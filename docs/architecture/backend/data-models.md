# Data Models

[Back to Architecture Index](../index.md)

---

## User

**Purpose:** Track anonymous users via device-generated UUID for linking searches and feedback without personal identification.

| Attribute | Type | Description |
|-----------|------|-------------|
| `id` | UUID (PK) | Server-generated internal ID |
| `device_uuid` | String (unique) | Device-generated anonymous UUID |
| `device_type` | Enum | `ios`, `android`, `web` |
| `app_version` | String | App version at registration |
| `location_consent` | Boolean | User opted into location tracking |
| `created_at` | Timestamp | First app launch |
| `last_active_at` | Timestamp | Most recent activity |

**Relationships:**
- Has many `Search` records
- Has many `Feedback` records
- Has one `Subscription` record
- Has many `UserUsage` records

## Search

**Purpose:** Record every verse identification attempt for analytics and algorithm improvement.

| Attribute | Type | Description |
|-----------|------|-------------|
| `id` | UUID (PK) | Unique search identifier |
| `user_id` | UUID (FK) | Link to User |
| `transcription` | Text | Google STT output (Arabic text) |
| `audio_duration_ms` | Integer | Recording length (10,000-15,000ms) |
| `audio_quality_score` | Float (nullable) | Client-side quality assessment |
| `top_result_surah` | Integer (nullable) | Best match surah number |
| `top_result_ayah` | Integer (nullable) | Best match ayah number |
| `confidence_score` | Float | Algorithm confidence (0.0-1.0) |
| `results_count` | Integer | Number of results shown (0, 1, 2, or 3) |
| `results_json` | JSONB | Full results array with scores |
| `processing_time_ms` | Integer | Total backend processing time |
| `stt_time_ms` | Integer | Google STT response time |
| `matching_time_ms` | Integer | Fuzzy matching time |
| `city` | String (nullable) | IP-based geolocation at search time |
| `region` | String (nullable) | IP-based geolocation at search time |
| `country_code` | String (nullable) | IP-based geolocation at search time |
| `created_at` | Timestamp | Search timestamp |

**Relationships:**
- Belongs to `User`
- Has one `Feedback` record (optional)

## Feedback

**Purpose:** Capture explicit and implicit user feedback on search results.

| Attribute | Type | Description |
|-----------|------|-------------|
| `id` | UUID (PK) | Unique feedback identifier |
| `search_id` | UUID (FK, unique) | Link to Search (1:1) |
| `user_id` | UUID (FK) | Link to User |
| `explicit_rating` | Enum (nullable) | `thumbs_up`, `thumbs_down`, `none_correct` |
| `clicked_result_index` | Integer (nullable) | Which result user tapped (0, 1, 2) |
| `time_on_results_ms` | Integer | Time spent viewing results |
| `opened_quran_reader` | Boolean | Did user open the Quran reader? |
| `created_at` | Timestamp | Feedback timestamp |

**Relationships:**
- Belongs to `Search` (one-to-one)
- Belongs to `User`

## Subscription

**Purpose:** Track user subscription status for freemium model enforcement.

| Attribute | Type | Description |
|-----------|------|-------------|
| `id` | UUID (PK) | Unique subscription identifier |
| `user_id` | UUID (FK, unique) | Link to User (1:1) |
| `revenuecat_user_id` | String (nullable) | RevenueCat app user ID |
| `product_id` | String (nullable) | Subscription product (e.g., `lawh_monthly`, `lawh_yearly`) |
| `status` | Enum | `active`, `expired`, `cancelled`, `grace_period`, `free` |
| `platform` | Enum (nullable) | `ios`, `android`, `web` |
| `expires_at` | Timestamp (nullable) | Subscription expiration date |
| `created_at` | Timestamp | Record created |
| `updated_at` | Timestamp | Last status update |

**Relationships:**
- Belongs to `User` (one-to-one)

## UserUsage

**Purpose:** Track daily and monthly search usage for free tier limit enforcement.

| Attribute | Type | Description |
|-----------|------|-------------|
| `id` | UUID (PK) | Unique usage record identifier |
| `user_id` | UUID (FK) | Link to User |
| `date` | Date | Date of usage (unique per user per day) |
| `daily_searches` | Integer | Searches performed today (resets daily) |
| `monthly_searches` | Integer | Searches performed this month (resets monthly) |
| `bonus_searches_earned` | Integer | Bonus searches earned via rewarded ads today |
| `bonus_searches_used` | Integer | Bonus searches consumed today |
| `created_at` | Timestamp | Record created |
| `updated_at` | Timestamp | Last update |

**Constraints:**
- Unique constraint on (`user_id`, `date`)
- `daily_searches` default 0
- `monthly_searches` default 0
- `bonus_searches_earned` max 3 per day

**Relationships:**
- Belongs to `User`

## QuranVerse (JSON Structure - Not in DB)

**Purpose:** In-memory Quran text for fuzzy matching. Loaded from JSON file at startup.

```json
{
  "verses": [
    {
      "surah": 1,
      "ayah": 1,
      "text_uthmani": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
      "text_simple": "بسم الله الرحمن الرحيم",
      "text_no_diacritics": "بسم الله الرحمن الرحيم"
    }
  ],
  "metadata": {
    "source": "tanzil.net",
    "version": "Uthmani",
    "total_verses": 6236,
    "downloaded_at": "2026-02-10"
  }
}
```

## Entity Relationship Diagram

```mermaid
erDiagram
    USER ||--o{ SEARCH : makes
    USER ||--o| SUBSCRIPTION : has
    USER ||--o{ USER_USAGE : tracks
    SEARCH ||--o| FEEDBACK : receives
    USER ||--o{ FEEDBACK : provides

    USER {
        uuid id PK
        string device_uuid UK
        enum device_type
        boolean location_consent
        timestamp created_at
    }

    SEARCH {
        uuid id PK
        uuid user_id FK
        text transcription
        real confidence_score
        jsonb results_json
        varchar city
        varchar country_code
        timestamp created_at
    }

    FEEDBACK {
        uuid id PK
        uuid search_id FK
        uuid user_id FK
        enum explicit_rating
        int clicked_result_index
        boolean opened_quran_reader
    }

    SUBSCRIPTION {
        uuid id PK
        uuid user_id FK UK
        varchar revenuecat_user_id
        varchar product_id
        enum status
        enum platform
        timestamp expires_at
    }

    USER_USAGE {
        uuid id PK
        uuid user_id FK
        date date
        int daily_searches
        int monthly_searches
        int bonus_searches_earned
        int bonus_searches_used
    }
```
