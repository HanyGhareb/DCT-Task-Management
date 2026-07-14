-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 21 Budget Utilization Briefing Book seed
-- File   : reporting/db/21_rpt_butil_book.sql
-- Seeds  : BUDGET_UTIL_BOOK -- "Briefing Book" MULTI report (PDF via the
--          budget_util_book.html.j2 Chromium template): cover + contents,
--          Part 1 overview (KPIs + charts + sector table + pressure lines),
--          Part 2 actuals (all direct AP invoices + all GRN receipts),
--          Part 3 open obligations (PO, GRN-netted),
--          Part 4 open commitments (reserved PR), Part 5 insights.
--          Params: year REQUIRED; sector / projecttype / costcenter optional
--          (empty sector = the whole organisation).
-- Data   : prod.dct_budget_utilization_v (db/v2/37) + detail views (db/v2/39);
--          the GRN section inlines the receipts query (the 39 view only keeps
--          uninvoiced balances; the book lists ALL receipts).
-- Deploy : Windows SQLcl (sql -name prod_mcp) OR python-oracledb (the Linux
--          SQLcl 26.1 script reader swallows big MERGE-bearing blocks).
--          After seeding, upload the template:
--            python runner/upload_template.py templates/budget_util_book.html.j2 --ords
-- Idempotent: MERGE + guarded UPDATE; safe to re-run (re-runs refresh source).
-- CRLF + UTF-8 no BOM. Zero blank lines inside statements.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. BUDGET_UTIL_BOOK definition (MULTI, 7 sections) ===
DECLARE
  l_bscope VARCHAR2(400);
  l_scope  VARCHAR2(1000);
  l_ov     VARCHAR2(2000);
  l_sec    VARCHAR2(2000);
  l_prs    VARCHAR2(2000);
  l_ap     VARCHAR2(2000);
  l_grn    VARCHAR2(4000);
  l_po     VARCHAR2(2000);
  l_pr     VARCHAR2(2000);
  l_src    CLOB;
  l_body   CLOB;
BEGIN
  -- shared predicates: butil view directly / detail views via the scope view
  l_bscope := q'! WHERE budget_year = [COLON]year AND ([COLON]sector IS NULL OR sector = [COLON]sector) AND ([COLON]projecttype IS NULL OR project_type = [COLON]projecttype) AND ([COLON]costcenter IS NULL OR cost_centre = [COLON]costcenter)!';
  l_scope  := q'! AND (x.project_number, NVL(x.task_number,'~')) IN (SELECT s.project_number, NVL(s.task_number,'~') FROM prod.dct_butil_scope_v s WHERE s.budget_year = [COLON]year AND ([COLON]sector IS NULL OR s.sector = [COLON]sector) AND ([COLON]projecttype IS NULL OR s.project_type = [COLON]projecttype) AND ([COLON]costcenter IS NULL OR s.cost_centre = [COLON]costcenter))!';
  -- part 1a: one-row overview (KPIs)
  l_ov := q'!SELECT COUNT(DISTINCT sector) AS sectors, COUNT(DISTINCT project_number) AS projects, COUNT(DISTINCT project_number||'~'||NVL(task_number,'~')) AS tasks, COUNT(*) AS budget_lines, SUM(budget) AS budget, SUM(actual_ap) AS actual_ap, SUM(actual_grn) AS actual_grn, SUM(actual_ap)+SUM(actual_grn) AS actual_total, SUM(obligation_po) AS obligation_po, SUM(commitment_pr) AS commitment_pr, SUM(fund_available) AS fund_available, ROUND(100*(SUM(actual_ap)+SUM(actual_grn)+SUM(commitment_pr)+SUM(obligation_po))/NULLIF(SUM(budget),0),1) AS utilization_pct, COUNT(CASE WHEN fund_available < -0.005 THEN 1 END) AS over_budget_lines FROM prod.dct_budget_utilization_v!' || l_bscope;
  -- part 1b: sector rollup (table + charts)
  l_sec := q'!SELECT NVL(sector,'(Unclassified)') AS sector, COUNT(DISTINCT project_number) AS projects, SUM(budget) AS budget, SUM(actual_ap) AS actual_ap, SUM(actual_grn) AS actual_grn, SUM(obligation_po) AS obligation_po, SUM(commitment_pr) AS commitment_pr, SUM(fund_available) AS fund_available, ROUND(100*(SUM(actual_ap)+SUM(actual_grn)+SUM(commitment_pr)+SUM(obligation_po))/NULLIF(SUM(budget),0),1) AS utilization_pct FROM prod.dct_budget_utilization_v!' || l_bscope || q'! GROUP BY NVL(sector,'(Unclassified)') ORDER BY 3 DESC!';
  -- part 1c: budget lines under pressure (least remaining funds)
  l_prs := q'!SELECT sector, project_number, project_name, task_number, expenditure_type, budget, actual_ap + actual_grn AS actual, obligation_po, commitment_pr, fund_available, ROUND(100*(actual_ap+actual_grn+commitment_pr+obligation_po)/NULLIF(budget,0),1) AS utilization_pct FROM prod.dct_budget_utilization_v!' || l_bscope || q'! AND budget > 0 ORDER BY fund_available ASC NULLS LAST FETCH FIRST 15 ROWS ONLY!';
  -- part 2a: ALL direct AP invoices (the utilization Actual AP register);
  -- zero-amount lines excluded (they add nothing, totals still reconcile)
  l_ap := q'!SELECT x.project_number, x.project_name, x.task_number, x.expenditure_type, x.invoice_number, x.invoice_date, x.supplier_name, x.invoice_currency AS currency, x.matched_aed, x.payment_status FROM prod.dct_unpaid_invoices_v x WHERE x.budget_year = [COLON]year AND x.has_po = 'N' AND ABS(NVL(x.matched_aed,0)) > 0.005!' || l_scope || q'! ORDER BY x.matched_aed DESC!';
  -- part 2b: ALL GRN receipts per PO distribution (inline; 39's view keeps
  -- only uninvoiced balances, the book lists every receipt)
  l_grn := q'!SELECT x.project_number, x.project_name, x.task_number, x.expenditure_type, x.po_number, x.po_line, x.supplier_name, x.last_receipt_date, x.receipt_lines, x.received_aed, x.invoiced_aed, x.received_aed - x.invoiced_aed AS uninvoiced_aed FROM (SELECT EXTRACT(YEAR FROM b.budget_date) AS budget_year, COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(b.project_id)) AS project_number, pj.project_name, COALESCE(tk.task_number, CASE WHEN b.task_id IS NOT NULL THEN '#'||TO_CHAR(b.task_id) END) AS task_number, b.expenditure_type, h.order_number AS po_number, pl.line AS po_line, h.supplier_name, g.last_receipt_date, g.receipt_lines, g.received_aed, NVL(a.invoiced_aed,0) AS invoiced_aed FROM (SELECT po_distribution_id, MAX(po_header_id) AS po_header_id, MAX(po_line_id) AS po_line_id, MAX(charge_account) AS charge_account, MAX(project_id) AS project_id, MAX(task_id) AS task_id, MAX(expenditure_type_name) AS expenditure_type, MAX(budget_date) AS budget_date FROM prod.po_distributions GROUP BY po_distribution_id) b JOIN (SELECT po_distribution_id, SUM(ledger_amount) AS received_aed, MAX(transaction_date) AS last_receipt_date, COUNT(*) AS receipt_lines FROM prod.grn_all_v2 GROUP BY po_distribution_id) g ON g.po_distribution_id = b.po_distribution_id LEFT JOIN (SELECT pk.po_distribution_id, SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS invoiced_aed FROM prod.ap_invoice_distributions d JOIN (SELECT ph2.order_number AS po_number, pl2.line AS po_line, pod.distribution_number AS po_dist_line, MAX(pod.po_distribution_id) AS po_distribution_id FROM prod.po_distributions pod JOIN prod.po_lines pl2 ON pl2.po_header_id = pod.po_header_id AND pl2.po_line_id = pod.po_line_id JOIN prod.po_headers ph2 ON ph2.po_header_id = pod.po_header_id GROUP BY ph2.order_number, pl2.line, pod.distribution_number) pk ON pk.po_number = d.po_number AND pk.po_line = d.po_line AND pk.po_dist_line = d.po_distribution_line WHERE NVL(d.reversal_indicator,'N') <> 'Y' GROUP BY pk.po_distribution_id) a ON a.po_distribution_id = b.po_distribution_id LEFT JOIN prod.po_headers h ON h.po_header_id = b.po_header_id LEFT JOIN prod.po_lines pl ON pl.po_header_id = b.po_header_id AND pl.po_line_id = b.po_line_id LEFT JOIN (SELECT project_id, MAX(project_number) AS project_number, MAX(project_name) AS project_name FROM prod.projects GROUP BY project_id) pj ON pj.project_id = b.project_id LEFT JOIN (SELECT task_id, MAX(task_number) AS task_number FROM prod.tasks GROUP BY task_id) tk ON tk.task_id = b.task_id WHERE b.project_id IS NOT NULL AND b.charge_account IS NOT NULL AND g.received_aed > 0.005) x WHERE x.budget_year = [COLON]year!' || l_scope || q'! ORDER BY x.received_aed DESC!';
  -- part 3: open obligations (GRN-netted PO lines)
  l_po := q'!SELECT x.project_number, x.project_name, x.task_number, x.expenditure_type, x.po_number, x.po_line, x.budget_date, x.supplier_name, x.funds_status, x.line_aed, x.received_aed, x.open_aed FROM prod.dct_open_po_lines_v x WHERE x.budget_year = [COLON]year!' || l_scope || q'! ORDER BY x.open_aed DESC!';
  -- part 4: open commitments (reserved PR lines); zero-amount lines excluded
  l_pr := q'!SELECT x.project_number, x.project_name, x.task_number, x.expenditure_type, x.pr_number, x.description, x.budget_date, x.currency_code AS currency, x.distribution_amount, x.amount_aed FROM prod.dct_reserved_pr_lines_v x WHERE x.budget_year = [COLON]year AND ABS(NVL(x.amount_aed,0)) > 0.005!' || l_scope || q'! ORDER BY x.amount_aed DESC!';
  l_src := '{"orientation":"landscape","required":["year"],"sections":['
        || '{"key":"overview","title":"Overview","layout":"kv","sql":"' || l_ov || '"}' || ','
        || '{"key":"by_sector","title":"Utilization by Sector","layout":"table","sql":"' || l_sec || '"}' || ','
        || '{"key":"pressure","title":"Budget Lines under Pressure","layout":"table","sql":"' || l_prs || '"}' || ','
        || '{"key":"ap_lines","title":"Actuals - AP Invoices","layout":"table","sql":"' || l_ap || '"}' || ','
        || '{"key":"grn_lines","title":"Actuals - Goods Receipts","layout":"table","sql":"' || l_grn || '"}' || ','
        || '{"key":"open_po","title":"Open Obligations - Purchase Orders","layout":"table","sql":"' || l_po || '"}' || ','
        || '{"key":"open_pr","title":"Open Commitments - Purchase Requisitions","layout":"table","sql":"' || l_pr || '"}'
        || ']}';
  l_src := REPLACE(l_src, '[COLON]', CHR(58));
  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>Budget Utilization Briefing Book</strong> for budget year '||
    '<strong>{{ params.year }}</strong>{% if params.sector %} ({{ params.sector }} sector){% endif %} '||
    'is attached. It covers the utilization overview, the full actuals register (AP and GRN), '||
    'open obligations and open commitments, and closes with observations for management review '||
    '({{ row_count }} detail lines).</p>'||
    '<p>Prepared by Financial Planning and Budgeting, Finance Department. '||
    'Generated {{ generated_at }} by i-Finance Reporting.</p>';
  MERGE INTO prod.dct_rpt_definition t
  USING (SELECT 'BUDGET_UTIL_BOOK' AS report_code FROM dual) s
  ON (t.report_code = s.report_code)
  WHEN NOT MATCHED THEN INSERT
    (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
     default_formats, pdf_template, email_subject_tpl, email_body_tpl, params_json,
     enabled, created_by, updated_by)
  VALUES
    ('BUDGET_UTIL_BOOK',
     'Budget Utilization Briefing Book',
     UNISTR('\0643\062A\064A\0628 \0627\0633\062A\062E\062F\0627\0645 \0627\0644\0645\0648\0627\0632\0646\0629'),
     'Briefing-book PDF: cover + contents, utilization overview with KPIs and charts, full actuals register (direct AP invoices + GRN receipts), open obligations (PO, GRN-netted), open commitments (reserved PR) and management insights. Parameters: year (required); sector, projecttype, costcenter (optional -- empty sector = whole organisation).',
     'General Ledger', 'MULTI', l_src, 'PYTHON', 'PDF',
     'budget_util_book.html.j2',
     'Budget Utilization Briefing Book - {{ params.year }}{% if params.sector %} - {{ params.sector }}{% endif %}',
     l_body,
     '{"year":null,"sector":null,"projecttype":null,"costcenter":null}',
     'Y', 'SETUP', 'SETUP')
  WHEN MATCHED THEN UPDATE SET
     t.source_type       = 'MULTI',
     t.source_ref        = l_src,
     t.engine            = 'PYTHON',
     t.default_formats   = 'PDF',
     t.pdf_template      = 'budget_util_book.html.j2',
     t.email_subject_tpl = 'Budget Utilization Briefing Book - {{ params.year }}{% if params.sector %} - {{ params.sector }}{% endif %}',
     t.email_body_tpl    = l_body,
     t.params_json       = '{"year":null,"sector":null,"projecttype":null,"costcenter":null}',
     t.updated_by        = 'SETUP',
     t.updated_at        = SYSTIMESTAMP;
  MERGE INTO prod.dct_rpt_recipient t
  USING (SELECT 'BUDGET_UTIL_BOOK' AS rc, 'SELF' AS rt FROM dual) s
  ON (t.report_code = s.rc AND t.recipient_type = s.rt)
  WHEN NOT MATCHED THEN INSERT
    (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
  VALUES
    ('BUDGET_UTIL_BOOK', 'SELF', NULL, 'EMAIL', 'Y', 'SETUP', 'SETUP');
  MERGE INTO prod.dct_rpt_schedule t
  USING (SELECT 'BUDGET_UTIL_BOOK' AS rc, 'Monthly (5th, 08:00)' AS nm FROM dual) s
  ON (t.report_code = s.rc AND t.schedule_name = s.nm)
  WHEN NOT MATCHED THEN INSERT
    (report_code, schedule_name, repeat_interval, timezone, criteria_json, enabled, created_by, updated_by)
  VALUES
    ('BUDGET_UTIL_BOOK', 'Monthly (5th, 08:00)',
     'FREQ=MONTHLY;BYMONTHDAY=5;BYHOUR=8;BYMINUTE=0', 'Asia/Dubai',
     '{"year":null}', 'N', 'SETUP', 'SETUP');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('BUDGET_UTIL_BOOK seeded (definition + SELF recipient + disabled sample schedule).');
END;
/

PROMPT === 2. Parameter spec (labels + hints + LOVs; sector OPTIONAL here) ===
UPDATE prod.dct_rpt_definition
   SET param_spec_json =
       '{"year":{"label":"Budget Year","label_ar":"'
    || UNISTR('\0633\0646\0629\0020\0627\0644\0645\064A\0632\0627\0646\064A\0629')
    || '","hint":"Required. The budget year the briefing book covers (e.g. 2026).","hint_ar":"'
    || UNISTR('\0625\0644\0632\0627\0645\064A\0020\2014\0020\0633\0646\0629\0020\0627\0644\0645\064A\0632\0627\0646\064A\0629\0020\0627\0644\062A\064A\0020\064A\063A\0637\064A\0647\0627\0020\0627\0644\062A\0642\0631\064A\0631\0020\0028\0645\062B\0627\0644\0020\0032\0030\0032\0036\0029\002E')
    || '","required":true,"lov_sql":"SELECT DISTINCT TO_CHAR(budget_year) FROM prod.dct_butil_scope_v WHERE budget_year IS NOT NULL ORDER BY 1 DESC"},'
    || '"sector":{"label":"Sector","label_ar":"'
    || UNISTR('\0627\0644\0642\0637\0627\0639')
    || '","hint":"Optional. Focus the book on one sector; leave empty for the whole organisation.","hint_ar":"'
    || UNISTR('\0627\062E\062A\064A\0627\0631\064A\0020\2014\0020\0627\062A\0631\0643\0647\0020\0641\0627\0631\063A\0627\064B\0020\0644\062A\063A\0637\064A\0629\0020\062C\0645\064A\0639\0020\0627\0644\0642\0637\0627\0639\0627\062A\002E')
    || '","required":false,"lov_sql":"SELECT DISTINCT sector FROM prod.dct_butil_scope_v WHERE sector IS NOT NULL ORDER BY 1"},'
    || '"projecttype":{"label":"Project Type","label_ar":"'
    || UNISTR('\0646\0648\0639\0020\0627\0644\0645\0634\0631\0648\0639')
    || '","hint":"Optional. Filter to one project type; leave empty to include all types.","hint_ar":"'
    || UNISTR('\0627\062E\062A\064A\0627\0631\064A\0020\2014\0020\062A\0635\0641\064A\0629\0020\062D\0633\0628\0020\0646\0648\0639\0020\0627\0644\0645\0634\0631\0648\0639\002E')
    || '","required":false,"lov_sql":"SELECT DISTINCT project_type FROM prod.dct_butil_scope_v WHERE project_type IS NOT NULL ORDER BY 1"},'
    || '"costcenter":{"label":"Cost Center","label_ar":"'
    || UNISTR('\0645\0631\0643\0632\0020\0627\0644\062A\0643\0644\0641\0629')
    || '","hint":"Optional. Filter to one cost center; leave empty to include all cost centers.","hint_ar":"'
    || UNISTR('\0627\062E\062A\064A\0627\0631\064A\0020\2014\0020\062A\0635\0641\064A\0629\0020\062D\0633\0628\0020\0645\0631\0643\0632\0020\0627\0644\062A\0643\0644\0641\0629\002E')
    || '","required":false,"lov_sql":"SELECT DISTINCT cost_centre FROM prod.dct_butil_scope_v WHERE cost_centre IS NOT NULL ORDER BY 1"}}'
 WHERE report_code = 'BUDGET_UTIL_BOOK';
COMMIT;

PROMPT === 3. Verify ===
SELECT report_code, source_type, engine, default_formats, pdf_template,
       CASE WHEN source_ref IS JSON THEN 'SRC OK' ELSE 'SRC BAD' END AS src_ok,
       CASE WHEN param_spec_json IS JSON THEN 'SPEC OK' ELSE 'SPEC BAD' END AS spec_ok,
       DBMS_LOB.GETLENGTH(source_ref) AS src_len
FROM prod.dct_rpt_definition
WHERE report_code = 'BUDGET_UTIL_BOOK';

PROMPT ============================================================
PROMPT  21_rpt_butil_book.sql complete (BUDGET_UTIL_BOOK).
PROMPT ============================================================
