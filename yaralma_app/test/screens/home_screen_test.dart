import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaralma_app/screens/home/home_screen.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('shows YARALMA in app bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(),
        ),
      );
      expect(find.text('YARALMA'), findsOneWidget);
    });

    testWidgets('shows Your shield is ready', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(),
        ),
      );
      expect(find.text('Your shield is ready.'), findsOneWidget);
    });

    testWidgets('shows YouTube Guardian card', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(),
        ),
      );
      expect(find.text('YouTube Guardian'), findsOneWidget);
    });

    testWidgets('shows Holy Lock schedule card', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(),
        ),
      );
      expect(find.text('Holy Lock schedule'), findsOneWidget);
    });
  });
}
