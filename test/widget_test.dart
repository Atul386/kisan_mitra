import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kisan_mitra/app/app.dart';
import 'package:kisan_mitra/app/router.dart';
import 'package:kisan_mitra/core/utils/shared_preferences_provider.dart';

void main() {
  testWidgets('App boots to the expected first screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const KisanMitraApp(),
      ),
    );
    await tester.pumpAndSettle();

    // kSkipOnboardingForDev (app/router.dart) is a temporary flag that
    // sends first launch straight to the dashboard instead of the normal
    // language -> login -> profile -> farm flow; this test follows
    // whichever behavior is currently active rather than fighting it.
    if (kSkipOnboardingForDev) {
      expect(find.text('KisanMitra 360'), findsOneWidget);
    } else {
      expect(find.text('Choose your language'), findsOneWidget);
    }
  });
}
