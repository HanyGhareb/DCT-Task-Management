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
  db/      01 DDL · 02 lookups · 03 DCT_RPT_PKG · 04 ORDS (/ords/admin/rpt/) · 05 scheduler · 06 native (P3) · 07 seed · 08 Budget-Util-by-Sector (MULTI) · 09/09a workers · 10 param spec + LOV endpoint · 20/20a report templates (DCT_RPT_TEMPLATE + /rpt/templates*) · install.sql
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
`GET/POST reports/` · `GET/PUT/DELETE reports/:code` · `POST reports/:code/run` (optional JSON body =
run parameters, e.g. `{"year":2026,"sector":"Tourism"}`; absent/`{}` keeps the definition defaults) ·
`GET runs/` · `GET runs/:id` · `GET runs/:id/output/:fmt` (authed download) · `POST runs/:id/retry` ·
`GET/POST schedules/` · `PUT/DELETE schedules/:id` · `POST schedules/sync` ·
`GET/POST recipients/` · `PUT/DELETE recipients/:id` · `GET/PUT config` · `GET meta` ·
`GET workers/` + `POST workers/command|remove|reclaim|job` (worker registry + queue + scheduler jobs) ·
`GET templates/` + `GET/PUT/DELETE templates/:name` (DB-stored PDF templates; PUT = raw-binary body)

## Status
- **Phase 0 (control plane):** ✅ DEPLOYED to PROD 2026-06-30 — 14 objects VALID, `rpt.rest` PUBLISHED,
  27 lookups, 12 config keys, pilot `GL_BUDGET_ACTUAL` seeded, enqueue→claim→mark smoke test passed.
- **Phase 1 (Python engine):** ✅ BUILT + VERIFIED E2E 2026-06-30 — `reporting/runner/` (Jinja2→Chromium
  PDF + openpyxl Excel + smtplib). Pilot run produced a valid 846 KB PDF + 195 KB XLSX from 3313 rows.
  Setup: `python -m venv .venv` → `pip install -r requirements.txt` → `playwright install chromium` →
  copy `env.ps1.example`→`env.ps1`. Run: `python runner.py --run GL_BUDGET_ACTUAL`.
- **Phase 2 (UI):** new **"BI - Reporting"** module app under `final apps/BI/` (SYS_ADMIN-gated).
- **Phase 3 (native engine):** `06_rpt_native_pkg.sql` (APEX_DATA_EXPORT + APEX_MAIL).
- **Multi-section reports (2026-07-02):** source type **`MULTI`** — `source_ref` is JSON
  (`{orientation, required[], sections:[{key,title,layout,sql}]}`); the Python engine runs every
  section with the shared params and renders a per-definition template (`pdf_template` column), a
  one-sheet-per-section workbook, and a sectioned CSV. First report: **`BUDGET_UTIL_SECTOR`** —
  6-part executive Budget Utilization by Sector pack (overview KPIs · utilization rows · unpaid /
  partially-paid invoices · uninvoiced GRN · open POs · reserved PRs; landscape PDF, grouped
  Actual/Encumbrance headers, reconciling totals). Params: `year` + `sector` required,
  `projecttype` + `costcenter` optional. Data views: `db/v2/39` over the GL actuals layer.

- **Word (.docx) report templates — GUI-manageable layouts (2026-07-07):** report PDF layouts are
  now **DB-stored** (`DCT_RPT_TEMPLATE`, `reporting/db/20` + `/rpt/templates*` endpoints `20a`) and
  managed from the BI app's **Templates** page (upload/replace/download/delete + authoring guide;
  report editor gets a PDF-template dropdown). Two kinds by extension: **`.docx`** — authored in
  Microsoft Word with Jinja2 tags (same variables + new `data` rows-as-dicts), rendered by
  **docxtpl** and converted by **headless LibreOffice** on the worker (`runner/render_docx.py`;
  page size/orientation come from the Word doc itself); **`.j2`** — the existing Jinja2-HTML →
  Chromium path, now ALSO loaded DB-first with bundled-file fallback. A template save applies on
  the next run on every worker — no redeploy. Starter file `report_starter.docx` + the two bundled
  `.j2` are seeded by `runner/upload_template.py --seed` (direct-DB or `--ords`). Workers need
  `docxtpl` + `libreoffice-writer` + Noto Arabic fonts (deploy_worker.sh installs them).
  docxtpl gotcha: each `{%tr%}`/`{%tc%}` loop tag must sit in its OWN table row/cell.

- **Budget Utilization Briefing Book (2026-07-08):** `BUDGET_UTIL_BOOK` (`reporting/db/21`) —
  executive "briefing book" PDF over the same GL utilization layer: professional cover
  (scope + "Prepared by Financial Planning and Budgeting — Finance Department") + contents page,
  Part 1 overview (KPI tiles, budget-composition stacked bar, utilization-by-sector bars, sector
  rollup + top-15 pressure lines), Part 2 the FULL actuals register (all direct AP invoices + all
  GRN receipts, monthly AP-vs-GRN trend, top-10 supplier bars), Part 3 open obligations
  (GRN-netted PO lines), Part 4 open commitments (reserved PRs), Part 5 auto-computed
  observations (pacing vs calendar, pressure, supplier concentration, pipeline, uninvoiced
  deliveries) + methodology. MULTI/PYTHON, 7 sections over `dct_budget_utilization_v` +
  db/v2/39 detail views (GRN receipts inlined — the 39 view keeps only uninvoiced balances);
  charts are pure CSS/HTML in `runner/templates/budget_util_book.html.j2` (Chromium PDF, also
  DB-stored). Params: `year` REQUIRED; `sector`/`projecttype`/`costcenter` optional (empty
  sector = whole organisation). E2E: 2026 all-sectors → 273-page PDF, 8,661 lines. Template
  gotcha: Jinja `truncate` needs `|string` first — numeric columns (PR numbers) raise
  "object of type 'int' has no len()".

Plan: `.claude/plans/i-want-to-find-agile-steele.md`. Word-templates plan: `docs/DOCX_TEMPLATES_PLAN.md`.
