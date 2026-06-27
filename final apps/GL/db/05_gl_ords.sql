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
    --   GET /gl/mappings?type=&segment=
    -- =========================================================================
    def_template('mappings');
    def_handler('mappings', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_type VARCHAR2(30)  := UPPER([COLON]type);
  l_seg  VARCHAR2(60)  := [COLON]segment;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (
    SELECT m.map_id, m.class_type_code, m.segment_value, m.class_value_id,
           v.value_code, v.name_en, m.notes,
           TO_CHAR(m.start_date,'YYYY-MM-DD') start_d,
           TO_CHAR(m.end_date,'YYYY-MM-DD')   end_d,
           CASE WHEN TRUNC(SYSDATE) BETWEEN m.start_date AND NVL(m.end_date, DATE '4000-01-01')
                THEN 'Y' ELSE 'N' END is_current
    FROM dct_gl_seg_class_map m JOIN dct_gl_class_value v ON v.class_value_id=m.class_value_id
    WHERE (l_type IS NULL OR m.class_type_code=l_type)
      AND (l_seg  IS NULL OR m.segment_value=l_seg)
    ORDER BY m.class_type_code, m.segment_value, m.start_date DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('mapId', r.map_id); APEX_JSON.write('type', r.class_type_code);
    APEX_JSON.write('segmentValue', r.segment_value); APEX_JSON.write('classValueId', r.class_value_id);
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

    COMMIT;
END setup_gl_ords_tmp;
/

BEGIN
    setup_gl_ords_tmp;
END;
/

DROP PROCEDURE setup_gl_ords_tmp;

PROMPT gl.rest ORDS module published at /ords/admin/gl/
