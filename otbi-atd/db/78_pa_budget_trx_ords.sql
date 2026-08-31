-- =============================================================================
-- ATD Loader (App 208) -- ORDS for Project Budget Transactions  (additive)
-- File    : 78_pa_budget_trx_ords.sql
-- Base URL: /ords/admin/atd/   (adds to the EXISTING 'atd.rest' module)
-- Run     : sql -name prod_mcp @78_pa_budget_trx_ords.sql   (FRESH session -
--           synonym rule: must NOT follow ALTER SESSION SET CURRENT_SCHEMA=PROD)
-- =============================================================================
-- Five endpoints for the Project Budget Transactions page (db/77 tables):
--   POST pbt/runs            enqueue an extract (RANGE | SYNC_SHALLOW | SYNC_DEEP)
--   GET  pbt/runs            request register + telemetry (worker/started/duration)
--   GET  pbt/runs/:id        one request, with its run-log message
--   GET  pbt/summary         KPIs + the LOVs the page's filters need
--   GET  pbt/data            paged header register (the extracted data)
--   GET  pbt/data/:num       one transaction: header + lines + approval trail
--
-- NOTE the enqueue is OUR OWN: db/44's "enqueue" endpoint is hard-coded to
-- action_type PPM_TASK_ADDL_INFO, so it could not be reused.
--
-- Purely additive on NEW templates; existing handlers untouched.
-- WARNING: 13_atd_ords.sql rebuilds atd.rest from scratch -- after ANY re-run of
-- 13 you must re-run 20, 38, 41, 42, 44, 45, 63 AND this 78.
-- Admin-only (SYS_ADMIN). [COLON] -> ':' at define time (SQLcl bind-scan guard).
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- ---------------------------------------------------------------------------
-- ADMIN synonyms FIRST. ORDS handlers execute as ADMIN, so every PROD object
-- named in handler PL/SQL needs one -- without them EVERY route answers an
-- uncatchable HTTP 555 (the handler never compiles, so the EXCEPTION block
-- cannot report it). Must run in a FRESH session: after an
-- ALTER SESSION SET CURRENT_SCHEMA = PROD these become self-referencing
-- (ORA-01471).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE SYNONYM pa_budget_trx_headers    FOR prod.pa_budget_trx_headers;
CREATE OR REPLACE SYNONYM pa_additional_fund_lines FOR prod.pa_additional_fund_lines;
CREATE OR REPLACE SYNONYM pa_estimated_cost_lines  FOR prod.pa_estimated_cost_lines;
CREATE OR REPLACE SYNONYM pa_annual_budget_lines   FOR prod.pa_annual_budget_lines;
CREATE OR REPLACE SYNONYM pa_budget_trx_approvals  FOR prod.pa_budget_trx_approvals;
CREATE OR REPLACE SYNONYM v_pa_budget_trx_request  FOR prod.v_pa_budget_trx_request;
CREATE OR REPLACE SYNONYM pa_pbt_sync_pkg          FOR prod.pa_pbt_sync_pkg;

CREATE OR REPLACE PROCEDURE setup_atd_pbt_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'atd.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;

    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN

    -- =========================================================================
    -- pbt/runs carries BOTH a POST (enqueue) and a GET (register). The template
    -- is declared ONCE here: calling ORDS.DEFINE_TEMPLATE again for the second
    -- method DROPS the handlers already defined on it (the same trap that bit
    -- GL/db/09) - the POST would vanish and the deploy would look clean.
    -- =========================================================================
    def_template('pbt/runs');

    -- =========================================================================
    -- POST pbt/runs -- enqueue one extract request
    -- Body: {mode, transactionTypes[], dateFrom, dateTo, businessUnits[],
    --        statuses[], includeApprovals, purgeMissing}
    -- The idem_key carries a timestamp so repeated manual runs are allowed; the
    -- SCHEDULED job uses a bucketed key instead (db/79) so a tick that fires
    -- while the fleet is busy cannot pile up a duplicate.
    -- =========================================================================

    def_handler('pbt/runs', 'POST', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_mode  VARCHAR2(20);
  l_from  VARCHAR2(20);
  l_to    VARCHAR2(20);
  l_aid   NUMBER;
  l_stat  VARCHAR2(20);
  l_pay   CLOB;
  l_ref   VARCHAR2(200);
  l_d1    DATE;
  l_d2    DATE;
  l_n     NUMBER;
  l_arr   VARCHAR2(4000);
  l_appr  VARCHAR2(10);
  l_purge VARCHAR2(10);

  -- rebuild a JSON array from the parsed body: the payload we store is
  -- CONSTRUCTED from validated input, never the caller's raw body
  FUNCTION arr(p_path VARCHAR2) RETURN VARCHAR2 IS
    v VARCHAR2(4000); c NUMBER;
  BEGIN
    c := NVL(APEX_JSON.get_count(p_path => p_path), 0);
    IF c = 0 THEN RETURN NULL; END IF;
    FOR i IN 1..c LOOP
      v := v || CASE WHEN i > 1 THEN ',' END ||
           '"' || REPLACE(APEX_JSON.get_varchar2(p_path => p_path || '[%d]',
                                                 p0 => i), '"', '') || '"';
    END LOOP;
    RETURN '[' || v || ']';
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;

  -- parse_body dereferences the BLOB [COLON]body exactly once; assigning
  -- [COLON]body to a CLOB instead does not compile -> uncatchable 555
  dct_rest.parse_body([COLON]body);
  l_mode := UPPER(NVL(APEX_JSON.get_varchar2('mode'), 'RANGE'));
  l_from := APEX_JSON.get_varchar2('dateFrom');
  l_to   := APEX_JSON.get_varchar2('dateTo');

  IF l_mode NOT IN ('RANGE','SYNC_SHALLOW','SYNC_DEEP') THEN
    dct_rest.err(400,'mode must be RANGE, SYNC_SHALLOW or SYNC_DEEP'); RETURN;
  END IF;

  -- FX-exact masks: a lenient TO_DATE turns '26-08' into year 0026
  BEGIN
    IF l_from IS NOT NULL THEN l_d1 := TO_DATE(l_from,'YYYY-MM-DD'); END IF;
    IF l_to   IS NOT NULL THEN l_d2 := TO_DATE(l_to,'YYYY-MM-DD');   END IF;
  EXCEPTION WHEN OTHERS THEN
    dct_rest.err(400,'dateFrom/dateTo must be YYYY-MM-DD'); RETURN;
  END;
  IF l_d1 IS NOT NULL AND l_d2 IS NOT NULL AND l_d2 < l_d1 THEN
    dct_rest.err(400,'dateTo cannot precede dateFrom'); RETURN;
  END IF;
  IF l_mode = 'RANGE' AND l_d1 IS NULL AND l_d2 IS NULL THEN
    dct_rest.err(400,'RANGE mode needs dateFrom and/or dateTo'); RETURN;
  END IF;

  l_appr  := CASE WHEN NVL(APEX_JSON.get_varchar2('includeApprovals'),'true')
                       IN ('false','N','0') THEN 'false' ELSE 'true' END;
  l_purge := CASE WHEN NVL(APEX_JSON.get_varchar2('purgeMissing'),'false')
                       IN ('true','Y','1') THEN 'true' ELSE 'false' END;

  l_pay := '{"mode":"' || l_mode || '"'
        || CASE WHEN l_from IS NOT NULL THEN ',"dateFrom":"'||l_from||'"' END
        || CASE WHEN l_to   IS NOT NULL THEN ',"dateTo":"'||l_to||'"' END;
  l_arr := arr('transactionTypes');
  IF l_arr IS NOT NULL THEN l_pay := l_pay || ',"transactionTypes":' || l_arr; END IF;
  l_arr := arr('businessUnits');
  IF l_arr IS NOT NULL THEN l_pay := l_pay || ',"businessUnits":' || l_arr; END IF;
  l_arr := arr('statuses');
  IF l_arr IS NOT NULL THEN l_pay := l_pay || ',"statuses":' || l_arr; END IF;
  l_pay := l_pay || ',"includeApprovals":' || l_appr
                 || ',"purgeMissing":' || l_purge || '}';

  l_ref := SUBSTR(l_mode||NVL(' '||l_from,'')||NVL('..'||l_to,''), 1, 200);

  l_aid := atd_action_pkg.enqueue_action(
    p_action_type   => 'PA_BUDGET_TRX',
    p_source_module => 'ATD',
    p_source_type   => 'UI',
    p_source_id     => NULL,
    p_source_ref    => l_ref,
    p_idem_key      => SUBSTR('PBT[COLON]'||l_mode||'[COLON]'
                              ||TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF3'), 1, 200),
    p_payload       => l_pay,
    p_env_name      => NULL,
    p_created_by    => l_user);

  SELECT run_status INTO l_stat FROM atd_action_request WHERE action_id = l_aid;

  dct_rest.json_header;
  APEX_JSON.open_object;
  APEX_JSON.write('actionId', l_aid);
  APEX_JSON.write('status', l_stat);
  APEX_JSON.write('mode', l_mode);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GET pbt/runs -- request register (newest first)
    -- =========================================================================

    def_handler('pbt/runs', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_lim  NUMBER := LEAST(NVL(TO_NUMBER(REGEXP_SUBSTR([COLON]limit,'^\d+$')), 50), 500);
  l_n    NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT action_id, run_status, run_mode, date_from, date_to, attempts,
           last_error, worker_host, duration_secs, created_by, log_row_count,
           log_status, source_ref,
           TO_CHAR(dct_to_local(started_at),  'YYYY-MM-DD HH[COLON]MI AM') started_l,
           TO_CHAR(dct_to_local(finished_at), 'YYYY-MM-DD HH[COLON]MI AM') finished_l,
           TO_CHAR(dct_to_local(created_at),  'YYYY-MM-DD HH[COLON]MI AM') created_l
      FROM v_pa_budget_trx_request
     ORDER BY action_id DESC
     FETCH FIRST l_lim ROWS ONLY)
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('actionId', r.action_id);
    APEX_JSON.write('status', r.run_status);
    APEX_JSON.write('mode', NVL(r.run_mode,''));
    APEX_JSON.write('scope', NVL(r.source_ref,''));
    APEX_JSON.write('dateFrom', NVL(r.date_from,''));
    APEX_JSON.write('dateTo', NVL(r.date_to,''));
    APEX_JSON.write('attempts', r.attempts);
    APEX_JSON.write('workerVm', NVL(r.worker_host,''));
    APEX_JSON.write('startedAt', NVL(r.started_l,''));
    APEX_JSON.write('finishedAt', NVL(r.finished_l,''));
    APEX_JSON.write('durationSecs', NVL(r.duration_secs,0));
    APEX_JSON.write('rowCount', NVL(r.log_row_count,0));
    APEX_JSON.write('logStatus', NVL(r.log_status,''));
    APEX_JSON.write('submittedBy', NVL(r.created_by,''));
    APEX_JSON.write('submittedAt', NVL(r.created_l,''));
    APEX_JSON.write('error', NVL(r.last_error,''));
    APEX_JSON.close_object;
    l_n := l_n + 1;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('count', l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GET pbt/runs/:id -- one request (the page polls this while a run is live)
    -- =========================================================================
    def_template('pbt/runs/[COLON]id');
    def_handler('pbt/runs/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER := TO_NUMBER(REGEXP_SUBSTR([COLON]id,'^\d+$'));
  l_cnt  NUMBER := 0;
  l_msg  CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'id must be numeric'); RETURN; END IF;
  SELECT COUNT(*) INTO l_cnt FROM v_pa_budget_trx_request WHERE action_id = l_id;
  -- 404 must be decided BEFORE json_header (the header wins otherwise)
  IF l_cnt = 0 THEN dct_rest.err(404,'Request not found'); RETURN; END IF;

  dct_rest.json_header;
  FOR r IN (SELECT * FROM v_pa_budget_trx_request WHERE action_id = l_id) LOOP
    l_msg := r.log_message;
    APEX_JSON.open_object;
    APEX_JSON.write('actionId', r.action_id);
    APEX_JSON.write('status', r.run_status);
    APEX_JSON.write('mode', NVL(r.run_mode,''));
    APEX_JSON.write('scope', NVL(r.source_ref,''));
    APEX_JSON.write('attempts', r.attempts);
    APEX_JSON.write('workerVm', NVL(r.worker_host,''));
    APEX_JSON.write('startedAt',
      NVL(TO_CHAR(dct_to_local(r.started_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('finishedAt',
      NVL(TO_CHAR(dct_to_local(r.finished_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('durationSecs', NVL(r.duration_secs,0));
    APEX_JSON.write('rowCount', NVL(r.log_row_count,0));
    APEX_JSON.write('logStatus', NVL(r.log_status,''));
    APEX_JSON.write('detail', NVL(DBMS_LOB.substr(l_msg,3900,1),''));
    APEX_JSON.write('submittedBy', NVL(r.created_by,''));
    APEX_JSON.write('error', NVL(r.last_error,''));
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GET pbt/summary -- KPIs + filter LOVs (one call feeds the whole page head)
    -- =========================================================================
    def_template('pbt/summary');
    def_handler('pbt/summary', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_lines  NUMBER := 0;
  l_syncon VARCHAR2(10) := 'N';
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.open_object;

  APEX_JSON.open_array('byType');
  FOR r IN (
    SELECT h.transaction_type ttype, COUNT(*) hdrs,
           MIN(h.transaction_date) d1, MAX(h.transaction_date) d2,
           MAX(h.last_seen_at) seen
      FROM pa_budget_trx_headers h
     GROUP BY h.transaction_type ORDER BY 1)
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('type', r.ttype);
    APEX_JSON.write('headers', r.hdrs);
    APEX_JSON.write('dateFrom', NVL(TO_CHAR(r.d1,'YYYY-MM-DD'),''));
    APEX_JSON.write('dateTo', NVL(TO_CHAR(r.d2,'YYYY-MM-DD'),''));
    APEX_JSON.write('lastSeen',
      NVL(TO_CHAR(dct_to_local(r.seen),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('byStatus');
  FOR r IN (SELECT status, COUNT(*) n FROM pa_budget_trx_headers
             GROUP BY status ORDER BY 2 DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('status', NVL(r.status,''));
    APEX_JSON.write('count', r.n);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('byBu');
  FOR r IN (SELECT business_unit bu, COUNT(*) n FROM pa_budget_trx_headers
             GROUP BY business_unit ORDER BY 2 DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('bu', NVL(r.bu,''));
    APEX_JSON.write('count', r.n);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('types');
  FOR r IN (SELECT v.value_code c, v.value_name_en n
              FROM dct_lookup_values v JOIN dct_lookup_categories g
                ON g.category_id = v.category_id
             WHERE g.category_code = 'PA_BUDGET_TRX_TYPE' AND v.is_active = 'Y'
             ORDER BY v.display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.c);
    APEX_JSON.write('name', r.n);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  SELECT COUNT(*) INTO l_lines FROM pa_additional_fund_lines;
  APEX_JSON.write('linesAdditional', l_lines);
  SELECT COUNT(*) INTO l_lines FROM pa_estimated_cost_lines;
  APEX_JSON.write('linesEstimatedCost', l_lines);
  SELECT COUNT(*) INTO l_lines FROM pa_annual_budget_lines;
  APEX_JSON.write('linesAnnualBudget', l_lines);
  SELECT COUNT(*) INTO l_lines FROM pa_budget_trx_approvals;
  APEX_JSON.write('approvals', l_lines);

  SELECT NVL(MAX(config_value),'N') INTO l_syncon FROM atd_runner_config
   WHERE config_key = 'PBT_SYNC_ENABLED';
  APEX_JSON.write('syncEnabled', l_syncon);

  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GET pbt/data -- paged header register
    -- Filters: type, from, to, bu, status, search (contains on num/decree/org)
    -- =========================================================================
    def_template('pbt/data');
    def_handler('pbt/data', 'GET', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_type  VARCHAR2(40)  := TRIM([COLON]type);
  l_bu    VARCHAR2(240) := TRIM([COLON]bu);
  l_stat  VARCHAR2(60)  := TRIM([COLON]status);
  l_srch  VARCHAR2(200) := LOWER(TRIM([COLON]search));
  l_from  DATE;
  l_to    DATE;
  l_pg    NUMBER := GREATEST(NVL(TO_NUMBER(REGEXP_SUBSTR([COLON]page,'^\d+$')),1),1);
  l_sz    NUMBER := LEAST(NVL(TO_NUMBER(REGEXP_SUBSTR([COLON]size,'^\d+$')),100),10000);
  l_tot   NUMBER := 0;
  l_n     NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  BEGIN
    IF [COLON]from IS NOT NULL THEN l_from := TO_DATE([COLON]from,'YYYY-MM-DD'); END IF;
    IF [COLON]to   IS NOT NULL THEN l_to   := TO_DATE([COLON]to,'YYYY-MM-DD');   END IF;
  EXCEPTION WHEN OTHERS THEN
    dct_rest.err(400,'from/to must be YYYY-MM-DD'); RETURN;
  END;

  SELECT COUNT(*) INTO l_tot FROM pa_budget_trx_headers h
   WHERE (l_type IS NULL OR h.transaction_type = l_type)
     AND (l_bu   IS NULL OR h.business_unit    = l_bu)
     AND (l_stat IS NULL OR h.status           = l_stat)
     AND (l_from IS NULL OR h.transaction_date >= l_from)
     AND (l_to   IS NULL OR h.transaction_date <= l_to)
     AND (l_srch IS NULL OR LOWER(h.transaction_num) LIKE '%'||l_srch||'%'
          OR LOWER(NVL(h.decree_no,'')) LIKE '%'||l_srch||'%'
          OR LOWER(NVL(h.organization,'')) LIKE '%'||l_srch||'%');

  dct_rest.json_header;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT h.*, TO_CHAR(h.transaction_date,'YYYY-MM-DD') td,
           TO_CHAR(h.creation_date,'YYYY-MM-DD') cd,
           (SELECT COUNT(*) FROM pa_budget_trx_approvals a
             WHERE a.transaction_num = h.transaction_num
               AND a.trx_type = h.transaction_type) appr_n
      FROM pa_budget_trx_headers h
     WHERE (l_type IS NULL OR h.transaction_type = l_type)
       AND (l_bu   IS NULL OR h.business_unit    = l_bu)
       AND (l_stat IS NULL OR h.status           = l_stat)
       AND (l_from IS NULL OR h.transaction_date >= l_from)
       AND (l_to   IS NULL OR h.transaction_date <= l_to)
       AND (l_srch IS NULL OR LOWER(h.transaction_num) LIKE '%'||l_srch||'%'
            OR LOWER(NVL(h.decree_no,'')) LIKE '%'||l_srch||'%'
            OR LOWER(NVL(h.organization,'')) LIKE '%'||l_srch||'%')
     ORDER BY h.transaction_date DESC, h.transaction_num DESC
     OFFSET (l_pg-1)*l_sz ROWS FETCH NEXT l_sz ROWS ONLY)
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('identifier', r.identifier);
    APEX_JSON.write('transactionNum', r.transaction_num);
    APEX_JSON.write('transactionType', r.transaction_type);
    APEX_JSON.write('projectType', NVL(r.project_type,''));
    APEX_JSON.write('status', NVL(r.status,''));
    APEX_JSON.write('transactionDate', NVL(r.td,''));
    APEX_JSON.write('trxYear', NVL(r.trx_year,''));
    APEX_JSON.write('approver', NVL(r.dept_1st_level_approver,''));
    APEX_JSON.write('businessUnit', NVL(r.business_unit,''));
    APEX_JSON.write('decreeNo', NVL(r.decree_no,''));
    APEX_JSON.write('organization', NVL(r.organization,''));
    APEX_JSON.write('projectApprovedCost', NVL(r.project_approved_cost,0));
    APEX_JSON.write('projectEstimatedCost', NVL(r.project_estimated_cost,0));
    APEX_JSON.write('projectTotalCost', NVL(r.project_total_cost,0));
    APEX_JSON.write('creationDate', NVL(r.cd,''));
    APEX_JSON.write('approvals', r.appr_n);
    APEX_JSON.close_object;
    l_n := l_n + 1;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('count', l_n);
  APEX_JSON.write('total', l_tot);
  APEX_JSON.write('page', l_pg);
  APEX_JSON.write('size', l_sz);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GET pbt/data/:num?type= -- one transaction: header + lines + approvals
    -- The lines come from the table matching the TYPE (their shapes differ), so
    -- each is emitted as a generic {label,value} pair list -- that keeps this
    -- handler stable when a 4th budget type is added.
    -- =========================================================================
    def_template('pbt/data/[COLON]num');
    def_handler('pbt/data/[COLON]num', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_num  VARCHAR2(60)  := TRIM([COLON]num);
  l_type VARCHAR2(40)  := TRIM([COLON]type);
  l_cnt  NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  IF l_num IS NULL THEN dct_rest.err(400,'num is required'); RETURN; END IF;
  SELECT COUNT(*) INTO l_cnt FROM pa_budget_trx_headers
   WHERE transaction_num = l_num AND (l_type IS NULL OR transaction_type = l_type);
  IF l_cnt = 0 THEN dct_rest.err(404,'Transaction not found'); RETURN; END IF;

  dct_rest.json_header;
  APEX_JSON.open_object;

  FOR h IN (SELECT * FROM pa_budget_trx_headers
             WHERE transaction_num = l_num
               AND (l_type IS NULL OR transaction_type = l_type)
             FETCH FIRST 1 ROWS ONLY) LOOP
    l_type := h.transaction_type;
    APEX_JSON.open_object('header');
    APEX_JSON.write('identifier', h.identifier);
    APEX_JSON.write('transactionNum', h.transaction_num);
    APEX_JSON.write('transactionType', h.transaction_type);
    APEX_JSON.write('status', NVL(h.status,''));
    APEX_JSON.write('transactionDate', NVL(TO_CHAR(h.transaction_date,'YYYY-MM-DD'),''));
    APEX_JSON.write('businessUnit', NVL(h.business_unit,''));
    APEX_JSON.write('projectType', NVL(h.project_type,''));
    APEX_JSON.write('decreeNo', NVL(h.decree_no,''));
    APEX_JSON.write('organization', NVL(h.organization,''));
    APEX_JSON.write('approver', NVL(h.dept_1st_level_approver,''));
    APEX_JSON.write('trxYear', NVL(h.trx_year,''));
    APEX_JSON.write('creationDate', NVL(TO_CHAR(h.creation_date,'YYYY-MM-DD'),''));
    APEX_JSON.close_object;
  END LOOP;

  APEX_JSON.open_array('lines');
  IF l_type = 'Additional' THEN
    FOR r IN (SELECT * FROM pa_additional_fund_lines WHERE transaction_num = l_num
               ORDER BY identifier) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('identifier', r.identifier);
      APEX_JSON.write('projectNum', NVL(r.project_num,''));
      APEX_JSON.write('projectName', NVL(r.project_name,''));
      APEX_JSON.write('taskNum', NVL(r.task_num,''));
      APEX_JSON.write('taskName', NVL(r.task_name,''));
      APEX_JSON.write('costCenter', NVL(r.cost_center,''));
      APEX_JSON.write('expenditureType', NVL(r.expenditure_type,''));
      APEX_JSON.write('codeCombination', NVL(r.code_combination,''));
      APEX_JSON.write('amount', NVL(r.additional_amount,0));
      APEX_JSON.write('totalAnnualBudget', NVL(r.total_annual_budget,0));
      APEX_JSON.write('currentAnnualBudget', NVL(r.current_annual_budget,0));
      APEX_JSON.write('fundAvailable', NVL(r.fund_available,0));
      APEX_JSON.write('glFundsAvailable', NVL(r.gl_funds_available,0));
      APEX_JSON.write('totalActual', NVL(r.total_actual,0));
      APEX_JSON.write('commitments', NVL(r.commitments,0));
      APEX_JSON.write('periodFrom', NVL(r.period_from,''));
      APEX_JSON.write('periodTo', NVL(r.period_to,''));
      APEX_JSON.write('lineStatus', NVL(r.line_status,''));
      APEX_JSON.write('baselineStatus', NVL(r.baseline_status,''));
      APEX_JSON.write('jvStatus', NVL(r.jv_status,''));
      APEX_JSON.write('notes', NVL(r.notes,''));
      APEX_JSON.close_object;
    END LOOP;
  ELSIF l_type = 'Estimated-Cost' THEN
    FOR r IN (SELECT * FROM pa_estimated_cost_lines WHERE transaction_num = l_num
               ORDER BY identifier) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('identifier', r.identifier);
      APEX_JSON.write('projectNum', NVL(r.project_num,''));
      APEX_JSON.write('projectName', NVL(r.project_name,''));
      APEX_JSON.write('taskNum', NVL(r.task_num,''));
      APEX_JSON.write('taskName', NVL(r.task_name,''));
      APEX_JSON.write('costCenter', NVL(r.cost_center,''));
      APEX_JSON.write('expenditureType', NVL(r.expenditure_type,''));
      APEX_JSON.write('codeCombination', NVL(r.code_combination,''));
      APEX_JSON.write('amount', NVL(r.estimated_cost,0));
      APEX_JSON.write('currentYearBudget', NVL(r.current_year_budget,0));
      APEX_JSON.write('glFundsAvailable', NVL(r.gl_funds_available,0));
      APEX_JSON.write('lineStatus', NVL(r.line_status,''));
      APEX_JSON.write('baselineStatus', NVL(r.baseline_status,''));
      APEX_JSON.write('notes', NVL(r.notes,''));
      APEX_JSON.close_object;
    END LOOP;
  ELSE
    FOR r IN (SELECT * FROM pa_annual_budget_lines WHERE transaction_num = l_num
               ORDER BY identifier) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('identifier', r.identifier);
      APEX_JSON.write('projectNum', NVL(r.project_num,''));
      APEX_JSON.write('projectName', NVL(r.project_name,''));
      APEX_JSON.write('taskNum', NVL(r.task_num,''));
      APEX_JSON.write('taskName', NVL(r.task_name,''));
      APEX_JSON.write('costCenter', NVL(r.cost_center,''));
      APEX_JSON.write('expenditureType', NVL(r.expenditure_type,''));
      APEX_JSON.write('codeCombination', NVL(r.code_combination,''));
      APEX_JSON.write('amount', NVL(r.approved_budget,0));
      APEX_JSON.write('proposedBudget', NVL(r.proposed_budget,0));
      APEX_JSON.write('approvedAnnualBudget', NVL(r.approved_annual_budget,0));
      APEX_JSON.write('revisedProjectCost', NVL(r.revised_project_cost,0));
      APEX_JSON.write('availableProjectCost', NVL(r.available_project_cost,0));
      APEX_JSON.write('totalActual', NVL(r.total_actual,0));
      APEX_JSON.write('glFundsAvailable', NVL(r.gl_funds_available,0));
      APEX_JSON.write('baselineStatus', NVL(r.baseline_status,''));
      APEX_JSON.write('jvStatus', NVL(r.jv_status,''));
      APEX_JSON.write('notes', NVL(r.notes,''));
      APEX_JSON.close_object;
    END LOOP;
  END IF;
  APEX_JSON.close_array;

  APEX_JSON.open_array('approvals');
  FOR r IN (SELECT * FROM pa_budget_trx_approvals
             WHERE transaction_num = l_num AND trx_type = l_type
             ORDER BY seq_no) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('seq', r.seq_no);
    APEX_JSON.write('submitter', NVL(r.submitter_name,''));
    APEX_JSON.write('assignee', NVL(r.assignee_username,''));
    APEX_JSON.write('state', NVL(r.assignment_state,''));
    APEX_JSON.write('createdAt',
      NVL(TO_CHAR(dct_to_local(r.creation_date),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('firstLevelFlag', NVL(r.dept_1st_level_approval_flag,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END setup_atd_pbt_tmp;
/

BEGIN
  setup_atd_pbt_tmp;
  COMMIT;
END;
/
DROP PROCEDURE setup_atd_pbt_tmp;

PROMPT otbi-atd 78 Project Budget Transactions ORDS : done
