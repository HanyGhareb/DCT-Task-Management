# Reporting Platform — Word (docxtpl) Report Templates — PLAN

**Goal:** let business users design and change PDF report layouts **in Microsoft Word** — no
developer, no worker redeploy. A report definition's `pdf_template` can point at a `.docx`
template stored **in the database**; the Python engine renders it with docxtpl (same Jinja2
variables as today) and converts to PDF with headless LibreOffice on the worker VMs.
The existing `.j2` HTML → Chromium path stays untouched and remains the default.

**Status (2026-07-07):** EXECUTED — Phases A/B/C/E/F DONE (DB `20` + ORDS `20a` deployed to PROD,
API pytest 12/12; runner docxtpl path unit-tested 4/4 incl. a real LibreOffice conversion; 3
templates seeded via `--seed --ords`; BI Templates page + editor dropdown browser-smoked 13/13,
APP_VERSION 1.10.0). **Phase D DONE 2026-07-08** — all 3 workers updated (docxtpl + LibreOffice +
Noto Arabic fonts) and **E2E on the fleet PASS**: 20-row docx run instant; 3,326-row run SUCCESS in
~4 min via the new `DOCX_PDF_TIMEOUT_SEC` config (480; LibreOffice table layout is slow on huge
tables — keep very large tabular reports on `.j2`). NOTE: scripts renumbered 19/19a → **20/20a**
(same-day collision with `19_rpt_test_email_python.sql`).

---

## Why docxtpl

- Template GUI = Word itself (users already have it); logos, fonts, headers, page
  orientation, RTL/Arabic all come from the document — no code editor UI to build.
- Same Jinja2 placeholder syntax already used in email subject/body templates
  (`{{ report_name }}`, `{% for r in data %}…{% endfor %}`).
- Fits the existing PYTHON engine: one new render module + a branch in `process()`.
- Templates stored in DB ⇒ saving a template in the BI app takes effect on the next run
  on **all** workers — kills the current "edit file + redeploy worker" loop.
- NATIVE engine unaffected.

## Scope decisions (proposed)

- Template storage = new `DCT_RPT_TEMPLATE` table (name-keyed BLOBs), NOT `DCT_DOCUMENTS`
  (`DCT_DOCUMENTS` is request-artifact oriented: `source_module/source_type/source_id`).
- `.j2` HTML templates ALSO become DB-loadable (DB-first, bundled-file fallback) so both
  kinds are UI-manageable; the two bundled files get seeded into the table.
- New `DOCX` output format (deliver the rendered Word file itself): **OUT of scope** —
  stretch item only (needs RPT_FORMAT lookup + UI churn).
- WYSIWYG in-browser editing: out of scope — the GUI is Word; the BI app manages
  upload/download/assign.

---

## Phase A — DB (`reporting/db/20_rpt_templates.sql`)

New table (PROD) + ADMIN synonym:

```
DCT_RPT_TEMPLATE (
  template_name  VARCHAR2(200) PK,   -- exact value used in dct_rpt_definition.pdf_template
  description    VARCHAR2(400),
  mime_type      VARCHAR2(120),
  content        BLOB NOT NULL,
  file_size      NUMBER,
  enabled        CHAR(1) DEFAULT 'Y',
  created_by/at, updated_by/at
)
```

- Template kind derived from the name extension (`.docx` vs `.j2`) — no enum column, no
  new lookup set needed.
- Seed `DCT_RPT_CONFIG` key `TEMPLATE_MAX_MB` (default 10) for the upload guard.
- Script rules: `SET DEFINE OFF`, `SET SQLBLANKLINES ON`, CRLF, UTF-8 no BOM,
  keyword-free banners, `prod.` qualification; idempotent (ORA-955 swallow / MERGE).
- Seeding the two bundled `.j2` files + a starter `.docx` cannot be done in SQL —
  done by the uploader utility in Phase C (via the PUT endpoint).

## Phase B — ORDS (`reporting/db/20a_rpt_templates_ords.sql`, ADDITIVE)

New paths only (no collision with `reports/ runs/ schedules/ recipients/ config meta
workers/ ir/`), `DEFINE_TEMPLATE` + `DEFINE_HANDLER`, SYS_ADMIN-gated via
`validate_session`, run in a FRESH SQLcl session:

| Method/Path | Purpose |
|---|---|
| `GET  /rpt/templates/` | list: name, description, size, mime, updatedBy/At + `usedBy` count from `dct_rpt_definition.pdf_template` |
| `GET  /rpt/templates/:name` | authed BLOB download |
| `PUT  /rpt/templates/:name` | raw-binary upload/replace — `l_blob := :body` (**deref `:body` exactly once**), `TEMPLATE_MAX_MB` guard → 413, description/mime via query string (binary-upload contract, like `/photobin`) |
| `DELETE /rpt/templates/:name` | delete; **409** if any definition references it |

- Error mapping: −20401→401, −20403→403, −20404→404, −20001→400, else 500.
- **Canonical re-run list after any 04 re-run becomes: 08b, 09a, 10, 12b, 19, 20a** —
  update `install.sql` footer note, README, deployment-notes.

## Phase C — Runner (`reporting/runner/`)

1. `requirements.txt` += `docxtpl>=0.16` (pulls python-docx).
2. New `render_docx.py`:
   - `build_pdf_from_docx(conn, template_name, ctx)` — fetch BLOB from
     `dct_rpt_template`, `DocxTemplate.render(ctx, jinja_env)` (same `fmt` filter /
     `num` test), save temp `.docx`, convert via
     `soffice --headless --convert-to pdf --outdir <tmp>` (subprocess, timeout,
     serialized with a lock — LibreOffice dislikes concurrent profiles), return PDF bytes.
3. `render_pdf.py`: Jinja2 loader becomes **DB-first** (`ChoiceLoader`: FunctionLoader
   over `dct_rpt_template` → existing `FileSystemLoader` fallback) so `.j2` edits in the
   UI also apply without redeploy.
4. `runner.process()`: branch on `pdf_template` extension — `.docx` → docx path
   (landscape/A4 come from the Word doc's own page setup — removes the "single-source
   is always portrait" limitation); else existing Chromium path.
5. **Word-author-friendly context**: add `data` = list of row **dicts** (lower-case
   column keys) and, for MULTI, `section.data` per section — `{% for r in data %}
   {{ r.sector_name }} {{ r.budget_ytd|fmt }} {% endfor %}` instead of tuple indexing.
   Existing keys (`report_name`, `params`, `meta`, `generated_at`, `headers`,
   `rows`, `sections`, `totals`…) unchanged.
6. `upload_template.py` utility (uses the PUT endpoint): seeds `report.html.j2`,
   `budget_util_sector.html.j2`, and a generated starter `report_starter.docx`
   (title + params + data table — the Word twin of `report.html.j2`).
7. Unit tests (`tests/test_render_docx.py`): render starter docx from a sample ctx,
   assert placeholder substitution + PDF magic bytes (skip-if-no-soffice guard).

## Phase D — Worker rollout (atd-vm180/181/182)

- `deploy_worker.sh`: install `libreoffice-writer` (headless) + **fonts** —
  Liberation + a Noto Arabic font (needed or Arabic PDFs render as boxes); pip install
  new requirements; restart `rpt-worker.service`.
- Redeploy all three workers once. After this, template changes never require a redeploy.
- Fidelity note: LibreOffice ≈ Word rendering, not pixel-identical — validate the
  starter template output; keep templates to standard fonts/tables.

## Phase E — BI app UI (`final apps/BI/Jet/`, APP_VERSION → next minor)

1. **New Templates view** (SYS_ADMIN nav): `views/templates.html` +
   `viewModels/templates.js` — platform classes only (`.data-table`, `.page-header-row`
   + `.page-actions`, edit-drawer). List (name, kind badge, size, updated, used-by);
   top-right **Upload** (file input → `api.putBinary`, accept `.docx,.j2`);
   row actions: Download (`api.fetchBlobUrl`), Replace, Delete (guarded).
   A "How to author" help drawer documents the available variables (`data`, `params`,
   `sections`, `fmt`…) with copy-paste snippets.
2. **reportDetail**: `pdfTemplate` free-text field → **dropdown** of DB templates
   (+ blank = engine default `report.html.j2`).
3. i18n: every new `t()` key in BOTH `app.en.json` + `app.ar.json`; router/nav entry.
4. No `final apps/shared/` change anticipated ⇒ bump BI `APP_VERSION` only
   (current 1.9.3). If anything shared moves, bump all 10 consumer apps.
5. Update `final apps/BI/docs/functions_list.md` (new view section + 4 endpoints) in the
   same change.

## Phase F — Tests, UAT, docs

- **API pytest**: templates CRUD happy/edge/error (401 no token, 403 non-admin,
  404 unknown, 413 oversize, 409 delete-in-use, boundary at TEMPLATE_MAX_MB).
- **E2E (Playwright, webapp-testing)**: upload starter docx → assign to a test
  definition → Run → run history SUCCESS → download PDF, assert size/magic; repeat
  with an edited template to prove no-redeploy pickup.
- **UAT**: next global-sequential BI round folder
  `final apps/BI/UAT/UAT_BI_round<N>-dd-mm-yyyy/` via the `uat_run_bi.py` pattern;
  never overwrite a prior round.
- **Docs**: `reporting/README.md`, `reporting/docs/deployment-notes.md` (new re-run
  list + LibreOffice/font install gotchas), `install.sql`, CLAUDE.md BI row, memory.

## Deployment order (one line)

20 → 20a (fresh session) → pip/systemd rollout on the 3 workers → seed templates via
`upload_template.py` → BI frontend ship (APP_VERSION bump) → E2E → UAT round.

## Risks / gotchas carried in

- `:body` single-deref (PLS-00382) on the PUT handler.
- LibreOffice conversion fidelity + missing-font Arabic boxes → install Noto Arabic.
- Concurrent soffice conversions on one VM → serialize with a lock file
  (same pattern as `.otbi_runner.lock`).
- DEFINE_TEMPLATE only on NEW URI templates (existing-template redefinition drops
  sibling handlers).
- ORDS re-run list grows to 08b/09a/10/12b/19/**20a**.
- docx templates bypass Jinja2 autoescape by design (Word XML) — docxtpl handles
  escaping; never feed raw HTML into a docx variable.
