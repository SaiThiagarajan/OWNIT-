import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/search/presentation/search_screen.dart';

void main() {
  Widget wrap() => MaterialApp(theme: AppTheme.dark, home: const SearchScreen());

  testWidgets('shows recent searches initially, then results after searching', (tester) async {
    await tester.pumpWidget(wrap());

    expect(find.text('Recent searches'), findsOneWidget);
    expect(find.text('black wallet'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'wallet');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump(); // loading state starts
    await tester.pump(const Duration(milliseconds: 700)); // simulated search delay
    await tester.pumpAndSettle();

    expect(find.textContaining('Potentially relevant reports'), findsOneWidget);
    expect(find.text('Black leather wallet'), findsOneWidget);
    expect(find.text('Black wallet'), findsOneWidget);
  });

  testWidgets('shows the no-results state for an unmatched query', (tester) async {
    await tester.pumpWidget(wrap());

    await tester.enterText(find.byType(TextField).first, 'zzz-nothing-here');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text('No matching reports yet'), findsOneWidget);
  });

  testWidgets('shows the error state and retries', (tester) async {
    await tester.pumpWidget(wrap());

    await tester.enterText(find.byType(TextField).first, 'please fail this search');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't load search results"), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // Same query still contains "fail", so it deliberately errors again.
    expect(find.text("Couldn't load search results"), findsOneWidget);
  });

  testWidgets('quick filter narrows results to the selected kind', (tester) async {
    await tester.pumpWidget(wrap());

    await tester.enterText(find.byType(TextField).first, 'wallet');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text('Black leather wallet'), findsOneWidget); // found
    expect(find.text('Black wallet'), findsOneWidget); // lost

    await tester.tap(find.text('Found'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text('Black leather wallet'), findsOneWidget);
    expect(find.text('Black wallet'), findsNothing);
  });

  testWidgets('tapping a result opens the report detail screen', (tester) async {
    await tester.pumpWidget(wrap());

    await tester.enterText(find.byType(TextField).first, 'wallet');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Black leather wallet'));
    await tester.pumpAndSettle();

    expect(find.text('Report detail'), findsOneWidget);
    expect(find.text('Claim this item'), findsOneWidget);
  });
}
