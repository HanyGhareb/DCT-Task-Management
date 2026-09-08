# General Ledger (App 210) — Deployment Notes

Canonical platform-wide SQLcl/ORDS rules live in `final apps/Admin/docs/deployment-notes.md §2`.
This file holds GL-specific deploy steps, history, and gotchas. **Update on every deploy.**

- **2026-09-07 — URL hash deep links + Budget Status direct link (v1.121.0, frontend-only + 1 nginx line).** GL now routes from `location.hash`: `#<tab id>` (or the friendly alias `#budget-status` → `fd`) opens that tab, `go()` mirrors the route back into the hash via `history.replaceState` (F5 / bookmarks / shared links restore the tab; unknown hashes fall back to `butil`; alias map `HASH_ALIAS`/`HASH_LABEL` next to `NAV_GROUPS`). **Login round-trip**: the session gate + 401 redirect send `?return=<path+hash>` to `/dct/index.html`, and Admin's `onLogin` (4.7.30) honours a same-origin relative `?return=` (blocks `//host` and `/ords`) — so a session-less user who opens the link signs in and lands straight on Budget Status. Short URL: `https://129.151.159.189/budget-status` (nginx 302 in webtier/ifinance.conf). The distributable link: `https://129.151.159.189/GL/Jet/index.html#budget-status`. Smoke `tests/deeplink_browser_smoke.py` — local 10/10 + PROD 11/11 (incl. the open-redirect guard + short URL).

- **2026-09-08 (2) — MSS report: Task Name beside EVERY Task Number (v1.122.1, reporting/db/46 re-run + hint text).**
  User request: Task Name on ALL sheets carrying Task Number — sheets 1/4/5 already had it, so
  db/46 grew surgeries adding it (always right after Task Number) to **sheet 2** (both UNION
  legs — tnm join added to the AP view leg AND the cost-adjustment leg, `NULL`-free: UNION
  column alignment means BOTH legs must emit it), **sheet 3** (tnm CTE + join before the
  `WHERE x.project_number NOT LIKE '#%'` anchor), **sheet 6** (tnm join chained after pendrq),
  **sheet 7** (inline tnm join on the comments SQL — no scope CTE there) and **sheet 8**
  (the PBT line carries its OWN `task_name`, kept in the inner query since 2026-08-30 — just
  exposed, marker `MSS_ADD bttn`). getsql/keyof/key-assert extended to sections 6–7 (keys
  `comments`/`budget_trx`). Frontend = buMssHint wording only (EN+AR). Fill on the live run:
  sheet 2 = 5,364/5,364 · sheet 3 = 5,133/5,133 · sheet 8 = 4,627/4,627. Webtier GL-only
  overlay **20260908162307** (rollback 20260908113029). Tests: `mss_register_api_smoke.py`
  **38/38** (Task Name position + fill on every sheet) · `mss_register_browser_smoke.py`
  **12/12 EN+AR** deployed. Deploy gotcha (recurred): a Python TEXT-mode read of a CRLF .sql
  converts it LF — always read `newline=''` and re-emit CRLF.
- **2026-09-08 — MSS - Projects Budget Utilization report (v1.122.0, NEW reporting/db/46 + NEW GL/db/53 + frontend).**
  Sibling of the FBP report, per the marked-up sample
  `docs/Reports/FMR/MSS Budget_Utilization_Register_2026.xlsx` (red fill = drop, green = add).
  ① NEW **`reporting/db/46_rpt_mss_butil_register.sql`** = definition **`MSS_BUTIL_REGISTER`**,
  a copy of BUDGET_UTIL_REGISTER patched **per SECTION**: each section's SQL is pulled out with
  `JSON_VALUE` (⚠ **a JSON path must be a LITERAL** — `'$.sections['||i||']'` = ORA-40597; one
  static path per index), patched with **asserted REPLACEs** (a missing pattern RAISES -20001
  naming the spot, so db/25 drift fails loudly instead of silently dropping a column — caught
  the live section key being `pending`, not `pend`, on the first run) and written back with
  `JSON_TRANSFORM SET`. Sheet 1 = **fixed 26-column wrap** (marker `MSS_FIXED_COLS`): Task
  Number KEPT + Task Name added; Appropriation Code/Name, Dct Program Code/Name, Ytd Budget,
  Budget Status + all 8 plan columns dropped; EBS Account, Budget Utilization Pct/Variance,
  Utilization Pct + the Fund Movement pair kept (`fund_movement_amount__pn` keeps the sign
  tint). **Requester** (user decisions 2026-09-08, header "Requester", after Organization /
  after Preparer Buyer on sheet 6): sheet 2 AP = the **matched PO line's requester** (user rule
  — never the AP header field, which is empty in practice: 1 of 11,900 in 2026; rqmap CTE =
  the LINE-GRAIN PO RULE linkage → `po_distributions.requestor_name`, joined by invoice_number
  **AND invoice_date** — number alone fanned 3 collision rows across suppliers; Direct rows
  legitimately blank, ~0.1% carry their own netted-out PO's requester); sheet 3 GRN = the `b`
  map's `MAX(requestor_name)` (5,108/5,108 filled on the smoke run); sheet 4 Open PO = per
  (PO, line) LISTAGG DISTINCT (2,024/2,030); sheet 5 Open PR = per requisition from
  `pr_distributions.requester` (1,938/1,938); sheet 6 Pending = PR leg `pr_lines` per
  (requisition, line) ∪ PO leg per (order, line) COALESCEd (1,412/1,415). **Task Name** also
  added on sheets 4+5 (tnm map, after Task Number). Sheet 6's earlier deferred columns stay
  deferred; sheets 7–8 untouched. **Re-run db/46 after any db/25 re-run** (refresh restores the
  copy, then re-patches — idempotent). ② NEW **`GL/db/53_gl_mss_register_ords.sql`** additive
  bridge (**GL post-05 re-run list = 07..53**): `POST /gl/butil/mssxlsx` + `GET /:id` +
  `/:id/file`, `report_code = 'MSS_BUTIL_REGISTER'`-scoped, NO sheetcols, gated
  GL_RUN_BRIEFING_BOOK. ③ Frontend: Generate Report ▾ entry 5 of 6 (📙, after FBP) →
  `runBuMss`; i18n repMss/repMssSub/buMssHint/buMssReady/rgGenMss EN+AR. **Deploy gotcha:**
  cloning a CRLF .sql by reading it in Python TEXT mode writes it back LF-only → the SQLcl
  swallowing hazard; read with `newline=''` and re-emit CRLF. Webtier GL-only overlay (see
  STATUS log; built on the parallel session's 20260907231739 /dct-cutover release — version
  taken 1.122.0 because 1.121.0 was claimed by that session). Tests:
  `tests/mss_register_api_smoke.py` **30/30** (guardrails, triple run-code scoping, sheetcols
  ignored, live run → per-sheet layout + requester-fill asserts) ·
  `tests/mss_register_browser_smoke.py` **12/12 EN+AR**.
- **2026-09-07 — FBP - Projects Budget Utilization report (v1.120.0, NEW reporting/db/45 + NEW GL/db/52 + frontend).**
  User request (per the marked-up sample `docs/Reports/FMR/FBP-Budget_Utilization_Register_2026.xlsx`):
  a distribution copy of the Excel register named **"FBP - Projects Budget Utilization"** with
  every red-filled sample header removed and **Task Name in place of Task Number** on sheet 1,
  runnable from the Budget Utilization page's Generate Report menu. ① NEW
  **`reporting/db/45_rpt_fbp_butil_register.sql`** = definition **`FBP_BUTIL_REGISTER`**, a
  verbatim copy of BUDGET_UTIL_REGISTER (db/25) whose copied `bu_lines` SQL is then wrapped in a
  **FIXED 21-column projection** (budget_combination … task_name … fund_available, comments —
  the sample's kept headers, in order; marker `FBP_FIXED_COLS`) via
  `JSON_TRANSFORM(source_ref, SET '$.sections[0].sql' = …)`, so the layout is baked into the
  DEFINITION and holds on EVERY entry point (GL bridge, BI run drawer, schedules) — user
  decision: fixed layout, the page's Manage-Columns view must never affect it (params replace,
  never merge, at enqueue — `NVL(p_params, l_params)` — so a params-level default would NOT
  survive a BI-drawer run; the SQL wrap does). Sheets 2–8 stay verbatim copies ⇒ **re-run
  db/45 after any db/25 re-run**. Sheet 6's two yellow sample headers (Last action date /
  Pending Days from last action) were explicitly DEFERRED — the BIP pending snapshot carries no
  last-action data. ② NEW **`GL/db/52_gl_fbp_register_ords.sql`** additive gl.rest bridge
  (**GL post-05 re-run list = 07..52**): `POST /gl/butil/fbpxlsx` (full butil filter set +
  cmtmode always written, **deliberately NO sheetcols forwarding**) + `GET /:id` + `GET
  /:id/file`, all scoped `report_code = 'FBP_BUTIL_REGISTER'`, gated GL_RUN_BRIEFING_BOOK like
  the register. ③ Frontend: Generate Report ▾ gains entry 4 of 5 **"FBP - Projects Budget
  Utilization (XLSX)"** (📗, after Excel Register) → `runBuFbp` (runBuXlsx clone minus
  sheetcols; Binder popup label `rgGenFbp`; download `FBP_Projects_Budget_Utilization_<year>.xlsx`);
  i18n repFbp/repFbpSub/buFbpHint/buFbpReady/rgGenFbp EN+AR. Deploys: db/45 via Linux SQLcl
  `prod_mcp` (no MERGE, UNISTR Arabic, block <10KB — parse-checked the wrapped SQL via
  DBMS_SQL as PROD), GL/db/52 fresh prod_mcp session, webtier GL-only overlay
  **20260907144600** (rollback 20260906194839). Tests: `tests/fbp_register_api_smoke.py`
  **18/18** (guardrails, run-code scoping both directions, sheetcols ignored, live run #1103 →
  1.8MB workbook: 8 sheets, sheet 1 = exactly the 21 agreed columns in order w/ Task Name and
  all 19 red-marked columns absent, sheets 2/6 untouched) · `tests/fbp_register_browser_smoke.py`
  **12/12 EN+AR** local + deployed (menu entry, hint, enqueue busy + Binder label, RTL).
  Browser-smoke gotcha: the page sets `buYear()` only after `/butil/filters` lands — wait for
  it before clicking a Generate entry or the year-required toast eats the click.
- **2026-09-06 — Terms and Key definitions (v1.118.0, NEW db/v2/129 + GL/db/51 + reporting/db/42 re-run + template + datasource.py LOB fix).**
  User-approved design (one rich-text DOCUMENT per record · Quill editor · GL_MANAGE_TERMS
  privilege · **period-end date basis**). ① NEW table **`DCT_GL_REPORT_TERMS`** (db/v2/129):
  title + `applied_to` (lookup `GL_TERMS_APPLIED_TO`, seeded `SECTOR_PERF` = Sector Performance)
  + `content_html` **CLOB** (never length-limited — user requirement) + start/end date +
  lookup-first status (`GL_TERMS_STATUS` ACTIVE/INACTIVE) + privilege **`GL_MANAGE_TERMS`** +
  the 7 initial terms seeded as one ACTIVE document (YTD Budget/Actual/Plan, Encumbrance,
  Fund Available, Actual/Budget %, Actual/Plan %). ② NEW **GL/db/51** additive gl.rest routes
  `GET/POST /gl/terms` · `GET/PUT/DELETE /gl/terms/:id` · `GET /gl/terms/meta/caps|lookups`
  (reads = GL_VIEW_BUDGET_UTILIZATION NULL-legacy; writes = GL_MANAGE_TERMS/SYS_ADMIN; HTML
  sanitised on save — script blocks / on* attrs / javascript: stripped). **GL post-05 re-run
  list = 07..51.** ③ reporting/db/42 re-run now **PREPENDS a "terms" section** into the copied
  SECTOR_PERF_BOOK source_ref after every refresh (string surgery on `"sections":[`, INSTR
  guard): the ACTIVE document whose start/end window covers the report **period end** (full
  year = 31-Dec) prints as **content entry 01 "Terms and Key definitions"** — the template's
  contents index + part numbers all shifted +1 (Overview = 02 … Observations = 08). ④ UI:
  new **Settings → Terms and Key definitions** tab (capability-hidden via `/terms/meta/caps`,
  manager-only), register + `.dw-tk` drawer with the **Quill 2.0.3 rich-text editor**
  (vendored `GL/Jet/lib/quill/`, loaded as a UMD script BEFORE require.js in the index.html
  boot chain — lazy AMD load would hit the anonymous-define collision; drawer degrades to a
  raw-HTML textarea if Quill fails to load). Saved HTML renders in the PDF with the exact
  formatting (`.terms-doc` + ql-* CSS in the report template).
  **THREE GOTCHAS burned here:** ⑴ a block-local PL/SQL function (clean_html) referenced
  INSIDE the SQL UPDATE = invisible to SQL DML = compile error = **uncatchable 555** — resolve
  content in PL/SQL first; ⑵ **`dct_rest.parse_body` truncates the body at 32,767 bytes**
  (DBMS_LOB.SUBSTR + VARCHAR2) and the WHEN OTHERS fallback parses `{}` so a >32K PUT silently
  keeps every stored value — large-body handlers must do the PAY/db/12 full-CLOB parse
  (`DBMS_LOB.CONVERTTOCLOB` + `APEX_JSON.parse(CLOB)`); ⑶ Playwright must write through
  **Quill's document model** (`Quill.find(node)` + `clipboard.convert`) — raw `.ql-editor`
  innerHTML bypasses the Delta that `getSemanticHTML()` serialises, saving `<p></p>`.
  Deploy order: db/v2/129 → GL/db/51 (fresh session) → reporting/db/42 → datasource.py fleet
  sync + rpt-worker restart ×3 (CLOB rows materialised at fetch) → template upload + fallback
  copies → webtier GL overlay **20260906154050** (rollback 20260906111321, APP_VERSION 1.118.0).
  Tests: `terms_api_smoke.py` **19/19** · `terms_browser_smoke.py` **17/17 EN+AR** · live
  render run #1054 (terms print as Part 1 with formatting; contents renumbered).
- **2026-09-06 — Sector Performance Report (v1.115.0, NEW GL/db/50 + reporting/db/42 + template + render_pdf.py hook).**
  New **Generate Report ▾ menu entry "Sector Performance Report (PDF)"** on the Budget Utilization
  page: report code **`SECTOR_PERF_BOOK`** = the Budget Utilization Briefing Book pack re-covered
  for distribution, per the user's annotated cover mock-up — ① **DCT logo top-right on EVERY page**
  (embedded PNG data-URI from `docs/photos/DCT logo.webp`), ② title "Sector Performance Report",
  ③ subtitle = "YTD MM-YYYY" (plain "Budget Year YYYY" when no period), ④⑤⑥ parameter chips,
  description paragraph and Generated block REMOVED from the cover, ⑦ prepared-by "Financial
  Planning and **Reporting**", ⑧ user-approved copyright line at the bottom of EVERY page:
  *"© <generation year> Department of Culture and Tourism — Abu Dhabi. All rights reserved.
  Confidential — for internal use only."* The per-part `.foot` document name follows suit.
  **Mechanism — NEW generic opt-in runner hook** (`reporting/runner/render_pdf.py`, fleet-synced
  vm180-182 + rpt-worker restart ×3): a template embeds
  `<template id="pdf-header" data-margin="24mm">` / `<template id="pdf-footer" data-margin="16mm">`
  blocks; `_extract_pdf_chrome` cuts them out of the flowing HTML and passes them to Chromium's
  `displayHeaderFooter`, which repeats them on every printed page **inside the page margins** —
  flowing content (long registers included) can never overlap them; `data-margin` overrides that
  side's page margin to make the room (top 14→24mm, so the cover height dropped 172→166mm to stay
  on one page). Existing reports are untouched (no blocks = old behaviour; an unprocessed
  `<template>` renders nothing on the WeasyPrint path). Template `sector_perf_book.html.j2`
  (repo `reporting/runner/templates/` + uploaded to `DCT_RPT_TEMPLATE`, 96,761 bytes incl. the
  ~27KB quantized-PNG logo). **`reporting/db/42`** seeds SECTOR_PERF_BOOK as a column-for-column
  copy of BUDGET_UTIL_BOOK (source_ref/params/param_spec verbatim, PDF-only, own pdf_template) —
  **re-run 42 after any reporting/db/21 re-run** to refresh the copy. **`GL/db/50`** = additive
  bridge `POST /gl/butil/sectorbook` + `GET …/:id` + `GET …/:id/pdf` (GL_RUN_BRIEFING_BOOK gate,
  full butil filter set, report-code-scoped run lookups — a SECTOR_PERF_BOOK run 404s on the
  /butil/book/:id routes and vice versa). Frontend: `runBuSpb()` + `buSpbBusy` folded into
  `buGenBusy`/"The Binder" popup (`rgGenSpb`), download name `Sector_Performance_Report_<year>.pdf`.
  **GL post-05 re-run list now includes 50.** Tests: `tests/sector_book_api_smoke.py` (guardrails +
  live fleet run + PDF download) + local Chromium render QA of cover/register/last pages.
  **Feedback round same day (template-only, re-uploaded to DCT_RPT_TEMPLATE + fleet fallback
  copies; no render_pdf.py / DB / frontend change):** ① cover logo OVERLAPPED the teal band —
  measured on the rasterized PDF: the header box has a ~5.5mm inherent top offset, so the
  15mm logo + 5mm padding ended at 24.9mm while the band starts at 24.0mm; now 13mm logo +
  2mm padding = bottom 20.0mm, **4.1mm clearance** (calibrate header geometry by MEASURING a
  rasterized page, never from the declared mm); ② cover title on ONE line ("Sector Performance
  Report", `<br>` removed); ③ NEW `Sector: …` line under the YTD subtitle (`.cv-sector`; brackets removed per a follow-up user comment same day — template-only re-upload, no worker restart) —
  the page's sector filter, pipe-lists rendered comma-separated, "All Sectors" when unfiltered.
  **ONE-SECTOR rule (user-approved "both ends", v1.116.0 — GL/db/50 re-run + reporting/db/42
  re-run + frontend):** the report runs for exactly ONE sector. Server: `POST /butil/sectorbook`
  400s when `sector` is missing OR a pipe-list (guard sits BEFORE the period check — tests
  probing bad periods must send a sector). Definition: db/42's post-copy `JSON_MERGEPATCH`
  stamps `sector.required=true` + a "Required —" hint into the copied PARAM_SPEC_JSON
  (re-applied every run, AFTER the copy refresh — the copied hint said "Optional", so patch
  hint/hint_ar too) ⇒ the BI Run-Parameters drawer enforces it as well. Frontend: the menu
  entry is `enable:buSector`-bound (greyed, subtitle + title flip to "Select a sector in Search
  first" until the single-select Sector filter holds a value — the filter was ALREADY
  single-select, so multi-sector was never possible) + a `runBuSpb` toast guard. The cover's
  "Sector: …" line therefore always names the one sector. Webtier GL-only overlay
  **20260906061035** (rollback 20260906020630). Smokes: `sector_book_api_smoke.py` (missing-
  sector + pipe-list 400s; sector taken from `/butil/filters`) + `sector_book_browser_smoke.py`
  15/15 EN+AR (disabled → pick sector → enabled → enqueue).

- **2026-09-03 — `/gl/combinations` current-data performance (db/44 + canonical db/05):** current-date requests now read the hourly refreshed indexed `DCT_GL_COA_SNAP`; explicit `asof=YYYY-MM-DD` requests still read effective-dated `DCT_GL_COA_V`. Production equivalence before deploy: 10,109 rows, identical classification checksum, zero full-row differences. DB benchmark: live view 2.13–2.96s versus snapshot 0.046–0.057s. No financial result cache or stale fallback was added.

- **2026-09-03 — `/gl/fmr/sector` current-COA performance (db/45 + canonical db/37):** the live Budget/Actual view remains the financial source; its current segment filtering now joins `DCT_GL_COA_SNAP` by `CC_ID` instead of parsing segment 4/6 repeatedly with regular expressions. Production equivalence for 09-2026: 19 sectors; Budget 8,477,793,017; Actual 4,302,647,467.51; Plan 5,233,447,657.42; identical result checksum. Controlled full-query benchmark: 2.168s before versus 1.940s after (10.5%); isolated Actual leg: 1.827s versus 0.760s (58.4%). No financial result cache was added. Re-run db/44 and db/45 after their canonical handler owners.

- **2026-08-30 (2) — Fund Movement drill: combination popover + status pills (v1.95.0, GL/db/34 re-run + frontend).**
  User feedback on the new drill: ① the **Code Combination column now shows the SAME styled
  10-segment popover** as the Actuals drill — the `GET /butil/lines/fundmove` response gained a
  **`combos` side-object** (each DISTINCT `code_combination` resolved against `DCT_GL_COA_SNAP`
  by `cc_string` to the 10 segment code+description pairs, `comboRows` shape; dedupe via an
  associative array + `apex_t_varchar2` → `TABLE()` lookup — handler now 11,110 chars, still
  one SQLcl statement). Client: `fmComboMap` from `d.combos`; the drawer's delegated hover
  (`drillGridOver/Move`) was refactored to `drillComboRow(info)` = `acRowMap[..] ||
  fmComboMap[..]` so BOTH drill kinds share one path (Actuals regression `ac_ir_browser_smoke`
  **26/26**). ② **Transaction / Line / Baseline / Journal / Approval State render as tinted
  icon pills** — reuses the Budget Transactions page's `btStClass`/`btTone` keyword classifier
  (failure patterns FIRST — the "Baselining Failed contains baselin" lesson) via a new drill
  column `type:'status'` branch in the drawer td template; the `#pg-budgettrx` `.st` disc-icon
  vocabulary (✓ ok / ✕ err / ! warn / • info / – mute) re-declared scoped `.dw-drawer .st`
  (portfolio-page precedent — never de-scope the originals). Webtier GL-only overlay
  **20260830194340** (rollback 20260830141216; name-sorted prune). Tests:
  `butil_fundmove_api_smoke.py` **53/53** (+combos coverage/shape) · `fm_browser_smoke.py`
  **40/40 EN+AR** (+popover opens in drawer w/ 10 segments + resolved descriptions, pills
  render, positive statuses tone ok, no err tone on positive words) · deployed spot check PASS.
- **2026-08-30 — Fund Movement COLUMNS on all three butil tabs (v1.94.0, NEW `GL/db/34` + frontend).**
  User request: **Fund Movement Count** + **Fund Movement Amount** columns on Budget Line /
  Department / Sector, each with a header hint, a green/red additions-vs-deductions hover popover,
  and a drilldown listing the transfer transactions with the SAME 28 columns as the register's
  Fund Movement sheet, sorted two ways. Confirmed choices: **all statuses** (sheet parity) ·
  count = **transfer lines** (a cell count always equals its drill row count; the 22 zero-amount
  lines excluded — neither addition nor deduction) · Dept/Sector **include unmatched transfers,
  attributed** by the transfer's OWN cost centre/sector (register rule; a CC/sector with no group
  row surfaces in a `fmExtraNote` under the table, never dropped) · amount = **net signed**
  (additions − deductions, green/red by sign). NEW `GL/db/34_butil_fundmove_ords.sql` = TWO
  additive routes (**GL post-05 re-run list is now 07..34**): `GET /gl/butil/fundmove`
  (`level=line|dept|sector` keyed aggregates {cnt, amt, posCnt/posAmt, negCnt/negAmt} + totals;
  line level groups by the EXACT project/task/etype and IGNORES page filters — the row key IS the
  filter — dept/sector bind the full own-attribute filter set incl. the SECTOR data scope;
  appropriation/program match the combination segment as a leading token so both bare codes and
  'CODE - Description' composites work) and `GET /gl/butil/lines/fundmove` (drill rows = the
  sheet's 28 columns, `sort=default` project/task/etype/trx-date or `sort=date` date-first; row
  mode exact-key + group mode `costcenter=`/`sector=` like the other drills; cap 1000, full_n/
  full_tot analytics). Source = `pa_additional_fund_lines` ⋈ `pa_budget_trx_headers`
  type 'Additional', `trx_year` = budget year, `transaction_date` cut at the period end — lifted
  from reporting/db/25's sheet-8 SQL, so page and register always tie. Frontend: columns sit
  right after Fund Available on all three tabs (`fmOfRow`/`fmOfGrp` merge maps fetched by
  `runBuFm` per level, cached by params — the line map keys only on year+period so filter changes
  never refetch it); `.fm-tip` popover (▲ n additions +amt green / ▼ n deductions −amt red /
  Net); drill drawer gains an FM-only sort switch (`.fm-sortbar`, `fmDrillOn` reset in
  `fillDrill`) and the Amount column tints by sign via the new `pn` column flag; both page CSVs
  (line + agg) carry the two columns. Deployed: db/34 via `sql -name prod_mcp` (fresh session;
  TWO temp procedures so each handler is its own statement — Linux SQLcl swallows ~19KB blocks;
  verified LENGTH 8290 + 9281). Webtier GL-only overlay **20260830141216** (rollback
  20260829182357). **DEPLOY GOTCHA (caused a ~2-min outage, fixed):** the release prune used
  `ls -t | tail -n +6` — but `cp -a` PRESERVES mtimes, so the new release sorted LAST and the
  prune deleted it, leaving `/var/www/ifinance/current` dangling (site-wide 404). Prune releases
  by NAME (`sort -r | tail -n +6 | grep -v $STAMP`), never by mtime. Tests:
  `tests/butil_fundmove_api_smoke.py` **50/50** (3-level reconciliation, cell↔drill ties incl.
  filtered dept + sector + period-cut, both sort orders, validation 400s, 401) ·
  `tests/fm_browser_smoke.py` **33/33 EN+AR** (headers+hints, popover, tinted cells, 28-col
  drawer ties, sort switch re-orders, dept/sector group drills, remainder note, dept CSV
  columns) · regression `butil_tabs_browser_smoke.py` **54/54** · deployed-build spot check
  PASS (map 2,213 keys, drill ties, 0 page errors). Test gotcha: switching agg level re-fetches
  the FM map — wait `buAggItems().some(r => !!fmOfGrp(r))`, not just map-non-empty (the previous
  level's map is non-empty too).
- **2026-08-29 (7) — Butil Excel Register: NEW sheet 8 "Additional Fund Transfers" (reporting/db/25 re-seed only — no GL script, no frontend, no APP_VERSION change).** User request: the budget transfer transactions ride the Budget Utilization register in their own worksheet, **Additional Fund only**, sorted project / task / etype / transaction date. Source = the PBT extract (`pa_budget_trx_headers` ⋈ `pa_additional_fund_lines` ⋈ per-transaction-aggregated `pa_budget_trx_approvals`); 32 columns = header identity (trx num, decree no, trx date/year, BU, project type, status) + full line detail (coding, code combination, signed Amount, budget/actual figures, line/baseline/journal statuses) + approval trail (submitted by, assignees, last state, last action time) + segment-resolved Sector/Cost centre/Department lead columns. Honours ALL the page filters the Generate-Report and Generate-and-Send flows forward (year, period-YTD cut on transaction date via BUTIL_END, sector/chapter/costcenter/projecttype/project/task/etype/search/bu) — applied to the line's own attributes, NOT the butil scope join (987 of 4,561 transfer lines have no exact butil line match). Details + verification in `reporting/docs/deployment-notes.md` (2026-08-29 entry).
- **2026-08-29 (6) — Missing-classification warning on the agg tabs (v1.93.0, frontend-only).** User
  rule: **cost centre is MANDATORY on every budget line** — a keyless Department/Sector group is a
  data-quality violation, not a dead row. The EXISTING missing-CC warning band (the amber `.bu-alert`
  above the Search region, negfund pattern) now fires from EITHER source — `/butil`'s `missingCc`
  aggregate (any tab, as before) OR a keyless group on an agg tab (`buAggMissRow` computed; the
  message takes count + annual budget from whichever tripped it, `buMissBandOn`). The keyless row
  itself is tinted red (`.tr-noclass`, 3px `#C0392B` spine) and **every cell of it now opens the
  missing-lines list** (`openBuMissCc` — `/butil?nocc=Y`, same page filters) instead of being a
  no-op; keyed rows keep their group drills, `money-cell` affordance now unconditional on the agg
  cells. Live 2026 data is FULLY classified (missingCc 0, zero keyless groups — probed unfiltered
  AND at the default page scope), so the smoke SIMULATES a keyless group (pushes a fake row into
  `buAggItems`) and asserts band-fires/message-numbers/red-tint/cell-click-drill/band-click-drill/
  band-hides. Webtier GL-only overlay release **20260829182357** (rollback 20260829180642).
  Smoke `butil_tabs_browser_smoke.py` **54/54 EN+AR**.
- **2026-08-29 (5) — Department/Sector tab FIGURE DRILLS (v1.92.0, GL/db/30 re-run + frontend).** Every
  money cell of a Department / Sector group row now opens the SAME drill drawer as the Budget Line
  tab (user request "add the drilldown for each figure … with same way"): Budget Annual/YTD, Plan
  Approved/Revised Annual/YTD, vs Plan, Actual AP, Actual GRN, Commitment PR, Obligation PO. The
  drill is the existing **aggregate mode** of `/gl/butil/lines` (+ `/butil/lines/costadj` appended
  when the group is starred, same `CADJ_DRILL_METRICS` rule as the line tab) scoped to the group:
  the page filter set with `costcenter=` the group's CC (dept) / `sector=` the group's sector —
  `openBuAggDrill`/`openBuAggPlan`/`buAggGrpScope` in app.js; drawer subtitle names the group,
  context = level + YTD period. **GL/db/30 re-run — `/gl/butil/lines/plan` gains `extra=Y`**: a
  third `kys` UNION ALL leg serves the plan rows whose key has NO budget line (the planUnmatched
  set), attributed through `dct_butil_key_cache` exactly like GL/db/33's unmatched leg (task attrs
  first, then project), so a GROUP plan drill ties even where planExtra > 0 (CCs 4510230/4515300/
  4515500 — 532 monthly rows on 4510230 alone). Default `N` keeps the Plan KPI tile drill
  matched-only (regression-asserted: no-extra total == /butil planApprovedAnnual). Groups with no
  key (unclassified sector / missing CC) can't be scoped server-side and stay non-drillable
  (`buAggCanDrill`). Deploy = db/30 via local SQLcl fresh session (file converted to CRLF), then
  webtier GL-only overlay release **20260829180642** (rollback 20260829174602).
  Tests: `butil_agg_api_smoke.py` **67/67** (3 dept groups × 6 metrics + 3 planExtra CCs annual+YTD
  + sector AP/plan + tile-drill regression) · `butil_tabs_browser_smoke.py` **47/47 EN+AR** + live
  deployed-build drill diff 0.0. Test gotcha: closing the comments drawer on an agg tab REFETCHES
  the aggregation (v1.90.0 cache invalidation) — wait `!buAggLoading()` before counting drill cells.
- **2026-08-29 (4) — Level-strip KPI chips + Encumbrance balance (v1.91.0, frontend-only).** The
  Results toolbar's plain text summary became **six professional icon KPI chips** (`.bu-lvl-kv`
  cards: tinted 27px icon disc + stacked uppercase label / bold value, palette mirroring the
  Overview band — count brand-green list, Budget steel-blue database, Plan YTD plum calendar-check,
  Actual purple dirham/dollar, **NEW Encumbrance amber lock = Commitment (PR) + Obligation (PO)**,
  Fund green shield flipping red `.kv-neg` when negative) with formula tooltips (`lv*Hint` keys
  EN+AR). `buLvlSum` gained `enc` on both levels. Also fixed: the v1.89 strip CSS referenced the
  non-existent `--mut` var (GL's token is `--muted`). Webtier overlay release **20260829174602**
  (rollback 20260829173552); smoke `butil_tabs_browser_smoke.py` now **39/39 EN+AR** (6 chips,
  Encumbrance = PR+PO reconciliation).

- **2026-08-29 (3) — Column hints reworked formula-first + agg Comments column shows the recorded text (v1.90.0, GL/db/33 re-run + frontend).** Feedback round on the level tabs: ① **every column of the butil line table AND the Department/Sector tables now carries a simple, formula-bearing hint** — new `ch*` i18n keys EN+AR (e.g. Fund Available = "YTD Budget − (Actual AP + Actual GRN + Commitment PR + Obligation PO); − Procash when included"), and the three existing keys rewritten formula-first: `piVsPlanHint` = "vs Plan = Total Actual (AP + GRN) ÷ Plan YTD × 100 …" (thresholds still substituted live), `piCovColHint` = "Plan Coverage = Plan Annual ÷ Annual Budget × 100 …", `buProcashHint` shortened. The smoke asserts NO visible line-table header is hint-less. ② **Department/Sector Comments column records the comment text of that department/sector at the selected Accounting Period** — GL/db/33's per-group lookup became COUNT + `LISTAGG('['||period||'] '||author||': '||text …)` newest-first (period-scoped: `l_period IS NULL OR accounting_period = l_period`; full year = the whole year), shipped as `commentsText`; the agg comments cell = 💬 button + `.cmt-txt-clamp` text (`.agg-cmt`, min 220px). Closing the comments drawer while on an agg tab **invalidates the cache and re-fetches** (`buAggInvalidate` + `closeCmtDrawer` hook, guarded on view==='butil') so a just-added comment appears immediately. Verified live with a CC-level comment round-trip (created on 4519202 @ 08-2026 → text + count on the dept row, absent at 07-2026 → deleted). Webtier overlay release **20260829173552** (rollback 20260829155225). Smoke `butil_tabs_browser_smoke.py` now **37/37 EN+AR** (formula hints, headers-all-hinted sweep, comments text in grid, period scoping).

- **2026-08-29 (2) — Budget Utilization Results-region LEVEL TABS (v1.89.0, NEW GL/db/33 + frontend).**
  User request + layout pick **B (Segmented Deck)** from the three demoed studies (artifact
  `butil-tab-studies.html`): the Results region gains a **pill segmented switcher with icons** —
  **1 Budget Line** (the untouched paged line table) · **2 Department** (cost-centre grain) ·
  **3 Sector** — plus a **live summary strip** (count · Budget · Plan YTD · Actual · Fund) that
  re-computes per level. Department/Sector come from NEW **`GET /gl/butil/agg?level=dept|sector`**
  (`GL/db/33_butil_agg_ords.sql`, additive template `butil/agg` — the live `GET butil` owner stays
  GL/db/32): the SAME butil-view join + full predicate set as `/gl/butil` (incl. sector data
  scoping, costadj/procash/ovr folding, BUTIL_END period window) GROUPed server-side, **plus a
  second UNION ALL leg folding the uploaded expenditure plan with NO budget line into the group
  plan figures** (the `/gl/butil` `planUnmatched` amount — attributed through
  `dct_butil_key_cache`: task match first, then the project's attributes; a group with plan but
  no lines ships `planOnly='Y'`, rendered as an amber "Plan only" row). Group vs-Plan/Coverage
  verdicts use the same thresholds/expressions as the line grain; `planExtra` per row + totals
  carries the folded-in amount (note under the table + cell title). Group 💬 buttons open the
  **COST_CENTER / SECTOR** comment levels (db/v2/125) and per-group `cmtCount` ships in the
  response. Export CSV exports the ACTIVE tab (dept/sector = client-side, full set loaded — 51
  CCs / 11 sectors, no pager). **GL post-05 re-run list = 07..33.**
  GOTCHA (hit live): `IF l_level NOT IN (...)` never fires on a NULL bind — 3-valued logic; the
  guard must be `IF l_level IS NULL OR l_level NOT IN (...)`.
  Deployed: db/33 via SQLcl (handler 16,466 chars, verified INSTR markers); webtier GL-only
  overlay release **20260829155225** (rollback 20260827080130). Tests:
  `tests/butil_agg_api_smoke.py` **38/38** (dept+sector reconcile byte-exact to /gl/butil totals
  full-year, period-cut and costadj=N; planExtra == planUnmatched 3,244,500; 400s) +
  `tests/butil_tabs_browser_smoke.py` **31/31 EN+AR/RTL** (pills/strip/reconciliation/plan-only
  note/comment drawer at COST_CENTER/CSV names/search re-scope), plus a deployed-build spot
  check (51 groups, fund diff 0, no page errors).

- **2026-08-29 — DATA LOAD: 40 Costing Adjustments from "Missing Projects and tasks from AP
  2026.xlsx"** (docs/Reports/GL/Data/Cost Adjustment/, Paid Status = Paid only; 2 Unpaid rows
  excluded). PCA-00019..PCA-00058, total AED 789,254.54 — **39 APPROVED** (AED 750,254.54,
  user decision) + **PCA-00043 left DRAFT** for review (invoice DCTCS2026FEB052, AED 39,000:
  the sheet said task "Freelancers-N" but project 4511001180's actual task is
  **Freelancers-N1** — loaded with the corrected task, pending user confirmation). Rules
  applied: expenditure type = the (project, task) budget line whose name starts with the GL
  Combination's ACCOUNT segment (5th token; all 40 resolved 1:1, zero ambiguity); accounting
  period = each row's own Period (01..07-2026); classification CORRECTION; every row linked
  to its AP invoice distribution (invoiceId via costadj/meta/dists, matched on invoice
  number + line + dist; original coding empty — these dists carry none); comments = invoice
  description. Loaded via the /gl/costadj API (same validation as the UI), idempotent on
  invoice+line+dist. Verified: butil 2026 totals.costAdj moved by EXACTLY +750,254.54.
  Loader gotcha: the live costadj/meta/dists response OMITS empty coding keys (handler
  reworked after v1.79) — read them with .get(), never by subscript.

- **2026-08-27 (4) — Cost adjustments in the Excel Register (reporting/db/25, user report).** The
  BUDGET_UTIL_REGISTER showed raw view figures, so a line whose Actual is entirely a costing
  adjustment (4511000981 · MICE-Trade Shows-N = PCA-00018) exported Actual Ap 0.00. Sheet 1 now
  folds APPROVED adjustments server-side (actual/budget/fund/utilization + the plan indicators all
  on adjusted figures — page costadj=Y parity) + explicit Cost Adjustment / Budget Override (Adj)
  columns, and NEW **sheet 8 "Costing Adjustments"** lists the transactions (ref, period, key,
  classification, amounts, referenced invoice, reason, approver). Book PDF folded the SAME DAY on user request
  (reporting/db/21: overview/by-sector/pressure + plan sections all on adjusted figures). Verified vs the live /gl/butil figures. See the reporting
  deployment notes for details.

- **2026-08-27 (3) — "Show Plan" LOV (v1.88.1, frontend-only, user feedback).** The
  "Show Plan Insights" checkbox became a 3-option Search LOV **"Show Plan"** (`buPlanMode`):
  **Yes (default)** = plan columns (Plan Annual/YTD + Revised pair when data exists) with the
  vs Plan + Plan Coverage indicator columns; **No** = NO plan columns in the results table at
  all; **Plan with insights** = everything incl. the D2 micro-chart + D3 composite columns.
  `buPlanOn`/`buPlanIns` are computeds off the mode; all plan headers/cells sit inside a
  `ko if: buPlanOn` wrapper; Reset restores Yes. KPI tiles, K2 strips and the CSV columns are
  deliberately unaffected (the Overview keeps its plan summary either way). Webtier overlay
  release **20260827080130** (rollback 20260827073754); smoke now **25/25 EN+AR** incl. the
  three modes, local + deployed.

- **2026-08-27 (2) — Plan Insights (v1.88.0, NEW GL/db/32 + frontend + reporting/db/21+25 + book template).**
  User-selected mockup combo **D1 + (D2+D3 behind "Show Plan Insights", default No) + K1 + K2 + R1 + B2**
  (mockup page `docs/design-mockups/plan-insights-mockups.html`). Two indicators, computed
  SERVER-side so page/CSV/drills/reports can never disagree:
  **① Plan vs Actual (execution)** — the row's Total Actual (AP incl. cost-adj when costadj=Y,
  + GRN, + procash when procash=Y) as % of the **EFFECTIVE** YTD plan (= REVISED when
  `plan_rev_annual <> 0`, else APPROVED): verdict `WITHIN` 👍 (90–110%) / `BELOW` 👎 (<90%) /
  `AHEAD` ✋ (>110%) / `NOPLAN`; **② Plan vs Budget (coverage)** — effective annual plan as % of
  the adjusted annual budget: `FULL` (95–105%) / `UNDER` (gap) / `OVER` / `NONE`. Thresholds =
  **GL module settings `PLAN_EXEC_TOL_LOW/HIGH` + `PLAN_COV_LOW/HIGH`** (seeded 90/110/95/105 by
  db/32, Admin-editable) and are **echoed per response** (`planThresholds`) so the client colors
  rows exactly as the server counted them.
  - **GL/db/32_butil_plan_insights.sql = the NEW LIVE OWNER of `GET /gl/butil`** (supersedes 31;
    body = 31's deployed body verified length-identical first, per the negfund-race lesson).
    Adds per-row `planEffYtd/planEffAnnual/planExecPct/planVariance/planExecState/planCovPct/
    planCovState`, 13 totals aggregates (`planWithin/Below(+Amt)/Ahead(+Amt)/NoPlan`,
    `planCovFull/Under/Gap/Over/None`, `planEffYtd/Annual`) and **NEW param
    `planstate=WITHIN|BELOW|AHEAD|NOPLAN`** restricting totals AND items (negfund convention —
    feeds the K1 row / K2 strip drills). **GL post-05 re-run list = 07..32.**
    ⚠ handler literal now ~31.1K of the 32,767 cap — the NEXT edit must switch to concatenated
    TO_CLOB pieces.
  - **Frontend (v1.88.0)**: D1 = always-on **vs Plan** (hand + %) + **Plan Coverage** (pill)
    columns; Search toggle **Show Plan Insights** (default No, frontend-only) reveals the D2
    micro-chart column (track = plan YTD, fill = actual, tick = YTD budget, plum coverage bar)
    + D3 composite cell; K1 = plum plan tile split into **Plan Performance** (hero exec % +
    hand; Within/Below/Ahead rows FILTER the results via planstate; Plan-YTD row keeps the
    monthly plan drill) + steel-blue **Plan Coverage** tile (`bu-kpis7` grid); K2 = amber
    execution + green coverage strips above Overview (negfund-band pattern; hidden while a
    verdict filter is applied — the Results-header **chip** with ✕ takes over; Reset clears
    both); CSV gains Effective Plan YTD / Plan Utilization % / Plan Variance / Plan Status /
    Plan Coverage % / Coverage Status; skCols 22→24.
  - **Reports**: BUDGET_UTIL_REGISTER sheet 1 gains the 4 indicator columns (R1 — glyph
    statuses ▼/▲/●; thresholds via a CROSS-JOINed settings aggregate); BUDGET_UTIL_BOOK gains
    **Part 6 — Expenditure Plan Performance** (B2: KPI strip, per-sector execution + coverage
    bars, 6.1 sector table, 6.2 top-15 deviations, methodology note; Observations renumbered
    Part 7, TOC updated; sections `plan_sector`/`plan_dev`/`plan_cov` in reporting/db/21).
  - **GOTCHAS (all hit live):** `CHR(9660)` for ▼ emits an INVALID UTF-8 byte pair (CHR is
    byte-based) → the python datasource dies decoding; `UNISTR('\25BC')` can't ride the MULTI
    source_ref (its backslash is an illegal JSON escape → JSONDecodeError at claim time); and
    bare `NCHR(9660)` inside a VARCHAR2 CASE = **ORA-12704 character set mismatch** — the
    working form is **`TO_CHAR(NCHR(9660))`**.
  - Deployed: db/32 via SQLcl (settings seeded, handler 30,919 chars, all markers wired);
    seeds 21+25 + template via python-oracledb/upload on vm180 (+ fleet fallback copies);
    webtier GL-only overlay release **20260827073754** (rollback 20260827000630). Tests:
    `tests/plan_insights_api_smoke.py` **20/20** (recompute parity, planstate reconciliation
    1178/19/472, thresholds echo, period basis, costadj=N) + `tests/plan_insights_browser_smoke.py`
    **23/23 EN+AR** local AND against the deployed build; register run verified (4 columns +
    all 4 glyph statuses), book run verified (124-page PDF, Part 6 + Part 7 renumber).

- **2026-08-27 — Cost-adjustment AP drill round 2 (v1.87.2, GL/db/29 re-run + frontend): the row IS the invoice distribution, marked (**).**
  User feedback on 2026-08-26 (4): the row still read as the adjustment transaction
  (Validation "Cost Adjustment", Payment "Reallocation", PCA text in the description). Now the
  metric=ap row is shaped EXACTLY like a plain invoice-distribution drill row — real
  Validation/Payment statuses and the distribution's OWN description via a ranked LEFT JOIN on
  `AP_INVOICE_DISTRIBUTIONS_V` (invoice_id + line + dist line; NULL stored dist line takes the
  line's first dist via ROW_NUMBER so the join can never fan out; header fallbacks from
  `ap_invoices` when the dist row is gone) — with `fromAdj='Y'` + `adjRef` riding the row. The
  Distribution (AED) column STILL carries the adjustment amount (drawer total keeps
  reconciling to the starred cell). Frontend: the drawer's invoice cell renders a **(**)**
  marker before the number when `fromAdj='Y'` (tooltip = "Sourced from approved cost
  adjustment PCA-xxxxx") + a `(**)` footnote under the table; sample row now reads
  2026-0080 · 1 · 2026-04-13 · NATIONAL MEDIA AUTHORITY · AED · 2,368,623 · Validated · Paid ·
  the invoice's own description. A reference-less adjustment keeps the PCA-shaped row.
  Note: the drill CSV carries the clean distribution fields only (the marker is on-screen; the
  adjustment itself is auditable on the Costing Adjustments register). Tests re-run:
  costadj_drill_api_smoke **19/19** + costadj_drill_browser_smoke **12/12** vs webtier release
  **20260827000630** (base 20260826235400 was a parallel session's release — overlay preserved
  it; rollback = that release).

- **2026-08-26 (4) — Cost-adjustment AP drill shows the REFERENCED invoice (GL/db/29 re-run, server-only).**
  User feedback: drilling Actual AP on an adjusted line showed the cost-adjustment
  transaction's own metadata (PCA ref in the doc column, accounting period as the date, no
  line/invoice amount) instead of the invoice it reallocates. GL/db/29's metric=ap branch now
  LEFT JOINs `prod.ap_invoices` + `prod.dct_ap_supplier_eff_v` on the adjustment's stored
  `invoice_id` and emits the **referenced invoice's details** — real invoice number (+
  `invoiceId`, so the drawer renders the Fusion deep-link for free), line, invoice date,
  effective vendor, currency and header amount (`invAmount`, matching the /butil/lines ap
  column set) — while the Distribution (AED) column keeps the ADJUSTMENT amount so the drawer
  total still reconciles to the starred figure; `validation='Cost Adjustment'` + description
  "Cost Adjustment PCA-xxxxx - reason" mark the row, and an adjustment with NO invoice
  reference keeps the old PCA-shaped row. Sample verified: 2026-0080 line 1 · 2026-04-13 ·
  NATIONAL MEDIA AUTHORITY · AED · inv 2,368,623 / adj 2,368,623. No frontend change
  (APP_VERSION stays 1.87.1). Tests updated + re-run: costadj_drill_api_smoke **18/18** +
  costadj_drill_browser_smoke **11/11** vs the live build.

- **2026-08-26 (3) — Plan header rename (v1.87.1, user feedback).** The approved-plan column
  headers drop the word "Approved" everywhere: butil table + CSV + KPI rows, Portfolio IR,
  book KPI/register now read **Plan Annual / Plan YTD** (AR: الخطة السنوية / الخطة منذ بداية
  السنة); the REVISED pair keeps its "Revised" prefix so the two stay distinguishable when a
  revised plan is uploaded. Register aliases `approved_plan_annual/ytd` → `plan_annual/ytd`
  (seed redeployed via vm180, run 763 verified: sheet-1 headers Plan Annual / Plan Ytd);
  book template KPI label "YTD Plan (Approved)" → "YTD Plan" (re-uploaded + fleet copies).
  Webtier release **20260826232512** (GL-only overlay; rollback 20260826230300); browser
  smoke re-run 23/23 vs the live build (assertions updated to the new labels).

- **2026-08-26 (2) — Expenditure Plan balances on dashboards + reports (v1.87.0, db/v2/126 + GL/db/21+22 re-runs + NEW GL/db/30 + reporting/db/21+25 + template).**
  User ask: surface the uploaded projects cashflow plan (`DCT_PROJECT_CASHFLOW`, the GL
  Cashflow tab; 6,701 APPROVED rows / 489 projects / AED 5,085.2M for 2026) as **Planning YTD
  and Annual Planning balances** on both dashboards and the reports. Decisions (user):
  Butil + Portfolio/360; **APPROVED and REVISED as separate column pairs**; Register + Book;
  just the two balances (no variance columns).
  **DB `db/v2/126`**: `DCT_PROJECT_CF_BUTIL_V` — plan aggregated to the EXACT butil line grain
  (year × project × task × etype, 1:1 join so it can never fan out) with the APPROVED/REVISED
  pairs pivoted and `*_YTD` BUTIL_END-aware (full year ⇒ YTD = Annual — same convention as the
  Sector Performance report). `DCT_BUDGET_UTILIZATION_V` deliberately untouched (procash /
  cost-adjustment precedent: the join lives in the consumers). Data check before build: 1,268
  of 1,272 plan lines (5,082.0M of 5,085.2M) match butil lines verbatim.
  **`/gl/butil` (GL/db/21 re-run, still the sole live owner)**: every row +
  `planApprovedAnnual/planApprovedYtd/planRevisedAnnual/planRevisedYtd` + `hasPlan` (drill
  gate); totals add the four sums + **`planUnmatched`** (plan on lines with NO butil line,
  checked against the db/v2/120 key cache — reported under the results table, never silently
  dropped; 3.24M today). Purely additive — no parameter, no existing figure changes.
  **NEW `GL/db/30`** `GET /gl/butil/lines/plan` — the monthly plan rows behind any plan
  figure: `type=APPROVED|REVISED`, YTD cut via `period` (the Annual cell just omits it), row
  mode (project/task/etype) + aggregate mode over the SAME kys CTE as butil/lines (key cache +
  SECTOR data scope, copied from GL/db/29); rows period/amount/loadedBy/loaded/file, cap 1000.
  **GL post-05 re-run list = 07..30.**
  **Portfolio + 360 (GL/db/22 re-run)**: `/gl/projects` totals + rows and
  `/gl/projects/:num`'s `year` block carry the same four keys — totals via a dedicated scan
  over the SAME filtered project set (project-grain attribution, so the portfolio total can
  include plan lines whose exact task/etype has no butil line — 5,085.2M unfiltered vs the
  butil page's 5,082.0M matched; deliberate and documented).
  **Frontend v1.87.0**: butil results table gains **Approved Plan Annual/YTD** columns after
  YTD Budget (the **Revised pair auto-appears only when any revised plan exists** —
  `buPlanRevOn` on the loaded set, columns + CSV + KPI row all gated on it); the KPI band goes
  5 → 6 tiles with a plum **Expenditure Plan** duo tile (hero = Approved YTD + % of annual
  plan, drillable Annual/YTD rows); every plan cell/row drills to the monthly rows in the
  shared drawer (columns client-defined; totals reconcile to the cell); CSV gains the 4 plan
  columns; Portfolio register (shared IR, `stateRev` 1→2) gains the plan pairs + a plan KPI
  tile; Project 360 KPI band gains the plan tile. Skeleton cols 20→22.
  **Reports**: BUDGET_UTIL_REGISTER sheet 1 gains the 4 plan columns (LEFT JOIN via a RENAMED
  inline view — the seed's WHERE uses unqualified `budget_year`, a bare join = ORA-00918);
  BUDGET_UTIL_BOOK overview KPIs gain the 4 plan sums + a **YTD Plan (Approved)** KPI card and
  the 1.1 sector table gains **Annual Plan / YTD Plan** columns (plan sums appended at the END
  of `l_sec`'s select list — its `ORDER BY 3` is positional); template
  `budget_util_book.html.j2` re-uploaded (54,776 bytes) + fleet fallback copies synced.
  Deployed via python-oracledb on vm180 (`deploy_seed.py` + `upload_template.py` now live in
  /opt/rpt-worker; worker env = `/etc/rpt-worker.env` + TNS_ADMIN/RPT_DB_* from the unit file,
  system python3 — there is NO venv on the rpt fleet). Verified live: register run 761 sheet 1
  Approved Plan Annual 48,349,977.57 / **YTD (06-2026) 24,104,898** = the raw months 03..06
  summed by hand; book run 762 PDF prints the plan KPI (24.10 M · Annual 48.30 M) and the 1.1
  plan columns.
  Tests: NEW `tests/plan_butil_api_smoke.py` **23/23** (totals=Σrows, YTD boundary 02/06-2026,
  per-line + aggregate drill reconciliation, portfolio/360 parity, 400/401) + NEW
  `tests/plan_browser_smoke.py` **23/23 EN+AR** — also re-run 23/23 against the deployed
  webtier build. Webtier release **20260826230300** (GL-only overlay; rollback
  20260826152712). Test gotcha: the page's INITIAL default butil run must finish before a
  scripted `runButil` or the late response overwrites `buTotals` mid-assert.

- **2026-08-23 (2) — Comments feedback round (v1.83.0, GL/db/26 + 21 + 11 re-runs + reporting/db/25).**
  Five user asks after hands-on testing, plus one pre-existing bug their report exposed:
  ① **"the accounting-period selection on the dashboard doesn't change" — ROOT CAUSE was the
  Project Portfolio page's period `<select>` (index.html:101)**: it bound
  `optionsText:'l', optionsValue:'v'` against `buPeriodOpts`, which is a plain STRING list —
  every option's value was `undefined`, and because that select shares the `buPeriod`
  observable, ANY period picked on the Budget Utilization page was synchronously written back
  to undefined ("Full year") by that hidden select's KO value sync. Present since v1.70.0;
  one-line fix. **LESSON: a KO select bound to a SHARED observable clobbers every other
  consumer when its own options can't represent the value — grep the other binds of an
  observable before blaming the page you're on.** ② Drawer polish: the accounting-period chip
  is now a labelled amber chip ("Accounting period: MM-YYYY"), avatars show the user's
  PROFILE PHOTO when one exists (thread items ship `authorId`/`hasPhoto`; the client fetches
  `/dct/users/:id/photo` once per author as an authed blob, initials fallback), roots sort
  **newest first** (GL/db/26 re-run; replies stay chronological), and a **collapsed Search
  region** (Posted by + Accounting Period) filters the loaded thread client-side — the thread
  now loads YEAR-WIDE and the period filter DEFAULTS to the dashboard's accounting-period
  parameter, so the drawer visibly follows the page selection. ③ NEW dashboard LOV **"Display
  Comments"** (None default / Selected period only / All): `/gl/butil` takes `cmtdisp` (21
  re-run — the cm join now aggregates from the raw table with a `LISTAGG ... ON OVERFLOW
  TRUNCATE` text column; `l_cmtd VARCHAR2(20)` — the undersized-DECLARE 555 gotcha), rows
  ship `commentsText` ('[MM-YYYY] user: text', newest first), echo `commentsDisplay`; the
  results table + CSV gain a Comments column (clamped, full text on hover). ④ **Excel
  register**: BUDGET_UTIL_REGISTER (reporting/db/25, deployed via python-oracledb from
  dev-vm) gains a sheet-1 `comments` column + NEW sheet 7 **"Comments - Other Levels"**
  (sector/CC/project/task/PO/PR/AP-invoice comments), both gated on the new `cmtmode` param;
  GL/db/11 re-run forwards it and **ALWAYS writes the key** (a bind absent from the run
  params is a python-datasource error — same family as the `:MI` phantom-bind rule, which is
  why the sheet-7 SQL scopes PERIOD mode via `GL_CTX.BUTIL_END`, never `:period`, and builds
  its time mask with CHR(58)). Live run 681 verified: 7 sheets, line comment on sheet 1,
  sector comment on sheet 7. Tests: API **75/75** + browser **41/41 EN+AR**; webtier release
  20260823183954 (GL-only overlay). **Cosmetics round (same day):** the sheet meta band now
  prints "**Comment Mode** ALL" instead of the raw param key (NEW generic `CRUMB_LABELS` map
  in `reporting/runner/runner.py` — crumbs print `label or raw key`; runner.py synced to
  /opt/rpt-worker on vm180-182 + rpt-worker restarted) and sheet 7's Comment Ref column is
  renamed **Post Reference** (alias in the reporting/db/25 section SQL; XLSX headers =
  title-cased column aliases, so header renames are seed-side aliases, never a runner
  change). Verified on live run 682.

- **2026-08-23 — Projects Budget Utilization COMMENTS (v1.82.0, db/v2/125 + GL/db/26 + GL/db/21 re-run).**
  User-approved shape (plan `final apps/GL/BUTIL_COMMENTS_PLAN.md`): threaded, attachable
  business-justification comments on the Budget Utilization report at 8 levels (SECTOR /
  COST_CENTER / PROJECT / TASK / BUTIL_LINE / PO / PR / AP_INVOICE) per budget year +
  accounting period. ONE table `DCT_GL_BUTIL_COMMENT` (`BUC-#####`, single-level threading —
  a reply's parent must be a root, soft delete, roots with active replies refuse delete) +
  `DCT_GL_BUTIL_PERIOD` (close/reopen; **no row = OPEN**; a CLOSED period 403s EVERY write
  in it — add/edit/reply/attach) + aggregate `DCT_GL_BUTIL_CMT_V`. **Capabilities are the
  COMMON role/permission tables** (user decision — no private mapping table): privileges
  `GL_ADD_BUTIL_COMMENT` / `GL_REPLY_BUTIL_COMMENT` / `GL_CLOSE_BUTIL_PERIOD` /
  `GL_MANAGE_CMT_ROLES` granted via `dct_role_permissions`, checked with
  `prod.dct_sec.has_priv` (+`refresh_flat` after every admin mutation); **7 PLATFORM-WIDE
  roles seeded** (module_id NULL, like FIN_DIRECTOR): FIN_BP (add+reply), FBP_UNIT_HEAD /
  PBP_UNIT_HEAD / FBP_SECTION_HEAD / PROJECT_PLANNER / SECTOR_PLANNER / DEPT_PLANNER
  (reply), FIN_DIRECTOR gains reply+close. Attachments on the shared `dct_documents`
  (GL / BUTIL_COMMENT / comment_id; NEW doc type `GL_CMT_ATTACH`, DOC_SOURCE_TYPE value,
  and GL's first `MAX_UPLOAD_MB` module setting). ORDS = `GL/db/26` (13 additive handlers
  incl. `butilcmt/meta/caps` + `butilcmt/admin/roles|periods`; media download; raw-binary
  doc PUT with `v_blob := :body` FIRST) — **GL post-05 re-run list = 07..26**; `GL/db/21`
  re-run wires per-row `hasCmt`/`cmtCount` + totals + the `commentsEnabled` echo via an
  **INLINE aggregate join** (`l_period IS NULL OR accounting_period = l_period` — a bare
  view join would fan out rows on a full-year run; self-check now prints CMT WIRED).
  UI: `(**)` beside the `(*)` + a Comments column (chat button + badge) gated on the echo;
  comments drawer `.dw-cmt` = the **LAST drawer in the DOM** (z-71 stacking is DOM order —
  it must open ABOVE the drill drawer); 💬 icons on the AP/PR/PO drill rows via a synthetic
  `_cmt` column; new tab **Projects › Comments** (register on the shared IR + the Sector /
  Cost-Center entry bar — those two levels have no grid row); Settings gains **Comment
  Roles** + **Reporting Periods** pages, tabs hidden unless caps allow (NAV `hidden` now
  accepts a function). **GOTCHA (cost an hour): `NVL(x,'')` is still NULL in Oracle so
  APEX_JSON DROPS the key — the periods page's bare-name foreach bindings aborted after
  row 1 and the error was swallowed by the VM's own `.catch` toast (no pageerror). Fix =
  normalise rows in the VM; a handler's NVL-to-'' never guarantees the JSON key exists.**
  Deploy chain 125 → 26 → 21 (each in a fresh SQLcl session; 125 is MERGE-free so Linux
  SQLcl is safe) + webtier release 20260823163437 (GL-only overlay). Tests: API smoke
  **68/68** (`tests/butilcmt_api_smoke.py`) + browser **31/31 EN+AR/RTL**
  (`tests/butilcmt_browser_smoke.py`).

- **2026-08-22 — v1.81.0: EVERY Refresh-data menu action shows a popup.** User reported the
  conveyor "not showing for Refresh data" even after v1.80.1. The nginx access log settled it:
  their evening clicks fired `POST /actuals/refresh` — they were clicking **"Refresh actuals"**,
  which by v1.77 design had NO popup (only the button label), while the Data Conveyor belongs
  only to "Refresh source data" (whose full flow was verified working on live from a clean
  session). The expectation is fair — actuals runs 10-40s with near-zero feedback — so now
  **Refresh actuals and Rebuild views get a lite popup** (`.rg-lite`: oj-progress-circle
  spinner card, "Refreshing actuals snapshot…" / "Rebuilding views…" + explainer, backdrop
  click hides while the work continues, top-level markup so it shows from ANY page incl.
  Overview); the conveyor stays exclusive to the fleet extract run. 8/8 checks (real menu
  click fires the POST, popup/labels, backdrop-hide keeps working state, close-on-completion,
  hide reset on the next run, Overview visibility). Deployed webtier release 20260822224415
  (GL-only overlay). DIAGNOSTIC LESSON: when "a popup doesn't show", check the nginx access
  log FIRST — it distinguishes click-never-fired / wrong-action / server-error in one look
  (here three dropdown-open GETs with no source-data POST, then the actuals POST told the
  whole story).

- **2026-08-22 — v1.80.1: report popup must never click-lock the page.** User report: after the
  Binder shipped, the Refresh-data conveyor "didn't show at all". The conveyor itself was fine —
  verified end-to-end ON LIVE (real click path, popup + queue OK) and the ATD queue showed the
  user's refresh click had never even reached the server. Root cause: the Binder's full-viewport
  backdrop (`.rg`, position:fixed inset:0) swallows every click while a report generates — a
  minutes-long book run makes the whole page (incl. Refresh data ▾) dead until × or completion.
  Fix: **clicking the backdrop hides the popup** (run continues; card clicks don't bubble —
  `clickBubble:false`), and `.rg` gets an explicit **z-index 59** above the conveyor's 58 so
  simultaneous popups stack deterministically (hiding the Binder reveals the conveyor).
  7/7 checks (backdrop-hide, card-click keeps open, menu reachable after hide, stacking, reveal).
  Deployed webtier release 20260822223110 (GL-only overlay). Standing rule: any future
  full-viewport popup must offer backdrop-click-to-hide or it locks the page.

- **2026-08-22 — "The Binder" report-generation popup (v1.80.0, frontend-only).**
  Report runs (Briefing Book PDF ~minutes / Excel Register ~40s+ / PPTX) previously showed only
  the button's busy label. Three animated studies (The Press / The Binder / The Draft) were
  demoed as an artifact — same process as the Data Conveyor — and the user picked **B, The
  Binder**: a centred popup over the dimmed page where the briefing book assembles from its 7
  REAL sections (chips light gold in sequence, a gold sheet flies into the green Fraunces-titled
  book, the book pulses on receive). Headline names the running format, the **elapsed clock is
  real** and sits beside the true poll cadence (6s book / 5s xlsx / 6s ppt) — no fake progress;
  **× hides the popup while the run continues** (`rgHidden` resets on the next run). Wiring is
  one `rgStart(labelKey, pollSecs)` call per runner + ONE central close: a `buGenBusy`
  subscription calls `rgStop` on any exit (success / FAILED / timeout / enqueue error), so no
  per-path teardown. RTL mirrors the fly direction + book spine/page-edge; reduced-motion
  freezes the loops (clock keeps ticking). GL-only CSS (`.rg-*` in app.css) — no shared change.
  Smoke `tests/rg_browser_smoke.py` **13/13 incl. a LIVE Excel-register generation** (popup
  content, ticking clock, hide-and-continue, real download lands, popup self-closes, re-show on
  a new run, AR strings). Deployed webtier release 20260822222016 (GL-only overlay).

- **2026-08-22 — Costing Adjustments feedback round (v1.79.0, GL/db/25 re-run).**
  Seven user fixes after hands-on testing: ① **accounting period is MANDATORY** — the
  "Full year" option is gone (server 400s without `period`; the drawer defaults it to the
  current month for the current year / December otherwise, and a year change keeps the chosen
  month via a `setTimeout(0)` re-assert — the KO options-rebuild blanking gotcha); ② + ③
  **dependent pick lists** — Task suggestions scope to the picked project and Expenditure-Type
  to project(+task) via NEW routes `costadj/meta/tasks` + `costadj/meta/etypes` over
  `prod.dct_butil_key_cache` (db/v2/120, hourly — the butil filter LOV source; loaded on the
  inputs' CHANGE events, never per keystroke; drawer datalists `ca-task-dl`/`ca-et-dl` replace
  the year-global ones); ④ **register columns re-ordered** to the annotated layout — Status ·
  Project · Task · Etype · Adjustment · Budget Override · Invoice · Supplier · Ref · Reason ·
  Year · Period · Classification · audit columns (envelope `stateRev:2` so the designed order
  beats stale IR autosave); ⑤ **Status renders as a coloured icon pill** with NO shared-IR
  change — `runCostAdj` stamps `row._rowClass` (`ca-st-draft/approved/rejected`) and app.css
  styles ONLY `td[data-key=status] span` from the row class (✎ grey / ✓ green / ✕ red;
  computed-style verified); ⑥ **budget year comma-free** (column type `text`, renders 2026 not
  2,026); ⑦ **Invoice number = Fusion deep-link** via the IR's EXISTING `env.cellLink` hook —
  `FusionLinks.invoice(invoiceId)` from the caRowMap side-map (the id never rides the row), so
  again no shared change; `caGridClick` lets `a.ir-link` clicks navigate instead of opening
  the drawer. Deploy = GL/db/25 re-run (now 9 routes) + frontend. Tests grew to
  `costadj_api_smoke.py` **50/50** (+ mandatory-period 400, dependent tasks/etypes, no-project
  400) and `costadj_browser_smoke.py` **33/33 EN+AR** (+ column order, 12-month period list w/
  default, scoped task/etype lists, DRAFT/APPROVED pills, comma-free year, AP_VIEWINVOICE
  href). Deployed webtier release 20260822190726 (GL-only overlay).

- **2026-08-22 — Projects Costing Adjustments (v1.78.0, db/v2/124 + GL/db/25 + GL/db/21 re-run).**
  User-approved shape (plan `final apps/GL/COSTING_ADJ_PLAN.md`): ONE table `DCT_PA_COST_ADJ` —
  a row = one **signed** cost adjustment (± AED) on a budget line (project × task × etype),
  optionally referencing the mis-coded AP invoice distribution (which may itself carry NO
  project coding) + an optional **signed `BUDGET_OVERRIDE`** for the same line + reason /
  classification (lookup `PA_COST_ADJ_CLASS`) / comments; status DRAFT → APPROVED/REJECTED
  (lookup `PA_COST_ADJ_STATUS`, manual approval for now). `db/v2/124` = table + seq (`PCA-#####`)
  + aggregate view **`DCT_PA_COST_ADJ_BUTIL_V`** (APPROVED only, butil key grain, BUTIL_END-aware
  like the procash view; NULL accounting_period counts in every YTD window) + lookups + privilege
  `GL_MANAGE_COST_ADJ` + ADMIN synonyms. `GL/db/25` = 7 additive routes: `GET/POST costadj`,
  `PUT/DELETE costadj/:id` (PUT = full-document replace, DRAFT only; DELETE any status —
  manage gate), `POST costadj/:id/action` {APPROVE|REJECT}, `costadj/meta/dists` (AP dist
  search, ≥2 chars, cap 50) + `costadj/meta/lookups` — reads gated GL_VIEW_BUDGET_UTILIZATION
  (NULL legacy), writes/approve GL_MANAGE_COST_ADJ w/ legacy SYS_ADMIN; **the meta routes sit
  under a third segment (AP procash pattern) so they never collide with `costadj/:id`**.
  `GL/db/21` re-run (still the ONE live GET /butil owner; 07 stays without it): new param
  **`costadj` DEFAULT Y** ("Include Cost Adjustment", checked by default — user spec) — when on,
  rows AND totals ship budget/budgetAnnual/actualAp/fundAvailable **already adjusted server-side**
  (Actual +Σamount, Budget +Σoverride annual AND YTD-from-period, Fund +Σ(override−amount)), so
  KPI band / CSV / negFund band follow with zero client math; either way each row carries
  `costAdj`/`costAdjOvr`/`costAdjOvrAnnual`/`hasAdj` + totals `costAdj`/`costAdjCount`/
  `costAdjOvr(Annual)` + `includeCostAdj` echo (handler now 14,541 chars, PROCASH + COSTADJ both
  verified in user_ords_handlers). **GL post-05 re-run list = 07..25.** Frontend: new
  **Projects › Costing Adjustments** tab (register on the shared IR `GL_PA_COST_ADJ`/section
  `cadj`, row click → `.dw-ca` drawer: AP-dist search → Select fills source ref + original coding
  + default amount; corrected line via the butil datalists; signed Amount + signed Budget
  override; Approve/Reject with confirm, Delete; APPROVED/REJECTED rows read-only w/ status
  ribbon); butil Search region gains the **Include Cost Adjustment** checkbox (default ON, sends
  `costadj=N` when unticked — server default is Y); adjusted butil rows show **`(*)` prefixed in
  the FIRST cell** + a `.cadj-note` under the results table explaining it — **both bind to the
  RESPONSE echo (`buCadjOn`)**, so the page never stars a line whose loaded figures don't carry
  the adjustment; encumbrances/pending/override-drawer param builders `delete p.costadj` (those
  endpoints have no such figure); CSV export appends Cost Adjustment / Budget Override (Adj) /
  Has Adjustment columns. Books/registers/report bridges deliberately unchanged (published
  definition — same decision as procash). Tests: `tests/costadj_api_smoke.py` **46/46** (CRUD +
  approve/reject lifecycle, validations incl. bad period/classification, dist search, DRAFT
  inert, approve moves row+totals exactly, costadj=N reverts while still reporting components,
  YTD period window, APPROVED locked, cleanup restores baseline) + `tests/costadj_browser_smoke.py`
  **24/24 EN+AR** (tab, default-on checkbox, drawer create via dist search, confirm-dialog
  approve, star + note appear/disappear with the toggle, figures revert by (override−amount),
  RTL). Smoke gotcha: wait on the **response echo** (`buCadjOn()===false`) after toggling — a
  bare `!buLoading()` wait raced the re-run once. Deployed webtier release 20260822163725
  (GL-only overlay).

- **2026-08-22 — Conveyor popup + "Refresh data" dropdown (v1.77.0, frontend-only).**
  User feedback on v1.76.0: the conveyor band sat top-left and looked off — it is now a
  **CENTRED fixed popup** (`.cvb` = full-viewport overlay z-58 with dimmed backdrop, `.cvb-card`
  centred; z sits UNDER drawers 70 / platform modals 60). The x hides the popup only — the run
  keeps going, `cvbHidden` resets on every new run, and the header button keeps its busy label.
  Second request (from the button-review recommendations): the THREE refresh buttons on the
  butil header folded into ONE **"Refresh data ▾"** dropdown on the shared `.gen` pattern —
  Refresh source data / Refresh actuals / **Rebuild views (SYS_ADMIN-only**, `ko if: isSysAdmin`
  — a plain property, re-evaluated because the whole menu lives inside `ko if: rdOpen`) + a
  **"Source data last refreshed"** footer fetched from GET /butil/refreshdata on open (max
  lastFinished parsed from the 12-h display format — lexical max is WRONG across AM/PM).
  Header is now Generate Report ▾ · Export CSV · Refresh data ▾. Other pages' refresh buttons
  untouched. Smoke `tests/cvb_browser_smoke.py` now **26/26 EN+AR incl. live fleet run** (72s);
  flake fixed with an explicit wait_for_selector(visible) after flipping pdataBusy (initial
  render race, the repo's standing wait-on-condition rule). Deployed webtier release
  20260822145611 (GL-only overlay).

- **2026-08-22 — Data Conveyor progress band for Refresh source data (v1.76.0, frontend-only).**
  User asked for an intuitive "construction motion" while the refresh runs; three animated
  studies (Crane Build / Gearworks / Data Conveyor) were demoed as an artifact and the user
  picked **Data Conveyor**. While `pdataBusy`, a `.cvb` status band appears under the butil
  page head: gold parcels ride a moving belt from a **Fusion** chip into an **i-Finance** tray
  (pure-CSS loop: `cvb-ride`/`cvb-spin`/`cvb-belt` keyframes), and a **15-segment bar + "X of
  15 extracts finished" + "now extracting: <jobs>"** advance on the REAL 5-second poll
  (`pdataProgress()`: done = jobs not READY/CLAIMED, running = CLAIMED names) — never a fake
  spinner. RTL mirrors the belt via `scaleX(-1)` on the SVG only — the Fusion/i-Finance labels
  are HTML chips outside the mirrored SVG so they stay readable; `prefers-reduced-motion`
  stops the loops, counters keep updating. KO-in-SVG gotcha avoided: the segment bar is an
  HTML `foreach` UNDER the svg (KO's template engine creates HTML-namespace nodes, so a
  `foreach` INSIDE `<svg>` produces dead elements). Smoke `tests/cvb_browser_smoke.py`
  **16/16 EN+AR incl. a LIVE fleet run** (68s, genuine progress observed, band auto-hides).
  Deployed webtier release 20260822144134 (GL-only overlay).

- **2026-08-22 — Refresh source data widened to ALL 15 full extracts (v1.75.0, GL/db/19 re-run).**
  User request: the butil page's "Refresh source data" button must also run the AP header /
  lines / distributions, PO, PR and GRN full jobs — not just the PROJECTS_DATA set. The
  `POST /gl/butil/refreshdata` bridge still calls `atd_set_pkg.run_now('PROJECTS_DATA')` and
  now ALSO queues the 12 transaction FULL jobs with the same mechanics (`run_status='READY'`,
  drained by the 3-VM fleet's idle cycle): AP Invoices/Invoice Lines/Distributions Full ·
  PO Headers/Lines/Schedules/Distributions Full · PR Headers Full / PR Lines All /
  PR Distributions Full · GRN Temporary Job + GRN Gap. **One deliberate difference from
  run_now: a CLAIMED (in-flight) job is left alone** — re-queueing it would double-run the
  extract (live-verified: the first POST returned queued=14 because PR Distributions Full was
  mid-run, and it was correctly skipped). `GET /butil/refreshdata` lists all 15 jobs. Frontend:
  hint/done texts name the full scope, poll ceiling 90→180 tries (~15 min; extracts total
  ~316s serial ≈ 2–4 min wall on the fleet). GRN gap injections re-derive within 15 min of the
  GRN extracts (ATD_GRN_GAP_MERGE_JOB). E2E: POST queued 14 (+1 already running), all 15
  finished SUCCESS. Deployed webtier release 20260822142319 (GL-only overlay).

- **2026-08-22 — Butil UX round v1.74.0: over-budget flagging + Type column removed (GL/db/21 re-run).**
  User requests: ① flag negative Fund Available lines, ② warning region above Overview,
  ③ remove the TYPE column. Server: `GET /gl/butil` now also aggregates **`negFund`** (count)
  + **`negFundTotal`** (sum) of lines whose *effective* Fund Available < -0.005 across the FULL
  filtered set (procash=Y uses fund − procash, mirroring the displayed figure). Change lives in
  **GL/db/21** (owns the live GET /butil) and is mirrored into 07's copy so a future 07→21
  chain keeps it. Deploy = 21 only (handler 11,888 chars, NEGFUND + PROCASH both verified in
  `user_ords_handlers`). Frontend: red `.bu-alert--negfund` warning band above the Overview
  region (count + over-spent amount, EN+AR, info-only — not clickable), Fund Available cells
  < 0 render **bold red on a soft red tint with a triangle warning flag** (`.nf-flag`; tooltip
  explains), and the **Type column is REMOVED** from the results table + CSV export
  (`skCols` 20→19; Project Type stays available as a Search filter + applied-filter chip).
  Live under the page default scope: 6 lines over budget by 16.75M total. Smoke
  `tests/negfund_browser_smoke.py` **16/16 EN+AR**; deployed webtier release 20260822135155
  as a **GL-only overlay release** (copy-of-live + GL/Jet, so parallel sessions' in-progress
  work in the shared tree was NOT shipped).

- **2026-08-22 — Budget Utilization page-load fix: db/v2/120 filter cache DEPLOYED (120→07→21).**
  User report: the page (the app's landing page since v1.64.0) took 10-15s+ to open. Measured
  cause: `GET /gl/butil/filters` ran **eight** distinct-scans of `DCT_BUDGET_UTILIZATION_V`
  (~1-2s each in SQLcl, worse through ORDS) and `GET /gl/butil/lov` four more — ~13 heavy view
  scans per page open; the main `/butil` report itself is only ~0.8s. Fix = the parallel
  session's `db/v2/120` cache (committed 2026-08-18, never deployed) + two changes made now:
  **refresh interval 6h → HOURLY** (user rule: the cache may never be staler than the data;
  figures are NEVER cached — only filter pick-lists + drill key-sets; the report always reads
  the live view) and **`/butil/lov` rewritten onto `DCT_BUTIL_KEY_CACHE` too** (repo 07 had
  left it on the view). Deploy order **120 → 07 → 21** — 21 is MANDATORY after any 07 re-run:
  repo 07's `GET /butil` has no procash code and would silently kill the v1.69.0 feature
  (pre-deploy diff proved live `GET /butil` is byte-identical to GL/db/21, and live
  `butil/lines` differs from repo 07 by exactly the five kys cache swaps — char count
  36,128→36,103 = 5 × the 5-char name difference). Verified after deploy: filters/lov carry
  ZERO view references (cache lookups 0.04-0.13s), procash flag intact, cache↔view parity
  (17=17 sectors, 617=617 projects for 2026), butil figures byte-identical,
  `DCT_BUTIL_FILTER_CACHE_JOB` hourly/SCHEDULED. Page-open DB time ≈ the ~1s report now.
  A brand-new filter value appears in the LOVs within the hour (data itself refreshes on the
  same cadence); figures are live instantly.

- **2026-08-18 — BUDGET_UTIL_SECTOR joins the override contract (reporting/db/08a).** The
  third butil report predated the feature and had NO `pre_sql` hook, so it always showed the
  raw Fusion budget while the Book and Register honoured `ovr=Y`. Added the same
  `set_butil_ovr` / `clear_butil_ovr` pair to its MULTI spec + `ovr` to `params_json` (so the
  BI Reports run-parameters drawer offers it). **08a is MERGE-bearing and Linux SQLcl cannot
  run it at all** — applied to PROD by targeted CLOB surgery on `source_ref` (guarded on
  `INSTR(source_ref,'pre_sql')=0`, so it is idempotent) with the seed file patched in
  lock-step; the `:` in the bound `pre_sql` is built as `CHR(58)`. Verified: spec still parses
  as JSON with all 6 sections, and a temporary -1,000,000 change moved the sector's budget by
  exactly that under `ovr=Y` (PASS), figures identical under `ovr=N`. NOTE: BUDGET_UTIL_BOOK
  and BUDGET_UTIL_REGISTER bind the flag but do NOT declare `ovr` in `params_json` — the GL
  page bridge passes it explicitly, so a run from the BI Reports page cannot tick it.

- **2026-08-17 — Excel Budget Override becomes a signed BUDGET CHANGE (v1.66.0; db/v2/106+107,
  db/v2/37, GL/db/07+15).** User request: the Excel figure must be a **+/- change added to the
  budget line for a chosen accounting period**, the download must be scoped and line-grained,
  and ticking *Select to include Budget Override* must move **both** the Annual and the YTD
  budget on the page and in the reports.
  - **Model flip:** `DCT_PROJECT_BUDGET_USER.budget_user` (absolute replacement) →
    **`budget_change`** (signed, ADDED to the budget). `106.1a` performs the one-time
    migration — guarded on the old column name, so it runs exactly once: **DELETE all rows
    (179 legacy ADMIN rows, user-approved) then RENAME COLUMN**. A PUT still sending
    `budget_user` is rejected with a **400** naming the new workbook (a silent reinterpretation
    of an absolute figure as a delta would be a data-integrity event).
    **The rename makes flashback recovery impossible (ORA-01466 across the DDL) — take a
    snapshot BEFORE re-running a migration like this.**
  - **Excel API v2** (`db/v2/106`): `GET /xl/budget/` is now **one row per budget LINE**
    (project × task × expenditure type) carrying `budget_annual`, `budget_ytd` (periods ≤ the
    selected one), `budget_change`, `line_change_total`, `adjusted_annual`, `adjusted_ytd`,
    `business_unit`, `project_type`; scoped by `business_unit` / `project_type` matched on the
    **exact** stored name and defaulting to `Department of Culture and Tourism` /
    `DCT OPEX Project Type`; new `GET /xl/lov/:kind` (business-units · project-types · periods ·
    budget-years · reasons) and an OpenAPI v2 whose four download parameters carry live `enum`
    lists so the add-in renders drop-downs.
  - **THE load-bearing data fact:** the Fusion budget is **un-phased** — 1,736 of 1,779 FY2026
    lines carry ONE period row, 1,570 of them in `01-2026`. A change booked at 08-2026 therefore
    usually has **no matching budget row**, so: `save_item` validates the LINE within the budget
    year (not the exact period row); `db/v2/37`'s `pb` CTE now feeds from a **`pb_src` UNION ALL**
    (budget rows contribute `budget`, change rows contribute `chg`) instead of an outer join;
    `GL/db/15` joins the budget per LINE with a LEFT join; and `GL/db/07`'s budget drill folds
    both sources into one row per period. Any of these left as a join would silently drop
    changes and stop the drill reconciling to the KPI.
  - **Deploy order (as executed):** `106` → `107` (fresh session) → `db/v2/37` → `GL/db/07` +
    `GL/db/15` (fresh session) → `compile_schema` to **0 INVALID**. The rename invalidates
    `DCT_BUDGET_UTILIZATION_V` and `DCT_BUTIL_SCOPE_V` in between — expected, recompile clears it.
    **GL post-05 re-run list is unchanged (07..20).**
  - **Frontend (v1.66.0):** the KPI tile is now **Budget Change (+/-)** with a signed, colour-coded
    value; the drawer is line-grain (Annual/YTD Fusion · Change ± · Adjusted Annual/YTD) with the
    signed input, updated CSV and totals footer. **The checkbox keeps its business wording,
    "Select to include Budget Override"** — only its hint changed (it now says the change is
    ADDED). NOTE: a parallel session had already bumped APP_VERSION to 1.65.0 for the Budget
    Transactions work, so this shipped as **1.66.0**.
  - **Verified:** xl API battery 40/41 (the one miss was the test's own AFH expectation — see
    below) · GL end-to-end 18/18 · SQL reconciliation (ovr flag is a no-op with zero changes;
    annual and YTD each move by exactly the change; an orphan-period change still counts; YTD
    excludes it before its period) · browser smoke NEW `tests/butil_change_browser_smoke.py`
    **31/31** EN + AR/RTL.
  - **Found, not fixed (data):** `business_unit=Abrahamic Family House` downloads **0 lines** —
    all 45 AFH budget lines reference task ids missing from the `ATD_TASKS` extract, so they are
    excluded here exactly as they already are on the butil page (platform '#'-surrogate rule).
    Widening the tasks extract to AFH lights both up together.
  - **Excel workbook:** the distributed v1 workbook still has the v1 columns and its uploads now
    fail with the `budget_user` 400. Rebuilding the layout REQUIRES the add-in in **Windows
    Excel** (cannot be done from Linux) — the click-path is in
    `docs/excel-integration/VBAFE_BUDGET_USER_GUIDE.md §3`. `style_template.py` was rewritten to
    resolve columns by **header text** (not fixed letters) so it follows whatever layout is
    published, and `load_overrides.py` now posts the sheet's adjustment column VERBATIM as
    `budget_change` (dry-run: 247/254 rows, −87.6M net).

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

## 2026-08-19 — Executive Project Dashboard: Portfolio + Project 360 (v1.70.0)

NEW `db/v2/122_dct_project_dashboard_views.sql` (8 views) + ADDITIVE
`final apps/GL/db/22_gl_projects_ords.sql` (10 routes) + two GL pages.
**GL post-05 re-run list is now 07..22.**

**Deploy order:** `db/v2/122` (SQLcl, fresh session) → `GL/db/22` as **`prod_mcp`**
(gl.rest lives under ADMIN; under the `prod` conn `ORDS.DEFINE_TEMPLATE` throws
ORA-01403) → frontend with the `APP_VERSION` bump → webtier release.

**What it is.** A Portfolio page ranking every project in a budget year with an
advisory health band, drilling into a Project 360 page (identity, KPI band,
Budget→PR→PO→GRN→Invoiced→Paid funnel, tasks, pipeline, AR, budget
transactions, cashflow). Budget-year scoped, so **every money figure reconciles
to the Budget Utilization page** — asserted, not assumed: `tests/projects_api_smoke.py`
compares all seven measures against `/gl/butil` for full-year, a period cut and a
sector filter (21 assertions, all exact to 0).

**Why `DCT_BUDGET_UTILIZATION_V` was NOT modified.** It ends with a `HAVING` on
the Fusion annual budget, so a project with spend and no budget line is invisible
in it. Relaxing that is tempting and wrong: the view's select list uses
`MAX(MAX(x)) OVER (PARTITION BY budget_year, project_key)` for sector, cost
centre, chapter, program, entity-specific and the combination builder, and a
window function is evaluated **after** `HAVING` — admitting the hidden rows
enlarges every one of those partitions and can change attributes on rows that are
already published, plus every cache and report downstream. `DCT_PROJECT_SPEND_V`
carries the unbudgeted leg separately and a `FULL OUTER JOIN` surfaces it. Live:
**9 projects / AED 27.3M**, all Abrahamic Family House, plus partial cases (one
project has 616K of spend on combinations with no budget line).

**Data limits found by probing before building, and honoured in the product:**
- `ATD_TASKS.ACTUAL_START_DATE` / `ACTUAL_FINISH_DATE` are **entirely empty**
  (0 of 6,059). Schedule slippage is not computable, so the health score has
  **four** components (burn 40 / funds 20 / approvals 20 / activity 20), not five,
  and the Tasks region shows planned dates only and says why.
- **No AR receipts extract** — billed revenue only; collections carry a visible
  `DATA GAP` badge, matching `reporting/db/35`. Only **51 of 991** projects carry
  any AR line, so the empty state is the normal case, not a fault.
- `ATD_PAYMENTS` has **no invoice id and no project**, so paid is derived from
  each invoice header's paid ratio, **capped at 100%** (20 live invoices carry
  paid > amount), applied to that invoice's project distributions.

**Gotchas paid for during this build:**
1. `SELECT *` across joins that each expose `project_number`/`budget_annual` gives
   duplicate cursor columns and an **uncatchable ORDS 555**. Enumerate columns.
2. `PROJECTS_V` exposes `APPROPRIATION` and `CHAPTER` — not `APPROPRIATION_CODE`
   / `_DESC` / `CHAPTER_NAME`.
3. `PA_BUDGET_TRX_HEADERS` has `DECREE_NO`, no `CREATED_BY` (use
   `DEPT_1ST_LEVEL_APPROVER`); `AP_INVOICES` has no `PAYMENT_STATUS` (reuse the
   derivation from `AP/db/05`); `PR_DISTRIBUTIONS` keys on `REQUISITION`.
4. Frontend: a `ko.computed` reading a **plain array** never re-runs. `pfPressure`
   / `pfElapsed` read `pfData()` (observable), not `self.pfItems`.
5. Running `db/v2/122` from `prod_mcp` makes the grantor ADMIN itself, so the
   `GRANT ... TO admin` block tolerates ORA-01749 (on ADB, ADMIN already reads PROD).

**⚠ Pre-existing issue found, NOT caused by this work — RESOLVED 2026-08-22:**
`db/v2/120_dct_butil_filter_cache.sql` was committed but undeployed at the time;
it has since been **deployed as 120→07→21** (see the 2026-08-22 entry at the top).
The portfolio routes still read `DCT_PROJECT_PORTFOLIO_V` directly and have no
dependency on the cache.

**Performance:** `/gl/projects?year=2026&limit=2000` is ~9s warm (butil is ~4.9s)
— it joins eight views and runs six aggregate scans. Both pages carry the standard
`oj-progress-circle` busy overlay. If this needs to come down, the cheapest win is
folding the spend/unbudgeted scan into the health scan (both already read
`DCT_PROJECT_HEALTH_V`, which exposes `spend_total` and `has_budget`), removing one
full rebuild of `DCT_PROJECT_SPEND_V`.

**Tests:** `tests/projects_api_smoke.py` **63/63**; `tests/projects_browser_smoke.py`
**34/34** EN + AR/RTL (evidence in `/tmp/gl_proj_evidence`). Browser gotchas honoured:
wait on `ko.dataFor(document.body)` (not just the nav — it can be undefined for a
tick after the first bound element appears), never `networkidle`, and target
`button[data-bind*="toggleLang"]` because `.lang-flip.last` is Sign out.

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

---

## Landing page + status pills — 2026-08-17 (v1.64.0, frontend only)

### Landing page = Projects › Budget Utilization
`self.view` now boots on `butil` instead of `overview` (Chart of Accounts), and
init calls **`self.go(self.view())`** rather than its own `if (view==='overview')
loadCoa()` branch — the landing page now loads through exactly the same path a
nav click takes, so changing it again is a one-word edit with no second load
branch to keep in sync. The group row follows for free (`activeGroup` is derived
from the view). `#pg-butil` / `#pg-overview` ids were added to those two page
containers, which had none, so tests can assert which page is actually shown.

### Status pills (Budget Transactions)
Header **Status**, the line **Line / Baseline / Journal status** columns and the
approval **State** were plain text or a flat grey chip. They now render as
tinted pills with an icon disc — ok `✓` green · err `✕` red · warn `!` amber ·
info `•` blue · mute `–` grey (`.st`/`.st--*` in `app.css`, scoped to
`#pg-budgettrx`, logical properties so they mirror in RTL). Negative figures in
the details grid turn red; line/approval **counts** became chips, dimmed at zero.

**The tone is decided in the VM (`btTone`), never in markup, and the failure
patterns are tested FIRST.** The live source vocabulary is inconsistent in both
case and wording — a `SELECT ... GROUP BY` over the loaded data returns:

| tone | values actually present |
|---|---|
| ok | `Baselined` (2,063) · `SUCCESS` **and** `Success` · `PASS` **and** `Pass` · `Approved` (1,761) |
| err | `Baselining Failed` (15) · `FAILED` · `ERROR` · `Rejected` |
| warn | `Pending Approval` · `Pending For Approval` · `IN PROCESS` |
| mute | `Draft` **and** `DRAFT` · `NOT CREATED` · `Withdraw` · null |
| info | `Entered` (105) |

So matching is case-insensitive on keywords — and because **"Baselining Failed"
also contains "baselin"**, an equality or prefix match would have painted a
failed transaction green. That ordering is asserted in the smoke test.

### Verified (v1.64.0)
`tests/budgettrx_browser_smoke.py` **54/54** EN + AR/RTL — adds the landing-page
assertions (Projects group + Budget Utilization sub-tab lit, `#pg-butil` shown,
`#pg-overview` not), the full tone table above driven through `btTone`, and a
**computed-style** check that the pill is actually painted and its `::before`
glyph resolves (a tone class with no CSS behind it would still pass a class-name
assertion). Live page shows the real spread: 86 ok · 10 info · 2 warn · 2 err.

---

## Budget Transactions — criteria parity with Budget Utilization — 2026-08-17 (v1.65.0)

Deploy: **`otbi-atd/db/80`** (new view + synonym) **then** `GL/db/20` (re-run).

### New DB object — `otbi-atd/db/80_pa_budget_trx_line_v.sql`
`PROD.V_PA_BUDGET_TRX_LINE` + its ADMIN synonym: one row per transaction line
over all three per-type line tables, projecting the columns they share, plus the
GL classification dimensions.

**Classifications resolve BY SEGMENT, not by the whole combination.** Joining
the line's 10-segment `CODE_COMBINATION` to `DCT_GL_COA_SNAP.CC_STRING` matches
only 82–99% of lines (entity 617 / Abrahamic Family House combinations are not
all in the snapshot, and **5,546 Estimated-Cost lines carry no combination at
all**). Segment maps — cost centre→Sector, appropriation→Chapter,
program→DCT Program — cover everything the snapshot knows, and each is 1:1 in
the data (verified: zero cost centres with >1 sector, zero appropriations with
>1 chapter), so the `MAX()` aggregates pick a value rather than one of several.
Cost-centre code falls back to the trailing digits of the `COST_CENTER` label
("AFHC Education and Dialogue-6170200" → 6170200) for the combination-less lines.
**An Estimated-Cost line legitimately has no code combination** — it is not
mandatory for that budget type (user-confirmed 2026-08-17) and 5,546 of them
carry none. So the segment codes fall back to the line's own **task** attributes
(the platform's task-first attribution, same source and LPAD widths as
`DCT_BUDGET_UTILIZATION_V`), which answers for 5,071 of those 5,546. Without the
fallback, a Chapter / Program / Appropriation filter would silently exclude every
Estimated-Cost transaction — not because it belongs to another chapter, but
because the row could not say which. `DIM_SOURCE` records which path each row
took (`COMBINATION` / `TASK`).

Coverage: cost centre 100% · sector 95.8% · **program 97.4%** (was 70) ·
**appropriation 97.4%** · **chapter 89.5%** (was 66). Estimated-Cost lines with a
chapter went from ~1.1k to 6,658 of 7,876.

The view also emits `period_from_num` / `period_to_num` (YYYYMM), because
**MM-YYYY cannot be compared or sorted lexically** ('02-2025' > '01-2026'), each
guarded by a format check so one malformed source value cannot ORA-01843 a query.

### `GL/db/20` — 9 line-level criteria + free text + a new LOV route
Search criteria went 10 → 21 fields: the header-level ones unchanged, plus
**Sector · Chapter · DCT Program · Appropriation · Cost Centre · Project · Task ·
Expenditure Type · Accounting Period**, a free-text **Search**, and the shared
**Figures in** display unit. New `GET /gl/budgettrx/lov` carries the four big
type-ahead lists (886 projects · 1,825 tasks · 184 expenditure types · 115 cost
centres) — the same split Budget Utilization makes between `/butil/filters` and
`/butil/lov`. **post-05 re-run list unchanged at 07..20.**

A transaction matches when **one of its lines satisfies all** the line criteria
(one subquery, not one per criterion). Free text now reaches line attributes too.

> **The line subquery is behind an `l_lineflt` guard.** Applied unconditionally
> it would silently drop the **110 headers that legitimately have no lines yet**
> (Entered / Rejected / Baselining-Failed) from the unfiltered grid. Asserted in
> the API smoke.

### ⚠ PERF — the line subqueries MUST be `WITH … /*+ MATERIALIZE */`
This cost two rounds to get right and is worth reading before touching the file.

A plain correlated `EXISTS` made the optimizer choose **VIEW PUSHED PREDICATE**:
it pushes `h.transaction_num` INTO the view and rebuilds it — a 3-table UNION ALL
joined to **four GROUP BYs over the 9,447-row COA snapshot** — *once per header
row*. Measured **3.5M buffer gets, 39s per execution**; a sector-filtered page
never returned through ORDS (>120s, client timeout).

Rewriting as an uncorrelated `(num,type) IN (SELECT /*+ UNNEST */ …)` was **not
enough**. The same `sql_id` then had three children — a hash-join plan at 0.22s
and a pushed-predicate plan at 39s — and ORDS kept landing on the slow one. The
fast plan was luck, not structure. Identical SQL ran 0.3s in SQLcl and 80s
through ORDS, which is exactly what a plan-choice problem looks like; don't
conclude "the SQL is fine" from a SQL*Plus timing.

`MATERIALIZE` removes the choice: the key set is built once into a temp table and
the EXISTS probes that. Worst case went **88s → 0.84s**. The bind guards inside
each CTE (`l_lineflt='Y'`, `l_srch IS NOT NULL`) are start-up filters, so an
unused CTE costs nothing — the unfiltered grid the page opens with is 0.01s.

### Frontend
The four `<datalist>` lists load in **parallel with, and are not awaited by**,
the grid — `loadBtFilters` fires `loadBtLov()` without chaining it. Awaiting them
made the first page-open race: the grid sometimes rendered empty because ~2,900
option elements were still in flight. A failed LOV load is swallowed: the
criteria are free-text inputs that simply lose their suggestions.

Every line-level criterion carries a ⓘ saying it matches the transaction's detail
lines, and a chip counts how many are active, so nobody reads them as header
filters.

**Not added, deliberately:** butil's *Consider Override Budget* — it applies the
`DCT_PROJECT_BUDGET_USER` override to butil's computed figures and has no
counterpart in PBT data, which is the source system's own transaction register.

### Budget Type + Transaction Year are MANDATORY (same round, user decision)
Both are marked `*`, have **no "All" option**, and the server **400s** without
them — so a direct curl cannot ask for the whole table either. The page defaults
to the first budget type and the current year (falling back to the newest year
with data), so it opens on a real scope rather than an error, and **Clear resets
to that default scope instead of emptying it** — clearing a mandatory field would
only produce an error message.

Because the type is always known, both line CTEs add `trx_type = l_type`, which
cuts the 18,544-row union to one type's table.

Everything else on the page is **scoped to that type+year too**: `/budgettrx/lov`
takes both, and `/budgettrx/filters` takes them optionally and narrows its
line-derived lists (sectors, chapters, programs, appropriations, periods) to
values that exist in scope. Before this, the criteria offered an Appropriation
that returned zero rows under the selected type — the API smoke caught exactly
that (`appropriation 000000 -> 0`). Page open therefore makes one unscoped
filters call (to learn the types and years), then one scoped call once the
defaults are set; changing either re-fetches through `btRescope()`.

Timings on the live tier: grid 0.10s unfiltered, 0.43s worst filtered,
filters 0.82s, lov 0.65s.

### Default opening scope — 2026-08-17 (v1.68.0, user-chosen)
The page opens on **Additional Fund · current year · Department of Culture and
Tourism · DCT OPEX Project Type** (`BT_DEFAULTS` in `app.js`; the year is always
"current, else newest with data", and Project Type matches the Budget
Utilization default). Each default is applied **only when the live LOV offers
it** — a hard-coded value that no longer exists would be blanked by KO's
`options` binding anyway, leaving the observable and the `<select>` disagreeing.
**Clear** resets to the same four.

Defaulting Business Unit and Project Type re-opened the dead-option problem one
level down — the criteria LOVs were scoped to type+year only, so the Sector list
still offered sectors with no rows under the default BU. `/budgettrx/filters`
and `/budgettrx/lov` therefore take **`bu` and `projecttype`** as well
(`l_hs` flag = "any header scope set"), and the frontend re-fetches on all four.
Sector list went 17 → 12 entries, all of which return rows.

> **`btRescope()` is DEBOUNCED (60ms) and that is load-bearing.** Applying four
> defaults fires four subscriptions, and KO's `<select>` write-back means some
> land a tick later — a plain "am I still applying?" flag let a half-built scope
> (type+year, no BU) through and fetched every list twice. Coalescing into one
> tick makes the call count independent of firing order: page open is now
> exactly 4 requests (unscoped filters → grid → scoped filters → lov).

> **⚠ DEPLOY ORDER — the client goes FIRST when a parameter becomes mandatory.**
> The v1.67.0 server change (400 without type+year) went out minutes before the
> matching frontend. In that window a still-loaded older page sent no type/year
> and got the server's raw `type and year are required` with `0 of 0` — which is
> exactly what it should do, but it looks like a broken page to whoever is
> holding it. Deploy the frontend first, or make the server tolerant until the
> clients have rolled.

### Verified
API `tests/budgettrx_api_smoke.py` **42/42** (every criterion narrows, criteria
AND on one line, period ordering is numeric, line-less headers survive, LOVs
narrow to the scope, missing type/year → 400, 400/404/401).
Browser `tests/budgettrx_browser_smoke.py` **85/85** EN + AR/RTL (incl. the four defaults and Clear restoring them).

Test gotchas:
- `.lbl` is `text-transform:uppercase` **and** Chrome's `innerText` upper-cases
  the trailing ⓘ to Ⓘ — strip it (and the `*`) before comparing.
- Assert the type filter as a **subset** of `{'Annual-Budget'}`, not equality:
  the default year may hold no rows of a type, and an empty grid is a correct
  answer. What must never happen is another type slipping through.
- Pick test values from the **scoped** `/budgettrx/filters`, not the unscoped
  one, or the test filters by a value that cannot exist in its own scope.
- Estimated-Cost touches every 2026 project, so its LOV legitimately **equals**
  the all-types list — assert subset, not "smaller".

## Procash on Budget Utilization (2026-08-17, GL v1.69.0 + AP/db/13 + GL/db/21)

`GET /gl/butil` gained **`procash=Y`** — the page's "Include Procash" checkbox, built on the
same pattern as the Budget Override flag.

- **Why:** procash records money already pushed through the bank portal that has NOT reached
  Fusion as a payable invoice, so no AP / GRN / PR / PO figure sees it. Between the payment and
  the invoice that spend is invisible here — the window a budget owner can overspend in.
- **What counts** (user decision): every LIVE procash transaction with no Fusion invoice linked
  — draft, submitted, in approval, approved and processed alike. The row leaves the figure the
  moment its invoice is linked, because the AP actual then carries the same spend. Cancelled and
  rejected never count.
- **Off (default)** the figure is reported and changes nothing, so Fund Available keeps the
  definition the books, registers and the Actuals↔Butil reconciliation already quote.
  **On**, Actual includes it and Fund Available is reduced by it.
- Always returned: `procash`, `procashCount`, `fundAvailableExProcash`, `procashUnmapped`.
- **`procashUnmapped`** is live procash coded to a GL combination instead of project/task/
  expenditure type. It has no budget key, so it is reported separately rather than dropped.
- Sources: `PROD.DCT_AP_PROCASH_BUTIL_V` and `DCT_AP_PROCASH_UNMAPPED_V` (`AP/db/13`), both
  honouring `GL_CTX.BUTIL_END` exactly as the view's own fact CTEs do.
- **`DCT_BUDGET_UTILIZATION_V` was deliberately NOT changed** — it feeds the books, registers,
  encumbrances and pending pages, so the join lives in the handler and the blast radius is one
  endpoint. The reports still quote the published Fund Available; extending them is a separate,
  explicit change.
- **GL post-05 re-run list is now 07..21.** `21` is DEFINE_HANDLER-only and needs `AP/db/13`.
- Tests: `GL/tests/butil_procash_api.py` (13/13) and `butil_procash_browser.py` (11/11).


## Projects-cashflow template pre-filled with every budget line — 2026-08-19 (v1.71.0, GL/db/23)

User request: the Cashflow page's **Download template** for Projects cashflow shipped ONE sample
row, so an end user had to hand-build every project / task / expenditure-type line. The template
now carries **all of them, with their full GL code combinations**.

- **`GL/db/23_gl_cashflow_template_ords.sql`** (ADDITIVE, `GET /gl/cashflow/projects/template`):
  `meta=Y` -> `years[]` only (feeds the picker, ~1s); otherwise every line of the year from
  `DCT_BUDGET_UTILIZATION_V` (project / task / expenditure type + `BUDGET_COMBINATION`, the full
  10-segment canonical combination, + sector / department / cost centre / GL account /
  appropriation / chapter / program / BU / project type / annual budget) with the cashflow amounts
  ALREADY saved for that year pivoted to `a01..a12` (APPROVED) and `r01..r12` (REVISED). Cashflow
  keys with no budget line are still emitted (`inBudget='N'`) so an existing plan row can never
  vanish from the sheet. Gate = `GL_MANAGE_CASHFLOW` (legacy SYS_ADMIN) — the same gate as the
  upload it serves. Cap 20,000 rows. **Live: 1,739 lines for 2026 in ~2.5s.**
  **GL post-05 re-run list is now 07..23.**
- **Frontend (v1.71.0)**: a **Budget Year** picker next to the button (years from the same route)
  and a WIDE workbook — `PROJECT · PROJECT_NAME · TASK · EXPENDITURE_TYPE · CF_TYPE`, then one
  column per accounting period (`01-YYYY`..`12-YYYY`), then the reference columns
  (`GL_COMBINATION`, SECTOR … ANNUAL_BUDGET) plus a **How to use** sheet. One APPROVED row per
  line, a REVISED row only where revised amounts exist. Filename `Projects_Cashflow_Template_<year>.xlsx`.
- **The upload reads BOTH shapes** — the classic long sheet (PERIOD + AMOUNT) and the wide
  template (`cfWideCols()` recognises `01-2026` / `Jan-2026` headers). **Blank month cells are
  skipped**: uploading an untouched template posts NOTHING, and a typed `0` posts and clears a
  saved amount. Reference columns are ignored on upload. So the download is a round-trip editor.
- **KO gotcha (bit us here):** the year `<select>` is bound before the LOV arrives, and a select
  whose option list was empty at bind time BLANKS its value when the options land — the page
  showed the wrong year until `loadCfTplYears` re-asserted the value in a `setTimeout(0)`.
- Test: `GL/tests/cf_template_browser_smoke.py` — **30/30** EN + AR/RTL (picker, workbook layout,
  1,739 lines all with a canonical combination, round-trip upload of ONE typed cell -> "1 rows
  saved, 0 errors", server-side verification, re-download pre-fill). Run it with
  `python3 'final apps/GL/Jet/dev-proxy.py' 8099`; it writes one real cashflow row as its fixture
  — delete it afterwards (`DELETE FROM prod.dct_project_cashflow WHERE cf_amount = 12345.67`).

## Sector Financial Performance report — data layer + API — 2026-08-19 (db/v2/123 + GL/db/24)

New GL report rebuilding the layout of `docs/Reports/GL/Sector Report_October.pdf`
(4 pages: Business Overview / Budget Overview / Budget Overview–Project Level /
Revenue Overview). Plan: `final apps/GL/SECTOR_PERF_REPORT_PLAN.md`.

**The key finding that shaped the build:** the source pack's own arithmetic already
matches the platform's — its page 3 reads
`4,989.6M budget − 3,009.0M actual − 1,344.4M encumbrance = 636.3M funds available`,
which is byte-for-byte `DCT_BUDGET_UTILIZATION_V.FUND_AVAILABLE`. So the report is
**butil + a Plan column + Revenue**, not a new actuals engine. `DCT_SECTOR_PERF_V`
is therefore built ON TOP of the butil view and never re-derives a fact, which makes
the reconciliation hold *by construction* rather than by testing.

### db/v2/123_gl_sector_perf.sql (deployed, 0 errors)
- `DCT_GL_REVENUE_CATEGORY` — the pack's 28 revenue types (S- sovereign / C-
  commercial) seeded EN+AR + `UNCATEGORISED`
- `DCT_GL_REVENUE_CAT_MAP` — natural account → revenue category
- `DCT_GL_REVENUE_PLAN` — monthly revenue plan (year × period × cost centre ×
  account × plan type)
- `DCT_GL_REVENUE_FACT_V` — revenue ACTUAL from `ATD_AR_INVOICE_DISTRIBUTION`
  (`accounting_class='Revenue'`), sector via cost centre, category via the map
- `DCT_SECTOR_PLAN_V` — expenditure plan aggregated at the butil grain,
  BUTIL_END-aware; `DCT_SECTOR_PLAN_ORPHAN_V` surfaces plan rows with no budget line
- `DCT_SECTOR_PERF_V` — the report fact (butil + plan + expenditure kind)
- `DCT_SECTOR_ACTUAL_MONTH_V` — AP+GRN actual by month, line grain, no period cut
- `DCT_GL_PLAN_SAMPLE_PKG` — generates and purges demonstration plan data
- setting `FEATURE_PLAN_SAMPLE_DATA` (ships **N**), 3 new privileges

### GL/db/24_gl_sector_perf_ords.sql (ADDITIVE — 8 handlers)
`sectorperf/filters` · `sectorperf` (overview) · `sectorperf/sectors` (`level=project`
expands) · `sectorperf/departments` · `sectorperf/trend` · `sectorperf/revenue` ·
`sectorperf/sample` GET+DELETE. **GL post-05 re-run list is now 07..24.**

Parameters: `year` (REQUIRED) · `period` MM-YYYY (YTD, drives `GL_CTX.BUTIL_END`) ·
`sector` and `costcenter` (Department) as pipe-delimited any-of MULTI-SELECT ·
`kind` (defaults to `Opex|Capex`, the pack's own footnote) · `projecttype` · `bu` ·
`plantype` APPROVED|REVISED.

### Sample plan data — three independent removal locks
Finance has no monthly plan loaded, so the report is demonstrated on generated data:
```sql
EXEC prod.dct_gl_plan_sample_pkg.generate_all(2026);   -- 20,868 exp + 288 rev + 54 map rows, ~5s
EXEC prod.dct_gl_plan_sample_pkg.purge(2026);          -- removes every trace
```
1. **Tagging** — every row is `loaded_by='SAMPLE'`, `source_file='SAMPLE:<batch>'`;
   `purge` deletes strictly on `loaded_by='SAMPLE'`, so a row Finance uploaded (real
   filename, real username) is *unreachable* by the purge.
2. **Refusal** — `generate_*` raises −20001 if the year holds any non-SAMPLE row, so
   the generator locks itself out the moment the real plan is uploaded.
3. **Visibility** — `is_sample_active()` drives the page banner / report watermark;
   `DELETE /gl/sectorperf/sample` purges from the UI (GL_MANAGE_PLAN_SAMPLE).

Figures are deterministic (hashed line key, never random) so a re-run reproduces
identical numbers. The curves are reverse-engineered from the pack: cumulative plan
at October is **69.2% Opex / 46.4% Capex / 65.3% Revenue**, and the live run
reproduces 69.2 / 46.4 exactly.

### ⚠ GOTCHAS FOUND THIS ROUND
- **`SHARE` is a reserved word** in 23ai — a column alias `share` fails with
  PLS-00103. Renamed `pct_share`.
- **`TO_DATE`'s `DEFAULT … ON CONVERSION ERROR` belongs to the EXPRESSION, before
  the format mask** — `TO_DATE(x, 'fmt' DEFAULT NULL ON CONVERSION ERROR)` is
  ORA-00907; `TO_DATE(x DEFAULT NULL ON CONVERSION ERROR, 'fmt')` is correct.
- **`ORA_HASH` is SQL-only** (PLS-00201 in PL/SQL). Use
  `DBMS_UTILITY.get_hash_value` for a PL/SQL-callable deterministic hash.
- **PL/SQL declaration order** — variables must precede nested subprograms in a
  `DECLARE` block, or PLS-00103 on the first variable after a procedure.
- **`OR … IN (SELECT … FROM atd_ar_invoice_distribution)` took >10 minutes** and
  had to be killed — the same FILTER-per-row shape that bit the AP facet engine.
  Rebuilt as `WITH … /*+ MATERIALIZE */` + hash join: **10 min → 5 s**.
- **A late-month trend assertion can pass trivially.** The extract stops in August,
  so "December cumulative == full-year actual" proved nothing; the smoke test now
  asserts months 4/6/8 where the cut-off genuinely bites.

### Known limitation (documented, not papered over)
`sectorperf/trend` returns the FY budget as a **flat** line (`budgetBasis:
"annual-flat"`). The platform holds no budget-version history, so the source pack's
gently-rising budget line cannot be reproduced without inventing it. It becomes real
when the published-month snapshot (plan enhancement 2) lands.

### Verified
- `db/v2/123t_gl_sector_perf_tests.sql` — **29/29** (reconciliation full-year and
  period-cut, plan arithmetic, monthly-actual identity, sample locks incl. a planted
  "real" row the generator must refuse and the purge must not touch)
- `final apps/GL/tests/sectorperf_api_smoke.py` — **70/70** (incl. RECON against
  `/gl/butil` unfiltered / period-cut / sector-filtered, all four 400 cases, 401)
- Deploy finished at the same INVALID count it started with. `PROD.AR_TAX_CALC` and
  `AR_TAX_CALC_LINE` are INVALID with syntax errors in their own source — pre-existing
  and unrelated to this change.

### Frontend — Sector Performance page (v1.72.0, same round)
New tab **Projects › Sector Performance** (`#pg-sectorperf`), five regions mirroring the source
pack: Search criteria → Business Overview (the 4×5 matrix + revenue-to-opex + cumulative
Budget-vs-Actual columns) → Budget Overview (6 KPI tiles + Opex/Capex gauges + department bars) →
Project Level (sector table with RAG dots, expand-to-project, reconciling total row) → Revenue
Overview (Sovereign/Commercial/Total cards + MTD strip + category bars) → Data quality.
EN + AR/RTL. Every visual is hand-built SVG/CSS — this app has no chart library.

- **Sector and Department (Cost Centre) are MULTI-SELECT chips** as specified; expenditure kind
  defaults to `Opex|Capex` (the pack's own footnote) and is shown as chips too, so the default
  scope is explicit rather than silent.
- **The page opens on the CURRENT accounting period**, not full year. On "full year" YTD Plan
  equals FY Plan, so the pack's *Target [YTD Plan / FY Plan]* column reads a useless flat 100%
  on every row. Same rule the Budget Utilization page already uses.

#### ⚠ FRONTEND GOTCHAS FOUND THIS ROUND
- **`APEX_JSON` omits a NULL key**, so `text: achievementPct` threw
  `achievementPct is not defined` and blanked the whole page — the binding error surfaced as
  `spError`, not a console error. Every nullable numeric is bound as `$data.field`.
  (Known platform rule; it bit again here because the omitted keys were *percentages*, which are
  null exactly when a denominator is zero.)
- **`html[dir=rtl] .bar-fill` (0,1,1) out-specifies a single-class colour rule (0,1,0)**, so the
  department and revenue bars silently reverted to the brand gradient in Arabic while looking
  correct in English. Chart colours here use three-class selectors
  (`.sp-dept .bar-track .sp-f--act`) which win in both directions. The browser smoke now
  measures the computed colour before and after the RTL flip so this cannot regress.
- A **full-page Playwright screenshot washes out everything below the fold** when the page
  contains a `backdrop-filter` element (the busy overlay). The content is fine — verify with
  per-region `locator.screenshot()`, not `full_page=True`.
- `.pnav` matches two elements (group row + sub-tab row) — target `.pnav--sub`.

#### Verified
- `final apps/GL/tests/sectorperf_browser_smoke.py` — **47/47** EN + AR/RTL (all five regions,
  criteria multi-selects, expand-to-project, sample banner, period cut, RTL colour guard)
- Live calibration at the default period: Target [YTD Plan / FY Plan] = 53.0% Opex / 30.2% Capex
  / 45.6% combined at August; a full-year run reproduces the pack's own 69.2% / 46.4% at October.
- APP_VERSION 1.71.0 → **1.72.0**

#### Webtier deploy — 2026-08-19
Release **20260819233525** (`SSH_USER=opc ./webtier/deploy_frontend.sh 129.151.159.189`);
previous release `20260819164147` is the rollback target. GL 1.71.0 → **1.72.0**; all 14 other
apps verified byte-identical to the repo after the deploy (the tarball ships every `<App>/Jet/`,
but only `GL/Jet` differed from the live release). Browser smoke re-run **against the deployed
build**: 47/47.
Gotchas: the VM does **not** accept `root` — the deploy needs `SSH_USER=opc` (as webtier/README
says); and `deploy_frontend.sh` was not executable in a fresh clone (`chmod +x` first).

#### v1.72.1 — region headers + department labels (2026-08-19, user feedback)
Release **20260819234642** (rollback target `20260819233525`).
- The four in-region chart headers (cumulative Budget vs Actual · Actual vs Budget & Plan by
  Department · MTD Trend · Actual vs Plan by Type) are now **filled bands with an icon**
  (`.sp-hd` / `.sp-hd-ic` / `.sp-hd-t`, + `.sp-hd-chip` for the live department count).
  Colours come from `--region-hd-bg` / `--region-hd-accent` / `--region-hd-fg`, never a
  hard-coded hex, so they follow Admin → Region Appearance like every other region header.
- Department labels show the **full name plus the cost-centre code beneath** (`.sp-dname` /
  `.sp-dcc`); the label column wraps instead of ellipsing.
- **Layout bug fixed in the same pass:** `.sp-dept` / `.sp-cats` rows have FOUR children
  (label · bar · value · %) but inherited the base 3-column `.bar-row` grid, so the % was being
  pushed onto an implicit second row under every bar. Both now declare their own 4-column grid.
  The browser smoke asserts all four cells share one grid row, that the label is not truncated,
  that the cost-centre code is present, and that nothing overflows the card.
- Smoke 47 → **54/54**, re-run against the deployed build.

⚠ Screenshot note: `locator.screenshot()` on this page washes out unless the (display:none but
`backdrop-filter`-bearing) `.bu-load-ov` is removed first — the content was never actually
clipped, it just looked it. **Measure geometry with `getBoundingClientRect` / `scrollWidth`
before believing a screenshot here.**

#### v1.73.0 — Chart of Accounts page = 4 sub-tabs (2026-08-21, user request)
Release **20260821100238** (rollback target `20260819234642`). Frontend-only — no DB/ORDS change.
- The Settings › Chart of Accounts page's four collapsible `.bu-sec` regions became **four
  sub-tabs** in the user-annotated order: **1 Classification values · 2 Manage CoA Mapping ·
  3 Combinations explorer · 4 Classification overview** (overview moved from first to last;
  default tab = Classification values).
- New `.coa-tabs` strip in `css/app.css` (pnav-style underline tabs, RTL-safe via flex);
  `coaTab('cls'|'map'|'exp'|'ov')` in app.js replaces `coaOvOpen`/`coaClsOpen`/`coaMapOpen`/
  `coaExpOpen` + `toggleCoa` (all removed). Region header bands kept (static, `bu-res-h`
  cursor) — the explorer header still carries the range summary, Export CSV and the ⤢ maximize
  toggle; `toggleCoaMax` now forces `coaTab('exp')` and Esc still restores. `loadCoa()`
  one-shot data load unchanged.
- Smoke `tests/coa_tabs_browser_smoke.py` **25/25** EN+AR (tab order, default tab, per-tab
  region isolation, explorer max/Esc, overview KPIs, AR labels + RTL switch, no page errors) —
  run against dev-proxy 8098; deployed build verified serving 1.73.0 + the coa-tabs markup.

#### v1.84.0 — Generate and Send: scoped butil report emails to To/Cc/Bcc lists (2026-08-24)
DB `reporting/db/39_rpt_distribution.sql` (deploy FIRST) + `GL/db/27_gl_report_dist_ords.sql`
(**GL post-05 re-run list is now 07..27**) + runner change fleet-synced (vm180-182 rpt-worker
restarted) + shared `<tree-select>` component (`shared/js/components/treeSelect.js` + `.tv-*`
in platform.css → **APP_VERSION bumped in ALL 16 apps**).
- **Feature**: butil page-head **Generate and Send ▾** (Sector / Department / Project level) →
  `.dw-gs` drawer: shared `<tree-select>` (oj-tree-view look — tri-state checkboxes, filter,
  CSS-drawn folder/doc icons — emoji glyphs are tofu on some hosts) → Add → selected list →
  formats (PDF book / XLSX register) → **recipient confirmation** (To/Cc lists verbatim, Bcc as
  a count, amber TEST-MODE + email-off banners, no-list warnings) → batch send → live progress
  (5s poll of `/butil/dist/batch/:bid`). One scoped run + ONE email per node × format; project
  nodes inherit their cost centre's recipient list and scope `costcenter+project`.
- **Recipient lists**: `DCT_RPT_DIST` (+`_RECIP` To/Cc/Bcc, `_BATCH`) dist_group `GL_BUTIL`,
  UNIQUE (group, scope_type, scope_value); managed in **GL → Settings → Report Recipients**
  (register + drawer + **Import from Excel**: SheetJS, auto-detects the Departments/Sectors
  sheets of `docs/Approval/Sectors  Departments Email list for 2026-FPB and PBP.xlsx`, email
  columns by @-density, defaults PBP/FBP→To + AP/Director/Key-Users→Cc, Active-only filter —
  51 dept + 7 sector rows parse; ≤500-row chunked upsert that REPLACES matched rows'
  recipients). Delete is blocked (409) once email history references the list — disable instead.
- **Email path** (`reporting/runner/deliver.py`): run with `dist_id` = ONE message — To + Cc
  headers, **Bcc envelope-only**; subject = dist `subject_tpl` else the scope-aware default
  `DCT i-Finance | report | scope | period`; rendered subject stamped on `dct_rpt_run.email_subject`;
  per-address `dct_rpt_delivery` rows carry the new `disposition` col. Legacy (non-dist) runs
  keep the old per-recipient loop untouched.
- **TEST MODE (user rule: never email real recipients while testing)**: `EMAIL_TEST_MODE`
  ships **Y** + `EMAIL_TEST_TO` empty (BI Settings edits both) → mail goes ONLY to the test
  mailbox with a `[TEST]` prefix, run stamped `is_test='Y'`, intended recipients logged
  SKIPPED; test mode + no test address = delivery skipped entirely. Sending to REAL
  recipients requires deliberately flipping EMAIL_TEST_MODE=N (EMAIL_ENABLED is already Y).
- **Email Logs page** (Projects › Email Logs): filters (dates, level, sector/CC/project,
  recipient-contains, run + email status, test Y/N, report, batch) → run-grain register
  (subject, TEST badge, sent/failed/skipped counts) → drill drawer (per-address dispositions +
  outcomes, attachments re-download via the existing book/xlsx file routes, criteria echo).
- **Gotchas found**: `TO_DATE/TO_NUMBER … DEFAULT NULL ON CONVERSION ERROR` inside a PL/SQL
  handler = ORA-43907/ORA-03066 → uncatchable 555 (use REGEXP-guarded CASE conversions);
  never build TWO APEX_JSON outputs interleaved (send handler params now come from SQL
  JSON_OBJECT); tree LEFT-JOIN + EXISTS must sit in an inline view (ORA-01799); the `rc*` VM
  prefix belongs to the Reconciliation page — recipients page uses `rl*`.
- Tests: `tests/gs_dist_api_smoke.py` **44/44** · `tests/gs_browser_smoke.py` **23/23 EN+AR**
  · `tests/gs_import_parse_smoke.py` **14/14** (real workbook, parse-only).
- Deployed: reporting/db/39 + GL/db/27 via Linux SQLcl (both verified; emails handler needed the
  ORA-43907 fix + redeploy), runner fleet-sync + rpt-worker restart ×3, webtier release
  **20260824160432** (GL-only overlay: GL/Jet + shared/css/platform.css + shared/js/components/
  treeSelect.js; rollback target 20260823183954) — deployed-build smoke 23/23.
- Residue: dist row #1 (first tree sector, DISABLED, @example.invalid addresses) survives the
  smoke because runs 701-703 reference it — the REAL Excel import upserts/heals it. Run 701 was
  processed by the pre-sync runner and emailed the requesting admin's own mailbox (legacy SELF
  path, pre-existing behavior); 702+ took the guarded dist path (all SKIPPED, nothing sent).

#### v1.85.0 — negative-Fund-Available drill drawer + Generate-and-Send arrow (2026-08-24, user feedback on a screenshot)
DB `GL/db/28_butil_negfund_drill.sql` (**GL post-05 re-run list is now 07..28**; ADDITIVE,
DEFINE_HANDLER-only, starts from `21_butil_procash.sql`'s body — needs 21 deployed first).
- **Feature 1**: the "Over budget — negative Fund Available" warning band above the Overview
  region on Project Budget Utilization is now clickable (CTA "View lines") and opens the shared
  `.dw-*` drill drawer listing exactly the offending lines — same pattern as the existing
  missing-Cost-Centre band (`nocc=Y`). New GET `/gl/butil?negfund=Y` param restricts BOTH the
  aggregate totals and the items cursor to lines whose EFFECTIVE Fund Available (same expression
  already used to compute the band's own `negFund`/`negFundTotal`, honouring the page's own
  `procash=`/`costadj=` toggles) is negative — the drawer can never disagree with the band's own
  count/total. Columns: Project/Project Name/Task/Expenditure Type/Department/YTD Budget/Actual
  AP/Actual GRN/Commitment (PR)/Obligation (PO)/Fund Available; footer total = `negFundTotal`.
  CSS: dropped the `.bu-alert--negfund{cursor:default}` + hover-transform:none overrides so the
  band inherits the base `.bu-alert` clickable styling (same as `.bu-alert` used for missing-CC).
  New i18n: `buNegCta`/`buNegDrill` (reused `cCommitPr`/`cObligPo`/`cBudgetYtd`/`cActualAp`/
  `cActualGrn`/`cFundAvail`/`buMissCcPName` — no other new keys needed).
- **Feature 2**: "Generate and Send" button now carries the same dropdown arrow as "Generate
  Report" (`gsBtn` i18n string gained the trailing ` ▾`, matching `genReport`'s existing pattern
  — the arrow is baked into the label text, not a CSS pseudo-element).
- Frontend-only for feature 2; feature 1 is DB (new opt-in query param, zero behavior change for
  existing callers) + frontend (band click binding, `openBuNegFund()`, CSS cleanup).
- Verified live against the deployed handler: default scope's Project Type filter (DCT OPEX
  Project Type) currently has ZERO negative lines; clearing it surfaces 6 (all DCT Trust Project
  Type, total -51,504,086) — drawer reconciles exactly to the band (row count, total, every row
  genuinely negative). New smoke `tests/negfund_drill_browser_smoke.py` **15/15 EN+AR** (dev-proxy
  8097); pre-existing `tests/negfund_browser_smoke.py` has 2 unrelated stale failures (results-
  table column count drifted from 19→20 since v1.74.0 with later Comments-column additions;
  default-scope negFund=0 is current live data, not a regression — neither touched by this change).
- Deployed: `GL/db/28_butil_negfund_drill.sql` via `sql -name prod_mcp` (fresh session, ADMIN),
  verified `NEGFUND DRILL WIRED`. `APP_VERSION` bumped to **1.85.0** in `GL/Jet/index.html` only
  (no `final apps/shared/` change this round — no fleet-wide bump needed). Frontend shipped as
  webtier release **20260825082023** (GL-only overlay: copy of the prior live release
  20260824160432 + overlay of `GL/Jet/` only, so parallel sessions' in-progress work elsewhere
  in the tree was NOT shipped; old releases beyond the last 5 pruned). Deployed-build smoke
  (`negfund_drill_browser_smoke.py` pointed at `https://129.151.159.189/`) **15/15 EN+AR**.

#### v1.86.0 — cost adjustments now appear in the butil drill drawers (2026-08-26)
User report: a line's Actual figure carried an approved Projects Costing Adjustment (costadj=Y
default) but the drill drawer showed only the real AP rows — sample project 4511000981 /
PCA-00018 was the WHOLE Actual (raw AP = 0.00), so the drawer was literally empty against a
2,368,623 cell. NEW ADDITIVE `GL/db/29_gl_costadj_drill_ords.sql` = `GET /gl/butil/lines/costadj`
(**GL post-05 re-run list is now 07..29**): the APPROVED adjustment rows for the drill's exact
scope — row mode + aggregate mode (kys CTE over the butil key cache incl. the SECTOR data scope,
copied verbatim from butil/lines so both requests always cover the same key set); metric `ap`
(amount_aed, drill-shaped: PCA ref in the doc column, Validation = 'Cost Adjustment',
classification + reason + Ref-invoice in Description) and `budget`/`budgetannual`
(budget_override rows; annual ignores the period window). YTD rule mirrors
DCT_PA_COST_ADJ_BUTIL_V exactly: NULL accounting period always counts, MM-YYYY counts on/before
the end month. Frontend: `openBuDrill`/`openBuAgg` fetch base + adjustments IN PARALLEL and
merge rows + total — gated on the SAME `buCadjOn()` response echo that stars the rows (and
`row.hasAdj` for row drills), so unchecking "Include Cost Adjustment" keeps the drill raw and
the drawer NEVER disagrees with the cell. Deliberately untouched: /butil/lines itself (36KB
handler), books/registers, the Project-360 funnel drills (portfolio figures don't include
adjustments). Deployed 29 via Linux SQLcl + webtier release **20260826152712** (GL-only
overlay; rollback 20260825082023). Tests: `tests/costadj_drill_api_smoke.py` **18/18** (incl.
the 03-2026/04-2026 period-boundary rule + aggregate mode) + `tests/costadj_drill_browser_smoke.py`
**10/10** re-run against the deployed build. Test gotcha: wait on `buLoading()` +
`buItems().length` — the `buBusy()` overlay flag races the re-run.

#### v1.85.0 negfund drill REGRESSED then FIXED — GL/db/31 supersedes GL/db/28 (2026-08-26)

**Symptom** (user report): clicking "View lines" on the over-budget band showed EVERY budget
line, not just the negative-Fund-Available ones. **Root cause — a race between two additive
layers on the SAME handler**: `GL/db/28` (2026-08-24) added `negfund=Y` on top of `21_butil_
procash.sql`'s body as it stood THEN. Separately, `21_butil_procash.sql` was edited IN PLACE
(354→401 lines) to add the 2026-08-26 plan-balance fields (`planApprovedAnnual/Ytd`, etc. —
db/v2/126) and re-run — which silently dropped 28's `negfund` filter, since 28 was a standalone
layer 21's edit never incorporated. The client had always sent `negfund=Y` correctly; the server
just had no `l_negf` variable anymore to bind it to, so the param was ignored and every row
came back. Confirmed live: `SELECT ... INSTR(h.source,'l_negf')` on the deployed handler = 0.

**Fix**: `GL/db/31_butil_negfund_drill_v2.sql` — rebuilds the SAME `negfund=Y` filter on top of
21's CURRENT (401-line, plan-balance-including) body, so nothing else regresses. `28` stays in
the repo as a historical record; **31 is the live owner of `/gl/butil` going forward.** **GL
post-05 re-run list is now 07..31** (30 unaffected — it owns the sibling `/butil/lines/plan`
route only). **LESSON for the next edit to this handler**: extend the CURRENT body of 21 (or
whichever file is the actual live owner per the deployed-handler length/verification query),
never a copy taken at some earlier point — this handler has been redefined ~9 times now
(07→11→12→13→15→21→28→31…) precisely because it accreted one param at a time; the failure mode
is always "additive layer X was built from a body that predates additive layer Y."

Verified live (production, not just dev-proxy): `tests/negfund_drill_browser_smoke.py` pointed
at `https://129.151.159.189/` **15/15 EN+AR** — drawer row count (8) and total (-51,562,679.85)
reconcile exactly to the band's own `negFund`/`negFundTotal`, every returned row genuinely
negative. Deployed via `sql -name prod_mcp` (handler verified `NEGFUND WIRED` + `PLAN WIRED` +
`COSTADJ WIRED` together) — no frontend change needed (the client-side code was already correct).

## vs Budget verdict columns + Manage Columns drawer — 2026-08-31 (v1.96.0, NEW GL/db/35 + 33/11 re-runs + reporting/db/25 + runner)

User request (both parts, decisions via Q&A): ① mirror the vs-Plan columns with an
**Actual vs Budget** verdict — basis = the ADJUSTED **ANNUAL** budget ("Annual Budget
always", never the YTD slice), 3-state configurable bands; ② a **Manage Columns**
button on the butil Results region — drawer with checkbox show/hide + arrow reorder +
IR-style **named views** saved per user, and the active view also drives the report.

**DB / server**
- **`GL/db/35_butil_vs_budget.sql` — THE NEW LIVE OWNER of `GET /gl/butil`**
  (supersedes 32→31→28→21; body = 32's deployed body verified by INSTR preflight).
  **The define is now assembled from CLOB pieces** (`l_src := q'!..!'; l_src := l_src
  || q'!..!';`) — the 32-file size warning came due: the body is 32,455 chars, PAST
  the 32,767 single-literal cliff edge. Future edits extend a piece / add one.
  Adds per row: `budUtilPct` (100 × displayed Total Actual ÷ adjusted annual budget),
  `budVariance` (signed), `budState` OK / NEAR / OVER / NOBUDGET (spend on a
  zero-budget line = OVER). Thresholds = GL module settings **`BUD_UTIL_NEAR_PCT`
  (90) / `BUD_UTIL_OVER_PCT` (100)** (seeded, Admin-editable) echoed per response as
  `budgetThresholds {near, over}`. GL post-05 re-run list = **07..35**.
- **`GL/db/33` re-run (edited in place)** — the Department/Sector agg groups carry the
  same `budUtilPct`/`budVariance`/`budState` + thresholds echo (group Actual vs group
  adjusted annual budget).
- **`GL/db/11` re-run** — `POST /gl/butil/xlsx` forwards body `sheetcols` (REGEXP
  `^[a-z0-9_,]+$` guarded) into run params as `sheet_cols_bu_lines`.
- **`reporting/db/25`** (python-oracledb on vm180) — register sheet 1 gains
  `budget_utilization_pct` / `budget_variance` / `budget_status` right after
  `ytd_budget` (glyphs via `TO_CHAR(NCHR())`: ● On track / ▲ Near limit / ▼ Over
  budget / Not budgeted); the `th` CROSS JOIN reads the two new settings (`WHERE`
  widened to `LIKE 'PLAN%' OR LIKE 'BUD_UTIL%'`).
- **`reporting/runner/runner.py`** — NEW generic `_apply_sheet_cols(sections, params)`
  applied in the XLSX path only: a run param `sheet_cols_<sectionkey>` (CSV of column
  names) keeps ONLY those columns in that order on the matching sheet — matching is
  case-insensitive and `__pn`-suffix transparent, `row_kind` always survives, a spec
  matching nothing leaves the sheet as-is. Fleet-synced vm180-182 + rpt-worker
  restarts.

**Frontend (v1.96.0)**
- Both butil results tables are **COLUMN-REGISTRY driven**: `BU_LINE_COLS` (32 cols) /
  `BU_AGG_COLS` (22) in app.js hold key + label/hint i18n keys + th css + cell
  template id + optional feature gate (plan LOV, revised-pair, comments, dept level)
  + CSV expansion + register sheet-1 column mapping. Headers and rows render via
  `foreach: buColsLine/buColsAgg` + per-cell KO templates (`buc-*`/`bua-*` script
  templates at the end of index.html — inside a template `$data` = the row and
  `$root` = the VM, so the cell markup moved over verbatim). `skCols` is now a
  computed sized to the active registry.
- **vs Budget column** (always on, independent of the Show Plan LOV) after YTD Budget
  on all three tabs: hand + % (`.vp` classes reused — OK→ok/green, NEAR→low/amber,
  OVER→high/red), tooltip = verdict + Δ vs annual budget, cell click = the
  budgetannual drill. `buBudThr` binds the response echo so page colors always match
  the server classification.
- **Manage Columns drawer** (`.dw-cols`, Results-header button beside maximize):
  checkbox show/hide + ↑↓ reorder + Select/Clear all; **named views** per level
  (line / dept / sector) with Save / Set-as-default / Delete / Reset-to-standard;
  gated columns show a "needs its feature on" chip. Persistence =
  `/dct/prefs` key **`gl.butil.colviews`** (roams with the account; server pref wins)
  + `localStorage('gl_bu_colviews')` instant-boot mirror. New registry columns added
  after a view was saved slot in at their registry position (shared-IR reconcile
  rule). Esc closes the drawer before restoring a maximized table.
- The active line view drives **CSV** (per-col expansions + fixed audit tail) and the
  **Excel Register sheet 1** (`buSheetCols()` → `sheetcols`, led by
  budget_combination; null while the standard layout is untouched so default runs
  keep the full 41-column sheet).

**Tests** — `tests/vsbudget_cols_api_smoke.py` **13/13** (per-row/agg recompute parity
under procash/costadj/period toggles, thresholds echo, register sheetcols E2E: the
produced workbook's sheet 1 = EXACTLY the requested ordered columns via openpyxl, and
a no-sheetcols run keeps all 41 incl. the three new budget columns after Ytd Budget);
`tests/cols_vsbudget_browser_smoke.py` **27/27 EN+AR** (position, verdict cells,
Show-Plan independence, drawer flows, per-level views, reload persistence via server
prefs, reset, RTL) — ALSO PASSED against the deployed webtier build. Regressions:
plan_insights_api 20/20 · plan_insights_browser 25/25 (its "NO hides plan columns"
assertion updated — vs Budget is a `.pi-th` that legitimately stays) ·
fm_browser 40/40 · butil_tabs_browser 54/54.

**Webtier** release 20260830203454 (GL-only overlay of index.html/app.js/app.css,
rollback = re-point `current` to 20260830194340).

**Gotchas learned**
- KO `css:` binding accepts a plain string of class names — the registry's `cls`
  rides it directly.
- Inside `<!-- ko template: {name: tpl, data: $parent} -->` under a
  `foreach: cols` nested in `foreach: rows`, the template context gets `$data` = the
  ROW and `$root` = the VM — existing cell markup ports verbatim; only `$parent`
  references would break (none did).
- A hidden sibling page's table also matches `.bu-results thead` — scope test
  selectors as `#pg-butil .bu-results table:not(.bu-agg-tbl)`.
- On the webtier the app lives at `/GL/Jet/` — browser smokes take
  `GL_BASE=https://129.151.159.189/GL/Jet` (the dev-proxy serves it at `/`).

## Register column trims + Fund Movement Approved-only — 2026-08-31 (v1.96.1, reporting/db/25 re-deploy + frontend)

User feedback round on the Budget Utilization Register + page, three removals:

- **Register sheet 1 (reporting/db/25)**: `cost_adjustment` + `budget_override_adj`
  columns REMOVED (sheet is now 39 columns; the adjustments still fold into the
  figures and the (**) rows on sheet 2 keep their `cost_adjustment_ref`). The
  frontend `fundAvailable` registry row's `xls` mapping dropped the two names.
- **Register sheet 8 "Fund Movement"**: rows filtered to **Approval State =
  'Approved'** only (drops Rejected/Withdraw and transactions with no approval
  trail; live 2026: 4,557 rows, all Approved). Filter = `apr.approval_state`
  in the l_bt outer WHERE.
- **Page Fund Movement Count/Amount columns REMOVED from all three tabs**
  (v1.94.0 feature, user removal): the 4 registry rows (`fmCnt`/`fmAmt` in
  BU_LINE_COLS + BU_AGG_COLS) and the two `runBuFm` call sites deleted — so
  the columns leave the tables, CSVs and the Manage Columns chooser, and no
  `/butil/fundmove` request fires. The fm machinery/templates/popover markup
  stay as DORMANT dead code (see the app.js comment block) and the GL/db/34
  routes stay live (`butil_fundmove_api_smoke.py` still valid);
  `fm_browser_smoke.py` is OBSOLETE by design. Saved Manage-Columns views
  containing the removed keys are silently reconciled (colReconcile filters
  to registry keys).

Deploys: db/25 via python-oracledb on vm180 (4 ok / 0 failed, src 28,096);
webtier GL-only overlay release **20260831070939** (prev 20260830203454).
NOTE: `tar --unlink-first` into a `cp -al` release prints "Cannot unlink:
Directory not empty" for directories — harmless; files are replaced correctly
(verify APP_VERSION in the new release + a marker string, and that the OLD
release still carries its own bytes).

Verified live (scratchpad verify_removals.py 13/13 + verify_fm_approved.py):
sheet 1 = 39 cols without the two adj columns, Comments right after
Utilization Pct; sheet 8 all-Approved; page = no fm columns on any tab, no
fundmove requests, chooser/CSV clean, vs Budget still after YTD Budget; full
run register OK.

## Fund Movement restore + register sheet-1 columns, Approved-only everywhere — 2026-08-31 (v1.96.2, GL/db/34 re-run + reporting/db/25 re-deploy + frontend)

**Correction of the v1.96.1 fm removal — it was a MISREAD.** The user's "also,
fund management count and amount columns" meant: keep them on the dashboard
AND add them to the register's "1. Budget Utilization Lines" sheet. Restored
and extended:

- **Frontend (v1.96.2)**: the 4 fm registry rows + both `runBuFm` call sites
  are back (line rows now carry `xls: ['fund_movement_count']` /
  `['fund_movement_amount']` so Manage-Columns saved views drive the new
  register columns too); `fm_browser_smoke.py` header restored (40/40 again);
  column hints note the Approved-only basis EN+AR.
- **GL/db/34 re-run**: both fundmove handlers are now **Approved-only** —
  the line + group aggregates JOIN the latest `pa_budget_trx_approvals`
  `assignment_state = 'Approved'` per transaction, and the drill adds
  `apr.approval_state = 'Approved'` as a top-level conjunct — matching the
  sheet-8 rule so every cell still equals its drill row count.
- **reporting/db/25**: sheet 1 gains `fund_movement_count` +
  `fund_movement_amount__pn` (green/red) right after Utilization Pct — a
  RENAMED `fm` inline view (fp/ft/fe, the pf-join ORA-00918 rule) on the
  exact butil line key, Approved-only, `trx_year` = budget year, BUTIL_END
  transaction-date cut, zero-amount lines excluded. Sheet 1 = 41 columns
  again. **GOTCHA: `DCT_RPT_DEFINITION.description` is VARCHAR2(1000)** —
  the first deploy died ORA-12899 at 1,024 chars; trim the catalog blurbs.
- Sheet 8 itself keeps its zero-amount rows (21 live) — the counts exclude
  them, so a strict sheet-8-rows == count comparison must net those out.

Deploys: db/34 local SQLcl fresh session (8,932 + 11,152 chars published);
db/25 via vm180 python-oracledb (src 29,061); webtier release
**20260831083730** (prev 20260831070939). Verified: verify_fm_restore.py —
sheet-1 fm values == /butil/fundmove per key (1,726 movement rows, 0
mismatch), per-key sheet-8 parity net of zero rows (2,213 keys, 0 mismatch),
page columns/drill/chooser/sheetcols on all three tabs, plus
fm_browser_smoke.py 40/40 EN+AR.

## Task Name column — 2026-08-31 (v1.96.3, GL/db/35 + reporting/db/25 re-deploys + frontend)

- **Source**: the butil view has NO task-name column and DCT_TASKS names are
  empty (all NULL/=number) — the name comes from **ATD_TASKS.task_name,
  PROJECT-SCOPED via ATD_PROJECTS.project_id** (task numbers repeat across
  projects — the tsk_org rule; 1,740/1,740 2026 lines named). Both consumers
  use the same renamed inline-view aggregate (tp/tt, MAX(task_name)).
- **GL/db/35 re-run**: items cursor gains the `tnm` LEFT JOIN + per-row
  `taskName`; verification tail gains a TASKNAME marker. Handler is now
  **32,785 chars — past the 32,767 single-literal cap**, so the CLOB-pieces
  define is no longer optional.
- **reporting/db/25 re-deployed**: sheet 1 `task_name` right after
  `task_number` (42 columns; SRC_LEN 29,364).
- **Frontend (v1.96.3)**: BU_LINE_COLS row `taskName` after `task`
  (chooser/CSV/`xls: ['task_name']` all follow), template `buc-taskname`,
  i18n cTaskName/chTaskName EN+AR. Agg tabs unchanged (dept/sector grain has
  no task). Webtier release **20260831092023** (prev 20260831083730).
- Verified live (verify_taskname.py 14/14): 200/200 API rows named, sheet-1
  column present+populated right after Task Number, page column/chooser/CSV/
  sheetcols/AR, fm + verdict columns intact.
## Revenue Categories settings — 2026-08-31 (v1.97.0, GL/db/36 + frontend)

- Ownership moved from the AR design area to GL/FPB. The mockup now lives at
  `GL/docs/design-mockups/revenue-categories.html`; AR has no runtime artifact.
- New PROD tables: `GL_REVENUE_CATEGORY` (two-level Main → Sub hierarchy),
  `GL_REVENUE_CATEGORY_RULE` (eight FPB-style dimensions, `ALL` wildcard), and
  `GL_REVENUE_CATEGORY_ACCESS` (role/user grants, optional child inheritance).
- New additive `/gl/revenue-categories*` ORDS family: one aggregate read and
  category/rule/access create, update, and delete operations. Writes require
  `GL_MANAGE_REVENUE_CATEGORIES` with `SYS_ADMIN` legacy compatibility.
- GL Settings now includes bilingual **Revenue Categories**, with Categories,
  Define Mapping, and Access Control views using the existing GL theme.
- Deployed DB script 36: 3/3 tables, VALID hierarchy trigger, 8/8 handlers.
  Rollback-only model smoke created Main + Sub + Rule + inherited Role grant,
  then confirmed zero test rows remained. Webtier release `20260831232838`;
  live version/HTML/JS/CSS markers verified and unauthenticated API returns 401.

## Financial Performance Report — Budget Overview, Entity + Sector level — 2026-09-01 (v1.99.0, GL/db/37)

Replicates `docs/Reports/FMR/FMR_Dashboard.pdf` pages 2-3 (the DCT corporate
Power BI "Budget Overview" pages) as a new live GL nav tab, sourced from the
same data the **Budget vs Actual** page already reads
(`prod.dct_budget_actual_period_v`) plus the GL Cashflow plan table
(`prod.dct_gl_budget_cashflow` / `dct_gl_cashflow_v`). Scope per the user:
Entity + Sector level only (not Revenue/Payroll/Ageing, which live in other
modules).

- **Entity classification (new — not a GL dimension before this)**, confirmed
  against live `dct_gl_coa_v` with the user:
  `appropriation_code='301439'` (FA1439 art-collectibles fund) → **Masterpieces**
  (carved out first, since its 4 combinations sit under ES=4510000);
  `entity_specific_code` `4510700`/`4510600` → **Museums**/**ALC**; else → **DCT**.
  A real ~9.18bn AED slice of 08-2026 budget (679 combinations, ~AED 100K
  actual — essentially unspent) has no row yet in `dct_gl_coa_snap` — reported
  as its own **Unclassified** bucket rather than folded into DCT, so
  `entities[]` always sums exactly to `overall{}` (which never joins the snap
  table, so it is unaffected by snapshot coverage). Join key is **`cc_id`**,
  not `cc_string` — `cc_string` is unindexed on the period view and that join
  alone took several seconds; `cc_id` is instant and has full coverage parity.
  Type classification (Payroll/Opex/Capex/CWIP) reuses the existing
  `chapter_code` already on both views (CH1/CH2/CH3/CH6); CH4/CH5/STIMULUS
  fold into **Other**, NULL chapter_code is its own **Unclassified** trend
  bucket (same coverage gap, ~9.84bn budget, kept visible not dropped).
- **Plan data**: `dct_gl_budget_cashflow` already carries `entity_specific_code`
  + `appropriation_code` directly (no join needed) and `dct_gl_cashflow_v`
  adds `chapter_code`. Per the user, `docs/Reports/FMR/Payroll Plan 2026.xlsx`
  (300 rows: one cost centre `4510220` "DCT — People & Performance" × 25 GL
  accounts × 12 months, Chapter 1/Payroll, AED 1,150,000,000 total) was loaded
  2026-09-01 via a one-off Python-generated SQLcl INSERT script (plain
  `INSERT`, not `MERGE` — this ADB's Linux SQLcl silently drops MERGE-bearing
  blocks) into `dct_gl_budget_cashflow`, using the exact combination the user
  specified: `451.070103.<CostCenterCode>.1.<GLAccount>.4510000.100103.000.
  000000.000000`, `cf_type='APPROVED'`. Verified `SUM(cf_amount)` matches the
  workbook exactly. Opex/Capex/CWIP and every Sector besides Support Service
  have **no plan yet** — they ship `hasPlan='N'` (reported, never fabricated,
  same convention as the Budget Utilization page's `planUnmatched`). Because
  only Payroll has real plan data so far, the page's **overall** and **DCT**
  Actual-vs-Plan% reads inflated (~500%, comparing full actual to a
  Payroll-only plan) until Finance uploads Opex/Capex plans via the existing
  Cashflow page.
- **New additive `GL/db/37_gl_fmr_ords.sql`** (no new views — aggregation SQL
  embedded directly in the handlers, `33`/`34` pattern): `GET /gl/fmr/entity`,
  `GET /gl/fmr/sector`, `GET`/`PUT /gl/fmr/notes`. Reads = any valid session
  (matches `GET /gl/actuals`); notes write = `GL_MANAGE_DOF_NOTES` (reused,
  legacy `SYS_ADMIN`). New tiny table `dct_gl_fmr_note` (year+period+type,
  upsert, empty text deletes) backs the PDF's "Current Month Variances" /
  "Expected Variances" narrative panels. **The PDF's "Under/Over Spend
  Comments" buttons are NOT a new comment store** — the Sector table's
  Comments button opens the **existing** `SECTOR`-level thread from Budget
  Utilization Comments (`db/v2/125`, `GL/db/26`'s routes, `self.openCmt(...)`)
  keyed on the same sector code, so a note left from either page is the same
  thread. **GL post-05 re-run list is now 07..37.**
- **PL/SQL gotcha (caught live, matches CLAUDE.md's PLS-00231 note)**: a
  function declared *locally inside the handler's own DECLARE block* cannot
  be called from a SQL statement issued by that same block (`PLS-00231
  function ... may not be used in SQL`) — first draft used
  `ent_of()`/`type_of()` helper functions inside `WHERE`/`GROUP BY`, which
  compiled fine (ORDS doesn't validate handler bodies at
  `DEFINE_HANDLER` time) but 555'd on every call. Fixed by inlining the
  classification as a `CASE` expression directly in the SQL; only `pct()`
  (called from plain PL/SQL, never inside a query) stayed a local function.
- **Frontend** (`final apps/GL/Jet/`, APP_VERSION 1.99.0): new nav tab
  **Financial Performance** in the General Ledger group, right before Budget
  vs Actual. KPI band + 5 entity gauges reuse the Sector Performance report's
  existing `.bu-kpis`/`.sp-gauge`/`spGaugeDash()` pattern verbatim; the YTD
  trend chart reuses its `.sp-cols`/`.sp-b` CSS-height bars (Budget/Actual/Plan
  per type) instead of introducing Chart.js (this app draws every chart as
  hand-built SVG/CSS by convention). Two **KO LAWS caught live** while wiring
  the year/period pickers: (1) a `<select options:X, value:Y>` binding
  force-selects its FIRST option and writes it back the instant it
  initialises if `Y` is still `''` — same rule as `cfTplYear`/`buType` — so a
  `!self.fmrYear()`-style "only default if empty" guard can never catch it;
  fixed by always setting the real default in `loadFmr()` plus a
  `setTimeout(...,0)` re-assert. (2) The default **period** mirrors the
  Budget vs Actual page's own rule (`GET /actuals/filters` `defaultPeriod` —
  current calendar month if it has data, else the latest loaded period)
  rather than the browser's real "today", which was ahead of the last
  extract (Sep-2026 client clock vs data loaded only through Aug-2026) and
  produced an empty page. Sector "Comments" button inside a `foreach` needs
  `$root.t(...)`, not bare `t(...)` — bare calls only resolve at the
  page-level (non-`foreach`) binding context; missed once, caught by the
  browser smoke run (`fmrError` surfaced the exact KO binding exception).
  Verified: `fmr_browser_smoke.py` 10/10 EN+AR (5 gauges, KPI figures,
  6 trend columns, sector table + entity-filter narrowing, note save
  round-trip, Comments button opens the shared Budget-Utilization-Comments
  drawer, clean AR toggle with no console errors).

### FMR v2 correction — Budget Group=1 filter + Chapter 2/3 plan from project cashflow — 2026-09-01 (GL/db/37 re-run, no frontend change)

User caught two real bugs live after go-live:

- **Budget/Actual were not filtered to Budget Group = 1**, the platform-wide
  rule (Budget Group defaults to '1' everywhere; group 8 is 0 in this data so
  it wasn't the visible symptom, but groups 3/5 — Chapters 4/5,
  Subsidy/Aids&Grants, ~738M — were being summed in). Fixed with
  `REGEXP_SUBSTR(p.cc_string,'[^.]+',1,4) = '1'` (position 4 of the canonical
  `entity.program.cc.BG.account.es.appr.ic.f1.f2` string) on every
  Budget/Actual query. **Overall budget went from 18,670.8M to the correct
  17,932.4M** (08-2026).
- **Same regex trick replaces the `dct_gl_coa_snap` LEFT JOIN for entity
  classification** (position 6 = entity_specific_code, always present in
  `cc_string` — no coverage-gap dependency). This retires the v1
  "UNCLASSIFIED entity" bucket entirely (it was a join artifact, not a real
  gap — those ~9.18bn AED rows are legitimate BG=1 DCT budget with generic
  `appropriation='000000'`, just missing from the transaction-derived
  snapshot). `entities[]` is now DCT/ALC/Museums/Masterpieces only (4, was
  5) and sums exactly to `overall{}`. **The UNCLASSIFIED *type/trend* bucket
  stays** — that one is a real gap (appropriation `'000000'` genuinely has no
  chapter mapped).
- **Plan for Opex (Chapter 2) and Capex (Chapter 3) now reads the SAME
  already-populated project-grain plan the Budget Utilization page uses**
  (per the user: "chapter 2 and 3 plan should come from project cashflow
  details") — `prod.dct_budget_utilization_v` (its `BUDGET_COMBINATION`
  column carries the entity segment; `CHAPTER` is text `'Chapter 2'`/
  `'Chapter 3'`, a DIFFERENT vocabulary from the actuals view's `CH2`/`CH3`
  codes) JOINed to `prod.dct_project_cf_butil_v` (db/v2/126,
  `PLAN_APPR_ANNUAL`/`_YTD`). Payroll (Chapter 1) keeps reading the GL
  Cashflow upload as before; the two sources are summed per entity/sector/
  type. **YTD requires `prod.dct_gl_class_pkg.set_butil_end(<end of
  period>)` before querying `dct_project_cf_butil_v`, cleared on every exit
  path (including the exception handler)** — left unset, `PLAN_APPR_YTD`
  silently equals `PLAN_APPR_ANNUAL` (verified live: Chapter 2 YTD dropped
  from 4,015.7M annual to 2,368.0M once the context was set for 08-2026).
  Sector attribution for this leg joins `dct_gl_class_value`
  (`class_type_code='SECTOR'`) on `name_en = dct_budget_utilization_v.sector`
  (verified 0 unmatched names against live 2026 data). Result: overall
  Actual-vs-Plan% dropped from a nonsensical 521% to a sane **96.3%**
  (08-2026) now that Plan actually covers all three chapters instead of
  Payroll alone.
- No new privilege/table changes; no frontend file changed — the page reads
  the same response shape (just fewer/more-correct rows), so the fix took
  effect on next page load with no redeploy needed. Re-verified via
  `fmr_smoke.py` (direct ORDS calls): entity sum, trend sum and the sector
  register all reconcile to the corrected `overall.budget`.

### FMR v3 — Chapter 1/2/3-only scope + MSS GL Plan upload — 2026-09-01 (GL/db/37 re-run)

Two more user requests same day, both live-verified:

- **Scope narrowed to Chapters 1/2/3 only, everywhere** ("exclude chapter
  4,5 - only chapter 1,2,3") — `p.chapter_code IN ('CH1','CH2','CH3')` added
  to the overall/entities/sector Budget+Actual queries (on top of the v2
  Budget-Group=1 filter). `trend[]` dropped CWIP/Other/Unclassified entirely
  (3 rows now, not 6 — they were always 0 or now out of scope). Verified:
  overall budget **8,461,984,756** = sum of the 4 entities = sum of the 3
  trend rows, all three ways of summing agree.
- **452201 check (user asked to confirm)**: verified `dct_budget_actual_period_v`
  and `dct_budget_utilization_v` carry ZERO rows for account 452201 — the
  2026-08-02 platform exclusion at the base views already propagates through
  to both FMR data sources, no code change needed.
- **MSS GL Plan 2026.xlsx loaded** (`docs/Reports/FMR/`, 3,311 raw rows /
  2,351 distinct GL-combination×period keys after aggregation — the sheet
  carries Project/Task detail that collapses onto the SAME combination for
  multiple rows, e.g. several projects sharing one cost-centre+account; a
  first load attempt hit `ORA-00001` on `UQ_GLCF` from exactly this, fixed by
  `GROUP BY` (cc, account, appropriation, period) and `SUM(Value)` before
  inserting — total preserved exactly, 1,869,900,067.54) into
  `dct_gl_budget_cashflow`: `451.070602.<CC>.1.<Account>.4510700.<row's own
  Appropriation>.000.000000.000000`. **Appropriation taken from the row, NOT
  hardcoded to the user's example `200104`** — the sheet mixes Chapter 2
  rows (appropriation 200104, 925.1M) and Chapter 3 rows (appropriation
  300105, 944.8M) in a clean 1:1 relationship with Chapter, so hardcoding
  200104 would have mis-booked 944.8M of Capex plan as Opex. All 28 cost
  centres already resolve to a real sector in `dct_gl_coa_snap` (0 unmapped)
  so the Sector-level plan attributes correctly with no extra work.
- **GL/db/37 generalized**: the GL-cashflow ("Payroll upload") plan leg was
  hard-restricted to the PAYROLL trend row; now every trend type queries it
  (via `dct_gl_cashflow_v.chapter_code = y.chcode`, since the raw table has
  no chapter column) so Opex/Capex pick up BOTH plan sources — the existing
  project-cashflow leg AND this new GL-cashflow upload — summed. Entity- and
  overall-level GL-cashflow sums were already chapter-unfiltered, so they
  picked up the MSS data automatically with no query change. Verified:
  Museums entity plan 0 → **590.3M** (hasPlan N → Y), Opex trend plan
  2,368.0M → 2,766.4M (+398.4M) and Capex 946.2M → 1,138.2M (+192.0M), the
  two increases summing exactly to Museums' +590.3M — three-way reconciled.

### FMR v4 — Plan label rename + Masterpieces project-cashflow classification bug — 2026-09-01 (GL/db/37 re-run + frontend v1.99.1)

- **Label only**: "Plan" renamed to **"YTD Plan"** on the FMR page's KPI
  tile, entity-gauge chips, trend legend/bars, and sector table header —
  added a page-scoped `fmrYtdPlan` i18n key rather than touching the shared
  `spPlan` key (Sector Performance report still says plain "Plan"). No data
  change — the figure was already YTD and stays YTD; a same-session "make it
  Annual" instruction was walked back by the user before any deploy (the
  in-progress Annual edit was reverted, never shipped).
- **Real bug, user-caught**: Masterpieces showed plan=0 despite project
  `4511000829` (chapter 3, appropriation `301439`, `dct_project_cf_butil_v`
  PLAN_APPR_ANNUAL=YTD=868,032,100) genuinely having plan data. Root cause:
  the project-cashflow plan leg's entity CASE (on `budget_combination`) only
  checked `entity_specific_code` (position 6) for Museums/ALC, never checked
  `appropriation_code` (position 7) for Masterpieces the way the
  Budget/Actual leg already did — so a Masterpieces project sitting under
  ES=4510000 (DCT) fell through to DCT via the catch-all `ELSE`. Fixed in
  both spots that build this CASE (entity handler's per-entity plan query +
  sector handler's entity-filter predicate) by checking
  `REGEXP_SUBSTR(budget_combination,'[^.]+',1,7)='301439'` FIRST, mirroring
  the Budget/Actual-side rule exactly. Verified: Masterpieces plan 0 →
  868,032,100 (hasPlan N→Y), DCT plan dropped by the exact same 868,032,100,
  overall total unchanged (entity-independent) — the money moved to the
  right bucket, nothing created or lost.

### FMR v5 — YTD Trend chart drill-down — 2026-09-01 (GL/db/37 re-run + frontend v1.99.3)

Each Budget/Actual/Plan bar on the Entity-Level trend chart is now clickable
and opens the **existing shared `.dw-drawer`** (user: "use the drawer page")
— no new UI. New additive route `GET /gl/fmr/trend/lines?period=&chapter=
CH1|CH2|CH3&metric=budget|actual|plan` returns the generic `{columns,rows,
total,count}` shape the drawer's `drillCols`/`drillRows`/`fillDrill` already
consume (the `col()` builder pattern from `07_gl_budget_util_ords.sql`), so
the frontend needed only a `fmrOpenTrendDrill(item, metric)` call — no new
drawer markup. Budget/Actual drill = the GL-combination rows behind that
chapter (cost centre, account, sector, appropriation, budget, actual, capped
500 by amount). Plan drill = a UNION of the GL-cashflow leg (Payroll/MSS
upload) and the project-cashflow leg (Opex/Capex), same two sources the
trend figure itself sums. **Gotcha caught before shipping**: the new
endpoint didn't call `prod.dct_gl_class_pkg.set_butil_end(...)` — without it
`plan_appr_ytd` silently reads full-year, so the drill's Opex plan total
(4,414M) didn't match the trend chart's own YTD figure (2,766M) until the
same `set_butil_end`/`clear_butil_end` pair used by the main handlers was
added here too. Verified: all 9 combinations (3 chapters × 3 metrics)
reconcile exactly between `/fmr/trend/lines` `total` and `/fmr/entity`
`trend[]`. Browser-verified: drawer opens with the right title/rows, Export
CSV works for free (shared drawer chrome), no console errors.

### FMR v6 — full GL combination column on the trend drill — 2026-09-01 (GL/db/37 re-run + frontend v1.99.4)

Added a leading **Combination** column to `/gl/fmr/trend/lines` (both the
Budget/Actual branch, `cc_string`, and the Plan branch, `cc_string` for the
GL-cashflow rows / `budget_combination` for the project-cashflow rows) plus
a `combos` side-object resolving every distinct combination against
`dct_gl_coa_snap` — the exact pattern already used by the Fund Movement
drill (`GL/db/34`, `col()`/dedupe/`l_seen` table). **Zero new frontend UI**:
the shared drill drawer already special-cases a column with `key==='combination'`
and shows the styled 10-segment "SEGMENTS" popover on hover
(`drillGridOver`/`drillComboRow`) — only had to (1) declare `fmrComboMap`
alongside the existing `fmComboMap` in the outer scope, (2) add it to
`drillComboRow`'s `acRowMap || fmComboMap || fmrComboMap` fallback chain,
and (3) populate it from `d.combos` in `fmrOpenTrendDrill`'s response
handler before calling the shared `fillDrill(d)`. Browser-verified: hovering
the Combination cell shows Entity/Cost Center/Account/Appropriation/Budget
Group/Entity Specific/Future 1/Future 2/Intercompany/Program, matching the
same popover used on the Actuals and Fund Movement drills pixel-for-pixel.

### FMR v7 — drill Export CSV was silently truncated at 500 rows — 2026-09-01 (GL/db/37 re-run, no frontend change)

`/gl/fmr/trend/lines` capped both branches at `FETCH FIRST 500 ROWS ONLY` —
fine for on-screen viewing but `drillExportCsv()` (shared drawer chrome)
just serializes whatever's already loaded into `drillRows()`, so the CSV
silently matched the 500-row page cap instead of the drawer's own
count`/total`. Raised the cap to 5000 in both branches — real volumes here
top out at 1,940 rows (Opex plan, the largest of the 9 metric×chapter
combinations), so every combination now returns its FULL row set with
plenty of headroom, not just a bigger cap. No frontend change: the fix is
entirely server-side, since the export path always exported "whatever
loaded" correctly — it just never had the full set to work with.

### DCT_GL_COA_V — budget-only combinations were invisible platform-wide — 2026-09-01 (GL/db/38, view redefine, no frontend change)

Root cause (user-diagnosed): two independent Fusion extracts feed the CoA
layer. **GL Balances** (`GL_SRC_BALANCES`/`GL_BALANCES_CC`) carries every
combination under budgetary control, budget-only included. **Combinations**
(`GL_SRC_COMBINATIONS` = `ATD_GL_ACCOUNTS_COMBINATIONS`) carries ONLY
combinations that have had an actual journal entry posted — budget with zero
postings never appears there. `DCT_GL_COA_V` (source of the Combinations
Explorer AND every Sector/Chapter/DCT-Program classification join
platform-wide) selected `FROM gl_src_combinations` alone, so any budget-only
combination was invisible to the Explorer and unclassified everywhere else.
Verified example `451.070101.4510311.1.411181.4510700.100103.000.000000.000000`:
8 rows / AED 513 budget YTD each in `dct_budget_actual_period_v`, zero rows
in `dct_gl_coa_snap`. 632 of ~10.1k distinct combinations in `GL_BALANCES_CC`
had no match in the snapshot.

**Fix**: `DCT_GL_COA_V`'s FROM is now a `UNION ALL` of (a) the real Fusion
combinations, byte-identical to before, and (b) any `GL_BALANCES_CC.cc_string`
with no match among the real ones (segments read straight off that already-
canonical, already-zero-padded `cc_string` via `REGEXP_SUBSTR`, wrapped in
`TO_NUMBER` — `gl_src_combinations`' segment columns are NUMBER, confirmed
via `all_tab_columns`, so the UNION ALL legs must match or ORA-01790 fires).
The 10 per-segment description joins and 3 Sector/Chapter/DCT-Program
classification joins downstream needed **zero changes** — they already
resolve at the single-segment level, never the whole-combination level; that
is what makes this fix work without touching any other query. `cc_id` has no
Fusion counterpart for a never-posted combo, so a stable negative hash of
`cc_string` stands in (`-(1+ORA_HASH(cc_string,2147483646))` — real Fusion
`cc_id`s are always positive, verified `MIN=197618`, zero collision risk by
construction; deterministic, so the same synthetic id every refresh). The
moment a real journal entry lands, Fusion assigns a real `cc_id`, the combo
appears in `gl_src_combinations`, the `NOT EXISTS` guard goes false, and the
real row silently takes over on the next refresh — self-healing, no
duplicate, no manual cleanup.

Column list/order is unchanged (no new column), so `dct_gl_coa_stage` /
`dct_gl_coa_snap` needed no DDL change and `prod.dct_actuals_refresh`
(db/v2/118) re-ran unmodified. **Perf gotcha**: the `NOT EXISTS` probe must
compare against a `/*+ MATERIALIZE */`-hinted CTE of the real combinations'
own computed `cc_string` — probing the live `DCT_GL_COA_V`/raw
`gl_src_combinations` per candidate row (10 `dct_gl_class_pkg.norm()` calls
each) timed out; materializing once first made it instant, same lesson as
`otbi-atd/db/80`.

Deployed: row count 9,477 → **10,109** (+632, exact match). Verified against
the example combo — resolves with full description + Sector `Natural
History Museum` / Chapter `Chapter 1`. Backups taken before the change:
view DDL at `final apps/GL/db/_backups/dct_gl_coa_v_ddl_backup_20260901.sql`,
snapshot data at `prod.dct_gl_coa_snap_bak20260901`. 9 dependent objects
(`DCT_GL_RECON_FACT_V`, `TASKS_V`, `DCT_GL_PLAN_SAMPLE_PKG`, `PROJECTS_V`,
`DCT_ACTUAL_V`, `DCT_KPI_PKG`, `AP_INVOICE_DISTRIBUTIONS_V`,
`DCT_PROJECT_SPEND_V`, `DCT_SECTOR_ACTUAL_MONTH_V`) were INVALID going into
this deploy (pre-existing, unrelated ATD-reload drift, confirmed unchanged
in count across the failed-then-succeeded run) — recompiled clean afterward.

### DCT_GL_COA_V — Chapter classification restricted to expense accounts (4xxxx) — 2026-09-01 (GL/db/39, view redefine, no frontend change)

User-diagnosed follow-up to the GL/db/38 fix above: Chapter (Payroll/Opex/
Capex) is meant as an **expense** classification, but the CHAPTER join keyed
purely off the appropriation segment, with no account-type gate — so any
combination on a Chapter-mapped appropriation got a Chapter even on a
non-expense account. Example `451.000000.4510210.1.327012.4510000.202061.
000.000000.000000` (account `327012`, leading digit 3 = Revenue / the
"budgetary-control offset" mirror pattern) was resolving to `Chapter 2`
purely because appropriation `202061` maps there. Platform-wide: 22
combinations carried a Chapter despite a non-4 account (2 Assets, 1
Liability, 19 Revenue/offset) — the 19 alone carried **AED 8.85 billion** of
budget in `GL_BALANCES_CC`, the exact double-counting exposure any Chapter
rollup without its own `account='4'` filter would be open to.

**Discussed and decided (2026-09-01, before implementing):** the fix does
**not** belong in the mapping table (`dct_gl_seg_class_map` — "appropriation
202061 = Chapter 2" is a true, standalone fact about that appropriation, not
wrong on its own) and does **not** belong in the shared resolver
(`dct_gl_class_pkg.resolve_value_id` — used generically for Sector/Chapter/
DCT-Program alike, and Sector/Program have no account-type concept at all).
It belongs at the point where a mapping gets **applied to a real
combination** — i.e. the join. One new `AND` condition on the existing
CHAPTER join: `SUBSTR(norm(c.gl_account,6),1,1) = '4'` — the exact same rule
the view's own `account_type` CASE already encodes, just applied to Chapter
resolution too.

Verified: the example combo's `chapter_code`/`chapter_name` are now NULL;
zero non-expense combinations carry a Chapter platform-wide; a real expense
line on the SAME appropriation (`422401`, Expense) still correctly resolves
to Chapter 2 — only the misattribution is removed, real Payroll/Opex/Capex
lines are untouched. Row count unchanged (10,109 — same combinations, only
Chapter attribution changed). 0 invalid dependents. Backups: pre-fix view
DDL at `final apps/GL/db/_backups/dct_gl_coa_v_ddl_backup_20260901_post38.sql`,
snapshot copy at `prod.dct_gl_coa_snap_bak20260901b`.

### DCT_GL_COA_V — Chapter also excludes account 452201 platform-wide — 2026-09-01 (GL/db/40, view redefine, no frontend change)

User follow-up ("very very important"): account `452201` "Revenue Transfer to
Treasury" is a **standing platform-wide exclusion** — already filtered out of
every balance-bearing view: `GL_BALANCES_CC` itself drops the raw row
(`NVL(REGEXP_SUBSTR(cc_string,'[^.]+',1,5),'x')<>'452201'`, confirmed in its
live DDL), and `DCT_EBS_BALANCE_MAPPED_V`/`DCT_GL_CASHFLOW_V` do the same
(2026-08-02 rule, [[project_gl_452201_bg_rules]]). No dollar amount for it
reaches FMR, Budget Utilization, or anywhere else today — confirmed 0 rows
in `dct_budget_actual_period_v` for this account.

But `DCT_GL_COA_V` (classification metadata, not amounts) still lists 4 real
`452201` combinations — currently blank-Chapter only by coincidence (their
appropriation is `000000`, unmapped). Since 452201 starts with digit 4,
GL/db/39's new expense-only gate alone would still let a Chapter through the
moment Fusion posts a 452201 combination against a chapter-mapped
appropriation. Added one more `AND` to the same CHAPTER join:
`prod.dct_gl_class_pkg.norm(c.gl_account,6) <> '452201'` — mirrors the exact
exclusion `GL_BALANCES_CC` already applies, now also at the classification
layer.

Verified: all 4 `452201` combinations show `chapter_code`/`chapter_name` =
NULL; GL/db/39's expense-only rule still holds (0 non-expense combos with a
Chapter); a real expense line on the same appropriation the example combo
used (`422401`, non-452201) still correctly resolves to Chapter 2. Row count
unchanged (10,109). 0 invalid dependents. Backups: pre-fix view DDL at
`final apps/GL/db/_backups/dct_gl_coa_v_ddl_backup_20260901_post39.sql`,
snapshot copy at `prod.dct_gl_coa_snap_bak20260901c`.

### Budget Utilization — negFund threshold rounds to 1 decimal — 2026-09-02 (GL/db/35 re-run, no frontend change)

User: the over-budget warning band was firing on pure float noise (GRN
receipts landing a few fils above YTD budget, e.g. project 4511000175 —
see the 2026-09-01 diagnosis) and the banner's whole-AED rounding made a
sub-1-AED difference read as "over-spent by 1". Fix: every place the negFund
flag compares `fund_available` (± procash/cost-adj) against zero now wraps
the expression in `ROUND(...,1)` first — 3 call sites (the totals COUNT/SUM,
the `negfund=Y` WHERE filter used by both `/butil` and its row loop) — plus
the displayed `fundAvailable`/`fundAvailableExProcash` (totals AND per-row)
are now themselves `ROUND(...,1)`, so the flag and the number shown always
agree. Effect: a true sub-0.05 AED float remainder no longer flags at all;
a genuine (if small) shortfall like -0.2 or -0.4 AED still correctly flags,
now with a clean 1-decimal number instead of a misleading whole-AED-rounded
one. Verified live: project 4511000175's two lines now show `fundAvailable`
-0.2 / -0.4 (was -0.2464346 / -0.39992), `negFundTotal` -0.6 (was the
misleading whole-AED "-1"). GL post-05 re-run list unchanged (07..35).

### Budget Utilization — negFund materiality raised to whole AED — 2026-09-02 (2) (GL/db/35 re-run, no frontend change)

SUPERSEDES the 1-decimal threshold above (same day). User follow-up on the
same two lines: "there is no difference between budget and GRN actual, so
it's suppose to be 0 — why still showing". Correct — the page displays whole
AED, so Budget 104,725 vs GRN 104,725.2464346 render identically while the
1-decimal flag still fired at -0.2/-0.4. Sub-AED fractions are now treated
as zero end-to-end: the 4 negFund test sites compare `ROUND(expr) < 0`
(whole AED — only a genuine ≥ 0.5 AED shortfall flags) and the displayed
`fundAvailable`/`fundAvailableExProcash` (totals + per-row) snap to exactly
0 when `ABS(raw) < 0.5`, keeping 1-decimal display for real values. Verified
live: project 4511000175 → negFund 0, both lines fundAvailable 0 (raw GRN
still carries the fils, untouched); default DCT-OPEX scope negFund 0 is
GENUINE (raw view has 0 lines < -0.5 under that type — the old 16.75M
over-spend was cleared by the approved costing adjustments); 7 real
over-budget lines under other project types (worst -19.6M) still flag.
Handler 33,824 chars, all INSTR markers verified. Re-run list unchanged.

### FMR page round 2 — spinner, Search region, KPI drilldowns, chart labels — 2026-09-02 (GL/db/37 re-run, APP_VERSION 1.100.0)

Four user-requested enhancements to the Financial Performance Report page:

1. **Loading spinner fixed** — `.bu-load-ov` was wired with a bare
   `<div class="ojpc"></div>` (no child `<circle>`s, so nothing animated —
   confirmed root cause of "no spinner displayed"). Presented 3 live animated
   concepts as an artifact (Continuity/oj-progress-circle, Ledger Gem/brand
   diamond, Bar Build); user picked **Bar Build** — 5 CSS bars in a staggered
   rise/fall wave, brand teal + one gold accent bar, echoing the page's own
   YTD Trend chart. New `.fmr-bars` CSS, `prefers-reduced-motion` respected.
2. **Search region** — the bare Year/Period `<select>`s in the page header
   became a proper collapsible `.bu-sec` Search region (own `gl_fmr_ui`
   localStorage key, mirrors Budget Utilization's `bu-sec`/`toggleBuSec`
   pattern exactly) with Search/Reset buttons + a **Generate Report**
   placeholder (disabled, "coming soon" tooltip — user chose this over
   building a full new Reporting-Platform report in the same round; real
   report generation is a follow-up once the desired sections are confirmed).
3. **KPI-tile drilldowns** — all 5 Entity-Level KPI tiles (Budget/Actual/
   YTD Plan/Actual vs Plan %/Funds Available) are now `.bk-click` and open
   the shared drill drawer. Backend: `/fmr/trend/lines` (GL/db/37) is now
   general-purpose — `chapter` and the new `entity` param are BOTH optional;
   omitting chapter spans all three FMR chapters at once (the KPI band's
   "whole entity level" scope), a new `fundsavailable` metric branch reuses
   the budget/actual query shape, and every row/leg now carries a resolved
   `chapter` and sorts `chapter_code NULLS LAST` then account/GL-segment
   ("sort by chapter then GL segment", user 2026-09-01) — unifying the
   single-chapter trend-bar drill and the all-chapter KPI-tile drill behind
   one query. "Actual vs Plan %" opens the Plan side (Actual already has its
   own tile). Verified live: all 4 metrics reconcile exactly to `/fmr/entity`
   overall (budget/actual/plan/fundsAvailable all matched to the cent), the
   `entity=MUSEUMS` filter matched the entities[] breakdown exactly, sort
   order confirmed Chapter-1-first ascending.
4. **Chart value labels + hints** — every trend-chart bar now shows its
   compact value (`buNum()`) permanently above the bar, plus a styled hover
   tooltip (`.sp-b-tip`, brand-dark card with an arrow, replacing the bare
   native `title=`) showing the full formatted amount + type/measure label.
   `.sp-cols` padding-top raised 6px→26px for label headroom.

Browser-verified end-to-end (local Playwright, 12/12 checks): spinner markup,
Search region open/collapse + summary line, Generate Report disabled with
hint, all 5 KPI tiles clickable and opening the drawer with a Chapter column
sorted ascending, chart value labels present, hover tooltip visibility, zero
console errors. `window.APP_VERSION` bumped to 1.100.0 (GL-only change, no
`shared/` touched). Webtier GL-only overlay release **20260902002208**
(rollback 20260901135751) — verified over HTTPS: current serves 1.100.0 with
the `fmr-bars`/`fmrOpenKpiDrill` markers, previous release intact at 1.99.4,
Admin untouched.

### FMR page round 3 — Generate Report (PDF/XLSX/PPTX) + one-row KPIs + gauge icons + hint popovers — 2026-09-02 (NEW reporting/db/40 + GL/db/41 + render_pptx.py fleet-sync, APP_VERSION 1.101.0)

Four user requests, all live:

1. **Generate Report is REAL** — the placeholder button became the butil-style
   **Generate Report ▾** `.gen` dropdown (Briefing Book PDF / Excel XLSX /
   PowerPoint PPTX). ONE new Reporting-Platform definition **`GL_FMR_REPORT`**
   (`reporting/db/40`, MULTI/PYTHON, landscape, params period REQUIRED +
   entity optional): 5 sections in LOCK-STEP with the GL/db/37 handlers
   (overall KPIs / entities / trend / sectors / notes — bg=1 regex, Chapters
   1–3, entity carve-outs identical), plan-YTD via `pre_sql` GL_CTX.BUTIL_END
   (`post_sql` always clears). PDF = NEW landscape book template
   **`gl_fmr_book.html.j2`** (DB-stored via upload_template.py on vm180;
   FMR_Dashboard layout — header band, 5 KPI cards, 4 entity SVG half-gauges,
   CSS trend chart w/ value labels, commentary boxes, ranked sector table w/
   pace bars; `.keep` wrapper stops the trend table splitting across pages).
   XLSX = sheet per section (automatic). PPTX = NEW **`_fmr_deck`** in
   `render_pptx.py` (cover w/ KPI ribbon · entity table+chart · trend chart ·
   sector table · commentary; dispatches on report_code GL_FMR_REPORT;
   **GOTCHA: `_band` part numbers must be STRINGS ("01") — an int reaches
   python-pptx `r.text` and dies as `TypeError: expected string or bytes-like
   object` with no traceback in the run row**; fleet-synced vm180-182 +
   rpt-worker restart ×3). Bridge = NEW **`GL/db/41`** `POST /gl/fmr/report`
   {period, format PDF|XLSX|PPTX} + `GET :id` + `GET :id/file` (single route
   set, the format is a per-run parameter — unlike butil's 3 definitions);
   gate `GL_RUN_BRIEFING_BOOK`. **GL post-05 re-run list = 07..41.**
   E2E verified via the bridge: XLSX 10.8KB / PDF 77KB (3 pages, rendered +
   visually checked) / PPTX 49KB — all magic-byte checked; plus a LIVE
   in-browser run (menu click → poll → `Financial_Performance_Report_09-2026
   .xlsx` download).
2. **All 5 Entity-Level KPIs on ONE row** — `.bu-kpis.sp-kpis{grid-template-
   columns:repeat(5,1fr)}` (double-class outranks the shared media rules;
   own fallbacks 3-col @1100 / 1-col @760).
3. **Gauge icons** — `.sp-gauge-ico` brand-tinted disc per entity gauge with
   inline SVG (`fmrEntIcon`): DCT landmark · ALC open book · Museums columned
   portico · Masterpieces framed artwork.
4. **Professional hints on every KPI + chart** — `.fmr-hint` ⓘ hover/focus
   popovers (brand-dark card + arrow, formula-first text, 8 new `fmrHint*`
   keys EN+AR) on the 5 KPI tiles, each entity gauge, the YTD Trend header
   and the Sector Level header; edge tiles anchor the popover inward so it
   never clips; the ⓘ click is `clickBubble:false` so it never triggers the
   tile drill.

Deploys: reporting/db/40 + template via python-oracledb/upload_template on
vm180 (SRC OK/SPEC OK verified); GL/db/41 via SQLcl `prod_mcp`; render_pptx
scp'd to vm180-182 + rpt-worker restarted (all active). Webtier GL-only
overlay release **20260902005826** (rollback 20260902002208), verified 1.101.0
+ `runFmrReport` over HTTPS, previous release intact. Tests: browser smoke
**12/12 EN** (one-row KPIs incl. same-top assert, icons, hint hover +
no-drill-on-ⓘ, 3-item menu, LIVE XLSX download) + AR/RTL pass (Arabic hint
text, RTL grid, menu; NOTE: a hidden popover's `inner_text` is EMPTY — hover
first before asserting its text).

## TRV — Tax-rate-variance AP distributions join the AP actual — 2026-09-02

**User rule:** a PO-matched AP distribution of type **"Tax rate variance"** is a real
project/task/etype cost that the GRN leg never carries — the receipt is valued at PO price and
the tax-rate delta exists only AP-side — so it must count in the butil AP actual, and its drill
row must be identifiable as **TRV**. (The `DISTRIBUTION_TYPE` column was added to the AP
distribution extract the same day; example: invoice AD2606-0073 line 2 dist 2, 9,961.66 AED on
4511000245 / ManagementAdvice-N3, previously counted nowhere.)

**The predicate change** (in lock-step across every butil-AP replica):
`WHERE d.po_number IS NULL` → `WHERE (d.po_number IS NULL OR d.distribution_type = 'Tax rate variance')`
- `db/v2/37` `f_ap` — the butil actual (2026 delta: **+36,146.10** across 15 lines)
- `db/v2/122` `f_ap` — the Project Portfolio / 360 parity leg (verified equal after)
- `db/v2/105` — the recon butil-AP replica (zero-residual invariant preserved)
- `db/v2/123` `m_ap` — the sector-perf monthly identity view
- `GL/db/07` `butil/lines` metric=ap drill — same predicate **+ a new `Type` column**
  (`dtype`: `TRV` for tax-rate variance, else the raw distribution type). Deployed as a
  **DEFINE_HANDLER-only patch of that one handler** — NEVER re-run 07 wholesale, its `butil`
  GET is superseded by GL/db/35 (the documented handler race).

**Deliberately NOT changed** (different business meaning — "AP Direct" = invoices with no PO):
`db/v2/34` `ap_direct_actual_ytd`, `db/v2/45/47` `ap_direct_aed`, `db/v2/122` `direct_aed`,
the AP module's `nopo` Direct-AP feature + `reporting/db/38`.

**DECIDED + SHIPPED same day (user: "yes as long as the charge account same as project/task/etype")**
â the rule is now GENERIC: a PO-matched variance dist (Tax rate / Invoice price / Conversion
rate / Retainage) counts in the AP actual ONLY when its charge account IS the line's expense
account (`cid.account_code = REGEXP_SUBSTR(d.expenditure_type,'^[0-9]{6}')`). Live 2026 data
separates perfectly on that test: all 5 IPV dists post on the expense account â **counted
(â113,626.29)**; all 102 Conversion-rate post to 360620 (FX gain/loss) and all 33 Retainage to
230210 (retainage liability) â excluded by the account test, not by name (they will count the
day Fusion posts one on the expense account). Deployed in lock-step: db/v2/37 Â· 122 Â· 105 Â· 123
Â· db/v2/39 (`matched_trv_aed` â **`matched_var_aed`** + new **`variance_types`** LISTAGG of short
codes TRV/IPV/CRV/RET) Â· GL/db/07 `butil/lines` ap drill (DEFINE_HANDLER-only patch again;
dtype now maps all four short codes) Â· reporting/db/21+25 live defs (CLOB surgery round 2:
register Line Type = Direct / TRV / IPV / â¦ / 'Direct + <types>'; book prefix `(<types>)`).
Verified: 123t 30/30 Â· sectorperf API smoke 70/70 Â· recon residual 0 Â· portfolio parity Â·
drill INV-00021 typed IPV reconciling to the butil cell Â· **register run 922** sheet 2 = 5 IPV
(â113,626.29) + 12 TRV (+36,146.10) + 40 costadj rows, main total = live /gl/butil actualAp
(costadj=N) to the cent at the same moment (the AP extracts reload HOURLY â never assert a
figure captured minutes earlier; ~30K drifted between checks twice today).
~~Also outstanding: the butil book/register "AP Invoices – Direct" section SQLs~~ —
**CLOSED same day (user: "it should listed")**: `db/v2/39` `DCT_UNPAID_INVOICES_V` gained
ADDITIVE splits `matched_direct_aed` / `matched_trv_aed` / `ap_actual_aed` (grain unchanged,
so the other two consumers — GL/db/22 Project 360 invoice list + reporting/db/08a — are
untouched), and the "AP Invoices - Direct" sections were repointed: register sheet 2
(reporting/db/25) = amount `ap_actual_aed` + new **Line Type** column (Direct / TRV /
Direct + TRV / Cost Adjustment for the (**) rows) with the `has_po` filter dropped; book
(reporting/db/21) = same amount, TRV rows prefixed **`(TRV) `** on Invoice Number (fixed PDF
template — no new column). Live definitions patched by CLOB REPLACE surgery (both seeds are
MERGE-bearing — Linux SQLcl swallows them); INSTR pre/post counts all 1. **Verified on a real
register run (run 921)**: sheet 2 = 5,299 rows Σ 1,442,587,598.48 = the butil AP actual to
the cent (was trailing by 36,146.10), 12 TRV rows Σ 36,146.10, 40 Cost Adjustment rows
Σ 3,118,877.54, AD2606-0073 listed typed TRV at 9,961.66; the book AP section SQL validated
live (same totals, `(TRV)` prefix).

### Same round — Sector Performance costadj parity + sample-generator hardening
While verifying, the live `/gl/butil` (GL/db/35 owner) had gained the **default-ON costing-
adjustment fold** (Include Cost Adjustment, +3,118,877.54 in 2026) which the sector-perf view
lacked — the two tabs disagreed by exactly that. `DCT_SECTOR_PERF_V` now folds
`DCT_PA_COST_ADJ_BUTIL_V` identically (budget +ovr, actual +adj, fund +ovr−adj; raw + component
columns kept) and the trend handler adds the APPROVED adjustments per accounting period so the
cumulative line still ties to the KPI. `123t`'s recon folds the same way.

The REAL Finance expenditure plan (6,701 rows / 2026) landed in `DCT_PROJECT_CASHFLOW` — the
sample generator's locks fired exactly as designed: purge removed only SAMPLE rows, regeneration
**refused** (−20001). `generate_all` now generates each part independently (a refusal on the
expenditure side no longer blocks the revenue sample, which has no real upload yet), and the
123t harness is real-data-aware (12-row shape asserted on SAMPLE rows only; purge proven to
leave every real row untouched).

### Verified
123t **30/30** · sectorperf API smoke **70/70** (RECON vs live /gl/butil ties again, full-year +
period-cut + sector-filtered) · browser smoke **54/54** against the deployed 1.101.0 build ·
drill for the example line returns exactly the TRV row, typed `TRV`, total 9,961.66 == the
butil cell · portfolio == butil for the project (9,961.66 both).
Pre-existing and unrelated: `PROD.ATD_AR_INVOICE_FULL_VW` is INVALID (references
`H.TRANSACTION_TYPE_TAX_CALCU`, an AR-extract column its source no longer exposes).

## FD Dashboard — Budget Status tab — 2026-09-03 (v1.102.0, NEW GL/db/42)

**Ask:** an executive "Budget status" page from the user's notebook sketch
(`final apps/BI/docs/FD Dashboard/Dashboard  FD.jpg`): a Sectors strip of clickable cards
on top, then one band per Chapter with Budget / Actual / Encumbrance / Fund Available,
across every business unit (DCT and MSS), sector filter off by default, one or more
sectors selectable. Three mockups were built first (`final apps/BI/docs/FD Dashboard/
mockups/` — A Ring Bands / B Consumption Bar / C Boardroom, interactive HTML + PNGs);
the user picked **A · Ring Bands**, the **GL-balances basis**, the **GL app**, and
**Year + YTD period selectors**.

**Basis = the Financial Performance tab's rules, verbatim** (user decision — the two
pages must agree): `prod.dct_budget_actual_period_v` at the period, Budget Group 1
(`REGEXP_SUBSTR(cc_string,'[^.]+',1,4)='1'`), Chapters 1–3 only, entity from segment 6
(4510700 → MSS, 4510600 → ALC, appropriation 301439 → Masterpieces, else DCT).
Encumbrance = `encumbrance_ytd`, Fund = `funds_available_ytd` — verified on live 09-2026
data that Budget − Actual − Encumbrance = Fund at every (sector × entity × chapter)
row, so the four figures in a band always tie. What the bands leave out (Budget-Group-1
rows with no chapter — appropriation '000000', AED 9.45B — and Chapters 4–6) ships as
`excluded{}` and prints as a footnote; never silently dropped.

**GL/db/42_gl_fd_ords.sql** (additive; **GL post-05 re-run list = 07..42**): ONE route
`GET /gl/fd/status?period=MM-YYYY` → the whole (sector × entity × chapter) cube (≈ 100
rows) + `sectors[]` LOV (budget-desc, Arabic name when the class value has one) +
`chapters[]` (code/name/alt from DCT_GL_CLASS_VALUE) + `entities[]` + `excluded{}` +
`totals{}`. Read = any valid session (same as `/fmr/entity`). Deployed via SQLcl
`prod_mcp` (handler 6,188 chars — verified in user_ords_handlers).

**Frontend (GL v1.102.0, GL-only change):** new General Ledger sub-tab **Budget Status**
right after Financial Performance (`NAV_GROUPS` id `fd`, `#pg-fd`, `fd*` VM block placed
before the FMR block in app.js, 36 `fd*` i18n keys EN+AR, `#pg-fd .fd-*` CSS). Search
region = Budget Year + Accounting Period (YTD; default from `GET /actuals/filters`
`defaultPeriod` like the FMR tab) + **Business unit** segmented toggle (All / DCT / MSS /
ALC / Masterpieces, data-driven from `entities[]`) + the SHARED `buUnit` "Figures in".
Sector cards = icon + name + budget + % used + utilisation bar, multi-select any-of,
`{n} selected` + Clear, non-selected cards dim; a sector with nothing in the current
business-unit scope (or all-zero figures — "Museums" has 7 empty combinations) gets no
card. Chapter bands = three ring gauges (Budget full ring, Actual and Encumbrance rings =
share of budget, `fdRingDash` = stroke-dasharray on r=38) + the green Fund Available
square (red `.neg` when negative). **All filtering is client-side** — one request per
period, cards and toggle recompute instantly. Footnote = basis + excluded amounts +
grand total.

**Verified:** `tests/fd_api_smoke.py` **47/47** (401/400 paths, envelope, rows==totals,
Fund=Budget−Actual−Enc on every row, sectors[]==Σrows, **RECONCILIATION vs
`/gl/fmr/entity` overall + all 4 entities to the cent**) · `tests/fd_browser_smoke.py`
**55/55 EN+AR** (nav, defaults, 19→18 cards, rings, any-of select/unselect/Clear, MSS
toggle, Figures-in, collapsed summary, RTL labels). Gotcha: `.fd-lab span` is
`text-transform:uppercase` and Chrome's `inner_text` applies it — compare lower-case.

**Deploys:** GL/db/42 via SQLcl `prod_mcp` (fresh session; single handler, 6,188 chars
verified); webtier **GL-only overlay release 20260903110916** (rollback = re-point
`/var/www/ifinance/current` to `20260902122830`; `cp -al` + `tar --unlink-first` of the 3 GL
files, old release verified intact at 1.101.0, prune by NAME kept the last 5). Live check:
`APP_VERSION = '1.102.0'` + `#pg-fd` served over HTTPS; browser smoke re-run against the
deployed build. Frontend changes are GL-only (no `shared/` touched — no fleet bump).
Mockups + the sketch stay in `final apps/BI/docs/FD Dashboard/` (not deployed).

## Budget Status — figure drill-down + combination hint — 2026-09-03 (v1.103.0, NEW GL/db/43)

**Ask (user, same day):** every figure on a chapter band drills into a drawer listing the
detail by FULL GL code combination, with the same well-formatted GL-description hint the
Budget Utilization drills show.

**GL/db/43_gl_fd_drill_ords.sql** (additive; **GL post-05 re-run list = 07..43**):
`GET /gl/fd/lines?period=&metric=budget|actual|encumbrance|fundsavailable[&chapter=][&entity=]
[&sector=a|b]` — rows from `dct_budget_actual_period_v` under the SAME predicates as db/42's
cube (Budget Group 1, Chapters 1–3, entity CASE, sector any-of on `sector_code`, `UNCLASSIFIED`
= NULL), one row per 10-segment combination with ALL FOUR measures (the drilled one is the
total; zero rows of it suppressed, totals still reconcile), sorted chapter → account → cost
centre (the user's FMR-drill rule), cap 5,000, `fundsAvailable` column flagged `pn` (sign
tint). `combos{}` side-map = every distinct combination resolved in ONE pass against
`dct_gl_coa_snap` (GL/db/34 + 37 pattern) → the shared drawer's delegated Combination
popover (`drillComboRow` now also consults `fdComboMap`). Deployed via SQLcl `prod_mcp`
(handler 7,747 chars verified).

**Frontend (v1.103.0):** the three rings + the Fund Available square are `role=button`
(`.fd-click`: lift + ⤢ affordance, Enter/Space) → `fdOpenDrill(item, metric)` opens the SHARED
drill drawer (`drillTitle` = "Chapter 2 · Opex — Budget", `drillSub` = period · business unit ·
picked sectors by name) scoped exactly like the band, so the drawer total == the figure clicked;
hover a Combination cell = the styled 10-segment code + description popover (`.combo-tip`). A
one-line hint above the bands says so (`fdDrillHint`, EN+AR).

**Verified:** `fd_api_smoke.py` **90/90** (drill 401/400s; for EVERY chapter × measure the drill
total == the cube figure; entity-scoped, 2-sector any-of and entity+sector+chapter drills all
reconcile; rows non-zero + sorted by account; `combos{}` covers ≥ 80% of the rows with the 10
code+desc pairs; Fund = Budget − Actual − Enc on every drill row) · `fd_browser_smoke.py`
**72/72 EN+AR** (4 drillable figures per band, drawer title/subtitle/columns, total == ring
figure, first cell is a 10-segment combination, hover → popover with 10 segments incl.
descriptions, close, sector-filtered Fund drill reconciles + subtitle names the sector).

**Deploys:** GL/db/43 via SQLcl `prod_mcp` (fresh session, 7,747 chars verified); webtier
**GL-only overlay release 20260903121501** (rollback = re-point `current` to
`20260903110916`; old release verified intact at 1.102.0). Live check: `APP_VERSION =
'1.103.0'` + `fdOpenDrill` served over HTTPS; browser smoke re-run against the deployed build.

**Fix, same day (user report: "in fund available drilldown there are lines displayed with no
fund"):** the drill suppressed rows with a drilled figure `<> 0`, but 88 combinations in scope
carry sub-AED remainders (e.g. budget 145,210.00 vs actual 145,209.90 → Fund Available 0.10),
which the drawer's whole-AED `money()` prints as **0**. GL/db/43 now suppresses rows whose
drilled figure ROUNDS TO 0 at the displayed precision (`ROUND(x,0) <> 0`, i.e. |x| < 0.5) in
both the row set and `count`; `total` still sums the whole scoped set so the drawer reconciles
to the band figure unchanged. Redeployed via `prod_mcp` (7,777 chars). `fd_api_smoke.py`
**94/94** (adds "no row displays as 0" per chapter × measure + the reported CH1/sector Fund
Available drill: no sub-AED rows AND total == cube). No frontend change (still 1.103.0).
GOTCHA: an interactive `cp` alias prompted "overwrite?" inside a chained deploy command and
hung SQLcl for 5 min — use `\cp -f` in scripted deploys.

## Budget Status — Departments (Cost Centres) region — 2026-09-03 (v1.104.0, db/42 + db/43 re-run)

**Ask (user):** under Sectors, a second region "Departments (Cost Centres)" showing the related
cost centres as clickable, filtered cards with multiple selection.

**Backend:** GL/db/42's cube grain went from (sector × entity × chapter) to **(sector × cost
centre × entity × chapter)** (rows carry `costCenter` + `costCenterName`; still a few hundred
rows, one request) + a new `costCenters[]` LOV (code / name / sector attribution / budget,
budget-desc) — the client recomputes per-scope figures from `rows[]` exactly as it does for
sectors. GL/db/43's drill gained **`costcenter=CC|CC…`** (any-of on `cost_center_code`,
`UNKNOWN` = NULL) in both the total and the row query, echoed back. Both redeployed via
`prod_mcp` (7,719 + 8,095 chars). GL post-05 re-run list unchanged (07..43).

**Frontend (v1.104.0):** new region right under Sectors — cards = the cost centres of the picked
sectors (all sectors when none picked) with their sector's icon, `code · sector` line, name,
budget + % used + utilisation bar; multi-select any-of (`fdCcSel`, `fdToggleDept`,
`fdClearDepts`, `{n} selected` + Clear, `shown/total` counter); a header text box
(`fdDeptQ`) filters the CARDS only, never the figures. Bands, footnote total and every drill
now honour business unit ∩ sectors ∩ departments (`fdRows`; drill sends `costcenter=` and
names the departments in the subtitle). Picks are pruned (`fdPruneDepts`) when a sector is
deselected, the business unit changes or the period reloads, so a hidden card can never keep
filtering silently. Reset clears both selections and the text filter.

**Verified:** `fd_api_smoke.py` **104/104** (rows carry cost centre, grain unique, `costCenters[]`
== Σrows per cost centre + one sector per cost centre + sorted, drill `costcenter=` any-of
reconciles to the cube) · `fd_browser_smoke.py` **95/95 EN+AR** (region renders 90 cards, sector
pick narrows them to that sector, department pick narrows the bands + the Actual drill
reconciles and names the department, any-of, text filter narrows cards only, prune on sector
change, Clear, Arabic header). Test gotcha: the Departments region reuses `.fd-card` /
`.fd-sec-acts` — scope sector-region selectors with `.fd-cards:not(.fd-cards--dept)` / `.first`.

**Deploys:** db/42 + db/43 via SQLcl `prod_mcp` (fresh session); webtier **GL-only overlay
release 20260903140645** (rollback = re-point `current` to `20260903121501`; old release intact
at 1.103.0). Live check `APP_VERSION = '1.104.0'` + the Departments region markup served;
browser smoke re-run against the deployed build.

## Budget Status — Sectors & Departments PRESENTATION switch — 2026-09-03 (v1.105.0, db/42 re-run)

**Ask (user, same day):** "propose 3 different mockups to enhance the presentation of sectors and
departments regions … executive level" → three studies built on the LIVE Sep-2026 cube
(`final apps/BI/docs/FD Dashboard/mockups/FD_Regions_mockups.html` + `regions_{A,B,C}_{default,selected}.png`,
artifact https://claude.ai/code/artifact/685dcbe5-a21d-4cd2-b74c-948e504b2a8c) → "Create all of them
A,B,C where end users can switch between them from new Parameter in Search Region". Decisions
(AskUserQuestion): default = **B Composition tiles**; the old card design is **replaced** (not kept as a
4th option); the choice is remembered **in this browser** (`gl_fd_ui.layout`); Rows/Tiles show the
**top N with "Show all"** (12 rows / 18 tiles).

**DB (GL/db/42 re-run, handler 8,551 chars):** `GET /gl/fd/status` now also echoes
`thresholds{near,over}` = the GL module settings `BUD_UTIL_NEAR_PCT` / `BUD_UTIL_OVER_PCT` (defaults
90 / 100, same keys GL/db/35 reads) — the page's state pills and map heat reuse the platform's
vs-Budget verdict, no new settings. Additive; GL post-05 re-run list unchanged (07..43).

**Frontend (v1.105.0):** ONE Search-region parameter **Presentation** (`fdLayout`, `<select
class="fd-layout-sel">`: Composition tiles · Ledger rows · Proportional map) drives BOTH regions:
- **tiles** (default) — `.fd-card.fd-tile`: icon + name + check, budget as the one big Fraunces figure
  (`fdBig` = compact under "Exact number", otherwise the chosen unit) + share of the scope total
  (`fdShare`, 1 decimal below 1%), a **composition bar** in the bands' own Actual / Encumbrance / Fund
  colours (`fdSeg`, segments clamped), `x% used · y% committed`, and a **state pill** `fdState` =
  `over` (fund < 0 or consumed > over%) / `tight` (consumed ≥ near%) / `ok` showing `% free` + the
  fund amount. Picked sectors show as header **chips** with × (`fdSelChips`). Department tiles add the
  mono code + sector tag (`fdSectorNameOf`, localised) and a header **Sort** (`fdDeptSort`:
  Budget / % used / % free).
- **rows** — `.fd-lg-row` ledger: check · icon · name (+ share · % used / code · sector) · a
  composition bar on ONE shared scale (`fdRowW` = budget ÷ the region's largest budget) · four
  aligned figure columns (Budget with the exact value beneath; Actual / Encumbrance / Fund with
  `% of budget`); brand spine on the selected row. Horizontal scroll under 900 px.
- **map** — squarified treemap (`fdSquarify`, in-VM; width measured by the `fdMeasure` KO binding +
  resize, `fdMapW`): sector tiles area = budget, fill = % consumed on a 5-step scale whose bands
  are derived from the thresholds (`fdHeatBands` legend: <60 · 60–(near−10) · (near−10)–near ·
  near–over · over committed = rust); labels degrade big → name-only → none (tooltip keeps the
  figures). Departments = the same map **nested per sector group** (`fdDeptGroups`, 20-px sector
  strip when the group is tall enough). Tiles use `inset-inline-start` so the map mirrors in RTL.
  **Unbudgeted items** (a cost centre with actual/encumbrance but zero budget — 1 live: 4511020)
  get a sliver (0.6% of the largest item) so they never vanish; a sliver GROUP (Unclassified,
  17×3 px) drops its padding so its 5 departments still render (`pad` guard) — the browser smoke
  asserts every department has a tile.
- Departments list: `fdDeptsSorted` → `fdDeptsShown` (top N unless `fdDeptShowAll`; the map always
  draws all) + `.fd-more` "Show all {n} departments" / "Show top {n} only"; header count =
  "Showing a of b" or "{n} selected". Everything else (multi-select any-of, prune, drills, footnote)
  unchanged — all three presentations share the same `fdSel` / `fdCcSel` state.
- 30 new i18n keys (`fdLayout*`, `fdSectorsHintRows/Map`, `fdDeptsHintRows/Map`, `fdSector`,
  `fdDept`, `fdColScale`, `fdOfTotal`, `fdOfBudget`, `fdCommitted`, `fdFree`, `fdFundShort`,
  `fdSt*`, `fdShowing`, `fdShowAll`, `fdShowTop`, `fdSort*`, `fdTm*`) EN + AR.

**Verified:** `fd_api_smoke.py` **105/105** (+ thresholds envelope) · `fd_browser_smoke.py`
**129/129 EN+AR** — locally AND against the deployed build (Presentation select offers the 3;
tiles = composition bars + pills + compact figure + sort by % used; rows = one row per sector,
largest bar 100%, second bar ∝ budget, 4 figure columns, top-12 + Show all; map = one tile per
sector, real measured width, area ∝ budget within 8%, no overflow, 5-swatch legend, nested groups
== departments, sector pick re-draws the department map to that sector, department tile narrows
the bands + drill reconciles; `gl_fd_ui.layout` survives a reload; Arabic option labels + RTL
ledger header). Gotchas: the tile footer must NOT reuse `.fd-foot` (the page footnote's class —
127 strict-mode matches); under tiles the header shows chips, not "n selected" — assert
`fdSelSummary()` / `.fd-chip` counts; after `page.reload()` wait for `ko.dataFor(document.body).go`
before evaluating.

**Deploys:** db/42 via SQLcl `prod_mcp` (fresh session); webtier **GL-only overlay release
20260903155452** (rollback = re-point `/var/www/ifinance/current` to `20260903140645`; old release
intact at 1.104.0; prune by NAME kept the last 5). Live check `APP_VERSION = '1.105.0'` +
`fd-layout-sel` served; browser smoke re-run against the deployed build 129/129. No `shared/`
change — no fleet bump.

## Budget Status — presentation radio cards, explicit sort, coloured hint strips — 2026-09-03 (v1.106.0, frontend-only)

**Ask (user, same day):** ① Presentation → radio buttons with a useful, formatted hint;
② sort Sectors/Departments by budget amount; ③ replace the region hint text with a well-formatted
coloured hint for Sectors and Departments; ④ ADVISE ONLY (not implemented) on a balance-by-period
horizontal bar-chart hint on the Budget / Actual / Encumbrance / Fund rings — 3 mockups + the
performance impact.

**Frontend (v1.106.0, no DB change):**
- **Presentation = 3 radio option cards** (`.fd-pres-opt`, `fdPresOpts` {v,l,d}: name + one-line
  description; KO `checked`/`checkedValue` on the radio, the card click sets `fdLayout`, the input is
  `pointer-events:none` — never wrap a KO input in `<label>`) on their own Search row, followed by a
  **formatted hint box** (`.fd-pres-hint`, `fdPresHint` = title + reading text for the picked
  presentation + the state-pill rule with the LIVE thresholds "On track below 90% · Tight from 90% ·
  Over committed above 100% or a negative fund" + the Actual / Encumbrance / Fund legend, or the 5 heat
  swatches under the map).
- **Sort on BOTH regions** (`.fd-sort` in each region header, `fdSecSort` + `fdDeptSort`,
  `fdSortOpts` Budget amount [default, largest first] · % used · % free · Name; `fdSortList` ties
  broken by budget). The map shows no sort control — its area IS the budget. Sectors + departments
  were already budget-desc; the sort is now explicit and stated in the strip ("Sorted by budget amount,
  largest first."). Reset restores both to budget.
- **Coloured hint strips** (`.fd-hint`: brand-soft ground, brand-dark text, gold inline-start spine,
  ⓘ disc) INSIDE each region replace the grey header hint: bold lead ("Pick one or more sectors" /
  "Pick one or more departments") + body + the presentation-specific reading tip (`fdHintTip`) + the
  sort statement + (departments) "Showing the top 18 — Show all lists the rest" (`fdDeptTopTxt`) +
  the legend on the right. The map's separate under-map legend is gone (it lives in the strip).
- 27 new / 4 removed i18n keys (`fdPresDesc*`, `fdPresHint*`, `fdPresState`, `fdSort*`,
  `fdHint*`; the `fdSectorsHintRows/Map` + `fdDeptsHintRows/Map` header variants removed) EN + AR.
- KO gotcha caught by the smoke: a `ko.computed` evaluates EAGERLY at creation — `fdPresHint` read
  `self.fdThr()` before `fdThr` was defined ("self.fdThr is not a function" at boot); keep VM
  blocks in dependency order (the presentation block now sits after `fdThr`/`fdScopeBudget`).

**Advisory (item ④, NOT implemented) — `final apps/BI/docs/FD Dashboard/mockups/FD_RingHint_mockups.html`
+ `ring_hint_M1..M3.png` (artifact https://claude.ai/code/artifact/4d10a8a7-b1dc-4e65-802a-4ece9b284743),
built on the real Chapter 2 Jan–Sep 2026 totals:** M1 YTD ladder (dark popover, bar = YTD balance vs
that period's YTD budget, gold = selected period, month-over-month foot); M2 Monthly movement (light
card, brought-forward pale + month's movement strong, one scale = current YTD); M3 always-on 9-bar
rail under each figure + wide ladder on hover with Budget / Balance / % used per period (also the
only one that works on touch). **Measured cost (SQLcl, PROD):** today's one-period cube 1.86 s DB /
2.1–3.3 s end-to-end / 96 KB; the SAME scan over all 9 loaded periods at cube grain = 2.38 s for
1,822 groups (+0.5 s); a chapter-only 9-period query = 2.34 s (the view scan dominates, not the
period count) ⇒ a lazy per-hover `/fd/trend` would cost ~2.3 s on EVERY first hover per scope —
unacceptable. Recommendation: extend the ONE `/fd/status` request with the year's periods
(rows × period, ~2.5k rows ≈ 0.9 MB uncompressed, compactable to arrays) fetched once per YEAR, so
hovers AND the period selector become instant (page load +≈0.5 s); if the payload grows,
materialise `sector × cost centre × entity × chapter × period` into a snapshot refreshed by the
hourly actuals job (<100 ms, at the price of staleness + one more object). Not built — awaiting the
user's pick.

**Verified:** `fd_browser_smoke.py` **140/140 EN+AR** locally and against the deployed build
(3 radio cards, default tiles card `.on` + radio checked, hint follows the pick incl. the 90%/100%
thresholds and the 3-swatch legend, 2 coloured strips with the sort statement + top-18 note, sort
control on both regions [absent under map], sort by name re-orders and budget restores, Arabic
options + strip). `fd_api_smoke.py` unchanged 105/105.

**Deploys:** webtier **GL-only overlay release 20260903161739** (rollback = re-point `current` to
`20260903155452`; prune by NAME kept the last 5). Live check `APP_VERSION = '1.106.0'` +
`fd-pres-opt` served.

## Budget Status — year series (approach A) + monthly-movement ring hint (Mockup 2) — 2026-09-03 (v1.107.0, db/42 re-run)

**Ask (user):** Mockup 2 "Monthly movement" on the rings, fed by approach **A** = load the whole
year once. Explained to the user as: one call brings Jan→Sep for every row; hover = no wait; period
switch inside the year = no call.

**DB (GL/db/42 re-run, handler 14,381 chars):** `GET /gl/fd/status?period=MM-YYYY` now runs **ONE scan
of the period view for the whole year** and derives EVERYTHING from it: `series[]` streams straight
off the cursor (one compact object per cube key: `{s,c,e,ch,m:{MM:[budget,actual,encumbrance,fund,
combinations]}}` for every loaded period), `periods[]` (MM-YYYY asc), `excludedByPeriod{MM}`; the
anchor period's `rows[]`, `sectors[]` (budget-desc, Arabic names from the class value), `costCenters[]`
(budget-desc, sector = the largest-budget row's sector) and `excluded{}`/`totals{}` are COLLECTED
from the same pass into PL/SQL maps (insertion-sorted, ≤ 100 keys) and written after it — JSON key
order is free. **First cut kept the four single-period scans and ADDED the year scan = 6.6 s; the
one-scan rewrite = 3.0 s / 221 KB (was 3.0 s / 96 KB for one period).** Envelope for the anchor
period is byte-compatible (API smoke unchanged + 8 new checks: series at the anchor == rows key-for-
key and == totals, excludedByPeriod == excluded, series at 01-2026 == a direct 01-2026 call's totals).
GL post-05 re-run list unchanged (07..43).

**Frontend (v1.107.0):**
- `fdCurRows` = rows for the SELECTED period: the server rows for the anchor, else derived from
  `series` (`fdRowsAt`, names from the LOV maps ∪ the anchor rows); `fdScopeRows`, `fdExcluded`,
  `fdHasData` read it. `fdPeriod.subscribe`: a period inside `periods[]` = client-side (prune picks,
  hide the hint, NO request); another year = `runFd`. `fdSectors`/`fdDeptsAll` union the LOV with
  codes present in the derived rows so a sector/cost centre that exists only in an earlier month
  still gets a card.
- **Ring hint** (`.fd-trend`, fixed popover, `pointer-events:none`, z 80; `data-m` = measure → its
  colour + pale tint): `mouseenter`/`focus` on the 3 rings + the Fund square → `fdTrOver(item,
  metric, e)` → `fdTrend()` sums `series` for that chapter under the band's own scope (business unit
  ∩ sectors ∩ departments) for every loaded period ≤ the selected one; rows = {label, ytd, mov = ytd −
  previous ytd, bfW/movW/movStart on ONE scale = the largest YTD so far}; a negative movement is
  drawn INSIDE the pale in red. Title "Actual — monthly movement" + chapter, subtitle with the
  selected period's YTD, legend + average month. Placement below the ring, flipped above when there is
  no room; **re-anchored on scroll (capture) — never hidden on scroll**: Playwright's `hover()`
  scrolls the element into view and the first cut's scroll→hide listener made the popover vanish
  before the assertion. The drill click hides it. 9 i18n keys EN+AR; the drill hint line gains
  "hover a figure for its month-by-month movement".

**Verified:** `fd_api_smoke.py` **113/113** · `fd_browser_smoke.py` **156/156 EN+AR** locally and
against the deployed build (year series loaded with the page; hover Actual → popover with one bar
per loaded period up to the selected one, last row == the ring figure and marked current, mov = YTD −
prev, bars within 0–100, legend + avg, colour follows the measure, hides on leave, Fund square has
its own ladder, stays glued while scrolling; switching to 01-2026 fires NO `/fd/status` request and
re-derives bands + cards, the SERVER drill for that derived period reconciles to the derived band
figure, back to the anchor = still no request).

**Deploys:** db/42 via SQLcl `prod_mcp` (fresh session); webtier **GL-only overlay release
20260903173502** (rollback = re-point `current` to `20260903161739`; prune by NAME kept the last 5).
Live check `APP_VERSION = '1.107.0'` + `fd-trend` served. No `shared/` change.

## Budget Status — monthly-movement hint on the SECTOR + DEPARTMENT cards — 2026-09-03 (v1.108.0, frontend only)

**User ask:** "do the same for sectors and departments" after the performance check (no server
impact — the year `series[]` already carries every sector × cost centre × unit × chapter × month).

**Frontend (v1.108.0):**
- `app.js`: `fdTrend` refactored onto ONE builder `fdTrBuild(metric, keep, bold, item)` — `keep(x)`
  is the series predicate, `bold` the popover subject, `item` (cards only) adds a **4-measure chip
  strip** (`metrics[]` = Budget / Actual / Encumbrance / Fund at the selected period, the ladder's
  measure lit). Three scopes: `fdTrend` (chapter band: BU ∩ picked sectors ∩ picked departments,
  unchanged), NEW `fdTrendSector(s, metric)` (**BU only** — a sector's figure ignores the department
  picks, same as `fdSectors`) and NEW `fdTrendDept(c, metric)` (**BU ∩ picked sectors**, same as
  `fdDeptsAll`) — so the last bar always equals the card figure. NEW `fdTrCard(kind, item, metric, e)`:
  entering a card = Actual; a figure inside it (`.fd-fm`: big budget figure / "% used" /
  "% committed" / free pill / Fund figure; ledger cells; map tile budget) = that measure. The popover
  is ALWAYS anchored on the CARD (`closest('.fd-tile,.fd-lg-row,.fd-tm')`), never on the figure, so it
  does not jump while the pointer crosses the card; the card's mouseleave/blur hides it.
  `fdTrPlace` grows by 44 px when chips are present. i18n `fdTrCardHint` EN+AR.
- `index.html`: card-level `mouseenter/mouseleave/focus/blur` + per-figure `mouseenter` hooks on the
  sector and department cards in ALL THREE presentations; the cards' native `title` tooltips DROPPED
  (they competed with the popover — the chip strip carries the four figures now); popover gains
  `.fd-tr-mx` chips (`ko if: $data.metrics`, absent on the ring popover); both hint strips append
  `fdTrCardHint`. APP_VERSION 1.108.0.
- `app.css`: `.fd-tr-mx` chip strip (lit chip = `--tr-c` border + `--tr-pale` fill), `.fd-fm`
  dotted-underline affordance on hover.

**Performance (measured before building, PROD 09-2026):** status call unchanged 2.94 s / 226 KB;
a card hover sums the 283 series keys once — ~0.07 ms in Python, faster in JS. No request, no
payload growth. Anything outside the cube (per project) would need a new call (~2.3 s each).

**Verified:** `fd_browser_smoke.py` **172/172 EN+AR** locally and against the deployed build
(+16: sector tile hover → popover Actual by default, names the sector, 4 chips with Actual lit,
last row == the tile Actual, no native title; budget figure → Budget ladder + first chip lit;
free pill → Fund ladder; NO request; hides on leave; picked sector → department tile ladder
"code · name" honouring the pick, committed figure → Encumbrance ladder; ledger Encumbrance cell →
that sector's Encumbrance ladder; map tile hover → ladder with the full name; strips carry the
card hint). `fd_api_smoke.py` untouched (no server change).
Test gotchas: hover a tile on its `.fd-nm` — the tile's geometric centre lands on a figure hook and
switches the measure; after a click the pointer still rests on the card, so move it away before
asserting the popover is hidden; dept tile hooks are budget · used · COMMITTED · pill (nth(2)).

**Deploys:** webtier **GL-only overlay release 20260903175814** (rollback = re-point `current` to
`20260903173502`; prune by NAME kept the last 5). Live check `APP_VERSION = '1.108.0'` + 23
`fdTrCard` bindings served. No `shared/` change, no DB change.

## Budget Status — Presentation as a vertical stack at the end side + "Entity" label — 2026-09-04 (v1.109.0, frontend only)

**User ask (screenshot):** ① Presentation parameter vertical, aligned to the far right; ② rename
"Business unit" to "Entity".

- `app.css`: `#pg-fd .filter-grid{align-items:start;grid-auto-flow:dense}`; `.fd-pres-field` =
  `grid-column:-3 / -1; grid-row:1 / span 2; align-self:start` (the LAST two columns at every
  breakpoint — negative lines follow the explicit grid: 7 cols → 6–7, 5 cols → 4–5 — and the end side
  mirrors in RTL); `.fd-pres` = flex column; each option card = one line (title + muted description,
  `.fd-pres-txt` row/baseline); `.fd-pres-hint{grid-column:1 / -3}` so the hint sits left of the stack.
  ≤1100px: stack + hint go full-width (`grid-row:auto`). `dense` matters at 5 columns: the 2-wide
  Entity toggle no longer fits row 1 after Year + Period, so "Figures in" backfills that cell instead
  of leaving a hole. Verified at 1680 / 1400 / 1000 px + Arabic.
- `app.js` i18n: `fdUnitL` Business unit → **Entity** (ar الجهة), `fdAllUnits` All units → **All
  entities** (ar جميع الجهات), `fdSub` "… every entity". The code keeps `entity`/`fdEntity` naming
  (it always was). APP_VERSION 1.109.0.
- `fd_browser_smoke.py` **175/175 EN+AR** (local + deployed): + Entity label + "All entities" first
  segment, + the three option cards stack vertically (same x, ascending y), + the stack is pinned to
  the end side of the grid above the hint row; 'All units' asserts → 'All entities'.

**Deploys:** webtier **GL-only overlay release 20260904044956** (rollback = re-point `current` to
`20260903175814`). Live `APP_VERSION = '1.109.0'`, `grid-auto-flow:dense` served. No `shared/`, no DB.
GOTCHA (this session): `pgrep -f "python3 dev-proxy.py 8212" | xargs kill` matches the calling
`bash -c` wrapper and kills the tool shell itself (exit 144) — anchor it: `pkill -f "^python3 dev-proxy.py 8212$"`.

## Chart of Accounts — classification ASSIGNMENT update was dead (HTTP 555) — 2026-09-04 (GL/db/46, DB only)

**User report:** "can't delete or update sector" → "i update with end date". Reproduced on the live
site: setting an end date on an assignment in the Classification-values row drawer (or editing one in
the Manage CoA Mapping modal) → `PUT /gl/mappings/:id` → **HTTP 555**, nothing saved, the drawer shows
"HTTP 555". Deleting a sector value that still has assignments is refused BY DESIGN (400 "Cannot
delete: N assignment(s) use this value. Deactivate it instead." — a 2.6 s toast, easy to miss);
updating the value itself (name/alt names/tag/order/active) worked all along.

**Root cause:** the PUT handler (GL/db/05, unchanged since 2026-07-21 and broken since birth) used a
scalar subquery INSIDE a PL/SQL expression — `l_cv := NVL(json, (SELECT class_value_id FROM
dct_gl_seg_class_map WHERE map_id=:id))` (and the same for start_date). That is **PLS-00405** at
compile time, so the block never runs and never reaches its EXCEPTION handler → uncatchable ORDS 555.
**GOTCHA (add to the 555 list):** a `(SELECT …)` inside a PL/SQL assignment/argument = 555; read the
row INTO locals first.

**Fix — `GL/db/46_gl_mappings_put_fix.sql`** (DEFINE_HANDLER-only on `mappings/:id` PUT; **never
DEFINE_TEMPLATE on the existing template — that drops its DELETE handler**; the `dh()` helper must
REPLACE `[COLON]` in the PATTERN as well as the source or DEFINE_HANDLER throws ORA-01403): one
`SELECT … INTO l_type, l_seg, l_cur_cv, l_cur_s` then `NVL(json, l_cur_*)`. Same source synced into 05
so a 05 re-run reproduces it. **GL post-05 re-run list now ends at 46.** Deployed as `prod_mcp`
(fresh session; `\cp -f` — an interactive `cp` prompt stalled the first chain). Live handler 1,373
chars, `l_cur_cv` present; DELETE handler untouched (472).

**Verified:** NEW `tests/mappings_api_smoke.py` **11/11** (self-cleaning throwaway value + bogus-segment
assignment: PUT end date 200 + persisted, clear end date + notes, end < start = 400 with the rule,
partial body keeps the class value, unknown id 404, no token 401, cleanup). Live drawer probe: MUSEUMS
/ 4510202 end date 2099-12-31 saved (dirty cleared, no error) and reverted to blank — both PUTs 200.
No frontend change (APP_VERSION stays 1.109.0).

## Budget Status — Chapter bands moved to the FIRST region after Search — 2026-09-04 (v1.110.0, frontend only)

**User ask (screenshot, "urgent"):** move the last region (the Chapter ring bands) to sit right after
the Search region, then Sectors, then Departments.

- `index.html`: the `fd-drill-hint` + `.fd-bands` block (one band per chapter) moved from the bottom of
  `#pg-fd .sp-body` to the top, right after the `.bu-load-ov` overlay and BEFORE the Sectors `.bu-sec`.
  Order is now Search → Chapters → Sectors → Departments → scope footnote (`.fd-foot` + the fixed
  `.fd-trend` popover stay at the end — the footnote is page-level scope/grand total, not a band
  element). No VM change: the bands still filter on the picked sectors/departments.
- `app.css`: `#pg-fd .fd-bands` gains `margin-bottom:16px` (the `.bu-sec` regions carry their own
  bottom margin; the bands had none because nothing followed them). APP_VERSION 1.110.0.
- `fd_browser_smoke.py` **176/176 EN+AR**: + a region-order assert (children of `.sp-body`:
  `fd-bands` first, then the two `.bu-sec` regions).

**Deploys:** webtier **GL-only overlay release 20260904074820** (`cp -al` of `20260904044956` +
`tar --unlink-first` of index.html + css/app.css; rollback = re-point `/var/www/ifinance/current` to
`20260904044956`; prune by NAME kept the last 5). Live `APP_VERSION = '1.110.0'`, marker
`Chapters FIRST` present in the new release and absent in the old. No `shared/`, no DB.

## Budget Status — TOTAL band on top of the chapter rings — 2026-09-04 (v1.111.0, frontend only)

**User ask (screenshot, "urgent"):** one row above the chapter rings with the total Budget / Actual /
Encumbrance / Fund Available.

- `app.js`: `fdTotalBand` computed = `fdSum(fdRows())` (the SAME business-unit ∩ sectors ∩ departments
  scope the chapter bands use, so Total == Σ chapters by construction) with `code:''`, `total:true`,
  name `fdGrand` ("Total") + NEW alt key `fdTotalAlt` ("Chapters 1–3" / "الأبواب 1–3"); null while no
  chapters are loaded. Because `code` is empty, `fdOpenDrill` sends NO `chapter=` to `/fd/lines`
  (GL/db/43 already treats NULL as CH1–CH3 — no DB change) and `fdTrend` matches every chapter
  (`!item.code || x.ch === item.code`), so the drill total and the hover ladder both equal the band figure.
- `index.html`: the band markup became ONE named KO template `fd-band-tpl` (`<script type="text/html">`)
  rendered twice inside `.fd-bands` — `with: fdTotalBand` first, then `template:{foreach: fdChapters}`;
  the band div adds `css:{'fd-band--total':!!$data.total}` + `data-ch="TOTAL"`. APP_VERSION 1.111.0.
- `app.css`: `.fd-band--total` = brand border + soft brand gradient, label strip `--brand-dark` with white
  text, figures 1.1em, a darker Fund square. Same column grid, so the Total figures line up with the
  chapter figures below.
- `fd_browser_smoke.py` **184/184 EN+AR**: chapter-band selectors now `.fd-band:not(.fd-band--total)`
  (3 chapter bands unchanged) + 8 Total checks — first band, label, 3 rings + Fund, all 4 measures ==
  Σ chapters, == `fdTotals` (foot), Actual drill total == band Actual, drill title, hover ladder opens.

**Deploys:** webtier **GL-only overlay release 20260904080059** (`cp -al` of `20260904074820` + `tar --unlink-first` of
index.html + css/app.css + js/app.js; rollback = re-point `/var/www/ifinance/current` to `20260904074820`; prune
by NAME kept the last 5). Live `APP_VERSION = '1.111.0'`; `fdTotalBand` present in the new release's
app.js and absent in the old. No `shared/`, no DB.

## Budget Status — Chapter 4 + Chapter 5 bands — 2026-09-04 (v1.112.0, GL/db/42 + 43 re-run + frontend)

**User ask ("urgent"):** two more chapter rows, Chapter 4 and Chapter 5, like the existing bands.

**Data fact that shaped the rule (live 09-2026):** Chapter 4 (Subsidy) exists ONLY on budget group 3
(5 combinations, 341.3M budget, 0 actual, 310.1M encumbrance) and Chapter 5 (Aids & Grants) ONLY on
budget group 5 (27.9M, all encumbered); on Budget Group 1 there is one zero CH5 row and nothing for CH4.
The bg-3 / bg-5 rows WITHOUT a chapter (341.3M / 27.9M — identical figures) are the 3xxxxx
budgetary-control offsets. So widening the chapter list alone would have produced two empty bands.

- **GL/db/42 (`GET /gl/fd/status`)**: band rule = chapter × budget-group PAIRS — CH1/CH2/CH3 on bg 1
  (unchanged = the FMR basis), CH4 on bg 3, CH5 on bg 5 — applied in the `in_band` CASEs, the entity
  CASE and the scan's WHERE (`bg = '1' OR CH4∧bg 3 OR CH5∧bg 5`, so the bg-3/5 offsets never enter).
  `excluded{}` keeps its meaning (the Budget Group 1 remainder: no chapter / Chapter 6). `chapters[]`
  LOV = CH1..CH5; `scope` = `budgetGroup '1|3|5'`, `chapters 'CH1|…|CH5'` + NEW `budgetGroupByChapter
  'CH1:1|CH2:1|CH3:1|CH4:3|CH5:5'`. `series[]` carries the new keys automatically (same scan), so the
  hover ladders and the client-side period switch work for the new bands with no other change.
  Handler 16,063 chars (SQLcl `prod_mcp`, verified = source length after the [COLON] swap).
- **GL/db/43 (`GET /gl/fd/lines`)**: `chapter=` accepts CH4/CH5 (CH6 → 400), both predicates carry the
  same pairs in LOCK-STEP; no chapter = the five together (the Total band's drill). 8,421 chars.
- Frontend: i18n `fdCH4`/`fdCH5` (الباب الرابع / الخامس), `fdAltCH4` Subsidy (الدعم), `fdAltCH5` Aids &
  Grants (المساعدات والمنح), `fdTotalAlt` → Chapters 1–5, footnote basis/excluded texts rewritten;
  **Budget sub-label is chapter-aware** (`fdBudgetSubOf` → "YTD · Budget Group 3" on Chapter 4, "Budget
  Groups 1 / 3 / 5" on the Total band) from the server's `budgetGroupByChapter` — never hard-coded.
  The bands render from the server LOV, so five bands needed no markup change. APP_VERSION 1.112.0.
  Sector / department cards now include CH4/CH5 (e.g. Strategic Affairs +289.8M budget) — consistent
  with the bands they filter.
- Tests: `fd_api_smoke.py` **144/144** (scope/LOV = CH1..5, CH4/CH5 rows present, totals = CH1–5 rows,
  **FMR reconciliation scoped to the CH1–3 rows** — FMR is bg-1/CH1–3 by definition, CH4 drill == cube,
  CH5 drill == cube, no-chapter drill == totals, CH6 → 400); `fd_browser_smoke.py` **188/188 EN+AR**
  (5 bands, labels/alts EN+AR, CH4 budget > 0, Total alt 1–5, budget-group sub-labels 1/1/1/3/5 + Total
  1 / 3 / 5).

**Deploys:** GL/db/42 then 43 as `prod_mcp` (fresh session each, runner file + EXIT; LF files deployed
fine — lengths verified); webtier **GL-only overlay release 20260904081416** (`cp -al` of `20260904080059` +
`tar --unlink-first` of index.html + css/app.css + js/app.js; rollback = re-point
`/var/www/ifinance/current` to `20260904080059` AND re-run the 2026-09-03 versions of db/42+43 if the DB rule must
go back). Live `APP_VERSION = '1.112.0'`. No `shared/` change. **GL post-05 re-run list = 07..46.**


## Entity = a data-driven classification (rules on ANY GL segment) — 2026-09-06 (GL/db/47 + 48, 03/04 + db/v2/34 re-run, 37/42/43/45 re-run, reporting/db/40+41 patched, GL v1.114.0)

**User ask (2026-09-04/06):** "where entity defined?" → "make it data-driven ... use all GL segments to
confirm the flexibility". Decisions (asked): a combination must NEVER match two rules (overlaps are
refused at save), unmatched = Unclassified, only Entity reads any segment (Sector/Chapter/Program stay
single-segment), all four surfaces switch.

**Model (GL/db/47):** `DCT_GL_SEGMENT` = the 10 canonical segments (key/position/width/names, seeded);
`DCT_GL_SEG_CLASS_MAP.SEGMENT_KEY` (NULL = the dimension's own segment; stored for ENTITY rules only, FK
to the segment table); `DCT_GL_CLASS_VALUE.IS_DEFAULT` (one per dimension via a function-based unique
index — the value used when no rule matches; **Entity only**). Seed: type ENTITY (segment
ENTITY_SPECIFIC, order 40), values DCT (**Default**) / MUSEUMS "MSS" / ALC / MASTERPIECES (EN+AR), and
the 3 former hard-coded rules from 2000-01-01: entity-specific 4510700 → MSS, 4510600 → ALC,
appropriation 301439 → Masterpieces. **Why DCT is a Default and not a rule:** the 4 Masterpieces
combinations sit INSIDE entity-specific 4510000, so "4510000 = DCT" would overlap the Masterpieces rule
and the user's one-rule-per-combination policy forbids that; un-flag the default to see gaps as
Unclassified (the user's chosen bucket).

**Package (03):** `validate_map(..., p_segment_key)` — Entity-only segment picking (-20001 otherwise),
same-segment period overlap (-20090), and the **one-Entity-rule-per-combination guard**: any snapshot
combination the new rule matches must not match another active Entity rule on ANY segment in an
overlapping period (-20090 naming the other rule + the count — verified: ES 4510000 = DCT refused on 4
combinations, ACCOUNT 452201 refused on 1 MSS combination, ACCOUNT 324566 accepted).
`segment_value_of(cc_string, key)`; `entity_of(cc_string, date)` RESULT_CACHE (rule → default → NULL)
+ `entity_asof()`.
**View (04):** `DCT_GL_COA_V` gains 4 columns LAST — `entity_class_value_id/_code/_name/_source`
(RULE | DEFAULT) — via a `LEFT JOIN LATERAL` over the rules (one CASE per segment, earliest start/map_id
tie-break as a safety net) + the flagged default; `DCT_GL_COA_SNAP` **and the db/v2/118 `DCT_GL_COA_STAGE`**
get the same 4 columns (guarded ALTER in 04 — the positional refresh INSERT needs both).
**db/v2/34:** `DCT_BUDGET_ACTUAL_PERIOD_V` gains `entity_class_code/_name` LAST (from the snapshot join it
already had) — re-creating it invalidated 20 dependents; `DBMS_UTILITY.compile_schema(PROD, FALSE)`
fixed all but `ATD_AR_INVOICE_FULL_VW` (pre-existing: references a column the AR extract dropped).

**Surfaces:** every former CASE replaced — `NVL(p.entity_class_code,'UNCLASSIFIED')` for period-view
rows (42 fd/status incl. `entities[]` from the values table + Unclassified only when an in-band row has
it; 43 fd/lines gate against the values table; 37 fmr/entity + fmr/sector + fmr/trend/lines; 45;
reporting/db/41), `entity_of(c.cc_string, TRUNC(SYSDATE))` for GL-cashflow rows, and for butil
`budget_combination` rows a **snapshot join** `LEFT JOIN prod.dct_gl_coa_snap csb ON csb.cc_string =
b.budget_combination` → `NVL(csb.entity_class_code,'UNCLASSIFIED')` (37/45/40). **GOTCHA:** a PL/SQL
function in a predicate against `DCT_BUDGET_UTILIZATION_V` raises **ORA-00979 "PJ"."PROJECT_NUMBER"**
(the optimizer pushes the function predicate into the view's GROUP BY block) — the join returns the
identical figure (4,055,281,743.73) faster. **Perf:** `entity_of` costs ~60 µs/row even with the
result cache (29k-row year scan 2.1 → 3.8 s), so page-scale reads use the snapshot columns, the
function only for small plan tables. Live report definitions GL_FMR_REPORT / GL_BUDGET_STATUS patched by
CLOB REPLACE (seeds 40/41 updated in lock-step; GL_BUDGET_STATUS already carried `entity_class_code`).
Parity: snapshot entity vs the old CASE = **0 mismatches** on all 9,478 combinations; in-band 2026 period
rows 22,814 / 0 mismatches; FD chapter 1-3 rows == FMR entity totals to the cent.

**Routes (GL/db/48, additive; post-05 re-run list now ends at 48 — 48 supersedes 09's GET /mappings and
46's PUT /mappings/:id):** NEW `GET /gl/segments`; `GET /gl/segments/:key/values` for ANY of the 10 keys
(distinct codes + descriptions from the snapshot, dynamic column via DBMS_ASSERT, `?type=` for
currentValueId); `GET /gl/mappings` + `segmentKey/segmentKeyName/segmentDesc` (10-branch UNION over the
snapshot); `POST /gl/mappings` + `segmentKey` (padded to the segment width); `PUT /gl/mappings/:id` +
`segmentKey`; `GET/POST/PUT class-values` + `isDefault`; `GET /gl/combinations` +
`entityClassCode/Name/Source` + `?entity=` (UNCLASSIFIED = no rule, no default). **Every write fires
both refresh jobs asynchronously** (`DBMS_SCHEDULER.run_job(..., use_current_session => FALSE)` on
DCT_ACTUALS_REFRESH_JOB ~8 s + DCT_BUTIL_FILTER_CACHE_JOB ~2 s; already-running = ignored) so a
classification edit reaches every page within seconds instead of the hourly :11 / :37 runs — the fix
for the 2026-09-04 "changes not reflected" report; responses carry `refreshQueued: 'Y'`.

**Frontend (v1.114.0; shipped in webtier release 20260905202533 together with the parallel session's
1.115.0 bump — rollback 20260905201058):** Classification values gets the Entity dimension
automatically (from boot); Default chip on the value + Default select in the editor (Entity only); the
assignments drawer shows a GL-segment column, the one-rule hint, and a per-row segment picker (10
segments) that reloads the value datalist for the picked segment; Manage CoA Mapping gets a segment
picker for Entity; the Combinations explorer gets an Entity filter + column (chip, "· default");
Budget Status / Financial Performance entity names come from the classification (EN/AR), incl.
Unclassified; save toasts say the reports refresh in ~15 s. i18n +10 keys EN+AR.

**Tests:** NEW `tests/entity_class_api_smoke.py` **30/30** (seed, segments, any-segment values, live-view
resolution of a Cost-Centre rule, the three guards, FD == FMR per entity, snapshot back to normal after
the queued refresh); NEW `tests/entity_class_browser_smoke.py` **23/23**; `fd_api_smoke.py` 144/144;
`mappings_api_smoke.py` 11/11; browser regressions coa_tabs + fd_browser against the deployed build.
Deploy order: 47 → 03 → 04 → `EXEC prod.dct_actuals_refresh` → db/v2/34 → compile_schema → 48 → 42, 43,
37, 45 → report CLOB surgery → webtier overlay. All scripts via SQLcl `prod_mcp` (fresh session each).

## Budget Status — compact search, Show Summary and Print — 2026-09-06 (v1.113.0)

Approved by the user with “go ahead”. Search now uses three criteria columns with a
250–300 px Presentation rail at the right (stacked responsively, descriptions wrap).
Show Summary is unchecked on page load and Reset; formatted ring/fund hover/focus
summaries are gated, while card summaries and drill actions remain available.
Print exposes PDF/PPTX via the existing authenticated reporting queue workflow.

- New **GL/db/49_gl_fd_report_ords.sql**: POST `fd/report`, GET `fd/report/:id`,
  GET `fd/report/:id/file`; `GL_RUN_BRIEFING_BOOK` required throughout, status/file
  additionally restricted to the requesting user. **Include 49 in the post-05 list**,
  alongside independent 47/48/50 changes. Renamed from the review's 47 to avoid
  collision with the independent ENTITY-classification migration.
- New **reporting/db/41_rpt_gl_budget_status.sql**: MULTI definition, cube + thresholds
  + global excluded balances. Explicit count/INSERT/UPDATE (avoids the Linux SQLcl
  MERGE skip). Seed detects live `fd/status` entity semantics; re-run after an entity
  handler rollout. Deployed with data-driven entity classification after that
  independent rollout completed; report totals verified against the live dashboard.
- Worker: `render_fd.py`, `templates/gl_budget_status.html.j2`, and narrow dispatch
  hooks in render_pdf/render_pptx installed on vm180/181/182; all services active.
  Backups `/opt/rpt-worker/backups/budget-status-20260906`. No recipients; no deliveries.
  PPTX slides contain dashboard page images. Map adds full ledger pages for tiny
  labels. Exports include all matching departments beyond the UI top-N.
- Webtier: GL-only overlay **20260905201058** of **20260904081416**, cp -al +
  tar --unlink-first, atomic symlink replacement; APP_VERSION **1.113.0**. Later
  independent GL 1.114/1.115 releases preserve these changes. Do not revert a later
  release wholesale to roll back this feature. No shared CSS/assets deployed.
- Live validation: **190/190** browser regression EN/AR; **51/51** report API checks
  (runs 1002–1007, PDF/PPT across all presentations, filtered totals reconcile);
  **14/14** Print-menu/default-summary/responsive/Arabic checks with real downloads.
  401/400/404 tested live; 403 recovery tested with local fixtures. No separate
  cross-user live test account was created. UAT round2-06-09-2026 holds evidence.

Full review/deployment details: [budget-status-review.md](budget-status-review.md).

## Budget Status — Show Summary applies to all graphs — 2026-09-06 (v1.115.1)

User correction: checkbox must cover sector and department cards as well as rings.
`fdTrCard(kind,item,metric,e)` now returns `fdTrOut()` when `fdShowSummary()` is false,
matching the existing ring/fund guard. Covers Composition tiles, Ledger rows and
Proportional map, including nested figure events. Default remains unchecked; open
summaries close immediately when cleared. Selection and drill handlers unchanged.

Deployed only GL index.html (cache version 1.115.1) and app.js as overlay
**20260906020630** over **20260905202533**; exact live hashes checked before activation.
No CSS, DB, or report-worker changes. Rollback: restore previous symlink only if no
later release exists; otherwise reverse this guard/version change in the newer release.
Targeted staged browser verification 66/66; live verification **67/67**; results in UAT round3-06-09-2026.
`fd_summary_scope_smoke.py` exercises every graph type in every presentation,
checkbox off/on/immediate-close, selection still working and Arabic card summaries.

## 2026-09-06 — Budget Status deep review, GL 1.116.1

Deployed release `/var/www/ifinance-releases/20260906104833`, previous `/var/www/ifinance-releases/20260906061035`. Only Budget Status frontend hunks plus the version changed; concurrent GL work was preserved using the live baseline and hashes. Report workers vm180/181/182 were paused until idle, updated, restarted and verified active. Worker backups: `/opt/rpt-worker/backups/fd-deep-20260906`. Only `render_fd.py` and `templates/gl_budget_status.html.j2` changed. Fresh SQLcl deployed `GL/db/49_gl_fd_report_ords.sql`; handlers backed up in round-4 evidence.

Fixes: recover invalid saved settings/storage failures; prevent stale search responses/errors; clear errors on cached-period selection; keyboard Search toggle and accessible criteria/entity state; hide hover instructions when Show Summary is off; configured Entity names in collapsed Search; active Entity classification validation for export; exact/automatic export numeric parity; measured continuation-page pagination retaining complete entries and correct page numbering. User-approved zero-budget behavior: Ledger rows with a No budget allocated notice instead of an empty map, independently for sectors/departments, on screen and in PDF/PPT.

Verification: live browser 190/190, live Show Summary 67/67, six live PDF/PPT reports 51/51; local deep browser 40/40, export fidelity 85/85, reopened PDF/PPT artifacts 24/24, report unit tests 4/4; initial API baseline 144/144. Deployed deep browser checks passed 40/40; configured entity plus Unclassified exports passed 11/11. UAT: `UAT/UAT_GL_round4-06-09-2026/` workbook, Word results and evidence.

Access tests: two temporary accounts verified owner downloads and cross-user 404 (including another privileged user); accounts/sessions removed. Current `FEATURE_SEC_ENFORCE_GL` compatibility behavior permits report submission without the dedicated privilege. This policy remains unchanged pending the user's explicit decision. Automatic approval review initially blocked the additional entity test; the user explicitly authorized the built-in quick login, and the test then passed 11/11 across all configured entities and Unclassified. Regular live PDF/PPT exports passed. No financial data changed and no reports were emailed.

Rollback: reverse only this review's hunks if subsequent changes exist; otherwise the previous release above is available. Restore the two worker backup files and restart safely. ORDS source backup is retained with round-4 evidence. Do not revert unrelated GL changes.

## 2026-09-06 — PLATFORM RULE: budget = expense side only; the funding side is never budget (GL 1.117.0, db/v2/32+110+34 + GL/db/04/18 + reporting/db/32)

**User rule (critical, applies platform-wide):** whenever a budget figure is displayed, the FUNDING SIDE is
ignored. Trigger: the Budget Status footnote "Not in the bands (Budget Group 1 rows with no chapter
classification or Chapter 6): Budget 9,459,056,211 · Actual 0" — the user asked twice what it was. It was
the funding side: Fusion budgetary control books each chapter budget twice, on the 4xxxxx expense
combination (8,851M) AND on a 3270xx "Treasury Contribution towards Chapter-N" account (8,803M mirror,
Actual always 0), plus the 656M revenue budget. EBS carries the same mirror (351xxx → 3270xx, budget ==
expense budget every year 2017–2025, with the matching NEGATIVE actual = funds received).

**DB (all deployed as ADMIN, fresh SQLcl sessions; deploy order matters):**
1. `db/v2/32` `GL_BALANCES_CC` — WHERE gains `NOT LIKE '3270%'` next to the 452201 rule (the whole 327000
   inter-entity-transfer node: 327011–18, 327021, 327031–35, 327050–52). `DCT_BUDGET_ACTUAL_V` gains a
   final `WHERE NVL(SUBSTR(account,1,1),'4') = '4'` (expense only). Only these two view DDLs were re-run.
2. `db/v2/110` `DCT_EBS_BALANCE_MAPPED_V` — `AND NVL(am.fusion_value,'x') NOT LIKE '3270%'` (mapped Fusion
   account; unmapped rows stay for the coverage annex). View DDL only.
3. `db/v2/34` `DCT_BUDGET_ACTUAL_PERIOD_V` — same expense-only WHERE on `k.cc_string`.
4. `GL/db/04` `DCT_GL_COA_V` — **now the SINGLE SOURCE**: the 2026-09-05 Entity re-run of 04 had silently
   REVERTED GL/db/38 (budget-only combinations UNION leg), 39 (Chapter only on 4xxxxx) and 40 (452201 never a
   Chapter) — the snapshot had 0 budget-only combos and 3 non-expense combos with a Chapter, and that was the
   "15.7M moved from the bands to the footnote". 38/39/40 are folded back in (with the Entity columns kept
   LAST); their files carry a "FOLDED INTO 04 — never run after 04" banner. Order: 32 BEFORE 04, or the
   restored 38 leg would pull the 3270xx budget-only combos into the snapshot (and the Sector Performance
   revenue target would read 9.5B).
5. `DBMS_UTILITY.compile_schema('PROD')` (only `ATD_AR_INVOICE_FULL_VW` stays INVALID — pre-existing) +
   `prod.dct_actuals_refresh` (run 2301, 10,091 rows, 12.2 s).
6. `GL/db/18` re-run — YoY EBS leg `e.fusion_account LIKE '4%'` + Fusion leg `f.account_code LIKE '4%'`
   (DOF GL/db/17 already did; recon GL/db/14 already `account_type LIKE '%EXPENSE%'`).
7. `reporting/db/32` EBS_GL_YOY_REGISTER — seed patched + live definition CLOB REPLACE surgery (INSTR
   verified before/after: ebs4=894, fus4=1701).

**Verified (SQL, 09-2026):** `GL_BALANCES_CC` 3270xx rows = 0; `DCT_BUDGET_ACTUAL_PERIOD_V` = 3,396 rows,
all 4-series, budget **8,851,453,715 = the Budget Status bands total to the cent**; bg-1 remainder budget 0
(49 zero rows → footnote hides itself); snapshot 10,091 rows / 611 budget-only combos restored / 0
non-expense combos with a Chapter / 0 452201 with a Chapter / Entity parity 0 mismatches; EBS mapped
3270xx rows 0 every year; Sector Performance revenue target = 976.8M (the full revenue budget — it read
656M while 38 was reverted; unchanged by the treasury rule); recon page unaffected (handler already
expense-scoped — its base view still holds revenue rows by design).

**Frontend (GL 1.117.0, webtier GL-only overlay release 20260906111321 over 20260906104833; live tree
diffed against local = only these hunks):** Budget Status basis footnote adds "Budget = expense accounts
(4xxxxx) only — Treasury-contribution (funding) accounts are never counted" (EN/AR); the excluded
footnote is now "Expense budget with no chapter classification (not in the bands — assign a Chapter in
Settings › Chart of Accounts)" and only renders when a real classification gap exists.

**Rule for every future surface:** any view/handler/report that shows a budget must scope to expense
accounts (or read the expense-scoped fact views) — never `SUM(total_budget)` over all accounts. Revenue
budgets are shown ONLY on revenue surfaces (db/v2/123 + GL/db/24 read `GL_BALANCES_CC` with
`account_type='Revenue'`). Keep 452201 + 3270xx in lock-step in db/v2/32 and 110.

**Also (GL/db/48 re-run, same day):** the post-save refresh kick in the Entity/classification routes is
now a ONE-OFF `DBMS_SCHEDULER.create_job` (ADMIN-owned `DCT_GL_CLASS_KICK_<ts>`, auto-drop, +3 s) whose block
retries `-20042` (db/v2/118 serializes the snapshot refresh) up to 6× every 20 s and then runs
`prod.dct_butil_filter_cache_refresh`. The previous `run_job` kick was silently LOST whenever a refresh was
already running (ORA-27478 swallowed) — `entity_class_api_smoke` caught it racing the hourly :11 job (48
snapshot rows kept a deleted test entity). Trialled as ADMIN: SUCCEEDED in 11 s, job auto-dropped.
Stale tests fixed: `dof_api_smoke` (DETAIL rows only — CHTOTAL/GRAND rows exist since v1.54.0),
`legacy_browser_smoke` (mapping count = API total, not the literal 3,191 — the 73 appropriation identity
rows count too), `entity_class_api_smoke` (45 s wait for the queued refresh; the MUSEUMS value name is data — it was renamed MSS → Museums in the UI — so the literal assertion is gone), `recon_browser_smoke` (the spinner check now waits for the overlay to lay out — `rcBusy` flips true before the KO view switch shows the page container, so an instant `bounding_box()` read None; probe: overlay visible ~2 s at 340 px) and its drill waits widened to 150 s — **FOLLOW-UP (pre-existing, not this change):** the Reconciliation KPI drill (`/gl/recon/drill?measure=all&bucket=matched`, server cap 5,000 rows) answers in 1.3 s but the shared drawer renders all 5,000 rows synchronously (~35 s freeze on the dev VM; the matched set is 15,206 docs today vs < 5,000 when the drill shipped on 2026-07-25). The other GL drill drawers cap at 1,000 with a top-N note — recon should either cap the same way or window the render.

**Tests:** fd_api 144/144 · dof_api 31/31 (after the DETAIL fix) · entity_class_api 30/30 (after the kick fix) · mappings_api 11/11 · sectorperf_api 70/70 (incl. RECON vs /gl/butil) · fd_browser 190/190 · yoy_browser 24/24 (both legs expense-scoped) · legacy_browser 17/17 · recon_browser 27/29 (the 2 = the pre-existing 'no console errors' checks tripped by the shared shell's js/i18n 404 probes — the same 2 recorded on 2026-07-25; every functional check passes EN+AR) — all on the local tree with the new views; frontend release verified live (APP_VERSION 1.117.0 + footnote marker).

## 2026-09-06 — LINE-GRAIN PO RULE: live butil/lines GRN-drill patch

The GRN drill's invoiced/related-invoices linkage joined AP distributions to POs via the
distribution-grain PO columns — but a Fusion PO-match CORRECTION updates only the invoice
LINE (the accounted distributions keep the original PO), so corrected invoices showed on
the wrong PO (9 invoices / 157K AED platform-wide; found via a −5,560 uninvoiced row).
Fix per the platform LINE-GRAIN PO RULE (CLAUDE.md): the drill's inv CTE now joins
prod.ap_invoice_lines and keys the pk join on COALESCE(line PO refs, dist PO refs).
DEPLOYED as a DEFINE_HANDLER-only patch of the LIVE gl.rest GET butil/lines handler via
python-oracledb on vm180 (fetch source → text replace → ords.define_handler with a CLOB
bind — never re-run GL/db/07 wholesale); the file GL/db/07 carries the same text for the
next legitimate rebuild. Verified live: the AD Burger receipt 4513076723 drill row now
reads invoiced 4,800 / uninvoiced 0 / related invoice 140726-1 only — matching Fusion.
