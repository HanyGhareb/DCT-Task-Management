-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 24 Encumbrances Pending Approval Register
-- File   : reporting/db/24_rpt_enc_pending_register.sql
-- Seeds  : ENC_PENDING_REGISTER -- the EXCEL companion of ENC_PENDING_BOOK
--          (reporting/db/23) for internal analysis: ONE flat register of all
--          pending PR / PO lines with every related attribute (approval trail,
--          budget line, Sector / Cost centre / Account / Appropriation /
--          Program code+name, canonical GL combination, AED amounts) plus the
--          extract-coverage annex as a second sheet. default_formats = XLSX
--          only (build_xlsx_multi renders one styled sheet per section; no
--          PDF template involved).
-- Scope  : SAME business rule as the book (2026-07-16): funds-RESERVED,
--          non-zero lines only; the annex sheet lists snapshot documents not
--          matched to the budget extract. Params = the full GL butil filter
--          set + `source` (PR | PO; empty = both), with the page's exact
--          predicate semantics. Launched from the GL app's "Encumbrances -
--          Pending Approval" page via the GL/db/13 xlsx bridge.
-- Deploy : Windows SQLcl (sql -name prod_mcp) OR python-oracledb (the Linux
--          SQLcl 26.1 script reader swallows big MERGE-bearing blocks).
--          No template upload needed (XLSX writer is generic).
-- Idempotent: MERGE + guarded UPDATE; safe to re-run (re-runs refresh source).
-- CRLF + UTF-8 no BOM. Zero blank lines inside statements.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. ENC_PENDING_REGISTER definition (MULTI, 2 sections, XLSX) ===
DECLARE
  l_scope  VARCHAR2(4000);
  l_reg    VARCHAR2(8000);
  l_um     VARCHAR2(2000);
  l_src    CLOB;
  l_body   CLOB;
BEGIN
  -- scope predicate -- VERBATIM mirror of GL /gl/butil (keep in lock-step
  -- with GL/db/07 / reporting/db/21 + 23)
  l_scope  := q'! AND (x.project_number, NVL(x.task_number,'~'), NVL(x.expenditure_type,'~')) IN (SELECT s.project_number, NVL(s.task_number,'~'), NVL(s.expenditure_type,'~') FROM prod.dct_butil_scope_v s WHERE s.budget_year = [COLON]year AND ([COLON]sector IS NULL OR s.sector = [COLON]sector) AND ([COLON]chapter IS NULL OR INSTR('|'||[COLON]chapter||'|', '|'||s.chapter||'|') > 0) AND ([COLON]projecttype IS NULL OR s.project_type = [COLON]projecttype) AND ([COLON]costcenter IS NULL OR (INSTR([COLON]costcenter,'|') = 0 AND s.cost_centre LIKE '%'||[COLON]costcenter||'%') OR INSTR('|'||[COLON]costcenter||'|', '|'||s.cost_centre||'|') > 0) AND ([COLON]project IS NULL OR (INSTR([COLON]project,'|') = 0 AND UPPER(s.project_number||' '||s.project_name) LIKE '%'||UPPER([COLON]project)||'%') OR INSTR('|'||[COLON]project||'|', '|'||s.project_number||'|') > 0) AND ([COLON]task IS NULL OR UPPER(s.task_number) LIKE '%'||UPPER([COLON]task)||'%') AND ([COLON]etype IS NULL OR UPPER(s.expenditure_type) LIKE '%'||UPPER([COLON]etype)||'%') AND ([COLON]search IS NULL OR UPPER(s.project_number||' '||s.project_name||' '||s.task_number||' '||s.department||' '||s.cost_centre||' '||s.expenditure_type) LIKE '%'||UPPER([COLON]search)||'%'))!';
  -- sheet 1: the flat pending PR + PO register, every related attribute
  l_reg := q'!SELECT x.source AS doc_type, x.doc_number AS document_number, x.doc_line AS line, x.descr AS description_supplier, x.business_unit, x.preparer_buyer, x.submitted_date, x.pending_days, x.pending_with, x.funds_status, x.project_number, x.project_name, x.task_number, x.expenditure_type, coa.sector_name AS sector, coa.chapter_name AS chapter, coa.cost_center_code, coa.cost_center_desc AS cost_center_name, coa.account_code, coa.account_desc AS account_name, coa.appropriation_code, coa.appropriation_desc AS appropriation_name, coa.program_code, coa.program_desc AS program_name, x.budget_date, x.currency, x.line_aed AS amount_aed, x.enc_open_aed AS open_in_encumbrance_aed, x.cc_string AS gl_combination FROM prod.dct_pr_po_pending_v x LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = x.cc_string WHERE x.in_extract = 'Y' AND x.budget_year = [COLON]year AND x.funds_status IN ('Reserved','Partially Liquidated') AND ABS(x.line_aed) > 0.005 AND ([COLON]source IS NULL OR x.source = UPPER([COLON]source)) AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||x.business_unit||'|') > 0)!' || l_scope || q'! ORDER BY x.source, x.pending_days DESC, x.line_aed DESC!';
  -- sheet 2: coverage annex -- snapshot documents not in the budget extract
  l_um := q'!SELECT x.source AS doc_type, x.business_unit, x.doc_number AS document_number, x.preparer_buyer, x.submitted_date, x.pending_days, x.pending_with FROM prod.dct_pr_po_pending_v x WHERE x.in_extract = 'N' AND ([COLON]source IS NULL OR x.source = UPPER([COLON]source)) AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||x.business_unit||'|') > 0) ORDER BY x.pending_days DESC!';
  l_src := '{"required":["year"],'
        || '"pre_sql":"BEGIN IF [COLON]period IS NULL THEN prod.dct_gl_class_pkg.clear_butil_end; ELSE prod.dct_gl_class_pkg.set_butil_end(LAST_DAY(TO_DATE(''01-''||[COLON]period,''DD-MM-YYYY''))); END IF; END;",'
        || '"post_sql":"BEGIN prod.dct_gl_class_pkg.clear_butil_end; END;",'
        || '"sections":['
        || '{"key":"register","title":"Pending PR and PO Register","layout":"table","sql":"' || l_reg || '"}' || ','
        || '{"key":"unmatched","title":"Not in the Budget Extract","layout":"table","sql":"' || l_um || '"}'
        || ']}';
  l_src := REPLACE(l_src, '[COLON]', CHR(58));
  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>Encumbrances Pending Approval Register</strong> (Excel) for budget year '||
    '<strong>{{ params.year }}</strong> is attached: every funds-reserved PR / PO line awaiting '||
    'approval with its full approval trail, budget line and GL classification '||
    '({{ row_count }} lines), plus the extract-coverage annex.</p>'||
    '<p>Prepared by Financial Planning and Budgeting, Finance Department. '||
    'Generated {{ generated_at }} by i-Finance Reporting.</p>';
  MERGE INTO prod.dct_rpt_definition t
  USING (SELECT 'ENC_PENDING_REGISTER' AS report_code FROM dual) s
  ON (t.report_code = s.report_code)
  WHEN NOT MATCHED THEN INSERT
    (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
     default_formats, email_subject_tpl, email_body_tpl, params_json,
     enabled, created_by, updated_by)
  VALUES
    ('ENC_PENDING_REGISTER',
     'Encumbrances Pending Approval Register (Excel)',
     UNISTR('\0633\062C\0644 \0627\0644\0627\0631\062A\0628\0627\0637\0627\062A \0642\064A\062F \0627\0644\0627\0639\062A\0645\0627\062F'),
     'Excel register for internal analysis: ONE flat list of every PR / PO line awaiting approval in Fusion (funds-reserved, non-zero lines -- the ENC_PENDING_BOOK scope rule) with all related information: approval trail (preparer, submitted date, days pending, pending approver), business unit, funds status, project / task / expenditure type, Sector, Chapter, Cost centre, Account, Appropriation and Program (code+name), budget date, AED amounts and the canonical GL combination; a second sheet lists snapshot documents not matched to the budget extract. Parameters mirror the GL page filters: year (required); period (YTD, MM-YYYY), sector, chapter, projecttype, costcenter, project, task, etype, search, source (PR/PO), bu = pipe-delimited Business Unit list (exact any-of, scopes both sheets) -- all optional.',
     'General Ledger', 'MULTI', l_src, 'PYTHON', 'XLSX',
     'Encumbrances Pending Approval Register - {{ params.year }}',
     l_body,
     '{"year":null,"period":null,"sector":null,"chapter":null,"projecttype":null,"costcenter":null,"project":null,"task":null,"etype":null,"search":null,"source":null,"bu":null}',
     'Y', 'SETUP', 'SETUP')
  WHEN MATCHED THEN UPDATE SET
     t.source_type       = 'MULTI',
     t.description       = 'Excel register for internal analysis: ONE flat list of every PR / PO line awaiting approval in Fusion (funds-reserved, non-zero lines -- the ENC_PENDING_BOOK scope rule) with all related information: approval trail (preparer, submitted date, days pending, pending approver), business unit, funds status, project / task / expenditure type, Sector, Chapter, Cost centre, Account, Appropriation and Program (code+name), budget date, AED amounts and the canonical GL combination; a second sheet lists snapshot documents not matched to the budget extract. Parameters mirror the GL page filters: year (required); period (YTD, MM-YYYY), sector, chapter, projecttype, costcenter, project, task, etype, search, source (PR/PO), bu = pipe-delimited Business Unit list (exact any-of, scopes both sheets) -- all optional.',
     t.source_ref        = l_src,
     t.engine            = 'PYTHON',
     t.default_formats   = 'XLSX',
     t.email_subject_tpl = 'Encumbrances Pending Approval Register - {{ params.year }}',
     t.email_body_tpl    = l_body,
     t.params_json       = '{"year":null,"period":null,"sector":null,"chapter":null,"projecttype":null,"costcenter":null,"project":null,"task":null,"etype":null,"search":null,"source":null,"bu":null}',
     t.updated_by        = 'SETUP',
     t.updated_at        = SYSTIMESTAMP;
  MERGE INTO prod.dct_rpt_recipient t
  USING (SELECT 'ENC_PENDING_REGISTER' AS rc, 'SELF' AS rt FROM dual) s
  ON (t.report_code = s.rc AND t.recipient_type = s.rt)
  WHEN NOT MATCHED THEN INSERT
    (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
  VALUES
    ('ENC_PENDING_REGISTER', 'SELF', NULL, 'EMAIL', 'Y', 'SETUP', 'SETUP');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('ENC_PENDING_REGISTER seeded (definition + SELF recipient).');
END;
/

PROMPT === 2. Parameter spec (copy the book set + the source param) ===
UPDATE prod.dct_rpt_definition
   SET param_spec_json = JSON_MERGEPATCH(
       (SELECT param_spec_json FROM prod.dct_rpt_definition WHERE report_code = 'BUDGET_UTIL_BOOK'),
       '{"source":{"label":"Source (PR / PO)","hint":"Optional. PR = requisitions only, PO = purchase orders only; leave empty for both.","required":false},"bu":{"label":"Business unit(s)","hint":"Optional. Pipe-separated exact list of Fusion Business Units; empty = all.","required":false}}')
 WHERE report_code = 'ENC_PENDING_REGISTER'
   AND EXISTS (SELECT 1 FROM prod.dct_rpt_definition WHERE report_code = 'BUDGET_UTIL_BOOK');
COMMIT;

PROMPT === 3. Verify ===
SELECT report_code, source_type, engine, default_formats,
       CASE WHEN source_ref IS JSON THEN 'SRC OK' ELSE 'SRC BAD' END AS src_ok,
       CASE WHEN param_spec_json IS JSON THEN 'SPEC OK' ELSE 'SPEC BAD' END AS spec_ok,
       DBMS_LOB.GETLENGTH(source_ref) AS src_len
FROM prod.dct_rpt_definition
WHERE report_code = 'ENC_PENDING_REGISTER';

PROMPT ============================================================
PROMPT  24_rpt_enc_pending_register.sql complete (ENC_PENDING_REGISTER).
PROMPT ============================================================
