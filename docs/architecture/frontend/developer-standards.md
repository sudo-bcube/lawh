# Frontend Developer Standards

[Back to Architecture Index](../index.md)

---

## Critical Coding Rules

These rules prevent common mistakes that break production apps. Follow them religiously.

### 1. Never Bypass Null Safety

```dart
// BAD: Force unwrapping without checking
final name = user!.name; // Crashes if user is null

// GOOD: Safe null handling
final name = user?.name ?? 'Guest';
```

### 2. Always Dispose Controllers and Subscriptions

```dart
// BAD: Memory leak
class RecordingScreen extends StatefulWidget {
  final _timer = Timer.periodic(Duration(seconds: 1), (_) {});
  // Timer never cancelled
}

// GOOD: Proper cleanup
class RecordingNotifier extends StateNotifier<RecordingState> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
```

### 3. Use Const Constructors for Immutable Widgets

```dart
// BAD: Rebuilds widget unnecessarily
Widget build(context) {
  return Container(color: Colors.blue);
}

// GOOD: Widget cached, better performance
Widget build(context) {
  return const  Container(color: Colors.blue);
}
```

### 4. Never Use BuildContext After Async Gaps

```dart
// BAD: Context might be disposed
Future<void> saveData() async {
  await repository.save(data);
  Navigator.of(context).pop(); // Crash if widget unmounted
}

// GOOD: Check if mounted
Future<void> saveData() async {
  await repository.save(data);
  if (!mounted) return;
  Navigator.of(context).pop();
}
```

### 5. Always Handle Async Errors

```dart
// BAD: Uncaught exceptions crash app
Future<void> identifyVerse() async {
  final result = await sttRepository.transcribe(audio);
  // If this throws, app crashes
}

// GOOD: Explicit error handling
Future<void> identifyVerse() async {
  try {
    final result = await sttRepository.transcribe(audio);
  } catch (e, stack) {
    state = AsyncValue.error(e, stack);
  }
}
```

### 6. Use Keys for Dynamic Lists

```dart
// BAD: Flutter can't track which item is which
ListView.builder(
  itemBuilder: (context, index) => ResultCard(results[index]),
)

// GOOD: Keys help Flutter optimize rebuilds
ListView.builder(
  itemBuilder: (context, index) {
    final result = results[index];
    return ResultCard(
      key: ValueKey('${result.surah}-${result.ayah}'),
      result: result,
    );
  },
)
```

### 7. Never Block the UI Thread

```dart
// BAD: Heavy computation blocks UI
Widget build(context) {
  final matches = fuzzyMatcher.findMatches(text); // Blocks for 2 seconds
  return ResultsList(matches);
}

// GOOD: Use async or compute()
@override
Widget build(context) {
  final matchesAsync = ref.watch(matchesProvider);
  return matchesAsync.when(
    data: (matches) => ResultsList(matches),
    loading: () => CircularProgressIndicator(),
    error: (e, _) => ErrorMessage(e),
  );
}
```

### 8. Always Test on Low-End Devices

```dart
// Test app performance on:
// - iPhone SE 2nd gen (iOS minimum)
// - Samsung Galaxy A10s (Android minimum, 2GB RAM)
// - Slow 3G network simulation
```

### 9. Handle Arabic Text Direction Properly

```dart
// BAD: LTR layout for Arabic text
Text(arabicVerse)

// GOOD: Explicit RTL direction
Text(
  arabicVerse,
  textDirection: TextDirection.rtl,
)
```

### 10. Never Hard-Code API Keys

```dart
// BAD: Exposed in source code
const azureKey = '1234567890abcdef';

// GOOD: Load from environment
final azureKey = dotenv.env['AZURE_STT_API_KEY'];
```

---

## Quick Reference

### Common Commands

```bash
# Development
flutter run                              # Run on connected device
flutter run --release                    # Run release build
flutter run -d chrome                    # Run on web (Phase 2)

# Building
flutter build apk --release              # Android APK
flutter build appbundle --release        # Android App Bundle
flutter build ios --release              # iOS build

# Testing
flutter test                             # Unit & widget tests
flutter test integration_test/           # Integration tests
flutter test --coverage                  # Generate coverage report

# Code Generation (Freezed, JSON)
flutter pub run build_runner build       # One-time generation
flutter pub run build_runner watch       # Watch mode
flutter pub run build_runner build --delete-conflicting-outputs  # Clean rebuild

# Dependencies
flutter pub get                          # Install dependencies
flutter pub upgrade                      # Upgrade dependencies
flutter pub outdated                     # Check for outdated packages

# Debugging
flutter doctor                           # Check Flutter setup
flutter clean                            # Clean build artifacts
flutter analyze                          # Static analysis
```

### Key Import Patterns

```dart
// Material/Cupertino
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Freezed models
import 'package:freezed_annotation/freezed_annotation.dart';
part 'model_name.freezed.dart';

// go_router
import 'package:go_router/go_router.dart';

// Dio
import 'package:dio/dio.dart';

// Project structure
import 'package:lawh/core/constants/app_colors.dart';
import 'package:lawh/features/verse_identification/domain/models/verse_result.dart';
```

### File Naming Conventions Recap

```plaintext
Screens:        main_screen.dart
Widgets:        result_card.dart
Providers:      recording_provider.dart
Models:         verse_result.dart
Repositories:   stt_repository.dart (interface)
                azure_stt_repository_impl.dart (implementation)
Services:       audio_recorder_service.dart
Constants:      app_colors.dart
Tests:          *_test.dart
```

### Riverpod Provider Patterns

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

### Common Debugging Tips

```dart
// Print to console
debugPrint('Message');  // Better than print(), stripped in release mode

// Inspect widget tree
flutter inspector  // In VS Code / Android Studio

// Check performance
flutter run --profile  // Profile mode
// Then press 'p' to toggle performance overlay

// Debug network calls
// Use Dio LogInterceptor (already configured in app)

// Check memory leaks
flutter run --profile
// Press 'M' to trigger memory snapshot
```

### Platform-Specific Checks

```dart
import 'dart:io';

if (Platform.isIOS) {
  // iOS-specific code
}

if (Platform.isAndroid) {
  // Android-specific code
}

// Or use Theme.of(context).platform
final platform = Theme.of(context).platform;
if (platform == TargetPlatform.iOS) {
  // iOS behavior
}
```

### Useful Extensions

```dart
// BuildContext extensions (already defined in project)
context.goToVerse(2, 255);
context.goBack();

// Custom extensions you might add
extension StringExtensions on String {
  bool get isArabic => RegExp(r'[\u0600-\u06FF]').hasMatch(this);
}

extension DoubleExtensions on double {
  String get confidenceLabel {
    if (this >= 0.9) return 'High';
    if (this >= 0.65) return 'Medium';
    return 'Low';
  }
}
```

---

## Related Documentation

- [Clean Architecture](./clean-architecture.md) - SOLID principles and code quality guidelines
- [Component Standards](./component-standards.md) - Naming conventions and widget templates
- [Testing](./testing.md) - Testing strategy and test templates
