# Project Brief: Lawh

## Executive Summary

**Lawh** is a mobile audio recognition app that identifies Quranic verses from live recitations in real-time. Users record 5-15 seconds of audio using their device microphone—from mosques, lectures, or prayers—and the app identifies the verse **within seconds**, even in noisy environments, then displays it in-app for reading and reflection.

**Primary Problem:** Muslims worldwide hear beautiful Quranic recitations but struggle to identify which verses are being recited, breaking their spiritual connection and preventing deeper engagement with the text.

**Target Market:** Global Muslim population (1.8B+), particularly pilgrims at Hajj/Umrah, mosque attendees, and Islamic content consumers aged 14-60 who regularly encounter Quranic recitations in daily life.

**Key Value Proposition:** Unlike existing solutions (Tarteel AI) that struggle with verse discovery accuracy, Lawh uses advanced Speech-to-Text with confidence-based fuzzy matching to achieve 85%+ identification accuracy across any reciter and audio source, solving the verse discovery problem that existing apps haven't mastered.

---

## Problem Statement

Muslims hear Quranic recitations at mosques, during prayers, at religious lectures, and especially during Hajj and Umrah—but often can't identify which verses are being recited in the moment.

**The Memory Gap:** "I remember the sound but not the reference."

Current options all fail:

- **Manual searching** - Takes 10-30 minutes, often unsuccessful due to transliteration errors or incomplete memory
- **Asking others** - Interrupts prayer or the moment; by the time you can ask, details are forgotten
- **Giving up** - The most common outcome

**Impact:**

- Spiritual connection broken between hearing a beautiful verse and understanding what it is
- Lost opportunity to study, memorize, or share the verse
- Frustration in a moment meant to be spiritually uplifting

**Why existing solutions fail:**
Tarteel AI (1M+ downloads) focuses on memorization coaching and struggles with verse discovery from live recitations. Quran search engines require accurate text input, which fails when users only remember phonetic sounds. No existing app solves the core problem: "hear it now → identify it now."

**Why this matters NOW:**
Speech recognition technology has finally reached the accuracy needed to handle Quranic Arabic with confidence. The problem that's frustrated Muslims for decades is now solvable.

---

## Proposed Solution

**Core Concept:**
Lawh uses Speech-to-Text (STT) technology combined with intelligent fuzzy matching to identify Quranic verses from live audio in seconds. The user experience is dead simple: tap to record, wait 3-5 seconds, see the verse identified and displayed for reading.

**How It Works (User Perspective):**

1. User hears a beautiful recitation at mosque, lecture, or during Hajj/Umrah
2. Opens app and taps "Listen" button
3. Records 5-15 seconds of the recitation
4. App displays identified verse(s) with confidence indicator
5. User taps result to read the full verse in-app Quran reader

**How It Works (Technical Approach):**

- Azure Speech-to-Text transcribes Arabic recitation audio (with built-in noise suppression)
- Fuzzy matching algorithm compares transcription against Quran text database
- Confidence scoring determines result display: 1 result if high confidence (80%+), 2-3 options if medium (55-79%), retry prompt if low (<55% - MVP threshold, subject to refinement)
- Anonymous feedback collection (thumbs up/down, clicks) continuously improves accuracy

**Key Differentiators:**

1. **Works with ANY reciter** - Unlike audio fingerprinting approaches, STT handles live recitations from unknown reciters
2. **Confidence-based UX** - Reduces decision fatigue by showing fewer options when system is certain
3. **Transparent data practices** - Optional location and usage data collection with clear disclosure; users control what they share
4. **Sustainable freemium model** - Free tier with limited searches and non-intrusive ads, paid tier for unlimited ad-free experience

**Why This Will Succeed:**

- **Solves real pain immediately** - Tarteel AI has 1M+ downloads but poor verse discovery; we're laser-focused on this one problem
- **Technology is ready** - Modern Arabic STT (Azure, Google) is finally accurate enough for Quranic recitation
- **Scope discipline** - MVP strips everything except core "listen → identify → read" flow, ensuring we ship in 4 weeks
- **Trust through transparency** - Religious apps require higher trust; our honest data practices build that from day one

**High-Level Vision:**
MVP delivers the core "Shazam moment" for Quran verses. Post-MVP, we layer on reciter identification, premium learning features, and community elements—but only after proving the fundamental value proposition works.

---

## Target Users

**Primary User Segment: Active Mosque Attendees & Islamic Content Consumers**

**Demographic Profile:**
- Age: 14-60 years old
- Global Muslims with smartphone access
- Regular engagement with Quranic recitations (daily to weekly)
- Comfortable with mobile apps

**Current Behaviors & Workflows:**
- Attend Friday prayers, Taraweeh during Ramadan, Islamic lectures
- Listen to Quran recitations via YouTube, Islamic apps, mosque live streams
- Use Quran apps for reading but lack verse identification tools
- Manually search for verses when curious, often unsuccessfully
- Share Quranic content on social media and messaging apps

**Specific Needs & Pain Points:**
- **Immediate identification** - Need to know "what is this verse?" in the moment, not hours later
- **Works anywhere** - Mosques, lectures, home listening, Hajj/Umrah
- **No Arabic typing required** - Most can't type Arabic accurately for text search
- **Respectful design** - Religious context demands culturally sensitive UX and monetization
- **Fast and simple** - Don't want complex features, just quick identification

**Goals They're Trying to Achieve:**
- Deepen spiritual connection by understanding what they hear
- Study and memorize verses that move them emotionally
- Share meaningful verses with family and friends
- Learn which surahs are commonly recited during prayers
- Engage more deeply with Quran beyond passive listening

**Secondary User Segment: Hajj & Umrah Pilgrims**

**Demographic Profile:**
- Muslims traveling to Mecca/Medina (any age, skews 30-70)
- Often first-time or infrequent pilgrims
- High emotional/spiritual engagement during journey
- May have limited Arabic proficiency

**Current Behaviors & Workflows:**
- Hear recitations at Masjid al-Haram and Masjid an-Nabawi
- Attend lectures and dhikr circles during pilgrimage
- Record audio/video of emotional moments
- Post pilgrimage experiences on social media
- Limited time window (7-14 days for Umrah, 5-6 days for Hajj)

**Specific Needs & Pain Points:**
- **Once-in-a-lifetime moments** - Heightened desire to capture and remember what they hear
- **Different reciters** - Hear unfamiliar voices and want to identify both verse and reciter
- **Limited internet** - May have spotty connectivity in crowded holy sites
- **Language barriers** - Non-Arabic speakers especially struggle with manual search
- **Share memories** - Want to share verses heard during pilgrimage with those back home

**Goals They're Trying to Achieve:**
- Preserve spiritual moments from their pilgrimage
- Understand the Quranic context of what moved them at the Haram
- Share pilgrimage experiences with meaningful context
- Continue engagement with special verses after returning home

---

## Goals & Success Metrics

**Business Objectives**

- **Launch MVP by February 14, 2026** - 4-week development timeline from mid-January to Valentine's Day
- **Achieve 1,000 active users within first 30 days** post-launch through targeted marketing ($500 budget)
- **Validate technical feasibility** - Achieve 85%+ verse identification accuracy (correct verse in top 3 results)
- **Cost sustainability validation** - Monitor Azure STT costs vs. subscription + ad revenue to ensure sustainable unit economics
- **Gather training data** - Collect 5,000+ user searches with feedback to improve matching algorithm

**User Success Metrics**

- **Time to identification** - 90% of searches return results within 5 seconds
- **User confidence in results** - 80%+ of identifications show high confidence (80%+ score), requiring only 1 result displayed
- **Successful identification rate** - 75%+ of users give positive feedback (thumbs up) on first search attempt
- **Repeat usage** - 40%+ of users return within 7 days of first use
- **Sharing behavior** - 30%+ of successful identifications result in verse sharing (social media, messaging)

**Key Performance Indicators (KPIs)**

- **Daily Active Users (DAU):** Target 200 DAU by end of Week 4 post-launch
- **Search Success Rate:** (Positive feedback / Total searches) ≥ 75%
- **Accuracy Confidence Distribution:** ≥80% of searches return high confidence results (80%+)
- **User Retention (Week 1):** ≥40% of new users perform second search within 7 days
- **Cost per Search:** Azure STT costs remain under $0.10 per search on average
- **Subscription Conversion Rate:** ≥5% of free tier users convert to paid subscription ($1/month or $10/year)
- **Data Opt-In Rate:** ≥60% of users consent to optional location/usage data sharing

---

## MVP Scope

### Core Features (Must Have)

- **Core Verse Detection via STT:** User records 5-15 seconds of any recitation, Azure STT transcribes with built-in noise suppression, fuzzy matching algorithm identifies verses. This IS the MVP—without this, there's no product.

- **Confidence-Based Result Display:** High confidence (80%+) shows 1 result, medium (55-79%) shows 2-3 options, low (<55%) prompts retry. Dramatically improves UX by reducing decision fatigue when system is certain.

- **In-App Quran Reader:** After verse identification, open Quran at that verse for reading along. Completes the core user journey from "hear it" to "read it."

- **Multi-Signal Feedback Collection:** Explicit feedback (thumbs up/down, "none of these") + implicit feedback (clicks, time spent, sharing). Essential for gathering training data from Day 1 to improve accuracy over time.

- **Anonymous User ID System:** Device-based UUID for linking feedback and searches without knowing user identity. Enables personalization and debugging while respecting privacy.

- **Optional Location Data (City/Region):** Request city/region with clear disclosure and opt-in/opt-out toggle. Enables regional insights for future features.

- **Freemium Subscription Model:** Free tier with 3 searches/day (10/month) and banner + interstitial ads (Google AdMob). Paid tier ($1/month or $10/year via RevenueCat) unlocks unlimited searches and removes all ads. Sustainable monetization from Day 1.

- **Recent Tab (Explore Page):** Shows recently identified verses for quick reference. Available to all users (free and paid) to encourage repeat engagement.

- **Basic Noise Suppression:** Azure STT's built-in noise reduction feature enabled by default. Improves real-world usability in mosques and noisy environments at zero additional cost.

### Out of Scope for MVP

- Reciter identification (which Sheikh is reciting)
- Audio fingerprinting for known recordings
- Offline mode / on-device processing
- Quran learning courses or upsells
- Advanced audio preprocessing algorithms
- Admin panel for managing reciters
- Social features (playlists, sharing networks, following)
- Multilingual translations beyond basic Quran text
- Background listening or always-on detection
- Custom tafsir or detailed commentary

### MVP Success Criteria

The MVP is considered successful if:

1. **Technical validation:** 85%+ of test searches return the correct verse in top 3 results
2. **User validation:** 75%+ of users give positive feedback on their identification results
3. **Timeline validation:** App launches on App Store/Google Play by February 14, 2026
4. **Cost validation:** Azure STT costs covered by subscription + ad revenue (positive unit economics at 1,000 users)
5. **Data validation:** 5,000+ user searches with feedback collected for algorithm improvement

If these criteria are met, we proceed to Phase 2 (reciter identification, premium features). If not, we iterate on MVP before adding complexity.

---

## Post-MVP Vision

### Phase 2 Features (March-April 2026)

After validating MVP success, Phase 2 focuses on depth and differentiation:

- **Reciter Identification:** Identify which specific reciter (Sheikh Mishary, Sudais, Abdul Basit, etc.) is reciting the verse using audio fingerprinting or voice classification. Requires building library of 10+ complete recitations and voice recognition system.

- **Admin Panel for Reciter Management:** Internal tool to add new reciters, manage audio libraries, monitor quality, and curate content without requiring app updates.

- **Premium Tier Enhancements:** Add offline mode, detailed tafsir, saved favorites to paid subscription. Expand value proposition beyond ad-free + unlimited searches.

### Long-Term Vision (Q2-Q3 2026)

Evolution toward comprehensive Quran engagement platform:

- **Quran Learning Courses:** "Identified a verse? Take a 5-minute lesson on its meaning" → natural upsell from discovery to learning. Partner with Islamic scholars or license existing content.

- **Advanced Audio Preprocessing:** Custom noise filtering algorithms for extreme environments (outdoor, construction, very loud mosques) beyond Azure's built-in suppression.

- **Offline Mode:** Download reciters and Quran text for recognition without internet. Requires on-device STT model and significant technical complexity.

- **Advanced Analytics Dashboard:** User insights including most-searched verses, accuracy trends, engagement patterns, and regional preferences. Valuable for content creators and researchers.

### Expansion Opportunities (2027+)

Potential moonshots requiring significant investment:

- **Live Recitation Social Network:** Users share favorite recitations, build playlists, follow reciters, discover new verses. Transforms utility tool into community platform with viral growth potential.

- **AI-Powered Tajweed Coach:** Real-time feedback on pronunciation and Tajweed rules as users recite. Shifts positioning from identification to education.

- **Mosque Integration & Smart Speakers:** Auto-display verse info on mosque screens during recitation; Alexa/Google Home integration for home use.

- **Data Insights Marketplace:** Sell anonymized aggregate insights to Islamic content creators, researchers, and publishers. Data becomes primary revenue stream.

- **API for Third-Party Integration:** Allow other Islamic apps to integrate verse recognition as a feature, creating platform ecosystem.

**Key Principle:**
Each phase builds on proven value from previous phase. We only add complexity after validating fundamentals. User feedback and data from MVP directly inform Phase 2 priorities.

---

## Technical Considerations

### Platform Requirements

- **Target Platforms:** iOS, Android, and Web
- **Framework:** Flutter for mobile (iOS/Android with single codebase); Web version using Flutter Web or separate React/Vue.js frontend
- **Minimum OS Support:** iOS 13+, Android 8.0+, modern web browsers (Chrome, Safari, Firefox, Edge)
- **Performance Requirements:**
  - Audio recording to result display: <5 seconds
  - In-app Quran reader load time: <1 second
  - App launch time: <2 seconds

### Technology Preferences

- **Frontend:**
  - Mobile: Flutter/Dart for cross-platform iOS/Android development
  - Web: Flutter Web or React/Vue.js (to be determined during architecture phase)
- **Backend:** Python with FastAPI framework
  - Optimal for fuzzy matching algorithms and text processing
  - Excellent Azure SDK support for Speech-to-Text integration
  - Strong ecosystem for future ML/AI features (reciter identification, Tajweed analysis)
  - Fast async API performance with modern development experience
- **Database:** PostgreSQL for user data, searches, and feedback; JSON/text files or MongoDB for Quran text database
- **Hosting/Infrastructure:**
  - Backend API: DigitalOcean Droplet ($6/month) or Heroku ($7/month) - cost-effective for MVP
  - Azure Speech-to-Text for transcription only (5 hours/month free tier)
  - Database: DigitalOcean managed PostgreSQL or Supabase free tier
  - Web frontend: Vercel or Netlify (free tier)
  - Analytics: Firebase Analytics (free) or custom backend tracking
- **Payment Processing:** RevenueCat SDK wrapping Apple In-App Purchase (iOS) and Google Play Billing (Android) for subscription management
- **Advertising:** Google AdMob for banner and interstitial ads (free tier users only)

### Architecture Considerations

- **Repository Structure:** Monorepo with separate `/mobile`, `/web`, `/backend`, and `/shared` directories
- **Service Architecture:**
  - Mobile/Web app → REST API → Azure STT service
  - Fuzzy matching algorithm runs server-side initially (migrate to client-side in Phase 3 for offline mode)
  - Analytics and feedback collection via Firebase Analytics or custom backend
- **Integration Requirements:**
  - Azure Speech-to-Text API integration with Arabic language support
  - Quran text database (Tanzil.net, EveryAyah.com, or similar)
  - RevenueCat SDK for subscription management (iOS + Android)
  - Google AdMob SDK for advertisements
  - App Store, Google Play, and web deployment pipelines
- **Security/Compliance:**
  - HTTPS/TLS for all API communication
  - Anonymous UUID generation on device, no personal data collection without consent
  - GDPR/CCPA compliance: user data export, deletion requests, opt-out mechanisms
  - App Store privacy nutrition label requirements
  - Secure storage of API keys and credentials

**Note:** These are initial preferences based on 4-week MVP timeline and technical requirements. Final technology decisions will be made during architecture planning phase.

---

## Constraints & Assumptions

### Constraints

- **Budget:** $500 total for launch marketing; hosting and infrastructure costs must stay minimal (<$20/month initially for DigitalOcean/Heroku)
- **Timeline:** 4-week development window (mid-January to February 14, 2026) - aggressive deadline requiring ruthless scope discipline
- **Resources:** Solo developer with full-stack capabilities; no dedicated designers, QA team, or DevOps support
- **Technical:** Azure STT free tier limits (5 hours/month); must optimize API usage or manage costs carefully as users scale

### Key Assumptions

- Azure Speech-to-Text can transcribe Quranic Arabic recitations with 70%+ word-level accuracy across different reciters
- Fuzzy matching algorithm can achieve 85%+ verse identification accuracy with imperfect STT transcriptions
- Target users (mosque attendees, pilgrims) have smartphones with microphone access and internet connectivity
- Users will tolerate 3-5 second wait time for verse identification (vs. instant like Shazam for music)
- Freemium model with ads will generate sufficient revenue to offset infrastructure costs (target: 5%+ free-to-paid conversion)
- Optional data collection (60%+ opt-in rate) provides sufficient training data for algorithm improvement
- Flutter can deliver production-quality mobile apps within 4-week timeline for solo developer
- Quran text databases (Tanzil.net, EveryAyah.com) are available under permissive licenses for commercial use
- App Store and Google Play will approve the app without major friction (privacy, content guidelines)

---

## Risks & Open Questions

### Key Risks

- **STT Accuracy Risk:** Azure STT may not achieve 70%+ accuracy with Quranic Arabic recitations, especially with varied reciters, accents, and Tajweed pronunciation. This is the highest-risk assumption - if STT fails, the entire product doesn't work. **Mitigation:** Priority #1 action is to test Azure STT with real samples THIS WEEK before full development.

- **Cost Scalability Risk:** If 1,000 users perform 5 searches/day at 15 seconds each, Azure STT costs could reach $630/month. **Mitigation:** Free tier limits (3/day, 10/month) cap Azure costs per user; subscription revenue ($1/month) + ad revenue offset costs; monitor unit economics closely.

- **4-Week Timeline Risk:** Aggressive deadline with solo developer may lead to technical debt, poor UX, or incomplete features. Scope creep is a major threat. **Mitigation:** Ruthless scope discipline - if a feature isn't in the "Core Features (Must Have)" list, it gets deferred to Phase 2.

- **App Store Rejection Risk:** Religious content + location tracking + user-generated data may trigger additional review scrutiny or rejection. **Mitigation:** Privacy-first design, clear disclosures, optional data collection, and thorough review of App Store/Google Play guidelines before submission.

- **User Adoption Risk:** "Build it and they will come" doesn't work - $500 marketing budget may be insufficient to reach 1,000 users. **Mitigation:** Leverage organic channels (Islamic Reddit, Facebook groups, WhatsApp), target Hajj/Umrah season timing, create compelling demo video.

### Open Questions

- What's the licensing situation for Quran text databases? Can we use Tanzil.net or EveryAyah.com commercially without restrictions?
- Should we consult Islamic scholars before launch regarding theological/scholarly perspective on using AI/ML with Quran content?
- How do we handle verse boundaries? Some reciters merge verses smoothly - should the app identify ranges like "Surah 2:1-5"?
- What happens if someone recites incorrectly? Does the app correct them or match the incorrect recitation?
- Should we support different Qira'at (Hafs vs. Warsh recitation styles) or focus on Hafs only for MVP?
- How do we verify our verse identifications are correct? Need human review process or quality control workflow?
- What's the backup plan if Azure STT shuts down or dramatically increases prices? Vendor lock-in risk?
- Can we partner with EveryAyah.com, Tanzil.net, or other Quran tech projects directly rather than building everything ourselves?

### Areas Needing Further Research

- Flutter vs. React Native technical feasibility testing - which actually delivers faster for solo developer?
- Tajweed pronunciation handling - STT trained on modern Arabic might struggle with classical Quranic pronunciation
- Scalability architecture - current plan works for MVP, but need to design for 10K+ users to avoid painful migration later
- Ad content guidelines - Ensure AdMob ads shown are appropriate for Islamic app context (filter inappropriate categories)
- App naming and branding - "Shazam for Quran" is descriptive but not a product name; needs creative exploration
- Accessibility considerations - visual impairment, hearing impairment, elderly users - how does app serve diverse needs?

---

## Appendices

### A. Research Summary

This Project Brief was informed by a comprehensive brainstorming session conducted on January 15, 2026, which generated 35+ distinct ideas and validated key assumptions:

**Key Findings:**

- **Market Validation:** Existing competitor (Tarteel AI, 1M+ downloads) validates market need but has poor verse discovery functionality, creating clear competitive opportunity
- **Technical Feasibility:** Modern Arabic STT technology (Azure, Google) has reached accuracy threshold needed for Quranic recitation recognition
- **Scope Refinement:** Removing reciter identification from MVP dramatically simplifies development while preserving core value proposition
- **Cultural Alignment:** Non-intrusive freemium model + privacy-first design align with Islamic values and build trust
- **Cost Management:** $500 marketing budget + minimal hosting (<$20/month) + Azure free tier enables sustainable MVP launch

**Brainstorming Techniques Used:**

- First Principles Thinking - Identified core problem and MVP success criteria
- What If Scenarios - Validated live recitation focus, eliminated audio fingerprinting
- Assumption Reversal - Led to confidence-based UX and privacy-first approach
- SCAMPER - Explored monetization options and phased feature rollout
- Convergent Discussion - Finalized user acquisition strategy and cost analysis

Full brainstorming session results available at: `docs/brainstorming-session-results.md`

### C. References

- Brainstorming Session Results: `docs/brainstorming-session-results.md`
- Tarteel AI: App Store / Google Play - competitor analysis
- Azure Speech-to-Text: Azure Cognitive Services documentation
- Tanzil.net: Quran text database
- bu: Quran audio recitations

---

## Next Steps

### Immediate Actions

1. **Validate STT Accuracy (Week 1 - THIS WEEK)** - Sign up for Azure STT, test with 10+ Quran recitation samples, measure word-level accuracy, calculate costs at scale. Decision point: Proceed or pivot.

2. **Build Fuzzy Matching Prototype (Week 1-2)** - Acquire Quran text database, implement matching algorithm with confidence scoring, test with STT outputs, iterate until 85%+ accuracy achieved.

3. **Design Privacy Architecture (Week 1)** - Document data collection policy, implement anonymous UUID system, write privacy policy, design opt-in UI, ensure GDPR/CCPA compliance.

4. **Set Up Development Environment (Week 1)** - Initialize Flutter project, configure DigitalOcean/Heroku backend, set up PostgreSQL database, integrate Azure STT API, establish CI/CD pipeline.

5. **Create Minimum UI/UX (Week 2-3)** - Design and implement core screens: listen button, confidence-based results display, Quran reader, feedback collection, donation button.

6. **Beta Testing & Refinement (Week 3-4)** - Internal testing, fix critical bugs, optimize performance, prepare App Store/Google Play submissions, create demo video for marketing.

7. **Launch & Monitor (Week 4)** - Submit to app stores, deploy marketing campaign ($500 budget), monitor costs vs. donations, collect user feedback, track success metrics.

### PM Handoff

This Project Brief provides the full context for **Lawh**. The next phase is PRD (Product Requirements Document) creation, where functional requirements, user stories, technical specifications, and acceptance criteria will be detailed section by section.

When ready to proceed to PRD creation, the Product Manager should review this brief thoroughly, validate assumptions, and work collaboratively to translate business objectives into detailed technical requirements.

---