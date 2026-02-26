# User Interface Design Goals

## Overall UX Vision

Lawh's user experience embodies spiritual simplicity and immediate utility. The interface prioritizes speed and clarity over complexity, reflecting the sacred nature of its content. Users should feel confident and calm when using the app—no cognitive load, no distractions, just a clear path from "I heard something beautiful" to "now I can read it."

The design philosophy follows these principles:
- **Spiritual Minimalism:** Clean, uncluttered screens that respect the religious context
- **Instant Clarity:** Every action has one clear outcome with no hidden menus or complex navigation
- **Trust Through Transparency:** Confidence indicators and clear feedback build user trust
- **Respectful Interaction:** No gamification, no manipulative patterns, no intrusive elements

The overall feel should be: **serene, trustworthy, and effortless.**

## Key Interaction Paradigms

1. **One-Tap Recording:** Primary action is a prominent "Listen" button on the main screen—tap once to start, automatically stops at 15 seconds or tap again to complete early (if ≥10 sec)

2. **Confidence-Aware Results:** Visual design adapts to system confidence—high confidence shows single result with prominent "This is the verse" messaging; medium confidence shows 2-3 options with clear selection affordances; low confidence shows encouraging retry message

3. **Seamless Reading Flow:** Tapping a verse result immediately opens in-app Quran reader at that exact location, preserving scroll position and allowing natural reading continuation

4. **Frictionless Feedback:** Thumbs up/down buttons are always visible but never intrusive—positioned naturally at bottom of results, never blocking content

5. **Clear Freemium Value:** Free tier shows usage counter (searches remaining) and non-intrusive banner ads; "Upgrade to Premium" button is accessible but respectful, encouraging subscription to remove ads and limits without pressure

6. **Contextual Location Collection:** Location data (city/region) is collected at the time of each search (tied to search context) rather than as a one-time permission, with clear opt-in/opt-out capability

7. **Respectful Ad Integration:** Banner ads appear at screen bottom (non-intrusive), interstitial ads appear before searches (after first search)—ads never interrupt reading, results viewing, or the Quran reader experience. First-time users get an ad-free first session

## Core Screens and Views

From a product perspective, these are the critical screens necessary to deliver the PRD values and goals:

1. **Main Screen (Listen/Home)**
   - Large, centered "Listen" button (primary CTA)
   - Visual feedback during 10-15 second recording (progress indicator, waveform animation)
   - **Free tier usage counter** ("3/3 searches today" or "Upgrade to Premium")
   - **"Upgrade to Premium" button** (secondary CTA for free users, clearly visible but not blocking primary action)
   - **Banner ad at bottom** (free tier only, not during first app session)
   - Settings icon (top-right corner)
   - Navigation to Explore (Recent Tab) page

2. **Results Screen**
   - Verse identification(s) with confidence indicator
   - Surah name + verse number (e.g., "Al-Baqarah 2:255")
   - Preview text snippet (first few words in Arabic)
   - Thumbs up/down feedback buttons
   - "None of these" option (if multiple results)
   - "Try again" button
   - Tap result → opens Quran Reader

3. **Quran Reader Screen**
   - Full-page Madinah Mushaf text display
   - Identified verse highlighted with subtle visual indicator
   - Scrollable to read surrounding context
   - Simple "Back to Search" navigation
   - Minimal chrome/UI elements to focus on text

4. **Explore Page (Recent Tab)**
   - List of last 20 identified verses (surah name, verse number, timestamp)
   - Tap to re-open in Quran Reader
   - **Available to ALL users** (free and paid)
   - **Banner ad at bottom** (free tier only, not during first app session)
   - Quick access to previously identified verses without re-recording

5. **Settings Screen**
   - Location sharing toggle with explanation ("Collected with each search to understand regional recitation preferences")
   - Privacy policy link
   - Data deletion request option
   - About Lawh section
   - Support/Feedback contact
   - "Manage Subscription" link (upgrade, restore purchases, view status)

6. **Error/Retry Screen**
   - User-friendly error messaging (per FR13)
   - Clear guidance: "Try recording in a quieter space" or "Check your internet connection"
   - "Try Again" button prominently displayed

7. **Paywall/Subscription Screen**
   - Triggered when free tier limit reached (3/day or 10/month)
   - Clear value proposition: "Unlock unlimited searches + remove all ads"
   - Pricing options: $1/month or $10/year (2 months free)
   - "Restore Purchases" link for reinstalls
   - "Maybe Later" dismissal option (returns to main screen)
   - Design: Non-manipulative, respectful presentation

8. **First-Launch Onboarding (Optional)**
   - 2-3 screens maximum explaining: "Hear a verse → Tap Listen → Get the verse"
   - Location permission explanation (collected with each search)
   - Skippable without penalty

## Accessibility: Basic for MVP

Target: **Basic accessibility** for MVP, with WCAG AA compliance deferred to Phase 2

**MVP Accessibility:**
- Dynamic text sizing respecting platform preferences (iOS Dynamic Type, Android font scaling)
- Minimum color contrast ratio 4.5:1 for all text
- Touch targets minimum 44x44pt (iOS) / 48x48dp (Android)
- No reliance on color alone for critical information (e.g., confidence indicators use text + color)

**Deferred to Phase 2:**
- Screen reader support (VoiceOver, TalkBack) - not priority for MVP
- Full WCAG AA compliance testing
- Keyboard navigation for web version

**Rationale:** Prioritizes core functionality delivery within 4-week timeline while maintaining basic usability standards. Full accessibility features added post-MVP validation.

## Branding

**Visual Identity:**
- **Color Palette:**
  - Primary: Dark green (dark lemon shade) conveying growth, nature, and Islamic tradition
  - Secondary: Snow white for clarity and purity
  - Accent: Complementary warm tones (gold, cream) for highlights and interactive elements
- **Typography:** Clean, highly readable sans-serif for UI (SF Pro/Roboto); traditional Arabic font (Uthmani script) for Quran text
- **Iconography:** Simple, geometric icons avoiding representational imagery (culturally appropriate)
- **Tone:** Respectful, helpful, never casual or playful

**Cultural Considerations:**
- No human/animal imagery (adhering to conservative Islamic design preferences)
- Right-to-left (RTL) layout support for Arabic text
- Color choices avoid culturally insensitive combinations
- "Lawh" branding emphasizes connection to Islamic tradition (Al-Lawh Al-Mahfuz)

## Target Device and Platforms: Mobile-First Cross-Platform

**Primary Platforms (MVP Priority):**
- **iOS (13+):** iPhone and iPad support, optimized for mobile-first usage
- **Android (8.0+):** Phone and tablet support, cross-device compatibility

**Secondary Platform (Stretch Goal/Phase 2):**
- **Web (Modern Browsers):** Chrome, Safari, Firefox, Edge—responsive design for desktop and mobile web

**Platform Prioritization for MVP:**
- **Week 1-3:** Flutter mobile development (iOS + Android simultaneously)
- **Week 3-4:** Testing, refinement, app store submission preparation
- **Phase 2:** Web deployment using Flutter Web or separate React/Vue.js implementation

**Design Approach:**
- Mobile-first responsive design (most users will be on phones in mosques/outdoor environments)
- Platform-specific UI patterns where appropriate (iOS navigation vs Android Material Design)
- Consistent core functionality across all platforms when web launches

---
