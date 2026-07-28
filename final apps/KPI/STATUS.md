# KPI Module (App 213) — Status

Finance KPI Management — DOF "ADGEs Unified Financials KPIs" automation.
Identity: App **213**, key `kpi`, code `KP`, module_code `KPI_MGMT`, ORDS `/ords/admin/kpi/`, brand `#8C6D1F`.

| Layer | Status | Notes |
|---|---|---|
| Plan (KPI_PLAN.md) | ✅ Approved 2026-07-28 | |
| DB DDL (db/01) | ✅ Deployed 2026-07-28 | 9 DCT_KPI_* tables, lookup-first |
| Views (db/02) | ✅ Deployed 2026-07-28 | 5 views incl. DWP fact view |
| Seed (db/03) | ✅ Deployed 2026-07-28 | 4 circular KPIs EN+AR, roles, module row 213 |
| Package (db/04) | ✅ Deployed 2026-07-28 | DCT_KPI_PKG; unit harness 36/36 |
| Workflow seed (db/05) | ✅ Deployed 2026-07-28 | KPI_RESULT_APPROVAL on DWP, route WF; live cycle APPROVED |
| ORDS (db/06) | ✅ Deployed 2026-07-28 | kpi.rest, 26 handlers; API tests 56/56; db/v2/50 gate has `kpi` |
| Jobs (db/07) | ✅ Deployed 2026-07-28 | period + reminder jobs SCHEDULED; 2026/2027 calendars live |
| JET SPA | ⚠️ v1.2.0 FAILED end-user review 2026-07-28 | 9 views live but IA is framework-shaped; **UX redesign planned — see KPI_REDESIGN_PLAN.md** (task-first Home, guided wizard, plain-language scorecard; server side unchanged) |
| Report | ✅ Deployed 2026-07-28 | KPI_BRIEFING_BOOK (reporting/db/29) + template; run SUCCESS, 8-page PDF |
| Docs / UAT | ✅ 2026-07-28 | deployment-notes, functions_list; UAT round 1 = 18/18 PASS |
| APEX pages | ⬜ N/A for now | JET-first module |

Open business confirmations (now Phase 0 of the redesign — blocking): Section Head =
line-manager resolver vs fixed role; KPI_FIN_DIRECTOR holder (ADMIN is the placeholder);
revenue account scope for the KPI 1 auto-suggestion; inter-KPI scorecard weights
(defaulted 25% each); KPI 4 cadence; **submission due dates per period**; expected-evidence
checklist per KPI; named preparers/approvers per KPI.

## Deployment log

| Date | What | Result |
|---|---|---|
| 2026-07-28 | First full deployment (db 01–07, DWP process, ORDS, gate, report, frontend registration) | 0 INVALID; unit 36/36; API 56/56; browser 15/15; UAT round 1 18/18; briefing book PDF verified |
| 2026-07-28 | Webtier release 20260728125906 — KPI/Jet + shared shell live on ifinance-web | /KPI/Jet/ 200 @ APP_VERSION 1.0.0; switcher entry served fleet-wide |
| 2026-07-28 | v1.1.0 FPB-layout review round (regions/tiles/guide/hints/calc explainer) — webtier release 20260728132554 | browser smoke 20/20; live @ 1.1.0 |
| 2026-07-28 | v1.2.0 FPB skin (Fraunces/Public Sans fonts, cream canvas, gold-gradient headers, GL-style tables/controls) — webtier release 20260728141810 | browser smoke 20/20; live @ 1.2.0 |
