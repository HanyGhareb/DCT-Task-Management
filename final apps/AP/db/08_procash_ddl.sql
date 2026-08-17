SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
-- =============================================================================
-- Procash Transactions - data model, vocabularies, settings and roles
-- File   : 08_procash_ddl.sql        App 212 / AP        2026-08-17
-- Schema : PROD
-- Run    : own SQLcl session (no synonyms here)
-- Safe   : rerunnable - add-if-missing everywhere, never removes business data
-- -----------------------------------------------------------------------------
-- A Procash transaction is a manual payment pushed through the bank portal
-- directly, outside Fusion Payables. Master-detail, budget-coded, reconciled
-- afterwards to the Fusion payable invoice once that invoice exists.
-- Value sets live in dct_lookup_values (lookup-first, no status constraints).
-- The coding columns (project / task / expenditure type / GL) carry NO foreign
-- key to the masters BY DECISION (user, 2026-08-17): the form offers the real
-- values in a dropdown, but a code the masters do not carry is still stored as
-- typed. A line coded that way will not join to GL or Budget Utilization.
-- Attachments ride dct_documents, the trail rides dct_request_status_history.
-- Blocks below carry no interior blank lines on purpose - this box's SQLcl
-- silently swallows blocks that do.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

PROMPT --- [1/7] master and detail ---

DECLARE
  PROCEDURE mk(p_name VARCHAR2, p_sql CLOB) IS
    l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n FROM all_tables WHERE owner = 'PROD' AND table_name = UPPER(p_name);
    IF l_n = 0 THEN
      EXECUTE IMMEDIATE p_sql;
      DBMS_OUTPUT.put_line('made  ' || p_name);
    ELSE
      DBMS_OUTPUT.put_line('kept  ' || p_name);
    END IF;
  END;
BEGIN
  mk('DCT_AP_PROCASH', q'[
    CREATE TABLE dct_ap_procash(
      procash_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      payment_number    VARCHAR2(30)  NOT NULL,
      bank_reference    VARCHAR2(100) NOT NULL,
      bank_account      VARCHAR2(200),
      business_unit     VARCHAR2(240) NOT NULL,
      supplier_number   VARCHAR2(30),
      supplier_name     VARCHAR2(400),
      payee_name        VARCHAR2(400),
      amount            NUMBER(18,2)  NOT NULL,
      currency_code     VARCHAR2(3)   NOT NULL REFERENCES dct_currency_codes(currency_code),
      exchange_rate     NUMBER(18,8)  DEFAULT 1 NOT NULL,
      amount_aed        NUMBER(18,2)  GENERATED ALWAYS AS (ROUND(amount * exchange_rate, 2)) VIRTUAL,
      payment_date      DATE          NOT NULL,
      description       VARCHAR2(1000),
      comments          VARCHAR2(4000),
      status            VARCHAR2(30)  DEFAULT 'DRAFT' NOT NULL,
      wf_instance_id    NUMBER,
      processed_by      NUMBER        REFERENCES dct_users(user_id),
      processed_on      TIMESTAMP,
      invoice_id        NUMBER,
      invoice_number    VARCHAR2(100),
      invoice_supplier  VARCHAR2(400),
      invoice_date      DATE,
      invoice_amount    NUMBER(18,2),
      invoice_currency  VARCHAR2(3),
      invoice_linked_by NUMBER        REFERENCES dct_users(user_id),
      invoice_linked_on TIMESTAMP,
      amount_mismatch   VARCHAR2(1)   GENERATED ALWAYS AS (CASE WHEN invoice_amount IS NULL THEN NULL WHEN ABS(invoice_amount - amount) > 0.005 THEN 'Y' ELSE 'N' END) VIRTUAL,
      created_by        NUMBER        NOT NULL REFERENCES dct_users(user_id),
      created_on        TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      updated_by        NUMBER        REFERENCES dct_users(user_id),
      updated_on        TIMESTAMP
    )]');
  mk('DCT_AP_PROCASH_LINE', q'[
    CREATE TABLE dct_ap_procash_line(
      line_id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      procash_id        NUMBER NOT NULL,
      line_num          NUMBER NOT NULL,
      coding_basis      VARCHAR2(10) DEFAULT 'PROJECT' NOT NULL,
      project_number    VARCHAR2(12),
      task_number       VARCHAR2(30),
      expenditure_type  VARCHAR2(255),
      gl_combination    VARCHAR2(320),
      amount            NUMBER(18,2) NOT NULL,
      comments          VARCHAR2(1000),
      created_by        NUMBER    NOT NULL REFERENCES dct_users(user_id),
      created_on        TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
      updated_by        NUMBER    REFERENCES dct_users(user_id),
      updated_on        TIMESTAMP,
      CONSTRAINT fk_procash_line_hdr  FOREIGN KEY (procash_id) REFERENCES dct_ap_procash(procash_id) ON DELETE CASCADE,
      CONSTRAINT uk_procash_line_num  UNIQUE (procash_id, line_num)
    )]');
END;
/

PROMPT --- [2/7] keys and access paths ---

DECLARE
  PROCEDURE mk_ix(p_name VARCHAR2, p_sql VARCHAR2) IS
    l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n FROM all_indexes WHERE owner = 'PROD' AND index_name = UPPER(p_name);
    IF l_n = 0 THEN
      EXECUTE IMMEDIATE p_sql;
      DBMS_OUTPUT.put_line('made  ' || p_name);
    END IF;
  END;
BEGIN
  mk_ix('UX_AP_PROCASH_REF',  'CREATE UNIQUE INDEX ux_ap_procash_ref ON dct_ap_procash(bank_reference)');
  mk_ix('UX_AP_PROCASH_NUM',  'CREATE UNIQUE INDEX ux_ap_procash_num ON dct_ap_procash(payment_number)');
  mk_ix('IX_AP_PROCASH_STAT', 'CREATE INDEX ix_ap_procash_stat ON dct_ap_procash(status)');
  mk_ix('IX_AP_PROCASH_PDT',  'CREATE INDEX ix_ap_procash_pdt ON dct_ap_procash(payment_date)');
  mk_ix('IX_AP_PROCASH_BU',   'CREATE INDEX ix_ap_procash_bu ON dct_ap_procash(business_unit)');
  mk_ix('IX_AP_PROCASH_INV',  'CREATE INDEX ix_ap_procash_inv ON dct_ap_procash(invoice_number)');
  mk_ix('IX_AP_PROCASH_OWNR', 'CREATE INDEX ix_ap_procash_ownr ON dct_ap_procash(created_by)');
  mk_ix('IX_AP_PCLINE_PROJ',  'CREATE INDEX ix_ap_pcline_proj ON dct_ap_procash_line(project_number, task_number)');
  mk_ix('IX_AP_PCLINE_GL',    'CREATE INDEX ix_ap_pcline_gl ON dct_ap_procash_line(gl_combination)');
END;
/

PROMPT --- [2b/7] the coding columns carry no master foreign keys ---

DECLARE
  PROCEDURE drop_fk(p_ref VARCHAR2) IS
  BEGIN
    FOR c IN (SELECT c.constraint_name FROM all_constraints c
                JOIN all_constraints r ON r.owner = c.r_owner AND r.constraint_name = c.r_constraint_name
               WHERE c.owner = 'PROD' AND c.table_name = 'DCT_AP_PROCASH_LINE'
                 AND c.constraint_type = 'R' AND r.table_name = p_ref) LOOP
      EXECUTE IMMEDIATE 'ALTER TABLE dct_ap_procash_line DROP CONSTRAINT ' || c.constraint_name;
      DBMS_OUTPUT.put_line('dropped ' || c.constraint_name || ' -> ' || p_ref);
    END LOOP;
  END;
BEGIN
  drop_fk('DCT_PROJECTS');
  drop_fk('DCT_TASKS');
  drop_fk('DCT_EXPENDITURE_TYPES');
END;
/

PROMPT --- [3/7] payment number generator ---

DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM all_sequences WHERE sequence_owner = 'PROD' AND sequence_name = 'DCT_AP_PROCASH_NUM_SEQ';
  IF l_n = 0 THEN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE dct_ap_procash_num_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE';
    DBMS_OUTPUT.put_line('made  DCT_AP_PROCASH_NUM_SEQ');
  END IF;
END;
/

PROMPT --- [4/7] vocabularies ---

DECLARE
  v_cat NUMBER;
  PROCEDURE up_cat(p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, o_id OUT NUMBER) IS
  BEGIN
    UPDATE prod.dct_lookup_categories SET category_name_en = p_en, category_name_ar = p_ar WHERE category_code = p_code;
    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO prod.dct_lookup_categories (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
      VALUES (p_code, p_en, p_ar, 121, 'Y', 'Y');
    END IF;
    SELECT category_id INTO o_id FROM prod.dct_lookup_categories WHERE category_code = p_code;
  END;
  PROCEDURE up_val(p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_ord NUMBER, p_default VARCHAR2 DEFAULT 'N') IS
  BEGIN
    UPDATE prod.dct_lookup_values SET value_name_en = p_en, value_name_ar = p_ar, display_order = p_ord, is_active = 'Y'
     WHERE category_id = p_cat AND value_code = p_code;
    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO prod.dct_lookup_values (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
      VALUES (p_cat, p_code, p_en, p_ar, p_ord, p_default, 'Y');
    END IF;
  END;
BEGIN
  up_cat('PROCASH_STATUS', 'Procash Transaction Status', 'حالة معاملة الدفع المباشر', v_cat);
  up_val(v_cat, 'DRAFT',       'Draft',       'مسودة',          10, 'Y');
  up_val(v_cat, 'SUBMITTED',   'Submitted',   'مقدمة',          20);
  up_val(v_cat, 'IN_APPROVAL', 'In Approval', 'قيد الاعتماد',   30);
  up_val(v_cat, 'APPROVED',    'Approved',    'معتمدة',         40);
  up_val(v_cat, 'PROCESSED',   'Processed',   'تم التنفيذ',     50);
  up_val(v_cat, 'INVOICED',    'Invoiced',    'مرتبطة بفاتورة', 60);
  up_val(v_cat, 'REJECTED',    'Rejected',    'مرفوضة',         70);
  up_val(v_cat, 'CANCELLED',   'Cancelled',   'ملغاة',          80);
  up_cat('PROCASH_CODING_BASIS', 'Procash Line Coding Basis', 'أساس ترميز بند الدفع المباشر', v_cat);
  up_val(v_cat, 'PROJECT', 'Project / Task / Expenditure Type', 'مشروع / مهمة / نوع الإنفاق', 10, 'Y');
  up_val(v_cat, 'GL',      'GL Combination',                    'تركيبة الأستاذ العام',       20);
  COMMIT;
END;
/

PROMPT --- [5/7] attachment types and the optional checklist ---

DECLARE
  PROCEDURE up_type(p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_ord NUMBER) IS
    l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n FROM prod.dct_document_types WHERE doc_type_code = p_code;
    IF l_n = 0 THEN
      INSERT INTO prod.dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, is_active, display_order)
      VALUES (p_code, p_en, p_ar, 'FINANCIAL', 'AP', 'N', 'Y', p_ord);
    ELSE
      UPDATE prod.dct_document_types SET doc_type_name_en = p_en, doc_type_name_ar = p_ar, is_active = 'Y' WHERE doc_type_code = p_code;
    END IF;
  END;
  PROCEDURE widen(p_code VARCHAR2) IS
  BEGIN
    UPDATE prod.dct_document_types SET applies_to_modules = applies_to_modules || '|AP'
     WHERE doc_type_code = p_code AND INSTR('|' || applies_to_modules || '|', '|AP|') = 0;
  END;
  PROCEDURE up_req(p_code VARCHAR2, p_seq NUMBER) IS
    l_type NUMBER;
    l_n    NUMBER;
  BEGIN
    SELECT doc_type_id INTO l_type FROM prod.dct_document_types WHERE doc_type_code = p_code;
    SELECT COUNT(*) INTO l_n FROM prod.dct_doc_requirements WHERE source_module = 'AP' AND context_code = 'PROCASH' AND doc_type_id = l_type;
    IF l_n = 0 THEN
      INSERT INTO prod.dct_doc_requirements (source_module, context_code, doc_type_id, is_mandatory, display_seq, is_active)
      VALUES ('AP', 'PROCASH', l_type, 'N', p_seq, 'Y');
    ELSE
      UPDATE prod.dct_doc_requirements SET is_mandatory = 'N', display_seq = p_seq, is_active = 'Y'
       WHERE source_module = 'AP' AND context_code = 'PROCASH' AND doc_type_id = l_type;
    END IF;
  END;
BEGIN
  up_type('PROCASH_ADVICE',       'Payment Advice',            'إشعار الدفع', 10);
  up_type('PROCASH_BANK_CONFIRM', 'Bank Confirmation / SWIFT', 'تأكيد البنك', 20);
  widen('INVOICE');
  widen('APPROVAL_LETTER');
  widen('OTHER');
  up_req('PROCASH_ADVICE',       10);
  up_req('PROCASH_BANK_CONFIRM', 20);
  up_req('INVOICE',              30);
  up_req('APPROVAL_LETTER',      40);
  up_req('OTHER',                90);
  COMMIT;
END;
/

PROMPT --- [6/7] module settings on AP ---

DECLARE
  PROCEDURE up_set(p_key VARCHAR2, p_val VARCHAR2, p_label VARCHAR2, p_desc VARCHAR2, p_type VARCHAR2, p_allowed VARCHAR2) IS
    l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n FROM prod.dct_module_settings WHERE module_id = 121 AND setting_key = p_key;
    IF l_n = 0 THEN
      INSERT INTO prod.dct_module_settings (module_id, setting_key, setting_value, setting_label, setting_description, value_type, allowed_values, default_value)
      VALUES (121, p_key, p_val, p_label, p_desc, p_type, p_allowed, p_val);
    ELSE
      UPDATE prod.dct_module_settings SET setting_label = p_label, setting_description = p_desc, value_type = p_type, allowed_values = p_allowed, default_value = p_val
       WHERE module_id = 121 AND setting_key = p_key;
    END IF;
  END;
BEGIN
  up_set('PROCASH_APPROVAL_MODE', 'NONE', 'Procash approval mode',
         'NONE keeps the simple lifecycle. WORKFLOW routes a submitted transaction through the PROCASH_APPROVAL process before it can be processed.',
         'SELECT', 'NONE,WORKFLOW');
  up_set('PROCASH_NUMBER_AUTO', 'Y', 'Generate procash payment numbers',
         'Stamp a system payment number on every new procash transaction.', 'BOOLEAN', 'Y,N');
  up_set('PROCASH_NUMBER_PREFIX', 'PCH-', 'Procash payment number prefix',
         'Prefix placed before the five digit sequence, for example PCH-00042.', 'TEXT', NULL);
  up_set('PROCASH_LINE_SUM_ENFORCE', 'Y', 'Detail lines must equal the header amount',
         'Blocks submit when the detail lines do not add up to the header amount. A draft only warns.', 'BOOLEAN', 'Y,N');
  up_set('PROCASH_ATTACH_REQUIRED', 'N', 'Attachment required before processing',
         'Requires at least one attachment before a procash transaction can be marked processed.', 'BOOLEAN', 'Y,N');
  COMMIT;
END;
/

PROMPT --- [7/7] roles ---

DECLARE
  PROCEDURE up_role(p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_desc VARCHAR2, p_ord NUMBER) IS
    l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n FROM prod.dct_roles WHERE role_code = p_code;
    IF l_n = 0 THEN
      INSERT INTO prod.dct_roles (role_code, role_name_en, role_name_ar, role_type, module_id, description_en, is_system_role, is_active, display_order, role_category)
      VALUES (p_code, p_en, p_ar, 'MODULE', 121, p_desc, 'N', 'Y', p_ord, 'JOB');
    ELSE
      UPDATE prod.dct_roles SET role_name_en = p_en, role_name_ar = p_ar, module_id = 121, description_en = p_desc, is_active = 'Y'
       WHERE role_code = p_code;
    END IF;
  END;
BEGIN
  up_role('PROCASH_USER', 'Procash User', 'مستخدم الدفع المباشر',
          'Creates and edits own procash transactions and submits them.', 10);
  up_role('PROCASH_PROCESSOR', 'Procash Processor', 'منفذ الدفع المباشر',
          'Marks an approved procash transaction as processed once the bank payment is executed.', 20);
  up_role('PROCASH_ADMIN', 'Procash Administrator', 'مسؤول الدفع المباشر',
          'Full control over every procash transaction, including invoice linking and unlinking.', 30);
  COMMIT;
END;
/

PROMPT --- [8/8] bootstrap holders so the roles are never empty ---

DECLARE
  v_admin NUMBER;
  PROCEDURE grant_role(p_code VARCHAR2) IS
    v_role NUMBER;
    v_n    NUMBER;
  BEGIN
    SELECT role_id INTO v_role FROM prod.dct_roles WHERE role_code = p_code;
    SELECT COUNT(*) INTO v_n FROM prod.dct_user_roles
     WHERE user_id = v_admin AND role_id = v_role AND (end_date IS NULL OR end_date > SYSDATE);
    IF v_n = 0 THEN
      INSERT INTO prod.dct_user_roles (user_id, role_id, start_date, is_active, assigned_by, reason, created_by)
      VALUES (v_admin, v_role, SYSDATE, 'Y', 'SEED', 'Bootstrap holder so the procash chain can resolve', 'SEED');
      DBMS_OUTPUT.put_line('granted ' || p_code || ' to ADMIN');
    END IF;
  END;
BEGIN
  SELECT user_id INTO v_admin FROM prod.dct_users WHERE username = 'ADMIN';
  grant_role('PROCASH_USER');
  grant_role('PROCASH_PROCESSOR');
  grant_role('PROCASH_ADMIN');
  COMMIT;
END;
/

PROMPT === verification ===

SET LINESIZE 200
COLUMN what FORMAT A30
COLUMN object_name FORMAT A30

SELECT object_type, object_name, status FROM all_objects
 WHERE owner = 'PROD' AND object_name LIKE '%PROCASH%' ORDER BY object_type, object_name;

SELECT 'lookup ' || c.category_code AS what, COUNT(*) AS cnt
  FROM prod.dct_lookup_categories c JOIN prod.dct_lookup_values v ON v.category_id = c.category_id
 WHERE c.category_code LIKE 'PROCASH%' GROUP BY c.category_code
UNION ALL SELECT 'settings on AP', COUNT(*) FROM prod.dct_module_settings WHERE module_id = 121 AND setting_key LIKE 'PROCASH%'
UNION ALL SELECT 'roles', COUNT(*) FROM prod.dct_roles WHERE role_code LIKE 'PROCASH%'
UNION ALL SELECT 'doc checklist', COUNT(*) FROM prod.dct_doc_requirements WHERE source_module = 'AP' AND context_code = 'PROCASH';

PROMPT === arabic byte check - lead bytes must be d8 or d9 ===

SELECT value_code, DUMP(value_name_ar, 1016) AS ar_bytes FROM prod.dct_lookup_values
 WHERE category_id = (SELECT category_id FROM prod.dct_lookup_categories WHERE category_code = 'PROCASH_STATUS')
   AND value_code = 'DRAFT';
