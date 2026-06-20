-- =============================================================================
-- Petty Cash Module (App 201) — ORDS REST API Definition
-- File    : 06_pc_ords.sql
-- Run as  : ADMIN schema (sql -name prod_mcp)
-- Base URL: /ords/admin/pc/
-- Prereqs : db/v2/11_dct_ords.sql already executed
--           (creates dct_rest, dct_auth, dct_sessions, dct_users, dct_notifications synonyms)
--           final apps/PC/db/ 01→05 deployed
-- Notes   : Login is NOT here — PC JET uses config.authBase → /ords/admin/dct/auth/*
--           (same convention as DT). JSON field names match the PC JET mock-data
--           contract (final apps/PC/Jet/js/mockData.js) so VMs work unchanged.
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

-- =============================================================================
-- 1. Sequences for request numbering (PROD schema, safe re-run)
-- =============================================================================
DECLARE
  PROCEDURE mk(p_name VARCHAR2) IS
    e_exists EXCEPTION; PRAGMA EXCEPTION_INIT(e_exists, -955);
  BEGIN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE prod.' || p_name || ' START WITH 100 INCREMENT BY 1 NOCACHE';
  EXCEPTION WHEN e_exists THEN NULL;
  END;
BEGIN
  mk('seq_pc_number');
  mk('seq_pc_reimb_number');
  mk('seq_pc_clear_number');
END;
/

-- =============================================================================
-- 2. ADMIN synonyms — PC tables, views, sequences + shared objects
-- =============================================================================
CREATE OR REPLACE SYNONYM dct_petty_cash            FOR prod.dct_petty_cash;
CREATE OR REPLACE SYNONYM dct_pc_budget_lines       FOR prod.dct_pc_budget_lines;
CREATE OR REPLACE SYNONYM dct_pc_reimbursements     FOR prod.dct_pc_reimbursements;
CREATE OR REPLACE SYNONYM dct_pc_reimb_budget_lines FOR prod.dct_pc_reimb_budget_lines;
CREATE OR REPLACE SYNONYM dct_pc_clearing           FOR prod.dct_pc_clearing;
CREATE OR REPLACE SYNONYM dct_pc_clear_budget_lines FOR prod.dct_pc_clear_budget_lines;
CREATE OR REPLACE SYNONYM dct_pc_attachments        FOR prod.dct_pc_attachments;
CREATE OR REPLACE SYNONYM dct_pc_summary_v          FOR prod.dct_pc_summary_v;
CREATE OR REPLACE SYNONYM dct_pc_admin_v            FOR prod.dct_pc_admin_v;
CREATE OR REPLACE SYNONYM seq_pc_number             FOR prod.seq_pc_number;
CREATE OR REPLACE SYNONYM seq_pc_reimb_number       FOR prod.seq_pc_reimb_number;
CREATE OR REPLACE SYNONYM seq_pc_clear_number       FOR prod.seq_pc_clear_number;
CREATE OR REPLACE SYNONYM dct_gl_code_combinations  FOR prod.dct_gl_code_combinations;
CREATE OR REPLACE SYNONYM dct_organizations         FOR prod.dct_organizations;
CREATE OR REPLACE SYNONYM dct_user_roles            FOR prod.dct_user_roles;
-- Shared (idempotent — may already exist from DT setup)
CREATE OR REPLACE SYNONYM dct_approval_instances    FOR prod.dct_approval_instances;
CREATE OR REPLACE SYNONYM dct_approval_actions      FOR prod.dct_approval_actions;
CREATE OR REPLACE SYNONYM dct_approval_steps        FOR prod.dct_approval_steps;
CREATE OR REPLACE SYNONYM dct_approval_templates    FOR prod.dct_approval_templates;
CREATE OR REPLACE SYNONYM dct_module_settings       FOR prod.dct_module_settings;
CREATE OR REPLACE SYNONYM dct_modules               FOR prod.dct_modules;
CREATE OR REPLACE SYNONYM dct_roles                 FOR prod.dct_roles;
CREATE OR REPLACE SYNONYM dct_notify                FOR prod.dct_notify;

-- =============================================================================
-- 3. Define ORDS module + all templates + handlers
-- =============================================================================
CREATE OR REPLACE PROCEDURE setup_pc_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'pc.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58))
        );
    END;

    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58))
        );
    END;

BEGIN

    BEGIN ORDS.DELETE_MODULE(p_module_name => c_mod); EXCEPTION WHEN OTHERS THEN NULL; END;

    ORDS.DEFINE_MODULE(
        p_module_name    => c_mod,
        p_base_path      => '/pc/',
        p_items_per_page => 100,
        p_status         => 'PUBLISHED',
        p_comments       => 'Petty Cash Module — REST API'
    );

    -- =========================================================================
    -- PC — literal templates first (stats / activity / all), then bind patterns
    -- =========================================================================
    def_template('pc/stats');
    def_handler('pc/stats', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_active NUMBER := 0; l_pending NUMBER := 0; l_float NUMBER := 0;
  l_reimb_pending NUMBER := 0; l_org_pending NUMBER := 0; l_org_reimb NUMBER := 0;
  l_has_active NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);

  SELECT COUNT(CASE WHEN status = 'ACTIVE' THEN 1 END),
         COUNT(CASE WHEN status IN ('SUBMITTED','PENDING_APPROVAL') THEN 1 END),
         NVL(SUM(CASE WHEN status = 'ACTIVE' THEN current_float_balance END), 0)
  INTO   l_active, l_pending, l_float
  FROM   dct_pc_summary_v WHERE user_id = l_uid;

  SELECT COUNT(*) INTO l_reimb_pending
  FROM   dct_pc_reimbursements r
  JOIN   dct_petty_cash pc ON pc.pc_id = r.pc_id
  WHERE  pc.user_id = l_uid AND r.status IN ('SUBMITTED','PENDING_APPROVAL');

  SELECT COUNT(*) INTO l_org_pending
  FROM   dct_petty_cash WHERE status IN ('SUBMITTED','PENDING_APPROVAL');

  SELECT COUNT(*) INTO l_org_reimb
  FROM   dct_pc_reimbursements WHERE status IN ('SUBMITTED','PENDING_APPROVAL');

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('activePc',            l_active);
  APEX_JSON.write('pendingPc',           l_pending);
  APEX_JSON.write('totalFloat',          l_float);
  APEX_JSON.write('totalFloatFormatted', TO_CHAR(l_float, 'FM999,999,990.00'));
  APEX_JSON.write('reimbPending',        l_reimb_pending);
  APEX_JSON.write('orgActivePc',         l_org_pending);
  APEX_JSON.write('orgPendingApprovals', l_org_pending + l_org_reimb);
  FOR r IN (
    SELECT * FROM dct_pc_summary_v
    WHERE user_id = l_uid AND status = 'ACTIVE'
    ORDER BY pc_id DESC FETCH FIRST 1 ROW ONLY
  ) LOOP
    l_has_active := 1;
    APEX_JSON.open_object('activeRecord');
    APEX_JSON.write('pcId',                r.pc_id);
    APEX_JSON.write('pcNumber',            r.pc_number);
    APEX_JSON.write('pcType',              r.pc_type);
    APEX_JSON.write('amount',              r.advance_amount);
    APEX_JSON.write('status',              r.status);
    APEX_JSON.write('codingType',          r.coding_type);
    APEX_JSON.write('fiscalYear',          r.fiscal_year);
    APEX_JSON.write('dueDate',             TO_CHAR(r.due_date,'YYYY-MM-DD'));
    APEX_JSON.write('totalReimbursed',     r.total_reimbursed);
    APEX_JSON.write('clearedAmount',       r.cleared_amount);
    APEX_JSON.write('refundedAmount',      r.refunded_amount);
    APEX_JSON.write('currentFloatBalance', r.current_float_balance);
    APEX_JSON.close_object;
  END LOOP;
  IF l_has_active = 0 THEN APEX_JSON.write('activeRecord', ''); END IF;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('pc/activity');
    def_handler('pc/activity', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (
    SELECT ai.source_record_ref, ai.source_module, aa.action, aa.comments,
           aa.actioned_at, u.display_name AS actor
    FROM   dct_approval_actions   aa
    JOIN   dct_approval_instances ai ON ai.instance_id = aa.instance_id
    JOIN   dct_users              u  ON u.user_id      = aa.actioned_by
    WHERE  ai.submitted_by  = l_uid
      AND  ai.source_module IN ('PETTY_CASH','REIMBURSEMENT','CLEARING')
    ORDER  BY aa.action_id DESC
    FETCH FIRST 8 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('requestRef',  r.source_record_ref);
    APEX_JSON.write('requestType', r.source_module);
    APEX_JSON.write('action',      r.action);
    APEX_JSON.write('comments',    r.comments);
    APEX_JSON.write('actionDate',  TO_CHAR(r.actioned_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('actionedBy',  r.actor);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('pc/all');
    def_handler('pc/all', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  -- Phase 3: raw array -> {items,total,limit,offset} envelope + server paging
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_search VARCHAR2(200) := [COLON]search;
  l_status VARCHAR2(30)  := UPPER([COLON]status);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;

  SELECT COUNT(*) INTO l_total
  FROM   dct_pc_admin_v a
  WHERE (l_status IS NULL OR a.status = l_status)
    AND (l_search IS NULL OR
         UPPER(a.pc_number || ' ' || NVL(a.employee_name,'') || ' ' || NVL(a.org_name,''))
         LIKE '%' || UPPER(l_search) || '%');

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total',  l_total);
  APEX_JSON.write('limit',  l_limit);
  APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT a.*, ai.overall_status AS approval_status
    FROM   dct_pc_admin_v a
    LEFT JOIN dct_petty_cash pc ON pc.pc_id = a.pc_id
    LEFT JOIN dct_approval_instances ai ON ai.instance_id = pc.approval_instance_id
    WHERE (l_status IS NULL OR a.status = l_status)
      AND (l_search IS NULL OR
           UPPER(a.pc_number || ' ' || NVL(a.employee_name,'') || ' ' || NVL(a.org_name,''))
           LIKE '%' || UPPER(l_search) || '%')
    ORDER  BY a.pc_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('pcId',                r.pc_id);
    APEX_JSON.write('pcNumber',            r.pc_number);
    APEX_JSON.write('pcType',              r.pc_type);
    APEX_JSON.write('userId',              r.user_id);
    APEX_JSON.write('employeeName',        r.employee_name);
    APEX_JSON.write('employeeNumber',      r.employee_number);
    APEX_JSON.write('orgName',             r.org_name);
    APEX_JSON.write('amount',              r.advance_amount);
    APEX_JSON.write('codingType',          r.coding_type);
    APEX_JSON.write('status',              r.status);
    APEX_JSON.write('fiscalYear',          r.fiscal_year);
    APEX_JSON.write('dueDate',             TO_CHAR(r.due_date,'YYYY-MM-DD'));
    APEX_JSON.write('disbursedDate',       TO_CHAR(r.disbursed_date,'YYYY-MM-DD'));
    APEX_JSON.write('submittedAt',         TO_CHAR(r.submitted_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('totalReimbursed',     r.total_reimbursed);
    APEX_JSON.write('clearedAmount',       r.cleared_amount);
    APEX_JSON.write('refundedAmount',      r.refunded_amount);
    APEX_JSON.write('currentFloatBalance', r.advance_amount - r.total_reimbursed);
    APEX_JSON.write('approvalStatus',      r.approval_status);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- PC CHARTS (Phase 3 — dashboard charts)
    -- =========================================================================
    def_template('pc/charts');
    def_handler('pc/charts', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;

  -- Chart 1: outstanding floats by organisation (ACTIVE floats)
  APEX_JSON.open_array('floatsByOrg');
  FOR r IN (
    SELECT NVL(a.org_name, 'Unassigned') AS org_name,
           SUM(a.advance_amount - NVL(a.total_reimbursed, 0)) AS outstanding
    FROM   dct_pc_admin_v a
    WHERE  a.status = 'ACTIVE'
    GROUP  BY NVL(a.org_name, 'Unassigned')
    ORDER  BY outstanding DESC
    FETCH FIRST 8 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('org',         r.org_name);
    APEX_JSON.write('outstanding', r.outstanding);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  -- Chart 2: uncleared TEMPORARY floats ageing (days since disbursement)
  APEX_JSON.open_array('tempAgeing');
  FOR r IN (
    SELECT bucket, COUNT(*) AS n FROM (
      SELECT CASE
               WHEN SYSDATE - pc.disbursed_date <= 30 THEN '0-30'
               WHEN SYSDATE - pc.disbursed_date <= 60 THEN '31-60'
               WHEN SYSDATE - pc.disbursed_date <= 90 THEN '61-90'
               ELSE '90+'
             END AS bucket
      FROM   dct_petty_cash pc
      WHERE  pc.pc_type = 'TEMPORARY'
      AND    pc.status  = 'ACTIVE'
      AND    pc.disbursed_date IS NOT NULL
    )
    GROUP BY bucket
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('bucket', r.bucket);
    APEX_JSON.write('count',  r.n);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('pc/');
    def_handler('pc/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (
    SELECT s.*, pc.purpose
    FROM   dct_pc_summary_v s
    JOIN   dct_petty_cash pc ON pc.pc_id = s.pc_id
    WHERE  s.user_id = l_uid
    ORDER  BY s.pc_id DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('pcId',                r.pc_id);
    APEX_JSON.write('pcNumber',            r.pc_number);
    APEX_JSON.write('pcType',              r.pc_type);
    APEX_JSON.write('userId',              r.user_id);
    APEX_JSON.write('amount',              r.advance_amount);
    APEX_JSON.write('purpose',             r.purpose);
    APEX_JSON.write('codingType',          r.coding_type);
    APEX_JSON.write('status',              r.status);
    APEX_JSON.write('displayStatus',       r.display_status);
    APEX_JSON.write('fiscalYear',          r.fiscal_year);
    APEX_JSON.write('dueDate',             TO_CHAR(r.due_date,'YYYY-MM-DD'));
    APEX_JSON.write('disbursedDate',       TO_CHAR(r.disbursed_date,'YYYY-MM-DD'));
    APEX_JSON.write('submittedAt',         TO_CHAR(r.submitted_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('totalReimbursed',     r.total_reimbursed);
    APEX_JSON.write('clearedAmount',       r.cleared_amount);
    APEX_JSON.write('refundedAmount',      r.refunded_amount);
    APEX_JSON.write('currentFloatBalance', r.current_float_balance);
    APEX_JSON.write('clearingId',          r.clearing_id);
    APEX_JSON.write('clearingStatus',      r.clearing_status);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('pc/', 'POST', q'!
DECLARE
  l_user     VARCHAR2(100) := dct_rest.validate_session;
  l_uid      NUMBER;
  l_max_pc   NUMBER;
  l_open     NUMBER;
  l_pc_id    NUMBER;
  l_number   VARCHAR2(20);
  l_tmpl_id  NUMBER;
  l_inst_id  NUMBER;
  l_amount   NUMBER;
  l_cnt      NUMBER;
  l_line_sum NUMBER := 0;
  l_role_id  NUMBER;
  l_new      CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);

  l_amount := APEX_JSON.get_number(p_path => 'amount');
  IF l_amount IS NULL OR l_amount <= 0 THEN
    dct_rest.err(400,'Amount must be greater than zero'); RETURN;
  END IF;

  -- MAX_PC_PER_EMPLOYEE guard
  BEGIN
    SELECT TO_NUMBER(ms.setting_value) INTO l_max_pc
    FROM   dct_module_settings ms JOIN dct_modules m ON m.module_id = ms.module_id
    WHERE  m.module_code = 'PETTY_CASH' AND ms.setting_key = 'MAX_PC_PER_EMPLOYEE';
  EXCEPTION WHEN OTHERS THEN l_max_pc := NULL;
  END;
  IF l_max_pc IS NOT NULL THEN
    SELECT COUNT(*) INTO l_open FROM dct_petty_cash
    WHERE  user_id = l_uid AND status IN ('SUBMITTED','PENDING_APPROVAL','ACTIVE');
    IF l_open >= l_max_pc THEN
      dct_rest.err(400,'Maximum of ' || l_max_pc || ' open petty cash records per employee reached');
      RETURN;
    END IF;
  END IF;

  -- Budget lines must sum to the amount
  l_cnt := NVL(APEX_JSON.get_count(p_path => 'budgetLines'), 0);
  IF l_cnt = 0 THEN dct_rest.err(400,'At least one budget line is required'); RETURN; END IF;
  FOR i IN 1 .. l_cnt LOOP
    l_line_sum := l_line_sum + NVL(APEX_JSON.get_number(p_path => 'budgetLines[%d].amount', p0 => i), 0);
  END LOOP;
  IF ROUND(l_line_sum,2) != ROUND(l_amount,2) THEN
    dct_rest.err(400,'Budget lines total (' || l_line_sum || ') must equal the advance amount (' || l_amount || ')');
    RETURN;
  END IF;

  l_number := 'PC-' || TO_CHAR(SYSDATE,'YYYY') || '-' || TO_CHAR(seq_pc_number.NEXTVAL,'FM00000');

  -- RETURNING is illegal with INSERT..SELECT: fetch user attributes first
  DECLARE
    l_emp_num dct_users.employee_number%TYPE;
    l_org_id  dct_users.org_id%TYPE;
  BEGIN
    SELECT employee_number, org_id INTO l_emp_num, l_org_id
    FROM   dct_users WHERE user_id = l_uid;

    INSERT INTO dct_petty_cash (
      pc_number, pc_type, user_id, employee_num, org_id, amount, purpose,
      coding_type, status, fiscal_year, due_date, submitted_at, created_by, updated_by)
    VALUES (
      l_number,
      APEX_JSON.get_varchar2(p_path => 'pcType'),
      l_uid, l_emp_num, l_org_id, l_amount,
      APEX_JSON.get_varchar2(p_path => 'purpose'),
      APEX_JSON.get_varchar2(p_path => 'codingType'),
      'SUBMITTED',
      EXTRACT(YEAR FROM SYSDATE),
      TO_DATE(APEX_JSON.get_varchar2(p_path => 'dueDate'),'YYYY-MM-DD'),
      SYSTIMESTAMP, l_user, l_user)
    RETURNING pc_id INTO l_pc_id;
  END;

  FOR i IN 1 .. l_cnt LOOP
    INSERT INTO dct_pc_budget_lines (
      pc_id, line_num, amount, cc_id, project_number, task_number,
      expenditure_type, description, created_by, updated_by)
    VALUES (
      l_pc_id, i,
      APEX_JSON.get_number  (p_path => 'budgetLines[%d].amount',          p0 => i),
      APEX_JSON.get_number  (p_path => 'budgetLines[%d].ccId',            p0 => i),
      APEX_JSON.get_varchar2(p_path => 'budgetLines[%d].projectNumber',   p0 => i),
      APEX_JSON.get_varchar2(p_path => 'budgetLines[%d].taskNumber',      p0 => i),
      APEX_JSON.get_varchar2(p_path => 'budgetLines[%d].expenditureType', p0 => i),
      APEX_JSON.get_varchar2(p_path => 'budgetLines[%d].description',     p0 => i),
      l_user, l_user);
  END LOOP;

  -- Approval instance
  SELECT at.template_id INTO l_tmpl_id
  FROM   dct_approval_templates at
  JOIN   dct_modules m ON m.module_id = at.module_id
  WHERE  m.module_code = 'PETTY_CASH' AND at.request_type = 'PETTY_CASH' AND at.is_active = 'Y'
  FETCH FIRST 1 ROW ONLY;

  INSERT INTO dct_approval_instances (
    template_id, source_module, source_record_id, source_record_ref,
    current_step_seq, overall_status, submitted_by, submitted_at, created_by, updated_by)
  VALUES (
    l_tmpl_id, 'PETTY_CASH', l_pc_id, l_number,
    (SELECT MIN(step_seq) FROM dct_approval_steps WHERE template_id = l_tmpl_id),
    'PENDING', l_uid, SYSTIMESTAMP, l_user, l_user)
  RETURNING instance_id INTO l_inst_id;

  UPDATE dct_petty_cash SET approval_instance_id = l_inst_id WHERE pc_id = l_pc_id;

  -- Notify first-step approvers
  BEGIN
    SELECT ast.required_role_id INTO l_role_id
    FROM   dct_approval_steps ast
    WHERE  ast.template_id = l_tmpl_id
    AND    ast.step_seq = (SELECT MIN(step_seq) FROM dct_approval_steps WHERE template_id = l_tmpl_id);
    FOR usr IN (
      SELECT ur.user_id FROM dct_user_roles ur
      WHERE  ur.role_id = l_role_id AND ur.is_active = 'Y'
      AND   (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
    ) LOOP
      dct_notify.send(
        p_recipient_user_id => usr.user_id,
        p_notification_type => 'APPROVAL_REQUEST',
        p_title_en          => 'Petty Cash Request Pending Approval',
        p_body_en           => 'Petty cash request ' || l_number || ' is awaiting your approval.',
        p_module_code       => 'PETTY_CASH');
    END LOOP;
  EXCEPTION WHEN OTHERS THEN NULL;
  END;

  -- Unified status-transition log
  INSERT INTO dct_request_status_history (
    source_module, source_type, source_id, old_status, new_status, changed_by, comments)
  VALUES ('PC', 'PC', l_pc_id, NULL, 'SUBMITTED', l_uid,
          'Petty cash ' || l_number || ' created and submitted');

  COMMIT;
  l_new := dct_audit_pkg.snap('DCT_PETTY_CASH','pc_id', TO_CHAR(l_pc_id));
  dct_audit_pkg.log(l_user,'CREATE','DCT_PETTY_CASH', TO_CHAR(l_pc_id), 'PC',
                    p_object_ref=>l_number, p_new=>l_new);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('pcId',     l_pc_id);
  APEX_JSON.write('pcNumber', l_number);
  APEX_JSON.write('status',   'SUBMITTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('pc/[COLON]id');
    def_handler('pc/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR r IN (
    SELECT s.*, pc.purpose, u.display_name AS employee_name, u.employee_number,
           o.org_name_en AS org_name, ai.overall_status AS approval_status
    FROM   dct_pc_summary_v s
    JOIN   dct_petty_cash    pc ON pc.pc_id   = s.pc_id
    JOIN   dct_users         u  ON u.user_id  = s.user_id
    LEFT JOIN dct_organizations o ON o.org_id = s.org_id
    LEFT JOIN dct_approval_instances ai ON ai.instance_id = pc.approval_instance_id
    WHERE  s.pc_id = [COLON]id
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('pcId',                r.pc_id);
    APEX_JSON.write('pcNumber',            r.pc_number);
    APEX_JSON.write('pcType',              r.pc_type);
    APEX_JSON.write('userId',              r.user_id);
    APEX_JSON.write('employeeName',        r.employee_name);
    APEX_JSON.write('employeeNumber',      r.employee_number);
    APEX_JSON.write('orgName',             r.org_name);
    APEX_JSON.write('amount',              r.advance_amount);
    APEX_JSON.write('purpose',             r.purpose);
    APEX_JSON.write('codingType',          r.coding_type);
    APEX_JSON.write('status',              r.status);
    APEX_JSON.write('displayStatus',       r.display_status);
    APEX_JSON.write('fiscalYear',          r.fiscal_year);
    APEX_JSON.write('dueDate',             TO_CHAR(r.due_date,'YYYY-MM-DD'));
    APEX_JSON.write('disbursedDate',       TO_CHAR(r.disbursed_date,'YYYY-MM-DD'));
    APEX_JSON.write('submittedAt',         TO_CHAR(r.submitted_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('totalReimbursed',     r.total_reimbursed);
    APEX_JSON.write('clearedAmount',       r.cleared_amount);
    APEX_JSON.write('refundedAmount',      r.refunded_amount);
    APEX_JSON.write('currentFloatBalance', r.current_float_balance);
    APEX_JSON.write('clearingId',          r.clearing_id);
    APEX_JSON.write('clearingStatus',      r.clearing_status);
    APEX_JSON.write('approvalStatus',      r.approval_status);
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('pc/[COLON]id', 'PUT', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20);
  l_old    CLOB;
  l_new    CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT status INTO l_status FROM dct_petty_cash WHERE pc_id = [COLON]id FOR UPDATE;
  IF l_status != 'DRAFT' THEN
    dct_rest.err(400,'Only DRAFT records can be updated (current status: ' || l_status || ')');
    RETURN;
  END IF;
  l_old := dct_audit_pkg.snap('DCT_PETTY_CASH','pc_id', TO_CHAR([COLON]id));
  dct_rest.parse_body([COLON]body);
  UPDATE dct_petty_cash SET
    pc_type     = NVL(APEX_JSON.get_varchar2(p_path => 'pcType'), pc_type),
    amount      = NVL(APEX_JSON.get_number  (p_path => 'amount'), amount),
    purpose     = NVL(APEX_JSON.get_varchar2(p_path => 'purpose'), purpose),
    coding_type = NVL(APEX_JSON.get_varchar2(p_path => 'codingType'), coding_type),
    due_date    = NVL(TO_DATE(APEX_JSON.get_varchar2(p_path => 'dueDate'),'YYYY-MM-DD'), due_date),
    updated_by  = l_user
  WHERE pc_id = [COLON]id;
  COMMIT;
  l_new := dct_audit_pkg.snap('DCT_PETTY_CASH','pc_id', TO_CHAR([COLON]id));
  dct_audit_pkg.log(l_user,'UPDATE','DCT_PETTY_CASH', TO_CHAR([COLON]id), 'PC',
                    p_old=>l_old, p_new=>l_new);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('pc/[COLON]id/lines');
    def_handler('pc/[COLON]id/lines', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (
    SELECT bl.*, gl.cc_code
    FROM   dct_pc_budget_lines bl
    LEFT JOIN dct_gl_code_combinations gl ON gl.cc_id = bl.cc_id
    WHERE  bl.pc_id = [COLON]id ORDER BY bl.line_num
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('lineId',          r.line_id);
    APEX_JSON.write('pcId',            r.pc_id);
    APEX_JSON.write('lineNum',         r.line_num);
    APEX_JSON.write('amount',          r.amount);
    APEX_JSON.write('ccId',            r.cc_id);
    APEX_JSON.write('ccCode',          r.cc_code);
    APEX_JSON.write('projectNumber',   r.project_number);
    APEX_JSON.write('taskNumber',      r.task_number);
    APEX_JSON.write('expenditureType', r.expenditure_type);
    APEX_JSON.write('description',     r.description);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('pc/[COLON]id/disburse');
    def_handler('pc/[COLON]id/disburse', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
  l_status VARCHAR2(20);
  l_appr   VARCHAR2(20);
  l_owner  NUMBER;
  l_num    VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT pc.status, ai.overall_status, pc.user_id, pc.pc_number
  INTO   l_status, l_appr, l_owner, l_num
  FROM   dct_petty_cash pc
  LEFT JOIN dct_approval_instances ai ON ai.instance_id = pc.approval_instance_id
  WHERE  pc.pc_id = [COLON]id FOR UPDATE OF pc.status;

  IF l_status NOT IN ('SUBMITTED','PENDING_APPROVAL') OR NVL(l_appr,'x') != 'APPROVED' THEN
    dct_rest.err(400,'Petty cash must be fully approved before disbursement (status: '
                 || l_status || ', approval: ' || NVL(l_appr,'NONE') || ')');
    RETURN;
  END IF;

  UPDATE dct_petty_cash SET
    status         = 'ACTIVE',
    disbursed_date = SYSDATE,
    disbursed_by   = l_user,
    updated_by     = l_user
  WHERE pc_id = [COLON]id;

  -- Unified status-transition log
  INSERT INTO dct_request_status_history (
    source_module, source_type, source_id, old_status, new_status, changed_by, comments)
  VALUES ('PC', 'PC', [COLON]id, l_status, 'ACTIVE', l_uid,
          'Petty cash ' || l_num || ' disbursed by Finance');

  BEGIN
    dct_notify.send(
      p_recipient_user_id => l_owner,
      p_notification_type => 'STATUS_UPDATE',
      p_title_en          => 'Petty Cash Disbursed',
      p_body_en           => 'Your petty cash ' || l_num || ' has been disbursed and is now active.',
      p_module_code       => 'PETTY_CASH');
  EXCEPTION WHEN OTHERS THEN NULL;
  END;

  -- Queue a Fusion AP prepayment (no-op unless PETTY_CASH.FUSION_POST_ADVANCE=Y)
  dct_pc_fusion_pkg.enqueue_advance_action([COLON]id);

  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.write('status','ACTIVE'); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GL CODES
    -- =========================================================================
    def_template('gl-codes');
    def_handler('gl-codes', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (SELECT * FROM dct_gl_code_combinations ORDER BY cc_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('ccId',            r.cc_id);
    APEX_JSON.write('ccCode',          r.cc_code);
    APEX_JSON.write('entityCode',      r.entity_code);
    APEX_JSON.write('ic',              r.program_code);
    APEX_JSON.write('costCenter',      r.cost_center_code);
    APEX_JSON.write('budgetGroupCode', r.budget_group_code);
    APEX_JSON.write('account',         r.account_code);
    APEX_JSON.write('entitySpecific',  r.entity_specific_code);
    APEX_JSON.write('appropriation',   r.appropriation_code);
    APEX_JSON.write('future1',         r.future1_code);
    APEX_JSON.write('future2',         r.future2_code);
    APEX_JSON.write('isActive',        r.is_active);
    APEX_JSON.write('startDate',       TO_CHAR(r.effective_from,'YYYY-MM-DD'));
    APEX_JSON.write('endDate',         TO_CHAR(r.effective_to,'YYYY-MM-DD'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('gl-codes', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  INSERT INTO dct_gl_code_combinations (
    entity_code, program_code, cost_center_code, budget_group_code, account_code,
    entity_specific_code, appropriation_code, future1_code, future2_code,
    is_active, effective_from, effective_to, created_by, updated_by)
  VALUES (
    APEX_JSON.get_varchar2(p_path => 'entityCode'),
    NVL(APEX_JSON.get_varchar2(p_path => 'ic'), '000000'),
    APEX_JSON.get_varchar2(p_path => 'costCenter'),
    APEX_JSON.get_varchar2(p_path => 'budgetGroupCode'),
    APEX_JSON.get_varchar2(p_path => 'account'),
    NVL(APEX_JSON.get_varchar2(p_path => 'entitySpecific'), '0000000'),
    APEX_JSON.get_varchar2(p_path => 'appropriation'),
    NVL(APEX_JSON.get_varchar2(p_path => 'future1'), '000000'),
    NVL(APEX_JSON.get_varchar2(p_path => 'future2'), '000000'),
    NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), 'Y'),
    NVL(TO_DATE(APEX_JSON.get_varchar2(p_path => 'startDate'),'YYYY-MM-DD'), TRUNC(SYSDATE)),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'endDate'),'YYYY-MM-DD'),
    l_user, l_user)
  RETURNING cc_id INTO l_id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ccId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('gl-codes/[COLON]id');
    def_handler('gl-codes/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_gl_code_combinations SET
    entity_code          = NVL(APEX_JSON.get_varchar2(p_path => 'entityCode'), entity_code),
    program_code         = NVL(APEX_JSON.get_varchar2(p_path => 'ic'), program_code),
    cost_center_code     = NVL(APEX_JSON.get_varchar2(p_path => 'costCenter'), cost_center_code),
    budget_group_code    = NVL(APEX_JSON.get_varchar2(p_path => 'budgetGroupCode'), budget_group_code),
    account_code         = NVL(APEX_JSON.get_varchar2(p_path => 'account'), account_code),
    entity_specific_code = NVL(APEX_JSON.get_varchar2(p_path => 'entitySpecific'), entity_specific_code),
    appropriation_code   = NVL(APEX_JSON.get_varchar2(p_path => 'appropriation'), appropriation_code),
    future1_code         = NVL(APEX_JSON.get_varchar2(p_path => 'future1'), future1_code),
    future2_code         = NVL(APEX_JSON.get_varchar2(p_path => 'future2'), future2_code),
    is_active            = NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), is_active),
    effective_from       = NVL(TO_DATE(APEX_JSON.get_varchar2(p_path => 'startDate'),'YYYY-MM-DD'), effective_from),
    effective_to         = TO_DATE(APEX_JSON.get_varchar2(p_path => 'endDate'),'YYYY-MM-DD'),
    updated_by           = l_user
  WHERE cc_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('gl-codes/[COLON]id', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  -- Soft-deactivate when referenced; hard delete only when unused
  BEGIN
    DELETE FROM dct_gl_code_combinations WHERE cc_id = [COLON]id;
  EXCEPTION WHEN OTHERS THEN
    UPDATE dct_gl_code_combinations SET is_active = 'N', updated_by = l_user
    WHERE cc_id = [COLON]id;
  END;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- REIMBURSEMENTS
    -- =========================================================================
    def_template('reimbursements/all');
    def_handler('reimbursements/all', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (
    SELECT rb.*, pc.pc_number, u.display_name AS employee_name,
           u.employee_number, o.org_name_en AS org_name
    FROM   dct_pc_reimbursements rb
    JOIN   dct_petty_cash pc ON pc.pc_id  = rb.pc_id
    JOIN   dct_users      u  ON u.user_id = pc.user_id
    LEFT JOIN dct_organizations o ON o.org_id = pc.org_id
    ORDER  BY rb.reimb_id DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('reimbId',        r.reimb_id);
    APEX_JSON.write('reimbNumber',    r.reimb_number);
    APEX_JSON.write('pcId',           r.pc_id);
    APEX_JSON.write('pcNumber',       r.pc_number);
    APEX_JSON.write('amount',         r.amount);
    APEX_JSON.write('purpose',        r.purpose);
    APEX_JSON.write('codingType',     r.coding_type);
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('submittedAt',    TO_CHAR(r.submitted_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('employeeName',   r.employee_name);
    APEX_JSON.write('employeeNumber', r.employee_number);
    APEX_JSON.write('orgName',        r.org_name);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('reimbursements/');
    def_handler('reimbursements/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (
    SELECT rb.*, pc.pc_number
    FROM   dct_pc_reimbursements rb
    JOIN   dct_petty_cash pc ON pc.pc_id = rb.pc_id
    WHERE  pc.user_id = l_uid
    ORDER  BY rb.reimb_id DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('reimbId',     r.reimb_id);
    APEX_JSON.write('reimbNumber', r.reimb_number);
    APEX_JSON.write('pcId',        r.pc_id);
    APEX_JSON.write('pcNumber',    r.pc_number);
    APEX_JSON.write('amount',      r.amount);
    APEX_JSON.write('purpose',     r.purpose);
    APEX_JSON.write('codingType',  r.coding_type);
    APEX_JSON.write('status',      r.status);
    APEX_JSON.write('submittedAt', TO_CHAR(r.submitted_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('reimbursements/', 'POST', q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_uid     NUMBER;
  l_pc      dct_petty_cash%ROWTYPE;
  l_id      NUMBER;
  l_number  VARCHAR2(20);
  l_tmpl_id NUMBER;
  l_inst_id NUMBER;
  l_amount  NUMBER;
  l_cnt     NUMBER;
  l_sum     NUMBER := 0;
  l_role_id NUMBER;
  l_new     CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);

  SELECT * INTO l_pc FROM dct_petty_cash
  WHERE pc_id = APEX_JSON.get_number(p_path => 'pcId') FOR UPDATE;

  IF l_pc.status != 'ACTIVE' THEN
    dct_rest.err(400,'Reimbursements can only be raised against an ACTIVE petty cash'); RETURN;
  END IF;
  IF l_pc.user_id != l_uid THEN
    dct_rest.err(403,'You can only raise reimbursements for your own petty cash'); RETURN;
  END IF;

  l_amount := APEX_JSON.get_number(p_path => 'amount');
  IF l_amount IS NULL OR l_amount <= 0 THEN
    dct_rest.err(400,'Amount must be greater than zero'); RETURN;
  END IF;

  l_cnt := NVL(APEX_JSON.get_count(p_path => 'budgetLines'), 0);
  IF l_cnt = 0 THEN dct_rest.err(400,'At least one budget line is required'); RETURN; END IF;
  FOR i IN 1 .. l_cnt LOOP
    l_sum := l_sum + NVL(APEX_JSON.get_number(p_path => 'budgetLines[%d].amount', p0 => i), 0);
  END LOOP;
  IF ROUND(l_sum,2) != ROUND(l_amount,2) THEN
    dct_rest.err(400,'Budget lines total must equal the reimbursement amount'); RETURN;
  END IF;

  l_number := 'RMB-' || TO_CHAR(SYSDATE,'YYYY') || '-' || TO_CHAR(seq_pc_reimb_number.NEXTVAL,'FM00000');

  INSERT INTO dct_pc_reimbursements (
    reimb_number, pc_id, amount, purpose, coding_type, status,
    submitted_at, created_by, updated_by)
  VALUES (
    l_number, l_pc.pc_id, l_amount,
    APEX_JSON.get_varchar2(p_path => 'purpose'),
    NVL(APEX_JSON.get_varchar2(p_path => 'codingType'), l_pc.coding_type),
    'SUBMITTED', SYSTIMESTAMP, l_user, l_user)
  RETURNING reimb_id INTO l_id;

  FOR i IN 1 .. l_cnt LOOP
    INSERT INTO dct_pc_reimb_budget_lines (
      reimb_id, line_num, amount, cc_id, project_number, task_number,
      expenditure_type, description, created_by, updated_by)
    VALUES (
      l_id, i,
      APEX_JSON.get_number  (p_path => 'budgetLines[%d].amount',          p0 => i),
      APEX_JSON.get_number  (p_path => 'budgetLines[%d].ccId',            p0 => i),
      APEX_JSON.get_varchar2(p_path => 'budgetLines[%d].projectNumber',   p0 => i),
      APEX_JSON.get_varchar2(p_path => 'budgetLines[%d].taskNumber',      p0 => i),
      APEX_JSON.get_varchar2(p_path => 'budgetLines[%d].expenditureType', p0 => i),
      APEX_JSON.get_varchar2(p_path => 'budgetLines[%d].description',     p0 => i),
      l_user, l_user);
  END LOOP;

  SELECT at.template_id INTO l_tmpl_id
  FROM   dct_approval_templates at
  JOIN   dct_modules m ON m.module_id = at.module_id
  WHERE  m.module_code = 'PETTY_CASH' AND at.request_type = 'REIMBURSEMENT' AND at.is_active = 'Y'
  FETCH FIRST 1 ROW ONLY;

  INSERT INTO dct_approval_instances (
    template_id, source_module, source_record_id, source_record_ref,
    current_step_seq, overall_status, submitted_by, submitted_at, created_by, updated_by)
  VALUES (
    l_tmpl_id, 'REIMBURSEMENT', l_id, l_number,
    (SELECT MIN(step_seq) FROM dct_approval_steps WHERE template_id = l_tmpl_id),
    'PENDING', l_uid, SYSTIMESTAMP, l_user, l_user)
  RETURNING instance_id INTO l_inst_id;

  UPDATE dct_pc_reimbursements SET approval_instance_id = l_inst_id WHERE reimb_id = l_id;

  BEGIN
    SELECT ast.required_role_id INTO l_role_id
    FROM   dct_approval_steps ast
    WHERE  ast.template_id = l_tmpl_id
    AND    ast.step_seq = (SELECT MIN(step_seq) FROM dct_approval_steps WHERE template_id = l_tmpl_id);
    FOR usr IN (
      SELECT ur.user_id FROM dct_user_roles ur
      WHERE  ur.role_id = l_role_id AND ur.is_active = 'Y'
      AND   (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
    ) LOOP
      dct_notify.send(
        p_recipient_user_id => usr.user_id,
        p_notification_type => 'APPROVAL_REQUEST',
        p_title_en          => 'Reimbursement Pending Approval',
        p_body_en           => 'Reimbursement ' || l_number || ' is awaiting your approval.',
        p_module_code       => 'PETTY_CASH');
    END LOOP;
  EXCEPTION WHEN OTHERS THEN NULL;
  END;

  -- Unified status-transition log
  INSERT INTO dct_request_status_history (
    source_module, source_type, source_id, old_status, new_status, changed_by, comments)
  VALUES ('PC', 'PC_REIMB', l_id, NULL, 'SUBMITTED', l_uid,
          'Reimbursement ' || l_number || ' created and submitted');

  COMMIT;
  l_new := dct_audit_pkg.snap('DCT_PC_REIMBURSEMENTS','reimb_id', TO_CHAR(l_id));
  dct_audit_pkg.log(l_user,'CREATE','DCT_PC_REIMBURSEMENTS', TO_CHAR(l_id), 'PC',
                    p_object_ref=>l_number, p_new=>l_new);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('reimbId',     l_id);
  APEX_JSON.write('reimbNumber', l_number);
  APEX_JSON.write('status',      'SUBMITTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('reimbursements/[COLON]id');
    def_handler('reimbursements/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR r IN (
    SELECT rb.*, pc.pc_number, u.display_name AS employee_name
    FROM   dct_pc_reimbursements rb
    JOIN   dct_petty_cash pc ON pc.pc_id  = rb.pc_id
    JOIN   dct_users      u  ON u.user_id = pc.user_id
    WHERE  rb.reimb_id = [COLON]id
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('reimbId',      r.reimb_id);
    APEX_JSON.write('reimbNumber',  r.reimb_number);
    APEX_JSON.write('pcId',         r.pc_id);
    APEX_JSON.write('pcNumber',     r.pc_number);
    APEX_JSON.write('amount',       r.amount);
    APEX_JSON.write('purpose',      r.purpose);
    APEX_JSON.write('codingType',   r.coding_type);
    APEX_JSON.write('status',       r.status);
    APEX_JSON.write('submittedAt',  TO_CHAR(r.submitted_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('employeeName', r.employee_name);
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('reimbursements/[COLON]id', 'PUT', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20);
  l_old    CLOB;
  l_new    CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT status INTO l_status FROM dct_pc_reimbursements WHERE reimb_id = [COLON]id FOR UPDATE;
  IF l_status != 'DRAFT' THEN
    dct_rest.err(400,'Only DRAFT reimbursements can be updated'); RETURN;
  END IF;
  l_old := dct_audit_pkg.snap('DCT_PC_REIMBURSEMENTS','reimb_id', TO_CHAR([COLON]id));
  dct_rest.parse_body([COLON]body);
  UPDATE dct_pc_reimbursements SET
    amount     = NVL(APEX_JSON.get_number  (p_path => 'amount'), amount),
    purpose    = NVL(APEX_JSON.get_varchar2(p_path => 'purpose'), purpose),
    updated_by = l_user
  WHERE reimb_id = [COLON]id;
  COMMIT;
  l_new := dct_audit_pkg.snap('DCT_PC_REIMBURSEMENTS','reimb_id', TO_CHAR([COLON]id));
  dct_audit_pkg.log(l_user,'UPDATE','DCT_PC_REIMBURSEMENTS', TO_CHAR([COLON]id), 'PC',
                    p_old=>l_old, p_new=>l_new);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('reimbursements/[COLON]id/lines');
    def_handler('reimbursements/[COLON]id/lines', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (
    SELECT bl.*, gl.cc_code
    FROM   dct_pc_reimb_budget_lines bl
    LEFT JOIN dct_gl_code_combinations gl ON gl.cc_id = bl.cc_id
    WHERE  bl.reimb_id = [COLON]id ORDER BY bl.line_num
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('lineId',          r.line_id);
    APEX_JSON.write('reimbId',         r.reimb_id);
    APEX_JSON.write('lineNum',         r.line_num);
    APEX_JSON.write('amount',          r.amount);
    APEX_JSON.write('ccId',            r.cc_id);
    APEX_JSON.write('ccCode',          r.cc_code);
    APEX_JSON.write('projectNumber',   r.project_number);
    APEX_JSON.write('taskNumber',      r.task_number);
    APEX_JSON.write('expenditureType', r.expenditure_type);
    APEX_JSON.write('description',     r.description);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- CLEARINGS
    -- =========================================================================
    def_template('clearings/all');
    def_handler('clearings/all', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (
    SELECT c.*, pc.pc_number, pc.pc_type, pc.amount AS advance_amount,
           u.display_name AS employee_name, u.employee_number
    FROM   dct_pc_clearing c
    JOIN   dct_petty_cash pc ON pc.pc_id  = c.pc_id
    JOIN   dct_users      u  ON u.user_id = pc.user_id
    ORDER  BY c.clearing_id DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('clearingId',     r.clearing_id);
    APEX_JSON.write('clearingNumber', r.clearing_number);
    APEX_JSON.write('pcId',           r.pc_id);
    APEX_JSON.write('pcNumber',       r.pc_number);
    APEX_JSON.write('pcType',         r.pc_type);
    APEX_JSON.write('advanceAmount',  r.advance_amount);
    APEX_JSON.write('amountSpent',    r.amount_spent);
    APEX_JSON.write('amountRefunded', r.amount_refunded);
    APEX_JSON.write('codingType',     r.coding_type);
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('submittedAt',    TO_CHAR(r.submitted_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('employeeName',   r.employee_name);
    APEX_JSON.write('employeeNumber', r.employee_number);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('clearings/');
    def_handler('clearings/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (
    SELECT c.*, pc.pc_number
    FROM   dct_pc_clearing c
    JOIN   dct_petty_cash pc ON pc.pc_id = c.pc_id
    WHERE  pc.user_id = l_uid
    ORDER  BY c.clearing_id DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('clearingId',     r.clearing_id);
    APEX_JSON.write('clearingNumber', r.clearing_number);
    APEX_JSON.write('pcId',           r.pc_id);
    APEX_JSON.write('pcNumber',       r.pc_number);
    APEX_JSON.write('amountSpent',    r.amount_spent);
    APEX_JSON.write('amountRefunded', r.amount_refunded);
    APEX_JSON.write('codingType',     r.coding_type);
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('submittedAt',    TO_CHAR(r.submitted_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('clearings/', 'POST', q'!
DECLARE
  l_user     VARCHAR2(100) := dct_rest.validate_session;
  l_uid      NUMBER;
  l_pc       dct_petty_cash%ROWTYPE;
  l_id       NUMBER;
  l_number   VARCHAR2(20);
  l_tmpl_id  NUMBER;
  l_inst_id  NUMBER;
  l_spent    NUMBER;
  l_refunded NUMBER;
  l_cnt      NUMBER;
  l_sum      NUMBER := 0;
  l_role_id  NUMBER;
  l_new      CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);

  SELECT * INTO l_pc FROM dct_petty_cash
  WHERE pc_id = APEX_JSON.get_number(p_path => 'pcId') FOR UPDATE;

  IF l_pc.status != 'ACTIVE' THEN
    dct_rest.err(400,'Clearing can only be raised against an ACTIVE petty cash'); RETURN;
  END IF;
  IF l_pc.user_id != l_uid THEN
    dct_rest.err(403,'You can only clear your own petty cash'); RETURN;
  END IF;

  l_spent    := NVL(APEX_JSON.get_number(p_path => 'amountSpent'), 0);
  l_refunded := NVL(APEX_JSON.get_number(p_path => 'amountRefunded'), 0);
  IF ROUND(l_spent + l_refunded, 2) != ROUND(l_pc.amount, 2) THEN
    dct_rest.err(400,'Spent (' || l_spent || ') + refunded (' || l_refunded ||
                 ') must equal the advance amount (' || l_pc.amount || ')');
    RETURN;
  END IF;

  l_cnt := NVL(APEX_JSON.get_count(p_path => 'budgetLines'), 0);
  FOR i IN 1 .. l_cnt LOOP
    l_sum := l_sum + NVL(APEX_JSON.get_number(p_path => 'budgetLines[%d].amount', p0 => i), 0);
  END LOOP;
  IF l_spent > 0 AND ROUND(l_sum,2) != ROUND(l_spent,2) THEN
    dct_rest.err(400,'Expense lines total must equal the amount spent'); RETURN;
  END IF;

  l_number := 'CLR-' || TO_CHAR(SYSDATE,'YYYY') || '-' || TO_CHAR(seq_pc_clear_number.NEXTVAL,'FM00000');

  INSERT INTO dct_pc_clearing (
    clearing_number, pc_id, amount_spent, amount_refunded, coding_type,
    status, submitted_at, created_by, updated_by)
  VALUES (
    l_number, l_pc.pc_id, l_spent, l_refunded,
    NVL(APEX_JSON.get_varchar2(p_path => 'codingType'), l_pc.coding_type),
    'SUBMITTED', SYSTIMESTAMP, l_user, l_user)
  RETURNING clearing_id INTO l_id;

  FOR i IN 1 .. l_cnt LOOP
    INSERT INTO dct_pc_clear_budget_lines (
      clearing_id, line_num, amount, cc_id, project_number, task_number,
      expenditure_type, description, created_by, updated_by)
    VALUES (
      l_id, i,
      APEX_JSON.get_number  (p_path => 'budgetLines[%d].amount',          p0 => i),
      APEX_JSON.get_number  (p_path => 'budgetLines[%d].ccId',            p0 => i),
      APEX_JSON.get_varchar2(p_path => 'budgetLines[%d].projectNumber',   p0 => i),
      APEX_JSON.get_varchar2(p_path => 'budgetLines[%d].taskNumber',      p0 => i),
      APEX_JSON.get_varchar2(p_path => 'budgetLines[%d].expenditureType', p0 => i),
      APEX_JSON.get_varchar2(p_path => 'budgetLines[%d].description',     p0 => i),
      l_user, l_user);
  END LOOP;

  SELECT at.template_id INTO l_tmpl_id
  FROM   dct_approval_templates at
  JOIN   dct_modules m ON m.module_id = at.module_id
  WHERE  m.module_code = 'PETTY_CASH' AND at.request_type = 'CLEARING' AND at.is_active = 'Y'
  FETCH FIRST 1 ROW ONLY;

  INSERT INTO dct_approval_instances (
    template_id, source_module, source_record_id, source_record_ref,
    current_step_seq, overall_status, submitted_by, submitted_at, created_by, updated_by)
  VALUES (
    l_tmpl_id, 'CLEARING', l_id, l_number,
    (SELECT MIN(step_seq) FROM dct_approval_steps WHERE template_id = l_tmpl_id),
    'PENDING', l_uid, SYSTIMESTAMP, l_user, l_user)
  RETURNING instance_id INTO l_inst_id;

  UPDATE dct_pc_clearing SET approval_instance_id = l_inst_id WHERE clearing_id = l_id;

  BEGIN
    SELECT ast.required_role_id INTO l_role_id
    FROM   dct_approval_steps ast
    WHERE  ast.template_id = l_tmpl_id
    AND    ast.step_seq = (SELECT MIN(step_seq) FROM dct_approval_steps WHERE template_id = l_tmpl_id);
    FOR usr IN (
      SELECT ur.user_id FROM dct_user_roles ur
      WHERE  ur.role_id = l_role_id AND ur.is_active = 'Y'
      AND   (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
    ) LOOP
      dct_notify.send(
        p_recipient_user_id => usr.user_id,
        p_notification_type => 'APPROVAL_REQUEST',
        p_title_en          => 'Clearing Pending Approval',
        p_body_en           => 'Clearing ' || l_number || ' is awaiting your approval.',
        p_module_code       => 'PETTY_CASH');
    END LOOP;
  EXCEPTION WHEN OTHERS THEN NULL;
  END;

  -- Unified status-transition log
  INSERT INTO dct_request_status_history (
    source_module, source_type, source_id, old_status, new_status, changed_by, comments)
  VALUES ('PC', 'PC_CLEAR', l_id, NULL, 'SUBMITTED', l_uid,
          'Clearing ' || l_number || ' created and submitted');

  COMMIT;
  l_new := dct_audit_pkg.snap('DCT_PC_CLEARING','clearing_id', TO_CHAR(l_id));
  dct_audit_pkg.log(l_user,'CREATE','DCT_PC_CLEARING', TO_CHAR(l_id), 'PC',
                    p_object_ref=>l_number, p_new=>l_new);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('clearingId',     l_id);
  APEX_JSON.write('clearingNumber', l_number);
  APEX_JSON.write('status',         'SUBMITTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('clearings/[COLON]id');
    def_handler('clearings/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR r IN (
    SELECT c.*, pc.pc_number, pc.pc_type, pc.amount AS advance_amount,
           u.display_name AS employee_name
    FROM   dct_pc_clearing c
    JOIN   dct_petty_cash pc ON pc.pc_id  = c.pc_id
    JOIN   dct_users      u  ON u.user_id = pc.user_id
    WHERE  c.clearing_id = [COLON]id
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('clearingId',     r.clearing_id);
    APEX_JSON.write('clearingNumber', r.clearing_number);
    APEX_JSON.write('pcId',           r.pc_id);
    APEX_JSON.write('pcNumber',       r.pc_number);
    APEX_JSON.write('pcType',         r.pc_type);
    APEX_JSON.write('advanceAmount',  r.advance_amount);
    APEX_JSON.write('amountSpent',    r.amount_spent);
    APEX_JSON.write('amountRefunded', r.amount_refunded);
    APEX_JSON.write('codingType',     r.coding_type);
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('submittedAt',    TO_CHAR(r.submitted_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('employeeName',   r.employee_name);
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('clearings/[COLON]id', 'PUT', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20);
  l_old    CLOB;
  l_new    CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT status INTO l_status FROM dct_pc_clearing WHERE clearing_id = [COLON]id FOR UPDATE;
  IF l_status != 'DRAFT' THEN
    dct_rest.err(400,'Only DRAFT clearings can be updated'); RETURN;
  END IF;
  l_old := dct_audit_pkg.snap('DCT_PC_CLEARING','clearing_id', TO_CHAR([COLON]id));
  dct_rest.parse_body([COLON]body);
  UPDATE dct_pc_clearing SET
    amount_spent    = NVL(APEX_JSON.get_number(p_path => 'amountSpent'), amount_spent),
    amount_refunded = NVL(APEX_JSON.get_number(p_path => 'amountRefunded'), amount_refunded),
    updated_by      = l_user
  WHERE clearing_id = [COLON]id;
  COMMIT;
  l_new := dct_audit_pkg.snap('DCT_PC_CLEARING','clearing_id', TO_CHAR([COLON]id));
  dct_audit_pkg.log(l_user,'UPDATE','DCT_PC_CLEARING', TO_CHAR([COLON]id), 'PC',
                    p_old=>l_old, p_new=>l_new);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('clearings/[COLON]id/lines');
    def_handler('clearings/[COLON]id/lines', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (
    SELECT bl.*, gl.cc_code
    FROM   dct_pc_clear_budget_lines bl
    LEFT JOIN dct_gl_code_combinations gl ON gl.cc_id = bl.cc_id
    WHERE  bl.clearing_id = [COLON]id ORDER BY bl.line_num
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('lineId',          r.line_id);
    APEX_JSON.write('clearingId',      r.clearing_id);
    APEX_JSON.write('lineNum',         r.line_num);
    APEX_JSON.write('amount',          r.amount);
    APEX_JSON.write('ccId',            r.cc_id);
    APEX_JSON.write('ccCode',          r.cc_code);
    APEX_JSON.write('projectNumber',   r.project_number);
    APEX_JSON.write('taskNumber',      r.task_number);
    APEX_JSON.write('expenditureType', r.expenditure_type);
    APEX_JSON.write('description',     r.description);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- APPROVALS
    -- =========================================================================
    def_template('approvals/pending');
    def_handler('approvals/pending', 'GET', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_roles VARCHAR2(4000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_roles := ',' || dct_auth.get_user_roles(l_user) || ',';
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (
    SELECT ai.instance_id, ai.source_module, ai.source_record_id,
           ai.source_record_ref, ai.submitted_at, ai.overall_status,
           ast.step_name, rol.role_code AS required_role,
           sub.display_name AS submitted_by_name,
           CASE ai.source_module
             WHEN 'PETTY_CASH'    THEN pc.amount
             WHEN 'REIMBURSEMENT' THEN rb.amount
             WHEN 'CLEARING'      THEN cl.amount_spent
           END AS amount
    FROM   dct_approval_instances ai
    JOIN   dct_approval_steps     ast ON ast.template_id = ai.template_id
                                     AND ast.step_seq    = ai.current_step_seq
    JOIN   dct_roles              rol ON rol.role_id     = ast.required_role_id
    JOIN   dct_users              sub ON sub.user_id     = ai.submitted_by
    LEFT JOIN dct_petty_cash       pc ON pc.pc_id        = ai.source_record_id
                                     AND ai.source_module = 'PETTY_CASH'
    LEFT JOIN dct_pc_reimbursements rb ON rb.reimb_id    = ai.source_record_id
                                     AND ai.source_module = 'REIMBURSEMENT'
    LEFT JOIN dct_pc_clearing      cl ON cl.clearing_id  = ai.source_record_id
                                     AND ai.source_module = 'CLEARING'
    WHERE  ai.overall_status = 'PENDING'
      AND  ai.source_module IN ('PETTY_CASH','REIMBURSEMENT','CLEARING')
      AND  (INSTR(l_roles, ',' || rol.role_code || ',') > 0
            OR INSTR(l_roles, ',SYS_ADMIN,') > 0)
    ORDER BY ai.submitted_at
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('instanceId',     r.instance_id);
    APEX_JSON.write('requestRef',     r.source_record_ref);
    APEX_JSON.write('requestType',    r.source_module);
    APEX_JSON.write('sourceRecordId', r.source_record_id);
    APEX_JSON.write('submittedBy',    r.submitted_by_name);
    APEX_JSON.write('submittedAt',    TO_CHAR(r.submitted_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('currentStep',    r.step_name);
    APEX_JSON.write('amount',         r.amount);
    APEX_JSON.write('overallStatus',  r.overall_status);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('approvals/[COLON]id/action');
    def_handler('approvals/[COLON]id/action', 'POST', q'!
DECLARE
  l_user     VARCHAR2(100) := dct_rest.validate_session;
  l_iid      NUMBER        := [COLON]id;
  l_uid      NUMBER;
  l_action   VARCHAR2(20);
  l_comments VARCHAR2(4000);
  l_inst     dct_approval_instances%ROWTYPE;
  l_step_id  NUMBER;
  l_amount   NUMBER := 0;
  l_next     NUMBER := NULL;
  l_owner    NUMBER;
  l_hist_old VARCHAR2(30);
  l_src_type VARCHAR2(30);

  -- Unified status-transition log row for this approval action
  PROCEDURE hist (p_new VARCHAR2, p_cmt VARCHAR2) IS
  BEGIN
    INSERT INTO dct_request_status_history (
      source_module, source_type, source_id, old_status, new_status, changed_by, comments)
    VALUES ('PC', l_src_type, l_inst.source_record_id, l_hist_old, p_new, l_uid, p_cmt);
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_action   := UPPER(APEX_JSON.get_varchar2(p_path => 'action'));
  l_comments := APEX_JSON.get_varchar2(p_path => 'comments');

  IF l_action NOT IN ('APPROVED','REJECTED','RETURNED') THEN
    dct_rest.err(400,'Invalid action. Use APPROVED, REJECTED, or RETURNED'); RETURN;
  END IF;
  IF l_comments IS NULL THEN
    dct_rest.err(400,'Comments are required'); RETURN;
  END IF;

  SELECT * INTO l_inst FROM dct_approval_instances WHERE instance_id = l_iid;
  IF l_inst.overall_status != 'PENDING' THEN
    dct_rest.err(400,'Approval instance is not PENDING'); RETURN;
  END IF;

  l_src_type := CASE l_inst.source_module
                  WHEN 'PETTY_CASH'    THEN 'PC'
                  WHEN 'REIMBURSEMENT' THEN 'PC_REIMB'
                  ELSE 'PC_CLEAR' END;
  BEGIN
    IF l_inst.source_module = 'PETTY_CASH' THEN
      SELECT status INTO l_hist_old FROM dct_petty_cash WHERE pc_id = l_inst.source_record_id;
    ELSIF l_inst.source_module = 'REIMBURSEMENT' THEN
      SELECT status INTO l_hist_old FROM dct_pc_reimbursements WHERE reimb_id = l_inst.source_record_id;
    ELSIF l_inst.source_module = 'CLEARING' THEN
      SELECT status INTO l_hist_old FROM dct_pc_clearing WHERE clearing_id = l_inst.source_record_id;
    END IF;
  EXCEPTION WHEN OTHERS THEN l_hist_old := NULL;
  END;

  SELECT step_id INTO l_step_id
  FROM dct_approval_steps
  WHERE template_id = l_inst.template_id AND step_seq = l_inst.current_step_seq;

  INSERT INTO dct_approval_actions (instance_id, step_id, actioned_by, action, comments)
  VALUES (l_iid, l_step_id, l_uid, l_action, l_comments);

  IF l_action = 'APPROVED' THEN
    BEGIN
      IF l_inst.source_module = 'PETTY_CASH' THEN
        SELECT amount INTO l_amount FROM dct_petty_cash WHERE pc_id = l_inst.source_record_id;
      ELSIF l_inst.source_module = 'REIMBURSEMENT' THEN
        SELECT amount INTO l_amount FROM dct_pc_reimbursements WHERE reimb_id = l_inst.source_record_id;
      ELSIF l_inst.source_module = 'CLEARING' THEN
        SELECT amount_spent INTO l_amount FROM dct_pc_clearing WHERE clearing_id = l_inst.source_record_id;
      END IF;
    EXCEPTION WHEN OTHERS THEN l_amount := 0; END;

    FOR nxt IN (
      SELECT step_seq FROM dct_approval_steps
      WHERE template_id    = l_inst.template_id
        AND step_seq       > l_inst.current_step_seq
        AND (condition_type = 'ALWAYS'
             OR (condition_type = 'AMOUNT' AND amount_operator = '>='  AND l_amount >= amount_threshold)
             OR (condition_type = 'AMOUNT' AND amount_operator = '>'   AND l_amount >  amount_threshold)
             OR (condition_type = 'AMOUNT' AND amount_operator = '<='  AND l_amount <= amount_threshold)
             OR (condition_type = 'AMOUNT' AND amount_operator = '<'   AND l_amount <  amount_threshold))
      ORDER BY step_seq FETCH FIRST 1 ROW ONLY
    ) LOOP
      l_next := nxt.step_seq;
    END LOOP;

    IF l_next IS NOT NULL THEN
      UPDATE dct_approval_instances SET
        current_step_seq = l_next, last_action_at = SYSTIMESTAMP,
        updated_by = l_user, updated_at = SYSTIMESTAMP
      WHERE instance_id = l_iid;
      -- Source moves into PENDING_APPROVAL while mid-chain
      IF l_inst.source_module = 'PETTY_CASH' THEN
        UPDATE dct_petty_cash SET status = 'PENDING_APPROVAL', updated_by = l_user
        WHERE pc_id = l_inst.source_record_id AND status = 'SUBMITTED';
      ELSIF l_inst.source_module = 'REIMBURSEMENT' THEN
        UPDATE dct_pc_reimbursements SET status = 'PENDING_APPROVAL', updated_by = l_user
        WHERE reimb_id = l_inst.source_record_id AND status = 'SUBMITTED';
      ELSIF l_inst.source_module = 'CLEARING' THEN
        UPDATE dct_pc_clearing SET status = 'PENDING_APPROVAL', updated_by = l_user
        WHERE clearing_id = l_inst.source_record_id AND status = 'SUBMITTED';
      END IF;
      IF NVL(l_hist_old,'~') != 'PENDING_APPROVAL' THEN
        hist('PENDING_APPROVAL', 'Step approved - moved to next approval step: ' || l_comments);
      END IF;
    ELSE
      -- Final approval
      UPDATE dct_approval_instances SET
        overall_status = 'APPROVED', current_step_seq = NULL,
        completed_at = SYSTIMESTAMP, last_action_at = SYSTIMESTAMP,
        updated_by = l_user, updated_at = SYSTIMESTAMP
      WHERE instance_id = l_iid;

      IF l_inst.source_module = 'PETTY_CASH' THEN
        -- Stays PENDING_APPROVAL until Finance disburses (status → ACTIVE)
        UPDATE dct_petty_cash SET status = 'PENDING_APPROVAL', updated_by = l_user
        WHERE pc_id = l_inst.source_record_id;
        hist('PENDING_APPROVAL', 'Fully approved - awaiting disbursement: ' || l_comments);
        SELECT user_id, pc_number INTO l_owner, l_comments
        FROM dct_petty_cash WHERE pc_id = l_inst.source_record_id;
        BEGIN
          dct_notify.send(l_owner, 'STATUS_UPDATE', 'Petty Cash Approved',
            'Your petty cash ' || l_comments || ' is approved and awaiting disbursement.',
            p_module_code => 'PETTY_CASH');
        EXCEPTION WHEN OTHERS THEN NULL; END;
      ELSIF l_inst.source_module = 'REIMBURSEMENT' THEN
        UPDATE dct_pc_reimbursements SET status = 'APPROVED', updated_by = l_user
        WHERE reimb_id = l_inst.source_record_id;
        hist('APPROVED', 'Final approval: ' || l_comments);
        -- Queue a Fusion AP invoice (no-op unless PETTY_CASH.FUSION_POST_REIMB=Y)
        dct_pc_fusion_pkg.enqueue_fusion_action(l_inst.source_record_id);
      ELSIF l_inst.source_module = 'CLEARING' THEN
        UPDATE dct_pc_clearing SET status = 'APPROVED', updated_by = l_user
        WHERE clearing_id = l_inst.source_record_id;
        hist('APPROVED', 'Final approval: ' || l_comments);
        -- Queue a Fusion AP invoice (no-op unless PETTY_CASH.FUSION_POST_CLEARING=Y)
        dct_pc_fusion_pkg.enqueue_clearing_action(l_inst.source_record_id);
        -- Close the parent petty cash (logged as its own transition)
        DECLARE
          l_pcid  NUMBER;
          l_pcold VARCHAR2(30);
        BEGIN
          SELECT pc_id INTO l_pcid FROM dct_pc_clearing WHERE clearing_id = l_inst.source_record_id;
          SELECT status INTO l_pcold FROM dct_petty_cash WHERE pc_id = l_pcid;
          UPDATE dct_petty_cash SET status = 'CLOSED', closed_date = SYSDATE, updated_by = l_user
          WHERE pc_id = l_pcid;
          INSERT INTO dct_request_status_history (
            source_module, source_type, source_id, old_status, new_status, changed_by, comments)
          VALUES ('PC', 'PC', l_pcid, l_pcold, 'CLOSED', l_uid,
                  'Closed by approved clearing ' || l_inst.source_record_ref);
        END;
      END IF;
    END IF;

  ELSE
    -- REJECTED or RETURNED
    UPDATE dct_approval_instances SET
      overall_status = l_action, current_step_seq = NULL,
      completed_at = SYSTIMESTAMP, last_action_at = SYSTIMESTAMP,
      updated_by = l_user, updated_at = SYSTIMESTAMP
    WHERE instance_id = l_iid;

    IF l_inst.source_module = 'PETTY_CASH' THEN
      UPDATE dct_petty_cash SET
        status = CASE l_action WHEN 'REJECTED' THEN 'REJECTED' ELSE 'DRAFT' END,
        updated_by = l_user
      WHERE pc_id = l_inst.source_record_id;
    ELSIF l_inst.source_module = 'REIMBURSEMENT' THEN
      UPDATE dct_pc_reimbursements SET
        status = CASE l_action WHEN 'REJECTED' THEN 'REJECTED' ELSE 'DRAFT' END,
        updated_by = l_user
      WHERE reimb_id = l_inst.source_record_id;
    ELSIF l_inst.source_module = 'CLEARING' THEN
      UPDATE dct_pc_clearing SET
        status = CASE l_action WHEN 'REJECTED' THEN 'REJECTED' ELSE 'DRAFT' END,
        updated_by = l_user
      WHERE clearing_id = l_inst.source_record_id;
    END IF;
    hist(CASE l_action WHEN 'REJECTED' THEN 'REJECTED' ELSE 'DRAFT' END,
         l_action || ': ' || l_comments);
  END IF;

  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('action', l_action);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('approval-templates');
    def_handler('approval-templates', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (
    SELECT at.template_id, at.template_code, at.template_name,
           at.request_type, at.is_sequential, at.is_active
    FROM   dct_approval_templates at
    JOIN   dct_modules m ON m.module_id = at.module_id
    WHERE  m.module_code = 'PETTY_CASH'
    ORDER  BY at.template_id
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('templateId',   r.template_id);
    APEX_JSON.write('templateCode', r.template_code);
    APEX_JSON.write('templateName', r.template_name);
    APEX_JSON.write('requestType',  r.request_type);
    APEX_JSON.write('isSequential', r.is_sequential);
    APEX_JSON.write('isActive',     r.is_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('approval-templates/[COLON]id/steps');
    def_handler('approval-templates/[COLON]id/steps', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (
    SELECT s.step_id, s.step_seq, s.step_name, s.step_type,
           rol.role_code AS required_role,
           s.condition_type, s.amount_operator, s.amount_threshold,
           s.escalation_days
    FROM   dct_approval_steps s
    LEFT JOIN dct_roles rol ON rol.role_id = s.required_role_id
    WHERE  s.template_id = [COLON]id
    ORDER  BY s.step_seq
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('stepId',          r.step_id);
    APEX_JSON.write('templateId',      TO_NUMBER([COLON]id));
    APEX_JSON.write('stepSeq',         r.step_seq);
    APEX_JSON.write('stepName',        r.step_name);
    APEX_JSON.write('stepType',        r.step_type);
    APEX_JSON.write('requiredRole',    r.required_role);
    APEX_JSON.write('conditionType',   r.condition_type);
    APEX_JSON.write('amountOperator',  r.amount_operator);
    APEX_JSON.write('amountThreshold', r.amount_threshold);
    APEX_JSON.write('escalationDays',  r.escalation_days);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- SETTINGS
    -- =========================================================================
    def_template('settings');
    def_handler('settings', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (
    SELECT ms.setting_id, ms.setting_key,
           -- Never expose secrets through the API (API keys, passwords, tokens)
           CASE WHEN ms.setting_key LIKE '%API_KEY%'
                  OR ms.setting_key LIKE '%SECRET%'
                  OR ms.setting_key LIKE '%PASSWORD%'
                  OR ms.setting_key LIKE '%TOKEN%'
                THEN CASE WHEN ms.setting_value IS NULL THEN NULL ELSE '********' END
                ELSE ms.setting_value END AS setting_value,
           ms.setting_label, ms.setting_description,
           ms.value_type, ms.allowed_values, ms.default_value,
           TO_CHAR(ms.effective_date,'YYYY-MM-DD') AS eff_date
    FROM   dct_module_settings ms JOIN dct_modules m ON m.module_id = ms.module_id
    WHERE  m.module_code = 'PETTY_CASH'
    ORDER  BY ms.setting_key
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('settingId',          r.setting_id);
    APEX_JSON.write('settingKey',         r.setting_key);
    APEX_JSON.write('settingValue',       r.setting_value);
    APEX_JSON.write('settingLabel',       r.setting_label);
    APEX_JSON.write('settingDescription', r.setting_description);
    APEX_JSON.write('valueType',          r.value_type);
    APEX_JSON.write('allowedValues',      r.allowed_values);
    APEX_JSON.write('defaultValue',       r.default_value);
    APEX_JSON.write('effectiveDate',      r.eff_date);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('settings/[COLON]id');
    def_handler('settings/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  -- '********' is the masked placeholder for secrets — never write it back
  IF APEX_JSON.get_varchar2(p_path => 'settingValue') = '********' THEN
    dct_rest.json_header;
    APEX_JSON.initialize_output;
    APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.write('skipped', 'masked value'); APEX_JSON.close_object;
    RETURN;
  END IF;
  UPDATE dct_module_settings SET
    setting_value  = APEX_JSON.get_varchar2(p_path => 'settingValue'),
    effective_date = NVL(TO_DATE(APEX_JSON.get_varchar2(p_path => 'effectiveDate'),'YYYY-MM-DD'), effective_date),
    updated_by     = l_user,
    updated_at     = SYSTIMESTAMP
  WHERE setting_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('settings/[COLON]id/reset');
    def_handler('settings/[COLON]id/reset', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  UPDATE dct_module_settings SET
    setting_value = default_value,
    updated_by    = l_user,
    updated_at    = SYSTIMESTAMP
  WHERE setting_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- NOTIFICATIONS (mark-all-read before [COLON]id/read — pattern precedence)
    -- =========================================================================
    def_template('notifications/');
    def_handler('notifications/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_array;
  FOR r IN (
    SELECT notification_id, title_en, body_en, notification_type, is_read, created_at
    FROM   dct_notifications
    WHERE  recipient_user_id = l_uid
      AND  (module_code = 'PETTY_CASH' OR module_code IS NULL)
      AND  (expires_at IS NULL OR expires_at > SYSTIMESTAMP)
    ORDER BY created_at DESC
    FETCH FIRST 50 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('notifId',   r.notification_id);
    APEX_JSON.write('title',     r.title_en);
    APEX_JSON.write('message',   r.body_en);
    APEX_JSON.write('type',      r.notification_type);
    APEX_JSON.write('isRead',    r.is_read);
    APEX_JSON.write('createdAt', TO_CHAR(r.created_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('notifications/mark-all-read');
    def_handler('notifications/mark-all-read', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  UPDATE dct_notifications SET is_read = 'Y', read_at = SYSTIMESTAMP
  WHERE  recipient_user_id = l_uid
    AND  (module_code = 'PETTY_CASH' OR module_code IS NULL)
    AND  is_read = 'N';
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('notifications/[COLON]id/read');
    def_handler('notifications/[COLON]id/read', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  UPDATE dct_notifications SET is_read = 'Y', read_at = SYSTIMESTAMP
  WHERE  notification_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_pc_ords_tmp;
/

SHOW ERRORS PROCEDURE setup_pc_ords_tmp

BEGIN
    setup_pc_ords_tmp;
END;
/

DROP PROCEDURE setup_pc_ords_tmp;

PROMPT
PROMPT === 06_pc_ords.sql complete ===
PROMPT ORDS module pc.rest published at /ords/admin/pc/
