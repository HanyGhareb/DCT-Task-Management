# Task Management (TM) — App 207 — Build Plan

> Status tracker: [STATUS.md](STATUS.md) · Deploy runbook: [docs/deployment-notes.md](docs/deployment-notes.md)

## 1. Context & objective

The Finance Division needs a module to **manage teams and the work they follow up** —
objectives / operations / projects, tasks, deliverables, and a RAID-style register
of issues / challenges / risks / achievements — together with related documents,
role-based dashboards, due-task reminders, and management reports.

TM is a net-new i-Finance module (**App 207**, module code `TASK_MGMT`) built to the
same conventions as PC/DT/HR/FL/CC/AR: APEX identity via App 200, ORDS REST under
`/ords/admin/tm/` (`tm.rest`), a JET SPA in `Jet/`, the unified shared DB structures,
and the shared frontend layer (`final apps/shared/`).

## 2. Locked scope decisions

| Decision | Value |
|---|---|
| App / code / ORDS | 207 · `TASK_MGMT` · `/ords/admin/tm/` · package `tm.rest` |
| Brand | Teal **`#0E8A8A`** |
| Surface | JET SPA only (APEX deferred) |
| Permission layers | System roles `TM_ADMIN` / `TM_USER` (module access) **+** team-scoped roles (artifact CRUD) |
| Team-role model | Global templates **+ per-team override** (Vault `rm-*/re-*` matrix UI) |
| Status/enum values | **Lookup-first** — `DCT_LOOKUP_VALUES` via `DCT_LOOKUP_PKG`; no status CHECK constraints |
| Documents | Reuse unified `DCT_DOCUMENTS` (`source_module='TASK_MGMT'`); no new doc table |
| Full scope | core + AI assist + Gantt + gamification in one build |
| Deployment | **Layer-by-layer**, tests per layer |

## 3. Suggested team roles (global templates)

Team Leader · Team Supervisor · Coordinator/Secretary · Member · Quality/Risk Owner · Sponsor/Observer.
Each carries an `action × artifact` CRUD matrix; teams may override a role's matrix.

## 4. Data model — `DCT_TM_*`

Surrogate-key tables (TM uses `DCT_TM_TASKS`, distinct from the natural-key
project-costing `DCT_TASKS`).

| Table | Purpose |
|---|---|
| `DCT_TM_TEAMS` | team def + `team_type` (lookup `TM_TEAM_TYPE`), `team_class` (`TM_TEAM_CLASS`), `team_category` (`TM_TEAM_CATEGORY`), status, RAG health |
| `DCT_TM_ROLES` | team-role templates (code, name en/ar, is_system) |
| `DCT_TM_ROLE_PERMS` | role × artifact × C/R/U/D (+ per-team override rows) |
| `DCT_TM_MEMBERS` | (team_id, user_id from `DCT_USERS`), role_id, join/leave, is_active |
| `DCT_TM_OBJECTIVES` | goals/operations/projects: progress %, target date, weight, status |
| `DCT_TM_TASKS` | title/desc, team, objective?, parent_task (subtasks), priority/status, dates, %, effort |
| `DCT_TM_TASK_ASSIGNEES` | task ↔ member (cross-team My Work) |
| `DCT_TM_TASK_UPDATES` | progress notes / activity feed / @mentions |
| `DCT_TM_DELIVERABLES` | title, team, objective?/milestone?, owner, type/status, due/accepted, %, acceptance criteria |
| `DCT_TM_LOG_ITEMS` | unified RAID: `item_type` (ISSUE/CHALLENGE/RISK/ACHIEVEMENT/DECISION/DEPENDENCY/LESSON), severity, status, owner |
| `DCT_TM_MILESTONES` | key dates per team/objective |
| `DCT_TM_MEETINGS` | meetings + minutes + action items (promotable to tasks) |
| `DCT_TM_REMINDER_PREFS` | per-user lead_days (N), channels, digest opt-in |

Documents: unified `DCT_DOCUMENTS`, `source_type IN (TEAM,TASK,OBJECTIVE,DELIVERABLE,MEETING,LOG_ITEM)`.

Lookup sets seeded: `TM_TEAM_TYPE` (Internal/External), `TM_TEAM_CLASS`
(Strategic/Operational/Management), `TM_TEAM_CATEGORY` (open), `TM_TEAM_STATUS`,
`TM_TASK_STATUS`, `TM_TASK_PRIORITY`, `TM_OBJECTIVE_STATUS`, `TM_DELIVERABLE_TYPE`,
`TM_DELIVERABLE_STATUS`, `TM_LOG_ITEM_TYPE`, `TM_LOG_SEVERITY`, `TM_LOG_STATUS`,
`TM_ARTIFACT_TYPE`, `TM_RAG`.

## 5. Layers & build order (deploy + verify each)

0. Folder skeleton + `TM_PLAN.md` + `STATUS.md`. ✅
1. **DB DDL** `db/01_tm_ddl.sql` + **seeds** `db/03_tm_seed.sql` (lookups, module,
   system roles/permissions, module settings, team-role templates + default perms,
   region theme, approval templates) + `db/install.sql`. utPLSQL scaffold in `db/test/`.
2. **PL/SQL** `db/04_tm_pkg.sql` (`DCT_TM_PKG`), `db/05_tm_reminder_pkg.sql`,
   views `db/02_tm_views.sql`. utPLSQL suite green.
3. **ORDS** `db/06_tm_ords.sql` (`tm.rest` + synonyms, fresh SQLcl session). pytest API green.
4. **JET SPA** `Jet/` cloned from CC; services → `/ords/admin/tm/`; register App 207 in
   `final apps/shared/js/shell.js` MODULES + **bump `APP_VERSION` in all 8 apps**;
   `DCT_MODULES`/region-theme seed. Playwright E2E + regression.
5. **Reminder job** (DBMS_SCHEDULER daily) + AI hooks.
6. **UAT round 1** workbook/evidence/results + user guide + `docs/deployment-notes.md`.

## 6. QA strategy

utPLSQL (≥90% on `DCT_TM_PKG`) · pytest API · Playwright E2E · automated UAT runner ·
8-app regression pack. Every area: Happy / Edge / Error (400/401/403/404/500) / Boundary.

## 7. Reports (6)

Team Progress & Status · Overdue & Upcoming (SLA) · Member Workload & Productivity ·
RAID Register · Achievements & Milestones · Deliverables Status (bonus: Document Compliance).

## 8. Reference files (reuse, do not reinvent)

- DDL/constraints/triggers: `final apps/CC/db/01_cc_ddl.sql`
- Unified tables / lookups / validator: `db/v2/15_dct_unified_structures.sql`
- Seed pattern (module/roles/perms/settings/approvals): `final apps/CC/db/03_cc_seed.sql`
- ORDS scaffold: `final apps/CC/db/09_cc_ords.sql`
- JET shell/router: `final apps/CC/Jet/{main.js,index.html,appController.js}`
- Shared layer: `final apps/shared/js/{shell.js,api.js,chartLoader.js}`, `css/{platform.css,vault.css}`
- Module registry to extend: `final apps/shared/js/shell.js` MODULES array
