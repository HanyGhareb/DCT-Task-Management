# Fusion BPM — Workflow Management (App 214) — Status

| Layer | Status |
|---|---|
| DB | ✅ `db/01_bpm_seed.sql` — the one `dct_modules` row (module_id 181). **No ORDS module by design** (console over `/wf/` + `/dct/`). + `02` THEME_SKIN seed · `03` ADDITIVE `bpm/settings` GET/PUT on `dct.admin` (**re-run 03 after any db/v2/11 re-run**) |
| JET SPA | ✅ Live (v1.1.0) — dashboard + 9 consolidated workflow pages + **Appearance (3 switchable skins, night default)**, EN/AR/RTL, shared shell |
| APEX | ⬜ N/A (JET only) |

## Deployment log

- **2026-08-02** — v1.1.0 switchable app skins: night (default) / redwood / diwan
  in `Jet/css/skins.css` + Appearance page + THEME_SKIN setting + additive
  `/dct/bpm/settings` routes. Browser test 15/15; web release `20260802153536`.

- **2026-08-01** — v1.0.0 initial release. App created; ALL workflow pages
  consolidated from Admin (myWorklist, pendingApprovals, myDelegations, processes,
  roleAssignments + 5 drawers, approvalMonitor, approvalTemplates, delegations) +
  new dashboard/notifications. `dct_modules` row deployed (App 214, display 78).
  Admin 4.7.15 strips the moved nav/pages and links to BPM; all 14 apps bumped
  (shared shell + i18n change). Tests: 7 moved suites (96 checks) + smoke 30/30,
  all PASS; PROD test residue 0.
