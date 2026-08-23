import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/app/app.dart';
import 'package:mobile/core/widgets/inputs/otp_input.dart';

Future<void> _goFromSplashToLogin(WidgetTester tester) async {
  await tester.tap(find.text('Get started'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Skip'));
  await tester.pumpAndSettle();
}

Future<void> _goFromLoginToHome(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField), '5551234567');
  await tester.tap(find.text('Continue'));
  await tester.pump(); // start the simulated submit delay
  await tester.pumpAndSettle();

  // Any complete 6-digit code is treated as valid (no backend yet).
  final otpFields = find.descendant(
    of: find.byType(OtpInput),
    matching: find.byType(TextField),
  );
  for (var i = 0; i < 6; i++) {
    await tester.enterText(otpFields.at(i), '$i');
  }
  await tester.pump(const Duration(milliseconds: 700)); // verifying
  await tester.pump(const Duration(milliseconds: 600)); // success, then navigate
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('system back steps through Onboarding -> Login -> OTP one screen at a time', (tester) async {
    await tester.pumpWidget(const OwnitApp());
    await _goFromSplashToLogin(tester);
    expect(find.text('Welcome to OWNIT'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '5551234567');
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Enter the code'), findsOneWidget);

    // OTP -> back -> Login.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Welcome to OWNIT'), findsOneWidget);

    // Login -> back -> Onboarding.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('What happened?'), findsOneWidget);

    // Onboarding -> back -> Splash.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Get started'), findsOneWidget);
  });

  testWidgets('Home <-> History/Messages/Profile: tab switch updates active tab, back returns to Home', (tester) async {
    await tester.pumpWidget(const OwnitApp());
    await _goFromSplashToLogin(tester);
    await _goFromLoginToHome(tester);
    expect(find.text('What happened?'), findsOneWidget);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'History'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('What happened?'), findsOneWidget);

    await tester.tap(find.text('Messages'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Messages'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('What happened?'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Profile'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('What happened?'), findsOneWidget);
  });

  testWidgets('switching directly between non-Home tabs replaces rather than stacking', (tester) async {
    await tester.pumpWidget(const OwnitApp());
    await _goFromSplashToLogin(tester);
    await _goFromLoginToHome(tester);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Messages'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Messages'), findsOneWidget);

    // A single back should land on Home, not History (History was replaced,
    // not stacked underneath Messages).
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('What happened?'), findsOneWidget);
  });

  testWidgets('report FAB opens the Lost/Found picker and routes to the Lost flow', (tester) async {
    await tester.pumpWidget(const OwnitApp());
    await _goFromSplashToLogin(tester);
    await _goFromLoginToHome(tester);

    await tester.tap(find.bySemanticsLabel('Report a lost or found item'));
    await tester.pumpAndSettle();
    expect(find.text('I lost something'), findsOneWidget);
    expect(find.text('I found something'), findsOneWidget);

    await tester.tap(find.text('I lost something'));
    await tester.pumpAndSettle();
    expect(find.text('What did you lose?'), findsOneWidget);
  });
}
