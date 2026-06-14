# HR (App 205) — Functions List

> **Purpose:** Complete grouped inventory of every user-facing function the HR
> JET SPA exposes, organised by functional area.
>
> **⚠️ KEEP THIS UPDATED.** Whenever you add, remove, or rename a view, viewModel
> method, or service in `final apps/HR/Jet/`, update this file in the **same change**.
> Each functional area maps to a view; bullets are public `self.<method>` on its
> viewModel. See the repo-wide rule in the root `CLAUDE.md` → "Functions List".

Module: **HR** · ORDS base: `/ords/admin/hr`

---

## 1. Authentication
**Login** (`login`) — `doLogin` · `quickLogin`.

## 2. Dashboard
**Dashboard** (`dashboard`) — landing + quick navigation.
- `goEmployees` / `goPositions` / `goDocuments` / `goOrgChart`.

## 3. Employees

**Employees** (`employees`) — paginated directory with sort/filter/CSV.
- `openAdd` / `openEdit` / `openEmployee` / `saveEmployee` · `pickPhoto`.
- List: `setSort` / `sortClass` · `clearFilters` · `nextPage` / `prevPage` · `exportCSV`.
- Helpers: `initials` / `avatarColor` / `activeClass` / `genderLabel` / `fmtDate` · `closeModal` / `dispose`.

**Employee Detail** (`employeeDetail`) — full employee record (tabs: edit, assignments, contracts, salary, docs).
- `setTab` · `openEdit` / `saveEdit` / `closeEdit` · `pickPhoto`.
- Assignments: `openAddAssignment` / `saveAssignment` / `openEndAssignment` / `confirmEndAssignment` / `closeAssignmentModal` / `closeEndModal`.
- Contracts: `openAddContract` / `openEditContract` / `saveContract` / `closeContractModal`.
- Salary: `openAddSalary` / `saveSalary` / `closeSalaryModal` · `fmtSalary`.
- Documents: `openAddDoc` / `openEditDoc` / `saveDoc` / `pickDocFile` / `downloadDoc` / `closeDocModal`.
- `toggleEditAudit` · `goBack` · `alertClass` / `fmtDateTime` · `dispose`.

## 4. Positions
**Positions** (`positions`) — position master with fill tracking.
- `openAdd` / `openEdit` / `savePosition` · `setSort` / `sortClass` · `clearFilters` · `exportCSV`.
- `goToEmployees` · `fillPct` / `fillBarClass` / `vacancyClass` · `toggleAudit` · `closeModal` / `dispose`.

## 5. Organisation
**Org Hierarchy** (`orgHierarchy`) — org tree editor.
- `openAdd` / `addChild` / `addSibling` / `openEdit` / `saveOrg` · `select` · `toggle` / `expandAll` / `collapseAll` · `typeClass` · `closeOrgModal`.

## 6. Master Data

**Grades** (`grades`) — grade master + salary range.
- `openAdd` / `openEdit` / `saveGrade` · `setSort` / `sortClass` · `categoryLabel` / `salaryRange` · `toggleAudit` · `closeModal`.

**Jobs** (`jobs`) — job master.
- `openAdd` / `openEdit` / `saveJob` · `select` · `toggleAudit` · `closeModal`.

**Locations** (`locations`) — location master.
- `openAdd` / `openEdit` / `saveLocation` · `select` · `typeClass` · `toggleAudit` · `closeModal`.

**Lookups** (`lookups`) — HR lookup categories + values.
- `openAddCategory` / `saveCategory` / `selectCategory` / `closeCatModal` · `openAdd` / `openEdit` / `saveValue` / `closeModal`.

## 7. Documents
**Documents** (`documents`) — org-wide document register with expiry alerts.
- `openDoc` · `setFilter` · `refresh` · `alertClass`.

## 8. Notifications
**Notifications** (`notifications`) — `markRead` / `markAll` · `typeClass`.

## 9. Configuration
**Module Settings** (`moduleSettings`) — module settings + region appearance.
- `saveAll` · `resetData`.

---

## API Endpoints (ORDS)

Module `hr.rest` · base path **`/ords/admin/hr/`** · defined in `final apps/HR/db/06_hr_ords.sql`.
All protected handlers call `dct_rest.validate_session`. **Shared `/dct/` calls:** only auth
(`auth/login`, `auth/logout`, session validation) and `GET boot` go to the Admin
`/ords/admin/dct/` module (via `authBase`). All other calls hit `/ords/admin/hr/`.

> ⚠️ **Known drift:** `hr.rest` defines **no notifications endpoints**, but `notificationService.js`
> (live branch) calls `GET /notifications/`, `PUT /notifications/:id/read`, `PUT /notifications/read-all`
> against the `/hr` base — these 404 in live mode. Either add HR notification handlers to
> `06_hr_ords.sql`, or route the service to `/dct` via `authBase` (and align to `dct`'s
> `PUT notifications/:id/read` + per-item mark-all, since `dct` has no `read-all`/`mark-all-read`).

| Area | Method & Path |
|---|---|
| Employees | `GET employees/` · `POST employees/` · `GET employees/:id` · `PUT employees/:id` · `PUT employees/:id/photo` |
| Org Hierarchy | `GET orgs/` · `POST orgs/` · `GET orgs/tree/` · `PUT orgs/:id` · `GET orgs/:id/positions/` |
| Positions | `GET positions/` · `POST positions/` · `GET positions/:id` · `PUT positions/:id` |
| Jobs & Grades | `GET jobs/` · `POST jobs/` · `PUT jobs/:id` · `GET job-families/` · `GET grades/` · `POST grades/` · `PUT grades/:code` |
| Locations | `GET locations/` · `POST locations/` · `PUT locations/:id` |
| Lookups | `GET lookups/` · `POST lookups/` · `POST lookups/category/` · `PUT lookups/category/:id` · `GET lookups/:category_code` · `PUT lookups/value/:id` · `GET doc-types/` |
| Assignments | `GET assignments/:person_id` · `POST assignments/` · `PUT assignments/:id/end/` |
| Contracts | `GET contracts/:person_id` · `POST contracts/` · `PUT contracts/update/:id` |
| Salary | `GET salary/:person_id` · `POST salary/` |
| Documents | `GET documents/:person_id` · `POST documents/` · `PUT documents/update/:id` · `PUT documents/file/:id` |
| Reports | `GET reports/headcount/` · `GET reports/expiry-alerts/` |
| Settings | `GET settings` · `PUT settings/:id` |

---

## Services / Data Layer (`js/services/`)

| Service | Responsibility |
|---|---|
| `api.js` | Bearer-token fetch wrapper; 401 → login. |
| `config.js` | `apiBase` toggle (mock vs `/ords/admin/hr`). |
| `authService` | login / session validate. |
| `hrService` | employees, positions, org, grades/jobs/locations, lookups, documents. |
| `notificationService` | notifications + count. |
