# General Ledger (App 210) — STATUS

Date-tracked Chart-of-Accounts classification layer (Sector / Chapter / DCT Program)
over the Fusion-loaded `ATD_GL_*` tables + a Portal-style management UI.

| Layer | State |
|---|---|
| DB tables (`DCT_GL_CLASS_TYPE/_VALUE/_SEG_CLASS_MAP`) | ✅ Deployed PROD (2026-06-28) — all VALID; +`alt_name1/2/3` |
| Bridge synonyms (`GL_SRC_*`) | ✅ Deployed — insulate the planned `ATD_GL_* → GL_*` rename |
| Package `DCT_GL_CLASS_PKG` + context `GL_CTX` | ✅ Deployed — norm / set_asof / resolve_value_id / validate_map |
| Views `DCT_GL_COA_V` (+`GL_COA_V`) / `DCT_GL_BALANCES_V` | ✅ Deployed — COA view = 9,338 rows (no fan-out), 8,485 (91%) have a Sector |
| Seed | ✅ 21 Sectors / 7 Chapters / 41 PBB Programs; 109 sector + 74 chapter + 33 program mappings |
| ORDS `gl.rest` (`/ords/admin/gl/`) | ✅ Deployed — route groups incl. actuals/dashboard/refresh; auth + overlap-guard + as-of verified |
| Actuals reporting (`db/v2/32–36`) | ✅ Deployed — `DCT_ACTUAL_V` / `DCT_BUDGET_ACTUAL_V` / `DCT_BUDGET_ACTUAL_PERIOD_V` (3-figure Commitment from **`DCT_PR_COMMITMENT_PERIOD_V`** [db/v2/36 over `ATD_PR_*`] + 3-figure PO buckets w/ **GRN-netted Open Obligation** + `open_encumbrance_ytd` + `funds_available_calc_ytd`; **AP Direct = `po_number IS NULL`**) + indexed `DCT_GL_COA_SNAP` + hourly `DCT_ACTUALS_REFRESH_JOB` |
| Frontend (Portal-style KO SPA, `Jet/`) | ✅ Live — Overview / Actuals (full-width; **grouped Commitment/Obligation cells** [Total/Open/Pipeline] + Open Encumbrance + Funds Available GL/Calc + SLA Actual; real PR/PO drills; filters + ⓘ hints) / Dashboard / Classifications / Mapping / Explorer; EN-AR-RTL; E2E + mock-render passed |
| Registration | ✅ shell switcher + common i18n + proxies (auto-derived) + CLAUDE.md Module Status |
| APEX pages | ⬜ N/A (JET only) |

## Deployment log
- **2026-08-23 (2)** — **Comments feedback round** (`APP_VERSION` **1.83.0**, GL/db/26+21+11
  re-runs + reporting/db/25, webtier release 20260823183954 GL-only overlay): dashboard
  accounting-period select FIXED (the Portfolio page's shared-observable select had
  undefined option values and clobbered every period pick back to "Full year"); drawer =
  labelled amber period chip + author profile photos + collapsed Search region (Posted by /
  Accounting Period, defaulting to the dashboard period) + newest-first roots; NEW "Display
  Comments" LOV (None/Selected period/All) → Comments column in results + CSV, and the
  Excel register gains a sheet-1 comments column + sheet 7 "Comments - Other Levels".
  API 75/75 + browser 41/41 EN+AR; live register run verified.
- **2026-08-23** — **Projects Budget Utilization COMMENTS** (`APP_VERSION` **1.82.0**,
  db/v2/125 + GL/db/26 + GL/db/21 re-run, webtier release 20260823163437 GL-only overlay):
  threaded, attachable justification comments at 8 levels per budget year + accounting
  period; `(**)` marker + Comments column on butil; drill-row 💬 for PO/PR/AP invoices;
  Comments register tab (Sector/CC entry); Comment Roles + Reporting Periods admin pages
  (capabilities on the COMMON dct_role_permissions; CLOSED period freezes every write);
  7 platform-wide roles seeded (FIN_BP, FBP/PBP heads, planners). Full details in
  `docs/deployment-notes.md` + `BUTIL_COMMENTS_PLAN.md`. API 68/68 + browser 31/31 EN+AR.
- **2026-08-04 (3)** — **Drawer figures mirror the table format** (`APP_VERSION` **1.56.2**,
  GL-only; webtier release 20260804221545): Record-details grid = same unit scaling,
  2-decimal money, near-zero mode + ▲green/▼red colored Variance. Smoke dof 59/59.
- **2026-08-04 (2)** — **Layout feedback fixes** (`APP_VERSION` **1.56.1**, webtier release
  20260804220157): merged identity columns (Appropriation/Account/Entity = code — name; fixes
  truncated frozen headers), shared-IR `stateRev` envelope hook (invalidates stale saved
  column order so the year-block default wins), stronger tints (prior year = slate-blue hue),
  NEW multi-select Chapter + Appropriation Search criteria (chips, any-of, client-side w/
  totals recomputed). Smokes: dof 57/57, yoy 24/24.
- **2026-08-04** — **Readability layout round on DOF Submissions + Balances YoY** (`APP_VERSION`
  **1.56.0**, frontend-only; webtier release 20260804214154). SHARED IR gained generic opt-in
  hooks — grouped header bands (`column.group`), per-column tints (`column.colClass`), frozen
  columns (`column.sticky`+`width`, RTL-safe), delta arrows (`column.delta` ▲green/▼red),
  near-zero display (`column.nearZero`), one-line ellipsis cells (`column.ellipsis`), zebra
  striping (envelope `zebra:true`). DOF datasets re-ordered into year blocks under FY bands
  (current = brand tint, prior = grey; quarterly = Q1–Q4 alternating bands), frozen
  Chapter/Appr/Account columns, Variance delta arrows, NEW "Showing figures in" (AED/K/M/B)
  + "Near-zero display" (Dimmed/Dash/Blank) Search parameters (display-only, persisted), and
  the notes drawer shows a full Record-details grid of the clicked row. YoY: alternating year
  tints + gold Change block w/ arrows + zebra. All 16 fronts bumped (shared change). Smokes:
  dof 51/51, yoy 24/24 EN+AR.
- **2026-08-03 (4)** — **Balances YoY on the shared interactive report** (`APP_VERSION` 1.55.0,
  frontend-only). Ascending year columns, dynamic "Change YY-YY" headers (two latest selected
  years), per-column ⓘ hints, and a trailing **Chart** column via the NEW shared-IR **`spark`**
  column type (inline sparkline + hover trend chart popover); shared IR also now inserts new
  envelope columns at their envelope position. All 15 apps bumped; smoke 20/20; webtier
  20260803221349.
- **2026-08-03 (3)** — **Chapter sub-totals in DOF grids + workbooks** (`APP_VERSION` 1.54.0;
  GL/db/17 + reporting/db/31 re-run + runner fleet sync). GROUPING SETS chapter/grand totals
  added to the BU + Quarterly datasets (YoY had them); styled bands on-screen via NEW shared-IR
  `row._rowClass` (`.ir-row-subtotal`/`.ir-row-grand` in platform.css) and in the XLSX via the
  NEW `row_kind` magic column in `render_xlsx.py` (consumed, styles the row; fleet-synced).
  Totals reconcile (GRAND = ΣDETAIL = ΣCHTOTAL); smoke 38/38; webtier 20260803220020.
- **2026-08-03 (2)** — **DOF column-header ⓘ hints** (`APP_VERSION` 1.53.0). Per-figure hover
  hint popovers on the DOF columns (FY-vs-YTD prior actuals, variance formula, cashflow/util
  semantics; EN+AR, year-substituted) via NEW generic `column.hint` support in the SHARED
  `<interactive-report>` (+ `.ir-hint` styles in platform.css) — shared change ⇒ all 15 apps
  bumped + fleet redeploy (webtier 20260803213633).
- **2026-08-03** — **DOF Submissions rework** (`APP_VERSION` 1.52.0; GL/db/17 + reporting/db/31
  re-run). Renamed **DOF Submissions**; criteria = butil-pattern collapsible Search region +
  Results region w/ busy overlay; **dynamic year-based column headers** ("Revised Budget 2026",
  "Actual FY 2025"…); **runs for every loaded fiscal year 2016+** — current-year leg = Fusion ∪
  legacy-EBS union (bg-1) on **STORED YTD slices** (KEEP LAST per combination; prior leg reworked
  in lock-step so 2026-prior = 2025-current byte-for-byte); EBS one budget measure → Initial =
  Revised for prior years. Live-verified all eras + both workbooks (2024 YoY 250 rows, 2023
  quarterly 55 rows); smoke `dof_browser_smoke.py` 35/35 EN+AR; webtier 20260803100051.
  ⚠ standing data flag: 2016–2024 EBS actuals sit on budget group 8 w/ credit signs → prior-era
  actual columns ≈ 0 on the bg-1 rule until Finance confirms the convention.
- **2026-08-02 (2)** — **Platform rules: 452201 excluded + Budget Group default 1** (`APP_VERSION` 1.51.1).
  ① Account 452201 "Revenue Transfer to Treasury" (2.1–5.1B/yr EBS actual; 976.8M Fusion 2026
  budget) EXCLUDED from all calc/reporting at the base views (GL_BALANCES_CC + EBS mapped view +
  cashflow view; raw rows preserved — reversible). ② Budget Group defaults to '1' everywhere:
  Fusion hard-'1' in DCT_GL_DOF_FACT_V (stray 3/5 excluded), EBS `bg=` param default '1'
  optionally +2/8 on YoY/summary/registers; DOF submissions bg-1 fixed; YoY tab gains BG chips.
  Verified exact deltas live; smoke 14/14; webtier 20260802182916.
- **2026-08-02** — **EBS YTD+PTD reload + GL Balances YoY tab** (`APP_VERSION` 1.51.0).
  Refreshed exports (20 XLSX: PTD + YTD per year 2016–2025) merged into ONE row per
  combination × period with **6 measures** (Budget/Enc/Actual × PTD/YTD) — **637,777 rows,
  0 errors, full replace; 2015 dropped** (user decision). YTD = stored data w/ opening
  balances (never derive from PTD). Refreshed data fixed Future2 attribution → chapter
  split now real (2025 FY: Ch2 4.52B/Ch3 1.57B/Ch1 1.07B). NEW **Balances YoY** tab +
  `GL/db/18` `/gl/ebs-balances/yoy` (Fusion-account basis, 3 measures, month cutoff or
  FY=13-slice; perf gotchas: no TABLE() year join / no correlated EXISTS / single-pass
  union — 90s→<2s) + **EBS_GL_YOY_REGISTER** (reporting/db/32) + db/30 register now uses
  stored YTD. **Post-05 re-run list = 07..18.** Smoke 14/14; webtier 20260802162317.
  ⚠ Older years (2017–2023) expense YTD still net-negative — Finance to confirm signs.
- **2026-07-30 (2)** — **EBS history 2015–2025 LOADED + full export layout** (`APP_VERSION` 1.50.0).
  The real EBS "GL Period Balances" exports (`docs/Reports/GL/Data/`, 11 CSVs) bulk-loaded:
  **603,698 rows, 0 errors**, per-year counts + Actual/Budget/Encumbrance totals byte-exact vs
  the CSVs; account-map coverage 99.3–99.9 %/year (unmapped accounts all zero-amount).
  `DCT_EBS_GL_BALANCE` extended to the full export layout (`cc_id`, 7 per-segment description
  columns, `account_type`; mapped view exposes `ebs_*` aliases); upload API takes the new
  optional fields, `ptd` optional, and the **`13-YYYY` adjustment period** (dated 31-Dec of its
  year — every year has one); frontend header map = synonym-priority w/ column claiming (bare
  `Budget` = amount when `Budget Group Code` present), template = the exact export layout;
  register sheet 1 + coverage annex gain the EBS desc/type columns. Load path for big files =
  python preprocess + **SQLcl `LOAD`** (~6.5k rows/s), browser upload for increments. DOF YoY
  2026 prior-year columns now live (priorFy 184.77M — ⚠ export sign convention flagged for
  Finance: Expense rows net negative 2016–2024, file is not a balanced trial balance). Smoke
  17/17; webtier 20260730104121. Same day: **canonical segment widths enforced as column
  lengths** (user rule: Entity 3 / CC 7 / BG 1 / Program 6 / Account 6 / ES 7 / Appr 6 / IC 3 /
  F1+F2 6) on `DCT_EBS_GL_BALANCE` + `DCT_GL_BUDGET_CASHFLOW` + `DCT_GL_DOF_NOTE`; 569,048 EBS
  rows zero-padded to exact width (totals/YoY unchanged, smoke 31/31); upload handler pads
  incoming numeric segments (`eseg`). ORA-30556 gotcha: MODIFY under a virtual-column UNIQUE
  or FBI = drop → modify → re-add (111.4b). Same day: **Appropriation↔Future2 = IDENTITY** (user rule
  "same code" — 110.5b seeds 72 identity rows over the chart appropriation codes, view join
  `LPAD(future2_code,6,'0')`; appr coverage 99.9–100 %, no mapping file needed). ⚠ EBS actuals
  sit on Future2 `0` → DOF YoY prior figures roll up under Unclassified; per-chapter prior
  split needs an account-only prior join (user decision pending).
- **2026-07-30** — **DOF submission reports + budget cashflow plan** (`APP_VERSION` 1.49.0).
  Two new tabs: **Cashflow** (GL 10-segment + Projects cashflow plan Excel uploads →
  `DCT_GL_BUDGET_CASHFLOW`/`DCT_PROJECT_CASHFLOW`, coverage tables) and **DOF Reports**
  (YoY Performance / Budget Utilization / Quarterly Performance datasets on the shared IR,
  persisted Reasons/Remarks drawer via `DCT_GL_DOF_NOTE`, Generate Workbook = DOF_YOY_PERF /
  DOF_QUARTERLY_PERF XLSX). DB `db/v2/111` (+ `DCT_GL_DOF_FACT_V`/`DCT_GL_CASHFLOW_V`),
  ORDS `GL/db/17` (post-05 re-run list now 07..17), reports `reporting/db/31`. Datasets
  scoped to 4xxxxx accounts (3xxxxx budget offsets excluded — they mirror-double every
  chapter). API smoke 31/31; browser smoke 24/24 EN+AR; live report runs reconcile to the
  detail sum. Prior-year (2025) columns await the EBS balance + appropriation-map files.
  Same-day corrections (v1.49.1): the Appropriation cross-map joins EBS **Future2** (was
  Future1 — view-only flip, no reload needed) and `DCT_EBS_GL_BALANCE` now carries Actual +
  Budget + Encumbrance measures (upload template ACTUAL/BUDGET/ENCUMBRANCE_AMOUNT columns;
  db/v2/110 + GL/db/16 + reporting/db/30 re-deployed, E2E verified, smoke 17/17).
- **2026-07-18** — **Business Unit filter on butil + encumbrances** (`APP_VERSION` 1.34.0).
  Projects master BU fixed by the user's extract change → butil/scope views carry `business_unit`
  (project attribution); `bu=` on /butil, /butil/lines, /encumbrances + businessUnits[] LOV +
  all report bridges; reporting 21/25 bind it; shared BU chips on both pages (pending keeps its
  snapshot-BU filter). E2E runs 109/110; smoke 47/47.
- **2026-07-17** — **Business Unit multi-select** (`APP_VERSION` 1.31.0). Pending Approval page
  gains a BU multi-select (chips; LOV = `businessUnits[]` from `/gl/pending`) → `bu=` exact
  any-of list scoping register + KPIs + the unmatched coverage KPI (GL/db/13 re-run); forwarded
  to ENC_PENDING_BOOK + ENC_PENDING_REGISTER (reporting/db/23+24 re-seeded, cover BU chip).
  NOT added to the other GL/AP dashboards: the BIP snapshot is the only cross-BU source — the
  OTBI extracts are DCT-scoped (AP has no BU column at all). E2E runs 89/90/91; smoke 45/45.
- **2026-07-16** — **Pending page: zero-value lines excluded** (`APP_VERSION` 1.30.1). User rule:
  the page follows budget utilization, so 0-amount PR/PO lines never show (they reserve nothing) —
  `ABS(NVL(line_aed,0)) > 0.005` in the `GET /gl/pending` cursor (GL/db/13 re-run); the single-scan
  design scopes register + KPIs + aging + approvers + client drills together (unmatched coverage
  KPI untouched; book/Excel already had the stricter reserved-only rule). Subtitle states the rule.
  Smoke 41/41 — webtier release 20260716223006.
- **2026-07-16** — **Review round 3** (`APP_VERSION` 1.30.0). Pending page: busy overlay,
  KPI/aging/approver drill-downs into the shared drawer (client-side slices, Fusion doc links,
  CSV), #79C5AC mini-table region headers. Butil: NEW Part 5 "Pending Approvals — PR & PO Queue"
  in BUDGET_UTIL_BOOK (db/21 + Approval-queue insight, Observations → Part 6) + NEW
  BUDGET_UTIL_REGISTER 6-sheet Excel (db/25 + /gl/butil/xlsx bridge in GL/db/11 + Export Excel
  button). Both report covers: "Oracle Fusion i-Finance · Reporting Platform", simple datetime
  ("Thu 16-Jul-2026 10:04 pm", runner `generated_at_pretty`), framed Prepared-by card. E2E runs
  86/87/88 SUCCESS; smoke 40/40 — webtier release 20260716220623.
- **2026-07-16** — **Pending Approval Excel register** (`APP_VERSION` 1.29.0). New
  `ENC_PENDING_REGISTER` (reporting/db/24, XLSX-only, 2 sheets: 29-column flat pending PR/PO
  register on the book scope rule + extract-coverage annex) + GL bridge `POST /gl/pending/xlsx`
  + status/file routes (GL/db/13 re-run) + **Export Excel** page button. E2E run 83: 1,004+329
  rows, 570.6M reconciles to the book. Smoke 30/30 — webtier release 20260716075119.
- **2026-07-16** — **Pending Approval review round** (`APP_VERSION` 1.28.0). Book: reserved
  non-zero lines only, full text (no truncation), +Sector/Cost centre/Appropriation (code+name)
  in registers + oldest-20, Cur/Funds dropped (reporting/db/23 v2, E2E run 82 = 1,385 lines).
  Page: Source (PR/PO) + "Showing figures in" filters, KPI band redesigned w/ semantic accents +
  heat badges (senior-frontend pass), Document # cells deep-link to Fusion (view db/v2/52 +
  GL/db/13 add fusion_header_id/source=). Browser smoke 29/29 — webtier release 20260716050503.
- **2026-07-16** — **Encumbrances – Pending Approval page + ENC_PENDING_BOOK briefing book**
  (`APP_VERSION` 1.27.0). New nav tab: every PR/PO document PENDING APPROVAL in Fusion (daily BIP
  snapshot `atd_pr_po_pending_approval`, otbi-atd/db/47) joined to the open-encumbrance line detail —
  view `DCT_PR_PO_PENDING_V` (db/v2/52, BUTIL_END-aware, `in_extract` coverage leg), ORDS `GL/db/13`
  (`GET /gl/pending` register + server-side KPIs/aging/approvers/unmatched in one scan; book bridge
  `POST /gl/pending/book` + status + pdf). Page reuses the butil filter bar + shared
  `<interactive-report>` (section `pend`), 4 composite KPI tiles + aging/top-approver mini tables +
  extract-coverage note + Briefing Book button. Reporting: `ENC_PENDING_BOOK` (reporting/db/23,
  MULTI/PYTHON, 9 sections; template `enc_pending_book.html.j2` DB-stored) — E2E 67-page PDF
  reconciles to the page. API smoke 20/20 + browser smoke 21/21 EN/AR — webtier release
  20260716025748. **GL post-05 re-run list now = 07+08+09+10+11+12+13.**
- **2026-07-02** — **Budget Utilization: KPI-card aggregate drill-down** (`APP_VERSION` 1.8.0). The four
  KPI cards (Actual AP/GRN/Commitment PR/Obligation PO) are now clickable → all supporting lines across
  the current filters, in the same drawer (adds Project/Task cols + "top N of M" note). `/gl/butil/lines`
  extended: `year+metric` with `project[+task+etype]` (row) OR `projecttype/sector/search` (aggregate),
  one `kys` CTE + window totals; PO/PR header/line joins de-duped (fixed aggregate PO fan-out). DEPLOYED
  as ADMIN; live totals reconcile row + aggregate; drawer Playwright-verified.
- **2026-07-02** — **Budget Utilization: per-figure drill-down** (`APP_VERSION` 1.7.0). The four money
  cells (Actual AP / Actual GRN / Commitment PR / Obligation PO) on each Budget Utilization row are
  clickable → supporting transaction lines in a **right-edge slide-in drawer** (`.dw-*`, mirrors the
  platform edit-drawer). Additive ORDS `GET /gl/butil/lines?year=&project=&task=&etype=&metric=`
  (`ap|grn|pr|po`) in `db/07` — totals reconcile to the row figure (verified against live 2026 data).
  **Deploy `db/07` as ADMIN in a fresh session** (ORDS is ADMIN-owned).
  Real requisitions (`ATD_PR_*`, `db/v2/36` `DCT_PR_COMMITMENT_PERIOD_V`) drive Commitment
  (Total=Reserved+Liquidated / Open=Reserved / Pipeline=Not-reserved). PO split into Total (ex
  Failed/Passed) / Open (Reserved+Partial **GRN-netted**) / Pipeline (Failed/Passed), de-duped by
  `po_distribution_id`. `db/v2/34` rewritten (+`open_encumbrance_ytd`, +`funds_available_calc_ytd`).
  ORDS `/actuals` new figures + PR/PO/pipeline drills (`prod.`-qualified, no new synonyms). Frontend =
  **grouped cells** (Total/Open/Pipeline) + Funds GL/Calc + 14 KPI cards. Deploy: `db/v2/36` →
  `db/v2/34` → `05_gl_ords.sql`. Verified live SQL + drills + node --check + mock-render (0 err).
  Currency caveat: PR AED via `DCT_CURRENCY_CODES` snapshot (only rate source).
- **2026-07-01** — **Actuals: AP Direct redefine + SLA Actual + PO/PR counts** (`APP_VERSION` 1.4.0).
  #1 **AP Direct** = AP lines with `po_number IS NULL` (true direct AP; drops `ap_po_match`); 06-2026
  1.322B → 1.292B. #2 **SLA Actual** = GRN + AP Direct (≈2.27B) — KPI card + column. #5 **po_count/
  pr_count** per combination → Obligation/Commitment cells show amount + "N POs"/"N PRs" sub-line.
  `db/v2/34` + `05_gl_ords.sql`. Verified live SQL + drill query + `node --check` + mock-render (0 err).
  **Pending (Batch B, user's PR_HEADER/PR_LINES/PR_DISTRIBUTIONS tables):** #3 Open Commitment from
  real PR source, #4 Encumbrance = Open PR + Open PO, #6 second Funds Available figure.
- **2026-06-30** — **Actuals: Open Commitment / Open Obligation + visible ⓘ hint** (`APP_VERSION` 1.3.0).
  Added `open_commitment_ytd` + `open_obligation_ytd` (the unliquidated subset =
  `FUNDS_STATUS IN ('Reserved','Partially Liquidated')`, de-duped) to `DCT_BUDGET_ACTUAL_PERIOD_V`
  (`db/v2/34`, live from `po_distributions`); ORDS `/actuals` (+openCommitment/openObligation in
  totals+items + as `source` values), `/actuals/lines` (+openCommitment→open PR lines, +openObligation
  →open PO lines). Frontend: 2 KPI cards + 2 drillable columns + visible ⓘ hint markers on the four
  PO-derived headers (wording kept) + 2 source-filter options + CSV. 06-2026 open = 723.08M (both).
  Verified live SQL + handler harness + `node --check` + Playwright mock-render (0 errors).
- **2026-06-30** — **Actuals: Commitment/Obligation + filters + full width** (`APP_VERSION` 1.2.0).
  Added `commitment_ytd` (PR-backed) + `obligation_ytd` (all PO) to `DCT_BUDGET_ACTUAL_PERIOD_V`
  (`db/v2/34`, read live from `po_distributions`); ORDS `/actuals/filters` (+accounts/costCenters),
  `/actuals` (+account/costcenter/source filters, +commitment/obligation), `/actuals/lines`
  (+commitment→PR lines, +obligation→PO lines). Frontend: full-viewport-width Actuals + Dashboard,
  3 new filters, 2 new KPI cards + 2 drillable columns, CSV updated. Verified via live SQL + handler
  query harness (no ORA errors), `node --check`, KO balance.
- **2026-06-30** — **Actuals reporting + Executive dashboard** (`APP_VERSION` 1.1.0). Added the
  **Actuals** (Budget vs Actual, YTD per combination — period/sector/chapter/program/appropriation
  filters, business-question cards, per-figure drill-down, combination tooltip, CSV) and
  **Dashboard** (utilisation gauge, period-over-period trend, by sector/program/appropriation,
  auto-insights — hand-built SVG/CSS) pages; **Refresh actuals** button (Overview/Actuals/Dashboard
  + ATD). ORDS `/actuals/filters|/actuals|/actuals/lines|/dashboard|POST /actuals/refresh`. DB
  `db/v2/34` (+appropriation) + `db/v2/35` (hourly job). Verified via live SQL probes, handler JSON
  harness, and a Playwright mock-render (0 console errors).
- **2026-06-28** — Initial build, all layers deployed to PROD and verified end-to-end.
  Brand `#3F6F5F`. `APP_VERSION` 1.0.0. Source CSVs preserved in `db/source/`.

## Known follow-ups
- **DCT Program mappings cover 33 of 35** used program codes (matched to PBB by description);
  the 2 unmatched can be mapped manually on the Mapping page.
- **`DCT_GL_BALANCES_V`** enriches Sector only (the `ATD_GL_BALANCES` feed is currently empty;
  Chapter/Program enrichment to be added once it carries parseable segments).
- **Sector seed** uses the latest cost-center column with a `2024-01-01` baseline start; historical
  closed ranges (2018–2023) can be added on the Mapping page when needed.
## 2026-08-31 — Revenue Categories (v1.97.0)

- LIVE under Settings → Revenue Categories.
- GL/db/36 owns the category hierarchy, mapping rules, access assignments and
  eight additive ORDS handlers. Production starts empty; no mockup data seeded.
- Webtier release: `20260831232838`.
