-- =============================================================================
-- Duty Travel Module (App 204) — PL/SQL Package
-- File    : 04_dct_dt_pkg.sql
-- Schema  : PROD
-- Run     : After 01_dt_ddl.sql, 02_dt_seed.sql, 03_dt_views.sql
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- PACKAGE SPEC
-- =============================================================================
CREATE OR REPLACE PACKAGE prod.dct_dt_pkg AS

    -- -------------------------------------------------------------------------
    -- Number generators
    -- -------------------------------------------------------------------------
    FUNCTION generate_request_number    RETURN VARCHAR2;
    FUNCTION generate_settlement_number RETURN VARCHAR2;

    -- -------------------------------------------------------------------------
    -- Rate lookup & per diem calculation
    -- -------------------------------------------------------------------------
    FUNCTION get_rate (
        p_country_code VARCHAR2,
        p_grade_code   VARCHAR2,
        p_travel_date  DATE
    ) RETURN NUMBER;  -- returns rate_id; NULL if not found

    PROCEDURE calc_per_diem (p_request_id NUMBER);

    -- -------------------------------------------------------------------------
    -- Document validation
    -- -------------------------------------------------------------------------
    PROCEDURE validate_docs (
        p_source_type VARCHAR2,   -- 'REQUEST' or 'SETTLEMENT'
        p_source_id   NUMBER
    );

    -- -------------------------------------------------------------------------
    -- Request lifecycle
    -- -------------------------------------------------------------------------
    PROCEDURE submit_request  (p_request_id NUMBER);
    PROCEDURE cancel_request  (p_request_id NUMBER, p_user_id NUMBER);

    -- -------------------------------------------------------------------------
    -- Finance actions (called from APEX pages 50 and 60)
    -- -------------------------------------------------------------------------
    PROCEDURE mark_advance_paid (p_request_id NUMBER, p_user_id NUMBER);
    PROCEDURE close_request     (p_request_id NUMBER, p_user_id NUMBER DEFAULT NULL);

    -- -------------------------------------------------------------------------
    -- Scheduled jobs (called by DBMS_SCHEDULER daily jobs)
    -- -------------------------------------------------------------------------
    PROCEDURE set_travelled_status;   -- ADVANCE_PAID → TRAVELLED when past return_date
    PROCEDURE auto_close_requests;    -- TRAVELLED → CLOSED when SETTLEMENT_REQUIRED=N + delay elapsed
    PROCEDURE send_settlement_alerts; -- notify Finance when settlement overdue

END dct_dt_pkg;
/

-- =============================================================================
-- PACKAGE BODY
-- =============================================================================
CREATE OR REPLACE PACKAGE BODY prod.dct_dt_pkg AS

    -- -------------------------------------------------------------------------
    -- Internal helper: read a module setting value
    -- -------------------------------------------------------------------------
    FUNCTION get_setting (p_key VARCHAR2) RETURN VARCHAR2 IS
        v_val VARCHAR2(1000);
    BEGIN
        SELECT ms.setting_value
        INTO   v_val
        FROM   dct_module_settings ms
        JOIN   dct_modules         m  ON m.module_id = ms.module_id
        WHERE  m.module_code  = 'DUTY_TRAVEL'
        AND    ms.setting_key = p_key;
        RETURN v_val;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
    END get_setting;

    -- -------------------------------------------------------------------------
    -- Internal helper: get next sequence value formatted as number string
    -- -------------------------------------------------------------------------
    FUNCTION next_seq_val (p_seq_name VARCHAR2) RETURN NUMBER IS
        v_val NUMBER;
    BEGIN
        EXECUTE IMMEDIATE 'SELECT prod.' || p_seq_name || '.NEXTVAL FROM dual' INTO v_val;
        RETURN v_val;
    END next_seq_val;

    -- =========================================================================
    -- GENERATE_REQUEST_NUMBER
    --   Format: {REQUEST_NUMBER_PREFIX}-{YYYY}-{00001}
    -- =========================================================================
    FUNCTION generate_request_number RETURN VARCHAR2 IS
        v_prefix VARCHAR2(20) := NVL(get_setting('REQUEST_NUMBER_PREFIX'), 'DT-REQ');
        v_seq    NUMBER       := next_seq_val('seq_dt_request_number');
    BEGIN
        RETURN v_prefix || '-' || TO_CHAR(SYSDATE,'YYYY') || '-' || LPAD(v_seq, 5, '0');
    END generate_request_number;

    -- =========================================================================
    -- GENERATE_SETTLEMENT_NUMBER
    --   Format: {SETTLEMENT_NUMBER_PREFIX}-{YYYY}-{00001}
    -- =========================================================================
    FUNCTION generate_settlement_number RETURN VARCHAR2 IS
        v_prefix VARCHAR2(20) := NVL(get_setting('SETTLEMENT_NUMBER_PREFIX'), 'DT-STL');
        v_seq    NUMBER       := next_seq_val('seq_dt_settlement_number');
    BEGIN
        RETURN v_prefix || '-' || TO_CHAR(SYSDATE,'YYYY') || '-' || LPAD(v_seq, 5, '0');
    END generate_settlement_number;

    -- =========================================================================
    -- GET_RATE
    --   Returns rate_id for the best matching rate row.
    --   Resolution order:
    --     1. Determine lookup_key from RATE_STRUCTURE setting
    --     2. Query DT_PER_DIEM_RATES for exact grade match
    --     3. Fall back to grade_code = 'ALL'
    --   Returns NULL if no rate is found (caller stores 0 for the leg).
    -- =========================================================================
    FUNCTION get_rate (
        p_country_code VARCHAR2,
        p_grade_code   VARCHAR2,
        p_travel_date  DATE
    ) RETURN NUMBER IS
        v_structure  VARCHAR2(20) := NVL(get_setting('RATE_STRUCTURE'), 'PER_COUNTRY');
        v_lookup_key VARCHAR2(20);
        v_rate_id    NUMBER;
    BEGIN
        -- Resolve lookup key
        IF v_structure = 'PER_COUNTRY' THEN
            v_lookup_key := p_country_code;
        ELSE
            BEGIN
                SELECT group_code INTO v_lookup_key
                FROM   dt_country_groups
                WHERE  country_code = p_country_code
                AND    is_active    = 'Y';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN v_lookup_key := p_country_code;
            END;
        END IF;

        -- Grade-specific rate
        BEGIN
            SELECT rate_id INTO v_rate_id
            FROM   dt_per_diem_rates
            WHERE  rate_key      = v_lookup_key
            AND    grade_code    = p_grade_code
            AND    effective_from <= p_travel_date
            AND    (effective_to IS NULL OR effective_to >= p_travel_date)
            AND    is_active     = 'Y'
            ORDER  BY effective_from DESC
            FETCH  FIRST 1 ROW ONLY;
            RETURN v_rate_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;

        -- Fallback to ALL grade
        BEGIN
            SELECT rate_id INTO v_rate_id
            FROM   dt_per_diem_rates
            WHERE  rate_key      = v_lookup_key
            AND    grade_code    = 'ALL'
            AND    effective_from <= p_travel_date
            AND    (effective_to IS NULL OR effective_to >= p_travel_date)
            AND    is_active     = 'Y'
            ORDER  BY effective_from DESC
            FETCH  FIRST 1 ROW ONLY;
            RETURN v_rate_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN RETURN NULL;
        END;
    END get_rate;

    -- =========================================================================
    -- CALC_PER_DIEM
    --   Called after any insert/update/delete on DT_DESTINATIONS for a request.
    --   1. Loops over all destination legs for the request.
    --   2. For each leg: resolves rate, applies half-day policy, computes total.
    --   3. Updates leg columns (rate_id, per_diem_daily_rate_aed, per_diem_total_aed).
    --   4. Rolls up total_per_diem_aed and total_advance_aed on the request header.
    -- =========================================================================
    PROCEDURE calc_per_diem (p_request_id NUMBER) IS
        v_req        dt_requests%ROWTYPE;
        v_policy     VARCHAR2(20) := NVL(get_setting('PER_DIEM_HALF_DAY_POLICY'), 'NONE');
        v_rate_id    NUMBER;
        v_daily_rate NUMBER;
        v_leg_days   NUMBER;
        v_leg_total  NUMBER;
        v_sum_pdiem  NUMBER := 0;

        -- Enabled allowance flags
        v_tick_on    VARCHAR2(1) := NVL(get_setting('INCLUDE_TICKET_ALLOWANCE'),          'Y');
        v_accom_on   VARCHAR2(1) := NVL(get_setting('INCLUDE_ACCOMMODATION_ALLOWANCE'),   'Y');
        v_visa_on    VARCHAR2(1) := NVL(get_setting('INCLUDE_VISA_ALLOWANCE'),            'Y');
        v_trans_on   VARCHAR2(1) := NVL(get_setting('INCLUDE_LOCAL_TRANSPORT_ALLOWANCE'), 'N');
    BEGIN
        -- Lock the request row
        SELECT * INTO v_req FROM dt_requests WHERE request_id = p_request_id FOR UPDATE;

        -- Process each leg
        FOR leg IN (
            SELECT destination_id, country_code, arrival_date, departure_date,
                   duration_days
            FROM   dt_destinations
            WHERE  request_id = p_request_id
            ORDER  BY seq_num
        ) LOOP
            v_rate_id    := get_rate(leg.country_code, v_req.employee_grade_code, leg.arrival_date);
            v_daily_rate := 0;

            IF v_rate_id IS NOT NULL THEN
                SELECT per_diem_daily_aed INTO v_daily_rate
                FROM   dt_per_diem_rates WHERE rate_id = v_rate_id;
            END IF;

            -- Apply half-day policy
            v_leg_days := leg.duration_days;
            IF v_policy = 'FIRST_LAST' AND v_leg_days >= 2 THEN
                v_leg_total := (v_leg_days - 2) * v_daily_rate + v_daily_rate * 0.5 * 2;
            ELSIF v_policy = 'FIRST_ONLY' AND v_leg_days >= 1 THEN
                v_leg_total := (v_leg_days - 1) * v_daily_rate + v_daily_rate * 0.5;
            ELSE
                v_leg_total := v_leg_days * v_daily_rate;
            END IF;

            UPDATE dt_destinations
            SET    rate_id                = v_rate_id,
                   per_diem_daily_rate_aed = v_daily_rate,
                   per_diem_total_aed      = ROUND(v_leg_total, 2),
                   updated_at              = SYSTIMESTAMP
            WHERE  destination_id = leg.destination_id;

            v_sum_pdiem := v_sum_pdiem + ROUND(v_leg_total, 2);
        END LOOP;

        -- Roll up to request header
        UPDATE dt_requests SET
            total_per_diem_aed = v_sum_pdiem,
            total_advance_aed  = v_sum_pdiem
                + CASE WHEN v_tick_on  = 'Y' THEN v_req.ticket_amount_aed        ELSE 0 END
                + CASE WHEN v_accom_on = 'Y' THEN v_req.accommodation_amount_aed ELSE 0 END
                + CASE WHEN v_visa_on  = 'Y' THEN v_req.visa_fees_aed            ELSE 0 END
                + CASE WHEN v_trans_on = 'Y' THEN v_req.local_transport_aed      ELSE 0 END
                + v_req.other_allowances_aed,
            updated_at         = SYSTIMESTAMP
        WHERE request_id = p_request_id;
    END calc_per_diem;

    -- =========================================================================
    -- VALIDATE_DOCS
    --   Checks that all mandatory document types from DT_DOC_REQUIREMENTS are
    --   uploaded in DT_DOCUMENTS for the given source.
    --   Raises ORA-20001 listing missing document types if any are absent.
    -- =========================================================================
    PROCEDURE validate_docs (
        p_source_type VARCHAR2,
        p_source_id   NUMBER
    ) IS
        v_mission   VARCHAR2(20);
        v_trip      VARCHAR2(10);
        v_missing   VARCHAR2(4000) := '';

        CURSOR c_missing IS
            SELECT lv.value_name_en AS doc_type_name
            FROM   dt_doc_requirements dr
            JOIN   dct_lookup_values   lv ON lv.value_id = dr.document_type_id
            WHERE  dr.is_mandatory    = 'Y'
            AND    dr.is_active       = 'Y'
            AND    dr.applies_to_source IN (p_source_type, 'BOTH')
            AND   (dr.mission_type = v_mission OR dr.mission_type = 'ALL')
            AND   (dr.trip_type    = v_trip    OR dr.trip_type    = 'ALL')
            AND    NOT EXISTS (
                SELECT 1 FROM dt_documents d
                WHERE  d.source_type     = p_source_type
                AND    d.source_id       = p_source_id
                AND    d.document_type_id = dr.document_type_id
            );
    BEGIN
        -- Get mission / trip context for validation
        IF p_source_type = 'REQUEST' THEN
            SELECT mission_type, trip_type
            INTO   v_mission, v_trip
            FROM   dt_requests WHERE request_id = p_source_id;
        ELSIF p_source_type = 'SETTLEMENT' THEN
            SELECT r.mission_type, r.trip_type
            INTO   v_mission, v_trip
            FROM   dt_settlement s
            JOIN   dt_requests   r ON r.request_id = s.request_id
            WHERE  s.settlement_id = p_source_id;
        END IF;

        FOR rec IN c_missing LOOP
            v_missing := v_missing || rec.doc_type_name || ', ';
        END LOOP;

        IF v_missing IS NOT NULL THEN
            v_missing := RTRIM(v_missing, ', ');
            RAISE_APPLICATION_ERROR(-20001,
                'Missing mandatory documents: ' || v_missing);
        END IF;
    END validate_docs;

    -- =========================================================================
    -- SUBMIT_REQUEST
    --   Validates docs, creates an approval instance, sets status = SUBMITTED.
    --   Creates notification for the first approver.
    -- =========================================================================
    PROCEDURE submit_request (p_request_id NUMBER) IS
        v_req        dt_requests%ROWTYPE;
        v_tmpl_id    dct_approval_templates.template_id%TYPE;
        v_inst_id    dct_approval_instances.instance_id%TYPE;
        v_allow_past VARCHAR2(1) := NVL(get_setting('ALLOW_PAST_TRAVEL_REQUEST'), 'N');
        v_dest_count NUMBER;
    BEGIN
        SELECT * INTO v_req FROM dt_requests WHERE request_id = p_request_id FOR UPDATE;

        IF v_req.status != 'DRAFT' THEN
            RAISE_APPLICATION_ERROR(-20002,
                'Only DRAFT requests can be submitted (current status: ' || v_req.status || ').');
        END IF;

        IF v_allow_past = 'N' AND v_req.departure_date < TRUNC(SYSDATE) THEN
            RAISE_APPLICATION_ERROR(-20003,
                'Departure date is in the past. Enable ALLOW_PAST_TRAVEL_REQUEST to allow backdated submissions.');
        END IF;

        SELECT COUNT(*) INTO v_dest_count
        FROM   dt_destinations WHERE request_id = p_request_id;

        IF v_dest_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20004,
                'At least one destination leg must be added before submission.');
        END IF;

        validate_docs('REQUEST', p_request_id);

        -- Get approval template
        SELECT at.template_id INTO v_tmpl_id
        FROM   dct_approval_templates at
        JOIN   dct_modules            m  ON m.module_id = at.module_id
        WHERE  m.module_code    = 'DUTY_TRAVEL'
        AND    at.template_code = 'DT_REQUEST_APPROVAL'
        AND    at.is_active     = 'Y';

        -- Create approval instance
        INSERT INTO dct_approval_instances (
            template_id, source_module, source_record_id,
            source_record_ref, current_step_seq, overall_status,
            submitted_by, submitted_at, created_by, updated_by)
        VALUES (
            v_tmpl_id, 'DUTY_TRAVEL', p_request_id,
            v_req.request_number, 1, 'PENDING',
            v_req.employee_user_id, SYSTIMESTAMP,
            v_req.created_by, v_req.created_by)
        RETURNING instance_id INTO v_inst_id;

        -- Update request
        UPDATE dt_requests SET
            status               = 'SUBMITTED',
            approval_instance_id = v_inst_id,
            updated_at           = SYSTIMESTAMP
        WHERE request_id = p_request_id;

        -- Notify first approver role
        DECLARE
            v_role_id  dct_roles.role_id%TYPE;
            v_role_code dct_roles.role_code%TYPE;
        BEGIN
            SELECT ast.required_role_id, r.role_code
            INTO   v_role_id, v_role_code
            FROM   dct_approval_steps ast
            JOIN   dct_roles          r ON r.role_id = ast.required_role_id
            WHERE  ast.template_id = v_tmpl_id
            AND    ast.step_seq    = 1;

            -- Send notification to all users with this role
            FOR usr IN (
                SELECT ur.user_id
                FROM   dct_user_roles ur
                WHERE  ur.role_id   = v_role_id
                AND    ur.is_active = 'Y'
                AND   (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
            ) LOOP
                dct_notify.send(
                    p_recipient_user_id => usr.user_id,
                    p_notification_type => 'APPROVAL_REQUEST',
                    p_title_en          => 'Travel Request Pending Approval',
                    p_body_en           => 'Travel request ' || v_req.request_number || ' is awaiting your approval.'
                );
            END LOOP;
        EXCEPTION WHEN OTHERS THEN NULL;  -- notifications are non-critical
        END;

        COMMIT;
    END submit_request;

    -- =========================================================================
    -- CANCEL_REQUEST
    --   Sets status = CANCELLED; only allowed in DRAFT state.
    -- =========================================================================
    PROCEDURE cancel_request (p_request_id NUMBER, p_user_id NUMBER) IS
        v_status dt_requests.status%TYPE;
    BEGIN
        SELECT status INTO v_status FROM dt_requests
        WHERE  request_id = p_request_id FOR UPDATE;

        IF v_status != 'DRAFT' THEN
            RAISE_APPLICATION_ERROR(-20005,
                'Only DRAFT requests can be cancelled (current status: ' || v_status || ').');
        END IF;

        UPDATE dt_requests SET
            status     = 'CANCELLED',
            updated_by = TO_CHAR(p_user_id),
            updated_at = SYSTIMESTAMP
        WHERE request_id = p_request_id;

        COMMIT;
    END cancel_request;

    -- =========================================================================
    -- MARK_ADVANCE_PAID
    --   Finance marks the travel advance as disbursed.
    --   Sets finance_disbursed_yn = Y, disbursed_date, status = ADVANCE_PAID.
    -- =========================================================================
    PROCEDURE mark_advance_paid (p_request_id NUMBER, p_user_id NUMBER) IS
        v_status dt_requests.status%TYPE;
        v_adv_req VARCHAR2(1) := NVL(get_setting('ADVANCE_PAYMENT_REQUIRED'), 'Y');
    BEGIN
        SELECT status INTO v_status FROM dt_requests
        WHERE  request_id = p_request_id FOR UPDATE;

        IF v_status != 'APPROVED' THEN
            RAISE_APPLICATION_ERROR(-20006,
                'Advance can only be marked paid for APPROVED requests (current status: ' || v_status || ').');
        END IF;

        UPDATE dt_requests SET
            finance_disbursed_yn  = 'Y',
            disbursed_date        = SYSDATE,
            disbursed_by_user_id  = p_user_id,
            status                = 'ADVANCE_PAID',
            updated_by            = TO_CHAR(p_user_id),
            updated_at            = SYSTIMESTAMP
        WHERE request_id = p_request_id;

        -- Notify employee
        DECLARE
            v_emp_id   NUMBER;
            v_req_num  VARCHAR2(50);
        BEGIN
            SELECT employee_user_id, request_number INTO v_emp_id, v_req_num
            FROM   dt_requests WHERE request_id = p_request_id;

            dct_notify.send(
                p_recipient_user_id => v_emp_id,
                p_notification_type => 'STATUS_UPDATE',
                p_title_en          => 'Travel Advance Disbursed',
                p_body_en           => 'Your travel advance for request ' || v_req_num || ' has been disbursed. You may proceed with your travel.'
            );
        EXCEPTION WHEN OTHERS THEN NULL;
        END;

        COMMIT;
    END mark_advance_paid;

    -- =========================================================================
    -- CLOSE_REQUEST
    --   Sets status = CLOSED, closed_date = SYSDATE.
    --   Called from:
    --     - Finance Closure Queue (Page 60) when SETTLEMENT_REQUIRED = N or settlement APPROVED.
    --     - Auto-close scheduler.
    --     - On settlement approval (when SETTLEMENT_REQUIRED = Y).
    -- =========================================================================
    PROCEDURE close_request (p_request_id NUMBER, p_user_id NUMBER DEFAULT NULL) IS
        v_status      dt_requests.status%TYPE;
        v_stl_req     VARCHAR2(1) := NVL(get_setting('SETTLEMENT_REQUIRED'), 'Y');
        v_stl_status  VARCHAR2(20);
        v_emp_id      NUMBER;
        v_req_num     VARCHAR2(50);
    BEGIN
        SELECT status, employee_user_id, request_number
        INTO   v_status, v_emp_id, v_req_num
        FROM   dt_requests WHERE request_id = p_request_id FOR UPDATE;

        IF v_status != 'TRAVELLED' THEN
            RAISE_APPLICATION_ERROR(-20007,
                'Only TRAVELLED requests can be closed (current status: ' || v_status || ').');
        END IF;

        -- If settlement is required, validate an approved settlement exists
        IF v_stl_req = 'Y' THEN
            BEGIN
                SELECT status INTO v_stl_status
                FROM   dt_settlement WHERE request_id = p_request_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20008,
                        'Settlement is required before closing this request.');
            END;
            IF v_stl_status != 'APPROVED' THEN
                RAISE_APPLICATION_ERROR(-20009,
                    'Settlement must be APPROVED before the request can be closed (current settlement status: ' || v_stl_status || ').');
            END IF;
        END IF;

        UPDATE dt_requests SET
            status            = 'CLOSED',
            closed_date       = SYSDATE,
            closed_by_user_id = p_user_id,
            updated_by        = TO_CHAR(p_user_id),
            updated_at        = SYSTIMESTAMP
        WHERE request_id = p_request_id;

        -- Notify employee
        BEGIN
            dct_notify.send(
                p_recipient_user_id => v_emp_id,
                p_notification_type => 'STATUS_UPDATE',
                p_title_en          => 'Travel Request Closed',
                p_body_en           => 'Your travel request ' || v_req_num || ' has been closed.'
            );
        EXCEPTION WHEN OTHERS THEN NULL;
        END;

        COMMIT;
    END close_request;

    -- =========================================================================
    -- SET_TRAVELLED_STATUS  (daily scheduler)
    --   Moves ADVANCE_PAID requests past their return_date to TRAVELLED.
    --   If ADVANCE_PAYMENT_REQUIRED = N, also moves APPROVED requests directly.
    --   Sends settlement reminder notification when SETTLEMENT_REQUIRED = Y.
    -- =========================================================================
    PROCEDURE set_travelled_status IS
        v_adv_req VARCHAR2(1) := NVL(get_setting('ADVANCE_PAYMENT_REQUIRED'), 'Y');
        v_stl_req VARCHAR2(1) := NVL(get_setting('SETTLEMENT_REQUIRED'),      'Y');
    BEGIN
        FOR rec IN (
            SELECT request_id, employee_user_id, request_number
            FROM   dt_requests
            WHERE  return_date < TRUNC(SYSDATE)
            AND    status IN (
                'ADVANCE_PAID',
                CASE WHEN v_adv_req = 'N' THEN 'APPROVED' ELSE '~never~' END
            )
        ) LOOP
            UPDATE dt_requests SET
                status     = 'TRAVELLED',
                updated_at = SYSTIMESTAMP
            WHERE request_id = rec.request_id;

            IF v_stl_req = 'Y' THEN
                BEGIN
                    dct_notify.send(
                        p_recipient_user_id => rec.employee_user_id,
                        p_notification_type => 'ACTION_REQUIRED',
                        p_title_en          => 'Settlement Required',
                        p_body_en           => 'You have returned from trip ' || rec.request_number || '. Please submit your expense settlement.'
                    );
                EXCEPTION WHEN OTHERS THEN NULL;
                END;
            END IF;
        END LOOP;

        COMMIT;
    END set_travelled_status;

    -- =========================================================================
    -- AUTO_CLOSE_REQUESTS  (daily scheduler)
    --   Applies only when SETTLEMENT_REQUIRED = N and AUTO_CLOSE_DAYS > 0.
    --   Closes TRAVELLED requests where return_date + AUTO_CLOSE_DAYS < SYSDATE.
    -- =========================================================================
    PROCEDURE auto_close_requests IS
        v_stl_req    VARCHAR2(1) := NVL(get_setting('SETTLEMENT_REQUIRED'), 'Y');
        v_close_days NUMBER      := NVL(TO_NUMBER(get_setting('AUTO_CLOSE_DAYS')), 0);
    BEGIN
        IF v_stl_req = 'Y' OR v_close_days = 0 THEN
            RETURN;  -- auto-close disabled
        END IF;

        FOR rec IN (
            SELECT request_id, employee_user_id, request_number
            FROM   dt_requests
            WHERE  status      = 'TRAVELLED'
            AND    return_date + v_close_days < TRUNC(SYSDATE)
        ) LOOP
            -- close_request handles COMMIT internally
            close_request(rec.request_id, NULL);
        END LOOP;
    END auto_close_requests;

    -- =========================================================================
    -- SEND_SETTLEMENT_ALERTS  (daily scheduler)
    --   Notifies Finance and DT_ADMIN when a settlement is overdue by more than
    --   SETTLEMENT_LATE_ALERT_DAYS days past the SETTLEMENT_DEADLINE_DAYS window.
    -- =========================================================================
    PROCEDURE send_settlement_alerts IS
        v_stl_req      VARCHAR2(1) := NVL(get_setting('SETTLEMENT_REQUIRED'),        'Y');
        v_deadline     NUMBER      := NVL(TO_NUMBER(get_setting('SETTLEMENT_DEADLINE_DAYS')),   7);
        v_alert_days   NUMBER      := NVL(TO_NUMBER(get_setting('SETTLEMENT_LATE_ALERT_DAYS')), 5);
        v_cutoff       DATE        := TRUNC(SYSDATE) - (v_deadline + v_alert_days);
    BEGIN
        IF v_stl_req = 'N' THEN RETURN; END IF;

        FOR req IN (
            SELECT r.request_id, r.request_number, r.return_date,
                   r.employee_user_id, u.display_name AS employee_name
            FROM   dt_requests r
            JOIN   dct_users   u ON u.user_id = r.employee_user_id
            WHERE  r.status     = 'TRAVELLED'
            AND    r.return_date < v_cutoff
            AND    NOT EXISTS (
                SELECT 1 FROM dt_settlement s
                WHERE  s.request_id = r.request_id
                AND    s.status IN ('SUBMITTED','APPROVED')
            )
        ) LOOP
            -- Notify DT_FINANCE and DT_ADMIN role members
            FOR usr IN (
                SELECT DISTINCT ur.user_id
                FROM   dct_user_roles ur
                JOIN   dct_roles      r  ON r.role_id   = ur.role_id
                WHERE  r.role_code IN ('DT_FINANCE','DT_ADMIN')
                AND    ur.is_active  = 'Y'
                AND   (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
            ) LOOP
                BEGIN
                    dct_notify.send(
                        p_recipient_user_id => usr.user_id,
                        p_notification_type => 'ALERT',
                        p_title_en          => 'Settlement Overdue',
                        p_body_en           => req.employee_name || ' has not submitted settlement for request ' ||
                                              req.request_number || ' (returned ' ||
                                              TO_CHAR(req.return_date,'DD-Mon-YYYY') || ').'
                    );
                EXCEPTION WHEN OTHERS THEN NULL;
                END;
            END LOOP;
        END LOOP;

        COMMIT;
    END send_settlement_alerts;

END dct_dt_pkg;
/

-- =============================================================================
-- SCHEDULER JOBS (daily, run at 01:00 AM server time)
-- =============================================================================
BEGIN
    FOR j IN (SELECT owner || '.' || job_name AS full_name
              FROM   all_scheduler_jobs
              WHERE  owner    = 'PROD'
              AND    job_name IN ('JOB_DT_SET_TRAVELLED','JOB_DT_AUTO_CLOSE','JOB_DT_STL_ALERTS'))
    LOOP
        DBMS_SCHEDULER.DROP_JOB(j.full_name, force => TRUE);
    END LOOP;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'JOB_DT_SET_TRAVELLED',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN prod.dct_dt_pkg.set_travelled_status; END;',
        start_date      => TRUNC(SYSDATE + 1) + INTERVAL '1' HOUR,
        repeat_interval => 'FREQ=DAILY;BYHOUR=1;BYMINUTE=0;BYSECOND=0',
        enabled         => TRUE,
        comments        => 'DT: Move ADVANCE_PAID/APPROVED past return_date to TRAVELLED');
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'JOB_DT_AUTO_CLOSE',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN prod.dct_dt_pkg.auto_close_requests; END;',
        start_date      => TRUNC(SYSDATE + 1) + INTERVAL '1' HOUR + INTERVAL '5' MINUTE,
        repeat_interval => 'FREQ=DAILY;BYHOUR=1;BYMINUTE=5;BYSECOND=0',
        enabled         => TRUE,
        comments        => 'DT: Auto-close TRAVELLED requests when SETTLEMENT_REQUIRED=N');
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'JOB_DT_STL_ALERTS',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN prod.dct_dt_pkg.send_settlement_alerts; END;',
        start_date      => TRUNC(SYSDATE + 1) + INTERVAL '1' HOUR + INTERVAL '10' MINUTE,
        repeat_interval => 'FREQ=DAILY;BYHOUR=1;BYMINUTE=10;BYSECOND=0',
        enabled         => TRUE,
        comments        => 'DT: Alert Finance when settlements are overdue');
END;
/

COMMIT;

PROMPT
PROMPT === 04_dct_dt_pkg.sql complete ===
PROMPT Package : DCT_DT_PKG (spec + body)
PROMPT Procs   : generate_request_number, generate_settlement_number
PROMPT          get_rate, calc_per_diem
PROMPT          validate_docs
PROMPT          submit_request, cancel_request
PROMPT          mark_advance_paid, close_request
PROMPT          set_travelled_status, auto_close_requests, send_settlement_alerts
PROMPT Jobs    : JOB_DT_SET_TRAVELLED, JOB_DT_AUTO_CLOSE, JOB_DT_STL_ALERTS
PROMPT ===
