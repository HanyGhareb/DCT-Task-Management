SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
-- =============================================================================
-- Procash Transactions - Excel (Visual Builder Add-in) layer test
-- File : procash_xl_test.sql        App 212 / AP        2026-08-17
-- Run  : sql -name prod_mcp @procash_xl_test.sql
-- -----------------------------------------------------------------------------
-- Drives DCT_XL_PROCASH_PKG the way the add-in does - a JSON body per row -
-- and then checks what actually landed in the tables. HTTP Basic auth and the
-- OpenAPI document are verified separately over curl (they need no data).
--
-- The emitted JSON goes to the HTP buffer, which is inert in a SQLcl session;
-- what matters here is the WRITE path, so every assertion reads the tables.
--
-- A refused Excel write ROLLS BACK (each ORDS request is its own transaction),
-- which would also undo this harness's fixtures - so the fixtures are COMMITTED
-- as they are built and removed explicitly at the end, exactly like the API
-- suite does.
-- =============================================================================

CREATE OR REPLACE PROCEDURE prod.p_procash_xl_test AS

    c_admin CONSTANT VARCHAR2(100) := 'ADMIN';
    g_pass NUMBER := 0;
    g_fail NUMBER := 0;
    g_ref  VARCHAR2(100) := 'XL-PCH-' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3');

    v_uid   NUMBER;
    v_id    NUMBER;
    v_n     NUMBER;
    v_amt   NUMBER;
    v_basis VARCHAR2(10);
    v_stat  VARCHAR2(30);
    v_proj  VARCHAR2(12);
    v_task  VARCHAR2(30);
    v_etype VARCHAR2(255);
    v_bu    VARCHAR2(240);
    v_gl    VARCHAR2(320);
    v_invno VARCHAR2(100);

    PROCEDURE ok (p_name VARCHAR2, p_cond BOOLEAN) IS
    BEGIN
        IF p_cond THEN
            g_pass := g_pass + 1;
            DBMS_OUTPUT.put_line('  PASS  ' || p_name);
        ELSE
            g_fail := g_fail + 1;
            DBMS_OUTPUT.put_line('  FAIL  ' || p_name);
        END IF;
    END ok;

    FUNCTION body (p_json VARCHAR2) RETURN BLOB IS
        v BLOB;
    BEGIN
        v := UTL_RAW.cast_to_raw(p_json);
        RETURN v;
    END body;

    -- the package writes HTTP headers; outside ORDS the OWA CGI environment
    -- has to be primed by hand or OWA_UTIL.mime_header raises ORA-06502
    PROCEDURE owa_env IS
        nm OWA.vc_arr;
        vl OWA.vc_arr;
    BEGIN
        nm(1) := 'REQUEST_PROTOCOL'; vl(1) := 'HTTP';
        nm(2) := 'REQUEST_METHOD';   vl(2) := 'GET';
        OWA.init_cgi_env(2, nm, vl);
        HTP.init;
    END owa_env;

BEGIN
    owa_env;
    DBMS_OUTPUT.put_line('=== DCT_XL_PROCASH_PKG (Excel add-in) test ===');

    SELECT user_id INTO v_uid FROM prod.dct_users WHERE username = c_admin;
    SELECT project_number, task_number INTO v_proj, v_task
      FROM (SELECT project_number, task_number FROM prod.dct_tasks ORDER BY project_number, task_number)
     WHERE ROWNUM = 1;
    SELECT expenditure_type INTO v_etype
      FROM (SELECT expenditure_type FROM prod.dct_expenditure_types WHERE is_active = 'Y'
             ORDER BY expenditure_type) WHERE ROWNUM = 1;
    SELECT business_unit INTO v_bu
      FROM (SELECT business_unit FROM prod.ap_invoices_header_v
             WHERE business_unit IS NOT NULL GROUP BY business_unit ORDER BY business_unit)
     WHERE ROWNUM = 1;

    DBMS_OUTPUT.put_line('-- sheet 1: one header and one line in one row');
    prod.dct_xl_procash_pkg.create_item(v_uid, 'single', body(
        '{"bank_reference":"' || g_ref || '","business_unit":"' || v_bu ||
        '","payee_name":"Excel Sheet Payee","amount":1200,"currency_code":"AED","payment_date":"' ||
        TO_CHAR(SYSDATE, 'YYYY-MM-DD') || '","description":"from the single sheet",' ||
        '"line_coding_basis":"PROJECT","line_project_number":"' || v_proj ||
        '","line_task_number":"' || v_task || '","line_expenditure_type":"' || v_etype ||
        '","line_amount":1200}'));

    COMMIT;
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash WHERE bank_reference = g_ref;
    ok('the single sheet creates the header', v_n = 1);
    SELECT procash_id INTO v_id FROM prod.dct_ap_procash WHERE bank_reference = g_ref;
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash_line WHERE procash_id = v_id;
    ok('the single sheet creates its detail line in the same row', v_n = 1);
    ok('the line balances the header on creation',
       prod.dct_ap_procash_pkg.line_total(v_id) = 1200);
    SELECT payment_number INTO v_stat FROM prod.dct_ap_procash WHERE procash_id = v_id;
    ok('a payment number is stamped for the Excel row', v_stat LIKE 'PCH-%');

    DBMS_OUTPUT.put_line('-- an absent key keeps the stored value');
    prod.dct_xl_procash_pkg.save_item(v_uid, 'single', TO_CHAR(v_id),
        body('{"description":"edited from Excel"}'));
    COMMIT;
    SELECT amount, business_unit INTO v_amt, v_stat FROM prod.dct_ap_procash WHERE procash_id = v_id;
    ok('a partial Excel update keeps the amount', v_amt = 1200);
    ok('a partial Excel update keeps the business unit', v_stat = v_bu);
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash
     WHERE procash_id = v_id AND description = 'edited from Excel';
    ok('the edited field is written', v_n = 1);

    DBMS_OUTPUT.put_line('-- sheet 2: extra lines joined on the bank reference');
    prod.dct_xl_procash_pkg.create_item(v_uid, 'lines', body(
        '{"bank_reference":"' || g_ref || '","coding_basis":"PROJECT","project_number":"' || v_proj ||
        '","task_number":"' || v_task || '","expenditure_type":"' || v_etype ||
        '","amount":300,"comments":"second line from Excel"}'));
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash_line WHERE procash_id = v_id;
    ok('a line row is attached to its header by bank reference', v_n = 2);
    ok('the line total follows the Excel rows',
       prod.dct_ap_procash_pkg.line_total(v_id) = 1500);

    DBMS_OUTPUT.put_line('-- an unknown bank reference is refused');
    prod.dct_xl_procash_pkg.create_item(v_uid, 'lines', body(
        '{"bank_reference":"NO-SUCH-REF-9999","coding_basis":"PROJECT","amount":50}'));
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash_line l
      JOIN prod.dct_ap_procash h ON h.procash_id = l.procash_id
     WHERE h.bank_reference = 'NO-SUCH-REF-9999';
    ok('an orphan line is never created', v_n = 0);

    DBMS_OUTPUT.put_line('-- the coding rules are the same ones the web app uses');
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash_line WHERE procash_id = v_id;
    prod.dct_xl_procash_pkg.create_item(v_uid, 'lines', body(
        '{"bank_reference":"' || g_ref || '","coding_basis":"PROJECT","project_number":"' || v_proj ||
        '","amount":100}'));
    SELECT COUNT(*) - v_n INTO v_n FROM prod.dct_ap_procash_line WHERE procash_id = v_id;
    ok('a project line with no task is refused from Excel too', v_n = 0);

    DBMS_OUTPUT.put_line('-- a GL line coded from Excel');
    SELECT cc_string INTO v_gl
      FROM (SELECT cc_string FROM prod.dct_gl_coa_snap ORDER BY cc_string) WHERE ROWNUM = 1;
    prod.dct_xl_procash_pkg.create_item(v_uid, 'lines', body(
        '{"bank_reference":"' || g_ref || '","coding_basis":"GL","gl_combination":"' ||
        v_gl || '","amount":200}'));
    COMMIT;
    SELECT coding_basis INTO v_basis FROM prod.dct_ap_procash_line
     WHERE procash_id = v_id AND line_num = 3;
    ok('a GL coded line is accepted', v_basis = 'GL');

    DBMS_OUTPUT.put_line('-- sheet 3: the invoice update');
    prod.dct_xl_procash_pkg.save_item(v_uid, 'invoices', TO_CHAR(v_id),
        body('{"invoice_number":"SOME-INVOICE"}'));
    SELECT status INTO v_stat FROM prod.dct_ap_procash WHERE procash_id = v_id;
    ok('a draft transaction refuses an invoice number', v_stat = 'DRAFT');

    UPDATE prod.dct_ap_procash SET amount = 1700 WHERE procash_id = v_id;
    prod.dct_ap_procash_pkg.submit(c_admin, v_id, 'excel test');
    prod.dct_ap_procash_pkg.mark_processed(c_admin, v_id, 'excel test');
    COMMIT;
    prod.dct_xl_procash_pkg.save_item(v_uid, 'invoices', TO_CHAR(v_id),
        body('{"invoice_number":"NO-SUCH-INVOICE-12345"}'));
    SELECT status INTO v_stat FROM prod.dct_ap_procash WHERE procash_id = v_id;
    ok('an invoice number that is not in the extract is refused', v_stat = 'PROCESSED');

    SELECT invoice_number INTO v_invno
      FROM (SELECT invoice_number FROM prod.ap_invoices_header_v
             WHERE invoice_number NOT IN (SELECT NVL(invoice_number, 'x') FROM prod.dct_ap_procash)
             GROUP BY invoice_number HAVING COUNT(*) = 1 ORDER BY invoice_number)
     WHERE ROWNUM = 1;
    prod.dct_xl_procash_pkg.save_item(v_uid, 'invoices', TO_CHAR(v_id), body(
        '{"invoice_number":"' || v_invno || '"}'));
    SELECT status INTO v_stat FROM prod.dct_ap_procash WHERE procash_id = v_id;
    ok('a real invoice number reconciles the payment from Excel', v_stat = 'INVOICED');
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash
     WHERE procash_id = v_id AND invoice_id IS NOT NULL AND invoice_amount IS NOT NULL;
    ok('the invoice snapshot is captured', v_n = 1);
    COMMIT;

    DBMS_OUTPUT.put_line('-- an invoiced transaction is closed to Excel edits');
    prod.dct_xl_procash_pkg.save_item(v_uid, 'single', TO_CHAR(v_id),
        body('{"payee_name":"should not stick"}'));
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash
     WHERE procash_id = v_id AND payee_name = 'should not stick';
    ok('an invoiced row cannot be edited from Excel', v_n = 0);

    DELETE FROM prod.dct_request_status_history
     WHERE source_module = 'AP' AND source_type = 'PROCASH' AND source_id = v_id;
    DELETE FROM prod.dct_ap_procash WHERE procash_id = v_id;
    COMMIT;
    DBMS_OUTPUT.put_line('=== ' || g_pass || ' passed, ' || g_fail || ' failed ===');
    IF g_fail > 0 THEN
        raise_application_error(-20999, g_fail || ' Excel-layer assertion(s) failed');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        IF v_id IS NOT NULL THEN
            DELETE FROM prod.dct_request_status_history
             WHERE source_module = 'AP' AND source_type = 'PROCASH' AND source_id = v_id;
            DELETE FROM prod.dct_ap_procash WHERE procash_id = v_id;
            COMMIT;
        END IF;
        DBMS_OUTPUT.put_line('=== ' || g_pass || ' passed, ' || g_fail || ' failed ===');
        RAISE;
END p_procash_xl_test;
/

SHOW ERRORS

BEGIN prod.p_procash_xl_test; END;
/

DROP PROCEDURE prod.p_procash_xl_test;
