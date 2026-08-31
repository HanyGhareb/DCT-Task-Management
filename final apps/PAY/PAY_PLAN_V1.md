# Outsource Payroll (OP) Module — Review and Approval Plan

> **SUPERSEDED:** this is V1, retained for history. The current document for review and
> approval is **`PAY_PLAN_V2.md`** (module abbreviation changed OP → PAY; delivery
> re-planned into end-to-end phases).

**Document date:** 2026-08-05  
**Status:** Superseded by PAY_PLAN_V2.md  
**Proposed application:** App 215 · Module code `OP` · ORDS path `/ords/admin/op/`

## 1. Purpose

DCT engages outsourced employees through multiple outsource companies. Each company is
maintained in Oracle Fusion as a supplier with supplier sites and payment details. DCT
calculates and retains employee-level payroll information, but pays the outsource company,
which then pays its employees and charges DCT the contractual margin, fees, and applicable
VAT.

The proposed i-Finance Outsource Payroll module will provide configurable,
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
| Application | i-Finance App 215, module code `OP` |
| Frontend | Oracle JET SPA using the shared i-Finance shell and App 200 identity |
| Services | `op.rest` under `/ords/admin/op/` |
| Business logic | `DCT_OP_PKG` and `DCT_OP_CALC_PKG` |
| Approval | DCT Workflow Platform (DWP) |
| Reporting | Shared Reporting Platform for payslips, registers, books, and delivery tracking |
| Documents/audit | Shared `DCT_DOCUMENTS`, status history, notifications, and audit services |
| Fusion integration | Controlled AP-invoice action queue with duplicate prevention and posting gate |
| Employee portal | Separate secure portal-session model for outsourced employees |

The application will be developed only under `final apps/`. Detailed table and API names
remain subject to technical-design review.

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

`Open Period -> Load Inputs -> Validate -> Calculate -> Review -> Approve -> Pay -> Account -> Archive`

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

- Employee portal for payslips, payment history, balances, leave, and documents.
- Configurable payslip publishing and secure email delivery tracking.
- Company summary and employee-level detail for monthly and separate payments.
- Employee payslip, payment history, deductions, loans, leave, and compensation reports.
- Payroll register, costing, margin/VAT, variance, exception, and reconciliation reports.
- Later company-portal capability for invoice, payroll-summary, and payment-status access.

## 5. Security and Controls

- Role-based entry, calculation, review, approval, payment, archive, and correction privileges.
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

## 9. Delivery Phases

1. **Design foundation:** approved requirements, data model, calculation specification,
   security matrix, and Fusion interface contract.
2. **Core configuration:** companies, contracts, people, assignments, payroll calendars,
   elements, eligibility, formulas, and costing.
3. **Monthly payroll:** validation, calculation, approvals, frozen results, payslips, invoices,
   and core reports.
4. **Extended payroll:** leave, loans, retro-pay, reversals, compensation, separate payments,
   and recoveries.
5. **Integration:** gated Fusion AP posting, status synchronization, accounting, and full
   reconciliation.
6. **Portals and analytics:** employee portal, later company portal, dashboards, alerts, and
   advanced reports.
7. **Go-live:** migration, parallel payroll cycles, UAT, reconciliation sign-off, and phased
   company rollout.

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
- [ ] Delivery phases and acceptance approach are approved.

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
