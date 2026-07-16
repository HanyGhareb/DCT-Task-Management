-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 23 Encumbrances Pending Approval Book
-- File   : reporting/db/23_rpt_enc_pending_book.sql
-- Seeds  : ENC_PENDING_BOOK -- "Briefing Book" MULTI report (PDF via the
--          enc_pending_book.html.j2 Chromium template): cover + contents,
--          Part 1 pending-approval overview (KPIs + aging + sector analysis),
--          Part 2 approver follow-up (top pending approvers + oldest docs),
--          Part 3 pending PR register, Part 4 pending PO register,
--          Part 5 insights + methodology + extract-coverage annex.
-- Data   : prod.dct_pr_po_pending_v (db/v2/52 -- the daily Fusion BIP
--          pending-approval snapshot joined to the open-encumbrance line
--          detail; BUTIL_END-aware) + prod.dct_budget_utilization_v /
--          prod.dct_butil_scope_v (db/v2/37+39) for the budget frame.
--          Params mirror the GL butil page filter set -- year REQUIRED;
--          period (YTD MM-YYYY) / sector / chapter / projecttype /
--          costcenter / project / task / etype / search optional, with the
--          page's exact predicate semantics. Launched from the GL app's
--          "Encumbrances - Pending Approval" page via GL/db/13 bridges.
--          BUSINESS RULE (user, 2026-07-16): the book covers funds-RESERVED,
--          non-zero lines only -- not-reserved documents and zero-value lines
--          are excluded from every section (the GL page still shows them).
--          Registers carry Sector / Cost centre (code+name) / Appropriation
--          (code+name) via DCT_GL_COA_SNAP; no Currency / Funds columns.
-- Deploy : Windows SQLcl (sql -name prod_mcp) OR python-oracledb (the Linux
--          SQLcl 26.1 script reader swallows big MERGE-bearing blocks).
--          After seeding, upload the template:
--            python runner/upload_template.py templates/enc_pending_book.html.j2 --ords
-- Idempotent: MERGE + guarded UPDATE; safe to re-run (re-runs refresh source).
-- CRLF + UTF-8 no BOM. Zero blank lines inside statements.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. ENC_PENDING_BOOK definition (MULTI, 9 sections) ===
DECLARE
  l_bscope VARCHAR2(2000);
  l_scope  VARCHAR2(4000);
  l_docg   VARCHAR2(6000);
  l_ov     VARCHAR2(8000);
  l_ctx    VARCHAR2(4000);
  l_ag     VARCHAR2(8000);
  l_apv    VARCHAR2(8000);
  l_secr   VARCHAR2(8000);
  l_prr    VARCHAR2(8000);
  l_por    VARCHAR2(8000);
  l_old    VARCHAR2(8000);
  l_um     VARCHAR2(2000);
  l_src    CLOB;
  l_body   CLOB;
BEGIN
  -- shared predicates -- VERBATIM mirror of the GL /gl/butil page handler
  -- (GL/db/07 / reporting/db/21, keep in lock-step): sector/projecttype exact;
  -- chapter/costcenter/project pipe-delimited multi-select OR contains-match;
  -- task/etype/search contains-match. Aggregate budget-frame section filters
  -- the butil fact view directly; the pending sections join the scope view on
  -- the FULL fact key (project, task, expenditure type).
  l_bscope := q'! WHERE budget_year = [COLON]year AND ([COLON]sector IS NULL OR sector = [COLON]sector) AND ([COLON]chapter IS NULL OR INSTR('|'||[COLON]chapter||'|', '|'||chapter||'|') > 0) AND ([COLON]projecttype IS NULL OR project_type = [COLON]projecttype) AND ([COLON]costcenter IS NULL OR (INSTR([COLON]costcenter,'|') = 0 AND cost_centre LIKE '%'||[COLON]costcenter||'%') OR INSTR('|'||[COLON]costcenter||'|', '|'||cost_centre||'|') > 0) AND ([COLON]project IS NULL OR (INSTR([COLON]project,'|') = 0 AND UPPER(project_number||' '||project_name) LIKE '%'||UPPER([COLON]project)||'%') OR INSTR('|'||[COLON]project||'|', '|'||project_number||'|') > 0) AND ([COLON]task IS NULL OR UPPER(task_number) LIKE '%'||UPPER([COLON]task)||'%') AND ([COLON]etype IS NULL OR UPPER(expenditure_type) LIKE '%'||UPPER([COLON]etype)||'%') AND ([COLON]search IS NULL OR UPPER(project_number||' '||project_name||' '||task_number||' '||department||' '||cost_centre||' '||expenditure_type) LIKE '%'||UPPER([COLON]search)||'%')!';
  l_scope  := q'! AND (x.project_number, NVL(x.task_number,'~'), NVL(x.expenditure_type,'~')) IN (SELECT s.project_number, NVL(s.task_number,'~'), NVL(s.expenditure_type,'~') FROM prod.dct_butil_scope_v s WHERE s.budget_year = [COLON]year AND ([COLON]sector IS NULL OR s.sector = [COLON]sector) AND ([COLON]chapter IS NULL OR INSTR('|'||[COLON]chapter||'|', '|'||s.chapter||'|') > 0) AND ([COLON]projecttype IS NULL OR s.project_type = [COLON]projecttype) AND ([COLON]costcenter IS NULL OR (INSTR([COLON]costcenter,'|') = 0 AND s.cost_centre LIKE '%'||[COLON]costcenter||'%') OR INSTR('|'||[COLON]costcenter||'|', '|'||s.cost_centre||'|') > 0) AND ([COLON]project IS NULL OR (INSTR([COLON]project,'|') = 0 AND UPPER(s.project_number||' '||s.project_name) LIKE '%'||UPPER([COLON]project)||'%') OR INSTR('|'||[COLON]project||'|', '|'||s.project_number||'|') > 0) AND ([COLON]task IS NULL OR UPPER(s.task_number) LIKE '%'||UPPER([COLON]task)||'%') AND ([COLON]etype IS NULL OR UPPER(s.expenditure_type) LIKE '%'||UPPER([COLON]etype)||'%') AND ([COLON]search IS NULL OR UPPER(s.project_number||' '||s.project_name||' '||s.task_number||' '||s.department||' '||s.cost_centre||' '||s.expenditure_type) LIKE '%'||UPPER([COLON]search)||'%'))!';
  -- shared document-grain inline view (one row per pending document in scope;
  -- RESERVED non-zero lines only per the 2026-07-16 business rule; the COA
  -- attrs collapse to '(Multiple)' when a document spans several combinations)
  l_docg := q'!(SELECT x.source, x.doc_number, MAX(x.business_unit) AS business_unit, MAX(x.descr) AS description, MAX(x.preparer_buyer) AS preparer_buyer, MAX(x.submitted_date) AS submitted_date, NVL(MAX(x.pending_days),0) AS pending_days, MAX(x.pending_with) AS pending_with, COUNT(*) AS doc_lines, SUM(x.line_aed) AS doc_amt, SUM(x.enc_open_aed) AS enc_open_aed, CASE WHEN MIN(NVL(coa.sector_name,'~')) = MAX(NVL(coa.sector_name,'~')) THEN MAX(coa.sector_name) ELSE '(Multiple)' END AS sector, CASE WHEN MIN(NVL(coa.cost_center_code,'~')) = MAX(NVL(coa.cost_center_code,'~')) THEN MAX(coa.cost_center_code || ' - ' || coa.cost_center_desc) ELSE '(Multiple)' END AS cost_centre, CASE WHEN MIN(NVL(coa.appropriation_code,'~')) = MAX(NVL(coa.appropriation_code,'~')) THEN MAX(coa.appropriation_code || ' - ' || coa.appropriation_desc) ELSE '(Multiple)' END AS appropriation FROM prod.dct_pr_po_pending_v x LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = x.cc_string WHERE x.in_extract = 'Y' AND x.budget_year = [COLON]year AND x.funds_status IN ('Reserved','Partially Liquidated') AND ABS(x.line_aed) > 0.005 AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||x.business_unit||'|') > 0)!' || l_scope || q'! GROUP BY x.source, x.doc_number)!';
  -- part 1a: one-row overview (KPIs, document grain)
  l_ov := q'!SELECT COUNT(*) AS docs, SUM(CASE WHEN source = 'PR' THEN 1 ELSE 0 END) AS pr_docs, SUM(CASE WHEN source = 'PO' THEN 1 ELSE 0 END) AS po_docs, SUM(doc_lines) AS lines, SUM(doc_amt) AS amt_total, SUM(CASE WHEN source = 'PR' THEN doc_amt ELSE 0 END) AS amt_pr, SUM(CASE WHEN source = 'PO' THEN doc_amt ELSE 0 END) AS amt_po, SUM(enc_open_aed) AS enc_open_aed, ROUND(AVG(pending_days),1) AS avg_days, MAX(pending_days) AS max_days, SUM(CASE WHEN pending_days > 30 THEN 1 ELSE 0 END) AS over30_docs, SUM(CASE WHEN pending_days > 30 THEN doc_amt ELSE 0 END) AS over30_amt FROM !' || l_docg;
  -- part 1b: the budget frame the pending demand lands on (butil fact view)
  l_ctx := q'!SELECT SUM(budget) AS budget, SUM(actual_ap) + SUM(actual_grn) AS actual_total, SUM(commitment_pr) AS commitment_pr, SUM(obligation_po) AS obligation_po, SUM(commitment_pr) + SUM(obligation_po) AS open_encumbrance, SUM(fund_available) AS fund_available FROM prod.dct_budget_utilization_v!' || l_bscope;
  -- part 1c: aging buckets (document grain)
  l_ag := q'!SELECT CASE WHEN pending_days <= 7 THEN '0-7' WHEN pending_days <= 15 THEN '8-15' WHEN pending_days <= 30 THEN '16-30' ELSE '31+' END AS bucket, COUNT(*) AS docs, SUM(CASE WHEN source = 'PR' THEN 1 ELSE 0 END) AS pr_docs, SUM(CASE WHEN source = 'PO' THEN 1 ELSE 0 END) AS po_docs, SUM(doc_amt) AS amount_aed FROM !' || l_docg || q'! GROUP BY CASE WHEN pending_days <= 7 THEN '0-7' WHEN pending_days <= 15 THEN '8-15' WHEN pending_days <= 30 THEN '16-30' ELSE '31+' END ORDER BY MIN(CASE WHEN pending_days <= 7 THEN 1 WHEN pending_days <= 15 THEN 2 WHEN pending_days <= 30 THEN 3 ELSE 4 END)!';
  -- part 2a: top pending approvers (follow-up list)
  l_apv := q'!SELECT pending_with, COUNT(*) AS docs, SUM(doc_lines) AS lines, SUM(doc_amt) AS amount_aed, MAX(pending_days) AS max_days, MIN(submitted_date) AS oldest_submitted FROM !' || l_docg || q'! GROUP BY pending_with ORDER BY 4 DESC NULLS LAST FETCH FIRST 15 ROWS ONLY!';
  -- part 1d: pending value by sector (line grain via the canonical combination)
  l_secr := q'!SELECT NVL(coa.sector_name,'(Unclassified)') AS sector, COUNT(DISTINCT x.source||'~'||x.doc_number) AS docs, COUNT(*) AS lines, SUM(x.line_aed) AS amount_aed, SUM(CASE WHEN x.pending_days > 30 THEN x.line_aed ELSE 0 END) AS over30_aed FROM prod.dct_pr_po_pending_v x LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = x.cc_string WHERE x.in_extract = 'Y' AND x.budget_year = [COLON]year AND x.funds_status IN ('Reserved','Partially Liquidated') AND ABS(x.line_aed) > 0.005 AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||x.business_unit||'|') > 0)!' || l_scope || q'! GROUP BY NVL(coa.sector_name,'(Unclassified)') ORDER BY 4 DESC!';
  -- part 3: pending PR register (line grain, oldest first; + Sector / Cost
  -- centre / Appropriation code+name via the COA snapshot)
  l_prr := q'!SELECT x.doc_number, x.doc_line, x.descr AS description, x.preparer_buyer, x.submitted_date, x.pending_days, x.pending_with, x.project_number, x.project_name, x.task_number, x.expenditure_type, coa.sector_name, coa.cost_center_code, coa.cost_center_desc, coa.appropriation_code, coa.appropriation_desc, x.budget_date, x.line_aed FROM prod.dct_pr_po_pending_v x LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = x.cc_string WHERE x.in_extract = 'Y' AND x.source = 'PR' AND x.budget_year = [COLON]year AND x.funds_status IN ('Reserved','Partially Liquidated') AND ABS(x.line_aed) > 0.005 AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||x.business_unit||'|') > 0)!' || l_scope || q'! ORDER BY x.pending_days DESC, x.line_aed DESC!';
  -- part 4: pending PO register (line grain, oldest first; open = GRN-netted)
  l_por := q'!SELECT x.doc_number, x.doc_line, x.descr AS supplier_name, x.preparer_buyer, x.submitted_date, x.pending_days, x.pending_with, x.project_number, x.project_name, x.task_number, x.expenditure_type, coa.sector_name, coa.cost_center_code, coa.cost_center_desc, coa.appropriation_code, coa.appropriation_desc, x.budget_date, x.line_aed, x.enc_open_aed AS open_aed FROM prod.dct_pr_po_pending_v x LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = x.cc_string WHERE x.in_extract = 'Y' AND x.source = 'PO' AND x.budget_year = [COLON]year AND x.funds_status IN ('Reserved','Partially Liquidated') AND ABS(x.line_aed) > 0.005 AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||x.business_unit||'|') > 0)!' || l_scope || q'! ORDER BY x.pending_days DESC, x.line_aed DESC!';
  -- part 2b: the 20 longest-waiting documents
  l_old := q'!SELECT source, doc_number, description, preparer_buyer, submitted_date, pending_days, pending_with, doc_amt, sector, cost_centre, appropriation FROM !' || l_docg || q'! ORDER BY pending_days DESC, doc_amt DESC FETCH FIRST 20 ROWS ONLY!';
  -- annex: snapshot documents not yet matched to the budget extract (whole
  -- snapshot -- these rows have no project/budget attributes to filter on)
  l_um := q'!SELECT x.source, x.business_unit, x.doc_number, x.preparer_buyer, x.submitted_date, x.pending_days, x.pending_with FROM prod.dct_pr_po_pending_v x WHERE x.in_extract = 'N' AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||x.business_unit||'|') > 0) ORDER BY x.pending_days DESC!';
  -- YTD period: pre_sql sets GL_CTX.BUTIL_END exactly like the /gl/pending
  -- handler; post_sql ALWAYS clears it (worker keeps one session across runs)
  l_src := '{"orientation":"landscape","required":["year"],'
        || '"pre_sql":"BEGIN IF [COLON]period IS NULL THEN prod.dct_gl_class_pkg.clear_butil_end; ELSE prod.dct_gl_class_pkg.set_butil_end(LAST_DAY(TO_DATE(''01-''||[COLON]period,''DD-MM-YYYY''))); END IF; END;",'
        || '"post_sql":"BEGIN prod.dct_gl_class_pkg.clear_butil_end; END;",'
        || '"sections":['
        || '{"key":"overview","title":"Pending Approval Overview","layout":"kv","sql":"' || l_ov || '"}' || ','
        || '{"key":"budget_ctx","title":"Budget Frame","layout":"kv","sql":"' || l_ctx || '"}' || ','
        || '{"key":"aging","title":"Aging Analysis","layout":"table","sql":"' || l_ag || '"}' || ','
        || '{"key":"approvers","title":"Pending Approvers","layout":"table","sql":"' || l_apv || '"}' || ','
        || '{"key":"sectors","title":"Pending Value by Sector","layout":"table","sql":"' || l_secr || '"}' || ','
        || '{"key":"oldest","title":"Longest-Waiting Documents","layout":"table","sql":"' || l_old || '"}' || ','
        || '{"key":"pr_register","title":"Pending Purchase Requisitions","layout":"table","sql":"' || l_prr || '"}' || ','
        || '{"key":"po_register","title":"Pending Purchase Orders","layout":"table","sql":"' || l_por || '"}' || ','
        || '{"key":"unmatched","title":"Documents Not in the Budget Extract","layout":"table","sql":"' || l_um || '"}'
        || ']}';
  l_src := REPLACE(l_src, '[COLON]', CHR(58));
  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>Encumbrances Pending Approval Briefing Book</strong> for budget year '||
    '<strong>{{ params.year }}</strong>{% if params.sector %} ({{ params.sector }} sector){% endif %} '||
    'is attached. It covers every PR / PO document awaiting approval in Fusion: the monitoring '||
    'overview with aging analysis, the approver follow-up list, the full pending requisition and '||
    'purchase-order registers with their budget lines, and closes with observations for management '||
    'review ({{ row_count }} detail lines).</p>'||
    '<p>Prepared by Financial Planning and Budgeting, Finance Department. '||
    'Generated {{ generated_at }} by i-Finance Reporting.</p>';
  MERGE INTO prod.dct_rpt_definition t
  USING (SELECT 'ENC_PENDING_BOOK' AS report_code FROM dual) s
  ON (t.report_code = s.report_code)
  WHEN NOT MATCHED THEN INSERT
    (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
     default_formats, pdf_template, email_subject_tpl, email_body_tpl, params_json,
     enabled, created_by, updated_by)
  VALUES
    ('ENC_PENDING_BOOK',
     'Encumbrances Pending Approval Briefing Book',
     UNISTR('\0643\062A\064A\0628 \0627\0644\0627\0631\062A\0628\0627\0637\0627\062A \0642\064A\062F \0627\0644\0627\0639\062A\0645\0627\062F'),
     'Briefing-book PDF for the PR / PO documents awaiting approval in Fusion: cover + contents, pending-approval overview with KPIs, aging and sector analysis, approver follow-up list with the longest-waiting documents, the full pending requisition and purchase-order registers (budget line, GL combination scope, submitted date, days pending, pending approver), management insights and an extract-coverage annex. Scope rule: funds-RESERVED, non-zero lines only (not-reserved documents and zero-value lines are excluded). Registers carry Sector, Cost centre and Appropriation (code+name). Parameters mirror the GL Budget Utilization page filters: year (required); period (YTD, MM-YYYY), sector, chapter, projecttype, costcenter, project, task, etype, search, plus bu = pipe-delimited Business Unit list (exact any-of; scopes every section incl. the extract-coverage annex; all optional -- empty = whole organisation, full year, all business units).',
     'General Ledger', 'MULTI', l_src, 'PYTHON', 'PDF',
     'enc_pending_book.html.j2',
     'Encumbrances Pending Approval Briefing Book - {{ params.year }}{% if params.sector %} - {{ params.sector }}{% endif %}',
     l_body,
     '{"year":null,"period":null,"sector":null,"chapter":null,"projecttype":null,"costcenter":null,"project":null,"task":null,"etype":null,"search":null,"bu":null}',
     'Y', 'SETUP', 'SETUP')
  WHEN MATCHED THEN UPDATE SET
     t.source_type       = 'MULTI',
     t.description       = 'Briefing-book PDF for the PR / PO documents awaiting approval in Fusion: cover + contents, pending-approval overview with KPIs, aging and sector analysis, approver follow-up list with the longest-waiting documents, the full pending requisition and purchase-order registers (budget line, GL combination scope, submitted date, days pending, pending approver), management insights and an extract-coverage annex. Scope rule: funds-RESERVED, non-zero lines only (not-reserved documents and zero-value lines are excluded). Registers carry Sector, Cost centre and Appropriation (code+name). Parameters mirror the GL Budget Utilization page filters: year (required); period (YTD, MM-YYYY), sector, chapter, projecttype, costcenter, project, task, etype, search, plus bu = pipe-delimited Business Unit list (exact any-of; scopes every section incl. the extract-coverage annex; all optional -- empty = whole organisation, full year, all business units).',
     t.source_ref        = l_src,
     t.engine            = 'PYTHON',
     t.default_formats   = 'PDF',
     t.pdf_template      = 'enc_pending_book.html.j2',
     t.email_subject_tpl = 'Encumbrances Pending Approval Briefing Book - {{ params.year }}{% if params.sector %} - {{ params.sector }}{% endif %}',
     t.email_body_tpl    = l_body,
     t.params_json       = '{"year":null,"period":null,"sector":null,"chapter":null,"projecttype":null,"costcenter":null,"project":null,"task":null,"etype":null,"search":null,"bu":null}',
     t.updated_by        = 'SETUP',
     t.updated_at        = SYSTIMESTAMP;
  MERGE INTO prod.dct_rpt_recipient t
  USING (SELECT 'ENC_PENDING_BOOK' AS rc, 'SELF' AS rt FROM dual) s
  ON (t.report_code = s.rc AND t.recipient_type = s.rt)
  WHEN NOT MATCHED THEN INSERT
    (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
  VALUES
    ('ENC_PENDING_BOOK', 'SELF', NULL, 'EMAIL', 'Y', 'SETUP', 'SETUP');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('ENC_PENDING_BOOK seeded (definition + SELF recipient).');
END;
/

PROMPT === 2. Parameter spec (labels + hints + LOVs; mirrors the GL page filters) ===
UPDATE prod.dct_rpt_definition
   SET param_spec_json = JSON_MERGEPATCH(
       (SELECT param_spec_json FROM prod.dct_rpt_definition WHERE report_code = 'BUDGET_UTIL_BOOK'),
       '{"bu":{"label":"Business unit(s)","hint":"Optional. Pipe-separated exact list of Fusion Business Units (e.g. Department of Culture and Tourism|Museum Shared Services); empty = all.","required":false}}')
 WHERE report_code = 'ENC_PENDING_BOOK'
   AND EXISTS (SELECT 1 FROM prod.dct_rpt_definition WHERE report_code = 'BUDGET_UTIL_BOOK');
COMMIT;

PROMPT === 3. Verify ===
SELECT report_code, source_type, engine, default_formats, pdf_template,
       CASE WHEN source_ref IS JSON THEN 'SRC OK' ELSE 'SRC BAD' END AS src_ok,
       CASE WHEN param_spec_json IS JSON THEN 'SPEC OK' ELSE 'SPEC BAD' END AS spec_ok,
       DBMS_LOB.GETLENGTH(source_ref) AS src_len
FROM prod.dct_rpt_definition
WHERE report_code = 'ENC_PENDING_BOOK';

PROMPT ============================================================
PROMPT  23_rpt_enc_pending_book.sql complete (ENC_PENDING_BOOK).
PROMPT ============================================================
