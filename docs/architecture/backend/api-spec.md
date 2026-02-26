# REST API Spec

[Back to Architecture Index](../index.md)

---

## Endpoints Summary

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/search` | POST | Verse identification (enforces usage limits) |
| `/api/v1/feedback` | POST | Submit feedback |
| `/api/v1/quran/{surah}/{ayah}` | GET | Get single verse |
| `/api/v1/quran/{surah}` | GET | Get full surah |
| `/api/v1/webhooks/revenuecat` | POST | RevenueCat subscription events |
| `/api/v1/users/{user_id}/subscription` | GET | Get subscription status |
| `/api/v1/users/{user_id}/usage` | GET | Get usage counters |
| `/api/v1/users/{user_id}/bonus-search` | POST | Grant bonus search (after rewarded ad) |
| `/api/v1/health` | GET | Health check |

## Search Response Schema

```json
{
  "search_id": "uuid",
  "transcription": "Arabic text from STT",
  "confidence": 0.92,
  "results_count": 1,
  "results": [
    {
      "surah": 1,
      "ayah": 1,
      "text_uthmani": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
      "confidence_score": 0.92,
      "surah_name_arabic": "الفاتحة",
      "surah_name_english": "Al-Fatihah"
    }
  ],
  "processing_time_ms": 3200
}
```

## Search Error Response (429 - Usage Limit Exceeded)

```json
{
  "error": "usage_limit_exceeded",
  "message": "Daily search limit reached",
  "usage": {
    "daily_searches": 3,
    "daily_limit": 3,
    "monthly_searches": 10,
    "monthly_limit": 10,
    "bonus_available": 0,
    "is_premium": false
  }
}
```

## Subscription Status Response Schema

```json
{
  "user_id": "uuid",
  "status": "active",
  "product_id": "lawh_monthly",
  "platform": "ios",
  "expires_at": "2026-03-26T12:00:00Z",
  "is_premium": true
}
```

## Usage Response Schema

```json
{
  "user_id": "uuid",
  "date": "2026-02-26",
  "daily_searches": 2,
  "daily_limit": 3,
  "monthly_searches": 8,
  "monthly_limit": 10,
  "bonus_available": 1,
  "is_premium": false
}
```

## Bonus Search Response Schema

```json
{
  "success": true,
  "bonus_searches_earned": 2,
  "bonus_searches_used": 1,
  "bonus_available": 1,
  "daily_bonus_limit": 3,
  "message": "Bonus search granted"
}
```

## RevenueCat Webhook Payload (Example)

```json
{
  "event": {
    "type": "INITIAL_PURCHASE",
    "app_user_id": "device-uuid-here",
    "product_id": "lawh_monthly",
    "purchased_at_ms": 1708948800000,
    "expiration_at_ms": 1711627200000,
    "store": "APP_STORE"
  }
}
```
