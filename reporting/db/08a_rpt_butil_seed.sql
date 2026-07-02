-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 08a Budget Utilization by Sector seed
-- File   : reporting/db/08a_rpt_butil_seed.sql   (invoked by 08_rpt_butil_sector.sql)
-- Keep ZERO blank lines inside every statement in this file. The Linux dev
-- VM SQLcl 26.1 cannot run this file at all (script-reader bug: big blocks
-- echoed or silently skipped; diagnose with SET ECHO ON) -- deploy from the
-- Windows SQLcl via sql -name prod_mcp, where this shape is proven.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. MULTI source type + BUDGET_UTIL_SECTOR definition + recipient + schedule ===
DECLARE
  l_scope VARCHAR2(1000);
  l_intro VARCHAR2(4000);
  l_util  VARCHAR2(2000);
  l_inv   VARCHAR2(2000);
  l_grn   VARCHAR2(2000);
  l_po    VARCHAR2(2000);
  l_pr    VARCHAR2(2000);
  l_src   CLOB;
  l_body  CLOB;
BEGIN
  -- lookup-first vocabulary: RPT_SOURCE_TYPE gains the MULTI value
  MERGE INTO prod.dct_lookup_values t
  USING (SELECT c.category_id, 'MULTI' AS value_code
           FROM prod.dct_lookup_categories c
          WHERE c.category_code = 'RPT_SOURCE_TYPE') s
  ON (t.category_id = s.category_id AND t.value_code = s.value_code)
  WHEN NOT MATCHED THEN
    INSERT (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
    VALUES (s.category_id, 'MULTI', 'Multi-Section (JSON)',
            UNISTR('\0645\062A\0639\062F\062F \0627\0644\0623\0642\0633\0627\0645'), 40, 'N', 'Y');
  -- shared sector-scope predicate: rows whose project + task belong to the
  -- selected budget year x sector (x optional project type / cost centre)
  l_scope := q'! AND (x.project_number, NVL(x.task_number,'~')) IN (SELECT s.project_number, NVL(s.task_number,'~') FROM prod.dct_butil_scope_v s WHERE s.budget_year = [COLON]year AND s.sector = [COLON]sector AND ([COLON]projecttype IS NULL OR s.project_type = [COLON]projecttype) AND ([COLON]costcenter IS NULL OR s.cost_centre = [COLON]costcenter))!';
  -- part 1: sector master details + KPI summary (single row, key-value layout)
  l_intro := q'!SELECT s.value_code AS sector_code, s.name_en AS sector_name, s.name_ar AS sector_name_arabic, s.cost_centres AS mapped_cost_centres, b.projects, b.tasks, b.budget_lines, b.budget, b.actual_ap, b.actual_grn, b.commitment_pr, b.obligation_po, b.fund_available, b.utilization_pct FROM (SELECT MAX(v.value_code) AS value_code, MAX(v.name_en) AS name_en, MAX(v.name_ar) AS name_ar, LISTAGG(DISTINCT m.segment_value, ', ' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY m.segment_value) AS cost_centres FROM prod.dct_gl_class_value v LEFT JOIN prod.dct_gl_seg_class_map m ON m.class_value_id = v.class_value_id AND m.class_type_code = 'SECTOR' AND TRUNC(SYSDATE) BETWEEN m.start_date AND NVL(m.end_date, DATE '9999-12-31') WHERE v.class_type_code = 'SECTOR' AND UPPER(v.name_en) = UPPER([COLON]sector)) s CROSS JOIN (SELECT COUNT(DISTINCT project_number) AS projects, COUNT(DISTINCT task_number) AS tasks, COUNT(*) AS budget_lines, SUM(budget) AS budget, SUM(actual_ap) AS actual_ap, SUM(actual_grn) AS actual_grn, SUM(commitment_pr) AS commitment_pr, SUM(obligation_po) AS obligation_po, SUM(fund_available) AS fund_available, ROUND(100 * (SUM(actual_ap) + SUM(actual_grn) + SUM(commitment_pr) + SUM(obligation_po)) / NULLIF(SUM(budget),0), 1) AS utilization_pct FROM prod.dct_budget_utilization_v WHERE budget_year = [COLON]year AND sector = [COLON]sector AND ([COLON]projecttype IS NULL OR project_type = [COLON]projecttype) AND ([COLON]costcenter IS NULL OR cost_centre = [COLON]costcenter)) b!';
  -- part 2: budget utilization rows (same figures as the GL Budget Utilization page)
  l_util := q'!SELECT x.department, x.cost_centre, x.project_number, x.project_name, x.task_number, x.gl_account, x.chapter, x.program, x.expenditure_type, x.budget, x.actual_ap, x.actual_grn, x.commitment_pr, x.obligation_po, x.fund_available FROM prod.dct_budget_utilization_v x WHERE x.budget_year = [COLON]year AND x.sector = [COLON]sector AND ([COLON]projecttype IS NULL OR x.project_type = [COLON]projecttype) AND ([COLON]costcenter IS NULL OR x.cost_centre = [COLON]costcenter) ORDER BY x.project_number, x.task_number, x.expenditure_type!';
  -- part 3: unpaid + partially paid invoices
  l_inv := q'!SELECT x.project_number, x.project_name, x.task_number, x.expenditure_type, x.invoice_number, x.invoice_date, x.supplier_name, x.invoice_currency AS currency, x.invoice_amount, x.invoice_amount_paid AS amount_paid, x.balance_due, x.payment_status, x.has_po FROM prod.dct_unpaid_invoices_v x WHERE x.budget_year = [COLON]year AND x.payment_status IN ('Unpaid','Partially Paid')!' || l_scope ||
           q'! ORDER BY x.project_number, x.task_number, x.expenditure_type, x.invoice_date!';
  -- part 4: uninvoiced GRN
  l_grn := q'!SELECT x.project_number, x.project_name, x.task_number, x.expenditure_type, x.po_number, x.po_line, x.supplier_name, x.last_receipt_date, x.receipt_lines, x.received_aed, x.invoiced_aed, x.uninvoiced_aed FROM prod.dct_uninvoiced_grn_v x WHERE x.budget_year = [COLON]year!' || l_scope ||
           q'! ORDER BY x.uninvoiced_aed DESC!';
  -- part 5: open purchase orders (GRN-netted)
  l_po := q'!SELECT x.project_number, x.project_name, x.task_number, x.expenditure_type, x.po_number, x.po_line, x.budget_date, x.supplier_name, x.funds_status, x.line_aed, x.received_aed, x.open_aed FROM prod.dct_open_po_lines_v x WHERE x.budget_year = [COLON]year!' || l_scope ||
          q'! ORDER BY x.open_aed DESC!';
  -- part 6: reserved purchase requisitions
  l_pr := q'!SELECT x.project_number, x.project_name, x.task_number, x.expenditure_type, x.pr_number, x.description, x.budget_date, x.currency_code AS currency, x.distribution_amount, x.amount_aed FROM prod.dct_reserved_pr_lines_v x WHERE x.budget_year = [COLON]year!' || l_scope ||
          q'! ORDER BY x.amount_aed DESC!';
  l_src := '{"orientation":"landscape","required":["year","sector"],"sections":['
        || '{"key":"intro","title":"Sector Overview","layout":"kv","sql":"' || l_intro || '"}' || ','
        || '{"key":"utilization","title":"Budget Utilization","layout":"table","sql":"' || l_util || '"}'  || ','
        || '{"key":"unpaid_invoices","title":"Unpaid and Partially Paid Invoices","layout":"table","sql":"' || l_inv || '"}'   || ','
        || '{"key":"uninvoiced_grn","title":"Uninvoiced GRN","layout":"table","sql":"' || l_grn || '"}'   || ','
        || '{"key":"open_po","title":"Open Purchase Orders","layout":"table","sql":"' || l_po || '"}'    || ','
        || '{"key":"reserved_pr","title":"Reserved Purchase Requisitions","layout":"table","sql":"' || l_pr || '"}'
        || ']}';
  l_src := REPLACE(l_src, '[COLON]', CHR(58));
  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>Budget Utilization by Sector</strong> executive report for '||
    '<strong>{{ params.sector }}</strong>, budget year <strong>{{ params.year }}</strong> '||
    'is attached (PDF + Excel). It covers {{ row_count }} detail lines across 6 sections.</p>'||
    '<p>Generated {{ generated_at }} by i-Finance Reporting.</p>';
  MERGE INTO prod.dct_rpt_definition t
  USING (SELECT 'BUDGET_UTIL_SECTOR' AS report_code FROM dual) s
  ON (t.report_code = s.report_code)
  WHEN NOT MATCHED THEN INSERT
    (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
     default_formats, pdf_template, email_subject_tpl, email_body_tpl, params_json,
     enabled, created_by, updated_by)
  VALUES
    ('BUDGET_UTIL_SECTOR',
     'Budget Utilization by Sector (Executive)',
     UNISTR('\0627\0633\062A\062E\062F\0627\0645 \0627\0644\0645\0648\0627\0632\0646\0629 \062D\0633\0628 \0627\0644\0642\0637\0627\0639'),
     '6-part executive pack per sector: overview, budget utilization (budget / AP / GRN / PR / PO / fund available), unpaid and partially paid invoices, uninvoiced GRN, open POs and reserved PRs. Parameters: year + sector (required), projecttype + costcenter (optional).',
     'General Ledger', 'MULTI', l_src, 'PYTHON', 'PDF,XLSX',
     'budget_util_sector.html.j2',
     'Budget Utilization - {{ params.sector }} - {{ params.year }}',
     l_body,
     '{"year":null,"sector":null,"projecttype":null,"costcenter":null}',
     'Y', 'SETUP', 'SETUP')
  WHEN MATCHED THEN UPDATE SET
     t.source_type       = 'MULTI',
     t.source_ref        = l_src,
     t.engine            = 'PYTHON',
     t.pdf_template      = 'budget_util_sector.html.j2',
     t.email_subject_tpl = 'Budget Utilization - {{ params.sector }} - {{ params.year }}',
     t.email_body_tpl    = l_body,
     t.params_json       = '{"year":null,"sector":null,"projecttype":null,"costcenter":null}',
     t.updated_by        = 'SETUP',
     t.updated_at        = SYSTIMESTAMP;
  MERGE INTO prod.dct_rpt_recipient t
  USING (SELECT 'BUDGET_UTIL_SECTOR' AS rc, 'SELF' AS rt FROM dual) s
  ON (t.report_code = s.rc AND t.recipient_type = s.rt)
  WHEN NOT MATCHED THEN INSERT
    (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
  VALUES
    ('BUDGET_UTIL_SECTOR', 'SELF', NULL, 'EMAIL', 'Y', 'SETUP', 'SETUP');
  MERGE INTO prod.dct_rpt_schedule t
  USING (SELECT 'BUDGET_UTIL_SECTOR' AS rc, 'Monthly (5th, 07:30)' AS nm FROM dual) s
  ON (t.report_code = s.rc AND t.schedule_name = s.nm)
  WHEN NOT MATCHED THEN INSERT
    (report_code, schedule_name, repeat_interval, timezone, criteria_json, enabled, created_by, updated_by)
  VALUES
    ('BUDGET_UTIL_SECTOR', 'Monthly (5th, 07:30)',
     'FREQ=MONTHLY;BYMONTHDAY=5;BYHOUR=7;BYMINUTE=30', 'Asia/Dubai',
     '{"year":null,"sector":null}', 'N', 'SETUP', 'SETUP');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('MULTI source type + BUDGET_UTIL_SECTOR seeded (definition + SELF recipient + sample schedule).');
END;
/


PROMPT 08a_rpt_butil_seed.sql complete.
