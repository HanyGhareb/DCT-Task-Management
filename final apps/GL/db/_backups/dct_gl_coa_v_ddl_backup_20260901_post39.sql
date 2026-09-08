
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PROD"."DCT_GL_COA_V" ("CC_ID", "ENTITY_CODE", "COST_CENTER_CODE", "ACCOUNT_CODE", "APPROPRIATION_CODE", "BUDGET_GROUP_CODE", "ENTITY_SPECIFIC_CODE", "FUTURE1_CODE", "FUTURE2_CODE", "INTERCOMPANY_CODE", "PROGRAM_CODE", "ENTITY_DESC", "COST_CENTER_DESC", "ACCOUNT_DESC", "APPROPRIATION_DESC", "BUDGET_GROUP_DESC", "ENTITY_SPECIFIC_DESC", "FUTURE1_DESC", "FUTURE2_DESC", "INTERCOMPANY_DESC", "PROGRAM_DESC", "CC_STRING", "SECTOR_CODE", "SECTOR_NAME", "CHAPTER_CODE", "CHAPTER_NAME", "PROGRAM_CLASS_CODE", "PROGRAM_NAME", "ACCOUNT_TYPE_CODE", "ACCOUNT_TYPE") DEFAULT COLLATION "USING_NLS_COMP"  AS
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
      -- 2026-09-01 fix: Chapter is an EXPENSE classification -- only apply it
      -- when the combination's own account is an expense account (leading
      -- digit 4). Same rule account_type already uses above; stops a
      -- Chapter-mapped appropriation from bleeding onto Asset/Liability/
      -- Revenue accounts riding the SAME appropriation code (e.g. the
      -- 3xxxxx budgetary-control offset mirror rows).
      AND SUBSTR(prod.dct_gl_class_pkg.norm(c.gl_account,6),1,1) = '4'
      AND NVL(TO_DATE(SYS_CONTEXT('GL_CTX','ASOF'),'YYYY-MM-DD'),TRUNC(SYSDATE))
            BETWEEN hm.start_date AND NVL(hm.end_date, DATE '4000-01-01')
LEFT JOIN prod.dct_gl_class_value hv ON hv.class_value_id = hm.class_value_id
LEFT JOIN prod.dct_gl_seg_class_map pm
       ON pm.class_type_code = 'DCT_PROGRAM'
      AND pm.segment_value   = prod.dct_gl_class_pkg.norm(c.program_code,6)
      AND NVL(TO_DATE(SYS_CONTEXT('GL_CTX','ASOF'),'YYYY-MM-DD'),TRUNC(SYSDATE))
            BETWEEN pm.start_date AND NVL(pm.end_date, DATE '4000-01-01')
LEFT JOIN prod.dct_gl_class_value pv ON pv.class_value_id = pm.class_value_id

