-- =============================================================================
-- ATD Loader (App 208) -- "Generate Schedule OTBI Data" ORDS (additive on atd.rest)
-- File : 38_atd_schedgen_ords.sql
-- Endpoints (module atd.rest, base /ords/admin/atd/):
--   POST schedule-gen/        enqueue { folderPath, includeSubfolders } -> reqId
--   GET  schedule-gen/        recent requests (status + message)
--   GET  schedule-gen/[COLON]id    one request incl. result_json
-- Run : sql -name prod_mcp @38_atd_schedgen_ords.sql   (FRESH session; additive,
--       no DELETE_MODULE -- safe to run after 13_atd_ords.sql). Idempotent.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE PROCEDURE admin.setup_atd_schedgen_ords_tmp AS
  c_mod CONSTANT VARCHAR2(30) := 'atd.rest';
  PROCEDURE def_template(p_pattern VARCHAR2) IS
  BEGIN
    ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern,'[COLON]',CHR(58)));
  END;
  PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
  BEGIN
    ORDS.DEFINE_HANDLER(p_module_name => c_mod,
      p_pattern => REPLACE(p_pattern,'[COLON]',CHR(58)),
      p_method => p_method, p_source_type => ORDS.source_type_plsql,
      p_source => REPLACE(p_source,'[COLON]',CHR(58)));
  END;
BEGIN
  def_template('schedule-gen/');
  def_handler('schedule-gen/', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_folder VARCHAR2(1000);
  l_sub    VARCHAR2(1);
  l_id     NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_folder := APEX_JSON.get_varchar2(p_path => 'folderPath');
  l_sub := CASE WHEN UPPER(NVL(APEX_JSON.get_varchar2(p_path => 'includeSubfolders'),'N'))
                     IN ('Y','TRUE','1') THEN 'Y' ELSE 'N' END;
  IF l_folder IS NULL OR TRIM(l_folder) IS NULL THEN
    dct_rest.err(400,'folderPath is required'); RETURN;
  END IF;
  INSERT INTO atd_schedgen_request (folder_path, include_subfolders, requested_by)
    VALUES (TRIM(l_folder), l_sub, l_user) RETURNING req_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('reqId', l_id);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

  def_handler('schedule-gen/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR c IN (SELECT req_id, folder_path, include_subfolders, status, message, requested_by,
                   TO_CHAR(dct_to_local(created),  'YYYY-MM-DD HH:MI AM') created_s,
                   TO_CHAR(dct_to_local(finished), 'YYYY-MM-DD HH:MI AM') finished_s
            FROM atd_schedgen_request ORDER BY req_id DESC FETCH FIRST 50 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('reqId', c.req_id);
    APEX_JSON.write('folderPath', c.folder_path);
    APEX_JSON.write('includeSubfolders', c.include_subfolders);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('message', c.message);
    APEX_JSON.write('requestedBy', c.requested_by);
    APEX_JSON.write('created', c.created_s);
    APEX_JSON.write('finished', c.finished_s);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

  def_template('schedule-gen/[COLON]id');
  def_handler('schedule-gen/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  FOR c IN (SELECT req_id, folder_path, include_subfolders, status, message, result_json,
                   TO_CHAR(dct_to_local(created),  'YYYY-MM-DD HH:MI AM') created_s,
                   TO_CHAR(dct_to_local(finished), 'YYYY-MM-DD HH:MI AM') finished_s
            FROM atd_schedgen_request WHERE req_id = [COLON]id) LOOP
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('reqId', c.req_id);
    APEX_JSON.write('folderPath', c.folder_path);
    APEX_JSON.write('includeSubfolders', c.include_subfolders);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('message', c.message);
    APEX_JSON.write('resultJson', c.result_json);
    APEX_JSON.write('created', c.created_s);
    APEX_JSON.write('finished', c.finished_s);
    APEX_JSON.close_object;
    RETURN;
  END LOOP;
  dct_rest.err(404,'Request not found');
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
  COMMIT;
END;
/
SHOW ERRORS PROCEDURE admin.setup_atd_schedgen_ords_tmp

BEGIN
  admin.setup_atd_schedgen_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE admin.setup_atd_schedgen_ords_tmp;

PROMPT 38_atd_schedgen_ords : done
