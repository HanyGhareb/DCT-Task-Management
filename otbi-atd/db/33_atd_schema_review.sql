-- ===========================================================================
-- otbi-atd : 33 schema-review gate
--   * ATD_OTBI_JOBS.schema_reviewed CHAR(1) DEFAULT 'Y' -> when 'N', the worker
--     PREPARES the table + column map (so the end user can review the structure)
--     but HOLDS before loading any rows (run-log status 'HELD'); loading resumes
--     only after the user approves. Existing jobs default 'Y' (no behaviour change).
--   * additive ORDS: POST /atd/jobs/:name/approve-schema  -> set schema_reviewed='Y'
-- Additive only (DEFINE_TEMPLATE/DEFINE_HANDLER on the live atd.rest) -> no
-- DELETE_MODULE. Run in a FRESH session. Rerunnable. Schema-qualified PROD.
-- CRLF / UTF-8 no BOM. [COLON] -> ':' at define.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO ON

-- review flag (existing rows -> 'Y' = no gate)
BEGIN
  EXECUTE IMMEDIATE
    q'[ALTER TABLE prod.atd_otbi_jobs ADD (schema_reviewed CHAR(1) DEFAULT 'Y' NOT NULL)]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;  -- already exists
END;
/
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_otbi_jobs DROP CONSTRAINT ck_atd_job_review';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -2443 THEN RAISE; END IF;  -- not found
END;
/
ALTER TABLE prod.atd_otbi_jobs ADD CONSTRAINT ck_atd_job_review
  CHECK (schema_reviewed IN ('Y','N'));

CREATE OR REPLACE SYNONYM atd_otbi_jobs FOR prod.atd_otbi_jobs;

CREATE OR REPLACE PROCEDURE setup_atd_review_ords_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'atd.rest';
    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method => p_method, p_source_type => ORDS.source_type_plsql,
            p_source => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    -- POST /jobs/:name/approve-schema  -- release a held job (schema reviewed)
    def_template('jobs/[COLON]name/approve-schema');
    def_handler('jobs/[COLON]name/approve-schema', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_n    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  UPDATE atd_otbi_jobs SET schema_reviewed = 'Y', updated_at = SYSTIMESTAMP
   WHERE job_name = [COLON]name;
  l_n := SQL%ROWCOUNT; COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Job not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');
END setup_atd_review_ords_tmp;
/

BEGIN
  setup_atd_review_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE setup_atd_review_ords_tmp;

SET ECHO OFF
PROMPT otbi-atd 33 schema review : done
