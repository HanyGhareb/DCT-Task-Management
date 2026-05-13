-- =============================================================================
-- Credit Cards App 202 — Shared Components Reference
-- File    : 02_shared_components.sql
-- Schema  : PROD (run as ADMIN)
-- Purpose : Reference script — displays copy-paste content for APEX Builder.
--           Run via SQLcl; copy the output into Shared Components as directed.
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

PROMPT ============================================================
PROMPT  App 202 — Shared Components Reference Output
PROMPT ============================================================

-- =============================================================================
-- APPLICATION ITEMS
-- Shared Components > Application Items > Create (one per item)
-- =============================================================================
/*
  Standard items (subscribe/match from App 200):
  Name                        Scope        Protection
  APP_USER_ID                 Application  Restricted
  APP_EMP_NUM                 Application  Restricted
  APP_EMP_NAME                Application  Unrestricted
  APP_ORG_ID                  Application  Restricted
  APP_IS_ADMIN                Application  Restricted
  APP_IS_MANAGER              Application  Restricted
  APP_PENDING_APPROVAL_COUNT  Application  Unrestricted

  Credit Cards module-specific items:
  Name                        Scope        Protection
  APP_IS_CC_ADMIN             Application  Restricted
  APP_HAS_ACTIVE_CARD         Application  Restricted
  APP_MY_CC_ID                Application  Restricted
*/

-- =============================================================================
-- SET_APP_ITEMS PROCESS SOURCE
-- Shared Components > Application Processes > SET_APP_ITEMS
-- Process Point: On New Session
-- =============================================================================
PROMPT
PROMPT === SET_APP_ITEMS Process Source — copy into APEX Builder ===
PROMPT

SELECT q'[
DECLARE
  v_user_id    NUMBER;
  v_emp_num    VARCHAR2(50);
  v_emp_name   VARCHAR2(200);
  v_org_id     NUMBER;
BEGIN
  -- Standard block (same in every module app)
  SELECT u.user_id, u.employee_number, u.display_name, u.org_id
  INTO   v_user_id, v_emp_num, v_emp_name, v_org_id
  FROM   prod.dct_users u
  WHERE  UPPER(u.username) = UPPER(:APP_USER);

  :APP_USER_ID  := v_user_id;
  :APP_EMP_NUM  := v_emp_num;
  :APP_EMP_NAME := v_emp_name;
  :APP_ORG_ID   := v_org_id;

  :APP_IS_ADMIN := CASE
    WHEN EXISTS (
      SELECT 1 FROM prod.dct_user_roles ur
      JOIN prod.dct_roles r ON r.role_id = ur.role_id
      WHERE ur.user_id = v_user_id AND r.role_code = 'ADMIN'
      AND ur.is_active = 'Y' AND (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
    ) THEN 'Y' ELSE 'N' END;

  :APP_IS_MANAGER := CASE
    WHEN EXISTS (
      SELECT 1 FROM prod.dct_user_roles ur
      JOIN prod.dct_roles r ON r.role_id = ur.role_id
      WHERE ur.user_id = v_user_id AND r.role_code = 'MANAGER'
      AND ur.is_active = 'Y' AND (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
    ) THEN 'Y' ELSE 'N' END;

  SELECT COUNT(DISTINCT ai.instance_id)
  INTO   :APP_PENDING_APPROVAL_COUNT
  FROM   prod.dct_approval_instances ai
  JOIN   prod.dct_approval_steps     s  ON s.template_id = ai.template_id
                                       AND s.step_seq    = ai.current_step_seq
  JOIN   prod.dct_user_roles         ur ON ur.role_id    = s.required_role_id
                                       AND ur.user_id    = v_user_id
                                       AND ur.is_active  = 'Y'
  WHERE  ai.overall_status = 'PENDING';

  -- Credit Cards module-specific items
  :APP_IS_CC_ADMIN := CASE
    WHEN EXISTS (
      SELECT 1 FROM prod.dct_user_roles ur
      JOIN prod.dct_roles r ON r.role_id = ur.role_id
      WHERE ur.user_id = v_user_id AND r.role_code = 'CC_ADMIN'
      AND ur.is_active = 'Y' AND (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
    ) THEN 'Y' ELSE 'N' END;

  SELECT COUNT(*),
         MAX(CASE WHEN status = 'ACTIVE' THEN cc_id END)
  INTO   :APP_HAS_ACTIVE_CARD,
         :APP_MY_CC_ID
  FROM   prod.dct_credit_cards
  WHERE  holder_user_id = v_user_id
  AND    status = 'ACTIVE';

EXCEPTION
  WHEN NO_DATA_FOUND THEN NULL;
END;
]' AS process_source FROM dual;

-- =============================================================================
-- AUTHORIZATION SCHEME EXPRESSIONS
-- Shared Components > Authorization Schemes > Create
-- Type: PL/SQL Function Body (returning Boolean)
-- Caching: Once per session (except IS_OWN_CARD: once per page view)
-- =============================================================================
PROMPT
PROMPT === Authorization Scheme Expressions ===
PROMPT

SELECT scheme_name, plsql_body FROM (
  SELECT 'IS_CC_ADMIN'         AS scheme_name,
         'RETURN :APP_IS_CC_ADMIN = ''Y'';' AS plsql_body FROM dual
  UNION ALL
  SELECT 'IS_MANAGER',
         'RETURN :APP_IS_MANAGER = ''Y'';' FROM dual
  UNION ALL
  SELECT 'IS_ADMIN',
         'RETURN :APP_IS_ADMIN = ''Y'';' FROM dual
  UNION ALL
  SELECT 'IS_MANAGER_OR_ADMIN',
         'RETURN :APP_IS_MANAGER = ''Y'' OR :APP_IS_CC_ADMIN = ''Y'';' FROM dual
  UNION ALL
  SELECT 'IS_OWN_CARD',
         'DECLARE v NUMBER;
BEGIN
  SELECT 1 INTO v
  FROM   prod.dct_credit_cards
  WHERE  cc_id          = :P2_CC_ID
  AND    holder_user_id = :APP_USER_ID;
  RETURN TRUE;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN FALSE;
END;' FROM dual
  UNION ALL
  SELECT 'IS_PROXY_SUBMITTER',
         'RETURN prod.dct_auth.has_role(''CC_ADMIN'', :APP_USER)
  OR EXISTS (
    SELECT 1 FROM prod.dct_cc_proxies p
    JOIN   prod.dct_credit_cards cc ON cc.cc_id = p.cc_id
    WHERE  p.proxy_user_id = :APP_USER_ID
    AND    p.is_active     = ''Y''
    AND    p.start_date   <= SYSDATE
    AND    (p.end_date IS NULL OR p.end_date >= SYSDATE)
  );' FROM dual
);

-- =============================================================================
-- GL SEGMENT CASCADE LOVs
-- Shared Components > List of Values — create one per segment
-- These are module-specific — not shared back to App 200
-- =============================================================================
PROMPT
PROMPT === GL Segment Cascade LOV Queries ===
PROMPT (same as App 201 — create locally in App 202)
PROMPT

SELECT lov_name, lov_query FROM (
  SELECT 'LOV_GL_ENTITY_CODE' AS lov_name,
         'SELECT DISTINCT entity_code d, entity_code r FROM prod.dct_gl_code_combinations WHERE is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1' AS lov_query FROM dual
  UNION ALL SELECT 'LOV_GL_APPROPRIATION',
         'SELECT DISTINCT appropriation d, appropriation r FROM prod.dct_gl_code_combinations WHERE entity_code = :ENTITY_CODE AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1' FROM dual
  UNION ALL SELECT 'LOV_GL_COST_CENTER',
         'SELECT DISTINCT cost_center d, cost_center r FROM prod.dct_gl_code_combinations WHERE entity_code = :ENTITY_CODE AND appropriation = :APPROPRIATION AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1' FROM dual
  UNION ALL SELECT 'LOV_GL_ENTITY_SPECIFIC',
         'SELECT DISTINCT entity_specific d, entity_specific r FROM prod.dct_gl_code_combinations WHERE cost_center = :COST_CENTER AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1' FROM dual
  UNION ALL SELECT 'LOV_GL_BUDGET_GROUP_CODE',
         'SELECT DISTINCT budget_group_code d, budget_group_code r FROM prod.dct_gl_code_combinations WHERE entity_specific = :ENTITY_SPECIFIC AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1' FROM dual
  UNION ALL SELECT 'LOV_GL_ACCOUNT',
         'SELECT DISTINCT account d, account r FROM prod.dct_gl_code_combinations WHERE budget_group_code = :BUDGET_GROUP_CODE AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1' FROM dual
  UNION ALL SELECT 'LOV_GL_IC',
         'SELECT DISTINCT ic d, ic r FROM prod.dct_gl_code_combinations WHERE account = :ACCOUNT AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1' FROM dual
  UNION ALL SELECT 'LOV_GL_FUTURE1',
         'SELECT DISTINCT future1 d, future1 r FROM prod.dct_gl_code_combinations WHERE ic = :IC AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1' FROM dual
  UNION ALL SELECT 'LOV_GL_FUTURE2',
         'SELECT DISTINCT future2 d, future2 r FROM prod.dct_gl_code_combinations WHERE future1 = :FUTURE1 AND is_active=''Y'' AND (end_date IS NULL OR end_date >= SYSDATE) ORDER BY 1' FROM dual
);

-- =============================================================================
-- CC_ID_GL RESOLUTION QUERY (for Dynamic Action on replenishment header/line)
-- =============================================================================
PROMPT
PROMPT === GL Code Combination ID Resolution Query ===
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
-- NUMBER GENERATION FORMATS (for page processes)
-- =============================================================================
PROMPT
PROMPT === Reference Number Formats ===
PROMPT

SELECT q'[
-- Credit Card number:
'CC-'  || TO_CHAR(SYSDATE,'YYYY') || '-' || LPAD(prod.seq_cc_number.NEXTVAL,  5, '0')

-- Card Request number:
'CCR-' || TO_CHAR(SYSDATE,'YYYY') || '-' || LPAD(prod.seq_ccr_number.NEXTVAL, 5, '0')

-- Monthly Replenishment number:
'CCM-' || TO_CHAR(SYSDATE,'YYYY') || '-' || TO_CHAR(SYSDATE,'MM')
       || '-' || LPAD(prod.seq_ccm_number.NEXTVAL, 5, '0')
]' AS number_formats FROM dual;

PROMPT
PROMPT === 02_shared_components.sql complete ===
PROMPT Copy displayed content into APEX Builder as directed in APEX_SETUP.md
