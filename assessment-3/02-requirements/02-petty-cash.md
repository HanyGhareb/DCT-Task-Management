# Petty Cash (App 201) — Requirements & Feature Assessment

**Purpose:** Manage petty-cash advances (floats) issued to employees, their reimbursements, and the final clearing/reconciliation of every advance — with budget coding to GL or projects and routed approvals.

**Primary sources:** `final apps/PC/STATUS.md`, `final apps/PC/db/01_pc_ddl.sql` (8 tables), `final apps/PC/db/04_pc_pkg.sql` (DCT_PC_PKG + DCT_PC_AI_PKG), `final apps/PC/Jet/` (17 views).

---

## 1. Actors

| Actor | Capabilities |
|---|---|
| Employee (custodian) | Request a petty cash advance, submit reimbursements, clear the advance |
| Manager | Approve requests per approval template |
| PC Admin (`IS_PC_ADMIN`) | All-records views, approval rules, GL code admin, module settings |
| Finance / AP | Reimbursement validation, disbursement |

## 2. Functional requirements

### 2.1 Petty cash advance lifecycle (implemented)
- Request an advance of type **TEMPORARY** (one-off, must be cleared by a due date) or **PERMANENT** (standing float) — `dct_petty_cash` (32 cols), statuses DRAFT → SUBMITTED → PENDING_APPROVAL → ACTIVE → CLOSED (or REJECTED/CANCELLED).
- Budget coding per line: `coding_type` GL (cc_id → `dct_gl_code_combinations`) or PROJECT (project/task/expenditure type) — `dct_pc_budget_lines`.
- Fiscal-year tracking; approval via the shared engine (`approval_instance_id`).
- JET views: `pcRequest.html`, `myPettyCash.html`, `pcDetail.html`, `allPettyCash.html`.

### 2.2 Reimbursement (implemented)
- Claim spend against an ACTIVE advance to top the float back up — `dct_pc_reimbursements` + `dct_pc_reimb_budget_lines`, own approval route.
- JET: `reimbursements.html`, `reimbDetail.html`, `allReimbursements.html`.

### 2.3 Clearing / reconciliation (implemented)
- Close an advance: `amount_spent` (proof lines in `dct_pc_clear_budget_lines`) + `amount_refunded` must equal the original advance — `dct_pc_clearing`.
- JET: `clearing.html`, `clearDetail.html`, `allClearings.html`.

### 2.4 AI-assisted clearing (implemented; **API key pending**)
- `DCT_PC_AI_PKG` parses receipts and proposes expense lines/coding for clearing. Requires the AI API key in `DCT_SYSTEM_SETTINGS` (`final apps/PC/STATUS.md` gotchas).

### 2.5 Administration (implemented)
- Approval rules per cost center (`approvalRules.html`), GL code browser (`glCodes.html` — 9-segment concatenation done client-side because `cc_code` is virtual), module settings (`moduleSettings.html`): FISCAL_YEAR_START_MONTH, DUE_DATE_REMINDER_DAYS, MAX_PC_PER_EMPLOYEE.
- Scheduled jobs in `DCT_PC_PKG`: overdue-TEMPORARY alerts and due-date reminders (daily).

### 2.6 Inferred requirements (not written down anywhere)
- One attachment store for all three request kinds, discriminated by `request_type` (PC | REIMB | CLEAR) — `dct_pc_attachments`. **No `document_type_id`** unlike other modules.
- A custodian may hold at most `MAX_PC_PER_EMPLOYEE` open advances — enforced in package, not documented.
- Refund handling on clearing implies a treasury receipt process that has no UI today.

## 3. Current status (verified 2026-06-11)

| Layer | Status | Evidence |
|---|---|---|
| DB + views + seed | ✅ Deployed | `final apps/PC/db/` install chain 00→05 |
| PL/SQL | ✅ DCT_PC_PKG + DCT_PC_AI_PKG | `04_pc_pkg.sql` |
| ORDS | Ready (`/ords/admin/pc`) but **JET still in mock mode** | `final apps/PC/Jet/js/services/config.js` → `apiBase: null` |
| JET SPA | ✅ 17 views, dual mock/ORDS services | `final apps/PC/Jet/js/views/` |
| APEX | ⬜ App 201 shell not started | `final apps/PC/STATUS.md` |

## 4. Gaps & recommendations

| # | Gap | Recommendation | Effort |
|---|---|---|---|
| P1 | **JET runs against mock data** while DT/HR are live — testing happens on stale localStorage | Flip `apiBase` to `/ords/admin/pc`, run the browser smoke test, then delete mock branches like Admin did | S |
| P2 | AI clearing blocked on API key | Store key in `DCT_SYSTEM_SETTINGS` (encrypted), add a settings UI field | S |
| P3 | Attachments lack document-type classification and expiry support | Adopt unified `dct_documents` (see `03-database/02-proposed-model.md` §2) | M |
| P4 | Three nearly identical budget-line tables (PC / REIMB / CLEAR) | Unified `dct_budget_coding_lines` (DB proposal §3) | M |
| P5 | No cash-position dashboard (total floats outstanding per org, ageing of uncleared TEMPORARY advances) | Add KPI + ageing chart to `dashboard.html` (see UI/UX mockup `dashboard-concept.html`) | M |
| P6 | Refund receipt step in clearing has no workflow/UI | Add a treasury confirmation step to the clearing approval template | M |
