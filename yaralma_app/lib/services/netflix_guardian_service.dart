import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for Netflix Guardian: blur scenes and hidden titles.
class NetflixGuardianService {
  static const _prefsChannel = MethodChannel('com.yaralma.yaralma_app/prefs');

  /// Fetches hidden titles from Supabase and syncs to native SharedPreferences.
  static Future<List<String>> syncHiddenTitles() async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('hidden_titles')
          .select('title')
          .order('title');

      final titles = (response as List)
          .map((row) => row['title'] as String)
          .toList();

      await _syncToNative('hidden_titles', titles);

      return titles;
    } catch (e) {
      return [];
    }
  }

  /// Fetches blur scenes from Supabase and syncs to native SharedPreferences.
  static Future<List<BlurScene>> syncBlurScenes() async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('blur_scenes')
          .select('title, season, episode, start_seconds, end_seconds')
          .order('title');

      final scenes = (response as List).map((row) => BlurScene(
        title: row['title'] as String,
        season: row['season'] as int?,
        episode: row['episode'] as int?,
        startSeconds: row['start_seconds'] as int,
        endSeconds: row['end_seconds'] as int,
      )).toList();

      // Sync as JSON string
      final jsonStr = scenes.map((s) => '${s.title}|${s.season ?? 0}|${s.episode ?? 0}|${s.startSeconds}|${s.endSeconds}').join(';');
      await _prefsChannel.invokeMethod('setBlurScenes', {'scenes': jsonStr});

      return scenes;
    } catch (e) {
      return [];
    }
  }

  static Future<void> _syncToNative(String key, List<String> values) async {
    try {
      await _prefsChannel.invokeMethod('setHiddenTitles', {
        'titles': values.join(','),
      });
    } catch (e) {
      // Platform channel might not be available
    }
  }
}

class BlurScene {
  final String title;
  final int? season;
  final int? episode;
  final int startSeconds;
  final int endSeconds;

  BlurScene({
    required this.title,
    this.season,
    this.episode,
    required this.startSeconds,
    required this.endSeconds,
  });
}
