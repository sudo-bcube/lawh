# External APIs

[Back to Architecture Index](../index.md)

---

## Google Cloud Speech-to-Text API

- **Purpose:** Transcribe Arabic Quranic audio recordings to text
- **Documentation:** https://cloud.google.com/speech-to-text/docs
- **Base URL:** `https://speech.googleapis.com/v1/speech:recognize`
- **Authentication:** Service Account JSON key
- **Rate Limits:** Default 300 requests/minute

**Request Configuration:**
```json
{
  "config": {
    "encoding": "LINEAR16",
    "sampleRateHertz": 16000,
    "languageCode": "ar-SA",
    "enableAutomaticPunctuation": true,
    "model": "default",
    "useEnhanced": true
  },
  "audio": {
    "content": "<base64-encoded-audio>"
  }
}
```

## Stripe API

- **Purpose:** Process Sadaqah (voluntary donation) payments
- **Documentation:** https://stripe.com/docs/api
- **Base URL:** `https://api.stripe.com/v1`
- **Authentication:** Secret key (server-side), Publishable key (client-side)

**Key Endpoints:**
- `POST /v1/payment_intents` - Create payment intent
- `POST /v1/webhooks` - Receive payment confirmation events

## Tanzil.net (One-Time Data Source)

- **Purpose:** Source for Quran text database (Uthmani script)
- **Documentation:** https://tanzil.net/download/
- **License:** Creative Commons Attribution 3.0 (requires attribution in app)
- **Usage:** Downloaded once during setup, stored as JSON
