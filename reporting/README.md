# i-Finance Reporting Platform

Free, professional **PDF + Excel** report generation with **scheduling** and **emailed delivery**
(attachments + formatted, dynamic-variable body) over the i-Finance Oracle data.

One **shared DB control plane** drives **two pluggable engines** — a report definition's `engine`
column routes execution:

| Engine | How | Best for |
|---|---|---|
| **PYTHON** (Solution 2) | `reporting/runner/` microservice — Jinja2 → Playwright/Chromium PDF + openpyxl Excel, SMTP email | branded / charted executive reports |
| **NATIVE** (Solution 1) | in-DB `DCT_RPT_NATIVE_PKG` — `APEX_DATA_EXPORT` + `APEX_MAIL` (Phase 3) | tabular operational reports, zero extra infra |

Schedules, recipients, run history, generated outputs, delivery status, and the UI-editable
runtime/SMTP config are written **once** and serve both engines. Everything is operated from the
Admin **Reports** page (Phase 2).

## Layout
```
reporting/
  db/      01 DDL · 02 lookups · 03 DCT_RPT_PKG · 04 ORDS (/ords/admin/rpt/) · 05 scheduler · 06 native (P3) · 07 seed · install.sql
  runner/  Python microservice (Phase 1)
  docs/    deployment-notes.md · functions_list.md
  tests/   render + e2e
```

## Control-plane tables (PROD)
`DCT_RPT_DEFINITION` · `DCT_RPT_SCHEDULE` · `DCT_RPT_RECIPIENT` · `DCT_RPT_RUN` ·
`DCT_RPT_OUTPUT` (output BLOBs) · `DCT_RPT_DELIVERY` · `DCT_RPT_CONFIG` (UI-editable; SMTP password
stays in `env`).

## Deploy (Phase 0) — run as the DBA, FRESH SQLcl session
SQLcl silently skips LF-only files, so the scripts ship **CRLF + UTF-8 (no BOM)**. Set
`JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8` so the Arabic lookup seeds store cleanly.

```powershell
$env:JAVA_TOOL_OPTIONS = '-Dfile.encoding=UTF-8'
cd reporting/db
C:\claude\tools\sqlcl\sqlcl\bin\sql.exe -name prod_mcp
-- at the SQL> prompt:
@install.sql
EXEC prod.dct_rpt_sched_sync;   -- build schedule jobs (none enabled by default)
```
Order matters: DDL → lookups → package → ORDS → scheduler → seed. The ORDS/synonym scripts must
**not** follow an `ALTER SESSION SET CURRENT_SCHEMA=PROD` (ORA-01471 self-reference).

## API — `/ords/admin/rpt/` (SYS_ADMIN only)
`GET/POST reports/` · `GET/PUT/DELETE reports/:code` · `POST reports/:code/run` ·
`GET runs/` · `GET runs/:id` · `GET runs/:id/output/:fmt` (authed download) · `POST runs/:id/retry` ·
`GET/POST schedules/` · `PUT/DELETE schedules/:id` · `POST schedules/sync` ·
`GET/POST recipients/` · `PUT/DELETE recipients/:id` · `GET/PUT config` · `GET meta`

## Status
- **Phase 0 (control plane):** ✅ DEPLOYED to PROD 2026-06-30 — 14 objects VALID, `rpt.rest` PUBLISHED,
  27 lookups, 12 config keys, pilot `GL_BUDGET_ACTUAL` seeded, enqueue→claim→mark smoke test passed.
- **Phase 1 (Python engine):** ✅ BUILT + VERIFIED E2E 2026-06-30 — `reporting/runner/` (Jinja2→Chromium
  PDF + openpyxl Excel + smtplib). Pilot run produced a valid 846 KB PDF + 195 KB XLSX from 3313 rows.
  Setup: `python -m venv .venv` → `pip install -r requirements.txt` → `playwright install chromium` →
  copy `env.ps1.example`→`env.ps1`. Run: `python runner.py --run GL_BUDGET_ACTUAL`.
- **Phase 2 (UI):** new **"BI - Reporting"** module app under `final apps/BI/` (SYS_ADMIN-gated).
- **Phase 3 (native engine):** `06_rpt_native_pkg.sql` (APEX_DATA_EXPORT + APEX_MAIL).

Plan: `.claude/plans/i-want-to-find-agile-steele.md`.
