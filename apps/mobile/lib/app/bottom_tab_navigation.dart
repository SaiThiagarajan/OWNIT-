import 'package:flutter/material.dart';

import '../core/widgets/app_bottom_navigation.dart';
import 'router.dart';

/// Shared switching logic for the four main-tab screens (Home, History,
/// Messages, Profile), so each screen doesn't reimplement it.
///
/// Home is the base of this section of the stack: from Home, switching to
/// another tab is a [Navigator.pushNamed] (so Back returns to Home). From
/// any other tab, switching to a *different* tab replaces the current one
/// ([Navigator.pushReplacementNamed]) so the stack never grows past one tab
/// screen on top of Home — and switching back to Home pops until Home is
/// found, rather than pushing a second Home instance.
void handleBottomTabTap(BuildContext context, {required int currentIndex, required int tappedIndex}) {
  if (tappedIndex == currentIndex) return;

  if (tappedIndex == AppNavDestination.home.index) {
    Navigator.of(context).popUntil((route) => route.settings.name == AppRoutes.home);
    return;
  }

  final targetRoute = switch (AppNavDestination.values[tappedIndex]) {
    AppNavDestination.home => AppRoutes.home,
    AppNavDestination.history => AppRoutes.history,
    AppNavDestination.messages => AppRoutes.messages,
    AppNavDestination.profile => AppRoutes.profile,
  };

  if (currentIndex == AppNavDestination.home.index) {
    Navigator.of(context).pushNamed(targetRoute);
  } else {
    Navigator.of(context).pushReplacementNamed(targetRoute);
  }
}
