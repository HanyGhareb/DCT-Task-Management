SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
-- =============================================================================
-- Procash Transactions - business logic
-- File   : 09_procash_pkg.sql        App 212 / AP        2026-08-17
-- Schema : PROD
-- Run    : own SQLcl session
-- -----------------------------------------------------------------------------
-- DCT_AP_PROCASH_PKG owns every validated write to dct_ap_procash and
-- dct_ap_procash_line. Handlers stay thin: they parse, call, and emit.
--
-- Error contract: -20401 auth, -20403 forbidden, -20404 not found,
-- -20001 validation (plus -20090 from dct_lookup_pkg).
--
-- Budget coding is NOT validated against the masters (user decision
-- 2026-08-17): the form offers the real projects, tasks, expenditure types, GL
-- combinations and suppliers in dropdowns, but whatever reaches this package --
-- from the API or the Excel add-in, which bypass the form -- is stored as
-- typed. What is still enforced is COMPLETENESS: a project line needs all
-- three parts, a GL line needs a combination, and neither may be zero-amount.
--
-- Partial updates: save_header writes EVERY field it is given. A PUT handler
-- must read the stored row first and only override what the body carries
-- (apex_json.does_exist), otherwise an absent key blanks a stored value.
--
-- Lifecycle: DRAFT - SUBMITTED - PROCESSED - INVOICED, with IN_APPROVAL and
-- APPROVED inserted when the AP module setting PROCASH_APPROVAL_MODE is
-- WORKFLOW. The workflow hooks at the end carry the engine signature
-- (instance, module, record, user) and are registered by the P4 script.
-- =============================================================================

CREATE OR REPLACE PACKAGE prod.dct_ap_procash_pkg AS

    c_module    CONSTANT VARCHAR2(10) := 'AP';
    c_src_type  CONSTANT VARCHAR2(30) := 'PROCASH';
    c_wf_module CONSTANT VARCHAR2(30) := 'AP_PROCASH';

    FUNCTION  user_id_of          (p_user VARCHAR2) RETURN NUMBER;
    FUNCTION  is_admin     (p_user VARCHAR2) RETURN BOOLEAN;
    FUNCTION  is_processor (p_user VARCHAR2) RETURN BOOLEAN;
    FUNCTION  setting      (p_key VARCHAR2, p_default VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;
    FUNCTION  next_number  RETURN VARCHAR2;
    FUNCTION  default_rate (p_currency VARCHAR2) RETURN NUMBER;
    FUNCTION  line_total   (p_procash_id NUMBER) RETURN NUMBER;
    FUNCTION  doc_count    (p_procash_id NUMBER) RETURN NUMBER;
    FUNCTION  can_edit     (p_procash_id NUMBER, p_user VARCHAR2) RETURN VARCHAR2;
    FUNCTION  findings     (p_procash_id NUMBER) RETURN CLOB;

    PROCEDURE save_header (
        p_user            IN  VARCHAR2,
        p_procash_id      IN  NUMBER,
        p_bank_reference  IN  VARCHAR2,
        p_bank_account    IN  VARCHAR2,
        p_business_unit   IN  VARCHAR2,
        p_supplier_number IN  VARCHAR2,
        p_supplier_name   IN  VARCHAR2,
        p_payee_name      IN  VARCHAR2,
        p_amount          IN  NUMBER,
        p_currency_code   IN  VARCHAR2,
        p_exchange_rate   IN  NUMBER,
        p_payment_date    IN  DATE,
        p_description     IN  VARCHAR2,
        p_comments        IN  VARCHAR2,
        o_procash_id      OUT NUMBER);

    PROCEDURE delete_header (p_user VARCHAR2, p_procash_id NUMBER);

    PROCEDURE save_line (
        p_user             IN  VARCHAR2,
        p_line_id          IN  NUMBER,
        p_procash_id       IN  NUMBER,
        p_coding_basis     IN  VARCHAR2,
        p_project_number   IN  VARCHAR2,
        p_task_number      IN  VARCHAR2,
        p_expenditure_type IN  VARCHAR2,
        p_gl_combination   IN  VARCHAR2,
        p_amount           IN  NUMBER,
        p_comments         IN  VARCHAR2,
        o_line_id          OUT NUMBER);

    PROCEDURE delete_line (p_user VARCHAR2, p_line_id NUMBER);

    PROCEDURE submit         (p_user VARCHAR2, p_procash_id NUMBER, p_comments VARCHAR2 DEFAULT NULL);
    PROCEDURE mark_processed (p_user VARCHAR2, p_procash_id NUMBER, p_comments VARCHAR2 DEFAULT NULL);
    PROCEDURE cancel         (p_user VARCHAR2, p_procash_id NUMBER, p_comments VARCHAR2 DEFAULT NULL);

    PROCEDURE link_invoice   (p_user VARCHAR2, p_procash_id NUMBER,
                              p_invoice_id NUMBER DEFAULT NULL, p_invoice_number VARCHAR2 DEFAULT NULL);
    PROCEDURE unlink_invoice (p_user VARCHAR2, p_procash_id NUMBER);

    PROCEDURE add_doc (p_user VARCHAR2, p_procash_id NUMBER, p_doc_type_code VARCHAR2,
                       p_file_name VARCHAR2, p_mime VARCHAR2, p_blob BLOB, o_doc_id OUT NUMBER);

    PROCEDURE bulk_upsert (p_user VARCHAR2, p_payload CLOB, o_result OUT CLOB);

    PROCEDURE wf_approved (p_instance_id NUMBER, p_module VARCHAR2, p_record_id NUMBER, p_user_id NUMBER);
    PROCEDURE wf_rejected (p_instance_id NUMBER, p_module VARCHAR2, p_record_id NUMBER, p_user_id NUMBER);
    PROCEDURE wf_returned (p_instance_id NUMBER, p_module VARCHAR2, p_record_id NUMBER, p_user_id NUMBER);

END dct_ap_procash_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_ap_procash_pkg AS

    -- ------------------------------------------------------------- helpers

    FUNCTION user_id_of (p_user VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT user_id INTO v_id FROM prod.dct_users WHERE UPPER(username) = UPPER(p_user);
        RETURN v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        raise_application_error(-20401, 'Unknown user: ' || p_user);
    END user_id_of;

    FUNCTION is_admin (p_user VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN prod.dct_auth.has_role(p_user, 'PROCASH_ADMIN')
            OR prod.dct_auth.has_role(p_user, 'SYS_ADMIN');
    END is_admin;

    FUNCTION is_processor (p_user VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN is_admin(p_user) OR prod.dct_auth.has_role(p_user, 'PROCASH_PROCESSOR');
    END is_processor;

    FUNCTION setting (p_key VARCHAR2, p_default VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
        v_val prod.dct_module_settings.setting_value%TYPE;
    BEGIN
        SELECT setting_value INTO v_val
          FROM prod.dct_module_settings
         WHERE module_id = 121 AND setting_key = p_key;
        RETURN NVL(v_val, p_default);
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN p_default;
    END setting;

    FUNCTION next_number RETURN VARCHAR2 IS
        v_seq NUMBER;
    BEGIN
        SELECT prod.dct_ap_procash_num_seq.NEXTVAL INTO v_seq FROM dual;
        RETURN setting('PROCASH_NUMBER_PREFIX', 'PCH-') || LPAD(TO_CHAR(v_seq), 5, '0');
    END next_number;

    FUNCTION default_rate (p_currency VARCHAR2) RETURN NUMBER IS
        v_rate NUMBER;
    BEGIN
        IF UPPER(p_currency) = 'AED' THEN
            RETURN 1;
        END IF;
        SELECT NVL(exchange_rate_to_aed, 1) INTO v_rate
          FROM prod.dct_currency_codes WHERE currency_code = UPPER(p_currency);
        RETURN NVL(v_rate, 1);
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN 1;
    END default_rate;

    FUNCTION line_total (p_procash_id NUMBER) RETURN NUMBER IS
        v_sum NUMBER;
    BEGIN
        SELECT NVL(SUM(amount), 0) INTO v_sum
          FROM prod.dct_ap_procash_line WHERE procash_id = p_procash_id;
        RETURN v_sum;
    END line_total;

    FUNCTION doc_count (p_procash_id NUMBER) RETURN NUMBER IS
        v_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_n FROM prod.dct_documents
         WHERE source_module = c_module AND source_type = c_src_type
           AND source_id = p_procash_id AND is_active = 'Y';
        RETURN v_n;
    END doc_count;

    FUNCTION hdr (p_procash_id NUMBER) RETURN prod.dct_ap_procash%ROWTYPE IS
        v_row prod.dct_ap_procash%ROWTYPE;
    BEGIN
        SELECT * INTO v_row FROM prod.dct_ap_procash WHERE procash_id = p_procash_id;
        RETURN v_row;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        raise_application_error(-20404, 'Procash transaction not found: ' || p_procash_id);
    END hdr;

    FUNCTION can_edit (p_procash_id NUMBER, p_user VARCHAR2) RETURN VARCHAR2 IS
        v_row prod.dct_ap_procash%ROWTYPE := hdr(p_procash_id);
    BEGIN
        -- An administrator may correct a transaction up to the point it is
        -- paid, but NOT while approvers are looking at it and not after they
        -- have signed it off: changing the payload under a running approval
        -- would invalidate what was approved. Cancel and re-raise instead.
        IF is_admin(p_user) THEN
            RETURN CASE WHEN v_row.status IN ('DRAFT', 'SUBMITTED', 'REJECTED') THEN 'Y' ELSE 'N' END;
        END IF;
        IF v_row.created_by = user_id_of(p_user) AND v_row.status IN ('DRAFT', 'REJECTED') THEN
            RETURN 'Y';
        END IF;
        RETURN 'N';
    END can_edit;

    PROCEDURE assert_edit (p_procash_id NUMBER, p_user VARCHAR2) IS
    BEGIN
        IF can_edit(p_procash_id, p_user) <> 'Y' THEN
            raise_application_error(-20403,
                'This procash transaction can no longer be edited by you.');
        END IF;
    END assert_edit;

    PROCEDURE hist (p_procash_id NUMBER, p_old VARCHAR2, p_new VARCHAR2,
                    p_user VARCHAR2, p_comments VARCHAR2) IS
    BEGIN
        INSERT INTO prod.dct_request_status_history
               (source_module, source_type, source_id, old_status, new_status, changed_by, changed_at, comments)
        VALUES (c_module, c_src_type, p_procash_id, p_old, p_new, user_id_of(p_user), SYSTIMESTAMP, p_comments);
    END hist;

    PROCEDURE add_finding (io_json IN OUT NOCOPY CLOB, p_code VARCHAR2,
                           p_severity VARCHAR2, p_message VARCHAR2) IS
        v_obj VARCHAR2(4000);
    BEGIN
        SELECT JSON_OBJECT('code' VALUE p_code, 'severity' VALUE p_severity, 'message' VALUE p_message)
          INTO v_obj FROM dual;
        io_json := CASE WHEN io_json IS NULL THEN v_obj ELSE io_json || ',' || v_obj END;
    END add_finding;

    -- ---------------------------------------------------------- validation

    FUNCTION findings (p_procash_id NUMBER) RETURN CLOB IS
        v_row   prod.dct_ap_procash%ROWTYPE := hdr(p_procash_id);
        v_items CLOB;
        v_lines NUMBER;
        v_sum   NUMBER := line_total(p_procash_id);
        v_diff  NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_lines FROM prod.dct_ap_procash_line WHERE procash_id = p_procash_id;

        IF v_lines = 0 THEN
            add_finding(v_items, 'NO_LINES', 'BLOCK',
                'Add at least one detail line before submitting.');
        ELSE
            v_diff := ROUND(v_row.amount - v_sum, 2);
            IF ABS(v_diff) > 0.005 THEN
                add_finding(v_items, 'LINE_SUM',
                    CASE WHEN NVL(setting('PROCASH_LINE_SUM_ENFORCE', 'Y'), 'Y') = 'Y'
                         THEN 'BLOCK' ELSE 'WARN' END,
                    'Detail lines total ' || TO_CHAR(v_sum, 'FM999999999990.00') ||
                    ' but the header amount is ' || TO_CHAR(v_row.amount, 'FM999999999990.00') ||
                    ' (difference ' || TO_CHAR(v_diff, 'FM999999999990.00') || ').');
            END IF;
        END IF;

        IF v_row.amount IS NULL OR v_row.amount = 0 THEN
            add_finding(v_items, 'AMOUNT', 'BLOCK', 'The payment amount must not be zero.');
        END IF;

        IF NVL(setting('PROCASH_ATTACH_REQUIRED', 'N'), 'N') = 'Y' AND doc_count(p_procash_id) = 0 THEN
            add_finding(v_items, 'NO_ATTACHMENT', 'BLOCK',
                'At least one attachment is required before this transaction can be processed.');
        ELSIF doc_count(p_procash_id) = 0 THEN
            add_finding(v_items, 'NO_ATTACHMENT', 'WARN',
                'No attachment has been uploaded for this payment.');
        END IF;

        RETURN '[' || NVL(v_items, TO_CLOB('')) || ']';
    END findings;

    PROCEDURE assert_ready (p_procash_id NUMBER) IS
        v_msg  VARCHAR2(4000);
        v_json CLOB := findings(p_procash_id);
    BEGIN
        SELECT LISTAGG(f.message, ' ') WITHIN GROUP (ORDER BY ROWNUM)
          INTO v_msg
          FROM JSON_TABLE(v_json, '$[*]'
                 COLUMNS (severity VARCHAR2(10) PATH '$.severity',
                          message  VARCHAR2(500) PATH '$.message')) f
         WHERE f.severity = 'BLOCK';
        IF v_msg IS NOT NULL THEN
            raise_application_error(-20001, v_msg);
        END IF;
    END assert_ready;

    -- -------------------------------------------------------------- header

    PROCEDURE save_header (
        p_user            IN  VARCHAR2,
        p_procash_id      IN  NUMBER,
        p_bank_reference  IN  VARCHAR2,
        p_bank_account    IN  VARCHAR2,
        p_business_unit   IN  VARCHAR2,
        p_supplier_number IN  VARCHAR2,
        p_supplier_name   IN  VARCHAR2,
        p_payee_name      IN  VARCHAR2,
        p_amount          IN  NUMBER,
        p_currency_code   IN  VARCHAR2,
        p_exchange_rate   IN  NUMBER,
        p_payment_date    IN  DATE,
        p_description     IN  VARCHAR2,
        p_comments        IN  VARCHAR2,
        o_procash_id      OUT NUMBER) IS

        v_uid  NUMBER := user_id_of(p_user);
        v_ccy  VARCHAR2(3)  := UPPER(TRIM(p_currency_code));
        v_rate NUMBER       := p_exchange_rate;
        v_sup  VARCHAR2(30) := TRIM(p_supplier_number);
        v_name VARCHAR2(400) := p_supplier_name;
        v_n    NUMBER;
    BEGIN
        IF TRIM(p_bank_reference) IS NULL THEN
            raise_application_error(-20001, 'Bank reference is required.');
        END IF;
        IF TRIM(p_business_unit) IS NULL THEN
            raise_application_error(-20001, 'Business unit is required.');
        END IF;
        IF p_payment_date IS NULL THEN
            raise_application_error(-20001, 'Payment date is required.');
        END IF;
        IF NVL(p_amount, 0) = 0 THEN
            raise_application_error(-20001, 'Payment amount is required and must not be zero.');
        END IF;
        IF v_ccy IS NULL THEN
            raise_application_error(-20001, 'Currency is required.');
        END IF;

        SELECT COUNT(*) INTO v_n FROM prod.dct_currency_codes WHERE currency_code = v_ccy;
        IF v_n = 0 THEN
            raise_application_error(-20001, 'Unknown currency: ' || v_ccy);
        END IF;

        v_rate := NVL(v_rate, default_rate(v_ccy));
        IF v_ccy = 'AED' THEN
            v_rate := 1;
        END IF;
        IF v_rate <= 0 THEN
            raise_application_error(-20001, 'Exchange rate must be greater than zero.');
        END IF;

        -- The supplier is PICKED from the Fusion list on the form, so the code
        -- that arrives is normally real; it is resolved to a name here but NOT
        -- validated -- an unrecognised supplier number is stored as typed
        -- (user decision 2026-08-17).
        IF v_sup IS NOT NULL AND v_name IS NULL THEN
            SELECT MAX(supplier_name) INTO v_name FROM prod.atd_suppliers
             WHERE TO_CHAR(supplier_number) = v_sup;
        END IF;

        IF p_procash_id IS NULL THEN
            IF NOT (is_admin(p_user) OR prod.dct_auth.has_role(p_user, 'PROCASH_USER')
                    OR prod.dct_auth.has_role(p_user, 'PROCASH_PROCESSOR')) THEN
                raise_application_error(-20403, 'You are not allowed to create procash transactions.');
            END IF;
            INSERT INTO prod.dct_ap_procash
                   (payment_number, bank_reference, bank_account, business_unit,
                    supplier_number, supplier_name, payee_name, amount, currency_code,
                    exchange_rate, payment_date, description, comments, status, created_by)
            VALUES (CASE WHEN NVL(setting('PROCASH_NUMBER_AUTO', 'Y'), 'Y') = 'Y'
                         THEN next_number ELSE TRIM(p_bank_reference) END,
                    TRIM(p_bank_reference), p_bank_account, TRIM(p_business_unit),
                    v_sup, v_name, p_payee_name, p_amount, v_ccy,
                    v_rate, p_payment_date, p_description, p_comments, 'DRAFT', v_uid)
            RETURNING procash_id INTO o_procash_id;
            hist(o_procash_id, NULL, 'DRAFT', p_user, 'Procash transaction created.');
        ELSE
            assert_edit(p_procash_id, p_user);
            UPDATE prod.dct_ap_procash
               SET bank_reference  = TRIM(p_bank_reference),
                   bank_account    = p_bank_account,
                   business_unit   = TRIM(p_business_unit),
                   supplier_number = v_sup,
                   supplier_name   = v_name,
                   payee_name      = p_payee_name,
                   amount          = p_amount,
                   currency_code   = v_ccy,
                   exchange_rate   = v_rate,
                   payment_date    = p_payment_date,
                   description     = p_description,
                   comments        = p_comments,
                   updated_by      = v_uid,
                   updated_on      = SYSTIMESTAMP
             WHERE procash_id = p_procash_id;
            o_procash_id := p_procash_id;
        END IF;
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
        raise_application_error(-20001,
            'Bank reference ' || TRIM(p_bank_reference) || ' is already recorded on another procash transaction.');
    END save_header;

    PROCEDURE delete_header (p_user VARCHAR2, p_procash_id NUMBER) IS
        v_row prod.dct_ap_procash%ROWTYPE := hdr(p_procash_id);
    BEGIN
        IF v_row.status <> 'DRAFT' AND NOT is_admin(p_user) THEN
            raise_application_error(-20403, 'Only a draft procash transaction can be removed.');
        END IF;
        IF v_row.status IN ('PROCESSED', 'INVOICED') THEN
            raise_application_error(-20403,
                'A processed or invoiced procash transaction cannot be removed. Cancel it instead.');
        END IF;
        assert_edit(p_procash_id, p_user);
        DELETE FROM prod.dct_documents
         WHERE source_module = c_module AND source_type = c_src_type AND source_id = p_procash_id;
        DELETE FROM prod.dct_request_status_history
         WHERE source_module = c_module AND source_type = c_src_type AND source_id = p_procash_id;
        DELETE FROM prod.dct_ap_procash WHERE procash_id = p_procash_id;
    END delete_header;

    -- --------------------------------------------------------------- lines

    PROCEDURE save_line (
        p_user             IN  VARCHAR2,
        p_line_id          IN  NUMBER,
        p_procash_id       IN  NUMBER,
        p_coding_basis     IN  VARCHAR2,
        p_project_number   IN  VARCHAR2,
        p_task_number      IN  VARCHAR2,
        p_expenditure_type IN  VARCHAR2,
        p_gl_combination   IN  VARCHAR2,
        p_amount           IN  NUMBER,
        p_comments         IN  VARCHAR2,
        o_line_id          OUT NUMBER) IS

        v_uid   NUMBER := user_id_of(p_user);
        v_basis VARCHAR2(10) := UPPER(NVL(TRIM(p_coding_basis), 'PROJECT'));
        v_hdr   NUMBER := p_procash_id;
        v_gl    VARCHAR2(320);
        v_proj  VARCHAR2(12)  := TRIM(p_project_number);
        v_task  VARCHAR2(30)  := TRIM(p_task_number);
        v_etype VARCHAR2(255) := TRIM(p_expenditure_type);
        v_n     NUMBER;
        v_num   NUMBER;
    BEGIN
        IF p_line_id IS NOT NULL THEN
            SELECT procash_id INTO v_hdr FROM prod.dct_ap_procash_line WHERE line_id = p_line_id;
        END IF;
        IF v_hdr IS NULL THEN
            raise_application_error(-20404, 'Procash line not found: ' || p_line_id);
        END IF;
        assert_edit(v_hdr, p_user);
        prod.dct_lookup_pkg.validate_lookup('PROCASH_CODING_BASIS', v_basis);

        IF NVL(p_amount, 0) = 0 THEN
            raise_application_error(-20001, 'Line amount is required and must not be zero.');
        END IF;

        IF v_basis = 'PROJECT' THEN
            IF v_proj IS NULL OR v_task IS NULL OR v_etype IS NULL THEN
                raise_application_error(-20001,
                    'A project line needs a project, a task and an expenditure type.');
            END IF;
            v_gl := NULL;
        ELSE
            IF TRIM(p_gl_combination) IS NULL THEN
                raise_application_error(-20001, 'A GL line needs a GL combination.');
            END IF;
            -- normalised to the canonical 10-segment order so a value typed by
            -- an API or Excel caller still matches what the form produces, but
            -- NOT checked against the chart of accounts (user decision).
            v_gl   := prod.dct_cc_canon(TRIM(p_gl_combination));
            v_proj := NULL;
            v_task := NULL;
            v_etype := NULL;
        END IF;

        IF p_line_id IS NULL THEN
            SELECT NVL(MAX(line_num), 0) + 1 INTO v_num
              FROM prod.dct_ap_procash_line WHERE procash_id = v_hdr;
            INSERT INTO prod.dct_ap_procash_line
                   (procash_id, line_num, coding_basis, project_number, task_number,
                    expenditure_type, gl_combination, amount, comments, created_by)
            VALUES (v_hdr, v_num, v_basis, v_proj, v_task, v_etype, v_gl, p_amount, p_comments, v_uid)
            RETURNING line_id INTO o_line_id;
        ELSE
            UPDATE prod.dct_ap_procash_line
               SET coding_basis     = v_basis,
                   project_number   = v_proj,
                   task_number      = v_task,
                   expenditure_type = v_etype,
                   gl_combination   = v_gl,
                   amount           = p_amount,
                   comments         = p_comments,
                   updated_by       = v_uid,
                   updated_on       = SYSTIMESTAMP
             WHERE line_id = p_line_id;
            o_line_id := p_line_id;
        END IF;
    END save_line;

    PROCEDURE delete_line (p_user VARCHAR2, p_line_id NUMBER) IS
        v_hdr NUMBER;
    BEGIN
        SELECT procash_id INTO v_hdr FROM prod.dct_ap_procash_line WHERE line_id = p_line_id;
        assert_edit(v_hdr, p_user);
        DELETE FROM prod.dct_ap_procash_line WHERE line_id = p_line_id;
        FOR r IN (SELECT line_id, ROW_NUMBER() OVER (ORDER BY line_num, line_id) AS rn
                    FROM prod.dct_ap_procash_line WHERE procash_id = v_hdr) LOOP
            UPDATE prod.dct_ap_procash_line SET line_num = r.rn WHERE line_id = r.line_id;
        END LOOP;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        raise_application_error(-20404, 'Procash line not found: ' || p_line_id);
    END delete_line;

    -- ----------------------------------------------------------- lifecycle

    PROCEDURE submit (p_user VARCHAR2, p_procash_id NUMBER, p_comments VARCHAR2 DEFAULT NULL) IS
        v_row  prod.dct_ap_procash%ROWTYPE := hdr(p_procash_id);
        v_mode VARCHAR2(20) := UPPER(NVL(setting('PROCASH_APPROVAL_MODE', 'NONE'), 'NONE'));
        v_new  VARCHAR2(30);
        v_inst NUMBER;
    BEGIN
        IF v_row.status NOT IN ('DRAFT', 'REJECTED') THEN
            raise_application_error(-20001,
                'Only a draft or rejected procash transaction can be submitted (this one is ' || v_row.status || ').');
        END IF;
        assert_edit(p_procash_id, p_user);
        assert_ready(p_procash_id);

        IF v_mode = 'WORKFLOW' THEN
            v_new := 'IN_APPROVAL';
            v_inst := prod.dct_wf_engine.start_process(
                          p_process_code      => 'PROCASH_APPROVAL',
                          p_source_record_id  => p_procash_id,
                          p_initiator_user_id => user_id_of(p_user),
                          p_source_record_ref => v_row.payment_number);
        ELSE
            v_new := 'SUBMITTED';
        END IF;

        UPDATE prod.dct_ap_procash
           SET status = v_new, wf_instance_id = NVL(v_inst, wf_instance_id),
               updated_by = user_id_of(p_user), updated_on = SYSTIMESTAMP
         WHERE procash_id = p_procash_id;
        hist(p_procash_id, v_row.status, v_new, p_user, p_comments);
    END submit;

    PROCEDURE mark_processed (p_user VARCHAR2, p_procash_id NUMBER, p_comments VARCHAR2 DEFAULT NULL) IS
        v_row  prod.dct_ap_procash%ROWTYPE := hdr(p_procash_id);
        v_mode VARCHAR2(20) := UPPER(NVL(setting('PROCASH_APPROVAL_MODE', 'NONE'), 'NONE'));
        v_ok   VARCHAR2(30) := CASE WHEN v_mode = 'WORKFLOW' THEN 'APPROVED' ELSE 'SUBMITTED' END;
    BEGIN
        IF NOT is_processor(p_user) THEN
            raise_application_error(-20403,
                'Marking a procash transaction as processed needs the Procash Processor role.');
        END IF;
        IF v_row.status <> v_ok THEN
            raise_application_error(-20001,
                'A procash transaction must be ' || v_ok || ' before it can be processed (this one is ' || v_row.status || ').');
        END IF;
        IF NVL(setting('PROCASH_ATTACH_REQUIRED', 'N'), 'N') = 'Y' AND doc_count(p_procash_id) = 0 THEN
            raise_application_error(-20001,
                'At least one attachment is required before this transaction can be processed.');
        END IF;
        UPDATE prod.dct_ap_procash
           SET status = 'PROCESSED', processed_by = user_id_of(p_user), processed_on = SYSTIMESTAMP,
               updated_by = user_id_of(p_user), updated_on = SYSTIMESTAMP
         WHERE procash_id = p_procash_id;
        hist(p_procash_id, v_row.status, 'PROCESSED', p_user, p_comments);
    END mark_processed;

    PROCEDURE cancel (p_user VARCHAR2, p_procash_id NUMBER, p_comments VARCHAR2 DEFAULT NULL) IS
        v_row prod.dct_ap_procash%ROWTYPE := hdr(p_procash_id);
    BEGIN
        IF v_row.status IN ('PROCESSED', 'INVOICED') AND NOT is_admin(p_user) THEN
            raise_application_error(-20403,
                'Only a Procash Administrator can cancel a processed transaction.');
        END IF;
        IF v_row.status = 'CANCELLED' THEN
            RETURN;
        END IF;
        IF v_row.created_by <> user_id_of(p_user) AND NOT is_admin(p_user) THEN
            raise_application_error(-20403, 'You are not allowed to cancel this procash transaction.');
        END IF;
        UPDATE prod.dct_ap_procash
           SET status = 'CANCELLED', updated_by = user_id_of(p_user), updated_on = SYSTIMESTAMP
         WHERE procash_id = p_procash_id;
        hist(p_procash_id, v_row.status, 'CANCELLED', p_user, p_comments);
    END cancel;

    -- ------------------------------------------------------------- invoice

    PROCEDURE link_invoice (p_user VARCHAR2, p_procash_id NUMBER,
                            p_invoice_id NUMBER DEFAULT NULL, p_invoice_number VARCHAR2 DEFAULT NULL) IS
        v_row prod.dct_ap_procash%ROWTYPE := hdr(p_procash_id);
        v_inv prod.ap_invoices_header_v%ROWTYPE;
        v_n   NUMBER;
    BEGIN
        IF v_row.created_by <> user_id_of(p_user) AND NOT is_processor(p_user) THEN
            raise_application_error(-20403, 'You are not allowed to update this procash transaction.');
        END IF;
        IF v_row.status <> 'PROCESSED' THEN
            raise_application_error(-20001,
                'Only a processed procash transaction can be linked to an invoice (this one is ' || v_row.status || ').');
        END IF;
        IF p_invoice_id IS NULL AND TRIM(p_invoice_number) IS NULL THEN
            raise_application_error(-20001, 'Provide the Fusion invoice to link.');
        END IF;

        IF p_invoice_id IS NOT NULL THEN
            BEGIN
                SELECT * INTO v_inv FROM prod.ap_invoices_header_v WHERE invoice_id = p_invoice_id;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                raise_application_error(-20404,
                    'Invoice ' || p_invoice_id || ' was not found in the loaded Fusion invoices.');
            END;
        ELSE
            SELECT COUNT(*) INTO v_n FROM prod.ap_invoices_header_v
             WHERE UPPER(invoice_number) = UPPER(TRIM(p_invoice_number));
            IF v_n = 0 THEN
                raise_application_error(-20404,
                    'Invoice ' || TRIM(p_invoice_number) || ' has not reached the loaded Fusion invoices yet.');
            ELSIF v_n > 1 THEN
                raise_application_error(-20001,
                    'Invoice number ' || TRIM(p_invoice_number) || ' matches ' || v_n ||
                    ' Fusion invoices. Pick the exact one from the search list.');
            END IF;
            SELECT * INTO v_inv FROM prod.ap_invoices_header_v
             WHERE UPPER(invoice_number) = UPPER(TRIM(p_invoice_number));
        END IF;

        SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash
         WHERE invoice_id = v_inv.invoice_id AND procash_id <> p_procash_id;
        IF v_n > 0 THEN
            raise_application_error(-20001,
                'Invoice ' || v_inv.invoice_number || ' is already linked to another procash transaction.');
        END IF;

        UPDATE prod.dct_ap_procash
           SET invoice_id        = v_inv.invoice_id,
               invoice_number    = v_inv.invoice_number,
               invoice_supplier  = NVL(v_inv.beneficiary_name, v_inv.supplier_name),
               invoice_date      = v_inv.invoice_date,
               invoice_amount    = v_inv.invoice_amount,
               invoice_currency  = v_inv.invoice_currency,
               invoice_linked_by = user_id_of(p_user),
               invoice_linked_on = SYSTIMESTAMP,
               status            = 'INVOICED',
               updated_by        = user_id_of(p_user),
               updated_on        = SYSTIMESTAMP
         WHERE procash_id = p_procash_id;
        hist(p_procash_id, v_row.status, 'INVOICED', p_user,
             'Linked to Fusion invoice ' || v_inv.invoice_number || '.');
    END link_invoice;

    PROCEDURE unlink_invoice (p_user VARCHAR2, p_procash_id NUMBER) IS
        v_row prod.dct_ap_procash%ROWTYPE := hdr(p_procash_id);
    BEGIN
        IF NOT is_admin(p_user) THEN
            raise_application_error(-20403,
                'Only a Procash Administrator can unlink an invoice.');
        END IF;
        IF v_row.invoice_id IS NULL AND v_row.invoice_number IS NULL THEN
            RETURN;
        END IF;
        UPDATE prod.dct_ap_procash
           SET invoice_id = NULL, invoice_number = NULL, invoice_supplier = NULL,
               invoice_date = NULL, invoice_amount = NULL, invoice_currency = NULL,
               invoice_linked_by = NULL, invoice_linked_on = NULL,
               status = 'PROCESSED', updated_by = user_id_of(p_user), updated_on = SYSTIMESTAMP
         WHERE procash_id = p_procash_id;
        hist(p_procash_id, v_row.status, 'PROCESSED', p_user,
             'Invoice ' || v_row.invoice_number || ' unlinked.');
    END unlink_invoice;

    -- ----------------------------------------------------------- documents

    PROCEDURE add_doc (p_user VARCHAR2, p_procash_id NUMBER, p_doc_type_code VARCHAR2,
                       p_file_name VARCHAR2, p_mime VARCHAR2, p_blob BLOB, o_doc_id OUT NUMBER) IS
        v_row  prod.dct_ap_procash%ROWTYPE := hdr(p_procash_id);
        v_type NUMBER;
    BEGIN
        IF v_row.created_by <> user_id_of(p_user) AND NOT is_processor(p_user) THEN
            raise_application_error(-20403, 'You are not allowed to attach files to this transaction.');
        END IF;
        IF v_row.status = 'CANCELLED' THEN
            raise_application_error(-20001, 'A cancelled procash transaction cannot take new attachments.');
        END IF;
        BEGIN
            SELECT doc_type_id INTO v_type FROM prod.dct_document_types
             WHERE doc_type_code = UPPER(NVL(TRIM(p_doc_type_code), 'OTHER')) AND is_active = 'Y';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001, 'Unknown document type: ' || p_doc_type_code);
        END;
        INSERT INTO prod.dct_documents
               (source_module, source_type, source_id, doc_type_id, file_name, mime_type,
                file_size_bytes, file_blob, status, is_required, is_active, created_by)
        VALUES (c_module, c_src_type, p_procash_id, v_type, p_file_name, p_mime,
                DBMS_LOB.getlength(p_blob), p_blob, 'ACTIVE', 'N', 'Y', user_id_of(p_user))
        RETURNING doc_id INTO o_doc_id;
    END add_doc;

    -- ---------------------------------------------------------- bulk entry

    PROCEDURE bulk_upsert (p_user VARCHAR2, p_payload CLOB, o_result OUT CLOB) IS
        v_items  CLOB;
        v_id     NUMBER;
        v_line   NUMBER;
        v_state  VARCHAR2(20);
        v_obj    VARCHAR2(4000);
        v_err    VARCHAR2(500);
        v_n      NUMBER := 0;
    BEGIN
        FOR r IN (SELECT * FROM JSON_TABLE(p_payload, '$[*]' COLUMNS (
                      row_no          FOR ORDINALITY,
                      bank_reference  VARCHAR2(100) PATH '$.bankReference',
                      bank_account    VARCHAR2(200) PATH '$.bankAccount',
                      business_unit   VARCHAR2(240) PATH '$.businessUnit',
                      supplier_number VARCHAR2(30)  PATH '$.supplierNumber',
                      supplier_name   VARCHAR2(400) PATH '$.supplierName',
                      payee_name      VARCHAR2(400) PATH '$.payeeName',
                      amount          NUMBER        PATH '$.amount',
                      currency_code   VARCHAR2(3)   PATH '$.currencyCode',
                      exchange_rate   NUMBER        PATH '$.exchangeRate',
                      payment_date    VARCHAR2(30)  PATH '$.paymentDate',
                      description     VARCHAR2(1000) PATH '$.description',
                      comments        VARCHAR2(4000) PATH '$.comments',
                      has_line        VARCHAR2(5)   EXISTS PATH '$.line',
                      coding_basis    VARCHAR2(10)  PATH '$.line.codingBasis',
                      project_number  VARCHAR2(12)  PATH '$.line.projectNumber',
                      task_number     VARCHAR2(30)  PATH '$.line.taskNumber',
                      etype           VARCHAR2(255) PATH '$.line.expenditureType',
                      gl_combination  VARCHAR2(320) PATH '$.line.glCombination',
                      line_amount     NUMBER        PATH '$.line.amount',
                      line_comments   VARCHAR2(1000) PATH '$.line.comments'))) LOOP
            v_n := v_n + 1;
            v_id := NULL;
            v_line := NULL;
            BEGIN
                SELECT procash_id INTO v_id FROM prod.dct_ap_procash
                 WHERE UPPER(bank_reference) = UPPER(TRIM(r.bank_reference));
                v_state := 'UPDATED';
            EXCEPTION WHEN NO_DATA_FOUND THEN
                v_id := NULL;
                v_state := 'CREATED';
            END;
            BEGIN
                save_header(p_user, v_id, r.bank_reference, r.bank_account, r.business_unit,
                            r.supplier_number, r.supplier_name, r.payee_name, r.amount,
                            r.currency_code, r.exchange_rate,
                            TO_DATE(SUBSTR(r.payment_date, 1, 10), 'YYYY-MM-DD'),
                            r.description, r.comments, v_id);
                IF r.has_line = 'true' AND NVL(r.line_amount, 0) <> 0 THEN
                    save_line(p_user, NULL, v_id, r.coding_basis, r.project_number, r.task_number,
                              r.etype, r.gl_combination, r.line_amount, r.line_comments, v_line);
                END IF;
                SELECT JSON_OBJECT('row' VALUE r.row_no, 'bankReference' VALUE r.bank_reference,
                                   'status' VALUE v_state, 'procashId' VALUE v_id,
                                   'lineId' VALUE v_line ABSENT ON NULL)
                  INTO v_obj FROM dual;
            EXCEPTION WHEN OTHERS THEN
                v_err := SUBSTR(SQLERRM, 1, 400);
                SELECT JSON_OBJECT('row' VALUE r.row_no, 'bankReference' VALUE r.bank_reference,
                                   'status' VALUE 'ERROR', 'error' VALUE v_err)
                  INTO v_obj FROM dual;
            END;
            v_items := CASE WHEN v_items IS NULL THEN v_obj ELSE v_items || ',' || v_obj END;
        END LOOP;
        o_result := '[' || NVL(v_items, TO_CLOB('')) || ']';
    END bulk_upsert;

    -- ------------------------------------------------------ workflow hooks

    PROCEDURE wf_approved (p_instance_id NUMBER, p_module VARCHAR2, p_record_id NUMBER, p_user_id NUMBER) IS
        v_old prod.dct_ap_procash.status%TYPE;
    BEGIN
        SELECT status INTO v_old FROM prod.dct_ap_procash WHERE procash_id = p_record_id;
        UPDATE prod.dct_ap_procash
           SET status = 'APPROVED', wf_instance_id = p_instance_id, updated_on = SYSTIMESTAMP
         WHERE procash_id = p_record_id;
        INSERT INTO prod.dct_request_status_history
               (source_module, source_type, source_id, old_status, new_status, changed_by, changed_at, comments)
        VALUES (c_module, c_src_type, p_record_id, v_old, 'APPROVED', NVL(p_user_id, 0), SYSTIMESTAMP,
                'Approved on the workflow platform.');
    EXCEPTION WHEN NO_DATA_FOUND THEN
        NULL;
    END wf_approved;

    PROCEDURE wf_rejected (p_instance_id NUMBER, p_module VARCHAR2, p_record_id NUMBER, p_user_id NUMBER) IS
        v_old prod.dct_ap_procash.status%TYPE;
    BEGIN
        SELECT status INTO v_old FROM prod.dct_ap_procash WHERE procash_id = p_record_id;
        UPDATE prod.dct_ap_procash
           SET status = 'REJECTED', wf_instance_id = p_instance_id, updated_on = SYSTIMESTAMP
         WHERE procash_id = p_record_id;
        INSERT INTO prod.dct_request_status_history
               (source_module, source_type, source_id, old_status, new_status, changed_by, changed_at, comments)
        VALUES (c_module, c_src_type, p_record_id, v_old, 'REJECTED', NVL(p_user_id, 0), SYSTIMESTAMP,
                'Rejected on the workflow platform.');
    EXCEPTION WHEN NO_DATA_FOUND THEN
        NULL;
    END wf_rejected;

    PROCEDURE wf_returned (p_instance_id NUMBER, p_module VARCHAR2, p_record_id NUMBER, p_user_id NUMBER) IS
        v_old prod.dct_ap_procash.status%TYPE;
    BEGIN
        SELECT status INTO v_old FROM prod.dct_ap_procash WHERE procash_id = p_record_id;
        UPDATE prod.dct_ap_procash
           SET status = 'DRAFT', wf_instance_id = p_instance_id, updated_on = SYSTIMESTAMP
         WHERE procash_id = p_record_id;
        INSERT INTO prod.dct_request_status_history
               (source_module, source_type, source_id, old_status, new_status, changed_by, changed_at, comments)
        VALUES (c_module, c_src_type, p_record_id, v_old, 'DRAFT', NVL(p_user_id, 0), SYSTIMESTAMP,
                'Returned for more information from the workflow platform.');
    EXCEPTION WHEN NO_DATA_FOUND THEN
        NULL;
    END wf_returned;

END dct_ap_procash_pkg;
/

SHOW ERRORS

PROMPT === verification ===

SELECT object_name, object_type, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS built
  FROM all_objects WHERE owner = 'PROD' AND object_name = 'DCT_AP_PROCASH_PKG';

SELECT line, position, SUBSTR(text, 1, 120) AS text FROM all_errors
 WHERE owner = 'PROD' AND name = 'DCT_AP_PROCASH_PKG' ORDER BY sequence;
