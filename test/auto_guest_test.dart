import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/database/app_database.dart';
import 'package:kisan_mitra/core/database/database_providers.dart';
import 'package:kisan_mitra/core/utils/shared_preferences_provider.dart';
import 'package:kisan_mitra/features/auth/auth_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('with login off, a guest is created on first launch and again after reset', () async {
    SharedPreferences.setMockInitialValues({});
    final db = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(await SharedPreferences.getInstance()),
      appDatabaseProvider.overrideWithValue(db),
    ]);
    addTearDown(() async {
      container.dispose();
      await db.close();
    });

    container.listen(autoGuestProvider, (_, __) {});
    container.listen(currentUserProvider, (_, __) {});
    Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 100));

    await settle();
    final first = container.read(currentUserProvider).value;
    expect(first, isNotNull);
    expect(first!.isGuest, isTrue);

    await container.read(authRepositoryProvider).deleteAccount();
    await settle();
    final second = container.read(currentUserProvider).value;
    expect(second, isNotNull);
    expect(second!.id, isNot(first.id));
    expect(await db.select(db.localUsers).get(), hasLength(1));
  });
}
