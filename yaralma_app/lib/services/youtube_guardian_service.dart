import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for YouTube Guardian: blocked keywords sync and overlay control.
class YouTubeGuardianService {
  static const _channel = MethodChannel('com.yaralma.yaralma_app/guardian');
  static const _prefsChannel = MethodChannel('com.yaralma.yaralma_app/prefs');

  /// Fetches blocked keywords from Supabase and syncs to native SharedPreferences.
  static Future<List<String>> syncBlockedKeywords() async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('blocked_keywords')
          .select('keyword')
          .order('keyword');

      final keywords = (response as List)
          .map((row) => row['keyword'] as String)
          .toList();

      // Sync to native SharedPreferences for the Accessibility Service
      await _syncToNative(keywords);

      return keywords;
    } catch (e) {
      // Return empty list on error; native service has fallback defaults
      return [];
    }
  }

  static Future<void> _syncToNative(List<String> keywords) async {
    try {
      await _prefsChannel.invokeMethod('setBlockedKeywords', {
        'keywords': keywords.join(','),
      });
    } catch (e) {
      // Platform channel might not be available (web/iOS)
    }
  }

  /// Gets the count of blocked searches today (from native SharedPreferences).
  static Future<int> getBlockedSearchCount() async {
    try {
      final count = await _prefsChannel.invokeMethod<int>('getSearchesBlockedToday');
      return count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Resets the daily blocked search counter.
  static Future<void> resetDailyCounter() async {
    try {
      await _prefsChannel.invokeMethod('resetSearchesBlockedToday');
    } catch (e) {
      // Ignore errors
    }
  }
}
