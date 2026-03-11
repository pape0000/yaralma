# YARALMA App (Skeleton)

Flutter parent app (Android + iOS) plus Android accessibility overlay skeleton, aligned with the [PRD](../prd.md) and [Master Build Guide](../masterbuildguide.md).

## What’s included

- **Flutter app** (package `com.yaralma.yaralma_app`) — runs on **Android and iOS**
  - **Onboarding:** Value Agreement (6 pillars) → Faith Shield (Mouride, Tijaniyya, General Muslim, Christian)
  - **Home:** Placeholder for accessibility setup (Android), YouTube/Netflix link, Holy Lock. On iOS, home explains that the overlay runs on Android and this app is for settings/reports.
  - **Theme:** Teranga-style (warm, premium)
  - **Routing:** `go_router` (value-agreement → faith-shield → home)
- **Supabase:** Init in `main.dart`; set `_supabaseUrl` and `_supabaseAnonKey` (from [Supabase Dashboard](https://supabase.com/dashboard)).
- **Android:** `YaralmaAccessibilityService` — overlay on YouTube/Netflix when `is_locked` is true (read from SharedPreferences; Flutter will write this when Supabase realtime updates). App label: **YARALMA**. minSdk 26.
- **iOS:** App display name **YARALMA**; same onboarding and home (overlay card shows an informational message that the shield runs on Android).

## Run

```bash
cd yaralma_app
flutter pub get
flutter run
```

- **Android:** Pick an Android device or emulator. On the device, enable **YARALMA Shield** under Settings → Accessibility.
- **iOS:** Pick an iOS simulator or connected iPhone (`flutter run` then choose the iOS device).
- **Web (Chrome / Safari):** Run in the browser for quick testing of onboarding and navigation:
  ```bash
  flutter run -d chrome
  ```
  Or run the web server and open the URL in Safari or Chrome:
  ```bash
  flutter run -d web-server
  ```
  Then open the printed URL (e.g. http://localhost:xxxxx) in Safari or Chrome. The overlay and device features only work in the Android app.

## Tests

Unit and widget tests live under `test/`. Run:

```bash
flutter test
```

- **test/widget_test.dart** — Smoke test: `YaralmaApp` loads and shows onboarding.
- **test/router/app_router_test.dart** — Route paths (value-agreement, faith-shield, home) and navigation flow.
- **test/screens/value_agreement_screen_test.dart** — Six pillars (FR-01), copy, button, navigation to Faith Shield.
- **test/screens/faith_shield_screen_test.dart** — Four options (FR-02), Continue to setup, tapping option or button navigates to home.
- **test/screens/home_screen_test.dart** — Home shows title, “Your shield is ready”, Link YouTube, Holy Lock cards.
- **test/theme/app_theme_test.dart** — Theme is light, Material 3, warm primary color.

## Next steps (from build guide)

1. Add Supabase URL and anon key in `lib/main.dart`.
2. Phase 2: Create `profiles` table and RLS policies in Supabase.
3. Phase 4: Deploy WhatsApp webhook (Vercel + Twilio); link WhatsApp number to profile.
4. Wire Supabase realtime `is_locked` → write to SharedPreferences so the overlay reacts.
