# Outsource Payroll (PAY) Module — Review and Approval Plan — Version 2

**Document date:** 2026-08-05  
**Status:** V2 — for stakeholder review and approval  
**Proposed application:** App 215 · Module code `PAY` · ORDS path `/ords/admin/pay/`

> **Version note:** this document supersedes `PAY_PLAN_V1.md` (originally `OP_PLAN.md`).
> Primary changes: (1) the module abbreviation is **PAY** and every artifact is named
> `PAY_*` / `DCT_PAY_*`; (2) the delivery plan is restructured into **end-to-end phases**,
> each delivering a complete working business function; and (3) supporting technical and
> delivery details are expanded. All business scope and the confirmed decisions of V1 are
> carried forward unchanged.

## 1. Purpose

DCT engages outsourced employees through multiple outsource companies. Each company is
maintained in Oracle Fusion as a supplier with supplier sites and payment details. DCT
calculates and retains employee-level payroll information, but pays the outsource company,
which then pays its employees and charges DCT the contractual margin, fees, and applicable
VAT.

The proposed i-Finance Outsource Payroll module (PAY) will provide configurable,
Fusion-Payroll-style processing without processing outsourced employees through Oracle
Fusion Payroll. Approved company payments will be transferred to Oracle Fusion Payables as
supplier invoices.

## 2. Objectives

- Maintain outsource companies, contracts, suppliers, sites, margins, and payment rules.
- Maintain outsourced people, concurrent assignments, organizational details, and documents.
- Configure payrolls, calendars, elements, formulas, eligibility, balances, and costing.
- Process regular, off-cycle, retroactive, correction, and reversal payroll runs.
- Manage leave, deductions, loans, advances, compensation, and separate payments.
- Generate employee payslips and company/employee summary and detailed reports.
- Create controlled Fusion Payables supplier invoices and reconcile their status.
- Provide effective dating, approvals, audit history, security, and period controls.

## 3. Proposed Platform Design

| Area | Proposed design |
|---|---|
| Application | i-Finance App 215, module code `PAY` |
| Frontend | Oracle JET SPA using the shared i-Finance shell and App 200 identity |
| Services | `pay.rest` under `/ords/admin/pay/` |
| Business logic | `DCT_PAY_PKG` (masters/lifecycle), `DCT_PAY_CALC_PKG` (calculation engine), `DCT_PAY_FUSION_PKG` (invoice bridge) |
| Approval | DCT Workflow Platform (DWP) — configurable approval chains |
| Reporting | Shared Reporting Platform for payslips, registers, books, and email delivery tracking |
| Documents/audit | Shared `DCT_DOCUMENTS`, status history, notifications, and audit services |
| Fusion integration | Controlled AP-invoice action queue with duplicate prevention and posting gate (`FUSION_POST_PAY`, default OFF) |
| Employee portal | Separate secure portal-session model for outsourced employees |

The application will be developed only under `final apps/PAY/`. Detailed table and API
names (`DCT_PAY_*`) remain subject to technical-design review.

## 4. High-Level Functional Scope

### 4.1 Companies and Contracts

- Company profile, category, contacts, tax information, status, documents, and supplier links.
- Multiple supplier/site/payment references, with one default per configured purpose.
- Multiple active, effective-dated contracts and version-controlled amendments.
- Configurable margins, service fees, VAT rules, expiry blocking, and renewal alerts.
- Each contract is limited to its defined payroll, BU, and supplier-site scope.

### 4.2 Employees and Assignments

- Use `DCT_EMPLOYEES` with employee type `OUTSOURCE`.
- Allow movement between outsource companies and multiple concurrent assignments.
- Maintain BU, department, job, grade, position, location, manager, payroll, and people group.
- Allow DCT and outsource-company maintenance according to system roles.
- Control bank details and documents through HR Entry and Payroll Entry permissions.
- Maintain effective-dated lifecycle events: hire, transfer, suspension, and termination.

### 4.3 Payroll Configuration

- Multiple payrolls per company and frequencies other than monthly.
- One currency per payroll; separate payroll scope by BU and supplier site.
- Configurable cut-off, calculation, approval, payment, and archive dates.
- Element classes: earning, deduction, employer cost, and information.
- Calculation rules: flat, percentage, rate table, quantity times rate, and safe formula.
- Recurring and one-time entries, configurable approvals, optional limits, costing, rounding,
  payslip visibility, and effective-dated formula versions.
- Eligibility by company, payroll, job, grade, location, people group, or employee.
- Eligibility resolved during calculation; authorized users may manually add or override entries.

### 4.4 Leave, Loans, and Other Transactions

- Configurable payroll effect by absence type.
- Leave balances maintained in this module, with configurable ownership and DCT as default.
- Direct entry and import of leave records, unpaid-leave calculation, and leave encashment.
- Configurable loan and advance types, approval, fixed/dynamic installments, carry-forward,
  insufficient-net-pay handling, and negative-net-pay policy.
- Configurable separate-payment types, including bonus, mission, expenses, visa fees, tickets,
  and similar payments.
- Configurable supporting-document requirements and cancellation/overpayment recovery.

### 4.5 Payroll Processing

The controlled lifecycle will be:

`Open Period -> Load Inputs -> Validate -> Calculate -> Review -> Approve -> Create Invoice -> Account -> Pay -> Reconcile -> Archive`

- Run types: regular, off-cycle, retroactive, correction, and reversal.
- Configurable proration for joiners, leavers, absences, suspensions, and assignment changes.
- Automatic retro-pay, with configurable approval and a default two-period lookback.
- Late inputs move to the next period.
- Approved results retain a frozen snapshot of assignments, elements, formulas, contract rules,
  costing, rates, and eligibility used in the calculation.
- Archived results are protected. A restricted role may initiate controlled correction,
  reversal, or reopening with approval and full audit history; results are not silently edited.

### 4.6 Employee and Company Amounts

The system will keep these amounts separate:

1. **Gross earnings:** all eligible earning elements.
2. **Employee net entitlement:** eligible earnings less eligible deductions.
3. **Employer costs:** accounting amounts that do not change employee net entitlement.
4. **Company charges:** contract margin, service fees, reimbursable costs, and VAT.
5. **Supplier invoice total:** employee-related cost plus approved company charges.

Information elements affect reporting only. Company margin is not part of employee gross or
net pay.

### 4.7 Margin, VAT, and Supplier Invoices

- Margin methods are configurable: percentage, flat amount, per employee, and per element.
- Margin basis is configurable: basic salary, gross earnings, net entitlement, or selected
  elements.
- A contract may contain multiple effective-dated margin rules.
- VAT treatment is configurable.
- Margin and VAT applicability for each payment type is configured in the company contract.
- Monthly invoice grouping is by company, payroll, period, BU, and supplier site.
- Payroll cost and company margin are separate invoice lines.
- For separate payments, the Payroll Entry user may create an individual or consolidated
  supplier invoice according to the company's submitted invoice.
- Approved supplier invoices are processed through Oracle Fusion Payables.
- Fusion submission must use a unique source reference, be idempotent, report failures, and
  support controlled correction and resubmission.

### 4.8 Portals, Payslips, and Reports

- Employee portal for payslips, payment history, balances, leave, and personal documents.
- Configurable payslip publishing per payroll (automatic on approval or manual publish) with
  secure email delivery tracking.
- Company summary and employee-level detail for monthly and separate payments.
- Employee payslip, payment history, deductions, loans, leave, and compensation reports.
- Payroll register, costing, margin/VAT, variance, exception, and reconciliation reports.
- Later company-portal capability for invoice, payroll-summary, and payment-status access.

## 5. Security and Controls

- Role-based entry, calculation, review, approval, payment, archive, and correction privileges
  (`PAY_*` roles).
- DCT/company data maintenance restricted by role and company scope.
- Maker-checker controls for sensitive changes, including bank, contract, and payroll data.
- Configurable workflow by transaction and business rules.
- Effective dating, versioning, immutable calculation snapshots, period locking, and audit trail.
- Reconciliation from employee results to company charges, supplier invoice, and Fusion status.
- Portal access auditing and masking of sensitive bank and identity information.

## 6. Confirmed Decisions

| Ref. | Confirmed decision |
|---:|---|
| 1–7 | Shared employee master with `OUTSOURCE` type; movements and concurrent assignments allowed; all organization attributes maintained; DCT/company maintenance by role; HR Entry and Payroll Entry control bank details and documents. |
| 8–14 | Multiple active contracts; each contract has a defined payroll/BU/site scope; lookup-based categories; profile-defined documents and approvals; configurable expiry blocking and renewal alerts; versioned amendments. |
| 15–22 | Configurable frequency and dates; multiple payrolls per company; one currency per payroll; BU/site separation; late inputs move forward; all run types supported; lock after archive. |
| 23–24 | Gross comprises eligible earnings; net comprises eligible earnings less deductions; margin remains a separate company charge. |
| 25–34 | All element classes and calculation methods; recurring/one-time entries; configured approval; calculation-time eligibility plus manual entry; authorized override; configurable visibility, rounding, and optional limits. |
| 35–40 | Configurable proration; automatic retro; configurable lookback defaulting to two periods; configurable retro approval; controlled correction/reversal of archived results. |
| 41–46 | Absence impact and balance ownership configurable; DCT ownership default; balances maintained internally; leave entry/import, unpaid leave, and encashment supported. |
| 47–51, 54 | Lookup-based loans/advances; configurable approval and installments; configurable insufficient/negative net treatment; automatic carry-forward. |
| 55–60 | Configurable separate payments; supplier-invoice processing; configurable documents; cancellation and recovery supported. |
| 61–68 | All margin methods/bases; multiple rules; configurable VAT; defined monthly invoice grouping; separate payroll/margin lines; user-selected separate-payment consolidation; payment-type margin/VAT controlled by contract. |

**Changes in V2 (naming and delivery only — no business-scope change):**

- Module abbreviation changed from OP to **PAY**; all artifacts follow (`pay.rest`,
  `DCT_PAY_*` tables and packages, `PAY_*` roles, workflows, and report codes).
- Delivery re-planned from layered phases into **end-to-end phases** (Section 9), each
  delivering a complete, immediately usable business function.

## 7. Deferred Decisions

The following items do not block the initial data model and will be confirmed during detailed
design or UAT:

- Loan early settlement, installment suspension, and rescheduling rules.
- Treatment of outstanding loan/deduction balances when an employee leaves.
- Detailed separate-payment approval routing by payment type and value.
- Detailed employee/company portal functions, authentication options, and retention periods.
- Final report layouts, formats, distribution schedules, and variance-alert thresholds.
- Historical data migration depth, pilot companies, parallel-run duration, and acceptance
  tolerances.

## 8. Mandatory Items to Validate During Technical Design

These are implementation validations rather than business-scope decisions:

- Confirm exact Oracle Fusion supplier, site, payment-method, payment-terms, tax, and payment
  bank-account interface behavior.
- Confirm source DCT bank-account/payment-process-profile selection in Fusion Payables.
- Confirm accounting distributions for payroll cost, employer cost, margin, fees, VAT,
  recoveries, projects, and cost centers.
- Confirm privacy, retention, and secure payslip-delivery requirements.
- Confirm role names, company data scope, maker-checker rules, and archive-reopening authority.

## 9. Delivery Phases — End-to-End Model

Each phase is a **vertical slice**: it is deployed to production, fully tested, UAT-signed,
and delivers a business function that is immediately usable on its own. Later phases extend
the module without reworking earlier ones.

| # | Phase | Scope | Working function delivered at phase end |
|---|---|---|---|
| 1 | **Companies & Contracts** | Application scaffold and registration; company profiles and categories; multiple supplier/site/bank references per company; effective-dated contracts with margin/fee/VAT rules and versioned amendments; renewal alerts; supporting documents. | A live, governed registry of all outsource companies, contracts, and margin terms — the single source of truth, replacing scattered files. |
| 2 | **Workforce** | Outsourced employees on the shared employee master (`OUTSOURCE` type); effective-dated concurrent assignments (company, payroll, BU, department, job, grade, position, location, manager, people group); bank details and documents under role control; lifecycle events; document expiry alerts; single-entry form and Excel bulk upload. | Complete, auditable outsourced-employee records maintained in the system — replacing spreadsheets — with alerts on expiring documents. |
| 3 | **Payroll Setup & First Calculated Payroll** | Payroll definitions and calendars; elements (all classes and calculation rules) with effective-dated formulas; eligibility and element entries; rate tables; balances; the calculation engine (eligibility, proration, priority order, gross-to-net, employer cost, margin/VAT preview); run console through Validate → Calculate → Review with exception and variance registers; payroll register export. | A real monthly payroll is calculated, reviewed, and reconciled against the current manual sheet. The parallel-run period starts here. |
| 4 | **Full Monthly Cycle** | DWP approval chain for payroll runs; period locking and frozen calculation snapshots; payslip generation (PDF, EN/AR) with per-payroll automatic/manual publishing and tracked email delivery; company payment summary and employee-level detail reports; employee payment-history report. | The complete monthly cycle — Open through Approve, payslips published to employees, company reports issued. Payment itself is still executed outside the system. |
| 5 | **Payment to Fusion** | Supplier invoice generation (grouping by company, payroll, period, BU, and supplier site; payroll cost and margin/VAT as separate lines); gated, idempotent AP-invoice posting through the platform action queue; Fusion status synchronization; Create Invoice → Account → Pay → Reconcile → Archive statuses; full reconciliation report (employee results ↔ company charges ↔ invoice lines ↔ Fusion). | The invoice is created, validated, accounted, and available for Fusion payment processing. Final payment status is synchronized when confirmed by Fusion. |
| 6 | **Leave, Loans & Separate Payments** | Absence types with configurable payroll effects, leave balances, import, unpaid-leave calculation, and encashment; loans/advances with schedules, carry-forward, and net-pay policies under approval; dynamic separate-payment types (bonus, mission, expenses, visa fees, tickets, and similar) with individual or consolidated invoices; off-cycle, retroactive, correction, and reversal runs. | Every payment and deduction type flows through the same calculate → approve → pay pipeline; off-cycle payments are live end-to-end. |
| 7 | **Self-Service & Analytics** | Employee portal (payslips, payment history, balances, leave, documents) on the secure portal-session model; dashboards (payroll cost, headcount, contract expiry, outstanding loans, payment status) and month-over-month anomaly alerts; hardened maker-checker and security-console privileges; optional company portal; phased onboarding of remaining companies. | Employees self-serve their payslips; management has live analytics; company rollout completes and the module reaches full go-live. |

**Phase exit criteria (every phase):** database deploys with zero invalid objects; unit, API,
and browser (English and Arabic/RTL) tests pass; reconciliation assertions hold; a UAT round
is executed and signed off; deployment notes, status, and functions-list documentation are
updated.

## 10. Verification and Acceptance

- Database deployment completes with zero invalid objects.
- Unit tests cover formulas, eligibility, proration, retro, balances, margins, and VAT.
- API tests cover security, validation, lifecycle, concurrency, and duplicate prevention.
- Browser tests cover English and Arabic/RTL workflows, roles, approvals, reports, and portal.
- Reconciliation proves employee results, company charges, invoice lines, and Fusion totals.
- At least the agreed number of parallel payroll cycles completes within approved tolerance.
- Payroll, HR, Finance/AP, IT, Internal Control, and business owners provide UAT sign-off.

## 11. Review and Approval

Reviewers should confirm:

- [ ] Business scope and confirmed decisions are accurate.
- [ ] Employee, payroll, margin, VAT, and supplier-invoice definitions are correct.
- [ ] Security, approval, audit, and correction controls are sufficient.
- [ ] Fusion Payables and accounting assumptions are accepted for technical validation.
- [ ] Deferred decisions may be finalized during detailed design or UAT.
- [ ] The end-to-end delivery phases and acceptance approach are approved.

| Review area | Reviewer | Decision | Comments | Date |
|---|---|---|---|---|
| Payroll |  | Approve / Revise |  |  |
| Human Resources |  | Approve / Revise |  |  |
| Finance / Accounts Payable |  | Approve / Revise |  |  |
| Outsource Contract Owner |  | Approve / Revise |  |  |
| IT / i-Finance |  | Approve / Revise |  |  |
| Internal Control / Audit |  | Approve / Revise |  |  |
| Final Business Owner |  | Approve / Revise |  |  |

Approval of this document authorizes detailed functional and technical design. It does not
authorize production deployment until design, security, integration, testing, and UAT
deliverables are separately approved.
