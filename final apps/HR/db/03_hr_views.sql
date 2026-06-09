-- =============================================================================
-- i-Finance V2 — HR Module: Views
-- File    : 03_hr_views.sql
-- Schema  : PROD
-- =============================================================================
-- Views:
--   1. V_HR_ORG_TREE          — recursive org hierarchy with full path + level
--   2. V_HR_HEADCOUNT          — positions: approved vs filled vs vacant
--   3. V_HR_EMPLOYEE_FULL      — employee + current assignment + contract + salary
--   4. V_HR_EXPIRING_DOCS      — documents expiring within 90 days
--   5. V_HR_ACTIVE_CONTRACTS   — active contracts with days-until-expiry
--   6. V_HR_SALARY_CURRENT     — most recent salary row per employee
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. V_HR_ORG_TREE
--    Recursive CTE that walks the DCT_ORGANIZATIONS hierarchy.
--    Returns every node with its computed level, full path, org type label,
--    and whether it is a leaf (has no children).
-- =============================================================================
CREATE OR REPLACE VIEW v_hr_org_tree AS
WITH org_cte (
    org_id, org_code, org_name_en, org_name_ar,
    org_type, org_type_id, org_type_label,
    parent_org_id, level_no, full_path,
    is_active, headcount_ceiling, location_id,
    cost_center_code, effective_from, effective_to
) AS (
    -- Anchor: root nodes (no parent)
    SELECT
        o.org_id,
        o.org_code,
        o.org_name_en,
        o.org_name_ar,
        o.org_type,
        o.org_type_id,
        NVL(lv.value_name_en, o.org_type)  AS org_type_label,
        o.parent_org_id,
        1                                   AS level_no,
        o.org_name_en                       AS full_path,
        o.is_active,
        o.headcount_ceiling,
        o.location_id,
        o.cost_center_code,
        o.effective_from,
        o.effective_to
    FROM  dct_organizations o
    LEFT JOIN dct_lookup_values lv ON lv.value_id = o.org_type_id
    WHERE o.parent_org_id IS NULL

    UNION ALL

    -- Recursive: children
    SELECT
        o.org_id,
        o.org_code,
        o.org_name_en,
        o.org_name_ar,
        o.org_type,
        o.org_type_id,
        NVL(lv.value_name_en, o.org_type),
        o.parent_org_id,
        cte.level_no + 1,
        cte.full_path || ' > ' || o.org_name_en,
        o.is_active,
        o.headcount_ceiling,
        o.location_id,
        o.cost_center_code,
        o.effective_from,
        o.effective_to
    FROM  dct_organizations o
    JOIN  org_cte cte ON cte.org_id = o.parent_org_id
    LEFT JOIN dct_lookup_values lv ON lv.value_id = o.org_type_id
)
SELECT
    cte.org_id,
    cte.org_code,
    cte.org_name_en,
    cte.org_name_ar,
    cte.org_type,
    cte.org_type_id,
    cte.org_type_label,
    cte.parent_org_id,
    cte.level_no,
    cte.full_path,
    cte.is_active,
    cte.headcount_ceiling,
    cte.location_id,
    l.location_name_en,
    cte.cost_center_code,
    cte.effective_from,
    cte.effective_to,
    -- leaf flag: 'Y' when this node has no children
    CASE WHEN EXISTS (
        SELECT 1 FROM dct_organizations c WHERE c.parent_org_id = cte.org_id
    ) THEN 'N' ELSE 'Y' END  AS is_leaf
FROM  org_cte cte
LEFT JOIN hr_locations l ON l.location_id = cte.location_id;

-- =============================================================================
-- 2. V_HR_HEADCOUNT
--    One row per active position.
--    filled_count = active primary assignments pointing to that position.
--    vacancy_count = approved_headcount - filled_count (can be negative if over-staffed).
-- =============================================================================
CREATE OR REPLACE VIEW v_hr_headcount AS
SELECT
    p.position_id,
    p.position_code,
    p.position_name_en,
    p.position_name_ar,
    p.org_id,
    o.org_name_en,
    o.org_name_ar,
    p.job_id,
    j.job_name_en,
    jf.family_name_en                              AS job_family,
    p.grade_code,
    g.grade_name_en,
    p.approved_headcount,
    COUNT(a.assignment_id)                          AS filled_count,
    p.approved_headcount - COUNT(a.assignment_id)   AS vacancy_count,
    pt.value_name_en                                AS position_type,
    p.effective_from,
    p.effective_to,
    l.location_name_en                              AS location
FROM  hr_positions p
JOIN  dct_organizations     o   ON o.org_id         = p.org_id
JOIN  hr_jobs               j   ON j.job_id         = p.job_id
LEFT JOIN hr_job_families   jf  ON jf.job_family_id = j.job_family_id
LEFT JOIN dct_employee_grades g ON g.grade_code     = p.grade_code
LEFT JOIN dct_lookup_values pt  ON pt.value_id      = p.position_type_id
LEFT JOIN hr_locations      l   ON l.location_id    = p.location_id
LEFT JOIN hr_employee_assignments a
       ON a.position_id         = p.position_id
      AND a.assignment_status   = 'ACTIVE'
      AND a.is_primary          = 'Y'
      AND a.end_date            IS NULL
WHERE p.is_active = 'Y'
GROUP BY
    p.position_id, p.position_code, p.position_name_en, p.position_name_ar,
    p.org_id, o.org_name_en, o.org_name_ar,
    p.job_id, j.job_name_en, jf.family_name_en,
    p.grade_code, g.grade_name_en,
    p.approved_headcount, pt.value_name_en,
    p.effective_from, p.effective_to, l.location_name_en;

-- =============================================================================
-- 3. V_HR_EMPLOYEE_FULL
--    Master employee view joining all HR dimensions.
--    Current assignment: ACTIVE + is_primary = Y + end_date IS NULL.
--    Current contract  : most recent row per person (by start_date DESC).
--    Current salary    : most recent row per person (by effective_date DESC).
-- =============================================================================
CREATE OR REPLACE VIEW v_hr_employee_full AS
SELECT
    -- Employee core
    e.person_id,
    e.employee_number,
    e.first_name_en,
    e.last_name_en,
    e.full_name_en,
    e.first_name_ar,
    e.last_name_ar,
    e.full_name_ar,
    e.email,
    e.personal_email,
    e.mobile,
    e.work_phone,
    e.photo_url,
    e.gender,
    e.date_of_birth,
    e.national_id,
    e.passport_number,
    e.hire_date,
    e.end_date,
    e.is_active,
    e.sync_source,
    -- Grade
    e.grade_code,
    g.grade_name_en,
    g.grade_name_ar,
    g.grade_category,
    g.grade_level,
    -- Nationality
    e.nationality_code,
    n.nationality_en,
    -- Marital status
    ms.value_name_en                                AS marital_status,
    -- Job title (employee-level, independent of assignment)
    e.job_title_en,
    e.job_title_ar,
    -- Primary org
    e.org_id,
    o.org_name_en,
    o.org_name_ar,
    -- Current assignment
    a.assignment_id,
    a.assignment_number,
    a.position_id,
    pos.position_name_en,
    a.job_id,
    j.job_name_en,
    j.job_name_ar,
    jf.family_name_en                               AS job_family,
    at_lv.value_name_en                             AS assignment_type,
    a.assignment_status,
    a.start_date                                    AS assignment_start,
    a.probation_end_date,
    a.location_id                                   AS assignment_location_id,
    al.location_name_en                             AS assignment_location,
    a.manager_person_id,
    mgr.full_name_en                                AS manager_name,
    -- Primary work location (employee-level, may differ from assignment)
    e.location_id                                   AS primary_location_id,
    pl.location_name_en                             AS primary_location,
    -- Current contract (most recent)
    c.contract_id,
    c.contract_number,
    ct.value_name_en                                AS contract_type,
    cs.value_name_en                                AS contract_status,
    c.start_date                                    AS contract_start,
    c.end_date                                      AS contract_end,
    c.probation_end_date                            AS contract_probation_end,
    -- Current salary (most recent)
    s.basic_salary,
    s.currency_code                                 AS salary_currency,
    s.effective_date                                AS salary_effective_date
FROM dct_employees e
-- Grade
LEFT JOIN dct_employee_grades   g    ON g.grade_code      = e.grade_code
-- Nationality
LEFT JOIN dct_nationality       n    ON n.nationality_code = e.nationality_code
-- Marital status lookup
LEFT JOIN dct_lookup_values     ms   ON ms.value_id       = e.marital_status_id
-- Primary org
LEFT JOIN dct_organizations     o    ON o.org_id          = e.org_id
-- Primary work location
LEFT JOIN hr_locations          pl   ON pl.location_id    = e.location_id
-- Current primary assignment
LEFT JOIN hr_employee_assignments a
       ON a.person_id           = e.person_id
      AND a.assignment_status   = 'ACTIVE'
      AND a.is_primary          = 'Y'
      AND a.end_date            IS NULL
-- Position + job + family from assignment
LEFT JOIN hr_positions          pos  ON pos.position_id   = a.position_id
LEFT JOIN hr_jobs               j    ON j.job_id          = a.job_id
LEFT JOIN hr_job_families       jf   ON jf.job_family_id  = j.job_family_id
LEFT JOIN dct_lookup_values     at_lv ON at_lv.value_id   = a.assignment_type_id
-- Assignment location
LEFT JOIN hr_locations          al   ON al.location_id    = a.location_id
-- Manager
LEFT JOIN dct_employees         mgr  ON mgr.person_id     = a.manager_person_id
-- Most recent contract
LEFT JOIN (
    SELECT c2.*,
           ROW_NUMBER() OVER (PARTITION BY c2.person_id ORDER BY c2.start_date DESC, c2.contract_id DESC) AS rn
    FROM hr_employment_contracts c2
) c ON c.person_id = e.person_id AND c.rn = 1
LEFT JOIN dct_lookup_values     ct   ON ct.value_id       = c.contract_type_id
LEFT JOIN dct_lookup_values     cs   ON cs.value_id       = c.contract_status_id
-- Most recent salary
LEFT JOIN (
    SELECT s2.person_id, s2.basic_salary, s2.currency_code, s2.effective_date,
           ROW_NUMBER() OVER (PARTITION BY s2.person_id ORDER BY s2.effective_date DESC, s2.salary_id DESC) AS rn
    FROM hr_salary_history s2
) s ON s.person_id = e.person_id AND s.rn = 1;

-- =============================================================================
-- 4. V_HR_EXPIRING_DOCS
--    Employee documents expiring within 90 days (or already expired).
--    expiry_alert: EXPIRED | CRITICAL (≤30d) | WARNING (≤60d) | UPCOMING (≤90d)
-- =============================================================================
CREATE OR REPLACE VIEW v_hr_expiring_docs AS
SELECT
    d.doc_id,
    e.person_id,
    e.employee_number,
    e.full_name_en,
    e.email,
    o.org_name_en,
    dt.doc_type_name_en                                         AS doc_type,
    dt.doc_category,
    d.doc_number,
    d.issue_date,
    d.expiry_date,
    TRUNC(d.expiry_date) - TRUNC(SYSDATE)                       AS days_until_expiry,
    CASE
        WHEN TRUNC(d.expiry_date) < TRUNC(SYSDATE)              THEN 'EXPIRED'
        WHEN TRUNC(d.expiry_date) <= TRUNC(SYSDATE) + 30        THEN 'CRITICAL'
        WHEN TRUNC(d.expiry_date) <= TRUNC(SYSDATE) + 60        THEN 'WARNING'
        ELSE                                                          'UPCOMING'
    END                                                         AS expiry_alert,
    ds.value_name_en                                            AS doc_status,
    d.issuing_authority,
    ic.country_name_en                                          AS issuing_country
FROM  hr_employee_documents d
JOIN  dct_employees         e   ON e.person_id      = d.person_id
JOIN  dct_organizations     o   ON o.org_id         = e.org_id
JOIN  dct_document_types    dt  ON dt.doc_type_id   = d.doc_type_id
LEFT JOIN dct_lookup_values ds  ON ds.value_id      = d.doc_status_id
LEFT JOIN dct_countries     ic  ON ic.country_code  = d.issuing_country_code
WHERE d.expiry_date IS NOT NULL
  AND TRUNC(d.expiry_date) <= TRUNC(SYSDATE) + 90
  AND e.is_active = 'Y';

-- =============================================================================
-- 5. V_HR_ACTIVE_CONTRACTS
--    All employment contracts joined with employee and org info.
--    Includes probation status flag and days until contract expiry.
-- =============================================================================
CREATE OR REPLACE VIEW v_hr_active_contracts AS
SELECT
    c.contract_id,
    c.contract_number,
    e.person_id,
    e.employee_number,
    e.full_name_en,
    e.full_name_ar,
    o.org_name_en,
    ct.value_name_en                                            AS contract_type,
    cs.value_name_en                                            AS contract_status,
    c.start_date,
    c.end_date,
    CASE WHEN c.end_date IS NOT NULL
         THEN TRUNC(c.end_date) - TRUNC(SYSDATE)
         ELSE NULL
    END                                                         AS days_until_expiry,
    c.probation_months,
    c.probation_end_date,
    CASE WHEN c.probation_end_date >= TRUNC(SYSDATE) THEN 'Y' ELSE 'N' END
                                                                AS in_probation,
    c.notice_period_days,
    c.signed_date,
    c.file_url,
    c.remarks
FROM  hr_employment_contracts c
JOIN  dct_employees         e   ON e.person_id      = c.person_id
JOIN  dct_organizations     o   ON o.org_id         = e.org_id
JOIN  dct_lookup_values     ct  ON ct.value_id      = c.contract_type_id
LEFT JOIN dct_lookup_values cs  ON cs.value_id      = c.contract_status_id
WHERE e.is_active = 'Y';

-- =============================================================================
-- 6. V_HR_SALARY_CURRENT
--    The single most-recent salary row per employee, joined with grade and
--    approver details. Used by reports and the employee detail page.
-- =============================================================================
CREATE OR REPLACE VIEW v_hr_salary_current AS
SELECT
    s.salary_id,
    s.person_id,
    e.employee_number,
    e.full_name_en,
    e.full_name_ar,
    o.org_name_en,
    e.grade_code,
    g.grade_name_en,
    g.grade_category,
    s.basic_salary,
    s.currency_code,
    s.effective_date,
    sr.value_name_en                                            AS change_reason,
    s.previous_basic,
    s.change_percentage,
    u.display_name                                              AS approved_by_name,
    s.remarks
FROM (
    SELECT sh.*,
           ROW_NUMBER() OVER (PARTITION BY sh.person_id ORDER BY sh.effective_date DESC, sh.salary_id DESC) AS rn
    FROM hr_salary_history sh
) s
JOIN  dct_employees         e   ON e.person_id      = s.person_id
JOIN  dct_organizations     o   ON o.org_id         = e.org_id
LEFT JOIN dct_employee_grades g ON g.grade_code     = e.grade_code
LEFT JOIN dct_lookup_values sr  ON sr.value_id      = s.change_reason_id
LEFT JOIN dct_users         u   ON u.user_id        = s.approved_by
WHERE s.rn = 1;

COMMIT;
PROMPT HR views created: V_HR_ORG_TREE, V_HR_HEADCOUNT, V_HR_EMPLOYEE_FULL,
PROMPT                   V_HR_EXPIRING_DOCS, V_HR_ACTIVE_CONTRACTS, V_HR_SALARY_CURRENT
