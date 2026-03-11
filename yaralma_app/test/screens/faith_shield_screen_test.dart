import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaralma_app/router/app_router.dart';
import 'package:yaralma_app/screens/onboarding/faith_shield_screen.dart';

void main() {
  group('FaithShieldScreen', () {
    testWidgets('shows Faith Shield app bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const FaithShieldScreen(),
        ),
      );
      expect(find.text('Faith Shield'), findsOneWidget);
    });

    testWidgets('shows all four faith options (FR-02)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const FaithShieldScreen(),
        ),
      );

      for (final option in FaithShieldScreen.options) {
        expect(find.text(option), findsOneWidget);
      }
    });

    testWidgets('shows Continue to setup button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const FaithShieldScreen(),
        ),
      );
      expect(find.text('Continue to setup'), findsOneWidget);
    });

    testWidgets('tapping Mouride navigates to home', (tester) async {
      final router = createAppRouter();
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('I agree — Continue'));
      await tester.tap(find.text('I agree — Continue'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mouride'));
      await tester.pumpAndSettle();

      expect(find.text('Your shield is ready.'), findsOneWidget);
    });

    testWidgets('tapping Continue to setup navigates to home', (tester) async {
      final router = createAppRouter();
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('I agree — Continue'));
      await tester.tap(find.text('I agree — Continue'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Continue to setup'));
      await tester.tap(find.text('Continue to setup'));
      await tester.pumpAndSettle();

      expect(find.text('Your shield is ready.'), findsOneWidget);
    });

    test('options list has exactly 4 items', () {
      expect(FaithShieldScreen.options.length, 4);
    });

    test('options contain Mouride, Tijaniyya, General Muslim, Christian', () {
      expect(
        FaithShieldScreen.options,
        ['Mouride', 'Tijaniyya', 'General Muslim', 'Christian'],
      );
    });
  });
}
