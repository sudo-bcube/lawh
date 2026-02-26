# Technical Assumptions

## Repository Structure: Monorepo

**Decision:** Single monorepo containing all platform code

**Structure:**
```
lawh/
├── mobile/          # Flutter mobile app (iOS + Android)
├── web/             # Web version (Flutter Web or React/Vue - Phase 2)
├── backend/         # Python FastAPI backend
├── shared/          # Shared assets (Quran text database, constants)
├── docs/            # Project documentation (PRD, architecture, etc.)
└── scripts/         # Build, deployment, and utility scripts
```

**Rationale:**
- Simplifies dependency management and versioning across platforms
- Easier code sharing between mobile and web (Flutter shared widgets/logic)
- Single CI/CD pipeline for all components
- Solo developer benefits from unified tooling and workflow
- Aligns with 4-week timeline—less overhead than managing multiple repos

**Trade-offs:**
- Larger repo size, but manageable for MVP scope
- All teams need access to entire codebase (not an issue for solo developer)

## Service Architecture: Monolithic Backend with Client Apps

**Architecture Overview:**

```
[Mobile Apps (Flutter)]  ←→  [Backend API (FastAPI)]  ←→  [Azure STT]
                                      ↓
                              [Local Quran DB]
                              [PostgreSQL]
```

**Components:**

1. **Client Applications (Flutter Mobile)**
   - iOS and Android native apps compiled from single Flutter codebase
   - Handle UI/UX, audio recording, result display, Quran reader
   - Communicate with backend via REST API over HTTPS
   - Store anonymous UUID locally (device storage)

2. **Backend API (Python FastAPI)**
   - Single monolithic API handling all business logic
   - Endpoints: `/search` (audio upload + identification), `/feedback`, `/donate`, `/quran` (verse retrieval)
   - Integrates with Azure Speech-to-Text API
   - Implements fuzzy matching algorithm (server-side)
   - Manages user data, searches, feedback storage
   - Deployed on DigitalOcean Droplet ($6/month) or Heroku ($7/month)

3. **Local Quran Text Database**
   - **CRITICAL IMPLEMENTATION NOTE:** Quran text is downloaded ONCE during backend setup and stored locally
   - Source: Tanzil.net or EveryAyah.com (Madinah Mushaf, Uthmani script)
   - Format: XML, JSON, or text files converted to PostgreSQL or file-based storage
   - The fuzzy matching algorithm compares STT output against THIS local copy (not external API calls)
   - Reasoning:
     - Speed: Local lookup required to meet ≤2 second matching requirement (NFR11)
     - Reliability: Cannot depend on external API availability for core functionality
     - Cost: Eliminates API rate limits and potential usage fees
     - Static data: Quran text doesn't change, so no need for real-time syncing
   - Tanzil.net is ONLY queried during initial setup, never during user searches

4. **External Services:**
   - **Azure Speech-to-Text:** Transcription service (API calls from backend for each search)
   - **PostgreSQL Database:** User searches, feedback, optional location data, analytics, and Quran text storage
   - **RevenueCat:** Subscription management wrapping Apple IAP and Google Play Billing
   - **Google AdMob:** Advertisement serving for free tier users (banner + interstitial ads)

**Why Monolithic (not Microservices):**
- MVP scope is small—no need for service decomposition
- Solo developer—microservices add unnecessary complexity
- Faster development and deployment (4-week timeline)
- Easy to refactor into microservices in Phase 2+ if needed

**Why Server-Side Matching (not Client-Side):**
- Centralized algorithm updates without app redeployment
- Collect training data for continuous improvement
- Reduce mobile app size and processing load
- Migrate to client-side in Phase 3 for offline mode if needed

## Testing Requirements: Unit + Integration for Critical Paths

**MVP Testing Strategy:**

**Unit Testing:**
- Backend fuzzy matching algorithm (90%+ coverage—this is critical)
- API endpoints (request/response validation)
- Audio validation logic (duration, quality checks)
- Confidence scoring calculations

**Integration Testing:**
- End-to-end flow: audio upload → STT → matching → result display
- Azure STT API integration (mocked for CI/CD, real calls in staging)
- Database operations (CRUD for searches, feedback, user data)
- Subscription integration (RevenueCat sandbox mode)
- Local Quran database queries and verse retrieval

**Manual Testing:**
- Real-world audio samples with various reciters and audio quality
- Cross-platform UI/UX (iOS, Android devices)
- Accessibility features (text sizing, contrast)
- App Store submission readiness

**Out of Scope for MVP:**
- End-to-end automated UI testing (Selenium, Appium) - time-intensive
- Performance/load testing beyond basic validation
- Security penetration testing (manual security review only)

**Testing Philosophy:**
- Focus testing effort on high-risk areas: algorithm accuracy, STT integration, data privacy
- Manual testing for UX and edge cases
- Automated tests for business logic that changes frequently

**CI/CD:**
- Automated unit/integration tests run on every commit (GitHub Actions or GitLab CI)
- Staging environment for pre-production validation
- Automated mobile builds (Fastlane or Codemagic)

## Additional Technical Assumptions and Requests

**Languages & Frameworks:**
- **Mobile:** Flutter/Dart 3.x for iOS and Android (single codebase)
- **Backend:** Python 3.11+ with FastAPI framework
- **Web (Phase 2):** Flutter Web (preferred) or React/Next.js (fallback)

**Database:**
- **Primary:** PostgreSQL for relational data (user searches, feedback, analytics) AND Quran text storage
- **Quran Text Storage Options:**
  - Option A: PostgreSQL table with columns (surah_number, verse_number, arabic_text, transliteration)
  - Option B: JSON/text files in `/shared` directory with in-memory loading for fast access
  - Recommendation: PostgreSQL for easier querying and verse retrieval via API
- **Caching:** Redis (optional, Phase 2) for frequently accessed verses

**Quran Text Database Details:**
- **Source:** Tanzil.net (http://tanzil.net/download/) or EveryAyah.com (https://everyayah.com/)
- **Version:** Madinah Mushaf (Uthmani script, Hafs recitation)
- **License:** Tanzil.net uses Creative Commons Attribution 3.0 (commercial use allowed with attribution)
- **Download:** One-time during backend setup using their XML/JSON export
- **Updates:** Rare (Quran text is static), check annually for corrections if any
- **Dev Task:** Create setup script to download, parse, and populate local database

**Hosting & Infrastructure:**
- **Backend API:** DigitalOcean Droplet ($6/month) or Heroku Eco ($7/month) for MVP
- **Database:** DigitalOcean Managed PostgreSQL ($15/month) or Supabase free tier
- **Storage:** Quran text database size ~2-5MB (negligible storage cost)
- **Web Frontend (Phase 2):** Vercel or Netlify free tier
- **Mobile Apps:** App Store (iOS) and Google Play (Android) distribution
- **Analytics:** Firebase Analytics (free) or custom backend tracking

**Third-Party Services:**
- **Speech-to-Text:** Azure Cognitive Services Speech-to-Text (5 hours/month free, then ~$1/hour)
- **Subscription Management:** RevenueCat (free tier up to $2.5k MRR, then 1%) wrapping Apple IAP (15-30% fee) and Google Play Billing (15-30% fee)
- **Advertising:** Google AdMob (free to integrate, revenue share via eCPM—typically $1-5 per 1,000 impressions for mobile apps)
- **Quran Text Source:** Tanzil.net or EveryAyah.com (downloaded once, stored locally—NOT queried per search)

**Development Tools:**
- **Version Control:** Git with GitHub or GitLab
- **IDE:** VSCode or Android Studio for Flutter development
- **API Testing:** Postman or Thunder Client
- **Backend Environment:** Virtual environment (venv) or Docker containers
- **Mobile Testing:** iOS Simulator, Android Emulator, physical devices for final validation

**Security & Compliance:**
- HTTPS/TLS for all API communication (enforced)
- Environment variables for API keys (never committed to Git)
- GDPR/CCPA compliance: data export, deletion, opt-out mechanisms
- App Store privacy nutrition labels completed before submission
- Secure storage of anonymous UUIDs on device (iOS Keychain, Android Keystore)

**Algorithm Specifications:**
- **Fuzzy Matching:** Levenshtein distance, phonetic similarity (Soundex/Metaphone for Arabic), or token-based matching
- **Optimization:** Matching completes in ≤2 seconds (NFR11) by comparing against local Quran database
- **Confidence Calculation:** Based on similarity score, verse length match, distinctive word patterns
- **Threshold Calibration:** Initially 90% (high), 65-89% (medium), <65% (low) - tunable post-launch

**Data Privacy & Storage:**
- Anonymous UUIDs generated on device (not server-assigned)
- IP-based city/region geolocation (not GPS coordinates)
- Data retention: 18 months minimum (NFR13)
- No tracking of personal identity (names, emails, phone numbers)
- Optional data collection with clear disclosure and opt-out

**Performance Targets:**
- API response time: <3 seconds for 95th percentile
- Backend handles 2,000 searches/day with 50 concurrent requests (NFR10)
- Mobile app startup: ≤2 seconds (NFR1)
- Quran reader load: ≤1 second (NFR2)
- Local Quran database query: <50ms for verse retrieval

**Deployment & DevOps:**
- Continuous deployment for backend (main branch → staging → production)
- Mobile app releases via TestFlight (iOS) and Google Play Internal Testing before public launch
- Rollback capability for backend deployments
- Monitoring: Basic error logging and performance metrics (Sentry or custom)
- Initial setup script: Download Quran text, populate database, validate data integrity

**Budget Constraints:**
- Marketing budget: $200 total for launch campaign
- Infrastructure costs: <$20/month initially (DigitalOcean + Azure free tier)
- Lean approach required for all technical decisions

**Localization (Future):**
- MVP: English UI with Arabic Quran text (Uthmani script)
- Phase 2+: Add Urdu, Indonesian, Turkish, French translations for broader reach
- RTL (Right-to-Left) layout support for Arabic text already built into Flutter

**Open Source & Licensing:**
- Quran text from Tanzil.net (Creative Commons Attribution 3.0 - requires attribution in app) or EveryAyah.com (license to be confirmed)
- All other code proprietary unless decided otherwise post-MVP
- Consider open-sourcing fuzzy matching algorithm if it proves valuable to community

---
