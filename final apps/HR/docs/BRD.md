# Business Requirements Document — HR Module (App 205)
**Version:** 1.0 | **Status:** DB Complete — APEX/JET pending | **Date:** 2026-06-06
**Schema:** PROD | **App ID:** 205 | **Module Code:** HR

---

## 1. Overview

The HR module is the central people-management system for the Finance Division. It stores and maintains the full employee lifecycle — from hire to separation — covering organisational structure, job architecture, position budgeting, assignments, contracts, salary history, and document management.

All other i-Finance modules (DT, PC, FL, CC) treat `DCT_EMPLOYEES` as their employee master. The HR module owns and maintains that table. It extends the platform with 8 new `HR_` tables and alters two existing platform tables (`DCT_ORGANIZATIONS`, `DCT_EMPLOYEES`).

---

## 2. Scope

| In Scope | Out of Scope |
|---|---|
| Organisation hierarchy | Payroll processing / ERP integration |
| Job families + job definitions | Leave management |
| Budgeted positions + headcount | Training management |
| Employee assignments (history) | Performance appraisal |
| Employment contracts | Recruitment |
| Salary history | Benefits / insurance |
| Employee personal documents | Time and attendance |

---

## 3. Roles

| Role Code | Description |
|---|---|
| `HR_ADMIN` | Full access — all employees, all orgs, salary, documents |
| `HR_MANAGER` | View/edit employees in own org unit; approve assignments |
| `HR_VIEWER` | Read-only access to org chart and employee directory |
| `EMPLOYEE` | View own profile, own documents, own assignment history |

---

## 4. Functions

| # | Function | Tables / Views |
|---|---|---|
| 1 | Organisation Management | `DCT_ORGANIZATIONS` (altered) |
| 2 | Location Management | `HR_LOCATIONS` |
| 3 | Job Architecture | `HR_JOB_FAMILIES`, `HR_JOBS` |
| 4 | Position Budgeting | `HR_POSITIONS`, `V_HR_HEADCOUNT` |
| 5 | Employee Directory | `DCT_EMPLOYEES` (altered), `V_HR_EMPLOYEE_FULL` |
| 6 | Assignments | `HR_EMPLOYEE_ASSIGNMENTS`, `V_HR_ORG_TREE` |
| 7 | Contracts | `HR_EMPLOYMENT_CONTRACTS`, `V_HR_ACTIVE_CONTRACTS` |
| 8 | Salary History | `HR_SALARY_HISTORY`, `V_HR_SALARY_CURRENT` |
| 9 | Document Management | `HR_EMPLOYEE_DOCUMENTS`, `V_HR_EXPIRING_DOCS` |

---

## 5. Data Model

### Platform Table Alterations

#### DCT_ORGANIZATIONS
The hard-coded `org_type` CHECK constraint (`DIVISION|SECTION|UNIT|DEPARTMENT`) is replaced by:
- `org_type_id NUMBER FK → DCT_LOOKUP_VALUES` (category: `HR_ORG_TYPE`)
- New lookup values support 9 org types: AUTHORITY, DIVISION, DEPARTMENT, SECTION, UNIT, TEAM, COMMITTEE, PROJECT_OFFICE, EXTERNAL
- Original `org_type VARCHAR2` column retained for backward compatibility
- Added: `location_id`, `headcount_ceiling`, `effective_from`, `effective_to`, `description_en/ar`, `cost_center_code`

#### DCT_EMPLOYEES
Added HR-specific columns:
- `position_id` — FK to `HR_POSITIONS` (current budgeted position)
- `location_id` — FK to `HR_LOCATIONS` (primary work location)
- `contract_id` — soft reference to active contract (no FK, application-enforced)
- `marital_status_id` — FK to lookup values (`HR_MARITAL_STATUS`)
- `personal_email`, `work_phone`, `photo_url`

### Two-Table Auth / HR Design
`DCT_USERS` = identity + access (username, auth, roles, sessions)
`DCT_EMPLOYEES` = person + employment (name, grade, org, dates, documents)
Linked via `DCT_USERS.person_id → DCT_EMPLOYEES.person_id`.

### New HR_ Tables

| Table | PK | Purpose |
|---|---|---|
| `HR_LOCATIONS` | `location_id` IDENTITY | Physical offices and sites |
| `HR_JOB_FAMILIES` | `job_family_id` IDENTITY | Job category groupings |
| `HR_JOBS` | `job_id` IDENTITY | Generic job definitions with grade range |
| `HR_POSITIONS` | `position_id` IDENTITY | Budgeted headcount slots per org + job |
| `HR_EMPLOYEE_ASSIGNMENTS` | `assignment_id` IDENTITY | Employee → position/org/grade over time |
| `HR_EMPLOYMENT_CONTRACTS` | `contract_id` IDENTITY | Employment contracts per employee |
| `HR_SALARY_HISTORY` | `salary_id` IDENTITY | Salary change events with delta calc |
| `HR_EMPLOYEE_DOCUMENTS` | `doc_id` IDENTITY | Official personal documents with expiry |

---

## 6. Key Business Rules

### Organisation
- Org type is driven by `HR_ORG_TYPE` lookup — admin can add new types without a schema change
- Hierarchy depth is unlimited (recursive `parent_org_id`)
- `headcount_ceiling` controls the maximum approved FTEs for any org node
- `effective_from / effective_to` support time-bounded org units (restructuring)

### Positions
- A position is a **budgeted slot** (org + job + grade + location)
- `approved_headcount` may be > 1 (shared roles)
- Vacancy = `approved_headcount - filled_count` (from `V_HR_HEADCOUNT`)
- `position_code` format: `POS-YYYY-NNNNN` (assigned by application)

### Assignments
- Every employee must have exactly **one** active PRIMARY assignment at any time
- Trigger `trg_hr_asgn_one_primary` enforces this at DB level
- `DCT_HR.ASSIGN_EMPLOYEE` automatically ends the previous primary before inserting
- Key employee fields (`org_id`, `grade_code`, `position_id`, `location_id`) are synced back to `DCT_EMPLOYEES` on every primary assignment change
- Assignment history is never deleted — `end_date` and `assignment_status = ENDED` close a row

### Salary
- Every salary change creates a new `HR_SALARY_HISTORY` row
- `previous_basic` and `change_percentage` are calculated automatically by `DCT_HR.UPDATE_SALARY`
- Current salary = most recent row per `person_id` (by `effective_date DESC`)

### Documents
- Document expiry is tracked via `V_HR_EXPIRING_DOCS` (90-day rolling window)
- `expiry_alert` classification: EXPIRED / CRITICAL (≤30d) / WARNING (≤60d) / UPCOMING (≤90d)
- `file_blob` stores the scan; download served via APEX page or ORDS binary endpoint
- `doc_status_id` from `HR_DOC_STATUS` lookup: VALID / EXPIRED / RENEWAL_IN_PROGRESS / CANCELLED

---

## 7. PL/SQL Package — `DCT_HR`

| Procedure / Function | Key Logic |
|---|---|
| `assign_employee` | Ends existing primary → inserts new assignment → syncs `DCT_EMPLOYEES` |
| `transfer_employee` | Wrapper calling `assign_employee` for org/position moves |
| `end_assignment` | Sets `end_date` + `assignment_status = ENDED` |
| `update_salary` | Fetches previous salary → calculates delta → inserts history row |
| `get_org_tree(p_root_org_id)` | Returns `SYS_REFCURSOR` of org hierarchy |
| `get_headcount_summary(p_org_id)` | Returns filled / vacant aggregates per org |
| `alert_expiring_docs(p_days_ahead)` | Returns docs expiring within N days |

---

## 8. Views

| View | Description |
|---|---|
| `V_HR_ORG_TREE` | Recursive CTE — level, full path, org type label, leaf flag, location |
| `V_HR_HEADCOUNT` | Positions with approved / filled / vacant counts |
| `V_HR_EMPLOYEE_FULL` | Complete employee profile (all dimensions, current assignment/contract/salary) |
| `V_HR_EXPIRING_DOCS` | Documents expiring in 90 days with alert classification |
| `V_HR_ACTIVE_CONTRACTS` | All contracts with days-until-expiry and probation flag |
| `V_HR_SALARY_CURRENT` | Latest salary row per employee with grade and approver |

---

## 9. ORDS Endpoints (`/ords/admin/hr/`)

| Method | Path | Description |
|---|---|---|
| GET | `/employees` | List with filters: `org_id`, `grade`, `active`, `q` |
| GET | `/employees/:id` | Full profile via `V_HR_EMPLOYEE_FULL` |
| POST | `/employees` | Create employee |
| PUT | `/employees/:id` | Update employee fields |
| GET | `/orgs` | Flat org list |
| GET | `/orgs/tree` | Hierarchy from `V_HR_ORG_TREE` |
| GET | `/orgs/:id/positions` | Positions in one org |
| GET | `/positions` | All positions with headcount |
| GET | `/positions/:id` | Single position |
| GET | `/jobs` | Job catalog |
| GET | `/job-families` | Job families |
| GET | `/locations` | Active locations |
| GET | `/assignments/:person_id` | Assignment history |
| POST | `/assignments` | Create assignment (calls `DCT_HR.ASSIGN_EMPLOYEE`) |
| PUT | `/assignments/:id/end` | End assignment |
| GET | `/contracts/:person_id` | Contract history |
| GET | `/salary/:person_id` | Salary history |
| GET | `/documents/:person_id` | Documents (no BLOB) |
| POST | `/documents` | Create document record |
| GET | `/reports/headcount` | Headcount by org |
| GET | `/reports/expiry-alerts` | Expiring documents |

---

## 10. JET SPA Pages

| Route | VM | Description |
|---|---|---|
| `dashboard` | `dashboard.js` | KPI: headcount, vacancies, expiring docs |
| `org-hierarchy` | `orgHierarchy.js` | Interactive tree + side panel |
| `employees` | `employees.js` | Searchable list |
| `employees/:id` | `employeeDetail.js` | Full profile: assignment, contract, salary, docs |
| `positions` | `positions.js` | Filled vs vacant by org |
| `jobs` | `jobs.js` | Job catalog + family |
| `locations` | `locations.js` | Location master |
| `documents` | `documents.js` | Expiry tracker |
| `module-settings` | `moduleSettings.js` | HR module settings |
| `notifications` | `notifications.js` | Shared notifications |

---

## 11. Lookup Categories Seeded

| Category Code | Values |
|---|---|
| `HR_ORG_TYPE` | AUTHORITY, DIVISION, DEPARTMENT, SECTION, UNIT, TEAM, COMMITTEE, PROJECT_OFFICE, EXTERNAL |
| `HR_LOCATION_TYPE` | HQ, BRANCH, REMOTE, FIELD, DATA_CENTER |
| `HR_POSITION_TYPE` | PERMANENT, TEMPORARY, SECONDMENT |
| `HR_ASSIGNMENT_TYPE` | PRIMARY, ACTING, SECONDMENT, DUAL |
| `HR_END_REASON` | TRANSFER, PROMOTION, LATERAL_TRANSFER, RESIGNATION, RETIREMENT, TERMINATION, CONTRACT_END, RESTRUCTURING |
| `HR_CONTRACT_TYPE` | PERMANENT, FIXED_TERM, SECONDMENT, INTERNSHIP, CONSULTANT |
| `HR_CONTRACT_STATUS` | ACTIVE, EXPIRED, TERMINATED, CANCELLED |
| `HR_SALARY_REASON` | HIRE, PROMOTION, ANNUAL_INCREMENT, MARKET_ADJUSTMENT, ACTING_ALLOWANCE, DEMOTION, CORRECTION |
| `HR_DOC_STATUS` | VALID, EXPIRED, RENEWAL_IN_PROGRESS, CANCELLED |
| `HR_MARITAL_STATUS` | SINGLE, MARRIED, DIVORCED, WIDOWED |

---

## 12. Build Order

```
db/v2/install.sql                  (prerequisite — platform)
db/v2/12_dct_master_data.sql       (prerequisite — employees, grades, countries)
     │
     ▼
final apps/HR/db/install.sql
  01_hr_ddl.sql
  02_hr_dct_alterations.sql
  03_hr_views.sql
  04_hr_seed.sql
  05_hr_pkg.sql
  06_hr_ords.sql
```

---

## 13. Next Steps

- [x] Run `install.sql` against PROD via SQLcl (`sql -name prod_mcp`)
- [x] Verify package `DCT_HR` compiles VALID in PROD schema
- [x] ORDS module `hr.rest` published at `/ords/admin/hr/`
- [ ] Populate `DCT_EMPLOYEES` with actual employee records
- [ ] Link `DCT_USERS` rows to `DCT_EMPLOYEES` via `person_id`
- [ ] Create positions for the Finance Division org units
- [ ] Build APEX App 205 pages using APEX Builder (per feedback: build in Builder first, then export)
- [ ] Build JET SPA views and wire to ORDS endpoints
