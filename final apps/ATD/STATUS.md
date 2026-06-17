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

## How to run locally
```
cd "final apps/ATD/Jet" && python dev-proxy.py     # http://localhost:8080
# log in at /Admin/Jet/index.html (ADMIN), then open /ATD/Jet/index.html
```

## Notes
- The app **enqueues** (marks jobs READY); the `otbi-atd/runner` worker hosts execute.
  The 15-min Windows Task `OTBI-ATD Loader` on this host drains them.
- DB scripts live in `otbi-atd/db/` (not `final apps/ATD/db/`) — single home for the ATD DB.
