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
- **2026-09-08 (2)** — MSS report: **Task Name beside every Task Number on ALL sheets**
  (`APP_VERSION` **1.122.1**, reporting/db/46 re-run — sheets 2/3/6/7 via the tnm map, sheet 8
  exposes the PBT line's native task_name; webtier overlay 20260908162307). mss_register_api_smoke
  **38/38** · browser **12/12**.
- **2026-09-08** — **MSS - Projects Budget Utilization report** (`APP_VERSION` **1.122.0**): NEW
  definition `MSS_BUTIL_REGISTER` (reporting/db/46 — register copy w/ FIXED 26-col sheet 1
  [Task Number kept + Task Name], Requester on sheets 2–6 [AP = matched PO line via the
  line-grain rule + invoice_date disambiguator; GRN/PO = PO requestor; PR = requisition
  requester; Pending = per doc], Task Name on sheets 4–5; per-section JSON_VALUE→REPLACE→
  JSON_TRANSFORM surgery w/ asserted patterns; re-run 46 after any 25 re-run) + NEW GL/db/53
  bridge `/gl/butil/mssxlsx[/:id[/file]]` (**GL post-05 re-run list = 07..53**) + Generate
  Report ▾ entry 5 of 6. Tests: mss_register_api_smoke 30/30 (live run, per-sheet layout +
  fill verified) · mss_register_browser_smoke 12/12 EN+AR.
- **2026-09-07** — **FBP - Projects Budget Utilization report** (`APP_VERSION` **1.120.0**, webtier
  GL-only overlay 20260907144600): NEW definition `FBP_BUTIL_REGISTER` (reporting/db/45 — copy of
  BUDGET_UTIL_REGISTER with a FIXED 21-column sheet 1: Task Name replaces Task Number, the sample's
  19 red-marked columns removed; re-run 45 after any 25 re-run) + NEW GL/db/52 bridge
  `/gl/butil/fbpxlsx[/:id[/file]]` (no sheetcols — Manage Columns never affects it; **GL post-05
  re-run list = 07..52**) + Generate Report ▾ entry 4 of 5. Tests: fbp_register_api_smoke 18/18
  (live run #1103, workbook layout verified) · fbp_register_browser_smoke 12/12 EN+AR (deployed).
- **2026-09-06 (3)** — **PLATFORM RULE: budget = expense side only** (`APP_VERSION` **1.117.0**, webtier
  GL-only overlay 20260906111321): the 3270xx Treasury-contribution funding mirror is dropped at
  `GL_BALANCES_CC` (db/v2/32) + `DCT_EBS_BALANCE_MAPPED_V` (110); `DCT_BUDGET_ACTUAL(_PERIOD)_V` (32/34)
  expense-only; YoY both legs `LIKE '4%'` (GL/db/18 + reporting/db/32); GL/db/04 re-issued as the SINGLE
  SOURCE of `DCT_GL_COA_V` (38/39/40 restored after the 2026-09-05 Entity re-run had reverted them, Entity
  kept). Period view 09-2026 = 8,851,453,715 = the Budget Status bands; footnote reworded. Tests: fd_api 144/144 · dof_api 31/31 (after the DETAIL fix) · entity_class_api 30/30 (after the kick fix) · mappings_api 11/11 · sectorperf_api 70/70 (incl. RECON vs /gl/butil) · fd_browser 190/190 · yoy_browser 24/24 (both legs expense-scoped) · legacy_browser 17/17 · recon_browser 27/29 (the 2 = the pre-existing 'no console errors' checks tripped by the shared shell's js/i18n 404 probes — the same 2 recorded on 2026-07-25; every functional check passes EN+AR) — all on the local tree with the new views; frontend release verified live (APP_VERSION 1.117.0 + footnote marker).
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
## 2026-09-03 — FD Dashboard / Budget Status (v1.102.0)

- LIVE under General Ledger → Budget Status (right after Financial Performance).
- User sketch → 3 mockups (`final apps/BI/docs/FD Dashboard/mockups/`) → mockup A "Ring Bands".
- Webtier release: `20260903110916` (rollback `20260902122830`).
- GL/db/42 `GET /gl/fd/status` (additive; post-05 list = 07..42). Same basis as the FMR tab,
  reconciles to `/gl/fmr/entity` to the cent (fd_api_smoke 47/47, fd_browser_smoke 55/55 EN+AR).
- 2026-09-03 v1.103.0: every band figure drills (GL/db/43 `GET /gl/fd/lines`, full 10-segment
  combination grain + the shared segment-description popover); post-05 list = 07..43;
  fd_api_smoke 90/90 · fd_browser_smoke 72/72 EN+AR. Webtier release `20260903121501` (rollback `20260903110916`).
- 2026-09-03 v1.104.0: Departments (Cost Centres) card region under Sectors (multi-select, text
  filter; cube at cost-centre grain, drill `costcenter=`); fd_api_smoke 104/104 · fd_browser_smoke 95/95.
  Webtier release `20260903140645` (rollback `20260903121501`).
- 2026-09-03 v1.105.0: Budget Status PRESENTATION switch — Search parameter renders the Sectors +
  Departments regions as Composition tiles (default) / Ledger rows / Proportional map (treemap), same
  multi-select state, remembered in this browser; state pills + map heat on the echoed vs-Budget
  thresholds (GL/db/42 re-run, `thresholds{near,over}`); departments top-N + Show all. fd_api_smoke
  105/105 · fd_browser_smoke 129/129 EN+AR (local + deployed). Webtier release `20260903155452`
  (rollback `20260903140645`).
- 2026-09-03 v1.106.0: Budget Status — Presentation = radio option cards + formatted reading hint
  (thresholds + legend), explicit Sort (budget amount default · % used · % free · name) on Sectors AND
  Departments, coloured ⓘ hint strips inside both regions (lead + tip + sort + top-N + legend).
  Advisory only: balance-by-period ring hint (3 mockups in BI/docs/FD Dashboard/mockups, timings in
  deployment-notes). fd_browser_smoke 140/140 EN+AR (local + deployed). Webtier release
  `20260903161739` (rollback `20260903155452`).
- 2026-09-03 v1.107.0: Budget Status — approach A: GL/db/42 = ONE scan for the whole year
  (`series[]` per cube key × period + `periods[]` + `excludedByPeriod{}`; anchor rows/LOVs collected
  from the same pass — 3.0 s / 221 KB, was 6.6 s with a second scan); period switch inside the year is
  client-side (no request); Mockup-2 "monthly movement" hover popover on every ring + the Fund
  square (brought-forward pale + month movement strong, negative in red, one scale, avg month).
  fd_api_smoke 113/113 · fd_browser_smoke 156/156 EN+AR (local + deployed). Webtier release
  `20260903173502` (rollback `20260903161739`).
- 2026-09-03 v1.108.0: Budget Status — the monthly-movement popover on every SECTOR + DEPARTMENT
  card in all three presentations (card = Actual, a figure inside = that measure, 4-measure chip
  strip; sector = BU scope, department = BU ∩ picked sectors — last bar == the card figure; no
  request, summed from the loaded year series). fd_browser_smoke 172/172 EN+AR (local + deployed).
  Webtier release `20260903175814` (rollback `20260903173502`).
- 2026-09-04 v1.109.0: Budget Status — Presentation parameter = vertical radio stack pinned to the
  end side of the Search grid (last two columns, spans criteria + hint rows, dense flow, RTL mirror);
  "Business unit" → "Entity" / "All entities" (EN+AR). fd_browser_smoke 175/175 EN+AR (local +
  deployed). Webtier release `20260904044956` (rollback `20260903175814`).
- 2026-09-04 v1.110.0: Budget Status — the Chapter ring bands moved to be the FIRST region after
  Search (order now Chapters → Sectors → Departments; user, urgent). Frontend only (index.html block move +
  `.fd-bands` margin-bottom); smoke 176/176 EN+AR; webtier GL-only overlay release 20260904074820.
- 2026-09-04 v1.111.0: Budget Status — TOTAL band on top of the chapter rings (Budget / Actual /
  Encumbrance / Fund Available summed over Chapters 1–3, same scope as the bands; drills + hover ladder
  with no chapter predicate; user, urgent). Frontend only; smoke 184/184 EN+AR; webtier GL-only overlay
  release 20260904080059.
- 2026-09-04 v1.112.0: Budget Status — Chapter 4 (Subsidy) + Chapter 5 (Aids & Grants) bands (user,
  urgent). GL/db/42 + 43 re-run: band rule = chapter × budget-group PAIRS (CH1–3 → bg 1, CH4 → bg 3,
  CH5 → bg 5 — CH4/CH5 have NOTHING on bg 1); Total band = Chapters 1–5; Budget sub-label names each
  band's own budget group. API smoke 144/144 (FMR reconciliation scoped to CH1–3) + browser 188/188 EN+AR;
  webtier GL-only overlay release 20260904081416.
- 2026-09-04 GL/db/46: FIX — `PUT /gl/mappings/:id` (assignment end date / dates / notes from the
  Classification-values drawer + Manage CoA Mapping modal) returned ORDS 555 since birth (scalar
  subquery inside a PL/SQL expression = PLS-00405); rewritten to SELECT INTO locals; synced into 05.
  mappings_api_smoke 11/11 + live drawer probe. Post-05 re-run list now ends at 46.
- 2026-09-06 v1.115.0 Sector Performance Report: NEW Generate Report menu entry running
  SECTOR_PERF_BOOK (reporting/db/42 = a copy of BUDGET_UTIL_BOOK with a distribution cover:
  DCT logo top-right + copyright line on EVERY page via the NEW render_pdf.py
  pdf-header/pdf-footer hook, "YTD MM-YYYY" subtitle, no parameter chips/description/generated
  block, prepared by Financial Planning and Reporting) through NEW bridge GL/db/50
  POST /gl/butil/sectorbook (+ :id + :id/pdf). Re-run reporting/db/42 after any db/21 re-run;
  GL post-05 re-run list now includes 50. sector_book_api_smoke.py live-run PASS.
- 2026-09-06 v1.114.0 + GL/db/47+48: ENTITY = a 4th date-tracked classification (rules on ANY of the
  10 GL segments, one Entity rule per combination enforced, DCT flagged Default, Unclassified bucket)
  replacing the hard-coded CASE in fd/status, fd/lines, fmr/*, sector-perf and the FMR/Budget-Status
  report definitions; every classification write now fires the COA-snapshot + butil-cache refresh
  jobs asynchronously. entity_class_api_smoke 30/30 · entity_class_browser_smoke 23/23 ·
  fd_api_smoke 144/144. Post-05 re-run list now ends at 48. Webtier release 20260905202533.

- 2026-09-06 v1.113.0 Budget Status: compact right-side Presentation rail; Show Summary
  unchecked on load/Reset; Print PDF/PPT via GL/db/49 and reporting/db/41
  (`GL_BUDGET_STATUS`, no recipients). Worker renderer deployed vm180/181/182.
  Webtier overlay 20260905201058, preserved by subsequent GL releases. Live report
  API 51/51, browser regression 190/190, actual Print/layout 14/14. Details and
  rollback cautions: docs/budget-status-review.md. Post-05 rebuilds must include db/49
  in addition to the independent db/47+48 and db/50 changes.
- 2026-09-06 (2) Sector Performance Report cover feedback (template-only re-upload): logo
  clearance fixed (13mm logo + 2mm padding — Chromium header box has ~5.5mm inherent offset;
  was clipping the teal band), title on one line, new "Sector: ..." line under the YTD (brackets removed per user feedback 2026-09-06, template-only re-upload)
  subtitle. Live run re-verified page-1.

- 2026-09-06 v1.115.1 Budget Status correction: Show Summary controls ALL formatted
  graph summaries (rings/Fund, sectors, departments; tiles/rows/map). Default false,
  immediate close on uncheck; selection/drills preserved. GL-only overlay release
  20260906020630 over 20260905202533. No DB or reporting-worker changes.
- 2026-09-06 (3) v1.116.0 Sector Performance Report ONE-SECTOR rule (user-approved "both
  ends"): bridge 400s without exactly one sector (GL/db/50 re-run), BI drawer sector
  required via db/42 param-spec merge-patch (hint rewritten from "Optional"), menu entry
  disabled + hint until the Sector filter is picked. Webtier GL overlay 20260906061035.
  Smokes: api (sector guardrails) + browser 15/15.

## 2026-09-06 — Budget Status deep review, GL 1.116.1

Deployed release `/var/www/ifinance-releases/20260906104833`, previous `/var/www/ifinance-releases/20260906061035`. Only Budget Status frontend hunks plus the version changed; concurrent GL work was preserved using the live baseline and hashes. Report workers vm180/181/182 were paused until idle, updated, restarted and verified active. Worker backups: `/opt/rpt-worker/backups/fd-deep-20260906`. Only `render_fd.py` and `templates/gl_budget_status.html.j2` changed. Fresh SQLcl deployed `GL/db/49_gl_fd_report_ords.sql`; handlers backed up in round-4 evidence.

Fixes: recover invalid saved settings/storage failures; prevent stale search responses/errors; clear errors on cached-period selection; keyboard Search toggle and accessible criteria/entity state; hide hover instructions when Show Summary is off; configured Entity names in collapsed Search; active Entity classification validation for export; exact/automatic export numeric parity; measured continuation-page pagination retaining complete entries and correct page numbering. User-approved zero-budget behavior: Ledger rows with a No budget allocated notice instead of an empty map, independently for sectors/departments, on screen and in PDF/PPT.

Verification: live browser 190/190, live Show Summary 67/67, six live PDF/PPT reports 51/51; local deep browser 40/40, export fidelity 85/85, reopened PDF/PPT artifacts 24/24, report unit tests 4/4; initial API baseline 144/144. Deployed deep browser checks passed 40/40; configured entity plus Unclassified exports passed 11/11. UAT: `UAT/UAT_GL_round4-06-09-2026/` workbook, Word results and evidence.

Access tests: two temporary accounts verified owner downloads and cross-user 404 (including another privileged user); accounts/sessions removed. Current `FEATURE_SEC_ENFORCE_GL` compatibility behavior permits report submission without the dedicated privilege. This policy remains unchanged pending the user's explicit decision. Automatic approval review initially blocked the additional entity test; the user explicitly authorized the built-in quick login, and the test then passed 11/11 across all configured entities and Unclassified. Regular live PDF/PPT exports passed. No financial data changed and no reports were emailed.

Rollback: reverse only this review's hunks if subsequent changes exist; otherwise the previous release above is available. Restore the two worker backup files and restart safely. ORDS source backup is retained with round-4 evidence. Do not revert unrelated GL changes.

## 2026-09-06 — Terms and Key definitions (GL 1.118.0, db/v2/129 + GL/db/51 + reporting/db/42 re-run)

New Settings → Terms and Key definitions page (capability-hidden, GL_MANAGE_TERMS/SYS_ADMIN): register of rich-text definition documents (`DCT_GL_REPORT_TERMS` — title, applied-to lookup seeded Sector Performance, CLOB content, start/end dates, lookup status) with a drawer holding the vendored Quill 2.0.3 editor (UMD before require.js; textarea fallback). The ACTIVE document at the report's period end prints as content entry 01 "Terms and Key definitions" of the Sector Performance Report with identical formatting — SECTOR_PERF_BOOK's copied source_ref gets the section PREPENDED on every db/42 refresh, template contents + parts renumbered 02..08. The 7 initial terms seeded per the user's list. Gotchas burned: block-local function in SQL DML = uncatchable 555; dct_rest.parse_body caps bodies at 32,767 bytes (full-CLOB CONVERTTOCLOB parse in the write handlers); Playwright must edit through Quill's model, not .ql-editor innerHTML.

Deployed: db/v2/129 → GL/db/51 → reporting/db/42 → datasource.py fleet sync + rpt-worker restart ×3 → template 99,351 B upload + fallbacks → webtier overlay 20260906154050 (rollback 20260906111321). GL post-05 re-run list = 07..51. Tests: terms_api_smoke 19/19 · terms_browser_smoke 17/17 EN+AR · live render run #1054 (terms as Part 1, contents 01–08).

## 2026-09-06 — Sector Performance Report: Overview page rework (report-only, reporting/db/42 re-run + template)

The report's Part 02 "Budget Utilization Overview" rebuilt per the user's 9 annotations: Actual-vs-Plan % on the YTD Plan tile, amount-based %Paid on the AP and GRN tiles, Utilization tile → Actual/Budget % (YTD actual ÷ adjusted ANNUAL budget — the standing vs-Budget rule), Top-sectors chart removed, Utilization-by-Department bars (top 10 by budget), and two new tables — Sector Overview (Opex/Capex/Total, Opex+Capex only) and By Department (Annual Budget/Actual/Encumbrance/Fund Available/Actual/Budget %/Actual/Plan %). Data = three new sections (sp_extra/sp_dept/sp_kind) injected by db/42 over DCT_SECTOR_PERF_V (cost adjustments folded, reconciles to /gl/butil sum-for-sum). No GL frontend change. Verified on live run #1058 (Support Service, YTD 09-2026, 47 pages).

## 2026-09-06 — Sector Performance Report: Overview feedback round 2 (report-only)

Six annotated fixes: Actual-vs-Plan % on one line; composition-bar percentages printed inside their segments; department bars and table carry the cost-centre code + full department name (sp_dept regrained to cost_centre × department); Sector Overview footnote explains the Opex+Capex-only total vs the whole-scope KPI (the 299.80M vs 309.30M question); table retitled "Budget overview by Department" with a Total row reconciling to the KPI band (309.30M / 107.80M / 34.90% / 63.70%) and centred headers; part-band scope line shows the full project type. reporting/db/42 re-run + template upload; verified live run #1060.

## 2026-09-06 — Sector Performance Report targets Opex + Capex (GL 1.119.0 + reporting/db/42 re-run)

User-approved rule: the report covers the Opex + Capex chapters BY DEFAULT — db/42 rewrites every section's chapter predicate to NVL(:chapter, 'Chapter 2|Chapter 3') (default resolved from the chapter classification at seed time), so the default holds from the GL bridge, the BI run drawer and schedules alike. Flexibility = the existing Search → Chapter multi-select overrides it (pick Chapter 1 to include Payroll, etc.). Sector Overview table now lists every kind in scope and its Total always equals the KPI band (no more 299.8-vs-309.3 gap); cover prints "Scope: Opex + Capex" and the band names the chapter scope. GL menu hint mentions the default (v1.119.0, webtier 20260906194839, rollback 20260906120807). Verified runs #1061 (default) + #1062 (Ch 1|2|3 → Payroll row, totals 309.3 everywhere).

## 2026-09-06 — Sector Performance Report: content restructure — Top 10 Projects + per-department pages (report-only, reporting/db/42 re-run + template)

User-approved round: Part-02's 2.1 "Utilization by sector" and 2.2 "Budget lines under pressure" tables removed (a one-sector report made 2.1 a one-row duplicate of the KPI band). NEW content entry 03 "Top 10 Projects Budget" — the 10 largest task budget lines in scope (project × task, ordered by annual budget) with Project Number/Name, Task, Annual Budget, YTD Plan, Actual, Encumbrance, Fund Available and both utilization ratios + a Total row (ratios recomputed from sums). Task display rule (user): a plain-number task number (the MSS style: 2, 4, 5…) prints the task NAME instead (ATD_TASKS project-scoped); code-bearing DCT task numbers print as-is. NEW content entry 04 "Top 5 Projects Budget by Department" — one page per department of the sector (largest budget first), each a full Part-02 replica scoped to that department: 8-tile KPI band + composition bar (extended sp_dept row), Utilization-by-Project bars and Budget-overview-by-Project table for its top 5 projects by budget (full project number · name, Total of the shown five, "top 5 of N — remaining budget" note). Old parts 03–08 renumbered 05–10 (TOC, bands, footers, cross-references). db/42 adds sections sp_top10/sp_dkind/sp_dproj and extends sp_dept; all on DCT_SECTOR_PERF_V under the Opex+Capex default chapter scope, so every figure reconciles to /gl/butil. No GL frontend change. Verified live runs #1063 (default, 50 pages, 7 department pages each matching its By-Department row) and the widened-chapter run.

## 2026-09-06 — Sector Performance Report: Part 05 Actuals rework (report-only, reporting/db/42 re-run + template)

User-annotated round on "Actuals — Supplier Invoices & Goods Receipts": ① Monthly actuals AP-vs-GRN chart removed; the Top-10-suppliers panel takes the full width. ② Supplier bars show the full supplier name plus "(N invoices)" — a new sp_supp section counts each supplier's DISTINCT invoices across BOTH legs (user-approved): the direct AP invoices of the register plus the PO-matched invoices behind the in-scope goods receipts, with the register's own exclusions so the names match the bars exactly; an uninvoiced-only supplier reads "(0 invoices)". ③ New Paid KPI tile (before Top Supplier Share): total paid amount and % of the Total Actual — sp_extra now ships ap_paid_aed + grn_paid_aed alongside the percentages. ④ The AP Invoices (Direct) and GRN Receipts tiles carry the same bold "X% paid" figures as the Part 02 overview, from the same section, so the two parts always agree. No GL frontend change. Verified live run #1065.

## 2026-09-06 — Sector Performance Report: Paid% on the Top-10 supplier bars (report-only, reporting/db/42 re-run + template)

User picked the "two-tone bar" style from three proposed options: each supplier's spend bar now shows a green PAID portion with the gold remainder unpaid, the value column reads "25.20 M · 89.60% paid", and a legend explains the tones. Per-supplier paid figures extend the sp_supp section — the direct AP counted amounts and the PO-matched invoices behind the in-scope receipts, each weighted by the invoice header's paid ratio (capped, so the % can never exceed 100); summed across suppliers the legs equal the Paid KPI tile, so the chart and the KPI always agree. A supplier with no billed invoices keeps a solid gold bar. Verified live run #1067 (0% row solid gold, 100% rows solid green, 49.7% row half-and-half).

## 2026-09-06 — Sector Performance Report: Part 06 Open Obligations round (+ Part 07 same fix; report-only, template)

The "Largest Single Line" KPI showed a bogus 3 K: the PO register is project-ordered, and the KPI/chart read the FIRST row as the largest — the "Largest open PO lines" bars were divided by that 3 K and overflowed. The template now sorts the PO (and PR — same latent bug) lines by amount: the KPI reads the true largest line with a self-explaining sub-line ("the biggest single open PO line — PO 451102004891/1 · MIDEAST DATA SYSTEMS L.L.C"), the charts show proper proportional bars sorted by amount with FULL supplier names, and the 6.1/7.1 registers finally honour their "ordered by amount" headings. The Top-10-suppliers-by-open-obligation labels now read "Full Supplier Name (N POs · share-of-open-obligation %)". Verified live run #1068.

## 2026-09-06 — Sector Performance Report: Part 07 rework + new Appendix (report-only, reporting/db/42 re-run + template)

Open Commitments (PRs) round: the Largest-open-requisition-lines chart now shows "PR number(Line) - Requester name" (real display names, not usernames), sorted by amount, with how many days each line's funds have been reserved ("4.40 M · 41 days" — days from the funds-reservation budget date); the Largest Single Line KPI names its PR, line and requester, and a KPI-guide footnote at the bottom of both the PO and PR pages explains the KPI in plain words. NEW content point "A — Appendix — Detailed Registers" after Observations & Insights: the four full line-level registers moved there — A.1 AP invoices charged directly (with a new Paid % column and the overall paid % on the Total row), A.2 Goods receipts (with a Paid % column per receipt line = paid ÷ invoiced of its matched invoices), A.3 Open purchase-order lines, A.4 Open purchase-requisition lines. Parts 05–07 keep their overview pages only. Verified live runs #1069 and #1070.

## 2026-09-06 — Sector Performance Report: Pending Approvals sorted + Plan Performance by Department (report-only, reporting/db/42 re-run + template)

Pending Approvals (PR & PO Queue): every chart and the 8.1 table now sort by amount — the aging ladder keeps its day-bucket labels but orders rows by pending value, and the top-approvers chart/table are guaranteed amount-descending. Expenditure Plan Performance re-based to Department: a new sp_dplan section (the by-sector plan logic re-grained to cost centre over DCT_SECTOR_PERF_V, with the GL module settings driving the Below/Within/Ahead status) powers the "Plan execution by Department" and "Plan coverage by Department" charts and the "9.1 Plan vs actual by Department" table — all labelled "Full Department Name (CC code)", ordered largest annual budget first. Removed per user decision ("Both"): the 9.2 Largest-deviations-from-plan table and the explanatory paragraph at the page bottom. Verified live run #1071.

## 2026-09-06 — Sector Performance Report: Part 10 removed + "% of Budget Planned" rename (report-only, template)

User audit round. The negative Uninvoiced AED question was answered with a live trace (AD BURGER PO 451102008430: one 4,800 receipt vs 10,360 invoiced — a 5,560 invoice was matched to the PO with no goods receipt recorded; negative uninvoiced flags invoicing ahead of the GRN, not a calculation error). Part 10 "Observations & Insights" — the only content point never specified by the user — removed entirely (insight paragraphs + methodology block + TOC row); the report now runs 01–09 plus the Appendix. The "Plan Coverage" KPI renamed "% of Budget Planned" on the Part 09 tile, the by-Department chart title and the 9.1 column, per the user's pick from four offered names. Verified live run #1072 (75 pages).

## 2026-09-06 — Line-grain PO rule (platform fix; root cause of the negative Uninvoiced)

The −5,560 Uninvoiced row was traced to its root cause: invoice 40626-2 was re-matched in Fusion from PO 451102008430 to 451102008216 on 24-Aug — the correction updates the invoice LINE, while the accounted distributions keep the original PO, and the OTBI extracts faithfully report both grains. Nine invoices / 157,059 AED were mis-attributed platform-wide. User-approved fix (Wave 1+2): every AP-distribution→PO join now takes the invoice line's PO reference first (COALESCE line→dist) — applied across the reporting books/registers, the uninvoiced-GRN view, DCT_ACTUAL_V / DCT_BUDGET_ACTUAL_V charge-account attribution, the PO/Project/Task document views, the live butil/lines GRN drill and the AP dashboards. Verified: zero mis-attributions remain, actuals totals unchanged to the cent, both AD Burger POs now read 100% invoiced / 0 uninvoiced exactly as Fusion shows (report run #1073).
