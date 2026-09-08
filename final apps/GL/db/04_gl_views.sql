-- ===========================================================================
-- General Ledger (App 210) - Layer 3b - unified views
-- ---------------------------------------------------------------------------
--  DCT_GL_COA_V       one row per CC_ID: all 10 segments (zero-padded) +
--                     descriptions + Sector/Chapter/DCT-Program effective on
--                     the as-of date (default SYSDATE; set via
--                     DCT_GL_CLASS_PKG.set_asof). Short synonym GL_COA_V.
--  DCT_GL_BALANCES_V  ATD_GL_BALANCES enriched with cost centre / account /
--                     effective Sector via DCT_GL_COA_V on the combination
--                     string (the slim reloaded table has no dimension cols).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

-- ---------------------------------------------------------------------------
-- SINGLE SOURCE OF TRUTH (2026-09-06): this file carries EVERY patch ever made
-- to DCT_GL_COA_V -- GL/db/38 (budget-only combinations from GL_BALANCES_CC,
-- negative hash cc_id), GL/db/39 (Chapter only on 4xxxxx expense accounts),
-- GL/db/40 (452201 never a Chapter) and GL/db/47 (Entity columns, kept LAST).
-- A re-run of this file on 2026-09-05 that pre-dated the fold silently REVERTED
-- 38/39/40 (snapshot lost its 632 budget-only combos; 3 non-expense combos got
-- a Chapter back). RULE: never re-create this view from any other file, and
-- fold every future patch back in here before re-running it.
-- ---------------------------------------------------------------------------
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
    WHEN '4' THEN 'Expense' WHEN '5' THEN 'Owner''s Equity' END AS account_type,
  -- Entity (GL/db/47, 2026-09-04): date-tracked rules on ANY of the 10 segments
  -- (dct_gl_seg_class_map.segment_key -- Entity only); the flagged default value
  -- covers what no rule matches; NULL = Unclassified. One rule per combination
  -- is enforced at save time -- the ORDER BY in the lateral join is a safety net.
  -- KEPT LAST (snapshot alignment: DCT_GL_COA_SNAP + _STAGE carry the same 4).
  NVL(er.class_value_id, ed.class_value_id) AS entity_class_value_id,
  NVL(er.value_code, ed.value_code)         AS entity_class_code,
  NVL(er.name_en, ed.name_en)               AS entity_class_name,
  CASE WHEN er.class_value_id IS NOT NULL THEN 'RULE'
       WHEN ed.class_value_id IS NOT NULL THEN 'DEFAULT' END AS entity_class_source
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
-- description joins are de-duplicated (GROUP BY) so duplicate codes in the
-- Fusion-loaded list tables (e.g. program 0 = "Unspecified"/"Un specified")
-- never fan out the one-row-per-combination grain.
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
LEFT JOIN prod.dct_gl_class_value pv ON pv.class_value_id = pm.class_value_id
LEFT JOIN LATERAL (
  SELECT ev.class_value_id, ev.value_code, ev.name_en
    FROM prod.dct_gl_seg_class_map em
    JOIN prod.dct_gl_class_type  et ON et.class_type_code = em.class_type_code
    JOIN prod.dct_gl_segment     eg ON eg.segment_key = NVL(em.segment_key, et.segment_key)
    JOIN prod.dct_gl_class_value ev ON ev.class_value_id = em.class_value_id
   WHERE em.class_type_code = 'ENTITY'
     AND NVL(TO_DATE(SYS_CONTEXT('GL_CTX','ASOF'),'YYYY-MM-DD'),TRUNC(SYSDATE))
           BETWEEN em.start_date AND NVL(em.end_date, DATE '4000-01-01')
     AND em.segment_value = CASE eg.segment_key
           WHEN 'ENTITY'          THEN prod.dct_gl_class_pkg.norm(c.entity_code,3)
           WHEN 'PROGRAM_CODE'    THEN prod.dct_gl_class_pkg.norm(c.program_code,6)
           WHEN 'COST_CENTER'     THEN prod.dct_gl_class_pkg.norm(c.cost_center,7)
           WHEN 'BUDGET_GROUP'    THEN prod.dct_gl_class_pkg.norm(c.budget_group,1)
           WHEN 'ACCOUNT'         THEN prod.dct_gl_class_pkg.norm(c.gl_account,6)
           WHEN 'ENTITY_SPECIFIC' THEN prod.dct_gl_class_pkg.norm(c.entity_specific,7)
           WHEN 'APPROPRIATION'   THEN prod.dct_gl_class_pkg.norm(c.appropriation,6)
           WHEN 'INTERCOMPANY'    THEN prod.dct_gl_class_pkg.norm(c.intercompany,3)
           WHEN 'FUTURE1'         THEN prod.dct_gl_class_pkg.norm(c.future_1,6)
           WHEN 'FUTURE2'         THEN prod.dct_gl_class_pkg.norm(c.future_2,6) END
   ORDER BY em.start_date, em.map_id
   FETCH FIRST 1 ROW ONLY) er ON 1 = 1
LEFT JOIN prod.dct_gl_class_value ed
       ON ed.class_type_code = 'ENTITY' AND ed.is_default = 'Y' AND ed.is_active = 'Y';

CREATE OR REPLACE SYNONYM prod.gl_coa_v FOR prod.dct_gl_coa_v;

-- ---------------------------------------------------------------------------
-- Budget balances enriched with cost centre / account / effective Sector.
-- REWRITTEN 2026-07-02: the reloaded ATD_GL_BALANCES no longer carries
-- COST_CENTER / ACCOUNT_CODE / GL_COMBINATION / FUNDS_AVAILABLE columns --
-- only CONCATENATED_SEGMENTS (dot-separated, DIFFERENT segment order than the
-- COA string). Reads prod.GL_BALANCES_CC (db/v2/32 -- the ONE canonical
-- combination-string remap; deploy 32 before re-running this script) and takes
-- all dimensions from the as-of-aware DCT_GL_COA_V (same GL_CTX semantics the
-- /balances handler already sets).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW prod.dct_gl_balances_v AS
SELECT
  b.*,
  coa.cost_center_code     AS cost_center,
  coa.cost_center_desc     AS cost_center_name,
  coa.account_code,
  coa.account_desc         AS account_name,
  b.funds_available_amount AS funds_available,
  coa.sector_code,
  coa.sector_name
FROM prod.gl_balances_cc b
LEFT JOIN prod.dct_gl_coa_v coa
       ON coa.cc_string = b.cc_string;

-- Keep the DCT_GL_COA_SNAP materialization aligned with DCT_GL_COA_V: the snapshot
-- refresh (prod.dct_actuals_refresh) does INSERT ... SELECT *, so the two account-type
-- columns must exist on the table, appended in the SAME order they end the view.
-- Idempotent: only runs when the snapshot exists and the columns are missing.
DECLARE
  l_tab NUMBER; l_col NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_tab FROM all_tables WHERE owner='PROD' AND table_name='DCT_GL_COA_SNAP';
  IF l_tab > 0 THEN
    SELECT COUNT(*) INTO l_col FROM all_tab_columns
     WHERE owner='PROD' AND table_name='DCT_GL_COA_SNAP' AND column_name='ACCOUNT_TYPE_CODE';
    IF l_col = 0 THEN
      EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_gl_coa_snap ADD (account_type_code VARCHAR2(1), account_type VARCHAR2(20))';
    END IF;
    -- Entity classification columns (GL/db/47) -- snapshot AND the db/v2/118 staging copy
    FOR t IN (SELECT column_value tab FROM TABLE(sys.odcivarchar2list('DCT_GL_COA_SNAP','DCT_GL_COA_STAGE'))) LOOP
      SELECT COUNT(*) INTO l_tab FROM all_tables WHERE owner='PROD' AND table_name=t.tab;
      IF l_tab > 0 THEN
        SELECT COUNT(*) INTO l_col FROM all_tab_columns
         WHERE owner='PROD' AND table_name=t.tab AND column_name='ENTITY_CLASS_CODE';
        IF l_col = 0 THEN
          EXECUTE IMMEDIATE 'ALTER TABLE prod.' || t.tab ||
            ' ADD (entity_class_value_id NUMBER, entity_class_code VARCHAR2(60), entity_class_name VARCHAR2(300), entity_class_source VARCHAR2(10))';
        END IF;
      END IF;
    END LOOP;
  END IF;
END;
/

PROMPT DCT_GL_COA_V (+ GL_COA_V) and DCT_GL_BALANCES_V created.
