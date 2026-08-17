-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 37 Procash Transactions Register/Book
-- File   : reporting/db/37_rpt_procash_register.sql
-- Seeds  : PROCASH_REGISTER -- manual bank-portal payments recorded outside
--          Fusion Payables, run from the AP app's Procash page (bridge =
--          final apps/AP/db/12). ONE definition, TWO formats: XLSX (sheet per
--          section) and PDF (custom template procash_book.html.j2, DB-stored
--          via /rpt/templates -- the default report.html.j2 has NO sections
--          loop, so a MULTI PDF needs its own).
--          Sections (lock-step with final apps/AP/db/10 handlers):
--            1. summary     -- one row per status: count, AED, lines
--            2. register    -- the payment headers
--            3. lines       -- detail lines with their budget coding
--            4. invoices    -- payment vs the Fusion payable invoice
--            5. exceptions  -- out of balance / awaiting invoice / mismatched
-- Params : status, bu, datefrom, dateto, search -- all optional, and all
--          mirroring the page filters so the book scope IS the page scope.
-- Deploy : SQLcl (sql -name prod_mcp, JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8)
--          or python-oracledb. Idempotent; count-then-insert/update (no MERGE).
-- NOTE   : TO_CHAR time masks use 'HH'||CHR(58)||'MI AM' -- a literal colon in
--          a section SQL becomes a phantom bind in the python datasource.
-- CRLF-safe. Zero blank lines inside statements.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. PROCASH_REGISTER definition (MULTI, 5 sections, XLSX+PDF) ===
DECLARE
  l_flt  VARCHAR2(2000);
  l_sum  VARCHAR2(4000);
  l_reg  VARCHAR2(8000);
  l_lin  VARCHAR2(8000);
  l_inv  VARCHAR2(8000);
  l_exc  VARCHAR2(8000);
  l_src  CLOB;
  l_body CLOB;
  l_spec CLOB;
  l_desc VARCHAR2(1000);
  l_n    NUMBER;
BEGIN
  l_flt := q'! ([COLON]status IS NULL OR INSTR('|'||[COLON]status||'|','|'||p.status||'|') > 0) AND ([COLON]bu IS NULL OR p.business_unit = [COLON]bu) AND ([COLON]datefrom IS NULL OR p.payment_date >= TO_DATE([COLON]datefrom,'YYYY-MM-DD')) AND ([COLON]dateto IS NULL OR p.payment_date < TO_DATE([COLON]dateto,'YYYY-MM-DD') + 1) AND ([COLON]search IS NULL OR UPPER(p.bank_reference||' '||p.payment_number||' '||NVL(p.payee_name,' ')||' '||NVL(p.description,' ')) LIKE '%'||UPPER([COLON]search)||'%')!';

  l_sum := q'!SELECT p.status, COUNT(*) AS transactions, ROUND(SUM(p.amount_aed),2) AS amount_aed, SUM((SELECT COUNT(*) FROM prod.dct_ap_procash_line l WHERE l.procash_id = p.procash_id)) AS detail_lines, COUNT(CASE WHEN p.invoice_id IS NOT NULL THEN 1 END) AS invoiced, COUNT(CASE WHEN p.amount_mismatch = 'Y' THEN 1 END) AS mismatched FROM prod.dct_ap_procash p WHERE!'
        || l_flt || q'! GROUP BY p.status ORDER BY p.status!';

  l_reg := q'!SELECT p.payment_number, p.bank_reference, p.bank_account, p.business_unit, NVL(p.payee_name, p.supplier_name) AS payee, p.supplier_number, TO_CHAR(p.payment_date,'YYYY-MM-DD') AS payment_date, p.currency_code, p.amount, p.exchange_rate, p.amount_aed, p.status, (SELECT COUNT(*) FROM prod.dct_ap_procash_line l WHERE l.procash_id = p.procash_id) AS lines, (SELECT NVL(SUM(l.amount),0) FROM prod.dct_ap_procash_line l WHERE l.procash_id = p.procash_id) AS lines_total, p.invoice_number, TO_CHAR(p.invoice_date,'YYYY-MM-DD') AS invoice_date, p.invoice_amount, p.amount_mismatch, p.description, cu.display_name AS created_by, TO_CHAR(prod.dct_to_local(p.created_on),'YYYY-MM-DD HH'||CHR(58)||'MI AM') AS created_on, pu.display_name AS processed_by, TO_CHAR(prod.dct_to_local(p.processed_on),'YYYY-MM-DD HH'||CHR(58)||'MI AM') AS processed_on FROM prod.dct_ap_procash p LEFT JOIN prod.dct_users cu ON cu.user_id = p.created_by LEFT JOIN prod.dct_users pu ON pu.user_id = p.processed_by WHERE!'
        || l_flt || q'! ORDER BY p.payment_date DESC, p.procash_id DESC!';

  l_lin := q'!SELECT p.payment_number, p.bank_reference, p.business_unit, TO_CHAR(p.payment_date,'YYYY-MM-DD') AS payment_date, p.status, l.line_num, l.coding_basis, l.project_number, pr.project_name_en AS project_name, l.task_number, tk.task_name_en AS task_name, l.expenditure_type, l.gl_combination, l.amount, p.currency_code, ROUND(l.amount * p.exchange_rate, 2) AS amount_aed, l.comments FROM prod.dct_ap_procash p JOIN prod.dct_ap_procash_line l ON l.procash_id = p.procash_id LEFT JOIN prod.dct_projects pr ON pr.project_number = l.project_number LEFT JOIN prod.dct_tasks tk ON tk.project_number = l.project_number AND tk.task_number = l.task_number WHERE!'
        || l_flt || q'! ORDER BY p.payment_date DESC, p.procash_id DESC, l.line_num!';

  l_inv := q'!SELECT p.payment_number, p.bank_reference, NVL(p.payee_name, p.supplier_name) AS payee, p.business_unit, TO_CHAR(p.payment_date,'YYYY-MM-DD') AS payment_date, p.currency_code, p.amount AS paid_amount, p.amount_aed AS paid_amount_aed, p.invoice_number, TO_CHAR(p.invoice_date,'YYYY-MM-DD') AS invoice_date, p.invoice_supplier, p.invoice_amount, p.invoice_currency, ROUND(NVL(p.invoice_amount,0) - p.amount, 2) AS difference, p.amount_mismatch, lu.display_name AS linked_by, TO_CHAR(prod.dct_to_local(p.invoice_linked_on),'YYYY-MM-DD HH'||CHR(58)||'MI AM') AS linked_on, ROUND(p.invoice_linked_on - p.processed_on) AS days_to_invoice FROM prod.dct_ap_procash p LEFT JOIN prod.dct_users lu ON lu.user_id = p.invoice_linked_by WHERE p.invoice_id IS NOT NULL AND!'
        || l_flt || q'! ORDER BY p.invoice_linked_on DESC!';

  l_exc := q'!SELECT reason, payment_number, bank_reference, business_unit, payee, payment_date, status, currency_code, amount, amount_aed, detail, days_open FROM (SELECT 'Lines do not add up to the header' AS reason, p.payment_number, p.bank_reference, p.business_unit, NVL(p.payee_name, p.supplier_name) AS payee, TO_CHAR(p.payment_date,'YYYY-MM-DD') AS payment_date, p.status, p.currency_code, p.amount, p.amount_aed, 'lines '||TO_CHAR(NVL((SELECT SUM(l.amount) FROM prod.dct_ap_procash_line l WHERE l.procash_id = p.procash_id),0),'FM999999999990.00')||' vs header '||TO_CHAR(p.amount,'FM999999999990.00') AS detail, TRUNC(SYSDATE) - TRUNC(p.payment_date) AS days_open FROM prod.dct_ap_procash p WHERE p.status NOT IN ('CANCELLED','REJECTED') AND ABS(p.amount - NVL((SELECT SUM(l.amount) FROM prod.dct_ap_procash_line l WHERE l.procash_id = p.procash_id),0)) > 0.005 AND!'
        || l_flt
        || q'! UNION ALL SELECT 'Paid but no Fusion invoice yet', p.payment_number, p.bank_reference, p.business_unit, NVL(p.payee_name, p.supplier_name), TO_CHAR(p.payment_date,'YYYY-MM-DD'), p.status, p.currency_code, p.amount, p.amount_aed, 'processed '||TO_CHAR(prod.dct_to_local(p.processed_on),'YYYY-MM-DD'), TRUNC(SYSDATE) - TRUNC(CAST(p.processed_on AS DATE)) FROM prod.dct_ap_procash p WHERE p.status = 'PROCESSED' AND p.invoice_id IS NULL AND!'
        || l_flt
        || q'! UNION ALL SELECT 'Invoice amount differs from the payment', p.payment_number, p.bank_reference, p.business_unit, NVL(p.payee_name, p.supplier_name), TO_CHAR(p.payment_date,'YYYY-MM-DD'), p.status, p.currency_code, p.amount, p.amount_aed, 'invoice '||p.invoice_number||' = '||TO_CHAR(p.invoice_amount,'FM999999999990.00'), TRUNC(SYSDATE) - TRUNC(p.payment_date) FROM prod.dct_ap_procash p WHERE p.amount_mismatch = 'Y' AND!'
        || l_flt || q'!) ORDER BY days_open DESC, payment_number!';

  l_src := '{"required":[],'
        || '"sections":['
        || '{"key":"summary","title":"Summary by status","layout":"table","sql":"' || l_sum || '"}' || ','
        || '{"key":"register","title":"Procash register","layout":"table","sql":"' || l_reg || '"}' || ','
        || '{"key":"lines","title":"Detail lines","layout":"table","sql":"' || l_lin || '"}' || ','
        || '{"key":"invoices","title":"Invoice reconciliation","layout":"table","sql":"' || l_inv || '"}' || ','
        || '{"key":"exceptions","title":"Exceptions","layout":"table","sql":"' || l_exc || '"}'
        || ']}';
  l_src := REPLACE(l_src, '[COLON]', CHR(58));

  l_spec := '{'
    || '"status":{"label":"Status","label_ar":UNQ1,"hint":"Pipe separated for any-of, e.g. DRAFT|PROCESSED. Blank = every status.","required":false},'
    || '"bu":{"label":"Business unit","label_ar":UNQ2,"hint":"Blank = every business unit","required":false,'
    || '"lov_sql":"SELECT business_unit AS d, business_unit AS r FROM prod.ap_invoices_header_v WHERE business_unit IS NOT NULL GROUP BY business_unit ORDER BY 1"},'
    || '"datefrom":{"label":"Payment date from","label_ar":UNQ3,"hint":"YYYY-MM-DD","required":false},'
    || '"dateto":{"label":"Payment date to","label_ar":UNQ4,"hint":"YYYY-MM-DD","required":false},'
    || '"search":{"label":"Search","label_ar":UNQ5,"hint":"Matches bank reference, payment number, payee or description","required":false}'
    || '}';
  l_spec := REPLACE(l_spec, 'UNQ1', '"' || UNISTR('\0627\0644\062D\0627\0644\0629') || '"');
  l_spec := REPLACE(l_spec, 'UNQ2', '"' || UNISTR('\0648\062D\062F\0629 \0627\0644\0623\0639\0645\0627\0644') || '"');
  l_spec := REPLACE(l_spec, 'UNQ3', '"' || UNISTR('\062A\0627\0631\064A\062E \0627\0644\062F\0641\0639 \0645\0646') || '"');
  l_spec := REPLACE(l_spec, 'UNQ4', '"' || UNISTR('\062A\0627\0631\064A\062E \0627\0644\062F\0641\0639 \0625\0644\0649') || '"');
  l_spec := REPLACE(l_spec, 'UNQ5', '"' || UNISTR('\0628\062D\062B') || '"');

  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>Procash Transactions Register</strong> is attached: every manual payment '||
    'pushed through the bank portal directly, with its budget coding, its Fusion payable '||
    'invoice where one has been linked, and the exceptions still open ({{ row_count }} rows).</p>'||
    '<p>Prepared by Financial Planning and Budgeting, Finance Department. '||
    'Generated {{ generated_at }} by i-Finance Reporting.</p>';

  l_desc := 'Manual payments pushed through the bank portal directly, outside Fusion Payables: '||
    'a summary by status, the payment register, every detail line with its project or GL coding, '||
    'the reconciliation against the Fusion payable invoice, and the open exceptions (lines that '||
    'do not add up, payments still awaiting their invoice, and invoices whose amount differs from '||
    'what was paid). Excel = sheet per section; PDF = executive book (procash_book.html.j2). '||
    'Parameters mirror the page filters: status, business unit, payment date range and search.';

  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_definition WHERE report_code = 'PROCASH_REGISTER';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_definition
      (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
       default_formats, pdf_template, email_subject_tpl, email_body_tpl, params_json,
       param_spec_json, enabled, created_by, updated_by)
    VALUES
      ('PROCASH_REGISTER',
       'Procash Transactions Register',
       UNISTR('\0633\062C\0644 \0645\0639\0627\0645\0644\0627\062A \0627\0644\062F\0641\0639 \0627\0644\0645\0628\0627\0634\0631'),
       l_desc,
       'Accounts Payable', 'MULTI', l_src, 'PYTHON', 'XLSX',
       'procash_book.html.j2',
       'Procash Transactions Register',
       l_body,
       '{}',
       l_spec,
       'Y', 'SETUP', 'SETUP');
  ELSE
    UPDATE prod.dct_rpt_definition SET
       source_type       = 'MULTI',
       description       = l_desc,
       source_ref        = l_src,
       engine            = 'PYTHON',
       default_formats   = 'XLSX',
       pdf_template      = 'procash_book.html.j2',
       email_subject_tpl = 'Procash Transactions Register',
       email_body_tpl    = l_body,
       params_json       = '{}',
       param_spec_json   = l_spec,
       updated_by        = 'SETUP',
       updated_at        = SYSTIMESTAMP
     WHERE report_code = 'PROCASH_REGISTER';
  END IF;

  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_recipient
   WHERE report_code = 'PROCASH_REGISTER' AND recipient_type = 'SELF';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_recipient
      (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
    VALUES ('PROCASH_REGISTER', 'SELF', NULL, 'EMAIL', 'Y', 'SETUP', 'SETUP');
  END IF;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('PROCASH_REGISTER seeded (definition + SELF recipient).');
END;
/

PROMPT === 2. Verify ===
SELECT report_code, source_type, engine, default_formats, pdf_template,
       CASE WHEN source_ref IS JSON THEN 'SRC OK' ELSE 'SRC BAD' END AS src_ok,
       CASE WHEN param_spec_json IS JSON THEN 'SPEC OK' ELSE 'SPEC BAD' END AS spec_ok
FROM prod.dct_rpt_definition
WHERE report_code = 'PROCASH_REGISTER';

PROMPT ============================================================
PROMPT  37_rpt_procash_register.sql complete (PROCASH_REGISTER).
PROMPT ============================================================
