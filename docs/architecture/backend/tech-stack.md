# Tech Stack

[Back to Architecture Index](../index.md)

---

## Cloud Infrastructure

- **Provider:** Google Cloud Platform (GCP) + DigitalOcean
- **Key Services:**
  - Google Cloud Speech-to-Text (transcription)
  - DigitalOcean Droplet (backend hosting)
  - DigitalOcean Managed PostgreSQL (database)
- **Deployment Regions:** US East (primary)

## Technology Stack Table

| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| **Mobile Framework** | Flutter | 3.24.x | Cross-platform iOS/Android | Single codebase, PRD requirement |
| **Mobile Language** | Dart | 3.5.x | Mobile app development | Flutter's language |
| **Mobile Architecture** | Riverpod + Clean Arch | 2.5+ | State management & structure | Compile-safe, async-friendly, testable |
| **Backend Framework** | FastAPI | 0.115.x | REST API | Async, fast, Python ecosystem |
| **Backend Language** | Python | 3.12 | Backend development | Latest stable, better performance |
| **Backend Template** | Tiangolo Full Stack | Latest | Project scaffolding | SQLAlchemy, Alembic, JWT ready |
| **Database** | PostgreSQL | 16 | Primary data store | Users, searches, feedback |
| **Quran Text Storage** | JSON files | N/A | Verse data | In-memory loading, <50ms lookup |
| **ORM** | SQLAlchemy | 2.0.x | Database access | Async support, migrations via Alembic |
| **Speech-to-Text** | Google Cloud STT | v1 | Arabic transcription | Pure Arabic output, tested accuracy |
| **Payments** | Stripe | Latest API | Sadaqah donations | International support |
| **Backend Hosting (Primary)** | DigitalOcean Droplet | $6/month | API server | Cost-effective |
| **Backend Hosting (Fallback)** | Heroku Eco | $7/month | Backup hosting | Easy deployment if DO issues |
| **Database Hosting** | DigitalOcean Managed PostgreSQL | $15/month | Managed DB | Automated backups |
| **CI/CD** | GitHub Actions | N/A | Automated testing/deployment | Free, integrated |
| **Mobile Builds** | Codemagic | Free tier | iOS/Android builds | Flutter-specialized |
| **Monitoring** | Sentry | Free tier | Error tracking | PRD requirement |
| **Analytics** | Firebase Analytics | Free | Usage tracking | PRD requirement |
