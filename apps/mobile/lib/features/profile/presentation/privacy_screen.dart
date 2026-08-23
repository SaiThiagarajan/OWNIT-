import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/settings_switch_tile.dart';

/// Local-only privacy preferences. Back returns to Profile (default
/// [Navigator.pop] behavior, since this is pushed from there).
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _showNameToMatchedUsers = true;
  bool _coarseLocationOnly = true;
  bool _notificationPreferences = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Privacy'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s16),
              Text(
                'Your exact location and contact details are never shown publicly. '
                'They\'re only shared with a matched user after ownership is verified.',
                style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s24),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    SettingsSwitchTile(
                      label: 'Show my name to matched users only',
                      value: _showNameToMatchedUsers,
                      onChanged: (value) => setState(() => _showNameToMatchedUsers = value),
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    SettingsSwitchTile(
                      label: 'Location privacy',
                      description: 'Only share an approximate area, never exact coordinates.',
                      value: _coarseLocationOnly,
                      onChanged: (value) => setState(() => _coarseLocationOnly = value),
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    SettingsSwitchTile(
                      label: 'Notification preferences',
                      description: 'Allow OWNIT to notify you about activity on your reports.',
                      value: _notificationPreferences,
                      onChanged: (value) => setState(() => _notificationPreferences = value),
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
