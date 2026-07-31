# Fusion BPM — Workflow Management (App 214) — Deployment Notes

> Platform-wide SQLcl/ORDS rules: see `final apps/Admin/docs/deployment-notes.md` §2.

## Deploy checklist

1. **Frontend:** bump `window.APP_VERSION` in `Jet/index.html` on every ship.
   A change under `final apps/shared/` bumps ALL apps (BPM included).
   Web tier: `SSH_USER=opc bash webtier/deploy_frontend.sh 129.151.159.189`
   (the script globs `*/Jet` — BPM ships automatically).
2. **DB:** `db/01_bpm_seed.sql` is the ONLY script (rerunnable; the `dct_modules`
   row). Run via `sql -name prod_mcp`. **There is no BPM ORDS module** — the app
   consumes `/ords/admin/wf/` + `/ords/admin/dct/`; nothing here to re-run after
   an 11 or 67 re-run (those have their own re-run lists).
3. **Smoke:** `python3 tests/bpm_browser_smoke.py` (30 checks) + the 7 workflow
   suites in `tests/` when workflow pages/components changed.

## Architecture notes

- `config.apiBase = …/ords/admin/dct` (same as Admin) so every page lifted from
  Admin works verbatim; `shared/api.js` derives the wf base by segment swap
  (`/dct` → `/wf`). If a dedicated BPM ORDS segment is ever introduced, either
  keep apiBase on a segment the `resolveBase` regex knows or set `config.wfBase`.
- Module-access: the `BPM` row in `dct_modules` makes the app restrictable via
  Admin → Modules → Access (empty grant set = everyone). No db/v2/50 CASE-map
  entry — BPM owns no ORDS path segment.
- Nav gating: Process Design = WF_ADMIN/SYS_ADMIN; Oversight = SYS_ADMIN/
  USER_ADMIN/WF_ADMIN; server routes remain the security boundary.

## Gotchas (learned building this app)

- **ORDS trailing slash + direct-ADB apiBase:** `GET /users?limit=500` 301s to
  `/users/?limit=500` and the redirect has no CORS headers → fetch fails
  SILENTLY under a direct-ADB base (this app / KPI pattern). Call collections
  with the trailing slash. (Only `/users` was affected; every other endpoint the
  app uses was probe-verified 200.)
- **Browser-test login hop:** no session → BPM redirects to the Admin portal.
  `window._jetApp` exists on the Admin login page BEFORE login — wait on
  `localStorage.getItem('ifinance_jet_session')`, then reload the BPM root.
- **UTC "today" status window:** a role assignment starting today lists as
  `FUTURE` between 00:00–04:00 Dubai (UTC storage; `SYSDATE` still yesterday).
- Admin dashboard's approval-cycle drill deep-links here
  (`/BPM/Jet/index.html#approvalMonitor`); `sessionStorage['amPresetSearch']`
  survives the same-tab hop — keep that key name if the monitor page changes.

## Deployment history

- **2026-08-01** — v1.0.0 initial release (consolidation of all Admin workflow
  pages + new dashboard). DB row deployed (module_id 181). Web release shipped
  with Admin 4.7.15 + platform-wide APP_VERSION bumps. All tests PASS
  (96 moved-suite checks + 30 smoke).
