-- =============================================================================
-- Credit Cards Module (App 202) -- ORDS REST API
-- File    : 09_cc_ords.sql
-- Schema  : registered under ADMIN (the only REST-routable schema on ADB)
-- Base URL: /ords/admin/cc/
-- Run     : sql -name prod_mcp @09_cc_ords.sql  (fresh session - synonym rule)
-- =============================================================================
-- Workflow endpoints delegate to prod.dct_cc_pkg (04_cc_pkg.sql). GET handlers
-- read the dct_cc_*_v views. Pagination envelope: {items,total,limit,offset}.
-- Audit fields rendered in Asia/Dubai local time. Documents and expense lines
-- live in the unified dct_documents / dct_budget_coding_lines tables.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- 1. ADMIN synonyms for every PROD object the handlers touch
-- =============================================================================
CREATE OR REPLACE SYNONYM dct_credit_cards            FOR prod.dct_credit_cards;
CREATE OR REPLACE SYNONYM dct_cc_requests             FOR prod.dct_cc_requests;
CREATE OR REPLACE SYNONYM dct_cc_replenishments       FOR prod.dct_cc_replenishments;
CREATE OR REPLACE SYNONYM dct_cc_proxies              FOR prod.dct_cc_proxies;
CREATE OR REPLACE SYNONYM dct_cc_card_limit_history   FOR prod.dct_cc_card_limit_history;
CREATE OR REPLACE SYNONYM dct_cc_card_v               FOR prod.dct_cc_card_v;
CREATE OR REPLACE SYNONYM dct_cc_request_v            FOR prod.dct_cc_request_v;
CREATE OR REPLACE SYNONYM dct_cc_replenishment_v      FOR prod.dct_cc_replenishment_v;
CREATE OR REPLACE SYNONYM dct_cc_pending_replenishment_v FOR prod.dct_cc_pending_replenishment_v;
CREATE OR REPLACE SYNONYM dct_cc_active_proxy_v       FOR prod.dct_cc_active_proxy_v;
CREATE OR REPLACE SYNONYM dct_cc_pkg                  FOR prod.dct_cc_pkg;
CREATE OR REPLACE SYNONYM dct_doc_requirements        FOR prod.dct_doc_requirements;
CREATE OR REPLACE SYNONYM dct_budget_coding_lines     FOR prod.dct_budget_coding_lines;
CREATE OR REPLACE SYNONYM dct_document_types          FOR prod.dct_document_types;
CREATE OR REPLACE SYNONYM dct_delegations             FOR prod.dct_delegations;
-- shared objects (dct_rest, dct_auth, dct_users, dct_documents, dct_modules,
-- dct_module_settings, dct_approval_*, dct_notifications, dct_lookup_*,
-- dct_organizations, dct_gl_code_combinations, dct_request_status_history)
-- already have ADMIN synonyms from earlier phases.

-- =============================================================================
-- 2. Module + handlers (wrapped in DDL so SQLcl skips bind scanning)
-- =============================================================================
CREATE OR REPLACE PROCEDURE setup_cc_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'cc.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;

    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name    => c_mod,
            p_pattern        => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method         => p_method,
            p_source_type    => ORDS.source_type_plsql,
            p_source         => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

    PROCEDURE def_media(p_pattern VARCHAR2, p_source VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name  => c_mod,
            p_pattern      => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method       => 'GET',
            p_source_type  => ORDS.SOURCE_TYPE_MEDIA,
            p_source       => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

BEGIN

    BEGIN
        ORDS.DELETE_MODULE(p_module_name => c_mod);
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    ORDS.DEFINE_MODULE(
        p_module_name    => c_mod,
        p_base_path      => '/cc/',
        p_items_per_page => 100,
        p_status         => 'PUBLISHED',
        p_comments       => 'i-Finance -- Credit Cards REST API (App 202)');

    -- =========================================================================
    -- DASHBOARD
    -- =========================================================================
    def_template('dashboard/stats');
    def_handler('dashboard/stats', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_active_cards NUMBER; l_total_limit NUMBER;
  l_pend_req NUMBER; l_repl_due NUMBER; l_repl_open NUMBER; l_month_total NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*), NVL(SUM(credit_limit),0) INTO l_active_cards, l_total_limit
  FROM dct_credit_cards WHERE status = 'ACTIVE';
  SELECT COUNT(*) INTO l_pend_req
  FROM dct_cc_requests WHERE status IN ('SUBMITTED','UNDER_REVIEW');
  SELECT COUNT(*) INTO l_repl_due FROM dct_cc_pending_replenishment_v;
  SELECT COUNT(*) INTO l_repl_open
  FROM dct_cc_replenishments WHERE status IN ('SUBMITTED','UNDER_REVIEW');
  SELECT NVL(SUM(total_amount),0) INTO l_month_total
  FROM dct_cc_replenishments
  WHERE period_month = EXTRACT(MONTH FROM SYSDATE)
    AND period_year  = EXTRACT(YEAR  FROM SYSDATE)
    AND status != 'REJECTED';
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('activeCards',      l_active_cards);
  APEX_JSON.write('totalLimit',       l_total_limit);
  APEX_JSON.write('pendingRequests',  l_pend_req);
  APEX_JSON.write('replenishmentsDue',l_repl_due);
  APEX_JSON.write('replenishmentsOpen', l_repl_open);
  APEX_JSON.write('monthTotal',       l_month_total);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('dashboard/charts');
    def_handler('dashboard/charts', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_active NUMBER; l_submitted NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_active FROM dct_credit_cards WHERE status = 'ACTIVE';
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  -- card limits by organisation
  APEX_JSON.open_array('limitsByOrg');
  FOR r IN (
    SELECT o.org_name_en, COUNT(*) AS card_count, NVL(SUM(cc.credit_limit),0) AS total_limit
    FROM   dct_credit_cards cc
    JOIN   dct_organizations o ON o.org_id = cc.org_id
    WHERE  cc.status = 'ACTIVE'
    GROUP BY o.org_name_en
    ORDER BY 3 DESC FETCH FIRST 8 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('org',        r.org_name_en);
    APEX_JSON.write('cardCount',  r.card_count);
    APEX_JSON.write('totalLimit', r.total_limit);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  -- replenishment compliance: submitted vs cards due, last 6 months
  APEX_JSON.open_array('replCompliance');
  FOR m IN (
    SELECT TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'), 1 - LEVEL), 'Mon YYYY') AS month_label,
           EXTRACT(MONTH FROM ADD_MONTHS(TRUNC(SYSDATE,'MM'), 1 - LEVEL)) AS mth,
           EXTRACT(YEAR  FROM ADD_MONTHS(TRUNC(SYSDATE,'MM'), 1 - LEVEL)) AS yr,
           LEVEL AS lvl
    FROM dual CONNECT BY LEVEL <= 6
    ORDER BY lvl DESC
  ) LOOP
    SELECT COUNT(*) INTO l_submitted
    FROM dct_cc_replenishments
    WHERE period_month = m.mth AND period_year = m.yr AND status != 'REJECTED';
    APEX_JSON.open_object;
    APEX_JSON.write('month',     m.month_label);
    APEX_JSON.write('submitted', l_submitted);
    APEX_JSON.write('due',       l_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- CARDS
    -- =========================================================================
    def_template('cards/');
    def_handler('cards/', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
  l_mine   VARCHAR2(1)   := UPPER([COLON]mine);
  l_status VARCHAR2(20)  := UPPER([COLON]status);
  l_search VARCHAR2(200) := [COLON]search;
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT COUNT(*) INTO l_total FROM dct_cc_card_v c
  WHERE (l_mine IS NULL OR l_mine != 'Y' OR c.holder_user_id = l_uid)
    AND (l_status IS NULL OR c.status = l_status)
    AND (l_search IS NULL OR UPPER(c.cc_number || ' ' || c.holder_name || ' ' || c.org_name)
         LIKE '%' || UPPER(l_search) || '%');
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT * FROM dct_cc_card_v c
    WHERE (l_mine IS NULL OR l_mine != 'Y' OR c.holder_user_id = l_uid)
      AND (l_status IS NULL OR c.status = l_status)
      AND (l_search IS NULL OR UPPER(c.cc_number || ' ' || c.holder_name || ' ' || c.org_name)
           LIKE '%' || UPPER(l_search) || '%')
    ORDER BY c.cc_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('ccId',             r.cc_id);
    APEX_JSON.write('ccNumber',         r.cc_number);
    APEX_JSON.write('holderUserId',     r.holder_user_id);
    APEX_JSON.write('holderName',       r.holder_name);
    APEX_JSON.write('employeeNum',      NVL(r.employee_num, ''));
    APEX_JSON.write('orgName',          r.org_name);
    APEX_JSON.write('creditLimit',      r.credit_limit);
    APEX_JSON.write('expiryDate',       TO_CHAR(r.expiry_date, 'YYYY-MM-DD'));
    APEX_JSON.write('status',           r.status);
    APEX_JSON.write('pendingOperation', NVL(r.pending_operation, ''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('cards/register');
    def_handler('cards/register', 'POST', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_cc_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'CC_ADMIN') AND NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only CC Admin can register cards'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  dct_cc_pkg.register_card(
    p_request_id     => APEX_JSON.get_number(p_path => 'requestId'),
    p_holder_user_id => APEX_JSON.get_number(p_path => 'holderUserId'),
    p_mother_name    => APEX_JSON.get_varchar2(p_path => 'motherName'),
    p_nationality    => APEX_JSON.get_varchar2(p_path => 'nationality'),
    p_credit_limit   => APEX_JSON.get_number(p_path => 'creditLimit'),
    p_expiry_date    => TO_DATE(APEX_JSON.get_varchar2(p_path => 'expiryDate'), 'YYYY-MM-DD'),
    p_email          => APEX_JSON.get_varchar2(p_path => 'email'),
    p_org_id         => APEX_JSON.get_number(p_path => 'orgId'),
    p_cost_center    => APEX_JSON.get_varchar2(p_path => 'costCenter'),
    p_user_id        => dct_auth.get_user_id(l_user),
    p_cc_id          => l_cc_id);
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ccId', l_cc_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('cards/[COLON]id');
    def_handler('cards/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM dct_cc_card_v WHERE cc_id = [COLON]id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('ccId',             r.cc_id);
    APEX_JSON.write('ccNumber',         r.cc_number);
    APEX_JSON.write('holderUserId',     r.holder_user_id);
    APEX_JSON.write('holderName',       r.holder_name);
    APEX_JSON.write('employeeNum',      NVL(r.employee_num, ''));
    APEX_JSON.write('username',         r.username);
    APEX_JSON.write('motherName',       r.mother_name);
    APEX_JSON.write('nationality',      r.nationality);
    APEX_JSON.write('creditLimit',      r.credit_limit);
    APEX_JSON.write('expiryDate',       TO_CHAR(r.expiry_date, 'YYYY-MM-DD'));
    APEX_JSON.write('email',            r.email);
    APEX_JSON.write('orgId',            r.org_id);
    APEX_JSON.write('orgName',          r.org_name);
    APEX_JSON.write('costCenter',       NVL(r.cost_center, ''));
    APEX_JSON.write('bankName',         NVL(r.bank_name, ''));
    APEX_JSON.write('bankCustomerYn',   r.bank_customer_yn);
    APEX_JSON.write('bankMobileYn',     r.bank_mobile_yn);
    APEX_JSON.write('bankEmailYn',      r.bank_email_yn);
    APEX_JSON.write('status',           r.status);
    APEX_JSON.write('pendingOperation', NVL(r.pending_operation, ''));
    APEX_JSON.write('notes',            NVL(r.notes, ''));
    APEX_JSON.write('createdBy',        r.created_by);
    APEX_JSON.write('createdAt',        TO_CHAR(FROM_TZ(CAST(r.created_at AS TIMESTAMP), 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.write('updatedBy',        r.updated_by);
    APEX_JSON.write('updatedAt',        TO_CHAR(FROM_TZ(CAST(r.updated_at AS TIMESTAMP), 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('cards/[COLON]id/limit-history');
    def_handler('cards/[COLON]id/limit-history', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT * FROM dct_cc_card_limit_history
    WHERE cc_id = [COLON]id ORDER BY changed_at DESC, history_id DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('historyId',  r.history_id);
    APEX_JSON.write('oldLimit',   r.old_limit);
    APEX_JSON.write('newLimit',   r.new_limit);
    APEX_JSON.write('changeType', r.change_type);
    APEX_JSON.write('requestId',  r.request_id);
    APEX_JSON.write('changedAt',  TO_CHAR(r.changed_at, 'YYYY-MM-DD'));
    APEX_JSON.write('changedBy',  NVL(r.changed_by, ''));
    APEX_JSON.write('notes',      NVL(r.notes, ''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- REQUESTS
    -- =========================================================================
    def_template('requests/');
    def_handler('requests/', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
  l_mine   VARCHAR2(1)   := UPPER([COLON]mine);
  l_status VARCHAR2(20)  := UPPER([COLON]status);
  l_type   VARCHAR2(20)  := UPPER([COLON]type);
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT COUNT(*) INTO l_total FROM dct_cc_request_v r
  WHERE (l_mine IS NULL OR l_mine != 'Y' OR r.holder_user_id = l_uid OR r.created_by = l_user)
    AND (l_status IS NULL OR r.status = l_status)
    AND (l_type IS NULL OR r.request_type = l_type);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT * FROM dct_cc_request_v r
    WHERE (l_mine IS NULL OR l_mine != 'Y' OR r.holder_user_id = l_uid OR r.created_by = l_user)
      AND (l_status IS NULL OR r.status = l_status)
      AND (l_type IS NULL OR r.request_type = l_type)
    ORDER BY r.request_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('requestId',         r.request_id);
    APEX_JSON.write('requestNumber',     r.request_number);
    APEX_JSON.write('ccId',              r.cc_id);
    APEX_JSON.write('ccNumber',          NVL(r.cc_number, ''));
    APEX_JSON.write('holderName',        NVL(r.holder_name, ''));
    APEX_JSON.write('requestType',       r.request_type);
    APEX_JSON.write('requestedLimit',    r.requested_limit);
    APEX_JSON.write('replacementReason', NVL(r.replacement_reason, ''));
    APEX_JSON.write('status',            r.status);
    APEX_JSON.write('createdByName',     NVL(r.created_by_name, r.created_by));
    APEX_JSON.write('submittedAt',       TO_CHAR(r.submitted_at, 'YYYY-MM-DD'));
    APEX_JSON.write('createdAt',         TO_CHAR(r.created_at, 'YYYY-MM-DD'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('requests/', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
  l_num  VARCHAR2(50);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_num := dct_cc_pkg.gen_request_number;
  INSERT INTO dct_cc_requests (
    request_number, cc_id, request_type, requested_limit,
    reason, replacement_reason, status, created_by, updated_by
  ) VALUES (
    l_num,
    APEX_JSON.get_number(p_path => 'ccId'),
    UPPER(APEX_JSON.get_varchar2(p_path => 'requestType')),
    APEX_JSON.get_number(p_path => 'requestedLimit'),
    APEX_JSON.get_varchar2(p_path => 'reason'),
    UPPER(APEX_JSON.get_varchar2(p_path => 'replacementReason')),
    'DRAFT', l_user, l_user
  ) RETURNING request_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('requestId', l_id);
  APEX_JSON.write('requestNumber', l_num);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('requests/[COLON]id');
    def_handler('requests/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM dct_cc_request_v WHERE request_id = [COLON]id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('requestId',         r.request_id);
    APEX_JSON.write('requestNumber',     r.request_number);
    APEX_JSON.write('ccId',              r.cc_id);
    APEX_JSON.write('ccNumber',          NVL(r.cc_number, ''));
    APEX_JSON.write('holderUserId',      r.holder_user_id);
    APEX_JSON.write('holderName',        NVL(r.holder_name, ''));
    APEX_JSON.write('employeeNum',       NVL(r.employee_num, ''));
    APEX_JSON.write('requestType',       r.request_type);
    APEX_JSON.write('requestedLimit',    r.requested_limit);
    APEX_JSON.write('reason',            NVL(r.reason, ''));
    APEX_JSON.write('replacementReason', NVL(r.replacement_reason, ''));
    APEX_JSON.write('status',            r.status);
    APEX_JSON.write('approvalInstanceId',r.approval_instance_id);
    APEX_JSON.write('submittedAt',       TO_CHAR(r.submitted_at, 'YYYY-MM-DD HH24:MI'));
    APEX_JSON.write('createdBy',         r.created_by);
    APEX_JSON.write('createdAt',         TO_CHAR(FROM_TZ(CAST(r.created_at AS TIMESTAMP), 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.write('updatedBy',         r.updated_by);
    APEX_JSON.write('updatedAt',         TO_CHAR(FROM_TZ(CAST(r.updated_at AS TIMESTAMP), 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('requests/[COLON]id', 'PUT', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT status INTO l_status FROM dct_cc_requests WHERE request_id = [COLON]id;
  IF l_status NOT IN ('DRAFT','RETURNED') THEN
    dct_rest.err(400,'Request can only be edited in DRAFT or RETURNED status'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_cc_requests SET
    cc_id              = CASE WHEN APEX_JSON.does_exist(p_path => 'ccId')
                              THEN APEX_JSON.get_number(p_path => 'ccId') ELSE cc_id END,
    request_type       = NVL(UPPER(APEX_JSON.get_varchar2(p_path => 'requestType')), request_type),
    requested_limit    = CASE WHEN APEX_JSON.does_exist(p_path => 'requestedLimit')
                              THEN APEX_JSON.get_number(p_path => 'requestedLimit') ELSE requested_limit END,
    reason             = CASE WHEN APEX_JSON.does_exist(p_path => 'reason')
                              THEN APEX_JSON.get_varchar2(p_path => 'reason') ELSE reason END,
    replacement_reason = CASE WHEN APEX_JSON.does_exist(p_path => 'replacementReason')
                              THEN UPPER(APEX_JSON.get_varchar2(p_path => 'replacementReason')) ELSE replacement_reason END,
    updated_by         = l_user, updated_at = SYSDATE
  WHERE request_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('requests/[COLON]id/submit');
    def_handler('requests/[COLON]id/submit', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_cc_pkg.submit_request([COLON]id, dct_auth.get_user_id(l_user));
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('status', 'SUBMITTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('requests/[COLON]id/withdraw');
    def_handler('requests/[COLON]id/withdraw', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_cc_pkg.withdraw_request([COLON]id, dct_auth.get_user_id(l_user));
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('status', 'WITHDRAWN');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- DOC REQUIREMENTS (unified, source_module CC, context = request type)
    -- =========================================================================
    def_template('doc-requirements');
    def_handler('doc-requirements', 'GET', q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_context VARCHAR2(30)  := UPPER([COLON]context);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT dr.doc_req_id, dr.context_code, dr.doc_type_id,
           dt.doc_type_name_en, dr.is_mandatory, dr.display_seq
    FROM   dct_doc_requirements dr
    JOIN   dct_document_types   dt ON dt.doc_type_id = dr.doc_type_id
    WHERE  dr.source_module = 'CC'
      AND  dr.is_active = 'Y'
      AND (l_context IS NULL OR dr.context_code = l_context)
    ORDER BY dr.context_code, dr.display_seq
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('docReqId',    r.doc_req_id);
    APEX_JSON.write('context',     r.context_code);
    APEX_JSON.write('docTypeId',   r.doc_type_id);
    APEX_JSON.write('docTypeName', r.doc_type_name_en);
    APEX_JSON.write('isMandatory', r.is_mandatory);
    APEX_JSON.write('displaySeq',  r.display_seq);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- DOCUMENTS (unified dct_documents, source_module CC)
    -- =========================================================================
    def_template('documents/');
    def_handler('documents/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_src  VARCHAR2(30)  := UPPER([COLON]sourceType);
  l_sid  NUMBER        := TO_NUMBER([COLON]sourceId DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT d.doc_id, d.source_type, d.source_id, d.doc_req_id, d.doc_type_id,
           dt.doc_type_name_en, d.file_name, d.mime_type,
           CASE WHEN d.file_blob IS NOT NULL THEN 'Y' ELSE 'N' END AS has_file,
           d.created_at
    FROM   dct_documents d
    LEFT JOIN dct_document_types dt ON dt.doc_type_id = d.doc_type_id
    WHERE  d.source_module = 'CC'
      AND  d.is_active = 'Y' AND d.status = 'ACTIVE'
      AND (l_src IS NULL OR d.source_type = l_src)
      AND (l_sid IS NULL OR d.source_id = l_sid)
    ORDER BY d.doc_id DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('documentId',  r.doc_id);
    APEX_JSON.write('sourceType',  r.source_type);
    APEX_JSON.write('sourceId',    r.source_id);
    APEX_JSON.write('docReqId',    r.doc_req_id);
    APEX_JSON.write('docTypeId',   r.doc_type_id);
    APEX_JSON.write('docTypeName', NVL(r.doc_type_name_en, '-'));
    APEX_JSON.write('fileName',    r.file_name);
    APEX_JSON.write('mimeType',    NVL(r.mime_type, ''));
    APEX_JSON.write('hasFile',     r.has_file);
    APEX_JSON.write('createdAt',   TO_CHAR(r.created_at, 'YYYY-MM-DD'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('documents/', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_id   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  INSERT INTO dct_documents (
    source_module, source_type, source_id, doc_req_id, doc_type_id,
    file_name, mime_type, status, is_required, is_active, created_by
  ) VALUES (
    'CC',
    UPPER(APEX_JSON.get_varchar2(p_path => 'sourceType')),
    APEX_JSON.get_number(p_path => 'sourceId'),
    APEX_JSON.get_number(p_path => 'docReqId'),
    APEX_JSON.get_number(p_path => 'docTypeId'),
    NVL(APEX_JSON.get_varchar2(p_path => 'fileName'), 'document'),
    APEX_JSON.get_varchar2(p_path => 'mimeType'),
    'ACTIVE',
    NVL(APEX_JSON.get_varchar2(p_path => 'isRequired'), 'N'),
    'Y', l_uid
  ) RETURNING doc_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('documentId', l_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('documents/[COLON]id/file');
    def_handler('documents/[COLON]id/file', 'PUT', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_uid   NUMBER;
  v_blob  BLOB;
  v_raw   RAW(32767);
  v_b64   VARCHAR2(32767) := [COLON]file_data_b64;
  v_len   NUMBER; v_pos NUMBER := 1; v_chunk NUMBER := 32764;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF v_b64 IS NULL THEN dct_rest.err(400,'file_data_b64 is required'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  DBMS_LOB.CREATETEMPORARY(v_blob, TRUE);
  v_len := LENGTH(v_b64);
  WHILE v_pos <= v_len LOOP
    v_raw := UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(SUBSTR(v_b64, v_pos, v_chunk)));
    DBMS_LOB.WRITEAPPEND(v_blob, UTL_RAW.LENGTH(v_raw), v_raw);
    v_pos := v_pos + v_chunk;
  END LOOP;
  UPDATE dct_documents SET
    file_blob = v_blob,
    mime_type = NVL([COLON]mime_type, mime_type),
    file_size_bytes = DBMS_LOB.GETLENGTH(v_blob),
    updated_by = l_uid, updated_at = SYSTIMESTAMP
  WHERE doc_id = [COLON]id AND source_module = 'CC';
  COMMIT;
  DBMS_LOB.FREETEMPORARY(v_blob);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');
    def_media('documents/[COLON]id/file',
      q'!SELECT mime_type, file_blob FROM dct_documents WHERE doc_id = [COLON]id AND source_module = 'CC'!');

    -- =========================================================================
    -- REPLENISHMENTS
    -- =========================================================================
    def_template('replenishments/');
    def_handler('replenishments/', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
  l_mine   VARCHAR2(1)   := UPPER([COLON]mine);
  l_status VARCHAR2(20)  := UPPER([COLON]status);
  l_ccid   NUMBER        := TO_NUMBER([COLON]ccId DEFAULT NULL ON CONVERSION ERROR);
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT COUNT(*) INTO l_total FROM dct_cc_replenishment_v r
  WHERE (l_mine IS NULL OR l_mine != 'Y'
         OR r.submitted_by_user_id = l_uid OR r.on_behalf_of_user_id = l_uid)
    AND (l_status IS NULL OR r.status = l_status)
    AND (l_ccid IS NULL OR r.cc_id = l_ccid);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT * FROM dct_cc_replenishment_v r
    WHERE (l_mine IS NULL OR l_mine != 'Y'
           OR r.submitted_by_user_id = l_uid OR r.on_behalf_of_user_id = l_uid)
      AND (l_status IS NULL OR r.status = l_status)
      AND (l_ccid IS NULL OR r.cc_id = l_ccid)
    ORDER BY r.replenishment_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('replenishmentId', r.replenishment_id);
    APEX_JSON.write('reimbNumber',     r.reimb_number);
    APEX_JSON.write('ccId',            r.cc_id);
    APEX_JSON.write('ccNumber',        r.cc_number);
    APEX_JSON.write('periodMonth',     r.period_month);
    APEX_JSON.write('periodYear',      r.period_year);
    APEX_JSON.write('periodLabel',     r.period_label);
    APEX_JSON.write('totalAmount',     r.total_amount);
    APEX_JSON.write('lineCount',       r.line_count);
    APEX_JSON.write('status',          r.status);
    APEX_JSON.write('submittedByName', r.submitted_by_name);
    APEX_JSON.write('onBehalfOfName',  r.on_behalf_of_name);
    APEX_JSON.write('submittedAt',     TO_CHAR(r.submitted_at, 'YYYY-MM-DD'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('replenishments/', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
  l_ccid   NUMBER;
  l_month  NUMBER;
  l_year   NUMBER;
  l_holder NUMBER;
  l_dup    NUMBER;
  l_id     NUMBER;
  l_num    VARCHAR2(50);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_ccid  := APEX_JSON.get_number(p_path => 'ccId');
  l_month := APEX_JSON.get_number(p_path => 'periodMonth');
  l_year  := APEX_JSON.get_number(p_path => 'periodYear');
  SELECT holder_user_id INTO l_holder FROM dct_credit_cards WHERE cc_id = l_ccid;
  SELECT COUNT(*) INTO l_dup FROM dct_cc_replenishments
  WHERE cc_id = l_ccid AND period_month = l_month AND period_year = l_year;
  IF l_dup > 0 THEN
    dct_rest.err(400,'A replenishment for this card and period already exists'); RETURN;
  END IF;
  l_num := dct_cc_pkg.gen_reimb_number(l_year, l_month);
  INSERT INTO dct_cc_replenishments (
    reimb_number, cc_id, period_month, period_year,
    submitted_by_user_id, on_behalf_of_user_id,
    coding_type, cc_id_gl, project_number, task_number, expenditure_type,
    status, created_by, updated_by
  ) VALUES (
    l_num, l_ccid, l_month, l_year,
    l_uid, l_holder,
    UPPER(APEX_JSON.get_varchar2(p_path => 'codingType')),
    APEX_JSON.get_number(p_path   => 'ccIdGl'),
    APEX_JSON.get_varchar2(p_path => 'projectNumber'),
    APEX_JSON.get_varchar2(p_path => 'taskNumber'),
    APEX_JSON.get_varchar2(p_path => 'expenditureType'),
    'DRAFT', l_user, l_user
  ) RETURNING replenishment_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('replenishmentId', l_id);
  APEX_JSON.write('reimbNumber', l_num);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('replenishments/[COLON]id');
    def_handler('replenishments/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM dct_cc_replenishment_v WHERE replenishment_id = [COLON]id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('replenishmentId', r.replenishment_id);
    APEX_JSON.write('reimbNumber',     r.reimb_number);
    APEX_JSON.write('ccId',            r.cc_id);
    APEX_JSON.write('ccNumber',        r.cc_number);
    APEX_JSON.write('periodMonth',     r.period_month);
    APEX_JSON.write('periodYear',      r.period_year);
    APEX_JSON.write('periodLabel',     r.period_label);
    APEX_JSON.write('totalAmount',     r.total_amount);
    APEX_JSON.write('submittedByUserId', r.submitted_by_user_id);
    APEX_JSON.write('submittedByName', r.submitted_by_name);
    APEX_JSON.write('onBehalfOfUserId', r.on_behalf_of_user_id);
    APEX_JSON.write('onBehalfOfName',  r.on_behalf_of_name);
    APEX_JSON.write('codingType',      NVL(r.coding_type, ''));
    APEX_JSON.write('ccIdGl',          r.cc_id_gl);
    APEX_JSON.write('projectNumber',   NVL(r.project_number, ''));
    APEX_JSON.write('taskNumber',      NVL(r.task_number, ''));
    APEX_JSON.write('expenditureType', NVL(r.expenditure_type, ''));
    APEX_JSON.write('status',          r.status);
    APEX_JSON.write('approvalInstanceId', r.approval_instance_id);
    APEX_JSON.write('submittedAt',     TO_CHAR(r.submitted_at, 'YYYY-MM-DD HH24:MI'));
    APEX_JSON.write('createdBy',       r.created_by);
    APEX_JSON.write('createdAt',       TO_CHAR(FROM_TZ(CAST(r.created_at AS TIMESTAMP), 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.write('updatedBy',       r.updated_by);
    APEX_JSON.write('updatedAt',       TO_CHAR(FROM_TZ(CAST(r.updated_at AS TIMESTAMP), 'UTC') AT TIME ZONE 'Asia/Dubai','DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.open_array('lines');
    FOR ln IN (
      SELECT * FROM dct_budget_coding_lines
      WHERE source_module = 'CC' AND source_type = 'CC_REPL'
        AND source_id = [COLON]id
      ORDER BY line_num
    ) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('lineId',          ln.line_id);
      APEX_JSON.write('lineNum',         ln.line_num);
      APEX_JSON.write('expenseDate',     TO_CHAR(ln.expense_date, 'YYYY-MM-DD'));
      APEX_JSON.write('merchantName',    NVL(ln.merchant_name, ''));
      APEX_JSON.write('amount',          ln.amount);
      APEX_JSON.write('description',     NVL(ln.description, ''));
      APEX_JSON.write('codingType',      ln.coding_type);
      APEX_JSON.write('ccIdGl',          ln.cc_id);
      APEX_JSON.write('projectNumber',   NVL(ln.project_number, ''));
      APEX_JSON.write('taskNumber',      NVL(ln.task_number, ''));
      APEX_JSON.write('expenditureType', NVL(ln.expenditure_type, ''));
      APEX_JSON.write('receiptAttached', NVL(ln.receipt_attached, 'N'));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('replenishments/[COLON]id', 'PUT', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT status INTO l_status FROM dct_cc_replenishments WHERE replenishment_id = [COLON]id;
  IF l_status NOT IN ('DRAFT','RETURNED') THEN
    dct_rest.err(400,'Replenishment can only be edited in DRAFT or RETURNED status'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_cc_replenishments SET
    coding_type      = CASE WHEN APEX_JSON.does_exist(p_path => 'codingType')
                            THEN UPPER(APEX_JSON.get_varchar2(p_path => 'codingType')) ELSE coding_type END,
    cc_id_gl         = CASE WHEN APEX_JSON.does_exist(p_path => 'ccIdGl')
                            THEN APEX_JSON.get_number(p_path => 'ccIdGl') ELSE cc_id_gl END,
    project_number   = CASE WHEN APEX_JSON.does_exist(p_path => 'projectNumber')
                            THEN APEX_JSON.get_varchar2(p_path => 'projectNumber') ELSE project_number END,
    task_number      = CASE WHEN APEX_JSON.does_exist(p_path => 'taskNumber')
                            THEN APEX_JSON.get_varchar2(p_path => 'taskNumber') ELSE task_number END,
    expenditure_type = CASE WHEN APEX_JSON.does_exist(p_path => 'expenditureType')
                            THEN APEX_JSON.get_varchar2(p_path => 'expenditureType') ELSE expenditure_type END,
    updated_by       = l_user, updated_at = SYSDATE
  WHERE replenishment_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('replenishments/[COLON]id/lines');
    def_handler('replenishments/[COLON]id/lines', 'PUT', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
  l_status VARCHAR2(20);
  l_count  NUMBER;
  l_total  NUMBER;
  l_path   VARCHAR2(100);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT status INTO l_status FROM dct_cc_replenishments WHERE replenishment_id = [COLON]id;
  IF l_status NOT IN ('DRAFT','RETURNED') THEN
    dct_rest.err(400,'Lines can only be edited in DRAFT or RETURNED status'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  DELETE FROM dct_budget_coding_lines
  WHERE source_module = 'CC' AND source_type = 'CC_REPL' AND source_id = [COLON]id;
  l_count := NVL(APEX_JSON.get_count(p_path => 'lines'), 0);
  FOR i IN 1 .. l_count LOOP
    l_path := 'lines[' || i || ']';
    INSERT INTO dct_budget_coding_lines (
      source_module, source_type, source_id, line_num, coding_type,
      cc_id, project_number, task_number, expenditure_type,
      amount, description, expense_date, merchant_name, receipt_attached,
      created_by
    ) VALUES (
      'CC', 'CC_REPL', [COLON]id, i,
      UPPER(APEX_JSON.get_varchar2(p_path => l_path || '.codingType')),
      APEX_JSON.get_number(p_path   => l_path || '.ccIdGl'),
      APEX_JSON.get_varchar2(p_path => l_path || '.projectNumber'),
      APEX_JSON.get_varchar2(p_path => l_path || '.taskNumber'),
      APEX_JSON.get_varchar2(p_path => l_path || '.expenditureType'),
      APEX_JSON.get_number(p_path   => l_path || '.amount'),
      APEX_JSON.get_varchar2(p_path => l_path || '.description'),
      TO_DATE(APEX_JSON.get_varchar2(p_path => l_path || '.expenseDate'), 'YYYY-MM-DD'),
      APEX_JSON.get_varchar2(p_path => l_path || '.merchantName'),
      NVL(APEX_JSON.get_varchar2(p_path => l_path || '.receiptAttached'), 'N'),
      l_uid
    );
  END LOOP;
  dct_cc_pkg.recalc_replenishment_total([COLON]id);
  SELECT total_amount INTO l_total FROM dct_cc_replenishments WHERE replenishment_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('lineCount', l_count);
  APEX_JSON.write('totalAmount', l_total);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('replenishments/[COLON]id/submit');
    def_handler('replenishments/[COLON]id/submit', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_cc_pkg.submit_replenishment([COLON]id, dct_auth.get_user_id(l_user));
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('status', 'SUBMITTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- PROXIES
    -- =========================================================================
    def_template('proxies/');
    def_handler('proxies/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_ccid NUMBER := TO_NUMBER([COLON]ccId DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT p.proxy_id, p.cc_id, cc.cc_number,
           own.display_name AS owner_name,
           p.proxy_user_id, prx.display_name AS proxy_name,
           p.start_date, p.end_date, p.is_active
    FROM   dct_cc_proxies p
    JOIN   dct_credit_cards cc ON cc.cc_id = p.cc_id
    JOIN   dct_users own ON own.user_id = cc.holder_user_id
    JOIN   dct_users prx ON prx.user_id = p.proxy_user_id
    WHERE (l_ccid IS NULL OR p.cc_id = l_ccid)
    ORDER BY p.proxy_id DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('proxyId',     r.proxy_id);
    APEX_JSON.write('ccId',        r.cc_id);
    APEX_JSON.write('ccNumber',    r.cc_number);
    APEX_JSON.write('ownerName',   r.owner_name);
    APEX_JSON.write('proxyUserId', r.proxy_user_id);
    APEX_JSON.write('proxyName',   r.proxy_name);
    APEX_JSON.write('startDate',   TO_CHAR(r.start_date, 'YYYY-MM-DD'));
    APEX_JSON.write('endDate',     TO_CHAR(r.end_date, 'YYYY-MM-DD'));
    APEX_JSON.write('isActive',    r.is_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('proxies/', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_id   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'CC_ADMIN') AND NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only CC Admin can manage proxies'); RETURN;
  END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  INSERT INTO dct_cc_proxies (
    cc_id, proxy_user_id, is_active, start_date, end_date,
    granted_by_user_id, created_by, updated_by
  ) VALUES (
    APEX_JSON.get_number(p_path => 'ccId'),
    APEX_JSON.get_number(p_path => 'proxyUserId'),
    'Y',
    NVL(TO_DATE(APEX_JSON.get_varchar2(p_path => 'startDate'), 'YYYY-MM-DD'), TRUNC(SYSDATE)),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'endDate'), 'YYYY-MM-DD'),
    l_uid, l_user, l_user
  ) RETURNING proxy_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('proxyId', l_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('proxies/[COLON]id');
    def_handler('proxies/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'CC_ADMIN') AND NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only CC Admin can manage proxies'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_cc_proxies SET
    is_active = CASE WHEN APEX_JSON.does_exist(p_path => 'isActive')
                     THEN UPPER(APEX_JSON.get_varchar2(p_path => 'isActive')) ELSE is_active END,
    end_date  = CASE WHEN APEX_JSON.does_exist(p_path => 'endDate')
                     THEN TO_DATE(APEX_JSON.get_varchar2(p_path => 'endDate'), 'YYYY-MM-DD') ELSE end_date END,
    updated_by = l_user, updated_at = SYSDATE
  WHERE proxy_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- APPROVALS (CC instances; delegation-aware, same pattern as the FL module)
    -- =========================================================================
    def_template('approvals/pending');
    def_handler('approvals/pending', 'GET', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_uid   NUMBER;
  l_roles VARCHAR2(4000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid   := dct_auth.get_user_id(l_user);
  l_roles := ',' || dct_auth.get_user_roles(l_user) || ',';
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT ai.instance_id, ai.source_module, ai.source_record_ref,
           ai.submitted_at, t.template_name, ast.step_name,
           rol.role_code AS required_role,
           sub.display_name AS submitted_by_name,
           (SELECT COUNT(*) FROM dct_approval_steps s2 WHERE s2.template_id = ai.template_id) AS total_steps,
           (SELECT COUNT(*) FROM dct_approval_steps s3 WHERE s3.template_id = ai.template_id
             AND s3.step_seq <= ai.current_step_seq) AS current_step,
           NVL(CASE ai.source_module
             WHEN 'CC_REQUEST'       THEN (SELECT requested_limit FROM dct_cc_requests       WHERE request_id       = ai.source_record_id)
             WHEN 'CC_REPLENISHMENT' THEN (SELECT total_amount    FROM dct_cc_replenishments WHERE replenishment_id = ai.source_record_id)
           END, 0) AS amount,
           CASE WHEN INSTR(l_roles, ',' || rol.role_code || ',') > 0
                  OR INSTR(l_roles, ',SYS_ADMIN,') > 0
                THEN NULL
                ELSE (SELECT MAX(du.display_name)
                      FROM dct_delegations dg
                      JOIN dct_user_roles ur2 ON ur2.user_id = dg.delegator_id
                                             AND ur2.role_id = rol.role_id AND ur2.is_active = 'Y'
                      JOIN dct_users du ON du.user_id = dg.delegator_id
                      WHERE dg.delegate_id = l_uid AND dg.status = 'ACTIVE'
                        AND TRUNC(SYSDATE) BETWEEN dg.start_date AND dg.end_date
                        AND (dg.scope = 'ALL_ROLES'
                             OR (dg.scope = 'SPECIFIC_ROLE' AND dg.role_id = rol.role_id)
                             OR (dg.scope = 'MODULE' AND dg.module_id = t.module_id)))
           END AS acting_for
    FROM   dct_approval_instances ai
    JOIN   dct_approval_templates t   ON t.template_id   = ai.template_id
    JOIN   dct_approval_steps     ast ON ast.template_id = ai.template_id
                                     AND ast.step_seq    = ai.current_step_seq
    JOIN   dct_roles              rol ON rol.role_id     = ast.required_role_id
    JOIN   dct_users              sub ON sub.user_id     = ai.submitted_by
    WHERE  ai.overall_status = 'PENDING'
      AND  ai.source_module IN ('CC_REQUEST','CC_REPLENISHMENT')
      AND (INSTR(l_roles, ',' || rol.role_code || ',') > 0
           OR INSTR(l_roles, ',SYS_ADMIN,') > 0
           OR EXISTS (
                SELECT 1 FROM dct_delegations dg
                JOIN dct_user_roles ur2 ON ur2.user_id = dg.delegator_id
                                       AND ur2.role_id = rol.role_id AND ur2.is_active = 'Y'
                WHERE dg.delegate_id = l_uid AND dg.status = 'ACTIVE'
                  AND TRUNC(SYSDATE) BETWEEN dg.start_date AND dg.end_date
                  AND (dg.scope = 'ALL_ROLES'
                       OR (dg.scope = 'SPECIFIC_ROLE' AND dg.role_id = rol.role_id)
                       OR (dg.scope = 'MODULE' AND dg.module_id = t.module_id))))
    ORDER BY ai.submitted_at
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('instanceId',      r.instance_id);
    APEX_JSON.write('requestRef',      NVL(r.source_record_ref, '-'));
    APEX_JSON.write('module',          r.source_module);
    APEX_JSON.write('templateName',    NVL(r.template_name, '-'));
    APEX_JSON.write('requestedBy',     NVL(r.submitted_by_name, '-'));
    APEX_JSON.write('requestedAt',     TO_CHAR(r.submitted_at,'YYYY-MM-DD HH24:MI'));
    APEX_JSON.write('amount',          r.amount);
    APEX_JSON.write('currentStep',     NVL(r.current_step, 1));
    APEX_JSON.write('totalSteps',      NVL(r.total_steps, 1));
    APEX_JSON.write('currentStepName', NVL(r.step_name, '-'));
    APEX_JSON.write('actingFor',       r.acting_for);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('approvals/[COLON]id/action');
    def_handler('approvals/[COLON]id/action', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  dct_cc_pkg.act_on_approval(
    p_instance_id => [COLON]id,
    p_user_id     => dct_auth.get_user_id(l_user),
    p_action      => APEX_JSON.get_varchar2(p_path => 'action'),
    p_comments    => APEX_JSON.get_varchar2(p_path => 'comments'));
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- LOOKUPS (combined reference data for the CC UI)
    -- =========================================================================
    def_template('lookups');
    def_handler('lookups', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  PROCEDURE emit_cat(p_json IN VARCHAR2, p_cat IN VARCHAR2) IS
  BEGIN
    APEX_JSON.open_array(p_json);
    FOR r IN (SELECT lv.value_id, lv.value_code, lv.value_name_en
              FROM dct_lookup_values lv
              JOIN dct_lookup_categories lc ON lc.category_id = lv.category_id
              WHERE lc.category_code = p_cat AND lv.is_active = 'Y'
              ORDER BY lv.display_order, lv.value_name_en) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('valueId', r.value_id);
      APEX_JSON.write('code',    r.value_code);
      APEX_JSON.write('name',    r.value_name_en);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  emit_cat('cardStatuses',       'CC_CARD_STATUS');
  emit_cat('requestStatuses',    'CC_REQUEST_STATUS');
  emit_cat('replStatuses',       'CC_REPL_STATUS');
  emit_cat('requestTypes',       'CC_REQUEST_TYPE');
  emit_cat('replacementReasons', 'CC_REPLACEMENT_REASON');
  APEX_JSON.open_array('orgs');
  FOR r IN (SELECT org_id, org_name_en FROM dct_organizations
            WHERE is_active = 'Y' ORDER BY org_name_en) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('orgId', r.org_id);
    APEX_JSON.write('name',  r.org_name_en);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('users');
  FOR r IN (SELECT user_id, username, display_name FROM dct_users
            WHERE is_active = 'Y' ORDER BY display_name) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('userId',      r.user_id);
    APEX_JSON.write('username',    r.username);
    APEX_JSON.write('displayName', r.display_name);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('docTypes');
  FOR r IN (SELECT doc_type_id, doc_type_code, doc_type_name_en FROM dct_document_types
            ORDER BY doc_type_name_en) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('docTypeId', r.doc_type_id);
    APEX_JSON.write('code',      r.doc_type_code);
    APEX_JSON.write('name',      r.doc_type_name_en);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GL CODES (same raw-array shape as the PC and FL modules)
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
  FOR r IN (SELECT cc_id, cc_code, is_active FROM dct_gl_code_combinations ORDER BY cc_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('ccId',     r.cc_id);
    APEX_JSON.write('ccCode',   r.cc_code);
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- MODULE SETTINGS
    -- =========================================================================
    def_template('settings');
    def_handler('settings', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT ms.setting_id, ms.setting_key, ms.setting_value, ms.setting_label,
           ms.setting_description, ms.value_type, ms.allowed_values, ms.default_value
    FROM   dct_module_settings ms
    JOIN   dct_modules m ON m.module_id = ms.module_id
    WHERE  m.module_code = 'CREDIT_CARDS'
    ORDER BY ms.setting_key
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('settingId',   r.setting_id);
    APEX_JSON.write('key',         r.setting_key);
    APEX_JSON.write('value',       r.setting_value);
    APEX_JSON.write('label',       NVL(r.setting_label, r.setting_key));
    APEX_JSON.write('description', NVL(r.setting_description, ''));
    APEX_JSON.write('type',        NVL(r.value_type, 'TEXT'));
    APEX_JSON.write('allowed',     NVL(r.allowed_values, ''));
    APEX_JSON.write('defaultValue',NVL(r.default_value, ''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('settings/[COLON]id');
    def_handler('settings/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'CC_ADMIN') AND NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'Only CC Admin can change module settings'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_module_settings SET
    setting_value = APEX_JSON.get_varchar2(p_path => 'value'),
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
    -- NOTIFICATIONS (per-user; same shape as the PC and FL modules)
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
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT notification_id, title_en, body_en, notification_type, is_read, created_at
    FROM   dct_notifications
    WHERE  recipient_user_id = l_uid
      AND  (expires_at IS NULL OR expires_at > SYSTIMESTAMP)
    ORDER BY created_at DESC FETCH FIRST 50 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('notifId',   r.notification_id);
    APEX_JSON.write('title',     r.title_en);
    APEX_JSON.write('body',      r.body_en);
    APEX_JSON.write('type',      r.notification_type);
    APEX_JSON.write('isRead',    r.is_read);
    APEX_JSON.write('createdAt', TO_CHAR(r.created_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('notifications/[COLON]id/read');
    def_handler('notifications/[COLON]id/read', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  UPDATE dct_notifications SET is_read = 'Y' WHERE notification_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
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
  UPDATE dct_notifications SET is_read = 'Y'
  WHERE recipient_user_id = l_uid AND is_read = 'N';
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_cc_ords_tmp;
/

BEGIN
    setup_cc_ords_tmp;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE setup_cc_ords_tmp';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

PROMPT ============================================================
PROMPT  09_cc_ords.sql complete.
PROMPT  Base URL: /ords/admin/cc/
PROMPT  Endpoints: dashboard, cards (+register/limit-history), requests
PROMPT             (+submit/withdraw), doc-requirements, documents,
PROMPT             replenishments (+lines/submit), proxies, approvals,
PROMPT             lookups, gl-codes, settings, notifications
PROMPT ============================================================
