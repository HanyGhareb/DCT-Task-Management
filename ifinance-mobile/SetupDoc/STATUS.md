# i-Finance Mobile — Setup Status & Resume Point

_Last updated: 2026-06-19_

Use this to pick the work back up after Google/Apple verification clears.

## Where we are
- **App code:** complete MVP, `tsc` clean, Metro iOS bundle clean. No code work pending.
- **DB script:** `db/v2/28_push_tokens.sql` ✅ **DEPLOYED to PROD 2026-06-20** —
  all objects VALID, sweep job SCHEDULED, ORDS register/unregister live,
  **exp.host ACL granted**, smoke-tested (register/unregister → `{"ok":true}`).
- **EAS:** ✅ `eas init` + FCM V1 key + `google-services.json` all set.
- **Android:** ✅ preview build installed + **on-device smoke test PASSED incl. push** (2026-06-20).
- **Accounts:** Expo ✅ · Firebase ✅ · Apple Org ⏳ (iOS) · Play Console ⏳ (optional).
- **Next:** iOS build (needs Apple Org) · confirm DCT's MDM for prod distribution.

## Account status (fill in as you go)
| Account | Needed for | Status | Notes |
|---|---|---|---|
| Expo (personal OK) | builds + push | ☐ todo | instant; `eas login` |
| Firebase project | Android FCM push | ☐ todo | **instant, no verification** — just need the service-account JSON |
| Apple Developer (Org) | iOS production | ☐ waiting | D-U-N-S + Apple review (slow) |
| Apple Business Manager | iOS private distribution | ☐ later | after Apple Org approved |
| Google Play Console | Managed Google Play (optional) | ☐ waiting on Google verification | **prod-only & optional** — MDM can push the AAB directly instead |

## ✅ Can do NOW (not blocked by any verification)
1. **Firebase service-account JSON** — Firebase → Project Settings → Service
   accounts → Generate new private key. (Skip the "Add Firebase SDK"/Gradle step —
   see `00_accounts_setup.md` §3.) Store it in the password manager.
2. **Expo:** `npm i -g eas-cli` → `eas login` → from `ifinance-mobile/`: `eas init`
   (writes the real `projectId` into `app.json`).
3. **Deploy the DB script** (`SetupDoc/dev/01_backend_db_deploy.md`): run
   `28_push_tokens.sql` via SQLcl + grant the `exp.host` ACL.
4. **Android dev build + test** (full end-to-end, no Apple needed):
   - `eas credentials` → Android → FCM V1 → upload the service-account JSON.
   - `eas build --profile development --platform android` → install on a phone.
   - Run the `SetupDoc/dev/03_on_device_test.md` checklist (login, approvals,
     notifications, delegations, profile, **push**).

## ⏳ Waiting on verification (do when cleared)
- **iOS:** Apple Org enrollment → Apple Business Manager → `eas build … --platform ios`
  → Custom App in App Store Connect → assign via MDM (`SetupDoc/prod/02`).
- **Managed Google Play (optional):** only if not pushing the AAB directly via MDM.

## ▶️ Resume checklist (next session)
1. Did the **Firebase service-account JSON** get saved? If not, do "Can do NOW #1".
2. Is the **DB script deployed**? Verify objects VALID + `/dct/devices/register`
   returns `{"ok":true}` (`dev/01` Step 3–4).
3. Is the **Android dev build** installed and tested? If yes, push is proven.
4. Has **Apple Org** enrollment cleared? → start the iOS path (`prod/02`).
5. Confirm **which MDM** DCT uses (Intune / Jamf / other) to finalize the prod
   distribution steps.

## On-device smoke test — PASSED 2026-06-20 (real Android device)
Verified end-to-end on a physical phone: login, biometric, Approvals (list +
detail + comment-required), Notifications (mark-read), Delegations (view),
Profile, EN/AR + RTL, dark mode, and **push notification end-to-end** (DB
notification → trigger → outbox → Expo → device banner; token
`ExponentPushToken[Xf6p9…]` registered for ADMIN).

Findings found + FIXED (all now live in the build):
1. **Keyboard dropped each keystroke** on New Delegation — `Field` was defined
   inside the render; lifted to module scope in `NewDelegationScreen.tsx`.
2. **Profile photo didn't upload** — `/dct/users/:id/photo` PUT is legacy base64
   (~24 KB); added **`db/v2/29` binary endpoint `PUT /dct/users/:id/photobin`**
   (DEPLOYED + REST-tested), client repointed in `api/profile.ts`.
3. **Push token never registered** — Android needs **`google-services.json`** in
   the build (the part to skip is only the Gradle plugin, NOT the JSON). Added the
   file + `android.googleServicesFile` in `app.json` + FCM V1 key in EAS. Also made
   registration **self-healing** (retries on every authed launch, not just login).

EAS build gotcha (recurring): monorepo → must set `$env:EAS_NO_VCS=1` + the root
`.easignore` excludes siblings (otbi-atd lock caused EBUSY). Use **preview**
profile for on-device installs (development = dev-client, needs Metro/Expo login).

### Round-2 fixes (2026-06-20, need a rebuild)
4. **Delegations had no way to find a user** (raw numeric ID). Added a searchable
   **user picker** — `api/users.ts` (GET /dct/users/?search=) + a modal in
   `NewDelegationScreen.tsx` (tap "Delegate to" → search → pick).
5. **Profile photo "nothing happened" on select.** Now shows the picked image
   **immediately** (preview set before upload) + alerts on permission-denied /
   upload-failure instead of silently returning. tsc + Metro clean.

### Round-3 fix (2026-06-20, need a rebuild)
6. **Picked photo still didn't display** (picker opened + returned, no error, but
   avatar stayed on initials). Root cause: RN's built-in `<Image>` is unreliable
   rendering picker `file://`/`content://` URIs on Android. Switched the avatar to
   **`expo-image`** `<Image>` (`contentFit="cover"`, `cachePolicy="none"`), added a
   visible **"Change photo"** button (the camera badge was too small a target), and
   a **TEMP on-screen `picked: …` caption** to confirm the picker returns a URI into
   state. `expo install expo-image` added; tsc clean. **expo-image is a native
   module → requires a new preview build** to take effect. Once the photo is
   confirmed showing, remove the TEMP caption in `ProfileScreen.tsx`.

## Phase 2 — Submission foundation + offline queue + ATD slice (2026-06-20)
**CODE COMPLETE; needs a rebuild for the device test.** Plan: `MOBILE_PHASE2_PLAN.md`.
- **Layer 1 — multi-module client.** `config.moduleBase(mod)` + `api.for(mod)`
  (same host/Bearer, different `/ords/admin/<mod>` segment). Live-verified `/dct`
  login → `GET /atd/dashboard`.
- **Layer 2 — offline write-queue.** `services/connectivity.ts` (NetInfo),
  `state/writeQueue.ts` (persisted FIFO + smart retry: network/401 → hold, 4xx →
  failed, 5xx → capped; flush on reconnect/foreground/30 s), `hooks/useQueuedMutation.ts`
  (`requireOnline` policy: forms queue, triggers fail-fast offline), `OfflineBanner`,
  `OutboxScreen` (retry/discard, Profile entry + badge). Hydrated on launch.
- **Layer 3 — Analytics Loader (App 208) slice.** `api/atd.ts`, `useHasRole`
  **SYS_ADMIN** gate, `screens/atd/` Dashboard (KPIs/alerts/recent) · Jobs
  (enqueue/reset, header enqueue-all/reap) · Runs (paged) · RunDetail; role-gated
  5th **Analytics** tab; EN+AR i18n.
- Quality: **tsc clean** + **Metro android bundle clean** (3.18 MB). `app.json`
  1.0.0 → **1.1.0**. New deps: `expo-image`, `@react-native-community/netinfo`
  (native → rebuild required).
- **Next:** `$env:EAS_NO_VCS=1; eas build --profile preview --platform android`,
  install, test with an ATD-admin login (ADMIN has SYS_ADMIN). Also picks up the
  round-3 photo fix (expo-image) + the delegation user-picker.

## Open decisions / unknowns
- **MDM platform** — not yet confirmed (needed for the exact prod upload steps).
- **DB deploy** — pending the user running it (the assistant's run was blocked by
  the safety classifier as a prod migration).
- Apple **Individual (dev now) → Organization (before prod)** — see `00_accounts §2`.
