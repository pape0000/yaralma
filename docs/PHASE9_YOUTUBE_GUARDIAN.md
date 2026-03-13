# Phase 9: YouTube Guardian

## Overview

YouTube Guardian protects children by:
1. **Search Filter**: Blocks searches containing inappropriate keywords (Wolof, French, English)
2. **Real-time Monitoring**: Uses Android Accessibility Service to detect text input in YouTube
3. **Visual Block**: Shows a full-screen overlay when blocked content is detected

## Database Migration

Run this in **Supabase Dashboard → SQL Editor**:

```sql
-- See: supabase/migrations/004_blocked_keywords.sql
```

This creates a `blocked_keywords` table with default entries for:
- French: porno, sexe, nu, drogue, violence, arme, casino, pari
- English: porn, naked, nude, sex, gun, drugs
- Wolof: takk, jigeen bu nit, gor bu nit

## Architecture

### Android Accessibility Service

The `YaralmaAccessibilityService` now listens for:
- `TYPE_WINDOW_STATE_CHANGED`: Detects when YouTube/Netflix is opened
- `TYPE_VIEW_TEXT_CHANGED`: Monitors search input for blocked keywords

When a blocked keyword is detected:
1. Shows a dark overlay with "YARALMA Guardian" message
2. Increments the `searches_blocked_today` counter in SharedPreferences
3. Stats are synced to Supabase for the Jom Report

### Flutter Integration

`YouTubeGuardianService`:
- Syncs blocked keywords from Supabase to native SharedPreferences
- Retrieves blocked search count for display

`YouTubeGuardianScreen`:
- Shows protection status
- Lists blocked keywords
- Displays daily blocked search count

### Method Channels

New `com.yaralma.yaralma_app/prefs` channel in `MainActivity.kt`:
- `setBlockedKeywords`: Syncs keywords to SharedPreferences
- `setIsLocked`: Sets lock state
- `getSearchesBlockedToday`: Gets blocked count
- `resetSearchesBlockedToday`: Resets daily counter

## Limitations

Since Google doesn't provide a public Family Link API:
- **Shorts**: Cannot programmatically hide the Shorts shelf; recommend enabling Restricted Mode
- **YouTube Kids**: Cannot force switch; recommend manual setup for ages 3-8
- **Explore Mode**: Recommend enabling for ages 9-12 in YouTube settings

The Accessibility Service provides a layer of protection but works best when combined with:
1. YouTube Restricted Mode (in YouTube settings)
2. Google Family Link (for device-level controls)
3. YouTube Kids app (for young children)

## Testing

1. Run the SQL migration
2. Open the app and navigate to "YouTube Guardian"
3. Tap "Sync" to fetch keywords from Supabase
4. On Android device: enable YARALMA Shield in Accessibility settings
5. Open YouTube and search for a blocked term (e.g., "xxx")
6. Verify the block overlay appears
