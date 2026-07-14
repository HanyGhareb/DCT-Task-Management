-- =============================================================================
-- Platform -- Sync the natural-key project-costing masters from the live budget
-- File    : 32_budget_masters_sync.sql
-- Schema  : PROD (procedure + job). Run: sql -name prod_mcp @32_budget_masters_sync.sql
--           Re-runnable (insert-where-not-exists; never updates or deletes).
-- Purpose : DCT_PROJECTS / DCT_TASKS / DCT_EXPENDITURE_TYPES are the natural-key
--           masters every module's project coding FKs to (FL contracts:
--           FK_FLCON_PROJECT / FK_FLCON_TASK / FK_FLCON_EXPTYPE). They still held
--           only the original demo seed, so NONE of the real Fusion budget lines
--           existed in them: saving a contract coded to a real project/task/
--           expenditure type died with
--              ORA-02291: integrity constraint (PROD.FK_FLCON_EXPTYPE) violated.
--           (Coverage before this script: 0 of 531 budget projects and 0 of 81
--           expenditure types were present.)
--           This seeds the masters from DCT_BUDGET_UTILIZATION_V -- the same view
--           the FL contract Budget Allocation LOVs read -- so anything a user can
--           pick is guaranteed to satisfy the FK. Existing seed rows are left
--           untouched. A nightly job keeps the masters in step with ATD reloads
--           (new projects/tasks appear in Fusion between deployments).
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE PROCEDURE prod.dct_budget_masters_sync (
    p_projects OUT NUMBER,
    p_tasks    OUT NUMBER,
    p_etypes   OUT NUMBER
) AS
-- Insert every project / task / expenditure type that the budget balances view
-- exposes but the masters do not yet carry. Insert-only: a master row that was
-- hand-maintained (names, org, manager) is never overwritten.
BEGIN
    INSERT INTO prod.dct_projects (
        project_number, project_name_en, project_type, status, is_active,
        created_by, created_at, updated_at)
    SELECT v.project_number, MAX(v.project_name), MAX(v.project_type),
           'ACTIVE', 'Y', 'BUDGET_SYNC', SYSTIMESTAMP, SYSTIMESTAMP
    FROM   prod.dct_budget_utilization_v v
    WHERE  v.project_number IS NOT NULL
    AND    v.project_name   IS NOT NULL
    AND    NOT EXISTS (SELECT 1 FROM prod.dct_projects p
                       WHERE p.project_number = v.project_number)
    GROUP BY v.project_number;
    p_projects := SQL%ROWCOUNT;

    INSERT INTO prod.dct_tasks (
        project_number, task_number, task_name_en, is_chargeable, is_active,
        created_by, created_at, updated_at)
    SELECT v.project_number, v.task_number, v.task_number, 'Y', 'Y',
           'BUDGET_SYNC', SYSTIMESTAMP, SYSTIMESTAMP
    FROM   prod.dct_budget_utilization_v v
    WHERE  v.project_number IS NOT NULL
    AND    v.task_number    IS NOT NULL
    AND    EXISTS     (SELECT 1 FROM prod.dct_projects p
                       WHERE p.project_number = v.project_number)
    AND    NOT EXISTS (SELECT 1 FROM prod.dct_tasks t
                       WHERE t.project_number = v.project_number
                       AND   t.task_number    = v.task_number)
    GROUP BY v.project_number, v.task_number;
    p_tasks := SQL%ROWCOUNT;

    -- The view's expenditure_type is the Fusion string "424521 - Manpower supply…"
    -- and IS the natural key; the readable name is the part after the code.
    INSERT INTO prod.dct_expenditure_types (
        expenditure_type, exp_type_name_en, exp_category,
        applies_to_gl, applies_to_project, is_active,
        created_by, created_at, updated_at)
    SELECT v.expenditure_type,
           SUBSTR(TRIM(REGEXP_REPLACE(v.expenditure_type, '^[0-9]+\s*-\s*', '')), 1, 300),
           'OTHER', 'Y', 'Y', 'Y', 'BUDGET_SYNC', SYSTIMESTAMP, SYSTIMESTAMP
    FROM   prod.dct_budget_utilization_v v
    WHERE  v.expenditure_type IS NOT NULL
    AND    NOT EXISTS (SELECT 1 FROM prod.dct_expenditure_types e
                       WHERE e.expenditure_type = v.expenditure_type)
    GROUP BY v.expenditure_type;
    p_etypes := SQL%ROWCOUNT;

    COMMIT;
END;
/

SHOW ERRORS

DECLARE
    v_p NUMBER; v_t NUMBER; v_e NUMBER;
BEGIN
    prod.dct_budget_masters_sync(v_p, v_t, v_e);
    DBMS_OUTPUT.PUT_LINE('synced -> projects ' || v_p || ' | tasks ' || v_t
                         || ' | expenditure types ' || v_e);
END;
/

-- Nightly top-up: ATD reloads bring new Fusion projects/tasks between deploys.
BEGIN
    BEGIN
        DBMS_SCHEDULER.DROP_JOB('PROD.DCT_BUDGET_MASTERS_SYNC_JOB', TRUE);
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => 'PROD.DCT_BUDGET_MASTERS_SYNC_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'DECLARE v_p NUMBER; v_t NUMBER; v_e NUMBER; '
                        || 'BEGIN prod.dct_budget_masters_sync(v_p, v_t, v_e); END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=DAILY; BYHOUR=2; BYMINUTE=40',
        enabled         => TRUE,
        comments        => 'Top up DCT_PROJECTS/DCT_TASKS/DCT_EXPENDITURE_TYPES from DCT_BUDGET_UTILIZATION_V');
END;
/

PROMPT === 32_budget_masters_sync.sql complete ===
