import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/widgets/app_bottom_sheet.dart';
import 'router.dart';

/// The "What happened?" Lost/Found picker shown by the report FAB on every
/// main screen (Home, History, Messages, Profile). Both destinations are
/// the same routes the Home cards push directly — this is the one place
/// that decides where the FAB leads, so it isn't reimplemented per screen.
Future<void> showReportSelectionSheet(BuildContext context) {
  return AppBottomSheet.show(
    context: context,
    title: 'What happened?',
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.search_outlined, color: AppColors.lostCoral),
            title: const Text('I lost something'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(AppRoutes.lostReport);
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.volunteer_activism_outlined, color: AppColors.foundTeal),
            title: const Text('I found something'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(AppRoutes.foundReport);
            },
          ),
        ],
      );
    },
  );
}
