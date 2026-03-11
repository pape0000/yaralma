import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaralma_app/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('light theme has brightness light', () {
      final theme = AppTheme.light;
      expect(theme.colorScheme.brightness, Brightness.light);
    });

    test('light theme uses Material 3', () {
      final theme = AppTheme.light;
      expect(theme.useMaterial3, true);
    });

    test('light theme has scaffold background color', () {
      final theme = AppTheme.light;
      expect(theme.scaffoldBackgroundColor, isNotNull);
    });

    test('light theme has card theme with zero elevation', () {
      final theme = AppTheme.light;
      expect(theme.cardTheme.elevation, 0);
    });

    test('light theme primary color is warm (terracotta range)', () {
      final theme = AppTheme.light;
      final primary = theme.colorScheme.primary;
      expect(primary.red, greaterThan(100));
      expect(primary.green, lessThan(100));
      expect(primary.blue, lessThan(80));
    });
  });
}
