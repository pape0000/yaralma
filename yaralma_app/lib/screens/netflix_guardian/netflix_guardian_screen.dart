import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, TargetPlatform, defaultTargetPlatform;

import '../../services/netflix_guardian_service.dart';

/// Netflix Guardian settings screen.
class NetflixGuardianScreen extends StatefulWidget {
  const NetflixGuardianScreen({super.key});

  @override
  State<NetflixGuardianScreen> createState() => _NetflixGuardianScreenState();
}

class _NetflixGuardianScreenState extends State<NetflixGuardianScreen> {
  bool _loading = true;
  List<String> _hiddenTitles = [];
  List<BlurScene> _blurScenes = [];
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
      final titles = await NetflixGuardianService.syncHiddenTitles();
      final scenes = await NetflixGuardianService.syncBlurScenes();

      setState(() {
        _hiddenTitles = titles;
        _blurScenes = scenes;
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
        title: const Text('Netflix Guardian'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Sync data',
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
          color: theme.colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.movie_filter,
                  size: 48,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lion Guardian Active',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _isAndroid
                            ? '${_blurScenes.length} scenes to blur'
                            : 'Works on Android devices',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
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
          icon: Icons.blur_on,
          title: 'Scene Blur',
          description: 'Automatically blurs inappropriate scenes during playback based on community timestamps.',
        ),
        const _FeatureCard(
          icon: Icons.visibility_off,
          title: 'Catalog Filter',
          description: 'Hides age-inappropriate titles from the Netflix catalog.',
        ),

        const SizedBox(height: 24),

        // Hidden titles
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hidden Titles',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '${_hiddenTitles.length} titles',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_hiddenTitles.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No hidden titles configured.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ...(_hiddenTitles.map((title) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.block),
                  title: Text(title),
                ),
              ))),

        const SizedBox(height: 24),

        // Blur scenes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Blur Scenes',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '${_blurScenes.length} scenes',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_blurScenes.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No blur scenes configured.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ...(_blurScenes.take(10).map((scene) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.blur_on),
                  title: Text(scene.title),
                  subtitle: Text(
                    scene.season != null
                        ? 'S${scene.season} E${scene.episode}: ${_formatTime(scene.startSeconds)} - ${_formatTime(scene.endSeconds)}'
                        : '${_formatTime(scene.startSeconds)} - ${_formatTime(scene.endSeconds)}',
                  ),
                ),
              ))),
        if (_blurScenes.length > 10)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '+ ${_blurScenes.length - 10} more scenes',
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
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
        leading: Icon(icon, color: theme.colorScheme.secondary),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }
}
