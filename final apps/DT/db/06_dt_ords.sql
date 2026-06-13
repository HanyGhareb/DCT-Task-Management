-- =============================================================================
-- Duty Travel Module (App 204) — ORDS REST API Definition
-- File    : 06_dt_ords.sql
-- Run as  : ADMIN schema (sql -name prod_mcp)
-- Base URL: /ords/admin/dt/
-- Prereqs : db/v2/11_dct_ords.sql already executed
--           (creates dct_rest, dct_auth, dct_sessions, dct_users, dct_notifications synonyms)
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

-- =============================================================================
-- 1. ADMIN synonyms — DT tables, views, sequences
-- =============================================================================
CREATE OR REPLACE SYNONYM dt_per_diem_rates       FOR prod.dt_per_diem_rates;
CREATE OR REPLACE SYNONYM dt_rate_master_v         FOR prod.dt_rate_master_v;
CREATE OR REPLACE SYNONYM dt_country_groups        FOR prod.dt_country_groups;
CREATE OR REPLACE SYNONYM dt_requests              FOR prod.dt_requests;
CREATE OR REPLACE SYNONYM dt_requests_v            FOR prod.dt_requests_v;
CREATE OR REPLACE SYNONYM dt_destinations          FOR prod.dt_destinations;
CREATE OR REPLACE SYNONYM dt_destinations_v        FOR prod.dt_destinations_v;
CREATE OR REPLACE SYNONYM dt_doc_requirements      FOR prod.dt_doc_requirements;
CREATE OR REPLACE SYNONYM dt_doc_requirements_v    FOR prod.dt_doc_requirements_v;
CREATE OR REPLACE SYNONYM dt_settlement            FOR prod.dt_settlement;
CREATE OR REPLACE SYNONYM dt_settlement_v          FOR prod.dt_settlement_v;
CREATE OR REPLACE SYNONYM dt_settlement_lines      FOR prod.dt_settlement_lines;
CREATE OR REPLACE SYNONYM dt_pending_approvals_v   FOR prod.dt_pending_approvals_v;
CREATE OR REPLACE SYNONYM seq_dt_request_number    FOR prod.seq_dt_request_number;
CREATE OR REPLACE SYNONYM seq_dt_settlement_number FOR prod.seq_dt_settlement_number;

-- Additional DCT objects not already covered by 11_dct_ords.sql
CREATE OR REPLACE SYNONYM dct_approval_instances   FOR prod.dct_approval_instances;
CREATE OR REPLACE SYNONYM dct_approval_actions     FOR prod.dct_approval_actions;
CREATE OR REPLACE SYNONYM dct_approval_steps       FOR prod.dct_approval_steps;
CREATE OR REPLACE SYNONYM dct_approval_templates   FOR prod.dct_approval_templates;
CREATE OR REPLACE SYNONYM dct_module_settings      FOR prod.dct_module_settings;
CREATE OR REPLACE SYNONYM dct_modules              FOR prod.dct_modules;
CREATE OR REPLACE SYNONYM dct_roles                FOR prod.dct_roles;

-- =============================================================================
-- 2. Define ORDS module + all templates + handlers
-- =============================================================================
CREATE OR REPLACE PROCEDURE setup_dt_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'dt.rest';

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
        p_base_path      => '/dt/',
        p_items_per_page => 100,
        p_status         => 'PUBLISHED',
        p_comments       => 'Duty Travel Module — REST API'
    );

    -- =========================================================================
    -- DASHBOARD
    -- =========================================================================
    def_template('dashboard/');
    def_handler('dashboard/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_a    NUMBER := 0;  l_d NUMBER := 0;
  l_n    NUMBER := 0;  l_t NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT
    COUNT(CASE WHEN status IN ('SUBMITTED','APPROVED','ADVANCE_PAID','TRAVELLED') THEN 1 END),
    COUNT(CASE WHEN status = 'DRAFT' THEN 1 END),
    COUNT(CASE WHEN status IN ('ADVANCE_PAID','TRAVELLED') THEN 1 END),
    NVL(SUM(CASE WHEN status = 'ADVANCE_PAID' THEN total_advance_aed ELSE 0 END), 0)
  INTO l_a, l_d, l_n, l_t
  FROM dt_requests WHERE employee_user_id = l_uid;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('activeRequests', l_a);
  APEX_JSON.write('draftRequests',  l_d);
  APEX_JSON.write('needSettlement', l_n);
  APEX_JSON.write('totalAdvance',   l_t);
  APEX_JSON.open_array('recentRequests');
  FOR r IN (
    SELECT request_id, request_number, purpose,
           TO_CHAR(departure_date,'YYYY-MM-DD') AS dep_dt,
           TO_CHAR(return_date,'YYYY-MM-DD')    AS ret_dt,
           total_advance_aed, status
    FROM   dt_requests
    WHERE  employee_user_id = l_uid
    ORDER  BY request_id DESC
    FETCH FIRST 5 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('reqId',        r.request_id);
    APEX_JSON.write('reqNumber',    r.request_number);
    APEX_JSON.write('travelPurpose',r.purpose);
    APEX_JSON.write('departureDate',r.dep_dt);
    APEX_JSON.write('returnDate',   r.ret_dt);
    APEX_JSON.write('advanceAmount',r.total_advance_aed);
    APEX_JSON.write('status',       r.status);
    APEX_JSON.write('statusLabel',  CASE r.status
      WHEN 'DRAFT'        THEN 'Draft'        WHEN 'SUBMITTED'    THEN 'Submitted'
      WHEN 'APPROVED'     THEN 'Approved'     WHEN 'ADVANCE_PAID' THEN 'Advance Paid'
      WHEN 'TRAVELLED'    THEN 'Travelled'    WHEN 'CLOSED'       THEN 'Closed'
      WHEN 'REJECTED'     THEN 'Rejected'     WHEN 'RETURNED'     THEN 'Returned'
      WHEN 'CANCELLED'    THEN 'Cancelled'    ELSE r.status END);
    APEX_JSON.write('statusClass', 'badge ' || CASE r.status
      WHEN 'ADVANCE_PAID' THEN 'badge--advance_paid'
      ELSE 'badge--' || LOWER(r.status) END);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  -- Phase 3 (additive): chart series for the dashboard
  -- monthlySpend: 12-month advances vs per-diem (all requests, AED)
  APEX_JSON.open_array('monthlySpend');
  FOR r IN (
    SELECT TO_CHAR(TRUNC(departure_date, 'MM'), 'YYYY-MM') AS mon,
           NVL(SUM(total_advance_aed), 0)  AS advances,
           NVL(SUM(total_per_diem_aed), 0) AS per_diem
    FROM   dt_requests
    WHERE  departure_date >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -11)
    AND    status NOT IN ('DRAFT', 'CANCELLED', 'REJECTED')
    GROUP  BY TRUNC(departure_date, 'MM')
    ORDER  BY 1
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('month',    r.mon);
    APEX_JSON.write('advances', r.advances);
    APEX_JSON.write('perDiem',  r.per_diem);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  -- statusFunnel: current request distribution by status
  APEX_JSON.open_array('statusFunnel');
  FOR r IN (
    SELECT status, COUNT(*) AS n
    FROM   dt_requests
    GROUP  BY status
    ORDER  BY CASE status
      WHEN 'DRAFT' THEN 1 WHEN 'SUBMITTED' THEN 2 WHEN 'APPROVED' THEN 3
      WHEN 'ADVANCE_PAID' THEN 4 WHEN 'TRAVELLED' THEN 5 WHEN 'CLOSED' THEN 6
      WHEN 'RETURNED' THEN 7 WHEN 'REJECTED' THEN 8 ELSE 9 END
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('status', r.status);
    APEX_JSON.write('count',  r.n);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- REQUESTS — list
    -- Query params: mine=Y (my requests), advancePending=Y (disbursement queue)
    -- =========================================================================
    def_template('requests/');
    def_handler('requests/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_mine VARCHAR2(1)   := [COLON]mine;
  l_adv  VARCHAR2(1)   := [COLON]advancePending;
  -- Phase 3 server-side pagination on the admin (all-requests) branch:
  -- ?limit=&offset=&search=&status= ; mine/advancePending stay unpaged (small sets)
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_search VARCHAR2(200) := [COLON]search;
  l_status VARCHAR2(30)  := UPPER([COLON]status);
  l_total  NUMBER;

  PROCEDURE write_req(
    p_id NUMBER, p_num VARCHAR2, p_uid NUMBER, p_purp VARCHAR2,
    p_dep VARCHAR2, p_ret VARCHAR2, p_days NUMBER,
    p_pdiem NUMBER, p_adv NUMBER, p_budget VARCHAR2,
    p_emp VARCHAR2, p_status VARCHAR2, p_disbyn VARCHAR2
  ) IS BEGIN
    APEX_JSON.open_object;
    APEX_JSON.write('reqId',           p_id);
    APEX_JSON.write('reqNumber',       p_num);
    APEX_JSON.write('userId',          p_uid);
    APEX_JSON.write('travelPurpose',   p_purp);
    APEX_JSON.write('departureDate',   p_dep);
    APEX_JSON.write('returnDate',      p_ret);
    APEX_JSON.write('estimatedDays',   p_days);
    APEX_JSON.write('estimatedPerDiem',p_pdiem);
    APEX_JSON.write('advanceAmount',   p_adv);
    APEX_JSON.write('advanceRequested',CASE WHEN p_adv > 0 THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('budgetType',      p_budget);
    APEX_JSON.write('employeeName',    p_emp);
    APEX_JSON.write('status',          p_status);
    APEX_JSON.write('financeDisbursedYn', p_disbyn);
    APEX_JSON.write('statusLabel', CASE p_status
      WHEN 'DRAFT'        THEN 'Draft'        WHEN 'SUBMITTED'    THEN 'Submitted'
      WHEN 'APPROVED'     THEN 'Approved'     WHEN 'ADVANCE_PAID' THEN 'Advance Paid'
      WHEN 'TRAVELLED'    THEN 'Travelled'    WHEN 'CLOSED'       THEN 'Closed'
      WHEN 'REJECTED'     THEN 'Rejected'     WHEN 'RETURNED'     THEN 'Returned'
      WHEN 'CANCELLED'    THEN 'Cancelled'    ELSE p_status END);
    APEX_JSON.write('statusClass', 'badge ' || CASE p_status
      WHEN 'ADVANCE_PAID' THEN 'badge--advance_paid'
      ELSE 'badge--' || LOWER(p_status) END);
    APEX_JSON.close_object;
  END write_req;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);

  -- total: meaningful for the admin branch; mirrors the branch row counts otherwise
  IF l_mine = 'Y' THEN
    SELECT COUNT(*) INTO l_total FROM dt_requests WHERE employee_user_id = l_uid;
  ELSIF l_adv = 'Y' THEN
    SELECT COUNT(*) INTO l_total FROM dt_requests
    WHERE status = 'APPROVED' AND total_advance_aed > 0 AND finance_disbursed_yn = 'N';
  ELSE
    SELECT COUNT(*) INTO l_total
    FROM dt_requests r JOIN dt_requests_v v ON v.request_id = r.request_id
    WHERE (l_status IS NULL OR r.status = l_status)
      AND (l_search IS NULL OR
           UPPER(r.request_number || ' ' || NVL(r.purpose,'') || ' ' || NVL(v.employee_name,''))
           LIKE '%' || UPPER(l_search) || '%');
  END IF;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total',  l_total);
  APEX_JSON.write('limit',  l_limit);
  APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');

  IF l_mine = 'Y' THEN
    FOR r IN (
      SELECT r.request_id, r.request_number, r.employee_user_id, r.purpose,
             TO_CHAR(r.departure_date,'YYYY-MM-DD') AS dep_dt,
             TO_CHAR(r.return_date,'YYYY-MM-DD')    AS ret_dt,
             r.total_days, r.total_per_diem_aed, r.total_advance_aed,
             r.budget_type, r.finance_disbursed_yn,
             v.employee_name, r.status
      FROM dt_requests r JOIN dt_requests_v v ON v.request_id = r.request_id
      WHERE r.employee_user_id = l_uid
      ORDER BY r.request_id DESC
    ) LOOP
      write_req(r.request_id, r.request_number, r.employee_user_id, r.purpose,
                r.dep_dt, r.ret_dt, r.total_days, r.total_per_diem_aed,
                r.total_advance_aed, r.budget_type, r.employee_name, r.status, r.finance_disbursed_yn);
    END LOOP;

  ELSIF l_adv = 'Y' THEN
    -- Disbursement queue: APPROVED, advance requested, not yet disbursed
    FOR r IN (
      SELECT r.request_id, r.request_number, r.employee_user_id, r.purpose,
             TO_CHAR(r.departure_date,'YYYY-MM-DD') AS dep_dt,
             TO_CHAR(r.return_date,'YYYY-MM-DD')    AS ret_dt,
             r.total_days, r.total_per_diem_aed, r.total_advance_aed,
             r.budget_type, r.finance_disbursed_yn,
             v.employee_name, r.status
      FROM dt_requests r JOIN dt_requests_v v ON v.request_id = r.request_id
      WHERE r.status = 'APPROVED'
        AND r.total_advance_aed > 0
        AND r.finance_disbursed_yn = 'N'
      ORDER BY r.departure_date
    ) LOOP
      write_req(r.request_id, r.request_number, r.employee_user_id, r.purpose,
                r.dep_dt, r.ret_dt, r.total_days, r.total_per_diem_aed,
                r.total_advance_aed, r.budget_type, r.employee_name, r.status, r.finance_disbursed_yn);
    END LOOP;

  ELSE
    -- All requests (admin / HR / finance view) — server-paged
    FOR r IN (
      SELECT r.request_id, r.request_number, r.employee_user_id, r.purpose,
             TO_CHAR(r.departure_date,'YYYY-MM-DD') AS dep_dt,
             TO_CHAR(r.return_date,'YYYY-MM-DD')    AS ret_dt,
             r.total_days, r.total_per_diem_aed, r.total_advance_aed,
             r.budget_type, r.finance_disbursed_yn,
             v.employee_name, r.status
      FROM dt_requests r JOIN dt_requests_v v ON v.request_id = r.request_id
      WHERE (l_status IS NULL OR r.status = l_status)
        AND (l_search IS NULL OR
             UPPER(r.request_number || ' ' || NVL(r.purpose,'') || ' ' || NVL(v.employee_name,''))
             LIKE '%' || UPPER(l_search) || '%')
      ORDER BY r.request_id DESC
      OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
    ) LOOP
      write_req(r.request_id, r.request_number, r.employee_user_id, r.purpose,
                r.dep_dt, r.ret_dt, r.total_days, r.total_per_diem_aed,
                r.total_advance_aed, r.budget_type, r.employee_name, r.status, r.finance_disbursed_yn);
    END LOOP;
  END IF;

  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('requests/', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
  l_req_id NUMBER;
  l_req_num VARCHAR2(50);
  l_year   VARCHAR2(4)  := TO_CHAR(SYSDATE,'YYYY');
  l_seq    VARCHAR2(10);
  l_prefix VARCHAR2(20) := 'DT';
  l_org_id NUMBER;
  l_new    CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);

  -- Get org from user profile (or from payload)
  SELECT org_id INTO l_org_id FROM dct_users WHERE user_id = l_uid;

  -- Generate request number: PREFIX-YYYY-NNNNN
  BEGIN
    SELECT setting_value INTO l_prefix
    FROM dct_module_settings ms JOIN dct_modules m ON m.module_id = ms.module_id
    WHERE m.module_code = 'DUTY_TRAVEL' AND ms.setting_key = 'REQUEST_NUMBER_PREFIX';
  EXCEPTION WHEN NO_DATA_FOUND THEN l_prefix := 'DT'; END;

  SELECT seq_dt_request_number.NEXTVAL INTO l_seq FROM DUAL;
  l_req_num := l_prefix || '-' || l_year || '-' || LPAD(l_seq, 5, '0');

  INSERT INTO dt_requests (
    request_number, employee_user_id, employee_grade_code, org_id,
    mission_type, trip_type, purpose, hosted_by,
    departure_date, return_date,
    total_per_diem_aed, total_advance_aed,
    ticket_amount_aed, accommodation_amount_aed,
    visa_fees_aed, local_transport_aed, other_allowances_aed,
    budget_type, cc_id_gl, project_number, task_number, expenditure_type,
    status, notes, created_by
  ) VALUES (
    l_req_num, l_uid,
    NVL(APEX_JSON.get_varchar2(p_path => 'gradeCode'), 'G1'),
    NVL(APEX_JSON.get_number(p_path => 'orgId'), l_org_id),
    NVL(APEX_JSON.get_varchar2(p_path => 'missionType'), 'BUSINESS_MISSION'),
    NVL(APEX_JSON.get_varchar2(p_path => 'tripType'), 'EXTERNAL'),
    APEX_JSON.get_varchar2(p_path => 'travelPurpose'),
    APEX_JSON.get_varchar2(p_path => 'hostedBy'),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'departureDate'), 'YYYY-MM-DD'),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'returnDate'), 'YYYY-MM-DD'),
    NVL(APEX_JSON.get_number(p_path => 'estimatedPerDiem'), 0),
    NVL(APEX_JSON.get_number(p_path => 'advanceAmount'), 0),
    NVL(APEX_JSON.get_number(p_path => 'ticketAmount'), 0),
    NVL(APEX_JSON.get_number(p_path => 'accommodationAmount'), 0),
    NVL(APEX_JSON.get_number(p_path => 'visaFees'), 0),
    NVL(APEX_JSON.get_number(p_path => 'localTransport'), 0),
    NVL(APEX_JSON.get_number(p_path => 'otherAllowances'), 0),
    NVL(APEX_JSON.get_varchar2(p_path => 'budgetType'), 'GL'),
    APEX_JSON.get_number(p_path => 'ccIdGl'),
    APEX_JSON.get_varchar2(p_path => 'projectNumber'),
    APEX_JSON.get_varchar2(p_path => 'taskNumber'),
    APEX_JSON.get_varchar2(p_path => 'expenditureType'),
    NVL(APEX_JSON.get_varchar2(p_path => 'status'), 'DRAFT'),
    APEX_JSON.get_varchar2(p_path => 'notes'),
    l_user
  ) RETURNING request_id INTO l_req_id;

  -- Insert destination legs
  FOR i IN 1 .. NVL(APEX_JSON.get_count(p_path => 'destinations'), 0) LOOP
    INSERT INTO dt_destinations (
      request_id, seq_num, country_code, city,
      arrival_date, departure_date,
      per_diem_daily_rate_aed, per_diem_total_aed
    ) VALUES (
      l_req_id,
      NVL(APEX_JSON.get_number(p_path => 'destinations[%d].seqNum', p0 => i), i),
      APEX_JSON.get_varchar2(p_path => 'destinations[%d].countryCode', p0 => i),
      NVL(APEX_JSON.get_varchar2(p_path => 'destinations[%d].city', p0 => i), ''),
      TO_DATE(APEX_JSON.get_varchar2(p_path => 'destinations[%d].fromDate', p0 => i), 'YYYY-MM-DD'),
      TO_DATE(APEX_JSON.get_varchar2(p_path => 'destinations[%d].toDate',   p0 => i), 'YYYY-MM-DD'),
      NVL(APEX_JSON.get_number(p_path => 'destinations[%d].dailyRateAed', p0 => i), 0),
      NVL(APEX_JSON.get_number(p_path => 'destinations[%d].amount', p0 => i), 0)
    );
  END LOOP;

  COMMIT;
  l_new := dct_audit_pkg.snap('DT_REQUESTS','request_id', TO_CHAR(l_req_id));
  dct_audit_pkg.log(l_user,'CREATE','DT_REQUESTS', TO_CHAR(l_req_id), 'DT',
                    p_object_ref=>l_req_num, p_new=>l_new);
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('reqId',     l_req_id);
  APEX_JSON.write('reqNumber', l_req_num);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- REQUESTS — single record
    -- =========================================================================
    def_template('requests/[COLON]id');
    def_handler('requests/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER        := [COLON]id;
  l_rec  dt_requests_v%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT * INTO l_rec FROM dt_requests_v WHERE request_id = l_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Request not found'); RETURN;
  END;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('reqId',            l_rec.request_id);
  APEX_JSON.write('reqNumber',        l_rec.request_number);
  APEX_JSON.write('userId',           l_rec.employee_user_id);
  APEX_JSON.write('employeeName',     l_rec.employee_name);
  APEX_JSON.write('gradeCode',        l_rec.employee_grade_code);
  APEX_JSON.write('gradeLabel',       l_rec.grade_label);
  APEX_JSON.write('orgId',            l_rec.org_id);
  APEX_JSON.write('orgName',          l_rec.org_name_en);
  APEX_JSON.write('missionType',      l_rec.mission_type);
  APEX_JSON.write('missionTypeLabel', l_rec.mission_type_label);
  APEX_JSON.write('tripType',         l_rec.trip_type);
  APEX_JSON.write('tripTypeLabel',    l_rec.trip_type_label);
  APEX_JSON.write('travelPurpose',    l_rec.purpose);
  APEX_JSON.write('hostedBy',         l_rec.hosted_by);
  APEX_JSON.write('departureDate',    TO_CHAR(l_rec.departure_date,'YYYY-MM-DD'));
  APEX_JSON.write('returnDate',       TO_CHAR(l_rec.return_date,'YYYY-MM-DD'));
  APEX_JSON.write('estimatedDays',    l_rec.total_days);
  APEX_JSON.write('estimatedPerDiem', l_rec.total_per_diem_aed);
  APEX_JSON.write('advanceAmount',    l_rec.total_advance_aed);
  APEX_JSON.write('advanceRequested', CASE WHEN l_rec.total_advance_aed > 0 THEN 'Y' ELSE 'N' END);
  APEX_JSON.write('ticketAmount',     l_rec.ticket_amount_aed);
  APEX_JSON.write('accommodationAmount', l_rec.accommodation_amount_aed);
  APEX_JSON.write('visaFees',         l_rec.visa_fees_aed);
  APEX_JSON.write('localTransport',   l_rec.local_transport_aed);
  APEX_JSON.write('otherAllowances',  l_rec.other_allowances_aed);
  APEX_JSON.write('budgetType',       l_rec.budget_type);
  APEX_JSON.write('ccIdGl',           l_rec.cc_id_gl);
  APEX_JSON.write('glCodeDisplay',    l_rec.gl_code_display);
  APEX_JSON.write('projectNumber',    l_rec.project_number);
  APEX_JSON.write('taskNumber',       l_rec.task_number);
  APEX_JSON.write('expenditureType',  l_rec.expenditure_type);
  APEX_JSON.write('status',           l_rec.status);
  APEX_JSON.write('financeDisbursedYn', l_rec.finance_disbursed_yn);
  APEX_JSON.write('disbursedDate',    TO_CHAR(l_rec.disbursed_date,'YYYY-MM-DD'));
  APEX_JSON.write('notes',            l_rec.notes);
  APEX_JSON.write('createdBy',        l_rec.created_by);
  APEX_JSON.write('createdAt',        TO_CHAR(l_rec.created_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
  APEX_JSON.write('statusLabel', CASE l_rec.status
    WHEN 'DRAFT'        THEN 'Draft'        WHEN 'SUBMITTED'    THEN 'Submitted'
    WHEN 'APPROVED'     THEN 'Approved'     WHEN 'ADVANCE_PAID' THEN 'Advance Paid'
    WHEN 'TRAVELLED'    THEN 'Travelled'    WHEN 'CLOSED'       THEN 'Closed'
    WHEN 'REJECTED'     THEN 'Rejected'     WHEN 'RETURNED'     THEN 'Returned'
    WHEN 'CANCELLED'    THEN 'Cancelled'    ELSE l_rec.status END);
  APEX_JSON.write('statusClass', 'badge ' || CASE l_rec.status
    WHEN 'ADVANCE_PAID' THEN 'badge--advance_paid'
    ELSE 'badge--' || LOWER(l_rec.status) END);
  -- Destinations array
  APEX_JSON.open_array('destinations');
  FOR d IN (
    SELECT destination_id, seq_num, country_code, country_name_en, city,
           TO_CHAR(arrival_date,'YYYY-MM-DD')   AS from_dt,
           TO_CHAR(departure_date,'YYYY-MM-DD') AS to_dt,
           duration_days, per_diem_daily_rate_aed, per_diem_total_aed, notes
    FROM dt_destinations_v
    WHERE request_id = l_id ORDER BY seq_num
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('destId',       d.destination_id);
    APEX_JSON.write('reqId',        l_id);
    APEX_JSON.write('seqNum',       d.seq_num);
    APEX_JSON.write('countryCode',  d.country_code);
    APEX_JSON.write('countryName',  d.country_name_en);
    APEX_JSON.write('city',         d.city);
    APEX_JSON.write('fromDate',     d.from_dt);
    APEX_JSON.write('toDate',       d.to_dt);
    APEX_JSON.write('days',         d.duration_days);
    APEX_JSON.write('dailyRateAed', d.per_diem_daily_rate_aed);
    APEX_JSON.write('amount',       d.per_diem_total_aed);
    APEX_JSON.write('notes',        d.notes);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('requests/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER        := [COLON]id;
  l_status VARCHAR2(25);
  l_old  CLOB;
  l_new  CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT status INTO l_status FROM dt_requests WHERE request_id = l_id;
  IF l_status NOT IN ('DRAFT','RETURNED') THEN
    dct_rest.err(400,'Only DRAFT or RETURNED requests can be edited'); RETURN;
  END IF;
  l_old := dct_audit_pkg.snap('DT_REQUESTS','request_id', TO_CHAR(l_id));
  dct_rest.parse_body([COLON]body);
  UPDATE dt_requests SET
    mission_type             = NVL(APEX_JSON.get_varchar2(p_path => 'missionType'),       mission_type),
    trip_type                = NVL(APEX_JSON.get_varchar2(p_path => 'tripType'),           trip_type),
    purpose                  = NVL(APEX_JSON.get_varchar2(p_path => 'travelPurpose'),      purpose),
    hosted_by                = APEX_JSON.get_varchar2(p_path => 'hostedBy'),
    departure_date           = NVL(TO_DATE(APEX_JSON.get_varchar2(p_path => 'departureDate'),'YYYY-MM-DD'), departure_date),
    return_date              = NVL(TO_DATE(APEX_JSON.get_varchar2(p_path => 'returnDate'),'YYYY-MM-DD'),    return_date),
    employee_grade_code      = NVL(APEX_JSON.get_varchar2(p_path => 'gradeCode'),          employee_grade_code),
    total_per_diem_aed       = NVL(APEX_JSON.get_number(p_path => 'estimatedPerDiem'),     total_per_diem_aed),
    total_advance_aed        = NVL(APEX_JSON.get_number(p_path => 'advanceAmount'),        total_advance_aed),
    ticket_amount_aed        = NVL(APEX_JSON.get_number(p_path => 'ticketAmount'),         ticket_amount_aed),
    accommodation_amount_aed = NVL(APEX_JSON.get_number(p_path => 'accommodationAmount'),  accommodation_amount_aed),
    visa_fees_aed            = NVL(APEX_JSON.get_number(p_path => 'visaFees'),             visa_fees_aed),
    local_transport_aed      = NVL(APEX_JSON.get_number(p_path => 'localTransport'),       local_transport_aed),
    other_allowances_aed     = NVL(APEX_JSON.get_number(p_path => 'otherAllowances'),      other_allowances_aed),
    budget_type              = NVL(APEX_JSON.get_varchar2(p_path => 'budgetType'),         budget_type),
    cc_id_gl                 = APEX_JSON.get_number(p_path => 'ccIdGl'),
    project_number           = APEX_JSON.get_varchar2(p_path => 'projectNumber'),
    notes                    = APEX_JSON.get_varchar2(p_path => 'notes'),
    updated_by               = l_user,
    updated_at               = SYSTIMESTAMP
  WHERE request_id = l_id;
  -- Replace destination legs if provided
  IF APEX_JSON.get_count(p_path => 'destinations') >= 0 THEN
    DELETE FROM dt_destinations WHERE request_id = l_id;
    FOR i IN 1 .. NVL(APEX_JSON.get_count(p_path => 'destinations'), 0) LOOP
      INSERT INTO dt_destinations (
        request_id, seq_num, country_code, city,
        arrival_date, departure_date, per_diem_daily_rate_aed, per_diem_total_aed
      ) VALUES (
        l_id,
        NVL(APEX_JSON.get_number(p_path => 'destinations[%d].seqNum', p0 => i), i),
        APEX_JSON.get_varchar2(p_path => 'destinations[%d].countryCode', p0 => i),
        NVL(APEX_JSON.get_varchar2(p_path => 'destinations[%d].city', p0 => i), ''),
        TO_DATE(APEX_JSON.get_varchar2(p_path => 'destinations[%d].fromDate', p0 => i), 'YYYY-MM-DD'),
        TO_DATE(APEX_JSON.get_varchar2(p_path => 'destinations[%d].toDate',   p0 => i), 'YYYY-MM-DD'),
        NVL(APEX_JSON.get_number(p_path => 'destinations[%d].dailyRateAed', p0 => i), 0),
        NVL(APEX_JSON.get_number(p_path => 'destinations[%d].amount', p0 => i), 0)
      );
    END LOOP;
  END IF;
  COMMIT;
  l_new := dct_audit_pkg.snap('DT_REQUESTS','request_id', TO_CHAR(l_id));
  dct_audit_pkg.log(l_user,'UPDATE','DT_REQUESTS', TO_CHAR(l_id), 'DT',
                    p_old=>l_old, p_new=>l_new);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- REQUEST ACTIONS
    -- =========================================================================
    def_template('requests/[COLON]id/submit');
    def_handler('requests/[COLON]id/submit', 'POST', q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_id      NUMBER        := [COLON]id;
  l_uid     NUMBER;
  l_status  VARCHAR2(25);
  l_ref     VARCHAR2(50);
  l_tmpl_id NUMBER;
  l_inst_id NUMBER;
  l_first   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT status, request_number INTO l_status, l_ref FROM dt_requests WHERE request_id = l_id;
  IF l_status NOT IN ('DRAFT','RETURNED') THEN
    dct_rest.err(400,'Request cannot be submitted in status: ' || l_status); RETURN;
  END IF;
  -- Find active approval template for DT TRAVEL_REQUEST
  BEGIN
    SELECT at2.template_id INTO l_tmpl_id
    FROM   dct_approval_templates at2
    JOIN   dct_modules m ON m.module_id = at2.module_id
    WHERE  m.module_code   = 'DUTY_TRAVEL'
      AND  at2.request_type = 'TRAVEL_REQUEST'
      AND  at2.is_active    = 'Y'
    FETCH FIRST 1 ROW ONLY;
  EXCEPTION WHEN NO_DATA_FOUND THEN l_tmpl_id := NULL; END;
  -- Get first step seq
  IF l_tmpl_id IS NOT NULL THEN
    SELECT MIN(step_seq) INTO l_first FROM dct_approval_steps WHERE template_id = l_tmpl_id;
    INSERT INTO dct_approval_instances (
      template_id, source_module, source_record_id, source_record_ref,
      current_step_seq, overall_status, submitted_by, created_by
    ) VALUES (
      l_tmpl_id, 'TRAVEL_REQUEST', l_id, l_ref,
      l_first, 'PENDING', l_uid, l_user
    ) RETURNING instance_id INTO l_inst_id;
  END IF;
  UPDATE dt_requests SET
    status               = 'SUBMITTED',
    approval_instance_id = l_inst_id,
    updated_by           = l_user,
    updated_at           = SYSTIMESTAMP
  WHERE request_id = l_id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok',         TRUE);
  APEX_JSON.write('status',     'SUBMITTED');
  APEX_JSON.write('instanceId', l_inst_id);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('requests/[COLON]id/cancel');
    def_handler('requests/[COLON]id/cancel', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_id     NUMBER        := [COLON]id;
  l_status VARCHAR2(25);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT status INTO l_status FROM dt_requests WHERE request_id = l_id;
  IF l_status NOT IN ('DRAFT','SUBMITTED','RETURNED') THEN
    dct_rest.err(400,'Cannot cancel request in status: ' || l_status); RETURN;
  END IF;
  UPDATE dt_requests
  SET status = 'CANCELLED', updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE request_id = l_id;
  -- Cancel any pending approval instance
  UPDATE dct_approval_instances
  SET overall_status = 'CANCELLED', completed_at = SYSTIMESTAMP, updated_by = l_user
  WHERE source_module = 'TRAVEL_REQUEST' AND source_record_id = l_id
    AND overall_status = 'PENDING';
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('requests/[COLON]id/pay-advance');
    def_handler('requests/[COLON]id/pay-advance', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_id     NUMBER        := [COLON]id;
  l_uid    NUMBER;
  l_status VARCHAR2(25);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT status INTO l_status FROM dt_requests WHERE request_id = l_id;
  IF l_status != 'APPROVED' THEN
    dct_rest.err(400,'Only APPROVED requests can have advance paid'); RETURN;
  END IF;
  UPDATE dt_requests SET
    status                 = 'ADVANCE_PAID',
    finance_disbursed_yn   = 'Y',
    disbursed_date         = TRUNC(SYSDATE),
    disbursed_by_user_id   = l_uid,
    updated_by             = l_user,
    updated_at             = SYSTIMESTAMP
  WHERE request_id = l_id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('requests/[COLON]id/mark-travelled');
    def_handler('requests/[COLON]id/mark-travelled', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_id     NUMBER        := [COLON]id;
  l_status VARCHAR2(25);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT status INTO l_status FROM dt_requests WHERE request_id = l_id;
  IF l_status != 'ADVANCE_PAID' THEN
    dct_rest.err(400,'Only ADVANCE_PAID requests can be marked as travelled'); RETURN;
  END IF;
  UPDATE dt_requests SET
    status = 'TRAVELLED', updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE request_id = l_id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- REQUEST DESTINATIONS
    -- =========================================================================
    def_template('requests/[COLON]id/destinations');
    def_handler('requests/[COLON]id/destinations', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER        := [COLON]id;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR d IN (
    SELECT destination_id, seq_num, country_code, country_name_en, city,
           TO_CHAR(arrival_date,'YYYY-MM-DD')   AS from_dt,
           TO_CHAR(departure_date,'YYYY-MM-DD') AS to_dt,
           duration_days, per_diem_daily_rate_aed, per_diem_total_aed
    FROM dt_destinations_v
    WHERE request_id = l_id ORDER BY seq_num
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('destId',       d.destination_id);
    APEX_JSON.write('reqId',        l_id);
    APEX_JSON.write('seqNum',       d.seq_num);
    APEX_JSON.write('countryCode',  d.country_code);
    APEX_JSON.write('countryName',  d.country_name_en);
    APEX_JSON.write('city',         d.city);
    APEX_JSON.write('fromDate',     d.from_dt);
    APEX_JSON.write('toDate',       d.to_dt);
    APEX_JSON.write('days',         d.duration_days);
    APEX_JSON.write('dailyRateAed', d.per_diem_daily_rate_aed);
    APEX_JSON.write('amount',       d.per_diem_total_aed);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- SETTLEMENTS — list
    -- Query params: mine=Y, reqId=N, status=APPROVED (closure queue)
    -- =========================================================================
    def_template('settlements/');
    def_handler('settlements/', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid    NUMBER;
  l_mine   VARCHAR2(1)   := [COLON]mine;
  l_req_id NUMBER        := [COLON]reqId;
  l_status VARCHAR2(25)  := [COLON]status;

  PROCEDURE write_settle(
    p_sid NUMBER, p_snum VARCHAR2, p_rid NUMBER, p_rnum VARCHAR2,
    p_ret_dt VARCHAR2, p_days NUMBER,
    p_total NUMBER, p_adv NUMBER, p_status VARCHAR2,
    p_emp VARCHAR2
  ) IS
    l_diff NUMBER := p_total - p_adv;
  BEGIN
    APEX_JSON.open_object;
    APEX_JSON.write('settleId',       p_sid);
    APEX_JSON.write('settleNumber',   p_snum);
    APEX_JSON.write('reqId',          p_rid);
    APEX_JSON.write('reqNumber',      p_rnum);
    APEX_JSON.write('actualReturn',   p_ret_dt);
    APEX_JSON.write('actualDays',     p_days);
    APEX_JSON.write('totalSettlement',p_total);
    APEX_JSON.write('advanceAmount',  p_adv);
    APEX_JSON.write('netPayable',     GREATEST(0, l_diff));
    APEX_JSON.write('netRefund',      GREATEST(0, -l_diff));
    APEX_JSON.write('employeeName',   p_emp);
    APEX_JSON.write('status',         p_status);
    APEX_JSON.write('statusLabel', CASE p_status
      WHEN 'DRAFT'     THEN 'Draft'     WHEN 'SUBMITTED' THEN 'Submitted'
      WHEN 'APPROVED'  THEN 'Approved'  WHEN 'REJECTED'  THEN 'Rejected'
      WHEN 'RETURNED'  THEN 'Returned'  ELSE p_status END);
    APEX_JSON.write('statusClass', 'badge badge--' || LOWER(p_status));
    APEX_JSON.close_object;
  END write_settle;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;

  IF l_req_id IS NOT NULL THEN
    -- Single settlement for a specific request (returns object, not array)
    DECLARE
      l_s dt_settlement_v%ROWTYPE;
    BEGIN
      BEGIN
        SELECT * INTO l_s FROM dt_settlement_v WHERE request_id = l_req_id;
        APEX_JSON.write('settleId',        l_s.settlement_id);
        APEX_JSON.write('settleNumber',    l_s.settlement_number);
        APEX_JSON.write('reqId',           l_s.request_id);
        APEX_JSON.write('reqNumber',       l_s.request_number);
        APEX_JSON.write('actualReturn',    TO_CHAR(l_s.actual_return_date,'YYYY-MM-DD'));
        APEX_JSON.write('actualDays',      l_s.actual_per_diem_days);
        APEX_JSON.write('totalSettlement', l_s.total_actual_aed);
        APEX_JSON.write('advanceAmount',   l_s.advance_paid_aed);
        APEX_JSON.write('netPayable',      GREATEST(0, l_s.difference_aed));
        APEX_JSON.write('netRefund',       GREATEST(0, -l_s.difference_aed));
        APEX_JSON.write('employeeNotes',   l_s.employee_notes);
        APEX_JSON.write('status',          l_s.status);
        APEX_JSON.write('found', TRUE);
      EXCEPTION WHEN NO_DATA_FOUND THEN
        APEX_JSON.write('found', FALSE);
      END;
    END;

  ELSE
    APEX_JSON.open_array('items');
    IF l_mine = 'Y' THEN
      FOR s IN (
        SELECT s.settlement_id, s.settlement_number, s.request_id,
               s.request_number, s.employee_user_id,
               TO_CHAR(s.actual_return_date,'YYYY-MM-DD') AS ret_dt,
               s.actual_per_diem_days, s.total_actual_aed, s.advance_paid_aed,
               s.status, s.employee_name
        FROM dt_settlement_v s
        WHERE s.employee_user_id = l_uid
        ORDER BY s.settlement_id DESC
      ) LOOP
        write_settle(s.settlement_id, s.settlement_number, s.request_id, s.request_number,
                     s.ret_dt, s.actual_per_diem_days, s.total_actual_aed, s.advance_paid_aed,
                     s.status, s.employee_name);
      END LOOP;
    ELSIF l_status IS NOT NULL THEN
      -- Closure queue: APPROVED settlements
      FOR s IN (
        SELECT s.settlement_id, s.settlement_number, s.request_id,
               s.request_number, s.employee_user_id,
               TO_CHAR(s.actual_return_date,'YYYY-MM-DD') AS ret_dt,
               s.actual_per_diem_days, s.total_actual_aed, s.advance_paid_aed,
               s.status, s.employee_name
        FROM dt_settlement_v s
        WHERE s.status = l_status
        ORDER BY s.settlement_id DESC
      ) LOOP
        write_settle(s.settlement_id, s.settlement_number, s.request_id, s.request_number,
                     s.ret_dt, s.actual_per_diem_days, s.total_actual_aed, s.advance_paid_aed,
                     s.status, s.employee_name);
      END LOOP;
    ELSE
      FOR s IN (
        SELECT s.settlement_id, s.settlement_number, s.request_id,
               s.request_number, s.employee_user_id,
               TO_CHAR(s.actual_return_date,'YYYY-MM-DD') AS ret_dt,
               s.actual_per_diem_days, s.total_actual_aed, s.advance_paid_aed,
               s.status, s.employee_name
        FROM dt_settlement_v s
        ORDER BY s.settlement_id DESC
      ) LOOP
        write_settle(s.settlement_id, s.settlement_number, s.request_id, s.request_number,
                     s.ret_dt, s.actual_per_diem_days, s.total_actual_aed, s.advance_paid_aed,
                     s.status, s.employee_name);
      END LOOP;
    END IF;
    APEX_JSON.close_array;
  END IF;

  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('settlements/', 'POST', q'!
DECLARE
  l_user     VARCHAR2(100) := dct_rest.validate_session;
  l_uid      NUMBER;
  l_sid      NUMBER;
  l_snum     VARCHAR2(50);
  l_req_id   NUMBER;
  l_adv      NUMBER;
  l_year     VARCHAR2(4) := TO_CHAR(SYSDATE,'YYYY');
  l_seq      VARCHAR2(10);
  l_prefix   VARCHAR2(20) := 'DTS';
  l_new      CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);

  l_req_id := APEX_JSON.get_number(p_path => 'reqId');
  -- Snapshot advance from request
  SELECT total_advance_aed INTO l_adv FROM dt_requests WHERE request_id = l_req_id;

  BEGIN
    SELECT setting_value INTO l_prefix
    FROM dct_module_settings ms JOIN dct_modules m ON m.module_id = ms.module_id
    WHERE m.module_code = 'DUTY_TRAVEL' AND ms.setting_key = 'SETTLEMENT_NUMBER_PREFIX';
  EXCEPTION WHEN NO_DATA_FOUND THEN l_prefix := 'DTS'; END;

  SELECT seq_dt_settlement_number.NEXTVAL INTO l_seq FROM DUAL;
  l_snum := l_prefix || '-' || l_year || '-' || LPAD(l_seq, 5, '0');

  INSERT INTO dt_settlement (
    settlement_number, request_id, employee_user_id,
    actual_return_date, actual_per_diem_days,
    total_actual_aed, advance_paid_aed,
    employee_notes, status, created_by
  ) VALUES (
    l_snum, l_req_id, l_uid,
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'actualReturn'), 'YYYY-MM-DD'),
    NVL(APEX_JSON.get_number(p_path => 'actualDays'), 1),
    NVL(APEX_JSON.get_number(p_path => 'totalSettlement'), 0),
    l_adv,
    APEX_JSON.get_varchar2(p_path => 'notes'),
    NVL(APEX_JSON.get_varchar2(p_path => 'status'), 'DRAFT'),
    l_user
  ) RETURNING settlement_id INTO l_sid;

  -- Expense lines
  FOR i IN 1 .. NVL(APEX_JSON.get_count(p_path => 'lines'), 0) LOOP
    INSERT INTO dt_settlement_lines (
      settlement_id, line_num, expense_category, description, amount_aed
    ) VALUES (
      l_sid, i,
      NVL(APEX_JSON.get_varchar2(p_path => 'lines[%d].category', p0 => i), 'OTHER'),
      APEX_JSON.get_varchar2(p_path => 'lines[%d].description', p0 => i),
      NVL(APEX_JSON.get_number(p_path => 'lines[%d].amount', p0 => i), 0)
    );
  END LOOP;

  COMMIT;
  l_new := dct_audit_pkg.snap('DT_SETTLEMENT','settlement_id', TO_CHAR(l_sid));
  dct_audit_pkg.log(l_user,'CREATE','DT_SETTLEMENT', TO_CHAR(l_sid), 'DT',
                    p_object_ref=>l_snum, p_new=>l_new);
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('settleId',     l_sid);
  APEX_JSON.write('settleNumber', l_snum);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- SETTLEMENTS — single record
    -- =========================================================================
    def_template('settlements/[COLON]id');
    def_handler('settlements/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER        := [COLON]id;
  l_s    dt_settlement_v%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT * INTO l_s FROM dt_settlement_v WHERE settlement_id = l_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Settlement not found'); RETURN;
  END;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('settleId',        l_s.settlement_id);
  APEX_JSON.write('settleNumber',    l_s.settlement_number);
  APEX_JSON.write('reqId',           l_s.request_id);
  APEX_JSON.write('reqNumber',       l_s.request_number);
  APEX_JSON.write('employeeName',    l_s.employee_name);
  APEX_JSON.write('orgName',         l_s.org_name_en);
  APEX_JSON.write('plannedDeparture',TO_CHAR(l_s.planned_departure_date,'YYYY-MM-DD'));
  APEX_JSON.write('plannedReturn',   TO_CHAR(l_s.planned_return_date,'YYYY-MM-DD'));
  APEX_JSON.write('actualReturn',    TO_CHAR(l_s.actual_return_date,'YYYY-MM-DD'));
  APEX_JSON.write('actualDays',      l_s.actual_per_diem_days);
  APEX_JSON.write('totalSettlement', l_s.total_actual_aed);
  APEX_JSON.write('advanceAmount',   l_s.advance_paid_aed);
  APEX_JSON.write('netPayable',      GREATEST(0, l_s.difference_aed));
  APEX_JSON.write('netRefund',       GREATEST(0, -l_s.difference_aed));
  APEX_JSON.write('settlementType',  l_s.settlement_type);
  APEX_JSON.write('employeeNotes',   l_s.employee_notes);
  APEX_JSON.write('financeNotes',    l_s.finance_notes);
  APEX_JSON.write('status',          l_s.status);
  APEX_JSON.write('statusLabel', CASE l_s.status
    WHEN 'DRAFT'     THEN 'Draft'     WHEN 'SUBMITTED' THEN 'Submitted'
    WHEN 'APPROVED'  THEN 'Approved'  WHEN 'REJECTED'  THEN 'Rejected'
    WHEN 'RETURNED'  THEN 'Returned'  ELSE l_s.status END);
  APEX_JSON.write('statusClass', 'badge badge--' || LOWER(l_s.status));
  APEX_JSON.write('createdAt',   TO_CHAR(l_s.created_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
  -- Expense lines
  APEX_JSON.open_array('lines');
  FOR ln IN (
    SELECT line_id, line_num, expense_category, description, amount_aed
    FROM   dt_settlement_lines
    WHERE  settlement_id = l_id ORDER BY line_num
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('lineId',      ln.line_id);
    APEX_JSON.write('lineNum',     ln.line_num);
    APEX_JSON.write('category',    ln.expense_category);
    APEX_JSON.write('description', ln.description);
    APEX_JSON.write('amount',      ln.amount_aed);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('settlements/[COLON]id', 'PUT', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_id     NUMBER        := [COLON]id;
  l_status VARCHAR2(25);
  l_old    CLOB;
  l_new    CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT status INTO l_status FROM dt_settlement WHERE settlement_id = l_id;
  IF l_status NOT IN ('DRAFT','RETURNED') THEN
    dct_rest.err(400,'Only DRAFT or RETURNED settlements can be edited'); RETURN;
  END IF;
  l_old := dct_audit_pkg.snap('DT_SETTLEMENT','settlement_id', TO_CHAR(l_id));
  dct_rest.parse_body([COLON]body);
  UPDATE dt_settlement SET
    actual_return_date   = NVL(TO_DATE(APEX_JSON.get_varchar2(p_path => 'actualReturn'),'YYYY-MM-DD'), actual_return_date),
    actual_per_diem_days = NVL(APEX_JSON.get_number(p_path => 'actualDays'),       actual_per_diem_days),
    total_actual_aed     = NVL(APEX_JSON.get_number(p_path => 'totalSettlement'),  total_actual_aed),
    employee_notes       = APEX_JSON.get_varchar2(p_path => 'notes'),
    updated_by           = l_user,
    updated_at           = SYSTIMESTAMP
  WHERE settlement_id = l_id;
  -- Replace lines if provided
  IF APEX_JSON.get_count(p_path => 'lines') >= 0 THEN
    DELETE FROM dt_settlement_lines WHERE settlement_id = l_id;
    FOR i IN 1 .. NVL(APEX_JSON.get_count(p_path => 'lines'), 0) LOOP
      INSERT INTO dt_settlement_lines (settlement_id, line_num, expense_category, description, amount_aed)
      VALUES (l_id, i,
        NVL(APEX_JSON.get_varchar2(p_path => 'lines[%d].category', p0 => i), 'OTHER'),
        APEX_JSON.get_varchar2(p_path => 'lines[%d].description', p0 => i),
        NVL(APEX_JSON.get_number(p_path => 'lines[%d].amount', p0 => i), 0)
      );
    END LOOP;
  END IF;
  COMMIT;
  l_new := dct_audit_pkg.snap('DT_SETTLEMENT','settlement_id', TO_CHAR(l_id));
  dct_audit_pkg.log(l_user,'UPDATE','DT_SETTLEMENT', TO_CHAR(l_id), 'DT',
                    p_old=>l_old, p_new=>l_new);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- SETTLEMENT ACTIONS
    -- =========================================================================
    def_template('settlements/[COLON]id/submit');
    def_handler('settlements/[COLON]id/submit', 'POST', q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_id      NUMBER        := [COLON]id;
  l_uid     NUMBER;
  l_status  VARCHAR2(25);
  l_ref     VARCHAR2(50);
  l_tmpl_id NUMBER;
  l_inst_id NUMBER;
  l_first   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT s.status, s.settlement_number INTO l_status, l_ref
  FROM dt_settlement s WHERE settlement_id = l_id;
  IF l_status NOT IN ('DRAFT','RETURNED') THEN
    dct_rest.err(400,'Settlement cannot be submitted in status: ' || l_status); RETURN;
  END IF;
  BEGIN
    SELECT at2.template_id INTO l_tmpl_id
    FROM dct_approval_templates at2 JOIN dct_modules m ON m.module_id = at2.module_id
    WHERE m.module_code = 'DUTY_TRAVEL' AND at2.request_type = 'SETTLEMENT' AND at2.is_active = 'Y'
    FETCH FIRST 1 ROW ONLY;
  EXCEPTION WHEN NO_DATA_FOUND THEN l_tmpl_id := NULL; END;
  IF l_tmpl_id IS NOT NULL THEN
    SELECT MIN(step_seq) INTO l_first FROM dct_approval_steps WHERE template_id = l_tmpl_id;
    INSERT INTO dct_approval_instances (
      template_id, source_module, source_record_id, source_record_ref,
      current_step_seq, overall_status, submitted_by, created_by
    ) VALUES (l_tmpl_id, 'SETTLEMENT', l_id, l_ref, l_first, 'PENDING', l_uid, l_user)
    RETURNING instance_id INTO l_inst_id;
  END IF;
  UPDATE dt_settlement SET
    status               = 'SUBMITTED',
    approval_instance_id = l_inst_id,
    updated_by           = l_user,
    updated_at           = SYSTIMESTAMP
  WHERE settlement_id = l_id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('status', 'SUBMITTED');
  APEX_JSON.write('instanceId', l_inst_id);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('settlements/[COLON]id/close');
    def_handler('settlements/[COLON]id/close', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_id     NUMBER        := [COLON]id;
  l_uid    NUMBER;
  l_status VARCHAR2(25);
  l_req_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT status, request_id INTO l_status, l_req_id FROM dt_settlement WHERE settlement_id = l_id;
  IF l_status != 'APPROVED' THEN
    dct_rest.err(400,'Only APPROVED settlements can be closed'); RETURN;
  END IF;
  -- Close the parent travel request
  UPDATE dt_requests SET
    status            = 'CLOSED',
    closed_date       = TRUNC(SYSDATE),
    closed_by_user_id = l_uid,
    updated_by        = l_user,
    updated_at        = SYSTIMESTAMP
  WHERE request_id = l_req_id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- APPROVALS — pending for current user
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
    SELECT ai.instance_id, ai.source_module, ai.source_record_id,
           ai.source_record_ref, ai.submitted_at,
           ast.step_name,
           rol.role_code       AS required_role,
           sub.display_name    AS submitted_by_name,
           CASE ai.source_module
             WHEN 'TRAVEL_REQUEST' THEN req.total_advance_aed
             WHEN 'SETTLEMENT'     THEN stl.total_actual_aed
           END AS amount
    FROM   dct_approval_instances ai
    JOIN   dct_approval_steps     ast ON ast.template_id = ai.template_id
                                     AND ast.step_seq    = ai.current_step_seq
    JOIN   dct_roles              rol ON rol.role_id     = ast.required_role_id
    JOIN   dct_users              sub ON sub.user_id     = ai.submitted_by
    LEFT JOIN dt_requests         req ON req.request_id  = ai.source_record_id
                                     AND ai.source_module = 'TRAVEL_REQUEST'
    LEFT JOIN dt_settlement       stl ON stl.settlement_id = ai.source_record_id
                                     AND ai.source_module  = 'SETTLEMENT'
    WHERE  ai.overall_status = 'PENDING'
      AND  ai.source_module IN ('TRAVEL_REQUEST','SETTLEMENT')
      AND  INSTR(l_roles, ',' || rol.role_code || ',') > 0
    ORDER BY ai.submitted_at
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('instanceId',    r.instance_id);
    APEX_JSON.write('requestRef',    r.source_record_ref);
    APEX_JSON.write('requestType',   r.source_module);
    APEX_JSON.write('sourceRecordId',r.source_record_id);
    APEX_JSON.write('submittedBy',   r.submitted_by_name);
    APEX_JSON.write('submittedAt',   TO_CHAR(r.submitted_at,'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('currentStep',   r.step_name);
    APEX_JSON.write('amount',        r.amount);
    APEX_JSON.write('overallStatus', 'PENDING');
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- APPROVALS — submit action (approve / reject / return)
    -- =========================================================================
    def_template('approvals/[COLON]id/action');
    def_handler('approvals/[COLON]id/action', 'POST', q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_iid     NUMBER        := [COLON]id;
  l_uid     NUMBER;
  l_action  VARCHAR2(20);
  l_comments VARCHAR2(4000);
  l_inst    dct_approval_instances%ROWTYPE;
  l_step_id NUMBER;
  l_amount  NUMBER := 0;
  l_next    NUMBER := NULL;
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

  -- Get step_id for the current step
  SELECT step_id INTO l_step_id
  FROM dct_approval_steps
  WHERE template_id = l_inst.template_id AND step_seq = l_inst.current_step_seq;

  -- Record the action
  INSERT INTO dct_approval_actions (instance_id, step_id, actioned_by, action, comments)
  VALUES (l_iid, l_step_id, l_uid, l_action, l_comments);

  IF l_action = 'APPROVED' THEN
    -- Get amount for conditional step evaluation
    BEGIN
      IF l_inst.source_module = 'TRAVEL_REQUEST' THEN
        SELECT total_advance_aed INTO l_amount FROM dt_requests WHERE request_id = l_inst.source_record_id;
      ELSIF l_inst.source_module = 'SETTLEMENT' THEN
        SELECT total_actual_aed INTO l_amount FROM dt_settlement WHERE settlement_id = l_inst.source_record_id;
      END IF;
    EXCEPTION WHEN OTHERS THEN l_amount := 0; END;

    -- Find next applicable step
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
    ELSE
      -- Final approval
      UPDATE dct_approval_instances SET
        overall_status = 'APPROVED', current_step_seq = NULL,
        completed_at = SYSTIMESTAMP, last_action_at = SYSTIMESTAMP,
        updated_by = l_user, updated_at = SYSTIMESTAMP
      WHERE instance_id = l_iid;
      -- Update source record
      IF l_inst.source_module = 'TRAVEL_REQUEST' THEN
        UPDATE dt_requests SET status = 'APPROVED', updated_by = l_user, updated_at = SYSTIMESTAMP
        WHERE request_id = l_inst.source_record_id;
      ELSIF l_inst.source_module = 'SETTLEMENT' THEN
        UPDATE dt_settlement SET status = 'APPROVED', updated_by = l_user, updated_at = SYSTIMESTAMP
        WHERE settlement_id = l_inst.source_record_id;
      END IF;
    END IF;

  ELSE
    -- REJECTED or RETURNED
    UPDATE dct_approval_instances SET
      overall_status = l_action, current_step_seq = NULL,
      completed_at = SYSTIMESTAMP, last_action_at = SYSTIMESTAMP,
      updated_by = l_user, updated_at = SYSTIMESTAMP
    WHERE instance_id = l_iid;
    -- Update source record
    IF l_inst.source_module = 'TRAVEL_REQUEST' THEN
      UPDATE dt_requests SET status = l_action, updated_by = l_user, updated_at = SYSTIMESTAMP
      WHERE request_id = l_inst.source_record_id;
    ELSIF l_inst.source_module = 'SETTLEMENT' THEN
      UPDATE dt_settlement SET status = l_action, updated_by = l_user, updated_at = SYSTIMESTAMP
      WHERE settlement_id = l_inst.source_record_id;
    END IF;
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

    -- =========================================================================
    -- APPROVAL TEMPLATES + STEPS
    -- =========================================================================
    def_template('approval-templates/');
    def_handler('approval-templates/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT at2.template_id, at2.template_code, at2.template_name,
           at2.request_type, at2.is_sequential, at2.is_active
    FROM   dct_approval_templates at2 JOIN dct_modules m ON m.module_id = at2.module_id
    WHERE  m.module_code = 'DUTY_TRAVEL'
    ORDER  BY at2.template_code
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
  APEX_JSON.close_object;
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
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR s IN (
    SELECT ast.step_id, ast.step_seq, ast.step_name, ast.step_type,
           ast.condition_type, ast.amount_operator, ast.amount_threshold,
           ast.is_mandatory, ast.allow_skip,
           rol.role_code AS required_role, rol.role_name_en AS required_role_name
    FROM   dct_approval_steps ast
    LEFT JOIN dct_roles rol ON rol.role_id = ast.required_role_id
    WHERE  ast.template_id = [COLON]id
    ORDER  BY ast.step_seq
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('stepId',           s.step_id);
    APEX_JSON.write('stepSeq',          s.step_seq);
    APEX_JSON.write('stepName',         s.step_name);
    APEX_JSON.write('stepType',         s.step_type);
    APEX_JSON.write('conditionType',    s.condition_type);
    APEX_JSON.write('amountOperator',   s.amount_operator);
    APEX_JSON.write('amountThreshold',  s.amount_threshold);
    APEX_JSON.write('isMandatory',      s.is_mandatory);
    APEX_JSON.write('allowSkip',        s.allow_skip);
    APEX_JSON.write('requiredRole',     s.required_role);
    APEX_JSON.write('requiredRoleName', s.required_role_name);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- MODULE SETTINGS (DT-specific)
    -- =========================================================================
    def_template('settings/');
    def_handler('settings/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
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
           ms.value_type, ms.allowed_values, ms.default_value
    FROM   dct_module_settings ms JOIN dct_modules m ON m.module_id = ms.module_id
    WHERE  m.module_code = 'DUTY_TRAVEL'
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
  dct_rest.parse_body([COLON]body);
  -- '********' is the masked placeholder for secrets — never write it back
  IF APEX_JSON.get_varchar2(p_path => 'settingValue') = '********' THEN
    dct_rest.json_header;
    APEX_JSON.initialize_output;
    APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.write('skipped', 'masked value'); APEX_JSON.close_object;
    RETURN;
  END IF;
  UPDATE dct_module_settings SET
    setting_value = APEX_JSON.get_varchar2(p_path => 'settingValue'),
    updated_by    = l_user,
    updated_at    = SYSTIMESTAMP
  WHERE setting_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- NOTIFICATIONS (DT-scoped)
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
      AND  (module_code = 'DUTY_TRAVEL' OR module_code IS NULL)
      AND  (expires_at IS NULL OR expires_at > SYSTIMESTAMP)
    ORDER BY created_at DESC
    FETCH FIRST 50 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('notifId',   r.notification_id);
    APEX_JSON.write('titleEn',   r.title_en);
    APEX_JSON.write('bodyEn',    r.body_en);
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

    -- Mark all read must come before :id/read to avoid ORDS pattern conflict
    def_template('notifications/mark-all-read');
    def_handler('notifications/mark-all-read', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  UPDATE dct_notifications SET is_read = 'Y', read_at = SYSTIMESTAMP
  WHERE  recipient_user_id = l_uid AND (module_code = 'DUTY_TRAVEL' OR module_code IS NULL) AND is_read = 'N';
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
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
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- PER DIEM RATES
    -- =========================================================================
    -- Lookup endpoint must come before the list (literal pattern > bind pattern)
    def_template('perdiem-rates/lookup');
    def_handler('perdiem-rates/lookup', 'GET', q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_country VARCHAR2(3)   := [COLON]country;
  l_grade   VARCHAR2(20)  := [COLON]grade;
  l_date    DATE          := NVL(TO_DATE([COLON]date,'YYYY-MM-DD'), TRUNC(SYSDATE));
  l_rec     dt_per_diem_rates%ROWTYPE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT * INTO l_rec FROM dt_per_diem_rates
    WHERE  rate_key   = l_country
      AND  grade_code IN (l_grade, 'ALL')
      AND  is_active  = 'Y'
      AND  effective_from <= l_date
      AND  (effective_to IS NULL OR effective_to >= l_date)
    ORDER BY CASE WHEN grade_code = l_grade THEN 1 ELSE 2 END
    FETCH FIRST 1 ROW ONLY;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.json_header;
    APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('found', FALSE);
    APEX_JSON.close_object;
    RETURN;
  END;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('found',          TRUE);
  APEX_JSON.write('rateId',         l_rec.rate_id);
  APEX_JSON.write('rateKey',        l_rec.rate_key);
  APEX_JSON.write('rateKeyName',    l_rec.rate_key_name_en);
  APEX_JSON.write('gradeCode',      l_rec.grade_code);
  APEX_JSON.write('dailyRateAed',   l_rec.per_diem_daily_aed);
  APEX_JSON.write('effectiveFrom',  TO_CHAR(l_rec.effective_from,'YYYY-MM-DD'));
  APEX_JSON.write('effectiveTo',    TO_CHAR(l_rec.effective_to,'YYYY-MM-DD'));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('perdiem-rates/');
    def_handler('perdiem-rates/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT rate_id, rate_key, rate_key_name_en, grade_code, grade_label,
           per_diem_daily_aed,
           TO_CHAR(effective_from,'YYYY-MM-DD') AS eff_from,
           TO_CHAR(effective_to,'YYYY-MM-DD')   AS eff_to,
           is_active, rate_status, notes
    FROM dt_rate_master_v ORDER BY rate_key, grade_code
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('rateId',        r.rate_id);
    APEX_JSON.write('rateKey',       r.rate_key);
    APEX_JSON.write('rateKeyName',   r.rate_key_name_en);
    APEX_JSON.write('gradeCode',     r.grade_code);
    APEX_JSON.write('gradeLabel',    r.grade_label);
    APEX_JSON.write('dailyRateAed',  r.per_diem_daily_aed);
    APEX_JSON.write('effectiveFrom', r.eff_from);
    APEX_JSON.write('effectiveTo',   r.eff_to);
    APEX_JSON.write('isActive',      r.is_active);
    APEX_JSON.write('rateStatus',    r.rate_status);
    APEX_JSON.write('notes',         r.notes);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('perdiem-rates/', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_rid    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  INSERT INTO dt_per_diem_rates (
    rate_key, rate_key_name_en, rate_key_name_ar, grade_code,
    per_diem_daily_aed, effective_from, effective_to, is_active, notes, created_by
  ) VALUES (
    UPPER(TRIM(APEX_JSON.get_varchar2(p_path => 'rateKey'))),
    APEX_JSON.get_varchar2(p_path => 'rateKeyName'),
    APEX_JSON.get_varchar2(p_path => 'rateKeyNameAr'),
    UPPER(TRIM(APEX_JSON.get_varchar2(p_path => 'gradeCode'))),
    APEX_JSON.get_number(p_path => 'dailyRateAed'),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'effectiveFrom'), 'YYYY-MM-DD'),
    CASE WHEN APEX_JSON.get_varchar2(p_path => 'effectiveTo') IS NOT NULL
         THEN TO_DATE(APEX_JSON.get_varchar2(p_path => 'effectiveTo'), 'YYYY-MM-DD') END,
    NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), 'Y'),
    APEX_JSON.get_varchar2(p_path => 'notes'),
    l_user
  ) RETURNING rate_id INTO l_rid;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('rateId', l_rid);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('perdiem-rates/[COLON]id');
    def_handler('perdiem-rates/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dt_per_diem_rates SET
    rate_key_name_en  = NVL(APEX_JSON.get_varchar2(p_path => 'rateKeyName'),    rate_key_name_en),
    grade_code        = NVL(UPPER(TRIM(APEX_JSON.get_varchar2(p_path => 'gradeCode'))), grade_code),
    per_diem_daily_aed= NVL(APEX_JSON.get_number(p_path => 'dailyRateAed'),     per_diem_daily_aed),
    effective_from    = NVL(TO_DATE(APEX_JSON.get_varchar2(p_path => 'effectiveFrom'),'YYYY-MM-DD'), effective_from),
    effective_to      = CASE WHEN APEX_JSON.get_varchar2(p_path => 'effectiveTo') IS NOT NULL
                             THEN TO_DATE(APEX_JSON.get_varchar2(p_path => 'effectiveTo'),'YYYY-MM-DD')
                             ELSE effective_to END,
    is_active         = NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), is_active),
    notes             = APEX_JSON.get_varchar2(p_path => 'notes'),
    updated_by        = l_user,
    updated_at        = SYSTIMESTAMP
  WHERE rate_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('perdiem-rates/[COLON]id', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  UPDATE dt_per_diem_rates SET is_active = 'N', updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE rate_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- COUNTRY GROUPS (admin — view + update group membership)
    -- =========================================================================
    def_template('country-groups/');
    def_handler('country-groups/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT DISTINCT group_code,
           MIN(is_active) AS grp_active,
           COUNT(*)       AS member_count
    FROM dt_country_groups
    GROUP BY group_code ORDER BY group_code
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('groupCode',   r.group_code);
    APEX_JSON.write('groupName',   r.group_code);  -- name = code; enriched via rate master if needed
    APEX_JSON.write('memberCount', r.member_count);
    APEX_JSON.write('isActive',    r.grp_active);
    APEX_JSON.open_array('members');
    FOR m IN (
      SELECT country_code, country_name_en FROM dt_country_groups
      WHERE group_code = r.group_code ORDER BY country_name_en
    ) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('countryCode', m.country_code);
      APEX_JSON.write('countryName', m.country_name_en);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('country-groups/[COLON]code');
    def_handler('country-groups/[COLON]code', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dt_country_groups SET
    group_code = NVL(APEX_JSON.get_varchar2(p_path => 'newGroupCode'), group_code),
    is_active  = NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), is_active),
    updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE country_code = [COLON]code;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- COUNTRIES (distinct active entries — used in destination picker)
    -- =========================================================================
    def_template('countries/');
    def_handler('countries/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT country_code, country_name_en AS country_name, group_code, is_active
    FROM dt_country_groups
    WHERE is_active = 'Y'
    ORDER BY country_name_en
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('countryCode', r.country_code);
    APEX_JSON.write('countryName', r.country_name);
    APEX_JSON.write('groupCode',   r.group_code);
    APEX_JSON.write('isActive',    r.is_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- DOC REQUIREMENTS (admin — view)
    -- =========================================================================
    def_template('doc-requirements/');
    def_handler('doc-requirements/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT doc_req_id, mission_type, mission_type_label, trip_type, trip_type_label,
           document_type_id, document_type_name, is_mandatory,
           applies_to_source, applies_to_source_label, display_seq, is_active
    FROM dt_doc_requirements_v
    ORDER BY mission_type, trip_type, display_seq
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('docReqId',            r.doc_req_id);
    APEX_JSON.write('missionType',         r.mission_type);
    APEX_JSON.write('missionTypeLabel',    r.mission_type_label);
    APEX_JSON.write('tripType',            r.trip_type);
    APEX_JSON.write('tripTypeLabel',       r.trip_type_label);
    APEX_JSON.write('documentTypeId',      r.document_type_id);
    APEX_JSON.write('documentTypeName',    r.document_type_name);
    APEX_JSON.write('isMandatory',         r.is_mandatory);
    APEX_JSON.write('appliesToSource',     r.applies_to_source);
    APEX_JSON.write('appliesToSourceLabel',r.applies_to_source_label);
    APEX_JSON.write('displaySeq',          r.display_seq);
    APEX_JSON.write('isActive',            r.is_active);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('doc-requirements/[COLON]id');
    def_handler('doc-requirements/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dt_doc_requirements SET
    is_mandatory      = NVL(APEX_JSON.get_varchar2(p_path => 'isMandatory'),     is_mandatory),
    applies_to_source = NVL(APEX_JSON.get_varchar2(p_path => 'appliesToSource'), applies_to_source),
    display_seq       = NVL(APEX_JSON.get_number(p_path   => 'displaySeq'),      display_seq),
    is_active         = NVL(APEX_JSON.get_varchar2(p_path => 'isActive'),         is_active),
    updated_by        = l_user,
    updated_at        = SYSTIMESTAMP
  WHERE doc_req_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('DT ORDS module dt.rest published successfully.');

END setup_dt_ords_tmp;
/

-- Execute (separate block so locks are released before DROP)
BEGIN
    setup_dt_ords_tmp;
END;
/

-- Drop the setup helper
BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE setup_dt_ords_tmp';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

PROMPT ============================================================
PROMPT  06_dt_ords.sql complete.
PROMPT  Base URL  : /ords/admin/dt/
PROMPT  Endpoints :
PROMPT    GET  dashboard/
PROMPT    GET  requests/           ?mine=Y | ?advancePending=Y
PROMPT    POST requests/
PROMPT    GET  requests/:id
PROMPT    PUT  requests/:id
PROMPT    POST requests/:id/submit
PROMPT    POST requests/:id/cancel
PROMPT    POST requests/:id/pay-advance
PROMPT    POST requests/:id/mark-travelled
PROMPT    GET  requests/:id/destinations
PROMPT    GET  settlements/        ?mine=Y | ?reqId=N | ?status=APPROVED
PROMPT    POST settlements/
PROMPT    GET  settlements/:id
PROMPT    PUT  settlements/:id
PROMPT    POST settlements/:id/submit
PROMPT    POST settlements/:id/close
PROMPT    GET  approvals/pending
PROMPT    POST approvals/:id/action
PROMPT    GET  approval-templates/
PROMPT    GET  approval-templates/:id/steps
PROMPT    GET  settings/
PROMPT    PUT  settings/:id
PROMPT    GET  notifications/
PROMPT    POST notifications/mark-all-read
PROMPT    POST notifications/:id/read
PROMPT    GET  perdiem-rates/lookup   ?country=XX&grade=G1&date=YYYY-MM-DD
PROMPT    GET  perdiem-rates/
PROMPT    POST perdiem-rates/
PROMPT    PUT  perdiem-rates/:id
PROMPT    DELETE perdiem-rates/:id
PROMPT    GET  country-groups/
PROMPT    PUT  country-groups/:code
PROMPT    GET  countries/
PROMPT    GET  doc-requirements/
PROMPT    PUT  doc-requirements/:id
PROMPT ============================================================
