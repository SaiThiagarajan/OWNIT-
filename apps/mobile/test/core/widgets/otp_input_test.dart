import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/widgets/inputs/otp_input.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  testWidgets('completes and reports the code once all boxes are filled', (tester) async {
    String? completed;
    await tester.pumpWidget(
      wrap(OtpInput(length: 4, onCompleted: (code) => completed = code)),
    );

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(4));

    for (var i = 0; i < 4; i++) {
      await tester.enterText(fields.at(i), '$i');
      await tester.pump();
    }

    expect(completed, '0123');
  });

  testWidgets('backspace on an empty box moves focus to the previous box', (tester) async {
    await tester.pumpWidget(wrap(const OtpInput(length: 4)));

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '5');
    await tester.pump();
    await tester.tap(fields.at(1));
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pump();

    final firstField = tester.widget<TextField>(fields.at(0));
    expect(firstField.controller!.text, isEmpty);
  });
}
