import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/motion.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/buttons/secondary_button.dart';

class _OnboardingPage {
  const _OnboardingPage({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;
}

const _pages = [
  _OnboardingPage(
    icon: Icons.swap_horiz,
    title: 'What happened?',
    body: 'Lost something? Found something? Tell us in seconds.',
  ),
  _OnboardingPage(
    icon: Icons.auto_awesome,
    title: 'AI helps find the match',
    body: 'Our AI compares lost and found reports to surface likely matches.',
  ),
  _OnboardingPage(
    icon: Icons.shield_outlined,
    title: 'Your privacy stays yours',
    body: 'Contact details are only shared after ownership is verified.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    Navigator.of(context).pushNamed(AppRoutes.login);
  }

  void _next() {
    if (_page == _pages.length - 1) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: motionDuration(context, const Duration(milliseconds: 300)),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isLastPage = _page == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Icon(page.icon, size: 40, color: AppColors.orange),
                        ),
                        const SizedBox(height: AppSpacing.s32),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        Text(
                          page.body,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Semantics(
              label: 'Page ${_page + 1} of ${_pages.length}',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  final active = index == _page;
                  return AnimatedContainer(
                    duration: motionDuration(context, const Duration(milliseconds: 200)),
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                    width: active ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active ? AppColors.orange : AppColors.border,
                      borderRadius: BorderRadius.circular(AppSpacing.s4),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.s24,
                AppSpacing.screenHorizontal,
                AppSpacing.s16,
              ),
              child: Column(
                children: [
                  PrimaryButton(
                    label: isLastPage ? 'Get started' : 'Continue',
                    onPressed: _next,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  SecondaryButton(label: 'Skip', onPressed: _finish),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
