# Business Requirements Document — Petty Cash Module
**App:** 201 | **Module Code:** PETTY_CASH | **Version:** 1.0 FINAL | **Date:** 2026-05-13

---

## 1. Purpose & Scope

Manages petty cash advance payments for **all DCT (Department of Culture and Tourism) employees** across all departments. The AP Petty Cash Admin team receives, reviews, and processes all requests. Employees self-serve to submit petty cash, reimbursement, and clearing requests.

---

## 2. User Roles

| Role | Access |
|---|---|
| **Employee** | Submit petty cash request, raise reimbursement & clearing requests, attach documents, track own status |
| **Manager** | Approve/reject requests for their team |
| **AP_PETTY_CASH_ADMIN** | Full org-wide visibility, process and close requests, reconcile, manage settings |
| **Admin** | System configuration, user access management |

---

## 3. Finance Policy Rules

| Rule | Detail |
|---|---|
| Active petty cash per employee | Configurable via Module Settings (`ALLOW_MULTIPLE_PC` / `MAX_PC_PER_EMPLOYEE`) |
| Two types | **Temporary** — must be cleared within the same fiscal year \| **Permanent** — spans multiple fiscal years |
| Fiscal year | Starts **January** — configurable in Module Settings |
| Multiple reimbursements | Employee may raise as many reimbursement requests as needed against their active petty cash |
| Clearing closes the petty cash | One clearing request settles and closes; no further reimbursements after clearing is submitted |

---

## 4. Core Business Process

### 4.1 Petty Cash Request (Advance)
- Employee submits advance request (only if active PC count < `MAX_PC_PER_EMPLOYEE`)
- Fields: Type (Temporary/Permanent), Amount (AED), Purpose, Due Date, Budget Coding lines
- Enters dynamic approval workflow
- Upon full approval: AP_PETTY_CASH_ADMIN disburses → status becomes **Active**

### 4.2 Reimbursement Request *(repeatable)*
- Employee spent from their float → submits reimbursement with expense proof
- Fields: Amount, Purpose, Budget Coding lines, Attachments
- Upon approval: spent amount paid back → float restored
- Temporary petty cash: all reimbursements must complete before fiscal year end

### 4.3 Clearing Request *(closes petty cash)*
- Employee declares: expense proof (budget lines) + unspent cash refund amount (declared field)
- Example: 10,000 AED advance → 8,000 AED spent (receipts) + 2,000 AED refunded
- Upon AP_PETTY_CASH_ADMIN approval → status **Closed**
- Employee becomes eligible for a new petty cash request

---

## 5. Status Flow

```
[New Request]
     |
  Submitted --> Pending Approval --> Rejected
                    | (all steps approved)
                  Active  (advance disbursed)
                    |
       +------------+------------------+
  Reimbursement Requests          Clearing Request
  (many, float restored)          (one, closes petty cash)
       |                               |
  Reimbursed --> continues        Cleared --> Closed
                                  (eligible for new PC)
```

---

## 6. Approval Workflow (Dynamic, Condition-Based)

### Master: DCT_APPROVAL_TEMPLATES
One active workflow per request type (MODULE_CODE = PETTY_CASH).

### Detail: DCT_APPROVAL_STEPS
Steps fire in sequence; steps with unmet conditions are skipped.

| Condition Type | Description |
|---|---|
| `ALWAYS` | Step always fires |
| `AMOUNT` | Fires when request amount meets operator + threshold |
| `TYPE_FILTER` | Fires when PC type matches the filter value |
| `COMBINED` | Amount AND type filter both must be true |
| `CUSTOM` | PL/SQL function name returning BOOLEAN |

### Default Configuration

**Workflow A — Petty Cash Advance:**

| Step | Role | Condition |
|---|---|---|
| 1 | Manager | Always |
| 2 | AP_PETTY_CASH_ADMIN | Amount >= 5,000 AED |
| 3 | Finance Director | Amount >= 20,000 AED |
| 4 | AP_PETTY_CASH_ADMIN | PC Type = PERMANENT |

**Workflow B — Reimbursement:**

| Step | Role | Condition |
|---|---|---|
| 1 | Manager | Always |
| 2 | AP_PETTY_CASH_ADMIN | Always |

**Workflow C — Clearing:**

| Step | Role | Condition |
|---|---|---|
| 1 | Manager | Always |
| 2 | AP_PETTY_CASH_ADMIN | Always |

---

## 7. Budget Coding

Applied to every request (petty cash, reimbursement, clearing).
- Coding type selected at **request level** (all lines follow same type)
- All budget line amounts must sum to the request total
- Two types: **GL Level** or **Project Level**

### GL Level — DCT_GL_CODE_COMBINATIONS (cascading LOVs)

| Cascade Order | Segment |
|---|---|
| 1 | Entity Code |
| 2 | Appropriation |
| 3 | Cost Center |
| 4 | Entity Specific |
| 5 | Budget Group Code |
| 6 | Account |
| 7 | IC |
| 8 | Future1 |
| 9 | Future2 |

### Project Level — DCT_PROJECT_BUDGET_V

| Field | LOV Level |
|---|---|
| Project Number | 1 |
| Task Number | 2 (filtered by Project) |
| Expenditure Type | 3 (filtered by Task) |

Budget balance (Budget / Actual / Encumbrance / Fund Available) displayed inline after selection.
Fund Available validation controlled by `BUDGET_VALIDATION_MODE` module setting (HARD = block / SOFT = warn).

---

## 8. Data Model

### Reference Tables
| Table | Purpose |
|---|---|
| `DCT_GL_CODE_COMBINATIONS` | Valid GL segment combinations (LOV source) |
| `DCT_PROJECT_BUDGET_V` | Project/task/expenditure with budget balances (view) |
| `DCT_MODULE_SETTINGS` | Admin-configurable module behaviour |
| `DCT_APPROVAL_TEMPLATES` | Workflow definitions (master) |
| `DCT_APPROVAL_STEPS` | Step definitions per workflow (detail) |

### Transaction Tables
| Table | Purpose |
|---|---|
| `DCT_PETTY_CASH` | One record per employee advance |
| `DCT_PC_BUDGET_LINES` | Budget coding lines for the advance |
| `DCT_PC_REIMBURSEMENTS` | Reimbursement requests |
| `DCT_PC_REIMB_BUDGET_LINES` | Budget coding lines per reimbursement |
| `DCT_PC_CLEARING` | Clearing request (closes petty cash) |
| `DCT_PC_CLEAR_BUDGET_LINES` | Budget coding lines per clearing |
| `DCT_PC_ATTACHMENTS` | Documents for any request type |

### Shared V2 Framework
| Object | Purpose |
|---|---|
| `DCT_APPROVAL_INSTANCES` | Runtime approval records |
| `DCT_APPROVAL_ACTIONS` | Approval decisions (approve/reject/comment) |
| `DCT_NOTIFY` package | Notifications |
| `DCT_AUTH` package | Authentication and session |

---

## 9. Module Settings

| Setting Key | Type | Default | Description |
|---|---|---|---|
| `BUDGET_VALIDATION_MODE` | SELECT | SOFT | HARD = block if over budget / SOFT = warn |
| `ALLOW_MULTIPLE_PC` | BOOLEAN | N | Allow > 1 active PC per employee |
| `MAX_PC_PER_EMPLOYEE` | NUMBER | 1 | Max active PC per employee |
| `MAX_PC_AMOUNT` | NUMBER | (null) | Max advance amount (null = no limit) |
| `FISCAL_YEAR_START_MONTH` | NUMBER | 1 | Month fiscal year starts |
| `SHOW_CLOSING_BANNER` | BOOLEAN | Y | Show deadline banner |
| `TEMP_PC_CLOSING_DEADLINE_MSG` | TEXT | (empty) | Banner message text |

---

## 10. Notifications

| Trigger | Recipients |
|---|---|
| New petty cash submitted | Manager + AP_PETTY_CASH_ADMIN |
| Request approved / rejected | Employee |
| New reimbursement submitted | AP_PETTY_CASH_ADMIN |
| Reimbursement approved / rejected | Employee |
| New clearing submitted | AP_PETTY_CASH_ADMIN |
| Clearing approved / closed | Employee |
| Fiscal year deadline reminder | Employees with active Temporary PC |

*(All via DCT_NOTIFY shared V2 framework)*
