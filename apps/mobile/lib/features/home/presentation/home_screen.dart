import 'package:flutter/material.dart';

import '../../../app/bottom_tab_navigation.dart';
import '../../../app/report_selection_sheet.dart';
import '../../../app/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_bottom_navigation.dart';
import '../../../core/widgets/report_fab.dart';
import '../../../core/widgets/status_badge.dart';
import 'widgets/primary_action_card.dart';

class _MockActiveReport {
  const _MockActiveReport({
    required this.title,
    required this.icon,
    required this.variant,
    required this.statusLabel,
    required this.accentColor,
  });

  final String title;
  final IconData icon;
  final StatusBadgeVariant variant;
  final String statusLabel;
  final Color accentColor;
}

const _mockActiveReports = [
  _MockActiveReport(
    title: 'Blue backpack',
    icon: Icons.backpack_outlined,
    variant: StatusBadgeVariant.lost,
    statusLabel: 'Lost',
    accentColor: AppColors.lostCoral,
  ),
  _MockActiveReport(
    title: 'White earbuds',
    icon: Icons.devices_other_outlined,
    variant: StatusBadgeVariant.matched,
    statusLabel: 'Matched',
    accentColor: AppColors.foundTeal,
  ),
  _MockActiveReport(
    title: 'House keys',
    icon: Icons.key_outlined,
    variant: StatusBadgeVariant.pending,
    statusLabel: 'Pending',
    accentColor: AppColors.textSecondary,
  ),
];

/// Home answers "what happened?" immediately: two equal-weight actions for
/// reporting a lost or found item, an active-reports carousel, and the
/// docked report FAB.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _tabIndex = AppNavDestination.home;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: ReportFab(onPressed: () => showReportSelectionSheet(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _tabIndex.index,
        onDestinationSelected: (index) => handleBottomTabTap(
          context,
          currentIndex: _tabIndex.index,
          tappedIndex: index,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('What happened?', style: textTheme.headlineSmall),
                  ),
                  _SearchButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.search),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'Tell us what\'s going on and we\'ll take it from there.',
                style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final actions = [
                    PrimaryActionCard(
                      label: 'I LOST SOMETHING',
                      description: 'Report a missing item',
                      icon: Icons.search_outlined,
                      accentColor: AppColors.lostCoral,
                      tintColor: AppColors.lostTint,
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.lostReport),
                    ),
                    PrimaryActionCard(
                      label: 'I FOUND SOMETHING',
                      description: 'Help return it to its owner',
                      icon: Icons.volunteer_activism_outlined,
                      accentColor: AppColors.foundTeal,
                      tintColor: AppColors.foundTint,
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.foundReport),
                    ),
                  ];

                  if (constraints.maxWidth < 340) {
                    return Column(
                      children: [
                        actions[0],
                        const SizedBox(height: AppSpacing.s16),
                        actions[1],
                      ],
                    );
                  }

                  // IntrinsicHeight gives the Row a bounded height (from its
                  // children's own intrinsic height) so `stretch` has
                  // something finite to stretch to — the Row is inside a
                  // scrollable Column, which otherwise hands it unbounded
                  // (infinite) height and crashes the stretch layout.
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: actions[0]),
                        const SizedBox(width: AppSpacing.s16),
                        Expanded(child: actions[1]),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.s32),
              Text('Active reports', style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.s16),
              const _ActiveReportsCarousel(reports: _mockActiveReports),
              const SizedBox(height: AppSpacing.s32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveReportsCarousel extends StatelessWidget {
  const _ActiveReportsCarousel({required this.reports});

  final List<_MockActiveReport> reports;

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return Text(
        'No active reports yet.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
      );
    }

    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: reports.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s12),
        itemBuilder: (context, index) {
          final report = reports[index];
          final textTheme = Theme.of(context).textTheme;
          return Container(
            width: 168,
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: report.accentColor.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(report.icon, size: 18, color: report.accentColor),
                ),
                const Spacer(),
                Text(
                  report.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.s8),
                StatusBadge(label: report.statusLabel, variant: report.variant),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Search',
      child: Material(
        color: AppColors.surfaceElevated,
        shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: const SizedBox(
            width: AppSpacing.minTapTarget,
            height: AppSpacing.minTapTarget,
            child: Icon(Icons.search, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
    );
  }
}
