import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/lost_report/presentation/lost_report_flow_screen.dart';
import 'package:mobile/features/reports/models/report.dart';
import 'package:mobile/features/reports/models/report_store.dart';

Future<void> _fillThroughToReview(WidgetTester tester) async {
  await tester.tap(find.text('Wallet / ID'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Skip')); // photo is optional
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField), 'Black leather wallet with my ID inside.');
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField).first, 'Near the campus library');
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
}

void main() {
  Widget wrap() {
    return MaterialApp(theme: AppTheme.dark, home: const LostReportFlowScreen());
  }

  testWidgets('walks through all 5 steps, submits, and appears in ReportStore', (tester) async {
    await tester.pumpWidget(wrap());

    expect(find.text('What did you lose?'), findsOneWidget);
    await _fillThroughToReview(tester);

    expect(find.text('Review your report'), findsOneWidget);
    expect(find.text('Wallet / ID'), findsOneWidget);
    expect(find.text('Near the campus library'), findsOneWidget);

    await tester.tap(find.text('Submit lost item'));
    await tester.pump(); // start the simulated submit delay
    await tester.pumpAndSettle();

    expect(find.text('Your lost item has been reported.'), findsOneWidget);
    expect(ReportStore.all, isNotEmpty);
    expect(ReportStore.all.first.type, ReportType.lost);
    expect(ReportStore.all.first.category, 'Wallet / ID');
  });

  testWidgets('Continue is disabled on the category step until one is picked', (tester) async {
    await tester.pumpWidget(wrap());

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('What did you lose?'), findsOneWidget);

    await tester.tap(find.text('Electronics'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('What did it look like?'), findsOneWidget);
  });

  testWidgets('description is required before Continue is enabled', (tester) async {
    await tester.pumpWidget(wrap());

    await tester.tap(find.text('Electronics'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Describe what you lost.'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Describe what you lost.'), findsOneWidget); // unchanged, blocked

    await tester.enterText(find.byType(TextField), 'A description.');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Where and when?'), findsOneWidget);
  });

  testWidgets('review step Edit links jump back to the right step', (tester) async {
    await tester.pumpWidget(wrap());
    await _fillThroughToReview(tester);

    await tester.tap(find.text('Edit >').at(2)); // Description row
    await tester.pumpAndSettle();
    expect(find.text('Describe what you lost.'), findsOneWidget);
  });

  testWidgets('the header back button steps through the wizard one step at a time', (tester) async {
    await tester.pumpWidget(wrap());
    await _fillThroughToReview(tester);
    expect(find.text('Review your report'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Where and when?'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Describe what you lost.'), findsOneWidget);
  });

  testWidgets('Android system back steps through the wizard, not just dismisses it', (tester) async {
    await tester.pumpWidget(wrap());

    await tester.tap(find.text('Electronics'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('What did it look like?'), findsOneWidget);

    // System back (not the header arrow) must step back one question, not
    // pop the whole flow straight back to Home.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('What did you lose?'), findsOneWidget);
  });

  testWidgets('the close button leaves the flow entirely', (tester) async {
    // Needs a real route underneath the flow (as Home would be in the
    // actual app) for "pop until first" to have somewhere to land.
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LostReportFlowScreen()),
                ),
                child: const Text('Open flow'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open flow'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Electronics'));
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Close'));
    await tester.pumpAndSettle();

    expect(find.text('What did you lose?'), findsNothing);
    expect(find.text('Open flow'), findsOneWidget);
  });

  testWidgets('a failed submission shows an inline error with retry, keeping entered data', (tester) async {
    await tester.pumpWidget(wrap());

    await tester.tap(find.text('Electronics'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'please fail this submission');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Downtown');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Submit lost item'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text("Couldn't submit your report."), findsOneWidget);
    // Data must still be there, not reset.
    expect(find.text('please fail this submission'), findsOneWidget);
  });
}
