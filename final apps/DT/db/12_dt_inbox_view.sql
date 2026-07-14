SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

-- =============================================================================
-- 12_dt_inbox_view.sql
-- DT: serve the approvals inbox from the SHARED worklist view.
-- Schema : ADMIN (ORDS metadata). Own SQLcl session.
-- Run    : AFTER db/v2/64 (views) and db/v2/66 (ADMIN synonyms).
--
-- Retires DT's private copy of the inbox query. Eligibility now has ONE
-- definition platform-wide (PROD.DCT_WF_INBOX_V). DT's own response keys are
-- preserved exactly -- its JET page parses them.
--
-- The POST action handler is NOT touched. See the banner in the canonical
-- ORDS script for why.
--
-- ADDITIVE -- DEFINE_HANDLER only (DEFINE_TEMPLATE on an existing template would
-- DROP its other handlers). The same facade is patched into the canonical script,
-- so a re-run of it reproduces this rather than reverting it.
-- =============================================================================

PROMPT === DT: approvals inbox -> DCT_WF_INBOX_V ===

BEGIN
    ORDS.DEFINE_HANDLER(
        p_module_name => 'dt.rest',
        p_pattern     => 'approvals/pending',
        p_method      => 'GET',
        p_source_type => ORDS.source_type_plsql,
        p_source      => q'[
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT id, engine, source_record_id, request_ref, source_module,
           requested_by, submitted_at, amount, current_step_name
    FROM   dct_wf_inbox_v
    WHERE  user_id = l_uid
      AND  source_module IN ('TRAVEL_REQUEST','SETTLEMENT')
    ORDER BY submitted_at
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('instanceId',     r.id);
    APEX_JSON.write('requestRef',     r.request_ref);
    APEX_JSON.write('requestType',    r.source_module);
    APEX_JSON.write('sourceRecordId', r.source_record_id);
    APEX_JSON.write('submittedBy',    r.requested_by);
    APEX_JSON.write('submittedAt',    TO_CHAR(dct_to_local(r.submitted_at),'YYYY-MM-DD"T"HH24":"MI":"SS'));
    APEX_JSON.write('currentStep',    r.current_step_name);
    APEX_JSON.write('amount',         r.amount);
    APEX_JSON.write('overallStatus',  'PENDING');
    APEX_JSON.write('engine',         r.engine);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]'
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('dt.rest approvals/pending now reads the shared inbox view.');
END;
/

PROMPT === 12_dt_inbox_view.sql complete ===
