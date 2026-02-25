# Epic 4: Feedback Collection Infrastructure

**Expanded Goal:** Implement multi-signal feedback system (explicit thumbs up/down, implicit clicks/time spent), optional IP-based location collection, data storage for continuous algorithm improvement, and privacy-first data handling (leveraging Epic 1's UUID system). This epic enables Goals #2 (measure 85%+ accuracy) and #5 (collect 5,000+ searches with feedback) for continuous product improvement.

---

## Story 4.1: Explicit Feedback UI (Thumbs Up/Down)

**As a** user,
**I want** to easily provide feedback on whether the verse identification was correct,
**so that** Lawh can improve accuracy over time.

### Acceptance Criteria

1. Results screen (Story 3.2) displays feedback buttons below verse results:
   - Thumbs up icon button (green when tapped)
   - Thumbs down icon button (red when tapped)
   - "None of these" text button (if multiple results shown)
2. Feedback buttons are always visible but never block content or feel intrusive
3. Tapping thumbs up:
   - Button turns green, haptic feedback (optional)
   - Toast message: "Thank you for your feedback!"
   - Feedback sent to backend immediately (Story 4.3)
4. Tapping thumbs down or "None of these":
   - Button turns red, haptic feedback
   - Optional: Quick follow-up question: "Was it a different verse?" with Yes/No
   - Feedback sent to backend
5. User can change feedback (tap up after down, or vice versa) - latest feedback overwrites
6. Feedback state persists if user navigates away and returns to same search result
7. Design: Icons are culturally neutral, buttons sized appropriately (44x44pt minimum)
8. No forced feedback - user can skip and continue using app

---

## Story 4.2: Implicit Feedback Tracking

**As a** product team,
**I want** to automatically track user behavior signals,
**so that** we can measure engagement and identify which results users actually use.

### Acceptance Criteria

1. **Track which result was selected (FR6):**
   - When user taps a verse result to open Quran reader (Story 3.3), log: search_id, selected_result_index (1-3), timestamp
   - If user taps "None of these" or exits without selecting, log accordingly
2. **Track time spent viewing results (FR6):**
   - Record timestamp when results screen opens
   - Record timestamp when user navigates away (opens reader, goes back, closes app)
   - Calculate and store: time_spent_on_results (seconds)
3. **Track Quran reader engagement:**
   - Time spent in reader (opened → closed/back button)
   - Scrolling behavior (did user scroll to see context? how far?)
4. All implicit tracking:
   - Linked to search_id and anonymous UUID (not personal identity)
   - Sent to backend asynchronously (doesn't block UI)
   - Stored in database (Story 4.4 schema)
5. Privacy-first: No tracking of actual audio content, precise GPS location, or cross-app activity
6. Implicit data collection happens silently - no UI indication (user agreed via privacy policy)

---

## Story 4.3: Feedback API Endpoint

**As a** developer,
**I want** a backend API endpoint to receive and store user feedback,
**so that** we can measure accuracy and improve the algorithm.

### Acceptance Criteria

1. Endpoint: `POST /api/feedback` accepts feedback data
2. Request body (JSON):
   ```json
   {
     "search_id": "uuid",
     "feedback_type": "thumbs_up|thumbs_down|none_of_these",
     "selected_result_index": 1,  // which result user tapped (1-3, or null)
     "time_spent_on_results": 8.5,  // seconds
     "time_spent_in_reader": 45.2,  // seconds (optional)
     "timestamp": "2026-01-20T10:30:00Z"
   }
   ```
3. Authentication: Anonymous UUID in request header validates user (same as Story 2.5)
4. Feedback is stored in `feedback` table (Story 1.3 schema, may need expansion)
5. Idempotent: Multiple feedback submissions for same search_id update existing record (user changed mind)
6. Response: 200 OK with confirmation message
7. Error handling: Invalid search_id (404), malformed data (400), database errors (500)
8. Rate limiting: Prevent abuse (e.g., max 100 feedback submissions per UUID per day)

---

## Story 4.4: Feedback Data Storage Schema

**As a** developer,
**I want** a robust database schema for storing feedback and behavioral data,
**so that** we can analyze it for accuracy measurement and algorithm improvement.

### Acceptance Criteria

1. Expand `feedback` table schema (from Story 1.3):
   ```sql
   feedback (
     id: uuid PRIMARY KEY,
     search_id: uuid FOREIGN KEY → searches.id,
     user_uuid: uuid,  // denormalized for faster queries
     feedback_type: enum ('thumbs_up', 'thumbs_down', 'none_of_these'),
     selected_result_index: int,  // which result user tapped (1-3, or null)
     time_spent_on_results: float,  // seconds
     time_spent_in_reader: float,  // seconds (optional)
     created_at: timestamp,
     updated_at: timestamp
   )
   ```
2. Indexes created for fast querying:
   - Index on search_id (lookup feedback by search)
   - Index on user_uuid (user behavior analysis)
   - Index on created_at (time-based queries)
3. Foreign key constraint: feedback.search_id references searches.id (cascade delete)
4. Data integrity: feedback_type must be valid enum, timestamps auto-generated
5. Migration script created and tested (Alembic or equivalent)
6. Test: Insert feedback, query by search_id, update existing feedback (idempotent test)

---

## Story 4.5: Optional Location Collection (IP-Based)

**As a** user,
**I want** the option to share my city/region with searches,
**so that** Lawh can understand regional recitation preferences without compromising my privacy.

### Acceptance Criteria

1. Location toggle in Settings (Story 3.4) controls location collection
2. **When location enabled:**
   - Backend detects city/region from IP address on each `/api/search` request (NOT GPS coordinates per FR8)
   - Use IP geolocation service: MaxMind GeoLite2 (free), ipapi.co, or similar
   - Location stored as: city, region/state, country (NOT latitude/longitude)
   - Location linked to search record in database (searches.location column)
3. **When location disabled (default):**
   - No location data collected or stored
   - searches.location field remains NULL
4. Location toggle state persists across app sessions
5. Disclosure text in Settings clearly explains: "We collect city/region only (not precise GPS) to understand regional recitation preferences"
6. Backend handles missing location gracefully (toggle OFF or IP lookup failure)
7. Privacy compliance: Location is optional (NFR6), user can opt out anytime, data deleted on user request (NFR7)
8. Test: Enable toggle, make search, verify location stored as city-level (e.g., "Riyadh, Riyadh Region, Saudi Arabia")

---

## Story 4.6: Data Retention & Deletion Policy Implementation

**As a** user,
**I want** my data to be retained responsibly and deletable on request,
**so that** I trust Lawh respects my privacy.

### Acceptance Criteria

1. **Data retention (NFR13):**
   - User searches and feedback retained for minimum 18 months for algorithm improvement
   - Automated cleanup job (cron/scheduled task) deletes data older than 18 months
   - User data (UUID, searches, feedback) remain linked for analysis within retention period
2. **User-initiated deletion (NFR7, GDPR/CCPA compliance):**
   - Settings screen "Request Data Deletion" button (Story 3.4) triggers deletion flow
   - User confirmation dialog: "Delete all your search history and feedback? This cannot be undone."
   - Backend endpoint: `DELETE /api/user/data` (authenticated by UUID header)
   - Deletes all records: searches, feedback, user entry from `users` table
   - Deletion completes within 30 days (NFR13)
3. **Data deletion implementation:**
   - Soft delete first (mark as deleted, actually delete after 30 days) for recovery window
   - Or hard delete immediately if user requests (more aggressive privacy approach)
   - Cascade delete: Deleting user also deletes all associated searches and feedback (foreign key constraints)
4. **Confirmation flow:**
   - After deletion request, show confirmation: "Your data will be deleted within 30 days. You can continue using Lawh with a new anonymous ID."
   - Generate new UUID for device after deletion (clean slate)
5. Test: Request deletion, verify all user data removed from database within timeframe

---

## Story 4.7: Feedback Analytics Query Functions

**As a** developer (Epic 6 dependency),
**I want** database query functions to calculate accuracy metrics from feedback data,
**so that** the analytics dashboard (Epic 6) can display meaningful insights.

### Acceptance Criteria

1. SQL query or backend function: Calculate positive feedback percentage
   ```sql
   SELECT
     COUNT(*) FILTER (WHERE feedback_type = 'thumbs_up') * 100.0 / COUNT(*) as positive_feedback_rate
   FROM feedback
   WHERE created_at > [date_range]
   ```
2. Query: Calculate accuracy by confidence level
   - Group searches by confidence (high/medium/low)
   - Calculate thumbs up % for each group
   - Validate if high confidence searches truly have higher accuracy
3. Query: Identify low-performing searches
   - Find searches with thumbs down or "none of these"
   - Export for manual review and algorithm debugging
4. Query: User engagement metrics
   - Average time spent on results
   - Average time spent in reader
   - % of users who provide explicit feedback (engagement rate)
5. Queries optimized for performance (use indexes, avoid full table scans)
6. Results returned in JSON format for Epic 6 analytics API
7. Test: Run queries on sample data (100+ feedback records), validate calculations

---

## Epic 4 Summary

**Stories:** 7 stories covering explicit feedback UI, implicit tracking, feedback API, data storage, location collection, data retention/deletion, and analytics query functions

**Estimated Effort:** 2-3 days for solo developer

**Critical Dependencies:**
- Depends on Epic 1 (UUID system established)
- Depends on Epic 3 (UI screens to add feedback buttons)
- Depends on Epic 2 (search flow to link feedback to searches)
- Story 4.7 prepares for Epic 6 (analytics dashboard)

**Definition of Done:**
- All 7 stories completed with acceptance criteria met
- Feedback collection working on iOS and Android
- Data stored securely with privacy-first approach
- Users can delete their data on request (GDPR/CCPA compliant)
- Optional location collection respects user choice
- Analytics queries ready for Epic 6 dashboard integration
