SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
-- =============================================================================
-- Excel integration - Procash Transactions (Visual Builder Add-in for Excel)
-- File   : 121_xl_procash.sql        2026-08-17
-- Schema : PROD
-- Run    : own SQLcl session, then re-run 107_xl_budget_ords.sql (the routes
--          live there because 107 DELETE_MODULEs xl.rest, so a separate
--          additive ORDS script would be wiped by the next 107 re-run)
-- -----------------------------------------------------------------------------
-- Four business objects, one per sheet of the procash workbook:
--   single    one header AND one detail line in a single row  (the default
--             sheet: capture a whole one line payment in one shot)
--   headers   header fields only          \  the multi line template: lines
--   lines     N detail lines               /  join their header on
--                                             bank_reference
--   invoices  the after the fact invoice update - PROCESSED transactions with
--             invoice_number as the ONLY writable field
--
-- Auth is HTTP Basic, validated in-handler against DCT_USERS by
-- DCT_XL_PKG.REQUIRE_USER (shared with the budget API). /xl/ is ORDS-public
-- and self-authenticating, so the db/v2/50 module gate does not apply.
--
-- EVERY write goes through DCT_AP_PROCASH_PKG, so the Excel path obeys exactly
-- the same rules as the web app: status gates, role checks, coding validation,
-- the line-sum rule and the audit trail. There is no second rule set here.
--
-- The row identity field is `id`, matching the {id} path parameter - the add-in
-- cannot update a row without it (the BUDGET_OVERRIDE lesson).
-- =============================================================================

CREATE OR REPLACE PACKAGE prod.dct_xl_procash_pkg AS

    -- GET  <kind>/            list rows (kind: single | headers | lines | invoices)
    PROCEDURE emit_list (p_uid    IN NUMBER,
                         p_kind   IN VARCHAR2,
                         p_limit  IN VARCHAR2 DEFAULT NULL,
                         p_offset IN VARCHAR2 DEFAULT NULL,
                         p_status IN VARCHAR2 DEFAULT NULL,
                         p_bu     IN VARCHAR2 DEFAULT NULL,
                         p_from   IN VARCHAR2 DEFAULT NULL,
                         p_to     IN VARCHAR2 DEFAULT NULL,
                         p_search IN VARCHAR2 DEFAULT NULL);

    -- GET  <kind>/:id         one row
    PROCEDURE emit_item (p_uid IN NUMBER, p_kind IN VARCHAR2, p_id IN VARCHAR2);

    -- POST <kind>/            create (single / headers / lines only)
    PROCEDURE create_item (p_uid IN NUMBER, p_kind IN VARCHAR2, p_body IN BLOB);

    -- PUT  <kind>/:id         update; an absent key keeps the stored value
    PROCEDURE save_item (p_uid IN NUMBER, p_kind IN VARCHAR2, p_id IN VARCHAR2, p_body IN BLOB);

    -- GET  lov/:kind          pick lists (business-units | currencies |
    --                         statuses | coding-bases | projects | etypes)
    PROCEDURE emit_lov (p_kind IN VARCHAR2, p_search IN VARCHAR2 DEFAULT NULL);

    -- GET  openapi            hand-authored description for the add-in; the
    --                         ORDS auto catalog of a custom module carries no
    --                         field schemas, so the add-in would list nothing.
    PROCEDURE emit_openapi;

END dct_xl_procash_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_xl_procash_pkg AS

    FUNCTION uname (p_uid NUMBER) RETURN VARCHAR2 IS
        v VARCHAR2(100);
    BEGIN
        SELECT username INTO v FROM prod.dct_users WHERE user_id = p_uid;
        RETURN v;
    END uname;

    FUNCTION norm (p_kind VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN LOWER(NVL(p_kind, 'single'));
    END norm;

    PROCEDURE bad (p_status PLS_INTEGER, p_msg VARCHAR2) IS
    BEGIN
        dct_rest.err(p_status, p_msg);
    END bad;

    -- map an ORA-20xxx from the shared package onto an HTTP status
    PROCEDURE oops IS
    BEGIN
        IF SQLCODE = -20401 THEN bad(401, SQLERRM);
        ELSIF SQLCODE = -20403 THEN bad(403, SQLERRM);
        ELSIF SQLCODE = -20404 THEN bad(404, SQLERRM);
        ELSIF SQLCODE IN (-20001, -20090) THEN bad(400, SQLERRM);
        ELSE bad(500, SQLERRM);
        END IF;
    END oops;

    FUNCTION jtxt (p_path VARCHAR2, p_default VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
    BEGIN
        IF APEX_JSON.does_exist(p_path => p_path) THEN
            RETURN APEX_JSON.get_varchar2(p_path => p_path);
        END IF;
        RETURN p_default;
    END jtxt;

    FUNCTION jnum (p_path VARCHAR2, p_default NUMBER DEFAULT NULL) RETURN NUMBER IS
    BEGIN
        IF APEX_JSON.does_exist(p_path => p_path) THEN
            RETURN APEX_JSON.get_number(p_path => p_path);
        END IF;
        RETURN p_default;
    END jnum;

    FUNCTION jdate (p_path VARCHAR2, p_default DATE DEFAULT NULL) RETURN DATE IS
        v VARCHAR2(40);
    BEGIN
        IF NOT APEX_JSON.does_exist(p_path => p_path) THEN
            RETURN p_default;
        END IF;
        v := APEX_JSON.get_varchar2(p_path => p_path);
        IF TRIM(v) IS NULL THEN
            RETURN p_default;
        END IF;
        RETURN TO_DATE(SUBSTR(v, 1, 10), 'YYYY-MM-DD');
    END jdate;

    -- ------------------------------------------------------------- row writers

    PROCEDURE hdr_fields (r prod.dct_ap_procash%ROWTYPE, p_with_line BOOLEAN) IS
        v_line prod.dct_ap_procash_line%ROWTYPE;
        v_n    NUMBER;
    BEGIN
        APEX_JSON.write('id',              r.procash_id);
        APEX_JSON.write('payment_number',  r.payment_number,  p_write_null => TRUE);
        APEX_JSON.write('bank_reference',  r.bank_reference,  p_write_null => TRUE);
        APEX_JSON.write('bank_account',    r.bank_account,    p_write_null => TRUE);
        APEX_JSON.write('business_unit',   r.business_unit,   p_write_null => TRUE);
        APEX_JSON.write('payee_name',      r.payee_name,      p_write_null => TRUE);
        APEX_JSON.write('supplier_number', r.supplier_number, p_write_null => TRUE);
        APEX_JSON.write('payment_date',    TO_CHAR(r.payment_date, 'YYYY-MM-DD'), p_write_null => TRUE);
        APEX_JSON.write('currency_code',   r.currency_code,   p_write_null => TRUE);
        APEX_JSON.write('amount',          r.amount,          p_write_null => TRUE);
        APEX_JSON.write('exchange_rate',   r.exchange_rate,   p_write_null => TRUE);
        APEX_JSON.write('amount_aed',      r.amount_aed,      p_write_null => TRUE);
        APEX_JSON.write('description',     r.description,     p_write_null => TRUE);
        APEX_JSON.write('comments',        r.comments,        p_write_null => TRUE);
        APEX_JSON.write('status',          r.status,          p_write_null => TRUE);
        SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash_line WHERE procash_id = r.procash_id;
        APEX_JSON.write('line_count', v_n);
        APEX_JSON.write('line_total', prod.dct_ap_procash_pkg.line_total(r.procash_id));
        APEX_JSON.write('invoice_number', r.invoice_number, p_write_null => TRUE);
        IF p_with_line THEN
            BEGIN
                SELECT * INTO v_line FROM prod.dct_ap_procash_line
                 WHERE procash_id = r.procash_id AND line_num = 1;
                APEX_JSON.write('line_coding_basis',     v_line.coding_basis,     p_write_null => TRUE);
                APEX_JSON.write('line_project_number',   v_line.project_number,   p_write_null => TRUE);
                APEX_JSON.write('line_task_number',      v_line.task_number,      p_write_null => TRUE);
                APEX_JSON.write('line_expenditure_type', v_line.expenditure_type, p_write_null => TRUE);
                APEX_JSON.write('line_gl_combination',   v_line.gl_combination,   p_write_null => TRUE);
                APEX_JSON.write('line_amount',           v_line.amount,           p_write_null => TRUE);
                APEX_JSON.write('line_comments',         v_line.comments,         p_write_null => TRUE);
            EXCEPTION WHEN NO_DATA_FOUND THEN
                APEX_JSON.write('line_coding_basis',     'PROJECT');
                APEX_JSON.write('line_project_number',   TO_CHAR(NULL), p_write_null => TRUE);
                APEX_JSON.write('line_task_number',      TO_CHAR(NULL), p_write_null => TRUE);
                APEX_JSON.write('line_expenditure_type', TO_CHAR(NULL), p_write_null => TRUE);
                APEX_JSON.write('line_gl_combination',   TO_CHAR(NULL), p_write_null => TRUE);
                APEX_JSON.write('line_amount',           TO_NUMBER(NULL), p_write_null => TRUE);
                APEX_JSON.write('line_comments',         TO_CHAR(NULL), p_write_null => TRUE);
            END;
        END IF;
    END hdr_fields;

    PROCEDURE line_fields (l prod.dct_ap_procash_line%ROWTYPE) IS
        h prod.dct_ap_procash%ROWTYPE;
    BEGIN
        SELECT * INTO h FROM prod.dct_ap_procash WHERE procash_id = l.procash_id;
        APEX_JSON.write('id',               l.line_id);
        APEX_JSON.write('bank_reference',   h.bank_reference);
        APEX_JSON.write('payment_number',   h.payment_number);
        APEX_JSON.write('line_num',         l.line_num);
        APEX_JSON.write('coding_basis',     l.coding_basis);
        APEX_JSON.write('project_number',   l.project_number,   p_write_null => TRUE);
        APEX_JSON.write('task_number',      l.task_number,      p_write_null => TRUE);
        APEX_JSON.write('expenditure_type', l.expenditure_type, p_write_null => TRUE);
        APEX_JSON.write('gl_combination',   l.gl_combination,   p_write_null => TRUE);
        APEX_JSON.write('amount',           l.amount);
        APEX_JSON.write('comments',         l.comments,         p_write_null => TRUE);
        APEX_JSON.write('header_status',    h.status);
        APEX_JSON.write('header_amount',    h.amount);
    END line_fields;

    PROCEDURE inv_fields (r prod.dct_ap_procash%ROWTYPE) IS
    BEGIN
        APEX_JSON.write('id',              r.procash_id);
        APEX_JSON.write('payment_number',  r.payment_number);
        APEX_JSON.write('bank_reference',  r.bank_reference);
        APEX_JSON.write('payee_name',      r.payee_name,     p_write_null => TRUE);
        APEX_JSON.write('business_unit',   r.business_unit);
        APEX_JSON.write('payment_date',    TO_CHAR(r.payment_date, 'YYYY-MM-DD'));
        APEX_JSON.write('currency_code',   r.currency_code);
        APEX_JSON.write('amount',          r.amount);
        APEX_JSON.write('status',          r.status);
        APEX_JSON.write('invoice_number',  r.invoice_number,  p_write_null => TRUE);
        APEX_JSON.write('invoice_date',    TO_CHAR(r.invoice_date, 'YYYY-MM-DD'), p_write_null => TRUE);
        APEX_JSON.write('invoice_amount',  r.invoice_amount,  p_write_null => TRUE);
        APEX_JSON.write('invoice_supplier', r.invoice_supplier, p_write_null => TRUE);
        APEX_JSON.write('amount_mismatch', r.amount_mismatch, p_write_null => TRUE);
    END inv_fields;

    -- ------------------------------------------------------------------- list

    PROCEDURE emit_list (p_uid    IN NUMBER,
                         p_kind   IN VARCHAR2,
                         p_limit  IN VARCHAR2 DEFAULT NULL,
                         p_offset IN VARCHAR2 DEFAULT NULL,
                         p_status IN VARCHAR2 DEFAULT NULL,
                         p_bu     IN VARCHAR2 DEFAULT NULL,
                         p_from   IN VARCHAR2 DEFAULT NULL,
                         p_to     IN VARCHAR2 DEFAULT NULL,
                         p_search IN VARCHAR2 DEFAULT NULL) IS
        v_kind   VARCHAR2(20) := norm(p_kind);
        v_limit  NUMBER := LEAST(NVL(TO_NUMBER(p_limit  DEFAULT NULL ON CONVERSION ERROR), 500), 5000);
        v_offset NUMBER := GREATEST(NVL(TO_NUMBER(p_offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
        v_from   DATE := TO_DATE(SUBSTR(p_from, 1, 10) DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
        v_to     DATE := TO_DATE(SUBSTR(p_to,   1, 10) DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
        v_n      NUMBER := 0;
    BEGIN
        dct_rest.json_header;
        APEX_JSON.initialize_output;
        APEX_JSON.open_object;
        APEX_JSON.open_array('items');

        IF v_kind = 'lines' THEN
            FOR l IN (SELECT l.* FROM prod.dct_ap_procash_line l
                        JOIN prod.dct_ap_procash h ON h.procash_id = l.procash_id
                       WHERE (p_status IS NULL OR INSTR('|'||p_status||'|', '|'||h.status||'|') > 0)
                         AND (p_bu IS NULL OR h.business_unit = p_bu)
                         AND (v_from IS NULL OR h.payment_date >= v_from)
                         AND (v_to   IS NULL OR h.payment_date < v_to + 1)
                         AND (p_search IS NULL OR UPPER(h.bank_reference||' '||h.payment_number)
                              LIKE '%'||UPPER(p_search)||'%')
                       ORDER BY h.payment_date DESC, l.procash_id DESC, l.line_num
                       OFFSET v_offset ROWS FETCH NEXT v_limit ROWS ONLY) LOOP
                APEX_JSON.open_object;
                line_fields(l);
                APEX_JSON.close_object;
                v_n := v_n + 1;
            END LOOP;
        ELSE
            FOR h IN (SELECT h.* FROM prod.dct_ap_procash h
                       WHERE (p_status IS NULL OR INSTR('|'||p_status||'|', '|'||h.status||'|') > 0)
                         AND (p_bu IS NULL OR h.business_unit = p_bu)
                         AND (v_from IS NULL OR h.payment_date >= v_from)
                         AND (v_to   IS NULL OR h.payment_date < v_to + 1)
                         AND (p_search IS NULL OR UPPER(h.bank_reference||' '||h.payment_number||' '||
                              NVL(h.payee_name,' ')) LIKE '%'||UPPER(p_search)||'%')
                         AND (v_kind <> 'invoices' OR h.status IN ('PROCESSED', 'INVOICED'))
                       ORDER BY h.payment_date DESC, h.procash_id DESC
                       OFFSET v_offset ROWS FETCH NEXT v_limit ROWS ONLY) LOOP
                APEX_JSON.open_object;
                IF v_kind = 'invoices' THEN
                    inv_fields(h);
                ELSE
                    hdr_fields(h, v_kind = 'single');
                END IF;
                APEX_JSON.close_object;
                v_n := v_n + 1;
            END LOOP;
        END IF;

        APEX_JSON.close_array;
        APEX_JSON.write('hasMore', CASE WHEN v_n = v_limit THEN TRUE ELSE FALSE END);
        APEX_JSON.write('limit',   v_limit);
        APEX_JSON.write('offset',  v_offset);
        APEX_JSON.write('count',   v_n);
        APEX_JSON.close_object;
    EXCEPTION WHEN OTHERS THEN oops;
    END emit_list;

    -- ------------------------------------------------------------------- item

    PROCEDURE emit_item (p_uid IN NUMBER, p_kind IN VARCHAR2, p_id IN VARCHAR2) IS
        v_kind VARCHAR2(20) := norm(p_kind);
        v_id   NUMBER := TO_NUMBER(p_id DEFAULT NULL ON CONVERSION ERROR);
        v_h    prod.dct_ap_procash%ROWTYPE;
        v_l    prod.dct_ap_procash_line%ROWTYPE;
    BEGIN
        IF v_id IS NULL THEN
            bad(400, 'Bad row id'); RETURN;
        END IF;
        IF v_kind = 'lines' THEN
            BEGIN
                SELECT * INTO v_l FROM prod.dct_ap_procash_line WHERE line_id = v_id;
            EXCEPTION WHEN NO_DATA_FOUND THEN bad(404, 'Line not found'); RETURN;
            END;
            dct_rest.json_header; APEX_JSON.initialize_output;
            APEX_JSON.open_object; line_fields(v_l); APEX_JSON.close_object;
        ELSE
            BEGIN
                SELECT * INTO v_h FROM prod.dct_ap_procash WHERE procash_id = v_id;
            EXCEPTION WHEN NO_DATA_FOUND THEN bad(404, 'Procash transaction not found'); RETURN;
            END;
            dct_rest.json_header; APEX_JSON.initialize_output;
            APEX_JSON.open_object;
            IF v_kind = 'invoices' THEN inv_fields(v_h); ELSE hdr_fields(v_h, v_kind = 'single'); END IF;
            APEX_JSON.close_object;
        END IF;
    EXCEPTION WHEN OTHERS THEN oops;
    END emit_item;

    -- ----------------------------------------------------------------- create

    PROCEDURE create_item (p_uid IN NUMBER, p_kind IN VARCHAR2, p_body IN BLOB) IS
        v_kind VARCHAR2(20) := norm(p_kind);
        v_user VARCHAR2(100) := uname(p_uid);
        v_id   NUMBER;
        v_line NUMBER;
        v_h    prod.dct_ap_procash%ROWTYPE;
        v_ref  VARCHAR2(100);
    BEGIN
        IF v_kind = 'invoices' THEN
            bad(405, 'Procash transactions cannot be created from the invoice sheet.'); RETURN;
        END IF;
        dct_rest.parse_body(p_body);

        IF v_kind = 'lines' THEN
            v_ref := jtxt('bank_reference');
            IF TRIM(v_ref) IS NULL THEN
                bad(400, 'bank_reference identifies the transaction this line belongs to.'); RETURN;
            END IF;
            BEGIN
                SELECT procash_id INTO v_id FROM prod.dct_ap_procash
                 WHERE UPPER(bank_reference) = UPPER(TRIM(v_ref));
            EXCEPTION WHEN NO_DATA_FOUND THEN
                bad(404, 'No procash transaction carries bank reference ' || v_ref); RETURN;
            END;
            prod.dct_ap_procash_pkg.save_line(
                v_user, NULL, v_id, jtxt('coding_basis', 'PROJECT'), jtxt('project_number'),
                jtxt('task_number'), jtxt('expenditure_type'), jtxt('gl_combination'),
                jnum('amount'), jtxt('comments'), v_line);
            COMMIT;
            SELECT * INTO v_h FROM prod.dct_ap_procash WHERE procash_id = v_id;
            dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
            APEX_JSON.write('id', v_line);
            APEX_JSON.write('bank_reference', v_h.bank_reference);
            APEX_JSON.write('line_total', prod.dct_ap_procash_pkg.line_total(v_id));
            APEX_JSON.close_object;
            RETURN;
        END IF;

        prod.dct_ap_procash_pkg.save_header(
            v_user, NULL, jtxt('bank_reference'), jtxt('bank_account'), jtxt('business_unit'),
            jtxt('supplier_number'), jtxt('supplier_name'), jtxt('payee_name'),
            jnum('amount'), jtxt('currency_code', 'AED'), jnum('exchange_rate'),
            jdate('payment_date', TRUNC(SYSDATE)), jtxt('description'), jtxt('comments'), v_id);

        IF v_kind = 'single' AND NVL(jnum('line_amount'), 0) <> 0 THEN
            prod.dct_ap_procash_pkg.save_line(
                v_user, NULL, v_id, jtxt('line_coding_basis', 'PROJECT'), jtxt('line_project_number'),
                jtxt('line_task_number'), jtxt('line_expenditure_type'), jtxt('line_gl_combination'),
                jnum('line_amount'), jtxt('line_comments'), v_line);
        END IF;
        COMMIT;
        SELECT * INTO v_h FROM prod.dct_ap_procash WHERE procash_id = v_id;
        dct_rest.json_header; APEX_JSON.initialize_output;
        APEX_JSON.open_object; hdr_fields(v_h, v_kind = 'single'); APEX_JSON.close_object;
    EXCEPTION WHEN OTHERS THEN ROLLBACK; oops;
    END create_item;

    -- ----------------------------------------------------------------- update

    PROCEDURE save_item (p_uid IN NUMBER, p_kind IN VARCHAR2, p_id IN VARCHAR2, p_body IN BLOB) IS
        v_kind VARCHAR2(20) := norm(p_kind);
        v_user VARCHAR2(100) := uname(p_uid);
        v_id   NUMBER := TO_NUMBER(p_id DEFAULT NULL ON CONVERSION ERROR);
        v_h    prod.dct_ap_procash%ROWTYPE;
        v_l    prod.dct_ap_procash_line%ROWTYPE;
        v_out  NUMBER;
    BEGIN
        IF v_id IS NULL THEN
            bad(400, 'Bad row id'); RETURN;
        END IF;
        dct_rest.parse_body(p_body);

        IF v_kind = 'lines' THEN
            BEGIN
                SELECT * INTO v_l FROM prod.dct_ap_procash_line WHERE line_id = v_id;
            EXCEPTION WHEN NO_DATA_FOUND THEN bad(404, 'Line not found'); RETURN;
            END;
            prod.dct_ap_procash_pkg.save_line(
                v_user, v_id, v_l.procash_id,
                jtxt('coding_basis',     v_l.coding_basis),
                jtxt('project_number',   v_l.project_number),
                jtxt('task_number',      v_l.task_number),
                jtxt('expenditure_type', v_l.expenditure_type),
                jtxt('gl_combination',   v_l.gl_combination),
                jnum('amount',           v_l.amount),
                jtxt('comments',         v_l.comments), v_out);
            COMMIT;
            SELECT * INTO v_l FROM prod.dct_ap_procash_line WHERE line_id = v_id;
            dct_rest.json_header; APEX_JSON.initialize_output;
            APEX_JSON.open_object; line_fields(v_l); APEX_JSON.close_object;
            RETURN;
        END IF;

        BEGIN
            SELECT * INTO v_h FROM prod.dct_ap_procash WHERE procash_id = v_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN bad(404, 'Procash transaction not found'); RETURN;
        END;

        IF v_kind = 'invoices' THEN
            -- invoice_number is the ONLY writable field on this sheet
            IF NOT APEX_JSON.does_exist(p_path => 'invoice_number')
               OR TRIM(jtxt('invoice_number')) IS NULL THEN
                bad(400, 'Fill invoice_number to reconcile this payment.'); RETURN;
            END IF;
            prod.dct_ap_procash_pkg.link_invoice(v_user, v_id, NULL, TRIM(jtxt('invoice_number')));
            COMMIT;
            SELECT * INTO v_h FROM prod.dct_ap_procash WHERE procash_id = v_id;
            dct_rest.json_header; APEX_JSON.initialize_output;
            APEX_JSON.open_object; inv_fields(v_h); APEX_JSON.close_object;
            RETURN;
        END IF;

        prod.dct_ap_procash_pkg.save_header(
            v_user, v_id,
            jtxt('bank_reference',  v_h.bank_reference),
            jtxt('bank_account',    v_h.bank_account),
            jtxt('business_unit',   v_h.business_unit),
            jtxt('supplier_number', v_h.supplier_number),
            jtxt('supplier_name',   v_h.supplier_name),
            jtxt('payee_name',      v_h.payee_name),
            jnum('amount',          v_h.amount),
            jtxt('currency_code',   v_h.currency_code),
            jnum('exchange_rate',   v_h.exchange_rate),
            jdate('payment_date',   v_h.payment_date),
            jtxt('description',     v_h.description),
            jtxt('comments',        v_h.comments), v_out);

        IF v_kind = 'single' AND APEX_JSON.does_exist(p_path => 'line_amount') THEN
            BEGIN
                SELECT * INTO v_l FROM prod.dct_ap_procash_line
                 WHERE procash_id = v_id AND line_num = 1;
                prod.dct_ap_procash_pkg.save_line(
                    v_user, v_l.line_id, v_id,
                    jtxt('line_coding_basis',     v_l.coding_basis),
                    jtxt('line_project_number',   v_l.project_number),
                    jtxt('line_task_number',      v_l.task_number),
                    jtxt('line_expenditure_type', v_l.expenditure_type),
                    jtxt('line_gl_combination',   v_l.gl_combination),
                    jnum('line_amount',           v_l.amount),
                    jtxt('line_comments',         v_l.comments), v_out);
            EXCEPTION WHEN NO_DATA_FOUND THEN
                IF NVL(jnum('line_amount'), 0) <> 0 THEN
                    prod.dct_ap_procash_pkg.save_line(
                        v_user, NULL, v_id, jtxt('line_coding_basis', 'PROJECT'),
                        jtxt('line_project_number'), jtxt('line_task_number'),
                        jtxt('line_expenditure_type'), jtxt('line_gl_combination'),
                        jnum('line_amount'), jtxt('line_comments'), v_out);
                END IF;
            END;
        END IF;
        COMMIT;
        SELECT * INTO v_h FROM prod.dct_ap_procash WHERE procash_id = v_id;
        dct_rest.json_header; APEX_JSON.initialize_output;
        APEX_JSON.open_object; hdr_fields(v_h, v_kind = 'single'); APEX_JSON.close_object;
    EXCEPTION WHEN OTHERS THEN ROLLBACK; oops;
    END save_item;

    -- -------------------------------------------------------------- pick lists

    PROCEDURE emit_lov (p_kind IN VARCHAR2, p_search IN VARCHAR2 DEFAULT NULL) IS
        v_kind VARCHAR2(30) := LOWER(NVL(p_kind, 'x'));
        v_n    NUMBER := 0;
    BEGIN
        dct_rest.json_header;
        APEX_JSON.initialize_output;
        APEX_JSON.open_object;
        APEX_JSON.open_array('items');
        IF v_kind = 'business-units' THEN
            FOR r IN (SELECT business_unit v FROM prod.ap_invoices_header_v
                       WHERE business_unit IS NOT NULL GROUP BY business_unit ORDER BY 1) LOOP
                APEX_JSON.open_object; APEX_JSON.write('code', r.v); APEX_JSON.write('name', r.v);
                APEX_JSON.close_object; v_n := v_n + 1;
            END LOOP;
        ELSIF v_kind = 'currencies' THEN
            FOR r IN (SELECT currency_code c, currency_name_en n FROM prod.dct_currency_codes
                       WHERE is_active = 'Y' ORDER BY display_order, currency_code) LOOP
                APEX_JSON.open_object; APEX_JSON.write('code', r.c); APEX_JSON.write('name', r.n);
                APEX_JSON.close_object; v_n := v_n + 1;
            END LOOP;
        ELSIF v_kind IN ('statuses', 'coding-bases') THEN
            FOR r IN (SELECT v.value_code c, v.value_name_en n
                        FROM prod.dct_lookup_values v
                        JOIN prod.dct_lookup_categories g ON g.category_id = v.category_id
                       WHERE g.category_code = CASE WHEN v_kind = 'statuses'
                                                    THEN 'PROCASH_STATUS' ELSE 'PROCASH_CODING_BASIS' END
                         AND v.is_active = 'Y' ORDER BY v.display_order) LOOP
                APEX_JSON.open_object; APEX_JSON.write('code', r.c); APEX_JSON.write('name', r.n);
                APEX_JSON.close_object; v_n := v_n + 1;
            END LOOP;
        ELSIF v_kind = 'projects' THEN
            FOR r IN (SELECT project_number c, project_name_en n FROM prod.dct_projects
                       WHERE is_active = 'Y'
                         AND (p_search IS NULL OR UPPER(project_number||' '||project_name_en)
                              LIKE '%'||UPPER(p_search)||'%')
                       ORDER BY project_number FETCH FIRST 500 ROWS ONLY) LOOP
                APEX_JSON.open_object; APEX_JSON.write('code', r.c); APEX_JSON.write('name', r.n);
                APEX_JSON.close_object; v_n := v_n + 1;
            END LOOP;
        ELSIF v_kind = 'etypes' THEN
            FOR r IN (SELECT expenditure_type c, exp_type_name_en n FROM prod.dct_expenditure_types
                       WHERE is_active = 'Y'
                         AND (p_search IS NULL OR UPPER(expenditure_type) LIKE '%'||UPPER(p_search)||'%')
                       ORDER BY expenditure_type FETCH FIRST 500 ROWS ONLY) LOOP
                APEX_JSON.open_object; APEX_JSON.write('code', r.c); APEX_JSON.write('name', r.n);
                APEX_JSON.close_object; v_n := v_n + 1;
            END LOOP;
        END IF;
        APEX_JSON.close_array;
        APEX_JSON.write('count', v_n);
        APEX_JSON.close_object;
    EXCEPTION WHEN OTHERS THEN oops;
    END emit_lov;

    -- ---------------------------------------------------------------- openapi

    PROCEDURE emit_openapi IS
        l_a    VARCHAR2(32767);
        l_b    VARCHAR2(32767);
        l_pos  PLS_INTEGER := 1;
        l_bu   VARCHAR2(2000);
        l_ccy  VARCHAR2(2000);
        c_base CONSTANT VARCHAR2(200) :=
            'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/xl';

        PROCEDURE app (p_buf IN OUT VARCHAR2, p_val VARCHAR2) IS
        BEGIN
            p_buf := p_buf || CASE WHEN p_buf IS NOT NULL THEN ', ' END
                     || '"' || REPLACE(p_val, '"', '') || '"';
        END;
    BEGIN
        FOR r IN (SELECT business_unit v FROM prod.ap_invoices_header_v
                   WHERE business_unit IS NOT NULL GROUP BY business_unit ORDER BY 1) LOOP
            app(l_bu, r.v);
        END LOOP;
        FOR r IN (SELECT currency_code v FROM prod.dct_currency_codes
                   WHERE is_active = 'Y' ORDER BY display_order, currency_code) LOOP
            app(l_ccy, r.v);
        END LOOP;

        l_a := q'!{
"openapi": "3.0.0",
"info": {
  "title": "i-Finance Procash Transactions (Excel)",
  "version": "1.0.0",
  "description": "Manual payments pushed through the bank portal directly, outside Fusion Payables. Sheet Single captures one header and one detail line in a single row. Sheets Headers and Lines capture a payment with many lines - a line joins its header on bank_reference. Sheet Invoices fills in the Fusion payable invoice after the fact. Every write obeys the same rules as the web app: only a DRAFT transaction can be edited, lines must add up to the header amount before it is submitted, and only a PROCESSED transaction accepts an invoice number."
},
"servers": [ { "url": "!' || c_base || q'!" } ],
"security": [ { "basicAuth": [] } ],
"paths": {
  "/procash/single/": {
    "get": { "operationId": "listSingle", "summary": "One line payments",
      "parameters": [ { "$ref": "#/components/parameters/status" },
                      { "$ref": "#/components/parameters/bu" },
                      { "$ref": "#/components/parameters/dfrom" },
                      { "$ref": "#/components/parameters/dto" },
                      { "$ref": "#/components/parameters/search" },
                      { "$ref": "#/components/parameters/limit" },
                      { "$ref": "#/components/parameters/offset" } ],
      "responses": { "200": { "description": "rows", "content": { "application/json": { "schema": {
        "type": "object", "properties": { "items": { "type": "array",
          "items": { "$ref": "#/components/schemas/SingleRow" } } } } } } } } },
    "post": { "operationId": "createSingle", "summary": "Create a one line payment",
      "requestBody": { "content": { "application/json": { "schema": { "$ref": "#/components/schemas/SingleRow" } } } },
      "responses": { "200": { "description": "created" } } } },
  "/procash/single/{id}": {
    "parameters": [ { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" } } ],
    "get": { "operationId": "getSingle", "responses": { "200": { "description": "row",
      "content": { "application/json": { "schema": { "$ref": "#/components/schemas/SingleRow" } } } } } },
    "put": { "operationId": "updateSingle",
      "requestBody": { "content": { "application/json": { "schema": { "$ref": "#/components/schemas/SingleRow" } } } },
      "responses": { "200": { "description": "updated" } } } },
  "/procash/headers/": {
    "get": { "operationId": "listHeaders", "summary": "Payment headers",
      "parameters": [ { "$ref": "#/components/parameters/status" },
                      { "$ref": "#/components/parameters/bu" },
                      { "$ref": "#/components/parameters/search" },
                      { "$ref": "#/components/parameters/limit" } ],
      "responses": { "200": { "description": "rows", "content": { "application/json": { "schema": {
        "type": "object", "properties": { "items": { "type": "array",
          "items": { "$ref": "#/components/schemas/HeaderRow" } } } } } } } } },
    "post": { "operationId": "createHeader",
      "requestBody": { "content": { "application/json": { "schema": { "$ref": "#/components/schemas/HeaderRow" } } } },
      "responses": { "200": { "description": "created" } } } },
  "/procash/headers/{id}": {
    "parameters": [ { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" } } ],
    "get": { "operationId": "getHeader", "responses": { "200": { "description": "row",
      "content": { "application/json": { "schema": { "$ref": "#/components/schemas/HeaderRow" } } } } } },
    "put": { "operationId": "updateHeader",
      "requestBody": { "content": { "application/json": { "schema": { "$ref": "#/components/schemas/HeaderRow" } } } },
      "responses": { "200": { "description": "updated" } } } },
  "/procash/lines/": {
    "get": { "operationId": "listLines", "summary": "Detail lines",
      "parameters": [ { "$ref": "#/components/parameters/status" },
                      { "$ref": "#/components/parameters/search" },
                      { "$ref": "#/components/parameters/limit" } ],
      "responses": { "200": { "description": "rows", "content": { "application/json": { "schema": {
        "type": "object", "properties": { "items": { "type": "array",
          "items": { "$ref": "#/components/schemas/LineRow" } } } } } } } } },
    "post": { "operationId": "createLine",
      "requestBody": { "content": { "application/json": { "schema": { "$ref": "#/components/schemas/LineRow" } } } },
      "responses": { "200": { "description": "created" } } } },
  "/procash/lines/{id}": {
    "parameters": [ { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" } } ],
    "get": { "operationId": "getLine", "responses": { "200": { "description": "row",
      "content": { "application/json": { "schema": { "$ref": "#/components/schemas/LineRow" } } } } } },
    "put": { "operationId": "updateLine",
      "requestBody": { "content": { "application/json": { "schema": { "$ref": "#/components/schemas/LineRow" } } } },
      "responses": { "200": { "description": "updated" } } } },
  "/procash/invoices/": {
    "get": { "operationId": "listInvoices", "summary": "Processed payments awaiting their invoice",
      "parameters": [ { "$ref": "#/components/parameters/bu" },
                      { "$ref": "#/components/parameters/search" },
                      { "$ref": "#/components/parameters/limit" } ],
      "responses": { "200": { "description": "rows", "content": { "application/json": { "schema": {
        "type": "object", "properties": { "items": { "type": "array",
          "items": { "$ref": "#/components/schemas/InvoiceRow" } } } } } } } } } },
  "/procash/invoices/{id}": {
    "parameters": [ { "name": "id", "in": "path", "required": true, "schema": { "type": "integer" } } ],
    "get": { "operationId": "getInvoice", "responses": { "200": { "description": "row",
      "content": { "application/json": { "schema": { "$ref": "#/components/schemas/InvoiceRow" } } } } } },
    "put": { "operationId": "updateInvoice", "summary": "Attach the Fusion payable invoice",
      "requestBody": { "content": { "application/json": { "schema": { "$ref": "#/components/schemas/InvoiceRow" } } } },
      "responses": { "200": { "description": "updated" } } } }
},
!';

        l_b := q'!"components": {
"securitySchemes": { "basicAuth": { "type": "http", "scheme": "basic" } },
"parameters": {
  "status": { "name": "status", "in": "query", "schema": { "type": "string" },
              "description": "Status filter, pipe separated for any-of (DRAFT|SUBMITTED)" },
  "bu":     { "name": "bu", "in": "query", "schema": { "type": "string", "enum": [ !' || l_bu || q'! ] },
              "description": "Business unit" },
  "dfrom":  { "name": "from", "in": "query", "schema": { "type": "string", "format": "date" },
              "description": "Payment date from (YYYY-MM-DD)" },
  "dto":    { "name": "to", "in": "query", "schema": { "type": "string", "format": "date" },
              "description": "Payment date to (YYYY-MM-DD)" },
  "search": { "name": "search", "in": "query", "schema": { "type": "string" },
              "description": "Matches bank reference, payment number or payee" },
  "limit":  { "name": "limit", "in": "query", "schema": { "type": "integer", "default": 500 } },
  "offset": { "name": "offset", "in": "query", "schema": { "type": "integer", "default": 0 } }
},
"schemas": {
  "HeaderRow": { "type": "object", "properties": {
    "id":              { "type": "integer", "readOnly": true, "title": "Row Id" },
    "payment_number":  { "type": "string",  "readOnly": true, "title": "Payment Number" },
    "bank_reference":  { "type": "string",  "title": "Bank Reference", "maxLength": 100 },
    "bank_account":    { "type": "string",  "nullable": true, "title": "Paying Bank Account", "maxLength": 200 },
    "business_unit":   { "type": "string",  "title": "Business Unit", "enum": [ !' || l_bu || q'! ] },
    "payee_name":      { "type": "string",  "nullable": true, "title": "Payee", "maxLength": 400 },
    "supplier_number": { "type": "string",  "nullable": true, "title": "Supplier Number", "maxLength": 30 },
    "payment_date":    { "type": "string",  "format": "date", "title": "Payment Date (bank value date)" },
    "currency_code":   { "type": "string",  "title": "Currency", "enum": [ !' || l_ccy || q'! ] },
    "amount":          { "type": "number",  "title": "Amount" },
    "exchange_rate":   { "type": "number",  "nullable": true, "title": "Exchange Rate (blank = current)" },
    "amount_aed":      { "type": "number",  "readOnly": true, "title": "Amount (AED)" },
    "description":     { "type": "string",  "nullable": true, "title": "Description", "maxLength": 1000 },
    "comments":        { "type": "string",  "nullable": true, "title": "Comments", "maxLength": 4000 },
    "status":          { "type": "string",  "readOnly": true, "title": "Status" },
    "line_count":      { "type": "integer", "readOnly": true, "title": "Lines" },
    "line_total":      { "type": "number",  "readOnly": true, "title": "Lines Total" },
    "invoice_number":  { "type": "string",  "readOnly": true, "nullable": true, "title": "Invoice Number" } } },
  "SingleRow": { "allOf": [ { "$ref": "#/components/schemas/HeaderRow" }, { "type": "object", "properties": {
    "line_coding_basis":     { "type": "string", "title": "Line Coding Basis", "enum": [ "PROJECT", "GL" ] },
    "line_project_number":   { "type": "string", "nullable": true, "title": "Line Project" },
    "line_task_number":      { "type": "string", "nullable": true, "title": "Line Task" },
    "line_expenditure_type": { "type": "string", "nullable": true, "title": "Line Expenditure Type" },
    "line_gl_combination":   { "type": "string", "nullable": true, "title": "Line GL Combination" },
    "line_amount":           { "type": "number", "nullable": true, "title": "Line Amount" },
    "line_comments":         { "type": "string", "nullable": true, "title": "Line Comments" } } } ] },
  "LineRow": { "type": "object", "properties": {
    "id":               { "type": "integer", "readOnly": true, "title": "Row Id" },
    "bank_reference":   { "type": "string",  "title": "Bank Reference (the header this line belongs to)" },
    "payment_number":   { "type": "string",  "readOnly": true, "title": "Payment Number" },
    "line_num":         { "type": "integer", "readOnly": true, "title": "Line" },
    "coding_basis":     { "type": "string",  "title": "Coding Basis", "enum": [ "PROJECT", "GL" ] },
    "project_number":   { "type": "string",  "nullable": true, "title": "Project" },
    "task_number":      { "type": "string",  "nullable": true, "title": "Task" },
    "expenditure_type": { "type": "string",  "nullable": true, "title": "Expenditure Type" },
    "gl_combination":   { "type": "string",  "nullable": true, "title": "GL Combination" },
    "amount":           { "type": "number",  "title": "Amount" },
    "comments":         { "type": "string",  "nullable": true, "title": "Comments" },
    "header_status":    { "type": "string",  "readOnly": true, "title": "Header Status" },
    "header_amount":    { "type": "number",  "readOnly": true, "title": "Header Amount" } } },
  "InvoiceRow": { "type": "object", "properties": {
    "id":               { "type": "integer", "readOnly": true, "title": "Row Id" },
    "payment_number":   { "type": "string",  "readOnly": true, "title": "Payment Number" },
    "bank_reference":   { "type": "string",  "readOnly": true, "title": "Bank Reference" },
    "payee_name":       { "type": "string",  "readOnly": true, "nullable": true, "title": "Payee" },
    "business_unit":    { "type": "string",  "readOnly": true, "title": "Business Unit" },
    "payment_date":     { "type": "string",  "readOnly": true, "title": "Payment Date" },
    "currency_code":    { "type": "string",  "readOnly": true, "title": "Currency" },
    "amount":           { "type": "number",  "readOnly": true, "title": "Amount" },
    "status":           { "type": "string",  "readOnly": true, "title": "Status" },
    "invoice_number":   { "type": "string",  "nullable": true, "title": "Fusion Invoice Number" },
    "invoice_date":     { "type": "string",  "readOnly": true, "nullable": true, "title": "Invoice Date" },
    "invoice_amount":   { "type": "number",  "readOnly": true, "nullable": true, "title": "Invoice Amount" },
    "invoice_supplier": { "type": "string",  "readOnly": true, "nullable": true, "title": "Invoice Supplier" },
    "amount_mismatch":  { "type": "string",  "readOnly": true, "nullable": true, "title": "Amount Mismatch" } } }
}
}
}!';

        OWA_UTIL.mime_header('application/json', TRUE);
        WHILE l_pos <= LENGTH(l_a) LOOP
            HTP.prn(SUBSTR(l_a, l_pos, 4000));
            l_pos := l_pos + 4000;
        END LOOP;
        l_pos := 1;
        WHILE l_pos <= LENGTH(l_b) LOOP
            HTP.prn(SUBSTR(l_b, l_pos, 4000));
            l_pos := l_pos + 4000;
        END LOOP;
    END emit_openapi;

END dct_xl_procash_pkg;
/

SHOW ERRORS

PROMPT === verification ===

SELECT object_name, object_type, status FROM all_objects
 WHERE owner = 'PROD' AND object_name = 'DCT_XL_PROCASH_PKG';

SELECT line, position, SUBSTR(text, 1, 120) AS text FROM all_errors
 WHERE owner = 'PROD' AND name = 'DCT_XL_PROCASH_PKG' ORDER BY sequence;
