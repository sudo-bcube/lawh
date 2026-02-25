# Error Handling Strategy

[Back to Architecture Index](../index.md)

---

## General Approach

- **Error Model:** Structured error responses with codes and messages
- **Exception Hierarchy:** Custom `LawhException` base class
- **Error Propagation:** Exceptions bubble up to API layer

## Standard Error Response

```json
{
  "error_code": "STT_ERROR",
  "message": "Voice recognition service temporarily unavailable",
  "details": {},
  "request_id": "abc-123"
}
```

## Logging Standards

- **Library:** `structlog` 24.x (JSON format)
- **Levels:** DEBUG, INFO, WARNING, ERROR, CRITICAL
- **Required Context:** `request_id`, `service`, `environment`, `event`, `duration_ms`

## Error Handling Patterns

**External API Errors:**
- Retry: Exponential backoff, max 2 retries
- Circuit Breaker: Open after 5 failures, half-open after 30s
- Timeouts: Google STT 30s, Stripe 15s

## Error Code Registry

| Code | HTTP | Description |
|------|------|-------------|
| `AUDIO_TOO_SHORT` | 400 | Recording under 10 seconds |
| `AUDIO_TOO_LONG` | 400 | Recording over 15 seconds |
| `STT_ERROR` | 503 | Google STT unavailable |
| `MATCH_NONE` | 200 | No verse matched |
| `PAY_DECLINED` | 402 | Payment declined |
