# Test Strategy and Standards

[Back to Architecture Index](../index.md)

---

## Testing Philosophy

- **Approach:** Test-after for MVP speed

## Coverage Goals

- Matching algorithm: **90%+**
- Backend overall: **80%+**
- Mobile: **70%+**

## Test Types

| Type | Framework | Location | Purpose |
|------|-----------|----------|---------|
| Unit | pytest | `tests/unit/` | Services, repositories |
| Integration | pytest + testcontainers | `tests/integration/` | API + DB |
| E2E | Manual (MVP) | N/A | Critical user journeys |
| Mobile Unit | flutter_test + mockito | `test/` | Provider logic |

## Test Data Management

- **Strategy:** Factory pattern
- **Fixtures:** `tests/fixtures/`
- **Cleanup:** Transaction rollback between tests
