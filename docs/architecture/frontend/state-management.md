# State Management

[Back to Architecture Index](../index.md)

---

## Store Structure

```plaintext
lib/features/verse_identification/
└── presentation/
    └── providers/
        ├── recording_provider.dart        # Audio recording state
        ├── identification_provider.dart   # STT + fuzzy matching state
        └── feedback_provider.dart         # User feedback submission
```

Each provider is co-located with its feature for better maintainability. Dependencies between providers are declared explicitly through Riverpod's `ref.watch()` mechanism.

---

## State Management Template

### 1. Simple State with StateProvider (Settings Example)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// For simple values that don't need complex logic
final locationSharingEnabledProvider = StateProvider<bool>((ref) {
  // Load from SharedPreferences
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  return settingsRepo.getLocationSharingEnabled();
});
```

### 2. Complex State with AsyncNotifierProvider (Verse Identification Example)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'identification_provider.freezed.dart';

// Immutable state using Freezed
@freezed
class IdentificationState with _$IdentificationState {
  const factory IdentificationState.initial() = _Initial;
  const factory IdentificationState.loading() = _Loading;
  const factory IdentificationState.success({
    required List<VerseResult> results,
    required double highestConfidence,
  }) = _Success;
  const factory IdentificationState.error({
    required String message,
    required IdentificationError errorType,
  }) = _Error;
}

enum IdentificationError {
  networkError,
  lowConfidence,
  audioPermissionDenied,
  sttServiceUnavailable,
}

// AsyncNotifier for complex async operations
class IdentificationNotifier extends AsyncNotifier<List<VerseResult>> {
  @override
  Future<List<VerseResult>> build() async {
    // Initial state returns empty results
    return [];
  }

  Future<void> identifyVerse(Uint8List audioData) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // Step 1: Transcribe audio with Azure STT
      final sttRepo = ref.read(sttRepositoryProvider);
      final transcription = await sttRepo.transcribeAudio(audioData);

      // Step 2: Fuzzy match against Quran text
      final fuzzyMatcher = ref.read(fuzzyMatcherServiceProvider);
      final matches = await fuzzyMatcher.findMatches(transcription);

      // Step 3: Sort by confidence and return top 3
      matches.sort((a, b) => b.confidence.compareTo(a.confidence));
      return matches.take(3).toList();
    });

    // Handle low confidence case
    state.whenData((results) {
      if (results.isEmpty || results.first.confidence < 0.65) {
        state = AsyncValue.error(
          'Low confidence',
          StackTrace.current,
        );
      }
    });
  }

  void reset() {
    state = const AsyncValue.data([]);
  }
}

// Provider declaration
final identificationProvider =
    AsyncNotifierProvider<IdentificationNotifier, List<VerseResult>>(
  IdentificationNotifier.new,
);
```

### 3. Recording State with StateNotifier (Audio Recording Example)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recording_provider.freezed.dart';

@freezed
class RecordingState with _$RecordingState {
  const factory RecordingState.idle() = _Idle;
  const factory RecordingState.recording({
    required Duration elapsed,
    required List<double> amplitudes, // For waveform visualization
  }) = _Recording;
  const factory RecordingState.processing() = _Processing;
  const factory RecordingState.completed({
    required Uint8List audioData,
  }) = _Completed;
  const factory RecordingState.error({
    required String message,
  }) = _Error;
}

class RecordingNotifier extends StateNotifier<RecordingState> {
  RecordingNotifier(this._audioRecorderService) : super(const RecordingState.idle());

  final AudioRecorderService _audioRecorderService;
  Timer? _timer;

  Future<void> startRecording() async {
    try {
      await _audioRecorderService.start();
      state = const RecordingState.recording(
        elapsed: Duration.zero,
        amplitudes: [],
      );

      // Update timer every 100ms for waveform animation
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
        if (state is _Recording) {
          final amplitude = await _audioRecorderService.getAmplitude();
          final currentState = state as _Recording;
          state = RecordingState.recording(
            elapsed: currentState.elapsed + const Duration(milliseconds: 100),
            amplitudes: [...currentState.amplitudes, amplitude],
          );

          // Auto-stop at 15 seconds
          if (currentState.elapsed.inSeconds >= 15) {
            await stopRecording();
          }
        }
      });
    } catch (e) {
      state = RecordingState.error(message: e.toString());
    }
  }

  Future<void> stopRecording() async {
    _timer?.cancel();
    state = const RecordingState.processing();

    try {
      final audioData = await _audioRecorderService.stop();
      state = RecordingState.completed(audioData: audioData);
    } catch (e) {
      state = RecordingState.error(message: e.toString());
    }
  }

  void reset() {
    _timer?.cancel();
    state = const RecordingState.idle();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Provider with dependency injection
final recordingProvider =
    StateNotifierProvider<RecordingNotifier, RecordingState>((ref) {
  return RecordingNotifier(
    ref.watch(audioRecorderServiceProvider),
  );
});
```

---

## Key Patterns

- **AsyncNotifier for API calls**: Use when you need imperative actions with async operations
- **StateNotifier for frequent updates**: Use for recording state that updates multiple times per second
- **StateProvider for simple values**: Use for settings, toggles, simple primitives
- **Freezed for immutable state**: Prevents accidental mutations, enables pattern matching
- **Explicit error types**: Enum-based error handling over string messages
- **Dependency injection via ref.watch()**: All dependencies injected through Riverpod for testability

---

## Riverpod Provider Patterns

```dart
// Simple state
final settingProvider = StateProvider<bool>((ref) => false);

// Async data
final verseProvider = FutureProvider.family<Verse, int>((ref, id) async {
  return await ref.read(quranRepositoryProvider).getVerse(id);
});

// Stateful logic
final recordingProvider = StateNotifierProvider<RecordingNotifier, RecordingState>((ref) {
  return RecordingNotifier(ref.watch(audioServiceProvider));
});

// Dependency injection
final sttRepositoryProvider = Provider<SttRepository>((ref) {
  return AzureSttRepositoryImpl(ref.watch(dioProvider));
});
```

---

## Related Documentation

- [Component Standards](./component-standards.md) - Naming conventions and widget templates
- [API Integration](./api-integration.md) - Service templates and HTTP client configuration
- [Testing](./testing.md) - Provider testing patterns
