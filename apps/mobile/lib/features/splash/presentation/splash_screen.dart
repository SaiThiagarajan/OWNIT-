import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';

/// The app's true entry screen: mark, wordmark, tagline, and an explicit
/// "Get started" action — no auto-advancing timer. The user decides when
/// to move on, and pressing back here is the app root (exiting is
/// expected Android behavior).
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _getStarted(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.onboarding);
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
            children: [
              const Spacer(flex: 5),
              // The OWNIT mark: a letterform badge built from the brand's
              // own type and color tokens (no image asset or stock icon
              // exists yet for a dedicated logo graphic).
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: Text(
                  'O',
                  style: AppTypography.numeral(fontSize: 44, color: AppColors.onAccent),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Semantics(
                header: true,
                child: RichText(
                  text: TextSpan(
                    style: textTheme.displaySmall,
                    children: [
                      const TextSpan(text: 'OWN'),
                      TextSpan(text: 'IT', style: TextStyle(color: AppColors.orange)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              Text(
                'Lost something? Found something?\nLet\'s reunite it.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
              const Spacer(flex: 6),
              PrimaryButton(
                label: 'Get started',
                onPressed: () => _getStarted(context),
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
