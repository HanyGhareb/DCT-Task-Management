-- =============================================================================
-- General Ledger (App 210) -- Legacy EBS mapping + balances endpoints (ADDITIVE)
-- File    : 16_gl_ebs_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : python-oracledb runner or sql -name prod_mcp (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07 + 08 + 09 + 10 + 11 + 12 + 13 + 14 + 15 + THIS script.
-- Purpose : the Fusion/EBS segment cross-map (db/v2/110) management API and
--           the EBS historical balance load/coverage API feeding the GL app
--           "Legacy (EBS)" pages and the EBS_GL_BALANCE_REGISTER report.
-- Endpoints:
--   GET  /gl/coamap?segment=&search=&active=     list (cap 5000) + segments[]
--   POST /gl/coamap                              create mapping row
--   PUT  /gl/coamap/:id                          partial update / deactivate
--   POST /gl/ebs-balances                        bulk upsert <=500 rows/req
--        (2026-07-30 (2): rows accept the FULL EBS "GL Period Balances"
--         export layout -- optional ccId / accountType / *Desc per segment;
--         ptd optional (blank = 0); adjustment period '13-YYYY' accepted,
--         dated 31-Dec of its year)
--   GET  /gl/ebs-balances/summary                per-year coverage + unmapped
--   POST /gl/ebs-balances/register               enqueue EBS_GL_BALANCE_REGISTER
--   GET  /gl/ebs-balances/register/:id[/file]    poll status / download XLSX
-- Gates   : reads  GL_VIEW_EBS_MAPPING   (NULL legacy role = any valid session)
--           writes GL_MANAGE_EBS_MAPPING (legacy role SYS_ADMIN)
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_ebs_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;

    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

BEGIN

    def_template('coamap');
    def_handler('coamap', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_seg    VARCHAR2(30)  := UPPER([COLON]segment);
  l_search VARCHAR2(200) := [COLON]search;
  l_active VARCHAR2(10)  := UPPER([COLON]active);
  l_n      NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_EBS_MAPPING', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_EBS_MAPPING required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('segments');
  FOR s IN (SELECT lv.value_code, lv.value_name_en, lv.value_name_ar
              FROM prod.dct_lookup_values lv
              JOIN prod.dct_lookup_categories lc ON lc.category_id = lv.category_id
             WHERE lc.category_code = 'GL_XMAP_SEGMENT' AND lv.is_active = 'Y'
             ORDER BY lv.display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code',   s.value_code);
    APEX_JSON.write('name',   s.value_name_en);
    APEX_JSON.write('nameAr', s.value_name_ar, p_write_null => TRUE);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT map_id, segment_type, ebs_value, fusion_value, parent_child,
           description, is_active, fusion_desc, in_chart,
           updated_by, created_by,
           TO_CHAR(dct_to_local(NVL(updated_at, created_at)),'YYYY-MM-DD HH[COLON]MI AM') AS upd_at
      FROM prod.dct_gl_ebs_map_v
     WHERE (l_seg IS NULL OR segment_type = l_seg)
       AND (l_active IS NULL OR l_active = 'ALL' OR is_active = l_active)
       AND (l_search IS NULL
            OR ebs_value LIKE '%'||l_search||'%'
            OR fusion_value LIKE '%'||l_search||'%'
            OR UPPER(NVL(description,' ')) LIKE '%'||UPPER(l_search)||'%'
            OR UPPER(NVL(fusion_desc,' ')) LIKE '%'||UPPER(l_search)||'%')
     ORDER BY segment_type, ebs_value
     FETCH FIRST 5000 ROWS ONLY) LOOP
    l_n := l_n + 1;
    APEX_JSON.open_object;
    APEX_JSON.write('id',          r.map_id);
    APEX_JSON.write('segment',     r.segment_type);
    APEX_JSON.write('ebsValue',    r.ebs_value);
    APEX_JSON.write('fusionValue', r.fusion_value);
    APEX_JSON.write('fusionDesc',  NVL(r.fusion_desc, NVL(r.description,'')));
    APEX_JSON.write('description', NVL(r.description,''));
    APEX_JSON.write('parentChild', NVL(r.parent_child,'CHILD'));
    APEX_JSON.write('inChart',     r.in_chart);
    APEX_JSON.write('active',      r.is_active);
    APEX_JSON.write('updatedBy',   NVL(r.updated_by, r.created_by));
    APEX_JSON.write('updatedAt',   NVL(r.upd_at,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('coamap', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_seg  VARCHAR2(30); l_ebs VARCHAR2(30); l_fus VARCHAR2(30);
  l_pc   VARCHAR2(10); l_desc VARCHAR2(400); l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_EBS_MAPPING', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_EBS_MAPPING required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_seg  := UPPER(APEX_JSON.get_varchar2(p_path=>'segment'));
  l_ebs  := TRIM(APEX_JSON.get_varchar2(p_path=>'ebsValue'));
  l_fus  := TRIM(APEX_JSON.get_varchar2(p_path=>'fusionValue'));
  l_pc   := NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'parentChild')),'CHILD');
  l_desc := SUBSTR(APEX_JSON.get_varchar2(p_path=>'description'),1,400);
  IF l_seg IS NULL OR l_ebs IS NULL OR l_fus IS NULL THEN
    dct_rest.err(400,'segment, ebsValue and fusionValue are required'); RETURN;
  END IF;
  prod.dct_lookup_pkg.validate_lookup('GL_XMAP_SEGMENT', l_seg);
  INSERT INTO prod.dct_gl_ebs_map
        (segment_type, ebs_value, fusion_value, parent_child, description, created_by)
  VALUES (l_seg, l_ebs, l_fus, l_pc, l_desc, l_user)
  RETURNING map_id INTO l_id;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('id', l_id);
  APEX_JSON.write('status', 'CREATED');
  APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK; dct_rest.err(400,'A mapping for this segment and EBS value already exists');
  WHEN OTHERS THEN
    ROLLBACK;
    IF SQLCODE = -20090 THEN dct_rest.err(400, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_template('coamap/[COLON]id');
    def_handler('coamap/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_n    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_EBS_MAPPING', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_EBS_MAPPING required'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_n FROM prod.dct_gl_ebs_map WHERE map_id = l_id;
  IF l_n = 0 THEN dct_rest.err(404,'Mapping row not found'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  -- partial PUT: only keys present in the body are applied
  IF APEX_JSON.does_exist(p_path=>'fusionValue') THEN
    UPDATE prod.dct_gl_ebs_map
       SET fusion_value = TRIM(APEX_JSON.get_varchar2(p_path=>'fusionValue'))
     WHERE map_id = l_id;
  END IF;
  IF APEX_JSON.does_exist(p_path=>'parentChild') THEN
    UPDATE prod.dct_gl_ebs_map
       SET parent_child = NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'parentChild')),'CHILD')
     WHERE map_id = l_id;
  END IF;
  IF APEX_JSON.does_exist(p_path=>'description') THEN
    UPDATE prod.dct_gl_ebs_map
       SET description = SUBSTR(APEX_JSON.get_varchar2(p_path=>'description'),1,400)
     WHERE map_id = l_id;
  END IF;
  IF APEX_JSON.does_exist(p_path=>'active') THEN
    UPDATE prod.dct_gl_ebs_map
       SET is_active = CASE WHEN UPPER(APEX_JSON.get_varchar2(p_path=>'active')) = 'N' THEN 'N' ELSE 'Y' END
     WHERE map_id = l_id;
  END IF;
  UPDATE prod.dct_gl_ebs_map
     SET updated_by = l_user, updated_at = SYSTIMESTAMP
   WHERE map_id = l_id;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('id', l_id);
  APEX_JSON.write('status', 'UPDATED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('ebs-balances');
    def_handler('ebs-balances', 'POST', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_cnt   NUMBER;
  l_src   VARCHAR2(200);
  l_ent   VARCHAR2(30); l_cc VARCHAR2(30); l_bud VARCHAR2(30); l_acc VARCHAR2(30);
  l_act   VARCHAR2(30); l_f1 VARCHAR2(30); l_f2 VARCHAR2(30);
  l_per   VARCHAR2(20); l_ptd NUMBER; l_bgt NUMBER; l_enc NUMBER; l_pd DATE;
  l_bgty  NUMBER; l_ency NUMBER; l_acty NUMBER;
  l_ccid  NUMBER;       l_atype VARCHAR2(60);
  l_entd  VARCHAR2(240); l_ccd VARCHAR2(240); l_budd VARCHAR2(240);
  l_accd  VARCHAR2(240); l_actd VARCHAR2(240);
  l_f1d   VARCHAR2(240); l_f2d VARCHAR2(240);
  l_ok    NUMBER := 0; l_err NUMBER := 0;
  -- Canonical segment widths (user rule 2026-07-30): Entity 3, Cost centre 7,
  -- Budget group 1, Account 6, Activity 6, Future1 6, Future2 6. EBS exports
  -- drop leading zeros -- numeric values are zero-padded to exact width.
  FUNCTION eseg(p VARCHAR2, w NUMBER) RETURN VARCHAR2 IS
  BEGIN
    IF p IS NULL THEN RETURN NULL; END IF;
    IF REGEXP_LIKE(TRIM(p), '^[0-9]+$') THEN RETURN LPAD(TRIM(p), w, '0'); END IF;
    RETURN TRIM(p);
  END;
  -- FX = exact-format parse. WITHOUT it Oracle leniently reads 'JAN-25'
  -- under 'MM-YYYY' as year 0025 (found in smoke) -- never drop the FX.
  -- EBS adjustment period '13-YYYY' is valid: dated 31-Dec of its year so
  -- it always lands inside December / full-year YTD windows.
  FUNCTION parse_period(p VARCHAR2) RETURN DATE IS
    d DATE;
    FUNCTION ok(x DATE) RETURN BOOLEAN IS
    BEGIN RETURN x IS NOT NULL AND EXTRACT(YEAR FROM x) BETWEEN 1990 AND 2100; END;
  BEGIN
    IF REGEXP_LIKE(p, '^13-[0-9]{4}$') THEN
      RETURN TO_DATE('31-12-' || SUBSTR(p, 4) DEFAULT NULL ON CONVERSION ERROR, 'FXDD-MM-YYYY');
    END IF;
    d := TO_DATE(p DEFAULT NULL ON CONVERSION ERROR, 'FXMM-YYYY');
    IF NOT ok(d) THEN d := TO_DATE(p DEFAULT NULL ON CONVERSION ERROR, 'FXMON-YYYY', q'#NLS_DATE_LANGUAGE=ENGLISH#'); END IF;
    IF NOT ok(d) THEN d := TO_DATE(p DEFAULT NULL ON CONVERSION ERROR, 'FXMON-YY',   q'#NLS_DATE_LANGUAGE=ENGLISH#'); END IF;
    IF NOT ok(d) THEN d := TO_DATE(p DEFAULT NULL ON CONVERSION ERROR, 'FXYYYY-MM'); END IF;
    IF NOT ok(d) THEN RETURN NULL; END IF;
    RETURN d;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_EBS_MAPPING', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_EBS_MAPPING required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_cnt := NVL(APEX_JSON.get_count(p_path=>'rows'), 0);
  IF l_cnt = 0 THEN dct_rest.err(400,'rows[] is required'); RETURN; END IF;
  IF l_cnt > 500 THEN dct_rest.err(400,'maximum 500 rows per request'); RETURN; END IF;
  l_src := SUBSTR(APEX_JSON.get_varchar2(p_path=>'sourceFile'),1,200);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('results');
  FOR i IN 1 .. l_cnt LOOP
    BEGIN
      l_ent := TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].entity',     p0=>i));
      l_cc  := TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].costCenter', p0=>i));
      l_bud := TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].budgetCode', p0=>i));
      l_acc := TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].account',    p0=>i));
      l_act := TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].activity',   p0=>i));
      l_f1  := TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].future1',    p0=>i));
      l_f2  := TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].future2',    p0=>i));
      l_per := TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].period',     p0=>i));
      l_ptd := NVL(APEX_JSON.get_number(p_path=>'rows[%d].ptd',         p0=>i), 0);
      l_bgt := NVL(APEX_JSON.get_number(p_path=>'rows[%d].budget',      p0=>i), 0);
      l_enc := NVL(APEX_JSON.get_number(p_path=>'rows[%d].encumbrance', p0=>i), 0);
      l_bgty := NVL(APEX_JSON.get_number(p_path=>'rows[%d].budgetYtd',      p0=>i), 0);
      l_ency := NVL(APEX_JSON.get_number(p_path=>'rows[%d].encumbranceYtd', p0=>i), 0);
      l_acty := NVL(APEX_JSON.get_number(p_path=>'rows[%d].actualYtd',      p0=>i), 0);
      l_ccid  := APEX_JSON.get_number(p_path=>'rows[%d].ccId', p0=>i);
      l_atype := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].accountType',    p0=>i)),1,60);
      l_entd  := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].entityDesc',     p0=>i)),1,240);
      l_ccd   := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].costCenterDesc', p0=>i)),1,240);
      l_budd  := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].budgetDesc',     p0=>i)),1,240);
      l_accd  := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].accountDesc',    p0=>i)),1,240);
      l_actd  := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].activityDesc',   p0=>i)),1,240);
      l_f1d   := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].future1Desc',    p0=>i)),1,240);
      l_f2d   := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].future2Desc',    p0=>i)),1,240);
      IF l_ent IS NULL OR l_cc IS NULL OR l_acc IS NULL OR l_per IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001,'entity, costCenter, account and period are required');
      END IF;
      l_ent := eseg(l_ent, 3);
      l_cc  := eseg(l_cc,  7);
      l_bud := eseg(NVL(l_bud, '0'), 1);
      l_acc := eseg(l_acc, 6);
      l_act := eseg(NVL(l_act, '0'), 6);
      l_f1  := eseg(NVL(l_f1,  '0'), 6);
      l_f2  := eseg(NVL(l_f2,  '0'), 6);
      l_pd := parse_period(l_per);
      UPDATE prod.dct_ebs_gl_balance t
         SET t.ptd_amount = l_ptd, t.budget_amount = l_bgt, t.encumbrance_amount = l_enc,
             t.budget_ytd = l_bgty, t.encumbrance_ytd = l_ency, t.actual_ytd = l_acty,
             t.period_date = l_pd,
             t.period_year = NVL(EXTRACT(YEAR FROM l_pd), TO_NUMBER(REGEXP_SUBSTR(l_per,'[0-9]{4}'))),
             t.cc_id = NVL(l_ccid, t.cc_id),
             t.entity_desc      = NVL(l_entd, t.entity_desc),
             t.cost_center_desc = NVL(l_ccd,  t.cost_center_desc),
             t.budget_desc      = NVL(l_budd, t.budget_desc),
             t.account_desc     = NVL(l_accd, t.account_desc),
             t.activity_desc    = NVL(l_actd, t.activity_desc),
             t.future1_desc     = NVL(l_f1d,  t.future1_desc),
             t.future2_desc     = NVL(l_f2d,  t.future2_desc),
             t.account_type     = NVL(l_atype, t.account_type),
             t.source_file = NVL(l_src, t.source_file),
             t.loaded_by = l_user, t.loaded_at = SYSTIMESTAMP
       WHERE t.entity_code = l_ent AND t.cost_center_code = l_cc
         AND t.budget_code = l_bud AND t.account_code = l_acc
         AND t.activity_code = l_act
         AND t.future1_code = l_f1 AND t.future2_code = l_f2
         AND t.accounting_period = l_per;
      IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO prod.dct_ebs_gl_balance
             (entity_code, cost_center_code, budget_code, account_code, activity_code,
              future1_code, future2_code, accounting_period, period_date, period_year,
              ptd_amount, budget_amount, encumbrance_amount,
              budget_ytd, encumbrance_ytd, actual_ytd,
              cc_id, entity_desc, cost_center_desc, budget_desc, account_desc,
              activity_desc, future1_desc, future2_desc, account_type,
              source_file, loaded_by)
        VALUES (l_ent, l_cc, l_bud, l_acc, l_act,
                l_f1, l_f2, l_per, l_pd,
                NVL(EXTRACT(YEAR FROM l_pd), TO_NUMBER(REGEXP_SUBSTR(l_per,'[0-9]{4}'))),
                l_ptd, l_bgt, l_enc,
                l_bgty, l_ency, l_acty,
                l_ccid, l_entd, l_ccd, l_budd, l_accd, l_actd, l_f1d, l_f2d, l_atype,
                l_src, l_user);
      END IF;
      l_ok := l_ok + 1;
      APEX_JSON.open_object;
      APEX_JSON.write('row', i);
      APEX_JSON.write('status', 'OK');
      APEX_JSON.close_object;
    EXCEPTION WHEN OTHERS THEN
      l_err := l_err + 1;
      APEX_JSON.open_object;
      APEX_JSON.write('row', i);
      APEX_JSON.write('status', 'ERROR');
      APEX_JSON.write('error', SUBSTR(SQLERRM,1,300));
      APEX_JSON.close_object;
    END;
  END LOOP;
  COMMIT;
  APEX_JSON.close_array;
  APEX_JSON.write('ok', l_ok);
  APEX_JSON.write('errors', l_err);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('ebs-balances/summary');
    def_handler('ebs-balances/summary', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  -- PLATFORM RULE 2026-08-02: Budget Group defaults to '1' (Current
  -- operations); bg= pipe list may add 2/8.
  l_bg   VARCHAR2(30)  := NVL(SUBSTR(TRIM([COLON]bg),1,30), '1');
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_EBS_MAPPING', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_EBS_MAPPING required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('years');
  FOR r IN (
    SELECT period_year,
           COUNT(*) AS n_rows,
           COUNT(DISTINCT ebs_combination) AS n_combos,
           COUNT(DISTINCT accounting_period) AS n_periods,
           SUM(ptd_amount) AS ptd_total,
           SUM(budget_amount) AS bgt_total,
           SUM(encumbrance_amount) AS enc_total,
           SUM(CASE WHEN SUBSTR(accounting_period,1,2) = '13' THEN actual_ytd END) AS ytd_at_13,
           SUM(CASE WHEN SUBSTR(accounting_period,1,2) = '12' THEN actual_ytd END) AS ytd_at_12,
           SUM(CASE WHEN account_mapped = 'Y' THEN 1 ELSE 0 END) AS acc_mapped,
           SUM(CASE WHEN appr_mapped = 'Y' THEN 1 ELSE 0 END) AS apr_mapped
      FROM prod.dct_ebs_balance_mapped_v
     WHERE INSTR('|' || l_bg || '|', '|' || budget_code || '|') > 0
     GROUP BY period_year ORDER BY period_year DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('year',          r.period_year);
    APEX_JSON.write('rows',          r.n_rows);
    APEX_JSON.write('combinations',  r.n_combos);
    APEX_JSON.write('periods',       r.n_periods);
    APEX_JSON.write('ptdTotal',      NVL(r.ptd_total,0));
    APEX_JSON.write('budgetTotal',   NVL(r.bgt_total,0));
    APEX_JSON.write('encTotal',      NVL(r.enc_total,0));
    APEX_JSON.write('actualYtdFy',   NVL(NVL(r.ytd_at_13, r.ytd_at_12),0));
    APEX_JSON.write('accountMapped', r.acc_mapped);
    APEX_JSON.write('apprMapped',    r.apr_mapped);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('unmappedAccounts');
  FOR r IN (
    SELECT account_code, COUNT(*) AS n, SUM(ABS(ptd_amount)) AS amt
      FROM prod.dct_ebs_balance_mapped_v
     WHERE account_mapped = 'N'
       AND INSTR('|' || l_bg || '|', '|' || budget_code || '|') > 0
     GROUP BY account_code ORDER BY SUM(ABS(ptd_amount)) DESC
     FETCH FIRST 10 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('ebsAccount', r.account_code);
    APEX_JSON.write('rows',       r.n);
    APEX_JSON.write('absAmount',  NVL(r.amt,0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('unmappedFuture2');
  FOR r IN (
    SELECT future2_code, COUNT(*) AS n, SUM(ABS(ptd_amount)) AS amt
      FROM prod.dct_ebs_balance_mapped_v
     WHERE appr_mapped = 'N'
       AND INSTR('|' || l_bg || '|', '|' || budget_code || '|') > 0
     GROUP BY future2_code ORDER BY SUM(ABS(ptd_amount)) DESC
     FETCH FIRST 10 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('ebsFuture2', r.future2_code);
    APEX_JSON.write('rows',       r.n);
    APEX_JSON.write('absAmount',  NVL(r.amt,0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('ebs-balances/register');
    def_handler('ebs-balances/register', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_year   NUMBER;
  l_params CLOB;
  l_run    NUMBER;
  PROCEDURE put(p_key VARCHAR2) IS
    l_val VARCHAR2(2000) := APEX_JSON.get_varchar2(p_path => p_key);
  BEGIN
    IF l_val IS NOT NULL THEN APEX_JSON.write(p_key, l_val); END IF;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_EBS_MAPPING', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_EBS_MAPPING required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_year := APEX_JSON.get_number(p_path=>'year');
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  APEX_JSON.initialize_clob_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.write('bg', NVL(APEX_JSON.get_varchar2(p_path=>'bg'), '1'));
  put('period'); put('account'); put('chapter'); put('search');
  APEX_JSON.close_object;
  l_params := APEX_JSON.get_clob_output;
  APEX_JSON.free_output;
  l_run := dct_rpt_pkg.enqueue(p_report_code  => 'EBS_GL_BALANCE_REGISTER',
                               p_params       => l_params,
                               p_trigger      => 'ONDEMAND',
                               p_requested_by => l_user,
                               p_formats      => 'XLSX');
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('runId', l_run);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_template('ebs-balances/register/[COLON]id');
    def_handler('ebs-balances/register/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_xls  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_EBS_MAPPING', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_EBS_MAPPING required'); RETURN;
  END IF;
  FOR c IN (SELECT run_id, status, row_count, error_msg, started_at, finished_at
              FROM dct_rpt_run
             WHERE run_id = [COLON]id AND report_code = 'EBS_GL_BALANCE_REGISTER') LOOP
    SELECT COUNT(*) INTO l_xls
      FROM dct_rpt_output WHERE run_id = c.run_id AND format = 'XLSX';
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('runId', c.run_id);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('rowCount', c.row_count);
    APEX_JSON.write('error', NVL(DBMS_LOB.SUBSTR(c.error_msg, 500, 1), ''));
    APEX_JSON.write('startedAt', NVL(TO_CHAR(dct_to_local(c.started_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('finishedAt', NVL(TO_CHAR(dct_to_local(c.finished_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('hasFile', l_xls > 0);
    APEX_JSON.close_object;
    RETURN;
  END LOOP;
  dct_rest.err(404,'Run not found');
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('ebs-balances/register/[COLON]id/file');
    def_handler('ebs-balances/register/[COLON]id/file', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_blob BLOB; l_name VARCHAR2(260); l_mime VARCHAR2(200);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_EBS_MAPPING', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_EBS_MAPPING required'); RETURN;
  END IF;
  BEGIN
    SELECT o.file_blob, o.file_name, o.mime_type INTO l_blob, l_name, l_mime FROM (
      SELECT o.file_blob, o.file_name, o.mime_type
        FROM dct_rpt_output o
        JOIN dct_rpt_run r ON r.run_id = o.run_id
       WHERE o.run_id = [COLON]id AND o.format = 'XLSX'
         AND r.report_code = 'EBS_GL_BALANCE_REGISTER'
       ORDER BY o.output_id DESC) o WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'File not found'); RETURN; END;
  OWA_UTIL.mime_header(NVL(l_mime,'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'), FALSE);
  HTP.p('Content-Disposition[COLON] attachment; filename="'||NVL(l_name,'ebs_gl_balance_register.xlsx')||'"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_gl_ebs_ords_tmp;
/

SHOW ERRORS

EXECUTE setup_gl_ebs_ords_tmp
DROP PROCEDURE setup_gl_ebs_ords_tmp;

PROMPT gl.rest Legacy EBS endpoints published (/gl/coamap + /gl/ebs-balances*).
