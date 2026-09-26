import 'package:flutter/material.dart';

/// Typography scale per blueprint §94.
/// Font families are wired in [AppTheme] via `fontFamilyFallback` so
/// Devanagari (hi/mr) renders correctly without per-widget overrides.
class AppTextStyles {
  AppTextStyles._();

  static const pageTitle = TextStyle(fontSize: 24, fontWeight: FontWeight.w700);
  static const sectionTitle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const cardTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const body = TextStyle(fontSize: 15, fontWeight: FontWeight.w400);
  static const supporting = TextStyle(fontSize: 13, fontWeight: FontWeight.w400);
  static const button = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
}
