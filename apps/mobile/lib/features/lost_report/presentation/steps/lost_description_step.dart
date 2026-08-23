import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../models/lost_report_draft.dart';

class LostDescriptionStep extends StatefulWidget {
  const LostDescriptionStep({super.key, required this.draft, required this.onChanged});

  final LostReportDraft draft;
  final VoidCallback onChanged;

  @override
  State<LostDescriptionStep> createState() => _LostDescriptionStepState();
}

class _LostDescriptionStepState extends State<LostDescriptionStep> {
  static const _maxLength = 280;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.draft.description);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s8),
          Text('Describe what you lost.', style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'This is what our AI searches with.',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s24),
          Semantics(
            textField: true,
            label: 'Description',
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _controller,
                maxLength: _maxLength,
                minLines: 5,
                maxLines: 8,
                style: textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'e.g. Navy blue backpack with a laptop and a water bottle inside.',
                  hintStyle: textTheme.bodyLarge?.copyWith(color: AppColors.textTertiary),
                  counterStyle: textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
                ),
                onChanged: (value) {
                  widget.draft.description = value;
                  widget.onChanged();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
