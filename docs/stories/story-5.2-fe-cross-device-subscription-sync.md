# Story 5.2-FE: Frontend Cross-Device Subscription Sync

Status: complete

## Story

As a **subscriber using a new device**,
I want **to restore my subscription and immediately get premium access**,
so that **I can use Lawh without ads or limits on all my devices**.

## Context

Story 5.1-FE implements RevenueCat SDK integration and a "Restore Purchases" button. However, after a successful restore, the frontend doesn't notify the backend. The backend still sees this device as a free-tier user, which means server-side usage enforcement blocks premium features.

This story closes the loop: after RevenueCat confirms entitlements (via initial purchase, restore, or app launch check), the frontend syncs that status with the backend via a new sync endpoint (from Story 5.2-BE).

**Depends on:** Story 5.1-FE (RevenueCat SDK, subscription provider, paywall must exist), Story 5.2-BE (sync endpoint must exist)

## Acceptance Criteria

### Subscription Sync After Restore

1. **AC1:** After successful "Restore Purchases", frontend calls backend sync:
   - Call `POST /api/v1/users/{user_id}/subscription/sync` with `{ "revenuecat_app_user_id": "<id from SDK>" }`
   - The `user_id` in the URL is the server-side UUID returned from `POST /users/register` (stored locally after device registration in Story 5.1)
   - Backend verifies subscription status server-side (frontend does not send entitlement claims)
   - On sync success: update local subscription state from response
   - On sync failure: still treat user as premium locally (RevenueCat SDK is client-side source of truth), retry sync on next app launch

2. **AC2:** After successful purchase (initial subscribe), frontend calls backend sync:
   - Same sync call as AC1
   - Ensures backend knows about the subscription even before the webhook arrives (webhook may be delayed)

### Subscription Sync on App Launch

3. **AC3:** On every app launch, after RevenueCat entitlement check:
   - If entitlement status changed from cached state (e.g., was free, now premium after restore on another device via same Apple ID): call sync endpoint
   - If entitlement status unchanged: skip sync (avoid unnecessary API calls)
   - Store last-synced entitlement state in SharedPreferences for comparison

4. **AC4:** Sync is fire-and-forget on launch:
   - Do not block app startup waiting for sync response
   - Local RevenueCat entitlement check determines UI state immediately
   - Sync runs in background to update backend

### Restore Purchases UX

Note: Story 5.1-FE AC6 defines the basic "Restore Purchases" button placement (Settings and paywall). This story adds the detailed UX feedback and backend sync that 5.1 does not cover.

5. **AC5:** "Restore Purchases" provides clear feedback:
   - Loading indicator while restore is in progress
   - Success: "Subscription restored! Premium features activated."
   - No subscription found: "No previous subscription found for this Apple ID / Google account."
   - Error: "Could not restore purchases. Check your connection and try again."

6. **AC6:** After successful restore, UI immediately reflects premium:
   - Ads hidden (banners removed, interstitials suppressed)
   - Usage counter hidden or shows "Unlimited"
   - Settings shows "Manage Subscription" instead of "Upgrade to Premium"

### RevenueCat App User ID Management

7. **AC7:** Use device_uuid as RevenueCat app user ID:
   - On RevenueCat SDK initialization, set the anonymous app user ID to the device's UUID
   - This ensures the backend can map TRANSFER events back to the correct User record
   - Do NOT use RevenueCat's auto-generated `$RCAnonymousID` -- use the device_uuid for backend traceability

### Error Handling

8. **AC8:** Sync endpoint errors do not degrade user experience:
   - If sync returns 429 (rate limited): silently retry on next app launch
   - If sync returns 5xx: silently retry on next app launch
   - If sync returns 4xx (validation error): log error, do not retry
   - User never sees sync errors -- RevenueCat SDK is the client-side source of truth

## Tasks / Subtasks

### Phase 1: Subscription Sync Service

- [ ] Task 1: Create sync API call (AC: #1, #2, #3)
  - [ ] Add `syncSubscription(String revenuecatAppUserId)` method to subscription repository interface in `lib/features/subscription/domain/repositories/subscription_repository.dart`
  - [ ] Implement in `lib/features/subscription/data/repositories/revenuecat_subscription_repository_impl.dart`
  - [ ] Call `POST /api/v1/users/{user_id}/subscription/sync` via Dio with only `revenuecat_app_user_id` in body (backend verifies status server-side)
  - [ ] Map response to existing `SubscriptionStatus` model

- [ ] Task 2: Add sync to subscription provider (AC: #1, #2, #3, #4)
  - [ ] Modify `lib/features/subscription/presentation/providers/subscription_provider.dart`
  - [ ] After `restorePurchases()` succeeds: call `syncSubscription()`
  - [ ] After `purchasePackage()` succeeds: call `syncSubscription()`
  - [ ] On app launch after entitlement check: compare with cached state, sync if changed
  - [ ] Store last-synced state in SharedPreferences via settings datasource

### Phase 2: RevenueCat User ID Configuration

- [ ] Task 3: Set device_uuid as RevenueCat app user ID (AC: #7)
  - [ ] Modify RevenueCat initialization in `lib/features/subscription/data/datasources/revenuecat_datasource.dart`
  - [ ] Call `Purchases.logIn(deviceUuid)` during SDK setup (identifies the device to RevenueCat with our UUID)
  - [ ] Handle the case where logIn returns a different customer info (means a merge/transfer happened)

### Phase 3: Restore Purchases UX

- [ ] Task 4: Enhance restore flow UI (AC: #5, #6)
  - [ ] Add loading state to restore button in paywall and settings
  - [ ] Show success/failure snackbar or dialog after restore
  - [ ] On success: trigger provider state update -> UI rebuilds to premium state
  - [ ] On "no purchases found": show informative message
  - [ ] On error: show retry option

### Phase 4: Error Handling

- [ ] Task 5: Implement sync error handling (AC: #8)
  - [ ] Wrap sync call in try-catch
  - [ ] On 429/5xx: set `needsSyncRetry` flag in SharedPreferences
  - [ ] On next app launch: check flag and retry sync
  - [ ] On 4xx: log error, clear retry flag
  - [ ] Never surface sync errors to UI

### Phase 5: Testing

- [ ] Task 6: Unit tests
  - [ ] Test: Restore succeeds -> sync called with correct parameters
  - [ ] Test: Purchase succeeds -> sync called
  - [ ] Test: App launch with changed entitlement -> sync called
  - [ ] Test: App launch with same entitlement -> sync NOT called
  - [ ] Test: Sync fails -> retry flag set, UI unaffected
  - [ ] Test: Sync rate limited -> retry on next launch

- [ ] Task 7: Widget tests
  - [ ] Test: Restore button shows loading indicator
  - [ ] Test: Restore success -> premium UI displayed
  - [ ] Test: Restore "no purchases" -> appropriate message shown
  - [ ] Test: After restore, banners hidden, counter shows unlimited

## Dev Notes

### Sync Flow Diagram

```text
App Launch (any device)
    |
    v
Initialize RevenueCat SDK
    |-- Purchases.logIn(device_uuid)
    v
Check Entitlements
    |-- customerInfo.entitlements["premium"]
    v
Compare with cached state (SharedPreferences)
    |
    |-- Changed? --> Call sync endpoint (background, fire-and-forget)
    |                Update cached state
    |
    |-- Same? --> Skip sync
    v
Set subscription provider state
    |
    v
UI renders based on provider state
```

### Restore Purchases Flow

```text
User taps "Restore Purchases"
    |
    v
Show loading indicator
    |
    v
Purchases.restorePurchases()
    |
    |-- Success (has entitlement) -->
    |       1. Update provider state to premium
    |       2. Call sync endpoint (background)
    |       3. Show "Subscription restored!"
    |       4. Dismiss paywall / update Settings
    |
    |-- Success (no entitlement) -->
    |       Show "No previous subscription found"
    |
    |-- Error -->
            Show "Could not restore. Try again."
```

### Files Modified

```text
mobile/lib/features/subscription/
├── domain/
│   └── repositories/
│       └── subscription_repository.dart        # MODIFIED: Add syncSubscription()
├── data/
│   ├── repositories/
│   │   └── revenuecat_subscription_repository_impl.dart  # MODIFIED: Implement sync
│   └── datasources/
│       └── revenuecat_datasource.dart          # MODIFIED: logIn with device_uuid
└── presentation/
    └── providers/
        └── subscription_provider.dart          # MODIFIED: Sync after restore/purchase/launch
```

### Key Implementation Details

**RevenueCat logIn vs configure:**
- `Purchases.configure()` creates an anonymous user with `$RCAnonymousID`
- `Purchases.logIn(deviceUuid)` identifies the user with our device UUID
- Use `logIn` so that TRANSFER webhook events contain our device_uuid, making backend mapping straightforward

**SharedPreferences Keys:**

- `last_synced_entitlement_active` (bool) - was premium last time we synced?
- `subscription_needs_sync_retry` (bool) - did last sync fail?

**Dio Call for Sync:**

```dart
Future<SubscriptionStatus> syncSubscription({
  required String userId,
  required String revenuecatAppUserId,
}) async {
  final response = await dio.post(
    '/api/v1/users/$userId/subscription/sync',
    data: {
      'revenuecat_app_user_id': revenuecatAppUserId,
    },
  );
  return SubscriptionStatus.fromJson(response.data);
}
```

### References

- [Source: Story 5.1-FE] - Base subscription/ads implementation this extends
- [Source: Story 5.2-BE] - Backend sync endpoint this calls
- [Source: docs/architecture/frontend/state-management.md] - Riverpod patterns
- [Source: docs/architecture/frontend/api-integration.md] - Dio HTTP patterns
- [Source: docs/architecture/frontend/project-structure.md] - Feature folder structure
- [RevenueCat Flutter SDK - Identifying Users](https://www.revenuecat.com/docs/getting-started/identifying-users)

## Dev Agent Record

### Agent Model Used

(To be filled by dev agent)

### Debug Log References

(To be filled during implementation)

### Completion Notes List

(To be filled during implementation)

### File List

(To be filled during implementation)
