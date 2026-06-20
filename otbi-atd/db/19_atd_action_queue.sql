-- ===========================================================================
-- otbi-atd : 19 action queue (Fusion write-back actions, generic framework)
-- The inverse of the extract jobs: a queue of ACTIONS to perform INSIDE Fusion
-- (first action_type = AP_INVOICE, from approved Petty Cash reimbursements).
-- The action worker (runner.py --actions) drains this queue with the same
-- SELECT ... FOR UPDATE SKIP LOCKED claim used by ATD_QUEUE_PKG, reusing the
-- shared browser session + .otbi_runner.lock, and writes the result back.
--
--   run_status  READY | CLAIMED | DONE | FAILED | CANCELLED
--   idem_key    natural dedupe key (AP_INVOICE -> the Fusion invoice number);
--               UNIQUE so enqueue is safe to call many times for one source row
--   payload_json fully-resolved invoice header+lines (runner needs no DB joins)
--
-- Lookup-first: action_type / status vocabularies live in DCT_LOOKUP_VALUES
-- (seeded below). run_status keeps a light CHECK like ATD_OTBI_JOBS because it
-- is an internal queue lifecycle, not a business enum.
-- Rerunnable. Schema-qualified PROD. CRLF + UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

-- ---------------------------------------------------------------------------
-- Table : ATD_ACTION_REQUEST
-- ---------------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.atd_action_request CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE prod.atd_action_request (
  action_id         NUMBER GENERATED ALWAYS AS IDENTITY,
  action_type       VARCHAR2(30)  NOT NULL,            -- AP_INVOICE (first); future: PAYMENT, JOURNAL ...
  env_name          VARCHAR2(60),                      -- which Fusion env to act in (FK ATD_OTBI_ENV)
  source_module     VARCHAR2(20),                      -- PC
  source_type       VARCHAR2(30),                      -- PC_REIMB
  source_id         NUMBER,                            -- reimb_id
  source_ref        VARCHAR2(200),                     -- reimb_number (human readable)
  idem_key          VARCHAR2(200) NOT NULL,            -- dedupe key (= Fusion invoice number)
  payload_json      CLOB,                              -- resolved invoice header + lines
  run_status        VARCHAR2(12)  DEFAULT 'READY' NOT NULL,
  priority          NUMBER        DEFAULT 100 NOT NULL,
  claimed_by        VARCHAR2(120),
  claimed_at        TIMESTAMP,
  attempts          NUMBER        DEFAULT 0 NOT NULL,
  max_attempts      NUMBER        DEFAULT 3 NOT NULL,
  last_error        VARCHAR2(4000),
  fusion_invoice_id VARCHAR2(60),                      -- Fusion InvoiceId read back after save
  fusion_ref        VARCHAR2(200),                     -- optional secondary ref
  last_run_id       NUMBER,
  created_by        VARCHAR2(120),
  created_at        TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
  updated_at        TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT pk_atd_action_request PRIMARY KEY (action_id),
  CONSTRAINT uq_atd_action_idem    UNIQUE (idem_key),
  CONSTRAINT fk_atd_action_env     FOREIGN KEY (env_name) REFERENCES prod.atd_otbi_env (env_name),
  CONSTRAINT ck_atd_action_status  CHECK (run_status IN ('READY','CLAIMED','DONE','FAILED','CANCELLED')),
  CONSTRAINT ck_atd_action_pjson   CHECK (payload_json IS NULL OR payload_json IS JSON)
);

-- claim-probe index (mirror ix_atd_jobs_claim)
CREATE INDEX prod.ix_atd_action_claim  ON prod.atd_action_request (run_status, priority, action_id);
CREATE INDEX prod.ix_atd_action_source ON prod.atd_action_request (source_module, source_type, source_id);

-- ---------------------------------------------------------------------------
-- Package : ATD_ACTION_PKG  (queue claim + result + idempotent enqueue)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE prod.atd_action_pkg AS
  -- Idempotently enqueue (or re-arm) an action keyed by p_idem_key. A DONE row
  -- is left untouched (never re-created); a FAILED/CANCELLED row is reset to
  -- READY. Returns the action_id.
  FUNCTION enqueue_action(
    p_action_type   VARCHAR2,
    p_source_module VARCHAR2,
    p_source_type   VARCHAR2,
    p_source_id     NUMBER,
    p_source_ref    VARCHAR2,
    p_idem_key      VARCHAR2,
    p_payload       CLOB,
    p_env_name      VARCHAR2 DEFAULT NULL,
    p_created_by    VARCHAR2 DEFAULT NULL
  ) RETURN NUMBER;

  -- Atomically lease the next READY action to p_host (SKIP LOCKED); bumps
  -- attempts. Returns action_id or NULL when the queue is empty.
  FUNCTION claim_next_action(p_host VARCHAR2) RETURN NUMBER;

  -- Return CLAIMED actions whose lease passed p_lease_minutes back to READY.
  FUNCTION reap_stale_actions(p_lease_minutes NUMBER DEFAULT 30) RETURN NUMBER;

  -- Mark a claimed action DONE with the Fusion invoice id / ref read back.
  PROCEDURE mark_action_done(p_id NUMBER, p_invoice_id VARCHAR2, p_ref VARCHAR2 DEFAULT NULL);

  -- Mark a claimed action FAILED; retried (-> READY) while attempts < max_attempts.
  PROCEDURE mark_action_failed(p_id NUMBER, p_err VARCHAR2);

  -- Operator cancel (anything not already DONE).
  PROCEDURE cancel_action(p_id NUMBER);
END atd_action_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.atd_action_pkg AS

  FUNCTION enqueue_action(
    p_action_type   VARCHAR2,
    p_source_module VARCHAR2,
    p_source_type   VARCHAR2,
    p_source_id     NUMBER,
    p_source_ref    VARCHAR2,
    p_idem_key      VARCHAR2,
    p_payload       CLOB,
    p_env_name      VARCHAR2 DEFAULT NULL,
    p_created_by    VARCHAR2 DEFAULT NULL
  ) RETURN NUMBER IS
    v_id NUMBER;
  BEGIN
    MERGE INTO prod.atd_action_request t
    USING (SELECT p_idem_key AS idem_key FROM dual) s
    ON (t.idem_key = s.idem_key)
    WHEN MATCHED THEN
      UPDATE SET payload_json  = p_payload,
                 source_ref    = p_source_ref,
                 env_name      = NVL(p_env_name, t.env_name),
                 last_error    = NULL,
                 claimed_by    = NULL,
                 claimed_at    = NULL,
                 attempts      = 0,
                 run_status    = CASE WHEN t.run_status IN ('FAILED','CANCELLED')
                                      THEN 'READY' ELSE t.run_status END,
                 updated_at    = SYSTIMESTAMP
      WHERE  t.run_status <> 'DONE'
    WHEN NOT MATCHED THEN
      INSERT (action_type, env_name, source_module, source_type, source_id,
              source_ref, idem_key, payload_json, run_status, created_by)
      VALUES (p_action_type, p_env_name, p_source_module, p_source_type, p_source_id,
              p_source_ref, p_idem_key, p_payload, 'READY', p_created_by);

    SELECT action_id INTO v_id FROM prod.atd_action_request WHERE idem_key = p_idem_key;
    COMMIT;
    RETURN v_id;
  END enqueue_action;

  FUNCTION claim_next_action(p_host VARCHAR2) RETURN NUMBER IS
    CURSOR c IS
      SELECT action_id FROM prod.atd_action_request
       WHERE run_status = 'READY'
       ORDER BY priority, action_id
       FOR UPDATE SKIP LOCKED;
    v_id prod.atd_action_request.action_id%TYPE;
  BEGIN
    OPEN c;
    FETCH c INTO v_id;
    IF c%FOUND THEN
      UPDATE prod.atd_action_request
         SET run_status = 'CLAIMED', claimed_by = p_host,
             claimed_at = CAST(SYSTIMESTAMP AS TIMESTAMP),
             attempts   = attempts + 1,
             updated_at = SYSTIMESTAMP
       WHERE action_id = v_id;
    END IF;
    CLOSE c;
    COMMIT;                 -- releases the row lock; CLAIMED now owns it
    RETURN v_id;           -- NULL when the queue is empty
  END claim_next_action;

  FUNCTION reap_stale_actions(p_lease_minutes NUMBER DEFAULT 30) RETURN NUMBER IS
    n NUMBER;
  BEGIN
    UPDATE prod.atd_action_request
       SET run_status = 'READY', claimed_by = NULL, claimed_at = NULL,
           updated_at = SYSTIMESTAMP
     WHERE run_status = 'CLAIMED'
       AND claimed_at < CAST(SYSTIMESTAMP AS TIMESTAMP)
                        - NUMTODSINTERVAL(NVL(p_lease_minutes,30), 'MINUTE');
    n := SQL%ROWCOUNT;
    COMMIT;
    RETURN n;
  END reap_stale_actions;

  PROCEDURE mark_action_done(p_id NUMBER, p_invoice_id VARCHAR2, p_ref VARCHAR2 DEFAULT NULL) IS
  BEGIN
    UPDATE prod.atd_action_request
       SET run_status        = 'DONE',
           fusion_invoice_id = p_invoice_id,
           fusion_ref        = NVL(p_ref, fusion_ref),
           last_error        = NULL,
           claimed_by        = NULL,
           claimed_at        = NULL,
           updated_at        = SYSTIMESTAMP
     WHERE action_id = p_id;
    COMMIT;
  END mark_action_done;

  PROCEDURE mark_action_failed(p_id NUMBER, p_err VARCHAR2) IS
  BEGIN
    UPDATE prod.atd_action_request
       SET run_status = CASE WHEN attempts < max_attempts THEN 'READY' ELSE 'FAILED' END,
           last_error = SUBSTR(p_err, 1, 4000),
           claimed_by = NULL,
           claimed_at = NULL,
           updated_at = SYSTIMESTAMP
     WHERE action_id = p_id;
    COMMIT;
  END mark_action_failed;

  PROCEDURE cancel_action(p_id NUMBER) IS
  BEGIN
    UPDATE prod.atd_action_request
       SET run_status = 'CANCELLED',
           claimed_by = NULL,
           claimed_at = NULL,
           updated_at = SYSTIMESTAMP
     WHERE action_id = p_id AND run_status <> 'DONE';
    COMMIT;
  END cancel_action;

END atd_action_pkg;
/

-- ---------------------------------------------------------------------------
-- Lookup-first vocabularies (action type + status) for the App 208 UI
-- ---------------------------------------------------------------------------
DECLARE
  v_cat NUMBER;
  PROCEDURE upsert_category(p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, o_id OUT NUMBER) IS
  BEGIN
    MERGE INTO prod.dct_lookup_categories t
    USING (SELECT p_code AS category_code FROM dual) s
    ON (t.category_code = s.category_code)
    WHEN NOT MATCHED THEN
      INSERT (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
      VALUES (p_code, p_en, p_ar, NULL, 'Y', 'Y')
    WHEN MATCHED THEN
      UPDATE SET category_name_en = p_en, category_name_ar = p_ar;
    SELECT category_id INTO o_id FROM prod.dct_lookup_categories WHERE category_code = p_code;
  END;
  PROCEDURE upsert_value(p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_ord NUMBER, p_default VARCHAR2 DEFAULT 'N') IS
  BEGIN
    MERGE INTO prod.dct_lookup_values t
    USING (SELECT p_cat AS category_id, p_code AS value_code FROM dual) s
    ON (t.category_id = s.category_id AND t.value_code = s.value_code)
    WHEN NOT MATCHED THEN
      INSERT (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
      VALUES (p_cat, p_code, p_en, p_ar, p_ord, p_default, 'Y')
    WHEN MATCHED THEN
      UPDATE SET value_name_en = p_en, value_name_ar = p_ar, display_order = p_ord;
  END;
BEGIN
  upsert_category('ATD_ACTION_TYPE', 'ATD Action Type', 'نوع إجراء الموزع', v_cat);
  upsert_value(v_cat, 'AP_INVOICE', 'AP Invoice', 'فاتورة دائنين', 10, 'Y');

  upsert_category('ATD_ACTION_STATUS', 'ATD Action Status', 'حالة الإجراء', v_cat);
  upsert_value(v_cat, 'READY',     'Ready',     'جاهز',    10, 'Y');
  upsert_value(v_cat, 'CLAIMED',   'Claimed',   'محجوز',   20);
  upsert_value(v_cat, 'DONE',      'Done',      'منجز',    30);
  upsert_value(v_cat, 'FAILED',    'Failed',    'فشل',     40);
  upsert_value(v_cat, 'CANCELLED', 'Cancelled', 'ملغى',    50);
  COMMIT;
END;
/

-- ---------------------------------------------------------------------------
-- ADMIN -> PROD synonyms (ORDS handlers + runner execute as ADMIN).
-- Safe here: this script never ALTERs CURRENT_SCHEMA, so no ORA-01471.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE SYNONYM atd_action_request FOR prod.atd_action_request;
CREATE OR REPLACE SYNONYM atd_action_pkg     FOR prod.atd_action_pkg;

SET ECHO OFF
PROMPT otbi-atd 19 action queue : done
