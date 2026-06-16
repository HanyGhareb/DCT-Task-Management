-- ===========================================================================
-- otbi-atd : 03 ATD_OTBI_PKG  (Track A - in-ATP, BI Publisher runReport API)
-- Reads the control tables, calls the BIP SOAP runReport for a job's report,
-- decodes the base64 CSV, parses it with APEX_DATA_PARSER, loads the staging
-- table, MERGEs into the final table, and writes ATD_LOAD_RUN_LOG.
-- Definer-rights, owned by PROD. CRLF + UTF-8 no BOM.
--
-- AUTH WIRING: get_secret() is the single place credentials resolve. The
-- default reads prod.atd_secret (a restricted table). For production, replace
-- its body with an OCI Vault fetch (DBMS_CLOUD / OCI REST). The password is
-- needed in clear at call time to build the WS-Security UsernameToken, so it
-- must live in a store the package can read - keep that store locked down.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

-- Minimal secret store (replace with OCI Vault in production). One row per
-- credential_ref used in ATD_OTBI_ENV / ATD_TARGET_DB.
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.atd_secret CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
CREATE TABLE prod.atd_secret (
  credential_ref VARCHAR2(200) PRIMARY KEY,
  username       VARCHAR2(200),
  secret_value   VARCHAR2(400),
  updated_at     TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE OR REPLACE PACKAGE prod.atd_otbi_pkg AS
  PROCEDURE run_job(p_job_name IN VARCHAR2);

  FUNCTION run_report(
    p_env_name    IN VARCHAR2,
    p_report_path IN VARCHAR2,
    p_params_json IN CLOB     DEFAULT NULL,
    p_format      IN VARCHAR2 DEFAULT 'csv'
  ) RETURN CLOB;

  FUNCTION get_secret(p_ref IN VARCHAR2, p_username OUT VARCHAR2) RETURN VARCHAR2;
END atd_otbi_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.atd_otbi_pkg AS

  g_soap_ns CONSTANT VARCHAR2(120) := 'http://xmlns.oracle.com/oxp/service/PublicReportService';

  ----------------------------------------------------------------------------
  FUNCTION get_secret(p_ref IN VARCHAR2, p_username OUT VARCHAR2) RETURN VARCHAR2 IS
    l_pwd prod.atd_secret.secret_value%TYPE;
  BEGIN
    -- PRODUCTION: replace this SELECT with an OCI Vault secret fetch.
    SELECT username, secret_value INTO p_username, l_pwd
      FROM prod.atd_secret WHERE credential_ref = p_ref;
    RETURN l_pwd;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20081, 'No secret for credential_ref '||p_ref);
  END get_secret;

  ----------------------------------------------------------------------------
  -- base64 BLOB payload -> UTF-8 text CLOB
  FUNCTION b64_to_text(p_b64 IN CLOB) RETURN CLOB IS
    l_blob BLOB;
    l_clob CLOB;
    l_dofs INTEGER := 1; l_sofs INTEGER := 1; l_warn INTEGER;
    l_lang INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
  BEGIN
    l_blob := apex_web_service.clobbase642blob(p_b64);
    DBMS_LOB.CREATETEMPORARY(l_clob, TRUE);
    DBMS_LOB.CONVERTTOCLOB(l_clob, l_blob, DBMS_LOB.LOBMAXSIZE, l_dofs, l_sofs,
                           DBMS_LOB.DEFAULT_CSID, l_lang, l_warn);
    RETURN l_clob;
  END b64_to_text;

  ----------------------------------------------------------------------------
  FUNCTION run_report(
    p_env_name    IN VARCHAR2,
    p_report_path IN VARCHAR2,
    p_params_json IN CLOB     DEFAULT NULL,
    p_format      IN VARCHAR2 DEFAULT 'csv'
  ) RETURN CLOB IS
    l_env      prod.atd_otbi_env%ROWTYPE;
    l_user     VARCHAR2(200);
    l_pwd      VARCHAR2(400);
    l_endpoint VARCHAR2(500);
    l_envelope CLOB;
    l_params   VARCHAR2(32767) := '';
    l_resp     CLOB;
    l_b64      CLOB;
    l_obj      JSON_OBJECT_T;
    l_keys     JSON_KEY_LIST;
  BEGIN
    SELECT * INTO l_env FROM prod.atd_otbi_env WHERE env_name = p_env_name;
    l_pwd := get_secret(l_env.credential_ref, l_user);
    l_endpoint := l_env.xmlpserver_base_url||'/services/ExternalReportWSSService';

    -- flat params {"P_NAME":"value", ...} -> <item><name/><values><item/></values></item>
    IF p_params_json IS NOT NULL THEN
      l_obj  := JSON_OBJECT_T.parse(p_params_json);
      l_keys := l_obj.get_keys;
      FOR i IN 1 .. l_keys.COUNT LOOP
        l_params := l_params
          ||'<pub:item><pub:name>'||l_keys(i)||'</pub:name>'
          ||'<pub:values><pub:item>'||l_obj.get_string(l_keys(i))
          ||'</pub:item></pub:values></pub:item>';
      END LOOP;
    END IF;

    l_envelope :=
      '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"'
      ||' xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"'
      ||' xmlns:pub="'||g_soap_ns||'">'
      ||'<soap:Header><wsse:Security soap:mustUnderstand="1"><wsse:UsernameToken>'
      ||'<wsse:Username>'||l_user||'</wsse:Username>'
      ||'<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">'
      ||l_pwd||'</wsse:Password>'
      ||'</wsse:UsernameToken></wsse:Security></soap:Header>'
      ||'<soap:Body><pub:runReport><pub:reportRequest>'
      ||'<pub:attributeFormat>'||p_format||'</pub:attributeFormat>'
      ||'<pub:reportAbsolutePath>'||p_report_path||'</pub:reportAbsolutePath>'
      ||'<pub:sizeOfDataChunkDownload>-1</pub:sizeOfDataChunkDownload>'
      ||CASE WHEN LENGTH(l_params) > 0
             THEN '<pub:parameterNameValues>'||l_params||'</pub:parameterNameValues>' END
      ||'</pub:reportRequest>'
      ||'<pub:userID>'||l_user||'</pub:userID>'
      ||'<pub:password>'||l_pwd||'</pub:password>'
      ||'</pub:runReport></soap:Body></soap:Envelope>';

    apex_web_service.g_request_headers.DELETE;
    apex_web_service.g_request_headers(1).name  := 'Content-Type';
    apex_web_service.g_request_headers(1).value := 'text/xml; charset=UTF-8';
    apex_web_service.g_request_headers(2).name  := 'SOAPAction';
    apex_web_service.g_request_headers(2).value := 'runReport';

    l_resp := apex_web_service.make_request(
                p_url      => l_endpoint,
                p_action   => 'runReport',
                p_envelope => l_envelope);

    -- extract <reportBytes> (base64) by local-name (ignores SOAP namespaces)
    l_b64 := XMLTYPE(l_resp)
               .extract('//*[local-name()="reportBytes"]/text()')
               .getclobval();

    IF l_b64 IS NULL OR DBMS_LOB.GETLENGTH(l_b64) = 0 THEN
      RAISE_APPLICATION_ERROR(-20082,
        'runReport returned no reportBytes for '||p_report_path||' :: '||SUBSTR(l_resp,1,2000));
    END IF;

    RETURN b64_to_text(l_b64);
  END run_report;

  ----------------------------------------------------------------------------
  -- Load CSV CLOB into stage_table using column_map_json {"Header":"TARGET_COL"}.
  FUNCTION load_csv(
    p_csv         IN CLOB,
    p_stage_table IN VARCHAR2,
    p_column_map  IN CLOB
  ) RETURN NUMBER IS
    TYPE t_map IS TABLE OF VARCHAR2(200) INDEX BY VARCHAR2(200);
    l_map      t_map;
    l_obj      JSON_OBJECT_T;
    l_keys     JSON_KEY_LIST;
    l_blob     BLOB;
    l_profile  CLOB;
    l_cols     VARCHAR2(8000);
    l_sel      VARCHAR2(8000);
    l_sql      VARCHAR2(16000);
    l_cnt      NUMBER;
    l_dofs     INTEGER := 1; l_sofs INTEGER := 1; l_warn INTEGER;
    l_lang     INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
  BEGIN
    l_obj  := JSON_OBJECT_T.parse(p_column_map);
    l_keys := l_obj.get_keys;
    FOR i IN 1 .. l_keys.COUNT LOOP
      l_map(UPPER(l_keys(i))) := l_obj.get_string(l_keys(i));   -- header -> target col
    END LOOP;

    DBMS_LOB.CREATETEMPORARY(l_blob, TRUE);
    DBMS_LOB.CONVERTTOBLOB(l_blob, p_csv, DBMS_LOB.LOBMAXSIZE, l_dofs, l_sofs,
                           DBMS_LOB.DEFAULT_CSID, l_lang, l_warn);

    l_profile := apex_data_parser.discover(p_content => l_blob, p_file_name => 'data.csv');

    FOR c IN (SELECT name, column_position
                FROM TABLE(apex_data_parser.get_columns(l_profile))) LOOP
      IF l_map.EXISTS(UPPER(c.name)) THEN
        l_cols := l_cols ||CASE WHEN l_cols IS NOT NULL THEN ',' END|| l_map(UPPER(c.name));
        l_sel  := l_sel  ||CASE WHEN l_sel  IS NOT NULL THEN ',' END
                         ||'COL'||LPAD(c.column_position,3,'0');
      END IF;
    END LOOP;

    IF l_cols IS NULL THEN
      RAISE_APPLICATION_ERROR(-20083,
        'No column_map header matched the CSV for '||p_stage_table);
    END IF;

    l_sql := 'INSERT INTO '||p_stage_table||' ('||l_cols||') SELECT '||l_sel
           ||' FROM TABLE(apex_data_parser.parse(p_content => :b, p_file_name => ''data.csv'','
           ||' p_file_profile => :p))';
    EXECUTE IMMEDIATE l_sql USING l_blob, l_profile;
    l_cnt := SQL%ROWCOUNT;
    RETURN l_cnt;
  END load_csv;

  ----------------------------------------------------------------------------
  -- Generic MERGE: assumes stage and final share column names (the loader puts
  -- the target column names into stage). Updates non-key shared cols; inserts
  -- shared cols. key_columns is a comma list.
  PROCEDURE merge_final(p_job IN prod.atd_otbi_jobs%ROWTYPE) IS
    l_keys  VARCHAR2(2000) := ','||UPPER(REPLACE(p_job.key_columns,' '))||',';
    l_on    VARCHAR2(4000);
    l_set   VARCHAR2(8000);
    l_ins   VARCHAR2(8000);
    l_vals  VARCHAR2(8000);
    l_sql   VARCHAR2(32000);
    l_stg   VARCHAR2(128) := UPPER(REGEXP_SUBSTR(p_job.stage_table,'[^.]+$'));
    l_fin   VARCHAR2(128) := UPPER(REGEXP_SUBSTR(p_job.final_table,'[^.]+$'));
  BEGIN
    IF p_job.final_table IS NULL OR p_job.load_mode <> 'MERGE' THEN RETURN; END IF;

    FOR col IN (
      SELECT f.column_name cn
        FROM all_tab_columns f
        JOIN all_tab_columns s
          ON s.owner = f.owner AND s.table_name = l_stg AND s.column_name = f.column_name
       WHERE f.owner = NVL(UPPER(REGEXP_SUBSTR(p_job.final_table,'^[^.]+(?=\.)')),'PROD')
         AND f.table_name = l_fin
       ORDER BY f.column_id
    ) LOOP
      l_ins  := l_ins  ||CASE WHEN l_ins  IS NOT NULL THEN ',' END||col.cn;
      l_vals := l_vals ||CASE WHEN l_vals IS NOT NULL THEN ',' END||'s.'||col.cn;
      IF INSTR(l_keys, ','||col.cn||',') > 0 THEN
        l_on := l_on ||CASE WHEN l_on IS NOT NULL THEN ' AND ' END||'t.'||col.cn||'=s.'||col.cn;
      ELSE
        l_set := l_set ||CASE WHEN l_set IS NOT NULL THEN ',' END||'t.'||col.cn||'=s.'||col.cn;
      END IF;
    END LOOP;

    l_sql := 'MERGE INTO '||p_job.final_table||' t USING '||p_job.stage_table||' s ON ('||l_on||')'
           ||CASE WHEN l_set IS NOT NULL THEN ' WHEN MATCHED THEN UPDATE SET '||l_set END
           ||' WHEN NOT MATCHED THEN INSERT ('||l_ins||') VALUES ('||l_vals||')';
    EXECUTE IMMEDIATE l_sql;
  END merge_final;

  ----------------------------------------------------------------------------
  PROCEDURE run_job(p_job_name IN VARCHAR2) IS
    l_job   prod.atd_otbi_jobs%ROWTYPE;
    l_env   prod.atd_otbi_env%ROWTYPE;
    l_csv   CLOB;
    l_cnt   NUMBER := 0;
    l_run   NUMBER;
  BEGIN
    SELECT * INTO l_job FROM prod.atd_otbi_jobs WHERE job_name = p_job_name;
    SELECT * INTO l_env FROM prod.atd_otbi_env  WHERE env_name = l_job.env_name;

    INSERT INTO prod.atd_load_run_log(job_name, track, status)
      VALUES (p_job_name, l_env.extract_track, 'RUNNING')
      RETURNING run_id INTO l_run;

    IF l_env.extract_track <> 'API' THEN
      RAISE_APPLICATION_ERROR(-20084,
        'Job '||p_job_name||' env is BROWSER track - run it via the Python runner.');
    END IF;

    l_csv := run_report(l_job.env_name, l_job.source_ref, l_job.params_json, l_job.output_format);

    IF l_job.load_mode = 'TRUNCATE_INSERT' THEN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE '||l_job.stage_table;
    END IF;

    l_cnt := load_csv(l_csv, l_job.stage_table, l_job.column_map_json);
    merge_final(l_job);

    UPDATE prod.atd_load_run_log
       SET finished = SYSTIMESTAMP, status = 'SUCCESS', row_count = l_cnt
     WHERE run_id = l_run;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      UPDATE prod.atd_load_run_log
         SET finished = SYSTIMESTAMP, status = 'FAILED',
             message = SUBSTR(SQLERRM||' :: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,1,4000)
       WHERE run_id = l_run;
      COMMIT;
      RAISE;
  END run_job;

END atd_otbi_pkg;
/
SHOW ERRORS PACKAGE BODY prod.atd_otbi_pkg

SET ECHO OFF
PROMPT otbi-atd 03 ATD_OTBI_PKG : done
