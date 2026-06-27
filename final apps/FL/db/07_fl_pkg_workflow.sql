-- =============================================================================
-- Freelancers Module (App 203) -- Phase 4 Workflow Extension
-- File    : 07_fl_pkg_workflow.sql
-- Schema  : PROD
-- Run     : After 04_fl_pkg.sql (this file fully replaces the package with the
--           original nine procedures preserved verbatim plus the workflow API)
-- Generated from 04_fl_pkg.sql -- edit the generator or 04, then regenerate.
-- =============================================================================

SET DEFINE OFF

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

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

    -- Daily scheduled job â€” document expiry notifications
    PROCEDURE send_expiry_alerts;

    -- Mirror a contract's header budget coding into the unified
    -- DCT_BUDGET_CODING_LINES (source_module FL, source_type FL_CONTRACT,
    -- line_num 1). Call on contract approval and after renewal creation.
    PROCEDURE mirror_contract_coding (p_contract_id IN NUMBER);

    -- Public helper â€” read a FREELANCERS module setting value
    FUNCTION get_setting (p_key IN VARCHAR2) RETURN VARCHAR2;


    -- =========================================================================
    -- Phase 4 workflow extension (07_fl_pkg_workflow.sql)
    -- Submit procedures create DCT_APPROVAL_INSTANCES from the seeded
    -- FL_*_APPROVAL templates; act_on_approval advances/completes instances
    -- and dispatches the per-type final-approval callbacks above.
    -- source_module registry: FL_REGISTRATION, FL_CONTRACT, FL_AMENDMENT,
    -- FL_VOUCHER, FL_RENEWAL, FL_PROFILE_CHANGE.
    -- =========================================================================
    PROCEDURE submit_registration   (p_id IN NUMBER, p_user_id IN NUMBER);
    PROCEDURE submit_contract       (p_id IN NUMBER, p_user_id IN NUMBER);
    PROCEDURE submit_amendment      (p_id IN NUMBER, p_user_id IN NUMBER);
    PROCEDURE submit_voucher        (p_id IN NUMBER, p_user_id IN NUMBER);
    PROCEDURE submit_renewal        (p_id IN NUMBER, p_user_id IN NUMBER);
    PROCEDURE submit_profile_change (p_id IN NUMBER, p_user_id IN NUMBER);

    PROCEDURE act_on_approval (
        p_instance_id IN NUMBER,
        p_user_id     IN NUMBER,
        p_action      IN VARCHAR2,
        p_comments    IN VARCHAR2
    );

END dct_fl_pkg;
/

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
    --   1. DCT_FL_FREELANCERS   â€” the approved freelancer record
    --   2. DCT_USERS (external) â€” portal login account (username = lower(email))
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
                -- First registration â€” create new external user
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

        -- Create the primary bank account from the registration's bank capture
        -- (Phase 1: bank details are collected at registration / AI-extracted).
        IF v_reg.bank_iban IS NOT NULL OR v_reg.bank_account_number IS NOT NULL THEN
            INSERT INTO prod.dct_fl_bank_accounts (
                freelancer_id, bank_name, account_number, iban, account_name,
                currency_code, is_primary, is_active,
                created_by, created_at, updated_by, updated_at
            ) VALUES (
                v_fl_id,
                NVL(v_reg.bank_name, '(unspecified)'),
                NVL(v_reg.bank_account_number, NVL(v_reg.bank_iban, '(unspecified)')),
                v_reg.bank_iban,
                NVL(v_reg.bank_account_name, v_reg.first_name_en || ' ' || v_reg.last_name_en),
                NVL(v_reg.bank_currency_code, 'AED'),
                'Y', 'Y', 'SYSTEM', SYSTIMESTAMP, 'SYSTEM', SYSTIMESTAMP
            );
        END IF;

        -- Carry the registration's uploaded documents over to the new freelancer
        -- so they are not orphaned (FL convention: reference_id = freelancer_id).
        UPDATE prod.dct_documents
        SET    source_type  = 'FREELANCER',
               source_id    = v_fl_id,
               reference_id = v_fl_id,
               updated_at   = SYSTIMESTAMP
        WHERE  source_module = 'FL'
        AND    source_type   = 'REGISTRATION'
        AND    source_id     = p_registration_id;

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
    -- WEEKLY  : one row per ISO week (Monâ€“Sun), due_date = Sunday of that week
    -- PER_COUNT: no auto-generation â€” rows added manually via admin UI
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
    --   â€¢ PAID and SKIPPED rows are preserved exactly as-is
    --   â€¢ VOUCHER_GENERATED rows are reset to PENDING before deletion
    --     (corresponding vouchers should be cancelled by the APEX process before
    --      calling this procedure â€” see amendment approval warning in BRD Â§5.1)
    --   â€¢ All PENDING rows are deleted
    --   â€¢ New PENDING rows are generated from the first period after the last
    --     PAID/SKIPPED row, using the contract's updated dates and amounts
    --   â€¢ Remaining amount = contract.total_amount âˆ’ SUM(PAID rows)
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
    -- OTHER       : No automated field update â€” admin reviews change_request
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
    --   expiry_date < SYSDATE                           â†’ EXPIRED
    --   expiry_date BETWEEN SYSDATE AND SYSDATE + N     â†’ EXPIRING_SOON
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
                                               THEN 'Document Expired â€” ' || rec.freelancer_name
                                               ELSE 'Document Expiring Soon â€” ' || rec.freelancer_name
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


    -- =========================================================================
    -- Phase 4 workflow extension â€” private helpers
    -- =========================================================================
    FUNCTION wf_username_of (p_user_id IN NUMBER) RETURN VARCHAR2 IS
        v VARCHAR2(100);
    BEGIN
        SELECT username INTO v FROM prod.dct_users WHERE user_id = p_user_id;
        RETURN v;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 'UNKNOWN';
    END wf_username_of;

    PROCEDURE wf_log_status (
        p_src_type IN VARCHAR2, p_src_id IN NUMBER,
        p_old IN VARCHAR2, p_new IN VARCHAR2,
        p_user_id IN NUMBER, p_comments IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO prod.dct_request_status_history (
            source_module, source_type, source_id, old_status, new_status,
            changed_by, comments)
        VALUES ('FL', p_src_type, p_src_id, p_old, p_new, p_user_id, p_comments);
    EXCEPTION WHEN OTHERS THEN NULL;
    END wf_log_status;

    PROCEDURE wf_notify_user (
        p_user_id IN NUMBER, p_title IN VARCHAR2, p_body IN VARCHAR2
    ) IS
    BEGIN
        IF p_user_id IS NULL THEN RETURN; END IF;
        prod.dct_notify.send(
            p_recipient_user_id => p_user_id,
            p_notification_type => 'STATUS_UPDATE',
            p_title_en          => p_title,
            p_body_en           => p_body,
            p_module_code       => 'FREELANCERS');
    EXCEPTION WHEN OTHERS THEN NULL;
    END wf_notify_user;

    PROCEDURE wf_notify_step (
        p_template_id IN NUMBER, p_step_seq IN NUMBER,
        p_title IN VARCHAR2, p_body IN VARCHAR2
    ) IS
        v_role_id NUMBER;
    BEGIN
        SELECT required_role_id INTO v_role_id
        FROM   prod.dct_approval_steps
        WHERE  template_id = p_template_id AND step_seq = p_step_seq;
        FOR u IN (
            SELECT ur.user_id FROM prod.dct_user_roles ur
            WHERE  ur.role_id = v_role_id AND ur.is_active = 'Y'
            AND   (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
        ) LOOP
            prod.dct_notify.send(
                p_recipient_user_id => u.user_id,
                p_notification_type => 'APPROVAL_REQUEST',
                p_title_en          => p_title,
                p_body_en           => p_body,
                p_module_code       => 'FREELANCERS');
        END LOOP;
    EXCEPTION WHEN OTHERS THEN NULL;
    END wf_notify_step;

    FUNCTION wf_next_step (
        p_template_id IN NUMBER, p_after_seq IN NUMBER, p_amount IN NUMBER
    ) RETURN NUMBER IS
        v_next NUMBER;
    BEGIN
        SELECT MIN(step_seq) INTO v_next
        FROM   prod.dct_approval_steps
        WHERE  template_id = p_template_id
        AND    step_seq    > p_after_seq
        AND   (condition_type = 'ALWAYS'
               OR (condition_type = 'AMOUNT' AND amount_operator = '>=' AND p_amount >= amount_threshold)
               OR (condition_type = 'AMOUNT' AND amount_operator = '>'  AND p_amount >  amount_threshold)
               OR (condition_type = 'AMOUNT' AND amount_operator = '<=' AND p_amount <= amount_threshold)
               OR (condition_type = 'AMOUNT' AND amount_operator = '<'  AND p_amount <  amount_threshold));
        RETURN v_next;
    END wf_next_step;

    -- Create the approval instance for a submitted FL record and notify
    -- step-1 approvers. Returns the new instance_id.
    FUNCTION wf_create_instance (
        p_request_type IN VARCHAR2,    -- template request_type (REGISTRATION ...)
        p_source_module IN VARCHAR2,   -- FL_REGISTRATION ...
        p_source_id    IN NUMBER,
        p_source_ref   IN VARCHAR2,
        p_user_id      IN NUMBER,
        p_dynamic_approver IN NUMBER DEFAULT NULL  -- per-instance named approver (line manager)
    ) RETURN NUMBER IS
        v_tmpl_id NUMBER;
        v_first   NUMBER;
        v_inst_id NUMBER;
        v_first_type VARCHAR2(20);
        v_uname   VARCHAR2(100) := wf_username_of(p_user_id);
    BEGIN
        SELECT at.template_id INTO v_tmpl_id
        FROM   prod.dct_approval_templates at
        JOIN   prod.dct_modules m ON m.module_id = at.module_id
        WHERE  m.module_code = 'FREELANCERS'
        AND    at.request_type = p_request_type
        AND    at.is_active = 'Y'
        FETCH FIRST 1 ROW ONLY;

        SELECT MIN(step_seq) INTO v_first
        FROM   prod.dct_approval_steps WHERE template_id = v_tmpl_id;

        SELECT step_type INTO v_first_type
        FROM   prod.dct_approval_steps
        WHERE  template_id = v_tmpl_id AND step_seq = v_first;

        INSERT INTO prod.dct_approval_instances (
            template_id, source_module, source_record_id, source_record_ref,
            current_step_seq, overall_status, submitted_by, submitted_at,
            dynamic_approver_user_id, created_by, updated_by)
        VALUES (
            v_tmpl_id, p_source_module, p_source_id, p_source_ref,
            v_first, 'PENDING', p_user_id, SYSTIMESTAMP,
            p_dynamic_approver, v_uname, v_uname)
        RETURNING instance_id INTO v_inst_id;

        -- USER_SPECIFIC first step (e.g. line-manager endorsement) is routed to
        -- the named approver; role-based steps notify the whole role.
        IF v_first_type = 'USER_SPECIFIC' AND p_dynamic_approver IS NOT NULL THEN
            wf_notify_user(p_dynamic_approver, 'Freelancer Approval Pending',
                p_source_ref || ' is awaiting your endorsement.');
        ELSE
            wf_notify_step(v_tmpl_id, v_first,
                'Freelancer Approval Pending',
                p_source_ref || ' is awaiting your approval.');
        END IF;
        RETURN v_inst_id;
    END wf_create_instance;

    -- =========================================================================
    -- SUBMIT_REGISTRATION
    -- =========================================================================
    PROCEDURE submit_registration (p_id IN NUMBER, p_user_id IN NUMBER) IS
        v_reg     prod.dct_fl_registrations%ROWTYPE;
        v_inst    NUMBER;
        v_uname   VARCHAR2(100) := wf_username_of(p_user_id);
        v_missing VARCHAR2(4000);
        v_cnt     NUMBER;
        v_lm_id   NUMBER;
        v_lm_name VARCHAR2(200);
        v_dup     CLOB;
        v_dobj    JSON_OBJECT_T;
        v_has_exact BOOLEAN := FALSE;
        v_fuzzy_n NUMBER := 0;
    BEGIN
        SELECT * INTO v_reg FROM prod.dct_fl_registrations
        WHERE registration_id = p_id FOR UPDATE NOWAIT;

        IF v_reg.status NOT IN ('DRAFT','RETURNED') THEN
            RAISE_APPLICATION_ERROR(-20130,
                'Registration cannot be submitted in status ' || v_reg.status || '.');
        END IF;
        IF v_reg.nationality_code = 'AE'
           AND NVL(get_setting('NATIONAL_ID_REQUIRED_FOR_AE'),'Y') = 'Y'
           AND v_reg.national_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20131, 'Emirates ID is required for UAE nationals.');
        END IF;
        IF NVL(get_setting('PHOTO_REQUIRED'),'Y') = 'Y' AND v_reg.photo_blob IS NULL THEN
            RAISE_APPLICATION_ERROR(-20132, 'A photo is required before submission.');
        END IF;

        -- Format validation (mirrors the JET registrationEdit client checks).
        IF v_reg.date_of_birth IS NULL OR v_reg.date_of_birth > TRUNC(SYSDATE) THEN
            RAISE_APPLICATION_ERROR(-20133, 'Date of birth is missing or in the future.');
        END IF;
        IF MONTHS_BETWEEN(TRUNC(SYSDATE), v_reg.date_of_birth) < 18 * 12 THEN
            RAISE_APPLICATION_ERROR(-20134, 'Freelancer must be at least 18 years old.');
        END IF;
        IF v_reg.email IS NULL
           OR NOT REGEXP_LIKE(v_reg.email, '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$') THEN
            RAISE_APPLICATION_ERROR(-20135, 'A valid email address is required.');
        END IF;
        IF v_reg.national_id IS NOT NULL
           AND NOT REGEXP_LIKE(REGEXP_REPLACE(v_reg.national_id, '[^0-9]', ''), '^784[0-9]{12}$') THEN
            RAISE_APPLICATION_ERROR(-20136, 'Emirates ID must be 15 digits starting with 784.');
        END IF;
        IF v_reg.passport_number IS NOT NULL
           AND NOT REGEXP_LIKE(v_reg.passport_number, '^[A-Za-z0-9]{6,12}$') THEN
            RAISE_APPLICATION_ERROR(-20137, 'Passport number must be 6-12 letters or digits.');
        END IF;
        IF v_reg.national_id IS NULL AND v_reg.passport_number IS NULL THEN
            RAISE_APPLICATION_ERROR(-20138, 'Provide an Emirates ID or a passport number.');
        END IF;
        IF v_reg.mobile IS NOT NULL
           AND NOT REGEXP_LIKE(REGEXP_REPLACE(v_reg.mobile, '[[:space:]()-]', ''), '^\+?[0-9]{7,15}$') THEN
            RAISE_APPLICATION_ERROR(-20139, 'Enter a valid mobile number (7-15 digits, optional leading +).');
        END IF;

        -- Required documents (DCT_DOC_REQUIREMENTS, context REGISTRATION). The set
        -- is data-driven; conditional applicability (Emirates ID only for AE / ID
        -- provided; Residence Visa only for non-AE) is applied here, keyed on code.
        -- A document counts as present only when its file_blob has been uploaded.
        IF NVL(get_setting('DOCS_REQUIRED_FOR_SUBMIT'),'Y') = 'Y' THEN
            FOR req IN (
                SELECT dr.doc_type_id, dt.doc_type_code, dt.doc_type_name_en
                FROM   prod.dct_doc_requirements dr
                JOIN   prod.dct_document_types   dt ON dt.doc_type_id = dr.doc_type_id
                WHERE  dr.source_module = 'FL' AND dr.context_code = 'REGISTRATION'
                AND    dr.is_active = 'Y' AND dr.is_mandatory = 'Y'
                ORDER BY dr.display_seq
            ) LOOP
                IF (req.doc_type_code = 'EMIRATES_ID'
                    AND NVL(v_reg.nationality_code,'X') != 'AE' AND v_reg.national_id IS NULL)
                   OR (req.doc_type_code = 'RESIDENCE_VISA'
                    AND NVL(v_reg.nationality_code,'X') = 'AE') THEN
                    CONTINUE;  -- not applicable to this registration
                END IF;
                SELECT COUNT(*) INTO v_cnt FROM prod.dct_documents
                WHERE  source_module = 'FL' AND source_type = 'REGISTRATION'
                AND    source_id = p_id AND doc_type_id = req.doc_type_id
                AND    is_active = 'Y' AND file_blob IS NOT NULL;
                IF v_cnt = 0 THEN
                    v_missing := v_missing
                              || CASE WHEN v_missing IS NULL THEN NULL ELSE ', ' END
                              || req.doc_type_name_en;
                END IF;
            END LOOP;
            IF v_missing IS NOT NULL THEN
                RAISE_APPLICATION_ERROR(-20142, 'Required document(s) missing: ' || v_missing || '.');
            END IF;
        END IF;

        -- Line manager is the first approver: resolve the email to a DCT user.
        IF v_reg.line_manager_email IS NULL THEN
            RAISE_APPLICATION_ERROR(-20140, 'A line manager email is required before submission.');
        END IF;
        BEGIN
            SELECT user_id, display_name INTO v_lm_id, v_lm_name
            FROM   prod.dct_users
            WHERE  LOWER(email) = LOWER(v_reg.line_manager_email)
            AND    is_active = 'Y'
            FETCH FIRST 1 ROW ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20141,
                'The line manager email (' || v_reg.line_manager_email
                || ') does not match an active DCT user, so they cannot approve.');
        END;

        -- Duplicate detection: block exact matches (unless an admin has overridden),
        -- flag fuzzy matches for reviewer attention.
        v_dup  := prod.dct_fl_reg_pkg.find_duplicates(p_id);
        v_dobj := JSON_OBJECT_T.parse(v_dup);
        BEGIN v_has_exact := v_dobj.get_boolean('hasExact'); EXCEPTION WHEN OTHERS THEN v_has_exact := FALSE; END;
        BEGIN v_fuzzy_n   := v_dobj.get_array('fuzzy').get_size; EXCEPTION WHEN OTHERS THEN v_fuzzy_n := 0; END;

        IF v_has_exact THEN
            IF NVL(v_reg.dup_status,'NONE') = 'OVERRIDDEN' THEN
                NULL;  -- an FL admin explicitly overrode the exact match
            ELSIF NVL(get_setting('DUP_BLOCK_ON_EXACT'),'Y') = 'Y' THEN
                UPDATE prod.dct_fl_registrations
                SET    dup_status = 'REVIEW', dup_match_json = v_dup, updated_at = SYSTIMESTAMP
                WHERE  registration_id = p_id;
                COMMIT;
                RAISE_APPLICATION_ERROR(-20001,
                    'A freelancer with the same Emirates ID / passport / email / IBAN already exists. '
                    || 'An FL administrator must override this duplicate before it can be submitted.');
            END IF;
        END IF;

        IF v_has_exact OR v_fuzzy_n > 0 THEN
            UPDATE prod.dct_fl_registrations
            SET    dup_status = CASE WHEN NVL(dup_status,'NONE') = 'OVERRIDDEN' THEN 'OVERRIDDEN' ELSE 'REVIEW' END,
                   dup_match_json = v_dup, updated_at = SYSTIMESTAMP
            WHERE  registration_id = p_id;
        END IF;

        v_inst := wf_create_instance('REGISTRATION', 'FL_REGISTRATION',
                                     p_id, v_reg.registration_number, p_user_id,
                                     p_dynamic_approver => v_lm_id);

        UPDATE prod.dct_fl_registrations
        SET    status = 'SUBMITTED', approval_instance_id = v_inst,
               line_manager_user_id = v_lm_id,
               line_manager_name = NVL(line_manager_name, v_lm_name),
               updated_by = v_uname, updated_at = SYSTIMESTAMP
        WHERE  registration_id = p_id;

        wf_log_status('FL_REG', p_id, v_reg.status, 'SUBMITTED',
                      p_user_id, 'Registration ' || v_reg.registration_number || ' submitted');
        COMMIT;
    END submit_registration;

    -- =========================================================================
    -- SUBMIT_CONTRACT
    -- =========================================================================
    PROCEDURE submit_contract (p_id IN NUMBER, p_user_id IN NUMBER) IS
        v_con   prod.dct_fl_contracts%ROWTYPE;
        v_inst  NUMBER;
        v_exp   NUMBER;
        v_uname VARCHAR2(100) := wf_username_of(p_user_id);
    BEGIN
        SELECT * INTO v_con FROM prod.dct_fl_contracts
        WHERE contract_id = p_id FOR UPDATE NOWAIT;

        IF v_con.status != 'DRAFT' THEN
            RAISE_APPLICATION_ERROR(-20133,
                'Contract cannot be submitted in status ' || v_con.status || '.');
        END IF;
        IF NVL(get_setting('BLOCK_CONTRACT_ON_EXPIRED_DOC'),'Y') = 'Y' THEN
            SELECT COUNT(*) INTO v_exp
            FROM   prod.dct_documents d
            WHERE  d.source_module = 'FL'
            AND    d.reference_id  = v_con.freelancer_id
            AND    d.status = 'ACTIVE' AND d.is_active = 'Y'
            AND    d.is_required = 'Y'
            AND    d.expiry_date < SYSDATE;
            IF v_exp > 0 THEN
                RAISE_APPLICATION_ERROR(-20134,
                    'The freelancer has ' || v_exp || ' expired required document(s); contract submission is blocked.');
            END IF;
        END IF;

        v_inst := wf_create_instance('CONTRACT', 'FL_CONTRACT',
                                     p_id, v_con.contract_number, p_user_id);

        UPDATE prod.dct_fl_contracts
        SET    status = 'SUBMITTED', approval_instance_id = v_inst,
               updated_by = v_uname, updated_at = SYSTIMESTAMP
        WHERE  contract_id = p_id;

        wf_log_status('FL_CONTRACT', p_id, v_con.status, 'SUBMITTED',
                      p_user_id, 'Contract ' || v_con.contract_number || ' submitted');
        COMMIT;
    END submit_contract;

    -- =========================================================================
    -- SUBMIT_AMENDMENT
    -- =========================================================================
    PROCEDURE submit_amendment (p_id IN NUMBER, p_user_id IN NUMBER) IS
        v_amd   prod.dct_fl_contract_amendments%ROWTYPE;
        v_ref   VARCHAR2(80);
        v_inst  NUMBER;
        v_uname VARCHAR2(100) := wf_username_of(p_user_id);
    BEGIN
        SELECT * INTO v_amd FROM prod.dct_fl_contract_amendments
        WHERE amendment_id = p_id FOR UPDATE NOWAIT;

        IF v_amd.status != 'DRAFT' THEN
            RAISE_APPLICATION_ERROR(-20135,
                'Amendment cannot be submitted in status ' || v_amd.status || '.');
        END IF;

        SELECT c.contract_number || ' / AMD-' || v_amd.amendment_number INTO v_ref
        FROM   prod.dct_fl_contracts c WHERE c.contract_id = v_amd.contract_id;

        v_inst := wf_create_instance('AMENDMENT', 'FL_AMENDMENT', p_id, v_ref, p_user_id);

        UPDATE prod.dct_fl_contract_amendments
        SET    status = 'SUBMITTED', approval_instance_id = v_inst,
               updated_by = v_uname, updated_at = SYSTIMESTAMP
        WHERE  amendment_id = p_id;

        wf_log_status('FL_AMENDMENT', p_id, v_amd.status, 'SUBMITTED',
                      p_user_id, 'Amendment ' || v_ref || ' submitted');
        COMMIT;
    END submit_amendment;

    -- =========================================================================
    -- SUBMIT_VOUCHER
    -- =========================================================================
    PROCEDURE submit_voucher (p_id IN NUMBER, p_user_id IN NUMBER) IS
        v_v     prod.dct_fl_payment_vouchers%ROWTYPE;
        v_inst  NUMBER;
        v_exp   NUMBER;
        v_acc   NUMBER;
        v_uname VARCHAR2(100) := wf_username_of(p_user_id);
    BEGIN
        SELECT * INTO v_v FROM prod.dct_fl_payment_vouchers
        WHERE voucher_id = p_id FOR UPDATE NOWAIT;

        IF v_v.status != 'DRAFT' THEN
            RAISE_APPLICATION_ERROR(-20136,
                'Voucher cannot be submitted in status ' || v_v.status || '.');
        END IF;
        IF NVL(get_setting('VOUCHER_REQUIRE_INVOICE'),'Y') = 'Y'
           AND (v_v.invoice_number IS NULL OR v_v.invoice_date IS NULL) THEN
            RAISE_APPLICATION_ERROR(-20137, 'Invoice number and date are required before submission.');
        END IF;
        IF NVL(get_setting('BLOCK_VOUCHER_ON_EXPIRED_DOC'),'N') = 'Y' THEN
            SELECT COUNT(*) INTO v_exp
            FROM   prod.dct_documents d
            WHERE  d.source_module = 'FL' AND d.reference_id = v_v.freelancer_id
            AND    d.status = 'ACTIVE' AND d.is_active = 'Y'
            AND    d.is_required = 'Y' AND d.expiry_date < SYSDATE;
            IF v_exp > 0 THEN
                RAISE_APPLICATION_ERROR(-20138,
                    'The freelancer has expired required document(s); voucher submission is blocked.');
            END IF;
        END IF;
        IF NVL(get_setting('VOUCHER_REQUIRE_ACCEPTED_DELIVERABLE'),'N') = 'Y'
           AND v_v.schedule_id IS NOT NULL THEN
            SELECT COUNT(*) INTO v_acc
            FROM   prod.dct_fl_deliverables
            WHERE  schedule_id = v_v.schedule_id AND status = 'ACCEPTED';
            IF v_acc = 0 THEN
                RAISE_APPLICATION_ERROR(-20139,
                    'An ACCEPTED deliverable is required for this payment period before submission.');
            END IF;
        END IF;

        v_inst := wf_create_instance('VOUCHER', 'FL_VOUCHER',
                                     p_id, v_v.voucher_number, p_user_id);

        UPDATE prod.dct_fl_payment_vouchers
        SET    status = 'SUBMITTED', approval_instance_id = v_inst,
               updated_by = v_uname, updated_at = SYSTIMESTAMP
        WHERE  voucher_id = p_id;

        wf_log_status('FL_VOUCHER', p_id, v_v.status, 'SUBMITTED',
                      p_user_id, 'Voucher ' || v_v.voucher_number || ' submitted');
        COMMIT;
    END submit_voucher;

    -- =========================================================================
    -- SUBMIT_RENEWAL
    -- =========================================================================
    PROCEDURE submit_renewal (p_id IN NUMBER, p_user_id IN NUMBER) IS
        v_rnl   prod.dct_fl_contract_renewals%ROWTYPE;
        v_inst  NUMBER;
        v_uname VARCHAR2(100) := wf_username_of(p_user_id);
    BEGIN
        SELECT * INTO v_rnl FROM prod.dct_fl_contract_renewals
        WHERE renewal_id = p_id FOR UPDATE NOWAIT;

        IF v_rnl.status != 'DRAFT' THEN
            RAISE_APPLICATION_ERROR(-20140,
                'Renewal cannot be submitted in status ' || v_rnl.status || '.');
        END IF;

        v_inst := wf_create_instance('RENEWAL', 'FL_RENEWAL',
                                     p_id, v_rnl.renewal_number, p_user_id);

        UPDATE prod.dct_fl_contract_renewals
        SET    status = 'SUBMITTED', approval_instance_id = v_inst,
               updated_by = v_uname, updated_at = SYSTIMESTAMP
        WHERE  renewal_id = p_id;

        wf_log_status('FL_RENEWAL', p_id, v_rnl.status, 'SUBMITTED',
                      p_user_id, 'Renewal ' || v_rnl.renewal_number || ' submitted');
        COMMIT;
    END submit_renewal;

    -- =========================================================================
    -- SUBMIT_PROFILE_CHANGE
    -- =========================================================================
    PROCEDURE submit_profile_change (p_id IN NUMBER, p_user_id IN NUMBER) IS
        v_cr    prod.dct_fl_profile_change_requests%ROWTYPE;
        v_ref   VARCHAR2(80);
        v_inst  NUMBER;
        v_uname VARCHAR2(100) := wf_username_of(p_user_id);
    BEGIN
        IF NVL(get_setting('ALLOW_PROFILE_CHANGE_REQUEST'),'Y') != 'Y' THEN
            RAISE_APPLICATION_ERROR(-20141, 'Profile change requests are disabled.');
        END IF;

        SELECT * INTO v_cr FROM prod.dct_fl_profile_change_requests
        WHERE change_request_id = p_id FOR UPDATE NOWAIT;

        IF v_cr.status != 'DRAFT' THEN
            RAISE_APPLICATION_ERROR(-20142,
                'Change request cannot be submitted in status ' || v_cr.status || '.');
        END IF;

        v_ref := 'PCR-' || p_id || ' (' || v_cr.change_type || ')';
        v_inst := wf_create_instance('PROFILE_CHANGE', 'FL_PROFILE_CHANGE',
                                     p_id, v_ref, p_user_id);

        UPDATE prod.dct_fl_profile_change_requests
        SET    status = 'SUBMITTED', approval_instance_id = v_inst,
               updated_by = v_uname, updated_at = SYSTIMESTAMP
        WHERE  change_request_id = p_id;

        wf_log_status('FL_PCR', p_id, v_cr.status, 'SUBMITTED',
                      p_user_id, 'Profile change ' || v_ref || ' submitted');
        COMMIT;
    END submit_profile_change;

    -- =========================================================================
    -- ACT_ON_APPROVAL â€” advance/complete an FL approval instance and dispatch
    -- the per-type final-approval callbacks. Mirrors DCT_CC_PKG.act_on_approval.
    -- =========================================================================
    PROCEDURE act_on_approval (
        p_instance_id IN NUMBER,
        p_user_id     IN NUMBER,
        p_action      IN VARCHAR2,
        p_comments    IN VARCHAR2
    ) IS
        v_inst     prod.dct_approval_instances%ROWTYPE;
        v_step_id  NUMBER;
        v_amount   NUMBER := 0;
        v_next     NUMBER;
        v_action   VARCHAR2(20) := UPPER(p_action);
        v_uname    VARCHAR2(100) := wf_username_of(p_user_id);
        v_owner    NUMBER;
        v_src_type VARCHAR2(30);
        v_old      VARCHAR2(30);
        v_rej_st   VARCHAR2(20);
        v_ret_st   VARCHAR2(20);
    BEGIN
        IF v_action NOT IN ('APPROVED','REJECTED','RETURNED') THEN
            RAISE_APPLICATION_ERROR(-20143, 'Invalid action. Use APPROVED, REJECTED, or RETURNED.');
        END IF;
        IF p_comments IS NULL THEN
            RAISE_APPLICATION_ERROR(-20144, 'Comments are required.');
        END IF;

        SELECT * INTO v_inst FROM prod.dct_approval_instances
        WHERE instance_id = p_instance_id FOR UPDATE NOWAIT;

        IF v_inst.overall_status != 'PENDING' THEN
            RAISE_APPLICATION_ERROR(-20145, 'Approval instance is not PENDING.');
        END IF;
        IF v_inst.source_module NOT IN ('FL_REGISTRATION','FL_CONTRACT','FL_AMENDMENT',
                                        'FL_VOUCHER','FL_RENEWAL','FL_PROFILE_CHANGE') THEN
            RAISE_APPLICATION_ERROR(-20146, 'Instance does not belong to the Freelancers module.');
        END IF;

        SELECT step_id INTO v_step_id
        FROM   prod.dct_approval_steps
        WHERE  template_id = v_inst.template_id AND step_seq = v_inst.current_step_seq;

        -- per-module facts: history type, owner, amount, current + fallback statuses
        v_owner := v_inst.submitted_by;
        CASE v_inst.source_module
          WHEN 'FL_REGISTRATION' THEN
            v_src_type := 'FL_REG'; v_rej_st := 'REJECTED'; v_ret_st := 'RETURNED';
            SELECT status INTO v_old FROM prod.dct_fl_registrations WHERE registration_id = v_inst.source_record_id;
          WHEN 'FL_CONTRACT' THEN
            v_src_type := 'FL_CONTRACT'; v_rej_st := 'CANCELLED'; v_ret_st := 'DRAFT';
            SELECT status, NVL(total_amount,0) INTO v_old, v_amount
            FROM prod.dct_fl_contracts WHERE contract_id = v_inst.source_record_id;
          WHEN 'FL_AMENDMENT' THEN
            v_src_type := 'FL_AMENDMENT'; v_rej_st := 'REJECTED'; v_ret_st := 'DRAFT';
            SELECT status, NVL(new_total_amount,0) INTO v_old, v_amount
            FROM prod.dct_fl_contract_amendments WHERE amendment_id = v_inst.source_record_id;
          WHEN 'FL_VOUCHER' THEN
            v_src_type := 'FL_VOUCHER'; v_rej_st := 'REJECTED'; v_ret_st := 'DRAFT';
            SELECT status, NVL(amount,0) INTO v_old, v_amount
            FROM prod.dct_fl_payment_vouchers WHERE voucher_id = v_inst.source_record_id;
          WHEN 'FL_RENEWAL' THEN
            v_src_type := 'FL_RENEWAL'; v_rej_st := 'REJECTED'; v_ret_st := 'DRAFT';
            SELECT status, NVL(new_total_amount,0) INTO v_old, v_amount
            FROM prod.dct_fl_contract_renewals WHERE renewal_id = v_inst.source_record_id;
          WHEN 'FL_PROFILE_CHANGE' THEN
            v_src_type := 'FL_PCR'; v_rej_st := 'REJECTED'; v_ret_st := 'DRAFT';
            SELECT status INTO v_old FROM prod.dct_fl_profile_change_requests WHERE change_request_id = v_inst.source_record_id;
        END CASE;

        INSERT INTO prod.dct_approval_actions (instance_id, step_id, actioned_by, action, comments)
        VALUES (p_instance_id, v_step_id, p_user_id, v_action, p_comments);

        IF v_action = 'APPROVED' THEN
            v_next := wf_next_step(v_inst.template_id, v_inst.current_step_seq, v_amount);

            IF v_next IS NOT NULL THEN
                UPDATE prod.dct_approval_instances SET
                    current_step_seq = v_next, last_action_at = SYSTIMESTAMP,
                    updated_by = v_uname, updated_at = SYSTIMESTAMP
                WHERE instance_id = p_instance_id;

                wf_log_status(v_src_type, v_inst.source_record_id, v_old, v_old,
                              p_user_id, 'Step approved; moved to next approval step: ' || p_comments);
                wf_notify_step(v_inst.template_id, v_next,
                    'Freelancer Approval Pending',
                    v_inst.source_record_ref || ' is awaiting your approval (next step).');
            ELSE
                -- FINAL APPROVAL
                UPDATE prod.dct_approval_instances SET
                    overall_status = 'APPROVED', current_step_seq = NULL,
                    completed_at = SYSTIMESTAMP, last_action_at = SYSTIMESTAMP,
                    updated_by = v_uname, updated_at = SYSTIMESTAMP
                WHERE instance_id = p_instance_id;

                CASE v_inst.source_module
                  WHEN 'FL_REGISTRATION' THEN
                    -- callback sets registration APPROVED + creates freelancer & portal user
                    create_freelancer_profile(v_inst.source_record_id);
                    wf_log_status(v_src_type, v_inst.source_record_id, v_old, 'APPROVED', p_user_id, p_comments);

                  WHEN 'FL_CONTRACT' THEN
                    UPDATE prod.dct_fl_contracts
                    SET status = 'ACTIVE', updated_by = v_uname, updated_at = SYSTIMESTAMP
                    WHERE contract_id = v_inst.source_record_id;
                    mirror_contract_coding(v_inst.source_record_id);
                    IF NVL(get_setting('AUTO_GENERATE_PAYMENT_SCHEDULE'),'Y') = 'Y' THEN
                        generate_payment_schedule(v_inst.source_record_id);
                    END IF;
                    wf_log_status(v_src_type, v_inst.source_record_id, v_old, 'ACTIVE', p_user_id, p_comments);

                  WHEN 'FL_AMENDMENT' THEN
                    DECLARE
                        v_amd prod.dct_fl_contract_amendments%ROWTYPE;
                    BEGIN
                        SELECT * INTO v_amd FROM prod.dct_fl_contract_amendments
                        WHERE amendment_id = v_inst.source_record_id;
                        UPDATE prod.dct_fl_contracts SET
                            total_amount   = NVL(v_amd.new_total_amount, total_amount),
                            start_date     = NVL(v_amd.new_start_date,   start_date),
                            end_date       = NVL(v_amd.new_end_date,     end_date),
                            billing_method = NVL(v_amd.new_billing_method, billing_method),
                            version_number = version_number + 1,
                            updated_by     = v_uname, updated_at = SYSTIMESTAMP
                        WHERE contract_id = v_amd.contract_id;
                        UPDATE prod.dct_fl_contract_amendments
                        SET status = 'APPROVED', updated_by = v_uname, updated_at = SYSTIMESTAMP
                        WHERE amendment_id = v_inst.source_record_id;
                        rebuild_payment_schedule(v_amd.contract_id);
                    END;
                    wf_log_status(v_src_type, v_inst.source_record_id, v_old, 'APPROVED', p_user_id, p_comments);

                  WHEN 'FL_VOUCHER' THEN
                    -- status first: push_to_fusion requires APPROVED
                    UPDATE prod.dct_fl_payment_vouchers
                    SET status = 'APPROVED', updated_by = v_uname, updated_at = SYSTIMESTAMP
                    WHERE voucher_id = v_inst.source_record_id;
                    push_to_fusion(v_inst.source_record_id);
                    -- mark the linked schedule row even when not posting to Fusion
                    UPDATE prod.dct_fl_payment_schedule s
                    SET    s.status = 'VOUCHER_GENERATED',
                           s.voucher_id = v_inst.source_record_id,
                           s.updated_at = SYSTIMESTAMP
                    WHERE  s.schedule_id = (SELECT schedule_id FROM prod.dct_fl_payment_vouchers
                                            WHERE voucher_id = v_inst.source_record_id)
                    AND    s.status = 'PENDING';
                    wf_log_status(v_src_type, v_inst.source_record_id, v_old, 'APPROVED', p_user_id, p_comments);

                  WHEN 'FL_RENEWAL' THEN
                    -- callback sets renewal APPROVED, creates the new contract,
                    -- completes the original and generates the new schedule
                    create_renewed_contract(v_inst.source_record_id);
                    wf_log_status(v_src_type, v_inst.source_record_id, v_old, 'APPROVED', p_user_id, p_comments);

                  WHEN 'FL_PROFILE_CHANGE' THEN
                    apply_profile_change(v_inst.source_record_id);
                    wf_log_status(v_src_type, v_inst.source_record_id, v_old, 'APPROVED', p_user_id, p_comments);
                END CASE;

                wf_notify_user(v_owner, 'Request Approved',
                    'Your request ' || v_inst.source_record_ref || ' has been fully approved.');
            END IF;

        ELSE
            -- REJECTED / RETURNED
            UPDATE prod.dct_approval_instances SET
                overall_status = v_action, current_step_seq = NULL,
                completed_at = SYSTIMESTAMP, last_action_at = SYSTIMESTAMP,
                updated_by = v_uname, updated_at = SYSTIMESTAMP
            WHERE instance_id = p_instance_id;

            DECLARE
                v_new VARCHAR2(20) := CASE v_action WHEN 'REJECTED' THEN v_rej_st ELSE v_ret_st END;
            BEGIN
                CASE v_inst.source_module
                  WHEN 'FL_REGISTRATION' THEN
                    UPDATE prod.dct_fl_registrations SET status = v_new,
                        updated_by = v_uname, updated_at = SYSTIMESTAMP
                    WHERE registration_id = v_inst.source_record_id;
                  WHEN 'FL_CONTRACT' THEN
                    UPDATE prod.dct_fl_contracts SET status = v_new,
                        updated_by = v_uname, updated_at = SYSTIMESTAMP
                    WHERE contract_id = v_inst.source_record_id;
                  WHEN 'FL_AMENDMENT' THEN
                    UPDATE prod.dct_fl_contract_amendments SET status = v_new,
                        updated_by = v_uname, updated_at = SYSTIMESTAMP
                    WHERE amendment_id = v_inst.source_record_id;
                  WHEN 'FL_VOUCHER' THEN
                    UPDATE prod.dct_fl_payment_vouchers SET status = v_new,
                        updated_by = v_uname, updated_at = SYSTIMESTAMP
                    WHERE voucher_id = v_inst.source_record_id;
                  WHEN 'FL_RENEWAL' THEN
                    UPDATE prod.dct_fl_contract_renewals SET status = v_new,
                        updated_by = v_uname, updated_at = SYSTIMESTAMP
                    WHERE renewal_id = v_inst.source_record_id;
                  WHEN 'FL_PROFILE_CHANGE' THEN
                    UPDATE prod.dct_fl_profile_change_requests SET status = v_new,
                        updated_by = v_uname, updated_at = SYSTIMESTAMP
                    WHERE change_request_id = v_inst.source_record_id;
                END CASE;

                wf_log_status(v_src_type, v_inst.source_record_id, v_old, v_new,
                              p_user_id, v_action || ': ' || p_comments);
            END;

            wf_notify_user(v_owner, 'Request ' || INITCAP(v_action),
                'Your request ' || v_inst.source_record_ref || ' was ' ||
                LOWER(v_action) || ': ' || p_comments);
        END IF;

        COMMIT;
    END act_on_approval;

END dct_fl_pkg;
/


SHOW ERRORS PACKAGE prod.dct_fl_pkg
SHOW ERRORS PACKAGE BODY prod.dct_fl_pkg

PROMPT === 07_fl_pkg_workflow.sql complete ===
