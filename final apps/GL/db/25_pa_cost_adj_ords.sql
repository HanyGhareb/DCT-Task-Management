-- =============================================================================
-- General Ledger (App 210) -- Projects Costing Adjustments endpoints (ADDITIVE)
-- File    : 25_pa_cost_adj_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp (fresh session, as ADMIN)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            the GL post-05 re-run list is now 07..25.
-- Needs   : db/v2/124_pa_cost_adj.sql deployed first.
-- Purpose : manual signed cost adjustments (plus/minus AED) on a budget line,
--           optionally referencing the mis-coded AP invoice distribution and
--           optionally carrying a signed BUDGET_OVERRIDE for the same line.
--           APPROVED rows fold into /gl/butil behind costadj=Y (GL/db/21).
-- Endpoints:
--   GET    /gl/costadj                 register (year/status/search, cap 2000)
--   POST   /gl/costadj                 create DRAFT
--   PUT    /gl/costadj/:id            full-document edit (DRAFT only)
--   DELETE /gl/costadj/:id            remove (manage gate, any status)
--   POST   /gl/costadj/:id/action    {action: APPROVE|REJECT, note} on DRAFT
--   GET    /gl/costadj/meta/dists     AP invoice distribution search (cap 50)
--   GET    /gl/costadj/meta/lookups   classification + status LOVs
--   GET    /gl/costadj/meta/tasks     tasks of a project (butil key cache)
--   GET    /gl/costadj/meta/etypes    expenditure types of a project[/task]
-- Feedback round 2026-08-22: accounting period is MANDATORY (no whole-year
-- adjustments) and the task / expenditure-type pick lists are DEPENDENT on the
-- selected project (source = prod.dct_butil_key_cache, db/v2/120 -- hourly
-- refreshed, the same source the butil filter LOVs read).
-- Gates   : reads  GL_VIEW_BUDGET_UTILIZATION (NULL legacy = any valid session)
--           writes GL_MANAGE_COST_ADJ (legacy role SYS_ADMIN)
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_costadj_ords AS

    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';

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

    def_template('costadj');
    def_handler('costadj', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_year   NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_status VARCHAR2(20)  := UPPER([COLON]status);
  l_search VARCHAR2(200) := [COLON]search;
  l_n      NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT a.*,
           (SELECT lv.value_name_en FROM prod.dct_lookup_values lv
             JOIN prod.dct_lookup_categories lc ON lc.category_id = lv.category_id
            WHERE lc.category_code = 'PA_COST_ADJ_CLASS' AND lv.value_code = a.classification) AS class_name,
           TO_CHAR(dct_to_local(a.created_at),'YYYY-MM-DD HH[COLON]MI AM')  AS created_disp,
           TO_CHAR(dct_to_local(a.approved_at),'YYYY-MM-DD HH[COLON]MI AM') AS actioned_disp
      FROM prod.dct_pa_cost_adj a
     WHERE (l_year   IS NULL OR a.budget_year = l_year)
       AND (l_status IS NULL OR l_status = 'ALL' OR a.status = l_status)
       AND (l_search IS NULL OR UPPER(a.adj_ref||' '||NVL(a.invoice_number,' ')||' '||a.project_number||' '
                ||a.task_number||' '||a.expenditure_type||' '||NVL(a.supplier_name,' ')||' '
                ||NVL(a.reason,' ')) LIKE '%'||UPPER(l_search)||'%')
     ORDER BY a.adj_id DESC
     FETCH FIRST 2000 ROWS ONLY) LOOP
    l_n := l_n + 1;
    APEX_JSON.open_object;
    APEX_JSON.write('id',            r.adj_id);
    APEX_JSON.write('ref',           r.adj_ref);
    APEX_JSON.write('budgetYear',    r.budget_year);
    APEX_JSON.write('period',        NVL(r.accounting_period,''));
    APEX_JSON.write('invoiceId',     r.invoice_id);
    APEX_JSON.write('invoiceNumber', NVL(r.invoice_number,''));
    APEX_JSON.write('invoiceLine',   r.invoice_line_number);
    APEX_JSON.write('distLine',      r.dist_line_number);
    APEX_JSON.write('supplier',      NVL(r.supplier_name,''));
    APEX_JSON.write('origProject',   NVL(r.orig_project,''));
    APEX_JSON.write('origTask',      NVL(r.orig_task,''));
    APEX_JSON.write('origEtype',     NVL(r.orig_etype,''));
    APEX_JSON.write('projectNumber', r.project_number);
    APEX_JSON.write('taskNumber',    r.task_number);
    APEX_JSON.write('expenditureType', r.expenditure_type);
    APEX_JSON.write('amount',        r.amount_aed);
    APEX_JSON.write('budgetOverride', NVL(r.budget_override,0));
    APEX_JSON.write('classification', NVL(r.classification,''));
    APEX_JSON.write('className',     NVL(r.class_name, NVL(r.classification,'')));
    APEX_JSON.write('reason',        r.reason);
    APEX_JSON.write('comments',      NVL(r.comments,''));
    APEX_JSON.write('status',        r.status);
    APEX_JSON.write('actionNote',    NVL(r.action_note,''));
    APEX_JSON.write('createdBy',     r.created_by);
    APEX_JSON.write('createdAt',     NVL(r.created_disp,''));
    APEX_JSON.write('actionedBy',    NVL(r.approved_by,''));
    APEX_JSON.write('actionedAt',    NVL(r.actioned_disp,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('costadj', 'POST', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_year  NUMBER; l_period VARCHAR2(7);
  l_amt   NUMBER; l_ovr NUMBER;
  l_proj  VARCHAR2(50); l_task VARCHAR2(100); l_et VARCHAR2(255);
  l_class VARCHAR2(50); l_reason VARCHAR2(2000);
  l_id    NUMBER; l_ref VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_COST_ADJ', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_COST_ADJ required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_year   := APEX_JSON.get_number(p_path=>'budgetYear');
  l_period := TRIM(APEX_JSON.get_varchar2(p_path=>'period'));
  l_proj   := TRIM(APEX_JSON.get_varchar2(p_path=>'projectNumber'));
  l_task   := TRIM(APEX_JSON.get_varchar2(p_path=>'taskNumber'));
  l_et     := TRIM(APEX_JSON.get_varchar2(p_path=>'expenditureType'));
  l_amt    := NVL(APEX_JSON.get_number(p_path=>'amount'), 0);
  l_ovr    := APEX_JSON.get_number(p_path=>'budgetOverride');
  l_class  := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'classification')));
  l_reason := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'reason')),1,2000);
  IF l_year IS NULL OR l_proj IS NULL OR l_task IS NULL OR l_et IS NULL THEN
    dct_rest.err(400,'budgetYear, projectNumber, taskNumber and expenditureType are required'); RETURN;
  END IF;
  IF l_reason IS NULL THEN dct_rest.err(400,'reason is required'); RETURN; END IF;
  IF NVL(l_amt,0) = 0 AND NVL(l_ovr,0) = 0 THEN
    dct_rest.err(400,'amount or budgetOverride must be non-zero'); RETURN;
  END IF;
  -- accounting period is MANDATORY (user decision 2026-08-22)
  IF l_period IS NULL THEN dct_rest.err(400,'period is required'); RETURN; END IF;
  IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
     OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
    dct_rest.err(400,'period must be MM-YYYY within the budget year'); RETURN;
  END IF;
  IF l_class IS NOT NULL THEN
    prod.dct_lookup_pkg.validate_lookup('PA_COST_ADJ_CLASS', l_class);
  END IF;
  l_ref := 'PCA-' || LPAD(TO_CHAR(prod.dct_pa_cost_adj_seq.NEXTVAL), 5, '0');
  INSERT INTO prod.dct_pa_cost_adj
        (adj_ref, budget_year, accounting_period,
         invoice_id, invoice_number, invoice_line_number, dist_line_number, supplier_name,
         orig_project, orig_task, orig_etype,
         project_number, task_number, expenditure_type,
         amount_aed, budget_override, classification, reason, comments, status, created_by)
  VALUES (l_ref, l_year, l_period,
         APEX_JSON.get_number(p_path=>'invoiceId'),
         SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'invoiceNumber')),1,100),
         APEX_JSON.get_number(p_path=>'invoiceLine'),
         APEX_JSON.get_number(p_path=>'distLine'),
         SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'supplier')),1,400),
         SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'origProject')),1,50),
         SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'origTask')),1,100),
         SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'origEtype')),1,255),
         SUBSTR(l_proj,1,50), SUBSTR(l_task,1,100), SUBSTR(l_et,1,255),
         l_amt, l_ovr, l_class, l_reason,
         SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'comments')),1,4000),
         'DRAFT', l_user);
  COMMIT;
  SELECT adj_id INTO l_id FROM prod.dct_pa_cost_adj WHERE adj_ref = l_ref;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('id', l_id); APEX_JSON.write('ref', l_ref);
  APEX_JSON.write('status', 'CREATED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE IN (-20090, -20001) THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_template('costadj/[COLON]id');
    def_handler('costadj/[COLON]id', 'PUT', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_id    NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_status VARCHAR2(20);
  l_year  NUMBER; l_period VARCHAR2(7);
  l_amt   NUMBER; l_ovr NUMBER;
  l_proj  VARCHAR2(50); l_task VARCHAR2(100); l_et VARCHAR2(255);
  l_class VARCHAR2(50); l_reason VARCHAR2(2000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_COST_ADJ', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_COST_ADJ required'); RETURN;
  END IF;
  BEGIN
    SELECT status INTO l_status FROM prod.dct_pa_cost_adj WHERE adj_id = l_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Adjustment not found'); RETURN;
  END;
  IF l_status <> 'DRAFT' THEN dct_rest.err(400,'Only DRAFT adjustments can be edited'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_year   := APEX_JSON.get_number(p_path=>'budgetYear');
  l_period := TRIM(APEX_JSON.get_varchar2(p_path=>'period'));
  l_proj   := TRIM(APEX_JSON.get_varchar2(p_path=>'projectNumber'));
  l_task   := TRIM(APEX_JSON.get_varchar2(p_path=>'taskNumber'));
  l_et     := TRIM(APEX_JSON.get_varchar2(p_path=>'expenditureType'));
  l_amt    := NVL(APEX_JSON.get_number(p_path=>'amount'), 0);
  l_ovr    := APEX_JSON.get_number(p_path=>'budgetOverride');
  l_class  := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'classification')));
  l_reason := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'reason')),1,2000);
  IF l_year IS NULL OR l_proj IS NULL OR l_task IS NULL OR l_et IS NULL THEN
    dct_rest.err(400,'budgetYear, projectNumber, taskNumber and expenditureType are required'); RETURN;
  END IF;
  IF l_reason IS NULL THEN dct_rest.err(400,'reason is required'); RETURN; END IF;
  IF NVL(l_amt,0) = 0 AND NVL(l_ovr,0) = 0 THEN
    dct_rest.err(400,'amount or budgetOverride must be non-zero'); RETURN;
  END IF;
  -- accounting period is MANDATORY (user decision 2026-08-22)
  IF l_period IS NULL THEN dct_rest.err(400,'period is required'); RETURN; END IF;
  IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
     OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
    dct_rest.err(400,'period must be MM-YYYY within the budget year'); RETURN;
  END IF;
  IF l_class IS NOT NULL THEN
    prod.dct_lookup_pkg.validate_lookup('PA_COST_ADJ_CLASS', l_class);
  END IF;
  -- full-document replace: the drawer always sends the complete form
  UPDATE prod.dct_pa_cost_adj
     SET budget_year = l_year,
         accounting_period = l_period,
         invoice_id = APEX_JSON.get_number(p_path=>'invoiceId'),
         invoice_number = SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'invoiceNumber')),1,100),
         invoice_line_number = APEX_JSON.get_number(p_path=>'invoiceLine'),
         dist_line_number = APEX_JSON.get_number(p_path=>'distLine'),
         supplier_name = SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'supplier')),1,400),
         orig_project = SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'origProject')),1,50),
         orig_task = SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'origTask')),1,100),
         orig_etype = SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'origEtype')),1,255),
         project_number = SUBSTR(l_proj,1,50),
         task_number = SUBSTR(l_task,1,100),
         expenditure_type = SUBSTR(l_et,1,255),
         amount_aed = l_amt,
         budget_override = l_ovr,
         classification = l_class,
         reason = l_reason,
         comments = SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'comments')),1,4000),
         updated_by = l_user, updated_at = SYSTIMESTAMP
   WHERE adj_id = l_id;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('id', l_id); APEX_JSON.write('status', 'UPDATED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE IN (-20090, -20001) THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_handler('costadj/[COLON]id', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_COST_ADJ', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_COST_ADJ required'); RETURN;
  END IF;
  DELETE FROM prod.dct_pa_cost_adj WHERE adj_id = l_id;
  IF SQL%ROWCOUNT = 0 THEN ROLLBACK; dct_rest.err(404,'Adjustment not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('id', l_id); APEX_JSON.write('status', 'DELETED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('costadj/[COLON]id/action');
    def_handler('costadj/[COLON]id/action', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_id     NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_action VARCHAR2(20);
  l_note   VARCHAR2(2000);
  l_status VARCHAR2(20);
  l_new    VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_COST_ADJ', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_COST_ADJ required'); RETURN;
  END IF;
  BEGIN
    SELECT status INTO l_status FROM prod.dct_pa_cost_adj WHERE adj_id = l_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Adjustment not found'); RETURN;
  END;
  dct_rest.parse_body([COLON]body);
  l_action := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'action')));
  l_note   := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'note')),1,2000);
  IF l_action NOT IN ('APPROVE','REJECT') THEN
    dct_rest.err(400,'action must be APPROVE or REJECT'); RETURN;
  END IF;
  IF l_status <> 'DRAFT' THEN
    dct_rest.err(400,'Only DRAFT adjustments can be actioned (current status ' || l_status || ')'); RETURN;
  END IF;
  l_new := CASE l_action WHEN 'APPROVE' THEN 'APPROVED' ELSE 'REJECTED' END;
  UPDATE prod.dct_pa_cost_adj
     SET status = l_new, action_note = l_note,
         approved_by = l_user, approved_at = SYSTIMESTAMP
   WHERE adj_id = l_id;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('id', l_id); APEX_JSON.write('status', l_new);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('costadj/meta/dists');
    def_handler('costadj/meta/dists', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_search VARCHAR2(200) := TRIM([COLON]search);
  l_n      NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_search IS NULL OR LENGTH(l_search) < 2 THEN
    dct_rest.err(400,'search (at least 2 characters) is required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT d.invoice_id, d.invoice_number, d.invoice_line_number, d.distribution_line_number,
           d.distribution_type, d.distribution_amount_aed,
           COALESCE(d.beneficiary_name, d.supplier_name) AS supplier,
           d.business_unit, d.period_name,
           TO_CHAR(d.accounting_date,'YYYY-MM-DD') AS acct_date,
           d.project_number, d.project_name, d.task_number, d.expenditure_type,
           d.distribution_description
      FROM prod.ap_invoice_distributions_v d
     WHERE d.cancelled_date IS NULL
       AND (UPPER(d.invoice_number) LIKE '%'||UPPER(l_search)||'%'
            OR UPPER(NVL(d.supplier_name,' ')) LIKE '%'||UPPER(l_search)||'%'
            OR UPPER(NVL(d.beneficiary_name,' ')) LIKE '%'||UPPER(l_search)||'%')
     ORDER BY d.invoice_date DESC, d.invoice_number, d.invoice_line_number, d.distribution_line_number
     FETCH FIRST 50 ROWS ONLY) LOOP
    l_n := l_n + 1;
    APEX_JSON.open_object;
    APEX_JSON.write('invoiceId',     r.invoice_id);
    APEX_JSON.write('invoiceNumber', r.invoice_number);
    APEX_JSON.write('line',          r.invoice_line_number);
    APEX_JSON.write('dist',          r.distribution_line_number);
    APEX_JSON.write('distType',      NVL(r.distribution_type,''));
    APEX_JSON.write('amountAed',     NVL(r.distribution_amount_aed,0));
    APEX_JSON.write('supplier',      NVL(r.supplier,''));
    APEX_JSON.write('businessUnit',  NVL(r.business_unit,''));
    APEX_JSON.write('periodName',    NVL(r.period_name,''));
    APEX_JSON.write('acctDate',      NVL(r.acct_date,''));
    APEX_JSON.write('projectNumber', NVL(r.project_number,''));
    APEX_JSON.write('projectName',   NVL(r.project_name,''));
    APEX_JSON.write('taskNumber',    NVL(r.task_number,''));
    APEX_JSON.write('expenditureType', NVL(r.expenditure_type,''));
    APEX_JSON.write('description',   NVL(r.distribution_description,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('costadj/meta/tasks');
    def_handler('costadj/meta/tasks', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_proj VARCHAR2(50) := TRIM([COLON]project);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL OR l_proj IS NULL THEN
    dct_rest.err(400,'year and project are required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT DISTINCT task_number
              FROM prod.dct_butil_key_cache
             WHERE budget_year = l_year AND project_number = l_proj
               AND task_number IS NOT NULL
             ORDER BY task_number
             FETCH FIRST 500 ROWS ONLY) LOOP
    APEX_JSON.write(r.task_number);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('costadj/meta/etypes');
    def_handler('costadj/meta/etypes', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_year NUMBER := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_proj VARCHAR2(50) := TRIM([COLON]project);
  l_task VARCHAR2(100) := TRIM([COLON]task);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL OR l_proj IS NULL THEN
    dct_rest.err(400,'year and project are required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT DISTINCT expenditure_type
              FROM prod.dct_butil_key_cache
             WHERE budget_year = l_year AND project_number = l_proj
               AND (l_task IS NULL OR task_number = l_task)
               AND expenditure_type IS NOT NULL
             ORDER BY expenditure_type
             FETCH FIRST 500 ROWS ONLY) LOOP
    APEX_JSON.write(r.expenditure_type);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('costadj/meta/lookups');
    def_handler('costadj/meta/lookups', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  PROCEDURE emit(p_arr VARCHAR2, p_cat VARCHAR2) IS
  BEGIN
    APEX_JSON.open_array(p_arr);
    FOR v IN (SELECT lv.value_code, lv.value_name_en, lv.value_name_ar
                FROM prod.dct_lookup_values lv
                JOIN prod.dct_lookup_categories lc ON lc.category_id = lv.category_id
               WHERE lc.category_code = p_cat AND lv.is_active = 'Y'
               ORDER BY lv.display_order) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('code',   v.value_code);
      APEX_JSON.write('name',   v.value_name_en);
      APEX_JSON.write('nameAr', v.value_name_ar, p_write_null => TRUE);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  emit('classifications', 'PA_COST_ADJ_CLASS');
  emit('statuses', 'PA_COST_ADJ_STATUS');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_gl_costadj_ords;
/

BEGIN setup_gl_costadj_ords; END;
/
DROP PROCEDURE setup_gl_costadj_ords;

PROMPT === verification ===
SELECT t.uri_template, h.method, LENGTH(h.source) AS chars
  FROM user_ords_handlers h
  JOIN user_ords_templates t ON t.id = h.template_id
  JOIN user_ords_modules m ON m.id = t.module_id
 WHERE m.name = 'gl.rest' AND t.uri_template LIKE 'costadj%'
 ORDER BY t.uri_template, h.method;
