-- =============================================================================
-- General Ledger (App 210) -- ENTITY classification: routes -- GL/db/48
-- Adds to : gl.rest (DEFINE_HANDLER-only on existing templates + ONE new template
--           'segments'; never DEFINE_TEMPLATE on an existing template -- it drops
--           the template's other handlers)
-- Run     : sql -name prod_mcp @48_gl_entity_ords.sql  (ADMIN, fresh session)
-- Needs   : GL/db/47 (tables/columns/seed) + 03 (package) + 04 (view + snapshot cols)
--           + db/v2/34 (period view entity columns) deployed first.
-- IMPORTANT: 05 DELETE_MODULEs gl.rest -- the GL post-05 re-run list now ends at 48
--           (48 supersedes 09's GET /mappings and 46's PUT /mappings/:id).
-- Routes  :
--   GET  /gl/segments                      the 10 canonical GL segments (key/position/width/names)
--   GET  /gl/segments/:key/values          ANY of the 10 keys (was 3) -- distinct codes + descriptions
--                                          from the COA snapshot, currentValueId for ?type= (default =
--                                          the dimension that owns the key, else ENTITY)
--   GET  /gl/mappings                      + segmentKey / segmentKeyName / segmentDesc for any segment
--   POST /gl/mappings                      + segmentKey (stored for ENTITY rules only; value padded to
--                                          the segment width); validate_map guards: only Entity may pick
--                                          a segment, same-segment period overlap, and ONE Entity rule
--                                          per GL combination (checked on the snapshot)
--   PUT  /gl/mappings/:id                  + segmentKey (46's SELECT-INTO shape kept)
--   DELETE /gl/mappings/:id                unchanged + refresh kick
--   GET  /gl/class-values                  + isDefault
--   POST /gl/class-values, PUT /:id        + isDefault (ENTITY only; setting Y clears the previous default)
--   GET  /gl/combinations                  + entityClassCode / entityClassName / entityClassSource
--                                          (RULE | DEFAULT | '' = Unclassified) + ?entity= filter
--                                          (UNCLASSIFIED = no rule and no default)
-- Every write fires a ONE-OFF refresh job (2026-09-06: create_job w/ -20042 retry, was run_job --
-- use_current_session => FALSE): DCT_ACTUALS_REFRESH_JOB (COA snapshot, ~8 s)
-- and DCT_BUTIL_FILTER_CACHE_JOB (butil key/filter cache, ~2 s) -- so a
-- classification edit reaches every page within seconds instead of the hourly
-- :11 / :37 runs (user report 2026-09-04). A job already running raises and is
-- ignored; the hourly schedules stay. Responses carry refreshQueued: 'Y'.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_entity_ords_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';
    PROCEDURE dt(p VARCHAR2) IS BEGIN ORDS.DEFINE_TEMPLATE(p_module_name=>c_mod, p_pattern=>REPLACE(p,'[COLON]',CHR(58))); END;
    PROCEDURE dh(p VARCHAR2, m VARCHAR2, s CLOB) IS BEGIN ORDS.DEFINE_HANDLER(p_module_name=>c_mod, p_pattern=>REPLACE(p,'[COLON]',CHR(58)), p_method=>m,
        p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(s,'[COLON]',CHR(58))); END;
BEGIN

  dt('segments');
  dh('segments','GET',q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT segment_key, position, width, name_en, name_ar FROM prod.dct_gl_segment ORDER BY position) LOOP
    APEX_JSON.open_object; APEX_JSON.write('key', r.segment_key); APEX_JSON.write('position', r.position);
    APEX_JSON.write('width', r.width); APEX_JSON.write('nameEn', r.name_en); APEX_JSON.write('nameAr', NVL(r.name_ar,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

  dh('segments/[COLON]key/values','GET',q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_key    VARCHAR2(30)  := UPPER([COLON]key);
  l_type   VARCHAR2(30)  := UPPER([COLON]type);
  l_search VARCHAR2(200) := [COLON]search;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 500);
  l_col    VARCHAR2(40); l_dcol VARCHAR2(40); l_w NUMBER; l_sql VARCHAR2(1500);
  TYPE t_cur IS REF CURSOR; c t_cur; l_code VARCHAR2(60); l_desc VARCHAR2(400); l_cur NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT coa_column, width INTO l_col, l_w FROM prod.dct_gl_segment WHERE segment_key = l_key;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Unknown segment key'); RETURN;
  END;
  IF l_type IS NULL THEN
    BEGIN SELECT class_type_code INTO l_type FROM prod.dct_gl_class_type WHERE segment_key = l_key AND ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN l_type := 'ENTITY'; END;
  END IF;
  l_col  := DBMS_ASSERT.simple_sql_name(l_col);
  l_dcol := DBMS_ASSERT.simple_sql_name(REPLACE(l_col, '_CODE', '_DESC'));
  l_sql := 'SELECT ' || l_col || ', MAX(' || l_dcol || ') FROM prod.dct_gl_coa_snap WHERE ' || l_col || ' IS NOT NULL'
        || ' AND (:s IS NULL OR UPPER(' || l_col || ' || '' '' || ' || l_dcol || ') LIKE ''%'' || UPPER(:s) || ''%'')'
        || ' GROUP BY ' || l_col || ' ORDER BY 1 FETCH FIRST :lim ROWS ONLY';
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  OPEN c FOR l_sql USING l_search, l_search, l_limit;
  LOOP
    FETCH c INTO l_code, l_desc; EXIT WHEN c%NOTFOUND;
    l_cur := NULL;
    BEGIN
      SELECT class_value_id INTO l_cur FROM (
        SELECT m.class_value_id FROM prod.dct_gl_seg_class_map m JOIN prod.dct_gl_class_type t ON t.class_type_code = m.class_type_code
         WHERE m.class_type_code = l_type AND NVL(m.segment_key, t.segment_key) = l_key AND m.segment_value = l_code
           AND TRUNC(SYSDATE) BETWEEN m.start_date AND NVL(m.end_date, DATE '4000-01-01')
         ORDER BY m.start_date DESC) WHERE ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN l_cur := NULL; END;
    APEX_JSON.open_object;
    APEX_JSON.write('segmentValue', l_code); APEX_JSON.write('description', NVL(l_desc,''));
    APEX_JSON.write('currentValueId', l_cur);
    APEX_JSON.close_object;
  END LOOP;
  CLOSE c;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

  dh('mappings','GET',q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_type VARCHAR2(30)  := UPPER([COLON]type);
  l_seg  VARCHAR2(60)  := [COLON]segment;
  l_vid  NUMBER        := TO_NUMBER([COLON]valueid DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_CLASSIFICATIONS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_CLASSIFICATIONS required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (
    WITH sd AS (
      SELECT 'ENTITY' k, entity_code sv, MAX(entity_desc) d FROM prod.dct_gl_coa_snap WHERE entity_code IS NOT NULL GROUP BY entity_code UNION ALL
      SELECT 'PROGRAM_CODE', program_code, MAX(program_desc) FROM prod.dct_gl_coa_snap WHERE program_code IS NOT NULL GROUP BY program_code UNION ALL
      SELECT 'COST_CENTER', cost_center_code, MAX(cost_center_desc) FROM prod.dct_gl_coa_snap WHERE cost_center_code IS NOT NULL GROUP BY cost_center_code UNION ALL
      SELECT 'BUDGET_GROUP', budget_group_code, MAX(budget_group_desc) FROM prod.dct_gl_coa_snap WHERE budget_group_code IS NOT NULL GROUP BY budget_group_code UNION ALL
      SELECT 'ACCOUNT', account_code, MAX(account_desc) FROM prod.dct_gl_coa_snap WHERE account_code IS NOT NULL GROUP BY account_code UNION ALL
      SELECT 'ENTITY_SPECIFIC', entity_specific_code, MAX(entity_specific_desc) FROM prod.dct_gl_coa_snap WHERE entity_specific_code IS NOT NULL GROUP BY entity_specific_code UNION ALL
      SELECT 'APPROPRIATION', appropriation_code, MAX(appropriation_desc) FROM prod.dct_gl_coa_snap WHERE appropriation_code IS NOT NULL GROUP BY appropriation_code UNION ALL
      SELECT 'INTERCOMPANY', intercompany_code, MAX(intercompany_desc) FROM prod.dct_gl_coa_snap WHERE intercompany_code IS NOT NULL GROUP BY intercompany_code UNION ALL
      SELECT 'FUTURE1', future1_code, MAX(future1_desc) FROM prod.dct_gl_coa_snap WHERE future1_code IS NOT NULL GROUP BY future1_code UNION ALL
      SELECT 'FUTURE2', future2_code, MAX(future2_desc) FROM prod.dct_gl_coa_snap WHERE future2_code IS NOT NULL GROUP BY future2_code
    )
    SELECT m.map_id, m.class_type_code, m.segment_value, m.class_value_id,
           v.value_code, v.name_en, m.notes,
           TO_CHAR(m.start_date,'YYYY-MM-DD') start_d,
           TO_CHAR(m.end_date,'YYYY-MM-DD')   end_d,
           CASE WHEN TRUNC(SYSDATE) BETWEEN m.start_date AND NVL(m.end_date, DATE '4000-01-01')
                THEN 'Y' ELSE 'N' END is_current,
           NVL(m.segment_key, t.segment_key) seg_key, g.name_en seg_name, g.name_ar seg_name_ar,
           sd.d AS seg_desc
    FROM prod.dct_gl_seg_class_map m
    JOIN prod.dct_gl_class_value v ON v.class_value_id = m.class_value_id
    JOIN prod.dct_gl_class_type  t ON t.class_type_code = m.class_type_code
    LEFT JOIN prod.dct_gl_segment g ON g.segment_key = NVL(m.segment_key, t.segment_key)
    LEFT JOIN sd ON sd.k = NVL(m.segment_key, t.segment_key) AND sd.sv = m.segment_value
    WHERE (l_type IS NULL OR m.class_type_code = l_type)
      AND (l_seg  IS NULL OR m.segment_value = l_seg)
      AND (l_vid  IS NULL OR m.class_value_id = l_vid)
    ORDER BY m.class_type_code, NVL(m.segment_key, t.segment_key), m.segment_value, m.start_date DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('mapId', r.map_id); APEX_JSON.write('type', r.class_type_code);
    APEX_JSON.write('segmentKey', r.seg_key); APEX_JSON.write('segmentKeyName', NVL(r.seg_name, r.seg_key));
    APEX_JSON.write('segmentKeyNameAr', NVL(r.seg_name_ar, NVL(r.seg_name, r.seg_key)));
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

  dh('mappings','POST',q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_type VARCHAR2(30); l_seg VARCHAR2(60); l_cv NUMBER; l_s DATE; l_e DATE; l_id NUMBER; l_key VARCHAR2(30); l_w NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_type := UPPER(APEX_JSON.get_varchar2(p_path=>'type'));
  l_key  := UPPER(APEX_JSON.get_varchar2(p_path=>'segmentKey'));
  l_seg  := APEX_JSON.get_varchar2(p_path=>'segmentValue');
  l_cv   := APEX_JSON.get_number(p_path=>'classValueId');
  l_s    := TO_DATE(APEX_JSON.get_varchar2(p_path=>'startDate'),'YYYY-MM-DD');
  l_e    := TO_DATE(APEX_JSON.get_varchar2(p_path=>'endDate'),'YYYY-MM-DD');
  prod.dct_gl_class_pkg.validate_map(NULL, l_type, l_seg, l_cv, l_s, l_e, l_key);
  IF l_key IS NOT NULL THEN
    SELECT width INTO l_w FROM prod.dct_gl_segment WHERE segment_key = l_key;
    l_seg := prod.dct_gl_class_pkg.norm(l_seg, l_w);
  END IF;
  INSERT INTO prod.dct_gl_seg_class_map (class_type_code, segment_key, segment_value, class_value_id, start_date, end_date, notes, created_by)
  VALUES (l_type, CASE WHEN l_type = 'ENTITY' THEN l_key END, l_seg, l_cv, l_s, l_e, APEX_JSON.get_varchar2(p_path=>'notes'), l_user)
  RETURNING map_id INTO l_id;
  COMMIT;
  -- refresh kick (2026-09-06): a ONE-OFF scheduler job (ADMIN-owned, auto-drop) replaces
  -- run_job -- db/v2/118 serializes the snapshot refresh (-20042 while another run is
  -- active) and run_job on a RUNNING job raises ORA-27478, so a kick landing mid-refresh
  -- was silently LOST until the next hourly run. The one-off retries -20042 up to 6x every
  -- 20 s, then refreshes the butil filter cache (db/v2/120). Trialled as ADMIN: SUCCEEDED, 11 s.
  BEGIN
    DBMS_SCHEDULER.create_job(
      job_name   => 'DCT_GL_CLASS_KICK_' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3'),
      job_type   => 'PLSQL_BLOCK',
      job_action => q'{DECLARE n PLS_INTEGER := 0; BEGIN LOOP BEGIN prod.dct_actuals_refresh; EXIT; EXCEPTION WHEN OTHERS THEN IF SQLCODE = -20042 AND n < 6 THEN n := n + 1; DBMS_SESSION.sleep(20); ELSE RAISE; END IF; END; END LOOP; BEGIN prod.dct_butil_filter_cache_refresh; EXCEPTION WHEN OTHERS THEN NULL; END; END;}',
      start_date => SYSTIMESTAMP + INTERVAL '3' SECOND, enabled => TRUE, auto_drop => TRUE,
      comments   => 'GL classification write -> COA snapshot + butil filter cache refresh');
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('mapId', l_id); APEX_JSON.write('refreshQueued', 'Y'); APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

  dh('mappings/[COLON]id','PUT',q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_type VARCHAR2(30); l_seg VARCHAR2(60); l_cv NUMBER; l_s DATE; l_e DATE; l_key VARCHAR2(30);
  l_cur_cv NUMBER; l_cur_s DATE; l_cur_key VARCHAR2(30);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  SELECT class_type_code, segment_value, class_value_id, start_date, segment_key
    INTO l_type, l_seg, l_cur_cv, l_cur_s, l_cur_key
    FROM prod.dct_gl_seg_class_map WHERE map_id=[COLON]id;
  l_cv  := NVL(APEX_JSON.get_number(p_path=>'classValueId'), l_cur_cv);
  l_s   := NVL(TO_DATE(APEX_JSON.get_varchar2(p_path=>'startDate'),'YYYY-MM-DD'), l_cur_s);
  l_e   := TO_DATE(APEX_JSON.get_varchar2(p_path=>'endDate'),'YYYY-MM-DD');
  l_key := NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'segmentKey')), l_cur_key);
  prod.dct_gl_class_pkg.validate_map([COLON]id, l_type, l_seg, l_cv, l_s, l_e, l_key);
  UPDATE prod.dct_gl_seg_class_map SET class_value_id=l_cv, start_date=l_s, end_date=l_e,
         segment_key = CASE WHEN l_type = 'ENTITY' THEN l_key ELSE segment_key END,
         notes=APEX_JSON.get_varchar2(p_path=>'notes'), updated_by=l_user, updated_at=SYSTIMESTAMP
   WHERE map_id=[COLON]id;
  IF SQL%ROWCOUNT=0 THEN dct_rest.err(404,'Assignment not found'); RETURN; END IF;
  COMMIT;
  -- refresh kick (2026-09-06): a ONE-OFF scheduler job (ADMIN-owned, auto-drop) replaces
  -- run_job -- db/v2/118 serializes the snapshot refresh (-20042 while another run is
  -- active) and run_job on a RUNNING job raises ORA-27478, so a kick landing mid-refresh
  -- was silently LOST until the next hourly run. The one-off retries -20042 up to 6x every
  -- 20 s, then refreshes the butil filter cache (db/v2/120). Trialled as ADMIN: SUCCEEDED, 11 s.
  BEGIN
    DBMS_SCHEDULER.create_job(
      job_name   => 'DCT_GL_CLASS_KICK_' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3'),
      job_type   => 'PLSQL_BLOCK',
      job_action => q'{DECLARE n PLS_INTEGER := 0; BEGIN LOOP BEGIN prod.dct_actuals_refresh; EXIT; EXCEPTION WHEN OTHERS THEN IF SQLCODE = -20042 AND n < 6 THEN n := n + 1; DBMS_SESSION.sleep(20); ELSE RAISE; END IF; END; END LOOP; BEGIN prod.dct_butil_filter_cache_refresh; EXCEPTION WHEN OTHERS THEN NULL; END; END;}',
      start_date => SYSTIMESTAMP + INTERVAL '3' SECOND, enabled => TRUE, auto_drop => TRUE,
      comments   => 'GL classification write -> COA snapshot + butil filter cache refresh');
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.write('refreshQueued', 'Y'); APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Assignment not found');
  WHEN OTHERS THEN IF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

  dh('mappings/[COLON]id','DELETE',q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  DELETE FROM prod.dct_gl_seg_class_map WHERE map_id=[COLON]id;
  IF SQL%ROWCOUNT=0 THEN dct_rest.err(404,'Assignment not found'); RETURN; END IF;
  COMMIT;
  -- refresh kick (2026-09-06): a ONE-OFF scheduler job (ADMIN-owned, auto-drop) replaces
  -- run_job -- db/v2/118 serializes the snapshot refresh (-20042 while another run is
  -- active) and run_job on a RUNNING job raises ORA-27478, so a kick landing mid-refresh
  -- was silently LOST until the next hourly run. The one-off retries -20042 up to 6x every
  -- 20 s, then refreshes the butil filter cache (db/v2/120). Trialled as ADMIN: SUCCEEDED, 11 s.
  BEGIN
    DBMS_SCHEDULER.create_job(
      job_name   => 'DCT_GL_CLASS_KICK_' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3'),
      job_type   => 'PLSQL_BLOCK',
      job_action => q'{DECLARE n PLS_INTEGER := 0; BEGIN LOOP BEGIN prod.dct_actuals_refresh; EXIT; EXCEPTION WHEN OTHERS THEN IF SQLCODE = -20042 AND n < 6 THEN n := n + 1; DBMS_SESSION.sleep(20); ELSE RAISE; END IF; END; END LOOP; BEGIN prod.dct_butil_filter_cache_refresh; EXCEPTION WHEN OTHERS THEN NULL; END; END;}',
      start_date => SYSTIMESTAMP + INTERVAL '3' SECOND, enabled => TRUE, auto_drop => TRUE,
      comments   => 'GL classification write -> COA snapshot + butil filter cache refresh');
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.write('refreshQueued', 'Y'); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

  dh('class-values','GET',q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_type VARCHAR2(30)  := UPPER([COLON]type);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (
    SELECT v.class_value_id, v.class_type_code, v.value_code, v.name_en, v.name_ar,
           v.alt_name1, v.alt_name2, v.alt_name3, v.parent_value_id, v.tag,
           v.display_order, v.is_active, v.is_default, p.name_en parent_name,
           (SELECT COUNT(*) FROM prod.dct_gl_seg_class_map m WHERE m.class_value_id=v.class_value_id) map_count
    FROM prod.dct_gl_class_value v
    LEFT JOIN prod.dct_gl_class_value p ON p.class_value_id = v.parent_value_id
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
    APEX_JSON.write('isDefault', NVL(r.is_default,'N'));
    APEX_JSON.write('mapCount', r.map_count);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

  dh('class-values','POST',q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_id NUMBER; l_type VARCHAR2(30); l_def VARCHAR2(1);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_type := UPPER(APEX_JSON.get_varchar2(p_path=>'type'));
  l_def  := CASE WHEN UPPER(NVL(APEX_JSON.get_varchar2(p_path=>'isDefault'),'N')) = 'Y' THEN 'Y' ELSE 'N' END;
  IF l_def = 'Y' AND l_type <> 'ENTITY' THEN dct_rest.err(400,'Only the Entity classification has a default value.'); RETURN; END IF;
  IF l_def = 'Y' THEN UPDATE prod.dct_gl_class_value SET is_default = 'N' WHERE class_type_code = l_type AND is_default = 'Y'; END IF;
  INSERT INTO prod.dct_gl_class_value (class_type_code, value_code, name_en, name_ar,
              alt_name1, alt_name2, alt_name3, parent_value_id, tag, display_order, is_active, is_default, created_by)
  VALUES (l_type,
          APEX_JSON.get_varchar2(p_path=>'valueCode'),
          APEX_JSON.get_varchar2(p_path=>'nameEn'),
          APEX_JSON.get_varchar2(p_path=>'nameAr'),
          APEX_JSON.get_varchar2(p_path=>'altName1'),
          APEX_JSON.get_varchar2(p_path=>'altName2'),
          APEX_JSON.get_varchar2(p_path=>'altName3'),
          APEX_JSON.get_number(p_path=>'parentValueId'),
          APEX_JSON.get_varchar2(p_path=>'tag'),
          NVL(APEX_JSON.get_number(p_path=>'displayOrder'),0),
          NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'), l_def, l_user)
  RETURNING class_value_id INTO l_id;
  COMMIT;
  -- refresh kick (2026-09-06): a ONE-OFF scheduler job (ADMIN-owned, auto-drop) replaces
  -- run_job -- db/v2/118 serializes the snapshot refresh (-20042 while another run is
  -- active) and run_job on a RUNNING job raises ORA-27478, so a kick landing mid-refresh
  -- was silently LOST until the next hourly run. The one-off retries -20042 up to 6x every
  -- 20 s, then refreshes the butil filter cache (db/v2/120). Trialled as ADMIN: SUCCEEDED, 11 s.
  BEGIN
    DBMS_SCHEDULER.create_job(
      job_name   => 'DCT_GL_CLASS_KICK_' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3'),
      job_type   => 'PLSQL_BLOCK',
      job_action => q'{DECLARE n PLS_INTEGER := 0; BEGIN LOOP BEGIN prod.dct_actuals_refresh; EXIT; EXCEPTION WHEN OTHERS THEN IF SQLCODE = -20042 AND n < 6 THEN n := n + 1; DBMS_SESSION.sleep(20); ELSE RAISE; END IF; END; END LOOP; BEGIN prod.dct_butil_filter_cache_refresh; EXCEPTION WHEN OTHERS THEN NULL; END; END;}',
      start_date => SYSTIMESTAMP + INTERVAL '3' SECOND, enabled => TRUE, auto_drop => TRUE,
      comments   => 'GL classification write -> COA snapshot + butil filter cache refresh');
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('classValueId', l_id); APEX_JSON.write('refreshQueued', 'Y'); APEX_JSON.close_object;
EXCEPTION WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(409,'Value code already exists for this dimension.');
WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

  dh('class-values/[COLON]id','PUT',q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_type VARCHAR2(30); l_def VARCHAR2(1);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  SELECT class_type_code, is_default INTO l_type, l_def FROM prod.dct_gl_class_value WHERE class_value_id = [COLON]id;
  IF APEX_JSON.does_exist(p_path=>'isDefault') THEN
    l_def := CASE WHEN UPPER(NVL(APEX_JSON.get_varchar2(p_path=>'isDefault'),'N')) = 'Y' THEN 'Y' ELSE 'N' END;
    IF l_def = 'Y' AND l_type <> 'ENTITY' THEN dct_rest.err(400,'Only the Entity classification has a default value.'); RETURN; END IF;
    IF l_def = 'Y' THEN UPDATE prod.dct_gl_class_value SET is_default = 'N' WHERE class_type_code = l_type AND is_default = 'Y' AND class_value_id <> [COLON]id; END IF;
  END IF;
  UPDATE prod.dct_gl_class_value SET
     name_en        = NVL(APEX_JSON.get_varchar2(p_path=>'nameEn'), name_en),
     name_ar        = APEX_JSON.get_varchar2(p_path=>'nameAr'),
     alt_name1      = APEX_JSON.get_varchar2(p_path=>'altName1'),
     alt_name2      = APEX_JSON.get_varchar2(p_path=>'altName2'),
     alt_name3      = APEX_JSON.get_varchar2(p_path=>'altName3'),
     parent_value_id= APEX_JSON.get_number(p_path=>'parentValueId'),
     tag            = APEX_JSON.get_varchar2(p_path=>'tag'),
     display_order  = NVL(APEX_JSON.get_number(p_path=>'displayOrder'), display_order),
     is_active      = NVL(APEX_JSON.get_varchar2(p_path=>'isActive'), is_active),
     is_default     = l_def,
     updated_by     = l_user, updated_at = SYSTIMESTAMP
   WHERE class_value_id = [COLON]id;
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Value not found'); RETURN; END IF;
  COMMIT;
  -- refresh kick (2026-09-06): a ONE-OFF scheduler job (ADMIN-owned, auto-drop) replaces
  -- run_job -- db/v2/118 serializes the snapshot refresh (-20042 while another run is
  -- active) and run_job on a RUNNING job raises ORA-27478, so a kick landing mid-refresh
  -- was silently LOST until the next hourly run. The one-off retries -20042 up to 6x every
  -- 20 s, then refreshes the butil filter cache (db/v2/120). Trialled as ADMIN: SUCCEEDED, 11 s.
  BEGIN
    DBMS_SCHEDULER.create_job(
      job_name   => 'DCT_GL_CLASS_KICK_' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3'),
      job_type   => 'PLSQL_BLOCK',
      job_action => q'{DECLARE n PLS_INTEGER := 0; BEGIN LOOP BEGIN prod.dct_actuals_refresh; EXIT; EXCEPTION WHEN OTHERS THEN IF SQLCODE = -20042 AND n < 6 THEN n := n + 1; DBMS_SESSION.sleep(20); ELSE RAISE; END IF; END; END LOOP; BEGIN prod.dct_butil_filter_cache_refresh; EXCEPTION WHEN OTHERS THEN NULL; END; END;}',
      start_date => SYSTIMESTAMP + INTERVAL '3' SECOND, enabled => TRUE, auto_drop => TRUE,
      comments   => 'GL classification write -> COA snapshot + butil filter cache refresh');
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok', 1); APEX_JSON.write('refreshQueued', 'Y'); APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Value not found');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

  dh('combinations','GET',q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_search VARCHAR2(200) := [COLON]search;
  l_sector VARCHAR2(60)  := [COLON]sector;
  l_chap   VARCHAR2(60)  := [COLON]chapter;
  l_prog   VARCHAR2(60)  := [COLON]program;
  l_ent    VARCHAR2(60)  := UPPER([COLON]entity);
  l_asof   VARCHAR2(20)  := [COLON]asof;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 50), 500);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_asof IS NOT NULL THEN dct_gl_class_pkg.set_asof(TO_DATE(l_asof,'YYYY-MM-DD'));
  ELSE dct_gl_class_pkg.clear_asof; END IF;
  WITH coa AS (
    SELECT * FROM prod.dct_gl_coa_snap WHERE l_asof IS NULL
    UNION ALL
    SELECT * FROM prod.dct_gl_coa_v WHERE l_asof IS NOT NULL
  )
  SELECT COUNT(*) INTO l_total FROM coa v
   WHERE (l_search IS NULL OR UPPER(v.cc_string||' '||v.cost_center_desc||' '||v.account_desc) LIKE '%'||UPPER(l_search)||'%')
     AND (l_sector IS NULL OR v.sector_code=l_sector)
     AND (l_chap   IS NULL OR v.chapter_code=l_chap)
     AND (l_prog   IS NULL OR v.program_class_code=l_prog)
     AND (l_ent    IS NULL OR (l_ent = 'UNCLASSIFIED' AND v.entity_class_code IS NULL) OR v.entity_class_code = l_ent);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    WITH coa AS (
      SELECT * FROM prod.dct_gl_coa_snap WHERE l_asof IS NULL
      UNION ALL
      SELECT * FROM prod.dct_gl_coa_v WHERE l_asof IS NOT NULL
    )
    SELECT * FROM coa v
     WHERE (l_search IS NULL OR UPPER(v.cc_string||' '||v.cost_center_desc||' '||v.account_desc) LIKE '%'||UPPER(l_search)||'%')
       AND (l_sector IS NULL OR v.sector_code=l_sector)
       AND (l_chap   IS NULL OR v.chapter_code=l_chap)
       AND (l_prog   IS NULL OR v.program_class_code=l_prog)
       AND (l_ent    IS NULL OR (l_ent = 'UNCLASSIFIED' AND v.entity_class_code IS NULL) OR v.entity_class_code = l_ent)
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
    APEX_JSON.write('entityClassCode', NVL(r.entity_class_code,'')); APEX_JSON.write('entityClassName', NVL(r.entity_class_name,''));
    APEX_JSON.write('entityClassSource', NVL(r.entity_class_source,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
  dct_gl_class_pkg.clear_asof;
EXCEPTION WHEN OTHERS THEN dct_gl_class_pkg.clear_asof; dct_rest.err(500, SQLERRM);
END;
!');

  COMMIT;
END setup_gl_entity_ords_tmp;
/

BEGIN setup_gl_entity_ords_tmp; END;
/
DROP PROCEDURE setup_gl_entity_ords_tmp;

PROMPT == GL/db/48 entity routes ==
SELECT h.method, t.uri_template, LENGTH(h.source) src_len
  FROM user_ords_handlers h JOIN user_ords_templates t ON t.id = h.template_id
 WHERE t.uri_template IN ('segments','segments/:key/values','mappings','mappings/:id','class-values','class-values/:id','combinations')
 ORDER BY 2, 1;
