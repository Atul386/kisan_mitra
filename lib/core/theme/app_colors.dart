import 'package:flutter/material.dart';

/// KisanMitra 360 brand palette.
/// See blueprint §83-91 for rationale and usage rules.
class AppColors {
  AppColors._();

  // Greens
  static const primary = Color(0xFF2E7D32);
  static const primaryDark = Color(0xFF1B5E20);
  static const primaryLight = Color(0xFFE8F5E9);

  // Soil
  static const soil = Color(0xFF795548);
  static const soilLight = Color(0xFFEFEBE9);

  // Harvest yellow (warning / due-soon)
  static const warning = Color(0xFFF9A825);
  static const warningLight = Color(0xFFFFF8E1);

  // Weather blue
  static const weather = Color(0xFF1976D2);
  static const weatherLight = Color(0xFFE3F2FD);

  // Alert red (critical only)
  static const error = Color(0xFFD32F2F);
  static const errorLight = Color(0xFFFFEBEE);

  // Neutrals (light theme)
  static const background = Color(0xFFF7F8F4);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  static const disabled = Color(0xFFBDBDBD);

  // Information (neutral status)
  static const info = Color(0xFF546E7A);

  // Dark theme
  static const darkBackground = Color(0xFF121812);
  static const darkSurface = Color(0xFF1B241B);
  static const darkPrimary = Color(0xFF66BB6A);
  static const darkTextSecondary = Color(0xFFB0B8B0);
  static const darkTextPrimary = Color(0xFFF4F6F4);
  static const darkBorder = Color(0xFF344034);
  static const darkWarning = Color(0xFFFBC02D);
  static const darkError = Color(0xFFEF5350);
  static const darkWeather = Color(0xFF64B5F6);
}

/// Farm/crop health status colors, always paired with an icon/label (§90).
enum HealthStatus { good, needsAttention, critical }

extension HealthStatusColor on HealthStatus {
  Color get color {
    switch (this) {
      case HealthStatus.good:
        return AppColors.primary;
      case HealthStatus.needsAttention:
        return AppColors.warning;
      case HealthStatus.critical:
        return AppColors.error;
    }
  }
}
