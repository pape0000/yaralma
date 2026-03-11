import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaralma_app/router/app_router.dart';
import 'package:yaralma_app/screens/onboarding/value_agreement_screen.dart';

void main() {
  group('ValueAgreementScreen', () {
    testWidgets('shows YARALMA title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ValueAgreementScreen(),
        ),
      );
      expect(find.text('YARALMA'), findsOneWidget);
    });

    testWidgets('shows six pillars with names and meanings', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ValueAgreementScreen(),
        ),
      );

      for (final pillar in ValueAgreementScreen.pillars) {
        expect(find.text(pillar.name), findsOneWidget);
        expect(find.text(pillar.meaning), findsOneWidget);
      }
    });

    testWidgets('shows value agreement copy', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ValueAgreementScreen(),
        ),
      );
      expect(
        find.text(
            'These values belong to every Senegalese person. They guide YARALMA.'),
        findsOneWidget,
      );
    });

    testWidgets('shows I agree — Continue button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ValueAgreementScreen(),
        ),
      );
      expect(find.text('I agree — Continue'), findsOneWidget);
    });

    testWidgets('navigates to Faith Shield when Continue tapped', (tester) async {
      final router = createAppRouter();
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('I agree — Continue'));
      await tester.tap(find.text('I agree — Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Faith Shield'), findsOneWidget);
      expect(find.text('Mouride'), findsOneWidget);
    });

    test('pillars list has exactly 6 items (FR-01)', () {
      expect(ValueAgreementScreen.pillars.length, 6);
    });

    test('pillars contain Teranga, Jom, Kersa, Sutura, Muñ, Ngor', () {
      final names = ValueAgreementScreen.pillars.map((p) => p.name).toSet();
      expect(names, containsAll(['Teranga', 'Jom', 'Kersa', 'Sutura', 'Muñ', 'Ngor']));
    });
  });
}
