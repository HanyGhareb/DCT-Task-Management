# APEX Page Plan — Duty Travel App 204
**APEX Version:** 24.2 | **Schema:** PROD | **Date:** 2026-05-16

---

## Shared Architecture

App 204 subscribes to App 200 for:
- **Auth Scheme:** `DCT Auth`
- **App Items (inherited):** `APP_USER_ID`, `APP_EMP_NUM`, `APP_EMP_NAME`, `APP_ORG_ID`, `APP_IS_ADMIN`, `APP_IS_MANAGER`, `APP_PENDING_APPROVAL_COUNT`
- **LOVs (inherited):** `LOV_DCT_EMPLOYEES`, `LOV_DCT_ORGANIZATIONS`, `LOV_YES_NO`, `LOV_ACTIVE_INACTIVE`, `LOV_APPROVAL_STATUS`, `LOV_REQUEST_STATUSES`
- **Auth Schemes (inherited):** `IS_ADMIN`, `IS_MANAGER`, `IS_MANAGER_OR_ADMIN`

### Module-Specific App Items (define locally in App 204)

| Item | Type | Populated in |
|---|---|---|
| `APP_IS_DT_ADMIN` | Varchar2(1) | App Computation (On New Session) |
| `APP_IS_DT_FINANCE` | Varchar2(1) | App Computation (On New Session) |
| `APP_IS_DT_MANAGER` | Varchar2(1) | App Computation (On New Session) |

**Computation SQL (each):**
```sql
-- APP_IS_DT_ADMIN
SELECT CASE WHEN prod.dct_auth.has_role(:APP_USER_ID, 'DT_ADMIN') THEN 'Y' ELSE 'N' END FROM dual

-- APP_IS_DT_FINANCE
SELECT CASE WHEN prod.dct_auth.has_role(:APP_USER_ID, 'DT_FINANCE') THEN 'Y' ELSE 'N' END FROM dual

-- APP_IS_DT_MANAGER
SELECT CASE WHEN prod.dct_auth.has_role(:APP_USER_ID, 'DT_MANAGER') THEN 'Y' ELSE 'N' END FROM dual
```

### Module-Specific Authorization Schemes (define locally in App 204)

| Scheme | Expression (PL/SQL Function Body returning Boolean) |
|---|---|
| `IS_DT_ADMIN` | `RETURN :APP_IS_DT_ADMIN = 'Y';` |
| `IS_DT_FINANCE` | `RETURN :APP_IS_DT_FINANCE = 'Y';` |
| `IS_DT_MANAGER` | `RETURN :APP_IS_DT_MANAGER = 'Y';` |
| `IS_DT_ADMIN_OR_FINANCE` | `RETURN :APP_IS_DT_ADMIN = 'Y' OR :APP_IS_DT_FINANCE = 'Y';` |
| `IS_DT_ADMIN_OR_MANAGER` | `RETURN :APP_IS_DT_ADMIN = 'Y' OR :APP_IS_DT_MANAGER = 'Y';` |

### Module-Specific LOVs (define locally in App 204)

| LOV Name | Query |
|---|---|
| `LOV_DT_MISSION_TYPE` | `SELECT 'Business Mission' d, 'BUSINESS_MISSION' r FROM dual UNION ALL SELECT 'Training', 'TRAINING' FROM dual` |
| `LOV_DT_TRIP_TYPE` | `SELECT 'Internal (UAE)' d, 'INTERNAL' r FROM dual UNION ALL SELECT 'External (International)', 'EXTERNAL' FROM dual` |
| `LOV_DT_STATUS` | `SELECT display_value d, lookup_code r FROM prod.dct_lookup_values lv JOIN prod.dct_lookup_categories lc ON lc.category_id = lv.category_id WHERE lc.category_code = 'DT_REQUEST_STATUS' ORDER BY display_seq` |
| `LOV_DT_EMPLOYEE_GRADE` | `SELECT display_value d, lookup_code r FROM prod.dct_lookup_values lv JOIN prod.dct_lookup_categories lc ON lc.category_id = lv.category_id WHERE lc.category_code = 'DT_EMPLOYEE_GRADE' ORDER BY display_seq` |
| `LOV_DT_DOCUMENT_TYPE` | `SELECT display_value d, lookup_code r FROM prod.dct_lookup_values lv JOIN prod.dct_lookup_categories lc ON lc.category_id = lv.category_id WHERE lc.category_code = 'DT_DOCUMENT_TYPE' ORDER BY display_seq` |
| `LOV_DT_EXPENSE_CATEGORY` | `SELECT 'Per Diem' d,'PER_DIEM' r FROM dual UNION ALL SELECT 'Accommodation','ACCOMMODATION' FROM dual UNION ALL SELECT 'Ticket','TICKET' FROM dual UNION ALL SELECT 'Visa','VISA' FROM dual UNION ALL SELECT 'Local Transport','LOCAL_TRANSPORT' FROM dual UNION ALL SELECT 'Other','OTHER' FROM dual` |
| `LOV_DT_BUDGET_TYPE` | `SELECT 'GL / Cost Centre' d,'GL' r FROM dual UNION ALL SELECT 'Project','PROJECT' FROM dual` |
| `LOV_DT_RATE_STRUCTURE` | `SELECT 'Per Country' d,'PER_COUNTRY' r FROM dual UNION ALL SELECT 'Tier-Based','TIER_BASED' FROM dual UNION ALL SELECT 'Region-Based','REGION_BASED' FROM dual` |
| `LOV_DT_HALF_DAY_POLICY` | `SELECT 'None (full rate every day)' d,'NONE' r FROM dual UNION ALL SELECT 'First & Last day half','FIRST_LAST' FROM dual UNION ALL SELECT 'First day only half','FIRST_ONLY' FROM dual` |
| `LOV_DT_COUNTRIES` | `SELECT country_name_en d, country_code r FROM prod.dt_country_groups WHERE is_active='Y' ORDER BY country_name_en` |

---

## Page 9999 — Login
Standard APEX login page. Authentication via DCT Auth scheme (subscribed from App 200).

---

## Page 0 — Global Page

**Region:** Notification Badge (same pattern as App 200/201/202/203)

```sql
SELECT :APP_PENDING_APPROVAL_COUNT FROM dual
```

**Global Dynamic Action — Refresh Notification Count:**
- Event: Custom `refresh-notif`
- Action: Execute Server-side Code → re-compute `APP_PENDING_APPROVAL_COUNT`

---

## Page 1 — Dashboard

**Auth:** IS_AUTHENTICATED
**Title:** Duty Travel Dashboard

**Region 1 — KPI Cards:**

```sql
-- My Open Requests (IS_AUTHENTICATED — shows own count)
SELECT COUNT(*) FROM prod.dt_requests
WHERE employee_user_id = :APP_USER_ID
AND   status NOT IN ('CLOSED','REJECTED','CANCELLED')

-- My Pending Approvals (IS_DT_MANAGER or IS_DT_ADMIN or IS_DT_FINANCE)
SELECT COUNT(*) FROM prod.dct_approval_instances ai
JOIN prod.dct_approval_steps ast ON ast.step_id = ai.current_step_id
JOIN prod.dct_roles r ON r.role_id = ast.approver_role_id
WHERE ai.status = 'PENDING'
AND   prod.dct_auth.has_role(:APP_USER_ID, r.role_code) = 1
AND   ai.entity_type = 'DT_REQUEST'

-- Upcoming Travel (within 7 days, APPROVED or ADVANCE_PAID)
SELECT COUNT(*) FROM prod.dt_requests
WHERE employee_user_id = :APP_USER_ID
AND   status IN ('APPROVED','ADVANCE_PAID')
AND   departure_date BETWEEN SYSDATE AND SYSDATE + 7

-- Overdue Settlements (TRAVELLED but no SUBMITTED/APPROVED settlement, past deadline)
SELECT COUNT(*) FROM prod.dt_requests r
WHERE r.employee_user_id = :APP_USER_ID
AND   r.status = 'TRAVELLED'
AND   NOT EXISTS (
    SELECT 1 FROM prod.dt_settlement s
    WHERE s.request_id = r.request_id
    AND   s.status IN ('SUBMITTED','APPROVED')
)

-- Finance: Awaiting Disbursement (IS_DT_FINANCE or IS_DT_ADMIN)
SELECT COUNT(*) FROM prod.dt_requests
WHERE status = 'APPROVED' AND finance_disbursed_yn = 'N'

-- Finance: Ready to Close (IS_DT_FINANCE or IS_DT_ADMIN)
SELECT COUNT(*) FROM prod.dt_requests
WHERE status = 'TRAVELLED'
```

**Region 2 — My Recent Requests (IR, 5 rows):**
```sql
SELECT request_number, mission_type, trip_type, departure_date, return_date,
       total_advance_aed, status
FROM   prod.dt_requests
WHERE  employee_user_id = :APP_USER_ID
ORDER  BY created_at DESC
FETCH  FIRST 5 ROWS ONLY
```
Link column: request_number → P12_REQUEST_ID (Request Detail)

**Region 3 — Pending Approvals Summary (IS_DT_MANAGER or IS_DT_ADMIN or IS_DT_FINANCE, 5 rows):**
```sql
SELECT r.request_number, u.display_name AS employee_name,
       r.mission_type, r.departure_date, r.return_date,
       r.total_advance_aed, r.status
FROM   prod.dt_requests r
JOIN   prod.dct_users u ON u.user_id = r.employee_user_id
JOIN   prod.dct_approval_instances ai ON ai.instance_id = r.approval_instance_id
JOIN   prod.dct_approval_steps ast ON ast.step_id = ai.current_step_id
JOIN   prod.dct_roles rol ON rol.role_id = ast.approver_role_id
WHERE  ai.status = 'PENDING'
AND    prod.dct_auth.has_role(:APP_USER_ID, rol.role_code) = 1
ORDER  BY r.created_at
FETCH  FIRST 5 ROWS ONLY
```
Link → P30 (Pending Approvals)

---

## Page 10 — My Travel Requests (IR)

**Auth:** IS_AUTHENTICATED
**Title:** My Travel Requests
**Source:** `prod.dt_requests`

**WHERE clause:**
```sql
employee_user_id = :APP_USER_ID
```

**Columns:**

| Column | Type | Notes |
|---|---|---|
| `request_number` | Link | → P12 (Request Detail), P12_REQUEST_ID = request_id |
| `mission_type` | Display | BUSINESS_MISSION / TRAINING |
| `trip_type` | Display | INTERNAL / EXTERNAL |
| `departure_date` | Date | |
| `return_date` | Date | |
| `total_days` | Number | Virtual column |
| `total_advance_aed` | Currency | |
| `status` | Badge | DRAFT=grey, SUBMITTED=blue, APPROVED=teal, ADVANCE_PAID=purple, TRAVELLED=orange, CLOSED=green, REJECTED=red, RETURNED=amber, CANCELLED=grey |
| `created_at` | Date | |

**Toolbar Button:** "New Request" → P11 (no P11_REQUEST_ID → insert mode)

**Row Actions:**
- Edit → P11 (only when status = DRAFT; condition on row)
- Cancel → inline confirm → Process: `UPDATE prod.dt_requests SET status='CANCELLED', updated_by=:APP_USER_ID, updated_at=SYSTIMESTAMP WHERE request_id=:APEX$ROW_PK AND status='DRAFT' AND employee_user_id=:APP_USER_ID`

---

## Page 11 — New / Edit Travel Request

**Auth:** IS_AUTHENTICATED
**Title:** `CASE WHEN :P11_REQUEST_ID IS NULL THEN 'New Travel Request' ELSE 'Edit Travel Request — '||:P11_REQUEST_NUMBER END`
**Mode:** Form (header) + Interactive Grid (destination legs)

### Hidden Items
| Item | Notes |
|---|---|
| `P11_REQUEST_ID` | PK; NULL = insert mode |
| `P11_REQUEST_NUMBER` | Display only; auto-generated |
| `P11_APPROVAL_INSTANCE_ID` | Hidden |

### Form Items — Trip Header

| Item | Type | Required | Notes |
|---|---|---|---|
| `P11_MISSION_TYPE` | Select List | Y | LOV_DT_MISSION_TYPE |
| `P11_TRIP_TYPE` | Select List | Y | LOV_DT_TRIP_TYPE |
| `P11_PURPOSE` | Textarea | Y | Max 1000 chars |
| `P11_HOSTED_BY` | Text | N | Inviting org / conference |
| `P11_DEPARTURE_DATE` | Date Picker | Y | |
| `P11_RETURN_DATE` | Date Picker | Y | Must be ≥ P11_DEPARTURE_DATE |
| `P11_BUDGET_TYPE` | Select List | Y | LOV_DT_BUDGET_TYPE; toggles GL vs PROJECT fields |
| `P11_CC_ID_GL` | Select List | N | LOV_GL_CC (cascade); shown when BUDGET_TYPE=GL |
| `P11_PROJECT_NUMBER` | Text | N | Shown when BUDGET_TYPE=PROJECT |
| `P11_TASK_NUMBER` | Text | N | Shown when BUDGET_TYPE=PROJECT |
| `P11_EXPENDITURE_TYPE` | Text | N | Shown when BUDGET_TYPE=PROJECT |
| `P11_NOTES` | Textarea | N | |

### Display-Only Items (read from calculated values)

| Item | Source |
|---|---|
| `P11_TOTAL_DAYS` | `SELECT return_date - departure_date + 1 FROM prod.dt_requests WHERE request_id = :P11_REQUEST_ID` |
| `P11_TOTAL_PER_DIEM_AED` | `SELECT total_per_diem_aed FROM prod.dt_requests WHERE request_id = :P11_REQUEST_ID` |
| `P11_TOTAL_ADVANCE_AED` | `SELECT total_advance_aed FROM prod.dt_requests WHERE request_id = :P11_REQUEST_ID` |

### Conditional Allowance Items (visible only when module setting = Y)

| Item | Type | Notes |
|---|---|---|
| `P11_TICKET_AMOUNT_AED` | Number | Shown when INCLUDE_TICKET_ALLOWANCE = Y |
| `P11_ACCOMMODATION_AMOUNT_AED` | Number | Shown when INCLUDE_ACCOMMODATION_ALLOWANCE = Y |
| `P11_VISA_FEES_AED` | Number | Shown when INCLUDE_VISA_ALLOWANCE = Y |
| `P11_LOCAL_TRANSPORT_AED` | Number | Shown when INCLUDE_LOCAL_TRANSPORT_ALLOWANCE = Y |
| `P11_OTHER_ALLOWANCES_AED` | Number | Always visible |

**Dynamic Actions — Budget Type Toggle:**
- On P11_BUDGET_TYPE change: show P11_CC_ID_GL (when GL), show P11_PROJECT_NUMBER / P11_TASK_NUMBER / P11_EXPENDITURE_TYPE (when PROJECT)

**Dynamic Actions — Date Validation:**
- On P11_RETURN_DATE change: JS validation that return_date ≥ departure_date; show inline error if not

### Interactive Grid — Destination Legs

**Source:**
```sql
SELECT destination_id, request_id, seq_num, country_code, city,
       arrival_date, departure_date, duration_days,
       per_diem_daily_rate_aed, per_diem_total_aed, notes
FROM   prod.dt_destinations
WHERE  request_id = :P11_REQUEST_ID
ORDER  BY seq_num
```

**IG Columns:**

| Column | Type | Required | Notes |
|---|---|---|---|
| `SEQ_NUM` | Number | Y | Auto-populated; user can reorder |
| `COUNTRY_CODE` | Select List | Y | LOV_DT_COUNTRIES (LOV_ISO_COUNTRIES for internal) |
| `CITY` | Text | Y | |
| `ARRIVAL_DATE` | Date Picker | Y | |
| `DEPARTURE_DATE` | Date Picker | Y | ≥ ARRIVAL_DATE |
| `DURATION_DAYS` | Display Only | — | Virtual; computed |
| `PER_DIEM_DAILY_RATE_AED` | Display Only | — | Snapped after save |
| `PER_DIEM_TOTAL_AED` | Display Only | — | Snapped after save |
| `NOTES` | Text | N | |

**IG Toolbar:** Add Row, Delete Row, Save

**Dynamic Action — After IG Save:** Execute Server-side Code:
```sql
BEGIN
  prod.dct_dt_pkg.calc_per_diem(p_request_id => :P11_REQUEST_ID);
END;
```
Then refresh P11_TOTAL_PER_DIEM_AED and P11_TOTAL_ADVANCE_AED display items.

### Processes

**Process 1 — Save Header (On Submit, Before Validations):**
```sql
DECLARE
  v_id   prod.dt_requests.request_id%TYPE := :P11_REQUEST_ID;
  v_num  VARCHAR2(30);
BEGIN
  IF v_id IS NULL THEN
    -- Insert
    v_num := prod.dct_dt_pkg.generate_request_number;
    INSERT INTO prod.dt_requests (
      request_number, employee_user_id, employee_grade_code, org_id,
      mission_type, trip_type, purpose, hosted_by,
      departure_date, return_date,
      ticket_amount_aed, accommodation_amount_aed, visa_fees_aed,
      local_transport_aed, other_allowances_aed,
      budget_type, cc_id_gl, project_number, task_number, expenditure_type,
      notes, status,
      created_by, created_at, updated_by, updated_at)
    VALUES (
      v_num, :APP_USER_ID,
      (SELECT employee_grade_code FROM prod.dct_users WHERE user_id = :APP_USER_ID),
      :APP_ORG_ID,
      :P11_MISSION_TYPE, :P11_TRIP_TYPE, :P11_PURPOSE, :P11_HOSTED_BY,
      TO_DATE(:P11_DEPARTURE_DATE, 'DD-MON-YYYY'),
      TO_DATE(:P11_RETURN_DATE, 'DD-MON-YYYY'),
      NVL(:P11_TICKET_AMOUNT_AED, 0), NVL(:P11_ACCOMMODATION_AMOUNT_AED, 0),
      NVL(:P11_VISA_FEES_AED, 0), NVL(:P11_LOCAL_TRANSPORT_AED, 0),
      NVL(:P11_OTHER_ALLOWANCES_AED, 0),
      :P11_BUDGET_TYPE, :P11_CC_ID_GL, :P11_PROJECT_NUMBER,
      :P11_TASK_NUMBER, :P11_EXPENDITURE_TYPE,
      :P11_NOTES, 'DRAFT',
      :APP_USER_ID, SYSTIMESTAMP, :APP_USER_ID, SYSTIMESTAMP)
    RETURNING request_id INTO v_id;
    :P11_REQUEST_ID := v_id;
  ELSE
    -- Update (only if DRAFT)
    UPDATE prod.dt_requests SET
      mission_type              = :P11_MISSION_TYPE,
      trip_type                 = :P11_TRIP_TYPE,
      purpose                   = :P11_PURPOSE,
      hosted_by                 = :P11_HOSTED_BY,
      departure_date            = TO_DATE(:P11_DEPARTURE_DATE, 'DD-MON-YYYY'),
      return_date               = TO_DATE(:P11_RETURN_DATE, 'DD-MON-YYYY'),
      ticket_amount_aed         = NVL(:P11_TICKET_AMOUNT_AED, 0),
      accommodation_amount_aed  = NVL(:P11_ACCOMMODATION_AMOUNT_AED, 0),
      visa_fees_aed             = NVL(:P11_VISA_FEES_AED, 0),
      local_transport_aed       = NVL(:P11_LOCAL_TRANSPORT_AED, 0),
      other_allowances_aed      = NVL(:P11_OTHER_ALLOWANCES_AED, 0),
      budget_type               = :P11_BUDGET_TYPE,
      cc_id_gl                  = :P11_CC_ID_GL,
      project_number            = :P11_PROJECT_NUMBER,
      task_number               = :P11_TASK_NUMBER,
      expenditure_type          = :P11_EXPENDITURE_TYPE,
      notes                     = :P11_NOTES,
      updated_by                = :APP_USER_ID,
      updated_at                = SYSTIMESTAMP
    WHERE request_id = v_id
    AND   status = 'DRAFT'
    AND   employee_user_id = :APP_USER_ID;
  END IF;

  prod.dct_dt_pkg.calc_per_diem(p_request_id => v_id);
END;
```

**Process 2 — Submit for Approval (button "Submit Request"):**
```sql
BEGIN
  prod.dct_dt_pkg.submit_request(p_request_id => :P11_REQUEST_ID);
END;
```
Condition: `:P11_REQUEST_ID IS NOT NULL AND :REQUEST ('SUBMIT') IS NOT NULL`
Redirect after: P10 (My Requests) with success message "Request submitted for approval."

**Process 3 — Save & Continue (button "Save Draft"):**
Redirect: P11 with P11_REQUEST_ID = :P11_REQUEST_ID (reload same page)

### Validations

| Validation | Type | Rule |
|---|---|---|
| Return date | PL/SQL | `RETURN TO_DATE(:P11_RETURN_DATE,'DD-MON-YYYY') >= TO_DATE(:P11_DEPARTURE_DATE,'DD-MON-YYYY');` |
| Departure not in past | PL/SQL | Read `ALLOW_PAST_TRAVEL_REQUEST` setting; if N, `RETURN TO_DATE(:P11_DEPARTURE_DATE,'DD-MON-YYYY') >= TRUNC(SYSDATE);` |
| Budget coding | PL/SQL | When `BUDGET_TYPE=GL`: cc_id_gl not null; when PROJECT: project_number not null |
| Destinations exist (submit only) | PL/SQL | `RETURN (SELECT COUNT(*) FROM prod.dt_destinations WHERE request_id = :P11_REQUEST_ID) > 0;` |

**Page Condition (edit guard):**
Show page items as read-only when status != 'DRAFT':
```sql
SELECT 1 FROM prod.dt_requests WHERE request_id = :P11_REQUEST_ID AND status != 'DRAFT'
```

---

## Page 12 — Request Detail

**Auth:** IS_AUTHENTICATED
**Title:** `'Request Detail — ' || :P12_REQUEST_NUMBER`
**Mode:** Read-only detail view

**Hidden:** `P12_REQUEST_ID`

### Regions

**Region 1 — Request Header (read-only form):**
```sql
SELECT r.request_id, r.request_number, r.mission_type, r.trip_type,
       r.purpose, r.hosted_by,
       r.departure_date, r.return_date, r.total_days,
       r.status,
       u.display_name AS employee_name,
       o.org_name_en,
       r.employee_grade_code
FROM   prod.dt_requests r
JOIN   prod.dct_users u ON u.user_id = r.employee_user_id
JOIN   prod.dct_organizations o ON o.org_id = r.org_id
WHERE  r.request_id = :P12_REQUEST_ID
AND    (r.employee_user_id = :APP_USER_ID
        OR :APP_IS_DT_ADMIN = 'Y'
        OR :APP_IS_DT_MANAGER = 'Y'
        OR :APP_IS_DT_FINANCE = 'Y')
```

**Region 2 — Destination Legs (IR, read-only):**
```sql
SELECT seq_num, country_code, city,
       arrival_date, departure_date, duration_days,
       per_diem_daily_rate_aed, per_diem_total_aed, notes
FROM   prod.dt_destinations
WHERE  request_id = :P12_REQUEST_ID
ORDER  BY seq_num
```

**Region 3 — Allowances Breakdown:**
```sql
SELECT total_per_diem_aed, ticket_amount_aed, accommodation_amount_aed,
       visa_fees_aed, local_transport_aed, other_allowances_aed,
       total_advance_aed,
       budget_type, cc_id_gl, project_number, task_number, expenditure_type,
       finance_disbursed_yn, disbursed_date,
       (SELECT display_name FROM prod.dct_users WHERE user_id = r.disbursed_by_user_id) AS disbursed_by_name,
       closed_date,
       (SELECT display_name FROM prod.dct_users WHERE user_id = r.closed_by_user_id) AS closed_by_name,
       notes
FROM   prod.dt_requests r
WHERE  request_id = :P12_REQUEST_ID
```

**Region 4 — Approval Trail (IR):**
```sql
SELECT ast.step_num, rol.role_name_en AS approver_role,
       (SELECT display_name FROM prod.dct_users WHERE user_id = ah.action_by_user_id) AS actioned_by,
       ah.action_type, ah.action_date, ah.comments
FROM   prod.dct_approval_history ah
JOIN   prod.dct_approval_steps ast ON ast.step_id = ah.step_id
JOIN   prod.dct_roles rol ON rol.role_id = ast.approver_role_id
JOIN   prod.dt_requests r ON r.approval_instance_id = ah.instance_id
WHERE  r.request_id = :P12_REQUEST_ID
ORDER  BY ah.action_date
```

**Region 5 — Supporting Documents (IR):**
```sql
SELECT document_id, document_name,
       (SELECT display_value FROM prod.dct_lookup_values WHERE lookup_value_id = d.document_type_id) AS doc_type,
       file_size, is_required, uploaded_at,
       (SELECT display_name FROM prod.dct_users WHERE user_id = d.uploaded_by) AS uploaded_by_name
FROM   prod.dt_documents d
WHERE  source_type = 'REQUEST'
AND    source_id = :P12_REQUEST_ID
ORDER  BY uploaded_at
```

**Buttons (condition-guarded):**

| Button | Condition | Action |
|---|---|---|
| Edit | `status = 'DRAFT' AND employee_user_id = :APP_USER_ID` | Redirect to P11 |
| Submit for Approval | `status = 'DRAFT' AND employee_user_id = :APP_USER_ID` | Call `DCT_DT_PKG.SUBMIT_REQUEST` |
| Approve | `status = 'SUBMITTED' AND (IS_DT_MANAGER or IS_DT_FINANCE)` | Redirect to P30 |
| Cancel Request | `status = 'DRAFT' AND employee_user_id = :APP_USER_ID` | Set status = CANCELLED |
| Create Settlement | `status = 'TRAVELLED' AND employee_user_id = :APP_USER_ID` | Redirect to P14 (new settlement) |

---

## Page 13 — My Settlements (IR)

**Auth:** IS_AUTHENTICATED
**Title:** My Settlements
**Source:**
```sql
SELECT s.settlement_id, s.settlement_number,
       r.request_number, r.departure_date, r.return_date,
       s.actual_return_date, s.actual_per_diem_days,
       s.advance_paid_aed, s.total_actual_aed, s.difference_aed,
       s.settlement_type, s.status, s.created_at
FROM   prod.dt_settlement s
JOIN   prod.dt_requests r ON r.request_id = s.request_id
WHERE  s.employee_user_id = :APP_USER_ID
ORDER  BY s.created_at DESC
```

**Columns:**

| Column | Type | Notes |
|---|---|---|
| `settlement_number` | Link | → P14 (P14_SETTLEMENT_ID) |
| `request_number` | Link | → P12 (P12_REQUEST_ID) |
| `departure_date` / `return_date` | Date | Planned dates |
| `actual_return_date` | Date | |
| `advance_paid_aed` | Currency | |
| `total_actual_aed` | Currency | |
| `difference_aed` | Currency | Positive = owed, negative = refund |
| `settlement_type` | Badge | BALANCED=grey, ADDITIONAL_PAYMENT=amber, REFUND=blue |
| `status` | Badge | DRAFT=grey, SUBMITTED=blue, APPROVED=green, REJECTED=red, RETURNED=amber |

**Toolbar Button:** — (new settlement created from P12 "Create Settlement" button only)

---

## Page 14 — Settlement Form

**Auth:** IS_AUTHENTICATED
**Title:** `CASE WHEN :P14_SETTLEMENT_ID IS NULL THEN 'New Settlement' ELSE 'Settlement — '||:P14_SETTLEMENT_NUMBER END`

**Hidden Items:** `P14_SETTLEMENT_ID`, `P14_REQUEST_ID`, `P14_SETTLEMENT_NUMBER`

### Form Items — Settlement Header

| Item | Type | Required | Notes |
|---|---|---|---|
| `P14_REQUEST_NUMBER` | Display Only | — | Loaded from request |
| `P14_ACTUAL_RETURN_DATE` | Date Picker | Y | |
| `P14_ACTUAL_PER_DIEM_DAYS` | Number | Y | Employee declares actual travel days |
| `P14_ADVANCE_PAID_AED` | Display Only | — | Snapped from request at creation |
| `P14_EMPLOYEE_NOTES` | Textarea | N | |

**Display-Only (calculated):**

| Item | Source |
|---|---|
| `P14_TOTAL_ACTUAL_AED` | SUM of expense lines |
| `P14_DIFFERENCE_AED` | total_actual - advance_paid |
| `P14_SETTLEMENT_TYPE` | BALANCED / ADDITIONAL_PAYMENT / REFUND |

### Interactive Grid — Expense Lines

**Source:**
```sql
SELECT line_id, settlement_id, line_num, expense_category,
       description, amount_aed, receipt_attached, notes
FROM   prod.dt_settlement_lines
WHERE  settlement_id = :P14_SETTLEMENT_ID
ORDER  BY line_num
```

**IG Columns:**

| Column | Type | Required | Notes |
|---|---|---|---|
| `LINE_NUM` | Number | Y | Auto-seq |
| `EXPENSE_CATEGORY` | Select List | Y | LOV_DT_EXPENSE_CATEGORY |
| `DESCRIPTION` | Text | N | |
| `AMOUNT_AED` | Currency | Y | |
| `RECEIPT_ATTACHED` | Select List | Y | LOV_YES_NO; required = Y for ACCOMMODATION/TICKET when SETTLEMENT_REQUIRE_RECEIPTS = Y |
| `NOTES` | Text | N | |

**Dynamic Action — After IG Save:** Recalculate and refresh P14_TOTAL_ACTUAL_AED, P14_DIFFERENCE_AED, P14_SETTLEMENT_TYPE.

### Processes

**Process 1 — Save Settlement Header:**
```sql
DECLARE
  v_id   prod.dt_settlement.settlement_id%TYPE := :P14_SETTLEMENT_ID;
  v_adv  prod.dt_requests.total_advance_aed%TYPE;
BEGIN
  IF v_id IS NULL THEN
    SELECT total_advance_aed INTO v_adv
    FROM   prod.dt_requests
    WHERE  request_id = :P14_REQUEST_ID;

    INSERT INTO prod.dt_settlement (
      settlement_number, request_id, employee_user_id,
      actual_return_date, actual_per_diem_days,
      total_actual_aed, advance_paid_aed,
      employee_notes, status,
      created_by, created_at, updated_by, updated_at)
    VALUES (
      prod.dct_dt_pkg.generate_settlement_number,
      :P14_REQUEST_ID, :APP_USER_ID,
      TO_DATE(:P14_ACTUAL_RETURN_DATE,'DD-MON-YYYY'),
      :P14_ACTUAL_PER_DIEM_DAYS,
      NVL((SELECT SUM(amount_aed) FROM prod.dt_settlement_lines WHERE settlement_id = v_id), 0),
      v_adv,
      :P14_EMPLOYEE_NOTES, 'DRAFT',
      :APP_USER_ID, SYSTIMESTAMP, :APP_USER_ID, SYSTIMESTAMP)
    RETURNING settlement_id INTO v_id;
    :P14_SETTLEMENT_ID := v_id;
  ELSE
    UPDATE prod.dt_settlement SET
      actual_return_date   = TO_DATE(:P14_ACTUAL_RETURN_DATE,'DD-MON-YYYY'),
      actual_per_diem_days = :P14_ACTUAL_PER_DIEM_DAYS,
      total_actual_aed     = NVL((SELECT SUM(amount_aed) FROM prod.dt_settlement_lines WHERE settlement_id = v_id), 0),
      employee_notes       = :P14_EMPLOYEE_NOTES,
      updated_by           = :APP_USER_ID,
      updated_at           = SYSTIMESTAMP
    WHERE settlement_id = v_id
    AND   status = 'DRAFT';
  END IF;
END;
```

**Process 2 — Submit Settlement (button "Submit for Approval"):**
```sql
BEGIN
  prod.dct_dt_pkg.submit_settlement(p_settlement_id => :P14_SETTLEMENT_ID);
END;
```
Redirect after: P13 (My Settlements) with success message.

### Validations

| Validation | Rule |
|---|---|
| Actual return date not future | `RETURN TO_DATE(:P14_ACTUAL_RETURN_DATE,'DD-MON-YYYY') <= TRUNC(SYSDATE);` |
| At least one expense line (submit only) | `RETURN (SELECT COUNT(*) FROM prod.dt_settlement_lines WHERE settlement_id = :P14_SETTLEMENT_ID) > 0;` |
| Receipts required (submit only) | Call `DCT_DT_PKG.VALIDATE_DOCS('SETTLEMENT', :P14_SETTLEMENT_ID)` |
| Amount cap (submit only) | Read `ALLOW_SETTLEMENT_AMOUNT_EXCEED` and `SETTLEMENT_MAX_EXCEED_PCT`; raise error if exceeded |

---

## Page 20 — All Requests (IR)

**Auth:** IS_DT_ADMIN
**Title:** All Travel Requests
**Source:** `prod.dt_requests_v` (view joining dt_requests + dct_users + dct_organizations)

**Columns:**

| Column | Notes |
|---|---|
| `request_number` | Link → P12 |
| `employee_name` | From dct_users.display_name |
| `org_name_en` | Department |
| `mission_type` | |
| `trip_type` | |
| `departure_date` / `return_date` | |
| `total_days` | |
| `total_advance_aed` | Currency |
| `finance_disbursed_yn` | Y/N badge |
| `status` | Badge (same as P10) |
| `created_at` | |

**Search Bar Filters:** Status select, Mission Type select, Trip Type select, Employee name text, Date range (departure from/to)

**Toolbar Buttons:**
- "Export CSV" (APEX built-in)
- "New Request on Behalf" → P11 (admin creates for another employee — requires a hidden P11_ON_BEHALF_OF item pre-set)

---

## Page 21 — All Settlements (IR)

**Auth:** IS_DT_ADMIN_OR_FINANCE
**Title:** All Settlements
**Source:**
```sql
SELECT s.settlement_id, s.settlement_number,
       r.request_number,
       u.display_name AS employee_name,
       o.org_name_en,
       s.actual_return_date, s.advance_paid_aed,
       s.total_actual_aed, s.difference_aed, s.settlement_type,
       s.status,
       s.refund_collected_yn, s.additional_payment_ref,
       s.created_at
FROM   prod.dt_settlement s
JOIN   prod.dt_requests r ON r.request_id = s.request_id
JOIN   prod.dct_users u ON u.user_id = s.employee_user_id
JOIN   prod.dct_organizations o ON o.org_id = r.org_id
ORDER  BY s.created_at DESC
```

**Columns:**

| Column | Notes |
|---|---|
| `settlement_number` | Link → P14 |
| `request_number` | Link → P12 |
| `employee_name` | |
| `org_name_en` | |
| `actual_return_date` | |
| `advance_paid_aed` / `total_actual_aed` / `difference_aed` | Currency |
| `settlement_type` | Badge |
| `status` | Badge |
| `refund_collected_yn` | Y/N — editable inline by Finance |

**Row Action — Mark Refund Collected (Finance, APPROVED status, REFUND type):**
```sql
UPDATE prod.dt_settlement
SET    refund_collected_yn = 'Y',
       refund_collected_date = SYSDATE,
       updated_by = :APP_USER_ID,
       updated_at = SYSTIMESTAMP
WHERE  settlement_id = :APEX$ROW_PK
AND    status = 'APPROVED'
AND    settlement_type = 'REFUND'
```

---

## Page 30 — Pending Approvals (IR)

**Auth:** IS_DT_MANAGER or IS_DT_ADMIN or IS_DT_FINANCE
**Title:** Pending Approvals

**Source:**
```sql
SELECT r.request_id, r.request_number,
       u.display_name AS employee_name,
       o.org_name_en,
       r.mission_type, r.trip_type,
       r.departure_date, r.return_date,
       r.total_advance_aed, r.status,
       ai.instance_id AS approval_instance_id,
       rol.role_code AS required_role
FROM   prod.dt_requests r
JOIN   prod.dct_users u ON u.user_id = r.employee_user_id
JOIN   prod.dct_organizations o ON o.org_id = r.org_id
JOIN   prod.dct_approval_instances ai ON ai.instance_id = r.approval_instance_id
JOIN   prod.dct_approval_steps ast ON ast.step_id = ai.current_step_id
JOIN   prod.dct_roles rol ON rol.role_id = ast.approver_role_id
WHERE  ai.status = 'PENDING'
AND    prod.dct_auth.has_role(:APP_USER_ID, rol.role_code) = 1
ORDER  BY r.created_at
```

**Columns:**

| Column | Notes |
|---|---|
| `request_number` | Link → P12 |
| `employee_name` | |
| `org_name_en` | |
| `mission_type` / `trip_type` | |
| `departure_date` / `return_date` | |
| `total_advance_aed` | Currency |
| `status` | Badge |

**Row-Level Buttons:** "Approve" / "Reject" / "Return" (inline confirm for Reject/Return with comments input)

**Process — Approve:**
```sql
DECLARE
  v_inst NUMBER := :P30_APPROVAL_INSTANCE_ID;
BEGIN
  -- Record approval action via shared DCT_APPROVAL framework
  prod.dct_auth.record_approval_action(
    p_instance_id  => v_inst,
    p_action_type  => 'APPROVED',
    p_action_by    => :APP_USER_ID,
    p_comments     => :P30_COMMENTS
  );
  -- If all steps approved → update request status
  DECLARE v_done VARCHAR2(1);
  BEGIN
    SELECT status INTO v_done FROM prod.dct_approval_instances WHERE instance_id = v_inst;
    IF v_done = 'APPROVED' THEN
      UPDATE prod.dt_requests SET status = 'APPROVED', updated_by = :APP_USER_ID, updated_at = SYSTIMESTAMP
      WHERE approval_instance_id = v_inst;
    END IF;
  END;
END;
```

**Process — Reject:**
```sql
BEGIN
  prod.dct_auth.record_approval_action(
    p_instance_id => :P30_APPROVAL_INSTANCE_ID,
    p_action_type => 'REJECTED',
    p_action_by   => :APP_USER_ID,
    p_comments    => :P30_COMMENTS
  );
  UPDATE prod.dt_requests SET status = 'REJECTED', updated_by = :APP_USER_ID, updated_at = SYSTIMESTAMP
  WHERE  approval_instance_id = :P30_APPROVAL_INSTANCE_ID;
END;
```

**Process — Return:**
```sql
BEGIN
  prod.dct_auth.record_approval_action(
    p_instance_id => :P30_APPROVAL_INSTANCE_ID,
    p_action_type => 'RETURNED',
    p_action_by   => :APP_USER_ID,
    p_comments    => :P30_COMMENTS
  );
  UPDATE prod.dt_requests SET status = 'RETURNED', updated_by = :APP_USER_ID, updated_at = SYSTIMESTAMP
  WHERE  approval_instance_id = :P30_APPROVAL_INSTANCE_ID;
END;
```

---

## Page 40 — Per Diem Rate Master (IG)

**Auth:** IS_DT_ADMIN
**Title:** Per Diem Rate Master
**Source:** `prod.dt_per_diem_rates`

**IG Columns:**

| Column | Type | Required | Notes |
|---|---|---|---|
| `RATE_ID` | Hidden PK | — | |
| `RATE_KEY` | Text | Y | Country code, tier code, or region code; label depends on RATE_STRUCTURE setting |
| `RATE_KEY_NAME_EN` | Text | Y | Display label |
| `RATE_KEY_NAME_AR` | Text | N | Arabic label |
| `GRADE_CODE` | Select List | Y | LOV_DT_EMPLOYEE_GRADE (includes ALL) |
| `PER_DIEM_DAILY_AED` | Currency | Y | All-in-one daily allowance |
| `EFFECTIVE_FROM` | Date | Y | |
| `EFFECTIVE_TO` | Date | N | Null = no expiry |
| `IS_ACTIVE` | Checkbox | Y | Default Y |
| `NOTES` | Text | N | |

**Info Banner:** Display current `RATE_STRUCTURE` setting value at top of page so admin knows what `rate_key` should contain.

**Unique Constraint Enforcement:** Before IG save, validate no duplicate `(rate_key, grade_code, effective_from)`.

---

## Page 41 — Country Group Mapping (IG)

**Auth:** IS_DT_ADMIN
**Title:** Country Group Mapping

**Visible Condition:** `RATE_STRUCTURE` setting is `TIER_BASED` or `REGION_BASED` (if `PER_COUNTRY`, show info message "Country groups are not used with Per-Country rate structure.")

**Source:** `prod.dt_country_groups`

**IG Columns:**

| Column | Type | Required | Notes |
|---|---|---|---|
| `COUNTRY_CODE` | Text | Y | ISO alpha-2 PK |
| `COUNTRY_NAME_EN` | Text | Y | |
| `COUNTRY_NAME_AR` | Text | N | |
| `GROUP_CODE` | Text | Y | Must match a `rate_key` in DT_PER_DIEM_RATES |
| `IS_ACTIVE` | Checkbox | Y | Default Y |

---

## Page 42 — Document Requirements (IG)

**Auth:** IS_DT_ADMIN
**Title:** Document Requirements

**Source:** `prod.dt_doc_requirements`

**IG Columns:**

| Column | Type | Required | Notes |
|---|---|---|---|
| `DOC_REQ_ID` | Hidden PK | — | |
| `MISSION_TYPE` | Select List | Y | LOV: BUSINESS_MISSION / TRAINING / ALL |
| `TRIP_TYPE` | Select List | Y | LOV: INTERNAL / EXTERNAL / ALL |
| `DOCUMENT_TYPE_ID` | Select List | Y | LOV_DT_DOCUMENT_TYPE |
| `IS_MANDATORY` | Checkbox | Y | Default Y |
| `APPLIES_TO_SOURCE` | Select List | Y | REQUEST / SETTLEMENT / BOTH |
| `DISPLAY_SEQ` | Number | Y | Default 99 |
| `IS_ACTIVE` | Checkbox | Y | Default Y |

---

## Page 50 — Finance Disbursement Queue (IR)

**Auth:** IS_DT_ADMIN_OR_FINANCE
**Title:** Disbursement Queue — Approved Requests

**Source:**
```sql
SELECT r.request_id, r.request_number,
       u.display_name AS employee_name,
       o.org_name_en,
       r.departure_date, r.return_date,
       r.total_advance_aed,
       r.budget_type, r.cc_id_gl, r.project_number,
       r.approved_date,
       r.notes
FROM   prod.dt_requests r
JOIN   prod.dct_users u ON u.user_id = r.employee_user_id
JOIN   prod.dct_organizations o ON o.org_id = r.org_id
WHERE  r.status = 'APPROVED'
AND    r.finance_disbursed_yn = 'N'
ORDER  BY r.departure_date
```

**Columns:**

| Column | Notes |
|---|---|
| `request_number` | Link → P12 |
| `employee_name` | |
| `org_name_en` | |
| `departure_date` | Sorted ascending — soonest travel first |
| `total_advance_aed` | Currency |
| `budget_type` | GL / PROJECT |
| `coding_info` | Display cc_id_gl or project_number depending on budget_type |

**Row-Level Button — "Mark Advance Paid":**
```sql
BEGIN
  prod.dct_dt_pkg.mark_advance_paid(
    p_request_id => :APEX$ROW_PK,
    p_user_id    => :APP_USER_ID
  );
END;
```
After action: refresh IR, show success message.

**Bulk Select + "Mark Selected as Paid":** APEX checkbox column; bulk process calls MARK_ADVANCE_PAID in a loop.

---

## Page 60 — Finance Closure Queue (IR)

**Auth:** IS_DT_ADMIN_OR_FINANCE
**Title:** Closure Queue — TRAVELLED Requests

**Source:**
```sql
SELECT r.request_id, r.request_number,
       u.display_name AS employee_name,
       o.org_name_en,
       r.return_date,
       r.total_advance_aed,
       s.settlement_id,
       s.settlement_number,
       s.status AS settlement_status,
       s.difference_aed,
       s.settlement_type,
       CASE WHEN s.settlement_id IS NULL THEN 'NO_SETTLEMENT'
            WHEN s.status = 'APPROVED' THEN 'READY_TO_CLOSE'
            ELSE 'SETTLEMENT_PENDING'
       END AS closure_readiness
FROM   prod.dt_requests r
JOIN   prod.dct_users u ON u.user_id = r.employee_user_id
JOIN   prod.dct_organizations o ON o.org_id = r.org_id
LEFT JOIN prod.dt_settlement s ON s.request_id = r.request_id
WHERE  r.status = 'TRAVELLED'
ORDER  BY r.return_date
```

**Badges:** `closure_readiness` — READY_TO_CLOSE=green, SETTLEMENT_PENDING=amber, NO_SETTLEMENT=grey

**Row-Level Button — "Close Request":**
- Condition: `closure_readiness = 'READY_TO_CLOSE'` OR (`SETTLEMENT_REQUIRED = N`)
```sql
BEGIN
  prod.dct_dt_pkg.close_request(p_request_id => :APEX$ROW_PK);
END;
```

**Link columns:** settlement_number → P14; request_number → P12

---

## Page 70 — Module Settings (IG)

**Auth:** IS_ADMIN
**Title:** Duty Travel Module Settings
**Source:**
```sql
SELECT ms.setting_id, ms.setting_key, ms.setting_value,
       ms.setting_type, ms.description_en,
       ms.is_editable
FROM   prod.dct_module_settings ms
JOIN   prod.dct_modules m ON m.module_id = ms.module_id
WHERE  m.module_code = 'DUTY_TRAVEL'
ORDER  BY ms.display_seq
```

**IG Columns:**

| Column | Type | Notes |
|---|---|---|
| `SETTING_ID` | Hidden PK | |
| `SETTING_KEY` | Display Only | Setting code |
| `DESCRIPTION_EN` | Display Only | Human-readable description |
| `SETTING_VALUE` | Text | Editable only when is_editable = Y |
| `SETTING_TYPE` | Display Only | VARCHAR2 / NUMBER / DATE / BOOLEAN |

**Validation:** Block save when `is_editable = 'N'`.

**Info Panel:** Description of each setting group (Request Settings, Settlement Settings, Per Diem Settings, Allowances, Approval Thresholds).

---

## Page 71 — Approval Rules (Master-Detail)

**Auth:** IS_ADMIN
**Title:** Duty Travel Approval Rules

**Region 1 — Approval Templates (IR, master):**
```sql
SELECT at.template_id, at.template_code, at.template_name_en,
       at.is_active
FROM   prod.dct_approval_templates at
WHERE  at.module_code = 'DUTY_TRAVEL'
ORDER  BY at.template_code
```

**Region 2 — Approval Steps (IG, detail; filtered by selected template):**
```sql
SELECT step_id, template_id, step_num, step_name_en,
       approver_role_id, condition_type, condition_value,
       is_active
FROM   prod.dct_approval_steps
WHERE  template_id = :P71_TEMPLATE_ID
ORDER  BY step_num
```

**IG Columns:**

| Column | Type | Notes |
|---|---|---|
| `STEP_NUM` | Number | |
| `STEP_NAME_EN` | Text | |
| `APPROVER_ROLE_ID` | Select List | LOV_DCT_ROLES filtered to DT_* roles |
| `CONDITION_TYPE` | Select List | ALWAYS / AMOUNT_GTE / ROLE_BASED |
| `CONDITION_VALUE` | Text | Threshold for AMOUNT_GTE (e.g. 5000) |
| `IS_ACTIVE` | Checkbox | |

---

## Page 80 — Travel Summary Report

**Auth:** IS_DT_ADMIN or IS_DT_MANAGER
**Title:** Travel Summary Report

**Filter Items:**

| Item | Type | Notes |
|---|---|---|
| `P80_ORG_ID` | Select List | LOV_DCT_ORGANIZATIONS; all if null |
| `P80_PERIOD_FROM` | Date Picker | Departure date from |
| `P80_PERIOD_TO` | Date Picker | Departure date to |
| `P80_MISSION_TYPE` | Select List | LOV_DT_MISSION_TYPE; all if null |
| `P80_TRIP_TYPE` | Select List | LOV_DT_TRIP_TYPE; all if null |
| `P80_STATUS` | Select List | LOV_DT_STATUS; all if null |

**Region 1 — Summary by Department (Classic Report):**
```sql
SELECT o.org_name_en AS department,
       COUNT(*)                                                AS total_requests,
       COUNT(CASE WHEN r.status = 'APPROVED'      THEN 1 END) AS approved,
       COUNT(CASE WHEN r.status = 'CLOSED'        THEN 1 END) AS closed,
       COUNT(CASE WHEN r.status = 'REJECTED'      THEN 1 END) AS rejected,
       SUM(r.total_advance_aed)                               AS total_advance_aed,
       SUM(CASE WHEN r.trip_type = 'EXTERNAL'     THEN 1 END) AS external_trips,
       SUM(CASE WHEN r.trip_type = 'INTERNAL'     THEN 1 END) AS internal_trips
FROM   prod.dt_requests r
JOIN   prod.dct_organizations o ON o.org_id = r.org_id
WHERE  (:P80_ORG_ID IS NULL OR r.org_id = :P80_ORG_ID)
AND    (:P80_PERIOD_FROM IS NULL OR r.departure_date >= TO_DATE(:P80_PERIOD_FROM,'DD-MON-YYYY'))
AND    (:P80_PERIOD_TO IS NULL OR r.departure_date <= TO_DATE(:P80_PERIOD_TO,'DD-MON-YYYY'))
AND    (:P80_MISSION_TYPE IS NULL OR r.mission_type = :P80_MISSION_TYPE)
AND    (:P80_TRIP_TYPE IS NULL OR r.trip_type = :P80_TRIP_TYPE)
AND    (:P80_STATUS IS NULL OR r.status = :P80_STATUS)
GROUP  BY o.org_name_en
ORDER  BY total_advance_aed DESC
```

**Region 2 — Request Detail (IR with all filters applied):**
```sql
SELECT r.request_number, u.display_name AS employee_name, o.org_name_en,
       r.mission_type, r.trip_type, r.departure_date, r.return_date,
       r.total_days, r.total_advance_aed, r.status
FROM   prod.dt_requests r
JOIN   prod.dct_users u ON u.user_id = r.employee_user_id
JOIN   prod.dct_organizations o ON o.org_id = r.org_id
WHERE  (:P80_ORG_ID IS NULL OR r.org_id = :P80_ORG_ID)
AND    (:P80_PERIOD_FROM IS NULL OR r.departure_date >= TO_DATE(:P80_PERIOD_FROM,'DD-MON-YYYY'))
AND    (:P80_PERIOD_TO IS NULL OR r.departure_date <= TO_DATE(:P80_PERIOD_TO,'DD-MON-YYYY'))
AND    (:P80_MISSION_TYPE IS NULL OR r.mission_type = :P80_MISSION_TYPE)
AND    (:P80_TRIP_TYPE IS NULL OR r.trip_type = :P80_TRIP_TYPE)
AND    (:P80_STATUS IS NULL OR r.status = :P80_STATUS)
ORDER  BY r.departure_date DESC
```

Link column: `request_number` → P12

**Export:** CSV and PDF (APEX built-in)

---

## Build Sequence

Build in this order in APEX Builder:

1. **Shared Components** — App Items, Auth Schemes (local), LOVs
2. **Page 9999** — Login (copy from App 203 pattern)
3. **Page 0** — Global (notification badge)
4. **Page 1** — Dashboard (KPI cards)
5. **Page 11** — Request Form + Destinations IG (most complex; build first so P10/P12 can link to it)
6. **Page 10** — My Requests IR
7. **Page 12** — Request Detail (read-only; all regions)
8. **Page 14** — Settlement Form + Lines IG
9. **Page 13** — My Settlements IR
10. **Page 30** — Pending Approvals + approve/reject/return processes
11. **Page 20** — All Requests (admin IR)
12. **Page 21** — All Settlements (admin IR)
13. **Page 50** — Finance Disbursement Queue
14. **Page 60** — Finance Closure Queue
15. **Page 40** — Per Diem Rate Master IG
16. **Page 41** — Country Group Mapping IG
17. **Page 42** — Document Requirements IG
18. **Page 70** — Module Settings IG
19. **Page 71** — Approval Rules Master-Detail
20. **Page 80** — Reports
21. **Navigation** — Nav bar / breadcrumb entries for all pages with correct auth conditions

---

## DB Prerequisites (must run before APEX build)

| Script | Contents | Status |
|---|---|---|
| `db/v2/01_dct_ddl.sql` | Core DCT_* tables | Done |
| `db/v2/04_dct_seed.sql` | Modules, roles, lookups | Done |
| `final apps/DT/db/01_dt_ddl.sql` | DT_* tables, sequences, triggers | Done |
| `final apps/DT/db/02_dt_seed.sql` | DT seed data (doc types, grade lookups, sample rates) | Done |
| `final apps/DT/db/03_dt_views.sql` | `DT_REQUESTS_V`, `DT_MY_REQUESTS_V`, etc. | **Pending** |
| `final apps/DT/db/04_dct_dt_pkg.sql` | `DCT_DT_PKG` package + body | **Pending** |
