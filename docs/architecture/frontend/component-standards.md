# Component Standards

[Back to Architecture Index](../index.md)

---

## Component Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [VerseResultCard] displays a single verse identification result.
///
/// Used in results screen to show identified verses with confidence indicators.
/// Supports high/medium confidence variants and tap-to-read interaction.
class VerseResultCard extends ConsumerWidget {
  const VerseResultCard({
    required this.surahName,
    required this.surahNameArabic,
    required this.ayahNumber,
    required this.previewText,
    required this.confidence,
    required this.onTap,
    this.onThumbsUp,
    this.onThumbsDown,
    super.key,
  });

  final String surahName;
  final String surahNameArabic;
  final int ayahNumber;
  final String previewText;
  final double confidence;
  final VoidCallback onTap;
  final VoidCallback? onThumbsUp;
  final VoidCallback? onThumbsDown;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isHighConfidence = confidence >= 0.9;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$surahName • $surahNameArabic',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isHighConfidence)
                    Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Verse $ayahNumber',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                previewText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontFamily: 'UthmanicHafs',
                  height: 1.8,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
              ),
              if (onThumbsUp != null || onThumbsDown != null) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onThumbsUp != null)
                      IconButton(
                        icon: const Icon(Icons.thumb_up_outlined),
                        iconSize: 20,
                        onPressed: onThumbsUp,
                        tooltip: 'Correct',
                      ),
                    if (onThumbsDown != null)
                      IconButton(
                        icon: const Icon(Icons.thumb_down_outlined),
                        iconSize: 20,
                        onPressed: onThumbsDown,
                        tooltip: 'Incorrect',
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Naming Conventions

### File Naming

- Screens: `{feature}_screen.dart` (e.g., `main_screen.dart`, `results_screen.dart`)
- Widgets: `{widget_name}.dart` (e.g., `result_card.dart`, `listen_button.dart`)
- Providers: `{feature}_provider.dart` (e.g., `recording_provider.dart`)
- Models: `{model_name}.dart` (e.g., `verse_result.dart`, `recording_state.dart`)
- Repositories: `{domain}_repository.dart` for interfaces, `{domain}_repository_impl.dart` for implementations
- Services: `{service_name}_service.dart` (e.g., `audio_recorder_service.dart`)

### Class Naming

- Screens: `{Feature}Screen` (e.g., `MainScreen`, `ResultsScreen`)
- Widgets: `{WidgetName}` (e.g., `ResultCard`, `ListenButton`)
- Providers: `{Feature}Provider` or `{Feature}Notifier` (e.g., `RecordingProvider`, `IdentificationNotifier`)
- Models: Use domain terms (e.g., `VerseResult`, `SearchFeedback`, `RecordingState`)
- Repositories (abstract): `{Domain}Repository` (e.g., `SttRepository`, `QuranRepository`)
- Repositories (implementation): `{Provider}{Domain}RepositoryImpl` (e.g., `AzureSttRepositoryImpl`)
- Services: `{Service}Service` (e.g., `AudioRecorderService`, `FuzzyMatcherService`)

### Variable Naming

- Use descriptive names: `surahName` not `sn`, `audioData` not `data`
- Booleans: Start with `is`, `has`, `can`, `should` (e.g., `isRecording`, `hasPermission`)
- Private members: Prefix with underscore (e.g., `_recorder`, `_audioData`)
- Constants: Use `lowerCamelCase` for local constants, `UPPER_SNAKE_CASE` for compile-time constants

### Provider Naming

```dart
// State providers
final recordingStateProvider = StateProvider<RecordingState>(...);

// StateNotifier providers
final recordingProvider = StateNotifierProvider<RecordingNotifier, RecordingState>(...);

// Future providers
final verseProvider = FutureProvider.family<Verse, VerseId>(...);

// Stream providers
final audioStreamProvider = StreamProvider<List<int>>(...);
```

### Flutter Conventions

- Use `const` constructors wherever possible for performance
- Prefer `StatelessWidget` and `ConsumerWidget` over `StatefulWidget`
- Extract complex widget trees into separate widget classes
- Use named parameters for widget constructors (better readability)

---

## Related Documentation

- [State Management](./state-management.md) - Riverpod provider patterns
- [Styling](./styling.md) - Theme configuration and styling guidelines
- [Project Structure](./project-structure.md) - Directory structure and architecture patterns
