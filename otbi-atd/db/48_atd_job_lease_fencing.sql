-- ===========================================================================
-- otbi-atd : renewable extract-job leases + claim-token fencing
-- Additive and rerunnable. Existing queue rows remain valid.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_otbi_jobs ADD (claim_token VARCHAR2(64))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_otbi_jobs ADD (lease_expires_at TIMESTAMP)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/

-- Rebuild the canonical queue package with the new lease contract.
@@12_atd_job_queue.sql

DECLARE
  l_errors PLS_INTEGER;
BEGIN
  SELECT COUNT(*) INTO l_errors
    FROM all_errors
   WHERE owner='PROD' AND name='ATD_QUEUE_PKG';
  IF l_errors > 0 THEN
    RAISE_APPLICATION_ERROR(-20062, 'ATD_QUEUE_PKG compiled with errors');
  END IF;
END;
/

PROMPT otbi-atd 48 renewable job leases : done
WHENEVER SQLERROR CONTINUE
