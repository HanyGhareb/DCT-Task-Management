-- =============================================================================
-- Accounts Payable (App 212) -- line / distribution level register (ADDITIVE)
-- File    : 04_ap_level_ords.sql
-- Adds to : ap.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @04_ap_level_ords.sql   (fresh session)
-- IMPORTANT: 03_ap_ords.sql rebuilds ap.rest from scratch -- whenever 03 is
--           re-run, re-run THIS script right after it.
-- Purpose : the dashboard level selector (Header / Line / Distribution) needs
--           the register at all three grains. Header grain = /ap/invoices
--           (03). This script adds the other two, same facet params:
--   GET /ap/lines            paged invoice-line rows {items,total,totals,...}
--   GET /ap/lines/export     CSV download (25k cap)
--   GET /ap/dists            paged distribution rows {items,total,totals,...}
--   GET /ap/dists/export     CSV download (25k cap)
-- Notes   : header-grain facets narrow via dct_ap_pkg.filtered_ids; facets
--           that live on the row's own grain are re-applied to the rows
--           directly (lines: dept/project/task/etype/po; dists: sector/cc/
--           project/task/etype/account/approp/po/pr/req) so a filtered
--           line/dist view only shows the matching rows, not whole invoices.
--           Dist rows also expose the EFFECTIVE charge account: for
--           PO-matched invoices it comes from the PO distribution line
--           (po_lines.order_number/line -> po_distributions schedule/
--           distribution_number), AP dist charge as fallback; glCombination
--           = prod.dct_cc_canon of that value + chargeSource PO/AP, plus the
--           full invoice-detail columns (description/pay group/terms/etc).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

-- ========================= part 1: lines register ===========================
CREATE OR REPLACE PROCEDURE setup_ap_lvl_t1 AS
    c_mod CONSTANT VARCHAR2(30) := 'ap.rest';
    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    def_template('lines');
    def_handler('lines', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_ids    apex_t_number;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 50), 10000);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_sort   VARCHAR2(30) := LOWER([COLON]sort);
  l_cnt NUMBER; l_amt NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_ids := prod.dct_ap_pkg.filtered_ids(
    p_datefrom => [COLON]datefrom, p_dateto => [COLON]dateto, p_supplier => [COLON]supplier,
    p_paid => [COLON]paid, p_val => [COLON]val, p_acc => [COLON]acc, p_inv => [COLON]inv,
    p_itype => [COLON]itype, p_curr => [COLON]curr, p_paygroup => [COLON]paygroup,
    p_paymethod => [COLON]paymethod, p_sector => [COLON]sector, p_dept => [COLON]dept,
    p_cc => [COLON]cc, p_project => [COLON]project, p_task => [COLON]task,
    p_etype => [COLON]etype, p_account => [COLON]account, p_approp => [COLON]approp,
    p_po => [COLON]po, p_pr => [COLON]pr, p_req => [COLON]req, p_search => [COLON]search,
    p_gldatefrom => [COLON]glfrom, p_gldateto => [COLON]glto,
    p_rcvfrom => [COLON]rcvfrom, p_rcvto => [COLON]rcvto,
    p_esupplier => [COLON]esupplier, p_aging => [COLON]aging, p_inclcxl => [COLON]inclcxl);
  SELECT COUNT(*), NVL(SUM(ln.line_amount_aed),0) INTO l_cnt, l_amt
    FROM prod.ap_invoice_lines_v ln
   WHERE ln.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
     AND ([COLON]dept IS NULL OR prod.dct_ap_pkg.in_list([COLON]dept, ln.expenditure_organization) = 1)
     AND ([COLON]project IS NULL OR prod.dct_ap_pkg.in_list([COLON]project, ln.project_number) = 1)
     AND ([COLON]task IS NULL OR UPPER(ln.task_number) = UPPER(TRIM([COLON]task)))
     AND ([COLON]etype IS NULL OR prod.dct_ap_pkg.in_list([COLON]etype, ln.expenditure_type) = 1)
     AND ([COLON]po IS NULL OR TO_CHAR(ln.po_number) = TRIM([COLON]po));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_cnt); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_object('totals'); APEX_JSON.write('amountAed', ROUND(l_amt,2)); APEX_JSON.close_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT ln.invoice_id, ln.invoice_number, TO_CHAR(ln.invoice_date,'YYYY-MM-DD') inv_dt,
           CASE WHEN ln.supplier_name = 'BENEFICIARY' AND ln.beneficiary_name IS NOT NULL
                THEN ln.beneficiary_name ELSE ln.supplier_name END supplier_name,
           CASE WHEN ln.supplier_name = 'BENEFICIARY' THEN 'Y' ELSE 'N' END is_beneficiary,
           ln.invoice_type, ln.invoice_status, ln.validation_status, ln.accounting_status, ln.payment_status,
           ln.invoice_line_number, ln.invoice_line_type, ln.line_description, ln.invoice_currency,
           ln.line_amount, ln.line_amount_aed, NVL(ln.active_holds,0) active_holds, ln.fund_status,
           ln.po_number, ln.po_line_number, ln.receipt_number, ln.project_number, ln.project_name,
           ln.task_number, ln.task_name, ln.expenditure_type, ln.expenditure_organization, ln.period_name
      FROM prod.ap_invoice_lines_v ln
     WHERE ln.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
       AND ([COLON]dept IS NULL OR prod.dct_ap_pkg.in_list([COLON]dept, ln.expenditure_organization) = 1)
       AND ([COLON]project IS NULL OR prod.dct_ap_pkg.in_list([COLON]project, ln.project_number) = 1)
       AND ([COLON]task IS NULL OR UPPER(ln.task_number) = UPPER(TRIM([COLON]task)))
       AND ([COLON]etype IS NULL OR prod.dct_ap_pkg.in_list([COLON]etype, ln.expenditure_type) = 1)
       AND ([COLON]po IS NULL OR TO_CHAR(ln.po_number) = TRIM([COLON]po))
     ORDER BY CASE WHEN l_sort = 'date_asc'    THEN ln.invoice_date END ASC,
              CASE WHEN l_sort = 'amount_desc' THEN ln.line_amount_aed END DESC,
              CASE WHEN l_sort = 'amount_asc'  THEN ln.line_amount_aed END ASC,
              ln.invoice_date DESC, ln.invoice_id DESC, ln.invoice_line_number
     OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY)
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.invoice_id);
    APEX_JSON.write('invoiceNumber', r.invoice_number); APEX_JSON.write('invoiceDate', r.inv_dt);
    APEX_JSON.write('supplier', r.supplier_name);
    APEX_JSON.write('isBeneficiary', r.is_beneficiary);
    APEX_JSON.write('invoiceType', r.invoice_type);
    APEX_JSON.write('invoiceStatus', r.invoice_status); APEX_JSON.write('validationStatus', r.validation_status);
    APEX_JSON.write('accountingStatus', r.accounting_status); APEX_JSON.write('paymentStatus', r.payment_status);
    APEX_JSON.write('lineNumber', r.invoice_line_number); APEX_JSON.write('lineType', r.invoice_line_type);
    APEX_JSON.write('description', r.line_description); APEX_JSON.write('currency', r.invoice_currency);
    APEX_JSON.write('amount', r.line_amount); APEX_JSON.write('amountAed', r.line_amount_aed);
    APEX_JSON.write('activeHolds', r.active_holds); APEX_JSON.write('fundStatus', r.fund_status);
    APEX_JSON.write('poNumber', r.po_number); APEX_JSON.write('poLine', r.po_line_number);
    APEX_JSON.write('receiptNumber', r.receipt_number);
    APEX_JSON.write('projectNumber', r.project_number); APEX_JSON.write('projectName', r.project_name);
    APEX_JSON.write('taskNumber', r.task_number); APEX_JSON.write('taskName', r.task_name);
    APEX_JSON.write('expType', r.expenditure_type); APEX_JSON.write('department', r.expenditure_organization);
    APEX_JSON.write('period', r.period_name);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
    COMMIT;
END setup_ap_lvl_t1;
/

BEGIN setup_ap_lvl_t1; END;
/
DROP PROCEDURE setup_ap_lvl_t1;

PROMPT level part 1 done (lines register)

-- ========================= part 2: lines csv export =========================
CREATE OR REPLACE PROCEDURE setup_ap_lvl_t2 AS
    c_mod CONSTANT VARCHAR2(30) := 'ap.rest';
    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    def_template('lines/export');
    def_handler('lines/export', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_ids  apex_t_number;
  FUNCTION esc(p VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF p IS NULL THEN RETURN NULL; END IF;
    IF INSTR(p, '"') > 0 OR INSTR(p, ',') > 0 OR INSTR(p, CHR(10)) > 0 THEN
      RETURN '"' || REPLACE(p, '"', '""') || '"';
    END IF;
    RETURN p;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_ids := prod.dct_ap_pkg.filtered_ids(
    p_datefrom => [COLON]datefrom, p_dateto => [COLON]dateto, p_supplier => [COLON]supplier,
    p_paid => [COLON]paid, p_val => [COLON]val, p_acc => [COLON]acc, p_inv => [COLON]inv,
    p_itype => [COLON]itype, p_curr => [COLON]curr, p_paygroup => [COLON]paygroup,
    p_paymethod => [COLON]paymethod, p_sector => [COLON]sector, p_dept => [COLON]dept,
    p_cc => [COLON]cc, p_project => [COLON]project, p_task => [COLON]task,
    p_etype => [COLON]etype, p_account => [COLON]account, p_approp => [COLON]approp,
    p_po => [COLON]po, p_pr => [COLON]pr, p_req => [COLON]req, p_search => [COLON]search,
    p_gldatefrom => [COLON]glfrom, p_gldateto => [COLON]glto,
    p_rcvfrom => [COLON]rcvfrom, p_rcvto => [COLON]rcvto,
    p_esupplier => [COLON]esupplier, p_aging => [COLON]aging, p_inclcxl => [COLON]inclcxl);
  OWA_UTIL.mime_header('text/csv', FALSE, 'UTF-8');
  HTP.p('Content-Disposition: attachment; filename="ap-lines-' || TO_CHAR(SYSDATE,'YYYY-MM-DD') || '.csv"');
  OWA_UTIL.http_header_close;
  HTP.prn(UNISTR('\FEFF'));
  HTP.print('Invoice Number,Invoice Date,Supplier,Is Beneficiary,Line,Line Type,Description,Currency,Line Amount,Line Amount AED,Fund Status,Active Holds,PO Number,PO Line,Receipt,Project,Project Name,Task,Task Name,Expenditure Type,Department,Period,Validation,Accounting,Paid Status');
  FOR r IN (
    SELECT ln.invoice_number, TO_CHAR(ln.invoice_date,'YYYY-MM-DD') inv_dt,
           CASE WHEN ln.supplier_name = 'BENEFICIARY' AND ln.beneficiary_name IS NOT NULL
                THEN ln.beneficiary_name ELSE ln.supplier_name END supplier_name,
           CASE WHEN ln.supplier_name = 'BENEFICIARY' THEN 'Y' ELSE 'N' END is_beneficiary,
           ln.invoice_line_number, ln.invoice_line_type, ln.line_description, ln.invoice_currency,
           ln.line_amount, ln.line_amount_aed, ln.fund_status, NVL(ln.active_holds,0) active_holds,
           ln.po_number, ln.po_line_number, ln.receipt_number, ln.project_number, ln.project_name,
           ln.task_number, ln.task_name, ln.expenditure_type, ln.expenditure_organization, ln.period_name,
           ln.validation_status, ln.accounting_status, ln.payment_status
      FROM prod.ap_invoice_lines_v ln
     WHERE ln.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
       AND ([COLON]dept IS NULL OR prod.dct_ap_pkg.in_list([COLON]dept, ln.expenditure_organization) = 1)
       AND ([COLON]project IS NULL OR prod.dct_ap_pkg.in_list([COLON]project, ln.project_number) = 1)
       AND ([COLON]task IS NULL OR UPPER(ln.task_number) = UPPER(TRIM([COLON]task)))
       AND ([COLON]etype IS NULL OR prod.dct_ap_pkg.in_list([COLON]etype, ln.expenditure_type) = 1)
       AND ([COLON]po IS NULL OR TO_CHAR(ln.po_number) = TRIM([COLON]po))
     ORDER BY ln.invoice_date DESC, ln.invoice_id DESC, ln.invoice_line_number
     FETCH FIRST 25000 ROWS ONLY)
  LOOP
    HTP.print(
      esc(r.invoice_number) || ',' || r.inv_dt || ',' || esc(r.supplier_name) || ',' || r.is_beneficiary || ',' ||
      r.invoice_line_number || ',' || esc(r.invoice_line_type) || ',' || esc(r.line_description) || ',' ||
      r.invoice_currency || ',' || r.line_amount || ',' || r.line_amount_aed || ',' ||
      esc(r.fund_status) || ',' || r.active_holds || ',' || r.po_number || ',' || r.po_line_number || ',' ||
      r.receipt_number || ',' || esc(r.project_number) || ',' || esc(r.project_name) || ',' ||
      esc(r.task_number) || ',' || esc(r.task_name) || ',' || esc(r.expenditure_type) || ',' ||
      esc(r.expenditure_organization) || ',' || esc(r.period_name) || ',' ||
      esc(r.validation_status) || ',' || esc(r.accounting_status) || ',' || esc(r.payment_status));
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
    COMMIT;
END setup_ap_lvl_t2;
/

BEGIN setup_ap_lvl_t2; END;
/
DROP PROCEDURE setup_ap_lvl_t2;

PROMPT level part 2 done (lines export)

-- ========================= part 3: dists register ===========================
CREATE OR REPLACE PROCEDURE setup_ap_lvl_t3 AS
    c_mod CONSTANT VARCHAR2(30) := 'ap.rest';
    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    def_template('dists');
    def_handler('dists', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_ids    apex_t_number;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 50), 10000);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_sort   VARCHAR2(30) := LOWER([COLON]sort);
  l_cnt NUMBER; l_amt NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_ids := prod.dct_ap_pkg.filtered_ids(
    p_datefrom => [COLON]datefrom, p_dateto => [COLON]dateto, p_supplier => [COLON]supplier,
    p_paid => [COLON]paid, p_val => [COLON]val, p_acc => [COLON]acc, p_inv => [COLON]inv,
    p_itype => [COLON]itype, p_curr => [COLON]curr, p_paygroup => [COLON]paygroup,
    p_paymethod => [COLON]paymethod, p_sector => [COLON]sector, p_dept => [COLON]dept,
    p_cc => [COLON]cc, p_project => [COLON]project, p_task => [COLON]task,
    p_etype => [COLON]etype, p_account => [COLON]account, p_approp => [COLON]approp,
    p_po => [COLON]po, p_pr => [COLON]pr, p_req => [COLON]req, p_search => [COLON]search,
    p_gldatefrom => [COLON]glfrom, p_gldateto => [COLON]glto,
    p_rcvfrom => [COLON]rcvfrom, p_rcvto => [COLON]rcvto,
    p_esupplier => [COLON]esupplier, p_aging => [COLON]aging, p_inclcxl => [COLON]inclcxl);
  SELECT COUNT(*), NVL(SUM(d.distribution_amount_aed),0) INTO l_cnt, l_amt
    FROM prod.ap_invoice_distributions_v d
   WHERE d.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
     AND ([COLON]sector IS NULL OR prod.dct_ap_pkg.in_list([COLON]sector, NVL(d.sector_name,'Unclassified')) = 1)
     AND ([COLON]cc IS NULL OR prod.dct_ap_pkg.in_list([COLON]cc, d.cost_center_code) = 1)
     AND ([COLON]project IS NULL OR prod.dct_ap_pkg.in_list([COLON]project, d.project_number) = 1)
     AND ([COLON]task IS NULL OR UPPER(d.task_number) = UPPER(TRIM([COLON]task)))
     AND ([COLON]etype IS NULL OR prod.dct_ap_pkg.in_list([COLON]etype, d.expenditure_type) = 1)
     AND ([COLON]account IS NULL OR prod.dct_ap_pkg.in_list([COLON]account, d.account_code) = 1)
     AND ([COLON]approp IS NULL OR prod.dct_ap_pkg.in_list([COLON]approp, d.appropriation_code) = 1)
     AND ([COLON]po IS NULL OR TO_CHAR(d.po_number) = TRIM([COLON]po))
     AND ([COLON]pr IS NULL OR TO_CHAR(d.pr_number) = TRIM([COLON]pr))
     AND ([COLON]req IS NULL OR prod.dct_ap_pkg.in_list([COLON]req, d.pr_preparer) = 1);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_cnt); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_object('totals'); APEX_JSON.write('amountAed', ROUND(l_amt,2)); APEX_JSON.close_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT d.invoice_id, d.invoice_number, TO_CHAR(d.invoice_date,'YYYY-MM-DD') inv_dt,
           CASE WHEN d.supplier_name = 'BENEFICIARY' AND d.beneficiary_name IS NOT NULL
                THEN d.beneficiary_name ELSE d.supplier_name END supplier_name,
           CASE WHEN d.supplier_name = 'BENEFICIARY' THEN 'Y' ELSE 'N' END is_beneficiary,
           d.validation_status, d.accounting_status, d.payment_status, d.invoice_type,
           d.invoice_line_number, d.distribution_line_number, d.distribution_type,
           d.distribution_description, d.invoice_currency, d.distribution_amount, d.distribution_amount_aed,
           d.distribution_status, d.posting_status, d.fund_status,
           TO_CHAR(d.accounting_date,'YYYY-MM-DD') acct_dt, d.period_name,
           d.po_number, d.pr_number, d.pr_preparer, d.project_number, d.project_name,
           d.task_number, d.expenditure_type, d.account_code, d.account_desc,
           d.cost_center_code, d.cost_center_desc, d.appropriation_code, d.appropriation_desc,
           d.sector_name, d.chapter_name, d.program_name,
           d.charge_account, prod.dct_cc_canon(pd.charge_account) po_charge_account,
           prod.dct_cc_canon(COALESCE(pd.charge_account, d.charge_account)) gl_combination,
           CASE WHEN pd.charge_account IS NOT NULL THEN 'PO' ELSE 'AP' END charge_source,
           h.invoice_description, h.pay_group, h.payment_method,
           TO_CHAR(h.terms_date,'YYYY-MM-DD') terms_dt, h.funds_status inv_funds, h.voucher_num
      FROM prod.ap_invoice_distributions_v d
      LEFT JOIN prod.ap_invoices_header_v h ON h.invoice_id = d.invoice_id
      LEFT JOIN prod.po_lines pl
             ON TO_CHAR(pl.order_number) = TO_CHAR(d.po_number) AND pl.line = d.po_line
      LEFT JOIN prod.po_distributions pd
             ON pd.po_line_id = pl.po_line_id AND pd.schedule = d.po_schedule
            AND pd.distribution_number = d.po_distribution_line
     WHERE d.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
       AND ([COLON]sector IS NULL OR prod.dct_ap_pkg.in_list([COLON]sector, NVL(d.sector_name,'Unclassified')) = 1)
       AND ([COLON]cc IS NULL OR prod.dct_ap_pkg.in_list([COLON]cc, d.cost_center_code) = 1)
       AND ([COLON]project IS NULL OR prod.dct_ap_pkg.in_list([COLON]project, d.project_number) = 1)
       AND ([COLON]task IS NULL OR UPPER(d.task_number) = UPPER(TRIM([COLON]task)))
       AND ([COLON]etype IS NULL OR prod.dct_ap_pkg.in_list([COLON]etype, d.expenditure_type) = 1)
       AND ([COLON]account IS NULL OR prod.dct_ap_pkg.in_list([COLON]account, d.account_code) = 1)
       AND ([COLON]approp IS NULL OR prod.dct_ap_pkg.in_list([COLON]approp, d.appropriation_code) = 1)
       AND ([COLON]po IS NULL OR TO_CHAR(d.po_number) = TRIM([COLON]po))
       AND ([COLON]pr IS NULL OR TO_CHAR(d.pr_number) = TRIM([COLON]pr))
       AND ([COLON]req IS NULL OR prod.dct_ap_pkg.in_list([COLON]req, d.pr_preparer) = 1)
     ORDER BY CASE WHEN l_sort = 'date_asc'    THEN d.invoice_date END ASC,
              CASE WHEN l_sort = 'amount_desc' THEN d.distribution_amount_aed END DESC,
              CASE WHEN l_sort = 'amount_asc'  THEN d.distribution_amount_aed END ASC,
              d.invoice_date DESC, d.invoice_id DESC, d.invoice_line_number, d.distribution_line_number
     OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY)
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.invoice_id);
    APEX_JSON.write('invoiceNumber', r.invoice_number); APEX_JSON.write('invoiceDate', r.inv_dt);
    APEX_JSON.write('supplier', r.supplier_name);
    APEX_JSON.write('isBeneficiary', r.is_beneficiary);
    APEX_JSON.write('validationStatus', r.validation_status); APEX_JSON.write('accountingStatus', r.accounting_status);
    APEX_JSON.write('paymentStatus', r.payment_status);
    APEX_JSON.write('lineNumber', r.invoice_line_number); APEX_JSON.write('distNumber', r.distribution_line_number);
    APEX_JSON.write('distType', r.distribution_type); APEX_JSON.write('currency', r.invoice_currency);
    APEX_JSON.write('amount', r.distribution_amount); APEX_JSON.write('amountAed', r.distribution_amount_aed);
    APEX_JSON.write('distStatus', r.distribution_status); APEX_JSON.write('postingStatus', r.posting_status);
    APEX_JSON.write('fundStatus', r.fund_status); APEX_JSON.write('accountingDate', r.acct_dt);
    APEX_JSON.write('period', r.period_name);
    APEX_JSON.write('poNumber', r.po_number); APEX_JSON.write('prNumber', r.pr_number);
    APEX_JSON.write('requestor', r.pr_preparer);
    APEX_JSON.write('projectNumber', r.project_number); APEX_JSON.write('projectName', r.project_name);
    APEX_JSON.write('taskNumber', r.task_number); APEX_JSON.write('expType', r.expenditure_type);
    APEX_JSON.write('accountCode', r.account_code); APEX_JSON.write('accountDesc', r.account_desc);
    APEX_JSON.write('costCenterCode', r.cost_center_code); APEX_JSON.write('costCenterDesc', r.cost_center_desc);
    APEX_JSON.write('appropriationCode', r.appropriation_code); APEX_JSON.write('appropriationDesc', r.appropriation_desc);
    APEX_JSON.write('sector', r.sector_name); APEX_JSON.write('chapter', r.chapter_name);
    APEX_JSON.write('program', r.program_name);
    APEX_JSON.write('invoiceType', r.invoice_type); APEX_JSON.write('distDescription', r.distribution_description);
    APEX_JSON.write('chargeAccount', r.charge_account); APEX_JSON.write('poChargeAccount', r.po_charge_account);
    APEX_JSON.write('glCombination', r.gl_combination); APEX_JSON.write('chargeSource', r.charge_source);
    APEX_JSON.write('invoiceDescription', r.invoice_description); APEX_JSON.write('payGroup', r.pay_group);
    APEX_JSON.write('paymentMethod', r.payment_method); APEX_JSON.write('termsDate', r.terms_dt);
    APEX_JSON.write('invFundsStatus', r.inv_funds); APEX_JSON.write('voucherNum', r.voucher_num);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
    COMMIT;
END setup_ap_lvl_t3;
/

BEGIN setup_ap_lvl_t3; END;
/
DROP PROCEDURE setup_ap_lvl_t3;

PROMPT level part 3 done (dists register)

-- ========================= part 4: dists csv export =========================
CREATE OR REPLACE PROCEDURE setup_ap_lvl_t4 AS
    c_mod CONSTANT VARCHAR2(30) := 'ap.rest';
    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    def_template('dists/export');
    def_handler('dists/export', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_ids  apex_t_number;
  FUNCTION esc(p VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF p IS NULL THEN RETURN NULL; END IF;
    IF INSTR(p, '"') > 0 OR INSTR(p, ',') > 0 OR INSTR(p, CHR(10)) > 0 THEN
      RETURN '"' || REPLACE(p, '"', '""') || '"';
    END IF;
    RETURN p;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_ids := prod.dct_ap_pkg.filtered_ids(
    p_datefrom => [COLON]datefrom, p_dateto => [COLON]dateto, p_supplier => [COLON]supplier,
    p_paid => [COLON]paid, p_val => [COLON]val, p_acc => [COLON]acc, p_inv => [COLON]inv,
    p_itype => [COLON]itype, p_curr => [COLON]curr, p_paygroup => [COLON]paygroup,
    p_paymethod => [COLON]paymethod, p_sector => [COLON]sector, p_dept => [COLON]dept,
    p_cc => [COLON]cc, p_project => [COLON]project, p_task => [COLON]task,
    p_etype => [COLON]etype, p_account => [COLON]account, p_approp => [COLON]approp,
    p_po => [COLON]po, p_pr => [COLON]pr, p_req => [COLON]req, p_search => [COLON]search,
    p_gldatefrom => [COLON]glfrom, p_gldateto => [COLON]glto,
    p_rcvfrom => [COLON]rcvfrom, p_rcvto => [COLON]rcvto,
    p_esupplier => [COLON]esupplier, p_aging => [COLON]aging, p_inclcxl => [COLON]inclcxl);
  OWA_UTIL.mime_header('text/csv', FALSE, 'UTF-8');
  HTP.p('Content-Disposition: attachment; filename="ap-distributions-' || TO_CHAR(SYSDATE,'YYYY-MM-DD') || '.csv"');
  OWA_UTIL.http_header_close;
  HTP.prn(UNISTR('\FEFF'));
  HTP.print('Invoice Number,Invoice Date,Supplier,Is Beneficiary,Line,Dist,Dist Type,Currency,Amount,Amount AED,GL Combination,Charge Source,PO Charge Account,Dist Status,Posting,Fund Status,Accounting Date,Period,PO,PR,Requestor,Project,Task,Expenditure Type,Account Code,Account,Cost Center Code,Cost Center,Appropriation,Sector,Chapter,Program,Validation,Accounting,Paid Status,Invoice Description,Pay Group,Payment Method,Terms Date,Voucher');
  FOR r IN (
    SELECT d.invoice_number, TO_CHAR(d.invoice_date,'YYYY-MM-DD') inv_dt,
           CASE WHEN d.supplier_name = 'BENEFICIARY' AND d.beneficiary_name IS NOT NULL
                THEN d.beneficiary_name ELSE d.supplier_name END supplier_name,
           CASE WHEN d.supplier_name = 'BENEFICIARY' THEN 'Y' ELSE 'N' END is_beneficiary,
           d.invoice_line_number, d.distribution_line_number, d.distribution_type, d.invoice_currency,
           d.distribution_amount, d.distribution_amount_aed, d.distribution_status, d.posting_status,
           d.fund_status, TO_CHAR(d.accounting_date,'YYYY-MM-DD') acct_dt, d.period_name,
           d.po_number, d.pr_number, d.pr_preparer, d.project_number, d.task_number, d.expenditure_type,
           d.account_code, d.account_desc, d.cost_center_code, d.cost_center_desc,
           d.appropriation_code, d.appropriation_desc, d.sector_name, d.chapter_name, d.program_name,
           d.validation_status, d.accounting_status, d.payment_status,
           prod.dct_cc_canon(pd.charge_account) po_charge_account,
           prod.dct_cc_canon(COALESCE(pd.charge_account, d.charge_account)) gl_combination,
           CASE WHEN pd.charge_account IS NOT NULL THEN 'PO' ELSE 'AP' END charge_source,
           h.invoice_description, h.pay_group, h.payment_method,
           TO_CHAR(h.terms_date,'YYYY-MM-DD') terms_dt, h.voucher_num
      FROM prod.ap_invoice_distributions_v d
      LEFT JOIN prod.ap_invoices_header_v h ON h.invoice_id = d.invoice_id
      LEFT JOIN prod.po_lines pl
             ON TO_CHAR(pl.order_number) = TO_CHAR(d.po_number) AND pl.line = d.po_line
      LEFT JOIN prod.po_distributions pd
             ON pd.po_line_id = pl.po_line_id AND pd.schedule = d.po_schedule
            AND pd.distribution_number = d.po_distribution_line
     WHERE d.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
       AND ([COLON]sector IS NULL OR prod.dct_ap_pkg.in_list([COLON]sector, NVL(d.sector_name,'Unclassified')) = 1)
       AND ([COLON]cc IS NULL OR prod.dct_ap_pkg.in_list([COLON]cc, d.cost_center_code) = 1)
       AND ([COLON]project IS NULL OR prod.dct_ap_pkg.in_list([COLON]project, d.project_number) = 1)
       AND ([COLON]task IS NULL OR UPPER(d.task_number) = UPPER(TRIM([COLON]task)))
       AND ([COLON]etype IS NULL OR prod.dct_ap_pkg.in_list([COLON]etype, d.expenditure_type) = 1)
       AND ([COLON]account IS NULL OR prod.dct_ap_pkg.in_list([COLON]account, d.account_code) = 1)
       AND ([COLON]approp IS NULL OR prod.dct_ap_pkg.in_list([COLON]approp, d.appropriation_code) = 1)
       AND ([COLON]po IS NULL OR TO_CHAR(d.po_number) = TRIM([COLON]po))
       AND ([COLON]pr IS NULL OR TO_CHAR(d.pr_number) = TRIM([COLON]pr))
       AND ([COLON]req IS NULL OR prod.dct_ap_pkg.in_list([COLON]req, d.pr_preparer) = 1)
     ORDER BY d.invoice_date DESC, d.invoice_id DESC, d.invoice_line_number, d.distribution_line_number
     FETCH FIRST 25000 ROWS ONLY)
  LOOP
    HTP.print(
      esc(r.invoice_number) || ',' || r.inv_dt || ',' || esc(r.supplier_name) || ',' || r.is_beneficiary || ',' ||
      r.invoice_line_number || ',' || r.distribution_line_number || ',' || esc(r.distribution_type) || ',' ||
      r.invoice_currency || ',' || r.distribution_amount || ',' || r.distribution_amount_aed || ',' ||
      esc(r.gl_combination) || ',' || r.charge_source || ',' || esc(r.po_charge_account) || ',' ||
      esc(r.distribution_status) || ',' || esc(r.posting_status) || ',' || esc(r.fund_status) || ',' ||
      r.acct_dt || ',' || esc(r.period_name) || ',' || r.po_number || ',' || r.pr_number || ',' ||
      esc(r.pr_preparer) || ',' || esc(r.project_number) || ',' || esc(r.task_number) || ',' ||
      esc(r.expenditure_type) || ',' || esc(r.account_code) || ',' || esc(r.account_desc) || ',' ||
      esc(r.cost_center_code) || ',' || esc(r.cost_center_desc) || ',' || esc(r.appropriation_code) || ',' ||
      esc(r.sector_name) || ',' || esc(r.chapter_name) || ',' || esc(r.program_name) || ',' ||
      esc(r.validation_status) || ',' || esc(r.accounting_status) || ',' || esc(r.payment_status) || ',' ||
      esc(r.invoice_description) || ',' || esc(r.pay_group) || ',' || esc(r.payment_method) || ',' ||
      r.terms_dt || ',' || r.voucher_num);
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
    COMMIT;
END setup_ap_lvl_t4;
/

BEGIN setup_ap_lvl_t4; END;
/
DROP PROCEDURE setup_ap_lvl_t4;

PROMPT level part 4 done (dists export)

PROMPT === verification -- expect 9 templates, 9 handlers on ap.rest ===
SELECT COUNT(*) templates FROM user_ords_templates t
  JOIN user_ords_modules m ON m.id = t.module_id WHERE m.name = 'ap.rest';
SELECT COUNT(*) handlers FROM user_ords_handlers h
  JOIN user_ords_templates t ON t.id = h.template_id
  JOIN user_ords_modules m ON m.id = t.module_id WHERE m.name = 'ap.rest';

PROMPT ap.rest level endpoints published (lines + dists + exports)
