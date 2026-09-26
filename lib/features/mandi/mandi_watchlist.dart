import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/localization/locale_controller.dart';
import '../../core/notifications/notification_providers.dart';
import '../../core/utils/shared_preferences_provider.dart';
import '../../l10n/app_localizations.dart';
import 'mandi_providers.dart';

const _favouritesKey = 'mandi_favourites';
const _alertsKey = 'mandi_price_alerts';
const _alertNotificationBaseId = 910000;

/// Commodity names come from two sources (farmer-typed and Agmarknet), so
/// they're compared case- and whitespace-insensitively.
String commodityKey(String commodity) => commodity.trim().toLowerCase();

class MandiWatchlist {
  const MandiWatchlist({this.favourites = const {}, this.alerts = const {}});

  /// [commodityKey]s the farmer starred.
  final Set<String> favourites;

  /// [commodityKey] → target price (₹ per quintal). One-shot: removed once
  /// it fires so the farmer isn't notified again for every later entry.
  final Map<String, double> alerts;

  bool isFavourite(String commodity) => favourites.contains(commodityKey(commodity));
  double? alertFor(String commodity) => alerts[commodityKey(commodity)];
}

/// Per-device preference, not farm data — kept in SharedPreferences rather
/// than the synced database.
class MandiWatchlistController extends Notifier<MandiWatchlist> {
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  MandiWatchlist build() {
    final favourites = _prefs.getStringList(_favouritesKey)?.toSet() ?? {};
    final rawAlerts = _prefs.getString(_alertsKey);
    final alerts = rawAlerts == null
        ? <String, double>{}
        : (jsonDecode(rawAlerts) as Map<String, dynamic>).map((k, v) => MapEntry(k, (v as num).toDouble()));
    return MandiWatchlist(favourites: favourites, alerts: alerts);
  }

  Future<void> toggleFavourite(String commodity) async {
    final key = commodityKey(commodity);
    final favourites = {...state.favourites};
    if (!favourites.remove(key)) favourites.add(key);
    state = MandiWatchlist(favourites: favourites, alerts: state.alerts);
    await _prefs.setStringList(_favouritesKey, favourites.toList());
  }

  Future<void> clear() async {
    state = const MandiWatchlist();
    await _prefs.remove(_favouritesKey);
    await _prefs.remove(_alertsKey);
  }

  Future<void> setAlert(String commodity, double? targetPrice) async {
    final alerts = {...state.alerts};
    if (targetPrice == null) {
      alerts.remove(commodityKey(commodity));
    } else {
      alerts[commodityKey(commodity)] = targetPrice;
    }
    state = MandiWatchlist(favourites: state.favourites, alerts: alerts);
    await _prefs.setString(_alertsKey, jsonEncode(alerts));
  }
}

final mandiWatchlistProvider = NotifierProvider<MandiWatchlistController, MandiWatchlist>(
  MandiWatchlistController.new,
);

/// Watched from the app root so alerts fire whichever screen the farmer is
/// on. Re-runs whenever logged prices, live prices or the alert list change.
final mandiPriceAlertCheckerProvider = FutureProvider<void>((ref) async {
  final alerts = ref.watch(mandiWatchlistProvider).alerts;
  if (alerts.isEmpty) return;

  final latestByCommodity = <String, (String, double)>{};
  void consider(String commodity, double price) {
    final key = commodityKey(commodity);
    final current = latestByCommodity[key];
    if (current == null || price > current.$2) latestByCommodity[key] = (commodity, price);
  }

  for (final trend in ref.watch(mandiTrendsProvider)) {
    consider(trend.latest.commodity, trend.latest.price);
  }
  for (final live in ref.watch(liveMandiPricesProvider).value ?? const []) {
    consider(live.commodity, live.modalPrice);
  }

  final t = lookupAppLocalizations(ref.read(localeControllerProvider).value ?? const Locale('en'));
  final notifications = ref.read(notificationServiceProvider);
  final watchlist = ref.read(mandiWatchlistProvider.notifier);

  for (final MapEntry(key: key, value: target) in alerts.entries) {
    final hit = latestByCommodity[key];
    if (hit == null || hit.$2 < target) continue;
    final (commodity, price) = hit;
    final priceText = price.toStringAsFixed(0);
    await notifications.showNow(
      id: _alertNotificationBaseId + key.hashCode.abs() % 10000,
      title: t.priceAlertNotificationTitle(commodity),
      body: t.priceAlertNotificationBody(commodity, priceText),
    );
    await watchlist.setAlert(commodity, null);
  }
});
