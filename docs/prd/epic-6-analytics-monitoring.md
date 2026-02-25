# Epic 6: Analytics & Monitoring Backend

**Expanded Goal:** Build backend analytics infrastructure including admin dashboard for monitoring key metrics (search volume, STT costs, donation revenue, accuracy trends, user retention), cost-per-search calculations, and data export capabilities for continuous improvement insights. This epic addresses Goal #4 (cost sustainability validation) and provides ongoing operational visibility.

**MVP Scope Clarification:**
- **IN MVP (Required):** Stories 6.1-6.2 (Data aggregation + API endpoints) - Essential for operational visibility and cost monitoring from Day 1
- **FLEXIBLE (Can defer to Week 5 post-launch):** Stories 6.3-6.4 (Admin web UI + Alerts) - Can manually query API endpoints via Postman if time pressure
- **RECOMMENDED IN MVP:** Stories 6.5-6.7 (Data export, retention calculation, documentation) - Enables Goal #4 validation and continuous improvement

**Launch Blocker:** NO - Epic 6 can be deferred entirely if necessary. However, Stories 6.1-6.2 are STRONGLY RECOMMENDED to validate cost sustainability (Goal #4) from Day 1. Without these, you'll be flying blind on Azure STT costs vs. donation revenue.

**Timeline Flexibility:** If Epics 1-5 take full 4 weeks, deploy Stories 6.1-6.2 in Week 5 (2 days effort) and defer Stories 6.3-6.7 to Phase 2.

---

## Story 6.1: Analytics Data Aggregation Logic

**As a** developer,
**I want** backend logic to aggregate raw search/feedback data into meaningful metrics,
**so that** the admin dashboard can display insights without slow real-time queries.

### Acceptance Criteria

1. **Daily metrics aggregation:**
   - Scheduled task (cron job or background worker) runs once daily (e.g., midnight UTC)
   - Aggregates previous day's data into summary table: `analytics_daily`
2. **Metrics calculated:**
   - Total searches for the day
   - Unique users (distinct UUIDs) for the day
   - Average searches per user
   - Positive feedback count (thumbs up)
   - Negative feedback count (thumbs down + none of these)
   - Positive feedback percentage: (thumbs up / total feedback) × 100
   - Average confidence score across all searches
   - Azure STT usage: Total audio duration processed (minutes)
   - Azure STT estimated cost: duration × pricing ($1/hour)
   - Donations received: Total amount, count, average donation
3. **Database schema:**
   ```sql
   analytics_daily (
     date: date PRIMARY KEY,
     total_searches: int,
     unique_users: int,
     avg_searches_per_user: float,
     positive_feedback_count: int,
     negative_feedback_count: int,
     positive_feedback_pct: float,
     avg_confidence_score: float,
     stt_minutes_used: float,
     stt_estimated_cost_usd: float,
     donations_total_usd: float,
     donations_count: int,
     created_at: timestamp
   )
   ```
4. **Performance:** Aggregation completes within 5 minutes even with 10,000+ daily searches
5. **Historical backfill:** Script can backfill historical dates (for launch day onwards)
6. Test: Run aggregation on sample data (1 week of searches/feedback), validate calculations

---

## Story 6.2: Admin Dashboard API Endpoints

**As a** developer,
**I want** REST API endpoints that serve analytics data to the admin UI,
**so that** the dashboard can display metrics dynamically.

### Acceptance Criteria

1. **Endpoint: GET /admin/metrics/overview**
   - Returns high-level KPIs for specified date range (default: last 7 days)
   - Response:
     ```json
     {
       "date_range": {"from": "2026-02-14", "to": "2026-02-20"},
       "total_searches": 2456,
       "unique_users": 412,
       "positive_feedback_rate": 78.5,
       "avg_confidence_score": 86.2,
       "total_stt_cost_usd": 14.32,
       "total_donations_usd": 45.00,
       "cost_per_search_usd": 0.006,
       "donation_conversion_rate": 3.2
     }
     ```
2. **Endpoint: GET /admin/metrics/trends**
   - Returns daily time-series data for charting (default: last 30 days)
   - Response: Array of daily metrics (from analytics_daily table)
   - Use for line charts: Searches over time, accuracy over time, costs over time
3. **Endpoint: GET /admin/metrics/costs**
   - Breakdown of Azure STT costs:
     - Daily cost trend
     - Cost per search (average and by day)
     - Projected monthly cost at current usage rate
4. **Endpoint: GET /admin/metrics/revenue**
   - Donation tracking:
     - Total donations by day
     - Donation conversion rate (% of active users who donated)
     - Average donation amount
     - Top donation amounts (anonymized)
5. **Endpoint: GET /admin/metrics/accuracy**
   - Accuracy metrics:
     - Positive feedback rate over time
     - Accuracy by confidence level (high/medium confidence buckets)
     - Low-confidence search rate (% of searches <55% confidence)
6. **Endpoint: GET /admin/metrics/retention**
   - User retention analysis:
     - Day 1, 7, 30 retention rates (% of users who return)
     - Repeat search rate (avg searches per returning user)
     - User cohorts by signup week
7. **Authentication:**
   - All `/admin/*` endpoints require authentication (API key in header or basic auth)
   - Admin credentials stored securely (environment variables)
   - Rate limiting: Prevent abuse (max 100 requests per hour per IP)
8. Test: Call each endpoint with Postman, validate response format and data accuracy

---

## Story 6.3: Simple Admin Web UI

**As a** product owner,
**I want** a simple web interface to view analytics without manually querying APIs,
**so that** I can monitor Lawh's performance at a glance.

### Acceptance Criteria

1. **Tech stack:** Simple HTML/CSS/JavaScript with Chart.js (or React/Vue if preferred)
2. **Admin login page:**
   - Username/password form (basic auth or simple token-based)
   - Credentials stored securely in backend (hashed password)
   - Session token issued on successful login (expires after 24 hours)
3. **Dashboard home page:**
   - High-level KPIs displayed as cards:
     - Total searches (last 7 days)
     - Unique users (last 7 days)
     - Positive feedback rate
     - Azure STT costs (last 7 days)
     - Total donations (last 7 days)
   - Date range selector: Last 7/30/90 days or custom range
4. **Charts & graphs:**
   - Line chart: Daily searches over time
   - Line chart: Positive feedback rate over time
   - Bar chart: Azure STT costs by day
   - Bar chart: Donations by day
   - Pie chart: Confidence level distribution (high/medium/low)
5. **Tables:**
   - Recent searches table: Search ID, confidence, result, feedback, timestamp (last 100)
   - Failed searches table: Searches with negative feedback or low confidence (for debugging)
   - Donations table: Amount, currency, timestamp (anonymized, no user details)
6. **Responsive design:** Works on desktop and tablet (mobile optional)
7. **Deployment:** Hosted at `https://admin.lawh.app` or subdomain, HTTPS required
8. **Security:** Requires login, no public access, logout button, session timeout
9. Test: Login, view dashboard, interact with charts, verify data matches API responses

---

## Story 6.4: Cost Monitoring & Alerts (Optional)

**As a** product owner,
**I want** automated alerts when costs or metrics exceed thresholds,
**so that** I can respond quickly to issues.

### Acceptance Criteria

1. **Cost threshold alerts:**
   - If daily Azure STT cost >$50, send email alert
   - If cost-per-search >$0.15 (above target per NFR4), send alert
2. **Accuracy threshold alerts:**
   - If positive feedback rate <70% for 3 consecutive days, send alert
   - If low-confidence search rate >40%, send alert (indicates algorithm degradation)
3. **Error rate alerts:**
   - If API error rate >5% of requests, send alert
   - If Azure STT failures >10% of searches, send alert
4. **Revenue alerts (informational):**
   - Daily summary email: Searches, costs, donations, net cost
   - Weekly summary: Trends and insights
5. **Alert delivery:**
   - Email to configured admin address (SendGrid, AWS SES, or SMTP)
   - Optional: Slack webhook, SMS via Twilio (if budget allows)
6. **Alert configuration:**
   - Thresholds stored in config file or environment variables
   - Easy to adjust without code changes
7. **Mute/snooze:** Ability to temporarily disable alerts (e.g., during maintenance)
8. Test: Manually trigger alert conditions (mock high cost), verify email sent

---

## Story 6.5: Data Export for Analysis

**As a** product team,
**I want** to export raw or aggregated data for deeper analysis,
**so that** I can perform custom queries and algorithm improvements.

### Acceptance Criteria

1. **Endpoint: GET /admin/data/export**
   - Query parameters: data_type (searches, feedback, analytics), date_range, format (CSV, JSON)
   - Example: `/admin/data/export?data_type=searches&from=2026-02-01&to=2026-02-28&format=csv`
2. **Export options:**
   - **Searches export:** All search records with: search_id, user_uuid, confidence, result_verses, stt_transcription (optional), feedback, timestamp, location
   - **Feedback export:** All feedback with: search_id, feedback_type, selected_result, time_spent, timestamp
   - **Analytics export:** Daily aggregated metrics (from analytics_daily table)
3. **Data privacy:**
   - UUID anonymization: Option to hash or remove UUIDs for extra privacy
   - No raw audio files exported (too large, privacy concern)
   - Adhere to data retention policy (only export data within 18-month window)
4. **File formats:**
   - CSV: Suitable for Excel, Google Sheets analysis
   - JSON: Suitable for programmatic analysis, data science workflows
5. **Performance:** Large exports (10,000+ rows) stream results or paginate (don't load all into memory)
6. **Authentication:** Requires admin credentials (same as other admin endpoints)
7. Test: Export 1,000 searches as CSV, validate format and data completeness

---

## Story 6.6: User Retention Calculation Logic

**As a** developer,
**I want** logic to calculate user retention metrics,
**so that** we can measure long-term engagement (Goal #5).

### Acceptance Criteria

1. **Retention definition:**
   - Day 1 retention: % of users who return within 24 hours of first use
   - Day 7 retention: % of users who return within 7 days of first use
   - Day 30 retention: % of users who return within 30 days of first use
2. **Calculation approach:**
   - Track user first seen date in `users` table: `first_seen_at`
   - Track user last active date: `last_active_at`
   - For each cohort (users who joined on date X), calculate: returned_users / total_users × 100
3. **Cohort analysis:**
   - Group users by signup week (e.g., Week of Feb 14, Week of Feb 21)
   - Calculate retention for each cohort
   - Display in admin dashboard as cohort table or line chart
4. **Query example:**
   ```sql
   SELECT
     DATE_TRUNC('week', first_seen_at) as cohort_week,
     COUNT(*) as total_users,
     COUNT(*) FILTER (WHERE last_active_at > first_seen_at + INTERVAL '7 days') as retained_7d,
     (retained_7d * 100.0 / total_users) as retention_7d_pct
   FROM users
   GROUP BY cohort_week
   ```
5. **Performance:** Retention queries optimized with indexes on first_seen_at and last_active_at
6. **Integration:** Retention metrics available via `/admin/metrics/retention` endpoint (Story 6.2)
7. Test: Create sample user cohorts with known retention patterns, validate calculation accuracy

---

## Story 6.7: Documentation & Handoff

**As a** product owner,
**I want** documentation on how to use the admin dashboard and interpret metrics,
**so that** non-technical stakeholders can monitor Lawh's performance.

### Acceptance Criteria

1. **Admin dashboard user guide:**
   - How to log in
   - Explanation of each metric (what it means, why it matters)
   - How to interpret charts (trends, anomalies)
   - How to export data for deeper analysis
2. **Metrics glossary:**
   - Positive feedback rate: % of searches with thumbs up (target: ≥75%)
   - Cost per search: Azure STT cost / total searches (target: <$0.10)
   - Donation conversion rate: % of users who donated (target: ≥5%)
   - Confidence distribution: % of searches in high/medium/low buckets (target: 80%+ high)
3. **Troubleshooting guide:**
   - What to do if costs spike
   - What to do if accuracy drops
   - How to identify failing searches for debugging
4. **API documentation:**
   - Endpoint list with request/response examples
   - Authentication instructions
   - Rate limits and usage guidelines
5. **Handoff to stakeholders:**
   - Demo session: Walk through dashboard, explain key metrics
   - Share credentials securely (password manager or encrypted email)
   - Schedule weekly check-ins to review metrics together (first month)
6. Documentation format: Markdown file in `/docs/admin-dashboard-guide.md` and/or Notion/Confluence page

---

## Epic 6 Summary

**Stories:** 7 stories covering data aggregation, API endpoints, admin web UI, cost monitoring/alerts, data export, retention calculation, and documentation

**Estimated Effort:** 2-3 days for solo developer

**Launch Blocker:** NO - Can be deferred to post-launch if timeline is tight

**Critical Dependencies:**
- Depends on Epics 1-4 (data sources: searches, feedback, donations)
- Story 6.2-6.3 can start in parallel with Epic 5 (doesn't block launch)

**Definition of Done:**
- All 7 stories completed with acceptance criteria met
- Admin dashboard accessible and functional
- Daily metrics aggregation running automatically
- Product owner trained on dashboard usage
- Cost and accuracy metrics visible from Day 1 post-launch
- Data export capability available for algorithm improvement

**Post-MVP Enhancements:**
- Real-time dashboards (current: daily aggregation)
- Advanced analytics: Cohort analysis, funnel metrics, A/B testing
- User segmentation: Power users vs casual users, regional analysis
- Predictive cost modeling: Forecast monthly costs based on trends
- Public metrics page: Share anonymized usage stats with community (builds trust)
