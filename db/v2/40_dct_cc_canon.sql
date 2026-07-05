-- ===========================================================================
-- DCT Actuals Reporting - charge-account canonicalizer (db/v2/40)
-- ---------------------------------------------------------------------------
-- prod.dct_cc_canon(p_cc) -> the COA canonical combination string
--   entity.cost_center.account.appropriation.budget_group.entity_specific.
--   future1.future2.intercompany.program
--
-- WHY: the 2026-07-05 ATD reload changed PR/PO CHARGE_ACCOUNT to the same
-- RE-ORDERED dot format that hit ATD_GL_BALANCES on 2026-07-02
-- (entity.program.cost_center.budget_group.account.entity_specific.
--  appropriation.intercompany.future1.future2) - every charge_account <-> COA
-- join matched ZERO rows, so the Actuals report showed Commitment (PR) and
-- Obligation (PO) all zeros.
--
-- FORMAT AUTO-DETECTION (self-heals if a future reload flips back):
--   NULL                          -> NULL
--   contains '-'                  -> legacy canonical dash form -> swap to dots
--   dot form, token#2 length = 7  -> already canonical (7-digit cost centre)
--   dot form, token#2 length <> 7 -> re-ordered feed (6-digit program at #2)
--                                    -> re-order s1.s3.s5.s7.s4.s6.s9.s10.s8.s2
--   (cost centres are always normalized 7-wide, programs 6-wide - the token#2
--    width is an unambiguous discriminator between the two dot forms.)
--
-- CONSUMERS (all charge_account joins/keys go through this function):
--   db/v2/32 DCT_ACTUAL_V + DCT_BUDGET_ACTUAL_V, db/v2/34 (grn/po),
--   db/v2/36 DCT_PR_COMMITMENT_PERIOD_V, db/v2/37 (po_dist/f_pr attributes),
--   GL/db/05 drill + dashboard handlers.
-- Note GL_BALANCES stays on the pure-SQL GL_BALANCES_CC view (db/v2/32 1b).
-- Run in a FRESH session (creates a synonym).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

CREATE OR REPLACE FUNCTION prod.dct_cc_canon (p_cc IN VARCHAR2)
RETURN VARCHAR2 DETERMINISTIC IS
  l_s2 VARCHAR2(40);
  TYPE t_seg IS VARRAY(10) OF VARCHAR2(40);
  s t_seg := t_seg(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
BEGIN
  IF p_cc IS NULL THEN RETURN NULL; END IF;
  IF INSTR(p_cc, '-') > 0 THEN RETURN REPLACE(p_cc, '-', '.'); END IF;
  l_s2 := REGEXP_SUBSTR(p_cc, '[^.]+', 1, 2);
  IF l_s2 IS NULL OR LENGTH(l_s2) = 7 THEN RETURN p_cc; END IF;
  FOR i IN 1 .. 10 LOOP
    s(i) := REGEXP_SUBSTR(p_cc, '[^.]+', 1, i);
  END LOOP;
  RETURN s(1)||'.'||s(3)||'.'||s(5)||'.'||s(7)||'.'||s(4)||'.'||s(6)||'.'
       ||s(9)||'.'||s(10)||'.'||s(8)||'.'||s(2);
END;
/

SHOW ERRORS

-- (no GRANT needed: the script runs AS ADMIN, which owns the create and has
--  EXECUTE ANY PROCEDURE; a self-GRANT raises ORA-01749)
CREATE OR REPLACE SYNONYM dct_cc_canon FOR prod.dct_cc_canon;

PROMPT prod.dct_cc_canon created (charge-account format canonicalizer).
