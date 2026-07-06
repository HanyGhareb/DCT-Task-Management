# AR (App 206) — Functions List

> **Purpose:** Complete grouped inventory of every user-facing function the AR
> (Event P&L / AR) JET SPA exposes, organised by functional area.
>
> **⚠️ KEEP THIS UPDATED.** Whenever you add, remove, or rename a view, viewModel
> method, or service in `final apps/AR/Jet/`, update this file in the **same change**.
> Each functional area maps to a view; bullets are public `self.<method>` on its
> viewModel. See the repo-wide rule in the root `CLAUDE.md` → "Functions List".

Module: **AR / Event P&L (AI)** · ORDS base: `/ords/admin/<ar path>`

---

## 1. Authentication & Shell
Auth + shell are shared (`shared/` layer). The app boots into the dashboard.

## 2. Dashboard
**Dashboard** (`dashboard`) — landing KPIs.
- `openEvents`.

## 3. Events & P&L

**Events** (`events`) — event list.
- `reload` · `newEvent` / `openDetail` · `fmt` / `statusClass`.

**Event Form** (`eventForm`) — create/edit an event.
- `save` · `cancel`.

**Event Detail** (`eventDetail`) — full event P&L workspace (tabs: lines, files, findings, KPIs).
- Navigation/tabs: `setTab` · `reloadAll` / `reloadPnl` · `editEvent` · `dispose`.
- AI + sources: `runAi` (AI P&L extraction) · `viewSource` · `openUpload` · `openReport` · `openWhatIf`.
- Files: `confirmFileCat` / `confirmAllDrafts` / `deleteFileRow` / `downloadFile` / `retryFile`.
- Lines & status: `saveLineCategory` / `deleteLine` / `toggleIncluded` · `setLineStatus` / `setKpiStatus` / `setFindingStatus`.
- Formatting: `fmt` / `chipClass` / `confClass` / `statusClass`.

## 4. Upload Wizard
**Upload Wizard** (`uploadWizard`) — bulk document ingestion for AI extraction.
- `pickFolder` · `startUpload` · `reset` · `backToEvent`.

## 5. What-If Scenarios
**What-If** (`whatIf`) — scenario modelling on event P&L.
- `addAdjustment` / `removeAdjustment` · `saveScenario` / `loadScenario` / `deleteScenario` · `fmt`.

## 6. Reports
**Reports** (`reports`) — P&L reporting + export.
- `exportCsv` · `print` · `fmt`.

## 7. Configuration

**P&L Categories** (`pnlCategories`) — P&L line category master.
- `newCat` / `editCat` / `save` / `cancelEdit` · `toggleActive` · `reload`.

**Document Categories** (`docCategories`) — document classification master.
- `newCat` / `editCat` / `save` / `cancelEdit` · `toggleActive` · `flagsText` · `reload`.

**Settings** (`settings`) — module settings + AI providers + region appearance.
- `saveRegion` · AI providers: `openProviders` / `closeProviders` / `addProvider` / `editProvider` / `saveProvider` / `deleteProvider` / `cancelProvEdit` / `isSelectedProvider` · `reload`.

---

## API Endpoints (ORDS)

Module `ar.rest` · base path **`/ords/admin/ar/`** · defined in `final apps/AR/db/05_ar_ords.sql`.
All protected handlers call `dct_rest.validate_session`. **Shared `/dct/` calls:** only auth
(`auth/login`, `auth/logout`, session validation) and `GET boot` go to the Admin
`/ords/admin/dct/` module (via `authBase`). AR has no notifications endpoints (no notification
service in the SPA). All other calls hit `/ords/admin/ar/`.

| Area | Method & Path |
|---|---|
| Events | `GET events/` · `POST events/` · `GET events/:id` · `PUT events/:id` |
| Event Files | `GET events/:id/files` · `POST events/:id/files` · `PUT files/:id/content` · `GET files/:id/content` · `PUT files/:id/classification` · `DELETE files/:id` |
| AI Processing | `POST events/:id/process` · `POST files/:id/process` · `GET events/:id/progress` |
| P&L Lines | `GET events/:id/pnl` · `POST events/:id/pnl` · `PUT pnl/:id` · `DELETE pnl/:id` · `POST events/:id/pnl/confirm` |
| Findings | `GET events/:id/findings` · `PUT findings/:id` |
| KPIs | `GET events/:id/kpis` · `POST events/:id/kpis` · `PUT kpis/:id` · `DELETE kpis/:id` |
| Categories | `GET categories/` · `POST categories/` · `PUT categories/:id` · `GET doc-categories/` · `POST doc-categories/` · `PUT doc-categories/:id` |
| What-If Scenarios | `GET scenarios/` · `POST scenarios/` · `PUT scenarios/:id` · `DELETE scenarios/:id` |
| Stats | `GET stats/dashboard` · `GET stats/events/:id` |
| Settings & Providers | `GET settings/` · `PUT settings/` · `GET providers/` · `POST providers/` · `PUT providers/:id` · `DELETE providers/:id` |
| Meta | `GET meta/lookups` |

---

## Services / Data Layer (`js/services/`)

| Service | Responsibility |
|---|---|
| `api.js` | Bearer-token fetch wrapper; 401 → login. |
| `config.js` | `apiBase` toggle (mock vs ORDS). |
| `authService` | login / session validate. |
| `arService` | events, P&L lines, files, AI jobs, what-if, categories. |
| `settingService` | module/system settings + AI providers. |

---

## Shared shell — Cross-UI SSO hand-off (2026-07-06)

When `FEATURE_SSO_HANDOFF` = Y (delivered by `GET /dct/boot`), the shared shell (`final apps/shared/js/shell.js`) injects an **APEX** button into the topbar: it calls `POST /dct/sso/code` (shared `/dct/` module, db/v2/41b) to issue a one-time code, then opens APEX App 200 already signed-in in a new tab. No app-local code — the button arrives via `shell.initRegionTheme`'s existing boot fetch.
