import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/location_datetime_step.dart';
import '../../models/lost_report_draft.dart';

class LostLocationStep extends StatelessWidget {
  const LostLocationStep({super.key, required this.draft, required this.onChanged});

  final LostReportDraft draft;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return LocationDateTimeStep(
      title: 'Where and when?',
      subtitle: 'Your exact location is never shown publicly.',
      accentColor: AppColors.lostCoral,
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
