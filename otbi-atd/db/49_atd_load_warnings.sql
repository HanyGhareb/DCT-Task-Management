-- ===========================================================================
-- otbi-atd : non-blocking row-level data-quality warnings
-- Invalid dates load as NULL; warning samples are tied to the successful run.
-- Additive and rerunnable.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.atd_load_row_warning (
      warning_id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      run_id       NUMBER NOT NULL,
      job_name     VARCHAR2(80) NOT NULL,
      row_number   NUMBER NOT NULL,
      column_name  VARCHAR2(128) NOT NULL,
      raw_value    VARCHAR2(1000),
      warning_code VARCHAR2(40) NOT NULL,
      message      VARCHAR2(1000),
      created_at   TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT fk_atd_row_warn_run FOREIGN KEY (run_id)
        REFERENCES prod.atd_load_run_log(run_id) ON DELETE CASCADE
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE
    'CREATE INDEX prod.ix_atd_row_warn_run ON prod.atd_load_row_warning(run_id, warning_id)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- Add/replace only the GET handler. Do not DEFINE_TEMPLATE on the existing URI.
CREATE OR REPLACE SYNONYM atd_load_row_warning FOR prod.atd_load_row_warning;

BEGIN
  ORDS.DEFINE_HANDLER(
    p_module_name=>'atd.rest', p_pattern=>'runs/'||CHR(58)||'id', p_method=>'GET',
    p_source_type=>ORDS.source_type_plsql,
    p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_found NUMBER := 0;
  l_warn_count NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*) INTO l_found FROM atd_load_run_log WHERE run_id=l_id;
  IF l_found=0 THEN dct_rest.err(404,'Run not found'); RETURN; END IF;
  SELECT COUNT(*) INTO l_warn_count FROM atd_load_row_warning WHERE run_id=l_id;
  dct_rest.json_header; APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM atd_load_run_log WHERE run_id=l_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('runId',r.run_id); APEX_JSON.write('jobName',r.job_name);
    APEX_JSON.write('track',NVL(r.track,'')); APEX_JSON.write('status',r.status);
    APEX_JSON.write('rowCount',NVL(r.row_count,0));
    APEX_JSON.write('csvChecksum',NVL(r.csv_checksum,''));
    APEX_JSON.write('started',TO_CHAR(dct_to_local(r.started),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('finished',TO_CHAR(dct_to_local(r.finished),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('durationSec',CASE WHEN r.started IS NOT NULL AND r.finished IS NOT NULL
      THEN ROUND((CAST(r.finished AS DATE)-CAST(r.started AS DATE))*86400) END);
    APEX_JSON.write('message',NVL(DBMS_LOB.SUBSTR(r.message,32000,1),''));
    APEX_JSON.write('warningCount',l_warn_count);
    APEX_JSON.open_array('warnings');
    FOR w IN (SELECT row_number,column_name,raw_value,warning_code,message
                FROM atd_load_row_warning WHERE run_id=l_id ORDER BY warning_id) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('rowNumber',w.row_number); APEX_JSON.write('columnName',w.column_name);
      APEX_JSON.write('rawValue',NVL(w.raw_value,'')); APEX_JSON.write('code',w.warning_code);
      APEX_JSON.write('reason',NVL(w.message,''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array; APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500,SQLERRM);
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

PROMPT otbi-atd 49 load warnings : done
WHENEVER SQLERROR CONTINUE
