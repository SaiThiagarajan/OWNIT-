import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The single orange floating action button used app-wide to jump into
/// reporting a lost or found item. This is one of the few places orange is
/// used as a fill, per the spec.
class ReportFab extends StatelessWidget {
  const ReportFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Report a lost or found item',
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.onAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
