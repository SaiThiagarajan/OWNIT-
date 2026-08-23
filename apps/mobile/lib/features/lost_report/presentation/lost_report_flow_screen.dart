import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/motion.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/buttons/secondary_button.dart';
import '../../../core/widgets/inline_error_banner.dart';
import '../../../core/widgets/report_flow_header.dart';
import '../../../core/widgets/report_flow_sheet.dart';
import '../../../core/widgets/state_views.dart';
import '../../history/presentation/history_screen.dart';
import '../../reports/models/report.dart';
import '../../reports/models/report_store.dart';
import '../models/lost_report_draft.dart';
import 'steps/lost_category_step.dart';
import 'steps/lost_description_step.dart';
import 'steps/lost_location_step.dart';
import 'steps/lost_photo_step.dart';
import 'steps/lost_review_step.dart';

/// Hosts the 5-step lost-item report as progressive disclosure: one
/// question per screen, a thin progress bar up top, and a single pinned
/// action at the bottom — never one large form.
class LostReportFlowScreen extends StatefulWidget {
  const LostReportFlowScreen({super.key});

  @override
  State<LostReportFlowScreen> createState() => _LostReportFlowScreenState();
}

class _LostReportFlowScreenState extends State<LostReportFlowScreen> {
  static const _stepCount = 5;

  final _draft = LostReportDraft();
  final _pageController = PageController();
  int _step = 0;
  bool _submitting = false;
  bool _submitted = false;
  bool _submitError = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _canContinue => switch (_step) {
        0 => _draft.hasCategory,
        2 => _draft.hasDescription,
        3 => _draft.hasLocation,
        _ => true,
      };

  void _refresh() => setState(() {});

  void _goToStep(int step) {
    setState(() => _step = step);
    _pageController.animateToPage(
      step,
      duration: motionDuration(context, const Duration(milliseconds: 250)),
      curve: Curves.easeOut,
    );
  }

  void _goNext() {
    if (_step == _stepCount - 1) {
      _submit();
      return;
    }
    _goToStep(_step + 1);
  }

  /// Handles both the header's back arrow and the Android system back
  /// button identically: step back through the wizard one question at a
  /// time, only leaving the flow once already on step 1.
  void _goBack() {
    if (_step == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    _goToStep(_step - 1);
  }

  void _close() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _submitError = false;
    });
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    // Typing "fail" anywhere in the description is a deliberate, reachable
    // way to demo the submission-error state without a real backend.
    if (_draft.description.toLowerCase().contains('fail')) {
      setState(() {
        _submitting = false;
        _submitError = true;
      });
      return;
    }

    ReportStore.add(
      Report(
        id: 'lost-${DateTime.now().microsecondsSinceEpoch}',
        type: ReportType.lost,
        category: _draft.category ?? 'Other',
        description: _draft.description,
        imageBytes: _draft.photoBytes,
        coarseLocation: _draft.locationLabel ?? 'Unknown area',
        dateTime: _draft.occurredAt ?? DateTime.now(),
        status: ReportStatus.active,
        createdAt: DateTime.now(),
      ),
    );

    setState(() {
      _submitting = false;
      _submitted = true;
    });
  }

  void _viewReport() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
            child: Column(
              children: [
                const Spacer(),
                const SuccessState(
                  title: 'Your lost item has been reported.',
                  message:
                      "OWNIT will look for potentially relevant found reports and notify you.",
                ),
                const Spacer(),
                PrimaryButton(label: 'View report', onPressed: _viewReport),
                const SizedBox(height: AppSpacing.s12),
                SecondaryButton(
                  label: 'Back to Home',
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                ),
                const SizedBox(height: AppSpacing.s24),
              ],
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _goBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: ReportFlowSheet(
            child: Column(
              children: [
                ReportFlowHeader(
                  step: _step,
                  totalSteps: _stepCount,
                  onBack: _goBack,
                  onClose: _close,
                  accentColor: AppColors.lostCoral,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      LostCategoryStep(draft: _draft, onChanged: _refresh),
                      LostPhotoStep(draft: _draft, onChanged: _refresh),
                      LostDescriptionStep(draft: _draft, onChanged: _refresh),
                      LostLocationStep(draft: _draft, onChanged: _refresh),
                      LostReviewStep(draft: _draft, onEditStep: _goToStep),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenHorizontal,
                    AppSpacing.s16,
                    AppSpacing.screenHorizontal,
                    AppSpacing.s16,
                  ),
                  child: Column(
                    children: [
                      if (_submitError) ...[
                        InlineErrorBanner(
                          message: "Couldn't submit your report.",
                          onRetry: _submit,
                        ),
                        const SizedBox(height: AppSpacing.s12),
                      ],
                      Row(
                        children: [
                          if (_step == 1) ...[
                            Expanded(
                              child: SecondaryButton(label: 'Skip', onPressed: _goNext),
                            ),
                            const SizedBox(width: AppSpacing.s12),
                          ],
                          Expanded(
                            child: PrimaryButton(
                              label: _step == _stepCount - 1
                                  ? (_submitting ? 'Submitting report...' : 'Submit lost item')
                                  : 'Continue',
                              isLoading: _submitting,
                              onPressed: _canContinue && !_submitting ? _goNext : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
