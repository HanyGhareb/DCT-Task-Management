-- =============================================================================
-- Credit Cards Module — Add DCT_CC_CARD_LIMIT_HISTORY
-- File    : 06_cc_card_limit_history.sql
-- Schema  : PROD
-- Run     : After 05_cc_alter_audit_cols.sql (one-time; idempotent — safe to re-run)
-- Purpose : Creates the credit limit change history table if it does not exist.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

DECLARE
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists
    FROM   all_tables
    WHERE  owner      = 'PROD'
    AND    table_name = 'DCT_CC_CARD_LIMIT_HISTORY';

    IF v_exists = 0 THEN
        EXECUTE IMMEDIATE q'[
            CREATE TABLE prod.dct_cc_card_limit_history (
              history_id           NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
              cc_id                NUMBER          NOT NULL,
              old_limit            NUMBER(15,2)    NOT NULL,
              new_limit            NUMBER(15,2)    NOT NULL,
              change_type          VARCHAR2(20)    NOT NULL,
              request_id           NUMBER,
              changed_at           DATE            DEFAULT SYSDATE NOT NULL,
              changed_by           VARCHAR2(100),
              notes                VARCHAR2(500),
              CONSTRAINT chk_dct_cclh_type      CHECK (change_type IN ('INITIAL','INCREASE','DECREASE')),
              CONSTRAINT chk_dct_cclh_old_limit CHECK (old_limit >= 0),
              CONSTRAINT chk_dct_cclh_new_limit CHECK (new_limit > 0),
              CONSTRAINT fk_dct_cclh_cc         FOREIGN KEY (cc_id)
                                                   REFERENCES prod.dct_credit_cards(cc_id),
              CONSTRAINT fk_dct_cclh_request    FOREIGN KEY (request_id)
                                                   REFERENCES prod.dct_cc_requests(request_id)
            )
        ]';

        EXECUTE IMMEDIATE
            'CREATE INDEX idx_dct_cclh_cc ON prod.dct_cc_card_limit_history(cc_id, changed_at)';
        EXECUTE IMMEDIATE
            'CREATE INDEX idx_dct_cclh_request ON prod.dct_cc_card_limit_history(request_id)';

        EXECUTE IMMEDIATE q'[COMMENT ON TABLE prod.dct_cc_card_limit_history IS
            'Immutable audit trail of every credit limit change per card']';
        EXECUTE IMMEDIATE q'[COMMENT ON COLUMN prod.dct_cc_card_limit_history.change_type IS
            'INITIAL = first recorded limit on card issuance; INCREASE/DECREASE = limit change request approved']';
        EXECUTE IMMEDIATE q'[COMMENT ON COLUMN prod.dct_cc_card_limit_history.request_id IS
            'NULL for INITIAL entries; FK to DCT_CC_REQUESTS for INCREASE/DECREASE']';
        EXECUTE IMMEDIATE q'[COMMENT ON COLUMN prod.dct_cc_card_limit_history.old_limit IS
            '0 for INITIAL entries (no prior limit)']';
        EXECUTE IMMEDIATE q'[COMMENT ON COLUMN prod.dct_cc_card_limit_history.changed_by IS
            'APEX APP_USER of the CC admin who approved/applied the change']';

        DBMS_OUTPUT.PUT_LINE('OK: DCT_CC_CARD_LIMIT_HISTORY created.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('SKIP: DCT_CC_CARD_LIMIT_HISTORY already exists.');
    END IF;
END;
/

PROMPT === 06_cc_card_limit_history.sql complete ===
