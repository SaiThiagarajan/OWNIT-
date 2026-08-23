import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/buttons/secondary_button.dart';
import '../../../core/widgets/confidence_badge.dart';

/// Compares the reporter's own item against a candidate the AI flagged as a
/// possible match. Nothing here claims certainty — the CTA is "Claim this
/// item" (which hands off to ownership verification, not in scope yet),
/// never an assertion that the items are the same.
class PotentialMatchScreen extends StatelessWidget {
  const PotentialMatchScreen({super.key});

  void _claim(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Ownership verification is coming soon')),
      );
  }

  void _notAMatch(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text("Thanks — we'll keep looking")));
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Potential match'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s16),
              const ConfidenceBadge(percent: 92),
              const SizedBox(height: AppSpacing.s24),
              LayoutBuilder(
                builder: (context, constraints) {
                  const yourReport = _MatchCard(
                    label: 'YOUR REPORT',
                    icon: Icons.backpack_outlined,
                    accentColor: AppColors.lostCoral,
                    title: 'Blue backpack',
                    description: 'Navy blue backpack with a laptop pocket, lost near the library.',
                  );
                  const candidate = _MatchCard(
                    label: 'CANDIDATE / FOUND ITEM',
                    icon: Icons.backpack_outlined,
                    accentColor: AppColors.foundTeal,
                    title: 'Backpack, navy blue',
                    description: 'Found with a laptop inside, handed to front desk security.',
                  );

                  if (constraints.maxWidth < 360) {
                    return const Column(
                      children: [
                        yourReport,
                        SizedBox(height: AppSpacing.s16),
                        candidate,
                      ],
                    );
                  }

                  return const Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: yourReport),
                      SizedBox(width: AppSpacing.s16),
                      Expanded(child: candidate),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Column(
                  children: [
                    _InfoRow(label: 'Found near', value: 'Central library'),
                    const Divider(color: AppColors.border, height: AppSpacing.s24),
                    _InfoRow(label: 'Found on', value: 'Yesterday'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
              PrimaryButton(label: 'Claim this item', onPressed: () => _claim(context)),
              const SizedBox(height: AppSpacing.s12),
              SecondaryButton(label: 'Not a match', onPressed: () => _notAMatch(context)),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.description,
  });

  final String label;
  final IconData icon;
  final Color accentColor;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Container(
            height: 88,
            width: double.infinity,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
            ),
            child: Icon(icon, color: accentColor, size: 32),
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(title, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.s4),
          Text(
            description,
            style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        Text(value, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
