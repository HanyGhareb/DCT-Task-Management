# Reporting Platform — Deployment Notes

Runbook + history for the i-Finance Reporting Platform (`reporting/`). See the canonical platform-wide
SQLcl/ORDS rules in `final apps/Admin/docs/deployment-notes.md` §2.

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
