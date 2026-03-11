import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaralma_app/app.dart';

void main() {
  testWidgets('YaralmaApp loads and shows onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(const YaralmaApp());
    await tester.pumpAndSettle();

    expect(find.text('YARALMA'), findsOneWidget);
    expect(find.text('I agree — Continue'), findsOneWidget);
  });
}
