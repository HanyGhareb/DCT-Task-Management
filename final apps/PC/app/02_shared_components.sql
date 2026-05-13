-- =============================================================================
-- Petty Cash App 201 — Shared Components Setup
-- File    : 02_shared_components.sql
-- Schema  : PROD
-- Run     : After creating App 201 in APEX Builder, before building pages
-- Purpose : Creates application items, authorization schemes, and the
--           SET_APP_ITEMS process via APEX API calls.
--           Run connected as ADMIN (the APEX workspace schema).
-- =============================================================================
-- NOTE: This script uses APEX_APPLICATION_* APIs.
--       It must be run as the APEX workspace owner (ADMIN), not PROD.
--       The app items and auth schemes defined here match APEX_PAGE_PLAN.md.
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

DECLARE
  v_app_id  NUMBER := 201;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Setting up App ' || v_app_id || ' shared components...');
END;
/

-- =============================================================================
-- APPLICATION ITEMS
-- Create via APEX_UTIL or verify they exist after manual creation in Builder.
-- The list below is the canonical set — create each in Builder if not scripting.
-- =============================================================================
/*
  Items to create in Shared Components > Application Items:

  Name                        Scope        Protection
  APP_USER_ID                 Application  Restricted
  APP_EMP_NUM                 Application  Restricted
  APP_EMP_NAME                Application  Unrestricted
  APP_ORG_ID                  Application  Restricted
  APP_IS_PC_ADMIN             Application  Restricted
  APP_IS_MANAGER              Application  Restricted
  APP_IS_ADMIN                Application  Restricted
  APP_ACTIVE_PC_ID            Application  Restricted
  APP_ACTIVE_PC_COUNT         Application  Restricted
  APP_PENDING_APPROVAL_COUNT  Application  Unrestricted
*/

-- =============================================================================
-- APPLICATION PROCESS: SET_APP_ITEMS
-- Fires: On New Session (after authentication)
-- Populates all application items from PROD schema
-- =============================================================================
/*
  Create in Shared Components > Application Processes:

  Name           : SET_APP_ITEMS
  Sequence       : 10
  Process Point  : On New Session
  Condition      : No condition (always fire)
  Source (PL/SQL):
*/

-- Source for SET_APP_ITEMS process:
PROMPT
PROMPT === COPY THE FOLLOWING INTO APEX Builder ===
PROMPT === Shared Components > Application Processes > SET_APP_ITEMS ===
PROMPT

SELECT q'[
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

  -- Role flags
  :APP_IS_PC_ADMIN := CASE
    WHEN EXISTS (
      SELECT 1 FROM prod.dct_user_roles ur
      JOIN prod.dct_roles r ON r.role_id = ur.role_id
      WHERE ur.user_id = v_user_id
      AND   r.role_code = 'AP_PETTY_CASH_ADMIN'
      AND   ur.is_active = 'Y'
      AND   (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
    ) THEN 'Y' ELSE 'N' END;

  :APP_IS_MANAGER := CASE
    WHEN EXISTS (
      SELECT 1 FROM prod.dct_user_roles ur
      JOIN prod.dct_roles r ON r.role_id = ur.role_id
      WHERE ur.user_id = v_user_id
      AND   r.role_code = 'MANAGER'
      AND   ur.is_active = 'Y'
      AND   (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
    ) THEN 'Y' ELSE 'N' END;

  :APP_IS_ADMIN := CASE
    WHEN EXISTS (
      SELECT 1 FROM prod.dct_user_roles ur
      JOIN prod.dct_roles r ON r.role_id = ur.role_id
      WHERE ur.user_id = v_user_id
      AND   r.role_code = 'ADMIN'
      AND   ur.is_active = 'Y'
      AND   (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
    ) THEN 'Y' ELSE 'N' END;

  -- Active petty cash
  SELECT COUNT(*), MAX(CASE WHEN status = 'ACTIVE' THEN pc_id END)
  INTO   :APP_ACTIVE_PC_COUNT, :APP_ACTIVE_PC_ID
  FROM   prod.dct_petty_cash
  WHERE  user_id = v_user_id
  AND    status  = 'ACTIVE';

  -- Pending approvals in this user's queue
  SELECT COUNT(DISTINCT ai.instance_id)
  INTO   :APP_PENDING_APPROVAL_COUNT
  FROM   prod.dct_approval_instances ai
  JOIN   prod.dct_approval_steps     s   ON s.template_id = ai.template_id
                                        AND s.step_seq    = ai.current_step_seq
  JOIN   prod.dct_user_roles         ur  ON ur.role_id    = s.required_role_id
                                        AND ur.user_id    = v_user_id
                                        AND ur.is_active  = 'Y'
  WHERE  ai.overall_status = 'PENDING';

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- User not found in DCT_USERS — session will be rejected by auth scheme
    NULL;
END;
]' AS process_source FROM dual;

-- =============================================================================
-- AUTHORIZATION SCHEMES — SQL sources for copy-paste into APEX Builder
-- Shared Components > Authorization Schemes > Create
-- =============================================================================

PROMPT
PROMPT === AUTHORIZATION SCHEME SOURCES ===
PROMPT

SELECT 'IS_MANAGER' AS scheme_name,
       'RETURN :APP_IS_MANAGER = ''Y'';' AS plsql_body
FROM dual
UNION ALL
SELECT 'IS_PC_ADMIN',
       'RETURN :APP_IS_PC_ADMIN = ''Y'';'
FROM dual
UNION ALL
SELECT 'IS_ADMIN',
       'RETURN :APP_IS_ADMIN = ''Y'';'
FROM dual
UNION ALL
SELECT 'IS_MANAGER_OR_ADMIN',
       'RETURN :APP_IS_MANAGER = ''Y'' OR :APP_IS_PC_ADMIN = ''Y'';'
FROM dual
UNION ALL
SELECT 'IS_OWN_PC',
       'DECLARE v NUMBER; BEGIN SELECT 1 INTO v FROM prod.dct_petty_cash WHERE pc_id = :P3_PC_ID AND user_id = :APP_USER_ID; RETURN TRUE; EXCEPTION WHEN NO_DATA_FOUND THEN RETURN FALSE; END;'
FROM dual;

-- =============================================================================
-- SHARED LOVs FOR GL SEGMENT CASCADE
-- Create in Shared Components > List of Values
-- =============================================================================

PROMPT
PROMPT === SHARED LOV QUERIES FOR GL SEGMENTS ===
PROMPT

SELECT 'LOV_GL_ENTITY_CODE' AS lov_name,
       'SELECT DISTINCT entity_code d, entity_code r FROM prod.dct_gl_code_combinations WHERE is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1' AS lov_query
FROM dual
UNION ALL
SELECT 'LOV_GL_APPROPRIATION',
       'SELECT DISTINCT appropriation d, appropriation r FROM prod.dct_gl_code_combinations WHERE entity_code = :ENTITY_CODE AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1'
FROM dual
UNION ALL
SELECT 'LOV_GL_COST_CENTER',
       'SELECT DISTINCT cost_center d, cost_center r FROM prod.dct_gl_code_combinations WHERE entity_code = :ENTITY_CODE AND appropriation = :APPROPRIATION AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1'
FROM dual
UNION ALL
SELECT 'LOV_GL_ENTITY_SPECIFIC',
       'SELECT DISTINCT entity_specific d, entity_specific r FROM prod.dct_gl_code_combinations WHERE cost_center = :COST_CENTER AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1'
FROM dual
UNION ALL
SELECT 'LOV_GL_BUDGET_GROUP_CODE',
       'SELECT DISTINCT budget_group_code d, budget_group_code r FROM prod.dct_gl_code_combinations WHERE entity_specific = :ENTITY_SPECIFIC AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1'
FROM dual
UNION ALL
SELECT 'LOV_GL_ACCOUNT',
       'SELECT DISTINCT account d, account r FROM prod.dct_gl_code_combinations WHERE budget_group_code = :BUDGET_GROUP_CODE AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1'
FROM dual
UNION ALL
SELECT 'LOV_GL_IC',
       'SELECT DISTINCT ic d, ic r FROM prod.dct_gl_code_combinations WHERE account = :ACCOUNT AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1'
FROM dual
UNION ALL
SELECT 'LOV_GL_FUTURE1',
       'SELECT DISTINCT future1 d, future1 r FROM prod.dct_gl_code_combinations WHERE ic = :IC AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1'
FROM dual
UNION ALL
SELECT 'LOV_GL_FUTURE2',
       'SELECT DISTINCT future2 d, future2 r FROM prod.dct_gl_code_combinations WHERE future1 = :FUTURE1 AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1'
FROM dual;

-- =============================================================================
-- CC_ID RESOLUTION QUERY (use in Dynamic Action / Page Process)
-- Resolves all 9 selected segments to a single CC_ID
-- =============================================================================
PROMPT
PROMPT === CC_ID RESOLUTION QUERY ===
PROMPT

SELECT q'[
SELECT cc_id
FROM   prod.dct_gl_code_combinations
WHERE  entity_code       = :ENTITY_CODE
AND    NVL(appropriation,    '~') = NVL(:APPROPRIATION,    '~')
AND    NVL(cost_center,      '~') = NVL(:COST_CENTER,      '~')
AND    NVL(entity_specific,  '~') = NVL(:ENTITY_SPECIFIC,  '~')
AND    NVL(budget_group_code,'~') = NVL(:BUDGET_GROUP_CODE,'~')
AND    NVL(account,          '~') = NVL(:ACCOUNT,          '~')
AND    NVL(ic,               '~') = NVL(:IC,               '~')
AND    NVL(future1,          '~') = NVL(:FUTURE1,          '~')
AND    NVL(future2,          '~') = NVL(:FUTURE2,          '~')
AND    is_active = 'Y'
]' AS cc_id_resolution_query FROM dual;

-- =============================================================================
-- BUDGET LINE VALIDATION QUERIES
-- =============================================================================
PROMPT
PROMPT === BUDGET LINE SUM VALIDATION ===
PROMPT

-- Validation: budget lines sum must equal request amount
-- Use in Page Validation, type: PL/SQL Expression
SELECT q'[
-- For Page 3 (Petty Cash):
(SELECT NVL(SUM(amount),0) FROM prod.dct_pc_budget_lines WHERE pc_id = :P3_PC_ID) = :P3_AMOUNT
]' AS budget_sum_validation FROM dual;

-- =============================================================================
-- NUMBER GENERATOR QUERIES (for page processes)
-- =============================================================================
PROMPT
PROMPT === REQUEST NUMBER GENERATION ===
PROMPT

SELECT q'[
-- Petty Cash number:
'PC-' || TO_CHAR(SYSDATE,'YYYY') || '-' || LPAD(prod.seq_pc_number.NEXTVAL, 5, '0')

-- Reimbursement number:
'RMB-' || TO_CHAR(SYSDATE,'YYYY') || '-' || LPAD(prod.seq_reimb_number.NEXTVAL, 5, '0')

-- Clearing number:
'CLR-' || TO_CHAR(SYSDATE,'YYYY') || '-' || LPAD(prod.seq_clr_number.NEXTVAL, 5, '0')
]' AS number_formats FROM dual;

COMMIT;
PROMPT
PROMPT === 02_shared_components.sql complete ===
PROMPT Copy the displayed queries into APEX Builder as instructed in APEX_SETUP.md
