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
--            2. AP Invoices - Direct      (the utilization Actual AP register;
--               since 2026-08-29 ALSO carries the APPROVED costing-adjustment
--               transactions folded into sheet 1's Actual AP -- rows marked
--               with a (**) prefix on Invoice Number + a Cost Adjustment Ref
--               column; the former separate Costing Adjustments sheet is GONE)
--            3. GRN Receipts              (receipt-date year basis, per PO dist)
--            4. Open Purchase Orders      (GRN-netted open obligation lines)
--            5. Open Requisitions         (reserved open commitment lines)
--            6. Pending Approval PR-PO    (funds-reserved queue, db/v2/52)
--            7. Comments - Other Levels   (butil comments, non-line levels;
--               2026-08-23 -- only when cmtmode = PERIOD/ALL; line-level
--               comments ride sheet 1's Comments column instead)
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

PROMPT === 1. BUDGET_UTIL_REGISTER definition (MULTI, 8 sections, XLSX) ===
DECLARE
  l_bscope VARCHAR2(2000);
  l_scope_cte  VARCHAR2(8000);
  l_scope_join VARCHAR2(1000);
  l_bu     VARCHAR2(12000);
  l_ap     VARCHAR2(12000);
  l_grn    VARCHAR2(12000);
  l_po     VARCHAR2(6000);
  l_pr     VARCHAR2(6000);
  l_pend   VARCHAR2(8000);
  l_cmt    VARCHAR2(4000);
  l_bt     VARCHAR2(8000);
  l_src    CLOB;
  l_body   CLOB;
BEGIN
  -- shared predicates -- VERBATIM mirror of the GL /gl/butil page handler
  -- (GL/db/07 / reporting/db/21, keep in lock-step)
  l_bscope := q'! WHERE budget_year = [COLON]year AND ([COLON]sector IS NULL OR sector = [COLON]sector) AND ([COLON]chapter IS NULL OR INSTR('|'||[COLON]chapter||'|', '|'||chapter||'|') > 0) AND ([COLON]projecttype IS NULL OR INSTR('|'||[COLON]projecttype||'|', '|'||project_type||'|') > 0) AND ([COLON]costcenter IS NULL OR (INSTR([COLON]costcenter,'|') = 0 AND cost_centre LIKE '%'||[COLON]costcenter||'%') OR INSTR('|'||[COLON]costcenter||'|', '|'||cost_centre||'|') > 0) AND ([COLON]project IS NULL OR (INSTR([COLON]project,'|') = 0 AND UPPER(project_number||' '||project_name) LIKE '%'||UPPER([COLON]project)||'%') OR INSTR('|'||[COLON]project||'|', '|'||project_number||'|') > 0) AND ([COLON]task IS NULL OR UPPER(task_number) LIKE '%'||UPPER([COLON]task)||'%') AND ([COLON]etype IS NULL OR UPPER(expenditure_type) LIKE '%'||UPPER([COLON]etype)||'%') AND ([COLON]search IS NULL OR UPPER(project_number||' '||project_name||' '||task_number||' '||department||' '||cost_centre||' '||expenditure_type) LIKE '%'||UPPER([COLON]search)||'%') AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||business_unit||'|') > 0)!';
  -- One request-scoped scope set for each detail sheet. MATERIALIZE makes the
  -- filtered live view execute once for the statement; GROUP BY makes the join
  -- one-to-one at the report grain, so it cannot fan out financial rows. This
  -- replaces both the old IN(UNNEST) filter and its second dimension scan.
  -- It is not a persistent cache: Oracle discards it after the section query.
  l_scope_cte := q'!WITH scope AS (SELECT /*+ MATERIALIZE */ s.budget_year, s.project_number, NVL(s.task_number,'~') AS tk, NVL(s.expenditure_type,'~') AS et, MAX(s.sector) AS sector, MAX(s.cost_centre) AS cost_centre, MAX(s.department) AS department, MAX(s.task_organization) AS organization, MAX(s.project_name) AS project_name FROM prod.dct_butil_scope_v s WHERE s.budget_year = [COLON]year AND ([COLON]sector IS NULL OR s.sector = [COLON]sector) AND ([COLON]chapter IS NULL OR INSTR('|'||[COLON]chapter||'|', '|'||s.chapter||'|') > 0) AND ([COLON]projecttype IS NULL OR INSTR('|'||[COLON]projecttype||'|', '|'||s.project_type||'|') > 0) AND ([COLON]costcenter IS NULL OR (INSTR([COLON]costcenter,'|') = 0 AND s.cost_centre LIKE '%'||[COLON]costcenter||'%') OR INSTR('|'||[COLON]costcenter||'|', '|'||s.cost_centre||'|') > 0) AND ([COLON]project IS NULL OR (INSTR([COLON]project,'|') = 0 AND UPPER(s.project_number||' '||s.project_name) LIKE '%'||UPPER([COLON]project)||'%') OR INSTR('|'||[COLON]project||'|', '|'||s.project_number||'|') > 0) AND ([COLON]task IS NULL OR UPPER(s.task_number) LIKE '%'||UPPER([COLON]task)||'%') AND ([COLON]etype IS NULL OR UPPER(s.expenditure_type) LIKE '%'||UPPER([COLON]etype)||'%') AND ([COLON]search IS NULL OR UPPER(s.project_number||' '||s.project_name||' '||s.task_number||' '||s.department||' '||s.cost_centre||' '||s.expenditure_type) LIKE '%'||UPPER([COLON]search)||'%') AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||s.business_unit||'|') > 0) GROUP BY s.budget_year, s.project_number, NVL(s.task_number,'~'), NVL(s.expenditure_type,'~')) !';
  l_scope_join := q'! JOIN scope sc ON sc.budget_year = [COLON]year AND sc.project_number = x.project_number AND sc.tk = NVL(x.task_number,'~') AND sc.et = NVL(x.expenditure_type,'~')!';
  -- sheet 1: the utilization rows themselves (per project x task x exp-type).
  -- BUDGET_COMBINATION (col A) = the view's full 10-segment canonical GL
  -- combination (db/v2/37 -- Fusion-derived from the task segments, actual
  -- posted combination as fallback). ACCOUNT_NUMBER = the code part of the
  -- view's GL_ACCOUNT (COA row txns, else the etype numeric prefix). The
  -- view ships gl_account/appropriation/program as 'CODE - Description'
  -- strings -- split on the FIRST ' - ' into code + name columns.
  -- EBS_ACCOUNT (2026-07-29) = the legacy EBS account(s) mapped to the row's
  -- Fusion account (DCT_GL_EBS_MAP, db/v2/110) -- slash-joined because 11
  -- Fusion accounts consolidate 2 EBS accounts.
  l_bu := q'!SELECT budget_combination, sector, chapter, CASE WHEN INSTR(appropriation,' - ') > 0 THEN SUBSTR(appropriation,1,INSTR(appropriation,' - ')-1) ELSE appropriation END AS appropriation_code, CASE WHEN INSTR(appropriation,' - ') > 0 THEN SUBSTR(appropriation,INSTR(appropriation,' - ')+3) END AS appropriation_name, CASE WHEN INSTR(program,' - ') > 0 THEN SUBSTR(program,1,INSTR(program,' - ')-1) ELSE program END AS dct_program_code, CASE WHEN INSTR(program,' - ') > 0 THEN SUBSTR(program,INSTR(program,' - ')+3) END AS dct_program_name, cost_centre, department, task_organization AS organization, project_number, project_name, task_number, CASE WHEN INSTR(gl_account,' - ') > 0 THEN SUBSTR(gl_account,1,INSTR(gl_account,' - ')-1) ELSE gl_account END AS account_number, (SELECT LISTAGG(m.ebs_value,' / ') WITHIN GROUP (ORDER BY m.ebs_value) FROM prod.dct_gl_ebs_map m WHERE m.segment_type = 'ACCOUNT' AND m.is_active = 'Y' AND m.fusion_value = CASE WHEN INSTR(gl_account,' - ') > 0 THEN SUBSTR(gl_account,1,INSTR(gl_account,' - ')-1) ELSE gl_account END) AS ebs_account, expenditure_type, budget_annual + bv.cadj_ovra AS annual_budget, budget + bv.cadj_ovr AS ytd_budget, pf.plan_appr_annual AS plan_annual, pf.plan_appr_ytd AS plan_ytd, pf.plan_rev_annual AS revised_plan_annual, pf.plan_rev_ytd AS revised_plan_ytd, ROUND(100*(actual_ap+bv.cadj_amt+actual_grn)/NULLIF(CASE WHEN NVL(pf.plan_rev_annual,0)<>0 THEN pf.plan_rev_ytd ELSE pf.plan_appr_ytd END,0),1) AS plan_utilization_pct, CASE WHEN NVL(CASE WHEN NVL(pf.plan_rev_annual,0)<>0 THEN pf.plan_rev_ytd ELSE pf.plan_appr_ytd END,0) > 0.005 THEN ROUND(actual_ap+bv.cadj_amt+actual_grn-(CASE WHEN NVL(pf.plan_rev_annual,0)<>0 THEN pf.plan_rev_ytd ELSE pf.plan_appr_ytd END),2) END AS plan_variance, CASE WHEN NVL(CASE WHEN NVL(pf.plan_rev_annual,0)<>0 THEN pf.plan_rev_ytd ELSE pf.plan_appr_ytd END,0) <= 0.005 THEN 'Not planned' WHEN 100*(actual_ap+bv.cadj_amt+actual_grn)/(CASE WHEN NVL(pf.plan_rev_annual,0)<>0 THEN pf.plan_rev_ytd ELSE pf.plan_appr_ytd END) < th.thx1 THEN TO_CHAR(NCHR(9660))||' Below plan' WHEN 100*(actual_ap+bv.cadj_amt+actual_grn)/(CASE WHEN NVL(pf.plan_rev_annual,0)<>0 THEN pf.plan_rev_ytd ELSE pf.plan_appr_ytd END) > th.thx2 THEN TO_CHAR(NCHR(9650))||' Ahead of plan' ELSE TO_CHAR(NCHR(9679))||' Within plan' END AS plan_status, ROUND(100*NVL(CASE WHEN NVL(pf.plan_rev_annual,0)<>0 THEN pf.plan_rev_annual ELSE pf.plan_appr_annual END,0)/NULLIF(budget_annual+bv.cadj_ovra,0),1) AS plan_coverage_pct, CASE WHEN NVL(CASE WHEN NVL(pf.plan_rev_annual,0)<>0 THEN pf.plan_rev_annual ELSE pf.plan_appr_annual END,0) <= 0.005 THEN 'Not planned' WHEN NVL(budget_annual+bv.cadj_ovra,0) = 0 OR 100*(CASE WHEN NVL(pf.plan_rev_annual,0)<>0 THEN pf.plan_rev_annual ELSE pf.plan_appr_annual END)/(budget_annual+bv.cadj_ovra) > th.thc2 THEN 'Over-planned' WHEN 100*(CASE WHEN NVL(pf.plan_rev_annual,0)<>0 THEN pf.plan_rev_annual ELSE pf.plan_appr_annual END)/(budget_annual+bv.cadj_ovra) < th.thc1 THEN 'Under-planned' ELSE 'Fully planned' END AS plan_coverage_status, actual_ap + bv.cadj_amt AS actual_ap, actual_grn, actual_ap + bv.cadj_amt + actual_grn AS actual_total, commitment_pr, obligation_po, commitment_pr + obligation_po AS open_encumbrance, fund_available + bv.cadj_ovr - bv.cadj_amt AS fund_available, ROUND(100*(actual_ap+bv.cadj_amt+actual_grn+commitment_pr+obligation_po)/NULLIF(budget+bv.cadj_ovr,0),1) AS utilization_pct, bv.cadj_amt AS cost_adjustment, bv.cadj_ovr AS budget_override_adj, CASE WHEN [COLON]cmtmode IN ('PERIOD','ALL') THEN (SELECT LISTAGG('['||c.accounting_period||'] '||c.created_by||' - '||c.comment_text, CHR(10) ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY c.created_at DESC) FROM prod.dct_gl_butil_comment c WHERE c.status = 'ACTIVE' AND c.entity_level = 'BUTIL_LINE' AND c.budget_year = bv.budget_year AND c.project_number = bv.project_number AND c.task_number = bv.task_number AND c.expenditure_type = bv.expenditure_type AND ([COLON]cmtmode = 'ALL' OR SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL OR c.accounting_period = TO_CHAR(TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD'),'MM-YYYY'))) END AS comments FROM (SELECT bv0.*, NVL(c.cost_adj_aed,0) AS cadj_amt, NVL(c.budget_ovr_aed,0) AS cadj_ovr, NVL(c.budget_ovr_annual,0) AS cadj_ovra FROM prod.dct_budget_utilization_v bv0 LEFT JOIN prod.dct_pa_cost_adj_butil_v c ON c.budget_year = bv0.budget_year AND c.project_number = bv0.project_number AND c.task_number = bv0.task_number AND c.expenditure_type = bv0.expenditure_type) bv LEFT JOIN (SELECT budget_year AS py, project_number AS pp, task_number AS pt, expenditure_type AS pe, plan_appr_annual, plan_appr_ytd, plan_rev_annual, plan_rev_ytd FROM prod.dct_project_cf_butil_v) pf ON pf.py = bv.budget_year AND pf.pp = bv.project_number AND pf.pt = bv.task_number AND pf.pe = bv.expenditure_type CROSS JOIN (SELECT NVL(MAX(CASE s.setting_key WHEN 'PLAN_EXEC_TOL_LOW' THEN TO_NUMBER(s.setting_value) END),90) AS thx1, NVL(MAX(CASE s.setting_key WHEN 'PLAN_EXEC_TOL_HIGH' THEN TO_NUMBER(s.setting_value) END),110) AS thx2, NVL(MAX(CASE s.setting_key WHEN 'PLAN_COV_LOW' THEN TO_NUMBER(s.setting_value) END),95) AS thc1, NVL(MAX(CASE s.setting_key WHEN 'PLAN_COV_HIGH' THEN TO_NUMBER(s.setting_value) END),105) AS thc2 FROM prod.dct_module_settings s JOIN prod.dct_modules md ON md.module_id = s.module_id AND md.module_code = 'GL' WHERE s.setting_key LIKE 'PLAN%') th!' || l_bscope || q'! ORDER BY sector, chapter, cost_centre, project_number, task_number, expenditure_type!';
  -- sheet 2: direct AP invoices (the utilization Actual AP register; 39 view)
  -- + (2026-08-29, user) the APPROVED costing-adjustment transactions folded
  -- into sheet 1's Actual AP figure ride THIS sheet (no separate sheet):
  -- second UNION ALL leg shaped like an AP row -- Invoice Number prefixed
  -- '(**) ' (referenced invoice number, else the stored snapshot, else the
  -- PCA ref), invoice date/supplier from the referenced header (GL/db/29
  -- shape; deduped ap_invoices + effective-supplier joins so the leg can
  -- never fan out), currency AED (the amount IS the AED adjustment),
  -- amount = the SIGNED adjustment, + trailing COST_ADJUSTMENT_REF column
  -- (NULL on plain AP rows) so (**) rows are filterable without a legend.
  -- Same butil scope join on the CORRECTED coding + the BUTIL_END period
  -- rule of DCT_PA_COST_ADJ_BUTIL_V (NULL period counts always).
  l_ap := l_scope_cte || q'!SELECT sc.sector, sc.cost_centre, sc.department, sc.organization, x.project_number, x.project_name, x.task_number, x.expenditure_type, x.invoice_number, x.invoice_date, x.supplier_name, x.invoice_currency AS currency, x.matched_aed, x.payment_status, NULL AS cost_adjustment_ref FROM prod.dct_unpaid_invoices_v x!' || l_scope_join || q'! WHERE x.budget_year = [COLON]year AND x.has_po = 'N' AND ABS(NVL(x.matched_aed,0)) > 0.005 UNION ALL SELECT sc.sector, sc.cost_centre, sc.department, sc.organization, x.project_number, sc.project_name, x.task_number, x.expenditure_type, '(**) '||COALESCE(i.inv_no, x.invoice_number, x.adj_ref) AS invoice_number, i.inv_date AS invoice_date, COALESCE(se.eff_name, x.supplier_name) AS supplier_name, 'AED' AS currency, x.amount_aed AS matched_aed, CASE WHEN i.inv_id IS NULL THEN 'Cost Adjustment' WHEN NVL(i.inv_amt,0) = 0 THEN NULL WHEN ABS(NVL(i.paid_amt,0)) >= ABS(NVL(i.inv_amt,0)) - 0.005 THEN 'Paid' WHEN NVL(i.paid_amt,0) <> 0 THEN 'Partially Paid' ELSE 'Unpaid' END AS payment_status, x.adj_ref AS cost_adjustment_ref FROM prod.dct_pa_cost_adj x LEFT JOIN (SELECT invoice_id AS inv_id, MAX(invoice_number) AS inv_no, MAX(invoice_date) AS inv_date, MAX(invoice_amount) AS inv_amt, MAX(invoice_amount_paid) AS paid_amt FROM prod.ap_invoices GROUP BY invoice_id) i ON i.inv_id = x.invoice_id LEFT JOIN (SELECT invoice_id, MAX(supplier_name) AS eff_name FROM prod.dct_ap_supplier_eff_v GROUP BY invoice_id) se ON se.invoice_id = x.invoice_id!' || l_scope_join || q'! WHERE x.status = 'APPROVED' AND x.budget_year = [COLON]year AND NVL(x.amount_aed,0) <> 0 AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL OR x.accounting_period IS NULL OR TO_DATE('01-'||x.accounting_period,'DD-MM-YYYY') <= TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD')) ORDER BY project_number, task_number, expenditure_type, invoice_date!';
  -- sheet 3: GRN receipts per PO distribution -- SAME receipt-date year basis
  -- as the page Actual GRN figure (kept in lock-step with reporting/db/21).
  -- RELATED_INVOICES (2026-07-27): the AP invoice numbers matched to the same
  -- PO distribution (the invoiced_aed set), comma-separated. Deduped header
  -- join (GROUP BY invoice_id) + LEFT JOIN so invoiced_aed sums are untouched.
  l_grn := l_scope_cte || q'!SELECT sc.sector, sc.cost_centre, sc.department, sc.organization, x.project_number, x.project_name, x.task_number, x.expenditure_type, x.po_number, x.po_line, x.supplier_name, x.last_receipt_date, x.receipt_lines, x.received_aed, x.invoiced_aed, x.received_aed - x.invoiced_aed AS uninvoiced_aed, x.related_invoices FROM (SELECT COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(g.project_id)) AS project_number, pj.project_name, COALESCE(tk.task_number, CASE WHEN g.task_id IS NOT NULL THEN '#'||TO_CHAR(g.task_id) END) AS task_number, g.expenditure_type, TO_CHAR(h.order_number) AS po_number, TO_CHAR(pl.line) AS po_line, h.supplier_name, g.last_receipt_date, g.receipt_lines, g.received_aed, NVL(a.invoiced_aed,0) AS invoiced_aed, a.related_invoices FROM (SELECT po_distribution_id, MAX(project_id) AS project_id, MAX(task_id) AS task_id, MAX(expenditure_type) AS expenditure_type, SUM(ledger_amount) AS received_aed, MAX(NVL(accounted_date, transaction_date)) AS last_receipt_date, COUNT(*) AS receipt_lines FROM prod.grn_all_v2 WHERE project_id IS NOT NULL AND EXTRACT(YEAR FROM NVL(accounted_date, transaction_date)) = [COLON]year AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL OR NVL(accounted_date, transaction_date) < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1) GROUP BY po_distribution_id) g JOIN (SELECT po_distribution_id, MAX(po_header_id) AS po_header_id, MAX(po_line_id) AS po_line_id, MAX(charge_account) AS charge_account FROM prod.po_distributions GROUP BY po_distribution_id) b ON b.po_distribution_id = g.po_distribution_id LEFT JOIN (SELECT pk.po_distribution_id, SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS invoiced_aed, LISTAGG(DISTINCT inv.invoice_number, ', ' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY inv.invoice_number) AS related_invoices FROM prod.ap_invoice_distributions d LEFT JOIN (SELECT invoice_id, MAX(invoice_number) AS invoice_number FROM prod.ap_invoices GROUP BY invoice_id) inv ON inv.invoice_id = d.invoice_id JOIN (SELECT ph2.order_number AS po_number, pl2.line AS po_line, pod.distribution_number AS po_dist_line, MAX(pod.po_distribution_id) AS po_distribution_id FROM prod.po_distributions pod JOIN prod.po_lines pl2 ON pl2.po_header_id = pod.po_header_id AND pl2.po_line_id = pod.po_line_id JOIN prod.po_headers ph2 ON ph2.po_header_id = pod.po_header_id GROUP BY ph2.order_number, pl2.line, pod.distribution_number) pk ON pk.po_number = d.po_number AND pk.po_line = d.po_line AND pk.po_dist_line = d.po_distribution_line WHERE NVL(d.reversal_indicator,'N') <> 'Y' AND EXTRACT(YEAR FROM d.accounting_date) = [COLON]year AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL OR d.accounting_date < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1) GROUP BY pk.po_distribution_id) a ON a.po_distribution_id = g.po_distribution_id LEFT JOIN (SELECT po_header_id, MAX(order_number) AS order_number, MAX(supplier_name) AS supplier_name FROM prod.po_headers GROUP BY po_header_id) h ON h.po_header_id = b.po_header_id LEFT JOIN (SELECT po_header_id, po_line_id, MAX(line) AS line FROM prod.po_lines GROUP BY po_header_id, po_line_id) pl ON pl.po_header_id = b.po_header_id AND pl.po_line_id = b.po_line_id LEFT JOIN (SELECT project_id, MAX(project_number) AS project_number, MAX(project_name) AS project_name FROM prod.projects GROUP BY project_id) pj ON pj.project_id = g.project_id LEFT JOIN (SELECT task_id, MAX(task_number) AS task_number FROM prod.tasks GROUP BY task_id) tk ON tk.task_id = g.task_id WHERE b.charge_account IS NOT NULL AND ABS(g.received_aed) > 0.005) x!' || l_scope_join || q'! WHERE x.project_number NOT LIKE '#%' AND x.task_number NOT LIKE '#_%' ORDER BY x.project_number, x.task_number, x.expenditure_type, x.po_number, x.po_line!';
  -- sheet 4: open obligations (GRN-netted PO lines)
  l_po := l_scope_cte || q'!SELECT sc.sector, sc.cost_centre, sc.department, sc.organization, x.project_number, x.project_name, x.task_number, x.expenditure_type, TO_CHAR(x.po_number) AS po_number, TO_CHAR(x.po_line) AS po_line, x.budget_date, x.supplier_name, x.funds_status, x.line_aed, x.received_aed, x.open_aed FROM prod.dct_open_po_lines_v x!' || l_scope_join || q'! WHERE x.budget_year = [COLON]year ORDER BY x.project_number, x.task_number, x.expenditure_type, x.po_number, x.po_line!';
  -- sheet 5: open commitments (reserved PR lines); zero-amount lines excluded
  l_pr := l_scope_cte || q'!SELECT sc.sector, sc.cost_centre, sc.department, sc.organization, x.project_number, x.project_name, x.task_number, x.expenditure_type, TO_CHAR(x.pr_number) AS pr_number, x.description, x.budget_date, x.currency_code AS currency, x.distribution_amount, x.amount_aed FROM prod.dct_reserved_pr_lines_v x!' || l_scope_join || q'! WHERE x.budget_year = [COLON]year AND ABS(NVL(x.amount_aed,0)) > 0.005 ORDER BY x.project_number, x.task_number, x.expenditure_type, x.pr_number!';
  -- sheet 6: the pending-approval queue (funds-reserved, non-zero -- the
  -- ENC_PENDING_BOOK scope rule; db/v2/52 + COA snapshot)
  l_pend := l_scope_cte || q'!SELECT x.source AS doc_type, x.doc_number AS document_number, x.doc_line AS line, x.descr AS description_supplier, x.preparer_buyer, x.submitted_date, x.pending_days, x.pending_with, x.project_number, x.project_name, x.task_number, x.expenditure_type, coa.sector_name AS sector, coa.cost_center_code, coa.cost_center_desc AS cost_center_name, coa.appropriation_code, coa.appropriation_desc AS appropriation_name, x.budget_date, x.line_aed AS amount_aed, x.cc_string AS gl_combination FROM prod.dct_pr_po_pending_v x!' || l_scope_join || q'! LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = x.cc_string WHERE x.in_extract = 'Y' AND x.budget_year = [COLON]year AND x.funds_status IN ('Reserved','Partially Liquidated') AND ABS(x.line_aed) > 0.005 ORDER BY x.source, x.doc_number, x.doc_line!';
  -- sheet 7 (2026-08-23): Budget Utilization COMMENTS at every level OTHER
  -- than the budget line (SECTOR / COST_CENTER / PROJECT / TASK / PO / PR /
  -- AP_INVOICE -- line-level comments ride sheet 1's Comments column instead).
  -- Included only when [COLON]cmtmode is PERIOD/ALL; PERIOD scopes to the run's
  -- accounting period via GL_CTX.BUTIL_END (the section SQLs never bind
  -- [COLON]period -- the GL bridge omits the key on full-year runs and a bind
  -- absent from the params is a datasource error). TO_CHAR time masks must
  -- avoid literal colon-MI (phantom bind) -- CHR(58) concatenation.
  l_cmt := q'!SELECT c.entity_level AS level_code, c.entity_key, c.entity_name, c.project_number, c.task_number, c.expenditure_type, c.accounting_period, c.comment_ref AS post_reference, CASE WHEN c.parent_comment_id IS NULL THEN 'COMMENT' ELSE 'REPLY' END AS kind, c.created_by AS posted_by, TO_CHAR(prod.dct_to_local(c.created_at),'YYYY-MM-DD HH24'||CHR(58)||'MI') AS posted_at, c.comment_text FROM prod.dct_gl_butil_comment c WHERE [COLON]cmtmode IN ('PERIOD','ALL') AND c.status = 'ACTIVE' AND c.entity_level <> 'BUTIL_LINE' AND c.budget_year = [COLON]year AND ([COLON]cmtmode = 'ALL' OR SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL OR c.accounting_period = TO_CHAR(TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD'),'MM-YYYY')) ORDER BY c.entity_level, c.entity_key, c.project_number, c.created_at DESC!';
  -- (the former sheet 8 "Costing Adjustments" was REMOVED 2026-08-29 -- the
  -- transactions now ride the AP Invoices - Direct sheet as (**) rows above)
  -- sheet 8 (2026-08-29, user): budget transfer transactions -- ADDITIONAL
  -- FUND ONLY -- from the PBT extract (otbi-atd/db/77: pa_budget_trx_headers
  -- + pa_additional_fund_lines + pa_budget_trx_approvals). One row per
  -- transfer LINE with the header identity (decree no, transaction date/year,
  -- BU, status), the full line detail (coding, signed amount, budget/actual
  -- figures, statuses) and the approval trail aggregated per transaction
  -- (first submitter, distinct assignees, last state, last action time).
  -- Scope: trx_year = [COLON]year + the run's YTD cut on transaction_date via
  -- GL_CTX.BUTIL_END. Filters are applied to the line's OWN attributes with
  -- segment-resolved Sector/Chapter/Cost-centre (the V_PA_BUDGET_TRX_LINE
  -- pattern: combination segment 3 else the COST_CENTER label's trailing
  -- digits; appropriation = segment 7) -- deliberately NOT the butil scope
  -- key join, because 987 of 4,561 live transfer lines have no exact butil
  -- line match and an inner scope join would silently drop them.
  -- Sort (user spec): project, task, expenditure type, transaction date.
  l_bt := q'!SELECT cs.sector_name AS sector, x.cc_code AS cost_centre, cs.cost_center_desc AS department, x.transaction_num, x.decree_no, x.transaction_date, x.transaction_year, x.business_unit, x.project_type, x.transaction_status, x.project_number, x.project_name, x.task_number, x.task_name, x.organization, x.expenditure_type, x.code_combination, x.amount, x.commitment, x.total_annual_budget, x.project_fund_available, x.total_actual, x.period_from, x.period_to, x.line_status, x.baseline_status, x.journal_status, apr.submitted_by, apr.assignee, apr.approval_state, apr.approval_date, x.notes FROM (SELECT h.transaction_num, h.decree_no, h.transaction_date, h.trx_year AS transaction_year, h.business_unit, h.project_type, h.status AS transaction_status, l.project_num AS project_number, l.project_name, l.task_num AS task_number, l.task_name, l.cost_center AS organization, l.expenditure_type, l.code_combination, l.additional_amount AS amount, l.commitments AS commitment, l.total_annual_budget, l.fund_available AS project_fund_available, l.total_actual, l.period_from, l.period_to, l.line_status, l.baseline_status, l.jv_status AS journal_status, l.notes, l.identifier, COALESCE(REGEXP_SUBSTR(l.code_combination,'[^.]+',1,3), REGEXP_SUBSTR(l.cost_center,'[0-9]+$')) AS cc_code, REGEXP_SUBSTR(l.code_combination,'[^.]+',1,7) AS appr_code FROM prod.pa_additional_fund_lines l JOIN prod.pa_budget_trx_headers h ON h.transaction_num = l.transaction_num AND h.transaction_type = 'Additional' WHERE h.trx_year = TO_CHAR([COLON]year) AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL OR h.transaction_date < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1)) x LEFT JOIN (SELECT cost_center_code, MAX(cost_center_desc) AS cost_center_desc, MAX(sector_name) AS sector_name FROM prod.dct_gl_coa_snap WHERE cost_center_code IS NOT NULL GROUP BY cost_center_code) cs ON cs.cost_center_code = x.cc_code LEFT JOIN (SELECT appropriation_code, MAX(chapter_name) AS chapter_name FROM prod.dct_gl_coa_snap WHERE appropriation_code IS NOT NULL GROUP BY appropriation_code) ap ON ap.appropriation_code = x.appr_code LEFT JOIN (SELECT transaction_num, MAX(submitter_name) KEEP (DENSE_RANK FIRST ORDER BY seq_no) AS submitted_by, LISTAGG(DISTINCT assignee_username, ', ' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY assignee_username) AS assignee, MAX(assignment_state) KEEP (DENSE_RANK LAST ORDER BY seq_no) AS approval_state, TO_CHAR(prod.dct_to_local(MAX(creation_date)),'YYYY-MM-DD HH24'||CHR(58)||'MI') AS approval_date FROM prod.pa_budget_trx_approvals WHERE trx_type = 'Additional' GROUP BY transaction_num) apr ON apr.transaction_num = x.transaction_num WHERE ([COLON]sector IS NULL OR cs.sector_name = [COLON]sector) AND ([COLON]chapter IS NULL OR INSTR('|'||[COLON]chapter||'|', '|'||ap.chapter_name||'|') > 0) AND ([COLON]costcenter IS NULL OR (INSTR([COLON]costcenter,'|') = 0 AND x.cc_code LIKE '%'||[COLON]costcenter||'%') OR INSTR('|'||[COLON]costcenter||'|', '|'||x.cc_code||'|') > 0) AND ([COLON]projecttype IS NULL OR INSTR('|'||[COLON]projecttype||'|', '|'||x.project_type||'|') > 0) AND ([COLON]project IS NULL OR (INSTR([COLON]project,'|') = 0 AND UPPER(x.project_number||' '||x.project_name) LIKE '%'||UPPER([COLON]project)||'%') OR INSTR('|'||[COLON]project||'|', '|'||x.project_number||'|') > 0) AND ([COLON]task IS NULL OR UPPER(x.task_number) LIKE '%'||UPPER([COLON]task)||'%') AND ([COLON]etype IS NULL OR UPPER(x.expenditure_type) LIKE '%'||UPPER([COLON]etype)||'%') AND ([COLON]search IS NULL OR UPPER(x.transaction_num||' '||x.decree_no||' '||x.project_number||' '||x.project_name||' '||x.task_number||' '||x.expenditure_type) LIKE '%'||UPPER([COLON]search)||'%') AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||x.business_unit||'|') > 0) ORDER BY x.project_number, x.task_number, x.expenditure_type, x.transaction_date, x.transaction_num, x.identifier!';
  l_src := '{"required":["year"],'
        || '"pre_sql":"BEGIN IF [COLON]period IS NULL THEN prod.dct_gl_class_pkg.clear_butil_end; ELSE prod.dct_gl_class_pkg.set_butil_end(LAST_DAY(TO_DATE(''01-''||[COLON]period,''DD-MM-YYYY''))); END IF; prod.dct_gl_class_pkg.set_butil_ovr([COLON]ovr); END;",'
        || '"post_sql":"BEGIN prod.dct_gl_class_pkg.clear_butil_end; prod.dct_gl_class_pkg.clear_butil_ovr; END;",'
        || '"sections":['
        || '{"key":"bu_lines","title":"Budget Utilization Lines","layout":"table","sql":"' || l_bu || '"}' || ','
        || '{"key":"ap_lines","title":"AP Invoices - Direct","layout":"table","sql":"' || l_ap || '"}' || ','
        || '{"key":"grn_lines","title":"GRN Receipts","layout":"table","sql":"' || l_grn || '"}' || ','
        || '{"key":"open_po","title":"Open Purchase Orders","layout":"table","sql":"' || l_po || '"}' || ','
        || '{"key":"open_pr","title":"Open Requisitions","layout":"table","sql":"' || l_pr || '"}' || ','
        || '{"key":"pending","title":"Pending Approval PR-PO","layout":"table","sql":"' || l_pend || '"}' || ','
        || '{"key":"comments","title":"Comments - Other Levels","layout":"table","sql":"' || l_cmt || '"}' || ','
        || '{"key":"budget_trx","title":"Additional Fund Transfers","layout":"table","sql":"' || l_bt || '"}'
        || ']}';
  l_src := REPLACE(l_src, '[COLON]', CHR(58));
  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>Budget Utilization Register</strong> (Excel) for budget year '||
    '<strong>{{ params.year }}</strong> is attached: the utilization lines plus every supporting '||
    'detail list in its own worksheet -- direct AP invoices, GRN receipts, open purchase orders, '||
    'open requisitions, the pending-approval PR/PO queue and the Additional Fund budget transfers ({{ row_count }} lines in total).</p>'||
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
     'Excel register for internal analysis: the Budget Utilization detail lists, each in its own worksheet -- utilization lines (budget + expenditure plan (annual and YTD, revised pair when uploaded) vs AP / GRN / open PR / open PO / fund available per project, task and expenditure type), direct AP invoices (including the approved costing-adjustment transactions, marked (**) with their Cost Adjustment Ref), GRN receipts (receipt-date year basis), open purchase orders (GRN-netted), open requisitions (reserved) the pending-approval PR/PO queue (funds-reserved) and, when cmtmode is PERIOD/ALL, the Budget Utilization comments (line comments as a sheet-1 column, all other levels in their own worksheet) and the Additional Fund budget transfers (header, line detail, approval trail). Parameters mirror the GL Budget Utilization page filters: year (required); period (YTD, MM-YYYY), sector, chapter, projecttype, costcenter, project, task, etype, search (all optional).',
     'General Ledger', 'MULTI', l_src, 'PYTHON', 'XLSX',
     'Budget Utilization Register - {{ params.year }}{% if params.sector %} - {{ params.sector }}{% endif %}',
     l_body,
     '{"year":null,"period":null,"sector":null,"chapter":null,"projecttype":null,"costcenter":null,"project":null,"task":null,"etype":null,"search":null,"bu":null,"ovr":null,"cmtmode":null}',
     'Y', 'SETUP', 'SETUP')
  WHEN MATCHED THEN UPDATE SET
     t.source_type       = 'MULTI',
     t.description       = 'Excel register for internal analysis: the Budget Utilization detail lists, each in its own worksheet -- utilization lines (budget + expenditure plan (annual and YTD, revised pair when uploaded) vs AP / GRN / open PR / open PO / fund available per project, task and expenditure type), direct AP invoices (including the approved costing-adjustment transactions, marked (**) with their Cost Adjustment Ref), GRN receipts (receipt-date year basis), open purchase orders (GRN-netted), open requisitions (reserved) the pending-approval PR/PO queue (funds-reserved) and, when cmtmode is PERIOD/ALL, the Budget Utilization comments (line comments as a sheet-1 column, all other levels in their own worksheet) and the Additional Fund budget transfers (header, line detail, approval trail). Parameters mirror the GL Budget Utilization page filters: year (required); period (YTD, MM-YYYY), sector, chapter, projecttype, costcenter, project, task, etype, search (all optional).',
     t.source_ref        = l_src,
     t.engine            = 'PYTHON',
     t.default_formats   = 'XLSX',
     t.email_subject_tpl = 'Budget Utilization Register - {{ params.year }}{% if params.sector %} - {{ params.sector }}{% endif %}',
     t.email_body_tpl    = l_body,
     t.params_json       = '{"year":null,"period":null,"sector":null,"chapter":null,"projecttype":null,"costcenter":null,"project":null,"task":null,"etype":null,"search":null,"bu":null,"ovr":null,"cmtmode":null}',
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
