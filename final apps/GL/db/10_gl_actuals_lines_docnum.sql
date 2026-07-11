-- =============================================================================
-- General Ledger (App 210) -- Actuals drill-down document numbers (ADDITIVE)
-- File    : 10_gl_actuals_lines_docnum.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @10_gl_actuals_lines_docnum.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07, 08, 09 AND this script right after it. The same handler
--            source is ALSO synced into 05 (GET actuals/lines), so a full 05
--            re-run already carries it; this script deploys the change
--            additively without republishing the module.
-- Change  : UPGRADES the existing GET /gl/actuals/lines handler:
--   + apdirect drawer shows the real AP invoice number + invoice line
--     (was the raw invoice_id) and hides zero-amount lines
--   + grn drawer labelled GRN # and shows the receipt line number
-- No new synonyms (prod.ap_invoices is queried schema-prefixed, same as the
-- other prod.* objects in this handler).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_aclines_ords_tmp AS
BEGIN

    ORDS.DEFINE_HANDLER(
        p_module_name => 'gl.rest',
        p_pattern     => 'actuals/lines',
        p_method      => 'GET',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'!DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_period VARCHAR2(7)   := [COLON]period;
  l_cc     VARCHAR2(120) := [COLON]cc;
  l_metric VARCHAR2(30)  := LOWER([COLON]metric);
  l_pstart DATE; l_pnext DATE; l_ystart DATE;
  l_total  NUMBER := 0;
  PROCEDURE col(p_key VARCHAR2, p_label VARCHAR2, p_type VARCHAR2) IS
  BEGIN
    APEX_JSON.open_object; APEX_JSON.write('key',p_key); APEX_JSON.write('label',p_label); APEX_JSON.write('type',p_type); APEX_JSON.close_object;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_period IS NULL OR l_cc IS NULL OR l_metric IS NULL THEN dct_rest.err(400,'period, cc and metric are required'); RETURN; END IF;
  l_pstart := TO_DATE(l_period,'MM-YYYY'); l_pnext := ADD_MONTHS(l_pstart,1); l_ystart := TRUNC(l_pstart,'YEAR');
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('metric', l_metric); APEX_JSON.write('ccString', l_cc); APEX_JSON.write('period', l_period);

  IF l_metric = 'budget' THEN
    APEX_JSON.open_array('columns'); col('period','Period','text'); col('initial','Initial budget','money'); col('adjustments','Adjustments','money'); col('amount','Total budget','money'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT g.period_name, SUM(g.initial_budget) ib, SUM(g.budget_adjustments) adj, SUM(g.total_budget) tb
              FROM prod.gl_balances_cc g WHERE g.cc_string = l_cc
                AND TO_DATE(g.period_name,'MM-YYYY') BETWEEN l_ystart AND l_pstart
              GROUP BY g.period_name ORDER BY TO_DATE(g.period_name,'MM-YYYY')) LOOP
      APEX_JSON.open_object; APEX_JSON.write('period',r.period_name); APEX_JSON.write('initial',r.ib); APEX_JSON.write('adjustments',r.adj); APEX_JSON.write('amount',r.tb); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(g.total_budget),0) INTO l_total FROM prod.gl_balances_cc g WHERE g.cc_string = l_cc AND TO_DATE(g.period_name,'MM-YYYY') BETWEEN l_ystart AND l_pstart;

  ELSIF l_metric = 'encumbrance' THEN
    APEX_JSON.open_array('columns'); col('period','Period','text'); col('commitments','Commitments','money'); col('obligations','Obligations','money'); col('other','Other','money'); col('amount','Encumbrance','money'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT g.period_name, SUM(NVL(g.commitments,0)) c, SUM(NVL(g.obligations,0)) o, SUM(NVL(g.other_encumbrances,0)) oe
              FROM prod.gl_balances_cc g WHERE g.cc_string = l_cc
                AND TO_DATE(g.period_name,'MM-YYYY') BETWEEN l_ystart AND l_pstart
              GROUP BY g.period_name ORDER BY TO_DATE(g.period_name,'MM-YYYY')) LOOP
      APEX_JSON.open_object; APEX_JSON.write('period',r.period_name); APEX_JSON.write('commitments',r.c); APEX_JSON.write('obligations',r.o); APEX_JSON.write('other',r.oe); APEX_JSON.write('amount',r.c+r.o+r.oe); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(NVL(g.commitments,0)+NVL(g.obligations,0)+NVL(g.other_encumbrances,0)),0) INTO l_total FROM prod.gl_balances_cc g WHERE g.cc_string = l_cc AND TO_DATE(g.period_name,'MM-YYYY') BETWEEN l_ystart AND l_pstart;

  ELSIF l_metric = 'glactual' THEN
    APEX_JSON.open_array('columns'); col('period','Period','text'); col('amount','Actual expenditure','money'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT g.period_name, SUM(g.expenditures) e
              FROM prod.gl_balances_cc g WHERE g.cc_string = l_cc
                AND TO_DATE(g.period_name,'MM-YYYY') BETWEEN l_ystart AND l_pstart
              GROUP BY g.period_name ORDER BY TO_DATE(g.period_name,'MM-YYYY')) LOOP
      APEX_JSON.open_object; APEX_JSON.write('period',r.period_name); APEX_JSON.write('amount',r.e); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(g.expenditures),0) INTO l_total FROM prod.gl_balances_cc g WHERE g.cc_string = l_cc AND TO_DATE(g.period_name,'MM-YYYY') BETWEEN l_ystart AND l_pstart;

  ELSIF l_metric = 'grn' THEN
    APEX_JSON.open_array('columns'); col('receipt','GRN #','text'); col('line','Line','text'); col('date','Date','date'); col('supplier','Supplier','text'); col('currency','Cur','text'); col('rate','Rate','num'); col('amount','Amount (AED)','money'); col('type','Type','text'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT * FROM (
              SELECT g.receipt_number, g.receipt_line_number line_no, TO_CHAR(g.transaction_date,'YYYY-MM-DD') td, h.supplier_name,
                     g.currency_code, g.conversion_rate, g.ledger_amount aed, g.transaction_type
              FROM prod.grn_all_v2 g JOIN prod.po_distributions pod ON pod.po_distribution_id = g.po_distribution_id
              LEFT JOIN prod.po_headers h ON h.po_header_id = g.po_header_id
              WHERE prod.dct_cc_canon(pod.charge_account) = l_cc AND g.transaction_date >= l_ystart AND g.transaction_date < l_pnext
              ORDER BY g.transaction_date DESC FETCH FIRST 500 ROWS ONLY
              ) ORDER BY receipt_number, line_no) LOOP
      APEX_JSON.open_object; APEX_JSON.write('receipt',r.receipt_number); APEX_JSON.write('line',NVL(TO_CHAR(r.line_no),'')); APEX_JSON.write('date',NVL(r.td,'')); APEX_JSON.write('supplier',NVL(r.supplier_name,''));
      APEX_JSON.write('currency',NVL(r.currency_code,'AED')); APEX_JSON.write('rate',NVL(r.conversion_rate,1)); APEX_JSON.write('amount',r.aed); APEX_JSON.write('type',NVL(r.transaction_type,'')); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(g.ledger_amount),0) INTO l_total FROM prod.grn_all_v2 g JOIN prod.po_distributions pod ON pod.po_distribution_id = g.po_distribution_id WHERE prod.dct_cc_canon(pod.charge_account) = l_cc AND g.transaction_date >= l_ystart AND g.transaction_date < l_pnext;

  ELSIF l_metric = 'apdirect' THEN
    APEX_JSON.open_array('columns'); col('invoice','Invoice #','text'); col('line','Line','text'); col('date','Acct date','date'); col('description','Description','text'); col('orig','Amount (orig)','money'); col('amount','Amount (AED)','money'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT NVL(i.invoice_number,'#'||TO_CHAR(d.invoice_id)) inv_no, d.line_number line_no,
                     TO_CHAR(d.accounting_date,'YYYY-MM-DD') ad, d.distribution_description descr,
                     d.distribution_amount amt, NVL(d.distribution_amount_functi,d.distribution_amount) aed
              FROM prod.ap_invoice_distributions d
              LEFT JOIN (SELECT invoice_id, MAX(invoice_number) invoice_number FROM prod.ap_invoices GROUP BY invoice_id) i
                     ON i.invoice_id = d.invoice_id
              JOIN prod.dct_gl_coa_snap cid ON cid.cc_id = d.cc_id
              WHERE cid.cc_string = l_cc AND d.po_number IS NULL AND NVL(d.reversal_indicator,'N') <> 'Y'
                AND NVL(NVL(d.distribution_amount_functi,d.distribution_amount),0) <> 0
                AND d.accounting_date >= l_ystart AND d.accounting_date < l_pnext
              ORDER BY d.accounting_date DESC FETCH FIRST 500 ROWS ONLY) LOOP
      APEX_JSON.open_object; APEX_JSON.write('invoice',NVL(r.inv_no,'')); APEX_JSON.write('line',NVL(TO_CHAR(r.line_no),'')); APEX_JSON.write('date',NVL(r.ad,'')); APEX_JSON.write('description',NVL(r.descr,'')); APEX_JSON.write('orig',r.amt); APEX_JSON.write('amount',r.aed); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(NVL(d.distribution_amount_functi,d.distribution_amount)),0) INTO l_total
      FROM prod.ap_invoice_distributions d
      JOIN prod.dct_gl_coa_snap cid ON cid.cc_id = d.cc_id
      WHERE cid.cc_string = l_cc AND d.po_number IS NULL AND NVL(d.reversal_indicator,'N') <> 'Y'
        AND d.accounting_date >= l_ystart AND d.accounting_date < l_pnext;

  ELSIF l_metric IN ('obligation','popipeline') THEN   -- Total PO (all except Failed/Passed) / PO Pipeline (Failed/Passed)
    APEX_JSON.open_array('columns'); col('po','PO #','text'); col('line','Line','text'); col('description','Item / description','text'); col('supplier','Supplier','text'); col('status','Funds status','text'); col('amount','Ordered (AED)','money'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT order_number, po_line, item_description, supplier_name, po_status, amt FROM (
                SELECT h.order_number, pl.line po_line, pl.item_description, h.supplier_name, pd.funds_status po_status,
                       MAX(pd.distribution_amount*NVL(pd.rate,1)) amt
                FROM prod.po_distributions pd
                JOIN prod.po_headers h ON h.po_header_id = pd.po_header_id
                LEFT JOIN prod.po_lines pl ON pl.po_header_id = pd.po_header_id AND pl.po_line_id = pd.po_line_id
                WHERE prod.dct_cc_canon(pd.charge_account) = l_cc AND (pd.budget_date IS NULL OR pd.budget_date < l_pnext)
                  AND ( (l_metric='obligation' AND NVL(pd.funds_status,'x') NOT IN ('Failed','Passed'))
                     OR (l_metric='popipeline' AND pd.funds_status IN ('Failed','Passed')) )
                GROUP BY h.order_number, pl.line, pl.item_description, h.supplier_name, pd.funds_status, pd.po_distribution_id)
              ORDER BY amt DESC NULLS LAST FETCH FIRST 500 ROWS ONLY) LOOP
      APEX_JSON.open_object; APEX_JSON.write('po',NVL(TO_CHAR(r.order_number),'')); APEX_JSON.write('line',NVL(TO_CHAR(r.po_line),''));
      APEX_JSON.write('description',NVL(r.item_description,'')); APEX_JSON.write('supplier',NVL(r.supplier_name,''));
      APEX_JSON.write('status',NVL(r.po_status,'')); APEX_JSON.write('amount',r.amt); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(amt),0) INTO l_total FROM (
      SELECT MAX(pd.distribution_amount*NVL(pd.rate,1)) amt FROM prod.po_distributions pd
      WHERE prod.dct_cc_canon(pd.charge_account) = l_cc AND (pd.budget_date IS NULL OR pd.budget_date < l_pnext)
        AND ( (l_metric='obligation' AND NVL(pd.funds_status,'x') NOT IN ('Failed','Passed'))
           OR (l_metric='popipeline' AND pd.funds_status IN ('Failed','Passed')) )
      GROUP BY pd.po_distribution_id);

  ELSIF l_metric = 'openobligation' THEN   -- (Reserved + Partially Liquidated) NETTED by GRN received, excl. Finally Closed POs (remainder released)
    APEX_JSON.open_array('columns'); col('po','PO #','text'); col('line','Line','text'); col('description','Item / description','text'); col('status','Funds status','text'); col('ordered','Ordered (AED)','money'); col('grn','Received (AED)','money'); col('amount','Open (AED)','money'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT order_number, po_line, item_description, po_status, ordered, grn, GREATEST(ordered-grn,0) open_amt FROM (
                SELECT h.order_number, pl.line po_line, pl.item_description, pd.funds_status po_status,
                       MAX(pd.distribution_amount*NVL(pd.rate,1)) ordered, NVL(MAX(g.grn),0) grn
                FROM prod.po_distributions pd
                JOIN prod.po_headers h ON h.po_header_id = pd.po_header_id
                LEFT JOIN prod.po_lines pl ON pl.po_header_id = pd.po_header_id AND pl.po_line_id = pd.po_line_id
                LEFT JOIN (SELECT po_distribution_id, SUM(ledger_amount) grn FROM prod.grn_all_v2 GROUP BY po_distribution_id) g
                  ON g.po_distribution_id = pd.po_distribution_id
                WHERE prod.dct_cc_canon(pd.charge_account) = l_cc AND (pd.budget_date IS NULL OR pd.budget_date < l_pnext)
                  AND pd.funds_status IN ('Reserved','Partially Liquidated')
                  AND NOT EXISTS (SELECT 1 FROM prod.po_headers hx
                                  WHERE hx.po_header_id = pd.po_header_id AND hx.status = 'Finally Closed')
                GROUP BY h.order_number, pl.line, pl.item_description, pd.funds_status, pd.po_distribution_id)
              ORDER BY open_amt DESC NULLS LAST FETCH FIRST 500 ROWS ONLY) LOOP
      APEX_JSON.open_object; APEX_JSON.write('po',NVL(TO_CHAR(r.order_number),'')); APEX_JSON.write('line',NVL(TO_CHAR(r.po_line),''));
      APEX_JSON.write('description',NVL(r.item_description,'')); APEX_JSON.write('status',NVL(r.po_status,''));
      APEX_JSON.write('ordered',r.ordered); APEX_JSON.write('grn',r.grn); APEX_JSON.write('amount',r.open_amt); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(GREATEST(ordered-grn,0)),0) INTO l_total FROM (
      SELECT MAX(pd.distribution_amount*NVL(pd.rate,1)) ordered, NVL(MAX(g.grn),0) grn
      FROM prod.po_distributions pd
      LEFT JOIN (SELECT po_distribution_id, SUM(ledger_amount) grn FROM prod.grn_all_v2 GROUP BY po_distribution_id) g
        ON g.po_distribution_id = pd.po_distribution_id
      WHERE prod.dct_cc_canon(pd.charge_account) = l_cc AND (pd.budget_date IS NULL OR pd.budget_date < l_pnext)
        AND pd.funds_status IN ('Reserved','Partially Liquidated')
        AND NOT EXISTS (SELECT 1 FROM prod.po_headers hx
                        WHERE hx.po_header_id = pd.po_header_id AND hx.status = 'Finally Closed')
      GROUP BY pd.po_distribution_id);

  ELSIF l_metric IN ('commitment','opencommitment','commitmentpipeline') THEN   -- PR drills (real requisitions, db/v2/36)
    APEX_JSON.open_array('columns'); col('pr','PR #','text'); col('description','Description','text'); col('requester','Requester','text'); col('status','Funds status','text'); col('amount','Amount (AED)','money'); APEX_JSON.close_array;
    APEX_JSON.open_array('rows');
    FOR r IN (SELECT h.pr_number, h.description, d.requester, d.funds_status,
                     SUM(d.distribution_amount*NVL(c.exchange_rate_to_aed,1)) amt
              FROM prod.pr_distributions d
              JOIN prod.pr_headers h ON h.pr_header_id = d.pr_header_id
              LEFT JOIN prod.dct_currency_codes c ON c.currency_code = d.currency_code
              WHERE prod.dct_cc_canon(d.charge_account) = l_cc AND (d.budget_date IS NULL OR d.budget_date < l_pnext)
                AND ( (l_metric='commitment'         AND d.funds_status IN ('Reserved','Liquidated'))
                   OR (l_metric='opencommitment'     AND d.funds_status = 'Reserved')
                   OR (l_metric='commitmentpipeline' AND d.funds_status = 'Not reserved') )
              GROUP BY h.pr_number, h.description, d.requester, d.funds_status
              ORDER BY amt DESC NULLS LAST FETCH FIRST 500 ROWS ONLY) LOOP
      APEX_JSON.open_object; APEX_JSON.write('pr',NVL(TO_CHAR(r.pr_number),''));
      APEX_JSON.write('description',NVL(r.description,'')); APEX_JSON.write('requester',NVL(r.requester,''));
      APEX_JSON.write('status',NVL(r.funds_status,'')); APEX_JSON.write('amount',r.amt); APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    SELECT NVL(SUM(d.distribution_amount*NVL(c.exchange_rate_to_aed,1)),0) INTO l_total
      FROM prod.pr_distributions d
      LEFT JOIN prod.dct_currency_codes c ON c.currency_code = d.currency_code
      WHERE prod.dct_cc_canon(d.charge_account) = l_cc AND (d.budget_date IS NULL OR d.budget_date < l_pnext)
        AND ( (l_metric='commitment'         AND d.funds_status IN ('Reserved','Liquidated'))
           OR (l_metric='opencommitment'     AND d.funds_status = 'Reserved')
           OR (l_metric='commitmentpipeline' AND d.funds_status = 'Not reserved') );

  ELSE
    dct_rest.err(400,'Unknown metric'); RETURN;
  END IF;

  APEX_JSON.write('total', l_total);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));

    COMMIT;
END setup_gl_aclines_ords_tmp;
/

SHOW ERRORS

EXECUTE setup_gl_aclines_ords_tmp
DROP PROCEDURE setup_gl_aclines_ords_tmp;

PROMPT gl.rest actuals/lines handler upgraded (document numbers + line numbers).
EXIT
