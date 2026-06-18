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

## Views (7)
dashboard · jobs · jobDetail · environments · targets · runs · queue
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

## How to run locally
```
cd "final apps/ATD/Jet" && python dev-proxy.py     # http://localhost:8080
# log in at /Admin/Jet/index.html (ADMIN), then open /ATD/Jet/index.html
```

## Notes
- The app **enqueues** (marks jobs READY); the `otbi-atd/runner` worker hosts execute.
  The 15-min Windows Task `OTBI-ATD Loader` on this host drains them.
- DB scripts live in `otbi-atd/db/` (not `final apps/ATD/db/`) — single home for the ATD DB.
