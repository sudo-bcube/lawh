# Lawh

Lawh is a Quran verse identification app that listens to recitations and identifies the surah and ayah being recited.

## Repository Structure

This project is split into two repositories:

### [lawh-frontend](https://github.com/sudo-bcube/lawh-frontend)

Flutter mobile application for iOS and Android.

**Features:**
- Audio recording and real-time verse identification
- Quran reader with Arabic text, translations, and transliterations
- Search history and recent verses
- Push notifications via Firebase Cloud Messaging
- Donation support via Stripe

**Tech Stack:**
- Flutter/Dart
- Riverpod for state management
- Firebase (FCM for push notifications)
- Stripe for payments

### [lawh-backend](https://github.com/sudo-bcube/lawh-backend)

FastAPI backend that handles verse matching and API services.

**Features:**
- Speech-to-text transcription (Google Cloud Speech)
- Fuzzy text matching against Quran corpus
- User and session management
- Push notification delivery via FCM
- Donation processing via Stripe webhooks
- Geolocation tracking for analytics

**Tech Stack:**
- Python/FastAPI
- PostgreSQL with SQLAlchemy
- Alembic for migrations
- Firebase Admin SDK
- Google Cloud Speech-to-Text

## Getting Started

See the README in each repository for setup instructions.
