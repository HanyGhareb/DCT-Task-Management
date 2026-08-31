# PAY Phase 3 — Payroll Setup & First Calculated Payroll

**Date:** 2026-08-08 · **Status:** DELIVERED — LIVE 2026-08-08 (db/14–17 + JET v1.4.0; API 37/37 incl. 3-month replay reconciliation, browser 29/29 EN+AR) · **App 215 · module PAY · `/ords/admin/pay/`**
Parent plan: `PAY_PLAN_V2.md` (approved) — phase table row 3 + §4.3/§4.5/§4.6. Builds on
Phase 1/1.1 (companies, contracts, margin rules) and Phase 2/2.1 (478 real outsourced
employees with salary snapshots loaded from the Oct–Dec 2025 rounds in `docs/PAYROLL/`).

## Outcome (end-to-end)
A real monthly payroll is **calculated inside the system** — payroll definitions and
calendars, elements with eligibility and calculation rules, a gross-to-net engine with
proration and margin/VAT preview, and a run console through
`Open → Load → Validate → Calculate → Review` — reconciled line-by-line against the current
manual company sheet. **The parallel-run period starts at this phase's exit.** (Approve,
payslips, and invoicing remain Phase 4/5.)

## Design decisions (user answers 2026-08-08 + evidence from `docs/PAYROLL/`)

**Settled:**

2. **Payroll structure — CONFIRMED**: one monthly AED payroll per company
   (`ALN_MONTHLY`, `DAYTON_MONTHLY`, `REACH_MONTHLY`); BU from the assignment; supplier site
   from the company's default PAYROLL-purpose reference.
6. **Promotions / sub-grade steps — DEFERRED** (Phase 6). Grade changes until then arrive via
   the monthly bulk upload (full upsert already updates grade + salary snapshot).
7. **AD Gaming = a DCT department**, not a BU. No BU split. NOTE: ALN still invoices the
   Gaming & Digital Development sector SEPARATELY (invoice 61305) — handled by sector-group
   invoice scoping below, not by BU.

**Observed billing model (from the actual invoices — governs the charge preview):**

- **ALN, Dec 2025 = FOUR tax invoices (61302–61305), one per SECTOR GROUP**: ADALC (35) ·
  Culture+OU+Tourism (54+30+42) · SA+SM&C+Support Services (34+32+87) · Gaming & Digital
  Development (23). Line build-up per employee: salary to be paid + prorated markup 795 +
  other amounts; 5% VAT on the total; payment terms Immediate; remit Standard Chartered AED
  IBAN. Invoice 61304 total 6,633,603.77 + VAT 331,680.19 = 6,965,283.96 reconciles exactly
  as Σsalary + 153×795 + other.
  ⇒ **invoice grouping needs a configurable SECTOR-GROUP dimension per company** (ALN = 4
  groups; Dayton/Reach = 1). Charge preview in P3 groups the same way.
- **Dayton (invoice DAAAO01834, agreement TCA/C&P/AB/13-0222)**: per-employee columns
  Basic + Other + **EOSB accrual = Basic/12** + Insurance + Govt Fees & Other (pass-through
  at cost, e.g. work-permit renewal 3,250) + **Markup flat 1,250.00/employee/month**;
  5% VAT; 30-day payment terms; FAB IBAN.
- **Reach**: fee NOT visible in the folder (payroll sheet shows only DCT salary + employer
  pension contribution; no Reach invoice attached). **The one missing business input.**

**Draft contract terms proposed for user confirmation (1):**

| Company | Margin rule | Extra charge lines | VAT | Terms |
|---|---|---|---|---|
| ALN (exists) | PER_EMPLOYEE **795**, prorated | Other amounts (arrears/adjustments) | 5% | Immediate |
| DAYTON (draft) | PER_EMPLOYEE **1,250**, prorated | **EOSB accrual Basic/12** + insurance + govt fees at cost | 5% | 30 days |
| REACH (draft) | **TBD — need the Reach agreement/invoice** | Employer pension contribution pass-through | 5% (assumed) | TBD |

**Settled 2026-08-08 (2):**

3. **Proration — fixed-30 divisor DEFAULT, configurable per payroll** (lookup
   `PAY_PRORATION_BASIS`: FIXED_30 / CALENDAR_DAYS / WORKING_DAYS — engine implements all
   three); the same factor prorates the per-employee markup ("Prorated Markup").
4. **Pension — build the deduction side now** with the sheet-observed employee rates
   (AE 5% / SA 9% / OM 7.5%, rate table keyed by nationality; no row = no deduction), and
   ship the employer side as a configurable `er_rate` column on the same rate table —
   **NULL (= contributes 0) until Finance confirms the employer % per country and who bears
   it**. Base configurable (default GROSS).
5. **WPS flag = YES** — Y/N on the employee bank record, informational until Phase 5.
   **⚠ PLATFORM RULE (user, 2026-08-08): DCT NEVER pays an employee directly. Every payment
   goes DCT → the outsource company's validated supplier bank account (Phase 5 pays the
   company invoice through Fusion AP). Employee IBAN/WPS data is REFERENCE ONLY — it
   describes how the company disburses to its own staff and must never become a payment
   target in any phase.**
8. **Parallel run — approved**: acceptance = replay ALN Dec-2025 / Dayton Nov-2025 /
   Reach Oct-2025 and reconcile to the approval sheets (company total exact, per-employee
   ≤ AED 0.05 rounding); then the next live month runs both ways, manual process stays
   authoritative until the user switches.
1. **Dayton draft contract — confirmed** (enter as DRAFT: agreement TCA/C&P/AB/13-0222,
   PER_EMPLOYEE 1,250 prorated + EOSB/insurance/govt-fee pass-through noted, VAT 5%,
   30-day terms). **Reach margin stays TBD** — engine flags the missing rule instead of
   guessing; charge preview shows salaries with a "no margin rule" exception.
FORMULA calc rule: seeded in the lookup but **disabled in Phase 3** (no observed use case —
every real element is FLAT / PERCENT / RATE_TABLE / QTY_RATE; `DCT_WF_EXPR` is a boolean
condition engine, so numeric formulas need their own evaluator when a use case appears).

## Data model (all new, `DCT_PAY_*`, lookup-first, effective-dated)

| Table | Purpose |
|---|---|
| `DCT_PAY_PAYROLL` | Payroll definition: code (the value `DCT_PAY_ASSIGNMENT.payroll_code` has been waiting for), name EN/AR, company, frequency (MONTHLY first), currency (one per payroll), BU/site scope, day offsets for cut-off/calculate/approve/pay/archive. |
| `DCT_PAY_PERIOD` | Generated calendar: payroll × period (MM-YYYY), start/end/cut-off/pay dates, status OPEN/CLOSED (lookup). Yearly generation job + on-demand. |
| `DCT_PAY_ELEMENT` | Element master: class EARNING/DEDUCTION/EMPLOYER_COST/INFORMATION; calculation rule FLAT/PERCENT/RATE_TABLE/QTY_RATE/FORMULA; priority order; prorate Y/N; rounding; payslip visibility; recurring/one-time; effective-dated **formula versions** (child table) using the `DCT_WF_EXPR` safe AST — zero dynamic SQL, same engine as DWP conditions. |
| `DCT_PAY_ELEMENT_LINK` | Eligibility: element → company / payroll / job / grade / location / people group / specific employee (any-of rows, resolved at calculation time). |
| `DCT_PAY_ELEMENT_ENTRY` | Recurring + one-time entries per assignment (amount/qty/rate inputs, effective dates, manual-add + authorized override per §4.3). |
| `DCT_PAY_RATE_TABLE` (+`_ROW`) | Named rate tables (first use: pension % by country per Q4). |
| `DCT_PAY_RUN` | Run header: payroll, period, run type (REGULAR only in P3), status `OPEN→LOADED→VALIDATED→CALCULATED→REVIEWED` (+`ERROR`), totals, who/when. |
| `DCT_PAY_RUN_EMP` | Per-employee result: snapshot keys (assignment, company ref, grade, CC), gross / deductions / net / employer cost, proration factor, exception flags. |
| `DCT_PAY_RUN_LINE` | Element-level result rows (the register grain; feeds variance + payslip later). |
| `DCT_PAY_RUN_CHARGE` | Company-charge **preview**: margin/fee/VAT lines computed from the Phase-1 contract margin rules (per §4.6 — never part of employee net), grouped by the company's invoice groups. |
| `DCT_PAY_INVOICE_GROUP` (+`_SECTOR`) | Per-company invoice/sector grouping (ALN = 4 groups over its sectors, e.g. Gaming & Digital Development alone; Dayton/Reach = 1 default group). Drives the charge preview now and Phase-5 invoice splitting later. |

Seed elements per company from the observed sheets: Basic, Allowance (ALN/Reach split),
Gross-only (Dayton), Pension EE/ER (Reach, rate table), plus INFORMATION elements for the
sheet columns we load but do not pay.

## Engine (`DCT_PAY_CALC_PKG`)
- `load_inputs` — snapshot eligible assignments (ACTIVE PRIMARY in period window) + entries
  into the run; late input = next period (§4.5).
- `validate` — exception register: missing bank (warning in P3), zero/negative gross, missing
  grade/CC where an element needs it, assignment gaps, currency mismatches.
- `calculate` — per employee: eligibility → element priority order → proration factor →
  gross-to-net → employer cost → run-charge preview from margin rules. Set-based where
  possible; per-employee SAVEPOINT so one bad row never kills a run.
- `review` snapshot totals + **variance vs prior period** (new/left/changed registers — the
  manual "variation report" the emails ask for every month).
- Rollback: a run in any pre-REVIEWED status can be recalculated; nothing is immutable until
  Phase 4 approval snapshots.

## ORDS (`db/16` additive — joins 08/12 on the post-04 re-run list)
`payrolls` CRUD + `payrolls/:code/periods` (+generate) · `elements` CRUD (+links, entries,
formula versions, rate tables) · `runs` POST/GET register · `runs/:id` detail (KPIs +
exceptions + variance) · `runs/:id/action` (load/validate/calculate/review/reopen) ·
`runs/:id/lines` paged register + CSV · payroll-register export bridge to the Reporting
Platform (XLSX first, `PAY_RUN_REGISTER`).

## Frontend (JET v1.4.0 — AP look, platform classes)
- **Payroll Setup** page: payrolls + calendars, elements (class/rule badges, eligibility
  chips, formula editor with live `conditions/compile`-style validation), rate tables.
- **Run Console** page: period strip → run card with stage buttons (Load → Validate →
  Calculate → Review), exception register, per-employee results in the SHARED
  `<interactive-report>`, variance-vs-prior-month register, company-charge preview tile,
  Register export button.
- Employees drawer: assignment shows its payroll; Phase 2.1 salary snapshot becomes the
  default Basic/Allowance element entries (one-time backfill, then entries are the truth).

## Scripts
`db/14_pay_phase3_ddl.sql` (tables + indexes + recompile sweep) ·
`db/15_pay_phase3_seed.sql` (lookups `PAY_ELEMENT_CLASS`/`PAY_CALC_RULE`/`PAY_RUN_STATUS`/
`PAY_RUN_TYPE`/`PAY_PRORATION_BASIS`, per-company seed elements, pension rate table, the three
payroll definitions + 2025-26 calendars, `payroll_code` backfill on the 478 assignments) ·
`db/16_pay_phase3_pkg.sql` (`DCT_PAY_CALC_PKG`) · `db/17_pay_phase3_ords.sql` (fresh session;
**post-04 re-run list becomes 08, 12, 17**).

## Tests & acceptance
- Unit: proration bases, each calc rule, eligibility resolution, pension rate table, element
  priority, margin preview per method (795/employee validates PER_EMPLOYEE live).
- API: full run chain + every 400/401/403 path + reopen/recalculate idempotency.
- **Reconciliation (the phase gate):** replayed ALN Dec-2025 / Dayton Nov-2025 / Reach
  Oct-2025 runs match the source sheets within the approved tolerance, employee-by-employee.
- Browser EN+AR/RTL smokes; 0 INVALID; docs (STATUS/deployment-notes/functions_list/CLAUDE.md
  row/memory) in the same change.

## Out of scope (later phases)
DWP approval + period locking + frozen snapshots + payslips (P4); invoice creation and Fusion
posting (P5 — the charge preview here is display-only); leave/loans/separate payments +
off-cycle/retro/correction runs (P6); portals (P7).
