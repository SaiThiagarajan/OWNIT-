import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/confidence_badge.dart';

/// Arguments passed to [AppRoutes.aiResult].
class AiResultScreenArgs {
  const AiResultScreenArgs({
    required this.category,
    required this.description,
    required this.confidence,
    required this.hasMatch,
  });

  final String category;
  final String description;
  final int confidence;
  final bool hasMatch;
}

/// Shows what the AI made of a submitted report. Always frames this as
/// assistance, never as fact — "potential match", never "this is your
/// item" — and has a clear no-match path too.
class AiResultScreen extends StatelessWidget {
  const AiResultScreen({super.key, required this.args});

  final AiResultScreenArgs args;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('AI analysis'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s16),
              Container(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                decoration: BoxDecoration(
                  color: AppColors.foundTint,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  border: Border.all(color: AppColors.foundTeal.withValues(alpha: 0.35)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, size: 16, color: AppColors.foundTeal),
                        const SizedBox(width: AppSpacing.s8),
                        Text(
                          'AI INSIGHT',
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.foundTeal,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s20),
                    Text('Category', style: textTheme.labelMedium?.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: AppSpacing.s4),
                    Text(args.category, style: textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.s16),
                    Text('Confidence', style: textTheme.labelMedium?.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: AppSpacing.s8),
                    ConfidenceBadge(percent: args.confidence, label: '${args.confidence}%'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              if (args.hasMatch) ...[
                Text('Potential match found', style: textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  "This is an AI suggested match, not a confirmed one. You'll need to verify ownership before any contact details are shared.",
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.s24),
                PrimaryButton(
                  label: 'View potential match',
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.potentialMatch),
                ),
              ] else ...[
                Text('No match yet', style: textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  "We'll notify you when something relevant appears.",
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
              ],
              const SizedBox(height: AppSpacing.s32),
            ],
          ),
        ),
      ),
    );
  }
}
