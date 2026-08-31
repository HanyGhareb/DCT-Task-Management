-- =============================================================================
-- Procash Transactions -- ap.rest routes (ADDITIVE)
-- File    : 10_procash_ords.sql       App 212 / AP        2026-08-17
-- Adds to : ap.rest (does NOT delete or redefine the module)
-- Run     : sql -name prod_mcp @10_procash_ords.sql   (fresh session, as ADMIN)
-- IMPORTANT: 03_ap_ords.sql rebuilds ap.rest from scratch -- whenever 03 is
--           re-run, re-run 04, 06, 07 and THIS script right after it.
--
-- Routes (all behind dct_rest.validate_session; writes are role-checked inside
-- prod.dct_ap_procash_pkg, so handlers stay thin):
--   GET    procash/                     register, paged + filtered + totals
--   POST   procash                      create a header (+ optional lines)
--   GET    procash/[COLON]id                  header + lines + docs + history + findings
--   PUT    procash/[COLON]id                  partial update (absent key keeps stored value)
--   DELETE procash/[COLON]id                  remove a draft
--   POST   procash/[COLON]id/submit           draft -> submitted (or in approval)
--   POST   procash/[COLON]id/process          stamp processed by / on
--   POST   procash/[COLON]id/cancel           cancel
--   POST   procash/[COLON]id/invoice          link the Fusion payable invoice
--   DELETE procash/[COLON]id/invoice          unlink it again (administrator only)
--   POST   procash/[COLON]id/lines            add a detail line
--   PUT    procash/[COLON]id/lines/[COLON]lineid   edit one
--   DELETE procash/[COLON]id/lines/[COLON]lineid   remove one (the rest renumber)
--   GET    procash/[COLON]id/documents        attachments
--   POST   procash/[COLON]id/documents        raw binary upload (name + type in the query)
--   DELETE procash/[COLON]id/documents/[COLON]docid
--   GET    procash/[COLON]id/documents/[COLON]docid/file   authenticated download
--   GET    procash/meta/lovs            statuses, currencies, business units, doc types
--   GET    procash/meta/projects        type-ahead over the project master
--   GET    procash/meta/tasks           tasks of one project
--   GET    procash/meta/etypes          expenditure types
--   GET    procash/meta/gl              GL combinations
--   GET    procash/meta/invoices        validated invoice pick from the AP extract
--   GET    procash/meta/export          CSV of the filtered register
--
-- The meta routes deliberately sit under a third segment that no [COLON]id route
-- uses (lovs / projects / tasks / etypes / gl / invoices / export are never
-- lines, documents, submit, process, cancel or invoice), so a numeric id and a
-- meta word can never collide.
--
-- Error map: -20401 401, -20403 403, -20404 404, -20001 and -20090 400, else 500.
-- Every stored timestamp is displayed through prod.dct_to_local with a 12 hour
-- mask; nullable values are emitted as '' so a key is never silently dropped.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

-- ===================== part 1: register and creation ========================
CREATE OR REPLACE PROCEDURE setup_procash_t1 AS
    c_mod CONSTANT VARCHAR2(30) := 'ap.rest';
    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN

    def_template('procash/');
    def_handler('procash/', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_me     NUMBER;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 50), 10000);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_sort   VARCHAR2(30) := LOWER(NVL([COLON]sort, 'date'));
  l_total  NUMBER := 0;
  l_amt    NUMBER := 0;
  l_open   NUMBER := 0;
  l_await  NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_me := prod.dct_ap_procash_pkg.user_id_of(l_user);
  SELECT COUNT(*), NVL(SUM(p.amount_aed),0),
         COUNT(CASE WHEN p.status IN ('DRAFT','SUBMITTED','IN_APPROVAL','APPROVED') THEN 1 END),
         COUNT(CASE WHEN p.status = 'PROCESSED' THEN 1 END)
    INTO l_total, l_amt, l_open, l_await
    FROM prod.dct_ap_procash p
   WHERE ([COLON]status IS NULL OR INSTR('|'||[COLON]status||'|', '|'||p.status||'|') > 0)
     AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||p.business_unit||'|') > 0)
     AND ([COLON]from IS NULL OR p.payment_date >= TO_DATE([COLON]from,'YYYY-MM-DD'))
     AND ([COLON]to IS NULL OR p.payment_date < TO_DATE([COLON]to,'YYYY-MM-DD') + 1)
     AND ([COLON]supplier IS NULL OR UPPER(NVL(p.supplier_name,' ')||' '||NVL(p.payee_name,' ')||' '||NVL(p.supplier_number,' ')) LIKE '%'||UPPER([COLON]supplier)||'%')
     AND ([COLON]linked IS NULL OR ([COLON]linked = 'Y' AND p.invoice_id IS NOT NULL) OR ([COLON]linked = 'N' AND p.invoice_id IS NULL))
     AND ([COLON]mismatch IS NULL OR NVL(p.amount_mismatch,'N') = [COLON]mismatch)
     AND ([COLON]mine IS NULL OR [COLON]mine <> 'Y' OR p.created_by = l_me)
     AND ([COLON]search IS NULL OR UPPER(p.bank_reference||' '||p.payment_number||' '||NVL(p.description,' ')||' '||NVL(p.invoice_number,' ')||' '||NVL(p.payee_name,' ')) LIKE '%'||UPPER([COLON]search)||'%');
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT p.procash_id, p.payment_number, p.bank_reference, NVL(p.bank_account,'') bank_account,
           p.business_unit, NVL(p.supplier_number,'') supplier_number,
           NVL(p.supplier_name,'') supplier_name, NVL(p.payee_name,'') payee_name,
           p.amount, p.currency_code, p.exchange_rate, p.amount_aed,
           TO_CHAR(p.payment_date,'YYYY-MM-DD') pay_dt, NVL(p.description,'') description,
           p.status, NVL(p.invoice_number,'') invoice_number, NVL(p.invoice_id,0) invoice_id,
           NVL(TO_CHAR(p.invoice_date,'YYYY-MM-DD'),'') inv_dt, NVL(p.invoice_amount,0) invoice_amount,
           NVL(p.amount_mismatch,'') amount_mismatch,
           NVL(TO_CHAR(prod.dct_to_local(p.created_on),'YYYY-MM-DD HH:MI AM'),'') created_disp,
           NVL(cu.display_name, '') created_name,
           NVL(TO_CHAR(prod.dct_to_local(p.processed_on),'YYYY-MM-DD HH:MI AM'),'') processed_disp,
           NVL(pu.display_name,'') processed_name,
           (SELECT COUNT(*) FROM prod.dct_ap_procash_line l WHERE l.procash_id = p.procash_id) line_count,
           (SELECT NVL(SUM(l.amount),0) FROM prod.dct_ap_procash_line l WHERE l.procash_id = p.procash_id) line_sum,
           (SELECT COUNT(*) FROM prod.dct_documents d WHERE d.source_module='AP' AND d.source_type='PROCASH'
              AND d.source_id = p.procash_id AND d.is_active='Y') doc_count
      FROM prod.dct_ap_procash p
      LEFT JOIN prod.dct_users cu ON cu.user_id = p.created_by
      LEFT JOIN prod.dct_users pu ON pu.user_id = p.processed_by
     WHERE ([COLON]status IS NULL OR INSTR('|'||[COLON]status||'|', '|'||p.status||'|') > 0)
       AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||p.business_unit||'|') > 0)
       AND ([COLON]from IS NULL OR p.payment_date >= TO_DATE([COLON]from,'YYYY-MM-DD'))
       AND ([COLON]to IS NULL OR p.payment_date < TO_DATE([COLON]to,'YYYY-MM-DD') + 1)
       AND ([COLON]supplier IS NULL OR UPPER(NVL(p.supplier_name,' ')||' '||NVL(p.payee_name,' ')||' '||NVL(p.supplier_number,' ')) LIKE '%'||UPPER([COLON]supplier)||'%')
       AND ([COLON]linked IS NULL OR ([COLON]linked = 'Y' AND p.invoice_id IS NOT NULL) OR ([COLON]linked = 'N' AND p.invoice_id IS NULL))
       AND ([COLON]mismatch IS NULL OR NVL(p.amount_mismatch,'N') = [COLON]mismatch)
       AND ([COLON]mine IS NULL OR [COLON]mine <> 'Y' OR p.created_by = l_me)
       AND ([COLON]search IS NULL OR UPPER(p.bank_reference||' '||p.payment_number||' '||NVL(p.description,' ')||' '||NVL(p.invoice_number,' ')||' '||NVL(p.payee_name,' ')) LIKE '%'||UPPER([COLON]search)||'%')
     ORDER BY CASE WHEN l_sort = 'amount' THEN p.amount_aed END DESC,
              CASE WHEN l_sort = 'status' THEN p.status END,
              CASE WHEN l_sort = 'ref' THEN p.bank_reference END,
              p.payment_date DESC, p.procash_id DESC
     OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('procashId', r.procash_id);
    APEX_JSON.write('paymentNumber', r.payment_number);
    APEX_JSON.write('bankReference', r.bank_reference);
    APEX_JSON.write('bankAccount', r.bank_account);
    APEX_JSON.write('businessUnit', r.business_unit);
    APEX_JSON.write('supplierNumber', r.supplier_number);
    APEX_JSON.write('supplierName', r.supplier_name);
    APEX_JSON.write('payeeName', r.payee_name);
    APEX_JSON.write('amount', r.amount);
    APEX_JSON.write('currencyCode', r.currency_code);
    APEX_JSON.write('exchangeRate', r.exchange_rate);
    APEX_JSON.write('amountAed', r.amount_aed);
    APEX_JSON.write('paymentDate', r.pay_dt);
    APEX_JSON.write('description', r.description);
    APEX_JSON.write('status', r.status);
    APEX_JSON.write('invoiceId', r.invoice_id);
    APEX_JSON.write('invoiceNumber', r.invoice_number);
    APEX_JSON.write('invoiceDate', r.inv_dt);
    APEX_JSON.write('invoiceAmount', r.invoice_amount);
    APEX_JSON.write('amountMismatch', r.amount_mismatch);
    APEX_JSON.write('lineCount', r.line_count);
    APEX_JSON.write('lineTotal', r.line_sum);
    APEX_JSON.write('docCount', r.doc_count);
    APEX_JSON.write('createdBy', r.created_name);
    APEX_JSON.write('createdOn', r.created_disp);
    APEX_JSON.write('processedBy', r.processed_name);
    APEX_JSON.write('processedOn', r.processed_disp);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_total);
  APEX_JSON.open_object('totals');
  APEX_JSON.write('amountAed', l_amt);
  APEX_JSON.write('count', l_total);
  APEX_JSON.write('openCount', l_open);
  APEX_JSON.write('awaitingInvoice', l_await);
  APEX_JSON.close_object;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('procash');
    def_handler('procash', 'POST', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER;
  l_line NUMBER;
  l_cnt  NUMBER := 0;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  prod.dct_ap_procash_pkg.save_header(
    p_user            => l_user,
    p_procash_id      => NULL,
    p_bank_reference  => APEX_JSON.get_varchar2(p_path=>'bankReference'),
    p_bank_account    => APEX_JSON.get_varchar2(p_path=>'bankAccount'),
    p_business_unit   => APEX_JSON.get_varchar2(p_path=>'businessUnit'),
    p_supplier_number => APEX_JSON.get_varchar2(p_path=>'supplierNumber'),
    p_supplier_name   => APEX_JSON.get_varchar2(p_path=>'supplierName'),
    p_payee_name      => APEX_JSON.get_varchar2(p_path=>'payeeName'),
    p_amount          => APEX_JSON.get_number(p_path=>'amount'),
    p_currency_code   => APEX_JSON.get_varchar2(p_path=>'currencyCode'),
    p_exchange_rate   => APEX_JSON.get_number(p_path=>'exchangeRate'),
    p_payment_date    => TO_DATE(SUBSTR(APEX_JSON.get_varchar2(p_path=>'paymentDate'),1,10),'YYYY-MM-DD'),
    p_description     => APEX_JSON.get_varchar2(p_path=>'description'),
    p_comments        => APEX_JSON.get_varchar2(p_path=>'comments'),
    o_procash_id      => l_id);
  l_cnt := NVL(APEX_JSON.get_count(p_path=>'lines'), 0);
  FOR i IN 1 .. l_cnt LOOP
    prod.dct_ap_procash_pkg.save_line(
      p_user             => l_user,
      p_line_id          => NULL,
      p_procash_id       => l_id,
      p_coding_basis     => APEX_JSON.get_varchar2(p_path=>'lines[%d].codingBasis', p0=>i),
      p_project_number   => APEX_JSON.get_varchar2(p_path=>'lines[%d].projectNumber', p0=>i),
      p_task_number      => APEX_JSON.get_varchar2(p_path=>'lines[%d].taskNumber', p0=>i),
      p_expenditure_type => APEX_JSON.get_varchar2(p_path=>'lines[%d].expenditureType', p0=>i),
      p_gl_combination   => APEX_JSON.get_varchar2(p_path=>'lines[%d].glCombination', p0=>i),
      p_amount           => APEX_JSON.get_number(p_path=>'lines[%d].amount', p0=>i),
      p_comments         => APEX_JSON.get_varchar2(p_path=>'lines[%d].comments', p0=>i),
      o_line_id          => l_line);
  END LOOP;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('procashId', l_id);
  APEX_JSON.write('lines', l_cnt);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20401 THEN dct_rest.err(401,SQLERRM);
  ELSIF SQLCODE = -20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE = -20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    COMMIT;
END setup_procash_t1;
/

BEGIN setup_procash_t1; END;
/
DROP PROCEDURE setup_procash_t1;

PROMPT procash part 1 done (register + create)

-- ========================= part 2: one transaction ==========================
CREATE OR REPLACE PROCEDURE setup_procash_t2 AS
    c_mod CONSTANT VARCHAR2(30) := 'ap.rest';
    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN

    def_template('procash/[COLON]id');
    def_handler('procash/[COLON]id', 'GET', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_id    NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_found BOOLEAN := FALSE;
  l_json  CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Bad procash id'); RETURN; END IF;
  FOR c IN (SELECT p.*, NVL(cu.display_name,'') created_name, NVL(pu.display_name,'') processed_name,
                   NVL(lu.display_name,'') linked_name
              FROM prod.dct_ap_procash p
              LEFT JOIN prod.dct_users cu ON cu.user_id = p.created_by
              LEFT JOIN prod.dct_users pu ON pu.user_id = p.processed_by
              LEFT JOIN prod.dct_users lu ON lu.user_id = p.invoice_linked_by
             WHERE p.procash_id = l_id) LOOP
    l_found := TRUE;
    l_json := prod.dct_ap_procash_pkg.findings(l_id);
    dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
    APEX_JSON.write('procashId', c.procash_id);
    APEX_JSON.write('paymentNumber', c.payment_number);
    APEX_JSON.write('bankReference', c.bank_reference);
    APEX_JSON.write('bankAccount', NVL(c.bank_account,''));
    APEX_JSON.write('businessUnit', c.business_unit);
    APEX_JSON.write('supplierNumber', NVL(c.supplier_number,''));
    APEX_JSON.write('supplierName', NVL(c.supplier_name,''));
    APEX_JSON.write('payeeName', NVL(c.payee_name,''));
    APEX_JSON.write('amount', c.amount);
    APEX_JSON.write('currencyCode', c.currency_code);
    APEX_JSON.write('exchangeRate', c.exchange_rate);
    APEX_JSON.write('amountAed', c.amount_aed);
    APEX_JSON.write('paymentDate', TO_CHAR(c.payment_date,'YYYY-MM-DD'));
    APEX_JSON.write('description', NVL(c.description,''));
    APEX_JSON.write('comments', NVL(c.comments,''));
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('wfInstanceId', NVL(c.wf_instance_id,0));
    APEX_JSON.write('invoiceId', NVL(c.invoice_id,0));
    APEX_JSON.write('invoiceNumber', NVL(c.invoice_number,''));
    APEX_JSON.write('invoiceSupplier', NVL(c.invoice_supplier,''));
    APEX_JSON.write('invoiceDate', NVL(TO_CHAR(c.invoice_date,'YYYY-MM-DD'),''));
    APEX_JSON.write('invoiceAmount', NVL(c.invoice_amount,0));
    APEX_JSON.write('invoiceCurrency', NVL(c.invoice_currency,''));
    APEX_JSON.write('invoiceLinkedBy', c.linked_name);
    APEX_JSON.write('invoiceLinkedOn', NVL(TO_CHAR(prod.dct_to_local(c.invoice_linked_on),'YYYY-MM-DD HH:MI AM'),''));
    APEX_JSON.write('amountMismatch', NVL(c.amount_mismatch,''));
    APEX_JSON.write('createdBy', c.created_name);
    APEX_JSON.write('createdOn', TO_CHAR(prod.dct_to_local(c.created_on),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('updatedOn', NVL(TO_CHAR(prod.dct_to_local(c.updated_on),'YYYY-MM-DD HH:MI AM'),''));
    APEX_JSON.write('processedBy', c.processed_name);
    APEX_JSON.write('processedOn', NVL(TO_CHAR(prod.dct_to_local(c.processed_on),'YYYY-MM-DD HH:MI AM'),''));
    APEX_JSON.write('lineTotal', prod.dct_ap_procash_pkg.line_total(l_id));
    APEX_JSON.write('canEdit', prod.dct_ap_procash_pkg.can_edit(l_id, l_user));
    APEX_JSON.write('canProcess', CASE WHEN prod.dct_ap_procash_pkg.is_processor(l_user) THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('canUnlink', CASE WHEN prod.dct_ap_procash_pkg.is_admin(l_user) THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('approvalMode', NVL(prod.dct_ap_procash_pkg.setting('PROCASH_APPROVAL_MODE','NONE'),'NONE'));
    APEX_JSON.open_array('lines');
    FOR l IN (SELECT ln.line_id, ln.line_num, ln.coding_basis,
                     NVL(ln.project_number,'') project_number, NVL(pr.project_name_en,'') project_name,
                     NVL(ln.task_number,'') task_number, NVL(tk.task_name_en,'') task_name,
                     NVL(ln.expenditure_type,'') expenditure_type,
                     NVL(ln.gl_combination,'') gl_combination, ln.amount, NVL(ln.comments,'') comments
                FROM prod.dct_ap_procash_line ln
                LEFT JOIN prod.dct_projects pr ON pr.project_number = ln.project_number
                LEFT JOIN prod.dct_tasks tk ON tk.project_number = ln.project_number AND tk.task_number = ln.task_number
               WHERE ln.procash_id = l_id ORDER BY ln.line_num) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('lineId', l.line_id);
      APEX_JSON.write('lineNum', l.line_num);
      APEX_JSON.write('codingBasis', l.coding_basis);
      APEX_JSON.write('projectNumber', l.project_number);
      APEX_JSON.write('projectName', l.project_name);
      APEX_JSON.write('taskNumber', l.task_number);
      APEX_JSON.write('taskName', l.task_name);
      APEX_JSON.write('expenditureType', l.expenditure_type);
      APEX_JSON.write('glCombination', l.gl_combination);
      APEX_JSON.write('amount', l.amount);
      APEX_JSON.write('comments', l.comments);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.open_array('documents');
    FOR d IN (SELECT d.doc_id, d.file_name, NVL(d.mime_type,'') mime_type, NVL(d.file_size_bytes,0) sz,
                     t.doc_type_code, t.doc_type_name_en,
                     TO_CHAR(prod.dct_to_local(d.created_at),'YYYY-MM-DD HH:MI AM') up_on,
                     NVL(u.display_name,'') up_by
                FROM prod.dct_documents d
                JOIN prod.dct_document_types t ON t.doc_type_id = d.doc_type_id
                LEFT JOIN prod.dct_users u ON u.user_id = d.created_by
               WHERE d.source_module='AP' AND d.source_type='PROCASH' AND d.source_id = l_id
                 AND d.is_active='Y' ORDER BY d.doc_id) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('docId', d.doc_id);
      APEX_JSON.write('fileName', d.file_name);
      APEX_JSON.write('mimeType', d.mime_type);
      APEX_JSON.write('fileSize', d.sz);
      APEX_JSON.write('docType', d.doc_type_code);
      APEX_JSON.write('docTypeName', d.doc_type_name_en);
      APEX_JSON.write('uploadedOn', d.up_on);
      APEX_JSON.write('uploadedBy', d.up_by);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.open_array('history');
    FOR h IN (SELECT NVL(h.old_status,'') old_status, h.new_status, NVL(h.comments,'') comments,
                     TO_CHAR(prod.dct_to_local(h.changed_at),'YYYY-MM-DD HH:MI AM') at_disp,
                     NVL(u.display_name,'') by_name
                FROM prod.dct_request_status_history h
                LEFT JOIN prod.dct_users u ON u.user_id = h.changed_by
               WHERE h.source_module='AP' AND h.source_type='PROCASH' AND h.source_id = l_id
               ORDER BY h.changed_at, h.hist_id) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('oldStatus', h.old_status);
      APEX_JSON.write('newStatus', h.new_status);
      APEX_JSON.write('comments', h.comments);
      APEX_JSON.write('changedOn', h.at_disp);
      APEX_JSON.write('changedBy', h.by_name);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.open_array('findings');
    FOR f IN (SELECT * FROM JSON_TABLE(l_json, '$[*]'
                COLUMNS (code VARCHAR2(40) PATH '$.code',
                         severity VARCHAR2(10) PATH '$.severity',
                         message VARCHAR2(500) PATH '$.message'))) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('code', f.code);
      APEX_JSON.write('severity', f.severity);
      APEX_JSON.write('message', f.message);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
  IF NOT l_found THEN dct_rest.err(404,'Procash transaction not found'); END IF;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('procash/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_row  prod.dct_ap_procash%ROWTYPE;
  l_out  NUMBER;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Bad procash id'); RETURN; END IF;
  BEGIN
    SELECT * INTO l_row FROM prod.dct_ap_procash WHERE procash_id = l_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Procash transaction not found'); RETURN;
  END;
  IF APEX_JSON.does_exist(p_path=>'bankReference')  THEN l_row.bank_reference  := APEX_JSON.get_varchar2(p_path=>'bankReference'); END IF;
  IF APEX_JSON.does_exist(p_path=>'bankAccount')    THEN l_row.bank_account    := APEX_JSON.get_varchar2(p_path=>'bankAccount'); END IF;
  IF APEX_JSON.does_exist(p_path=>'businessUnit')   THEN l_row.business_unit   := APEX_JSON.get_varchar2(p_path=>'businessUnit'); END IF;
  IF APEX_JSON.does_exist(p_path=>'supplierNumber') THEN l_row.supplier_number := APEX_JSON.get_varchar2(p_path=>'supplierNumber'); END IF;
  IF APEX_JSON.does_exist(p_path=>'supplierName')   THEN l_row.supplier_name   := APEX_JSON.get_varchar2(p_path=>'supplierName'); END IF;
  IF APEX_JSON.does_exist(p_path=>'payeeName')      THEN l_row.payee_name      := APEX_JSON.get_varchar2(p_path=>'payeeName'); END IF;
  IF APEX_JSON.does_exist(p_path=>'amount')         THEN l_row.amount          := APEX_JSON.get_number(p_path=>'amount'); END IF;
  IF APEX_JSON.does_exist(p_path=>'currencyCode')   THEN l_row.currency_code   := APEX_JSON.get_varchar2(p_path=>'currencyCode'); END IF;
  IF APEX_JSON.does_exist(p_path=>'exchangeRate')   THEN l_row.exchange_rate   := APEX_JSON.get_number(p_path=>'exchangeRate'); END IF;
  IF APEX_JSON.does_exist(p_path=>'paymentDate')    THEN l_row.payment_date    := TO_DATE(SUBSTR(APEX_JSON.get_varchar2(p_path=>'paymentDate'),1,10),'YYYY-MM-DD'); END IF;
  IF APEX_JSON.does_exist(p_path=>'description')    THEN l_row.description     := APEX_JSON.get_varchar2(p_path=>'description'); END IF;
  IF APEX_JSON.does_exist(p_path=>'comments')       THEN l_row.comments        := APEX_JSON.get_varchar2(p_path=>'comments'); END IF;
  prod.dct_ap_procash_pkg.save_header(
    l_user, l_id, l_row.bank_reference, l_row.bank_account, l_row.business_unit,
    l_row.supplier_number, l_row.supplier_name, l_row.payee_name, l_row.amount,
    l_row.currency_code, l_row.exchange_rate, l_row.payment_date,
    l_row.description, l_row.comments, l_out);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('procashId', l_out);
  APEX_JSON.write('updated', 'Y');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20401 THEN dct_rest.err(401,SQLERRM);
  ELSIF SQLCODE = -20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE = -20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_handler('procash/[COLON]id', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Bad procash id'); RETURN; END IF;
  prod.dct_ap_procash_pkg.delete_header(l_user, l_id);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('deleted', 'Y');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20401 THEN dct_rest.err(401,SQLERRM);
  ELSIF SQLCODE = -20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE = -20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    COMMIT;
END setup_procash_t2;
/

BEGIN setup_procash_t2; END;
/
DROP PROCEDURE setup_procash_t2;

PROMPT procash part 2 done (detail, update, remove)

-- ======================== part 3: lifecycle actions =========================
CREATE OR REPLACE PROCEDURE setup_procash_t3 AS
    c_mod CONSTANT VARCHAR2(30) := 'ap.rest';
    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN

    def_template('procash/[COLON]id/submit');
    def_handler('procash/[COLON]id/submit', 'POST', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_st   VARCHAR2(30);
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Bad procash id'); RETURN; END IF;
  prod.dct_ap_procash_pkg.submit(l_user, l_id, APEX_JSON.get_varchar2(p_path=>'comments'));
  COMMIT;
  SELECT status INTO l_st FROM prod.dct_ap_procash WHERE procash_id = l_id;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('procashId', l_id);
  APEX_JSON.write('status', l_st);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20401 THEN dct_rest.err(401,SQLERRM);
  ELSIF SQLCODE = -20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE = -20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('procash/[COLON]id/process');
    def_handler('procash/[COLON]id/process', 'POST', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_st   VARCHAR2(30);
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Bad procash id'); RETURN; END IF;
  prod.dct_ap_procash_pkg.mark_processed(l_user, l_id, APEX_JSON.get_varchar2(p_path=>'comments'));
  COMMIT;
  SELECT status INTO l_st FROM prod.dct_ap_procash WHERE procash_id = l_id;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('procashId', l_id);
  APEX_JSON.write('status', l_st);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20401 THEN dct_rest.err(401,SQLERRM);
  ELSIF SQLCODE = -20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE = -20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('procash/[COLON]id/cancel');
    def_handler('procash/[COLON]id/cancel', 'POST', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Bad procash id'); RETURN; END IF;
  prod.dct_ap_procash_pkg.cancel(l_user, l_id, APEX_JSON.get_varchar2(p_path=>'comments'));
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('procashId', l_id);
  APEX_JSON.write('status', 'CANCELLED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20401 THEN dct_rest.err(401,SQLERRM);
  ELSIF SQLCODE = -20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE = -20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('procash/[COLON]id/invoice');
    def_handler('procash/[COLON]id/invoice', 'POST', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_inv  NUMBER;
  l_no   VARCHAR2(100);
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Bad procash id'); RETURN; END IF;
  l_inv := APEX_JSON.get_number(p_path=>'invoiceId');
  l_no  := APEX_JSON.get_varchar2(p_path=>'invoiceNumber');
  prod.dct_ap_procash_pkg.link_invoice(l_user, l_id, l_inv, l_no);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  FOR c IN (SELECT invoice_id, invoice_number, NVL(amount_mismatch,'N') mm, status
              FROM prod.dct_ap_procash WHERE procash_id = l_id) LOOP
    APEX_JSON.write('procashId', l_id);
    APEX_JSON.write('invoiceId', c.invoice_id);
    APEX_JSON.write('invoiceNumber', c.invoice_number);
    APEX_JSON.write('amountMismatch', c.mm);
    APEX_JSON.write('status', c.status);
  END LOOP;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20401 THEN dct_rest.err(401,SQLERRM);
  ELSIF SQLCODE = -20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE = -20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_handler('procash/[COLON]id/invoice', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Bad procash id'); RETURN; END IF;
  prod.dct_ap_procash_pkg.unlink_invoice(l_user, l_id);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('procashId', l_id);
  APEX_JSON.write('status', 'PROCESSED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20401 THEN dct_rest.err(401,SQLERRM);
  ELSIF SQLCODE = -20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE = -20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    COMMIT;
END setup_procash_t3;
/

BEGIN setup_procash_t3; END;
/
DROP PROCEDURE setup_procash_t3;

PROMPT procash part 3 done (submit, process, cancel, invoice link)

-- ====================== part 4: lines and attachments =======================
CREATE OR REPLACE PROCEDURE setup_procash_t4 AS
    c_mod CONSTANT VARCHAR2(30) := 'ap.rest';
    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN

    def_template('procash/[COLON]id/lines');
    def_handler('procash/[COLON]id/lines', 'POST', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_line NUMBER;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Bad procash id'); RETURN; END IF;
  prod.dct_ap_procash_pkg.save_line(
    p_user             => l_user,
    p_line_id          => NULL,
    p_procash_id       => l_id,
    p_coding_basis     => APEX_JSON.get_varchar2(p_path=>'codingBasis'),
    p_project_number   => APEX_JSON.get_varchar2(p_path=>'projectNumber'),
    p_task_number      => APEX_JSON.get_varchar2(p_path=>'taskNumber'),
    p_expenditure_type => APEX_JSON.get_varchar2(p_path=>'expenditureType'),
    p_gl_combination   => APEX_JSON.get_varchar2(p_path=>'glCombination'),
    p_amount           => APEX_JSON.get_number(p_path=>'amount'),
    p_comments         => APEX_JSON.get_varchar2(p_path=>'comments'),
    o_line_id          => l_line);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('lineId', l_line);
  APEX_JSON.write('lineTotal', prod.dct_ap_procash_pkg.line_total(l_id));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20401 THEN dct_rest.err(401,SQLERRM);
  ELSIF SQLCODE = -20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE = -20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('procash/[COLON]id/lines/[COLON]lineid');
    def_handler('procash/[COLON]id/lines/[COLON]lineid', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100);
  l_id   NUMBER := TO_NUMBER([COLON]id     DEFAULT NULL ON CONVERSION ERROR);
  l_line NUMBER := TO_NUMBER([COLON]lineid DEFAULT NULL ON CONVERSION ERROR);
  l_out  NUMBER;
BEGIN
  dct_rest.parse_body([COLON]body);
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL OR l_line IS NULL THEN dct_rest.err(400,'Bad procash or line id'); RETURN; END IF;
  prod.dct_ap_procash_pkg.save_line(
    p_user             => l_user,
    p_line_id          => l_line,
    p_procash_id       => l_id,
    p_coding_basis     => APEX_JSON.get_varchar2(p_path=>'codingBasis'),
    p_project_number   => APEX_JSON.get_varchar2(p_path=>'projectNumber'),
    p_task_number      => APEX_JSON.get_varchar2(p_path=>'taskNumber'),
    p_expenditure_type => APEX_JSON.get_varchar2(p_path=>'expenditureType'),
    p_gl_combination   => APEX_JSON.get_varchar2(p_path=>'glCombination'),
    p_amount           => APEX_JSON.get_number(p_path=>'amount'),
    p_comments         => APEX_JSON.get_varchar2(p_path=>'comments'),
    o_line_id          => l_out);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('lineId', l_out);
  APEX_JSON.write('lineTotal', prod.dct_ap_procash_pkg.line_total(l_id));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20401 THEN dct_rest.err(401,SQLERRM);
  ELSIF SQLCODE = -20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE = -20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_handler('procash/[COLON]id/lines/[COLON]lineid', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER := TO_NUMBER([COLON]id     DEFAULT NULL ON CONVERSION ERROR);
  l_line NUMBER := TO_NUMBER([COLON]lineid DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL OR l_line IS NULL THEN dct_rest.err(400,'Bad procash or line id'); RETURN; END IF;
  prod.dct_ap_procash_pkg.delete_line(l_user, l_line);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('deleted', 'Y');
  APEX_JSON.write('lineTotal', prod.dct_ap_procash_pkg.line_total(l_id));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20401 THEN dct_rest.err(401,SQLERRM);
  ELSIF SQLCODE = -20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE = -20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('procash/[COLON]id/documents');
    def_handler('procash/[COLON]id/documents', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_blob BLOB := [COLON]body;
  l_max  NUMBER;
  l_doc  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Bad procash id'); RETURN; END IF;
  IF l_blob IS NULL OR DBMS_LOB.getlength(l_blob) = 0 THEN dct_rest.err(400,'Empty upload'); RETURN; END IF;
  l_max := TO_NUMBER(NVL(prod.dct_ap_procash_pkg.setting('MAX_UPLOAD_MB','10'),'10'));
  IF DBMS_LOB.getlength(l_blob) > l_max * 1024 * 1024 THEN
    dct_rest.err(413,'File is larger than the '||l_max||' MB limit'); RETURN;
  END IF;
  prod.dct_ap_procash_pkg.add_doc(l_user, l_id,
    NVL([COLON]doctype,'OTHER'), NVL([COLON]name,'attachment'), [COLON]mime, l_blob, l_doc);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('docId', l_doc);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20401 THEN dct_rest.err(401,SQLERRM);
  ELSIF SQLCODE = -20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE = -20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_handler('procash/[COLON]id/documents', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Bad procash id'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR d IN (SELECT d.doc_id, d.file_name, NVL(d.mime_type,'') mime_type, NVL(d.file_size_bytes,0) sz,
                   t.doc_type_code, t.doc_type_name_en,
                   TO_CHAR(prod.dct_to_local(d.created_at),'YYYY-MM-DD HH:MI AM') up_on,
                   NVL(u.display_name,'') up_by
              FROM prod.dct_documents d
              JOIN prod.dct_document_types t ON t.doc_type_id = d.doc_type_id
              LEFT JOIN prod.dct_users u ON u.user_id = d.created_by
             WHERE d.source_module='AP' AND d.source_type='PROCASH' AND d.source_id = l_id
               AND d.is_active='Y' ORDER BY d.doc_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('docId', d.doc_id);
    APEX_JSON.write('fileName', d.file_name);
    APEX_JSON.write('mimeType', d.mime_type);
    APEX_JSON.write('fileSize', d.sz);
    APEX_JSON.write('docType', d.doc_type_code);
    APEX_JSON.write('docTypeName', d.doc_type_name_en);
    APEX_JSON.write('uploadedOn', d.up_on);
    APEX_JSON.write('uploadedBy', d.up_by);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('procash/[COLON]id/documents/[COLON]docid');
    def_handler('procash/[COLON]id/documents/[COLON]docid', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER := TO_NUMBER([COLON]id    DEFAULT NULL ON CONVERSION ERROR);
  l_doc  NUMBER := TO_NUMBER([COLON]docid DEFAULT NULL ON CONVERSION ERROR);
  l_own  NUMBER;
  l_n    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL OR l_doc IS NULL THEN dct_rest.err(400,'Bad procash or document id'); RETURN; END IF;
  SELECT COUNT(*) INTO l_n FROM prod.dct_documents
   WHERE doc_id = l_doc AND source_module='AP' AND source_type='PROCASH' AND source_id = l_id;
  IF l_n = 0 THEN dct_rest.err(404,'Attachment not found'); RETURN; END IF;
  SELECT created_by INTO l_own FROM prod.dct_ap_procash WHERE procash_id = l_id;
  IF l_own <> prod.dct_ap_procash_pkg.user_id_of(l_user)
     AND NOT prod.dct_ap_procash_pkg.is_processor(l_user) THEN
    dct_rest.err(403,'You are not allowed to remove this attachment'); RETURN;
  END IF;
  UPDATE prod.dct_documents SET is_active='N', updated_by = prod.dct_ap_procash_pkg.user_id_of(l_user),
         updated_at = SYSTIMESTAMP
   WHERE doc_id = l_doc;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('deleted', 'Y');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('procash/[COLON]id/documents/[COLON]docid/file');
    def_handler('procash/[COLON]id/documents/[COLON]docid/file', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER := TO_NUMBER([COLON]id    DEFAULT NULL ON CONVERSION ERROR);
  l_doc  NUMBER := TO_NUMBER([COLON]docid DEFAULT NULL ON CONVERSION ERROR);
  l_blob BLOB;
  l_name VARCHAR2(255);
  l_mime VARCHAR2(100);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_id IS NULL OR l_doc IS NULL THEN dct_rest.err(400,'Bad procash or document id'); RETURN; END IF;
  BEGIN
    SELECT file_blob, file_name, NVL(mime_type,'application/octet-stream')
      INTO l_blob, l_name, l_mime
      FROM prod.dct_documents
     WHERE doc_id = l_doc AND source_module='AP' AND source_type='PROCASH' AND source_id = l_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Attachment not found'); RETURN;
  END;
  OWA_UTIL.mime_header(l_mime, FALSE);
  HTP.p('Content-Length: ' || DBMS_LOB.getlength(l_blob));
  HTP.p('Content-Disposition: inline; filename="' || l_name || '"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_procash_t4;
/

BEGIN setup_procash_t4; END;
/
DROP PROCEDURE setup_procash_t4;

PROMPT procash part 4 done (lines + attachments)

-- ================ part 5: pick lists, invoice search, export ================
CREATE OR REPLACE PROCEDURE setup_procash_t5 AS
    c_mod CONSTANT VARCHAR2(30) := 'ap.rest';
    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN

    def_template('procash/meta/lovs');
    def_handler('procash/meta/lovs', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('statuses');
  FOR r IN (SELECT v.value_code, v.value_name_en, NVL(v.value_name_ar,'') ar
              FROM prod.dct_lookup_values v JOIN prod.dct_lookup_categories c ON c.category_id = v.category_id
             WHERE c.category_code = 'PROCASH_STATUS' AND v.is_active='Y' ORDER BY v.display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.value_code);
    APEX_JSON.write('nameEn', r.value_name_en);
    APEX_JSON.write('nameAr', r.ar);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('codingBases');
  FOR r IN (SELECT v.value_code, v.value_name_en, NVL(v.value_name_ar,'') ar
              FROM prod.dct_lookup_values v JOIN prod.dct_lookup_categories c ON c.category_id = v.category_id
             WHERE c.category_code = 'PROCASH_CODING_BASIS' AND v.is_active='Y' ORDER BY v.display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.value_code);
    APEX_JSON.write('nameEn', r.value_name_en);
    APEX_JSON.write('nameAr', r.ar);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('currencies');
  FOR r IN (SELECT currency_code, currency_name_en, NVL(exchange_rate_to_aed,1) rate
              FROM prod.dct_currency_codes WHERE is_active='Y' ORDER BY display_order, currency_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.currency_code);
    APEX_JSON.write('name', r.currency_name_en);
    APEX_JSON.write('rate', r.rate);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('businessUnits');
  FOR r IN (SELECT business_unit bu FROM prod.ap_invoices_header_v
             WHERE business_unit IS NOT NULL GROUP BY business_unit ORDER BY business_unit) LOOP
    APEX_JSON.write(r.bu);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('docTypes');
  FOR r IN (SELECT t.doc_type_code, t.doc_type_name_en, NVL(t.doc_type_name_ar,'') ar, rq.is_mandatory
              FROM prod.dct_doc_requirements rq JOIN prod.dct_document_types t ON t.doc_type_id = rq.doc_type_id
             WHERE rq.source_module='AP' AND rq.context_code='PROCASH' AND rq.is_active='Y'
             ORDER BY rq.display_seq) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.doc_type_code);
    APEX_JSON.write('nameEn', r.doc_type_name_en);
    APEX_JSON.write('nameAr', r.ar);
    APEX_JSON.write('mandatory', r.is_mandatory);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('approvalMode', NVL(prod.dct_ap_procash_pkg.setting('PROCASH_APPROVAL_MODE','NONE'),'NONE'));
  APEX_JSON.write('lineSumEnforced', NVL(prod.dct_ap_procash_pkg.setting('PROCASH_LINE_SUM_ENFORCE','Y'),'Y'));
  APEX_JSON.write('attachRequired', NVL(prod.dct_ap_procash_pkg.setting('PROCASH_ATTACH_REQUIRED','N'),'N'));
  APEX_JSON.write('canCreate', CASE WHEN prod.dct_ap_procash_pkg.is_admin(l_user)
                                     OR dct_auth.has_role(l_user,'PROCASH_USER')
                                     OR dct_auth.has_role(l_user,'PROCASH_PROCESSOR') THEN 'Y' ELSE 'N' END);
  APEX_JSON.write('canProcess', CASE WHEN prod.dct_ap_procash_pkg.is_processor(l_user) THEN 'Y' ELSE 'N' END);
  APEX_JSON.write('isAdmin', CASE WHEN prod.dct_ap_procash_pkg.is_admin(l_user) THEN 'Y' ELSE 'N' END);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('procash/meta/projects');
    def_handler('procash/meta/projects', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT project_number, project_name_en FROM prod.dct_projects
             WHERE is_active='Y'
               AND ([COLON]search IS NULL
                    OR UPPER(project_number||' '||project_name_en) LIKE '%'||UPPER([COLON]search)||'%')
             ORDER BY project_number FETCH FIRST 2000 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.project_number);
    APEX_JSON.write('name', r.project_name_en);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('procash/meta/tasks');
    def_handler('procash/meta/tasks', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF [COLON]project IS NULL THEN dct_rest.err(400,'A project is required'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT task_number, task_name_en FROM prod.dct_tasks
             WHERE project_number = [COLON]project AND is_active='Y'
               AND ([COLON]search IS NULL
                    OR UPPER(task_number||' '||task_name_en) LIKE '%'||UPPER([COLON]search)||'%')
             ORDER BY task_number FETCH FIRST 500 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.task_number);
    APEX_JSON.write('name', r.task_name_en);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('procash/meta/etypes');
    def_handler('procash/meta/etypes', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT expenditure_type, exp_type_name_en FROM prod.dct_expenditure_types
             WHERE is_active='Y'
               AND ([COLON]search IS NULL
                    OR UPPER(expenditure_type||' '||exp_type_name_en) LIKE '%'||UPPER([COLON]search)||'%')
             ORDER BY expenditure_type FETCH FIRST 1000 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.expenditure_type);
    APEX_JSON.write('name', r.exp_type_name_en);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('procash/meta/gl');
    def_handler('procash/meta/gl', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT cc_string, NVL(account_desc,'') account_desc, NVL(cost_center_desc,'') cc_desc,
                   NVL(entity_desc,'') entity_desc
              FROM prod.dct_gl_coa_snap
             WHERE ([COLON]search IS NULL OR UPPER(cc_string||' '||NVL(account_desc,' ')||' '||NVL(cost_center_desc,' '))
                    LIKE '%'||UPPER([COLON]search)||'%')
             ORDER BY cc_string FETCH FIRST 300 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.cc_string);
    APEX_JSON.write('account', r.account_desc);
    APEX_JSON.write('costCenter', r.cc_desc);
    APEX_JSON.write('entity', r.entity_desc);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('procash/meta/suppliers');
    def_handler('procash/meta/suppliers', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT TO_CHAR(supplier_number) code, MAX(supplier_name) name
              FROM prod.atd_suppliers
             WHERE supplier_number IS NOT NULL
               AND ([COLON]search IS NULL
                    OR UPPER(supplier_name) LIKE '%'||UPPER([COLON]search)||'%'
                    OR TO_CHAR(supplier_number) LIKE [COLON]search||'%')
             GROUP BY supplier_number
             ORDER BY MAX(supplier_name) FETCH FIRST 200 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.code);
    APEX_JSON.write('name', r.name);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('procash/meta/invoices');
    def_handler('procash/meta/invoices', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (SELECT h.invoice_id, h.invoice_number, TO_CHAR(h.invoice_date,'YYYY-MM-DD') inv_dt,
                   NVL(h.beneficiary_name, h.supplier_name) supplier, NVL(h.business_unit,'') bu,
                   h.invoice_amount, NVL(h.invoice_currency,'') ccy, NVL(h.invoice_status,'') st,
                   (SELECT COUNT(*) FROM prod.dct_ap_procash p WHERE p.invoice_id = h.invoice_id) taken
              FROM prod.ap_invoices_header_v h
             WHERE ([COLON]search IS NULL
                    OR UPPER(h.invoice_number||' '||NVL(h.supplier_name,' ')||' '||NVL(h.beneficiary_name,' '))
                       LIKE '%'||UPPER([COLON]search)||'%')
               AND ([COLON]bu IS NULL OR h.business_unit = [COLON]bu)
             ORDER BY h.invoice_date DESC, h.invoice_id DESC FETCH FIRST 100 ROWS ONLY) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('invoiceId', r.invoice_id);
    APEX_JSON.write('invoiceNumber', r.invoice_number);
    APEX_JSON.write('invoiceDate', r.inv_dt);
    APEX_JSON.write('supplier', r.supplier);
    APEX_JSON.write('businessUnit', r.bu);
    APEX_JSON.write('amount', r.invoice_amount);
    APEX_JSON.write('currency', r.ccy);
    APEX_JSON.write('status', r.st);
    APEX_JSON.write('alreadyLinked', CASE WHEN r.taken > 0 THEN 'Y' ELSE 'N' END);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('procash/meta/export');
    def_handler('procash/meta/export', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  FUNCTION esc(p VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF p IS NULL THEN RETURN NULL; END IF;
    IF INSTR(p,'"') > 0 OR INSTR(p,',') > 0 OR INSTR(p,CHR(10)) > 0 THEN
      RETURN '"' || REPLACE(p,'"','""') || '"';
    END IF;
    RETURN p;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  OWA_UTIL.mime_header('text/csv', FALSE, 'UTF-8');
  HTP.p('Content-Disposition: attachment; filename="procash-'||TO_CHAR(SYSDATE,'YYYY-MM-DD')||'.csv"');
  OWA_UTIL.http_header_close;
  HTP.prn(UNISTR('\FEFF'));
  HTP.print('Payment Number,Bank Reference,Bank Account,Business Unit,Payee,Supplier Number,Payment Date,Currency,Amount,Rate,Amount AED,Status,Line Count,Line Total,Invoice Number,Invoice Date,Invoice Amount,Mismatch,Description,Created By,Created On,Processed By,Processed On');
  FOR r IN (SELECT p.payment_number, p.bank_reference, p.bank_account, p.business_unit,
                   NVL(p.payee_name, p.supplier_name) payee, p.supplier_number,
                   TO_CHAR(p.payment_date,'YYYY-MM-DD') pay_dt, p.currency_code, p.amount,
                   p.exchange_rate, p.amount_aed, p.status,
                   (SELECT COUNT(*) FROM prod.dct_ap_procash_line l WHERE l.procash_id = p.procash_id) lc,
                   (SELECT NVL(SUM(l.amount),0) FROM prod.dct_ap_procash_line l WHERE l.procash_id = p.procash_id) lt,
                   p.invoice_number, TO_CHAR(p.invoice_date,'YYYY-MM-DD') inv_dt, p.invoice_amount,
                   p.amount_mismatch, p.description, cu.display_name created_name,
                   TO_CHAR(prod.dct_to_local(p.created_on),'YYYY-MM-DD HH:MI AM') created_disp,
                   pu.display_name processed_name,
                   TO_CHAR(prod.dct_to_local(p.processed_on),'YYYY-MM-DD HH:MI AM') processed_disp
              FROM prod.dct_ap_procash p
              LEFT JOIN prod.dct_users cu ON cu.user_id = p.created_by
              LEFT JOIN prod.dct_users pu ON pu.user_id = p.processed_by
             WHERE ([COLON]status IS NULL OR INSTR('|'||[COLON]status||'|', '|'||p.status||'|') > 0)
               AND ([COLON]bu IS NULL OR INSTR('|'||[COLON]bu||'|', '|'||p.business_unit||'|') > 0)
               AND ([COLON]from IS NULL OR p.payment_date >= TO_DATE([COLON]from,'YYYY-MM-DD'))
               AND ([COLON]to IS NULL OR p.payment_date < TO_DATE([COLON]to,'YYYY-MM-DD') + 1)
               AND ([COLON]linked IS NULL OR ([COLON]linked = 'Y' AND p.invoice_id IS NOT NULL) OR ([COLON]linked = 'N' AND p.invoice_id IS NULL))
               AND ([COLON]search IS NULL OR UPPER(p.bank_reference||' '||p.payment_number||' '||NVL(p.description,' ')||' '||NVL(p.invoice_number,' ')||' '||NVL(p.payee_name,' ')) LIKE '%'||UPPER([COLON]search)||'%')
             ORDER BY p.payment_date DESC, p.procash_id DESC
             FETCH FIRST 25000 ROWS ONLY) LOOP
    HTP.print(esc(r.payment_number)||','||esc(r.bank_reference)||','||esc(r.bank_account)||','||
              esc(r.business_unit)||','||esc(r.payee)||','||esc(r.supplier_number)||','||r.pay_dt||','||
              r.currency_code||','||r.amount||','||r.exchange_rate||','||r.amount_aed||','||r.status||','||
              r.lc||','||r.lt||','||esc(r.invoice_number)||','||r.inv_dt||','||r.invoice_amount||','||
              r.amount_mismatch||','||esc(r.description)||','||esc(r.created_name)||','||r.created_disp||','||
              esc(r.processed_name)||','||r.processed_disp);
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_procash_t5;
/

BEGIN setup_procash_t5; END;
/
DROP PROCEDURE setup_procash_t5;

PROMPT procash part 5 done (pick lists, invoice search, CSV)

PROMPT === verification -- procash templates on ap.rest ===
SELECT t.uri_template, LISTAGG(h.method, ' ') WITHIN GROUP (ORDER BY h.method) AS methods
  FROM user_ords_templates t
  JOIN user_ords_modules m ON m.id = t.module_id
  LEFT JOIN user_ords_handlers h ON h.template_id = t.id
 WHERE m.name = 'ap.rest' AND t.uri_template LIKE 'procash%'
 GROUP BY t.uri_template ORDER BY t.uri_template;
