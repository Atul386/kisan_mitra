import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sync/cloud_store.dart';
import '../utils/error_reporter.dart';

/// The kinds of server-sent notification. Kept few on purpose — only
/// important alerts, each one switchable by the farmer.
enum PushTopic {
  weatherAlerts('weather_alerts', 'push_weather_alerts'),
  mandiAlerts('mandi_alerts', 'push_mandi_alerts'),
  governmentUpdates('govt_updates', 'push_govt_updates');

  const PushTopic(this.fcmTopic, this.prefsKey);

  /// Topic name the server publishes to.
  final String fcmTopic;
  final String prefsKey;
}

/// What [PushService] needs from Firebase Cloud Messaging.
abstract class PushMessaging {
  /// True if the farmer allowed notifications.
  Future<bool> requestPermission();
  Future<String?> getToken();
  Stream<String> get onTokenRefresh;
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);

  /// Messages that arrive while the app is open (the system only shows
  /// notifications itself when the app is in the background).
  Stream<({String? title, String? body})> get onForegroundMessage;
}

class FirebasePushMessaging implements PushMessaging {
  FirebasePushMessaging(this._messaging);

  final FirebaseMessaging _messaging;

  @override
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<String?> getToken() => _messaging.getToken();

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Future<void> subscribeToTopic(String topic) => _messaging.subscribeToTopic(topic);

  @override
  Future<void> unsubscribeFromTopic(String topic) => _messaging.unsubscribeFromTopic(topic);

  @override
  Stream<({String? title, String? body})> get onForegroundMessage =>
      FirebaseMessaging.onMessage.map((m) => (title: m.notification?.title, body: m.notification?.body));
}

/// Registers this phone for push notifications for a signed-in farmer:
/// stores the device token under `users/{uid}/preferences/push` (so the
/// server can target them) and keeps the per-topic subscriptions in step
/// with the farmer's switches. Sending notifications is a server job
/// (Cloud Functions), not something the app does.
class PushService {
  PushService({
    required this.messaging,
    required this.store,
    required this.prefs,
    this.showForeground,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final PushMessaging messaging;
  final CloudStore store;
  final SharedPreferences prefs;

  /// Shows a message that arrived while the app was open.
  final Future<void> Function(String title, String body)? showForeground;
  final DateTime Function() _now;

  StreamSubscription<String>? _tokenSub;
  StreamSubscription<({String? title, String? body})>? _messageSub;

  /// Weather alerts are on by default; the others need the farmer's opt-in.
  bool isEnabled(PushTopic topic) => prefs.getBool(topic.prefsKey) ?? topic == PushTopic.weatherAlerts;

  Future<void> setEnabled(PushTopic topic, bool enabled) async {
    await prefs.setBool(topic.prefsKey, enabled);
    if (enabled) {
      await messaging.subscribeToTopic(topic.fcmTopic);
    } else {
      await messaging.unsubscribeFromTopic(topic.fcmTopic);
    }
  }

  /// Returns false when the farmer declined notifications (nothing is
  /// registered then).
  Future<bool> register(String uid) async {
    if (!await messaging.requestPermission()) return false;

    final token = await messaging.getToken();
    if (token != null) await _saveToken(uid, token);

    await _tokenSub?.cancel();
    _tokenSub = messaging.onTokenRefresh.listen((t) async {
      try {
        await _saveToken(uid, t);
      } catch (e, st) {
        reportError(e, st, context: 'push.tokenRefresh');
      }
    });

    for (final topic in PushTopic.values) {
      if (isEnabled(topic)) {
        await messaging.subscribeToTopic(topic.fcmTopic);
      } else {
        await messaging.unsubscribeFromTopic(topic.fcmTopic);
      }
    }

    await _messageSub?.cancel();
    final show = showForeground;
    if (show != null) {
      _messageSub = messaging.onForegroundMessage.listen((m) {
        final title = m.title;
        if (title != null) show(title, m.body ?? '');
      });
    }
    return true;
  }

  Future<void> dispose() async {
    await _tokenSub?.cancel();
    await _messageSub?.cancel();
  }

  Future<void> _saveToken(String uid, String token) {
    return store.set(['users', uid, 'preferences', 'push'], {
      'token': token,
      'updatedAt': _now().millisecondsSinceEpoch,
    });
  }
}
