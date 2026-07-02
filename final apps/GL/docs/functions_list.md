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
- business-question answer cards (14): `tot(k)` reads the `totals` summary — budget, **Total PR** (`prTotal`), **Open Commitment** (`openCommitment`), **Commitment Pipeline** (`commitmentPipeline`), **Total PO** (`totalPo`), **Open Obligation** (`openObligation`), **PO Pipeline** (`poPipeline`), **Open Encumbrance** (`openEncumbrance`), GL actual, GRN actual, AP direct, SLA actual, **Funds Available (GL)** (`fundsAvailable`), **Funds Available (calc)** (`fundsAvailableCalc`).
- result table — **grouped cells** (`.grp-cell` w/ 3 `.grp-row` each drillable): **Commitment (PR)** = Total / Open / Pipeline (count on Total row); **Obligation (PO)** = Total / Open / Pipeline; **Funds Available** = GL / Calc. Single columns: budget, **Open Encumbrance**, GL actual, GRN, AP direct, SLA. Commitment sourced from real requisitions (`ATD_PR_*`): **Total** = FUNDS_STATUS Reserved+Liquidated / **Open** = Reserved / **Pipeline** = Not-reserved. Obligation from `po_distributions`: **Total** = all except Failed/Passed / **Open** = (Reserved+Partially-Liquidated) **GRN-netted** / **Pipeline** = Failed/Passed. **Open Encumbrance** = Open Commitment + Open Obligation. **AP Direct** = AP lines with `po_number IS NULL`; **SLA** = GRN + AP direct. Group headers carry a ⓘ hint (`hCommitmentGrp`/`hObligationGrp`/`hFundsGrp`/`hOpenEncumbrance`).
- drill-down: `openDrill(row, metric)` (`/actuals/lines`, metric ∈ budget|commitment|opencommitment|commitmentpipeline|obligation|openobligation|popipeline|glactual|grn|apdirect) → wide modal; `closeDrill()`. **commitment/openCommitment/commitmentPipeline** → real PR lines (PR #, description, requester, funds status); **obligation/poPipeline** → PO lines; **openObligation** → PO lines with Ordered / Received (GRN) / Open columns (the netting made visible).
- `acExportCsv()` — CSV of the full filtered set (≤5000 rows, incl. all 3-figure Commitment/Obligation + Open Encumbrance + both Funds Available); `acRange` — “a–b of total”.

## Budget Utilization (`view()==='butil'`) — project budget vs actual (per task & expenditure type)
- full-viewport width (`.wrap.wide` also applied on this view). One row per **Budget Year × Project × Task × Expenditure Type**, budget > 0 lines only.
- search criteria: `buYear` (**mandatory**, defaults to latest year), `buType` (project type), `buSector`, `buSearch` — LOVs from `loadBuFilters()` (`/butil/filters`).
- `runButil(offset)` — run the report (`/butil`, server-paginated); `buReset()`; `btnSearch`/`btnReset` + Enter-to-search; `yearRequired` toast when no year.
- totals answer cards (6) via `buTot(k)`: budget, actualAp, actualGrn, commitmentPr (open PR), obligationPo (open PO, GRN-netted), fundAvailable (= Budget − AP − GRN − Open PR − Open PO).
- result table (17 cols): Type / Sector / Department / Cost centre / Project (number + name) / Task / GL Account / Appropriation / Chapter / Program / Expenditure type + the 6 measures. Attributes resolve task-first (task `COST_CENTER`→SECTOR map, task `APPROPRIATION`→CHAPTER map, task `PROGRAM`), then transactions, then project.
- `buExportCsv()` — CSV of the full filtered set (≤5000 rows); `buRange` — “a–b of total”.

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
| GET | `/actuals` | Budget-vs-Actual per combination for one period (YTD), `?period(req)=&sector=&chapter=&program=&appropriation=&account=&costcenter=&source=&search=&limit=&offset=`; totals + items include `prTotal`, `openCommitment`, `commitmentPipeline`, `totalPo`, `openObligation` (GRN-netted), `poPipeline`, `openEncumbrance`, `fundsAvailable` (GL), `fundsAvailableCalc`, `slaActual`, `poCount`/`prCount` |
| GET | `/actuals/lines` | drill-down lines behind a figure, `?period=&cc=&metric=` (budget\|commitment\|opencommitment\|commitmentpipeline\|obligation\|openobligation\|popipeline\|glActual\|grn\|apDirect); commitment/openCommitment/commitmentPipeline→real PR lines (`pr_*`), obligation/poPipeline→PO lines, openObligation→PO lines GRN-netted (Ordered/Received/Open) |
| GET | `/dashboard` | executive analytics for a period: KPIs + by sector/program/appropriation + trend, `?period=` |
| POST | `/actuals/refresh` | rebuild `DCT_GL_COA_SNAP` + recompile INVALID PROD views (manual; same proc as the hourly job) |
| GET | `/butil/filters` | Budget Utilization LOVs: years (+`defaultYear`), projectTypes, sectors (`07_gl_budget_util_ords.sql`, ADDITIVE — re-run after any 05 re-run) |
| GET | `/butil` | Budget Utilization report, `?year(req)=&projecttype=&sector=&search=&limit=&offset=` → totals + items over `DCT_BUDGET_UTILIZATION_V` (db/v2/37) |

## Data layer (PROD)
- Tables: `DCT_GL_CLASS_TYPE` → `DCT_GL_CLASS_VALUE` → `DCT_GL_SEG_CLASS_MAP`.
- Package: `DCT_GL_CLASS_PKG` (`norm`, `set_asof`/`clear_asof`/`get_asof`, `resolve_value_id`, `validate_map`); context `GL_CTX`.
- Views: `DCT_GL_COA_V` (+`GL_COA_V`), `DCT_GL_BALANCES_V`.
- Actuals reporting (db/v2/32–36): base pass-through views (`AP_*`/`PO_*`/**`PR_*`**/`GRN_ALL_V2`/`GL_BALANCES`), `DCT_ACTUAL_V`, `DCT_BUDGET_ACTUAL_V`, **`DCT_PR_COMMITMENT_PERIOD_V`** (`db/v2/36`, over `ATD_PR_*`, AED via `DCT_CURRENCY_CODES` snapshot: `pr_total_ytd`=Reserved+Liquidated / `pr_open_commitment_ytd`=Reserved / `pr_pipeline_ytd`=Not-reserved + `pr_count`), and `DCT_BUDGET_ACTUAL_PERIOD_V` (per-combination × period YTD; +appropriation; joins the PR view for Commitment; PO 3 buckets from `po_distributions` de-duped by `po_distribution_id` — `total_po_ytd` [ex Failed/Passed] / `open_obligation_ytd` [(Reserved+Partial) **GRN-netted** via `grn_all_v2.po_distribution_id`] / `po_pipeline_ytd` [Failed/Passed]; `open_encumbrance_ytd`; `funds_available_calc_ytd` = Budget−OpenPO−OpenPR−GRN−APDirect; `funds_available_ytd` = GL balance; `po_count`/`pr_count`; **`ap_direct_actual_ytd` = AP lines with `po_number IS NULL`**); indexed snapshot `DCT_GL_COA_SNAP` + `prod.dct_actuals_refresh` (hourly job `DCT_ACTUALS_REFRESH_JOB`).
- Bridge synonyms: `GL_SRC_*` → `ATD_GL_*` (rename-insulation).
