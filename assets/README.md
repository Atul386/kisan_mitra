# Assets

Folders are pre-wired into `pubspec.yaml` (`flutter.assets`) so dropping a
file in here is enough — no pubspec edit needed for images/icons.

- **images/** — app logo, splash/onboarding illustrations, empty-state
  graphics.
- **icons/** — per-crop icons for `master_crops` (blueprint §15 —
  `MasterCrop.icon` in `lib/features/crop/domain/master_crop.dart` doesn't
  reference a real asset yet; wire it up here once icons exist).
- **fonts/** — not yet wired. `core/theme/app_theme.dart` already
  declares `Inter` (English) and `Noto Sans Devanagari` (Hindi/Marathi) as
  the intended `fontFamilyFallback` (blueprint §94), but until the actual
  `.ttf` files are added here and declared under `flutter.fonts` in
  `pubspec.yaml`, the app falls back to the system font — which still
  looks fine, so this isn't urgent.
