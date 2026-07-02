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
