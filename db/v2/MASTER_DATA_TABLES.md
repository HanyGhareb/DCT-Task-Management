# Master Data / Reference Tables — State as of 2026-05-19

**Script:** `db/v2/12_dct_master_data.sql`  
**Schema:** PROD (Oracle AI Database 26ai)  
**Status:** Deployed and committed

---

## Tables Deployed

| Table | PK | Rows | Purpose |
|---|---|---|---|
| `DCT_EMPLOYEE_GRADES` | `grade_code` VARCHAR2 | 11 | Grade master (E1-E4, P1-P3, T1-T2, S1-S2) |
| `DCT_GL_CODE_COMBINATIONS` | `cc_id` IDENTITY | 12 | 9-segment chart of accounts (see below) |
| `DCT_COUNTRIES` | `country_code` VARCHAR2 | 70 | ISO 3166-1 country master |
| `DCT_NATIONALITY` | `nationality_code` VARCHAR2 | 34 | Nationality reference |
| `DCT_EMPLOYEES` | `person_id` IDENTITY | 0 | HR employee master |
| `DCT_PROJECTS` | `project_id` IDENTITY | 0 | Project master for budget coding |
| `DCT_PROJECT_TASKS` | `task_id` IDENTITY | 0 | WBS task codes within projects |
| `DCT_EXPENDITURE_TYPES` | `exp_type_id` IDENTITY | 20 | Expenditure category reference |
| `DCT_DOCUMENT_TYPES` | `doc_type_id` IDENTITY | 18 | Document type master (DT, FL, PC, CC modules) |
| `DCT_CURRENCY_CODES` | `currency_code` VARCHAR2 | 20 | ISO 4217 currency reference |
| `DCT_BANK_CODES` | `bank_code` VARCHAR2 | 15 | UAE bank reference |

---

## DCT_GL_CODE_COMBINATIONS — 9-Segment Design

Each GL combination stores a code and description for all 9 segments:

| Seg | Column (code / desc) | Width | Constraint |
|---|---|---|---|
| 1 | `entity_code` / `entity_desc` | 3 / 255 | NOT NULL |
| 2 | `program_code` / `program_desc` | 6 / 255 | NOT NULL |
| 3 | `cost_center_code` / `cost_center_desc` | 7 / 255 | NOT NULL |
| 4 | `budget_group_code` / `budget_group_desc` | 1 / 255 | NOT NULL |
| 5 | `account_code` / `account_desc` | 6 / 255 | NOT NULL |
| 6 | `entity_specific_code` / `entity_specific_desc` | 7 / 255 | DEFAULT `'0000000'` |
| 7 | `appropriation_code` / `appropriation_desc` | 6 / 255 | NOT NULL |
| 8 | `future1_code` / `future1_desc` | 6 / 255 | DEFAULT `'000000'` |
| 9 | `future2_code` / `future2_desc` | 6 / 255 | DEFAULT `'000000'` |

`cc_code` is a **virtual column** computed as: `S1.S2.S3.S4.S5.S6.S7.S8.S9`  
Example: `001.100000.1010001.2.520100.0000000.202600.000000.000000`

UNIQUE constraint is on the 9 segment codes. `cc_id` is the FK target for all module tables.

---

## FK Wires Added (ENABLE NOVALIDATE)

Existing module tables now have FK constraints pointing to the new master tables:

| Module table | Column | → References |
|---|---|---|
| `dct_users` | `person_id` | `dct_employees.person_id` |
| `dct_fl_registrations` | `nationality_code` | `dct_nationality` |
| `dct_fl_freelancers` | `nationality_code` | `dct_nationality` |
| `dt_country_groups` | `country_code` | `dct_countries` |
| `dt_destinations` | `country_code` | `dct_countries` |
| `dt_requests` | `cc_id_gl` | `dct_gl_code_combinations` |
| `dt_doc_requirements` | `document_type_id` | `dct_document_types` |
| `dt_documents` | `document_type_id` | `dct_document_types` |

---

## Seed Data Summary

| Table | Seed highlights |
|---|---|
| DCT_EMPLOYEE_GRADES | E1–E4 (Executive), P1–P3 (Professional), T1–T2 (Technical), S1–S2 (Support) |
| DCT_COUNTRIES | GCC, Arab League, Europe, Asia-Pacific, Americas, Africa (70 ISO codes) |
| DCT_NATIONALITY | GCC + Arab + South/SE Asian + Western nationalities (34) |
| DCT_CURRENCY_CODES | AED, USD, GBP, EUR + GCC + 15 others with indicative AED rates |
| DCT_BANK_CODES | FAB, ADCB, ENBD, ADIB, DIB, Mashreq + 9 more UAE banks |
| DCT_EXPENDITURE_TYPES | PERSONNEL, TRAVEL, SERVICES, SUPPLIES, EQUIPMENT, OTHER (20 types) |
| DCT_DOCUMENT_TYPES | IDENTITY, TRAVEL, FINANCIAL, LEGAL, MEDICAL, OTHER (18 types) |
| DCT_GL_CODE_COMBINATIONS | Finance Division codes for DT/PC/FL/CC + CAPEX (12 sample combinations) |

---

## Known Issues Fixed During Deployment

### 1. FK syntax — `ENABLE NOVALIDATE` not `NOVALIDATE ENABLE`
Oracle requires `ENABLE NOVALIDATE`, not `NOVALIDATE ENABLE`. Fixed in script.

### 2. INSERT ALL + GENERATED ALWAYS AS IDENTITY — ORA-00001
Oracle 23ai bug: `INSERT ALL` with identity-column tables generates duplicate sequence values.  
**Fix:** Use individual `INSERT INTO ... VALUES (...);` per row for all identity-PK tables.  
Tables with VARCHAR PKs (countries, nationalities, currencies, banks, grades) can still use `INSERT ALL`.

### 3. `SET DEFINE OFF` required
SQLcl treats `&` in string literals as a substitution variable marker.  
`'Department of Culture & Tourism'` prompted `Enter value for Tourism:` and hung the session.  
**Fix:** `SET DEFINE OFF` added after `ALTER SESSION` at the top of the script.

### 4. INSERT ALL without column list — ORA-00947
Tables with `NOT NULL` columns that have defaults (e.g. `created_at TIMESTAMP DEFAULT SYSTIMESTAMP`) require explicit column lists in `INSERT ALL ... INTO table VALUES (...)`.  
**Fix:** Added explicit column lists omitting the defaulted columns for `dct_countries`, `dct_nationality`, `dct_currency_codes`, `dct_bank_codes`.

---

## Next Steps

- Populate `DCT_EMPLOYEES` with actual employee records (HR sync or manual entry)
- Link existing `DCT_USERS` rows to `DCT_EMPLOYEES` via `person_id`
- Populate `DCT_PROJECTS` and `DCT_PROJECT_TASKS` once project register is available
- Update `DCT_GL_CODE_COMBINATIONS` with actual chart-of-accounts codes from Finance
- Consider ORDS endpoints for GL code lookup (LOV in APEX forms)
