# Epic 1: Foundation & Core Infrastructure

**Expanded Goal:** Establish the complete technical foundation for Lawh by setting up the backend API framework (Python FastAPI), downloading and populating the local Quran text database from Tanzil.net or EveryAyah.com, initializing the Flutter mobile project for iOS and Android, implementing anonymous UUID generation for privacy-first user tracking, configuring the Git repository with CI/CD pipeline, deploying to staging environment, and creating a health-check endpoint. This epic validates that the entire technology stack works together before building any features, reducing risk and establishing a solid foundation for all subsequent development work.

---

## Story 1.1: Backend API Foundation Setup

**As a** developer,
**I want** a working Python FastAPI backend with basic project structure and routing,
**so that** I have a foundation to build API endpoints for verse identification.

### Acceptance Criteria

1. Python 3.11+ virtual environment created with FastAPI and required dependencies installed
2. Project structure established: `/backend` directory with `main.py`, `requirements.txt`, and modular folders (`/api`, `/models`, `/services`)
3. FastAPI app initialized with basic configuration (CORS, middleware)
4. Health-check endpoint `GET /health` returns `{"status": "ok"}` with 200 status code
5. Local development server runs successfully on `http://localhost:8000`
6. API documentation auto-generated and accessible at `/docs` (Swagger UI)
7. Environment variables configuration file (`.env`) created for API keys and secrets
8. `.gitignore` configured to exclude `.env`, `__pycache__`, and virtual environment

---

## Story 1.2: Local Quran Text Database Setup

**As a** developer,
**I want** the Quran text (Madinah Mushaf) downloaded from Tanzil.net or EveryAyah.com and stored locally in the backend,
**so that** the fuzzy matching algorithm can compare STT output against it without external API calls.

### Acceptance Criteria

1. Setup script (`scripts/setup_quran_db.py`) downloads Quran text from Tanzil.net (XML/JSON format) or EveryAyah.com
2. Quran text is Madinah Mushaf, Uthmani script, Hafs recitation
3. Text is parsed and populated into PostgreSQL database with schema: `quran_verses (surah_number, verse_number, arabic_text, transliteration)`
4. Database table contains all 6,236 verses from the Quran
5. Script validates data integrity: No missing verses, correct verse count per surah
6. Attribution to Tanzil.net or EveryAyah.com documented in code comments per license requirements
7. Database query test: Retrieve specific verse (e.g., Al-Fatiha 1:1) returns correct Arabic text
8. Query performance: Retrieving any single verse takes <50ms

---

## Story 1.3: PostgreSQL Database Configuration

**As a** developer,
**I want** a PostgreSQL database configured for user data, searches, feedback, and Quran text,
**so that** the backend can persist and query all application data.

### Acceptance Criteria

1. PostgreSQL database created locally (or via DigitalOcean/Supabase managed service)
2. Database connection established from FastAPI backend using SQLAlchemy or similar ORM
3. Initial schema created for core tables:
   - `quran_verses` (surah_number, verse_number, arabic_text, transliteration)
   - `users` (uuid, created_at, last_active)
   - `searches` (id, user_uuid, audio_file_path, stt_transcription, result_verses, confidence_score, created_at, location)
   - `feedback` (id, search_id, feedback_type, created_at)
4. Database migrations system configured (Alembic or equivalent) for schema versioning
5. Connection pooling configured for concurrent requests
6. Database credentials stored in environment variables (not hardcoded)
7. Test: Insert and retrieve data from each table successfully

---

## Story 1.4: Flutter Mobile App Shell (iOS & Android)

**As a** developer,
**I want** a Flutter project initialized with iOS and Android targets and basic navigation,
**so that** I can build mobile UI in subsequent epics.

### Acceptance Criteria

1. Flutter project created in `/mobile` directory with latest stable Flutter SDK
2. iOS and Android targets configured and build successfully
3. Basic app structure: Main screen with placeholder "Listen" button (non-functional)
4. App runs on iOS Simulator and Android Emulator without errors
5. App icon placeholder and splash screen configured
6. Navigation framework set up (Navigator 2.0 or go_router)
7. HTTP client configured (dio or http package) for API communication
8. Environment configuration for API base URL (staging vs production)
9. Basic theming applied: Dark green (dark lemon) primary color, snow white background

---

## Story 1.5: Anonymous UUID Generation System

**As a** user,
**I want** the app to generate and store a unique anonymous identifier on my device,
**so that** my searches and feedback can be linked for algorithm improvement without revealing my identity.

### Acceptance Criteria

1. On first app launch, generate a UUID v4 and store it securely on device (iOS Keychain, Android Keystore)
2. UUID persists across app restarts and is never regenerated
3. UUID is sent with all API requests (`X-User-UUID` header or similar)
4. Backend stores UUID in `users` table on first request
5. No personal data (name, email, phone) is collected or associated with UUID
6. User can request UUID deletion via settings (FR7, GDPR compliance)
7. UUID is not transmitted to third parties (Azure STT, Stripe) except as anonymous identifier
8. Test: Uninstall and reinstall app generates NEW UUID (device-based, not server-based)

---

## Story 1.6: Git Repository & Version Control

**As a** developer,
**I want** a Git repository with proper structure and version control practices,
**so that** code is tracked, backed up, and collaborative development is supported.

### Acceptance Criteria

1. Git repository initialized with `.gitignore` for Python, Flutter, and environment files
2. Repository structure: `/backend`, `/mobile`, `/web` (placeholder), `/shared`, `/docs`, `/scripts`
3. Initial commit with project foundation code
4. Remote repository created (GitHub or GitLab)
5. Branching strategy documented: `main` for production, `develop` for integration, feature branches
6. Sensitive files (`.env`, API keys, credentials) excluded from version control
7. README.md created with project overview and setup instructions

---

## Story 1.7: CI/CD Pipeline Setup

**As a** developer,
**I want** an automated CI/CD pipeline for testing and deployment,
**so that** code changes are validated and deployed consistently.

### Acceptance Criteria

1. CI/CD platform configured (GitHub Actions or GitLab CI)
2. Automated tests run on every commit: Backend unit tests, linting (flake8/black for Python)
3. Backend deployment to staging environment (DigitalOcean Droplet or Heroku) on `develop` branch merge
4. Flutter mobile builds triggered for iOS and Android (optional for Epic 1, can defer to Epic 3)
5. Deployment rollback capability documented
6. Pipeline status visible in repository (badges or dashboard)
7. Secrets management: API keys and credentials stored securely in CI/CD environment variables

---

## Story 1.8: Staging Environment Deployment

**As a** developer,
**I want** the backend API deployed to a staging environment accessible via HTTPS,
**so that** I can test integration with mobile apps and validate the deployment process.

### Acceptance Criteria

1. Backend API deployed to DigitalOcean Droplet ($6/month) or Heroku Eco ($7/month)
2. HTTPS/TLS enabled with SSL certificate (Let's Encrypt or platform-provided)
3. Domain or subdomain configured: `https://staging-api.lawh.app` or similar
4. Health-check endpoint accessible: `GET https://staging-api.lawh.app/health` returns 200 OK
5. PostgreSQL database deployed and connected (managed service or same server)
6. Environment variables configured for staging (Azure STT API keys, Stripe test keys, database credentials)
7. Basic monitoring: Server uptime checks, error logging to console/file
8. Deployment documentation: How to deploy updates, rollback, and access logs

---

## Epic 1 Summary

**Stories:** 8 stories covering backend foundation, Quran database, Flutter shell, UUID system, Git/CI/CD, and staging deployment

**Estimated Effort:** 3-4 days for solo developer

**Critical Dependencies:**
- Story 1.2 (Quran DB) and Story 1.3 (PostgreSQL) are blockers for Epic 2
- Story 1.4 (Flutter shell) is a blocker for Epic 3

**Definition of Done:**
- All 8 stories completed with acceptance criteria met
- Health-check endpoint returns 200 OK from staging environment
- Flutter app runs on iOS and Android simulators
- Quran database contains all 6,236 verses and queries perform <50ms
- Git repository with CI/CD pipeline functioning
