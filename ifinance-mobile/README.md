# i-Finance Mobile (App 209 — `ifinance-mobile`)

Cross-platform (iOS + Android) native client for the **i-Finance** platform,
built with **React Native + Expo (TypeScript)**. It is a thin native client over
the existing Oracle ADB / ORDS REST APIs — no new module logic. MVP scope is the
**on-the-go core**: unified approvals, notifications, delegations, and profile.

> Planning + rationale (skill-driven): `C:\Users\hanyg\.claude\plans\mobile-app-planning-i-compiled-treasure.md`

---

## What it does (MVP)

| Area | Screen | Endpoints (shared `/dct/` module) |
|---|---|---|
| Sign in | `LoginScreen` + biometric `LockScreen` | `POST /dct/auth/login`, `POST /dct/auth/logout` |
| Approvals (PC/DT/FL/CC/AR) | `ApprovalsScreen` → `ApprovalDetailScreen` | `GET /dct/approvals/pending`, `POST /dct/approvals/:id/action` |
| Notifications | `NotificationsScreen` | `GET /dct/notifications/`, `GET /dct/notifications/count`, `PUT /dct/notifications/:id/read` |
| Delegations | `DelegationsScreen` → `NewDelegationScreen` | `GET /dct/delegations/?mine=Y`, `POST /dct/delegations/`, `POST /dct/delegations/:id/cancel` |
| Profile + photo | `ProfileScreen` | `GET/PUT /dct/users/:id`, `PUT /dct/users/:id/photo` (raw binary) |
| Push registration | `services/push.ts` + `state/session.ts` | `POST /dct/devices/register`, `DELETE /dct/devices/:token` (db/v2/28) |

Features: EN/AR + RTL, light/dark themes, brand color from `GET /dct/boot`,
biometric unlock, FlashList virtualized lists, offline read cache (TanStack
Query persistence), real push (Expo Push → FCM/APNs).

---

## Architecture

```
src/
  config.ts                 runtime config (apiBase from app.json extra)
  api/
    client.ts               TS port of shared/js/api.js (Bearer, 401, putBinary)
    types.ts                typed ORDS shapes (match APEX_JSON keys exactly)
    auth | approvals | notifications | delegations | profile | devices
  state/
    session.ts              Zustand store (session, token wiring, 401 expiry)
    queryClient.ts          TanStack Query + AsyncStorage persistence (offline read)
  services/
    secureStore.ts          session in Keychain/Keystore (expo-secure-store)
    biometric.ts            Face ID / fingerprint (expo-local-authentication)
    push.ts                 Expo push token + deep-link payload extraction
  theme/                    tokens (mirrors platform.css) + ThemeProvider (light/dark/brand)
  i18n/                     strings (EN/AR, ported from common.*.json) + I18nProvider (RTL)
  components/               ui.tsx kit (Button/Card/Badge/EmptyState/Skeleton) + ScreenHeader
  navigation/               bottom tabs (≤5) + native stack + push deep-linking
  screens/                  Login, Lock, Approvals(+Detail), Notifications, Delegations(+New), Profile
App.tsx                     providers + session restore + biometric gate + push routing
```

State: **Zustand** (atomic session/UI) + **TanStack Query** (server cache,
offline-read via `persistQueryClient`). Lists use **FlashList**. Session token is
stored only in the OS keystore — never AsyncStorage.

---

## Run locally

```bash
cd ifinance-mobile
npm install
npx expo start        # press i (iOS) / a (Android), or scan with a dev build
```

- `apiBase` defaults to the production ADB ORDS `/ords/admin/dct` (see `app.json` → `extra.apiBase`).
- **Push, biometrics and secure-store need a real device + an EAS dev build** (not Expo Go):
  ```bash
  npm run build:dev      # eas build --profile development
  ```
- Set a real `extra.eas.projectId` in `app.json` before building (run `eas init`).

## Checks

```bash
npm run typecheck                       # tsc --noEmit  (clean)
npx expo export --platform ios          # Metro bundle sanity (clean)
npx expo-doctor                         # dependency/version validation
```

---

## Backend dependency

Push requires **`db/v2/28_push_tokens.sql`** deployed (device-token table +
push outbox + `/dct/devices` ORDS handlers + a once-a-minute sweep job to Expo
Push). See that script's header and `docs/deployment-notes.md`. A one-time
network ACL for `exp.host` must be granted for the sweep job to deliver.

## Phase 2 — submission foundation (in progress)

The submission foundation is **built** (see `MOBILE_PHASE2_PLAN.md`):
- **Multi-module client** — `api.for(mod)` reaches any `/ords/admin/<mod>` module
  on the shared session.
- **Offline write-queue** — form submissions queue while offline and auto-retry on
  reconnect; triggers use `requireOnline` and fail fast. Reviewed in the **Outbox**.
- **First slice = Analytics Loader (App 208)** — a role-gated (SYS_ADMIN) Analytics
  tab: dashboard (KPIs/alerts), jobs (enqueue/reset), run history + detail.

**Remaining Phase 2 modules** (each reuses the foundation): PC requests, DT
settlements + camera receipts, CC replenishments, FL registration, AR P&L, TM task
updates. All map to already-documented per-module endpoints.
