-- =============================================================================
-- Credit Cards Module (App 202) — Views
-- File    : 02_cc_views.sql
-- Schema  : PROD
-- Run     : After 01_cc_ddl.sql
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. DCT_CC_CARD_V — Card registry with employee and org display names
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_cc_card_v AS
SELECT
  cc.cc_id,
  cc.cc_number,
  cc.holder_user_id,
  u.display_name                        AS holder_name,
  u.employee_number                     AS employee_num,
  u.username                            AS username,
  cc.mother_name,
  cc.nationality,
  cc.credit_limit,
  cc.expiry_date,
  cc.email,
  cc.org_id,
  o.org_name_en                         AS org_name,
  cc.cost_center,
  cc.bank_name,
  cc.bank_customer_yn,
  cc.bank_mobile_yn,
  cc.bank_email_yn,
  cc.status,
  cc.notes,
  cc.approval_instance_id,
  cc.created_by,
  cc.created_at,
  cc.updated_by,
  cc.updated_at
FROM prod.dct_credit_cards cc
JOIN prod.dct_users         u  ON u.user_id = cc.holder_user_id
JOIN prod.dct_organizations o  ON o.org_id  = cc.org_id;

COMMENT ON TABLE prod.dct_cc_card_v IS 'Card registry enriched with cardholder name, employee number, and organization name';

-- =============================================================================
-- 2. DCT_CC_REQUEST_V — Card requests with cardholder and card context
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_cc_request_v AS
SELECT
  r.request_id,
  r.request_number,
  r.cc_id,
  cc.cc_number,
  cc.holder_user_id,
  u.display_name                        AS holder_name,
  u.employee_number                     AS employee_num,
  r.request_type,
  r.requested_limit,
  r.reason,
  r.replacement_reason,
  r.status,
  r.approval_instance_id,
  r.submitted_at,
  r.created_by,
  cr.display_name                       AS created_by_name,
  r.created_at,
  r.updated_by,
  r.updated_at
FROM prod.dct_cc_requests      r
LEFT JOIN prod.dct_credit_cards cc  ON cc.cc_id   = r.cc_id
LEFT JOIN prod.dct_users        u   ON u.user_id  = cc.holder_user_id
LEFT JOIN prod.dct_users        cr  ON cr.user_id = r.created_by;

COMMENT ON TABLE prod.dct_cc_request_v IS 'Card requests with card and cardholder context — LEFT JOIN so NEW_CARD requests (no cc_id) appear';

-- =============================================================================
-- 3. DCT_CC_REPLENISHMENT_V — Monthly replenishments with card and submitter info
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_cc_replenishment_v AS
SELECT
  r.replenishment_id,
  r.reimb_number,
  r.cc_id,
  cc.cc_number,
  r.period_month,
  r.period_year,
  TO_CHAR(TO_DATE(r.period_month || '/01/' || r.period_year, 'MM/DD/YYYY'), 'Mon YYYY')
                                        AS period_label,
  r.total_amount,
  r.submitted_by_user_id,
  sub.display_name                      AS submitted_by_name,
  r.on_behalf_of_user_id,
  own.display_name                      AS on_behalf_of_name,
  own.employee_number                   AS owner_employee_num,
  r.coding_type,
  r.cc_id_gl,
  r.project_number,
  r.task_number,
  r.expenditure_type,
  r.status,
  r.approval_instance_id,
  r.submitted_at,
  r.created_by,
  r.created_at,
  r.updated_by,
  r.updated_at,
  -- Derived: line count and sum for validation display
  (SELECT COUNT(*) FROM prod.dct_cc_reimb_lines l WHERE l.replenishment_id = r.replenishment_id)
                                        AS line_count,
  (SELECT NVL(SUM(l.amount),0) FROM prod.dct_cc_reimb_lines l WHERE l.replenishment_id = r.replenishment_id)
                                        AS lines_total
FROM prod.dct_cc_replenishments r
JOIN prod.dct_credit_cards      cc  ON cc.cc_id   = r.cc_id
JOIN prod.dct_users             sub ON sub.user_id = r.submitted_by_user_id
JOIN prod.dct_users             own ON own.user_id = r.on_behalf_of_user_id;

COMMENT ON TABLE prod.dct_cc_replenishment_v IS 'Monthly replenishment headers with card, submitter, owner context and line summary';

-- =============================================================================
-- 4. DCT_CC_PENDING_REPLENISHMENT_V — Cards with missing replenishment this month
--    Drives the "due" banner and admin overdue report
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_cc_pending_replenishment_v AS
SELECT
  cc.cc_id,
  cc.cc_number,
  cc.holder_user_id,
  u.display_name                        AS holder_name,
  u.employee_number                     AS employee_num,
  cc.org_id,
  o.org_name_en                         AS org_name,
  EXTRACT(MONTH FROM SYSDATE)           AS current_month,
  EXTRACT(YEAR  FROM SYSDATE)           AS current_year
FROM prod.dct_credit_cards  cc
JOIN prod.dct_users         u   ON u.user_id = cc.holder_user_id
JOIN prod.dct_organizations o   ON o.org_id  = cc.org_id
WHERE cc.status = 'ACTIVE'
AND NOT EXISTS (
  SELECT 1
  FROM prod.dct_cc_replenishments r
  WHERE r.cc_id        = cc.cc_id
  AND   r.period_month = EXTRACT(MONTH FROM SYSDATE)
  AND   r.period_year  = EXTRACT(YEAR  FROM SYSDATE)
  AND   r.status       NOT IN ('REJECTED')
);

COMMENT ON TABLE prod.dct_cc_pending_replenishment_v IS 'Active cards that have no non-rejected replenishment for the current month';

-- =============================================================================
-- 5. DCT_CC_ACTIVE_PROXY_V — Currently active proxies for replenishment submission
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_cc_active_proxy_v AS
SELECT
  p.proxy_id,
  p.cc_id,
  cc.cc_number,
  cc.holder_user_id,
  own.display_name                      AS owner_name,
  p.proxy_user_id,
  prx.display_name                      AS proxy_name,
  prx.employee_number                   AS proxy_employee_num,
  p.start_date,
  p.end_date,
  p.is_active
FROM prod.dct_cc_proxies    p
JOIN prod.dct_credit_cards  cc  ON cc.cc_id   = p.cc_id
JOIN prod.dct_users         own ON own.user_id = cc.holder_user_id
JOIN prod.dct_users         prx ON prx.user_id = p.proxy_user_id
WHERE p.is_active = 'Y'
AND   p.start_date <= SYSDATE
AND   (p.end_date IS NULL OR p.end_date >= SYSDATE);

COMMENT ON TABLE prod.dct_cc_active_proxy_v IS 'Currently active proxy assignments — used to determine who can submit on behalf of a card owner';

-- =============================================================================
-- 6. DCT_CC_DELEGATION_V — CC-scoped approver delegations via V2 shared table
--    Backed by DCT_DELEGATIONS (scope='MODULE', module_code='CREDIT_CARDS').
--    Use this view for all CC delegation queries instead of a module-local table.
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_cc_delegation_v AS
SELECT
  d.delegation_id,
  d.delegator_id                          AS delegator_user_id,
  delegator.display_name                  AS delegator_name,
  d.delegate_id                           AS delegate_user_id,
  delegate.display_name                   AS delegate_name,
  d.start_date,
  d.end_date,
  d.reason,
  d.status,
  CASE d.status WHEN 'ACTIVE' THEN 'Y' ELSE 'N' END AS is_active,
  d.approved_by,
  d.approved_at,
  d.created_by,
  d.created_at,
  d.updated_by,
  d.updated_at
FROM   prod.dct_delegations  d
JOIN   prod.dct_modules      m          ON m.module_id  = d.module_id
JOIN   prod.dct_users        delegator  ON delegator.user_id = d.delegator_id
JOIN   prod.dct_users        delegate   ON delegate.user_id  = d.delegate_id
WHERE  d.scope       = 'MODULE'
AND    m.module_code = 'CREDIT_CARDS';

COMMENT ON TABLE prod.dct_cc_delegation_v IS 'CC-scoped approver delegations — window into V2 DCT_DELEGATIONS (scope=MODULE, module=CREDIT_CARDS)';

COMMIT;

PROMPT
PROMPT === 02_cc_views.sql complete ===
PROMPT Views created: DCT_CC_CARD_V, DCT_CC_REQUEST_V, DCT_CC_REPLENISHMENT_V,
PROMPT                DCT_CC_PENDING_REPLENISHMENT_V, DCT_CC_ACTIVE_PROXY_V,
PROMPT                DCT_CC_DELEGATION_V
