# ATD Loader (App 208) — Functions List

User-facing functions by area. Each area = a view (`Jet/js/views/<x>.html` +
`viewModels/<x>.js`); each bullet is a public `self.<method>`.

## Dashboard (`dashboard`)
- KPIs (total/enabled jobs, 24h success rate, 24h runs, last finished), queue-state donut,
  recent runs, alerts (FAILED / truncation). `go(id)` — jump to a section.
- **Refresh Actuals** header button (`refreshActuals` → `POST /atd/actuals/refresh`): rebuilds the
  GL classification snapshot (`DCT_GL_COA_SNAP`) the actuals reporting views read — handy straight
  after a load. Same proc as the GL app's button + the hourly `DCT_ACTUALS_REFRESH_JOB`.
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
- **Schema-review gate** (`fmHoldReview` → `holdForReview`; `db/33`): a **"Hold for schema review"**
  checkbox on the job form. When held (`schemaReviewed='N'`), the worker prepares the table + column
  map but **does not load** data (run-log `HELD`) until approved. A new job is **auto-held when its
  target table already exists** (shared/peer table — e.g. the 10-min / hourly / daily jobs on one
  analysis — or a customised one), so the structure/mapping is confirmed before loading; the create
  toast says so. Held jobs show a **"Review"** badge in the list (`schemaReviewed`). Approve from
  **job detail** (`approveSchema` → `POST /jobs/:name/approve-schema`): the page shows an "Awaiting
  schema review" notice + **Approve schema** button (replacing Enqueue while held); the Schema panel
  edits/recreates the table if the mapping needs fixing, then Approve releases it.
- **Filter bar** (`fSearch`/`fStatus`/`fCategory`/`fSubCategory`): live filters + an explicit
  **Search** (`search`) and **Clear** (`clearFilters`) button. Criteria are **remembered across a
  page refresh** via `util/filterStore` (localStorage `atd.filters.jobs`). Same pattern on Run Logs
  (`atd.filters.runs`) and Queue (`atd.filters.queue`).
- **Job Categories** (ATD-native lookup, `db/32`; **hierarchical** via `parent_code`, `db/36`):
  tag a job with any number of categories.
  - List **Category column** (colored chips) + a two-level toolbar filter: **Category**
    (`fCategory` = top-level) → **Sub-category** (`fSubCategory`, shown when the chosen category has
    children) → `GET /jobs?category=CODE` (a parent code includes all its sub-categories server-side).
    `topCategories`/`subCategories`/`parentOptions` computeds drive the dropdowns.
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
- **Schema panel** (`toggleSchema` · `loadSchema` · `applySchema` · `removeCol`): shows the live
  staging-table structure — **Source header (editable) · Column name (editable) · Data type (editable
  dropdown) · Sample value · ✕ remove** — plus an editable **table name**. **`removeCol`** drops a
  column from the editor list (a leftover the analysis no longer returns); it's removed from the table
  only on **Apply** (Reload restores it). **Apply** validates and drops + recreates the staging table
  from the remaining definition, rebuilds the column map, renames the table if changed, and the job
  reloads on the next run. Nothing changes until Apply (the staging table is load-only/disposable).
- **Re-prepare** recovers a job whose stored column map / table no longer fits the live
  analysis. **Re-map** (`reprepare(false)`) clears `column_map_json` so the next run
  re-derives it (table + rows kept). **Rebuild table** (`reprepare(true)`, danger, confirm)
  also DROPs the stage (+ final) table so the next run recreates it from the live data —
  the way to accept an **incompatible** column change (a NUMBER/DATE column the analysis
  now sends as text); currently loaded rows are lost.

## Job Sets (`jobSets`, `jobSetDetail`)
Group jobs under **one shared schedule** so a batch can be scheduled / paused / run together, instead
of editing each job's frequency + enabled flag one by one. A job belongs to **at most one set** (member
PK); a job in no set keeps its own schedule (fully backward-compatible). Drives the live browser track:
the 15-min `enqueue` (db/12) only marks a member READY while its set's gate says "go now" and re-runs it
on the set's interval.
- **List (`jobSets`)** — `load` (from `/job-sets`), `newSet` / `editSet` (shared `<edit-drawer>`),
  `save` (create/update), `open` (→ `jobSetDetail`), `runSet` (Run Set Now), `togglePause`
  (Pause/Resume), `del`. Table columns: Set (code + name), Interval, Active window, Members (on/total),
  State (Active/Off/Paused), Notify + row actions (run · pause · edit · delete). `intervalText` renders
  the preset/minutes; `presetLabel`/`dayLabel`/`toggleDay`/`isDay` drive the interval presets + day chips.
- **Create/edit drawer** — flat `fm*` observables: set code (create-only), name EN/AR, comment,
  **Run interval** (preset select → minutes; `CUSTOM` reveals a minutes input), **Start/End** window
  (`datetime-local`), **Daily from/until** (`time`), **Run on days** (Mon–Sun toggle chips),
  Active + Notify-on-failure. All dates/times are **local Asia/Dubai**; leave a field blank for no bound.
- **Detail (`jobSetDetail`)** — header actions: Back · Pause/Resume · Delete · **Edit** (`openEdit` →
  same drawer) · **Run Set Now** (`runSet`). Schedule summary card (read-only). **Members** card:
  add-member picker (`pickJob` from `/job-set-jobs` candidates not in any set) + `addMember`; a
  `.data-table` of members with per-row **In set** toggle (`toggleMember` → enable/disable within the
  set), **Order** input (`saveOrder`), Job-enabled, Status, **≈ Next run** (`atd_set_next_run`; shows
  "Set paused" when gated off), Last run, and `removeMember`. **Set Run History** card = set-scoped
  `atd_load_run_log` rows. A paused set shows an amber notice.

## Environments (`environments`)
- `load` · `newEnv` / `editEnv` (drawer) · `save` (create/update) · `del`.

## Targets (`targets`)
- `load` · `newTarget` / `editTarget` (drawer) · `save` (create/update) · `del`.

## Run Logs (`runs`)
- `load` (job/status/**jobSet**/from/to filters, **server-paged** via `<list-pager>` — `offset`/`limit`/`total`) ·
  `open` (detail modal: message, checksum, rows, duration) · `closeDetail` · `exportCsv` (authed blob
  download) · `fmtDuration`.
- **VM column** (`host`, from `ATD_LOAD_RUN_LOG.host_id`) shows which parallel worker ran each load.
- **Job Set column + filter** (2026-07-01, APP_VERSION 1.19.0): each row shows the Job Set its job
  belongs to (`setCode`/`setName` from a `LEFT JOIN atd_job_set_member → atd_job_set`; region-themed
  `.badge`, `—` when the job is in no set), and a **Job Set** filter dropdown (options from
  `listJobSets()`, sends `?setcode=`, remembered via `filterStore`). Export CSV honours the filter and
  adds a `jobSet` column.
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
| POST | `/actuals/refresh` | rebuild `DCT_GL_COA_SNAP` (`prod.dct_actuals_refresh`) — `otbi-atd/db/39_atd_actuals_refresh_ords.sql` (additive to `atd.rest`); mirrors the GL app button + hourly job |
| GET | `/dashboard` | KPIs + queue counts + recent + alerts (failures **and** runs with a warning message; each alert has `kind` WARNING/FAILED) |
| GET | `/lookups` | envs + targets for pickers |
| GET / POST | `/jobs` | list (+`prepared` flag, +`lastDurationSec`, +`categories[]`; **`?category=CODE`** filter) / create job — POST needs only `sourceRef`; optional `frequencyMinutes`, `categories[]` |
| GET / PUT / DELETE | `/jobs/:name` | read (returns `frequencyMinutes` + `categories[]`) / update (incl. `frequencyMinutes`, `categories[]` replace-set) / delete job |
| GET / POST | `/categories` | list categories (+`usage` count, +`parentCode`/`parentName`) / create (`code`,`nameEn`,`nameAr`,`color`,`displayOrder`,`active`,`parentCode`). SYS_ADMIN |
| PUT / DELETE | `/categories/:code` | update (partial, incl. `parentCode`) / delete — 400 if in use by jobs OR has sub-categories (deactivate/reparent instead). SYS_ADMIN |
| POST | `/jobs/:name/approve-schema` | release a job held for schema review (`schema_reviewed`→'Y'); it loads on next run. SYS_ADMIN |
| GET | `/runs` | run-log list (paged) — each row carries `host` (which VM ran it), `warn` (Y when a SUCCESS run has a message) + `message` snippet + `durationSec` + **`setCode`/`setName`** (the run's Job Set, via `atd_job_set_member`). `status=WARNING` → SUCCESS rows with a message; **`?setcode=`** filters to one set (db/42) |
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
| GET | `/runs` · `/runs/:id` · `/runs/export` | run-log list / detail / CSV — list + export add the **Job Set** column + `?setcode=` filter (redefined by `otbi-atd/db/42_atd_runs_set_ords.sql`, additive; re-run after `13`) |
| GET | `/actions` | Fusion action queue list (paged; filter `status`/`type`/`search`) — `otbi-atd/db/20_atd_action_ords.sql` (additive to `atd.rest`) |
| GET | `/actions/stats` | action-queue counts (ready/claimed/done/failed/cancelled) — dashboard tile |
| GET | `/actions/:id` | action detail: payload, last error, source status history |
| POST | `/actions/:id/retry` · `/actions/:id/cancel` | re-arm FAILED/CANCELLED → READY · cancel (not-DONE) |
| GET / POST | `/job-sets` | list job sets (+ member/enabled counts, interval, window, state) / create a set — `otbi-atd/db/41_atd_job_set_ords.sql` (additive to `atd.rest`). SYS_ADMIN |
| GET / PUT / DELETE | `/job-sets/:code` | detail (schedule + members[+`nextRun`] + recent runs) / partial update (schedule/window/flags) / delete (cascades membership) |
| POST | `/job-sets/:code/members` | add member(s) (`{jobName}` or `{jobNames:[…]}`; a job already in a set is skipped + reported) |
| PUT / DELETE | `/job-sets/:code/members/:job` | toggle `enabledInSet` / set `memberOrder` · remove a member |
| POST | `/job-sets/:code/run` | Run Set Now — top-priority enqueue every enabled member (`atd_set_pkg.run_now`) |
| PUT | `/job-sets/:code/pause` | pause / resume the whole set (`{paused:'Y'/'N'}`) |
| GET | `/job-set-jobs` | candidate picker — every job + its current set (if any); the detail add-member list filters to unassigned jobs |

All handlers: `dct_rest.validate_session` → 401, `dct_auth.has_role(user,'SYS_ADMIN')` → 403.

## Services / Data layer
| File | Role |
|---|---|
| `js/services/atdService.js` | one method per ORDS endpoint (Promises); incl. `getActionStats` / `listActions` / `getAction` / `retryAction` / `cancelAction`; job sets `listJobSets` / `getJobSet` / `createJobSet` / `updateJobSet` / `deleteJobSet` / `addSetMembers` / `updateSetMember` / `removeSetMember` / `runJobSet` / `pauseJobSet` / `listSetCandidates` |
| `js/services/api.js` | re-export of `shared/js/api.js` (Bearer + 401 handling) |
| `js/services/authService.js` | session reader (shared `ifinance_jet_session`) |
| `js/services/config.js` | `apiBase=/ords/admin/atd`, `authBase=/ords/admin/dct` |
