# PAY — Outsource Payroll (App 215) — Functions List

Functional inventory of the JET SPA (`Jet/js/views/<x>.html` + `viewModels/<x>.js`) and the ORDS API (`db/04_pay_ords.sql`). Update this file in the SAME change as any view/method/endpoint change.

## Overview (dashboard)
- `refresh()` — reload the /stats figures and expiring-contracts list.
- `toggleRegion()` / `toggleRegionMax()` — collapse / maximize the expiring-contracts region.
- `openContract(row)` — deep-link a row into the Contracts page drawer.
- `go(route)` — header shortcut (New Company).

## Companies
- `load()` / `onPage()` — server-paged register (search debounce, status + category filters).
- `exportCsv()` — CSV of the visible register (UTF-8 BOM).
- `toggleTable()` / `toggleTableMax()` — region collapse / maximize.
- `openNew()` / `openEdit(row)` — company drawer (Profile / Supplier References / Documents tabs; suppliers+docs enabled after first save).
- `save()` — create/update via POST/PUT companies (validation errors surfaced in-drawer).
- Supplier references: `supNew()` / `supEdit(s)` / `supPick(lovItem)` (type-ahead over the Fusion supplier extract, auto-fills bank details) / `supSave()` / `supCancel()` / `supToggleDefault()` (one default per purpose).
- Documents: `docUpload()` (raw-binary, MAX_UPLOAD_MB), `docView(d)`, `docDelete(d)`, `loadDocs()`.

## Contracts
- `load()` / `onPage()` — register (search, company, status, BU, expiring ≤60d filters).
- `exportCsv()`, `toggleTable()`, `toggleTableMax()`.
- `openNew()` / `openEdit(row)` / `openVersion(v)` — drawer (Details / Margin Rules / Documents tabs) with amendment-chain version chips.
- `save()` — create/update; company's active supplier refs feed the site-scope select.
- `amend()` — clone as next version (new draft), old version → SUPERSEDED.
- Margin rules: `mrNew()` / `mrEdit(m)` / `mrSave()` (overlap per scope rejected server-side) / `mrCancel()` / `mrToggleVat()`.
- `toggleExpiryBlocking()`, documents as on Companies (source type PAY_CONTRACT).

## Employees (Workforce — Phase 2)
- `load()` / `onPage()` — server-paged register (search debounce; company / BU / active filters).
- `exportCsv()`, `toggleTable()` / `toggleTableMax()`.
- `openNew()` / `openEdit(row)` — drawer (Profile / Assignments / Bank / Documents / Lifecycle tabs; tabs enabled after first save).
- `save()` — hire (auto OS- number) or update via POST/PUT employees (email mandatory; dedup 400s surfaced in-drawer).
- Assignments: `asgNew()` / `asgEdit(a)` / `asgSave()` / `asgCancel()` — master LOV dropdowns (company/contract/BU/department/job/grade/position/location/people group), manager type-ahead `mgrPick()` / `mgrClear()`; PRIMARY-overlap 400 server-side. Phase 2.1 fields: company ref, free-text designation/sector/department, cost center, basic/allowance/gross salary snapshot.
- Bank (PAY_PAYROLL_ENTRY / PAY_ADMIN): `bankNew()` / `bankEdit(b)` / `bankSave()` / `bankTogglePrimary()`; masked read-only otherwise.
- **Salary tab (2026-08-09, v1.6.0)**: per-employee element entries over `/pay/entries` (`loadEntries`/`enNew`/`enEdit`/`enSave`/`enEnd`) — list w/ element/type/amount/qty×rate/effective window/status, New/Edit/End-as-of-today actions, element picker = active FLAT/QTY_RATE elements; actions gated PAY_PAYROLL_ENTRY/PAY_ADMIN (pension/percent elements compute automatically — no entry). `DCT_PAY_EMP_PKG.save_assignment` auto-seeds missing BASIC+ALLOWANCE (or GROSS_SALARY) entries from assignment salary figures (hire / bulk / transfer) — missing-only, never overwrites.
- Documents: `loadEmpDocs()` (docs + 6-type checklist), `docUpload()` (type + expiry pickers), `docView(d)`, `docDelete(d)`.
- Lifecycle: `lcStart(action)` / `lcSubmit()` / `lcCancel()` — Transfer / Suspend / Resume / Terminate / Rehire sub-form (effective date + reason + notes, target company for transfer/rehire); `lcAvailable` derives valid actions from record state; event trail table.
- Bulk upload: `bulkTemplate()` (SheetJS .xlsx template), `bulkChoose()` → parse → chunked `employees/bulk` full upsert → per-row CREATED/UPDATED/ERROR results + summary.

## Payroll Runs (Phase 3 — run console)
- Payroll + period pickers (period options show the existing run status); `openRun()` — open or create the period's REGULAR run.
- `doAction(a)` — Load / Validate / Calculate / Review / Reopen stage buttons (state-gated via `can(a)`; Reopen confirms).
- KPI band (employees / exceptions / gross / deductions / net / employer cost / company charges) + stage trail (who/when per stage).
- Invoice-group summary table + company-charge preview table (margin per group, VAT preview, DRAFT-contract and no-margin-rule flags).
- Exceptions register + variance-vs-prior-period region (new/left/changed + top deltas).
- Results register: server-paged + search + status/group filters (groups shown as Short Code); row click → calculation-lines drawer; `exportCsv()` — payroll register CSV (+ Group Short Code column).
- Lines drawer invoice-group move (`applyGroup`, PAY_ADMIN, run LOADED/VALIDATED/CALCULATED): select from `run().groupLov`, persists as an INCLUDE override and re-prices company charges immediately.

## Payroll Setup (Phase 3 — PAY_ADMIN)
- Payrolls table + edit drawer (`pdEdit`/`pdSave`): names, proration basis/divisor, pension base, cut-off/pay day, active; `pdGenPeriods()` — generate a year's monthly calendar.
- Elements table + drawer (`edNew`/`edEdit`/`edSave`): class/rule/base/percent/rate table/priority/prorate; eligibility links (`edAddLink`/`edToggleLink`). FORMULA rule disabled in Phase 3.
- Rate tables (`rdEdit`/`rdAdd`/`rdUpdate`): PENSION_GCC employee/employer % per nationality (employer NULL until Finance confirms).
- Invoice groups (`gdNew`/`gdEdit`/`gdSave`) — **cost-center based since 2026-08-09**: numeric Code + Short Code, cost-center checkbox picker (`ccLov`; centers owned by another group are locked and labeled), resolved member list with source badges CC/INCLUDE/DEFAULT (`gdRemoveMember` = EXCLUDE for CC members, CLEAR for forced includes; `gdRestore` un-excludes), add-employee search (`gdAddEmp` = INCLUDE override). Default group catches unmapped cost centers.

## DCT Bank Accounts
- `load()`, `openNew()` / `openEdit(row)`, `save()`, `toggleActive()`.

## API Endpoints (ORDS — pay.rest, /ords/admin/pay/)
| Method | Path | Purpose |
|---|---|---|
| GET | boot | Identity flags + PAY_* lookups + banks |
| GET | stats | Overview KPIs + expiring contracts (top 10) |
| GET | companies | Paged register (search/status/cat/limit/offset) |
| POST | companies | Create company (PAY_ADMIN) |
| GET | companies/:id | Company + supplier refs + contracts summary |
| PUT | companies/:id | Update company (PAY_ADMIN) |
| POST | companies/:id/suppliers | Add supplier reference (validated vs ATD_SUPPLIERS) |
| PUT | suppliers/:sid | Update supplier reference |
| GET | contracts | Paged register (search/companyid/status/bu/expiring) |
| POST | contracts | Create contract (PAY_ADMIN) |
| GET | contracts/:id | Contract + margin rules + version chain |
| PUT | contracts/:id | Update contract |
| POST | contracts/:id/amend | Clone as next version; old → SUPERSEDED |
| POST | contracts/:id/margin-rules | Add margin rule (overlap-guarded) |
| PUT | margin-rules/:rid | Update margin rule |
| GET | banks | DCT funding bank accounts |
| POST | banks | Create bank (PAY_ADMIN) |
| PUT | banks/:id | Update bank (PAY_ADMIN) |
| GET | lov/suppliers?search= | Type-ahead over ATD_SUPPLIERS (top 30, primary bank row) |
| GET | lov/supplier-sites?registryid= | Sites of a Fusion supplier (ATD_SUPPLIER_SITES) — Phase 1.1 |
| GET | lov/supplier-banks?registryid= | Bank accounts of a Fusion supplier (ATD_SUPPLIER_BANK_ACCOUNTS) — Phase 1.1 |
| GET | lov/payment | Payment LOVs from the AP installments extract: paymentMethods[] + payGroups[] (ATD_AP_INVOICE_INSTALLMENTS) + paymentTerms[] (ATD_AP_INVOICES) |
| GET/PUT | companies/:id/governance | Owners, contacts, compliance, scores (Phase 1.1) |
| POST | companies/:id/contacts · PUT contacts/:id | Company contacts CRUD (Phase 1.1) |
| POST | companies/:id/compliance · PUT compliance/:id | Compliance items CRUD (Phase 1.1) |
| POST | companies/:id/scores | Performance scorecard entry (Phase 1.1) |
| GET/PUT | contracts/:id/governance | Contract governance (Phase 1.1) |
| POST | contracts/:id/fee-rules · PUT fee-rules/:id | Configurable fee rules (Phase 1.1) |
| POST | contracts/:id/amend-governed | Governed amendment w/ change log (Phase 1.1) |
| POST | contracts/:id/renewal-actions | Renewal workflow actions (Phase 1.1) |
| POST | suppliers/:id/refresh | Re-validate a supplier ref vs the ATD extract (Phase 1.1) |
| GET | governance/data-quality | Company data-quality exceptions (Phase 1.1) |
| GET | governance/renewals | Contracts expiring ≤180 days (Phase 1.1) |
| GET | employees | Paged outsourced-employee register (search/companyid/bu/active) — Phase 2 |
| POST | employees | Hire (auto OS- number, HIRE event; PAY_HR_ENTRY/PAY_ADMIN) — Phase 2 |
| GET | employees/:id | Full profile: assignments + banks (masked w/o payroll role) + events — Phase 2 |
| PUT | employees/:id | Update employee (OUTSOURCE only; dedup 400s) — Phase 2 |
| POST | employees/:id/assignments · PUT assignments/:aid | Effective-dated assignments (one ACTIVE PRIMARY per window) — Phase 2 |
| POST | employees/:id/lifecycle | TRANSFER/SUSPEND/RESUME/TERMINATE/REHIRE + event row — Phase 2 |
| POST | employees/:id/banks · PUT emp-banks/:bid | Employee bank accounts (PAY_PAYROLL_ENTRY/PAY_ADMIN) — Phase 2 |
| GET | employees/:id/docs | Employee documents + PAY_EMPLOYEE checklist status — Phase 2 |
| PUT | employees/:id/docs?doctype=&file_name=&mime_type=&expiry= | Raw-binary employee doc upload w/ real type + expiry — Phase 2 |
| POST | employees/bulk | Excel full upsert ≤500 rows, per-row {row,status,error}; matches empNo→fusionNo→EID→email; enrichment + bank columns (Phase 2.1) |
| GET | lov/masters | One-call LOVs: companies/contracts/departments/jobs/grades/positions/locations/nationalities/docTypes + canHr/canPayroll — Phase 2 |
| GET | lov/employees?search= | Manager type-ahead over DCT_EMPLOYEES (top 20) — Phase 2 |
| GET | employees/expiring-docs?days= | Employee documents expiring inside the window — Phase 2 |
| GET | paysetup/boot | Setup snapshot: payrolls/elements(+links)/rate tables(+rows)/invoice groups (numeric code + shortCode + cost centers + override counts) + PAY_* lookups + canSetup/canRun — Phase 3 |
| POST | paysetup/payrolls · PUT paysetup/payrolls/:id | Payroll definition writes (PAY_ADMIN) — Phase 3 |
| GET/POST | paysetup/payrolls/:id/periods | Period calendar list / generate a year — Phase 3 |
| POST | paysetup/elements · PUT paysetup/elements/:id | Element writes (FORMULA rejected) — Phase 3 |
| POST | paysetup/elements/:id/links · PUT paysetup/links/:id | Eligibility links — Phase 3 |
| POST | paysetup/rate-rows · PUT paysetup/rate-rows/:id | Rate-table rows (pension %) — Phase 3 |
| POST | paysetup/invoice-groups · PUT paysetup/invoice-groups/:id | Invoice groups: numeric code + shortCode + pipe-list cost centers (a dash clears; cross-group CC = 400) — CC-based since 2026-08-09 |
| GET | paysetup/cc-lov?companyid= | Company cost-center catalog (employees, sector, owning group) for the group drawer picker |
| GET/POST | paysetup/invoice-groups/:id/emps | Resolved group membership (source CC/INCLUDE/DEFAULT) + excluded list / set INCLUDE·EXCLUDE·CLEAR override (PAY_ADMIN) |
| GET | paysetup/invoice-groups/:id/candidates?search= | Add-employee picker: company employees not force-included (cap 20) |
| GET/POST | entries · PUT entries/:id | Element entries per employee (recurring/one-time; PAY_PAYROLL_ENTRY/PAY_ADMIN) — Phase 3 |
| GET/POST | runs | Run register / create-or-return the period's REGULAR run — Phase 3 |
| GET | runs/:id | Run detail: KPIs + groups + charges + exceptions + variance vs prior period — Phase 3 |
| POST | runs/:id/action | LOAD / VALIDATE / CALCULATE / REVIEW / REOPEN — Phase 3 |
| GET | runs/:id/emps · runs/:id/emps/:reid | Paged per-employee results (+search/status/group; rows carry group + groupShort) / calculation lines — Phase 3 |
| PUT | runs/:id/emps/:reid | Pay-Admin invoice-group move on a LOADED/VALIDATED/CALCULATED run: persists as INCLUDE override + re-prices charges when calculated — 2026-08-09 |
| GET | runs/:id/export | Payroll register CSV (UTF-8 BOM) — Phase 3 |
| GET | docs?type=&id= | Documents of a company/contract (DCT_DOCUMENTS, module PAY) |
| PUT | docs?type=&id=&file_name=&mime_type= | Raw-binary upload (PAY_ADMIN, MAX_UPLOAD_MB → 413) |
| DELETE | docs/:docId | Soft-delete a document (PAY_ADMIN) |
| GET | docs/:docId/file | Media download |

## Services / Data layer
| Service | Role |
|---|---|
| `services/payService.js` | The ONE client for /pay/ (register, drawers, LOV, docs) |
| `services/api.js` | Re-export of shared fetch wrapper (Bearer + 401 redirect) |
| `services/authService.js` | Session reader (Admin JET writes the session) |
| `services/config.js` | apiBase /pay · authBase /dct |
| Server | `DCT_PAY_PKG` (validated writes + renewal sweep) · `DCT_PAY_RENEWAL_JOB` daily 07:20 UTC · `DCT_PAY_EMP_PKG` (Phase 2 workforce: numbering/dedup/assignments/lifecycle/banks/docs/bulk) · `DCT_PAY_EMPDOC_JOB` daily 07:25 UTC · `DCT_PAY_CALC_PKG` (Phase 3 payroll setup writes + the run engine: load/validate/calculate/review/reopen, proration, eligibility, rate tables, charge preview) |
