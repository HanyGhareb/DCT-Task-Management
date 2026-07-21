-- =============================================================================
-- General Ledger (App 210) -- ORDS REST API (gl.rest)
-- File    : 05_gl_ords.sql
-- Schema  : registered under ADMIN (the only REST-routable schema on ADB)
-- Base URL: /ords/admin/gl/
-- Run     : sql -name prod_mcp @05_gl_ords.sql   (FRESH session -- synonym rule:
--           do NOT run after ALTER SESSION SET CURRENT_SCHEMA=PROD or the ADMIN
--           synonyms self-reference, ORA-01471)
-- Notes   : Thin handlers over DCT_GL_CLASS_PKG + dct_gl_* tables/views.
--           validate_session on every route. Pagination {items,total,limit,offset}.
--           Error map: -20401->401 -20403->403 -20404->404 -20001/-20090->400 else 500.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

-- =============================================================================
-- 1. ADMIN synonyms for every PROD object the handlers touch
--    (dct_rest, dct_auth, dct_users already have ADMIN synonyms from earlier phases)
-- =============================================================================
CREATE OR REPLACE SYNONYM dct_gl_class_pkg     FOR prod.dct_gl_class_pkg;
CREATE OR REPLACE SYNONYM dct_gl_class_type    FOR prod.dct_gl_class_type;
CREATE OR REPLACE SYNONYM dct_gl_class_value   FOR prod.dct_gl_class_value;
CREATE OR REPLACE SYNONYM dct_gl_seg_class_map FOR prod.dct_gl_seg_class_map;
CREATE OR REPLACE SYNONYM dct_gl_coa_v         FOR prod.dct_gl_coa_v;
CREATE OR REPLACE SYNONYM dct_gl_balances_v    FOR prod.dct_gl_balances_v;
CREATE OR REPLACE SYNONYM gl_src_combinations  FOR prod.gl_src_combinations;
CREATE OR REPLACE SYNONYM gl_src_cost_centers  FOR prod.gl_src_cost_centers;
CREATE OR REPLACE SYNONYM gl_src_appropriation FOR prod.gl_src_appropriation;
CREATE OR REPLACE SYNONYM gl_src_program       FOR prod.gl_src_program;
-- Actuals reporting layer (db/v2/32-35): budget-vs-actual + drill-down + refresh
CREATE OR REPLACE SYNONYM dct_budget_actual_period_v FOR prod.dct_budget_actual_period_v;
CREATE OR REPLACE SYNONYM dct_gl_coa_snap            FOR prod.dct_gl_coa_snap;
CREATE OR REPLACE SYNONYM dct_actuals_refresh        FOR prod.dct_actuals_refresh;
CREATE OR REPLACE SYNONYM gl_balances                FOR prod.gl_balances;
CREATE OR REPLACE SYNONYM po_distributions           FOR prod.po_distributions;
CREATE OR REPLACE SYNONYM po_headers                 FOR prod.po_headers;
CREATE OR REPLACE SYNONYM po_lines                   FOR prod.po_lines;
CREATE OR REPLACE SYNONYM grn_all_v2                 FOR prod.grn_all_v2;
CREATE OR REPLACE SYNONYM ap_invoice_distributions   FOR prod.ap_invoice_distributions;

-- =============================================================================
-- 2. Module + handlers (wrapped in a procedure so SQLcl skips bind scanning)
-- =============================================================================
CREATE OR REPLACE PROCEDURE setup_gl_ords_tmp AS

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

    BEGIN
        ORDS.DELETE_MODULE(p_module_name => c_mod);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    ORDS.DEFINE_MODULE(
        p_module_name    => c_mod,
        p_base_path      => '/gl/',
        p_items_per_page => 100,
        p_status         => 'PUBLISHED',
        p_comments       => 'i-Finance -- General Ledger REST API (App 210)');

    -- =========================================================================
    -- BOOT -- dimensions catalog + coverage counts for the UI
    -- =========================================================================
    def_template('boot');
    def_handler('boot', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_combos NUMBER;
  l_classified NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT COUNT(*) INTO l_combos FROM gl_src_combinations;
  SELECT COUNT(*) INTO l_classified FROM dct_gl_coa_v WHERE sector_code IS NOT NULL;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('userId', l_uid);
  APEX_JSON.write('displayName', l_user);
  APEX_JSON.open_array('dimensions');
  FOR r IN (SELECT t.class_type_code, t.name_en, t.name_ar, t.segment_key, t.seg_pad_width,
                   t.is_hierarchical,
                   (SELECT COUNT(*) FROM dct_gl_class_value v WHERE v.class_type_code=t.class_type_code AND v.is_active='Y') val_count,
                   (SELECT COUNT(DISTINCT m.segment_value) FROM dct_gl_seg_class_map m WHERE m.class_type_code=t.class_type_code) seg_count
            FROM dct_gl_class_type t WHERE t.is_active='Y' ORDER BY t.display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.class_type_code);
    APEX_JSON.write('nameEn', r.name_en);
    APEX_JSON.write('nameAr', NVL(r.name_ar,''));
    APEX_JSON.write('segmentKey', r.segment_key);
    APEX_JSON.write('padWidth', r.seg_pad_width);
    APEX_JSON.write('isHierarchical', r.is_hierarchical);
    APEX_JSON.write('valueCount', r.val_count);
    APEX_JSON.write('mappedSegments', r.seg_count);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('combinationCount', l_combos);
  APEX_JSON.write('classifiedCount', l_classified);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- CLASS TYPES (dimensions)
    -- =========================================================================
    def_template('class-types');
    def_handler('class-types', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_gl_class_type ORDER BY display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.class_type_code); APEX_JSON.write('nameEn', r.name_en);
    APEX_JSON.write('nameAr', NVL(r.name_ar,'')); APEX_JSON.write('segmentKey', r.segment_key);
    APEX_JSON.write('padWidth', r.seg_pad_width); APEX_JSON.write('isHierarchical', r.is_hierarchical);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- CLASS VALUES (Sector / Chapter / DCT Program master values)
    -- =========================================================================
    def_template('class-values');
    def_handler('class-values', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_type VARCHAR2(30)  := UPPER([COLON]type);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (
    SELECT v.class_value_id, v.class_type_code, v.value_code, v.name_en, v.name_ar,
           v.alt_name1, v.alt_name2, v.alt_name3, v.parent_value_id, v.tag,
           v.display_order, v.is_active, p.name_en parent_name,
           (SELECT COUNT(*) FROM dct_gl_seg_class_map m WHERE m.class_value_id=v.class_value_id) map_count
    FROM dct_gl_class_value v
    LEFT JOIN dct_gl_class_value p ON p.class_value_id = v.parent_value_id
    WHERE (l_type IS NULL OR v.class_type_code = l_type)
    ORDER BY v.class_type_code, v.display_order, v.name_en
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('classValueId', r.class_value_id);
    APEX_JSON.write('type', r.class_type_code);
    APEX_JSON.write('valueCode', r.value_code);
    APEX_JSON.write('nameEn', r.name_en);
    APEX_JSON.write('nameAr', NVL(r.name_ar,''));
    APEX_JSON.write('altName1', NVL(r.alt_name1,''));
    APEX_JSON.write('altName2', NVL(r.alt_name2,''));
    APEX_JSON.write('altName3', NVL(r.alt_name3,''));
    APEX_JSON.write('parentValueId', r.parent_value_id);
    APEX_JSON.write('parentName', NVL(r.parent_name,''));
    APEX_JSON.write('tag', NVL(r.tag,''));
    APEX_JSON.write('displayOrder', r.display_order);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.write('mapCount', r.map_count);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('class-values', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  INSERT INTO dct_gl_class_value (class_type_code, value_code, name_en, name_ar,
              alt_name1, alt_name2, alt_name3, parent_value_id, tag, display_order, is_active, created_by)
  VALUES (UPPER(APEX_JSON.get_varchar2(p_path=>'type')),
          APEX_JSON.get_varchar2(p_path=>'valueCode'),
          APEX_JSON.get_varchar2(p_path=>'nameEn'),
          APEX_JSON.get_varchar2(p_path=>'nameAr'),
          APEX_JSON.get_varchar2(p_path=>'altName1'),
          APEX_JSON.get_varchar2(p_path=>'altName2'),
          APEX_JSON.get_varchar2(p_path=>'altName3'),
          APEX_JSON.get_number(p_path=>'parentValueId'),
          APEX_JSON.get_varchar2(p_path=>'tag'),
          NVL(APEX_JSON.get_number(p_path=>'displayOrder'),0),
          NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'), l_user)
  RETURNING class_value_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('classValueId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN DUP_VAL_ON_INDEX THEN dct_rest.err(409,'Value code already exists for this dimension.');
WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('class-values/[COLON]id');
    def_handler('class-values/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  UPDATE dct_gl_class_value SET
     name_en        = NVL(APEX_JSON.get_varchar2(p_path=>'nameEn'), name_en),
     name_ar        = APEX_JSON.get_varchar2(p_path=>'nameAr'),
     alt_name1      = APEX_JSON.get_varchar2(p_path=>'altName1'),
     alt_name2      = APEX_JSON.get_varchar2(p_path=>'altName2'),
     alt_name3      = APEX_JSON.get_varchar2(p_path=>'altName3'),
     parent_value_id= APEX_JSON.get_number(p_path=>'parentValueId'),
     tag            = APEX_JSON.get_varchar2(p_path=>'tag'),
     display_order  = NVL(APEX_JSON.get_number(p_path=>'displayOrder'), display_order),
     is_active      = NVL(APEX_JSON.get_varchar2(p_path=>'isActive'), is_active),
     updated_by     = l_user, updated_at = SYSTIMESTAMP
   WHERE class_value_id = [COLON]id;
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Value not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok', 1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('class-values/[COLON]id', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO n FROM dct_gl_seg_class_map WHERE class_value_id = [COLON]id;
  IF n > 0 THEN dct_rest.err(400,'Cannot delete: '||n||' assignment(s) use this value. Deactivate it instead.'); RETURN; END IF;
  DELETE FROM dct_gl_class_value WHERE class_value_id = [COLON]id;
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Value not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok', 1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- SEGMENT VALUES picker -- distinct codes used in combinations + description
    --   /gl/segments/:key/values?search=&limit=   key in COST_CENTER|APPROPRIATION|PROGRAM_CODE
    -- =========================================================================
    def_template('segments/[COLON]key/values');
    def_handler('segments/[COLON]key/values', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_key    VARCHAR2(30)  := UPPER([COLON]key);
  l_search VARCHAR2(200) := [COLON]search;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 500);
  l_type   VARCHAR2(30);
  l_width  NUMBER;

  PROCEDURE emit(p_code VARCHAR2, p_desc VARCHAR2) IS
    l_val VARCHAR2(60) := dct_gl_class_pkg.norm(p_code, l_width);
    l_cur NUMBER;
  BEGIN
    SELECT class_value_id INTO l_cur FROM (
      SELECT class_value_id FROM dct_gl_seg_class_map
       WHERE class_type_code=l_type AND segment_value=l_val
         AND TRUNC(SYSDATE) BETWEEN start_date AND NVL(end_date, DATE '4000-01-01')
       ORDER BY start_date DESC) WHERE ROWNUM=1;
    APEX_JSON.open_object;
    APEX_JSON.write('segmentValue', l_val); APEX_JSON.write('description', NVL(p_desc,''));
    APEX_JSON.write('currentValueId', l_cur);
    APEX_JSON.close_object;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    APEX_JSON.open_object;
    APEX_JSON.write('segmentValue', l_val); APEX_JSON.write('description', NVL(p_desc,''));
    APEX_JSON.write('currentValueId', TO_NUMBER(NULL));
    APEX_JSON.close_object;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT class_type_code, seg_pad_width INTO l_type, l_width
    FROM dct_gl_class_type WHERE segment_key = l_key AND ROWNUM=1;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  IF l_key = 'COST_CENTER' THEN
    FOR r IN (SELECT DISTINCT c.cost_center code, l.cost_center_description descr
              FROM gl_src_combinations c JOIN gl_src_cost_centers l ON l.cost_center=c.cost_center
              WHERE l_search IS NULL OR UPPER(TO_CHAR(c.cost_center)||' '||l.cost_center_description) LIKE '%'||UPPER(l_search)||'%'
              ORDER BY 1 FETCH FIRST l_limit ROWS ONLY) LOOP emit(r.code, r.descr); END LOOP;
  ELSIF l_key = 'APPROPRIATION' THEN
    FOR r IN (SELECT DISTINCT c.appropriation code, l.appropriation_description descr
              FROM gl_src_combinations c JOIN gl_src_appropriation l ON l.appropriation_code=c.appropriation
              WHERE l_search IS NULL OR UPPER(TO_CHAR(c.appropriation)||' '||l.appropriation_description) LIKE '%'||UPPER(l_search)||'%'
              ORDER BY 1 FETCH FIRST l_limit ROWS ONLY) LOOP emit(r.code, r.descr); END LOOP;
  ELSIF l_key = 'PROGRAM_CODE' THEN
    FOR r IN (SELECT DISTINCT c.program_code code, l.program_description descr
              FROM gl_src_combinations c JOIN gl_src_program l ON l.program_code=c.program_code
              WHERE l_search IS NULL OR UPPER(TO_CHAR(c.program_code)||' '||l.program_description) LIKE '%'||UPPER(l_search)||'%'
              ORDER BY 1 FETCH FIRST l_limit ROWS ONLY) LOOP emit(r.code, r.descr); END LOOP;
  END IF;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Unknown segment key');
WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- MAPPINGS -- date-tracked segment -> classification assignments
    --   GET /gl/mappings?type=&segment=&valueid=
    --   (valueid + segmentDesc added for the Classifications row-click drawer;
    --    keep in sync with the additive 09_gl_class_drill_ords.sql)
    -- =========================================================================
    def_template('mappings');
    def_handler('mappings', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_type VARCHAR2(30)  := UPPER([COLON]type);
  l_seg  VARCHAR2(60)  := [COLON]segment;
  l_vid  NUMBER        := TO_NUMBER([COLON]valueid DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (
    SELECT m.map_id, m.class_type_code, m.segment_value, m.class_value_id,
           v.value_code, v.name_en, m.notes,
           TO_CHAR(m.start_date,'YYYY-MM-DD') start_d,
           TO_CHAR(m.end_date,'YYYY-MM-DD')   end_d,
           CASE WHEN TRUNC(SYSDATE) BETWEEN m.start_date AND NVL(m.end_date, DATE '4000-01-01')
                THEN 'Y' ELSE 'N' END is_current,
           sd.descr AS seg_desc
    FROM dct_gl_seg_class_map m
    JOIN dct_gl_class_value v ON v.class_value_id = m.class_value_id
    JOIN dct_gl_class_type  t ON t.class_type_code = m.class_type_code
    LEFT JOIN (
      SELECT 'COST_CENTER' AS seg_key, dct_gl_class_pkg.norm(cost_center,7) AS sv,
             MAX(cost_center_description) AS descr
        FROM gl_src_cost_centers GROUP BY dct_gl_class_pkg.norm(cost_center,7)
      UNION ALL
      SELECT 'APPROPRIATION', dct_gl_class_pkg.norm(appropriation_code,6),
             MAX(appropriation_description)
        FROM gl_src_appropriation GROUP BY dct_gl_class_pkg.norm(appropriation_code,6)
      UNION ALL
      SELECT 'PROGRAM_CODE', dct_gl_class_pkg.norm(program_code,6),
             MAX(program_description)
        FROM gl_src_program GROUP BY dct_gl_class_pkg.norm(program_code,6)
    ) sd ON sd.seg_key = t.segment_key AND sd.sv = m.segment_value
    WHERE (l_type IS NULL OR m.class_type_code=l_type)
      AND (l_seg  IS NULL OR m.segment_value=l_seg)
      AND (l_vid  IS NULL OR m.class_value_id=l_vid)
    ORDER BY m.class_type_code, m.segment_value, m.start_date DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('mapId', r.map_id); APEX_JSON.write('type', r.class_type_code);
    APEX_JSON.write('segmentValue', r.segment_value); APEX_JSON.write('segmentDesc', NVL(r.seg_desc,''));
    APEX_JSON.write('classValueId', r.class_value_id);
    APEX_JSON.write('valueCode', r.value_code); APEX_JSON.write('valueName', r.name_en);
    APEX_JSON.write('startDate', r.start_d); APEX_JSON.write('endDate', NVL(r.end_d,''));
    APEX_JSON.write('notes', NVL(r.notes,'')); APEX_JSON.write('isCurrent', r.is_current);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('mappings', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_type VARCHAR2(30); l_seg VARCHAR2(60); l_cv NUMBER; l_s DATE; l_e DATE; l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_type := UPPER(APEX_JSON.get_varchar2(p_path=>'type'));
  l_seg  := APEX_JSON.get_varchar2(p_path=>'segmentValue');
  l_cv   := APEX_JSON.get_number(p_path=>'classValueId');
  l_s    := TO_DATE(APEX_JSON.get_varchar2(p_path=>'startDate'),'YYYY-MM-DD');
  l_e    := TO_DATE(APEX_JSON.get_varchar2(p_path=>'endDate'),'YYYY-MM-DD');
  dct_gl_class_pkg.validate_map(NULL, l_type, l_seg, l_cv, l_s, l_e);
  INSERT INTO dct_gl_seg_class_map (class_type_code, segment_value, class_value_id, start_date, end_date, notes, created_by)
  VALUES (l_type, l_seg, l_cv, l_s, l_e, APEX_JSON.get_varchar2(p_path=>'notes'), l_user)
  RETURNING map_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('mapId', l_id); APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('mappings/[COLON]id');
    def_handler('mappings/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_type VARCHAR2(30); l_seg VARCHAR2(60); l_cv NUMBER; l_s DATE; l_e DATE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  SELECT class_type_code, segment_value INTO l_type, l_seg FROM dct_gl_seg_class_map WHERE map_id=[COLON]id;
  l_cv := NVL(APEX_JSON.get_number(p_path=>'classValueId'),
              (SELECT class_value_id FROM dct_gl_seg_class_map WHERE map_id=[COLON]id));
  l_s  := NVL(TO_DATE(APEX_JSON.get_varchar2(p_path=>'startDate'),'YYYY-MM-DD'),
              (SELECT start_date FROM dct_gl_seg_class_map WHERE map_id=[COLON]id));
  l_e  := TO_DATE(APEX_JSON.get_varchar2(p_path=>'endDate'),'YYYY-MM-DD');
  dct_gl_class_pkg.validate_map([COLON]id, l_type, l_seg, l_cv, l_s, l_e);
  UPDATE dct_gl_seg_class_map SET class_value_id=l_cv, start_date=l_s, end_date=l_e,
         notes=APEX_JSON.get_varchar2(p_path=>'notes'), updated_by=l_user, updated_at=SYSTIMESTAMP
   WHERE map_id=[COLON]id;
  IF SQL%ROWCOUNT=0 THEN dct_rest.err(404,'Assignment not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Assignment not found');
  WHEN OTHERS THEN IF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_handler('mappings/[COLON]id', 'DELETE', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  DELETE FROM dct_gl_seg_class_map WHERE map_id=[COLON]id;
  IF SQL%ROWCOUNT=0 THEN dct_rest.err(404,'Assignment not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- COMBINATIONS -- the unified COA view (paginated, filterable, as-of aware)
    -- =========================================================================
    def_template('combinations');
    def_handler('combinations', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_search VARCHAR2(200) := [COLON]search;
  l_sector VARCHAR2(60)  := [COLON]sector;
  l_chap   VARCHAR2(60)  := [COLON]chapter;
  l_prog   VARCHAR2(60)  := [COLON]program;
  l_asof   VARCHAR2(20)  := [COLON]asof;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 50), 500);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_asof IS NOT NULL THEN dct_gl_class_pkg.set_asof(TO_DATE(l_asof,'YYYY-MM-DD'));
  ELSE dct_gl_class_pkg.clear_asof; END IF;
  SELECT COUNT(*) INTO l_total FROM dct_gl_coa_v v
   WHERE (l_search IS NULL OR UPPER(v.cc_string||' '||v.cost_center_desc||' '||v.account_desc) LIKE '%'||UPPER(l_search)||'%')
     AND (l_sector IS NULL OR v.sector_code=l_sector)
     AND (l_chap   IS NULL OR v.chapter_code=l_chap)
     AND (l_prog   IS NULL OR v.program_class_code=l_prog);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT * FROM dct_gl_coa_v v
     WHERE (l_search IS NULL OR UPPER(v.cc_string||' '||v.cost_center_desc||' '||v.account_desc) LIKE '%'||UPPER(l_search)||'%')
       AND (l_sector IS NULL OR v.sector_code=l_sector)
       AND (l_chap   IS NULL OR v.chapter_code=l_chap)
       AND (l_prog   IS NULL OR v.program_class_code=l_prog)
     ORDER BY v.cc_id OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('ccId', r.cc_id); APEX_JSON.write('ccString', r.cc_string);
    APEX_JSON.write('entityCode', r.entity_code); APEX_JSON.write('entityDesc', NVL(r.entity_desc,''));
    APEX_JSON.write('costCenterCode', r.cost_center_code); APEX_JSON.write('costCenterDesc', NVL(r.cost_center_desc,''));
    APEX_JSON.write('accountCode', r.account_code); APEX_JSON.write('accountDesc', NVL(r.account_desc,''));
    APEX_JSON.write('appropriationCode', r.appropriation_code); APEX_JSON.write('appropriationDesc', NVL(r.appropriation_desc,''));
    APEX_JSON.write('budgetGroupCode', r.budget_group_code); APEX_JSON.write('budgetGroupDesc', NVL(r.budget_group_desc,''));
    APEX_JSON.write('entitySpecificCode', r.entity_specific_code); APEX_JSON.write('entitySpecificDesc', NVL(r.entity_specific_desc,''));
    APEX_JSON.write('future1Code', r.future1_code); APEX_JSON.write('future1Desc', NVL(r.future1_desc,''));
    APEX_JSON.write('future2Code', r.future2_code); APEX_JSON.write('future2Desc', NVL(r.future2_desc,''));
    APEX_JSON.write('intercompanyCode', r.intercompany_code); APEX_JSON.write('intercompanyDesc', NVL(r.intercompany_desc,''));
    APEX_JSON.write('programCode', r.program_code); APEX_JSON.write('programDesc', NVL(r.program_desc,''));
    APEX_JSON.write('sectorCode', NVL(r.sector_code,'')); APEX_JSON.write('sectorName', NVL(r.sector_name,''));
    APEX_JSON.write('chapterCode', NVL(r.chapter_code,'')); APEX_JSON.write('chapterName', NVL(r.chapter_name,''));
    APEX_JSON.write('programClassCode', NVL(r.program_class_code,'')); APEX_JSON.write('programName', NVL(r.program_name,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
  dct_gl_class_pkg.clear_asof;
EXCEPTION WHEN OTHERS THEN dct_gl_class_pkg.clear_asof; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('combinations/[COLON]id');
    def_handler('combinations/[COLON]id', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_found NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM dct_gl_coa_v WHERE cc_id=[COLON]id) LOOP
    l_found := 1; APEX_JSON.open_object;
    APEX_JSON.write('ccId', r.cc_id); APEX_JSON.write('ccString', r.cc_string);
    APEX_JSON.write('entityCode', r.entity_code); APEX_JSON.write('entityDesc', NVL(r.entity_desc,''));
    APEX_JSON.write('costCenterCode', r.cost_center_code); APEX_JSON.write('costCenterDesc', NVL(r.cost_center_desc,''));
    APEX_JSON.write('accountCode', r.account_code); APEX_JSON.write('accountDesc', NVL(r.account_desc,''));
    APEX_JSON.write('appropriationCode', r.appropriation_code); APEX_JSON.write('appropriationDesc', NVL(r.appropriation_desc,''));
    APEX_JSON.write('budgetGroupCode', r.budget_group_code); APEX_JSON.write('budgetGroupDesc', NVL(r.budget_group_desc,''));
    APEX_JSON.write('entitySpecificCode', r.entity_specific_code); APEX_JSON.write('entitySpecificDesc', NVL(r.entity_specific_desc,''));
    APEX_JSON.write('future1Code', r.future1_code); APEX_JSON.write('future1Desc', NVL(r.future1_desc,''));
    APEX_JSON.write('future2Code', r.future2_code); APEX_JSON.write('future2Desc', NVL(r.future2_desc,''));
    APEX_JSON.write('intercompanyCode', r.intercompany_code); APEX_JSON.write('intercompanyDesc', NVL(r.intercompany_desc,''));
    APEX_JSON.write('programCode', r.program_code); APEX_JSON.write('programDesc', NVL(r.program_desc,''));
    APEX_JSON.write('sectorName', NVL(r.sector_name,'')); APEX_JSON.write('chapterName', NVL(r.chapter_name,''));
    APEX_JSON.write('programName', NVL(r.program_name,''));
    APEX_JSON.close_object;
  END LOOP;
  IF l_found = 0 THEN dct_rest.err(404,'Combination not found'); END IF;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- BALANCES -- budget balances enriched with Sector (as-of aware)
    -- =========================================================================
    def_template('balances');
    def_handler('balances', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_asof   VARCHAR2(20)  := [COLON]asof;
  l_sector VARCHAR2(60)  := [COLON]sector;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 50), 500);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_asof IS NOT NULL THEN dct_gl_class_pkg.set_asof(TO_DATE(l_asof,'YYYY-MM-DD')); ELSE dct_gl_class_pkg.clear_asof; END IF;
  SELECT COUNT(*) INTO l_total FROM dct_gl_balances_v v WHERE (l_sector IS NULL OR v.sector_code=l_sector);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (SELECT v.cost_center, v.cost_center_name, v.account_code, v.account_name,
                   v.total_budget, v.expenditures, v.funds_available, v.sector_code, v.sector_name
            FROM dct_gl_balances_v v WHERE (l_sector IS NULL OR v.sector_code=l_sector)
            ORDER BY v.cost_center OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('costCenter', NVL(r.cost_center,'')); APEX_JSON.write('costCenterName', NVL(r.cost_center_name,''));
    APEX_JSON.write('accountCode', NVL(r.account_code,'')); APEX_JSON.write('accountName', NVL(r.account_name,''));
    APEX_JSON.write('totalBudget', r.total_budget); APEX_JSON.write('expenditures', r.expenditures);
    APEX_JSON.write('fundsAvailable', r.funds_available);
    APEX_JSON.write('sectorCode', NVL(r.sector_code,'')); APEX_JSON.write('sectorName', NVL(r.sector_name,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
  dct_gl_class_pkg.clear_asof;
EXCEPTION WHEN OTHERS THEN dct_gl_class_pkg.clear_asof; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- ACTUALS FILTERS -- everything the Budget-vs-Actual report page needs to
    -- populate its search criteria in one call (periods + classification LOVs).
    -- =========================================================================
    def_template('actuals/filters');
    def_handler('actuals/filters', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_cur  VARCHAR2(7);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  -- default period = current calendar month if it has data, else the latest period
  SELECT NVL(MAX(CASE WHEN period_name = TO_CHAR(SYSDATE,'MM-YYYY') THEN period_name END),
             MAX(period_name) KEEP (DENSE_RANK LAST ORDER BY TO_DATE(period_name,'MM-YYYY')))
    INTO l_cur FROM prod.gl_balances WHERE period_name IS NOT NULL;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('defaultPeriod', l_cur);
  APEX_JSON.open_array('periods');
  FOR r IN (SELECT DISTINCT period_name pn FROM prod.gl_balances WHERE period_name IS NOT NULL
            ORDER BY TO_DATE(period_name,'MM-YYYY') DESC) LOOP
    APEX_JSON.open_object; APEX_JSON.write('period', r.pn);
    APEX_JSON.write('isCurrent', CASE WHEN r.pn = l_cur THEN 'Y' ELSE 'N' END);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('sectors');
  FOR r IN (SELECT value_code, name_en FROM prod.dct_gl_class_value WHERE class_type_code='SECTOR' AND is_active='Y' ORDER BY display_order, name_en) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code', r.value_code); APEX_JSON.write('name', r.name_en); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('chapters');
  FOR r IN (SELECT value_code, name_en FROM prod.dct_gl_class_value WHERE class_type_code='CHAPTER' AND is_active='Y' ORDER BY display_order, name_en) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code', r.value_code); APEX_JSON.write('name', r.name_en); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('programs');
  FOR r IN (SELECT value_code, name_en FROM prod.dct_gl_class_value WHERE class_type_code='DCT_PROGRAM' AND is_active='Y' ORDER BY display_order, name_en) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code', r.value_code); APEX_JSON.write('name', r.name_en); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('appropriations');
  FOR r IN (SELECT appropriation_code code, MAX(appropriation_desc) descr FROM prod.dct_gl_coa_snap
            WHERE appropriation_code IS NOT NULL GROUP BY appropriation_code ORDER BY appropriation_code) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code', r.code); APEX_JSON.write('name', NVL(r.descr,r.code)); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('accounts');
  FOR r IN (SELECT account_code code, MAX(account_desc) descr FROM prod.dct_gl_coa_snap
            WHERE account_code IS NOT NULL GROUP BY account_code ORDER BY account_code) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code', r.code); APEX_JSON.write('name', NVL(r.descr,r.code)); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('costCenters');
  FOR r IN (SELECT cost_center_code code, MAX(cost_center_desc) descr FROM prod.dct_gl_coa_snap
            WHERE cost_center_code IS NOT NULL GROUP BY cost_center_code ORDER BY cost_center_code) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code', r.code); APEX_JSON.write('name', NVL(r.descr,r.code)); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- ACTUALS -- Budget vs Actual per GL combination for one period (YTD).
    --   GET /gl/actuals?period=&sector=&chapter=&program=&appropriation=&search=&limit=&offset=
    --   Returns {total, totals{...business-question answer...}, items[...]}.
    --   Each item carries the full 10 segment codes/descs so the UI reuses the
    --   combination hover popover (same field names as /combinations).
    -- =========================================================================
    def_template('actuals');
    def_handler('actuals', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_period VARCHAR2(7)   := [COLON]period;
  l_sector VARCHAR2(400) := [COLON]sector;
  l_chap   VARCHAR2(400) := [COLON]chapter;
  l_prog   VARCHAR2(400) := [COLON]program;
  l_appr   VARCHAR2(400) := [COLON]appropriation;
  l_acct   VARCHAR2(400) := [COLON]account;
  l_cc     VARCHAR2(400) := [COLON]costcenter;
  l_atype  VARCHAR2(60)  := [COLON]accounttype;
  l_source VARCHAR2(30)  := [COLON]source;
  l_search VARCHAR2(200) := [COLON]search;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 100), 1000);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
  t_bud NUMBER; t_enc NUMBER; t_prt NUMBER; t_ocmt NUMBER; t_cpipe NUMBER; t_tpo NUMBER; t_oobl NUMBER; t_ppipe NUMBER; t_oenc NUMBER; t_act NUMBER; t_fun NUMBER; t_fcalc NUMBER; t_grn NUMBER; t_apd NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_period IS NULL THEN dct_rest.err(400,'period is required'); RETURN; END IF;
  SELECT COUNT(*), NVL(SUM(budget_ytd),0), NVL(SUM(encumbrance_ytd),0),
         NVL(SUM(pr_total_ytd),0), NVL(SUM(open_commitment_ytd),0), NVL(SUM(commitment_pipeline_ytd),0),
         NVL(SUM(total_po_ytd),0), NVL(SUM(open_obligation_ytd),0), NVL(SUM(po_pipeline_ytd),0),
         NVL(SUM(open_encumbrance_ytd),0),
         NVL(SUM(gl_actual_ytd),0), NVL(SUM(funds_available_ytd),0), NVL(SUM(funds_available_calc_ytd),0),
         NVL(SUM(grn_actual_ytd),0), NVL(SUM(ap_direct_actual_ytd),0)
    INTO l_total, t_bud, t_enc, t_prt, t_ocmt, t_cpipe, t_tpo, t_oobl, t_ppipe, t_oenc, t_act, t_fun, t_fcalc, t_grn, t_apd
    FROM prod.dct_budget_actual_period_v p
   WHERE p.period_name = l_period
     AND (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||p.sector_code||'|') > 0)
     AND (l_chap   IS NULL OR INSTR('|'||l_chap||'|',   '|'||p.chapter_code||'|') > 0)
     AND (l_prog   IS NULL OR INSTR('|'||l_prog||'|',   '|'||p.program_class_code||'|') > 0)
     AND (l_appr   IS NULL OR INSTR('|'||l_appr||'|',   '|'||p.appropriation_code||'|') > 0)
     AND (l_acct   IS NULL OR INSTR('|'||l_acct||'|',   '|'||p.account_code||'|') > 0)
     AND (l_cc     IS NULL OR INSTR('|'||l_cc||'|',     '|'||p.cost_center_code||'|') > 0)
     AND (l_atype  IS NULL OR INSTR('|'||l_atype||'|',  '|'||SUBSTR(p.account_code,1,1)||'|') > 0)
     AND (l_source IS NULL
          OR (l_source='budget'      AND p.budget_ytd            <> 0)
          OR (l_source='commitment'  AND p.pr_total_ytd          <> 0)
          OR (l_source='obligation'  AND p.total_po_ytd          <> 0)
          OR (l_source='openCommitment' AND p.open_commitment_ytd <> 0)
          OR (l_source='openObligation' AND p.open_obligation_ytd <> 0)
          OR (l_source='glActual'    AND p.gl_actual_ytd         <> 0)
          OR (l_source='grn'         AND p.grn_actual_ytd        <> 0)
          OR (l_source='apDirect'    AND p.ap_direct_actual_ytd  <> 0))
     AND (l_search IS NULL OR UPPER(p.cc_string||' '||p.cost_center_desc||' '||p.account_desc||' '||p.appropriation_desc) LIKE '%'||UPPER(l_search)||'%');
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.write('period', l_period);
  APEX_JSON.open_object('totals');
  APEX_JSON.write('budget', t_bud); APEX_JSON.write('encumbrance', t_enc);
  APEX_JSON.write('prTotal', t_prt); APEX_JSON.write('openCommitment', t_ocmt); APEX_JSON.write('commitmentPipeline', t_cpipe);
  APEX_JSON.write('totalPo', t_tpo); APEX_JSON.write('openObligation', t_oobl); APEX_JSON.write('poPipeline', t_ppipe);
  APEX_JSON.write('openEncumbrance', t_oenc);
  APEX_JSON.write('glActual', t_act);
  APEX_JSON.write('fundsAvailable', t_fun); APEX_JSON.write('fundsAvailableCalc', t_fcalc);
  APEX_JSON.write('grnActual', t_grn); APEX_JSON.write('apDirect', t_apd);
  APEX_JSON.write('slaActual', t_grn + t_apd);
  APEX_JSON.write('variance', t_bud - t_act);
  APEX_JSON.close_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT p.cc_string, p.cc_id, p.cost_center_code, p.cost_center_desc, p.account_code, p.account_desc,
           p.appropriation_code, p.appropriation_desc, p.sector_code, p.sector_name,
           p.chapter_code, p.chapter_name, p.program_class_code, p.program_name,
           p.budget_ytd, p.encumbrance_ytd, p.pr_total_ytd, p.total_po_ytd,
           p.open_commitment_ytd, p.open_obligation_ytd,
           p.commitment_pipeline_ytd, p.po_pipeline_ytd, p.open_encumbrance_ytd,
           p.po_count, p.pr_count,
           p.gl_actual_ytd, p.funds_available_ytd, p.funds_available_calc_ytd,
           p.grn_actual_ytd, p.ap_direct_actual_ytd, p.variance_ytd,
           s.entity_code, s.entity_desc, s.budget_group_code, s.budget_group_desc,
           s.entity_specific_code, s.entity_specific_desc, s.future1_code, s.future1_desc,
           s.future2_code, s.future2_desc, s.intercompany_code, s.intercompany_desc,
           s.program_code seg_program_code, s.program_desc
    FROM prod.dct_budget_actual_period_v p
    LEFT JOIN prod.dct_gl_coa_snap s ON s.cc_string = p.cc_string
    WHERE p.period_name = l_period
      AND (l_sector IS NULL OR INSTR('|'||l_sector||'|', '|'||p.sector_code||'|') > 0)
      AND (l_chap   IS NULL OR INSTR('|'||l_chap||'|',   '|'||p.chapter_code||'|') > 0)
      AND (l_prog   IS NULL OR INSTR('|'||l_prog||'|',   '|'||p.program_class_code||'|') > 0)
      AND (l_appr   IS NULL OR INSTR('|'||l_appr||'|',   '|'||p.appropriation_code||'|') > 0)
      AND (l_acct   IS NULL OR INSTR('|'||l_acct||'|',   '|'||p.account_code||'|') > 0)
      AND (l_cc     IS NULL OR INSTR('|'||l_cc||'|',     '|'||p.cost_center_code||'|') > 0)
      AND (l_atype  IS NULL OR INSTR('|'||l_atype||'|',  '|'||SUBSTR(p.account_code,1,1)||'|') > 0)
      AND (l_source IS NULL
           OR (l_source='budget'      AND p.budget_ytd            <> 0)
           OR (l_source='commitment'  AND p.pr_total_ytd          <> 0)
           OR (l_source='obligation'  AND p.total_po_ytd          <> 0)
           OR (l_source='openCommitment' AND p.open_commitment_ytd <> 0)
           OR (l_source='openObligation' AND p.open_obligation_ytd <> 0)
           OR (l_source='glActual'    AND p.gl_actual_ytd         <> 0)
           OR (l_source='grn'         AND p.grn_actual_ytd        <> 0)
           OR (l_source='apDirect'    AND p.ap_direct_actual_ytd  <> 0))
      AND (l_search IS NULL OR UPPER(p.cc_string||' '||p.cost_center_desc||' '||p.account_desc||' '||p.appropriation_desc) LIKE '%'||UPPER(l_search)||'%')
    ORDER BY p.gl_actual_ytd DESC NULLS LAST, p.cc_string
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('ccString', r.cc_string); APEX_JSON.write('ccId', r.cc_id);
    APEX_JSON.write('costCenterCode', r.cost_center_code); APEX_JSON.write('costCenterDesc', NVL(r.cost_center_desc,''));
    APEX_JSON.write('accountCode', r.account_code); APEX_JSON.write('accountDesc', NVL(r.account_desc,''));
    APEX_JSON.write('accountTypeCode', SUBSTR(r.account_code,1,1));
    APEX_JSON.write('appropriationCode', NVL(r.appropriation_code,'')); APEX_JSON.write('appropriationDesc', NVL(r.appropriation_desc,''));
    APEX_JSON.write('sectorCode', NVL(r.sector_code,'')); APEX_JSON.write('sectorName', NVL(r.sector_name,''));
    APEX_JSON.write('chapterCode', NVL(r.chapter_code,'')); APEX_JSON.write('chapterName', NVL(r.chapter_name,''));
    APEX_JSON.write('programClassCode', NVL(r.program_class_code,'')); APEX_JSON.write('programName', NVL(r.program_name,''));
    APEX_JSON.write('budget', r.budget_ytd); APEX_JSON.write('encumbrance', r.encumbrance_ytd);
    APEX_JSON.write('prTotal', r.pr_total_ytd); APEX_JSON.write('openCommitment', r.open_commitment_ytd); APEX_JSON.write('commitmentPipeline', r.commitment_pipeline_ytd);
    APEX_JSON.write('totalPo', r.total_po_ytd); APEX_JSON.write('openObligation', r.open_obligation_ytd); APEX_JSON.write('poPipeline', r.po_pipeline_ytd);
    APEX_JSON.write('openEncumbrance', r.open_encumbrance_ytd);
    APEX_JSON.write('glActual', r.gl_actual_ytd); APEX_JSON.write('fundsAvailable', r.funds_available_ytd); APEX_JSON.write('fundsAvailableCalc', r.funds_available_calc_ytd);
    APEX_JSON.write('grnActual', r.grn_actual_ytd); APEX_JSON.write('apDirect', r.ap_direct_actual_ytd);
    APEX_JSON.write('slaActual', r.grn_actual_ytd + r.ap_direct_actual_ytd);
    APEX_JSON.write('poCount', r.po_count); APEX_JSON.write('prCount', r.pr_count);
    APEX_JSON.write('variance', r.variance_ytd);
    -- full segment detail for the hover popover (same keys as /combinations)
    APEX_JSON.write('entityCode', NVL(r.entity_code,'')); APEX_JSON.write('entityDesc', NVL(r.entity_desc,''));
    APEX_JSON.write('budgetGroupCode', NVL(r.budget_group_code,'')); APEX_JSON.write('budgetGroupDesc', NVL(r.budget_group_desc,''));
    APEX_JSON.write('entitySpecificCode', NVL(r.entity_specific_code,'')); APEX_JSON.write('entitySpecificDesc', NVL(r.entity_specific_desc,''));
    APEX_JSON.write('future1Code', NVL(r.future1_code,'')); APEX_JSON.write('future1Desc', NVL(r.future1_desc,''));
    APEX_JSON.write('future2Code', NVL(r.future2_code,'')); APEX_JSON.write('future2Desc', NVL(r.future2_desc,''));
    APEX_JSON.write('intercompanyCode', NVL(r.intercompany_code,'')); APEX_JSON.write('intercompanyDesc', NVL(r.intercompany_desc,''));
    APEX_JSON.write('programCode', NVL(r.seg_program_code,'')); APEX_JSON.write('programDesc', NVL(r.program_desc,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- ACTUALS LINES -- drill-down behind a single figure on the report.
    --   GET /gl/actuals/lines?period=&cc=&metric=
    --   metric in budget|encumbrance|commitment|obligation|openCommitment|
    --     openObligation|commitmentPipeline|poPipeline|glActual|grn|apDirect.
    --     commitment/openCommitment/commitmentPipeline -> real PR lines (pr_*);
    --     obligation/openObligation/poPipeline -> PO lines (openObligation GRN-netted).
    --   Returns {metric, ccString, period, total, columns[{key,label,type}], rows[]}.
    -- =========================================================================
    def_template('actuals/lines');
    -- source split into two TO_CLOB-concatenated q-literals: the whole body now
    -- exceeds the 32767-char PL/SQL VARCHAR2 literal limit (aggregate KPI drill added).
    def_handler('actuals/lines', 'GET', TO_CLOB(q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_period VARCHAR2(7)   := [COLON]period;
  l_cc     VARCHAR2(120) := [COLON]cc;
  l_metric VARCHAR2(30)  := LOWER([COLON]metric);
  -- aggregate-mode filters (used when l_cc IS NULL — KPI-card drill across the set,
  -- same predicates as GET /actuals). l_ccf = cost-centre filter (l_cc is the single
  -- combination string for the per-cell drill).
  l_sector VARCHAR2(400) := [COLON]sector;
  l_chap   VARCHAR2(400) := [COLON]chapter;
  l_prog   VARCHAR2(400) := [COLON]program;
  l_appr   VARCHAR2(400) := [COLON]appropriation;
  l_acct   VARCHAR2(400) := [COLON]account;
  l_ccf    VARCHAR2(400) := [COLON]costcenter;
  l_atype  VARCHAR2(60)  := [COLON]accounttype;
  l_source VARCHAR2(30)  := [COLON]source;
  l_search VARCHAR2(200) := [COLON]search;
  l_agg    BOOLEAN;
  l_pstart DATE; l_pnext DATE; l_ystart DATE;
  l_total  NUMBER := 0;
  l_count  NUMBER := 0;
  PROCEDURE col(p_key VARCHAR2, p_label VARCHAR2, p_type VARCHAR2) IS
  BEGIN
    APEX_JSON.open_object; APEX_JSON.write('key',p_key); APEX_JSON.write('label',p_label); APEX_JSON.write('type',p_type); APEX_JSON.close_object;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_period IS NULL OR l_metric IS NULL THEN dct_rest.err(400,'period and metric are required'); RETURN; END IF;
  l_agg := (l_cc IS NULL);   -- no combination => aggregate the whole filtered set
  l_pstart := TO_DATE(l_period,'MM-YYYY'); l_pnext := ADD_MONTHS(l_pstart,1); l_ystart := TRUNC(l_pstart,'YEAR');
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('metric', l_metric); APEX_JSON.write('ccString', l_cc); APEX_JSON.write('period', l_period);
  APEX_JSON.write('aggregate', CASE WHEN l_agg THEN 'Y' ELSE 'N' END);

  IF l_agg THEN
    -- ===================== AGGREGATE (KPI-card) DRILL =====================
    -- Supporting lines across the WHOLE filtered set. kys = the combinations that
    -- pass the same predicates as GET /actuals. Capped 500; 'count' carries the
    -- true line count so the UI shows a "top N of M" note; window SUM = full total.
    IF l_metric IN ('budget','glactual','funds','fundscalc') THEN
      APEX_JSON.open_array('columns');
      col('costCenter','Cost centre','text'); col('account','Account','text'); col('combination','Combination','text');
      IF l_metric = 'budget' THEN col('amount','Total budget','money');
      ELSIF l_metric = 'glactual' THEN col('amount','Actual expenditure','money');
      ELSE col('budget','Budget','money'); col('encumbrance','Open encumbrance','money'); col('actual','GL actual','money'); col('amount','Funds available','money'); END IF;
      APEX_JSON.close_array;
      APEX_JSON.open_array('rows');
      FOR r IN (
        SELECT p.cost_center_code, p.account_code, p.cc_string, p.budget_ytd, p.open_encumbrance_ytd, p.gl_actual_ytd,
               CASE l_metric WHEN 'budget' THEN p.budget_ytd WHEN 'glactual' THEN p.gl_actual_ytd
                    WHEN 'fundscalc' THEN p.funds_available_calc_ytd ELSE p.funds_available_ytd END amt,
               SUM(CASE l_metric WHEN 'budget' THEN p.budget_ytd WHEN 'glactual' THEN p.gl_actual_ytd
                    WHEN 'fundscalc' THEN p.funds_available_calc_ytd ELSE p.funds_available_ytd END) OVER () tot,
               COUNT(*) OVER () cnt
        FROM prod.dct_budget_actual_period_v p
        WHERE p.period_name = l_period
          AND (l_sector IS NULL OR INSTR('|'||l_sector||'|','|'||p.sector_code||'|')>0)
          AND (l_chap   IS NULL OR INSTR('|'||l_chap||'|','|'||p.chapter_code||'|')>0)
          AND (l_prog   IS NULL OR INSTR('|'||l_prog||'|','|'||p.program_class_code||'|')>0)
          AND (l_appr   IS NULL OR INSTR('|'||l_appr||'|','|'||p.appropriation_code||'|')>0)
          AND (l_acct   IS NULL OR INSTR('|'||l_acct||'|','|'||p.account_code||'|')>0)
          AND (l_ccf    IS NULL OR INSTR('|'||l_ccf||'|','|'||p.cost_center_code||'|')>0)
          AND (l_atype  IS NULL OR INSTR('|'||l_atype||'|','|'||SUBSTR(p.account_code,1,1)||'|')>0)
          AND (l_search IS NULL OR UPPER(p.cc_string||' '||p.cost_center_desc||' '||p.account_desc||' '||p.appropriation_desc) LIKE '%'||UPPER(l_search)||'%')
          AND (p.budget_ytd<>0 OR p.gl_actual_ytd<>0 OR p.open_encumbrance_ytd<>0)
        ORDER BY amt DESC NULLS LAST, p.cc_string FETCH FIRST 500 ROWS ONLY
      ) LOOP
        l_total := r.tot; l_count := r.cnt;
        APEX_JSON.open_object;
        APEX_JSON.write('costCenter',r.cost_center_code); APEX_JSON.write('account',r.account_code); APEX_JSON.write('combination',r.cc_string);
        IF l_metric IN ('funds','fundscalc') THEN
          APEX_JSON.write('budget',r.budget_ytd); APEX_JSON.write('encumbrance',r.open_encumbrance_ytd); APEX_JSON.write('actual',r.gl_actual_ytd);
        END IF;
        APEX_JSON.write('amount',r.amt); APEX_JSON.close_object;
      END LOOP;
      APEX_JSON.close_array;

    ELSIF l_metric = 'grn' THEN
      APEX_JSON.open_array('columns'); col('costCenter','Cost centre','text'); col('account','Account','text'); col('receipt','GRN #','text'); col('line','Line','text'); col('date','Date','date'); col('supplier','Supplier','text'); col('amount','Amount (AED)','money'); APEX_JSON.close_array;
      APEX_JSON.open_array('rows');
      FOR r IN (
        WITH kys AS (SELECT p.cc_string, p.cost_center_code, p.account_code FROM prod.dct_budget_actual_period_v p
                     WHERE p.period_name=l_period
                       AND (l_sector IS NULL OR INSTR('|'||l_sector||'|','|'||p.sector_code||'|')>0)
                       AND (l_chap   IS NULL OR INSTR('|'||l_chap||'|','|'||p.chapter_code||'|')>0)
                       AND (l_prog   IS NULL OR INSTR('|'||l_prog||'|','|'||p.program_class_code||'|')>0)
                       AND (l_appr   IS NULL OR INSTR('|'||l_appr||'|','|'||p.appropriation_code||'|')>0)
                       AND (l_acct   IS NULL OR INSTR('|'||l_acct||'|','|'||p.account_code||'|')>0)
                       AND (l_ccf    IS NULL OR INSTR('|'||l_ccf||'|','|'||p.cost_center_code||'|')>0)
                       AND (l_atype  IS NULL OR INSTR('|'||l_atype||'|','|'||SUBSTR(p.account_code,1,1)||'|')>0)
                       AND (l_search IS NULL OR UPPER(p.cc_string||' '||p.cost_center_desc||' '||p.account_desc||' '||p.appropriation_desc) LIKE '%'||UPPER(l_search)||'%'))
        SELECT k.cost_center_code, k.account_code, g.receipt_number, g.receipt_line_number line_no,
               TO_CHAR(g.transaction_date,'YYYY-MM-DD') td, h.supplier_name, g.ledger_amount aed,
               SUM(g.ledger_amount) OVER () tot, COUNT(*) OVER () cnt
        FROM prod.grn_all_v2 g
        JOIN prod.po_distributions pod ON pod.po_distribution_id = g.po_distribution_id
        JOIN kys k ON k.cc_string = prod.dct_cc_canon(pod.charge_account)
        LEFT JOIN prod.po_headers h ON h.po_header_id = g.po_header_id
        WHERE g.transaction_date >= l_ystart AND g.transaction_date < l_pnext
        ORDER BY g.ledger_amount DESC NULLS LAST FETCH FIRST 500 ROWS ONLY
      ) LOOP
        l_total := r.tot; l_count := r.cnt;
        APEX_JSON.open_object; APEX_JSON.write('costCenter',r.cost_center_code); APEX_JSON.write('account',r.account_code);
        APEX_JSON.write('receipt',r.receipt_number); APEX_JSON.write('line',NVL(TO_CHAR(r.line_no),'')); APEX_JSON.write('date',NVL(r.td,''));
        APEX_JSON.write('supplier',NVL(r.supplier_name,'')); APEX_JSON.write('amount',r.aed); APEX_JSON.close_object;
      END LOOP;
      APEX_JSON.close_array;

    ELSIF l_metric = 'apdirect' THEN
      APEX_JSON.open_array('columns'); col('costCenter','Cost centre','text'); col('account','Account','text'); col('invoice','Invoice #','text'); col('line','Line','text'); col('date','Acct date','date'); col('description','Description','text'); col('amount','Amount (AED)','money'); APEX_JSON.close_array;
      APEX_JSON.open_array('rows');
      FOR r IN (
        WITH kys AS (SELECT p.cc_id, p.cost_center_code, p.account_code FROM prod.dct_budget_actual_period_v p
                     WHERE p.period_name=l_period
                       AND (l_sector IS NULL OR INSTR('|'||l_sector||'|','|'||p.sector_code||'|')>0)
                       AND (l_chap   IS NULL OR INSTR('|'||l_chap||'|','|'||p.chapter_code||'|')>0)
                       AND (l_prog   IS NULL OR INSTR('|'||l_prog||'|','|'||p.program_class_code||'|')>0)
                       AND (l_appr   IS NULL OR INSTR('|'||l_appr||'|','|'||p.appropriation_code||'|')>0)
                       AND (l_acct   IS NULL OR INSTR('|'||l_acct||'|','|'||p.account_code||'|')>0)
                       AND (l_ccf    IS NULL OR INSTR('|'||l_ccf||'|','|'||p.cost_center_code||'|')>0)
                       AND (l_atype  IS NULL OR INSTR('|'||l_atype||'|','|'||SUBSTR(p.account_code,1,1)||'|')>0)
                       AND (l_search IS NULL OR UPPER(p.cc_string||' '||p.cost_center_desc||' '||p.account_desc||' '||p.appropriation_desc) LIKE '%'||UPPER(l_search)||'%'))
        SELECT k.cost_center_code, k.account_code, NVL(i.invoice_number,'#'||TO_CHAR(d.invoice_id)) inv_no, d.line_number line_no,
               TO_CHAR(d.accounting_date,'YYYY-MM-DD') ad, d.distribution_description descr,
               NVL(d.distribution_amount_functi,d.distribution_amount) aed,
               SUM(NVL(d.distribution_amount_functi,d.distribution_amount)) OVER () tot, COUNT(*) OVER () cnt
        FROM prod.ap_invoice_distributions d
        JOIN kys k ON k.cc_id = d.cc_id
        LEFT JOIN (SELECT invoice_id, MAX(invoice_number) invoice_number FROM prod.ap_invoices GROUP BY invoice_id) i ON i.invoice_id = d.invoice_id
        WHERE d.po_number IS NULL AND NVL(d.reversal_indicator,'N') <> 'Y'
          AND NVL(NVL(d.distribution_amount_functi,d.distribution_amount),0) <> 0
          AND d.accounting_date >= l_ystart AND d.accounting_date < l_pnext
        ORDER BY NVL(d.distribution_amount_functi,d.distribution_amount) DESC NULLS LAST FETCH FIRST 500 ROWS ONLY
      ) LOOP
        l_total := r.tot; l_count := r.cnt;
        APEX_JSON.open_object; APEX_JSON.write('costCenter',r.cost_center_code); APEX_JSON.write('account',r.account_code);
        APEX_JSON.write('invoice',NVL(r.inv_no,'')); APEX_JSON.write('line',NVL(TO_CHAR(r.line_no),'')); APEX_JSON.write('date',NVL(r.ad,''));
        APEX_JSON.write('description',NVL(r.descr,'')); APEX_JSON.write('amount',r.aed); APEX_JSON.close_object;
      END LOOP;
      APEX_JSON.close_array;

    ELSIF l_metric IN ('obligation','popipeline') THEN
      APEX_JSON.open_array('columns'); col('costCenter','Cost centre','text'); col('account','Account','text'); col('po','PO #','text'); col('line','Line','text'); col('description','Item / description','text'); col('supplier','Supplier','text'); col('status','Funds status','text'); col('amount','Ordered (AED)','money'); APEX_JSON.close_array;
      APEX_JSON.open_array('rows');
      FOR r IN (
        WITH kys AS (SELECT p.cc_string, p.cost_center_code, p.account_code FROM prod.dct_budget_actual_period_v p
                     WHERE p.period_name=l_period
                       AND (l_sector IS NULL OR INSTR('|'||l_sector||'|','|'||p.sector_code||'|')>0)
                       AND (l_chap   IS NULL OR INSTR('|'||l_chap||'|','|'||p.chapter_code||'|')>0)
                       AND (l_prog   IS NULL OR INSTR('|'||l_prog||'|','|'||p.program_class_code||'|')>0)
                       AND (l_appr   IS NULL OR INSTR('|'||l_appr||'|','|'||p.appropriation_code||'|')>0)
                       AND (l_acct   IS NULL OR INSTR('|'||l_acct||'|','|'||p.account_code||'|')>0)
                       AND (l_ccf    IS NULL OR INSTR('|'||l_ccf||'|','|'||p.cost_center_code||'|')>0)
                       AND (l_atype  IS NULL OR INSTR('|'||l_atype||'|','|'||SUBSTR(p.account_code,1,1)||'|')>0)
                       AND (l_search IS NULL OR UPPER(p.cc_string||' '||p.cost_center_desc||' '||p.account_desc||' '||p.appropriation_desc) LIKE '%'||UPPER(l_search)||'%'))
        SELECT cost_center_code, account_code, order_number, po_line, item_description, supplier_name, po_status, amt,
               SUM(amt) OVER () tot, COUNT(*) OVER () cnt FROM (
          SELECT k.cost_center_code, k.account_code, h.order_number, pl.line po_line, pl.item_description, h.supplier_name, pd.funds_status po_status,
                 MAX(pd.distribution_amount*NVL(pd.rate,1)) amt
          FROM prod.po_distributions pd
          JOIN kys k ON k.cc_string = prod.dct_cc_canon(pd.charge_account)
          JOIN prod.po_headers h ON h.po_header_id = pd.po_header_id
          LEFT JOIN prod.po_lines pl ON pl.po_header_id = pd.po_header_id AND pl.po_line_id = pd.po_line_id
          WHERE (pd.budget_date IS NULL OR pd.budget_date < l_pnext)
            AND ( (l_metric='obligation' AND NVL(pd.funds_status,'x') NOT IN ('Failed','Passed'))
               OR (l_metric='popipeline' AND pd.funds_status IN ('Failed','Passed')) )
          GROUP BY k.cost_center_code, k.account_code, h.order_number, pl.line, pl.item_description, h.supplier_name, pd.funds_status, pd.po_distribution_id)
        ORDER BY amt DESC NULLS LAST FETCH FIRST 500 ROWS ONLY
      ) LOOP
        l_total := r.tot; l_count := r.cnt;
        APEX_JSON.open_object; APEX_JSON.write('costCenter',r.cost_center_code); APEX_JSON.write('account',r.account_code);
        APEX_JSON.write('po',NVL(TO_CHAR(r.order_number),'')); APEX_JSON.write('line',NVL(TO_CHAR(r.po_line),''));
        APEX_JSON.write('description',NVL(r.item_description,'')); APEX_JSON.write('supplier',NVL(r.supplier_name,''));
        APEX_JSON.write('status',NVL(r.po_status,'')); APEX_JSON.write('amount',r.amt); APEX_JSON.close_object;
      END LOOP;
      APEX_JSON.close_array;

    ELSIF l_metric = 'openobligation' THEN
      APEX_JSON.open_array('columns'); col('costCenter','Cost centre','text'); col('account','Account','text'); col('po','PO #','text'); col('line','Line','text'); col('description','Item / description','text'); col('status','Funds status','text'); col('ordered','Ordered (AED)','money'); col('grn','Received (AED)','money'); col('amount','Open (AED)','money'); APEX_JSON.close_array;
      APEX_JSON.open_array('rows');
      FOR r IN (
        WITH kys AS (SELECT p.cc_string, p.cost_center_code, p.account_code FROM prod.dct_budget_actual_period_v p
                     WHERE p.period_name=l_period
                       AND (l_sector IS NULL OR INSTR('|'||l_sector||'|','|'||p.sector_code||'|')>0)
                       AND (l_chap   IS NULL OR INSTR('|'||l_chap||'|','|'||p.chapter_code||'|')>0)
                       AND (l_prog   IS NULL OR INSTR('|'||l_prog||'|','|'||p.program_class_code||'|')>0)
                       AND (l_appr   IS NULL OR INSTR('|'||l_appr||'|','|'||p.appropriation_code||'|')>0)
                       AND (l_acct   IS NULL OR INSTR('|'||l_acct||'|','|'||p.account_code||'|')>0)
                       AND (l_ccf    IS NULL OR INSTR('|'||l_ccf||'|','|'||p.cost_center_code||'|')>0)
                       AND (l_atype  IS NULL OR INSTR('|'||l_atype||'|','|'||SUBSTR(p.account_code,1,1)||'|')>0)
                       AND (l_search IS NULL OR UPPER(p.cc_string||' '||p.cost_center_desc||' '||p.account_desc||' '||p.appropriation_desc) LIKE '%'||UPPER(l_search)||'%'))
        SELECT cost_center_code, account_code, order_number, po_line, item_description, po_status, ordered, grn, GREATEST(ordered-grn,0) open_amt,
               SUM(GREATEST(ordered-grn,0)) OVER () tot, COUNT(*) OVER () cnt FROM (
          SELECT k.cost_center_code, k.account_code, h.order_number, pl.line po_line, pl.item_description, pd.funds_status po_status,
                 MAX(pd.distribution_amount*NVL(pd.rate,1)) ordered, NVL(MAX(g.grn),0) grn
          FROM prod.po_distributions pd
          JOIN kys k ON k.cc_string = prod.dct_cc_canon(pd.charge_account)
          JOIN prod.po_headers h ON h.po_header_id = pd.po_header_id
          LEFT JOIN prod.po_lines pl ON pl.po_header_id = pd.po_header_id AND pl.po_line_id = pd.po_line_id
          LEFT JOIN (SELECT po_distribution_id, SUM(ledger_amount) grn FROM prod.grn_all_v2 GROUP BY po_distribution_id) g ON g.po_distribution_id = pd.po_distribution_id
          WHERE (pd.budget_date IS NULL OR pd.budget_date < l_pnext)
            AND pd.funds_status IN ('Reserved','Partially Liquidated')
            AND NOT EXISTS (SELECT 1 FROM prod.po_headers hx WHERE hx.po_header_id = pd.po_header_id AND hx.status = 'Finally Closed')
          GROUP BY k.cost_center_code, k.account_code, h.order_number, pl.line, pl.item_description, pd.funds_status, pd.po_distribution_id)
        ORDER BY open_amt DESC NULLS LAST FETCH FIRST 500 ROWS ONLY
      ) LOOP
        l_total := r.tot; l_count := r.cnt;
        APEX_JSON.open_object; APEX_JSON.write('costCenter',r.cost_center_code); APEX_JSON.write('account',r.account_code);
        APEX_JSON.write('po',NVL(TO_CHAR(r.order_number),'')); APEX_JSON.write('line',NVL(TO_CHAR(r.po_line),''));
        APEX_JSON.write('description',NVL(r.item_description,'')); APEX_JSON.write('status',NVL(r.po_status,''));
        APEX_JSON.write('ordered',r.ordered); APEX_JSON.write('grn',r.grn); APEX_JSON.write('amount',r.open_amt); APEX_JSON.close_object;
      END LOOP;
      APEX_JSON.close_array;

    ELSIF l_metric IN ('commitment','opencommitment','commitmentpipeline') THEN
      APEX_JSON.open_array('columns'); col('costCenter','Cost centre','text'); col('account','Account','text'); col('pr','PR #','text'); col('description','Description','text'); col('requester','Requester','text'); col('status','Funds status','text'); col('amount','Amount (AED)','money'); APEX_JSON.close_array;
      APEX_JSON.open_array('rows');
      FOR r IN (
        WITH kys AS (SELECT p.cc_string, p.cost_center_code, p.account_code FROM prod.dct_budget_actual_period_v p
                     WHERE p.period_name=l_period
                       AND (l_sector IS NULL OR INSTR('|'||l_sector||'|','|'||p.sector_code||'|')>0)
                       AND (l_chap   IS NULL OR INSTR('|'||l_chap||'|','|'||p.chapter_code||'|')>0)
                       AND (l_prog   IS NULL OR INSTR('|'||l_prog||'|','|'||p.program_class_code||'|')>0)
                       AND (l_appr   IS NULL OR INSTR('|'||l_appr||'|','|'||p.appropriation_code||'|')>0)
                       AND (l_acct   IS NULL OR INSTR('|'||l_acct||'|','|'||p.account_code||'|')>0)
                       AND (l_ccf    IS NULL OR INSTR('|'||l_ccf||'|','|'||p.cost_center_code||'|')>0)
                       AND (l_atype  IS NULL OR INSTR('|'||l_atype||'|','|'||SUBSTR(p.account_code,1,1)||'|')>0)
                       AND (l_search IS NULL OR UPPER(p.cc_string||' '||p.cost_center_desc||' '||p.account_desc||' '||p.appropriation_desc) LIKE '%'||UPPER(l_search)||'%'))
        SELECT cost_center_code, account_code, pr_number, description, requester, funds_status, amt,
               SUM(amt) OVER () tot, COUNT(*) OVER () cnt FROM (
          SELECT k.cost_center_code, k.account_code, h.pr_number, h.description, d.requester, d.funds_status,
                 SUM(d.distribution_amount*NVL(c.exchange_rate_to_aed,1)) amt
          FROM prod.pr_distributions d
          JOIN kys k ON k.cc_string = prod.dct_cc_canon(d.charge_account)
          JOIN prod.pr_headers h ON h.pr_header_id = d.pr_header_id
          LEFT JOIN prod.dct_currency_codes c ON c.currency_code = d.currency_code
          WHERE (d.budget_date IS NULL OR d.budget_date < l_pnext)
            AND ( (l_metric='commitment'         AND d.funds_status IN ('Reserved','Liquidated'))
               OR (l_metric='opencommitment'     AND d.funds_status = 'Reserved')
               OR (l_metric='commitmentpipeline' AND d.funds_status = 'Not reserved') )
          GROUP BY k.cost_center_code, k.account_code, h.pr_number, h.description, d.requester, d.funds_status)
        ORDER BY amt DESC NULLS LAST FETCH FIRST 500 ROWS ONLY
      ) LOOP
        l_total := r.tot; l_count := r.cnt;
        APEX_JSON.open_object; APEX_JSON.write('costCenter',r.cost_center_code); APEX_JSON.write('account',r.account_code);
        APEX_JSON.write('pr',NVL(TO_CHAR(r.pr_number),'')); APEX_JSON.write('description',NVL(r.description,'')); APEX_JSON.write('requester',NVL(r.requester,''));
        APEX_JSON.write('status',NVL(r.funds_status,'')); APEX_JSON.write('amount',r.amt); APEX_JSON.close_object;
      END LOOP;
      APEX_JSON.close_array;

    ELSE
      dct_rest.err(400,'Unknown metric'); RETURN;
    END IF;
    APEX_JSON.write('count', l_count);
    APEX_JSON.write('total', l_total);
    APEX_JSON.close_object;
    RETURN;
  END IF;
!')
    || q'!

  IF l_metric = 'budget' THEN
    APEX_JSON.open_array('columns'); col('period','Period','text'); col('initial','Initial budget','money'); col('adjustments','Adjustments','money'); col('amount','Total budget','money'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT g.period_name, SUM(g.initial_budget) ib, SUM(g.budget_adjustments) adj, SUM(g.total_budget) tb
              FROM prod.gl_balances_cc g WHERE g.cc_string = l_cc
                AND TO_DATE(g.period_name,'MM-YYYY') BETWEEN l_ystart AND l_pstart
              GROUP BY g.period_name ORDER BY TO_DATE(g.period_name,'MM-YYYY')) LOOP
      APEX_JSON.open_object; APEX_JSON.write('period',r.period_name); APEX_JSON.write('initial',r.ib); APEX_JSON.write('adjustments',r.adj); APEX_JSON.write('amount',r.tb); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(g.total_budget),0) INTO l_total FROM prod.gl_balances_cc g WHERE g.cc_string = l_cc AND TO_DATE(g.period_name,'MM-YYYY') BETWEEN l_ystart AND l_pstart;

  ELSIF l_metric = 'encumbrance' THEN
    APEX_JSON.open_array('columns'); col('period','Period','text'); col('commitments','Commitments','money'); col('obligations','Obligations','money'); col('other','Other','money'); col('amount','Encumbrance','money'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT g.period_name, SUM(NVL(g.commitments,0)) c, SUM(NVL(g.obligations,0)) o, SUM(NVL(g.other_encumbrances,0)) oe
              FROM prod.gl_balances_cc g WHERE g.cc_string = l_cc
                AND TO_DATE(g.period_name,'MM-YYYY') BETWEEN l_ystart AND l_pstart
              GROUP BY g.period_name ORDER BY TO_DATE(g.period_name,'MM-YYYY')) LOOP
      APEX_JSON.open_object; APEX_JSON.write('period',r.period_name); APEX_JSON.write('commitments',r.c); APEX_JSON.write('obligations',r.o); APEX_JSON.write('other',r.oe); APEX_JSON.write('amount',r.c+r.o+r.oe); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(NVL(g.commitments,0)+NVL(g.obligations,0)+NVL(g.other_encumbrances,0)),0) INTO l_total FROM prod.gl_balances_cc g WHERE g.cc_string = l_cc AND TO_DATE(g.period_name,'MM-YYYY') BETWEEN l_ystart AND l_pstart;

  ELSIF l_metric = 'glactual' THEN
    APEX_JSON.open_array('columns'); col('period','Period','text'); col('amount','Actual expenditure','money'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT g.period_name, SUM(g.expenditures) e
              FROM prod.gl_balances_cc g WHERE g.cc_string = l_cc
                AND TO_DATE(g.period_name,'MM-YYYY') BETWEEN l_ystart AND l_pstart
              GROUP BY g.period_name ORDER BY TO_DATE(g.period_name,'MM-YYYY')) LOOP
      APEX_JSON.open_object; APEX_JSON.write('period',r.period_name); APEX_JSON.write('amount',r.e); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(g.expenditures),0) INTO l_total FROM prod.gl_balances_cc g WHERE g.cc_string = l_cc AND TO_DATE(g.period_name,'MM-YYYY') BETWEEN l_ystart AND l_pstart;

  ELSIF l_metric = 'grn' THEN
    APEX_JSON.open_array('columns'); col('receipt','GRN #','text'); col('line','Line','text'); col('date','Date','date'); col('supplier','Supplier','text'); col('currency','Cur','text'); col('rate','Rate','num'); col('amount','Amount (AED)','money'); col('type','Type','text'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT * FROM (
              SELECT g.receipt_number, g.receipt_line_number line_no, TO_CHAR(g.transaction_date,'YYYY-MM-DD') td, h.supplier_name,
                     g.currency_code, g.conversion_rate, g.ledger_amount aed, g.transaction_type
              FROM prod.grn_all_v2 g JOIN prod.po_distributions pod ON pod.po_distribution_id = g.po_distribution_id
              LEFT JOIN prod.po_headers h ON h.po_header_id = g.po_header_id
              WHERE prod.dct_cc_canon(pod.charge_account) = l_cc AND g.transaction_date >= l_ystart AND g.transaction_date < l_pnext
              ORDER BY g.transaction_date DESC FETCH FIRST 500 ROWS ONLY
              ) ORDER BY receipt_number, line_no) LOOP
      APEX_JSON.open_object; APEX_JSON.write('receipt',r.receipt_number); APEX_JSON.write('line',NVL(TO_CHAR(r.line_no),'')); APEX_JSON.write('date',NVL(r.td,'')); APEX_JSON.write('supplier',NVL(r.supplier_name,''));
      APEX_JSON.write('currency',NVL(r.currency_code,'AED')); APEX_JSON.write('rate',NVL(r.conversion_rate,1)); APEX_JSON.write('amount',r.aed); APEX_JSON.write('type',NVL(r.transaction_type,'')); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(g.ledger_amount),0) INTO l_total FROM prod.grn_all_v2 g JOIN prod.po_distributions pod ON pod.po_distribution_id = g.po_distribution_id WHERE prod.dct_cc_canon(pod.charge_account) = l_cc AND g.transaction_date >= l_ystart AND g.transaction_date < l_pnext;

  ELSIF l_metric = 'apdirect' THEN
    APEX_JSON.open_array('columns'); col('invoice','Invoice #','text'); col('line','Line','text'); col('date','Acct date','date'); col('description','Description','text'); col('orig','Amount (orig)','money'); col('amount','Amount (AED)','money'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT NVL(i.invoice_number,'#'||TO_CHAR(d.invoice_id)) inv_no, d.line_number line_no,
                     TO_CHAR(d.accounting_date,'YYYY-MM-DD') ad, d.distribution_description descr,
                     d.distribution_amount amt, NVL(d.distribution_amount_functi,d.distribution_amount) aed
              FROM prod.ap_invoice_distributions d
              LEFT JOIN (SELECT invoice_id, MAX(invoice_number) invoice_number FROM prod.ap_invoices GROUP BY invoice_id) i
                     ON i.invoice_id = d.invoice_id
              JOIN prod.dct_gl_coa_snap cid ON cid.cc_id = d.cc_id
              WHERE cid.cc_string = l_cc AND d.po_number IS NULL AND NVL(d.reversal_indicator,'N') <> 'Y'
                AND NVL(NVL(d.distribution_amount_functi,d.distribution_amount),0) <> 0
                AND d.accounting_date >= l_ystart AND d.accounting_date < l_pnext
              ORDER BY d.accounting_date DESC FETCH FIRST 500 ROWS ONLY) LOOP
      APEX_JSON.open_object; APEX_JSON.write('invoice',NVL(r.inv_no,'')); APEX_JSON.write('line',NVL(TO_CHAR(r.line_no),'')); APEX_JSON.write('date',NVL(r.ad,'')); APEX_JSON.write('description',NVL(r.descr,'')); APEX_JSON.write('orig',r.amt); APEX_JSON.write('amount',r.aed); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(NVL(d.distribution_amount_functi,d.distribution_amount)),0) INTO l_total
      FROM prod.ap_invoice_distributions d
      JOIN prod.dct_gl_coa_snap cid ON cid.cc_id = d.cc_id
      WHERE cid.cc_string = l_cc AND d.po_number IS NULL AND NVL(d.reversal_indicator,'N') <> 'Y'
        AND d.accounting_date >= l_ystart AND d.accounting_date < l_pnext;

  ELSIF l_metric IN ('obligation','popipeline') THEN   -- Total PO (all except Failed/Passed) / PO Pipeline (Failed/Passed)
    APEX_JSON.open_array('columns'); col('po','PO #','text'); col('line','Line','text'); col('description','Item / description','text'); col('supplier','Supplier','text'); col('status','Funds status','text'); col('amount','Ordered (AED)','money'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT order_number, po_line, item_description, supplier_name, po_status, amt FROM (
                SELECT h.order_number, pl.line po_line, pl.item_description, h.supplier_name, pd.funds_status po_status,
                       MAX(pd.distribution_amount*NVL(pd.rate,1)) amt
                FROM prod.po_distributions pd
                JOIN prod.po_headers h ON h.po_header_id = pd.po_header_id
                LEFT JOIN prod.po_lines pl ON pl.po_header_id = pd.po_header_id AND pl.po_line_id = pd.po_line_id
                WHERE prod.dct_cc_canon(pd.charge_account) = l_cc AND (pd.budget_date IS NULL OR pd.budget_date < l_pnext)
                  AND ( (l_metric='obligation' AND NVL(pd.funds_status,'x') NOT IN ('Failed','Passed'))
                     OR (l_metric='popipeline' AND pd.funds_status IN ('Failed','Passed')) )
                GROUP BY h.order_number, pl.line, pl.item_description, h.supplier_name, pd.funds_status, pd.po_distribution_id)
              ORDER BY amt DESC NULLS LAST FETCH FIRST 500 ROWS ONLY) LOOP
      APEX_JSON.open_object; APEX_JSON.write('po',NVL(TO_CHAR(r.order_number),'')); APEX_JSON.write('line',NVL(TO_CHAR(r.po_line),''));
      APEX_JSON.write('description',NVL(r.item_description,'')); APEX_JSON.write('supplier',NVL(r.supplier_name,''));
      APEX_JSON.write('status',NVL(r.po_status,'')); APEX_JSON.write('amount',r.amt); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(amt),0) INTO l_total FROM (
      SELECT MAX(pd.distribution_amount*NVL(pd.rate,1)) amt FROM prod.po_distributions pd
      WHERE prod.dct_cc_canon(pd.charge_account) = l_cc AND (pd.budget_date IS NULL OR pd.budget_date < l_pnext)
        AND ( (l_metric='obligation' AND NVL(pd.funds_status,'x') NOT IN ('Failed','Passed'))
           OR (l_metric='popipeline' AND pd.funds_status IN ('Failed','Passed')) )
      GROUP BY pd.po_distribution_id);

  ELSIF l_metric = 'openobligation' THEN   -- (Reserved + Partially Liquidated) NETTED by GRN received, excl. Finally Closed POs (remainder released)
    APEX_JSON.open_array('columns'); col('po','PO #','text'); col('line','Line','text'); col('description','Item / description','text'); col('status','Funds status','text'); col('ordered','Ordered (AED)','money'); col('grn','Received (AED)','money'); col('amount','Open (AED)','money'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT order_number, po_line, item_description, po_status, ordered, grn, GREATEST(ordered-grn,0) open_amt FROM (
                SELECT h.order_number, pl.line po_line, pl.item_description, pd.funds_status po_status,
                       MAX(pd.distribution_amount*NVL(pd.rate,1)) ordered, NVL(MAX(g.grn),0) grn
                FROM prod.po_distributions pd
                JOIN prod.po_headers h ON h.po_header_id = pd.po_header_id
                LEFT JOIN prod.po_lines pl ON pl.po_header_id = pd.po_header_id AND pl.po_line_id = pd.po_line_id
                LEFT JOIN (SELECT po_distribution_id, SUM(ledger_amount) grn FROM prod.grn_all_v2 GROUP BY po_distribution_id) g
                  ON g.po_distribution_id = pd.po_distribution_id
                WHERE prod.dct_cc_canon(pd.charge_account) = l_cc AND (pd.budget_date IS NULL OR pd.budget_date < l_pnext)
                  AND pd.funds_status IN ('Reserved','Partially Liquidated')
                  AND NOT EXISTS (SELECT 1 FROM prod.po_headers hx
                                  WHERE hx.po_header_id = pd.po_header_id AND hx.status = 'Finally Closed')
                GROUP BY h.order_number, pl.line, pl.item_description, pd.funds_status, pd.po_distribution_id)
              ORDER BY open_amt DESC NULLS LAST FETCH FIRST 500 ROWS ONLY) LOOP
      APEX_JSON.open_object; APEX_JSON.write('po',NVL(TO_CHAR(r.order_number),'')); APEX_JSON.write('line',NVL(TO_CHAR(r.po_line),''));
      APEX_JSON.write('description',NVL(r.item_description,'')); APEX_JSON.write('status',NVL(r.po_status,''));
      APEX_JSON.write('ordered',r.ordered); APEX_JSON.write('grn',r.grn); APEX_JSON.write('amount',r.open_amt); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(GREATEST(ordered-grn,0)),0) INTO l_total FROM (
      SELECT MAX(pd.distribution_amount*NVL(pd.rate,1)) ordered, NVL(MAX(g.grn),0) grn
      FROM prod.po_distributions pd
      LEFT JOIN (SELECT po_distribution_id, SUM(ledger_amount) grn FROM prod.grn_all_v2 GROUP BY po_distribution_id) g
        ON g.po_distribution_id = pd.po_distribution_id
      WHERE prod.dct_cc_canon(pd.charge_account) = l_cc AND (pd.budget_date IS NULL OR pd.budget_date < l_pnext)
        AND pd.funds_status IN ('Reserved','Partially Liquidated')
        AND NOT EXISTS (SELECT 1 FROM prod.po_headers hx
                        WHERE hx.po_header_id = pd.po_header_id AND hx.status = 'Finally Closed')
      GROUP BY pd.po_distribution_id);

  ELSIF l_metric IN ('commitment','opencommitment','commitmentpipeline') THEN   -- PR drills (real requisitions, db/v2/36)
    APEX_JSON.open_array('columns'); col('pr','PR #','text'); col('description','Description','text'); col('requester','Requester','text'); col('status','Funds status','text'); col('amount','Amount (AED)','money'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT h.pr_number, h.description, d.requester, d.funds_status,
                     SUM(d.distribution_amount*NVL(c.exchange_rate_to_aed,1)) amt
              FROM prod.pr_distributions d
              JOIN prod.pr_headers h ON h.pr_header_id = d.pr_header_id
              LEFT JOIN prod.dct_currency_codes c ON c.currency_code = d.currency_code
              WHERE prod.dct_cc_canon(d.charge_account) = l_cc AND (d.budget_date IS NULL OR d.budget_date < l_pnext)
                AND ( (l_metric='commitment'         AND d.funds_status IN ('Reserved','Liquidated'))
                   OR (l_metric='opencommitment'     AND d.funds_status = 'Reserved')
                   OR (l_metric='commitmentpipeline' AND d.funds_status = 'Not reserved') )
              GROUP BY h.pr_number, h.description, d.requester, d.funds_status
              ORDER BY amt DESC NULLS LAST FETCH FIRST 500 ROWS ONLY) LOOP
      APEX_JSON.open_object; APEX_JSON.write('pr',NVL(TO_CHAR(r.pr_number),''));
      APEX_JSON.write('description',NVL(r.description,'')); APEX_JSON.write('requester',NVL(r.requester,''));
      APEX_JSON.write('status',NVL(r.funds_status,'')); APEX_JSON.write('amount',r.amt); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(d.distribution_amount*NVL(c.exchange_rate_to_aed,1)),0) INTO l_total
      FROM prod.pr_distributions d
      LEFT JOIN prod.dct_currency_codes c ON c.currency_code = d.currency_code
      WHERE prod.dct_cc_canon(d.charge_account) = l_cc AND (d.budget_date IS NULL OR d.budget_date < l_pnext)
        AND ( (l_metric='commitment'         AND d.funds_status IN ('Reserved','Liquidated'))
           OR (l_metric='opencommitment'     AND d.funds_status = 'Reserved')
           OR (l_metric='commitmentpipeline' AND d.funds_status = 'Not reserved') );

  ELSE
    dct_rest.err(400,'Unknown metric'); RETURN;
  END IF;

  APEX_JSON.write('total', l_total);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- DASHBOARD -- executive analytics for one period (YTD): KPIs + by Sector /
    -- DCT Program / Appropriation (budget, actual, PO count & total) + a
    -- period-over-period actual trend.
    --   GET /gl/dashboard?period=
    -- =========================================================================
    def_template('dashboard');
    def_handler('dashboard', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_period VARCHAR2(7)   := [COLON]period;
  l_pstart DATE; l_pnext DATE; l_ystart DATE;
  t_bud NUMBER; t_enc NUMBER; t_act NUMBER; t_fun NUMBER; t_grn NUMBER; t_apd NUMBER; t_cmb NUMBER;
  t_pocnt NUMBER; t_pototal NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_period IS NULL THEN
    SELECT NVL(MAX(CASE WHEN period_name = TO_CHAR(SYSDATE,'MM-YYYY') THEN period_name END),
               MAX(period_name) KEEP (DENSE_RANK LAST ORDER BY TO_DATE(period_name,'MM-YYYY')))
      INTO l_period FROM prod.gl_balances WHERE period_name IS NOT NULL;
  END IF;
  l_pstart := TO_DATE(l_period,'MM-YYYY'); l_pnext := ADD_MONTHS(l_pstart,1); l_ystart := TRUNC(l_pstart,'YEAR');

  SELECT NVL(SUM(budget_ytd),0), NVL(SUM(encumbrance_ytd),0), NVL(SUM(gl_actual_ytd),0),
         NVL(SUM(funds_available_ytd),0), NVL(SUM(grn_actual_ytd),0), NVL(SUM(ap_direct_actual_ytd),0), COUNT(*)
    INTO t_bud, t_enc, t_act, t_fun, t_grn, t_apd, t_cmb
    FROM prod.dct_budget_actual_period_v WHERE period_name = l_period;
  SELECT NVL(COUNT(DISTINCT h.order_number),0), NVL(SUM(pd.distribution_amount*NVL(pd.rate,1)),0)
    INTO t_pocnt, t_pototal
    FROM prod.po_distributions pd JOIN prod.po_headers h ON h.po_header_id = pd.po_header_id
    WHERE pd.budget_date IS NULL OR pd.budget_date < l_pnext;

  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('period', l_period);
  APEX_JSON.open_object('kpis');
  APEX_JSON.write('budget', t_bud); APEX_JSON.write('encumbrance', t_enc); APEX_JSON.write('actual', t_act);
  APEX_JSON.write('fundsAvailable', t_fun); APEX_JSON.write('grn', t_grn); APEX_JSON.write('apDirect', t_apd);
  APEX_JSON.write('combos', t_cmb); APEX_JSON.write('poCount', t_pocnt); APEX_JSON.write('poTotal', t_pototal);
  APEX_JSON.write('utilizationPct', CASE WHEN t_bud>0 THEN ROUND(t_act*100/t_bud,1) ELSE 0 END);
  APEX_JSON.write('commitmentPct', CASE WHEN t_bud>0 THEN ROUND(t_enc*100/t_bud,1) ELSE 0 END);
  APEX_JSON.close_object;

  -- by SECTOR (top 8 by actual)
  APEX_JSON.open_array('bySector');
  FOR r IN (
    WITH gl AS (SELECT s.sector_code, SUM(g.total_budget) bud, SUM(g.expenditures) act
                FROM prod.gl_balances_cc g JOIN prod.dct_gl_coa_snap s ON s.cc_string = g.cc_string
                WHERE TO_DATE(g.period_name,'MM-YYYY') BETWEEN l_ystart AND l_pstart AND s.sector_code IS NOT NULL
                GROUP BY s.sector_code),
         po AS (SELECT s.sector_code, COUNT(DISTINCT h.order_number) pc, SUM(pd.distribution_amount*NVL(pd.rate,1)) pt
                FROM prod.po_distributions pd JOIN prod.po_headers h ON h.po_header_id=pd.po_header_id
                JOIN prod.dct_gl_coa_snap s ON s.cc_string = prod.dct_cc_canon(pd.charge_account)
                WHERE (pd.budget_date IS NULL OR pd.budget_date < l_pnext) AND s.sector_code IS NOT NULL
                GROUP BY s.sector_code),
         dim AS (SELECT sector_code, MAX(sector_name) nm FROM prod.dct_gl_coa_snap WHERE sector_code IS NOT NULL GROUP BY sector_code)
    SELECT d.sector_code code, d.nm name, NVL(gl.bud,0) bud, NVL(gl.act,0) act, NVL(po.pc,0) pc, NVL(po.pt,0) pt
    FROM dim d LEFT JOIN gl ON gl.sector_code=d.sector_code LEFT JOIN po ON po.sector_code=d.sector_code
    ORDER BY NVL(gl.act,0) DESC, NVL(po.pt,0) DESC FETCH FIRST 8 ROWS ONLY) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code',r.code); APEX_JSON.write('name',r.name);
    APEX_JSON.write('budget',r.bud); APEX_JSON.write('actual',r.act); APEX_JSON.write('poCount',r.pc); APEX_JSON.write('poTotal',r.pt); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  -- by DCT PROGRAM (top 8 by actual)
  APEX_JSON.open_array('byProgram');
  FOR r IN (
    WITH gl AS (SELECT s.program_class_code code, SUM(g.total_budget) bud, SUM(g.expenditures) act
                FROM prod.gl_balances_cc g JOIN prod.dct_gl_coa_snap s ON s.cc_string = g.cc_string
                WHERE TO_DATE(g.period_name,'MM-YYYY') BETWEEN l_ystart AND l_pstart AND s.program_class_code IS NOT NULL
                GROUP BY s.program_class_code),
         po AS (SELECT s.program_class_code code, COUNT(DISTINCT h.order_number) pc, SUM(pd.distribution_amount*NVL(pd.rate,1)) pt
                FROM prod.po_distributions pd JOIN prod.po_headers h ON h.po_header_id=pd.po_header_id
                JOIN prod.dct_gl_coa_snap s ON s.cc_string = prod.dct_cc_canon(pd.charge_account)
                WHERE (pd.budget_date IS NULL OR pd.budget_date < l_pnext) AND s.program_class_code IS NOT NULL
                GROUP BY s.program_class_code),
         dim AS (SELECT program_class_code code, MAX(program_name) nm FROM prod.dct_gl_coa_snap WHERE program_class_code IS NOT NULL GROUP BY program_class_code)
    SELECT d.code code, d.nm name, NVL(gl.bud,0) bud, NVL(gl.act,0) act, NVL(po.pc,0) pc, NVL(po.pt,0) pt
    FROM dim d LEFT JOIN gl ON gl.code=d.code LEFT JOIN po ON po.code=d.code
    ORDER BY NVL(gl.act,0) DESC, NVL(po.pt,0) DESC FETCH FIRST 8 ROWS ONLY) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code',r.code); APEX_JSON.write('name',r.name);
    APEX_JSON.write('budget',r.bud); APEX_JSON.write('actual',r.act); APEX_JSON.write('poCount',r.pc); APEX_JSON.write('poTotal',r.pt); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  -- by APPROPRIATION (top 8 by PO total)
  APEX_JSON.open_array('byAppropriation');
  FOR r IN (
    WITH gl AS (SELECT s.appropriation_code code, SUM(g.total_budget) bud, SUM(g.expenditures) act
                FROM prod.gl_balances_cc g JOIN prod.dct_gl_coa_snap s ON s.cc_string = g.cc_string
                WHERE TO_DATE(g.period_name,'MM-YYYY') BETWEEN l_ystart AND l_pstart AND s.appropriation_code IS NOT NULL
                GROUP BY s.appropriation_code),
         po AS (SELECT s.appropriation_code code, COUNT(DISTINCT h.order_number) pc, SUM(pd.distribution_amount*NVL(pd.rate,1)) pt
                FROM prod.po_distributions pd JOIN prod.po_headers h ON h.po_header_id=pd.po_header_id
                JOIN prod.dct_gl_coa_snap s ON s.cc_string = prod.dct_cc_canon(pd.charge_account)
                WHERE (pd.budget_date IS NULL OR pd.budget_date < l_pnext) AND s.appropriation_code IS NOT NULL
                GROUP BY s.appropriation_code),
         dim AS (SELECT appropriation_code code, MAX(appropriation_desc) nm FROM prod.dct_gl_coa_snap WHERE appropriation_code IS NOT NULL GROUP BY appropriation_code)
    SELECT d.code code, d.nm name, NVL(gl.bud,0) bud, NVL(gl.act,0) act, NVL(po.pc,0) pc, NVL(po.pt,0) pt
    FROM dim d LEFT JOIN gl ON gl.code=d.code LEFT JOIN po ON po.code=d.code
    ORDER BY NVL(po.pt,0) DESC, NVL(gl.act,0) DESC FETCH FIRST 8 ROWS ONLY) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code',r.code); APEX_JSON.write('name',NVL(r.name,r.code));
    APEX_JSON.write('budget',r.bud); APEX_JSON.write('actual',r.act); APEX_JSON.write('poCount',r.pc); APEX_JSON.write('poTotal',r.pt); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  -- period-over-period trend (all periods)
  APEX_JSON.open_array('trend');
  FOR r IN (SELECT period_name, NVL(SUM(budget_ytd),0) bud, NVL(SUM(gl_actual_ytd),0) act, NVL(SUM(grn_actual_ytd),0) grn
            FROM prod.dct_budget_actual_period_v GROUP BY period_name ORDER BY TO_DATE(period_name,'MM-YYYY')) LOOP
    APEX_JSON.open_object; APEX_JSON.write('period',r.period_name); APEX_JSON.write('budget',r.bud); APEX_JSON.write('actual',r.act); APEX_JSON.write('grn',r.grn); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- REFRESH -- rebuild the COA snapshot the actuals layer reads from.
    --   POST /gl/actuals/refresh  (also scheduled hourly, db/v2/35)
    -- =========================================================================
    def_template('actuals/refresh');
    def_handler('actuals/refresh', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_actuals_refresh;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('ok', 1);
  APEX_JSON.write('refreshedAt', TO_CHAR(dct_to_local(SYSTIMESTAMP),'YYYY-MM-DD HH:MI AM'));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_gl_ords_tmp;
/

BEGIN
    setup_gl_ords_tmp;
END;
/

DROP PROCEDURE setup_gl_ords_tmp;

PROMPT gl.rest ORDS module published at /ords/admin/gl/
