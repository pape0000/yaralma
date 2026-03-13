# Phase 11: Wolof Guardian — ASR Placeholder

## Overview

Wolof Guardian is designed to monitor audio in real-time and automatically mute inappropriate content spoken in Wolof or local French. This phase provides a **placeholder** for future ASR (Automatic Speech Recognition) integration.

## Current Status: Placeholder

The service and screen are implemented as placeholders documenting the integration points. Full functionality awaits:
1. A trained Wolof ASR model
2. Audio capture API integration
3. Real-time processing infrastructure

## How It Will Work

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ Audio Stream │───▶│  Wolof ASR   │───▶│   Keyword    │───▶│  Auto-Mute   │
│ (YouTube/    │    │   Model      │    │   Checker    │    │   Signal     │
│  Netflix)    │    │              │    │              │    │              │
└──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
```

1. **Audio Capture**: Captures audio from video playback
2. **Speech Recognition**: Processes through Wolof ASR model
3. **Content Analysis**: Checks transcription against blocked keywords
4. **Auto-Mute**: Mutes audio when inappropriate content detected

## Files Created

### Service (`lib/services/wolof_guardian_service.dart`)

```dart
class WolofGuardianService {
  static bool isAvailable() => false;  // Returns true when ASR is ready
  
  static Future<void> startMonitoring() async { ... }
  static Future<void> stopMonitoring() async { ... }
  static List<String> getBlockedWolofKeywords() { ... }
  static Future<bool> processAudioChunk(List<int> audioData) async { ... }
  static Future<void> muteForDuration(Duration duration) async { ... }
}
```

### Screen (`lib/screens/wolof_guardian/wolof_guardian_screen.dart`)

Shows:
- Current availability status ("Coming Soon")
- How it will work (step-by-step cards)
- Preview of blocked Wolof keywords
- Technical requirements checklist

## Blocked Keywords (Preview)

Initial list for Wolof content:
- `takk`
- `jigeen bu nit`
- `gor bu nit`

*More keywords will be added when the ASR model is ready.*

## Technical Requirements

### 1. Wolof ASR Model
- Train or obtain a Wolof speech recognition model
- Options: Whisper fine-tuned on Wolof, or custom model

### 2. Audio Capture
- Android: Use `AudioPlaybackCapture` API (requires `FOREGROUND_SERVICE_MEDIA_PLAYBACK`)
- iOS: Not possible without jailbreak (App Sandbox restrictions)

### 3. Real-time Processing
- WebSocket or gRPC connection to ASR server
- Low-latency inference (<500ms for near-real-time)

### 4. Mute Integration
- Method channel to signal accessibility service
- Accessibility service mutes device audio temporarily

## Future Implementation Steps

1. **Train ASR Model**
   - Collect Wolof speech dataset
   - Fine-tune Whisper or train custom model
   - Deploy as API endpoint

2. **Integrate Audio Capture**
   - Request necessary Android permissions
   - Implement audio stream capture service
   - Handle background processing

3. **Connect to ASR**
   - Stream audio chunks to ASR server
   - Parse transcription results
   - Check against keyword blocklist

4. **Implement Mute Signal**
   - Send mute command via method channel
   - Accessibility service applies mute
   - Schedule unmute after duration

## Related PRD Requirement

> *Wolof Guardian: Real-time mute of inappropriate Wolof (and local French) dialogue using a specialized Wolof acoustic model.*

This is documented in the PRD as a future enhancement requiring the Wolof ASR model.
