# APEX Page Plan — Credit Cards App 202
**APEX Version:** 24.2 | **Schema:** PROD | **Date:** 2026-05-13

---

## Page Inventory

| Page | Name | Type |
|---|---|---|
| 9999 | Login | Login |
| 0 | Global Page | Global |
| 1 | Home Dashboard | Blank + regions |
| 2 | My Credit Card | IR + card detail |
| 3 | Card Request Form | Form |
| 4 | All Credit Cards | IR |
| 5 | All Requests | IR |
| 6 | Pending Approvals | IR + modal |
| 7 | Document Requirements | IG |
| 8 | Delegation | Form + IR |
| 9 | Approval Rules | Master-Detail |
| 10 | Module Settings | IG |
| 11 | My Replenishments | IR |
| 12 | Replenishment Form | Form + IG |
| 13 | All Replenishments | IR |
| 14 | Proxy Management | IG |

---

## Page 9999 — Login

Use APEX wizard: **Create Login Page**. No customisation needed beyond Oracle Fusion CSS.

---

## Page 0 — Global Page

**Region: Notification Badge**
- Type: PL/SQL Dynamic Content
- Condition: `APP_PENDING_APPROVAL_COUNT > 0`
- Renders badge next to nav bar "Approve / Reject" link

**Region: Replenishment Due Banner**
```sql
-- Show when current day >= REPLENISHMENT_DUE_DAY setting and employee has active card
SELECT 'Y'
FROM   prod.dct_cc_pending_replenishment_v
WHERE  holder_user_id = :APP_USER_ID
AND    ROWNUM = 1
```
- Type: Static HTML — orange alert banner (`t-Alert--warning`)
- Text: "Your monthly credit card replenishment for [Month Year] is due. Please submit by the [N]th."

---

## Page 1 — Home Dashboard

**4 KPI Card Regions (Static Content + SQL):**

| KPI | Query |
|---|---|
| My Card Status | `SELECT status FROM prod.dct_credit_cards WHERE holder_user_id = :APP_USER_ID AND ROWNUM=1` |
| Pending Replenishments | `SELECT COUNT(*) FROM prod.dct_cc_pending_replenishment_v WHERE holder_user_id = :APP_USER_ID` |
| Pending Approvals | `:APP_PENDING_APPROVAL_COUNT` |
| My Credit Limit | `SELECT credit_limit FROM prod.dct_credit_cards WHERE holder_user_id = :APP_USER_ID AND status='ACTIVE' AND ROWNUM=1` |

**Region: Recent Requests**
```sql
SELECT request_number, request_type, status, created_at
FROM   prod.dct_cc_request_v
WHERE  created_by = :APP_USER_ID
ORDER  BY created_at DESC
FETCH  FIRST 5 ROWS ONLY
```

**Region: Recent Replenishments (if has card)**
```sql
SELECT reimb_number, period_month, period_year, total_amount, status
FROM   prod.dct_cc_replenishment_v
WHERE  on_behalf_of_user_id = :APP_USER_ID
ORDER  BY period_year DESC, period_month DESC
FETCH  FIRST 5 ROWS ONLY
```

---

## Page 2 — My Credit Card

**Region: Card Details (Form — read-only)**

Source table: `prod.dct_cc_card_v`
Where: `holder_user_id = :APP_USER_ID`

Items:
| Item | Type | Notes |
|---|---|---|
| `P2_CC_ID` | Hidden | |
| `P2_CC_NUMBER` | Display Only | |
| `P2_CREDIT_LIMIT` | Display Only | Format: 999G999G990D00 |
| `P2_EXPIRY_DATE` | Display Only | |
| `P2_STATUS` | Display Only | Badge styling |
| `P2_EMAIL` | Display Only | |
| `P2_BANK_NAME` | Display Only | |
| `P2_BANK_CUSTOMER_YN` | Display Only | Y/N |
| `P2_MOTHER_NAME` | Display Only | |
| `P2_NATIONALITY` | Display Only | |
| `P2_ORG_NAME` | Display Only | |
| `P2_COST_CENTER` | Display Only | |

**Region: My Requests (IR)**
```sql
SELECT request_number, request_type, requested_limit, status, submitted_at, created_at
FROM   prod.dct_cc_request_v
WHERE  created_by = :APP_USER_ID
ORDER  BY created_at DESC
```
- Link column: request_number → Page 3 with `P3_REQUEST_ID`

**Button: New Request** → Page 3 (create mode)

---

## Page 3 — Card Request Form

**Page Items:**
| Item | Type | Source | Notes |
|---|---|---|---|
| `P3_REQUEST_ID` | Hidden | — | PK |
| `P3_REQUEST_NUMBER` | Display Only | DCT_CC_REQUESTS | Auto-generated on insert |
| `P3_CC_ID` | Hidden | — | Pre-populated from :APP_MY_CC_ID if change request |
| `P3_REQUEST_TYPE` | Select List | LOV: NEW_CARD/INCREASE_LIMIT/DECREASE_LIMIT/CLOSE_CARD/REPLACEMENT | |
| `P3_REQUESTED_LIMIT` | Number Field | — | Show only for INCREASE/DECREASE type |
| `P3_REPLACEMENT_REASON` | Select List | LOV: DAMAGED/LOST/EXPIRING/OTHER | Show only for REPLACEMENT type |
| `P3_REASON` | Textarea | — | |
| `P3_STATUS` | Hidden | — | Defaults DRAFT |

**Dynamic Actions:**
- On Change `P3_REQUEST_TYPE`:
  - Show/Hide `P3_REQUESTED_LIMIT` (show if INCREASE_LIMIT or DECREASE_LIMIT)
  - Show/Hide `P3_REPLACEMENT_REASON` (show if REPLACEMENT)

**Subregion: Required Documents (IR)**
```sql
SELECT doc_req_id, document_name, is_mandatory
FROM   prod.dct_cc_doc_requirements
WHERE  request_type = :P3_REQUEST_TYPE
AND    is_active    = 'Y'
ORDER  BY display_seq
```
- Refreshes when `P3_REQUEST_TYPE` changes

**Subregion: Attachments (IR)**
```sql
SELECT attach_id, file_name, mime_type,
       ROUND(file_size/1024,1) || ' KB' AS file_size_disp,
       description, uploaded_at
FROM   prod.dct_cc_attachments
WHERE  source_type = 'REQUEST'
AND    source_id   = :P3_REQUEST_ID
```
- Upload button → APEX file browse item → process saves to DCT_CC_ATTACHMENTS
- Delete link per row

**Processes:**

*Save Request:*
```sql
MERGE INTO prod.dct_cc_requests t
USING (SELECT :P3_REQUEST_ID AS request_id FROM dual) s
ON (t.request_id = s.request_id)
WHEN MATCHED THEN
  UPDATE SET request_type      = :P3_REQUEST_TYPE,
             requested_limit   = :P3_REQUESTED_LIMIT,
             replacement_reason= :P3_REPLACEMENT_REASON,
             reason            = :P3_REASON,
             updated_by        = :APP_USER_ID,
             updated_at        = SYSDATE
WHEN NOT MATCHED THEN
  INSERT (request_number, cc_id, request_type, requested_limit,
          replacement_reason, reason, status, created_by, updated_by)
  VALUES ('CCR-' || TO_CHAR(SYSDATE,'YYYY') || '-' || LPAD(prod.seq_ccr_number.NEXTVAL,5,'0'),
          :APP_MY_CC_ID, :P3_REQUEST_TYPE, :P3_REQUESTED_LIMIT,
          :P3_REPLACEMENT_REASON, :P3_REASON, 'DRAFT', :APP_USER_ID, :APP_USER_ID)
RETURNING request_id INTO :P3_REQUEST_ID;
```

*Submit Request:*
- Update status to SUBMITTED
- Call `prod.dct_approval_pkg.create_instance` (or equivalent) with template based on request_type
- Update `dct_credit_cards.status` to `UNDER_PROCESS` / `REPLACEMENT_IN_PROGRESS` etc.

**Validation:**
- `P3_REQUEST_TYPE` required
- `P3_REQUESTED_LIMIT` required and > 0 when type is INCREASE/DECREASE
- `P3_REPLACEMENT_REASON` required when type is REPLACEMENT

**Read-only condition:** `status NOT IN ('DRAFT','RETURNED','WITHDRAWN')` — all items become Display Only

---

## Page 4 — All Credit Cards (CC Admin)

**Region: All Credit Cards (IR)**
```sql
SELECT cc_id, cc_number, holder_name, employee_num, org_name,
       credit_limit, expiry_date, status, bank_name,
       bank_customer_yn, bank_mobile_yn, created_at
FROM   prod.dct_cc_card_v
ORDER  BY created_at DESC
```
- Search bar: holder_name, cc_number, org_name, status
- Link: cc_number → Page 2 (read-only admin view)
- Actions menu: Deactivate Card button

---

## Page 5 — All Requests (CC Admin)

**Region: All Card Requests (IR)**
```sql
SELECT request_id, request_number, cc_number, holder_name,
       request_type, requested_limit, replacement_reason,
       status, submitted_at, created_at
FROM   prod.dct_cc_request_v
ORDER  BY created_at DESC
```
- Search: request_number, holder_name, request_type, status
- Link: request_number → Page 3 (read-only if status not editable)

---

## Page 6 — Pending Approvals

**Region: Pending Approvals (IR)**
```sql
SELECT ai.instance_id, ai.reference_id,
       CASE ai.module_code
         WHEN 'CREDIT_CARDS' THEN
           CASE (SELECT request_type FROM prod.dct_cc_requests WHERE request_id = ai.reference_id)
             WHEN 'REPLENISHMENT' THEN 'Replenishment'
             ELSE 'Card Request'
           END
       END                          AS request_category,
       r.request_number             AS ref_number,
       r.request_type,
       cv.holder_name,
       cv.cc_number,
       ai.overall_status,
       ai.current_step_seq,
       ai.created_at
FROM   prod.dct_approval_instances ai
JOIN   prod.dct_approval_steps     s   ON s.template_id = ai.template_id
                                      AND s.step_seq    = ai.current_step_seq
JOIN   prod.dct_user_roles         ur  ON ur.role_id    = s.required_role_id
                                      AND ur.is_active  = 'Y'
LEFT JOIN prod.dct_cc_requests     r   ON r.request_id  = ai.reference_id
LEFT JOIN prod.dct_cc_card_v       cv  ON cv.cc_id      = r.cc_id
WHERE  ur.user_id      = :APP_USER_ID
AND    ai.overall_status = 'PENDING'
AND    ai.module_code  = 'CREDIT_CARDS'
ORDER  BY ai.created_at
```

**Inline Approve / Reject** via modal (Page 6 modal region):
- Items: `P6_INSTANCE_ID`, `P6_ACTION` (Approve/Reject/Return), `P6_COMMENTS`
- Process: update `dct_approval_instances`, advance step or close, update card/request status
- Notify requester via `prod.dct_notify.send`

---

## Page 7 — Document Requirements (CC Admin)

**Region: Document Requirements (IG)**

Source table: `prod.dct_cc_doc_requirements`

Editable columns:
| Column | Type |
|---|---|
| `request_type` | Select List (static: NEW_CARD/INCREASE_LIMIT/DECREASE_LIMIT/CLOSE_CARD/REPLACEMENT) |
| `document_name` | Text Field |
| `is_mandatory` | Select List (LOV_YES_NO) |
| `is_active` | Select List (LOV_YES_NO) |
| `display_seq` | Number Field |

Process: Automatic Row Processing (MRU) + Insert + Delete

---

## Page 8 — Delegation

**Region: My Delegation Records (IR)**
```sql
SELECT d.delegation_id, dr.display_name AS delegate_name,
       d.start_date, d.end_date, d.reason, d.is_active,
       CASE WHEN d.is_active='Y' AND d.start_date<=SYSDATE AND NVL(d.end_date,SYSDATE)>=SYSDATE
            THEN 'Active' ELSE 'Inactive' END AS effective_status
FROM   prod.dct_cc_delegation d
JOIN   prod.dct_users         dr ON dr.user_id = d.delegate_user_id
WHERE  d.delegator_user_id = :APP_USER_ID
ORDER  BY d.start_date DESC
```

**Form Region: New Delegation**

Items:
| Item | Type |
|---|---|
| `P8_DELEGATION_ID` | Hidden |
| `P8_DELEGATE_USER_ID` | Select List (LOV_DCT_EMPLOYEES) |
| `P8_START_DATE` | Date Picker |
| `P8_END_DATE` | Date Picker |
| `P8_REASON` | Textarea |
| `P8_IS_ACTIVE` | Select List (LOV_YES_NO) |

Process: Save/Update delegation record with `delegator_user_id = :APP_USER_ID`

---

## Page 9 — Approval Rules (Master-Detail)

**Master Region: Approval Templates (IR)**
```sql
SELECT template_id, template_code, template_name, request_type,
       is_active, description
FROM   prod.dct_approval_templates
WHERE  module_code = 'CREDIT_CARDS'
ORDER  BY template_code
```

**Detail Region: Approval Steps (IG)**
```sql
SELECT s.step_id, s.step_seq, s.step_name,
       r.role_code, r.role_name,
       s.condition_type, s.amount_operator, s.amount_threshold,
       s.type_filter, s.custom_condition, s.is_active
FROM   prod.dct_approval_steps s
JOIN   prod.dct_roles          r ON r.role_id = s.required_role_id
WHERE  s.template_id = :P9_TEMPLATE_ID
ORDER  BY s.step_seq
```

Detail is filtered by selected master template.
IG allows add/edit/delete of steps. Condition type drives show/hide of amount/type/custom fields.

---

## Page 10 — Module Settings (IG)

**Region: Credit Cards Module Settings (IG)**
```sql
SELECT setting_id, setting_key, setting_value, description, data_type
FROM   prod.dct_module_settings
WHERE  module_code = 'CREDIT_CARDS'
AND    is_active   = 'Y'
ORDER  BY setting_key
```

Editable column: `setting_value` only (key and description are read-only display).
Process: Automatic Row Processing (MRU).

---

## Page 11 — My Replenishments

**Region: My Replenishments (IR)**
```sql
SELECT r.replenishment_id, r.reimb_number,
       r.period_month, r.period_year, r.period_label,
       r.total_amount, r.line_count, r.lines_total,
       r.submitted_by_name, r.status, r.submitted_at, r.created_at
FROM   prod.dct_cc_replenishment_v r
WHERE  r.on_behalf_of_user_id = :APP_USER_ID
   OR  r.submitted_by_user_id = :APP_USER_ID
ORDER  BY r.period_year DESC, r.period_month DESC
```
- Link: reimb_number → Page 12

**Button: New Replenishment** → Page 12 (create mode)
- Disabled if no ACTIVE card: condition `APP_MY_CC_ID IS NULL`

---

## Page 12 — Replenishment Form

**Header Region: Replenishment Details**

Items:
| Item | Type | Notes |
|---|---|---|
| `P12_REPLENISHMENT_ID` | Hidden | PK |
| `P12_REIMB_NUMBER` | Display Only | Auto-generated |
| `P12_CC_ID` | Hidden | Defaults :APP_MY_CC_ID; proxy can select from their proxied cards |
| `P12_CC_NUMBER` | Display Only | |
| `P12_PERIOD_MONTH` | Select List | LOV_MONTHS |
| `P12_PERIOD_YEAR` | Number Field | Defaults EXTRACT(YEAR FROM SYSDATE) |
| `P12_TOTAL_AMOUNT` | Number Field | Must equal sum of lines |
| `P12_STATUS` | Hidden | |
| `P12_ON_BEHALF_OF_USER_ID` | Hidden | Defaults :APP_USER_ID |

**Header Budget Coding Subregion:**
| Item | Type | Notes |
|---|---|---|
| `P12_CODING_TYPE` | Select List | GL / PROJECT |
| GL items (9) | Select Lists | Cascade LOVs (same as App 201) |
| `P12_CC_ID_GL` | Hidden | Resolved from GL segments |
| `P12_PROJECT_NUMBER` | Select List | LOV: from DCT_PROJECT_BUDGET_V |
| `P12_TASK_NUMBER` | Select List | Cascades from project |
| `P12_EXPENDITURE_TYPE` | Select List | Cascades from task |

**Dynamic Action: Coding Type Change**
- Show GL segment items when `P12_CODING_TYPE = 'GL'`
- Show Project items when `P12_CODING_TYPE = 'PROJECT'`
- On header coding change → Set Value of all IG line coding columns (default propagation)

**Lines Region: Expense Lines (IG)**

Source table: `prod.dct_cc_reimb_lines`
Where: `replenishment_id = :P12_REPLENISHMENT_ID`

Editable columns:
| Column | Type |
|---|---|
| `line_num` | Number (auto) |
| `expense_date` | Date Picker |
| `merchant_name` | Text Field |
| `amount` | Number Field |
| `description` | Text Field |
| `coding_type` | Select List (GL/PROJECT) |
| GL segment columns (9) | Select Lists with cascade |
| `cc_id_gl` | Hidden (resolved) |
| `project_number` | Select List |
| `task_number` | Select List |
| `expenditure_type` | Select List |
| `receipt_attached` | Display Only (Y/N — updated by attachment upload) |

**Attachments Subregion (per line):**
- Upload file → DCT_CC_ATTACHMENTS with source_type='REPLENISHMENT', source_id=P12_REPLENISHMENT_ID, reference_id=line_id
- On upload → update `receipt_attached = 'Y'` on the line

**Processes:**

*Save Header:*
```sql
MERGE INTO prod.dct_cc_replenishments t
USING (SELECT :P12_REPLENISHMENT_ID AS replenishment_id FROM dual) s
ON (t.replenishment_id = s.replenishment_id)
WHEN MATCHED THEN
  UPDATE SET period_month         = :P12_PERIOD_MONTH,
             period_year          = :P12_PERIOD_YEAR,
             total_amount         = :P12_TOTAL_AMOUNT,
             coding_type          = :P12_CODING_TYPE,
             cc_id_gl             = :P12_CC_ID_GL,
             project_number       = :P12_PROJECT_NUMBER,
             task_number          = :P12_TASK_NUMBER,
             expenditure_type     = :P12_EXPENDITURE_TYPE,
             updated_by           = :APP_USER_ID
WHEN NOT MATCHED THEN
  INSERT (reimb_number, cc_id, period_month, period_year, total_amount,
          submitted_by_user_id, on_behalf_of_user_id,
          coding_type, cc_id_gl, project_number, task_number, expenditure_type,
          status, created_by, updated_by)
  VALUES (
    'CCM-' || TO_CHAR(SYSDATE,'YYYY') || '-' || TO_CHAR(SYSDATE,'MM')
            || '-' || LPAD(prod.seq_ccm_number.NEXTVAL,5,'0'),
    :P12_CC_ID, :P12_PERIOD_MONTH, :P12_PERIOD_YEAR, :P12_TOTAL_AMOUNT,
    :APP_USER_ID, NVL(:P12_ON_BEHALF_OF_USER_ID,:APP_USER_ID),
    :P12_CODING_TYPE, :P12_CC_ID_GL, :P12_PROJECT_NUMBER,
    :P12_TASK_NUMBER, :P12_EXPENDITURE_TYPE,
    'DRAFT', :APP_USER_ID, :APP_USER_ID
  )
RETURNING replenishment_id INTO :P12_REPLENISHMENT_ID;
```

**Validation:**
- Period month + year required
- Total amount > 0
- Lines sum = total_amount (PL/SQL expression):
  `(SELECT NVL(SUM(amount),0) FROM prod.dct_cc_reimb_lines WHERE replenishment_id = :P12_REPLENISHMENT_ID) = :P12_TOTAL_AMOUNT`
- At least one line if `REPLENISHMENT_LINES_REQUIRED = 'Y'`
- No duplicate period for same card

**Read-only condition:** `status NOT IN ('DRAFT','RETURNED')` — all items become Display Only

---

## Page 13 — All Replenishments (CC Admin)

**Region: All Replenishments (IR)**
```sql
SELECT replenishment_id, reimb_number, cc_number,
       on_behalf_of_name, owner_employee_num,
       period_month, period_year, period_label,
       total_amount, line_count, status, submitted_at
FROM   prod.dct_cc_replenishment_v
ORDER  BY period_year DESC, period_month DESC, submitted_at DESC
```
- Search: cc_number, on_behalf_of_name, status, period
- Link: reimb_number → Page 12 (read-only)

---

## Page 14 — Proxy Management (CC Admin)

**Region: Proxy Assignments (IG)**

```sql
SELECT p.proxy_id, cc.cc_number,
       own.display_name   AS owner_name,
       prx.display_name   AS proxy_name,
       p.start_date, p.end_date, p.is_active,
       p.granted_by_user_id
FROM   prod.dct_cc_proxies    p
JOIN   prod.dct_credit_cards  cc  ON cc.cc_id   = p.cc_id
JOIN   prod.dct_users         own ON own.user_id = cc.holder_user_id
JOIN   prod.dct_users         prx ON prx.user_id = p.proxy_user_id
ORDER  BY cc.cc_number, p.start_date DESC
```

Editable columns:
| Column | Type |
|---|---|
| `cc_id` | Select List (LOV: cc_number / cc_id from DCT_CREDIT_CARDS) |
| `proxy_user_id` | Select List (LOV_DCT_EMPLOYEES) |
| `start_date` | Date Picker |
| `end_date` | Date Picker |
| `is_active` | Select List (LOV_YES_NO) |

Process: ARP + Insert. On insert set `granted_by_user_id = :APP_USER_ID`.

---

## Build Sequence Summary

```
9999 → 0 → 1 → 2 → 7 → 3 → 4 → 5 → 6 → 8 → 11 → 12 → 13 → 14 → 9 → 10
```

---

## Navigation / URL Reference

| Page | f?p URL |
|---|---|
| Login | f?p=202:9999 |
| Home | f?p=202:1 |
| My Card | f?p=202:2 |
| Request Form | f?p=202:3:::::P3_REQUEST_ID:[id] |
| All Cards | f?p=202:4 |
| All Requests | f?p=202:5 |
| Approve | f?p=202:6 |
| Doc Requirements | f?p=202:7 |
| Delegation | f?p=202:8 |
| Approval Rules | f?p=202:9 |
| Module Settings | f?p=202:10 |
| My Replenishments | f?p=202:11 |
| Replenishment Form | f?p=202:12:::::P12_REPLENISHMENT_ID:[id] |
| All Replenishments | f?p=202:13 |
| Proxy Management | f?p=202:14 |
