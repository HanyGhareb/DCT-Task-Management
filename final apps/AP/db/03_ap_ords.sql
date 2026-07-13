-- =============================================================================
-- Accounts Payable (App 212) -- ORDS REST API (ap.rest)
-- File    : 03_ap_ords.sql
-- Schema  : registered under ADMIN (the only REST-routable schema on ADB)
-- Base URL: /ords/admin/ap/
-- Run     : sql -name prod_mcp @03_ap_ords.sql   (fresh session)
-- IMPORTANT: this script rebuilds ap.rest from scratch -- whenever 03 is
--           re-run, re-run 04_ap_level_ords.sql right after it (same rule
--           as GL 05->07/08/09/10).
-- Depends : 02_ap_pkg.sql (prod.dct_ap_pkg facet engine)
-- Notes   : read-only analytics over prod.ap_invoices_header_v /
--           ap_invoice_lines_v / ap_invoice_distributions_v. All handler SQL
--           uses the prod. prefix directly, so no new ADMIN synonyms are
--           needed. validate_session on every route. Amount KPIs are AED
--           (paid/balance converted per invoice with amount_aed/amount).
--           Aging = unpaid balance bucketed by days past terms_date.
--           Setup is split into five small procedures on purpose -- the Linux
--           SQLcl build silently skips very large single statements.
-- Routes  :
--   GET /ap/filters            facet LOVs (+ global header counts)
--   GET /ap/summary            KPIs + chart datasets for the current facets
--   GET /ap/invoices           paged register {items,total,totals,limit,offset}
--   GET /ap/invoices/export    CSV download of the filtered register (10k cap)
--   GET /ap/invoices/[COLON]id header + lines + distributions drill
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

-- ========================= part 1: module + filters =========================
CREATE OR REPLACE PROCEDURE setup_ap_ords_t1 AS
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
    BEGIN
        ORDS.DELETE_MODULE(p_module_name => c_mod);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    ORDS.DEFINE_MODULE(
        p_module_name    => c_mod,
        p_base_path      => '/ap/',
        p_items_per_page => 100,
        p_status         => 'PUBLISHED',
        p_comments       => 'i-Finance -- Accounts Payable analytics REST API (App 212)');

    def_template('filters');
    def_handler('filters', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_min  VARCHAR2(10); l_max VARCHAR2(10);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT TO_CHAR(MIN(invoice_date),'YYYY-MM-DD'), TO_CHAR(MAX(invoice_date),'YYYY-MM-DD')
    INTO l_min, l_max FROM prod.ap_invoices_header_v;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('minDate', l_min); APEX_JSON.write('maxDate', l_max);
  APEX_JSON.open_array('paymentStatus');
  FOR r IN (SELECT payment_status v, COUNT(*) c FROM prod.ap_invoices_header_v WHERE ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') GROUP BY payment_status ORDER BY 2 DESC) LOOP
    APEX_JSON.open_object; APEX_JSON.write('name', r.v); APEX_JSON.write('count', r.c); APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('validationStatus');
  FOR r IN (SELECT validation_status v, COUNT(*) c FROM prod.ap_invoices_header_v WHERE ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') GROUP BY validation_status ORDER BY 2 DESC) LOOP
    APEX_JSON.open_object; APEX_JSON.write('name', r.v); APEX_JSON.write('count', r.c); APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('accountingStatus');
  FOR r IN (SELECT accounting_status v, COUNT(*) c FROM prod.ap_invoices_header_v WHERE ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') GROUP BY accounting_status ORDER BY 2 DESC) LOOP
    APEX_JSON.open_object; APEX_JSON.write('name', r.v); APEX_JSON.write('count', r.c); APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('invoiceStatus');
  FOR r IN (SELECT invoice_status v, COUNT(*) c FROM prod.ap_invoices_header_v WHERE ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') GROUP BY invoice_status ORDER BY 2 DESC) LOOP
    APEX_JSON.open_object; APEX_JSON.write('name', r.v); APEX_JSON.write('count', r.c); APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('invoiceType');
  FOR r IN (SELECT invoice_type v, COUNT(*) c FROM prod.ap_invoices_header_v WHERE ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') GROUP BY invoice_type ORDER BY 2 DESC) LOOP
    APEX_JSON.open_object; APEX_JSON.write('name', r.v); APEX_JSON.write('count', r.c); APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('currency');
  FOR r IN (SELECT invoice_currency v, COUNT(*) c FROM prod.ap_invoices_header_v WHERE ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') GROUP BY invoice_currency ORDER BY 2 DESC) LOOP
    APEX_JSON.open_object; APEX_JSON.write('name', r.v); APEX_JSON.write('count', r.c); APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('payGroup');
  FOR r IN (SELECT NVL(pay_group,'(None)') v, COUNT(*) c FROM prod.ap_invoices_header_v WHERE ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') GROUP BY NVL(pay_group,'(None)') ORDER BY 2 DESC) LOOP
    APEX_JSON.open_object; APEX_JSON.write('name', r.v); APEX_JSON.write('count', r.c); APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('paymentMethod');
  FOR r IN (SELECT payment_method v, COUNT(*) c FROM prod.ap_invoices_header_v WHERE ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') GROUP BY payment_method ORDER BY 2 DESC) LOOP
    APEX_JSON.open_object; APEX_JSON.write('name', r.v); APEX_JSON.write('count', r.c); APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('sectors');
  -- per-invoice classification: one bucket each (single sector / Multiple / Unclassified),
  -- so the sector counts sum exactly to the invoices KPI
  FOR r IN (SELECT sect v, COUNT(*) c FROM (
              SELECT h.invoice_id,
                     CASE WHEN COUNT(DISTINCT CASE WHEN d.invoice_id IS NOT NULL
                                                   THEN NVL(d.sector_name,'Unclassified') END) > 1
                          THEN '(Multiple sectors)'
                          ELSE NVL(MAX(NVL(d.sector_name,'Unclassified')),'Unclassified') END sect
                FROM prod.ap_invoices_header_v h
                LEFT JOIN prod.ap_invoice_distributions_v d
                       ON d.invoice_id = h.invoice_id
                      AND d.distribution_type NOT IN ('Recoverable tax','Nonrecoverable tax')
               WHERE ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR h.invoice_status <> 'Cancelled')
               GROUP BY h.invoice_id)
             GROUP BY sect ORDER BY 2 DESC) LOOP
    APEX_JSON.open_object; APEX_JSON.write('name', r.v); APEX_JSON.write('count', r.c); APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('suppliers');
  FOR r IN (SELECT DISTINCT supplier_name v FROM prod.ap_invoices_header_v WHERE ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') AND supplier_name IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.write(r.v);
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('departments');
  FOR r IN (SELECT DISTINCT expenditure_organization v FROM prod.ap_invoice_lines_v WHERE ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') AND expenditure_organization IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.write(r.v);
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('requestors');
  FOR r IN (SELECT DISTINCT pr_preparer v FROM prod.ap_invoice_distributions_v WHERE distribution_type NOT IN ('Recoverable tax','Nonrecoverable tax') AND ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') AND pr_preparer IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.write(r.v);
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('expTypes');
  FOR r IN (SELECT DISTINCT expenditure_type v FROM prod.ap_invoice_distributions_v WHERE distribution_type NOT IN ('Recoverable tax','Nonrecoverable tax') AND ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') AND expenditure_type IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.write(r.v);
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('costCenters');
  FOR r IN (SELECT DISTINCT cost_center_code cd, cost_center_desc nm FROM prod.ap_invoice_distributions_v WHERE distribution_type NOT IN ('Recoverable tax','Nonrecoverable tax') AND ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') AND cost_center_code IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code', r.cd); APEX_JSON.write('name', r.nm); APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('accounts');
  FOR r IN (SELECT DISTINCT account_code cd, account_desc nm FROM prod.ap_invoice_distributions_v WHERE distribution_type NOT IN ('Recoverable tax','Nonrecoverable tax') AND ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') AND account_code IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code', r.cd); APEX_JSON.write('name', r.nm); APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('appropriations');
  FOR r IN (SELECT DISTINCT appropriation_code cd, appropriation_desc nm FROM prod.ap_invoice_distributions_v WHERE distribution_type NOT IN ('Recoverable tax','Nonrecoverable tax') AND ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') AND appropriation_code IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code', r.cd); APEX_JSON.write('name', r.nm); APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('projects');
  FOR r IN (SELECT DISTINCT project_number cd, project_name nm FROM prod.ap_invoice_distributions_v WHERE distribution_type NOT IN ('Recoverable tax','Nonrecoverable tax') AND ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR invoice_status <> 'Cancelled') AND project_number IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code', r.cd); APEX_JSON.write('name', r.nm); APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
    COMMIT;
END setup_ap_ords_t1;
/

BEGIN setup_ap_ords_t1; END;
/
DROP PROCEDURE setup_ap_ords_t1;

PROMPT part 1 done (module + filters)

-- ========================= part 2: summary ==================================
CREATE OR REPLACE PROCEDURE setup_ap_ords_t2 AS
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
    def_template('summary');
    def_handler('summary', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_ids  apex_t_number;
  k_cnt NUMBER; k_sup NUMBER; k_tot NUMBER; k_paid NUMBER; k_out NUMBER; k_over NUMBER; k_cxl NUMBER;
  -- trend default window: no explicit date criteria = start at the current
  -- budget year (Jan 1); any date facet supplied = show the filtered range
  l_trendfloor DATE := CASE WHEN [COLON]datefrom IS NULL AND [COLON]dateto IS NULL
                             AND [COLON]rcvfrom IS NULL AND [COLON]rcvto IS NULL
                             AND [COLON]glfrom  IS NULL AND [COLON]glto  IS NULL
                            THEN TRUNC(SYSDATE,'YYYY') END;
  PROCEDURE nco(p_n VARCHAR2, p_c NUMBER, p_a NUMBER) IS
  BEGIN
    APEX_JSON.open_object; APEX_JSON.write('name', p_n);
    APEX_JSON.write('count', p_c); APEX_JSON.write('amount', ROUND(p_a, 2));
    APEX_JSON.close_object;
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
  SELECT COUNT(*),
         COUNT(DISTINCT CASE WHEN h.supplier_name = 'BENEFICIARY' AND h.beneficiary_name IS NOT NULL
                             THEN h.beneficiary_name ELSE h.supplier_name END),
         NVL(SUM(h.invoice_amount_aed),0),
         NVL(SUM(NVL(h.amount_paid,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1)),0),
         NVL(SUM(CASE WHEN h.payment_status = 'Unpaid' THEN NVL(h.balance_due,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1) ELSE 0 END),0),
         NVL(SUM(CASE WHEN h.payment_status = 'Unpaid' AND NVL(h.balance_due,0) <> 0
                       AND TRUNC(NVL(h.terms_date, h.invoice_date)) < TRUNC(SYSDATE)
                      THEN NVL(h.balance_due,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1) ELSE 0 END),0),
         COUNT(CASE WHEN h.invoice_status = 'Cancelled' THEN 1 END)
    INTO k_cnt, k_sup, k_tot, k_paid, k_out, k_over, k_cxl
    FROM prod.ap_invoices_header_v h
   WHERE h.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_object('kpis');
  APEX_JSON.write('invoices', k_cnt); APEX_JSON.write('suppliers', k_sup);
  APEX_JSON.write('totalAed', ROUND(k_tot,2)); APEX_JSON.write('paidAed', ROUND(k_paid,2));
  APEX_JSON.write('outstandingAed', ROUND(k_out,2)); APEX_JSON.write('overdueAed', ROUND(k_over,2));
  APEX_JSON.write('cancelled', k_cxl);
  APEX_JSON.close_object;
  APEX_JSON.open_array('aging');
  FOR r IN (
    SELECT b, COUNT(*) c, NVL(SUM(bal),0) amt FROM (
      SELECT CASE WHEN TRUNC(NVL(h.terms_date, h.invoice_date)) >= TRUNC(SYSDATE) THEN 'CURRENT'
                  WHEN TRUNC(SYSDATE) - TRUNC(NVL(h.terms_date, h.invoice_date)) <= 30 THEN 'D1_30'
                  WHEN TRUNC(SYSDATE) - TRUNC(NVL(h.terms_date, h.invoice_date)) <= 60 THEN 'D31_60'
                  WHEN TRUNC(SYSDATE) - TRUNC(NVL(h.terms_date, h.invoice_date)) <= 90 THEN 'D61_90'
                  WHEN TRUNC(SYSDATE) - TRUNC(NVL(h.terms_date, h.invoice_date)) <= 180 THEN 'D91_180'
                  ELSE 'D180P' END b,
             NVL(h.balance_due,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1) bal
        FROM prod.ap_invoices_header_v h
       WHERE h.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
         AND h.payment_status = 'Unpaid' AND NVL(h.balance_due,0) <> 0)
    GROUP BY b)
  LOOP
    APEX_JSON.open_object; APEX_JSON.write('bucket', r.b);
    APEX_JSON.write('count', r.c); APEX_JSON.write('amount', ROUND(r.amt,2));
    APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('validationStatus');
  FOR r IN (SELECT h.validation_status v, COUNT(*) c, NVL(SUM(h.invoice_amount_aed),0) a
              FROM prod.ap_invoices_header_v h
             WHERE h.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
             GROUP BY h.validation_status ORDER BY 2 DESC) LOOP
    nco(r.v, r.c, r.a);
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('accountingStatus');
  FOR r IN (SELECT h.accounting_status v, COUNT(*) c, NVL(SUM(h.invoice_amount_aed),0) a
              FROM prod.ap_invoices_header_v h
             WHERE h.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
             GROUP BY h.accounting_status ORDER BY 2 DESC) LOOP
    nco(r.v, r.c, r.a);
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('paymentStatus');
  FOR r IN (SELECT h.payment_status v, COUNT(*) c, NVL(SUM(h.invoice_amount_aed),0) a
              FROM prod.ap_invoices_header_v h
             WHERE h.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
             GROUP BY h.payment_status ORDER BY 2 DESC) LOOP
    nco(r.v, r.c, r.a);
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('trend');
  -- month basis = Invoice Received Date (creation date fallback when not recorded)
  FOR r IN (SELECT m, c, a FROM (
              SELECT TO_CHAR(COALESCE(h.invoice_received_date, h.created_date, h.invoice_date),'YYYY-MM') m,
                     COUNT(*) c, NVL(SUM(h.invoice_amount_aed),0) a
                FROM prod.ap_invoices_header_v h
               WHERE h.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
                 AND (l_trendfloor IS NULL OR COALESCE(h.invoice_received_date, h.created_date, h.invoice_date) >= l_trendfloor)
               GROUP BY TO_CHAR(COALESCE(h.invoice_received_date, h.created_date, h.invoice_date),'YYYY-MM')
               ORDER BY m DESC FETCH FIRST 60 ROWS ONLY) ORDER BY m) LOOP
    APEX_JSON.open_object; APEX_JSON.write('month', r.m);
    APEX_JSON.write('count', r.c); APEX_JSON.write('amount', ROUND(r.a,2));
    APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('topSuppliers');
  FOR r IN (SELECT CASE WHEN h.supplier_name = 'BENEFICIARY' AND h.beneficiary_name IS NOT NULL
                        THEN h.beneficiary_name ELSE h.supplier_name END v,
                   COUNT(*) c, NVL(SUM(h.invoice_amount_aed),0) a
              FROM prod.ap_invoices_header_v h
             WHERE h.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
             GROUP BY CASE WHEN h.supplier_name = 'BENEFICIARY' AND h.beneficiary_name IS NOT NULL
                           THEN h.beneficiary_name ELSE h.supplier_name END
             ORDER BY 3 DESC FETCH FIRST 10 ROWS ONLY) LOOP
    nco(r.v, r.c, r.a);
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('bySector');
  -- classification grouping (matches the facet + its drill): one bucket per
  -- invoice; amount = its non-tax distributed AED
  FOR r IN (SELECT sect v, COUNT(*) c, NVL(SUM(amt),0) a FROM (
              SELECT h.invoice_id,
                     CASE WHEN COUNT(DISTINCT CASE WHEN d.invoice_id IS NOT NULL
                                                   THEN NVL(d.sector_name,'Unclassified') END) > 1
                          THEN '(Multiple sectors)'
                          ELSE NVL(MAX(NVL(d.sector_name,'Unclassified')),'Unclassified') END sect,
                     SUM(d.distribution_amount_aed) amt
                FROM prod.ap_invoices_header_v h
                LEFT JOIN prod.ap_invoice_distributions_v d
                       ON d.invoice_id = h.invoice_id
                      AND d.distribution_type NOT IN ('Recoverable tax','Nonrecoverable tax')
               WHERE h.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
               GROUP BY h.invoice_id)
             GROUP BY sect ORDER BY 3 DESC FETCH FIRST 14 ROWS ONLY) LOOP
    nco(r.v, r.c, r.a);
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('byPayGroup');
  FOR r IN (SELECT NVL(h.pay_group,'(None)') v, COUNT(*) c, NVL(SUM(h.invoice_amount_aed),0) a
              FROM prod.ap_invoices_header_v h
             WHERE h.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
             GROUP BY NVL(h.pay_group,'(None)') ORDER BY 3 DESC FETCH FIRST 10 ROWS ONLY) LOOP
    nco(r.v, r.c, r.a);
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
    COMMIT;
END setup_ap_ords_t2;
/

BEGIN setup_ap_ords_t2; END;
/
DROP PROCEDURE setup_ap_ords_t2;

PROMPT part 2 done (summary)

-- ========================= part 3: register =================================
CREATE OR REPLACE PROCEDURE setup_ap_ords_t3 AS
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
    def_template('invoices');
    def_handler('invoices', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_ids    apex_t_number;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 50), 10000);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_sort   VARCHAR2(30) := LOWER([COLON]sort);
  l_amt NUMBER; l_bal NUMBER;
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
  SELECT NVL(SUM(h.invoice_amount_aed),0),
         NVL(SUM(CASE WHEN h.payment_status = 'Unpaid' THEN NVL(h.balance_due,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1) ELSE 0 END),0)
    INTO l_amt, l_bal
    FROM prod.ap_invoices_header_v h
   WHERE h.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_ids.COUNT); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_object('totals');
  APEX_JSON.write('amountAed', ROUND(l_amt,2)); APEX_JSON.write('balanceAed', ROUND(l_bal,2));
  APEX_JSON.close_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT h.invoice_id, h.invoice_number, TO_CHAR(h.invoice_date,'YYYY-MM-DD') inv_dt, h.invoice_type,
           CASE WHEN h.supplier_name = 'BENEFICIARY' AND h.beneficiary_name IS NOT NULL
                THEN h.beneficiary_name ELSE h.supplier_name END supplier_name,
           CASE WHEN h.supplier_name = 'BENEFICIARY' THEN 'Y' ELSE 'N' END is_beneficiary,
           h.supplier_number, h.invoice_description, h.invoice_currency,
           h.invoice_amount, h.invoice_amount_aed, NVL(h.amount_paid,0) amount_paid, NVL(h.balance_due,0) balance_due,
           NVL(h.balance_due,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1) balance_aed,
           h.validation_status, h.accounting_status, h.payment_status, h.funds_status, h.invoice_status,
           TO_CHAR(h.terms_date,'YYYY-MM-DD') terms_dt, h.payment_terms, h.pay_group, h.payment_method,
           h.po_numbers, h.pr_numbers, h.voucher_num, h.invoice_source, h.line_count, h.distribution_count,
           CASE WHEN h.payment_status = 'Unpaid' AND NVL(h.balance_due,0) > 0
                THEN GREATEST(TRUNC(SYSDATE) - TRUNC(NVL(h.terms_date, h.invoice_date)), 0) END days_past_due
      FROM prod.ap_invoices_header_v h
     WHERE h.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
     ORDER BY CASE WHEN l_sort = 'date_asc'      THEN h.invoice_date END ASC,
              CASE WHEN l_sort = 'amount_desc'   THEN h.invoice_amount_aed END DESC,
              CASE WHEN l_sort = 'amount_asc'    THEN h.invoice_amount_aed END ASC,
              CASE WHEN l_sort = 'balance_desc'  THEN NVL(h.balance_due,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1) END DESC,
              CASE WHEN l_sort = 'supplier_asc'  THEN CASE WHEN h.supplier_name = 'BENEFICIARY' AND h.beneficiary_name IS NOT NULL
                                                           THEN h.beneficiary_name ELSE h.supplier_name END END ASC,
              CASE WHEN l_sort = 'supplier_desc' THEN CASE WHEN h.supplier_name = 'BENEFICIARY' AND h.beneficiary_name IS NOT NULL
                                                           THEN h.beneficiary_name ELSE h.supplier_name END END DESC,
              h.invoice_date DESC, h.invoice_id DESC
     OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY)
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.invoice_id);
    APEX_JSON.write('invoiceNumber', r.invoice_number);
    APEX_JSON.write('invoiceDate', r.inv_dt);
    APEX_JSON.write('invoiceType', r.invoice_type);
    APEX_JSON.write('supplier', r.supplier_name);
    APEX_JSON.write('isBeneficiary', r.is_beneficiary);
    APEX_JSON.write('supplierNumber', r.supplier_number);
    APEX_JSON.write('description', r.invoice_description);
    APEX_JSON.write('currency', r.invoice_currency);
    APEX_JSON.write('amount', r.invoice_amount);
    APEX_JSON.write('amountAed', r.invoice_amount_aed);
    APEX_JSON.write('amountPaid', r.amount_paid);
    APEX_JSON.write('balanceDue', r.balance_due);
    APEX_JSON.write('balanceAed', ROUND(r.balance_aed,2));
    APEX_JSON.write('validationStatus', r.validation_status);
    APEX_JSON.write('accountingStatus', r.accounting_status);
    APEX_JSON.write('paymentStatus', r.payment_status);
    APEX_JSON.write('fundsStatus', r.funds_status);
    APEX_JSON.write('invoiceStatus', r.invoice_status);
    APEX_JSON.write('termsDate', r.terms_dt);
    APEX_JSON.write('paymentTerms', r.payment_terms);
    APEX_JSON.write('payGroup', r.pay_group);
    APEX_JSON.write('paymentMethod', r.payment_method);
    APEX_JSON.write('poNumbers', r.po_numbers);
    APEX_JSON.write('prNumbers', r.pr_numbers);
    APEX_JSON.write('voucherNum', r.voucher_num);
    APEX_JSON.write('source', r.invoice_source);
    APEX_JSON.write('lineCount', r.line_count);
    APEX_JSON.write('distCount', r.distribution_count);
    IF r.days_past_due IS NOT NULL THEN APEX_JSON.write('daysPastDue', r.days_past_due); END IF;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
    COMMIT;
END setup_ap_ords_t3;
/

BEGIN setup_ap_ords_t3; END;
/
DROP PROCEDURE setup_ap_ords_t3;

PROMPT part 3 done (register)

-- ========================= part 4: csv export ===============================
CREATE OR REPLACE PROCEDURE setup_ap_ords_t4 AS
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
    def_template('invoices/export');
    def_handler('invoices/export', 'GET', q'!
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
  HTP.p('Content-Disposition: attachment; filename="ap-register-' || TO_CHAR(SYSDATE,'YYYY-MM-DD') || '.csv"');
  OWA_UTIL.http_header_close;
  HTP.prn(UNISTR('\FEFF'));
  HTP.print('Invoice Number,Invoice Date,Type,Supplier,Is Beneficiary,Description,Currency,Amount,Amount AED,Amount Paid,Balance Due,Balance AED,Validation,Accounting,Paid Status,Funds,Invoice Status,Terms Date,Days Past Due,Pay Group,Payment Method,PO Numbers,PR Numbers,Voucher,Source');
  FOR r IN (
    SELECT h.invoice_number, TO_CHAR(h.invoice_date,'YYYY-MM-DD') inv_dt, h.invoice_type,
           CASE WHEN h.supplier_name = 'BENEFICIARY' AND h.beneficiary_name IS NOT NULL
                THEN h.beneficiary_name ELSE h.supplier_name END supplier_name,
           CASE WHEN h.supplier_name = 'BENEFICIARY' THEN 'Y' ELSE 'N' END is_beneficiary,
           h.invoice_description, h.invoice_currency, h.invoice_amount, h.invoice_amount_aed,
           NVL(h.amount_paid,0) amount_paid, NVL(h.balance_due,0) balance_due,
           ROUND(NVL(h.balance_due,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1),2) balance_aed,
           h.validation_status, h.accounting_status, h.payment_status, h.funds_status, h.invoice_status,
           TO_CHAR(h.terms_date,'YYYY-MM-DD') terms_dt,
           CASE WHEN h.payment_status = 'Unpaid' AND NVL(h.balance_due,0) > 0
                THEN GREATEST(TRUNC(SYSDATE) - TRUNC(NVL(h.terms_date, h.invoice_date)), 0) END days_past_due,
           h.pay_group, h.payment_method, h.po_numbers, h.pr_numbers, h.voucher_num, h.invoice_source
      FROM prod.ap_invoices_header_v h
     WHERE h.invoice_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
     ORDER BY h.invoice_date DESC, h.invoice_id DESC
     FETCH FIRST 10000 ROWS ONLY)
  LOOP
    HTP.print(
      esc(r.invoice_number) || ',' || r.inv_dt || ',' || esc(r.invoice_type) || ',' ||
      esc(r.supplier_name) || ',' || r.is_beneficiary || ',' || esc(r.invoice_description) || ',' || r.invoice_currency || ',' ||
      r.invoice_amount || ',' || r.invoice_amount_aed || ',' || r.amount_paid || ',' ||
      r.balance_due || ',' || r.balance_aed || ',' ||
      esc(r.validation_status) || ',' || esc(r.accounting_status) || ',' || esc(r.payment_status) || ',' ||
      esc(r.funds_status) || ',' || esc(r.invoice_status) || ',' || r.terms_dt || ',' || r.days_past_due || ',' ||
      esc(r.pay_group) || ',' || esc(r.payment_method) || ',' || esc(r.po_numbers) || ',' ||
      esc(r.pr_numbers) || ',' || r.voucher_num || ',' || esc(r.invoice_source));
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
    COMMIT;
END setup_ap_ords_t4;
/

BEGIN setup_ap_ords_t4; END;
/
DROP PROCEDURE setup_ap_ords_t4;

PROMPT part 4 done (csv export)

-- ========================= part 5: invoice drill ============================
CREATE OR REPLACE PROCEDURE setup_ap_ords_t5 AS
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
    def_template('invoices/[COLON]id');
    def_handler('invoices/[COLON]id', 'GET', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_id    NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_found BOOLEAN := FALSE;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Invalid invoice id'); RETURN; END IF;
  FOR h IN (
    SELECT invoice_id, invoice_number, TO_CHAR(invoice_date,'YYYY-MM-DD') inv_dt, invoice_type,
           invoice_description, invoice_status, supplier_number, supplier_name, beneficiary_name,
           CASE WHEN supplier_name = 'BENEFICIARY' THEN 'Y' ELSE 'N' END is_beneficiary,
           supplier_site, party_site_city, party_site_country, supplier_email,
           invoice_currency, invoice_amount, total_tax_charged, invoice_amount_aed, conversion_rate,
           NVL(amount_paid,0) amount_paid, NVL(balance_due,0) balance_due,
           payment_status, validation_status, accounting_status, funds_status, approval_status,
           payment_terms, TO_CHAR(terms_date,'YYYY-MM-DD') terms_dt, payment_method, pay_group,
           payment_currency, voucher_num, invoice_source, batch_name,
           TO_CHAR(gl_date,'YYYY-MM-DD') gl_dt, TO_CHAR(invoice_received_date,'YYYY-MM-DD') rcv_dt,
           created_by, TO_CHAR(created_date,'YYYY-MM-DD') created_dt,
           last_updated_by, TO_CHAR(last_updated_date,'YYYY-MM-DD') updated_dt,
           TO_CHAR(cancelled_date,'YYYY-MM-DD') cxl_dt, cancelled_by,
           line_count, distribution_count, po_numbers, pr_numbers
      FROM prod.ap_invoices_header_v WHERE invoice_id = l_id)
  LOOP
    l_found := TRUE;
    dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
    APEX_JSON.open_object('header');
    APEX_JSON.write('id', h.invoice_id); APEX_JSON.write('invoiceNumber', h.invoice_number);
    APEX_JSON.write('invoiceDate', h.inv_dt); APEX_JSON.write('invoiceType', h.invoice_type);
    APEX_JSON.write('description', h.invoice_description); APEX_JSON.write('invoiceStatus', h.invoice_status);
    APEX_JSON.write('supplierNumber', h.supplier_number); APEX_JSON.write('supplier', h.supplier_name);
    APEX_JSON.write('beneficiary', h.beneficiary_name);
    APEX_JSON.write('isBeneficiary', h.is_beneficiary);
    APEX_JSON.write('supplierSite', h.supplier_site);
    APEX_JSON.write('city', h.party_site_city); APEX_JSON.write('country', h.party_site_country);
    APEX_JSON.write('supplierEmail', h.supplier_email);
    APEX_JSON.write('currency', h.invoice_currency); APEX_JSON.write('amount', h.invoice_amount);
    APEX_JSON.write('taxCharged', h.total_tax_charged); APEX_JSON.write('amountAed', h.invoice_amount_aed);
    APEX_JSON.write('conversionRate', h.conversion_rate);
    APEX_JSON.write('amountPaid', h.amount_paid); APEX_JSON.write('balanceDue', h.balance_due);
    APEX_JSON.write('paymentStatus', h.payment_status); APEX_JSON.write('validationStatus', h.validation_status);
    APEX_JSON.write('accountingStatus', h.accounting_status); APEX_JSON.write('fundsStatus', h.funds_status);
    APEX_JSON.write('approvalStatus', h.approval_status);
    APEX_JSON.write('paymentTerms', h.payment_terms); APEX_JSON.write('termsDate', h.terms_dt);
    APEX_JSON.write('paymentMethod', h.payment_method); APEX_JSON.write('payGroup', h.pay_group);
    APEX_JSON.write('paymentCurrency', h.payment_currency); APEX_JSON.write('voucherNum', h.voucher_num);
    APEX_JSON.write('source', h.invoice_source); APEX_JSON.write('batchName', h.batch_name);
    APEX_JSON.write('glDate', h.gl_dt); APEX_JSON.write('receivedDate', h.rcv_dt);
    APEX_JSON.write('createdBy', h.created_by); APEX_JSON.write('createdDate', h.created_dt);
    APEX_JSON.write('lastUpdatedBy', h.last_updated_by); APEX_JSON.write('lastUpdatedDate', h.updated_dt);
    APEX_JSON.write('cancelledDate', h.cxl_dt); APEX_JSON.write('cancelledBy', h.cancelled_by);
    APEX_JSON.write('lineCount', h.line_count); APEX_JSON.write('distCount', h.distribution_count);
    APEX_JSON.write('poNumbers', h.po_numbers); APEX_JSON.write('prNumbers', h.pr_numbers);
    APEX_JSON.close_object;
    APEX_JSON.open_array('lines');
    FOR r IN (SELECT invoice_line_number, invoice_line_type, line_description, invoice_currency,
                     line_amount, line_amount_aed, NVL(active_holds,0) active_holds, fund_status,
                     po_number, po_line_number, receipt_number, project_number, project_name,
                     task_number, task_name, expenditure_type, expenditure_organization, period_name
                FROM prod.ap_invoice_lines_v WHERE invoice_id = l_id
               ORDER BY invoice_line_number) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('lineNumber', r.invoice_line_number); APEX_JSON.write('lineType', r.invoice_line_type);
      APEX_JSON.write('description', r.line_description); APEX_JSON.write('currency', r.invoice_currency);
      APEX_JSON.write('amount', r.line_amount); APEX_JSON.write('amountAed', r.line_amount_aed);
      APEX_JSON.write('activeHolds', r.active_holds); APEX_JSON.write('fundStatus', r.fund_status);
      APEX_JSON.write('poNumber', r.po_number); APEX_JSON.write('poLine', r.po_line_number);
      APEX_JSON.write('receiptNumber', r.receipt_number);
      APEX_JSON.write('projectNumber', r.project_number); APEX_JSON.write('projectName', r.project_name);
      APEX_JSON.write('taskNumber', r.task_number); APEX_JSON.write('taskName', r.task_name);
      APEX_JSON.write('expType', r.expenditure_type); APEX_JSON.write('expOrg', r.expenditure_organization);
      APEX_JSON.write('period', r.period_name);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.open_array('distributions');
    -- full COA segment breakdown per distribution (GL-Actuals-style hover):
    -- the view's charge_account is already canonical, so it joins the snap 1:1
    FOR r IN (SELECT d.invoice_line_number, d.distribution_line_number, d.distribution_type,
                     d.distribution_amount, d.distribution_amount_aed, d.distribution_status, d.posting_status,
                     d.fund_status, TO_CHAR(d.accounting_date,'YYYY-MM-DD') acct_dt, d.period_name,
                     d.po_number, d.pr_number, d.pr_preparer, d.project_number, d.task_number, d.expenditure_type,
                     d.charge_account, d.account_code, d.account_desc, d.cost_center_code, d.cost_center_desc,
                     d.appropriation_code, d.appropriation_desc, d.sector_name, d.chapter_name, d.program_name,
                     g.entity_code ent_code, g.entity_desc ent_desc,
                     g.budget_group_code bg_code, g.budget_group_desc bg_desc,
                     g.entity_specific_code es_code, g.entity_specific_desc es_desc,
                     g.future1_code f1_code, g.future1_desc f1_desc,
                     g.future2_code f2_code, g.future2_desc f2_desc,
                     g.intercompany_code ic_code, g.intercompany_desc ic_desc,
                     g.program_code prog_code, g.program_desc prog_desc
                FROM prod.ap_invoice_distributions_v d
                LEFT JOIN prod.dct_gl_coa_snap g ON g.cc_string = d.charge_account
               WHERE d.invoice_id = l_id
               ORDER BY d.invoice_line_number, d.distribution_line_number) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('lineNumber', r.invoice_line_number); APEX_JSON.write('distNumber', r.distribution_line_number);
      APEX_JSON.write('distType', r.distribution_type);
      APEX_JSON.write('amount', r.distribution_amount); APEX_JSON.write('amountAed', r.distribution_amount_aed);
      APEX_JSON.write('status', r.distribution_status); APEX_JSON.write('postingStatus', r.posting_status);
      APEX_JSON.write('fundStatus', r.fund_status); APEX_JSON.write('accountingDate', r.acct_dt);
      APEX_JSON.write('period', r.period_name);
      APEX_JSON.write('poNumber', r.po_number); APEX_JSON.write('prNumber', r.pr_number);
      APEX_JSON.write('requestor', r.pr_preparer);
      APEX_JSON.write('projectNumber', r.project_number); APEX_JSON.write('taskNumber', r.task_number);
      APEX_JSON.write('expType', r.expenditure_type);
      APEX_JSON.write('chargeAccount', r.charge_account);
      APEX_JSON.write('accountCode', r.account_code); APEX_JSON.write('accountDesc', r.account_desc);
      APEX_JSON.write('costCenterCode', r.cost_center_code); APEX_JSON.write('costCenterDesc', r.cost_center_desc);
      APEX_JSON.write('appropriationCode', r.appropriation_code); APEX_JSON.write('appropriationDesc', r.appropriation_desc);
      APEX_JSON.write('sector', r.sector_name); APEX_JSON.write('chapter', r.chapter_name);
      APEX_JSON.write('program', r.program_name);
      APEX_JSON.write('entityCode', r.ent_code); APEX_JSON.write('entityDesc', r.ent_desc);
      APEX_JSON.write('budgetGroupCode', r.bg_code); APEX_JSON.write('budgetGroupDesc', r.bg_desc);
      APEX_JSON.write('entitySpecificCode', r.es_code); APEX_JSON.write('entitySpecificDesc', r.es_desc);
      APEX_JSON.write('future1Code', r.f1_code); APEX_JSON.write('future1Desc', r.f1_desc);
      APEX_JSON.write('future2Code', r.f2_code); APEX_JSON.write('future2Desc', r.f2_desc);
      APEX_JSON.write('intercompanyCode', r.ic_code); APEX_JSON.write('intercompanyDesc', r.ic_desc);
      APEX_JSON.write('programCode', r.prog_code); APEX_JSON.write('programDesc', r.prog_desc);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
  IF NOT l_found THEN dct_rest.err(404,'Invoice not found'); END IF;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
    COMMIT;
END setup_ap_ords_t5;
/

BEGIN setup_ap_ords_t5; END;
/
DROP PROCEDURE setup_ap_ords_t5;

PROMPT part 5 done (invoice drill)

PROMPT === verification -- expect module ap.rest, 5 templates, 5 handlers ===
SELECT name, uri_prefix, status FROM user_ords_modules WHERE name = 'ap.rest';
SELECT COUNT(*) templates FROM user_ords_templates t
  JOIN user_ords_modules m ON m.id = t.module_id WHERE m.name = 'ap.rest';
SELECT COUNT(*) handlers FROM user_ords_handlers h
  JOIN user_ords_templates t ON t.id = h.template_id
  JOIN user_ords_modules m ON m.id = t.module_id WHERE m.name = 'ap.rest';

PROMPT ap.rest ORDS module published at /ords/admin/ap/
