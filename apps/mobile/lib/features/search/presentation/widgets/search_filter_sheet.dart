import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/secondary_button.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../models/search_filters.dart';

/// Shows the Category/Location/Date filter sheet and resolves with the
/// user's chosen [SearchFilters], or null if they dismissed it without
/// applying.
Future<SearchFilters?> showSearchFilterSheet(BuildContext context, SearchFilters current) {
  return AppBottomSheet.show<SearchFilters>(
    context: context,
    title: 'Filters',
    builder: (context) => _SearchFilterSheetBody(initial: current),
  );
}

class _SearchFilterSheetBody extends StatefulWidget {
  const _SearchFilterSheetBody({required this.initial});

  final SearchFilters initial;

  @override
  State<_SearchFilterSheetBody> createState() => _SearchFilterSheetBodyState();
}

class _SearchFilterSheetBodyState extends State<_SearchFilterSheetBody> {
  late SearchFilters _filters = widget.initial;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterSection(
          title: 'Category',
          options: kSearchCategories,
          selected: _filters.category,
          onSelected: (value) => setState(() {
            _filters = _filters.category == value
                ? _filters.copyWith(clearCategory: true)
                : _filters.copyWith(category: value);
          }),
        ),
        const SizedBox(height: AppSpacing.s24),
        _FilterSection(
          title: 'Location',
          options: kSearchLocations,
          selected: _filters.location,
          onSelected: (value) => setState(() {
            _filters = _filters.location == value
                ? _filters.copyWith(clearLocation: true)
                : _filters.copyWith(location: value);
          }),
        ),
        const SizedBox(height: AppSpacing.s24),
        _FilterSection(
          title: 'Date',
          options: kSearchDateRanges,
          selected: _filters.dateRange,
          onSelected: (value) => setState(() {
            _filters = _filters.dateRange == value
                ? _filters.copyWith(clearDateRange: true)
                : _filters.copyWith(dateRange: value);
          }),
        ),
        const SizedBox(height: AppSpacing.s32),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: 'Clear filters',
                onPressed: _filters.isEmpty
                    ? null
                    : () => setState(() => _filters = SearchFilters.empty),
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: PrimaryButton(
                label: 'Apply filters',
                onPressed: () => Navigator.of(context).pop(_filters),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.labelMedium?.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.s8),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: options.map((option) {
            return CategoryChip(
              label: option,
              selected: selected == option,
              onTap: () => onSelected(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}
