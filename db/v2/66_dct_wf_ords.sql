SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

-- =============================================================================
-- 66_dct_wf_ords.sql
-- i-Finance Workflow Platform (DWP) -- repoint the inbox at the union view
-- Schema : ADMIN (ORDS metadata). OWN SQLcl session -- must not follow any
--          script that set CURRENT_SCHEMA=PROD, or the synonyms self-reference
--          (ORA-01471).
-- Run    : AFTER db/v2/64 (views) and db/v2/65 (compat package).
--
-- This is the change that KILLS THE RE-RUN COUPLING.
--
-- Before: /dct/approvals/pending and /dct/approvals/:id/action carried the
--         approval engine inside their ORDS handler text. Because 11 rebuilds
--         those handlers from scratch, every behaviour patch had to be re-applied
--         afterwards -- which is exactly what db/v2/11b and 11c were, and why
--         "re-run 11c after any 11 re-run" appears in CLAUDE.md.
--
-- After:  both handlers are thin facades over PROD objects. The SAME facade text
--         now lives in 11 itself, so a re-run of 11 REPRODUCES this state instead
--         of reverting it. 11b and 11c are archived. Approval behaviour changes
--         with CREATE OR REPLACE PACKAGE BODY -- no ORDS churn at all.
--
-- BEHAVIOUR: unchanged. db/v2/64t proved the view returns byte-identical rows to
--            the old handler for all 18 active users, and dct_wf_compat.act_on_legacy
--            is a verbatim lift of the old POST body. The response gains three
--            ADDITIVE keys (engine, dueAt, outcomes[]); every existing key keeps
--            its name, type and format, so App 209 and the JET pages are untouched.
--
-- Idempotent. DEFINE_HANDLER only -- never DEFINE_TEMPLATE on an existing
-- template, which would DROP the template's other handlers.
-- =============================================================================

PROMPT === repointing the inbox at DCT_WF_INBOX_V ===

CREATE OR REPLACE SYNONYM dct_wf_inbox_v     FOR prod.dct_wf_inbox_v;
CREATE OR REPLACE SYNONYM dct_wf_chain_v     FOR prod.dct_wf_chain_v;
CREATE OR REPLACE SYNONYM dct_wf_compat      FOR prod.dct_wf_compat;
CREATE OR REPLACE SYNONYM dct_wf_engine      FOR prod.dct_wf_engine;
CREATE OR REPLACE SYNONYM dct_wf_outcome     FOR prod.dct_wf_outcome;
CREATE OR REPLACE SYNONYM dct_wf_outcome_set FOR prod.dct_wf_outcome_set;

BEGIN
    ORDS.DEFINE_HANDLER(
        p_module_name => 'dct.admin',
        p_pattern     => 'approvals/pending',
        p_method      => 'GET',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'[
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
    SELECT id, engine, instance_id, request_ref, source_module, template_name,
           requested_by, submitted_at, amount, currency, current_step, total_steps,
           current_step_name, acting_for, due_at, outcome_set_code
    FROM   dct_wf_inbox_v
    WHERE  user_id = l_uid
    ORDER BY submitted_at
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('instanceId',      r.id);
    APEX_JSON.write('requestRef',      r.request_ref);
    APEX_JSON.write('module',          r.source_module);
    APEX_JSON.write('templateName',    r.template_name);
    APEX_JSON.write('requestedBy',     r.requested_by);
    APEX_JSON.write('requestedAt',     TO_CHAR(dct_to_local(r.submitted_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('amount',          r.amount);
    APEX_JSON.write('currentStep',     r.current_step);
    APEX_JSON.write('totalSteps',      r.total_steps);
    APEX_JSON.write('currentStepName', r.current_step_name);
    APEX_JSON.write('actingFor',       r.acting_for);
    APEX_JSON.write('engine',          r.engine);
    IF r.due_at IS NOT NULL THEN
      APEX_JSON.write('dueAt', TO_CHAR(dct_to_local(r.due_at),'YYYY-MM-DD HH:MI AM'));
    END IF;
    IF r.outcome_set_code IS NOT NULL THEN
      APEX_JSON.open_array('outcomes');
      FOR o IN (SELECT o.outcome_code, o.label_en, o.label_ar, o.semantic,
                       o.is_positive, o.requires_comment, o.color
                FROM   dct_wf_outcome o
                JOIN   dct_wf_outcome_set s ON s.set_id = o.set_id
                WHERE  s.set_code = r.outcome_set_code
                ORDER BY o.display_order) LOOP
        APEX_JSON.open_object;
        APEX_JSON.write('code',            o.outcome_code);
        APEX_JSON.write('labelEn',         o.label_en);
        APEX_JSON.write('labelAr',         o.label_ar);
        APEX_JSON.write('semantic',        o.semantic);
        APEX_JSON.write('isPositive',      o.is_positive);
        APEX_JSON.write('requiresComment', o.requires_comment);
        APEX_JSON.write('color',           o.color);
        APEX_JSON.close_object;
      END LOOP;
      APEX_JSON.close_array;
    END IF;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
]', '[COLON]', CHR(58))
    );

    ORDS.DEFINE_HANDLER(
        p_module_name => 'dct.admin',
        p_pattern     => REPLACE('approvals/[COLON]id/action', '[COLON]', CHR(58)),
        p_method      => 'POST',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'[
DECLARE
  l_user     VARCHAR2(100) := dct_rest.validate_session;
  l_id       NUMBER        := [COLON]id;
  l_uid      NUMBER;
  l_action   VARCHAR2(32);
  l_comments VARCHAR2(4000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_action   := UPPER(APEX_JSON.get_varchar2(p_path => 'action'));
  l_comments := APEX_JSON.get_varchar2(p_path => 'comments');

  dct_wf_compat.act(l_id, l_uid, l_user, l_action, l_comments);

  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('action', l_action);
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
]', '[COLON]', CHR(58))
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('approvals/pending + approvals/:id/action are now facades.');
    DBMS_OUTPUT.PUT_LINE('11b and 11c are retired -- do not re-run them.');
END;
/

PROMPT === 66_dct_wf_ords.sql complete ===
