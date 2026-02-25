# Epic 5: Monetization & Launch Preparation

**Expanded Goal:** Add Sadaqah donation integration (Stripe), complete app store submission requirements (privacy labels, screenshots, testing), final polish, and production deployment with basic error logging. This epic transforms the working prototype into a production-ready, publicly available product and validates cost sustainability (Goal #4).

---

## Story 5.1: Sadaqah Donation Integration (Stripe)

**As a** user,
**I want** to support Lawh's development through voluntary donations,
**so that** the app can remain free and accessible to all Muslims.

### Acceptance Criteria

1. **Donation button placement (per UI goals):**
   - Prominent "Support Lawh (Sadaqah)" button on main screen below "Listen" button
   - Same button accessible in Settings screen
2. **Donation flow:**
   - Tap button opens donation screen
   - Pre-set donation amounts: $5, $10, $25, $50, Custom amount
   - Currency selector: USD, EUR, GBP, SAR (Saudi Riyal), others as needed
   - Text: "Your donation helps keep Lawh free for everyone. Jazakallah Khair (May Allah reward you)."
3. **Stripe integration:**
   - Stripe Payment Sheet (mobile SDK) for secure payment processing
   - Supports credit/debit cards, Apple Pay (iOS), Google Pay (Android)
   - International donations supported (FR9 requirement)
   - Test mode for development, production mode for launch
4. **Payment processing:**
   - Backend endpoint: `POST /api/donate` handles Stripe payment intent creation
   - Stripe webhook: `/api/webhooks/stripe` receives payment confirmation
   - Donation recorded in database: user_uuid (optional, anonymous), amount, currency, status, timestamp
5. **Confirmation flow:**
   - Success: "Thank you for your support! Jazakallah Khair" with animated checkmark
   - Failure: "Payment failed - please try again or contact support"
   - Email receipt (optional, if user provides email)
6. **Privacy:** Donation is anonymous (linked to UUID only if user is active, no personal data required)
7. **Stripe fees:** Document fee structure (2.9% + $0.30) for cost analysis (Epic 6)
8. Test: Process test donation in Stripe test mode, verify backend receives webhook, donation recorded

---

## Story 5.2: App Store Assets & Metadata

**As a** developer,
**I want** all required app store assets prepared for iOS App Store and Google Play submission,
**so that** Lawh can be publicly available for download.

### Acceptance Criteria

1. **App Store Screenshots (iOS & Android):**
   - 5-6 screenshots per platform showcasing:
     - Main screen with "Listen" button
     - Recording UI in action
     - Results screen (high confidence, 1 result)
     - Quran reader with highlighted verse
     - Settings screen with privacy controls
   - iOS: Sizes for iPhone (6.5", 5.5") and iPad (12.9")
   - Android: Sizes for phone and tablet (1080x1920, 2560x1440)
   - Culturally appropriate: No people, respectful imagery, Arabic text visible
2. **App descriptions:**
   - Short description (80 chars): "Identify Quranic verses from live recitations instantly"
   - Full description (4000 chars): Explains problem, solution, features, privacy-first approach
   - Keywords: Quran, verse identification, recitation, Shazam for Quran, Lawh, Islamic app
3. **App icon:**
   - High-resolution (1024x1024) app icon following brand guidelines
   - Dark green (dark lemon) with "Lawh" or abstract Islamic geometric design
   - No text (iOS requirement), recognizable at small sizes
4. **Promotional assets:**
   - Feature graphic (1024x500 for Google Play)
   - Promo video (optional, 30 seconds showing app usage)
5. **App Store metadata:**
   - Category: Reference, Books, or Education
   - Content rating: 4+ (iOS), Everyone (Android)
   - Support URL, privacy policy URL, marketing URL
6. All assets reviewed and approved by stakeholder before submission

---

## Story 5.3: Privacy Nutrition Labels & Data Safety Forms

**As a** developer,
**I want** App Store privacy labels and Google Play data safety forms completed accurately,
**so that** users trust how their data is handled and app approval isn't delayed.

### Acceptance Criteria

1. **iOS App Store Privacy Nutrition Label:**
   - Data collected: Location (optional, city/region), Usage Data (searches, feedback)
   - Data linked to user: Anonymous UUID only
   - Data not collected: Name, email, phone, precise location, browsing history
   - Data used for: App functionality, analytics, product personalization
   - Third-party data: Azure STT (audio transcription only, not stored), Stripe (payment processing)
2. **Google Play Data Safety Form:**
   - Similar disclosures as iOS
   - Encryption: In transit (HTTPS), at rest (database encryption)
   - Data deletion: Users can request deletion via Settings
   - Data sharing: No data sold or shared with third parties except service providers (Azure, Stripe)
3. **Privacy Policy (required for both platforms):**
   - Hosted at public URL (e.g., lawh.app/privacy)
   - Written in plain language (not legalese)
   - Covers: What data collected, why, how used, user rights (deletion, opt-out), third-party services, retention policy
   - GDPR and CCPA compliant (NFR7, NFR8)
   - Link included in app (Settings screen) and app store listings
4. **Terms of Service (optional but recommended):**
   - Covers: Acceptable use, disclaimer (not for religious fatwa), liability limits
5. Labels/forms reviewed for accuracy - mismatch with actual behavior causes rejection
6. Test: Submit test app with privacy labels to TestFlight/Internal Testing, validate no warnings

---

## Story 5.4: Final Cross-Platform Testing & Bug Fixes

**As a** QA tester (developer wearing QA hat),
**I want** comprehensive testing across devices, OS versions, and edge cases,
**so that** users have a stable, bug-free experience at launch.

### Acceptance Criteria

1. **Device coverage:**
   - iOS: Test on 3+ devices (iPhone SE, iPhone 14, iPad)
   - Android: Test on 3+ devices (Pixel, Samsung, mid-range phone)
   - OS versions: iOS 13-17, Android 8-14
2. **Functional testing:**
   - Complete user journey: Record → Identify → Read (happy path)
   - All edge cases: Low confidence results, no match, errors (network, API, permissions)
   - Settings: Location toggle, data deletion, donation flow
   - Feedback: Thumbs up/down, implicit tracking
3. **Performance testing:**
   - App launch time: ≤2 seconds (NFR1)
   - Search time: ≤5 seconds (FR10)
   - Quran reader load: ≤1 second (NFR2)
   - Memory usage stable (no leaks)
4. **Audio testing:**
   - Various audio quality: High-quality recording, mosque audio (reverb/echo), background noise
   - Different reciters: Test with 5+ different voices
   - Volume levels: Loud, moderate, quiet (should reject too quiet per FR14)
5. **UI/UX polish:**
   - Animations smooth (no jank)
   - Text readable (contrast, sizing)
   - Buttons responsive (no double-tap bugs)
   - Navigation intuitive (back buttons, gestures work)
6. **Edge case testing:**
   - Airplane mode (graceful offline handling per FR15)
   - App backgrounded during recording (resumes or cancels appropriately)
   - Rapid button tapping (no crashes)
   - Very long/short recordings
7. **Bug tracking:**
   - All bugs logged with severity (critical, major, minor)
   - Critical/major bugs fixed before launch
   - Minor bugs documented for Phase 2
8. **Regression testing:** After bug fixes, re-test affected areas to ensure no new issues introduced

---

## Story 5.5: Production Backend Deployment

**As a** developer,
**I want** the backend API deployed to production environment with monitoring,
**so that** the app is stable, secure, and observable in production.

### Acceptance Criteria

1. **Production environment setup:**
   - Backend deployed to DigitalOcean Droplet or Heroku production tier
   - Domain configured: `https://api.lawh.app` or similar (not "staging")
   - SSL/TLS certificate (Let's Encrypt or provider-managed)
   - PostgreSQL database on production tier (managed service recommended)
2. **Environment configuration:**
   - Production environment variables: Azure STT prod keys, Stripe live keys, database prod credentials
   - Secrets management: Keys stored securely (not in code), rotated if compromised
   - CORS configured for production mobile app domains
3. **Production data:**
   - Quran database populated (same as staging)
   - No test data in production (clean database)
4. **Backup & disaster recovery (NFR16, NFR17):**
   - Automated daily database backups configured (DigitalOcean managed backups or pg_dump cron job)
   - Backup retention: 30 days
   - Backup scope: All tables (users, searches, feedback, analytics, quran_verses)
   - Backup verification: Test restore to separate database before launch
   - Recovery documentation: Step-by-step restoration procedure documented in `/docs/disaster-recovery.md`
   - RTO target: 4 hours maximum downtime
   - RPO target: 24 hours maximum data loss (daily backups)
5. **Monitoring & logging (basic for MVP):**
   - Error logging: Sentry, Rollbar, or custom logging to file/database
   - Uptime monitoring: UptimeRobot, Pingdom, or similar (free tier)
   - Log critical errors: API failures, database errors, Azure STT failures
   - Alerts: Email/SMS notification for critical errors (optional for MVP)
5. **Performance baseline:**
   - Health-check endpoint: `GET https://api.lawh.app/health` returns 200 OK
   - API response time: <3 seconds for 95th percentile (documented baseline for Epic 6)
   - Database connection pool sized for expected load (50 concurrent, NFR10)
6. **Deployment process:**
   - CI/CD pipeline deploys to production on `main` branch merge (or manual trigger)
   - Rollback capability: Documented steps to revert to previous version
   - Database migrations run automatically or manually (with backup first)
7. Test: Hit production API from mobile app, complete full search flow, verify no errors

---

## Story 5.6: App Store Submission (iOS)

**As a** developer,
**I want** to submit Lawh to the iOS App Store for review,
**so that** iPhone users can download it publicly.

### Acceptance Criteria

1. **Pre-submission checklist:**
   - App builds successfully in Release mode (not Debug)
   - All Story 5.2 assets uploaded to App Store Connect
   - Privacy nutrition labels completed (Story 5.3)
   - Test flight testing completed with no critical bugs
   - App version: 1.0.0, build number incremented
2. **App Store Connect configuration:**
   - App name: "Lawh - Quran Verse Finder" (or similar, check availability)
   - Bundle ID registered: com.lawh.app (or chosen identifier)
   - Screenshots, descriptions, keywords uploaded
   - Pricing: Free with in-app donations (not in-app purchase, just external link to Stripe)
   - App Store availability: All countries (or specific regions if restricted)
3. **Submission:**
   - Upload IPA (via Xcode or Transporter app)
   - Submit for review with all metadata complete
   - Export compliance: Declare if app uses encryption (HTTPS counts)
4. **Review process:**
   - Monitor review status (typically 1-3 days)
   - Respond to any rejection reasons (common: privacy issues, metadata mismatch, donation flow concerns)
   - If rejected: Fix issues, resubmit
5. **Approval & release:**
   - Upon approval: Release immediately or schedule release date (target: February 14, 2026)
   - Monitor for crashes or user reports immediately after launch
6. **Post-launch:**
   - Respond to user reviews (thank positive, address negative constructively)
   - Monitor analytics (downloads, daily actives) via App Store Connect

---

## Story 5.7: Google Play Submission (Android)

**As a** developer,
**I want** to submit Lawh to Google Play for review,
**so that** Android users can download it publicly.

### Acceptance Criteria

1. **Pre-submission checklist:**
   - App builds successfully in Release mode (signed with upload key)
   - All Story 5.2 assets uploaded to Google Play Console
   - Data safety form completed (Story 5.3)
   - Internal testing completed with no critical bugs
   - App version: 1.0.0, version code: 1
2. **Google Play Console configuration:**
   - App name: "Lawh - Quran Verse Finder" (check availability)
   - Package name registered: com.lawh.app (matches iOS bundle ID ideally)
   - Screenshots, feature graphic, descriptions uploaded
   - Pricing: Free with donations
   - Content rating questionnaire completed (likely "Everyone")
   - Countries available: All (or specific regions)
3. **Submission:**
   - Upload AAB (Android App Bundle) via Google Play Console
   - Submit for review (production track)
4. **Review process:**
   - Google Play reviews faster than App Store (often same day to 1-2 days)
   - Monitor for rejection reasons (less common than iOS)
   - If rejected: Fix issues, resubmit
5. **Approval & release:**
   - Upon approval: Release immediately or staged rollout (10% → 50% → 100%)
   - Target: February 14, 2026 launch
6. **Post-launch:**
   - Monitor Google Play Console for crashes (automatic crash reporting)
   - Respond to user reviews
   - Monitor analytics (installs, daily actives, retention)

---

## Story 5.8: Launch Day Coordination & Monitoring

**As a** product owner,
**I want** a coordinated launch with monitoring in place,
**so that** we can respond quickly to issues and measure initial success.

### Acceptance Criteria

1. **Launch readiness:**
   - Both iOS and Android apps live on stores (or scheduled release)
   - Backend production deployment stable (Story 5.5)
   - Monitoring and error logging active
   - Privacy policy and support email live
2. **Launch announcement:**
   - Social media posts prepared (Twitter, LinkedIn, Islamic communities)
   - Demo video published (YouTube, TikTok if available)
   - Press release or blog post (optional, if time permits)
   - Marketing budget ($200) allocated for ads (Facebook, Instagram targeting Muslims interested in Islam/Quran)
3. **Day 1 monitoring:**
   - Watch for crashes, errors, user complaints
   - Monitor backend health: API response times, Azure STT costs, database load
   - Track downloads: iOS App Store Connect, Google Play Console
   - Engage with early users: Respond to reviews, thank early adopters
4. **Immediate response plan:**
   - Critical bugs: Hotfix and resubmit within 24 hours
   - Server issues: Scale up resources or optimize immediately
   - Negative reviews: Address concerns publicly and improve in updates
5. **Success metrics (Day 1-7):**
   - Downloads: Target 100+ downloads in first week
   - Searches: Monitor search volume, identify patterns
   - Feedback: Track positive vs negative feedback rate (target ≥75% per Goal #2)
   - Costs: Azure STT costs vs donations received
6. **Week 1 retrospective:**
   - Document what went well, what failed
   - Prioritize Phase 2 features based on user feedback
   - Celebrate launch milestone with team/stakeholders!

---

## Epic 5 Summary

**Stories:** 8 stories covering donation integration, app store assets, privacy labels, testing, production deployment, iOS submission, Android submission, and launch coordination

**Estimated Effort:** 2-3 days for solo developer (can overlap with Epic 4)

**Critical Dependencies:**
- Depends on Epics 1-4 being complete and stable
- App store review times are unpredictable (budget 1-5 days for approvals)
- Launch date: February 14, 2026 (4 weeks from mid-January start)

**Definition of Done:**
- All 8 stories completed with acceptance criteria met
- Lawh live on iOS App Store and Google Play
- Donation flow working and tested
- Privacy labels accurate and approved
- Production backend stable with monitoring
- Launch announcement published, marketing initiated
- Day 1 monitoring shows no critical issues
