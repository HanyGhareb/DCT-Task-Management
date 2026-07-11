# General Ledger (App 210) — Deployment Notes

Canonical platform-wide SQLcl/ORDS rules live in `final apps/Admin/docs/deployment-notes.md §2`.
This file holds GL-specific deploy steps, history, and gotchas. **Update on every deploy.**

## Deploy checklist
1. **DB scripts** via SQLcl `sql -name prod_mcp` (CRLF, UTF-8 no BOM, `SET DEFINE OFF`, `SET SQLBLANKLINES ON`):
   - `01_gl_synonyms.sql` — **own fresh session** (ORA-01471 rule).
   - `02_gl_ddl.sql` → `03_gl_pkg.sql` → `04_gl_views.sql`.
   - `06_gl_seed.sql` — run with `JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8` (Arabic class-type names);
     regenerate from CSVs first with `python db/gen_seed.py` if `db/source/*.csv` changed.
   - `05_gl_ords.sql` — **own fresh session**. It DELETE_MODULEs gl.rest — **always re-run the
     ADDITIVE scripts `07` (butil), `08` (rebuild endpoint), `09` (mappings drill) and `10`
     (actuals/lines doc numbers) right after any 05 re-run.** (09 and 10 are also source-synced
     into 05, so a full 05 re-run carries their changes — re-running them is still harmless.)
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
