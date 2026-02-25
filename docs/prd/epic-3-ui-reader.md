# Epic 3: User Interface & Quran Reader

**Expanded Goal:** Deliver the complete user experience with mobile UI (Flutter iOS/Android), confidence-based results display, in-app Quran reader with verse highlighting, error handling flows, and culturally respectful design following spiritual minimalism principles. This epic transforms the working backend (Epic 2) into a user-facing product that delivers the core value proposition: hear a verse → identify it → read it.

---

## Story 3.1: Main Screen with Listen Button & Recording UI

**As a** user,
**I want** a clean, beautiful main screen with a prominent "Listen" button,
**so that** I can quickly start recording when I hear a Quranic recitation.

### Acceptance Criteria

1. Main screen displays:
   - Large, centered "Listen" button (primary CTA, dark green color)
   - Prominent "Support Lawh (Sadaqah)" button below Listen button (secondary CTA)
   - Settings icon in top-right corner
   - App branding: "Lawh" name/logo at top
2. "Listen" button tap initiates audio recording (calls Story 2.2 functionality)
3. Recording UI overlay displays:
   - Circular progress indicator showing elapsed time (0-15 seconds)
   - Animated waveform visualization of audio input
   - "Stop" button (enabled after 10 seconds minimum)
   - "Recording..." label
4. Visual feedback: Button state changes (idle → recording → processing)
5. Recording automatically stops at 15 seconds with animation
6. Design follows spiritual minimalism: Clean, uncluttered, dark green (dark lemon) and snow white color scheme
7. Responsive layout: Works on various screen sizes (iPhone SE to iPad, small Android phones to tablets)
8. Accessibility: Minimum touch target 44x44pt, color contrast 4.5:1, dynamic text sizing supported

---

## Story 3.2: Results Screen with Confidence-Based Display

**As a** user,
**I want** to see verse identification results with clear confidence indication,
**so that** I can quickly find the correct verse or retry if uncertain.

### Acceptance Criteria

1. After recording completes, display loading state: "Identifying verse..." with spinner (max 5 seconds per FR10)
2. **High confidence (≥80%) display:**
   - Single result card prominently displayed
   - Verse reference: "Surah Name (Number:Verse)" - e.g., "Al-Fatiha (1:1)"
   - Arabic text preview (first 5-10 words with ellipsis)
   - Confidence indicator: Green checkmark icon + "High confidence match"
   - Tap card → opens Quran reader (Story 3.3)
3. **Medium confidence (55-79%) display:**
   - 2-3 result cards stacked vertically
   - Each card shows: Surah name/number, Arabic preview, similarity score percentage
   - Confidence indicator: Yellow/amber icon + "Select the correct verse"
   - Tap any card → opens Quran reader at that verse
4. **Low confidence (<55%) display:**
   - Message: "Could not identify verse - please try again"
   - Suggestions: "Try recording in a quieter space" or "Record a longer segment"
   - Large "Try Again" button returns to main screen
5. All confidence levels show:
   - Thumbs up/down feedback buttons at bottom (Story 4.1)
   - "None of these" option (if medium/high confidence results shown)
   - "Back to Home" button
6. Error state: API failures, timeout, network errors show user-friendly message (FR13) with retry option
7. Design: Cards use snow white background, dark green accents, Arabic text in Uthmani script font

---

## Story 3.3: In-App Quran Reader with Verse Highlighting

**As a** user,
**I want** to read the identified verse in context within the app,
**so that** I can reflect on the full meaning without switching to another app.

### Acceptance Criteria

1. Tapping verse result (Story 3.2) opens Quran reader screen
2. Reader displays:
   - Surah name and number at top (e.g., "Al-Fatiha - 1")
   - Verses in Madinah Mushaf (Uthmani script) Arabic text
   - Identified verse highlighted with subtle background color (light green or gold)
   - Verse numbers displayed inline or in margin
3. Reader is scrollable to view surrounding verses (context before and after identified verse)
4. Verse highlighting persists as user scrolls (sticky highlight or scroll-to effect)
5. Reader loads and displays within ≤1 second of result tap (NFR2)
6. Typography: Arabic text uses traditional Uthmani font, appropriate size (18-22pt), line spacing for readability
7. Navigation: "Back to Results" button or gesture (swipe back on iOS, back button on Android)
8. RTL (Right-to-Left) layout support for Arabic text
9. Accessibility: Dynamic text sizing supported, minimum contrast 4.5:1
10. Optional: Display transliteration below Arabic text (Phase 2 consideration)

---

## Story 3.4: Settings Screen with Privacy Controls

**As a** user,
**I want** a settings screen where I can control my privacy preferences and access app information,
**so that** I have transparency and control over my data.

### Acceptance Criteria

1. Settings icon (top-right of main screen) opens Settings screen
2. Settings sections:
   - **Location Sharing**
     - Toggle: "Share location with searches" (default: OFF)
     - Explanation text: "Help us understand regional recitation preferences. We collect city/region only, not precise GPS." (FR8)
     - When enabled: Display current detected city/region
   - **Privacy & Data**
     - Link: "Privacy Policy" (opens web view or external browser)
     - Button: "Request Data Deletion" (triggers deletion flow per NFR7)
     - Text: "Your data is anonymous and linked only to this device"
   - **Support Lawh**
     - Button: "Support Lawh (Sadaqah)" (opens donation flow, Story 5.1)
     - Text: "Help keep Lawh free and accessible"
   - **About**
     - App version number
     - Attribution: "Quran text from Tanzil.net (CC BY 3.0)"
     - Link: "Contact Support" (email or feedback form)
3. Toggle states persist across app restarts
4. Settings design follows dark green/snow white branding, clean layout
5. Accessibility: Clear labels, sufficient touch targets, screen reader compatible (deferred to Phase 2 per NFR14)

---

## Story 3.5: Error Handling & Retry Flows

**As a** user,
**I want** clear, helpful error messages when something goes wrong,
**so that** I know what happened and how to fix it.

### Acceptance Criteria

1. **Audio recording errors (FR13, FR14):**
   - Microphone permission denied: "Lawh needs microphone access to identify verses. Enable in Settings?"
   - Audio too quiet: "Recording too quiet - try getting closer to the sound source"
   - Recording too short (<5 seconds): "Please record at least 5 seconds"
2. **Network errors (FR15):**
   - No internet connection: "Internet connection required for Lawh to identify verses"
   - Request timeout: "Taking longer than expected - please try again"
   - Server error (5xx): "Something went wrong on our end - please try again shortly"
3. **Search result errors:**
   - No verse match (confidence <55%): "Could not identify verse - try recording in a quieter space or a longer segment"
   - STT failure: "Audio processing failed - please try again"
4. All error screens include:
   - Clear error icon (not alarming, friendly tone)
   - Simple explanation of what went wrong
   - Actionable next step ("Try Again", "Check Settings", "Contact Support")
   - "Back to Home" button
5. Error messages follow respectful tone (no technical jargon, no blame)
6. Toast notifications for minor errors (network glitch recovered, location detection failed)
7. Error tracking: Log errors to backend for monitoring (Epic 6 analytics)

---

## Story 3.6: Onboarding Flow (Optional)

**As a** first-time user,
**I want** a brief introduction to Lawh's purpose,
**so that** I understand how to use it immediately.

### Acceptance Criteria

1. **First launch only:** Display 2-3 screen onboarding flow (swipeable cards or steps)
2. **Screen 1:** "Hear a verse"
   - Illustration: Mosque or person listening
   - Text: "Hear a beautiful Quranic recitation at the mosque, a lecture, or during Hajj"
3. **Screen 2:** "Identify it instantly"
   - Illustration: Phone with Listen button
   - Text: "Tap Listen, record 5-15 seconds, and Lawh identifies the verse"
4. **Screen 3:** "Read and reflect"
   - Illustration: Quran text display
   - Text: "Read the identified verse in the app and share if you wish"
5. Optional: Location permission request with explanation during onboarding
6. Skip button available on all onboarding screens (no forced completion)
7. "Get Started" button on final screen closes onboarding and shows main screen
8. Onboarding never shown again after completion (stored in local preferences)
9. Onboarding design: Simple, culturally respectful illustrations, dark green/snow white branding
10. **Decision point:** If timeline is tight, defer onboarding to Phase 2 - app should be intuitive enough without it

---

## Story 3.7: iOS Build & Testing

**As a** developer,
**I want** the Flutter app built and tested on iOS devices,
**so that** iPhone users can use Lawh.

### Acceptance Criteria

1. iOS app builds successfully for iOS 13+ targets
2. App runs on iPhone simulators (iPhone SE, iPhone 14, iPhone 14 Pro Max)
3. App tested on at least one physical iOS device (iPhone 8 or newer)
4. Platform-specific features working:
   - iOS-style navigation (swipe back, modals)
   - Microphone permission request (iOS-style alert)
   - Audio recording using iOS AVFoundation
   - Secure UUID storage in iOS Keychain (Story 1.5)
5. iOS-specific UI polish:
   - Status bar styling (dark content on light background)
   - Safe area insets respected (iPhone notch, Dynamic Island)
   - Haptic feedback on button taps (optional)
6. No crashes, memory leaks, or performance issues on iOS
7. App Store asset preparation (Story 5.2) begins: screenshots, metadata, privacy labels

---

## Story 3.8: Android Build & Testing

**As a** developer,
**I want** the Flutter app built and tested on Android devices,
**so that** Android users can use Lawh.

### Acceptance Criteria

1. Android app builds successfully for Android 8.0+ (API level 26+)
2. App runs on Android emulators (Pixel 4, Pixel 6, Samsung Galaxy S22)
3. App tested on at least one physical Android device (mid-range phone recommended)
4. Platform-specific features working:
   - Material Design 3 components (buttons, cards, navigation)
   - Android-style navigation (back button, material transitions)
   - Microphone permission request (Android runtime permissions)
   - Audio recording using Android MediaRecorder
   - Secure UUID storage in Android Keystore (Story 1.5)
5. Android-specific UI polish:
   - System navigation bar handling (3-button vs gesture navigation)
   - Edge-to-edge display support
   - Ripple effects on button taps
6. No crashes, memory leaks, or performance issues on Android
7. Google Play asset preparation (Story 5.2) begins: screenshots, metadata, data safety form

---

## Epic 3 Summary

**Stories:** 8 stories covering main screen, results display, Quran reader, settings, error handling, onboarding, iOS build, and Android build

**Estimated Effort:** 4-5 days for solo developer

**Critical Dependencies:**
- Depends on Epic 2 (API endpoints `/api/search` and `/api/quran` must be working)
- Depends on Epic 1 (Flutter shell and theming established)
- Story 3.6 (Onboarding) can be deferred if timeline is tight

**Definition of Done:**
- All 8 stories completed with acceptance criteria met (Story 3.6 optional)
- App runs smoothly on both iOS and Android devices
- Core user journey functional: Record → Identify → Read
- Error states handled gracefully with user-friendly messaging
- Design follows spiritual minimalism with dark green/snow white branding
- Performance: App launch ≤2 seconds (NFR1), Quran reader load ≤1 second (NFR2)
