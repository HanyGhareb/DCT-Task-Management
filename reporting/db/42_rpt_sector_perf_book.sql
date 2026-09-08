-- =============================================================================
-- Reporting Platform -- SECTOR_PERF_BOOK (Sector Performance Report)
-- File    : 42_rpt_sector_perf_book.sql
-- Run     : sql -name prod_mcp @42_rpt_sector_perf_book.sql
-- Purpose : a distribution copy of BUDGET_UTIL_BOOK with its own PDF cover
--           template (sector_perf_book.html.j2, DB-stored): DCT logo top-right
--           and a copyright line on EVERY page (drawn in the page margins via
--           the render_pdf.py pdf-header/pdf-footer hook), simplified first
--           page (no parameter chips / description / generated block), title
--           "Sector Performance Report", prepared-by "Financial Planning and
--           Reporting". Section SQLs / params / hooks are copied VERBATIM
--           from BUDGET_UTIL_BOOK, so RE-RUN this script after any 21 re-run
--           to refresh the copy. PDF only. Launched from the GL Budget
--           Utilization page's Generate Report menu (bridge = GL/db/50).
--           USER RULE 2026-09-06: the report runs for exactly ONE sector --
--           the GL bridge 400s without one, and the param-spec patch below
--           marks sector required so the BI run drawer enforces it as well
--           (the patch re-applies after the copy refresh, every run).
--           TERMS SECTION (user, 2026-09-06): a "terms" section is PREPENDED
--           to the copied section list after every refresh -- it reads the
--           ACTIVE "Terms and Key definitions" rich-text document from
--           DCT_GL_REPORT_TERMS (db/v2/129, managed in GL -> Settings) that
--           is in force at the report's PERIOD-END date (full year = 31-Dec)
--           and prints as content entry 01 with the author's formatting.
--           Deploy db/v2/129 BEFORE running this script.
-- Idempotent: refreshes the copied columns on every run.
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  l_n      NUMBER;
  l_terms  VARCHAR2(1200);
  l_def    VARCHAR2(400);
  l_bscope VARCHAR2(4000);
  l_scope  VARCHAR2(4000);
  l_sx     VARCHAR2(20000);
  l_sd     VARCHAR2(8000);
  l_sk     VARCHAR2(8000);
  l_st     VARCHAR2(8000);
  l_dk     VARCHAR2(8000);
  l_dp     VARCHAR2(8000);
  l_sp     VARCHAR2(12000);
  l_spr    VARCHAR2(8000);
  l_dpl    VARCHAR2(8000);
  l_add    CLOB;
BEGIN
  -- DEFAULT CHAPTER SCOPE (user-approved 2026-09-06): the report targets the
  -- Opex + Capex chapters. Resolved from the chapter classification (alt_name1)
  -- at SEED time, applied as NVL([COLON]chapter, default) inside EVERY section
  -- (surgery below) so the default holds on ANY entry point (GL bridge, BI
  -- run drawer, schedules). The GL page's Chapter multi-select overrides it.
  SELECT LISTAGG(name_en, '|') WITHIN GROUP (ORDER BY value_code)
    INTO l_def
    FROM prod.dct_gl_class_value
   WHERE class_type_code = 'CHAPTER' AND alt_name1 IN ('Opex', 'Capex');
  IF l_def IS NULL THEN l_def := 'Chapter 2|Chapter 3'; END IF;
  SELECT COUNT(*) INTO l_n
    FROM prod.dct_rpt_definition
   WHERE report_code = 'SECTOR_PERF_BOOK';

  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_definition
      (report_code, name_en, name_ar, description, category,
       source_type, source_ref, engine, default_formats, pdf_template,
       xlsx_template, email_subject_tpl, email_body_tpl,
       params_json, param_spec_json, enabled, created_by, updated_by)
    SELECT 'SECTOR_PERF_BOOK',
           'Sector Performance Report',
           'تقرير أداء القطاعات',
           'Sector Performance Report — the Budget Utilization Briefing Book pack re-covered for distribution, for exactly ONE sector per run (sector is required): DCT logo top-right and a copyright line on every page, simplified cover (YTD period subtitle + sector line), prepared by Financial Planning and Reporting. Data sections are a verbatim copy of BUDGET_UTIL_BOOK — re-run reporting/db/42 after any db/21 re-run to refresh the copy. PDF only; run from the GL Budget Utilization page (Generate Report menu, bridge GL/db/50).',
           category, source_type, source_ref, engine,
           'PDF', 'sector_perf_book.html.j2',
           NULL, email_subject_tpl, email_body_tpl,
           params_json, param_spec_json, 'Y', 'SEED', 'SEED'
      FROM prod.dct_rpt_definition
     WHERE report_code = 'BUDGET_UTIL_BOOK';
  ELSE
    UPDATE prod.dct_rpt_definition
       SET (source_ref, params_json, param_spec_json, category,
            email_subject_tpl, email_body_tpl, source_type, engine) =
           (SELECT source_ref, params_json, param_spec_json, category,
                   email_subject_tpl, email_body_tpl, source_type, engine
              FROM prod.dct_rpt_definition
             WHERE report_code = 'BUDGET_UTIL_BOOK'),
           name_en         = 'Sector Performance Report',
           name_ar         = 'تقرير أداء القطاعات',
           description     = 'Sector Performance Report — the Budget Utilization Briefing Book pack re-covered for distribution, for exactly ONE sector per run (sector is required): DCT logo top-right and a copyright line on every page, simplified cover (YTD period subtitle + sector line), prepared by Financial Planning and Reporting. Data sections are a verbatim copy of BUDGET_UTIL_BOOK — re-run reporting/db/42 after any db/21 re-run to refresh the copy. PDF only; run from the GL Budget Utilization page (Generate Report menu, bridge GL/db/50).',
           pdf_template    = 'sector_perf_book.html.j2',
           default_formats = 'PDF',
           enabled         = 'Y',
           updated_by      = 'SEED',
           updated_at      = SYSTIMESTAMP
     WHERE report_code = 'SECTOR_PERF_BOOK';
  END IF;

  -- chapter-default surgery on the COPIED sections: rewrite the two chapter
  -- predicates (aggregate + s.-aliased scope form, db/21 text VERBATIM) to
  -- NVL the bind with the Opex+Capex default. REPLACE no-ops when the copy
  -- was already patched, so this is idempotent; it runs BEFORE the sp_*
  -- prepend (those sections are built with the NVL form directly).
  UPDATE prod.dct_rpt_definition
     SET source_ref = REPLACE(REPLACE(source_ref,
           REPLACE(q'!([COLON]chapter IS NULL OR INSTR('|'||[COLON]chapter||'|', '|'||chapter||'|') > 0)!', '[COLON]', CHR(58)),
           REPLACE(q'!(INSTR('|'||NVL([COLON]chapter, '!' || l_def || q'!')||'|', '|'||chapter||'|') > 0)!', '[COLON]', CHR(58))),
           REPLACE(q'!([COLON]chapter IS NULL OR INSTR('|'||[COLON]chapter||'|', '|'||s.chapter||'|') > 0)!', '[COLON]', CHR(58)),
           REPLACE(q'!(INSTR('|'||NVL([COLON]chapter, '!' || l_def || q'!')||'|', '|'||s.chapter||'|') > 0)!', '[COLON]', CHR(58)))
   WHERE report_code = 'SECTOR_PERF_BOOK';

  -- PAID%% surgery on the COPIED registers (user round 2026-09-06, Appendix):
  -- ap_lines gains per-invoice paid_pct (header paid ratio, capped 0..1);
  -- grn_lines gains per-receipt-line paid_pct (paid / invoiced of the matched
  -- invoices behind that PO distribution -- the sp_extra linkage grown into
  -- the copied section's inner "a" subquery). Runs BEFORE the sp_* prepend so
  -- the patterns match ONLY the db/21 copy; the copy refresh above restores
  -- the originals on every run, so the surgery re-applies idempotently.
  UPDATE prod.dct_rpt_definition
     SET source_ref = REPLACE(source_ref,
           'x.ap_actual_aed AS matched_aed, x.payment_status FROM prod.dct_unpaid_invoices_v x',
           'x.ap_actual_aed AS matched_aed, x.payment_status, ROUND(100*LEAST(1,GREATEST(0,NVL(x.invoice_amount_paid,0)/NULLIF(x.invoice_amount,0))),1) AS paid_pct FROM prod.dct_unpaid_invoices_v x')
   WHERE report_code = 'SECTOR_PERF_BOOK';
  UPDATE prod.dct_rpt_definition
     SET source_ref = REPLACE(REPLACE(REPLACE(source_ref,
           'x.received_aed - x.invoiced_aed AS uninvoiced_aed FROM (SELECT',
           'x.received_aed - x.invoiced_aed AS uninvoiced_aed, ROUND(100*x.paid_aed/NULLIF(x.invoiced_aed,0),1) AS paid_pct FROM (SELECT'),
           'NVL(a.invoiced_aed,0) AS invoiced_aed FROM (SELECT po_distribution_id,',
           'NVL(a.invoiced_aed,0) AS invoiced_aed, NVL(a.paid_aed,0) AS paid_aed FROM (SELECT po_distribution_id,'),
           'SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS invoiced_aed FROM prod.ap_invoice_distributions d',
           'SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS invoiced_aed, SUM(NVL(d.distribution_amount_functi, d.distribution_amount)*LEAST(1,GREATEST(0,NVL(hh.paid_amt,0)/NULLIF(hh.inv_amt,0)))) AS paid_aed FROM prod.ap_invoice_distributions d LEFT JOIN (SELECT invoice_id, MAX(invoice_amount) AS inv_amt, MAX(invoice_amount_paid) AS paid_amt FROM prod.ap_invoices GROUP BY invoice_id) hh ON hh.invoice_id = d.invoice_id')
   WHERE report_code = 'SECTOR_PERF_BOOK';

  -- terms section: prepend the rich-text "Terms and Key definitions" section
  -- (DCT_GL_REPORT_TERMS, db/v2/129) as the FIRST section of the copied list.
  -- Active-document rule (user 2026-09-06): the document in force at the
  -- report's PERIOD-END date (full year = 31-Dec of the budget year).
  -- Re-applied after every copy refresh; the INSTR guard keeps it single.
  l_terms := '{"key":"terms","title":"Terms and Key definitions","layout":"html","sql":"'
          || 'SELECT t.title, t.content_html FROM prod.dct_gl_report_terms t'
          || ' WHERE t.applied_to = ''SECTOR_PERF'' AND t.status = ''ACTIVE'''
          || ' AND TRUNC(t.start_date) <= CASE WHEN [COLON]period IS NULL THEN TO_DATE([COLON]year || ''-12-31'', ''YYYY-MM-DD'') ELSE LAST_DAY(TO_DATE(''01-'' || [COLON]period, ''DD-MM-YYYY'')) END'
          || ' AND (t.end_date IS NULL OR TRUNC(t.end_date) >= CASE WHEN [COLON]period IS NULL THEN TO_DATE([COLON]year || ''-12-31'', ''YYYY-MM-DD'') ELSE LAST_DAY(TO_DATE(''01-'' || [COLON]period, ''DD-MM-YYYY'')) END)'
          || ' ORDER BY t.term_id"},';

  -- Overview extras (user round 2026-09-06): three SECTOR_PERF-only sections
  -- over prod.dct_sector_perf_v (db/v2/123 -- butil grain + cost adjustments
  -- ALREADY folded + plan + Opex/Capex kind; BUTIL_END-aware, so figures tie
  -- to the book's other sections by construction).
  -- Ratio conventions (user-approved): Actual = AP + GRN + approved costing
  -- adjustments; Actual/Budget % vs the adjusted ANNUAL budget (the standing
  -- vs-Budget rule); Actual/Plan % vs the EFFECTIVE YTD plan (revised when
  -- one exists, else approved); %Paid measured BY AMOUNT.
  -- l_bscope / l_scope are the db/21 predicates VERBATIM -- keep in lock-step.
  l_bscope := q'! WHERE budget_year = [COLON]year AND ([COLON]sector IS NULL OR sector = [COLON]sector) AND (INSTR('|'||NVL([COLON]chapter, '!' || l_def || q'!')||'|', '|'||chapter||'|') > 0) AND ([COLON]projecttype IS NULL OR INSTR('|'||[COLON]projecttype||'|', '|'||project_type||'|') > 0) AND ([COLON]costcenter IS NULL OR (INSTR([COLON]costcenter,'|') = 0 AND cost_centre LIKE '%'||[COLON]costcenter||'%') OR INSTR('|'||[COLON]costcenter||'|', '|'||cost_centre||'|') > 0) AND ([COLON]project IS NULL OR (INSTR([COLON]project,'|') = 0 AND UPPER(project_number||' '||project_name) LIKE '%'||UPPER([COLON]project)||'%') OR INSTR('|'||[COLON]project||'|', '|'||project_number||'|') > 0) AND ([COLON]task IS NULL OR UPPER(task_number) LIKE '%'||UPPER([COLON]task)||'%') AND ([COLON]etype IS NULL OR UPPER(expenditure_type) LIKE '%'||UPPER([COLON]etype)||'%') AND ([COLON]search IS NULL OR UPPER(project_number||' '||project_name||' '||task_number||' '||department||' '||cost_centre||' '||expenditure_type) LIKE '%'||UPPER([COLON]search)||'%') AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||business_unit||'|') > 0)!';
  l_scope  := q'! AND (x.project_number, NVL(x.task_number,'~'), NVL(x.expenditure_type,'~')) IN (SELECT /*+ UNNEST */ s.project_number, NVL(s.task_number,'~'), NVL(s.expenditure_type,'~') FROM prod.dct_butil_scope_v s WHERE s.budget_year = [COLON]year AND ([COLON]sector IS NULL OR s.sector = [COLON]sector) AND (INSTR('|'||NVL([COLON]chapter, '!' || l_def || q'!')||'|', '|'||s.chapter||'|') > 0) AND ([COLON]projecttype IS NULL OR INSTR('|'||[COLON]projecttype||'|', '|'||s.project_type||'|') > 0) AND ([COLON]costcenter IS NULL OR (INSTR([COLON]costcenter,'|') = 0 AND s.cost_centre LIKE '%'||[COLON]costcenter||'%') OR INSTR('|'||[COLON]costcenter||'|', '|'||s.cost_centre||'|') > 0) AND ([COLON]project IS NULL OR (INSTR([COLON]project,'|') = 0 AND UPPER(s.project_number||' '||s.project_name) LIKE '%'||UPPER([COLON]project)||'%') OR INSTR('|'||[COLON]project||'|', '|'||s.project_number||'|') > 0) AND ([COLON]task IS NULL OR UPPER(s.task_number) LIKE '%'||UPPER([COLON]task)||'%') AND ([COLON]etype IS NULL OR UPPER(s.expenditure_type) LIKE '%'||UPPER([COLON]etype)||'%') AND ([COLON]search IS NULL OR UPPER(s.project_number||' '||s.project_name||' '||s.task_number||' '||s.department||' '||s.cost_centre||' '||s.expenditure_type) LIKE '%'||UPPER([COLON]search)||'%') AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||s.business_unit||'|') > 0))!';

  -- sp_extra (kv, one row): Actual vs Plan %, Actual/Budget % (annual), and
  -- the amount-based %Paid pair. AP leg = the direct-AP register view (paid
  -- ratio per invoice header applied to the counted AED); GRN leg = the
  -- PO-matched invoices behind the in-scope receipts (the l_grn linkage with
  -- an ap_invoices header join for the paid ratio).
  l_sx := '{"key":"sp_extra","title":"Sector KPIs","layout":"kv","sql":"'
       || 'SELECT ROUND(100*ov.actual_ytd/NULLIF(ov.eff_plan_ytd,0),1) AS actual_vs_plan_pct,'
       || ' ROUND(100*ov.actual_ytd/NULLIF(ov.budget_annual,0),1) AS actual_budget_pct,'
       || ' ap.ap_paid_pct, ap.ap_paid_aed, gr.grn_paid_pct, gr.grn_paid_aed, ov.actual_ytd, ov.eff_plan_ytd, ov.budget_annual'
       || ' FROM (SELECT SUM(actual_ytd) AS actual_ytd, SUM(budget_annual) AS budget_annual,'
       || ' SUM(CASE WHEN NVL(plan_rev_annual,0)<>0 THEN plan_rev_ytd ELSE plan_ytd END) AS eff_plan_ytd'
       || ' FROM prod.dct_sector_perf_v' || l_bscope || ') ov'
       || ' CROSS JOIN (SELECT ROUND(100*SUM(x.ap_actual_aed*LEAST(1,GREATEST(0,NVL(x.invoice_amount_paid,0)/NULLIF(x.invoice_amount,0))))/NULLIF(SUM(x.ap_actual_aed),0),1) AS ap_paid_pct,'
       || ' SUM(x.ap_actual_aed*LEAST(1,GREATEST(0,NVL(x.invoice_amount_paid,0)/NULLIF(x.invoice_amount,0)))) AS ap_paid_aed'
       || ' FROM prod.dct_unpaid_invoices_v x WHERE x.budget_year = [COLON]year AND ABS(NVL(x.ap_actual_aed,0)) > 0.005' || l_scope || ') ap'
       || ' CROSS JOIN (SELECT ROUND(100*SUM(x.paid_aed)/NULLIF(SUM(x.invoiced_aed),0),1) AS grn_paid_pct, SUM(x.paid_aed) AS grn_paid_aed FROM ('
       || 'SELECT COALESCE(TO_CHAR(pj.project_number), ''#''||TO_CHAR(g.project_id)) AS project_number,'
       || ' COALESCE(tk.task_number, CASE WHEN g.task_id IS NOT NULL THEN ''#''||TO_CHAR(g.task_id) END) AS task_number,'
       || ' g.expenditure_type, a.invoiced_aed, a.paid_aed'
       || ' FROM (SELECT po_distribution_id, MAX(project_id) AS project_id, MAX(task_id) AS task_id, MAX(expenditure_type) AS expenditure_type'
       || ' FROM prod.grn_all_v2 WHERE project_id IS NOT NULL AND EXTRACT(YEAR FROM NVL(accounted_date, transaction_date)) = [COLON]year'
       || ' AND (SYS_CONTEXT(''GL_CTX'',''BUTIL_END'') IS NULL OR NVL(accounted_date, transaction_date) < TO_DATE(SYS_CONTEXT(''GL_CTX'',''BUTIL_END''),''YYYY-MM-DD'') + 1)'
       || ' GROUP BY po_distribution_id) g'
       || ' JOIN (SELECT pk.po_distribution_id, SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS invoiced_aed,'
       || ' SUM(NVL(d.distribution_amount_functi, d.distribution_amount)*LEAST(1,GREATEST(0,NVL(h.paid_amt,0)/NULLIF(h.inv_amt,0)))) AS paid_aed'
       || ' FROM prod.ap_invoice_distributions d'
       || ' LEFT JOIN (SELECT invoice_id, invoice_line_number, MAX(po_number) AS po_number, MAX(po_line_number) AS po_line_number, MAX(po_distribution) AS po_distribution FROM prod.ap_invoice_lines WHERE po_number IS NOT NULL GROUP BY invoice_id, invoice_line_number) lp ON lp.invoice_id = d.invoice_id AND lp.invoice_line_number = d.line_number'
       || ' JOIN (SELECT ph2.order_number AS po_number, pl2.line AS po_line, pod.distribution_number AS po_dist_line, MAX(pod.po_distribution_id) AS po_distribution_id'
       || ' FROM prod.po_distributions pod JOIN prod.po_lines pl2 ON pl2.po_header_id = pod.po_header_id AND pl2.po_line_id = pod.po_line_id'
       || ' JOIN prod.po_headers ph2 ON ph2.po_header_id = pod.po_header_id GROUP BY ph2.order_number, pl2.line, pod.distribution_number) pk'
       || ' ON pk.po_number = COALESCE(lp.po_number, d.po_number) AND pk.po_line = COALESCE(lp.po_line_number, d.po_line) AND pk.po_dist_line = COALESCE(lp.po_distribution, d.po_distribution_line)'
       || ' LEFT JOIN (SELECT invoice_id, MAX(invoice_amount) AS inv_amt, MAX(invoice_amount_paid) AS paid_amt FROM prod.ap_invoices GROUP BY invoice_id) h ON h.invoice_id = d.invoice_id'
       || ' WHERE NVL(d.reversal_indicator,''N'') <> ''Y'' AND EXTRACT(YEAR FROM d.accounting_date) = [COLON]year'
       || ' AND (SYS_CONTEXT(''GL_CTX'',''BUTIL_END'') IS NULL OR d.accounting_date < TO_DATE(SYS_CONTEXT(''GL_CTX'',''BUTIL_END''),''YYYY-MM-DD'') + 1)'
       || ' GROUP BY pk.po_distribution_id) a ON a.po_distribution_id = g.po_distribution_id'
       || ' LEFT JOIN (SELECT project_id, MAX(project_number) AS project_number FROM prod.projects GROUP BY project_id) pj ON pj.project_id = g.project_id'
       || ' LEFT JOIN (SELECT task_id, MAX(task_number) AS task_number FROM prod.tasks GROUP BY task_id) tk ON tk.task_id = g.task_id'
       || ') x WHERE x.project_number NOT LIKE ''#%'' AND x.task_number NOT LIKE ''#_%''' || l_scope || ') gr"},';

  -- sp_dept (table): cost-centre grain (code + FULL department name -- user
  -- feedback 2026-09-06) ordered by largest annual budget; plan_ytd shipped
  -- so the template's Total row can recompute the ratios from sums.
  -- EXTENDED (top-5-by-department round, 2026-09-06): AP/GRN/PO/PR splits,
  -- line counts and the effective annual plan, so each department's Part 04
  -- page can rebuild the FULL Part 02 KPI band + composition bar from its row.
  l_sd := '{"key":"sp_dept","title":"Budget overview by Department","layout":"table","sql":"'
       || 'SELECT NVL(cost_centre, ''-'') AS cost_centre, NVL(department, ''(Unclassified)'') AS department,'
       || ' SUM(budget_annual) AS budget_annual, SUM(budget_ytd) AS budget_ytd,'
       || ' SUM(actual_ytd) AS actual_total, SUM(encumbrance) AS encumbrance, SUM(fund_available) AS fund_available,'
       || ' SUM(actual_ap) AS actual_ap, SUM(actual_grn) AS actual_grn,'
       || ' SUM(obligation_po) AS obligation_po, SUM(commitment_pr) AS commitment_pr,'
       || ' COUNT(*) AS budget_lines, SUM(CASE WHEN fund_available < 0 THEN 1 ELSE 0 END) AS over_budget_lines,'
       || ' SUM(CASE WHEN NVL(plan_rev_annual,0)<>0 THEN plan_rev_annual ELSE plan_annual END) AS plan_annual,'
       || ' SUM(CASE WHEN NVL(plan_rev_annual,0)<>0 THEN plan_rev_ytd ELSE plan_ytd END) AS plan_ytd,'
       || ' ROUND(100*SUM(actual_ytd)/NULLIF(SUM(budget_annual),0),1) AS actual_budget_pct,'
       || ' ROUND(100*SUM(actual_ytd)/NULLIF(SUM(CASE WHEN NVL(plan_rev_annual,0)<>0 THEN plan_rev_ytd ELSE plan_ytd END),0),1) AS actual_plan_pct'
       || ' FROM prod.dct_sector_perf_v' || l_bscope
       || ' GROUP BY NVL(cost_centre, ''-''), NVL(department, ''(Unclassified)'')'
       || ' ORDER BY 3 DESC NULLS LAST"},';

  -- sp_kind (table): one row per expenditure kind IN SCOPE + ROLLUP Total --
  -- default scope = Opex + Capex (the chapter default above), so the table
  -- shows exactly those two; a widened Chapter filter adds its kinds (e.g.
  -- Payroll) and the Total ALWAYS equals the KPI band's whole-scope figures
  l_sk := '{"key":"sp_kind","title":"Sector Overview","layout":"table","sql":"'
       || 'SELECT NVL(kind, ''Total'') AS kind, SUM(budget_annual) AS budget_annual,'
       || ' SUM(actual_ytd) AS actual_ytd, SUM(eff_plan_ytd) AS plan_ytd,'
       || ' ROUND(100*SUM(actual_ytd)/NULLIF(SUM(budget_annual),0),1) AS actual_budget_pct,'
       || ' ROUND(100*SUM(actual_ytd)/NULLIF(SUM(eff_plan_ytd),0),1) AS actual_plan_pct'
       || ' FROM (SELECT expenditure_kind AS kind, budget_annual, actual_ytd,'
       || ' CASE WHEN NVL(plan_rev_annual,0)<>0 THEN plan_rev_ytd ELSE plan_ytd END AS eff_plan_ytd'
       || ' FROM prod.dct_sector_perf_v' || l_bscope || ')'
       || ' GROUP BY ROLLUP(kind)'
       || ' ORDER BY CASE WHEN kind IS NULL THEN 9 WHEN kind = ''Opex'' THEN 1 WHEN kind = ''Capex'' THEN 2 ELSE 3 END, kind"},';

  -- sp_top10 (table, Part 03 -- user round 2026-09-06): the 10 largest task
  -- budget lines in scope (project x task grain, etypes rolled up), ordered by
  -- annual budget. TASK DISPLAY RULE (user): a PLAIN-NUMBER task number (the
  -- MSS style: 2, 4, 5...) is a meaningless sequence code, so the task NAME
  -- prints instead; a code-bearing task number (DCT style, contains letters)
  -- prints as-is. Task names come from ATD_TASKS PROJECT-SCOPED via
  -- ATD_PROJECTS (the db/25 tnm pattern -- the butil view has no name column).
  l_st := '{"key":"sp_top10","title":"Top 10 Projects Budget","layout":"table","sql":"'
       || 'SELECT b.project_number, b.project_name, b.task_number,'
       || ' CASE WHEN REGEXP_LIKE(TRIM(b.task_number), ''^[0-9][0-9. ]*$'') THEN NVL(tnm.task_name, b.task_number) ELSE b.task_number END AS task_disp,'
       || ' b.budget_annual, b.plan_ytd, b.actual_ytd, b.encumbrance, b.fund_available,'
       || ' ROUND(100*b.actual_ytd/NULLIF(b.budget_annual,0),1) AS actual_budget_pct,'
       || ' ROUND(100*b.actual_ytd/NULLIF(b.plan_ytd,0),1) AS actual_plan_pct'
       || ' FROM (SELECT project_number, project_name, task_number,'
       || ' SUM(budget_annual) AS budget_annual, SUM(actual_ytd) AS actual_ytd,'
       || ' SUM(encumbrance) AS encumbrance, SUM(fund_available) AS fund_available,'
       || ' SUM(CASE WHEN NVL(plan_rev_annual,0)<>0 THEN plan_rev_ytd ELSE plan_ytd END) AS plan_ytd'
       || ' FROM prod.dct_sector_perf_v' || l_bscope
       || ' GROUP BY project_number, project_name, task_number'
       || ' ORDER BY 4 DESC NULLS LAST FETCH FIRST 10 ROWS ONLY) b'
       || ' LEFT JOIN (SELECT p.project_number AS tp, t.task_number AS tt, MAX(t.task_name) AS task_name'
       || ' FROM prod.atd_tasks t JOIN prod.atd_projects p ON p.project_id = t.project_id'
       || ' GROUP BY p.project_number, t.task_number) tnm'
       || ' ON tnm.tp = b.project_number AND tnm.tt = b.task_number'
       || ' ORDER BY b.budget_annual DESC NULLS LAST"},';

  -- sp_dkind (table, Part 04): department x expenditure-kind rows -- each
  -- department page's Overview table (its Total row = the sp_dept row itself)
  l_dk := '{"key":"sp_dkind","title":"Department Overview by expenditure kind","layout":"table","sql":"'
       || 'SELECT NVL(cost_centre, ''-'') AS cost_centre, kind, SUM(budget_annual) AS budget_annual,'
       || ' SUM(actual_ytd) AS actual_ytd, SUM(eff_plan_ytd) AS plan_ytd,'
       || ' ROUND(100*SUM(actual_ytd)/NULLIF(SUM(budget_annual),0),1) AS actual_budget_pct,'
       || ' ROUND(100*SUM(actual_ytd)/NULLIF(SUM(eff_plan_ytd),0),1) AS actual_plan_pct'
       || ' FROM (SELECT cost_centre, expenditure_kind AS kind, budget_annual, actual_ytd,'
       || ' CASE WHEN NVL(plan_rev_annual,0)<>0 THEN plan_rev_ytd ELSE plan_ytd END AS eff_plan_ytd'
       || ' FROM prod.dct_sector_perf_v' || l_bscope || ')'
       || ' GROUP BY NVL(cost_centre, ''-''), kind'
       || ' ORDER BY 1, CASE WHEN kind = ''Opex'' THEN 1 WHEN kind = ''Capex'' THEN 2 ELSE 3 END, kind"},';

  -- sp_dproj (table, Part 04): each department''s TOP 5 projects by annual
  -- budget (rn <= 5) + proj_count so the page can note "top 5 of N projects"
  l_dp := '{"key":"sp_dproj","title":"Top 5 Projects Budget by Department","layout":"table","sql":"'
       || 'SELECT cost_centre, project_number, project_name, budget_annual, actual_total, encumbrance,'
       || ' fund_available, plan_ytd, rn, proj_count,'
       || ' ROUND(100*actual_total/NULLIF(budget_annual,0),1) AS actual_budget_pct,'
       || ' ROUND(100*actual_total/NULLIF(plan_ytd,0),1) AS actual_plan_pct'
       || ' FROM (SELECT NVL(cost_centre, ''-'') AS cost_centre, project_number, project_name,'
       || ' SUM(budget_annual) AS budget_annual, SUM(actual_ytd) AS actual_total,'
       || ' SUM(encumbrance) AS encumbrance, SUM(fund_available) AS fund_available,'
       || ' SUM(CASE WHEN NVL(plan_rev_annual,0)<>0 THEN plan_rev_ytd ELSE plan_ytd END) AS plan_ytd,'
       || ' ROW_NUMBER() OVER (PARTITION BY NVL(cost_centre, ''-'') ORDER BY SUM(budget_annual) DESC NULLS LAST) AS rn,'
       || ' COUNT(*) OVER (PARTITION BY NVL(cost_centre, ''-'')) AS proj_count'
       || ' FROM prod.dct_sector_perf_v' || l_bscope
       || ' GROUP BY NVL(cost_centre, ''-''), project_number, project_name)'
       || ' WHERE rn <= 5 ORDER BY cost_centre, rn"},';

  -- sp_supp (table, Part 05 -- user round 2026-09-06): per-supplier DISTINCT
  -- invoice count for the Top-10-suppliers list "(N invoices)" bracket --
  -- BOTH legs (user-approved): the direct AP invoices of the register PLUS the
  -- PO-matched invoices behind the in-scope receipts (the sp_extra linkage +
  -- the register''s own charge-account / non-zero / hash-id exclusions, so the
  -- names key 1:1 to the bars the template sums from the register rows)
  -- + per-supplier PAID figures (user round 2026-09-06, "two-tone bar" pick):
  -- billed = AP counted AED + matched-invoice invoiced AED; paid = the same
  -- weighted by each invoice header''s paid ratio (capped 0..1) -- so
  -- SUM(paid) over suppliers == the Paid KPI legs and paid_pct is always <=100
  l_sp := '{"key":"sp_supp","title":"Supplier invoice counts","layout":"table","sql":"'
       || 'SELECT supplier_name, COUNT(DISTINCT inv_key) AS inv_count,'
       || ' SUM(billed_aed) AS billed_aed, SUM(paid_aed) AS paid_aed,'
       || ' ROUND(100*SUM(paid_aed)/NULLIF(SUM(billed_aed),0),1) AS paid_pct FROM ('
       || 'SELECT NVL(x.supplier_name, ''(Unknown supplier)'') AS supplier_name, ''A''||x.invoice_number AS inv_key,'
       || ' x.ap_actual_aed AS billed_aed,'
       || ' x.ap_actual_aed*LEAST(1,GREATEST(0,NVL(x.invoice_amount_paid,0)/NULLIF(x.invoice_amount,0))) AS paid_aed'
       || ' FROM prod.dct_unpaid_invoices_v x WHERE x.budget_year = [COLON]year AND ABS(NVL(x.ap_actual_aed,0)) > 0.005' || l_scope
       || ' UNION ALL'
       || ' SELECT NVL(x.supplier_name, ''(Unknown supplier)''), ''P''||TO_CHAR(x.invoice_id),'
       || ' x.invoiced_aed, x.invoiced_aed*LEAST(1,GREATEST(0,NVL(x.paid_amt,0)/NULLIF(x.inv_amt,0)))'
       || ' FROM (SELECT COALESCE(TO_CHAR(pj.project_number), ''#''||TO_CHAR(g.project_id)) AS project_number,'
       || ' COALESCE(tk.task_number, CASE WHEN g.task_id IS NOT NULL THEN ''#''||TO_CHAR(g.task_id) END) AS task_number,'
       || ' g.expenditure_type, h.supplier_name, a.invoice_id, a.invoiced_aed, hh.inv_amt, hh.paid_amt'
       || ' FROM (SELECT po_distribution_id, MAX(project_id) AS project_id, MAX(task_id) AS task_id, MAX(expenditure_type) AS expenditure_type, SUM(ledger_amount) AS received_aed'
       || ' FROM prod.grn_all_v2 WHERE project_id IS NOT NULL AND EXTRACT(YEAR FROM NVL(accounted_date, transaction_date)) = [COLON]year'
       || ' AND (SYS_CONTEXT(''GL_CTX'',''BUTIL_END'') IS NULL OR NVL(accounted_date, transaction_date) < TO_DATE(SYS_CONTEXT(''GL_CTX'',''BUTIL_END''),''YYYY-MM-DD'') + 1)'
       || ' GROUP BY po_distribution_id) g'
       || ' JOIN (SELECT pk.po_distribution_id, d.invoice_id, SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS invoiced_aed'
       || ' FROM prod.ap_invoice_distributions d'
       || ' LEFT JOIN (SELECT invoice_id, invoice_line_number, MAX(po_number) AS po_number, MAX(po_line_number) AS po_line_number, MAX(po_distribution) AS po_distribution FROM prod.ap_invoice_lines WHERE po_number IS NOT NULL GROUP BY invoice_id, invoice_line_number) lp ON lp.invoice_id = d.invoice_id AND lp.invoice_line_number = d.line_number'
       || ' JOIN (SELECT ph2.order_number AS po_number, pl2.line AS po_line, pod.distribution_number AS po_dist_line, MAX(pod.po_distribution_id) AS po_distribution_id'
       || ' FROM prod.po_distributions pod JOIN prod.po_lines pl2 ON pl2.po_header_id = pod.po_header_id AND pl2.po_line_id = pod.po_line_id'
       || ' JOIN prod.po_headers ph2 ON ph2.po_header_id = pod.po_header_id GROUP BY ph2.order_number, pl2.line, pod.distribution_number) pk'
       || ' ON pk.po_number = COALESCE(lp.po_number, d.po_number) AND pk.po_line = COALESCE(lp.po_line_number, d.po_line) AND pk.po_dist_line = COALESCE(lp.po_distribution, d.po_distribution_line)'
       || ' WHERE NVL(d.reversal_indicator,''N'') <> ''Y'' AND EXTRACT(YEAR FROM d.accounting_date) = [COLON]year'
       || ' AND (SYS_CONTEXT(''GL_CTX'',''BUTIL_END'') IS NULL OR d.accounting_date < TO_DATE(SYS_CONTEXT(''GL_CTX'',''BUTIL_END''),''YYYY-MM-DD'') + 1)'
       || ' GROUP BY pk.po_distribution_id, d.invoice_id) a ON a.po_distribution_id = g.po_distribution_id'
       || ' LEFT JOIN (SELECT invoice_id, MAX(invoice_amount) AS inv_amt, MAX(invoice_amount_paid) AS paid_amt FROM prod.ap_invoices GROUP BY invoice_id) hh ON hh.invoice_id = a.invoice_id'
       || ' JOIN (SELECT po_distribution_id, MAX(po_header_id) AS po_header_id, MAX(charge_account) AS charge_account FROM prod.po_distributions GROUP BY po_distribution_id) b ON b.po_distribution_id = g.po_distribution_id'
       || ' LEFT JOIN (SELECT po_header_id, MAX(supplier_name) AS supplier_name FROM prod.po_headers GROUP BY po_header_id) h ON h.po_header_id = b.po_header_id'
       || ' LEFT JOIN (SELECT project_id, MAX(project_number) AS project_number FROM prod.projects GROUP BY project_id) pj ON pj.project_id = g.project_id'
       || ' LEFT JOIN (SELECT task_id, MAX(task_number) AS task_number FROM prod.tasks GROUP BY task_id) tk ON tk.task_id = g.task_id'
       || ' WHERE b.charge_account IS NOT NULL AND ABS(g.received_aed) > 0.005) x'
       || ' WHERE x.project_number NOT LIKE ''#%'' AND x.task_number NOT LIKE ''#_%''' || l_scope
       || ') GROUP BY supplier_name"},';

  -- sp_pr (table, Part 07 -- user round 2026-09-06): the 12 largest OPEN
  -- (funds-Reserved) PR lines with the fields the chart needs -- PR line
  -- number + requester (ATD_PR_LINES / the distribution''s own requester) and
  -- days_reserved (today minus the funds-reservation budget date). Predicates
  -- are DCT_RESERVED_PR_LINES_V (db/v2/39) VERBATIM -- keep in lock-step --
  -- because the view itself carries neither pr_line nor requester.
  l_spr := '{"key":"sp_pr","title":"Largest open requisition lines","layout":"table","sql":"'
        || 'SELECT x.project_number, x.task_number, x.expenditure_type, x.pr_number, x.pr_line,'
        || ' x.requester, x.budget_date, x.days_reserved, x.amount_aed FROM ('
        || 'SELECT COALESCE(TO_CHAR(pj.project_number), ''#''||TO_CHAR(d.project_id)) AS project_number,'
        || ' COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN ''#''||TO_CHAR(d.task_id) END) AS task_number,'
        || ' d.expenditure_type, d.requisition AS pr_number, pl.pr_line,'
        || ' COALESCE(pl.requester_name, d.requester) AS requester, d.budget_date,'
        || ' TRUNC(SYSDATE) - TRUNC(d.budget_date) AS days_reserved,'
        || ' d.distribution_amount * NVL(cc.exchange_rate_to_aed,1) AS amount_aed'
        || ' FROM prod.pr_distributions d'
        || ' LEFT JOIN (SELECT pr_line_id, MAX(pr_line) AS pr_line, MAX(requester_name) AS requester_name'
        || ' FROM prod.pr_lines GROUP BY pr_line_id) pl ON pl.pr_line_id = d.pr_line_id'
        || ' LEFT JOIN prod.dct_currency_codes cc ON cc.currency_code = d.currency_code'
        || ' LEFT JOIN (SELECT project_id, MAX(project_number) AS project_number FROM prod.projects GROUP BY project_id) pj ON pj.project_id = d.project_id'
        || ' LEFT JOIN (SELECT task_id, MAX(task_number) AS task_number FROM prod.tasks GROUP BY task_id) tk ON tk.task_id = d.task_id'
        || ' WHERE d.funds_status = ''Reserved'' AND d.project_id IS NOT NULL AND pj.project_number IS NOT NULL'
        || ' AND (tk.task_number IS NOT NULL OR d.task_id IS NULL) AND d.charge_account IS NOT NULL'
        || ' AND EXTRACT(YEAR FROM d.budget_date) = [COLON]year'
        || ' AND (SYS_CONTEXT(''GL_CTX'',''BUTIL_END'') IS NULL OR d.budget_date < TO_DATE(SYS_CONTEXT(''GL_CTX'',''BUTIL_END''),''YYYY-MM-DD'') + 1)) x'
        || ' WHERE 1 = 1' || l_scope
        || ' ORDER BY x.amount_aed DESC NULLS LAST FETCH FIRST 12 ROWS ONLY"},';

  -- sp_dplan (table, Part 09 -- user round 2026-09-06): plan performance at
  -- DEPARTMENT grain (the plan_sector logic re-grained over dct_sector_perf_v,
  -- which already folds cost adjustments + the effective plan) -- execution %,
  -- coverage % and the settings-driven plan status per cost centre; ordered by
  -- largest annual budget (the report''s department convention)
  l_dpl := '{"key":"sp_dplan","title":"Plan Performance - by Department","layout":"table","sql":"'
        || 'SELECT NVL(cost_centre, ''-'') AS cost_centre, NVL(department, ''(Unclassified)'') AS department,'
        || ' SUM(actual_ytd) AS actual_total, SUM(eff_plan_ytd) AS ytd_plan,'
        || ' SUM(eff_plan_annual) AS annual_plan, SUM(budget_annual) AS annual_budget,'
        || ' ROUND(100*SUM(actual_ytd)/NULLIF(SUM(eff_plan_ytd),0),1) AS exec_pct,'
        || ' ROUND(100*SUM(eff_plan_annual)/NULLIF(SUM(budget_annual),0),1) AS coverage_pct,'
        || ' CASE WHEN NVL(SUM(eff_plan_ytd),0) <= 0.005 THEN ''Not planned'''
        || ' WHEN 100*SUM(actual_ytd)/SUM(eff_plan_ytd) < MAX(th.thx1) THEN ''Below plan'''
        || ' WHEN 100*SUM(actual_ytd)/SUM(eff_plan_ytd) > MAX(th.thx2) THEN ''Ahead of plan'''
        || ' ELSE ''Within plan'' END AS plan_status'
        || ' FROM (SELECT cost_centre, department, actual_ytd, budget_annual,'
        || ' CASE WHEN NVL(plan_rev_annual,0)<>0 THEN plan_rev_ytd ELSE plan_ytd END AS eff_plan_ytd,'
        || ' CASE WHEN NVL(plan_rev_annual,0)<>0 THEN plan_rev_annual ELSE plan_annual END AS eff_plan_annual'
        || ' FROM prod.dct_sector_perf_v' || l_bscope || ')'
        || ' CROSS JOIN (SELECT NVL(MAX(CASE s.setting_key WHEN ''PLAN_EXEC_TOL_LOW'' THEN TO_NUMBER(s.setting_value) END),90) AS thx1,'
        || ' NVL(MAX(CASE s.setting_key WHEN ''PLAN_EXEC_TOL_HIGH'' THEN TO_NUMBER(s.setting_value) END),110) AS thx2'
        || ' FROM prod.dct_module_settings s JOIN prod.dct_modules md ON md.module_id = s.module_id AND md.module_code = ''GL'''
        || ' WHERE s.setting_key LIKE ''PLAN%'') th'
        || ' GROUP BY NVL(cost_centre, ''-''), NVL(department, ''(Unclassified)'')'
        || ' ORDER BY 6 DESC NULLS LAST"},';

  l_add := TO_CLOB(l_terms) || l_sx || l_sd || l_sk || l_st || l_dk || l_dp || l_sp || l_spr || l_dpl;
  l_add := REPLACE(l_add, '[COLON]', CHR(58));
  UPDATE prod.dct_rpt_definition
     SET source_ref = REPLACE(source_ref, '"sections":[', '"sections":[' || l_add)
   WHERE report_code = 'SECTOR_PERF_BOOK'
     AND INSTR(source_ref, '"key":"terms"') = 0;

  -- one-sector rule: mark the sector parameter REQUIRED in the copied spec so
  -- the BI Run-Parameters drawer enforces it (RFC-7396 merge keeps the copied
  -- label/hint/lov_sql); re-applied on every run, after the copy refresh
  UPDATE prod.dct_rpt_definition
     SET param_spec_json = JSON_MERGEPATCH(param_spec_json,
           '{"sector":{"required":true,"hint":"Required — the Sector Performance Report runs for exactly one sector.","hint_ar":"مطلوب — يصدر تقرير أداء القطاعات لقطاع واحد."},"chapter":{"hint":"Optional — defaults to the Opex + Capex chapters; a pipe-delimited chapter list (e.g. Chapter 1|Chapter 2|Chapter 3) widens or narrows the scope.","hint_ar":"اختياري — الافتراضي فصلا التشغيل والرأسمالية؛ قائمة فصول مفصولة بعلامة | توسّع النطاق أو تضيّقه."}}' RETURNING CLOB)
   WHERE report_code = 'SECTOR_PERF_BOOK'
     AND param_spec_json IS NOT NULL;

  COMMIT;
  DBMS_OUTPUT.put_line('SECTOR_PERF_BOOK upserted (pre-existing rows: ' || l_n || ')');
END;
/

PROMPT === verify ===
SELECT report_code, name_en, source_type, engine, default_formats,
       pdf_template, LENGTH(source_ref) AS src_len, enabled
  FROM prod.dct_rpt_definition
 WHERE report_code IN ('SECTOR_PERF_BOOK', 'BUDGET_UTIL_BOOK')
 ORDER BY report_code;

SELECT JSON_QUERY(param_spec_json, '$.sector') AS sector_spec,
       CASE WHEN INSTR(source_ref, '"key":"terms"') > 0 THEN 'TERMS OK' ELSE 'TERMS MISSING' END AS terms_ok,
       CASE WHEN INSTR(source_ref, '"key":"sp_extra"') > 0
             AND INSTR(source_ref, '"key":"sp_dept"') > 0
             AND INSTR(source_ref, '"key":"sp_kind"') > 0
             AND INSTR(source_ref, '"key":"sp_top10"') > 0
             AND INSTR(source_ref, '"key":"sp_dkind"') > 0
             AND INSTR(source_ref, '"key":"sp_dproj"') > 0
             AND INSTR(source_ref, '"key":"sp_supp"') > 0
             AND INSTR(source_ref, '"key":"sp_pr"') > 0
             AND INSTR(source_ref, '"key":"sp_dplan"') > 0
             AND INSTR(source_ref, 'AS paid_pct', 1, 2) > 0 THEN 'SP SECTIONS OK'
            ELSE 'SP SECTIONS MISSING' END AS sp_ok,
       CASE WHEN INSTR(source_ref, CHR(58) || 'chapter IS NULL') = 0
             AND INSTR(source_ref, 'NVL(' || CHR(58) || 'chapter') > 0 THEN 'CH DEFAULT OK'
            ELSE 'CH DEFAULT MISSING' END AS chdef_ok,
       CASE WHEN source_ref IS JSON THEN 'SRC OK' ELSE 'SRC BAD' END AS src_ok
  FROM prod.dct_rpt_definition
 WHERE report_code = 'SECTOR_PERF_BOOK';

PROMPT SECTOR_PERF_BOOK definition seeded (copy of BUDGET_UTIL_BOOK, own cover template, sector REQUIRED).
