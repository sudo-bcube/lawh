# Security

[Back to Architecture Index](../index.md)

---

## Input Validation

- **Library:** Pydantic v2
- **Location:** API boundary (request models)
- **Approach:** Whitelist validation

## Authentication & Authorization

- **Method:** Anonymous device UUID
- **Rate Limiting:** 30 searches/minute per device

## Secrets Management

- **Development:** `.env` file (gitignored)
- **Production:** DigitalOcean environment variables

## API Security

- **HTTPS:** Enforced on all endpoints
- **CORS:** Restricted to production domains
- **Security Headers:** X-Content-Type-Options, X-Frame-Options, X-XSS-Protection

## Data Protection

- **Encryption at Rest:** DO Managed PostgreSQL (encrypted)
- **Encryption in Transit:** TLS 1.2+
- **PII:** No names, emails, phone numbers collected
- **Logging:** Never log full UUIDs, transcriptions, or IPs

## Dependency Security

- **Scanning:** `pip-audit`, `gitleaks`
- **Update Policy:** Patch critical CVEs within 7 days
