-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 38 Direct AP Briefing Book (Excel)
-- File   : reporting/db/38_rpt_ap_direct_register.sql
-- Seeds  : AP_DIRECT_REGISTER -- AP invoices with NO PO reference and NO
--          project coding anywhere (header_po_number IS NULL AND po_count = 0
--          AND project_count = 0 on prod.ap_invoices_header_v -- the same rule
--          as the Direct AP page's nopo=Y facet in dct_ap_pkg.filtered_ids).
--          Run from the AP app's Direct AP page (bridge = final apps/AP/db/14).
--          XLSX ONLY (sheet per section) -- no PDF template is authored, the
--          bridge rejects any other format.
--          Sections (lock-step with the page figures):
--            1. overview   -- one row per payment status: count, AED totals
--            2. register   -- the direct-invoice header register
--            3. suppliers  -- by effective supplier (beneficiary-aware)
--            4. coding     -- GL coding of the non-tax distributions
--            5. aging      -- unpaid balance by aging bucket (due-date basis)
-- Params : bu, supplier, paid, val, chapter, datefrom, dateto, search,
--          inclcxl -- all optional, pipe-delimited multi where the page facet
--          is multi, so the book scope IS the page scope (chapter = the
--          per-invoice classification bucket, like the page facet). The
--          direct rule itself is HARD CODED in every section -- it is the
--          report's identity, not a param (incl. pr_count = 0: verified 0
--          rows 2026-08-21, kept as a guard -- no PR without a PO).
-- Deploy : SQLcl (sql -name prod_mcp, JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8)
--          or python-oracledb. Idempotent; count-then-insert/update (no MERGE).
-- CRLF-safe. Zero blank lines inside statements.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. AP_DIRECT_REGISTER definition (MULTI, 5 sections, XLSX) ===
DECLARE
  l_flt  VARCHAR2(2000);
  l_ovr  VARCHAR2(4000);
  l_reg  VARCHAR2(8000);
  l_sup  VARCHAR2(4000);
  l_cod  VARCHAR2(4000);
  l_age  VARCHAR2(4000);
  l_src  CLOB;
  l_body CLOB;
  l_spec CLOB;
  l_desc VARCHAR2(1000);
  l_n    NUMBER;
BEGIN
  l_flt := q'! h.header_po_number IS NULL AND h.po_count = 0 AND h.project_count = 0 AND h.pr_count = 0 AND h.invoice_id NOT IN (SELECT lx.invoice_id FROM prod.ap_invoice_lines lx WHERE lx.po_number IS NOT NULL OR lx.project_number IS NOT NULL) AND ([COLON]chapter IS NULL OR h.invoice_id IN (SELECT dc.invoice_id FROM (SELECT d2.invoice_id, CASE WHEN COUNT(DISTINCT NVL(d2.chapter_name,'Unclassified')) > 1 THEN '(Multiple chapters)' ELSE MAX(NVL(d2.chapter_name,'Unclassified')) END chap FROM prod.ap_invoice_distributions_v d2 WHERE d2.distribution_type NOT IN ('Recoverable tax','Nonrecoverable tax') GROUP BY d2.invoice_id) dc WHERE INSTR('|'||[COLON]chapter||'|','|'||dc.chap||'|') > 0) OR (INSTR('|'||[COLON]chapter||'|','|Unclassified|') > 0 AND h.invoice_id NOT IN (SELECT d3.invoice_id FROM prod.ap_invoice_distributions_v d3 WHERE d3.distribution_type NOT IN ('Recoverable tax','Nonrecoverable tax')))) AND ([COLON]inclcxl IS NULL OR [COLON]inclcxl = 'Y' OR h.invoice_status <> 'Cancelled') AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|','|'||h.business_unit||'|') > 0) AND ([COLON]supplier IS NULL OR INSTR('|'||[COLON]supplier||'|','|'||h.supplier_name||'|') > 0) AND ([COLON]paid IS NULL OR INSTR('|'||[COLON]paid||'|','|'||h.payment_status||'|') > 0) AND ([COLON]val IS NULL OR INSTR('|'||[COLON]val||'|','|'||h.validation_status||'|') > 0) AND ([COLON]datefrom IS NULL OR h.invoice_date >= TO_DATE([COLON]datefrom,'YYYY-MM-DD')) AND ([COLON]dateto IS NULL OR h.invoice_date < TO_DATE([COLON]dateto,'YYYY-MM-DD') + 1) AND ([COLON]search IS NULL OR UPPER(h.invoice_number||' '||h.supplier_name||' '||NVL(h.beneficiary_name,' ')||' '||NVL(h.invoice_description,' ')) LIKE '%'||UPPER([COLON]search)||'%')!';

  l_ovr := q'!SELECT h.payment_status, COUNT(*) AS invoices, COUNT(DISTINCT CASE WHEN h.supplier_name = 'BENEFICIARY' AND h.beneficiary_name IS NOT NULL THEN h.beneficiary_name ELSE h.supplier_name END) AS suppliers, ROUND(SUM(h.invoice_amount_aed),2) AS amount_aed, ROUND(SUM(NVL(h.amount_paid,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1)),2) AS paid_aed, ROUND(SUM(NVL(h.balance_due,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1)),2) AS balance_aed, COUNT(CASE WHEN h.invoice_status = 'Cancelled' THEN 1 END) AS cancelled FROM prod.ap_invoices_header_v h WHERE!'
        || l_flt || q'! GROUP BY h.payment_status ORDER BY 4 DESC!';

  l_reg := q'!SELECT h.invoice_number, TO_CHAR(h.invoice_date,'YYYY-MM-DD') AS invoice_date, h.invoice_type, CASE WHEN h.supplier_name = 'BENEFICIARY' AND h.beneficiary_name IS NOT NULL THEN h.beneficiary_name ELSE h.supplier_name END AS supplier, h.supplier_number, h.supplier_site, h.business_unit, h.invoice_description, h.invoice_currency, h.invoice_amount, h.invoice_amount_aed, NVL(h.amount_paid,0) AS amount_paid, ROUND(NVL(h.balance_due,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1),2) AS balance_aed, h.validation_status, h.accounting_status, h.payment_status, h.approval_status, h.funds_status, h.invoice_status, TO_CHAR(h.due_date,'YYYY-MM-DD') AS due_date, CASE WHEN h.payment_status = 'Unpaid' AND NVL(h.balance_due,0) > 0 THEN GREATEST(TRUNC(SYSDATE) - h.due_date, 0) END AS days_past_due, h.payment_terms, h.pay_group, h.payment_method, TO_CHAR(h.gl_date,'YYYY-MM-DD') AS gl_date, TO_CHAR(h.invoice_received_date,'YYYY-MM-DD') AS received_date, h.voucher_num, h.invoice_source, h.line_count, h.distribution_count FROM prod.ap_invoices_header_v h WHERE!'
        || l_flt || q'! ORDER BY h.invoice_date DESC, h.invoice_id DESC!';

  l_sup := q'!SELECT CASE WHEN h.supplier_name = 'BENEFICIARY' AND h.beneficiary_name IS NOT NULL THEN h.beneficiary_name ELSE h.supplier_name END AS supplier, COUNT(*) AS invoices, ROUND(SUM(h.invoice_amount_aed),2) AS amount_aed, ROUND(SUM(NVL(h.amount_paid,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1)),2) AS paid_aed, ROUND(SUM(NVL(h.balance_due,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1)),2) AS balance_aed, TO_CHAR(MIN(h.invoice_date),'YYYY-MM-DD') AS first_invoice, TO_CHAR(MAX(h.invoice_date),'YYYY-MM-DD') AS last_invoice FROM prod.ap_invoices_header_v h WHERE!'
        || l_flt || q'! GROUP BY CASE WHEN h.supplier_name = 'BENEFICIARY' AND h.beneficiary_name IS NOT NULL THEN h.beneficiary_name ELSE h.supplier_name END ORDER BY 3 DESC!';

  l_cod := q'!SELECT d.account_code, d.account_desc, d.cost_center_code, d.cost_center_desc, NVL(d.sector_name,'Unclassified') AS sector, d.appropriation_code, d.appropriation_desc, COUNT(DISTINCT d.invoice_id) AS invoices, COUNT(*) AS distributions, ROUND(SUM(d.distribution_amount_aed),2) AS amount_aed FROM prod.ap_invoice_distributions_v d JOIN prod.ap_invoices_header_v h ON h.invoice_id = d.invoice_id WHERE d.distribution_type NOT IN ('Recoverable tax','Nonrecoverable tax') AND!'
        || l_flt || q'! GROUP BY d.account_code, d.account_desc, d.cost_center_code, d.cost_center_desc, NVL(d.sector_name,'Unclassified'), d.appropriation_code, d.appropriation_desc ORDER BY 10 DESC!';

  l_age := q'!SELECT bucket, invoices, balance_aed FROM (SELECT CASE WHEN h.due_date >= TRUNC(SYSDATE) THEN '1. Current' WHEN TRUNC(SYSDATE) - h.due_date <= 30 THEN '2. 1-30 days' WHEN TRUNC(SYSDATE) - h.due_date <= 60 THEN '3. 31-60 days' WHEN TRUNC(SYSDATE) - h.due_date <= 90 THEN '4. 61-90 days' WHEN TRUNC(SYSDATE) - h.due_date <= 180 THEN '5. 91-180 days' ELSE '6. Over 180 days' END AS bucket, COUNT(*) AS invoices, ROUND(SUM(NVL(h.balance_due,0) * NVL(h.invoice_amount_aed / NULLIF(h.invoice_amount,0),1)),2) AS balance_aed FROM prod.ap_invoices_header_v h WHERE h.payment_status = 'Unpaid' AND NVL(h.balance_due,0) <> 0 AND!'
        || l_flt || q'! GROUP BY CASE WHEN h.due_date >= TRUNC(SYSDATE) THEN '1. Current' WHEN TRUNC(SYSDATE) - h.due_date <= 30 THEN '2. 1-30 days' WHEN TRUNC(SYSDATE) - h.due_date <= 60 THEN '3. 31-60 days' WHEN TRUNC(SYSDATE) - h.due_date <= 90 THEN '4. 61-90 days' WHEN TRUNC(SYSDATE) - h.due_date <= 180 THEN '5. 91-180 days' ELSE '6. Over 180 days' END) ORDER BY bucket!';

  l_src := '{"required":[],'
        || '"sections":['
        || '{"key":"overview","title":"Overview by payment status","layout":"table","sql":"' || l_ovr || '"}' || ','
        || '{"key":"register","title":"Direct invoices register","layout":"table","sql":"' || l_reg || '"}' || ','
        || '{"key":"suppliers","title":"By supplier","layout":"table","sql":"' || l_sup || '"}' || ','
        || '{"key":"coding","title":"GL coding (non-tax distributions)","layout":"table","sql":"' || l_cod || '"}' || ','
        || '{"key":"aging","title":"Aging of unpaid balance","layout":"table","sql":"' || l_age || '"}'
        || ']}';
  l_src := REPLACE(l_src, '[COLON]', CHR(58));

  l_spec := '{'
    || '"bu":{"label":"Business unit","label_ar":UNQ1,"hint":"Pipe separated for any-of. Blank = every business unit","required":false,'
    || '"lov_sql":"SELECT business_unit AS d, business_unit AS r FROM prod.ap_invoices_header_v WHERE business_unit IS NOT NULL GROUP BY business_unit ORDER BY 1"},'
    || '"supplier":{"label":"Supplier","label_ar":UNQ2,"hint":"Raw supplier name(s), pipe separated for any-of","required":false},'
    || '"paid":{"label":"Payment status","label_ar":UNQ3,"hint":"Paid|Partially Paid|Unpaid, pipe separated","required":false},'
    || '"val":{"label":"Validation status","label_ar":UNQ4,"hint":"Pipe separated for any-of","required":false},'
    || '"chapter":{"label":"Chapter","label_ar":UNQ9,"hint":"Per-invoice chapter classification: chapter name, (Multiple chapters) or Unclassified; pipe separated for any-of","required":false},'
    || '"datefrom":{"label":"Invoice date from","label_ar":UNQ5,"hint":"YYYY-MM-DD","required":false},'
    || '"dateto":{"label":"Invoice date to","label_ar":UNQ6,"hint":"YYYY-MM-DD","required":false},'
    || '"search":{"label":"Search","label_ar":UNQ7,"hint":"Matches invoice number, supplier, beneficiary or description","required":false},'
    || '"inclcxl":{"label":"Include cancelled","label_ar":UNQ8,"hint":"Y = include cancelled invoices (default excluded)","required":false}'
    || '}';
  l_spec := REPLACE(l_spec, 'UNQ1', '"' || UNISTR('\0648\062D\062F\0629 \0627\0644\0623\0639\0645\0627\0644') || '"');
  l_spec := REPLACE(l_spec, 'UNQ2', '"' || UNISTR('\0627\0644\0645\0648\0631\062F') || '"');
  l_spec := REPLACE(l_spec, 'UNQ3', '"' || UNISTR('\062D\0627\0644\0629 \0627\0644\062F\0641\0639') || '"');
  l_spec := REPLACE(l_spec, 'UNQ4', '"' || UNISTR('\062D\0627\0644\0629 \0627\0644\062A\062F\0642\064A\0642') || '"');
  l_spec := REPLACE(l_spec, 'UNQ5', '"' || UNISTR('\062A\0627\0631\064A\062E \0627\0644\0641\0627\062A\0648\0631\0629 \0645\0646') || '"');
  l_spec := REPLACE(l_spec, 'UNQ6', '"' || UNISTR('\062A\0627\0631\064A\062E \0627\0644\0641\0627\062A\0648\0631\0629 \0625\0644\0649') || '"');
  l_spec := REPLACE(l_spec, 'UNQ7', '"' || UNISTR('\0628\062D\062B') || '"');
  l_spec := REPLACE(l_spec, 'UNQ8', '"' || UNISTR('\062A\0636\0645\064A\0646 \0627\0644\0645\0644\063A\0627\0629') || '"');
  l_spec := REPLACE(l_spec, 'UNQ9', '"' || UNISTR('\0627\0644\0628\0627\0628') || '"');

  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>Direct AP Briefing Book</strong> is attached: every AP invoice with '||
    'no purchase-order reference and no project coding, with the payment overview, the '||
    'full register, the supplier breakdown, the GL coding of the distributions and the '||
    'aging of the unpaid balance ({{ row_count }} rows).</p>'||
    '<p>Prepared by Financial Planning and Budgeting, Finance Department. '||
    'Generated {{ generated_at }} by i-Finance Reporting.</p>';

  l_desc := 'AP invoices with NO purchase-order reference and NO project coding anywhere '||
    '(direct expenses): overview by payment status, the full direct-invoice register, the '||
    'supplier breakdown (beneficiary-aware), the GL coding of their non-tax distributions '||
    'and the aging of the unpaid balance. Excel workbook, sheet per section. Parameters '||
    'mirror the Direct AP page filters: business unit, supplier, payment/validation status, '||
    'chapter, invoice date range, search and include-cancelled.';

  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_definition WHERE report_code = 'AP_DIRECT_REGISTER';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_definition
      (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
       default_formats, email_subject_tpl, email_body_tpl, params_json,
       param_spec_json, enabled, created_by, updated_by)
    VALUES
      ('AP_DIRECT_REGISTER',
       'Direct AP Briefing Book',
       UNISTR('\0643\062A\0627\0628 \0627\0644\0641\0648\0627\062A\064A\0631 \0627\0644\0645\0628\0627\0634\0631\0629'),
       l_desc,
       'Accounts Payable', 'MULTI', l_src, 'PYTHON', 'XLSX',
       'Direct AP Briefing Book',
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
       email_subject_tpl = 'Direct AP Briefing Book',
       email_body_tpl    = l_body,
       params_json       = '{}',
       param_spec_json   = l_spec,
       updated_by        = 'SETUP',
       updated_at        = SYSTIMESTAMP
     WHERE report_code = 'AP_DIRECT_REGISTER';
  END IF;

  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_recipient
   WHERE report_code = 'AP_DIRECT_REGISTER' AND recipient_type = 'SELF';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_recipient
      (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
    VALUES ('AP_DIRECT_REGISTER', 'SELF', NULL, 'EMAIL', 'Y', 'SETUP', 'SETUP');
  END IF;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('AP_DIRECT_REGISTER seeded (definition + SELF recipient).');
END;
/

PROMPT === 2. Verify ===
SELECT report_code, source_type, engine, default_formats,
       CASE WHEN source_ref IS JSON THEN 'SRC OK' ELSE 'SRC BAD' END AS src_ok,
       CASE WHEN param_spec_json IS JSON THEN 'SPEC OK' ELSE 'SPEC BAD' END AS spec_ok
FROM prod.dct_rpt_definition
WHERE report_code = 'AP_DIRECT_REGISTER';

PROMPT ============================================================
PROMPT  38_rpt_ap_direct_register.sql complete (AP_DIRECT_REGISTER).
PROMPT ============================================================
