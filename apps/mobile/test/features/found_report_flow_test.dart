import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/found_report/presentation/found_report_flow_screen.dart';
import 'package:mobile/features/reports/models/report.dart';
import 'package:mobile/features/reports/models/report_store.dart';

import '../support/fake_image_picker.dart';

/// Taking a photo only populates the draft — it does not auto-advance the
/// step, so this always follows up with the explicit "Continue" tap that
/// moves from the camera step to the AI-suggestion step.
Future<void> _takePhotoAndContinue(WidgetTester tester) async {
  await tester.tap(find.text('Take photo'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
}

Future<void> _fillThroughToReview(WidgetTester tester) async {
  await _takePhotoAndContinue(tester);
  expect(find.text('AI suggested'), findsOneWidget);
  await tester.tap(find.text('Confirm'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();

  expect(find.text('Where and when did you find it?'), findsOneWidget);
  await tester.enterText(find.byType(TextField).first, 'Central Library');
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();

  expect(find.text('Where is the item now?'), findsOneWidget);
  await tester.tap(find.text("I'm keeping it"));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
}

/// The AI-suggestion step's content (photo preview + suggestion card) is
/// taller than the default 800x600 test surface, which pushes its buttons
/// low enough to collide with the fixed footer/FAB area and makes taps
/// land on the wrong widget. A realistic phone-sized viewport avoids that
/// whole class of flakiness rather than special-casing each tap.
void _useRealisticViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
}

void main() {
  setUpAll(() {
    ImagePickerPlatform.instance = FakeImagePicker();
  });

  Widget wrap() {
    return MaterialApp(theme: AppTheme.dark, home: const FoundReportFlowScreen());
  }

  testWidgets('camera step requires a photo before Continue is enabled', (tester) async {
    _useRealisticViewport(tester);
    await tester.pumpWidget(wrap());

    expect(find.text('What did you find?'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('What did you find?'), findsOneWidget); // still here, blocked

    await _takePhotoAndContinue(tester);
    expect(find.text('AI suggested'), findsOneWidget);
  });

  testWidgets('AI suggestion can be accepted as-is', (tester) async {
    _useRealisticViewport(tester);
    await tester.pumpWidget(wrap());
    await _takePhotoAndContinue(tester);

    expect(find.text('Electronics'), findsOneWidget);
    expect(find.text('94%'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    expect(find.text('Confirmed'), findsOneWidget);
  });

  testWidgets('AI suggestion can be edited before confirming', (tester) async {
    _useRealisticViewport(tester);
    await tester.pumpWidget(wrap());
    await _takePhotoAndContinue(tester);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bag'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Bag'), findsOneWidget);
  });

  testWidgets('safekeeping requires a selection before Continue is enabled', (tester) async {
    _useRealisticViewport(tester);
    await tester.pumpWidget(wrap());
    await _takePhotoAndContinue(tester);
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Campus area');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Where is the item now?'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Where is the item now?'), findsOneWidget); // still here, blocked

    await tester.tap(find.text('Handed to a front desk'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Review your report'), findsOneWidget);
  });

  testWidgets('review shows AI-suggested category and safekeeping, then submits into ReportStore', (tester) async {
    _useRealisticViewport(tester);
    await tester.pumpWidget(wrap());
    await _fillThroughToReview(tester);

    expect(find.text('Review your report'), findsOneWidget);
    expect(find.text('Electronics'), findsOneWidget);
    expect(find.text("I'm keeping it"), findsOneWidget);

    await tester.tap(find.text('Submit found item'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Your found item has been reported.'), findsOneWidget);
    expect(ReportStore.all, isNotEmpty);
    expect(ReportStore.all.first.type, ReportType.found);
  });

  testWidgets('Android system back steps through the wizard before leaving it', (tester) async {
    _useRealisticViewport(tester);
    await tester.pumpWidget(wrap());
    await _takePhotoAndContinue(tester);
    expect(find.text('AI suggested'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('What did you find?'), findsOneWidget);
  });
}
