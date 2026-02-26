# Requirements

## Functional Requirements

1. **FR1:** The system shall record audio for a minimum of 5 seconds and maximum of 15 seconds, then transcribe the recorded Arabic Quranic recitation using Azure Speech-to-Text API with Arabic language support and built-in noise suppression enabled. Recordings under 5 seconds shall prompt user to continue recording; recordings shall automatically stop at 15 seconds.

2. **FR2:** The system shall implement an optimized text matching algorithm (Levenshtein distance, phonetic matching, or equivalent) that compares STT transcription output against a Quran text database (Madinah Mushaf from Tanzil.net or equivalent) to identify matching verses with confidence scoring in ≤2 seconds after receiving STT output.

3. **FR3:** The system shall display search results using confidence-based logic: 1 result if algorithm confidence ≥80%, 2-3 results if confidence is 55-79%, and a "Could not identify verse - please try again" message if confidence <55%. (Note: Confidence score represents algorithm certainty; actual accuracy target of 85%+ correct verse in top 3 is measured in NFR3.)

4. **FR4:** The system shall provide an in-app Quran reader displaying the Madinah Mushaf (Uthmani script) that opens to the identified verse location, allowing users to read the full context after identification.

5. **FR5:** The system shall collect explicit feedback through thumbs up/down buttons and a "none of these" option on all search result screens.

6. **FR6:** The system shall collect implicit feedback including which result was clicked and time spent viewing results.

7. **FR7:** The system shall generate and store a device-based anonymous UUID on first app launch to link searches and feedback without identifying the user.

8. **FR8:** The system shall request optional city/region location data via IP-based geolocation with clear disclosure of purpose ("Help us understand regional recitation preferences") and provide opt-in/opt-out toggle in settings.

9. **FR9:** The system shall implement a freemium subscription model using RevenueCat SDK (wrapping Apple In-App Purchase for iOS and Google Play Billing for Android) with two paid tiers: $1/month or $10/year, unlocking unlimited searches and removing all advertisements.

10. **FR10:** The system shall enforce free tier usage limits: maximum 3 searches per day and 10 searches per month. When limits are reached, the system shall display a clear message prompting upgrade to paid subscription with a direct link to the subscription screen.

11. **FR11:** The system shall provide a "Recent Tab" (Explore page) feature displaying the user's recently identified verses (last 20 searches) for quick return access. This feature shall be available to all users (free and paid).

12. **FR12:** The system shall track subscription status locally (via RevenueCat SDK) and sync with backend to gate features appropriately. Subscription status shall be checked on app launch and periodically during use to handle expiration, renewal, or cancellation.

13. **FR13:** The system shall display banner advertisements (Google AdMob) for free tier users on the Home screen and Explore (Recent Tab) page. Banner ads shall not appear during the user's very first app session (first-time user experience). Paid subscribers shall see no advertisements.

14. **FR14:** The system shall display interstitial advertisements (Google AdMob) for free tier users before initiating a search, with the following exceptions: (a) the user's very first search ever is ad-free, (b) paid subscribers see no ads. Interstitial ads shall be skippable after 5 seconds or close automatically after completion.

15. **FR15:** The system shall complete the cycle from recording completion to result display in ≤5 seconds for 90% of searches (excluding the 5-15 second recording duration and any interstitial ad viewing time).

16. **FR16:** The system shall support cross-platform deployment on iOS (13+), Android (8.0+), and modern web browsers (Chrome, Safari, Firefox, Edge).

17. **FR17:** The system shall store all user searches, feedback, and optional location data in a backend database for algorithm improvement and analytics.

18. **FR18:** The system shall display user-friendly error messages for common failure scenarios including: STT API unavailable, poor audio quality detected, network connectivity lost, no verse match found (confidence <55%), and provide actionable recovery steps.

19. **FR19:** The system shall perform client-side audio validation before API submission, checking minimum audio volume level and duration requirements (5-15 seconds), rejecting recordings that fail quality thresholds with user guidance.

20. **FR20:** The system shall require active internet connectivity to function and display clear messaging when offline: "Internet connection required for Lawh to identify verses."

## Non-Functional Requirements

1. **NFR1:** The app shall launch from cold start to ready state in ≤2 seconds on supported devices.

2. **NFR2:** The in-app Quran reader shall load and display the requested verse in ≤1 second after selection.

3. **NFR3:** The system shall maintain 85%+ verse identification accuracy, defined as the correct verse appearing in the top 3 results. This measures actual algorithm performance against real user searches, distinct from confidence scoring in FR3.

4. **NFR4:** Azure STT costs shall remain under $0.10 per search on average during MVP phase, optimizing audio processing and API usage.

5. **NFR5:** All API communication between mobile/web clients and backend shall use HTTPS/TLS encryption.

6. **NFR6:** User data storage shall implement pseudonymization using anonymous UUIDs, with no collection of real names, emails, or precise GPS coordinates without explicit consent.

7. **NFR7:** The system shall comply with GDPR and CCPA requirements, providing user data export, deletion requests, and opt-out mechanisms.

8. **NFR8:** The app shall meet App Store and Google Play privacy nutrition label requirements, clearly disclosing all data collection practices.

9. **NFR9:** API keys, database credentials, and payment processing secrets shall be stored securely using environment variables or secure key management services, never committed to version control.

10. **NFR10:** The backend API shall handle up to 2,000 searches per day without degraded performance or increased error rates, with peak capacity for 50 concurrent searches.

11. **NFR11:** The text matching algorithm shall complete verse identification processing in ≤2 seconds after receiving STT transcription output.

12. **NFR12:** The system shall log all errors, failed searches, and performance metrics to support debugging and continuous improvement.

13. **NFR13:** User search data and feedback shall be retained for a minimum of 18 months for algorithm improvement, with user-initiated deletion available on request within 30 days.

14. **NFR14:** The app shall support basic accessibility features including dynamic text sizing and minimum color contrast ratio of 4.5:1 for readability. Full screen reader compatibility (VoiceOver, TalkBack) and WCAG AA compliance deferred to Phase 2.

15. **NFR15:** Azure Speech-to-Text noise suppression feature shall be enabled by default to improve recognition quality in real-world environments (mosques, lectures, outdoor spaces).

16. **NFR16:** The relational database shall have automated daily backups configured with a retention period of 30 days. Backups shall include all user data (users, searches, feedback, analytics) and Quran text database. Backup verification test shall be performed quarterly to ensure recoverability.

17. **NFR17:** The system shall have defined disaster recovery objectives: Recovery Time Objective (RTO) of 4 hours maximum downtime, and Recovery Point Objective (RPO) of 24 hours maximum data loss. Database restoration procedure shall be documented and tested before production launch.

---
