-- =============================================================================
-- Finance KPI Management Module (App 213) -- ORDS REST API (kpi.rest)
-- File    : 06_kpi_ords.sql
-- Schema  : registered under ADMIN (the only REST-routable schema on ADB)
-- Base URL: /ords/admin/kpi/
-- Run     : sql -name prod_mcp @06_kpi_ords.sql   (FRESH session -- synonym rule:
--           do NOT run after ALTER SESSION SET CURRENT_SCHEMA=PROD or the ADMIN
--           synonyms self-reference, ORA-01471)
-- Notes   : Thin handlers over DCT_KPI_PKG + dct_kpi_*_v views. validate_session
--           on every route (the db/v2/50 gate maps segment kpi -> KPI_MGMT).
--           Pagination envelope {items,total,limit,offset}. Error mapping:
--           -20401->401 -20403->403 -20404->404 -20001/-20090->400 else 500.
--           Worklist/actions are NOT here -- the shared /wf/ API serves them.
--           Report bridge enqueues KPI_BRIEFING_BOOK as the calling user.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

-- =============================================================================
-- 1. ADMIN synonyms for every PROD object the handlers touch
-- =============================================================================
CREATE OR REPLACE SYNONYM dct_kpi_pkg             FOR prod.dct_kpi_pkg;
CREATE OR REPLACE SYNONYM dct_kpi_definitions     FOR prod.dct_kpi_definitions;
CREATE OR REPLACE SYNONYM dct_kpi_score_bands     FOR prod.dct_kpi_score_bands;
CREATE OR REPLACE SYNONYM dct_kpi_criteria        FOR prod.dct_kpi_criteria;
CREATE OR REPLACE SYNONYM dct_kpi_criteria_levels FOR prod.dct_kpi_criteria_levels;
CREATE OR REPLACE SYNONYM dct_kpi_targets         FOR prod.dct_kpi_targets;
CREATE OR REPLACE SYNONYM dct_kpi_periods         FOR prod.dct_kpi_periods;
CREATE OR REPLACE SYNONYM dct_kpi_results         FOR prod.dct_kpi_results;
CREATE OR REPLACE SYNONYM dct_kpi_result_criteria FOR prod.dct_kpi_result_criteria;
CREATE OR REPLACE SYNONYM dct_kpi_sources         FOR prod.dct_kpi_sources;
CREATE OR REPLACE SYNONYM dct_kpi_definition_v    FOR prod.dct_kpi_definition_v;
CREATE OR REPLACE SYNONYM dct_kpi_result_v        FOR prod.dct_kpi_result_v;
CREATE OR REPLACE SYNONYM dct_kpi_result_crit_v   FOR prod.dct_kpi_result_crit_v;
CREATE OR REPLACE SYNONYM dct_kpi_scorecard_v     FOR prod.dct_kpi_scorecard_v;
CREATE OR REPLACE SYNONYM dct_rpt_pkg             FOR prod.dct_rpt_pkg;
CREATE OR REPLACE SYNONYM dct_rpt_run             FOR prod.dct_rpt_run;
CREATE OR REPLACE SYNONYM dct_rpt_output          FOR prod.dct_rpt_output;
-- shared objects (dct_rest, dct_auth, dct_users, dct_documents,
-- dct_document_types, dct_lookup_categories/values, dct_modules,
-- dct_module_settings, dct_to_local) already have ADMIN synonyms.

-- =============================================================================
-- 2. Module + handlers (wrapped in DDL so SQLcl skips bind scanning)
-- =============================================================================
CREATE OR REPLACE PROCEDURE setup_kpi_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'kpi.rest';

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

    PROCEDURE def_media(p_pattern VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => 'GET',
            p_source_type => ORDS.source_type_media,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

BEGIN

    BEGIN
        ORDS.DELETE_MODULE(p_module_name => c_mod);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    ORDS.DEFINE_MODULE(
        p_module_name    => c_mod,
        p_base_path      => '/kpi/',
        p_items_per_page => 100,
        p_status         => 'PUBLISHED',
        p_comments       => 'i-Finance -- Finance KPI Management REST API (App 213)');

    -- =========================================================================
    -- BOOT -- identity flags + lookups + sources for the UI
    -- =========================================================================
    def_template('boot');
    def_handler('boot', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_max  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  BEGIN
    SELECT TO_NUMBER(ms.setting_value DEFAULT NULL ON CONVERSION ERROR) INTO l_max
    FROM dct_module_settings ms JOIN dct_modules m ON m.module_id = ms.module_id
    WHERE m.module_code='KPI_MGMT' AND ms.setting_key='MAX_UPLOAD_MB';
  EXCEPTION WHEN NO_DATA_FOUND THEN l_max := NULL; END;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('userId', l_uid);
  APEX_JSON.write('isKpiAdmin', dct_kpi_pkg.is_admin(l_uid));
  APEX_JSON.write('isApprover', dct_auth.has_role(l_user,'KPI_FIN_DIRECTOR') OR dct_auth.has_role(l_user,'SYS_ADMIN'));
  APEX_JSON.write('maxUploadMb', NVL(l_max,10));
  APEX_JSON.open_array('lookups');
  FOR r IN (
    SELECT c.category_code, v.value_code, v.value_name_en, v.value_name_ar, v.display_order
    FROM dct_lookup_values v JOIN dct_lookup_categories c ON c.category_id = v.category_id
    WHERE c.category_code LIKE 'KPI\_%' ESCAPE '\' AND v.is_active = 'Y'
    ORDER BY c.category_code, v.display_order
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('category', r.category_code);
    APEX_JSON.write('code',     r.value_code);
    APEX_JSON.write('nameEn',   r.value_name_en);
    APEX_JSON.write('nameAr',   NVL(r.value_name_ar,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('sources');
  FOR r IN (SELECT source_code, name_en, name_ar, description_en, is_active
            FROM dct_kpi_sources ORDER BY source_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.source_code);
    APEX_JSON.write('nameEn', r.name_en);
    APEX_JSON.write('nameAr', NVL(r.name_ar,''));
    APEX_JSON.write('descriptionEn', NVL(r.description_en,''));
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- USERS -- picker
    -- =========================================================================
    def_template('users');
    def_handler('users', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_search VARCHAR2(200) := [COLON]search;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT user_id, username, display_name FROM dct_users
            WHERE is_active='Y'
              AND (l_search IS NULL OR UPPER(display_name||' '||username) LIKE '%'||UPPER(l_search)||'%')
            ORDER BY display_name FETCH FIRST 50 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('userId', r.user_id);
    APEX_JSON.write('username', r.username);
    APEX_JSON.write('displayName', NVL(r.display_name, r.username));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- KPI REGISTRY
    -- =========================================================================
    def_template('kpis');
    def_handler('kpis', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_all  VARCHAR2(1) := UPPER([COLON]all);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_kpi_definition_v
            WHERE (NVL(l_all,'N')='Y' OR is_active='Y')
            ORDER BY display_order, kpi_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('kpiId', r.kpi_id); APEX_JSON.write('code', r.kpi_code);
    APEX_JSON.write('nameEn', r.name_en); APEX_JSON.write('nameAr', NVL(r.name_ar,''));
    APEX_JSON.write('descriptionEn', NVL(r.description_en,'')); APEX_JSON.write('descriptionAr', NVL(r.description_ar,''));
    APEX_JSON.write('type', r.kpi_type); APEX_JSON.write('polarity', r.polarity);
    APEX_JSON.write('unitEn', NVL(r.unit_en,'')); APEX_JSON.write('unitAr', NVL(r.unit_ar,''));
    APEX_JSON.write('frequency', r.frequency); APEX_JSON.write('calcMethod', r.calc_method);
    APEX_JSON.write('weight', r.scorecard_weight_pct);
    APEX_JSON.write('requiresEvidence', r.requires_evidence);
    APEX_JSON.write('bandCount', r.band_count); APEX_JSON.write('criteriaCount', r.criteria_count);
    APEX_JSON.write('criteriaWeightSum', r.criteria_weight_sum);
    APEX_JSON.write('currentYearTarget', r.current_year_target);
    APEX_JSON.write('currentYearTargetLabel', NVL(r.current_year_target_label,''));
    APEX_JSON.write('displayOrder', r.display_order); APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('kpis', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_id := APEX_JSON.get_number(p_path=>'kpiId');
  dct_kpi_pkg.save_kpi(
    p_user_id => l_uid, p_kpi_id => l_id,
    p_kpi_code => APEX_JSON.get_varchar2(p_path=>'code'),
    p_name_en => APEX_JSON.get_varchar2(p_path=>'nameEn'),
    p_name_ar => APEX_JSON.get_varchar2(p_path=>'nameAr'),
    p_description_en => APEX_JSON.get_varchar2(p_path=>'descriptionEn'),
    p_description_ar => APEX_JSON.get_varchar2(p_path=>'descriptionAr'),
    p_kpi_type => NVL(APEX_JSON.get_varchar2(p_path=>'type'),'STRATEGIC'),
    p_polarity => NVL(APEX_JSON.get_varchar2(p_path=>'polarity'),'ASCENDING'),
    p_unit_en => APEX_JSON.get_varchar2(p_path=>'unitEn'),
    p_unit_ar => APEX_JSON.get_varchar2(p_path=>'unitAr'),
    p_frequency => APEX_JSON.get_varchar2(p_path=>'frequency'),
    p_calc_method => APEX_JSON.get_varchar2(p_path=>'calcMethod'),
    p_calc_desc_en => APEX_JSON.get_varchar2(p_path=>'calcDescEn'),
    p_calc_desc_ar => APEX_JSON.get_varchar2(p_path=>'calcDescAr'),
    p_source_of_data_en => APEX_JSON.get_varchar2(p_path=>'sourceOfDataEn'),
    p_source_of_data_ar => APEX_JSON.get_varchar2(p_path=>'sourceOfDataAr'),
    p_kpi_owner_en => APEX_JSON.get_varchar2(p_path=>'ownerEn'),
    p_kpi_owner_ar => APEX_JSON.get_varchar2(p_path=>'ownerAr'),
    p_note_en => APEX_JSON.get_varchar2(p_path=>'noteEn'),
    p_note_ar => APEX_JSON.get_varchar2(p_path=>'noteAr'),
    p_source_code_a => APEX_JSON.get_varchar2(p_path=>'sourceCodeA'),
    p_source_code_b => APEX_JSON.get_varchar2(p_path=>'sourceCodeB'),
    p_figure_a_label_en => APEX_JSON.get_varchar2(p_path=>'figureALabelEn'),
    p_figure_a_label_ar => APEX_JSON.get_varchar2(p_path=>'figureALabelAr'),
    p_figure_b_label_en => APEX_JSON.get_varchar2(p_path=>'figureBLabelEn'),
    p_figure_b_label_ar => APEX_JSON.get_varchar2(p_path=>'figureBLabelAr'),
    p_scorecard_weight_pct => APEX_JSON.get_number(p_path=>'weight'),
    p_requires_evidence => NVL(APEX_JSON.get_varchar2(p_path=>'requiresEvidence'),'N'),
    p_display_order => APEX_JSON.get_number(p_path=>'displayOrder'),
    p_is_active => NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'));
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('kpiId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('kpis/[COLON]id');
    def_handler('kpis/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_found NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_found FROM dct_kpi_definition_v WHERE kpi_id = TO_NUMBER([COLON]id);
  IF l_found = 0 THEN dct_rest.err(404,'KPI not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM dct_kpi_definition_v WHERE kpi_id = TO_NUMBER([COLON]id)) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('kpiId', r.kpi_id); APEX_JSON.write('code', r.kpi_code);
    APEX_JSON.write('nameEn', r.name_en); APEX_JSON.write('nameAr', NVL(r.name_ar,''));
    APEX_JSON.write('descriptionEn', NVL(r.description_en,'')); APEX_JSON.write('descriptionAr', NVL(r.description_ar,''));
    APEX_JSON.write('type', r.kpi_type); APEX_JSON.write('polarity', r.polarity);
    APEX_JSON.write('unitEn', NVL(r.unit_en,'')); APEX_JSON.write('unitAr', NVL(r.unit_ar,''));
    APEX_JSON.write('frequency', r.frequency); APEX_JSON.write('calcMethod', r.calc_method);
    APEX_JSON.write('calcDescEn', NVL(r.calc_desc_en,'')); APEX_JSON.write('calcDescAr', NVL(r.calc_desc_ar,''));
    APEX_JSON.write('sourceOfDataEn', NVL(r.source_of_data_en,'')); APEX_JSON.write('sourceOfDataAr', NVL(r.source_of_data_ar,''));
    APEX_JSON.write('ownerEn', NVL(r.kpi_owner_en,'')); APEX_JSON.write('ownerAr', NVL(r.kpi_owner_ar,''));
    APEX_JSON.write('noteEn', NVL(r.note_en,'')); APEX_JSON.write('noteAr', NVL(r.note_ar,''));
    APEX_JSON.write('sourceCodeA', NVL(r.source_code_a,'')); APEX_JSON.write('sourceCodeB', NVL(r.source_code_b,''));
    APEX_JSON.write('figureALabelEn', NVL(r.figure_a_label_en,'')); APEX_JSON.write('figureALabelAr', NVL(r.figure_a_label_ar,''));
    APEX_JSON.write('figureBLabelEn', NVL(r.figure_b_label_en,'')); APEX_JSON.write('figureBLabelAr', NVL(r.figure_b_label_ar,''));
    APEX_JSON.write('weight', r.scorecard_weight_pct);
    APEX_JSON.write('requiresEvidence', r.requires_evidence);
    APEX_JSON.write('displayOrder', r.display_order); APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.open_array('bands');
    FOR b IN (SELECT * FROM dct_kpi_score_bands WHERE kpi_id = r.kpi_id ORDER BY band_score DESC) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('score', b.band_score); APEX_JSON.write('operator', b.operator);
      APEX_JSON.write('threshold1', b.threshold_1); APEX_JSON.write('threshold2', b.threshold_2);
      APEX_JSON.write('labelEn', NVL(b.label_en,'')); APEX_JSON.write('labelAr', NVL(b.label_ar,''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.open_array('criteria');
    FOR c IN (SELECT * FROM dct_kpi_criteria WHERE kpi_id = r.kpi_id ORDER BY display_order, criterion_id) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('criterionId', c.criterion_id); APEX_JSON.write('code', c.criterion_code);
      APEX_JSON.write('nameEn', c.name_en); APEX_JSON.write('nameAr', NVL(c.name_ar,''));
      APEX_JSON.write('descriptionEn', NVL(c.description_en,'')); APEX_JSON.write('descriptionAr', NVL(c.description_ar,''));
      APEX_JSON.write('weight', c.weight_pct); APEX_JSON.write('entryType', c.entry_type);
      APEX_JSON.write('frequencyNoteEn', NVL(c.frequency_note_en,'')); APEX_JSON.write('frequencyNoteAr', NVL(c.frequency_note_ar,''));
      APEX_JSON.write('displayOrder', c.display_order); APEX_JSON.write('isActive', c.is_active);
      APEX_JSON.open_array('levels');
      FOR l IN (SELECT * FROM dct_kpi_criteria_levels WHERE criterion_id = c.criterion_id ORDER BY level_no) LOOP
        APEX_JSON.open_object;
        APEX_JSON.write('levelNo', l.level_no);
        APEX_JSON.write('titleEn', NVL(l.title_en,'')); APEX_JSON.write('titleAr', NVL(l.title_ar,''));
        APEX_JSON.write('descriptionEn', NVL(l.description_en,'')); APEX_JSON.write('descriptionAr', NVL(l.description_ar,''));
        APEX_JSON.close_object;
      END LOOP;
      APEX_JSON.close_array;
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.open_array('targets');
    FOR t IN (SELECT * FROM dct_kpi_targets WHERE kpi_id = r.kpi_id ORDER BY target_year) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('year', t.target_year); APEX_JSON.write('value', t.target_value);
      APEX_JSON.write('labelEn', NVL(t.label_en,'')); APEX_JSON.write('labelAr', NVL(t.label_ar,''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('kpis/[COLON]id', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  IF NOT dct_kpi_pkg.is_admin(l_uid) THEN dct_rest.err(403,'KPI administrator role required'); RETURN; END IF;
  UPDATE dct_kpi_definitions SET is_active='N', updated_by=l_user, updated_at=SYSDATE
  WHERE kpi_id = TO_NUMBER([COLON]id);
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'KPI not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('kpis/[COLON]id/bands');
    def_handler('kpis/[COLON]id/bands', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_n := NVL(APEX_JSON.get_count(p_path=>'bands'), 0);
  IF l_n = 0 THEN dct_rest.err(400,'bands array is required'); RETURN; END IF;
  FOR i IN 1 .. l_n LOOP
    dct_kpi_pkg.set_band(
      p_user_id => l_uid, p_kpi_id => TO_NUMBER([COLON]id),
      p_band_score  => APEX_JSON.get_number(p_path=>'bands[%d].score', p0=>i),
      p_operator    => APEX_JSON.get_varchar2(p_path=>'bands[%d].operator', p0=>i),
      p_threshold_1 => APEX_JSON.get_number(p_path=>'bands[%d].threshold1', p0=>i),
      p_threshold_2 => APEX_JSON.get_number(p_path=>'bands[%d].threshold2', p0=>i),
      p_label_en    => APEX_JSON.get_varchar2(p_path=>'bands[%d].labelEn', p0=>i),
      p_label_ar    => APEX_JSON.get_varchar2(p_path=>'bands[%d].labelAr', p0=>i));
  END LOOP;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('saved', l_n); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('kpis/[COLON]id/criteria');
    def_handler('kpis/[COLON]id/criteria', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_n NUMBER; l_nl NUMBER; l_cid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_n := NVL(APEX_JSON.get_count(p_path=>'criteria'), 0);
  IF l_n = 0 THEN dct_rest.err(400,'criteria array is required'); RETURN; END IF;
  FOR i IN 1 .. l_n LOOP
    l_cid := APEX_JSON.get_number(p_path=>'criteria[%d].criterionId', p0=>i);
    dct_kpi_pkg.save_criterion(
      p_user_id => l_uid, p_kpi_id => TO_NUMBER([COLON]id), p_criterion_id => l_cid,
      p_criterion_code => APEX_JSON.get_varchar2(p_path=>'criteria[%d].code', p0=>i),
      p_name_en => APEX_JSON.get_varchar2(p_path=>'criteria[%d].nameEn', p0=>i),
      p_name_ar => APEX_JSON.get_varchar2(p_path=>'criteria[%d].nameAr', p0=>i),
      p_description_en => APEX_JSON.get_varchar2(p_path=>'criteria[%d].descriptionEn', p0=>i),
      p_description_ar => APEX_JSON.get_varchar2(p_path=>'criteria[%d].descriptionAr', p0=>i),
      p_weight_pct => APEX_JSON.get_number(p_path=>'criteria[%d].weight', p0=>i),
      p_entry_type => APEX_JSON.get_varchar2(p_path=>'criteria[%d].entryType', p0=>i),
      p_fnote_en => APEX_JSON.get_varchar2(p_path=>'criteria[%d].frequencyNoteEn', p0=>i),
      p_fnote_ar => APEX_JSON.get_varchar2(p_path=>'criteria[%d].frequencyNoteAr', p0=>i),
      p_display_order => APEX_JSON.get_number(p_path=>'criteria[%d].displayOrder', p0=>i),
      p_is_active => NVL(APEX_JSON.get_varchar2(p_path=>'criteria[%d].isActive', p0=>i),'Y'));
    l_nl := NVL(APEX_JSON.get_count(p_path=>'criteria[%d].levels', p0=>i), 0);
    FOR j IN 1 .. l_nl LOOP
      dct_kpi_pkg.save_level(
        p_user_id => l_uid, p_criterion_id => l_cid,
        p_level_no => APEX_JSON.get_number(p_path=>'criteria[%d].levels[%d].levelNo', p0=>i, p1=>j),
        p_title_en => APEX_JSON.get_varchar2(p_path=>'criteria[%d].levels[%d].titleEn', p0=>i, p1=>j),
        p_title_ar => APEX_JSON.get_varchar2(p_path=>'criteria[%d].levels[%d].titleAr', p0=>i, p1=>j),
        p_description_en => APEX_JSON.get_varchar2(p_path=>'criteria[%d].levels[%d].descriptionEn', p0=>i, p1=>j),
        p_description_ar => APEX_JSON.get_varchar2(p_path=>'criteria[%d].levels[%d].descriptionAr', p0=>i, p1=>j));
    END LOOP;
  END LOOP;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('saved', l_n); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('kpis/[COLON]id/targets');
    def_handler('kpis/[COLON]id/targets', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_n NUMBER; l_nr NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_n := NVL(APEX_JSON.get_count(p_path=>'targets'), 0);
  FOR i IN 1 .. l_n LOOP
    dct_kpi_pkg.set_target(
      p_user_id => l_uid, p_kpi_id => TO_NUMBER([COLON]id),
      p_target_year  => APEX_JSON.get_number(p_path=>'targets[%d].year', p0=>i),
      p_target_value => APEX_JSON.get_number(p_path=>'targets[%d].value', p0=>i),
      p_label_en     => APEX_JSON.get_varchar2(p_path=>'targets[%d].labelEn', p0=>i),
      p_label_ar     => APEX_JSON.get_varchar2(p_path=>'targets[%d].labelAr', p0=>i));
  END LOOP;
  l_nr := NVL(APEX_JSON.get_count(p_path=>'removeYears'), 0);
  FOR i IN 1 .. l_nr LOOP
    dct_kpi_pkg.delete_target(l_uid, TO_NUMBER([COLON]id),
      APEX_JSON.get_number(p_path=>'removeYears[%d]', p0=>i));
  END LOOP;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('saved', l_n); APEX_JSON.write('removed', l_nr); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- PERIODS
    -- =========================================================================
    def_template('periods');
    def_handler('periods', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT period_id, period_year, period_type, period_no, start_date, end_date, status,
                   CASE period_type WHEN 'ANNUAL' THEN TO_CHAR(period_year)
                        ELSE period_year || '-Q' || period_no END AS period_label
            FROM dct_kpi_periods
            WHERE (l_year IS NULL OR period_year = l_year)
            ORDER BY period_year DESC, period_type, period_no) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('periodId', r.period_id); APEX_JSON.write('year', r.period_year);
    APEX_JSON.write('type', r.period_type); APEX_JSON.write('quarter', r.period_no);
    APEX_JSON.write('label', r.period_label);
    APEX_JSON.write('startDate', TO_CHAR(r.start_date,'YYYY-MM-DD'));
    APEX_JSON.write('endDate', TO_CHAR(r.end_date,'YYYY-MM-DD'));
    APEX_JSON.write('status', r.status);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('periods/generate');
    def_handler('periods/generate', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_year NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  IF NOT dct_kpi_pkg.is_admin(l_uid) THEN dct_rest.err(403,'KPI administrator role required'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_year := APEX_JSON.get_number(p_path=>'year');
  dct_kpi_pkg.ensure_periods(l_year);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('year', l_year); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- RESULTS
    -- =========================================================================
    def_template('results');
    def_handler('results', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_kpi  NUMBER := TO_NUMBER([COLON]kpiId DEFAULT NULL ON CONVERSION ERROR);
  l_status VARCHAR2(30) := UPPER([COLON]status);
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 100), 500);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM dct_kpi_result_v
  WHERE (l_year IS NULL OR period_year = l_year)
    AND (l_kpi IS NULL OR kpi_id = l_kpi)
    AND (l_status IS NULL OR status = l_status);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_kpi_result_v
            WHERE (l_year IS NULL OR period_year = l_year)
              AND (l_kpi IS NULL OR kpi_id = l_kpi)
              AND (l_status IS NULL OR status = l_status)
            ORDER BY period_year DESC, kpi_id, period_type, period_no
            OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('resultId', r.result_id); APEX_JSON.write('kpiId', r.kpi_id);
    APEX_JSON.write('kpiCode', r.kpi_code); APEX_JSON.write('kpiNameEn', r.kpi_name_en);
    APEX_JSON.write('kpiNameAr', NVL(r.kpi_name_ar,''));
    APEX_JSON.write('periodId', r.period_id); APEX_JSON.write('periodLabel', r.period_label);
    APEX_JSON.write('year', r.period_year); APEX_JSON.write('periodType', r.period_type);
    APEX_JSON.write('resultPct', r.result_pct); APEX_JSON.write('score', r.score);
    APEX_JSON.write('targetValue', r.target_value);
    APEX_JSON.write('status', r.status);
    APEX_JSON.write('preparedByName', NVL(r.prepared_by_name,''));
    APEX_JSON.write('submittedAt', NVL(r.submitted_at_disp,''));
    APEX_JSON.write('docCount', r.doc_count);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('results/init');
    def_handler('results/init', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_id := dct_kpi_pkg.init_result(
    p_kpi_id => APEX_JSON.get_number(p_path=>'kpiId'),
    p_period_id => APEX_JSON.get_number(p_path=>'periodId'),
    p_user_id => l_uid);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('resultId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('results/[COLON]id');
    def_handler('results/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_found NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_found FROM dct_kpi_result_v WHERE result_id = TO_NUMBER([COLON]id);
  IF l_found = 0 THEN dct_rest.err(404,'Result not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM dct_kpi_result_v WHERE result_id = TO_NUMBER([COLON]id)) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('resultId', r.result_id); APEX_JSON.write('kpiId', r.kpi_id);
    APEX_JSON.write('kpiCode', r.kpi_code); APEX_JSON.write('kpiNameEn', r.kpi_name_en);
    APEX_JSON.write('kpiNameAr', NVL(r.kpi_name_ar,''));
    APEX_JSON.write('polarity', r.polarity); APEX_JSON.write('frequency', r.frequency);
    APEX_JSON.write('calcMethod', r.calc_method); APEX_JSON.write('requiresEvidence', r.requires_evidence);
    APEX_JSON.write('unitEn', NVL(r.unit_en,'')); APEX_JSON.write('unitAr', NVL(r.unit_ar,''));
    APEX_JSON.write('figureALabelEn', NVL(r.figure_a_label_en,'')); APEX_JSON.write('figureALabelAr', NVL(r.figure_a_label_ar,''));
    APEX_JSON.write('figureBLabelEn', NVL(r.figure_b_label_en,'')); APEX_JSON.write('figureBLabelAr', NVL(r.figure_b_label_ar,''));
    APEX_JSON.write('periodId', r.period_id); APEX_JSON.write('periodLabel', r.period_label);
    APEX_JSON.write('year', r.period_year); APEX_JSON.write('periodType', r.period_type);
    APEX_JSON.write('figureA', r.figure_a); APEX_JSON.write('figureB', r.figure_b);
    APEX_JSON.write('suggestedA', r.suggested_a); APEX_JSON.write('suggestedB', r.suggested_b);
    APEX_JSON.write('figureASource', r.figure_a_source); APEX_JSON.write('figureBSource', r.figure_b_source);
    APEX_JSON.write('resultPct', r.result_pct); APEX_JSON.write('score', r.score);
    APEX_JSON.write('targetValue', r.target_value);
    APEX_JSON.write('status', r.status);
    APEX_JSON.write('wfInstanceId', r.wf_instance_id);
    APEX_JSON.write('notes', NVL(r.notes,''));
    APEX_JSON.write('preparedBy', r.prepared_by); APEX_JSON.write('preparedByName', NVL(r.prepared_by_name,''));
    APEX_JSON.write('submittedByName', NVL(r.submitted_by_name,''));
    APEX_JSON.write('submittedAt', NVL(r.submitted_at_disp,''));
    APEX_JSON.write('approvedAt', NVL(r.approved_at_disp,''));
    APEX_JSON.write('docCount', r.doc_count);
    APEX_JSON.open_array('criteria');
    FOR c IN (SELECT * FROM dct_kpi_result_crit_v WHERE result_id = r.result_id
              ORDER BY display_order, criterion_id) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('criterionId', c.criterion_id); APEX_JSON.write('code', c.criterion_code);
      APEX_JSON.write('nameEn', c.name_en); APEX_JSON.write('nameAr', NVL(c.name_ar,''));
      APEX_JSON.write('descriptionEn', NVL(c.description_en,'')); APEX_JSON.write('descriptionAr', NVL(c.description_ar,''));
      APEX_JSON.write('weight', c.weight_pct); APEX_JSON.write('entryType', c.entry_type);
      APEX_JSON.write('frequencyNoteEn', NVL(c.frequency_note_en,'')); APEX_JSON.write('frequencyNoteAr', NVL(c.frequency_note_ar,''));
      APEX_JSON.write('levelNo', c.level_no); APEX_JSON.write('achievedPct', c.achieved_pct);
      APEX_JSON.write('critScore', c.crit_score);
      APEX_JSON.write('justification', NVL(c.justification,''));
      APEX_JSON.write('levelTitleEn', NVL(c.level_title_en,'')); APEX_JSON.write('levelTitleAr', NVL(c.level_title_ar,''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.open_array('history');
    FOR h IN (SELECT h.old_status, h.new_status, h.comments,
                     TO_CHAR(dct_to_local(h.changed_at),'YYYY-MM-DD HH:MI AM') AS changed_disp,
                     u.display_name AS changed_by_name
              FROM dct_request_status_history h
              LEFT JOIN dct_users u ON u.user_id = h.changed_by
              WHERE h.source_module='KPI_MGMT' AND h.source_type='KPI_RESULT'
                AND h.source_id = r.result_id
              ORDER BY h.changed_at) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('oldStatus', NVL(h.old_status,'')); APEX_JSON.write('newStatus', h.new_status);
      APEX_JSON.write('comments', NVL(h.comments,''));
      APEX_JSON.write('changedAt', h.changed_disp); APEX_JSON.write('changedBy', NVL(h.changed_by_name,''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('results/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  dct_kpi_pkg.save_result(
    p_result_id => TO_NUMBER([COLON]id), p_user_id => l_uid,
    p_figure_a => APEX_JSON.get_number(p_path=>'figureA'),
    p_figure_b => APEX_JSON.get_number(p_path=>'figureB'),
    p_notes => APEX_JSON.get_varchar2(p_path=>'notes'));
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  FOR r IN (SELECT result_pct, score FROM dct_kpi_results WHERE result_id = TO_NUMBER([COLON]id)) LOOP
    APEX_JSON.write('resultPct', r.result_pct); APEX_JSON.write('score', r.score);
  END LOOP;
  APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('results/[COLON]id/criteria/[COLON]critId');
    def_handler('results/[COLON]id/criteria/[COLON]critId', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  dct_kpi_pkg.save_result_criterion(
    p_result_id => TO_NUMBER([COLON]id), p_criterion_id => TO_NUMBER([COLON]critId), p_user_id => l_uid,
    p_level_no => APEX_JSON.get_number(p_path=>'levelNo'),
    p_achieved_pct => APEX_JSON.get_number(p_path=>'achievedPct'),
    p_justification => APEX_JSON.get_varchar2(p_path=>'justification'));
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  FOR r IN (SELECT result_pct, score FROM dct_kpi_results WHERE result_id = TO_NUMBER([COLON]id)) LOOP
    APEX_JSON.write('resultPct', r.result_pct); APEX_JSON.write('score', r.score);
  END LOOP;
  APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('results/[COLON]id/suggest');
    def_handler('results/[COLON]id/suggest', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_kpi_pkg.refresh_suggestions(TO_NUMBER([COLON]id), l_uid);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  FOR r IN (SELECT suggested_a, suggested_b FROM dct_kpi_results WHERE result_id = TO_NUMBER([COLON]id)) LOOP
    APEX_JSON.write('suggestedA', r.suggested_a); APEX_JSON.write('suggestedB', r.suggested_b);
  END LOOP;
  APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('results/[COLON]id/submit');
    def_handler('results/[COLON]id/submit', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_kpi_pkg.submit_result(TO_NUMBER([COLON]id), l_uid);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  FOR r IN (SELECT status, wf_instance_id, result_pct, score FROM dct_kpi_results WHERE result_id = TO_NUMBER([COLON]id)) LOOP
    APEX_JSON.write('status', r.status); APEX_JSON.write('wfInstanceId', r.wf_instance_id);
    APEX_JSON.write('resultPct', r.result_pct); APEX_JSON.write('score', r.score);
  END LOOP;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- EVIDENCE DOCUMENTS -- raw binary body, MAX_UPLOAD_MB guarded
    -- =========================================================================
    def_template('results/[COLON]id/docs');
    def_handler('results/[COLON]id/docs', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT d.doc_id, d.file_name, d.mime_type, d.file_size_bytes, d.created_at,
                   u.display_name AS uploaded_by_name
            FROM dct_documents d
            LEFT JOIN dct_users u ON u.user_id = d.created_by
            WHERE d.source_module='KPI_MGMT' AND d.source_type='KPI_RESULT'
              AND d.source_id = TO_NUMBER([COLON]id) AND d.is_active='Y'
            ORDER BY d.created_at DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('docId', r.doc_id); APEX_JSON.write('fileName', r.file_name);
    APEX_JSON.write('mimeType', NVL(r.mime_type,'')); APEX_JSON.write('fileSize', NVL(r.file_size_bytes,0));
    APEX_JSON.write('uploadedBy', NVL(r.uploaded_by_name,''));
    APEX_JSON.write('uploadedAt', TO_CHAR(dct_to_local(r.created_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('results/[COLON]id/docs', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100);
  l_uid  NUMBER;
  v_blob BLOB;
  v_len  NUMBER;
  v_max  NUMBER;
  l_id   NUMBER;
BEGIN
  v_blob := [COLON]body;
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF v_blob IS NULL OR DBMS_LOB.GETLENGTH(v_blob) = 0 THEN
    dct_rest.err(400,'Request body (file bytes) is required'); RETURN;
  END IF;
  v_len := DBMS_LOB.GETLENGTH(v_blob);
  BEGIN
    SELECT TO_NUMBER(ms.setting_value DEFAULT NULL ON CONVERSION ERROR) INTO v_max
    FROM dct_module_settings ms JOIN dct_modules m ON m.module_id = ms.module_id
    WHERE m.module_code='KPI_MGMT' AND ms.setting_key='MAX_UPLOAD_MB';
  EXCEPTION WHEN NO_DATA_FOUND THEN v_max := NULL; END;
  v_max := NVL(v_max, 10);
  IF v_len > v_max * 1024 * 1024 THEN
    dct_rest.err(413,'File exceeds the maximum upload size of '||v_max||' MB'); RETURN;
  END IF;
  l_uid := dct_auth.get_user_id(l_user);
  l_id := dct_kpi_pkg.add_evidence(
    p_result_id => TO_NUMBER([COLON]id), p_user_id => l_uid,
    p_file_name => [COLON]file_name, p_mime => NVL([COLON]mime_type,'application/octet-stream'),
    p_blob => v_blob);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('docId', l_id); APEX_JSON.write('fileSize', v_len); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('docs/[COLON]docId');
    def_handler('docs/[COLON]docId', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_kpi_pkg.delete_evidence(TO_NUMBER([COLON]docId), l_uid);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('docs/[COLON]docId/file');
    def_media('docs/[COLON]docId/file',
      q'!SELECT mime_type, file_blob FROM dct_documents
         WHERE doc_id = [COLON]docId AND source_module='KPI_MGMT' AND is_active='Y'!');

    -- =========================================================================
    -- SCORECARD DASHBOARD -- all derived values computed in PL/SQL, none inline
    -- =========================================================================
    def_template('scorecard');
    def_handler('scorecard', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER := NVL(TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR), EXTRACT(YEAR FROM SYSDATE));
  l_wsum NUMBER := 0;
  l_wtot NUMBER := 0;
  l_scored NUMBER := 0;
  l_kpis NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.open_array('kpis');
  FOR d IN (SELECT * FROM dct_kpi_definition_v WHERE is_active='Y' ORDER BY display_order, kpi_id) LOOP
    DECLARE
      l_avg NUMBER; l_latest NUMBER; l_latest_pct NUMBER; l_apr NUMBER := 0; l_cnt NUMBER := 0;
      l_tgt NUMBER; l_tgt_lbl VARCHAR2(60); l_prev NUMBER;
    BEGIN
      l_kpis := l_kpis + 1;
      FOR s IN (SELECT * FROM dct_kpi_scorecard_v WHERE kpi_id = d.kpi_id AND period_year = l_year) LOOP
        l_avg := s.avg_score; l_latest := s.latest_score; l_latest_pct := s.latest_result_pct;
        l_apr := s.approved_count; l_cnt := s.results_count;
        l_tgt := s.target_value; l_tgt_lbl := s.target_label_en;
      END LOOP;
      FOR s IN (SELECT avg_score FROM dct_kpi_scorecard_v WHERE kpi_id = d.kpi_id AND period_year = l_year - 1) LOOP
        l_prev := s.avg_score;
      END LOOP;
      IF l_tgt IS NULL THEN
        BEGIN
          SELECT target_value, label_en INTO l_tgt, l_tgt_lbl FROM dct_kpi_targets
          WHERE kpi_id = d.kpi_id AND target_year = l_year;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;
      END IF;
      IF l_avg IS NOT NULL THEN
        l_wsum := l_wsum + d.scorecard_weight_pct * l_avg;
        l_wtot := l_wtot + d.scorecard_weight_pct;
        l_scored := l_scored + 1;
      END IF;
      APEX_JSON.open_object;
      APEX_JSON.write('kpiId', d.kpi_id); APEX_JSON.write('code', d.kpi_code);
      APEX_JSON.write('nameEn', d.name_en); APEX_JSON.write('nameAr', NVL(d.name_ar,''));
      APEX_JSON.write('frequency', d.frequency); APEX_JSON.write('polarity', d.polarity);
      APEX_JSON.write('calcMethod', d.calc_method);
      APEX_JSON.write('unitEn', NVL(d.unit_en,''));
      APEX_JSON.write('weight', d.scorecard_weight_pct);
      APEX_JSON.write('avgScore', l_avg); APEX_JSON.write('prevYearScore', l_prev);
      APEX_JSON.write('latestScore', l_latest); APEX_JSON.write('latestPct', l_latest_pct);
      APEX_JSON.write('approvedCount', l_apr); APEX_JSON.write('resultsCount', l_cnt);
      APEX_JSON.write('targetValue', l_tgt); APEX_JSON.write('targetLabel', NVL(l_tgt_lbl,''));
      APEX_JSON.open_array('cells');
      FOR c IN (SELECT r.result_id, r.period_label, r.period_type, r.period_no,
                       r.result_pct, r.score, r.status
                FROM dct_kpi_result_v r
                WHERE r.kpi_id = d.kpi_id AND r.period_year = l_year
                ORDER BY r.period_type, r.period_no) LOOP
        APEX_JSON.open_object;
        APEX_JSON.write('resultId', c.result_id);
        APEX_JSON.write('period', c.period_label); APEX_JSON.write('periodType', c.period_type);
        APEX_JSON.write('quarter', c.period_no);
        APEX_JSON.write('pct', c.result_pct); APEX_JSON.write('score', c.score);
        APEX_JSON.write('status', c.status);
        APEX_JSON.close_object;
      END LOOP;
      APEX_JSON.close_array;
      APEX_JSON.close_object;
    END;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('kpiCount', l_kpis);
  APEX_JSON.write('scoredCount', l_scored);
  IF l_wtot > 0 THEN
    APEX_JSON.write('overallScore', ROUND(l_wsum / l_wtot, 2));
  ELSE
    APEX_JSON.write('overallScore', '');
  END IF;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- REPORT BRIDGE -- KPI briefing book via the Reporting Platform
    -- =========================================================================
    def_template('reports/book');
    def_handler('reports/book', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER;
  l_params CLOB;
  l_run NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_year := APEX_JSON.get_number(p_path=>'year');
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  APEX_JSON.initialize_clob_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  APEX_JSON.close_object;
  l_params := APEX_JSON.get_clob_output;
  APEX_JSON.free_output;
  l_run := dct_rpt_pkg.enqueue(
    p_report_code  => 'KPI_BRIEFING_BOOK',
    p_params       => l_params,
    p_trigger      => 'ONDEMAND',
    p_requested_by => l_user,
    p_formats      => 'PDF');
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('runId', l_run); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('reports/[COLON]runId/status');
    def_handler('reports/[COLON]runId/status', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_found NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_found FROM dct_rpt_run
  WHERE run_id = TO_NUMBER([COLON]runId) AND report_code = 'KPI_BRIEFING_BOOK';
  IF l_found = 0 THEN dct_rest.err(404,'Run not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  FOR r IN (SELECT rr.run_id, rr.status, rr.row_count,
                   NVL(DBMS_LOB.SUBSTR(rr.error_msg, 2000, 1), ' ') AS error_txt,
                   TO_CHAR(dct_to_local(rr.started_at),'YYYY-MM-DD HH:MI AM') AS started_disp,
                   TO_CHAR(dct_to_local(rr.finished_at),'YYYY-MM-DD HH:MI AM') AS finished_disp,
                   (SELECT COUNT(*) FROM dct_rpt_output o WHERE o.run_id = rr.run_id AND o.format='PDF') AS pdf_count
            FROM dct_rpt_run rr
            WHERE rr.run_id = TO_NUMBER([COLON]runId) AND rr.report_code = 'KPI_BRIEFING_BOOK') LOOP
    l_found := 1;
    APEX_JSON.open_object;
    APEX_JSON.write('runId', r.run_id); APEX_JSON.write('status', r.status);
    APEX_JSON.write('rowCount', r.row_count); APEX_JSON.write('error', TRIM(r.error_txt));
    APEX_JSON.write('startedAt', NVL(r.started_disp,'')); APEX_JSON.write('finishedAt', NVL(r.finished_disp,''));
    APEX_JSON.write('hasPdf', CASE WHEN r.pdf_count > 0 THEN 'Y' ELSE 'N' END);
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('reports/[COLON]runId/pdf');
    def_handler('reports/[COLON]runId/pdf', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_blob BLOB; l_name VARCHAR2(200);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT o.file_blob, o.file_name INTO l_blob, l_name
    FROM dct_rpt_output o
    JOIN dct_rpt_run rr ON rr.run_id = o.run_id
    WHERE o.run_id = TO_NUMBER([COLON]runId) AND rr.report_code='KPI_BRIEFING_BOOK'
      AND o.format='PDF'
    ORDER BY o.output_id DESC FETCH FIRST 1 ROWS ONLY;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'PDF not found'); RETURN; END;
  OWA_UTIL.mime_header('application/pdf', FALSE);
  HTP.p('Content-Disposition: attachment; filename="'||NVL(l_name,'kpi_briefing_book.pdf')||'"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_kpi_ords_tmp;
/

BEGIN
    setup_kpi_ords_tmp;
END;
/

DROP PROCEDURE setup_kpi_ords_tmp;

PROMPT === 06_kpi_ords.sql complete: kpi.rest published at /ords/admin/kpi/ ===
