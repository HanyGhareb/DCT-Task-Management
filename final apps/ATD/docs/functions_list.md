# ATD Loader (App 208) — Functions List

User-facing functions by area. Each area = a view (`Jet/js/views/<x>.html` +
`viewModels/<x>.js`); each bullet is a public `self.<method>`.

## Dashboard (`dashboard`)
- KPIs (total/enabled jobs, 24h success rate, 24h runs, last finished), queue-state donut,
  recent runs, alerts (FAILED / truncation). `go(id)` — jump to a section.

## Jobs (`jobs`)
- `load` (search + status filter) · `open` (→ jobDetail) · `newJob` / `editJob` (drawer) ·
  `toggleAdvanced` · `save` (create/update, JSON-validates column-map/params) · `enqueue` ·
  `reset` · `runNow` · `del` · `fmtDuration` (`util/duration` — adaptive-compact run time).
- The list shows a **Duration** column = the last run's elapsed time (`lastDurationSec`),
  formatted `47s` / `1m 50s` / `1h 20m 10s` (units i18n `atd.dur.h/m/s`; `—` when never run or
  the run-log row has no `started`, e.g. the SQLcl loader path).
- **Minimal create:** the New-Job drawer needs only the **analysis path** (and, optionally, a
  target table). Everything else — job name, environment, target DB, staging table — is
  auto-derived; the **column map + table columns are prepared by the runner on first run**
  (`prepare.py` profiles the live CSV). All other fields live behind an "Advanced options"
  disclosure. Jobs not yet prepared show a `not prepared` badge (`prepared='N'`).

## Job detail (`jobDetail`)
- `refresh` (full config + run history) · `enqueue` · `back` · `reprepare(rebuild)` ·
  `fmtDuration`. The run-history table includes a **Duration** column (`durationSec` per run).
- **Re-prepare** recovers a job whose stored column map / table no longer fits the live
  analysis. **Re-map** (`reprepare(false)`) clears `column_map_json` so the next run
  re-derives it (table + rows kept). **Rebuild table** (`reprepare(true)`, danger, confirm)
  also DROPs the stage (+ final) table so the next run recreates it from the live data —
  the way to accept an **incompatible** column change (a NUMBER/DATE column the analysis
  now sends as text); currently loaded rows are lost.

## Environments (`environments`)
- `load` · `newEnv` / `editEnv` (drawer) · `save` (create/update) · `del`.

## Targets (`targets`)
- `load` · `newTarget` / `editTarget` (drawer) · `save` (create/update) · `del`.

## Run Logs (`runs`)
- `load` (job/status/from/to filters) · `open` (detail modal: message, checksum, rows, duration) ·
  `closeDetail` · `exportCsv` (authed blob download) · `fmtDuration`.
- The list + detail modal show a **Duration** column (`durationSec` = `finished − started` seconds,
  same adaptive-compact format as the Jobs list; `—` for a RUNNING row or one with no `started`).
- A `SUCCESS` run that carries a `message` (schema-drift note or truncation warning) shows a
  `⚠ warning` chip in the list (`warn='Y'`, message in the chip tooltip); the full text is in the
  detail modal's Message box. The Dashboard **Alerts** panel lists these as `WARNING` (amber) /
  `FAILED` (red) via the run's `kind`.

## Queue & Operations (`queue`)
- `load` (per-job claim state + worker) · `enqueueAll` · `reap` (lease minutes) · `enqueueOne`.

## API Endpoints (ORDS) — `/ords/admin/atd/` (`otbi-atd/db/13_atd_ords.sql`, module `atd.rest`)
| Method | Path | Purpose |
|---|---|---|
| GET | `/dashboard` | KPIs + queue counts + recent + alerts (failures **and** runs with a warning message; each alert has `kind` WARNING/FAILED) |
| GET | `/lookups` | envs + targets for pickers |
| GET / POST | `/jobs` | list (+`prepared` flag, +`lastDurationSec` = last run elapsed seconds) / create job — POST needs only `sourceRef`; job name, env, target, stage table auto-derived |
| GET / PUT / DELETE | `/jobs/:name` | read (history rows carry `durationSec`) / update / delete job |
| GET | `/runs` | run-log list — each row carries `warn` (Y when a SUCCESS run has a message) + `message` snippet + `durationSec` |
| POST | `/jobs/:name/enqueue` · `/jobs/:name/reset` | queue one / reset one |
| POST | `/jobs/:name/reprepare` | clear column map (re-derive next run); `{"rebuild":"Y"}` also drops + recreates the table to accept an incompatible column change |
| POST | `/enqueue` · `/reap` | enqueue all · reap stale |
| GET / POST | `/envs` ; PUT / DELETE `/envs/:name` | environments CRUD |
| GET / POST | `/targets` ; PUT / DELETE `/targets/:name` | targets CRUD |
| GET | `/runs` · `/runs/:id` · `/runs/export` | run-log list / detail / CSV |

All handlers: `dct_rest.validate_session` → 401, `dct_auth.has_role(user,'SYS_ADMIN')` → 403.

## Services / Data layer
| File | Role |
|---|---|
| `js/services/atdService.js` | one method per ORDS endpoint (Promises) |
| `js/services/api.js` | re-export of `shared/js/api.js` (Bearer + 401 handling) |
| `js/services/authService.js` | session reader (shared `ifinance_jet_session`) |
| `js/services/config.js` | `apiBase=/ords/admin/atd`, `authBase=/ords/admin/dct` |
