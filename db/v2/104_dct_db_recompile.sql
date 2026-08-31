-- ===========================================================================
-- i-Finance -- PROD invalid-object recompile (front-end Data Maintenance action)
-- Adds prod.dct_db_recompile + POST /dct/maintenance/db-health/recompile so a
-- SYS_ADMIN can clear invalid objects from the Admin System Settings page.
--
-- The recompile first runs prod.dct_views_rebuild (recreates the base
-- pass-through views as SELECT * so a reloaded ATD table whose columns changed
-- self-heals -- the usual root of a cascade of invalid GL/AP/PO views), then
-- DBMS_UTILITY.COMPILE_SCHEMA to recompile the remaining dependents and package
-- bodies in dependency order, then refreshes the health snapshot.
--
-- Additive. Re-run after any 79 re-run (uses prod.dct_db_health_pkg). Deploy as
-- ADMIN in a fresh session (defines an ORDS handler on module dct.admin).
-- ===========================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

PROMPT === 1. Recompile procedure (runs as PROD, owns the objects) ===

CREATE OR REPLACE PROCEDURE prod.dct_db_recompile(
  p_by      IN  VARCHAR2,
  p_before  OUT NUMBER,
  p_after   OUT NUMBER,
  p_rebuilt OUT NUMBER,
  p_still   OUT CLOB
) AUTHID DEFINER AS
  l_reb NUMBER;
  l_inv VARCHAR2(4000);
BEGIN
  -- current invalid count (same predicate as prod.dct_db_health_pkg)
  SELECT COUNT(*) INTO p_before
    FROM user_objects
   WHERE status <> 'VALID' AND object_name NOT LIKE 'BIN$%';

  -- 1. self-heal structural ATD-reload changes on the base pass-throughs
  BEGIN
    prod.dct_views_rebuild(l_reb, l_inv);
    p_rebuilt := NVL(l_reb, 0);
  EXCEPTION WHEN OTHERS THEN
    p_rebuilt := 0;
  END;

  -- 2. recompile the remaining invalid objects (dependency order, invalid-only)
  BEGIN
    DBMS_UTILITY.COMPILE_SCHEMA(schema => 'PROD', compile_all => FALSE, reuse_settings => TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;

  -- 3. refresh the health snapshot so the card reflects the new state
  BEGIN
    prod.dct_db_health_pkg.run_health_check(p_by);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;

  SELECT COUNT(*) INTO p_after
    FROM user_objects
   WHERE status <> 'VALID' AND object_name NOT LIKE 'BIN$%';

  SELECT LISTAGG(object_name || ' (' || object_type || ')', ', '
                 ON OVERFLOW TRUNCATE ' ...' WITH COUNT)
           WITHIN GROUP (ORDER BY object_name)
    INTO p_still
    FROM user_objects
   WHERE status <> 'VALID' AND object_name NOT LIKE 'BIN$%';
END;
/
SHOW ERRORS

PROMPT === 2. Grant to ADMIN (ORDS handlers execute as ADMIN) ===

CREATE OR REPLACE PROCEDURE prod.grant_dct_db_recompile_tmp AUTHID DEFINER AS
BEGIN
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON prod.dct_db_recompile TO admin';
END;
/
BEGIN prod.grant_dct_db_recompile_tmp; END;
/
DROP PROCEDURE prod.grant_dct_db_recompile_tmp;

PROMPT === 3. SYS_ADMIN endpoint: POST maintenance/db-health/recompile ===

CREATE OR REPLACE PROCEDURE admin.setup_dct_db_recompile_ords_tmp AS
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'dct.admin', p_pattern => 'maintenance/db-health/recompile');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'dct.admin', p_pattern => 'maintenance/db-health/recompile', p_method => 'POST',
    p_source_type => ORDS.source_type_plsql,
    p_source => q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_before  NUMBER;
  l_after   NUMBER;
  l_rebuilt NUMBER;
  l_still   CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may recompile database objects'); RETURN;
  END IF;
  prod.dct_db_recompile(l_user, l_before, l_after, l_rebuilt, l_still);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('before', l_before);
  APEX_JSON.write('after', l_after);
  APEX_JSON.write('cleared', GREATEST(l_before - l_after, 0));
  APEX_JSON.write('viewsRebuilt', l_rebuilt);
  APEX_JSON.write('stillInvalid', NVL(DBMS_LOB.SUBSTR(l_still,4000,1),''));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
END;
/
SHOW ERRORS

BEGIN
  admin.setup_dct_db_recompile_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE admin.setup_dct_db_recompile_ords_tmp;

PROMPT === 4. Verification ===
SELECT object_name, object_type, status FROM dba_objects
 WHERE owner='PROD' AND object_name='DCT_DB_RECOMPILE';
SELECT h.method FROM user_ords_handlers h
 WHERE h.template_id IN (SELECT id FROM user_ords_templates WHERE uri_template = 'maintenance/db-health/recompile');

PROMPT db/v2/104 database object recompile complete.
EXIT
