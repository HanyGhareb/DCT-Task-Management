# Admin (App 200) — Functions List

> **Purpose:** A complete, grouped inventory of every user-facing function the Admin
> JET SPA exposes, organised by functional area. Use it as the single reference for
> "what can this app do".
>
> **⚠️ KEEP THIS UPDATED.** Whenever you add, remove, or rename a view, viewModel
> method, or service in `final apps/Admin/Jet/`, update this file in the **same change**.
> Each functional area maps to a view (`js/views/<x>.html` + `js/viewModels/<x>.js`);
> the bullet under each is a public `self.<method>` on that viewModel. See the
> repo-wide rule in the root `CLAUDE.md` → "Functions List".

Module: **Admin / Identity Provider** · Brand: platform default · ORDS base: `/ords/admin/dct`

---

## 1. Authentication & Session

**Login** (`login`) — central identity provider; all module apps authenticate here.
- `doLogin` — submit username/password, open session, write `ifinance_jet_session`.
- `quickLogin` — one-click UAT/demo login as a seeded user.
- `onKeyDown` — Enter-to-submit handler.

**Cross-UI SSO hand-off** (shell + `appController`, db/v2/41 — gated `FEATURE_SSO_HANDOFF`)
- **APEX** topbar button (all shared-shell apps, injected by `shared/js/shell.js`) — `POST /dct/sso/code` then opens APEX App 200 signed-in in a new tab.
- `#sso=<code>` boot hook (`appController`) — APEX→JET landing: scrubs the code from the URL, `authService.ssoExchange(code)`, then `onLogin`; invalid code falls back to the login form.

**Active Sessions** (`sessions`) — view/revoke live sessions across the platform.
- `reload` · `revoke` (terminate a session) · `isOwn` (flag current session) · `fmt`.

**My Profile** (`profile`) — self-service profile, password, photo, delegations.
- `saveProfile` · `changePassword` · `pickPhoto` / `photoSelected` (profile photo upload).
- `createDelegation` / `cancelDelegation` / `openDelModal` · `isMyOutgoing` · `delBadge`.

## 2. User Management

**Users** (`users`) — paginated, searchable user directory (server pagination).
- `reload` · `setStatus` (ALL/ACTIVE/INACTIVE filter) · `addUser` / `editUser` / `navigateToEdit`.
- `confirmDelete` (soft deactivate + undo toast) · `getInitials`.
- Bulk actions: `toggleSelect` / `toggleSelectAll` / `isSelected` / `clearSelection` / `openBulk` / `runBulk` / `closeBulk`.

**User Editor** (`userEdit`) — create/edit a user with validation.
- `save` · `cancel` · `validate` / `validatePassword` / `validateConfirm` / `setFieldError` / `getError` / `hasError`.

## 3. Roles & Permissions

**Roles** (`roles`) — role catalogue.
- `addRole` · `editRole` / `navigateToEdit` · `confirmDelete` / `cancelDelete` / `doDelete`.

**Role Editor** (`roleEdit`) — edit a role + its permission set.
- `save` · `cancel` · `validate` / `getError` / `hasError`.

**Permission Matrix** (`permissions`) — role × permission grid by module.
- `togglePerm` · `hasPerm` · `getPermsByModule` · `saveAll`.

## 4. Organisation & Modules

**Org Hierarchy** (`orgHierarchy`) — org unit tree (divisions/departments/sections).
- `openAdd` / `addChild` / `openEdit` / `saveUnit` · `toggleActive` · `getParentName` / `getTypeLabel` / `closeModal`.

**Modules** (`modules`) — register/configure module apps (PC, DT, HR…).
- `openEdit` / `saveEdit` / `closeEdit` · `toggleActive`.
- Module access (db/v2/49): `openAccess` / `saveAccess` / `closeAccess` / `clearAccess` —
  per-module role grant set controlling App-Launcher (module switcher) visibility;
  empty set = visible to everyone, SYS_ADMIN always sees every app.

## 5. Approvals & Delegation

**Approval Templates** (`approvalTemplates`) — multi-step approval workflow designer with draft lifecycle.
- `viewTemplate` · `saveSteps` / `moveStep` · `activate` / `toggleActive` · `cloneDraft`.
- Versioning: `openHistory` / `closeHistory` / `hasHistory` / `familyArchives` / `restoreVersion` / `diffText` · `statusOf` / `statusBadge` / `closeDetail`.

**Approval Monitor** (`approvalMonitor`) — live view of in-flight approval instances.
- `reload` · `getStepArray` / `stepState` / `getProgressPct`.

**Pending Approvals** (`pendingApprovals`) — unified approvals inbox (all modules).
- `startApprove` / `startReject` / `startAction` · `confirmAction` / `cancelAction` · `getStepArray` / `stepState`.

**Delegations** (`delegations`) — admin view of approval delegations.
- `reload` · `cancel` · `scopeLabel` / `statusBadge`.

**Approval Processes** (`processes`) — the DWP process designer (shared `<wf-designer>`): clone a published chain to a draft, edit steps/conditions/participants (incl. the `ASSIGNED_ROLE` resolver), simulate (which steps fire/skip and who resolves), publish. List / **Diagram** (flowchart) toggle via shared `<wf-diagram>`.

**Role Assignments** (`roleAssignments`) — date-tracked assignment of users to workflow DATA roles (FBP, PBP, Approver, Planner, FYI Group) per business object (Sector, Department, HR Org, Cost Center, Project, Task, Appropriation, PO, GL Account, Entity). WF_ADMIN/SYS_ADMIN.
- Tab Assignments: `search` / `resetFilters` / `nextPage` / `prevPage` · `openNew` / `saveEdit` / `closeEdit` (type-driven object picker: `searchObjects` / `searchParents`; live holder preview `refreshPreview`) · `openAct` / `saveAct` / `closeAct` (End / Replace / Void) · `openTimeline`.
- Tab Audit: `auditSearch` / `aNext` / `aPrev` · `exportCsv` (Arabic-safe CSV) · `openBiReport` (deep-links the BI Interactive Report `WF_ROLE_ASSIGN_AUDIT` — `#irViewer/<CODE>` auto-runs a parameter-less report).
- **Role Policies** modal: `openPolicies` / `togglePolicy` — flip a role between single-assignee and group (`PUT /wf/assign/policy/:role`, db/v2/97; warns with the overlap count when flipping to single leaves grandfathered overlaps).

## 6. System Configuration

**System Settings** (`systemSettings`) — platform-wide settings (branding, feature flags, secrets).
- `saveAll`.

**Region Appearance** (`appearance`) — region header/border theming palette.
- `selectTheme` · `saveTheme`.

**Lookups** (`lookups`) — manage `DCT_LOOKUP_VALUES` enum/status sets (lookup-first).
- `openNew` / `openEdit` / `saveEdit` / `closeEdit`.

## 7. Communication

**Announcements** (`announcements`) — platform announcement banners.
- `openCreate` / `openEdit` / `save` · `toggleActive` · `audienceLabel` / `sevBadge`.

**Notifications** (`notifications`) — user notification centre.
- `markRead` / `markAllRead` · `getTypeIcon`.

## 8. Audit & Monitoring

**Audit Log** (`auditLog`) — searchable audit trail with before/after diff modal + CSV export.
- `reload` · `toggleExpand` (diff snapshot) · `exportCsv` · `formatDate` / `getActionBadgeClass`.

**Automation Registry** (`runners`) — catalogue of every automation runner/script (location,
purpose, how-to-use, deps/schedule, optional inline text + stored binary copy); full CRUD via
the shared `<edit-drawer>` + `<doc-upload>`.
- `reload` · `doSearch` / `clearFilters` · `openNew` / `openEdit` / `closeEdit` / `saveEdit` · `del`
  · `onFilePicked` (shared doc-upload) / `downloadFile` · `statusClass`.

## 9. Dashboard

**Dashboard** (`dashboard`) — customisable KPI/widget home.
- `toggleCustomize` · `toggleWidget` / `isHidden` / `moveStat`.

---

## API Endpoints (ORDS)

Module `dct.admin` · base path **`/ords/admin/dct/`** · defined in `db/v2/11_dct_ords.sql`.
These `/dct/` endpoints are the **platform-shared** API. Module apps (PC/DT/HR/FL/CC/AR/TM)
route only **auth** (`auth/login`, `auth/logout`, session validation) and **`GET boot`** here,
via their `authBase` config; all their other calls — including each module's own notifications —
go to `/ords/admin/<code>/`. (Exception: TM defines no module notifications and calls
`/dct/notifications/` directly.) All protected handlers call `dct_rest.validate_session`;
`GET /branding` is the ONLY public handler. Note: `dct` has no `notifications/mark-all-read`
and read is **PUT** `notifications/:id/read` (not POST).

| Area | Method & Path |
|---|---|
| Auth | `POST auth/login` · `POST auth/logout` · `POST auth/sso` *(public — redeem an APEX2JET one-time code for a bearer session; db/v2/41b)* |
| SSO hand-off | `POST sso/code` *(bearer — issue a JET2APEX one-time code; body `{app}` = calling JET module's app number, honored when on the `APEX_SSO_APPS` allowlist else falls back to 200; returns `{code, expiresInSecs, apexUrl, targetApp}`; gated `FEATURE_SSO_HANDOFF`; db/v2/41b+41c)* |
| Boot / shared | `GET boot` · `GET branding` *(public)* · `GET stats/` · `GET prefs/` · `PUT prefs/:prefkey` |
| Users | `GET users/` · `POST users/` · `GET users/:id` · `PUT users/:id` · `DELETE users/:id` · `PUT users/:id/photo` |
| Roles & Permissions | `GET roles/` · `POST roles/` · `GET roles/:id` · `PUT roles/:id` · `DELETE roles/:id` · `GET permissions/` |
| Modules | `GET modules/` · `PUT modules/:id` · `GET modules/:id/roles` · `PUT modules/:id/roles` *(module access grant set, SYS_ADMIN; db/v2/49)* |
| Module access | `GET my/modules` *(denied module codes for the session user — consumed by `shared/js/shell.js` to hide switcher entries; db/v2/49)* |
| Org Hierarchy | `GET orgs/` · `POST orgs/` · `PUT orgs/:id` |
| Lookups | `GET lookups/` · `POST lookups/values` · `PUT lookups/values/:id` |
| Settings | `GET settings/` · `PUT settings/:setkey` |
| Notifications | `GET notifications/` · `GET notifications/count` · `PUT notifications/:id/read` |
| Approvals | `GET approvals/pending` · `GET approvals/` · `POST approvals/:id/action` |
| Approval Templates | `GET approval-templates/` · `GET approval-templates/:id` · `PUT approval-templates/:id` · `POST approval-templates/:id/clone` · `POST approval-templates/:id/activate` · `PUT approval-templates/:id/steps` · `POST approval-templates/:id/restore` |
| Audit | `GET audit/` · `GET audit/:id` · `GET audit/export` |
| Sessions | `GET sessions/` · `POST sessions/revoke` |
| Automation Registry | `GET runners/` · `GET runners/meta` · `POST runners/` · `GET runners/:id` · `PUT runners/:id` · `DELETE runners/:id` · `PUT runners/:id/file` · `GET runners/:id/file` *(db/v2/31)* |
| Delegations | `GET delegations/` · `POST delegations/` · `POST delegations/:id/cancel` |
| Announcements | `GET announcements/` · `POST announcements/` · `PUT announcements/:id` · `GET announcements/active` |

Module `wf.rest` · base path **`/ords/admin/wf/`** · defined in `db/v2/67` + `69` (designer) + `96` (role assignments). Cross-module by design (EXEMPT from the module-access gate → every route self-gates); consumed via `shared/js/wfService.js`.

| Area | Endpoints |
|---|---|
| Worklist & actions | `GET worklist` · `POST tasks/:id/action` · `claim` / `release` / `delegate` / `request-info` · `GET instances/:id/history` · `GET chain` |
| Designer (WF_ADMIN) | `GET processes` · `versions/:id/steps` · `versions/:id/design` · `outcome-sets` · `schemas/:id/fields` · `POST processes/:code/draft` · `PUT/DELETE versions/:id/step(/:key)` · `condition(/:key)` · `participant(/:rid)` · `POST versions/:id/validate` / `publish` · `DELETE versions/:id` · `POST conditions/compile` · `POST processes/:code/simulate` |
| Role assignments (WF_ADMIN) | `GET assign/object-types` · `GET assign/lov` · `GET assign/list` · `POST assign/` (create / replace) · `PUT assign/:id` (end / update / void) · `GET assign/timeline` · `GET assign/preview` · `GET assign/audit` · `GET assign/audit/export` *(db/v2/96)* · `PUT assign/policy/:role` *(db/v2/97)* |

---

## Services / Data Layer (`js/services/`)

| Service | Responsibility |
|---|---|
| `api.js` | Bearer-token fetch wrapper; auto-navigates to `login` on 401. |
| `config.js` | `apiBase` toggle (mock vs `/ords/admin/dct`). |
| `authService` | login / logout / validate session / `ssoExchange(code)` (APEX→JET hand-off, db/v2/41). |
| `userService` | user CRUD + `getPage()` server pagination. |
| `roleService` | roles CRUD + `getPermissionMatrix()` + `setRolePermissions()`. |
| `orgService` | org hierarchy CRUD. |
| `moduleService` | module app registry + module access grant set (`getRoles`/`setRoles`, db/v2/49). |
| `settingService` | system/module settings. |
| `themeService` | brand + region theme. |
| `notificationService` | notifications + count. |
| `auditService` | audit log + export. |
| `sessionService` | active sessions + revoke. |
| `delegationService` | approval delegations. |
| `announcementService` | announcement banners. |
| `runnerService` | automation registry CRUD + meta + binary file up/download (`putBinary`/`fetchBlobUrl`). |
