-- =============================================================================
-- i-Finance — Audit Log statistics and guarded category purge
-- Endpoints (dct.admin, SYS_ADMIN only):
--   GET  audit/stats  -- headline totals + module categories
--   POST audit/purge  -- body {category, olderThanDays}; minimum 30 days
-- Purge is category-specific and writes its own audit entry after completion.
-- Additive/rerunnable. Re-run after any 11_dct_ords.sql module rebuild.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE PACKAGE prod.dct_audit_maintenance_pkg AUTHID DEFINER AS
  PROCEDURE purge_category(
    p_username IN VARCHAR2, p_category IN VARCHAR2,
    p_older_than_days IN NUMBER, p_deleted OUT NUMBER);
END dct_audit_maintenance_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_audit_maintenance_pkg AS
  PROCEDURE purge_category(
    p_username IN VARCHAR2, p_category IN VARCHAR2,
    p_older_than_days IN NUMBER, p_deleted OUT NUMBER
  ) IS
    l_category VARCHAR2(100):=UPPER(TRIM(p_category));
    l_exists NUMBER;
  BEGIN
    IF l_category IS NULL THEN RAISE_APPLICATION_ERROR(-20081,'Category is required'); END IF;
    IF p_older_than_days IS NULL OR p_older_than_days<>TRUNC(p_older_than_days)
       OR p_older_than_days NOT BETWEEN 30 AND 3650 THEN
      RAISE_APPLICATION_ERROR(-20082,'Older-than days must be a whole number from 30 to 3650');
    END IF;
    SELECT COUNT(*) INTO l_exists FROM prod.dct_audit_log
     WHERE NVL(module_code,'UNCATEGORIZED')=l_category;
    IF l_exists=0 THEN RAISE_APPLICATION_ERROR(-20083,'Unknown or empty audit category'); END IF;
    DELETE FROM prod.dct_audit_log
     WHERE NVL(module_code,'UNCATEGORIZED')=l_category
       AND logged_at<SYSTIMESTAMP-NUMTODSINTERVAL(p_older_than_days,'DAY');
    p_deleted:=SQL%ROWCOUNT;
    COMMIT;
    prod.dct_audit_pkg.log(
      p_username,'DELETE','DCT_AUDIT_LOG','PURGE','ADMIN',
      p_object_ref=>'Category='||l_category||', olderThanDays='||p_older_than_days
                    ||', deleted='||p_deleted);
  EXCEPTION WHEN OTHERS THEN ROLLBACK; RAISE;
  END purge_category;
END dct_audit_maintenance_pkg;
/

CREATE OR REPLACE SYNONYM dct_audit_maintenance_pkg FOR prod.dct_audit_maintenance_pkg;

CREATE OR REPLACE PROCEDURE admin.setup_dct_audit_maint_ords_tmp AS
  c_mod CONSTANT VARCHAR2(30):='dct.admin';
  PROCEDURE def_template(p_pattern VARCHAR2) IS
  BEGIN
    ORDS.DEFINE_TEMPLATE(p_module_name=>c_mod,p_pattern=>p_pattern);
  END;
  PROCEDURE def_handler(p_pattern VARCHAR2,p_method VARCHAR2,p_source CLOB) IS
  BEGIN
    ORDS.DEFINE_HANDLER(p_module_name=>c_mod,p_pattern=>p_pattern,p_method=>p_method,
      p_source_type=>ORDS.source_type_plsql,p_source=>p_source);
  END;
BEGIN
  -- Extend the existing paginated list with module_code as visible category.
  def_handler('audit/','GET',q'!
DECLARE
  l_user   VARCHAR2(100):=dct_rest.validate_session;
  l_limit  NUMBER:=LEAST(NVL(TO_NUMBER(:limit DEFAULT NULL ON CONVERSION ERROR),50),200);
  l_offset NUMBER:=GREATEST(NVL(TO_NUMBER(:offset DEFAULT NULL ON CONVERSION ERROR),0),0);
  l_search VARCHAR2(200):=:search;
  l_action VARCHAR2(100):=UPPER(:action);
  l_category VARCHAR2(100):=UPPER(:category);
  l_from   DATE:=TO_DATE(:fromdt DEFAULT NULL ON CONVERSION ERROR,'YYYY-MM-DD');
  l_to     DATE:=TO_DATE(:todt DEFAULT NULL ON CONVERSION ERROR,'YYYY-MM-DD');
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM dct_audit_log
   WHERE (l_action IS NULL OR action=l_action)
     AND (l_category IS NULL OR NVL(module_code,'UNCATEGORIZED')=l_category)
     AND (l_from IS NULL OR logged_at>=l_from)
     AND (l_to IS NULL OR logged_at<l_to+1)
     AND (l_search IS NULL OR
          UPPER(NVL(username,'')||' '||NVL(module_code,'')||' '||NVL(object_type,'')||' '||NVL(object_id,''))
          LIKE '%'||UPPER(l_search)||'%');
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total',l_total); APEX_JSON.write('limit',l_limit); APEX_JSON.write('offset',l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT log_id,username,module_code,action,object_type,object_id,status,error_message,logged_at
      FROM dct_audit_log
     WHERE (l_action IS NULL OR action=l_action)
       AND (l_category IS NULL OR NVL(module_code,'UNCATEGORIZED')=l_category)
       AND (l_from IS NULL OR logged_at>=l_from)
       AND (l_to IS NULL OR logged_at<l_to+1)
       AND (l_search IS NULL OR
            UPPER(NVL(username,'')||' '||NVL(module_code,'')||' '||NVL(object_type,'')||' '||NVL(object_id,''))
            LIKE '%'||UPPER(l_search)||'%')
     ORDER BY logged_at DESC OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('logId',r.log_id); APEX_JSON.write('username',r.username);
    APEX_JSON.write('category',NVL(r.module_code,'UNCATEGORIZED'));
    APEX_JSON.write('action',r.action); APEX_JSON.write('objectType',r.object_type);
    APEX_JSON.write('objectId',r.object_id); APEX_JSON.write('status',r.status);
    APEX_JSON.write('error',r.error_message);
    APEX_JSON.write('loggedAt',TO_CHAR(dct_to_local(r.logged_at),'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;
!');

  def_template('audit/stats');
  def_handler('audit/stats','GET',q'!
DECLARE
  l_user       VARCHAR2(100):=dct_rest.validate_session;
  l_total      NUMBER;
  l_recent     NUMBER;
  l_failed     NUMBER;
  l_users      NUMBER;
  l_oldest     VARCHAR2(40);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may view audit statistics'); RETURN;
  END IF;
  SELECT COUNT(*),
         COUNT(CASE WHEN logged_at>=SYSTIMESTAMP-INTERVAL '30' DAY THEN 1 END),
         COUNT(CASE WHEN NVL(status,'SUCCESS')<>'SUCCESS' THEN 1 END),
         COUNT(DISTINCT NVL(username,'SYSTEM')),
         TO_CHAR(MIN(logged_at),'YYYY-MM-DD"T"HH24:MI:SS')
    INTO l_total,l_recent,l_failed,l_users,l_oldest
    FROM dct_audit_log;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total',l_total);
  APEX_JSON.write('last30Days',l_recent);
  APEX_JSON.write('failed',l_failed);
  APEX_JSON.write('uniqueUsers',l_users);
  APEX_JSON.write('oldest',NVL(l_oldest,''));
  APEX_JSON.open_array('categories');
  FOR r IN (
    SELECT NVL(module_code,'UNCATEGORIZED') category,COUNT(*) row_count
      FROM dct_audit_log
     GROUP BY NVL(module_code,'UNCATEGORIZED')
     ORDER BY 1
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('category',r.category);
    APEX_JSON.write('count',r.row_count);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;
!');

  def_template('audit-maintenance/purge');
  def_handler('audit-maintenance/purge','POST',q'!
DECLARE
  l_user     VARCHAR2(100):=dct_rest.validate_session;
  l_category VARCHAR2(100);
  l_days     NUMBER;
  l_deleted  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may purge audit records'); RETURN;
  END IF;
  dct_rest.parse_body(:body);
  l_category:=UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'category')));
  l_days:=APEX_JSON.get_number(p_path=>'olderThanDays');
  dct_audit_maintenance_pkg.purge_category(l_user,l_category,l_days,l_deleted);

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok',TRUE);
  APEX_JSON.write('category',l_category);
  APEX_JSON.write('olderThanDays',l_days);
  APEX_JSON.write('deleted',l_deleted);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE BETWEEN -20083 AND -20081 THEN dct_rest.err(400,SQLERRM);
  ELSE
    dct_audit_pkg.log(l_user,'DELETE','DCT_AUDIT_LOG','PURGE','ADMIN',
                      p_status=>'FAILED',p_error=>SQLERRM);
    dct_rest.err(500,SQLERRM);
  END IF;
END;
!');
END;
/

BEGIN
  admin.setup_dct_audit_maint_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE admin.setup_dct_audit_maint_ords_tmp;

PROMPT db/v2/77 audit statistics and guarded purge complete.
EXIT
