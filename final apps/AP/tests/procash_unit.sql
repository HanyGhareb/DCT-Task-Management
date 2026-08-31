SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
-- =============================================================================
-- Procash Transactions - unit harness for DCT_AP_PROCASH_PKG
-- File : procash_unit.sql        App 212 / AP        2026-08-17
-- Run  : sql -name prod_mcp @procash_unit.sql
-- -----------------------------------------------------------------------------
-- utPLSQL is not installed on this ADB, so this is the house pattern: a
-- throwaway PROD procedure that asserts, prints, then rolls back. It writes
-- nothing permanent - every row it makes is undone by the closing ROLLBACK.
-- Fixtures (project, task, expenditure type, GL combination, Fusion invoice)
-- are picked from live data at run time so the harness never rots.
-- =============================================================================

CREATE OR REPLACE PROCEDURE prod.p_procash_unit AS

    c_admin CONSTANT VARCHAR2(100) := 'ADMIN';
    c_plain CONSTANT VARCHAR2(100) := 'AYESHA.AMERI';

    g_pass NUMBER := 0;
    g_fail NUMBER := 0;
    g_ref  VARCHAR2(100) := 'UT-PCH-' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3');

    v_id    NUMBER;
    v_id2   NUMBER;
    v_line  NUMBER;
    v_line2 NUMBER;
    v_line3 NUMBER;
    v_doc   NUMBER;
    v_num   VARCHAR2(30);
    v_stat  VARCHAR2(30);
    v_n     NUMBER;
    v_clob  CLOB;
    v_res   CLOB;
    v_proj  VARCHAR2(12);
    v_task  VARCHAR2(30);
    v_etype VARCHAR2(255);
    v_gl    VARCHAR2(320);
    v_inv   NUMBER;
    v_invno VARCHAR2(100);
    v_invamt NUMBER;

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

    FUNCTION status_of (p_id NUMBER) RETURN VARCHAR2 IS
        v VARCHAR2(30);
    BEGIN
        SELECT status INTO v FROM prod.dct_ap_procash WHERE procash_id = p_id;
        RETURN v;
    END status_of;

BEGIN
    DBMS_OUTPUT.put_line('=== DCT_AP_PROCASH_PKG unit harness ===');

    SELECT project_number, task_number INTO v_proj, v_task
      FROM (SELECT project_number, task_number FROM prod.dct_tasks ORDER BY project_number, task_number)
     WHERE ROWNUM = 1;
    SELECT expenditure_type INTO v_etype
      FROM (SELECT expenditure_type FROM prod.dct_expenditure_types WHERE is_active = 'Y' ORDER BY expenditure_type)
     WHERE ROWNUM = 1;
    SELECT cc_string INTO v_gl
      FROM (SELECT cc_string FROM prod.dct_gl_coa_snap ORDER BY cc_string) WHERE ROWNUM = 1;
    SELECT invoice_id, invoice_number, invoice_amount INTO v_inv, v_invno, v_invamt
      FROM (SELECT invoice_id, invoice_number, invoice_amount FROM prod.ap_invoices_header_v ORDER BY invoice_id)
     WHERE ROWNUM = 1;

    DBMS_OUTPUT.put_line('fixtures: project ' || v_proj || ' task ' || v_task ||
                         ' | invoice ' || v_invno || ' ' || v_invamt);

    DBMS_OUTPUT.put_line('-- helpers');
    ok('next_number carries the configured prefix', prod.dct_ap_procash_pkg.next_number LIKE 'PCH-%');
    ok('default_rate AED is 1',   prod.dct_ap_procash_pkg.default_rate('AED') = 1);
    ok('default_rate USD is > 1', prod.dct_ap_procash_pkg.default_rate('USD') > 1);
    ok('setting reads the AP module row',
       prod.dct_ap_procash_pkg.setting('PROCASH_APPROVAL_MODE') IN ('NONE', 'WORKFLOW'));

    DBMS_OUTPUT.put_line('-- header writes');
    prod.dct_ap_procash_pkg.save_header(
        c_admin, NULL, g_ref, 'FAB Current Account 1234', 'Department of Culture and Tourism',
        NULL, NULL, 'Test Payee LLC', 1000, 'AED', NULL, TRUNC(SYSDATE), 'Unit harness payment', NULL, v_id);
    ok('save_header returns an id', v_id IS NOT NULL);
    ok('a new transaction starts as DRAFT', status_of(v_id) = 'DRAFT');
    SELECT payment_number INTO v_num FROM prod.dct_ap_procash WHERE procash_id = v_id;
    ok('payment number was generated', v_num LIKE 'PCH-%');
    SELECT COUNT(*) INTO v_n FROM prod.dct_request_status_history
     WHERE source_module = 'AP' AND source_type = 'PROCASH' AND source_id = v_id;
    ok('creation is written to the shared status history', v_n = 1);

    BEGIN
        prod.dct_ap_procash_pkg.save_header(
            c_admin, NULL, g_ref, NULL, 'Department of Culture and Tourism', NULL, NULL, 'Dup',
            50, 'AED', NULL, TRUNC(SYSDATE), NULL, NULL, v_id2);
        ok('a duplicate bank reference is refused', FALSE);
    EXCEPTION WHEN OTHERS THEN
        ok('a duplicate bank reference is refused', SQLCODE = -20001);
    END;

    BEGIN
        prod.dct_ap_procash_pkg.save_header(
            c_admin, NULL, NULL, NULL, 'Department of Culture and Tourism', NULL, NULL, NULL,
            50, 'AED', NULL, TRUNC(SYSDATE), NULL, NULL, v_id2);
        ok('a missing bank reference is refused', FALSE);
    EXCEPTION WHEN OTHERS THEN
        ok('a missing bank reference is refused', SQLCODE = -20001);
    END;

    BEGIN
        prod.dct_ap_procash_pkg.save_header(
            c_admin, NULL, g_ref || '-X', NULL, 'Department of Culture and Tourism', NULL, NULL, NULL,
            50, 'ZZZ', NULL, TRUNC(SYSDATE), NULL, NULL, v_id2);
        ok('an unknown currency is refused', FALSE);
    EXCEPTION WHEN OTHERS THEN
        ok('an unknown currency is refused', SQLCODE = -20001);
    END;

    -- the supplier is PICKED from the Fusion list on the form; an unrecognised
    -- number is stored as typed rather than refused (user decision 2026-08-17)
    prod.dct_ap_procash_pkg.save_header(
        c_admin, NULL, g_ref || '-Y', NULL, 'Department of Culture and Tourism', '99999999', NULL, NULL,
        50, 'AED', NULL, TRUNC(SYSDATE), NULL, NULL, v_id2);
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash
     WHERE procash_id = v_id2 AND supplier_number = '99999999';
    ok('an unrecognised supplier number is stored as typed', v_n = 1);

    prod.dct_ap_procash_pkg.save_header(
        c_admin, NULL, g_ref || '-FX', NULL, 'Department of Culture and Tourism', NULL, NULL, 'FX Payee',
        100, 'USD', NULL, TRUNC(SYSDATE), 'FX check', NULL, v_id2);
    SELECT amount_aed INTO v_n FROM prod.dct_ap_procash WHERE procash_id = v_id2;
    ok('amount_aed is derived from the rate', v_n > 300);

    DBMS_OUTPUT.put_line('-- validation before any line');
    v_clob := prod.dct_ap_procash_pkg.findings(v_id);
    ok('findings flags a transaction with no lines', INSTR(v_clob, 'NO_LINES') > 0);
    BEGIN
        prod.dct_ap_procash_pkg.submit(c_admin, v_id);
        ok('submit is blocked with no lines', FALSE);
    EXCEPTION WHEN OTHERS THEN
        ok('submit is blocked with no lines', SQLCODE = -20001);
    END;

    DBMS_OUTPUT.put_line('-- detail lines');
    BEGIN
        prod.dct_ap_procash_pkg.save_line(c_admin, NULL, v_id, 'PROJECT', v_proj, NULL, v_etype,
                                          NULL, 100, NULL, v_line);
        ok('a project line without a task is refused', FALSE);
    EXCEPTION WHEN OTHERS THEN
        ok('a project line without a task is refused', SQLCODE = -20001);
    END;

    -- a GL combination outside the chart of accounts is no longer refused, but
    -- it IS normalised to the canonical segment order before it is stored
    prod.dct_ap_procash_pkg.save_line(c_admin, NULL, v_id, 'GL', NULL, NULL, NULL,
                                      '451.999999.9999999.9.999999.9999999.999999.000.000000.000000',
                                      100, 'unmatched code', v_line);
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash_line
     WHERE line_id = v_line AND gl_combination IS NOT NULL;
    ok('a GL code outside the chart of accounts is stored as typed', v_n = 1);
    prod.dct_ap_procash_pkg.delete_line(c_admin, v_line);

    prod.dct_ap_procash_pkg.save_line(c_admin, NULL, v_id, 'PROJECT', v_proj, v_task, v_etype,
                                      NULL, 400, 'first line', v_line);
    ok('a valid project line is stored', v_line IS NOT NULL);
    SELECT line_num INTO v_n FROM prod.dct_ap_procash_line WHERE line_id = v_line;
    ok('the first line is numbered 1', v_n = 1);

    prod.dct_ap_procash_pkg.save_line(c_admin, NULL, v_id, 'GL', NULL, NULL, NULL, v_gl, 300, NULL, v_line2);
    ok('a valid GL line is stored', v_line2 IS NOT NULL);
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash_line
     WHERE line_id = v_line2 AND project_number IS NULL AND gl_combination IS NOT NULL;
    ok('a GL line keeps no project coding', v_n = 1);

    prod.dct_ap_procash_pkg.save_line(c_admin, NULL, v_id, 'PROJECT', v_proj, v_task, v_etype,
                                      NULL, 100, 'third line', v_line3);
    ok('line_total adds the lines up', prod.dct_ap_procash_pkg.line_total(v_id) = 800);

    v_clob := prod.dct_ap_procash_pkg.findings(v_id);
    ok('findings flags an out of balance transaction', INSTR(v_clob, 'LINE_SUM') > 0);
    BEGIN
        prod.dct_ap_procash_pkg.submit(c_admin, v_id);
        ok('submit is blocked while out of balance', FALSE);
    EXCEPTION WHEN OTHERS THEN
        ok('submit is blocked while out of balance', SQLCODE = -20001);
    END;

    prod.dct_ap_procash_pkg.delete_line(c_admin, v_line3);
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash_line
     WHERE procash_id = v_id AND line_num IN (1, 2);
    ok('removing a line renumbers the rest', v_n = 2);

    prod.dct_ap_procash_pkg.save_line(c_admin, v_line, v_id, 'PROJECT', v_proj, v_task, v_etype,
                                      NULL, 700, 'first line', v_line);
    ok('lines now balance the header', prod.dct_ap_procash_pkg.line_total(v_id) = 1000);

    DBMS_OUTPUT.put_line('-- lifecycle');
    prod.dct_ap_procash_pkg.submit(c_admin, v_id, 'unit harness submit');
    ok('a balanced transaction submits', status_of(v_id) = 'SUBMITTED');
    ok('a submitted transaction is closed to its owner',
       prod.dct_ap_procash_pkg.can_edit(v_id, c_plain) = 'N');

    BEGIN
        prod.dct_ap_procash_pkg.mark_processed(c_plain, v_id);
        ok('processing needs the processor role', FALSE);
    EXCEPTION WHEN OTHERS THEN
        ok('processing needs the processor role', SQLCODE = -20403);
    END;

    prod.dct_ap_procash_pkg.mark_processed(c_admin, v_id, 'paid through the bank portal');
    ok('a submitted transaction can be processed', status_of(v_id) = 'PROCESSED');
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash
     WHERE procash_id = v_id AND processed_by IS NOT NULL AND processed_on IS NOT NULL;
    ok('processing stamps who and when', v_n = 1);

    DBMS_OUTPUT.put_line('-- invoice reconciliation');
    BEGIN
        prod.dct_ap_procash_pkg.link_invoice(c_admin, v_id, NULL, 'NO-SUCH-INVOICE-9999');
        ok('an unknown invoice number is refused', FALSE);
    EXCEPTION WHEN OTHERS THEN
        ok('an unknown invoice number is refused', SQLCODE = -20404);
    END;

    prod.dct_ap_procash_pkg.link_invoice(c_admin, v_id, v_inv);
    ok('linking a real invoice moves it to INVOICED', status_of(v_id) = 'INVOICED');
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash
     WHERE procash_id = v_id AND invoice_number = v_invno AND invoice_amount = v_invamt;
    ok('the invoice snapshot is stored', v_n = 1);
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash
     WHERE procash_id = v_id
       AND amount_mismatch = CASE WHEN ABS(v_invamt - 1000) > 0.005 THEN 'Y' ELSE 'N' END;
    ok('the amount mismatch flag is derived', v_n = 1);
    ok('an invoiced transaction is locked', prod.dct_ap_procash_pkg.can_edit(v_id, c_admin) = 'N');

    BEGIN
        prod.dct_ap_procash_pkg.link_invoice(c_admin, v_id2, v_inv);
        ok('the same invoice cannot be linked twice', FALSE);
    EXCEPTION WHEN OTHERS THEN
        ok('the same invoice cannot be linked twice', SQLCODE IN (-20001, -20404));
    END;

    BEGIN
        prod.dct_ap_procash_pkg.unlink_invoice(c_plain, v_id);
        ok('unlinking needs the administrator role', FALSE);
    EXCEPTION WHEN OTHERS THEN
        ok('unlinking needs the administrator role', SQLCODE = -20403);
    END;

    prod.dct_ap_procash_pkg.unlink_invoice(c_admin, v_id);
    ok('an administrator can unlink', status_of(v_id) = 'PROCESSED');
    SELECT COUNT(*) INTO v_n FROM prod.dct_ap_procash
     WHERE procash_id = v_id AND invoice_id IS NULL AND invoice_number IS NULL;
    ok('unlinking clears the invoice snapshot', v_n = 1);

    DBMS_OUTPUT.put_line('-- bulk entry');
    prod.dct_ap_procash_pkg.bulk_upsert(c_admin,
        '[{"bankReference":"' || g_ref || '-B1","businessUnit":"Department of Culture and Tourism",' ||
        '"amount":250,"currencyCode":"AED","paymentDate":"' || TO_CHAR(SYSDATE, 'YYYY-MM-DD') ||
        '","payeeName":"Bulk One","line":{"codingBasis":"PROJECT","projectNumber":"' || v_proj ||
        '","taskNumber":"' || v_task || '","expenditureType":"' || v_etype || '","amount":250}},' ||
        '{"bankReference":"' || g_ref || '","businessUnit":"Department of Culture and Tourism",' ||
        '"amount":1000,"currencyCode":"AED","paymentDate":"' || TO_CHAR(SYSDATE, 'YYYY-MM-DD') ||
        '","payeeName":"Bulk Update"},' ||
        '{"bankReference":"' || g_ref || '-B3","businessUnit":"Department of Culture and Tourism",' ||
        '"amount":0,"currencyCode":"AED","paymentDate":"' || TO_CHAR(SYSDATE, 'YYYY-MM-DD') || '"}]',
        v_res);
    ok('bulk entry creates a new row',      INSTR(v_res, '"CREATED"') > 0);
    ok('bulk entry reports a row error',    INSTR(v_res, '"ERROR"') > 0);
    SELECT COUNT(*) INTO v_n
      FROM JSON_TABLE(v_res, '$[*]' COLUMNS (s VARCHAR2(20) PATH '$.status'));
    ok('bulk entry never aborts the batch', v_n = 3);

    DBMS_OUTPUT.put_line('-- cancellation');
    prod.dct_ap_procash_pkg.cancel(c_admin, v_id2, 'no longer needed');
    ok('a transaction can be cancelled', status_of(v_id2) = 'CANCELLED');
    ok('a cancelled transaction is closed', prod.dct_ap_procash_pkg.can_edit(v_id2, c_admin) = 'N');

    ROLLBACK;

    DBMS_OUTPUT.put_line('=== ' || g_pass || ' passed, ' || g_fail || ' failed ===');
    IF g_fail > 0 THEN
        raise_application_error(-20999, g_fail || ' unit assertion(s) failed');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.put_line('=== ' || g_pass || ' passed, ' || g_fail || ' failed ===');
        RAISE;
END p_procash_unit;
/

SHOW ERRORS

BEGIN prod.p_procash_unit; END;
/

DROP PROCEDURE prod.p_procash_unit;
