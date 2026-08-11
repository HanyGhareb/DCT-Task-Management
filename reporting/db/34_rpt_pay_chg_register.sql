-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 34 PAY Employee Change Register pack
-- File   : reporting/db/34_rpt_pay_chg_register.sql
-- Seeds  : PAY_CHG_REGISTER -- the Outsource Payroll change-control register
--          (final apps/PAY/db/19+21) as a formal monthly pack, run from the
--          PAY app's Employee Changes page (bridge in PAY/db/20) and
--          auto-enqueued when a register reaches CONFIRMED (CHG_REPORT_AUTO).
--          ONE definition, TWO formats: XLSX (sheet per section, full
--          detail incl. the whole snapshot) and PDF (custom template
--          pay_chg_book.html.j2, DB-stored via /rpt/templates).
--          Sections (lock-step with DCT_PAY_CHG_PKG):
--            1. overview   -- register head, counts, sign-off trail
--            2. changes    -- every confirmable finding w/ old/new/flags/notes
--            3. new_hires  -- joiners with their gross impact
--            4. exits      -- leavers with their gross impact
--            5. snapshot   -- the full per-attribute snapshot (XLSX only;
--                             the PDF template deliberately skips it)
-- Params : registerid (REQUIRED -- a DCT_PAY_CHG_REGISTER id)
-- Deploy : SQLcl (sql -name prod_mcp, JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8).
--          Idempotent; count-then-insert/update (no MERGE -- Linux SQLcl safe).
-- NOTE   : TO_CHAR time masks use 'HH'||CHR(58)||'MI AM' -- a literal colon in
--          a section SQL becomes a phantom bind in the python datasource.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. PAY_CHG_REGISTER definition (MULTI, 5 sections, XLSX+PDF) ===
DECLARE
  l_ov   VARCHAR2(4000);
  l_chg  VARCHAR2(4000);
  l_nh   VARCHAR2(2000);
  l_ex   VARCHAR2(2000);
  l_snap VARCHAR2(1000);
  l_src  CLOB;
  l_body CLOB;
  l_spec CLOB;
  l_desc VARCHAR2(1000);
  l_n    NUMBER;
BEGIN
  l_ov := q'!SELECT p.payroll_code, p.name_en AS payroll_name, c.name_en AS company_name, pe.period_code, r.status, TO_CHAR(prod.dct_to_local(r.captured_at), 'YYYY-MM-DD HH'||CHR(58)||'MI AM') AS captured_at, r.captured_by, r.emp_count, r.change_count, (SELECT COUNT(*) FROM prod.dct_pay_chg_item i WHERE i.register_id = r.register_id AND i.change_kind = 'NEW_HIRE') AS new_hires, (SELECT COUNT(*) FROM prod.dct_pay_chg_item i WHERE i.register_id = r.register_id AND i.change_kind = 'EXIT') AS exits, (SELECT COUNT(*) FROM prod.dct_pay_chg_item i WHERE i.register_id = r.register_id AND i.flags IS NOT NULL) AS flagged, (SELECT NVL(SUM(CASE WHEN i.attr_code IN ('GROSS','EMPLOYEE') THEN i.delta END),0) FROM prod.dct_pay_chg_item i WHERE i.register_id = r.register_id) AS gross_impact, (SELECT pe2.period_code FROM prod.dct_pay_chg_register r2 JOIN prod.dct_pay_period pe2 ON pe2.period_id = r2.period_id WHERE r2.register_id = r.prior_register_id) AS prior_period, r.hr_done_by, TO_CHAR(prod.dct_to_local(r.hr_done_at), 'YYYY-MM-DD HH'||CHR(58)||'MI AM') AS hr_done_at, r.pay_done_by, TO_CHAR(prod.dct_to_local(r.pay_done_at), 'YYYY-MM-DD HH'||CHR(58)||'MI AM') AS pay_done_at FROM prod.dct_pay_chg_register r JOIN prod.dct_pay_payroll p ON p.payroll_id = r.payroll_id JOIN prod.dct_pay_company c ON c.company_id = p.company_id JOIN prod.dct_pay_period pe ON pe.period_id = r.period_id WHERE r.register_id = TO_NUMBER([COLON]registerid)!';
  l_chg := q'!SELECT i.employee_number, i.full_name, i.change_kind, i.attr_group, i.attr_code, i.old_value, i.new_value, i.delta, i.flags, i.note, (SELECT COUNT(*) FROM prod.dct_documents d WHERE d.source_module = 'PAY' AND d.source_type = 'PAY_CHANGE' AND d.source_id = i.item_id AND d.is_active = 'Y') AS evidence_docs, i.hr_status, i.hr_by, TO_CHAR(prod.dct_to_local(i.hr_at), 'YYYY-MM-DD HH'||CHR(58)||'MI AM') AS hr_at, i.pay_status, i.pay_by, TO_CHAR(prod.dct_to_local(i.pay_at), 'YYYY-MM-DD HH'||CHR(58)||'MI AM') AS pay_at FROM prod.dct_pay_chg_item i WHERE i.register_id = TO_NUMBER([COLON]registerid) ORDER BY i.full_name, i.person_id, CASE i.change_kind WHEN 'NEW_HIRE' THEN 1 WHEN 'EXIT' THEN 2 ELSE 3 END, i.attr_group, i.attr_code!';
  l_nh := q'!SELECT i.employee_number, i.full_name, i.new_value AS gross_salary, i.delta AS gross_impact, i.note, i.hr_status, i.pay_status FROM prod.dct_pay_chg_item i WHERE i.register_id = TO_NUMBER([COLON]registerid) AND i.change_kind = 'NEW_HIRE' ORDER BY i.full_name!';
  l_ex := q'!SELECT i.employee_number, i.full_name, i.old_value AS gross_salary, i.delta AS gross_impact, i.note, i.hr_status, i.pay_status FROM prod.dct_pay_chg_item i WHERE i.register_id = TO_NUMBER([COLON]registerid) AND i.change_kind = 'EXIT' ORDER BY i.full_name!';
  l_snap := q'!SELECT s.employee_number, s.full_name, s.attr_group, s.attr_code, s.attr_value FROM prod.dct_pay_chg_snap s WHERE s.register_id = TO_NUMBER([COLON]registerid) ORDER BY s.full_name, s.person_id, s.attr_group, s.attr_code!';
  l_src := '{"required":["registerid"],'
        || '"sections":['
        || '{"key":"overview","title":"Register Overview","layout":"table","sql":"' || l_ov || '"}' || ','
        || '{"key":"changes","title":"Change Register","layout":"table","sql":"' || l_chg || '"}' || ','
        || '{"key":"new_hires","title":"New Hires","layout":"table","sql":"' || l_nh || '"}' || ','
        || '{"key":"exits","title":"Exits","layout":"table","sql":"' || l_ex || '"}' || ','
        || '{"key":"snapshot","title":"Full Snapshot","layout":"table","sql":"' || l_snap || '"}'
        || ']}';
  l_src := REPLACE(l_src, '[COLON]', CHR(58));
  l_spec := '{'
    || '"registerid":{"label":"Change register id","label_ar":UNQ1,"hint":"DCT_PAY_CHG_REGISTER id (run from the PAY Employee Changes page)","required":true}'
    || '}';
  l_spec := REPLACE(l_spec, 'UNQ1', '"' || UNISTR('\0631\0642\0645 \0633\062C\0644 \0627\0644\062A\063A\064A\064A\0631\0627\062A') || '"');
  l_body :=
    '<p>Dear {{ recipient_name }},</p>'||
    '<p>The <strong>Employee Change Register</strong> pack is attached: every '||
    'payroll-relevant change of the period with previous and new values, the '||
    'variance flags, justification notes and the dual HR / Payroll confirmation '||
    'trail ({{ row_count }} rows).</p>'||
    '<p>Prepared by Financial Planning and Budgeting, Finance Department. '||
    'Generated {{ generated_at }} by i-Finance Reporting.</p>';
  l_desc := 'Outsource Payroll change-control register as a formal monthly pack: register overview with the dual sign-off trail, the full change register (old/new values, financial impact, variance flags, justification notes, evidence-document counts, per-item HR and Payroll confirmations), joiner and leaver annexes, and the complete point-in-time snapshot (Excel only). Runs from the PAY Employee Changes page and automatically when a register reaches CONFIRMED. Parameter: registerid (required).';

  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_definition
   WHERE report_code = 'PAY_CHG_REGISTER';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_definition
      (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
       default_formats, pdf_template, email_subject_tpl, email_body_tpl, params_json,
       param_spec_json, enabled, created_by, updated_by)
    VALUES
      ('PAY_CHG_REGISTER',
       'Employee Change Register Pack',
       UNISTR('\0633\062C\0644 \062A\063A\064A\064A\0631\0627\062A \0627\0644\0645\0648\0638\0641\064A\0646'),
       l_desc,
       'Outsource Payroll', 'MULTI', l_src, 'PYTHON', 'PDF',
       'pay_chg_book.html.j2',
       'Employee Change Register - register {{ params.registerid }}',
       l_body,
       '{"registerid":""}',
       l_spec,
       'Y', 'SETUP', 'SETUP');
  ELSE
    UPDATE prod.dct_rpt_definition SET
       source_type       = 'MULTI',
       description       = l_desc,
       source_ref        = l_src,
       engine            = 'PYTHON',
       default_formats   = 'PDF',
       pdf_template      = 'pay_chg_book.html.j2',
       email_subject_tpl = 'Employee Change Register - register {{ params.registerid }}',
       email_body_tpl    = l_body,
       params_json       = '{"registerid":""}',
       param_spec_json   = l_spec,
       updated_by        = 'SETUP',
       updated_at        = SYSTIMESTAMP
     WHERE report_code = 'PAY_CHG_REGISTER';
  END IF;

  SELECT COUNT(*) INTO l_n FROM prod.dct_rpt_recipient
   WHERE report_code = 'PAY_CHG_REGISTER' AND recipient_type = 'SELF';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_recipient
      (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
    VALUES
      ('PAY_CHG_REGISTER', 'SELF', NULL, 'EMAIL', 'Y', 'SETUP', 'SETUP');
  END IF;

  COMMIT;
  DBMS_OUTPUT.put_line('PAY_CHG_REGISTER seeded');
END;
/

PROMPT === 2. verification ===
SELECT report_code, source_type, engine, default_formats, pdf_template,
       CASE WHEN source_ref IS JSON THEN 'SRC OK' ELSE 'SRC BAD' END AS src_ok,
       CASE WHEN param_spec_json IS JSON THEN 'SPEC OK' ELSE 'SPEC BAD' END AS spec_ok
FROM prod.dct_rpt_definition
WHERE report_code = 'PAY_CHG_REGISTER';

EXIT
