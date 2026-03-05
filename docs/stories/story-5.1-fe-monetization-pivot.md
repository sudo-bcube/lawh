# Story 5.1-FE: Frontend Monetization Pivot - Remove Donations, Implement Ads & Subscriptions

Status: complete

## Story

As a **user**,
I want **to access Lawh with a freemium model (limited free tier with ads, unlimited paid tier without ads)**,
so that **I can try the app for free and upgrade if I find value, while the app remains sustainable**.

## Context

This story pivots the monetization strategy from Sadaqah (donation-based) to freemium (subscriptions + ads). The backend will handle this separately. This story focuses exclusively on **frontend implementation**.

**What's being removed:**
- All donation/Sadaqah functionality (Stripe integration, donation UI, payment flows)

**What's being implemented:**
- RevenueCat SDK for subscription management
- Google AdMob for advertisements (banner, interstitial, and rewarded video)
- Free tier usage limits (3/day, 10/month)
- Paywall UI when limits reached
- **Watch-to-unlock:** Rewarded video ads to earn bonus searches when limits exceeded

## Acceptance Criteria

### Removal (Donations)

1. **AC1:** All donation-related code is removed from the codebase:
   - `lib/features/donation/` directory completely removed
   - `stripe_flutter` package removed from pubspec.yaml
   - No Stripe SDK initialization or configuration remains
   - "Support Lawh (Sadaqah)" button removed from Settings screen
   - All donation-related providers, models, and repositories deleted

### Subscriptions (RevenueCat)

1. **AC2:** RevenueCat SDK integrated for both iOS and Android:
   - `purchases_flutter` package added to pubspec.yaml
   - SDK initialized on app startup with API keys
   - Configured for sandbox (dev) and production modes

2. **AC3:** Subscription tiers displayed correctly:
   - Monthly: $1/month (auto-renewing)
   - Yearly: $10/year (auto-renewing, "2 months free" badge)

3. **AC4:** Subscription status checked and cached:
   - On app launch: Check RevenueCat for current entitlements
   - Cache "premium" entitlement locally for offline access
   - Handle states: active, expired, cancelled, grace period

4. **AC5:** Paywall screen implemented:
   - Full-screen paywall when free limits reached
   - Shows: Features unlocked, pricing options, restore purchases button
   - Text: "Unlock unlimited verse identification and remove all ads"
   - "Upgrade" button accessible from Settings at any time

5. **AC6:** Restore purchases functionality:
   - "Restore Purchases" button in Settings and paywall
   - Handles family sharing and device transfers

### Advertisements (AdMob)

1. **AC7:** Google AdMob SDK integrated:
   - `google_mobile_ads` package added
   - Ad unit IDs configured (test IDs for dev, production for release)
   - GDPR/CCPA consent via AdMob User Messaging Platform (UMP)

2. **AC8:** Banner ads displayed correctly:
   - Bottom of Home screen
   - Bottom of Explore (Recent Tab) page
   - Adaptive banner size
   - NO banner during user's first app session

3. **AC9:** Interstitial ads displayed correctly:
   - Shown BEFORE initiating a search (after tapping "Listen")
   - First-ever search is ad-free
   - Skippable after 5 seconds
   - Loading indicator while ad loads

4. **AC10:** Paid users see no ads:
    - Check "premium" entitlement before showing any ad
    - No ad placeholders visible for subscribers

### Rewarded Video Ads (Watch-to-Unlock)

1. **AC11:** Rewarded video ad integration:
    - Rewarded ad unit ID configured (separate from banner/interstitial)
    - Rewarded ads preloaded when user approaches limit (2/3 daily or 8/10 monthly)
    - Test rewarded ad IDs for development

2. **AC12:** Watch-to-unlock flow when limits reached:
    - Present option: "Watch a short video to unlock 1 extra search"
    - Alternative to subscription paywall (both options shown)
    - User must watch complete video (non-skippable, 15-30 seconds)
    - Upon completion: Grant 1 bonus search immediately
    - Show confirmation: "Bonus search unlocked!"

3. **AC13:** Bonus search constraints:
    - Maximum 3 bonus searches per day via rewarded ads (prevents abuse)
    - Bonus searches do NOT roll over (use within session/day)
    - Track bonus searches separately from regular limit
    - Display: "X bonus searches available" when earned

4. **AC14:** Rewarded ad error handling:
    - If rewarded ad fails to load: Show "No ads available, try again later"
    - Provide "Retry" button to attempt reload
    - Always show subscription option as fallback

### Free Tier Limits

1. **AC15:** Usage limits enforced:
    - Maximum 3 searches per day
    - Maximum 10 searches per month
    - Counter displayed: "3/3 searches used today" or "10/10 this month"
    - Limits reset at midnight local time (daily) and calendar month (monthly)

2. **AC16:** When limits reached, present options:
    - **Option A:** "Watch a short video to unlock 1 search" (rewarded ad - AC12)
    - **Option B:** "Upgrade to Premium for unlimited searches" (paywall - AC5)
    - Both options visible on same screen
    - Clear value proposition for each option

### First-Time User Experience

1. **AC17:** First session is ad-light:
    - No banner ads during first app session (until app closed/reopened)
    - No interstitial before first-ever search
    - Rewarded ads available from first session (user-initiated only)
    - Track "first_session" and "first_search_completed" flags in SharedPreferences

## Tasks / Subtasks

### Phase 1: Remove Donation Feature

- [ ] Task 1: Remove donation feature folder (AC: #1)
  - [ ] Delete `lib/features/donation/` directory entirely
  - [ ] Remove all imports referencing donation feature across codebase
  - [ ] Remove donation-related routes if any

- [ ] Task 2: Remove Stripe dependency (AC: #1)
  - [ ] Remove `stripe_flutter` from pubspec.yaml
  - [ ] Remove any Stripe configuration (API keys, initialization)
  - [ ] Run `flutter pub get` to update dependencies

- [ ] Task 3: Update Settings screen (AC: #1)
  - [ ] Remove "Support Lawh (Sadaqah)" button/tile
  - [ ] Add "Upgrade to Premium" tile (for non-subscribers)
  - [ ] Add "Manage Subscription" tile (for subscribers)
  - [ ] Add "Restore Purchases" tile

### Phase 2: Implement RevenueCat Subscriptions

- [ ] Task 4: Add RevenueCat SDK (AC: #2)
  - [ ] Add `purchases_flutter: ^6.0.0` to pubspec.yaml
  - [ ] Create `lib/features/subscription/` feature folder
  - [ ] Create subscription data layer structure

- [ ] Task 5: Initialize RevenueCat (AC: #2)
  - [ ] Create `subscription_datasource.dart` wrapping Purchases SDK
  - [ ] Initialize in `main.dart` with platform-specific API keys
  - [ ] Configure debug logging for development

- [ ] Task 6: Create subscription state management (AC: #4)
  - [ ] Create `subscription_provider.dart` using Riverpod
  - [ ] Create `subscription_status.dart` model (active, expired, cancelled, grace_period, free)
  - [ ] Check entitlements on app launch
  - [ ] Cache status in SharedPreferences for offline access

- [ ] Task 7: Implement paywall screen (AC: #3, #5)
  - [ ] Create `paywall_screen.dart` with subscription options
  - [ ] Display monthly ($1/mo) and yearly ($10/yr) options
  - [ ] Show "2 months free" badge on yearly
  - [ ] Implement purchase flow via RevenueCat
  - [ ] Handle purchase success/failure states

- [ ] Task 8: Implement restore purchases (AC: #6)
  - [ ] Add restore function in subscription repository
  - [ ] Add "Restore Purchases" in paywall and Settings
  - [ ] Handle restore success/no-purchases-found states

### Phase 3: Implement AdMob Advertisements

- [ ] Task 9: Add AdMob SDK (AC: #7)
  - [ ] Add `google_mobile_ads: ^5.0.0` to pubspec.yaml
  - [ ] Create `lib/features/ads/` feature folder
  - [ ] Initialize AdMob in `main.dart`
  - [ ] Configure test ad unit IDs for development

- [ ] Task 10: Implement banner ads (AC: #8, #10)
  - [ ] Create `banner_ad_widget.dart` component
  - [ ] Create `ads_provider.dart` for ad state management
  - [ ] Add banner to Home screen (bottom)
  - [ ] Add banner to Explore/Recent Tab (bottom)
  - [ ] Skip banner if premium OR first session

- [ ] Task 11: Implement interstitial ads (AC: #9, #10)
  - [ ] Create `interstitial_ad_service.dart`
  - [ ] Preload interstitial on app start
  - [ ] Show before search (after "Listen" tap)
  - [ ] Skip if premium OR first-ever search
  - [ ] Show loading indicator while ad loads
  - [ ] Handle ad not available (proceed without ad)

- [ ] Task 12: Implement GDPR/CCPA consent (AC: #7)
  - [ ] Integrate AdMob UMP SDK
  - [ ] Show consent dialog for EU users on first launch
  - [ ] Store consent status
  - [ ] Pass consent to ad requests

- [ ] Task 13: Implement rewarded video ads (AC: #11, #12, #14)
  - [ ] Create `rewarded_ad_service.dart`
  - [ ] Configure rewarded ad unit ID
  - [ ] Preload rewarded ad when user approaches limit
  - [ ] Implement watch completion callback
  - [ ] Handle ad load failures with retry option

### Phase 4: Implement Free Tier Limits

- [ ] Task 14: Create usage tracking (AC: #15)
  - [ ] Create `usage_tracker_service.dart`
  - [ ] Track daily searches (reset at midnight local)
  - [ ] Track monthly searches (reset on 1st of month)
  - [ ] Track bonus searches earned (reset daily)
  - [ ] Store counts in SharedPreferences
  - [ ] Create `usage_provider.dart` for UI access

- [ ] Task 15: Display usage counter (AC: #15)
  - [ ] Show "X/3 searches today" on Home screen
  - [ ] Show "X/10 searches this month" in Settings or Home
  - [ ] Show "X bonus searches available" when earned
  - [ ] Update counter after each search

- [ ] Task 16: Enforce limits with watch-to-unlock (AC: #16, #12, #13)
  - [ ] Check limits before allowing search
  - [ ] If limit reached AND bonus available: Allow search, decrement bonus
  - [ ] If limit reached AND no bonus: Show limit-reached screen with options
  - [ ] Create `limit_reached_screen.dart` with two CTAs:
    - "Watch Video for 1 Search" (triggers rewarded ad)
    - "Upgrade to Premium" (triggers paywall)
  - [ ] On rewarded ad completion: Grant bonus, increment bonus counter
  - [ ] Enforce max 3 bonus per day
  - [ ] Premium users bypass all limits

### Phase 5: First-Time User Experience

- [ ] Task 17: Track first-time flags (AC: #17)
  - [ ] Store "first_session_completed" flag
  - [ ] Store "first_search_completed" flag
  - [ ] Set "first_session_completed" on app close/background
  - [ ] Set "first_search_completed" after first successful search

- [ ] Task 18: Implement ad-light first experience (AC: #17)
  - [ ] Banner ads: Check first_session_completed before showing
  - [ ] Interstitial: Check first_search_completed before showing
  - [ ] Rewarded ads: Always available (user-initiated)

## Dev Notes

### Architecture Alignment

This implementation follows the existing feature-first + clean architecture:

```
lib/features/
├── subscription/
│   ├── presentation/
│   │   ├── screens/
│   │   │   └── paywall_screen.dart
│   │   ├── widgets/
│   │   │   ├── subscription_tile.dart
│   │   │   └── usage_counter.dart
│   │   └── providers/
│   │       └── subscription_provider.dart
│   ├── domain/
│   │   ├── models/
│   │   │   └── subscription_status.dart
│   │   └── repositories/
│   │       └── subscription_repository.dart
│   └── data/
│       ├── repositories/
│       │   └── revenuecat_subscription_repository_impl.dart
│       └── datasources/
│           └── revenuecat_datasource.dart
│
├── ads/
│   ├── presentation/
│   │   ├── widgets/
│   │   │   └── banner_ad_widget.dart
│   │   ├── screens/
│   │   │   └── limit_reached_screen.dart
│   │   └── providers/
│   │       └── ads_provider.dart
│   ├── domain/
│   │   └── services/
│   │       ├── interstitial_ad_service.dart
│   │       └── rewarded_ad_service.dart
│   └── data/
│       └── datasources/
│           └── admob_datasource.dart
│
└── usage/
    ├── presentation/
    │   └── providers/
    │       └── usage_provider.dart
    └── domain/
        └── services/
            └── usage_tracker_service.dart
```

### Key Dependencies

```yaml
# Add to pubspec.yaml
dependencies:
  purchases_flutter: ^6.0.0        # RevenueCat
  google_mobile_ads: ^5.0.0        # AdMob

# Remove from pubspec.yaml
# stripe_flutter: ^11.0+           # DELETE THIS
```

### Platform Configuration Required

**iOS (ios/Runner/Info.plist):**
- Add AdMob App ID: `GADApplicationIdentifier`
- Add SKAdNetwork identifiers for ad attribution

**Android (android/app/src/main/AndroidManifest.xml):**
- Add AdMob App ID as meta-data
- Add internet permission (likely already present)

### Testing Standards

- Unit tests for subscription_provider, usage_tracker_service, rewarded_ad_service
- Widget tests for paywall_screen, banner_ad_widget, limit_reached_screen
- Integration test: Full subscription flow (use sandbox)
- Integration test: Ad display - banner, interstitial, rewarded (use test ad IDs)
- Integration test: Watch-to-unlock flow (rewarded ad → bonus search granted)

### References

- [Source: /Users/omoba/Documents/personal-projects/lawh/docs/prd/epic-5-monetization-launch.md#Story-5.1] - Subscription requirements
- [Source: /Users/omoba/Documents/personal-projects/lawh/docs/prd/epic-5-monetization-launch.md#Story-5.1b] - Advertisement requirements
- [Source: /Users/omoba/Documents/personal-projects/lawh/docs/prd/requirements.md#FR9-FR14] - Monetization functional requirements
- [Source: /Users/omoba/Documents/personal-projects/lawh/docs/architecture/frontend/project-structure.md] - Feature folder structure
- [Source: /Users/omoba/Documents/personal-projects/lawh/docs/architecture/frontend/state-management.md] - Riverpod patterns
- [Source: /Users/omoba/Documents/personal-projects/lawh/docs/architecture/frontend/clean-architecture.md] - Layer separation
- [Source: /Users/omoba/Documents/personal-projects/lawh/docs/architecture/frontend/tech-stack.md] - Dependencies
- [Source: /Users/omoba/Documents/personal-projects/lawh/docs/architecture/frontend/routing.md] - Navigation patterns

### API Keys (Environment Variables)

```dart
// Use environment variables, NOT hardcoded
const revenueCatApiKeyIos = String.fromEnvironment('REVENUECAT_IOS_KEY');
const revenueCatApiKeyAndroid = String.fromEnvironment('REVENUECAT_ANDROID_KEY');
const adMobAppIdIos = String.fromEnvironment('ADMOB_IOS_APP_ID');
const adMobAppIdAndroid = String.fromEnvironment('ADMOB_ANDROID_APP_ID');

// Test Ad Unit IDs (safe to commit - Google's official test IDs)
const testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
const testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
const testRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
```

## Dev Agent Record

### Agent Model Used

(To be filled by dev agent)

### Debug Log References

(To be filled during implementation)

### Completion Notes List

(To be filled during implementation)

### File List

(To be filled during implementation)
