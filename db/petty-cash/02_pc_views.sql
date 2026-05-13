-- =============================================================================
-- Petty Cash Module — Views
-- File    : 02_pc_views.sql
-- Schema  : PROD
-- DB      : Oracle 23ai
-- Module  : PETTY_CASH (f101)
-- Depends : 01_pc_ddl.sql
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

-- =============================================================================
-- 1. DCT_PROJECT_BUDGET_V
--    Exposes project / task / expenditure type combinations with live budget
--    balances. Used as the LOV source for Project-level budget coding and to
--    display fund availability to the employee before confirming a line amount.
--
--    Source tables (external — must exist in the same schema or via DB link):
--      PROJECTS                  project master
--      PROJECT_TASKS             tasks under each project
--      PROJECT_EXPENDITURE_TYPES expenditure type definitions per project/task
--      PROJECT_BALANCES          budget, actual, encumbrance per combination
--
--    NOTE: Adjust table/column names below to match the actual source schema.
--    FUND_AVAILABLE = BUDGET - ACTUAL - ENCUMBRANCE
-- =============================================================================
CREATE OR REPLACE FORCE VIEW dct_project_budget_v AS
SELECT
    p.project_number,
    p.project_name,
    pt.task_number,
    pt.task_name,
    pet.expenditure_type,
    pet.expenditure_type_desc,
    pb.budget,
    pb.actual,
    pb.encumbrance,
    (pb.budget - pb.actual - pb.encumbrance) AS fund_available
FROM
    projects                  p
    JOIN project_tasks         pt  ON pt.project_number  = p.project_number
    JOIN project_expenditure_types pet ON pet.project_number = p.project_number
                                      AND pet.task_number   = pt.task_number
    JOIN project_balances      pb  ON pb.project_number  = p.project_number
                                  AND pb.task_number     = pt.task_number
                                  AND pb.expenditure_type = pet.expenditure_type
WHERE
    p.project_status  = 'ACTIVE'
    AND pt.task_status = 'ACTIVE'
;

COMMENT ON TABLE dct_project_budget_v IS 'Petty Cash: Read-only view of project/task/expenditure combinations with live budget balances (budget, actual, encumbrance, fund_available). Used for Project-level budget coding LOVs.';
COMMENT ON COLUMN dct_project_budget_v.fund_available IS 'Calculated: BUDGET - ACTUAL - ENCUMBRANCE. Displayed to the employee when selecting project coding. Compared against line amount per BUDGET_VALIDATION_MODE setting (HARD=block / SOFT=warn).';

-- =============================================================================
-- 2. DCT_PC_SUMMARY_V
--    Employee-facing summary: one row per petty cash showing the advance
--    amount, total reimbursed to date, and remaining float balance.
-- =============================================================================
CREATE OR REPLACE VIEW dct_pc_summary_v AS
SELECT
    pc.pc_id,
    pc.pc_number,
    pc.pc_type,
    pc.user_id,
    pc.employee_num,
    pc.org_id,
    pc.amount                                          AS advance_amount,
    pc.coding_type,
    pc.status,
    pc.fiscal_year,
    pc.due_date,
    pc.disbursed_date,
    pc.submitted_at,
    pc.created_at,
    NVL(reimb.total_reimbursed, 0)                    AS total_reimbursed,
    NVL(clr.amount_spent, 0)                          AS cleared_amount,
    NVL(clr.amount_refunded, 0)                       AS refunded_amount,
    (pc.amount - NVL(reimb.total_reimbursed, 0))      AS current_float_balance,
    CASE
        WHEN pc.status = 'ACTIVE' AND clr.clearing_id IS NOT NULL THEN 'CLEARING_IN_PROGRESS'
        ELSE pc.status
    END                                                AS display_status,
    clr.clearing_id,
    clr.status                                         AS clearing_status
FROM
    dct_petty_cash pc
    LEFT JOIN (
        SELECT pc_id,
               SUM(amount) AS total_reimbursed
        FROM   dct_pc_reimbursements
        WHERE  status = 'APPROVED'
        GROUP BY pc_id
    ) reimb ON reimb.pc_id = pc.pc_id
    LEFT JOIN dct_pc_clearing clr ON clr.pc_id = pc.pc_id
                                 AND clr.status NOT IN ('REJECTED','CANCELLED')
;

COMMENT ON TABLE  dct_pc_summary_v              IS 'Petty Cash: Employee-facing summary view. Shows advance amount, total reimbursed, cleared/refunded amounts, and current float balance.';
COMMENT ON COLUMN dct_pc_summary_v.total_reimbursed    IS 'Sum of all APPROVED reimbursement requests against this petty cash.';
COMMENT ON COLUMN dct_pc_summary_v.current_float_balance IS 'advance_amount minus total_reimbursed — the remaining float in the employee hands.';

-- =============================================================================
-- 3. DCT_PC_ADMIN_V
--    AP_PETTY_CASH_ADMIN view: org-wide petty cash with employee and org names.
-- =============================================================================
CREATE OR REPLACE VIEW dct_pc_admin_v AS
SELECT
    pc.pc_id,
    pc.pc_number,
    pc.pc_type,
    pc.user_id,
    u.display_name                                     AS employee_name,
    u.employee_number,
    pc.org_id,
    o.org_name_en                                      AS org_name,
    pc.amount                                          AS advance_amount,
    pc.coding_type,
    pc.status,
    pc.fiscal_year,
    pc.due_date,
    pc.disbursed_date,
    pc.closed_date,
    pc.submitted_at,
    pc.created_at,
    NVL(reimb.total_reimbursed, 0)                    AS total_reimbursed,
    NVL(clr.amount_spent, 0)                          AS cleared_amount,
    NVL(clr.amount_refunded, 0)                       AS refunded_amount,
    clr.clearing_id,
    clr.status                                         AS clearing_status
FROM
    dct_petty_cash     pc
    JOIN  dct_users         u   ON u.user_id  = pc.user_id
    LEFT JOIN dct_organizations o   ON o.org_id   = pc.org_id
    LEFT JOIN (
        SELECT pc_id, SUM(amount) AS total_reimbursed
        FROM   dct_pc_reimbursements
        WHERE  status = 'APPROVED'
        GROUP BY pc_id
    ) reimb ON reimb.pc_id = pc.pc_id
    LEFT JOIN dct_pc_clearing clr ON clr.pc_id = pc.pc_id
                                 AND clr.status NOT IN ('REJECTED','CANCELLED')
;

COMMENT ON TABLE dct_pc_admin_v IS 'Petty Cash: Admin view of all petty cash records with employee name, org name, and aggregated amounts. Visible to AP_PETTY_CASH_ADMIN role.';

COMMIT;
-- End of 02_pc_views.sql
