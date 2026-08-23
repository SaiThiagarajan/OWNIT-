import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/settings_nav_tile.dart';

class _FaqTopic {
  const _FaqTopic({required this.title, required this.body});

  final String title;
  final String body;
}

const _faqTopics = [
  _FaqTopic(
    title: 'How OWNIT works',
    body: 'OWNIT connects people who\'ve lost something with people who\'ve found something, '
        'using AI to suggest likely matches. Ownership is always verified before any contact '
        'details are shared.',
  ),
  _FaqTopic(
    title: 'Reporting a lost item',
    body: 'Pick a category, optionally add a photo, describe the item, and give an approximate '
        'location and time. We\'ll search for potential matches automatically.',
  ),
  _FaqTopic(
    title: 'Reporting a found item',
    body: 'Take a photo and our AI will suggest a category and description you can edit. Let us '
        'know roughly where you found it and where it\'s being kept safe.',
  ),
  _FaqTopic(
    title: 'How matching works',
    body: 'AI compares lost and found reports and surfaces potential matches with a confidence '
        'score. A match is always a suggestion, never a confirmed identification.',
  ),
  _FaqTopic(
    title: 'Privacy & safety',
    body: 'Exact locations, phone numbers, and other private details are never shown publicly. '
        'They\'re only shared with a matched user once ownership is verified.',
  ),
];

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  void _openContactSupport(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      title: 'Contact support',
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.mail_outline, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: AppSpacing.s12),
                Text('support@ownit.app', style: textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            Text(
              'We typically respond within 24 hours.',
              style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.s16),
          ],
        );
      },
    );
  }

  void _openReportProblem(BuildContext context) async {
    final submitted = await AppBottomSheet.show<bool>(
      context: context,
      title: 'Report a problem',
      builder: (context) => const _ReportProblemForm(),
    );
    if (submitted == true && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text("Thanks — we've received your report.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Help & Support'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s24),
              AppCard(
                padding: EdgeInsets.zero,
                child: Material(
                  type: MaterialType.transparency,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: Column(
                      children: [
                        for (var i = 0; i < _faqTopics.length; i++) ...[
                          if (i > 0) const Divider(color: AppColors.border, height: 1),
                          _FaqTile(topic: _faqTopics[i]),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    SettingsNavTile(
                      icon: Icons.support_agent_outlined,
                      label: 'Contact support',
                      onTap: () => _openContactSupport(context),
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    SettingsNavTile(
                      icon: Icons.report_gmailerrorred_outlined,
                      label: 'Report a problem',
                      onTap: () => _openReportProblem(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.topic});

  final _FaqTopic topic;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ExpansionTile(
      title: Text(topic.title, style: textTheme.bodyMedium),
      iconColor: AppColors.orange,
      collapsedIconColor: AppColors.textSecondary,
      childrenPadding: const EdgeInsets.fromLTRB(
        AppSpacing.cardPadding,
        0,
        AppSpacing.cardPadding,
        AppSpacing.cardPadding,
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            topic.body,
            style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _ReportProblemForm extends StatefulWidget {
  const _ReportProblemForm();

  @override
  State<_ReportProblemForm> createState() => _ReportProblemFormState();
}

class _ReportProblemFormState extends State<_ReportProblemForm> {
  static const _issues = ['Bug', 'Incorrect match', 'Safety concern', 'Other'];

  String _issue = _issues.first;
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Issue', style: textTheme.labelMedium?.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.s8),
        DropdownButtonFormField<String>(
          initialValue: _issue,
          items: _issues
              .map((issue) => DropdownMenuItem(value: issue, child: Text(issue)))
              .toList(),
          onChanged: (value) => setState(() => _issue = value ?? _issue),
          dropdownColor: AppColors.surfaceElevated,
        ),
        const SizedBox(height: AppSpacing.s16),
        Text('Description', style: textTheme.labelMedium?.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.s8),
        TextField(
          controller: _descriptionController,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(hintText: 'What went wrong?'),
        ),
        const SizedBox(height: AppSpacing.s24),
        PrimaryButton(
          label: 'Submit',
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
