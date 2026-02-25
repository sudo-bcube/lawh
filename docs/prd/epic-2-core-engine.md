# Epic 2: Core Verse Identification Engine with Validation

**Expanded Goal:** Build and validate the heart of Lawh: Azure STT integration, optimized fuzzy matching algorithm with confidence scoring, audio recording/upload capabilities, and comprehensive accuracy testing with 50-100 real audio samples to validate 85%+ identification accuracy target. This epic delivers the core technical value proposition and validates the feasibility of the entire product concept before investing heavily in UI polish.

---

## Story 2.1: Azure Speech-to-Text Integration

**As a** developer,
**I want** to integrate Azure Speech-to-Text API for Arabic transcription,
**so that** recorded Quranic recitation audio can be converted to text for matching.

### Acceptance Criteria

1. Azure Cognitive Services account created with Speech-to-Text API enabled
2. API key and region stored securely in environment variables
3. Backend endpoint `/api/stt/transcribe` accepts audio file upload (WAV/MP3, 10-15 seconds)
4. Audio is sent to Azure STT with Arabic language code (`ar-SA` or `ar-EG`)
5. Noise suppression feature enabled in API request (NFR15)
6. STT transcription response returned with confidence scores for each word
7. Error handling: Azure API failures return user-friendly error messages (FR13)
8. Cost tracking: Log STT API usage (duration, cost) for monitoring (Epic 6 dependency)
9. Test: Sample Quranic audio (Al-Fatiha recitation) transcribes with recognizable Arabic words

---

## Story 2.2: Audio Recording & Upload from Mobile App

**As a** user,
**I want** to record 10-15 seconds of audio using my device microphone,
**so that** I can capture a Quranic recitation for verse identification.

### Acceptance Criteria

1. "Listen" button on main screen initiates audio recording when tapped
2. Recording UI displays: Progress indicator (circular timer), waveform visualization, elapsed time counter
3. Recording automatically stops at 15 seconds (FR1)
4. User can manually stop recording after 10 seconds minimum (FR1)
5. If user stops before 10 seconds, display message: "Please record at least 10 seconds" and allow retry
6. Audio quality validation (FR14): Check minimum volume level before upload, reject if too quiet
7. Recorded audio encoded in format supported by Azure STT (WAV or MP3, 16kHz sampling rate recommended)
8. Audio uploaded to backend `/api/search` endpoint with anonymous UUID in headers
9. Loading state displayed during upload and processing: "Identifying verse..."
10. Error handling: Network failures, upload errors, timeout after 10 seconds show clear retry options

---

## Story 2.3: Fuzzy Matching Algorithm Implementation

**As a** developer,
**I want** an optimized text matching algorithm that compares STT transcription to Quran verses,
**so that** the system can identify the correct verse even with imperfect transcription.

### Acceptance Criteria

1. Matching algorithm accepts STT transcription as input (Arabic text string)
2. Algorithm compares transcription against all 6,236 verses in local Quran database (Story 1.2)
3. Matching approach uses combination of:
   - Levenshtein distance (edit distance between strings)
   - Phonetic similarity (Soundex/Metaphone for Arabic if available)
   - Token-based matching (distinctive word patterns like "Allah", "Rahman")
   - Verse length similarity as filter (short transcription → short verses)
4. Algorithm completes in ≤2 seconds for any transcription (NFR11)
5. Returns top 3 verse matches with similarity scores (0-100%)
6. Matches are ranked by combined scoring: similarity + distinctive words + length match
7. Unit tests: Test with known transcriptions (e.g., "Bismillah ar-Rahman ar-Rahim" → Al-Fatiha 1:1)
8. Edge case handling: Very short transcriptions (<5 words), completely gibberish input, empty transcription

---

## Story 2.4: Confidence Scoring System

**As a** developer,
**I want** a confidence scoring system that categorizes match quality,
**so that** the UI can display appropriate result count based on certainty (FR3).

### Acceptance Criteria

1. Confidence calculation logic converts similarity score (0-100%) to confidence percentage
2. Factors influencing confidence:
   - Primary: Fuzzy match similarity score from Story 2.3
   - Secondary: STT transcription confidence (from Azure API)
   - Tertiary: Gap between top result and second result (larger gap = higher confidence)
3. Confidence threshold mapping:
   - High confidence: ≥80% → Return result(s) ≥80% only
   - Medium confidence: 55-79% → Return 2-3 results
   - Low confidence: <55% → Return no results, suggest retry
4. Confidence score included in search API response for UI display
5. Confidence calculation is fast (<100ms) and doesn't impact overall performance target (NFR11)
6. Unit tests: Mock various similarity scores and validate confidence categorization
7. Tunable thresholds: Confidence boundaries (80%, 55%) stored as config values for post-launch adjustment

---

## Story 2.5: Search API Endpoint Implementation

**As a** developer,
**I want** a complete `/api/search` endpoint that orchestrates the identification flow,
**so that** mobile apps can upload audio and receive verse identification results.

### Acceptance Criteria

1. Endpoint: `POST /api/search` accepts multipart form data (audio file + anonymous UUID header)
2. Request validation: Audio file format, size (<5MB), duration (10-15 seconds estimate)
3. Flow orchestration:
   - Step 1: Upload audio to Azure STT (Story 2.1)
   - Step 2: Receive transcription
   - Step 3: Run fuzzy matching (Story 2.3)
   - Step 4: Calculate confidence (Story 2.4)
   - Step 5: Return results or retry message
4. Response format (JSON):
   ```json
   {
     "search_id": "uuid",
     "confidence": 92,
     "results": [
       {
         "surah_number": 1,
         "verse_number": 1,
         "surah_name": "Al-Fatiha",
         "arabic_text": "بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ",
         "similarity_score": 92
       }
     ],
     "retry_suggested": false
   }
   ```
5. Low confidence response (<55%): `{"confidence": 54, "results": [], "retry_suggested": true, "message": "Could not identify verse - please try again"}`
6. Store search in database: user_uuid, audio_file_path, stt_transcription, result_verses, confidence_score, created_at (Story 1.3 schema)
7. Total response time: ≤5 seconds from upload complete to response returned (FR10)
8. Error responses: STT failure, matching timeout, database errors with appropriate HTTP status codes (4xx/5xx)

---

## Story 2.6: Verse Retrieval API Endpoint

**As a** developer,
**I want** an API endpoint to retrieve full verse details for display in the Quran reader,
**so that** the mobile app can show identified verses with surrounding context.

### Acceptance Criteria

1. Endpoint: `GET /api/quran/{surah_number}/{verse_number}` returns single verse details
2. Endpoint: `GET /api/quran/{surah_number}?from={verse}&to={verse}` returns verse range (optional for MVP)
3. Response format (JSON):
   ```json
   {
     "surah_number": 1,
     "surah_name": "Al-Fatiha",
     "verse_number": 1,
     "arabic_text": "بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ",
     "transliteration": "Bismillahi ar-Rahmani ar-Raheem"
   }
   ```
4. Queries local Quran database (Story 1.2) - NOT external API
5. Response time: <50ms for single verse retrieval
6. Error handling: Invalid surah/verse numbers return 404 with helpful message
7. CORS configured to allow mobile app requests
8. Optional: Include surrounding verses (±5 verses) for context in Quran reader

---

## Story 2.7: Accuracy Validation with Real Audio Samples

**As a** developer and PM,
**I want** to test the identification system with 50-100 diverse audio samples,
**so that** we can validate the 85%+ accuracy target (NFR3) before building full UI.

### Acceptance Criteria

1. Collect 50-100 audio samples (10-15 seconds each) representing:
   - Different reciters (5-10 different voices)
   - Different audio quality levels (high quality, mosque audio, phone recording, background noise)
   - Different surahs (common and uncommon verses)
   - Different recitation speeds (slow, moderate, fast)
2. Create test dataset with ground truth labels (correct surah:verse for each sample)
3. Run all samples through `/api/search` endpoint and record results
4. Calculate accuracy metrics:
   - **Primary metric:** Correct verse in top 3 results (target: ≥85%)
   - Secondary: Correct verse as #1 result (target: ≥70%)
   - Confidence distribution: % of searches in high/medium/low confidence buckets
5. Document failures: Which samples failed? Why? (poor audio, unusual recitation, algorithm limitation)
6. If accuracy <85%, iterate on fuzzy matching algorithm (Story 2.3) and retest
7. Accuracy validation report documented and shared with stakeholders before proceeding to Epic 3
8. Cost analysis: Calculate actual Azure STT cost per search based on test volume

---

## Story 2.8: Performance Optimization & Load Testing

**As a** developer,
**I want** to validate the system performs within targets under realistic load,
**so that** we ensure a responsive user experience at launch.

### Acceptance Criteria

1. Performance testing with single request:
   - Audio upload → result display: ≤5 seconds (FR10)
   - STT transcription: ≤3 seconds
   - Fuzzy matching: ≤2 seconds (NFR11)
2. Load testing with concurrent requests:
   - 10 concurrent searches complete successfully without errors
   - 50 concurrent searches (peak capacity per NFR10) complete within acceptable time (<10 seconds)
3. Database query performance: Quran verse retrieval <50ms under load
4. Memory usage: Backend process remains stable under load (no memory leaks)
5. Identify bottlenecks: STT API, fuzzy matching, database queries, or network I/O
6. Optimization if needed: Caching frequently searched verses, connection pooling, algorithm improvements
7. Document performance baselines for future monitoring (Epic 6)

---

## Epic 2 Summary

**Stories:** 8 stories covering STT integration, audio recording/upload, fuzzy matching algorithm, confidence scoring, API endpoints, accuracy validation, and performance testing

**Estimated Effort:** Full week (5-7 days) for solo developer - this is the most complex epic

**Critical Dependencies:**
- Depends on Epic 1 (backend API, Quran database, Flutter shell must be complete)
- Blocks Epic 3 (UI needs working API endpoints from Story 2.5 and 2.6)

**High-Risk Items:**
- Story 2.7 (Accuracy Validation) is GO/NO-GO decision point
- If accuracy <85%, must iterate on algorithm before proceeding to Epic 3
- Azure STT quality with Quranic Arabic is unvalidated assumption (Week 1 testing critical)

**Definition of Done:**
- All 8 stories completed with acceptance criteria met
- Accuracy validation achieves ≥85% correct verse in top 3 results
- Performance targets met: ≤5 seconds end-to-end, ≤2 seconds matching
- 50 concurrent searches handled without degradation
- API endpoints functional and tested from Postman/Thunder Client
