# KPI Module (App 213) — Functions List

User-facing functions of the Finance KPIs JET app, by functional area. Each area maps to a
view (`Jet/js/views/<x>.html` + `viewModels/<x>.js`); each bullet is a public `self.<method>`
on that viewModel.

All main pages use the **FPB-style layout** (mirrors GL Budget Utilization): brand-headed
collapsible regions (`.kp-sec`, `toggleSec`, state persisted in `localStorage('kpi_ui')`)
with ⓘ hint tooltips on region headers, tiles and key fields.

## Scorecard Dashboard (`dashboard`)
- **How to Start region** — 5 clickable steps covering the full KPI cycle (generate calendar →
  start measurement → complete figures → submit for approval → track scorecard); step 1 badged
  as the KPI-Admin step; auto-collapses once the year has scored KPIs (`goResults`/`goWorklist`/`goReports`)
- Year selector (`year`) — reloads the scorecard for the chosen year
- **Overview region** — 4 tinted stat tiles: overall weighted score (`overallDisplay`/`overallClass`/`overallBar`),
  KPIs scored coverage (`coverageBar`), approved measurements (`approvedCount`, click → results),
  in-approval count (`inFlightCount`, click → My Worklist)
- **KPI Scorecards region** — per-KPI cards: average/latest score, previous-year comparison,
  target, period strip coloured by approved score (`freqLabel`, `statusShort`); `openKpi`
- **Chart region** — average-score-by-KPI bar chart with max-score guide line (redraws on
  region expand)

## Results & Submissions (`results`)
- **Search region** (`searchSummary`) — year selector + Generate-periods (KPI_ADMIN) with
  first-step hint
- **Measurements region** — KPI × period matrix (Annual + Q1–Q4) with score pills + status
  badges and a legend row; no-calendar empty state is role-aware (admin: generate CTA,
  user: "ask a KPI administrator" first-step message)
- `openCell` — open an existing measurement, or `initResult` a new DRAFT (with auto-suggested
  figures) and open it
- `generatePeriods` — KPI_ADMIN only; creates the year's measurement calendar

## Measurement Entry (`resultEntry`)
- **"How this KPI is scored" region** (collapsed by default) — calc-method formula pills
  (ratio / abs-variance / weighted), the KPI's live score-band table (`bandCond`/`bandLabel`
  over `kpis/:id` bands) and the banding/provenance/approval rules
- Live computed result + score-band preview (updates on every save)
- A/B figure capture with AUTO/MANUAL provenance badges, system suggestion display,
  `useSuggested`, `refreshSuggestion`, notes (justification for overrides), `save`
- Weighted-criteria capture: maturity rubric picker with the circular level descriptions
  (`pickLevel`) or achievement-% entry, per-criterion justification (`saveCriterion`)
- Evidence: `uploadDoc` (raw binary via shared docUpload, 413-guarded), `downloadDoc`,
  `removeDoc`; required-evidence badge
- `submit` — validations then submit to the DWP approval chain; figures lock
- Approval trail: shared `<wf-timeline>` + status-history table; `goBack`

## My Worklist (`myWorklist`)
- Shared `<wf-worklist>` scoped to `KPI_MGMT` + `<wf-action-bar>` (server-driven outcomes)
- `openRequest`/`closeRequest` — shared `<wf-timeline>` for the selected request

## KPI Registry (`kpiList`, admin)
- Registry table with band/criteria counts, weight-sum warning, current-year target,
  active status; `showAll` toggle; `openKpi`, `newKpi`

## KPI Editor (`kpiEdit`, admin)
- `saveDefinition` — full definition upsert (bilingual names/descriptions, type, polarity,
  frequency, calc method, unit, scorecard weight, evidence flag, auto-source mapping A/B,
  figure labels, display order)
- `saveBands` — 1–5 score band editor (operator/thresholds/labels)
- `addTarget`/`removeTarget`/`saveTargets` — yearly targets
- `addCriterion`/`saveCriteria` — weighted criteria incl. per-level maturity descriptions
- `deactivate` — soft-deactivate the KPI

## Reports (`reports`)
- `run` — generate the KPI Briefing Book for a year via the module bridge (enqueue → poll →
  auto-download); `download` re-downloads the last PDF; last-run status + error display

## Notifications (`notifications`)
- Platform notifications list (`markRead`, `markAll`, `typeClass`)

## API Endpoints (ORDS — `kpi.rest`, base `/ords/admin/kpi/`, source `db/06_kpi_ords.sql`)

| Method | Path | Purpose |
|---|---|---|
| GET | `boot` | identity flags, KPI_* lookups, source registry, upload cap |
| GET | `users` | active-user picker (`?search=`) |
| GET | `kpis` | registry list (`?all=Y` incl. inactive) |
| POST | `kpis` | create/update a definition (KPI_ADMIN) |
| GET | `kpis/:id` | full definition: bands, criteria + levels, targets |
| DELETE | `kpis/:id` | soft-deactivate (KPI_ADMIN) |
| POST | `kpis/:id/bands` | replace-set band editor (KPI_ADMIN) |
| POST | `kpis/:id/criteria` | criteria + levels upsert (KPI_ADMIN) |
| POST | `kpis/:id/targets` | targets upsert + `removeYears[]` (KPI_ADMIN) |
| GET | `periods` | measurement calendar (`?year=`) |
| POST | `periods/generate` | `ensure_periods(year)` (KPI_ADMIN) |
| GET | `results` | paged register (`?year=&kpiId=&status=&limit=&offset=`) |
| POST | `results/init` | open/create a DRAFT measurement (suggestion prefill) |
| GET | `results/:id` | figures, criteria rows, status history |
| PUT | `results/:id` | save figures/notes (DRAFT/RETURNED; live recompute) |
| PUT | `results/:id/criteria/:critId` | save one criterion entry (live recompute) |
| POST | `results/:id/suggest` | re-run the suggestion engine |
| POST | `results/:id/submit` | validate + submit → `dct_wf_engine.start_process` |
| GET | `results/:id/docs` | evidence list |
| PUT | `results/:id/docs` | raw-binary evidence upload (`?file_name=&mime_type=`, 413-guarded) |
| DELETE | `docs/:docId` | soft-delete evidence |
| GET | `docs/:docId/file` | evidence download (media) |
| GET | `scorecard` | dashboard payload (`?year=`) — overall, per-KPI cards + cells |
| POST | `reports/book` | enqueue KPI_BRIEFING_BOOK `{year}` as the calling user |
| GET | `reports/:runId/status` | bridge run status (+`hasPdf`) |
| GET | `reports/:runId/pdf` | authed PDF download |

Worklist/approval actions are NOT here — the shared `/wf/` API serves them
(`<wf-worklist>`/`<wf-action-bar>`/`<wf-timeline>` + `shared/js/wfService.js`).

## Services / Data layer

| File | Role |
|---|---|
| `services/kpiService.js` | the ONE client for `/kpi/` (registry, periods, results, evidence, scorecard, report bridge) |
| `services/authService.js` | shared-session reader (`ifinance_jet_session`), role helpers `isKpiAdmin`/`isKpiApprover` |
| `services/notificationService.js` | platform notifications via `/dct/` |
| `services/config.js` | apiBase `/ords/admin/kpi`, authBase `/ords/admin/dct` |
| DB | `DCT_KPI_PKG` + 9 `DCT_KPI_*` tables + 5 views (`db/01–07`); DWP process `KPI_RESULT_APPROVAL`; report `KPI_BRIEFING_BOOK` (reporting/db/29) |
