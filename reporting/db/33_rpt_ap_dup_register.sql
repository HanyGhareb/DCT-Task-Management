-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 33 AP Duplicate Vendors Register/Book
-- File   : reporting/db/33_rpt_ap_dup_register.sql
-- Seeds  : AP_BENEF_DUP_REGISTER -- the AP AI Duplicate Check results as a
--          formal report, run from the AP app's AI Duplicate Check page
--          (bridge = final apps/AP/db/07). ONE definition, TWO formats:
--          XLSX (sheet per section, full invoice detail) and PDF (custom
--          template ap_dup_book.html.j2, DB-stored via /rpt/templates).
--          Sections (lock-step with DCT_AP_AI_PKG, AP/db/06):
--            1. overview        -- the latest persisted AI run's header
--            2. groups          -- AI duplicate groups at member grain
--            3. group_invoices  -- every invoice behind the group members
--            4. shared_accounts -- same bank account, different vendors
--                                  (deterministic, platform-wide, vendor grain)
--            5. shared_invoices -- every invoice behind the shared accounts
-- Params : suppnum (optional, default 26553 -- the generic BENEFICIARY
--          supplier whose population the AI run analysed)
-- Deploy : SQLcl (sql -name prod, JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8) or
--          python-oracledb. Idempotent; count-then-insert/update (no MERGE).
-- NOTE   : TO_CHAR time masks use 'HH'||CHR(58)||'MI AM' -- a literal colon in
--          a section SQL becomes a phantom bind in the python datasource.
-- CRLF-safe. Zero blank lines inside statements.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. AP_BENEF_DUP_REGISTER definition (MULTI, 5 sections, XLSX+PDF) ===
DECLARE
  l_run  VARCHAR2(400);
  l_inv  VARCHAR2(4000);
  l_ov   VARCHAR2(4000);
  l_grp  VARCHAR2(4000);
  l_ginv VARCHAR2(4000);
  l_sav  VARCHAR2(8000);
  l_sinv VARCHAR2(8000);
  l_src  CLOB;
  l_body CLOB;
  l_spec CLOB;
  l_desc VARCHAR2(1000);
  l_n    NUMBER;
BEGIN
  l_run := q'!(SELECT MAX(run_id) FROM prod.dct_ap_ai_dup_run WHERE suppnum = NVL([COLON]suppnum,'26553'))!';
  l_inv := q'!SELECT UPPER(REGEXP_REPLACE(n.bank_account_number,'[^A-Za-z0-9]','')) bank_key, MIN(n.bank_account_number) bank_raw, CASE WHEN h.supplier_name = 'BENEFICIARY' AND h.beneficiary_name IS NOT NULL THEN h.beneficiary_name ELSE h.supplier_name END nm, MAX(h.supplier_number) suppno, MAX(h.supplier_site) site, h.invoice_id, MAX(NVL(h.invoice_amount_aed,0)) amt, MAX(h.invoice_date) inv_dt FROM prod.ap_invoice_installments n JOIN prod.ap_invoices_header_v h ON h.invoice_id = n.invoice_id WHERE n.bank_account_number IS NOT NULL AND LENGTH(REGEXP_REPLACE(n.bank_account_number,'[^A-Za-z0-9]','')) >= 6 GROUP BY UPPER(REGEXP_REPLACE(n.bank_account_number,'[^A-Za-z0-9]','')), CASE WHEN h.supplier_name = 'BENEFICIARY' AND h.beneficiary_name IS NOT NULL THEN h.beneficiary_name ELSE h.supplier_name END, h.invoice_id!';
  l_ov := q'!SELECT r.run_id, r.suppnum, r.analyzed, r.group_count, r.shared_count, (SELECT COUNT(*) FROM prod.dct_ap_ai_dup_member m WHERE m.run_id = r.run_id) AS member_names, r.provider, r.model, TO_CHAR(prod.dct_to_local(r.created_at), 'YYYY-MM-DD HH'||CHR(58)||'MI AM') AS ran_at, r.created_by AS ran_by FROM prod.dct_ap_ai_dup_run r WHERE r.run_id = !' || l_run;
  l_grp := q'!SELECT g.group_no, g.canonical, g.confidence, g.reason, m.member_no, m.name AS member_name, m.site AS supplier_site, m.bank_accounts, m.invoices, m.total_aed, m.first_invoice, m.last_invoice FROM prod.dct_ap_ai_dup_group g JOIN prod.dct_ap_ai_dup_member m ON m.run_id = g.run_id AND m.group_no = g.group_no WHERE g.run_id = !' || l_run
        || q'! ORDER BY g.group_no, m.member_no!';
  l_ginv := q'!SELECT m.group_no, g.canonical, m.name AS vendor_name, h.invoice_number, h.invoice_date, h.invoice_type, h.invoice_status, h.validation_status, h.payment_status, h.supplier_site, h.business_unit, NVL(h.invoice_amount_aed,0) AS amount_aed FROM prod.dct_ap_ai_dup_member m JOIN prod.dct_ap_ai_dup_group g ON g.run_id = m.run_id AND g.group_no = m.group_no JOIN prod.ap_invoices_header_v h ON h.supplier_number = NVL([COLON]suppnum,'26553') AND (CASE WHEN h.supplier_name = 'BENEFICIARY' AND h.beneficiary_name IS NOT NULL THEN h.beneficiary_name ELSE h.supplier_name END) = m.name WHERE m.run_id = !' || l_run
        || q'! ORDER BY m.group_no, m.member_no, h.invoice_date!';
  l_sav := q'!SELECT bank_account, vendor_count, account_invoices, account_total_aed, vendor_name, supplier_number, supplier_site, invoices, amount_aed, first_invoice, last_invoice FROM (SELECT va.bank AS bank_account, va.nm AS vendor_name, va.suppno AS supplier_number, va.site AS supplier_site, va.invs AS invoices, va.amt AS amount_aed, va.dt_first AS first_invoice, va.dt_last AS last_invoice, COUNT(*) OVER (PARTITION BY va.bank_key) AS vendor_count, SUM(va.invs) OVER (PARTITION BY va.bank_key) AS account_invoices, ROUND(SUM(va.amt) OVER (PARTITION BY va.bank_key), 2) AS account_total_aed FROM (SELECT inv.bank_key, MIN(inv.bank_raw) bank, inv.nm, MAX(inv.suppno) suppno, MAX(inv.site) site, COUNT(*) invs, ROUND(SUM(inv.amt), 2) amt, TO_CHAR(MIN(inv.inv_dt), 'YYYY-MM-DD') dt_first, TO_CHAR(MAX(inv.inv_dt), 'YYYY-MM-DD') dt_last FROM (!'
        || l_inv || q'!) inv GROUP BY inv.bank_key, inv.nm) va) WHERE vendor_count >= 2 ORDER BY vendor_count DESC, account_total_aed DESC, bank_account, amount_aed DESC!';
  l_sinv := q'!SELECT i.bank_raw AS bank_account, i.nm AS vendor_name, i.suppno AS supplier_number, h2.invoice_number, h2.invoice_date, NVL(h2.invoice_amount_aed,0) AS amount_aed, h2.payment_status, h2.invoice_status, h2.business_unit FROM (!'
        || l_inv || q'!) i JOIN prod.ap_invoices_header_v h2 ON h2.invoice_id = i.invoice_id WHERE i.bank_key IN (SELECT s.bank_key FROM (!'
        || l_inv || q'!) s GROUP BY s.bank_key HAVING COUNT(DISTINCT s.nm) >= 2) ORDER BY i.bank_raw, i.nm, h2.invoice_date!';
  l_src := '{"required":[],'
        || '"sections":['
        || '{"key":"overview","title":"AI Run Overview","layout":"table","sql":"' || l_ov || '"}' || ','
        || '{"key":"groups","title":"Duplicate Groups","layout":"table","sql":"' || l_grp || '"}' || ','
        || '{"key":"group_invoices","title":"Duplicate Group Invoices","layout":"table","sql":"' || l_ginv || '"}' || ','
        || '{"key":"shared_accounts","title":"Shared Bank Accounts","layout":"table","sql":"' || l_sav || '"}' || ','
        || '{"key":"shared_invoices","title":"Shared Account Invoices","layout":"table","sql":"' || l_sinv || '"}'
        || ']}';
  l_src := REPLACE(l_src, '[COLON]', CHR(58));
  l_spec := '{'
    || '"suppnum":{"label":"Generic supplier number","label_ar":UNQ1,"hint":"The generic BENEFICIARY supplier whose AI run to report (default 26553)","required":false}'
    || '}';
  l_spec := REPLACE(l_spec, 'UNQ1', '"' || UNISTR('\0631\0642\0645 \0627\0644\0645\0648\0631\062F \0627\0644\0639\0627\0645') || '"');
  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>AP Duplicate Vendors Register</strong> is attached: the latest AI '||
    'duplicate-beneficiary analysis (groups and their invoices) plus the shared-bank-account '||
    'red-flag check (the same vendor bank account paid under different vendor names, '||
    'checked platform-wide), with full invoice detail ({{ row_count }} rows).</p>'||
    '<p>Prepared by Financial Planning and Budgeting, Finance Department. '||
    'Generated {{ generated_at }} by i-Finance Reporting.</p>';
  l_desc := 'AP AI Duplicate Check results as a formal report: the latest persisted AI run''s duplicate-beneficiary groups (name variants clustered with vendor bank accounts as same-identity evidence) with every invoice behind them, plus the deterministic shared-bank-account red-flag check (same account, different vendors, platform-wide across all suppliers) with its invoice detail. Excel = sheet per section (full detail); PDF = executive book (template ap_dup_book.html.j2). Parameter: suppnum (default 26553).';
  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_definition
   WHERE report_code = 'AP_BENEF_DUP_REGISTER';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_definition
      (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
       default_formats, pdf_template, email_subject_tpl, email_body_tpl, params_json,
       param_spec_json, enabled, created_by, updated_by)
    VALUES
      ('AP_BENEF_DUP_REGISTER',
       'AP Duplicate Vendors Register',
       UNISTR('\0633\062C\0644 \0627\0644\0645\0648\0631\062F\064A\0646 \0627\0644\0645\0643\0631\0631\064A\0646 \0644\0644\0630\0645\0645 \0627\0644\062F\0627\0626\0646\0629'),
       l_desc,
       'Accounts Payable', 'MULTI', l_src, 'PYTHON', 'XLSX',
       'ap_dup_book.html.j2',
       'AP Duplicate Vendors Register - run {{ params.suppnum }}',
       l_body,
       '{"suppnum":"26553"}',
       l_spec,
       'Y', 'SETUP', 'SETUP');
  ELSE
    UPDATE prod.dct_rpt_definition SET
       source_type       = 'MULTI',
       description       = l_desc,
       source_ref        = l_src,
       engine            = 'PYTHON',
       default_formats   = 'XLSX',
       pdf_template      = 'ap_dup_book.html.j2',
       email_subject_tpl = 'AP Duplicate Vendors Register - run {{ params.suppnum }}',
       email_body_tpl    = l_body,
       params_json       = '{"suppnum":"26553"}',
       param_spec_json   = l_spec,
       updated_by        = 'SETUP',
       updated_at        = SYSTIMESTAMP
     WHERE report_code = 'AP_BENEF_DUP_REGISTER';
  END IF;
  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_recipient
   WHERE report_code = 'AP_BENEF_DUP_REGISTER' AND recipient_type = 'SELF';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_recipient
      (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
    VALUES
      ('AP_BENEF_DUP_REGISTER', 'SELF', NULL, 'EMAIL', 'Y', 'SETUP', 'SETUP');
  END IF;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('AP_BENEF_DUP_REGISTER seeded (definition + SELF recipient).');
END;
/

PROMPT === 2. Verify ===
SELECT report_code, source_type, engine, default_formats, pdf_template,
       CASE WHEN source_ref IS JSON THEN 'SRC OK' ELSE 'SRC BAD' END AS src_ok,
       CASE WHEN param_spec_json IS JSON THEN 'SPEC OK' ELSE 'SPEC BAD' END AS spec_ok
FROM prod.dct_rpt_definition
WHERE report_code = 'AP_BENEF_DUP_REGISTER';

PROMPT ============================================================
PROMPT  33_rpt_ap_dup_register.sql complete (AP_BENEF_DUP_REGISTER).
PROMPT ============================================================
