# APEX Page Plan — Petty Cash (App 201)
**App ID:** 201 | **Schema:** PROD | **Theme:** Universal Theme 42 | **Date:** 2026-05-13

---

## Application Overview

| Property | Value |
|---|---|
| App ID | 201 |
| App Name | Petty Cash — DCT |
| Schema | PROD |
| Auth Scheme | DCT_AUTH (custom, same as App 200) |
| Theme | Universal Theme 42 |
| Theme Style | Oracle Fusion (custom CSS) |
| Language | English (AR labels ready for future) |
| Session State | APEX Application Session |

---

## Application Items

| Item Name | Type | Description |
|---|---|---|
| `APP_USER_ID` | Number | Logged-in user's DCT_USERS.USER_ID |
| `APP_EMP_NUM` | Varchar2 | Employee number from DCT_USERS.EMPLOYEE_NUMBER |
| `APP_EMP_NAME` | Varchar2 | Display name from DCT_USERS.DISPLAY_NAME |
| `APP_ORG_ID` | Number | User's primary org ID |
| `APP_IS_PC_ADMIN` | Varchar2(1) | Y if user has AP_PETTY_CASH_ADMIN role |
| `APP_IS_MANAGER` | Varchar2(1) | Y if user has MANAGER role |
| `APP_IS_ADMIN` | Varchar2(1) | Y if user has ADMIN role |
| `APP_ACTIVE_PC_ID` | Number | PK of user's current active petty cash (null if none) |
| `APP_ACTIVE_PC_COUNT` | Number | Count of active petty cash for current user |
| `APP_PENDING_APPROVAL_COUNT` | Number | Count of items pending this user's approval |

---

## Authorization Schemes

| Scheme Name | Type | Expression |
|---|---|---|
| `IS_EMPLOYEE` | PL/SQL Function | `RETURN dct_auth.has_role('EMPLOYEE', :APP_USER);` |
| `IS_MANAGER` | PL/SQL Function | `RETURN :APP_IS_MANAGER = 'Y';` |
| `IS_PC_ADMIN` | PL/SQL Function | `RETURN :APP_IS_PC_ADMIN = 'Y';` |
| `IS_ADMIN` | PL/SQL Function | `RETURN :APP_IS_ADMIN = 'Y';` |
| `IS_MANAGER_OR_ADMIN` | PL/SQL Function | `RETURN :APP_IS_MANAGER = 'Y' OR :APP_IS_PC_ADMIN = 'Y';` |
| `IS_OWN_PC` | PL/SQL Function | Checks `DCT_PETTY_CASH.USER_ID = :APP_USER_ID` for current PC_ID |

---

## Page Inventory

| Page | Name | Type | Auth | Primary Table/View |
|---|---|---|---|---|
| 0 | Global Page | Global | — | — |
| 1 | Home Dashboard | Dashboard | Authenticated | DCT_PC_SUMMARY_V |
| 2 | My Petty Cash | IR | Authenticated | DCT_PC_SUMMARY_V |
| 3 | Petty Cash Request | Form | Authenticated | DCT_PETTY_CASH |
| 4 | Reimbursement Requests | IR + Modal | Authenticated | DCT_PC_REIMBURSEMENTS |
| 5 | Reimbursement Detail | Form | Authenticated | DCT_PC_REIMBURSEMENTS |
| 6 | Clearing Request | Form | Authenticated | DCT_PC_CLEARING |
| 7 | Approve / Reject | IR + Form | IS_MANAGER_OR_ADMIN | DCT_APPROVAL_INSTANCES |
| 8 | All Petty Cash | IR | IS_PC_ADMIN | DCT_PC_ADMIN_V |
| 9 | All Reimbursements | IR | IS_PC_ADMIN | DCT_PC_REIMBURSEMENTS |
| 10 | All Clearings | IR | IS_PC_ADMIN | DCT_PC_CLEARING |
| 11 | GL Code Combinations | IG | IS_PC_ADMIN | DCT_GL_CODE_COMBINATIONS |
| 12 | Approval Rules | Master-Detail | IS_ADMIN | DCT_APPROVAL_TEMPLATES / DCT_APPROVAL_STEPS |
| 13 | Module Settings | IG | IS_ADMIN | DCT_MODULE_SETTINGS |
| 9999 | Login | Login | Public | — |

---

## Page 0 — Global Page

### Regions
| Region | Type | Purpose |
|---|---|---|
| Navigation Bar | Navigation | Top bar: App name, user name, logout, notification bell |
| Notification Badge | PL/SQL Dynamic Content | Count of unread notifications from DCT_NOTIFICATIONS |

### Application Processes (Before Header)
```sql
-- Process: SET_APP_ITEMS
-- Fires: On New Session
DECLARE
  v_user_id    NUMBER;
  v_emp_num    VARCHAR2(50);
  v_emp_name   VARCHAR2(200);
  v_org_id     NUMBER;
BEGIN
  SELECT u.user_id, u.employee_number, u.display_name, u.org_id
  INTO   v_user_id, v_emp_num, v_emp_name, v_org_id
  FROM   prod.dct_users u
  WHERE  UPPER(u.username) = UPPER(:APP_USER);

  :APP_USER_ID  := v_user_id;
  :APP_EMP_NUM  := v_emp_num;
  :APP_EMP_NAME := v_emp_name;
  :APP_ORG_ID   := v_org_id;

  :APP_IS_PC_ADMIN := CASE WHEN prod.dct_auth.has_role('AP_PETTY_CASH_ADMIN',:APP_USER) THEN 'Y' ELSE 'N' END;
  :APP_IS_MANAGER  := CASE WHEN prod.dct_auth.has_role('MANAGER',:APP_USER)              THEN 'Y' ELSE 'N' END;
  :APP_IS_ADMIN    := CASE WHEN prod.dct_auth.has_role('ADMIN',:APP_USER)                THEN 'Y' ELSE 'N' END;

  SELECT COUNT(*), MAX(CASE WHEN status = 'ACTIVE' THEN pc_id END)
  INTO   :APP_ACTIVE_PC_COUNT, :APP_ACTIVE_PC_ID
  FROM   prod.dct_petty_cash
  WHERE  user_id = v_user_id
  AND    status  = 'ACTIVE';

  SELECT COUNT(*)
  INTO   :APP_PENDING_APPROVAL_COUNT
  FROM   prod.dct_approval_instances ai
  JOIN   prod.dct_approval_steps     s  ON s.template_id = ai.template_id
                                       AND s.step_seq    = ai.current_step_seq
  JOIN   prod.dct_user_roles         ur ON ur.role_id    = s.required_role_id
  JOIN   prod.dct_users              u2 ON u2.user_id    = ur.user_id
  WHERE  ai.overall_status = 'PENDING'
  AND    UPPER(u2.username) = UPPER(:APP_USER);
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
```

---

## Page 1 — Home Dashboard

**Purpose:** Employee landing page. Shows active petty cash status, pending counts, closing banner.

### Regions

#### Region 1: Closing Deadline Banner
- **Type:** PL/SQL Dynamic Content
- **Condition:** `SHOW_CLOSING_BANNER = 'Y'` AND `TEMP_PC_CLOSING_DEADLINE_MSG IS NOT NULL` AND user has active Temporary PC
- **Query:**
```sql
DECLARE
  v_msg  VARCHAR2(500);
  v_show VARCHAR2(1);
BEGIN
  SELECT setting_value INTO v_show
  FROM   prod.dct_module_settings
  WHERE  module_id  = (SELECT module_id FROM prod.dct_modules WHERE module_code = 'PETTY_CASH')
  AND    setting_key = 'SHOW_CLOSING_BANNER';

  IF v_show = 'Y' THEN
    SELECT setting_value INTO v_msg
    FROM   prod.dct_module_settings
    WHERE  module_id  = (SELECT module_id FROM prod.dct_modules WHERE module_code = 'PETTY_CASH')
    AND    setting_key = 'TEMP_PC_CLOSING_DEADLINE_MSG';
    IF v_msg IS NOT NULL THEN
      htp.p('<div class="t-Alert t-Alert--warning">' || apex_escape.html(v_msg) || '</div>');
    END IF;
  END IF;
END;
```

#### Region 2: My Petty Cash Card
- **Type:** Classic Report (styled as card)
- **Source:**
```sql
SELECT
  pc_number,
  pc_type,
  TO_CHAR(advance_amount, 'FM999,999,990.00') || ' AED' AS advance_amount,
  TO_CHAR(total_reimbursed, 'FM999,999,990.00') || ' AED' AS total_reimbursed,
  TO_CHAR(current_float_balance, 'FM999,999,990.00') || ' AED' AS float_balance,
  display_status,
  TO_CHAR(due_date, 'DD-Mon-YYYY') AS due_date
FROM prod.dct_pc_summary_v
WHERE user_id = :APP_USER_ID
AND   status  = 'ACTIVE'
```
- **No Data Message:** "You have no active petty cash. Click 'Request Petty Cash' to get started."
- **Button:** "Request Petty Cash" → Page 3 (hidden if active PC exists and ALLOW_MULTIPLE_PC = N)

#### Region 3: Quick Stats Bar
- **Type:** Cards / Static Content (4 KPI tiles)

| Tile | Query |
|---|---|
| Active Petty Cash | `SELECT COUNT(*) FROM prod.dct_petty_cash WHERE user_id = :APP_USER_ID AND status = 'ACTIVE'` |
| Pending Reimbursements | `SELECT COUNT(*) FROM prod.dct_pc_reimbursements r JOIN prod.dct_petty_cash p ON p.pc_id = r.pc_id WHERE p.user_id = :APP_USER_ID AND r.status = 'PENDING_APPROVAL'` |
| Pending Approvals (mine) | `:APP_PENDING_APPROVAL_COUNT` (from app item) |
| Total Float Balance | `SELECT NVL(SUM(current_float_balance),0) FROM prod.dct_pc_summary_v WHERE user_id = :APP_USER_ID AND status = 'ACTIVE'` |

#### Region 4: Recent Activity
- **Type:** Classic Report
- **Source:**
```sql
SELECT
  ai.source_record_ref         AS request_ref,
  ai.source_module             AS module,
  aa.action                    AS action_taken,
  aa.comments,
  TO_CHAR(aa.actioned_at,'DD-Mon-YYYY HH24:MI') AS action_date,
  u.display_name               AS actioned_by
FROM prod.dct_approval_instances ai
JOIN prod.dct_approval_actions   aa ON aa.instance_id = ai.instance_id
JOIN prod.dct_users              u  ON u.user_id      = aa.actioned_by
WHERE ai.submitted_by = :APP_USER_ID
ORDER BY aa.actioned_at DESC
FETCH FIRST 8 ROWS ONLY
```

### Buttons
| Button | Action |
|---|---|
| Request Petty Cash | Redirect to Page 3 |
| New Reimbursement | Redirect to Page 5 (only if active PC exists) |
| Submit Clearing | Redirect to Page 6 (only if active PC exists) |

---

## Page 2 — My Petty Cash

**Purpose:** Full history of employee's petty cash records.

### Region: My Petty Cash (Interactive Report)
```sql
SELECT
  pc_number,
  pc_type,
  TO_CHAR(advance_amount,'FM999,999,990.00') AS advance_amount,
  TO_CHAR(total_reimbursed,'FM999,999,990.00') AS reimbursed,
  TO_CHAR(current_float_balance,'FM999,999,990.00') AS float_balance,
  display_status                              AS status,
  fiscal_year,
  TO_CHAR(disbursed_date,'DD-Mon-YYYY')      AS disbursed,
  TO_CHAR(due_date,'DD-Mon-YYYY')            AS due_date,
  pc_id
FROM prod.dct_pc_summary_v
WHERE user_id = :APP_USER_ID
ORDER BY created_at DESC
```

### Link Column
- PC Number → Page 3 (view/edit mode, passing PC_ID)

### Buttons
- "New Petty Cash Request" → Page 3 (disabled if at MAX_PC_PER_EMPLOYEE limit)

---

## Page 3 — Petty Cash Request (Create / View)

**Purpose:** Create a new petty cash advance request or view an existing one.

### Page Items
| Item | Type | Source | Notes |
|---|---|---|---|
| `P3_PC_ID` | Hidden | URL parameter | |
| `P3_PC_NUMBER` | Display Only | DCT_PETTY_CASH | Auto-generated on save |
| `P3_PC_TYPE` | Select List | TEMPORARY \| PERMANENT | Required |
| `P3_AMOUNT` | Number Field | DCT_PETTY_CASH | Required, > 0, <= MAX_PC_AMOUNT if set |
| `P3_PURPOSE` | Textarea | DCT_PETTY_CASH | Required |
| `P3_DUE_DATE` | Date Picker | DCT_PETTY_CASH | Required for Temporary |
| `P3_CODING_TYPE` | Radio Group | GL \| PROJECT | Required |
| `P3_STATUS` | Display Only | DCT_PETTY_CASH | Read-only |
| `P3_FISCAL_YEAR` | Display Only | Computed | EXTRACT(YEAR FROM SYSDATE) |

### Region: Budget Lines (Interactive Grid)
**Source Table:** `PROD.DCT_PC_BUDGET_LINES` where `PC_ID = :P3_PC_ID`

**Columns (GL mode — shown when P3_CODING_TYPE = 'GL'):**

| Column | Type | LOV / Notes |
|---|---|---|
| `LINE_NUM` | Hidden | Auto sequence |
| `AMOUNT` | Number | Required |
| `ENTITY_CODE` | Select List | `SELECT DISTINCT entity_code FROM prod.dct_gl_code_combinations WHERE is_active='Y' ORDER BY 1` |
| `APPROPRIATION` | Select List | Filtered by ENTITY_CODE (cascade LOV) |
| `COST_CENTER` | Select List | Filtered by APPROPRIATION (cascade LOV) |
| `ENTITY_SPECIFIC` | Select List | Filtered by COST_CENTER |
| `BUDGET_GROUP_CODE` | Select List | Filtered by ENTITY_SPECIFIC |
| `ACCOUNT` | Select List | Filtered by BUDGET_GROUP_CODE |
| `IC` | Select List | Filtered by ACCOUNT |
| `FUTURE1` | Select List | Filtered by IC |
| `FUTURE2` | Select List | Filtered by FUTURE1 |
| `CC_ID` | Hidden | Auto-resolved from segment selection |
| `DESCRIPTION` | Text | Optional |

**Cascade LOV Queries (example — Appropriation):**
```sql
SELECT DISTINCT appropriation d, appropriation r
FROM   prod.dct_gl_code_combinations
WHERE  entity_code = :ENTITY_CODE
AND    is_active   = 'Y'
AND    (end_date IS NULL OR end_date >= SYSDATE)
ORDER  BY 1
```
*(Repeat pattern for each downstream segment)*

**CC_ID Resolution (Dynamic Action on FUTURE2 change):**
```sql
SELECT cc_id
FROM   prod.dct_gl_code_combinations
WHERE  entity_code        = :ENTITY_CODE
AND    appropriation      = :APPROPRIATION
AND    cost_center        = :COST_CENTER
AND    entity_specific    = :ENTITY_SPECIFIC
AND    budget_group_code  = :BUDGET_GROUP_CODE
AND    account            = :ACCOUNT
AND    NVL(ic,'~')       = NVL(:IC,'~')
AND    NVL(future1,'~') = NVL(:FUTURE1,'~')
AND    NVL(future2,'~') = NVL(:FUTURE2,'~')
AND    is_active          = 'Y'
```

**Columns (Project mode — shown when P3_CODING_TYPE = 'PROJECT'):**

| Column | Type | LOV / Notes |
|---|---|---|
| `AMOUNT` | Number | Required |
| `PROJECT_NUMBER` | Select List | `SELECT project_number d, project_number r FROM prod.dct_project_budget_v GROUP BY project_number ORDER BY 1` |
| `TASK_NUMBER` | Select List | Cascade on PROJECT_NUMBER |
| `EXPENDITURE_TYPE` | Select List | Cascade on PROJECT_NUMBER + TASK_NUMBER |
| `BUDGET` | Display Only | From DCT_PROJECT_BUDGET_V |
| `ACTUAL` | Display Only | From DCT_PROJECT_BUDGET_V |
| `FUND_AVAILABLE` | Display Only | Highlighted red if amount > fund_available |
| `DESCRIPTION` | Text | Optional |

### Region: Attachments
- **Type:** APEX_UTIL file upload with inline preview
- **Table:** `PROD.DCT_PC_ATTACHMENTS` (REQUEST_TYPE='PC', REQUEST_ID=P3_PC_ID)

### Validations
| Validation | Rule |
|---|---|
| Budget lines required | IG must have at least 1 row |
| Lines sum = amount | SUM(budget line amounts) = P3_AMOUNT |
| Max amount check | P3_AMOUNT <= MAX_PC_AMOUNT module setting (if not null) |
| PC limit check | Active PC count < MAX_PC_PER_EMPLOYEE |
| Due date required | If P3_PC_TYPE = 'TEMPORARY' then due date must be set |
| Fund available (HARD mode) | If BUDGET_VALIDATION_MODE='HARD', block if any project line amount > fund_available |

### Processes
| Process | Type | Action |
|---|---|---|
| Save Petty Cash | PL/SQL | Insert/Update DCT_PETTY_CASH + budget lines |
| Generate PC Number | PL/SQL | `'PC-' || TO_CHAR(SYSDATE,'YYYY') || '-' || LPAD(seq,5,'0')` |
| Submit for Approval | PL/SQL | Set STATUS='SUBMITTED', create DCT_APPROVAL_INSTANCES record, send notification |
| Send Notification | DCT_NOTIFY | Notify Manager + AP_PETTY_CASH_ADMIN |

### Buttons
| Button | Condition | Action |
|---|---|---|
| Save Draft | STATUS = DRAFT | Save without submitting |
| Submit | STATUS = DRAFT | Validate + submit for approval |
| Cancel | Always | Redirect to Page 2 |
| Delete | STATUS = DRAFT | Delete record + redirect |

---

## Page 4 — Reimbursement Requests

**Purpose:** List of employee's reimbursement requests with option to create new.

### Region 1: Active Petty Cash Summary (Static Content)
- Shows: PC Number, Type, Advance Amount, Float Balance, Status
- Query: `SELECT * FROM prod.dct_pc_summary_v WHERE pc_id = :APP_ACTIVE_PC_ID`

### Region 2: My Reimbursements (Interactive Report)
```sql
SELECT
  r.reimb_number,
  TO_CHAR(r.amount,'FM999,999,990.00') AS amount,
  r.purpose,
  r.status,
  TO_CHAR(r.submitted_at,'DD-Mon-YYYY') AS submitted,
  r.coding_type,
  r.reimb_id
FROM prod.dct_pc_reimbursements r
JOIN prod.dct_petty_cash         p ON p.pc_id = r.pc_id
WHERE p.user_id = :APP_USER_ID
ORDER BY r.created_at DESC
```

### Link: REIMB_NUMBER → Page 5 (passing REIMB_ID)

### Buttons
- "New Reimbursement" → Page 5 (new mode, passing APP_ACTIVE_PC_ID)

---

## Page 5 — Reimbursement Detail

**Purpose:** Create or view a reimbursement request with budget lines and attachments.

### Page Items
| Item | Type | Notes |
|---|---|---|
| `P5_REIMB_ID` | Hidden | URL parameter |
| `P5_PC_ID` | Hidden | Parent petty cash |
| `P5_REIMB_NUMBER` | Display Only | Auto-generated |
| `P5_AMOUNT` | Number | Required |
| `P5_PURPOSE` | Textarea | Required |
| `P5_CODING_TYPE` | Radio Group | GL \| PROJECT (inherited from parent PC, can be changed) |
| `P5_STATUS` | Display Only | |

### Region: Budget Lines (Interactive Grid)
**Source:** `PROD.DCT_PC_REIMB_BUDGET_LINES` where `REIMB_ID = :P5_REIMB_ID`

Same cascade LOV structure as Page 3 (GL and Project modes).

### Region: Attachments
- **Table:** `PROD.DCT_PC_ATTACHMENTS` (REQUEST_TYPE='REIMB', REQUEST_ID=P5_REIMB_ID)

### Validations
- Budget lines sum = P5_AMOUNT
- Parent PC must be in ACTIVE status
- Parent PC must not have a submitted/active clearing request

### Processes
| Process | Action |
|---|---|
| Save Reimbursement | Insert/Update DCT_PC_REIMBURSEMENTS + budget lines |
| Generate REIMB Number | `'RMB-' || TO_CHAR(SYSDATE,'YYYY') || '-' || LPAD(seq,5,'0')` |
| Submit | Set STATUS='SUBMITTED', create approval instance, notify |

---

## Page 6 — Clearing Request

**Purpose:** Employee closes/settles their petty cash advance.

### Page Items
| Item | Type | Notes |
|---|---|---|
| `P6_CLEARING_ID` | Hidden | URL parameter |
| `P6_PC_ID` | Hidden | Parent petty cash |
| `P6_CLEARING_NUMBER` | Display Only | Auto-generated |
| `P6_AMOUNT_SPENT` | Number (computed) | = SUM of budget line amounts (read-only) |
| `P6_AMOUNT_REFUNDED` | Number | Declared unspent cash returned to company |
| `P6_CODING_TYPE` | Radio Group | GL \| PROJECT |
| `P6_STATUS` | Display Only | |

### Region: Active PC Summary
Shows: PC Number, Advance Amount, Total Reimbursed, Current Float Balance

### Region: Expense Budget Lines (Interactive Grid)
**Source:** `PROD.DCT_PC_CLEAR_BUDGET_LINES` where `CLEARING_ID = :P6_CLEARING_ID`

Same cascade LOV structure as Page 3.

### Region: Attachments
- **Table:** `PROD.DCT_PC_ATTACHMENTS` (REQUEST_TYPE='CLEAR', REQUEST_ID=P6_CLEARING_ID)

### Validations
| Validation | Rule |
|---|---|
| Total check | P6_AMOUNT_SPENT + P6_AMOUNT_REFUNDED = Parent PC advance amount |
| P6_AMOUNT_REFUNDED | Must be >= 0 |
| No other clearing | Parent PC must not already have an active clearing request |
| No pending reimbursements | Parent PC must not have PENDING_APPROVAL reimbursements |

### Processes
| Process | Action |
|---|---|
| Save Clearing | Insert/Update DCT_PC_CLEARING + budget lines |
| Generate CLR Number | `'CLR-' || TO_CHAR(SYSDATE,'YYYY') || '-' || LPAD(seq,5,'0')` |
| Submit | Set STATUS='SUBMITTED', create approval instance, notify |
| Close PC on Approval | On final approval: set DCT_PETTY_CASH.STATUS='CLOSED', CLOSED_DATE=SYSDATE |

---

## Page 7 — Approve / Reject

**Purpose:** Manager and AP_PETTY_CASH_ADMIN approval queue for all pending requests.

**Auth:** IS_MANAGER_OR_ADMIN

### Region: Pending Approvals (Interactive Report)
```sql
SELECT
  ai.instance_id,
  ai.source_record_ref                               AS request_ref,
  ai.source_module                                   AS request_type,
  u.display_name                                     AS submitted_by,
  TO_CHAR(ai.submitted_at,'DD-Mon-YYYY')             AS submitted_date,
  s.step_name                                        AS current_step,
  CASE ai.source_module
    WHEN 'PETTY_CASH'    THEN pc.amount
    WHEN 'REIMBURSEMENT' THEN r.amount
    WHEN 'CLEARING'      THEN c.amount_spent
  END                                                AS amount,
  ai.overall_status
FROM prod.dct_approval_instances ai
JOIN prod.dct_approval_steps     s   ON s.template_id = ai.template_id
                                    AND s.step_seq    = ai.current_step_seq
JOIN prod.dct_user_roles         ur  ON ur.role_id    = s.required_role_id
JOIN prod.dct_users              req ON req.user_id   = ai.submitted_by
JOIN prod.dct_users              u   ON u.user_id     = req.user_id
LEFT JOIN prod.dct_petty_cash    pc  ON pc.pc_id           = ai.source_record_id AND ai.source_module = 'PETTY_CASH'
LEFT JOIN prod.dct_pc_reimbursements r ON r.reimb_id       = ai.source_record_id AND ai.source_module = 'REIMBURSEMENT'
LEFT JOIN prod.dct_pc_clearing   c   ON c.clearing_id      = ai.source_record_id AND ai.source_module = 'CLEARING'
WHERE ai.overall_status = 'PENDING'
AND   ur.role_id IN (
  SELECT role_id FROM prod.dct_user_roles
  WHERE  user_id = :APP_USER_ID AND is_active = 'Y'
)
ORDER BY ai.submitted_at
```

### Approval Form (Modal Dialog)
Triggered from IR row action.

**Items:**
- `P7_INSTANCE_ID` — Hidden
- `P7_ACTION` — Radio: APPROVED | REJECTED | RETURNED
- `P7_COMMENTS` — Textarea (required on REJECTED/RETURNED)

**Process: Record Approval Action**
```sql
INSERT INTO prod.dct_approval_actions
  (instance_id, step_id, actioned_by, action, comments)
VALUES
  (:P7_INSTANCE_ID, :CURRENT_STEP_ID, :APP_USER_ID, :P7_ACTION, :P7_COMMENTS);

-- Advance to next step or mark complete
-- (calls DCT_AUTH approval engine procedure)
prod.dct_auth.process_approval_action(
  p_instance_id => :P7_INSTANCE_ID,
  p_action      => :P7_ACTION,
  p_user_id     => :APP_USER_ID
);
```

---

## Page 8 — All Petty Cash (Admin)

**Auth:** IS_PC_ADMIN

### Region: All Petty Cash (Interactive Report)
```sql
SELECT
  pc_number,
  employee_name,
  employee_number,
  org_name,
  pc_type,
  TO_CHAR(advance_amount,'FM999,999,990.00')       AS advance_amount,
  TO_CHAR(total_reimbursed,'FM999,999,990.00')     AS reimbursed,
  TO_CHAR(cleared_amount,'FM999,999,990.00')       AS cleared,
  TO_CHAR(refunded_amount,'FM999,999,990.00')      AS refunded,
  status,
  clearing_status,
  fiscal_year,
  TO_CHAR(disbursed_date,'DD-Mon-YYYY')            AS disbursed,
  TO_CHAR(closed_date,'DD-Mon-YYYY')               AS closed,
  pc_id
FROM prod.dct_pc_admin_v
ORDER BY created_at DESC
```

**Filters (IR search bar):** Status, PC Type, Fiscal Year, Org Name, Employee Number
**Export:** Excel, CSV

### Action: Disburse
- Button visible for APPROVED records
- Sets STATUS='ACTIVE', DISBURSED_DATE=SYSDATE
- Sends notification to employee

---

## Page 9 — All Reimbursements (Admin)

**Auth:** IS_PC_ADMIN

### Region: All Reimbursements (Interactive Report)
```sql
SELECT
  r.reimb_number,
  u.display_name                                   AS employee_name,
  u.employee_number,
  o.org_name_en                                    AS org_name,
  p.pc_number,
  TO_CHAR(r.amount,'FM999,999,990.00')             AS amount,
  r.purpose,
  r.status,
  r.coding_type,
  TO_CHAR(r.submitted_at,'DD-Mon-YYYY')            AS submitted,
  r.reimb_id,
  r.pc_id
FROM prod.dct_pc_reimbursements r
JOIN prod.dct_petty_cash         p  ON p.pc_id   = r.pc_id
JOIN prod.dct_users              u  ON u.user_id  = p.user_id
LEFT JOIN prod.dct_organizations o  ON o.org_id   = p.org_id
ORDER BY r.created_at DESC
```

---

## Page 10 — All Clearings (Admin)

**Auth:** IS_PC_ADMIN

### Region: All Clearings (Interactive Report)
```sql
SELECT
  c.clearing_number,
  u.display_name                                   AS employee_name,
  u.employee_number,
  p.pc_number,
  p.pc_type,
  TO_CHAR(p.amount,'FM999,999,990.00')             AS advance_amount,
  TO_CHAR(c.amount_spent,'FM999,999,990.00')       AS amount_spent,
  TO_CHAR(c.amount_refunded,'FM999,999,990.00')    AS amount_refunded,
  c.status,
  c.coding_type,
  TO_CHAR(c.submitted_at,'DD-Mon-YYYY')            AS submitted,
  c.clearing_id,
  c.pc_id
FROM prod.dct_pc_clearing        c
JOIN prod.dct_petty_cash          p  ON p.pc_id   = c.pc_id
JOIN prod.dct_users               u  ON u.user_id  = p.user_id
ORDER BY c.created_at DESC
```

---

## Page 11 — GL Code Combinations

**Auth:** IS_PC_ADMIN

### Region: GL Code Combinations (Interactive Grid)
**Source Table:** `PROD.DCT_GL_CODE_COMBINATIONS`

**Columns:**

| Column | Type | Editable |
|---|---|---|
| CC_ID | Hidden PK | No |
| ENTITY_CODE | Text | Yes |
| APPROPRIATION | Text | Yes |
| COST_CENTER | Text | Yes |
| ENTITY_SPECIFIC | Text | Yes |
| BUDGET_GROUP_CODE | Text | Yes |
| ACCOUNT | Text | Yes |
| IC | Text | Yes |
| FUTURE1 | Text | Yes |
| FUTURE2 | Text | Yes |
| IS_ACTIVE | Select (Y/N) | Yes |
| START_DATE | Date | Yes |
| END_DATE | Date | Yes |

**IG Operations:** Insert, Update, Delete (with confirmation)
**Toolbar:** Save, Add Row, Delete Selected, Search, Download

---

## Page 12 — Approval Rules (Master-Detail)

**Auth:** IS_ADMIN

### Master Region: Approval Workflows (Interactive Report)
```sql
SELECT
  t.template_id,
  t.template_code,
  t.template_name,
  t.request_type,
  t.is_sequential,
  t.auto_approve_days,
  t.is_active
FROM prod.dct_approval_templates t
JOIN prod.dct_modules             m ON m.module_id = t.module_id
WHERE m.module_code = 'PETTY_CASH'
ORDER BY t.request_type, t.template_name
```

### Detail Region: Approval Steps (Interactive Grid)
**Filtered by selected master TEMPLATE_ID**

```sql
SELECT
  step_id,
  step_seq,
  step_name,
  step_type,
  required_role_id,
  escalation_days,
  is_mandatory,
  allow_skip,
  condition_type,
  amount_operator,
  amount_threshold,
  type_filter,
  custom_condition,
  is_active
FROM prod.dct_approval_steps
WHERE template_id = :P12_TEMPLATE_ID
ORDER BY step_seq
```

**Detail IG Columns:**

| Column | Type | LOV |
|---|---|---|
| STEP_SEQ | Number | |
| STEP_NAME | Text | |
| REQUIRED_ROLE_ID | Select List | `SELECT role_name_en, role_id FROM prod.dct_roles WHERE is_active='Y' ORDER BY 1` |
| CONDITION_TYPE | Select List | ALWAYS \| AMOUNT \| TYPE_FILTER \| COMBINED \| CUSTOM |
| AMOUNT_OPERATOR | Select List | > \| >= \| < \| <= \| = (hidden if CONDITION_TYPE=ALWAYS/TYPE_FILTER/CUSTOM) |
| AMOUNT_THRESHOLD | Number | (hidden if CONDITION_TYPE=ALWAYS/TYPE_FILTER/CUSTOM) |
| TYPE_FILTER | Text | (hidden if CONDITION_TYPE=ALWAYS/AMOUNT/CUSTOM) |
| CUSTOM_CONDITION | Text | (hidden if CONDITION_TYPE != CUSTOM) |
| IS_MANDATORY | Select (Y/N) | |
| ALLOW_SKIP | Select (Y/N) | |
| ESCALATION_DAYS | Number | |
| IS_ACTIVE | Select (Y/N) | |

**Dynamic Actions:** Show/hide condition columns based on CONDITION_TYPE selection.

---

## Page 13 — Module Settings

**Auth:** IS_ADMIN

### Region: Module Settings (Interactive Grid)
```sql
SELECT
  s.setting_id,
  s.setting_key,
  s.setting_label,
  s.setting_description,
  s.value_type,
  s.allowed_values,
  s.default_value,
  s.setting_value,
  s.effective_date
FROM prod.dct_module_settings s
JOIN prod.dct_modules          m ON m.module_id = s.module_id
WHERE m.module_code = 'PETTY_CASH'
ORDER BY s.setting_key
```

**Editable columns:** SETTING_VALUE, EFFECTIVE_DATE only (all others read-only)

**Validation:** On save, validate SETTING_VALUE against VALUE_TYPE:
- BOOLEAN: must be Y or N
- NUMBER: must be numeric
- SELECT: must be one of ALLOWED_VALUES (pipe-split)

**Button:** "Reset to Default" — sets SETTING_VALUE = DEFAULT_VALUE for selected row

---

## Page 9999 — Login

**Type:** Login Page
**Auth:** Public (pre-auth)
**Auth Scheme:** DCT_AUTH custom scheme (redirects to App 200 for SSO if configured)

---

## Navigation Menu (Desktop Navigation)

| Label | Icon | Target | Auth |
|---|---|---|---|
| Home | fa-home | Page 1 | All |
| My Petty Cash | fa-money | Page 2 | All |
| New Request | fa-plus | Page 3 | All |
| Reimbursements | fa-receipt | Page 4 | All |
| Clearing | fa-check-circle | Page 6 | All |
| Approve / Reject | fa-thumbs-up | Page 7 | IS_MANAGER_OR_ADMIN |
| --- Admin --- | | Separator | IS_PC_ADMIN |
| All Petty Cash | fa-list | Page 8 | IS_PC_ADMIN |
| All Reimbursements | fa-list-alt | Page 9 | IS_PC_ADMIN |
| All Clearings | fa-list-ol | Page 10 | IS_PC_ADMIN |
| GL Code Combinations | fa-table | Page 11 | IS_PC_ADMIN |
| --- Config --- | | Separator | IS_ADMIN |
| Approval Rules | fa-sitemap | Page 12 | IS_ADMIN |
| Module Settings | fa-cog | Page 13 | IS_ADMIN |

---

## Sequences Required

```sql
-- Run in PROD schema
CREATE SEQUENCE prod.seq_pc_number   START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE prod.seq_reimb_number START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE prod.seq_clr_number   START WITH 1 INCREMENT BY 1 NOCACHE;
```

---

## Dynamic Actions Summary

| Page | Trigger | Action |
|---|---|---|
| 3, 5, 6 | P_CODING_TYPE change | Show/hide GL columns vs Project columns in budget IG |
| 3, 5, 6 | Each GL segment change | Refresh next cascade LOV |
| 3, 5, 6 | Project LOV changes | Refresh downstream LOVs, display budget balance |
| 3, 5, 6 | Budget IG row amount change | Recalculate total, highlight if over budget |
| 12 | CONDITION_TYPE change | Show/hide AMOUNT_OPERATOR, AMOUNT_THRESHOLD, TYPE_FILTER, CUSTOM_CONDITION columns |
| 7 | P7_ACTION change | Require/optional comments field |

---

## Build Sequence (APEX Builder)

1. Create App 201 with Universal Theme 42
2. Set Authentication Scheme (DCT_AUTH)
3. Create Application Items (13 items)
4. Create Authorization Schemes (6 schemes)
5. Build Page 0 (Global) — app process + nav bar
6. Build Page 9999 (Login)
7. Build Pages 1 → 13 in order
8. Configure Navigation Menu
9. Apply Oracle Fusion CSS (from App 200 shared components)
10. Export via `apex_export.get_application(p_application_id => 201)`
