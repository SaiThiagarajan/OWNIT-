import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/app/app.dart';

void main() {
  testWidgets('Splash shows Get started, which navigates to Onboarding', (tester) async {
    await tester.pumpWidget(const OwnitApp());

    expect(find.textContaining('OWNIT', findRichText: true), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('What happened?'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('Onboarding Skip goes straight to Login, and back returns to Onboarding', (tester) async {
    await tester.pumpWidget(const OwnitApp());
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to OWNIT'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('What happened?'), findsOneWidget);
  });
}
