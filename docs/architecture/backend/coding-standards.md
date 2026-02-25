# Coding Standards

[Back to Architecture Index](../index.md)

---

## Core Standards

- **Backend:** Python 3.12, `ruff` + `mypy`
- **Mobile:** Dart 3.5.x, `very_good_analysis`
- **Test Organization:** `tests/unit/` and `tests/integration/`

## Critical Rules

| Rule | Description |
|------|-------------|
| **No print statements** | Use `structlog` logger |
| **No hardcoded secrets** | All secrets via environment variables |
| **Arabic text handling** | Always use UTF-8 encoding |
| **Quran text is read-only** | Never modify `quran.json` at runtime |
| **No raw SQL** | Use SQLAlchemy ORM/queries |
| **API responses use schemas** | All endpoints return Pydantic models |
| **Async all the way** | Backend uses `async def` |
| **Riverpod for state** | Mobile features use Riverpod providers |
