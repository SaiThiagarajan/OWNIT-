import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('Home renders without overflow on a device with a gesture-nav bottom inset', (tester) async {
    // Regression test: BottomAppBar already applies its own internal
    // SafeArea, so AppBottomNavigation must not also add the system
    // bottom inset into its padding — doing so caused a real "BOTTOM
    // OVERFLOWED" error on devices with a gesture-nav inset (~24px).
    tester.view.devicePixelRatio = 3.0;
    tester.view.padding = const FakeViewPadding(bottom: 72); // 24 logical px
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(theme: AppTheme.dark, home: const HomeScreen()));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('What happened?'), findsOneWidget);
    expect(find.text('I LOST SOMETHING'), findsOneWidget);
    expect(find.text('I FOUND SOMETHING'), findsOneWidget);
    expect(find.text('Active reports'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Messages'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
