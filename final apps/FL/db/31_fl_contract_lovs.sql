-- =============================================================================
-- Freelancers Module (App 203) -- Contract LOVs + Budget Allocation
-- File    : 31_fl_contract_lovs.sql
-- Schema  : objects in PROD; ORDS module fl.rest + synonyms under ADMIN.
-- Run     : sql -name prod_mcp @31_fl_contract_lovs.sql
--           MUST run in a FRESH SQLcl session (it creates ADMIN synonyms; a
--           session that earlier did ALTER SESSION SET CURRENT_SCHEMA = PROD
--           makes them self-referencing -> ORA-01471).
--           Additive + re-runnable: only NEW templates/handlers are defined on
--           fl.rest, so the module is not rebuilt. Re-run after any
--           08_fl_ords.sql re-run.
-- Purpose : Contract-page review round (2026-07-14):
--   1. TITLE is optional and lookup-based -> new lookup category
--      FL_CONTRACT_TITLE (editable in Admin -> Lookups) + DCT_FL_CONTRACTS.TITLE
--      relaxed to NULL.
--   2. TERMS OF PAYMENT is lookup-based -> new category FL_PAYMENT_TERMS
--      (ARREARS / ADVANCE).
--   3. "Budget Coding" becomes "Budget Allocation", defaulting to PROJECT:
--      Project -> Task -> Expenditure Type are DEPENDENT LOVs sourced from the
--      project balances view DCT_BUDGET_UTILIZATION_V for the contract's budget
--      year, and a fund check tells the user whether the selected line still
--      carries enough budget for the contract's total amount.
--      The alternative GL level picks a real combination from DCT_GL_COA_V via
--      cascading segment LOVs (entity -> cost centre -> account -> combination).
-- New ORDS routes (all authenticated, GET):
--   lookup-values?cat=          category values (EN/AR)
--   budget/projects?year=&search=
--   budget/tasks?year=&project=
--   budget/etypes?year=&project=&task=
--   budget/check?year=&project=&task=&etype=&amount=
--   gl/segments?seg=entity|costcenter|account[&entity=&costcenter=]
--   gl/combinations?entity=&costcenter=&account=&search=
-- NOTE: 'q' is an ORDS-reserved query parameter -- these routes use 'search'.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- -----------------------------------------------------------------------------
-- 1. Synonyms for the two reporting views the LOVs read
-- -----------------------------------------------------------------------------
CREATE OR REPLACE SYNONYM dct_budget_utilization_v FOR prod.dct_budget_utilization_v;
CREATE OR REPLACE SYNONYM dct_gl_coa_v             FOR prod.dct_gl_coa_v;

-- -----------------------------------------------------------------------------
-- 2. TITLE becomes optional
-- -----------------------------------------------------------------------------
DECLARE
    e_already_null EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_already_null, -1451);   -- column already nullable
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_fl_contracts MODIFY (title NULL)';
    DBMS_OUTPUT.PUT_LINE('dct_fl_contracts.title -> NULL allowed');
EXCEPTION
    WHEN e_already_null THEN DBMS_OUTPUT.PUT_LINE('title already nullable');
END;
/

-- -----------------------------------------------------------------------------
-- 3. Lookup categories + values (Arabic via UNISTR -- keeps this file ASCII so
--    SQLcl cannot mangle it; see feedback_sqlcl_utf8_arabic)
-- -----------------------------------------------------------------------------
DECLARE
    v_mod  NUMBER;
    v_cat  NUMBER;

    PROCEDURE ensure_cat(p_code   VARCHAR2,
                         p_en     VARCHAR2,
                         p_ar     VARCHAR2,
                         p_mod    NUMBER,
                         p_cat_id OUT NUMBER) IS
    BEGIN
        SELECT category_id INTO p_cat_id
        FROM   prod.dct_lookup_categories
        WHERE  category_code = p_code;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO prod.dct_lookup_categories
                   (category_code, category_name_en, category_name_ar,
                    module_id, is_system, is_active, created_by)
            VALUES (p_code, p_en, p_ar, p_mod, 'N', 'Y', 'SYSTEM')
            RETURNING category_id INTO p_cat_id;
    END;

    PROCEDURE ensure_val(p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2,
                         p_ar VARCHAR2, p_ord NUMBER, p_def VARCHAR2 DEFAULT 'N') IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt FROM prod.dct_lookup_values
        WHERE  category_id = p_cat AND value_code = p_code;
        IF v_cnt = 0 THEN
            INSERT INTO prod.dct_lookup_values
                   (category_id, value_code, value_name_en, value_name_ar,
                    display_order, is_default, is_active, created_by)
            VALUES (p_cat, p_code, p_en, p_ar, p_ord, p_def, 'Y', 'SYSTEM');
        END IF;
    END;
BEGIN
    BEGIN
        SELECT module_id INTO v_mod FROM prod.dct_modules WHERE module_code = 'FL';
    EXCEPTION WHEN NO_DATA_FOUND THEN v_mod := NULL;
    END;

    -- Contract titles (starter set -- extend freely in Admin -> Lookups)
    ensure_cat('FL_CONTRACT_TITLE', 'Freelancer Contract Title',
               UNISTR('\0639\0646\0648\0627\0646 \0627\0644\0639\0642\062F'), v_mod, v_cat);
    ensure_val(v_cat, 'CONSULTANT',    'Consultant',
               UNISTR('\0645\0633\062A\0634\0627\0631'), 10);
    ensure_val(v_cat, 'ADVISOR',       'Advisor',
               UNISTR('\0645\0633\062A\0634\0627\0631 \0623\0648\0644'), 20);
    ensure_val(v_cat, 'TRAINER',       'Trainer',
               UNISTR('\0645\062F\0631\0628'), 30);
    ensure_val(v_cat, 'PHOTOGRAPHER',  'Photographer',
               UNISTR('\0645\0635\0648\0631 \0641\0648\062A\0648\063A\0631\0627\0641\064A'), 40);
    ensure_val(v_cat, 'VIDEOGRAPHER',  'Videographer',
               UNISTR('\0645\0635\0648\0631 \0641\064A\062F\064A\0648'), 50);
    ensure_val(v_cat, 'DESIGNER',      'Designer',
               UNISTR('\0645\0635\0645\0645'), 60);
    ensure_val(v_cat, 'SPEAKER',       'Speaker',
               UNISTR('\0645\062A\062D\062F\062B'), 70);
    ensure_val(v_cat, 'RESEARCHER',    'Researcher',
               UNISTR('\0628\0627\062D\062B'), 80);
    ensure_val(v_cat, 'TRANSLATOR',    'Translator',
               UNISTR('\0645\062A\0631\062C\0645'), 90);
    ensure_val(v_cat, 'CONTENT_WRITER','Content Writer',
               UNISTR('\0643\0627\062A\0628 \0645\062D\062A\0648\0649'), 100);
    ensure_val(v_cat, 'EVENT_SUPPORT', 'Event Support',
               UNISTR('\062F\0639\0645 \0627\0644\0641\0639\0627\0644\064A\0627\062A'), 110);
    ensure_val(v_cat, 'OTHER',         'Other',
               UNISTR('\0623\062E\0631\0649'), 999);

    -- Terms of payment
    ensure_cat('FL_PAYMENT_TERMS', 'Freelancer Terms of Payment',
               UNISTR('\0634\0631\0648\0637 \0627\0644\062F\0641\0639'), v_mod, v_cat);
    ensure_val(v_cat, 'ARREARS', 'In Arrears',
               UNISTR('\0628\0623\062B\0631 \0631\062C\0639\064A'), 10, 'Y');
    ensure_val(v_cat, 'ADVANCE', 'In Advance',
               UNISTR('\0645\0642\062F\0645\0627'), 20);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('lookup categories FL_CONTRACT_TITLE + FL_PAYMENT_TERMS ready');
END;
/

-- -----------------------------------------------------------------------------
-- 4. ORDS routes (additive on fl.rest)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE setup_fl_contract_lovs_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'fl.rest';

    PROCEDURE deft(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    EXCEPTION WHEN OTHERS THEN NULL;   -- template may already exist
    END;

    PROCEDURE defh(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method => p_method, p_source_type => ORDS.source_type_plsql,
            p_source => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    -- ---------- generic lookup category values ------------------------------
    deft('lookup-values');
    defh('lookup-values', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_cat  VARCHAR2(60)  := UPPER([COLON]cat);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_cat IS NULL THEN dct_rest.err(400,'cat (lookup category code) is required'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('category', l_cat);
  APEX_JSON.open_array('items');
  FOR r IN (SELECT lv.value_code, lv.value_name_en, lv.value_name_ar, lv.is_default
            FROM   dct_lookup_values     lv
            JOIN   dct_lookup_categories lc ON lc.category_id = lv.category_id
            WHERE  lc.category_code = l_cat AND lv.is_active = 'Y'
            ORDER BY lv.display_order, lv.value_name_en) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code',      r.value_code);
    APEX_JSON.write('name',      r.value_name_en);
    APEX_JSON.write('nameAr',    NVL(r.value_name_ar, r.value_name_en));
    APEX_JSON.write('isDefault', NVL(r.is_default, 'N'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- ---------- budget allocation: projects ---------------------------------
    deft('budget/projects');
    defh('budget/projects', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_srch VARCHAR2(200) := UPPER(TRIM([COLON]search));
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year (budget year) is required'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT project_number, MAX(project_name) AS project_name,
           SUM(budget) AS budget, SUM(fund_available) AS fund_available
    FROM   dct_budget_utilization_v
    WHERE  budget_year = l_year
    AND    (l_srch IS NULL
            OR UPPER(project_number) LIKE '%' || l_srch || '%'
            OR UPPER(project_name)   LIKE '%' || l_srch || '%')
    GROUP BY project_number
    ORDER BY project_number
    FETCH FIRST 300 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('projectNumber', r.project_number);
    APEX_JSON.write('projectName',   NVL(r.project_name, '-'));
    APEX_JSON.write('budget',        NVL(r.budget, 0));
    APEX_JSON.write('fundAvailable', NVL(r.fund_available, 0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- ---------- budget allocation: tasks of a project -----------------------
    deft('budget/tasks');
    defh('budget/tasks', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_proj VARCHAR2(60)  := TRIM([COLON]project);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_year IS NULL OR l_proj IS NULL THEN
    dct_rest.err(400,'year and project are required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT task_number, SUM(budget) AS budget, SUM(fund_available) AS fund_available
    FROM   dct_budget_utilization_v
    WHERE  budget_year = l_year AND project_number = l_proj
    AND    task_number IS NOT NULL
    GROUP BY task_number
    ORDER BY task_number
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('taskNumber',    r.task_number);
    APEX_JSON.write('budget',        NVL(r.budget, 0));
    APEX_JSON.write('fundAvailable', NVL(r.fund_available, 0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- ---------- budget allocation: expenditure types of a task --------------
    deft('budget/etypes');
    defh('budget/etypes', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_proj VARCHAR2(60)  := TRIM([COLON]project);
  l_task VARCHAR2(200) := TRIM([COLON]task);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_year IS NULL OR l_proj IS NULL THEN
    dct_rest.err(400,'year and project are required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT expenditure_type, SUM(budget) AS budget, SUM(fund_available) AS fund_available
    FROM   dct_budget_utilization_v
    WHERE  budget_year = l_year AND project_number = l_proj
    AND    (l_task IS NULL OR task_number = l_task)
    AND    expenditure_type IS NOT NULL
    GROUP BY expenditure_type
    ORDER BY expenditure_type
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('expenditureType', r.expenditure_type);
    APEX_JSON.write('budget',          NVL(r.budget, 0));
    APEX_JSON.write('fundAvailable',   NVL(r.fund_available, 0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- ---------- budget allocation: fund check -------------------------------
    -- Green flag when the selected budget line still carries at least the
    -- contract's total amount for the contract's budget year; otherwise red,
    -- with the shortfall the UI prints in its inline message.
    deft('budget/check');
    defh('budget/check', 'GET', q'[
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_year  NUMBER        := TO_NUMBER([COLON]year   DEFAULT NULL ON CONVERSION ERROR);
  l_proj  VARCHAR2(60)  := TRIM([COLON]project);
  l_task  VARCHAR2(200) := TRIM([COLON]task);
  l_etype VARCHAR2(300) := TRIM([COLON]etype);
  l_amt   NUMBER        := NVL(TO_NUMBER([COLON]amount DEFAULT NULL ON CONVERSION ERROR), 0);
  l_bud   NUMBER := 0;  l_ap  NUMBER := 0;  l_grn NUMBER := 0;
  l_pr    NUMBER := 0;  l_po  NUMBER := 0;  l_fund NUMBER := 0;
  l_rows  NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_year IS NULL OR l_proj IS NULL THEN
    dct_rest.err(400,'year and project are required'); RETURN;
  END IF;

  SELECT COUNT(*), NVL(SUM(budget),0), NVL(SUM(actual_ap),0), NVL(SUM(actual_grn),0),
         NVL(SUM(commitment_pr),0), NVL(SUM(obligation_po),0), NVL(SUM(fund_available),0)
  INTO   l_rows, l_bud, l_ap, l_grn, l_pr, l_po, l_fund
  FROM   dct_budget_utilization_v
  WHERE  budget_year = l_year
  AND    project_number = l_proj
  AND    (l_task  IS NULL OR task_number      = l_task)
  AND    (l_etype IS NULL OR expenditure_type = l_etype);

  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year',          l_year);
  APEX_JSON.write('projectNumber', l_proj);
  IF l_task  IS NOT NULL THEN APEX_JSON.write('taskNumber', l_task); END IF;
  IF l_etype IS NOT NULL THEN APEX_JSON.write('expenditureType', l_etype); END IF;
  APEX_JSON.write('found',         CASE WHEN l_rows > 0 THEN 'Y' ELSE 'N' END);
  APEX_JSON.write('budget',        l_bud);
  APEX_JSON.write('actual',        l_ap + l_grn);
  APEX_JSON.write('commitment',    l_pr);
  APEX_JSON.write('obligation',    l_po);
  APEX_JSON.write('fundAvailable', l_fund);
  APEX_JSON.write('required',      l_amt);
  APEX_JSON.write('sufficient',
    CASE WHEN l_rows > 0 AND l_fund >= l_amt AND l_fund > 0 THEN 'Y' ELSE 'N' END);
  APEX_JSON.write('shortfall',     GREATEST(l_amt - l_fund, 0));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- ---------- GL level: cascading segment LOVs ----------------------------
    deft('gl/segments');
    defh('gl/segments', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_seg  VARCHAR2(30)  := LOWER(TRIM([COLON]seg));
  l_ent  VARCHAR2(30)  := TRIM([COLON]entity);
  l_cc   VARCHAR2(30)  := TRIM([COLON]costcenter);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_seg NOT IN ('entity','costcenter','account') THEN
    dct_rest.err(400,'seg must be entity, costcenter or account'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('seg', l_seg);
  APEX_JSON.open_array('items');
  IF l_seg = 'entity' THEN
    FOR r IN (SELECT entity_code AS code, MAX(entity_desc) AS descr
              FROM dct_gl_coa_v WHERE entity_code IS NOT NULL
              GROUP BY entity_code ORDER BY entity_code) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('code', r.code); APEX_JSON.write('name', NVL(r.descr, r.code));
      APEX_JSON.close_object;
    END LOOP;
  ELSIF l_seg = 'costcenter' THEN
    FOR r IN (SELECT cost_center_code AS code, MAX(cost_center_desc) AS descr
              FROM dct_gl_coa_v
              WHERE cost_center_code IS NOT NULL
              AND   (l_ent IS NULL OR entity_code = l_ent)
              GROUP BY cost_center_code ORDER BY cost_center_code) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('code', r.code); APEX_JSON.write('name', NVL(r.descr, r.code));
      APEX_JSON.close_object;
    END LOOP;
  ELSE
    FOR r IN (SELECT account_code AS code, MAX(account_desc) AS descr
              FROM dct_gl_coa_v
              WHERE account_code IS NOT NULL
              AND   (l_ent IS NULL OR entity_code      = l_ent)
              AND   (l_cc  IS NULL OR cost_center_code = l_cc)
              GROUP BY account_code ORDER BY account_code) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('code', r.code); APEX_JSON.write('name', NVL(r.descr, r.code));
      APEX_JSON.close_object;
    END LOOP;
  END IF;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- ---------- GL level: the combinations behind the chosen segments -------
    deft('gl/combinations');
    defh('gl/combinations', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_ent  VARCHAR2(30)  := TRIM([COLON]entity);
  l_cc   VARCHAR2(30)  := TRIM([COLON]costcenter);
  l_acct VARCHAR2(30)  := TRIM([COLON]account);
  l_srch VARCHAR2(200) := UPPER(TRIM([COLON]search));
  l_cnt  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_cnt FROM dct_gl_coa_v
  WHERE (l_ent  IS NULL OR entity_code      = l_ent)
  AND   (l_cc   IS NULL OR cost_center_code = l_cc)
  AND   (l_acct IS NULL OR account_code     = l_acct)
  AND   (l_srch IS NULL OR UPPER(cc_string) LIKE '%' || l_srch || '%'
                        OR UPPER(account_desc) LIKE '%' || l_srch || '%');
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_cnt);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT cc_id, cc_string, entity_desc, cost_center_desc, account_desc, program_desc
    FROM   dct_gl_coa_v
    WHERE (l_ent  IS NULL OR entity_code      = l_ent)
    AND   (l_cc   IS NULL OR cost_center_code = l_cc)
    AND   (l_acct IS NULL OR account_code     = l_acct)
    AND   (l_srch IS NULL OR UPPER(cc_string) LIKE '%' || l_srch || '%'
                          OR UPPER(account_desc) LIKE '%' || l_srch || '%')
    ORDER BY cc_string
    FETCH FIRST 200 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('ccId',       r.cc_id);
    APEX_JSON.write('ccCode',     r.cc_string);
    APEX_JSON.write('entityDesc', NVL(r.entity_desc, ''));
    APEX_JSON.write('ccDesc',     NVL(r.cost_center_desc, ''));
    APEX_JSON.write('acctDesc',   NVL(r.account_desc, ''));
    APEX_JSON.write('programDesc',NVL(r.program_desc, ''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

END setup_fl_contract_lovs_tmp;
/

BEGIN
    setup_fl_contract_lovs_tmp;
    COMMIT;
END;
/

DROP PROCEDURE setup_fl_contract_lovs_tmp;

PROMPT === 31_fl_contract_lovs.sql complete ===
