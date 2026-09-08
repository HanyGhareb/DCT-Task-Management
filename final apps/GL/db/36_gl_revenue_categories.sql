-- =============================================================================
-- General Ledger (App 210) -- Revenue Categories (ADDITIVE)
-- Run: sql -name prod_mcp @36_gl_revenue_categories.sql  (fresh session)
-- Adds GL-owned category hierarchy, FPB-style mapping rules, access grants,
-- and CRUD routes under /ords/admin/gl/revenue-categories.
-- Re-run after 05_gl_ords.sql (post-05 additive list = 07..36).
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

DECLARE
  PROCEDURE ddl(p_sql CLOB, p_ign NUMBER DEFAULT NULL) IS
  BEGIN EXECUTE IMMEDIATE p_sql;
  EXCEPTION WHEN OTHERS THEN IF p_ign IS NULL OR SQLCODE <> p_ign THEN RAISE; END IF;
  END;
BEGIN
  ddl(q'~CREATE TABLE prod.gl_revenue_category (
    category_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_code VARCHAR2(60) NOT NULL,
    name_en VARCHAR2(200) NOT NULL,
    name_ar VARCHAR2(200),
    category_level VARCHAR2(10) NOT NULL,
    parent_category_id NUMBER,
    revenue_source VARCHAR2(20) NOT NULL,
    description VARCHAR2(1000),
    default_priority NUMBER(6) DEFAULT 100 NOT NULL,
    is_active VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    created_by VARCHAR2(100), created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by VARCHAR2(100), updated_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT uq_gl_revcat_code UNIQUE(category_code),
    CONSTRAINT ck_gl_revcat_level CHECK(category_level IN ('MAIN','SUB')),
    CONSTRAINT ck_gl_revcat_source CHECK(revenue_source IN ('AR_TRANSACTION','MISC_RECEIPT','BOTH')),
    CONSTRAINT ck_gl_revcat_active CHECK(is_active IN ('Y','N')),
    CONSTRAINT ck_gl_revcat_parent CHECK((category_level='MAIN' AND parent_category_id IS NULL) OR (category_level='SUB' AND parent_category_id IS NOT NULL)),
    CONSTRAINT fk_gl_revcat_parent FOREIGN KEY(parent_category_id) REFERENCES prod.gl_revenue_category(category_id)
  )~', -955);
  ddl('CREATE INDEX prod.ix_gl_revcat_parent ON prod.gl_revenue_category(parent_category_id)', -955);

  ddl(q'~CREATE TABLE prod.gl_revenue_category_rule (
    rule_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_id NUMBER NOT NULL,
    revenue_source VARCHAR2(20) NOT NULL,
    priority NUMBER(6) DEFAULT 100 NOT NULL,
    transaction_type VARCHAR2(200) DEFAULT 'ALL' NOT NULL,
    transaction_source VARCHAR2(200) DEFAULT 'ALL' NOT NULL,
    revenue_type VARCHAR2(200) DEFAULT 'ALL' NOT NULL,
    cost_center VARCHAR2(100) DEFAULT 'ALL' NOT NULL,
    gl_account VARCHAR2(100) DEFAULT 'ALL' NOT NULL,
    project_number VARCHAR2(100) DEFAULT 'ALL' NOT NULL,
    task_number VARCHAR2(100) DEFAULT 'ALL' NOT NULL,
    customer_number VARCHAR2(100) DEFAULT 'ALL' NOT NULL,
    is_active VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    created_by VARCHAR2(100), created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by VARCHAR2(100), updated_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT fk_gl_revrule_cat FOREIGN KEY(category_id) REFERENCES prod.gl_revenue_category(category_id),
    CONSTRAINT ck_gl_revrule_source CHECK(revenue_source IN ('AR_TRANSACTION','MISC_RECEIPT')),
    CONSTRAINT ck_gl_revrule_active CHECK(is_active IN ('Y','N'))
  )~', -955);
  ddl('CREATE INDEX prod.ix_gl_revrule_cat ON prod.gl_revenue_category_rule(category_id, priority)', -955);

  ddl(q'~CREATE TABLE prod.gl_revenue_category_access (
    access_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_id NUMBER NOT NULL,
    principal_type VARCHAR2(10) NOT NULL,
    principal_id NUMBER NOT NULL,
    include_children VARCHAR2(1) DEFAULT 'N' NOT NULL,
    is_active VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    created_by VARCHAR2(100), created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by VARCHAR2(100), updated_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT fk_gl_revaccess_cat FOREIGN KEY(category_id) REFERENCES prod.gl_revenue_category(category_id),
    CONSTRAINT uq_gl_revaccess UNIQUE(category_id, principal_type, principal_id),
    CONSTRAINT ck_gl_revaccess_type CHECK(principal_type IN ('ROLE','USER')),
    CONSTRAINT ck_gl_revaccess_child CHECK(include_children IN ('Y','N')),
    CONSTRAINT ck_gl_revaccess_active CHECK(is_active IN ('Y','N'))
  )~', -955);
  ddl('CREATE INDEX prod.ix_gl_revaccess_principal ON prod.gl_revenue_category_access(principal_type, principal_id)', -955);
END;
/

CREATE OR REPLACE TRIGGER prod.gl_revenue_category_biu
FOR INSERT OR UPDATE ON prod.gl_revenue_category
COMPOUND TRIGGER
  BEFORE EACH ROW IS
  BEGIN
    :NEW.category_code := UPPER(TRIM(:NEW.category_code));
    :NEW.updated_at := SYSTIMESTAMP;
    IF :NEW.category_level='SUB' AND :NEW.parent_category_id=:NEW.category_id THEN
      RAISE_APPLICATION_ERROR(-20001,'A category cannot be its own parent');
    END IF;
  END BEFORE EACH ROW;
  AFTER STATEMENT IS
    l_bad NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_bad FROM prod.gl_revenue_category c
      LEFT JOIN prod.gl_revenue_category p ON p.category_id=c.parent_category_id
     WHERE c.category_level='SUB' AND (p.category_id IS NULL OR p.category_level<>'MAIN' OR p.is_active<>'Y');
    IF l_bad>0 THEN RAISE_APPLICATION_ERROR(-20001,'Parent must be an active main category'); END IF;
  END AFTER STATEMENT;
END;
/

CREATE OR REPLACE PROCEDURE setup_gl_revcat_ords_tmp AS
  c_mod CONSTANT VARCHAR2(30) := 'gl.rest';
  PROCEDURE dt(p VARCHAR2) IS BEGIN ORDS.DEFINE_TEMPLATE(p_module_name=>c_mod, p_pattern=>REPLACE(p,'[COLON]',CHR(58))); END;
  PROCEDURE dh(p VARCHAR2, m VARCHAR2, s CLOB) IS
  BEGIN ORDS.DEFINE_HANDLER(p_module_name=>c_mod, p_pattern=>REPLACE(p,'[COLON]',CHR(58)), p_method=>m,
    p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(s,'[COLON]',CHR(58))); END;
BEGIN
  dt('revenue-categories');
  dh('revenue-categories','GET',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
 dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
 APEX_JSON.write('canManage',CASE WHEN prod.dct_sec.has_priv_or_role(l_user,'GL_MANAGE_REVENUE_CATEGORIES','SYS_ADMIN','GL') THEN 'Y' ELSE 'N' END);
 APEX_JSON.open_array('categories');
 FOR c IN (SELECT c.*, p.name_en parent_name,
   TO_CHAR(dct_to_local(c.created_at),'YYYY-MM-DD HH[COLON]MI AM') created_on,
   TO_CHAR(dct_to_local(c.updated_at),'YYYY-MM-DD HH[COLON]MI AM') updated_on,
   (SELECT COUNT(*) FROM prod.gl_revenue_category x WHERE x.parent_category_id=c.category_id) child_count,
   (SELECT COUNT(*) FROM prod.gl_revenue_category_rule r WHERE r.category_id=c.category_id) rule_count,
   (SELECT COUNT(*) FROM prod.gl_revenue_category_access a WHERE a.category_id=c.category_id) access_count
   FROM prod.gl_revenue_category c LEFT JOIN prod.gl_revenue_category p ON p.category_id=c.parent_category_id
   ORDER BY NVL(c.parent_category_id,c.category_id), c.category_level, c.name_en) LOOP
   APEX_JSON.open_object; APEX_JSON.write('categoryId',c.category_id); APEX_JSON.write('code',c.category_code);
   APEX_JSON.write('nameEn',c.name_en); APEX_JSON.write('nameAr',NVL(c.name_ar,''));
   APEX_JSON.write('level',c.category_level); APEX_JSON.write('parentId',c.parent_category_id);
   APEX_JSON.write('parentName',NVL(c.parent_name,'')); APEX_JSON.write('source',c.revenue_source);
   APEX_JSON.write('description',NVL(c.description,'')); APEX_JSON.write('priority',c.default_priority);
   APEX_JSON.write('createdBy',NVL(c.created_by,'')); APEX_JSON.write('createdOn',c.created_on);
   APEX_JSON.write('updatedBy',NVL(c.updated_by,'')); APEX_JSON.write('updatedOn',c.updated_on);
   APEX_JSON.write('active',c.is_active); APEX_JSON.write('childCount',c.child_count);
   APEX_JSON.write('ruleCount',c.rule_count); APEX_JSON.write('accessCount',c.access_count); APEX_JSON.close_object;
 END LOOP; APEX_JSON.close_array;
 APEX_JSON.open_array('rules');
 FOR r IN (SELECT r.*, c.name_en category_name, p.name_en parent_name,
   TO_CHAR(dct_to_local(r.created_at),'YYYY-MM-DD HH[COLON]MI AM') created_on,
   TO_CHAR(dct_to_local(r.updated_at),'YYYY-MM-DD HH[COLON]MI AM') updated_on
   FROM prod.gl_revenue_category_rule r JOIN prod.gl_revenue_category c ON c.category_id=r.category_id
   LEFT JOIN prod.gl_revenue_category p ON p.category_id=c.parent_category_id ORDER BY r.priority,r.rule_id) LOOP
   APEX_JSON.open_object; APEX_JSON.write('ruleId',r.rule_id); APEX_JSON.write('categoryId',r.category_id);
   APEX_JSON.write('categoryName',r.category_name); APEX_JSON.write('parentName',NVL(r.parent_name,''));
   APEX_JSON.write('source',r.revenue_source); APEX_JSON.write('priority',r.priority);
   APEX_JSON.write('transactionType',r.transaction_type); APEX_JSON.write('transactionSource',r.transaction_source);
   APEX_JSON.write('revenueType',r.revenue_type); APEX_JSON.write('costCenter',r.cost_center);
   APEX_JSON.write('glAccount',r.gl_account); APEX_JSON.write('projectNumber',r.project_number);
   APEX_JSON.write('taskNumber',r.task_number); APEX_JSON.write('customerNumber',r.customer_number);
   APEX_JSON.write('active',r.is_active); APEX_JSON.write('createdBy',NVL(r.created_by,'')); APEX_JSON.write('createdOn',r.created_on);
   APEX_JSON.write('updatedBy',NVL(r.updated_by,'')); APEX_JSON.write('updatedOn',r.updated_on); APEX_JSON.close_object;
 END LOOP; APEX_JSON.close_array;
 APEX_JSON.open_array('access');
 FOR a IN (SELECT a.*, c.name_en category_name, p.name_en parent_name,
   TO_CHAR(dct_to_local(a.created_at),'YYYY-MM-DD HH[COLON]MI AM') created_on,
   TO_CHAR(dct_to_local(a.updated_at),'YYYY-MM-DD HH[COLON]MI AM') updated_on,
   CASE a.principal_type WHEN 'ROLE' THEN r.role_name_en ELSE u.display_name END principal_name
   FROM prod.gl_revenue_category_access a JOIN prod.gl_revenue_category c ON c.category_id=a.category_id
   LEFT JOIN prod.gl_revenue_category p ON p.category_id=c.parent_category_id
   LEFT JOIN prod.dct_roles r ON a.principal_type='ROLE' AND r.role_id=a.principal_id
   LEFT JOIN prod.dct_users u ON a.principal_type='USER' AND u.user_id=a.principal_id ORDER BY principal_name, category_name) LOOP
   APEX_JSON.open_object; APEX_JSON.write('accessId',a.access_id); APEX_JSON.write('categoryId',a.category_id);
   APEX_JSON.write('categoryName',a.category_name); APEX_JSON.write('parentName',NVL(a.parent_name,''));
   APEX_JSON.write('principalType',a.principal_type); APEX_JSON.write('principalId',a.principal_id);
   APEX_JSON.write('principalName',NVL(a.principal_name,'Unknown')); APEX_JSON.write('includeChildren',a.include_children);
   APEX_JSON.write('active',a.is_active); APEX_JSON.write('createdBy',NVL(a.created_by,'')); APEX_JSON.write('createdOn',a.created_on);
   APEX_JSON.write('updatedBy',NVL(a.updated_by,'')); APEX_JSON.write('updatedOn',a.updated_on); APEX_JSON.close_object;
 END LOOP; APEX_JSON.close_array;
 APEX_JSON.open_array('roles'); FOR x IN (SELECT role_id,role_name_en FROM prod.dct_roles WHERE is_active='Y' ORDER BY role_name_en) LOOP
   APEX_JSON.open_object; APEX_JSON.write('id',x.role_id); APEX_JSON.write('name',x.role_name_en); APEX_JSON.close_object; END LOOP; APEX_JSON.close_array;
 APEX_JSON.open_array('users'); FOR x IN (SELECT user_id,display_name FROM prod.dct_users WHERE is_active='Y' ORDER BY display_name) LOOP
   APEX_JSON.open_object; APEX_JSON.write('id',x.user_id); APEX_JSON.write('name',x.display_name); APEX_JSON.close_object; END LOOP; APEX_JSON.close_array;
 APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM); END;!');

  dt('revenue-categories/lov');
  dh('revenue-categories/lov','GET',q'!
DECLARE
 l_user VARCHAR2(100):=dct_rest.validate_session;
 l_kind VARCHAR2(30):=UPPER(TRIM([COLON]kind));
 l_search VARCHAR2(200):=UPPER(TRIM([COLON]search));
 l_project VARCHAR2(100):=TRIM([COLON]project);
 PROCEDURE item(p_value VARCHAR2,p_label VARCHAR2,p_detail VARCHAR2 DEFAULT NULL) IS
 BEGIN APEX_JSON.open_object; APEX_JSON.write('value',p_value); APEX_JSON.write('label',p_label); APEX_JSON.write('detail',NVL(p_detail,'')); APEX_JSON.close_object; END;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
 IF l_kind NOT IN ('TRANSACTION_TYPE','TRANSACTION_SOURCE','REVENUE_TYPE','COST_CENTER','GL_ACCOUNT','PROJECT','TASK','CUSTOMER') THEN dct_rest.err(400,'Invalid LOV kind'); RETURN; END IF;
 dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
 item('ALL','ALL — All values');
 IF l_kind='TRANSACTION_TYPE' THEN
  FOR x IN (SELECT value FROM (SELECT DISTINCT TRIM(transaction_type_name) value FROM prod.ar_transaction_details_v WHERE transaction_type_name IS NOT NULL AND (l_search IS NULL OR UPPER(transaction_type_name) LIKE '%'||l_search||'%') ORDER BY 1) WHERE ROWNUM<=100) LOOP item(x.value,x.value); END LOOP;
 ELSIF l_kind='TRANSACTION_SOURCE' THEN
  FOR x IN (SELECT value FROM (SELECT DISTINCT TRIM(transaction_source) value FROM prod.ar_transaction_details_v WHERE transaction_source IS NOT NULL AND (l_search IS NULL OR UPPER(transaction_source) LIKE '%'||l_search||'%') ORDER BY 1) WHERE ROWNUM<=100) LOOP item(x.value,x.value); END LOOP;
 ELSIF l_kind='REVENUE_TYPE' THEN
  FOR x IN (SELECT value,detail FROM (SELECT DISTINCT TRIM(revenue_type) value, TRIM(service_name) detail FROM prod.atd_ar_revenue_types WHERE revenue_type IS NOT NULL AND (l_search IS NULL OR UPPER(revenue_type||' '||service_name) LIKE '%'||l_search||'%') ORDER BY 1,2) WHERE ROWNUM<=100) LOOP item(x.value,x.value,x.detail); END LOOP;
 ELSIF l_kind='COST_CENTER' THEN
  FOR x IN (SELECT value,detail FROM (SELECT DISTINCT TRIM(cost_center) value,TRIM(cost_center_description) detail FROM prod.atd_gl_cost_centers_list WHERE cost_center IS NOT NULL AND (l_search IS NULL OR UPPER(cost_center||' '||cost_center_description) LIKE '%'||l_search||'%') ORDER BY 1) WHERE ROWNUM<=100) LOOP item(x.value,x.value,x.detail); END LOOP;
 ELSIF l_kind='GL_ACCOUNT' THEN
  FOR x IN (SELECT value,detail FROM (SELECT DISTINCT TRIM(account_code) value,TRIM(account_description) detail FROM prod.atd_gl_account_list WHERE account_code IS NOT NULL AND (l_search IS NULL OR UPPER(account_code||' '||account_description) LIKE '%'||l_search||'%') ORDER BY 1) WHERE ROWNUM<=100) LOOP item(x.value,x.value,x.detail); END LOOP;
 ELSIF l_kind='PROJECT' THEN
  FOR x IN (SELECT value,detail FROM (SELECT DISTINCT TRIM(project_number) value,TRIM(project_name) detail FROM prod.projects WHERE project_number IS NOT NULL AND (l_search IS NULL OR UPPER(project_number||' '||project_name) LIKE '%'||l_search||'%') ORDER BY 1) WHERE ROWNUM<=100) LOOP item(x.value,x.value,x.detail); END LOOP;
 ELSIF l_kind='TASK' AND l_project IS NOT NULL AND l_project<>'ALL' THEN
  FOR x IN (SELECT value,detail FROM (SELECT DISTINCT TRIM(t.task_number) value,TRIM(t.task_name) detail FROM prod.tasks t JOIN prod.projects p ON p.project_id=t.project_id WHERE p.project_number=l_project AND t.task_number IS NOT NULL AND (l_search IS NULL OR UPPER(t.task_number||' '||t.task_name) LIKE '%'||l_search||'%') ORDER BY 1) WHERE ROWNUM<=100) LOOP item(x.value,x.value,x.detail); END LOOP;
 ELSIF l_kind='CUSTOMER' THEN
  FOR x IN (SELECT value FROM (SELECT DISTINCT TRIM(bill_to_customer_number) value FROM prod.ar_transaction_details_v WHERE bill_to_customer_number IS NOT NULL AND (l_search IS NULL OR UPPER(bill_to_customer_number) LIKE '%'||l_search||'%') ORDER BY 1) WHERE ROWNUM<=100) LOOP item(x.value,x.value); END LOOP;
 END IF;
 APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM); END;!');

  dh('revenue-categories','POST',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session; l_id NUMBER; l_level VARCHAR2(10); l_parent NUMBER;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
 IF NOT prod.dct_sec.has_priv_or_role(l_user,'GL_MANAGE_REVENUE_CATEGORIES','SYS_ADMIN','GL') THEN dct_rest.err(403,'Management privilege required'); RETURN; END IF;
 dct_rest.parse_body([COLON]body); l_level:=UPPER(APEX_JSON.get_varchar2('level')); l_parent:=APEX_JSON.get_number('parentId');
 INSERT INTO prod.gl_revenue_category(category_code,name_en,name_ar,category_level,parent_category_id,revenue_source,description,default_priority,is_active,created_by,updated_by)
 VALUES(APEX_JSON.get_varchar2('code'),APEX_JSON.get_varchar2('nameEn'),APEX_JSON.get_varchar2('nameAr'),l_level,l_parent,
   UPPER(APEX_JSON.get_varchar2('source')),APEX_JSON.get_varchar2('description'),NVL(APEX_JSON.get_number('priority'),100),NVL(APEX_JSON.get_varchar2('active'),'Y'),l_user,l_user)
 RETURNING category_id INTO l_id; COMMIT; dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('categoryId',l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; IF SQLCODE IN(-1,-20001,-2291,-2290,-1400) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF; END;!');

  dt('revenue-categories/[COLON]id');
  dh('revenue-categories/[COLON]id','PUT',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN
 IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
 IF NOT prod.dct_sec.has_priv_or_role(l_user,'GL_MANAGE_REVENUE_CATEGORIES','SYS_ADMIN','GL') THEN dct_rest.err(403,'Management privilege required'); RETURN; END IF;
 dct_rest.parse_body([COLON]body);
 UPDATE prod.gl_revenue_category SET category_code=APEX_JSON.get_varchar2('code'),name_en=APEX_JSON.get_varchar2('nameEn'),name_ar=APEX_JSON.get_varchar2('nameAr'),
  category_level=UPPER(APEX_JSON.get_varchar2('level')),parent_category_id=APEX_JSON.get_number('parentId'),revenue_source=UPPER(APEX_JSON.get_varchar2('source')),
  description=APEX_JSON.get_varchar2('description'),default_priority=NVL(APEX_JSON.get_number('priority'),100),is_active=NVL(APEX_JSON.get_varchar2('active'),'Y'),updated_by=l_user
 WHERE category_id=[COLON]id; IF SQL%ROWCOUNT=0 THEN dct_rest.err(404,'Category not found'); RETURN; END IF;
 COMMIT; dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; IF SQLCODE IN(-1,-20001,-2291,-2290,-1400) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF; END;!');
  dh('revenue-categories/[COLON]id','DELETE',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session;
BEGIN IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
 IF NOT prod.dct_sec.has_priv_or_role(l_user,'GL_MANAGE_REVENUE_CATEGORIES','SYS_ADMIN','GL') THEN dct_rest.err(403,'Management privilege required'); RETURN; END IF;
 DELETE FROM prod.gl_revenue_category WHERE category_id=[COLON]id; IF SQL%ROWCOUNT=0 THEN dct_rest.err(404,'Category not found'); RETURN; END IF; COMMIT; dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; IF SQLCODE=-2292 THEN dct_rest.err(409,'Remove child categories, rules and access grants first'); ELSE dct_rest.err(500,SQLERRM); END IF; END;!');

  dt('revenue-categories/rules');
  dh('revenue-categories/rules','POST',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session; l_id NUMBER; l_n NUMBER;
 FUNCTION v(p VARCHAR2) RETURN VARCHAR2 IS x VARCHAR2(4000):=TRIM(APEX_JSON.get_varchar2(p)); BEGIN RETURN NVL(x,'ALL'); END;
BEGIN IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
 IF NOT prod.dct_sec.has_priv_or_role(l_user,'GL_MANAGE_REVENUE_CATEGORIES','SYS_ADMIN','GL') THEN dct_rest.err(403,'Management privilege required'); RETURN; END IF;
 dct_rest.parse_body([COLON]body);
 SELECT COUNT(*) INTO l_n FROM prod.gl_revenue_category WHERE category_id=APEX_JSON.get_number('categoryId') AND category_level='SUB' AND is_active='Y';
 IF l_n=0 THEN dct_rest.err(400,'Mapping rules require an active subcategory'); RETURN; END IF;
 INSERT INTO prod.gl_revenue_category_rule(category_id,revenue_source,priority,transaction_type,transaction_source,revenue_type,cost_center,gl_account,project_number,task_number,customer_number,is_active,created_by,updated_by)
 VALUES(APEX_JSON.get_number('categoryId'),UPPER(APEX_JSON.get_varchar2('source')),NVL(APEX_JSON.get_number('priority'),100),v('transactionType'),v('transactionSource'),v('revenueType'),v('costCenter'),v('glAccount'),v('projectNumber'),v('taskNumber'),v('customerNumber'),NVL(APEX_JSON.get_varchar2('active'),'Y'),l_user,l_user)
 RETURNING rule_id INTO l_id; COMMIT; dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ruleId',l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; IF SQLCODE IN(-2291,-2290,-1400) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF; END;!');
  dt('revenue-categories/rules/[COLON]id');
  dh('revenue-categories/rules/[COLON]id','DELETE',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session; BEGIN IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
 IF NOT prod.dct_sec.has_priv_or_role(l_user,'GL_MANAGE_REVENUE_CATEGORIES','SYS_ADMIN','GL') THEN dct_rest.err(403,'Management privilege required'); RETURN; END IF;
 DELETE FROM prod.gl_revenue_category_rule WHERE rule_id=[COLON]id; IF SQL%ROWCOUNT=0 THEN dct_rest.err(404,'Rule not found'); RETURN; END IF; COMMIT; dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500,SQLERRM); END;!');

  dt('revenue-categories/access');
  dh('revenue-categories/access','POST',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session; l_id NUMBER; l_type VARCHAR2(10); l_pid NUMBER; l_n NUMBER; l_inc VARCHAR2(1);
BEGIN IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
 IF NOT prod.dct_sec.has_priv_or_role(l_user,'GL_MANAGE_REVENUE_CATEGORIES','SYS_ADMIN','GL') THEN dct_rest.err(403,'Management privilege required'); RETURN; END IF;
 dct_rest.parse_body([COLON]body); l_type:=UPPER(APEX_JSON.get_varchar2('principalType')); l_pid:=APEX_JSON.get_number('principalId'); l_inc:=NVL(APEX_JSON.get_varchar2('includeChildren'),'N');
 IF l_type NOT IN ('ROLE','USER') THEN dct_rest.err(400,'principalType must be ROLE or USER'); RETURN; END IF;
 IF l_type='ROLE' THEN SELECT COUNT(*) INTO l_n FROM prod.dct_roles WHERE role_id=l_pid AND is_active='Y'; ELSE SELECT COUNT(*) INTO l_n FROM prod.dct_users WHERE user_id=l_pid AND is_active='Y'; END IF;
 IF l_n=0 THEN dct_rest.err(400,'Active principal not found'); RETURN; END IF;
 IF l_inc='Y' THEN SELECT COUNT(*) INTO l_n FROM prod.gl_revenue_category WHERE category_id=APEX_JSON.get_number('categoryId') AND category_level='MAIN'; IF l_n=0 THEN dct_rest.err(400,'Only a main category can include subcategories'); RETURN; END IF; END IF;
 INSERT INTO prod.gl_revenue_category_access(category_id,principal_type,principal_id,include_children,is_active,created_by,updated_by)
 VALUES(APEX_JSON.get_number('categoryId'),l_type,l_pid,l_inc,NVL(APEX_JSON.get_varchar2('active'),'Y'),l_user,l_user)
 RETURNING access_id INTO l_id; COMMIT; dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('accessId',l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; IF SQLCODE IN(-1,-2291,-2290,-1400) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF; END;!');
  dt('revenue-categories/access/[COLON]id');
  dh('revenue-categories/access/[COLON]id','DELETE',q'!
DECLARE l_user VARCHAR2(100):=dct_rest.validate_session; BEGIN IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
 IF NOT prod.dct_sec.has_priv_or_role(l_user,'GL_MANAGE_REVENUE_CATEGORIES','SYS_ADMIN','GL') THEN dct_rest.err(403,'Management privilege required'); RETURN; END IF;
 DELETE FROM prod.gl_revenue_category_access WHERE access_id=[COLON]id; IF SQL%ROWCOUNT=0 THEN dct_rest.err(404,'Access grant not found'); RETURN; END IF; COMMIT; dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500,SQLERRM); END;!');
  COMMIT;
END;
/
BEGIN setup_gl_revcat_ords_tmp; END;
/
DROP PROCEDURE setup_gl_revcat_ords_tmp;

PROMPT === Revenue Categories verification ===
SELECT table_name FROM all_tables WHERE owner='PROD' AND table_name IN ('GL_REVENUE_CATEGORY','GL_REVENUE_CATEGORY_RULE','GL_REVENUE_CATEGORY_ACCESS') ORDER BY 1;
SELECT t.uri_template, h.method FROM user_ords_handlers h JOIN user_ords_templates t ON t.id=h.template_id
 JOIN user_ords_modules m ON m.id=t.module_id WHERE m.name='gl.rest' AND t.uri_template LIKE 'revenue-categories%' ORDER BY 1,2;
