# ATD Loader (App 208) — Functions List

User-facing functions by area. Each area = a view (`Jet/js/views/<x>.html` +
`viewModels/<x>.js`); each bullet is a public `self.<method>`.

## Dashboard (`dashboard`)
- KPIs (total/enabled jobs, 24h success rate, 24h runs, last finished), queue-state donut,
  recent runs, alerts (FAILED / truncation). `go(id)` — jump to a section.
- **Worker Fleet** panel (`listWorkers` → `GET /atd/workers`): one row per parallel-worker VM
  (`worker_id`, status IDLE/BUSY/DOWN, current job, last-seen age, runs-24h) with a green/red
  online dot (`workerDot`, fresh ≤120s) and `workerAge`. Reflects the 3-VM fleet
  (atd-vm180/181/182) draining the shared queue.
  - **Refresh** button per VM (`refreshWorker` → `POST /atd/workers/:id/refresh`): asks that
    worker to re-login to Fusion (sets `ATD_WORKER_HEARTBEAT.refresh_req`; the worker forces a
    fresh login → one MFA push to approve in Authenticator). Also available via the Telegram bot
    (`refresh vm180`/`vm181`/`vm182`/`all`).
  - **Session Age** column (`sessionAge`/`sessionAged` ← `getJobHealth` → `GET /atd/jobs/health`):
    each VM's Fusion session age (from `ATD_WORKER_HEARTBEAT.session_started`); turns amber past
    ~7h so an aging session is visible before it expires (~8h).
- **Break window banner** (`breakInfo`/`breakText` ← `getJobHealth`): shown when `ATD_BREAK_ENABLED=Y`;
  displays the configured window (`ATD_BREAK_START`–`END`, Asia/Dubai) and whether it is active now,
  so a paused fleet reads as intentional, not broken.
- **Job Freshness** card (`jobHealth`/`sinceText`/`jobStale` ← `getJobHealth`): per ENABLED job —
  last SUCCESS + time-since, consecutive fails since that success, any stuck `RUNNING`, and the
  effective frequency. Stale rows (fails>0 or stuck) tint red.

## Jobs (`jobs`)
- `load` (search + status filter) · `open` (→ jobDetail) · `newJob` / `editJob` (drawer) ·
  `toggleAdvanced` · `save` (create/update, JSON-validates column-map/params) · `enqueue` ·
  `reset` · `runNow` · `del` · `fmtDuration` (`util/duration` — adaptive-compact run time).
- **Add New OTBI Analysis** + the **column picker** now live on the **OTBI Discovery** page
  (see below), not here — the Jobs page only manages existing jobs.
- The list shows a **Duration** column = the last run's elapsed time (`lastDurationSec`),
  formatted `47s` / `1m 50s` / `1h 20m 10s` (units i18n `atd.dur.h/m/s`; `—` when never run or
  the run-log row has no `started`, e.g. the SQLcl loader path).
- **Minimal create:** the New-Job drawer needs only the **analysis path** (and, optionally, a
  target table). Everything else — job name, environment, target DB, staging table — is
  auto-derived; the **column map + table columns are prepared by the runner on first run**
  (`prepare.py` profiles the live CSV). All other fields live behind an "Advanced options"
  disclosure. Jobs not yet prepared show a `not prepared` badge (`prepared='N'`).
- **Frequency (min)** field (Advanced; `fmFrequency` → `frequencyMinutes`): how often the job is
  queued. Blank = the global default (`ATD_DEFAULT_FREQ_MINUTES`, 15); e.g. 60 = hourly,
  1440 = daily. The 15-min enqueue only marks a job READY once this much time has passed since its
  last run (db/12 `enqueue` due-ness), so heavy "Real Time" jobs needn't run every cycle.
- **Job Categories** (ATD-native lookup, `db/32`): tag a job with any number of categories.
  - List **Category column** (colored chips) + a toolbar **category filter** (`fCategory` →
    `GET /jobs?category=CODE`).
  - Drawer **category picker** (`fmCategories`, toggle chips) — sent as `categories:[codes]` on
    create/update (replace-set).
  - **Manage Categories** right-edge **drawer** (shared `.ed-*` chrome; `openCatMgr`/`editCat`/
    `saveCat`/`delCat`) with **New · Close · Save** actions in the drawer header: add / edit form +
    the existing-categories list (rename / color / order / activate-deactivate), over `/categories`.
    Delete is blocked while in use (→ deactivate). Chips localize EN/AR (`catLabel`) and colour from
    the category (`chipStyle`).

## Job detail (`jobDetail`)
- `refresh` (full config + run history) · `enqueue` · `back` · `reprepare(rebuild)` ·
  `fmtDuration`. The run-history table includes a **Duration** column (`durationSec` per run).
- **Schema panel** (`toggleSchema` · `loadSchema` · `applySchema`): shows the live staging-table
  structure — **Source header · Column name (editable) · Data type (editable dropdown) · Sample
  value** — plus an editable **table name**. **Apply** validates and drops + recreates the staging
  table from the edited definition, rebuilds the column map, renames the table if changed, and the
  job reloads on the next run. Nothing changes until Apply (the staging table is load-only/disposable).
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
- `load` (job/status/from/to filters, **server-paged** via `<list-pager>` — `offset`/`limit`/`total`) ·
  `open` (detail modal: message, checksum, rows, duration) · `closeDetail` · `exportCsv` (authed blob
  download) · `fmtDuration`.
- **VM column** (`host`, from `ATD_LOAD_RUN_LOG.host_id`) shows which parallel worker ran each load.
- Status filter includes **WARNING** (a SUCCESS run that carries a message) alongside
  SUCCESS/FAILED/RUNNING — the server maps `status=WARNING` to `status='SUCCESS' AND message IS NOT NULL`.
- The list + detail modal show a **Duration** column (`durationSec` = `finished − started` seconds,
  same adaptive-compact format as the Jobs list; `—` for a RUNNING row or one with no `started`).
- A `SUCCESS` run that carries a `message` (schema-drift note or truncation warning) shows a
  `⚠ warning` chip in the list (`warn='Y'`, message in the chip tooltip); the full text is in the
  detail modal's Message box. The Dashboard **Alerts** panel lists these as `WARNING` (amber) /
  `FAILED` (red) via the run's `kind`.

## Queue & Operations (`queue`)
- `load` (per-job claim state + worker) · `enqueueAll` · `reap` (lease minutes) · `enqueueOne`.

## Fusion Actions (`actions`)
Fusion write-back queue — the inverse of extract jobs. The runner (`python runner.py --actions`)
performs each action *inside* Oracle Fusion via the shared SSO session; first type `AP_INVOICE`,
sourced from approved Petty Cash reimbursements. Idempotent (never creates a duplicate invoice).
- `load` (from `/actions` + `/actions/stats`): list of action requests + a status-count strip.
- `setStatus` / `statusFilter`: filter by `READY|CLAIMED|DONE|FAILED|CANCELLED`.
- `retry(row)` POST `/actions/:id/retry` (re-arm a FAILED/CANCELLED action → READY).
- `cancel(row)` POST `/actions/:id/cancel` (cancel anything not DONE).
- `openDetail(row)` / `closeDetail`: modal with pretty-printed `payload_json`, last error, and the
  source-record status history (`detail` + `detailPayload`).
- Dashboard tile: `actions` (queued = ready+claimed, failed) KPIs link here.

## OTBI Discovery (`discovery`)
One page, three tables, for the `create_analysis` async pipeline:
- **Discovery requests** (`loadRequests` from `/subject-areas`): current status per subject area
  (QUEUED/SCRAPING/READY/FAILED + folder/column counts). `discoverNew` (input + button) and
  `rediscover(row)` POST `/subject-areas/discover` to (re)queue a scrape; `discover(sa)` is shared.
- **Discovery run history** (`loadRuns` from `/subject-areas/runs`, paged): every `--discover`
  scrape as a log row (subject area, status, columns, started, duration, message).
- **Analysis build requests** (`loadBuilds` from `/analyses`): the "Add New OTBI Analysis" queue
  (name, save folder, status, resulting job, message).
- `refresh` reloads all three.
- **Add New OTBI Analysis** (`newAnalysis` → drawer; `addAnColumn` / `removeAnColumn` /
  `saveAnalysis`): builds a brand-new OTBI analysis from a spec (subject area, save folder,
  name, a Folder/Column/Heading columns repeater, optional prompted-filter JSON, load mode).
  `saveAnalysis` POSTs `{name, saveFolder, specJson}` to `/atd/analyses` — queued in
  `ATD_ANALYSIS_REQUEST`; the runner (`python runner.py --build`) drives the OTBI Answers UI
  (`create_analysis.build_analysis`), saves the analysis, registers it as a job, and loads it.
  `saveAnalysis` refreshes the build-requests table on success.
- **Column picker** (in the Add-New-Analysis drawer; `loadCatalog` · `discoverColumns` ·
  `toggleFolder` · `togglePick` · `anPickSa` subscribe): instead of typing Folder/Column labels,
  pick a previously **discovered** subject area from the dropdown (reuses the page's `requests`
  list) and tick its real folders/columns to fill the repeater. The catalog is a **full-depth
  nested tree** (folders → sub-folders → leaf columns) rendered by a recursive KO template
  (`anPickNodeTpl`); each picked leaf carries its folder **`path`** so the builder can expand the
  full ancestor chain. `discoverColumns` POSTs `/atd/subject-areas/discover` to queue a scrape;
  the dedicated **1-minute `OTBI-ATD Discover`** task (`python runner.py --discover`, one SA/run)
  drives the OTBI tree (`create_analysis.discover_subject_area`, icon-based folder detection) and
  caches it in `ATD_SA_CATALOG`; the picker reads it via `/atd/subject-areas/columns?sa=`.
- **AI column suggester** (`suggestColumns` · `anSuggestText` · `anSuggestBusy`; helpers
  `_pickByPath`/`_applyPick`): a "✨ Suggest columns" textarea — describe the data in plain language
  and POST `/atd/subject-areas/suggest` `{sa, request}`; `DCT_ATD_AI_PKG.suggest_columns` flattens
  the discovered catalog to a numbered list, asks Claude (Sonnet 4.6) for the matching **indices**,
  and maps them back to `{path, column}` (server-validated against the catalog — no hallucinations).
  The matches are ticked in the nested picker for review before Build.

## API Endpoints (ORDS) — `/ords/admin/atd/` (`otbi-atd/db/13_atd_ords.sql`, module `atd.rest`)
| Method | Path | Purpose |
|---|---|---|
| GET | `/dashboard` | KPIs + queue counts + recent + alerts (failures **and** runs with a warning message; each alert has `kind` WARNING/FAILED) |
| GET | `/lookups` | envs + targets for pickers |
| GET / POST | `/jobs` | list (+`prepared` flag, +`lastDurationSec`, +`categories[]`; **`?category=CODE`** filter) / create job — POST needs only `sourceRef`; optional `frequencyMinutes`, `categories[]` |
| GET / PUT / DELETE | `/jobs/:name` | read (returns `frequencyMinutes` + `categories[]`) / update (incl. `frequencyMinutes`, `categories[]` replace-set) / delete job |
| GET / POST | `/categories` | list categories (+`usage` count) / create (`code`,`nameEn`,`nameAr`,`color`,`displayOrder`,`active`). SYS_ADMIN |
| PUT / DELETE | `/categories/:code` | update (partial) / delete — 400 if in use (deactivate instead). SYS_ADMIN |
| GET | `/runs` | run-log list (paged) — each row carries `host` (which VM ran it), `warn` (Y when a SUCCESS run has a message) + `message` snippet + `durationSec`. `status=WARNING` → SUCCESS rows with a message |
| GET | `/workers` | parallel-worker fleet health from `ATD_WORKER_HEARTBEAT` — `workerId`, `status`, `currentJob`, `lastSeen`, `ageSec`, `online` (Y when ≤120s), `runs24h` |
| GET | `/jobs/health` | dashboard observability (additive, db/31) — `break` {enabled,active,start,end}, `workers[]` {workerId,sessionStarted,sessionAgeMin}, `jobs[]` (enabled) {jobName,lastSuccess,sinceMin,consecutiveFails,stuckRunning,alertSent,frequencyMin}. SYS_ADMIN |
| POST | `/workers/:id/refresh` | request a worker re-login (`:id` = worker_id or `all`) — sets `ATD_WORKER_HEARTBEAT.refresh_req`; the worker forces a fresh Fusion login (MFA). SYS_ADMIN |
| GET / POST | `/analyses` | list recent build requests / queue a "build a new OTBI analysis" request (`{name, saveFolder, specJson}` → `ATD_ANALYSIS_REQUEST`; runner `--build` consumes it) |
| GET | `/subject-areas` | list discovered subject areas + status/column counts (column-picker source) |
| GET | `/subject-areas/columns?sa=` | one READY subject area's cached folder/column tree (raw `catalog_json`) |
| POST | `/subject-areas/discover` | queue a subject area for (re)scrape (`{subjectArea}` → `ATD_SA_CATALOG` QUEUED; the 1-min `OTBI-ATD Discover` task / runner `--discover` consumes it, one SA per run) |
| POST | `/subject-areas/suggest` | AI column suggester — `{sa, request}` → `DCT_ATD_AI_PKG.suggest_columns` (Claude Sonnet 4.6) → `{items:[{path,column}]}` chosen strictly from the discovered catalog |
| GET | `/subject-areas/runs` | discovery run history (paged) — `ATD_LOAD_RUN_LOG` rows with `track='DISCOVER'` (subject area, status, columns, started, duration, message); the main `/runs` excludes these |
| POST | `/jobs/:name/enqueue` · `/jobs/:name/reset` | queue one / reset one |
| POST | `/jobs/:name/reprepare` | clear column map (re-derive next run); `{"rebuild":"Y"}` also drops + recreates the table to accept an incompatible column change |
| GET / POST | `/jobs/:name/schema` | read live staging-table structure (name+type+sample per column, + raw column_map_json) / apply an edited definition (validate names+types, drop + recreate the table, rebuild column map, rename, mark reload) |
| POST | `/enqueue` · `/reap` | enqueue all · reap stale |
| GET / POST | `/envs` ; PUT / DELETE `/envs/:name` | environments CRUD |
| GET / POST | `/targets` ; PUT / DELETE `/targets/:name` | targets CRUD |
| GET | `/runs` · `/runs/:id` · `/runs/export` | run-log list / detail / CSV |
| GET | `/actions` | Fusion action queue list (paged; filter `status`/`type`/`search`) — `otbi-atd/db/20_atd_action_ords.sql` (additive to `atd.rest`) |
| GET | `/actions/stats` | action-queue counts (ready/claimed/done/failed/cancelled) — dashboard tile |
| GET | `/actions/:id` | action detail: payload, last error, source status history |
| POST | `/actions/:id/retry` · `/actions/:id/cancel` | re-arm FAILED/CANCELLED → READY · cancel (not-DONE) |

All handlers: `dct_rest.validate_session` → 401, `dct_auth.has_role(user,'SYS_ADMIN')` → 403.

## Services / Data layer
| File | Role |
|---|---|
| `js/services/atdService.js` | one method per ORDS endpoint (Promises); incl. `getActionStats` / `listActions` / `getAction` / `retryAction` / `cancelAction` |
| `js/services/api.js` | re-export of `shared/js/api.js` (Bearer + 401 handling) |
| `js/services/authService.js` | session reader (shared `ifinance_jet_session`) |
| `js/services/config.js` | `apiBase=/ords/admin/atd`, `authBase=/ords/admin/dct` |
