# Epic List

The following epics represent the high-level structure of the Lawh MVP development work. Each epic delivers significant, end-to-end, fully deployable increments of testable functionality following agile best practices.

## Epic 1: Foundation & Core Infrastructure

**Goal:** Establish complete project foundation including backend API (FastAPI), local Quran database setup, Flutter mobile app shell (iOS/Android), anonymous UUID generation system, deployment pipeline, and basic health-check endpoint to validate the entire development stack.

**Key Deliverables:**
- Backend API framework (Python FastAPI) with basic routing
- Local Quran text database downloaded and populated (Tanzil.net or EveryAyah.com)
- Flutter project initialized with iOS and Android targets
- Anonymous UUID generation system (device-based)
- Git repository, CI/CD pipeline setup
- Deployment to staging environment (DigitalOcean/Heroku)
- Health-check endpoint returning 200 OK

**Why First:** Establishes foundational infrastructure that all subsequent epics depend on. Validates that the entire tech stack (backend, mobile, database, deployment) works together before building features.

---

## Epic 2: Core Verse Identification Engine with Validation

**Goal:** Build and validate the heart of Lawh: Azure STT integration, optimized fuzzy matching algorithm with confidence scoring, audio recording/upload capabilities, and comprehensive accuracy testing with 50-100 real audio samples to validate 85%+ identification accuracy target.

**Key Deliverables:**
- Azure Speech-to-Text API integration with Arabic language support
- Audio recording functionality (5-15 seconds, client-side validation)
- Audio upload endpoint (`/search`) with proper encoding
- Fuzzy matching algorithm (Levenshtein/phonetic) comparing STT output to local Quran database
- Confidence scoring system (80%+ high, 55-79% medium, <55% low)
- Search result API response with verse references and confidence scores
- Accuracy validation: Test with 50-100 diverse audio samples (different reciters, audio quality)
- Performance validation: ≤5 seconds from recording end to result display (FR10)

**Why Second:** This is the highest-risk technical component and core value proposition. Building this early allows validation of the fundamental concept before investing heavily in UI/UX. If STT or matching fails to meet accuracy targets, we pivot before building the full product.

---

## Epic 3: User Interface & Quran Reader

**Goal:** Deliver the complete user experience with mobile UI (Flutter iOS/Android), confidence-based results display, in-app Quran reader with verse highlighting, error handling flows, and culturally respectful design following spiritual minimalism principles.

**Key Deliverables:**
- Main screen with prominent "Listen" button and recording UI (progress indicator, waveform)
- Results screen with confidence-based display (1 result for high confidence, 2-3 for medium, retry for low)
- In-app Quran reader displaying Madinah Mushaf (Uthmani script) with verse highlighting
- Error/retry screens with user-friendly messaging (FR13)
- Settings screen with basic navigation
- Dark green (dark lemon) and snow white branding with culturally appropriate design
- Platform-specific UI patterns (iOS vs Android Material Design)
- Basic accessibility: text sizing, color contrast 4.5:1

**Why Third:** Cannot build functional UI without working backend (Epic 1) and API endpoints (Epic 2). This epic makes the core functionality accessible to real users and completes the primary user journey: hear → record → identify → read.

---

## Epic 4: Feedback Collection Infrastructure

**Goal:** Implement multi-signal feedback system (explicit thumbs up/down, implicit clicks/time spent), optional IP-based location collection, data storage for continuous algorithm improvement, and privacy-first data handling (leveraging Epic 1's UUID system).

**Key Deliverables:**
- Explicit feedback UI: Thumbs up/down buttons, "none of these" option on results screen
- Implicit feedback tracking: Which result clicked, time spent viewing, session duration
- Feedback API endpoint (`/feedback`) for storing user responses
- Optional location collection (IP-based city/region) with clear disclosure and settings toggle (FR8)
- Database schema for storing searches, feedback, and optional location data
- Privacy-first implementation: Links feedback to anonymous UUID (from Epic 1), no personal data
- Data retention policy implementation: 18-month minimum storage (NFR13)

**Why Fourth:** Feedback collection enables continuous algorithm improvement and measures actual accuracy (Goal #2 and #5). Depends on completed UI (Epic 3) for user interactions and Epic 1's UUID system for anonymous tracking. This is essential for MVP but not blocking for core functionality testing.

---

## Epic 5: Monetization & Launch Preparation

**Goal:** Add Sadaqah donation integration (Stripe), complete app store submission requirements (privacy labels, screenshots, testing), final polish, and production deployment with basic error logging.

**Key Deliverables:**
- Prominent "Support Lawh (Sadaqah)" button on main screen and in settings
- Stripe payment integration for international donations
- Donation confirmation flow and thank-you messaging
- App store assets: Screenshots, app descriptions, keywords, promotional text
- Privacy nutrition labels (iOS App Store, Google Play)
- App icon, splash screen, and branding finalization
- Final testing: Cross-device (iOS/Android), edge cases, error scenarios
- Production deployment: Backend to production server, mobile apps to TestFlight/Internal Testing
- Basic error logging (Sentry or custom) for production monitoring
- App Store and Google Play submission

**Why Fifth:** Donation functionality validates cost sustainability (Goal #4). App store assets and privacy labels are required for public launch. Depends on completed UI and features from Epics 1-4. This epic transforms the working prototype into a production-ready, publicly available product.

---

## Epic 6: Analytics & Monitoring Backend

**Goal:** Build backend analytics infrastructure including admin dashboard for monitoring key metrics (search volume, STT costs, donation revenue, accuracy trends, user retention), cost-per-search calculations, and data export capabilities for continuous improvement insights.

**MVP Scope Clarification:**
- **IN MVP (Required):** Stories 6.1-6.2 (Data aggregation + API endpoints) - Provides operational visibility from Day 1
- **FLEXIBLE (Can defer to Week 5 if timeline pressure):** Stories 6.3-6.4 (Admin web UI + Alerts) - Manual API queries acceptable for MVP
- **RECOMMENDED IN MVP:** Stories 6.5-6.7 (Data export, retention calculation, documentation) - Enables Goal #4 validation

**Launch Blocker:** NO - Epic 6 can be deferred entirely if necessary, but Stories 6.1-6.2 are strongly recommended for cost monitoring.

**Key Deliverables:**
- Analytics data aggregation logic (daily/weekly metrics from search logs)
- Admin API endpoints for metrics:
  - `/admin/metrics/overview` - High-level KPIs dashboard
  - `/admin/metrics/searches` - Search volume trends
  - `/admin/metrics/costs` - Azure STT costs and cost-per-search
  - `/admin/metrics/revenue` - Donation tracking and conversion rates
  - `/admin/metrics/accuracy` - Identification accuracy trends from feedback
  - `/admin/metrics/retention` - User retention analysis
  - `/admin/data/export` - CSV export for detailed analysis
- Simple admin web interface with authentication (basic auth or API key)
- Automated daily metric calculation (scheduled task/cron job)
- Cost monitoring: Azure STT usage tracking and cost-per-search calculations
- Revenue tracking: Stripe webhook integration for donation events

**Key Metrics Tracked:**
- Search volume: Total searches, daily/weekly active users, searches per user
- Cost metrics: Azure STT cost per search, total monthly costs, cost trends
- Revenue metrics: Total donations, conversion rate, average donation amount
- Accuracy metrics: Positive feedback percentage, confidence score distribution
- Retention metrics: Day 1/7/30 retention rates, repeat search behavior

**Why Sixth:** Provides operational visibility and validates cost sustainability (Goal #4). Enables data-driven decisions for Phase 2 prioritization. Can be deployed post-launch if timeline pressure occurs (launch blocker: NO), but provides immediate value for monitoring MVP success and making informed product decisions.

**Note:** Marketing execution (Goal #3: acquire 1,000 users with $200 budget) is a separate post-launch workstream, not part of development epics. Epic 5 includes app store assets for discoverability, and Epic 6 provides metrics to measure acquisition success.

**Epic Details:** See individual epic files in `docs/prd/` directory:
- `epic-1-foundation.md` - 8 stories
- `epic-2-core-engine.md` - 8 stories
- `epic-3-ui-reader.md` - 8 stories
- `epic-4-feedback.md` - 7 stories
- `epic-5-monetization-launch.md` - 8 stories
- `epic-6-analytics-monitoring.md` - 7 stories

---
