# Styling Guidelines

[Back to Architecture Index](../index.md)

---

## Theme Configuration

Based on the UI/UX specification, Lawh uses a spiritual minimalism design with dark lemon green primary color and platform-adaptive components.

### Global Theme Setup (lib/core/theme/app_theme.dart)

```dart
import 'package:flutter/material.dart';
import 'package:lawh/core/constants/app_colors.dart';
import 'package:lawh/core/constants/app_text_styles.dart';

class AppTheme {
  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      background: AppColors.background,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.background,

    // Typography
    textTheme: TextTheme(
      displayLarge: AppTextStyles.h1,
      displayMedium: AppTextStyles.h2,
      displaySmall: AppTextStyles.h3,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.small,
      bodySmall: AppTextStyles.caption,
    ),

    // Card styling
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.surface,
    ),

    // Button styling
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(120, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Icon button styling
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48), // Meets accessibility minimum
      ),
    ),

    // App bar styling
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.neutralDark,
      centerTitle: true,
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryDark,
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
      surface: AppColors.surfaceDark,
      background: AppColors.backgroundDark,
      error: AppColors.errorDark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,

    // Typography (same structure, colors adjusted automatically)
    textTheme: TextTheme(
      displayLarge: AppTextStyles.h1.copyWith(color: AppColors.neutralLight),
      displayMedium: AppTextStyles.h2.copyWith(color: AppColors.neutralLight),
      displaySmall: AppTextStyles.h3.copyWith(color: AppColors.neutralLight),
      bodyLarge: AppTextStyles.body.copyWith(color: AppColors.neutralLight),
      bodyMedium: AppTextStyles.small.copyWith(color: AppColors.neutralLight),
      bodySmall: AppTextStyles.caption.copyWith(color: AppColors.neutralMediumDark),
    ),

    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.surfaceDark,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        minimumSize: const Size(120, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
      ),
    ),

    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.neutralLight,
      centerTitle: true,
    ),
  );
}
```

---

## Color Constants

### lib/core/constants/app_colors.dart

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Light Mode Colors
  static const Color primary = Color(0xFF2D5016);        // Dark lemon green
  static const Color secondary = Color(0xFFFFFAFA);      // Snow white
  static const Color accent = Color(0xFFD4AF37);         // Gold
  static const Color success = Color(0xFF4CAF50);        // Green
  static const Color warning = Color(0xFFFF9800);        // Orange
  static const Color error = Color(0xFFF44336);          // Red
  static const Color neutralDark = Color(0xFF333333);    // Primary text
  static const Color neutralMedium = Color(0xFF666666);  // Secondary text
  static const Color neutralLight = Color(0xFFE0E0E0);   // Borders
  static const Color background = Color(0xFFF5F5F5);     // App background
  static const Color surface = Color(0xFFFFFFFF);        // Card backgrounds

  // Dark Mode Colors
  static const Color primaryDark = Color(0xFF4A7C2B);           // Lighter green
  static const Color secondaryDark = Color(0xFF1E1E1E);         // Dark surface
  static const Color accentDark = Color(0xFFE6C657);            // Brighter gold
  static const Color successDark = Color(0xFF66BB6A);           // Lighter green
  static const Color warningDark = Color(0xFFFFA726);           // Brighter orange
  static const Color errorDark = Color(0xFFEF5350);             // Muted red
  static const Color neutralLightDark = Color(0xFFE0E0E0);      // Primary text (inverted)
  static const Color neutralMediumDark = Color(0xFFB0B0B0);     // Secondary text
  static const Color neutralDarkDark = Color(0xFF424242);       // Borders
  static const Color backgroundDark = Color(0xFF121212);        // App background (not true black)
  static const Color surfaceDark = Color(0xFF1E1E1E);           // Card backgrounds

  // Confidence indicators
  static const Color highConfidence = success;
  static const Color mediumConfidence = warning;
  static const Color lowConfidence = error;
}
```

---

## Typography Constants

### lib/core/constants/app_text_styles.dart

```dart
import 'package:flutter/material.dart';

class AppTextStyles {
  // Base font family (system default)
  static const String fontFamily = 'System'; // SF Pro (iOS), Roboto (Android)

  // Quranic Arabic font (configured in pubspec.yaml)
  static const String arabicFontFamily = 'UthmanicHafs';

  // Display styles
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: 0,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
  );

  // Body styles
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle small = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0,
  );

  // Arabic Quran text style
  static const TextStyle quranText = TextStyle(
    fontFamily: arabicFontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 1.8, // Generous line height for readability
    letterSpacing: 0,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0.5,
  );
}
```

---

## Spacing Constants

### lib/core/constants/app_spacing.dart

```dart
class AppSpacing {
  // Base unit: 8pt grid system
  static const double xs = 4;   // Micro spacing
  static const double sm = 8;   // Tight spacing
  static const double md = 16;  // Standard spacing
  static const double lg = 24;  // Comfortable spacing
  static const double xl = 32;  // Generous spacing
  static const double xxl = 48; // Extra generous spacing

  // Semantic spacing
  static const double componentPadding = md;      // Default component internal padding
  static const double screenMargin = md;          // Screen edge margins
  static const double sectionSpacing = xl;        // Major layout divisions
  static const double elementGap = sm;            // Gap between related elements

  // Touch targets
  static const double minTouchTarget = 48;        // iOS/Android minimum (44pt/48dp)

  // Border radius
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusCircular = 999;       // For circular buttons
}
```

---

## Styling Approach

### Platform-Adaptive Components

Lawh uses Material Design 3 as the base with platform-specific adaptations:

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PlatformButton extends StatelessWidget {
  const PlatformButton({
    required this.onPressed,
    required this.child,
    super.key,
  });

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Use Cupertino style on iOS, Material on Android
    if (Platform.isIOS) {
      return CupertinoButton.filled(
        onPressed: onPressed,
        child: child,
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}

class PlatformLoadingIndicator extends StatelessWidget {
  const PlatformLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return const CupertinoActivityIndicator();
    }

    return const CircularProgressIndicator();
  }
}
```

---

## Component-Specific Styling Examples

### Result Card with Confidence Indicator

```dart
class ResultCard extends StatelessWidget {
  const ResultCard({
    required this.verse,
    required this.confidence,
    required this.onTap,
    super.key,
  });

  final VerseResult verse;
  final double confidence;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHighConfidence = confidence >= 0.9;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenMargin,
        vertical: AppSpacing.elementGap,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.componentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${verse.surahName} • ${verse.surahNameArabic}',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  if (isHighConfidence)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.highConfidence,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Verse ${verse.ayahNumber}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                verse.previewText,
                style: AppTextStyles.quranText.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Listen Button with States

```dart
class ListenButton extends StatelessWidget {
  const ListenButton({
    required this.state,
    required this.onPressed,
    super.key,
  });

  final RecordingState state;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: ElevatedButton(
        onPressed: state.isIdle ? onPressed : null,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          backgroundColor: _getButtonColor(state),
        ),
        child: _getButtonChild(state),
      ),
    );
  }

  Color _getButtonColor(RecordingState state) {
    return state.when(
      idle: () => AppColors.primary,
      recording: (_) => AppColors.error,
      processing: () => AppColors.neutralMedium,
      completed: (_) => AppColors.success,
      error: (_) => AppColors.error,
    );
  }

  Widget _getButtonChild(RecordingState state) {
    return state.when(
      idle: () => const Icon(Icons.mic, size: 48),
      recording: (_) => const Icon(Icons.stop, size: 48),
      processing: () => const PlatformLoadingIndicator(),
      completed: (_) => const Icon(Icons.check, size: 48),
      error: (_) => const Icon(Icons.error_outline, size: 48),
    );
  }
}
```

---

## Styling Best Practices

### 1. Always Use Theme Colors

```dart
// BAD: Hard-coded colors
Container(
  color: Color(0xFF2D5016),
  child: Text('Hello', style: TextStyle(color: Colors.white)),
)

// GOOD: Theme colors
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Hello',
    style: Theme.of(context).textTheme.bodyLarge,
  ),
)
```

### 2. Use Spacing Constants

```dart
// BAD: Magic numbers
Padding(padding: EdgeInsets.all(16))

// GOOD: Named constants
Padding(padding: EdgeInsets.all(AppSpacing.componentPadding))
```

### 3. Respect Platform Conventions

```dart
// Use platform-adaptive widgets for better native feel
final indicator = Platform.isIOS
  ? CupertinoActivityIndicator()
  : CircularProgressIndicator();
```

### 4. Test Light and Dark Modes

```dart
// Always test both themes during development
// Toggle in device/simulator settings
// Verify all colors meet 4.5:1 contrast ratio
```

### 5. Use Semantic Color Names

```dart
// BAD: Colors named by appearance
static const greenColor = Color(0xFF2D5016);

// GOOD: Colors named by purpose
static const primary = Color(0xFF2D5016);
```

---

## Related Documentation

- [Component Standards](./component-standards.md) - Naming conventions and widget templates
- [Project Structure](./project-structure.md) - Directory structure and architecture patterns
- [Tech Stack](./tech-stack.md) - Full technology stack and package versions
