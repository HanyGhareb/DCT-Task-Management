-- ============================================================================
-- DRAFT — NOT DEPLOYED — assessment-3 proposal only. Do NOT run against PROD.
-- Shared request-status history + standard status vocabulary.
-- See assessment-3/03-database/02-proposed-model.md §4
-- ============================================================================
SET DEFINE OFF

CREATE TABLE prod.dct_request_status_history (
  hist_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  source_module  VARCHAR2(10)  NOT NULL,
  source_type    VARCHAR2(30)  NOT NULL,
  source_id      NUMBER        NOT NULL,
  old_status     VARCHAR2(30),            -- NULL on creation
  new_status     VARCHAR2(30)  NOT NULL,
  changed_by     NUMBER        NOT NULL REFERENCES prod.dct_users (user_id),
  changed_at     TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
  comments       VARCHAR2(1000)
);

CREATE INDEX prod.idx_dct_rsh_source
  ON prod.dct_request_status_history (source_module, source_type, source_id);
CREATE INDEX prod.idx_dct_rsh_changed
  ON prod.dct_request_status_history (changed_at);

COMMENT ON TABLE prod.dct_request_status_history IS
  'Append-only status-transition log for every request-like row in every module. Fed by module packages (single helper proc in DCT_REST or a new DCT_LIFECYCLE pkg).';

-- ----------------------------------------------------------------------------
-- Standard status vocabulary as a lookup category.
-- Individual INSERTs (INSERT ALL + IDENTITY raises ORA-00001 — known platform bug).
-- Module-specific sub-states (e.g. DT ADVANCE_PAID/TRAVELLED) remain in the
-- module's own status column but must map to one of these for cross-module
-- reporting (mapping kept in dct_lookup_values.attribute1).
-- ----------------------------------------------------------------------------
-- Assumes a category row in dct_lookup_categories with category_code = 'REQUEST_STATUS'.
-- Pseudo-seed (category_id resolved at install time):

INSERT INTO prod.dct_lookup_values (category_id, value_code, value_name_en, display_order)
  SELECT category_id, 'DRAFT', 'Draft', 10 FROM prod.dct_lookup_categories WHERE category_code = 'REQUEST_STATUS';
INSERT INTO prod.dct_lookup_values (category_id, value_code, value_name_en, display_order)
  SELECT category_id, 'SUBMITTED', 'Submitted', 20 FROM prod.dct_lookup_categories WHERE category_code = 'REQUEST_STATUS';
INSERT INTO prod.dct_lookup_values (category_id, value_code, value_name_en, display_order)
  SELECT category_id, 'PENDING_APPROVAL', 'Pending Approval', 30 FROM prod.dct_lookup_categories WHERE category_code = 'REQUEST_STATUS';
INSERT INTO prod.dct_lookup_values (category_id, value_code, value_name_en, display_order)
  SELECT category_id, 'RETURNED', 'Returned for Correction', 40 FROM prod.dct_lookup_categories WHERE category_code = 'REQUEST_STATUS';
INSERT INTO prod.dct_lookup_values (category_id, value_code, value_name_en, display_order)
  SELECT category_id, 'APPROVED', 'Approved', 50 FROM prod.dct_lookup_categories WHERE category_code = 'REQUEST_STATUS';
INSERT INTO prod.dct_lookup_values (category_id, value_code, value_name_en, display_order)
  SELECT category_id, 'REJECTED', 'Rejected', 60 FROM prod.dct_lookup_categories WHERE category_code = 'REQUEST_STATUS';
INSERT INTO prod.dct_lookup_values (category_id, value_code, value_name_en, display_order)
  SELECT category_id, 'IN_PROGRESS', 'In Progress', 70 FROM prod.dct_lookup_categories WHERE category_code = 'REQUEST_STATUS';
INSERT INTO prod.dct_lookup_values (category_id, value_code, value_name_en, display_order)
  SELECT category_id, 'CLOSED', 'Closed', 80 FROM prod.dct_lookup_categories WHERE category_code = 'REQUEST_STATUS';
INSERT INTO prod.dct_lookup_values (category_id, value_code, value_name_en, display_order)
  SELECT category_id, 'CANCELLED', 'Cancelled', 90 FROM prod.dct_lookup_categories WHERE category_code = 'REQUEST_STATUS';

COMMIT;

-- Cross-module pending-work query this enables (example):
--   SELECT source_module, source_type, COUNT(*)
--   FROM   ( latest status per source via dct_request_status_history )
--   WHERE  new_status IN ('SUBMITTED','PENDING_APPROVAL')
--   GROUP  BY source_module, source_type;
