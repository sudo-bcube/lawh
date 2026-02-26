# Components

[Back to Architecture Index](../index.md)

---

## Mobile App (Flutter)

**Responsibility:** Handle user interactions, audio recording, result display, and Quran reading experience.

**Key Interfaces:**
- REST API client for backend communication
- Google Firebase SDK for analytics
- Device audio recording APIs
- Local storage for anonymous UUID

**Dependencies:** Backend API, Firebase Analytics

**Technology Stack:** Flutter 3.24.x, Dart 3.5.x, Riverpod, Clean Architecture

**Internal Structure (Feature-First Clean Architecture):**
```
mobile/
├── lib/
│   ├── app/                    # App configuration, routing
│   ├── features/
│   │   ├── recording/          # Audio capture feature
│   │   ├── results/            # Search results display
│   │   ├── quran_reader/       # In-app Quran viewer
│   │   ├── feedback/           # Thumbs up/down, ratings
│   │   ├── subscription/       # RevenueCat subscription management
│   │   ├── ads/                # Google AdMob integration
│   │   ├── usage/              # Usage tracking and limits
│   │   └── settings/           # User preferences
│   ├── core/
│   │   ├── api/                # Backend API client
│   │   ├── models/             # Data models
│   │   └── utils/              # Helpers, constants
│   └── l10n/                   # Localization
```

## Backend API (FastAPI)

**Responsibility:** Orchestrate STT transcription, execute fuzzy matching, manage user data, track subscriptions and usage.

**Key Interfaces:**
- `POST /api/v1/search` - Audio upload and verse identification (enforces usage limits)
- `POST /api/v1/feedback` - Submit search feedback
- `GET /api/v1/quran/{surah}/{ayah}` - Retrieve verse text
- `POST /api/v1/webhooks/revenuecat` - Receive subscription status updates
- `GET /api/v1/users/{user_id}/subscription` - Get subscription status
- `GET /api/v1/users/{user_id}/usage` - Get usage counters
- `POST /api/v1/users/{user_id}/bonus-search` - Grant bonus search
- `GET /api/v1/health` - Health check endpoint

**Dependencies:** Google Cloud STT, PostgreSQL, RevenueCat Webhooks, Quran JSON data

**Technology Stack:** Python 3.12, FastAPI 0.115.x, SQLAlchemy 2.0, Pydantic

**Internal Structure (Layered Architecture):**
```
backend/
├── app/
│   ├── api/v1/endpoints/       # HTTP layer (search, feedback, webhooks, users)
│   ├── core/                   # Config, security, dependencies
│   ├── services/               # Business logic (STT, matching, usage)
│   ├── repositories/           # Data access layer
│   ├── models/
│   │   ├── domain/             # SQLAlchemy models
│   │   └── schemas/            # Pydantic schemas
│   └── data/quran.json         # Quran text
```

## Component Diagram

```mermaid
graph TB
    subgraph "Mobile App (Flutter)"
        UI[UI Layer<br/>Screens & Widgets]
        Providers[Riverpod Providers<br/>State Management]
        API_Client[API Client<br/>REST Communication]
        RC_SDK[RevenueCat SDK]
        AdMob_SDK[AdMob SDK]
    end

    subgraph "Backend API (FastAPI)"
        Router[API Router<br/>Endpoints]
        Services[Service Layer]
        Repos[Repository Layer]

        subgraph "Services"
            STT[STT Service]
            Match[Matching Service]
            Quran[Quran Service]
            Usage[Usage Service]
        end
    end

    subgraph "External"
        Google[Google Cloud STT]
        RevenueCat[RevenueCat<br/>Webhooks]
        AdMob[Google AdMob]
    end

    subgraph "Data"
        PG[(PostgreSQL)]
        JSON[(Quran JSON<br/>In-Memory)]
    end

    UI --> Providers
    Providers --> API_Client
    Providers --> RC_SDK
    Providers --> AdMob_SDK
    API_Client -->|HTTPS| Router
    RC_SDK -->|Purchase| RevenueCat
    AdMob_SDK -->|Ads| AdMob
    RevenueCat -->|Webhook| Router
    Router --> Services
    Services --> Repos
    STT -->|API Call| Google
    Match --> JSON
    Quran --> JSON
    Repos --> PG
```
