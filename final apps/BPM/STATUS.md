# Fusion BPM — Workflow Management (App 214) — Status

| Layer | Status |
|---|---|
| DB | ✅ `db/01_bpm_seed.sql` — the one `dct_modules` row (module_id 181). **No ORDS module by design** (console over `/wf/` + `/dct/`). |
| JET SPA | ✅ Live (v1.0.0) — dashboard + 9 consolidated workflow pages, EN/AR/RTL, shared shell |
| APEX | ⬜ N/A (JET only) |

## Deployment log

- **2026-08-01** — v1.0.0 initial release. App created; ALL workflow pages
  consolidated from Admin (myWorklist, pendingApprovals, myDelegations, processes,
  roleAssignments + 5 drawers, approvalMonitor, approvalTemplates, delegations) +
  new dashboard/notifications. `dct_modules` row deployed (App 214, display 78).
  Admin 4.7.15 strips the moved nav/pages and links to BPM; all 14 apps bumped
  (shared shell + i18n change). Tests: 7 moved suites (96 checks) + smoke 30/30,
  all PASS; PROD test residue 0.
