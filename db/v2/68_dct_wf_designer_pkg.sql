SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- 68_dct_wf_designer_pkg.sql
-- i-Finance Workflow Platform (DWP) -- DCT_WF_DESIGNER
-- Schema : PROD  (run: sql -name prod_mcp @68_dct_wf_designer_pkg.sql)
-- Run    : AFTER db/v2/60 (ddl), 61 (seed), 62 (expr), 63 (engine).
--
-- WHAT THIS IS -- requirement 1: end users edit approval chains from a UI page.
--   The WRITE side of the process designer. A published version is IMMUTABLE;
--   editing means clone -> DRAFT -> edit -> publish (retire prior). Instances pin
--   their version_id, so in-flight work is never touched by an edit.
--
--   Exactly ONE draft per process at a time (clone returns the open draft if one
--   already exists). Only a DRAFT version is editable -- every mutator asserts it.
--   No COMMIT in this package: the ORDS handler owns the transaction boundary,
--   same contract as DCT_WF_ENGINE / DCT_WF_COMPAT.
--
--   Conditions are compiled at SAVE time by DCT_WF_EXPR (never parsed at runtime);
--   an invalid condition is stored with is_valid='N' so the draft keeps the
--   in-progress text, and publish() REFUSES a version that still holds one.
-- =============================================================================

PROMPT === DCT_WF_DESIGNER -- process designer write API ===

CREATE OR REPLACE PACKAGE prod.dct_wf_designer AS

    -- clone the latest version of a process into a fresh DRAFT and return its id.
    -- if an open DRAFT already exists, returns THAT (one draft per process).
    FUNCTION clone_to_draft (p_process_code VARCHAR2, p_user VARCHAR2) RETURN NUMBER;

    -- upsert a condition on a DRAFT (compiles via DCT_WF_EXPR; stores AST + validity).
    PROCEDURE save_condition (p_version_id   NUMBER,
                              p_condition_key VARCHAR2,
                              p_expr         VARCHAR2,
                              p_name_en      VARCHAR2,
                              p_name_ar      VARCHAR2,
                              p_user         VARCHAR2,
                              o_valid        OUT VARCHAR2,
                              o_error        OUT VARCHAR2);

    PROCEDURE delete_condition (p_version_id NUMBER, p_condition_key VARCHAR2);

    -- upsert a step from a JSON payload (keys documented in the body). Resolves
    -- conditionKey / outcomeSetCode / escalateRoleCode within the version.
    PROCEDURE save_step (p_version_id NUMBER, p_json CLOB, p_user VARCHAR2,
                         o_step_id OUT NUMBER);

    PROCEDURE delete_step (p_version_id NUMBER, p_step_key VARCHAR2);

    -- upsert a participant rule (who is asked) on a step of a DRAFT.
    PROCEDURE save_participant_rule (p_version_id NUMBER, p_json CLOB,
                                     o_rule_id OUT NUMBER);

    PROCEDURE delete_participant_rule (p_version_id NUMBER, p_rule_id NUMBER);

    -- returns NULL if the version is publishable, else a '; '-joined problem list.
    FUNCTION validate_version (p_version_id NUMBER) RETURN VARCHAR2;

    -- publish a DRAFT: validate, retire the prior PUBLISHED, activate the process.
    PROCEDURE publish (p_version_id NUMBER, p_user VARCHAR2);

    -- throw away a DRAFT and everything under it.
    PROCEDURE discard_draft (p_version_id NUMBER);

    -- authz for the designer API: WF_ADMIN or SYS_ADMIN, further scoped by
    -- dct_wf_process.owner_role_id when the process sets one (FL_ADMIN edits FL
    -- chains, not Petty Cash's). Returns 'Y'/'N'.
    FUNCTION can_edit_process (p_user VARCHAR2, p_process_code VARCHAR2) RETURN VARCHAR2;
    FUNCTION can_edit_version (p_user VARCHAR2, p_version_id NUMBER) RETURN VARCHAR2;

END dct_wf_designer;
/
SHOW ERRORS PACKAGE prod.dct_wf_designer

CREATE OR REPLACE PACKAGE BODY prod.dct_wf_designer AS

    -- ---- small JSON helpers ------------------------------------------------
    FUNCTION js (o JSON_OBJECT_T, k VARCHAR2, d VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
    BEGIN
        IF o.has(k) THEN RETURN NVL(o.get_string(k), d); ELSE RETURN d; END IF;
    END js;

    FUNCTION jn (o JSON_OBJECT_T, k VARCHAR2, d NUMBER DEFAULT NULL) RETURN NUMBER IS
    BEGIN
        IF o.has(k) AND o.get_string(k) IS NOT NULL THEN RETURN o.get_number(k); ELSE RETURN d; END IF;
    END jn;

    -- yes/no, tolerant of 'Y'/'N', true/false, 1/0
    FUNCTION jyn (o JSON_OBJECT_T, k VARCHAR2, d VARCHAR2 DEFAULT 'N') RETURN VARCHAR2 IS
        v VARCHAR2(10);
    BEGIN
        IF NOT o.has(k) THEN RETURN d; END IF;
        v := UPPER(NVL(o.get_string(k), d));
        RETURN CASE WHEN v IN ('Y','YES','TRUE','1') THEN 'Y'
                    WHEN v IN ('N','NO','FALSE','0') THEN 'N'
                    ELSE d END;
    END jyn;

    -- ---- guards ------------------------------------------------------------
    PROCEDURE assert_draft (p_version_id NUMBER) IS
        v_st VARCHAR2(12);
    BEGIN
        SELECT status INTO v_st FROM prod.dct_wf_process_version WHERE version_id = p_version_id;
        IF v_st <> 'DRAFT' THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Version ' || p_version_id || ' is ' || v_st ||
                ' -- only a DRAFT is editable. Clone it to a new draft first.');
        END IF;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'Version ' || p_version_id || ' not found.');
    END assert_draft;

    FUNCTION process_of (p_version_id NUMBER) RETURN NUMBER IS
        v NUMBER;
    BEGIN
        SELECT process_id INTO v FROM prod.dct_wf_process_version WHERE version_id = p_version_id;
        RETURN v;
    END process_of;

    -- =======================================================================
    -- CLONE -> DRAFT   (deep copy: conditions -> steps -> participant rules)
    -- =======================================================================
    FUNCTION clone_to_draft (p_process_code VARCHAR2, p_user VARCHAR2) RETURN NUMBER IS
        v_pid       NUMBER;
        v_src       NUMBER;
        v_src_no    NUMBER;
        v_src_st    VARCHAR2(12);
        v_new       NUMBER;
        TYPE t_map IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        m_cond      t_map;   -- old condition_id -> new
        m_step      t_map;   -- old step_id      -> new
        v_newc      NUMBER;
        v_news      NUMBER;
        v_mapc      NUMBER;   -- remapped condition_id (resolved in PL/SQL, never in SQL)
        v_maps      NUMBER;   -- remapped step_id
    BEGIN
        SELECT process_id INTO v_pid FROM prod.dct_wf_process WHERE process_code = p_process_code;

        -- latest version (any status) is the clone source
        SELECT version_id, version_no, status INTO v_src, v_src_no, v_src_st
        FROM (SELECT version_id, version_no, status FROM prod.dct_wf_process_version
              WHERE process_id = v_pid ORDER BY version_no DESC)
        WHERE ROWNUM = 1;

        -- one draft at a time
        IF v_src_st = 'DRAFT' THEN RETURN v_src; END IF;

        INSERT INTO prod.dct_wf_process_version
            (process_id, version_no, status, notes, created_by)
        VALUES (v_pid, v_src_no + 1, 'DRAFT',
                'Cloned from v' || v_src_no, p_user)
        RETURNING version_id INTO v_new;

        -- conditions (build old->new id map)
        FOR c IN (SELECT * FROM prod.dct_wf_condition WHERE version_id = v_src) LOOP
            INSERT INTO prod.dct_wf_condition
                (version_id, condition_key, name_en, name_ar, expr_text, expr_ast,
                 compiler_version, compiled_by, compiled_at, is_valid, compile_error)
            VALUES (v_new, c.condition_key, c.name_en, c.name_ar, c.expr_text, c.expr_ast,
                    c.compiler_version, c.compiled_by, c.compiled_at, c.is_valid, c.compile_error)
            RETURNING condition_id INTO v_newc;
            m_cond(c.condition_id) := v_newc;
        END LOOP;

        -- steps (remap condition_id; outcome sets are shared, copy as-is)
        FOR s IN (SELECT * FROM prod.dct_wf_step WHERE version_id = v_src ORDER BY step_seq) LOOP
            IF s.condition_id IS NULL THEN v_mapc := NULL; ELSE v_mapc := m_cond(s.condition_id); END IF;
            INSERT INTO prod.dct_wf_step
                (version_id, step_key, step_seq, name_en, name_ar, step_kind, stage_key,
                 parallel_group, quorum_type, quorum_n, veto_on_reject, condition_id,
                 outcome_set_id, sla_hours, sla_calendar, reminder_offsets, escalate_role_id,
                 escalate_after_hours, auto_action_outcome, auto_action_after_hours,
                 allow_claim, allow_delegate, allow_request_info, allow_reassign,
                 allow_attachment, comment_required, system_action_code, refresh_facts_before,
                 is_final_gate, display_order)
            VALUES (v_new, s.step_key, s.step_seq, s.name_en, s.name_ar, s.step_kind, s.stage_key,
                 s.parallel_group, s.quorum_type, s.quorum_n, s.veto_on_reject,
                 v_mapc,
                 s.outcome_set_id, s.sla_hours, s.sla_calendar, s.reminder_offsets, s.escalate_role_id,
                 s.escalate_after_hours, s.auto_action_outcome, s.auto_action_after_hours,
                 s.allow_claim, s.allow_delegate, s.allow_request_info, s.allow_reassign,
                 s.allow_attachment, s.comment_required, s.system_action_code, s.refresh_facts_before,
                 s.is_final_gate, s.display_order)
            RETURNING step_id INTO v_news;
            m_step(s.step_id) := v_news;
        END LOOP;

        -- participant rules (remap step_id)
        FOR r IN (SELECT pr.* FROM prod.dct_wf_participant_rule pr
                  JOIN prod.dct_wf_step st ON st.step_id = pr.step_id
                  WHERE st.version_id = v_src) LOOP
            v_maps := m_step(r.step_id);
            INSERT INTO prod.dct_wf_participant_rule
                (step_id, rule_seq, participant_type, resolver_type, role_code, org_scope,
                 org_fact_path, static_org_id, static_user_id, fact_path, ref_step_key,
                 levels_up, resolution_mode, fallback_rule, min_resolved, include_delegates,
                 exclude_initiator)
            VALUES (v_maps, r.rule_seq, r.participant_type, r.resolver_type, r.role_code,
                 r.org_scope, r.org_fact_path, r.static_org_id, r.static_user_id, r.fact_path,
                 r.ref_step_key, r.levels_up, r.resolution_mode, r.fallback_rule, r.min_resolved,
                 r.include_delegates, r.exclude_initiator);
        END LOOP;

        RETURN v_new;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'Process ' || p_process_code || ' not found.');
    END clone_to_draft;

    -- =======================================================================
    -- CONDITIONS
    -- =======================================================================
    PROCEDURE save_condition (p_version_id   NUMBER,
                              p_condition_key VARCHAR2,
                              p_expr         VARCHAR2,
                              p_name_en      VARCHAR2,
                              p_name_ar      VARCHAR2,
                              p_user         VARCHAR2,
                              o_valid        OUT VARCHAR2,
                              o_error        OUT VARCHAR2) IS
        v_sch  NUMBER;
        v_ast  CLOB;
        v_n    NUMBER;
    BEGIN
        assert_draft(p_version_id);

        SELECT p.schema_id INTO v_sch
        FROM prod.dct_wf_process_version v JOIN prod.dct_wf_process p ON p.process_id = v.process_id
        WHERE v.version_id = p_version_id;

        v_ast   := prod.dct_wf_expr.compile(p_expr, v_sch, o_error);
        o_valid := CASE WHEN v_ast IS NOT NULL THEN 'Y' ELSE 'N' END;

        SELECT COUNT(*) INTO v_n FROM prod.dct_wf_condition
        WHERE version_id = p_version_id AND condition_key = p_condition_key;

        IF v_n = 0 THEN
            INSERT INTO prod.dct_wf_condition
                (version_id, condition_key, name_en, name_ar, expr_text, expr_ast,
                 compiler_version, compiled_by, compiled_at, is_valid, compile_error)
            VALUES (p_version_id, p_condition_key, p_name_en, p_name_ar, p_expr, v_ast,
                    '1', p_user, SYSTIMESTAMP, o_valid, o_error);
        ELSE
            UPDATE prod.dct_wf_condition
            SET name_en = p_name_en, name_ar = p_name_ar, expr_text = p_expr, expr_ast = v_ast,
                compiler_version = '1', compiled_by = p_user, compiled_at = SYSTIMESTAMP,
                is_valid = o_valid, compile_error = o_error
            WHERE version_id = p_version_id AND condition_key = p_condition_key;
        END IF;
    END save_condition;

    PROCEDURE delete_condition (p_version_id NUMBER, p_condition_key VARCHAR2) IS
        v_cid NUMBER;
    BEGIN
        assert_draft(p_version_id);
        SELECT condition_id INTO v_cid FROM prod.dct_wf_condition
        WHERE version_id = p_version_id AND condition_key = p_condition_key;
        -- detach any step first so the FK never blocks the delete
        UPDATE prod.dct_wf_step SET condition_id = NULL
        WHERE version_id = p_version_id AND condition_id = v_cid;
        DELETE FROM prod.dct_wf_condition WHERE condition_id = v_cid;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END delete_condition;

    -- =======================================================================
    -- STEPS
    -- =======================================================================
    PROCEDURE save_step (p_version_id NUMBER, p_json CLOB, p_user VARCHAR2,
                         o_step_id OUT NUMBER) IS
        o        JSON_OBJECT_T := JSON_OBJECT_T.parse(p_json);
        v_key    VARCHAR2(40);
        v_cond   NUMBER;
        v_set    NUMBER;
        v_role   NUMBER;
        v_ckey   VARCHAR2(40);
        v_scode  VARCHAR2(40);
        v_rcode  VARCHAR2(100);
        v_n      NUMBER;
        -- resolve every JSON value into a local FIRST: a body-private helper can
        -- never be called from SQL DML (PLS-00231). Same rule as the engine.
        l_seq    NUMBER;
        l_nen    VARCHAR2(200); l_nar VARCHAR2(200); l_kind VARCHAR2(16);
        l_pg     VARCHAR2(40);  l_qt VARCHAR2(10);   l_qn NUMBER;   l_veto VARCHAR2(1);
        l_sla    NUMBER;        l_cal VARCHAR2(20);  l_rem VARCHAR2(200); l_esch NUMBER;
        l_auto   VARCHAR2(32);  l_autoh NUMBER;
        l_ac VARCHAR2(1); l_ad VARCHAR2(1); l_ari VARCHAR2(1); l_are VARCHAR2(1); l_aat VARCHAR2(1);
        l_creq   VARCHAR2(12);  l_sys VARCHAR2(60);  l_fg VARCHAR2(1); l_disp NUMBER;
    BEGIN
        assert_draft(p_version_id);
        v_key := js(o, 'stepKey');
        IF v_key IS NULL THEN RAISE_APPLICATION_ERROR(-20001, 'stepKey is required.'); END IF;

        -- resolve references within the version
        v_ckey  := js(o, 'conditionKey');
        v_scode := js(o, 'outcomeSetCode');
        v_rcode := js(o, 'escalateRoleCode');

        IF v_ckey IS NOT NULL THEN
            BEGIN SELECT condition_id INTO v_cond FROM prod.dct_wf_condition
                  WHERE version_id = p_version_id AND condition_key = v_ckey;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'Unknown conditionKey "' || v_ckey || '" for this version.');
            END;
        END IF;
        IF v_scode IS NOT NULL THEN
            BEGIN SELECT set_id INTO v_set FROM prod.dct_wf_outcome_set WHERE set_code = v_scode;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'Unknown outcomeSetCode "' || v_scode || '".');
            END;
        END IF;
        IF v_rcode IS NOT NULL THEN
            BEGIN SELECT role_id INTO v_role FROM prod.dct_roles WHERE role_code = v_rcode;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_role := NULL; END;
        END IF;

        l_seq := jn(o, 'stepSeq');
        IF l_seq IS NULL THEN
            SELECT NVL(MAX(step_seq), 0) + 10 INTO l_seq FROM prod.dct_wf_step WHERE version_id = p_version_id;
        END IF;
        l_nen  := js(o,'nameEn');            l_nar  := js(o,'nameAr');
        l_kind := js(o,'stepKind','HUMAN');  l_pg   := js(o,'parallelGroup');
        l_qt   := js(o,'quorumType','ALL');  l_qn   := jn(o,'quorumN');
        l_veto := jyn(o,'vetoOnReject','Y'); l_sla  := jn(o,'slaHours');
        l_cal  := js(o,'slaCalendar','CALENDAR'); l_rem := js(o,'reminderOffsets');
        l_esch := jn(o,'escalateAfterHours'); l_auto := js(o,'autoActionOutcome');
        l_autoh:= jn(o,'autoActionAfterHours');
        l_ac := jyn(o,'allowClaim','Y');     l_ad  := jyn(o,'allowDelegate','Y');
        l_ari:= jyn(o,'allowRequestInfo','Y'); l_are := jyn(o,'allowReassign','Y');
        l_aat:= jyn(o,'allowAttachment','Y');
        l_creq := js(o,'commentRequired','ON_NEGATIVE'); l_sys := js(o,'systemActionCode');
        l_fg   := jyn(o,'isFinalGate','N');  l_disp := jn(o,'displayOrder',10);

        SELECT COUNT(*) INTO v_n FROM prod.dct_wf_step
        WHERE version_id = p_version_id AND step_key = v_key;

        IF v_n = 0 THEN
            INSERT INTO prod.dct_wf_step
                (version_id, step_key, step_seq, name_en, name_ar, step_kind, parallel_group,
                 quorum_type, quorum_n, veto_on_reject, condition_id, outcome_set_id, sla_hours,
                 sla_calendar, reminder_offsets, escalate_role_id, escalate_after_hours,
                 auto_action_outcome, auto_action_after_hours, allow_claim, allow_delegate,
                 allow_request_info, allow_reassign, allow_attachment, comment_required,
                 system_action_code, is_final_gate, display_order)
            VALUES (p_version_id, v_key, l_seq, l_nen, l_nar, l_kind, l_pg,
                 l_qt, l_qn, l_veto, v_cond, v_set, l_sla,
                 l_cal, l_rem, v_role, l_esch,
                 l_auto, l_autoh, l_ac, l_ad, l_ari, l_are, l_aat, l_creq,
                 l_sys, l_fg, l_disp)
            RETURNING step_id INTO o_step_id;
        ELSE
            UPDATE prod.dct_wf_step SET
                 step_seq = l_seq, name_en = l_nen, name_ar = l_nar, step_kind = l_kind,
                 parallel_group = l_pg, quorum_type = l_qt, quorum_n = l_qn, veto_on_reject = l_veto,
                 condition_id = v_cond, outcome_set_id = v_set, sla_hours = l_sla, sla_calendar = l_cal,
                 reminder_offsets = l_rem, escalate_role_id = v_role, escalate_after_hours = l_esch,
                 auto_action_outcome = l_auto, auto_action_after_hours = l_autoh,
                 allow_claim = l_ac, allow_delegate = l_ad, allow_request_info = l_ari,
                 allow_reassign = l_are, allow_attachment = l_aat, comment_required = l_creq,
                 system_action_code = l_sys, is_final_gate = l_fg, display_order = l_disp
            WHERE version_id = p_version_id AND step_key = v_key
            RETURNING step_id INTO o_step_id;
        END IF;
    END save_step;

    PROCEDURE delete_step (p_version_id NUMBER, p_step_key VARCHAR2) IS
        v_sid NUMBER;
    BEGIN
        assert_draft(p_version_id);
        SELECT step_id INTO v_sid FROM prod.dct_wf_step
        WHERE version_id = p_version_id AND step_key = p_step_key;
        DELETE FROM prod.dct_wf_participant_rule WHERE step_id = v_sid;
        DELETE FROM prod.dct_wf_step WHERE step_id = v_sid;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END delete_step;

    -- =======================================================================
    -- PARTICIPANT RULES (who is asked)
    -- =======================================================================
    PROCEDURE save_participant_rule (p_version_id NUMBER, p_json CLOB,
                                     o_rule_id OUT NUMBER) IS
        o       JSON_OBJECT_T := JSON_OBJECT_T.parse(p_json);
        v_skey  VARCHAR2(40);
        v_sid   NUMBER;
        v_rid   NUMBER;
        -- locals first (PLS-00231: no body-private helper inside SQL DML)
        l_seq   NUMBER; l_pt VARCHAR2(20); l_rt VARCHAR2(24); l_rc VARCHAR2(100);
        l_os    VARCHAR2(20); l_ofp VARCHAR2(200); l_soi NUMBER; l_sui NUMBER;
        l_fp    VARCHAR2(200); l_rsk VARCHAR2(40); l_lu NUMBER; l_rm VARCHAR2(12);
        l_fb    VARCHAR2(20); l_mr NUMBER; l_id VARCHAR2(1); l_ei VARCHAR2(1);
    BEGIN
        assert_draft(p_version_id);
        v_skey := js(o, 'stepKey');
        BEGIN
            SELECT step_id INTO v_sid FROM prod.dct_wf_step
            WHERE version_id = p_version_id AND step_key = v_skey;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Unknown stepKey "' || v_skey || '" for this version.');
        END;

        v_rid := jn(o, 'ruleId');
        l_seq := jn(o, 'ruleSeq', 10);
        l_pt  := js(o,'participantType','POTENTIAL_OWNER'); l_rt := js(o,'resolverType');
        l_rc  := js(o,'roleCode');       l_os  := js(o,'orgScope','NONE');
        l_ofp := js(o,'orgFactPath');    l_soi := jn(o,'staticOrgId'); l_sui := jn(o,'staticUserId');
        l_fp  := js(o,'factPath');       l_rsk := js(o,'refStepKey');  l_lu  := jn(o,'levelsUp',0);
        l_rm  := js(o,'resolutionMode','UNION'); l_fb := js(o,'fallbackRule','ANY_ROLE_HOLDER');
        l_mr  := jn(o,'minResolved',1);  l_id  := jyn(o,'includeDelegates','Y'); l_ei := jyn(o,'excludeInitiator','Y');

        IF v_rid IS NOT NULL THEN
            UPDATE prod.dct_wf_participant_rule SET
                 rule_seq = l_seq, participant_type = l_pt, resolver_type = l_rt, role_code = l_rc,
                 org_scope = l_os, org_fact_path = l_ofp, static_org_id = l_soi, static_user_id = l_sui,
                 fact_path = l_fp, ref_step_key = l_rsk, levels_up = l_lu, resolution_mode = l_rm,
                 fallback_rule = l_fb, min_resolved = l_mr, include_delegates = l_id, exclude_initiator = l_ei
            WHERE rule_id = v_rid AND step_id = v_sid
            RETURNING rule_id INTO o_rule_id;
            IF o_rule_id IS NULL THEN RAISE_APPLICATION_ERROR(-20404, 'Rule ' || v_rid || ' not found on this step.'); END IF;
        ELSE
            INSERT INTO prod.dct_wf_participant_rule
                (step_id, rule_seq, participant_type, resolver_type, role_code, org_scope,
                 org_fact_path, static_org_id, static_user_id, fact_path, ref_step_key, levels_up,
                 resolution_mode, fallback_rule, min_resolved, include_delegates, exclude_initiator)
            VALUES (v_sid, l_seq, l_pt, l_rt, l_rc, l_os, l_ofp, l_soi, l_sui, l_fp, l_rsk, l_lu,
                 l_rm, l_fb, l_mr, l_id, l_ei)
            RETURNING rule_id INTO o_rule_id;
        END IF;
    END save_participant_rule;

    PROCEDURE delete_participant_rule (p_version_id NUMBER, p_rule_id NUMBER) IS
        v_ok NUMBER;
    BEGIN
        assert_draft(p_version_id);
        -- the rule must belong to a step of THIS version (never delete cross-version)
        SELECT COUNT(*) INTO v_ok FROM prod.dct_wf_participant_rule pr
        JOIN prod.dct_wf_step st ON st.step_id = pr.step_id
        WHERE pr.rule_id = p_rule_id AND st.version_id = p_version_id;
        IF v_ok = 0 THEN RETURN; END IF;
        DELETE FROM prod.dct_wf_participant_rule WHERE rule_id = p_rule_id;
    END delete_participant_rule;

    -- =======================================================================
    -- VALIDATE + PUBLISH
    -- =======================================================================
    FUNCTION validate_version (p_version_id NUMBER) RETURN VARCHAR2 IS
        v_probs VARCHAR2(4000) := NULL;
        v_n     NUMBER;
        PROCEDURE add (p VARCHAR2) IS
        BEGIN
            v_probs := CASE WHEN v_probs IS NULL THEN p ELSE v_probs || '; ' || p END;
        END;
    BEGIN
        SELECT COUNT(*) INTO v_n FROM prod.dct_wf_step WHERE version_id = p_version_id;
        IF v_n = 0 THEN add('no steps defined'); RETURN v_probs; END IF;

        -- Arabic labels required (requirement 3: no half-translated process ships)
        FOR r IN (SELECT step_key FROM prod.dct_wf_step
                  WHERE version_id = p_version_id AND (name_ar IS NULL OR name_en IS NULL)
                  ORDER BY step_seq) LOOP
            add('step "' || r.step_key || '" missing EN/AR name');
        END LOOP;

        -- every invalid condition blocks publish (requirement 5 safety)
        FOR r IN (SELECT condition_key FROM prod.dct_wf_condition
                  WHERE version_id = p_version_id AND is_valid = 'N') LOOP
            add('condition "' || r.condition_key || '" is invalid');
        END LOOP;

        -- HUMAN steps need participants AND an outcome set (the action bar)
        FOR r IN (SELECT s.step_key,
                         (SELECT COUNT(*) FROM prod.dct_wf_participant_rule pr WHERE pr.step_id = s.step_id) AS parts,
                         s.outcome_set_id
                  FROM prod.dct_wf_step s
                  WHERE s.version_id = p_version_id AND s.step_kind = 'HUMAN'
                  ORDER BY s.step_seq) LOOP
            IF r.parts = 0 THEN add('step "' || r.step_key || '" has no participants'); END IF;
            IF r.outcome_set_id IS NULL THEN add('step "' || r.step_key || '" has no outcome set'); END IF;
        END LOOP;

        -- exactly the final approval must exist
        SELECT COUNT(*) INTO v_n FROM prod.dct_wf_step
        WHERE version_id = p_version_id AND is_final_gate = 'Y';
        IF v_n = 0 THEN add('no final-gate step marked'); END IF;

        RETURN v_probs;
    END validate_version;

    PROCEDURE publish (p_version_id NUMBER, p_user VARCHAR2) IS
        v_pid   NUMBER;
        v_probs VARCHAR2(4000);
    BEGIN
        assert_draft(p_version_id);
        v_probs := validate_version(p_version_id);
        IF v_probs IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Cannot publish: ' || v_probs);
        END IF;
        v_pid := process_of(p_version_id);

        UPDATE prod.dct_wf_process_version
        SET status = 'RETIRED', retired_at = SYSTIMESTAMP
        WHERE process_id = v_pid AND status = 'PUBLISHED';

        UPDATE prod.dct_wf_process_version
        SET status = 'PUBLISHED', published_by = p_user, published_at = SYSTIMESTAMP,
            effective_from = SYSDATE
        WHERE version_id = p_version_id;

        UPDATE prod.dct_wf_process
        SET is_active = 'Y', updated_by = p_user, updated_at = SYSTIMESTAMP
        WHERE process_id = v_pid;
    END publish;

    PROCEDURE discard_draft (p_version_id NUMBER) IS
    BEGIN
        assert_draft(p_version_id);
        DELETE FROM prod.dct_wf_participant_rule pr
        WHERE pr.step_id IN (SELECT step_id FROM prod.dct_wf_step WHERE version_id = p_version_id);
        DELETE FROM prod.dct_wf_step WHERE version_id = p_version_id;
        DELETE FROM prod.dct_wf_condition WHERE version_id = p_version_id;
        DELETE FROM prod.dct_wf_process_version WHERE version_id = p_version_id;
    END discard_draft;

    -- =======================================================================
    -- AUTHZ
    -- =======================================================================
    FUNCTION can_edit_process (p_user VARCHAR2, p_process_code VARCHAR2) RETURN VARCHAR2 IS
        v_rc VARCHAR2(100);
    BEGIN
        IF prod.dct_auth.has_role(p_user, 'SYS_ADMIN') THEN RETURN 'Y'; END IF;
        IF NOT prod.dct_auth.has_role(p_user, 'WF_ADMIN') THEN RETURN 'N'; END IF;
        -- owner scoping: only enforced when the process names an owner role
        BEGIN
            SELECT r.role_code INTO v_rc
            FROM prod.dct_wf_process p JOIN prod.dct_roles r ON r.role_id = p.owner_role_id
            WHERE p.process_code = p_process_code;
        EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 'Y';   -- no owner role -> WF_ADMIN suffices
        END;
        RETURN CASE WHEN prod.dct_auth.has_role(p_user, v_rc) THEN 'Y' ELSE 'N' END;
    END can_edit_process;

    FUNCTION can_edit_version (p_user VARCHAR2, p_version_id NUMBER) RETURN VARCHAR2 IS
        v_code VARCHAR2(60);
    BEGIN
        SELECT p.process_code INTO v_code
        FROM prod.dct_wf_process_version v JOIN prod.dct_wf_process p ON p.process_id = v.process_id
        WHERE v.version_id = p_version_id;
        RETURN can_edit_process(p_user, v_code);
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 'N';
    END can_edit_version;

END dct_wf_designer;
/
SHOW ERRORS PACKAGE BODY prod.dct_wf_designer

PROMPT
PROMPT === verifying DCT_WF_DESIGNER ===
SELECT object_type, status FROM all_objects
WHERE owner = 'PROD' AND object_name = 'DCT_WF_DESIGNER' ORDER BY object_type;

PROMPT === 68_dct_wf_designer_pkg.sql complete ===
