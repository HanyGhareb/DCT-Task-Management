# otbi-atd — Deployment & Runbook

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
