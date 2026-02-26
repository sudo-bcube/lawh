# Core Workflows

[Back to Architecture Index](../index.md)

---

## Workflow 1: Verse Identification (Primary User Journey)

```mermaid
sequenceDiagram
    autonumber
    participant User
    participant App as Mobile App
    participant API as FastAPI Backend
    participant STT as Google Cloud STT
    participant Match as Matching Service
    participant DB as PostgreSQL

    User->>App: Tap "Record" button
    App->>App: Start audio recording (5-15 seconds)
    User->>App: Recording completes

    App->>App: Validate audio (duration, volume)
    App->>API: POST /api/v1/search (audio bytes)

    API->>STT: Send audio for transcription
    STT-->>API: Return Arabic transcription

    API->>Match: find_matches(transcription)
    Match-->>API: Return ranked results

    API->>DB: Save Search record
    API-->>App: Return results with confidence

    alt Confidence ≥80%
        App->>User: Show result(s) ≥80% only
    else Confidence 55-79%
        App->>User: Show 2-3 suggestions
    else Confidence <55%
        App->>User: "Could not identify verse"
    end
```

## Workflow 2: Feedback Submission

```mermaid
sequenceDiagram
    autonumber
    participant User
    participant App as Mobile App
    participant API as FastAPI Backend
    participant DB as PostgreSQL

    alt User taps a result
        User->>App: Tap verse result
        App->>API: POST /api/v1/feedback (implicit)
        API->>DB: Save Feedback
        App->>App: Navigate to Quran Reader
    else User taps thumbs up/down
        User->>App: Tap feedback button
        App->>API: POST /api/v1/feedback (explicit)
        API->>DB: Save Feedback
        App->>User: "Thank you!"
    end
```

## Workflow 3: Subscription Management

```mermaid
sequenceDiagram
    autonumber
    participant User
    participant App as Mobile App
    participant RC as RevenueCat SDK
    participant API as FastAPI Backend
    participant DB as PostgreSQL

    User->>App: Tap "Upgrade to Premium"
    App->>App: Show Paywall (pricing options)
    User->>App: Select subscription ($1/mo or $10/yr)

    App->>RC: Purchase subscription
    RC->>RC: Handle Apple IAP / Google Play Billing
    RC-->>App: Purchase successful

    RC->>API: Webhook: INITIAL_PURCHASE
    API->>DB: Create/Update Subscription (active)
    API-->>RC: 200 OK

    App->>User: "Welcome to Premium!"
```

## Workflow 4: Usage Limit Enforcement

```mermaid
sequenceDiagram
    autonumber
    participant User
    participant App as Mobile App
    participant API as FastAPI Backend
    participant DB as PostgreSQL

    User->>App: Tap "Listen" (initiate search)
    App->>API: POST /api/v1/search

    API->>DB: Check subscription status
    API->>DB: Check usage (daily/monthly)

    alt Premium User
        API->>API: Process search (no limits)
    else Free User Under Limits
        API->>DB: Increment usage counters
        API->>API: Process search
    else Free User At Limit (has bonus)
        API->>DB: Use bonus search
        API->>API: Process search
    else Free User At Limit (no bonus)
        API-->>App: 429 Too Many Requests + usage info
        App->>User: Show limit reached screen
        User->>App: Watch rewarded ad OR upgrade
    end

    API-->>App: Return results
```

## Workflow 5: Bonus Search (Watch-to-Unlock)

```mermaid
sequenceDiagram
    autonumber
    participant User
    participant App as Mobile App
    participant AdMob as Google AdMob
    participant API as FastAPI Backend
    participant DB as PostgreSQL

    User->>App: Tap "Watch Video for 1 Search"
    App->>AdMob: Request rewarded video ad
    AdMob-->>App: Show rewarded video (15-30s)

    User->>App: Complete watching video
    AdMob-->>App: Ad completed callback

    App->>API: POST /api/v1/users/{id}/bonus-search
    API->>DB: Check bonus limit (max 3/day)
    API->>DB: Grant bonus search
    API-->>App: Bonus granted + usage summary

    App->>User: "Bonus search unlocked!"
```
