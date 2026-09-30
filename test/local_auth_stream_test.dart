import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/database/app_database.dart';
import 'package:kisan_mitra/core/sync/sync_queue_repository.dart';
import 'package:kisan_mitra/features/auth/data/local_auth_repository.dart';
import 'package:kisan_mitra/features/auth/domain/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late LocalAuthRepository auth;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
    auth = LocalAuthRepository(db, await SharedPreferences.getInstance(), SyncQueueRepository(db));
  });

  tearDown(() => db.close());

  test('watchCurrentUser follows guest sign-in, profile edits, sign-out and sign-in again', () async {
    final seen = <AppUser?>[];
    final sub = auth.watchCurrentUser().listen(seen.add);
    Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 50));

    await settle();
    expect(seen.last, isNull);

    final guest = await auth.continueAsGuest();
    await settle();
    expect(seen.last?.id, guest.id);

    await auth.updateProfile(guest.copyWith(name: 'Ramesh'));
    await settle();
    expect(seen.last?.name, 'Ramesh');

    await auth.signOut();
    await settle();
    expect(seen.last, isNull);

    final again = await auth.continueAsGuest();
    await settle();
    expect(seen.last?.id, again.id);

    await sub.cancel();
  });
}
