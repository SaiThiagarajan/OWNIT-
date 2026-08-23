import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/inputs/otp_input.dart';
import '../../../core/widgets/state_views.dart';

enum _OtpStatus { entering, verifying, success }

/// OTP verification. There is no backend yet, so any complete 6-digit code
/// is treated as valid — this screen only proves out the UI states
/// (entering / verifying / success) and the resend-timer interaction.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const _resendSeconds = 30;

  _OtpStatus _status = _OtpStatus.entering;
  Timer? _timer;
  int _secondsRemaining = _resendSeconds;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = _resendSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining <= 1) {
        setState(() => _secondsRemaining = 0);
        timer.cancel();
      } else {
        setState(() => _secondsRemaining -= 1);
      }
    });
  }

  void _resend() {
    if (_secondsRemaining > 0) return;
    _startTimer();
  }

  Future<void> _onCompleted(String code) async {
    setState(() => _status = _OtpStatus.verifying);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _status = _OtpStatus.success);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: _status == _OtpStatus.success
              ? const SuccessState(
                  title: 'Verified',
                  message: 'Taking you to OWNIT...',
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.s24),
                    Text('Enter the code', style: textTheme.headlineSmall),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      'We sent a 6-digit code to ${widget.phoneNumber}',
                      style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.s32),
                    IgnorePointer(
                      ignoring: _status == _OtpStatus.verifying,
                      child: OtpInput(onCompleted: _onCompleted),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    if (_status == _OtpStatus.verifying)
                      Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: AppSpacing.s8),
                          Text(
                            'Verifying...',
                            style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      )
                    else
                      _ResendRow(
                        secondsRemaining: _secondsRemaining,
                        onResend: _resend,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ResendRow extends StatelessWidget {
  const _ResendRow({required this.secondsRemaining, required this.onResend});

  final int secondsRemaining;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final canResend = secondsRemaining == 0;

    return Row(
      children: [
        Text(
          "Didn't get a code? ",
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        Semantics(
          button: true,
          enabled: canResend,
          label: canResend ? 'Resend code' : 'Resend available in $secondsRemaining seconds',
          child: GestureDetector(
            onTap: canResend ? onResend : null,
            child: Text(
              canResend ? 'Resend' : 'Resend in ${secondsRemaining}s',
              style: textTheme.bodyMedium?.copyWith(
                color: canResend ? AppColors.orange : AppColors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
