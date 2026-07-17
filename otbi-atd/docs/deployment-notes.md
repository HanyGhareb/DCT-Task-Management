# otbi-atd — Deployment & Runbook

## 2026-07-16 — PR/PO Pending Approval extract: FIRST BIP (.xdo/xmlpserver) job (db/47 + runner bip.py)

New daily snapshot of every PR + PO in **PENDING APPROVAL** status, from the BI Publisher report
`ADG Document Status Report` (NOT an OTBI analysis — this introduced first-class **BIP report
support** in the Track B runner).

- **Target:** `PROD.ATD_PR_PO_PENDING_APPROVAL` (8 report columns + `load_ts`), full refresh
  (`TRUNCATE_INSERT`) — the table always holds the CURRENT pending list; approved/rejected
  documents drop out on the next run.
- **Job:** `PR PO Pending Approval` (env `FUSION_ADGOV`, `output_format='xlsx'`,
  `source_ref='/Custom/ADGE Procurement Reports/Purchasing/ADG Document Status Report.xdo'`).
  Params in `params_json`: `_xt` (template), `_paramsP_BU=*`, `_paramsP_DOCTYPE=["REQUISITION","STANDARD"]`
  (a JSON ARRAY repeats the URL key — BIP multi-select), `_paramsP_STATUS=PENDING APPROVAL`, and the
  runner directive `_atd_require="Document Number"` (rows without a Document Number are excluded;
  banner/blank rows always are). Column map keeps ONLY the 8 wanted report columns.
- **Schedule:** job set `PRPO_PENDING` — daily window **06:30–08:30 Asia/Dubai**, freq 1440
  (+ job `frequency_minutes=1440`); category tag `PO`. NOTE the fleet **break window ends 08:00**,
  so in practice the run lands 08:00–08:30. History = the normal `ATD_LOAD_RUN_LOG` / Run Logs page.
- **DB deploy:** `db/47_atd_pr_po_pending.sql` — **MERGE-bearing → deployed via python-oracledb on
  vm180** (Linux SQLcl swallows MERGE blocks), verified: table + job + set + member + category all in.
- **Runner (`bip.py` NEW + `extract.py`/`runner.py`/`config.py` touched, `openpyxl` added):**
  a `source_ref` ending `.xdo` routes to `bip.download_csv`: fetch
  `{xmlpserver}/<path>.xdo?_xpt=1&_xf=xlsx&_xautorun=true&_paramsP_*=…` via the warm session
  cookies (**`_xpt=1` returns the document itself — no viewer, no 'Apply' click**), convert
  XLSX→CSV (openpyxl; header row auto-detected below BIP's title/banner rows; headers matched
  case-insensitively but emitted under the column-map's own key text so `resolve_pairs` hits),
  then the UNCHANGED prepare/load pipeline runs. Job selects now also fetch
  `output_format`/`xmlpserver_base_url`. Unit tests `runner/tests/test_bip.py` (7/7).
- **Why the converter projects mapped columns only:** prepare's drift engine ADDs any unmapped
  CSV column to the table — emitting only the mapped headers is what enforces "extract only these
  columns" AND keeps drift quiet if the report gains columns.
- **SSO gotcha (protects every future .xdo job):** the FIRST xmlpserver touch of a session can
  bounce to sign-in even with live cookies — the IDCS/Entra hop needs a JS auto-post that
  `ctx.request` can't run. `bip.download_bytes` primes once via a real `page.goto(xmlpserver)/`
  then retries before raising SessionExpired (which still triggers the worker's normal
  re-auth+retry). Error triage mirrors the Go-URL: HTML while still on /xmlpserver = ReportError
  (bad path/params — re-auth won't help); bounced off = SessionExpired.
- **Fleet rollout:** bip/extract/runner/config/requirements + `pip install openpyxl` synced to
  vm180/181/182, `systemctl restart atd-worker` — all three active clean.
- **FIRST LIVE RUN — SUCCESS (2026-07-16 ~02:20 Dubai, 1,060 rows = 916 REQUISITION + 144
  STANDARD; zero null/duplicate Document Numbers).** One finding: the BIP template exports
  `Submitted for Approval Date` as **text `DD-MM-YYYY`** (`14-07-2026`), which the loader's
  date formats didn't know → run 1 warned (drift: "column is DATE … load may fail") and loaded
  the dates NULL. The user resolved it live by altering the column to **VARCHAR2(20)** (kept as
  verbatim text — user decision; db/47 updated to match) and re-running clean. The runner ALSO
  gained the day-first `%d-%m-%Y` format (load.DATE_FORMATS + prepare.DATE_RE), so a FUTURE BIP
  job with such dates auto-types/parses to real DATE from run 1. NOTE: the legacy SQLcl loadsql
  path still emits only ISO TO_DATE — fleet is oracledb, so not extended.

## 2026-07-01 — Run Logs: Job Set column + filter (App 208, APP_VERSION 1.19.0)

Make the global **Run Logs** page set-aware so operators can see which Job Set a run's job
belongs to and filter the log by set (the per-set Run History on the Job Set Detail page still
exists; this adds visibility from the main log). Additive & backward-compatible.

- **ORDS — `db/42_atd_runs_set_ords.sql` (new, ADDITIVE — no DELETE_MODULE):** REDEFINES the
  `GET /runs` + `GET /runs/export` handlers to `LEFT JOIN atd_job_set_member → atd_job_set`
  (a job is in ≤1 set → PK `job_name`, so no row fan-out), adding `setCode`/`setName` to each
  run row + a `jobSet` CSV column, and accepting a `?setcode=` filter. Times stay `dct_to_local`.
- **Deploy:** run `db/42` in a **FRESH SQLcl session** (synonym rule). It upserts only those two
  handlers — job-sets/actions/etc. untouched. **NOTE:** because `13_atd_ords.sql` DELETE_MODULEs
  and rebuilds `atd.rest` with the plain (no-set) `/runs` handlers, **always re-run `42` after `13`**
  (same rule as `20_atd_action_ords.sql` for Actions). Header note added to `13`.
- **Frontend (`final apps/ATD/Jet/`, APP_VERSION 1.19.0):** `runs.html` gains a **Job Set** column
  (region-themed `.badge`, `—` when the job is in no set) + a **Job Set** filter `<select>` in the
  toolbar; `runs.js` loads the set list via `listJobSets()`, passes `setcode`, and persists the
  filter (filterStore). `atd.col.jobSet` / `atd.runs.allSets` added to EN + AR i18n.
- **Verification:** deployed VALID (both handlers registered). Playwright E2E **9/9 PASS** against
  the live `FULL_DATA` set — column header, per-row set badges, populated filter dropdown, filter
  returns only that set's rows (20/20 tagged), AR/RTL header, and `GET /runs?setcode=` API
  (100 rows all tagged & members). Non-destructive (no data created/deleted).
- **Gotcha:** SPA route switching in tests — `page.goto('/index.html#runs')` does NOT reload the
  app (hash-only change), so the route never switches; use `page.evaluate("window._jetApp.navigate('runs')")`
  (or click the nav link) instead.

## 2026-07-01 — Manage Job Sets: grouped scheduling (App 208, APP_VERSION 1.18.0)

Group jobs under **one shared schedule** so the operator can schedule / pause / run a *batch*
together instead of editing every job's frequency + enabled flag one by one. Fully additive and
**backward-compatible** — a job in no set behaves exactly as before.

- **What it does.** A **Job Set** = a run interval + an active window (Start/End dates, optional
  daily HH:MI mask + day-of-week mask, all **local Asia/Dubai**) + per-member enable/disable +
  notify-on-failure. It drives the LIVE browser track: the 15-min `enqueue` (db/12) only marks a
  member `READY` while its set says "go now" (`atd_set_gate_ok`) and re-runs it on the set's
  interval (`atd_set_eff_freq`). Plus **Run Set Now**, **Pause/Resume**, **≈ next-run** preview per
  member, **set-scoped run history**, and **failure notifications** (DCT_NOTIFY → SYS_ADMINs).
- **DB — `db/40_atd_job_set.sql` (new):** `ATD_JOB_SET` + `ATD_JOB_SET_MEMBER` (**PK `(job_name)`**
  enforces *one set per job*), SQL-callable `atd_set_gate_ok` / `atd_set_eff_freq` / `atd_set_next_run`,
  `ATD_SET_PKG` (`run_now` + `notify_sweep`), `ATD_SET_NOTIFY_JOB` (5-min sweep), config
  `ATD_SET_NOTIFY_ENABLED` (Y/N, default **N**) + `ATD_SET_NOTIFY_WATERMARK`, ADMIN synonyms.
- **DB — `db/12_atd_job_queue.sql` (2-token enqueue edit):** on the scheduled bulk path only,
  `AND (p_only IS NOT NULL OR prod.atd_set_gate_ok(j.job_name)='Y')` + the frequency NVL now wraps
  `prod.atd_set_eff_freq(j.job_name, j.frequency_minutes)`. Manual single-job enqueue (`p_only`)
  bypasses the gate (operator override, like the break window).
- **ORDS — `db/41_atd_job_set_ords.sql` (new, ADDITIVE — no DELETE_MODULE):** 11 handlers on
  `atd.rest` — `/job-sets` (GET/POST), `/job-sets/:code` (GET/PUT/DELETE), `/job-sets/:code/members`
  (POST), `/job-sets/:code/members/:job` (PUT/DELETE), `/job-sets/:code/run` (POST),
  `/job-sets/:code/pause` (PUT), `/job-set-jobs` (GET candidate picker). SYS_ADMIN-gated.
- **Deploy order (idempotent):** run **`40` first**, then **re-run `12`** (picks up the enqueue edit;
  db/12 references the db/40 wrappers, so 12 is INVALID until 40 runs — auto-revalidates), then
  **`41` in a FRESH SQLcl session** (synonyms). Verify all objects VALID + `ATD_SET_NOTIFY_JOB`
  scheduled. **No runner change** (the queue pkg isn't ORDS; the runner drains READY as always).
- **Gotchas hit & fixed:**
  - **PLS-00231 (`function 'PTS' may not be used in SQL`)** — the create/update handlers first used
    a nested `pts()` function inside the INSERT/UPDATE; a locally-declared PL/SQL function can't be
    called from SQL DML (→ ORDS returned **HTTP 555**, a fresh-compile failure of the stored block, NOT
    a caught runtime 500). Fixed by inlining the parse as a pure SQL expression
    `TO_TIMESTAMP(REPLACE(SUBSTR(APEX_JSON.get_varchar2(...),1,16),'T',' '),'YYYY-MM-DD HH24:MI')`.
  - **ORA-12860 on `DELETE FROM atd_job_set` in SQLcl** (auto parallel-DML sibling-lock via the
    ON DELETE CASCADE chain) — a SQLcl-session artifact only; the ORDS DELETE handler runs serially
    (like the existing `/jobs/:name` cascade delete) and is fine. For manual cleanup:
    `ALTER SESSION DISABLE PARALLEL DML;` first.
  - Re-running `db/12` ends with `UPDATE atd_otbi_jobs SET run_status='READY' WHERE enabled='Y'`
    (its documented reset) — deploy during a quiet window / worker idle.
- **Frontend (`final apps/ATD/Jet/`, APP_VERSION 1.18.0):** new nav item **Job Sets** (Operations),
  `jobSets` list + `jobSetDetail` pages (shared `<edit-drawer>` create/edit with interval presets +
  day chips + datetime/time windows; `.data-table` member manager with per-row enable toggle + order
  + ≈ next-run; set-scoped run history; Run/Pause/Delete). `atdService` set methods; EN+AR i18n
  (`atd.set.*`/`atd.nav.jobSets`/`atd.day.*`); no bespoke CSS (platform classes only).
- **Full E2E — Playwright, SYS_ADMIN, 11/11 PASS (self-cleaned):** login → create set (DAILY) →
  add member → toggle in-set → **Run Set Now** (worker actually ran AP Distributions Full, 23,555
  rows SUCCESS, appeared in set-scoped history) → Pause → Edit drawer → Arabic RTL → Delete. Every
  ORDS call returned 200. PL/SQL smoke separately verified the gate (in-window Y, paused/out-of-window/
  disabled N), eff_freq (set-over-job), and run_now.

## 2026-06-29 — MERGE load mode: staging-clear fix + GRN incremental-upsert runbook

### Runner fix (`runner/load.py`) — REQUIRED before any MERGE job is used
The oracledb loader only cleared the staging table for `TRUNCATE_INSERT`; in `MERGE` mode it
re-inserted each extract on top of the previous run's rows. On the **2nd run** a re-extracted key
then appeared twice in the merge source → `ORA-30926 "unable to get a stable set of rows in the
source tables"`, and the staging table grew unbounded. Fix: the staging `DELETE` is now
**unconditional** (both modes) so staging always holds *only* the current extract; behaviour for
`TRUNCATE_INSERT` is unchanged (stage IS the destination → atomic replace). Also added a guard that
raises a clear error if a MERGE job is misconfigured with `stage_table == final_table`.
**Deploy:** copy `runner/load.py` to all worker VMs + `systemctl restart atd-worker`. (SQLcl-mode
`loadsql.py` still rejects MERGE with `NotImplementedError` — prod runs oracledb, so MERGE works.)

### How MERGE mode works (for the Edit Job form)
A MERGE job uses **two** tables. **Target Table** (`stage_table`) is the scratch landing zone the
fresh OTBI extract loads into each run; **Final Table (MERGE)** (`final_table`) is the persistent
base table you query. After staging loads, the runner runs
`MERGE INTO final USING stage ON (key_columns)` — updating matched rows, inserting new ones. Stage
and final **must be different tables**, and **`key_columns` must be UNIQUE per row in a single
extract** or the merge fails with ORA-30926. Neither table needs pre-creating — `prepare.py` builds
both from the live CSV on first run (and ALTERs both on schema drift).

### GRN incremental conversion (GRN Updates 10Min → MERGE) — PENDING a unique key
There are 3 GRN jobs sharing staging `PROD.ATD_GRN`: **GRN Full** (`GRN_ALL_F`, daily, real map),
**GRN Hourly** (`GRN_ALL_UH`, 60 min), **GRN Updates 10Min** (`GRN_ALL_U10M`, 10 min, currently
disabled). The plan: keep **staging = `ATD_GRN`**, MERGE into **base = `GRN`**.

**Blocker:** the GRN extract is accounting-line-level and has **no unique key** — `TRANSACTION_ID`
yields only 2,802 distinct of 6,943 rows (up to 5 lines/txn: Dr/Cr signs, multiple CC_IDs); even a
5-column composite (`TXN+CC+SIGN+GL_BATCH+LEDGER_AMOUNT`) still leaves 16 collisions. MERGE needs a
truly unique key. **Decision (2026-06-29): add a true accounting-line unique id to the OTBI
analysis** (e.g. the receipt-accounting distribution id, or XLA `AE_HEADER_ID`+`AE_LINE_NUM` / GL
link id). Add it to `GRN_ALL_U10M` (ideally all three, so the shared `ATD_GRN`/`GRN` carry it
consistently); the runner auto-adds the new column on the next run via schema-drift handling.

**Once the analysis emits the unique id column (call it `<KEY_COL>`):**
1. (One-time) Seed/own the base table `GRN`. Options: make **GRN Full** also write the base — either
   MERGE Full into `GRN` on `<KEY_COL>` (daily full upsert) or TRUNCATE_INSERT Full directly into
   `GRN` (daily full rebuild) — or seed `GRN` once from `ATD_GRN` then let increments maintain it.
2. Drop the stray junk column once no job's column map references it:
   `ALTER TABLE prod.atd_grn DROP COLUMN the_query_resulted_in_no_r;`
3. Reconfigure GRN Updates 10Min:
   ```sql
   UPDATE prod.atd_otbi_jobs
      SET load_mode='MERGE', stage_table='PROD.ATD_GRN', final_table='PROD.GRN',
          key_columns='<KEY_COL>', column_map_json=NULL, updated_at=SYSTIMESTAMP
    WHERE job_name='GRN Updates 10Min';
   COMMIT;
   ```
   (Set `column_map_json=NULL` only if the analysis structure changed, to force a clean re-profile.)
4. Verify: enable + run it **twice**. Both SUCCESS; staging row count = latest extract (not growing);
   `GRN` reflects upserts (changed rows updated in place, only new keys add rows). Confirm
   `SELECT <KEY_COL>, COUNT(*) FROM prod.grn GROUP BY <KEY_COL> HAVING COUNT(*)>1` returns nothing.

## 2026-06-27 — Fusion session auto-heal: keep-alive + cross-worker failover (App 208, APP_VERSION 1.15.3)

The recurring "session expired mid-run" failure (Fusion SSO/MFA session dies between sparse
jobs or at its absolute lifetime) is now largely self-healing — two layers on top of the
existing once-daily relogin + aging nudge:

- **Tier 1 — keep-alive (prevention).** An idle `--forever` worker pings its warm Fusion
  session every `ATD_SESSION_KEEPALIVE_MIN` min (**default 3** — comfortably under any OBIEE
  idle timeout) via the cheap `auth._validate` GET, which resets OBIEE's idle timer (no MFA).
  A live session never idle-expires between jobs. A ping that fails for `ATD_KEEPALIVE_STRIKES`
  **consecutive** tries (default 2 — a 2-strike guard so a transient network blip doesn't trigger
  a needless MFA) marks the session dead → pauses claiming + self-heals via a **rate-limited
  forced re-login** (one MFA, gated by `ATD_REAUTH_COOLDOWN`).
- **Tier 2 — cross-worker failover (resilience).** A mid-run session bounce is logged
  **`REQUEUED`** (neutral, not `FAILED` → no chronic-fail alert) and the job is **released back
  to the queue** (`atd_queue_pkg.release_job`) for a peer with a healthy session — instead of
  being consumed as FAILED. The bouncing worker pauses claiming until it re-auths. Budget
  `ATD_REQUEUE_MAX` (default 6) cross-worker bounces/60 min, then the job is marked FAILED so a
  genuinely stuck job still surfaces.
- **Unavoidable:** the *first* recovery after every session death still needs **one Telegram MFA
  approval** (SSO is MFA-gated) — but only one, and keep-alive then holds the session open.
- **DB:** `db/12` (+ `release_job` in `atd_queue_pkg`, recompiled VALID — additive, backward-
  compatible with the old runner) + `db/35` (MERGE-seed `ATD_SESSION_KEEPALIVE_MIN` +
  `ATD_REQUEUE_MAX`, UI-editable on Runner Settings; also added to `db/14` for fresh installs).
  No ORDS rebuild needed (queue pkg isn't ORDS).
- **Runner — DEPLOYED to all 3 VMs 2026-06-27:** `runner.py` only (keep-alive block, `_relogin`
  + `_recent_requeues` helpers, session-bounce → REQUEUED/release, claim gating on a dead
  session). scp + `systemctl restart atd-worker`; all `active`, `[config] applied 25 runner
  settings` (was 23 → the 2 new keys load).
- **Frontend:** neutral `REQUEUED` status pill (`app.css` `.rstat--REQUEUED`, ↻) + REQUEUED/HELD
  added to the Run Logs status filter. APP_VERSION 1.15.3.

### 2026-06-28 — job sub-categories + remembered filters with Search/Clear (APP_VERSION 1.16.0)
- **Sub-categories (hierarchical categories):** `db/36` adds `ATD_JOB_CATEGORY.parent_code`
  (self-FK + "not its own parent" CHECK + index). A category with `parent_code = NULL` is top-level
  (Purchasing); one with a parent is a SUB-category (PO/PR/REC). `db/32` `/categories` GET/POST/PUT
  now carry `parentCode`/`parentName`; DELETE also blocks a parent that still has children. `db/13`
  `/jobs` category filter now **includes children** (selecting a parent matches jobs tagged to it OR
  any of its sub-categories). **Redeploy chain: `36 → 13 → 20 → 26 → 31 → 32 → 33`** (13 rebuilds the
  module). Existing 6 categories stay top-level; create sub-categories in **Manage Categories** (new
  **Parent** dropdown + column). Jobs/Queue filter bars gain a **Sub-category** dropdown that appears
  once the chosen category has children.
- **Remembered filters + Search/Clear (UX):** new `js/util/filterStore.js` persists each page's filter
  criteria in `localStorage` (key `atd.filters.<page>`) and restores them on load — fixing "criteria
  reset on browser refresh". Added a **Search** button (apply/refresh) + **Clear** button (reset all)
  to **Jobs**, **Run Logs**, and **Queue** (Queue also gained search + status + category filters it
  didn't have). Filters still apply live as you change them; the buttons are explicit apply/reset.
- **Frontend only for the UX part** (jobs/runs/queue VMs+views, filterStore, i18n `atd.cat.allSub`/
  `atd.cat.parent`/`atd.cat.parentNone`/`atd.filter.search`/`atd.filter.clear`, EN+AR). APP_VERSION 1.16.0.

### 2026-06-28 — schema-editor remove-column + download timeout + cookie scrubbing (APP_VERSION 1.15.6)
- **Schema editor "remove column" (✕):** each row in the Table Schema editor now has a ✕ that drops
  the column from the list (`jobDetail.removeCol`); it's removed from the table only on **Apply**
  (recreate from the remaining cols; Reload restores). For leftover columns the analysis no longer
  returns (the runner keeps dropped columns loading NULL — never auto-drops). Frontend only.
- **(b) CSV download timeout configurable (`extract.py`):** the hard-coded 180 s Go-URL download
  timeout is now `ATD_DOWNLOAD_TIMEOUT_SEC` (default **300**, Runner Settings editable) — raise it for
  large/slow reports (was the cause of the AP Invoice Lines "Timeout 180000ms exceeded" FAILED).
- **(c) secret scrubbing (`checks.scrub`):** a failed Go-URL download's Playwright error dumps the
  full request incl. the `cookie:` header (live JSESSIONID / ORA_OCIS_CG_SESSION / _WL_AUTHCOOKIE —
  replayable). All run-log writers now scrub cookie/auth/Bearer values to `[redacted]` before storing
  (`runner._log_end` + `_log_orphan`, `loadsql.log_failure` + `log_held`). Verified on the real leaked
  message — tokens gone, useful text kept.
- **DB:** `db/35` MERGE + `db/14` add `ATD_DOWNLOAD_TIMEOUT_SEC`. **Runner — all 3 VMs 2026-06-28:**
  `checks.py`/`extract.py`/`runner.py`/`loadsql.py` + restart (`applied 27 runner settings`).

### 2026-06-27 follow-up — pre-run auth gap + Queue wording (APP_VERSION 1.15.4)
- **Bug closed (`runner.py`, all 3 VMs):** the Tier 2 failover only covered a session death
  *inside* a run. A login failure **before** the run (opening the session for a claimed job — MFA
  timeout, or a session dead at its absolute lifetime) escaped the loop, **crashed the worker, and
  left the job orphaned in `CLAIMED`** with no run-log row until the 30-min reap (hit live: GL_ACCOUNTS_
  COMBINATIONS, claimed by vm182 09:24, no run row; auto-recovered at the reap → vm181 ran it SUCCESS
  9 338 rows 09:55). Now the pre-run `auth.authenticate()` is wrapped: on failure it marks the host
  session dead, writes a visible `REQUEUED` (or `FAILED` past `ATD_REQUEUE_MAX`) run-log row via the
  new `_log_orphan`, and **releases the job to a healthy peer** (`release_job`) instead of crashing.
- **UI wording:** Queue page **"Reap Stale" → "Recover Stuck"** + the lease box **"Lease (min)" →
  "Stuck after (min)"**, both with explanatory tooltips (`atd.queue.reap.hint` / `atd.queue.lease.hint`,
  EN+AR). No behaviour change — clearer label for returning stuck `CLAIMED` jobs to the queue.

## 2026-06-27 — Unlabelled-OTBI-column fix + editable source header (App 208, APP_VERSION 1.15.1)

OTBI sometimes exports a column with **no heading**. The column map was keyed by header, so
every blank header collapsed onto one `''` key — all but the last vanished from the map (→ blank
"Source header" in the schema editor, re-added as drift every run) and the unlabelled columns
**did not load their data** (the loaders matched map-key → CSV header, and `''` matched at most one).

- **Fix (runner):** unlabelled columns now key by a **positional sentinel** `#__blankcol_<1-based CSV pos>__`
  — distinct per column and stable across runs (survives renames). New `prepare.map_key` /
  `is_blank_key` / `blank_key_pos` / **`resolve_pairs`** (shared); `column_map`, `_plan_drift`,
  `_drift_warnings` use it. Both loaders (`load.py` `_parse_csv`, `loadsql.py` `_parse`) switched to a
  **positional CSV reader** so blank-header columns load by position. Real-header jobs are byte-for-byte
  unaffected (no blank keys → new branch never fires). Verified locally: 2-blank-header CSV → all cols
  distinct, load positionally, re-run drift is a no-op (no re-add loop), rename survives re-runs.
- **Fix (ORDS apply handler, `db/13` POST `/jobs/:name/schema`):** **no longer drops** a column whose
  source header is blank — stores it under the positional sentinel (was `IF l_hdr IS NOT NULL` → skip).
- **Editable source header (frontend):** the schema editor's "Source header" is now an editable input
  (placeholder *"(unnamed in OTBI — type a header)"*); sentinel keys render blank; a typed header is
  saved into the map on Apply. `jobDetail.js` (`isBlankKey`, `header` → observable), `jobDetail.html`,
  EN/AR `atd.schema.unnamedHdr`.
- **DB redeploy (one fresh SQLcl session):** `13 → 20 → 26 → 31 → 32 → 33` (13 `DELETE_MODULE`s
  `atd.rest`, so additive scripts follow; 33 last re-adds approve-schema). All `PL/SQL procedure
  successfully completed`, no ORA-/PLS-.
- **Runner — DEPLOYED to all 3 VMs 2026-06-27:** `prepare.py`, `load.py`, `loadsql.py` scp'd to
  `/root/otbi-atd/runner/` on atd-vm180 (canary, verified clean startup) then 181/182; `ast.parse`
  syntax-check + `systemctl restart atd-worker` (all `active`, `[config] applied … settings`, clean).
- **Note for users:** to get a heading shown (and to make a column self-describing), set a *Custom
  Heading* on the column in the OTBI analysis; otherwise type one in the schema editor. Either way the
  data now loads.

## 2026-06-26 — Existing-target-table fix + schema-review gate (App 208, APP_VERSION 1.14.0)

Two linked changes to job create/update.
- **Bug fixed — entering an already-existing target table "went wrong":** on first run the runner
  reused the existing table but derived the column map *from the CSV* as if it were fresh, so a
  shared/peer table (the 10-min / hourly / daily jobs on one analysis) or a customised table could
  fail to load. `prepare.ensure_prepared_oracledb` now **reconciles to the existing table**
  (`_reconcile_existing`: ADD genuinely-new columns, widen outgrown text) instead of assuming a new
  one. Shared target tables are **intentional and allowed** — no blocking.
- **Schema-review gate (`db/33`):** `ATD_OTBI_JOBS.schema_reviewed CHAR(1) DEFAULT 'Y'`. A
  **"Hold for schema review"** checkbox on the form, and **auto-hold when the target table already
  exists**, set it to `'N'`. The worker then **prepares** the table+map but **HOLDS before loading**
  (run-log status `HELD`) until approved via **`POST /jobs/:name/approve-schema`** (job-detail
  "Approve schema"). `db/12 enqueue` skips a held job once it is prepared (no repeated HELD); resumes
  on approval. Existing jobs default `'Y'` → no behaviour change.
- **DB:** `db/33` (column + approve endpoint, additive) + `db/12` (enqueue guard) + `db/13`
  (create/PUT `holdForReview` + table-exists auto-hold, GET returns `schemaReviewed`). Redeploy ran
  **`33 → 12 → 13 → 20 → 26 → 31 → 32 → 33`** (33 last to re-add the endpoint after the 13 rebuild).
- **Runner — DEPLOYED to all 3 VMs 2026-06-26:** `prepare.py` (reconcile), `runner.py` (HELD gate,
  both paths), `config.py` (selects `schema_reviewed`), `loadsql.py` (`log_held`). scp'd to
  `/root/otbi-atd/runner/` on atd-vm180/181/182 + `systemctl restart atd-worker` (all `active`,
  clean startup, no SQL errors). No MFA needed at restart — all jobs were disabled so the workers
  stayed idle; each re-auths (one MFA) on its next real job claim.
- **Frontend:** hold checkbox + "Review" badge (jobs), approve button + notice (jobDetail),
  `atdService.approveSchema`, EN/AR i18n, `app.css` `.review-*`.


## 2026-06-26 — Job Categories (ATD App 208, APP_VERSION 1.13.0)

Tag jobs with any number of **categories** (ATD-native lookup) to simplify job management.
- **DB (`db/32_atd_job_category.sql`, additive):** `ATD_JOB_CATEGORY` (code, EN/AR name, color,
  order, active) + `ATD_JOB_CATEGORY_MAP` (`(job_name,category_code)` PK — no per-job cap; FK
  `job_name` ON DELETE CASCADE). Seeds 6 starters (AP/GL/PO/SUPPLIER/MASTER/FINANCE). **No max-3
  cap** (the PK alone prevents duplicate tags). Additive ORDS: `GET/POST /atd/categories`,
  `PUT/DELETE /atd/categories/:code` (DELETE blocked while in use → deactivate).
  **Deploy with `-Dfile.encoding=UTF-8`** for the Arabic seed (verified bytes ≈ 2× chars, no
  mojibake).
- **`db/13` (jobs handlers, triggers a rebuild):** list returns `categories[]` per job +
  **`?category=CODE` filter**; `GET /jobs/:name` returns `categories[]`; `POST`/`PUT` accept
  `categories:[codes]` (PUT = replace-set). **Redeploy ran `13 → 20 → 26 → 31 → 32`** (32 is
  additive and must follow any 13 rebuild — the chain is now five scripts). Verified all 12 handlers
  registered; tag round-trip + filter + PK-dup-block + delete-in-use guard all pass.
- **Frontend:** Jobs list Category column + filter + **Manage Categories** right-edge **drawer**
  (shared `.ed-*` chrome, New/Close/Save in the header — APP_VERSION **1.13.1**); drawer category
  picker on the job form (toggle chips, no cap); jobDetail chips. Colored EN/AR chips. `atdService`
  category CRUD; `app.css` `.cat-chip*`/`.cat-swatch`; EN/AR i18n.
- **Live browser smoke test PASSED 11/11** (Playwright, SYS_ADMIN): create/edit/delete category,
  tag/untag a job, list Category column + chips, category filter, drawer header actions, Arabic RTL
  in the drawer — all verified end-to-end (UI→ORDS→DB), test self-cleaned (no prod residue).

## 2026-06-26 — Unqualified stage table → ORA-00942 (blank source headers)

- **Symptom:** a new job (AP_INVOICES_F) showed every SOURCE HEADER blank on the schema-review
  page. Root cause: the user typed the stage table as `ATD_AP_INVOICES` (no schema prefix) in the
  create form, and it was stored verbatim. The runner connects as **ADMIN**, so the bare name
  resolved to `ADMIN.ATD_AP_INVOICES` → every run failed `ORA-00942` in prepare/reconcile →
  `column_map_json` never persisted → no headers. (Minimal-create jobs auto-get `PROD.`; only a
  user-typed bare name hit this.)
- **Fixes:**
  - Data: `UPDATE atd_otbi_jobs SET stage_table='PROD.ATD_AP_INVOICES'` for the affected job, and
    reset it to READY (audited all jobs — no other unqualified stage/final names).
  - Runner (`prepare.py`, deployed to all 3 VMs + restart): new `qualify(table)` defaults any
    UNqualified staging/final table name to `PROD.<name>` in both prepare paths (create + drift,
    oracledb + sqlcl); the qualified name is persisted back, so the stored value self-heals on the
    first prepare. Compile-verified on each VM; all `active`.
  - Frontend (committed): the job-detail review banner now distinguishes prepared vs not — a held
    job with an empty map reads "Not prepared yet …" instead of falsely claiming "prepared".
- **Note:** the stale-RUNNING reaper (`_reap_stale_runs`) was already deployed on all 3 VMs and is
  working; run 1456 ended on the real ORA-00942, not as a reaped orphan (correct behaviour).

## 2026-06-26 — Dashboard scoped to real job loads

- **Recent Runs / Alerts / 24h KPIs showed phantom rows for deleted jobs (db/13, redeployed).**
  These dashboard panels read `atd_load_run_log` with no track filter, so after the orphan sweep
  the 69 leftover **DISCOVER** rows (subject-area names, not jobs) surfaced as fake "jobs". Scoped
  the dashboard handler: `runs24h`/`success24h`/`lastFinished` now count only `track IN
  ('API','BROWSER')`; the **recent** + **alerts** cursors additionally require the job to still
  exist (`EXISTS atd_otbi_jobs`). Verified live with 0 jobs: jobs/runs24h/recent/alerts all 0,
  successRate `—`. Full 13-chain re-run (13→20→26→31→32→33); regression-checked jobs/health,
  actions/stats, categories, workers all 200.

## 2026-06-26 — Job→log cascade + dev-proxy no-cache

- **Orphaned run-logs (db/34, DEPLOYED):** run-log rows had no link to their job, so deleting a
  job left its load history behind. New row trigger `prod.trg_atd_job_log_cascade`
  (AFTER DELETE on `atd_otbi_jobs`) clears that job's load rows (track API/BROWSER) on any delete
  path (ORDS/SQLcl). DISCOVER rows are keyed by subject area, not a job, so they are preserved.
  One-time sweep removed **1369** already-orphaned load rows (verified: 0 load-orphans left,
  69 DISCOVER rows kept, trigger ENABLED). No FK added (a hard FK would break DISCOVER inserts).
  Independent of the 13-chain (no ORDS).
- **Blank-page-after-deploy fix (dev-proxy.py, all 9 apps):** the dev-proxy served static assets
  with **no `Cache-Control`**, so the browser cached `index.html`; after rapid APP_VERSION bumps a
  stale `index.html` kept re-requesting old-versioned (cached) JS → blank page. Added an
  `end_headers` override emitting `Cache-Control: no-store, must-revalidate` for non-`/ords/`
  responses. Verified header now served. (One-time remedy for an already-stale browser: hard
  refresh / Ctrl+Shift+R.)

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
- **Track A (BIP) spike — NO MFA wall, BUT current credential REJECTED by BIP (2026-06-26, zeep on vm180).**
  Ran a real `zeep` 4.3.2 spike against the BIP web services. Findings, in order:
    1. **No MFA / no Entra redirect** on any BIP SOAP endpoint — confirmed. The service does its own
       credential check; MFA is genuinely not in the path.
    2. **WSSE (`ExternalReportWSSService.getFolderContents`) keeps returning `InvalidSecurity: error
       in processing the WS-Security security header`** — even with correct `zeep` UsernameToken
       **and** a `wsu:Timestamp`, PasswordText **and** PasswordDigest. So it is NOT a curl/canon
       issue and NOT a missing-timestamp issue; OWSM wants a stricter policy (likely message
       protection / signing) on the WSS endpoint. These are header-structure rejections → password
       never evaluated → lockout-safe.
    3. **The clean path is `…/xmlpserver/services/v2/ReportService`** — its non-`InSession` ops take
       **inline `userID`/`password` as plain SOAP body params, no WS-Security at all**:
       `runReport(reportRequest, userID, password)`, `getReportParameters(reportRequest, userID, password)`.
       This sidesteps OWSM/WSSE entirely.
    4. **DECISIVE:** `getReportParameters(req, OTBI_USER, OTBI_PWD)` returned
       **`java.lang.SecurityException: Failed to log into BI Publisher: invalid username or password.`**
       The credential was **evaluated and rejected**. The `OTBI_USER/OTBI_PWD` in `env.sh` (the
       Entra/SSO password the browser workers use to drive the interactive login) is **not valid for
       BIP direct service auth** — the classic federated-SSO gotcha (SSO password ≠ a credential the
       Fusion identity domain accepts for non-interactive web-service login).
  **Revised verdict:** the *mechanism* is solved (v2/ReportService, inline creds, no WSSE, no MFA),
  but Track A is **blocked on a credential**: it needs either (a) the correct username form / a
  Fusion-local (non-SSO) password for this user, or (b) a dedicated **BI Publisher service account**
  from IT with web-service access. **Do not keep trying username/password variants** — each is a real
  FailedAuth against the shared account the whole browser fleet depends on (one such failure already
  occurred during this spike; worker confirmed still `active` after). **Next step is an IT/credential
  ask, not more code.** Once a working credential exists, the build is small: `extract_bip.py` calling
  `v2/ReportService.runReport` with inline creds + `extract_track='BIP'` + per-job report path.

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

---

## Fusion Actions — read PoC (2026-06-30)

Driving Fusion via the extract-job session now has a dedicated hub:
**`otbi-atd/docs/fusion-actions/`** (README + `fusion_invoice_lookup.py` + PoC writeup
+ evidence). PoC verified: looked up `INV/HQ/26032465` on atd-vm181 and returned its
line description via the Payables UI.

Key finding: **`fscmRestApi` returns 401 even with a full Fusion UI cookie session**
(federated ADGOV SSO has no Fusion-local password/OAuth) → **UI robot is the only
channel** for both reads and the AP write-back. ADF needs JS `el.click()`; Navigator
sub-items are lazy (expand the group first). Push scripts to the VMs with
base64-in-one-shot (a plain `scp` + separate run can leave a 0-byte file).
See `fusion-actions/README.md`.

---

## Fusion Action #2 — PPM_TASK_ADDL_INFO (financial-plan task Organization Reference, 2026-07-09)

Second write-back action type: **update a task's "Additional Information" DFF on a project's
financial plan** (first use: set the *Organization Reference* cost-centre segment). Requested
flow replicated 1:1: My Projects → search Project Number → open project → Tasks drawer →
*Manage Financial Project Plan* → Display=**List** → QBE-filter Task Number → row's
*Additional Information* icon → popup → fill Organization Reference (LOV autosuggest) → OK → Save.

- **DB:** `otbi-atd/db/43_atd_action_ppm.sql` — seeds `PPM_TASK_ADDL_INFO` into the
  `ATD_ACTION_TYPE` lookup. **DEPLOYED 2026-07-09.** That is the ONLY DB change — queue,
  `ATD_ACTION_PKG`, `/atd/actions*` ORDS and the App 208 Actions page are all generic over
  `action_type`. (Script uses plain INSERT-if-absent, no MERGE block — the Linux SQLcl 26.1
  MERGE-swallow gotcha.)
- **Runner:** `actions/ppm_task_addl.py` (+ dispatch branch in `actions/__init__.py`).
  Built on the PROVEN ADF patterns from the read PoC (`docs/fusion-actions/`): `_jsclick`
  (`el.click()` in-DOM — ADF intercepts normal clicks), lazy Navigator groups (expand
  `groupNode_projects` first), `_fill_label` for label-adjacent inputs, long ADF waits.
  **No REST anywhere** — `fscmRestApi` is 401 under ADGOV SSO (PoC finding), so idempotency
  is **UI-based**: the handler reads the popup's current Organization Reference and returns
  "already set — idempotent skip" without saving when it already carries the target. An
  UPDATE is also naturally idempotent (re-applying the same value is a no-op).
- **Payload** (`payload_json`): `{"projectNumber": "...", "taskNumber": "...", "orgReference": "..."}`
  (+ optional `entitySpecific` / `appropriation` / `program` / `bgOverride` /
  `revenueAccountOverride` — the other popup segments). Suggested `idem_key`:
  `PPM-ORGREF:<project>:<task>:<cc>` (include the cc — a later re-point of the same task to a
  NEW cost centre must be a NEW idem_key; DONE rows are never re-armed).
- **Safety:** `ATD_ACTION_LIVE=1` gates the page-level Save; a dry run navigates, filters,
  fills the popup and clicks OK (all in-memory on the ADF page) then raises `DryRun` BEFORE
  Save. After a live Save the handler re-opens the popup and verifies the value stuck
  (read-back) before marking DONE. Step screenshots via `ATD_ACTION_SHOT_DIR` (set
  automatically by the smoke) — the headless-VM way to tune selectors.
- **Smoke:** `smoke_ppm_task.py` + `payload_ppm_task.json` (first trial: project 4511000682,
  task "Annual Reports", cost centre 4510195). HEADLESS by default with screenshots to
  `./ppm_smoke_shots/`; `--headed` on a desktop. On a worker VM:
  ```bash
  # push the two new/changed files base64-in-one-shot (race-free), then dry-run
  for f in actions/ppm_task_addl.py actions/__init__.py smoke_ppm_task.py payload_ppm_task.json; do
    base64 otbi-atd/runner/$f | ssh -i $KEY root@192.168.1.181 "base64 -d > /root/otbi-atd/runner/$f"
  done
  ssh -i $KEY root@192.168.1.181 "cd ~/otbi-atd/runner && source ~/otbi-atd/env.sh && \
    ~/otbi-atd/venv/bin/python -u smoke_ppm_task.py payload_ppm_task.json"
  # review ppm_smoke_shots/*.png; when selectors are confirmed:
  #   ATD_ACTION_LIVE=1 ~/otbi-atd/venv/bin/python -u smoke_ppm_task.py payload_ppm_task.json
  ```
- **Enqueue (via the queue instead of the smoke):**
  ```sql
  DECLARE
    v_id NUMBER;
  BEGIN
    v_id := prod.atd_action_pkg.enqueue_action(
      p_action_type   => 'PPM_TASK_ADDL_INFO',
      p_source_module => 'ATD', p_source_type => 'ADHOC', p_source_id => NULL,
      p_source_ref    => 'Annual Reports @ 4511000682',
      p_idem_key      => 'PPM-ORGREF:4511000682:Annual Reports:4510195',
      p_payload       => '{"projectNumber":"4511000682","taskNumber":"Annual Reports","orgReference":"4510195"}');
  END;
  /
  ```
  The scheduled `runner.py --actions` sweep picks it up (worker must run with
  `ATD_ACTION_LIVE=1` to actually save; otherwise the row fails with the DryRun note).
- **Selector status: VALIDATED LIVE 2026-07-13** — E2E on vm180 (headless): dry-run PASS
  (popup filled, DryRun gate held) then **LIVE run PASS** (Save + read-back verified; trial
  project 4511000682 / task "Annual Reports" / cc 4510195 now carries *DCT ALC Executive
  Director's Office Division*). Final handler synced to vm180/181/182 (md5-verified);
  **restart `atd-worker` on the fleet** so the long-running workers import the new module.
  Unit tests: `tests/test_actions.py` PASS. **ADF selector laws learned in the 19-round tune
  (apply to every future UI action):**
  1. **Visible-first, always** — ADF keeps HIDDEN duplicates in the DOM (topbar Personalize
     spans, pre-rendered dialog buttons) that match text/title selectors FIRST in document
     order. Iterate matches and act on the first `is_visible()` one; in JS filters use
     `offsetParent!==null && getBoundingClientRect().width>0`.
  2. **The af:query Search panel lands COLLAPSED with its inputs NOT in the DOM** — expand
     via a REAL Playwright click on the anchor `a[id$="_afrDscl"]` / `[title="Expand Search"]`
     (header-text clicks and JS clicks never expand it).
  3. **JS value-set does not register in ADF component state** — the query ran empty despite
     the input visually holding the value. Fill with REAL typing (`press_sequentially`) + Tab
     blur; LOV autosuggest also only fires on real keystrokes, and the suggest entry needs a
     REAL click on the VISIBLE row.
  4. **Saved-search defaults over-constrain** — My Projects pre-fills Team Member + Project
     Status=Approved; clear them (Ctrl+A, Delete, Tab) before searching by number.
  5. **Never walk <tr> ancestors to find a row** — the whole page is nested tables + a
     frozen/scrollable grid split. Use the deterministic id scheme instead: Task Number cell
     `…:tt1:<row>:tNum::content` (span in display mode, **input in edit mode** — match both)
     ↔ same row's Additional Information icon `…:tt1:<row>:dffIL1` (swap the suffix).
  6. **ADF panelWindow popups carry NO `role="dialog"`** — detect by the visible title text,
     then walk up to the smallest div containing the field inputs.
  7. **Page-level Save is not a `<button>`** — click the first VISIBLE exact-text "Save"
     element (`get_by_text("Save", exact=True)`).
  8. **After an LOV commit Fusion displays the DESCRIPTION, not the code** — read-back must
     accept the resolved display text captured at fill time (and the idempotency fast-path
     only triggers when the code is visible in the field).
- **UI (2026-07-09, ATD APP_VERSION 1.20.0):** App 208 **"Manage Projects Org"** page (route
  `projectsOrg`) — single-row form + **Excel bulk upload** (SheetJS client-side parse + template
  download) + recent-actions list. Backed by additive **`otbi-atd/db/44_atd_ppm_org_ords.sql`**
  (`POST /atd/actions/enqueue`, ≤500 rows/req, per-row result; DEPLOYED + API/browser-verified).
  **13 re-run ⇒ re-run 20, 38, 41, 42, 44, 45.** Details in `final apps/ATD/docs/deployment-notes.md`.
- **LOVs + fleet actions drain (2026-07-13, ATD APP_VERSION 1.21.0):** additive
  **`otbi-atd/db/45_atd_ppm_lov_ords.sql`** = `GET /atd/actions/ppmlov?type=project|task|cc
  [&search=][&project=]` type-ahead lists (sources `prod.atd_projects`/`prod.atd_tasks`/
  `prod.dct_gl_coa_v`; **`q=` is reserved by ORDS — use `search=`**; validate params BEFORE
  `json_header`) feeding `<datalist>`s on the 3 required form inputs (project searchable by number
  or name; tasks per typed project; suggestion-only, free text preserved — the extract is a
  snapshot). AND the worker fleet now drains the ACTIONS queue: `runner.py`
  `_drain_actions_idle` runs in the `--worker --forever` idle path (before this, NOTHING on the
  VMs ran `--actions`, so UI-enqueued actions sat READY forever); `ATD_ACTION_LIVE=1` set in each
  VM's `env.sh`; fleet synced + restarted. The actions queue (`ATD_ACTION_REQUEST`) is SEPARATE
  from the extract queue (`ATD_OTBI_JOBS`) — same fleet + SSO session, different tables/claim pkgs.
