import 'package:flutter/material.dart';

import '../../../app/bottom_tab_navigation.dart';
import '../../../app/report_selection_sheet.dart';
import '../../../core/constants/item_categories.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/friendly_date.dart';
import '../../../core/widgets/app_bottom_navigation.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/report_fab.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/status_badge.dart';
import '../../reports/models/report.dart';
import '../../reports/models/report_store.dart';

/// Shows reports submitted this session (from [ReportStore] — in-memory
/// only, no backend yet).
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const _tabIndex = AppNavDestination.history;

  IconData _iconFor(String category) {
    for (final item in kItemCategories) {
      if (item.label == category) return item.icon;
    }
    return Icons.inventory_2_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final reports = ReportStore.all;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('History'),
      ),
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
        child: reports.isEmpty
            ? const Center(
                child: EmptyState(
                  icon: Icons.history,
                  title: 'No history yet',
                  message: 'Reports you\'ve submitted or resolved will show up here.',
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                itemCount: reports.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s12),
                itemBuilder: (context, index) {
                  final report = reports[index];
                  final accent =
                      report.type == ReportType.lost ? AppColors.lostCoral : AppColors.foundTeal;

                  return AppCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                          ),
                          child: Icon(_iconFor(report.category), color: accent, size: 22),
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                report.category,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: AppSpacing.s4),
                              Text(
                                '${report.type == ReportType.lost ? 'Lost' : 'Found'} near '
                                '${report.coarseLocation} · ${friendlyDate(report.createdAt)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: AppSpacing.s8),
                              StatusBadge(
                                label: report.statusLabel,
                                variant: report.type == ReportType.lost
                                    ? StatusBadgeVariant.lost
                                    : StatusBadgeVariant.found,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
