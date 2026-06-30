# General Ledger (App 210) — Functions List

User-facing functions by area. Each area = a `view()` section in `Jet/index.html`; each bullet is a
public method on the single KO viewModel in `Jet/js/app.js`. Mandatory maintenance artifact —
update on any view/method/endpoint change.

## Overview (`view()==='overview'`)
- coverage stats: `combinationCount`, `pctClassified`, per-dimension `valueCount` / `mappedSegments` (from `/boot`).

## Classifications (`view()==='classifications'`) — manage Sector/Chapter/Program master values
- `clsType` — dimension selector (drives `loadValues`).
- `loadValues()` — list values for the selected dimension.
- `addValue()` / `editValue(r)` / `saveValue()` — create/update (code, EN/AR name, **3 alt names**, tag, parent, order, active).
- `deleteValue(r)` — delete (blocked with a message if assignments reference it).

## Segment Mapping (`view()==='mapping'`) — date-tracked assignments
- `mapType` — dimension; `segSearch` + `segOptions` + `mapSegment` — real-data segment-value picker.
- `loadSegOptions()` / `loadMappings()` — picker + effective-history timeline (current + past).
- `addMapping()` / `editMapping(r)` / `saveMapping()` — create/update (value, start/end date, notes); overlap rejected server-side (toast).
- `deleteMapping(r)` — remove an assignment.

## Explorer (`view()==='explorer'`) — the unified COA view
- filters: `expSearch`, `fSector`, `fChapter`, `asOf` (date) → `loadCombos(offset)` (server-paginated).
- `comboRange` — “a–b / total”; `exportCsv()` — CSV of the current filtered set (≤500 rows).

## Actuals (`view()==='actuals'`) — Budget vs Actual report (YTD per GL combination)
- full-viewport width (the `.wrap.wide` modifier is applied on Actuals + Dashboard).
- search criteria: `acPeriod` (**mandatory**, defaults to current period), `acSector`, `acChapter`, `acProgram`, `acAppr`, `acAccount`, `acCostCenter`, `acSource` (transaction-source — keep rows whose measure is non-zero; reactive list `acSources` = budget/commitment/obligation/**openCommitment**/**openObligation**/glActual/grn/apDirect), `acSearch` — populated by `loadAcFilters()` (`/actuals/filters`, now also returns `accounts` + `costCenters` LOVs).
- `runActuals(offset)` — run the report (`/actuals`), server-paginated; `acReset()` — clear filters, keep current period; `btnSearch`/`btnReset` buttons + Enter-to-search.
- business-question answer cards: `tot(k)` reads the `totals` summary (budget, **commitment (PR)**, **obligation (PO)**, **open commitment (PR)**, **open obligation (PO)**, encumbrance, GL actual, funds available, GRN actual, AP direct) for the filtered set.
- result table: budget · **commitment** · **obligation** · **open commitment** · **open obligation** · encumbrance · GL actual · funds · GRN · AP direct columns; full segment codes/descs per row reuse the combination hover popover (`comboHover`); the four PO-derived headers carry a **visible ⓘ hint marker** (`.hint-i`, `title` = `hCommitment`/`hObligation`/`hOpenCommitment`/`hOpenObligation`); row-hover highlight. *Open* = the unliquidated subset of obligation — PO lines whose budget is still encumbered (FUNDS_STATUS Reserved/Partially Liquidated); open commitment is its PR-backed subset.
- drill-down: `openDrill(row, metric)` (`/actuals/lines`, metric ∈ budget|commitment|obligation|opencommitment|openobligation|encumbrance|glactual|grn|apdirect) → wide modal (`drillCols`/`drillRows`/`drillTotalV`, rendered via `cell(row,col)`); `closeDrill()`. **commitment**/**openCommitment** drill to PR lines (PR #, line, description, requestor); **obligation**/**openObligation** drill to PO lines (PO #, line, item, supplier, status).
- `acExportCsv()` — CSV of the full filtered set (≤5000 rows, incl. commitment + obligation + open commitment + open obligation); `acRange` — “a–b of total”.

## Dashboard (`view()==='dashboard'`) — executive analytics
- `dashPeriod` selector → `loadDashboard()` (`/dashboard`); KPI strip via `kpis()` (budget, actual, funds, encumbrance, PO total & count, utilisation/commitment %).
- `gauge()` — utilisation radial gauge (SVG); `trend()` — period-over-period actual SVG area+line; `sectorBars`/`programBars`/`apprBars` — horizontal bar charts (actual / PO commitments); `insights()` — auto-generated executive sentences. All charts are hand-built SVG/CSS (no chart library).

## Refresh (Overview + Actuals + Dashboard)
- `refreshActuals()` — `POST /actuals/refresh` rebuilds `DCT_GL_COA_SNAP` so the report reflects the latest GL/ATD data + mapping edits; `refreshing` / `lastRefreshed`. Also runs hourly (`DCT_ACTUALS_REFRESH_JOB`, db/v2/35) and is mirrored as a button in the ATD app (`POST /atd/actuals/refresh`).

## Shell
- `t()` / `toggleLang()` (EN/AR + RTL), `go(view)`, `signOut()` (→ Admin), `refreshFilters()`.
- formatters: `money(n)` (full AED with separators), `compact(n)` (1.71B / 868.0M / 12K), `fmt(n)`.

## API Endpoints (ORDS) — `db/05_gl_ords.sql`, base `/ords/admin/gl/`
| Method | Path | Purpose |
|---|---|---|
| GET | `/boot` | dimensions catalog + combination/classified counts |
| GET | `/class-types` | dimensions |
| GET/POST | `/class-values` | list (by `?type=`) / create classification value |
| PUT/DELETE | `/class-values/:id` | update / delete value |
| GET | `/segments/:key/values` | distinct segment values + description (picker; `?search=&limit=`) |
| GET/POST | `/mappings` | list (`?type=&segment=`) / create assignment (overlap-validated) |
| PUT/DELETE | `/mappings/:id` | update / delete assignment |
| GET | `/combinations` | unified COA view, paginated, `?search=&sector=&chapter=&program=&asof=` |
| GET | `/combinations/:ccId` | single combination |
| GET | `/balances` | budget balances enriched with Sector, `?asof=&sector=` |
| GET | `/actuals/filters` | report LOVs in one call: periods (+default), sectors, chapters, programs, appropriations, **accounts**, **costCenters** |
| GET | `/actuals` | Budget-vs-Actual per combination for one period (YTD), `?period(req)=&sector=&chapter=&program=&appropriation=&account=&costcenter=&source=&search=&limit=&offset=` (`source` accepts `openCommitment`/`openObligation`); returns `{total, totals{…incl. commitment, obligation, openCommitment, openObligation}, items[…incl. commitment, obligation, openCommitment, openObligation]}` |
| GET | `/actuals/lines` | drill-down lines behind a figure, `?period=&cc=&metric=` (budget\|commitment\|obligation\|openCommitment\|openObligation\|encumbrance\|glActual\|grn\|apDirect); commitment/openCommitment→PR lines, obligation/openObligation→PO lines |
| GET | `/dashboard` | executive analytics for a period: KPIs + by sector/program/appropriation + trend, `?period=` |
| POST | `/actuals/refresh` | rebuild `DCT_GL_COA_SNAP` (manual; same proc as the hourly job) |

## Data layer (PROD)
- Tables: `DCT_GL_CLASS_TYPE` → `DCT_GL_CLASS_VALUE` → `DCT_GL_SEG_CLASS_MAP`.
- Package: `DCT_GL_CLASS_PKG` (`norm`, `set_asof`/`clear_asof`/`get_asof`, `resolve_value_id`, `validate_map`); context `GL_CTX`.
- Views: `DCT_GL_COA_V` (+`GL_COA_V`), `DCT_GL_BALANCES_V`.
- Actuals reporting (db/v2/32–35): base pass-through views (`AP_*`/`PO_*`/`GRN_ALL_V2`/`GL_BALANCES`), `DCT_ACTUAL_V`, `DCT_BUDGET_ACTUAL_V`, `DCT_BUDGET_ACTUAL_PERIOD_V` (per-combination × period YTD; incl. `appropriation_code`/`_desc`, `commitment_ytd` [PR-backed PO lines] / `obligation_ytd` [all PO lines] and `open_commitment_ytd` / `open_obligation_ytd` [the FUNDS_STATUS Reserved/Partially-Liquidated subset], read live from `po_distributions`); indexed snapshot `DCT_GL_COA_SNAP` + `prod.dct_actuals_refresh` (hourly job `DCT_ACTUALS_REFRESH_JOB`).
- Bridge synonyms: `GL_SRC_*` → `ATD_GL_*` (rename-insulation).
