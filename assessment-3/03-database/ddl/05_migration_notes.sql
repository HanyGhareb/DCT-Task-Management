-- ============================================================================
-- DRAFT — NOT DEPLOYED — assessment-3 proposal only. Do NOT run against PROD.
-- Old -> new mapping notes for the phased migration
-- (order of adoption: CC -> FL -> PC -> DT, see 02-proposed-model.md §8).
-- Everything below is commented INSERT-SELECT sketches, not runnable as-is:
-- column lists must be finalized against the deployed DDL at migration time.
-- ============================================================================
SET DEFINE OFF

-- ----------------------------------------------------------------------------
-- 1. Documents -> dct_documents
-- ----------------------------------------------------------------------------
-- PC (dct_pc_attachments: request_type PC|REIMB|CLEAR, no doc type -> map to
--     a generic 'OTHER' document type until users reclassify):
-- INSERT INTO prod.dct_documents
--   (source_module, source_type, source_id, document_type_id,
--    file_name, mime_type, file_blob, created_by, created_at)
-- SELECT 'PC', a.request_type, a.request_id, :generic_doc_type_id,
--        a.file_name, a.mime_type, a.file_blob, a.created_by, a.created_at
-- FROM   prod.dct_pc_attachments a;

-- DT (dt_documents already has document_type_id + expiry — 1:1 mapping):
-- SELECT 'DT', d.source_type, d.source_id, d.document_type_id,
--        d.file_name, d.mime_type, d.file_blob,
--        d.expiry_date, d.alert_days_before, ...
-- FROM   prod.dt_documents d;

-- CC (dct_cc_attachments: keep reference_id and doc_req_id):
-- SELECT 'CC', a.source_type, a.source_id, NVL(r.document_type_id, :generic),
--        ... , a.reference_id, a.doc_req_id
-- FROM   prod.dct_cc_attachments a
-- LEFT JOIN prod.dct_cc_doc_requirements r ON r.doc_req_id = a.doc_req_id;

-- FL (dct_fl_documents — the source pattern; 1:1):
-- SELECT 'FL', d.source_type, d.source_id, d.document_type_id, ...
-- FROM   prod.dct_fl_documents d;

-- HR (hr_employee_documents):
-- SELECT 'HR', 'EMPLOYEE', d.employee_id, d.document_type_id, ...
-- FROM   prod.hr_employee_documents d;

-- Post-step per module: repoint package procedures + ORDS handlers, rename old
-- table to <name>_bak for one release, then DROP. ADMIN synonyms must be
-- recreated to point at the new table BEFORE the ORDS module switch.

-- ----------------------------------------------------------------------------
-- 2. Budget lines -> dct_budget_coding_lines
-- ----------------------------------------------------------------------------
-- Free-text -> ID resolution happens during the INSERT-SELECT:
-- INSERT INTO prod.dct_budget_coding_lines
--   (source_module, source_type, source_id, line_num, coding_type,
--    cc_id, project_id, task_id, exp_type_id, amount, description, ...)
-- SELECT 'PC', 'PC', b.pc_id, b.line_num, b.coding_type,
--        b.cc_id,
--        p.project_id,            -- JOIN dct_projects p ON p.project_number = b.project_number
--        t.task_id,               -- JOIN dct_project_tasks t ON t.task_number = b.task_number
--        e.exp_type_id,           -- JOIN dct_expenditure_types e ON e.exp_type_code = b.expenditure_type
--        b.amount, b.description, ...
-- FROM   prod.dct_pc_budget_lines b ...;
--
-- Rows whose free-text fails to resolve go to a _migration_orphans staging
-- table for manual mapping — DO NOT silently drop them.
--
-- DT/FL header-level inline coding becomes a single line (line_num = 1):
-- SELECT 'DT', 'DT_REQ', r.request_id, 1, r.budget_type, r.cc_id_gl, ...
-- FROM   prod.dt_requests r WHERE r.budget_type IS NOT NULL;

-- ----------------------------------------------------------------------------
-- 3. Status history backfill (optional, best-effort)
-- ----------------------------------------------------------------------------
-- Historic transitions are only partially reconstructable from
-- dct_approval_actions; seed one CREATION row per existing record at its
-- current status and start clean from cutover:
-- INSERT INTO prod.dct_request_status_history
--   (source_module, source_type, source_id, old_status, new_status, changed_by, changed_at)
-- SELECT 'PC', 'PC', pc_id, NULL, status, created_by, created_at
-- FROM   prod.dct_petty_cash;

-- ----------------------------------------------------------------------------
-- 4. CC card status simplification (do BEFORE writing DCT_CC_PKG)
-- ----------------------------------------------------------------------------
-- UPDATE prod.dct_credit_cards
-- SET    status = CASE
--          WHEN status IN ('ACTIVE') THEN 'ACTIVE'
--          WHEN status IN ('INACTIVE','UNDER_PROCESS') THEN 'INACTIVE'
--          ELSE 'ACTIVE'   -- *_IN_PROGRESS: the open dct_cc_requests row carries the operation
--        END;
-- ALTER TABLE prod.dct_credit_cards DROP CONSTRAINT <old status check>;
-- ALTER TABLE prod.dct_credit_cards ADD CONSTRAINT ck_cc_status
--   CHECK (status IN ('ACTIVE','INACTIVE','CLOSED'));
-- CREATE OR REPLACE VIEW prod.dct_cc_cards_v AS
--   SELECT c.*,
--          (SELECT MAX(r.request_type) FROM prod.dct_cc_requests r
--           WHERE r.card_id = c.card_id
--           AND   r.status IN ('SUBMITTED','UNDER_REVIEW')) AS pending_operation
--   FROM prod.dct_credit_cards c;
