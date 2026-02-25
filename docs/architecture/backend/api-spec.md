# REST API Spec

[Back to Architecture Index](../index.md)

---

## Endpoints Summary

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/search` | POST | Verse identification |
| `/api/v1/feedback` | POST | Submit feedback |
| `/api/v1/quran/{surah}/{ayah}` | GET | Get single verse |
| `/api/v1/quran/{surah}` | GET | Get full surah |
| `/api/v1/donations` | POST | Create payment |
| `/api/v1/donations/webhook` | POST | Stripe webhook |
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
