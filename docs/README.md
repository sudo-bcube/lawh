# Lawh - Documentation Index

**Project:** Lawh - Quranic Verse Identification App
**Last Updated:** February 10, 2026

---

## 🚀 Quick Start for Developers

### Critical Decisions Made

| Decision | Choice | Document |
|----------|--------|----------|
| **STT Provider** | ✅ Google Cloud Speech-to-Text | [STT Decision](./archive/decision-making/azure-stt-quick-summary.md.archive) |
| **Framework** | Flutter (Dart 3.5+) | [Frontend Architecture](./architecture/frontend/overview.md) |
| **State Management** | Riverpod 2.5+ | [State Management](./architecture/frontend/state-management.md) |
| **Routing** | go_router 14.0+ | [Routing](./architecture/frontend/routing.md) |
| **Backend** | Python FastAPI | [Backend Overview](./architecture/backend/high-level-overview.md) |
| **Database** | PostgreSQL (user data) + JSON (Quran) | [Data Models](./architecture/backend/data-models.md) |

### Why Google Cloud STT?

- ✅ **Pure Arabic transcription** (no English garbage like Azure)
- ✅ **60-70% accuracy** on live recordings
- ✅ **Viable for fuzzy matching** with 40% similarity threshold
- ❌ Azure failed with "Who do we do" and "Switch ing" on user recordings

**See full comparison:** [azure-stt-quick-summary.md.archive](./archive/decision-making/azure-stt-quick-summary.md.archive)

---

## 📚 Documentation Structure

### 1. Architecture (Current)

**[Architecture Index](./architecture/index.md)** - Complete technical architecture

#### Backend Architecture (`architecture/backend/`)
| Document | Description |
|----------|-------------|
| [High-Level Overview](./architecture/backend/high-level-overview.md) | Technical summary, diagrams |
| [Tech Stack](./architecture/backend/tech-stack.md) | Python, FastAPI, PostgreSQL |
| [Data Models](./architecture/backend/data-models.md) | Entity definitions, ER diagram |
| [API Specification](./architecture/backend/api-spec.md) | REST endpoints |
| [Database Schema](./architecture/backend/database-schema.md) | PostgreSQL DDL |
| [Infrastructure](./architecture/backend/infrastructure.md) | DigitalOcean, CI/CD |

#### Frontend Architecture (`architecture/frontend/`)
| Document | Description |
|----------|-------------|
| [Frontend Overview](./architecture/frontend/overview.md) | Framework selection |
| [Tech Stack](./architecture/frontend/tech-stack.md) | Flutter packages |
| [State Management](./architecture/frontend/state-management.md) | Riverpod patterns |
| [Project Structure](./architecture/frontend/project-structure.md) | Clean Architecture |
| [Component Standards](./architecture/frontend/component-standards.md) | Templates, naming |

### 2. Product Requirements

**[PRD Index](./prd/index.md)** - Product requirements and epics
- [Goals & Background](./prd/goals-and-background-context.md)
- [Requirements](./prd/requirements.md)
- [Epic List](./prd/epic-list.md) - 6 epics covering full MVP scope

### 3. Project Foundation

| Document | Description |
|----------|-------------|
| [brief.md](./brief.md) | Original project brief |
| [brainstorming-session-results.md](./brainstorming-session-results.md) | Initial brainstorming session |

### 4. Archived Decision-Making Documents

Located in `archive/decision-making/`:

| Document | Description |
|----------|-------------|
| [azure-stt-quick-summary.md.archive](./archive/decision-making/azure-stt-quick-summary.md.archive) | ⭐ STT provider decision summary |
| [azure-stt-test-results.md.archive](./archive/decision-making/azure-stt-test-results.md.archive) | Detailed STT test results |
| [test-azure-stt.md.archive](./archive/decision-making/test-azure-stt.md.archive) | Azure testing guide |
| [test-google-stt.md.archive](./archive/decision-making/test-google-stt.md.archive) | Google testing guide |
| [setup-quran-database.md.archive](./archive/decision-making/setup-quran-database.md.archive) | Quran database setup |
| [front-end-spec.md.archive](./archive/decision-making/front-end-spec.md.archive) | Original UI/UX specification |

### 5. Testing Scripts

Located in `scripts/` directory:

| Script | Purpose | Usage |
|--------|---------|-------|
| `setup_test_audio.sh` | Download test audio files | `./scripts/setup_test_audio.sh` |
| `setup_test_audio.py` | Python version (cross-platform) | `python3 scripts/setup_test_audio.py` |
| `test_google_stt_simple.sh` | Test Google Cloud STT | `./scripts/test_google_stt_simple.sh GOOGLE_API_KEY` |

---

## 🔑 Environment Variables

Create `.env.development` and `.env.production` files:

```bash
# Google Cloud Speech-to-Text
GOOGLE_CLOUD_STT_API_KEY=your_api_key_here

# Firebase (Analytics & Crashlytics)
FIREBASE_API_KEY=your_firebase_key

# Stripe (Sadaqah donations)
STRIPE_PUBLISHABLE_KEY=your_stripe_key

# Feature Flags
ENABLE_DEBUG_LOGGING=true  # false in production
ENABLE_LOCATION_COLLECTION=true
```

**Security:** Never commit `.env*` files to git. Add to `.gitignore`.

---

## 📊 Key Metrics & Success Criteria

### Technical Metrics
- ✅ **STT Success Rate:** >90% (API returns valid Arabic text)
- ✅ **Fuzzy Match Success:** >80% (correct verse in top 5)
- ✅ **User Selection Rate:** >70% (user finds correct verse)
- ✅ **API Latency:** <5 seconds (recording to results)
- ✅ **Cost per User:** <$0.50/month (for 10 verses/user)

### User Experience Metrics
- ✅ **First-Match Accuracy:** >50% (correct verse is #1)
- ✅ **Top-3 Accuracy:** >70% (correct verse in top 3)
- ✅ **Re-record Rate:** <30% (users satisfied with matches)
- ✅ **Task Completion:** >85% (successfully identify & share)

---

## 💰 Cost Estimates

### Google Cloud STT
- **Free Tier:** 60 minutes/month
- **Paid Tier:** $0.024/minute (~$1.44/hour)
- **Per Verse:** ~$0.014 (10-second recording)

### MVP Phase (100 users, 10 verses each)
```
1,000 verses × 10 seconds = 10,000 seconds = 167 minutes
167 min - 60 free = 107 paid minutes
107 min × $0.024 = $2.57/month
```

### Post-MVP (1,000 users, 50 verses each)
```
50,000 verses × 10 seconds = 500,000 seconds = 8,333 minutes
8,333 min × $0.024 = $200/month
```

**Conclusion:** Cost scales reasonably with usage.

---

## 🚨 Common Issues & Solutions

### Issue: "Who do we do" English output
**Solution:** You're using Azure STT. Switch to Google Cloud STT.
**See:** [azure-stt-quick-summary.md.archive](./archive/decision-making/azure-stt-quick-summary.md.archive)

### Issue: Low fuzzy matching accuracy
**Solution:**
1. Check STT is returning pure Arabic
2. Tune similarity threshold (try 35-45%)
3. Ensure diacritics are removed in cleaning function

### Issue: Google Cloud API authentication failed
**Solution:**
1. Verify API key is correct
2. Check Speech-to-Text API is enabled in Google Cloud Console
3. Verify API key restrictions (should allow STT API)

### Issue: Audio recording not working
**Solution:**
1. Check microphone permissions (iOS/Android)
2. Verify audio format (WAV 16kHz mono)
3. Test with Flutter Sound example app

---

## 📞 Support & Resources

### External Resources
- [Google Cloud STT Documentation](https://cloud.google.com/speech-to-text/docs)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Quran.com API](https://alquran.cloud/api)

### Project Resources
- Test Audio Files: `test_audio/samples/` (17 WAV files)
- Test Scripts: `scripts/`
- Documentation: `docs/`

---

## 📝 Document Versions

| Document | Version | Last Updated |
|----------|---------|--------------|
| README.md | 2.0 | 2026-02-10 |
| Architecture (sharded) | 2.0 | 2026-02-10 |
| PRD (sharded) | 1.0 | 2026-02-03 |

---

**Ready to start development?** Read the [Architecture Index](./architecture/index.md) first.

**Questions about STT testing?** See [azure-stt-quick-summary.md.archive](./archive/decision-making/azure-stt-quick-summary.md.archive) for the decision summary.
