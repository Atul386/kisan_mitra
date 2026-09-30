import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/features/advisories/presentation/advisories_tab.dart';
import 'package:kisan_mitra/features/advisories/presentation/official_services_screen.dart';
import 'package:kisan_mitra/features/advisories/presentation/scheme_detail_screen.dart';
import 'package:kisan_mitra/features/advisories/presentation/schemes_screen.dart';
import 'package:kisan_mitra/features/crop_library/presentation/crop_detail_screen.dart';
import 'package:kisan_mitra/features/crop_library/presentation/crop_library_screen.dart';
import 'package:kisan_mitra/features/more/presentation/more_tab.dart';
import 'package:kisan_mitra/l10n/app_localizations.dart';

/// 360px-wide phone; tall enough that lazy lists build their last items.
Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
  tester.view.physicalSize = const Size(720, 3200);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: screen,
    ),
  ));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('advisories hub lists all five sections', (tester) async {
    await pumpScreen(tester, const AdvisoriesTab());
    for (final label in ['Weather', 'Crop advisories', 'Government schemes', 'Crop insurance', 'PM-KISAN']) {
      expect(find.text(label, skipOffstage: false), findsOneWidget);
    }
  });

  testWidgets('schemes list and detail show the official-portal disclaimer', (tester) async {
    await pumpScreen(tester, const SchemesScreen());
    expect(find.textContaining('MahaDBT'), findsWidgets);
    expect(find.textContaining('Final eligibility', skipOffstage: false), findsOneWidget);

    await pumpScreen(tester, const SchemeDetailScreen(schemeId: 'mahadbt'));
    expect(find.text('Who may be eligible'), findsOneWidget);
    expect(find.text('Apply on the official portal', skipOffstage: false), findsOneWidget);
  });

  testWidgets('PM-KISAN and insurance pages render', (tester) async {
    await pumpScreen(tester, const PmKisanScreen());
    expect(find.textContaining('never need to enter your Aadhaar', skipOffstage: false), findsOneWidget);
    await pumpScreen(tester, const InsuranceScreen());
    expect(find.text('Report crop loss', skipOffstage: false), findsOneWidget);
  });

  testWidgets('more tab has the expected entries', (tester) async {
    await pumpScreen(tester, const MoreTab());
    expect(find.text('Crop library'), findsOneWidget);
    expect(find.text('Profit calculator'), findsOneWidget);
    expect(find.text('Nearby services', skipOffstage: false), findsOneWidget);
  });

  testWidgets('crop library lists crops, searches, and opens detail', (tester) async {
    await pumpScreen(tester, const CropLibraryScreen());
    expect(find.text('Onion'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'soy');
    await tester.pumpAndSettle();
    expect(find.text('Soybean'), findsOneWidget);
    expect(find.text('Onion'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    expect(find.textContaining('No crops match'), findsOneWidget);

    await pumpScreen(tester, const CropDetailScreen(cropId: 'onion'));
    expect(find.text('Sowing period'), findsOneWidget);
    await tester.scrollUntilVisible(find.textContaining('General guidance only'), 400);
    expect(find.textContaining('General guidance only'), findsOneWidget);
  });
}
