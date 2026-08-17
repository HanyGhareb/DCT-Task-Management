# General Ledger (App 210) — Deployment Notes

Canonical platform-wide SQLcl/ORDS rules live in `final apps/Admin/docs/deployment-notes.md §2`.
This file holds GL-specific deploy steps, history, and gotchas. **Update on every deploy.**

- **2026-08-12 — Butil Organization column (v1.61.0; db/v2/37+39 + GL/db/07 + reporting/db/25).**
  User request after the Department-vs-OTBI question: the page's DEPARTMENT is the GL
  cost-centre segment description (COA snap), NOT the PPM Task Organization — both are now
  shown. `DCT_BUDGET_UTILIZATION_V` gains **TASK_ORGANIZATION** (last column; the raw PPM
  owning org of the task, e.g. "MSS Guggenheim Abu Dhabi"), `dct_butil_scope_v` re-exposes
  it, `GET /gl/butil` ships `organization` per row, and the butil page shows an
  **Organization** column (after Department; skeleton 18→19 cols, CSV export included,
  `cOrg` EN/AR). BUDGET_UTIL_REGISTER (reporting/db/25) carries **Organization** on sheets
  1–5 (`l_bu` + the `l_dim` scope join); sheet 6 (Pending Approval PR-PO) is a Fusion-doc
  register with no butil task dimension — unchanged. The Briefing-Book PDF (db/21) is a
  fixed-layout template and was deliberately NOT widened. **BUG FIXED during the round:**
  the view's `tsk_org` CTE grouped by `task_number` ALONE — task numbers repeat across
  projects, so MAX() could pick another project's organization (4510714 showed "MSS
  Technical Operations Section" instead of "MSS Guggenheim Abu Dhabi"); now project-scoped
  `(project_key, task_number)`, which also tightens the DEPARTMENT last-resort fallback.
  Deploy: 37+39+25 via python-oracledb on vm180 (25 is MERGE-bearing; 37 is a >10KB block —
  Linux SQLcl swallow risk), then GL/db/07 via SQLcl `prod_mcp` (verified
  `INSTR(source,'organization')` in user_ords_handlers), recompile sweep to 0 INVALID,
  webtier release 20260812161233. Verified: live API row parity with OTBI, register run 403
  (org col on 5 sheets), browser check EN+AR PASS.

- **2026-08-04 — Resilient actuals snapshot refresh (db/v2/118; DB only):** `prod.dct_actuals_refresh` now serializes runs through a control-row lock, loads `DCT_GL_COA_STAGE`, verifies non-empty/exact row counts plus non-null/unique `CC_ID` and `CC_STRING`, and only then atomically replaces `DCT_GL_COA_SNAP` in one transaction. Any load/validation/publish failure rolls back and leaves the prior committed snapshot available. `DCT_ACTUALS_REFRESH_LOG` records requester, source/staged/published counts, duration and error with 90-day retention; stats errors are warnings after a successful publish. Removed the unrelated two-pass invalid-view compilation from every run; the dedicated DB-health workflow owns recompilation. PROD verification: four successful 9,409-row runs (4.62–5.52 s), real hourly scheduler run SUCCEEDED, procedure/job healthy, 0 invalid objects.

## Deploy checklist
1. **DB scripts** via SQLcl `sql -name prod_mcp` (CRLF, UTF-8 no BOM, `SET DEFINE OFF`, `SET SQLBLANKLINES ON`):
   - `01_gl_synonyms.sql` — **own fresh session** (ORA-01471 rule).
   - `02_gl_ddl.sql` → `03_gl_pkg.sql` → `04_gl_views.sql`.
   - `06_gl_seed.sql` — run with `JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8` (Arabic class-type names);
     regenerate from CSVs first with `python db/gen_seed.py` if `db/source/*.csv` changed.
   - `05_gl_ords.sql` — **own fresh session**. It DELETE_MODULEs gl.rest — **always re-run the
     ADDITIVE scripts `07` (butil), `08` (rebuild endpoint), `09` (mappings drill), `10`
     (actuals/lines doc numbers), `11` (butil Briefing-Book bridge), `12` (Projects
     Encumbrances), `13` (Encumbrances Pending Approval + its book bridge) and `14`
     (Reconciliation endpoints) right after any 05 re-run.** (09 and 10 are also source-synced
     into 05, so a full 05 re-run carries their changes — re-running them is still harmless.)
     **Post-05 re-run list = 07..14.**
   - After a **structural** ATD reload (new/renamed columns): UI **Rebuild views** button
     (= `POST /gl/actuals/rebuild` → `prod.dct_views_rebuild`, db/v2/38) re-creates the base
     pass-throughs + recompiles + refreshes. If it reports views still invalid → edit/re-run the
     owning script (`db/v2/32`/`34`/`36`/`37`, `04_gl_views.sql`).
2. **Frontend** — bump `window.APP_VERSION` in `Jet/index.html`. A change under `final apps/shared/`
   requires bumping `APP_VERSION` in ALL apps (cache-bust).
3. **Smoke** — `python Jet/dev-proxy.py` (DEV_PROXY_PORT=8090), quick-login via Admin, load
   `/GL/Jet/index.html`; check Overview counts, Classifications CRUD, a Mapping with start/end
   (overlap → toast), Explorer as-of + CSV.

## History
- **2026-08-11 — BUDGET_COMBINATION blank on MSS/ZNM register lines (db/v2/37 re-run;
  DB-only).** 35 of 344 MSS-BU lines (incl. every ZNM line) printed an empty Budget
  Combination in BUDGET_UTIL_REGISTER sheet 1: their tasks/projects carry NO segment
  attributes in Fusion, and the combination builder only read task attrs + the project
  attr rollup — while the DISPLAY cost_centre column also falls back to the line's
  posted-combination segments and the project-window posted segments (which is why the
  row still showed CC 4510183 next to a blank combination). Fix: every ingredient of
  `BUDGET_COMBINATION` (program / cost centre / entity-specific / appropriation) now
  mirrors its display column's chain — task attr → project attr rollup → posted COA
  segment → project-window posted COA segment → default. Verified: NULL combinations
  2026 = **0 for both BUs** (was 35/344 MSS); ZNM sample rows render the full canonical
  string. Re-generate any register produced before the fix to pick the values up.
- **2026-08-10 (b) — Web-tier release `20260811004936` pushed**: GL v1.60.0 live (verified
  `buTypeSel`/`buTypeAdd` + the new override checkbox label served). SAME SESSION: **manual
  ATD_PROJECTS_BUDGET reload** (user-extracted `temp-data/PROJECTS_BUDGET_PERIODS.csv` —
  OTBI slow-performance workaround): backup `atd_projects_budget_bak0811` kept, staging-table
  load (SQLcl LOAD, 1,896/1,896 rows) + transactional DELETE/INSERT swap verified before
  COMMIT (1,896 rows / 7,642,950,825 / 12 accounting periods; 15 Excel `'`-prefixed numerics
  cleaned in preprocess), then `dct_budget_masters_sync` (**needs `ALTER SESSION DISABLE
  PARALLEL DML` when it actually inserts** — auto-parallel DML + the step-2 re-read of
  dct_projects throws ORA-12839; the nightly job normally inserts 0 rows so it never hit it).
  Butil API acceptance: 1,734 lines / 7.585B annual (view exclusions account for the gap),
  MSS 344 / 1.85B intact.
- **2026-08-10 — Project Type MULTI-SELECT + report-generation 5× speed-up + override
  checkbox label (GL v1.60.0).** Three user asks:
  1) **Project Type is multi-select** on Budget Utilization / Projects Encumbrances /
     Pending Approval (shared `buTypeSel` chips + `buTypePick`; **`buType` stayed as a
     computed returning the pipe-joined list so every existing sender — buParams, both
     report bridges, pending bridges — kept working untouched**; default + Reset = the
     single DCT-OPEX chip). Server: `l_ptype` widened to VARCHAR2(1000) + the exact
     `v.project_type = l_ptype` predicate → pipe any-of INSTR in **GL/db/07 (×7) / 12 /
     13 / 15** (deployed via prod_mcp, all 5 handlers verified MULTI) and in the four
     report definitions **BUDGET_UTIL_BOOK / BUDGET_UTIL_REGISTER / ENC_PENDING_BOOK /
     ENC_PENDING_REGISTER** (seed files + CLOB surgery, counts verified, JSON valid).
     Root complaint solved: **MSS Business Unit showed all zeros** because the page's
     DCT-OPEX default type filter excluded every MSS line (their type =
     'MSS OPEX Project Type') — MSS BU + both types now returns 344 lines / 1.85B.
     Smokes: API 6/6 (single 1,380 = unchanged; DCT|MSS = 1,724 union) + browser
     `butil_type_multi_smoke.py` **9/9**.
  2) **Report generation 5× faster**: BUDGET_UTIL_REGISTER renders regressed 0.7 → ~3.5
     min after the Jul-29 sheet-1 enrichment. Per-section timing showed the line sections
     dominated (grn 81 s / open-po 28 s / ap 18 s): the `l_scope`
     `IN (SELECT … FROM dct_butil_scope_v s …)` subquery was FILTER-evaluated per row.
     **Fix = `/*+ UNNEST */` inside the scope IN-subquery** (one textual change to the
     shared fragment): grn 81→5 s, po 28→4 s, ap 18→4 s, pr 5.6→4 s. Applied to seed
     files 21/23/24/25 + CLOB surgery on all four stored definitions (BOOK 7 /
     REGISTER 5 / PENDING_BOOK 7 / PENDING_REGISTER 1 subqueries hinted). Acceptance:
     live run #281 year-2026 register = **SUCCESS in 40 s wall** (15,653 rows). The
     Aug-10 morning 17–28-min QUEUE waits were burst-queueing behind 3.5-min renders —
     they shrink proportionally.
  3) Butil override checkbox label → **"Select to include Budget Override"** (off) /
     "Budget Override included" (on), EN+AR (`buOvrOff`/`buOvrOn`).
- **2026-08-08 (3b) — Web-tier release `20260808143934` pushed**: GL v1.59.0 live; verified
  `APP_VERSION` 1.59.0 + the 16 `buNum(tot(` band bindings and the `mv()` envelope scaler
  served from https://129.151.159.189/.
- **2026-08-08 (3) — "Figures in" display unit on the Budget-vs-Actual drawer (GL v1.59.0;
  frontend-only).** The report-parameters drawer gains the SAME **`buUnit`** attribute the
  Budget Utilization page uses ("Figures in" — Auto B/M/K · Billions · Millions · Thousands ·
  Exact; one shared setting persisted in `gl_bu_ui.unit`, so butil / pending / General Ledger
  stay in sync): the 6 KPI-band cards + sub-rows format through `buNum` (16 bindings,
  compact→buNum), and the IR register scales every money column by the unit divisor with the
  unit suffix appended to the column labels (`(M)` etc.) inside the `acIr` envelope
  (Auto/Exact = full numbers; counts unscaled; `acRowMap`/drills keep the ORIGINAL unscaled
  rows). Display-only — changing the unit re-renders instantly, no re-query. Smoke → **26/26**.
- **2026-08-08 (2b) — Web-tier release `20260808142802` pushed**: GL v1.58.0 live; verified
  `APP_VERSION` 1.58.0 + `fillAcAgg`/`drillSortNote`/`drillGridOver` JS and `.dw-sort` CSS
  served from https://129.151.159.189/.
- **2026-08-08 (2) — KPI aggregate-drill drawer round (GL v1.58.0; frontend-only).** User
  round on the "Budget · All lines" drawer (openAcAgg): ① **Cost-centre column shows
  `code - name`** — resolved client-side from the `/actuals/filters` LOV in the new
  `fillAcAgg` post-processor (no GL/db/10 change); ② **Combination cells show the same
  10-segment popover as the register** — delegated `drillGridOver/Move` on the drawer's
  `.tbl-wrap` (plain-KO context: `$data` = column / `$parent` = row — NOT the IR's
  `$parent.row`), full segment row recovered from `acRowMap` (popover z 90 > drawer z 71);
  ③ rows **guaranteed amount-descending** (server already orders by amt DESC; client
  re-sort makes the contract explicit) + ④ a **sort-criteria pill on top of the table**
  ("↓ Sorted by Total budget — highest first", `drillSortNote`/`.dw-sort`; cleared by
  `fillDrill` and `closeDrawer` so butil/pending drills never inherit it). Smoke
  `ac_ir_browser_smoke.py` extended → **23/23** EN+AR.
- **2026-08-08 — Web-tier release `20260808135924` pushed** (`SSH_USER=opc bash
  webtier/deploy_frontend.sh 129.151.159.189`): GL v1.57.0 live; verified `APP_VERSION`
  1.57.0 + `acIr`/`acLovCommit`/`AC_METRIC` JS and `.ac-body`/`.acg-pr`/`.ac-drillcell`
  CSS served from https://129.151.159.189/.
- **2026-08-08 — Budget-vs-Actual register on the SHARED interactive report + busy overlay +
  type-ahead report parameters (GL v1.57.0; frontend-only, no DB change).** User round on the
  General Ledger tab:
  1) **Results table → shared `<interactive-report>`** (`reportCode GL_BUDGET_ACTUAL_IR`,
     section `ac`): the hand-built 16-column table with stacked `.grp-cell`s is gone; the
     register is a flat IR grid — frozen Combination + Cost-centre columns, grouped header
     bands (Commitment PR / Obligation PO / GL Actual / Funds available) with per-group tints
     (`.acg-*` bands + `.acc-*` cells in app.css), per-column ⓘ hints, PR/PO count columns,
     zebra, and the IR's own search / column mgmt / filters / sort / CSV+XLSX / layouts.
     Figure cells stay **drillable** and the Combination cell keeps the 10-segment popover via
     the delegated-wrapper pattern (`acGridOver/acGridMove/acGridClick` + `ko.contextFor`;
     IR rows carry only declared columns, so `acRowMap` keyed on the combination string
     recovers the full source row for the popover; `AC_METRIC` maps column key → drill metric).
  2) **One-shot loader**: `runActuals()` now page-merges `/actuals` (server clamp is 1,000
     rows/request in GL/db/05 — deliberately NOT raised, avoiding the 05 → 07..18 re-run
     cascade) up to 10,000 rows; the 100-row pager is deleted; `acTruncated` drives a
     truncation note. `acRange` = "loaded of total".
  3) **Spinner**: the oj-progress-circle `.bu-load-ov` overlay (butil/pending pattern) sits
     over the new `.ac-body` wrapper (KPI band + register) on initial load and every search.
  4) **Type-ahead report parameters**: the drawer's six big LOV selects (Sector / Chapter /
     DCT Program / Appropriation / Account / Cost Center) are now `<input list>` datalist
     type-aheads (value = code, label = name) — `acLovCommit` matches exact code, `code · name`,
     exact name, then a UNIQUE contains match, and turns the pick into a chip (Enter or change
     commits). Account Type / Transaction Source / Period stay selects.
  Browser smoke `tests/ac_ir_browser_smoke.py` **18/18** EN + AR/RTL (gotcha: Playwright
  `evaluate` AWAITS a returned promise — call `runActuals()` inside a statement body, not as
  the return value, when asserting the busy overlay mid-run).
- **2026-08-04 (3) — Drawer figures mirror the table format (GL v1.56.2; GL-only)** — the
  notes drawer's Record-details grid now formats exactly like the grid: same unit scaling
  ("Showing figures in"), 2-decimal money, near-zero mode, and the Variance rows carry the
  ▲ green / ▼ red arrow + color (`openDofNote` builds {v, cls, arrow} from the cached column
  meta). Webtier release **20260804221545**; smoke `dof_browser_smoke.py` **59/59**.
- **2026-08-04 (2) — Layout round feedback fixes (GL v1.56.1; SHARED IR change)** — user
  screenshot feedback on v1.56.0: ① truncated frozen headers ("APPROPRIATI…"/"FUSION ACC…")
  → identity code+description pairs **MERGED into single columns** (Appropriation =
  "100103 — FA103-Manpower Expense" frozen 230px, Account = fusion code — name frozen 240px
  [EBS Account keeps its own column], Entity = code — name; the notes-drawer side-map now
  keys on the MERGED fields because normalizeRows drops non-column keys); ② year blocks not
  in the agreed order on the user's machine → the IR's saved column state from the pre-rework
  runs was overriding the new default — NEW generic envelope **`stateRev`** in the SHARED IR
  (folds into the persistence key; bump it when a DESIGNED order change must beat autosave;
  DOF + YoY envelopes now `stateRev: 2`); ③ tint contrast too subtle → current-year green
  raised to .15 and prior-year switched to a distinct **slate-blue** hue (.15), quarter/YoY
  tints strengthened in step; ④ NEW **Chapter + Appropriation Search criteria — MULTI-select**
  (butil chips pattern: pick → chip, any-of semantics; LOVs from the loaded run, Appropriation
  LOV scoped to picked chapters; applied client-side by `dofEmit` with **totals following the
  filter** — whole-chapter picks keep the server CHTOTAL rows [grand recomputed when >1
  chapter], appropriation picks get a recomputed grand row w/ ratios recomputed not summed;
  reset clears, collapsed-search summary lists picks). All fronts bumped, webtier release
  **20260804220157**; smoke `dof_browser_smoke.py` **57/57**, `yoy_browser_smoke.py` 24/24.
- **2026-08-04 — Readability layout round: year blocks/bands/tints, frozen columns, delta
  arrows, unit + near-zero parameters, full-record drawer (GL v1.56.0; frontend-only, SHARED
  IR change)** — user-picked enhancements 1–12 on DOF Submissions + Balances YoY. **SHARED
  `<interactive-report>` gained five generic opt-in hooks**: `column.group`/`groupClass`
  (grouped header band row — contiguous same-group columns render ONE spanning cell),
  `column.colClass` (per-column td class → app-defined tints), `column.sticky` + `width`
  (frozen columns; offsets accumulate over preceding visible sticky columns via
  `inset-inline-start` so the pin mirrors in RTL; hidden columns re-flow the offsets),
  `column.delta` (▲ green increase / ▼ red decrease arrow + value tinted `ir-pos`/`ir-neg`),
  `column.nearZero` `{mode:'muted'|'dash'|'blank', threshold}` (values that round to zero at
  the current unit), `column.ellipsis` (one-line cell + full text on hover title), and
  envelope **`zebra:true`** (stripe parity stamped by the component on the row STREAM —
  `tr.ir-even` — so break/subtotal rows never shift the stripe). `.ir-band*`/`.ir-col-sticky`/
  `.ir-delta*`/`.ir-pos`/`.ir-neg`/`.ir-dim`/`.ir-ellipsis` in platform.css; tint classes are
  the CONSUMER's (`dofc-*`/`dofg-*`/`yoc-*` in GL app.css, loaded after platform.css so tints
  beat the zebra stripe). **DOF Submissions**: columns re-ordered into YEAR BLOCKS (frozen
  Chapter/Appropriation/Account code columns → current-year block → prior-year block →
  Variance → Reasons) under **FY 20xx header bands** (butil = Budget/Performance bands,
  quarterly = Budget + Quarter 1–4 bands w/ alternating quarter tints); current year =
  brand-green tint, prior year = neutral grey; Variance columns carry the delta arrows; NEW
  Search params **"Showing figures in"** (AED/K/M/B — re-emits the cached run, no re-query)
  and **"Near-zero display"** (Dimmed 0.00 / Dash / Blank — the ≈0 pre-2025 EBS actuals read
  as "no data", not real zeros); Reasons/Remarks + description columns truncate to one line
  (hover = full text) and the notes drawer now opens with a **Record details grid = every
  dataset column of the clicked row (raw AED)** above the note fields. **Balances YoY**:
  alternating year-column tints, Change/Change % on a gold tint with the red/green arrows,
  zebra rows. Unit+zero prefs persist in `gl_dof_ui`. Shared change ⇒ all 16 fronts bumped
  (GL 1.56.0), webtier release **20260804214154**; smokes extended: `dof_browser_smoke.py`
  **51/51**, `yoy_browser_smoke.py` **24/24** EN+AR (`pending_browser_smoke.py`'s stale
  nav-count expectation relaxed to ≥10 — the nav grew past it).
- **2026-08-03 (4) — Balances YoY on the SHARED interactive report + Chart sparkline column
  (GL v1.55.0; frontend-only, SHARED IR change)** — the Balances YoY tab's hand-built pivot
  table was replaced by the SHARED `<interactive-report>` (`GL_BAL_YOY`/section `yoy`; envelope
  from the NEW `yoIr` computed — rebuilds on run/measure/search/type): **year columns ASCENDING
  left→right** (2020, 2021 … 2026), **dynamic "Change YY-YY" / "Change % YY-YY" headers** naming
  the two latest selected years (drop 2026 → headers become 24-25; single year → change columns
  omitted), per-column ⓘ hints (year semantics incl. the EBS/Fusion era note, change formulas),
  and a trailing **Chart column** — NEW generic **`spark` column type in the SHARED IR**
  (`column.type='spark'` + `spark:{cols,labels}` → inline SVG mini-sparkline in the cell, hover
  = larger trend chart popover with per-year labels + compact values; injection-safe numeric
  SVG; no sort, exports empty). Also NEW shared-IR behavior: `reconcileColState` now inserts
  NEW envelope columns at their **envelope position** (anchored after the nearest surviving
  envelope sibling) instead of appending — adding 2020 to an existing 2024-2026 run lands the
  column first, not last. `.ir-spark*` styles in platform.css; page CSV export switched to
  ascending years. Shared change ⇒ all 15 apps bumped, webtier release 20260803221349; smoke
  `yoy_browser_smoke.py` rewritten for the IR UI — 20/20 EN+AR.
- **2026-08-03 (3) — Chapter sub-totals everywhere (GL v1.54.0; GL/db/17 + reporting/db/31 +
  runner + SHARED IR change)** — styled **Chapter sub-total + Grand-total bands** in all three
  DOF datasets, on-screen AND in the generated workbooks. DB: the Budget Utilization and
  Quarterly handlers/report sections got the same `GROUP BY GROUPING SETS ((chapter, ap),
  (chapter), ())` treatment the YoY already had — every dataset now ships `rowType`
  DETAIL/CHTOTAL/GRAND, utilization/variance-% recomputed at each total level, notes on detail
  rows only; verified GRAND = Σ(DETAIL) = Σ(CHTOTAL) live. On-screen: NEW generic
  **`row._rowClass`** support in the SHARED `<interactive-report>` (preserved through
  normalizeRows → bound as the `<tr>` class) + `.ir-row-subtotal` (region-soft tinted, bold) /
  `.ir-row-grand` (region-header band, bold) in platform.css — GL stamps the classes from
  `rowType` (shared change ⇒ all 15 apps bumped, webtier 20260803220020). Workbooks: the report
  section SQLs emit a leading **`row_kind`** column and `runner/render_xlsx.py` gained generic
  magic-column support — `row_kind` is consumed (never written to the sheet) and styles CHTOTAL
  rows as a tinted bold band, GRAND as the brand band with white text (opt-in per section, all
  other reports unaffected; synced to vm180-182 + rpt-worker restart). Verified: DOF_YOY_PERF
  run 210 (both sheets styled) + DOF_QUARTERLY_PERF run 211; smoke `dof_browser_smoke.py`
  38/38 (bands + reconciliation checks added).
- **2026-08-03 (2) — DOF column-header ⓘ hints (GL v1.53.0; SHARED IR component change)** — the
  DOF Submissions figure columns now carry hover hint popovers explaining each figure
  (Actual FY {p} = full-year reference, never used by the Variance; Actual YTD {p} = prior year
  cut at the SAME month as the current YTD = the like-for-like comparator; Variance formula;
  budget/cashflow/utilization semantics; Q1/Q2 cumulative revised budgets) — YoY 5 / BU 7 /
  Quarterly 3 hints, EN+AR, year-substituted per run. Implemented as **generic per-column
  `hint` support in the SHARED `<interactive-report>`** (`column.hint` in the envelope →
  ⓘ + `.ir-hint-pop` CSS popover in platform.css; hint survives header renames; ⓘ click does
  NOT trigger the sort) — **shared change ⇒ APP_VERSION bumped in ALL 15 apps** and the whole
  fleet redeployed (webtier release 20260803213633). Verified headless EN+AR incl. hover
  display.
- **2026-08-03 — DOF Submissions rework: all fiscal years + dynamic headers + butil-style search
  (GL v1.52.0; GL/db/17 + reporting/db/31 re-run)** — four user requirements on the DOF tab:
  ① renamed **DOF Submissions** (nav + page title, EN; AR title = التقارير المقدمة لدائرة المالية);
  ② the criteria card became the **butil-pattern collapsible Search region** (`.bu-sec` header +
  chevron + collapsed-state summary, Search/Reset buttons) and the grid moved into a matching
  **Results region** with the `oj-progress-circle` busy overlay (state in
  `localStorage('gl_dof_ui')`); ③ **dynamic year-based column headers** — the run year is baked
  into the IR envelope labels ("Revised Budget 2026", "Actual FY 2025", "Actual YTD 2026/2025",
  "Variance (2026 vs 2025)"; butil/quarterly follow suit) via `{y}`-substituted i18n keys
  (`dofColActualFyY` etc.); ④ **the report now runs for EVERY loaded fiscal year (2016+)** — the
  CURRENT-year leg of `/gl/dof/yoy|butil|quarterly` is a Fusion ∪ legacy-EBS union (bg-1), and the
  prior-year EBS leg was reworked in the same pass to **STORED YTD slices** (platform rule: YTD is
  stored data with opening balances, never PTD-derived) — per combination
  `MAX(measure) KEEP (DENSE_RANK LAST ORDER BY period_date)` at the cutoff (the `13-YYYY`
  adjustment period sorts after `12`), so a 2026 run's prior figures now MATCH a 2025 run's
  current figures byte-for-byte (7,153.6M) and the 2024 budget reads the true stored 3,665.9M
  (PTD-sum gave 3,341.4M). EBS carries ONE budget measure → **Initial = Revised for prior years**
  (era note on the page; the no-cashflow warning is suppressed for years < 2026).
  `reporting/db/31` section SQLs + year LOVs kept in LOCK-STEP (inner slices need `p.me` in
  GROUP BY there — the cutoff comes from the `prm` CTE, not a PL/SQL bind). Verified live: yoy
  2016/2020/2024/2025/2026 + YTD-Jun cutoff on 2025 (2,160.7M), butil 2024, quarterly 2023
  (approved 5,299.5M, revised-CF Q1 4,344.0M); DOF_YOY_PERF 2024 (250 rows) + DOF_QUARTERLY_PERF
  2023 (55 rows) workbooks SUCCESS; browser smoke `tests/dof_browser_smoke.py` extended → 35/35
  EN+AR. **⚠ Data flag (standing):** 2016–2024 EBS **actuals net ≈ 0 on budget group 1** — those
  years' actuals sit on **budget group 8 with credit signs** (2016 −245.6M … 2023 −4,204.3M FY),
  only the 2025 export carries actuals on bg 1 (+7,153.6M). Budgets are real on bg 1 every year.
  Until Finance confirms the sign/group convention, prior-era DOF actual columns show ~0 by
  design — do NOT invent a bg-8 sign flip in the reports. Handler literal sizes now 10.3–10.7KB —
  after a Linux-SQLcl deploy of 17, verify `LENGTH(source)` in `user_ords_handlers` (join
  `user_ords_templates` on `t.id = h.template_id`) against the script.
- **2026-07-21 — Applied-filters tray (GL v1.38.0)** — the multi-select chip bar (`.mchips-bar`,
  shared by the butil / encumbrances / pending Search regions) is now a highlighted
  **applied-criteria tray**: brand-green tinted band w/ 3px inline-start accent spine (logical
  props → mirrors in RTL), opened by the GL gold-diamond mark + a small-caps "Applied filters"
  eyebrow (`.mchips-lab`, i18n `appliedFilters` EN/AR); chips invert to white surfaces against the
  tint; soft one-shot entrance animation (reduced-motion aware). CSS-only + label span in the 3
  bars; verified EN + AR/RTL, no JS errors.
- **2026-07-21 — Period-aware Budget: Annual + YTD Budget columns w/ drill-down (GL v1.37.0)** —
  the user added `ACCOUNTING_PERIOD` (MM-YYYY — the SAME format the page's period param sends) to
  `ATD_PROJECTS_BUDGET`, so the Budget figure is now period-aware. Data profile at build time:
  1,836 rows, 0 NULL periods/budgets, most lines lumped in 01-2026, ATD total = view total exactly.
  - **DB (`db/v2/37` re-run; `dct_views_rebuild` FIRST — the pass-through lacked the new column):**
    pb CTE now emits `BUDGET_ANNUAL` (sum of ALL period rows) and `BUDGET` = **YTD** (period rows
    on/before `GL_CTX.BUTIL_END`; NULL/unparseable period → DATE 1900 fallback = always included,
    i.e. un-spread budget counts as annual). `FUND_AVAILABLE = BUDGET(YTD) − consumption`; line set
    = `HAVING BUDGET_ANNUAL > 0` (rows never appear/disappear when the period changes). Acceptance:
    full-year totals byte-identical to before; Jan YTD 6.66B < annual 7.57B; **Dec YTD = annual to
    the penny (PASS)**; line count 1,724 stable across periods. Every consumer that sets BUTIL_END
    (page, briefing book pre_sql) gets the YTD budget automatically; all others see annual.
  - **ORDS (`GL/db/07` re-run):** `/gl/butil` rows + `totals` gain `budgetAnnual`; `/gl/butil/lines`
    gains metrics **`budget`** (YTD periods) and **`budgetannual`** (all periods) — rows = the
    line's `projects_budget` period records (period/amount/updatedBy/updatedOn), both drill modes
    (row + aggregate KPI). **GOTCHA: `l_metric` was `VARCHAR2(10)` and 'budgetannual' is 12 chars —
    a DECLARE-section VALUE_ERROR is uncatchable → ORDS 555. Widened to VARCHAR2(20); size handler
    DECLARE vars for the longest routed value.**
  - **Frontend (v1.37.0):** results table shows **Annual Budget + YTD Budget** columns (equal on
    Full year), BOTH drillable to the period drawer; Budget KPI tile became a duo tile (hero = YTD
    which drives Fund/Utilization; rows Annual/YTD w/ YTD-of-annual %, both aggregate-drillable;
    seg bar = YTD share of annual); CSV export gains the annual column; skeleton 17→18 cols;
    Calculation Logic region + period ⓘ hint updated (budget no longer "stays annual"). Browser E2E
    7/7 (columns, duo tile, both drills, YTD < annual under a period, calc region 6 rows).
- **2026-07-21 — Calculation Logic region on Budget Utilization (GL v1.36.0)** — new fourth
  collapsible `.bu-sec` at the BOTTOM of the butil page (collapsed by default; state persisted in
  `localStorage('gl_bu_ui').calc`) documenting, in the UI itself, how every figure is computed from
  the Budget Year + Accounting Period criteria: colour-coded formula pills (Fund Available = Budget
  − (Actual AP + Actual GRN + Commitment PR + Obligation PO), palette = the KPI band's), a
  per-figure 3-column table (what it counts / Accounting-Period YTD effect — the annual budget is
  NEVER period-filtered; AP capped by invoice accounting date, GRN by accounted-else-transaction
  date, PR/PO by budget date, PO GRN-netted) and Budget-Year / YTD / Utilization-% notes. Frontend
  only (index.html + app.js i18n/state + app.css `.calc-*`/`.cf-*`); EN/AR + RTL; Playwright E2E
  PASS (present/collapsed default, expand = formula + 5-row table + notes, localStorage
  persistence, AR/RTL, zero JS errors).
- **2026-07-18 — Business Unit filter on Budget Utilization + Projects Encumbrances (GL v1.34.0)** —
  follow-through of the BU rollout after the user's extract fixes: `ATD_PROJECTS.BUSINESS_UNIT_NAME`
  now carries the REAL BU name (was junk 'BU'), so **every budget line takes its PROJECT's Business
  Unit**. `db/v2/37` butil view + `db/v2/39` `DCT_BUTIL_SCOPE_V` gain `business_unit` (re-run +
  recompile sweep to 0 INVALID); `GL/db/07` adds `bu=` exact any-of to `/butil` + `/butil/lines`
  (all 6 chapter-predicate spots) + `businessUnits[]` in `/butil/filters`; `GL/db/12` `/encumbrances`
  same; `GL/db/11` all three bridges (book/xlsx/ppt) + GL/db/13's ppt bridge forward `bu`;
  reporting/db/21+25 bind it in `l_bscope`/`l_scope` (params+spec via the BUDGET_UTIL_BOOK spec,
  cover chip in `budget_util_book.html.j2`) — deployed via vm180 python-oracledb. Frontend: shared
  **Business unit** multi-select chips on the butil + encumbrances Search regions (LOV from
  /butil/filters; single value today — grows automatically as more BUs reach the extracts); the
  Pending Approval page KEEPS its own snapshot-document BU filter (runPending overrides `p.bu`).
  Butil BU today = one value (projects are all DCT) — the AP dashboards got the real cross-BU data
  (see AP notes). E2E: BUDGET_UTIL_REGISTER runs 109 (bu=DCT, 9,530 rows) / 110 (bogus BU, 0 rows);
  spot check 7/7; pending regression 47/47.
- **2026-07-18 — Web-tier release `20260718021355`** (`SSH_USER=opc bash
  webtier/deploy_frontend.sh 129.151.159.189`): GL v1.32.1 live — verified `APP_VERSION` +
  `app.js` now serves `runBuPpt`/`toggleGen`/`buGenBusy` (the dropdown, whose markup had shipped
  earlier without its handler, is now functional) and `/gl/butil/ppt` 401s without a token.
- **2026-07-18 — "Generate Report" dropdown + PowerPoint export (GL v1.32.1).** UX request:
  fold the Budget Utilization page's **Export Excel** + **Briefing Book** buttons into ONE
  **"Generate Report ▾"** split button and add a **PowerPoint** option. The menu (`.gen`/
  `.gen-menu`/`.gen-item`, click-outside `.gen-back`) offers Briefing Book (PDF), Excel Register
  (XLSX) and PowerPoint (PPTX); Export CSV / Rebuild views / Refresh actuals stay separate.
  - **PowerPoint is a NEW output format for the whole Reporting Platform.** Backend:
    `reporting/runner/render_pptx.py` (python-pptx) builds an executive 16:9 deck from the same
    MULTI sections as the Briefing Book — cover + KPI overview + utilization-by-sector chart+table
    + budget composition doughnut + lines under pressure + actuals & supplier concentration +
    open obligations/commitments + observations & insights + methodology (native, editable
    tables/charts; figures match the PDF/Excel). `runner.py` gains a `PPTX` format branch;
    `reporting/db/26` (+ db/02 source) registers `PPTX` in the `RPT_FORMAT` lookup (else
    `record_output` → ORA-20090). python-pptx added to the fleet (vm180-182) + `deploy_worker.sh`.
  - PPT reuses `BUDGET_UTIL_BOOK`: the GL bridge `POST /gl/butil/ppt` enqueues it with
    `formats='PPTX'` (+ `GET /butil/ppt/:id` status, `/butil/ppt/:id/file` download) — added to
    `db/11_gl_butil_book_ords.sql` alongside the book/xlsx routes. **Post-05 re-run of 11 unchanged.**
  - Verified: local deck render (8 slides, visual QA of cover/KPI/sector/insights); fleet E2E
    run 101 SUCCESS (valid 8-slide deck from real 2026/Tourism data); HTTP bridge E2E run 102
    (POST→SUCCESS→valid 64 KB .pptx, 400 no-year / 401 no-token); browser smoke 14/14 (dropdown
    replaces the two buttons, 3 format options, PowerPoint generates + downloads a valid 8-slide
    deck, EN/AR menu localized). APP_VERSION 1.32.1.
- **2026-07-17 — Business Unit multi-select filter (GL v1.31.0)** — user request: BU as a search
  criterion "in all dashboards in GL and AP + the reports", multi-select. **Data reality: the BIP
  pending-approval snapshot is the ONLY cross-BU source on the platform** (DCT 713 / Museum Shared
  Services 293 / Abrahamic Family House 10 docs; the non-DCT docs are 100% OUTSIDE the budget
  extract). The OTBI extracts feeding every other surface are DCT-scoped single-value
  (`ATD_PR_DISTRIBUTIONS.BUSINESS_UNIT` / `ATD_PO_HEADERS.*_BU` = one value; `ATD_AP_INVOICES`
  has NO BU column; `ATD_PROJECTS.BUSINESS_UNIT_NAME` = literal placeholder 'BU'; budget lines /
  GRN / GL balances = none) — so a BU filter elsewhere would be a one-value dropdown that never
  changes results, and it was NOT added there (unlock = add BUSINESS_UNIT to the OTBI extracts,
  then wire it like this one). Implemented where real: **Encumbrances – Pending Approval page**
  gains a Business Unit multi-select (options from the new `businessUnits[]` LOV in the response;
  picks = chips on the shared mchips bar; Reset clears) → `bu=` pipe-delimited EXACT any-of on
  `GET /gl/pending`, scoping register + ALL KPIs/aging/approvers AND the unmatched coverage KPI
  (GL/db/13 re-run); both bridges forward `bu`. Reports: `bu` param in ENC_PENDING_BOOK
  (reporting/db/23 — all 4 scoped sections + the coverage annex + cover chip in
  `enc_pending_book.html.j2`) and ENC_PENDING_REGISTER (reporting/db/24 — both sheets), each
  param_spec gains the `bu` entry via JSON_MERGEPATCH (seeds deployed via vm180 python-oracledb;
  template upserted + bundled copies synced to vm181/182). E2E: xlsx run 89 (bu=MSS|AFH) =
  0 register rows + 303-doc annex; run 90 (bu=DCT) = 990 register rows (= page 992 minus the 2
  not-reserved) + 14 annex; book run 91 cover shows the BU chip. Smoke +4 checks = **45/45**.
- **2026-07-16 — Pending page: zero-value lines excluded (GL v1.30.1)** — user's round-4 review:
  the "Not reserved (pipeline)" drill still surfaced 0-amount lines. **User rule: the page follows
  budget utilization — a zero line never reserves funds — so zero-value lines are EXCLUDED from the
  PAGE too** (until now the rule applied only to the book/Excel register, which additionally keep
  RESERVED lines only; the page keeps the reserved/not-reserved split). Fix = ONE predicate in the
  `GET /gl/pending` cursor (`ABS(NVL(line_aed,0)) > 0.005`, GL/db/13 re-run) — the single-scan
  design means register, KPIs, aging, approvers AND the client-side drill slices all pick it up
  at once (the unmatched `in_extract='N'` coverage KPI is computed separately and is untouched).
  Live: 1,035 → 992 lines, docs 712 (no real document lost; later snapshot 991/711 = one all-zero
  doc dropped), totals reconcile; not-reserved slice = 2 real lines / 450K (rest was zero noise).
  Page subtitle now states the rule (EN/AR). Smoke +1 check = **41/41** — webtier release
  20260716223006.
- **2026-07-16 — Review round 3: page UX + butil book/Excel + report covers (GL v1.30.0)** —
  ①**Pending page UX**: busy overlay (the butil `.bu-load-ov` oj-progress-circle replica
  wired to `pnLoading`, KPI band + Results wrapped in a `.bu-body`; `.pn-loading` min-height
  covers the first load); **KPI drill-downs** — every tile breakdown row (PR/PO docs, PR/PO
  amounts, Reserved/Not-reserved, Over-30/Within-30), every aging bucket row and every
  top-approver row opens the SHARED right-edge drill drawer with the matching pending lines
  (client-side slice of the loaded register `pnItems`, cap 1,000 w/ top-N note, total
  reconciles, CSV export for free; drawer Document # cells deep-link to Fusion via a new
  generic `drillLink` rule on key `docNumber` + row.source/fusionHeaderId); the aging/approver
  **mini-table headers are region-header bands in the user-specified `#79C5AC`**
  (`.pn-mini h4`, dark-green text for contrast, tables in `.pn-tbl-wrap`, hover tint on
  clickable rows).
  ②**Budget Utilization book (`reporting/db/21` + template redeployed)**: NEW **Part 5 —
  Pending Approvals (PR & PO Queue)** (sections `pend_ov`/`pend_aging`/`pend_approvers` over
  `DCT_PR_PO_PENDING_V`, reserved non-zero rule; KPI tiles + aging/approver bars + top-10
  per-approver table), TOC row added, Observations renumbered Part 6 + a new **Approval
  queue** insight (pending value as % of open encumbrance, over-30 focus).
  ③**Budget Utilization Excel register**: NEW `BUDGET_UTIL_REGISTER` (`reporting/db/25`,
  MULTI/PYTHON, XLSX-only — 6 sheets: utilization lines / direct AP / GRN receipts / open PO
  / open PR / pending PR-PO queue; params = the butil set, param_spec copied from the book;
  section SQLs kept in LOCK-STEP with db/21) + bridge `POST /gl/butil/xlsx` + `:id` +
  `:id/file` (**GL/db/11 re-run**) + **Export Excel** button on the butil page head.
  ④**Both report covers** (senior-frontend pass, both `.j2` templates + runner):
  "Oracle Fusion i-Finance · Reporting Platform" brand line; generated stamp in the simple
  form **"Thu 16-Jul-2026 10:04 pm"** (NEW additive runner ctx field `generated_at_pretty`
  — runner.py synced to vm180-182 + rpt-workers restarted; `generated_at` unchanged for
  other consumers); **Prepared-by card** (framed white card, brand accent spine, PREPARED BY
  eyebrow, 16.5px name).
  E2E runs 86/87/88 all SUCCESS (butil book 230pp w/ Part 5+6 verified; register 906KB
  6-sheet workbook 9,483 rows; pending book cover verified); browser smoke **40/40**;
  webtier release 20260716220623.
- **2026-07-16 — Pending Approval Excel register (GL v1.29.0)** — user request: "the same
  report only table … in Excel format for internal analysis". NEW Reporting-Platform
  definition **`ENC_PENDING_REGISTER`** (`reporting/db/24`, MULTI/PYTHON,
  **default_formats = XLSX only**, no template — `build_xlsx_multi` renders one styled sheet
  per section): sheet 1 = ONE flat register of every funds-reserved pending PR/PO line
  (same ENC_PENDING_BOOK scope rule) with ALL related info — 29 columns: approval trail
  (preparer, submitted, days, pending-with), business unit, funds status, project/task/etype,
  Sector, Chapter, Cost centre / Account / Appropriation / Program (code+name), budget date,
  currency, AED amounts, canonical GL combination; sheet 2 = the extract-coverage annex.
  Params = the butil set + `source` (param_spec = BUDGET_UTIL_BOOK's via **JSON_MERGEPATCH**
  + a source entry). GL bridge (`GL/db/13` re-run): `POST /gl/pending/xlsx` (+source in
  body) + `GET /gl/pending/xlsx/:id` (hasFile) + `/:id/file` (XLSX download). Page: **Export
  Excel** button next to Briefing Book (`runPnXlsx`, 4-s poll, auto-download
  `Encumbrances_Pending_Approval_Register_<year>.xlsx`). 24 is MERGE-bearing → deployed via
  python-oracledb on vm180. E2E run 83 SUCCESS in ~10s: 1,004 register rows (919 PR + 85 PO)
  + 329 annex rows, total 570,603,223.50 AED — exactly the book's reserved-scope pending
  value. Browser smoke 30/30; webtier release 20260716075119.
- **2026-07-16 — Pending Approval review round (GL v1.28.0)** — user's manual-review fixes, all
  layers redeployed same day (webtier release 20260716050503).
  ①**Book (`reporting/db/23` + template re-upserted via vm180)**: BUSINESS RULE — the book now
  covers **funds-RESERVED, non-zero lines ONLY** (not-reserved documents and zero-value lines
  excluded from every section; the GL page still shows them and keeps the reserved/not-reserved
  split tile); ALL table text displays in full (no `|truncate` in any table cell — only chart
  bar labels stay shortened); PR/PO registers + the oldest-20 table gained **Sector / Cost
  centre (code+name) / Appropriation (code+name)** via `DCT_GL_COA_SNAP` (doc-grain rows show
  "(Multiple)" when a document spans combinations — the `l_docg` inline view carries the
  MIN=MAX collapse); **Cur + Funds columns removed**; overview lost the Not-Reserved tile +
  reservation stack; budget-impact insight rewritten (everything in scope is already inside
  open encumbrance). E2E run 82 SUCCESS — 1,385 lines (919 PR + 85 PO reserved non-zero).
  ②**View (`db/v2/52`)**: + `fusion_header_id` (pr_header_id / po_header_id) — document
  numbers alone cannot build Fusion deep links.
  ③**ORDS (`GL/db/13` re-run)**: `GET /pending` + `source=` param (PR|PO, else 400; empty =
  both) and `fusionHeaderId` on every item (NOT a column — the shared IR grid drops
  undeclared row fields, so the frontend keeps a source|doc# → id side-map).
  ④**Page**: Search gains **Source** (All/PR/PO, page-local `pnSource`, cleared by Reset) and
  **"Showing figures in"** (the shared `buUnit` selector — KPI tiles + mini-table amounts now
  format via `buNum`); **KPI band redesigned** (senior-frontend pass, `.pn-kpis`/`.pnk-*`
  semantic accents: docs steel-blue / amount gold / reservation green-vs-red / aging amber
  flipping `.hot` red while over-30 exists; pct pills, unit suffix, non-drillable rows lose
  the pointer affordance); aging mini-table gets heat badges (`.pn-badge pnb0..3`), approver
  max-days gets a red `.pn-days.bad` chip past 30; **Document # cells deep-link to Fusion**
  (delegated `pnGridOver`/`pnGridClick` via ko.contextFor — hover underline + title, click
  opens `FusionLinks.requisition/purchaseOrder(fusionHeaderId)` in a new tab; no
  shared-component change). Browser smoke **29/29 EN + AR/RTL** (adds source-scope,
  figures-in, hot-state, badge and deep-link cases).
- **2026-07-16 — Encumbrances – Pending Approval page + Briefing Book (GL v1.27.0)** — new nav
  tab monitoring every PR / PO document PENDING APPROVAL in Fusion, on the butil criteria.
  ①**DB view `PROD.DCT_PR_PO_PENDING_V`** (`db/v2/52`): the daily BIP snapshot
  `atd_pr_po_pending_approval` (otbi-atd/db/47, loaded ~08:00 Dubai) joined to the PR/PO
  distribution detail — PR leg on `TO_CHAR(pr_distributions.requisition) = document_number`,
  PO leg via deduped `po_headers`/`po_distributions`; AED via the currency snapshot (PR) /
  distribution rate (PO); `enc_open_aed` = the butil Open Commitment / GRN-netted Open
  Obligation bases; GL_CTX.BUTIL_END-aware (budget_date window + GRN netting) like db/v2/39;
  a third leg keeps snapshot docs with NO qualifying extract line (`in_extract='N'`, 256 PR +
  73 PO on deploy day) so nothing pending is silently dropped. `submitted_for_approval_date`
  is a DD-MM-YYYY STRING in the snapshot (user decision) → parsed with
  `TO_DATE(... DEFAULT NULL ON CONVERSION ERROR)`.
  ②**ORDS `GL/db/13`** (additive; **post-05 re-run list now = 07+08+09+10+11+12+13**):
  `GET /gl/pending` (full butil param set incl. period-YTD via `set_butil_end`/ALWAYS-clear;
  ONE scan streams the register [cap 10k, `limit=` — note the ORDS-reserved `:limit` bind
  defaults to 100 when absent, the page always passes it] AND accumulates the monitoring
  aggregates in the same loop, so `kpis{}` / `aging[]` (0-7/8-15/16-30/31+ at document grain)
  / `approvers[]` (top 8 by value held) / `unmatched{}` / `totals{}` stay correct even when
  the echoed rows are capped; per-doc dedupe via an assoc array keyed source|doc_number) +
  `POST /gl/pending/book`, `GET /gl/pending/book/:id`, `GET /gl/pending/book/:id/pdf`
  (clone of the 11 bridge, report_code `ENC_PENDING_BOOK`). API smoke 20/20; register sum ==
  totals; aging/approver sums reconcile to KPIs; pending encOpen ⊆ /gl/encumbrances openAed.
  ③**Frontend** (`view()==='pending'`, nav after Projects Encumbrances): reuses the bu*
  filter bar + datalists verbatim (`runPending()`), 4 composite `.bk` tiles (Pending
  documents PR/PO split · Pending amount · Funds reserved vs not-reserved [the not-reserved
  slice is what would hit Fund Available on approval] · Approval aging w/ over-30 focus),
  aging + top-approver mini tables (`.pn-grid2`/`.pn-mini`/`.pn-tbl` in app.css), unmatched
  coverage note, and the SHARED `<interactive-report>` (reportCode `GL_ENC_PENDING`,
  section `pend`) with the GL-combination hover popover reused from the encumbrances tab.
  Briefing Book button = same poll/download pattern as butil (`/gl/pending/book`).
  Browser smoke **21/21 EN + AR/RTL** (`tests/pending_browser_smoke.py`; networkidle never
  settles on this app — wait for `ko.dataFor(document.body)` instead; Chrome innerText
  applies the header text-transform → compare lower-case).
  ④**Briefing Book `ENC_PENDING_BOOK`** (`reporting/db/23` + DB template
  `enc_pending_book.html.j2`): MULTI/PYTHON landscape PDF — cover/TOC, Part 1 overview
  (KPIs + composition/reservation stacks + budget-frame bars + aging/approver bars + aging
  & sector tables), Part 2 approver follow-up (top 15 + oldest 20), Part 3 pending PR
  register, Part 4 pending PO register, Part 5 computed insights (velocity, bottleneck
  concentration, budget impact of approval, composition, extract coverage) + methodology,
  Annex = unmatched docs. Params = the FULL butil filter set; `pre_sql`/`post_sql` set/clear
  BUTIL_END; param_spec copied from BUDGET_UTIL_BOOK (kept in lock-step). **23 is
  MERGE-bearing → deployed via python-oracledb on vm180** (template upserted via
  `upload_template.py` there; bundled copy synced to vm180-182). E2E: run 81 SUCCESS,
  1,427 lines, 67-page 845KB PDF, figures reconcile to the page. Webtier release
  20260716025748 (deploy as `SSH_USER=opc`).
- **2026-07-15 — Projects Encumbrances: column reorder + GL-combination hint (GL v1.26.0)** —
  user-requested. ①**Column order** (`GL/db/12`, server-defined; the IR renders the
  server `columns[]` order for fresh/Reset users — a returning user's localStorage
  layout `GL_PROJ_ENCUMBRANCES::enc` overrides it until they hit **Reset**): now
  Sector · Chapter · Project name · Project # · Task · Expenditure type · Source ·
  Document # · Line · Description/Vendor · Budget date · Cur · Line amount · Open/Reserved ·
  GL combination · Program · Cost centre · Account · Appropriation · (then Entity ·
  Budget group · Entity specific · Intercompany · Future 1 · Future 2), each segment code+name.
  DB-only, additive, **standalone-safe re-run of 12** (deployed + verified handler source
  order). ②**GL-combination hint**: the same 10-segment `.combo-tip` popover used on
  Actuals/Explorer now shows on hover over the grid's **GL combination** cell — wired
  **GL-side only** (no shared-component change): a delegated `mouseover/mousemove/mouseout`
  on the encumbrance wrapper resolves the hovered IR cell's row/column via `ko.contextFor`
  (`$data`=column, `$parent.row`=row) and triggers `comboHover` when key='combination';
  `comboRows` now accepts `*Name` (IR rows) as well as `*Desc` (Actuals/Explorer rows).
  Frontend files: `Jet/index.html` (wrapper + APP_VERSION 1.25.0→**1.26.0**), `Jet/js/app.js`.
  **No `final apps/shared/` change → no all-apps bump.** Frontend ships via webtier release.
- **2026-07-15 — Butil KPI-card drill row cap 1000 → 10000 (`GL/db/07`, DB-only)** —
  user reported the aggregate "Actual AP" drill (1,040.1M) did not list all the invoices
  a single budget-line drill showed (e.g. `4511000175 / Mission & Travel-N` = 93K / 7
  invoices). **Root cause: not a data bug** — the 93K IS in the 1,040.1M. `/butil/lines`
  aggregate mode returns `rows[]` capped `FETCH FIRST 1000 ROWS ONLY` ordered by amount
  DESC, while `total`/`count` come from `COUNT(*)/SUM() OVER()` over the full set (line
  371). The card drill spans ~2,985 AP lines; the 1,000th-largest is ~21K, and these
  invoices are 13–20K, so they fell below the visible top-1000 even though counted.
  Verified in PROD (2,985 lines / rank-1000 ≈ 21K / 1,947 lines ≤ 20K). Fix: raised all
  four metric caps (ap/grn/pr/po) to 10000 (full base is ~3k → effectively exhaustive;
  matches the encumbrance `EN_MAX`=10000). Deploy: **07 re-run, standalone-safe** (fresh
  session; verified stored handler source = 4× `FETCH FIRST 10000`, 0× old). No frontend
  change (server-only; `drillCapNote` "top {n} of {c}" still guards any future overflow).
  The row-cell drill was always complete. See `budget_utilization_missing_data.md`.
- **2026-07-15 — Web-tier release `20260715131150` pushed** (`SSH_USER=opc bash
  webtier/deploy_frontend.sh 129.151.159.189`): GL v1.25.0 (Projects Encumbrances tab) live;
  verified `APP_VERSION`, the requirejs bootstrap (`define('knockout'…)`) and `runEncumbrances`
  served from https://129.151.159.189/, and `/gl/encumbrances` 401s without a token (deployed +
  auth-enforced). The `db/12` endpoint was already live on PROD (reconciliation tested against
  the production ORDS URL).
- **2026-07-15 — Projects Encumbrances tab (GL v1.25.0) — new "Open Projects Encumbrance
  Follow-up" report on the SHARED `<interactive-report>` component.** New nav tab + view
  `encumbrances`: every OPEN encumbrance line (Open Commitment PR reserved + Open Obligation
  PO GRN-netted) for the budget lines matching the Budget Utilization scope, exploded to the
  FULL GL combination — all ten segments, **code + name** — plus sector/chapter. Rendered in
  the same APEX-IR grid AP/BI use (column show/hide/reorder/rename, filter chips, multi-sort,
  calc columns, aggregates, control breaks, highlight rules, CSV + XLSX export, per-user
  localStorage layouts). **Search criteria = Budget Utilization verbatim** (reuses the `bu*`
  filters, `buParams`, and the `bu-*` autocomplete datalists; the Open total reconciles to the
  butil Total Encumbrance).
  - DB: `db/12_gl_encumbrances_ords.sql` (ADDITIVE) `GET /encumbrances` — key-set CTE lifted
    from `/butil/lines`, UNION PR+PO, joined to `DCT_GL_COA_SNAP` via `dct_cc_canon` for the 10
    segment code/name pairs; returns `{columns[],items[],count,totals{openAed}}`; zero lines
    excluded; capped 10 000 by open amount. Deployed via SQLcl (additive, no MERGE — fine on
    Linux SQLcl). ORDS stores handler source uncompiled → validated at runtime.
  - **Re-run list after any 05 re-run is now 07 + 08 + 09 + 10 + 11 + 12.**
  - IR in a PORTAL app: GL has no requirejs, so `index.html` bootstraps a minimal one —
    `fusionLinks.js` (UMD) loads as a plain `<script>` BEFORE require.js (else its anonymous
    `define()` collides), then require.js + `define('knockout', [], ()=>window.ko)` reuses the
    ALREADY-loaded global Knockout so the shared AMD IR component registers
    `<interactive-report>`/`<edit-drawer>` on the SAME `ko` the app binds with; `shared/i18n` is
    initialised for the `ir.*` toolbar labels and kept in sync by `toggleLang`. Every step
    degrades gracefully (a load failure still boots the app; the tab shows `enIrError`).
  - CSS: `platform.css` is linked **before** `app.css` (portal `body`/`.btn`/tokens still win)
    so the IR gets its base classes (`.data-table`/`.form-control`/`.badge`/`.ir-*`/`.ed-*`); a
    small var bridge in `app.css` maps the platform var NAMES to GL's portal tokens so the grid
    renders in the GL green theme.
  - Verified: endpoint Open total reconciles to butil Total Encumbrance to the fils across 4
    filter combos (incl. YTD period) + 400/401 error paths; browser smoke 22/22 (component
    registered on the app KO, full segment grid renders, filter re-run, EN/AR/RTL with the IR
    toolbar localized, Budget Utilization tab unaffected by platform.css). APP_VERSION 1.25.0.
- **2026-07-14 — Butil "Figures in" display-unit selector (GL v1.24.0) + web-tier release
  `20260714151925`.** New **Figures in** field in the Budget Utilization Search region:
  Auto (B/M/K, the old compact default) | Billions | Millions | Thousands | Exact number.
  Display-only — switching re-renders instantly with NO re-query: `buUnit` observable
  (persisted in `localStorage('gl_bu_ui')` alongside the region-collapse state) +
  `buNum(n)` unit-aware formatter (locale grouping on the scaled value, e.g. `2,097.8M` /
  `2,097,828K` / full separated number for Exact) applied to the 4 KPI tiles + duo
  breakdown rows + collapsed-band summary + all 6 results-table money columns; exact-value
  tooltips (`money()`) unchanged; CSV export stays raw numbers. i18n `fUnitL`/`unit*`
  EN+AR. Frontend-only; APP_VERSION 1.24.0. Playwright verify 11/11 PASS (5 options, M/K/
  B/Exact renders match computed expectations, persistence across reload, Auto restore,
  no JS errors); webtier verified serving 1.24.0.
- **2026-07-14 — Butil KPI breakdown %-of-budget suffixes (GL v1.23.1) + web-tier release
  `20260714151110`.** Each breakdown row in the two composite Budget Utilization KPI tiles
  (Actual AP / Actual GRN under Total Actual; Commitment PR / Obligation PO under Total
  Encumbrance) now shows its **% of budget in brackets** after the amount, e.g.
  `Actual AP 1.04B (18.8%)`; the two sub-percentages sum to the tile's own "x% of budget"
  line. New `buPartPct(v)` helper in app.js + `.pp` muted suffix span on the 4 rows
  (css `.bk-duo-row .pp`). Frontend-only; APP_VERSION 1.23.1. Playwright verify 3/3 PASS
  (suffix format, reconciliation to tile %, no JS errors); webtier verified serving 1.23.1.
- **2026-07-14 — Web-tier release `20260714145511` pushed** (`SSH_USER=opc bash
  webtier/deploy_frontend.sh 129.151.159.189`): GL v1.23.0 (Actuals parameters drawer +
  grouped KPI cards; butil multi-select filters + consolidated KPI tiles) live; verified
  `APP_VERSION` 1.23.0 + the new `.kgrid`/`.mchips-bar`/`.dw-filter` CSS and
  `buChapterParam`/`acFilterDrawer`/`buEncumbTot` JS served from https://129.151.159.189/.
- **2026-07-14 — Actuals parameters drawer + grouped KPI cards; butil MULTI-SELECT filters +
  consolidated KPI tiles (GL v1.23.0, DEPLOYED + E2E 24/24).** User review round:
  1) **Actuals filter drawer** — the inline filter card moved into a big right-edge drawer
     (`.dw-filter`, min(720px,94vw); Apply/Reset/Cancel in the header + a bottom Apply, Esc
     closes) opened by a page-head **Filters** button with an active-criteria count badge;
     the page shows a clickable applied-criteria chip bar (`.ac-chipbar`, period always first).
  2) **Actuals KPI redesign** — the 14 flat `.kstat` tiles became 6 grouped measure cards
     (`.kgrid`/`.kg-*`): Budget (+GL-actual utilization bar), Commitment (PR) Total/Open/Pipeline,
     Obligation (PO) Total/Open/Pipeline, Open Encumbrance (Open PR + Open PO), GL Actual
     (GRN / AP Direct / SLA), Funds Available GL/Calc (+% remaining, red when over budget).
  3) **Butil multi-select Chapter / Cost centre / Project** — picks become chips in a labelled
     bar under the filter grid (`.mchips-bar`; × removes); requests carry a **pipe-delimited
     exact any-of list** while a single free-typed value keeps contains-match. `GL/db/07`
     re-run: `/butil` + `/butil/lines` predicates are pipe-aware everywhere (INSTR pattern,
     params widened to VARCHAR2(2000)); `GL/db/11` re-run (put() 500→2000); the BOOK seed's
     l_bscope/l_scope predicates updated in lock-step (`reporting/db/21`) so a multi-filtered
     Briefing Book matches the page.
  4) **Butil consolidated KPI band** — 6 tiles → 4: Budget | **Total Actual = AP + GRN** |
     **Total Encumbrance = Commitment (PR) + Obligation (PO)** | Fund Available. The two
     composite `.bk-duo` tiles show a stacked composition bar + two drillable breakdown rows
     (colour-dotted AP/GRN and PR/PO, each opens its `openBuAgg` drawer); totals reconcile
     exactly (verified 2.098B = 1.040B + 1.058B on live data).
  Also re-verified the "all figures zero" complaint on Actuals: data-side it was already fixed
  by the 2026-07-13 canonical flip (db/v2/48) + snapshot refresh — live page-1 rows now carry
  real PR/PO figures (E2E asserts non-zero Commitment/Obligation on page 1).
  **DEPLOY GOTCHA (repeat offender)**: `reporting/db/21` ran "clean" from Linux SQLcl but the
  MERGE-bearing PL/SQL block was SILENTLY SWALLOWED (source_ref unchanged, updated_at stale).
  Recovery = a small-line PL/SQL surgery block that REPLACEd the six predicate fragments inside
  the stored `source_ref` CLOB (+ `IS JSON` guard) — verify with an INSTR count (21 pipe-INSTRs)
  and `updated_at`. The 21 script itself stays the source of truth for Windows/worker re-runs.
  E2E: Playwright 24/24 (drawer open/apply/badge/Esc, KPI groups, non-zero rows, drill modal,
  4 tiles + reconciliation, chapter+CC chips, multi search 1,365→1,272 rows, chip remove,
  AP breakdown drill). APP_VERSION 1.23.0.
- **2026-07-14 — Web-tier release `20260714053705` pushed** (`SSH_USER=opc bash
  webtier/deploy_frontend.sh 129.151.159.189`): GL v1.22.0 (Briefing Book = full page-filter
  parity) live; verified `APP_VERSION` + the new `runBuBook` payload served from
  https://129.151.159.189/.
- **2026-07-14 — Briefing Book now honours ALL page filters (GL v1.22.0, DEPLOYED + verified).**
  User review: the book ignored most page parameters. Now `runBuBook` sends the FULL butil
  filter set — Year, **Period (YTD)**, Project type, Sector, **Chapter**, Cost center, **Project,
  Task, Expenditure type, Search** — and the report applies them with the page's exact predicate
  semantics (sector/chapter/type exact; cc/project/task/etype/search contains-match, project on
  number OR name), so the book always equals the page. Pieces: `db/11` bridge forwards the new
  params + validates `period` (MM-YYYY within year → 400); `reporting/db/21` seed rebuilt (all
  9 binds in every section, line sections join `dct_butil_scope_v` on the FULL fact key
  project+task+etype, GRN register rebased to the page's receipt-date year basis, param spec +
  LOVs for chapter/etype); `db/v2/39` scope view + `chapter`/`expenditure_type` cols and the
  AP/PO/PR line views honour `GL_CTX.BUTIL_END` (same date bases as 37's fact CTEs; unset =
  unchanged); runner MULTI spec gained **`pre_sql`/`post_sql` hooks** (set/ALWAYS-clear the
  period context — the worker session is reused across runs); template cover/Part-bands/insights
  print the applied scope and the pacing clock stops at the period end. **Also fixed a real
  over-count**: ATD `po_headers`/`po_lines` attribute joins in the registers multiplied amounts
  on duplicate rows (76 dup po_lines keys → GRN +35.5M, PO +59M platform-wide) — all 39/21
  attribute joins now de-duped (the same fan-out rule 07's drills already follow). Verified:
  SQL reconcile **20/20 PASS** (register Σ = Part-1 KPI to the fils across 5 filter combos incl.
  YTD periods), bridge E2E run 67 (Tourism + 06-2026: every KPI tile = the page's `/butil`
  totals, cover chips + 50%-elapsed pacing correct, bad-period 400s), browser smoke ALL PASS
  (default current-month period + sector flow from the UI into the PDF). Deploy: 39+21 via
  python-oracledb on vm180, `datasource.py` to vm180-182 + worker restarts, GL/db/11 via SQLcl,
  template re-upload via ORDS.
- **2026-07-14 — Web-tier release `20260714045940` pushed** (`SSH_USER=opc bash
  webtier/deploy_frontend.sh 129.151.159.189`): GL v1.21.0 (Briefing Book button) + BI 1.10.4
  live; verified `APP_VERSION` + `runBuBook` served from https://129.151.159.189/.
- **2026-07-14 — Briefing Book button on Budget Utilization (GL v1.21.0 + `db/11_gl_butil_book_ords.sql`,
  DEPLOYED + E2E PASS).** Any GL user can now generate the Reporting-Platform **BUDGET_UTIL_BOOK**
  executive PDF (reporting/db/21 — cover/contents/overview/actuals/open-PO/open-PR/insights)
  straight from the page: new GL-gated bridge endpoints `POST /gl/butil/book` (enqueues via
  `dct_rpt_pkg.enqueue` as the calling user, params = the page's Year/Sector/Project-type/
  Cost-center filters), `GET /butil/book/:id` (status, BUDGET_UTIL_BOOK-only) and
  `GET /butil/book/:id/pdf` (authed download) — the `/rpt/` admin endpoints stay SYS_ADMIN-only,
  and the render happens on the normal reporting worker fleet. Frontend: primary **Briefing Book**
  button in the page head (tooltip explains which filters apply), 6s status polling with a
  "Preparing book…" busy label, auto-download as `Budget_Utilization_Briefing_Book_<year>.pdf`.
  **Re-run list after any 05 re-run is now 07 + 08 + 09 + 10 + 11.** API tests: 401 / 400-no-year /
  enqueue→SUCCESS→download (Tourism-scoped run 63, 1,159 lines, 516 KB). Browser smoke ALL PASS
  (button → busy → toast → real download, no JS errors). Same round: the book's timestamps now
  carry the timezone — "…AM **GST (UTC+04:00)**, Asia/Dubai" on the cover, contents footer and
  insights footer (template re-uploaded to DCT_RPT_TEMPLATE — no worker redeploy).
- **2026-07-11 — Web-tier release `20260711234246` pushed** (`SSH_USER=opc
  webtier/deploy_frontend.sh 129.151.159.189`): ships GL **v1.16.0** (Accounting-period YTD
  filter) + v1.15.0 (loading states) to production users. Smoke through nginx: APP_VERSION
  1.16.0 served, app.js 200 with the new features present, `/ords/admin/gl/butil?period=` routes
  (401 unauthenticated as expected). Commits `94e1075` (period filter) + `83ff41b`
  (document-inquiry views db/v2/43–47) pushed to origin/main.
- **2026-07-11 — PO document views, all four levels (`db/v2/46_po_views.sql`, DB-only, DEPLOYED + verified).**
  End-user views over the ATD purchase-order tables: **`PO_HEADER_V`** (one row per PO — full
  descriptive info + statistics: line/schedule/distribution counts, project+task counts &
  project-number/task-number lists (task_count = distinct task numbers, `#id` fallback for
  ids missing from the tasks master, so count always equals the list), PR count/numbers from
  **two sources** [backing `po_distributions.pr_number` +
  `invoiced_pr_*` via `ap_invoice_distributions.requisition`], AP invoice count / matched amount /
  gross amount / pro-rated paid + per-invoice Paid/Partial/Unpaid counts + invoice numbers, GRN
  receipt count/amount/numbers, GRN-netted **open_obligation_aed** [0 when header Finally Closed],
  %-received/%-invoiced/%-paid), **`PO_LINES_V`**, **`PO_SCHEDULES_V`**, **`PO_DISTRIBUTIONS_V`**
  (charge-account COA classification via `dct_cc_canon`→`dct_gl_coa_snap`, project/task/exp-type
  names, PR reference, GRN + AP rollups per distribution). Conventions inherited: PO AED =
  `distribution_amount × NVL(rate,1)`; GRN AED = `ledger_amount`; AP AED = FUNCTI convention;
  every view de-dups by natural key on `load_ts` (po_lines carries real dups: 3,011 rows / 2,935
  ids). **AP amounts attributed to a PO are the MATCHED distribution portion** — invoice header
  totals overstate (live case: 49.7M invoice with only 12.4M matched to its PO); the linked
  invoices' full totals are exposed separately as `ap_invoice_gross_amount_aed`, and
  `ap_paid_amount_aed` = matched × the invoice's paid ratio (capped 0..1). Verified: 0 INVALID;
  row counts = 2,129/2,935/2,936/3,031; header open-obligation total = actuals layer
  `open_obligation_ytd` (07-2026) to 4 fils; AP matched total = raw dists exactly; GRN total =
  `grn_all_v2` raw; Finally-Closed PO 451102004832 shows 0 open obligation. Rerunnable; depends
  on db/v2/32/33/40.
- **2026-07-11 — Budget Utilization Accounting-period (YTD) filter + GRN accounted-date basis
  (v1.16.0, DB + frontend, DEPLOYED + verified).** New **Accounting period** dropdown next to
  Budget Year (Full year + the 12 MM-YYYY months of the selected year; **defaults to the current
  period**, e.g. 07-2026, when the selected year is the current year — first load, Reset, and
  year-change; ⓘ hint on label + select: "Year-to-date: figures include 1 January through the end
  of the selected period. Budget stays annual."). Semantics = **YTD through the period end**; the
  row set stays budget-driven (annual budget, HAVING budget>0) — only the measures shrink.
  Mechanics: `DCT_GL_CLASS_PKG.set_butil_end/clear_butil_end` write
  `SYS_CONTEXT('GL_CTX','BUTIL_END')` (03_gl_pkg.sql); `db/v2/37` fact CTEs (f_ap/f_grn/f_pr/f_po
  **+ the grn_per_dist PO-netting**) gained `(BUTIL_END IS NULL OR date < end+1)` bounds — unset
  context = unchanged full-year behavior for every existing consumer (hourly job, db/v2/39 pack).
  `/gl/butil` accepts `period=MM-YYYY` (400 unless the month belongs to `year`), sets the context
  before its two queries and **always clears it after + in the exception handler** (pooled ORDS
  sessions); `/gl/butil/lines` takes the same `period` as **inline date bounds** on all four
  metric queries incl. the PO netting so row/card drill totals keep reconciling. **GRN date basis
  switched to `NVL(ACCOUNTED_DATE, TRANSACTION_DATE)`** (user rule: accounting date first) in the
  view year attribution + drill filters + drawer Date column — the column was **just added to
  ATD_GRN_ALL_V2**, so deploy started with `prod.dct_views_rebuild` (16 views re-expanded) to
  expose it; currently accounted=transaction on all 2,259 rows so FY figures are unchanged
  (verified: FY GRN still 1,057,258,560.95). Deploy order: rebuild → 03 → 37 (one session) → 07
  (fresh session); 0 INVALID. Frontend: `buPeriod`/`buPeriodOpts` (client-generated months),
  default logic in load/Reset/year-change, flows through `buParams` (report/pager/CSV) +
  `openBuDrill`/`openBuAgg`; drawer eyebrow shows "YTD MM-YYYY". APP_VERSION 1.15.0 → **1.16.0**.
  Verified E2E vs PROD: default 07-2026; Full-year totals byte-identical to pre-change; YTD
  03-2026 = AP 921.2M / GRN 344.6M / PR 86.0M / PO 177.5M (matches SQL smoke); GRN KPI drill and a
  row GRN drill both reconcile exactly under the period; Reset/AR-RTL pass.
- **2026-07-11 — Professional loading states: skeleton table + branded loader (v1.15.0, frontend-only).**
  Every data-load slot upgraded from the bare 16px `.spin` dot. **Budget Utilization results
  table** now shows **8 shimmer skeleton rows × 17 column-aligned cells** (`.sk-row`/`.sk`,
  `skRows`/`skCols` VM arrays, `<!-- ko if: buLoading -->` swap in the tbody) + an
  **indeterminate teal→gold sweep bar** (`.ldbar`) under the Results region header + a **busy
  Search button** (`.btn.busy` inline spinner, Reset disabled). All other load slots — Actuals
  table, Dashboard, Classifications values, Explorer combinations, both drill drawers + the
  Actuals drill modal (`.ldr.sm` compact) — use the new **branded loader** `.ldr`: the GL gold
  diamond pulsing inside twin counter-rotating teal/gold arcs + i18n "Loading data…" with
  staggered animated dots (`loadingData` EN/AR). `prefers-reduced-motion` slows all loader
  animations. The two small in-button spinners (Rebuild/Refresh) intentionally keep `.spin`.
  APP_VERSION 1.14.0 → **1.15.0**. Verified live vs PROD with Playwright route-throttling
  (5–6s delay on /butil*): skeleton 8×17 + sweep bar + busy button while loading, clean swap to
  100 real rows after; branded loader visible in the drill drawer mid-flight then 1000 rows; all
  5 views navigated with 0 page errors. No DB change.
- **2026-07-11 — Open Obligation excludes 'Finally Closed' POs (DB-only, DEPLOYED + verified).**
  Fusion releases the remaining reserved funds when a PO is
  **finally closed**, but the PO **distributions keep their old `funds_status`**
  (Reserved/Partially Liquidated) — so the un-received remainder kept counting as Open Obligation
  (example PO `451102004832`: ordered 3,600,000.22, GRN received 879,515.24, header STATUS
  'Finally Closed' → 2,720,484.98 wrongly held as open). Fix: every open-obligation expression now
  also requires **header `ATD_PO_HEADERS.STATUS <> 'Finally Closed'`** (via a grouped
  `po_hdr_status` CTE or `NOT EXISTS` on `prod.po_headers`). Measured impact at deploy time:
  **2,738,255.44 AED across 4 distributions / 5 finally-closed POs** leaves Open Obligation (and
  Open Encumbrance; Funds Available Calc / butil Fund Available rise by the same amount).
  Total PO and PO Pipeline are unchanged (the order still happened). 'Canceled' POs need no rule —
  their distributions lose the Reserved status. Touched: `db/v2/34` (period view — open_obligation,
  open_encumbrance + funds_available_calc derive), `db/v2/37` (butil view obligation_po +
  fund_available), `db/v2/39` (`DCT_OPEN_PO_LINES_V` → BI report pack section 5 self-corrects),
  `GL/db/05` (source sync only — do NOT re-run), `GL/db/07` (butil PO drill, both row-cell and
  KPI-card agg mode), `GL/db/10` (actuals/lines `openobligation` rows + total). Deploy order:
  `db/v2/34` → `37` → `39` (one session) → `GL/db/07` + `GL/db/10` (fresh session; both additive,
  no 05 re-run needed). Verified in PROD 2026-07-11: `DCT_OPEN_PO_LINES_V` = 0 Finally-Closed
  rows; example butil row (4511000283 / Utilities-N / 423931) obligation 1,707,735.07 (the
  2,720,484.98 remainder gone, fund available now +2,455,467.26); 07-2026 platform Open
  Obligation 458.4M / Open Encumbrance 919.5M; 0 INVALID objects.
- **2026-07-11 — Web-tier release `20260711203106` pushed** (`SSH_USER=opc
  webtier/deploy_frontend.sh 129.151.159.189` from Git Bash): ships GL v1.14.0 (all three
  same-day waves — filter LOVs + KPI answer band + regions/maximize) + the pending v1.11.0 drill
  Export CSV. Smoke through nginx: index/app.js/app.css 200, APP_VERSION 1.14.0 served, new
  `/ords/admin/gl/butil/lov` routes (401 unauthenticated as expected). Commits `6cecdc6` (GRN
  ledger_amount fix) + `5028cc1` (butil UX waves) pushed to origin/main.
- **2026-07-11 — Budget Utilization page regions + table maximize (v1.14.0, frontend-only).**
  The page is now organized into three **brand-headed regions** (`.bu-sec` / `.bu-sec-h` — teal
  gradient header bar, white uppercase title, echoes the platform region theming):
  **Search** (the filter grid, collapsible), **Overview** (the KPI answer band, collapsible) and
  **Results** (the table + pager, maximizable). Collapse: chevron header click (`toggleBuSec`),
  rotates closed (RTL-flipped), state **persisted per browser** in `localStorage('gl_bu_ui')`;
  while collapsed the header shows a live summary — Search: "<year> · N active filters"
  (`buSearchSummary`/`buActiveFilters`; the DCT OPEX default counts), Overview: "Budget X · Fund
  available Y" (`buKpiSummary`). Maximize: ⤢ button in the Results header (`buMax`/`toggleBuMax`)
  turns the region into a **full-screen fixed surface** (z-index **55** — deliberately BELOW the
  drill drawer 70/71, modal 60 and toast 80 so cell/KPI drills still open above it); flex column =
  header / scrollable `.tbl-wrap` (sticky thead works inside) / pinned pager; body scroll locked;
  button flips to ⤡; **Esc restores** — guarded to do nothing while a drawer/modal is open.
  Pager toolbar moved off inline styles to `.toolbar.bu-pager`. 6 new i18n keys (`buSecSearch`/
  `buSecOverview`/`buSecResults`/`buFiltersActive`/`buMaxT`/`buRestoreT`). APP_VERSION 1.13.0 →
  **1.14.0**. Verified live vs PROD (dev-proxy + Playwright): collapse/summaries/persist-across-
  reload, maximize = exact viewport + scroll lock, drill drawer opens above the maximized table,
  Esc guard then restore, EN + AR/RTL headers. No DB change.
- **2026-07-11 — Budget Utilization KPI answer band redesign (v1.13.0, frontend-only).** The six
  totals cards are now a **visually distinct answer band** (new `.bu-kpis`/`.bk-*` styles, scoped to
  Budget Utilization — the Actuals/Dashboard `.kstat` strips are untouched): per-measure gradient
  tint + 4px accent spine + rounded **icon chip** (inline stroke SVGs: database/invoice/package/
  clock/clipboard/shield) + big Fraunces value in the measure color + a **%-of-budget context
  line** + a **mini utilization bar**. Budget tile shows the filtered row count ("N budget
  lines"); Fund Available shows "% of budget remaining" and flips the whole tile red (`.neg`,
  `--bad`) with "over budget" when negative (bar clamps to 0). New VM helpers `buPct`/`buBarW`/
  `buPctTxt`/`buFundSub` (all derived from `buTotals()` so they re-render reactively) + i18n keys
  `buLinesLbl`/`buOfBudget`/`buRemaining`/`buOverBudget`. The 4 drillable tiles keep the
  lift + ⤢ affordance (`.bk-click`). Responsive columns 6→3→2→1 (breakpoints 1500/920/560px) so
  rows never orphan a tile. APP_VERSION 1.12.0 → **1.13.0**. Verified live vs PROD (dev-proxy +
  Playwright): bars sum to ~100% with Fund Available (19.4 AP + 19.7 GRN + 8.6 PR + 8.6 PO + 43.6
  remaining), AP tile drill total = KPI figure exactly, simulated negative fund renders red
  "over budget", EN + AR/RTL both clean (spine/chip/bar flip via inline-start). No DB change.
- **2026-07-11 — Budget Utilization filter LOVs + DCT OPEX default (v1.12.0, DB + frontend).**
  Four new **autocomplete LOV filters** on the Budget Utilization search bar — Cost Center
  (option label = department), Project (option value = number, dropdown label = name;
  contains-match on number OR name), Task, Expenditure Type — implemented as native
  `<datalist>` pickers (same pattern as the Classifications segment picker), plus **Project
  Type now defaults to `DCT OPEX Project Type`** on first load and after Reset (falls back to
  All types if the value ever disappears from the LOV). DB (`07_gl_budget_util_ords.sql`,
  re-run whole script, fresh session): NEW `GET /gl/butil/lov?year=` returns the four distinct
  lists per budget year (51 CCs / 523 projects / 309 tasks / 81 e-types for 2026); `/gl/butil`
  gained `costcenter`/`project`/`task`/`etype` contains-match params (count + items + totals);
  `/gl/butil/lines` aggregate (KPI-card) mode gained the same four as
  `costcenter`/`fproject`/`ftask`/`fetype` (f-prefixed — `project`/`task`/`etype` are the
  row-drill key params) in all four metric `kys` CTEs, so card drills keep reconciling to the
  filtered KPI figures. Frontend: `buCc`/`buProject`/`buTask`/`buEtype` observables +
  `loadBuLovs()` (re-fetches when `buYear` changes), filters flow through `buParams()` (report,
  pager, CSV export) and `openBuAgg()` (drill + context line); Enter-to-search on every input;
  `buReset()` restores the OPEX default. APP_VERSION 1.11.0 → **1.12.0**. Verified E2E against
  PROD (dev-proxy + Playwright): default type applied (1,355 = exact OPEX row count), LOV counts
  match DB, CC filter 43 rows all-matching, partial project name "IMEX" resolves, task+etype
  narrow to 1 row, KPI GRN card drill total 104,725.2464 = on-screen KPI exactly, Reset restores
  default.
- **2026-07-10 — GRN drill drawers sorted by GRN # + Line (DB-only).** Both GRN drill queries now
  display rows ordered by `receipt_number, receipt_line_number` instead of amount-desc (butil) /
  date-desc (actuals). The row-cap SELECTION is preserved by wrapping: the inner query still keeps
  top-1000-by-amount (butil, so the "top N of M" cap note stays true) / most-recent-500 (actuals),
  and only the outer SELECT re-orders for display — pattern `SELECT * FROM (… ORDER BY … FETCH
  FIRST n ROWS ONLY) ORDER BY receipt_number, line_no`. Side benefit: correction rows (negative
  re-receipts of the same GRN #) now sit adjacent to their original. Changed `07` (butil grn) +
  `10` (actuals grn; source synced into `05`); redeployed 07 + 10 (fresh sessions, compile clean);
  verified via SQL replica on project 4511000943 (14 lines, receipt-ascending, corrections
  adjacent). No frontend change.
- **2026-07-10 — Export CSV on every drill-down surface (v1.11.0, frontend-only).** New shared
  `drillExportCsv()` in `Jet/js/app.js` + **Export CSV** button in BOTH drill headers: the Actuals
  drill **modal** (`.modal-h`, before Cancel) and the Budget Utilization slide-in **drawer**
  (`.dw-h`, buttons grouped in new `.dw-acts` flex wrapper — `.dw-h` is space-between, so ungrouped
  buttons would spread). Serializes the server-driven `drillCols`/`drillRows` as-loaded (raw
  values, quote-escaped, UTF-8 **BOM** for Excel-safe Arabic supplier names) + a Total
  reconciliation footer row; filename `gl_drill_<title>_<sub>.csv`; button hidden while loading or
  when 0 lines. `openDrill` now clears `drillSub`/`drillCtx` (they were only set by the butil
  drawer and would leak a stale subtitle into the modal's export filename). APP_VERSION 1.10.0 →
  **1.11.0**. Verified: `node --check` + Playwright mocked-ORDS smoke (drawer + modal: button
  renders, download fires, CSV headers/rows/quote-escaping/Total row correct; 0 console errors).
  No DB/ORDS change.
- **2026-07-10 — GRN AED amounts: LEDGER_AMOUNT replaces TRANSACTION_AMOUNT × CONVERSION_RATE (DB-only).**
  Root-caused a negative Fund Available (−226K on project 4511000943 / Partnership Fees): the GRN
  extract's `TRANSACTION_AMOUNT` is **already the AED (ledger) figure** (doc amount × rate at
  source — verified against PO 451102006219 = EUR 23,000 → GRN txn 97,956.06 = 23,000 × 4.258959),
  so multiplying by `CONVERSION_RATE` **double-converted every FX receipt** (EUR ×4.26, USD ×3.67;
  platform GRN total was 1.79B vs the true 1.065B). All GRN AED expressions now read
  `ledger_amount` (equal to txn×rate on AED rows, the correct AED on FX rows; `SLA_LEDGER_AMOUNT`
  is unusable — uniformly 3× from a source-join artifact). Changed: `db/v2/32` (DCT_ACTUAL_V GRN
  branch + DCT_BUDGET_ACTUAL_V grn_agg + currency-contract header comment), `db/v2/34` (grn_ytd +
  grn_per_dist netting), `db/v2/37` (f_grn + grn_per_dist), `db/v2/39` (uninvoiced-GRN +
  open-PO-netting views), `07_gl_budget_util_ords.sql` (butil grn drill rows/total/filter + PO
  open netting), `10_gl_actuals_lines_docnum.sql` + source-synced `05_gl_ords.sql` (actuals grn
  drill + openobligation netting), and the two docs analysis queries. Deploy order: 32→34→37→39
  (one fresh session) → 07 → 10 (own sessions); recompile pass → 0 INVALID. Verified: sample row
  GRN 854K→212,489, Fund Available −226K→+416,248; DCT_ACTUAL_V GRN total 1,065,124,042.55 =
  Σ ledger_amount. No frontend change (drawer amounts are server-computed).
  **Gotcha: never multiply `grn_all_v2` amounts by `CONVERSION_RATE`** — see Gotchas below.
- **2026-07-08 — Butil GRN drawer: + PO #, PO Line, Supplier (DB-only) + web-tier release.**
  The Budget Utilization "Actual GRN — receipts" drawer now also traces each receipt to its PO:
  `07_gl_budget_util_ords.sql` grn metric gained `po`/`poLine`/`supplier` columns (de-duped
  `po_headers`/`po_lines` joins via `grn_all_v2.po_header_id`/`po_line_id`, same pattern as the
  PO drawer). Redeployed 07 (fresh session); no frontend change. Also pushed web-tier release
  `20260708225930` via `webtier/deploy_frontend.sh` (no APP_VERSION bump — no frontend files
  changed; ORDS changes are live through the nginx `/ords/` proxy regardless).
  Verified through BOTH the ADB URL and `https://129.151.159.189/`: project 4511000854 GRN drill
  → 3 receipts, all PO 451102006105 line 1 supplier BEST MOMENTS EVENTS L.L.C, total 20,549,700
  reconciles; aggregate mode 1000 rows with 0 missing PO #.
- **2026-07-07 — Drill-down drawers: document number + line, no zero-amount lines (DB-only).**
  User request: every drill-down drawer identifies rows by **document number + line number**
  (AP invoice #/line, GRN #/line, PR #/line, PO #/line) instead of transaction-id-looking values,
  and hides zero-amount lines. No frontend change (drawer columns are server-driven) —
  APP_VERSION stays 1.10.0.
  - `07_gl_budget_util_ords.sql` (re-run whole, fresh session) — `GET /gl/butil/lines`, all four
    metrics, both row + aggregate modes: **ap** + `Line` (`ap_invoice_distributions.line_number`);
    **grn** relabelled `GRN #` + `Line` (`grn_all_v2.receipt_line_number`); **pr** + `Line`
    (`pr_lines.pr_line` via de-duped `pr_line_id` join); **po** already had PO #/Line. Zero-amount
    filters: ap/grn/pr `amount <> 0`, po `open > 0` (fully-received lines vanish). Zeros add
    nothing to SUM, so **drill totals still reconcile** to the row/card figures.
  - NEW `10_gl_actuals_lines_docnum.sql` — **ADDITIVE, DEFINE_HANDLER-only** upgrade of
    `GET /gl/actuals/lines` (source synced into 05): **apdirect** drawer showed the raw
    **`invoice_id` transaction id** — now the real AP invoice number (de-duped `ap_invoices`
    join, `#id` fallback) + invoice line + zero-amount filter; **grn** drawer relabelled `GRN #`
    + receipt line. Other actuals metrics untouched (PO drawers already show PO #/Line; the PR
    drawer aggregates at PR-header grain by design).
  - Verified: SQLcl reconciliation harness — all 4 butil drills PASS (drill total == row figure,
    0 zero rows, 0 null lines); live HTTP smoke as NASER.ALKHAJA **31/31 PASS** (agg + row modes
    reconcile; apdirect 0 id-fallbacks; actuals grn sample receipt 4513075482 line 1).
- **2026-07-06 — PR/PO charge-account format fix (`prod.dct_cc_canon`, db/v2/40).** The 2026-07-05
  ATD reload flipped `CHARGE_ACCOUNT` on `ATD_PR_DISTRIBUTIONS`/`ATD_PO_DISTRIBUTIONS` to the same
  **re-ordered dot format** that hit `ATD_GL_BALANCES` on 07-02 — every charge_account↔COA join
  matched ZERO rows (PR 0/4,559, PO 0/2,783), so the Actuals report showed **Commitment (PR) and
  Obligation (PO) all zeros** (user-reported). Fix = **`prod.dct_cc_canon(cc)`** function with
  format auto-detection (dash = legacy → dots; dot w/ 7-digit token#2 = already canonical;
  6-digit token#2 = program-first re-ordered feed → re-order) — self-heals if a future reload
  flips back. **RULE: every `charge_account` ↔ COA join/key goes through `prod.dct_cc_canon`**
  (GL_BALANCES keeps the pure-SQL `GL_BALANCES_CC` view).
  - Re-pointed: `db/v2/36` (PR view cc), `db/v2/32` (`DCT_ACTUAL_V` ap_po_match/PO/GRN branches +
    `DCT_BUDGET_ACTUAL_V` spine/po_agg/grn_agg), `db/v2/34` (grn_ytd + po_base), `db/v2/37`
    (po_dist + f_pr attribute cc), `05_gl_ords.sql` (8 drill filters + 3 dashboard snap joins) —
    then 05 republished + 07 + 08 re-run per the rule.
  - Verified: canon unit test (all 3 forms); PR 4,547/4,559 + PO 2,782/2,783 matched; 07-2026
    report rows carry Commitment 1,940.3M / Open 448.3M / PO 1,514.8M / Open 475.3M with sectors;
    drill + dashboard queries return rows; butil 2026 totals intact AND **sector coverage now
    100%** (canon fixed the transaction-based sector fallback); 19 templates; 0 invalid objects.
    No frontend change (APP_VERSION stays 1.10.0).
- **2026-07-05 — Classifications assignments drawer (v1.10.0).** Clicking a row on the
  Classifications values table opens an **extra-wide (1120px) right-edge drawer** with that value's
  full assignment list — segment code + dimension description, editable start/end dates + notes,
  CURRENT/PAST/NEW chips — with top-right **+ Add / Close / Save** buttons. Add = new row with a
  datalist segment picker (`/segments/:key/values`, description auto-fills); Save = sequential
  POST (new) / PUT (dirty) with overlap errors surfaced in a drawer error bar; per-row ✕ deletes.
  - ORDS: `09_gl_class_drill_ords.sql` — **ADDITIVE, DEFINE_HANDLER-only** upgrade of
    `GET /gl/mappings`: `?valueid=` filter + `segmentDesc` per row (GL_SRC_* dimension matched on
    the normalized segment value; live coverage 214/216). Source is **synced into 05**, so a full
    05 re-run already carries it — 09 exists to deploy without republishing the module. NB the
    platform gotcha: `ORDS.DEFINE_TEMPLATE` on an existing template silently DROPS its other
    handlers — 09 deliberately never calls it (POST /mappings verified surviving).
  - Frontend v1.10.0: row click + `clickBubble:false` on the row Edit/Delete buttons; `.dw-xw`
    wide-drawer modifier + `.dw-h .btn.solid` (inverted Save) + `.dw-err` + `.clsdw-tbl` styles.
  - Verified: handler live-run (CULTURE → its 13 assignments with descriptions), POST handler
    intact, `node --check` clean, Playwright mock-render PASS (open → +Add → desc autofill →
    Save → Close; 0 console errors).
- **2026-07-02 — Rebuild-views button (v1.9.0) + GL balances feed format fix (GL_BALANCES_CC).**
  Two things: a UI recovery button for structural ATD reloads, and an incident fix it immediately
  surfaced — the reloaded `ATD_GL_BALANCES` lost its dimension columns (`COST_CENTER`/`ACCOUNT_CODE`/
  `GL_COMBINATION`/`FUNDS_AVAILABLE`…) AND its `CONCATENATED_SEGMENTS` came back dot-separated in a
  **different segment order** (`entity.program.cost_center.budget_group.account.entity_specific.`
  `appropriation.intercompany.future1.future2`) — every gl_balances↔COA join silently matched ZERO
  rows (Actuals Budget/GL-Actual/Funds-GL figures empty).
  - DB: `db/v2/38` **`prod.dct_views_rebuild`** (re-creates the 16 `SELECT *` pass-throughs over
    `ATD_*`, calls `dct_actuals_refresh` [snapshot + 2-pass recompile], returns rebuilt count + any
    views still INVALID; +`GRANT CREATE VIEW TO PROD` — definer-rights needs the direct grant).
    `db/v2/32` adds **`GL_BALANCES_CC`** — the ONE canonical remap of the re-ordered
    `CONCATENATED_SEGMENTS` (legacy dash format still accepted); `DCT_ACTUAL_V` GL branch +
    `DCT_BUDGET_ACTUAL_V` re-pointed. `db/v2/34` `gl_ytd` re-pointed. `04_gl_views.sql`
    `DCT_GL_BALANCES_V` rewritten (dimensions via `DCT_GL_COA_V` on `GL_BALANCES_CC.cc_string` —
    **re-run 32 before 04**). Dropped orphaned live-only draft `DCT_PROJECT_BUDGET_V` (referenced
    long-gone `PROJECT_BALANCES`).
  - ORDS: `08_gl_views_rebuild_ords.sql` — **ADDITIVE** `POST /gl/actuals/rebuild` (+ ADMIN synonym
    `dct_views_rebuild`, fresh session). `05_gl_ords.sql` had 9 direct
    `REPLACE(concatenated_segments,'-','.')` joins (drill budget/encumbrance/glactual + dashboard
    bySector/byProgram/byAppropriation) — all re-pointed to `gl_balances_cc.cc_string` and the whole
    module re-published (then 07 + 08 re-run per the rule). **After any 05 re-run, re-run 07 AND 08.**
  - Frontend v1.9.0: **Rebuild views** button (Overview + Budget Utilization page heads) with tooltip
    hint + confirm — "use only after a reload that changed table structure; plain reload → Refresh
    actuals"; toast lists views still invalid (= script edit needed).
  - Verified: rebuild proc live-run (16 rebuilt, invalid none); GL figures restored — 07-2026 Budget
    17,181.2M / GL Actual 1,728.1M / Funds GL 9,955.4M; balances match 9,508/10,351 vs COA (843
    combos absent from the `ATD_GL_CODE_COMBINATIONS` extract — source-side gap); `/balances` view
    9,508 with cost-centre / 9,464 with sector; endpoint registered; `node --check` clean.
- **2026-07-02 — Budget Utilization KPI-card (aggregate) drill-down (v1.8.0).** Follow-up to v1.7.0:
  the user expected the prominent **KPI cards** (Actual AP / GRN / Commitment PR / Obligation PO) to be
  clickable, not just the table cells. Now both are: cards drill the **whole filtered set** (aggregate),
  table cells drill the single row. DEPLOYED as ADMIN (`sql` ADMIN@prod_high, fresh session) — VALID.
  - ORDS `07_gl_butil_ords`: `/gl/butil/lines` now takes `year+metric` with EITHER `project[+task+etype]`
    (row) OR `projecttype/sector/search` (card aggregate). ONE `kys` key-set CTE (`SELECT … FROM dual
    WHERE :project IS NOT NULL UNION ALL SELECT … FROM dct_budget_utilization_v WHERE :project IS NULL
    AND <filters>`) drives both; fact totals via `COUNT/SUM OVER ()` windows (rows capped 1000, total/count
    full). Response adds `aggregate` + `count`. **Fan-out fix:** the PO branch's `po_headers`+`po_lines`
    joins and the PR branch's `pr_headers` join are now de-duped via grouped subqueries — a raw join
    inflated aggregate PO (30.9M vs true 25.19M) when a PO line had duplicate header/line rows.
  - Frontend v1.8.0: `openBuAgg(metric)` + `.kstat-click` cards (hover ⤢ + dotted underline) + `drillCount`/
    `drillCapNote` ("showing top N of M"); aggregate drawer adds Project/Task columns + filter context.
  - Verified against LIVE data (ADMIN): row totals ap 43,966/grn 1,059,704/pr 200,734/po 972,771 and
    aggregate (sector=Culture) ap 50,030,599/grn 130,050,118/pr 107,576,885/po 25,188,034 ALL reconcile
    to the card/row figures; handler compiled clean; both endpoint modes route (401 unauth); drawer
    Playwright-verified (card→aggregate w/ cap note, cell→row).
- **2026-07-02 — Budget Utilization figure drill-down (v1.7.0).** The four money figures on each
  Budget Utilization row (Actual AP / Actual GRN / Commitment PR / Obligation PO) are now clickable
  and drill to their supporting transaction lines in a **right-edge slide-in drawer** (mirrors the
  platform edit-drawer template; brand-themed, RTL-aware). Each drill total reconciles exactly to
  the row figure.
  - ORDS: `07_gl_budget_util_ords.sql` — **ADDITIVE**, new `GET /gl/butil/lines?year=&project=&task=&etype=&metric=`
    (metric `ap|grn|pr|po`). Filters/amounts replicate the `DCT_BUDGET_UTILIZATION_V` fact CTEs
    (db/v2/37) keyed by the same grain (year × project_number × task_number × expenditure_type, all
    charge accounts). **`ap`** = no-PO validated invoice distributions (invoice #, date, vendor,
    currency, invoice amount, distribution AED, validation, **derived payment status** from
    `invoice_amount_paid`, description); **`grn`** = receipts; **`pr`** = Reserved PR distributions;
    **`po`** = Reserved/Partially-Liquidated PO distributions, **GRN-netted open** amount.
    **Run as ADMIN in a fresh SQLcl session** (`sql -name prod_mcp @07_gl_budget_util_ords.sql`) —
    ORDS modules are ADMIN-owned; re-run 07 again if `05_gl_ords.sql` is ever re-run.
  - Frontend v1.7.0: `openBuDrill(row, metric)` → `.dw-*` drawer (new CSS in `app.css`, markup in
    `index.html`), reuses the existing drill observables; four `.money-cell` cells + header hint
    tooltips. `node --check` clean; drawer visually verified via Playwright (mocked API): brand
    header, eyebrow=project·name, context=task·expenditure type, 9-col AP table, total reconciles.
  - Verified against live data (PROD, as user `prod`): all four drill totals reconcile to a real
    2026 row (AP 43,966 / GRN 1,059,704 / PR 200,734 / PO 972,771); handler body compiled + ran as
    a throwaway PROD procedure (APEX_JSON scaffolding clean) — final ORDS registration still needs
    the ADMIN deploy above.
- **2026-07-02 — Budget Utilization page (v1.6.0) + self-healing refresh + PROJECT_NUMBER type fix.**
  New project-costing report: ONE row per Budget Year × Project × Task × Expenditure Type
  (budget > 0 only), **Budget Year is a mandatory filter**. Budget from the new
  `ATD_PROJECTS_BUDGET` extract; AP/GRN/open PR/open PO year-scoped by their dates;
  Fund Available = Budget − AP − GRN − Open PR − Open PO. Sector via the DEFINED SECTOR map from
  the task's `COST_CENTER`; Appropriation/Program from `ATD_TASKS`; Chapter via the CHAPTER map.
  - DB: `db/v2/37` `DCT_BUDGET_UTILIZATION_V` (re-run `db/v2/32` FIRST so `projects_budget`/`tasks`
    pass-throughs expose `BUDGET_YEAR` + task `COST_CENTER`); `db/v2/33` `dct_actuals_refresh` now
    also **recompiles INVALID PROD views** (2 passes) — hourly job + both Refresh buttons self-heal
    after ATD reloads (NB: recompile only; a `SELECT *` base view still needs a 32/36 re-run to
    EXPOSE new columns). Also in `db/v2/32`: `DCT_ACTUAL_V` ORA-01790 fix after
    `ATD_PROJECTS.PROJECT_NUMBER` became VARCHAR2 ('T4514' Trust numbers).
  - ORDS: `07_gl_budget_util_ords.sql` — **ADDITIVE** to gl.rest (`GET /gl/butil/filters`,
    `GET /gl/butil?year=` [400 without year]). **If `05_gl_ords.sql` is ever re-run (it
    DELETE_MODULEs gl.rest), re-run 07 right after it.**
  - Frontend v1.6.0: new **Budget Utilization** nav page — mandatory Budget Year select (default =
    latest), Project Type/Sector/Search filters, 6 totals cards, 17-column table, CSV, pagination.
  - Verified: view VALID (2026: 1,352 rows / 5,277.4M, full-year aggregate 1.4 s), templates
    registered, handler queries live-run, `node --check` clean.
  - Known data gaps (source-side, tracked in `docs/budget_utilization_missing_data.md`): 73 lines
    without Sector (tasks missing `COST_CENTER`), 13 lines without Chapter (unmapped appropriations
    50723/50729/50730/0).
- **2026-07-02 — Actuals: 3-figure Commitment/Obligation + Open Encumbrance + Funds calc (v1.5.0, Batch B).**
  Real requisitions now drive Commitment; PO obligation split into three funds-status buckets with a
  GRN-netted Open Obligation. Grouped-cell display.
  - DB: `db/v2/36` `DCT_PR_COMMITMENT_PERIOD_V` → 3 figures (`pr_total_ytd`=Reserved+Liquidated,
    `pr_open_commitment_ytd`=Reserved, `pr_pipeline_ytd`=Not-reserved, `pr_count`). `db/v2/34`
    rewritten: PO de-duped by `po_distribution_id` → `total_po_ytd` (all except Failed/Passed),
    `open_obligation_ytd` = (Reserved+Partially Liquidated) **netted by GRN** `GREATEST(amt−Σgrn,0)`
    (grn via `grn_all_v2.po_distribution_id`), `po_pipeline_ytd` (Failed/Passed); LEFT JOIN the PR
    view; `open_encumbrance_ytd` = open commitment + open obligation; `funds_available_calc_ytd` =
    Budget − Open PO − Open PR − GRN − AP Direct (GL `funds_available_ytd` kept as the 2nd figure).
  - ORDS (`05_gl_ords.sql`, whole module, fresh session — **no new synonyms**, all `prod.`-qualified):
    `/actuals` emits prTotal/openCommitment/commitmentPipeline/totalPo/openObligation/poPipeline/
    openEncumbrance/fundsAvailable/fundsAvailableCalc; `/actuals/lines` — commitment/openCommitment/
    **commitmentPipeline** → real PR lines (`pr_distributions`+`pr_headers`, AED via `DCT_CURRENCY_CODES`),
    obligation/**poPipeline** → PO lines, openObligation → GRN-netted (Ordered/Received/Open columns).
  - Frontend v1.5.0: **grouped cells** — Commitment & Obligation each show Total/Open/Pipeline stacked
    (count on the Total row), Funds Available cell shows GL/Calc; +Open Encumbrance column; 14 KPI cards.
  - Verified: view VALID + figures reconcile (PR 1.89B/412.7M/4.71B, PO 1.52B/474.0M/2.1M, OpenEnc
    886.7M); drill queries ran live; `node --check`; Playwright mock-render (0 console errors).
    Deploy order: `db/v2/36` → `db/v2/34` → `05_gl_ords.sql` (fresh session).
  - **Currency caveat:** non-AED PR distributions are converted via the `DCT_CURRENCY_CODES` snapshot
    (manual ISO master, single RATE_DATE 19-May-2026) — the only rate source (PR tables carry none).
    Pending user check of whether PR line details include a rate.
- **2026-07-01 — PR reporting views created (Batch B step 1 — DB only, not yet integrated).**
  New `db/v2/36_dct_pr_views.sql`: base pass-throughs `prod.pr_headers`/`pr_lines`/`pr_distributions`
  (over the `ATD_PR_*` tables) + **`DCT_PR_COMMITMENT_PERIOD_V`** (per GL combination × period,
  YTD via `BUDGET_DATE<period-end`, AED via the `DCT_CURRENCY_CODES` snapshot rate — the PR tables
  carry NO transaction rate). Measures (06-2026): `pr_commitment_ytd` = `FUNDS_STATUS='Reserved'`
  (currently-reserved requisitions) = 412.7M; `pr_open_commitment_ytd` = Reserved & PR line has no
  PO (disjoint from Open PO) = 369.4M; `pr_count`/`open_pr_count` = distinct PR headers. Excludes
  `'Not reserved'` drafts (4.75B) AND `'Liquidated'` (already POs → shown under Obligation). All VALID.
  **NOT yet wired into `DCT_BUDGET_ACTUAL_PERIOD_V` / ORDS / frontend** — next step: #3 repoint the
  commitment source, #4 Encumbrance = Open PR + Open PO, #6b calculated Funds Available.
- **2026-07-01 — Actuals: AP Direct redefine + SLA Actual + PO/PR counts (v1.4.0).** (User comments
  batch A of 6; #3/#4/#6b pending the user's PR_HEADER/PR_LINES/PR_DISTRIBUTIONS tables.)
  - **#1 AP Direct** now = AP distribution lines with **`po_number IS NULL`** (true direct AP, no PO
    reference), replacing the old "unmatched-to-`po_distributions`" logic (dropped the `ap_po_match`
    CTE in `db/v2/34` `ap_ytd` + the inline match subquery in the `apdirect` drill). Live impact:
    06-2026 YTD AP Direct 1.322B → **1.292B** (the delta = AP lines that carry a po_number but don't
    match a PO distribution — now excluded).
  - **#2 SLA Actual** ("Subledger Actuals") = GRN Actual + AP Direct (≈ 2.27B). Emitted by `/actuals`
    (`slaActual` in totals + items); new KPI card + non-drillable table column + ⓘ hint.
  - **#5 PO/PR counts:** `DCT_BUDGET_ACTUAL_PERIOD_V` gained `po_count` (distinct po_header_id) +
    `pr_count` (distinct pr_number) per combination; `/actuals` items emit `poCount`/`prCount`; the
    Obligation/Commitment cells show the amount with a count sub-line ("N POs" / "N PRs"). PR count is
    interim from `po_distributions` until the dedicated PR_* tables arrive (#3).
  - Deploy order: `db/v2/34` → `05_gl_ords.sql` (fresh session, no new synonyms). Verified: view VALID,
    AP Direct drill query ran live (no ORA errors), `node --check`, Playwright mock-render (0 errors).
- **2026-06-30 — Actuals report: Open Commitment / Open Obligation + visible hint (v1.3.0).**
  - DB: added `open_commitment_ytd` + `open_obligation_ytd` to `DCT_BUDGET_ACTUAL_PERIOD_V`
    (`db/v2/34`) — the **unliquidated** subset of obligation/commitment = PO distribution lines
    whose budget is still encumbered (`FUNDS_STATUS IN ('Reserved','Partially Liquidated')`),
    de-duped per natural key (the amount/`SCHEDULE_UNBILLED_AMOUNT` columns are unreliable in
    this Fusion load, so "open" is driven by FUNDS_STATUS, not ordered−billed). Verified VALID;
    06-2026 open = 723.08M (both), ⊆ commitment 1.504B ⊆ obligation 1.510B.
  - ORDS (`05_gl_ords.sql`, whole module, fresh session — no new synonyms): `/actuals` emits
    `openCommitment`/`openObligation` in `totals` + `items` and accepts them as `source` filter
    values; `/actuals/lines` gains `openCommitment` (→ open PR lines) and `openObligation`
    (→ open PO lines) drill metrics (same columns as commitment/obligation, FUNDS_STATUS-filtered).
  - Frontend (v1.3.0): 2 new KPI cards (Open Commitment / Open Obligation) + 2 new drillable
    table columns; the four PO-derived headers (Commitment/Obligation/Open Commitment/Open
    Obligation) now show a **visible ⓘ hint marker** (`.hint-i`) carrying the explanatory tooltip
    (kept the existing "Commitment (PR)" / "Obligation (PO)" wording); 2 new source-filter options;
    CSV includes the open columns.
  - Verified: view VALID + open figures match probe; all new handler queries executed live against
    PROD (no ORA errors); `node --check`; Playwright mock-render of Actuals + Open-Obligation drill
    + Dashboard (0 console/binding errors). Deploy order: `db/v2/34` → `05_gl_ords.sql` (fresh session).
- **2026-06-30 — Actuals report: Commitment/Obligation + extra filters + full width (v1.2.0).**
  - DB: added `commitment_ytd` (PR-backed PO distribution lines) + `obligation_ytd` (all PO
    distribution lines) to `DCT_BUDGET_ACTUAL_PERIOD_V` (`db/v2/34`), read live from
    `po_distributions` (de-duped per natural key; `gl_balances.OBLIGATIONS` is 0 in this Fusion
    config so POs come from `po_distributions`; commitment = the PR-backed subset of obligation).
  - ORDS (`05_gl_ords.sql`, re-run whole module, fresh session — no new synonyms):
    `/actuals/filters` now also returns `accounts` + `costCenters` LOVs; `/actuals` gains
    `account`/`costcenter`/`source` filters and emits `commitment`/`obligation` in totals + items;
    `/actuals/lines` gains `commitment` (→ PR lines) and `obligation` (→ PO lines) drill metrics.
  - Frontend (v1.2.0): Actuals + Dashboard pages now use the full viewport width (`.wrap.wide`);
    3 new search criteria (Account, Cost center, Transaction source); 2 new KPI cards + 2 new
    drillable table columns (Commitment / Obligation) with header hints; CSV includes them.
  - Verified: view VALID + commitment⊆obligation (1.504B ⊆ 1.510B, 06-2026); all new handler
    queries executed live against PROD (no ORA errors); `node --check` + KO comment balance.
    Deploy order: `db/v2/34` → `05_gl_ords.sql` (fresh session).
- **2026-06-30 — Actuals reporting + Executive dashboard (v1.1.0).** New **Actuals** (Budget vs
  Actual) and **Dashboard** pages over the actuals reporting layer (`db/v2/32–35`):
  - DB: added `appropriation_code`/`_desc` to `DCT_BUDGET_ACTUAL_PERIOD_V` (`db/v2/34`); new hourly
    job `DCT_ACTUALS_REFRESH_JOB` for `prod.dct_actuals_refresh` (`db/v2/35`).
  - ORDS (`05_gl_ords.sql`, re-run whole module, fresh session): `/actuals/filters`, `/actuals`,
    `/actuals/lines`, `/dashboard`, `POST /actuals/refresh` + 9 new ADMIN→PROD synonyms
    (period view, snapshot, refresh proc, base AP/PO/GRN/GL views).
  - Frontend: Actuals report (mandatory period + Sector/Chapter/DCT-Program/Appropriation filters,
    business-question answer cards, full-width table with header hints + combination tooltip + row
    hover, per-figure drill-down modal, Search/Reset, CSV); Executive dashboard (utilisation gauge,
    period-over-period trend, by sector/program/appropriation bars, auto-insights — all hand-built
    SVG/CSS, no chart lib); **Refresh actuals** button on Overview/Actuals/Dashboard.
  - Verified: live SQL probes + handler JSON harness against PROD; Playwright mock-render of both
    pages + drill (0 console/binding errors). Deploy order: `db/v2/33` (snapshot, if not present) →
    `db/v2/32` → `db/v2/34` → `db/v2/35` → `05_gl_ords.sql`.
- **2026-06-28 — Initial release (v1.0.0).** All layers deployed + verified end-to-end (Playwright).
  COA view 9,338 rows (no fan-out), 91% sector-classified. Registered in switcher + i18n.

## Gotchas (GL-specific)
- **'Finally Closed' POs keep stale `funds_status` on their distributions** (2026-07-11): Fusion
  releases the un-received remainder of a finally-closed PO back to budget, but
  `po_distributions.funds_status` stays 'Reserved'/'Partially Liquidated'. Any open-obligation /
  open-encumbrance / funds-available expression MUST also exclude header
  `po_headers.STATUS = 'Finally Closed'` (dup-safe: grouped `MAX(status)` CTE or `NOT EXISTS`).
  Header status lives ONLY on `ATD_PO_HEADERS.STATUS` ('Open', 'Closed', 'Closed for Receiving',
  'Finally Closed', 'Canceled', …) — 'Closed'/'Closed for Receiving' do NOT release funds; only
  'Finally Closed' does. 'Canceled' needs no rule (distributions lose Reserved status).
- **GRN amounts are already AED — use `LEDGER_AMOUNT`, never × `CONVERSION_RATE`** (2026-07-10;
  **CORRECTED 2026-07-11**): the OTBI CSV proved the ATD loader maps `TRANSACTION_AMOUNT` ← OTBI
  **"Ledger Amount"** (the true doc-currency "Transaction Amount" never reaches ATD), which is why
  the DB column is "already AED". BUT OTBI Ledger Amount = **k × true** (k = # charge-class
  receipt-accounting lines; SLA = (k+2) × true): clean rows k=1 (SLA/Ledger=3, 2,161 rows);
  **defect k=3 (SLA/Ledger=5/3) on 54+3 rows / 45 distributions = 7,865,481.59 AED overstated**
  (e.g. project 4511001235's −438K fund). `sla_ledger_amount` itself is never usable. ROOT FIX
  (pending): extract OTBI's true Transaction Amount into ATD, then GRN AED = `txn × NVL(rate,1)`
  again; detect bad rows via `ROUND(sla_ledger_amount/ledger_amount,2) NOT IN (3,-3)`. Contrast:
  `po_distributions.distribution_amount` IS doc-currency and DOES need `* NVL(rate,1)`; AP uses
  `NVL(distribution_amount_functi, distribution_amount)` — documented in `db/v2/32` header.
- **`GL_SRC_*` synonyms** are the only thing that knows the base table is `ATD_GL_*`. On the
  planned rename to `GL_*`, re-run `01_gl_synonyms.sql` with the new targets — nothing else changes.
- **Description-list fan-out:** the Fusion list tables contain duplicate codes (e.g. program `0` =
  "Unspecified"/"Un specified", used by 5,605 combinations). `DCT_GL_COA_V` de-duplicates every
  description join with `GROUP BY` — never join the raw list tables 1:1 or the grain explodes.
- **Segment widths (zero-pad):** entity 3, cost-center 7, account 6, appropriation 6, **program 6**.
  Segments are stored `NUMBER` (lossy) so the view/map normalize via `DCT_GL_CLASS_PKG.norm`.
- **Program ↔ PBB:** codes differ (`10100` vs PBB `070100`); mappings are matched by *description*,
  not arithmetic. 33 of 35 used program codes matched.
- **Parallel DML:** the seed sets `ALTER SESSION DISABLE PARALLEL DML` (consecutive MERGEs on a
  parallel-enabled table → ORA-12839).
- **As-of:** `DCT_GL_CLASS_PKG.set_asof(date)` then SELECT the view; the `/combinations?asof=` and
  `/balances?asof=` handlers set/clear the `GL_CTX` context per request.
- **2026-07-13** — Budget Utilization **Chapter filter**: `GL/db/07` re-run — `/butil/filters`
  adds `chapters[]`, `/butil` + `/butil/lines` take `chapter=` (exact match, applied in every
  spot the sector predicate appears incl. all lines-metric CTEs so KPI-card drills still
  reconcile); frontend Chapter dropdown in the butil Search region (report/pager/CSV/aggregate
  drills all flow through buParams). APP_VERSION 1.17.0. NOTE: 07 was LF-only in the repo —
  re-normalised to CRLF for Linux SQLcl deploys.
- **2026-07-13** — Butil drill drawer UX: default width 940 → `min(1360px,96vw)` (`.dw-wide`)
  + full-screen toggle ⤢/⤡ in the drawer header (`.dw-full` = 100vw; Esc restores first,
  close resets). Classifications drawer (.dw-xw) untouched. APP_VERSION 1.18.0.
- **2026-07-13** — Butil page-busy overlay: Oracle-JET-style indeterminate progress circle
  (`oj-progress-circle` replica — neutral track + brand arc, Material dash sweep) over the
  Overview+Results regions (`.bu-body`/`.bu-load-ov`/`.ojpc`, z 30 below maximize/modal/drawer)
  shown on the butil initial load (NEW `buFiltersLoading` covers `/butil/filters`) AND on every
  `/butil` search/pager run (`buBusy` = filters OR rows loading). Search region stays usable;
  skeleton rows/ldbar/busy button kept beneath the frosted scrim. APP_VERSION 1.19.0.
- **2026-07-13** — **GL segment codes zero-padded everywhere** (user-reported: butil showed
  Appropriation `50729` instead of `050729`): `ATD_TASKS.COST_CENTER/APPROPRIATION/PROGRAM`
  are NUMBER, so bare `TO_CHAR` drops leading zeros and the COA-description + chapter-map
  joins silently miss. Fixed `db/v2/37` (butil view), `45_tasks_v`, `47_projects_v` — every
  task segment attr is now `LPAD(TO_CHAR(x), <width>, '0')` (cost centre 7 / appropriation 6 /
  program 6, matching the platform segment widths). DEPLOYED + verified: all 1,373 butil-2026
  appropriations 6-digit, `050729/050730` rows get desc + Chapter 2 (50730 had NO chapter
  before), only `000000 - Un Specified` remains unmapped; 0 INVALID. GL/db/05's segment LOV
  was already safe (`dct_gl_class_pkg.norm`). RULE: any new view reading ATD task/project
  segment attributes must LPAD to the segment width — never bare TO_CHAR. (Files also
  CRLF-normalised: 37/45/47 were LF-only = silently skipped by Linux SQLcl.)
- **2026-07-13** — **Canonical GL-combination rule enforced platform-wide** (user directive):
  every view/table that exposes a combination string MUST use the COA canonical order
  `entity(3).cost_center(7).account(6).appropriation(6).budget_group(1).entity_specific(7).
  future1(6).future2(6).intercompany(3).program(6)` — exactly `DCT_GL_COA_V.cc_string` /
  `prod.dct_cc_canon` output; never the re-ordered Fusion feed/display order
  (entity.program.cc.bg.acct.es.appr.ic.f1.f2). Audit result: COA view, GL_BALANCES_CC,
  COA snap, actuals/butil/PR/AP fact views already canonical; FIXED `PO_DISTRIBUTIONS_V.
  charge_account` (db/v2/46 — was raw feed) and AP `poChargeAccount` (AP/db/04); NEW
  `db/v2/48` migrated `DCT_GL_CODE_COMBINATIONS.cc_code` (was 9-seg Fusion order) to the
  10-seg canonical virtual column incl. new `intercompany_code` ('000' default; db/v2/12
  updated for fresh installs; TRG_DCT_GL_UPD recompiled). Verified: zero non-canonical
  strings in PO_DISTRIBUTIONS_V / COA snap / AP outputs; 0 INVALID. RULE for new work:
  any exposed charge_account/combination column goes through `prod.dct_cc_canon`.
- **2026-07-13 (same day, order FLIPPED after user confirmation)** — the canonical
  combination order is the **FUSION sequence**: `entity(3).program(6).cost_center(7).
  budget_group(1).account(6).entity_specific(7).appropriation(6).intercompany(3).
  future1(6).future2(6)` — exactly as the Fusion UI shows a distribution combination
  (the earlier entry's old COA order is obsolete). The WHOLE derivation chain flipped
  together so every join stays consistent: `prod.dct_cc_canon` (db/v2/40 — now returns
  the feed as-is when token#2 is 6-wide and re-orders OLD-canonical/dash strings),
  `DCT_GL_COA_V.cc_string` (GL/db/04), `GL_BALANCES_CC` (db/v2/32 — feed passes through,
  legacy forms re-ordered), `DCT_GL_COA_SNAP` (refreshed), `DCT_GL_CODE_COMBINATIONS.
  cc_code` (db/v2/48 re-run; guard is order-aware — NOTE `all_tab_columns.data_default`
  is LONG: fetch it plain into a PL/SQL VARCHAR2, SQL SUBSTR on it = ORA-00932).
  Verified: butil totals unchanged (budget 5.54B / AP 1.04B / GRN 1.06B), balances↔COA
  match 10,102/10,961 (~92%, same as pre-flip), AP glCombination matches the Fusion UI
  string byte-for-byte, 0 INVALID. RULE: keep the three cc_string producers in lock-step;
  new views wrap feed charge_accounts with `prod.dct_cc_canon`.
- **2026-07-13 (Fusion deep-links in butil drill drawers, v1.20.0)** — Invoice/PO/PR
  numbers in the Budget Utilization drill drawer (all four metrics, both row-cell and
  KPI-card drills) now open Oracle Fusion in a new tab via the SHARED
  `shared/js/fusionLinks.js` (made **UMD** this round: AMD for the JET-shell apps +
  `window.FusionLinks` global for portal-style plain-KO apps like GL — index.html loads
  it before app.js, app still boots if it 404s). DB: `GL/db/07` `/butil/lines` rows now
  carry the FUSION internal ids — `invoiceId` (ap metric), `poHeaderId` (grn + po
  metrics), `prHeaderId` (pr metric) — all from joins the queries already had. FE:
  `drillLink(row,col)` maps invoice/po/pr columns to deeplinks (`.fus-link` style, ↗);
  CSV export unchanged (numbers only). Deploy: 07 re-run (standalone-safe) + webtier
  release 20260713232809. APP_VERSION 1.20.0.

- **2026-07-19 — Security Console review round (GL side) — APP_VERSION 1.34.6:** the Page Security drawer now renders its artifact register in the SHARED `<interactive-report>` (report code `GL_SEC_PAGEINFO`, section per tab; drawer widened `.dw-wide`; envelope built client-side in `buildSecIr` with EN/AR labels). GL descriptions for all 14 GL privileges + duties/jobs/groups seeded platform-wide by `db/v2/103`. Smoke: drawer IR renders the overview page's 2 button artifacts with granted-to rollup, 0 JS errors.
- **2026-07-19 — Security Console adoption (first module) — APP_VERSION 1.34.4 (webtier release `20260719165634` LIVE):**
  GL/db/07/09/11/12/13 re-run with (a) a privilege gate after every 401 check —
  `prod.dct_sec.has_priv_or_role(l_user,'<PRIV>',NULL,'GL')` (NULL legacy role = the
  historical any-valid-session behaviour survives while `FEATURE_SEC_ENFORCE_GL`=N;
  flip to Y ⇒ privilege-only, SYS_ADMIN exempt, rollback = flip back — no deploy) and
  (b) the SECTOR data-security predicate on /gl/butil (both report+totals, 6 spots) +
  /gl/encumbrances + /gl/pending: `l_secok = 1 OR v.sector IN (value_code→name_en map
  of V_DCT_SEC_USER_SCOPE)`. Privileges per script: 07=GL_VIEW_BUDGET_UTILIZATION,
  09=GL_VIEW_CLASSIFICATIONS, 11=GL_RUN_BRIEFING_BOOK, 12=GL_VIEW_ENCUMBRANCES,
  13=GL_VIEW_PENDING_APPROVALS. Seeds in db/v2/102 (14 verb-first GL privileges, groups
  "Financial Planning and Reporting" + "GL Administration", duties GL_DUTY_FIN_REPORTING/
  CLASSIFICATION/DATA_OPS nested in jobs GL_ANALYST/GL_ACCOUNTANT, page+artifact registry
  for all 9 tabs). **The post-05 re-run list (07..13) now ALSO requires db/v2/99-102
  deployed first** (handlers reference prod.dct_sec/dct_sec_data). Frontend: SYS_ADMIN-only
  **Security Info** button at the end of the pnav (a `<button>`, NOT an `<a>` — the pending
  smoke asserts `nav.pnav a` count == 9) opening a `.dw-*` drawer over GET /dct/sec/pageinfo
  for the ACTIVE tab. Tests: GL/tests/sec_scope_smoke.py 10/10 (grandfather equivalence,
  sector scoping [scoped user sees ONLY their sector, totals reconcile], enforce flip 403,
  GL_ANALYST job role restores access, scope holds under enforcement) + drawer browser 7/7.

- **2026-07-21 — Actuals: Account Type column + filter, multi-select filters — APP_VERSION 1.39.0:**
  (1) `DCT_GL_COA_V` (GL/db/04) gains derived `account_type_code` (leading digit of the
  zero-padded account segment) + `account_type` name (1=Assets 2=Liability 3=Revenue
  4=Expense 5=Owner's Equity) — additive columns, no dependent breaks. (2) `/actuals` +
  `/actuals/filters` (GL/db/05): the six existing filters (Sector/Chapter/DCT-Program/
  Appropriation/Account/Cost-Centre) converted from single `=` to pipe-delimited **any-of**
  (`INSTR('|'||l_x||'|','|'||col||'|')>0`, the Budget-Utilization multi-select pattern) in
  BOTH the totals and items WHERE clauses (kept byte-identical so KPI⋈table reconciliation
  holds), plus a NEW `accounttype` multi param filtering on `SUBSTR(account_code,1,1)`;
  each item now emits `accountTypeCode`. Multi-value locals widened to VARCHAR2(400).
  (3) Frontend (GL/Jet): the six filter drop-downs became pick→chip multi-selects + a new
  **Account Type** multi-select, a removable-chip tray in the filter drawer, an **Account
  Type** table column, and Account Type in the CSV export; bilingual keys atAssets..atEquity/
  fAccTypeL/thAccType/allAccTypes. **DEPLOY: run GL/db/04 then GL/db/05 as ADMIN in a fresh
  session, then re-run the post-05 chain 07→13** (05 DELETE_MODULEs gl.rest); then webtier
  frontend deploy. Verified against PROD data (01-2026): all 5 account types present; totals
  reconcile; accounttype=4 ⇒ all GL Actual (93.83M) & PR/PO (20.23M) as expected.

- **2026-07-22 — Actuals Account Type is now MANDATORY, default Expense — APP_VERSION 1.39.1:**
  `acAccTypeSel` defaults to `['4']` (Expense) on load and on Reset; `runActuals` refuses an
  empty selection (`accTypeRequired` toast); the drawer chip tray won't remove the last
  account-type chip; drawer label marked ` *`. Frontend-only (no DB/ORDS change). Browser
  smoke 9/9 (default Expense loads, rows all Expense, chip bar + required marker, guard rails).

- **2026-07-22 — Actuals KPI-card drill-down (aggregate across the filtered set) — APP_VERSION 1.40.0:**
  Every KPI-band figure now drills to its supporting lines across the WHOLE filtered set,
  mirroring Budget Utilization's `openBuAgg`. DB: `GET /gl/actuals/lines` gained an AGGREGATE
  mode — when `cc` is omitted it accepts the full /actuals filter set (period + sector/chapter/
  program/appropriation/account/costcenter/accounttype/source/search, pipe-delimited any-of)
  and builds a `kys` CTE of the matching combinations, joining the raw line sources (grn/ap/po/pr)
  or the period view (budget/glactual/funds/fundscalc) to it; each drill leads with Cost-centre/
  Account/Combination context columns, is capped 500 with a true `count` (UI "top N of M"), and
  the window-SUM total reconciles EXACTLY to the KPI (verified: commitment/obligation/glactual/
  apdirect/budget/funds all to the dinar). The per-cell drill is unchanged (branch below `IF l_agg`).
  **Handler source now exceeds the 32767-char PL/SQL literal limit → split into two TO_CLOB-
  concatenated q'!…!' pieces (in BOTH 05 and 10; 10 is the authoritative definer in the re-run
  chain and keeps its own doc-number single-cc branches).** Frontend: `openAcAgg(metric)` opens the
  shared `.dw-*` drill drawer via the same `fillDrill`; 14 drillable figures wired (`.kg-drill`
  hover affordance); composite figures (Open Encumbrance main, SLA) drill via their components.
  Deploy = 04(unchanged) → 05 → 07..13 (10 carries the aggregate) → webtier. Browser smoke 8/8.

### 2026-07-22 — Reconciliation tab (Actuals ↔ Budget Utilization), GL v1.41.0
- **DB (db/v2/105_dct_gl_recon.sql)** — `DCT_GL_RECON_FACT_V` (AP/GRN/PR/PO bridge fact: both sides via `in_actuals`/`in_butil` + `bucket` = matched/no_project/ap_validation/no_budget_line; honours `GL_CTX.BUTIL_END` for period alignment) + `DCT_GL_RECON_GLBUDGET_V` (GL budget per period×combination + COA dims + account_type/chapter for Expense/CHx scoping). Deploy: `sql -name prod @105` (after 37). Verified the fact's Butil side equals live `DCT_BUDGET_UTILIZATION_V` totals to the riyal; bucket totals reconcile (AP no_project 342,753,920 · AP no_budget_line 647,994 · PR no_budget_line 8,270,309 · GRN/PO diff 0).
- **ORDS (GL/db/14_gl_recon_ords.sql)** — additive to `gl.rest`: `/recon/filters`, `/recon/summary`, `/recon/rows` (grain + optional measure), `/recon/drill` (bucket→source). Gated on `GL_VIEW_BUDGET_UTILIZATION` + SECTOR scope. **Post-05 re-run list is now 07..14.** GOTCHAS hit: (1) `raw` is a reserved word → CTE renamed `f_raw` (ORA-00903); (2) scalar subquery inside `APEX_JSON.write` = uncatchable 555 → `SELECT … INTO` first; (3) the setup proc needs its own `END setup_…;/` before the executor block (PLS-00103); (4) drill GRN/PR/PO must LEFT JOIN the COA snap (fact does) and source `cc_string` from the transaction, else unmapped combos (all of PR no_budget_line) vanish — and don't let the PR replacement also hit the AP branch (AP has no `charge_account`).
- **Frontend** — new `recon` tab in `GL/Jet/index.html` (+ `js/app.js` VM block + `css/app.css` `.rc-*`), APP_VERSION 1.40.0→1.41.0. Reuses the shared drill drawer for difference-to-source. Browser smoke `tests/recon_browser_smoke.py` 16/16 EN+AR/RTL (2 "failures" = pre-existing `js/i18n/app.*.json` 404s, unrelated).

### 2026-07-22 — App/tab renames + Chart of Accounts merge, FP v1.42.0 (frontend only)
- **Renames** (i18n in `js/app.js`): app `General Ledger` → **Financial Planning and Budgeting** (`appName`, `appSub`='FP', `<title>`); tab `Actuals` → **General Ledger** (`navActuals`; internal `view()==='actuals'` unchanged); `Budget Utilization` → **Project Budget Utilization** (`navButil`/`buTitle`).
- **Chart of Accounts** — Overview + Explorer merged into one page (`view()==='overview'`, nav `navOverview`='Chart of Accounts'); the standalone `explorer` view + nav entry removed. Content in two collapsible `.bu-sec` regions (`coaOvOpen`/`coaExpOpen`, `toggleCoa`); the combinations table is **maximizable** (`coaMax`/`toggleCoaMax`, reuses `.bu-results.maxed`, Esc restores — added `.bu-results.maxed .bu-sec-b` flex CSS since the content is wrapped in `.bu-sec-b`). Combos auto-load on landing + `go('overview')`.
- Frontend only, no DB/ORDS change. APP_VERSION 1.41.1→1.42.0. Browser-verified (renames + 2 regions + collapse + maximize) and recon regression 16/16.

### 2026-07-22 (2) — App-nav label + Classifications/Mapping merge into Chart of Accounts (FP v1.42.1 + shared i18n)
- **Module-switcher label (SHARED)**: `shared/i18n/common.{en,ar}.json` `mod.gl` "General Ledger" → **Financial Planning and Budgeting** (+ desc rewritten). The shell fetches `common.<lang>.json?v=APP_VERSION`, so **every app's APP_VERSION was bumped +1 patch** (Admin 4.7.9, AP 1.13.6, AR 4.7.16, ATD 1.23.14, BI 1.10.21, CC 4.5.33, DT 4.5.32, FL 4.18.16, GL 1.42.1, HR 4.6.28, PC 4.5.32, TM 4.9.13) to force the switcher to refetch — this is why the whole fleet is redeployed.
- **Classifications + Segment Mapping merged** into the Chart of Accounts page as Regions 2 & 3 (`coaClsOpen`/`coaMapOpen`, `loadCoa` loads all three sets once); their `view` ids + nav entries removed (`go()` redirects legacy ids → `overview`). Split the shared `loading` flag → `clsLoading` for the values table so it no longer cross-flickers with the Explorer table. Subscribe guards for `clsType`/`mapType` now fire on `view()==='overview'`.
- Frontend + shared-i18n only, no DB/ORDS change. Browser-verified (4 CoA regions, values + mapping load, nav trimmed); recon regression 16/16.

### 2026-07-25 — Exclude cancelled/soft-deleted '#'-surrogate IDs platform-wide (FP v1.42.6)
- **Rule (user):** any project/task/PR/PO id shown as a `'#'||id` surrogate (master row gone) = cancelled/soft-deleted → excluded on ALL pages & reports. User chose to also drop bare-`#` no-project spend. Predicate: project `NOT LIKE '#%'`, task `NOT LIKE '#_%'` (bare-`#` task KEPT = legit no-task/project-level line), invoice `#` fallback never fires (0 null invoice numbers).
- **Base views (CREATE OR REPLACE, re-runnable, 0 invalid):** `db/v2/105` recon fact, `db/v2/52` pending (PR+PO legs), `db/v2/37` butil (no-op today), `db/v2/39` 4 detail views, `db/v2/46` PO_HEADER_V (task aggregate drops `#`). Deploy order 37→39→46→52→105.
- **GL ORDS:** `/recon/drill` (db/14) inline WHERE added. `/butil` (07) + `/encumbrances` (12) auto-covered — they filter via `IN (SELECT ... FROM kys)` off the now-clean butil view. `/recon/summary|rows|budget` read the base views. Actuals/lines (05/10) invoice `#` never fires — untouched.
- **Reports:** BUDGET_UTIL_BOOK (reporting/db/21) + BUDGET_UTIL_REGISTER (25) GRN section outer WHERE now excludes `#`. MERGE-bearing ⇒ pushed to the LIVE `DCT_RPT_DEFINITION.source_ref` via a targeted `UPDATE ... REPLACE(source_ref,'...0.005) x WHERE 1 = 1','...NOT LIKE ...')` (small non-MERGE stmt, SQLcl-safe) + source files edited. 23/24/08a inherit base views.
- **Frontend:** recon Non-project tile / register column / donut segment hide when 0 (now always, since non-project is excluded).
- **Verified live (2026):** recon residual 0 all measures; consumption 4.19B→3.83B; noProject→0; orphan 8.78M→696K; coverage→~100%; pending/encumbrances/drills 0 `#`; butil unchanged. Browser 28/30 (2 pre-existing i18n 404). Webtier release 20260725174619. See memory [[project_hash_id_exclusion]].

### 2026-07-25 — Reconciliation: loading spinner + KPI hints + KPI drill-downs (FP v1.42.2 → v1.42.4)
- **v1.42.2 — loading spinner fix**: the `.bu-load-ov` (rotating oj-progress-circle, bound `visible:rcBusy`) is `position:absolute;inset:0` over `.bu-body`, but on first load both content sections (`rcSummary`/`rcLoaded`) are hidden so `.bu-body` collapsed to 0px and the overlay had nothing to fill → added `.bu-body.rc-loading{min-height:340px}` toggled by `rcBusy` (same pattern as the pending page's `.pn-loading`). Frontend only.
- **v1.42.3 — info hints (ⓘ)**: 16 `hRc*` bilingual hint keys on the 3 region headers, all 5 KPI tiles, both chart titles, and the 6 register columns (native-title `hint-i` pattern). Added a generic `.hint-i` base rule + a light variant for the brand-gradient region header. Frontend only.
- **v1.42.4 — KPI drill-downs (DB + frontend)**: every KPI tile figure now drills into the SHARED drill drawer.
  - **DB `GL/db/14` (re-run in place; post-05 list = 07..14)**: (1) extended `/recon/drill` to accept `measure=all` (unions AP+GRN+PR+PO — branch WHEREs `l_meas IN ('all','xx')`, adds a **Source** column; the drill output columns were already unified so this was a small change); (2) NEW `/recon/budget?side=gl|ppm` handler returning Budget·Consumed·Fund per project-line (ppm, `DCT_BUDGET_UTILIZATION_V` — cols are `PROJECT_NUMBER`/`TASK_NUMBER`, NOT project/task) or per GL combination (gl). **GL-side Fund FULL-OUTER-JOINs consumption to budget on `cc_string`** — a LEFT JOIN drops consumption on un-budgeted combinations and GL Fund won't reconcile (tile GL fund = GL budget − TOTAL consumption 4.19B); the FULL JOIN also surfaces un-budgeted spend as negative-fund rows. Deployed via SQLcl (`sql -name prod_mcp`, space-free path per the `@`-with-space gotcha) — no MERGE, compiled clean.
  - **Frontend**: `rcKpiDrill(bucket,titleKey)` (Coverage→matched, Non-project→no_project, Orphan→no_budget_line via `measure=all`) + `rcBudgetDrill(side,focus,titleKey)` (Budget/Fund GL & PPM sub-values; `focus` picks whether the reconciling drawer total is budget or fund). Tile figures rendered as `.rc-dl` drill links styled to match the original values. 10 new bilingual keys.
  - **Verified live (year 2026)**: all 6 drills reconcile to their tiles to the riyal — Coverage 3,822,322,605 · Non-project 350,546,765 · Orphan 8,781,748 · GL budget 7,577,576,961 (consumed 4,192,192,832 / fund 3,385,384,129) · Project budget 7,553,471,219 (consumed 3,822,322,605 / fund 3,731,148,613). Browser smoke 22/24 (2 = pre-existing shared-i18n 404 under dev-proxy).
- Webtier releases 20260725142721 (v1.42.2) → 20260725145450 (v1.42.3) → 20260725165107 (v1.42.4).

### 2026-07-27 — Missing-Cost-Centre red alert band + drill drawer on Project Budget Utilization (FP v1.43.0)
- **Trigger:** budget-only lines whose task has no `COST_CENTER` attribute in Fusion show Cost Centre/Sector "—" (root-caused same day on project 4511001117: the task master carried Appropriation+Program but no Cost Center; the update flowed automatically once maintained in Fusion — extract sweep every ~30 min, 08:00–16:00 Dubai). User rated the gap highly critical → a page-level alert.
- **ORDS (`GL/db/07` re-run, /butil handler only):** response now ALWAYS carries `missingCc` + `missingCcBudget` = count / annual-budget sum of the filtered rows with **annual budget ≠ 0 AND cost_centre IS NULL** (computed in the same single aggregate scan, so the flag covers the whole filtered set, not the page); new `nocc=Y` param filters the register to exactly those rows. Post-05 re-run list unchanged (07..14).
- **Frontend (GL/Jet, APP_VERSION 1.42.6→1.43.0):** `.bu-alert` red band (app.css: `--bad` accent spine, tinted gradient, hover lift, RTL-safe logical properties) rendered under the page head ONLY when `buMissCc() > 0` (set by every `runButil`); message = `{n}` lines + `{amt}` annual budget + the Fusion fix; whole band click-drills `openBuMissCc()` → the shared drill drawer over `/butil?nocc=Y` with the page's filters (Project/Name/Task/Etype/Department/Appropriation/Annual Budget; `drillTotalV` = `missingCcBudget` so the footer reconciles; CSV export free via `drillExportCsv`). 6 new bilingual i18n keys (`buMissCc*`).
- **Tests:** API 7/7 (missingCc fields, nocc row purity, sum reconciliation, filter interplay, regression) + browser `tests/butil_misscc_browser.py` 14/14 EN+AR/RTL (band visibility, red styling, drawer rows/count/total, band hidden at 0 missing, language restore). Live data at deploy: 2026 = 17 lines / 130.5M AED annual budget without a cost centre (all Museums-BU projects).

### 2026-07-27 (2) — Budget Override from Excel: Consider-Override flag + Override KPI + VB template repository (FP v1.44.0)
- **Requirement:** end users maintain a `BUDGET_USER` override per project-budget period row from Excel (Oracle Visual Builder Add-in over `/ords/admin/xl/`, db/v2/106–108); the GL Budget Utilization page gains a separate Override Budget KPI, a "Consider Override Budget = Y/N" parameter that swaps every budget figure to `NVL(budget_user, budget)`, an editable override drawer, and a template-download instructions region.
- **DB:** `GL/db/03` re-run (`set_butil_ovr`/`clear_butil_ovr` on `GL_CTX`) → `db/v2/37` re-run (pb CTE joins `DCT_PROJECT_BUDGET_USER`; `BUTIL_OVR='Y'` = effective budget; always-on `override_budget[_annual]`/`override_lines` columns appended LAST) → `GL/db/07` re-run (`ovr=` on `/butil` + `/butil/lines`; totals/rows gain override fields; budget drills gain an Override column; **the `/butil/lines` handler literal is at ~31.4K of the 32,767 hard cap — the next addition must split it, see reference_ords_handler_32k_split**) → NEW ADDITIVE `GL/db/15` (`GET /butil/override/lines` + `POST /butil/override`). **Post-05 re-run list = 07+08+09+10+11+12+13+14+15.**
- **Reports:** `GL/db/11` re-run — all three bridges forward `ovr`; `BUDGET_UTIL_BOOK`/`BUDGET_UTIL_REGISTER` `pre_sql` now also calls `set_butil_ovr(:ovr)` (+ `post_sql` clears) — applied to the LIVE definitions via CLOB REPLACE surgery AND synced into `reporting/db/21`+`25` seeds. Missing `ovr` param binds NULL = flag off (runner binds only referenced names).
- **Verified (curl 7/7):** override set via Excel API → `/butil` `ovr=N` budget unchanged + Override KPI totals correct → `ovr=Y` budget moves by exactly the override delta → drawer list totals (override vs fusion) → drawer edit + clear → baseline restored.
- **Gotcha (new, hit today):** chaining two `@script` includes in ONE SQLcl runner file silently skipped the second script — always deploy one script per `sql -name prod_mcp @runner` invocation and verify (user_ords_handlers) after.
- **Frontend verified + LIVE:** GL v1.44.0 (Consider-Override checkbox re-runs /butil in place; gold Override Budget KPI tile + editable `.dw-*` drawer over /butil/override/lines w/ POST save; "Budget Override from Excel" region w/ template download via /xl/templates/download) — regression smoke `tests/butil_misscc_browser.py` 14/14 + override feature checks 8/8; ATD v1.25.0 gains the **VB Templates** page (nav `xlTemplates`, manages the db/v2/108 repository). **Webtier release 20260728000216 LIVE.**

### 2026-07-28 — Override round 2: Reason Category + Comments + drawer how-to (FP v1.45.0)
- **User feedback round:** ① instructions belong ON TOP of the Override drawer table (branded `.ov-guide` panel: soft-green tint + gold accent, 3 how-to lines + "Download the Excel template" hyperlink → `downloadXlTemplate`); ② drawer widened (`.dw-ov` = min(1500px,96vw)); ③ TWO classification columns on `DCT_PROJECT_BUDGET_USER` — `reason_category` (lookup-first: NEW category **`XL_OVERRIDE_REASON`** seeded System issues / Request not received / Budget reallocation / Data correction / Other — manage in Admin → Lookups) + free-text `comments` (≤1000), both editable in the Excel VB template AND the drawer.
- **DB:** `db/v2/106` re-run (ALTER guard + lookup seed + view cols + `write_row`/`save_item` — reason validated via `dct_lookup_pkg.is_valid` → 400; PARTIAL semantics, only body keys applied; OpenAPI gains both fields, reason as a **dynamic enum built from the lookup**) + `GL/db/15` re-run (`reasons[]` LOV + `reasonCategory`/`comments` per item). curl 6/6.
- **Frontend (GL v1.45.0):** drawer guide panel + hyperlink, wider drawer, per-row Reason `<select>` (language-aware labels from `reasons[]`, unknown stored codes re-injected per the KO `options:` rule) + Comments input, save sends all four fields, CSV gains both columns; browser feature run 10/11 — the single "fail" was the test asserting against its own seed row while the drawer (correctly) showed the user's real row; **the save path was thereby proven on live data and the user's row restored afterwards** (5,000,000, reason/comments empty).
- **Workbook:** API/OpenAPI ready; the ACTIVE v1 workbook predates the columns — add Reason Category + Comments in the VBAFE Layout Designer (after a catalog metadata refresh) and upload/activate as **version 2** (guide §"Pending workbook update").
- **2026-07-28 (2) — VB add-in installer self-service (FP v1.45.1):** the VBAFE 5.0 current-user MSI is hosted in the template repository as code **`VBAFE_ADDIN`** (uploaded + activated; `db/v2/108` `upload_file` now derives MIME from the file extension so `.msi` streams as `application/x-msi`); "Add-in not installed?" download hyperlinks added to BOTH the "Budget Override from Excel" region and the Override drawer's how-to panel (`downloadVbAddin`, 2 i18n keys EN+AR). Browser-verified: links render + click fires the real MSI download. Webtier release 20260728083734.

### 2026-07-27 (2) — Budget Utilization Register: Related Invoices column on the GRN Receipts sheet (reporting/db/25 re-seed, no FE change)
- **User ask:** the `BUDGET_UTIL_REGISTER` Excel (butil page → Generate Report → Excel Register) sheet **"3. GRN Receipts"** now ends with a **Related Invoices** column — the AP invoice numbers matched to the same PO distribution as the receipt (the `invoiced_aed` set), comma-separated.
- **How:** the `l_grn` section's invoiced-AED subquery gains `LISTAGG(DISTINCT inv.invoice_number, ', ' ON OVERFLOW TRUNCATE)` via a **deduped (`GROUP BY invoice_id`) LEFT JOIN** to `prod.ap_invoices` — provably cannot drop or multiply rows, and old-vs-new aggregate regression confirmed byte-identical totals (2,413 rows, received 1,140,727,632.03 / invoiced 1,088,116,504.11 for 2026; 2,124 rows carry invoices).
- **Deploy:** db/25 is MERGE-bearing → executed the seed block via python-oracledb on vm180 (`config.connect()` wallet helper), then verified `source_ref IS JSON` + column present. E2E: run 166 via `POST /gl/butil/xlsx {year:2026}` → SUCCESS, workbook sheet 3 header ends "Related Invoices", multi-invoice rows render "62023, 62596, 63138, …". reporting/db/21 (PDF book) untouched — the book's GRN register keeps its columns.

### 2026-07-28 — GRN drill drawer: full register-parity columns + wider drawer (FP v1.46.0 + GL/db/07 re-run)
- **User ask:** the Budget Utilization "Actual GRN — receipts" drill drawer now carries EVERY column of the BUDGET_UTIL_REGISTER "GRN Receipts" sheet, and the drawer is wider.
- **ORDS (`GL/db/07` /butil/lines, metric=grn):** aggregate mode adds `projectName` + `etype` after Project/Task; BOTH modes add per-PO-distribution `invoicedAed` / `uninvoicedAed` (dist-level received − invoiced, same year/period window as the row) and `relatedInvoices` (LISTAGG DISTINCT invoice numbers via the register's deduped pk mapping + `prod.ap_invoices` header join, ON OVERFLOW TRUNCATE). **`amount` stays the LAST column** so the drawer's reconciling total footer lands under it; drill total still equals the page Actual GRN KPI (verified to the fils, 1,142,616,925.13 YTD 07-2026). AP/PR/PO/budget metrics untouched.
- **32K CAP:** the /butil/lines handler literal was 31,414 chars; the additions pushed it to 34,883 → **split into TWO `TO_CLOB(q'!…!')` concatenated literals** (split at the `ELSIF l_metric = 'pr'` boundary — the reference_ords_handler_32k_split fix). Any future edit to this handler must keep both parts under 32,767.
- **Frontend (APP_VERSION 1.45.1→1.46.0):** `.dw-wide` widened `min(1360px,96vw)` → **`min(1680px,97vw)`** (GL app.css; all wide drill drawers benefit). No JS change — drawer columns are server-driven.
- **Tests:** API 11/11 (column set/order, populated values, comma-lists, KPI reconciliation, row-drill + ap-metric regression) + headless browser 4/4 (drawer 1680px, Related Invoices/Project name/Expenditure type rendered, 509 multi-invoice cells). Deployed: 07 fresh-session SQLcl + webtier release 20260728091031.

### 2026-07-28 (2) — Related Invoices = Fusion deep-links (FP v1.47.0 + GL/db/07 re-run)
- **User ask:** each invoice number in the GRN drill's Related Invoices column opens the invoice in Fusion.
- **ORDS (07, grn metric):** rows ship a hidden `relatedInvPairs` field — pipe-separated `invoice_number~invoice_id` pairs (second LISTAGG DISTINCT over the concatenated pair; **LISTAGG DISTINCT only allows ORDER BY the measure expression itself**, so ids can NOT be aggregated in display-number order as a parallel list — pairs are the workaround). Not a declared column, so the grid/CSV keep numbers only. Handler split parts now 18,167 + 16,650 (cap 32,767 each).
- **Frontend:** `relatedInvLinks(row)` (app.js) splits the display list, maps numbers→ids via the pairs, and builds `FusionLinks.invoice(id)` URLs; the drawer cell template renders each number as its own `.fus-link` anchor (comma-separated, plain text when no id resolves). APP_VERSION 1.46.0→1.47.0.
- **Verified:** API — pairs on every row, all numbers resolve to numeric ids, columns/total unchanged (1,142,616,925.13 reconciles); browser — 4,276 AP_VIEWINVOICE anchors in the visible drawer column, 507 multi-invoice cells with separate links. **Test gotcha: the DOM holds 3 `.drill-tbl` tables (hidden Actuals modal + drawer + recon) — always select the one with `offsetParent` set, or the census reads the hidden table and shows 0 links.** Webtier release 20260728095903.

### 2026-07-29 — Legacy System (EBS) mapping + historical balances (FP v1.48.0, db/v2/110 + GL/db/16 + reporting/db/25+30)
- **User ask:** map the Fusion GL Account chart to the legacy EBS chart (used until 31-Dec-2025) from `docs/excel-integration/COA Account_Mapping.xlsx`, load EBS historical balances (7-segment `Entity.CC.Budget.Account.Activity.Future1.Future2` per period, PTD), Admin-editable, and enable prior-year reports. Second mapping (Fusion **Appropriation ↔ EBS Future1**) modelled now, file pending.
- **DB (`db/v2/110`):** `DCT_GL_EBS_MAP` (generic `segment_type` ACCOUNT/APPROPRIATION via lookup `GL_XMAP_SEGMENT`; UNIQUE (segment_type, ebs_value) — EBS→Fusion is a strict function, 11 Fusion accounts consolidate 2 EBS each) + `DCT_GL_EBS_MAP_V` (COA-snap descriptions + `in_chart`), `DCT_EBS_GL_BALANCE` (verbatim EBS grain, UNIQUE 7 segments + period) + `DCT_EBS_BALANCE_MAPPED_V` (translation happens HERE — account/appropriation via the map, chapter via the standing classification, sector via the CC snapshot, `account_mapped`/`appr_mapped` flags so nothing drops silently; a mapping fix retro-fixes reports without a reload), privileges `GL_VIEW_EBS_MAPPING`/`GL_MANAGE_EBS_MAPPING`. Seeded 3,191 ACCOUNT rows via `docs/excel-integration/load_coa_map.py` (MERGE, rerunnable; same script loads the APPROPRIATION file later). 439/442 live accounts covered.
- **ORDS (`GL/db/16`, additive — post-05 re-run list now 07..16):** `GET/POST /coamap` + `PUT /coamap/:id` (partial PUT, dup→400, lookup-validated; writes `has_priv_or_role(GL_MANAGE_EBS_MAPPING,'SYS_ADMIN')`), `POST /ebs-balances` (≤500 rows/req MERGE upsert w/ per-row results), `GET /ebs-balances/summary` (per-year coverage + top unmapped), `POST/GET /ebs-balances/register[/:id[/file]]` (EBS_GL_BALANCE_REGISTER bridge). **Period-parse gotcha: lenient `TO_DATE('JAN-25','MM-YYYY')` returns year 0025 — the parser uses `FX`-exact formats (FXMM-YYYY → FXMON-YYYY → FXMON-YY → FXYYYY-MM) + a 1990–2100 sanity window.** API smoke 16/16.
- **Frontend (v1.48.0):** new nav tab **Legacy (EBS)** (`#pg-legacy`) — Region 1 = COA Account Mapping on the SHARED `<interactive-report>` (segment/status/search toolbar, client-built columns; row click resolves via `ko.contextFor(td)` + a `segment|ebsValue` side-map → edit drawer; + Add mapping) with the `.dw-drawer` add/edit form (segment+EBS value frozen on edit, deactivate instead of delete); Region 2 = Legacy Balances — SheetJS client-parse Excel upload (fuzzy header map, chunks of 500, per-chunk progress + first-error surface), template download, per-year coverage table (rows/periods/combos/PTD/mapped %), top-unmapped lists, and **Generate Register (XLSX)** poll/download. Browser smoke `tests/legacy_browser_smoke.py` 17/17 EN + AR/RTL. **Layout gotcha: the `</div></div>` before the "DRILL-DOWN DRAWER" comment belongs to the drill-down MODAL, not `.wrap` — a section appended there renders inside the hidden modal; the Legacy section sits before `.pfoot`.**
- **Reports:** BUDGET_UTIL_REGISTER sheet 1 gains **Ebs Account** after Account Number (slash-joined LISTAGG over the active ACCOUNT map; run 179 = 1,373/1,373 filled, 424521→421100); NEW **EBS_GL_BALANCE_REGISTER** (`reporting/db/30`, MULTI/PYTHON XLSX): sheet 1 = mapped balance lines (PTD + running YTD per combination) w/ params year(req)/period/account(EBS or Fusion)/chapter/search, sheet 2 = Unmapped Coverage annex. E2E run 180 on synthetic 2025 rows: 203276→Fusion 213276 translated, unmapped 999999 + Future1 in the annex (no APPROPRIATION map yet — expected).
- Deploys via python-oracledb from the dev VM; 0 INVALID after every step. Webtier release: see git log.

### 2026-07-30 — DOF submission reports + budget cashflow plan (FP v1.49.0, db/v2/111 + GL/db/17 + reporting/db/31)
- **User ask:** the three DOF (Department of Finance) performance submissions — templates in `docs/Reports/GL/` — produced by the platform: **YoY Performance** (entity × chapter × appropriation × account, EBS + Fusion account codes, prior-year FY/YTD actuals), **Budget Utilization** (appropriation grain, Initial/Revised Budget FY + Initial/Revised Budget **YTD Cashflow**), **Quarterly Performance** (per-quarter Approved/Revised Budget Cashflow vs Actuals). Gap analysis found the budget **cashflow phasing exists nowhere** (Fusion budget = annual + dated adjustments; verified live — the whole initial budget sits in period 01-2026), so per user decision the plan is **uploaded from Excel** into two custom tables pending a dedicated Cashflow module; "Reasons for Variance"/"Remarks" are captured + persisted in-platform.
- **DB (`db/v2/111`):** `DCT_GL_BUDGET_CASHFLOW` (full 10-segment combination [virtual canonical `cc_string`, **VARCHAR2(320)** — 10×30+9 dots overflows 300] × budget_year × MM-YYYY period × `cf_type` APPROVED/REVISED, lookup `GL_CF_TYPE`), `DCT_PROJECT_CASHFLOW` (project/task/etype grain, no hard FKs — mirrors DCT_PROJECT_BUDGET_USER), `DCT_GL_DOF_NOTE` (year × entity × appropriation × account? × quarter? × REASON/REMARK, FBI-unique with NVL on the nullable keys), views **`DCT_GL_DOF_FACT_V`** (Fusion-era balances at DOF grain built from `gl_balances_cc.cc_string` TOKENS — entity=t1/account=t5/appr=t7 LPAD-normed — so unmapped combinations never drop; initial/adjustments/total budget + expenditures PTD per period) + **`DCT_GL_CASHFLOW_V`** (plan + chapter/appr attrs + mapped flags), privileges GL_VIEW_DOF_REPORTS / GL_MANAGE_CASHFLOW / GL_MANAGE_DOF_NOTES. Prior-year actuals come from the existing `DCT_EBS_BALANCE_MAPPED_V` (db/v2/110). **Deployed via Linux SQLcl saved conn `prod` — script deliberately has NO MERGE (count-then-insert/update) + keyword-free banners, so SQLcl-safe.**
- **ORDS (`GL/db/17`, additive — post-05 re-run list now 07..17; run as ADMIN `prod_mcp`, running it under the `prod` conn = ORA-01403 from ORDS.DEFINE_TEMPLATE because gl.rest lives under ADMIN):** `POST /cashflow` + `POST /cashflow/projects` (≤500 rows/req, per-row results, FX-exact period parse, numeric segments zero-padded to canonical widths — Excel drops leading zeros), `GET /cashflow/summary`, the three datasets `GET /dof/yoy|butil|quarterly` (year req; yoy/butil take `period=` MM-YYYY YTD-end defaulting to the latest loaded month; YoY = FULL OUTER JOIN current-year vs prior-year (Fusion ∪ EBS legs) + GROUPING SETS chapter/grand totals + slash-joined EBS account codes; **scoped to `SUBSTR(account_code,1,1)='4'`** — the 3xxxxx budgetary-control offset rows carry 8.76B mirror budget with zero spend and would double every chapter, and revenue-side budget is excluded; total-row attribute columns blanked via `CASE WHEN GROUPING(..)=0`), `GET/PUT /dof/notes` (upsert by natural key; empty text = delete), and the register bridges `POST /dof/register` {report:YOY|QUARTERLY, year, period?} + `GET /dof/register/:id[/file]`. API smoke `tests/dof_api_smoke.py` **31/31** (401/400s, dataset shapes, grand-total reconciliation, idempotent re-upload, per-row error, CF surfacing in butil, note round-trip; test rows use year 2030 and are cleaned).
- **Reports (`reporting/db/31`):** `DOF_YOY_PERF` (2 sheets — YoY + DOF Budget Utilization) + `DOF_QUARTERLY_PERF` (1 sheet, flat `_Q1.._Q4` headers; the template's merged quarter band is cosmetic-only loss). MULTI/PYTHON XLSX-only, section SQLs mirror the /dof/* handlers in lock-step; **seeds use count-then-insert/update (no MERGE) so Linux SQLcl deploys them** (needs `JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8` for the Arabic param labels). E2E on the live fleet: YoY run SUCCESS 203 rows / Quarterly 20 rows; workbook grand total (9,737,673,363 revised / 3,020,977,523.34 actual YTD 07-2026) reconciles exactly to the detail sum; CH1 = 1.162B expense-only (offsets excluded).
- **Frontend (v1.49.0):** nav tabs **Cashflow** (`#pg-cashflow` — GL + Projects plan uploads, SheetJS 500-row chunks + per-chunk progress, template downloads, per-year/type coverage + top-unmapped-appropriation lists) and **DOF Reports** (`#pg-dof` — report picker YoY/Butil/Quarterly + Year + Period(YTD), datasets on the SHARED `<interactive-report>`, row click → Reasons/Remarks drawer [yoy/butil = one reason; quarterly = 4 quarter reasons + remark; saved notes pre-fill every run], cashflow-missing hint, **Generate Workbook (XLSX)** button — butil enqueues the YOY workbook since it carries both sheets — poll 5s + auto-download). Browser smoke `tests/dof_browser_smoke.py` **24/24** EN + AR/RTL; `legacy_browser_smoke.py` updated (nav count 8→10) and re-run 17/17.
- **Formula conventions implemented (flag to Finance for sign-off — the templates hold only zero-value formulas):** YoY Variance = Actual YTD − Prior-year Actual YTD; BU Variance = Revised Budget YTD Cashflow − Actual YTD, Utilization % = Actual YTD ÷ Revised CF YTD; Quarterly Variance_Qn = Revised CF_Qn − Actual_Qn (% against Revised CF). "2026 Revised Budget Q1/Q2" = cumulative `total_budget` through Mar/Jun.
- **Pending user-side data:** 2025 EBS balance files + the Appropriation↔Future1 mapping file (prior-year columns render 0 until loaded — plumbing verified against the mapped view), and the actual cashflow plan workbooks (CF columns 0 until uploaded; on-screen hint points to the Cashflow tab).
- Webtier release 20260730051424.

### 2026-07-30 (2) — EBS corrections: Appropriation maps to FUTURE2 + Budget/Encumbrance balance measures (FP v1.49.1, db/v2/110 + GL/db/16 + reporting/db/30 re-runs)
- **User corrections:** (1) the Fusion **Appropriation** segment cross-maps to EBS **Future2** — NOT Future1 as originally modelled; (2) `DCT_EBS_GL_BALANCE` must carry the THREE balance measures — **Actual** (existing `ptd_amount`), **Budget** (`budget_amount`), **Encumbrance** (`encumbrance_amount`) — with the upload template updated.
- **Why this was cheap:** translation lives ONLY in `DCT_EBS_BALANCE_MAPPED_V` (the db/v2/110 design rule) — the Future2 flip is a one-line join change (`pm.ebs_value = b.future2_code`), no data reload, and retro-applies to everything downstream (DOF YoY prior-year leg included, which reads `fusion_appropriation` from the view).
- **DB (`db/v2/110` re-run, SQLcl `prod` — script has no MERGE):** guarded `ALTER TABLE ADD (budget_amount, encumbrance_amount NUMBER DEFAULT 0 NOT NULL)` + mapped view re-created (join flip + the 2 new measure columns). 3,191 ACCOUNT map rows untouched, 0 INVALID.
- **ORDS (`GL/db/16` re-run as `prod_mcp`):** `POST /ebs-balances` accepts optional `budget`/`encumbrance` per row (default 0) — **the row upsert MERGE was converted to UPDATE-then-INSERT** (SQLcl-safe, matches GL/db/17 style); `GET /ebs-balances/summary` years[] gains `budgetTotal`/`encTotal`, and the unmapped-appropriation list is now **`unmappedFuture2[]`** (key `ebsFuture2`, grouped on `future2_code`).
- **Report (`reporting/db/30` re-seeded — REWRITTEN count-then-insert/update, no MERGE, so Linux SQLcl deploys it):** sheet 1 columns now `… Future1 Code, Ebs Future2, Fusion Appropriation …, Actual Ptd, Budget Amount, Encumbrance Amount, Actual Ytd (running)`; coverage annex segment `FUTURE1`→**`FUTURE2`** + per-measure totals.
- **Frontend (v1.49.1):** upload template = `ACTUAL_AMOUNT / BUDGET_AMOUNT / ENCUMBRANCE_AMOUNT` columns (header map also accepts PTD/AMOUNT synonyms; bare `BUDGET` still means the budget-code SEGMENT — the amount needs `BUDGET_AMOUNT`), coverage table gains Budget + Encumbrance totals, labels "Future2 mapped" / "Top unmapped Future2 values" (`ebUnmappedF2`/`ebsFuture2`).
- **Verified E2E on live PROD (synthetic rows, cleaned after):** balance row with `future2=999888` + test APPROPRIATION map row → mapped view resolves Fusion appr 100103 + desc + Chapter 1 (`appr_mapped=Y`); unmapped `777666` correctly listed under Future2; summary budget/enc totals exact (14,000/650); register run SUCCESS with all new columns. Legacy browser smoke 17/17. Webtier release 20260730093714.
- **Test gotcha:** `JAN-99` under `FXMON-YY` parses to year **2099** (current-century YY) — fine for the real '25-era files, but synthetic test periods should use 4-digit years.

### 2026-07-30 (3) — EBS history 2015–2025 bulk-loaded + full export layout (FP v1.50.0, db/v2/110 + GL/db/16 + reporting/db/30 re-runs)
- **Data:** the real EBS "GL Period Balances" exports arrived in `docs/Reports/GL/Data/` — 11 CSVs (2015–2025, 145 MB). **All 603,698 rows loaded into `DCT_EBS_GL_BALANCE` with 0 errors**; per-year row counts and Actual/Budget/Encumbrance totals verified byte-exact against the CSVs. Account-map coverage 99.3–99.9 % per year (all unmapped accounts carry zero amounts); appropriation coverage 0 % until the Future2 map file arrives.
- **Load path (the fast one — NOT the browser):** preprocess with python (normalize periods to `MM-YYYY`, keep `13-YYYY`, blanks→0, headers renamed to the table's column names, `PERIOD_DATE` as `YYYY-MM-DD`), then **SQLcl `LOAD`** via `sql -name prod` (`set load batch_rows 500`) — ~6.5k rows/sec over the wallet (603k rows ≈ 95 s), converts `YYYY-MM-DD` strings into the DATE column natively. Load-ready files + `expected_totals.json` generator kept in the session scratchpad pattern; the browser upload (500-row chunks) stays for incremental corrections only.
- **Schema (`db/v2/110` re-run via `prod`):** `DCT_EBS_GL_BALANCE` extended to the FULL export layout — guarded ALTER adds `cc_id` + `entity_desc/cost_center_desc/budget_desc/account_desc/activity_desc/future1_desc/future2_desc` (VARCHAR2(240)) + `account_type` (VARCHAR2(60)). `DCT_EBS_BALANCE_MAPPED_V` exposes them LAST as `cc_id` / `ebs_*_desc` / `ebs_account_type` — the un-prefixed `account_type`/`cost_center_desc` view columns remain the FUSION-side attributes.
- **ORDS (`GL/db/16` re-run as `prod_mcp`):** `POST /ebs-balances` rows accept optional `ccId`/`accountType`/`entityDesc`…`future2Desc`; `ptd` now optional (blank = 0, matching the export's empty measure cells); **adjustment period `13-YYYY` accepted** — `parse_period` dates it 31-Dec of its year so it lands inside December/full-year YTD windows (every year 2015–2025 has one).
- **Report (`reporting/db/30` re-seeded):** sheet 1 gains `Ebs Account Desc` + `Ebs Account Type` after the EBS account code. 2015 register run verified (11,898 lines + coverage annex).
- **Frontend (v1.50.0):** `EB_HEADS` rewritten to synonym-priority matching **with column claiming** — segment keys resolve before measure keys, so with a `Budget Group Code` column present a bare `Budget` column is the AMOUNT, while a lone bare `Budget` (legacy template) still means the budget-code segment. New header synonyms for the full export layout (`CC_ID`, `Account Number`, `Period Name`, descriptions, `Account Type`, `Actual`); upload template regenerated as the EXACT export layout; `ptd` no longer required to upload.
- **DOF YoY impact:** `/gl/dof/yoy?year=2026` prior-year columns now populate live from the 2025 balances (Grand priorFy 184.77M / priorYtd 283.65M through the account map). ⚠ **Flag for Finance validation:** the export's Actual sign convention is unusual — EBS *Expense* rows net NEGATIVE in 2016–2024 (e.g. 2024 −3.31B) and the per-year totals do not balance to zero, so the file is not a full trial balance. Prior-year figures currently group under a NULL appropriation until the Future2 map loads.
- Legacy browser smoke 17/17. Webtier release 20260730104121.

### 2026-07-30 (4) — Appropriation↔Future2 = IDENTITY (user rule: "same code, no difference") — db/v2/110 re-run, NO mapping file needed
- **Rule:** the EBS Future2 value IS the Fusion Appropriation code; EBS just stores it without leading zeros (`438` = `000438`, `0` = `000000` Un Specified). Implemented as **identity seed** (110.5b): one `APPROPRIATION` map row per chart appropriation code (`ebs_value = fusion_value`, 72 rows, idempotent INSERT..SELECT) + the mapped-view join zero-pads the EBS side: `pm.ebs_value = LPAD(b.future2_code, 6, '0')` — self-healing for any future value. `load_coa_map.py --segment APPROPRIATION` is no longer needed.
- **Coverage after seed:** appr_mapped 99.9–100 % per year; only `301005`/`201129` (FA1005/FA1129 oddballs, zero amounts) stay unmapped. Correcting a specific code later = edit its row on the Legacy tab (ebs_value in 6-digit padded form).
- ⚠ **Data-reality finding (for Finance):** the EBS **actuals carry no appropriation attribution** — in 2025, ALL 184.77M expense actual sits on Future2 `0` (Un Specified); the rows with a real Future2 (program codes) sum to zero. EBS Budget Groups are `1 Current / 2 Capital / 8 Accrual` — not the 7 DOF chapters. Consequently the DOF YoY prior-year columns currently roll up under appropriation `000000` → "Unclassified" chapter rows; chapters 1–5 show prior = 0. If DOF needs prior figures BESIDE the current-year account rows, the YoY prior leg must join by ACCOUNT only (ignore appropriation for the prior year) — a report-semantics change awaiting the user's call.

### 2026-07-30 — Budget Combination derivation corrected (db/v2/37 re-run, user rules)
- **User rules:** ① the ACCOUNT segment of `BUDGET_COMBINATION` (and the register's Account Number) = the **expenditure type's 6-digit prefix ALWAYS** — never the posted-transaction account (first pass had COA-row-txns winning, so e.g. project 4511000892's 421115/422401 lines all showed 424521); ② every task must have Program/Cost Centre/Entity-Specific/Appropriation — a task missing one takes it from **PROJECT level** (= the rollup of the project's own tasks via the new `proj_seg` CTE; appropriation also from the project's APPROPRIATION attribute — the extract has no project CC/program/ES columns).
- View changes: `GL_ACCOUNT` display flipped to etype-prefix-first (posted account = display fallback only); `budget_combination` account leg = `REGEXP_SUBSTR(etype,'^\d{6}')` only; task→project COALESCE on the 4 segments; `MAX(k.cc_string)` stays as LAST resort (only when no cost centre at task OR project level — 8 lines today). Verified: 1,620/1,628 constructed lines embed exactly the etype prefix (the other 8 are the posted-combination fallback), totals unchanged (1,728 lines / 7.56B annual), 0 INVALID. Registers pick it up automatically (they read the view).

### 2026-07-30 (5) — Canonical segment widths enforced as column lengths (user rule) — db/v2/110 + 111 + GL/db/16 re-runs
- **Rule:** segment lengths are FIXED: Entity 3 · Cost centre 7 · Budget group 1 · Program 6 · GL Account 6 · Entity Specific 7 · Appropriation 6 · Intercompany 3 · Future1/Future2 6. All segment columns on both sides are **VARCHAR2 at exactly these widths** now: `DCT_EBS_GL_BALANCE` (7 EBS segments), `DCT_GL_BUDGET_CASHFLOW` (10 Fusion segments), `DCT_GL_DOF_NOTE` (entity/appr/account).
- **EBS data normalized:** 569,048 of the 603,698 loaded rows zero-padded to exact width (`0`→`000000` etc. on activity/future1/future2 — entity/cc/budget/account were already exact); totals byte-identical after, coverage account 99.8 % / appropriation ~100 %, DOF YoY figures unchanged, 0 INVALID. The `/gl/ebs-balances` upload handler now pads numeric incoming values (`eseg()` — matches the stored canonical form so re-uploads upsert correctly).
- **ORA-30556 gotcha:** a column referenced by a **virtual column that sits in a UNIQUE constraint** (cashflow `cc_string`) or by a **function-based unique index** (note key) cannot be MODIFYed directly — 111.4b drops the constraint + virtual column (or the FBI), MODIFYes, then re-adds. Both tables were empty.
- DOF API smoke 31/31 re-run PASS.

### 2026-08-02 — EBS YTD+PTD reload (2016–2025) + GL Balances YoY comparison (FP v1.51.0, db/v2/110+111 + GL/db/16 + NEW GL/db/18 + reporting/db/30+32)
- **Data (FULL REPLACE, user decisions):** the refreshed EBS exports (`docs/Reports/GL/Data/`, now 20 XLSX — `GL Period Balances - PTD-<yr>.xlsx` + `- YTD-<yr>.xlsx` per year 2016–2025) merged into **ONE row per combination × period with 6 measures** (Budget/Encumbrance/Actual × PTD/YTD) and loaded: **637,777 rows, 0 errors**, every year's PTD-file/YTD-file keys align 1:1 (0 mismatches/dups). **2015 dropped** (old CSV era, no YTD); previous 603,698 rows deleted. The refreshed extract also **fixed Future2 attribution** (2025 expense actuals now mostly on real appropriations → chapter split works: Ch2 4.52B / Ch3 1.57B / Ch1 1.07B FY-2025) and 2025 expense signs look right (+6.66B FY) — **older years (2017–2023) still show net-negative expense YTD; flagged for Finance**.
- **YTD is genuine data** — carries opening balances (Retained Earnings opens 2016 at 1.05B with PTD 0). NEVER derive YTD from PTD. `db/v2/110` adds `budget_ytd/encumbrance_ytd/actual_ytd` (DEFAULT 0 NOT NULL, exposed LAST in the mapped view); GL/db/16 upload accepts `budgetYtd/encumbranceYtd/actualYtd`; summary years[] gains `actualYtdFy` (13-slice else 12-slice).
- **YoY comparison (the point of the exercise):** NEW **`GL/db/18`** ADDITIVE — `GET /gl/ebs-balances/yoy?years=2026|2025|2024&month=0..12` (Fusion-account basis: EBS years read STORED YTD slices through the account map, Fusion years sum `DCT_GL_DOF_FACT_V` periods ≤ cutoff — the fact view gained `encumbrance` = commitments+obligations+other_encumbrances in 111.6; long-format rows, all-zero year-slices suppressed; **EBS YTD-at-cutoff = the `MM-YYYY` period SLICE; Full Year = `13-YYYY` slice else `12-YYYY`**) + register bridge `POST /ebs-balances/yoy/xlsx` → **EBS_GL_YOY_REGISTER** (reporting/db/32, XLSX: long-format sheet w/ prior-year actual + change via LAG, + per-year coverage sheet; SQLs LOCK-STEP with the handler). reporting/db/30 sheet 1 now reads the STORED YTD columns (its old running-PTD window sum missed opening balances) + budget/encumbrance YTD columns. **Post-05 re-run list = 07..18.**
- **⚠ PERF gotchas (cost 90s live, now <2s):** a JOIN to `TABLE(apex_t_number(...))` for the year list wrecks the plan against the 637k-row mapped view (41s) → **scalar `IN (NVL(l_y1,-1)…)` binds**; a correlated per-row `EXISTS` for the 13-slice check → **pre-grouped `fy` CTE**; referencing the union CTE twice re-executes both slices → **single pass + analytic (`MAX(..) OVER/KEEP`) account attributes**.
- **Frontend v1.51.0:** NEW nav tab **Balances YoY** (`#pg-yoy`) — year chips (max 6, default 2026/2025/2024), Balance-as-of select (Full year / month YTD), measure toggle Actual/Budget/Encumbrance, client-side account search + type filter, pivot table (year columns desc + Change + Change% vs previous year + totals row), CSV export, **Export Excel Register** poll/download. `yo*` i18n EN+AR; `.yo-chip` styles in app.css.
- Verified live: Basic salary 411121 YTD-Jun = 2026 194.7M vs 2025 159.2M; register run SUCCESS 731 rows; endpoint 0.6–1.9s; browser smoke `tests/yoy_browser_smoke.py` **14/14** EN+AR. Webtier release 20260802162317.

### 2026-08-02 (2) — TWO PLATFORM RULES: account 452201 excluded + Budget Group defaults to 1 (FP v1.51.1)
- **RULE 1 — account 452201 "Revenue Transfer to Treasury" is EXCLUDED from ALL calc/reporting** (user): it is the government revenue remittance mis-classed as Expense (2.1–5.1B actual/yr in EBS; 976.8M budget in Fusion 2026) and distorted every expense figure. Filtered at the BASE read layer so every consumer inherits: `GL_BALANCES_CC` (db/v2/32 — outer WHERE on cc_string account token; NOT in dct_views_rebuild, so a views rebuild won't resurrect it) + `DCT_EBS_BALANCE_MAPPED_V` (db/v2/110) + `DCT_GL_CASHFLOW_V` (db/v2/111). **Raw rows stay in the tables — read-layer rule, reversible.** Verified exact: 2026 budget 19,477→18,500M (−976.8M), DOF revBudget −976.8M, 2025 FY expense −318.2M (its year total), read layer = 0 rows everywhere, 0 INVALID after recompile sweep.
- **RULE 2 — Budget Group segment defaults to '1' (Current operations) in all calc/reports/UI; 2 (Capital) / 8 (Accrual) optionally addable as a parameter** (user):
  - **Fusion side = HARD bg '1'** inside `DCT_GL_DOF_FACT_V` (Fusion carries stray groups 3/5 — 738M budget, zero spend — never selectable); the view now exposes `budget_group_code`.
  - **EBS side = `bg=` parameter, default '1'**, pipe list may add 2/8: `/gl/ebs-balances/yoy` (+ echoed `budgetGroups`, 400 on malformed), `/gl/ebs-balances/summary`, `EBS_GL_YOY_REGISTER` (db/32) and `EBS_GL_BALANCE_REGISTER` (db/30) params + both bridges forward it. DOF submissions are bg-1 FIXED (prior EBS leg in GL/db/17 + reporting/db/31 in lock-step — no param by design).
  - **Frontend v1.51.1:** YoY tab gains a **Budget group chip row** (1 on by default; 2/8 toggleable, EBS years only) + hint; note text updated to state the 452201 exclusion.
- Verified live: bg default vs 1|2|8 (2025 FY expense 7,153.6M vs 6,339.2M — group 8 accrual reversals net −814M), summary rows 102,921 (bg 1) vs 125,761 (all); DOF YoY GRAND now revBudget 8,392.2M / priorFy 7,157.7M. Smoke 14/14. Webtier release 20260802182916.
- Deploy chain: db/v2/32 GL_BALANCES_CC (extract) + 110 + 111 via `prod` (+ recompile sweep to 0 INVALID); GL/db/16+17+18 via `prod_mcp`; reporting/db/30+31+32 via `prod`.

### 2026-08-13 — Butil "Refresh source data" button + PROJECTS_DATA job set (FP v1.62.0, GL/db/19)
- **New ATD job set `PROJECTS_DATA`** (otbi-atd/db/67): Projects Full + Tasks Full + Projects
  Budget Full - V2, **hourly, no daily window** — replaces PROJECTS_DAILY membership for the
  masters (a job belongs to ONE set) and aligns them with the hourly chunked budget extract, so
  a task created in Fusion mid-day no longer leaves its budget line hidden behind the butil
  view's missing-master exclusion (seen live: project 4511000339). PROJECTS_DAILY now holds
  only the disabled legacy Projects Budget Full.
- **GL/db/19 (ADDITIVE)**: `POST /gl/butil/refreshdata` → `prod.atd_set_pkg.run_now('PROJECTS_DATA')`
  = {queued:n}; `GET /gl/butil/refreshdata` = {busy Y/N, jobs[{job,queueStatus,lastStatus,
  lastRows,lastFinished}]}. Gated like the butil endpoints (GL_VIEW_BUDGET_UTILIZATION via
  has_priv_or_role). **GL post-05 re-run list = 07..19.**
- **Frontend v1.62.0**: butil page-head button **Refresh source data** (`refreshProjectsData`/
  `pdataBusy`) — enqueues the set, polls every 5s (7.5-min ceiling), toasts per-job failures,
  re-runs the current search on success; EN+AR (`pdata*` keys). Smoke:
  `tests/butil_pdata_smoke.py`. Webtier release 20260813222044.

---

## Budget Transactions page + navigation restructure — 2026-08-17 (v1.63.0)

### Navigation: 11 flat tabs → 3 groups with sub-tabs
The tab bar is now two rows — a group row and a sub-tab row — driven by a single
`NAV_GROUPS` list in `app.js`. The active group is **derived from the current
view**, so a deep link still lights the right group; adding a page means one
entry in that list, nothing else.

| Group | Sub-tabs |
|---|---|
| **Projects** | Project Budget Utilization · Projects Encumbrances · Encumbrances – Pending Approval · **Budget Transactions (new)** · Cashflow |
| **General Ledger** | Dashboard · Budget vs Actual · Reconciliation · Legacy (EBS) · DOF Submissions · Balances YoY |
| **Settings** | Chart of Accounts |

Nothing was removed. Two label changes only: the group header is *General
Ledger*, so the `actuals` page (which is the Budget-vs-Actual report) is now
labelled **Budget vs Actual** — a sub-tab named "General Ledger" inside a
"General Ledger" group read as a duplicate. `navOverview` was already
"Chart of Accounts", which is why it sits under Settings.

### The Budget Transactions page (`view()==='budgettrx'`)
Mirrors the source **Project Budget Transactions** VBCS screen: four regions —
Search criteria (10 fields) → Transactions master grid → Details of the selected
row → its Approval history. Selecting a header row is what loads the two child
regions, exactly as the source behaves; a new search clears the selection.

Data is the ATD PBT extract (`PA_BUDGET_TRX_*`, `otbi-atd/db/77`), so the page is
**read-only** — it shows what the last sync pulled, not live Fusion.

* The master grid **scrolls inside a fixed 340px box with a sticky header**
  (`.bt-scroll`). Without that, 100 rows made the page ~7,600px tall and pushed
  Details and Approvals off-screen — the source screen keeps all four visible.
* The **line columns differ per budget type** (34 / 21 / 38 source fields), so
  the details table is metadata-driven from `BT_LINE_COLS`; adding a budget type
  is one entry there plus one in the lookup.

### DB — `GL/db/20_gl_budget_trx_ords.sql` (additive)
```
GET /gl/budgettrx/filters   -> criteria LOVs (types, BUs, project types, statuses, years, approvers)
GET /gl/budgettrx           -> master grid, paged; every criterion on the screen
GET /gl/budgettrx/:num?type= -> header + lines (per-type shape) + approval trail
```
Gated on `GL_VIEW_BUDGET_UTILIZATION` via `has_priv_or_role`. **`/atd/pbt/*`
already serves the same tables but is SYS_ADMIN-gated and behind the ATD
module-access gate, so a Finance user of this app would get a 403** — hence the
GL-side routes.

No synonyms are created here: `otbi-atd/db/78` already made the ADMIN synonyms
for `PA_BUDGET_TRX_*`, and ORDS handlers run as ADMIN.

> **`05_gl_ords.sql` DELETE_MODULEs `gl.rest` — the post-05 re-run list is now
> `07..20`.**

### Verified
API 7/7 (filters, grid, type filter, date range, 400 on a bad date, 404 on an
unknown transaction, drill). Browser `tests/budgettrx_browser_smoke.py`
**32/32** EN + AR/RTL — nav groups, sub-tabs, all four regions, row selection
driving the child regions, criteria filtering, Clear, and the AR pass.

### Gotchas hit
- `networkidle` **never settles** on this app — wait on `window.ko` plus a nav
  selector instead (same trap as `pending_browser_smoke.py`).
- `.bu-sec-t` is `text-transform:uppercase` and Chrome's `innerText` applies it,
  so region-heading assertions must compare case-insensitively.
- **`.lang-flip` is shared by three buttons** — the app switcher, the language
  toggle *and* Sign out. `page.locator('.lang-flip').last` would click **Sign
  out**; target `button[data-bind*="toggleLang"]`.
- GL persists the language to `localStorage('gl_lang')` only, **not** to the
  user's server-side prefs like the shared shell — so an AR toggle in a test
  cannot leak into the real account.
