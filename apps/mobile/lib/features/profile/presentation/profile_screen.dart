import 'package:flutter/material.dart';

import '../../../app/bottom_tab_navigation.dart';
import '../../../app/report_selection_sheet.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_bottom_navigation.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/report_fab.dart';
import '../../../core/widgets/settings_nav_tile.dart';
import '../../../core/widgets/settings_switch_tile.dart';
import 'about_screen.dart';
import 'help_support_screen.dart';
import 'notifications_settings_screen.dart';
import 'privacy_screen.dart';

/// Profile tab: header, a quick privacy toggle, factual activity stats,
/// and settings navigation. All state here is local/in-memory — no
/// backend or real auth is wired up yet.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _tabIndex = AppNavDestination.profile;

  bool _showNameToMatchedUsers = true;

  void _openPhoneAccountSheet() {
    AppBottomSheet.show(
      context: context,
      title: 'Phone & account',
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.phone_outlined, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: AppSpacing.s12),
                Text('+1 555 123 4567', style: textTheme.bodyMedium),
                const SizedBox(width: AppSpacing.s8),
                const Icon(Icons.verified_outlined, color: AppColors.foundTeal, size: 16),
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            Text(
              'Your phone number is never shown to other users publicly.',
              style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.s16),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Profile'),
      ),
      floatingActionButton: ReportFab(onPressed: () => showReportSelectionSheet(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _tabIndex.index,
        onDestinationSelected: (index) => handleBottomTabTap(
          context,
          currentIndex: _tabIndex.index,
          tappedIndex: index,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s24),
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceElevated,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_outline, color: AppColors.textSecondary, size: 28),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alex Morgan', style: textTheme.titleLarge),
                        const SizedBox(height: AppSpacing.s4),
                        Text(
                          '+1 555 123 4567',
                          style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s24),
              Row(
                children: [
                  Expanded(child: _StatTile(label: 'Reports', value: '3')),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(child: _StatTile(label: 'Recovered', value: '2')),
                ],
              ),
              const SizedBox(height: AppSpacing.s24),
              AppCard(
                padding: EdgeInsets.zero,
                child: SettingsSwitchTile(
                  label: 'Show my name to matched users only',
                  value: _showNameToMatchedUsers,
                  onChanged: (value) => setState(() => _showNameToMatchedUsers = value),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    SettingsNavTile(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NotificationsSettingsScreen()),
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    SettingsNavTile(
                      icon: Icons.badge_outlined,
                      label: 'Phone & account',
                      onTap: _openPhoneAccountSheet,
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    SettingsNavTile(
                      icon: Icons.lock_outline,
                      label: 'Privacy',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    SettingsNavTile(
                      icon: Icons.help_outline,
                      label: 'Help & Support',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    SettingsNavTile(
                      icon: Icons.info_outline,
                      label: 'About OWNIT',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AboutScreen()),
                      ),
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

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.s4),
          Text(label, style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
