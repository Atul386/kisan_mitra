import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/error_reporter.dart';
import '../../../l10n/app_localizations.dart';
import '../auth_providers.dart';
import '../domain/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.length != 10) {
      final t = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.invalidPhoneNumberMessage)));
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref.read(authRepositoryProvider).sendOtp(phone);
      if (mounted) context.push('/otp/$phone');
    } on AuthNotConfiguredException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e, st) {
      reportError(e, st, context: 'sendOtp');
      if (mounted) showGenericErrorSnackBar(context);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _continueAsGuest() async {
    setState(() => _submitting = true);
    try {
      await ref.read(authRepositoryProvider).continueAsGuest();
      // Router redirect takes over once currentUserProvider emits.
    } catch (e, st) {
      reportError(e, st, context: 'continueAsGuest');
      if (mounted) showGenericErrorSnackBar(context);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset('assets/icons/app_icon.png', width: 64, height: 64),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.eco_rounded, color: AppColors.primary, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    t.loginTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                t.loginHeading,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(t.loginSubtitle, style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Text('+91', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      autofillHints: const [],
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(hintText: t.phoneNumberLabel),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _phoneController,
                builder: (context, value, _) {
                  final isValid = value.text.length == 10;
                  return ElevatedButton(
                    onPressed: _submitting || !isValid ? null : _sendOtp,
                    child: Text(t.sendOtp),
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(children: [
                const Expanded(child: Divider()),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(t.orDivider)),
                const Expanded(child: Divider()),
              ]),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: _submitting ? null : _continueAsGuest,
                child: Text(t.continueAsGuest),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
