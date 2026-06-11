-- =============================================================================
-- Freelancers Module (App 203) — Business Logic Package
-- File    : 04_fl_pkg.sql
-- Schema  : PROD
-- Run     : After 01_fl_ddl.sql, 02_fl_views.sql, 03_fl_seed.sql
-- =============================================================================
-- Procedures (called from APEX approval callbacks and scheduled jobs):
--
--   CREATE_FREELANCER_PROFILE  — registration approval → creates freelancer +
--                                external DCT_USERS record for portal login
--   GENERATE_PAYMENT_SCHEDULE  — contract approval → generates schedule rows
--   REBUILD_PAYMENT_SCHEDULE   — amendment approval → preserves PAID/SKIPPED,
--                                regenerates PENDING rows with new dates/amounts
--   CREATE_RENEWED_CONTRACT    — renewal approval → new contract + marks
--                                original COMPLETED, auto-generates schedule
--   PUSH_TO_FUSION             — voucher approval → marks schedule as
--                                VOUCHER_GENERATED, stubs Fusion REST call
--   RECEIVE_FUSION_CALLBACK    — Fusion payment confirmed → marks voucher +
--                                schedule PAID
--   APPLY_PROFILE_CHANGE       — profile change approval → updates freelancer
--                                profile fields (EMAIL / PHONE / BANK_ACCOUNT)
--   SEND_EXPIRY_ALERTS         — daily scheduler → sends notifications for
--                                EXPIRING_SOON and EXPIRED documents
--
-- Note on BANK_ACCOUNT profile changes:
--   The APEX form pre-inserts a new DCT_FL_BANK_ACCOUNTS row (is_primary = 'N')
--   and stores its PK in DCT_FL_PROFILE_CHANGE_REQUESTS.requested_value.
--   On approval this procedure promotes it to primary and deactivates the old.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- PACKAGE SPEC
-- =============================================================================
CREATE OR REPLACE PACKAGE prod.dct_fl_pkg AS

    -- Registration approval callback
    PROCEDURE create_freelancer_profile (p_registration_id IN NUMBER);

    -- Contract approval callback
    PROCEDURE generate_payment_schedule (p_contract_id IN NUMBER);

    -- Amendment approval callback
    PROCEDURE rebuild_payment_schedule (p_contract_id IN NUMBER);

    -- Renewal approval callback
    PROCEDURE create_renewed_contract (p_renewal_id IN NUMBER);

    -- Voucher approval callback
    PROCEDURE push_to_fusion (p_voucher_id IN NUMBER);

    -- Fusion payment confirmation (REST callback entry point)
    PROCEDURE receive_fusion_callback (
        p_voucher_id        IN NUMBER,
        p_payment_date      IN DATE,
        p_payment_reference IN VARCHAR2
    );

    -- Profile change approval callback
    PROCEDURE apply_profile_change (p_change_request_id IN NUMBER);

    -- Daily scheduled job — document expiry notifications
    PROCEDURE send_expiry_alerts;

    -- Mirror a contract's header budget coding into the unified
    -- DCT_BUDGET_CODING_LINES (source_module FL, source_type FL_CONTRACT,
    -- line_num 1). Call on contract approval and after renewal creation.
    PROCEDURE mirror_contract_coding (p_contract_id IN NUMBER);

    -- Public helper — read a FREELANCERS module setting value
    FUNCTION get_setting (p_key IN VARCHAR2) RETURN VARCHAR2;

END dct_fl_pkg;
/

-- =============================================================================
-- PACKAGE BODY
-- =============================================================================
CREATE OR REPLACE PACKAGE BODY prod.dct_fl_pkg AS

    -- -------------------------------------------------------------------------
    -- Private: resolve a FREELANCERS module setting value
    -- -------------------------------------------------------------------------
    FUNCTION get_setting (p_key IN VARCHAR2) RETURN VARCHAR2 IS
        v_val VARCHAR2(500);
    BEGIN
        SELECT ms.setting_value
        INTO   v_val
        FROM   prod.dct_module_settings ms
        JOIN   prod.dct_modules          m ON m.module_id = ms.module_id
        WHERE  m.module_code    = 'FREELANCERS'
        AND    ms.setting_key   = p_key;
        RETURN v_val;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
    END get_setting;

    -- =========================================================================
    -- CREATE_FREELANCER_PROFILE
    -- Called from the FL_REGISTRATION_APPROVAL final-approval APEX process.
    -- Creates:
    --   1. DCT_FL_FREELANCERS   — the approved freelancer record
    --   2. DCT_USERS (external) — portal login account (username = lower(email))
    -- Idempotent: silently exits if a DCT_FL_FREELANCERS row already exists for
    -- this registration_id (handles double-click / retry scenarios).
    -- =========================================================================
    PROCEDURE create_freelancer_profile (p_registration_id IN NUMBER) IS
        v_reg       prod.dct_fl_registrations%ROWTYPE;
        v_fl_id     NUMBER;
        v_user_id   NUMBER;
        v_vendor    VARCHAR2(50);
        v_username  VARCHAR2(100);
    BEGIN
        -- Lock the registration row for this transaction
        SELECT * INTO v_reg
        FROM   prod.dct_fl_registrations
        WHERE  registration_id = p_registration_id
        FOR UPDATE NOWAIT;

        -- Idempotency guard
        BEGIN
            SELECT freelancer_id INTO v_fl_id
            FROM   prod.dct_fl_freelancers
            WHERE  registration_id = p_registration_id;
            RETURN;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;

        -- Auto-generate vendor number if configured
        IF NVL(get_setting('AUTO_GENERATE_VENDOR_NUM'), 'Y') = 'Y' THEN
            v_vendor := 'FL-VND-' || TO_CHAR(prod.seq_fl_vendor_number.NEXTVAL, 'FM000000');
        END IF;

        -- Insert freelancer profile
        INSERT INTO prod.dct_fl_freelancers (
            registration_id,   vendor_number,
            first_name_en,     last_name_en,
            first_name_ar,     last_name_ar,
            date_of_birth,     nationality_code,
            national_id,       passport_number,
            email,             mobile,
            specialization,
            photo_mime_type,   photo_filename,    photo_blob,
            status,
            created_by,        created_at,
            updated_by,        updated_at
        ) VALUES (
            p_registration_id, v_vendor,
            v_reg.first_name_en,  v_reg.last_name_en,
            v_reg.first_name_ar,  v_reg.last_name_ar,
            v_reg.date_of_birth,  v_reg.nationality_code,
            v_reg.national_id,    v_reg.passport_number,
            v_reg.email,          v_reg.mobile,
            v_reg.specialization,
            v_reg.photo_mime_type, v_reg.photo_filename, v_reg.photo_blob,
            'ACTIVE',
            'SYSTEM', SYSTIMESTAMP,
            'SYSTEM', SYSTIMESTAMP
        ) RETURNING freelancer_id INTO v_fl_id;

        -- Create external DCT_USERS record for portal login
        -- username = lowercase email; password set separately by admin
        v_username := LOWER(v_reg.email);

        BEGIN
            -- Re-registering freelancer: reactivate existing user record
            UPDATE prod.dct_users
            SET    is_active   = 'Y',
                   display_name = v_reg.first_name_en || ' ' || v_reg.last_name_en,
                   first_name   = v_reg.first_name_en,
                   last_name    = v_reg.last_name_en,
                   updated_by   = 'SYSTEM',
                   updated_at   = SYSTIMESTAMP
            WHERE  username = v_username
            AND    is_external = 'Y';

            IF SQL%ROWCOUNT = 0 THEN
                -- First registration — create new external user
                INSERT INTO prod.dct_users (
                    username,        email,
                    display_name,    first_name,      last_name,
                    auth_method,     is_active,       is_external,
                    created_by,      created_at,
                    updated_by,      updated_at
                ) VALUES (
                    v_username,      v_reg.email,
                    v_reg.first_name_en || ' ' || v_reg.last_name_en,
                    v_reg.first_name_en, v_reg.last_name_en,
                    'DB',            'Y',             'Y',
                    'SYSTEM',        SYSTIMESTAMP,
                    'SYSTEM',        SYSTIMESTAMP
                ) RETURNING user_id INTO v_user_id;
            END IF;
        END;

        -- Mark registration approved
        UPDATE prod.dct_fl_registrations
        SET    status     = 'APPROVED',
               updated_at = SYSTIMESTAMP
        WHERE  registration_id = p_registration_id;

        prod.dct_audit.log(
            p_action      => 'FREELANCER_PROFILE_CREATED',
            p_object_type => 'DCT_FL_FREELANCERS',
            p_object_id   => TO_CHAR(v_fl_id),
            p_object_ref  => v_reg.registration_number,
            p_module_code => 'FREELANCERS'
        );

    EXCEPTION
        WHEN OTHERS THEN
            prod.dct_audit.log(
                p_action      => 'FREELANCER_PROFILE_CREATED',
                p_object_type => 'DCT_FL_FREELANCERS',
                p_object_id   => TO_CHAR(p_registration_id),
                p_module_code => 'FREELANCERS',
                p_status      => 'ERROR',
                p_error_msg   => SQLERRM
            );
            RAISE;
    END create_freelancer_profile;

    -- =========================================================================
    -- GENERATE_PAYMENT_SCHEDULE
    -- Called from contract approval (and internally from CREATE_RENEWED_CONTRACT).
    -- MONTHLY : one row per calendar month, due_date = last day of month
    -- WEEKLY  : one row per ISO week (Mon–Sun), due_date = Sunday of that week
    -- PER_COUNT: no auto-generation — rows added manually via admin UI
    -- Amount per period = billing_unit_amount if set, else total_amount / periods
    -- Idempotent: exits silently if schedule rows already exist for this contract.
    -- =========================================================================
    PROCEDURE generate_payment_schedule (p_contract_id IN NUMBER) IS
        v_con        prod.dct_fl_contracts%ROWTYPE;
        v_cur_date   DATE;
        v_end_date   DATE;
        v_amount     NUMBER(15,2);
        v_period_cnt NUMBER;
        v_existing   NUMBER;
    BEGIN
        SELECT * INTO v_con
        FROM   prod.dct_fl_contracts
        WHERE  contract_id = p_contract_id;

        -- PER_COUNT rows are added manually
        IF v_con.billing_method = 'PER_COUNT' THEN
            RETURN;
        END IF;

        -- Idempotency guard
        SELECT COUNT(*) INTO v_existing
        FROM   prod.dct_fl_payment_schedule
        WHERE  contract_id = p_contract_id;
        IF v_existing > 0 THEN RETURN; END IF;

        -- Default open-ended contracts to 12-month horizon
        v_end_date := NVL(v_con.end_date, ADD_MONTHS(v_con.start_date, 12));

        IF v_con.billing_method = 'MONTHLY' THEN

            IF v_con.billing_unit_amount IS NOT NULL THEN
                v_amount := v_con.billing_unit_amount;
            ELSE
                v_period_cnt := GREATEST(
                    MONTHS_BETWEEN(TRUNC(v_end_date, 'MM'), TRUNC(v_con.start_date, 'MM')) + 1,
                    1
                );
                v_amount := ROUND(v_con.total_amount / v_period_cnt, 2);
            END IF;

            v_cur_date := TRUNC(v_con.start_date, 'MM');
            WHILE v_cur_date <= TRUNC(v_end_date, 'MM') LOOP
                INSERT INTO prod.dct_fl_payment_schedule
                    (contract_id, period_label, due_date, amount, status, created_at, updated_at)
                VALUES
                    (p_contract_id,
                     TRIM(TO_CHAR(v_cur_date, 'Month YYYY')),
                     LAST_DAY(v_cur_date),
                     v_amount,
                     'PENDING',
                     SYSTIMESTAMP, SYSTIMESTAMP);
                v_cur_date := ADD_MONTHS(v_cur_date, 1);
            END LOOP;

        ELSIF v_con.billing_method = 'WEEKLY' THEN

            IF v_con.billing_unit_amount IS NOT NULL THEN
                v_amount := v_con.billing_unit_amount;
            ELSE
                v_cur_date   := TRUNC(v_con.start_date, 'IW');   -- Monday of start week
                v_period_cnt := GREATEST(TRUNC((v_end_date - v_cur_date) / 7) + 1, 1);
                v_amount     := ROUND(v_con.total_amount / v_period_cnt, 2);
            END IF;

            v_cur_date := TRUNC(v_con.start_date, 'IW');
            WHILE v_cur_date <= v_end_date LOOP
                INSERT INTO prod.dct_fl_payment_schedule
                    (contract_id, period_label, due_date, amount, status, created_at, updated_at)
                VALUES
                    (p_contract_id,
                     'Week ' || TO_CHAR(v_cur_date, 'IW') || ' ' || TO_CHAR(v_cur_date, 'YYYY'),
                     v_cur_date + 6,   -- Sunday of that week
                     v_amount,
                     'PENDING',
                     SYSTIMESTAMP, SYSTIMESTAMP);
                v_cur_date := v_cur_date + 7;
            END LOOP;

        END IF;

        prod.dct_audit.log(
            p_action      => 'PAYMENT_SCHEDULE_GENERATED',
            p_object_type => 'DCT_FL_CONTRACTS',
            p_object_id   => TO_CHAR(p_contract_id),
            p_module_code => 'FREELANCERS'
        );

    EXCEPTION
        WHEN OTHERS THEN RAISE;
    END generate_payment_schedule;

    -- =========================================================================
    -- REBUILD_PAYMENT_SCHEDULE
    -- Called from FL_AMENDMENT_APPROVAL final-approval APEX process.
    -- Rules:
    --   • PAID and SKIPPED rows are preserved exactly as-is
    --   • VOUCHER_GENERATED rows are reset to PENDING before deletion
    --     (corresponding vouchers should be cancelled by the APEX process before
    --      calling this procedure — see amendment approval warning in BRD §5.1)
    --   • All PENDING rows are deleted
    --   • New PENDING rows are generated from the first period after the last
    --     PAID/SKIPPED row, using the contract's updated dates and amounts
    --   • Remaining amount = contract.total_amount − SUM(PAID rows)
    -- =========================================================================
    PROCEDURE rebuild_payment_schedule (p_contract_id IN NUMBER) IS
        v_con          prod.dct_fl_contracts%ROWTYPE;
        v_last_paid_dt DATE;
        v_paid_total   NUMBER(15,2) := 0;
        v_remain_amt   NUMBER(15,2);
        v_cur_date     DATE;
        v_end_date     DATE;
        v_amount       NUMBER(15,2);
        v_period_cnt   NUMBER;
    BEGIN
        SELECT * INTO v_con
        FROM   prod.dct_fl_contracts
        WHERE  contract_id = p_contract_id;

        -- PER_COUNT: only delete PENDING rows; manual rows stay
        IF v_con.billing_method = 'PER_COUNT' THEN
            DELETE FROM prod.dct_fl_payment_schedule
            WHERE  contract_id = p_contract_id AND status = 'PENDING';
            RETURN;
        END IF;

        -- Snapshot paid state before making changes
        SELECT MAX(CASE WHEN status IN ('PAID','SKIPPED') THEN due_date END),
               NVL(SUM(CASE WHEN status = 'PAID'         THEN amount   ELSE 0 END), 0)
        INTO   v_last_paid_dt, v_paid_total
        FROM   prod.dct_fl_payment_schedule
        WHERE  contract_id = p_contract_id;

        -- Reset VOUCHER_GENERATED rows back to PENDING so they get deleted below
        UPDATE prod.dct_fl_payment_schedule
        SET    status     = 'PENDING',
               updated_at = SYSTIMESTAMP
        WHERE  contract_id = p_contract_id
        AND    status      = 'VOUCHER_GENERATED';

        -- Delete all PENDING rows
        DELETE FROM prod.dct_fl_payment_schedule
        WHERE  contract_id = p_contract_id
        AND    status      = 'PENDING';

        v_remain_amt := v_con.total_amount - v_paid_total;
        v_end_date   := NVL(v_con.end_date, ADD_MONTHS(v_con.start_date, 12));

        IF v_con.billing_method = 'MONTHLY' THEN

            v_cur_date := CASE
                WHEN v_last_paid_dt IS NOT NULL
                     THEN TRUNC(ADD_MONTHS(v_last_paid_dt, 1), 'MM')
                ELSE TRUNC(v_con.start_date, 'MM')
            END;

            IF v_cur_date > TRUNC(v_end_date, 'MM') THEN RETURN; END IF;

            IF v_con.billing_unit_amount IS NOT NULL THEN
                v_amount := v_con.billing_unit_amount;
            ELSE
                v_period_cnt := GREATEST(
                    MONTHS_BETWEEN(TRUNC(v_end_date, 'MM'), v_cur_date) + 1, 1
                );
                v_amount := ROUND(v_remain_amt / v_period_cnt, 2);
            END IF;

            WHILE v_cur_date <= TRUNC(v_end_date, 'MM') LOOP
                INSERT INTO prod.dct_fl_payment_schedule
                    (contract_id, period_label, due_date, amount, status, created_at, updated_at)
                VALUES
                    (p_contract_id,
                     TRIM(TO_CHAR(v_cur_date, 'Month YYYY')),
                     LAST_DAY(v_cur_date),
                     v_amount, 'PENDING',
                     SYSTIMESTAMP, SYSTIMESTAMP);
                v_cur_date := ADD_MONTHS(v_cur_date, 1);
            END LOOP;

        ELSIF v_con.billing_method = 'WEEKLY' THEN

            v_cur_date := CASE
                WHEN v_last_paid_dt IS NOT NULL
                     THEN TRUNC(v_last_paid_dt + 7, 'IW')
                ELSE TRUNC(v_con.start_date, 'IW')
            END;

            IF v_cur_date > v_end_date THEN RETURN; END IF;

            IF v_con.billing_unit_amount IS NOT NULL THEN
                v_amount := v_con.billing_unit_amount;
            ELSE
                v_period_cnt := GREATEST(TRUNC((v_end_date - v_cur_date) / 7) + 1, 1);
                v_amount     := ROUND(v_remain_amt / v_period_cnt, 2);
            END IF;

            WHILE v_cur_date <= v_end_date LOOP
                INSERT INTO prod.dct_fl_payment_schedule
                    (contract_id, period_label, due_date, amount, status, created_at, updated_at)
                VALUES
                    (p_contract_id,
                     'Week ' || TO_CHAR(v_cur_date, 'IW') || ' ' || TO_CHAR(v_cur_date, 'YYYY'),
                     v_cur_date + 6,
                     v_amount, 'PENDING',
                     SYSTIMESTAMP, SYSTIMESTAMP);
                v_cur_date := v_cur_date + 7;
            END LOOP;

        END IF;

        prod.dct_audit.log(
            p_action      => 'PAYMENT_SCHEDULE_REBUILT',
            p_object_type => 'DCT_FL_CONTRACTS',
            p_object_id   => TO_CHAR(p_contract_id),
            p_module_code => 'FREELANCERS'
        );

    EXCEPTION
        WHEN OTHERS THEN RAISE;
    END rebuild_payment_schedule;

    -- =========================================================================
    -- CREATE_RENEWED_CONTRACT
    -- Called from FL_RENEWAL_APPROVAL final-approval APEX process.
    -- Creates a new DCT_FL_CONTRACTS row linked to the original via
    -- renewed_from_contract_id, sets original to COMPLETED, and optionally
    -- auto-generates the payment schedule for the new contract.
    -- The new contract starts in ACTIVE status (no re-approval needed).
    -- Idempotent: exits silently if new_contract_id is already populated.
    -- =========================================================================
    -- =========================================================================
    -- MIRROR_CONTRACT_CODING
    -- Upserts the contract's header GL/PROJECT coding as line 1 of the unified
    -- DCT_BUDGET_CODING_LINES so cross-module spend reporting has one read
    -- path. The FL forms keep editing the header columns; this mirror runs on
    -- contract approval and inside CREATE_RENEWED_CONTRACT.
    -- =========================================================================
    PROCEDURE mirror_contract_coding (p_contract_id IN NUMBER) IS
        v_con     prod.dct_fl_contracts%ROWTYPE;
        v_user_id NUMBER;
    BEGIN
        SELECT * INTO v_con
        FROM   prod.dct_fl_contracts
        WHERE  contract_id = p_contract_id;

        IF v_con.coding_type IS NULL THEN
            RETURN;   -- contract carries no budget coding yet
        END IF;

        -- Resolve an audit user (unified table requires a dct_users FK)
        BEGIN
            SELECT user_id INTO v_user_id FROM prod.dct_users
            WHERE  username = NVL(v_con.updated_by, 'ADMIN') AND ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            SELECT MIN(user_id) INTO v_user_id FROM prod.dct_users;
        END;

        MERGE INTO prod.dct_budget_coding_lines t
        USING (SELECT 'FL' AS source_module, 'FL_CONTRACT' AS source_type,
                      p_contract_id AS source_id, 1 AS line_num FROM dual) s
        ON (t.source_module = s.source_module AND t.source_type = s.source_type
            AND t.source_id = s.source_id AND t.line_num = s.line_num)
        WHEN NOT MATCHED THEN
            INSERT (source_module, source_type, source_id, line_num, coding_type,
                    cc_id, project_number, task_number, expenditure_type,
                    amount, currency_code, description, created_by)
            VALUES ('FL', 'FL_CONTRACT', p_contract_id, 1, v_con.coding_type,
                    v_con.cc_id_gl, v_con.project_number, v_con.task_number, v_con.expenditure_type,
                    NVL(v_con.total_amount, 0), NVL(v_con.currency_code, 'AED'),
                    'Contract ' || v_con.contract_number || ' header coding', v_user_id)
        WHEN MATCHED THEN
            UPDATE SET t.coding_type      = v_con.coding_type,
                       t.cc_id            = v_con.cc_id_gl,
                       t.project_number   = v_con.project_number,
                       t.task_number      = v_con.task_number,
                       t.expenditure_type = v_con.expenditure_type,
                       t.amount           = NVL(v_con.total_amount, 0),
                       t.currency_code    = NVL(v_con.currency_code, 'AED'),
                       t.updated_by       = v_user_id,
                       t.updated_at       = SYSTIMESTAMP;
    END mirror_contract_coding;

    PROCEDURE create_renewed_contract (p_renewal_id IN NUMBER) IS
        v_rnl      prod.dct_fl_contract_renewals%ROWTYPE;
        v_orig     prod.dct_fl_contracts%ROWTYPE;
        v_new_id   NUMBER;
        v_con_num  VARCHAR2(50);
    BEGIN
        SELECT * INTO v_rnl
        FROM   prod.dct_fl_contract_renewals
        WHERE  renewal_id = p_renewal_id
        FOR UPDATE NOWAIT;

        -- Idempotency guard
        IF v_rnl.new_contract_id IS NOT NULL THEN RETURN; END IF;

        SELECT * INTO v_orig
        FROM   prod.dct_fl_contracts
        WHERE  contract_id = v_rnl.original_contract_id;

        v_con_num := 'FL-CON-' || TO_CHAR(prod.seq_fl_contract_number.NEXTVAL, 'FM000000');

        INSERT INTO prod.dct_fl_contracts (
            contract_number,          version_number,
            freelancer_id,            renewed_from_contract_id,
            title,
            start_date,               end_date,
            total_amount,             currency_code,
            billing_method,           billing_unit_id,      billing_unit_amount,
            org_id,
            coding_type,              cc_id_gl,
            project_number,           task_number,          expenditure_type,
            status,                   notes,
            created_by,               created_at,
            updated_by,               updated_at
        ) VALUES (
            v_con_num,                1,
            v_orig.freelancer_id,     v_orig.contract_id,
            v_orig.title,
            v_rnl.new_start_date,     v_rnl.new_end_date,
            v_rnl.new_total_amount,   v_orig.currency_code,
            NVL(v_rnl.new_billing_method,      v_orig.billing_method),
            NVL(v_rnl.new_billing_unit_id,     v_orig.billing_unit_id),
            NVL(v_rnl.new_billing_unit_amount,  v_orig.billing_unit_amount),
            v_orig.org_id,
            v_rnl.coding_type,        v_rnl.cc_id_gl,
            v_rnl.project_number,     v_rnl.task_number,    v_rnl.expenditure_type,
            'ACTIVE',
            'Renewed from ' || v_orig.contract_number || '. ' || v_rnl.reason,
            'SYSTEM',                 SYSTIMESTAMP,
            'SYSTEM',                 SYSTIMESTAMP
        ) RETURNING contract_id INTO v_new_id;

        -- Write new_contract_id back to the renewal record
        UPDATE prod.dct_fl_contract_renewals
        SET    new_contract_id = v_new_id,
               status          = 'APPROVED',
               updated_at      = SYSTIMESTAMP
        WHERE  renewal_id = p_renewal_id;

        -- Mark original contract completed
        UPDATE prod.dct_fl_contracts
        SET    status     = 'COMPLETED',
               updated_at = SYSTIMESTAMP
        WHERE  contract_id = v_rnl.original_contract_id;

        -- Auto-generate schedule for new contract if configured
        IF NVL(get_setting('AUTO_GENERATE_PAYMENT_SCHEDULE'), 'Y') = 'Y' THEN
            generate_payment_schedule(v_new_id);
        END IF;

        -- Mirror the new contract's coding into the unified coding lines
        mirror_contract_coding(v_new_id);

        prod.dct_audit.log(
            p_action      => 'CONTRACT_RENEWED',
            p_object_type => 'DCT_FL_CONTRACTS',
            p_object_id   => TO_CHAR(v_new_id),
            p_object_ref  => v_con_num,
            p_module_code => 'FREELANCERS'
        );

    EXCEPTION
        WHEN OTHERS THEN
            prod.dct_audit.log(
                p_action      => 'CONTRACT_RENEWED',
                p_object_type => 'DCT_FL_CONTRACT_RENEWALS',
                p_object_id   => TO_CHAR(p_renewal_id),
                p_module_code => 'FREELANCERS',
                p_status      => 'ERROR',
                p_error_msg   => SQLERRM
            );
            RAISE;
    END create_renewed_contract;

    -- =========================================================================
    -- PUSH_TO_FUSION
    -- Called from FL_VOUCHER_APPROVAL final-approval APEX process when
    -- post_to_fusion = 'Y'.  Updates the linked schedule row to
    -- VOUCHER_GENERATED and audits the event.
    --
    -- V1 STUB: The actual Oracle Fusion Payables REST call is out of scope for
    -- this release.  Wire in the REST call here when Fusion integration is ready.
    -- The RECEIVE_FUSION_CALLBACK procedure handles the return webhook.
    -- =========================================================================
    PROCEDURE push_to_fusion (p_voucher_id IN NUMBER) IS
        v_v prod.dct_fl_payment_vouchers%ROWTYPE;
    BEGIN
        SELECT * INTO v_v
        FROM   prod.dct_fl_payment_vouchers
        WHERE  voucher_id = p_voucher_id;

        -- Only act on approved vouchers flagged for Fusion
        IF v_v.status != 'APPROVED' OR NVL(v_v.post_to_fusion, 'N') != 'Y' THEN
            RETURN;
        END IF;

        -- Mark the linked schedule row as VOUCHER_GENERATED
        IF v_v.schedule_id IS NOT NULL THEN
            UPDATE prod.dct_fl_payment_schedule
            SET    status     = 'VOUCHER_GENERATED',
                   voucher_id = p_voucher_id,
                   updated_at = SYSTIMESTAMP
            WHERE  schedule_id = v_v.schedule_id;
        END IF;

        prod.dct_audit.log(
            p_action      => 'VOUCHER_QUEUED_FOR_FUSION',
            p_object_type => 'DCT_FL_PAYMENT_VOUCHERS',
            p_object_id   => TO_CHAR(p_voucher_id),
            p_object_ref  => v_v.voucher_number,
            p_module_code => 'FREELANCERS'
        );

    EXCEPTION
        WHEN OTHERS THEN RAISE;
    END push_to_fusion;

    -- =========================================================================
    -- RECEIVE_FUSION_CALLBACK
    -- Entry point for the Oracle Fusion Payables payment webhook.
    -- Sets payment_status = PAID on the voucher and PAID on the schedule row.
    -- =========================================================================
    PROCEDURE receive_fusion_callback (
        p_voucher_id        IN NUMBER,
        p_payment_date      IN DATE,
        p_payment_reference IN VARCHAR2
    ) IS
        v_schedule_id NUMBER;
        v_voucher_num VARCHAR2(50);
    BEGIN
        UPDATE prod.dct_fl_payment_vouchers
        SET    payment_status    = 'PAID',
               payment_date      = p_payment_date,
               payment_reference = p_payment_reference,
               updated_at        = SYSTIMESTAMP
        WHERE  voucher_id = p_voucher_id
        RETURNING schedule_id, voucher_number
        INTO      v_schedule_id,  v_voucher_num;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20010, 'DCT_FL_PKG: voucher_id ' || p_voucher_id || ' not found.');
        END IF;

        IF v_schedule_id IS NOT NULL THEN
            UPDATE prod.dct_fl_payment_schedule
            SET    status     = 'PAID',
                   updated_at = SYSTIMESTAMP
            WHERE  schedule_id = v_schedule_id;
        END IF;

        prod.dct_audit.log(
            p_action      => 'FUSION_PAYMENT_CONFIRMED',
            p_object_type => 'DCT_FL_PAYMENT_VOUCHERS',
            p_object_id   => TO_CHAR(p_voucher_id),
            p_object_ref  => v_voucher_num,
            p_module_code => 'FREELANCERS'
        );

    EXCEPTION
        WHEN OTHERS THEN RAISE;
    END receive_fusion_callback;

    -- =========================================================================
    -- APPLY_PROFILE_CHANGE
    -- Called from FL_PROFILE_CHANGE_APPROVAL final-approval APEX process.
    --
    -- EMAIL       : Updates DCT_FL_FREELANCERS.email AND DCT_USERS.username +
    --               email (portal login credential changes with email)
    -- PHONE       : Updates DCT_FL_FREELANCERS.mobile
    -- BANK_ACCOUNT: The APEX form pre-inserts a new DCT_FL_BANK_ACCOUNTS row
    --               (is_primary='N', is_active='Y') and stores its PK as a
    --               numeric string in requested_value.  This procedure promotes
    --               it to primary and deactivates the previous primary account.
    -- OTHER       : No automated field update — admin reviews change_request
    --               notes and applies the change manually.
    -- =========================================================================
    PROCEDURE apply_profile_change (p_change_request_id IN NUMBER) IS
        v_cr prod.dct_fl_profile_change_requests%ROWTYPE;
    BEGIN
        SELECT * INTO v_cr
        FROM   prod.dct_fl_profile_change_requests
        WHERE  change_request_id = p_change_request_id
        FOR UPDATE NOWAIT;

        CASE v_cr.change_type

            WHEN 'EMAIL' THEN
                -- Update freelancer profile
                UPDATE prod.dct_fl_freelancers
                SET    email      = v_cr.requested_value,
                       updated_at = SYSTIMESTAMP
                WHERE  freelancer_id = v_cr.freelancer_id;

                -- Update the external DCT_USERS record so portal login still works
                UPDATE prod.dct_users
                SET    email      = v_cr.requested_value,
                       username   = LOWER(v_cr.requested_value),
                       updated_at = SYSTIMESTAMP
                WHERE  username    = (
                           SELECT LOWER(f.email)
                           FROM   prod.dct_fl_freelancers f
                           WHERE  f.freelancer_id = v_cr.freelancer_id
                       )
                AND    is_external = 'Y';

            WHEN 'PHONE' THEN
                UPDATE prod.dct_fl_freelancers
                SET    mobile     = v_cr.requested_value,
                       updated_at = SYSTIMESTAMP
                WHERE  freelancer_id = v_cr.freelancer_id;

            WHEN 'BANK_ACCOUNT' THEN
                -- Demote current primary account
                UPDATE prod.dct_fl_bank_accounts
                SET    is_primary = 'N',
                       updated_at = SYSTIMESTAMP
                WHERE  freelancer_id = v_cr.freelancer_id
                AND    is_primary    = 'Y';

                -- Promote the pre-inserted staging account
                -- requested_value holds the bank_account_id (numeric string)
                UPDATE prod.dct_fl_bank_accounts
                SET    is_primary = 'Y',
                       is_active  = 'Y',
                       updated_at = SYSTIMESTAMP
                WHERE  bank_account_id = TO_NUMBER(v_cr.requested_value)
                AND    freelancer_id   = v_cr.freelancer_id;

                IF SQL%ROWCOUNT = 0 THEN
                    RAISE_APPLICATION_ERROR(-20011,
                        'DCT_FL_PKG: bank_account_id ' || v_cr.requested_value ||
                        ' not found for freelancer_id ' || v_cr.freelancer_id);
                END IF;

            ELSE
                -- OTHER: log intent; admin applies manually
                NULL;

        END CASE;

        -- Mark request applied
        UPDATE prod.dct_fl_profile_change_requests
        SET    status     = 'APPROVED',
               updated_at = SYSTIMESTAMP
        WHERE  change_request_id = p_change_request_id;

        prod.dct_audit.log(
            p_action      => 'PROFILE_CHANGE_APPLIED',
            p_object_type => 'DCT_FL_PROFILE_CHANGE_REQUESTS',
            p_object_id   => TO_CHAR(p_change_request_id),
            p_module_code => 'FREELANCERS'
        );

    EXCEPTION
        WHEN OTHERS THEN RAISE;
    END apply_profile_change;

    -- =========================================================================
    -- SEND_EXPIRY_ALERTS
    -- Intended to run daily via DBMS_SCHEDULER (see job created below).
    -- Scans the unified DCT_DOCUMENTS (source_module = 'FL'; reference_id =
    -- freelancer_id) for ACTIVE documents where:
    --   expiry_date < SYSDATE                           → EXPIRED
    --   expiry_date BETWEEN SYSDATE AND SYSDATE + N     → EXPIRING_SOON
    -- For each qualifying document, notifies all FL_ADMIN users once per day
    -- (skips if an alert of the same type was already sent today for that doc).
    -- Inserts one unified DCT_DOC_EXPIRY_ALERTS row per notification sent.
    -- =========================================================================
    PROCEDURE send_expiry_alerts IS
        v_notified  NUMBER := 0;

        CURSOR c_docs IS
            SELECT
                d.doc_id                                   AS document_id,
                d.reference_id                             AS freelancer_id,
                d.expiry_date,
                d.alert_days_before,
                f.first_name_en || ' ' || f.last_name_en  AS freelancer_name,
                dt.doc_type_name_en                        AS doc_type_name,
                TRUNC(d.expiry_date - SYSDATE)             AS days_remaining,
                CASE
                    WHEN d.expiry_date < SYSDATE THEN 'EXPIRED'
                    ELSE 'EXPIRING_SOON'
                END                                        AS alert_type
            FROM  prod.dct_documents           d
            JOIN  prod.dct_fl_freelancers      f  ON f.freelancer_id = d.reference_id
            LEFT JOIN prod.dct_document_types  dt ON dt.doc_type_id  = d.doc_type_id
            WHERE d.source_module = 'FL'
            AND   d.status      = 'ACTIVE'
            AND   d.is_active   = 'Y'
            AND   d.expiry_date IS NOT NULL
            AND   f.status      = 'ACTIVE'
            AND   (d.expiry_date < SYSDATE
                   OR d.expiry_date <= SYSDATE + NVL(d.alert_days_before, 30))
            -- One alert per document per alert_type per calendar day
            AND NOT EXISTS (
                SELECT 1
                FROM   prod.dct_doc_expiry_alerts a
                WHERE  a.doc_id      = d.doc_id
                AND    a.alert_type  = CASE
                                         WHEN d.expiry_date < SYSDATE THEN 'EXPIRED'
                                         ELSE 'EXPIRING_SOON'
                                       END
                AND    TRUNC(a.sent_at) = TRUNC(SYSTIMESTAMP)
            );

    BEGIN
        FOR rec IN c_docs LOOP
            -- Notify all active FL_ADMIN users
            FOR adm IN (
                SELECT u.user_id
                FROM   prod.dct_users      u
                JOIN   prod.dct_user_roles ur ON ur.user_id = u.user_id
                JOIN   prod.dct_roles       r ON r.role_id  = ur.role_id
                WHERE  r.role_code  = 'FL_ADMIN'
                AND    u.is_active  = 'Y'
                AND    NVL(ur.end_date, SYSDATE + 1) > SYSDATE
            ) LOOP
                prod.dct_notify.send(
                    p_recipient_user_id => adm.user_id,
                    p_notification_type => 'ALERT',
                    p_title_en          => CASE rec.alert_type
                                               WHEN 'EXPIRED'
                                               THEN 'Document Expired — ' || rec.freelancer_name
                                               ELSE 'Document Expiring Soon — ' || rec.freelancer_name
                                           END,
                    p_body_en           => rec.doc_type_name
                                          || ' for ' || rec.freelancer_name
                                          || CASE rec.alert_type
                                                 WHEN 'EXPIRED'
                                                 THEN ' expired on '
                                                      || TO_CHAR(rec.expiry_date, 'DD-Mon-YYYY') || '.'
                                                 ELSE ' expires in ' || rec.days_remaining
                                                      || ' day(s) on '
                                                      || TO_CHAR(rec.expiry_date, 'DD-Mon-YYYY') || '.'
                                             END,
                    p_module_code       => 'FREELANCERS'
                );

                INSERT INTO prod.dct_doc_expiry_alerts
                    (doc_id, alert_type, days_remaining, notified_user_id, sent_at)
                VALUES
                    (rec.document_id, rec.alert_type,
                     rec.days_remaining, adm.user_id, SYSTIMESTAMP);

                v_notified := v_notified + 1;
            END LOOP;
        END LOOP;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('SEND_EXPIRY_ALERTS: ' || v_notified || ' notification(s) sent.');

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            prod.dct_audit.log(
                p_action      => 'SEND_EXPIRY_ALERTS',
                p_module_code => 'FREELANCERS',
                p_status      => 'ERROR',
                p_error_msg   => SQLERRM
            );
            RAISE;
    END send_expiry_alerts;

END dct_fl_pkg;
/

-- =============================================================================
-- DBMS_SCHEDULER JOB — daily document expiry alerts at 06:00 server time
-- =============================================================================
BEGIN
    -- Drop if exists so re-runs are safe
    BEGIN
        DBMS_SCHEDULER.DROP_JOB('PROD.FL_DOC_EXPIRY_ALERTS_JOB', force => TRUE);
    EXCEPTION
        WHEN OTHERS THEN NULL;
    END;

    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => 'PROD.FL_DOC_EXPIRY_ALERTS_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN prod.dct_fl_pkg.send_expiry_alerts; END;',
        start_date      => TRUNC(SYSDATE + 1) + 6/24,   -- tomorrow at 06:00
        repeat_interval => 'FREQ=DAILY;BYHOUR=6;BYMINUTE=0;BYSECOND=0',
        enabled         => TRUE,
        comments        => 'Freelancers module — daily document expiry notification job'
    );
    DBMS_OUTPUT.PUT_LINE('Scheduler job FL_DOC_EXPIRY_ALERTS_JOB created.');
END;
/

PROMPT
PROMPT === 04_fl_pkg.sql complete ===
PROMPT Package: PROD.DCT_FL_PKG (spec + body)
PROMPT Job    : PROD.FL_DOC_EXPIRY_ALERTS_JOB (daily at 06:00)
PROMPT
PROMPT Verify compilation:
PROMPT   SELECT object_name, object_type, status
PROMPT   FROM   all_objects
PROMPT   WHERE  owner = 'PROD' AND object_name = 'DCT_FL_PKG';
PROMPT
