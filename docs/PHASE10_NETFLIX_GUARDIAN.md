# Phase 10: Netflix Guardian — Lion Guardian

## Overview

Netflix Guardian provides two layers of protection:
1. **Scene Blur**: Community-sourced timestamps for scenes to blur during playback
2. **Catalog Filter**: Hides age-inappropriate titles from the Netflix browse view

## Database Migration

Run this in **Supabase Dashboard → SQL Editor**:

```sql
-- See: supabase/migrations/005_netflix_guardian.sql
```

This creates:
- `blur_scenes` table: timestamps (title, season, episode, start/end seconds)
- `hidden_titles` table: titles to hide from catalog

## Architecture

### Blur Scenes (Lion Guardian List)

The community-sourced list contains:
- Title name
- Season/episode (for series)
- Start and end timestamps (in seconds)
- Reason for blur

Example entries:
- Money Heist S1E2: 20:45-21:30 (Intimate scene)
- Squid Game S1E1: 57:00-58:20 (Graphic violence)

### Hidden Titles

Titles completely hidden from the Netflix catalog:
- 365 Days
- Sex Education
- Euphoria

### Android Accessibility Service

The service (extended from Phase 9):
1. Detects Netflix app is open
2. Loads blur scenes and hidden titles from SharedPreferences
3. During playback, monitors current time (via accessibility events)
4. Overlays blur when current time matches a scene timestamp
5. Hides thumbnails matching hidden titles

**Note**: Full implementation of time-based blur requires monitoring Netflix's playback UI elements, which varies by Netflix app version. The current MVP provides the data infrastructure; real-time blur may need refinement.

### Flutter Integration

`NetflixGuardianService`:
- Syncs blur scenes and hidden titles from Supabase
- Writes to native SharedPreferences via MethodChannel

`NetflixGuardianScreen`:
- Displays sync status
- Shows hidden titles list
- Shows blur scenes with timestamps

## Method Channels

Extended `com.yaralma.yaralma_app/prefs` channel:
- `setHiddenTitles`: Syncs hidden titles (comma-separated)
- `setBlurScenes`: Syncs blur scenes (pipe-delimited format)

## Limitations

1. **Playback Detection**: Netflix's UI structure varies; accurate playback time detection may require updates as Netflix changes their app
2. **Thumbnail Detection**: Identifying specific thumbnails requires image matching or text recognition, which is complex on accessibility layer
3. **Community Data**: The blur list effectiveness depends on community contributions

## Future Improvements

- Machine learning for automatic inappropriate scene detection
- Integration with Common Sense Media ratings
- User-contributed timestamps with moderation
- Netflix API integration (if available)

## Testing

1. Run the SQL migration
2. Open the app and navigate to "Netflix Guardian"
3. Tap "Sync" to fetch blur scenes and hidden titles
4. On Android device: verify data appears in the screen
5. Open Netflix and observe overlay behavior (MVP shows basic functionality)
