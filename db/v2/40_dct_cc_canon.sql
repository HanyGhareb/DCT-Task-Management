-- ===========================================================================
-- DCT Actuals Reporting - charge-account canonicalizer (db/v2/40)
-- ---------------------------------------------------------------------------
-- prod.dct_cc_canon(p_cc) -> the platform CANONICAL combination string, which
-- since 2026-07-13 (user directive) is the FUSION segment sequence:
--   entity(3).program(6).cost_center(7).budget_group(1).account(6).
--   entity_specific(7).appropriation(6).intercompany(3).future1(6).future2(6)
-- exactly as the Fusion UI shows a distribution combination.
--
-- HISTORY: the platform originally canonicalized to the old COA-view order
-- (entity.cc.account.appr.bg.es.f1.f2.ic.program). On 2026-07-13 the whole
-- derivation chain (this function, DCT_GL_COA_V.cc_string, GL_BALANCES_CC,
-- DCT_GL_COA_SNAP, DCT_GL_CODE_COMBINATIONS.cc_code) flipped TOGETHER to the
-- Fusion order - joins stay consistent because both sides derive from here.
--
-- FORMAT AUTO-DETECTION (self-heals whatever a reload delivers):
--   NULL                          -> NULL
--   contains '-'                  -> legacy dash form (old canonical order)
--                                    -> dots, then re-order below
--   dot form, token#2 length = 7  -> old canonical (7-digit cost centre at #2)
--                                    -> re-order c1.c10.c2.c5.c3.c6.c4.c9.c7.c8
--   dot form, token#2 length <> 7 -> already the Fusion order (6-digit program
--                                    at #2) -> returned as-is
--   (cost centres are always normalized 7-wide, programs 6-wide - the token#2
--    width is an unambiguous discriminator between the two dot forms.)
--
-- CONSUMERS (all charge_account joins/keys go through this function):
--   db/v2/32 DCT_ACTUAL_V + DCT_BUDGET_ACTUAL_V, db/v2/34 (grn/po),
--   db/v2/36 DCT_PR_COMMITMENT_PERIOD_V, db/v2/37 (po_dist/f_pr attributes),
--   db/v2/46 PO views, AP/db/04+05, GL/db/05 drill + dashboard handlers.
-- Note GL_BALANCES stays on the pure-SQL GL_BALANCES_CC view (db/v2/32 1b).
-- Run in a FRESH session (creates a synonym).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

CREATE OR REPLACE FUNCTION prod.dct_cc_canon (p_cc IN VARCHAR2)
RETURN VARCHAR2 DETERMINISTIC IS
  l_cc VARCHAR2(400);
  l_s2 VARCHAR2(40);
  TYPE t_seg IS VARRAY(10) OF VARCHAR2(40);
  s t_seg := t_seg(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
BEGIN
  IF p_cc IS NULL THEN RETURN NULL; END IF;
  l_cc := REPLACE(p_cc, '-', '.');
  l_s2 := REGEXP_SUBSTR(l_cc, '[^.]+', 1, 2);
  IF l_s2 IS NULL OR LENGTH(l_s2) <> 7 THEN RETURN l_cc; END IF;
  FOR i IN 1 .. 10 LOOP
    s(i) := REGEXP_SUBSTR(l_cc, '[^.]+', 1, i);
  END LOOP;
  RETURN s(1)||'.'||s(10)||'.'||s(2)||'.'||s(5)||'.'||s(3)||'.'||s(6)||'.'
       ||s(4)||'.'||s(9)||'.'||s(7)||'.'||s(8);
END;
/

SHOW ERRORS

-- (no GRANT needed: the script runs AS ADMIN, which owns the create and has
--  EXECUTE ANY PROCEDURE; a self-GRANT raises ORA-01749)
CREATE OR REPLACE SYNONYM dct_cc_canon FOR prod.dct_cc_canon;

PROMPT prod.dct_cc_canon created (Fusion-order combination canonicalizer).
