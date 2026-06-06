# HR Module — Full Database Reference
**Schema:** PROD | **Module:** HR (App 205) | **Date:** 2026-06-06

---

## 1. Tables Overview

| # | Table | PK | Rows (est.) | Purpose |
|---|---|---|---|---|
| 1 | `HR_LOCATIONS` | `location_id` IDENTITY | ~20 | Physical offices and sites |
| 2 | `HR_JOB_FAMILIES` | `job_family_id` IDENTITY | ~10 | Job category groups |
| 3 | `HR_JOBS` | `job_id` IDENTITY | ~50 | Generic job definitions |
| 4 | `HR_POSITIONS` | `position_id` IDENTITY | ~100 | Budgeted headcount slots |
| 5 | `HR_EMPLOYEE_ASSIGNMENTS` | `assignment_id` IDENTITY | ~500 | Employee → position/org history |
| 6 | `HR_EMPLOYMENT_CONTRACTS` | `contract_id` IDENTITY | ~200 | Employment contracts |
| 7 | `HR_SALARY_HISTORY` | `salary_id` IDENTITY | ~500 | Salary change events |
| 8 | `HR_EMPLOYEE_DOCUMENTS` | `doc_id` IDENTITY | ~400 | Personal documents with expiry |

**Platform tables altered by this module:**
- `DCT_ORGANIZATIONS` — org type moved to lookup + new HR columns added
- `DCT_EMPLOYEES` — position, location, contract, marital status, photo added

---

## 2. HR_LOCATIONS

Physical offices and sites. Referenced by `DCT_ORGANIZATIONS`, `HR_POSITIONS`, and `HR_EMPLOYEE_ASSIGNMENTS`.

| Column | Type | Nullable | Default | Description |
|---|---|---|---|---|
| `location_id` | NUMBER | NOT NULL | IDENTITY | PK |
| `location_code` | VARCHAR2(50) | NOT NULL | — | Unique site code (e.g., `HQ-ABU`) |
| `location_name_en` | VARCHAR2(200) | NOT NULL | — | English name |
| `location_name_ar` | VARCHAR2(200) | NULL | — | Arabic name |
| `location_type_id` | NUMBER | NULL | — | FK → `DCT_LOOKUP_VALUES` (cat: `HR_LOCATION_TYPE`) |
| `org_id` | NUMBER | NULL | — | FK → `DCT_ORGANIZATIONS` (owning org unit) |
| `country_code` | VARCHAR2(3) | NULL | — | FK → `DCT_COUNTRIES` |
| `emirate` | VARCHAR2(50) | NULL | — | UAE emirate name |
| `city` | VARCHAR2(100) | NULL | — | City |
| `area` | VARCHAR2(100) | NULL | — | District / neighbourhood |
| `building_name` | VARCHAR2(200) | NULL | — | Building |
| `floor_no` | VARCHAR2(20) | NULL | — | Floor |
| `po_box` | VARCHAR2(20) | NULL | — | PO Box |
| `zip_code` | VARCHAR2(20) | NULL | — | Postal code |
| `google_maps_url` | VARCHAR2(1000) | NULL | — | Maps link |
| `is_active` | VARCHAR2(1) | NOT NULL | `'Y'` | `Y`/`N` |
| `display_order` | NUMBER | NULL | `0` | Sort order |
| `created_by` | VARCHAR2(100) | NULL | — | Audit |
| `created_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Audit |
| `updated_by` | VARCHAR2(100) | NULL | — | Audit |
| `updated_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Auto-maintained by trigger |

**Constraints:** `uq_hr_loc_code (location_code)`, `chk_hr_loc_active (is_active IN ('Y','N'))`,
`fk_hr_loc_type → DCT_LOOKUP_VALUES`, `fk_hr_loc_org → DCT_ORGANIZATIONS`, `fk_hr_loc_country → DCT_COUNTRIES`

**Indexes:** `ix_hr_loc_org (org_id)`, `ix_hr_loc_country (country_code)`, `ix_hr_loc_active (is_active)`

**Trigger:** `trg_hr_loc_upd` — auto-sets `updated_at` + `updated_by` on every UPDATE

---

## 3. HR_JOB_FAMILIES

Groups related jobs (Finance, IT, HR, Legal, Operations …). No external FKs.

| Column | Type | Nullable | Default | Description |
|---|---|---|---|---|
| `job_family_id` | NUMBER | NOT NULL | IDENTITY | PK |
| `family_code` | VARCHAR2(50) | NOT NULL | — | Unique code (e.g., `FIN`) |
| `family_name_en` | VARCHAR2(200) | NOT NULL | — | English name |
| `family_name_ar` | VARCHAR2(200) | NULL | — | Arabic name |
| `description_en` | VARCHAR2(500) | NULL | — | Description |
| `is_active` | VARCHAR2(1) | NOT NULL | `'Y'` | `Y`/`N` |
| `display_order` | NUMBER | NULL | `0` | Sort order |
| `created_by` | VARCHAR2(100) | NULL | — | Audit |
| `created_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Audit |
| `updated_by` | VARCHAR2(100) | NULL | — | Audit |
| `updated_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Auto-maintained by trigger |

**Constraints:** `uq_hr_jf_code (family_code)`, `chk_hr_jf_active (is_active IN ('Y','N'))`

**Seeded:** Finance, HR & Administration, IT & Systems, Legal & Compliance, Operations & Facilities, Risk & Audit

---

## 4. HR_JOBS

Generic job definitions. One job (e.g., "Financial Analyst") can fill many positions.
Grade range (min/max) defines the span allowed for this job.

| Column | Type | Nullable | Default | Description |
|---|---|---|---|---|
| `job_id` | NUMBER | NOT NULL | IDENTITY | PK |
| `job_code` | VARCHAR2(50) | NOT NULL | — | Unique code (e.g., `FIN-ANLT`) |
| `job_name_en` | VARCHAR2(200) | NOT NULL | — | English title |
| `job_name_ar` | VARCHAR2(200) | NULL | — | Arabic title |
| `job_family_id` | NUMBER | NULL | — | FK → `HR_JOB_FAMILIES` |
| `min_grade_code` | VARCHAR2(20) | NULL | — | FK → `DCT_EMPLOYEE_GRADES` (lowest eligible grade) |
| `max_grade_code` | VARCHAR2(20) | NULL | — | FK → `DCT_EMPLOYEE_GRADES` (highest eligible grade) |
| `description_en` | VARCHAR2(2000) | NULL | — | English description |
| `description_ar` | VARCHAR2(2000) | NULL | — | Arabic description |
| `key_responsibilities` | CLOB | NULL | — | Bullet points or JSON |
| `min_experience_years` | NUMBER | NULL | — | Minimum years of experience |
| `required_qualification_id` | NUMBER | NULL | — | FK → `DCT_LOOKUP_VALUES` (HR_QUALIFICATION) |
| `is_active` | VARCHAR2(1) | NOT NULL | `'Y'` | `Y`/`N` |
| `effective_from` | DATE | NULL | — | Job definition activation date |
| `effective_to` | DATE | NULL | — | Job definition end date |
| `created_by` | VARCHAR2(100) | NULL | — | Audit |
| `created_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Audit |
| `updated_by` | VARCHAR2(100) | NULL | — | Audit |
| `updated_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Auto-maintained by trigger |

**Constraints:** `uq_hr_job_code`, `chk_hr_job_active`, `chk_hr_job_dates (effective_to >= effective_from)`,
`fk_hr_job_family → HR_JOB_FAMILIES`, `fk_hr_job_mingrade → DCT_EMPLOYEE_GRADES`,
`fk_hr_job_maxgrade → DCT_EMPLOYEE_GRADES`, `fk_hr_job_qual → DCT_LOOKUP_VALUES`

**Indexes:** `ix_hr_job_family (job_family_id)`, `ix_hr_job_active (is_active, effective_from, effective_to)`

**Seeded (17 jobs):** CFO / Finance Director, Payables Manager, Budget Manager, Revenue Assurance Manager, Receivables Manager,
Financial Analyst, Senior Financial Analyst, Accounts Payable Specialist, Accounts Receivable Specialist,
Budget Analyst, Revenue Analyst, Payroll Specialist, Treasury Analyst, Financial Controller,
Financial Auditor, Risk Analyst, Finance Systems Administrator

---

## 5. HR_POSITIONS

Budgeted headcount slots: one org unit + one job + one grade + one location.
`approved_headcount` > filled count = vacancy (computed in `V_HR_HEADCOUNT`).

| Column | Type | Nullable | Default | Description |
|---|---|---|---|---|
| `position_id` | NUMBER | NOT NULL | IDENTITY | PK |
| `position_code` | VARCHAR2(50) | NOT NULL | — | Unique code — format `POS-YYYY-NNNNN` |
| `position_name_en` | VARCHAR2(300) | NOT NULL | — | English title |
| `position_name_ar` | VARCHAR2(300) | NULL | — | Arabic title |
| `job_id` | NUMBER | NOT NULL | — | FK → `HR_JOBS` |
| `org_id` | NUMBER | NOT NULL | — | FK → `DCT_ORGANIZATIONS` |
| `location_id` | NUMBER | NULL | — | FK → `HR_LOCATIONS` (NULL = inherit from org) |
| `grade_code` | VARCHAR2(20) | NULL | — | FK → `DCT_EMPLOYEE_GRADES` (approved grade) |
| `approved_headcount` | NUMBER | NOT NULL | `1` | Budget approved headcount |
| `position_type_id` | NUMBER | NULL | — | FK → `DCT_LOOKUP_VALUES` (cat: `HR_POSITION_TYPE`) |
| `is_active` | VARCHAR2(1) | NOT NULL | `'Y'` | `Y`/`N` |
| `effective_from` | DATE | NOT NULL | — | Position activation date |
| `effective_to` | DATE | NULL | — | Position end date |
| `description_en` | VARCHAR2(500) | NULL | — | Description |
| `created_by` | VARCHAR2(100) | NULL | — | Audit |
| `created_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Audit |
| `updated_by` | VARCHAR2(100) | NULL | — | Audit |
| `updated_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Auto-maintained by trigger |

**Constraints:** `uq_hr_pos_code`, `chk_hr_pos_active`, `chk_hr_pos_hc (approved_headcount > 0)`,
`chk_hr_pos_dates (effective_to >= effective_from)`, `fk_hr_pos_job → HR_JOBS`,
`fk_hr_pos_org → DCT_ORGANIZATIONS`, `fk_hr_pos_loc → HR_LOCATIONS`,
`fk_hr_pos_grade → DCT_EMPLOYEE_GRADES`, `fk_hr_pos_type → DCT_LOOKUP_VALUES`

**Indexes:** `ix_hr_pos_job (job_id)`, `ix_hr_pos_org (org_id)`, `ix_hr_pos_grade (grade_code)`,
`ix_hr_pos_active (is_active, effective_from, effective_to)`

---

## 6. HR_EMPLOYEE_ASSIGNMENTS

Core assignment: employee → position → org → grade → location at a point in time.
All history is kept; `end_date` marks the end. One ACTIVE PRIMARY per person enforced by trigger.

| Column | Type | Nullable | Default | Description |
|---|---|---|---|---|
| `assignment_id` | NUMBER | NOT NULL | IDENTITY | PK |
| `assignment_number` | VARCHAR2(30) | NOT NULL | — | Unique — format `ASGN-YYYY-NNNNN` (generated by `DCT_HR.ASSIGN_EMPLOYEE`) |
| `person_id` | NUMBER | NOT NULL | — | FK → `DCT_EMPLOYEES` |
| `position_id` | NUMBER | NULL | — | FK → `HR_POSITIONS` (NULL allowed for acting/legacy) |
| `job_id` | NUMBER | NULL | — | FK → `HR_JOBS` (snapped at assignment time) |
| `org_id` | NUMBER | NOT NULL | — | FK → `DCT_ORGANIZATIONS` |
| `grade_code` | VARCHAR2(20) | NULL | — | FK → `DCT_EMPLOYEE_GRADES` (effective grade) |
| `location_id` | NUMBER | NULL | — | FK → `HR_LOCATIONS` |
| `assignment_type_id` | NUMBER | NULL | — | FK → `DCT_LOOKUP_VALUES` (cat: `HR_ASSIGNMENT_TYPE`) |
| `assignment_status` | VARCHAR2(20) | NOT NULL | `'ACTIVE'` | `ACTIVE` / `ENDED` / `SUSPENDED` |
| `start_date` | DATE | NOT NULL | — | Assignment start |
| `end_date` | DATE | NULL | — | Assignment end (NULL = open) |
| `end_reason_id` | NUMBER | NULL | — | FK → `DCT_LOOKUP_VALUES` (cat: `HR_END_REASON`) |
| `is_primary` | VARCHAR2(1) | NOT NULL | `'Y'` | `Y`/`N` — only one `Y+ACTIVE+end_date IS NULL` per person |
| `probation_end_date` | DATE | NULL | — | Set from probation months at assignment time |
| `manager_person_id` | NUMBER | NULL | — | FK → `DCT_EMPLOYEES` (direct manager at time of assignment) |
| `remarks` | VARCHAR2(1000) | NULL | — | Free text |
| `created_by` | VARCHAR2(100) | NULL | — | Audit |
| `created_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Audit |
| `updated_by` | VARCHAR2(100) | NULL | — | Audit |
| `updated_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Auto-maintained by trigger |

**Constraints:** `uq_hr_asgn_number`, `chk_hr_asgn_status (ACTIVE/ENDED/SUSPENDED)`,
`chk_hr_asgn_prim (Y/N)`, `chk_hr_asgn_dates (end_date >= start_date)`,
FKs to `DCT_EMPLOYEES`, `HR_POSITIONS`, `HR_JOBS`, `DCT_ORGANIZATIONS`, `DCT_EMPLOYEE_GRADES`,
`HR_LOCATIONS`, `DCT_LOOKUP_VALUES (×2)`, `DCT_EMPLOYEES (manager_person_id)`

**Indexes:** `ix_hr_asgn_person (person_id)`, `ix_hr_asgn_pos (position_id)`,
`ix_hr_asgn_org (org_id)`, `ix_hr_asgn_status (assignment_status, is_primary, end_date)`,
`ix_hr_asgn_dates (start_date, end_date)`

**Triggers:**
- `trg_hr_asgn_one_primary` — BEFORE INSERT OR UPDATE — raises `-20100` if inserting a second ACTIVE PRIMARY for the same `person_id`
- `trg_hr_asgn_upd` — BEFORE UPDATE — auto-sets `updated_at / updated_by`

---

## 7. HR_EMPLOYMENT_CONTRACTS

One row per contract period. Renewal creates a new row; previous row gets `contract_status = EXPIRED`.

| Column | Type | Nullable | Default | Description |
|---|---|---|---|---|
| `contract_id` | NUMBER | NOT NULL | IDENTITY | PK |
| `contract_number` | VARCHAR2(50) | NOT NULL | — | Unique HR-issued contract number |
| `person_id` | NUMBER | NOT NULL | — | FK → `DCT_EMPLOYEES` |
| `contract_type_id` | NUMBER | NOT NULL | — | FK → `DCT_LOOKUP_VALUES` (cat: `HR_CONTRACT_TYPE`) |
| `start_date` | DATE | NOT NULL | — | Contract start |
| `end_date` | DATE | NULL | — | Contract end (NULL = permanent / indefinite) |
| `probation_months` | NUMBER | NULL | `3` | Probation period in months |
| `probation_end_date` | DATE | NULL | — | Calculated at insert: `ADD_MONTHS(start_date, probation_months)` |
| `notice_period_days` | NUMBER | NULL | `30` | Notice period in calendar days |
| `contract_status_id` | NUMBER | NULL | — | FK → `DCT_LOOKUP_VALUES` (cat: `HR_CONTRACT_STATUS`) |
| `signed_date` | DATE | NULL | — | Date employee signed the contract |
| `file_url` | VARCHAR2(1000) | NULL | — | Link to scanned contract document |
| `remarks` | VARCHAR2(1000) | NULL | — | Free text |
| `created_by` | VARCHAR2(100) | NULL | — | Audit |
| `created_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Audit |
| `updated_by` | VARCHAR2(100) | NULL | — | Audit |
| `updated_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Auto-maintained by trigger |

**Constraints:** `uq_hr_contract_number`, `chk_hr_contract_dates`, `chk_hr_contract_prob`,
`chk_hr_contract_ntc`, FKs to `DCT_EMPLOYEES`, `DCT_LOOKUP_VALUES (×2)`

**Indexes:** `ix_hr_contract_person (person_id)`, `ix_hr_contract_status (contract_status_id, end_date)`,
`ix_hr_contract_dates (start_date, end_date)`

---

## 8. HR_SALARY_HISTORY

One row per salary change event (hire, promotion, annual increment …).
Most recent row per `person_id` = current salary (`V_HR_SALARY_CURRENT`).

| Column | Type | Nullable | Default | Description |
|---|---|---|---|---|
| `salary_id` | NUMBER | NOT NULL | IDENTITY | PK |
| `person_id` | NUMBER | NOT NULL | — | FK → `DCT_EMPLOYEES` |
| `effective_date` | DATE | NOT NULL | — | Date the new salary takes effect |
| `basic_salary` | NUMBER(15,2) | NOT NULL | — | Basic salary (must be > 0) |
| `currency_code` | VARCHAR2(3) | NOT NULL | `'AED'` | FK → `DCT_CURRENCY_CODES` |
| `change_reason_id` | NUMBER | NULL | — | FK → `DCT_LOOKUP_VALUES` (cat: `HR_SALARY_REASON`) |
| `previous_basic` | NUMBER(15,2) | NULL | — | Snapped from prior row by `DCT_HR.UPDATE_SALARY` |
| `change_percentage` | NUMBER(6,2) | NULL | — | `((new - old) / old) × 100` — auto-calculated |
| `approved_by` | NUMBER | NULL | — | FK → `DCT_USERS` |
| `remarks` | VARCHAR2(500) | NULL | — | Free text |
| `created_by` | VARCHAR2(100) | NULL | — | Audit |
| `created_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Audit |
| `updated_by` | VARCHAR2(100) | NULL | — | Audit |
| `updated_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Auto-maintained by trigger |

**Constraints:** `chk_hr_sal_amount (basic_salary > 0)`, FKs to `DCT_EMPLOYEES`,
`DCT_CURRENCY_CODES`, `DCT_LOOKUP_VALUES`, `DCT_USERS`

**Indexes:** `ix_hr_sal_person (person_id, effective_date DESC)`, `ix_hr_sal_date (effective_date)`

---

## 9. HR_EMPLOYEE_DOCUMENTS

Official personal documents per employee (passport, Emirates ID, visa, NOC …).
Expiry tracked via `V_HR_EXPIRING_DOCS`. BLOB stores the scan.

| Column | Type | Nullable | Default | Description |
|---|---|---|---|---|
| `doc_id` | NUMBER | NOT NULL | IDENTITY | PK |
| `person_id` | NUMBER | NOT NULL | — | FK → `DCT_EMPLOYEES` |
| `doc_type_id` | NUMBER | NOT NULL | — | FK → `DCT_DOCUMENT_TYPES` |
| `doc_number` | VARCHAR2(100) | NULL | — | Passport number, Emirates ID number … |
| `issue_date` | DATE | NULL | — | Issue date |
| `expiry_date` | DATE | NULL | — | Expiry date (NULL = no expiry) |
| `issuing_authority` | VARCHAR2(200) | NULL | — | Issuing body name |
| `issuing_country_code` | VARCHAR2(3) | NULL | — | FK → `DCT_COUNTRIES` |
| `doc_status_id` | NUMBER | NULL | — | FK → `DCT_LOOKUP_VALUES` (cat: `HR_DOC_STATUS`) |
| `file_blob` | BLOB | NULL | — | Scanned document binary |
| `file_name` | VARCHAR2(500) | NULL | — | Original file name |
| `file_mime_type` | VARCHAR2(100) | NULL | — | MIME type (e.g., `application/pdf`) |
| `notes` | VARCHAR2(500) | NULL | — | Free text |
| `created_by` | VARCHAR2(100) | NULL | — | Audit |
| `created_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Audit |
| `updated_by` | VARCHAR2(100) | NULL | — | Audit |
| `updated_at` | TIMESTAMP | NOT NULL | SYSTIMESTAMP | Auto-maintained by trigger |

**Constraints:** `chk_hr_doc_dates (expiry_date >= issue_date)`, FKs to `DCT_EMPLOYEES`,
`DCT_DOCUMENT_TYPES`, `DCT_COUNTRIES`, `DCT_LOOKUP_VALUES`

**Indexes:** `ix_hr_doc_person (person_id)`, `ix_hr_doc_type (doc_type_id)`,
`ix_hr_doc_expiry (person_id, doc_type_id, expiry_date)`, `ix_hr_doc_status (doc_status_id)`

---

## 10. Platform Table Alterations

### DCT_ORGANIZATIONS — Added Columns

| Column | Type | Description |
|---|---|---|
| `org_type_id` | NUMBER | FK → `DCT_LOOKUP_VALUES` (cat: `HR_ORG_TYPE`). Replaces the hard-coded CHECK constraint. |
| `location_id` | NUMBER | FK → `HR_LOCATIONS` — primary site for this org unit |
| `headcount_ceiling` | NUMBER | Maximum approved FTEs for this node |
| `effective_from` | DATE | Org unit activation date |
| `effective_to` | DATE | Org unit end date (NULL = active) |
| `description_en` | VARCHAR2(500) | English description |
| `description_ar` | VARCHAR2(500) | Arabic description |
| `cost_center_code` | VARCHAR2(20) | Soft link to GL cost center |

**Dropped:** `chk_dct_org_type CHECK (org_type IN ('DIVISION','SECTION','UNIT','DEPARTMENT'))` — replaced by lookup

**New indexes:** `ix_dct_org_type_lv`, `ix_dct_org_location`, `ix_dct_org_eff`

### DCT_EMPLOYEES — Added Columns

| Column | Type | Description |
|---|---|---|
| `position_id` | NUMBER | FK → `HR_POSITIONS` — current budgeted position (synced by `DCT_HR.ASSIGN_EMPLOYEE`) |
| `location_id` | NUMBER | FK → `HR_LOCATIONS` — primary work location |
| `contract_id` | NUMBER | Soft reference to active `HR_EMPLOYMENT_CONTRACTS` row (no FK — application-maintained) |
| `marital_status_id` | NUMBER | FK → `DCT_LOOKUP_VALUES` (cat: `HR_MARITAL_STATUS`) |
| `personal_email` | VARCHAR2(255) | Non-work email |
| `work_phone` | VARCHAR2(20) | Office extension |
| `photo_url` | VARCHAR2(500) | Profile photo (OCI Object Storage or APEX) |

---

## 11. Views

### V_HR_ORG_TREE
Recursive CTE walking `DCT_ORGANIZATIONS`. Returns every node with level, full path, org type label, leaf flag.

**Key columns:** `org_id`, `org_code`, `org_name_en/ar`, `org_type`, `org_type_id`, `org_type_label`,
`parent_org_id`, `level_no`, `full_path`, `is_active`, `headcount_ceiling`, `location_id`,
`location_name_en`, `cost_center_code`, `effective_from`, `effective_to`, `is_leaf` (`Y`/`N`)

---

### V_HR_HEADCOUNT
One row per active position. Computes filled vs. vacant.

**Key columns:** `position_id`, `position_code`, `position_name_en/ar`, `org_id`, `org_name_en/ar`,
`job_id`, `job_name_en`, `job_family`, `grade_code`, `grade_name_en`,
`approved_headcount`, `filled_count`, `vacancy_count`, `position_type`, `effective_from/to`, `location`

**Logic:** `filled_count` = COUNT(assignments WHERE status=ACTIVE AND is_primary=Y AND end_date IS NULL)
`vacancy_count` = `approved_headcount - filled_count`

---

### V_HR_EMPLOYEE_FULL
Complete employee profile joining all HR dimensions. Current assignment, most recent contract, most recent salary.

**Key columns:** All `DCT_EMPLOYEES` fields + grade name/category/level, nationality, marital status,
org name, current assignment details (position, job, job family, assignment type, location, manager),
primary location, current contract (number, type, status, dates, probation),
current salary (basic, currency, effective date)

---

### V_HR_EXPIRING_DOCS
Documents expiring within 90 days (or already expired), active employees only.

**Key columns:** `doc_id`, `person_id`, `employee_number`, `full_name_en`, `email`, `org_name_en`,
`doc_type`, `doc_category`, `doc_number`, `issue_date`, `expiry_date`, `days_until_expiry`,
`expiry_alert` (`EXPIRED` / `CRITICAL` ≤30d / `WARNING` ≤60d / `UPCOMING` ≤90d),
`doc_status`, `issuing_authority`, `issuing_country`

---

### V_HR_ACTIVE_CONTRACTS
All employment contracts for active employees, with days-until-expiry and probation status.

**Key columns:** `contract_id`, `contract_number`, `person_id`, `employee_number`, `full_name_en/ar`,
`org_name_en`, `contract_type`, `contract_status`, `start_date`, `end_date`, `days_until_expiry`,
`probation_months`, `probation_end_date`, `in_probation` (`Y`/`N`), `notice_period_days`, `signed_date`

---

### V_HR_SALARY_CURRENT
Most recent salary row per employee (by `effective_date DESC, salary_id DESC`).

**Key columns:** `salary_id`, `person_id`, `employee_number`, `full_name_en/ar`, `org_name_en`,
`grade_code`, `grade_name_en`, `grade_category`, `basic_salary`, `currency_code`,
`effective_date`, `change_reason`, `previous_basic`, `change_percentage`, `approved_by_name`

---

## 12. PL/SQL Package — DCT_HR

```sql
-- All procedures/functions are in PROD.DCT_HR (package + body both required)
```

### assign_employee (procedure)
Creates a new `HR_EMPLOYEE_ASSIGNMENTS` row. Automatically ends existing primary before inserting.
Syncs `DCT_EMPLOYEES.org_id / grade_code / position_id / location_id / manager_person_id`.

```
p_person_id          IN NUMBER
p_position_id        IN NUMBER DEFAULT NULL
p_job_id             IN NUMBER DEFAULT NULL
p_org_id             IN NUMBER                 ← REQUIRED
p_grade_code         IN VARCHAR2 DEFAULT NULL
p_location_id        IN NUMBER DEFAULT NULL
p_assignment_type_id IN NUMBER DEFAULT NULL
p_start_date         IN DATE DEFAULT TRUNC(SYSDATE)
p_probation_months   IN NUMBER DEFAULT NULL
p_manager_person_id  IN NUMBER DEFAULT NULL
p_is_primary         IN VARCHAR2 DEFAULT 'Y'
p_remarks            IN VARCHAR2 DEFAULT NULL
p_assignment_id      OUT NUMBER                ← new assignment_id
```

### transfer_employee (procedure)
Wrapper calling `assign_employee`. Ends current primary with reason `TRANSFER`.

### end_assignment (procedure)
Sets `end_date + assignment_status = ENDED`. Raises `-20101` if assignment not found.

```
p_assignment_id IN NUMBER
p_end_date      IN DATE DEFAULT TRUNC(SYSDATE)
p_end_reason_id IN NUMBER DEFAULT NULL
p_remarks       IN VARCHAR2 DEFAULT NULL
```

### update_salary (procedure)
Inserts `HR_SALARY_HISTORY`. Auto-calculates `previous_basic` and `change_percentage`.

```
p_person_id        IN NUMBER
p_basic_salary     IN NUMBER
p_effective_date   IN DATE DEFAULT TRUNC(SYSDATE)
p_currency_code    IN VARCHAR2 DEFAULT 'AED'
p_change_reason_id IN NUMBER DEFAULT NULL
p_approved_by      IN NUMBER DEFAULT NULL
p_remarks          IN VARCHAR2 DEFAULT NULL
p_salary_id        OUT NUMBER
```

### get_org_tree (function → SYS_REFCURSOR)
Returns org hierarchy from `V_HR_ORG_TREE`, optionally rooted at `p_root_org_id`.

### get_headcount_summary (function → SYS_REFCURSOR)
Returns filled/vacant aggregates from `V_HR_HEADCOUNT`, optionally for one org + descendants.

### alert_expiring_docs (function → SYS_REFCURSOR)
Returns documents expiring within `p_days_ahead` days from `V_HR_EXPIRING_DOCS`.

---

## 13. ORDS Endpoints

**Base URL:** `/ords/admin/hr/`
**Module name:** `hr.rest` (defined in ADMIN schema)
**ADMIN synonyms:** All `HR_*` tables, `V_HR_*` views, and platform objects created in ADMIN.

| Method | Path | Source | Description |
|---|---|---|---|
| GET | `/employees/` | `V_HR_EMPLOYEE_FULL` join | List — filters: `org_id`, `grade`, `active`, `q` |
| GET | `/employees/:id` | `V_HR_EMPLOYEE_FULL` | Full profile (one row) |
| POST | `/employees/` | PL/SQL INSERT | Create employee in `DCT_EMPLOYEES` |
| PUT | `/employees/:id` | PL/SQL UPDATE | Update employee fields |
| GET | `/orgs/` | `DCT_ORGANIZATIONS` join | Flat org list — filter: `is_active` |
| GET | `/orgs/tree/` | `V_HR_ORG_TREE` | Full hierarchy sorted by `full_path` |
| GET | `/orgs/:id/positions/` | `V_HR_HEADCOUNT` | Positions in one org |
| GET | `/positions/` | `V_HR_HEADCOUNT` | All positions — filter: `org_id` |
| GET | `/positions/:id` | `V_HR_HEADCOUNT` | Single position |
| GET | `/jobs/` | `HR_JOBS` join | Job catalog — filters: `family_id`, `is_active` |
| GET | `/job-families/` | `HR_JOB_FAMILIES` | Job families — filter: `is_active` |
| GET | `/locations/` | `HR_LOCATIONS` join | Active locations — filter: `is_active` |
| GET | `/assignments/:person_id` | `HR_EMPLOYEE_ASSIGNMENTS` join | Assignment history |
| POST | `/assignments/` | `DCT_HR.ASSIGN_EMPLOYEE` | Create assignment |
| PUT | `/assignments/:id/end/` | `DCT_HR.END_ASSIGNMENT` | End assignment |
| GET | `/contracts/:person_id` | `V_HR_ACTIVE_CONTRACTS` | Contract history |
| GET | `/salary/:person_id` | `HR_SALARY_HISTORY` join | Salary history |
| GET | `/documents/:person_id` | `HR_EMPLOYEE_DOCUMENTS` join | Documents (no BLOB) |
| POST | `/documents/` | PL/SQL INSERT | Create document record |
| GET | `/reports/headcount/` | `V_HR_HEADCOUNT` aggregate | Headcount by org |
| GET | `/reports/expiry-alerts/` | `V_HR_EXPIRING_DOCS` | Expiring documents ≤ `?days` |

---

## 14. Lookup Categories (seeded by 04_hr_seed.sql)

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

## 15. Install Order

```
db/v2/install.sql                    (platform prerequisite)
db/v2/12_dct_master_data.sql         (employees, grades, countries)
        │
        ▼
final apps/HR/db/install.sql
  01_hr_ddl.sql                      tables + indexes + triggers
  02_hr_dct_alterations.sql          platform table alterations
  03_hr_views.sql                    6 views
  04_hr_seed.sql                     lookup + locations + jobs
  05_hr_pkg.sql                      DCT_HR package (spec + body)
  06_hr_ords.sql                     ADMIN synonyms + ORDS module hr.rest
```
