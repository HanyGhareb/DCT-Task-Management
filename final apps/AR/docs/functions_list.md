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

## 8. AR Customers — DoF Fusion Receivables (2026-07-08)

**AR Customers list** (`arCustomers`) — local store of customer submissions to Fusion.
- `reload` (search + status filter + pager) · `newCustomer` / `openCustomer` · `submitRow` (send to gateway) · `syncRow` (poll PROCESSED, captures Fusion customer code) · `deleteRow` (DRAFT only) · `canEdit` / `canSubmit` / `canSync` / `canDelete` · Fusion lookup modal: `openLookup` / `closeLookup` / `runLookup` / `rowPairs`.

**AR Customer form** (`arCustomerForm`) — full 67-field CreateCustomers form (8 sections; the wire payload adds server-stamped `ORG_CODE` + `SOURCE_SYSTEM` = 69 attributes), required markers, LOV dropdowns (incl. countries), read-only once sent.
- `saveDraft` · `saveAndSubmit` · `back` · `lovText` · client required-field validation.

**SoapUI Generator** (modal on `arCustomers`, AR_ADMIN/SYS_ADMIN) — Excel upload → downloadable SoapUI project XML for bulk CreateCustomers (client-side via SheetJS + `services/soapuiGen.js`; credentials fetched from `customers/soapui-config`, never bundled).
- `openGenerator` / `closeGenerator` · `genTemplate` (Excel template download) · `genChooseFile` (parse + validate, per-row errors) · `genDownload` (env STAGE/PROD, chunk size, password override; blocks CHANGE_ME) · `genReady`.

---

## 9. AR Invoice Rebill — Fusion write-back (2026-07-25)

**Invoice Rebill** (`arRebill`, AR_ADMIN) — submit and track VAT-correction rebill requests.
Each request runs a nine-stage saga inside Oracle Fusion Receivables, performed by the ATD
worker fleet (`otbi-atd/runner/actions/ar_invoice_rebill.py`): credit the invoice off in full →
duplicate it → correct the Tax Classification on the nominated memo lines → set Project/Task on
each line → complete the duplicate. Both generated document numbers come back to the
register. Enqueue only — the page never talks to Fusion directly.
- Single request: `submitSingle` · `resetForm` · `addLine` / `removeLine` · `cmNumberPlaceholder`
  (defaults the credit memo number to `<invoice>CM`) · `lovLabel`. The **memo line is the matching
  key** (2026-07-26): the line number is optional everywhere, and the fleet applies each payload
  memo line to **every** Fusion invoice line carrying that memo (same memo, same treatment).
- Bulk upload (**ONE flat sheet grouped by invoice number** via SheetJS, 2026-07-26): columns
  `Invoice Number · Memo Line · Project Number · Task · VAT Rate Code · CM Number · New Invoice
  Number` + the optional per-invoice header-detail columns `CM_TXN_NO · CM_TXN_DATE · CM_ACCT_DATE
  · CREDIT_REASON · COMMENTS · CM_FINISH · DUP_SOURCE · DUP_TXN_DATE · DUP_ACCT_DATE` (read from
  the invoice's first non-empty cell; blanks fall back to the batch defaults `bulkDate` /
  `bulkReason` / `bulkFinish`, auto comments, source DCT Manual). CM Number / New Invoice Number
  are RESULT columns — an invoice whose results are already filled is skipped, so the running
  workbook re-uploads whole. `downloadTemplate` (flat sheet) · `chooseFile` (parse + group +
  per-row validation) · `submitBulk` (chunked enqueue, per-row `READY #id`) · `clearBulk` ·
  `bulkValidCount` / `bulkErrorCount` / `bulkDoneCount`.
- Register (2026-07-26): the SHARED `<interactive-report>` component over a one-shot capped fetch (10,000; `AR_REBILL_REQUESTS`, `layoutsApi: null`) — filtering, multi-sort, column show/hide/rename, control breaks, highlights, aggregates, CSV/XLSX export and **maximize-to-full-screen** all come from the component; `loadRegister` (refresh) · `irRowClick` (delegated row click via the cell's KO context → stage timeline) · `statusClass` · `fmtDur`.
- Stage timeline drawer: `openDetail` / `closeDetail` · `stageLabel` (EN/AR from the
  `AR_REBILL_STAGE` lookup).

---

## 10. AR Transactions Dashboard (2026-09-02)

**Transactions Dashboard** (`arTrxDashboard`, nav group "AR Transactions", any AR user) —
executive analytics over the Fusion-loaded receivables transaction views
(`AR_TRANSACTION_AGING_V` transaction grain · `AR_TRANSACTION_DETAILS_V` line grain),
modeled on the AP dashboard (App 212). One facet engine (`prod.dct_ar_trx_pkg`) feeds the
KPIs, charts, register and exports so every figure reconciles.
- Facet rail: free-text search + transaction/due/GL date ranges + 13 facet groups
  (settlement OPEN/SETTLED/CREDIT · aging buckets · business unit · type · source ·
  payment terms · complete · customer type · customer · memo line · project · cost
  center · account): `toggleGroup` / `toggleItem` / `chips` / `resetFilters`.
- Analytics region: 8 KPI tiles (transactions · customers · invoiced · collected ·
  credits & adjustments · outstanding · overdue · collection rate) + 8 drillable
  Chart.js charts (`renderCharts`): outstanding by aging (brand ramp, Σ = outstanding
  incl. negative credit balances), settlement doughnut, monthly invoiced trend, top
  customers by outstanding, by type / source / BU, revenue by cost center (line grain,
  informational). `exportSummaryCsv` · `exportChartsPng` · ⓘ hint popovers (`hintOver`).
- Register region: two-level radio (Transactions | Lines — `setLevel`), metadata-driven
  table w/ server sort (`sortBy`), column chooser persisted to `/dct/prefs`
  (`ar.trxdash.cols`; `toggleCol` / `showAllCols` / `resetCols`), CSV + XLSX export
  (`exportCsv` / `exportXlsx`), pager (`reloadRows`).
- Transaction drill window (`openDrill` on any register/drawer row): master details +
  summary card (invoiced hero, collected/credits/adjustments/remaining, settlement +
  aging badges) + revenue lines table (empty-state for line-less opening balances);
  ⤢ maximize (`toggleInvMax`), Esc restores then closes.
- Chart drill drawer (`openChartDrill`): clicked segment → matching transactions,
  reconciling invoiced + remaining footer, CSV (`dwExportCsv`), ⤢ full-screen.
- `printReport` — A4-landscape pixel report (criteria chips + KPIs + chart images +
  first-200 register rows, mirrors the visible columns).
- **Build-bar loader**: `.arld-*` overlay (spinner + segmented Filters/Analytics/Register
  progress bar + `buildPct` %) shown while the page's three loads assemble.

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
| AR Customers (db/10, ADDITIVE — re-run after any 05 re-run) | `GET customers/` · `POST customers/` · `GET customers/:id` · `PUT customers/:id` · `DELETE customers/:id` · `POST customers/:id/submit` · `POST customers/:id/sync` · `GET customers/wssearch` · `GET customers/lovs` · `GET customers/soapui-config` (AR_ADMIN) |
| AR Invoice Rebill (db/11, ADDITIVE — re-run after any 05 re-run; all AR_ADMIN) | `POST rebill/requests` (bulk enqueue, ≤500 rows, per-row result) · `GET rebill/requests` (register) · `GET rebill/requests/:id` (request + 9-stage timeline) · `GET rebill/lovs` |
| AR Transactions dashboard (db/12, ADDITIVE — re-run after any 05 re-run; any valid session) | `GET trx/filters` (facet LOVs + counts) · `GET trx/summary` (KPIs + 8 chart datasets) · `GET trx/list` · `GET trx/lines` (paged registers w/ totals) · `GET trx/list/export` · `GET trx/lines/export` (CSV, 10k cap) · `GET trx/detail/:id` (header + lines) |

---

## Services / Data Layer (`js/services/`)

| Service | Responsibility |
|---|---|
| `api.js` | Bearer-token fetch wrapper; 401 → login. |
| `config.js` | `apiBase` toggle (mock vs ORDS). |
| `authService` | login / session validate. |
| `arService` | events, P&L lines, files, AI jobs, what-if, categories. |
| `settingService` | module/system settings + AI providers. |
| `arCustomerService` | AR Customer submissions CRUD + submit/sync + Fusion lookup + form LOVs. |
| `rebillService` | AR Invoice Rebill: bulk enqueue, register, request detail + stage timeline, form value sets. |
| `arTrxService` | AR Transactions dashboard: facet LOVs, summary (KPIs + charts), two-level register, transaction detail, CSV export blob/text. |
| `soapuiGen` | client-side Excel→SoapUI-project generator (wire catalog, parse/validate, envelope + project XML, template) — keep in sync with `AR/tools/soapui-customers/generate_soapui_customers.py`. |

---

## Shared shell — Cross-UI SSO hand-off (2026-07-06)

When `FEATURE_SSO_HANDOFF` = Y (delivered by `GET /dct/boot`), the shared shell (`final apps/shared/js/shell.js`) injects an **APEX** button into the topbar: it calls `POST /dct/sso/code` (shared `/dct/` module, db/v2/41b) to issue a one-time code, then opens APEX App 200 already signed-in in a new tab. No app-local code — the button arrives via `shell.initRegionTheme`'s existing boot fetch.
