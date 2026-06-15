-- =============================================================================
-- Task Management Module (App 207) -- Measurable Objectives (Key Results)
-- File    : 08_tm_key_results.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @08_tm_key_results.sql   (after 01_tm_ddl.sql)
-- Safe    : Re-runnable -- table/column creation guarded; lookup seed is upsert.
-- Adds    : DCT_TM_KEY_RESULTS (1..N measurable key results per objective) +
--           DCT_TM_OBJECTIVES.progress_mode (AUTO|MANUAL) + TM_KR_DIRECTION /
--           TM_KR_UNIT lookup vocabularies. Lookup-first -- no status CHECKs.
-- Notes   : KR status reuses the TM_OBJECTIVE_STATUS lookup set; KR CRUD is
--           governed by the existing OBJECTIVE artifact permission (no new
--           DCT_TM_ROLE_PERMS rows). Per-KR progress is computed in the view;
--           the objective roll-up is recomputed by DCT_TM_PKG on every change.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. TABLE + INDEX + TRIGGER + objective column (re-runnable)
-- =============================================================================
DECLARE
    PROCEDURE run_ddl (p_sql VARCHAR2, p_ignore NUMBER) IS
    BEGIN
        EXECUTE IMMEDIATE p_sql;
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE != p_ignore THEN RAISE; END IF;   -- ignore the "already exists" case
    END;
BEGIN
    -- key results table (ORA-00955 = name already used by an existing object)
    run_ddl(q'[
        CREATE TABLE prod.dct_tm_key_results (
          kr_id            NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          objective_id     NUMBER          NOT NULL,
          title_en         VARCHAR2(300)   NOT NULL,
          title_ar         VARCHAR2(300),
          unit             VARCHAR2(30),                          -- free text (datalist-suggested, not validated)
          direction        VARCHAR2(10)    DEFAULT 'INCREASE' NOT NULL,  -- lookup TM_KR_DIRECTION
          baseline_value   NUMBER,
          target_value     NUMBER          NOT NULL,
          current_value    NUMBER,
          weight           NUMBER(5,2)     DEFAULT 1 NOT NULL,    -- relative weight for objective roll-up
          target_date      DATE,
          status           VARCHAR2(30)    DEFAULT 'NOT_STARTED' NOT NULL,  -- lookup TM_OBJECTIVE_STATUS
          display_order    NUMBER          DEFAULT 100 NOT NULL,
          created_by       VARCHAR2(100),
          created_at       DATE            DEFAULT SYSDATE NOT NULL,
          updated_by       VARCHAR2(100),
          updated_at       DATE            DEFAULT SYSDATE NOT NULL,
          --
          CONSTRAINT chk_dct_tm_kr_wt  CHECK (weight >= 0),
          CONSTRAINT fk_dct_tm_kr_obj  FOREIGN KEY (objective_id) REFERENCES prod.dct_tm_objectives(objective_id) ON DELETE CASCADE
        )]', -955);

    run_ddl('CREATE INDEX prod.ix_dct_tm_kr_obj ON prod.dct_tm_key_results (objective_id, display_order)', -955);

    -- updated_at trigger (CREATE OR REPLACE -- always safe)
    EXECUTE IMMEDIATE q'[
        CREATE OR REPLACE TRIGGER prod.trg_dct_tm_key_results_upd
          BEFORE UPDATE ON prod.dct_tm_key_results FOR EACH ROW
          BEGIN :NEW.updated_at := SYSDATE; END;]';

    -- objective progress mode (ORA-01430 = column being added already exists)
    run_ddl(q'[ALTER TABLE prod.dct_tm_objectives ADD (progress_mode VARCHAR2(10) DEFAULT 'AUTO' NOT NULL)]', -1430);

    DBMS_OUTPUT.PUT_LINE('DCT_TM_KEY_RESULTS + objective progress_mode ready.');
END;
/

COMMENT ON TABLE prod.dct_tm_key_results IS 'Measurable key results (OKR-style) per team objective; objective progress rolls up from these.';
COMMENT ON COLUMN prod.dct_tm_key_results.direction IS 'Lookup TM_KR_DIRECTION: INCREASE (higher is better), DECREASE (lower is better), MAINTAIN (hold at/above target).';
COMMENT ON COLUMN prod.dct_tm_objectives.progress_mode IS 'AUTO = progress_pct is the weighted roll-up of key results; MANUAL = hand-entered progress_pct.';

-- =============================================================================
-- 2. LOOKUP VOCABULARIES  (upsert -- idempotent)
-- =============================================================================
DECLARE
    v_cat NUMBER;

    PROCEDURE upsert_category (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, o_id OUT NUMBER) IS
    BEGIN
        MERGE INTO prod.dct_lookup_categories t
        USING (SELECT p_code AS category_code FROM dual) s
        ON (t.category_code = s.category_code)
        WHEN NOT MATCHED THEN
            INSERT (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
            VALUES (p_code, p_en, p_ar, NULL, 'Y', 'Y')
        WHEN MATCHED THEN
            UPDATE SET category_name_en = p_en, category_name_ar = p_ar;
        SELECT category_id INTO o_id FROM prod.dct_lookup_categories WHERE category_code = p_code;
    END;

    PROCEDURE upsert_value (p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_ord NUMBER, p_default VARCHAR2 DEFAULT 'N') IS
    BEGIN
        MERGE INTO prod.dct_lookup_values t
        USING (SELECT p_cat AS category_id, p_code AS value_code FROM dual) s
        ON (t.category_id = s.category_id AND t.value_code = s.value_code)
        WHEN NOT MATCHED THEN
            INSERT (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
            VALUES (p_cat, p_code, p_en, p_ar, p_ord, p_default, 'Y')
        WHEN MATCHED THEN
            UPDATE SET value_name_en = p_en, value_name_ar = p_ar, display_order = p_ord;
    END;
BEGIN
    -- Key-result direction (drives how attainment normalises to 0-100)
    upsert_category('TM_KR_DIRECTION', 'TM Key Result Direction', 'اتجاه النتيجة الرئيسية', v_cat);
    upsert_value(v_cat, 'INCREASE', 'Increase to',  'زيادة إلى',  10, 'Y');
    upsert_value(v_cat, 'DECREASE', 'Decrease to',  'خفض إلى',    20);
    upsert_value(v_cat, 'MAINTAIN', 'Maintain at',  'الحفاظ على', 30);

    -- Key-result unit (suggestions only -- NOT validated; the column is free text)
    upsert_category('TM_KR_UNIT', 'TM Key Result Unit', 'وحدة القياس', v_cat);
    upsert_value(v_cat, '%',      'Percent (%)',  'نسبة مئوية',  10);
    upsert_value(v_cat, '#',      'Count (#)',    'عدد',         20);
    upsert_value(v_cat, 'AED',    'Amount (AED)', 'مبلغ (درهم)', 30);
    upsert_value(v_cat, 'Days',   'Days',         'أيام',        40);
    upsert_value(v_cat, 'Hours',  'Hours',        'ساعات',       50);
    upsert_value(v_cat, 'Score',  'Score',        'درجة',        60);
    upsert_value(v_cat, 'Ratio',  'Ratio',        'نسبة',        70);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('TM_KR_DIRECTION + TM_KR_UNIT lookups seeded.');
END;
/

-- =============================================================================
-- 3. VERIFY
-- =============================================================================
SELECT COUNT(*) AS kr_table_cols FROM all_tab_columns WHERE owner='PROD' AND table_name='DCT_TM_KEY_RESULTS';
SELECT COUNT(*) AS obj_progress_mode FROM all_tab_columns WHERE owner='PROD' AND table_name='DCT_TM_OBJECTIVES' AND column_name='PROGRESS_MODE';
SELECT lc.category_code, COUNT(*) AS vals
FROM   prod.dct_lookup_categories lc
JOIN   prod.dct_lookup_values lv ON lv.category_id = lc.category_id
WHERE  lc.category_code IN ('TM_KR_DIRECTION','TM_KR_UNIT')
GROUP  BY lc.category_code
ORDER  BY lc.category_code;
