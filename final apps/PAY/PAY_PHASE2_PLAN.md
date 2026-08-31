# PAY Phase 2 — Workforce (Outsourced Employees & Assignments)

**Date:** 2026-08-06 · **Status:** DELIVERED — LIVE 2026-08-07 (db/09–12 + JET v1.2.0) · **App 215 · module PAY · `/ords/admin/pay/`**
Parent plan: `PAY_PLAN_V2.md` (approved) — phase table row 2 + §4.2. Builds on Phase 1 (companies & contracts) and Phase 1.1 (governance).

## Outcome (end-to-end)
Complete, auditable outsourced-employee records maintained in the system — replacing the
current spreadsheets — with effective-dated concurrent assignments, lifecycle events,
role-controlled bank details and documents, document-expiry alerts, a single-entry form and
a full-upsert Excel bulk upload.

## Decisions locked (user, 2026-08-06)
1. **Employee number = auto-generated** (`OS-#####` via sequence, prefix in module settings)
   **+ a separate nullable `fusion_person_number`** cross-reference — some outsourced staff
   already exist in Fusion HCM; unique when present.
2. **Entry roles now:** `PAY_HR_ENTRY` (personal + assignment data) and `PAY_PAYROLL_ENTRY`
   (bank details); documents = either entry role; `PAY_ADMIN` = everything; `PAY_USER` = read.
3. **Assignment attributes reuse the DCT masters:** department → `DCT_ORGANIZATIONS`,
   grade → `DCT_EMPLOYEE_GRADES`, job → `HR_JOBS`, position → `HR_POSITIONS`,
   location → `HR_LOCATIONS`, manager → `DCT_EMPLOYEES`. People group (no master exists)
   → new lookup `PAY_PEOPLE_GROUP`.
4. **Excel bulk upload = full upsert** — new hires AND updates in one workbook, matched by
   employee number (or Emirates ID for new rows), per-row validation + result, chunked.
5. **Email is MANDATORY for every employee category** (2026-08-07) — direct hires, outsourced
   staff (even with a Fusion HR record), freelancers. `DCT_EMPLOYEES.EMAIL` keeps NOT NULL;
   the hire form + bulk upload enforce it with a clean 400.

## Data model (additive — nothing dropped)

### ALTER `DCT_EMPLOYEES` (shared platform table — additive only)
- `employee_type VARCHAR2(20) DEFAULT 'INTERNAL' NOT NULL` — lookup `EMPLOYEE_TYPE`
  (INTERNAL / OUTSOURCE). Existing rows stay INTERNAL; no other module changes behaviour.
- `fusion_person_number VARCHAR2(30)` nullable + function-based unique index (unique when set).
- `EMAIL` **stays NOT NULL — user decision 2026-08-07**: email is mandatory for ALL employee
  categories (direct hires in Fusion, outsourced staff even when they have a Fusion HR record,
  freelancers). The hire form and bulk upload validate it as required (clean 400, not ORA-01400).

### New tables
| Table | Purpose |
|---|---|
| `DCT_PAY_ASSIGNMENT` | Effective-dated assignment: person → outsource **company** (+ optional Phase-1 **contract**), `bu_code` (PAY_BU), org/job/grade/position/location FKs to the masters above, `manager_person_id`, `people_group`, `assignment_type` PRIMARY/CONCURRENT, `status` ACTIVE/SUSPENDED/ENDED, `effective_from/to`, `payroll_code` placeholder (Phase 3 FK), row_version + who columns. **Rules:** exactly one ACTIVE PRIMARY assignment per person per date window (overlap-guarded); CONCURRENT rows unlimited; movement between companies = end-date old + new row via TRANSFER. |
| `DCT_PAY_EMP_BANK` | Employee bank accounts (bank name, IBAN, account no, effective dates, one `is_primary` per person). Writes = PAY_PAYROLL_ENTRY / PAY_ADMIN only. |
| `DCT_PAY_EMP_EVENT` | Lifecycle trail: HIRE / TRANSFER / SUSPEND / RESUME / TERMINATE / REHIRE — event + effective date, reason (lookup `PAY_EVENT_REASON`), from/to assignment refs, notes, actor. Every lifecycle mutation writes exactly one event row. |

### Documents & expiry
Shared `DCT_DOCUMENTS` (`source_module='PAY'`, new `source_type='PAY_EMPLOYEE'`,
reference = person_id) through the existing `/pay/docs` routes; required-doc checklist rows
(Emirates ID, passport, visa/work permit, labour card, employment contract, bank letter —
Required/Optional configurable) + expiry tracking via the shared `DCT_DOC_REQUIREMENTS` /
`DCT_DOC_EXPIRY_ALERTS` infrastructure; the daily PAY sweep notifies PAY_ADMIN + PAY_HR_ENTRY
of documents expiring inside their alert window (7-day re-notify throttle, Phase-1 pattern).

## Scripts (all additive; SQLcl rules per deployment-notes)
- `db/09_pay_phase2_ddl.sql` — ALTERs + 3 tables + indexes (re-runnable guards).
- `db/10_pay_phase2_seed.sql` — lookups `EMPLOYEE_TYPE`, `PAY_ASSIGNMENT_STATUS`,
  `PAY_ASSIGNMENT_TYPE`, `PAY_PEOPLE_GROUP`, `PAY_EVENT_TYPE`, `PAY_EVENT_REASON`,
  employee doc-type seeds; roles `PAY_HR_ENTRY` / `PAY_PAYROLL_ENTRY` + permissions;
  settings `EMP_NUMBER_PREFIX` (OS-), `EMP_DOC_ALERT_DAYS` (30).
- `db/11_pay_phase2_pkg.sql` — `DCT_PAY_EMP_PKG`: `next_emp_number`, `save_employee`
  (dedup on Emirates ID / passport / fusion_person_number → clear 400s), `save_assignment`
  (FK + PRIMARY-overlap validation), lifecycle procs (`transfer` / `suspend` / `resume` /
  `terminate` / `rehire` — assignment adjustments + event row + employee `is_active`/`end_date`),
  `save_bank` (role check), `bulk_upsert_row`, doc-expiry sweep.
- `db/12_pay_phase2_ords.sql` — additive ORDS (**re-run after any 04 re-run**, joins 08 on
  that list): `employees` GET (facets: company/status/BU/type + search, paged) / POST ·
  `employees/:id` GET (profile + assignments + banks + events + docs) / PUT ·
  `employees/:id/assignments` POST · `assignments/:id` PUT · `employees/:id/lifecycle` POST
  (action + effective date + reason) · `employees/:id/banks` POST · `emp-banks/:id` PUT ·
  `employees/bulk` POST (≤500 rows, per-row {row, status READY/ERROR, error}) ·
  `lov/masters` GET (orgs / jobs / grades / positions / locations, one call) ·
  `lov/managers` GET (type-ahead over DCT_EMPLOYEES) · `employees/expiring-docs` GET.

## Frontend (JET v1.2.0 — AP look & feel, platform classes only)
- Nav group **Workforce** → **Employees** page: register (server-paged, facet rail company /
  status / BU / search) + `.dw-*` drawer with tabs **Profile** (identity incl. Fusion person
  no · OS number readonly) / **Assignments** (sub-editor, master LOV dropdowns, PRIMARY badge,
  timeline order) / **Bank** (role-gated, masked for non-payroll roles — Phase 1.1 mask
  pattern) / **Documents** (shared doc-upload + checklist status) / **Lifecycle** (event trail
  + top-right action buttons Transfer / Suspend / Resume / Terminate, each a small modal:
  effective date + reason + notes).
- **Bulk Upload** region on the Employees page: template download, SheetJS client parse +
  per-row validation, chunked `employees/bulk` upsert, per-row READY/ERROR results table
  (GL/ATD pattern).
- Dashboard: headcount-by-company tile + expiring-documents tile.
- i18n EN + AR complete; RTL verified.

## Tests & acceptance
- PL/SQL unit: numbering, dedup 400s, PRIMARY-overlap guard, each lifecycle transition, role
  gates on bank writes.
- API pytest: CRUD chain hire→assign→bank→transfer→suspend→terminate + bulk upsert (insert +
  update + error rows) + 400/401/403 paths.
- Browser smoke EN + AR/RTL (register, drawer tabs, lifecycle modal, bulk upload happy path).
- Zero INVALID objects; all test data deleted after runs.
- Docs: STATUS.md, deployment-notes.md, functions_list.md, CLAUDE.md module row, memory.

## Out of scope (later phases)
Payroll definitions & calendars (P3 — `payroll_code` stays a free placeholder), DWP approval
chains (excluded per Phase-1.1 decision until requested), employee self-service portal (P7),
company-side maintenance portal (P7).
