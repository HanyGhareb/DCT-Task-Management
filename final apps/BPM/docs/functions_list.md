# Fusion BPM — Workflow Management (App 214) — Functions List

> **Purpose:** A complete, grouped inventory of every user-facing function the
> Fusion BPM JET SPA exposes. **KEEP THIS UPDATED** — same-change rule as every
> app (see root `CLAUDE.md` → "Functions List").

Module: **Fusion BPM — Workflow Management** · Brand: `#7D3243` · module_code `BPM`
· **No ORDS module of its own** — the app is a console over the two existing
cross-module APIs: `/ords/admin/wf/` (DCT Workflow Platform, gate-exempt) and
`/ords/admin/dct/` (shared Admin module: legacy approvals, delegations, users,
notifications). `config.apiBase = …/dct`, and `shared/api.js` derives the wf base
from it (`{ base: 'wf' }` segment swap).

All pages below were consolidated here from the Admin app on **2026-08-01**.

---

## 1. Home

**Dashboard** (`dashboard`) — landing surface over both workflow stacks.
- Stat tiles (click-through): my open DWP tasks (`/wf/worklist`), pending legacy
  approvals (`/dct/approvals/pending`), my active delegations, process count
  (WF_ADMIN only, `/wf/processes`).
- `go(route)` quick links: worklist / pending / delegations (+ processes /
  role assignments / monitor for WF_ADMIN).

## 2. Workspace (visible to every user)

**My Worklist** (`myWorklist`) — the ONE cross-module DWP worklist: shared
`<wf-worklist>` (each task ships its OWN `outcomes[]` — no hard-coded verbs) +
`<wf-timeline>` drawer per request.

**Approval Templates** (`approvalTemplates`) — multi-step approval workflow designer with draft lifecycle.
- `viewTemplate` · `saveSteps` / `moveStep` · `activate` / `toggleActive` · `cloneDraft`.
- Versioning: `openHistory` / `closeHistory` / `hasHistory` / `familyArchives` / `restoreVersion` / `diffText` · `statusOf` / `statusBadge` / `closeDetail`.

**Approval Monitor** (`approvalMonitor`) — live view of in-flight approval instances.
- `reload` · `getStepArray` / `stepState` / `getProgressPct`.

**Pending Approvals** (`pendingApprovals`) — unified approvals inbox (all modules).
- `startApprove` / `startReject` / `startAction` · `confirmAction` / `cancelAction` · `getStepArray` / `stepState`.

**Delegations** (`delegations`) — admin oversight view of everyone's approval delegations (self-service lives at Workspace → My Delegations).
- `reload` · `cancel` · `scopeLabel` / `statusBadge`.

**Approval Processes** (`processes`) — the DWP process designer (shared `<wf-designer>`): clone a published chain to a draft, edit steps/conditions/participants (incl. the `ASSIGNED_ROLE` + `ASSIGNED_ROLE_CASCADE` resolvers and the per-step **Timers** section: reminders/escalation/auto-action), simulate (which steps fire/skip and who resolves — cascade steps show the resolved level), publish. List / **Diagram** (flowchart) toggle via shared `<wf-diagram>`. **Test mode** toggle per process (`toggleTestMode` → `PUT /wf/processes/:code/test-mode`, db/v2/114): notifications redirect to the `WF_TEST_EMAIL` account while ON (amber TEST MODE badge; platform-wide switch = System Settings → Workflow → `WF_TEST_MODE`).

**Role Assignments** (`roleAssignments`) — date-tracked assignment of users to workflow DATA roles (FBP, PBP, Approver, Planner, FYI Group) per business object (Sector, Department, HR Org, Cost Center, Project, Task, Appropriation, PO, GL Account, Entity). WF_ADMIN/SYS_ADMIN.
- Tab Assignments: `search` / `resetFilters` / `nextPage` / `prevPage` · `openNew` / `saveEdit` / `closeEdit` (type-driven object picker: `searchObjects` / `searchParents`; live holder preview `refreshPreview`) · `openAct` / `saveAct` / `closeAct` (End / Replace / Void) · `openTimeline`.
- Tab Audit: `auditSearch` / `aNext` / `aPrev` · `exportCsv` (Arabic-safe CSV) · `openBiReport` (deep-links the BI Interactive Report `WF_ROLE_ASSIGN_AUDIT` — `#irViewer/<CODE>` auto-runs a parameter-less report).
- **Role Policies** drawer: `openPolicies` / `togglePolicy` — flip a role between single-assignee and group (`PUT /wf/assign/policy/:role`, db/v2/97; warns with the overlap count when flipping to single leaves grandfathered overlaps). Shared `<edit-drawer>`.
- **Manage Roles** drawer (WF_ADMIN): `openManageRoles` / `mrNew` / `mrEdit` / `mrSave` — create/rename/deactivate DATA assignment roles + cardinality from the UI (`GET/POST /wf/assign/manage/roles`, db/v2/98); deactivation warns with the active-assignment count; pickers refresh immediately (`refreshMeta`).
- **Manage Objects** drawer (SYS_ADMIN): `openManageObjects` / `moNew` / `moEdit` / `moSave` / `moSearchViews` / `moLoadCols` — create/edit object-type registry rows with the LOV view and every column chosen from data-dictionary dropdowns (`GET/POST /wf/assign/manage/object-types` + `GET /wf/assign/dict`, db/v2/98); nothing free-typed reaches the registry.
- **Level Priority** drawer: `openPriority` / `lpSelectScope` / `lpUp` / `lpDown` / `lpAdd` / `lpRemove` / `lpStartFromDefault` / `lpSave` — the cascade order (default + per-role override) read by `ASSIGNED_ROLE_CASCADE` at approval time (`GET/PUT /wf/assign/priority`, db/v2/113); audited `ASSIGN_PRIORITY`.
- **Import Matrix** drawer: `openImport` / `imPickFile` / `imParse` / `imDryRun` / `imApply` / `imExportExceptions` — SheetJS parse of the approval-matrix workbook (role-name → email-column mapping, Key Users split), server dry-run/apply (`POST /wf/assign/import`, db/v2/113; unmatched emails reported `NO_USER`, never auto-created; apply = date-tracked create/replace/skip).


## 3. Alerts

**Notifications** (`notifications`) — platform notifications (`/dct/notifications/`),
mark-read / mark-all-read.

---

## Nav & gating

| Group | Items | Visible to |
|---|---|---|
| Home | dashboard | all |
| Workspace | myWorklist · pendingApprovals · myDelegations | all |
| Process Design | processes · roleAssignments | `WF_ADMIN` or `SYS_ADMIN` |
| Oversight | approvalMonitor · approvalTemplates · delegations | `SYS_ADMIN` / `USER_ADMIN` / `WF_ADMIN` |
| Alerts | notifications | all |

Nav gating mirrors the server: every `/wf/` designer/assign route self-gates
WF_ADMIN-or-SYS_ADMIN; the worklist is gated per-TASK.

## API Endpoints

BPM defines none. It consumes `/wf/*` (db/v2/67 + 96/97/98/113/114 — see the
platform workflow docs) and `/dct/approvals*`, `/dct/approval-templates*`,
`/dct/delegations*`, `/dct/users/`, `/dct/notifications*`, `/dct/stats/`.

## Services / Data Layer (`js/services/`)

| Service | Purpose |
|---|---|
| `config.js` | `apiBase`/`authBase` = `…/ords/admin/dct` (wf base derived by segment swap) |
| `authService.js` | session reader (`ifinance_jet_session`), `isWfAdmin()`, dev login |
| `auditService.js` | legacy approvals + templates + monitor + audit/stats (lifted from Admin) |
| `delegationService.js` | `/dct/delegations` (mine + oversight) |
| `userService.js` | user directory (pickers) |
| `moduleService.js` | module list (delegation module scope) |
| `notificationService.js` | platform notifications |
| shared `wfService.js` | the ONE client for `/wf/` (worklist/designer/assignments) |

## Gotcha log

- **ORDS trailing slash + direct-ADB base:** `GET /users?limit=500` 301-redirects
  to `/users/?limit=500`; the redirect response carries no CORS headers, so with a
  direct-ADB `apiBase` (this app, KPI-style) fetch fails SILENTLY. Always call
  collection endpoints with the trailing slash.
- **Login-hop test pattern:** with no session BPM redirects to the Admin portal;
  after login wait on `localStorage.getItem('ifinance_jet_session')` — NOT
  `window._jetApp`, which exists on the Admin login page pre-login — then reload
  the BPM root.
- **UTC "today" window:** a role assignment starting today computes status
  `FUTURE` between 00:00–04:00 Dubai (storage is UTC; `SYSDATE` is still
  yesterday). Both open statuses are correct in tests.
