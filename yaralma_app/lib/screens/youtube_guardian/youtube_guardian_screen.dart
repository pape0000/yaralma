import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, TargetPlatform, defaultTargetPlatform;

import '../../services/youtube_guardian_service.dart';

/// YouTube Guardian settings screen.
class YouTubeGuardianScreen extends StatefulWidget {
  const YouTubeGuardianScreen({super.key});

  @override
  State<YouTubeGuardianScreen> createState() => _YouTubeGuardianScreenState();
}

class _YouTubeGuardianScreenState extends State<YouTubeGuardianScreen> {
  bool _loading = true;
  List<String> _keywords = [];
  int _blockedCount = 0;
  String? _error;

  static bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    try {
      final keywords = await YouTubeGuardianService.syncBlockedKeywords();
      final blockedCount = _isAndroid
          ? await YouTubeGuardianService.getBlockedSearchCount()
          : 0;

      setState(() {
        _keywords = keywords;
        _blockedCount = blockedCount;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Guardian'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Sync keywords',
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildError(theme)
                : _buildContent(theme),
      ),
    );
  }

  Widget _buildError(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loadData, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Status card
        Card(
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.shield,
                  size: 48,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Guardian Active',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _isAndroid
                            ? '$_blockedCount searches blocked today'
                            : 'Works on Android devices',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Features
        Text(
          'Protection Features',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        const _FeatureCard(
          icon: Icons.search_off,
          title: 'Search Filter',
          description: 'Blocks searches containing inappropriate keywords in Wolof, French, and English.',
        ),
        const _FeatureCard(
          icon: Icons.short_text,
          title: 'Shorts Awareness',
          description: 'Monitors YouTube Shorts usage. Full blocking requires restricted mode.',
        ),
        const _FeatureCard(
          icon: Icons.child_care,
          title: 'Age-Appropriate Content',
          description: 'Recommend using YouTube Kids (3-8) or Restricted Mode (9-12) in YouTube settings.',
        ),

        const SizedBox(height: 24),

        // Blocked keywords
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Blocked Keywords',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '${_keywords.length} keywords',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_keywords.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No custom keywords. Using default list.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _keywords.take(20).map((k) => Chip(label: Text(k))).toList(),
          ),
        if (_keywords.length > 20)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '+ ${_keywords.length - 20} more',
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }
}
