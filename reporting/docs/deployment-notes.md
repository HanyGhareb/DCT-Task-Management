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
