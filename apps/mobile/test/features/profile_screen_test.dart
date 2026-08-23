import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/profile/presentation/profile_screen.dart';

void main() {
  Widget wrap() => MaterialApp(theme: AppTheme.dark, home: const ProfileScreen());

  Future<void> tapRow(WidgetTester tester, String label) async {
    final finder = find.text(label);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('shows header, stats, and no gamified elements', (tester) async {
    await tester.pumpWidget(wrap());

    expect(find.text('Alex Morgan'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Reports'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Recovered'), findsOneWidget);
    expect(find.text('Owner'), findsNothing);
    expect(find.text('Finder'), findsNothing);
  });

  testWidgets('the name-visibility privacy toggle actually changes state', (tester) async {
    await tester.pumpWidget(wrap());

    final switchFinder = find.byType(Switch);
    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    expect(tester.widget<Switch>(switchFinder).value, isFalse);
  });

  testWidgets('Privacy, Notifications, Help & Support, and About all navigate', (tester) async {
    await tester.pumpWidget(wrap());

    await tapRow(tester, 'Privacy');
    expect(find.text('Location privacy'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tapRow(tester, 'Notifications');
    expect(find.text('Match alerts'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tapRow(tester, 'Help & Support');
    expect(find.text('How OWNIT works'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tapRow(tester, 'About OWNIT');
    expect(find.text('AI-powered real-time lost & found'), findsOneWidget);
  });

  testWidgets('Report a problem form submits and shows a confirmation', (tester) async {
    await tester.pumpWidget(wrap());

    await tapRow(tester, 'Help & Support');

    await tester.tap(find.text('Report a problem'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'The map pin was off by a lot.');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text("Thanks — we've received your report."), findsOneWidget);
  });
}
