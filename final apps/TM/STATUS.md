# Task Management (TM) — App 207 — Status

Module code `TASK_MGMT` · ORDS `/ords/admin/tm/` · JET `final apps/TM/Jet/` · Brand `#0E8A8A`

Build is **layer-by-layer**; each layer is deployed and verified before the next.

| Layer | Scope | State |
|---|---|---|
| 0 | Folder skeleton, `TM_PLAN.md`, `STATUS.md` | ✅ done |
| 1 | DDL (`01_tm_ddl.sql`) + seeds (`03_tm_seed.sql`) | ✅ deployed + verified |
| 1 | `install.sql` master | ✅ written |
| 1t | test harness (`db/test/tm_smoke_test.sql`) | ✅ 16/16 pass |
| 2 | `02_tm_views.sql` (12 views) + `04_tm_pkg.sql` (DCT_TM_PKG) + `05_tm_reminder_pkg.sql` | ✅ deployed, all VALID |
| 3 | ORDS `tm.rest` (`06_tm_ords.sql`) — 23 templates, PUBLISHED; 401 gate verified live; pytest suite in `tests/api/` | ✅ deployed |
| 4 | JET SPA (10 views/VMs) + App 207 in shared shell.js + i18n + APP_VERSION 4.5.0 ×8; JS/JSON valid; static-served smoke OK | ✅ built |
| 5 | `07_tm_jobs.sql` reminder job (daily 07:00 Asia/Dubai) | ✅ deployed |
| 6 | `install.sql` + `docs/deployment-notes.md` + UAT round-1 case book; E2E/pytest specs delivered | ✅ docs done |

**Live E2E DONE (Playwright, quick-login):** 8/8 flows pass, 0 console errors — switcher Admin→TM, dashboard KPIs, create team, create task, **Kanban drag TODO→DONE persisted**, My Tasks, Preferences, Reports. Evidence in `UAT/UAT_TM_round1-13-06-2026/evidence_13-Jun-2026/`. Fixed during the run: boot lookup query (`LIKE 'TM\_%' ESCAPE '\'`), `notificationService` → auth base, `SIBLING_APPS` += `'TM'` in all 8 dev-proxies.

**UAT round 2 (Admin-style package) DONE 2026-06-13 — 27/27 PASS.** Reusable `UAT/UAT_TM_TestScript.xlsx` master + `UAT/UAT_TM_round2-13-06-2026/` holding the filled workbook (`UAT_TM_13-Jun-2026-01.xlsx`), Word results (`UAT_TM_Results_13-Jun-2026-01.docx`) and `evidence_13-Jun-2026-01/` (27 screenshots). Runner: `assessment-3/phase4/tests/uat_run_tm.py` (Playwright + ORDS, mirrors `uat_run_cc.py`). Covers Access/Session, Dashboard, Teams, Team Detail (overview+edit), Members (add/role/remove), Tasks (create/kanban/assign/**reassign-trail**/comment), Artifacts (deliverable/RAID/milestone/meeting/document), Cross-cutting (My Tasks/Reports/Preferences/AR-RTL).

**Still pending:** authenticated pytest API run (`tests/api`, env `TM_USER`/`TM_PASS`), AI-assist hooks (deferred sub-feature).

## Deployment log

_(append one line per deploy: date · script · result)_

- 2026-06-13 · Layer 0 scaffolding created.
- 2026-06-13 · `01_tm_ddl.sql` deployed — 13 DCT_TM_* tables + indexes + triggers (clean).
- 2026-06-13 · `03_tm_seed.sql` deployed — verified CATS=14, VALS=72, MODULE=1, SYSROLES=2, SETTINGS=12, TMROLES=6, TMPERMS=60. Needed `SET SQLBLANKLINES ON` (SQLcl swallowed the lookup block otherwise). Arabic verified clean (multibyte, no mojibake).
- 2026-06-13 · `04_tm_pkg.sql` (DCT_TM_PKG) deployed VALID — published actor_name/gen_code/role_id_of in spec to avoid PLS-00231 (private fn in SQL).
- 2026-06-13 · `02_tm_views.sql` deployed — 12 read views created.
- 2026-06-13 · `05_tm_reminder_pkg.sql` (DCT_TM_REMINDER_PKG) deployed VALID.
- 2026-06-13 · `db/test/tm_smoke_test.sql` run — 16/16 PASS (happy/edge/error/boundary), changes rolled back. utPLSQL not installed on ADB, so harness is standalone PL/SQL asserts.
- 2026-06-13 · `06_tm_ords.sql` deployed (fresh session) — 25 ADMIN synonyms, `tm.rest` 23 templates PUBLISHED at /tm/. Live GET /tm/boot without token → 401 (gate verified).
- 2026-06-13 · `07_tm_jobs.sql` — DCT_TM_REMINDER_JOB created (daily 07:00 Asia/Dubai).
- 2026-06-13 · JET app built: index/main/appController + services (config/api/auth/tmService/notification) + 10 views/VMs (login, dashboard, teams, teamDetail w/ Kanban, myWork, library, reports, teamRoles, preferences, notifications) + css + EN/AR i18n. App 207 registered in shared shell.js MODULES + common i18n; APP_VERSION bumped 4.4.0→4.5.0 in all 8 apps. node --check on all JS + JSON parse OK; dev-proxy static smoke OK (index/app.css/tmService 200, shell.js serves TASK_MGMT).
- 2026-06-13 · install.sql + docs/deployment-notes.md + UAT/UAT_TM_round1-13-06-2026/UAT_TM_cases.md (28 cases) + tests/api/test_tm_api.py + tests/e2e/team_lifecycle.spec.js written.
- 2026-06-13 · **UI/UX rework + functional enhancements (round 2)** — APP_VERSION 4.5.1. Driven by user feedback ("look & feel different, fields not aligned; no way to add members/documents/milestones/meetings, edit team, or assign tasks with reassignment tracking").
  - **Root cause of the visual divergence:** TM views used a bespoke `.input` / `.modal` / `<label>`-wrapping markup instead of the shared platform classes (`.form-control` / `.form-group` / `.form-grid` / `.modal-overlay` / `.modal-box`). Converted the teams create modal + rebuilt teamDetail on platform classes; added an `.input`→form-control style shim + missing helpers (`.muted`, `.btn-xs`, `.btn-icon-danger`, `.badge--brand`, `.avatar`, `.form-control--sm`) and new components (`.def-grid`, `.tm-person`, `.tm-assignee(s)`, `.tm-feed`, `.tm-prog`, `.tm-drawer`) to `css/app.css`.
  - **teamDetail fully rebuilt:** Overview now shows ALL team fields in a definition grid + **Edit Team** modal (PUT /teams/:id); **Members** tab gains add (user picker)/role-change/remove; **Tasks** cards open a **drawer** with status/progress, **assignees (assign / set-primary / unassign)**, an **activity feed**, and comments; **Milestones**, **Meetings**, and a new **Documents** tab all gain add forms.
  - **Backend (deployed):** `DCT_TM_PKG.assign_task`/`unassign_task` now write `DCT_TM_TASK_UPDATES` rows recording assignment & **primary-reassignment** history; new `DCT_TM_PKG.add_document` (unified `DCT_DOCUMENTS`, source_module='TM'). New ORDS routes `GET /users`, `GET /tasks/assignees`, `POST /documents`; boot now returns `docTypes`; +3 synonyms (dct_users, dct_tm_task_assignees, dct_document_types). Package compiled clean; ORDS redeployed in a fresh session; new routes 401-gated (verified).
  - **Bugs fixed during the run:** (1) optional fields bound bare (`text: dueDate`) threw "not defined" because **APEX_JSON omits NULL keys** — rebound all nullable fields as `$data.field` per the platform gotcha; (2) `canEditTeam` read a plain `myUid` var so the computed never re-ran after boot when `isTmAdmin` stayed false — made `myUid` observable (Edit/manage buttons now appear for the team leader); (3) milestone status dropdown sourced from non-existent `TM_MILESTONE_STATUS` → corrected to `TM_OBJECTIVE_STATUS`; (4) TM login view still carried HR copy-branding → set to TM.
  - **Live verification (Playwright, quick-login):** backend **15/15** authenticated flows pass (incl. assign→reassign: feed logged "Primary assignee reassigned from AYESHA.AMERI to HANY", primary flag moved; add member/milestone/meeting/document; PUT edit → ON_HOLD). UI render: TM app, def-grid, 9 tabs, members table, kanban, task drawer (2 assignees, 2 feed items), documents row, edit modal — **0 console errors** (only the universal pre-login 401). Evidence: c:/tmp/tm_overview.png, tm_task_drawer.png, tm_members.png, tm_documents.png.
- 2026-06-13 · LIVE Playwright E2E (quick-login via Admin) — 8/8 pass, 0 console errors; 7 evidence screenshots. Three fixes shipped: (1) `06_tm_ords.sql` boot query used SQL-Server `LIKE 'TM[_]%' ESCAPE '['` (matched nothing → empty dropdowns → ORA-01400) → Oracle `LIKE 'TM\_%' ESCAPE '\'`, ORDS redeployed; (2) `notificationService.js` hit `/tm/notifications` (500/CORS) → now uses `{base:'auth'}` (/dct, platform DCT_NOTIFY); (3) all 8 dev-proxies `SIBLING_APPS` += `'TM'` so the switcher's `/TM/Jet/` URL resolves in dev. Kanban native HTML5 DnD verified (Playwright drag_to can't fire it — E2E spec dispatches real DragEvents).
