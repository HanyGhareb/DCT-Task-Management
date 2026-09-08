-- ===========================================================================
-- i-Finance V2 -- 110: Fusion / EBS (legacy) GL segment mapping + balances
-- File   : db/v2/110_gl_ebs_map.sql
-- Purpose: the legacy EBS GL was used until 31-Dec-2025; Fusion from
--          01-Jan-2026. To produce prior-year reports the platform stores
--          (a) the segment cross-map between the two charts and (b) the EBS
--          historical balances at their native grain.
--          Two mappings are defined by Finance:
--            ACCOUNT       : EBS GL Account  <-> Fusion GL Account segment
--                            (seeded from docs/excel-integration/
--                             "COA Account_Mapping.xlsx" via load_coa_map.py)
--            APPROPRIATION : EBS Future2     <-> Fusion Appropriation segment
--                            (CORRECTED 2026-07-30 -- was modelled on Future1;
--                             the join lives ONLY in the mapped view, so the
--                             flip needed no reload. SEEDED 2026-07-30 as
--                             IDENTITY over the chart appropriation codes --
--                             user rule "same code"; view join zero-pads the
--                             EBS side to 6: LPAD(future2_code,6,'0'). No
--                             mapping file needed.)
--          EBS -> Fusion is a strict function: UNIQUE (segment_type,
--          ebs_value). Fusion -> EBS is 1:many (11 consolidations) -- Fusion-
--          keyed surfaces show a slash-joined list.
--          EBS balances arrive as the full 7-segment combination
--          Entity.CostCenter.BudgetCode.GLAccount.Activity.Future1.Future2
--          per Accounting Period with PTD amounts for the THREE balance
--          measures -- Actual (ptd_amount), Budget (budget_amount) and
--          Encumbrance (encumbrance_amount; added 2026-07-30). Stored
--          VERBATIM (never translated at load time); translation happens in
--          DCT_EBS_BALANCE_MAPPED_V so a mapping correction retroactively
--          fixes reports without a reload.
--          2026-07-30 (2): table extended to the full EBS "GL Period
--          Balances" export layout (docs/Reports/GL/Data, 2015-2025):
--          cc_id + the 7 per-segment description columns + account_type,
--          exposed by the mapped view as cc_id / ebs_*_desc /
--          ebs_account_type (the un-prefixed account_type/cost_center_desc
--          view columns remain the FUSION-side attributes). Adjustment
--          period "13-YYYY" is a valid accounting_period (period_date
--          = 31-Dec of the year so it lands inside Dec YTD windows).
-- Objects: DCT_GL_EBS_MAP (+DCT_GL_EBS_MAP_V), DCT_EBS_GL_BALANCE
--          (+DCT_EBS_BALANCE_MAPPED_V), lookup GL_XMAP_SEGMENT,
--          GL privileges GL_VIEW_EBS_MAPPING / GL_MANAGE_EBS_MAPPING.
-- Consumers: GL/db/16 ORDS (/gl/coamap, /gl/ebs-balances), GL app
--          "Legacy (EBS)" pages, reporting/db/25 EBS-account column,
--          EBS_GL_BALANCE_REGISTER report.
-- Deploy : python-oracledb from the dev VM (blocks are MERGE-adjacent and
--          Linux SQLcl swallows keyword-heavy blocks). Idempotent.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 110.1 lookup vocabulary GL_XMAP_SEGMENT ===
DECLARE
    l_cat NUMBER;
    l_n   NUMBER;
    PROCEDURE val (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_ord NUMBER) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_lookup_values
        WHERE  category_id = l_cat AND value_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_lookup_values
                   (category_id, value_code, value_name_en, value_name_ar,
                    display_order, is_active, created_by)
            VALUES (l_cat, p_code, p_en, p_ar, p_ord, 'Y', 'SYSTEM');
        END IF;
    END;
BEGIN
    BEGIN
        SELECT category_id INTO l_cat FROM prod.dct_lookup_categories
        WHERE  category_code = 'GL_XMAP_SEGMENT';
    EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO prod.dct_lookup_categories
               (category_code, category_name_en, category_name_ar, is_system, is_active, created_by)
        VALUES ('GL_XMAP_SEGMENT', 'Legacy Segment Mapping Type',
                UNISTR('\0631\0628\0637 \0642\0637\0627\0639\0627\062A \0627\0644\0646\0638\0627\0645 \0627\0644\0633\0627\0628\0642'),
                'N', 'Y', 'SYSTEM')
        RETURNING category_id INTO l_cat;
    END;
    val('ACCOUNT',       'GL Account',    UNISTR('\0627\0644\062D\0633\0627\0628'), 10);
    val('APPROPRIATION', 'Appropriation', UNISTR('\0627\0644\0627\0639\062A\0645\0627\062F'), 20);
    COMMIT;
END;
/

PROMPT === 110.2 mapping table DCT_GL_EBS_MAP ===
DECLARE
    l_n NUMBER;
BEGIN
    SELECT COUNT(*) INTO l_n FROM all_tables
    WHERE owner = 'PROD' AND table_name = 'DCT_GL_EBS_MAP';
    IF l_n = 0 THEN
        EXECUTE IMMEDIATE q'!
            CREATE TABLE prod.dct_gl_ebs_map (
                map_id        NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
                segment_type  VARCHAR2(30)  NOT NULL,
                ebs_value     VARCHAR2(30)  NOT NULL,
                fusion_value  VARCHAR2(30)  NOT NULL,
                parent_child  VARCHAR2(10)  DEFAULT 'CHILD',
                description   VARCHAR2(400),
                is_active     VARCHAR2(1)   DEFAULT 'Y' NOT NULL,
                created_by    VARCHAR2(100) DEFAULT 'SETUP',
                created_at    TIMESTAMP     DEFAULT SYSTIMESTAMP,
                updated_by    VARCHAR2(100),
                updated_at    TIMESTAMP,
                CONSTRAINT uq_glebsmap UNIQUE (segment_type, ebs_value)
            )!';
        EXECUTE IMMEDIATE
            'CREATE INDEX prod.ix_glebsmap_fusion ON prod.dct_gl_ebs_map (segment_type, fusion_value)';
    END IF;
END;
/

PROMPT === 110.3 legacy balances table DCT_EBS_GL_BALANCE ===
DECLARE
    l_n NUMBER;
BEGIN
    SELECT COUNT(*) INTO l_n FROM all_tables
    WHERE owner = 'PROD' AND table_name = 'DCT_EBS_GL_BALANCE';
    IF l_n = 0 THEN
        EXECUTE IMMEDIATE q'!
            CREATE TABLE prod.dct_ebs_gl_balance (
                bal_id            NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
                entity_code       VARCHAR2(3)  NOT NULL,
                cost_center_code  VARCHAR2(7)  NOT NULL,
                budget_code       VARCHAR2(1)  NOT NULL,
                account_code      VARCHAR2(6)  NOT NULL,
                activity_code     VARCHAR2(6)  NOT NULL,
                future1_code      VARCHAR2(6)  NOT NULL,
                future2_code      VARCHAR2(6)  NOT NULL,
                accounting_period VARCHAR2(20) NOT NULL,
                period_date       DATE,
                period_year       NUMBER,
                ptd_amount        NUMBER DEFAULT 0 NOT NULL,
                source_file       VARCHAR2(200),
                loaded_by         VARCHAR2(100),
                loaded_at         TIMESTAMP DEFAULT SYSTIMESTAMP,
                CONSTRAINT uq_ebsbal UNIQUE
                    (entity_code, cost_center_code, budget_code, account_code,
                     activity_code, future1_code, future2_code, accounting_period)
            )!';
        EXECUTE IMMEDIATE
            'CREATE INDEX prod.ix_ebsbal_year ON prod.dct_ebs_gl_balance (period_year, account_code)';
    END IF;
    SELECT COUNT(*) INTO l_n FROM all_tab_columns
    WHERE owner = 'PROD' AND table_name = 'DCT_EBS_GL_BALANCE'
      AND column_name = 'BUDGET_AMOUNT';
    IF l_n = 0 THEN
        EXECUTE IMMEDIATE q'!
            ALTER TABLE prod.dct_ebs_gl_balance ADD (
                budget_amount      NUMBER DEFAULT 0 NOT NULL,
                encumbrance_amount NUMBER DEFAULT 0 NOT NULL)!';
    END IF;
    -- 2026-08-02: YTD measures alongside PTD (refreshed 2016-2025 exports
    -- ship BOTH "GL Period Balances - PTD-<yr>.xlsx" and "- YTD-<yr>.xlsx"
    -- with identical row keys; merged into ONE row per combination x period).
    -- YTD is GENUINE data, not a running PTD sum -- it carries opening
    -- balances (e.g. Retained Earnings opens 2016 at 1.05B with PTD 0).
    SELECT COUNT(*) INTO l_n FROM all_tab_columns
    WHERE owner = 'PROD' AND table_name = 'DCT_EBS_GL_BALANCE'
      AND column_name = 'ACTUAL_YTD';
    IF l_n = 0 THEN
        EXECUTE IMMEDIATE q'!
            ALTER TABLE prod.dct_ebs_gl_balance ADD (
                budget_ytd      NUMBER DEFAULT 0 NOT NULL,
                encumbrance_ytd NUMBER DEFAULT 0 NOT NULL,
                actual_ytd      NUMBER DEFAULT 0 NOT NULL)!';
    END IF;
    -- 2026-07-30 (2): full EBS "GL Period Balances" export layout
    -- (docs/Reports/GL/Data 2015-2025): EBS code-combination id, per-segment
    -- descriptions and the EBS account type ride each balance row VERBATIM.
    SELECT COUNT(*) INTO l_n FROM all_tab_columns
    WHERE owner = 'PROD' AND table_name = 'DCT_EBS_GL_BALANCE'
      AND column_name = 'CC_ID';
    IF l_n = 0 THEN
        EXECUTE IMMEDIATE q'!
            ALTER TABLE prod.dct_ebs_gl_balance ADD (
                cc_id            NUMBER,
                entity_desc      VARCHAR2(240),
                cost_center_desc VARCHAR2(240),
                budget_desc      VARCHAR2(240),
                account_desc     VARCHAR2(240),
                activity_desc    VARCHAR2(240),
                future1_desc     VARCHAR2(240),
                future2_desc     VARCHAR2(240),
                account_type     VARCHAR2(60))!';
    END IF;
END;
/

PROMPT === 110.3b canonical segment widths + zero-pad normalization (user rule 2026-07-30) ===
-- Segment lengths are FIXED: Entity 3, Cost centre 7, Budget group 1,
-- GL Account 6, Activity 6, Future1 6, Future2 6 (matches the Fusion
-- canonical widths; Future2 = Appropriation = 6). EBS exports drop leading
-- zeros ('0' = '000000'), so stored values are zero-padded to exact width,
-- then the columns are shrunk from VARCHAR2(30). Idempotent: the UPDATE
-- only touches short values; MODIFY only fires when the width differs.
DECLARE
    l_n NUMBER;
    PROCEDURE fix (p_col VARCHAR2, p_w NUMBER) IS
        v NUMBER;
    BEGIN
        SELECT MAX(data_length) INTO v FROM all_tab_columns
        WHERE owner = 'PROD' AND table_name = 'DCT_EBS_GL_BALANCE'
          AND column_name = p_col;
        IF v IS NOT NULL AND v <> p_w THEN
            EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_ebs_gl_balance MODIFY ('
                || p_col || ' VARCHAR2(' || p_w || '))';
        END IF;
    END;
BEGIN
    UPDATE prod.dct_ebs_gl_balance
       SET entity_code      = LPAD(entity_code,      3, '0'),
           cost_center_code = LPAD(cost_center_code, 7, '0'),
           account_code     = LPAD(account_code,     6, '0'),
           activity_code    = LPAD(activity_code,    6, '0'),
           future1_code     = LPAD(future1_code,     6, '0'),
           future2_code     = LPAD(future2_code,     6, '0')
     WHERE LENGTH(entity_code)      < 3 OR LENGTH(cost_center_code) < 7
        OR LENGTH(account_code)     < 6 OR LENGTH(activity_code)    < 6
        OR LENGTH(future1_code)     < 6 OR LENGTH(future2_code)     < 6;
    l_n := SQL%ROWCOUNT;
    COMMIT;
    DBMS_OUTPUT.put_line('zero-padded rows: ' || l_n);
    fix('ENTITY_CODE',      3);
    fix('COST_CENTER_CODE', 7);
    fix('BUDGET_CODE',      1);
    fix('ACCOUNT_CODE',     6);
    fix('ACTIVITY_CODE',    6);
    fix('FUTURE1_CODE',     6);
    fix('FUTURE2_CODE',     6);
END;
/

PROMPT === 110.4 view DCT_GL_EBS_MAP_V (map + live-chart enrichment) ===
CREATE OR REPLACE VIEW prod.dct_gl_ebs_map_v AS
WITH acc AS (
  SELECT account_code, MAX(account_desc) AS account_desc
  FROM prod.dct_gl_coa_snap WHERE account_code IS NOT NULL GROUP BY account_code
),
apr AS (
  SELECT appropriation_code, MAX(appropriation_desc) AS appropriation_desc
  FROM prod.dct_gl_coa_snap WHERE appropriation_code IS NOT NULL GROUP BY appropriation_code
)
SELECT m.map_id, m.segment_type, m.ebs_value, m.fusion_value, m.parent_child,
       m.description, m.is_active,
       CASE m.segment_type
            WHEN 'ACCOUNT'       THEN a.account_desc
            WHEN 'APPROPRIATION' THEN p.appropriation_desc
       END AS fusion_desc,
       CASE WHEN (m.segment_type = 'ACCOUNT'       AND a.account_code IS NOT NULL)
              OR (m.segment_type = 'APPROPRIATION' AND p.appropriation_code IS NOT NULL)
            THEN 'Y' ELSE 'N' END AS in_chart,
       m.created_by, m.created_at, m.updated_by, m.updated_at
FROM prod.dct_gl_ebs_map m
LEFT JOIN acc a ON m.segment_type = 'ACCOUNT'       AND a.account_code = m.fusion_value
LEFT JOIN apr p ON m.segment_type = 'APPROPRIATION' AND p.appropriation_code = m.fusion_value;

PROMPT === 110.5 view DCT_EBS_BALANCE_MAPPED_V (balances translated to Fusion dims) ===
CREATE OR REPLACE VIEW prod.dct_ebs_balance_mapped_v AS
WITH acc AS (
  SELECT account_code, MAX(account_desc) AS account_desc, MAX(account_type) AS account_type
  FROM prod.dct_gl_coa_snap WHERE account_code IS NOT NULL GROUP BY account_code
),
apr AS (
  SELECT appropriation_code, MAX(appropriation_desc) AS appropriation_desc
  FROM prod.dct_gl_coa_snap WHERE appropriation_code IS NOT NULL GROUP BY appropriation_code
),
chap AS (
  SELECT m.segment_value AS appropriation_code, MAX(v.name_en) AS chapter_name
  FROM prod.dct_gl_seg_class_map m
  JOIN prod.dct_gl_class_value v ON v.class_value_id = m.class_value_id
  WHERE m.class_type_code = 'CHAPTER'
    AND TRUNC(SYSDATE) BETWEEN m.start_date AND NVL(m.end_date, DATE '9999-12-31')
  GROUP BY m.segment_value
),
ccd AS (
  SELECT cost_center_code, MAX(cost_center_desc) AS cost_center_desc,
         MAX(sector_name) AS sector_name
  FROM prod.dct_gl_coa_snap WHERE cost_center_code IS NOT NULL
  GROUP BY cost_center_code
)
SELECT
  b.bal_id, b.entity_code, b.cost_center_code, b.budget_code, b.account_code,
  b.activity_code, b.future1_code, b.future2_code,
  b.entity_code || '.' || b.cost_center_code || '.' || b.budget_code || '.' ||
  b.account_code || '.' || b.activity_code || '.' || b.future1_code || '.' ||
  b.future2_code AS ebs_combination,
  b.accounting_period, b.period_date, b.period_year,
  b.ptd_amount, b.budget_amount, b.encumbrance_amount,
  am.fusion_value AS fusion_account,
  ac.account_desc AS fusion_account_desc,
  ac.account_type,
  pm.fusion_value AS fusion_appropriation,
  ap.appropriation_desc AS fusion_appropriation_desc,
  ch.chapter_name AS chapter,
  cc.cost_center_desc, cc.sector_name AS sector,
  CASE WHEN am.fusion_value IS NOT NULL THEN 'Y' ELSE 'N' END AS account_mapped,
  CASE WHEN pm.fusion_value IS NOT NULL THEN 'Y' ELSE 'N' END AS appr_mapped,
  b.source_file, b.loaded_by, b.loaded_at,
  b.cc_id,
  b.entity_desc      AS ebs_entity_desc,
  b.cost_center_desc AS ebs_cost_center_desc,
  b.budget_desc      AS ebs_budget_desc,
  b.account_desc     AS ebs_account_desc,
  b.activity_desc    AS ebs_activity_desc,
  b.future1_desc     AS ebs_future1_desc,
  b.future2_desc     AS ebs_future2_desc,
  b.account_type     AS ebs_account_type,
  b.budget_ytd, b.encumbrance_ytd, b.actual_ytd
FROM prod.dct_ebs_gl_balance b
-- PLATFORM RULE 2026-08-02 (user): account 452201 "Revenue Transfer to
-- Treasury" is EXCLUDED from ALL calculations and reporting (2.1-5.1B
-- actual/yr -- the treasury remittance mis-classed as Expense). Fusion twin
-- of this filter lives in GL_BALANCES_CC (db/v2/32). Raw rows stay in the
-- table -- read-layer rule, reversible.
LEFT JOIN prod.dct_gl_ebs_map am
       ON am.segment_type = 'ACCOUNT' AND am.is_active = 'Y'
      AND am.ebs_value = b.account_code
LEFT JOIN prod.dct_gl_ebs_map pm
       ON pm.segment_type = 'APPROPRIATION' AND pm.is_active = 'Y'
      AND pm.ebs_value = LPAD(b.future2_code, 6, '0')
LEFT JOIN acc ac ON ac.account_code = am.fusion_value
LEFT JOIN apr ap ON ap.appropriation_code = pm.fusion_value
LEFT JOIN chap ch ON ch.appropriation_code = pm.fusion_value
LEFT JOIN ccd cc ON cc.cost_center_code = b.cost_center_code
WHERE b.account_code <> '452201'
  -- PLATFORM RULE 2026-09-06 (user): the funding side is never budget. EBS
  -- 351xxx 'Treasury Contribution towards Chapter-N' map onto Fusion 3270xx and
  -- carry the chapter budget MIRRORED (budget_ytd == the expense budget every
  -- year 2017-2025) plus the matching NEGATIVE actual (funds received). Dropped
  -- on the MAPPED Fusion account -- twin of GL_BALANCES_CC (db/v2/32); unmapped
  -- rows stay so the coverage annex still sees them. Read-layer, reversible.
  AND NVL(am.fusion_value, 'x') NOT LIKE '3270%';

PROMPT === 110.5b APPROPRIATION identity seed (user rule 2026-07-30) ===
-- The EBS Future2 code IS the Fusion Appropriation code (user-confirmed:
-- "same code, no difference") -- EBS just stores it without leading zeros
-- (Excel drop: '438' = '000438', '0' = '000000' Un Specified). So the map
-- is IDENTITY over the chart's appropriation codes, and the mapped view
-- joins on LPAD(future2_code, 6, '0'). 64 of the 66 Future2 values in the
-- 2015-2025 history match; the 2 leftovers (301005/201129 -- FA1005/FA1129
-- oddballs) carry zero amounts and stay unmapped. A future correction for
-- a specific code = edit its row in the Legacy tab (ebs_value in the
-- 6-digit padded form). Idempotent INSERT..SELECT, no MERGE.
INSERT INTO prod.dct_gl_ebs_map
       (segment_type, ebs_value, fusion_value, parent_child, description, created_by)
SELECT 'APPROPRIATION', s.appropriation_code, s.appropriation_code, 'CHILD',
       SUBSTR('Identity (Future2 = Appropriation): ' || s.appropriation_desc, 1, 400), 'SEED'
FROM  (SELECT appropriation_code, MAX(appropriation_desc) AS appropriation_desc
       FROM prod.dct_gl_coa_snap
       WHERE appropriation_code IS NOT NULL
       GROUP BY appropriation_code) s
WHERE NOT EXISTS (SELECT 1 FROM prod.dct_gl_ebs_map m
                  WHERE m.segment_type = 'APPROPRIATION'
                    AND m.ebs_value = s.appropriation_code);
COMMIT;

PROMPT === 110.6 GL privileges (Security Console, verb-first) ===
DECLARE
    l_gl NUMBER;
    PROCEDURE ins_priv (p_code VARCHAR2, p_name VARCHAR2, p_ar VARCHAR2,
                        p_action VARCHAR2, p_mid NUMBER) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_permissions WHERE permission_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_permissions
                (permission_code, permission_name, permission_name_ar,
                 module_id, action_type, verb, created_by)
            VALUES (p_code, p_name, p_ar, p_mid, p_action,
                 UPPER(REGEXP_SUBSTR(p_name, '^\S+')), 'SEED');
        END IF;
    END;
BEGIN
    SELECT MAX(module_id) INTO l_gl FROM prod.dct_modules WHERE module_code = 'GL';
    ins_priv('GL_VIEW_EBS_MAPPING',   'View Legacy EBS Mapping',
             UNISTR('\0639\0631\0636 \0631\0628\0637 \062D\0633\0627\0628\0627\062A \0627\0644\0646\0638\0627\0645 \0627\0644\0633\0627\0628\0642'), 'VIEW', l_gl);
    ins_priv('GL_MANAGE_EBS_MAPPING', 'Manage Legacy EBS Mapping',
             UNISTR('\0625\062F\0627\0631\0629 \0631\0628\0637 \062D\0633\0627\0628\0627\062A \0627\0644\0646\0638\0627\0645 \0627\0644\0633\0627\0628\0642'), 'CONFIGURE', l_gl);
    COMMIT;
END;
/

PROMPT === 110.7 verify ===
SELECT (SELECT COUNT(*) FROM prod.dct_gl_ebs_map) AS map_rows,
       (SELECT COUNT(*) FROM prod.dct_ebs_gl_balance) AS bal_rows,
       (SELECT COUNT(*) FROM all_objects WHERE owner = 'PROD' AND status = 'INVALID') AS invalid
FROM dual;

PROMPT ============================================================
PROMPT  110_gl_ebs_map.sql complete (map + balances + views + privs).
PROMPT ============================================================
