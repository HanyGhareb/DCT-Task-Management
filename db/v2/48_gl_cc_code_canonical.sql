-- ===========================================================================
-- GL code-combination master - canonical cc_code (db/v2/48)
-- ---------------------------------------------------------------------------
-- Platform rule 2026-07-13: EVERY combination string in the platform uses the
-- one canonical segment order
--   entity(3).cost_center(7).account(6).appropriation(6).budget_group(1).
--   entity_specific(7).future1(6).future2(6).intercompany(3).program(6)
-- (same order as DCT_GL_COA_V.cc_string / prod.dct_cc_canon output).
--
-- DCT_GL_CODE_COMBINATIONS predates the rule: its cc_code virtual column was
-- built in the Fusion display order (entity.program.cc.bg.acct.es.appr.f1.f2)
-- and had no intercompany segment. This script (rerunnable):
--   1. adds INTERCOMPANY_CODE VARCHAR2(3) DEFAULT '000' NOT NULL (+ desc col)
--   2. drops + re-adds CC_CODE as the 10-segment canonical virtual column
--   3. recompiles the dependents (DT_REQUESTS_V, DCT_PC_FUSION_PKG)
-- Run as ADMIN (fresh session not required - no synonyms).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM all_tab_columns
   WHERE owner = 'PROD' AND table_name = 'DCT_GL_CODE_COMBINATIONS'
     AND column_name = 'INTERCOMPANY_CODE';
  IF l_n = 0 THEN
    EXECUTE IMMEDIATE q'[ALTER TABLE prod.dct_gl_code_combinations ADD (
      intercompany_code VARCHAR2(3) DEFAULT '000' NOT NULL,
      intercompany_desc VARCHAR2(255))]';
    DBMS_OUTPUT.put_line('added intercompany_code / intercompany_desc');
  ELSE
    DBMS_OUTPUT.put_line('intercompany_code already present');
  END IF;
END;
/

DECLARE
  l_default LONG;
  l_needs   NUMBER := 1;
BEGIN
  SELECT data_default INTO l_default FROM all_tab_columns
   WHERE owner = 'PROD' AND table_name = 'DCT_GL_CODE_COMBINATIONS'
     AND column_name = 'CC_CODE';
  IF INSTR(l_default, 'INTERCOMPANY_CODE') > 0 THEN
    l_needs := 0;
  END IF;
  IF l_needs = 1 THEN
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_gl_code_combinations DROP COLUMN cc_code';
    EXECUTE IMMEDIATE q'[ALTER TABLE prod.dct_gl_code_combinations ADD (
      cc_code VARCHAR2(200) GENERATED ALWAYS AS (
        entity_code           || '.' ||
        cost_center_code      || '.' ||
        account_code          || '.' ||
        appropriation_code    || '.' ||
        budget_group_code     || '.' ||
        entity_specific_code  || '.' ||
        future1_code          || '.' ||
        future2_code          || '.' ||
        intercompany_code     || '.' ||
        program_code) VIRTUAL)]';
    DBMS_OUTPUT.put_line('cc_code rebuilt in canonical order');
  ELSE
    DBMS_OUTPUT.put_line('cc_code already canonical');
  END IF;
END;
/

BEGIN
  BEGIN EXECUTE IMMEDIATE 'ALTER VIEW prod.dt_requests_v COMPILE'; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN EXECUTE IMMEDIATE 'ALTER PACKAGE prod.dct_pc_fusion_pkg COMPILE BODY'; EXCEPTION WHEN OTHERS THEN NULL; END;
END;
/

PROMPT === verification - expect canonical strings + zero INVALID ===
SELECT cc_code FROM prod.dct_gl_code_combinations FETCH FIRST 3 ROWS ONLY;
SELECT object_name, object_type, status FROM all_objects
 WHERE owner = 'PROD' AND status = 'INVALID';

PROMPT 48_gl_cc_code_canonical.sql complete.
