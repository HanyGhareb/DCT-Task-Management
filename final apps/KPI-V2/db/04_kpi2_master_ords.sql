-- =============================================================================
-- Finance KPIs V2 (App 213) -- Phase 2 KPI master ORDS routes (ADDITIVE on kpi.rest)
-- File   : 04_kpi2_master_ords.sql
-- Schema : ADMIN (fresh SQLcl session)
-- Adds   : v2/kpi-lovs      GET  (all KPI2_* + KPI_BAND_OP lookup values, eff flag)
--          v2/kpis          GET  (master register w/ child counts) + POST (create)
--          v2/kpis/[COLON]id GET (full detail incl. sources/figures/bands) + PUT
--          All KPI_ADMIN-or-SYS_ADMIN gated. Lookup-coded fields validated via
--          dct_lookup_pkg.validate_lookup (-20090 -> 400). kpi_code immutable
--          after create (plans will reference it).
-- RERUN RULE: KPI/db/06 rebuilds kpi.rest (DELETE_MODULE) -- after ANY re-run
--          of 06, re-run 02 AND this script.
-- Needs  : 03_kpi2_master_ddl.sql (tables + ADMIN synonyms) deployed first.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE PROCEDURE setup_kpi2_ords2_tmp AS

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

BEGIN

    -- =========================================================================
    -- LOVs for the KPI form + search filters (one call)
    -- =========================================================================
    def_template('v2/kpi-lovs');
    def_handler('v2/kpi-lovs', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'KPI_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'KPI administrator role required'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT c.category_code, v.value_code, v.value_name_en, v.value_name_ar,
           CASE WHEN v.is_active = 'Y'
                 AND (v.start_date IS NULL OR v.start_date <= SYSDATE)
                 AND (v.end_date IS NULL OR v.end_date >= TRUNC(SYSDATE))
                THEN 'Y' ELSE 'N' END eff
      FROM dct_lookup_values v
      JOIN dct_lookup_categories c ON c.category_id = v.category_id
     WHERE c.category_code IN ('KPI2_KPI_TYPE','KPI2_CATEGORY','KPI2_REPORTING_FREQ',
                               'KPI2_UPDATING_FREQ','KPI2_POLARITY','KPI2_CALC_METHOD',
                               'KPI2_UOM','KPI2_DATA_SOURCE','KPI2_SOURCE_FIGURE',
                               'KPI_BAND_OP')
     ORDER BY c.category_code, v.display_order, v.value_code)
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('category', r.category_code);
    APEX_JSON.write('code',     r.value_code);
    APEX_JSON.write('nameEn',   r.value_name_en);
    APEX_JSON.write('nameAr',   NVL(r.value_name_ar,''));
    APEX_JSON.write('eff',      r.eff);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- KPI master register
    -- =========================================================================
    def_template('v2/kpis');
    def_handler('v2/kpis', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'KPI_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'KPI administrator role required'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT k.kpi_id, k.kpi_code, k.name_en, k.name_ar, k.kpi_type, k.category,
           k.reporting_freq, k.updating_freq, k.polarity, k.calc_method, k.uom,
           k.evidence_required, k.is_active,
           (SELECT COUNT(*) FROM dct_kpi2_def_source s WHERE s.kpi_id = k.kpi_id) n_src,
           (SELECT COUNT(*) FROM dct_kpi2_def_figure f WHERE f.kpi_id = k.kpi_id) n_fig,
           (SELECT COUNT(*) FROM dct_kpi2_bands b WHERE b.kpi_id = k.kpi_id) n_bands,
           TO_CHAR(dct_to_local(k.updated_at),'YYYY-MM-DD HH[COLON]MI AM') updated_local,
           k.updated_by
      FROM dct_kpi2_definitions k
     ORDER BY k.kpi_code)
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id',            r.kpi_id);
    APEX_JSON.write('code',          r.kpi_code);
    APEX_JSON.write('nameEn',        r.name_en);
    APEX_JSON.write('nameAr',        NVL(r.name_ar,''));
    APEX_JSON.write('type',          r.kpi_type);
    APEX_JSON.write('category',      NVL(r.category,''));
    APEX_JSON.write('reportingFreq', r.reporting_freq);
    APEX_JSON.write('updatingFreq',  r.updating_freq);
    APEX_JSON.write('polarity',      r.polarity);
    APEX_JSON.write('calcMethod',    r.calc_method);
    APEX_JSON.write('uom',           r.uom);
    APEX_JSON.write('evidenceRequired', r.evidence_required);
    APEX_JSON.write('isActive',      r.is_active);
    APEX_JSON.write('sourceCount',   r.n_src);
    APEX_JSON.write('figureCount',   r.n_fig);
    APEX_JSON.write('bandCount',     r.n_bands);
    APEX_JSON.write('updatedAt',     NVL(r.updated_local,''));
    APEX_JSON.write('updatedBy',     NVL(r.updated_by,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('v2/kpis', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
  l_code VARCHAR2(60); l_en VARCHAR2(300);
  l_type VARCHAR2(100); l_cat VARCHAR2(100);
  l_rf VARCHAR2(100); l_uf VARCHAR2(100); l_pol VARCHAR2(100);
  l_cm VARCHAR2(100); l_uom VARCHAR2(100);
  l_n NUMBER; l_score NUMBER; l_op VARCHAR2(10);
  l_t1 NUMBER; l_t2 NUMBER; l_v VARCHAR2(100);
  PROCEDURE vl(p_cat VARCHAR2, p_val VARCHAR2) IS
  BEGIN
    IF p_val IS NOT NULL THEN dct_lookup_pkg.validate_lookup(p_cat, p_val); END IF;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'KPI_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'KPI administrator role required'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_code := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'code')));
  l_en   := TRIM(APEX_JSON.get_varchar2(p_path=>'nameEn'));
  l_type := APEX_JSON.get_varchar2(p_path=>'type');
  l_cat  := APEX_JSON.get_varchar2(p_path=>'category');
  l_rf   := APEX_JSON.get_varchar2(p_path=>'reportingFreq');
  l_uf   := APEX_JSON.get_varchar2(p_path=>'updatingFreq');
  l_pol  := APEX_JSON.get_varchar2(p_path=>'polarity');
  l_cm   := APEX_JSON.get_varchar2(p_path=>'calcMethod');
  l_uom  := APEX_JSON.get_varchar2(p_path=>'uom');
  IF l_code IS NULL OR l_en IS NULL OR l_type IS NULL OR l_rf IS NULL
     OR l_uf IS NULL OR l_pol IS NULL OR l_cm IS NULL OR l_uom IS NULL THEN
    dct_rest.err(400,'code, nameEn, type, reportingFreq, updatingFreq, polarity, calcMethod and uom are required'); RETURN; END IF;
  IF NOT REGEXP_LIKE(l_code, '^[A-Z0-9_-]{2,60}$') THEN
    dct_rest.err(400,'code may only contain A-Z, 0-9, underscore and dash'); RETURN; END IF;
  vl('KPI2_KPI_TYPE', l_type);        vl('KPI2_CATEGORY', l_cat);
  vl('KPI2_REPORTING_FREQ', l_rf);    vl('KPI2_UPDATING_FREQ', l_uf);
  vl('KPI2_POLARITY', l_pol);         vl('KPI2_CALC_METHOD', l_cm);
  vl('KPI2_UOM', l_uom);
  BEGIN
    INSERT INTO dct_kpi2_definitions
           (kpi_code, name_en, name_ar, description_en, description_ar,
            kpi_type, category, reporting_freq, updating_freq, polarity,
            calc_method, uom, evidence_required, is_active, created_by, updated_by)
    VALUES (l_code, l_en,
            NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'nameAr')),''),
            NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'descriptionEn')),''),
            NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'descriptionAr')),''),
            l_type, NULLIF(l_cat,''), l_rf, l_uf, l_pol, l_cm, l_uom,
            NVL(APEX_JSON.get_varchar2(p_path=>'evidenceRequired'),'N'),
            NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'),
            l_user, l_user)
    RETURNING kpi_id INTO l_id;
  EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
    dct_rest.err(400,'A KPI with this code already exists'); RETURN;
  END;
  l_n := NVL(APEX_JSON.get_count(p_path=>'sources'),0);
  FOR i IN 1 .. l_n LOOP
    l_v := APEX_JSON.get_varchar2(p_path=>'sources[%d]', p0=>i);
    vl('KPI2_DATA_SOURCE', l_v);
    INSERT INTO dct_kpi2_def_source (kpi_id, source_code, created_by)
    SELECT l_id, l_v, l_user FROM dual
     WHERE NOT EXISTS (SELECT 1 FROM dct_kpi2_def_source
                        WHERE kpi_id = l_id AND source_code = l_v);
  END LOOP;
  l_n := NVL(APEX_JSON.get_count(p_path=>'figures'),0);
  FOR i IN 1 .. l_n LOOP
    l_v := APEX_JSON.get_varchar2(p_path=>'figures[%d]', p0=>i);
    vl('KPI2_SOURCE_FIGURE', l_v);
    INSERT INTO dct_kpi2_def_figure (kpi_id, figure_code, created_by)
    SELECT l_id, l_v, l_user FROM dual
     WHERE NOT EXISTS (SELECT 1 FROM dct_kpi2_def_figure
                        WHERE kpi_id = l_id AND figure_code = l_v);
  END LOOP;
  l_n := NVL(APEX_JSON.get_count(p_path=>'bands'),0);
  FOR i IN 1 .. l_n LOOP
    l_score := APEX_JSON.get_number(p_path=>'bands[%d].score', p0=>i);
    l_op    := UPPER(APEX_JSON.get_varchar2(p_path=>'bands[%d].operator', p0=>i));
    l_t1    := APEX_JSON.get_number(p_path=>'bands[%d].threshold1', p0=>i);
    l_t2    := APEX_JSON.get_number(p_path=>'bands[%d].threshold2', p0=>i);
    IF l_score IS NULL OR l_score NOT BETWEEN 1 AND 5 THEN
      RAISE_APPLICATION_ERROR(-20001,'Band score must be between 1 and 5'); END IF;
    vl('KPI_BAND_OP', l_op);
    IF l_t1 IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001,'Band '||l_score||' requires a threshold'); END IF;
    IF l_op = 'BETWEEN' AND l_t2 IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001,'Band '||l_score||' operator BETWEEN requires a second threshold'); END IF;
    INSERT INTO dct_kpi2_bands
           (kpi_id, band_score, operator, threshold_1, threshold_2,
            label_en, label_ar, created_by)
    VALUES (l_id, l_score, l_op, l_t1, l_t2,
            NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'bands[%d].labelEn', p0=>i)),''),
            NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'bands[%d].labelAr', p0=>i)),''),
            l_user);
  END LOOP;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('id', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE = -1 THEN dct_rest.err(400,'Duplicate band score');
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- KPI detail + update
    -- =========================================================================
    def_template('v2/kpis/[COLON]id');
    def_handler('v2/kpis/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_found NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'KPI_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'KPI administrator role required'); RETURN; END IF;
  SELECT COUNT(*) INTO l_found FROM dct_kpi2_definitions WHERE kpi_id = [COLON]id;
  IF l_found = 0 THEN dct_rest.err(404,'KPI not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  FOR r IN (SELECT * FROM dct_kpi2_definitions WHERE kpi_id = [COLON]id) LOOP
    APEX_JSON.write('id',            r.kpi_id);
    APEX_JSON.write('code',          r.kpi_code);
    APEX_JSON.write('nameEn',        r.name_en);
    APEX_JSON.write('nameAr',        NVL(r.name_ar,''));
    APEX_JSON.write('descriptionEn', NVL(r.description_en,''));
    APEX_JSON.write('descriptionAr', NVL(r.description_ar,''));
    APEX_JSON.write('type',          r.kpi_type);
    APEX_JSON.write('category',      NVL(r.category,''));
    APEX_JSON.write('reportingFreq', r.reporting_freq);
    APEX_JSON.write('updatingFreq',  r.updating_freq);
    APEX_JSON.write('polarity',      r.polarity);
    APEX_JSON.write('calcMethod',    r.calc_method);
    APEX_JSON.write('uom',           r.uom);
    APEX_JSON.write('evidenceRequired', r.evidence_required);
    APEX_JSON.write('isActive',      r.is_active);
    APEX_JSON.write('updatedAt', NVL(TO_CHAR(dct_to_local(r.updated_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('updatedBy', NVL(r.updated_by,''));
  END LOOP;
  APEX_JSON.open_array('sources');
  FOR r IN (SELECT source_code FROM dct_kpi2_def_source
             WHERE kpi_id = [COLON]id ORDER BY source_code) LOOP
    APEX_JSON.write(r.source_code);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('figures');
  FOR r IN (SELECT figure_code FROM dct_kpi2_def_figure
             WHERE kpi_id = [COLON]id ORDER BY figure_code) LOOP
    APEX_JSON.write(r.figure_code);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('bands');
  FOR r IN (SELECT band_score, operator, threshold_1, threshold_2, label_en, label_ar
              FROM dct_kpi2_bands WHERE kpi_id = [COLON]id ORDER BY band_score DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('score',      r.band_score);
    APEX_JSON.write('operator',   r.operator);
    APEX_JSON.write('threshold1', r.threshold_1);
    IF r.threshold_2 IS NOT NULL THEN APEX_JSON.write('threshold2', r.threshold_2); END IF;
    APEX_JSON.write('labelEn',    NVL(r.label_en,''));
    APEX_JSON.write('labelAr',    NVL(r.label_ar,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('v2/kpis/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_found NUMBER := 0;
  l_en VARCHAR2(300);
  l_type VARCHAR2(100); l_cat VARCHAR2(100);
  l_rf VARCHAR2(100); l_uf VARCHAR2(100); l_pol VARCHAR2(100);
  l_cm VARCHAR2(100); l_uom VARCHAR2(100);
  l_n NUMBER; l_score NUMBER; l_op VARCHAR2(10);
  l_t1 NUMBER; l_t2 NUMBER; l_v VARCHAR2(100);
  PROCEDURE vl(p_cat VARCHAR2, p_val VARCHAR2) IS
  BEGIN
    IF p_val IS NOT NULL THEN dct_lookup_pkg.validate_lookup(p_cat, p_val); END IF;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'KPI_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'KPI administrator role required'); RETURN; END IF;
  SELECT COUNT(*) INTO l_found FROM dct_kpi2_definitions WHERE kpi_id = [COLON]id;
  IF l_found = 0 THEN dct_rest.err(404,'KPI not found'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_en   := TRIM(APEX_JSON.get_varchar2(p_path=>'nameEn'));
  l_type := APEX_JSON.get_varchar2(p_path=>'type');
  l_cat  := APEX_JSON.get_varchar2(p_path=>'category');
  l_rf   := APEX_JSON.get_varchar2(p_path=>'reportingFreq');
  l_uf   := APEX_JSON.get_varchar2(p_path=>'updatingFreq');
  l_pol  := APEX_JSON.get_varchar2(p_path=>'polarity');
  l_cm   := APEX_JSON.get_varchar2(p_path=>'calcMethod');
  l_uom  := APEX_JSON.get_varchar2(p_path=>'uom');
  IF l_en IS NULL OR l_type IS NULL OR l_rf IS NULL OR l_uf IS NULL
     OR l_pol IS NULL OR l_cm IS NULL OR l_uom IS NULL THEN
    dct_rest.err(400,'nameEn, type, reportingFreq, updatingFreq, polarity, calcMethod and uom are required'); RETURN; END IF;
  vl('KPI2_KPI_TYPE', l_type);        vl('KPI2_CATEGORY', l_cat);
  vl('KPI2_REPORTING_FREQ', l_rf);    vl('KPI2_UPDATING_FREQ', l_uf);
  vl('KPI2_POLARITY', l_pol);         vl('KPI2_CALC_METHOD', l_cm);
  vl('KPI2_UOM', l_uom);
  UPDATE dct_kpi2_definitions
     SET name_en = l_en,
         name_ar        = NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'nameAr')),''),
         description_en = NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'descriptionEn')),''),
         description_ar = NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'descriptionAr')),''),
         kpi_type = l_type, category = NULLIF(l_cat,''),
         reporting_freq = l_rf, updating_freq = l_uf, polarity = l_pol,
         calc_method = l_cm, uom = l_uom,
         evidence_required = NVL(APEX_JSON.get_varchar2(p_path=>'evidenceRequired'),'N'),
         is_active = NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'),
         updated_by = l_user, updated_at = SYSTIMESTAMP
   WHERE kpi_id = [COLON]id;
  DELETE FROM dct_kpi2_def_source WHERE kpi_id = [COLON]id;
  DELETE FROM dct_kpi2_def_figure WHERE kpi_id = [COLON]id;
  DELETE FROM dct_kpi2_bands      WHERE kpi_id = [COLON]id;
  l_n := NVL(APEX_JSON.get_count(p_path=>'sources'),0);
  FOR i IN 1 .. l_n LOOP
    l_v := APEX_JSON.get_varchar2(p_path=>'sources[%d]', p0=>i);
    vl('KPI2_DATA_SOURCE', l_v);
    INSERT INTO dct_kpi2_def_source (kpi_id, source_code, created_by)
    SELECT [COLON]id, l_v, l_user FROM dual
     WHERE NOT EXISTS (SELECT 1 FROM dct_kpi2_def_source
                        WHERE kpi_id = [COLON]id AND source_code = l_v);
  END LOOP;
  l_n := NVL(APEX_JSON.get_count(p_path=>'figures'),0);
  FOR i IN 1 .. l_n LOOP
    l_v := APEX_JSON.get_varchar2(p_path=>'figures[%d]', p0=>i);
    vl('KPI2_SOURCE_FIGURE', l_v);
    INSERT INTO dct_kpi2_def_figure (kpi_id, figure_code, created_by)
    SELECT [COLON]id, l_v, l_user FROM dual
     WHERE NOT EXISTS (SELECT 1 FROM dct_kpi2_def_figure
                        WHERE kpi_id = [COLON]id AND figure_code = l_v);
  END LOOP;
  l_n := NVL(APEX_JSON.get_count(p_path=>'bands'),0);
  FOR i IN 1 .. l_n LOOP
    l_score := APEX_JSON.get_number(p_path=>'bands[%d].score', p0=>i);
    l_op    := UPPER(APEX_JSON.get_varchar2(p_path=>'bands[%d].operator', p0=>i));
    l_t1    := APEX_JSON.get_number(p_path=>'bands[%d].threshold1', p0=>i);
    l_t2    := APEX_JSON.get_number(p_path=>'bands[%d].threshold2', p0=>i);
    IF l_score IS NULL OR l_score NOT BETWEEN 1 AND 5 THEN
      RAISE_APPLICATION_ERROR(-20001,'Band score must be between 1 and 5'); END IF;
    vl('KPI_BAND_OP', l_op);
    IF l_t1 IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001,'Band '||l_score||' requires a threshold'); END IF;
    IF l_op = 'BETWEEN' AND l_t2 IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001,'Band '||l_score||' operator BETWEEN requires a second threshold'); END IF;
    INSERT INTO dct_kpi2_bands
           (kpi_id, band_score, operator, threshold_1, threshold_2,
            label_en, label_ar, created_by)
    VALUES ([COLON]id, l_score, l_op, l_t1, l_t2,
            NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'bands[%d].labelEn', p0=>i)),''),
            NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'bands[%d].labelAr', p0=>i)),''),
            l_user);
  END LOOP;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE = -1 THEN dct_rest.err(400,'Duplicate band score');
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

END setup_kpi2_ords2_tmp;
/

BEGIN setup_kpi2_ords2_tmp; COMMIT; END;
/

DROP PROCEDURE setup_kpi2_ords2_tmp;

PROMPT == verification ==
SELECT uri_template, method
  FROM user_ords_handlers h JOIN user_ords_templates t ON t.id = h.template_id
 WHERE t.uri_template LIKE 'v2/kpi%'
 ORDER BY 1, 2;
