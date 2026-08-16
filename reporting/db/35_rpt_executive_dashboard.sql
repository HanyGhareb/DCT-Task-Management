-- =============================================================================
-- Reporting Platform -- AP/AR Executive Dashboard endpoint (ADDITIVE)
-- File   : reporting/db/35_rpt_executive_dashboard.sql
-- Adds to: rpt.rest (does not rebuild the module)
-- Route  : GET /ords/admin/rpt/executive-aging?bu=<business unit>
--          GET /ords/admin/rpt/executive-aging/lines?metric=...&bu=...
-- Gate   : BI_USER or SYS_ADMIN
--
-- Accounting contract:
--   * open document = non-cancelled with a non-zero AED balance
--   * gross AP aging includes positive balances, including Partially Paid
--   * open credits remain signed and are reported separately
--   * the six aging buckets reconcile exactly to gross AP outstanding
--   * AR is deliberately marked DATA_GAP until payment schedules / receipts
--     provide due_date and remaining_amount_due; transaction totals are not AR
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

BEGIN
  ORDS.DEFINE_TEMPLATE(
    p_module_name => 'rpt.rest',
    p_pattern     => 'executive-aging'
  );
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest',
    p_pattern     => 'executive-aging',
    p_method      => 'GET',
    p_source_type => ORDS.source_type_plsql,
    p_source      => q'!
DECLARE
  l_user          VARCHAR2(100) := dct_rest.validate_session;
  l_asof          DATE := TRUNC(SYSDATE);
  l_open_count    NUMBER;
  l_overdue_count NUMBER;
  l_credit_count  NUMBER;
  l_gross_open    NUMBER;
  l_overdue       NUMBER;
  l_open_credits  NUMBER;
  l_net_exposure  NUMBER;
  l_partial_count NUMBER;
  l_partial_open  NUMBER;
  l_due_7         NUMBER;
  l_due_14        NUMBER;
  l_due_30        NUMBER;
  l_bucket_total  NUMBER;
  l_source_update DATE;
  l_ar_rows       NUMBER;

BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'BI_USER') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'BI access required'); RETURN;
  END IF;

  SELECT COUNT(CASE WHEN balance_aed > 0.005 THEN 1 END),
         COUNT(CASE WHEN balance_aed > 0.005 AND due_date < l_asof THEN 1 END),
         COUNT(CASE WHEN balance_aed < -0.005 THEN 1 END),
         NVL(SUM(CASE WHEN balance_aed > 0.005 THEN balance_aed ELSE 0 END),0),
         NVL(SUM(CASE WHEN balance_aed > 0.005 AND due_date < l_asof THEN balance_aed ELSE 0 END),0),
         NVL(SUM(CASE WHEN balance_aed < -0.005 THEN balance_aed ELSE 0 END),0),
         NVL(SUM(CASE WHEN ABS(balance_aed) > 0.005 THEN balance_aed ELSE 0 END),0),
         COUNT(CASE WHEN payment_status = 'Partially Paid' AND balance_aed > 0.005 THEN 1 END),
         NVL(SUM(CASE WHEN payment_status = 'Partially Paid' AND balance_aed > 0.005 THEN balance_aed ELSE 0 END),0),
         NVL(SUM(CASE WHEN balance_aed > 0.005 AND due_date BETWEEN l_asof AND l_asof + 7  THEN balance_aed ELSE 0 END),0),
         NVL(SUM(CASE WHEN balance_aed > 0.005 AND due_date BETWEEN l_asof AND l_asof + 14 THEN balance_aed ELSE 0 END),0),
         NVL(SUM(CASE WHEN balance_aed > 0.005 AND due_date BETWEEN l_asof AND l_asof + 30 THEN balance_aed ELSE 0 END),0),
         MAX(last_updated_date)
    INTO l_open_count, l_overdue_count, l_credit_count,
         l_gross_open, l_overdue, l_open_credits, l_net_exposure,
         l_partial_count, l_partial_open, l_due_7, l_due_14, l_due_30, l_source_update
    FROM (
      SELECT h.*,
             NVL(h.balance_due,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1) AS balance_aed
        FROM prod.ap_invoices_header_v h
       WHERE h.invoice_status <> 'Cancelled'
         AND (:bu IS NULL OR h.business_unit = :bu)
         AND (:supplier IS NULL OR UPPER(CASE WHEN h.supplier_name='BENEFICIARY' AND h.beneficiary_name IS NOT NULL THEN h.beneficiary_name ELSE h.supplier_name END) LIKE '%'||UPPER(:supplier)||'%')
         AND (:aging IS NULL OR CASE WHEN h.due_date >= l_asof THEN 'CURRENT' WHEN l_asof-h.due_date <= 30 THEN 'D1_30' WHEN l_asof-h.due_date <= 60 THEN 'D31_60' WHEN l_asof-h.due_date <= 90 THEN 'D61_90' WHEN l_asof-h.due_date <= 180 THEN 'D91_180' ELSE 'D180P' END = UPPER(:aging))
    );

  SELECT NVL(SUM(amount),0)
    INTO l_bucket_total
    FROM (
      SELECT SUM(balance_aed) amount
        FROM (
          SELECT h.due_date,
                 NVL(h.balance_due,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1) balance_aed
            FROM prod.ap_invoices_header_v h
           WHERE h.invoice_status <> 'Cancelled'
             AND (:bu IS NULL OR h.business_unit = :bu)
             AND (:supplier IS NULL OR UPPER(CASE WHEN h.supplier_name='BENEFICIARY' AND h.beneficiary_name IS NOT NULL THEN h.beneficiary_name ELSE h.supplier_name END) LIKE '%'||UPPER(:supplier)||'%')
             AND (:aging IS NULL OR CASE WHEN h.due_date >= l_asof THEN 'CURRENT' WHEN l_asof-h.due_date <= 30 THEN 'D1_30' WHEN l_asof-h.due_date <= 60 THEN 'D31_60' WHEN l_asof-h.due_date <= 90 THEN 'D61_90' WHEN l_asof-h.due_date <= 180 THEN 'D91_180' ELSE 'D180P' END = UPPER(:aging))
        )
       WHERE balance_aed > 0.005
       GROUP BY CASE WHEN due_date >= l_asof THEN 'CURRENT'
                     WHEN l_asof-due_date <= 30 THEN 'D1_30'
                     WHEN l_asof-due_date <= 60 THEN 'D31_60'
                     WHEN l_asof-due_date <= 90 THEN 'D61_90'
                     WHEN l_asof-due_date <= 180 THEN 'D91_180'
                     ELSE 'D180P' END
    );

  BEGIN
    SELECT COUNT(*) INTO l_ar_rows FROM prod.atd_ar_invoice_header_details;
  EXCEPTION WHEN OTHERS THEN l_ar_rows := 0;
  END;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('asOf', TO_CHAR(l_asof,'YYYY-MM-DD'));
  APEX_JSON.write('generatedAt', TO_CHAR(SYSTIMESTAMP,'YYYY-MM-DD"T"HH24:MI:SS'));
  APEX_JSON.write('currency', 'AED');
  APEX_JSON.write('businessUnit', NVL(:bu,'ALL'));

  APEX_JSON.open_array('businessUnits');
  FOR r IN (SELECT DISTINCT business_unit v FROM prod.ap_invoices_header_v
             WHERE business_unit IS NOT NULL ORDER BY business_unit) LOOP
    APEX_JSON.write(r.v);
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_object('ap');
  APEX_JSON.write('status','READY');
  APEX_JSON.write('sourceUpdatedAt', TO_CHAR(l_source_update,'YYYY-MM-DD'));
  APEX_JSON.write('openCount', l_open_count);
  APEX_JSON.write('overdueCount', l_overdue_count);
  APEX_JSON.write('creditCount', l_credit_count);
  APEX_JSON.write('netDocumentCount', l_open_count+l_credit_count);
  APEX_JSON.write('grossOutstandingAed', ROUND(l_gross_open,2));
  APEX_JSON.write('overdueAed', ROUND(l_overdue,2));
  APEX_JSON.write('overduePct', CASE WHEN l_gross_open = 0 THEN 0 ELSE ROUND(l_overdue/l_gross_open*100,1) END);
  APEX_JSON.write('openCreditsAed', ROUND(l_open_credits,2));
  APEX_JSON.write('creditPct', CASE WHEN l_gross_open = 0 THEN 0 ELSE ROUND(ABS(l_open_credits)/l_gross_open*100,1) END);
  APEX_JSON.write('netExposureAed', ROUND(l_net_exposure,2));
  APEX_JSON.write('netPct', CASE WHEN l_gross_open = 0 THEN 0 ELSE ROUND(l_net_exposure/l_gross_open*100,1) END);
  APEX_JSON.write('partialCount', l_partial_count);
  APEX_JSON.write('partialOpenAed', ROUND(l_partial_open,2));
  APEX_JSON.open_object('upcoming');
  APEX_JSON.write('days7', ROUND(l_due_7,2));
  APEX_JSON.write('days14', ROUND(l_due_14,2));
  APEX_JSON.write('days30', ROUND(l_due_30,2));
  APEX_JSON.close_object;
  APEX_JSON.open_object('reconciliation');
  APEX_JSON.write('bucketTotalAed', ROUND(l_bucket_total,2));
  APEX_JSON.write('differenceAed', ROUND(l_gross_open-l_bucket_total,2));
  APEX_JSON.write('trusted', ABS(l_gross_open-l_bucket_total) < 0.01);
  APEX_JSON.close_object;

  APEX_JSON.open_array('aging');
  FOR r IN (
    WITH buckets AS (
      SELECT 'CURRENT' code, 1 seq FROM dual UNION ALL SELECT 'D1_30',2 FROM dual
      UNION ALL SELECT 'D31_60',3 FROM dual UNION ALL SELECT 'D61_90',4 FROM dual
      UNION ALL SELECT 'D91_180',5 FROM dual UNION ALL SELECT 'D180P',6 FROM dual
    ), aged AS (
      SELECT CASE WHEN due_date >= l_asof THEN 'CURRENT'
                  WHEN l_asof-due_date <= 30 THEN 'D1_30'
                  WHEN l_asof-due_date <= 60 THEN 'D31_60'
                  WHEN l_asof-due_date <= 90 THEN 'D61_90'
                  WHEN l_asof-due_date <= 180 THEN 'D91_180'
                  ELSE 'D180P' END code,
             COUNT(*) invoice_count, SUM(balance_aed) amount
        FROM (
          SELECT h.due_date, NVL(h.balance_due,0) * NVL(h.invoice_amount_aed/NULLIF(h.invoice_amount,0),1) balance_aed
            FROM prod.ap_invoices_header_v h
           WHERE h.invoice_status <> 'Cancelled'
             AND (:bu IS NULL OR h.business_unit = :bu)
             AND (:supplier IS NULL OR UPPER(CASE WHEN h.supplier_name='BENEFICIARY' AND h.beneficiary_name IS NOT NULL THEN h.beneficiary_name ELSE h.supplier_name END) LIKE '%'||UPPER(:supplier)||'%')
             AND (:aging IS NULL OR CASE WHEN h.due_date >= l_asof THEN 'CURRENT' WHEN l_asof-h.due_date <= 30 THEN 'D1_30' WHEN l_asof-h.due_date <= 60 THEN 'D31_60' WHEN l_asof-h.due_date <= 90 THEN 'D61_90' WHEN l_asof-h.due_date <= 180 THEN 'D91_180' ELSE 'D180P' END = UPPER(:aging))
        )
       WHERE balance_aed > 0.005
       GROUP BY CASE WHEN due_date >= l_asof THEN 'CURRENT'
                     WHEN l_asof-due_date <= 30 THEN 'D1_30'
                     WHEN l_asof-due_date <= 60 THEN 'D31_60'
                     WHEN l_asof-due_date <= 90 THEN 'D61_90'
                     WHEN l_asof-due_date <= 180 THEN 'D91_180'
                     ELSE 'D180P' END
    )
    SELECT b.code, NVL(a.invoice_count,0) invoice_count, NVL(a.amount,0) amount
      FROM buckets b LEFT JOIN aged a ON a.code=b.code ORDER BY b.seq
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('bucket',r.code); APEX_JSON.write('count',r.invoice_count);
    APEX_JSON.write('amount',ROUND(r.amount,2));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('topSuppliers');
  FOR r IN (
    SELECT effective_supplier supplier, COUNT(*) invoice_count, SUM(balance_aed) amount,
           MAX(l_asof-due_date) max_days_past_due
      FROM (
        SELECT CASE WHEN h.supplier_name='BENEFICIARY' AND h.beneficiary_name IS NOT NULL
                    THEN h.beneficiary_name ELSE h.supplier_name END effective_supplier,
               h.due_date, NVL(h.balance_due,0) * NVL(h.invoice_amount_aed/NULLIF(h.invoice_amount,0),1) balance_aed
          FROM prod.ap_invoices_header_v h
         WHERE h.invoice_status <> 'Cancelled' AND h.due_date < l_asof
           AND (:bu IS NULL OR h.business_unit = :bu)
           AND (:supplier IS NULL OR UPPER(CASE WHEN h.supplier_name='BENEFICIARY' AND h.beneficiary_name IS NOT NULL THEN h.beneficiary_name ELSE h.supplier_name END) LIKE '%'||UPPER(:supplier)||'%')
           AND (:aging IS NULL OR CASE WHEN h.due_date >= l_asof THEN 'CURRENT' WHEN l_asof-h.due_date <= 30 THEN 'D1_30' WHEN l_asof-h.due_date <= 60 THEN 'D31_60' WHEN l_asof-h.due_date <= 90 THEN 'D61_90' WHEN l_asof-h.due_date <= 180 THEN 'D91_180' ELSE 'D180P' END = UPPER(:aging))
      )
     WHERE balance_aed > 0.005
     GROUP BY effective_supplier ORDER BY amount DESC FETCH FIRST 10 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('supplier',r.supplier); APEX_JSON.write('count',r.invoice_count);
    APEX_JSON.write('amount',ROUND(r.amount,2)); APEX_JSON.write('maxDaysPastDue',r.max_days_past_due);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('attention');
  FOR r IN (
    SELECT * FROM (
      SELECT h.invoice_id, h.invoice_number,
             CASE WHEN h.supplier_name='BENEFICIARY' AND h.beneficiary_name IS NOT NULL
                  THEN h.beneficiary_name ELSE h.supplier_name END supplier,
             h.business_unit, h.due_date, l_asof-h.due_date days_past_due,
             h.payment_status, h.validation_status, h.approval_status,
             NVL(h.balance_due,0) * NVL(h.invoice_amount_aed/NULLIF(h.invoice_amount,0),1) balance_aed
        FROM prod.ap_invoices_header_v h
       WHERE h.invoice_status <> 'Cancelled' AND h.due_date < l_asof
         AND (:bu IS NULL OR h.business_unit = :bu)
         AND (:supplier IS NULL OR UPPER(CASE WHEN h.supplier_name='BENEFICIARY' AND h.beneficiary_name IS NOT NULL THEN h.beneficiary_name ELSE h.supplier_name END) LIKE '%'||UPPER(:supplier)||'%')
         AND (:aging IS NULL OR CASE WHEN h.due_date >= l_asof THEN 'CURRENT' WHEN l_asof-h.due_date <= 30 THEN 'D1_30' WHEN l_asof-h.due_date <= 60 THEN 'D31_60' WHEN l_asof-h.due_date <= 90 THEN 'D61_90' WHEN l_asof-h.due_date <= 180 THEN 'D91_180' ELSE 'D180P' END = UPPER(:aging))
    ) WHERE balance_aed > 0.005
    ORDER BY balance_aed DESC FETCH FIRST 15 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('invoiceId',r.invoice_id); APEX_JSON.write('invoiceNumber',r.invoice_number);
    APEX_JSON.write('supplier',r.supplier); APEX_JSON.write('businessUnit',r.business_unit);
    APEX_JSON.write('dueDate',TO_CHAR(r.due_date,'YYYY-MM-DD'));
    APEX_JSON.write('daysPastDue',r.days_past_due); APEX_JSON.write('balanceAed',ROUND(r.balance_aed,2));
    APEX_JSON.write('paymentStatus',r.payment_status); APEX_JSON.write('validationStatus',r.validation_status);
    APEX_JSON.write('approvalStatus',r.approval_status);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;

  APEX_JSON.open_object('ar');
  APEX_JSON.write('status','DATA_GAP');
  APEX_JSON.write('transactionRows',l_ar_rows);
  APEX_JSON.write('reason','AR transactions exist, but payment-schedule due dates and remaining balances are not yet extracted.');
  APEX_JSON.write('requiredSource','Fusion Receivables payment schedules, receipts and applications');
  APEX_JSON.close_object;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;!'
  );
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(
    p_module_name => 'rpt.rest',
    p_pattern     => 'executive-aging/lines'
  );
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest',
    p_pattern     => 'executive-aging/lines',
    p_method      => 'GET',
    p_source_type => ORDS.source_type_plsql,
    p_source      => q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_metric VARCHAR2(30) := LOWER(TRIM(:metric));
  l_bucket VARCHAR2(20) := UPPER(TRIM(:bucket));
  l_party  VARCHAR2(500) := :party;
  l_asof   DATE := TRUNC(SYSDATE);
  l_count  NUMBER;
  l_total  NUMBER;
  l_cap    CONSTANT PLS_INTEGER := 1000;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'BI_USER') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'BI access required'); RETURN;
  END IF;
  IF l_metric NOT IN ('outstanding','overdue','credits','net','partial','due7','due14','due30','aging','supplier') THEN
    dct_rest.err(400,'Unsupported executive aging metric'); RETURN;
  END IF;

  SELECT COUNT(*), NVL(SUM(balance_aed),0)
    INTO l_count, l_total
    FROM (
      SELECT h.due_date, h.payment_status,
             CASE WHEN h.supplier_name='BENEFICIARY' AND h.beneficiary_name IS NOT NULL
                  THEN h.beneficiary_name ELSE h.supplier_name END effective_supplier,
             NVL(h.balance_due,0)*NVL(h.invoice_amount_aed/NULLIF(h.invoice_amount,0),1) balance_aed,
             CASE WHEN h.due_date >= l_asof THEN 'CURRENT'
                  WHEN l_asof-h.due_date <= 30 THEN 'D1_30'
                  WHEN l_asof-h.due_date <= 60 THEN 'D31_60'
                  WHEN l_asof-h.due_date <= 90 THEN 'D61_90'
                  WHEN l_asof-h.due_date <= 180 THEN 'D91_180' ELSE 'D180P' END aging_bucket
        FROM prod.ap_invoices_header_v h
       WHERE h.invoice_status <> 'Cancelled'
         AND (:bu IS NULL OR h.business_unit=:bu)
         AND (:supplier IS NULL OR UPPER(CASE WHEN h.supplier_name='BENEFICIARY' AND h.beneficiary_name IS NOT NULL THEN h.beneficiary_name ELSE h.supplier_name END) LIKE '%'||UPPER(:supplier)||'%')
         AND (:aging IS NULL OR CASE WHEN h.due_date >= l_asof THEN 'CURRENT' WHEN l_asof-h.due_date <= 30 THEN 'D1_30' WHEN l_asof-h.due_date <= 60 THEN 'D31_60' WHEN l_asof-h.due_date <= 90 THEN 'D61_90' WHEN l_asof-h.due_date <= 180 THEN 'D91_180' ELSE 'D180P' END = UPPER(:aging))
    )
   WHERE (l_metric='outstanding' AND balance_aed>0.005
       OR l_metric='overdue'     AND balance_aed>0.005 AND due_date<l_asof
       OR l_metric='credits'     AND balance_aed< -0.005
       OR l_metric='net'         AND ABS(balance_aed)>0.005
       OR l_metric='partial'     AND balance_aed>0.005 AND payment_status='Partially Paid'
       OR l_metric='due7'        AND balance_aed>0.005 AND due_date BETWEEN l_asof AND l_asof+7
       OR l_metric='due14'       AND balance_aed>0.005 AND due_date BETWEEN l_asof AND l_asof+14
       OR l_metric='due30'       AND balance_aed>0.005 AND due_date BETWEEN l_asof AND l_asof+30
       OR l_metric='aging'       AND balance_aed>0.005 AND aging_bucket=l_bucket
       OR l_metric='supplier'    AND balance_aed>0.005 AND due_date<l_asof AND effective_supplier=l_party);

  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('metric',l_metric); APEX_JSON.write('bucket',NVL(l_bucket,''));
  APEX_JSON.write('businessUnit',NVL(:bu,'ALL')); APEX_JSON.write('count',l_count);
  APEX_JSON.write('totalAed',ROUND(l_total,2)); APEX_JSON.write('cap',l_cap);
  APEX_JSON.write('capped',l_count>l_cap);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT * FROM (
      SELECT h.invoice_id, h.invoice_number,
             CASE WHEN h.supplier_name='BENEFICIARY' AND h.beneficiary_name IS NOT NULL
                  THEN h.beneficiary_name ELSE h.supplier_name END supplier,
             h.business_unit, h.invoice_date, h.due_date,
             CASE WHEN h.due_date<l_asof THEN l_asof-h.due_date ELSE 0 END days_past_due,
             h.payment_status, h.validation_status, h.approval_status,
             NVL(h.balance_due,0)*NVL(h.invoice_amount_aed/NULLIF(h.invoice_amount,0),1) balance_aed,
             CASE WHEN h.due_date >= l_asof THEN 'CURRENT'
                  WHEN l_asof-h.due_date <= 30 THEN 'D1_30'
                  WHEN l_asof-h.due_date <= 60 THEN 'D31_60'
                  WHEN l_asof-h.due_date <= 90 THEN 'D61_90'
                  WHEN l_asof-h.due_date <= 180 THEN 'D91_180' ELSE 'D180P' END aging_bucket
        FROM prod.ap_invoices_header_v h
       WHERE h.invoice_status <> 'Cancelled'
         AND (:bu IS NULL OR h.business_unit=:bu)
         AND (:supplier IS NULL OR UPPER(CASE WHEN h.supplier_name='BENEFICIARY' AND h.beneficiary_name IS NOT NULL THEN h.beneficiary_name ELSE h.supplier_name END) LIKE '%'||UPPER(:supplier)||'%')
         AND (:aging IS NULL OR CASE WHEN h.due_date >= l_asof THEN 'CURRENT' WHEN l_asof-h.due_date <= 30 THEN 'D1_30' WHEN l_asof-h.due_date <= 60 THEN 'D31_60' WHEN l_asof-h.due_date <= 90 THEN 'D61_90' WHEN l_asof-h.due_date <= 180 THEN 'D91_180' ELSE 'D180P' END = UPPER(:aging))
    ) x
    WHERE (l_metric='outstanding' AND balance_aed>0.005
        OR l_metric='overdue'     AND balance_aed>0.005 AND due_date<l_asof
        OR l_metric='credits'     AND balance_aed< -0.005
        OR l_metric='net'         AND ABS(balance_aed)>0.005
        OR l_metric='partial'     AND balance_aed>0.005 AND payment_status='Partially Paid'
        OR l_metric='due7'        AND balance_aed>0.005 AND due_date BETWEEN l_asof AND l_asof+7
        OR l_metric='due14'       AND balance_aed>0.005 AND due_date BETWEEN l_asof AND l_asof+14
        OR l_metric='due30'       AND balance_aed>0.005 AND due_date BETWEEN l_asof AND l_asof+30
        OR l_metric='aging'       AND balance_aed>0.005 AND aging_bucket=l_bucket
        OR l_metric='supplier'    AND balance_aed>0.005 AND due_date<l_asof AND supplier=l_party)
    ORDER BY ABS(balance_aed) DESC FETCH FIRST l_cap ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('invoiceId',r.invoice_id); APEX_JSON.write('invoiceNumber',r.invoice_number);
    APEX_JSON.write('supplier',r.supplier); APEX_JSON.write('businessUnit',r.business_unit);
    APEX_JSON.write('invoiceDate',TO_CHAR(r.invoice_date,'YYYY-MM-DD'));
    APEX_JSON.write('dueDate',TO_CHAR(r.due_date,'YYYY-MM-DD'));
    APEX_JSON.write('daysPastDue',r.days_past_due); APEX_JSON.write('balanceAed',ROUND(r.balance_aed,2));
    APEX_JSON.write('paymentStatus',r.payment_status); APEX_JSON.write('validationStatus',r.validation_status);
    APEX_JSON.write('approvalStatus',r.approval_status); APEX_JSON.write('agingBucket',r.aging_bucket);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;!'
  );
  COMMIT;
END;
/

PROMPT 35_rpt_executive_dashboard.sql complete
