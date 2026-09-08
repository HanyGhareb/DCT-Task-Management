-- =============================================================================
-- !! FOLDED INTO 04_gl_views.sql on 2026-09-06 -- GL/db/04 is now the single
-- !! source of the DCT_GL_COA_V DDL (a 04 re-run on 2026-09-05 had silently
-- !! reverted this fix). Kept for history + its verification queries only;
-- !! NEVER run this file after 04 -- it would drop the Entity columns.
-- DCT_GL_COA_V -- Chapter classification also excludes account 452201
-- File    : 40_gl_coa_chapter_exclude_452201.sql   App 210 / GL     2026-09-01
-- Run     : sql -name prod_mcp @40_gl_coa_chapter_exclude_452201.sql (fresh session, ADMIN)
--
-- ROOT CAUSE (user-flagged 2026-09-01, "very very important"): account 452201
-- "Revenue Transfer to Treasury" is a STANDING PLATFORM-WIDE EXCLUSION --
-- already filtered out of every balance-bearing view (GL_BALANCES_CC itself
-- drops the raw row: NVL(REGEXP_SUBSTR(cc_string,'[^.]+',1,5),'x')<>'452201',
-- verified in its live DDL; DCT_EBS_BALANCE_MAPPED_V and DCT_GL_CASHFLOW_V do
-- the same -- 2026-08-02 rule, see project_gl_452201_bg_rules). So no dollar
-- amount for it reaches FMR, Budget Utilization, or any other report today.
--
-- BUT DCT_GL_COA_V (pure classification metadata, not amounts) still lists 4
-- real 452201 combinations (confirmed via dct_gl_coa_snap) -- currently
-- blank-Chapter only by COINCIDENCE (their appropriation happens to be
-- '000000', unmapped). Account 452201 starts with digit '4', so GL/db/39's
-- new "expense accounts only" gate ALONE would still let a Chapter through
-- the moment Fusion ever posts a 452201 combination against a chapter-mapped
-- appropriation -- reintroducing exactly the kind of misattribution db/39
-- just closed, for the one account that must never count at all.
--
-- FIX: ONE more AND condition on the same CHAPTER join (hm), alongside
-- db/39's digit-4 gate --
--   prod.dct_gl_class_pkg.norm(c.gl_account,6) <> '452201'
-- Mirrors the exact exclusion GL_BALANCES_CC already applies (same account,
-- same platform rule), just applied at the classification layer too, so it
-- can never surface a Chapter for this account regardless of appropriation.
--
-- Column list/order is UNCHANGED -- dct_gl_coa_stage/dct_gl_coa_snap need no
-- DDL change; prod.dct_actuals_refresh (db/v2/118) re-runs unmodified.
--
-- BACKUP: pre-fix view DDL saved at final apps/GL/db/_backups/
-- dct_gl_coa_v_ddl_backup_20260901_post39.sql (the state as of GL/db/39,
-- immediately before this file); snapshot data copied to
-- prod.dct_gl_coa_snap_bak20260901c. To roll back: run that backup file's
-- CREATE OR REPLACE VIEW, then BEGIN prod.dct_actuals_refresh; END;
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === backing up the live snapshot before touching the view ===
DECLARE l_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_count FROM dba_tables
   WHERE owner='PROD' AND table_name='DCT_GL_COA_SNAP_BAK20260901C';
  IF l_count=0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE prod.dct_gl_coa_snap_bak20260901c AS SELECT * FROM prod.dct_gl_coa_snap';
    DBMS_OUTPUT.PUT_LINE('Backup table created.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Backup table already exists -- left untouched.');
  END IF;
END;
/

CREATE OR REPLACE VIEW prod.dct_gl_coa_v AS
SELECT
  c.cc_id,
  -- zero-padded canonical segment codes (VARCHAR2)
  prod.dct_gl_class_pkg.norm(c.entity_code,     3) AS entity_code,
  prod.dct_gl_class_pkg.norm(c.cost_center,     7) AS cost_center_code,
  prod.dct_gl_class_pkg.norm(c.gl_account,      6) AS account_code,
  prod.dct_gl_class_pkg.norm(c.appropriation,   6) AS appropriation_code,
  prod.dct_gl_class_pkg.norm(c.budget_group,    1) AS budget_group_code,
  prod.dct_gl_class_pkg.norm(c.entity_specific, 7) AS entity_specific_code,
  prod.dct_gl_class_pkg.norm(c.future_1,        6) AS future1_code,
  prod.dct_gl_class_pkg.norm(c.future_2,        6) AS future2_code,
  prod.dct_gl_class_pkg.norm(c.intercompany,    3) AS intercompany_code,
  prod.dct_gl_class_pkg.norm(c.program_code,    6) AS program_code,
  -- descriptions
  e.description               AS entity_desc,
  cc.cost_center_description  AS cost_center_desc,
  ac.account_description      AS account_desc,
  ap.appropriation_description AS appropriation_desc,
  bg.budget_group_description AS budget_group_desc,
  es.entity_specific_descriptio AS entity_specific_desc,
  f1.future_1_description     AS future1_desc,
  f2.future_2_description     AS future2_desc,
  ic.intercompany_description AS intercompany_desc,
  pr.program_description      AS program_desc,
  -- full dotted combination string - the platform CANONICAL order, which since
  -- 2026-07-13 is the FUSION segment sequence (entity.program.cost_center.
  -- budget_group.account.entity_specific.appropriation.intercompany.f1.f2).
  -- MUST stay in lock-step with prod.dct_cc_canon (db/v2/40) and
  -- GL_BALANCES_CC (db/v2/32) - every combination join compares these strings.
  prod.dct_gl_class_pkg.norm(c.entity_code,3)     || '.' ||
  prod.dct_gl_class_pkg.norm(c.program_code,6)    || '.' ||
  prod.dct_gl_class_pkg.norm(c.cost_center,7)     || '.' ||
  prod.dct_gl_class_pkg.norm(c.budget_group,1)    || '.' ||
  prod.dct_gl_class_pkg.norm(c.gl_account,6)      || '.' ||
  prod.dct_gl_class_pkg.norm(c.entity_specific,7) || '.' ||
  prod.dct_gl_class_pkg.norm(c.appropriation,6)   || '.' ||
  prod.dct_gl_class_pkg.norm(c.intercompany,3)    || '.' ||
  prod.dct_gl_class_pkg.norm(c.future_1,6)        || '.' ||
  prod.dct_gl_class_pkg.norm(c.future_2,6)        AS cc_string,
  -- date-tracked classifications (effective on the as-of date)
  sv.value_code AS sector_code,   sv.name_en AS sector_name,
  hv.value_code AS chapter_code,  hv.name_en AS chapter_name,
  pv.value_code AS program_class_code, pv.name_en AS program_name,
  -- account type derived from the LEADING DIGIT of the (zero-padded) account
  -- segment: 1=Assets 2=Liability 3=Revenue 4=Expense 5=Owner's Equity.
  -- KEPT LAST so the DCT_GL_COA_SNAP refresh (INSERT ... SELECT *) stays aligned
  -- with the table's appended columns.
  SUBSTR(prod.dct_gl_class_pkg.norm(c.gl_account,6),1,1) AS account_type_code,
  CASE SUBSTR(prod.dct_gl_class_pkg.norm(c.gl_account,6),1,1)
    WHEN '1' THEN 'Assets'  WHEN '2' THEN 'Liability' WHEN '3' THEN 'Revenue'
    WHEN '4' THEN 'Expense' WHEN '5' THEN 'Owner''s Equity' END AS account_type
FROM (
  -- (a) real Fusion combinations -- unchanged, byte-identical to before.
  -- (b) budget-only combinations: any GL_BALANCES_CC.cc_string with no match
  --     among the real ones. real_cc is MATERIALIZE-hinted so the NOT EXISTS
  --     probe below computes each real combo's cc_string ONCE, not once per
  --     candidate row (same performance lesson as otbi-atd/db/80 -- an
  --     unhinted correlated check against a PL/SQL-function-heavy view here
  --     times out).
  WITH real_cc AS (
    SELECT /*+ MATERIALIZE */
           prod.dct_gl_class_pkg.norm(g.entity_code,3)     || '.' ||
           prod.dct_gl_class_pkg.norm(g.program_code,6)    || '.' ||
           prod.dct_gl_class_pkg.norm(g.cost_center,7)     || '.' ||
           prod.dct_gl_class_pkg.norm(g.budget_group,1)    || '.' ||
           prod.dct_gl_class_pkg.norm(g.gl_account,6)      || '.' ||
           prod.dct_gl_class_pkg.norm(g.entity_specific,7) || '.' ||
           prod.dct_gl_class_pkg.norm(g.appropriation,6)   || '.' ||
           prod.dct_gl_class_pkg.norm(g.intercompany,3)    || '.' ||
           prod.dct_gl_class_pkg.norm(g.future_1,6)        || '.' ||
           prod.dct_gl_class_pkg.norm(g.future_2,6)        AS cc_string
      FROM prod.gl_src_combinations g
  )
  SELECT entity_code, cost_center, gl_account, appropriation, budget_group,
         entity_specific, future_1, future_2, intercompany, program_code, cc_id
    FROM prod.gl_src_combinations
  UNION ALL
  -- gl_src_combinations' segment columns are NUMBER (verified 2026-09-01), so
  -- the synthetic leg must be too, or UNION ALL raises ORA-01790. norm() in
  -- the outer SELECT already round-trips through TRIM/LPAD on whatever comes
  -- in, so TO_NUMBER here is safe and lossless for these zero-padded digit
  -- codes -- the same implicit conversion the real rows already go through.
  SELECT TO_NUMBER(REGEXP_SUBSTR(b.cc_string,'[^.]+',1,1))  AS entity_code,
         TO_NUMBER(REGEXP_SUBSTR(b.cc_string,'[^.]+',1,3))  AS cost_center,
         TO_NUMBER(REGEXP_SUBSTR(b.cc_string,'[^.]+',1,5))  AS gl_account,
         TO_NUMBER(REGEXP_SUBSTR(b.cc_string,'[^.]+',1,7))  AS appropriation,
         TO_NUMBER(REGEXP_SUBSTR(b.cc_string,'[^.]+',1,4))  AS budget_group,
         TO_NUMBER(REGEXP_SUBSTR(b.cc_string,'[^.]+',1,6))  AS entity_specific,
         TO_NUMBER(REGEXP_SUBSTR(b.cc_string,'[^.]+',1,9))  AS future_1,
         TO_NUMBER(REGEXP_SUBSTR(b.cc_string,'[^.]+',1,10)) AS future_2,
         TO_NUMBER(REGEXP_SUBSTR(b.cc_string,'[^.]+',1,8))  AS intercompany,
         TO_NUMBER(REGEXP_SUBSTR(b.cc_string,'[^.]+',1,2))  AS program_code,
         -(1 + ORA_HASH(b.cc_string, 2147483646))           AS cc_id
    FROM (SELECT DISTINCT cc_string FROM prod.gl_balances_cc
           WHERE cc_string IS NOT NULL
             AND REGEXP_COUNT(cc_string,'\.') = 9) b
   WHERE NOT EXISTS (SELECT 1 FROM real_cc r WHERE r.cc_string = b.cc_string)
) c
LEFT JOIN (SELECT value, MAX(description) description FROM prod.gl_src_entity GROUP BY value) e
       ON e.value = c.entity_code
LEFT JOIN (SELECT cost_center, MAX(cost_center_description) cost_center_description FROM prod.gl_src_cost_centers GROUP BY cost_center) cc
       ON cc.cost_center = c.cost_center
LEFT JOIN (SELECT account_code, MAX(account_description) account_description FROM prod.gl_src_account GROUP BY account_code) ac
       ON ac.account_code = c.gl_account
LEFT JOIN (SELECT appropriation_code, MAX(appropriation_description) appropriation_description FROM prod.gl_src_appropriation GROUP BY appropriation_code) ap
       ON ap.appropriation_code = c.appropriation
LEFT JOIN (SELECT budget_group, MAX(budget_group_description) budget_group_description FROM prod.gl_src_budget_group GROUP BY budget_group) bg
       ON bg.budget_group = c.budget_group
LEFT JOIN (SELECT entity_specific, MAX(entity_specific_descriptio) entity_specific_descriptio FROM prod.gl_src_entity_specific GROUP BY entity_specific) es
       ON es.entity_specific = c.entity_specific
LEFT JOIN (SELECT future_1, MAX(future_1_description) future_1_description FROM prod.gl_src_future1 GROUP BY future_1) f1
       ON f1.future_1 = c.future_1
LEFT JOIN (SELECT future_2, MAX(future_2_description) future_2_description FROM prod.gl_src_future2 GROUP BY future_2) f2
       ON f2.future_2 = c.future_2
LEFT JOIN (SELECT intercompany, MAX(intercompany_description) intercompany_description FROM prod.gl_src_intercompany GROUP BY intercompany) ic
       ON ic.intercompany = c.intercompany
LEFT JOIN (SELECT program_code, MAX(program_description) program_description FROM prod.gl_src_program GROUP BY program_code) pr
       ON pr.program_code = c.program_code
LEFT JOIN prod.dct_gl_seg_class_map sm
       ON sm.class_type_code = 'SECTOR'
      AND sm.segment_value   = prod.dct_gl_class_pkg.norm(c.cost_center,7)
      AND NVL(TO_DATE(SYS_CONTEXT('GL_CTX','ASOF'),'YYYY-MM-DD'),TRUNC(SYSDATE))
            BETWEEN sm.start_date AND NVL(sm.end_date, DATE '4000-01-01')
LEFT JOIN prod.dct_gl_class_value sv ON sv.class_value_id = sm.class_value_id
LEFT JOIN prod.dct_gl_seg_class_map hm
       ON hm.class_type_code = 'CHAPTER'
      AND hm.segment_value   = prod.dct_gl_class_pkg.norm(c.appropriation,6)
      -- 2026-09-01 (GL/db/39): Chapter is an EXPENSE classification -- only
      -- apply it when the combination's own account is an expense account
      -- (leading digit 4). Stops a Chapter-mapped appropriation from
      -- bleeding onto Asset/Liability/Revenue accounts riding the SAME
      -- appropriation code (e.g. the 3xxxxx budgetary-control offset rows).
      AND SUBSTR(prod.dct_gl_class_pkg.norm(c.gl_account,6),1,1) = '4'
      -- 2026-09-01 (GL/db/40): account 452201 "Revenue Transfer to Treasury"
      -- is excluded from ALL calc/reporting platform-wide (same exclusion
      -- GL_BALANCES_CC already applies) -- never a Chapter either, even
      -- though it happens to start with digit 4.
      AND prod.dct_gl_class_pkg.norm(c.gl_account,6) <> '452201'
      AND NVL(TO_DATE(SYS_CONTEXT('GL_CTX','ASOF'),'YYYY-MM-DD'),TRUNC(SYSDATE))
            BETWEEN hm.start_date AND NVL(hm.end_date, DATE '4000-01-01')
LEFT JOIN prod.dct_gl_class_value hv ON hv.class_value_id = hm.class_value_id
LEFT JOIN prod.dct_gl_seg_class_map pm
       ON pm.class_type_code = 'DCT_PROGRAM'
      AND pm.segment_value   = prod.dct_gl_class_pkg.norm(c.program_code,6)
      AND NVL(TO_DATE(SYS_CONTEXT('GL_CTX','ASOF'),'YYYY-MM-DD'),TRUNC(SYSDATE))
            BETWEEN pm.start_date AND NVL(pm.end_date, DATE '4000-01-01')
LEFT JOIN prod.dct_gl_class_value pv ON pv.class_value_id = pm.class_value_id;

PROMPT === view redefined -- publishing the snapshot ===
BEGIN prod.dct_actuals_refresh; END;
/

PROMPT === refresh log (top 3) ===
SELECT run_id,status,source_rows,staged_rows,published_rows,duration_seconds,error_code,error_message
  FROM prod.dct_actuals_refresh_log ORDER BY run_id DESC FETCH FIRST 3 ROWS ONLY;

PROMPT === invalid PROD objects depending on the snapshot (must be 0) ===
SELECT COUNT(*) invalid_dependents FROM dba_objects o
 WHERE o.owner='PROD' AND o.status='INVALID'
   AND EXISTS (SELECT 1 FROM dba_dependencies d WHERE d.owner=o.owner AND d.name=o.object_name
                AND d.referenced_owner='PROD' AND d.referenced_name='DCT_GL_COA_SNAP');

PROMPT === all 452201 combos -- chapter must be NULL on every one ===
SELECT cc_string, account_code, account_type, appropriation_code, chapter_code, chapter_name
  FROM prod.dct_gl_coa_snap
 WHERE account_code = '452201';

PROMPT === count of 452201 combos still carrying a Chapter (must be 0) ===
SELECT COUNT(*) FROM prod.dct_gl_coa_snap
 WHERE account_code = '452201' AND chapter_code IS NOT NULL;

PROMPT === GL/db/39's fix still holds: non-expense combos with a Chapter (should be 0) ===
SELECT COUNT(*) FROM prod.dct_gl_coa_snap
 WHERE chapter_code IS NOT NULL AND SUBSTR(account_code,1,1) <> '4';

PROMPT === a real (non-452201) expense line still classifies normally (spot check) ===
SELECT cc_string, account_code, account_type, appropriation_code, chapter_code, chapter_name
  FROM prod.dct_gl_coa_snap
 WHERE appropriation_code = '202061' AND SUBSTR(account_code,1,1) = '4' AND account_code <> '452201'
 FETCH FIRST 3 ROWS ONLY;

EXIT;
