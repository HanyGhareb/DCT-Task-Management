-- ===========================================================================
-- i-Finance -- live database-health summary consistency fix
-- Replaces only GET /dct/maintenance/db-health.  Summary counts/status and
-- the issue list now use the same live dictionary data, preventing a stale
-- scheduled snapshot from disabling the recompile action.
-- Run as ADMIN in a fresh SQLcl session. Additive and rerunnable.
-- ===========================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE PROCEDURE admin.setup_dct_db_health_live_tmp AS
BEGIN
  ORDS.DEFINE_TEMPLATE(
    p_module_name => 'dct.admin',
    p_pattern     => 'maintenance/db-health');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'dct.admin',
    p_pattern     => 'maintenance/db-health',
    p_method      => 'GET',
    p_source_type => ORDS.source_type_plsql,
    p_source      => q'!
DECLARE
  l_user     VARCHAR2(100):=dct_rest.validate_session;
  l_invalid  NUMBER;
  l_unusable NUMBER;
  l_parts    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may view database object health'); RETURN;
  END IF;

  SELECT COUNT(*) INTO l_invalid FROM dba_objects
   WHERE owner='PROD' AND status<>'VALID' AND object_name NOT LIKE 'BIN$%';
  SELECT COUNT(*) INTO l_unusable FROM dba_indexes
   WHERE owner='PROD' AND status='UNUSABLE';
  SELECT COUNT(*) INTO l_parts FROM dba_ind_partitions
   WHERE index_owner='PROD' AND status='UNUSABLE';

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('status',CASE WHEN l_invalid+l_unusable+l_parts=0 THEN 'HEALTHY' ELSE 'WARNING' END);
  APEX_JSON.write('invalidObjects',l_invalid);
  APEX_JSON.write('unusableIndexes',l_unusable);
  APEX_JSON.write('unusablePartitions',l_parts);
  APEX_JSON.write('checkedAt',TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai','YYYY-MM-DD HH24:MI'));
  APEX_JSON.write('checkedBy','LIVE');
  APEX_JSON.open_array('issues');
  FOR r IN (
    SELECT issue_type,object_name,object_type,status
      FROM (
        SELECT 'INVALID_OBJECT' issue_type,object_name,object_type,status
          FROM dba_objects WHERE owner='PROD' AND status<>'VALID' AND object_name NOT LIKE 'BIN$%'
        UNION ALL
        SELECT 'UNUSABLE_INDEX',index_name,'INDEX',status
          FROM dba_indexes WHERE owner='PROD' AND status='UNUSABLE'
        UNION ALL
        SELECT 'UNUSABLE_PARTITION',index_name||' / '||partition_name,'INDEX PARTITION',status
          FROM dba_ind_partitions WHERE index_owner='PROD' AND status='UNUSABLE'
      ) ORDER BY issue_type,object_name FETCH FIRST 100 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('issueType',r.issue_type);
    APEX_JSON.write('objectName',r.object_name);
    APEX_JSON.write('objectType',r.object_type);
    APEX_JSON.write('status',r.status);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;
!');
END;
/
SHOW ERRORS

BEGIN
  admin.setup_dct_db_health_live_tmp;
  COMMIT;
END;
/
DROP PROCEDURE admin.setup_dct_db_health_live_tmp;

SELECT t.uri_template,h.method
  FROM user_ords_handlers h
  JOIN user_ords_templates t ON t.id=h.template_id
 WHERE t.uri_template='maintenance/db-health' AND h.method='GET';

PROMPT db/v2/120 live database-health summary complete.
EXIT
