-- =============================================================================
-- Finance KPIs V2 (App 213) -- Phase 1 ORDS routes (ADDITIVE on kpi.rest)
-- File   : 02_kpi2_ords.sql
-- Schema : ADMIN (fresh SQLcl session -- never after ALTER SESSION CURRENT_SCHEMA)
-- Adds   : v2/lookups            GET (master list) + POST (new lookup)
--          v2/lookups/:id        PUT (rename / de-activate a lookup)
--          v2/lookups/:id/values GET (values incl. desc/dates/status) + POST
--          v2/lookup-values/:id  PUT (edit a value)
--          All KPI_ADMIN-or-SYS_ADMIN gated; db/v2/50 gate covers segment kpi.
-- Scope  : master list = lookup categories owned by module KPI_MGMT plus any
--          KPI2_* code; v1's KPI_* system rows (module NULL, is_system Y) are
--          not listed and cannot be touched here.
-- RERUN RULE: KPI/db/06 rebuilds kpi.rest from scratch (DELETE_MODULE) -- after
--          ANY re-run of 06, re-run THIS script to restore the v2 routes.
-- Needs  : db/v2/109 (new columns) deployed first. No new synonyms needed --
--          dct_lookup_categories/values, dct_modules, dct_rest, dct_auth,
--          dct_to_local already have ADMIN synonyms.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE PROCEDURE setup_kpi2_ords_tmp AS

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
    -- MASTER -- lookup categories
    -- =========================================================================
    def_template('v2/lookups');
    def_handler('v2/lookups', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_mod  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'KPI_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'KPI administrator role required'); RETURN; END IF;
  SELECT module_id INTO l_mod FROM dct_modules WHERE module_code = 'KPI_MGMT';
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT c.category_id, c.category_code, c.category_name_en, c.category_name_ar,
           c.is_active,
           (SELECT COUNT(*) FROM dct_lookup_values v
             WHERE v.category_id = c.category_id) n_vals,
           (SELECT COUNT(*) FROM dct_lookup_values v
             WHERE v.category_id = c.category_id AND v.is_active = 'Y'
               AND (v.start_date IS NULL OR v.start_date <= SYSDATE)
               AND (v.end_date IS NULL OR v.end_date >= TRUNC(SYSDATE))) n_eff,
           TO_CHAR(dct_to_local(c.updated_at),'YYYY-MM-DD HH[COLON]MI AM') updated_local,
           c.updated_by
      FROM dct_lookup_categories c
     WHERE c.module_id = l_mod OR c.category_code LIKE 'KPI2\_%' ESCAPE '\'
     ORDER BY c.category_code)
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id',        r.category_id);
    APEX_JSON.write('code',      r.category_code);
    APEX_JSON.write('nameEn',    r.category_name_en);
    APEX_JSON.write('nameAr',    NVL(r.category_name_ar,''));
    APEX_JSON.write('isActive',  r.is_active);
    APEX_JSON.write('valueCount', r.n_vals);
    APEX_JSON.write('effectiveCount', r.n_eff);
    APEX_JSON.write('updatedAt', NVL(r.updated_local,''));
    APEX_JSON.write('updatedBy', NVL(r.updated_by,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('v2/lookups', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_mod  NUMBER; l_id NUMBER;
  l_code VARCHAR2(100); l_en VARCHAR2(200); l_ar VARCHAR2(200);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'KPI_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'KPI administrator role required'); RETURN; END IF;
  SELECT module_id INTO l_mod FROM dct_modules WHERE module_code = 'KPI_MGMT';
  dct_rest.parse_body([COLON]body);
  l_code := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'code')));
  l_en   := TRIM(APEX_JSON.get_varchar2(p_path=>'nameEn'));
  l_ar   := TRIM(APEX_JSON.get_varchar2(p_path=>'nameAr'));
  IF l_code IS NULL OR l_en IS NULL THEN
    dct_rest.err(400,'code and nameEn are required'); RETURN; END IF;
  IF NOT REGEXP_LIKE(l_code, '^[A-Z0-9_]{2,100}$') THEN
    dct_rest.err(400,'code may only contain A-Z, 0-9 and underscore'); RETURN; END IF;
  BEGIN
    INSERT INTO dct_lookup_categories
           (category_code, category_name_en, category_name_ar,
            module_id, is_system, is_active, created_by, updated_by)
    VALUES (l_code, l_en, l_ar, l_mod, 'N',
            NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'), l_user, l_user)
    RETURNING category_id INTO l_id;
  EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
    dct_rest.err(400,'A lookup with this code already exists'); RETURN;
  END;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('id', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('v2/lookups/[COLON]id');
    def_handler('v2/lookups/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_sys  VARCHAR2(1); l_dummy NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'KPI_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'KPI administrator role required'); RETURN; END IF;
  BEGIN
    SELECT is_system INTO l_sys FROM dct_lookup_categories WHERE category_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Lookup not found'); RETURN; END;
  IF l_sys = 'Y' THEN dct_rest.err(403,'System lookups are read-only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  IF TRIM(APEX_JSON.get_varchar2(p_path=>'nameEn')) IS NULL THEN
    dct_rest.err(400,'nameEn is required'); RETURN; END IF;
  UPDATE dct_lookup_categories
     SET category_name_en = TRIM(APEX_JSON.get_varchar2(p_path=>'nameEn')),
         category_name_ar = CASE WHEN APEX_JSON.does_exist(p_path=>'nameAr')
                                 THEN NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'nameAr')),'')
                                 ELSE category_name_ar END,
         is_active        = NVL(APEX_JSON.get_varchar2(p_path=>'isActive'), is_active),
         updated_by = l_user, updated_at = SYSTIMESTAMP
   WHERE category_id = [COLON]id;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500,SQLERRM);
END;
!');

    -- =========================================================================
    -- DETAIL -- lookup values
    -- =========================================================================
    def_template('v2/lookups/[COLON]id/values');
    def_handler('v2/lookups/[COLON]id/values', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'KPI_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'KPI administrator role required'); RETURN; END IF;
  SELECT COUNT(*) INTO l_n FROM dct_lookup_categories WHERE category_id = [COLON]id;
  IF l_n = 0 THEN dct_rest.err(404,'Lookup not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT v.value_id, v.value_code, v.value_name_en, v.value_name_ar,
           v.description_en, v.description_ar,
           TO_CHAR(v.start_date,'YYYY-MM-DD') start_d,
           TO_CHAR(v.end_date,'YYYY-MM-DD')   end_d,
           v.display_order, v.is_default, v.is_active,
           CASE WHEN v.is_active = 'N'                THEN 'INACTIVE'
                WHEN v.start_date > SYSDATE           THEN 'PENDING'
                WHEN v.end_date  < TRUNC(SYSDATE)     THEN 'EXPIRED'
                ELSE 'ACTIVE' END eff_status,
           TO_CHAR(dct_to_local(v.updated_at),'YYYY-MM-DD HH[COLON]MI AM') updated_local,
           v.updated_by
      FROM dct_lookup_values v
     WHERE v.category_id = [COLON]id
     ORDER BY v.display_order, v.value_code)
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id',            r.value_id);
    APEX_JSON.write('code',          r.value_code);
    APEX_JSON.write('nameEn',        r.value_name_en);
    APEX_JSON.write('nameAr',        NVL(r.value_name_ar,''));
    APEX_JSON.write('descriptionEn', NVL(r.description_en,''));
    APEX_JSON.write('descriptionAr', NVL(r.description_ar,''));
    APEX_JSON.write('startDate',     NVL(r.start_d,''));
    APEX_JSON.write('endDate',       NVL(r.end_d,''));
    APEX_JSON.write('displayOrder',  NVL(r.display_order,0));
    APEX_JSON.write('isDefault',     r.is_default);
    APEX_JSON.write('isActive',      r.is_active);
    APEX_JSON.write('effectiveStatus', r.eff_status);
    APEX_JSON.write('updatedAt',     NVL(r.updated_local,''));
    APEX_JSON.write('updatedBy',     NVL(r.updated_by,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('v2/lookups/[COLON]id/values', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_sys VARCHAR2(1); l_id NUMBER;
  l_code VARCHAR2(100); l_en VARCHAR2(200);
  l_sd_txt VARCHAR2(30); l_ed_txt VARCHAR2(30);
  l_sd DATE; l_ed DATE; l_def VARCHAR2(1);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'KPI_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'KPI administrator role required'); RETURN; END IF;
  BEGIN
    SELECT is_system INTO l_sys FROM dct_lookup_categories WHERE category_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Lookup not found'); RETURN; END;
  IF l_sys = 'Y' THEN dct_rest.err(403,'System lookups are read-only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_code := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'code')));
  l_en   := TRIM(APEX_JSON.get_varchar2(p_path=>'nameEn'));
  IF l_code IS NULL OR l_en IS NULL THEN
    dct_rest.err(400,'code and nameEn are required'); RETURN; END IF;
  IF NOT REGEXP_LIKE(l_code, '^[A-Z0-9_]{1,100}$') THEN
    dct_rest.err(400,'code may only contain A-Z, 0-9 and underscore'); RETURN; END IF;
  l_sd_txt := APEX_JSON.get_varchar2(p_path=>'startDate');
  l_ed_txt := APEX_JSON.get_varchar2(p_path=>'endDate');
  l_sd := TO_DATE(l_sd_txt DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
  l_ed := TO_DATE(l_ed_txt DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
  IF (l_sd_txt IS NOT NULL AND l_sd IS NULL) OR (l_ed_txt IS NOT NULL AND l_ed IS NULL) THEN
    dct_rest.err(400,'Dates must be YYYY-MM-DD'); RETURN; END IF;
  IF l_sd IS NOT NULL AND l_ed IS NOT NULL AND l_ed < l_sd THEN
    dct_rest.err(400,'End date must be on or after the start date'); RETURN; END IF;
  l_def := NVL(APEX_JSON.get_varchar2(p_path=>'isDefault'),'N');
  BEGIN
    INSERT INTO dct_lookup_values
           (category_id, value_code, value_name_en, value_name_ar,
            description_en, description_ar, start_date, end_date,
            display_order, is_default, is_active, created_by, updated_by)
    VALUES ([COLON]id, l_code, l_en,
            NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'nameAr')),''),
            NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'descriptionEn')),''),
            NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'descriptionAr')),''),
            l_sd, l_ed,
            NVL(APEX_JSON.get_number(p_path=>'displayOrder'), 0),
            l_def, NVL(APEX_JSON.get_varchar2(p_path=>'isActive'),'Y'),
            l_user, l_user)
    RETURNING value_id INTO l_id;
  EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
    dct_rest.err(400,'A value with this code already exists in the lookup'); RETURN;
  END;
  IF l_def = 'Y' THEN
    UPDATE dct_lookup_values SET is_default = 'N'
     WHERE category_id = [COLON]id AND value_id <> l_id AND is_default = 'Y';
  END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('id', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-2290 THEN dct_rest.err(400,'End date must be on or after the start date');
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('v2/lookup-values/[COLON]id');
    def_handler('v2/lookup-values/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_cat NUMBER; l_sys VARCHAR2(1);
  l_sd_txt VARCHAR2(30); l_ed_txt VARCHAR2(30);
  l_sd DATE; l_ed DATE; l_def VARCHAR2(1);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'KPI_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'KPI administrator role required'); RETURN; END IF;
  BEGIN
    SELECT v.category_id, c.is_system INTO l_cat, l_sys
      FROM dct_lookup_values v JOIN dct_lookup_categories c ON c.category_id = v.category_id
     WHERE v.value_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Lookup value not found'); RETURN; END;
  IF l_sys = 'Y' THEN dct_rest.err(403,'System lookups are read-only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  IF TRIM(APEX_JSON.get_varchar2(p_path=>'nameEn')) IS NULL THEN
    dct_rest.err(400,'nameEn is required'); RETURN; END IF;
  l_sd_txt := APEX_JSON.get_varchar2(p_path=>'startDate');
  l_ed_txt := APEX_JSON.get_varchar2(p_path=>'endDate');
  l_sd := TO_DATE(l_sd_txt DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
  l_ed := TO_DATE(l_ed_txt DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
  IF (l_sd_txt IS NOT NULL AND l_sd IS NULL) OR (l_ed_txt IS NOT NULL AND l_ed IS NULL) THEN
    dct_rest.err(400,'Dates must be YYYY-MM-DD'); RETURN; END IF;
  IF l_sd IS NOT NULL AND l_ed IS NOT NULL AND l_ed < l_sd THEN
    dct_rest.err(400,'End date must be on or after the start date'); RETURN; END IF;
  l_def := APEX_JSON.get_varchar2(p_path=>'isDefault');
  UPDATE dct_lookup_values
     SET value_name_en  = TRIM(APEX_JSON.get_varchar2(p_path=>'nameEn')),
         value_name_ar  = CASE WHEN APEX_JSON.does_exist(p_path=>'nameAr')
                               THEN NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'nameAr')),'')
                               ELSE value_name_ar END,
         description_en = CASE WHEN APEX_JSON.does_exist(p_path=>'descriptionEn')
                               THEN NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'descriptionEn')),'')
                               ELSE description_en END,
         description_ar = CASE WHEN APEX_JSON.does_exist(p_path=>'descriptionAr')
                               THEN NULLIF(TRIM(APEX_JSON.get_varchar2(p_path=>'descriptionAr')),'')
                               ELSE description_ar END,
         start_date     = CASE WHEN APEX_JSON.does_exist(p_path=>'startDate') THEN l_sd ELSE start_date END,
         end_date       = CASE WHEN APEX_JSON.does_exist(p_path=>'endDate')   THEN l_ed ELSE end_date   END,
         display_order  = NVL(APEX_JSON.get_number(p_path=>'displayOrder'), display_order),
         is_default     = NVL(l_def, is_default),
         is_active      = NVL(APEX_JSON.get_varchar2(p_path=>'isActive'), is_active),
         updated_by = l_user, updated_at = SYSTIMESTAMP
   WHERE value_id = [COLON]id;
  IF l_def = 'Y' THEN
    UPDATE dct_lookup_values SET is_default = 'N'
     WHERE category_id = l_cat AND value_id <> [COLON]id AND is_default = 'Y';
  END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE=-2290 THEN dct_rest.err(400,'End date must be on or after the start date');
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

END setup_kpi2_ords_tmp;
/

BEGIN setup_kpi2_ords_tmp; COMMIT; END;
/

DROP PROCEDURE setup_kpi2_ords_tmp;

PROMPT == verification ==
SELECT uri_template, method
  FROM user_ords_handlers h JOIN user_ords_templates t ON t.id = h.template_id
 WHERE t.uri_template LIKE 'v2/%'
 ORDER BY 1, 2;
