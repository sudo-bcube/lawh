# Frontend Tech Stack

[Back to Architecture Index](../index.md)

---

## Technology Stack Table

| Category | Technology | Version | Purpose | Rationale |
|----------|-----------|---------|---------|-----------|
| **Framework** | Flutter | 3.24+ (stable) | Cross-platform mobile app framework | Native performance, single codebase for iOS/Android, excellent UI toolkit for the required 60fps animations and <2s launch time |
| **Language** | Dart | 3.5+ | Programming language for Flutter | Type-safe, null-safe, optimized for Flutter's reactive architecture |
| **UI Library** | Material Design 3 / Cupertino | Built-in | Platform-adaptive UI components | Provides platform-native feel (Material for Android, Cupertino for iOS) while maintaining brand identity through theming |
| **State Management** | Riverpod | 2.5+ | Reactive state management | Compile-safe, testable, no BuildContext dependency; better than Provider for complex async operations (STT API calls) |
| **Routing** | go_router | 14.0+ | Declarative routing | Type-safe navigation, deep linking support for future web version, cleaner than Navigator 2.0 API |
| **HTTP Client** | dio | 5.4+ | API communication | Interceptors for auth/logging, better error handling than http package, request cancellation support |
| **Audio Recording** | record | 5.1+ | Microphone audio capture | Cross-platform, supports AAC/Opus encoding, provides audio amplitude for waveform visualization |
| **Audio Playback** | just_audio | 0.9+ | Optional audio playback (future feature) | Low latency, background audio support if reciter playback is added in Phase 2 |
| **Local Storage** | sqflite | 2.3+ | SQLite database for Quran text | Efficient verse lookup, supports complex queries, offline-first architecture |
| **Shared Preferences** | shared_preferences | 2.2+ | User settings persistence | Simple key-value storage for location toggle, theme preference, anonymous UUID |
| **Permissions** | permission_handler | 11.3+ | Runtime permissions management | Handles microphone, location permissions across iOS/Android with unified API |
| **Analytics** | firebase_analytics | 11.0+ | Usage tracking and feedback collection | Free tier, integrates with Firebase ecosystem, privacy-compliant event tracking |
| **Payments** | stripe_flutter | 11.0+ | Sadaqah donation processing | Official Stripe SDK, PCI-compliant, supports diverse payment methods |
| **Testing Framework** | flutter_test | Built-in | Unit and widget testing | Official testing framework, excellent widget testing support |
| **Integration Testing** | integration_test | Built-in | E2E testing | Tests full user flows on real devices/emulators |
| **Mocking** | mockito | 5.4+ | Test mocking | Generate mocks for API clients, repositories, services |
| **Linting** | flutter_lints | 4.0+ | Code quality enforcement | Official lint rules, enforces Dart/Flutter best practices |
| **Environment Config** | flutter_dotenv | 5.1+ | Environment variable management | Secure API key storage, separate dev/prod configs |
| **Crash Reporting** | firebase_crashlytics | 4.0+ | Production error tracking | Real-time crash reports, integrates with Firebase Analytics |
| **Code Generation** | build_runner + freezed | 2.4+ / 2.4+ | Immutable state classes | Reduces boilerplate for data models, ensures immutability for state management |
| **JSON Serialization** | json_serializable | 6.8+ | API response parsing | Type-safe JSON deserialization, reduces manual parsing errors |
| **Location Services** | geolocator | 12.0+ | Optional city/region collection | Cross-platform location access, respects permission states |
| **Dev Tools** | Flutter DevTools | Built-in | Performance profiling and debugging | Frame rate monitoring, memory profiling, network inspection |

---

## Key Technology Decisions

**1. Riverpod over Provider/Bloc**:
- Riverpod's compile-time safety catches errors early (critical for solo developer)
- AsyncNotifier pattern perfect for STT API calls with loading/error states
- No BuildContext requirement simplifies testing
- Trade-off: Steeper learning curve, but better long-term maintainability

**2. go_router over Navigator 2.0**:
- Declarative routing aligns with Flutter 3.x best practices
- Deep linking support prepares for web version (Phase 2)
- Type-safe navigation reduces runtime errors
- Trade-off: Extra dependency, but worth it for code clarity

**3. record package over flutter_sound**:
- Simpler API for basic recording needs
- Lighter weight (flutter_sound has more features we don't need)
- Better maintained for recent Flutter versions
- Trade-off: Fewer features, but sufficient for MVP

**4. dio over http package**:
- Interceptors essential for logging Azure STT requests/responses during debugging
- Request cancellation if user navigates away during API call
- Better timeout handling (10-second timeout requirement)
- Trade-off: Slightly heavier, but more robust for production

**5. Firebase Analytics over custom backend tracking**:
- Free tier sufficient for MVP scale (1,000 users)
- Reduces backend complexity (no need to build tracking API)
- Integrates with Crashlytics for unified monitoring
- Trade-off: Vendor lock-in, but cost-effective for MVP

---

## Critical Notes

- Azure STT accessed via REST API (no official Dart SDK, using dio for HTTP calls)
- Quran text database fits in SQLite (~5MB as mentioned in UI/UX spec)
- Stripe Islamic payment processor support requires verification before implementation
- Firebase free tier adequate for initial 1,000 users

---

## Related Documentation

- [Overview](./overview.md) - Framework selection and STT provider decision
- [API Integration](./api-integration.md) - Service templates and HTTP client configuration
- [State Management](./state-management.md) - Riverpod provider patterns
