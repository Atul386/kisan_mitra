import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/database/app_database.dart';
import 'package:kisan_mitra/core/sync/sync_queue_repository.dart';
import 'package:kisan_mitra/features/auth/data/local_auth_repository.dart';
import 'package:kisan_mitra/features/mandi/data/local_mandi_repository.dart';
import 'package:kisan_mitra/features/mandi/domain/mandi_price.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('deleteAccount wipes local data and signs the farmer out', () async {
    final prefs = await SharedPreferences.getInstance();
    final syncQueue = SyncQueueRepository(db);
    final auth = LocalAuthRepository(db, prefs, syncQueue);

    final user = await auth.continueAsGuest();
    await auth.updateProfile(user.copyWith(name: 'Ramesh', village: 'Khed'));
    expect((await auth.currentUser())?.village, 'Khed');

    await LocalMandiRepository(db, syncQueue).addPrice(
      MandiPriceEntry(id: 'p1', farmId: 'f1', commodity: 'Soybean', price: 4600, date: DateTime.now()),
    );

    await auth.deleteAccount();

    expect(await auth.currentUser(), isNull);
    expect(await db.select(db.localUsers).get(), isEmpty);
    expect(await db.select(db.mandiPriceLogs).get(), isEmpty);
    expect(await db.select(db.syncQueueItems).get(), isEmpty);
  });
}
