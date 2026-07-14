SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- 67_dct_wf_api.sql
-- i-Finance Workflow Platform (DWP) -- the /wf/ REST API
-- Schema : ADMIN (ORDS metadata). OWN SQLcl session -- must not follow anything
--          that set CURRENT_SCHEMA=PROD or the synonyms self-reference (ORA-01471).
-- Run    : AFTER db/v2/63 (engine), 64 (views), 65 (compat).
--
-- WHAT THIS SERVES
--   the cross-module worklist, task actions with CUSTOM OUTCOMES, the request
--   timeline, the endorsement chain, and the read side of the process designer.
--
-- MODULE-ACCESS GATE -- /wf/ MUST STAY EXEMPT.
--   db/v2/50 maps an ORDS path segment -> ONE module_code and 403s users who hold
--   no role in that module. /wf/ is CROSS-MODULE BY DEFINITION: it is the platform
--   worklist. Mapping it to any module_code would 403 the worklist for everyone
--   who lacks that module's role -- i.e. almost everyone.
--   `ELSE NULL` already exempts it, which is exactly the trap: it looks like an
--   omission, and a future maintainer "fixes" it. db/v2/50 now carries an explicit
--   `WHEN 'wf' THEN NULL` WITH THIS REASON. Do not map it.
--   Authorization here is PER TASK, in the engine (participant check), never
--   per-module at the gate.
--
-- Idempotent. Re-runnable.
-- =============================================================================

PROMPT === i-Finance Workflow Platform -- /wf/ API ===

PROMPT
PROMPT --- [1/3] synonyms (handlers run as ADMIN) ---

CREATE OR REPLACE SYNONYM dct_wf_engine          FOR prod.dct_wf_engine;
CREATE OR REPLACE SYNONYM dct_wf_expr            FOR prod.dct_wf_expr;
CREATE OR REPLACE SYNONYM dct_wf_compat          FOR prod.dct_wf_compat;
CREATE OR REPLACE SYNONYM dct_wf_inbox_v         FOR prod.dct_wf_inbox_v;
CREATE OR REPLACE SYNONYM dct_wf_chain_v         FOR prod.dct_wf_chain_v;
CREATE OR REPLACE SYNONYM dct_wf_parity_v        FOR prod.dct_wf_parity_v;
CREATE OR REPLACE SYNONYM dct_wf_task            FOR prod.dct_wf_task;
CREATE OR REPLACE SYNONYM dct_wf_task_participant FOR prod.dct_wf_task_participant;
CREATE OR REPLACE SYNONYM dct_wf_instance        FOR prod.dct_wf_instance;
CREATE OR REPLACE SYNONYM dct_wf_step_instance   FOR prod.dct_wf_step_instance;
CREATE OR REPLACE SYNONYM dct_wf_step            FOR prod.dct_wf_step;
CREATE OR REPLACE SYNONYM dct_wf_history         FOR prod.dct_wf_history;
CREATE OR REPLACE SYNONYM dct_wf_outcome         FOR prod.dct_wf_outcome;
CREATE OR REPLACE SYNONYM dct_wf_outcome_set     FOR prod.dct_wf_outcome_set;
CREATE OR REPLACE SYNONYM dct_wf_process         FOR prod.dct_wf_process;
CREATE OR REPLACE SYNONYM dct_wf_process_version FOR prod.dct_wf_process_version;
CREATE OR REPLACE SYNONYM dct_wf_condition       FOR prod.dct_wf_condition;
CREATE OR REPLACE SYNONYM dct_wf_fact_schema     FOR prod.dct_wf_fact_schema;
CREATE OR REPLACE SYNONYM dct_wf_fact_field      FOR prod.dct_wf_fact_field;
CREATE OR REPLACE SYNONYM dct_wf_info_request    FOR prod.dct_wf_info_request;
CREATE OR REPLACE SYNONYM dct_wf_participant_rule FOR prod.dct_wf_participant_rule;
CREATE OR REPLACE SYNONYM dct_wf_route           FOR prod.dct_wf_route;

PROMPT
PROMPT --- [2/3] WF_ADMIN role (designer access) ---

DECLARE
    v NUMBER;
BEGIN
    SELECT COUNT(*) INTO v FROM prod.dct_roles WHERE role_code = 'WF_ADMIN';
    IF v = 0 THEN
        INSERT INTO prod.dct_roles
            (role_code, role_name_en, role_name_ar, role_type,
             description_en, is_system_role, is_active)
        VALUES ('WF_ADMIN', 'Workflow Administrator',
                UNISTR('\0645\0633\0624\0648\0644 \0633\064A\0631 \0627\0644\0639\0645\0644'),
                'SYSTEM',
                'Edits approval process definitions from the UI (requirement 1). '
                || 'Scoped further by dct_wf_process.owner_role_id.',
                'Y', 'Y');
        DBMS_OUTPUT.PUT_LINE('  created role WF_ADMIN');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  exists  role WF_ADMIN');
    END IF;
END;
/

PROMPT
PROMPT --- [3/3] the wf.rest module ---

DECLARE
    c_mod CONSTANT VARCHAR2(30) := 'wf.rest';

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
    BEGIN
        ORDS.DELETE_MODULE(p_module_name => c_mod);
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    ORDS.DEFINE_MODULE(
        p_module_name    => c_mod,
        p_base_path      => '/wf/',
        p_items_per_page => 0,
        p_status         => 'PUBLISHED');

    -- =====================================================================
    -- WORKLIST -- the one list, both engines. Requirement 4.
    -- =====================================================================
    def_template('worklist');
    def_handler('worklist', 'GET', q'!
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
  FOR r IN (SELECT * FROM dct_wf_inbox_v WHERE user_id = l_uid ORDER BY submitted_at) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id',              r.id);
    APEX_JSON.write('engine',          r.engine);
    APEX_JSON.write('instanceId',      r.instance_id);
    APEX_JSON.write('module',          r.source_module);
    APEX_JSON.write('sourceRecordId',  r.source_record_id);
    APEX_JSON.write('requestRef',      r.request_ref);
    APEX_JSON.write('processName',     r.template_name);
    APEX_JSON.write('requestedBy',     r.requested_by);
    APEX_JSON.write('requestedAt',     TO_CHAR(dct_to_local(r.submitted_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('amount',          r.amount);
    APEX_JSON.write('currency',        NVL(r.currency,'AED'));
    APEX_JSON.write('currentStep',     r.current_step);
    APEX_JSON.write('totalSteps',      r.total_steps);
    APEX_JSON.write('currentStepName', r.current_step_name);
    APEX_JSON.write('actingFor',       r.acting_for);
    APEX_JSON.write('via',             r.via);
    IF r.due_at IS NOT NULL THEN
      APEX_JSON.write('dueAt', TO_CHAR(dct_to_local(r.due_at),'YYYY-MM-DD HH:MI AM'));
      APEX_JSON.write('overdue', CASE WHEN r.due_at < SYSTIMESTAMP THEN 'Y' ELSE 'N' END);
    END IF;
    -- the action bar renders THESE. There is no hard-coded Approve/Reject anywhere.
    APEX_JSON.open_array('outcomes');
    IF r.outcome_set_code IS NOT NULL THEN
      FOR o IN (SELECT o.outcome_code, o.label_en, o.label_ar, o.semantic, o.is_positive,
                       o.requires_comment, o.color, o.icon
                  FROM dct_wf_outcome o JOIN dct_wf_outcome_set s ON s.set_id = o.set_id
                 WHERE s.set_code = r.outcome_set_code ORDER BY o.display_order) LOOP
        APEX_JSON.open_object;
        APEX_JSON.write('code', o.outcome_code);
        APEX_JSON.write('labelEn', o.label_en);
        APEX_JSON.write('labelAr', o.label_ar);
        APEX_JSON.write('semantic', o.semantic);
        APEX_JSON.write('isPositive', o.is_positive);
        APEX_JSON.write('requiresComment', o.requires_comment);
        APEX_JSON.write('color', o.color);
        APEX_JSON.write('icon', o.icon);
        APEX_JSON.close_object;
      END LOOP;
    ELSE
      -- a LEGACY row: the old engine only ever had these three
      FOR o IN (SELECT o.outcome_code, o.label_en, o.label_ar, o.semantic, o.is_positive,
                       o.requires_comment, o.color
                  FROM dct_wf_outcome o JOIN dct_wf_outcome_set s ON s.set_id = o.set_id
                 WHERE s.set_code = 'APPROVE_REJECT_RETURN' ORDER BY o.display_order) LOOP
        APEX_JSON.open_object;
        APEX_JSON.write('code', CASE o.outcome_code WHEN 'APPROVE' THEN 'APPROVED'
                                                    WHEN 'REJECT'  THEN 'REJECTED'
                                                    WHEN 'RETURN'  THEN 'RETURNED'
                                                    ELSE o.outcome_code END);
        APEX_JSON.write('labelEn', o.label_en);
        APEX_JSON.write('labelAr', o.label_ar);
        APEX_JSON.write('semantic', o.semantic);
        APEX_JSON.write('isPositive', o.is_positive);
        APEX_JSON.write('requiresComment', 'Y');
        APEX_JSON.write('color', o.color);
        APEX_JSON.close_object;
      END LOOP;
    END IF;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =====================================================================
    -- TASK ACTIONS -- one route, every engine, every outcome
    -- =====================================================================
    def_template('tasks/[COLON]id/action');
    def_handler('tasks/[COLON]id/action', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER        := [COLON]id;
  l_uid  NUMBER;
  l_out  VARCHAR2(32);
  l_cmt  VARCHAR2(4000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_out := UPPER(APEX_JSON.get_varchar2(p_path => 'outcome'));
  IF l_out IS NULL THEN
    l_out := UPPER(APEX_JSON.get_varchar2(p_path => 'action'));   -- legacy callers
  END IF;
  l_cmt := APEX_JSON.get_varchar2(p_path => 'comments');

  dct_wf_compat.act(l_id, l_uid, l_user, l_out, l_cmt);
  COMMIT;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('outcome', l_out);
  APEX_JSON.write('engine', dct_wf_compat.engine_of(l_id));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE IN (-20147, -20303) THEN dct_rest.err(403, SQLERRM);
  ELSIF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
  ELSIF SQLCODE IN (-20001, -20090, -20304, -20305, -20307, -20308, -20309)
     OR SQLCODE BETWEEN -20160 AND -20131 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM);
  END IF;
END;
!');

    def_template('tasks/[COLON]id/claim');
    def_handler('tasks/[COLON]id/claim', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_wf_engine.claim_task([COLON]id, dct_auth.get_user_id(l_user));
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE = -20303 THEN dct_rest.err(403, SQLERRM); ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_template('tasks/[COLON]id/release');
    def_handler('tasks/[COLON]id/release', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_wf_engine.release_task([COLON]id, dct_auth.get_user_id(l_user));
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE = -20303 THEN dct_rest.err(403, SQLERRM); ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_template('tasks/[COLON]id/delegate');
    def_handler('tasks/[COLON]id/delegate', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_to   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_to := APEX_JSON.get_number(p_path => 'toUserId');
  IF l_to IS NULL THEN dct_rest.err(400,'toUserId is required'); RETURN; END IF;
  dct_wf_engine.delegate_task([COLON]id, dct_auth.get_user_id(l_user), l_to,
                              APEX_JSON.get_varchar2(p_path => 'comments'));
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE = -20303 THEN dct_rest.err(403, SQLERRM); ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_template('tasks/[COLON]id/request-info');
    def_handler('tasks/[COLON]id/request-info', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_of   NUMBER;
  l_q    VARCHAR2(2000);
  l_req  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_of := APEX_JSON.get_number(p_path => 'ofUserId');
  l_q  := APEX_JSON.get_varchar2(p_path => 'question');
  IF l_of IS NULL OR l_q IS NULL THEN
    dct_rest.err(400,'ofUserId and question are required'); RETURN;
  END IF;
  l_req := dct_wf_engine.request_info([COLON]id, dct_auth.get_user_id(l_user), l_of, l_q);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('requestId', l_req);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE = -20303 THEN dct_rest.err(403, SQLERRM); ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_template('info-requests/[COLON]id/answer');
    def_handler('info-requests/[COLON]id/answer', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  dct_wf_engine.provide_info([COLON]id, dct_auth.get_user_id(l_user),
                             APEX_JSON.get_varchar2(p_path => 'answer'));
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE = -20303 THEN dct_rest.err(403, SQLERRM);
  ELSIF SQLCODE = -20308 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    -- =====================================================================
    -- TIMELINE -- requirement 4's "and History", for EITHER engine
    -- =====================================================================
    def_template('instances/[COLON]id/history');
    def_handler('instances/[COLON]id/history', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER := [COLON]id;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('events');
  IF l_id >= 900000000 THEN
    NULL;   -- a task id, not an instance id: the caller wants /instances/<instanceId>
  END IF;
  FOR h IN (
    SELECT h.event_code, h.actor_kind, h.outcome_code, h.comments,
           h.from_state, h.to_state, h.source_note, h.event_at,
           u.display_name AS actor_name,
           si.step_key, si.skipped_reason, si.condition_result
      FROM dct_wf_history h
      LEFT JOIN dct_users u ON u.user_id = h.actor_user_id
      LEFT JOIN dct_wf_step_instance si ON si.step_instance_id = h.step_instance_id
     WHERE h.instance_id = l_id
     ORDER BY h.event_at, h.history_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('event',     h.event_code);
    APEX_JSON.write('actorKind', h.actor_kind);
    APEX_JSON.write('actor',     NVL(h.actor_name, '-'));
    APEX_JSON.write('outcome',   h.outcome_code);
    APEX_JSON.write('comments',  h.comments);
    APEX_JSON.write('stepKey',   h.step_key);
    -- "why did this step skip" -- the thing the legacy engine could never say
    APEX_JSON.write('skipReason', h.skipped_reason);
    APEX_JSON.write('note',      h.source_note);
    APEX_JSON.write('at',        TO_CHAR(dct_to_local(h.event_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- the endorsement chain, either engine, keyed by the SOURCE record
    def_template('chain');
    def_handler('chain', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_mod  VARCHAR2(40)  := :module;
  l_rec  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_mod IS NULL OR :record IS NULL THEN
    dct_rest.err(400,'module and record are required'); RETURN;
  END IF;
  l_rec := TO_NUMBER(:record);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('steps');
  FOR c IN (SELECT * FROM dct_wf_chain_v
             WHERE source_module = l_mod AND source_record_id = l_rec
               AND is_current = 'Y' ORDER BY step_seq) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('engine',     c.engine);
    APEX_JSON.write('stepSeq',    c.step_seq);
    APEX_JSON.write('stepName',   c.step_name);
    APEX_JSON.write('approver',   c.approver);
    APEX_JSON.write('status',     c.status);
    APEX_JSON.write('actionedBy', c.actioned_by);
    APEX_JSON.write('actionedAt',
      CASE WHEN c.actioned_at IS NULL THEN NULL
           ELSE TO_CHAR(dct_to_local(c.actioned_at),'YYYY-MM-DD HH:MI AM') END);
    APEX_JSON.write('comments',   c.comments);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =====================================================================
    -- DESIGNER (read) + the two things that make it safe: compile + simulate
    -- =====================================================================
    def_template('processes');
    def_handler('processes', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  -- every derived value is computed IN THE CURSOR. A scalar subquery used as an
  -- actual parameter to APEX_JSON.write parses as an ORDS 555 -- which is
  -- uncatchable, because it never reaches the EXCEPTION block.
  FOR p IN (SELECT p.process_id, p.process_code, p.source_module, p.name_en, p.name_ar,
                   p.is_active, p.requires_final_callback,
                   v.version_no AS pub_ver,
                   v.version_id AS pub_vid,
                   r.engine     AS engine,
                   (SELECT COUNT(*) FROM dct_wf_step s
                     WHERE s.version_id = v.version_id) AS step_count
              FROM dct_wf_process p
              LEFT JOIN dct_wf_process_version v
                     ON v.process_id = p.process_id AND v.status = 'PUBLISHED'
              LEFT JOIN dct_wf_route r
                     ON r.source_module = p.source_module
             ORDER BY p.process_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('processId',   p.process_id);
    APEX_JSON.write('processCode', p.process_code);
    APEX_JSON.write('module',      p.source_module);
    APEX_JSON.write('nameEn',      p.name_en);
    APEX_JSON.write('nameAr',      p.name_ar);
    APEX_JSON.write('isActive',    p.is_active);
    APEX_JSON.write('publishedVersion', p.pub_ver);
    APEX_JSON.write('versionId',   p.pub_vid);
    APEX_JSON.write('routedTo',    NVL(p.engine, 'LEGACY'));
    APEX_JSON.write('steps',       NVL(p.step_count, 0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('versions/[COLON]id/steps');
    def_handler('versions/[COLON]id/steps', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('steps');
  FOR s IN (SELECT s.step_id, s.step_key, s.step_seq, s.name_en, s.name_ar, s.step_kind,
                   s.quorum_type, s.quorum_n, s.sla_hours, s.sla_calendar,
                   s.reminder_offsets, s.comment_required, s.is_final_gate,
                   s.parallel_group,
                   os.set_code, c.expr_text, c.is_valid AS cond_valid
              FROM dct_wf_step s
              LEFT JOIN dct_wf_outcome_set os ON os.set_id = s.outcome_set_id
              LEFT JOIN dct_wf_condition   c  ON c.condition_id = s.condition_id
             WHERE s.version_id = [COLON]id ORDER BY s.step_seq) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('stepId',    s.step_id);
    APEX_JSON.write('stepKey',   s.step_key);
    APEX_JSON.write('stepSeq',   s.step_seq);
    APEX_JSON.write('nameEn',    s.name_en);
    APEX_JSON.write('nameAr',    s.name_ar);
    APEX_JSON.write('kind',      s.step_kind);
    APEX_JSON.write('outcomeSet', s.set_code);
    APEX_JSON.write('condition', s.expr_text);
    APEX_JSON.write('conditionValid', s.cond_valid);
    APEX_JSON.write('quorumType', s.quorum_type);
    APEX_JSON.write('quorumN',   s.quorum_n);
    APEX_JSON.write('slaHours',  s.sla_hours);
    APEX_JSON.write('slaCalendar', s.sla_calendar);
    APEX_JSON.write('reminders', s.reminder_offsets);
    APEX_JSON.write('commentRequired', s.comment_required);
    APEX_JSON.write('parallelGroup', s.parallel_group);
    APEX_JSON.write('isFinalGate', s.is_final_gate);
    APEX_JSON.open_array('participants');
    FOR r IN (SELECT resolver_type, role_code, org_scope, fact_path, static_user_id,
                     fallback_rule, exclude_initiator
                FROM dct_wf_participant_rule
               WHERE step_id = s.step_id ORDER BY rule_seq) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('resolver',  r.resolver_type);
      APEX_JSON.write('roleCode',  r.role_code);
      APEX_JSON.write('orgScope',  r.org_scope);
      APEX_JSON.write('factPath',  r.fact_path);
      APEX_JSON.write('staticUserId', r.static_user_id);
      APEX_JSON.write('fallback',  r.fallback_rule);
      APEX_JSON.write('excludeInitiator', r.exclude_initiator);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('outcome-sets');
    def_handler('outcome-sets', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('sets');
  FOR s IN (SELECT set_id, set_code, name_en, name_ar FROM dct_wf_outcome_set
             ORDER BY set_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('setCode', s.set_code);
    APEX_JSON.write('nameEn',  s.name_en);
    APEX_JSON.write('nameAr',  s.name_ar);
    APEX_JSON.open_array('outcomes');
    FOR o IN (SELECT outcome_code, label_en, label_ar, semantic, counts_toward_quorum,
                     is_positive, requires_comment, color, target_step_key
                FROM dct_wf_outcome WHERE set_id = s.set_id ORDER BY display_order) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('code',     o.outcome_code);
      APEX_JSON.write('labelEn',  o.label_en);
      APEX_JSON.write('labelAr',  o.label_ar);
      APEX_JSON.write('semantic', o.semantic);
      APEX_JSON.write('countsTowardQuorum', o.counts_toward_quorum);
      APEX_JSON.write('isPositive', o.is_positive);
      APEX_JSON.write('requiresComment', o.requires_comment);
      APEX_JSON.write('color',    o.color);
      APEX_JSON.write('targetStepKey', o.target_step_key);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- live validation: an INVALID CONDITION CANNOT BE SAVED. The designer calls
    -- this on every keystroke (debounced).
    def_template('conditions/compile');
    def_handler('conditions/compile', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_ast  CLOB;
  l_err  VARCHAR2(1000);
  l_sch  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user, 'WF_ADMIN') = FALSE
     AND dct_auth.has_role(l_user, 'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403, 'WF_ADMIN required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_sch := APEX_JSON.get_number(p_path => 'schemaId');
  l_ast := dct_wf_expr.compile(APEX_JSON.get_varchar2(p_path => 'expr'), l_sch, l_err);

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('valid', l_ast IS NOT NULL);
  APEX_JSON.write('error', l_err);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- the highest-value safeguard in the design: dry-run a real request and see
    -- which steps fire, WHICH SKIP AND WHY, and who would actually be asked.
    -- Creates NOTHING.
    def_template('processes/[COLON]code/simulate');
    def_handler('processes/[COLON]code/simulate', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_out  CLOB;
  l_f    CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user, 'WF_ADMIN') = FALSE
     AND dct_auth.has_role(l_user, 'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403, 'WF_ADMIN required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_f := APEX_JSON.get_clob(p_path => 'facts');
  IF l_f IS NULL THEN l_f := TO_CLOB('{"roles":[]}'); END IF;

  l_out := dct_wf_engine.simulate([COLON]code, l_f,
                                  dct_auth.get_user_id(l_user));
  OWA_UTIL.mime_header('application/json', FALSE);
  OWA_UTIL.http_header_close;
  HTP.prn(l_out);
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM); ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    -- shadow-mode drift report (SYS_ADMIN): the entry gate for every cutover
    def_template('parity');
    def_handler('parity', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user, 'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403, 'SYS_ADMIN required'); RETURN;
  END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR p IN (SELECT * FROM dct_wf_parity_v ORDER BY source_module, source_record_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('module',       p.source_module);
    APEX_JSON.write('requestRef',   p.source_record_ref);
    APEX_JSON.write('legacyStatus', p.legacy_status);
    APEX_JSON.write('wfStatus',     p.wf_status);
    APEX_JSON.write('legacyStep',   p.legacy_step);
    APEX_JSON.write('wfStep',       p.wf_step);
    APEX_JSON.write('verdict',      p.verdict);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('  wf.rest defined at /ords/admin/wf/');
END;
/

PROMPT
PROMPT === /wf/ API done -- verifying ===

SELECT m.name AS module_name, m.uri_prefix, COUNT(DISTINCT t.id) AS templates,
       COUNT(h.id) AS handlers
  FROM user_ords_modules m
  LEFT JOIN user_ords_templates t ON t.module_id = m.id
  LEFT JOIN user_ords_handlers  h ON h.template_id = t.id
 WHERE m.name = 'wf.rest'
 GROUP BY m.name, m.uri_prefix;

SELECT t.uri_template, h.method
  FROM user_ords_modules m
  JOIN user_ords_templates t ON t.module_id = m.id
  JOIN user_ords_handlers  h ON h.template_id = t.id
 WHERE m.name = 'wf.rest'
 ORDER BY t.uri_template, h.method;
