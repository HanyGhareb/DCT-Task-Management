-- =============================================================================
-- Freelancers Module (App 203) — APEX Shared Components Reference
-- File    : 02_shared_components.sql
-- Purpose : Documents SET_APP_ITEMS process body, authorization scheme
--           expressions, and GL cascade LOV queries for App 203.
--           Build these manually in APEX Builder — this file is reference only.
-- =============================================================================

/*
============================================================
SET_APP_ITEMS — Application Process
Process Point : On New Session
Sequence      : 10
============================================================
*/

-- SET_APP_ITEMS PL/SQL Body:
/*
DECLARE
  v_user prod.dct_users%ROWTYPE;
BEGIN
  -- Standard block (same across all module apps)
  BEGIN
    SELECT * INTO v_user
    FROM   prod.dct_users
    WHERE  UPPER(username) = UPPER(:APP_USER);
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN;
  END;

  :APP_USER_ID  := v_user.user_id;
  :APP_EMP_NUM  := v_user.employee_number;
  :APP_EMP_NAME := v_user.display_name;
  :APP_ORG_ID   := v_user.org_id;

  :APP_IS_ADMIN   := CASE WHEN prod.dct_auth.has_role(v_user.user_id,'ADMIN')   = 'Y' THEN 'Y' ELSE 'N' END;
  :APP_IS_MANAGER := CASE WHEN prod.dct_auth.has_role(v_user.user_id,'MANAGER') = 'Y' THEN 'Y' ELSE 'N' END;

  SELECT COUNT(*)
  INTO   :APP_PENDING_APPROVAL_COUNT
  FROM   prod.dct_approval_instances
  WHERE  current_approver_user_id = v_user.user_id
  AND    status = 'PENDING';

  -- Module-specific: FL_ADMIN flag
  :APP_IS_FL_ADMIN := CASE WHEN prod.dct_auth.has_role(v_user.user_id,'FL_ADMIN') = 'Y' THEN 'Y' ELSE 'N' END;

  -- Module-specific: Freelancer portal session
  -- Check if logged-in user is a registered freelancer (by email)
  BEGIN
    SELECT freelancer_id
    INTO   :APP_FL_FREELANCER_ID
    FROM   prod.dct_fl_freelancers
    WHERE  UPPER(email) = UPPER(:APP_USER)
    AND    status       = 'ACTIVE';
  EXCEPTION WHEN NO_DATA_FOUND THEN
    :APP_FL_FREELANCER_ID := NULL;
  END;

END;
*/

/*
============================================================
AUTHORIZATION SCHEMES — Create locally in App 203
============================================================

IS_FL_ADMIN
  Type       : PL/SQL Function Body (returning Boolean)
  Expression : RETURN :APP_IS_FL_ADMIN = 'Y';
  Caching    : Once per session

IS_FL_MANAGER_OR_ADMIN
  Type       : PL/SQL Function Body
  Expression : RETURN :APP_IS_MANAGER = 'Y' OR :APP_IS_FL_ADMIN = 'Y';
  Caching    : Once per session

IS_FREELANCER
  Type       : PL/SQL Function Body
  Expression : RETURN :APP_FL_FREELANCER_ID IS NOT NULL;
  Caching    : Once per page view

IS_OWN_CONTRACT
  Type       : PL/SQL Function Body
  Expression :
    DECLARE
      v NUMBER;
    BEGIN
      SELECT 1 INTO v
      FROM prod.dct_fl_contracts c
      JOIN prod.dct_fl_freelancers f ON f.freelancer_id = c.freelancer_id
      WHERE c.contract_id = :P30_CONTRACT_ID
        AND f.freelancer_id = :APP_FL_FREELANCER_ID;
      RETURN TRUE;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN FALSE;
    END;
  Caching    : Once per page view

============================================================
STANDARD SCHEMES — Subscribe from App 200
============================================================
  IS_ADMIN, IS_MANAGER, IS_MANAGER_OR_ADMIN

============================================================
COMMON LOVs — Subscribe from App 200
============================================================
  LOV_DCT_EMPLOYEES, LOV_DCT_EMPLOYEES_BY_ORG, LOV_DCT_ORGANIZATIONS,
  LOV_DCT_ROLES, LOV_YES_NO, LOV_ACTIVE_INACTIVE, LOV_MONTHS,
  LOV_APPROVAL_STATUS, LOV_REQUEST_STATUSES

============================================================
MODULE-SPECIFIC LOVs — Create locally in App 203
============================================================

LOV_FL_NATIONALITY
  SELECT nationality_name_en AS d, nationality_code AS r
  FROM   prod.dct_nationality
  WHERE  is_active = 'Y'
  ORDER BY display_seq, nationality_name_en

LOV_FL_FREELANCERS
  SELECT first_name_en || ' ' || last_name_en || ' (' || NVL(vendor_number,'no vendor#') || ')' AS d,
         freelancer_id AS r
  FROM   prod.dct_fl_freelancers
  WHERE  status = 'ACTIVE'
  ORDER BY first_name_en, last_name_en

LOV_FL_BILLING_UNIT
  SELECT v.value_name_en AS d, v.value_id AS r
  FROM   prod.dct_lookup_values v
  JOIN   prod.dct_lookup_categories c ON c.category_id = v.category_id
  WHERE  c.category_code = 'FL_BILLING_UNIT'
  AND    v.is_active     = 'Y'
  ORDER BY v.display_order

LOV_FL_PAYMENT_METHOD
  SELECT v.value_name_en AS d, v.value_code AS r
  FROM   prod.dct_lookup_values v
  JOIN   prod.dct_lookup_categories c ON c.category_id = v.category_id
  WHERE  c.category_code = 'FL_PAYMENT_METHOD'
  AND    v.is_active     = 'Y'
  ORDER BY v.display_order

LOV_FL_PAY_GROUP
  SELECT v.value_name_en AS d, v.value_code AS r
  FROM   prod.dct_lookup_values v
  JOIN   prod.dct_lookup_categories c ON c.category_id = v.category_id
  WHERE  c.category_code = 'FL_PAY_GROUP'
  AND    v.is_active     = 'Y'
  ORDER BY v.display_order

LOV_FL_DOCUMENT_TYPE
  SELECT v.value_name_en AS d, v.value_id AS r
  FROM   prod.dct_lookup_values v
  JOIN   prod.dct_lookup_categories c ON c.category_id = v.category_id
  WHERE  c.category_code = 'FL_DOCUMENT_TYPE'
  AND    v.is_active     = 'Y'
  ORDER BY v.display_order

LOV_FL_BILLING_METHOD
  SELECT 'Monthly'   AS d, 'MONTHLY'   AS r FROM dual UNION ALL
  SELECT 'Weekly'    AS d, 'WEEKLY'    AS r FROM dual UNION ALL
  SELECT 'Per Count' AS d, 'PER_COUNT' AS r FROM dual

LOV_FL_CODING_TYPE
  SELECT 'GL Code'       AS d, 'GL'      AS r FROM dual UNION ALL
  SELECT 'Project / Task' AS d, 'PROJECT' AS r FROM dual

============================================================
GL CASCADE LOVs — Same 9-segment pattern as App 201/202
============================================================
Subscribe from App 201 (Petty Cash) or App 202 (Credit Cards):
  LOV_GL_ENTITY_CODE, LOV_GL_APPROPRIATION, LOV_GL_COST_CENTER,
  LOV_GL_ENTITY_SPECIFIC, LOV_GL_BUDGET_GROUP_CODE, LOV_GL_ACCOUNT,
  LOV_GL_IC, LOV_GL_FUTURE1, LOV_GL_FUTURE2

============================================================
SEQUENCES — Number formatting
============================================================

Registration number : 'FL-REG-' || TO_CHAR(prod.seq_fl_reg_number.NEXTVAL,'FM000000')
Vendor number       : 'FL-VND-' || TO_CHAR(prod.seq_fl_vendor_number.NEXTVAL,'FM000000')
Contract number     : 'FL-CON-' || TO_CHAR(prod.seq_fl_contract_number.NEXTVAL,'FM000000')
Renewal number      : 'FL-RNW-' || TO_CHAR(prod.seq_fl_renewal_number.NEXTVAL,'FM000000')
Voucher number      : 'FL-VCH-' || TO_CHAR(prod.seq_fl_voucher_number.NEXTVAL,'FM000000')
*/

PROMPT 02_shared_components.sql — Reference file only. Build components in APEX Builder.
