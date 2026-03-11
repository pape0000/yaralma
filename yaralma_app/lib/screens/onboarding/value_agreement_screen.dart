import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/app_router.dart';

/// FR-01: Value Agreement — Six Pillars before entering settings.
/// Teranga, Jom, Kersa, Sutura, Muñ, Ngor.
class ValueAgreementScreen extends StatelessWidget {
  const ValueAgreementScreen({super.key});

  static const List<({String name, String meaning, String emoji})> pillars = [
    (name: 'Teranga', meaning: 'Hospitality', emoji: '🤝'),
    (name: 'Jom', meaning: 'Dignity', emoji: '🦁'),
    (name: 'Kersa', meaning: 'Modesty', emoji: '🙈'),
    (name: 'Sutura', meaning: 'Discretion', emoji: '🤫'),
    (name: 'Muñ', meaning: 'Patience', emoji: '⏳'),
    (name: 'Ngor', meaning: 'Integrity', emoji: '✨'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 32),
              Text(
                'YARALMA',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'These values belong to every Senegalese person. They guide YARALMA.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ...pillars.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Text(p.emoji, style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  p.meaning,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () =>
                    context.go(AppRoutes.pathFaithShield),
                child: const Text('I agree — Continue'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
