# User Journeys

This document describes the key user journeys in Lawh, mapping the end-to-end experience from user intent to outcome. These journeys support traceability from business goals to functional requirements.

---

## Journey 1: New User First Search

**Persona:** First-time user who just downloaded Lawh after hearing a beautiful recitation at the mosque.

**Goal:** Identify the verse they just heard.

**Trigger:** User hears a Quranic recitation and wants to know which verse it is.

### Steps

| Step | User Action | System Response | FR Reference |
|------|-------------|-----------------|--------------|
| 1 | Opens Lawh for the first time | App launches, generates anonymous UUID, displays Home screen with prominent "Listen" button. No banner ads on first session. | FR7, FR13 |
| 2 | Taps "Listen" button | Recording UI appears with progress indicator and waveform visualization | FR1 |
| 3 | Records 5-15 seconds of recitation | Audio validated client-side for duration and volume | FR1, FR19 |
| 4 | Recording stops (auto at 15s or manual) | "Identifying verse..." loading state. No interstitial ad on first search. | FR14, FR15 |
| 5 | Waits ≤5 seconds | STT transcription + fuzzy matching executed server-side | FR1, FR2, FR15 |
| 6 | Views results | Confidence-based display: 1 result (high), 2-3 results (medium), or retry prompt (low) | FR3 |
| 7 | Taps identified verse | In-app Quran reader opens at verse location | FR4 |
| 8 | Reads verse in context | Full Madinah Mushaf displayed with verse highlighted | FR4 |

**Success Criteria:** User identifies verse within 10 seconds of tapping Listen (excluding recording time).

**Supports Goals:** Technical Feasibility (85%+ accuracy), 5000+ User Searches

---

## Journey 2: Returning User Search (Free Tier)

**Persona:** Returning user on free tier who has used the app before.

**Goal:** Identify another verse they heard.

**Trigger:** User hears a recitation during Friday prayer.

### Steps

| Step | User Action | System Response | FR Reference |
|------|-------------|-----------------|--------------|
| 1 | Opens Lawh | App launches, checks usage limits (3/day, 10/month), displays Home screen with banner ad at bottom | FR10, FR13 |
| 2 | Taps "Listen" button | Interstitial ad displayed (skippable after 5 seconds) | FR14 |
| 3 | Ad completes/skipped | Recording UI appears | FR14 |
| 4 | Records recitation | Audio captured and validated | FR1, FR19 |
| 5 | Recording stops | Processing begins, result returned in ≤5 seconds | FR2, FR15 |
| 6 | Views results | Confidence-based result display | FR3 |
| 7 | Provides feedback | Taps thumbs up/down or "none of these" | FR5 |
| 8 | Taps verse to read | Quran reader opens | FR4 |
| 9 | Navigates to Recent Tab | Views list of recently identified verses | FR11 |

**Alternate Flow - Limit Reached:**
- At Step 2, if daily/monthly limit reached, system displays upgrade prompt instead of recording UI
- User sees subscription options ($1/month or $10/year)

**Success Criteria:** User completes search with minimal ad friction; Recent Tab enables quick reference to past searches.

**Supports Goals:** Cost Sustainability (ad revenue), 5000+ User Searches

---

## Journey 3: Free-to-Paid Conversion

**Persona:** Active free tier user who has hit usage limits or wants ad-free experience.

**Goal:** Upgrade to paid subscription for unlimited, ad-free searches.

**Trigger:** User reaches daily limit OR is frustrated by interstitial ads.

### Steps

| Step | User Action | System Response | FR Reference |
|------|-------------|-----------------|--------------|
| 1 | Reaches limit OR taps "Remove Ads" | Subscription screen displayed with two options: $1/month, $10/year | FR9, FR10 |
| 2 | Reviews subscription benefits | Clear display: unlimited searches, no ads, same Recent Tab access | FR9 |
| 3 | Selects subscription tier | RevenueCat SDK initiates Apple IAP or Google Play Billing flow | FR9 |
| 4 | Completes payment | Platform-native payment UI (Face ID/fingerprint for Apple, Google Play flow) | FR9 |
| 5 | Payment confirmed | Subscription status updated locally and synced to backend | FR12 |
| 6 | Returns to Home screen | Banner ad removed, interstitial ads disabled | FR13, FR14 |
| 7 | Performs search | No interstitial, no limits, full experience | FR9 |

**Alternate Flow - Restore Purchase:**
- User taps "Restore Purchases" on subscription screen
- RevenueCat checks existing entitlements
- If valid subscription found, features unlocked immediately

**Success Criteria:** Conversion completes in <60 seconds with platform-native payment experience.

**Supports Goals:** Cost Sustainability (subscription revenue), 1000 Active Users

---

## Journey 4: Feedback Submission

**Persona:** Any user who has completed a search and wants to improve the system.

**Goal:** Provide feedback on search accuracy to help improve the algorithm.

**Trigger:** User sees search results and knows whether they're correct.

### Steps

| Step | User Action | System Response | FR Reference |
|------|-------------|-----------------|--------------|
| 1 | Views search results | Results displayed with thumbs up/down buttons and "None of these" option | FR3, FR5 |
| 2a | Taps thumbs up on correct result | Positive feedback recorded with search ID and result index | FR5, FR17 |
| 2b | Taps thumbs down on incorrect result | Negative feedback recorded | FR5, FR17 |
| 2c | Taps "None of these" | Negative feedback recorded indicating all results wrong | FR5, FR17 |
| 3 | Taps a result to view | Implicit feedback: which result clicked, timestamp | FR6, FR17 |
| 4 | Spends time reading verse | Implicit feedback: time spent on result (engagement signal) | FR6 |
| 5 | Returns to results or exits | Session data compiled and stored for algorithm improvement | FR17 |

**Implicit Feedback (Background):**
- System automatically tracks which result was clicked
- Time spent viewing each result
- Whether user performed another search immediately (retry signal)
- Session duration and return visits

**Success Criteria:** Feedback captured with zero friction; user doesn't feel surveyed.

**Supports Goals:** 5000+ User Searches with Feedback, Technical Feasibility (data for algorithm improvement)

---

## Journey 5: Error Recovery

**Persona:** Any user who encounters an error during search.

**Goal:** Understand what went wrong and successfully complete their search.

**Trigger:** Search fails due to network, audio quality, or low confidence.

### Steps

| Step | User Action | System Response | FR Reference |
|------|-------------|-----------------|--------------|
| 1 | Attempts search | Error occurs during processing | FR18 |
| 2a | **Network Error:** | "Connection lost. Please check your internet and try again." with retry button | FR18, FR20 |
| 2b | **Audio Quality Error:** | "Audio too quiet. Please move closer to the source and try again." | FR18, FR19 |
| 2c | **Low Confidence (<55%):** | "Could not identify verse. Please try recording a longer or clearer sample." | FR3, FR18 |
| 2d | **STT API Unavailable:** | "Service temporarily unavailable. Please try again in a moment." | FR18 |
| 3 | User follows guidance | Retry button available, clear next steps provided | FR18 |
| 4 | Retries search | New attempt with improved conditions | FR1 |

**Success Criteria:** User understands error cause and can take corrective action; no dead ends.

**Supports Goals:** 1000 Active Users (retention through good error UX)

---

## Journey Map Summary

| Journey | Primary Goal | Key FRs | Success Metric |
|---------|--------------|---------|----------------|
| New User First Search | First successful identification | FR1-4, FR7, FR13-15 | <10 sec to result |
| Returning User (Free) | Repeat usage with monetization | FR1-6, FR10-14 | DAU retention |
| Free-to-Paid Conversion | Subscription revenue | FR9, FR10, FR12 | 5%+ conversion |
| Feedback Submission | Algorithm improvement data | FR5, FR6, FR17 | 75%+ feedback rate |
| Error Recovery | User retention | FR18-20 | <5% abandonment |

---
