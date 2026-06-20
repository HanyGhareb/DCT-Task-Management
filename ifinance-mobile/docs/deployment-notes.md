# i-Finance Mobile — Deployment Notes

App: **ifinance-mobile** (App 209). Stack: React Native + Expo (managed),
TypeScript. Consumes the shared Admin `/dct/` ORDS module. See Admin
`final apps/Admin/docs/deployment-notes.md` for the canonical platform-wide
SQLcl/ORDS rules.

## Deploy checklist

### Backend (once / when push changes)
1. Run **`db/v2/28_push_tokens.sql`** in a **fresh** SQLcl session
   (`sql -name prod_mcp`) — must NOT follow `ALTER SESSION SET CURRENT_SCHEMA=PROD`
   (the ADMIN synonyms would self-reference → ORA-01471). The script is
   idempotent and creates:
   - `PROD.DCT_DEVICE_TOKENS` (device push tokens, unique by `push_token`),
   - `PROD.DCT_PUSH_OUTBOX` (queued pushes),
   - `TRG_DCT_NOTIF_PUSH` (fans each new `DCT_NOTIFICATIONS` row to the
     recipient's active devices — leaves `DCT_NOTIFY` untouched),
   - `PROD.DCT_PUSH_PKG` (`register` / `unregister` / `send_pending`),
   - `PROD.DCT_PUSH_SWEEP` scheduler job (drains the outbox every minute),
   - ADMIN→PROD synonyms + ORDS handlers `POST /dct/devices/register` and
     `DELETE /dct/devices/:token` on the existing `dct.admin` module (additive,
     no module re-define).
2. **One-time network ACL** (section 8 of the script, commented): grant `http`
   to PROD for host `exp.host` so the sweep job can reach Expo Push. Without it,
   outbox rows go to `FAILED` after 5 attempts.
3. Smoke test:
   ```
   curl -X POST .../ords/admin/dct/devices/register \
     -H "Authorization: Bearer <sessionId>" -H "Content-Type: application/json" \
     -d '{"token":"ExponentPushToken[xxx]","platform":"IOS","appVersion":"1.0.0"}'
   ```
   Expect `{"ok":true}` and a row in `DCT_DEVICE_TOKENS`.

### Mobile app
1. `cd ifinance-mobile && npm install`.
2. `eas init` → put the real `projectId` in `app.json` → `extra.eas.projectId`.
3. For FCM (Android) + APNs (iOS) credentials, configure them in EAS
   (`eas credentials`); Expo Push routes through them.
4. Build: `npm run build:dev` (internal) or `npm run build:prod`.
5. Bump `expo.version` in `app.json` on every store release.

## Phase 2 — multi-module submission + offline write-queue (no DB change)
Phase 2 adds the ability to *submit* from the phone, foundation-first (plan:
`MOBILE_PHASE2_PLAN.md`). **No backend/DB change** — it consumes existing ORDS
modules via the shared session.
- **Multi-module client:** `config.moduleBase(mod)` derives `…/ords/admin/<mod>`
  from `apiBase`; `api.for('atd')` rebinds the verb helpers to it (same Bearer
  token, 401-handling). Any `/ords/admin/*` module is now reachable.
- **Offline write-queue:** queued form submissions persist (AsyncStorage
  `ifinance_write_queue`) and auto-retry on reconnect (NetInfo) / foreground / 30 s.
  Triggers (e.g. ATD job enqueue) use `requireOnline:true` and **fail fast offline**
  instead of queuing. Reviewed in the **Outbox** screen (Profile → Outbox).
- **First module slice = Analytics Loader (App 208) — FULL admin (v1.2.0).**
  Role-gated **Analytics** tab (SYS_ADMIN only — every `/atd/` handler enforces
  `dct_auth.has_role(…, 'SYS_ADMIN')`) with a **Manage** menu to: Dashboard, **Jobs**
  (enqueue/reset/enable/disable/re-map/rebuild/delete), **Queue** (counts + reap),
  **Runs** (+detail), **Discovery** (subject areas + (re)discover + history),
  **Environments** (CRUD), **Targets** (CRUD), **Runner Settings** (`/config`
  editor). Job/env/target writes use the partial-safe PUT (`does_exist` per column);
  Runner Settings PUTs only changed keys so write-only secrets are preserved.
- New native deps → **require a rebuild**: `expo-image`, `@react-native-community/netinfo`.
- **ATD UX notes:** Android `Alert` shows max 3 buttons → multi-action menus use a
  custom bottom-sheet / full-screen modal, not `Alert`. Enqueue ≠ run: it sets the
  job READY in the queue; a **run-history** row appears only after the runner
  (Windows Scheduled Task `OTBI-ATD Loader`, ~15-min poll) claims and executes it.

## Gotchas learned
- `expo install react-native @shopify/flash-list` pruned `expo-asset` /
  `expo-font` (needed by `@expo/vector-icons` and Metro). If `expo export` errors
  with "cannot be found", run `npx expo install expo-asset expo-font`.
- `expo-image-picker@16` deprecated `MediaTypeOptions`; use `mediaTypes: ['images']`.
- `expo-notifications` `setNotificationHandler` requires `shouldShowAlert` on this
  SDK (not only `shouldShowBanner`/`shouldShowList`).
- React Query `onError` types the error as `Error`; our `ApiError` cast goes
  through `unknown` (`e as unknown as ApiError`).
- `babel-preset-expo` resolves the `@/*` tsconfig path alias natively — do NOT add
  `babel-plugin-module-resolver` (it isn't installed and will fail the bundle).

## Deployment history
- 2026-06-19 — Initial MVP scaffolded. tsc clean; Metro iOS bundle clean
  (3.08 MB). `db/v2/28_push_tokens.sql` authored (CRLF/UTF-8).
- 2026-06-20 — **`db/v2/28_push_tokens.sql` DEPLOYED to PROD.** All objects VALID
  (DCT_DEVICE_TOKENS, DCT_PUSH_OUTBOX, DCT_PUSH_PKG, TRG_DCT_NOTIF_PUSH),
  DCT_PUSH_SWEEP job SCHEDULED, ORDS `POST /dct/devices/register` +
  `DELETE /dct/devices/:token` live, **exp.host network ACL granted** (PROD).
  Smoke-tested end-to-end (login → register `{"ok":true}` → unregister
  `{"ok":true}`); smoke row cleaned. **EAS:** `eas init` done — real projectId
  `f5421129-…` + owner `hanyghareb` in app.json; `RECORD_AUDIO` blocked
  (image-picker `microphonePermission:false` + `blockedPermissions`).
  Fix during deploy: `SQLERRM` can't be referenced inside a SQL `UPDATE` (ORA-00904)
  — captured into a local `l_err` var first. **Pending:** Android dev build +
  on-device test; iOS (waits on Apple Org).
- 2026-06-20 — Android **preview** build installed on device; smoke test found +
  fixed 2 issues: (1) New-Delegation keyboard dropped each keystroke (inner
  `Field` component → lifted to module scope); (2) profile photo upload — the
  legacy `/users/:id/photo` PUT is base64-only (~24 KB), so added
  **`db/v2/29_user_photo_binary.sql`** = `PUT /dct/users/:id/photobin` (raw `:body`
  BLOB, MAX_UPLOAD_MB guard) and repointed `api/profile.ts`. **DEPLOYED + REST-
  tested** (upload `{"ok":true}`, GET photo 200). Gotcha: deref `:body` as the
  FIRST statement in BEGIN (not in DECLARE) or the bind error escapes the handler
  → HTTP 555. Both app fixes ship in the next preview rebuild.
- 2026-06-20 — **On-device smoke test PASSED incl. push (real Android).** Final
  push blocker: Android needs **`google-services.json`** embedded in the build to
  mint a token — the part to skip in the Firebase wizard is only the Gradle plugin,
  NOT the JSON file. Added `ifinance-mobile/google-services.json` +
  `android.googleServicesFile` in app.json (FCM V1 service-account key was already
  in EAS). Token registered (`ExponentPushToken[Xf6p9…]`); test notification →
  trigger → outbox → Expo → device banner confirmed; outbox `SENT`. Push
  registration is now self-healing (retries on every authed launch). Test data
  cleaned (notification, outbox, ADMIN 1px test photo). **Still pending:** iOS
  (Apple Org) + MDM choice for prod.
- 2026-06-20 — **Round-3 profile-photo fix** (picked image didn't render): switched
  the avatar to **`expo-image`** (RN `<Image>` is unreliable with picker `file://`
  URIs on Android), added a visible "Change photo" button + a temp `picked:` debug
  caption. `expo install expo-image`. Needs a rebuild; remove the temp caption once
  confirmed.
- 2026-06-20 — **Phase 2 CODE COMPLETE (app 1.0.0 → 1.1.0).** Multi-module client +
  offline write-queue + ATD (App 208) slice (role-gated Analytics tab). No DB change.
  tsc clean + Metro android bundle clean (3.18 MB). ATD **reads** live-verified vs
  PROD; **writes** (enqueue/reset/reap) deferred to the on-device test (they trigger
  real loads). **Pending:** one preview rebuild (`$env:EAS_NO_VCS=1; eas build
  --profile preview --platform android`) then the Phase 2 on-device test.
- 2026-06-20 — **Phase 2.1: FULL ATD admin (app 1.1.0 → 1.2.0).** Brought the
  Analytics slice to web-parity: full Jobs management (enable/disable/re-map/rebuild/
  delete) + new Environments/Targets CRUD, Runner Settings (`/config`) editor, Queue,
  Discovery screens + a dashboard Manage menu. Reusable `components/form.tsx`. No DB
  change (all endpoints already existed; shapes verified live). tsc + Metro-android
  (3.24 MB) clean. **Pending:** the same single preview rebuild + on-device test.
