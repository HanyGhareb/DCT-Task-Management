-- =============================================================================
-- Duty Travel Module (App 204) — Views
-- File    : 03_dt_views.sql
-- Schema  : PROD
-- Run     : After 01_dt_ddl.sql and 02_dt_seed.sql
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. DT_REQUESTS_V
--    Full travel request with employee name, org name, grade label,
--    disbursed-by and closed-by display names, and status badge class.
-- =============================================================================
CREATE OR REPLACE VIEW prod.dt_requests_v AS
SELECT
  r.request_id,
  r.request_number,
  r.employee_user_id,
  emp.display_name                                            AS employee_name,
  emp.username                                                AS employee_username,
  r.employee_grade_code,
  lv_grade.value_name_en                                      AS grade_label,
  r.org_id,
  org.org_name_en,
  org.org_name_ar,
  r.mission_type,
  CASE r.mission_type
    WHEN 'BUSINESS_MISSION' THEN 'Business Mission'
    WHEN 'TRAINING'         THEN 'Training'
    ELSE r.mission_type
  END                                                         AS mission_type_label,
  r.trip_type,
  CASE r.trip_type
    WHEN 'INTERNAL' THEN 'Internal (UAE)'
    WHEN 'EXTERNAL' THEN 'External (International)'
    ELSE r.trip_type
  END                                                         AS trip_type_label,
  r.purpose,
  r.hosted_by,
  r.departure_date,
  r.return_date,
  r.total_days,
  -- Per diem & advance
  r.total_per_diem_aed,
  r.ticket_amount_aed,
  r.accommodation_amount_aed,
  r.visa_fees_aed,
  r.local_transport_aed,
  r.other_allowances_aed,
  r.total_advance_aed,
  -- Budget coding
  r.budget_type,
  r.cc_id_gl,
  gl.entity_code
    || CASE WHEN gl.appropriation IS NOT NULL THEN '.' || gl.appropriation ELSE '' END
    || CASE WHEN gl.cost_center   IS NOT NULL THEN '.' || gl.cost_center   ELSE '' END
    || CASE WHEN gl.account       IS NOT NULL THEN '.' || gl.account       ELSE '' END
                                                              AS gl_code_display,
  r.project_number,
  r.task_number,
  r.expenditure_type,
  -- Lifecycle
  r.status,
  CASE r.status
    WHEN 'DRAFT'        THEN 'u-color-1'
    WHEN 'SUBMITTED'    THEN 'u-color-5'
    WHEN 'APPROVED'     THEN 'u-color-8'
    WHEN 'ADVANCE_PAID' THEN 'u-color-6'
    WHEN 'TRAVELLED'    THEN 'u-color-4'
    WHEN 'CLOSED'       THEN 'u-color-2'
    WHEN 'REJECTED'     THEN 'u-color-3'
    WHEN 'RETURNED'     THEN 'u-color-7'
    WHEN 'CANCELLED'    THEN 'u-color-9'
    ELSE 'u-color-1'
  END                                                         AS status_badge_class,
  r.approval_instance_id,
  ai.overall_status                                           AS approval_status,
  r.finance_disbursed_yn,
  r.disbursed_date,
  r.disbursed_by_user_id,
  disb_usr.display_name                                       AS disbursed_by_name,
  r.closed_date,
  r.closed_by_user_id,
  clos_usr.display_name                                       AS closed_by_name,
  r.notes,
  r.created_by,
  r.created_at,
  r.updated_by,
  r.updated_at
FROM prod.dt_requests                r
JOIN prod.dct_users                  emp       ON emp.user_id         = r.employee_user_id
JOIN prod.dct_organizations          org       ON org.org_id          = r.org_id
LEFT JOIN (SELECT lv.value_code, lv.value_name_en
           FROM   prod.dct_lookup_values      lv
           JOIN   prod.dct_lookup_categories  lc ON lc.category_id = lv.category_id
           WHERE  lc.category_code = 'DT_EMPLOYEE_GRADE') lv_grade
                                               ON lv_grade.value_code = r.employee_grade_code
LEFT JOIN prod.dct_gl_code_combinations gl     ON gl.cc_id            = r.cc_id_gl
LEFT JOIN prod.dct_users             disb_usr  ON disb_usr.user_id    = r.disbursed_by_user_id
LEFT JOIN prod.dct_users             clos_usr  ON clos_usr.user_id    = r.closed_by_user_id
LEFT JOIN prod.dct_approval_instances ai       ON ai.instance_id      = r.approval_instance_id;

COMMENT ON TABLE prod.dt_requests_v IS 'Travel requests with employee / org / coding / lifecycle display names';

-- =============================================================================
-- 2. DT_DESTINATIONS_V
--    Destination legs enriched with country group info and request context.
-- =============================================================================
CREATE OR REPLACE VIEW prod.dt_destinations_v AS
SELECT
  d.destination_id,
  d.request_id,
  r.request_number,
  r.employee_user_id,
  r.status                                                    AS request_status,
  d.seq_num,
  d.country_code,
  COALESCE(cg.country_name_en, d.country_code)               AS country_name_en,
  COALESCE(cg.country_name_ar, d.country_code)               AS country_name_ar,
  cg.group_code,
  d.city,
  d.arrival_date,
  d.departure_date,
  d.duration_days,
  d.rate_id,
  pdr.rate_key                                                AS rate_key,
  pdr.rate_key_name_en                                        AS rate_key_name_en,
  d.per_diem_daily_rate_aed,
  d.per_diem_total_aed,
  d.notes,
  d.created_at,
  d.updated_at
FROM prod.dt_destinations          d
JOIN prod.dt_requests              r   ON r.request_id = d.request_id
LEFT JOIN prod.dt_country_groups   cg  ON cg.country_code = d.country_code
LEFT JOIN prod.dt_per_diem_rates   pdr ON pdr.rate_id     = d.rate_id;

COMMENT ON TABLE prod.dt_destinations_v IS 'Destination legs with country name, group, and snapped rate details';

-- =============================================================================
-- 3. DT_SETTLEMENT_V
--    Settlement header joined to request, employee, and org.
-- =============================================================================
CREATE OR REPLACE VIEW prod.dt_settlement_v AS
SELECT
  s.settlement_id,
  s.settlement_number,
  s.request_id,
  r.request_number,
  r.mission_type,
  r.trip_type,
  r.departure_date                                            AS planned_departure_date,
  r.return_date                                               AS planned_return_date,
  s.employee_user_id,
  emp.display_name                                            AS employee_name,
  emp.username                                                AS employee_username,
  r.org_id,
  org.org_name_en,
  s.actual_return_date,
  s.actual_per_diem_days,
  s.total_actual_aed,
  s.advance_paid_aed,
  s.difference_aed,
  s.settlement_type,
  CASE s.settlement_type
    WHEN 'ADDITIONAL_PAYMENT' THEN 'u-color-7'
    WHEN 'REFUND'             THEN 'u-color-5'
    ELSE 'u-color-1'
  END                                                         AS settlement_type_badge_class,
  s.employee_notes,
  s.finance_notes,
  s.status,
  CASE s.status
    WHEN 'DRAFT'      THEN 'u-color-1'
    WHEN 'SUBMITTED'  THEN 'u-color-5'
    WHEN 'APPROVED'   THEN 'u-color-2'
    WHEN 'REJECTED'   THEN 'u-color-3'
    WHEN 'RETURNED'   THEN 'u-color-7'
    ELSE 'u-color-1'
  END                                                         AS status_badge_class,
  s.approval_instance_id,
  s.refund_collected_yn,
  s.refund_collected_date,
  s.additional_payment_ref,
  s.additional_payment_date,
  s.created_by,
  s.created_at,
  s.updated_by,
  s.updated_at
FROM prod.dt_settlement      s
JOIN prod.dt_requests        r   ON r.request_id      = s.request_id
JOIN prod.dct_users          emp ON emp.user_id        = s.employee_user_id
JOIN prod.dct_organizations  org ON org.org_id         = r.org_id;

COMMENT ON TABLE prod.dt_settlement_v IS 'Settlements with request context, employee name, and org name';

-- =============================================================================
-- 4. DT_PENDING_APPROVALS_V
--    One row per request currently awaiting action in the approval queue.
--    Join to current approval step via template_id + current_step_seq.
--    Filter by required_role_code in APEX using DCT_AUTH.HAS_ROLE.
-- =============================================================================
CREATE OR REPLACE VIEW prod.dt_pending_approvals_v AS
SELECT
  r.request_id,
  r.request_number,
  r.employee_user_id,
  emp.display_name                                            AS employee_name,
  emp.username                                                AS employee_username,
  r.org_id,
  org.org_name_en,
  r.mission_type,
  r.trip_type,
  r.departure_date,
  r.return_date,
  r.total_days,
  r.total_advance_aed,
  r.status,
  r.approval_instance_id,
  ai.instance_id,
  ai.current_step_seq,
  ai.overall_status                                           AS approval_overall_status,
  ast.step_id                                                 AS current_step_id,
  ast.step_seq                                                AS step_seq,
  ast.step_name                                               AS step_name,
  ast.required_role_id                                        AS approver_role_id,
  rol.role_code                                               AS required_role_code,
  rol.role_name_en                                            AS required_role_name,
  ai.submitted_at,
  r.purpose
FROM prod.dt_requests             r
JOIN prod.dct_users               emp ON emp.user_id         = r.employee_user_id
JOIN prod.dct_organizations       org ON org.org_id          = r.org_id
JOIN prod.dct_approval_instances  ai  ON ai.instance_id      = r.approval_instance_id
JOIN prod.dct_approval_steps      ast ON ast.template_id     = ai.template_id
                                     AND ast.step_seq        = ai.current_step_seq
JOIN prod.dct_roles               rol ON rol.role_id         = ast.required_role_id
WHERE ai.overall_status = 'PENDING';

COMMENT ON TABLE prod.dt_pending_approvals_v IS 'Requests pending approval — filter APEX region by DCT_AUTH.HAS_ROLE(:APP_USER_ID, required_role_code) = 1';

-- =============================================================================
-- 5. DT_RATE_MASTER_V
--    Per diem rate master with current/expired/future status and grade label.
-- =============================================================================
CREATE OR REPLACE VIEW prod.dt_rate_master_v AS
SELECT
  r.rate_id,
  r.rate_key,
  r.rate_key_name_en,
  r.rate_key_name_ar,
  r.grade_code,
  lv.value_name_en                                            AS grade_label,
  r.per_diem_daily_aed,
  r.effective_from,
  r.effective_to,
  r.is_active,
  CASE
    WHEN r.is_active = 'N'                 THEN 'INACTIVE'
    WHEN r.effective_from > TRUNC(SYSDATE) THEN 'FUTURE'
    WHEN r.effective_to IS NULL
      OR r.effective_to >= TRUNC(SYSDATE)  THEN 'CURRENT'
    ELSE 'EXPIRED'
  END                                                         AS rate_status,
  CASE
    WHEN r.is_active = 'N'                 THEN 'u-color-1'
    WHEN r.effective_from > TRUNC(SYSDATE) THEN 'u-color-5'
    WHEN r.effective_to IS NULL
      OR r.effective_to >= TRUNC(SYSDATE)  THEN 'u-color-2'
    ELSE 'u-color-9'
  END                                                         AS rate_status_badge_class,
  r.notes,
  r.created_by,
  r.created_at,
  r.updated_by,
  r.updated_at
FROM prod.dt_per_diem_rates r
LEFT JOIN (SELECT lv2.value_code, lv2.value_name_en
           FROM   prod.dct_lookup_values     lv2
           JOIN   prod.dct_lookup_categories lc2 ON lc2.category_id = lv2.category_id
           WHERE  lc2.category_code = 'DT_EMPLOYEE_GRADE') lv
                                   ON lv.value_code = r.grade_code;

COMMENT ON TABLE prod.dt_rate_master_v IS 'Per diem rates with computed CURRENT/FUTURE/EXPIRED/INACTIVE status and grade display label';

-- =============================================================================
-- 6. DT_DOC_REQUIREMENTS_V
--    Document requirements enriched with document type display name.
-- =============================================================================
CREATE OR REPLACE VIEW prod.dt_doc_requirements_v AS
SELECT
  dr.doc_req_id,
  dr.mission_type,
  CASE dr.mission_type
    WHEN 'BUSINESS_MISSION' THEN 'Business Mission'
    WHEN 'TRAINING'         THEN 'Training'
    WHEN 'ALL'              THEN 'All Types'
    ELSE dr.mission_type
  END                                                         AS mission_type_label,
  dr.trip_type,
  CASE dr.trip_type
    WHEN 'INTERNAL' THEN 'Internal (UAE)'
    WHEN 'EXTERNAL' THEN 'External (International)'
    WHEN 'ALL'      THEN 'All Types'
    ELSE dr.trip_type
  END                                                         AS trip_type_label,
  dr.document_type_id,
  lv.value_name_en                                            AS document_type_name,
  dr.is_mandatory,
  dr.applies_to_source,
  CASE dr.applies_to_source
    WHEN 'REQUEST'    THEN 'Request'
    WHEN 'SETTLEMENT' THEN 'Settlement'
    WHEN 'BOTH'       THEN 'Both'
    ELSE dr.applies_to_source
  END                                                         AS applies_to_source_label,
  dr.display_seq,
  dr.is_active,
  dr.created_by,
  dr.created_at,
  dr.updated_by,
  dr.updated_at
FROM prod.dt_doc_requirements   dr
LEFT JOIN prod.dct_lookup_values lv ON lv.value_id = dr.document_type_id;

COMMENT ON TABLE prod.dt_doc_requirements_v IS 'Document requirements with document type name and decoded label columns';

-- =============================================================================
COMMIT;

PROMPT
PROMPT === 03_dt_views.sql complete ===
PROMPT Views created:
PROMPT   DT_REQUESTS_V          - Full request with employee / org / coding / lifecycle
PROMPT   DT_DESTINATIONS_V      - Legs with country name, group code, snapped rate
PROMPT   DT_SETTLEMENT_V        - Settlement with request context and employee name
PROMPT   DT_PENDING_APPROVALS_V - Active approval queue with required role
PROMPT   DT_RATE_MASTER_V       - Rate master with CURRENT/FUTURE/EXPIRED status
PROMPT   DT_DOC_REQUIREMENTS_V  - Doc requirements with document type name
PROMPT ===
