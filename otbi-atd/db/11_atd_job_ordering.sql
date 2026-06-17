-- ===========================================================================
-- otbi-atd : 11 job ordering columns
-- Adds explicit execution control to ATD_OTBI_JOBS:
--   priority   - band (lower number = runs earlier); default 5
--   run_order  - sequence within a priority band (ascending); default 100
-- Final run order = ORDER BY priority, run_order, job_name.
-- Rerunnable (ADD COLUMN guarded against ORA-01430 "column already exists").
-- Schema-qualified to PROD. CRLF + UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

BEGIN
  EXECUTE IMMEDIATE
    'ALTER TABLE prod.atd_otbi_jobs ADD (priority NUMBER DEFAULT 5 NOT NULL)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;  -- already exists
END;
/

BEGIN
  EXECUTE IMMEDIATE
    'ALTER TABLE prod.atd_otbi_jobs ADD (run_order NUMBER DEFAULT 100 NOT NULL)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;  -- already exists
END;
/

-- Optional seed: give the three live jobs a deliberate order (smallest first).
-- Edit these rows any time to re-sequence - no code change.
UPDATE prod.atd_otbi_jobs SET priority = 5, run_order = 10  WHERE job_name = 'SUPPLIERS';
UPDATE prod.atd_otbi_jobs SET priority = 5, run_order = 20  WHERE job_name = 'GRN_ALL';
UPDATE prod.atd_otbi_jobs SET priority = 5, run_order = 30  WHERE job_name = 'BENEFICIARIES';
COMMIT;

SET ECHO OFF
PROMPT otbi-atd 11 job ordering : done
