-- =============================================================================
-- Freelancers Module (App 203) — Views
-- File    : 02_fl_views.sql
-- Schema  : PROD
-- Run     : After 01_fl_ddl.sql
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. DCT_FL_REGISTRATION_V — Registration requests with nationality name
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_fl_registration_v AS
SELECT
  r.registration_id,
  r.registration_number,
  r.first_name_en,
  r.last_name_en,
  r.first_name_en || ' ' || r.last_name_en    AS full_name_en,
  r.first_name_ar,
  r.last_name_ar,
  r.date_of_birth,
  r.nationality_code,
  n.nationality_en                             AS nationality_name,
  r.national_id,
  r.passport_number,
  r.email,
  r.mobile,
  r.specialization,
  r.first_deal_with_dct,
  r.submitted_by,
  r.submitted_by_user_id,
  su.display_name                              AS submitted_by_name,
  r.status,
  r.approval_instance_id,
  r.notes,
  r.created_by,
  cb.display_name                              AS created_by_name,
  r.created_at,
  r.updated_by,
  r.updated_at
FROM prod.dct_fl_registrations  r
JOIN  prod.dct_nationality       n   ON n.nationality_code = r.nationality_code
LEFT JOIN prod.dct_users         su  ON su.user_id = r.submitted_by_user_id
LEFT JOIN prod.dct_users         cb  ON cb.username = r.created_by;

COMMENT ON TABLE prod.dct_fl_registration_v IS 'Registration requests enriched with nationality name and submitter details';

-- =============================================================================
-- 2. DCT_FL_FREELANCER_V — Freelancer profiles with nationality and doc counts
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_fl_freelancer_v AS
SELECT
  f.freelancer_id,
  f.registration_id,
  f.vendor_number,
  f.first_name_en,
  f.last_name_en,
  f.first_name_en || ' ' || f.last_name_en    AS full_name_en,
  f.first_name_ar,
  f.last_name_ar,
  f.date_of_birth,
  f.nationality_code,
  n.nationality_en                             AS nationality_name,
  f.national_id,
  f.passport_number,
  f.email,
  f.mobile,
  f.specialization,
  f.status,
  f.blacklist_reason,
  f.notes,
  f.created_at,
  f.updated_at,
  -- Active contract count
  (SELECT COUNT(*)
   FROM prod.dct_fl_contracts c
   WHERE c.freelancer_id = f.freelancer_id
   AND   c.status        = 'ACTIVE')           AS active_contract_count,
  -- Expired document count (unified dct_documents; reference_id = freelancer_id for FL docs)
  (SELECT COUNT(*)
   FROM prod.dct_documents d
   WHERE d.source_module  = 'FL'
   AND   d.reference_id   = f.freelancer_id
   AND   d.expiry_date    < SYSDATE
   AND   d.status         = 'ACTIVE'
   AND   d.is_active      = 'Y')               AS expired_doc_count
FROM prod.dct_fl_freelancers f
LEFT JOIN prod.dct_nationality n ON n.nationality_code = f.nationality_code;

COMMENT ON TABLE prod.dct_fl_freelancer_v IS 'Freelancer profiles with nationality, active contract count and expired document count';

-- =============================================================================
-- 3. DCT_FL_CONTRACT_V — Contracts with freelancer, org, and billing status
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_fl_contract_v AS
SELECT
  c.contract_id,
  c.contract_number,
  c.version_number,
  c.freelancer_id,
  f.first_name_en || ' ' || f.last_name_en    AS freelancer_name,
  f.vendor_number,
  c.renewed_from_contract_id,
  c.title,
  c.start_date,
  c.end_date,
  c.total_amount,
  c.currency_code,
  c.billing_method,
  c.billing_unit_id,
  lv.value_name_en                            AS billing_unit_name,
  c.billing_unit_amount,
  c.org_id,
  o.org_name_en                               AS org_name,
  c.coding_type,
  c.cc_id_gl,
  c.project_number,
  c.task_number,
  c.expenditure_type,
  c.status,
  c.approval_instance_id,
  c.notes,
  c.created_by,
  cb.display_name                             AS created_by_name,
  c.created_at,
  c.updated_at,
  -- Payment totals
  (SELECT NVL(SUM(s.amount), 0)
   FROM prod.dct_fl_payment_schedule s
   WHERE s.contract_id = c.contract_id)       AS scheduled_total,
  (SELECT NVL(SUM(s.amount), 0)
   FROM prod.dct_fl_payment_schedule s
   WHERE s.contract_id = c.contract_id
   AND   s.status      = 'PAID')              AS paid_total,
  -- Billing status derived from schedule
  CASE
    WHEN (SELECT COUNT(*) FROM prod.dct_fl_payment_schedule s
          WHERE s.contract_id = c.contract_id) = 0
      THEN 'NOT_PAID'
    WHEN (SELECT COUNT(*) FROM prod.dct_fl_payment_schedule s
          WHERE s.contract_id = c.contract_id
          AND   s.status     != 'PAID') = 0
      THEN 'FULLY_PAID'
    WHEN (SELECT COUNT(*) FROM prod.dct_fl_payment_schedule s
          WHERE s.contract_id = c.contract_id
          AND   s.status      = 'PAID') > 0
      THEN 'PARTIALLY_PAID'
    ELSE 'NOT_PAID'
  END                                         AS contract_bill_status
FROM prod.dct_fl_contracts      c
JOIN  prod.dct_fl_freelancers   f   ON f.freelancer_id = c.freelancer_id
JOIN  prod.dct_organizations    o   ON o.org_id        = c.org_id
LEFT JOIN prod.dct_lookup_values lv ON lv.value_id     = c.billing_unit_id
LEFT JOIN prod.dct_users         cb ON cb.username      = c.created_by;

COMMENT ON TABLE prod.dct_fl_contract_v IS 'Contracts with freelancer, org, billing unit, payment totals and contract_bill_status';

-- =============================================================================
-- 4. DCT_FL_PAYMENT_SCHEDULE_V — Schedule rows with contract and freelancer info
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_fl_payment_schedule_v AS
SELECT
  s.schedule_id,
  s.contract_id,
  c.contract_number,
  c.freelancer_id,
  f.first_name_en || ' ' || f.last_name_en    AS freelancer_name,
  s.period_label,
  s.due_date,
  s.amount,
  s.voucher_id,
  v.voucher_number,
  s.status,
  s.created_at,
  s.updated_at
FROM prod.dct_fl_payment_schedule   s
JOIN  prod.dct_fl_contracts          c   ON c.contract_id  = s.contract_id
JOIN  prod.dct_fl_freelancers        f   ON f.freelancer_id = c.freelancer_id
LEFT JOIN prod.dct_fl_payment_vouchers v ON v.voucher_id   = s.voucher_id;

COMMENT ON TABLE prod.dct_fl_payment_schedule_v IS 'Payment schedule rows with contract number, freelancer name and linked voucher';

-- =============================================================================
-- 5. DCT_FL_VOUCHER_V — Vouchers with contract, freelancer, and payment info
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_fl_voucher_v AS
SELECT
  v.voucher_id,
  v.voucher_number,
  v.contract_id,
  c.contract_number,
  v.freelancer_id,
  f.first_name_en || ' ' || f.last_name_en    AS freelancer_name,
  f.vendor_number,
  v.schedule_id,
  v.period_label,
  v.due_date,
  v.amount,
  v.invoice_number,
  v.invoice_date,
  v.payment_method,
  v.pay_group,
  v.description,
  v.coding_type,
  v.cc_id_gl,
  v.project_number,
  v.task_number,
  v.expenditure_type,
  v.post_to_fusion,
  v.status,
  v.payment_status,
  v.payment_date,
  v.payment_reference,
  v.approval_instance_id,
  v.notes,
  v.created_by,
  cb.display_name                             AS created_by_name,
  v.created_at,
  v.updated_at
FROM prod.dct_fl_payment_vouchers  v
JOIN  prod.dct_fl_contracts         c   ON c.contract_id   = v.contract_id
JOIN  prod.dct_fl_freelancers       f   ON f.freelancer_id = v.freelancer_id
LEFT JOIN prod.dct_users            cb  ON cb.username      = v.created_by;

COMMENT ON TABLE prod.dct_fl_voucher_v IS 'Payment vouchers with contract, freelancer, and payment status context';

-- =============================================================================
-- 6. DCT_FL_DOCUMENT_V — Documents with expiry status and freelancer name
--    Backed by the unified DCT_DOCUMENTS store (source_module = 'FL').
--    Convention: reference_id carries the freelancer_id for every FL document;
--    document types resolve from DCT_DOCUMENT_TYPES (not lookup values).
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_fl_document_v AS
SELECT
  d.doc_id                                    AS document_id,
  d.reference_id                              AS freelancer_id,
  f.first_name_en || ' ' || f.last_name_en    AS freelancer_name,
  d.source_type,
  d.source_id,
  d.doc_type_id                               AS document_type_id,
  dt.doc_type_name_en                         AS document_type_name,
  d.file_name                                 AS document_name,
  d.mime_type                                 AS file_mime_type,
  d.file_size_bytes                           AS file_size,
  d.expiry_date,
  d.alert_days_before,
  d.is_required,
  d.status,
  d.notes,
  d.created_by,
  d.created_at,
  d.updated_at,
  -- Expiry status
  CASE
    WHEN d.expiry_date IS NULL
      THEN 'VALID'
    WHEN d.expiry_date < SYSDATE
      THEN 'EXPIRED'
    WHEN d.expiry_date <= SYSDATE + NVL(d.alert_days_before, 30)
      THEN 'EXPIRING_SOON'
    ELSE 'VALID'
  END                                         AS expiry_status,
  TRUNC(d.expiry_date - SYSDATE)              AS days_to_expiry
FROM prod.dct_documents           d
LEFT JOIN prod.dct_fl_freelancers f  ON f.freelancer_id = d.reference_id
LEFT JOIN prod.dct_document_types dt ON dt.doc_type_id  = d.doc_type_id
WHERE d.source_module = 'FL';

COMMENT ON TABLE prod.dct_fl_document_v IS 'FL window into unified DCT_DOCUMENTS with expiry_status (VALID/EXPIRING_SOON/EXPIRED), days_to_expiry, and freelancer name (reference_id = freelancer_id)';

-- =============================================================================
-- 7. DCT_FL_DELIVERABLE_V — Deliverables with contract and freelancer info
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_fl_deliverable_v AS
SELECT
  d.deliverable_id,
  d.contract_id,
  c.contract_number,
  c.freelancer_id,
  f.first_name_en || ' ' || f.last_name_en    AS freelancer_name,
  d.schedule_id,
  s.period_label,
  d.title,
  d.description,
  d.deliverable_date,
  d.quantity,
  d.unit_id,
  lv.value_name_en                            AS unit_name,
  d.accepted_by,
  au.display_name                             AS accepted_by_name,
  d.accepted_date,
  d.status,
  d.rejection_reason,
  d.notes,
  d.created_by,
  cb.display_name                             AS created_by_name,
  d.created_at,
  d.updated_at
FROM prod.dct_fl_deliverables       d
JOIN  prod.dct_fl_contracts          c   ON c.contract_id   = d.contract_id
JOIN  prod.dct_fl_freelancers        f   ON f.freelancer_id = c.freelancer_id
LEFT JOIN prod.dct_fl_payment_schedule s ON s.schedule_id  = d.schedule_id
LEFT JOIN prod.dct_lookup_values     lv  ON lv.value_id    = d.unit_id
LEFT JOIN prod.dct_users             au  ON au.user_id     = d.accepted_by
LEFT JOIN prod.dct_users             cb  ON cb.username     = d.created_by;

COMMENT ON TABLE prod.dct_fl_deliverable_v IS 'Deliverables with contract, freelancer, schedule period and acceptor details';

COMMIT;

PROMPT
PROMPT === 02_fl_views.sql complete ===
PROMPT Views created: DCT_FL_REGISTRATION_V, DCT_FL_FREELANCER_V, DCT_FL_CONTRACT_V,
PROMPT                DCT_FL_PAYMENT_SCHEDULE_V, DCT_FL_VOUCHER_V,
PROMPT                DCT_FL_DOCUMENT_V, DCT_FL_DELIVERABLE_V
