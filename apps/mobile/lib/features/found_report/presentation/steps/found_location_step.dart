import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/location_datetime_step.dart';
import '../../models/found_report_draft.dart';

class FoundLocationStep extends StatelessWidget {
  const FoundLocationStep({super.key, required this.draft, required this.onChanged});

  final FoundReportDraft draft;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return LocationDateTimeStep(
      title: 'Where and when did you find it?',
      subtitle: 'Your exact location is never shown publicly.',
      accentColor: AppColors.foundTeal,
      initialLocation: draft.locationLabel,
      initialDateTime: draft.occurredAt,
      onLocationChanged: (value) {
        draft.locationLabel = value;
        onChanged();
      },
      onDateTimeChanged: (value) {
        draft.occurredAt = value;
        onChanged();
      },
    );
  }
}
