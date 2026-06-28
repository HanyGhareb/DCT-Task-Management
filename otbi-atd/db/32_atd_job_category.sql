-- ===========================================================================
-- otbi-atd : 32 Job Categories  (ATD-native lookup + job tagging)
--   * ATD_JOB_CATEGORY      -> the category lookup (code, EN/AR name, color,
--     order, active). Managed in-app on the Jobs page ("Manage Categories").
--   * ATD_JOB_CATEGORY_MAP  -> job <-> category (many-to-many, no per-job cap;
--     PK prevents duplicate tags; FK job_name ON DELETE CASCADE clears tags
--     when a job is deleted).
--   * additive ORDS: GET/POST /atd/categories, PUT/DELETE /atd/categories/:code
-- DDL is rerunnable (CREATE guarded against ORA-00955; never drops existing data).
-- Additive ORDS only (DEFINE_TEMPLATE/DEFINE_HANDLER on the live atd.rest) -> no
-- DELETE_MODULE. Run in a FRESH session (synonym rule). Job tagging (categories
-- on /jobs create/update/list/detail) lives in db/13. Schema-qualified PROD.
-- CRLF / UTF-8 no BOM (deploy with -Dfile.encoding=UTF-8 for the Arabic seed).
-- [COLON] -> ':' at define.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO ON

-- ---- category lookup table ----
BEGIN
  EXECUTE IMMEDIATE q'[CREATE TABLE prod.atd_job_category (
    category_code  VARCHAR2(30)  NOT NULL,
    name_en        VARCHAR2(100) NOT NULL,
    name_ar        VARCHAR2(200),
    color          VARCHAR2(9),
    display_order  NUMBER DEFAULT 100,
    active         CHAR(1) DEFAULT 'Y' NOT NULL,
    created_at     TIMESTAMP DEFAULT SYSTIMESTAMP,
    created_by     VARCHAR2(100),
    updated_at     TIMESTAMP,
    updated_by     VARCHAR2(100),
    CONSTRAINT pk_atd_job_category   PRIMARY KEY (category_code),
    CONSTRAINT ck_atd_jobcat_active  CHECK (active IN ('Y','N'))
  )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;  -- already exists
END;
/

-- ---- job <-> category junction (no per-job cap; PK blocks duplicates) ----
BEGIN
  EXECUTE IMMEDIATE q'[CREATE TABLE prod.atd_job_category_map (
    job_name       VARCHAR2(80) NOT NULL,
    category_code  VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_atd_jobcat_map PRIMARY KEY (job_name, category_code),
    CONSTRAINT fk_atd_jcm_job FOREIGN KEY (job_name)
      REFERENCES prod.atd_otbi_jobs (job_name) ON DELETE CASCADE,
    CONSTRAINT fk_atd_jcm_cat FOREIGN KEY (category_code)
      REFERENCES prod.atd_job_category (category_code)
  )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_atd_jcm_cat ON prod.atd_job_category_map (category_code)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- ---- starter categories (MERGE = never overwrite operator edits on rerun) ----
MERGE INTO prod.atd_job_category t USING (SELECT 'AP' code FROM dual) s ON (t.category_code=s.code)
WHEN NOT MATCHED THEN INSERT (category_code,name_en,name_ar,color,display_order)
  VALUES ('AP','Accounts Payable','الذمم الدائنة','#B0721E',10);
MERGE INTO prod.atd_job_category t USING (SELECT 'GL' code FROM dual) s ON (t.category_code=s.code)
WHEN NOT MATCHED THEN INSERT (category_code,name_en,name_ar,color,display_order)
  VALUES ('GL','General Ledger','دفتر الأستاذ العام','#2C6CB0',20);
MERGE INTO prod.atd_job_category t USING (SELECT 'PO' code FROM dual) s ON (t.category_code=s.code)
WHEN NOT MATCHED THEN INSERT (category_code,name_en,name_ar,color,display_order)
  VALUES ('PO','Purchasing','المشتريات','#2A7D3A',30);
MERGE INTO prod.atd_job_category t USING (SELECT 'SUPPLIER' code FROM dual) s ON (t.category_code=s.code)
WHEN NOT MATCHED THEN INSERT (category_code,name_en,name_ar,color,display_order)
  VALUES ('SUPPLIER','Suppliers','الموردون','#7C4DBE',40);
MERGE INTO prod.atd_job_category t USING (SELECT 'MASTER' code FROM dual) s ON (t.category_code=s.code)
WHEN NOT MATCHED THEN INSERT (category_code,name_en,name_ar,color,display_order)
  VALUES ('MASTER','Master Data','البيانات الرئيسية','#5A6570',50);
MERGE INTO prod.atd_job_category t USING (SELECT 'FINANCE' code FROM dual) s ON (t.category_code=s.code)
WHEN NOT MATCHED THEN INSERT (category_code,name_en,name_ar,color,display_order)
  VALUES ('FINANCE','Finance','المالية','#C13A30',60);
COMMIT;

-- ---- ADMIN synonyms for the objects the handlers touch ----
CREATE OR REPLACE SYNONYM atd_job_category     FOR prod.atd_job_category;
CREATE OR REPLACE SYNONYM atd_job_category_map FOR prod.atd_job_category_map;

-- ---- additive ORDS: category CRUD ----
CREATE OR REPLACE PROCEDURE setup_atd_category_ords_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'atd.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method => p_method, p_source_type => ORDS.source_type_plsql,
            p_source => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    -- =========================================================================
    -- GET /categories  -- all categories + usage count
    -- =========================================================================
    def_template('categories');
    def_handler('categories', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT c.category_code, c.name_en, c.name_ar, c.color, c.display_order, c.active,
                   c.parent_code,
                   (SELECT p.name_en FROM atd_job_category p WHERE p.category_code=c.parent_code) AS parent_name,
                   (SELECT COUNT(*) FROM atd_job_category_map m WHERE m.category_code=c.category_code) AS usage
              FROM atd_job_category c
             ORDER BY NVL(c.parent_code, c.category_code), c.parent_code NULLS FIRST,
                      c.display_order, c.category_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.category_code);
    APEX_JSON.write('nameEn', r.name_en);
    APEX_JSON.write('nameAr', NVL(r.name_ar,''));
    APEX_JSON.write('color', NVL(r.color,''));
    APEX_JSON.write('displayOrder', r.display_order);
    APEX_JSON.write('active', r.active);
    APEX_JSON.write('parentCode', NVL(r.parent_code,''));
    APEX_JSON.write('parentName', NVL(r.parent_name,''));
    APEX_JSON.write('usage', r.usage);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- POST /categories  -- create
    -- =========================================================================
    def_handler('categories', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_code VARCHAR2(30);
  l_name VARCHAR2(100);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_code := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'code')));
  l_name := APEX_JSON.get_varchar2(p_path=>'nameEn');
  IF l_code IS NULL OR l_name IS NULL THEN dct_rest.err(400,'code and nameEn are required'); RETURN; END IF;
  INSERT INTO atd_job_category (category_code, name_en, name_ar, color, display_order, active, parent_code, created_by)
  VALUES (l_code, l_name, APEX_JSON.get_varchar2(p_path=>'nameAr'),
          APEX_JSON.get_varchar2(p_path=>'color'),
          NVL(APEX_JSON.get_number(p_path=>'displayOrder'),100),
          NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'active')),'Y'),
          NULLIF(UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'parentCode'))), l_code), l_user);
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.write('code', l_code); APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(400,'A category with that code already exists');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- PUT /categories/:code  -- update (does_exist guards = partial update)
    -- =========================================================================
    def_template('categories/[COLON]code');
    def_handler('categories/[COLON]code', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE atd_job_category SET
    name_en       = CASE WHEN APEX_JSON.does_exist(p_path=>'nameEn')       THEN APEX_JSON.get_varchar2(p_path=>'nameEn')       ELSE name_en END,
    name_ar       = CASE WHEN APEX_JSON.does_exist(p_path=>'nameAr')       THEN APEX_JSON.get_varchar2(p_path=>'nameAr')       ELSE name_ar END,
    color         = CASE WHEN APEX_JSON.does_exist(p_path=>'color')        THEN APEX_JSON.get_varchar2(p_path=>'color')        ELSE color END,
    display_order = CASE WHEN APEX_JSON.does_exist(p_path=>'displayOrder') THEN APEX_JSON.get_number(p_path=>'displayOrder')   ELSE display_order END,
    active        = CASE WHEN APEX_JSON.does_exist(p_path=>'active')       THEN UPPER(APEX_JSON.get_varchar2(p_path=>'active')) ELSE active END,
    parent_code   = CASE WHEN APEX_JSON.does_exist(p_path=>'parentCode')
                         THEN NULLIF(UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'parentCode'))), UPPER([COLON]code))
                         ELSE parent_code END,
    updated_at    = SYSTIMESTAMP, updated_by = l_user
  WHERE category_code = UPPER([COLON]code);
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Category not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- DELETE /categories/:code  -- hard-delete only when unused (else deactivate)
    -- =========================================================================
    def_handler('categories/[COLON]code', 'DELETE', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_usage NUMBER;
  l_n     NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*) INTO l_usage FROM atd_job_category_map WHERE category_code = UPPER([COLON]code);
  IF l_usage > 0 THEN
    dct_rest.err(400,'Category is in use by '||l_usage||' job(s) - deactivate it instead'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_usage FROM atd_job_category WHERE parent_code = UPPER([COLON]code);
  IF l_usage > 0 THEN
    dct_rest.err(400,'Category has '||l_usage||' sub-categor(y/ies) - remove or reparent them first'); RETURN;
  END IF;
  DELETE FROM atd_job_category WHERE category_code = UPPER([COLON]code);
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Category not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

END setup_atd_category_ords_tmp;
/

BEGIN
  setup_atd_category_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE setup_atd_category_ords_tmp;

SET ECHO OFF
PROMPT otbi-atd 32 job category : done
