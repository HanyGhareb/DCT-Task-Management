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
- **2026-06-18** — App 208 built (DB/ORDS/JET/UAT round 1 26/26) + Runner Settings.
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
  loads. Subsequent runs skip prep. DB slug (`PROD.ATD_<slug>`) and the runner's
  `derive_table()` produce identical names, so the pre-created stage table and the runner agree.
