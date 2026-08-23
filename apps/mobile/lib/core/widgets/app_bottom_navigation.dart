import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Destinations shown in [AppBottomNavigation]. The report action sits in
/// the notch between [history] and [messages] and is not an index here —
/// it's driven by [ReportFab] via the Scaffold's `floatingActionButton`.
enum AppNavDestination { home, history, messages, profile }

/// The app-level bottom navigation bar: four tabs with a notch in the
/// middle for a docked, raised [ReportFab]. Pair it with
/// `floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked`
/// on the same [Scaffold] so the FAB sits in the notch this bar cuts out.
///
/// Built on [BottomAppBar]'s notched-shape support rather than Material's
/// default [NavigationBar] — the raised center FAB and rounded lower
/// corners are core to OWNIT's identity and don't come for free otherwise.
class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _radius = Radius.circular(24);

  /// Comfortable height for the nav item content itself (icon + label +
  /// vertical padding), not counting the system bottom inset.
  static const _contentHeight = 64.0;

  @override
  Widget build(BuildContext context) {
    // BottomAppBar wraps its child in its own SafeArea internally, so it
    // already consumes the system bottom inset on its own — the inset must
    // only be spent here, once, to grow the bar's total height. Adding it
    // again into the padding would double-count it and starve the content
    // of vertical space (this is what caused the 24px overflow).
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.only(bottomLeft: _radius, bottomRight: _radius),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: BottomAppBar(
          color: AppColors.surfaceElevated,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: const CircularNotchedRectangle(),
          notchMargin: AppSpacing.s8,
          height: _contentHeight + bottomInset,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s8),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: 'Home',
                  selected: currentIndex == AppNavDestination.home.index,
                  onTap: () => onDestinationSelected(AppNavDestination.home.index),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.history_outlined,
                  selectedIcon: Icons.history,
                  label: 'History',
                  selected: currentIndex == AppNavDestination.history.index,
                  onTap: () => onDestinationSelected(AppNavDestination.history.index),
                ),
              ),
              const SizedBox(width: 56),
              Expanded(
                child: _NavItem(
                  icon: Icons.chat_bubble_outline,
                  selectedIcon: Icons.chat_bubble,
                  label: 'Messages',
                  selected: currentIndex == AppNavDestination.messages.index,
                  onTap: () => onDestinationSelected(AppNavDestination.messages.index),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  label: 'Profile',
                  selected: currentIndex == AppNavDestination.profile.index,
                  onTap: () => onDestinationSelected(AppNavDestination.profile.index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.orange : AppColors.textSecondary;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSpacing.minTapTarget),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(selected ? selectedIcon : icon, color: color, size: 22),
              const SizedBox(height: 2),
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
