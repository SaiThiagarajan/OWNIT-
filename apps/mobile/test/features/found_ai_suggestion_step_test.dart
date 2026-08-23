import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/found_report/models/found_report_draft.dart';
import 'package:mobile/features/found_report/presentation/steps/found_ai_suggestion_step.dart';

void main() {
  testWidgets('populates a mock AI suggestion and requires confirmation before continuing', (tester) async {
    final draft = FoundReportDraft();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: FoundAiSuggestionStep(draft: draft, onChanged: () {}),
        ),
      ),
    );

    // The mock suggestion is populated on first build.
    expect(draft.category, 'Electronics');
    expect(draft.aiConfidence, 94);
    expect(draft.aiSuggestionConfirmed, isFalse);
    expect(find.text('AI SUGGESTED'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(draft.aiSuggestionConfirmed, isTrue);
  });

  testWidgets('editing lets the user override the suggested category', (tester) async {
    final draft = FoundReportDraft();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: FoundAiSuggestionStep(draft: draft, onChanged: () {}),
        ),
      ),
    );

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bag'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(draft.category, 'Bag');
    expect(draft.aiSuggestionConfirmed, isTrue);
  });
}
