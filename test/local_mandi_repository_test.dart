import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/database/app_database.dart';
import 'package:kisan_mitra/core/sync/sync_queue_repository.dart';
import 'package:kisan_mitra/features/mandi/data/local_mandi_repository.dart';
import 'package:kisan_mitra/features/mandi/domain/mandi_price.dart';

void main() {
  late AppDatabase db;
  late LocalMandiRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = LocalMandiRepository(db, SyncQueueRepository(db));
  });

  tearDown(() => db.close());

  test('watchPrices returns entries newest first', () async {
    await repo.addPrice(
      MandiPriceEntry(
        id: '1',
        farmId: 'farm1',
        commodity: 'Soybean',
        price: 4610,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    );
    await repo.addPrice(
      MandiPriceEntry(id: '2', farmId: 'farm1', commodity: 'Soybean', price: 4720, date: DateTime.now()),
    );

    final prices = await repo.watchPrices(farmId: 'farm1').first;
    expect(prices.map((e) => e.price), [4720, 4610]);
  });

  test('filtering by commodity excludes other commodities', () async {
    await repo.addPrice(
      MandiPriceEntry(id: '1', farmId: 'farm1', commodity: 'Soybean', price: 4720, date: DateTime.now()),
    );
    await repo.addPrice(
      MandiPriceEntry(id: '2', farmId: 'farm1', commodity: 'Cotton', price: 7200, date: DateTime.now()),
    );

    final soybeanOnly = await repo.watchPrices(farmId: 'farm1', commodity: 'Soybean').first;
    expect(soybeanOnly, hasLength(1));
    expect(soybeanOnly.single.commodity, 'Soybean');
  });
}
