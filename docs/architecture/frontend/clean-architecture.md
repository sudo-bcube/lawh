# Clean Architecture & SOLID Principles

[Back to Architecture Index](../index.md)

---

## SOLID Principles Applied to Lawh

### 1. Single Responsibility Principle (SRP)

> *A class should have one, and only one, reason to change.*

**APPLY**:
- `AudioRecorderService` handles recording only, not transcription or fuzzy matching
- `FuzzyMatcherService` handles verse matching only, not API calls or UI state
- `RecordingProvider` manages recording state, not Quran text loading

**Example (SRP Violation to Avoid)**:
```dart
// BAD: One class doing too much
class VerseIdentificationService {
  Future<Verse> identifyVerse() {
    // Records audio
    // Calls Azure STT
    // Does fuzzy matching
    // Saves to database
    // Sends analytics
  }
}

// GOOD: Single responsibilities
class AudioRecorderService { /* records audio */ }
class AzureSttRepository { /* calls Azure STT API */ }
class FuzzyMatcherService { /* matches verses */ }
class FeedbackRepository { /* saves analytics */ }
```

---

### 2. Open/Closed Principle (OCP)

> *Software entities should be open for extension, but closed for modification.*

**APPLY**:
- Use repository interfaces to allow swapping implementations (Azure -> Google STT) without changing providers
- Use abstract `SttRepository` that `AzureSttRepositoryImpl` implements

**Example**:
```dart
// GOOD: Open for extension
abstract class SttRepository {
  Future<String> transcribeAudio(Uint8List audioData);
}

class AzureSttRepositoryImpl implements SttRepository {
  @override
  Future<String> transcribeAudio(Uint8List audioData) {
    // Azure-specific implementation
  }
}

// Later, extend with Google without modifying existing code
class GoogleSttRepositoryImpl implements SttRepository {
  @override
  Future<String> transcribeAudio(Uint8List audioData) {
    // Google-specific implementation
  }
}
```

**DON'T OVER-APPLY**:
- Don't create plugin architectures or strategy patterns for things that will never change
- Example: Quran text structure is stable; don't create multiple implementations

---

### 3. Liskov Substitution Principle (LSP)

> *Objects should be replaceable with instances of their subtypes without altering correctness.*

**APPLY**:
- Any implementation of `SttRepository` should work interchangeably in `IdentificationProvider`
- Mock repositories in tests should behave like real repositories

**Example**:
```dart
// GOOD: Mock behaves like real implementation
class MockSttRepository implements SttRepository {
  @override
  Future<String> transcribeAudio(Uint8List audioData) async {
    return 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'; // Test data
  }
}

// Provider doesn't care if it's real or mock
final identificationProvider = IdentificationProvider(
  sttRepository: MockSttRepository(), // or AzureSttRepositoryImpl()
);
```

---

### 4. Interface Segregation Principle (ISP)

> *Clients should not be forced to depend on interfaces they don't use.*

**APPLY**:
- Don't create giant "God interfaces" with 20 methods
- Split `QuranRepository` into specific interfaces if needed

**Example**:
```dart
// BAD: Fat interface forces unused dependencies
abstract class QuranRepository {
  Future<List<Verse>> getAllVerses();
  Future<Verse> getVerse(int surah, int ayah);
  Future<void> saveBookmark(Bookmark bookmark);
  Future<List<Bookmark>> getBookmarks();
  Future<void> updateReadingProgress(Progress progress);
  // ... 15 more methods
}

// GOOD: Focused interfaces
abstract class QuranTextRepository {
  Future<Verse> getVerse(int surah, int ayah);
  Future<List<Verse>> getVerseRange(int surahStart, int ayahStart, int ayahEnd);
}

abstract class BookmarkRepository {
  Future<void> saveBookmark(Bookmark bookmark);
  Future<List<Bookmark>> getBookmarks();
}
```

**DON'T OVER-APPLY**:
- For MVP, if `QuranRepository` only has 3-4 methods, keep it as one interface
- Only split when you have 8+ methods or unrelated responsibilities

---

### 5. Dependency Inversion Principle (DIP)

> *High-level modules should not depend on low-level modules. Both should depend on abstractions.*

**APPLY** (This is the most important for testability):
- Providers depend on repository interfaces, not concrete implementations
- Repositories are injected via Riverpod, not instantiated directly in providers

**Example**:
```dart
// BAD: Provider depends on concrete implementation
class IdentificationProvider extends StateNotifier<IdentificationState> {
  final azureClient = AzureSttClient(); // Hard-coded dependency

  Future<void> identify(Uint8List audio) async {
    final text = await azureClient.transcribe(audio); // Can't test or swap
  }
}

// GOOD: Provider depends on abstraction
class IdentificationProvider extends StateNotifier<IdentificationState> {
  final SttRepository sttRepository; // Injected dependency

  IdentificationProvider(this.sttRepository);

  Future<void> identify(Uint8List audio) async {
    final text = await sttRepository.transcribeAudio(audio); // Testable, swappable
  }
}

// Riverpod injection
final identificationProvider = StateNotifierProvider<IdentificationProvider, IdentificationState>((ref) {
  return IdentificationProvider(
    ref.watch(sttRepositoryProvider), // Injected via provider
  );
});
```

---

## MVP Architecture Decision Matrix

Use this matrix to decide when to apply architecture patterns:

| Scenario | Apply Architecture? | Rationale |
|----------|---------------------|-----------|
| **API might change (Azure -> Google)** | YES - Use repository interface | High probability, easy to add interface |
| **Complex business logic (fuzzy matching)** | YES - Separate service class | Makes testing easier, logic is complex |
| **Simple data storage (settings)** | MAYBE - Direct SharedPreferences if <5 settings | Don't over-abstract simple key-value storage |
| **Quran text lookup** | YES - Repository + local datasource | Critical feature, needs testing, may add caching later |
| **UI state management** | YES - Riverpod providers | Essential for reactive UI, already decided |
| **Audio recording** | YES - Service wrapper | Isolates platform-specific code, easier to test |
| **Analytics tracking** | NO - Direct Firebase calls OK for MVP | Low complexity, unlikely to change, don't abstract |
| **Navigation** | MAYBE - go_router is already an abstraction | Don't add custom navigation layer on top |
| **Networking** | YES - Repository wraps dio | Enables mocking, error handling, retries |
| **Validation logic** | NO - Inline validation OK for MVP | Simple input validation doesn't need separate layer |

**The Rule**: If it's testable, swappable, or complex business logic -> add layer. Otherwise, ship it simple.

---

## Code Quality Guidelines for MVP

### 1. Write Testable Code (But Don't Write All Tests Immediately)
- Structure code so it CAN be tested (dependency injection, pure functions)
- Write tests for critical paths: fuzzy matching, STT integration, recording state management
- Skip tests for simple UI widgets until after MVP ships (test during manual QA instead)

### 2. Use Type Safety Aggressively
- Leverage Dart's null safety (`String?` vs `String`)
- Use Freezed for immutable data classes (prevents accidental mutations)
- Prefer enums over strings for state (`RecordingState.recording` not `'recording'`)

### 3. Keep Functions Small and Focused
- Aim for <20 lines per function (exceptions OK for UI build methods)
- If a function does more than one thing, split it
- Use descriptive names: `transcribeAudioWithAzureStt()` not `process()`

### 4. Fail Fast and Explicitly
- Throw specific exceptions (`AudioPermissionDeniedException` not generic `Exception`)
- Validate inputs at function boundaries (assert or throw if invalid)
- Don't swallow errors silently

### 5. No Unnecessary Comments
- **Write self-documenting code first**: Good naming makes most comments obsolete
- **Only comment the "why", never the "what"**: Code shows what it does; comments explain why you made non-obvious decisions
- **Delete commented-out code**: Use git history instead
- **Avoid redundant comments**: Don't restate what the code clearly shows

```dart
// BAD: Commenting the obvious
// Set the recording state to recording
state = RecordingState.recording;

// BAD: Restating what the code does
// Create a new instance of AudioRecorderService
final recorder = AudioRecorderService();

// GOOD: Explaining WHY (non-obvious decision)
// Start recording immediately without delay to capture the first few seconds
// of recitation, which are critical for verse identification accuracy
await _recorder.start();

// GOOD: Warning about side effects or gotchas
// Note: This must be called before dispose() or it will leak memory
await _recorder.stop();

// GOOD: Documenting complex business logic
// Fuzzy matching uses Levenshtein distance with 15% tolerance because
// STT accuracy for Quranic Arabic averages 85% across tested reciters
final match = _fuzzyMatcher.findBestMatch(text, threshold: 0.15);
```

### 6. Optimize Later, Not Now
- Don't prematurely optimize (no custom memory pools, complex caching in MVP)
- Measure performance with Flutter DevTools before optimizing
- Focus on architecture that makes optimization easier later (e.g., swappable repositories)

---

## When to Refactor (Post-MVP Signals)

Add layers and complexity when you see these signals:

1. **Duplication across 3+ places** -> Extract shared abstraction
2. **Test setup is painful** -> Add abstraction to enable easier mocking
3. **Changing one thing breaks unrelated features** -> Add boundaries (interfaces/repositories)
4. **File is >500 lines** -> Split into multiple files by responsibility
5. **You're afraid to change code** -> Refactor to add safety (tests, types, boundaries)

**Before MVP**: Resist the urge to refactor unless it's blocking progress.

---

## Developer Checklist: Principal Engineer Review

Before merging any code, ask yourself:

- [ ] **Can I test this without running the app?** (If no, consider refactoring)
- [ ] **If Azure STT changes to Google, how many files do I touch?** (Should be 1-2, not 10+)
- [ ] **Is this code solving a current problem or a future hypothetical?** (Only solve current problems)
- [ ] **Would a senior engineer understand this code in 6 months?** (Clear naming, simple structure)
- [ ] **Am I following SOLID where it matters, not everywhere?** (Pragmatic, not dogmatic)
- [ ] **Is this the simplest thing that could possibly work?** (MVP mindset)
- [ ] **Does this code need comments, or can better naming eliminate them?** (Self-documenting code first)

---

## Related Documentation

- [Project Structure](./project-structure.md) - Directory structure and architecture patterns
- [Testing](./testing.md) - Testing strategy and test templates
- [Developer Standards](./developer-standards.md) - Critical coding rules and quick reference
