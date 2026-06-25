# otbi-atd — Deployment & Runbook

## 2026-06-25/26 — Production-workload hardening (Phases 0–2) + Track A spike

Driven by a run-log review (multi-hour overnight dead windows; a moved-path job blind for
~2 days; orphaned RUNNING rows stuck 4–6 days). All new behaviour is **config-gated** in
`ATD_RUNNER_CONFIG` (Runner Settings page) so each piece is independently toggleable.

- **Phase 0 — data quality (commit 486a098):** `prepare.py` date detection now wins over the
  numeric-name hint (fixed `BUDGET_DATE` → was NUMBER; remediated live via ALTER), date-name
  awareness, TIMESTAMP + ISO-`T`/fractional support; blank header → `COL_<pos>`. `load.py`
  DATE_FORMATS broadened. `PO_HEADERS.SUBMIT_DATE` (VARCHAR2, job disabled) corrects on its next
  Rebuild.
- **Phase 1 — reliability (commit 3b9b3fa):** stale-RUNNING reaper (`ATD_RUN_REAP_MINUTES`, closed
  the 2 orphans); proactive session mgmt (`ATD_WORKER_HEARTBEAT.session_started`, `ATD_DAILY_RELOGIN`
  job at 06:00 Asia/Dubai gated by `ATD_AUTO_RELOGIN`, aging nudge `ATD_SESSION_WARN_HOURS`+
  `ATD_AGING_MSG`); chronic-failure alert (`fail_alert_sent`, `ATD_FAIL_ALERT_STREAK`,
  `ATD_FAIL_ALERT_MSG`); Break window (`db/30 prod.atd_in_break` + `ATD_BREAK_ENABLED/START/END`,
  enforced in `enqueue` + worker idle loop, seeded DISABLED 20:00–06:00, midnight-wrap aware).
  DB 27/28/30 + db/12; runner.py.
- **Phase 2.1 — per-job scheduling (commit 2ed3b11):** `ATD_OTBI_JOBS.frequency_minutes` (NULL →
  `ATD_DEFAULT_FREQ_MINUTES`=15); `enqueue` only (re)queues a DUE job. db/29 + db/12.
- **Phase 2.2 — observability + frequency UI (2026-06-26, APP_VERSION 1.12.0):** additive ORDS
  **`GET /atd/jobs/health`** (`db/31`, no module rebuild needed by itself) returns break-window
  status + per-VM session age + per-job freshness. Dashboard gains a **Break-window banner**, a
  **Session Age** column on the Worker Fleet (amber past ~7h), and a **Job Freshness** card
  (last success / since / consecutive fails / stuck / frequency). The job form (+ jobDetail) gains a
  **Frequency (min)** field — persisted via the core `/jobs` POST + `/jobs/:name` PUT/GET in `db/13`,
  so this redeploy **rebuilt `atd.rest`**: ran **13 → 20 → 26 → 31** in order (20/26/31 are additive
  and must follow any `db/13` rebuild). Verified: all 8 handlers registered (incl. `jobs/health`,
  `workers/:id/refresh`, `actions/stats`); `frequencyMinutes` round-trips through create/update/get;
  `jobs/health` queries run clean (workers vm180/181 showed ~9h sessions — exactly what the new
  Session Age column surfaces). **No runner change.** Frontend: dashboard/jobs/jobDetail views+VMs,
  `atdService.getJobHealth`, EN/AR i18n.
- **Track A (BIP, MFA-free) spike — VIABLE, no MFA wall (2026-06-26).** BIP SOAP
  `ExternalReportWSSService` at `…/xmlpserver/services/…` responds at the **SOAP/WS-Security layer**
  with **no Entra/Microsoft login redirect** → auth is credential-based, non-interactive; **no
  separate MFA-free account needed.** Required combo = **SOAP 1.2** content-type
  (`application/soap+xml`) + **WS-Security UsernameToken** (HTTP Basic → 401; text/xml → VersionMismatch).
  Current state: hand-rolled curl WS-Security (UsernameToken PasswordText, with and without
  `wsu:Timestamp`) returns `InvalidSecurity: error in processing the WS-Security security header` —
  i.e. OWSM rejects the **header structure**, NOT the credentials (no `FailedAuthentication`, so the
  password isn't even checked → these attempts don't count toward credential lockout). **Lesson:
  stop hand-rolling WSSE in curl** — Fusion OWSM is strict about header canonicalization/ordering.
  **Recommended completion (the actual build, not more probing):**
    1. Build `extract_bip.py` with **python `zeep` + `zeep.wsse.UsernameToken`** (forms the WSSE
       header correctly) against `ExternalReportWSSService` (SOAP 1.2). OR
    2. Try `…/xmlpserver/services/v2/ReportService` (the non-WSS variant) with **HTTP Basic** —
       it may not require OWSM WSSE at all (untested for runReport; try first, carefully).
  Then wire `extract_track='BIP'` + per-job BIP report mapping. **CAUTION: minimise live auth
  attempts against the shared account** (the browser workers depend on it). Verdict stands: **no MFA
  wall — the account authenticates non-interactively; this is now an integration/build task.**

## What is proven (2026-06-17)
End-to-end pipeline for the **GRN All** analysis works:

1. **Auth** — login chain is Oracle IDCS → **ADGOV-Employees-Login** → Microsoft
   Entra ID (username+password) → **Microsoft Authenticator push, number-matching**.
   Credentials valid; MFA is enforced (semi-attended — a human approves the push).
2. **Extract** — `GET /analytics/saw.dll?Go&path=<ENC>&Action=Download&Format=csv`
   returns `text/csv`. **The param is lowercase `path`; capital `Path` → WebLogic 404.**
   Pulled 317 KB / 1,527 rows.
3. **Load** — `PROD.ATD_GRN_ALL` created from the dataset (16 cols) and loaded;
   verified 1,527 rows, 1,051 distinct receipts, dates 2026-03-02→2026-06-16,
   total 701,610,978, 94 non-null rates (matches the source profile).
4. **Orchestration** — control tables (`ATD_OTBI_ENV/_TARGET_DB/_JOBS/_LOAD_RUN_LOG`)
   deployed; job `GRN_ALL` seeded (BROWSER track, TRUNCATE_INSERT → `PROD.ATD_GRN_ALL`).

## DB objects deployed
Run via SQLcl (`sql -name prod_mcp`), in order:
`01_atd_control_tables.sql`, then per analysis a table + seed:
`06_grn_all_table.sql` + `07_seed_grn_all.sql`,
`08_suppliers_table.sql` + `09_beneficiaries_table.sql` + `10_seed_more.sql`.
(`02_network_acl` / `03_otbi_pkg` / `04_scheduler` are Track A only — not needed for Track B.)

Three jobs are live in `ATD_OTBI_JOBS` (all BROWSER / TRUNCATE_INSERT):
| job | analysis path | target table |
|---|---|---|
| GRN_ALL | /users/haghareb@dctabudhabi.ae/MG/GRN All | PROD.ATD_GRN_ALL |
| SUPPLIERS | /users/haghareb@dctabudhabi.ae/Hany/Suppliers/Suppliers | PROD.ATD_SUPPLIERS |
| BENEFICIARIES | /users/haghareb@dctabudhabi.ae/Hany/AP/Beneficiaries | PROD.ATD_BENEFICIARIES |

`ATD_GRN_ALL` is already loaded (1,527 rows, verified); `ATD_SUPPLIERS` (1,398) and
`ATD_BENEFICIARIES` (12,086) are created and load on the next runner run.
**ADB gotcha:** seeding MERGE hit ORA-12860 (parallel DML); `07`/`10` do
`ALTER SESSION DISABLE PARALLEL DML` + `NOPARALLEL` on the control tables.
**Date handling:** `load.py` parses DATE/TIMESTAMP columns in Python (mixed date-only +
datetime values), so no NLS dependency.

## Running the Track B runner (`runner/`)
DB load defaults to **`oracledb`** (fast; see "Fast load mode" below) when DB creds are present,
and falls back to **SQLcl** (`sql -name prod_mcp`, no separate creds) otherwise.

One-time setup on the host:
```
pip install -r runner/requirements.txt   # playwright + httpx + python-oracledb
python -m playwright install chromium
```
Environment variables:
```
# Fusion login (used by auth.py; referenced by the env's credential_ref FUSION_ADGOV)
set OTBI_USER=hg2248@dctabudhabi.ae
set OTBI_PWD=********
set ATD_STATE_DIR=c:\otbi-atd-state   # where auth_state_*.json + mfa number file live
# SQLcl (defaults shown) — used for ALL DB reads/writes, reuses stored creds
set ATD_SQLCL=C:\claude\tools\sqlcl\sqlcl\bin\sql.exe
set ATD_SQLCL_CONN=prod_mcp
set ATD_LOAD_BATCH=200                 # rows per INSERT ALL (tuning)
```
Run a job:
```
cd runner
python runner.py GRN_ALL      # or: python runner.py   (all enabled BROWSER jobs)
```
Verified 2026-06-17: all 3 jobs load via SQLcl with no DB creds —
BENEFICIARIES 12,086 / GRN_ALL 1,527 / SUPPLIERS 1,398, each a SUCCESS row in
ATD_LOAD_RUN_LOG. SQLcl headless gotcha: it needs an empty real-file stdin and a
real-file stdout (NUL/pipe -> "IOException: Incorrect function"); `SET LONG` is
raised so JSON CLOB columns aren't truncated to 80 chars (both handled in sqlrun.py).
On first run (or after the session expires) the console prints
`>>> APPROVE THE AUTHENTICATOR PUSH — ENTER NUMBER: NN`; open Authenticator, enter NN,
approve. The session is saved to `auth_state_FUSION_ADGOV.json` and reused on later runs
(no MFA) until Entra expires it. Each run writes a row to `PROD.ATD_LOAD_RUN_LOG`.

## Creating analyses (`create_analysis.py`) — build, don't just load
`add_analysis.py` registers an analysis that already exists; `create_analysis.py` **builds**
one in the OTBI Answers UI from a declarative spec (`otbi-atd/specs/*.json`) and reuses the
same `auth.authenticate()` session, so it triggers the same MFA flow as the runner.
```
cd runner
python create_analysis.py --spec ../specs/po_headers.json --headed   # bring-up: watch it
python create_analysis.py --spec ../specs/po_headers.json --load      # create + table + load
```
Four spec inputs: `subject_area`+`columns[]` (the data), `params[]` (optional prompted
filters), `save_folder`, `name`. `--load` chains `add_analysis.py` + `runner.py`.
**Selectors are confirmed live** (the Answers editor is dynamic): use `--headed` or `--pause`
(Playwright inspector) on first bring-up of a new pod/subject area, then harden the selector
lists in `create_analysis.py`; step failures screenshot to `ATD_STATE_DIR` as
`create_<step>_*.png`. The reference spec `po_headers.json` builds PO header details from
`Procurement - Purchasing Real Time` → `/users/haghareb@dctabudhabi.ae/PO/PO Headers`
(TRUNCATE_INSERT full snapshot; see the 2026-06-19 entry below for the date-only + Status
column choices). Save to `/Shared Folders/...` instead if a different service account runs
the scheduled loads (personal folders are private to their owner).

## Fast load mode (oracledb) — NOW THE DEFAULT
`oracledb` is auto-selected when `ATD_DB_USER`+`ATD_DB_PASSWORD` are set; it falls back to SQLcl
otherwise. Force either with `ATD_DB_MODE`. Pure-Python **thin mode** (no Instant Client, no Java):
```
pip install python-oracledb
set ATD_DB_USER=ADMIN          &  set ATD_DB_PASSWORD=********
set ATD_WALLET_PASSWORD=****** &  rem decrypts ewallet.pem (= DB password here)
set ATD_DB_DSN=prod_low        &  set TNS_ADMIN=<wallet dir: ewallet.pem + tnsnames.ora>
set ATD_DB_CHUNK=5000          rem rows per array-bind round-trip
```
**Measured A/B on this host (BENEFICIARIES 12,160 rows): pure DB load 80.7s → 0.5s = 155×;
end-to-end 109s → 17.5s.** Same control tables, same runner. Two gotchas (full detail REFERENCE.md
§10): thin mode **needs the wallet password** (SQLcl/JDBC use the password-less `cwallet.sso`,
which thin mode ignores); and the wallet's `retry_count=20` makes a *bad* connect hang ~60s while
a correct one is <1s. On Windows the secrets live in the git-ignored `runner/env.ps1`
(`. .\env.ps1` then `python runner.py`).

## Job ordering (priority / run_order)
`db/11_atd_job_ordering.sql` adds `priority` (lower runs earlier; default 5) and `run_order`
(sequence within a band; default 100) to `ATD_OTBI_JOBS`. Both runner paths order by
`priority, run_order, job_name`. Re-sequence with a plain `UPDATE` — no code change.

## Truncation / OTBI export cap warning
OTBI caps the CSV download server-side (often ~65k rows) → large analyses can come back
silently truncated. The runner flags it: if a load's row count equals a common cap
(`ATD_TRUNCATION_CAPS`) or is below `ATD_EXPECTED_MIN`, it prints `[WARN]`, sends it to Telegram,
and stores it in `ATD_LOAD_RUN_LOG.message`. Raise the pod's download limit before relying on
extracts near the cap. Full detail: REFERENCE.md §7.

## MFA number delivery (Telegram) — approve from anywhere
When the saved session has expired the runner needs a fresh push approval. It prints the
number-matching value NN, writes it to a file, AND sends it via `notify.py` so you can read
it on your phone and approve in Authenticator without being at the host.

Telegram setup (one-time, ~2 min):
1. In Telegram, message **@BotFather** → `/newbot` → get the **bot token**.
2. Send any message to your new bot (so it can reply to you).
3. Get your **chat id**:  `set ATD_TG_TOKEN=...` then `python notify.py chatid`.
4. Configure the runner host:
```
set ATD_NOTIFY=telegram
set ATD_TG_TOKEN=123456:ABC...
set ATD_TG_CHAT=<your chat id>
set ATD_MFA_WAIT=420            # seconds the runner waits for approval (default 420 = 7 min)
```
5. Test:  `python notify.py test`  (you should get a Telegram message).

Other channels (same `notify.send`): `ATD_NOTIFY=email|webhook|sms` — see env vars at the
top of `runner/notify.py` (Teams/Slack incoming webhook, SMTP, or Twilio SMS). Notification
is best-effort: a delivery failure is logged but never breaks the login.

**Editable message text (db/18, Runner Settings page):** the three notification
messages are templates in `ATD_RUNNER_CONFIG`, editable in the app's **Runner Settings**
page — no code change needed. `notify.render(key, default, ...)` formats them, falls back to
the built-in default if the key is blank/malformed, and never raises:
- `ATD_MFA_MSG` — MFA sign-in approval. Placeholders `{number}` (auto-appended if the
  template omits it, so the code can never be lost) and `{env}`.
- `ATD_JOB_MSG` — job status / truncation warning. Placeholders `{job}`, `{note}`.
- `ATD_DRIFT_MSG` — schema-drift warning. Placeholders `{job}`, `{drift}`.

Re-running `db/18_atd_msg_templates.sql` is idempotent (MERGE inserts only when absent —
it never overwrites a value edited in the UI).

## Scheduling
Cannot be scheduled from ATP (Track B drives a browser). Runs stay inside the Entra session
lifetime, so MFA is only needed occasionally; the runner surfaces the number (Telegram) on refresh.

**This host — live every 15 min (registered 2026-06-18):** Windows Task `OTBI-ATD Loader` runs
`runner/run_atd.ps1`, which dot-sources the git-ignored `env.ps1` and drains **all three runner
queues each cycle** (since 2026-06-19): `--discover` (subject-area column-picker scrapes),
`--build` (Add-New-Analysis requests), then the plain load for all enabled jobs — each phase logged
separately to `otbi-atd/run.log`. The discover/build phases early-exit cheaply (no browser/MFA) when
their queues are empty, so they cost nothing when idle but make every queue self-draining like the
load queue. Trigger: every 15 minutes, `MultipleInstances=
IgnoreNew`, 10-min limit, `StartWhenAvailable`. Runs in the logged-on user session (Playwright
headless). Manage it:
```
Get-ScheduledTaskInfo -TaskName 'OTBI-ATD Loader'      # last result + next run
Start-ScheduledTask  -TaskName 'OTBI-ATD Loader'       # run now
Disable-ScheduledTask -TaskName 'OTBI-ATD Loader'      # pause
Unregister-ScheduledTask -TaskName 'OTBI-ATD Loader' -Confirm:$false   # remove
```
To run **while logged off**, re-register with stored credentials (`-User`/`-Password` or
`-LogonType S4U`). `run.log` is git-ignored. (Linux/VM equivalent: the cron line in
`oci-vm-setup.md` §7.)

## Adding another analysis
1. (optional) create its target table — model on `06_grn_all_table.sql`.
2. Insert a row in `ATD_OTBI_JOBS` (copy the `GRN_ALL` MERGE in `07`): set `source_ref`
   to the analysis path, `stage_table`, `load_mode`, and `column_map_json`
   (CSV header → column). No code change.

## To repoint host / account / database
Edit rows, not code: `ATD_OTBI_ENV.analytics_base_url` (pod), `.credential_ref` (account),
`ATD_TARGET_DB` (LOCAL_ATP vs REMOTE). Both tracks read the same tables.

## 2026-06-19 — PO Headers (date-only) + "Add New OTBI Analysis" from the UI
**PO Headers analysis** built via `create_analysis.py --spec ../specs/po_headers.json`
(18 cols, `/users/haghareb@dctabudhabi.ae/PO/PO Headers`), loaded to `PROD.ATD_PO_HEADERS`
(`TRUNCATE_INSERT`, 2641 rows). Date columns (Creation/Approved/Closed) sourced from the
`Time - <X> Date` folders' **`Report Date`** attribute (date-only); status from
`Document Status` → **`Document Status Meaning`** (the bare attribute returns a hierarchy
total). Two robustness fixes so date columns type as `DATE` despite a few OTBI-misaligned
rows: `prepare.profile` tolerates ≤2% non-date cells when typing a `DATE` column;
`load._to_dt` nulls an unparseable date cell instead of failing the load.

**Add New OTBI Analysis (feature).** Jobs page → "+ New OTBI Analysis" drawer collects a
spec (subject area, save folder, name, Folder/Column/Heading repeater, optional prompt JSON,
load mode) and POSTs `{name, saveFolder, specJson}` to `/atd/analyses`. Deploy order:
1. `sql -name prod_mcp @otbi-atd/db/15_atd_analysis_request.sql`  (creates `ATD_ANALYSIS_REQUEST`)
2. `sql -name prod_mcp @otbi-atd/db/13_atd_ords.sql`  (FRESH session — adds the
   `atd_analysis_request` synonym + `GET/POST /atd/analyses` handlers)
3. Bump `final apps/ATD/Jet/index.html` `APP_VERSION` (→ 1.4.0).
The runner host drains requests: **`python runner.py --build`** (oracledb mode) builds each
queued analysis in OTBI (`create_analysis.build_analysis`), registers it as a job, and loads
it once; marks the request DONE/FAILED. (Schedule `--build` alongside the loader task, or run
on demand. Building needs the OTBI session, so MFA may be prompted like any runner login.)

**Column picker (Add-New-Analysis drawer).** Instead of typing Folder/Column labels, pick a
**discovered** subject area and tick its real folders/columns. Deploy order:
1. `sql -name prod_mcp @otbi-atd/db/16_atd_sa_catalog.sql`  (creates `ATD_SA_CATALOG` — the
   discover queue **and** the picker cache; one row per subject area)
2. `sql -name prod_mcp @otbi-atd/db/13_atd_ords.sql`  (FRESH session — adds the
   `atd_sa_catalog` synonym + `GET /atd/subject-areas`, `GET /atd/subject-areas/columns?sa=`,
   `POST /atd/subject-areas/discover` handlers)
3. Bump `final apps/ATD/Jet/index.html` `APP_VERSION` (→ 1.5.0).
"Discover columns" POSTs `/atd/subject-areas/discover` (QUEUED). The runner host drains scrapes:
**`python runner.py --discover`** (oracledb mode) drives the OTBI Answers tree
(`create_analysis.discover_subject_area`) — enumerates every top-level folder, walks each
(virtualised) folder's leaves, and caches `{folders:[{folder,columns:[]}]}` into
`ATD_SA_CATALOG` (status READY). Scope = **whole subject area per run** (first scrape of a big
SA can take minutes; the picker is instant + offline afterwards). The picker reads the cache via
`GET /atd/subject-areas/columns?sa=`; non-READY returns `{status, folders:[]}` so the UI shows
QUEUED/SCRAPING/FAILED. Sub-folders that leak into a parent's leaves are filtered out (a folder
owns a `_disclosure` node). Standalone test: `python create_analysis.py --discover --subject-area "…" [--headed]`.
**Gotcha (live-pod, fixed):** the Answers criteria pane lists EVERY subject area in the catalog
as its own `criteriaDataBrowser$…` node, so enumerating all `_disclosure` ids grabs all subject
areas as phantom folders (a Financials subject area showed 274). OTBI **quotes subject-area names
in the id** (`criteriaDataBrowser$"Costing - X Real Time"`) but presentation **folders are
unquoted** (`criteriaDataBrowser$Currency`) — `_top_folders` keeps only unquoted ids (and drops
zero-column folders). Verified: "Project Control - Financial Project Plans Real Time" → 11 folders
/ 195 columns.

**Full-depth nested discovery + dedicated 1-min runner + AI suggester (2026-06-20, APP_VERSION 1.6.4).**
- **Nested discovery (full depth).** `create_analysis.discover_subject_area` now recurses into
  sub-folders to the true leaf columns and returns a **nested tree**
  `{subject_area, folders:[{folder, columns, folders}], column_count, folder_count, scraped_at}`.
  The builder (`build`/`add_column`) is **path-aware**: a spec column may carry `path:[...]`
  (top→immediate parent) and the builder expands every ancestor before adding the leaf
  (`_expand_path`/`_child_id`); legacy depth-1 `folder` still works. **Live-DOM gotcha (caused a
  hang):** OTBI tree rows are `criteriaDataBrowser$<base>_details` with the twisty/children as
  SIBLINGS on `<base>`; **folder vs column is the ICON** (`.../obips.Tree/folder.png` vs
  `column.png`) — NOT the disclosure, which EVERY node (incl. leaf columns) carries collapsed.
  The first cut keyed on disclosure → treated every column as a folder → 30s expand-timeout each →
  multi-hour hang. `_JS_CHILDREN` now keys folder-ness on the icon. Verified: Requisitions
  15 flat→**73 folders/1166 cols**, Project Control 11→40/370, Supplier 7→34/552 (depth-3).
  Re-queue all SAs after deploying (old catalogs are flat): `UPDATE prod.atd_sa_catalog SET
  status='QUEUED' WHERE catalog_json NOT LIKE '%"column_count"%'`.
- **Dedicated discovery runner.** `run_atd_discover.ps1` + Windows Task **`OTBI-ATD Discover`**
  (every **1 min**, `MultipleInstances=IgnoreNew`, 30-min limit, logged-on session) drains the
  discovery queue independently of the 15-min loader. `runner.py --discover` now processes **ONE**
  oldest QUEUED SA per invocation, so a multi-minute scrape never overlaps the next tick and each
  SA gets the full limit. `run_atd.ps1` reverted to **build + load only** (no `--discover`).
  `--discover` still no-ops (no browser) when the queue is empty. Manage:
  `Get-ScheduledTaskInfo / Start-ScheduledTask / Disable-ScheduledTask -TaskName 'OTBI-ATD Discover'`.
- **Single-browser lock (2026-06-20).** The 1-min Discover task and the 15-min loader must never
  drive an OTBI browser at the same time — two Playwright sessions on the one Fusion SSO session
  corrupt each other's server-side Answers-editor state (intermittent build failures like
  `folder did not load children: '<name>'` / `saTreeNode_NN`). Both `run_atd.ps1` and
  `run_atd_discover.ps1` acquire the SAME exclusive lockfile `otbi-atd/.otbi_runner.lock`
  (`[System.IO.File]::Open(path,'OpenOrCreate','ReadWrite','None')`) before launching python; if the
  other holds it, the cycle is skipped and retried next tick. One OTBI browser per host — the only
  safe model with a single MFA account.
- **Stale-SCRAPING reaper (2026-06-20).** `--discover` only retries `QUEUED` rows, so a row left in
  `SCRAPING` by a crashed/killed scrape (or one that wrote the catalog but lost the `READY` flip)
  would never recover. `runner._reap_stale_discovery` runs at the top of every `--discover` cycle:
  it resets to `QUEUED` any `SCRAPING` catalog row that has **no** `DISCOVER` run-log row `RUNNING`
  within `ATD_LEASE_MINUTES` (default 30), and closes the dangling `RUNNING` run-log rows as
  `FAILED`. A genuinely-live scrape keeps a fresh `RUNNING` log row and is never reaped. Gotchas:
  the statements carry `/*+ no_parallel */` (these ATD tables auto-parallelize → ORA-12860 deadlock
  under concurrency) and compare `started >= CAST(systimestamp AS TIMESTAMP) - …` (the run-log
  `started` is a plain `TIMESTAMP`; comparing it against TZ-aware `systimestamp` mis-fired the lease
  — same skew fixed earlier in `ATD_QUEUE_PKG.reap_stale`).
- **AI column suggester (Sonnet 4.6).** `db/17_atd_ai.sql` = network ACL for `api.anthropic.com`
  + `ATD_RUNNER_CONFIG` keys `AI_MODEL` (default `claude-sonnet-4-6`) / `AI_MAX_TOKENS` /
  `AI_API_KEY` (secret; blank → reuses the AR ANTHROPIC provider key) + `DCT_ATD_AI_PKG`.
  `suggest_columns(sa, request)` flattens the cached catalog to a NUMBERED list, asks Claude for
  the matching **indices**, and maps them back to `{path,column}` server-side — so a suggestion can
  never be a column outside the catalog (no hallucination). ORDS `POST /atd/subject-areas/suggest`
  `{sa, request}` (synonym `dct_atd_ai_pkg`; error map -20404→404 / -20001→400). Frontend: a
  "✨ Suggest columns" textarea in the Add-New-Analysis drawer ticks the matches in the nested
  picker. Deploy: `@db/17_atd_ai.sql` (own session) then `@db/13_atd_ords.sql` (FRESH session).
  **PLS gotchas:** `DBMS_LOB.CONVERTTOBLOB` offset/lang args are IN OUT (pass variables, not
  literals); the CLOB-escape chunk buffer must be `VARCHAR2(32767)` reading 8000 chars (ORA-06502
  otherwise). Verified live: a supplier-data request returned 11 correctly-pathed real columns.

**OTBI Discovery page (ATD JET, APP_VERSION 1.6.0).** New `discovery` view = one page, three
tables: (1) discovery requests (`/subject-areas`, queue-style, with Discover / Re-discover),
(2) discovery run history (`/subject-areas/runs`), (3) analysis build requests (`/analyses`).
Backend additions: each `--discover` scrape now writes an `ATD_LOAD_RUN_LOG` row with
`track='DISCOVER'` (job_name = subject area truncated to 80, row_count = column count); new
`GET /atd/subject-areas/runs` lists them, and the main `/runs` now excludes `track='DISCOVER'` so
the Run Logs page stays load-focused. Redeploy `13_atd_ords.sql` (fresh session) for the new
endpoint; no new DB script (reuses `ATD_LOAD_RUN_LOG`). Nav item added under Operations in
`appController.js`.

---

**Fusion write-back ACTIONS — AP invoices from Petty Cash (APP_VERSION 1.7.0, 2026-06-20).**
The inverse of the extract jobs: a queue of actions the runner *performs inside* Oracle Fusion via
the SAME authenticated browser session (no service account). First action type = `AP_INVOICE`,
sourced from approved Petty Cash reimbursements.

- **DB (new, isolated):** `otbi-atd/db/19_atd_action_queue.sql` = `ATD_ACTION_REQUEST` (queue:
  `READY|CLAIMED|DONE|FAILED|CANCELLED`, UNIQUE `idem_key`, `payload_json`) + `ATD_ACTION_PKG`
  (`enqueue_action` MERGE-on-idem_key, `claim_next_action` FOR UPDATE SKIP LOCKED,
  `mark_action_done/failed`, `reap_stale_actions`, `cancel_action`) + `ATD_ACTION_TYPE`/`ATD_ACTION_STATUS`
  lookups. **Idempotency law:** a `DONE` row is never re-created; `enqueue` re-arms only FAILED/CANCELLED.
- **DB (PC source):** `final apps/PC/db/07_pc_fusion.sql` = `DCT_PC_FUSION_PKG`
  (`build_ap_invoice_payload` / `enqueue_fusion_action` / `receive_fusion_result`) + 4 tracking
  columns on `DCT_PC_REIMBURSEMENTS` (`post_to_fusion`, `fusion_status`, `fusion_invoice_id`,
  `fusion_pushed_at`) + 2 settings (`FUSION_POST_REIMB` Y/N gate, `FUSION_ENV_NAME`). Hooks:
  `db/v2/14` `apply_final_approval` (sweep) + `final apps/PC/db/06_pc_ords.sql` (interactive approve)
  both call `dct_pc_fusion_pkg.enqueue_fusion_action(reimb_id)` — **no-op until FUSION_POST_REIMB=Y**.
  `changed_by` on `dct_request_status_history` is NOT NULL → both procs resolve the petty-cash owner
  user_id (bit us once: ORA-01400).
- **Runner:** `runner.py --actions [--forever]` (oracledb mode) drains the queue; `actions/__init__.py`
  dispatch + `actions/ap_invoice.py` driver. **Idempotency probe** = read-only Payables REST lookup
  by InvoiceNumber over the session cookies (`ctx.request`); if found, return that id, create nothing.
  **Writes are gated by `ATD_ACTION_LIVE=1`** — without it the driver does probe + form validation and
  raises `DryRun` (nothing saved). Pod-specific Create-Invoice selectors in `ap_invoice.py` MUST be
  confirmed in a HEADED run against a Fusion TEST pod before the first live save.
- **Schedule:** `run_atd_actions.ps1` (e.g. every 5 min, MultipleInstances=IgnoreNew) — shares the
  SAME `.otbi_runner.lock` as loader/discover so no two tasks drive a Fusion browser concurrently.
- **App 208 UI/ORDS:** `otbi-atd/db/20_atd_action_ords.sql` (ADDITIVE — no DELETE_MODULE) adds
  `GET /atd/actions`, `GET /atd/actions/stats`, `GET /atd/actions/:id`, `POST /atd/actions/:id/retry`,
  `POST /atd/actions/:id/cancel` to the live `atd.rest`. New JET `actions` view + dashboard tile.
  - **⚠️ ALWAYS run `20_atd_action_ords.sql` RIGHT AFTER `13_atd_ords.sql`.** `13` does
    `ORDS.DELETE_MODULE(atd.rest)` + rebuild, so any redeploy of `13` (e.g. the 2026-06-21 `/workers`
    add) WIPES these additive `/actions/*` handlers. Symptom: the dashboard's `/actions/stats` call
    404s and the browser shows a CORS **"Network error — check your connection"** toast + a dead
    Fusion Actions page. Fix = re-run `20`. (Same trap as the TM `06`/`14` rule.) Hit & fixed
    2026-06-21.
- **Employee→Fusion supplier map:** `otbi-atd/db/21_emp_supplier_map.sql` = `DCT_EMP_SUPPLIER_MAP`
  (`source_module`, `party_key`=employee_num/freelancer_id, `supplier_number/name/site`,
  `business_unit`, **`payment_method`**, `pay_group/payment_terms/currency_code`,
  UNIQUE(source_module, party_key)). `build_ap_invoice_payload` LEFT-JOINs it (`PC` + employee_num,
  active) → emits a `supplier{number,name,site,paymentMethod,payGroup,paymentTerms}` block and
  overrides `businessUnit`/`currency`; omitted (ABSENT ON NULL) when unmapped. Per-app by design.
  Ships EMPTY — populate before live posting.
- **Deploy order (each in its OWN fresh SQLcl session — synonym rule):**
  `@otbi-atd/db/19...` → `@otbi-atd/db/21...` → `@final apps/PC/db/07...` → `@db/v2/14...` →
  `@final apps/PC/db/06...` (recreates pc.rest) → `@otbi-atd/db/20...`. Then bump ATD `APP_VERSION` + ship JET.
- **Verified (2026-06-20):** all objects VALID; idempotency unit (DONE never resurrected); end-to-end
  on real RMB-2026-00100 — payload builds, enqueue → 1 READY + reimb QUEUED, runner-callback → POSTED.
  Runner action handler unit-tested (idempotent skip + dry-run safety). **Pending:** headed live test
  of `ap_invoice.py` against a Fusion test pod (needs MFA approval) before enabling FUSION_POST_REIMB=Y.
- **Honest note:** semi-attended — runs unattended while the saved SSO session is valid; a human
  approves the Authenticator number-match only when it expires (same as the extract jobs).
- **Explicit Fusion apps URL (db/22, 2026-06-21):** `ATD_OTBI_ENV.fusion_apps_url` (FUSION_ADGOV =
  `https://iaaibv.fa.ocs.oraclecloud29.com`). `ap_invoice._apps_base` resolves: this column →
  `ATD_FUSION_APPS_URL` env → derive from `analytics_base_url`. Threaded via `config.get_action` /
  `get_default_browser_env` → worker env dict.
- **Supplier identity source:** `DCT_EMP_SUPPLIER_MAP` is fed from the **HR module Employee screen**
  (employee↔supplier mapping; HR has no supplier columns yet → this table is the store, party_key =
  employee_number). HR-screen wiring is a follow-up.
- **Smoke test (db/22 + runner):** `smoke_ap_invoice.fields.txt` (fill-in form) → generate
  `payload.json` → `python smoke_ap_invoice.py payload.json` (HEADED, bypasses the queue). It first
  runs a **fscmRestApi reachability probe** (settles the InvoiceId source: REST read-back if reachable,
  else the invoice number we set + UI-based idempotency), then drives Create-Invoice. Dry-run by default
  (fills the form, validates selectors, does NOT save); `ATD_ACTION_LIVE=1` actually saves. `create()`
  now fills the form BEFORE the save gate so a dry-run exercises the selectors.
- **AP invoice TYPE (answer to "Fusion doc"):** in Fusion Payables every invoice has a TYPE — Standard,
  Prepayment, Credit Memo, etc. Reimbursement = **Standard** (built). Advance = likely **Prepayment**;
  Clearing = prepayment application / adjustment — both pending confirmation before wiring their
  action_types.

---

**Round 2 — all 3 PC documents + configurable type + HR mapping screen (2026-06-21):**
- **Configurable invoice TYPE** (`otbi-atd/db/23_fusion_doctype_map.sql`): `DCT_FUSION_DOCTYPE_MAP`
  (source_module, source_type) -> invoice_type. Seeded PC_REIMB=Standard, PC_CLEAR=Standard,
  PC_ADVANCE=Prepayment. `DCT_PC_FUSION_PKG.doctype()` reads it (default Standard); the payload
  carries `invoiceType`; `ap_invoice.py` fills the Fusion Invoice Type field from it.
- **All 3 PC documents** now post (each its own per-type gate + tracking cols on
  DCT_PETTY_CASH / DCT_PC_CLEARING / DCT_PC_REIMBURSEMENTS):
  - Reimbursement -> Standard, gate FUSION_POST_REIMB, hook = approve (06 + sweep 14).
  - Advance -> Prepayment, gate FUSION_POST_ADVANCE, hook = **disburse** (06 pc/:id/disburse,
    fires at status->ACTIVE), idem = pc_number.
  - Clearing -> Standard, gate FUSION_POST_CLEARING, hook = approve (06 + sweep 14), idem = clearing_number.
  `receive_fusion_result` is now generic `(source_type, source_id, invoice_id, ref)`; the runner
  passes `action.source_type`. Verified: reimb->Standard, advance->Prepayment enqueue end-to-end.
- **HR Employee supplier-mapping screen** (`final apps/HR/db/07_hr_supplier_map_ords.sql`, additive
  to hr.rest): `GET/PUT /hr/employees/:id/supplier-map` upsert DCT_EMP_SUPPLIER_MAP (source_module='PC',
  party_key = employee_number). HR `employeeDetail` view: a "🏛 Supplier" button + modal (all fields
  incl. payment_method). HR APP_VERSION 4.6.0. This is the map's source of truth per the requirement.
- **`db/v2/14` DEPLOYED 2026-06-21 (VALID):** the CLEARING **sweep-path** enqueue is now live
  alongside the reimbursement one; interactive approval (06) and idle-timeout auto-approve both
  enqueue all 3 PC documents. All Fusion-action DB deploys complete; only the live headed smoke
  test + populating `DCT_EMP_SUPPLIER_MAP` remain before flipping a `FUSION_POST_*` gate to Y.

## 3-VM parallel worker fleet — DEPLOYED 2026-06-21 (Track B scale-out)

The Track B runner now runs on **3 on-prem Oracle Linux 9.7 VMs** (replaced the single Windows
box + the OL7.9 agents) as **parallel workers draining the one shared ADB queue**.

- **VMs:** `atd-vm180/181/182` = 192.168.1.180/181/182 on standalone ESXi 6.5 (192.168.1.190),
  provisioned hands-off via OL9.7 kickstart (see `provision/`). 2 vCPU / 6 GB / 50 GB each.
- **Each VM runs** `runner.py --worker --forever` as systemd **`atd-worker.service`**
  (`runner/systemd/`, `Restart=always`, `Environment=HOME=/root` + `PYTHONUNBUFFERED=1`, logs to
  journald — **not** `append:/root/...`, which SELinux blocks → status 209/STDOUT). One warm Fusion
  session per VM; **worker id = hostname** so `env.sh` is identical on every VM.
- **The `--forever` loop now also drains discover + builds** when no load job is waiting (reuses the
  warm session), and calls `reap_stale` + a stale-peer Telegram alert each idle cycle.
- **DB changes (deployed):** `db/12` `ATD_QUEUE_PKG` — `enqueue` skips `CLAIMED` rows; added
  `claim_sa` / `claim_build` (FOR UPDATE SKIP LOCKED) so discover/build are race-safe across VMs.
  `db/24` `ATD_ENQUEUE_JOB` (DBMS_SCHEDULER, every 15 min — the only schedule). `db/25`
  `host_id` on `ATD_LOAD_RUN_LOG` + `ATD_WORKER_HEARTBEAT`. `db/13` ORDS `GET /atd/workers` + `host`
  in the runs feed. (Numbered 24/25 — 19–23 are the parallel Fusion-action work-stream.)
- **UI (App 208, APP_VERSION 1.8.0):** dashboard **Worker Fleet** panel (green/red per VM, current
  job, last-seen, runs-24h) + **VM column** on the Runs page.
- **Deploy / scale-out:** `runner/deploy_worker.sh <ip>` (idempotent: software via `install_sw.sh`,
  syncs runner+wallet+`env.sh`, enables the service). Add a VM later with
  `provision/provision_vm.sh <host> <ip>` then `deploy_worker.sh <ip>` — **no DB/queue/UI change**, it
  self-registers in the queue + dashboard. **Old Windows "OTBI-ATD Loader" task DISABLED** (cutover).
- **GOTCHAS hit & fixed:** PyPI package is **`oracledb`** not `python-oracledb`; OL9 needs Chromium
  libs via `dnf` (Playwright `--with-deps` is Debian-only) — `CHROMIUM_SMOKE_OK` confirms; kickstart
  `network` must be **one line** (pykickstart chokes on `\` continuation → "unrecognized arguments");
  systemd needs `HOME=/root` (env.sh uses `$HOME` for `TNS_ADMIN`); the MFA number-match screen needs
  **polling** (single look races it) — auth.py now polls ~36s; the heartbeat staleness check must
  `CAST(SYSTIMESTAMP AS TIMESTAMP)` (raw TIMESTAMPTZ vs TIMESTAMP skews by the TZ offset → false DOWN).
- **VALIDATED:** parallel load spread across 2 VMs with no duplication (SUPPLIERS→vm180,
  AP_INVOICE_HEADER→vm181, each one SUCCESS); `host_id` recorded; heartbeats stable IDLE. Fusion
  confirmed to allow concurrent sessions for one account (3 independent sessions seeded).
- **MFA Telegram message now includes the VM name** (`auth.surface_number` adds `host`).
- **Pending:** VM clock sync (chronyd — ~13 min skew observed, cosmetic for timestamps only);
  optional crash-recovery + discover-race live tests (mechanism deployed).

---

## 2026-06-22 — Mid-life session self-heal + fleet re-seed (Track B)

**Incident:** all 3 VMs failed every GL_BALANCES load for ~20h with
`Go-URL did not return CSV (status=200, type=text/html) … Session likely expired`. Root cause:
the Fusion/Entra session expired **mid-life**; the `--forever` worker caches its Playwright
context in `ctx_by_env` and only calls `auth.authenticate()` (which re-validates + re-prompts MFA)
the **first** time it needs an env — so a cached session that dies later is never re-validated and
every load fails until a manual restart. The midnight MFA pushes came from the *discovery* path
(authenticates fresh per scrape); none were approved → stuck.

**Immediate recovery:** re-seeded all 3 (restart → approve MFA: vm182=21, vm180=34, vm181=98).
vm181 needed a **forced** re-seed (`runner/seed_session.py` one-shot `auth.authenticate` after
`rm auth_state_*.json`) because its dead session still passed auth.py's cheap `_validate`
(bieehome loads even when the Go-URL export bounces to login — a false positive).

**Permanent fix (code, deployed to all 3 VMs):**
- `runner/extract.py` — new `SessionExpired(RuntimeError)`, raised by `download_csv` **only** when
  the Go-URL bounces to the login page (HTTP 200 + HTML). A genuinely wrong path (WebLogic 404,
  status≠200) still raises plain `RuntimeError` — so we re-auth only when it can actually help.
- `runner/runner.py` — `_make_run_one_oracledb` logs the failed attempt then **re-raises**
  `SessionExpired`; `_run_worker` catches it, drops the dead context (`ctx_by_env`/`browser_by_env`,
  closes the browser), calls `auth.authenticate()` (→ **one** MFA push) and **retries the job once**
  with the fresh session. MFA-not-approved/re-auth failure is caught → job fails this cycle, worker
  keeps running (next claim re-prompts). `_drive` (direct non-worker path) guards `SessionExpired`
  as a clean failure (no retry) so it can't crash a batch. New `_env_of(job, env_name)` helper.
- **Effect:** a mid-life expiry now self-heals after **one** approval instead of failing silently
  for hours. Deploy = `scp runner.py extract.py` to each VM + `systemctl restart atd-worker`
  (py_compile-checked on each; all came back `active` with no MFA — fresh sessions valid).
- **VERIFIED by simulation (2026-06-22).** `extract.download_csv` has an inert test affordance: if
  the one-shot sentinel `$ATD_STATE_DIR/ATD_TEST_EXPIRE_ONCE` exists it is consumed and raises
  `SessionExpired` (as if the Go-URL bounced to login) — the file never exists in normal operation.
  To simulate: `ssh vm<ip> "touch /root/otbi-atd-state/ATD_TEST_EXPIRE_ONCE"`, then run/enqueue a
  load job. Observed on atd-vm180 (10s, real `_run_worker`):
  `[FAIL] GL_BALANCES: session expired mid-run; re-authenticating` ->
  `GL_BALANCES: SIMULATED session expiry ... -> re-authenticating` ->
  `[ok] GL_BALANCES: 9530 rows`. Re-auth was silent (real session valid -> no MFA); a real expiry
  would prompt one MFA, then retry. (One FAILED + one SUCCESS run row per simulated heal is expected
  test residue; `rm` any sentinel you arm on VMs that didn't claim the job.)
- **Note:** the same latent pattern exists in `_run_action_worker` but is low-impact
  (`FUSION_POST_REIMB` defaults N, actions DRY by default) — left for a follow-up.

---

## 2026-06-24 — Operator-triggered worker re-login ("Refresh") — UI button + Telegram

Re-seeding a worker's Fusion session no longer needs SSH. Two front-ends now set a flag
that the worker acts on:
- **DB (`db/26_atd_worker_refresh.sql`, deployed):** `refresh_req TIMESTAMP` on
  `ATD_WORKER_HEARTBEAT`; **additive** ORDS `POST /atd/workers/:id/refresh` (`:id` = worker_id
  or `all`; SYS_ADMIN) sets it. Additive only (DEFINE_TEMPLATE/HANDLER) — actions + workers-GET
  untouched; run in a fresh session (synonym rule).
- **Worker (`runner.py`, deployed all 3):** the `--forever` idle loop calls `_handle_refresh`
  — if `refresh_req` is set for THIS host, it clears it and **forces a fresh login**
  (`auth.authenticate(force=True)` → one MFA push), dropping the cached session first.
- **UI (App 208, APP_VERSION 1.11.0):** a **Refresh** button per VM in the dashboard Worker
  Fleet table (`atdService.refreshWorker` → the POST). Confirm dialog + toast; i18n EN/AR.
- **Telegram (`tg_bot.py`, vm180 only):** `refresh vm180` / `vm181` / `vm182` / `all` →
  `do_refresh` sets the same flag. Added to `/help`.
- **The MFA tap still happens in Microsoft Authenticator** — these only *trigger* the login and
  surface the number; they cannot replace the approval (only Track A/BIP removes the tap).
- **Verified:** ORDS template registered (actions intact); `refresh_req` column present; all 3
  workers read the column with no error; tgbot restarted clean. Final live tap = operator test.

---

## 2026-06-23 — The GL_BALANCES "session" outage was actually a MOVED REPORT PATH

**Lesson: HTTP 200 + HTML from the Go-URL does NOT always mean the session expired.** After
the 2026-06-22 self-heal work, GL_BALANCES kept failing on all 3 VMs with
`Go-URL did not return CSV (type=text/html) … Session likely expired`. A controlled probe
(reuse a freshly-approved session, dump every job's Go-URL) proved the session was **fine** —
6 of 8 reports returned CSV; only GL_BALANCES + AP_INVOICE_HEADER returned HTML. Dumping the
GL_BALANCES HTML showed the real error: **"Path not found — Check the input path entered.
Error Codes: U9KP7Q94"** — the report had been **moved/renamed** out of its configured path
(`/users/haghareb@dctabudhabi.ae/Drafts/GL/GL Balances`). The runner blindly treated *any*
HTML as expiry, so the self-heal kept re-authenticating (uselessly) and pushing MFA for a
problem re-auth can never fix.

**Fixes:**
- **Path corrected** (by the report owner): `GL_BALANCES.source_ref` →
  `/users/haghareb@dctabudhabi.ae/Data/GL/Budget Status` (verified: Go-URL returns CSV).
- **`extract.download_csv` now classifies HTML by the FINAL url** (deployed to all 3 VMs):
  - still on `/analytics/` → **`ReportError`** (report moved/renamed/deleted or a report
    runtime error) — a clean failure with an honest message; **no re-auth, no MFA**.
  - redirected to sign-in (`login.microsoft*` / `signin` / `/oam`) → **`SessionExpired`**
    (the worker re-authenticates + retries, as designed).
  - non-200 → plain `RuntimeError`.
  The old test sentinel was removed (it routed to an analytics HTML page and so now classifies
  as `ReportError`, which is correct but no longer simulates expiry). Verified live with
  `test_classify.py`: configured path → CSV; bogus path → `ReportError` (NOT `SessionExpired`).
- **Diagnosing this class:** reuse a known-good session and dump the Go-URL — if 200+HTML with a
  final url still on `/analytics/`, read the page text (it carries the OTBI error, e.g. "Path not
  found"); the report/path is wrong, not the session. (`probe_dump.py` did exactly this.)
- **Telegram relay is flaky** (`[notify] telegram send failed: handshake timed out`) and the
  MFA number capture sometimes yields `"see login screen"` (no digit). Both make manual re-seeds
  unreliable — another reason to pursue Track A (BIP, MFA-free).

---

## Telegram query bot (tg_bot.py) — PoC, vm180 only

A lightweight long-polling bot that answers i-Finance lookups in Telegram.
**getUpdates is single-consumer — run on vm180 only** (one service, no lock needed).

### What it does (PoC scope)
| Command | Behaviour |
|---|---|
| `/help` | List commands + "coming soon" services |
| `/vendor <number>` | Exact supplier lookup by number (name, status, currency) |
| `/vendor <text>` | Case-insensitive fuzzy name search, top 5 results |
| (others) | Stub "coming soon" reply (payments, pettycash, freelancer) |

Bank-sensitive columns (`iban`, `bank_account_number`, `bank_name`, `bank_branch_name`,
`account_name`) are never returned by any command — hardcoded whitelist in `tg_bot.py`.

Unrecognised Telegram chat IDs are silently ignored (no reply revealing the bot exists).

### Files
- `runner/tg_bot.py` — poll loop + command dispatch + DB lookups (imports `config`, `notify`)
- `runner/systemd/atd-tgbot.service` — systemd unit (clone of atd-worker.service)

### env.sh additions (vm180 only)
Add these two lines to `/root/otbi-atd/env.sh` on vm180 **after** the existing `ATD_TG_CHAT` line:
```bash
export ATD_TGBOT_ALLOW="${ATD_TG_CHAT}"   # comma-separated; seed = operator chat id
export ATD_TGBOT_ENABLED=1                # set to 0 to pause without stopping the unit
```
If you want to allow additional chat IDs later: `ATD_TGBOT_ALLOW="111111111,222222222"`.

### Deploy (one-time, vm180 only)
```bash
# 1. Copy the bot script and service unit to vm180
scp -i /c/tmp/atd-provision/keys/atd_id_ed25519 \
    otbi-atd/runner/tg_bot.py \
    root@192.168.1.180:/root/otbi-atd/runner/

scp -i /c/tmp/atd-provision/keys/atd_id_ed25519 \
    otbi-atd/runner/systemd/atd-tgbot.service \
    root@192.168.1.180:/etc/systemd/system/

# 2. SSH into vm180 and add the env vars
ssh -i /c/tmp/atd-provision/keys/atd_id_ed25519 root@192.168.1.180

  # --- on vm180 ---
  # Append the two env vars after ATD_TG_CHAT in /root/otbi-atd/env.sh:
  #   export ATD_TGBOT_ALLOW="${ATD_TG_CHAT}"
  #   export ATD_TGBOT_ENABLED=1

  # 3. Enable and start the service
  systemctl daemon-reload
  systemctl enable atd-tgbot
  systemctl start  atd-tgbot
  systemctl status atd-tgbot    # should show "active (running)"

  # 4. Follow logs
  journalctl -u atd-tgbot -f
```

### Redeployment (after tg_bot.py changes)
```bash
scp -i /c/tmp/atd-provision/keys/atd_id_ed25519 \
    otbi-atd/runner/tg_bot.py \
    root@192.168.1.180:/root/otbi-atd/runner/

ssh -i /c/tmp/atd-provision/keys/atd_id_ed25519 root@192.168.1.180 \
    systemctl restart atd-tgbot
```

### State file
The last processed `update_id` is persisted to `/root/otbi-atd/tgbot_offset.txt` so a
`systemctl restart` does not replay already-handled messages.

### Test plan
1. **Allowed chat → `/help`** — should list commands and "coming soon" services.
2. **Allowed chat → `/vendor <known number>`** — should reply with name (status, currency).
3. **Allowed chat → `/vendor acme`** (or any partial name) — should reply with up to 5 matches.
4. **Non-allowed chat** — send any message → no reply at all (check `journalctl -u atd-tgbot`
   for `"ignored chat_id=..."` log line).
5. **Bank field check** — search for a supplier known to have IBAN data; confirm the reply
   contains NO `IBAN`, `Bank`, or `Account Name` fields.
6. **Restart resilience** — `systemctl restart atd-tgbot`; send a message; should reply
   correctly with no duplicate responses.
