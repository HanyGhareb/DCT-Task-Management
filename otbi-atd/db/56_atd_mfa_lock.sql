-- Fleet-wide MFA serialization. Only fresh logins take this lease; session reuse does not.
-- Lease expiry prevents a crashed worker from blocking the fleet permanently.
SET DEFINE OFF
SET SERVEROUTPUT ON

BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.atd_mfa_lock (
      lock_name      VARCHAR2(30) PRIMARY KEY,
      owner_worker   VARCHAR2(120),
      acquired_at    TIMESTAMP WITH TIME ZONE,
      lease_expires  TIMESTAMP WITH TIME ZONE
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

MERGE INTO prod.atd_mfa_lock t
USING (SELECT 'FUSION_MFA' lock_name FROM dual) s
ON (t.lock_name=s.lock_name)
WHEN NOT MATCHED THEN INSERT (lock_name) VALUES (s.lock_name);
COMMIT;

CREATE OR REPLACE SYNONYM atd_mfa_lock FOR prod.atd_mfa_lock;

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_MFA_SLOT_WAIT' config_key FROM dual) s
ON (t.config_key=s.config_key)
WHEN NOT MATCHED THEN INSERT
  (config_key,config_value,value_type,description,display_order)
  VALUES ('ATD_MFA_SLOT_WAIT','1200','NUMBER',
          'Maximum seconds a worker waits for another worker to finish MFA',25);
COMMIT;
