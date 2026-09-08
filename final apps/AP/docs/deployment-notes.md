# AP (App 212) — Deployment Notes

Platform-wide SQLcl/ORDS rules live in `final apps/Admin/docs/deployment-notes.md` §2 — read those first.

## Deploy checklist

1. **DB order** (SQLcl `sql -name prod_mcp`, each script CRLF + `SET DEFINE OFF` + `SET SQLBLANKLINES ON`):
   - `db/01_ap_module_seed.sql` — DCT_MODULES `AP` row (rerunnable).
   - `db/02_ap_pkg.sql` — `PROD.DCT_AP_PKG`. Verify both spec+body VALID.
   - `db/03_ap_ords.sql` — **fresh session**. Rebuilds `ap.rest` from scratch (DELETE_MODULE):
     **always re-run `04` right after any `03` re-run.** Verify 5 templates / 5 handlers.
   - `db/04_ap_level_ords.sql` — **fresh session**, additive lines/dists (+exports + cc lookup). Verify 10/10.
   - `db/06_ap_ai_dupcheck.sql` — AI duplicate check package + persistence.
   - `db/07_ap_dup_report_ords.sql` — **fresh session**, additive dup-report bridge.
   - **Procash Transactions (2026-08-17):**
     - `db/08_procash_ddl.sql` — tables, sequence, lookups, AP module settings, roles, doc checklist,
       bootstrap role holders. Rerunnable.
     - `db/09_procash_pkg.sql` — `PROD.DCT_AP_PROCASH_PKG`. Verify spec+body VALID.
     - `db/10_procash_ords.sql` — **fresh session**, additive. Verify 19 procash templates.
     - `db/11_procash_wf.sql` — DWP process `PROCASH_APPROVAL` + fact view + route `AP_PROCASH` → WF.
       Rebuilds the definition ONLY while it has zero instances.
     - `db/12_procash_report_ords.sql` — **fresh session**, additive report bridge (needs
       `reporting/db/37_rpt_procash_register.sql` + the `procash_book.html.j2` template uploaded).
     - Excel add-in: `db/v2/121_xl_procash.sql`, then **re-run `db/v2/107_xl_budget_ords.sql`**
       (107 `DELETE_MODULE`s `xl.rest`, so the procash routes live inside 107 itself).
   - `db/14_ap_direct_report_ords.sql` — **fresh session**, additive Direct-AP Briefing Book bridge
     (needs `reporting/db/38_rpt_ap_direct_register.sql` seeded; XLSX only — no PDF template).
   - **Post-`03` re-run list is now: 04, 06, 07, 10, 12, 14.**
2. **Frontend**: bump `window.APP_VERSION` in `Jet/index.html`; if anything under
   `final apps/shared/` changed, bump ALL apps. Ship via `webtier/deploy_frontend.sh`.
3. **Smoke**: run `scratch` API suite (or curl `/ap/filters` + `/ap/summary?sector=Culture&paid=Unpaid`
   — the filtered summary must return in ~1–2 s, not minutes) and a browser pass
   (`Jet/dev-proxy.py <port>`; port 8080 may be taken on the dev VM — pass another port).

## App-specific gotchas (all hit during the 2026-07-12 build)

- **Never filter the AP views with `OR EXISTS` correlated subqueries.** The `AP_*_V` views
  sit over un-indexed ATD-loaded tables; a facet like `sector` turned into a 5+ minute
  query. `DCT_AP_PKG.filtered_ids` does ONE scan per used facet into an id collection and
  intersects with `MULTISET INTERSECT DISTINCT` — keep that pattern for any new facet.
- **A stuck long query pins DCT_AP_PKG** — `CREATE OR REPLACE PACKAGE BODY` then hangs on
  the library-cache pin until the query finishes (or its session is killed). If a package
  redeploy "hangs", check `v$session` for an active `/ap/…`-module session first.
- **No due-date column**: aging uses `TERMS_DATE` (100% populated) as the due-date proxy;
  bucket by `TRUNC(SYSDATE) - TRUNC(terms_date)`.
- **Aging must include negative balances** (`balance_due <> 0`, not `> 0`) — credit memos —
  otherwise Σ(aging buckets) ≠ Outstanding KPI and the dashboard looks broken.
- **No `AMOUNT_PAID_AED` column**: AED-normalise paid/balance with the per-invoice ratio
  `NVL(invoice_amount_aed / NULLIF(invoice_amount,0), 1)`.
- **Header `REQUESTER` is always NULL** — the Requestor facet uses `PR_PREPARER` from the
  distributions view. "Department" = `EXPENDITURE_ORGANIZATION` (lines view).
- Multi-value facet params travel **pipe-delimited** (`curr=USD|EUR`); `(None)` selects
  blank pay_group, `Unclassified` selects blank sector.
- Line/dist registers re-apply their own-grain facets directly to the rows (a sector
  filter shows only that sector's distributions, not all rows of matching invoices).

- **ATD_AP_* structural reload playbook** (hit 2026-07-13 when the OTBI analysis
  dropped `Attachment Flag` from `ATD_AP_INVOICES` and ALL three `AP_*_V` views +
  `DCT_AP_PKG` body + five GL-layer views went INVALID): run
  `prod.dct_views_rebuild(l_rebuilt, l_invalid)` (two OUT params) to fix the
  pass-throughs + GL layer, then `@05_ap_views.sql` (recreates the `AP_*_V`
  views — now the source of truth in the repo — and recompiles `dct_ap_pkg`),
  then `@03` + `@04`. Verify `all_objects WHERE status='INVALID'` is empty.

## Procash Transactions — gotchas paid for on 2026-08-17

- **`uid` and `validate` are unusable as package routine names.** Both collide with SQL
  built-ins the moment the routine is called inside a SQL statement: `uid(p_user)` in an
  `INSERT ... VALUES` raised `ORA-01747: invalid column specification: "UID"`, and
  `JSON_TABLE(validate(id), ...)` raised the same for `VALIDATE`. Renamed to `user_id_of`
  and `findings`. Calling them from PL/SQL alone would have hidden the problem.
- **`SQLERRM` cannot be referenced inside a SQL statement** — assign it to a local first,
  then use the local (`JSON_OBJECT('error' VALUE v_err)`).
- **An inline `(SELECT …)` is not a PL/SQL expression** — `ok('x', (SELECT COUNT(*) …) = 3)`
  does not compile; `SELECT … INTO` first.
- **A KO `<select>` whose option list is still empty at bind time BLANKS its bound value.**
  The entry page's currency came back as NULL on save (`ORA-20001: Currency is required`)
  until the VM re-applied currency and business unit after the pick lists resolved
  (`restoreSelects()`), whichever order the two requests finish in.
- **The procash meta routes deliberately sit under a third path segment** (`procash/meta/lovs`,
  `…/projects`, `…/report`). A two-segment literal like `procash/export` would compete with
  `procash/:id`; a third segment that no `:id` route uses (never `lines`, `documents`,
  `submit`, `process`, `cancel`, `invoice`) cannot collide with a numeric id.
- **A refused write in an ORDS handler rolls the request back** — correct per request, but a
  SQL*Plus test harness that builds fixtures in the same transaction loses them. `procash_xl_test.sql`
  commits its fixtures and deletes them explicitly instead of relying on a closing ROLLBACK.
- **Calling an ORDS-facing package from SQLcl needs `OWA.init_cgi_env` first**, or
  `OWA_UTIL.mime_header` raises ORA-06502.
- **This box's SQLcl swallows a PL/SQL block that contains blank lines**, so `db/08` and
  friends carry zero interior blank lines and every deploy is verified with row counts,
  not the console log.

## Procash coding fields — strict dropdowns, no master validation (2026-08-17, user decision)

Project / Task / Expenditure type / GL combination / Payee are **strict dropdowns** on the form,
and the server **no longer validates the codes against the masters**. Consequences to keep in mind:

- The FKs from `DCT_AP_PROCASH_LINE` to `DCT_PROJECTS` / `DCT_TASKS` / `DCT_EXPENDITURE_TYPES`
  are **dropped** (`db/08` drops them if present and no longer creates them). What is still
  enforced is completeness: a project line needs all three parts, a GL line needs a combination.
- The API and the Excel add-in bypass the dropdown, so **that is where unvalidated codes will
  actually enter**. A line coded to something the masters do not carry will not join to GL or
  Budget Utilization.
- **`DCT_GL_CODE_COMBINATIONS` holds 12 demo rows — never use it as a GL source.** The first cut
  validated against it, which would have rejected every real combination. The chart of accounts is
  **`DCT_GL_COA_SNAP` / `DCT_GL_COA_V`** (9,447 rows, `cc_string` already in canonical order).
- GL combinations are still normalised through `prod.dct_cc_canon` on the way in, so a value typed
  by an API or Excel caller matches what the form produces.
- Every dropdown re-injects its stored value as an option when the master no longer lists it —
  otherwise KO's `options:` binding silently blanks the field on an old record.

## Deployment history

- **2026-08-21 (round 2) — PR guard + Chapter facet (AP v1.22.0; db/02+03+04 re-run + full
  post-03 chain + reporting/db/38 re-seed).** ① **PR check on Direct AP (user):** verified
  **0** direct invoices carry any PR reference (all 747 incl. cancelled — a PR cannot exist
  without a PO); `pr_count = 0` added to the nopo rule anyway (pkg predicate + all four
  /filters predicate shapes + the report's l_flt) so the invariant holds by construction.
  Scope unchanged: 588 / AED 369.7M. ② **Chapter search criterion on ALL THREE dashboards**
  (AP Dashboard, Beneficiaries, Direct AP): `p_chapter` in `filtered_ids` — a per-invoice
  CLASSIFICATION facet exactly like `p_sector` (single chapter / `(Multiple chapters)` /
  `Unclassified`; counts sum to the invoices KPI) — bound on every route, counted
  `chapters[]` LOV in `/filters` (honours inclcxl/suppnum/nopo scoping), own-grain re-apply
  on the dists register/export (mirrors sector), forwarded by the Direct-AP book bridge +
  bound in AP_DIRECT_REGISTER's l_flt (uncorrelated IN + Unclassified NOT-IN leg — never a
  correlated per-row subquery against the un-indexed dist view). One shared `GROUP_DEFS`
  entry serves all three pages (`f.chapter` EN/AR). Live: Chapter 2 = 8,492 invoices,
  direct∩Chapter 2 = 32; KPI == facet count verified. Tests: API smoke **19/19** + browser
  **15/15**. Frontend release 20260821054018.

- **2026-08-21 — Direct AP page + Briefing Book (AP v1.21.0; db/02+03 re-run + 04/06/07/10/12
  re-run + NEW db/14 + reporting/db/38).** New nav page **Direct AP** = the AP Dashboard mounted
  in `nopo` mode (the Beneficiaries nested-`module` pattern, zero duplicated markup): only
  invoices with **NO PO reference and NO project coding anywhere**. The rule is TWO-legged —
  `header_po_number IS NULL AND po_count = 0 AND project_count = 0` (header cols, distribution-
  derived) **AND no invoice LINE carrying a `po_number`/`project_number`**: the first pass missed
  the line leg and 131 of 878 candidate invoices turned out to be project-coded at the LINE grain
  with clean distributions (the header counts only see distributions). Engine = new `p_nopo`
  param in `dct_ap_pkg.filtered_ids` (header-scan predicate + one `MULTISET EXCEPT` scan of the
  raw `prod.ap_invoice_lines` pass-through); `nopo=Y` is bound on every ap.rest facet route and
  inlined into every `/filters` LOV/count query (all three predicate shapes). Live scope at
  deploy: **588 direct invoices (non-cancelled), AED 369.7M**. Direct-AP UI drops the
  project/etype/requestor facets + PO/PR/Task ref inputs and hides the PO/project columns by
  default; own col-prefs (`ap.direct.cols`) + IR code `AP_DIRECT_REGISTER`. **Briefing Book
  (Excel)** header button → `POST /ap/direct/report` (bridge db/14, GL-butil poll/download
  pattern) → Reporting definition **AP_DIRECT_REGISTER** (reporting/db/38, MULTI/PYTHON,
  **XLSX only** — no PDF template, other formats 400; 5 sheets: overview by payment status /
  full register / by supplier beneficiary-aware / GL coding of non-tax dists / aging on the
  due-date basis; params mirror the page criteria bu/supplier/paid/val/datefrom/dateto/search/
  inclcxl). Tests: `tests/direct_api_smoke.py` **14/14** (incl. book E2E render+download,
  1,364 rows / 177KB) + `tests/direct_browser_smoke.py` **15/15** EN+AR (incl. UI book
  download). Deployed via Linux SQLcl `sql -name prod_mcp` (the 16.7KB `setup_ap_ords_t1`
  statement landed intact — verified `LENGTH(source)` + `:nopo` refs per handler after the run).
  Frontend release 20260821015055 (`SSH_USER=opc ./deploy_frontend.sh 129.151.159.189`).
  Note: 2 pre-existing INVALID PROD objects (`AR_TAX_CALC*`, another session's in-progress AR
  work, last DDL 2026-08-19) were present before this deploy and left untouched.

- **2026-08-17 — Procash Transactions (AP v1.19.0; db/08–12 + db/v2/121 + 107 re-run +
  reporting/db/37).** Manual payments pushed through the bank portal directly, outside Fusion
  Payables, recorded master–detail with budget coding, attachments and an audit trail, then
  reconciled to the Fusion payable invoice once it exists. `DCT_AP_PROCASH` +
  `DCT_AP_PROCASH_LINE` are the first WRITE tables in AP; everything else reuses the shared
  platform (`DCT_DOCUMENTS`, `DCT_REQUEST_STATUS_HISTORY`, `DCT_LOOKUP_VALUES`).
  Lifecycle DRAFT → SUBMITTED → PROCESSED → INVOICED, with the AP module setting
  **`PROCASH_APPROVAL_MODE`** (ships `NONE`) inserting a DWP chain (line manager → Finance
  Director) before PROCESSED when set to `WORKFLOW`. The workflow route uses its **own module
  code `AP_PROCASH`**, not `AP`, so nothing else in the module is bound to the engine and a
  rollback is a one-row UPDATE. Excel: four business objects (Single / Headers / Lines /
  Invoice Update) for the Visual Builder Add-in, all writing through the same package as the
  UI. Reporting: `PROCASH_REGISTER` (5 sections, XLSX sheets + PDF book).
  Verified: unit 45/45 · API 84/84 · browser 38/38 EN+AR/RTL · workflow 22/22 · Excel 17/17 ·
  report render both formats (XLSX 5 sheets, PDF 3 pages) · UAT round 1 22/22.
  **Same-day follow-up (AP v1.20.0):** the coding fields became strict dropdowns and master
  validation was switched off by user decision — see the section above.

- **2026-08-06 — AI Duplicate Check PAGE + invoice drills + PDF/Excel reports
  (AP v1.16.0, db/06 re-run + NEW db/07 + reporting/db/33).** Same-day round 2
  on the AI check (user request): ① drawer → **full page** `aiDuplicates`
  (nav item "AI Duplicate Check"): every AI run is now PERSISTED
  (`DCT_AP_AI_DUP_RUN/_GROUP/_MEMBER`, created in db/06 idempotently;
  `benef_dup_check(p_suppnum, p_user)` inserts + COMMITs and the envelope
  gains `runId/ranAt/ranBy/groupNo`), so the page loads the LAST run
  instantly via NEW `GET /ap/benef/dupcheck/last` (`benef_dup_last` rebuilds
  the envelope from the tables; shared accounts recomputed live via the
  refactored `emit_shared`) and "Re-run analysis" is an explicit action.
  The Beneficiaries-dashboard button now just navigates (AI VM block +
  drawer markup removed from dashboard). ② **Invoice counts are links**:
  NEW `GET /ap/benef/dupinvoices?bank=|name=|runid=&grp=` returns the
  invoices behind any count (3 modes: normalised-bank platform-wide
  [optional name], AI group via the persisted member names, effective
  vendor name; cap 500 + count/totalAed) — right-edge drill drawer with a
  reconciling total, CSV, and **invoice numbers deep-linking to Fusion**
  (`fusionLinks.invoice(invoiceId)`). ③ **Generate Report** buttons
  (GL-butil pattern): NEW Reporting-Platform definition
  **AP_BENEF_DUP_REGISTER** (reporting/db/33 — MULTI, 5 lock-step sections:
  overview / groups / group_invoices / shared_accounts / shared_invoices;
  XLSX = sheet per section w/ FULL invoice detail; PDF = executive book via
  DB-stored template `ap_dup_book.html.j2`, uploaded via PUT
  /rpt/templates) + NEW bridge **AP/db/07** (`POST /ap/benef/dupreport`
  {format:PDF|XLSX} → enqueue as the calling user · `GET :id` status ·
  `GET :id/file` download). **AP post-03 re-run list is now 04, 06, 07.**
  reporting/db/33 is a data seed (no re-run coupling). E2E: XLSX 267KB
  5 sheets / PDF 505KB render on the fleet; API 7/7; browser smoke
  `ap_aidup_page_browser.py` 9/9 EN+AR incl. BOTH report downloads.
  **OPS incident on the way:** all rpt-workers showed systemd active but
  heartbeats were ~18h stale (hung after a network blip) — QUEUED runs
  never claimed; fix = `ssh root@192.168.1.18X systemctl restart
  rpt-worker` ×3. A stuck reporting run ⇒ check `/rpt/workers` health
  FIRST. Gotchas: the default `report.html.j2` has NO sections loop — a
  MULTI PDF needs its own template; the AP router reads the hash only at
  boot (in-page `#hash` goto does not remount — navigate via the shell VM).

- **2026-08-06 — AI dup-check: vendor bank-account evidence + shared-account
  red-flag section (AP v1.15.0, db/06 re-run).** User request: "enhance the AI
  checking process to check if same vendor bank account are used for different
  vendors." Two enhancements to `DCT_AP_AI_PKG.benef_dup_check`, both fed by
  the new `ap_invoice_installments` extract data: ① the AI prompt lines are now
  `id|name|bank accounts` (LISTAGG DISTINCT per effective name, benef-scoped) —
  a shared account is decisive same-identity evidence for name variants, and
  group members ship `bankAccounts` (drawer column + CSV). Groups rose 135→~172
  and ~170 reasons cite the shared account. ② deterministic **`sharedAccounts`**
  envelope section: every bank account used by ≥2 DIFFERENT effective vendor
  names, checked **PLATFORM-WIDE across all suppliers** (not just 26553) —
  account key alphanumeric-normalised (`UPPER(REGEXP_REPLACE(...,'[^A-Za-z0-9]',''))`,
  len ≥ 6) so spacing/dash IBAN variants still match; amounts de-duped at
  invoice grain; top 100 accounts by vendor count then value +
  `sharedAccountCount`/`sharedShown`. Live data: **148 shared accounts** — e.g.
  one FAB corporate debit card paid under 92 names (3.78M AED), an Asteco
  account spanning TWO supplier numbers (26553 + 12369), Private-Department
  name variants. Frontend: red `.ai-group--warn` shared-accounts section in the
  AI drawer (account mono + vendor-count danger badge + per-vendor table w/
  Supplier No), members Bank-accounts column, CSV = both sections, meta line
  shows the shared count, `ai.*` i18n +12 keys EN/AR, hint updated.
  **PROMPT-QUALITY LESSON (2 iterations):** naive "shared account = decisive"
  made the model merge all 92 corporate-card employees into ONE conf-1.0
  "duplicate" group. Fix = prompt carve-out (a many-person card/prepaid funding
  account must NOT group on the account alone) **+ server-side guard skipping
  groups with `confidence < 0.4`** (models still emit the catch-all group at
  conf 0.1 despite instructions — filter, don't trust). Browser smoke
  `ap_ai_shared_browser.py` 7/7 EN+AR (gotcha: on `#beneficiaries` get the VM
  via `ko.dataFor(<element inside the drawer>)` — the module host's first child
  belongs to the wrapper VM, not DashboardViewModel).

- **2026-07-19 — AI-button hint + PLATFORM rebrand "Fusion i-Finance" + DCT logo.**
  ① The Beneficiaries "Check duplicate using AI…" button gained a rich `title`
  hint (`ai.btn.hint` EN/AR) explaining what the analysis does, how long it
  takes and that suggestions must be verified. ② PLATFORM-WIDE rebrand (user
  request): suite name **i-Finance → "Fusion i-Finance"** — shared i18n
  `suite.name` EN/AR, every app's `<title>` + side-nav `FUSION i-FINANCE · APP
  nnn`, GL portal strings, FL Portal wordmark, and the DB login branding
  (`DCT_SYSTEM_SETTINGS` APP_NAME/'Fusion i-Finance' + APP_NAME_AR) — and the
  topbar **iF cube replaced by the official DCT crest logo** in all 11 shell
  apps: NEW shared asset `shared/img/dct-logo.png` (136×79 PNG recovered from
  the legacy APEX app-101 static-file export via hex-decode) rendered by the
  new `.suite-logo` white tile in platform.css. Shared change ⇒ all 12 apps
  bumped; webtier release 20260719180511.

- **2026-07-19 — AI duplicate-beneficiary detection (AP v1.13.0, NEW db/06).**
  Beneficiaries dashboard gains a **"Check duplicate using AI…"** header button:
  one call clusters all distinct beneficiary names (same person registered
  multiple times — spacing, capitalisation, Mohamed/Mohammed transliterations,
  swapped order, titles, typos) into likely-duplicate groups shown in a
  right-edge drawer (canonical name + confidence badge + reason + member rows
  w/ site, invoice count, total AED, first/last invoice; CSV export;
  verify-before-merging disclaimer). NEW `db/06_ap_ai_dupcheck.sql`:
  `PROD.DCT_AP_AI_PKG.benef_dup_check` — AI config is the FL module's
  (user requirement): provider registry `prod.dct_ar_ai_providers` + the
  FREELANCERS module settings AI_PROVIDER/AI_MODEL/AI_FALLBACK_CLAUDE, text-only
  DBMS_CLOUD call with 4-try backoff + GEMINI→ANTHROPIC fallback (mirrors
  DCT_FL_AI_PKG); prompt sends `id|name` lines, answer references ids only;
  additive `POST /ap/benef/dupcheck?suppnum=` (**re-run 06 after any 03**).
  Live-tested: 1,374 names → 135 groups in ~23 s on gemini-2.5-flash.
  GOTCHAS hit: ① `APEX_JSON.STRINGIFY` has no CLOB overload — a ~50 KB prompt
  needs a chunk-safe `json_escape_clob`; ② gemini-2.5-* burn THINKING tokens
  out of `maxOutputTokens` and truncate the JSON on big lists — set
  `thinkingConfig:{thinkingBudget:0}` (+60k budget); ③ `IS JSON` is a SQL-only
  condition — test via `SELECT … WHERE v IS JSON`; ④ CLOB responses must be
  HTP.prn'd in chunks; ⑤ `dct_rest.validate_session` RETURNS NULL rather than
  raising — every handler needs the explicit `IF l_user IS NULL THEN err(401)`
  guard (first deploy shipped without it = unauthenticated route; fixed same
  hour). Webtier release 20260719175106.

- **2026-07-19 — AP rebrand: plum → green (#8E3B5C → #14682F).** All fills/
  backgrounds and the chart palette move to the new brand green: `app.css`
  tokens (`--brand #14682F` / `--brand-rgb 20,104,47` / `--brand-dark #0F4E23`
  / `--brand-soft #E8F3EC` — every component styled off the vars follows for
  free), `dashboard.js` chart constants (`BRAND`/`BRAND_MID` + the 6-step aging
  ordinal RAMP rebuilt light→dark on the green hue: #9ECBAD → #0B3A1A; print
  report + drawers + tooltips inherit via BRAND), the shared shell module
  registry color (`shared/js/shell.js` — switcher dot + boot brand; shared
  change ⇒ all-apps APP_VERSION bump) and the `DCT_MODULES` row
  (icon_color/bg_color, seed `db/01` + live UPDATE in PROD). No AP
  `THEME_BRAND_COLOR` module-setting row exists, so the registry default is
  what boots. Semantic status colors (paid green / warn amber / error red) and
  the region-theme settings are unchanged. Webtier release 20260719171839.

- **2026-07-19 — Interactive-view deep-links + register COA popover (AP v1.12.0).**
  User-reported: in the Interactive view (shared `<interactive-report>`) at Line/Dist
  level the Invoice/PO/PR numbers were plain text and PO/PR rendered comma-grouped
  like ids (they were typed `num` in the IR envelope). Fixes: ① the SHARED IR
  component gained an optional envelope hook `cellLink(row, colKey) → href|null`
  (renders the cell as a new-tab `.ir-link` anchor, base columns only; cells now
  carry `data-key` for app-level delegated handlers; `.ir-link` style in
  platform.css) — AP's envelope passes an adapter over the existing
  `cellLink(row,col)` rule set, so the IR grid links Invoice # (row.id), PO
  (poHeaderId) and PR (prHeaderId) exactly like the standard table; ② PO/PR/
  receipt/voucher numbers dropped from `IR_NUM_KEYS` → typed text, no thousands
  grouping; ③ **GL Combination popover**: the 10-segment code+desc popover (same
  as the invoice window's Distributions tab) now shows on hover over the
  register's `glCombination`/`chargeAccount`/`poChargeAccount` cells in BOTH
  views (and the Beneficiaries dashboard — same VM): delegated
  `ccRegOver/Move/Out` on the register region + NEW additive `GET /ap/cc?cc=`
  (04 part 5 — one snap row by cc_string, `found:'N'` when absent), lazy-cached
  per combination. Shared change ⇒ APP_VERSION bumped in ALL 12 apps
  (AP 1.12.0). Deploy: 04 re-run (10/10 templates+handlers), webtier release
  20260719152633; sanity 50/50 register combinations resolve in the snap.

- **2026-07-18 — BU facet fix round (AP v1.11.1).** User screenshot: the Business-unit
  facet rendered three "(None)" rows — the `/filters` `businessUnits[]` LOV was emitted as
  `{v,c}` (the GL LOV shape) but the counted-facet renderer expects `{name,count}` like every
  other counted array; 03 re-run with the corrected shape (then 04 — 03 rebuilds ap.rest).
  Also per user: the group moved to the TOP of the facet rail (open by default) and
  **Department of Culture and Tourism is pre-selected on first load** — `loadFilters` checks
  the `^Department of Culture` item on the first fetch only and the initial summary/register
  load now runs AFTER filters resolve, so the page opens DCT-scoped (5,321 invoices,
  cancelled excluded) with a clearable chip; re-fetches keep user selections as before.
  Applies to BOTH dashboards (the beneficiary scope spans all 3 BUs too). Browser check 9/9.
  APP_VERSION 1.11.1.

- **2026-07-18 — Business Unit facet + CROSS-BU data (AP v1.11.0).** The user added *Business
  Unit Name* to the AP Invoices OTBI analyses and the extract now loads **cross-BU** data:
  DCT 5,757 + Museum Shared Services 2,166 + Abrahamic Family House 232 invoices (was 5,456
  DCT-only — every AP figure platform-wide grew accordingly, by design). Wiring: `ATD_AP_INVOICES.
  BUSINESS_UNIT_NAME` → all 3 `AP_*_V` views gain `BUSINESS_UNIT` (05), `DCT_AP_PKG.filtered_ids`
  gains `p_bu` (multi, header grain; 02), every handler passes `bu=` + `/filters` ships a counted
  `businessUnits[]` LOV (03+04), registers/CSVs at all 3 levels carry the column. **Deploy gotcha:
  the new extract column requires `prod.dct_views_rebuild` BEFORE 05** (the `prod.ap_invoices`
  pass-through predates the column; without the rebuild 05 compiles INVALID with ORA-00904).
  Frontend: **Business unit** counted facet group (both dashboards incl. Beneficiaries), visible
  `businessUnit` register column (hidden at line/dist levels). API verified: all=8,155 / MSS=2,166 /
  MSS register rows all-MSS; browser spot-check PASS.

- **2026-07-12** — Initial deploy: 01→04 to PROD; `ap.rest` 9 routes live; API smoke 14/14;
  browser smoke 23/23; platform registration (shell + i18n + all-apps APP_VERSION bump).
  Web-tier release `20260712231423` shipped same day (whole fleet; AP live at /AP/Jet/).
- **2026-07-12 (round 2)** — `db/04` re-run: dists register/export now join `po_lines`
  (order_number/line) → `po_distributions` (schedule/distribution_number) for the
  PO-sourced charge account; `glCombination` = `dct_cc_canon(COALESCE(po, ap))`
  (the PO extract stores charge accounts in the FLIPPED segment order — canon fixes it),
  `chargeSource` PO/AP + full invoice-detail columns. Coverage: 9,910 PO-matched dists,
  4,430 with a loaded PO dist row, 0 canonical mismatches. Frontend 1.1.0: full-width
  dashboard (`page-wrap--full`), ONE metadata-driven register table (all levels),
  per-user column chooser saved to `/dct/prefs` key `ap.dash.cols` + localStorage.
  Browser smoke 30/30. Web-tier redeployed.
- **2026-07-12 (round 3)** — Interactive view on the register: shared `<interactive-report>`
  component embedded (rename cols / calculated cols / aggregates / breaks / highlights;
  `layoutsApi: null` = localStorage layouts only — the server-layout endpoints are BI-gated).
  Register endpoint caps raised 500 → 10000 for the one-shot IR fetch (03 + 04 re-run;
  remember 03 rebuilds ap.rest → always re-run 04 after it). The envelope must carry
  `section` — the component scopes its autosave key from env.section, not the param.
  APP_VERSION 1.2.0; browser smoke 37/37.
- **2026-07-13** — `Attachment Flag` removed from the OTBI analysis / `ATD_AP_INVOICES`.
  Recovery per the playbook above; NEW `db/05_ap_views.sql` captures the three view
  definitions (minus `has_attachment`); drill handler no longer selects/returns it
  (03+04 re-run); `dr.attachment` i18n keys dropped. Zero INVALID in PROD, API smoke
  14/14, GL butil verified. APP_VERSION 1.2.1.
- **2026-07-13 (beneficiary round, v1.3.0)** — supplier `BENEFICIARY` is a generic Fusion
  supplier record (2,723 of 5,456 invoices; the real payee is in header `BENEFICIARY_NAME`,
  populated on 2,295 of them and ONLY on BENEFICIARY rows). All three register levels,
  their CSV exports, the top-suppliers chart, the suppliers KPI and the supplier sort now
  use the **effective supplier** (`CASE WHEN supplier_name='BENEFICIARY' AND beneficiary_name
  IS NOT NULL THEN beneficiary_name ELSE supplier_name END`) + a new **Is Beneficiary Y/N**
  column everywhere (visible by default at header level, in the chooser at line/dist).
  Free-text `search=` now also matches `beneficiary_name` (db/02). Lines + dists views
  gained `BENEFICIARY_NAME` (db/05 — the header attr joined via `ap_invoices`). The drill
  keeps the RAW supplier + beneficiary + flag (detail view). Deploy order was 05 → 02 →
  03 → 04. The supplier FACET still lists the generic `BENEFICIARY` value (filtering is
  by real supplier record); find a payee via free-text search.
- **2026-07-13 (canonical GL combination)** — platform rule (user-confirmed same day):
  every combination string uses the canonical **Fusion** order
  `entity.program.cc.bg.account.es.appr.ic.f1.f2`. AP was already
  canonical (`glCombination`/`chargeAccount` via `dct_cc_canon`/COA snap); the raw
  `poChargeAccount` (register + CSV) is now wrapped in `dct_cc_canon` too (db/04).
  NOTE: `db/v2/43` (old AP view DDL) RETIRED — `AP/db/05_ap_views.sql` is the only source.
- **2026-07-13 (dashboard enhancements round 4, v1.4.0)** — six-part UX/analytics round:
  1. **Include Cancelled Invoices?** checkbox in Search Filters (default ON = previous
     behaviour; OFF sends `inclcxl=N` → engine excludes `invoice_status='Cancelled'`).
  2. **GL Date from/to** filter (`glfrom`/`glto` on header `gl_date`).
  3. **Monthly trend re-based**: month basis is now `NVL(invoice_received_date,
     invoice_date)` (was `invoice_date`; 5,207 of 5,484 headers carry a received date)
     and the default window starts at the **current budget year** (Jan 1) — any explicit
     date facet (invoice/GL/received) restores the full filtered range (cap 60 months).
  4. **Chart drill-down on ALL 8 charts** — GL Budget-Utilization-style right-edge
     drawer (`.dw-*` in app.css): click any bar/slice/point → related invoice list
     (current facets + the clicked segment), wide default + ⤢ full-screen (Esc restores,
     then closes), CSV export w/ reconciliation footer, "top N of M" cap note (500),
     row click opens the invoice-detail modal ABOVE the drawer. New engine facets:
     `aging=<CURRENT|D1_30|D31_60|D61_90|D91_180|D180P>`, `esupplier=` (effective,
     beneficiary-aware — the top-suppliers bars), `rcvfrom/rcvto` (trend months),
     plus `glfrom/glto/inclcxl` (7 new `filtered_ids` params, 31 args total).
  5. **Maximize fixed**: `.ap-region { position:relative }` was declared AFTER
     `.ap-region--max { position:fixed }` at equal specificity, so the fixed positioning
     silently lost and the ⤢ button looked dead. Rules merged; region-max z lowered
     900 → 750 so drawers (760/761) and the platform modal (800) layer above it.
  6. **Chart hints**: ⓘ icon on every chart title (native tooltip, EN+AR) explaining
     content, date basis and criteria.
  **Item-only rule (reconciliation fix, user-reported)**: every distribution-grain
  analysis now counts **`distribution_type = 'Item'` rows only** — tax/freight dists
  carry unmapped cost centers and dragged classified invoices into sector
  'Unclassified' (facet said 4,887; Item-only truth = 78). Applied to all 10 dist
  facet scans in `dct_ap_pkg.filtered_ids`, the `/filters` dist-based LOVs + sector
  counts, and the `/summary` bySector dataset, so facet counts == KPIs == charts.
  The dist-level REGISTER still lists all dist rows of matching invoices (a register,
  not an analysis). Deploy order 02 → 03 → 04 (03 rebuilds ap.rest — 04 right after).
  DB verify: 31 pkg args, 7 handlers w/ new binds, item-only present in filters+summary;
  7/7 SQL reconciliation tests PASS (cxl 5484−406=5078; Unclassified 78=78; aging D1_30
  428=428; GL-date 1383=1383; rcv-month 1112=1112; esupplier 457=457). APP_VERSION 1.4.0.
- **2026-07-13 (round 4b + invoice window, v1.5.0)** — follow-ups to round 4:
  1. **Include Cancelled Invoices? now defaults to UNCHECKED** (cancelled excluded
     everywhere by default; ticking it shows a "Yes" chip). The **/filters facet
     counts + LOVs follow the checkbox** — every count/LOV query in the filters
     handler takes the `inclcxl` bind (`NULL/'Y'` = include for API back-compat;
     the frontend always sends it and re-fetches `/filters` on toggle, preserving
     the user's selections and open groups).
  2. **Received-date fallback = invoice CREATION date** (was invoice date):
     `COALESCE(invoice_received_date, created_date, invoice_date)` in the pkg
     rcv facets + the /summary trend (all 277 received-date-less headers have a
     created_date; 0 fall through to invoice_date).
  3. **Invoice window redesigned** (/senior-frontend + /frontend-design):
     document-style **master region** (big invoice number + effective supplier +
     type/beneficiary chips + grouped sections Supplier & references / Payment /
     Dates & audit) with a **Summary card top-right** (hero AED amount, FX line
     when non-AED, Paid/Balance/Tax rows, status badge stack, cancelled ribbon)
     and a **detail region with 2 tabs (Lines, Distributions)** — the old Header
     tab dissolved into the master region; **⤢ maximize** turns the window
     full-screen (`.inv-max`; Esc restores first, second Esc closes).
  Deploy 02 → 03 → 04; verify: filters/summary carry the new logic; SQL smoke —
  rcv-month 2026-05 engine 1,140 = direct 1,140 (moved from 1,112 under the old
  fallback), exclude-cancelled 5,078 = 5,078. APP_VERSION 1.5.0.
- **2026-07-13 (invoice window round 2, v1.6.0)** — user-review refinements:
  1. **Summary card fills the master-region height** (align-self stretch + flex column;
     the status stack anchors to the card foot). **Approval status: DATA GAP** — neither
     `AP_INVOICES` nor `ATD_AP_INVOICES` carries an approval-status column (checked
     `%APPR%/%WORKFLOW%` across all AP tables); the OTBI analysis must add Fusion's
     "Approval Status" field before it can be surfaced (then: view 05 + drill handler + card row).
  2. **Audit info collapsible** (collapsed by default) in the master region: created
     by/on + last updated by/on (drill handler now emits `lastUpdatedBy/lastUpdatedDate`)
     + cancelled by/on when present; the Dates section keeps invoice/GL/received dates only.
  3. **Distributions tab: full GL combination column** + GL-Actuals-style hover popover —
     the drill handler LEFT JOINs `dct_gl_coa_snap` on the (already canonical)
     `charge_account` and emits all 10 segment codes+descs; the popover lists them in the
     canonical Fusion order with descriptions (`.combo-tip`, z 950 above the modal; header
     ⓘ hint on the column). Snap join coverage 5,024/5,041 Item dists.
  Deploy: 03 → 04 re-run (02 untouched). APP_VERSION 1.6.0.
- **2026-07-13 (approval status, v1.6.1)** — user added `APPROVAL_STATUS` to
  `ATD_AP_INVOICES` via the OTBI analysis (data gap from the invoice-window round
  closed). Recovery-playbook flow: `prod.dct_views_rebuild` (15 pass-throughs,
  0 invalid — `ap_invoices` picks up the column) → 05 re-run (header view maps
  Fusion codes to display labels: WFAPPROVED→'Workflow Approved', else INITCAP;
  4,480 Workflow Approved / 496 Required / 407 Not Required / 79 Initiated /
  14 Rejected / 10 Stopped) → 03 → 04. Drill handler emits `approvalStatus`;
  the invoice-window Summary card gained the Approval badge row (`apprBadge`:
  approved=green, Rejected/Stopped=red, Not Required=idle, else amber).
  Facet/register column for approval status NOT added yet (only the Summary was
  requested). APP_VERSION 1.6.1.
- **2026-07-13 (UI polish, v1.6.2, frontend-only)** — Summary-card statuses show a
  glyph instead of the badge dot (✓ success / ✕ danger / ! warn / – idle; scoped
  `.inv-badges .badge::before` overrides the platform 5px dot). Audit-info chevron
  moved next to the label, brand-colored, larger (was far-right, barely visible).
  ALSO fixed a latent gap: `badge--success/--warn/--danger` were emitted by the VM
  helpers but never defined in ANY stylesheet (status pills rendered colorless
  platform-app-wide) — now defined in AP app.css with the platform soft palette,
  colouring the register/drawer/window badges everywhere. APP_VERSION 1.6.2.
- **2026-07-13 (sector reconciliation, v1.6.3)** — two corrections after user review:
  1. **Item-only rule was WRONG → non-tax rule.** PO-matched Item lines produce
     `Accrual` (+ Conversion rate variance / Retainage / Tax rate variance)
     distributions, NOT `Item` — 1,801 invoices had vanished from every dist-grain
     facet. All 10 pkg facet scans, the /filters dist LOVs and bySector now use
     `distribution_type NOT IN ('Recoverable tax','Nonrecoverable tax')` (= exactly
     the distributions of Item lines; tax rows stay excluded). Dist-grain coverage
     3,381 → 5,390 of 5,486 invoices.
  2. **Sector became a per-invoice CLASSIFICATION facet** (user: "for invoices that
     span more than one sector, show it as separate"): each invoice lands in exactly
     one bucket — its single sector, `(Multiple sectors)` (88), or `Unclassified`
     (93, incl. invoices with no distributions) — so the facet counts now SUM TO the
     invoices KPI (5,080 non-cancelled). Applied in lock-step to the pkg `p_sector`
     match (header LEFT JOIN + per-invoice bucket), /filters counts, the bySector
     chart dataset (amount = invoice's non-tax distributed AED), and the dists
     register/export sector predicate (a `(Multiple sectors)` selection passes its
     invoices' rows through). Deploy 02 → 03 → 04; combined facet query ~0.3s.
  Frontend: bySector ⓘ hint rewritten (EN/AR). APP_VERSION 1.6.3.
- **2026-07-13 (approval facet, v1.6.4)** — Approval Status added as a search
  criterion: `p_appr` facet in `filtered_ids` (multi, header `approval_status`
  display labels) + `appr=` bind in all 7 facet handlers; `/filters` gains the
  `approvalStatus` counted list (inclcxl-aware, placed after Accounting status);
  header register + CSV export gained the `approvalStatus` column (hidden by
  default, `appr` badge). Verified: facet Workflow Approved 4,480 = direct;
  multi-value `Rejected|Stopped` = 23. Deploy 02 → 03 → 04. APP_VERSION 1.6.4.
- **2026-07-13 (Fusion deep-links, v1.6.5, frontend-only)** — invoice numbers are
  links to Oracle Fusion (`fscmUI/faces/deeplink?objType=AP_VIEWINVOICE&action=VIEW
  &objKey=InvoiceId=<invoice_id>`; base URL in `config.js` `fusionInvoiceUrl`),
  opening in a NEW TAB (`target=_blank rel=noopener`; ↗ affordance). Applied in the
  AP Register (all 3 levels via the generic invoiceNumber cell — the anchor uses
  `click: return true` + `clickBubble: false` so the row-drill doesn't fire), the
  chart drill-drawer table, and the invoice window's big header number.
  APP_VERSION 1.6.5.
- **2026-07-13 (PO/PR deep-links + shared fusionLinks, v1.7.0)** — deep-link
  builders promoted to `shared/js/fusionLinks.js` (invoice / purchaseOrder /
  requisition / generic `link()`; contract in SHARED_JET_ARCHITECTURE.md —
  shared change ⇒ APP_VERSION bumped in ALL 11 apps). PR/PO numbers link to
  Fusion (PURCHASE_REQUISITION_LOBUSER / PURCHASE_ORDER deeplinks) wherever a
  single number shows: register line+dist levels, invoice-window Lines/Dists
  tabs (header-level PO/PR are comma-separated LISTAGGs — not linked). The
  deeplinks need the FUSION ids, so `AP/db/05` lines view gained `PO_HEADER_ID`
  and the dists view `PO_HEADER_ID`+`PR_HEADER_ID` (from `po_headers.po_header_id`
  / `pr_headers.pr_header_id`, 100%% populated) and 03 drill + 04 lines/dists emit
  `poHeaderId`/`prHeaderId`. Frontend: generic `cellLink(row,col)` drives the
  register/drawer anchors (invoice/PO/PR in one place); `config.fusionInvoiceUrl`
  retired. Deploy 05 → 03 → 04. APP_VERSION 1.7.0.
- **2026-07-13 (invoice-header PO/PR deep-links, v1.7.1)** — the invoice window's
  Supplier & References PO/PR fields (header level) are now links too: the 03
  drill handler emits `poRefs`/`prRefs` arrays of distinct `{num, id}` referenced
  documents (POs = UNION of lines+dists grouped by number, PRs from dists;
  `MAX(header_id)` per number), and the master region renders each number as a
  Fusion anchor (`foreach` over the refs, falls back to the plain LISTAGG string
  when a ref has no id). `openDrill` hoists `d.poRefs/prRefs` onto `d.header`
  because the region binds `with: header`. `.inv-reflist` wraps multi-document
  lists. Deploy 03 → 04 (03 rebuilds ap.rest). APP_VERSION 1.7.1, release
  20260713230157.
- **2026-07-13 (Beneficiaries dashboard, v1.8.0)** — NEW nav page `beneficiaries`:
  the full AP dashboard locked to the generic BENEFICIARY supplier (supplier
  number 26553), where the beneficiary name acts as the supplier name and the
  supplier SITE number as the beneficiary's supplier number. DB: `db/02` adds
  `p_suppnum` (multi, `supplier_number`) to `filtered_ids`; `db/03` threads
  `suppnum=` through /filters (every LOV/count scoped; the suppliers LOV lists
  EFFECTIVE supplier names under suppnum), /summary, /invoices (+`supplierSite`
  in rows + `Site` CSV column); `db/04` same for lines/dists (+exports) with a
  `supplierSite` header join. Frontend: `viewModels/beneficiaries.js` mounts the
  SAME `dashboard.html` via a nested `module` binding with
  `DashboardViewModel({benef:true, suppnum:'26553'})` — benef mode relabels
  Supplier→Beneficiary (register/facet/KPI/top chart/print, `ben.*` i18n EN+AR),
  swaps the Is-Beneficiary column for a visible Supplier No (site) column at all
  3 levels + drill drawer, maps the supplier facet to `esupplier=`, keeps its
  own column prefs (`ap.benef.cols`) and IR code (`AP_BENEF_REGISTER`), and
  prefixes exports `ap-beneficiaries-*`. Standard dashboard also gained a
  hidden-by-default *Supplier site* column. GOTCHA: `renderCharts` has a local
  `var tr = d.trend` — a constructor-level helper named `tr` gets shadowed there
  (was "tr is not a function"); the label-override helper is named `lt`.
  Deploy 02 → 03 → 04 (fresh sessions). Tests: `tests/benef_api_smoke.py` 18/18,
  `tests/api_smoke.py` regression 14/14, `tests/benef_browser_smoke.py` 24/24
  (scoped KPIs 2,604 invoices / 1,064 beneficiaries vs 5,080 unscoped).
  APP_VERSION 1.8.0. Web-tier release 20260713233720 LIVE 2026-07-13 (prod smoke: index 1.8.0, beneficiaries files 200, ORDS proxy 401 w/o token); pushed as c9a6170.
- **2026-07-13 (beneficiary-name enrichment, DB-only)** — user caught generic
  "BENEFICIARY" names still showing on the Beneficiaries dashboard: 429/2,727
  invoices of supplier 26553 arrive from Fusion with NULL `beneficiary_name`.
  Fix in `db/05_ap_views.sql`: all three `AP_*_V` views now derive the name
  from a `benef_site` map (per supplier_number+site `MAX(beneficiary_name)`
  where recorded — the site uniquely identifies the person) via
  `COALESCE(i.beneficiary_name, bs.beneficiary_name)`. One view-level fix
  covers the facet engine, /filters LOVs, registers, exports, charts and the
  drill with ZERO handler changes (no 03/04 re-run — handler source untouched;
  pkg recompiled by 05). Generic rows 429 → 4 (2 sites whose name was never
  recorded on any invoice). benef API smoke 18/18 + regression 14/14. No
  frontend change / no web-tier deploy needed.
- **2026-07-14 (beneficiary name PLATFORM-WIDE, DB-only)** — user caught the generic
  BENEFICIARY vendor on the GL Budget-Utilization AP drill. Full sweep of every
  surface that displays an AP-invoice vendor: NEW `db/v2/51_ap_supplier_eff.sql`
  `DCT_AP_SUPPLIER_EFF_V` (invoice_id → beneficiary-aware effective supplier w/
  same-site fallback) now joined by the GL butil AP drill (`GL/db/07` re-run),
  `DCT_UNPAID_INVOICES_V` (`db/v2/39` re-run → BUDGET_UTIL_SECTOR report) and
  `DCT_ACTUAL_V`'s AP branch (`db/v2/32`, surgical single-view redeploy). BI
  definitions scanned — only BUDGET_UTIL_SECTOR touches supplier (covered via 39).
  PO/GRN/PR surfaces show real suppliers (beneficiary payments are AP-direct).
  Live-verified: the reported invoice DCT2026MARSUP002 now returns
  "UAE AL WATHBA STABLES FSTVL BGT AC" from /gl/butil/lines?metric=ap.
- **2026-07-14 (rich chart/region hints, v1.9.0)** — the plain title-attr tooltips
  on the 8 chart ⓘ icons became a styled popover (`.ap-tip`: brand header +
  description + LIVE figures for the current filters), and the Analytics +
  Register region headings gained ⓘ hints too. Per-chart stats: aging
  (outstanding/overdue/unpaid count/largest bucket), payment (per-status
  count·amount + paid share), trend (months/total/peak/latest), validation +
  accounting (statuses/largest/share), top suppliers (count/#1/top-10 share),
  sector (buckets/#1/unclassified), pay group (groups/#1+share); regions show
  KPIs/level/rows/active-filter count. Benef mode reuses everything with its
  own labels + scope wording (`rg.*.hint`→`ben.*.hint` via LBL). 41 new i18n
  keys EN+AR. Playwright hint test 15/15 + browser smoke 24/24 on BOTH
  dashboards. APP_VERSION 1.9.0.
- **2026-07-14 (aging re-base + branded chart tooltips, v1.10.0)** — user-confirmed
  aging basis change: **due date = invoice received date (fallback created →
  invoice date) + payment-terms credit days** (`DCT_AP_PKG.terms_days` parses the
  first number in the terms name: Immediate→0, Net 30→30; the data has only those
  two values). NEW `DUE_DATE` column on `AP_INVOICES_HEADER_V` (05) is THE single
  source — the aging chart/facet (02), Overdue KPI, daysPastDue, register+CSV
  `Due Date` column and the invoice-window Payment section (03) all derive from
  it; terms_date remains displayed but is no longer the aging basis. Deploy
  02→05→03→04 (pkg body transiently INVALID between 02 and 05 — 05's COMPILE
  BODY fixes it). Validated: due_date exact for all 5,486 rows, aging buckets
  Σ == Outstanding KPI. Frontend: Chart.js data tooltips (hovering bars/slices/
  points) restyled to a branded white card via `tipOpts()` — title + labeled
  rows (Amount (AED) / Invoices / Share of total) + italic "Click to list the
  invoices" footer, on all 8 charts, both dashboards; hint-popover rows no
  longer join count·amount with an interpunct (user-reported unreadable) —
  counts sit in the label ("Paid (2,514 Invoices)"), amounts stay plain
  99,999,999.99. APP_VERSION 1.10.0; smokes 18/18 + 14/14 + browser 5/5.
- **Installments round (v1.14.0)** — new extract `ATD_AP_INVOICE_INSTALLMENTS` (key
  invoice_id + installment_number; due date, priority, per-installment payment method,
  vendor bank account, pay group, paid Y/N, on-hold, gross/unpaid amounts; ~9.7k rows,
  1 installment/invoice today but modelled 1..N). Added END-TO-END:
  `prod.ap_invoice_installments` pass-through (db/v2/32 + the dct_views_rebuild list in
  db/v2/38) → `AP_INVOICE_INSTALLMENTS_V` (05 — installment cols + header context;
  UNPAID_AMOUNT_IN_BASE_CURR arrives already AED, gross AED via the header ratio) →
  facet engine params `p_bank`/`p_duefrom`/`p_dueto` (02, one scan of the installments
  view intersected into the id-set) → ORDS: `bankAccounts[]` in /filters, the three new
  binds on EVERY filtered_ids call site (03+04 — so bank/due filters narrow KPIs, charts
  and all registers), NEW `GET /ap/installments` + `/ap/installments/export` (04 part 6 —
  own-grain bank/due re-applied to rows; totals = gross AED + unpaid AED; ap.rest now
  12 templates/12 handlers), drill `/invoices/:id` ships `installments[]` (03 part 5) →
  frontend: 4th **Installment** detail-level radio (COLS.inst catalog, IR/print/exports/
  column-chooser all metadata-driven), **Vendor bank account** searchable facet (2,238
  accounts), **Installment due date** from/to range, drill modal **Installments** tab.
  GOTCHA: a new register level must be added to the per-level `_hidden` column map +
  `applyColPrefs`/`persistCols` lists in dashboard.js or `visibleCols` throws and the
  level never loads. API smoke 6/6 (facet consistency: bank filter narrows installments/
  invoices/KPIs identically) + browser smoke 5/5.
  The **Beneficiaries dashboard inherits the whole round automatically** (same
  DashboardViewModel, locked suppnum): Installment level shows Beneficiary +
  Supplier No columns (the benef column swap applies to the new level), the
  bank-account facet LOV is beneficiary-scoped (suppnum honored in /filters —
  1,268 accounts), due-date range + drill tab work; browser-verified 4/4.
- **2026-08-11 (AI dup-check criteria + guard, v1.17.0)** — user requirements on the
  AI Duplicate Check page: ① Run-criteria region — Include FAB DEBIT CARD vendors
  (effective-name prefix match, default EXCLUDED), Include cancelled invoices
  (default EXCLUDED), Invoice created from/to (CREATED-date window). Applied in 06
  to the entry list, bank-account map, sharedAccounts and the runid+grp drill;
  persisted on DCT_AP_AI_DUP_RUN (incl_fab/incl_cxl/created_from/created_to) and
  echoed by both envelopes + the page run line. ② Short explanation per finding:
  "Why flagged:" on every AI group (prompt demands concrete evidence + shared-
  account last-4; VM fallback) and on every shared-account block (deterministic).
  ③ SELF-PAIR GUARD: DISTINCT ids per AI group — run 21 had 29 groups of ONE
  entry repeated (ids like [57,57]) with doubled invoice/amount totals (the
  user-reported HANA ABDULWAHAB M ZAKRI case). ④ SALVAGE parser: responses
  truncated at the provider output-token ceiling (~1,360 entries now) are trimmed
  to the last complete group + control-chars normalised instead of erroring.
  Deploy: 06 re-run (fresh session). Fresh run 41: 1,360 analysed, 122 groups,
  0 self-pairs, 0 FAB vendors, all reasons cite evidence; API 7/7 + browser
  13/13. APP_VERSION 1.17.0.
- **2026-08-12 (reason-category sections, v1.18.0)** — user requirement "group all
  related cases with same reasons in separate group": every AI group now ships
  `reasonType`, derived server-side by `dct_ap_ai_pkg.reason_type` (published in
  the spec) — deterministic keyword classification of the ENFORCED reason format,
  so it categorises STORED runs retroactively with no new AI call. Vocabulary
  SPELLING/TRANSLITERATION/SPACING/CAPITALISATION/WORD_ORDER/TYPO/ABBREVIATION/
  PARTIAL_NAME/COMPANY_SUFFIX/NAME_VARIATION/SHARED_ACCOUNT/OTHER; variation
  types are checked BEFORE the account keyword ("spelling, shared account 1234"
  = SPELLING — first deploy without that precedence put 120/122 groups in
  SHARED_ACCOUNT). Prompt now forbids the generic phrase "name variation" and
  demands the specific type. Page renders the group cards clustered under one
  `.ai-sec` band per category (label + "N groups" pill + combined invoices/AED);
  CSV gains a Finding-type column; 12 `ai.rt.*` keys EN+AR. Deploy: 06 re-run
  (fresh session, twice — classifier precedence fix), frontend + APP_VERSION
  1.18.0. Fresh run 43: 115 groups over 9 categories (58 partial-name /
  34 capitalisation / 5+5+5 spelling·typo·spacing / 4 account-only / 2 word-order
  / 1+1), 0 self-pairs; sections smoke 12/12 EN+AR.

## 2026-09-06 — LINE-GRAIN PO RULE: AP/db/04 + 05 re-run

Platform rule (CLAUDE.md, user-approved): a Fusion PO-match correction updates the invoice
LINE; the accounted distributions keep the ORIGINAL PO — so the dist register/export
handlers (04) and AP_INVOICE_DISTRIBUTIONS_V (05) now resolve the effective charge account
and PO-header attribution through COALESCE(invoice-line PO refs, dist PO refs) (new lgp/lp
invoice-lines join; the view exposes d.line_number AS invoice_line_number — the 04 handlers
join on that alias). Deployed: 05 re-run + dct_ap_pkg body recompile + 04 re-run (SQLcl
gotcha: @ paths containing "final apps" MUST be double-quoted or SQLcl truncates at the
space). Displayed raw po_number columns still show the extract's dist-grain value by
design — only joins/attributions are corrected. Smoke: /ap/dists OK.
