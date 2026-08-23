import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/settings_switch_tile.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _matchAlerts = true;
  bool _newMessages = true;
  bool _reportUpdates = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Notifications'),
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
                child: Column(
                  children: [
                    SettingsSwitchTile(
                      label: 'Match alerts',
                      description: 'When AI finds a potential match for your report.',
                      value: _matchAlerts,
                      onChanged: (value) => setState(() => _matchAlerts = value),
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    SettingsSwitchTile(
                      label: 'New messages',
                      description: 'When you receive a message in a verified conversation.',
                      value: _newMessages,
                      onChanged: (value) => setState(() => _newMessages = value),
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    SettingsSwitchTile(
                      label: 'Report updates',
                      description: 'Status changes on reports you\'ve submitted.',
                      value: _reportUpdates,
                      onChanged: (value) => setState(() => _reportUpdates = value),
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
