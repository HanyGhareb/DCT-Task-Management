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
- `runNow(row)` — fetches the param spec (`GET reports/:code/params`); parameterized definitions open the **Run Parameters drawer in place on the list** (LOV dropdowns + EN/AR labels/hints + required-field validation) — no navigation to detail; param-less definitions queue immediately. `submitRun` posts the collected params. `openDetail(row)` — open report detail. `remove(row)` — delete.

## Report Detail (`reportDetail`) — schedules + recipients
- `loadAll` / `back` / `syncSched` (rebuild DBMS_SCHEDULER jobs).
- `runNow` — fetches the param spec (`GET reports/:code/params`) and opens the **Run Parameters
  drawer** (LOV dropdowns from the definition's `param_spec_json` lov_sql, EN/AR labels + hints,
  required markers; empty optional field = report default, numeric strings sent as numbers);
  no declared params → queues immediately. `submitRun` validates required fields, then
  `queueRun(params)` POSTs the params object as the run body.
- Schedules: `openSchNew` / `openSchEdit` / `saveSch` / `removeSch`.
- Recipients: `openRcNew` / `openRcEdit` / `saveRc` / `removeRc` (USER/ROLE/ORG/EMAIL/SELF × channel).

## Workers (`workers`) — engine monitoring + control
- `load` / `refresh` — workers + derived health (ONLINE < 90s heartbeat, STALE < 10min, else OFFLINE), queue stats (queued/running/failed today/success today/oldest queued age) and the two DCT_RPT_* scheduler jobs. Auto-refreshes every 10s while the page is open.
- `pause(w)` / `resume(w)` / `stop(w)` — write the worker's `command`; the Python worker obeys on its next loop (STOP exits after the current run). `remove(w)` — delete an OFFLINE registry row.
- `reclaim` — requeue stuck RUNNING runs (`DCT_RPT_PKG.reclaim_stuck`).
- `toggleJob(j)` — enable/disable `DCT_RPT_NATIVE_JOB` (NATIVE sweep) / `DCT_RPT_MAINT_JOB` (maintenance).

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
| GET | `reports/:code/params` | run-parameter spec for the Run drawer: name/label/labelAr/hint/hintAr/required + LOV values (each `param_spec_json` lov_sql executed, max 500 rows) — `reporting/db/10` |
| GET | `runs/` | run history (paged) |
| GET | `runs/:id` | run detail (+ outputs + deliveries) |
| GET | `runs/:id/output/:fmt` | authed BLOB download |
| POST | `runs/:id/retry` | re-queue a run |
| GET | `workers/` | workers + health + queue stats + DCT_RPT_* scheduler jobs |
| POST | `workers/command` | `{workerId, command: PAUSE\|RESUME\|STOP\|CLEAR}` |
| POST | `workers/remove` | `{workerId}` — delete a dead/stopped registry row |
| POST | `workers/reclaim` | requeue stuck RUNNING runs |
| POST | `workers/job` | `{jobName, enabled}` — toggle DCT_RPT_NATIVE_JOB / DCT_RPT_MAINT_JOB |
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
