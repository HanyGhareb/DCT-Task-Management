# ATD Loader (App 208) — Build Plan

**Module:** OTBI → ATD automation **control plane** (configure jobs/envs/targets, enqueue runs,
monitor the shared queue + run logs). The `otbi-atd/runner/` workers stay the executors; this app
is the management UI over the **same control tables**.

**Status:** PLAN — awaiting approval. Build layer-by-layer (DB → ORDS → frontend → docs/UAT),
deploying + verifying each layer before the next.

---

## 0. Scope & approach
- **In scope:** full CRUD on Jobs / Environments / Targets; queue control (Enqueue / Reset /
  Reap); dashboards; run-log browsing + CSV export. All actions are **DB-only** operations, so
  they work from ORDS with no browser.
- **Explicitly NOT in scope:** running a Track-B job from the browser (needs MFA on a host). The
  app **Enqueues** (`run_status='READY'`); worker hosts running `--worker` pick the jobs up. The
  app shows `claimed_by` / `claimed_at` so you can see which host is working what.
- **Reuses:** the shared platform (shell, `platform.css`, EN/AR i18n, tri-state lists, Chart.js,
  `regionPicker`, top-right action buttons) and App 200 session — exactly like PC/DT/HR/CC/TM.
- **Admin-only:** only admins manage automation (gate on the admin role in every handler).

## 1. Identity & scaffold
| Field | Value |
|---|---|
| App number | **208** |
| module_code | **ATD** |
| App name | **Analytics Loader** (OTBI → ATD) |
| Brand colour | **`#3A4FB0`** (indigo; ops/automation console) — configurable via `THEME_BRAND_COLOR` |
| ORDS base | `/ords/admin/atd/` |
| Package(s) | **`atd.rest`** (thin CRUD + queue/log endpoints); reuses **`ATD_QUEUE_PKG`** (enqueue/reap/claim) |
| Folder | `final apps/ATD/` (`Jet/`, `docs/`, `UAT/`, `guides/`, `STATUS.md`, `ATD_PLAN.md`) |

**Deviation from the standard checklist (intentional):** the ATD **DB lives in `otbi-atd/db/`**
(control tables 01, ordering 11, queue 12). So the new backend scripts go there too —
`otbi-atd/db/13_atd_rest_pkg.sql` + `otbi-atd/db/14_atd_ords.sql` — not under `final apps/ATD/db/`.
The JET app, docs, UAT live under `final apps/ATD/`. Register App 208 in `shared/js/shell.js`
MODULES, `shared/i18n/common.{en,ar}.json`, every app's `dev-proxy.py` `SIBLING_APPS`, and the
CLAUDE.md Module Status table.

## 2. Auth & shell (shared session — no private login)
- Redirect to `../Admin/Jet/index.html` when no `ifinance_jet_session`; only Admin writes it.
- Scrub all copy artifacts (login cube/title/subtitle, `authService` header, `config.js`
  `apiBase=/ords/admin/atd`, `authBase=/ords/admin/dct`).
- `window.APP_VERSION` bump on every frontend deploy; a `shared/` change bumps all apps.

## 3. Frontend views (7) — platform classes only
Each maps to `Jet/js/views/<x>.html` + `viewModels/<x>.js`. Use `.form-grid`/`.data-table`/
`.modal-*`/`.btn`/`.card`/`.badge`/`.section-heading-row`+`.region-actions`; **no bespoke markup**;
action buttons top-right; bind nullable fields as `$data.field`.

| # | View (vm) | Contents | Actions |
|---|---|---|---|
| 1 | **dashboard** | KPIs (jobs, enabled, success-rate, last cycle); queue-state donut (READY/CLAIMED/DONE/FAILED) via Chart.js; recent runs; truncation alerts | refresh |
| 2 | **jobs** | table: job, env, target, source_ref, stage_table, priority, run_order, enabled, run_status, claimed_by, last run | add, edit, enable/disable, **Enqueue**, **Reset**, open detail |
| 3 | **jobDetail** | all job fields; `column_map_json` (CSV header→col) editor; `params_json`; this job's run history | save, enqueue, back |
| 4 | **environments** | CRUD `ATD_OTBI_ENV` (pod URL, xmlpserver, credential_ref, auth_type, extract_track, enabled) | add, edit, enable/disable |
| 5 | **targets** | CRUD `ATD_TARGET_DB` (db_kind, schema, db_link, tns_alias, enabled) | add, edit, enable/disable |
| 6 | **runs** | run-log table; filters job/status/from-to; detail modal (message, rows, checksum, started/finished, track) | filter, view, **export CSV** |
| 7 | **queue** | per-job claim state + last worker; global ops | **Enqueue all**, **Reap stale**, set lease |

## 4. Functional completeness
- Jobs/envs/targets get **full UI CRUD** (create/edit/remove, enable/disable inline).
- Pickers from real data: env + target dropdowns on the Job form (from `/atd/lookups`).
- Audit: enqueue/reset/reap and config edits are visible via `run_status`/`claimed_*` + run logs.

## 5. i18n
- Every `t('atd.…')` key in **both** `Jet/js/i18n/app.en.json` + `app.ar.json`; `mod.atd`(+`.desc`)
  in `shared/i18n/common.{en,ar}.json`. Latin digits; RTL verified.

## 6. Database — `otbi-atd/db/13_atd_rest_pkg.sql`
- **`atd.rest`** thin package: `validate_session(:body)` + admin check at the top of every
  protected handler; `parse_body`; JSON out via `APEX_JSON`; error mapping
  `-20401→401/-20403→403/-20404→404/-20001|-20090→400/else 500`.
- Reuses **`ATD_QUEUE_PKG`** for `enqueue` / `reap_stale`; reset = `UPDATE run_status='READY'`.
- Lookup-first, `SET DEFINE OFF`/`SET SQLBLANKLINES ON`, CRLF/UTF-8 no-BOM, schema-qualified.
- ADMIN→PROD synonyms for every PROD object the handlers touch; ORDS script
  (`14_atd_ords.sql`) run in a **fresh** SQLcl session (ORA-01471 rule).

## 7. ORDS endpoints (`/ords/admin/atd/`)
| Method | Path | Purpose |
|---|---|---|
| GET | `/atd/dashboard` | KPIs + queue counts + recent runs |
| GET | `/atd/lookups` | envs + targets for form pickers |
| GET/POST | `/atd/jobs` · `/atd/jobs` | list / create job |
| GET/PUT/DELETE | `/atd/jobs/:name` | read / update / delete job |
| POST | `/atd/jobs/:name/enqueue` · `/atd/jobs/:name/reset` | queue one / reset one |
| POST | `/atd/enqueue` · `/atd/reap` | enqueue all · reap stale |
| GET/POST | `/atd/envs` · `/atd/envs` | list / create env |
| PUT/DELETE | `/atd/envs/:name` | update / delete env |
| GET/POST | `/atd/targets` · PUT/DELETE `/atd/targets/:name` | targets CRUD |
| GET | `/atd/runs` | run log (filters: job, status, fromdt, todt, paging) |
| GET | `/atd/runs/:id` | one run detail |
| GET | `/atd/runs/export` | run log CSV |

## 8. Testing & UAT (Admin convention)
- PL/SQL unit (standalone assert harness): claim/enqueue/reap idempotency; admin-gate denials.
- API (pytest): each endpoint Happy / 400 / 401 / 403 / 404; job CRUD round-trip; enqueue flips
  `run_status`; runs filters + CSV.
- System/E2E (Playwright, webapp-testing): add→edit→enqueue→see status; run-log filter+export;
  env/target CRUD; EN/AR + RTL.
- UAT package in Admin layout: master `UAT/UAT_ATD_TestScript.xlsx`; per-round folder
  `UAT/UAT_ATD_round1-dd-mm-yyyy/` (dated workbook + Word results + `evidence_*`).
- Regression: confirm the runner still claims/loads after the new endpoints exist (shared tables).

## 9. Documentation
- `final apps/ATD/docs/deployment-notes.md` (deploy checklist + history), `docs/functions_list.md`
  (views/methods/services + ORDS table), `STATUS.md`, `guides/`. Update memory + CLAUDE.md Module
  Status row when it ships. Update `otbi-atd/docs/REFERENCE.md` to point at the management app.

## 10. Build order (each deployed + verified before the next)
1. `13_atd_rest_pkg.sql` (atd.rest) + synonyms → compile VALID.
2. `14_atd_ords.sql` (fresh session) → smoke each endpoint with a Bearer token.
3. JET scaffold (config/shell/i18n/services) → login redirect + boot.
4. Views 1–7 → live CRUD + enqueue + logs.
5. Docs + UAT round 1.

## 11. Open risks / notes
- **Run-log messages** can contain stack traces — admin-only mitigates exposure; truncate in UI.
- **Delete guards:** block deleting an env/target still referenced by a job (FK already enforces;
  surface a friendly 400).
- **`column_map_json` editing** is power-user; provide a JSON validate + a key/value helper, not a
  raw textarea only.
- The app **enqueues**; actual runs need a worker host scheduled/running — dashboard should show
  "last worker seen" so an all-`READY`-but-nothing-moving state is obvious.
