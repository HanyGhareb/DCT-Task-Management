-- ============================================================================
-- DRAFT — NOT DEPLOYED — assessment-3 proposal only. Do NOT run against PROD.
-- Unified document store replacing:
--   dct_pc_attachments, dt_documents, dct_cc_attachments,
--   dct_fl_documents, hr_employee_documents
-- See assessment-3/03-database/02-proposed-model.md §2
-- Conventions: run via SQLcl as ADMIN, objects in PROD schema.
-- ============================================================================
SET DEFINE OFF

CREATE TABLE prod.dct_documents (
  doc_id             NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  source_module      VARCHAR2(10)  NOT NULL
                     CHECK (source_module IN ('PC','DT','HR','FL','CC','ADMIN')),
  source_type        VARCHAR2(30)  NOT NULL,  -- REQUEST, REIMB, CLEARING, CONTRACT, EMPLOYEE, ...
  source_id          NUMBER        NOT NULL,  -- PK of the owning row in the module table
  reference_id       NUMBER,                  -- optional line-level anchor (CC pattern)
  document_type_id   NUMBER        NOT NULL
                     REFERENCES prod.dct_document_types (document_type_id),
  doc_req_id         NUMBER,                  -- optional link to dct_doc_requirements
  file_name          VARCHAR2(255) NOT NULL,
  mime_type          VARCHAR2(100),
  file_size_bytes    NUMBER,
  file_blob          BLOB,                    -- later: nullable + object_storage_url
  expiry_date        DATE,
  alert_days_before  NUMBER,
  notes              VARCHAR2(1000),
  is_active          VARCHAR2(1)   DEFAULT 'Y' CHECK (is_active IN ('Y','N')),
  created_by         NUMBER        NOT NULL,
  created_at         TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
  updated_by         NUMBER,
  updated_at         TIMESTAMP
);

CREATE INDEX prod.idx_dct_docs_source
  ON prod.dct_documents (source_module, source_type, source_id);
CREATE INDEX prod.idx_dct_docs_expiry
  ON prod.dct_documents (expiry_date) ;

COMMENT ON TABLE prod.dct_documents IS
  'Unified document/attachment store for all modules. Discriminated by (source_module, source_type, source_id).';

-- ----------------------------------------------------------------------------
-- Unified document requirements (replaces dt_doc_requirements, dct_cc_doc_requirements)
-- ----------------------------------------------------------------------------
CREATE TABLE prod.dct_doc_requirements (
  doc_req_id         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  source_module      VARCHAR2(10)  NOT NULL,
  context_code       VARCHAR2(50)  NOT NULL,  -- e.g. DT:EXTERNAL_TRIP, CC:NEW_CARD
  document_type_id   NUMBER        NOT NULL
                     REFERENCES prod.dct_document_types (document_type_id),
  is_mandatory       VARCHAR2(1)   DEFAULT 'Y' CHECK (is_mandatory IN ('Y','N')),
  display_seq        NUMBER        DEFAULT 10,
  is_active          VARCHAR2(1)   DEFAULT 'Y' CHECK (is_active IN ('Y','N')),
  created_by         NUMBER NOT NULL,
  created_at         TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
  updated_by         NUMBER,
  updated_at         TIMESTAMP,
  CONSTRAINT uq_dct_doc_req UNIQUE (source_module, context_code, document_type_id)
);

-- ----------------------------------------------------------------------------
-- Generalized expiry-alert suppression log (from dct_fl_doc_expiry_alerts)
-- Fed by one daily job replacing the per-module dispatchers.
-- ----------------------------------------------------------------------------
CREATE TABLE prod.dct_doc_expiry_alerts (
  alert_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  doc_id       NUMBER NOT NULL REFERENCES prod.dct_documents (doc_id),
  alerted_at   TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
  notified_user_id NUMBER NOT NULL,
  CONSTRAINT uq_dct_doc_alert UNIQUE (doc_id, notified_user_id)
);

-- ADMIN synonyms required for ORDS handlers (handlers execute as ADMIN):
--   CREATE OR REPLACE SYNONYM dct_documents        FOR prod.dct_documents;
--   CREATE OR REPLACE SYNONYM dct_doc_requirements FOR prod.dct_doc_requirements;
