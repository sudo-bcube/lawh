# Project Structure

[Back to Architecture Index](../index.md)

---

## Principal Engineer Mindset

**Think like a principal engineer, not a framework zealot.**

A principal engineer knows when to apply architecture patterns and when to ship pragmatically. For this 4-week MVP:

- **Apply architecture when it prevents pain later** (testability, swappable Azure STT, clear feature boundaries)
- **Skip architecture when it's speculative** (don't build for features that don't exist yet)
- **Write code that's easy to change** (interfaces, dependency injection)
- **Don't write code that's "flexible for future unknowns"** (YAGNI - You Aren't Gonna Need It)

**The MVP Architecture Rule**: If a layer doesn't solve a current problem or make testing significantly easier, skip it. Add it in Phase 2 when you have real requirements.

---

## Pragmatic Clean Architecture for MVP

**Three-Layer Approach (Simplified Clean Architecture)**:

```
┌─────────────────────────────────────────────────┐
│         PRESENTATION LAYER                      │
│  - Screens (Widgets)                            │
│  - Riverpod Providers (State Management)        │
│  - UI Logic Only                                │
│  - Depends on: Domain Layer                     │
└─────────────────────────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────┐
│         DOMAIN LAYER (Business Logic)           │
│  - Models (Freezed data classes)                │
│  - Repository Interfaces (abstract)             │
│  - Pure Dart (no Flutter imports)               │
│  - Depends on: Nothing                          │
└─────────────────────────────────────────────────┘
                      ▲
┌─────────────────────────────────────────────────┐
│         DATA LAYER (Implementation)             │
│  - Repository Implementations                   │
│  - API Clients (dio, Azure STT)                 │
│  - Local Storage (SQLite, SharedPreferences)    │
│  - Depends on: Domain Layer                     │
└─────────────────────────────────────────────────┘
```

**Key Benefits for MVP**:
1. **Testable**: Domain layer has zero Flutter dependencies, easy to unit test business logic
2. **Swappable**: Replace Azure STT with Google Cloud STT by swapping one repository implementation
3. **Clear boundaries**: Each layer has one job; debugging is easier when you know where to look

**What We're NOT Doing (Post-MVP)**:
- Use Cases / Interactors layer (business logic is simple enough to live in providers)
- Complex entity/model mappings (domain models ARE data models for now)
- Dependency Injection containers (Riverpod providers handle DI)
- Separate DTO/Entity layers (premature abstraction)

---

## Directory Structure

```
lawh/
├── android/                      # Android-specific native code
├── ios/                          # iOS-specific native code
├── lib/
│   ├── main.dart                 # App entry point, initializes providers
│   ├── app.dart                  # Root widget, theme configuration, routing setup
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart           # Color palette (light/dark mode)
│   │   │   ├── app_text_styles.dart      # Typography scale
│   │   │   ├── app_spacing.dart          # 8pt grid spacing constants
│   │   │   └── app_strings.dart          # UI text constants
│   │   ├── theme/
│   │   │   ├── app_theme.dart            # ThemeData configuration
│   │   │   └── platform_theme.dart       # Material vs Cupertino theme logic
│   │   ├── router/
│   │   │   └── app_router.dart           # go_router configuration
│   │   ├── di/
│   │   │   └── providers.dart            # Riverpod provider declarations
│   │   ├── utils/
│   │   │   ├── logger.dart               # Logging utility
│   │   │   ├── device_info.dart          # Device UUID, platform detection
│   │   │   └── permissions_helper.dart   # Permission request wrappers
│   │   └── errors/
│   │       ├── app_exception.dart        # Custom exception types
│   │       └── error_handler.dart        # Global error handling logic
│   │
│   ├── features/
│   │   ├── verse_identification/
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── main_screen.dart          # "Listen" button home screen
│   │   │   │   │   ├── recording_screen.dart     # Waveform animation screen
│   │   │   │   │   ├── results_screen.dart       # Verse identification results
│   │   │   │   │   └── error_retry_screen.dart   # Low confidence / error handling
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── listen_button.dart        # Primary CTA with states
│   │   │   │   │   ├── waveform_visualizer.dart  # Audio amplitude animation
│   │   │   │   │   ├── result_card.dart          # Verse result card component
│   │   │   │   │   ├── confidence_indicator.dart # High/medium confidence badge
│   │   │   │   │   └── feedback_buttons.dart     # Thumbs up/down
│   │   │   │   └── providers/
│   │   │   │       ├── recording_provider.dart   # Audio recording state
│   │   │   │       ├── identification_provider.dart  # STT + fuzzy match logic
│   │   │   │       └── feedback_provider.dart    # Feedback submission
│   │   │   ├── domain/
│   │   │   │   ├── models/
│   │   │   │   │   ├── verse_result.dart         # Verse identification result
│   │   │   │   │   ├── search_feedback.dart      # User feedback model
│   │   │   │   │   └── recording_state.dart      # Recording status enum
│   │   │   │   └── repositories/
│   │   │   │       ├── stt_repository.dart       # Abstract STT interface
│   │   │   │       └── feedback_repository.dart  # Abstract feedback interface
│   │   │   └── data/
│   │   │       ├── repositories/
│   │   │       │   ├── azure_stt_repository_impl.dart    # Azure STT implementation
│   │   │       │   └── firebase_feedback_repository_impl.dart
│   │   │       ├── services/
│   │   │       │   ├── audio_recorder_service.dart   # record package wrapper
│   │   │       │   ├── fuzzy_matcher_service.dart    # Local verse matching
│   │   │       │   └── audio_compressor_service.dart # AAC/Opus encoding
│   │   │       └── datasources/
│   │   │           └── azure_stt_datasource.dart     # dio HTTP client for Azure
│   │   │
│   │   ├── quran_reader/
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   └── quran_reader_screen.dart  # Full Quran text display
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── verse_text.dart           # Arabic text with highlighting
│   │   │   │   │   └── surah_header.dart         # Surah name header
│   │   │   │   └── providers/
│   │   │   │       └── quran_reader_provider.dart
│   │   │   ├── domain/
│   │   │   │   ├── models/
│   │   │   │   │   ├── verse.dart                # Single verse model
│   │   │   │   │   ├── surah.dart                # Surah metadata
│   │   │   │   │   └── quran_text.dart           # Full Quran structure
│   │   │   │   └── repositories/
│   │   │   │       └── quran_repository.dart     # Abstract Quran data interface
│   │   │   └── data/
│   │   │       ├── repositories/
│   │   │       │   └── quran_repository_impl.dart
│   │   │       ├── datasources/
│   │   │       │   └── quran_local_datasource.dart   # SQLite queries
│   │   │       └── models/
│   │   │           └── quran_db_model.dart       # SQLite table structure
│   │   │
│   │   ├── settings/
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── settings_screen.dart
│   │   │   │   │   ├── privacy_policy_screen.dart
│   │   │   │   │   └── about_screen.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── settings_toggle.dart      # Location sharing toggle
│   │   │   │   │   └── settings_list_tile.dart   # Reusable settings item
│   │   │   │   └── providers/
│   │   │   │       └── settings_provider.dart
│   │   │   ├── domain/
│   │   │   │   ├── models/
│   │   │   │   │   └── app_settings.dart         # User preferences model
│   │   │   │   └── repositories/
│   │   │   │       └── settings_repository.dart
│   │   │   └── data/
│   │   │       ├── repositories/
│   │   │       │   └── settings_repository_impl.dart
│   │   │       └── datasources/
│   │   │           └── settings_local_datasource.dart  # SharedPreferences wrapper
│   │   │
│   │   ├── subscription/
│   │       │   ├── presentation/
│   │       │   │   ├── screens/
│   │       │   │   │   └── paywall_screen.dart       # Subscription paywall
│   │       │   │   ├── widgets/
│   │       │   │   │   ├── subscription_tile.dart    # Settings tile for upgrade/manage
│   │       │   │   │   └── usage_counter.dart        # "X/3 searches today" display
│   │       │   │   └── providers/
│   │       │   │       └── subscription_provider.dart
│   │       │   ├── domain/
│   │       │   │   ├── models/
│   │       │   │   │   └── subscription_status.dart  # Subscription state model
│   │       │   │   └── repositories/
│   │       │   │       └── subscription_repository.dart
│   │       │   └── data/
│   │       │       ├── repositories/
│   │       │       │   └── revenuecat_subscription_repository_impl.dart
│   │       │       └── datasources/
│   │       │           └── revenuecat_datasource.dart  # RevenueCat SDK wrapper
│   │       │
│   │       ├── ads/
│   │       │   ├── presentation/
│   │       │   │   ├── screens/
│   │       │   │   │   └── limit_reached_screen.dart  # Watch ad or upgrade options
│   │       │   │   ├── widgets/
│   │       │   │   │   └── banner_ad_widget.dart      # Adaptive banner ad
│   │       │   │   └── providers/
│   │       │   │       └── ads_provider.dart
│   │       │   └── domain/
│   │       │       └── services/
│   │       │           ├── interstitial_ad_service.dart
│   │       │           └── rewarded_ad_service.dart   # Watch-to-unlock ads
│   │       │
│   │       └── usage/
│   │           ├── presentation/
│   │           │   └── providers/
│   │           │       └── usage_provider.dart        # Usage state for UI
│   │           └── domain/
│   │               └── services/
│   │                   └── usage_tracker_service.dart # Daily/monthly limit tracking
│   │
│   └── shared/
│       ├── widgets/
│       │   ├── primary_button.dart               # Reusable primary button
│       │   ├── secondary_button.dart             # Reusable secondary button
│       │   ├── loading_indicator.dart            # Platform-adaptive spinner
│       │   └── error_message.dart                # Standard error display
│       └── extensions/
│           ├── context_extensions.dart           # BuildContext helpers
│           └── string_extensions.dart            # String utilities
│
├── assets/
│   ├── fonts/
│   │   └── uthmanic_hafs.ttf                     # Quranic Arabic font
│   ├── images/
│   │   └── islamic_pattern.svg                   # Main screen background pattern
│   └── data/
│       └── quran.db                              # Pre-packaged SQLite database
│
├── test/
│   ├── unit/
│   │   ├── features/
│   │   │   └── verse_identification/
│   │   │       ├── fuzzy_matcher_test.dart
│   │   │       └── recording_provider_test.dart
│   │   └── core/
│   │       └── utils/
│   │           └── permissions_helper_test.dart
│   ├── widget/
│   │   └── features/
│   │       └── verse_identification/
│   │           ├── main_screen_test.dart
│   │           └── result_card_test.dart
│   └── integration/
│       └── verse_identification_flow_test.dart   # Full E2E flow
│
├── .env.development                              # Dev environment variables
├── .env.production                               # Prod environment variables
├── pubspec.yaml                                  # Dependencies
├── analysis_options.yaml                         # Lint rules
└── README.md
```

---

## Architecture Pattern: Feature-First + Clean Architecture

**Why Feature-First?**
- **Scalability**: Each feature (verse identification, quran reader, settings, subscription, ads, usage) is self-contained
- **Solo developer efficiency**: Work on one feature at a time without touching others
- **Clear ownership**: Easy to find all code related to a specific screen or user flow
- **Phase 2 readiness**: New features (reciter identification, offline mode) can be added as new feature directories

---

## Key Structural Decisions

1. **`core/` for cross-cutting concerns**: Theme, routing, dependency injection live here (used by all features)
2. **`features/` organized by user journey**: Each feature is independent and follows presentation/domain/data layers
3. **`shared/widgets/` for truly reusable components**: Only components used across 2+ features go here (prevents premature abstraction)
4. **`domain/repositories/` implementation pattern**: Repositories implement abstract interfaces for testability and swappability
5. **`assets/data/quran.db` pre-packaged**: Quran text bundled with app (no first-launch download delay)

---

## Related Documentation

- [Overview](./overview.md) - Framework selection and STT provider decision
- [Clean Architecture](./clean-architecture.md) - SOLID principles and code quality guidelines
- [Component Standards](./component-standards.md) - Naming conventions and widget templates
