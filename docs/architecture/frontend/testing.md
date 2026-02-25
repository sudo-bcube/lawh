# Testing Requirements

[Back to Architecture Index](../index.md)

---

## Testing Strategy for MVP

**Focus on critical paths, not exhaustive coverage.** For a 4-week MVP, prioritize tests that prevent production failures over achieving high test coverage numbers.

### Testing Priority

1. **Critical path**: Verse identification flow (recording -> STT -> fuzzy match -> results)
2. **Business logic**: Fuzzy matching algorithm accuracy
3. **Edge cases**: Error handling, network failures, low confidence scenarios
4. **Skip for MVP**: Simple UI widgets, trivial getters/setters, platform-specific code

### Coverage Goals

- **Domain layer**: 80%+ (business logic is critical and easy to test)
- **Data layer**: 60%+ (API integration needs coverage)
- **Presentation layer**: 30%+ (focus on provider logic, skip widget tests for simple components)
- **Overall**: Don't obsess over numbers; test what matters

---

## Component Test Template

### Unit Test: Fuzzy Matching Service

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:lawh/features/verse_identification/data/services/fuzzy_matcher_service.dart';

void main() {
  late FuzzyMatcherService fuzzyMatcher;

  setUp(() {
    fuzzyMatcher = FuzzyMatcherService();
  });

  group('FuzzyMatcherService', () {
    test('returns high confidence match for exact transcription', () async {
      const transcription = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';

      final results = await fuzzyMatcher.findMatches(transcription);

      expect(results, isNotEmpty);
      expect(results.first.confidence, greaterThanOrEqualTo(0.95));
      expect(results.first.surahNumber, equals(1));
      expect(results.first.ayahNumber, equals(1));
    });

    test('returns medium confidence for partial match', () async {
      // Missing diacritics
      const transcription = 'بسم الله الرحمن الرحيم';

      final results = await fuzzyMatcher.findMatches(transcription);

      expect(results, isNotEmpty);
      expect(results.first.confidence, inRange(0.65, 0.89));
    });

    test('returns empty list for gibberish input', () async {
      const transcription = 'xyz123 random text';

      final results = await fuzzyMatcher.findMatches(transcription);

      expect(results, isEmpty);
    });

    test('handles empty string gracefully', () async {
      const transcription = '';

      final results = await fuzzyMatcher.findMatches(transcription);

      expect(results, isEmpty);
    });
  });
}
```

### Provider Test: Recording State

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lawh/features/verse_identification/presentation/providers/recording_provider.dart';
import 'package:lawh/features/verse_identification/data/services/audio_recorder_service.dart';

@GenerateMocks([AudioRecorderService])
import 'recording_provider_test.mocks.dart';

void main() {
  late MockAudioRecorderService mockRecorder;
  late ProviderContainer container;

  setUp(() {
    mockRecorder = MockAudioRecorderService();
    container = ProviderContainer(
      overrides: [
        audioRecorderServiceProvider.overrideWithValue(mockRecorder),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('RecordingProvider', () {
    test('initial state is idle', () {
      final state = container.read(recordingProvider);

      expect(state, isA<RecordingStateIdle>());
    });

    test('starts recording successfully', () async {
      when(mockRecorder.start()).thenAnswer((_) async => Future.value());

      final notifier = container.read(recordingProvider.notifier);
      await notifier.startRecording();

      final state = container.read(recordingProvider);
      expect(state, isA<RecordingStateRecording>());

      verify(mockRecorder.start()).called(1);
    });

    test('handles recording permission denied', () async {
      when(mockRecorder.start()).thenThrow(
        AudioPermissionException('Microphone permission denied'),
      );

      final notifier = container.read(recordingProvider.notifier);
      await notifier.startRecording();

      final state = container.read(recordingProvider);
      expect(state, isA<RecordingStateError>());
      expect(
        (state as RecordingStateError).message,
        contains('permission'),
      );
    });

    test('stops recording and returns audio data', () async {
      final audioData = Uint8List.fromList([1, 2, 3, 4]);
      when(mockRecorder.start()).thenAnswer((_) async => Future.value());
      when(mockRecorder.stop()).thenAnswer((_) async => audioData);

      final notifier = container.read(recordingProvider.notifier);
      await notifier.startRecording();
      await notifier.stopRecording();

      final state = container.read(recordingProvider);
      expect(state, isA<RecordingStateCompleted>());
      expect((state as RecordingStateCompleted).audioData, equals(audioData));

      verify(mockRecorder.stop()).called(1);
    });
  });
}
```

### Widget Test: Result Card

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawh/features/verse_identification/presentation/widgets/result_card.dart';
import 'package:lawh/features/verse_identification/domain/models/verse_result.dart';

void main() {
  testWidgets('ResultCard displays verse information correctly', (tester) async {
    final verse = VerseResult(
      surahNumber: 2,
      ayahNumber: 255,
      surahName: 'Al-Baqarah',
      surahNameArabic: 'البقرة',
      previewText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ',
      confidence: 0.95,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ResultCard(
              verse: verse,
              confidence: verse.confidence,
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    // Verify surah name is displayed
    expect(find.text('Al-Baqarah • البقرة'), findsOneWidget);

    // Verify verse number is displayed
    expect(find.text('Verse 255'), findsOneWidget);

    // Verify Arabic text is displayed
    expect(find.text('اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ'), findsOneWidget);

    // Verify high confidence indicator is shown
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('ResultCard calls onTap when tapped', (tester) async {
    var tapped = false;
    final verse = VerseResult(
      surahNumber: 1,
      ayahNumber: 1,
      surahName: 'Al-Fatihah',
      surahNameArabic: 'الفاتحة',
      previewText: 'بِسْمِ اللَّهِ',
      confidence: 0.90,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ResultCard(
              verse: verse,
              confidence: verse.confidence,
              onTap: () => tapped = true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ResultCard));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('ResultCard does not show confidence indicator for medium confidence', (tester) async {
    final verse = VerseResult(
      surahNumber: 3,
      ayahNumber: 1,
      surahName: 'Al-Imran',
      surahNameArabic: 'آل عمران',
      previewText: 'الم',
      confidence: 0.75, // Medium confidence
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ResultCard(
              verse: verse,
              confidence: verse.confidence,
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    // Confidence indicator should not be shown for medium confidence
    expect(find.byIcon(Icons.check_circle), findsNothing);
  });
}
```

### Integration Test: Full Verse Identification Flow

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lawh/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Verse Identification Flow', () {
    testWidgets('complete flow from recording to results', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. Verify main screen is displayed
      expect(find.text('Listen'), findsOneWidget);

      // 2. Tap listen button to start recording
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pump();

      // 3. Wait for recording to start
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byIcon(Icons.stop), findsOneWidget);

      // 4. Wait 10 seconds minimum (simulated)
      await tester.pump(const Duration(seconds: 10));

      // 5. Stop recording
      await tester.tap(find.byIcon(Icons.stop));
      await tester.pump();

      // 6. Wait for processing
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // 7. Verify results screen is displayed
      expect(find.text('Results'), findsOneWidget);
      expect(find.byType(ResultCard), findsWidgets);

      // 8. Tap first result to open Quran reader
      await tester.tap(find.byType(ResultCard).first);
      await tester.pumpAndSettle();

      // 9. Verify Quran reader screen is displayed
      expect(find.text('Quran Reader'), findsOneWidget);

      // 10. Verify share button is present
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('handles low confidence gracefully', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Record audio with background noise (low quality)
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pump(const Duration(seconds: 10));
      await tester.tap(find.byIcon(Icons.stop));
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Should show retry screen for low confidence
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.text('quieter space'), findsOneWidget);
    });

    testWidgets('handles network error gracefully', (tester) async {
      // TODO: Implement network error simulation
      // Requires mocking Azure STT service
    });
  });
}
```

---

## Testing Best Practices

### 1. Test Critical Business Logic First

```dart
// HIGH PRIORITY: Test fuzzy matching algorithm
test('fuzzy matcher handles Tajweed pronunciation variations', () {
  // Test different recitation styles
});

// HIGH PRIORITY: Test STT error handling
test('handles Azure STT timeout gracefully', () {
  // Test network failures
});

// LOW PRIORITY: Test simple getters
test('verse.surahName returns correct value', () {
  // Too trivial, skip for MVP
});
```

### 2. Use Mocks for External Dependencies

```dart
// GOOD: Mock external services
@GenerateMocks([AudioRecorderService, SttRepository])
void main() {
  // Tests are fast and reliable
}

// BAD: Real Azure API calls in tests
test('calls Azure STT service', () async {
  final result = await realAzureClient.transcribe(audio); // Slow, flaky
});
```

### 3. Test Error Paths, Not Just Happy Paths

```dart
test('handles network timeout', () { /* ... */ });
test('handles invalid audio format', () { /* ... */ });
test('handles empty transcription response', () { /* ... */ });
test('handles permission denial', () { /* ... */ });
```

### 4. Keep Tests Fast

```dart
// GOOD: Fast unit tests (<100ms each)
test('fuzzy match calculation', () {
  // Pure function, instant result
});

// ACCEPTABLE: Integration tests (<5s each)
testWidgets('full recording flow', (tester) async {
  // E2E flow, acceptable delay
});

// BAD: Tests that take >10 seconds
// Split into smaller tests or use mocks
```

### 5. Test One Thing at a Time

```dart
// BAD: Testing multiple things
test('recording and identification work', () {
  // Tests recording, STT, fuzzy match, UI update
});

// GOOD: Focused tests
test('recording starts successfully', () { /* ... */ });
test('STT transcribes audio correctly', () { /* ... */ });
test('fuzzy matcher finds correct verse', () { /* ... */ });
```

---

## MVP Testing Checklist

### Before Launch

- [ ] Fuzzy matching algorithm tested with 20+ sample verses
- [ ] Recording state transitions tested (idle -> recording -> processing -> completed)
- [ ] STT error handling tested (timeout, network error, auth failure)
- [ ] Deep link navigation tested (lawh://verse/2/255 opens correct verse)
- [ ] Low confidence scenario tested (shows retry screen)
- [ ] Feedback submission tested (thumbs up/down persists)
- [ ] Dark mode tested (all screens render correctly)
- [ ] Arabic text rendering tested (RTL layout, proper font)
- [ ] Share functionality tested (generates correct deep links)
- [ ] Permission handling tested (microphone, location)

### Post-MVP (Phase 2)

- [ ] E2E tests for all user flows
- [ ] Performance tests (60fps animations, <2s app launch)
- [ ] Accessibility tests (screen reader, voice control)
- [ ] Widget tests for all custom components
- [ ] Stress tests (recording 50+ times, memory leaks)

---

## Running Tests

### Unit Tests

```bash
# Run all unit tests
flutter test

# Run specific test file
flutter test test/unit/features/verse_identification/fuzzy_matcher_test.dart

# Run tests with coverage
flutter test --coverage
```

### Widget Tests

```bash
# Run widget tests
flutter test test/widget/

# Run specific widget test
flutter test test/widget/features/verse_identification/result_card_test.dart
```

### Integration Tests

```bash
# Run on connected device/emulator
flutter test integration_test/

# Run on specific device
flutter test integration_test/ -d <device_id>
```

### Test Coverage Report

```bash
# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Related Documentation

- [Clean Architecture](./clean-architecture.md) - SOLID principles and code quality guidelines
- [State Management](./state-management.md) - Provider testing patterns
- [API Integration](./api-integration.md) - Mocking API clients in tests
