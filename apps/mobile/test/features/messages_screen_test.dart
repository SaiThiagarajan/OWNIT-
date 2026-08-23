import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/messages/presentation/messages_screen.dart';

void main() {
  Widget wrap() => MaterialApp(theme: AppTheme.dark, home: const MessagesScreen());

  testWidgets('shows a loading skeleton, then the mock conversation list', (tester) async {
    await tester.pumpWidget(wrap());

    // Loading state before the simulated 500ms load completes.
    expect(find.text('Maya'), findsNothing);

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Maya'), findsOneWidget);
    expect(find.text('Alex'), findsOneWidget);
    expect(find.text('Sam'), findsOneWidget);
  });

  testWidgets('opening a conversation shows the safety banner and messages, and sending works', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Maya'));
    await tester.pumpAndSettle();

    expect(find.text('Keep meetups in public places.'), findsOneWidget);
    expect(find.text('Tomorrow afternoon.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Sounds good, see you then.');
    await tester.tap(find.bySemanticsLabel('Send message'));
    await tester.pumpAndSettle();

    expect(find.text('Sounds good, see you then.'), findsOneWidget);
  });

  testWidgets('marking an item as returned disables the input and shows the banner', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Maya'));
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Mark item as returned'));
    await tester.pumpAndSettle();

    expect(find.text('Mark item as returned?'), findsOneWidget);
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(find.text('Item marked as returned'), findsOneWidget);

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.enabled, isFalse);
  });
}
