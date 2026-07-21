-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 25 Budget Utilization Register (Excel)
-- File   : reporting/db/25_rpt_butil_register.sql
-- Seeds  : BUDGET_UTIL_REGISTER -- the EXCEL companion of BUDGET_UTIL_BOOK
--          (reporting/db/21) for internal analysis, mirroring the
--          ENC_PENDING_REGISTER pattern (reporting/db/24): every detail list
--          of the briefing book in its OWN worksheet. default_formats = XLSX
--          only (build_xlsx_multi renders one styled sheet per section).
--          Sheets:
--            1. Budget Utilization Lines  (per project x task x exp-type)
--            2. AP Invoices - Direct      (the utilization Actual AP register)
--            3. GRN Receipts              (receipt-date year basis, per PO dist)
--            4. Open Purchase Orders      (GRN-netted open obligation lines)
--            5. Open Requisitions         (reserved open commitment lines)
--            6. Pending Approval PR-PO    (funds-reserved queue, db/v2/52)
-- Params : the FULL GL butil page filter set (year REQUIRED; period YTD /
--          sector / chapter / projecttype / costcenter / project / task /
--          etype / search optional) with the page's exact predicate
--          semantics -- section SQLs are kept in LOCK-STEP with
--          reporting/db/21. Launched from the GL app's Budget Utilization
--          page via the GL/db/11 xlsx bridge.
-- Deploy : Windows SQLcl (sql -name prod_mcp) OR python-oracledb (the Linux
--          SQLcl 26.1 script reader swallows big MERGE-bearing blocks).
--          No template upload needed (XLSX writer is generic).
-- Idempotent: MERGE + guarded UPDATE; safe to re-run (re-runs refresh source).
-- CRLF + UTF-8 no BOM. Zero blank lines inside statements.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. BUDGET_UTIL_REGISTER definition (MULTI, 6 sections, XLSX) ===
DECLARE
  l_bscope VARCHAR2(2000);
  l_scope  VARCHAR2(4000);
  l_bu     VARCHAR2(4000);
  l_ap     VARCHAR2(6000);
  l_grn    VARCHAR2(12000);
  l_po     VARCHAR2(6000);
  l_pr     VARCHAR2(6000);
  l_pend   VARCHAR2(8000);
  l_src    CLOB;
  l_body   CLOB;
BEGIN
  -- shared predicates -- VERBATIM mirror of the GL /gl/butil page handler
  -- (GL/db/07 / reporting/db/21, keep in lock-step)
  l_bscope := q'! WHERE budget_year = [COLON]year AND ([COLON]sector IS NULL OR sector = [COLON]sector) AND ([COLON]chapter IS NULL OR INSTR('|'||[COLON]chapter||'|', '|'||chapter||'|') > 0) AND ([COLON]projecttype IS NULL OR project_type = [COLON]projecttype) AND ([COLON]costcenter IS NULL OR (INSTR([COLON]costcenter,'|') = 0 AND cost_centre LIKE '%'||[COLON]costcenter||'%') OR INSTR('|'||[COLON]costcenter||'|', '|'||cost_centre||'|') > 0) AND ([COLON]project IS NULL OR (INSTR([COLON]project,'|') = 0 AND UPPER(project_number||' '||project_name) LIKE '%'||UPPER([COLON]project)||'%') OR INSTR('|'||[COLON]project||'|', '|'||project_number||'|') > 0) AND ([COLON]task IS NULL OR UPPER(task_number) LIKE '%'||UPPER([COLON]task)||'%') AND ([COLON]etype IS NULL OR UPPER(expenditure_type) LIKE '%'||UPPER([COLON]etype)||'%') AND ([COLON]search IS NULL OR UPPER(project_number||' '||project_name||' '||task_number||' '||department||' '||cost_centre||' '||expenditure_type) LIKE '%'||UPPER([COLON]search)||'%') AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||business_unit||'|') > 0)!';
  l_scope  := q'! AND (x.project_number, NVL(x.task_number,'~'), NVL(x.expenditure_type,'~')) IN (SELECT s.project_number, NVL(s.task_number,'~'), NVL(s.expenditure_type,'~') FROM prod.dct_butil_scope_v s WHERE s.budget_year = [COLON]year AND ([COLON]sector IS NULL OR s.sector = [COLON]sector) AND ([COLON]chapter IS NULL OR INSTR('|'||[COLON]chapter||'|', '|'||s.chapter||'|') > 0) AND ([COLON]projecttype IS NULL OR s.project_type = [COLON]projecttype) AND ([COLON]costcenter IS NULL OR (INSTR([COLON]costcenter,'|') = 0 AND s.cost_centre LIKE '%'||[COLON]costcenter||'%') OR INSTR('|'||[COLON]costcenter||'|', '|'||s.cost_centre||'|') > 0) AND ([COLON]project IS NULL OR (INSTR([COLON]project,'|') = 0 AND UPPER(s.project_number||' '||s.project_name) LIKE '%'||UPPER([COLON]project)||'%') OR INSTR('|'||[COLON]project||'|', '|'||s.project_number||'|') > 0) AND ([COLON]task IS NULL OR UPPER(s.task_number) LIKE '%'||UPPER([COLON]task)||'%') AND ([COLON]etype IS NULL OR UPPER(s.expenditure_type) LIKE '%'||UPPER([COLON]etype)||'%') AND ([COLON]search IS NULL OR UPPER(s.project_number||' '||s.project_name||' '||s.task_number||' '||s.department||' '||s.cost_centre||' '||s.expenditure_type) LIKE '%'||UPPER([COLON]search)||'%') AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||s.business_unit||'|') > 0))!';
  -- sheet 1: the utilization rows themselves (per project x task x exp-type)
  l_bu := q'!SELECT sector, chapter, project_type, cost_centre, department, project_number, project_name, task_number, expenditure_type, budget_annual AS annual_budget, budget AS ytd_budget, actual_ap, actual_grn, actual_ap + actual_grn AS actual_total, commitment_pr, obligation_po, commitment_pr + obligation_po AS open_encumbrance, fund_available, ROUND(100*(actual_ap+actual_grn+commitment_pr+obligation_po)/NULLIF(budget,0),1) AS utilization_pct FROM prod.dct_budget_utilization_v!' || l_bscope || q'! ORDER BY annual_budget DESC NULLS LAST!';
  -- sheet 2: direct AP invoices (the utilization Actual AP register; 39 view)
  l_ap := q'!SELECT x.project_number, x.project_name, x.task_number, x.expenditure_type, x.invoice_number, x.invoice_date, x.supplier_name, x.invoice_currency AS currency, x.matched_aed, x.payment_status FROM prod.dct_unpaid_invoices_v x WHERE x.budget_year = [COLON]year AND x.has_po = 'N' AND ABS(NVL(x.matched_aed,0)) > 0.005!' || l_scope || q'! ORDER BY x.matched_aed DESC!';
  -- sheet 3: GRN receipts per PO distribution -- SAME receipt-date year basis
  -- as the page Actual GRN figure (kept in lock-step with reporting/db/21)
  l_grn := q'!SELECT x.project_number, x.project_name, x.task_number, x.expenditure_type, x.po_number, x.po_line, x.supplier_name, x.last_receipt_date, x.receipt_lines, x.received_aed, x.invoiced_aed, x.received_aed - x.invoiced_aed AS uninvoiced_aed FROM (SELECT COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(g.project_id)) AS project_number, pj.project_name, COALESCE(tk.task_number, CASE WHEN g.task_id IS NOT NULL THEN '#'||TO_CHAR(g.task_id) END) AS task_number, g.expenditure_type, TO_CHAR(h.order_number) AS po_number, TO_CHAR(pl.line) AS po_line, h.supplier_name, g.last_receipt_date, g.receipt_lines, g.received_aed, NVL(a.invoiced_aed,0) AS invoiced_aed FROM (SELECT po_distribution_id, MAX(project_id) AS project_id, MAX(task_id) AS task_id, MAX(expenditure_type) AS expenditure_type, SUM(ledger_amount) AS received_aed, MAX(NVL(accounted_date, transaction_date)) AS last_receipt_date, COUNT(*) AS receipt_lines FROM prod.grn_all_v2 WHERE project_id IS NOT NULL AND EXTRACT(YEAR FROM NVL(accounted_date, transaction_date)) = [COLON]year AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL OR NVL(accounted_date, transaction_date) < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1) GROUP BY po_distribution_id) g JOIN (SELECT po_distribution_id, MAX(po_header_id) AS po_header_id, MAX(po_line_id) AS po_line_id, MAX(charge_account) AS charge_account FROM prod.po_distributions GROUP BY po_distribution_id) b ON b.po_distribution_id = g.po_distribution_id LEFT JOIN (SELECT pk.po_distribution_id, SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS invoiced_aed FROM prod.ap_invoice_distributions d JOIN (SELECT ph2.order_number AS po_number, pl2.line AS po_line, pod.distribution_number AS po_dist_line, MAX(pod.po_distribution_id) AS po_distribution_id FROM prod.po_distributions pod JOIN prod.po_lines pl2 ON pl2.po_header_id = pod.po_header_id AND pl2.po_line_id = pod.po_line_id JOIN prod.po_headers ph2 ON ph2.po_header_id = pod.po_header_id GROUP BY ph2.order_number, pl2.line, pod.distribution_number) pk ON pk.po_number = d.po_number AND pk.po_line = d.po_line AND pk.po_dist_line = d.po_distribution_line WHERE NVL(d.reversal_indicator,'N') <> 'Y' AND EXTRACT(YEAR FROM d.accounting_date) = [COLON]year AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL OR d.accounting_date < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1) GROUP BY pk.po_distribution_id) a ON a.po_distribution_id = g.po_distribution_id LEFT JOIN (SELECT po_header_id, MAX(order_number) AS order_number, MAX(supplier_name) AS supplier_name FROM prod.po_headers GROUP BY po_header_id) h ON h.po_header_id = b.po_header_id LEFT JOIN (SELECT po_header_id, po_line_id, MAX(line) AS line FROM prod.po_lines GROUP BY po_header_id, po_line_id) pl ON pl.po_header_id = b.po_header_id AND pl.po_line_id = b.po_line_id LEFT JOIN (SELECT project_id, MAX(project_number) AS project_number, MAX(project_name) AS project_name FROM prod.projects GROUP BY project_id) pj ON pj.project_id = g.project_id LEFT JOIN (SELECT task_id, MAX(task_number) AS task_number FROM prod.tasks GROUP BY task_id) tk ON tk.task_id = g.task_id WHERE b.charge_account IS NOT NULL AND ABS(g.received_aed) > 0.005) x WHERE 1 = 1!' || l_scope || q'! ORDER BY x.received_aed DESC!';
  -- sheet 4: open obligations (GRN-netted PO lines)
  l_po := q'!SELECT x.project_number, x.project_name, x.task_number, x.expenditure_type, TO_CHAR(x.po_number) AS po_number, TO_CHAR(x.po_line) AS po_line, x.budget_date, x.supplier_name, x.funds_status, x.line_aed, x.received_aed, x.open_aed FROM prod.dct_open_po_lines_v x WHERE x.budget_year = [COLON]year!' || l_scope || q'! ORDER BY x.open_aed DESC!';
  -- sheet 5: open commitments (reserved PR lines); zero-amount lines excluded
  l_pr := q'!SELECT x.project_number, x.project_name, x.task_number, x.expenditure_type, TO_CHAR(x.pr_number) AS pr_number, x.description, x.budget_date, x.currency_code AS currency, x.distribution_amount, x.amount_aed FROM prod.dct_reserved_pr_lines_v x WHERE x.budget_year = [COLON]year AND ABS(NVL(x.amount_aed,0)) > 0.005!' || l_scope || q'! ORDER BY x.amount_aed DESC!';
  -- sheet 6: the pending-approval queue (funds-reserved, non-zero -- the
  -- ENC_PENDING_BOOK scope rule; db/v2/52 + COA snapshot)
  l_pend := q'!SELECT x.source AS doc_type, x.doc_number AS document_number, x.doc_line AS line, x.descr AS description_supplier, x.preparer_buyer, x.submitted_date, x.pending_days, x.pending_with, x.project_number, x.project_name, x.task_number, x.expenditure_type, coa.sector_name AS sector, coa.cost_center_code, coa.cost_center_desc AS cost_center_name, coa.appropriation_code, coa.appropriation_desc AS appropriation_name, x.budget_date, x.line_aed AS amount_aed, x.cc_string AS gl_combination FROM prod.dct_pr_po_pending_v x LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = x.cc_string WHERE x.in_extract = 'Y' AND x.budget_year = [COLON]year AND x.funds_status IN ('Reserved','Partially Liquidated') AND ABS(x.line_aed) > 0.005!' || l_scope || q'! ORDER BY x.source, x.pending_days DESC, x.line_aed DESC!';
  l_src := '{"required":["year"],'
        || '"pre_sql":"BEGIN IF [COLON]period IS NULL THEN prod.dct_gl_class_pkg.clear_butil_end; ELSE prod.dct_gl_class_pkg.set_butil_end(LAST_DAY(TO_DATE(''01-''||[COLON]period,''DD-MM-YYYY''))); END IF; END;",'
        || '"post_sql":"BEGIN prod.dct_gl_class_pkg.clear_butil_end; END;",'
        || '"sections":['
        || '{"key":"bu_lines","title":"Budget Utilization Lines","layout":"table","sql":"' || l_bu || '"}' || ','
        || '{"key":"ap_lines","title":"AP Invoices - Direct","layout":"table","sql":"' || l_ap || '"}' || ','
        || '{"key":"grn_lines","title":"GRN Receipts","layout":"table","sql":"' || l_grn || '"}' || ','
        || '{"key":"open_po","title":"Open Purchase Orders","layout":"table","sql":"' || l_po || '"}' || ','
        || '{"key":"open_pr","title":"Open Requisitions","layout":"table","sql":"' || l_pr || '"}' || ','
        || '{"key":"pending","title":"Pending Approval PR-PO","layout":"table","sql":"' || l_pend || '"}'
        || ']}';
  l_src := REPLACE(l_src, '[COLON]', CHR(58));
  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>Budget Utilization Register</strong> (Excel) for budget year '||
    '<strong>{{ params.year }}</strong> is attached: the utilization lines plus every supporting '||
    'detail list in its own worksheet -- direct AP invoices, GRN receipts, open purchase orders, '||
    'open requisitions and the pending-approval PR/PO queue ({{ row_count }} lines in total).</p>'||
    '<p>Prepared by Financial Planning and Budgeting, Finance Department. '||
    'Generated {{ generated_at }} by i-Finance Reporting.</p>';
  MERGE INTO prod.dct_rpt_definition t
  USING (SELECT 'BUDGET_UTIL_REGISTER' AS report_code FROM dual) s
  ON (t.report_code = s.report_code)
  WHEN NOT MATCHED THEN INSERT
    (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
     default_formats, email_subject_tpl, email_body_tpl, params_json,
     enabled, created_by, updated_by)
  VALUES
    ('BUDGET_UTIL_REGISTER',
     'Budget Utilization Register (Excel)',
     UNISTR('\0633\062C\0644 \0627\0633\062A\062E\062F\0627\0645 \0627\0644\0645\0648\0627\0632\0646\0629'),
     'Excel register for internal analysis: the Budget Utilization detail lists, each in its own worksheet -- utilization lines (budget vs AP / GRN / open PR / open PO / fund available per project, task and expenditure type), direct AP invoices, GRN receipts (receipt-date year basis), open purchase orders (GRN-netted), open requisitions (reserved) and the pending-approval PR/PO queue (funds-reserved). Parameters mirror the GL Budget Utilization page filters: year (required); period (YTD, MM-YYYY), sector, chapter, projecttype, costcenter, project, task, etype, search (all optional).',
     'General Ledger', 'MULTI', l_src, 'PYTHON', 'XLSX',
     'Budget Utilization Register - {{ params.year }}{% if params.sector %} - {{ params.sector }}{% endif %}',
     l_body,
     '{"year":null,"period":null,"sector":null,"chapter":null,"projecttype":null,"costcenter":null,"project":null,"task":null,"etype":null,"search":null,"bu":null}',
     'Y', 'SETUP', 'SETUP')
  WHEN MATCHED THEN UPDATE SET
     t.source_type       = 'MULTI',
     t.description       = 'Excel register for internal analysis: the Budget Utilization detail lists, each in its own worksheet -- utilization lines (budget vs AP / GRN / open PR / open PO / fund available per project, task and expenditure type), direct AP invoices, GRN receipts (receipt-date year basis), open purchase orders (GRN-netted), open requisitions (reserved) and the pending-approval PR/PO queue (funds-reserved). Parameters mirror the GL Budget Utilization page filters: year (required); period (YTD, MM-YYYY), sector, chapter, projecttype, costcenter, project, task, etype, search (all optional).',
     t.source_ref        = l_src,
     t.engine            = 'PYTHON',
     t.default_formats   = 'XLSX',
     t.email_subject_tpl = 'Budget Utilization Register - {{ params.year }}{% if params.sector %} - {{ params.sector }}{% endif %}',
     t.email_body_tpl    = l_body,
     t.params_json       = '{"year":null,"period":null,"sector":null,"chapter":null,"projecttype":null,"costcenter":null,"project":null,"task":null,"etype":null,"search":null,"bu":null}',
     t.updated_by        = 'SETUP',
     t.updated_at        = SYSTIMESTAMP;
  MERGE INTO prod.dct_rpt_recipient t
  USING (SELECT 'BUDGET_UTIL_REGISTER' AS rc, 'SELF' AS rt FROM dual) s
  ON (t.report_code = s.rc AND t.recipient_type = s.rt)
  WHEN NOT MATCHED THEN INSERT
    (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
  VALUES
    ('BUDGET_UTIL_REGISTER', 'SELF', NULL, 'EMAIL', 'Y', 'SETUP', 'SETUP');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('BUDGET_UTIL_REGISTER seeded (definition + SELF recipient).');
END;
/

PROMPT === 2. Parameter spec (identical set to the book -- straight copy) ===
UPDATE prod.dct_rpt_definition
   SET param_spec_json =
       (SELECT param_spec_json FROM prod.dct_rpt_definition WHERE report_code = 'BUDGET_UTIL_BOOK')
 WHERE report_code = 'BUDGET_UTIL_REGISTER'
   AND EXISTS (SELECT 1 FROM prod.dct_rpt_definition WHERE report_code = 'BUDGET_UTIL_BOOK');
COMMIT;

PROMPT === 3. Verify ===
SELECT report_code, source_type, engine, default_formats,
       CASE WHEN source_ref IS JSON THEN 'SRC OK' ELSE 'SRC BAD' END AS src_ok,
       CASE WHEN param_spec_json IS JSON THEN 'SPEC OK' ELSE 'SPEC BAD' END AS spec_ok,
       DBMS_LOB.GETLENGTH(source_ref) AS src_len
FROM prod.dct_rpt_definition
WHERE report_code = 'BUDGET_UTIL_REGISTER';

PROMPT ============================================================
PROMPT  25_rpt_butil_register.sql complete (BUDGET_UTIL_REGISTER).
PROMPT ============================================================
