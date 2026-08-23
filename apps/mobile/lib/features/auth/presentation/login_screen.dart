import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/inputs/app_text_field.dart';

/// Phone-number entry. Validation here is local/UI-only — no network call
/// is made; a brief simulated delay demonstrates the loading state ahead
/// of the real API being wired up later.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  String? _errorText;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool _isValidPhone(String value) => RegExp(r'^\d{7,15}$').hasMatch(value);

  Future<void> _continue() async {
    final phone = _phoneController.text.trim();
    if (!_isValidPhone(phone)) {
      setState(() => _errorText = 'Enter a valid phone number');
      return;
    }

    setState(() {
      _errorText = null;
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    setState(() => _isSubmitting = false);
    Navigator.of(context).pushNamed(AppRoutes.otp, arguments: OtpScreenArgs(phoneNumber: phone));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s48),
              Text('Welcome to OWNIT', style: textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'Enter your phone number to sign in or create an account.',
                style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s32),
              AppTextField(
                label: 'Phone number',
                hintText: '5551234567',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                errorText: _errorText,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                  child: Icon(Icons.phone_outlined, color: AppColors.textSecondary),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Continue',
                onPressed: _isSubmitting ? null : _continue,
                isLoading: _isSubmitting,
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
