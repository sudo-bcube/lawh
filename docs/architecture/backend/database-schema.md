# Database Schema

[Back to Architecture Index](../index.md)

---

```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ENUM TYPES
CREATE TYPE device_type AS ENUM ('ios', 'android', 'web');
CREATE TYPE feedback_rating AS ENUM ('thumbs_up', 'thumbs_down', 'none_correct');
CREATE TYPE subscription_status AS ENUM ('active', 'expired', 'cancelled', 'grace_period', 'free');
CREATE TYPE subscription_platform AS ENUM ('ios', 'android', 'web');

-- USERS TABLE
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    device_uuid VARCHAR(36) NOT NULL UNIQUE,
    device_type device_type NOT NULL,
    app_version VARCHAR(20) NOT NULL,
    location_consent BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    last_active_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- SEARCHES TABLE
CREATE TABLE searches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    transcription TEXT NOT NULL,
    audio_duration_ms INTEGER NOT NULL CHECK (audio_duration_ms BETWEEN 10000 AND 15000),
    audio_quality_score REAL,
    top_result_surah SMALLINT CHECK (top_result_surah BETWEEN 1 AND 114),
    top_result_ayah SMALLINT,
    confidence_score REAL NOT NULL CHECK (confidence_score BETWEEN 0.0 AND 1.0),
    results_count SMALLINT NOT NULL CHECK (results_count BETWEEN 0 AND 3),
    results_json JSONB NOT NULL DEFAULT '[]',
    processing_time_ms INTEGER NOT NULL,
    stt_time_ms INTEGER NOT NULL,
    matching_time_ms INTEGER NOT NULL,
    city VARCHAR(100),
    region VARCHAR(100),
    country_code CHAR(2),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- FEEDBACK TABLE
CREATE TABLE feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    search_id UUID NOT NULL UNIQUE REFERENCES searches(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    explicit_rating feedback_rating,
    clicked_result_index SMALLINT CHECK (clicked_result_index BETWEEN 0 AND 2),
    time_on_results_ms INTEGER,
    opened_quran_reader BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- SUBSCRIPTIONS TABLE
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    revenuecat_user_id VARCHAR(255),
    product_id VARCHAR(100),
    status subscription_status NOT NULL DEFAULT 'free',
    platform subscription_platform,
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- USER USAGE TABLE (for free tier limit tracking)
CREATE TABLE user_usage (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    daily_searches INTEGER NOT NULL DEFAULT 0,
    monthly_searches INTEGER NOT NULL DEFAULT 0,
    bonus_searches_earned INTEGER NOT NULL DEFAULT 0 CHECK (bonus_searches_earned <= 3),
    bonus_searches_used INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, date)
);

-- INDEXES
CREATE INDEX idx_users_device_uuid ON users(device_uuid);
CREATE INDEX idx_searches_user_id ON searches(user_id);
CREATE INDEX idx_searches_created_at ON searches(created_at);
CREATE INDEX idx_searches_confidence ON searches(confidence_score);
CREATE INDEX idx_feedback_search_id ON feedback(search_id);
CREATE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_expires_at ON subscriptions(expires_at);
CREATE INDEX idx_user_usage_user_date ON user_usage(user_id, date);
```
