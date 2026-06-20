# Task Management (App 207) — Functions List

> **Purpose:** Complete grouped inventory of every user-facing function the Task
> Management JET SPA exposes, organised by functional area.
>
> **⚠️ KEEP THIS UPDATED.** Whenever you add, remove, or rename a view, viewModel
> method, or service in `final apps/TM/Jet/`, update this file in the **same change**.
> Each functional area maps to a view; bullets are public `self.<method>` on its
> viewModel. See the repo-wide rule in the root `CLAUDE.md` → "Functions List".

Module: **Task Management** · ORDS base: `/ords/admin/tm`

---

## 1. Authentication
**Login** (`login`) — `doLogin` · `quickLogin`.

## 2. Dashboard
**Dashboard** (`dashboard`) — landing + quick navigation.
- `go`.

## 3. My Work
**My Work** (`myWork`) — the user's assigned tasks.
- `load` · `open` · `markDone` · `prioClass` / `statClass`.

## 4. Teams

**Teams** (`teams`) — team list (search toolbar + platform data table).
- `newTeam` / `editTeam` (per-row edit; loads full team via `getTeam`, drawer updates via `PUT teams/:id`) / `open` / `save` (create↔update) / `cancel` · `load` · `ragClass` / `statusClass`.

**Team Detail** (`teamDetail`) — full team workspace (summary header band + tabs: tasks board, members, docs, comments).
- Visibility: `taskPct` (header completion %) · `tabCount` / `tabAttn` (tab count pills + attention dots) · `loadOverview` (builds the Overview "Needs attention" + "Upcoming" lists) · `statusBadge` / `sevBadge` (semantic status/severity colors).
- Tabs/load: `setTab` / `tabClass` · `loadTab` / `loadTaskPanel` · `refreshTeam` / `refreshUsers` · `editTeam` / `saveTeam`.
- Task board: `openTask` / `closeTask` · `colTasks` · `saveTaskStatus` · drag-drop `onDragStart` / `onDragOver` / `onDrop` · `doAssign` / `unassign` · `addComment`.
- Members: `openAddMember` / `openEditMember` (drawer; role + title via `members/update`) / `saveMember` / `cancelAddMember` · `changeRole` / `makePrimary` / `removeMember`.
- Objectives (measurable): `openObjective` / `closeObjective` / `removeObjective` · `loadKrs` / `refreshObjAfterKr` · `saveObjEdits` (title/status/target/weight + Auto|Manual progress mode) · key results `openAddKr` / `editKr` / `cancelKr` / `saveKr` / `recordKr` / `removeKr`.
- Documents (raw-binary upload via shared `docUpload.choose` + `tmService.uploadDocumentFile`/`putBinary`): `openAddDoc` / `openEditDoc` (drawer; file name + type + notes via `documents/update`) / `saveDoc` / `cancelAddDoc` / `onFilePick`.
- Generic add/edit (drawer): `openAdd` / `openEdit` (per-row edit for deliverable/raid/milestone/meeting — pre-fills the shared `<edit-drawer>` and upserts via `editId`) / `saveAdd` / `cancelAdd` · `back` · `initials` / `prioClass` / `ragClass` / `statusLabel`.

## 5. Team Roles
**Team Roles** (`teamRoles`) — team role × artifact permission templates.
- `loadPerms` · `yn`.

## 6. Library
**Library** (`library`) — shared document/artifact library.
- `load` · `fmtSize`.

## 7. Reports
**Reports** (`reports`) — team/task reporting (RAG).
- `pct` / `ragClass`.

## 8. Notifications
**Notifications** (`notifications`) — `markRead` / `markAll` · `typeClass`.

## 9. Preferences
**Preferences** (`preferences`) — user preferences.
- `save`.

---

## API Endpoints (ORDS)

Module `tm.rest` · base path **`/ords/admin/tm/`** · defined in `final apps/TM/db/06_tm_ords.sql`.
All protected handlers call `dct_rest.validate_session`. **Shared `/dct/` calls:** auth
(`auth/login`, `auth/logout`, session validation), `GET boot`, **and notifications** go to the
Admin `/ords/admin/dct/` module (via `authBase`) — TM defines no module-level notifications.
All other calls (incl. TM's own `GET boot`/`prefs`) hit `/ords/admin/tm/`. Notifications use
`GET /dct/notifications/` + `PUT /dct/notifications/:id/read` (mark-all = per-item PUT, since
`dct` has no `mark-all-read`).

| Area | Method & Path |
|---|---|
| Boot / Dashboard | `GET boot` · `GET dashboard` |
| Teams | `GET teams` · `POST teams` · `GET teams/:id` · `PUT teams/:id` |
| Members | `GET members` · `POST members/add` · `POST members/role` · `POST members/update` · `POST members/remove` · `GET users` |
| Roles / Permissions | `GET perms` · `POST perms` |
| Objectives & Milestones | `GET objectives` · `POST objectives` · `DELETE objectives/:id` · `GET milestones` · `POST milestones` |
| Key Results (measurable objectives) | `GET key-results?objectiveId=` · `POST key-results` · `POST key-results/value` · `DELETE key-results/:id` |
| Tasks | `GET tasks` · `POST tasks` · `POST tasks/status` · `POST tasks/assign` · `GET tasks/assignees` · `GET tasks/updates` · `POST tasks/update` · `GET my-tasks` |
| Deliverables | `GET deliverables` · `POST deliverables` · `POST deliverables/status` |
| RAID & Meetings | `GET raid` · `POST raid` · `GET meetings` · `POST meetings` |
| Documents | `GET documents` · `POST documents` · `POST documents/update` · `PUT documents/:id/file` *(raw-binary upload)* · `GET documents/:id/file` *(media)* |
| Preferences | `GET prefs` · `POST prefs` |
| Reporting cycles | `GET cycle-config?teamId=` · `POST cycle-config` · `GET periods` · `POST periods/generate` · `POST periods/close` · `POST periods/lock` · `POST periods/signoff` · `GET periods/:id/snapshot` |
| Member check-ins | `GET my-submissions` · `GET submissions?periodId=` · `POST submissions/save` · `POST submissions/submit` · `GET period-status?periodId=` |
| Visibility (exec exceptions) | `GET visibility-grants` · `POST visibility-grants` · `POST visibility-grants/revoke` · `GET my-visibility` |
| Team hierarchy + executive | `POST teams/parent` · `GET team-tree` · `GET exec/teams` |
| Custom roles (admin) | `POST roles` · `POST roles/retire` · `POST role-template-perm` |
| AI period summary | `POST periods/:id/ai-summary` *(generate via DCT_TM_AI_PKG → Anthropic; gated by AI_FEATURES_ENABLED)* · `GET periods/:id/ai-summary` *(read stored)* |

> **Row-level visibility (security):** all team-keyed GET list handlers (`teams`, `teams/:id`, `members`, `objectives`, `tasks`, `deliverables`, `raid`, `milestones`, `meetings`) and the dashboard aggregates are scoped to the caller's visible team set via `dct_tm_vis_pkg.visible_teams(uid)` — a team only sees its own data unless an active visibility grant / org-head / team-tree / admin scope applies.

## Functional areas — Reporting Cycles, Executive View & Visibility (2026-06-20)

| Area | View / ViewModel | Key `self.*` methods |
|---|---|---|
| My Check-ins | `views/myUpdates.html` + `viewModels/myUpdates.js` | `load`, `open`, `saveDraft`, `submit` (auto-pulled metrics shown read-only) |
| Executive View | `views/exec.html` + `viewModels/exec.js` | `load`, `setGroup` (org/team-tree/flat), `openTeam`; RAG donut + on-time leaderboard + grouped scorecard |
| Reporting Cycle (per team) | `views/teamCycle.html` + `viewModels/teamCycle.js` | `saveConfig`, `generate`, `openRoster`, `closePeriod`, `lockPeriod`, `signoff`, `saveParent` |
| Visibility Grants (admin) | `views/visibilityGrants.html` + `viewModels/visibilityGrants.js` | `newGrant`, `save`, `revoke` (scope TEAM/TEAM_TREE/ORG/ALL × VIEWER/REPORTER) |
| Team Roles (admin, full CRUD) | `views/teamRoles.html` + `viewModels/teamRoles.js` | `newRole`, `editRole`, `saveRole`, `retire`, `toggle` (clickable template CRUD matrix) |
| Timeline / Gantt (per team) | `views/timeline.html` + `viewModels/timeline.js` | date-axis bars for tasks/deliverables/milestones (reached from teamDetail) |

**Phase B/C additions (2026-06-20):** exec scorecard gains achievement **badges** (`exec.js` `badges()` — perfect on-time / zero-overdue / all-on-track); **AI executive summary** per period in the teamCycle roster modal (`genAi`, `getAiSummary`); **weekly leader digest** (`DCT_TM_CYCLE_PKG.run_cycle_sweep` step 7, Sundays, gated by `CYCLE_WEEKLY_DIGEST`) — auto-fans to mobile push via the shared `DCT_NOTIFICATIONS`→`DCT_PUSH_OUTBOX` trigger (db/v2/28), so all `TM_CYCLE_*`/`TM_WEEKLY_DIGEST` notifications already reach App 209. New `tmService`: `getAiSummary`, `generateAiSummary`.

`tmService` additions: `getCycleConfig`, `saveCycleConfig`, `listPeriods`, `generatePeriods`, `closePeriod`, `lockPeriod`, `signoffPeriod`, `periodSnapshot`, `periodStatus`, `mySubmissions`, `getSubmission`, `saveSubmission`, `submitSubmission`, `listGrants`, `createGrant`, `revokeGrant`, `myVisibility`, `setTeamParent`, `teamTree`, `execTeams`, `saveRole`, `retireRole`, `saveRoleTemplatePerm`.

---

## Services / Data Layer (`js/services/`)

| Service | Responsibility |
|---|---|
| `api.js` | Bearer-token fetch wrapper; 401 → login. |
| `config.js` | `apiBase` toggle (mock vs `/ords/admin/tm`). |
| `authService` | login / session validate. |
| `tmService` | teams, tasks, members, objectives + key results, documents, roles, reports. |
| `notificationService` | notifications + count. |
