import 'package:flutter/material.dart';

import '../../../../core/constants/item_categories.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/secondary_button.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../../../core/widgets/confidence_badge.dart';
import '../../models/found_report_draft.dart';

/// Shows the (mocked) AI category/description suggestion for the photo
/// taken in the previous step. The user must explicitly edit-and-save or
/// confirm before continuing — the suggestion is never treated as final on
/// its own, per the "AI suggested, not fact" rule.
class FoundAiSuggestionStep extends StatefulWidget {
  const FoundAiSuggestionStep({super.key, required this.draft, required this.onChanged});

  final FoundReportDraft draft;
  final VoidCallback onChanged;

  @override
  State<FoundAiSuggestionStep> createState() => _FoundAiSuggestionStepState();
}

class _FoundAiSuggestionStepState extends State<FoundAiSuggestionStep> {
  late final TextEditingController _descriptionController;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    if (widget.draft.category == null) {
      // Mocked AI output — no real analysis call yet.
      widget.draft.category = 'Electronics';
      widget.draft.description = 'White wireless earbuds in a charging case.';
      widget.draft.aiConfidence = 94;
    }
    _descriptionController = TextEditingController(text: widget.draft.description);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _confirm() {
    setState(() {
      _editing = false;
      widget.draft.aiSuggestionConfirmed = true;
    });
    widget.onChanged();
  }

  void _startEditing() {
    setState(() {
      _editing = true;
      widget.draft.aiSuggestionConfirmed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final draft = widget.draft;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s8),
          Text('AI suggested', style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'Check this looks right — you can edit anything before confirming.',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s24),
          if (draft.photoBytes != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              child: Image.memory(draft.photoBytes!, height: 160, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: AppSpacing.s16),
          ],
          Container(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.foundTint,
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              border: Border.all(color: AppColors.foundTeal.withValues(alpha: 0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, size: 16, color: AppColors.foundTeal),
                    const SizedBox(width: AppSpacing.s8),
                    Expanded(
                      child: Text(
                        'AI SUGGESTED',
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.foundTeal,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    if (draft.aiConfidence != null) ...[
                      const SizedBox(width: AppSpacing.s8),
                      // Just the percentage here — "AI SUGGESTED" already
                      // says this is a suggestion, so the fuller "N%
                      // confident match" phrasing used elsewhere would be
                      // redundant, and doesn't fit next to it on a phone
                      // width anyway.
                      ConfidenceBadge(percent: draft.aiConfidence!, label: '${draft.aiConfidence}%'),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  'AI recommends. You confirm.',
                  style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.s16),
                if (_editing) ...[
                  Text('Category', style: textTheme.labelMedium?.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.s8),
                  Wrap(
                    spacing: AppSpacing.s8,
                    runSpacing: AppSpacing.s8,
                    children: kItemCategories.map((category) {
                      return CategoryChip(
                        label: category.label,
                        icon: category.icon,
                        selected: draft.category == category.label,
                        onTap: () => setState(() => draft.category = category.label),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text('Description', style: textTheme.labelMedium?.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.s8),
                  TextField(
                    controller: _descriptionController,
                    minLines: 2,
                    maxLines: 4,
                    style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
                    decoration: const InputDecoration(isDense: true),
                    onChanged: (value) => draft.description = value,
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  PrimaryButton(label: 'Save', onPressed: _confirm),
                ] else ...[
                  Text(
                    draft.category ?? '',
                    style: textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    draft.description,
                    style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(label: 'Edit', onPressed: _startEditing),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      Expanded(
                        child: PrimaryButton(
                          label: draft.aiSuggestionConfirmed ? 'Confirmed' : 'Confirm',
                          onPressed: draft.aiSuggestionConfirmed ? null : _confirm,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
