import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaralma_app/router/app_router.dart';

void main() {
  group('AppRoutes', () {
    test('pathValueAgreement is /onboarding/value-agreement', () {
      expect(AppRoutes.pathValueAgreement, '/onboarding/value-agreement');
    });

    test('pathFaithShield is /onboarding/faith-shield', () {
      expect(AppRoutes.pathFaithShield, '/onboarding/faith-shield');
    });

    test('pathHome is /home', () {
      expect(AppRoutes.pathHome, '/home');
    });

    test('valueAgreement name matches path segment', () {
      expect(AppRoutes.valueAgreement, 'value-agreement');
    });

    test('faithShield name matches path segment', () {
      expect(AppRoutes.faithShield, 'faith-shield');
    });
  });

  group('createAppRouter', () {
    testWidgets('starts at Value Agreement screen', (tester) async {
      final router = createAppRouter();
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();
      expect(find.text('YARALMA'), findsOneWidget);
      expect(find.text('I agree — Continue'), findsOneWidget);
    });

    testWidgets('navigates to Faith Shield then Home', (tester) async {
      final router = createAppRouter();
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('YARALMA'), findsOneWidget);
      expect(find.text('I agree — Continue'), findsOneWidget);

      await tester.ensureVisible(find.text('I agree — Continue'));
      await tester.tap(find.text('I agree — Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Faith Shield'), findsOneWidget);
      expect(find.text('Mouride'), findsOneWidget);

      await tester.ensureVisible(find.text('Continue to setup'));
      await tester.tap(find.text('Continue to setup'));
      await tester.pumpAndSettle();

      expect(find.text('Your shield is ready.'), findsOneWidget);
    });
  });
}
