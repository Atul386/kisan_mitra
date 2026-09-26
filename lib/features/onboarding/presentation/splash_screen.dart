import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Continues the native splash (same background + glyph) so there's no
/// visible jump while the router decides where to go.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(
        child: Image.asset('assets/images/splash_icon.png', width: 240, height: 240),
      ),
    );
  }
}
