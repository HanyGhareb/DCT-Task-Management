# ATD Loader (App 208) — Status

Control-plane JET app for the OTBI → ATD automation (`otbi-atd/`). Manages the same
control tables the runner uses: configure jobs/envs/targets, enqueue runs, monitor the
shared queue + run logs. Admin-only (SYS_ADMIN).

| Layer | Status |
|---|---|
| DB (control tables, queue) | ✅ `otbi-atd/db/01,11,12` deployed (tables + `ATD_QUEUE_PKG`) |
| ORDS (`atd.rest`, `/ords/admin/atd/`) | ✅ `otbi-atd/db/13_atd_ords.sql` deployed + smoke-tested (14/15 green) |
| JET SPA (7 views) | ✅ Live, verified via dev-proxy (0 console errors, all views render real data) |
| Docs | ✅ this file + `docs/deployment-notes.md` + `docs/functions_list.md` |
| APEX pages | N/A (internal admin tool) |
| UAT package | ✅ round 1 — 26/26 PASS (2026-06-18); `UAT/uat_run_atd.py` + workbook + Word + evidence |
| Runner Settings | ✅ ATD_RUNNER_CONFIG + /atd/config + page (db/14); runner reads at startup |

## Views
dashboard · jobs · jobDetail · **jobSets · jobSetDetail** · queue · actions · discovery · runs ·
environments · targets · runnerSettings
Brand `#3A4FB0` (indigo). Shared platform shell + EN/AR + module switcher.

## Deployment log
- **2026-06-18** — App 208 built. ORDS `atd.rest` deployed; JET app (`final apps/ATD/Jet/`)
  live; registered in `shared/js/shell.js` MODULES + `shared/i18n/common.*`; all 8 sibling
  APP_VERSIONs bumped (shared shell change); CLAUDE.md Module Status row added.
- **2026-06-18** — **Minimal job create + runner auto-prepare** (APP_VERSION 1.2.0). New job
  needs only the analysis path (target table optional); job name/env/target/stage auto-derived;
  staging table + column map prepared on first run (`otbi-atd/runner/prepare.py`). `13_atd_ords.sql`
  redeployed; verified live (minimal POST → derived name + `prepared='N'`, missing-source → 400).
- **2026-06-18** — **Re-prepare action + atomic reload** (APP_VERSION 1.3.0). New
  `POST /atd/jobs/:name/reprepare` (Job Detail → Re-map / Rebuild table) recovers a job whose
  stored map/table no longer fits the analysis — `{"rebuild":"Y"}` drops + recreates the table to
  accept an incompatible change. `TRUNCATE_INSERT` is now an atomic `DELETE`-in-transaction
  replace (failed reload rolls back, keeps prior load). `13_atd_ords.sql` redeployed; live-verified
  (remap flips `prepared` Y→N; rebuild dropped a real PROD table; 404 on unknown job).
- **2026-06-18** — **Run-duration column** (APP_VERSION 1.3.1). Jobs list + Job Detail history show
  the run's elapsed time (`lastDurationSec`/`durationSec` from `GET /jobs` + `/jobs/:name`),
  formatted adaptive-compact (`47s` / `1m 50s` / `1h 20m 10s`) by `js/util/duration.js` (units i18n,
  Latin digits). ORDS redeployed; live-verified against real runs.
- **2026-06-18** — **Run-duration on Run Logs** (APP_VERSION 1.3.2). Same duration column on the
  Run Logs list + run-detail modal (`GET /runs` + `/runs/:id` return `durationSec`). ORDS
  redeployed; live-verified.
- **2026-06-18** — **Filter fix** (APP_VERSION 1.3.3, frontend-only). Run Logs + Jobs filters were
  lagging one change (KO `value`+`event:change` ordering); now driven by observable subscriptions.
  Run Logs count label shows `shown / total`. Browser-verified all filter combinations.
- **2026-06-19** — **Run Logs pager + Warning filter** (APP_VERSION 1.3.4). Shared `<list-pager>`
  on Run Logs (server-paged, 50/page); status filter gains **WARNING** (`GET /runs` maps it to
  SUCCESS rows with a message). ORDS redeployed; browser-verified (WARNING→10; pager 7 pages).
- **2026-07-01** — **Run Logs: Job Set column + filter** (APP_VERSION 1.19.0). The global Run Logs
  page is now set-aware: a **Job Set** column (region-themed badge, `—` when the job is in no set) +
  a **Job Set** filter dropdown. Additive ORDS `otbi-atd/db/42_atd_runs_set_ords.sql` REDEFINES
  `GET /runs` + `/runs/export` (LEFT JOIN `atd_job_set_member`→`atd_job_set`, `setCode`/`setName`
  fields + `?setcode=` filter; no DELETE_MODULE). **Always re-run 42 after 13** (13 rebuilds the
  plain handlers). Frontend `runs.html`/`runs.js` + `atd.col.jobSet`/`atd.runs.allSets` (EN+AR).
  Playwright E2E **9/9 PASS** (non-destructive, against the live FULL_DATA set).
- **2026-07-01** — **Manage Job Sets** (APP_VERSION 1.18.0). Grouped scheduling: `otbi-atd/db/40`
  (`ATD_JOB_SET` + `ATD_JOB_SET_MEMBER` [PK job_name = one set/job] + `atd_set_gate_ok`/`atd_set_eff_freq`/
  `atd_set_next_run` + `ATD_SET_PKG` run_now/notify_sweep + `ATD_SET_NOTIFY_JOB`), db/12 enqueue
  gate/interval edit, additive ORDS `otbi-atd/db/41` (`/job-sets*` + `/job-set-jobs`). New views
  `jobSets` + `jobSetDetail` (interval presets/day+time window, per-member enable/order, ≈ next-run,
  Run Set Now / Pause, set run-history, failure-notify). **Deploy 40 → re-run 12 → 41 (fresh session).**
  Full Playwright E2E **11/11 PASS** (create→member→toggle→run→pause→edit→AR→delete, all ORDS 200);
  PL/SQL smoke verified the gate + eff_freq + run_now. Gotchas: PLS-00231 (a nested `pts()` fn used in
  SQL → HTTP 555; fixed by inlining the TO_TIMESTAMP parse); ORA-12860 on SQLcl set-delete (PDML).

## How to run locally
```
cd "final apps/ATD/Jet" && python dev-proxy.py     # http://localhost:8080
# log in at /Admin/Jet/index.html (ADMIN), then open /ATD/Jet/index.html
```

## Notes
- The app **enqueues** (marks jobs READY); the `otbi-atd/runner` worker hosts execute.
  The 15-min Windows Task `OTBI-ATD Loader` on this host drains them.
- DB scripts live in `otbi-atd/db/` (not `final apps/ATD/db/`) — single home for the ATD DB.
