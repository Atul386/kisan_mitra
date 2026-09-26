import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/utils/shared_preferences_provider.dart';
import 'package:kisan_mitra/features/mandi/mandi_watchlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<ProviderContainer> makeContainer() async {
    final prefs = await SharedPreferences.getInstance();
    return ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
  }

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('favourites match commodity names case-insensitively and persist', () async {
    final container = await makeContainer();
    await container.read(mandiWatchlistProvider.notifier).toggleFavourite('Soybean');

    expect(container.read(mandiWatchlistProvider).isFavourite(' soybean '), isTrue);

    final reloaded = await makeContainer();
    expect(reloaded.read(mandiWatchlistProvider).isFavourite('SOYBEAN'), isTrue);

    await reloaded.read(mandiWatchlistProvider.notifier).toggleFavourite('soybean');
    expect(reloaded.read(mandiWatchlistProvider).isFavourite('Soybean'), isFalse);
  });

  test('price alerts can be set, persisted and removed', () async {
    final container = await makeContainer();
    await container.read(mandiWatchlistProvider.notifier).setAlert('Onion', 2500);

    final reloaded = await makeContainer();
    expect(reloaded.read(mandiWatchlistProvider).alertFor('onion'), 2500);

    await reloaded.read(mandiWatchlistProvider.notifier).setAlert('Onion', null);
    expect(reloaded.read(mandiWatchlistProvider).alertFor('Onion'), isNull);
  });

  test('clear removes favourites and alerts', () async {
    final container = await makeContainer();
    final watchlist = container.read(mandiWatchlistProvider.notifier);
    await watchlist.toggleFavourite('Wheat');
    await watchlist.setAlert('Wheat', 2800);
    await watchlist.clear();

    final reloaded = await makeContainer();
    expect(reloaded.read(mandiWatchlistProvider).favourites, isEmpty);
    expect(reloaded.read(mandiWatchlistProvider).alerts, isEmpty);
  });
}
