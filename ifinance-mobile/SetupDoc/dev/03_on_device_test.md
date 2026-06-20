# dev/03 — On-device smoke test

Run on **one iPhone + one Android phone** with a valid i-Finance test user that
has pending approvals. Requires dev/01 (DB) and dev/02 (build) done.

## A. Auth & session
- [ ] Launch → login screen renders (title from `/dct/branding`).
- [ ] Sign in with a real user → lands on the Approvals tab.
- [ ] Kill the app and reopen → **biometric prompt** (Face ID / fingerprint) → unlock shows data.
- [ ] Settings → revoke the session (or wait out the timeout) → next API call returns to login (401 path).

## B. Approvals (the core)
- [ ] Approvals list matches `GET /dct/approvals/pending` (same items/amounts), grouped by module color.
- [ ] Open an item → all fields show; "acting for" badge appears for delegated items.
- [ ] Try to approve with an empty comment → blocked + "comment required".
- [ ] Approve with a comment → haptic + success → item disappears → **confirm it reflects in the web inbox** and status history.
- [ ] Repeat for Reject and Return.

## C. Notifications
- [ ] List matches `GET /dct/notifications/`; unread show a dot + tab badge.
- [ ] Tap an unread → marks read → badge count drops.

## D. Delegations
- [ ] List shows my delegations.
- [ ] Create one (delegate user ID + date range) → appears as ACTIVE.
- [ ] Cancel it → status flips to CANCELLED.

## E. Profile
- [ ] Name/email/org/roles correct.
- [ ] Change photo (camera/library) → uploads (raw binary) → persists after reopen.
- [ ] Toggle EN ⇄ AR → strings localize; AR flips layout to RTL; digits stay Latin.
- [ ] Sign out → returns to login; device token unregistered.

## F. Push (the differentiator)
1. On the device, confirm the app registered a token:
   ```sql
   SELECT platform, is_active, last_seen_at FROM prod.dct_device_tokens ORDER BY created_at DESC FETCH FIRST 5 ROWS ONLY;
   ```
2. Trigger a notification to that user (submit a request that routes to them, or
   insert a test `DCT_NOTIFICATIONS` row for `recipient_user_id`).
3. Within ~1 min (sweep interval): device shows a push.
   - [ ] Push arrives with the app backgrounded.
   - [ ] Tapping it deep-links into the Approvals tab.
4. If nothing arrives, check the outbox:
   ```sql
   SELECT status, attempts, error_msg, sent_at FROM prod.dct_push_outbox ORDER BY created_at DESC FETCH FIRST 10 ROWS ONLY;
   ```
   - `PENDING` stuck → sweep job not running or ACL missing (dev/01 Step 2).
   - `FAILED` with an HTTP error → ACL/host issue.
   - `SENT` but no device banner → bad/expired Expo token, or notifications
     permission denied on the device.

## Light/dark & a11y spot-check
- [ ] Switch the OS to dark mode → contrast holds in both themes.
- [ ] Largest Dynamic Type / font size → no clipped labels.

## Done when
- Sections A–F all pass on both platforms. Capture a screenshot per area for the
  record (mirrors the platform UAT evidence convention).
- Ready for **prod/**.
