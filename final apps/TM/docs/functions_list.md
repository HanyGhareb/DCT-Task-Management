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

**Teams** (`teams`) — team list.
- `newTeam` / `open` / `save` / `cancel` · `load` · `ragClass`.

**Team Detail** (`teamDetail`) — full team workspace (tabs: tasks board, members, docs, comments).
- Tabs/load: `setTab` / `tabClass` · `loadTab` / `loadTaskPanel` · `refreshTeam` / `refreshUsers` · `editTeam` / `saveTeam`.
- Task board: `openTask` / `closeTask` · `colTasks` · `saveTaskStatus` · drag-drop `onDragStart` / `onDragOver` / `onDrop` · `doAssign` / `unassign` · `addComment`.
- Members: `openAddMember` / `saveMember` / `cancelAddMember` · `changeRole` / `makePrimary` / `removeMember`.
- Documents: `openAddDoc` / `saveDoc` / `cancelAddDoc` / `onFilePick`.
- Generic add: `openAdd` / `saveAdd` / `cancelAdd` · `back` · `initials` / `prioClass` / `ragClass` / `statusLabel`.

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
All other calls (incl. TM's own `GET boot`/`prefs`) hit `/ords/admin/tm/`.

> ⚠️ **Known drift:** `notificationService.js` calls `POST /dct/notifications/:id/read` and
> `POST /dct/notifications/mark-all-read`, but the `dct` module exposes `PUT notifications/:id/read`
> and has **no** `mark-all-read` handler — both 404/405 in live mode. Fix the client to `PUT` +
> per-item mark, or add `POST` aliases + `mark-all-read` to `db/v2/11_dct_ords.sql`.

| Area | Method & Path |
|---|---|
| Boot / Dashboard | `GET boot` · `GET dashboard` |
| Teams | `GET teams` · `POST teams` · `GET teams/:id` · `PUT teams/:id` |
| Members | `GET members` · `POST members/add` · `POST members/role` · `POST members/remove` · `GET users` |
| Roles / Permissions | `GET perms` · `POST perms` |
| Objectives & Milestones | `GET objectives` · `POST objectives` · `GET milestones` · `POST milestones` |
| Tasks | `GET tasks` · `POST tasks` · `POST tasks/status` · `POST tasks/assign` · `GET tasks/assignees` · `GET tasks/updates` · `POST tasks/update` · `GET my-tasks` |
| Deliverables | `GET deliverables` · `POST deliverables` · `POST deliverables/status` |
| RAID & Meetings | `GET raid` · `POST raid` · `GET meetings` · `POST meetings` |
| Documents | `GET documents` · `POST documents` |
| Preferences | `GET prefs` · `POST prefs` |

---

## Services / Data Layer (`js/services/`)

| Service | Responsibility |
|---|---|
| `api.js` | Bearer-token fetch wrapper; 401 → login. |
| `config.js` | `apiBase` toggle (mock vs `/ords/admin/tm`). |
| `authService` | login / session validate. |
| `tmService` | teams, tasks, members, documents, roles, reports. |
| `notificationService` | notifications + count. |
