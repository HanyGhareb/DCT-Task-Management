-- =============================================================================
-- i-Finance V2 -- Module access control (DCT_MODULE_ROLES goes live)
-- File    : 49_module_access.sql
-- Schema  : ADMIN ORDS additions (module dct.admin) over PROD dct_module_roles
-- Run as  : sql -name prod_mcp   (FRESH session -- do NOT follow an ALTER SESSION
--           SET CURRENT_SCHEMA=PROD run, or synonyms self-reference ORA-01471)
-- Purpose : wire DCT_MODULE_ROLES (module -> role App-Launcher access, seeded
--           dormant in 04_dct_seed.sql) into the platform. Semantics:
--             module with ZERO rows  -> visible to every signed-in user (fail-open)
--             module with rows       -> visible only to users holding a mapped role
--             SYS_ADMIN              -> always sees everything (lockout guard)
--           The shared shell hides denied entries from the module switcher;
--           per-handler ORDS role checks remain the security boundary.
-- Endpoints (module dct.admin, additive):
--   GET my/modules                   denied module codes for the session user
--   GET modules/[COLON]id/roles      all active roles + granted flag (SYS_ADMIN)
--   PUT modules/[COLON]id/roles      replace the module's role set (SYS_ADMIN);
--                                    body {"roleIds":[..]}; empty = unrestricted
-- Step 1 wipes the dormant 04 seed rows (created_by SYSTEM) so going live
-- changes nothing until an admin restricts an app in the new UI.
-- Idempotent / rerunnable. Re-run this script after any 11_dct_ords.sql re-run.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 0. ADMIN synonym (first handler use of dct_module_roles) ===
CREATE OR REPLACE SYNONYM dct_module_roles FOR prod.dct_module_roles;

PROMPT === 1. Reset dormant seed rows (behavior-preserving go-live) ===
BEGIN
  DELETE FROM prod.dct_module_roles WHERE created_by = 'SYSTEM';
  DBMS_OUTPUT.put_line('seed rows removed: ' || SQL%ROWCOUNT);
  COMMIT;
END;
/

PROMPT === 1b. Registry gap-fill: ATD + GL had no dct_modules row ===
-- Without a registry row an app can never be restricted (fail-open forever).
-- Add-if-missing only; names/colors mirror the shell registry. Run SQLcl with
-- JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8 (Arabic literals).
INSERT INTO prod.dct_modules
  (module_code, module_name_en, module_name_ar, module_type, apex_app_id,
   apex_page_id, icon_class, icon_color, bg_color,
   description_en, description_ar, category, display_order,
   is_active, is_new_tab, is_admin_only)
SELECT 'ATD', 'Analytics Loader', N'محمل البيانات التحليلية', 'APEX_APP', 208, 1,
       'fa-database', '#3A4FB0', '#E9ECF7',
       'Control plane for the OTBI-to-ATD data extraction fleet - jobs, queue, discovery, job sets and Fusion write-back actions.',
       N'لوحة التحكم في استخراج البيانات من فيوجن - المهام وقوائم الانتظار ومجموعات المهام وإجراءات الكتابة العكسية.',
       'CORE', 76, 'Y', 'N', 'Y'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM prod.dct_modules WHERE module_code = 'ATD');

INSERT INTO prod.dct_modules
  (module_code, module_name_en, module_name_ar, module_type, apex_app_id,
   apex_page_id, icon_class, icon_color, bg_color,
   description_en, description_ar, category, display_order,
   is_active, is_new_tab, is_admin_only)
SELECT 'GL', 'General Ledger', N'الأستاذ العام', 'APEX_APP', 210, 1,
       'fa-book', '#3F6F5F', '#E9F2EE',
       'Chart-of-accounts classifications, budget vs actuals reporting and budget utilization over the Fusion-loaded GL data.',
       N'تصنيفات دليل الحسابات وتقارير الموازنة مقابل الفعلي واستغلال الموازنة من بيانات الأستاذ العام.',
       'BUDGET', 77, 'Y', 'N', 'N'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM prod.dct_modules WHERE module_code = 'GL');

COMMIT;

PROMPT === 2. ORDS handlers (module dct.admin, additive) ===
CREATE OR REPLACE PROCEDURE admin.setup_dct_modaccess_ords_tmp AS
  c_mod CONSTANT VARCHAR2(30) := 'dct.admin';
  PROCEDURE def_template(p_pattern VARCHAR2) IS
  BEGIN
    ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern,'[COLON]',CHR(58)));
  END;
  PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
  BEGIN
    ORDS.DEFINE_HANDLER(
      p_module_name => c_mod,
      p_pattern     => REPLACE(p_pattern,'[COLON]',CHR(58)),
      p_method      => p_method,
      p_source_type => ORDS.source_type_plsql,
      p_source      => REPLACE(p_source,'[COLON]',CHR(58)));
  END;
BEGIN

  def_template('my/modules');
  def_handler('my/modules', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT user_id INTO l_uid FROM dct_users WHERE UPPER(username) = UPPER(l_user);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('denied');
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    FOR r IN (
      SELECT m.module_code
      FROM   dct_modules m
      WHERE  EXISTS (SELECT 1 FROM dct_module_roles mr WHERE mr.module_id = m.module_id)
        AND NOT EXISTS (
          SELECT 1
          FROM   dct_module_roles mr
          JOIN   dct_user_roles   ur ON ur.role_id = mr.role_id
          JOIN   dct_roles        ro ON ro.role_id = mr.role_id
          WHERE  mr.module_id = m.module_id
            AND  ur.user_id   = l_uid
            AND  ur.is_active = 'Y'
            AND  ro.is_active = 'Y'
            AND  TRUNC(SYSDATE) >= TRUNC(ur.start_date)
            AND (ur.end_date IS NULL OR TRUNC(SYSDATE) <= TRUNC(ur.end_date)))
    ) LOOP
      APEX_JSON.write(r.module_code);
    END LOOP;
  END IF;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION
  WHEN NO_DATA_FOUND THEN dct_rest.err(401,'Unauthorized');
  WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

  def_template('modules/[COLON]id/roles');
  def_handler('modules/[COLON]id/roles', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may manage module access'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_n FROM dct_modules WHERE module_id = [COLON]id;
  IF l_n = 0 THEN dct_rest.err(404,'Module not found'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('moduleId', TO_NUMBER([COLON]id));
  SELECT COUNT(*) INTO l_n FROM dct_module_roles WHERE module_id = [COLON]id;
  APEX_JSON.write('restricted', CASE WHEN l_n > 0 THEN 'Y' ELSE 'N' END);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT ro.role_id, ro.role_code, ro.role_name_en, ro.role_name_ar,
           CASE WHEN mr.mr_id IS NULL THEN 'N' ELSE 'Y' END AS granted
    FROM   dct_roles ro
    LEFT JOIN dct_module_roles mr
           ON mr.role_id = ro.role_id AND mr.module_id = [COLON]id
    WHERE  ro.is_active = 'Y'
    ORDER BY ro.display_order, ro.role_name_en
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('roleId',   r.role_id);
    APEX_JSON.write('roleCode', r.role_code);
    APEX_JSON.write('nameEn',   r.role_name_en);
    APEX_JSON.write('nameAr',   r.role_name_ar);
    APEX_JSON.write('granted',  r.granted);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

  def_handler('modules/[COLON]id/roles', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n    NUMBER;
  l_cnt  NUMBER := 0;
  l_old  VARCHAR2(4000);
  l_new  VARCHAR2(4000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only SYS_ADMIN may manage module access'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_n FROM dct_modules WHERE module_id = [COLON]id;
  IF l_n = 0 THEN dct_rest.err(404,'Module not found'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  SELECT LISTAGG(ro.role_code, ',') WITHIN GROUP (ORDER BY ro.role_code)
    INTO l_old
  FROM   dct_module_roles mr JOIN dct_roles ro ON ro.role_id = mr.role_id
  WHERE  mr.module_id = [COLON]id;
  DELETE FROM dct_module_roles WHERE module_id = [COLON]id;
  IF APEX_JSON.does_exist(p_path => 'roleIds') THEN
    l_cnt := NVL(APEX_JSON.get_count(p_path => 'roleIds'), 0);
  END IF;
  FOR i IN 1 .. l_cnt LOOP
    INSERT INTO dct_module_roles (module_id, role_id, access_level, created_by)
    VALUES ([COLON]id, APEX_JSON.get_number(p_path => 'roleIds[%d]', p0 => i),
            'FULL', l_user);
  END LOOP;
  SELECT LISTAGG(ro.role_code, ',') WITHIN GROUP (ORDER BY ro.role_code)
    INTO l_new
  FROM   dct_module_roles mr JOIN dct_roles ro ON ro.role_id = mr.role_id
  WHERE  mr.module_id = [COLON]id;
  COMMIT;
  dct_audit_pkg.log(l_user, 'UPDATE', 'DCT_MODULE_ROLES', TO_CHAR([COLON]id), 'ADMIN',
                    p_old => '{"roles":"' || NVL(l_old,'') || '"}',
                    p_new => '{"roles":"' || NVL(l_new,'') || '"}');
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('count', l_cnt);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    IF SQLCODE = -2291 THEN dct_rest.err(400,'Unknown roleId in roleIds');
    ELSE dct_rest.err(500, SQLERRM);
    END IF;
END;
!');

END;
/

BEGIN
  admin.setup_dct_modaccess_ords_tmp;
  COMMIT;
END;
/

DROP PROCEDURE admin.setup_dct_modaccess_ords_tmp;

PROMPT === 3. Verify ===
SELECT COUNT(*) AS modaccess_handlers
FROM   user_ords_handlers h
JOIN   user_ords_templates t ON t.id = h.template_id
WHERE  t.uri_template IN ('my/modules', 'modules/:id/roles');

SELECT COUNT(*) AS remaining_seed_rows FROM prod.dct_module_roles;

EXIT
