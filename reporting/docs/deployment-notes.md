# Reporting Platform — Deployment Notes

Runbook + history for the i-Finance Reporting Platform (`reporting/`). See the canonical platform-wide
SQLcl/ORDS rules in `final apps/Admin/docs/deployment-notes.md` §2.

## History (most recent first)

## 2026-09-08 — MSS_BUTIL_REGISTER (NEW reporting/db/46): the MSS distribution copy of the butil register

Sibling of FBP_BUTIL_REGISTER, per `docs/Reports/FMR/MSS Budget_Utilization_Register_2026.xlsx`
(red = drop, green = add). Copy of BUDGET_UTIL_REGISTER patched **per section** — each section
SQL extracted with `JSON_VALUE` (**JSON paths must be literals**: `'$.sections['||i||']'` =
ORA-40597, use one static path per index), patched with **asserted REPLACEs** (missing pattern
= RAISE -20001 naming the spot; caught the live section key `pending` vs the assumed `pend`)
and written back with `JSON_TRANSFORM SET '$.sections[n].sql'`. Sheet 1 = fixed 26-column wrap
(`MSS_FIXED_COLS`; Task Number kept + Task Name; 14 red columns dropped;
`fund_movement_amount__pn` keeps the sign tint). **Requester added on sheets 2–6** from the
verified sources: AP = the matched PO line's requester (user rule; rqmap CTE = the LINE-GRAIN
PO RULE linkage → `po_distributions.requestor_name`, keyed **invoice_number + invoice_date**
— number alone cross-attributed 3 collision rows), GRN = the existing `b` map +
`MAX(requestor_name)`, Open PO = per (PO, line) LISTAGG DISTINCT, Open PR = per requisition
(`pr_distributions.requester`, 100% filled), Pending = PR-line ∪ PO-line map COALESCEd; Task
Name on sheets 4–5 via the tnm map. **2026-09-08 (2), same day:** Task Name extended to EVERY
sheet with a Task Number (user request) — sheets 2 (both UNION legs), 3, 6, 7 via the tnm map,
sheet 8 exposing the PBT line's native `task_name`; helpers/key-asserts extended to sections
6–7 (`comments`/`budget_trx`); all EIGHT patched sections DBMS_SQL-parse-checked as PROD.
**Re-run db/46 after any db/25 re-run.** XLSX only; SELF recipient; GL bridge = GL/db/53
`POST /gl/butil/mssxlsx`. Verified live: 2.6MB workbook, sheet-by-sheet layout + fill asserts
(`final apps/GL/tests/mss_register_api_smoke.py` 30/30).

## 2026-09-07 — FBP_BUTIL_REGISTER (NEW reporting/db/45): the FBP distribution copy of the butil register

Per the user's marked-up sample `docs/Reports/FMR/FBP-Budget_Utilization_Register_2026.xlsx`:
definition **`FBP_BUTIL_REGISTER`** ("FBP - Projects Budget Utilization") = a verbatim copy of
BUDGET_UTIL_REGISTER whose copied `bu_lines` section SQL is wrapped in a **FIXED 21-column
projection** (Task Name in place of Task Number; the sample's 19 red-filled headers — EBS
account, appropriation/program names, YTD budget, the vs-Budget trio, all 8 plan columns,
utilization pct, the fund-movement pair — removed) via `JSON_TRANSFORM(source_ref, SET
'$.sections[0].sql' = …)` with an `FBP_FIXED_COLS` marker. Baking the layout into the
DEFINITION (not a `sheet_cols_bu_lines` run param) is deliberate: `dct_rpt_pkg.enqueue` does
`NVL(p_params, l_params)` — run params REPLACE definition defaults — so a params-level default
would not survive a BI run-drawer run; the SQL wrap holds on every entry point. Sheets 2–8 +
params/param-spec stay verbatim copies ⇒ **re-run db/45 after any db/25 re-run** (the refresh
restores the copy, then re-wraps — idempotent). XLSX only; SELF e-mail recipient like the
register. Launched from the GL Budget Utilization page via the NEW GL/db/52 bridge
`POST /gl/butil/fbpxlsx` (no sheetcols forwarding). Deployed via Linux SQLcl `prod_mcp`
(no MERGE, UNISTR Arabic, block <10KB); wrapped SQL parse-checked via DBMS_SQL as PROD.
Verified live: run #1103 → 8-sheet workbook, sheet 1 = exactly the 21 agreed columns in order
(`final apps/GL/tests/fbp_register_api_smoke.py` 18/18).

## 2026-09-06 — BI 1.16.0: report storage and cleanup

User approved the first three storage recommendations: consolidate duplicate maintenance, add the BI storage panel and audit cleanup. Deployed BI-only release `/var/www/ifinance-releases/20260906120807`, previous `/var/www/ifinance-releases/20260906154050`, with baseline hash checks preserving concurrent GL/other work. No worker restart required.

- Fresh ADMIN SQLcl ran `reporting/db/43_rpt_output_maintenance.sql` and `44_rpt_storage_ords.sql`. All objects compile. `PROD.DCT_RPT_CLEANUP_LOG` records start/end, retention/cutoff, deleted file count/bytes, status and errors. Deletions and success audit commit together; failures roll back deletion and record error. The 90-day setting is unchanged; 0 still keeps all files.
- The existing **ADMIN.DCT_RPT_MAINT_JOB** is authoritative because BI Workers reads/manages the ADMIN schedule. Verified duplicate **PROD.DCT_RPT_MAINT_JOB** is disabled (definition retained). ADMIN ran the new audited procedure successfully at 16:08 Dubai. `05_rpt_sched_sync.sql` now includes canonical 43 instead of redefining the old procedure/recreating duplicates. After re-running 04, re-run **44** with the existing additive ORDS scripts.
- `GET /rpt/storage` is read-only and SYS_ADMIN-only (401/403 verified). Summaries read output metadata; no file BLOB downloads/scans. Allocated space is nullable if dictionary access is unavailable. Largest reports limited to 10; history to latest 20. Added-in-period sizes count still-retained files, not net growth. Worker 10-second polling does not query storage; only entering the page or explicit refresh does.
- BI → Workers → Report storage and cleanup: retained-file size/count, retention, eligible files/bytes, allocated storage, 7/30-day additions, largest report types, and cleanup audit with error/empty/loading states. EN/AR + narrow screens verified. No manual purge, per-report retention, archive or shrink added. Audit history is retained from deployment.
- Validation: 21 browser checks, 10 live API/access checks, 11 database assertions, plus scheduled-job confirmation. Test fixtures removed; only one expired synthetic 16-byte output was deleted during testing. UAT workbook/Word/evidence: `final apps/BI/UAT/UAT_BI_round3-06-09-2026/`. Initial live UI samples include real aggregate report-storage metadata.

Rollback: reverse only BI feature hunks if later releases exist; otherwise use the previous release. Procedure/job pre-change source snapshot is in UAT evidence. Preserve audit records. Do not re-enable the duplicate simply to roll back the UI.


- **2026-09-06 — LINE-GRAIN PO RULE (platform-wide, user-approved Wave 1+2 after root-cause
  review).** The −5,560 Uninvoiced on the Sector Perf A.2 register exposed a REAL data
  defect: when Fusion corrects an invoice's PO match (AD Burger 40626-2: entered 10-Aug on
  PO ...8430, corrected 24-Aug to ...8216), the correction lands on the invoice LINE while
  the accounted DISTRIBUTIONS keep the original PO — 9 invoices / 157,059 AED mis-attributed
  platform-wide. FIX: every AP-dist→PO join now keys on **COALESCE(invoice-line PO refs,
  dist PO refs)** (see the CLAUDE.md rule block for the canonical lp fragment). Reporting
  side: db/21 grn_lines + db/25 GRN sheet patched (deployed via python-oracledb `run_seed.py`
  on vm180 — thin mode NEEDS config_dir+wallet_location or DPY-6000) + db/42 re-run (its
  paid-column surgery RE-ANCHORED to a shorter pattern ending at `...distributions d` so it
  survives the lp insertion in the copied db/21 text — all canaries OK). DB side: db/v2/32
  (DCT_ACTUAL_V — its existing `l` lines join MOVED ABOVE pm, ANSI joins can't
  forward-reference — + DCT_BUDGET_ACTUAL_V ap_eff), 39, 45, 46 (apd/aps/apl/inv_link/invpr;
  inv_link+invpr also exclude tax dists so 0-amount tax rows don't ghost-list a corrected
  invoice on its old PO), 47; live gl.rest butil/lines grn drill DEFINE_HANDLER-patched
  (GL/db/07 file synced); AP/db/04+05 re-run. Verified: 0 mis-attributions remain,
  DCT_ACTUAL_V AP total byte-identical (3,525,721,791 — only attribution moved),
  PO_HEADER_V both AD Burger POs match Fusion exactly, run #1073 A.2 rows clean
  (8430: 4,800/0 · 8216: 5,560/100% paid), /gl drill + /ap/dists smoke OK.
- **2026-09-06 — SECTOR_PERF_BOOK: Part 10 REMOVED + "% of Budget Planned" rename
  (TEMPLATE-ONLY).** User audit round: ① explained the NEGATIVE Uninvoiced AED on the A.2
  register — traced AD BURGER PO 451102008430: one 4,800 receipt (31-Aug) vs TWO matched
  invoices (4,800 + a 5,560 invoice dated 10-Aug with NO goods receipt recorded) —
  uninvoiced = received − invoiced goes negative when a PO line is invoiced ahead of (or
  without) its GRN; real data, flags a missing receipt. ② **Part 10 "Observations &
  Insights" REMOVED ENTIRELY** (user picked "Remove entirely" — the only content point
  never specified in their review rounds): the five auto-insight paragraphs, the
  methodology block, its TOC row and the pre-compute block (elapsed/oldest_po etc.);
  the report now ends on Appendix A.4, TOC = 01–09 + A. ③ **"Plan Coverage" renamed
  "% of Budget Planned"** (user picked from 4 offered names): the Part 09 KPI tile, the
  by-Department chart title and the 9.1 column header. Verified run #1072 (75 pages;
  zero "Observations"/"Plan Coverage" strings anywhere).
- **2026-09-06 — SECTOR_PERF_BOOK Part 08 sorted + Part 09 by-Department (db/42 re-run +
  template).** Part 08 (Pending Approvals): the Aging bars, the Top-pending-approvers
  chart AND the 8.1 table all iterate amount-DESC sorted lists (PAGS/PAPS — the aging
  ladder keeps its bucket labels but rows order by pending value, per the user's "sort
  all charts and table by Amount"). Part 09 (Expenditure Plan Performance) re-based to
  DEPARTMENT: NEW injected section **sp_dplan** = the plan_sector logic re-grained to
  cost_centre × department over dct_sector_perf_v (costadj + effective plan already
  folded; exec/coverage % + the settings-driven plan status via the PLAN_EXEC_TOL th
  join; ordered by annual budget DESC) — drives the "Plan execution by Department" +
  "Plan coverage by Department" charts (labels = "Full Department Name (CC code)") and
  the "9.1 Plan vs actual by Department" table. **REMOVED (user: "both")**: the 9.2
  "Largest deviations from plan" table and the explanatory paragraph at the page bottom
  (PLS/PLD header sets remain but are unused). TOC 09 description re-worded. Verified
  run #1071 (rasterized both pages; sp_dplan 7 rows).
- **2026-09-06 — SECTOR_PERF_BOOK Part 07 rework + NEW Appendix (db/42 re-run + template).**
  ① Part 07 chart = NEW injected section **sp_pr** (the 12 largest funds-Reserved PR lines;
  predicates are DCT_RESERVED_PR_LINES_V VERBATIM — the view carries neither pr_line nor
  requester, so the section reads prod.pr_distributions + pr_lines directly — keep in
  lock-step with db/v2/39): label **"PR number(Line) - Requester"** (requester =
  `COALESCE(pl.requester_name, d.requester)` — the distribution's own `requester` is a
  USERNAME/email, pr_lines.requester_name is the display name), amount-sorted, value =
  "4.40 M · 41 days" (**days_reserved** = today − the funds-reservation budget_date); the
  Largest-Single-Line KPI reads sp_pr[0] (PR#(line) · requester). ② **KPI-guide footnote**
  at the bottom of BOTH Part 06 + Part 07 pages explaining Largest Single Line (and Days)
  + pointing at the appendix register. ③ NEW content point **"A — Appendix — Detailed
  Registers"** (circled "A" in TOC + band, placed AFTER Observations): the four register
  pages MOVED out of parts 05/06/07 → **A.1** AP invoices (+ NEW **Paid % column**, tfoot
  shows the overall X.ap_paid_pct), **A.2** GRN (+ **Paid % column** per receipt line =
  paid/invoiced of its matched invoices, tfoot X.grn_paid_pct), **A.3** open PO lines,
  **A.4** open PR lines; Observations' "(Part 5.2)" → "(Appendix A.2)". The Paid%
  columns come from **surgery on the COPIED ap_lines/grn_lines sections** (3 targeted
  REPLACEs run BEFORE the sp_* prepend so patterns match only the db/21 copy; grn's
  inner "a" subquery grows the ap_invoices header-ratio join). GOTCHA (self-inflicted):
  a python splice that edits with stale indexes corrupted the template — restored from
  the fleet copy (/opt/rpt-worker/templates/ = last deployed state); the redo asserts
  every pattern and writes only when all pass. Verified runs #1069 + #1070 (76 pages;
  requester names not usernames, Appendix A.1-A.4 present, A.1 tfoot 46% paid).
- **2026-09-06 — SECTOR_PERF_BOOK Part 06 Open Obligations round + Part 07 same-bug fix
  (TEMPLATE-ONLY).** The user asked "what is the Largest Single Line KPI?" — it is the
  single biggest open PO line, and it was showing a bogus **3 K** because the open_po
  section is ordered by project/task (db/21), so `PO[0]` was merely the first project's
  line; the "Largest open PO lines" chart divided every bar by that 3 K (bars overflowing
  at full width, K-scale values). FIX: `po_sorted` = PO amount-DESC in the template —
  KPI now reads the true largest (8.80 M) **with a self-explaining sub-line** ("the
  biggest single open PO line — PO 451102004891/1 · supplier"), the right chart iterates
  po_sorted (proper proportional bars, FULL supplier names, "sorted by open amount"
  note) and the 6.1 register finally honours its own "ordered by open amount" label.
  Left chart = FULL supplier name + **"(N POs · share%)"** bracket (distinct PO numbers
  via a namespace dict; share = of the open-obligation total; `.dep-bars` wrapping
  labels). **Part 07 had the IDENTICAL latent bug** (`PR[0]`, project-ordered) — same
  fix: pr_sorted drives the KPI (4.40 M + explanation), the chart and the 7.1 register.
  Verified run #1068 (72 pages; Part 06 on p49, Part 07 on p60, both rasterized).
- **2026-09-06 — SECTOR_PERF_BOOK Top-10 suppliers Paid% two-tone bars (user picked from 3
  proposed styles; db/42 re-run + template).** Each supplier's spend bar splits into a
  GREEN paid portion + gold unpaid remainder, and the value column reads
  "25.20 M · 89.60% paid"; a legend line explains the tones ("green fill = the paid share
  of what the supplier has billed"). Data: **sp_supp EXTENDED** with per-supplier
  billed_aed / paid_aed / paid_pct — AP leg = counted AED weighted by each invoice
  header's paid ratio (capped 0..1 ⇒ pct ≤ 100 by construction), GRN leg = the matched
  invoices behind in-scope receipts at (po_distribution × invoice) grain joined to the
  ap_invoices header ratio — summed over suppliers the legs equal the Paid KPI amounts,
  so the chart and the tile can never disagree. Template: SUPC map now stores the whole
  sp_supp row; `.hb-paid` nested div (height 100%, width = pct capped 100) inside the
  gold `.hb-bar`; `.sup-bars .hb-val` widened to 132px. A supplier with no billed
  invoices keeps a solid gold bar and no % label. Verified run #1067 (rasterized: 0%
  solid gold / 100% solid green / 49.7% half-half, all 10 rows labelled).
- **2026-09-06 — SECTOR_PERF_BOOK formatting round: circled part numbers + name-first
  departments + composition-bar height (TEMPLATE-ONLY — no db/42 run).** ① Every content
  point number sits in a **formatted circle**: the part-band `.pt-no` is now a 34px white
  disc (brand-dark number) and each Contents-index number a 30px brand disc (`.toc .no
  span` — the numbers are wrapped in spans; a bare td can't be circled). ② Every
  department + cost-centre combination reads **"Full Department Name (CC code)"** — the
  Part 04 band title, the Part 02 Utilization-by-Department bar labels and the
  Budget-overview-by-Department first column (was "code · name"). ③ The **Budget
  composition card stretches to its neighbour's height**: the composition `.charts` rows
  (Parts 02 + 04) get `.eq { align-items: stretch }` and the card `.comp` becomes a flex
  column whose `.stack` flex-grows (`height:auto`, segment divs `height:auto`), so the
  bar fills whatever height the Utilization bars card sets — self-adjusting for the
  10-bar Part 02 row AND the 5-bar department pages. Verified run #1066 (rasterized TOC /
  Part 02 / department pages).
- **2026-09-06 — SECTOR_PERF_BOOK Part 05 "Actuals" rework (user-annotated; db/42 re-run +
  template).** ① "Monthly actuals — AP vs GRN" chart REMOVED (its `mo`/`months`/`mmax`
  computation deleted; `.cols` CSS left in place); the Top-10-suppliers panel is now the
  full-width chart. ② Supplier bars show the **FULL supplier name + "(N invoices)"** —
  counts from NEW injected section **sp_supp**: per-supplier DISTINCT invoices across BOTH
  legs (user-approved) — the direct AP invoices of the register (`dct_unpaid_invoices_v`,
  same predicates as ap_lines) UNION the **PO-matched invoices behind the in-scope
  receipts** (the sp_extra grn linkage + the grn_lines register's charge-account/non-zero/
  hash-id exclusions, supplier via po_headers — so names key 1:1 to the template-summed
  bars; keys prefixed 'A'/'P' so the two id spaces can't collide). Bar labels wrap via
  `.sup-bars .hb-lbl` (420px); an uninvoiced-only supplier prints "(0 invoices)".
  ③ NEW **Paid KPI tile** (between Active Suppliers and Top Supplier Share): paid amount +
  **% of the Total Actual** — sp_extra EXTENDED with `ap_paid_aed` (register AED weighted
  by each invoice header's paid ratio) + `grn_paid_aed` (the matched-invoice paid leg);
  tile = (ap_paid+grn_paid) and ÷ actual_ytd. ④ AP Invoices (direct) + GRN Receipts tiles
  gain the same bold **"X% paid"** as Part 02 (same X.ap_paid_pct/grn_paid_pct — the two
  parts can never disagree). Top-Supplier-Share tile name un-truncated; Part-05 TOC
  description re-worded (no more "monthly trend"). Sub-pages 5.1/5.2 untouched. Verified:
  sp_supp/sp_extra live via DBMS_SQL (228 suppliers / 1 row) + run #1065.
- **2026-09-06 — SECTOR_PERF_BOOK content restructure: 2.1/2.2 removed, NEW Part 03 "Top 10
  Projects Budget" + NEW Part 04 "Top 5 Projects Budget by Department" (user-approved; db/42
  re-run + template).** Part 02's two sub-tables are GONE (2.1 Utilization by sector — a
  one-sector report made it a one-row duplicate of the KPI band — and 2.2 Budget lines under
  pressure; the Observations "Budget pressure" insight dropped its "Part 2.2 lists…" sentence
  but keeps the tightest-line callout). **Part 03** = the 10 largest task budget lines in
  scope (project × task grain, etypes rolled up, ordered by annual budget) as one full-width
  card table — Project Number / Project Name / Task / Annual Budget / Plan(YTD) / Actual /
  Encumbrance / Fund Available / Actual-Budget % / Actual-Plan % + a Total row (ratios
  recomputed from sums). **TASK DISPLAY RULE (user):** a PLAIN-NUMBER task number (the MSS
  style: 2, 4, 5…) prints the task NAME instead (`REGEXP_LIKE '^[0-9][0-9. ]*$'` →
  ATD_TASKS.task_name PROJECT-SCOPED via ATD_PROJECTS, the db/25 tnm pattern); code-bearing
  task numbers (DCT style, e.g. "Facilities Rent-N1") print as-is. **Part 04** = ONE PAGE PER
  DEPARTMENT (cost centre) of the sector, largest budget first — a full Part-02 replica scoped
  to the department: 8-tile KPI band + composition stack (from the EXTENDED sp_dept row) +
  "Utilization by Project" bars (top 5 by budget, full project number · name) + "Department
  Overview" kind table (sp_dkind rows, Total = the sp_dept row) + "Budget overview by Project"
  table (top 5 + Total of the shown 5 + "top 5 of N — remaining budget" note via proj_count).
  db/42: sp_dept EXTENDED (actual_ap/actual_grn/obligation_po/commitment_pr, budget_lines,
  over_budget_lines, effective plan_annual) + 3 NEW injected sections **sp_top10 / sp_dkind /
  sp_dproj** (all on dct_sector_perf_v with the l_bscope predicate incl. the NVL'd chapter
  default; sp_dproj = ROW_NUMBER PARTITION BY cost_centre ≤ 5 + COUNT(*) OVER proj_count).
  Template: TOC gains entries 03 + 04 (02's description re-worded), old parts 03–08 renumbered
  **05–10** (pt-no, sub-h 3.1→5.1 … 7.2→9.2, footers, Observations cross-refs). Verified:
  section SQLs live via DBMS_SQL (10/10/25/7 rows for Support Service), run #1063 default
  scope — TOC 10 entries, Part 03 total ties to the band, 7 department pages each reconciling
  to the By-Department table row.
- **2026-09-06 — SECTOR_PERF_BOOK default chapter scope = Opex + Capex (user-approved; db/42 re-run + template + GL v1.119.0 hint).**
  The report now TARGETS the Opex + Capex chapters: db/42 resolves the default chapter list
  from the chapter classification (`alt_name1 IN ('Opex','Capex')` → `'Chapter 2|Chapter 3'`)
  and **rewrites every copied section's chapter predicate to `NVL([COLON]chapter, <default>)`**
  (surgery on both the aggregate and the `s.`-aliased scope form, before the sp_* prepend, so
  the default holds on EVERY entry point — GL bridge, BI run drawer, schedules). The GL page's
  existing **Search → Chapter multi-select overrides it** (that was the approved flexibility
  mechanism — no new UI). sp_kind's hard `IN ('Opex','Capex')` filter REMOVED: the Sector
  Overview table now shows every kind in scope and its Total ALWAYS equals the KPI band
  (the 299.8-vs-309.3 gap is gone — a default run is 299.80M everywhere; adding Chapter 1
  brings a Payroll row and 309.3M everywhere). Cover gains a **"Scope: Opex + Capex"** line
  (kinds derived from the data); the band chip prints "Opex + Capex chapters (default)" or
  the explicit comma-separated chapter list; table title/Total label follow the kinds.
  Param-spec chapter hint updated for the BI drawer; GL menu-entry hint mentions the default
  (v1.119.0, webtier 20260906194839). NOTE: lines with NO chapter classification fall outside
  any chapter pick — chapter coverage is effectively total on live data. Verified: run #1061
  (default — cover Scope Opex + Capex, KPIs 299.80M, table total = band) and #1062
  (Chapter 1|2|3 — Scope Opex + Capex + Payroll, Payroll row, plain Total).
- **2026-09-06 — SECTOR_PERF_BOOK Overview feedback round 2 (db/42 re-run + template).** Six
  fixes on the annotated page: ① "Actual vs Plan X%" wrapped in a nowrap span (never splits
  across lines); ② composition stack prints each segment's % INSIDE its bar (≥5.5% wide;
  Available segment gets a dark `.dk` label); ④ department bars + table show the **cost-centre
  code + FULL department name** — sp_dept regrained to `GROUP BY cost_centre, department`
  (+ `plan_ytd` column so the Total row can recompute ratios from sums) and `.dep-bars
  .hb-lbl` widened/wrapping; ⑤ the 299.80M-vs-309.30M question = the table's Opex+Capex-only
  rule — a `.tbl-note` footnote now prints the excluded amount so the report self-explains;
  ⑥ table retitled **"Budget overview by Department"** + tfoot **Total row** (sums over ALL
  departments, ratios recomputed — reconciles to the KPI band exactly: 309.30M / 107.80M /
  34.90% / 63.70%) + centred column headers (`.chart .data th`); ⑦ part-band scope line
  truncate 80→150 so "Project type: DCT OPEX Project Type" prints in full. Verified live run
  #1060 (Support Service, YTD 09-2026).
- **2026-09-06 — SECTOR_PERF_BOOK Overview rework (annotated round: db/42 re-run + template; NO frontend change).**
  Part 02 "Budget Utilization Overview" rebuilt per the user's 9 annotations, all figures from
  THREE new SECTOR_PERF-only sections that db/42 now injects alongside `terms` (same
  `"sections":[` surgery + INSTR guard; l_bscope/l_scope copied VERBATIM from db/21 — keep in
  lock-step): **`sp_extra`** (kv: Actual-vs-Plan %, Actual/Budget %, and the amount-based
  %Paid pair — AP = paid ratio per `dct_unpaid_invoices_v` header applied to the counted
  `ap_actual_aed`; GRN = the l_grn PO-distribution linkage joined to `ap_invoices` headers:
  paid ÷ invoiced of the invoices matched to the in-scope receipts), **`sp_dept`** (department
  rollup over `prod.dct_sector_perf_v`, ordered by annual budget DESC) and **`sp_kind`**
  (Opex/Capex + ROLLUP Total — **Opex+Capex ONLY**, user decision; other kinds excluded).
  All three ride `dct_sector_perf_v` (db/v2/123: cost adjustments already folded, plan +
  expenditure kind, BUTIL_END-aware) so they tie to /gl/butil by construction — verified
  SUM-for-SUM against the butil view (309.32M / 107.81M exact). **Ratio conventions
  (user-approved): Actual = AP+GRN+approved costing adjustments; Actual/Budget % vs the
  adjusted ANNUAL budget (the standing vs-Budget rule); Actual/Plan % vs the EFFECTIVE YTD
  plan (revised else approved); %Paid by amount.** Template: YTD-Plan tile + "Actual vs
  Plan %", AP/GRN tiles + "% paid", Utilization tile → **Actual/Budget %** (YTD actual ÷
  annual budget), "Top sectors by approved budget" REMOVED (one-sector report),
  "Utilization by sector" → **"Utilization by Department"** bars (top 10, budget-ordered),
  plus two new table cards: **Sector Overview — Opex/Capex** (Annual Budget · YTD Actual ·
  YTD Plan · Actual/Budget % · Actual/Plan %) and **By Department** (Annual Budget · Actual ·
  Encumbrance · Fund Available · Actual/Budget % · Actual/Plan %, top 12 + note). Bare
  `sub-h` numbers (1.1…6.2) renumbered +1 to follow the part shift (the earlier regex only
  caught "Part N"). Empty-state guard: `X.get('attr')` — attribute access on the empty-dict
  helper returns Undefined which PASSES `is not none` and then blows up on `> 100`.
  Verified: live run #1058 (Support Service, YTD 09-2026) — Actual vs Plan 63.70%, AP 48.80%
  / GRN 92.10% paid, Actual/Budget 34.90% = 107.81/309.32, dept + kind tables laid out per
  the annotation, 47 pages, following parts untouched.
- **2026-09-06 — SECTOR_PERF_BOOK "Terms and Key definitions" content entry 01 (db/42 re-run + template + datasource.py LOB fix).**
  User feature: the report's FIRST content entry is now **"Terms and Key definitions"** — a
  rich-text document managed in **GL → Settings → Terms and Key definitions** (`DCT_GL_REPORT_TERMS`,
  db/v2/129; Quill editor, CLOB content, start/end validity + lookup status + applied-to scope
  seeded `SECTOR_PERF`). `db/42` now **PREPENDS a `terms` section into the copied source_ref
  after every refresh** (string surgery on `"sections":[` + INSTR guard, so the 42-after-21
  coupling still holds): the section SQL selects the ACTIVE document whose window covers the
  report's **period-end date** (`:period` MM-YYYY → LAST_DAY; full year → 31-Dec of `:year`).
  Template: contents index gains entry 01 and every part shifted +1 (Overview 02 … Observations
  08); the new Part 1 page renders `content_html` via `|safe` inside `.terms-doc` (+ ql-* CSS
  for Quill alignment/size/indent/RTL classes; empty state prints a notice, numbering stable).
  **Runner fix (fleet-synced + rpt-worker restart ×3): `datasource.fetch` now materialises LOB
  values at fetch time** — a CLOB column previously reached Jinja as an oracledb LOB handle
  (dead once the cursor closed); inert for LOB-free reports. Verified live: run #1054 prints
  the 7 seeded terms as Part 1 with formatting; local render test covers both branches.
- **2026-09-06 — SECTOR_PERF_BOOK "Sector Performance Report" (reporting/db/42 + `sector_perf_book.html.j2` + NEW render_pdf.py per-page header/footer hook).**
  A distribution copy of BUDGET_UTIL_BOOK launched from the GL Budget Utilization page's Generate
  Report menu (bridge `GL/db/50`, `POST /gl/butil/sectorbook`). `db/42` seeds the definition as a
  **column-for-column copy of BUDGET_UTIL_BOOK** (source_ref / params_json / param_spec_json
  verbatim; PDF-only; own `pdf_template`) — **re-run 42 after any db/21 re-run** to refresh the
  copy. The template differs only in the chrome, per the user's annotated cover: DCT logo top-right
  + user-approved copyright line ("© <generation year> Department of Culture and Tourism — Abu
  Dhabi. All rights reserved. Confidential — for internal use only.") on EVERY page, cover = title
  "Sector Performance Report" + "YTD MM-YYYY" subtitle + Prepared-by card ("Financial Planning and
  Reporting") only — no parameter chips / description / Generated block. **NEW generic runner
  hook** in `render_pdf.py` (`_extract_pdf_chrome`): a template may embed
  `<template id="pdf-header" data-margin="24mm">…</template>` and/or
  `<template id="pdf-footer" data-margin="16mm">…</template>`; the blocks are cut out of the
  flowing HTML and passed to Chromium's `displayHeaderFooter`, so they repeat on every printed
  page **inside the page margins** (content can never overlap them) and `data-margin` overrides
  that side's margin to make the room — mind the shrunken page box (top 24mm ⇒ the cover block
  must fit 170mm, not 180mm). Reports without the blocks render byte-identically to before; on
  the WeasyPrint path an unprocessed `<template>` element renders nothing. The logo rides the
  template as a ~27KB quantized-PNG data-URI (Pillow MEDIANCUT 48 colours from
  `docs/photos/DCT logo.webp` — the raw PNG was 90KB). Fleet: `render_pdf.py` +
  `templates/sector_perf_book.html.j2` scp'd to vm180-182 + `systemctl restart rpt-worker` ×3;
  template also uploaded to `DCT_RPT_TEMPLATE` (96,761 bytes) via `upload_template.py` on vm180
  (NOTE: the service env vars `RPT_DB_USER`/`RPT_DB_DSN`/`TNS_ADMIN` live in the systemd unit,
  not `/etc/rpt-worker.env` — export them manually for ad-hoc runs). Verified: local Chromium
  render QA (logo + copyright on cover, table-continuation and last pages; no overlap) + live
  fleet E2E via `final apps/GL/tests/sector_book_api_smoke.py`. **User-feedback round same
  day (template-only re-upload):** the Chromium header box carries a ~5.5mm inherent top
  offset — the declared 5mm padding + 15mm logo really ended at 24.9mm and clipped the cover's
  teal band (content top = 24.0mm); fixed to 2mm + 13mm (bottom 20.0mm, 4.1mm clearance).
  **Lesson: calibrate displayHeaderFooter geometry by measuring a rasterized page, not from
  the declared units.** Cover title now one line + a `Sector: …` line under the subtitle (brackets removed per user feedback, template re-upload 2026-09-06)
  (sector filter, pipe-lists → comma-separated, "All Sectors" default).

- **2026-08-30 — BUDGET_UTIL_REGISTER sheet 8 renamed "Fund Movement" + column rework (reporting/db/25 re-seed + render_xlsx.py, user request).**
  ① Sheet title "Additional Fund Transfers" → **"Fund Movement"** (tab = "8. Fund Movement"). ② Columns
  **Project Type / Period From / Period To / Task Name removed** (kept in the inner query — the
  projecttype filter still binds). ③ Columns **re-ordered per the user's layout**: identity
  (Project Number/Name, Task Number, Expenditure Type, Code Combination) → figures (**Amount**,
  Commitment, Total Annual Budget, Project Fund Available, Total Actual) → org (Cost Centre,
  Department, Organization, Sector) → transaction (Transaction Num, Decree No, Transaction
  Date/Year, Business Unit) → statuses (Transaction/Line/Baseline/Journal) → approval (Submitted
  By, **Assignee renamed "Approved By"**, Approval State/Date) → Notes. ④ **Amount = green
  positive / red negative** via a NEW GENERIC `render_xlsx.py` hook: a column alias ending
  **`__pn`** (case-insensitive) gets number format `[Green]#,##0.00;[Red]-#,##0.00;#,##0.00` and
  the suffix stripped from the printed header (`AMOUNT__PN` → "Amount") — opt-in like the ROW_KIND
  magic column, every existing report unaffected; **render_xlsx.py fleet-synced to
  /opt/rpt-worker on vm180-182 + rpt-worker restarted ×3**. Gotcha (again):
  `DCT_RPT_DEFINITION.DESCRIPTION` is VARCHAR2(1000) — ORA-12899 forced a shorter description
  phrase. Deployed via python-oracledb on vm180; live run 802 (year 2026, period 08-2026, DCT
  BU/OPEX, project 4511000346) verified: 8 sheets, exact header order, removed columns absent,
  green/red format on all Amount cells (9 negatives in scope).
- **2026-08-29 — BUDGET_UTIL_REGISTER: NEW sheet 8 "Additional Fund Transfers" (reporting/db/25 re-seed, user request).** The budget transfer transactions from the PBT extract (otbi-atd/db/77: `pa_budget_trx_headers` ⋈ `pa_additional_fund_lines` ⋈ `pa_budget_trx_approvals`) — **Additional Fund type ONLY** (`transaction_type='Additional'`, hard-coded) — one row per transfer LINE: header identity (transaction num, decree no, transaction date, trx year, BU, project type, header status), the full line detail (project/task/etype + names, organization, code combination, **signed Amount** = `additional_amount`, commitment, total annual budget, project fund available, total actual, period from/to, line/baseline/journal statuses, notes) and the approval trail **aggregated per transaction** (first submitter, `LISTAGG DISTINCT` assignees, last state via `KEEP DENSE_RANK LAST`, last action time — `dct_to_local` + `CHR(58)` mask). Sorted **project, task, etype, transaction date** (user spec). Scope: `trx_year = :year` + the run's YTD cut on `transaction_date` via `GL_CTX.BUTIL_END`; filters applied to the line's OWN attributes with segment-resolved Sector/Chapter/Cost-centre (the `V_PA_BUDGET_TRX_LINE` pattern: combination seg 3 else the COST_CENTER label's trailing digits; appropriation = seg 7) — **deliberately NOT the butil scope key join**: 987 of 4,561 live transfer lines have no exact butil line match and an inner scope join would silently drop them. No new params (missing binds resolve to None in datasource.py's `params.get`). Gotcha hit: `DCT_RPT_DEFINITION.DESCRIPTION` is VARCHAR2(1000) — ORA-12899 on a long description edit. Sections 7 → 8; sheet-tab titles truncate at 31 chars incl. the `"8. "` prefix, hence the short title. Deployed via python-oracledb (local wallet). Verified: assembled SQL = 4,561 rows unfiltered / trx 012945 reproduces the source screen byte-exact (−340,440, DCT-FD-3369-2026, submitter/assignee/approval 07:54); live run SUCCESS — 8 sheets, 4,561 sorted rows; scoped run (period 06-2026 + CC 4510210) narrows correctly. Generate-and-Send distributions pick the sheet up automatically (same definition).
- **2026-08-29 — BUDGET_UTIL_REGISTER: costing-adjustment trx moved INTO sheet 2 "AP Invoices - Direct" as (**) rows; sheet 8 REMOVED (reporting/db/25 re-seed, user request).** The separate "Costing Adjustments" worksheet (added 2026-08-27) is gone — the APPROVED transactions now ride the AP register itself as a second UNION ALL leg shaped like an AP row: **Invoice Number prefixed `(**) `** (referenced invoice number → stored snapshot → PCA ref), invoice date/effective supplier from the referenced `ap_invoices`/`dct_ap_supplier_eff_v` headers (both deduped `GROUP BY invoice_id` so the leg can never fan out — GL/db/29 shape), currency AED, amount = the SIGNED adjustment, payment status computed from the header (`Cost Adjustment` when reference-less), plus a trailing **Cost Adjustment Ref** column (NULL on plain AP rows) so (**) rows are filterable without a legend. Scope join on the CORRECTED coding + the `DCT_PA_COST_ADJ_BUTIL_V` BUTIL_END period rule (NULL period counts always); zero-amount (override-only) adjustments excluded — they are budget rows, not AP rows. The shared scope CTE gained `MAX(s.project_name)` (harmless to the other sheets); `l_ap` → VARCHAR2(12000); sections 8 → 7. Deployed via python-oracledb on vm180 (`/tmp/deploy_db25.py`, worker env). Verified: assembled sheet-2 SQL = 5,258 rows / 40 (**) rows / adj total 3,118,877.54 = the live `/gl/butil` `totals.costAdj` exactly; live run 782 SUCCESS — 7 sheets, no Costing Adjustments sheet, AP sheet carries the 40 (**) rows w/ refs PCA-000xx. Generate-and-Send distributions pick this up automatically (same definition). (reporting/db/25, user report: PCA trx invisible on 4511000981).** Sheet 1 now reads the butil view through a nested inline view LEFT-JOINing **`dct_pa_cost_adj_butil_v`** (APPROVED rows at the butil key, BUTIL_END-aware — the register's pre_sql period hook applies for free): `actual_ap`/`actual_total` **+cost_adj**, `annual_budget`/`ytd_budget` **+budget_override**, `fund_available` **+ovr−adj**, `utilization_pct` + the plan-indicator expressions all on the ADJUSTED figures — matching the page's costadj=Y default — plus explicit **Cost Adjustment** and **Budget Override (Adj)** columns. NEW **sheet 8 "Costing Adjustments"** lists the APPROVED transactions in scope (adj_ref, period, butil key, classification, amounts, referenced invoice + original coding, reason, approved by/on — date-only, no `:MI` phantom-bind risk) via the shared scope CTE. `l_bu` bumped to VARCHAR2(12000). **SAME DAY (3): the Briefing Book folds them too (user request)** — l_ov/l_sec/l_prs + the three plan sections now read the butil view through the same nested cost-adj inline view (actual +adj, budgets +override, fund +ovr−adj, utilization + over-budget count + plan indicators all adjusted; document registers untouched). Verified: scoped book run (4511000981/08-2026) prints Actual Total 19,259,354 incl. the 2,368,623 PCA — byte-matching /gl/butil totals. No template change needed. Verified: run scoped to 4511000981/08-2026 shows MICE-Trade Shows-N actual_ap 2,368,623 (= PCA-00018) + the trx on sheet 8.
- **2026-08-27 — Plan-insight indicators in the butil reports (reporting/db/21 + 25 + template, GL v1.88.0 round).** `BUDGET_UTIL_REGISTER` sheet 1 gains **Plan Utilization % / Plan Variance / Plan Status / Plan Coverage % / Plan Coverage Status** (effective plan = revised-when-exists; thresholds read live from the GL module settings `PLAN_EXEC_TOL_LOW/HIGH` + `PLAN_COV_LOW/HIGH` via a CROSS-JOINed aggregate, defaults 90/110/95/105). `BUDGET_UTIL_BOOK` gains **Part 6 "Expenditure Plan Performance"** — new MULTI sections `plan_sector` (plan vs actual + coverage per sector w/ status), `plan_dev` (top-15 absolute deviations among planned lines) and `plan_cov` (kv coverage + verdict-count summary); template adds the Part 6 page (KPI strip, execution + coverage sector bars, 6.1/6.2 tables, methodology note), the TOC row, and renumbers Observations to **Part 7**. **THREE glyph gotchas hit live:** `CHR(9660)` for ▼ emits an invalid UTF-8 byte pair (CHR is byte-based → the datasource dies with UnicodeDecodeError); `UNISTR('\25BC')` cannot ride the MULTI `source_ref` (the backslash is an illegal JSON escape → JSONDecodeError at claim time); bare `NCHR(9660)` in a VARCHAR2 CASE = ORA-12704 charset mismatch — the working form is **`TO_CHAR(NCHR(9660))`**. Deployed via python-oracledb on vm180 + template upload (61,552 bytes) + fleet fallback copies. Verified: register run 771 (4 columns, all 4 statuses incl. glyphs) + book run 767 (124-page PDF, Part 6 renders, Part 7 renumber).
- **2026-08-26 — Expenditure Plan columns in the butil reports (reporting/db/21 + 25 + template).** `BUDGET_UTIL_REGISTER` sheet 1 gains `approved_plan_annual/approved_plan_ytd/revised_plan_annual/revised_plan_ytd` and `BUDGET_UTIL_BOOK` gains the four plan sums in its overview KPIs (+ a "YTD Plan (Approved)" KPI card) and **Annual Plan / YTD Plan** columns in the 1.1 sector table — all from `DCT_PROJECT_CF_BUTIL_V` (db/v2/126, the uploaded `DCT_PROJECT_CASHFLOW` at the butil line grain, BUTIL_END-aware so the existing `pre_sql` period hook gives the YTD cut for free). Join gotcha: the seeds' scope WHERE uses unqualified `budget_year`, so the plan view joins through a RENAMED inline view (py/pp/pt/pe) — a bare join is ORA-00918; and `l_sec`'s plan columns are appended at the END of the select list because its `ORDER BY 3` is positional. Template `budget_util_book.html.j2` re-uploaded (54,776 bytes) + fleet fallback copies synced (no worker restart needed — templates load DB-first per run). Deployed via python-oracledb on vm180; `deploy_seed.py`/`upload_template.py` now live in /opt/rpt-worker (env: `set -a; . /etc/rpt-worker.env` + TNS_ADMIN=/opt/oracle-wallet/Wallet_prod RPT_DB_USER=ADMIN RPT_DB_DSN=prod_low, system python3 — the rpt fleet has NO venv). Verified: run 761 XLSX plan sums reconcile to the hand-summed months (annual 48,349,977.57 / YTD 06-2026 24,104,898); run 762 PDF prints the plan KPI + 1.1 columns.
- **2026-08-22 — Report SQL observability:** each claimed run now sets Oracle session metadata to `DCT_RPT:<report_code>` and `RUN:<run_id>` before executing its live SQL, then clears it in `finally`. This lets Admin SQL Performance attribute background SQL without storing binds or result data, and keeps report workload out of interactive slow-SQL alerts. Fleet rollout: vm180-182.

- **2026-08-12 — BUDGET_UTIL_REGISTER: Organization column (reporting/db/25 re-seed).** Sheets 1–5
  gain **Organization** (the task's raw PPM owning org, new `DCT_BUDGET_UTILIZATION_V.TASK_ORGANIZATION` /
  `dct_butil_scope_v` column) next to Department — Department stays the GL cost-centre segment
  description; the two are different Fusion attributes. `l_bu` adds `task_organization AS organization`;
  `l_dim` adds `MAX(task_organization) AS organization` and the four line sheets select `sc.organization`.
  Sheet 6 (Pending Approval PR-PO) has no butil task dimension — unchanged. BUDGET_UTIL_BOOK (db/21)
  untouched (fixed-layout PDF template). Deployed via python-oracledb on vm180 (MERGE-bearing);
  verified by GL bridge run 403 (org populated on all 5 sheets). Companion change: GL v1.61.0
  page column + `/gl/butil` field (see GL deployment-notes 2026-08-12).
- **2026-08-10 — Worker self-heal on dead DB connection (runner.py fleet-synced vm180-182).**
  ROOT CAUSE of the 2026-08-07→08-10 outage: ADB dropped all three workers' connections on
  2026-08-07 ~16:05 UTC (`DPY-4011`), and the `--forever` loop's `except` handler slept and
  retried **on the same dead connection** every 20s for three days — systemd showed `active`,
  heartbeats went stale, and every new run sat QUEUED (runs 241/242 recovered by manual
  `systemctl restart rpt-worker` ×3). FIX: the loop-error handler now `conn.ping()`s; on a dead
  connection it closes + retries `config.connect()` with backoff (5s→60s), reloads config and
  heartbeats IDLE; after ~10 min of failed reconnects it exits(1) so `Restart=always` brings up
  a fresh process. NOTE: the BI Workers page CANNOT fix this class of hang — its
  PAUSE/RESUME/STOP commands travel through the DB, which a dead-connection worker can't read;
  stale heartbeats on that page ARE the alert. (The ATD worker never needed this: DB errors
  there escape the loop, crash the process, and systemd restarts it.)
- **2026-07-26 — Budget Utilization reports: drop Project Type column + user-requested detail sort orders
  (BUDGET_UTIL_BOOK / BUDGET_UTIL_REGISTER / BUDGET_UTIL_SECTOR).** Register sheet 1 "Budget Utilization
  Lines" lost the redundant **Project Type** column (already in the report scope/filter). Detail-section
  sort orders standardised across all three BU report layouts: BU Lines → `Sector, Chapter, Cost Centre,
  Project, Task, Expenditure`; AP Invoices-Direct → `Project, Task, Expenditure, Invoice Date`; GRN
  Receipts → `Project, Task, Expenditure, PO Number, PO Line`; Open POs → same as GRN; Open PRs →
  `Project, Task, Expenditure, PR Number`; Pending PR/PO (register) → `Doc Type, Document Number, Line`.
  BUDGET_UTIL_SECTOR aligned too (its invoice section already matched; utilization gains Chapter/Cost-Centre
  lead keys since it is single-sector). The book's summary/ranking sections (by_sector, pressure, pending
  aging/approvers) keep their analytical ordering. Source files edited (`reporting/db/08a,21,25`) AND the
  **live `source_ref` deployed via targeted CLOB REPLACE** (per the db/28 pattern — the MERGE-bearing seeds
  are swallowed by Linux SQLcl; every search string verified as exactly 1 occurrence before replacing).
  Verified: all 3 defs still `IS JSON`, 0 old sort strings remain, `project_type` gone from the register,
  every new ORDER BY executes + sorts correctly against the live views. **No template change** (register
  is generic XLSX; the book/sector J2 templates render section columns in SELECT order). Deploy script
  archived in the session scratchpad; re-running the edited seeds reproduces the change.

## Deploy checklist (DB — Phase 0 control plane)
1. Files ship **CRLF + UTF-8 (no BOM)** (SQLcl silently skips LF-only files). Normalize if edited.
2. Launch SQLcl with `JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8` so the Arabic lookup seeds store cleanly.
3. FRESH `sql -name prod_mcp` session — must **not** follow `ALTER SESSION SET CURRENT_SCHEMA=PROD`
   (ORDS/synonym scripts self-reference → ORA-01471).
4. Run in order: `@install.sql` (01 DDL → 02 lookups → 03 pkg → 04 ORDS → 05 scheduler → 07 seed).
5. `EXEC prod.dct_rpt_sched_sync;` to (re)build schedule jobs from `DCT_RPT_SCHEDULE` (none enabled by default).
6. Verify: all `DCT_RPT*` objects VALID; `rpt.rest` module PUBLISHED; lookups/config seeded.

## Objects created
- Tables: `DCT_RPT_DEFINITION` `DCT_RPT_SCHEDULE` `DCT_RPT_RECIPIENT` `DCT_RPT_RUN` `DCT_RPT_OUTPUT`
  `DCT_RPT_DELIVERY` `DCT_RPT_CONFIG` (+ ADMIN synonyms).
- Types: `RPT_RECIPIENT_ROW` / `RPT_RECIPIENT_TAB` (pipelined recipient resolution).
- Package: `DCT_RPT_PKG` (cfg / enqueue / claim_next / mark_status / record_output / record_delivery /
  resolve_recipients / reclaim_stuck).
- Procedures: `DCT_RPT_RUN_SCHEDULE`, `DCT_RPT_SCHED_SYNC`, `DCT_RPT_MAINT`.
- Jobs: `DCT_RPT_MAINT_JOB` (every 15 min — reclaim stuck runs + purge expired output BLOBs);
  `DCT_RPT_SCH_<id>` per enabled schedule (built by sched_sync).
- ORDS: module `rpt.rest` at `/ords/admin/rpt/` (SYS_ADMIN-only).

## Gotchas discovered
- **Output BLOBs** are stored directly in `DCT_RPT_OUTPUT.file_blob` (not `DCT_DOCUMENTS`) — self-contained,
  retention-controlled via `DCT_RPT_CONFIG.OUTPUT_RETAIN_DAYS` + `DCT_RPT_MAINT`.
- **ORA-00932 (CLOB vs CHAR)** in a `CASE` that mixed a `VARCHAR2` literal with the CLOB `error_msg`
  column — wrap the literal branch in `TO_CLOB(...)` (fixed in `reclaim_stuck`).
- **ORA-02303** on re-running `CREATE OR REPLACE TYPE` (the table type/package depend on the object type)
  — the row/table types are created **guarded** (`EXECUTE IMMEDIATE 'CREATE TYPE…'` swallowing ORA-00955)
  so re-installs are clean. To change a type's shape, drop dependents first.
- **Transient first-DDL hiccup:** on a brand-new schema the very first `CREATE TABLE` (DEFINITION) once
  failed transiently, cascading FK failures to SCHEDULE/RECIPIENT. The scripts are idempotent — simply
  re-run `@install.sql`; the guards skip existing objects and create the missing ones.
- **SMTP password** never lives in `DCT_RPT_CONFIG` (UI-editable, `is_secret` masks values on GET) —
  it stays in the Python runner's `env.ps1` / secret store.

## Python runner (Phase 1)
- Code in `reporting/runner/` (mirrors `otbi-atd/runner/`): `config.py` (oracledb thin + wallet, reuses
  `ATD_DB_*`/`TNS_ADMIN`, `RPT_DB_*` overrides; reads `DCT_RPT_CONFIG`), `datasource.py` (runs the
  definition's SQL/VIEW, binds only `:params` present), `render_pdf.py` (Jinja2 `templates/report.html.j2`
  → Chromium `page.pdf()`; WeasyPrint alt), `render_xlsx.py` (openpyxl), `deliver.py` (smtplib + per-recipient
  `DCT_RPT_DELIVERY`), `runner.py` (claim→render→archive→email→mark; `--once/--forever/--run/--reclaim`),
  `notify.py` (ops alerts).
- Setup: `python -m venv .venv`; `pip install -r requirements.txt`; `python -m playwright install chromium`;
  copy `env.ps1.example`→`env.ps1` (DB + `RPT_SMTP_PASSWORD`). Schedule `run_reporting.ps1` (own
  `.rpt_runner.lock`; the render Chromium is independent of the OTBI Fusion session).
- Test: `python -m pytest tests -q` (render layer, no DB). Ad-hoc: `python runner.py --run <code> [--period MM-YYYY]`.
- Runner connects as **ADMIN** (env.ps1) and calls `prod.dct_rpt_pkg.*`; output BLOBs via `conn.createlob`.
- Gotcha: oracledb thin connect from the workstation occasionally hangs — re-run; verify run state via SQLcl.

## Frontend — "BI - Reporting" app (Phase 2)
- New JET module app `final apps/BI/Jet/` (App 211, brand #1F6F8B, SYS_ADMIN-gated), built on the shared
  platform/shell. Views: dashboard, reports (definition CRUD + run-now), reportDetail (schedules +
  recipients CRUD + sync), runs (history), runDetail (download PDF/XLSX + deliveries + retry), settings
  (SMTP/runtime config editor), login. Service layer `js/services/{config,api,authService,rptService}.js`.
- **Shared changes (require APP_VERSION bump in ALL apps on next deploy):** added the `bi` entry to
  `final apps/shared/js/shell.js` MODULES and `mod.bi`/`mod.bi.desc` to `shared/i18n/common.{en,ar}.json`.
  The dev-proxy auto-derives the new app (any `final apps/<X>/Jet/` folder), so every proxy serves `/BI/Jet/`.
- Run locally: `cd "final apps/BI/Jet" && python dev-proxy.py <port>` then quick-login via Admin to seed the
  shared session. **Port gotcha:** stray `python` http servers can squat a port (Windows SO_REUSEADDR lets
  two bind the same port and the older one answers) — verify the served `/index.html` actually contains
  "BI - Reporting" before testing.
- Browser smoke test (Playwright) **16/16 PASS** with live `/rpt` data (dashboard KPIs + run #2, reports
  list, report detail schedules/recipients, run history, run detail PDF 826.9 KB + XLSX 190.4 KB, settings).
  One non-fatal 401 on `/dct/settings/` from the shared region-theme init (falls back to platform default).

## NATIVE engine (Phase 3 — Solution 1, in-DB)
- `reporting/db/06_rpt_native_pkg.sql` — `DCT_RPT_NATIVE_PKG`: NATIVE-engine runs are enqueued exactly like
  PYTHON ones; the **`DCT_RPT_NATIVE_JOB`** sweep (every 5 min) claims `engine='NATIVE'` QUEUED runs
  (SKIP LOCKED) and processes them in-DB via `APEX_DATA_EXPORT.EXPORT` (PDF+XLSX) → `DCT_RPT_OUTPUT`, then
  `APEX_MAIL` (gated by `EMAIL_ENABLED`) → `DCT_RPT_DELIVERY`. Same control plane / run-log / UI as Python.
  Pilot `GL_BUDGET_ACTUAL_NATIVE` (self-contained SQL, no binds). Verified: SUCCESS, 3313 rows, PDF 763 KB
  (`%PDF-`) + XLSX 148 KB (`PK`).
- **APEX context gotcha:** `APEX_EXEC`/`APEX_DATA_EXPORT`/`APEX_MAIL` need a real APEX session from a
  background job — `set_security_group_id` alone gives **ORA-20987**. Fix = `apex_session.create_session
  (p_app_id=>200, p_page_id=>1, p_username=>'ADMIN')` (in `set_apex_context`).
- **Brand look & feel:** `apex_data_export.get_print_config(p_header_bg_color=>'#1F6F8B',
  p_header_font_color=>'#FFFFFF', p_header_font_weight=>'bold', p_border_color=>'#D9D9D9')` → matches the
  BI app + Python engine. (`p_report_colour` does NOT exist on this APEX 24.2 / `WWV_FLOW_DATA_EXPORT_API`.)
- **NATIVE source SQL must be self-contained (no `:binds`)** — binds are a Python-engine convenience.
- **Install gotcha:** SQLcl swallows the package SPEC on `06`'s keyword-heavy banner (body then goes INVALID
  "cannot compile body without its specification"). Re-run `06` (idempotent) or create the spec standalone
  first, then `ALTER PACKAGE prod.dct_rpt_native_pkg COMPILE BODY`. Also: a trailing `--` on a SQLcl `PROMPT`
  line merges the next statement — keep `PROMPT` lines dash-free.

## History
- **2026-07-30 (3) — Sector / Cost Centre / Department on the butil register line sheets
  (`reporting/db/25` re-seed).** Sheets 2 AP Invoices - Direct / 3 GRN Receipts / 4 Open Purchase
  Orders / 5 Open Requisitions now open with **Sector, Cost Centre, Department** — a shared
  `l_dim` LEFT JOIN to a deduped `dct_butil_scope_v` lookup on the butil key (budget_year +
  project + task + etype; the scope view is exactly one row per key, so the join cannot fan out —
  same dimension source as sheet 1). E2E run 190 (year 2026, DCT OPEX): all four sheets carry the
  columns 100% filled (3,219 / 2,503 / 1,040 / 1,247 rows), row counts unchanged.
- **2026-07-29 (2) — EBS Account column in the butil register + NEW EBS_GL_BALANCE_REGISTER
  (`reporting/db/25` re-seed + NEW `reporting/db/30`).** BUDGET_UTIL_REGISTER sheet 1 gains
  **Ebs Account** right after Account Number — slash-joined `LISTAGG` over the active ACCOUNT rows
  of `DCT_GL_EBS_MAP` (db/v2/110; 11 Fusion accounts consolidate 2 EBS accounts). NEW
  **EBS_GL_BALANCE_REGISTER** (MULTI/PYTHON, XLSX-only): sheet 1 = every legacy EBS balance line
  translated to Fusion dims via `DCT_EBS_BALANCE_MAPPED_V` (PTD + running YTD per combination;
  params year req / period / account EBS-or-Fusion / chapter / search), sheet 2 = Unmapped
  Coverage annex (EBS accounts + Future1 values with no active mapping). Own authored
  param_spec_json (year LOV over the loaded balance years). Run from the GL Legacy (EBS) page via
  the GL/db/16 bridge. Deployed via python-oracledb; E2E runs 179 (butil register — 1,373/1,373
  lines carry the EBS account, 424521→421100) + 180 (EBS register on synthetic 2025 rows —
  203276→213276 translated, unmapped values in the annex).
- **2026-07-29 — Appropriation, DCT Program, Budget Combination + Account Number columns in the
  butil register (`reporting/db/25` re-seeded twice).** BUDGET_UTIL_REGISTER sheet 1 "Budget
  Utilization Lines" gains: **Budget Combination** in column A (the line's natural key
  `project.task.expenditure-type` — unique per row, the analysts' VLOOKUP key against their manual
  FBP sheets), **Appropriation Code / Appropriation Name / Dct Program Code / Dct Program Name**
  after Chapter, and **Account Number** between Task Number and Expenditure Type (the code part of
  the view's `GL_ACCOUNT` — COA row txns first, else the etype numeric prefix). The butil view
  ships `gl_account`/`appropriation`/`program` as combined `'CODE - Description'` strings, so the
  section SQL splits on the FIRST `' - '` (INSTR/SUBSTR; description absent → code only, name
  NULL). Deployed via python-oracledb from the dev VM; E2E runs 174/175 (year=2026,
  period=03-2026, DCT OPEX): 24-col sheet, account e.g. `424521`.
  **Same day (user clarification): Budget Combination = the FULL 10-segment GL combination**, not
  the project.task.etype key — NEW view column `DCT_BUDGET_UTILIZATION_V.BUDGET_COMBINATION`
  (db/v2/37 re-run, additive LAST column): canonical Fusion order
  `entity.program.cc.bg.account.es.appr.ic.f1.f2` constructed the way Fusion derives project
  charge accounts — entity `451` + task PROGRAM/COST_CENTER/ENTITY_SPECIFIC/APPROPRIATION (tsk_seg
  CTE gained `entity_specific_code` LPAD 7) + budget group `1` + account (COA row txns → etype
  prefix) + constant tail `000.000000.000000`; falls back to an actual posted combination
  (`MAX(k.cc_string)`) when task segments are missing. Validated: 97.7% of constructible lines
  exist verbatim in `dct_gl_coa_snap`; register col A now reads the view column. E2E run 176:
  1,370/1,373 lines filled, e.g. `451.070101.4510195.1.422401.4510600.200104.000.000000.000000`.
- **2026-07-21 — Annual + YTD Budget in the butil reports.** Follow-through of the GL v1.37.0
  period-aware budget: **BUDGET_UTIL_BOOK** overview + utilization-by-sector sections now also
  select `SUM(budget_annual)` (the view's `budget` stays the period-aware YTD figure the book's
  `pre_sql` already produces), and the DB template `budget_util_book.html.j2` shows it — KPI card
  label flips to "YTD Budget" when a period is passed (sub-line carries the Annual figure when it
  differs) and the 1.1 sector table gains an **Annual Budget** column next to the (YTD) Budget one.
  **BUDGET_UTIL_REGISTER** sheet 1 emits `annual_budget` + `ytd_budget` (ordered by annual).
  Deployed the two definition blocks via python-oracledb from the dev VM (Linux SQLcl still
  swallows these MERGE-bearing seeds) + template upsert; includes the user's TO_CHAR wraps on
  PO/PR doc-number columns (Jinja `truncate`-on-NUMBER guard). Verified E2E via the GL bridges
  with period=03-2026: register sheet shows both columns (annual ≠ ytd), book renders the new
  KPI + table column.

- **2026-07-18 — `bu` (Business Unit) param on BUDGET_UTIL_BOOK + BUDGET_UTIL_REGISTER (`reporting/db/21`
  + `25` re-seeded).** Same exact any-of semantics as the pending pair, but bound in `l_bscope`/`l_scope`
  (project-attribution BU via the butil/scope views, which gained `business_unit` in db/v2/37+39) so ALL
  sections of a workbook/book — including 21's Part 5 pending sections via `l_scope` — cut consistently.
  BUDGET_UTIL_BOOK's authored param_spec gains the `bu` entry (LOV over `dct_butil_scope_v`); 25 inherits
  it by copy. Cover chip added to `budget_util_book.html.j2`. Deployed via vm180 python-oracledb;
  E2E runs 109 (bu=DCT → 9,530 rows) / 110 (bogus → 0 rows).
- **2026-07-18 — PowerPoint (PPTX): a NEW output format for the platform + BUDGET_UTIL_BOOK deck.** `reporting/runner/render_pptx.py` (python-pptx) builds an executive 16:9 slide deck from the SAME MULTI sections the Briefing Book renders (overview/by_sector/pressure/ap_lines/grn_lines/open_po/open_pr) — cover · KPI overview · utilization-by-sector chart+table · budget-composition doughnut · lines under pressure · actuals & top-suppliers · open obligations/commitments · observations & insights · methodology; native editable PPTX tables + charts, same computed insights as the PDF so figures match. `runner.py` gains a `PPTX` format branch (built only for MULTI runs, from `sections`); enqueue any MULTI report with `p_formats='PPTX'` to get a deck. **`reporting/db/26` (+ db/02 source) registers `PPTX` in the `RPT_FORMAT` lookup** — WITHOUT it `dct_rpt_pkg.record_output` raises ORA-20090 (it `validate_lookup`s the format). python-pptx added to the fleet (vm180-182 pip) + `runner/deploy_worker.sh`. First consumer: the GL Budget Utilization page's **Generate Report → PowerPoint** (bridge `POST /gl/butil/ppt` enqueues BUDGET_UTIL_BOOK formats=PPTX; GL/db/11). Verified: local 8-slide deck (visual QA) + fleet E2E run 101 SUCCESS + HTTP bridge run 102 (valid 64 KB .pptx). No server-side LibreOffice needed — the .pptx is delivered as-is; opens in PowerPoint. db/26 deployed via python-oracledb on vm180 (MERGE-bearing).
- **2026-07-17 — `bu` (Business Unit) param on ENC_PENDING_BOOK + ENC_PENDING_REGISTER (`reporting/db/23`
  + `24` re-seeded).** Pipe-delimited EXACT any-of list of Fusion BU names
  (`([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|','|'||x.business_unit||'|') > 0)`): the book adds it
  to all 4 scoped sections AND the extract-coverage annex (`enc_pending_book.html.j2` cover gains a
  Business-unit chip, pipes shown as commas); the register adds it to both sheets. `params_json` +
  `param_spec_json` gain `bu` (spec via JSON_MERGEPATCH — the book's spec is no longer a straight copy
  of BUDGET_UTIL_BOOK's). Fed by the GL pending page's new BU multi-select through the GL/db/13 bridges.
  The pending snapshot is the platform's ONLY cross-BU source (OTBI extracts are DCT-scoped), so
  BUDGET_UTIL_BOOK/REGISTER did NOT get the param — their butil/AP/GRN/PR/PO sections have no usable BU
  column (and BUDGET_UTIL_BOOK's Part 5 pending sections follow the butil page scope, which has no BU
  filter). Deployed via vm180 python-oracledb (deploy_seed.py); template upserted to DCT_RPT_TEMPLATE +
  bundled copies synced to vm181/182. E2E runs 89/90/91 (bu=MSS|AFH → 0 register rows + 303-doc annex;
  bu=DCT → 990 + 14; book cover chip renders).
- **2026-07-14 — BUDGET_UTIL_BOOK mirrors the FULL GL butil page filter set + MULTI `pre_sql`/`post_sql` hooks.**
  Review: launching the book from the GL page ignored most page parameters. The definition now
  takes all 9 page filters (`year` req; `period` YTD MM-YYYY, `sector`, `chapter`, `projecttype`,
  `costcenter`, `project`, `task`, `etype`, `search`) with the page handler's verbatim predicate
  semantics; line sections join `dct_butil_scope_v` on the FULL fact key (project+task+etype;
  scope view gained `chapter`+`expenditure_type`, db/v2/39). **Engine feature:** MULTI `source_ref`
  may now carry `pre_sql`/`post_sql` PL/SQL blocks (bind-filtered like sections; post ALWAYS runs,
  finally) — the book uses them to set/clear `GL_CTX.BUTIL_END` for the YTD period, and the 39
  AP/PO/PR line views honour that context with 37's exact date bases. GRN register rebased to the
  page's receipt-date year basis (was PO budget-date year). **Fan-out fix:** de-duped the ATD
  `po_headers`/`po_lines` attribute joins in 39+21 — duplicate rows (76 po_lines keys) were
  multiplying register amounts (GRN +35.5M / PO +59M platform-wide, silently, since the book
  shipped). Reconcile suite 20/20 PASS (every register Σ = its Part-1 KPI to the fils, 5 combos
  incl. periods); bridge E2E run 67 = page-parity on all KPI tiles. Deploys: 39+21 python-oracledb
  on vm180; `runner/datasource.py` scp'd to vm180-182 + `systemctl restart rpt-worker`; template
  re-upload via `upload_template.py --ords`. Param-spec drawer in BI picks the new params up
  automatically (chapter/etype LOVs from the scope view).
- **2026-07-14 — Briefing Book refinements (review comments) + GL-app launch.** (1) **Zero-amount
  rows excluded from all registers** — seed `21` adds `ABS(NVL(amount,0)) > 0.005` to the AP and PR
  sections (GRN/PO already filtered in their sources); redeployed via the vm180 python-oracledb
  executor; all-org 2026 run went 8,661 → 8,655 lines. (2) **Insights page reworked for
  executives**: no technical/database names anywhere (methodology now reads "the i-Finance
  budget-utilization reporting layer"), and figures carry **verdict colours** — green `.i-good` /
  red `.i-bad` on pacing vs calendar, over-budget line count, tightest remaining funds, supplier
  concentration (>50% top-supplier = red, ≤30% = green), aged open POs (pre-budget-year = red) and
  sizeable uninvoiced deliveries (>2% of budget = red). (3) **Timestamps carry the timezone** —
  "GST (UTC+04:00), Asia/Dubai" on cover/contents/insights. (4) **GL-app launch**: the book is now
  runnable from GL → Budget Utilization (GL v1.21.0 + `GL/db/11` bridge — see the GL
  deployment-notes entry). Template round-tripped via `upload_template.py --ords` each time — no
  worker redeploys.
- **2026-07-08 — Budget Utilization Briefing Book (`BUDGET_UTIL_BOOK`, `reporting/db/21` + template
  `budget_util_book.html.j2`) DEPLOYED + E2E PASS.** Second MULTI/PYTHON report over the GL
  utilization layer, rendered as an executive **briefing book**: cover page (scope chips +
  "Prepared by Financial Planning and Budgeting — Finance Department") → contents → Part 1
  overview (7 KPI tiles, budget-composition stacked bar, top-sectors + utilization-by-sector bar
  charts, sector rollup table w/ totals, top-15 budget-pressure lines) → Part 2 actuals (monthly
  AP-vs-GRN column chart + top-10 supplier bars + FULL registers: direct AP invoices, all GRN
  receipts) → Part 3 open obligations (top-supplier/largest-line bars + GRN-netted PO register) →
  Part 4 open commitments (reserved PR register) → Part 5 auto-computed observations (pacing vs
  calendar, pressure, supplier concentration, delivery pipeline incl. oldest open PO, uninvoiced
  deliveries) + methodology box. 7 sections: overview/by_sector/pressure from
  `dct_budget_utilization_v`; ap_lines from `dct_unpaid_invoices_v` (has_po='N' = the Actual-AP
  register, ALL payment statuses); **grn_lines inlined** (db/v2/39's `dct_uninvoiced_grn_v` keeps
  only uninvoiced>0 rows — the book lists every receipt, so the seed carries the receipts query
  with an AP-invoiced-per-distribution join); open_po/open_pr from the 39 views. Params: `year`
  REQUIRED, `sector`/`projecttype`/`costcenter` optional (all-org when empty; spec seeded with
  LOVs from `dct_butil_scope_v`, sector marked optional unlike BUDGET_UTIL_SECTOR). PDF-only
  definition; charts are **pure CSS/HTML** (no Chart.js/CDN — deterministic in Chromium print).
  **Deploy path (Linux):** 21 is MERGE-bearing → executed via python-oracledb ON vm180 (generic
  chunk-executor splitting PL/SQL on lone `/`; scratchpad deploy_21.py pattern), then template
  uploaded with `upload_template.py --ords`; template fixes round-trip through the DB with **no
  worker redeploy** (proved live: first run FAILED in-template, re-upload, next run green).
  **Template gotchas:** (1) Jinja `truncate` on numeric columns (PR numbers are NUMBER) raises
  `TypeError: object of type 'int' has no len()` — always `|string|truncate(n)`; (2) a
  full-bleed cover must stay ≤ ~172mm tall on A4-landscape or an absolute-positioned bottom band
  spills onto a blank page 2. E2E: year=2026 all-sectors → run 62 SUCCESS on vm182, **273-page
  3.0 MB PDF, 8,661 detail lines**, cover/contents/KPIs/charts/registers/insights all verified
  from page rasters; BI Run-Parameters drawer LOVs verified via `/reports/BUDGET_UTIL_BOOK/params`
  (year required + 11 sectors / 2 types / 51 cost centres). Also re-uploaded
  `budget_util_sector.html.j2` after removing stray committed keyboard-garbage in its CSS
  (`}Y!M(h-exYeR...` — shipped 2026-07-06, harmless but could void the `.params b` rule).
- **2026-07-07 — Word (.docx) report templates, GUI-manageable (`reporting/db/20` + `20a`; BI APP_VERSION
  1.9.3→**1.10.0**; plan `docs/DOCX_TEMPLATES_PLAN.md`).** Report PDF layouts are now **DB-stored and
  UI-managed** — no worker redeploy to change a layout. **DB (20, DEPLOYED):** `DCT_RPT_TEMPLATE`
  (template_name PK ending `.docx`/`.j2`, content BLOB) + ADMIN synonym + `TEMPLATE_MAX_MB` config (10).
  **ORDS (20a, DEPLOYED, ADDITIVE):** `GET templates/` (list + `usedBy` count) · `GET/PUT/DELETE
  templates/:name` — PUT is raw-binary (`l_blob := :body` once; 413 over limit; 400 bad extension),
  DELETE 409s while referenced; **canonical post-04 re-run list is now 08b, 09a, 10, 12b, 19, 20a**
  (script numbers 19/19a were taken same-day by the test-email entry below → renumbered 20/20a).
  API pytest 12/12 (`reporting/tests/test_templates_api.py`). **Runner:** new `render_docx.py` —
  `.docx` templates render via **docxtpl** with the same Jinja2 context (+ NEW `data` = rows as
  lower-case-keyed dicts, also per MULTI section) and convert via **headless LibreOffice**
  (per-call `-env:UserInstallation` temp profile → concurrent-safe; page size/orientation come from
  the Word doc, killing the single-source-always-portrait limit); `.j2` templates now load
  **DB-first** with bundled-file fallback (`render_pdf.render_html(source=)`). Unit tests 4/4 incl.
  a real LibreOffice conversion; legacy render tests still 8/8. Templates seeded to PROD via
  `runner/upload_template.py --seed --ords` (report.html.j2, budget_util_sector.html.j2, generated
  `report_starter.docx`). **docxtpl gotcha (cost an hour):** each `{%tr%}` loop tag needs its OWN
  table row and each `{%tc%}` tag its OWN cell — the tag's row/cell is consumed and the middle
  cell repeats; putting for/endfor + content in one cell silently drops the opener → "unknown tag
  'endfor'". **BI app (1.10.0):** new SYS_ADMIN **Templates** page (list w/ kind badge + usedBy,
  raw-binary Upload/Replace via `shared/docUpload.choose`, Download, guarded Delete, Authoring-guide
  drawer w/ starter download); Reports editor gains a **PDF template dropdown** for PYTHON
  definitions (blank = `report.html.j2`). Browser smoke **13/13 PASS**. **Worker rollout:**
  `deploy_worker.sh` now installs `docxtpl` + `libreoffice-writer` + Noto Arabic fonts (Arabic PDFs
  render as boxes without them). **Fleet rollout DONE 2026-07-08** (light update — code scp +
  docxtpl 0.20.2 + libreoffice-writer + Noto Arabic fonts + `systemctl restart rpt-worker`;
  `/etc/rpt-worker.env` untouched; all 3 workers active). **E2E on the fleet PASS:** 20-row docx
  run → SUCCESS in seconds (valid branded PDF from the DB-stored starter template, vm182);
  3,326-row GL_BUDGET_ACTUAL with `report_starter.docx` → **SUCCESS in ~4 min** (1.0 MB PDF, vm180)
  after the first attempt hit the 180s soffice timeout — LibreOffice **table layout is slow on
  huge tables**, so the conversion timeout is now config-driven: **`DOCX_PDF_TIMEOUT_SEC`**
  (seeded 480, editable in BI Settings; added to `20_rpt_templates.sql`). Guidance: Word templates
  suit executive-size row counts; keep very large tabular reports on `.j2` (Chromium paginates
  thousands of rows without breaking a sweat). Default-`.j2` regression run after revert: SUCCESS.
- **2026-07-07 — In-DB email channel FIXED: gmail SMTP never worked on ADB → OCI Email Delivery (`reporting/db/17_smtp_acl_fix.sql` diagnostic + `18_oci_email_delivery.sql`).** After the web-tier deploy the BI "Send Test Email" returned ok (mailId) but nothing arrived. Diagnosis (17): the endpoint enqueues via APEX_MAIL, but messages sat in `apex_mail_queue` with `mail_send_count=0` and NO `mail_send_error`, while `ORACLE_APEX_MAIL_QUEUE` "SUCCEEDED" every 5 min and `apex_mail_log` was EMPTY — the in-DB channel had **never** delivered (the 2026-07-06 "both channels verified" entry below is **wrong** for Channel 2; only the Python/VM channel was really verified). Root cause chain: `dba_host_aces` had no entry for `smtp.gmail.com` (16's ACL block silently failed — its EXCEPTION handler swallows errors), `UTL_SMTP` → `ORA-24247`; and the ACL can't even be created — **ADB network policy hard-blocks outbound SMTP to non-OCI endpoints (`ORA-24244` on APPEND_HOST_ACE for smtp.gmail.com:587)**, so gmail-direct from the DB is impossible, ever. Fix (18): OCI Console → IAM user SMTP credentials + Email Delivery Approved Sender `hany.uipath@gmail.com` (pilot; prod sender on `dctabudhabi.ae` needs IT to add OCI SPF/DKIM or the org gateway itself will reject the spoofed From) → ACL to `smtp.email.me-abudhabi-1.oci.oraclecloud.com:587` for ADMIN **and APEX_240200** (the mail-queue job runs as the APEX engine schema) + APEX instance params re-pointed at the OCI endpoint (long `ocid1.user…@ocid1.tenancy…` SMTP username; password via `ACCEPT … HIDE`). **Python channel untouched** — do NOT edit the `SMTP_*` rows in `DCT_RPT_CONFIG` for this (those drive the VM runner, which keeps gmail smtplib + `env.ps1`). Where to look next time: `apex_mail_queue.mail_send_error`, `all_scheduler_job_run_details` for `ORACLE_APEX_MAIL_QUEUE`, `apex_mail_log` (delivered), `DCT_RPT_DELIVERY` (report runs); nginx logs only prove the POST reached ORDS — the web tier plays no part in sending. **Follow-up same day:** after 18, `apex_mail_queue` drained and `apex_mail_log` showed all 5 mails accepted by the OCI endpoint — but nothing arrived (spam + OCI Suppressions both clean; OCI outbound-relay logging not enabled, so the loss is invisible). Rather than debug OCI blind, **`19_rpt_test_email_python.sql` re-points `POST config/test-email` at the VERIFIED Python worker channel**: seeds a one-row `EMAIL_TEST` definition (engine PYTHON, SQL source, XLSX) + an EMAIL recipient the handler upserts to the requested address, then `dct_rpt_pkg.enqueue` — the test button now exercises the exact path scheduled reports use (worker claims → renders → smtplib gmail → `DCT_RPT_DELIVERY`). Guard: 400 when `EMAIL_ENABLED='N'`. Requires a live worker (BI Workers page). BI frontend: success banner shows run id + points at Run History; `set.testHint` EN/AR rewritten; APP_VERSION 1.9.2→**1.9.3**. `11` is SUPERSEDED — never re-run it (restores the dead APEX_MAIL handler); **canonical post-04 re-run list is now 08b, 09a, 10, 12b, 19**. In-DB APEX_MAIL remains available for the NATIVE engine but is UNVERIFIED end-to-end; revisit with OCI outbound-relay logs enabled or once IT provides an SPF/DKIM sender. **19 deployed to PROD same day + smoked:** definition/recipient/handler verified in the dictionary; smoke run 41 was claimed by `vm180/py957` in seconds but FAILED `DPY-4008: no bind placeholder named :ss` — the runner's bind extractor treats `:MI`/`:SS` inside a `TO_CHAR` format **string literal** as phantom binds (same class as the IR pkg phantom-`'HH24:MI'` gotcha; the Python runner has no literal scrub) → **EMAIL_TEST source SQL must stay colon-free** (uses `'YYYY-MM-DD HH24.MI.SS'`; 19 updated in-repo + in-DB). Smoke run 42 = render **SUCCESS** (1 row, `vm182/py964`) but delivery FAILED **gmail `530 5.7.0 Authentication Required`** → root cause: `deploy_worker.sh` only ever wrote `RPT_DB_PASSWORD`/`RPT_WALLET_PASSWORD` to `/etc/rpt-worker.env` — **`RPT_SMTP_PASSWORD` never reached vm180-182** (the 2026-07-06 "Channel 1 verified" was the Windows runner with `env.ps1`). deploy_worker.sh now includes `RPT_SMTP_PASSWORD=${RPT_SMTP_PASSWORD:-}`; on the existing workers append `RPT_SMTP_PASSWORD=<gmail app pwd>` to `/etc/rpt-worker.env` (600) + `systemctl restart rpt-worker` on each VM — **DONE 2026-07-07 on all three (atd-vm180/181/182, via sshpass from the dev-vm; root pw = the fleet kickstart rootpw), smoke run 51 = render SUCCESS + delivery SENT, message received. Email channel VERIFIED end-to-end for the first time.** Delivery outcome per recipient (incl. the real SMTP error text) is in `DCT_RPT_DELIVERY` / the BI run-detail page — this is now the email log that actually answers "why didn't it arrive".
- **2026-07-06 — Email pilot LIVE, both channels verified (`reporting/db/16_apex_instance_mail.sql`).** Gmail app-password pilot (`hany.uipath@gmail.com`) now delivers on **both** paths. **Channel 1 — Python runner (smtplib STARTTLS, `smtp.gmail.com:587`, password in `env.ps1`):** verified end-to-end (test messages delivered to an external inbox). **Channel 2 — in-DB APEX_MAIL (BI "Send Test Email" button + NATIVE engine):** enabled by setting the **APEX instance** SMTP params — `SMTP_HOST_ADDRESS=smtp.gmail.com`, `SMTP_HOST_PORT=587`, `SMTP_USERNAME`/`SMTP_FROM=hany.uipath@gmail.com`, `SMTP_TLS_MODE=STARTTLS`, `SMTP_PASSWORD=<app pwd>` — via `16_apex_instance_mail.sql` (run by a human in SQLcl; **`ACCEPT … HIDE`** prompts for the password so it never lands on disk). BI Send Test Email confirmed working after the params were set. **ADB note:** APEX_MAIL egress works **without** a manual `DBMS_NETWORK_ACL_ADMIN` ACL on this Autonomous DB — the script's ACL block is belt-and-suspenders (its `EXCEPTION` handler makes a missing/failed ACL non-fatal). Script gotchas: run the `@file` arg **quoted** in PowerShell (`sql -name prod_mcp "@16_apex_instance_mail.sql"`) or `@` is parsed as the splat operator; and the ACL uses `xs$name_list(...)` (a `$`-name that a double-quoted PowerShell here-doc will silently eat → `PLS-00201 identifier 'XS'`). SMTP **password** stays out of git/`DCT_RPT_CONFIG` — Python side in `env.ps1`, DB side in encrypted APEX instance config only.
- **2026-07-06 — "Send Test Email" (BI Settings; new `reporting/db/11_rpt_test_email.sql`, BI APP_VERSION 1.8.1→1.9.0).** New additive endpoint `POST /rpt/config/test-email {to}` (SYS_ADMIN) sends a small branded test message via **APEX_MAIL** (in-DB path) and returns the mail id or the SMTP error. BI Settings gained a **Send Test Email** card (recipient pre-filled from `SMTP_FROM`, result banner + toast). `11` is additive (deft/defh, no module rebuild) — **re-run after any `04_rpt_ords.sql` re-run**. E2E PASS (card renders, endpoint responds; returns `ORA-20001 SMTP_HOST_ADDRESS instance parameter must be set` until the APEX instance mail is configured). **To deliver via Gmail** (in-DB path) set the APEX instance email + a network ACL as ADMIN: `APEX_INSTANCE_ADMIN.SET_PARAMETER('SMTP_HOST_ADDRESS','smtp.gmail.com' / 'SMTP_HOST_PORT','587' / 'SMTP_USERNAME',<gmail> / 'SMTP_PASSWORD',<valid app pwd> / 'SMTP_TLS_MODE','STARTTLS')` + a `DBMS_NETWORK_ACL_ADMIN` ACL to `smtp.gmail.com:587`. (The Python engine's own email path stays independent — password in `env.ps1`.) Deploy gotcha: `11`'s `DEFINE_HANDLER` was slow (>90s ORDS metadata op) — run it backgrounded or via a runner-with-`EXIT`, not a 90s-capped foreground call.
- **2026-07-03 — IR round 5b: calc editor converted to a wide drawer (BI APP_VERSION 1.8.1) —
  E2E 17/17.** The calculated-column editor is no longer a centred `.modal-box` — it is the shared
  right-edge **`<edit-drawer>`** at **760px** (matches the platform's record-editor pattern; Save/
  Cancel in the themed header). The component itself now `define`s `'shared/editDrawer'` (guarded
  self-registration) so consuming apps don't need it in their boot list. Gotchas worth keeping:
  inside `<edit-drawer>` body markup, **`$component` resolves to the DRAWER VM**, not the host —
  in nested `foreach` blocks reference the host via `$parent`; and a positioning wrapper around a
  `.form-control` breaks `.form-group`'s flex stretch (the control has no width rule) — the wrapped
  textarea needs an explicit `width: 100%` (`.ir-calc-exprwrap .form-control`). Esc interplay
  verified: autocomplete open → dropdown only (textarea handler stops propagation before the
  drawer's own Esc listener); otherwise the drawer closes. Also: typing a column name now clears a
  lingering "give the column a name" validation error. Shared change ⇒ all 10 apps bumped (BI 1.8.1).
- **2026-07-03 — IR round 5: formula autocomplete + insert chips + label aliases (BI APP_VERSION
  1.8.0) — E2E 13/13.** Frontend-only (shared component; no DB change). Root cause of the user
  report ("`Budget_ytd` gives an error"): the engine was already case-insensitive on KEYS, but the
  Budget Utilization report's column is `BUDGET` (no `_YTD`) — the error just gave no help finding
  that. (1) The expression textarea now has **autocomplete**: typing an identifier suggests matching
  columns (by key OR header label, prefix-ranked) and functions; ArrowUp/Down navigate, Enter/Tab or
  click inserts, Esc closes the dropdown only (Esc chain: autocomplete → dialog → panel → maximize);
  suggestions are suppressed inside 'string' literals. (2) **Click-to-insert chips** under the
  textarea — every column (rename-aware label, key in the tooltip) plus the 5 functions; inserts at
  the caret. (3) **irExpr header-label aliases**: a column's displayed label in identifier form
  (spaces→`_`, case-insensitive) resolves to the key — header "Budget Ytd" ⇒ `Budget_Ytd` compiles,
  renamed headers included; aliases never shadow real keys; the layout-restore recompile path passes
  labels so saved expressions keep resolving. (4) **Did-you-mean errors**: unknown-column errors
  suggest the closest key (prefix/substring/Levenshtein ≤ 3), e.g. "unknown column: Budget_ytd — did
  you mean BUDGET?". i18n: `ir.calc.hint` reworded + `ir.calc.insertCols`/`insertFns` EN+AR in
  `shared/i18n/common.*.json`. Shared change ⇒ APP_VERSION bumped in all 10 consumer apps (BI 1.8.0).
- **2026-07-03 — LOV convergence + param-spec editor + IR round 4 (breaks/highlights) + shared-layer
  promotion + BI_USER rollout helper (BI APP_VERSION 1.7.0) — DEPLOYED; smoke 24/24, E2E 27/27,
  UAT round 2 29/29.** Completes the follow-up flagged in the MERGE NOTE below: **ONE parameter-metadata
  column — `PARAM_SPEC_JSON`**. The canonical **re-run list after any 04 re-run is now: 08b, 09a, 10,
  12b** (13/13a are RETIRED — deleted from the repo; their handlers folded into 12b).
  - **DB `14_rpt_lov_converge.sql`:** folds every legacy `PARAMS_LOV_JSON` query into the matching
    `PARAM_SPEC_JSON` entry's `lov_sql` (admin edits win; dynamic SQL so it no-ops once the column is
    gone), seeds the GL_BUDGET_ACTUAL `period` entry for fresh installs, adds the `IS JSON` guard
    (`ck_dct_rpt_def_pspec`), then **DROPS `PARAMS_LOV_JSON`**. Run AFTER 10 and BEFORE re-running
    12a/12b. Gotcha hit: PL/SQL JSON object types can't be referenced inside a SQL statement —
    `UPDATE ... SET col = l_obj.to_clob` raises **ORA-40573**; assign `l_out := l_obj.to_string` first.
  - **PKG `12a` (in place):** `run_lov` now reads the param's `lov_sql` from `PARAM_SPEC_JSON`; new
    **`preview_lov(p_sql, p_max_rows=50)`** for the editor's Test button (same guards: query-keyword +
    bind-free; shared `exec_lov` core).
  - **ORDS `12b` (in place, now 10 ir/* handlers):** catalog emits **`params[]`**
    (`{name,label,labelAr,hint,hintAr,required,hasLov}` merged from params_json defaults + the spec —
    the viewer renders labels/hints/required from it; `lovParams` kept for back-compat) and absorbs
    13a's `GET ir/reports/:code/lov`; new **`GET/PUT ir/reports/:code/paramspec`** (SYS_ADMIN — raw
    spec editor payload; PUT accepts `{paramSpec:{...}}`, `{}` clears) and **`POST ir/lov/preview`**
    (SYS_ADMIN). Gotcha hit: a CLOB `=` comparison inside handler SQL (`CASE WHEN l_spec = '{}'`)
    raises **ORA-22848 at parse time → uncatchable ORDS 555** (even the handler's 404/400 paths die);
    same class as `JSON_QUERY(... RETURNING CLOB)` in a PL/SQL expression — keep both in SQL-from-dual
    or plain PL/SQL. `install.sql` order: `... 07 → 10 → 12 → 14 → 12a → 12b` (also fixed the stale
    `@@10_rpt_ir.sql`-era references left by the merge).
  - **DB `15_bi_user_rollout.sql`:** idempotent BI_USER grant helper — edit the username list, run any
    time; skips missing/inactive users and existing holders, prints the current holder list.
  - **Frontend (BI 1.7.0):** irViewer parameter card shows EN/AR labels, hints and required markers
    from the catalog `params[]`; **reportDetail "Parameters" drawer** (SYS_ADMIN) edits the spec
    per param (label/label_ar/hint/hint_ar/required/lov_sql) with a **Test** button running the draft
    query via preview. **`<interactive-report>` round 4:** **control breaks** (break toggle per column
    in the column manager + break chips; bands `Label: value`; per-group **subtotal rows** when any
    aggregate is set — structural repage subscribes to `hasAggs`, NOT the select's change event, which
    can fire before the value binding writes) and **highlight rules** (row/cell scope, 5-color soft
    palette, operators per column type, count badge on the toolbar); both persist in layouts +
    autosave and are dropped for unknown columns on apply.
  - **Shared-layer promotion:** the component now lives in **`final apps/shared/js/components/`**
    (`interactiveReport.js/.html`, `irExpr.js`; require as `'shared/components/interactiveReport'`),
    `.ir-*` grid styles moved to **platform.css**, component `ir.*` i18n keys moved to
    **`shared/i18n/common.*.json`** (viewer-page `ir.viewer.*` keys stay in BI). Autosave key is now
    app-agnostic: **`ifinance.ir.<code>::<section>`**. Shared change ⇒ **APP_VERSION bumped in all 10
    consumer apps** (Admin 4.5.10, PC/DT/CC/AR 4.5.8, HR/FL 4.6.3, TM 4.8.3, ATD 1.19.1, BI 1.7.0).
    Contract documented in `SHARED_JET_ARCHITECTURE.md`.
  - **Regression fixed:** BI `Jet/index.html` had shipped (commit 2077121) with the APP_VERSION
    `<script>` tag unterminated — a rebase-conflict artifact; fresh loads threw "Invalid or unexpected
    token" and the login view never mounted. Restored `;</script>`.
  - **UAT round 2** (`final apps/BI/UAT/UAT_BI_round2-03-07-2026/`, runner
    `assessment-3/phase4/tests/uat_run_bi.py`): 29/29 PASS across Viewer & Parameters / Grid Features /
    Admin Param Spec / API & Security; master `UAT_BI_TestScript.xlsx` created at the UAT root.
- **2026-07-03 — MERGE NOTE (parallel sessions).** Two branches shipped the same day: the param-spec/worker-fleet branch below (v1.3.0, `10_rpt_param_lov.sql`, PARAM_SPEC_JSON for the admin Run drawer) and the Interactive Report branch (v1.3.0–1.5.0). The IR scripts were renumbered `10*/11*` → **`12/12a/12b/13/13a`** to clear the number collision, and the merged frontend ships as **APP_VERSION 1.6.0**. The two LOV columns coexist: `PARAM_SPEC_JSON` (admin Run drawer: label/hint/required/lov_sql via `/reports/:code/params`) and `PARAMS_LOV_JSON` (BI_USER viewer via `/ir/reports/:code/lov`) — converging them is a known follow-up. Full re-run list after any 04 re-run: **08b, 09a, 10, 12b, 13a**.
- **2026-07-03 — IR round 3: parameter LOVs (BI APP_VERSION 1.5.0) — DEPLOYED + E2E 6/6.** Run-parameter
  inputs become dropdowns. A definition may carry **`PARAMS_LOV_JSON`** = `{ "<param>": "<query>" }` —
  admin-authored **bind-free** query per parameter (same trust level as source_ref; col 1 = value,
  optional col 2 = display label, capped 500 rows).
  - **DB:** `reporting/db/13_rpt_ir_lov.sql` — guarded ALTER adds the column (+ IS JSON check) and
    seeds the two pilots: BUDGET_UTIL_SECTOR (year/sector/projecttype/costcenter over
    `dct_budget_utilization_v` / `dct_butil_scope_v`) and GL_BUDGET_ACTUAL (period, ordered by
    `MAX(period_date) DESC` via GROUP BY — DISTINCT can't ORDER BY an unselected column).
  - **PKG:** `12a` updated in place — `DCT_RPT_IR_PKG.run_lov(code, param)`: case-insensitive param
    match, scrub + query-keyword guard, **rejects binds**, streams `{param, items:[{value,label}],
    total}`. **Run 13 BEFORE re-running 12a** (the body reads the new column — ORA-00904 otherwise;
    install.sql order fixed to 12 → 13 → 12a → 12b → 13a).
  - **ORDS:** `13a_rpt_ir_lov_ords.sql` (ADDITIVE) — redefines `GET ir/catalog` (adds `lovParams[]`
    per definition) + new `GET ir/reports/:code/lov?param=x`, both gated BI_USER-or-SYS_ADMIN.
    **Re-run list after any 04 re-run is now: 08b, 09a, 10, 12b, 13a** (13a AFTER 12b — it overrides
    10b's catalog handler).
  - **Frontend:** irViewer renders a `<select>` (optionsCaption "— Select —") for any param in the
    catalog's `lovParams`, plain input otherwise; values fetched per param via
    `rptService.getIrLov`. Numeric coercion on submit unchanged. i18n `ir.viewer.select` EN+AR.
  - **Verified:** API smoke (catalog lovParams, 4 LOVs return sorted values, unknown-param 400,
    no-LOV-map 400, unauth 401) + Playwright 6/6 (5 selects render, year/sector populated, run with
    dropdown values, required-param still enforced, no page errors).
- **2026-07-03 — IR round 2: themed header + maximize + header rename (BI APP_VERSION 1.4.0) — E2E 6/6.**
  Frontend-only (no DB change): (1) grid header now uses the FULL region-theme header treatment
  (`--region-hd-bg/-fg/-accent` fill+font, auto-follows the Admin Region Appearance palette) —
  **selector must be `table.data-table.ir-table thead th`**, plain `.ir-table thead th` LOSES the
  specificity fight to platform's `table.data-table thead th` and silently no-ops; (2) **maximize
  toggle** (⤢ icon at toolbar right) — fullscreen fixed overlay (`.ir-max`), sticky toolbar inside,
  Esc restores (Esc also closes panels/dialog first), body scroll locked while maximized, listener
  removed in dispose; (3) **rename column headers** (pencil in the column manager → inline input;
  empty/unchanged reverts to default) — override lives in colState `label` observable, flows to grid/
  chips/filter options/exports, persists in layout JSON (`columns[].label`) + autosave. i18n
  `ir.toolbar.maximize/restore` + `ir.cols.rename` EN+AR. Playwright round-2 6/6 (th bg === resolved
  `--region-hd-bg`, fixed overlay fills viewport, Esc restores, rename + persistence, no page errors).
  grid for business users: one capped server fetch, then column show/hide + reorder, filter chips,
  multi-sort (Shift+click), global search, **calculated columns** (safe client parser `irExpr.js` —
  no eval; ROUND/ABS/NVL/UPPER/LOWER), aggregates footer (sum/avg/min/max/count over the filtered
  set), CSV (BOM) + real **XLSX** export (SheetJS via requirejs `xlsx` path), **server-saved named
  layouts** (default auto-apply, SYS_ADMIN-only sharing) + localStorage last-state autosave.
  - **DB:** `reporting/db/12_rpt_ir.sql` — `DCT_RPT_IR_LAYOUT` (unique name per report+owner,
    `layout_json IS JSON`), **REPORTING module row** in `dct_modules` (module_id 101) + **BI_USER
    role** (assign via Admin roles UI), `IR_MAX_ROWS` config (default 10000).
  - **Executor:** `12a_rpt_ir_pkg.sql` — `DCT_RPT_IR_PKG.run_report` runs a definition's stored
    source ONCE with only its declared binds bound (DBMS_SQL parse/describe/typed fetch; literal+
    comment scrub before the bind scan so `'HH24:MI'` never fakes a `:MI` bind — verified; SELECT/
    WITH-only guard → 400; VIEW refs via DBMS_ASSERT; MULTI = one section per call, `required[]`
    enforced with the Python engine's exact failure text). Streams
    `{columns:[{key,label,type text|num|money|date}], items, total, truncated, maxRows}`; domain
    dates emitted as literal ISO (deliberately NOT `dct_to_local`); CLOBs substr'd to 4000.
  - **ORDS:** `12b_rpt_ir_ords.sql` — 6 ADDITIVE `rpt.rest` handlers, ALL gated **BI_USER OR
    SYS_ADMIN**: `GET ir/catalog` (enabled defs + MULTI sections/required), `POST
    ir/reports/:code/data` (body `{section?, params?}`), `GET ir/reports/:code/layouts`,
    `POST ir/layouts` (409 dup, share=admin-only), `PUT/DELETE ir/layouts/:id` (owner-or-admin,
    404 no-leak). **Re-run 12b after any 04 re-run** (with 08b + 09a + 10 + 13a).
  - **Frontend:** BI-local `<interactive-report>` KO component (`js/components/interactiveReport.js`
    + `.html` template + `irExpr.js`; `.ir-*` styles in `css/app.css` composing platform classes) +
    **Interactive Reports** viewer page (`irViewer`) with catalog + params/section runner. Nav is
    role-filtered: BI_USER-only users see Dashboard + Interactive Reports; admin routes reroute; the
    dashboard skips admin-gated fetches for viewers. `main.js` adds the SheetJS `xlsx` requirejs path.
  - **Verified:** API smoke 17/17 + truncation (IR_MAX_ROWS=5 → `truncated:true`) + VIEW-type +
    non-SELECT guard + phantom-bind literal test (scratch definitions, cleaned up); Playwright E2E
    **22/22** (hide/reorder/filter/sort/search/calc/aggregate/exports/layout save/autosave restore/
    BI_USER nav+reroute+403/no console errors). Perf: master rows in plain arrays, only the visible
    page in an observableArray (10k rows OK).
  - **Gotchas:** rows are normalized on ingest (APEX_JSON omits NULL keys); `.data-table th` is
    CSS-uppercased (test with case-insensitive match); the app router reads the hash only at BOOT —
    Playwright must `reload()` after a same-document `#hash` goto; a stale dev-proxy from another
    app on 8080 serves ITS app for root-absolute paths — probe `announcements?module=` to spot it.
- **2026-07-02 — Run-parameter LOVs + hints, drawer on the Reports list (BI APP_VERSION 1.3.0).**
  The Run Parameters drawer now shows a **dropdown (LOV) per parameter with an EN/AR label, a hint
  line and a required marker**, and opens **in place on the Reports list** (clicking Run now no
  longer navigates to the report detail page; the detail page's own Run now uses the same drawer).
  - **DB:** `reporting/db/10_rpt_param_lov.sql` — new nullable column
    `DCT_RPT_DEFINITION.PARAM_SPEC_JSON` (per-param UI metadata `{label, label_ar, hint, hint_ar,
    required, lov_sql}`; kept SEPARATE from `PARAMS_JSON` so runtime defaults stay a flat object the
    runner binds directly) + ADDITIVE `GET /rpt/reports/:code/params` (executes each `lov_sql` as
    ADMIN, max 500 rows — reference PROD objects with the `prod.` prefix) + the BUDGET_UTIL_SECTOR
    spec seed (LOVs from `DCT_BUTIL_SCOPE_V`: year/sector/projecttype/costcenter). **Re-run 10 after
    any 04 re-run** (04 DELETE_MODULEs rpt.rest). Deployed + endpoint smoke-tested on PROD.
  - **Frontend:** `rptService.getReportParams`; reports.js + reportDetail.js share the same drawer
    logic (required-field validation with toast; empty optional field omitted; numeric strings sent
    as numbers). E2E Playwright: drawer in place on `#reports`, 4 LOV selects + hints + 2 required
    stars, empty-submit validation, run queued with `year=2026&sector=Tourism` → SUCCESS (run 28).
  - **Worker fleet:** `runner.py` honours `RPT_WORKER_NAME` (worker display name override for cloned
    VMs) and new `reporting/runner/deploy_worker.sh` installs a permanent systemd worker
    (`rpt-worker.service`, Restart=always, creds in root-only `/etc/rpt-worker.env`) on any Linux VM:
    `export RPT_DB_PASSWORD=…; export SSHPASS=…; ./deploy_worker.sh <host> <name>`.
- **2026-07-02 — Workers monitoring + control page (BI APP_VERSION 1.2.0).** New **Workers** nav page:
  live Python-engine worker registry (health ONLINE/STALE/OFFLINE from heartbeat age, status, current
  run, done/failed counters), queue KPIs (queued / running / succeeded+failed today, backlog banner
  with oldest-queued age), Requeue-stuck button, and the two in-DB scheduler jobs
  (`DCT_RPT_NATIVE_JOB` / `DCT_RPT_MAINT_JOB`) with enable/disable. Auto-refreshes every 10s.
  - **DB:** `reporting/db/09_rpt_workers.sql` (`DCT_RPT_WORKER` heartbeat/command table + synonym) +
    `09a_rpt_workers_ords.sql` (5 ADDITIVE rpt.rest endpoints — **re-run 09a after any 04 re-run**).
    Deployed + verified on PROD (small one-block statements — safe on the Linux SQLcl).
  - **Runner:** `--forever` workers register as `<host>/py<pid>`, heartbeat every loop, and obey the
    page's commands — PAUSE (stops claiming, status PAUSED), RESUME, STOP (exit after current run);
    counters per run. One-shot drains stay unregistered. Pause→resume round-trip verified live.
  - **Gotcha:** `user_scheduler_jobs.last_start_date/next_run_date` are TIMESTAMP WITH TIME ZONE
    already in the job's own timezone (Asia/Dubai here) — display with `AT TIME ZONE 'Asia/Dubai'`,
    NOT `dct_to_local` (that double-shifts +4h). `dct_to_local` stays correct for the plain-TIMESTAMP
    UTC columns (worker heartbeats etc.).
- **2026-07-02 — Budget Utilization by Sector executive report (BUDGET_UTIL_SECTOR) + MULTI engine
  support (BI APP_VERSION 1.1.0).** New 6-part sector pack on the PYTHON engine: 1 Sector overview
  (master details + KPI cards) · 2 Budget utilization rows (budget/AP/GRN/PR/PO/fund) · 3 Unpaid +
  partially-paid invoices · 4 Uninvoiced GRN · 5 Open POs (GRN-netted) · 6 Reserved PRs. Params:
  `year`+`sector` REQUIRED, `projecttype`/`costcenter` optional; landscape PDF (grouped
  Actual/Encumbrance header + reconciling totals rows) + one-sheet-per-section XLSX + sectioned CSV.
  - **DB:** `db/v2/39_dct_rpt_butil_details.sql` (renumbered from 38 — the GL Rebuild-views wave took `db/v2/38` the same day) (5 PROD views: `DCT_BUTIL_SCOPE_V`,
    `DCT_UNPAID_INVOICES_V`, `DCT_UNINVOICED_GRN_V`, `DCT_OPEN_PO_LINES_V`,
    `DCT_RESERVED_PR_LINES_V` — same project/task key fallback grain as
    `DCT_BUDGET_UTILIZATION_V` so every part reconciles; re-run after 32/36/37 re-runs) +
    `reporting/db/08_rpt_butil_sector.sql` (MULTI lookup value, definition seed [idempotent,
    refreshes machine-owned fields on re-run], SELF recipient, disabled monthly schedule, and the
    **params-aware run handler**: `POST /rpt/reports/:code/run` now reads an optional JSON body of
    run params — body absent or `{}` keeps definition defaults; invalid JSON → 400).
  - **Runner (Python engine):** `source_type='MULTI'` — `source_ref` JSON
    `{orientation, required[], sections:[{key,title,layout,sql}]}`; `datasource.fetch_multi`
    (missing required params → clear FAILED error), per-definition `pdf_template` template
    (`budget_util_sector.html.j2`), landscape `page.pdf`, `render_xlsx.build_xlsx_multi`
    (sheet-name char sanitising), money-only totals (`_totals` skips line numbers/counts),
    `--params '<json>'` CLI. Render tests 8/8.
  - **BI app 1.1.0:** Run now opens a **Run Parameters drawer** when the definition declares
    `params_json` keys (numeric strings sent as numbers; empty fields omitted → defaults);
    definition card shows Params; `rptService.runReport(code, formats, params)` posts the body.
    i18n `det.runParams`/`det.runParamsHint` EN+AR.
  - **DEPLOY STATE:** `38` + the seed portion of `08` ran on PROD (PROD-user SQLcl session) and were
    verified live: all 6 stored section SQLs executed with binds year=2026 / sector=Tourism (250
    utilization rows, 60 unpaid invoices, 76 uninvoiced GRN, 204 open PO, 269 reserved PR) and the
    real data rendered through the actual pipeline into a 45-page landscape PDF + 6-sheet XLSX whose
    totals reconcile (e.g. Reserved PR total 139,664,892.47 = the Commitment PR KPI).
    **COMPLETED same day as ADMIN:** the user supplied the ADMIN password, a `prod_mcp` connection
    was saved on the Linux dev VM, and the params-aware run handler was published + verified
    (`user_ords_handlers` source contains the params body logic; definition/lookup/recipient/
    schedule/Arabic name all re-verified clean). Rule: **re-run 08 after any 04 re-run** (04
    DELETE_MODULEs rpt.rest and rebuilds the plain run handler).
  - **SQLcl gotchas found (Linux dev-VM SQLcl 26.1)** — cost hours, remember these:
    1. With `SET SQLBLANKLINES ON`, an anonymous PL/SQL block containing `MERGE` is **silently
       swallowed** (no error, no output) when run via `@file` — minimal reproducer confirmed;
       removing the SET makes the same block run.
    2. Independently, very large (~10 KB) DECLARE blocks in a script get **echoed instead of
       executed** on this build regardless of settings (script-reader bug; nested `@`, direct
       `@` and stdin all affected; the same shape deploys fine from the Windows SQLcl — the
       identically-shaped pilot `07_rpt_seed.sql` proved it).
    3. A `--` inside a `PROMPT` line merges the following statement into the prompt (already a
       known repo rule — it bit again during verification).
    Because of (2), `08` is now a thin driver that `@@`-invokes `08a_rpt_butil_seed.sql` (seed,
    one statement) + `08b_rpt_butil_run_handler.sql` (handler, one statement); keep zero blank
    lines inside statements and deploy 08 from the Windows `prod_mcp` SQLcl. Diagnose any silent
    skip with `SET ECHO ON`.
- **2026-07-01 — BI app round 1 review + fix + UAT (APP_VERSION 1.0.1).** Converted the three record
  forms (Reports create/edit; Report-detail Schedule + Recipient) from the legacy `modal-overlay`/
  `modal-box` to the shared **`<edit-drawer>`** (robust close on Cancel/Save/Esc/scrim). Fixed a latent
  KO binding bug: a `attr:{ placeholder:'{"period":null}' }` value contained a literal `"` that ended
  the `data-bind="…"` HTML attribute early → KO threw and left every subsequent field unbound (Email
  subject/body/Enabled lost their labels). Moved brace/quote placeholders to **static single-quoted
  HTML `placeholder=` attributes** (`reports.html` + `reportDetail.html`); all 13 drawer fields bind.
  **Gotcha (platform-wide):** never put a string containing `"` inside a KO `data-bind="…"` (e.g.
  `attr:{ placeholder:'{"k":v}' }`) — the HTML parser truncates the attribute at the inner quote. Use a
  static `placeholder='…'` or `&quot;`. Playwright UAT **15/15 PASS** (`final apps/BI/UAT/UAT_BI_round1-01-07-2026/`).
- **2026-07-01 — Phase 3 (NATIVE engine) BUILT + VERIFIED on PROD.** `DCT_RPT_NATIVE_PKG` + sweep job +
  `GL_BUDGET_ACTUAL_NATIVE` pilot; in-DB APEX_DATA_EXPORT PDF+XLSX with the BI brand colours. Reporting
  Platform now feature-complete (both engines live behind one control plane + UI).
- **2026-06-30 — Phase 2 (BI - Reporting JET app) BUILT + browser-verified 16/16.** App 211 live in the
  switcher; full config + run-history/logs/downloads/delivery/retry operated from the UI.
- **2026-06-30 — Phase 1 (Python engine) BUILT + VERIFIED E2E on PROD.** Pilot `GL_BUDGET_ACTUAL` run 2:
  SUCCESS, 3313 rows, ~21s; PDF 846,708 B (sig `%PDF-`) + XLSX 194,925 B (sig `PK`) archived to
  `DCT_RPT_OUTPUT`; email skipped (`EMAIL_ENABLED=N`). Render unit tests 4/4. venv + Chromium installed.
- **2026-06-30 — Phase 0 (control plane) DEPLOYED to PROD.** 14 objects VALID, `rpt.rest` PUBLISHED,
  27 RPT_* lookups, 12 config keys, pilot `GL_BUDGET_ACTUAL` seeded (definition + disabled sample
  schedule + SELF email recipient). enqueue→claim→mark smoke test passed; smoke run row cleaned.
  `EMAIL_ENABLED=N` (generate-only until SMTP configured).

### 2026-07-27 — BUDGET_UTIL_REGISTER: Related Invoices column (db/25 re-seed)
- Sheet "3. GRN Receipts" gains a trailing **Related Invoices** column: `LISTAGG(DISTINCT inv.invoice_number, ', ' ON OVERFLOW TRUNCATE)` in the invoiced-AED subquery via a deduped LEFT JOIN to `prod.ap_invoices` (GROUP BY invoice_id) — invoiced/received totals regression-verified unchanged. Deployed via python-oracledb on vm180 (Linux SQLcl swallows this MERGE-bearing seed); E2E run 166 SUCCESS. Details in `final apps/GL/docs/deployment-notes.md` (2026-07-27 (2)).

### 2026-08-24 — Report Distributions (To/Cc/Bcc) + TEST MODE (db/39 + runner)
- `39_rpt_distribution.sql`: `DCT_RPT_DIST` (dist_group `GL_BUTIL`, scope SECTOR|COSTCENTER,
  optional per-list `subject_tpl`) + `DCT_RPT_DIST_RECIP` (disposition TO|CC|BCC) +
  `DCT_RPT_DIST_BATCH`; `DCT_RPT_RUN` gains `dist_id`/`batch_id`/`is_test`/`email_subject`,
  `DCT_RPT_DELIVERY` gains `disposition`; lookups RPT_DIST_SCOPE/RPT_DISPOSITION/RPT_DIST_LEVEL;
  config keys **`EMAIL_TEST_MODE` (ships Y)** + `EMAIL_TEST_TO`. Count-then-insert seeds —
  Linux-SQLcl-safe, deployed via SQLcl 2026-08-24. NO rpt.rest route change (post-04 re-run
  list unchanged); the consumer routes live GL-side (`final apps/GL/db/27`).
- Runner: `deliver.py` gains the **distribution path** — a run carrying `dist_id` sends ONE
  message (To+Cc headers, Bcc envelope-only, per-address delivery rows w/ disposition, subject
  stamped on the run). **TEST MODE is decided at delivery time**: EMAIL_TEST_MODE=Y →
  only EMAIL_TEST_TO receives (subject prefixed `[TEST]`, run `is_test='Y'`, intended
  recipients logged SKIPPED); test mode with no test address = skipped entirely;
  EMAIL_ENABLED=N on a dist run = `record_dist_skipped` (honest log, nothing sent).
  Legacy per-recipient path untouched. Fleet-synced vm180-182 + rpt-worker restarted.
- Standing rule (user, 2026-08-24): **never send report emails to real recipients during
  testing — test mailbox only.** EMAIL_TEST_MODE must stay Y until Finance signs the lists off.

## 2026-08-31 — BUDGET_UTIL_REGISTER budget-verdict columns + per-run sheet-column filter (GL v1.96.0)

- **db/25 re-deployed** (python-oracledb on vm180): sheet 1 gains
  `budget_utilization_pct` / `budget_variance` / `budget_status` right after
  `ytd_budget` — Actual (AP incl. cost-adj + GRN) vs the ADJUSTED **ANNUAL** budget
  (user rule 2026-08-31: Annual always). Status text via the verified
  `TO_CHAR(NCHR())` glyph form: ● On track / ▲ Near limit / ▼ Over budget /
  Not budgeted. Thresholds ride the `th` CROSS JOIN from GL module settings
  `BUD_UTIL_NEAR_PCT` (90) / `BUD_UTIL_OVER_PCT` (100) — its WHERE is now
  `(setting_key LIKE 'PLAN%' OR setting_key LIKE 'BUD_UTIL%')`; keep it in
  lock-step with the GL/db/35 handler expressions.
- **runner.py — NEW generic `_apply_sheet_cols(sections, params)`** (fleet-synced
  vm180-182, rpt-workers restarted), applied ONLY in the `build_xlsx_multi` path:
  a run param **`sheet_cols_<sectionkey>`** = comma-separated column names keeps
  ONLY those columns, in that order, on the matching sheet. Case-insensitive,
  transparent to the `__pn` sign-tint suffix, the `row_kind` styling column always
  survives, unknown names are ignored, and a spec matching nothing leaves the sheet
  untouched. First consumer: the GL Budget Utilization **Manage Columns** saved view
  (GL/db/11 forwards body `sheetcols` as `sheet_cols_bu_lines`). PDF/book renders
  are deliberately NOT filtered (fixed templates).
- E2E verified via `final apps/GL/tests/vsbudget_cols_api_smoke.py` 13/13 — a
  filtered run's sheet 1 = exactly the requested ordered columns (openpyxl), a
  default run keeps the full 41-column sheet.

## 2026-08-31 (2) — BUDGET_UTIL_REGISTER trims (GL v1.96.1)

- **db/25 re-deployed**: sheet 1 `cost_adjustment` + `budget_override_adj`
  columns REMOVED (user; 41 → 39 columns — adjustments still fold into the
  figures, sheet 2's (**) rows keep `cost_adjustment_ref`), and sheet 8
  "Fund Movement" now returns **Approval State = 'Approved' rows ONLY**
  (`apr.approval_state = 'Approved'` in the l_bt outer WHERE; drops
  Rejected/Withdraw + no-trail transactions). Verified: full 2026 run =
  4,557 Fund Movement rows, all Approved.

## 2026-08-31 (3) — BUDGET_UTIL_REGISTER sheet-1 Fund Movement pair (GL v1.96.2)

- **db/25 re-deployed**: sheet 1 gains `fund_movement_count` +
  `fund_movement_amount__pn` after Utilization Pct (41 columns) — Approved
  Additional Fund transfer lines on the exact butil key (renamed `fm` inline
  view; Approved = latest `pa_budget_trx_approvals.assignment_state`),
  BUTIL_END cut, zero-amount lines excluded; values reconcile cell-for-cell
  with GL `/butil/fundmove` (2,213 keys, 0 mismatch). **GOTCHA:
  `DCT_RPT_DEFINITION.description` is VARCHAR2(1000) — ORA-12899 at 1,024;
  keep catalog descriptions terse.** SRC_LEN 29,061.

## 2026-08-31 (4) — BUDGET_UTIL_REGISTER sheet-1 Task Name (GL v1.96.3)

- **db/25 re-deployed**: sheet 1 gains `task_name` right after `task_number`
  (42 columns) — ATD_TASKS.task_name PROJECT-SCOPED via ATD_PROJECTS (task
  numbers repeat across projects; the butil view has no name column and
  DCT_TASKS names are empty). Renamed `tnm` inline view per the pf/fm
  ambiguity rule. SRC_LEN 29,364.

## 2026-09-06 — Budget Status PDF/PPT

`reporting/db/41_rpt_gl_budget_status.sql` deployed via SQLcl; explicit count/INSERT/UPDATE
avoids MERGE skipping. GL/db/49 bridges the authenticated Print menu to
`GL_BUDGET_STATUS` (no recipients). `render_fd.py`, the Budget Status Jinja template
and narrow PDF/PPT dispatch hooks deployed to vm180/181/182; backups under
`/opt/rpt-worker/backups/budget-status-20260906`. Six real jobs (1002–1007) succeeded
for all three presentations, including Arabic PPT. PDF totals match the GL dashboard.
The seed follows the live fd/status entity-classification semantics; re-run after
changing that handler. PowerPoint uses rendered page images; full ledger pages
accompany treemaps. The later Sector Performance PDF-header/footer work is separate
and must be preserved on rollback. See GL/docs/budget-status-review.md.

## 2026-09-06 — Budget Status renderer deep-review fixes

Deployed release `/var/www/ifinance-releases/20260906104833`, previous `/var/www/ifinance-releases/20260906061035`. Only Budget Status frontend hunks plus the version changed; concurrent GL work was preserved using the live baseline and hashes. Report workers vm180/181/182 were paused until idle, updated, restarted and verified active. Worker backups: `/opt/rpt-worker/backups/fd-deep-20260906`. Only `render_fd.py` and `templates/gl_budget_status.html.j2` changed. Fresh SQLcl deployed `GL/db/49_gl_fd_report_ords.sql`; handlers backed up in round-4 evidence.

Fixes: recover invalid saved settings/storage failures; prevent stale search responses/errors; clear errors on cached-period selection; keyboard Search toggle and accessible criteria/entity state; hide hover instructions when Show Summary is off; configured Entity names in collapsed Search; active Entity classification validation for export; exact/automatic export numeric parity; measured continuation-page pagination retaining complete entries and correct page numbering. User-approved zero-budget behavior: Ledger rows with a No budget allocated notice instead of an empty map, independently for sectors/departments, on screen and in PDF/PPT.

Verification: live browser 190/190, live Show Summary 67/67, six live PDF/PPT reports 51/51; local deep browser 40/40, export fidelity 85/85, reopened PDF/PPT artifacts 24/24, report unit tests 4/4; initial API baseline 144/144. Deployed deep browser checks passed 40/40; configured entity plus Unclassified exports passed 11/11. UAT: `UAT/UAT_GL_round4-06-09-2026/` workbook, Word results and evidence.

Access tests: two temporary accounts verified owner downloads and cross-user 404 (including another privileged user); accounts/sessions removed. Current `FEATURE_SEC_ENFORCE_GL` compatibility behavior permits report submission without the dedicated privilege. This policy remains unchanged pending the user's explicit decision. Automatic approval review initially blocked the additional entity test; the user explicitly authorized the built-in quick login, and the test then passed 11/11 across all configured entities and Unclassified. Regular live PDF/PPT exports passed. No financial data changed and no reports were emailed.

Rollback: reverse only this review's hunks if subsequent changes exist; otherwise the previous release above is available. Restore the two worker backup files and restart safely. ORDS source backup is retained with round-4 evidence. Do not revert unrelated GL changes.

## 2026-09-07 — literal `&mdash;` fix in 4 PDF templates
- User report: a null Actual/Plan % cell on a SECTOR_PERF_BOOK department page printed the literal text `&mdash;`.
- Cause: the no-value dash was written as an HTML entity **inside a Jinja `{{ }}` expression** (`else '&mdash;'`) — the environment autoescapes string expressions, so the entity prints literally. Entities in RAW template text (the `money()`/`dt()` macros, cover) are untouched and always rendered fine — that's why only expression-built cells broke.
- RULE: in `.j2` report templates, never put an HTML entity inside a Jinja string literal — use the real character (`'—'`).
- Fixed `sector_perf_book.html.j2` (12 spots) + same latent bug in `ap_dup_book.html.j2` (1), `procash_book.html.j2` (4), `gl_fmr_book.html.j2` (1); scp'd to vm180-182 `/opt/rpt-worker/templates/` + upserted to the DB store via `upload_template.py` on vm180.
- Verified: SECTOR_PERF_BOOK run #1102 (ALC, YTD 09-2026) — 0 literal occurrences; the null plan cell renders `—`.
