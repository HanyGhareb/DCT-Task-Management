# BI - Reporting (App 211) — Functions List

User-facing functions of the BI - Reporting JET app (`final apps/BI/Jet/`), grouped by view. Each area
maps to `Jet/js/views/<x>.html` + `Jet/js/viewModels/<x>.js`; each bullet is a public `self.<method>`.
SYS_ADMIN-gated; consumes the Reporting Platform ORDS module `/ords/admin/rpt/`.

## Dashboard (`dashboard`)
- `go(path)` — navigate to a section. `openRun(row)` — open a run's detail. `badge(status)` — status→badge class.
- Loads: total reports, recent runs (counts: succeeded/failed/in-progress), `EMAIL_ENABLED` banner.

## Reports (`reports`) — definition CRUD
- `load` / `applyFilter` / `prev` / `next` — list + search + engine filter + paging.
- `openNew` / `openEdit(row)` / `save` — create/edit definition via the shared `<edit-drawer>` (code, names, source, engine, formats, templates, params, enabled). Drawer Cancel/Esc/scrim close via the `editing` observable.
- `runNow(row)` — enqueue an on-demand run. `openDetail(row)` — open report detail. `remove(row)` — delete.

## Report Detail (`reportDetail`) — schedules + recipients
- `loadAll` / `back` / `syncSched` (rebuild DBMS_SCHEDULER jobs).
- `runNow` — when the definition declares `params_json` keys, opens the **Run Parameters drawer**
  (one field per key; empty = report default, numeric strings sent as numbers); otherwise queues
  immediately. `submitRun` / `queueRun(params)` — POST the params object as the run body.
- Schedules: `openSchNew` / `openSchEdit` / `saveSch` / `removeSch`.
- Recipients: `openRcNew` / `openRcEdit` / `saveRc` / `removeRc` (USER/ROLE/ORG/EMAIL/SELF × channel).

## Run History (`runs`)
- `load` / `applyFilter` / `refresh` / `prev` / `next` — list with report + status filters + paging.
- `open(row)` — run detail. `retry(row)` — re-queue. `badge(status)`.

## Run Detail (`runDetail`)
- `load` / `back` / `retry`. `download(output)` — authed BLOB download (PDF/XLSX). `fmtBytes(n)`.
- Shows summary, generated files (download), per-recipient deliveries.

## Settings (`settings`) — runtime / SMTP config editor
- `load` / `saveAll` / `toggle(row)` — edit `DCT_RPT_CONFIG` (EMAIL_ENABLED, SMTP_*, PDF_RENDERER, retention…).
  Secrets (SMTP password) live in the runner's env, not here.

## Login (`login`)
- `doLogin` / `quickLogin(ql)` — dev standalone login; production redirects to Admin (App 200) for the shared session.

## API Endpoints (ORDS `/ords/admin/rpt/`)
| Method | Path | Purpose |
|---|---|---|
| GET | `meta` | dropdown vocabularies |
| GET/POST | `reports/` | list / create definitions |
| GET/PUT/DELETE | `reports/:code` | detail / update / delete |
| POST | `reports/:code/run` | enqueue on-demand run (optional JSON body = run parameters; absent/`{}` keeps definition defaults) |
| GET | `runs/` | run history (paged) |
| GET | `runs/:id` | run detail (+ outputs + deliveries) |
| GET | `runs/:id/output/:fmt` | authed BLOB download |
| POST | `runs/:id/retry` | re-queue a run |
| GET/POST | `schedules/` | list / create |
| PUT/DELETE | `schedules/:id` | update / delete |
| POST | `schedules/sync` | rebuild DBMS_SCHEDULER jobs |
| GET/POST | `recipients/` | list / create |
| PUT/DELETE | `recipients/:id` | update / delete |
| GET/PUT | `config` | runtime/SMTP config editor |

## Services / Data layer
| File | Role |
|---|---|
| `js/services/config.js` | `apiBase=/ords/admin/rpt`, `authBase=/ords/admin/dct`, `adminPortalUrl` |
| `js/services/api.js` | re-export of `shared/api` (Bearer + 401 handling) |
| `js/services/authService.js` | shared-session reader; `isReportAdmin()` (SYS_ADMIN) |
| `js/services/rptService.js` | all `/rpt` endpoint wrappers |
