import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/motion.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/buttons/secondary_button.dart';
import '../../../core/widgets/inline_error_banner.dart';
import '../../../core/widgets/report_flow_header.dart';
import '../../../core/widgets/report_flow_sheet.dart';
import '../../../core/widgets/state_views.dart';
import '../../ai_result/presentation/ai_result_screen.dart';
import '../../history/presentation/history_screen.dart';
import '../../reports/data/reports_api.dart';
import '../../reports/models/report_store.dart';
import '../models/found_report_draft.dart';
import 'steps/found_ai_suggestion_step.dart';
import 'steps/found_camera_step.dart';
import 'steps/found_location_step.dart';
import 'steps/found_review_step.dart';
import 'steps/found_safekeeping_step.dart';

/// Hosts the 5-step found-item report: camera-first, then an editable AI
/// suggestion, coarse location/time, safekeeping, and review.
class FoundReportFlowScreen extends StatefulWidget {
  const FoundReportFlowScreen({super.key});

  @override
  State<FoundReportFlowScreen> createState() => _FoundReportFlowScreenState();
}

class _FoundReportFlowScreenState extends State<FoundReportFlowScreen> {
  static const _stepCount = 5;

  final _draft = FoundReportDraft();
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
        0 => _draft.hasPhoto,
        1 => _draft.aiSuggestionConfirmed,
        2 => _draft.hasLocation,
        3 => _draft.safekeeping != null,
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

    try {
      final report = await ReportsApi.submitFoundReport(_draft);
      if (!mounted) return;
      ReportStore.add(report);
      setState(() {
        _submitting = false;
        _submitted = true;
      });
    } catch (e) {
      // TEMP DEBUG — remove after diagnosing the submission failure.
      debugPrint('[FoundReportFlowScreen] submit failed: $e');
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _submitError = true;
      });
    }
  }

  void _viewReport() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HistoryScreen()),
    );
  }

  void _viewAiInsight() {
    Navigator.of(context).pushNamed(
      AppRoutes.aiResult,
      arguments: AiResultScreenArgs(
        category: _draft.category ?? 'Item',
        description: _draft.description,
        confidence: _draft.aiConfidence ?? 90,
        hasMatch: true,
      ),
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
                  title: 'Your found item has been reported.',
                  message: "OWNIT will look for potentially relevant lost reports.",
                ),
                const SizedBox(height: AppSpacing.s8),
                Semantics(
                  button: true,
                  label: 'View AI insight',
                  child: InkWell(
                    onTap: _viewAiInsight,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.s8),
                      child: Text(
                        'View AI insight',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.foundTeal,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
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
                  accentColor: AppColors.foundTeal,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      FoundCameraStep(draft: _draft, onChanged: _refresh),
                      FoundAiSuggestionStep(draft: _draft, onChanged: _refresh),
                      FoundLocationStep(draft: _draft, onChanged: _refresh),
                      FoundSafekeepingStep(draft: _draft, onChanged: _refresh),
                      FoundReviewStep(draft: _draft, onEditStep: _goToStep),
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
                      PrimaryButton(
                        label: _step == _stepCount - 1
                            ? (_submitting ? 'Submitting report...' : 'Submit found item')
                            : 'Continue',
                        isLoading: _submitting,
                        onPressed: _canContinue && !_submitting ? _goNext : null,
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
