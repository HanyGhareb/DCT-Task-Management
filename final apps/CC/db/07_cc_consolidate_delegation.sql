-- =============================================================================
-- Credit Cards Module — Consolidate DCT_CC_DELEGATION into V2 DCT_DELEGATIONS
-- File    : 07_cc_consolidate_delegation.sql
-- Schema  : PROD
-- Run     : After 06_cc_card_limit_history.sql (one-time; idempotent — safe to re-run)
-- What    : Drops the module-local DCT_CC_DELEGATION table (no FK dependents,
--           0 data rows on all known installs) and creates DCT_CC_DELEGATION_V
--           as a CC-scoped view over the shared V2 DCT_DELEGATIONS table.
--
-- New insert pattern (replaces INSERT INTO dct_cc_delegation):
--   INSERT INTO prod.dct_delegations
--     (delegator_id, delegate_id, scope, module_id,
--      start_date, end_date, reason, created_by)
--   VALUES
--     (:delegator_user_id, :delegate_user_id, 'MODULE',
--      (SELECT module_id FROM prod.dct_modules WHERE module_code = 'CREDIT_CARDS'),
--      :start_date, :end_date, :reason, :app_user);
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

-- -----------------------------------------------------------------------------
-- 1. Drop DCT_CC_DELEGATION (and its trigger) if they still exist
-- -----------------------------------------------------------------------------
DECLARE
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists
    FROM   all_tables
    WHERE  owner      = 'PROD'
    AND    table_name = 'DCT_CC_DELEGATION';

    IF v_exists > 0 THEN
        -- Drop trigger first (not strictly required — CASCADE CONSTRAINTS on the
        -- table drop doesn't remove triggers; drop explicitly to keep it clean)
        BEGIN
            EXECUTE IMMEDIATE
                'DROP TRIGGER prod.trg_dct_cc_delegation_upd';
            DBMS_OUTPUT.PUT_LINE('  trigger trg_dct_cc_delegation_upd dropped.');
        EXCEPTION WHEN OTHERS THEN
            IF SQLCODE = -4080 THEN  -- ORA-04080: trigger does not exist
                DBMS_OUTPUT.PUT_LINE('  trigger already gone — skip.');
            ELSE RAISE;
            END IF;
        END;

        EXECUTE IMMEDIATE
            'DROP TABLE prod.dct_cc_delegation CASCADE CONSTRAINTS PURGE';
        DBMS_OUTPUT.PUT_LINE('OK: DCT_CC_DELEGATION dropped.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('SKIP: DCT_CC_DELEGATION does not exist.');
    END IF;
END;
/

-- -----------------------------------------------------------------------------
-- 2. Create (or replace) DCT_CC_DELEGATION_V
--    CC-scoped window into the shared V2 DCT_DELEGATIONS table.
-- -----------------------------------------------------------------------------
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

PROMPT === 07_cc_consolidate_delegation.sql complete ===
