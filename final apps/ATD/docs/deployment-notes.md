# ATD Loader (App 208) — Deployment & Runbook

Control-plane JET app over the OTBI → ATD automation. Backend DB lives in `otbi-atd/db/`
(not `final apps/ATD/db/`) — the ATD database is kept in one place. See Admin's
`docs/deployment-notes.md` for the canonical SQLcl/ORDS platform rules.

## Deploy order
1. **DB (once):** `otbi-atd/db/01_atd_control_tables.sql`, `11_atd_job_ordering.sql`,
   `12_atd_job_queue.sql` (tables + `ATD_QUEUE_PKG`).
2. **ORDS:** `otbi-atd/db/13_atd_ords.sql` via `sql -name prod_mcp` in a **fresh** SQLcl
   session (synonym rule → ORA-01471). Creates ADMIN synonyms + module `atd.rest` at
   `/ords/admin/atd/`. Smoke: `python final apps/ATD/tests/atd_api_smoke.py`.
3. **Frontend:** static under `final apps/ATD/Jet/`. Bump `window.APP_VERSION` in
   `Jet/index.html` on every ship. **A change under `final apps/shared/` bumps ALL apps'
   APP_VERSION** (this app's first deploy bumped the 8 siblings for the shell-registry edit).

## Auth
Admin-only. No private login — when no `ifinance_jet_session` exists the app redirects to
`/Admin/Jet/index.html` (only Admin/App 200 writes the session; same-origin via dev-proxy).
Every ORDS handler gates on `SYS_ADMIN`.

## Run locally
```
cd "final apps/ATD/Jet" && python dev-proxy.py        # serves all sibling apps + /shared
# open http://localhost:8080/Admin/Jet/index.html, log in (ADMIN / iFinance@2026),
# then http://localhost:8080/ATD/Jet/index.html
```

## Smoke test (done 2026-06-18)
- API: `tests/atd_api_smoke.py` — 14/15 endpoints green (jobs CRUD round-trip, queue ops,
  401/403/404 gating). The "fail" is a 201-vs-200 assertion only; create works.
- UI: Playwright drive of all 7 views — 0 console/page errors; every view renders live data
  (dashboard KPIs + queue donut + recent/alerts; jobs/queue/runs/envs/targets tables;
  jobDetail with run history).

## Gotchas captured
- `.kpi*` card styles are **not** in `platform.css` (they were TM-local) → added to
  `Jet/css/app.css`.
- ORDS handler: never pass a **scalar subquery as an APEX_JSON.write argument** (PL/SQL
  rejects it) → put it in the cursor SELECT / use OUTER APPLY.
- ORDS handler: call `dct_rest.err(404)` **before** `json_header`/`initialize_output`, else
  the status line leaks into the body.
- PUT into CLOB columns via `CASE … THEN APEX_JSON.get_varchar2 … END` needs `TO_CLOB(...)`
  on the THEN branch (CLOB/VARCHAR2 type mix → ORA-00932).

## Relationship to the runner
The app **enqueues** (marks jobs READY); execution is the `otbi-atd/runner` workers (the
15-min Windows Task `OTBI-ATD Loader` on this host, or `--worker` hosts). Dashboard shows
`claimedBy`/`claimedAt` so an all-READY-but-idle state is visible.

## Deployment history
- **2026-06-19** — **Run Logs: pager + Warning filter** (APP_VERSION 1.3.4). Added the shared
  `<list-pager>` to Run Logs (server-paged `offset`/`limit`/`total`, default 50/page; filter changes
  reset to page 1) and a **WARNING** option to the status filter. `GET /runs` (+ COUNT + `/runs/export`)
  now map `status=WARNING` → `status='SUCCESS' AND message IS NOT NULL`, so you can isolate the
  warned runs (drift/truncation). ORDS redeployed; verified live (WARNING→10 rows all `warn=Y`;
  pager 1–50 / 51–100 of 326, 7 pages; pages disjoint).
- **2026-06-18** — **Filter fix: Run Logs + Jobs** (APP_VERSION 1.3.3, frontend-only). The
  job/status/date filters were lagging one change behind: the controls used
  `value: X, event:{change: load}`, and KO fires the `event` `change` handler **before** the
  `value` binding writes the observable, so `load()` read the previous value. Fixed by driving
  `load` from **observable subscriptions** (`fJob/fStatus/fFrom/fTo` on Run Logs; `fStatus` on
  Jobs) and removing the `event:{change: load}` markup. Also surfaced the server `total` in the
  Run Logs count label (`100 / 322 results`) so a filter's effect is visible even though the list
  is capped at 100 (no pager yet). No ORDS/DB change. Browser-verified (FAILED→3, SUCCESS→100/319,
  job=SUPPLIERS→100/106 all-SUPPLIERS, combined→1, todt→96). **KO gotcha for future filters: never
  pair `value:` with `event:{change: load}` on one control — subscribe to the observable instead.**
- **2026-06-18** — **Run-duration on Run Logs** (APP_VERSION 1.3.2). Extended the duration column
  to the **Run Logs** list + run-detail modal (`GET /runs` + `/runs/:id` now return `durationSec`),
  same `js/util/duration.js` adaptive-compact format; `—` for RUNNING / no-`started` rows. ORDS
  redeployed; live-verified.
- **2026-06-18** — **Run-duration column** (APP_VERSION 1.3.1). Jobs list shows a **Duration**
  column (`GET /jobs` → `lastDurationSec`, the last run's `finished − started` in seconds, via the
  OUTER APPLY); Job Detail run-history adds a Duration column (`durationSec` per run). Formatted
  client-side adaptive-compact (`47s` / `1m 50s` / `1h 20m 10s`) by `js/util/duration.js`, units
  i18n `atd.dur.h/m/s` (EN h/m/s, AR س/د/ث), Latin digits; `—` when a run-log row has no `started`
  (the SQLcl loader path stamps only `finished`). ORDS redeployed; live-verified against real runs.
- **2026-06-18** — **Backlog: re-prepare action + atomic reload** (APP_VERSION 1.3.0).
  (1) New `POST /atd/jobs/:name/reprepare` clears `column_map_json` (next run re-derives it);
  `{"rebuild":"Y"}` also DROPs the stage (+final) table so the next run recreates it from the
  live data — the recovery path for an **incompatible** column change. Surfaced on the Job
  Detail page as **Re-map** (safe) + **Rebuild table** (danger, confirm). ORDS redeployed;
  live-verified (remap flips `prepared` Y→N; rebuild dropped a real `PROD.ATD_RP_DROP`; 404 on
  unknown job). (2) **`TRUNCATE_INSERT` is now an atomic replace** — the loaders clear the
  staging table with `DELETE` (in-transaction) instead of `TRUNCATE` (DDL auto-commit), so a
  failed reload rolls back and the table keeps its prior load. SQLcl path uses
  `WHENEVER SQLERROR EXIT FAILURE ROLLBACK`; oracledb path adds `conn.rollback()` before the
  FAILED-log commit. (The opt-in `ATD_LOAD_METHOD=bulk` SQLcl-LOAD path stays non-atomic — it
  commits per batch — and is unchanged.)
- **2026-06-18** — App 208 built (DB/ORDS/JET/UAT round 1 26/26) + Runner Settings.
- **2026-06-18** — **Drift warnings made visible + consistent** (APP_VERSION 1.2.1). Drift/
  truncation notes now land in the run-log `message` on **all** paths (sqlcl via `loadsql`
  `extra_msg`; FAILED path prepends the note). UI: `⚠ warning` chip in Run Logs (`/runs` returns
  `warn`+`message`), `kind` (WARNING/FAILED) on Dashboard Alerts (broadened to any run with a
  message). Fixed a false-positive: `prepare.DATE_RE` now matches all loader date formats so a
  DATE column with `15-JAN-2026`-style values isn't flagged incompatible. ORDS redeployed; live-
  verified (real runs already show `widened POSTED_FLAG` + the now-fixed TO_DT case).
- **2026-06-18** — **Schema-drift auto-adapt.** `prepare.ensure_prepared_*` now runs every load:
  after the first run it diffs the live header and ADDs new columns / widens outgrown text
  automatically, keeps removed columns (load NULL) and flags incompatible type changes — all
  warned via Telegram + run-log `message`. Runner-only (no frontend change); verified live
  (A VARCHAR2(20)→100 widen + new column ADD on a probe table). See "Schema drift" below.
- **2026-06-18** — **Minimal job create + auto-prepare.** Creating a job now needs only the
  **analysis path** (target table optional); job name/env/target/stage table are auto-derived
  in `POST /atd/jobs`, and the **staging table + column map are prepared by the runner on first
  run** (new `otbi-atd/runner/prepare.py`, shared with `add_analysis.py`; wired into both the
  oracledb and SQLcl load paths). `prepared` flag added to `/jobs` list + detail; UI New-Job
  drawer collapsed to path + optional target table with an "Advanced options" disclosure.
  Redeployed `13_atd_ords.sql`; APP_VERSION 1.1.0 → **1.2.0**. Verified live: minimal POST
  derives `MY_TEST_ANALYSIS` → `PROD.ATD_MY_TEST_ANALYSIS`, env/target auto-filled,
  `prepared='N'`, missing-source → 400. No `final apps/shared/` change → only this app bumped.

## Auto-prepare contract (prepare.py)
- A job "needs preparation" when `column_map_json` is empty. On that job's first run the runner
  profiles the freshly downloaded CSV (`profile()` — same column-name/type inference as
  `add_analysis.py`), **CREATEs the staging table if missing** (sized/typed from the data +
  a `load_ts` audit column), persists `column_map_json` + `stage_table` onto the job row, then
  loads. DB slug (`PROD.ATD_<slug>`) and the runner's `derive_table()` produce identical names,
  so the pre-created stage table and the runner agree.

## Schema drift — auto-adapt + warn (every run)
`ensure_prepared_*` runs on **every** load, not just the first, so a job tracks its analysis
when columns change. After the first run it diffs the live CSV header against the stored map +
table columns (`_plan_drift`) and reconciles:
- **New column** → `ALTER TABLE ADD` (typed from the live data) + extend the map. *(auto)*
- **Outgrown text** (values longer than the column) → `ALTER TABLE MODIFY` to a wider
  `VARCHAR2`. *(auto; `NUMBER` is unbounded in our DDL so numbers never need widening.)*
- **Removed column** → kept in the table + map; it loads `NULL`. **Warned.**
- **Incompatible** (a `NUMBER`/`DATE` column now holds text) → **warned**, not altered (changing
  a populated column's type needs it empty); the load then fails loudly (ORA-01722 / date parse)
  and is logged `FAILED`. **To accept it, use Job Detail → Rebuild table** (`POST /jobs/:name/
  reprepare {"rebuild":"Y"}`), which drops the stage (+final) table + clears the map so the next
  run recreates it fresh from the live data. (Re-map clears only the map — for a non-breaking
  remap.) Both the stage and (MERGE) final table are altered together.
- Warnings go to **Telegram** (`notify.send`) **and the run-log `message` on every path**:
  oracledb (`_log_end`), sqlcl (`loadsql._logvals` `extra_msg`), and the FAILED path prepends the
  drift note so a failed reload explains *why*. Reconcile ALTERs auto-commit; widening only grows.
- **Where it shows in the UI:** a `SUCCESS` run with a message gets a `⚠ warning` chip in the
  **Run Logs** list (`warn='Y'`, message in the tooltip) + the full text in the run **detail
  modal**; the **Dashboard → Alerts** panel lists failures *and* warnings with a `kind`
  (WARNING amber / FAILED red). `GET /runs` returns `warn`+`message`; `GET /dashboard` alerts
  use `WHERE status='FAILED' OR message IS NOT NULL`.
- **Date-format alignment (avoids false drift):** `prepare.DATE_RE` recognises every shape the
  loader parses (`YYYY-MM-DD[ HH:MI:SS]`, `DD-MON-YYYY`, `MM/DD/YYYY[ HH:MI:SS]`), so a DATE
  column fed non-ISO dates (e.g. `15-JAN-2026`) is **not** mis-flagged as an incompatible change.

### Performance (the extra step runs every load)
- The only added cost on a **clean** (no-drift) run is a small `all_tab_columns` query
  (negligible) + one `profile()` pass over the already-downloaded CSV. `profile()` is a single
  streaming pass (rewritten from a per-column pass): **~125 ms for a 12k-row analysis, ~0.7 s
  for the 65k-row OTBI export cap** (17.7 MB). The load itself already parses the CSV (~0.35 s
  at 65k), and the OTBI download dominates a run (seconds), so prepare adds a low single-digit
  % to a job's wall time and is dwarfed by the network fetch. No ALTER/commit happens unless the
  schema actually drifted.
- A drift *reconcile* needs no extra DB work beyond the one metadata query + (rarely) the ALTERs.
- If very large analyses ever run on a tight cadence, the next lever is to **fuse profiling into
  the load's existing CSV parse** (one pass instead of two) — deferred; not worth the coupling at
  current data sizes.
