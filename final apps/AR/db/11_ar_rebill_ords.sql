-- =============================================================================
-- i-Finance V2 -- AR Invoice Rebill -- ORDS endpoints (ADDITIVE to ar.rest)
-- File    : 11_ar_rebill_ords.sql
-- Run as  : ADMIN schema (sql -name prod_mcp) -- FRESH SESSION
--           (never after ALTER SESSION SET CURRENT_SCHEMA = PROD -> ORA-01471)
-- Depends : 05_ar_ords.sql (module ar.rest),
--           otbi-atd/db/19 (ATD_ACTION_REQUEST + ATD_ACTION_PKG),
--           otbi-atd/db/52 (ATD_ACTION_STEP + saga pkg + register view),
--           otbi-atd/db/53 (AR_INVOICE_REBILL action type + lookup vocabularies)
-- NOTE    : 05 rebuilds ar.rest with DELETE_MODULE -- RE-RUN 10 AND 11 after any
--           re-run of 05. Templates here are NEW patterns only, so running 11
--           never disturbs the handlers defined in 05 or 10.
-- =============================================================================
-- The AR-side bridge onto the ATD Fusion write-back queue. AR staff submit
-- rebill requests here; the worker fleet drains ATD_ACTION_REQUEST and drives
-- the Fusion UI (otbi-atd/runner/actions/ar_invoice_rebill.py). /atd/ stays
-- SYS_ADMIN-only, which is why AR gets its own gated bridge rather than
-- calling the ATD API directly -- the same pattern as GL's /butil/book bridge
-- onto the Reporting platform.
--
-- Endpoints (base /ords/admin/ar/):
--   POST rebill/requests      enqueue 1..500 rebill requests, per-row results
--   GET  rebill/requests      paged register with the audit columns
--   GET  rebill/requests/:id  one request + its 9-stage timeline
--   GET  rebill/lovs          credit reasons / tax classifications / finish modes
--
-- The POST handler is a WHITELIST: it re-emits only the keys the runner
-- understands, so nothing unexpected from an Excel upload can reach the robot.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = ADMIN;
SET DEFINE OFF
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. Synonyms (19 and 52 create most of these; repeated so 11 is self-sufficient)
-- =============================================================================
CREATE OR REPLACE SYNONYM atd_action_request      FOR prod.atd_action_request;
CREATE OR REPLACE SYNONYM atd_action_pkg          FOR prod.atd_action_pkg;
CREATE OR REPLACE SYNONYM atd_action_step         FOR prod.atd_action_step;
CREATE OR REPLACE SYNONYM atd_action_saga_pkg     FOR prod.atd_action_saga_pkg;
CREATE OR REPLACE SYNONYM v_atd_ar_rebill_request FOR prod.v_atd_ar_rebill_request;

-- =============================================================================
-- 2. Templates + handlers (additive)
-- =============================================================================
CREATE OR REPLACE PROCEDURE setup_ar_rebill_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'ar.rest';

    PROCEDURE def_tpl (p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => p_pattern);
    END;

    PROCEDURE def_plsql (p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => p_pattern,
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => p_source
        );
    END;

BEGIN

    -- =========================================================================
    -- REBILL REQUESTS -- bulk enqueue
    -- =========================================================================
    def_tpl('rebill/requests');

    def_plsql('rebill/requests', 'POST', q'[
DECLARE
  -- validate_session takes NO argument here, and :body must be dereferenced
  -- EXACTLY ONCE and as a BLOB -- it binds as BLOB on this ADB's ORDS. Passing
  -- :body into validate_session fails to compile and ORDS reports it as an
  -- UNCATCHABLE 555 (the EXCEPTION block never runs). Same idiom as
  -- 10_ar_customer_ords.sql's POST customers/.
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_blob    BLOB := :body;
  l_body    CLOB;
  l_cnt     NUMBER;
  l_ok      NUMBER := 0;
  l_bad     NUMBER := 0;
  l_inv     VARCHAR2(200);
  l_finish  VARCHAR2(30);
  l_nlines  NUMBER;
  l_lineno  NUMBER;
  l_memo    VARCHAR2(400);
  l_proj    VARCHAR2(100);
  l_task    VARCHAR2(400);
  l_payload CLOB;
  l_err     VARCHAR2(400);
  l_aid     NUMBER;
  TYPE t_res IS RECORD (inv VARCHAR2(200), aid NUMBER, err VARCHAR2(400));
  TYPE t_tab IS TABLE OF t_res INDEX BY PLS_INTEGER;
  l_res     t_tab;
  e_row     EXCEPTION;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'AR_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN'))
  THEN dct_rest.err(403,'AR_ADMIN required'); RETURN; END IF;
  IF l_blob IS NULL OR dbms_lob.getlength(l_blob) = 0 THEN
    dct_rest.err(400,'Body required'); RETURN;
  END IF;
  DECLARE
    l_doff INTEGER := 1; l_soff INTEGER := 1;
    l_ctx  INTEGER := dbms_lob.default_lang_ctx; l_warn INTEGER;
  BEGIN
    dbms_lob.createtemporary(l_body, TRUE);
    dbms_lob.converttoclob(l_body, l_blob, dbms_lob.lobmaxsize,
                           l_doff, l_soff, dbms_lob.default_csid, l_ctx, l_warn);
  END;
  APEX_JSON.parse(l_body);

  l_cnt := NVL(APEX_JSON.get_count(p_path=>'rows'), 0);
  IF l_cnt = 0 THEN dct_rest.err(400,'rows[] is required'); RETURN; END IF;
  IF l_cnt > 500 THEN dct_rest.err(400,'Maximum 500 rows per request'); RETURN; END IF;

  FOR i IN 1 .. l_cnt LOOP
    l_err := NULL; l_aid := NULL;
    l_inv := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].invoiceNumber', p0=>i)), 1, 200);
    BEGIN
      IF l_inv IS NULL THEN l_err := 'invoiceNumber is required'; RAISE e_row; END IF;

      l_finish := UPPER(NVL(TRIM(APEX_JSON.get_varchar2(
                    p_path=>'rows[%d].cm.finish', p0=>i)), 'COMPLETE_AND_CLOSE'));
      IF l_finish NOT IN ('SAVE','COMPLETE_AND_CLOSE') THEN
        l_err := 'cm.finish must be SAVE or COMPLETE_AND_CLOSE'; RAISE e_row;
      END IF;

      IF TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].cm.transactionDate', p0=>i)) IS NULL
         OR TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].cm.accountingDate', p0=>i)) IS NULL THEN
        l_err := 'cm.transactionDate and cm.accountingDate are required'; RAISE e_row;
      END IF;
      IF TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].duplicate.transactionDate', p0=>i)) IS NULL
         OR TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].duplicate.accountingDate', p0=>i)) IS NULL THEN
        l_err := 'duplicate.transactionDate and duplicate.accountingDate are required'; RAISE e_row;
      END IF;

      l_nlines := NVL(APEX_JSON.get_count(p_path=>'rows[%d].lines', p0=>i), 0);
      IF l_nlines = 0 THEN l_err := 'at least one line is required'; RAISE e_row; END IF;

      -- rebuild the payload from KNOWN keys only (whitelist: junk columns from
      -- an Excel upload can never reach the robot)
      APEX_JSON.initialize_clob_output;
      APEX_JSON.open_object;
      APEX_JSON.write('invoiceNumber', l_inv);

      APEX_JSON.open_object('cm');
      APEX_JSON.write('transactionNumber',
        NVL(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].cm.transactionNumber', p0=>i)),
            l_inv || 'CM'));
      APEX_JSON.write('transactionDate',
        TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].cm.transactionDate', p0=>i)));
      APEX_JSON.write('accountingDate',
        TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].cm.accountingDate', p0=>i)));
      APEX_JSON.write('creditReason',
        NVL(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].cm.creditReason', p0=>i)),''));
      APEX_JSON.write('comments',
        NVL(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].cm.comments', p0=>i)),''));
      APEX_JSON.write('finish', l_finish);
      APEX_JSON.close_object;

      APEX_JSON.open_object('duplicate');
      APEX_JSON.write('transactionSource',
        NVL(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].duplicate.transactionSource', p0=>i)),
            'DCT Manual'));
      APEX_JSON.write('transactionDate',
        TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].duplicate.transactionDate', p0=>i)));
      APEX_JSON.write('accountingDate',
        TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].duplicate.accountingDate', p0=>i)));
      APEX_JSON.close_object;

      APEX_JSON.open_array('lines');
      FOR j IN 1 .. l_nlines LOOP
        l_lineno := TO_NUMBER(APEX_JSON.get_varchar2(
                      p_path=>'rows[%d].lines[%d].lineNumber', p0=>i, p1=>j)
                    DEFAULT NULL ON CONVERSION ERROR);
        l_memo := TRIM(APEX_JSON.get_varchar2(
                    p_path=>'rows[%d].lines[%d].memoLine', p0=>i, p1=>j));
        l_proj := TRIM(APEX_JSON.get_varchar2(
                    p_path=>'rows[%d].lines[%d].projectNumber', p0=>i, p1=>j));
        l_task := TRIM(APEX_JSON.get_varchar2(
                    p_path=>'rows[%d].lines[%d].taskNumber', p0=>i, p1=>j));
        -- the MEMO LINE is the matching key (user rule 2026-07-26): the runner
        -- resolves the grid row by memo line, never by position. lineNumber is
        -- an optional hint and defaults to the payload position.
        IF l_lineno IS NULL THEN l_lineno := j; END IF;
        IF l_lineno < 1 THEN
          APEX_JSON.free_output;
          l_err := 'line ' || j || ': lineNumber must be a whole number >= 1'; RAISE e_row;
        END IF;
        IF l_memo IS NULL THEN
          APEX_JSON.free_output;
          l_err := 'line ' || l_lineno || ': memoLine is required (it is the matching key)';
          RAISE e_row;
        END IF;
        IF l_proj IS NULL OR l_task IS NULL THEN
          APEX_JSON.free_output;
          l_err := 'line ' || l_lineno || ': projectNumber and taskNumber are required';
          RAISE e_row;
        END IF;
        APEX_JSON.open_object;
        APEX_JSON.write('lineNumber', l_lineno);
        APEX_JSON.write('memoLine', l_memo);
        APEX_JSON.write('taxClassification',
          NVL(TRIM(APEX_JSON.get_varchar2(
            p_path=>'rows[%d].lines[%d].taxClassification', p0=>i, p1=>j)),''));
        APEX_JSON.write('projectNumber', l_proj);
        APEX_JSON.write('taskNumber', l_task);
        APEX_JSON.close_object;
      END LOOP;
      APEX_JSON.close_array;
      APEX_JSON.close_object;

      l_payload := APEX_JSON.get_clob_output;
      APEX_JSON.free_output;

      l_aid := atd_action_pkg.enqueue_action(
                 p_action_type   => 'AR_INVOICE_REBILL',
                 p_source_module => 'AR',
                 p_source_type   => 'AR_REBILL',
                 p_source_id     => NULL,
                 p_source_ref    => l_inv,
                 p_idem_key      => 'AR-REBILL:' || UPPER(l_inv),
                 p_payload       => l_payload,
                 p_env_name      => NULL,
                 p_created_by    => l_user);
      l_ok := l_ok + 1;
    EXCEPTION
      WHEN e_row THEN l_bad := l_bad + 1;
      WHEN OTHERS THEN
        BEGIN APEX_JSON.free_output; EXCEPTION WHEN OTHERS THEN NULL; END;
        l_bad := l_bad + 1;
        l_err := SUBSTR(SQLERRM, 1, 400);
    END;
    l_res(i).inv := l_inv;
    l_res(i).aid := l_aid;
    l_res(i).err := l_err;
  END LOOP;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_cnt);
  APEX_JSON.write('enqueued', l_ok);
  APEX_JSON.write('errors', l_bad);
  APEX_JSON.open_array('items');
  FOR i IN 1 .. l_cnt LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('row', i);
    APEX_JSON.write('invoiceNumber', NVL(l_res(i).inv,''));
    IF l_res(i).aid IS NOT NULL THEN APEX_JSON.write('actionId', l_res(i).aid); END IF;
    APEX_JSON.write('status', CASE WHEN l_res(i).err IS NULL THEN 'READY' ELSE 'ERROR' END);
    APEX_JSON.write('error', NVL(l_res(i).err,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- =========================================================================
    -- REBILL REQUESTS -- register
    -- =========================================================================
    def_plsql('rebill/requests', 'GET', q'[
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20)  := UPPER(:status);
  l_search VARCHAR2(200) := :search;
  -- 10000 cap: the page's interactive-report view fetches the register in ONE
  -- shot and filters client-side (same pattern as the AP dashboard registers)
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER(:limit  DEFAULT NULL ON CONVERSION ERROR), 25), 10000);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER(:offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'AR_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN'))
  THEN dct_rest.err(403,'AR_ADMIN required'); RETURN; END IF;

  SELECT COUNT(*) INTO l_total
  FROM   v_atd_ar_rebill_request r
  WHERE  (l_status IS NULL OR r.run_status = l_status)
  AND    (l_search IS NULL OR UPPER(r.invoice_number || ' ' ||
                                    NVL(r.cm_document_number,'') || ' ' ||
                                    NVL(r.new_invoice_number,''))
                              LIKE '%' || UPPER(l_search) || '%');

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total',  l_total);
  APEX_JSON.write('limit',  l_limit);
  APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT r.action_id, r.invoice_number, r.run_status, r.attempts, r.max_attempts,
           r.worker_host, r.submitted_by, r.duration_secs, r.current_stage,
           r.stages_done, r.cm_document_number, r.cm_transaction_number,
           r.new_invoice_number,
           NVL(DBMS_LOB.SUBSTR(r.last_error,300,1),'') AS last_err,
           TO_CHAR(dct_to_local(r.submitted_at),'YYYY-MM-DD HH:MI AM') AS submitted_s,
           TO_CHAR(dct_to_local(r.started_at),  'YYYY-MM-DD HH:MI AM') AS started_s,
           TO_CHAR(dct_to_local(r.finished_at), 'YYYY-MM-DD HH:MI AM') AS finished_s
    FROM   v_atd_ar_rebill_request r
    WHERE  (l_status IS NULL OR r.run_status = l_status)
    AND    (l_search IS NULL OR UPPER(r.invoice_number || ' ' ||
                                      NVL(r.cm_document_number,'') || ' ' ||
                                      NVL(r.new_invoice_number,''))
                                LIKE '%' || UPPER(l_search) || '%')
    ORDER BY r.action_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('actionId', r.action_id);
    APEX_JSON.write('invoiceNumber', NVL(r.invoice_number,''));
    APEX_JSON.write('runStatus', r.run_status);
    APEX_JSON.write('attempts', r.attempts);
    APEX_JSON.write('maxAttempts', r.max_attempts);
    APEX_JSON.write('currentStage', NVL(r.current_stage,''));
    APEX_JSON.write('stagesDone', NVL(r.stages_done,0));
    APEX_JSON.write('cmTransactionNumber', NVL(r.cm_transaction_number,''));
    APEX_JSON.write('cmDocumentNumber', NVL(r.cm_document_number,''));
    APEX_JSON.write('newInvoiceNumber', NVL(r.new_invoice_number,''));
    APEX_JSON.write('submittedBy', NVL(r.submitted_by,''));
    APEX_JSON.write('submittedAt', NVL(r.submitted_s,''));
    APEX_JSON.write('startedAt', NVL(r.started_s,''));
    APEX_JSON.write('finishedAt', NVL(r.finished_s,''));
    IF r.duration_secs IS NOT NULL THEN
      APEX_JSON.write('durationSecs', r.duration_secs);
    END IF;
    APEX_JSON.write('workerVm', NVL(r.worker_host,''));
    APEX_JSON.write('lastError', r.last_err);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- =========================================================================
    -- REBILL REQUESTS -- one request + its stage timeline
    -- =========================================================================
    def_tpl('rebill/requests/:id');

    def_plsql('rebill/requests/:id', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER := TO_NUMBER(:id DEFAULT NULL ON CONVERSION ERROR);
  l_n    NUMBER;
  l_pl   CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'AR_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN'))
  THEN dct_rest.err(403,'AR_ADMIN required'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'id must be numeric'); RETURN; END IF;

  SELECT COUNT(*) INTO l_n FROM v_atd_ar_rebill_request WHERE action_id = l_id;
  IF l_n = 0 THEN dct_rest.err(404,'Request not found'); RETURN; END IF;

  SELECT payload_json INTO l_pl FROM atd_action_request WHERE action_id = l_id;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  FOR r IN (SELECT * FROM v_atd_ar_rebill_request WHERE action_id = l_id) LOOP
    APEX_JSON.write('actionId', r.action_id);
    APEX_JSON.write('invoiceNumber', NVL(r.invoice_number,''));
    APEX_JSON.write('runStatus', r.run_status);
    APEX_JSON.write('attempts', r.attempts);
    APEX_JSON.write('currentStage', NVL(r.current_stage,''));
    APEX_JSON.write('stagesDone', NVL(r.stages_done,0));
    APEX_JSON.write('cmTransactionNumber', NVL(r.cm_transaction_number,''));
    APEX_JSON.write('cmDocumentNumber', NVL(r.cm_document_number,''));
    APEX_JSON.write('newInvoiceNumber', NVL(r.new_invoice_number,''));
    APEX_JSON.write('submittedBy', NVL(r.submitted_by,''));
    APEX_JSON.write('submittedAt',
      NVL(TO_CHAR(dct_to_local(r.submitted_at),'YYYY-MM-DD HH:MI AM'),''));
    APEX_JSON.write('startedAt',
      NVL(TO_CHAR(dct_to_local(r.started_at),'YYYY-MM-DD HH:MI AM'),''));
    APEX_JSON.write('finishedAt',
      NVL(TO_CHAR(dct_to_local(r.finished_at),'YYYY-MM-DD HH:MI AM'),''));
    IF r.duration_secs IS NOT NULL THEN
      APEX_JSON.write('durationSecs', r.duration_secs);
    END IF;
    APEX_JSON.write('workerVm', NVL(r.worker_host,''));
    APEX_JSON.write('lastError', NVL(DBMS_LOB.SUBSTR(r.last_error,3000,1),''));
  END LOOP;

  APEX_JSON.open_array('stages');
  FOR s IN (
    SELECT s.stage_no, s.stage_code, s.status, s.fusion_ref, s.note,
           s.attempt_no, s.worker_host,
           NVL(DBMS_LOB.SUBSTR(s.last_error,300,1),'') AS err,
           TO_CHAR(dct_to_local(s.started_at), 'YYYY-MM-DD HH:MI AM') AS started_s,
           TO_CHAR(dct_to_local(s.finished_at),'YYYY-MM-DD HH:MI AM') AS finished_s,
           (SELECT v.value_name_en FROM dct_lookup_values v
             JOIN dct_lookup_categories c ON c.category_id = v.category_id
            WHERE c.category_code = 'AR_REBILL_STAGE'
              AND v.value_code = s.stage_code)  AS label_en,
           (SELECT v.value_name_ar FROM dct_lookup_values v
             JOIN dct_lookup_categories c ON c.category_id = v.category_id
            WHERE c.category_code = 'AR_REBILL_STAGE'
              AND v.value_code = s.stage_code)  AS label_ar
    FROM   atd_action_step s
    WHERE  s.action_id = l_id
    ORDER BY s.stage_no
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('stageNo', s.stage_no);
    APEX_JSON.write('stageCode', s.stage_code);
    APEX_JSON.write('labelEn', NVL(s.label_en, s.stage_code));
    APEX_JSON.write('labelAr', NVL(s.label_ar, s.stage_code));
    APEX_JSON.write('status', s.status);
    APEX_JSON.write('fusionRef', NVL(s.fusion_ref,''));
    APEX_JSON.write('note', NVL(s.note,''));
    IF s.attempt_no IS NOT NULL THEN APEX_JSON.write('attemptNo', s.attempt_no); END IF;
    APEX_JSON.write('workerVm', NVL(s.worker_host,''));
    APEX_JSON.write('startedAt', NVL(s.started_s,''));
    APEX_JSON.write('finishedAt', NVL(s.finished_s,''));
    APEX_JSON.write('lastError', s.err);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.write('payload', NVL(DBMS_LOB.SUBSTR(l_pl, 30000, 1), ''));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    -- =========================================================================
    -- REBILL -- form value sets (lookup-first: extend in Admin, no deploy)
    -- =========================================================================
    def_tpl('rebill/lovs');

    def_plsql('rebill/lovs', 'GET', q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;

  PROCEDURE emit(p_arr VARCHAR2, p_cat VARCHAR2) IS
  BEGIN
    APEX_JSON.open_array(p_arr);
    FOR v IN (SELECT v.value_code, v.value_name_en, v.value_name_ar, v.is_default
              FROM   dct_lookup_values v
              JOIN   dct_lookup_categories c ON c.category_id = v.category_id
              WHERE  c.category_code = p_cat
              AND    v.is_active = 'Y'
              ORDER BY v.display_order, v.value_code) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('code', v.value_code);
      APEX_JSON.write('nameEn', NVL(v.value_name_en, v.value_code));
      APEX_JSON.write('nameAr', NVL(v.value_name_ar, v.value_code));
      APEX_JSON.write('isDefault', NVL(v.is_default,'N'));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  emit('creditReasons',      'AR_CREDIT_REASON');
  emit('taxClassifications', 'AR_TAX_CLASSIFICATION');
  emit('cmFinish',           'AR_REBILL_CM_FINISH');
  emit('stages',             'AR_REBILL_STAGE');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]');

    COMMIT;
END;
/

SHOW ERRORS

BEGIN
    setup_ar_rebill_ords_tmp;
END;
/

DROP PROCEDURE setup_ar_rebill_ords_tmp;

-- =============================================================================
-- 3. Verify
-- =============================================================================
SELECT t.uri_template, h.method
FROM   user_ords_templates t
JOIN   user_ords_handlers  h ON h.template_id = t.id
JOIN   user_ords_modules   m ON m.id = t.module_id
WHERE  m.name = 'ar.rest'
AND    t.uri_template LIKE 'rebill%'
ORDER  BY 1, 2;

PROMPT AR 11 rebill ORDS : done
