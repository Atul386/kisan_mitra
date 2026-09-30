import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/analytics/firebase_analytics_service.dart';
import 'package:kisan_mitra/core/notifications/push_service.dart';
import 'package:kisan_mitra/core/sync/cloud_store.dart';
import 'package:kisan_mitra/core/sync/firestore_sync_specs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeMessaging implements PushMessaging {
  FakeMessaging({this.allowed = true, this.token = 'token-1'});

  bool allowed;
  String? token;
  final subscribed = <String>{};
  final unsubscribed = <String>[];
  final refresh = StreamController<String>.broadcast();
  final foreground = StreamController<({String? title, String? body})>.broadcast();

  @override
  Future<bool> requestPermission() async => allowed;
  @override
  Future<String?> getToken() async => token;
  @override
  Stream<String> get onTokenRefresh => refresh.stream;
  @override
  Future<void> subscribeToTopic(String topic) async => subscribed.add(topic);
  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    subscribed.remove(topic);
    unsubscribed.add(topic);
  }

  @override
  Stream<({String? title, String? body})> get onForegroundMessage => foreground.stream;
}

class MemoryStore implements CloudStore {
  final docs = <String, Json>{};
  @override
  Future<void> set(List<String> docPath, Json data) async => docs[docPath.join('/')] = Map.of(data);
  @override
  Future<Json?> get(List<String> docPath) async => docs[docPath.join('/')];
  @override
  Future<List<Json>> list(List<String> collectionPath) async => [];
}

void main() {
  late SharedPreferences prefs;
  late FakeMessaging messaging;
  late MemoryStore store;
  late List<(String, String)> shown;
  late PushService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    messaging = FakeMessaging();
    store = MemoryStore();
    shown = [];
    service = PushService(
      messaging: messaging,
      store: store,
      prefs: prefs,
      showForeground: (t, b) async => shown.add((t, b)),
      now: () => DateTime.fromMillisecondsSinceEpoch(1000),
    );
  });

  tearDown(() => service.dispose());

  test('registering saves the device token under the farmer\'s own preferences', () async {
    expect(await service.register('uid-1'), isTrue);
    expect(store.docs['users/uid-1/preferences/push'], {'token': 'token-1', 'updatedAt': 1000});
  });

  test('a refreshed token replaces the stored one', () async {
    await service.register('uid-1');
    messaging.refresh.add('token-2');
    await Future<void>.delayed(Duration.zero);
    expect(store.docs['users/uid-1/preferences/push']!['token'], 'token-2');
  });

  test('if notifications are declined nothing is registered', () async {
    messaging.allowed = false;
    expect(await service.register('uid-1'), isFalse);
    expect(store.docs, isEmpty);
    expect(messaging.subscribed, isEmpty);
  });

  test('by default only weather alerts are on; mandi and government updates need opt-in', () async {
    await service.register('uid-1');
    expect(messaging.subscribed, {'weather_alerts'});
    expect(service.isEnabled(PushTopic.weatherAlerts), isTrue);
    expect(service.isEnabled(PushTopic.mandiAlerts), isFalse);
    expect(service.isEnabled(PushTopic.governmentUpdates), isFalse);
  });

  test('switching a topic on and off subscribes and unsubscribes, and is remembered', () async {
    await service.register('uid-1');
    await service.setEnabled(PushTopic.mandiAlerts, true);
    expect(messaging.subscribed, containsAll(['weather_alerts', 'mandi_alerts']));
    expect(service.isEnabled(PushTopic.mandiAlerts), isTrue);

    await service.setEnabled(PushTopic.weatherAlerts, false);
    expect(messaging.subscribed, {'mandi_alerts'});

    // A new session honours the saved choices.
    final again = PushService(messaging: FakeMessaging(), store: store, prefs: prefs);
    expect(again.isEnabled(PushTopic.weatherAlerts), isFalse);
    expect(again.isEnabled(PushTopic.mandiAlerts), isTrue);
  });

  test('a message that arrives while the app is open is shown, one without a title is not', () async {
    await service.register('uid-1');
    messaging.foreground.add((title: 'Heavy rain tomorrow', body: 'Avoid spraying'));
    messaging.foreground.add((title: null, body: 'data only'));
    await Future<void>.delayed(Duration.zero);
    expect(shown, [('Heavy rain tomorrow', 'Avoid spraying')]);
  });

  test('analytics parameters are cleaned to what Firebase accepts', () {
    final clean = FirebaseAnalyticsService.sanitizeParameters({
      'cropId': 'onion',
      'count': 3,
      'price': 12.5,
      'offline': true,
      'skipped': null,
      'list': [1, 2],
    });
    expect(clean, {'cropId': 'onion', 'count': 3, 'price': 12.5, 'offline': 1, 'list': '[1, 2]'});
  });
}
