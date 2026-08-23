import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/category_chip.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/state_views.dart';
import '../models/mock_report.dart';
import '../models/search_filters.dart';
import 'report_detail_screen.dart';
import 'widgets/search_filter_sheet.dart';
import 'widgets/search_result_card.dart';

enum _SearchState { initial, loading, results, empty, error }

/// Discovering public lost/found reports. Never surfaces phone numbers,
/// exact addresses, or other private details — only coarse location, per
/// the same privacy rule the report flows follow.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  _SearchState _state = _SearchState.initial;
  ReportKind? _quickFilter;
  SearchFilters _filters = SearchFilters.empty;
  List<MockReport> _results = const [];

  final List<String> _recentSearches = ['black wallet', 'AirPods', 'blue backpack'];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _runSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    _controller.text = trimmed;
    _focusNode.unfocus();
    setState(() {
      _recentSearches.remove(trimmed);
      _recentSearches.insert(0, trimmed);
      if (_recentSearches.length > 5) _recentSearches.removeLast();
      _state = _SearchState.loading;
    });

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    // Typing "fail" is a deliberate, reachable way to demo the error state
    // for a purely local mock search that otherwise can't fail.
    if (trimmed.toLowerCase().contains('fail')) {
      setState(() => _state = _SearchState.error);
      return;
    }

    final results = searchMockReports(trimmed, kind: _quickFilter).where((report) {
      final matchesCategory = _filters.category == null || report.category == _filters.category;
      final matchesLocation =
          _filters.location == null || report.coarseLocation == _filters.location;
      return matchesCategory && matchesLocation;
    }).toList();

    setState(() {
      _results = results;
      _state = results.isEmpty ? _SearchState.empty : _SearchState.results;
    });
  }

  void _removeRecentSearch(String query) {
    setState(() => _recentSearches.remove(query));
  }

  Future<void> _openFilters() async {
    final result = await showSearchFilterSheet(context, _filters);
    if (result == null) return;
    setState(() => _filters = result);
    if (_controller.text.trim().isNotEmpty) {
      unawaited(_runSearch(_controller.text));
    }
  }

  void _setQuickFilter(ReportKind? kind) {
    setState(() => _quickFilter = kind);
    if (_controller.text.trim().isNotEmpty) {
      unawaited(_runSearch(_controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Search'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.s8,
                AppSpacing.screenHorizontal,
                AppSpacing.s16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SearchBar(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: _runSearch,
                    onClear: () => setState(() {
                      _controller.clear();
                      _state = _SearchState.initial;
                    }),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              CategoryChip(
                                label: 'All',
                                selected: _quickFilter == null,
                                onTap: () => _setQuickFilter(null),
                              ),
                              const SizedBox(width: AppSpacing.s8),
                              CategoryChip(
                                label: 'Lost',
                                selected: _quickFilter == ReportKind.lost,
                                onTap: () => _setQuickFilter(ReportKind.lost),
                              ),
                              const SizedBox(width: AppSpacing.s8),
                              CategoryChip(
                                label: 'Found',
                                selected: _quickFilter == ReportKind.found,
                                onTap: () => _setQuickFilter(ReportKind.found),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s8),
                      _FilterButton(activeCount: _filters.activeCount, onTap: _openFilters),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_state) {
      case _SearchState.initial:
        return _InitialState(
          recentSearches: _recentSearches,
          onTapRecent: _runSearch,
          onRemoveRecent: _removeRecentSearch,
        );
      case _SearchState.loading:
        return const _LoadingResults();
      case _SearchState.results:
        return _ResultsList(results: _results, onOpenReport: _openReport);
      case _SearchState.empty:
        return const EmptyState(
          icon: Icons.search_off_outlined,
          title: 'No matching reports yet',
          message: 'Try a broader search or adjust your filters.',
        );
      case _SearchState.error:
        return ErrorState(
          title: "Couldn't load search results",
          actionLabel: 'Retry',
          onAction: () => _runSearch(_controller.text),
        );
    }
  }

  void _openReport(MockReport report) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ReportDetailScreen(report: report)),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      textField: true,
      label: 'Search for an item',
      child: SizedBox(
        height: AppSpacing.controlHeight,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.search,
          style: textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: 'Search for an item...',
            prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return Semantics(
                  button: true,
                  label: 'Clear search',
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 18),
                    onPressed: onClear,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.activeCount, required this.onTap});

  final int activeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = activeCount > 0;

    return Semantics(
      button: true,
      label: active ? 'Filters, $activeCount active' : 'Filters',
      child: Material(
        color: active ? AppColors.orange.withValues(alpha: 0.12) : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          child: Container(
            width: AppSpacing.controlHeight,
            height: AppSpacing.controlHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
              border: Border.all(color: active ? AppColors.orange : AppColors.border),
            ),
            child: Icon(
              Icons.tune,
              color: active ? AppColors.orange : AppColors.textSecondary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _InitialState extends StatelessWidget {
  const _InitialState({
    required this.recentSearches,
    required this.onTapRecent,
    required this.onRemoveRecent,
  });

  final List<String> recentSearches;
  final ValueChanged<String> onTapRecent;
  final ValueChanged<String> onRemoveRecent;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      children: [
        if (recentSearches.isNotEmpty) ...[
          Text('Recent searches', style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.s8),
          for (final query in recentSearches)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history, color: AppColors.textSecondary),
              title: Text(query, style: textTheme.bodyMedium),
              trailing: Semantics(
                button: true,
                label: 'Remove "$query" from recent searches',
                child: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textTertiary, size: 18),
                  onPressed: () => onRemoveRecent(query),
                ),
              ),
              onTap: () => onTapRecent(query),
            ),
          const SizedBox(height: AppSpacing.s24),
        ],
        Text(
          "Search for something you've lost or found.",
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s32),
      ],
    );
  }
}

class _LoadingResults extends StatelessWidget {
  const _LoadingResults();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.s8,
      ),
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s16),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LoadingSkeleton(height: 96, borderRadius: AppSpacing.radiusControl),
              const SizedBox(height: AppSpacing.s12),
              const LoadingSkeleton(width: 160, height: 14),
              const SizedBox(height: AppSpacing.s8),
              const LoadingSkeleton(width: 120, height: 12),
            ],
          ),
        );
      },
    );
  }
}

class _ResultsList extends StatelessWidget {
  const _ResultsList({required this.results, required this.onOpenReport});

  final List<MockReport> results;
  final ValueChanged<MockReport> onOpenReport;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.s8,
      ),
      itemCount: results.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s16),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Text(
            'Potentially relevant reports (${results.length})',
            style: textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
          );
        }
        final report = results[index - 1];
        return SearchResultCard(report: report, onTap: () => onOpenReport(report));
      },
    );
  }
}
