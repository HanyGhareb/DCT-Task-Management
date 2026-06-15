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

---

## Services / Data Layer (`js/services/`)

| Service | Responsibility |
|---|---|
| `api.js` | Bearer-token fetch wrapper; 401 → login. |
| `config.js` | `apiBase` toggle (mock vs `/ords/admin/tm`). |
| `authService` | login / session validate. |
| `tmService` | teams, tasks, members, objectives + key results, documents, roles, reports. |
| `notificationService` | notifications + count. |
