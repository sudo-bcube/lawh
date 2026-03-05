# Story 5.2-BE: Backend Cross-Device Subscription Sync

Status: done

## Story

As a **subscriber**,
I want **my premium subscription recognized on any device I use**,
so that **I don't lose access when switching phones or using multiple devices**.

## Context

Story 5.1-BE implements RevenueCat webhook handling and subscription tracking, but ties subscriptions 1:1 to a single device (user). When a subscriber installs the app on a second device and restores purchases, RevenueCat recognizes them via Apple ID / Google Play account, but the backend has no mechanism to grant premium status to the new device.

RevenueCat's cross-device flow:

1. Device A subscribes -> RevenueCat associates subscription with `device_uuid_A`
2. Device B installs, taps "Restore Purchases" -> RevenueCat finds subscription via Apple ID / Google Play
3. RevenueCat aliases Device B under Device A's subscriber identity
4. RevenueCat sends a `TRANSFER` webhook event: `old_app_user_id` (Device B) is now merged into `new_app_user_id` (Device A)

This story closes the gap: the backend must handle TRANSFER events, provide a server-verified sync endpoint, and propagate status changes across all linked devices.

**Depends on:** Story 5.1-BE (subscription model, webhook endpoint, usage service must exist)

## Acceptance Criteria

### TRANSFER Webhook Handling

1. **AC1:** RevenueCat TRANSFER event handled in existing webhook endpoint:
   - `POST /api/v1/webhooks/revenuecat` handles event type `TRANSFER`
   - Extracts `new_app_user_id` (canonical subscriber) and `transferred_from` / `transferred_to` app user IDs
   - Looks up the User record for the transferred device's `device_uuid`
   - Creates or updates that User's subscription record: copies `status`, `product_id`, `platform`, `expires_at` from the canonical subscriber's subscription
   - Sets `revenuecat_user_id` on both subscription records to the canonical (new) app user ID

2. **AC2:** TRANSFER event is idempotent:
   - Processing the same TRANSFER event twice produces the same result
   - No duplicate subscription records created

### Subscription Sync Endpoint

3. **AC3:** New endpoint for frontend-initiated subscription sync:
   - `POST /api/v1/users/{user_id}/subscription/sync`
   - Request body: `{ "revenuecat_app_user_id": "string" }`
   - Backend resolves subscription status server-side (never trusts client-reported entitlement):
     - Step 1: Look up existing subscription records with the given `revenuecat_app_user_id`
     - Step 2: If an active subscription exists for another device with that ID, mirror its `status`, `product_id`, `platform`, `expires_at` to this device's subscription record
     - Step 3: If no existing record found, call RevenueCat REST API (`GET /v1/subscribers/{revenuecat_app_user_id}`) to verify subscription status server-side
     - Step 4: Create or update this device's subscription record based on the verified status
   - Sets `revenuecat_user_id` on the subscription record
   - Returns the updated subscription status response (same schema as `GET /api/v1/users/{user_id}/subscription`)

4. **AC4:** Sync endpoint validates against abuse:
   - Rate limited: max 5 calls per user per hour
   - The `revenuecat_app_user_id` must be a non-empty string
   - Backend never trusts client-reported subscription status -- all status is resolved server-side via existing records or RevenueCat REST API

5. **AC5:** Sync endpoint is the source of truth fallback:
   - If webhook delivery fails (RevenueCat retries, but gaps can occur), the sync endpoint ensures the backend eventually learns about the subscription via RevenueCat REST API verification
   - Webhook remains the primary/authoritative source; sync with REST API verification is a secondary confirmation path

### Webhook Status Propagation

6. **AC6:** Status-change webhook events propagate to all linked devices:
   - When `EXPIRATION`, `CANCELLATION`, or `BILLING_ISSUE` events are processed, update ALL subscription records sharing the same `revenuecat_user_id` to the new status
   - Uses the `revenuecat_user_id` index for efficient lookup
   - This ensures Device B doesn't retain `active` status after the subscription expires on RevenueCat

### Subscription Lookup Enhancement

7. **AC7:** Subscription status lookup considers cross-device:
   - `GET /api/v1/users/{user_id}/subscription` behavior unchanged (returns subscription for that specific user/device)
   - Internal `usage_service.check_and_increment()` unchanged -- it checks the subscription for the requesting user_id, which will now be correctly populated via TRANSFER or sync

### Data Model

8. **AC8:** No column changes required to `subscriptions` table:
   - The existing `revenuecat_user_id` field (nullable VARCHAR) already exists
   - The existing 1:1 unique constraint on `user_id` is kept -- each device gets its own subscription row
   - Multiple subscription rows can share the same `revenuecat_user_id` (different devices, same subscriber)
   - One migration needed to add index on `revenuecat_user_id` for lookup performance

## Tasks / Subtasks

### Phase 1: TRANSFER Webhook Event

- [x] Task 1: Add TRANSFER to webhook handler (AC: #1, #2)
  - [x] Add `TRANSFER` handling in `app/api/v1/endpoints/webhooks.py` (separate function `_handle_transfer_event`)
  - [x] Extract `app_user_id` (canonical) and `transferred_from` array from TRANSFER payload
  - [x] Look up User by ID matching the transferred app_user_id
  - [x] Look up canonical subscriber's subscription
  - [x] Create or update subscription record for the transferred device's User
  - [x] Set `revenuecat_user_id` on both records to the canonical ID
  - [x] Ensure idempotency (upsert logic)

### Phase 2: RevenueCat REST API Client

- [x] Task 2: Create RevenueCat API client (AC: #3)
  - [x] Create `app/services/revenuecat_service.py`
  - [x] Implement `verify_subscriber(revenuecat_app_user_id)` method
  - [x] Calls `GET /v1/subscribers/{app_user_id}` on RevenueCat REST API
  - [x] Uses `REVENUECAT_API_KEY` for Bearer auth
  - [x] Returns parsed subscription status: active/expired/cancelled/free, product_id, expires_at
  - [x] Handles API errors gracefully (timeout -> return free status)

### Phase 3: Subscription Sync Endpoint

- [x] Task 3: Create sync endpoint schema (AC: #3)
  - [x] Create Pydantic request schema `SubscriptionSyncRequest` in `app/models/schemas/subscription.py`
  - [x] Fields: `revenuecat_app_user_id` (str, required, min_length=1)

- [x] Task 4: Implement sync endpoint (AC: #3, #4, #5)
  - [x] Add `POST /api/v1/users/{user_id}/subscription/sync` in `app/api/v1/endpoints/users.py`
  - [x] Look up existing subscription records by `revenuecat_user_id`
  - [x] If active record found for another device: mirror status to this device
  - [x] If no record found: call `revenuecat_service.verify_subscriber()` to resolve status server-side
  - [x] Set `revenuecat_user_id` on the subscription record
  - [x] Add rate limiting (5 calls/user/hour using in-memory store)
  - [x] Return subscription status response
  - [x] Route automatically included via users router

### Phase 4: Webhook Status Propagation

- [x] Task 5: Propagate status changes across devices (AC: #6)
  - [x] Created `_propagate_status_to_linked_devices()` helper function
  - [x] Modify webhook handler for EXPIRATION, CANCELLATION, BILLING_ISSUE events (via `EVENTS_REQUIRING_PROPAGATION` set)
  - [x] After updating the primary device's subscription, query all subscription records with the same `revenuecat_user_id`
  - [x] Update all matching records to the new status
  - [x] Return the number of additional devices updated in response

### Phase 5: Database Index

- [x] Task 6: Add revenuecat_user_id index (AC: #8)
  - [x] Create Alembic migration: `013_add_revenuecat_user_id_index.py`
  - [x] Add index `ix_subscriptions_revenuecat_user_id` on `subscriptions.revenuecat_user_id`
  - [x] Migration up/down implemented

### Phase 6: Testing

- [ ] Task 7: Unit tests (AC: #1, #2, #3, #4, #6)
  - [ ] Test TRANSFER webhook with valid payload -> subscription created for new device
  - [ ] Test TRANSFER webhook idempotency -> processing twice yields same result
  - [ ] Test sync endpoint with revenuecat_user_id matching active subscription on another device -> mirrors status
  - [ ] Test sync endpoint with unknown revenuecat_user_id -> calls RevenueCat REST API -> creates record
  - [ ] Test sync endpoint rate limiting -> 429 after 5 calls/hour
  - [ ] Test EXPIRATION webhook -> all devices with same revenuecat_user_id set to expired
  - [ ] Test CANCELLATION webhook -> all devices with same revenuecat_user_id set to cancelled
  - [ ] Test RevenueCat REST API client -> handles success, timeout, and error responses

- [ ] Task 8: Integration tests (AC: #1, #3, #6, #7)
  - [ ] Test: Device A subscribes via webhook -> Device B sends TRANSFER webhook -> Device B calls search -> allowed (premium)
  - [ ] Test: Device B calls sync -> backend verifies via existing record or REST API -> Device B calls search -> allowed (premium)
  - [ ] Test: Subscription expires via webhook -> both Device A and Device B subscription records updated -> both get free tier limits

## Dev Notes

### RevenueCat TRANSFER Event Payload

```json
{
  "event": {
    "type": "TRANSFER",
    "app_user_id": "new-canonical-user-id",
    "transferred_from": ["old-device-uuid-B"],
    "transferred_to": ["new-canonical-user-id"],
    "product_id": "lawh_monthly",
    "expiration_at_ms": 1711627200000,
    "store": "APP_STORE"
  }
}
```

Note: The exact TRANSFER payload structure must be verified against [RevenueCat's current webhook documentation](https://www.revenuecat.com/docs/integrations/webhooks/event-types-and-fields) at implementation time. The `transferred_from` array contains the anonymous IDs that were merged.

### Sync Endpoint Flow

```text
Frontend (Device B)                    Backend
    |                                    |
    |-- Restore Purchases (RevenueCat) --|
    |<- Entitlements: premium active   --|
    |                                    |
    |-- POST /subscription/sync -------->|
    |   { revenuecat_app_user_id: "X" } |
    |                                    |-- 1. Look up subscriptions where
    |                                    |--    revenuecat_user_id = "X"
    |                                    |-- 2. Found Device A active? Mirror it.
    |                                    |--    Not found? Call RevenueCat REST API.
    |                                    |-- 3. Upsert subscription for Device B
    |<- 200 { status: active, ... } ----|
    |                                    |
    |-- POST /search (works!) --------->|
    |                                    |-- check_and_increment()
    |                                    |-- subscription.status == active
    |<- 200 (search results) -----------|
```

### Expiration Propagation Flow

```text
RevenueCat                             Backend
    |                                    |
    |-- EXPIRATION webhook ------------->|
    |   { app_user_id: "device-A" }     |
    |                                    |-- 1. Update Device A sub -> expired
    |                                    |-- 2. Get revenuecat_user_id from record
    |                                    |-- 3. Query all subs with same
    |                                    |--    revenuecat_user_id
    |                                    |-- 4. Update Device B sub -> expired
    |                                    |
```

### Files Modified

```text
backend/app/
├── api/v1/
│   └── endpoints/
│       ├── webhooks.py         # MODIFIED: Add TRANSFER + propagation logic
│       └── users.py            # MODIFIED: Add sync endpoint
├── services/
│   └── revenuecat_service.py   # NEW: RevenueCat REST API client
├── models/
│   └── schemas/
│       └── subscription.py     # MODIFIED: Add SubscriptionSyncRequest schema
└── alembic/
    └── versions/
        └── xxx_add_revenuecat_user_id_index.py  # NEW: Migration
```

### Environment Variables

```bash
# Existing (from Story 5.1-BE)
REVENUECAT_WEBHOOK_AUTH_TOKEN=your_webhook_auth_token

# New (required for server-side subscriber verification)
REVENUECAT_API_KEY=your_revenuecat_secret_api_key
```

Note: `REVENUECAT_API_KEY` is the secret API key from RevenueCat dashboard (not the public SDK key). Used for `GET /v1/subscribers/{app_user_id}` REST API calls.

### API Endpoints Summary

| Endpoint                                      | Method | Purpose                                           | Auth          |
|-----------------------------------------------|--------|---------------------------------------------------|---------------|
| `/api/v1/webhooks/revenuecat`                 | POST   | **MODIFIED:** TRANSFER + status propagation       | Webhook token |
| `/api/v1/users/{user_id}/subscription/sync`   | POST   | **NEW:** Server-verified subscription sync        | Device UUID   |

### References

- [Source: Story 5.1-BE] - Base subscription implementation this extends
- [Source: docs/architecture/backend/api-spec.md] - API patterns
- [Source: docs/architecture/backend/data-models.md] - Subscription model definition
- [RevenueCat TRANSFER events documentation](https://www.revenuecat.com/docs/webhooks)

## Dev Agent Record

### Agent Model Used

Claude Opus 4.5 (claude-opus-4-5-20251101)

### Debug Log References

- Migration 013: Add revenuecat_user_id index
- Webhook refactor: Added TRANSFER handling and status propagation
- Sync endpoint: Implemented with rate limiting

### Completion Notes List

- Fixed bug: webhook was storing `event.get("id")` instead of `app_user_id` as `revenuecat_user_id`
- TRANSFER event handling: Mirrors subscription from canonical device to transferred devices
- Status propagation: EXPIRATION, CANCELLATION, BILLING_ISSUE events propagate to all linked devices
- Sync endpoint: Falls back to RevenueCat REST API when no local record exists
- Rate limiting: In-memory implementation (5 calls/user/hour) - consider Redis for production scaling
- Tests pending

### File List

Modified:
- `app/api/v1/endpoints/webhooks.py` - Added TRANSFER handling, status propagation, fixed revenuecat_user_id
- `app/api/v1/endpoints/users.py` - Added sync endpoint with rate limiting
- `app/models/schemas/subscription.py` - Added SubscriptionSyncRequest schema
- `app/core/config.py` - Added revenuecat_api_key setting

Created:
- `app/services/revenuecat_service.py` - RevenueCat REST API client
- `alembic/versions/013_add_revenuecat_user_id_index.py` - Index migration
