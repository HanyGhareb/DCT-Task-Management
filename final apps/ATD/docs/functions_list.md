# ATD Loader (App 208) — Functions List

User-facing functions by area. Each area = a view (`Jet/js/views/<x>.html` +
`viewModels/<x>.js`); each bullet is a public `self.<method>`.

## Dashboard (`dashboard`)
- KPIs (total/enabled jobs, 24h success rate, 24h runs, last finished), queue-state donut,
  recent runs, alerts (FAILED / truncation). `go(id)` — jump to a section.
- **Refresh Actuals** header button (`refreshActuals` → `POST /atd/actuals/refresh`): rebuilds the
  GL classification snapshot (`DCT_GL_COA_SNAP`) the actuals reporting views read through the validated, overlap-protected db/v2/118 refresh — handy straight
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
  - **Region-header ↻ Refresh** (`loadFleet`): re-fetches `/workers` + `/jobs/health` together
    and re-renders the table (also the initial load path).
  - **Inline verdict badge** (`startVerdict`/`verdictOn`/`verdictClass`/`verdictText`, v1.42.0):
    after Check session or Force re-login the row shows a live badge — amber "Checking…"/
    "Re-logging in…"/"Approve the number in Authenticator" → green "✓ Session OK — no MFA was
    needed" / "✓ Signed in — MFA approved" → red on failure; driven by `mfa_status` + the 3s
    poll, terminal verdicts auto-hide after 90s. (A live Microsoft sign-in completes a forced
    re-login WITHOUT any MFA number — the green verdict is the success signal.)
  - **Account** column (`sessionAccount`, db/85): which Fusion account the VM's current session
    belongs to — the service account, or the personal profile of the running job/action.
    **v1.43.0**: extra muted sub-lines (`workerSessions` ← heartbeat `sessions_json`) list the
    OTHER live Fusion sessions the worker holds (per-user personal profiles, db/62) with each
    session's own age; every column header now carries a plain-language ⓘ hint (EN+AR) —
    Session Age = the SERVICE-account session's age (~8h lifetime, amber past 7h).
  - **Pause / Resume** buttons (`pauseWorker`/`resumeWorker` → `POST /atd/workers/:id/pause`\|`/resume`,
    db/85): operator hold — a paused worker claims no new work (in-flight job finishes first),
    keeps heartbeating (`PAUSED` pill) and still honours session commands.
  - **VM drill-down** (`openWorkerRuns`): the VM name is a link → Run Logs pre-filtered to that
    host (one-shot `vmFilter` route state; Run Logs has a matching VM dropdown, `?vm=` on
    `GET /runs` + `/runs/export`, db/42 rework).
  - **Worker-offline banner** (`offlineWorkers`): red banner at the top of the dashboard when a
    worker is `DOWN` or silent > 5 min while not BUSY (a BUSY worker legitimately skips
    heartbeats for the length of a run).
  - **Age-based auto re-login** (runner-side, db/85 settings `ATD_AGE_RELOGIN`=N +
    `ATD_AGE_RELOGIN_HOURS`=7.5, editable in Runner Settings): when on, an idle worker whose
    session age passes the threshold re-logs itself in (one MFA push); one attempt per session.
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

## VB Templates (`xlTemplates`)
Visual Builder Excel template repository — per process (template) a set of **versions**, each carrying a
**MASTER** (unpublished, admin-only) and a **PUBLISHED** (end-user) workbook; exactly **one version is
ACTIVE per template** and end users elsewhere download the active published file
(`GET /ords/admin/xl/templates/download?code=`). Backed by the platform **`xl` ORDS module**
(`/ords/admin/xl/`, NOT `/atd/`) — SYS_ADMIN-gated except the download route.
- `load` — template list (`.data-table`: code, EN/AR name, module badge, description, versions count,
  ACTIVE version badge); row click expands the per-template **versions table** (`toggle`/`isOpen`,
  expansion survives reloads).
- `newTpl` / `editTpl` / `saveTpl` — create/edit template drawer (code fixed after create; name/nameAr/
  module/description partial update via `POST /templates/` with `templateId`).
- `newVersion` / `saveVersion` — New Version drawer (notes) → `POST /templates/version`.
- `upload(t, v, kind)` — `.xlsx` picker (`shared/docUpload.choose`) → raw-binary
  `PUT /templates/file?templateid=&ver=&kind=master|published&filename=`; toast + refresh.
- `download(t, v, kind)` — authed blob fetch → object-URL `a.click` (master or published workbook).
- `activate(t, v)` — confirm + `POST /templates/activate` (button disabled until a published file exists;
  server 400s otherwise).
- `delVersion(t, v)` — confirm + `POST /templates/delete-version` (blocked on the ACTIVE version).

## Run Logs (`runs`)
- `cancelRun(row)` (v1.40.0) — Cancel button, rendered on **RUNNING rows only**; confirms, calls `POST /runs/:id/cancel`, reloads. `clickBubble:false` or the row's own click opens the detail drawer underneath it
- Run Detail shows non-blocking **data warnings** for invalid dates: source row,
  target column, original value, and reason. The job remains SUCCESS and loads NULL
  for the invalid cell; diagnostic samples are stored by run (`db/49`).
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

## Manage Projects Org (`projectsOrg`)
Enqueue `PPM_TASK_ADDL_INFO` Fusion actions — update a financial-plan task's **Additional
Information** DFF (Organization Reference cost centre + optional Entity Specific / Appropriation /
Program / BG Override / Revenue Account Override) via *Manage Financial Project Plan*. The runner
(`python runner.py --actions`) performs them inside Fusion; idempotent per
`PPM-ORGREF:<project>:<task>:<cc>` key.
- `submitSingle` (+ `fProject`/`fTask`/`fOrg`, `moreOpen` disclosure with `fEntity`/`fAppr`/
  `fProgram`/`fBg`/`fRev`): single-row form → POST `/actions/enqueue` (rows:[1]); clears on success.
- **Type-ahead LOVs (1.21.0)** — `lovProjects`/`lovTasks`/`lovCcs` feed native `<datalist>`s on the
  three required inputs via GET `/actions/ppmlov`: projects (all ~800, searchable by number OR name
  — option label carries `name · status`), tasks (reloaded 400ms-debounced from the typed
  `fProject`), cost centres (code + description from `DCT_GL_COA_V`). SUGGESTIONS ONLY — inputs
  stay free-text because the extract tables are a snapshot (a task created in Fusion today may not
  be there yet). Param is `search=`, NOT `q=` (ORDS reserves `q`).
- `chooseFile` (shared `docUpload.choose`, `.xlsx/.xls/.csv` ≤10MB) → SheetJS (`require(['xlsx'])`)
  parse of the first sheet: header row mapped case/space-insensitively (`PROJECT_NUMBER`,
  `TASK_NUMBER`, `ORG_REFERENCE` [aliases `COST_CENTRE`/`COST_CENTER`/`CC`] + the 5 optional
  segment columns); per-row client validation; preview table with Valid/Invalid badges.
- `submitBulk`: valid rows in chunks of 200 → sequential POST `/actions/enqueue`; per-row result
  written back into the preview Status column (`READY #<actionId>` / error) — row objects are
  **replaced** (KO foreach skips re-render on identical references).
- `downloadTemplate`: generates `projects_org_template.xlsx` client-side (SheetJS, sample row).
- `clearBulk`; `bulkValidCount`/`bulkErrorCount` computeds.
- **Recent Projects Org Actions** (`loadRecent` from `/actions?type=PPM_TASK_ADDL_INFO`):
  last 20 with status chip, **Worker VM / Started / Ended / Duration (`fmtDur`) / Submitted by /
  Submitted on** (db/46 telemetry: `workerVm`/`startedAt`/`finishedAt`/`durationSecs`/`submittedBy`;
  rows enqueued before db/46 show — for the first four), attempts, last error;
  `retry(row)`/`cancel(row)` as on Fusion Actions.
- Header link `viewActions` → the Fusion Actions page (`$root.navigate('actions')`).

## Project Budget Transactions (`pbtExtract`)
Extracts master–detail budget transactions from the ADG_FIN **Project Budget Transactions**
VBCS app into `PA_BUDGET_TRX_HEADERS` + the per-type line tables + `PA_BUDGET_TRX_APPROVALS`
(`otbi-atd/db/77`). Enqueues action type **`PA_BUDGET_TRX`** — the first *read* action — and
monitors it with the queue's own telemetry.
- **Currently loaded** (`loadSummary` from `/pbt/summary`): rows per budget type with date span
  and last-refresh time, line totals per type, approval count, and a scheduled-sync on/off badge.
- **Extract parameters**: `fType` (budget type), `fMode` (`RANGE` / `SYNC_SHALLOW` / `SYNC_DEEP`,
  with `modeHint` explaining each), `fFrom`/`fTo` dates, `fBus` + `fStatuses` multi-select chips
  (`toggleBu`/`hasBu`/`toggleStatus`/`hasStatus`), `fApprovals`, `fPurge`.
- **Run + monitor**: `submit` (client-side validation → `POST /pbt/runs`), `poll` (4 s until
  DONE/FAILED/CANCELLED) showing status chip, worker VM, started/finished/duration, rows loaded,
  per-type detail line and last error; `watchRun(row)` re-attaches the monitor to any past run.
- **Recent runs** (`loadRuns` from `/pbt/runs`): request, status, scope, worker, timings, rows,
  submitted-by; row click = watch it.
- **Extracted transactions** (`loadData` from `/pbt/data`): server-paged register with type /
  status / BU / date-range / free-text filters (`searchData`, `prevPage`, `nextPage`); row click
  → `openDetail` drill drawer with the transaction header, its detail lines and its approval
  trail (`/pbt/data/:num`).
- Helpers: `statusClass`, `num`, `closeDrawer`.

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

## Runner Settings (`runnerSettings`)
- **Operational settings table** (`load` from `/config`; `save` → PUT `/config`): the UI-managed
  `ATD_RUNNER_CONFIG` keys (MFA wait, lease, chunk, notify channel, global `OTBI_USER`…) — the
  runner overlays them onto its environment at startup (DB wins over env.ps1). Secret rows render
  a set/not-set badge only.
- **My OTBI Account** (`loadCred` / `saveCred` / `removeCred` over `/my-credential`, db/62+63):
  per-user Fusion credential profile — Fusion username, **write-only** password (sent only when
  typed; AES-256-encrypted server-side), personal Telegram chat id (MFA number-match pushes for
  this account go there) and an Active toggle. Jobs and Fusion actions the signed-in user enqueues
  run under THIS account on the worker fleet; scheduled/automatic runs keep the global service
  account. First personal run per worker VM needs one Authenticator approval from the owner's
  phone; an unapproved push fails only that run.
- **Who has a personal account** roster (`credRoster` from `/credentials`): username, Fusion
  login, active/password/chat flags — no secret values.

## API Endpoints (ORDS) — `/ords/admin/atd/` (`otbi-atd/db/13_atd_ords.sql`, module `atd.rest`)
| Method | Path | Purpose |
|---|---|---|
| POST | `/actuals/refresh` | rebuild `DCT_GL_COA_SNAP` (`prod.dct_actuals_refresh`) — `otbi-atd/db/39_atd_actuals_refresh_ords.sql` (additive to `atd.rest`); mirrors the GL app button + hourly job |
| GET | `/dashboard` | KPIs + queue counts + recent + alerts (failures **and** runs with a warning message; each alert has `kind` WARNING/FAILED) |
| GET | `/lookups` | envs + targets for pickers |
| GET / POST | `/jobs` | list (+`prepared` flag, +`lastDurationSec`, +`categories[]`, +**`owner`/`ownerType`** = the job's PERMANENT owner: `catalog` = the credential profile whose OTBI catalog folder holds the analysis (every run, scheduled included, signs in as that account), `manual` = the user who queued this cycle, '' = service account; +`requestedBy` (this cycle's manual requester); **`?category=CODE`** filter) / create job — POST needs only `sourceRef`; optional `frequencyMinutes`, `categories[]` |
| GET / PUT / DELETE | `/jobs/:name` | read (returns `frequencyMinutes` + `categories[]` + `owner`/`ownerType`/`requestedBy`) / update (incl. `frequencyMinutes`, `categories[]` replace-set) / delete job |
| GET / POST | `/categories` | list categories (+`usage` count, +`parentCode`/`parentName`) / create (`code`,`nameEn`,`nameAr`,`color`,`displayOrder`,`active`,`parentCode`). SYS_ADMIN |
| PUT / DELETE | `/categories/:code` | update (partial, incl. `parentCode`) / delete — 400 if in use by jobs OR has sub-categories (deactivate/reparent instead). SYS_ADMIN |
| POST | `/jobs/:name/approve-schema` | release a job held for schema review (`schema_reviewed`→'Y'); it loads on next run. SYS_ADMIN |
| GET | `/runs` | run-log list (paged) — each row carries `host` (which VM ran it), `warn` (Y when a SUCCESS run has a message) + `message` snippet + `durationSec` + **`setCode`/`setName`** (the run's Job Set, via `atd_job_set_member`). `status=WARNING` → SUCCESS rows with a message; **`?setcode=`** filters to one set, **`?vm=`** to one worker VM (db/42) |
| GET | `/workers` | parallel-worker fleet health from `ATD_WORKER_HEARTBEAT` — status, heartbeat, session/MFA state, last login duration/status, last successful extract, 24-hour run count, `paused` + `sessionAccount` (db/85 — that script now owns this handler; run 85 after any 13 re-run, never 56 after 85) |
| POST | `/workers/:id/pause` | operator hold (`:id` = worker_id or `all`) — sets `ATD_WORKER_HEARTBEAT.paused='Y'`; the worker claims no new work after its in-flight job. SYS_ADMIN (db/85) |
| POST | `/workers/:id/resume` | clears the pause flag; the worker claims work again. SYS_ADMIN (db/85) |
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
| GET | `/runs` · `/runs/:id` · `/runs/export` | run-log list / detail / CSV — list + export add the **Job Set** column + `?setcode=` + `?vm=` filters (db/42); detail adds `warningCount` + `warnings[]` with row/column/value/reason for non-blocking invalid-date warnings (db/49). Re-run both additive scripts after `13`. |
| POST | `/runs/:id/cancel` | cancel a run stuck on RUNNING (worker gone): closes the run-log row + releases any `ATD_ACTION_REQUEST` still holding it — a CLAIMED action keeps its idempotency bucket locked. 409 if already finished. **Cannot kill a process** (no command channel to the ATD fleet). db/81 — re-run after any 13 |
| GET | `/actions` | Fusion action queue list (paged; filter `status`/`type`/`search`; incl. db/46 telemetry `workerVm`/`startedAt`/`finishedAt`/`durationSecs`/`submittedBy`) — `otbi-atd/db/20_atd_action_ords.sql` (additive to `atd.rest`) |
| GET | `/actions/stats` | action-queue counts (ready/claimed/done/failed/cancelled) — dashboard tile |
| GET | `/actions/:id` | action detail: payload, last error, source status history |
| POST | `/actions/:id/retry` · `/actions/:id/cancel` | re-arm FAILED/CANCELLED → READY · cancel (not-DONE) |
| POST | `/actions/enqueue` | bulk-enqueue `PPM_TASK_ADDL_INFO` actions (`{rows:[{projectNumber,taskNumber,orgReference,…}]}`, ≤500/req; per-row result) — `otbi-atd/db/44_atd_ppm_org_ords.sql` (additive; Manage Projects Org page) |
| GET | `/actions/ppmlov` | type-ahead suggestion lists for Manage Projects Org (`?type=project\|task\|cc [&search=][&project=]`; `search` not `q` — ORDS reserves `q`) from `ATD_PROJECTS`/`ATD_TASKS`/`DCT_GL_COA_V` — `otbi-atd/db/45_atd_ppm_lov_ords.sql` (additive) |
| GET / POST | `/job-sets` | list job sets (+ member/enabled counts, interval, window, state) / create a set — `otbi-atd/db/41_atd_job_set_ords.sql` (additive to `atd.rest`). SYS_ADMIN |
| GET / PUT / DELETE | `/job-sets/:code` | detail (schedule + members[+`nextRun`] + recent runs) / partial update (schedule/window/flags) / delete (cascades membership) |
| POST | `/job-sets/:code/members` | add member(s) (`{jobName}` or `{jobNames:[…]}`; a job already in a set is skipped + reported) |
| PUT / DELETE | `/job-sets/:code/members/:job` | toggle `enabledInSet` / set `memberOrder` · remove a member |
| POST | `/job-sets/:code/run` | Run Set Now — top-priority enqueue every enabled member (`atd_set_pkg.run_now`) |
| PUT | `/job-sets/:code/pause` | pause / resume the whole set (`{paused:'Y'/'N'}`) |
| GET | `/job-set-jobs` | candidate picker — every job + its current set (if any); the detail add-member list filters to unassigned jobs |
| GET / PUT | `/config` | Runner Settings — list / update `ATD_RUNNER_CONFIG` rows (update-only, secrets masked). SYS_ADMIN |
| GET / PUT / DELETE | `/my-credential` | per-user OTBI credential profile (db/62+63): read own profile (`passwordSet` flag, never the password) / upsert (`password` applied only when present + non-empty — write-only; `catalogLogin` = OTBI catalog folder when it differs from the sign-in — drives permanent job ownership) / remove. SYS_ADMIN, always the caller's own row — `otbi-atd/db/63_atd_user_cred_ords.sql` (additive) |
| POST / GET | `/pbt/runs` | enqueue one PBT extract (`{mode,transactionTypes[],dateFrom,dateTo,businessUnits[],statuses[],includeApprovals,purgeMissing}`; mode `RANGE`\|`SYNC_SHALLOW`\|`SYNC_DEEP`) / request register with worker + timings + row counts — `otbi-atd/db/78_pa_budget_trx_ords.sql` (additive). **db/44's `/actions/enqueue` is hard-coded to `PPM_TASK_ADDL_INFO`, so PBT needs its own.** |
| GET | `/pbt/runs/:id` | one request + its run-log detail (the page polls this while a run is live) |
| GET | `/pbt/summary` | KPIs — headers by type (with date span + last refresh), by status, by BU; line + approval totals; budget-type LOV; `syncEnabled` |
| GET | `/pbt/data` | paged extracted-header register (`?type=&status=&bu=&from=&to=&search=&page=&size=`) |
| GET | `/pbt/data/:num` | one transaction — header + its detail lines (from the table matching `?type=`) + its approval trail |
| GET | `/credentials` | roster of personal OTBI accounts (username, fusionLogin, active/password/chat flags — no secrets) — db/63 (additive) |

All handlers: `dct_rest.validate_session` → 401, `dct_auth.has_role(user,'SYS_ADMIN')` → 403.

## API Endpoints (ORDS) — `/ords/admin/xl/` (platform `xl` module — VB Template repository)
Bearer-auth like every other module; **SYS_ADMIN-gated except `/templates/download`** (any valid
session). Errors arrive as `{"error":"…"}` with a proper HTTP status. Consumed by the VB Templates
page via `js/services/xlService.js` (base derived by swapping the module segment — the shared
api.js `wf` pattern; `config.xlBase` wins if set).
| Method | Path | Purpose |
|---|---|---|
| GET | `/templates/` | full repository — `{items:[{templateId, code, name, nameAr, description, module, versions:[{versionNo, isActive, notes, masterFile/SizeKb/By/At, pubFile/SizeKb/By/At}]}]}`. SYS_ADMIN |
| POST | `/templates/` | create (`{code,name,nameAr,description,module}` → `{templateId}`) or partial update (same body + `templateId`). SYS_ADMIN |
| POST | `/templates/version` | `{templateId, notes}` → `{versionNo}` — next version for a template. SYS_ADMIN |
| PUT | `/templates/file?templateid=&ver=&kind=master\|published&filename=` | raw-binary workbook upload (`application/octet-stream` body) → `{ok:1}`. SYS_ADMIN |
| GET | `/templates/file?templateid=&ver=&kind=master\|published` | binary workbook download (authed blob). SYS_ADMIN |
| POST | `/templates/activate` | `{templateId, versionNo}` → `{ok:1}`; 400 if that version has no published file. SYS_ADMIN |
| POST | `/templates/delete-version` | `{templateId, versionNo}` → `{ok:1}`; 400 if the version is ACTIVE. SYS_ADMIN |
| GET | `/templates/download?code=` | the template's **active published** file — any authenticated user (end-user download route) |

## Services / Data layer
| File | Role |
|---|---|
| `js/services/atdService.js` | one method per ORDS endpoint (Promises); incl. `getActionStats` / `listActions` / `getAction` / `retryAction` / `cancelAction`; job sets `listJobSets` / `getJobSet` / `createJobSet` / `updateJobSet` / `deleteJobSet` / `addSetMembers` / `updateSetMember` / `removeSetMember` / `runJobSet` / `pauseJobSet` / `listSetCandidates`; Project Budget Transactions `pbtSummary` / `pbtRun` / `pbtRuns` / `pbtRunById` / `pbtData` / `pbtDetail` |
| `js/services/xlService.js` | VB Template repository client for the platform `xl` ORDS module (`/ords/admin/xl/`): `list` / `save` / `newVersion` / `activate` / `deleteVersion` / raw-binary `uploadFile` / authed `fileBlobUrl` |
| `js/services/api.js` | re-export of `shared/js/api.js` (Bearer + 401 handling) |
| `js/services/authService.js` | session reader (shared `ifinance_jet_session`) |
| `js/services/config.js` | `apiBase=/ords/admin/atd`, `authBase=/ords/admin/dct` |

---

## Shared shell — Cross-UI SSO hand-off (2026-07-06)

When `FEATURE_SSO_HANDOFF` = Y (delivered by `GET /dct/boot`), the shared shell (`final apps/shared/js/shell.js`) injects an **APEX** button into the topbar: it calls `POST /dct/sso/code` (shared `/dct/` module, db/v2/41b) to issue a one-time code, then opens APEX App 200 already signed-in in a new tab. No app-local code — the button arrives via `shell.initRegionTheme`'s existing boot fetch.
