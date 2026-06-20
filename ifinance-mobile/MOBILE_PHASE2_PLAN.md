# i-Finance Mobile — Phase 2 Plan: Submission Foundation + Offline Write-Queue + TM slice

_Status: PROPOSED — awaiting approval. Date: 2026-06-20._

Phase 1 (MVP) shipped read + approve flows (approvals / notifications / delegations /
profile / biometric / push). **Phase 2 adds the ability to _submit_ from the phone.**
Per the build rule (CLAUDE.md §0), this is delivered **layer-by-layer**, foundation
first, proven on **one module** before the rest.

## Decisions locked (from the user)
- **Start with the shared submission foundation + ONE module slice**, then replicate.
- **Build the offline write-queue NOW** as part of the foundation (every later
  module gets offline submit for free).
- First module slice = **Analytics Loader (App 208 / OTBI→ATD)** — an admin/ops
  control plane. Mobile value = glance at the dashboard (queue counts + FAILED/
  WARNING alerts) and **trigger a load** (`POST /atd/jobs/:name/enqueue`) while
  away, then watch the run. (TM was the original candidate but is being revised, so
  it moves to the follow-up list.)
- Two ATD-specific design points the foundation must support:
  - **Role-gating** — App 208 is for ATD admins, not all employees. The Analytics
    tab/screens render only when the session carries the ATD admin role (exact role
    code confirmed in Layer 3). Regular users never see it.
  - **`requireOnline` writes** — triggering a load should NOT silently queue while
    offline (you don't want a stale load firing later). The submission layer takes a
    per-action `requireOnline` flag: ATD triggers fail-fast with an "offline" message;
    finance forms (later modules) still queue. Same layer, two policies.

## Layer 1 — Multi-module API access (no new screens)
Today `config.apiBase` = `…/ords/admin/dct`. TM is `…/ords/admin/tm`. Same host,
different last segment.
- **`src/config.ts`** — derive `ordsRoot` = apiBase with the last segment stripped
  (`…/ords/admin`); export `moduleBase(mod)` = `${ordsRoot}/${mod}`.
- **`src/api/client.ts`** — add an optional `{ base }` to the call options so a
  request can target another module base; add `api.for(mod)` returning
  `{ get, post, put, delete, putBinary }` bound to that module's base. The Bearer
  token, 401-handling and error-normalization stay identical (the session is shared
  across all `/ords/admin/*` modules).
- _Verify:_ a throwaway `api.for('tm').get('/my-tasks')` returns the signed-in
  user's tasks (tsc + a live call through the dev proxy / device).

## Layer 2 — Offline write-queue (the foundation)
- **`src/state/writeQueue.ts`** — a persisted FIFO queue (AsyncStorage key
  `ifinance_write_queue`). Each item:
  `{ id, module, path, method, body, label, createdAt, status: 'pending'|'failed', attempts, error }`.
  - `enqueue(item)` → persist + attempt immediate `flush()`.
  - `flush()` → process oldest-first; **success** → remove + invalidate the item's
    `invalidateKeys`; **network error (status 0)** → leave `pending`, stop (retry
    later); **4xx (validation/business, e.g. -20001/-20090)** → mark `failed` (do NOT
    auto-retry; the user must fix/discard); **5xx** → keep pending, capped attempts.
  - Triggers: on `enqueue`, on app foreground (AppState), on reconnect (NetInfo),
    and a light 30 s interval while items remain.
  - Exposed as a **Zustand store** (`useWriteQueue`) so the UI can show a
    pending/failed count and a "Outbox" review.
- **`src/services/connectivity.ts`** — wrap `@react-native-community/netinfo`
  (Expo-supported); expose `isOnline` + subscribe; drive the existing
  `offline.banner` string and the queue flush-on-reconnect.
- **`src/hooks/useQueuedMutation.ts`** — thin wrapper over a normal call. With
  `requireOnline: false` (default for forms): when offline it routes the write
  through `enqueue` and returns an optimistic result; when online it calls directly
  and only records to the queue on network failure. With `requireOnline: true` (ATD
  triggers): it never queues — offline → reject immediately with the `offline.banner`
  message so the user knows the action did NOT fire. Keeps screens simple.
- **`src/screens/OutboxScreen.tsx`** — list pending/failed submissions with
  retry/discard; surfaced from Profile (and a small header badge). Gives offline
  submits a visible, trustworthy home (ui-ux-pro-max: offline-support, error-recovery).
- _Verify:_ airplane-mode a submit → it queues, banner shows, Outbox lists it;
  re-enable network → it flushes and the list refreshes. A forced 400 → item shows
  `failed` with the server message + Discard.

## Layer 3 — Analytics Loader (App 208 / ATD) slice (proves the foundation)
All under `api.for('atd')` (`…/ords/admin/atd`).
- **`src/api/atd.ts`** — reads: `getDashboard()` (`GET /dashboard` — KPIs, queue
  counts, recent runs, alerts), `getJobs()` (`GET /jobs` — prepared flag +
  `lastDurationSec`), `getRuns(page)` (`GET /runs` paged — status/`warn`/`message`/
  `durationSec`), `getRun(id)` (`GET /runs/:id`). Writes (via the submission layer,
  **`requireOnline: true`**): `enqueueJob(name)` (`POST /jobs/:name/enqueue`),
  `resetJob(name)` (`POST /jobs/:name/reset`), `enqueueAll()` (`POST /enqueue`),
  `reapStale()` (`POST /reap`).
- **Role-gate** — every ATD ORDS handler enforces `dct_auth.has_role(user,
  'SYS_ADMIN')` (verified in `otbi-atd/db/13_atd_ords.sql`). Expose a session helper
  `hasRole('SYS_ADMIN')` (read from `rolesCsv`); the Analytics tab + screens mount
  only when true. No DB change needed.
- **`src/screens/atd/AtdDashboardScreen.tsx`** — landing: KPI cards (queued /
  running / failed today), an **alerts** list (FAILED + WARNING, each tappable to
  the run), and a "recent runs" strip. Pull-to-refresh; light auto-poll while
  focused (reuse `notifPollMs`).
- **`src/screens/atd/AtdJobsScreen.tsx`** — FlashList of jobs (name, prepared badge,
  last duration). Tap a job → action sheet: **Enqueue run** (the queued/triggered
  submission, with an inline "running…" optimistic state), **Reset**. A header
  "Enqueue all" / "Reap stale" overflow.
- **`src/screens/atd/AtdRunsScreen.tsx`** + **`AtdRunDetailScreen.tsx`** — run-log
  list (status pill, duration, warn dot + message snippet) → detail (full message,
  timing, target).
- **Navigation** — one **role-gated 5th bottom tab "Analytics"** → an ATD native
  stack whose landing is `AtdDashboardScreen`, with Jobs / Runs reachable from it
  (segmented control or header links) and Run-detail pushed. Outbox stays a stack
  route off Profile. (Bottom nav stays ≤5; non-ATD users see 4 tabs.)
- **i18n** — add `tab.analytics`, `atd.*`, `outbox.*`, `queue.*` keys in **both**
  `en` and `ar` (a missing key renders raw). Latin digits for all counts/durations.
- _Verify:_ on-device with an ATD-admin session — dashboard shows live queue/alert
  data; **enqueue a job** → it fires and the run appears in `/runs` (and in the ATD
  web app); offline → enqueue fails fast with the offline message (does NOT queue);
  a non-ATD session shows no Analytics tab.

## Out of scope this round (the remaining Phase 2 modules)
TM task updates (being revised), PC requests, DT settlements + camera receipts, CC
replenishments, FL registration, AR P&L. Each becomes a follow-up slice reusing
Layers 1–2 unchanged (an `api.for('<mod>')` module + a screen or two). DT's receipt
capture will reuse the existing binary-upload path (`putBinary`) already proven by
profile photos; finance forms use the **queued** (`requireOnline: false`) policy.

## New dependencies
- `@react-native-community/netinfo` (Expo-supported, native module → needs a rebuild).
- (No others; AsyncStorage, Zustand, TanStack Query, FlashList already present.)

## Testing
- `tsc --noEmit` clean + Metro bundle clean after each layer.
- Queue unit behavior exercised via the Outbox (enqueue/flush/fail/retry/discard).
- On-device: online submit (verify in TM web), offline submit → reconnect flush,
  forced-400 failure path.
- Update `docs/deployment-notes.md`, `STATUS.md`, this plan's status, and the memory
  project entry when the slice lands. Bump `APP_VERSION` for the rebuild.

## Verified ATD payload shapes (live PROD, 2026-06-20 — bind to these)
Login user `ADMIN` returned `rolesCsv=PLATFORM_USER,SYS_ADMIN` (sees Analytics tab).
- `GET /atd/dashboard` → `{ queue:{ready,claimed,done,failed}, jobs:int,
  enabledJobs:int, runs24h:int, success24h:int, successRate:int(%),
  lastFinished:"YYYY-MM-DD HH:MM",
  recent:[{runId,jobName,status,rowCount,started,finished}](≤10),
  alerts:[{runId,jobName,status,kind:'WARNING'|'FAILED',message,started}](≤10) }`
- `GET /atd/jobs` → `{ items:[{jobName,envName,targetName,sourceRef,stageTable,
  loadMode,priority,runOrder,enabled:'Y'|'N',prepared:'Y'|'N',runStatus,lastRunId,
  lastRunStatus,lastFinished,lastDurationSec}] }`
- `GET /atd/runs?limit=&offset=` → `{ items:[{runId,jobName,track,status,rowCount,
  warn:'Y'|'N',started,finished,durationSec}] }` (paged)
- Writes (requireOnline): `POST /atd/jobs/:name/enqueue`, `/atd/jobs/:name/reset`,
  `/atd/enqueue`, `/atd/reap`.

## Build status — Layers 1–3 ✅ CODE COMPLETE (2026-06-20)
- **Layer 1** — `config.moduleBase` + `api.for(mod)`; **live-verified** `/dct` login
  → `Bearer` → `GET /atd/dashboard` (multi-module routing + shared session, PROD).
- **Layer 2** — `services/connectivity.ts` (NetInfo + `isOnline()` + offline store),
  `state/writeQueue.ts` (persisted FIFO, smart retry, reconnect/foreground/interval
  flush, queryClient invalidation), `hooks/useQueuedMutation.ts` (queue vs
  `requireOnline` fail-fast), `components/OfflineBanner.tsx`, `screens/OutboxScreen.tsx`
  (+ Profile entry with queued badge). Queue hydrated on launch in `App.tsx`.
- **Layer 3** — `api/atd.ts` (typed reads, shapes verified live), `useHasRole`
  SYS_ADMIN gate, `screens/atd/` Dashboard/Jobs/Runs/RunDetail, role-gated 5th
  **Analytics** tab + ATD stack routes, full `atd.*`/`outbox.*`/`queue.*` EN+AR i18n.
- Verification: **tsc clean** + **Metro android bundle clean** (3.18 MB hbc) after all
  layers. Reads live-verified vs PROD; ATD **write** endpoints (enqueue/reset/reap)
  deliberately NOT fired against PROD (they trigger real loads) — proven on-device.
- `app.json` version bumped **1.0.0 → 1.1.0**.

### Phase 2.1 — FULL ATD admin (web-parity) ✅ CODE COMPLETE (2026-06-20, v1.2.0)
Per user request ("all functions available… runner settings"), the ATD slice was
extended to mirror the web app — **no DB change** (every endpoint already existed):
- **Jobs:** enqueue / reset / **enable / disable** / re-map / rebuild / delete (bottom-
  sheet; Android Alert caps at 3 buttons). **Environments** + **Targets**: full CRUD.
- **Runner Settings** (`/config`): typed editor (STRING/NUMBER/ENUM/BOOL/secret); PUTs
  only changed keys so write-only secrets (`secretSet`) are preserved.
- **Queue** (counts + READY/CLAIMED + reap) · **Discovery** (subject areas + (re)discover
  + history; deep column-picker/AI-builder remains web). **Dashboard Manage menu** to all.
- Reusable `components/form.tsx`. Partial-PUT safety confirmed (`does_exist` per column).
  tsc + Metro-android (3.24 MB) clean. Same single preview rebuild still pending.

### Pending (Layer 4)
On-device test with an ATD-admin session via a new **preview** build
(`$env:EAS_NO_VCS=1; eas build --profile preview --platform android`): dashboard
data, enqueue a job → run appears in `/runs`; offline → enqueue fails fast; offline
form-style queue/flush via the Outbox; non-admin session shows no Analytics tab.

## Deliverable order (each verified before the next)
1. Layer 1 (multi-module client) → tsc + a live `api.for('atd').get('/dashboard')` call.
2. Layer 2 (write-queue + connectivity + Outbox) → offline/queue/flush proven; the
   `requireOnline` fail-fast path proven.
3. Layer 3 (ATD api + role-gate + dashboard/jobs/runs screens + Analytics tab + i18n)
   → on-device end-to-end with an ATD-admin session.
4. Docs + APP_VERSION bump → one rebuild for the device test (netinfo + new screens).
