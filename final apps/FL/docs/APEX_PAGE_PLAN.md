# APEX Page Plan — Freelancers App 203
**APEX Version:** 24.2 | **Schema:** PROD | **Date:** 2026-05-14

---

## Page 9999 — Login
Standard APEX login page. Authentication via DCT_AUTH.

---

## Page 9998 — Self-Registration (Public)
**Auth:** Public (no authentication required)
**Region:** Single form

**Items:**
| Item | Type | Notes |
|---|---|---|
| P9998_FIRST_NAME_EN | Text | Required |
| P9998_LAST_NAME_EN | Text | Required |
| P9998_DATE_OF_BIRTH | Date Picker | Required |
| P9998_NATIONALITY_CODE | Select List | LOV_FL_NATIONALITY; Required |
| P9998_NATIONAL_ID | Text | Required when nationality = AE (dynamic show/hide) |
| P9998_PASSPORT_NUMBER | Text | |
| P9998_EMAIL | Text | Required |
| P9998_MOBILE | Text | |
| P9998_SPECIALIZATION | Text | |
| P9998_PHOTO | File Upload | Required if PHOTO_REQUIRED = Y |
| P9998_FIRST_DEAL | Select List | LOV_YES_NO; Default Y |
| P9998_NOTES | Textarea | |

**Dynamic Action:** On NATIONALITY_CODE change → show/hide P9998_NATIONAL_ID (required when = AE)

**Process — Submit Registration:**
```sql
DECLARE
  v_reg_num VARCHAR2(50);
  v_req     VARCHAR2(1);
BEGIN
  -- Check if Emirates ID required
  SELECT NVL(setting_value,'Y') INTO v_req
  FROM   prod.dct_module_settings ms
  JOIN   prod.dct_modules m ON m.module_id = ms.module_id
  WHERE  m.module_code = 'FREELANCERS'
  AND    ms.setting_key = 'NATIONAL_ID_REQUIRED_FOR_AE';

  IF :P9998_NATIONALITY_CODE = 'AE' AND v_req = 'Y'
     AND :P9998_NATIONAL_ID IS NULL THEN
    raise_application_error(-20001,'Emirates ID is required for UAE nationals.');
  END IF;

  v_reg_num := 'FL-REG-' || TO_CHAR(prod.seq_fl_reg_number.NEXTVAL,'FM000000');

  INSERT INTO prod.dct_fl_registrations (
    registration_number, first_name_en, last_name_en,
    date_of_birth, nationality_code, national_id, passport_number,
    email, mobile, specialization, first_deal_with_dct,
    submitted_by, notes, status, created_at, updated_at)
  VALUES (
    v_reg_num, :P9998_FIRST_NAME_EN, :P9998_LAST_NAME_EN,
    TO_DATE(:P9998_DATE_OF_BIRTH,'DD-MON-YYYY'), :P9998_NATIONALITY_CODE,
    :P9998_NATIONAL_ID, :P9998_PASSPORT_NUMBER,
    :P9998_EMAIL, :P9998_MOBILE, :P9998_SPECIALIZATION, :P9998_FIRST_DEAL,
    'SELF', :P9998_NOTES, 'SUBMITTED', SYSTIMESTAMP, SYSTIMESTAMP);
END;
```

---

## Page 0 — Global Page
**Region:** Notification Badge (same pattern as App 200/201/202)

```sql
SELECT :APP_PENDING_APPROVAL_COUNT FROM dual
```

---

## Page 1 — Home Dashboard
**Auth:** IS_FL_MANAGER_OR_ADMIN
**Regions:** KPI cards + recent activity

**KPI Cards:**
```sql
-- Total Active Freelancers
SELECT COUNT(*) FROM prod.dct_fl_freelancers WHERE status = 'ACTIVE'

-- Active Contracts
SELECT COUNT(*) FROM prod.dct_fl_contracts WHERE status = 'ACTIVE'

-- Pending Vouchers (by payment status)
SELECT COUNT(*) FROM prod.dct_fl_payment_vouchers
WHERE status = 'APPROVED' AND payment_status = 'PENDING'

-- Expiring Documents (next 30 days)
SELECT COUNT(*) FROM prod.dct_fl_document_v
WHERE expiry_status = 'EXPIRING_SOON' AND status = 'ACTIVE'

-- Pending Approvals
SELECT :APP_PENDING_APPROVAL_COUNT FROM dual
```

---

## Page 22 — Registration Requests (IR)
**Auth:** IS_FL_MANAGER_OR_ADMIN
**Source:** `prod.dct_fl_registration_v`

**Columns:** registration_number, full_name_en, nationality_name, email, submitted_by, first_deal_with_dct, status, created_at

**Actions:** View Detail (link to P23), Approve/Reject (button for manager/admin)

---

## Page 23 — Registration Form
**Auth:** IS_FL_ADMIN (edit) / IS_FL_MANAGER_OR_ADMIN (view)
**Items:** Same as P9998 plus status, approval controls

**Process — Submit for Approval:**
Starts `FL_REGISTRATION_APPROVAL` template, sets status = SUBMITTED.

**Process — Approve (post-approval trigger):**
Calls `DCT_FL_PKG.CREATE_FREELANCER_PROFILE(p_registration_id)` which:
1. Inserts into `DCT_FL_FREELANCERS` (copies all fields)
2. If AUTO_GENERATE_VENDOR_NUM = Y → vendor_number = 'FL-VND-' || seq
3. Inserts initial blank `DCT_FL_BANK_ACCOUNTS` record (or prompts admin to complete)

---

## Page 20 — All Freelancers (IR)
**Auth:** IS_FL_ADMIN
**Source:** `prod.dct_fl_freelancer_v`

**Columns:** vendor_number, full_name_en, nationality_name, email, mobile, status, active_contract_count, expired_doc_count, created_at

**Badges:** status (ACTIVE=green, INACTIVE=grey, BLACKLISTED=red), expired_doc_count (red if > 0)

---

## Page 21 — Freelancer Detail (Form)
**Auth:** IS_FL_ADMIN
**Items:** P21_FREELANCER_ID (hidden), all freelancer fields, bank account sub-region (IG)

**Bank Account IG source:** `prod.dct_fl_bank_accounts WHERE freelancer_id = :P21_FREELANCER_ID`
**Bank Account IG columns:** bank_name, account_number, iban, account_name, currency_code, is_primary, is_active

---

## Page 30 — All Contracts (IR)
**Auth:** IS_FL_ADMIN
**Source:** `prod.dct_fl_contract_v`

**Columns:** contract_number, version_number, freelancer_name, vendor_number, title, org_name, billing_method, total_amount, start_date, end_date, status, contract_bill_status, created_at

**Badges:** status, contract_bill_status (NOT_PAID=red, PARTIALLY_PAID=amber, FULLY_PAID=green)

---

## Page 31 — Contract Form
**Auth:** IS_FL_ADMIN
**Items:**

| Item | Type | Notes |
|---|---|---|
| P31_CONTRACT_ID | Hidden | |
| P31_CONTRACT_NUMBER | Display Only | Auto-generated |
| P31_FREELANCER_ID | Select List | LOV_FL_FREELANCERS |
| P31_TITLE | Text | Required |
| P31_START_DATE | Date Picker | Required |
| P31_END_DATE | Date Picker | |
| P31_TOTAL_AMOUNT | Number | Required |
| P31_BILLING_METHOD | Select List | LOV_FL_BILLING_METHOD |
| P31_BILLING_UNIT_ID | Select List | LOV_FL_BILLING_UNIT; shown when PER_COUNT |
| P31_BILLING_UNIT_AMOUNT | Number | |
| P31_ORG_ID | Select List | LOV_DCT_ORGANIZATIONS |
| P31_CODING_TYPE | Select List | LOV_FL_CODING_TYPE |
| P31_CC_ID_GL | Select List | LOV_GL_ENTITY_CODE cascade; shown when GL |
| P31_PROJECT_NUMBER | Text | shown when PROJECT |
| P31_TASK_NUMBER | Text | |
| P31_EXPENDITURE_TYPE | Text | |
| P31_NOTES | Textarea | |

**Dynamic Actions:** Show/hide GL vs PROJECT coding fields based on P31_CODING_TYPE

**Process — MERGE Contract:**
```sql
DECLARE
  v_num VARCHAR2(50);
BEGIN
  IF :P31_CONTRACT_ID IS NULL THEN
    v_num := 'FL-CON-' || TO_CHAR(prod.seq_fl_contract_number.NEXTVAL,'FM000000');
    INSERT INTO prod.dct_fl_contracts (
      contract_number, freelancer_id, title, start_date, end_date,
      total_amount, billing_method, billing_unit_id, billing_unit_amount,
      org_id, coding_type, cc_id_gl, project_number, task_number, expenditure_type,
      status, notes, created_by, created_at, updated_by, updated_at)
    VALUES (
      v_num, :P31_FREELANCER_ID, :P31_TITLE,
      TO_DATE(:P31_START_DATE,'DD-MON-YYYY'), TO_DATE(:P31_END_DATE,'DD-MON-YYYY'),
      :P31_TOTAL_AMOUNT, :P31_BILLING_METHOD, :P31_BILLING_UNIT_ID, :P31_BILLING_UNIT_AMOUNT,
      :P31_ORG_ID, :P31_CODING_TYPE, :P31_CC_ID_GL, :P31_PROJECT_NUMBER,
      :P31_TASK_NUMBER, :P31_EXPENDITURE_TYPE,
      'DRAFT', :P31_NOTES, :APP_USER_ID, SYSTIMESTAMP, :APP_USER_ID, SYSTIMESTAMP)
    RETURNING contract_id INTO :P31_CONTRACT_ID;
  ELSE
    -- Direct edit path (ALLOW_DIRECT_CONTRACT_EDIT = Y): increment version
    UPDATE prod.dct_fl_contracts
    SET title               = :P31_TITLE,
        start_date          = TO_DATE(:P31_START_DATE,'DD-MON-YYYY'),
        end_date            = TO_DATE(:P31_END_DATE,'DD-MON-YYYY'),
        total_amount        = :P31_TOTAL_AMOUNT,
        billing_unit_id     = :P31_BILLING_UNIT_ID,
        billing_unit_amount = :P31_BILLING_UNIT_AMOUNT,
        org_id              = :P31_ORG_ID,
        coding_type         = :P31_CODING_TYPE,
        cc_id_gl            = :P31_CC_ID_GL,
        project_number      = :P31_PROJECT_NUMBER,
        task_number         = :P31_TASK_NUMBER,
        expenditure_type    = :P31_EXPENDITURE_TYPE,
        notes               = :P31_NOTES,
        version_number      = version_number + 1,
        updated_by          = :APP_USER_ID
    WHERE contract_id = :P31_CONTRACT_ID;
  END IF;
END;
```

---

## Page 32 — Contract Detail + Schedule
**Auth:** IS_FL_ADMIN or IS_MANAGER
**Regions:**
1. Contract header (read-only form) — source: `dct_fl_contract_v WHERE contract_id = :P32_CONTRACT_ID`
2. Payment Schedule sub-region (IR) — source: `dct_fl_payment_schedule_v WHERE contract_id = :P32_CONTRACT_ID`
3. Vouchers sub-region (IR) — source: `dct_fl_voucher_v WHERE contract_id = :P32_CONTRACT_ID`

**Schedule IR columns:** period_label, due_date, amount, status, voucher_number, voucher_status

**Actions:** Generate Voucher button (per PENDING row) — redirects to P41 with P41_SCHEDULE_ID

---

## Page 33 — Amendment Form
**Auth:** IS_FL_ADMIN
**Condition:** `ALLOW_DIRECT_CONTRACT_EDIT = N` OR user explicitly creates amendment

**Items:**
| Item | Type | Notes |
|---|---|---|
| P33_CONTRACT_ID | Hidden | |
| P33_REASON | Textarea | Required |
| P33_CHANGE_SUMMARY | Textarea | |
| P33_NEW_TOTAL_AMOUNT | Number | Pre-filled from contract |
| P33_NEW_START_DATE | Date Picker | Editable only if no PAID schedule rows |
| P33_NEW_END_DATE | Date Picker | |
| P33_NEW_BILLING_METHOD | Select List | LOV_FL_BILLING_METHOD; locked if PAID rows |

**Validations:**
- new_total_amount ≥ SUM(PAID amounts)
- new_start_date ≥ MAX(due_date of PAID rows) if PAID rows exist
- billing_method cannot change if PAID rows exist

**Process:** INSERT into `dct_fl_contract_amendments` + start `FL_AMENDMENT_APPROVAL`

---

## Page 41 — Voucher Form
**Auth:** IS_FL_ADMIN
**Items:**

| Item | Type | Notes |
|---|---|---|
| P41_VOUCHER_ID | Hidden | |
| P41_SCHEDULE_ID | Hidden | Pre-filled from P32 |
| P41_CONTRACT_ID | Display Only | |
| P41_FREELANCER_ID | Display Only | |
| P41_PERIOD_LABEL | Display Only | From schedule |
| P41_AMOUNT | Number | Read-only unless ALLOW_VOUCHER_AMOUNT_OVERRIDE = Y |
| P41_INVOICE_NUMBER | Text | Required if VOUCHER_REQUIRE_INVOICE = Y |
| P41_INVOICE_DATE | Date Picker | Required if VOUCHER_REQUIRE_INVOICE = Y |
| P41_PAYMENT_METHOD | Select List | LOV_FL_PAYMENT_METHOD; default from module setting |
| P41_PAY_GROUP | Select List | LOV_FL_PAY_GROUP; default from module setting |
| P41_DESCRIPTION | Textarea | Default from VOUCHER_DEFAULT_DESCRIPTION |
| P41_CODING_TYPE | Display Only | Inherited from contract |
| P41_CC_ID_GL | Display Only | Inherited from contract |
| P41_PROJECT_NUMBER | Display Only | |
| P41_POST_TO_FUSION | Select List | LOV_YES_NO; default Y |
| P41_NOTES | Textarea | |

**Process — Generate Voucher:**
```sql
DECLARE
  v_num     VARCHAR2(50);
  v_desc    VARCHAR2(1000);
  v_con     prod.dct_fl_contracts%ROWTYPE;
  v_sched   prod.dct_fl_payment_schedule%ROWTYPE;
BEGIN
  SELECT * INTO v_con   FROM prod.dct_fl_contracts WHERE contract_id = :P41_CONTRACT_ID;
  SELECT * INTO v_sched FROM prod.dct_fl_payment_schedule WHERE schedule_id = :P41_SCHEDULE_ID;

  -- Token substitution for description
  SELECT REPLACE(REPLACE(NVL(setting_value,'Freelancer Payment'),
         '{CONTRACT_NUMBER}', v_con.contract_number),
         '{PERIOD_LABEL}', v_sched.period_label)
  INTO v_desc
  FROM prod.dct_module_settings ms
  JOIN prod.dct_modules m ON m.module_id = ms.module_id
  WHERE m.module_code = 'FREELANCERS' AND ms.setting_key = 'VOUCHER_DEFAULT_DESCRIPTION';

  v_num := 'FL-VCH-' || TO_CHAR(prod.seq_fl_voucher_number.NEXTVAL,'FM000000');

  INSERT INTO prod.dct_fl_payment_vouchers (
    voucher_number, contract_id, freelancer_id, schedule_id,
    period_label, due_date, amount,
    invoice_number, invoice_date, payment_method, pay_group, description,
    coding_type, cc_id_gl, project_number, task_number, expenditure_type,
    post_to_fusion, status, payment_status,
    created_by, created_at, updated_by, updated_at)
  VALUES (
    v_num, :P41_CONTRACT_ID, v_con.freelancer_id, :P41_SCHEDULE_ID,
    v_sched.period_label, v_sched.due_date, NVL(:P41_AMOUNT, v_sched.amount),
    :P41_INVOICE_NUMBER, TO_DATE(:P41_INVOICE_DATE,'DD-MON-YYYY'),
    :P41_PAYMENT_METHOD, :P41_PAY_GROUP, NVL(:P41_DESCRIPTION, v_desc),
    v_con.coding_type, v_con.cc_id_gl, v_con.project_number,
    v_con.task_number, v_con.expenditure_type,
    NVL(:P41_POST_TO_FUSION,'Y'), 'DRAFT', 'PENDING',
    :APP_USER_ID, SYSTIMESTAMP, :APP_USER_ID, SYSTIMESTAMP);

  -- Update schedule row
  UPDATE prod.dct_fl_payment_schedule
  SET status     = 'VOUCHER_GENERATED',
      updated_at = SYSTIMESTAMP
  WHERE schedule_id = :P41_SCHEDULE_ID;
END;
```

---

## Page 42 — Pending Approvals (IR)
**Auth:** IS_FL_MANAGER_OR_ADMIN
**Source:**
```sql
SELECT ai.instance_id,
       ai.reference_type,
       ai.reference_id,
       ai.status,
       ai.created_at,
       CASE ai.reference_type
         WHEN 'REGISTRATION' THEN (SELECT r.first_name_en || ' ' || r.last_name_en
                                   FROM prod.dct_fl_registrations r WHERE r.registration_id = ai.reference_id)
         WHEN 'CONTRACT'     THEN (SELECT c.contract_number FROM prod.dct_fl_contracts c WHERE c.contract_id = ai.reference_id)
         WHEN 'VOUCHER'      THEN (SELECT v.voucher_number FROM prod.dct_fl_payment_vouchers v WHERE v.voucher_id = ai.reference_id)
         WHEN 'RENEWAL'      THEN (SELECT r.renewal_number FROM prod.dct_fl_contract_renewals r WHERE r.renewal_id = ai.reference_id)
         ELSE TO_CHAR(ai.reference_id)
       END AS reference_label
FROM prod.dct_approval_instances ai
WHERE ai.current_approver_user_id = :APP_USER_ID
AND   ai.status = 'PENDING'
AND   ai.module_id = (SELECT module_id FROM prod.dct_modules WHERE module_code = 'FREELANCERS')
ORDER BY ai.created_at
```

---

## Page 50 — Deliverables — Accept/Reject (IR)
**Auth:** IS_FL_MANAGER_OR_ADMIN
**Source:** `prod.dct_fl_deliverable_v WHERE status = 'SUBMITTED'`

**Columns:** title, freelancer_name, contract_number, period_label, deliverable_date, quantity, unit_name, status

**Row Actions:** Accept (sets status = ACCEPTED, accepted_by = APP_USER_ID, accepted_date = SYSDATE) | Reject (popup for rejection_reason)

---

## Page 60 — Document Expiry Dashboard (IR)
**Auth:** IS_FL_ADMIN
**Source:** `prod.dct_fl_document_v WHERE status = 'ACTIVE' AND expiry_date IS NOT NULL`

**Columns:** freelancer_name, document_type_name, document_name, expiry_date, days_to_expiry, expiry_status

**Badges:** expiry_status (VALID=green, EXPIRING_SOON=amber, EXPIRED=red)

**Filter buttons:** All | Expiring Soon | Expired

---

## Page 34 — Renewal Requests (IR)
**Auth:** IS_FL_MANAGER_OR_ADMIN
**Source:**
```sql
SELECT r.renewal_id, r.renewal_number, r.status,
       c.contract_number AS original_contract_number,
       f.first_name_en || ' ' || f.last_name_en AS freelancer_name,
       r.new_start_date, r.new_end_date, r.new_total_amount,
       r.created_at
FROM prod.dct_fl_contract_renewals r
JOIN prod.dct_fl_contracts c ON c.contract_id = r.original_contract_id
JOIN prod.dct_fl_freelancers f ON f.freelancer_id = c.freelancer_id
ORDER BY r.created_at DESC
```

---

## Page 35 — Renewal Form
**Auth:** IS_FL_ADMIN
**Items:** Similar to Contract Form; pre-filled from original contract. On approval → `DCT_FL_PKG.CREATE_RENEWED_CONTRACT`.

---

## Page 10 — My Profile (Freelancer Portal)
**Auth:** IS_FREELANCER
**Source:** `prod.dct_fl_freelancer_v WHERE freelancer_id = :APP_FL_FREELANCER_ID`

Read-only view of profile + bank account. Button: Request Change → P_CHANGE_REQUEST form (if ALLOW_PROFILE_CHANGE_REQUEST = Y).

---

## Pages 11–14 — Freelancer Portal IRs

| Page | Source | Columns |
|---|---|---|
| P11 My Contracts | `dct_fl_contract_v WHERE freelancer_id = :APP_FL_FREELANCER_ID` | contract_number, title, billing_method, total_amount, status, contract_bill_status |
| P12 My Vouchers | `dct_fl_voucher_v WHERE freelancer_id = :APP_FL_FREELANCER_ID` | voucher_number, period_label, amount, status, payment_status, payment_date |
| P13 My Deliverables | `dct_fl_deliverable_v WHERE freelancer_id = :APP_FL_FREELANCER_ID` | title, contract_number, deliverable_date, quantity, status; + Submit New button |
| P14 My Documents | `dct_fl_document_v WHERE freelancer_id = :APP_FL_FREELANCER_ID` | document_type_name, document_name, expiry_date, expiry_status; + Upload button |

---

## Page 70 — Module Settings (IG)
**Auth:** IS_ADMIN
**Source:**
```sql
SELECT ms.setting_id, ms.setting_key, ms.setting_label,
       ms.setting_description, ms.setting_value, ms.value_type,
       ms.allowed_values, ms.default_value
FROM prod.dct_module_settings ms
JOIN prod.dct_modules m ON m.module_id = ms.module_id
WHERE m.module_code = 'FREELANCERS'
ORDER BY ms.setting_key
```

**Editable column:** setting_value only. All other columns read-only.

---

## Page 71 — Approval Rules (Master-Detail)
**Auth:** IS_ADMIN
**Master:** `prod.dct_approval_templates WHERE module_id = (SELECT module_id FROM prod.dct_modules WHERE module_code = 'FREELANCERS')`
**Detail:** `prod.dct_approval_steps WHERE template_id = :P71_TEMPLATE_ID ORDER BY step_seq`
