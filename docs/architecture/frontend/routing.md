# Routing & Deep Linking

[Back to Architecture Index](../index.md)

---

## Route Configuration

**Deep Linking is Essential for MVP**: The project brief targets 30%+ verse sharing rate as a key success metric. Deep linking enables recipients to open shared verses directly in the app, which is critical for viral growth.

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Route paths as constants
class AppRoutes {
  static const main = '/';
  static const results = '/results';
  static const verse = '/verse/:surah/:ayah';  // Deep linkable!
  static const settings = '/settings';
  static const privacyPolicy = '/settings/privacy-policy';
  static const about = '/settings/about';
}

// Router configuration provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.main,
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        path: '/',
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/results',
        name: 'results',
        builder: (context, state) {
          // For internal navigation, still use extra data
          final results = state.extra as List<VerseResult>?;
          return ResultsScreen(results: results ?? []);
        },
      ),

      // PRIMARY ROUTE: Deep linkable verse reader
      // Supports: lawh://verse/2/255 or https://lawh.app/verse/2/255
      GoRoute(
        path: '/verse/:surah/:ayah',
        name: 'verse',
        builder: (context, state) {
          final surah = int.tryParse(state.pathParameters['surah'] ?? '');
          final ayah = int.tryParse(state.pathParameters['ayah'] ?? '');

          if (surah == null || ayah == null) {
            return ErrorScreen(
              error: 'Invalid verse reference',
              onRetry: () => context.go('/'),
            );
          }

          // Load verse from repository using surah/ayah numbers
          return QuranReaderScreen(
            surahNumber: surah,
            ayahNumber: ayah,
          );
        },
      ),

      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'privacy-policy',
            name: 'privacyPolicy',
            builder: (context, state) => const PrivacyPolicyScreen(),
          ),
          GoRoute(
            path: 'about',
            name: 'about',
            builder: (context, state) => const AboutScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(
      error: state.error?.toString() ?? 'Unknown error',
      onRetry: () => context.go('/'),
    ),
  );
});

// Navigation helper extensions
extension NavigationExtensions on BuildContext {
  void goToMain() => go('/');

  void goToResults(List<VerseResult> results) {
    go('/results', extra: results);
  }

  // Primary verse navigation - generates shareable URLs
  void goToVerse(int surah, int ayah) {
    go('/verse/$surah/$ayah');
  }

  void goToSettings() => go('/settings');
  void goToPrivacyPolicy() => go('/settings/privacy-policy');
  void goToAbout() => go('/settings/about');

  void goBack() => pop();
}
```

---

## Deep Link Platform Configuration

### iOS Configuration (ios/Runner/Info.plist)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <!-- Existing keys... -->

  <!-- Custom URL Scheme: lawh://verse/2/255 -->
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleTypeRole</key>
      <string>Editor</string>
      <key>CFBundleURLName</key>
      <string>com.lawh.app</string>
      <key>CFBundleURLSchemes</key>
      <array>
        <string>lawh</string>
      </array>
    </dict>
  </array>

  <!-- Universal Links (HTTPS): https://lawh.app/verse/2/255 -->
  <!-- Note: Requires apple-app-site-association file on web server -->
  <!-- Can defer HTTPS links to Phase 2; use lawh:// scheme for MVP -->
  <key>com.apple.developer.associated-domains</key>
  <array>
    <string>applinks:lawh.app</string>
  </array>
</dict>
</plist>
```

### Android Configuration (android/app/src/main/AndroidManifest.xml)

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  <application>
    <activity
      android:name=".MainActivity"
      android:launchMode="singleTop"
      android:theme="@style/LaunchTheme">

      <!-- Existing intent filters... -->

      <!-- Custom URL Scheme: lawh://verse/2/255 -->
      <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="lawh" />
        <data android:host="verse" />
      </intent-filter>

      <!-- App Links (HTTPS): https://lawh.app/verse/2/255 -->
      <!-- Note: Requires assetlinks.json file on web server -->
      <!-- Can defer to Phase 2; use lawh:// scheme for MVP -->
      <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="https" />
        <data android:host="lawh.app" />
        <data android:pathPrefix="/verse" />
      </intent-filter>
    </activity>
  </application>
</manifest>
```

---

## Verse Sharing Implementation

### Add share_plus to pubspec.yaml

```yaml
dependencies:
  share_plus: ^7.2.0
```

### Verse Share Service

```dart
import 'package:share_plus/share_plus.dart';

class VerseShareService {
  /// Share verse with deep link for viral growth
  Future<void> shareVerse({
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
    required String verseText,
  }) async {
    // Use custom scheme for MVP (no web server needed)
    final deepLink = 'lawh://verse/$surahNumber/$ayahNumber';

    // Phase 2: Use HTTPS link after deploying web version
    // final deepLink = 'https://lawh.app/verse/$surahNumber/$ayahNumber';

    final message = '''
$verseText

$surahName, Verse $ayahNumber

Open in Lawh app: $deepLink
''';

    await Share.share(
      message,
      subject: 'Verse from $surahName',
    );

    // Track sharing for analytics (30% share rate KPI)
    // await ref.read(analyticsServiceProvider).logShare(
    //   surah: surahNumber,
    //   ayah: ayahNumber,
    // );
  }
}

// Provider
final verseShareServiceProvider = Provider<VerseShareService>((ref) {
  return VerseShareService();
});
```

### QuranReaderScreen with Share Button

```dart
class QuranReaderScreen extends ConsumerWidget {
  const QuranReaderScreen({
    required this.surahNumber,
    required this.ayahNumber,
    super.key,
  });

  final int surahNumber;
  final int ayahNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verseAsync = ref.watch(verseProvider(surahNumber, ayahNumber));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Reader'),
        actions: [
          // Share button in app bar
          verseAsync.when(
            data: (verse) => IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await ref.read(verseShareServiceProvider).shareVerse(
                  surahNumber: verse.surahNumber,
                  ayahNumber: verse.ayahNumber,
                  surahName: verse.surahName,
                  verseText: verse.text,
                );
              },
              tooltip: 'Share verse',
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: verseAsync.when(
        data: (verse) => VerseDisplay(verse: verse),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorDisplay(error: error.toString()),
      ),
    );
  }
}
```

---

## Testing Deep Links

### iOS Simulator

```bash
# Test custom scheme
xcrun simctl openurl booted "lawh://verse/2/255"

# Test HTTPS link (Phase 2)
xcrun simctl openurl booted "https://lawh.app/verse/2/255"
```

### Android Emulator/Device

```bash
# Test custom scheme
adb shell am start -W -a android.intent.action.VIEW -d "lawh://verse/2/255" com.lawh.app

# Test HTTPS link (Phase 2)
adb shell am start -W -a android.intent.action.VIEW -d "https://lawh.app/verse/2/255" com.lawh.app
```

### Manual Testing Checklist

- [ ] Share verse via WhatsApp, tap link, app opens to correct verse
- [ ] Share verse via Messages, tap link, app opens to correct verse
- [ ] Copy link and paste in Safari/Chrome, app opens
- [ ] Invalid verse reference (e.g., lawh://verse/999/999) shows error screen
- [ ] App not installed: link fails gracefully (Phase 2: fallback to web version)

---

## Deep Linking Design Decisions

### Why Path Parameters are Primary

- **Shareable URLs**: Enables 30% share rate KPI from project brief
- **Viral growth**: Recipients can open verses directly without copy-paste
- **Future-proof**: Same URLs work for web version (Phase 2)
- **Simple structure**: `/verse/:surah/:ayah` is human-readable and memorable

### MVP vs Phase 2 Approach

**MVP (Week 1-4)**:
- Use `lawh://` custom scheme (no web server needed)
- Works offline immediately after app install
- Good enough for friends/family sharing

**Phase 2 (Post-MVP)**:
- Upgrade to `https://lawh.app/verse/:surah/:ayah` URLs
- Requires deploying apple-app-site-association (iOS) and assetlinks.json (Android)
- Fallback to web version if app not installed
- Better for social media sharing (HTTPS previews)

### Trade-offs

- **No backend needed for MVP**: Custom scheme works without web server
- **Custom schemes look less polished**: `lawh://` vs `https://` in messages
- **No link previews**: Custom schemes don't generate rich previews on social media
- **Easy upgrade path**: Change URL prefix in Phase 2 without refactoring routing

### Key Implementation Notes

- **android:launchMode="singleTop"**: Prevents multiple app instances when clicking links
- **Error handling**: Invalid verse references show error screen, not crash
- **Analytics tracking**: Log share events to measure 30% share rate KPI
- **QuranReaderScreen must load by reference**: Takes `surahNumber` and `ayahNumber`, fetches verse from repository

---

## Related Documentation

- [Component Standards](./component-standards.md) - Naming conventions and widget templates
- [State Management](./state-management.md) - Riverpod provider patterns
- [Testing](./testing.md) - Integration testing for deep links
