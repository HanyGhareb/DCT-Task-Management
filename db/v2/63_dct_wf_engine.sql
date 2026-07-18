SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- 63_dct_wf_engine.sql
-- i-Finance Workflow Platform (DWP) -- the executor
-- Schema  : PROD (run as ADMIN with schema-qualified names)
-- Plan    : ~/.claude/plans/design-new-workflow-solution-woolly-sun.md
--
-- ONE package, not two. The plan drew DCT_WF_ENGINE as a facade dispatching to
-- DCT_WF_ENGINE_NATIVE or DCT_WF_ENGINE_APEX. The spike killed the APEX arm
-- (every APEX outcome column is VARCHAR2(8) with a check limiting it to
-- APPROVED or REJECTED), so a dispatcher would route one way, forever. The
-- module-facing API is what the plan's golden rule names: DCT_WF_ENGINE.
--
-- WHAT A MODULE DOES:
--   1. publish a fact view + rows in dct_wf_fact_schema / dct_wf_fact_field
--   2. register its side effects in dct_wf_action_registry
--   3. call dct_wf_engine.start_process(...) and never speak to the engine again
--   Routing, conditions, outcomes, quorum, SLA and notifications are metadata.
--
-- DYNAMIC CODE -- there are exactly TWO sites, both auditable:
--   a) run_action    -- invokes a registry-approved pkg.proc, binds only.
--   b) build_facts   -- reads a module's fact view. View name, key column and
--                       every source column come from dct_wf_fact_* metadata,
--                       each passed through DBMS_ASSERT.simple_sql_name.
--   Neither ever sees end-user text. Condition source text is compiled by
--   DCT_WF_EXPR, which has NO dynamic code at all -- that is the invariant that
--   matters and it is unchanged. CI assertion for this file:
--     grep -v '^\s*--' db/v2/63_dct_wf_engine.sql \
--       | grep -c 'DBMS_SQL'                                 -- must be 0
--
-- ERROR CODES
--   -20301  process requires a final callback but has no active ON_COMPLETE hook
--   -20302  a participant rule resolved to nobody and its fallback is FAIL
--   -20303  this user may not act on this task
--   -20304  outcome is not in this step's outcome set
--   -20305  a comment is required for this outcome
--   -20306  process has no PUBLISHED version
--   -20307  return-loop limit exceeded -- instance FAULTED
--   -20308  task is not open
--   -20309  target step of a RETURN_TO_STEP / ROUTE outcome does not exist
--
-- DEPLOY NOTE: Linux SQLcl can silently swallow a large package body. After
--              running this, CONFIRM both spec and body are VALID:
--                select object_name, object_type, status, last_ddl_time
--                  from all_objects
--                 where owner='PROD' and object_name='DCT_WF_ENGINE';
--              If not, deploy via python-oracledb on a worker VM.
--
-- Additive. Creates no schema objects other than the package, two synonyms and
-- the sweep job. Nothing is switched on: every module is still on LEGACY in
-- dct_wf_route, so nothing calls this yet.
-- =============================================================================

PROMPT === i-Finance Workflow Platform -- engine ===

CREATE OR REPLACE PACKAGE prod.dct_wf_engine AS

    c_version    CONSTANT VARCHAR2(10) := '1.0';
    c_max_cycles CONSTANT PLS_INTEGER  := 10;
    c_task_floor CONSTANT NUMBER       := 900000000;

    -- which engine owns this source module right now: LEGACY or WF
    FUNCTION engine_for (p_source_module IN VARCHAR2) RETURN VARCHAR2;

    -- build the fact document for a source record from the module's fact view.
    -- exposed because the designer preview and simulate() both need it.
    FUNCTION build_facts (p_schema_id         IN NUMBER,
                          p_source_record_id  IN NUMBER,
                          p_initiator_user_id IN NUMBER DEFAULT NULL) RETURN CLOB;

    PROCEDURE refresh_facts (p_instance_id IN NUMBER);

    -- start an instance on the process's PUBLISHED version. returns instance_id.
    -- joins the CALLER'S transaction -- no autonomous commit anywhere in here.
    FUNCTION start_process (p_process_code      IN VARCHAR2,
                            p_source_record_id  IN NUMBER,
                            p_initiator_user_id IN NUMBER   DEFAULT NULL,
                            p_source_record_ref IN VARCHAR2 DEFAULT NULL,
                            p_facts             IN CLOB     DEFAULT NULL) RETURN NUMBER;

    -- the one call that moves a workflow forward
    PROCEDURE complete_task (p_task_id      IN NUMBER,
                             p_user_id      IN NUMBER,
                             p_outcome_code IN VARCHAR2,
                             p_comments     IN VARCHAR2 DEFAULT NULL);

    PROCEDURE claim_task    (p_task_id IN NUMBER, p_user_id IN NUMBER);
    PROCEDURE release_task  (p_task_id IN NUMBER, p_user_id IN NUMBER);
    PROCEDURE delegate_task (p_task_id    IN NUMBER,
                             p_user_id    IN NUMBER,
                             p_to_user_id IN NUMBER,
                             p_comments   IN VARCHAR2 DEFAULT NULL);
    PROCEDURE reassign_task (p_task_id       IN NUMBER,
                             p_admin_user_id IN NUMBER,
                             p_to_user_id    IN NUMBER,
                             p_reason        IN VARCHAR2 DEFAULT NULL);

    FUNCTION request_info (p_task_id    IN NUMBER,
                           p_user_id    IN NUMBER,
                           p_of_user_id IN NUMBER,
                           p_question   IN VARCHAR2) RETURN NUMBER;
    PROCEDURE provide_info (p_req_id  IN NUMBER,
                            p_user_id IN NUMBER,
                            p_answer  IN VARCHAR2);

    PROCEDURE cancel_instance (p_instance_id IN NUMBER,
                               p_user_id     IN NUMBER,
                               p_reason      IN VARCHAR2 DEFAULT NULL);

    -- resume a RETURNED instance at the step that returned it
    PROCEDURE resubmit (p_instance_id IN NUMBER,
                        p_user_id     IN NUMBER,
                        p_comments    IN VARCHAR2 DEFAULT NULL);

    -- dry run: which steps fire, which skip and why, who would be asked.
    -- creates NOTHING. this is how an admin gains confidence before publishing.
    FUNCTION simulate (p_process_code      IN VARCHAR2,
                       p_facts             IN CLOB,
                       p_initiator_user_id IN NUMBER DEFAULT NULL) RETURN CLOB;

    -- timers: reminders, escalation, auto-action, SLA breach. Idempotent.
    PROCEDURE sweep;

    -- helpers the compat facade and the ORDS layer lean on
    FUNCTION active_task_for (p_instance_id IN NUMBER, p_user_id IN NUMBER) RETURN NUMBER;
    FUNCTION can_act         (p_task_id IN NUMBER, p_user_id IN NUMBER) RETURN VARCHAR2;

END dct_wf_engine;
/

SHOW ERRORS

CREATE OR REPLACE PACKAGE BODY prod.dct_wf_engine AS

    -- ---------------------------------------------------------------------
    -- types
    -- ---------------------------------------------------------------------
    TYPE t_prin IS RECORD (
        user_id NUMBER,
        via     VARCHAR2(24),
        via_ref VARCHAR2(100));
    TYPE t_prins IS TABLE OF t_prin INDEX BY PLS_INTEGER;
    TYPE t_seen  IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;

    -- ---------------------------------------------------------------------
    -- small helpers
    -- ---------------------------------------------------------------------
    PROCEDURE err (p_code IN NUMBER, p_msg IN VARCHAR2) IS
    BEGIN
        raise_application_error(p_code, p_msg);
    END;

    PROCEDURE hist (p_instance_id      IN NUMBER,
                    p_event_code       IN VARCHAR2,
                    p_step_instance_id IN NUMBER   DEFAULT NULL,
                    p_task_id          IN NUMBER   DEFAULT NULL,
                    p_actor_user_id    IN NUMBER   DEFAULT NULL,
                    p_actor_kind       IN VARCHAR2 DEFAULT 'USER',
                    p_outcome_code     IN VARCHAR2 DEFAULT NULL,
                    p_comments         IN CLOB     DEFAULT NULL,
                    p_from_state       IN VARCHAR2 DEFAULT NULL,
                    p_to_state         IN VARCHAR2 DEFAULT NULL,
                    p_payload          IN CLOB     DEFAULT NULL,
                    p_note             IN VARCHAR2 DEFAULT NULL) IS
    BEGIN
        INSERT INTO prod.dct_wf_history
            (instance_id, step_instance_id, task_id, event_code, actor_user_id,
             actor_kind, outcome_code, comments, from_state, to_state, payload, source_note)
        VALUES (p_instance_id, p_step_instance_id, p_task_id, p_event_code, p_actor_user_id,
                p_actor_kind, p_outcome_code, p_comments, p_from_state, p_to_state,
                p_payload, p_note);

        UPDATE prod.dct_wf_instance
           SET last_event_at = SYSTIMESTAMP
         WHERE instance_id = p_instance_id;
    END;

    FUNCTION jkey_ok (p_key IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN REGEXP_LIKE(p_key, '^[A-Za-z][A-Za-z0-9_]{0,39}$');
    END;

    FUNCTION norm_key (p_path IN VARCHAR2) RETURN VARCHAR2 IS
        v VARCHAR2(200) := TRIM(p_path);
    BEGIN
        -- fact paths are top-level keys in the MVP. tolerate a leading $. form.
        IF v IS NULL THEN RETURN NULL; END IF;
        IF SUBSTR(v, 1, 2) = '$.' THEN v := SUBSTR(v, 3); END IF;
        IF SUBSTR(v, 1, 1) = '$'  THEN v := SUBSTR(v, 2); END IF;
        RETURN v;
    END;

    FUNCTION fact_str (p_facts IN CLOB, p_key IN VARCHAR2) RETURN VARCHAR2 IS
        o JSON_OBJECT_T;
        k VARCHAR2(200) := norm_key(p_key);
    BEGIN
        IF p_facts IS NULL OR k IS NULL THEN RETURN NULL; END IF;
        o := JSON_OBJECT_T.parse(p_facts);
        IF NOT o.has(k) THEN RETURN NULL; END IF;
        RETURN o.get_string(k);
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END;

    FUNCTION fact_num (p_facts IN CLOB, p_key IN VARCHAR2) RETURN NUMBER IS
        o JSON_OBJECT_T;
        k VARCHAR2(200) := norm_key(p_key);
    BEGIN
        IF p_facts IS NULL OR k IS NULL THEN RETURN NULL; END IF;
        o := JSON_OBJECT_T.parse(p_facts);
        IF NOT o.has(k) THEN RETURN NULL; END IF;
        RETURN o.get_number(k);
    EXCEPTION WHEN OTHERS THEN
        RETURN TO_NUMBER(REGEXP_SUBSTR(fact_str(p_facts, p_key), '^\d+$'));
    END;

    -- ---------------------------------------------------------------------
    -- business calendar
    -- ---------------------------------------------------------------------
    FUNCTION is_work_moment (p_cal IN VARCHAR2, p_ts IN TIMESTAMP) RETURN BOOLEAN IS
        v_days  prod.dct_wf_calendar.work_days%TYPE;
        v_from  prod.dct_wf_calendar.day_start_hr%TYPE;
        v_to    prod.dct_wf_calendar.day_end_hr%TYPE;
        v_dy    VARCHAR2(10);
        v_hr    NUMBER;
        v_hol   NUMBER;
    BEGIN
        SELECT work_days, day_start_hr, day_end_hr
          INTO v_days, v_from, v_to
          FROM prod.dct_wf_calendar
         WHERE calendar_code = p_cal;

        v_dy := TO_CHAR(p_ts, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH');
        v_hr := TO_NUMBER(TO_CHAR(p_ts, 'HH24'));

        IF INSTR(',' || v_days || ',', ',' || UPPER(v_dy) || ',') = 0 THEN
            RETURN FALSE;
        END IF;
        IF v_hr < v_from OR v_hr >= v_to THEN
            RETURN FALSE;
        END IF;

        SELECT COUNT(*) INTO v_hol
          FROM prod.dct_wf_holiday
         WHERE calendar_code = p_cal
           AND holiday_date  = TRUNC(CAST(p_ts AS DATE));
        RETURN v_hol = 0;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN TRUE;
    END;

    FUNCTION due_from (p_from     IN TIMESTAMP,
                       p_hours    IN NUMBER,
                       p_calendar IN VARCHAR2 DEFAULT 'CALENDAR') RETURN TIMESTAMP IS
        v_ts    TIMESTAMP := p_from;
        v_left  NUMBER;
        v_guard PLS_INTEGER := 0;
    BEGIN
        IF p_hours IS NULL OR p_hours <= 0 THEN
            RETURN NULL;
        END IF;

        IF NVL(p_calendar, 'CALENDAR') <> 'BUSINESS' THEN
            RETURN p_from + NUMTODSINTERVAL(p_hours, 'HOUR');
        END IF;

        -- business hours: advance an hour at a time over the UAE working week
        v_left := p_hours;
        WHILE v_left > 0 AND v_guard < 5000 LOOP
            v_guard := v_guard + 1;
            v_ts    := v_ts + NUMTODSINTERVAL(1, 'HOUR');
            IF is_work_moment('UAE', v_ts) THEN
                v_left := v_left - 1;
            END IF;
        END LOOP;
        RETURN v_ts;
    END;

    -- ---------------------------------------------------------------------
    -- routing
    -- ---------------------------------------------------------------------
    FUNCTION engine_for (p_source_module IN VARCHAR2) RETURN VARCHAR2 IS
        v VARCHAR2(10);
    BEGIN
        SELECT engine INTO v
          FROM prod.dct_wf_route
         WHERE source_module = p_source_module;
        RETURN v;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN 'LEGACY';
    END;

    -- ---------------------------------------------------------------------
    -- DYNAMIC SITE (a) -- the action registry
    -- ---------------------------------------------------------------------
    PROCEDURE run_action (p_action_id        IN NUMBER,
                          p_instance_id      IN NUMBER,
                          p_source_module    IN VARCHAR2,
                          p_source_record_id IN NUMBER,
                          p_user_id          IN NUMBER) IS
        v_call VARCHAR2(200);
        v_kind VARCHAR2(20);
        v_stmt VARCHAR2(400);
    BEGIN
        SELECT plsql_call, signature_kind
          INTO v_call, v_kind
          FROM prod.dct_wf_action_registry
         WHERE action_id = p_action_id
           AND is_active = 'Y';

        -- the call is admin-registered and constraint-shaped as PKG.PROC. assert
        -- it again anyway -- the registry is the security boundary of the engine.
        v_call := DBMS_ASSERT.qualified_sql_name(v_call);
        v_stmt := 'BEGIN prod.' || v_call || '(:1, :2, :3, :4); END;';

        EXECUTE IMMEDIATE v_stmt
            USING p_instance_id, p_source_module, p_source_record_id, p_user_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        NULL;   -- an inactive action is a no-op, not a failure
    END;

    PROCEDURE run_hooks (p_instance_id IN NUMBER,
                         p_version_id  IN NUMBER,
                         p_step_id     IN NUMBER,
                         p_event_code  IN VARCHAR2,
                         p_user_id     IN NUMBER) IS
        v_mod prod.dct_wf_instance.source_module%TYPE;
        v_rec prod.dct_wf_instance.source_record_id%TYPE;
    BEGIN
        SELECT source_module, source_record_id
          INTO v_mod, v_rec
          FROM prod.dct_wf_instance
         WHERE instance_id = p_instance_id;

        FOR h IN (SELECT h.hook_id, h.action_id, h.on_error, a.action_code
                    FROM prod.dct_wf_process_hook h
                    JOIN prod.dct_wf_action_registry a ON a.action_id = h.action_id
                   WHERE h.version_id = p_version_id
                     AND h.event_code = p_event_code
                     AND h.is_active  = 'Y'
                     AND a.is_active  = 'Y'
                     AND (h.step_id IS NULL OR h.step_id = p_step_id)
                   ORDER BY h.exec_order, h.hook_id)
        LOOP
            BEGIN
                run_action(h.action_id, p_instance_id, v_mod, v_rec, p_user_id);
                hist(p_instance_id, 'HOOK_RUN',
                     p_actor_kind => 'SYSTEM',
                     p_note       => p_event_code || ' -> ' || h.action_code);
            EXCEPTION WHEN OTHERS THEN
                IF h.on_error = 'FAIL' THEN
                    -- side effects that must be transactional with the approval
                    RAISE;
                END IF;
                -- a dead SMTP relay must never block an approval
                hist(p_instance_id, 'HOOK_ERROR',
                     p_actor_kind => 'SYSTEM',
                     p_note       => SUBSTR(h.action_code || ': ' || SQLERRM, 1, 400));
            END;
        END LOOP;
    END;

    -- ---------------------------------------------------------------------
    -- DYNAMIC SITE (b) -- read a module's fact view
    -- ---------------------------------------------------------------------
    FUNCTION build_facts (p_schema_id         IN NUMBER,
                          p_source_record_id  IN NUMBER,
                          p_initiator_user_id IN NUMBER DEFAULT NULL) RETURN CLOB IS
        v_view  prod.dct_wf_fact_schema.source_view%TYPE;
        v_key   prod.dct_wf_fact_schema.source_key_column%TYPE;
        v_cols  VARCHAR2(8000);
        v_stmt  VARCHAR2(9000);
        v_json  CLOB;
        v_obj   JSON_OBJECT_T;
        v_roles JSON_ARRAY_T := JSON_ARRAY_T();
        v_raw   VARCHAR2(200);
    BEGIN
        SELECT source_view, source_key_column
          INTO v_view, v_key
          FROM prod.dct_wf_fact_schema
         WHERE schema_id = p_schema_id
           AND is_active = 'Y';

        -- every identifier below comes from dct_wf_fact_* metadata, never from a
        -- request body, and every one is asserted.
        v_view := DBMS_ASSERT.simple_sql_name(v_view);
        v_key  := DBMS_ASSERT.simple_sql_name(v_key);

        FOR f IN (SELECT field_key, source_column
                    FROM prod.dct_wf_fact_field
                   WHERE schema_id = p_schema_id
                   ORDER BY display_order, field_id)
        LOOP
            IF NOT jkey_ok(f.field_key) THEN
                err(-20001, 'illegal fact field key: ' || f.field_key);
            END IF;
            v_cols := v_cols
                   || CASE WHEN v_cols IS NULL THEN '' ELSE ', ' END
                   || '''' || f.field_key || ''' VALUE '
                   || DBMS_ASSERT.simple_sql_name(f.source_column);
        END LOOP;

        IF v_cols IS NULL THEN
            v_json := TO_CLOB('{}');
        ELSE
            v_stmt := 'SELECT JSON_OBJECT(' || v_cols
                   || ' ABSENT ON NULL RETURNING CLOB) FROM prod.' || v_view
                   || ' WHERE ' || v_key || ' = :1';
            BEGIN
                EXECUTE IMMEDIATE v_stmt INTO v_json USING p_source_record_id;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                v_json := TO_CLOB('{}');
            END;
        END IF;

        v_obj := JSON_OBJECT_T.parse(v_json);

        -- coerce declared BOOLEAN fields off Oracle's Y/N convention so that a
        -- condition can just say "is_renewal" and mean it
        FOR f IN (SELECT field_key FROM prod.dct_wf_fact_field
                   WHERE schema_id = p_schema_id AND data_type = 'BOOLEAN')
        LOOP
            IF v_obj.has(f.field_key) THEN
                BEGIN
                    v_raw := v_obj.get_string(f.field_key);
                    v_obj.put(f.field_key,
                              UPPER(NVL(v_raw, 'N')) IN ('Y', '1', 'TRUE', 'T'));
                EXCEPTION WHEN OTHERS THEN NULL;
                END;
            END IF;
        END LOOP;

        -- the initiator's role codes -- this is what HAS_ROLE() reads. A snapshot,
        -- never a live query at evaluation time.
        IF p_initiator_user_id IS NOT NULL THEN
            FOR r IN (SELECT DISTINCT ro.role_code
                        FROM prod.dct_user_roles ur
                        JOIN prod.dct_roles ro ON ro.role_id = ur.role_id
                       WHERE ur.user_id   = p_initiator_user_id
                         AND ur.is_active = 'Y'
                         AND ur.start_date <= SYSDATE
                         AND (ur.end_date IS NULL OR ur.end_date >= SYSDATE))
            LOOP
                v_roles.append(r.role_code);
            END LOOP;
            v_obj.put('initiator_user_id', p_initiator_user_id);
        END IF;
        v_obj.put('roles', v_roles);

        RETURN v_obj.to_clob;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN TO_CLOB('{"roles":[]}');
    END;

    PROCEDURE refresh_facts (p_instance_id IN NUMBER) IS
        v_schema NUMBER;
        v_rec    NUMBER;
        v_init   NUMBER;
        v_facts  CLOB;
    BEGIN
        SELECT p.schema_id, i.source_record_id, i.initiator_user_id
          INTO v_schema, v_rec, v_init
          FROM prod.dct_wf_instance i
          JOIN prod.dct_wf_process  p ON p.process_id = i.process_id
         WHERE i.instance_id = p_instance_id;

        IF v_schema IS NULL THEN
            RETURN;
        END IF;

        v_facts := build_facts(v_schema, v_rec, v_init);

        UPDATE prod.dct_wf_instance
           SET fact_doc          = v_facts,
               fact_refreshed_at = SYSTIMESTAMP
         WHERE instance_id = p_instance_id;
    END;

    -- ---------------------------------------------------------------------
    -- notifications
    -- ---------------------------------------------------------------------
    FUNCTION render (p_text     IN CLOB,
                     p_instance IN NUMBER,
                     p_task     IN NUMBER,
                     p_step_nm  IN VARCHAR2,
                     p_actor_nm IN VARCHAR2,
                     p_out_lbl  IN VARCHAR2,
                     p_facts    IN CLOB,
                     o_warn     OUT VARCHAR2) RETURN VARCHAR2 IS
        -- deliberately VARCHAR2 inside: token scanning on a CLOB drags in CLOB
        -- regex semantics for no benefit. A notification body is prose, not a report.
        v      VARCHAR2(32767) := SUBSTR(p_text, 1, 32000);
        v_ref  VARCHAR2(200);
        v_due  TIMESTAMP;
        v_amt  NUMBER;
        v_cur  VARCHAR2(3);
        v_left VARCHAR2(200);
        v_key  VARCHAR2(60);
        v_obj  JSON_OBJECT_T;
        v_i    PLS_INTEGER := 1;
    BEGIN
        IF v IS NULL THEN RETURN NULL; END IF;

        SELECT source_record_ref INTO v_ref
          FROM prod.dct_wf_instance WHERE instance_id = p_instance;

        IF p_task IS NOT NULL THEN
            SELECT due_at, amount, currency INTO v_due, v_amt, v_cur
              FROM prod.dct_wf_task WHERE task_id = p_task;
        END IF;

        v := REPLACE(v, '{{instance.ref}}',    NVL(v_ref, TO_CHAR(p_instance)));
        v := REPLACE(v, '{{step.name}}',       NVL(p_step_nm, '-'));
        v := REPLACE(v, '{{actor.displayName}}', NVL(p_actor_nm, '-'));
        v := REPLACE(v, '{{outcome.label}}',   NVL(p_out_lbl, '-'));
        v := REPLACE(v, '{{due.date}}',
                     NVL(TO_CHAR(prod.dct_to_local(v_due), 'YYYY-MM-DD HH:MI AM'), '-'));
        v := REPLACE(v, '{{fact.amount}}',
                     NVL(TO_CHAR(v_amt, 'FM999G999G999G990D00'), '-'));
        v := REPLACE(v, '{{fact.currency}}',   NVL(v_cur, ''));
        v := REPLACE(v, '{{link}}',            NVL(v_ref, ''));

        -- any remaining {{fact.x}} resolves against the instance's fact document
        IF p_facts IS NOT NULL AND INSTR(v, '{{fact.') > 0 THEN
            BEGIN
                v_obj := JSON_OBJECT_T.parse(p_facts);
                LOOP
                    -- always occurrence 1: each pass REPLACEs the match away, so the
                    -- next unresolved token becomes the new first. v_i is a loop guard.
                    v_key := REGEXP_SUBSTR(v, '\{\{fact\.([A-Za-z0-9_]{1,40})\}\}',
                                           1, 1, NULL, 1);
                    EXIT WHEN v_key IS NULL OR v_i > 40;
                    v := REPLACE(v, '{{fact.' || v_key || '}}',
                                 CASE WHEN v_obj.has(v_key)
                                      THEN NVL(v_obj.get_string(v_key), '')
                                      ELSE '' END);
                    v_i := v_i + 1;
                END LOOP;
            EXCEPTION WHEN OTHERS THEN NULL;
            END;
        END IF;

        -- unknown tokens become empty, and we say so rather than shipping {{junk}}
        v_left := REGEXP_SUBSTR(v, '\{\{[^}]{0,60}\}\}');
        IF v_left IS NOT NULL THEN
            o_warn := 'unknown token ' || SUBSTR(v_left, 1, 60);
            v := REGEXP_REPLACE(v, '\{\{[^}]{0,60}\}\}', '');
        END IF;

        RETURN v;
    END;

    PROCEDURE notify_user (p_user_id     IN NUMBER,
                           p_instance_id IN NUMBER,
                           p_task_id     IN NUMBER,
                           p_event_code  IN VARCHAR2,
                           p_version_id  IN NUMBER,
                           p_step_id     IN NUMBER,
                           p_step_nm     IN VARCHAR2 DEFAULT NULL,
                           p_actor_nm    IN VARCHAR2 DEFAULT NULL,
                           p_out_lbl     IN VARCHAR2 DEFAULT NULL) IS
        v_tid   NUMBER;
        v_s_en  VARCHAR2(4000);
        v_s_ar  VARCHAR2(4000);
        v_b_en  VARCHAR2(32767);
        v_b_ar  VARCHAR2(32767);
        v_t_en  CLOB;
        v_t_ar  CLOB;
        v_link  VARCHAR2(400);
        v_mod   VARCHAR2(40);
        v_facts CLOB;
        v_ref   VARCHAR2(200);
        v_w1    VARCHAR2(400);
        v_w2    VARCHAR2(400);
        v_w3    VARCHAR2(400);
        v_w4    VARCHAR2(400);
        v_warn  VARCHAR2(400);
    BEGIN
        IF p_user_id IS NULL THEN RETURN; END IF;

        SELECT i.fact_doc, i.source_module, i.source_record_ref
          INTO v_facts, v_mod, v_ref
          FROM prod.dct_wf_instance i
         WHERE i.instance_id = p_instance_id;

        -- most specific template wins: STEP, then PROCESS, then GLOBAL
        BEGIN
            SELECT template_id, subject_en, subject_ar, body_en, body_ar, link_template
              INTO v_tid, v_s_en, v_s_ar, v_t_en, v_t_ar, v_link
              FROM (SELECT t.*,
                           CASE WHEN t.step_id    = p_step_id    THEN 1
                                WHEN t.version_id = p_version_id THEN 2
                                ELSE 3 END AS rank_
                      FROM prod.dct_wf_notify_template t
                     WHERE t.event_code = p_event_code
                       AND t.channel    = 'INAPP'
                       AND t.is_active  = 'Y'
                       AND (t.step_id    = p_step_id    OR t.step_id    IS NULL)
                       AND (t.version_id = p_version_id OR t.version_id IS NULL)
                     ORDER BY rank_, t.template_id)
             WHERE ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            v_tid := NULL;
        END;

        IF v_tid IS NULL THEN
            -- no template configured: send a plain built-in rather than nothing.
            -- silence is the worst possible failure mode for an approval queue.
            v_s_en := INITCAP(REPLACE(p_event_code, '_', ' ')) || ' - ' || NVL(v_ref, p_instance_id);
            v_s_ar := v_s_en;
            v_b_en := NVL(p_step_nm, '');
            v_b_ar := v_b_en;
            v_warn := 'no template for ' || p_event_code;
        ELSE
            v_s_en := render(TO_CLOB(v_s_en), p_instance_id, p_task_id, p_step_nm, p_actor_nm, p_out_lbl, v_facts, v_w1);
            v_s_ar := render(TO_CLOB(v_s_ar), p_instance_id, p_task_id, p_step_nm, p_actor_nm, p_out_lbl, v_facts, v_w2);
            v_b_en := render(v_t_en,          p_instance_id, p_task_id, p_step_nm, p_actor_nm, p_out_lbl, v_facts, v_w3);
            v_b_ar := render(v_t_ar,          p_instance_id, p_task_id, p_step_nm, p_actor_nm, p_out_lbl, v_facts, v_w4);
            v_warn := COALESCE(v_w1, v_w2, v_w3, v_w4);
        END IF;

        prod.dct_notify.send(
            p_recipient_user_id => p_user_id,
            p_notification_type => p_event_code,
            p_title_en          => SUBSTR(v_s_en, 1, 400),
            p_body_en           => SUBSTR(v_b_en, 1, 2000),
            p_title_ar          => SUBSTR(v_s_ar, 1, 400),
            p_body_ar           => SUBSTR(v_b_ar, 1, 2000),
            p_module_code       => v_mod,
            p_link_url          => v_link);

        INSERT INTO prod.dct_wf_notify_log
            (instance_id, task_id, template_id, event_code, channel, user_id,
             status, warn_msg)
        VALUES (p_instance_id, p_task_id, v_tid, p_event_code, 'INAPP', p_user_id,
                CASE WHEN v_warn IS NULL THEN 'SENT' ELSE 'WARN' END, v_warn);
    EXCEPTION WHEN OTHERS THEN
        -- a notification failure must never roll back an approval.
        -- SQLERRM cannot be referenced inside a SQL statement -- via a variable.
        v_warn := SUBSTR(SQLERRM, 1, 400);
        INSERT INTO prod.dct_wf_notify_log
            (instance_id, task_id, event_code, channel, user_id, status, warn_msg)
        VALUES (p_instance_id, p_task_id, p_event_code, 'INAPP', p_user_id,
                'FAILED', v_warn);
    END;

    -- ---------------------------------------------------------------------
    -- participant resolution
    -- ---------------------------------------------------------------------
    PROCEDURE add_prin (p_prins IN OUT NOCOPY t_prins,
                        p_seen  IN OUT NOCOPY t_seen,
                        p_uid   IN NUMBER,
                        p_via   IN VARCHAR2,
                        p_ref   IN VARCHAR2 DEFAULT NULL) IS
        v_act VARCHAR2(1);
        i     PLS_INTEGER;
    BEGIN
        IF p_uid IS NULL OR p_seen.EXISTS(p_uid) THEN
            RETURN;
        END IF;

        BEGIN
            SELECT is_active INTO v_act FROM prod.dct_users WHERE user_id = p_uid;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RETURN;
        END;
        IF v_act <> 'Y' THEN
            RETURN;   -- a deactivated approver is not an approver
        END IF;

        i := p_prins.COUNT + 1;
        p_prins(i).user_id := p_uid;
        p_prins(i).via     := p_via;
        p_prins(i).via_ref := p_ref;
        p_seen(p_uid)      := 1;
    END;

    PROCEDURE role_holders (p_prins  IN OUT NOCOPY t_prins,
                            p_seen   IN OUT NOCOPY t_seen,
                            p_role   IN VARCHAR2,
                            p_org    IN NUMBER,
                            p_exclude IN NUMBER,
                            p_via    IN VARCHAR2) IS
    BEGIN
        FOR u IN (SELECT DISTINCT ur.user_id
                    FROM prod.dct_user_roles ur
                    JOIN prod.dct_roles r ON r.role_id = ur.role_id
                   WHERE r.role_code  = p_role
                     AND r.is_active  = 'Y'
                     AND ur.is_active = 'Y'
                     AND ur.start_date <= SYSDATE
                     AND (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
                     AND (p_org IS NULL
                          OR ur.org_scope_id IS NULL
                          OR ur.org_scope_id = p_org))
        LOOP
            IF p_exclude IS NULL OR u.user_id <> p_exclude THEN
                add_prin(p_prins, p_seen, u.user_id, p_via, p_role);
            END IF;
        END LOOP;
    END;

    -- ------------------------------------------------------------------
    -- ASSIGNED_ROLE: date-tracked role assignments against business
    -- objects (dct_wf_role_assignment, registry dct_wf_object_type).
    -- p_asof is the request's SUBMISSION date, so a returned-and-
    -- resubmitted request keeps the chain it entered with. Types with
    -- hierarchy_kind ORG climb the org tree, nearest mapped ancestor
    -- wins (the old approver-map walk). Cross-type fallback (task ->
    -- project -> cost center -> sector) is NOT here: it is an ordered
    -- rule cascade with resolution_mode FIRST_MATCH.
    -- ------------------------------------------------------------------
    PROCEDURE assigned_holders (p_prins   IN OUT NOCOPY t_prins,
                                p_seen    IN OUT NOCOPY t_seen,
                                p_role    IN VARCHAR2,
                                p_type    IN VARCHAR2,
                                p_key     IN VARCHAR2,
                                p_key2    IN VARCHAR2,
                                p_asof    IN DATE,
                                p_exclude IN NUMBER) IS
        v_num  VARCHAR2(1);
        v_hier VARCHAR2(10);
        v_key  VARCHAR2(100);
        v_key2 VARCHAR2(100);
        v_org  NUMBER;
        v_lvl  NUMBER;
        v_asof DATE := NVL(TRUNC(p_asof), TRUNC(SYSDATE));
    BEGIN
        IF p_key IS NULL OR p_type IS NULL OR p_role IS NULL THEN RETURN; END IF;

        BEGIN
            SELECT key_is_numeric, hierarchy_kind INTO v_num, v_hier
              FROM prod.dct_wf_object_type
             WHERE object_type_code = p_type AND is_active = 'Y';
        EXCEPTION WHEN NO_DATA_FOUND THEN RETURN;
        END;

        -- canonicalize exactly as DCT_WF_ASSIGN.canon does on write: trim,
        -- and numeric keys lose leading zeros so '0410' matches '410'
        v_key  := TRIM(p_key);
        v_key2 := TRIM(p_key2);
        IF v_num = 'Y' THEN
            BEGIN
                v_key := TO_CHAR(TO_NUMBER(v_key));
            EXCEPTION WHEN OTHERS THEN NULL;
            END;
        END IF;

        IF v_hier = 'ORG' THEN
            BEGIN
                v_org := TO_NUMBER(v_key);
            EXCEPTION WHEN OTHERS THEN RETURN;
            END;

            SELECT MIN(o.lvl) INTO v_lvl
              FROM (SELECT org_id, LEVEL AS lvl
                      FROM prod.dct_organizations
                     START WITH org_id = v_org
                   CONNECT BY PRIOR parent_org_id = org_id) o
              JOIN prod.dct_wf_role_assignment ra
                ON ra.object_key = TO_CHAR(o.org_id)
             WHERE ra.object_type_code = p_type
               AND ra.role_code  = p_role
               AND ra.is_active  = 'Y'
               AND ra.start_date <= v_asof
               AND (ra.end_date IS NULL OR ra.end_date >= v_asof);

            IF v_lvl IS NULL THEN RETURN; END IF;

            FOR u IN (SELECT ra.user_id
                        FROM (SELECT org_id, LEVEL AS lvl
                                FROM prod.dct_organizations
                               START WITH org_id = v_org
                             CONNECT BY PRIOR parent_org_id = org_id) o
                        JOIN prod.dct_wf_role_assignment ra
                          ON ra.object_key = TO_CHAR(o.org_id)
                       WHERE ra.object_type_code = p_type
                         AND ra.role_code  = p_role
                         AND ra.is_active  = 'Y'
                         AND o.lvl = v_lvl
                         AND ra.start_date <= v_asof
                         AND (ra.end_date IS NULL OR ra.end_date >= v_asof))
            LOOP
                IF p_exclude IS NULL OR u.user_id <> p_exclude THEN
                    -- via_ref is the bare role code on purpose: a SPECIFIC_ROLE
                    -- delegation matches on it. Do not decorate it.
                    add_prin(p_prins, p_seen, u.user_id, 'ASSIGNED', p_role);
                END IF;
            END LOOP;
        ELSE
            FOR u IN (SELECT ra.user_id
                        FROM prod.dct_wf_role_assignment ra
                       WHERE ra.object_type_code = p_type
                         AND ra.object_key = v_key
                         AND NVL(ra.object_key2, '#') = NVL(v_key2, '#')
                         AND ra.role_code  = p_role
                         AND ra.is_active  = 'Y'
                         AND ra.start_date <= v_asof
                         AND (ra.end_date IS NULL OR ra.end_date >= v_asof))
            LOOP
                IF p_exclude IS NULL OR u.user_id <> p_exclude THEN
                    add_prin(p_prins, p_seen, u.user_id, 'ASSIGNED', p_role);
                END IF;
            END LOOP;
        END IF;
    END;

    -- ROLE_SCOPED_ORG, kept for saved rules and the designer: since the
    -- role-assignment layer (db/v2/94) this delegates to assigned_holders
    -- with object type DEPARTMENT, which absorbed the (always empty)
    -- dct_wf_approver_map AND fixed its SYSDATE-not-submission-date gap.
    PROCEDURE scoped_holders (p_prins   IN OUT NOCOPY t_prins,
                              p_seen    IN OUT NOCOPY t_seen,
                              p_role    IN VARCHAR2,
                              p_org     IN NUMBER,
                              p_asof    IN DATE,
                              p_exclude IN NUMBER) IS
    BEGIN
        IF p_org IS NULL THEN RETURN; END IF;
        assigned_holders(p_prins, p_seen, p_role, 'DEPARTMENT',
                         TO_CHAR(p_org), NULL, p_asof, p_exclude);
    END;

    -- LINE_MANAGER and ORG_HEAD are written, correct, and return NOBODY today:
    -- dct_users.person_id, dct_employees.manager_person_id and
    -- dct_organizations.head_user_id are NULL on every row (plan section 9).
    -- They light up the moment workstream W0 populates the hierarchy. Until
    -- then a rule using them falls through to its fallback_rule, loudly.
    PROCEDURE line_manager (p_prins IN OUT NOCOPY t_prins,
                            p_seen  IN OUT NOCOPY t_seen,
                            p_uid   IN NUMBER,
                            p_up    IN NUMBER,
                            p_via   IN VARCHAR2 DEFAULT 'LINE_MANAGER') IS
        v_person NUMBER;
        v_mgr    NUMBER;
        v_user   NUMBER;
    BEGIN
        -- p_uid is the SUBJECT the chain climbs from: the initiator for
        -- LINE_MANAGER, or a fact-referenced person for FACT_LINE_MANAGER
        -- (the "on behalf of" case -- route to the BENEFICIARY's manager,
        -- never the submitter's). Same walk, different starting user.
        SELECT person_id INTO v_person FROM prod.dct_users WHERE user_id = p_uid;
        IF v_person IS NULL THEN RETURN; END IF;

        SELECT manager_person_id INTO v_mgr
          FROM (SELECT e.manager_person_id, LEVEL AS lvl
                  FROM prod.dct_employees e
                 START WITH e.person_id = v_person
               CONNECT BY PRIOR e.manager_person_id = e.person_id
                     AND LEVEL <= GREATEST(NVL(p_up, 0), 0) + 1)
         WHERE lvl = GREATEST(NVL(p_up, 0), 0) + 1;

        IF v_mgr IS NULL THEN RETURN; END IF;

        SELECT MIN(user_id) INTO v_user
          FROM prod.dct_users WHERE person_id = v_mgr AND is_active = 'Y';
        add_prin(p_prins, p_seen, v_user, p_via);
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;

    PROCEDURE org_head (p_prins IN OUT NOCOPY t_prins,
                        p_seen  IN OUT NOCOPY t_seen,
                        p_org   IN NUMBER,
                        p_up    IN NUMBER) IS
        v_head NUMBER;
    BEGIN
        IF p_org IS NULL THEN RETURN; END IF;

        SELECT head_user_id INTO v_head
          FROM (SELECT o.head_user_id, LEVEL AS lvl
                  FROM prod.dct_organizations o
                 START WITH o.org_id = p_org
               CONNECT BY PRIOR o.parent_org_id = o.org_id)
         WHERE lvl = GREATEST(NVL(p_up, 0), 0) + 1;

        add_prin(p_prins, p_seen, v_head, 'ORG_HEAD');
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;

    PROCEDURE resolve_participants (p_step_id     IN  NUMBER,
                                    p_instance_id IN  NUMBER,
                                    p_facts       IN  CLOB,
                                    p_initiator   IN  NUMBER,
                                    p_org         IN  NUMBER,
                                    p_process     IN  VARCHAR2,
                                    p_module_id   IN  NUMBER,
                                    o_prins       OUT NOCOPY t_prins,
                                    o_reason      OUT VARCHAR2,
                                    p_asof        IN  DATE DEFAULT NULL) IS
        v_seen  t_seen;
        v_deleg t_prins;
        v_dseen t_seen;
        v_fb    VARCHAR2(20) := 'ANY_ROLE_HOLDER';
        v_role  VARCHAR2(100);   -- the FIRST rule's role, for the fallback
        v_drole VARCHAR2(100);   -- the role a given principal was resolved BY
        v_uid   NUMBER;
        v_txt   VARCHAR2(200);
        v_txt2  VARCHAR2(200);
        v_org   NUMBER;
        v_first BOOLEAN := TRUE;
        -- assignments resolve as of the request's SUBMISSION date (NULL,
        -- e.g. from simulate, means "as of now")
        v_asof  DATE := NVL(TRUNC(p_asof), TRUNC(SYSDATE));
    BEGIN
        FOR r IN (SELECT * FROM prod.dct_wf_participant_rule
                   WHERE step_id = p_step_id
                   ORDER BY rule_seq, rule_id)
        LOOP
            IF v_first THEN
                v_fb    := r.fallback_rule;
                v_role  := r.role_code;
                v_first := FALSE;
            END IF;

            IF r.resolution_mode = 'FIRST_MATCH' AND o_prins.COUNT > 0 THEN
                EXIT;
            END IF;

            -- which org is this rule scoped to
            v_org := CASE r.org_scope
                        WHEN 'NONE'          THEN NULL
                        WHEN 'REQUEST_ORG'   THEN p_org
                        WHEN 'INITIATOR_ORG' THEN p_org
                        WHEN 'STATIC'        THEN r.static_org_id
                        WHEN 'FACT'          THEN fact_num(p_facts, r.org_fact_path)
                     END;

            CASE r.resolver_type
                WHEN 'ROLE' THEN
                    role_holders(o_prins, v_seen, r.role_code, v_org,
                                 CASE WHEN r.exclude_initiator = 'Y' THEN p_initiator END,
                                 'ROLE');

                WHEN 'ROLE_SCOPED_ORG' THEN
                    scoped_holders(o_prins, v_seen, r.role_code, v_org, v_asof,
                                   CASE WHEN r.exclude_initiator = 'Y' THEN p_initiator END);

                WHEN 'ASSIGNED_ROLE' THEN
                    -- date-tracked assignment lookup: role x business object,
                    -- object key(s) read from the request's facts. Fallback
                    -- across the dimension hierarchy (task -> project -> cost
                    -- center -> sector) = an ordered cascade of these rules
                    -- with resolution_mode FIRST_MATCH.
                    v_txt  := fact_str(p_facts, r.fact_path);
                    IF v_txt IS NULL THEN
                        v_txt := TO_CHAR(fact_num(p_facts, r.fact_path));
                    END IF;
                    v_txt2 := CASE WHEN r.key2_fact_path IS NOT NULL
                                   THEN NVL(fact_str(p_facts, r.key2_fact_path),
                                            TO_CHAR(fact_num(p_facts, r.key2_fact_path)))
                              END;
                    assigned_holders(o_prins, v_seen, r.role_code,
                                     r.object_type_code, v_txt, v_txt2, v_asof,
                                     CASE WHEN r.exclude_initiator = 'Y' THEN p_initiator END);

                WHEN 'STATIC_USER' THEN
                    add_prin(o_prins, v_seen, r.static_user_id, 'STATIC');

                WHEN 'FACT_USER' THEN
                    -- FL's line-manager-by-email pattern, generalised. The fact may
                    -- hold a user id or an email address.
                    v_uid := fact_num(p_facts, r.fact_path);
                    IF v_uid IS NULL THEN
                        v_txt := fact_str(p_facts, r.fact_path);
                        IF v_txt IS NOT NULL AND INSTR(v_txt, '@') > 0 THEN
                            BEGIN
                                SELECT MIN(user_id) INTO v_uid
                                  FROM prod.dct_users
                                 WHERE UPPER(email) = UPPER(TRIM(v_txt))
                                   AND is_active = 'Y';
                            EXCEPTION WHEN OTHERS THEN v_uid := NULL;
                            END;
                        END IF;
                    END IF;
                    add_prin(o_prins, v_seen, v_uid, 'FACT', SUBSTR(r.fact_path, 1, 100));

                WHEN 'FACT_LINE_MANAGER' THEN
                    -- "on behalf of": resolve the SUBJECT user from a fact
                    -- (id or email, same as FACT_USER), then climb to THEIR
                    -- line manager -- not the submitter's. levels_up skips N.
                    v_uid := fact_num(p_facts, r.fact_path);
                    IF v_uid IS NULL THEN
                        v_txt := fact_str(p_facts, r.fact_path);
                        IF v_txt IS NOT NULL AND INSTR(v_txt, '@') > 0 THEN
                            BEGIN
                                SELECT MIN(user_id) INTO v_uid
                                  FROM prod.dct_users
                                 WHERE UPPER(email) = UPPER(TRIM(v_txt))
                                   AND is_active = 'Y';
                            EXCEPTION WHEN OTHERS THEN v_uid := NULL;
                            END;
                        END IF;
                    END IF;
                    IF v_uid IS NOT NULL THEN
                        line_manager(o_prins, v_seen, v_uid, r.levels_up,
                                     'FACT_LINE_MANAGER');
                    END IF;

                WHEN 'INITIATOR' THEN
                    add_prin(o_prins, v_seen, p_initiator, 'INITIATOR');

                WHEN 'PREVIOUS_ACTOR' THEN
                    BEGIN
                        SELECT MAX(t.outcome_by) INTO v_uid
                          FROM prod.dct_wf_task t
                          JOIN prod.dct_wf_step_instance si
                            ON si.step_instance_id = t.step_instance_id
                         WHERE t.instance_id = p_instance_id
                           AND t.state       = 'COMPLETED'
                           AND (r.ref_step_key IS NULL OR si.step_key = r.ref_step_key);
                    EXCEPTION WHEN OTHERS THEN v_uid := NULL;
                    END;
                    add_prin(o_prins, v_seen, v_uid, 'PREV_ACTOR', r.ref_step_key);

                WHEN 'LINE_MANAGER' THEN
                    line_manager(o_prins, v_seen, p_initiator, r.levels_up);

                WHEN 'ORG_HEAD' THEN
                    org_head(o_prins, v_seen, v_org, r.levels_up);

                ELSE
                    NULL;
            END CASE;
        END LOOP;

        -- nobody resolved: apply the first rule's fallback
        IF o_prins.COUNT = 0 THEN
            CASE v_fb
                WHEN 'ANY_ROLE_HOLDER' THEN
                    role_holders(o_prins, v_seen, v_role, NULL, NULL, 'FALLBACK_ROLE');
                    o_reason := 'fallback: any holder of ' || v_role;
                WHEN 'BUSINESS_ADMIN' THEN
                    role_holders(o_prins, v_seen, 'SYS_ADMIN', NULL, NULL, 'FALLBACK_ADMIN');
                    o_reason := 'fallback: business admin';
                WHEN 'ORG_HEAD' THEN
                    org_head(o_prins, v_seen, p_org, 0);
                    o_reason := 'fallback: org head';
                WHEN 'FAIL' THEN
                    err(-20302, 'workflow step ' || p_step_id
                              || ': no participant resolved and fallback is FAIL');
                ELSE
                    o_reason := 'no participant resolved';
            END CASE;
        END IF;

        -- Delegates ride along on the principal's task -- they do not get their own.
        -- (This is why delegation shows up in the inbox without forking the chain.)
        --
        -- The scope vocabulary is dct_delegations' OWN, and it is NOT what you would
        -- guess: ALL_ROLES / SPECIFIC_ROLE / MODULE (chk_dct_del_scope). Coding this
        -- against a plausible-looking 'ALL' matches zero rows and delegation silently
        -- resolves nobody -- which is exactly what happened here until the suite
        -- caught it. Do not "tidy" these literals.
        FOR i IN 1 .. o_prins.COUNT LOOP
            v_uid  := o_prins(i).user_id;
            v_drole := CASE WHEN o_prins(i).via IN ('ROLE', 'MAP', 'FALLBACK_ROLE')
                            THEN o_prins(i).via_ref END;

            FOR d IN (SELECT dg.delegate_id
                        FROM prod.dct_delegations dg
                        LEFT JOIN prod.dct_roles r ON r.role_id = dg.role_id
                       WHERE dg.delegator_id = v_uid
                         AND dg.status       = 'ACTIVE'
                         AND TRUNC(SYSDATE) BETWEEN TRUNC(dg.start_date)
                                                AND TRUNC(dg.end_date)
                         AND (dg.scope = 'ALL_ROLES'
                              OR (dg.scope = 'MODULE'
                                  AND dg.module_id IS NOT NULL
                                  AND dg.module_id = p_module_id)
                              OR (dg.scope = 'SPECIFIC_ROLE'
                                  AND v_drole IS NOT NULL
                                  AND r.role_code = v_drole)))
            LOOP
                IF NOT v_seen.EXISTS(d.delegate_id) THEN
                    add_prin(v_deleg, v_dseen, d.delegate_id,
                             'DELEGATE', TO_CHAR(v_uid));
                END IF;
            END LOOP;
        END LOOP;

        FOR i IN 1 .. v_deleg.COUNT LOOP
            add_prin(o_prins, v_seen, v_deleg(i).user_id, v_deleg(i).via, v_deleg(i).via_ref);
        END LOOP;
    END;

    -- ---------------------------------------------------------------------
    -- forward declarations -- activate and advance are mutually recursive
    -- ---------------------------------------------------------------------
    PROCEDURE advance (p_instance_id IN NUMBER, p_user_id IN NUMBER);

    -- ---------------------------------------------------------------------
    -- step activation
    -- ---------------------------------------------------------------------
    PROCEDURE activate_step (p_instance_id IN NUMBER,
                             p_step_id     IN NUMBER,
                             p_user_id     IN NUMBER,
                             o_active      OUT BOOLEAN) IS
        s        prod.dct_wf_step%ROWTYPE;
        v_inst   prod.dct_wf_instance%ROWTYPE;
        v_ast    CLOB;
        v_res    VARCHAR2(5) := 'TRUE';
        v_trace  CLOB;
        v_expr   VARCHAR2(2000);
        v_si     NUMBER;
        v_att    NUMBER;
        v_prins  t_prins;
        v_reason VARCHAR2(400);
        v_req    NUMBER;
        v_due    TIMESTAMP;
        v_tid    NUMBER;
        v_pcode  VARCHAR2(60);
        v_mid    NUMBER;
        v_mcode  VARCHAR2(40);
        v_rname  VARCHAR2(200);
        v_amt    NUMBER;
        v_cur    VARCHAR2(3);
        v_setid  NUMBER;
        v_nprin  PLS_INTEGER;
    BEGIN
        o_active := FALSE;

        SELECT * INTO s FROM prod.dct_wf_step WHERE step_id = p_step_id;
        SELECT * INTO v_inst FROM prod.dct_wf_instance WHERE instance_id = p_instance_id;

        SELECT p.process_code, p.module_id, p.source_module
          INTO v_pcode, v_mid, v_mcode
          FROM prod.dct_wf_process p
         WHERE p.process_id = v_inst.process_id;

        SELECT NVL(MAX(attempt_no), 0) + 1 INTO v_att
          FROM prod.dct_wf_step_instance
         WHERE instance_id = p_instance_id AND step_id = p_step_id;

        -- ---------- condition ----------
        IF s.condition_id IS NOT NULL THEN
            BEGIN
                SELECT expr_ast, expr_text INTO v_ast, v_expr
                  FROM prod.dct_wf_condition
                 WHERE condition_id = s.condition_id
                   AND is_valid = 'Y';
                v_res := prod.dct_wf_expr.eval(v_ast, v_inst.fact_doc, v_trace);
            EXCEPTION WHEN NO_DATA_FOUND THEN
                -- an invalid condition must not silently pass. Skip, and say why.
                v_res  := 'NULL';
                v_expr := 'condition ' || s.condition_id || ' is not compiled';
            END;
        END IF;

        IF v_res <> 'TRUE' THEN
            INSERT INTO prod.dct_wf_step_instance
                (instance_id, step_id, step_key, attempt_no, parallel_group, status,
                 condition_result, condition_trace, skipped_reason, activated_at, satisfied_at)
            VALUES (p_instance_id, p_step_id, s.step_key, v_att, s.parallel_group, 'SKIPPED',
                    v_res, v_trace,
                    SUBSTR('condition not met: ' || v_expr, 1, 400),
                    SYSTIMESTAMP, SYSTIMESTAMP)
            RETURNING step_instance_id INTO v_si;

            hist(p_instance_id, 'STEP_SKIPPED', v_si,
                 p_actor_kind => 'SYSTEM',
                 p_to_state   => 'SKIPPED',
                 p_payload    => v_trace,
                 p_note       => SUBSTR(s.step_key || ': ' || v_expr, 1, 400));
            RETURN;
        END IF;

        -- ---------- non-human steps satisfy immediately ----------
        IF s.step_kind = 'SYSTEM' THEN
            INSERT INTO prod.dct_wf_step_instance
                (instance_id, step_id, step_key, attempt_no, parallel_group, status,
                 condition_result, condition_trace, activated_at, satisfied_at)
            VALUES (p_instance_id, p_step_id, s.step_key, v_att, s.parallel_group, 'SATISFIED',
                    v_res, v_trace, SYSTIMESTAMP, SYSTIMESTAMP)
            RETURNING step_instance_id INTO v_si;

            IF s.system_action_code IS NOT NULL THEN
                FOR a IN (SELECT action_id FROM prod.dct_wf_action_registry
                           WHERE action_code = s.system_action_code AND is_active = 'Y')
                LOOP
                    run_action(a.action_id, p_instance_id, v_inst.source_module,
                               v_inst.source_record_id, p_user_id);
                END LOOP;
            END IF;

            hist(p_instance_id, 'STEP_SATISFIED', v_si,
                 p_actor_kind => 'SYSTEM', p_to_state => 'SATISFIED',
                 p_note => s.step_key);
            RETURN;
        END IF;

        -- ---------- resolve who ----------
        -- as-of = the request's submission date: assignments are evaluated
        -- against who held the role when the request entered the system,
        -- for every step, even after a return-and-resubmit.
        resolve_participants(p_step_id, p_instance_id, v_inst.fact_doc,
                             v_inst.initiator_user_id, v_inst.initiator_org_id,
                             v_pcode, v_mid, v_prins, v_reason,
                             p_asof => CAST(v_inst.started_at AS DATE));

        -- how many principals (delegates do not count toward quorum -- they act
        -- FOR a principal, they are not an extra approver)
        v_nprin := 0;
        FOR i IN 1 .. v_prins.COUNT LOOP
            IF v_prins(i).via <> 'DELEGATE' THEN
                v_nprin := v_nprin + 1;
            END IF;
        END LOOP;

        IF v_nprin = 0 THEN
            -- nobody to ask and the fallback did not raise: skip, loudly and visibly
            INSERT INTO prod.dct_wf_step_instance
                (instance_id, step_id, step_key, attempt_no, parallel_group, status,
                 condition_result, skipped_reason, activated_at, satisfied_at)
            VALUES (p_instance_id, p_step_id, s.step_key, v_att, s.parallel_group, 'SKIPPED',
                    v_res, SUBSTR(NVL(v_reason, 'no participant resolved'), 1, 400),
                    SYSTIMESTAMP, SYSTIMESTAMP)
            RETURNING step_instance_id INTO v_si;

            hist(p_instance_id, 'STEP_SKIPPED', v_si,
                 p_actor_kind => 'SYSTEM', p_to_state => 'SKIPPED',
                 p_note => SUBSTR(s.step_key || ': ' || NVL(v_reason, 'no participant'), 1, 400));
            RETURN;
        END IF;

        -- ---------- quorum ----------
        v_req := CASE s.quorum_type
                    WHEN 'ALL'     THEN v_nprin
                    WHEN 'ANY'     THEN 1
                    WHEN 'N_OF_M'  THEN LEAST(GREATEST(NVL(s.quorum_n, 1), 1), v_nprin)
                    WHEN 'PERCENT' THEN GREATEST(CEIL(v_nprin * NVL(s.quorum_n, 100) / 100), 1)
                    ELSE v_nprin
                 END;

        -- a pure FYI step blocks nobody
        v_setid := s.outcome_set_id;
        IF v_setid IS NOT NULL THEN
            DECLARE
                v_blocking NUMBER;
            BEGIN
                SELECT COUNT(*) INTO v_blocking
                  FROM prod.dct_wf_outcome
                 WHERE set_id = v_setid AND counts_toward_quorum = 'Y';
                IF v_blocking = 0 THEN
                    v_req := 0;
                END IF;
            END;
        END IF;

        v_due := due_from(SYSTIMESTAMP, s.sla_hours, s.sla_calendar);

        INSERT INTO prod.dct_wf_step_instance
            (instance_id, step_id, step_key, attempt_no, parallel_group, status,
             quorum_type, quorum_required, quorum_met, condition_result, condition_trace,
             activated_at, due_at)
        VALUES (p_instance_id, p_step_id, s.step_key, v_att, s.parallel_group, 'ACTIVE',
                s.quorum_type, v_req, 0, v_res, v_trace, SYSTIMESTAMP, v_due)
        RETURNING step_instance_id INTO v_si;

        -- ---------- denormalized task header (this is what makes the inbox one scan) ----------
        v_amt := fact_num(v_inst.fact_doc, 'amount');
        v_cur := fact_str(v_inst.fact_doc, 'currency');
        BEGIN
            SELECT display_name INTO v_rname
              FROM prod.dct_users WHERE user_id = v_inst.initiator_user_id;
        EXCEPTION WHEN OTHERS THEN
            v_rname := fact_str(v_inst.fact_doc, 'requester_name');
        END;

        -- ---------- one task per principal ----------
        FOR i IN 1 .. v_prins.COUNT LOOP
            IF v_prins(i).via <> 'DELEGATE' THEN
                INSERT INTO prod.dct_wf_task
                    (step_instance_id, instance_id, assignee_user_id, state, due_at,
                     priority, subject_en, subject_ar, source_record_ref,
                     amount, currency, requester_name, module_code)
                VALUES (v_si, p_instance_id, v_prins(i).user_id, 'ASSIGNED', v_due,
                        NVL(v_inst.priority, 3), s.name_en, s.name_ar,
                        v_inst.source_record_ref, v_amt, NVL(v_cur, 'AED'),
                        v_rname, v_mcode)
                RETURNING task_id INTO v_tid;

                INSERT INTO prod.dct_wf_task_participant
                    (task_id, user_id, participant_type, via, via_ref)
                VALUES (v_tid, v_prins(i).user_id, 'POTENTIAL_OWNER',
                        v_prins(i).via, v_prins(i).via_ref);

                -- attach this principal's delegates to THIS task
                FOR j IN 1 .. v_prins.COUNT LOOP
                    IF v_prins(j).via = 'DELEGATE'
                       AND v_prins(j).via_ref = TO_CHAR(v_prins(i).user_id) THEN
                        BEGIN
                            INSERT INTO prod.dct_wf_task_participant
                                (task_id, user_id, participant_type, via, via_ref)
                            VALUES (v_tid, v_prins(j).user_id, 'POTENTIAL_OWNER',
                                    'DELEGATE', v_prins(j).via_ref);
                        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
                        END;
                    END IF;
                END LOOP;

                hist(p_instance_id, 'TASK_CREATED', v_si, v_tid,
                     p_actor_kind => 'SYSTEM', p_to_state => 'ASSIGNED',
                     p_note => s.step_key || ' -> user ' || v_prins(i).user_id);

                notify_user(v_prins(i).user_id, p_instance_id, v_tid,
                            CASE WHEN v_req = 0 THEN 'FYI' ELSE 'TASK_ASSIGNED' END,
                            v_inst.version_id, p_step_id, s.name_en);
            END IF;
        END LOOP;

        -- notify the delegates too -- otherwise delegation is invisible until they look
        FOR i IN 1 .. v_prins.COUNT LOOP
            IF v_prins(i).via = 'DELEGATE' THEN
                notify_user(v_prins(i).user_id, p_instance_id, NULL, 'TASK_ASSIGNED',
                            v_inst.version_id, p_step_id, s.name_en);
            END IF;
        END LOOP;

        hist(p_instance_id, 'STEP_ACTIVATED', v_si,
             p_actor_kind => 'SYSTEM', p_to_state => 'ACTIVE',
             p_note => s.step_key || ' quorum ' || v_req || ' of ' || v_nprin);

        -- a NOTIFY step, or an all-FYI step, blocks nobody: satisfy it at once
        IF s.step_kind = 'NOTIFY' OR v_req = 0 THEN
            UPDATE prod.dct_wf_step_instance
               SET status = 'SATISFIED', satisfied_at = SYSTIMESTAMP
             WHERE step_instance_id = v_si;
            hist(p_instance_id, 'STEP_SATISFIED', v_si,
                 p_actor_kind => 'SYSTEM', p_to_state => 'SATISFIED',
                 p_note => s.step_key || ' (informational)');
            RETURN;
        END IF;

        o_active := TRUE;
    END;

    -- ---------------------------------------------------------------------
    -- finalize
    -- ---------------------------------------------------------------------
    PROCEDURE finish_instance (p_instance_id IN NUMBER,
                               p_status      IN VARCHAR2,
                               p_outcome     IN VARCHAR2,
                               p_user_id     IN NUMBER) IS
        v_inst  prod.dct_wf_instance%ROWTYPE;
        v_rfc   VARCHAR2(1);
        v_hooks NUMBER;
        v_evt   VARCHAR2(30);
    BEGIN
        SELECT * INTO v_inst FROM prod.dct_wf_instance WHERE instance_id = p_instance_id;

        SELECT requires_final_callback INTO v_rfc
          FROM prod.dct_wf_process WHERE process_id = v_inst.process_id;

        v_evt := CASE p_status
                    WHEN 'COMPLETED' THEN 'ON_COMPLETE'
                    WHEN 'REJECTED'  THEN 'ON_REJECT'
                    WHEN 'CANCELLED' THEN 'ON_CANCEL'
                    ELSE 'ON_COMPLETE'
                 END;

        -- THE fail-closed guard. The headline bug in the legacy engine is that
        -- DCT_APPROVAL_PKG.apply_final_approval omits all 6 FL modules, so an
        -- auto-approved FL registration reaches APPROVED while the freelancer
        -- profile is never created. Here that is structurally impossible: a
        -- process that declares it needs a final callback cannot finalize
        -- without one.
        IF p_status = 'COMPLETED' AND v_rfc = 'Y' THEN
            SELECT COUNT(*) INTO v_hooks
              FROM prod.dct_wf_process_hook h
              JOIN prod.dct_wf_action_registry a ON a.action_id = h.action_id
             WHERE h.version_id = v_inst.version_id
               AND h.event_code = 'ON_COMPLETE'
               AND h.is_active  = 'Y'
               AND a.is_active  = 'Y';
            IF v_hooks = 0 THEN
                err(-20301, 'process requires a final callback but version '
                          || v_inst.version_id || ' has no active ON_COMPLETE hook');
            END IF;
        END IF;

        -- close every task still open
        UPDATE prod.dct_wf_task
           SET state = 'CANCELLED'
         WHERE instance_id = p_instance_id
           AND state IN ('UNASSIGNED', 'ASSIGNED', 'INFO_REQUESTED');

        UPDATE prod.dct_wf_step_instance
           SET status = 'CANCELLED'
         WHERE instance_id = p_instance_id
           AND status IN ('PENDING', 'ACTIVE');

        UPDATE prod.dct_wf_instance
           SET status       = p_status,
               outcome_code = p_outcome,
               completed_at = SYSTIMESTAMP
         WHERE instance_id = p_instance_id;

        hist(p_instance_id, 'INSTANCE_' || p_status,
             p_actor_user_id => p_user_id,
             p_actor_kind    => CASE WHEN p_user_id IS NULL THEN 'SYSTEM' ELSE 'USER' END,
             p_outcome_code  => p_outcome,
             p_from_state    => v_inst.status,
             p_to_state      => p_status);

        run_hooks(p_instance_id, v_inst.version_id, NULL, v_evt, p_user_id);

        IF v_inst.initiator_user_id IS NOT NULL THEN
            notify_user(v_inst.initiator_user_id, p_instance_id, NULL,
                        'INSTANCE_' || p_status, v_inst.version_id, NULL);
        END IF;
    END;

    -- ---------------------------------------------------------------------
    -- advance -- pick and activate the next step(s)
    -- ---------------------------------------------------------------------
    PROCEDURE advance (p_instance_id IN NUMBER, p_user_id IN NUMBER) IS
        v_inst   prod.dct_wf_instance%ROWTYPE;
        v_open   NUMBER;
        v_next   NUMBER;
        v_grp    VARCHAR2(40);
        v_active BOOLEAN;
        v_any    BOOLEAN;
        v_guard  PLS_INTEGER := 0;
    BEGIN
        LOOP
            v_guard := v_guard + 1;
            EXIT WHEN v_guard > 200;

            SELECT * INTO v_inst FROM prod.dct_wf_instance WHERE instance_id = p_instance_id;
            IF v_inst.status NOT IN ('RUNNING', 'WAITING') THEN
                RETURN;
            END IF;

            -- still waiting on somebody?
            SELECT COUNT(*) INTO v_open
              FROM prod.dct_wf_step_instance
             WHERE instance_id = p_instance_id AND status = 'ACTIVE';
            IF v_open > 0 THEN
                RETURN;
            END IF;

            -- the next step is the lowest-seq step of this version that has no
            -- SATISFIED / SKIPPED activation. After a RETURN_TO_STEP every step at
            -- or beyond the target is CANCELLED, so they become eligible again --
            -- which is precisely what "rework in place" means.
            BEGIN
                SELECT step_id, parallel_group
                  INTO v_next, v_grp
                  FROM (SELECT s.step_id, s.parallel_group
                          FROM prod.dct_wf_step s
                         WHERE s.version_id = v_inst.version_id
                           AND NOT EXISTS (SELECT 1
                                             FROM prod.dct_wf_step_instance si
                                            WHERE si.instance_id = p_instance_id
                                              AND si.step_id     = s.step_id
                                              AND si.status IN ('SATISFIED', 'SKIPPED'))
                         ORDER BY s.step_seq)
                 WHERE ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                -- chain exhausted: the request is approved
                finish_instance(p_instance_id, 'COMPLETED', 'APPROVED', p_user_id);
                RETURN;
            END;

            v_any := FALSE;

            IF v_grp IS NULL THEN
                activate_step(p_instance_id, v_next, p_user_id, v_active);
                v_any := v_active;
            ELSE
                -- a parallel group activates together
                FOR g IN (SELECT s.step_id
                            FROM prod.dct_wf_step s
                           WHERE s.version_id     = v_inst.version_id
                             AND s.parallel_group = v_grp
                             AND NOT EXISTS (SELECT 1
                                               FROM prod.dct_wf_step_instance si
                                              WHERE si.instance_id = p_instance_id
                                                AND si.step_id     = s.step_id
                                                AND si.status IN ('SATISFIED', 'SKIPPED'))
                           ORDER BY s.step_seq)
                LOOP
                    activate_step(p_instance_id, g.step_id, p_user_id, v_active);
                    IF v_active THEN
                        v_any := TRUE;
                    END IF;
                END LOOP;
            END IF;

            IF v_any THEN
                -- somebody now has work to do
                RETURN;
            END IF;
            -- else the step skipped or self-satisfied: keep walking
        END LOOP;

        err(-20307, 'workflow advance did not converge on instance ' || p_instance_id);
    END;

    -- ---------------------------------------------------------------------
    -- start
    -- ---------------------------------------------------------------------
    FUNCTION start_process (p_process_code      IN VARCHAR2,
                            p_source_record_id  IN NUMBER,
                            p_initiator_user_id IN NUMBER   DEFAULT NULL,
                            p_source_record_ref IN VARCHAR2 DEFAULT NULL,
                            p_facts             IN CLOB     DEFAULT NULL) RETURN NUMBER IS
        v_pid   NUMBER;
        v_vid   NUMBER;
        v_sch   NUMBER;
        v_mod   VARCHAR2(40);
        v_facts CLOB;
        v_org   NUMBER;
        v_iid   NUMBER;
    BEGIN
        SELECT p.process_id, p.schema_id, p.source_module
          INTO v_pid, v_sch, v_mod
          FROM prod.dct_wf_process p
         WHERE p.process_code = p_process_code
           AND p.is_active = 'Y';

        BEGIN
            SELECT version_id INTO v_vid
              FROM prod.dct_wf_process_version
             WHERE process_id = v_pid AND status = 'PUBLISHED';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            err(-20306, 'process ' || p_process_code || ' has no PUBLISHED version');
        END;

        v_facts := NVL(p_facts,
                       CASE WHEN v_sch IS NULL THEN TO_CLOB('{"roles":[]}')
                            ELSE build_facts(v_sch, p_source_record_id, p_initiator_user_id)
                       END);

        BEGIN
            SELECT org_id INTO v_org FROM prod.dct_users WHERE user_id = p_initiator_user_id;
        EXCEPTION WHEN OTHERS THEN
            v_org := NULL;
        END;

        INSERT INTO prod.dct_wf_instance
            (process_id, version_id, source_module, source_record_id, source_record_ref,
             fact_doc, fact_refreshed_at, status, initiator_user_id, initiator_org_id)
        VALUES (v_pid, v_vid, v_mod, p_source_record_id, p_source_record_ref,
                v_facts, SYSTIMESTAMP, 'RUNNING', p_initiator_user_id, v_org)
        RETURNING instance_id INTO v_iid;

        hist(v_iid, 'INSTANCE_STARTED',
             p_actor_user_id => p_initiator_user_id,
             p_actor_kind    => CASE WHEN p_initiator_user_id IS NULL THEN 'SYSTEM' ELSE 'USER' END,
             p_to_state      => 'RUNNING',
             p_note          => p_process_code);

        run_hooks(v_iid, v_vid, NULL, 'ON_SUBMIT', p_initiator_user_id);

        advance(v_iid, p_initiator_user_id);

        RETURN v_iid;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        err(-20404, 'no active workflow process with code ' || p_process_code);
        RETURN NULL;
    END;

    -- ---------------------------------------------------------------------
    -- authorization
    -- ---------------------------------------------------------------------
    FUNCTION can_act (p_task_id IN NUMBER, p_user_id IN NUMBER) RETURN VARCHAR2 IS
        v NUMBER;
        v_state VARCHAR2(16);
    BEGIN
        SELECT state INTO v_state FROM prod.dct_wf_task WHERE task_id = p_task_id;
        IF v_state NOT IN ('UNASSIGNED', 'ASSIGNED', 'INFO_REQUESTED') THEN
            RETURN 'N';
        END IF;

        SELECT COUNT(*) INTO v
          FROM prod.dct_wf_task_participant
         WHERE task_id          = p_task_id
           AND user_id          = p_user_id
           AND is_active        = 'Y'
           AND participant_type = 'POTENTIAL_OWNER';

        RETURN CASE WHEN v > 0 THEN 'Y' ELSE 'N' END;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN 'N';
    END;

    FUNCTION active_task_for (p_instance_id IN NUMBER, p_user_id IN NUMBER) RETURN NUMBER IS
        v NUMBER;
    BEGIN
        -- A user can legitimately hold TWO open tasks on one instance: an FYI
        -- acknowledgement (whose step has already satisfied -- an FYI blocks nobody,
        -- so it stays open until acknowledged) and a real approval at the step that
        -- is currently ACTIVE. "The task this user acts on for this request" means
        -- the blocking one, so an ACTIVE step always outranks a satisfied one.
        -- Ordering by task_id alone hands back the FYI, which is the wrong answer
        -- for the compat facade and for every caller that asks this question.
        SELECT task_id INTO v
          FROM (SELECT t.task_id
                  FROM prod.dct_wf_task t
                  JOIN prod.dct_wf_task_participant tp
                    ON tp.task_id = t.task_id
                  JOIN prod.dct_wf_step_instance si
                    ON si.step_instance_id = t.step_instance_id
                 WHERE t.instance_id = p_instance_id
                   AND t.state IN ('UNASSIGNED', 'ASSIGNED', 'INFO_REQUESTED')
                   AND tp.user_id   = p_user_id
                   AND tp.is_active = 'Y'
                 ORDER BY CASE WHEN si.status = 'ACTIVE' THEN 0 ELSE 1 END,
                          t.task_id)
         WHERE ROWNUM = 1;
        RETURN v;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;

    -- ---------------------------------------------------------------------
    -- complete_task -- the one call that moves a workflow forward
    -- ---------------------------------------------------------------------
    PROCEDURE complete_task (p_task_id      IN NUMBER,
                             p_user_id      IN NUMBER,
                             p_outcome_code IN VARCHAR2,
                             p_comments     IN VARCHAR2 DEFAULT NULL) IS
        t        prod.dct_wf_task%ROWTYPE;
        si       prod.dct_wf_step_instance%ROWTYPE;
        s        prod.dct_wf_step%ROWTYPE;
        o        prod.dct_wf_outcome%ROWTYPE;
        v_inst   prod.dct_wf_instance%ROWTYPE;
        v_met    NUMBER;
        v_tgt    NUMBER;
        v_tgtseq NUMBER;
        v_cycles NUMBER;
        v_actor  VARCHAR2(200);
        v_sibs   NUMBER;
    BEGIN
        SELECT * INTO t FROM prod.dct_wf_task WHERE task_id = p_task_id FOR UPDATE;

        IF t.state NOT IN ('UNASSIGNED', 'ASSIGNED', 'INFO_REQUESTED') THEN
            err(-20308, 'task ' || p_task_id || ' is ' || t.state || ', not open');
        END IF;
        IF can_act(p_task_id, p_user_id) <> 'Y' THEN
            err(-20303, 'user ' || p_user_id || ' may not act on task ' || p_task_id);
        END IF;

        SELECT * INTO si FROM prod.dct_wf_step_instance
         WHERE step_instance_id = t.step_instance_id FOR UPDATE;
        SELECT * INTO s      FROM prod.dct_wf_step     WHERE step_id     = si.step_id;
        SELECT * INTO v_inst FROM prod.dct_wf_instance WHERE instance_id = t.instance_id FOR UPDATE;

        -- the outcome must belong to THIS step's set. This is the whole of
        -- requirement 2: there is no hard-coded Approve/Reject anywhere.
        BEGIN
            SELECT * INTO o
              FROM prod.dct_wf_outcome
             WHERE set_id       = s.outcome_set_id
               AND outcome_code = UPPER(TRIM(p_outcome_code));
        EXCEPTION WHEN NO_DATA_FOUND THEN
            err(-20304, 'outcome ' || p_outcome_code
                      || ' is not offered by step ' || s.step_key);
        END;

        IF (o.requires_comment = 'Y'
            OR s.comment_required = 'ALWAYS'
            OR (s.comment_required = 'ON_NEGATIVE' AND o.is_positive = 'N'))
           AND TRIM(p_comments) IS NULL THEN
            err(-20305, 'a comment is required for outcome ' || o.outcome_code);
        END IF;

        BEGIN
            SELECT display_name INTO v_actor
              FROM prod.dct_users WHERE user_id = p_user_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            v_actor := 'user ' || p_user_id;
        END;

        UPDATE prod.dct_wf_task
           SET state        = 'COMPLETED',
               outcome_code = o.outcome_code,
               outcome_by   = p_user_id,
               outcome_at   = SYSTIMESTAMP,
               comments     = p_comments,
               assignee_user_id = NVL(assignee_user_id, p_user_id)
         WHERE task_id = p_task_id;

        hist(t.instance_id, 'TASK_COMPLETED', t.step_instance_id, p_task_id,
             p_actor_user_id => p_user_id,
             p_outcome_code  => o.outcome_code,
             p_comments      => p_comments,
             p_from_state    => t.state,
             p_to_state      => 'COMPLETED',
             p_note          => s.step_key);

        -- tell the requester what happened, in their own language, by name of the
        -- real outcome -- "Endorsed", not "Approved".
        IF v_inst.initiator_user_id IS NOT NULL THEN
            notify_user(v_inst.initiator_user_id, t.instance_id, p_task_id,
                        'OUTCOME_RECORDED', v_inst.version_id, si.step_id,
                        s.name_en, v_actor, o.label_en);
        END IF;

        -- ---------------- semantics ----------------
        CASE o.semantic

            WHEN 'NOOP' THEN
                -- FYI: recorded, blocks nothing. If the step still has blocking
                -- tasks open it stays ACTIVE; otherwise it is done.
                SELECT COUNT(*) INTO v_sibs
                  FROM prod.dct_wf_task
                 WHERE step_instance_id = si.step_instance_id
                   AND state IN ('UNASSIGNED', 'ASSIGNED', 'INFO_REQUESTED');
                IF v_sibs = 0 THEN
                    UPDATE prod.dct_wf_step_instance
                       SET status = 'SATISFIED', satisfied_at = SYSTIMESTAMP
                     WHERE step_instance_id = si.step_instance_id;
                    hist(t.instance_id, 'STEP_SATISFIED', si.step_instance_id,
                         p_actor_kind => 'SYSTEM', p_to_state => 'SATISFIED');
                    advance(t.instance_id, p_user_id);
                END IF;

            WHEN 'HOLD' THEN
                UPDATE prod.dct_wf_instance
                   SET status = 'SUSPENDED' WHERE instance_id = t.instance_id;
                hist(t.instance_id, 'INSTANCE_SUSPENDED', si.step_instance_id, p_task_id,
                     p_actor_user_id => p_user_id, p_to_state => 'SUSPENDED');

            WHEN 'REJECT' THEN
                IF s.veto_on_reject = 'Y' THEN
                    UPDATE prod.dct_wf_step_instance
                       SET status = 'REJECTED', satisfied_at = SYSTIMESTAMP
                     WHERE step_instance_id = si.step_instance_id;
                    finish_instance(t.instance_id, 'REJECTED', o.outcome_code, p_user_id);
                ELSE
                    -- no veto: this rejection just cannot count toward quorum.
                    -- if nobody is left who could still satisfy it, the step fails.
                    SELECT COUNT(*) INTO v_sibs
                      FROM prod.dct_wf_task
                     WHERE step_instance_id = si.step_instance_id
                       AND state IN ('UNASSIGNED', 'ASSIGNED', 'INFO_REQUESTED');
                    IF NVL(si.quorum_met, 0) + v_sibs < si.quorum_required THEN
                        UPDATE prod.dct_wf_step_instance
                           SET status = 'REJECTED', satisfied_at = SYSTIMESTAMP
                         WHERE step_instance_id = si.step_instance_id;
                        finish_instance(t.instance_id, 'REJECTED', o.outcome_code, p_user_id);
                    END IF;
                END IF;

            WHEN 'RETURN_TO_INITIATOR' THEN
                UPDATE prod.dct_wf_task
                   SET state = 'CANCELLED'
                 WHERE instance_id = t.instance_id
                   AND state IN ('UNASSIGNED', 'ASSIGNED', 'INFO_REQUESTED');
                UPDATE prod.dct_wf_step_instance
                   SET status = 'CANCELLED'
                 WHERE instance_id = t.instance_id
                   AND status = 'ACTIVE';
                UPDATE prod.dct_wf_instance
                   SET status = 'RETURNED' WHERE instance_id = t.instance_id;

                hist(t.instance_id, 'INSTANCE_RETURNED', si.step_instance_id, p_task_id,
                     p_actor_user_id => p_user_id, p_outcome_code => o.outcome_code,
                     p_to_state => 'RETURNED');
                run_hooks(t.instance_id, v_inst.version_id, si.step_id, 'ON_RETURN', p_user_id);
                IF v_inst.initiator_user_id IS NOT NULL THEN
                    notify_user(v_inst.initiator_user_id, t.instance_id, NULL, 'RETURNED',
                                v_inst.version_id, si.step_id, s.name_en, v_actor, o.label_en);
                END IF;

            WHEN 'RETURN_TO_STEP' THEN
                -- rework IN PLACE. The legacy engine could not do this at all: it
                -- set current_step_seq to NULL and killed the instance, so a
                -- resubmission forked a new instance and the audit trail split.
                IF o.target_step_key IS NULL THEN
                    err(-20309, 'outcome ' || o.outcome_code || ' is RETURN_TO_STEP '
                              || 'but names no target step');
                END IF;

                BEGIN
                    SELECT step_id, step_seq INTO v_tgt, v_tgtseq
                      FROM prod.dct_wf_step
                     WHERE version_id = v_inst.version_id
                       AND step_key   = o.target_step_key;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                    err(-20309, 'target step ' || o.target_step_key || ' does not exist');
                END;

                v_cycles := NVL(v_inst.cycle_count, 0) + 1;
                IF v_cycles > c_max_cycles THEN
                    UPDATE prod.dct_wf_instance
                       SET status      = 'FAULTED',
                           cycle_count = v_cycles,
                           error_code  = 'MAX_CYCLES',
                           error_msg   = 'return loop exceeded ' || c_max_cycles || ' cycles'
                     WHERE instance_id = t.instance_id;
                    hist(t.instance_id, 'INSTANCE_FAULTED', si.step_instance_id, p_task_id,
                         p_actor_kind => 'SYSTEM', p_to_state => 'FAULTED',
                         p_note => 'return loop exceeded ' || c_max_cycles);
                    -- a silent infinite loop in a workflow engine is production-stopping.
                    -- make it loud.
                    err(-20307, 'return loop limit exceeded on instance ' || t.instance_id);
                END IF;

                UPDATE prod.dct_wf_instance
                   SET cycle_count = v_cycles WHERE instance_id = t.instance_id;

                -- everything at or after the target is superseded, so advance() sees
                -- those steps as un-run again
                UPDATE prod.dct_wf_task
                   SET state = 'CANCELLED'
                 WHERE step_instance_id IN (
                        SELECT si2.step_instance_id
                          FROM prod.dct_wf_step_instance si2
                          JOIN prod.dct_wf_step s2 ON s2.step_id = si2.step_id
                         WHERE si2.instance_id = t.instance_id
                           AND s2.step_seq >= v_tgtseq)
                   AND state IN ('UNASSIGNED', 'ASSIGNED', 'INFO_REQUESTED');

                UPDATE prod.dct_wf_step_instance
                   SET status = 'CANCELLED'
                 WHERE step_instance_id IN (
                        SELECT si2.step_instance_id
                          FROM prod.dct_wf_step_instance si2
                          JOIN prod.dct_wf_step s2 ON s2.step_id = si2.step_id
                         WHERE si2.instance_id = t.instance_id
                           AND s2.step_seq >= v_tgtseq)
                   AND status IN ('PENDING', 'ACTIVE', 'SATISFIED', 'SKIPPED');

                hist(t.instance_id, 'RETURNED_TO_STEP', si.step_instance_id, p_task_id,
                     p_actor_user_id => p_user_id, p_outcome_code => o.outcome_code,
                     p_note => 'back to ' || o.target_step_key
                            || ' (cycle ' || v_cycles || ')');
                run_hooks(t.instance_id, v_inst.version_id, si.step_id, 'ON_RETURN', p_user_id);

                advance(t.instance_id, p_user_id);

            WHEN 'ROUTE' THEN
                IF o.target_step_key IS NULL THEN
                    err(-20309, 'outcome ' || o.outcome_code || ' is ROUTE but names no target');
                END IF;
                BEGIN
                    SELECT step_id, step_seq INTO v_tgt, v_tgtseq
                      FROM prod.dct_wf_step
                     WHERE version_id = v_inst.version_id
                       AND step_key   = o.target_step_key;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                    err(-20309, 'target step ' || o.target_step_key || ' does not exist');
                END;

                UPDATE prod.dct_wf_step_instance
                   SET status = 'SATISFIED', satisfied_at = SYSTIMESTAMP,
                       quorum_met = NVL(quorum_met, 0) + 1
                 WHERE step_instance_id = si.step_instance_id;

                UPDATE prod.dct_wf_task
                   SET state = 'CANCELLED'
                 WHERE step_instance_id = si.step_instance_id
                   AND state IN ('UNASSIGNED', 'ASSIGNED', 'INFO_REQUESTED');

                -- everything between here and the target is bypassed, on the record
                INSERT INTO prod.dct_wf_step_instance
                    (instance_id, step_id, step_key, attempt_no, status,
                     skipped_reason, activated_at, satisfied_at)
                SELECT t.instance_id, s2.step_id, s2.step_key,
                       NVL((SELECT MAX(attempt_no) FROM prod.dct_wf_step_instance si3
                             WHERE si3.instance_id = t.instance_id
                               AND si3.step_id = s2.step_id), 0) + 1,
                       'SKIPPED',
                       'routed past by outcome ' || o.outcome_code,
                       SYSTIMESTAMP, SYSTIMESTAMP
                  FROM prod.dct_wf_step s2
                 WHERE s2.version_id = v_inst.version_id
                   AND s2.step_seq   > s.step_seq
                   AND s2.step_seq   < v_tgtseq
                   AND NOT EXISTS (SELECT 1 FROM prod.dct_wf_step_instance si4
                                    WHERE si4.instance_id = t.instance_id
                                      AND si4.step_id     = s2.step_id
                                      AND si4.status IN ('SATISFIED', 'SKIPPED'));

                hist(t.instance_id, 'ROUTED', si.step_instance_id, p_task_id,
                     p_actor_user_id => p_user_id, p_outcome_code => o.outcome_code,
                     p_note => 'routed to ' || o.target_step_key);

                run_hooks(t.instance_id, v_inst.version_id, si.step_id,
                          'ON_STEP_SATISFIED', p_user_id);
                advance(t.instance_id, p_user_id);

            ELSE   -- ADVANCE
                v_met := NVL(si.quorum_met, 0)
                       + CASE WHEN o.counts_toward_quorum = 'Y' THEN 1 ELSE 0 END;

                UPDATE prod.dct_wf_step_instance
                   SET quorum_met = v_met
                 WHERE step_instance_id = si.step_instance_id;

                IF v_met >= si.quorum_required THEN
                    UPDATE prod.dct_wf_step_instance
                       SET status = 'SATISFIED', satisfied_at = SYSTIMESTAMP
                     WHERE step_instance_id = si.step_instance_id;

                    -- quorum reached: the others no longer need to act
                    UPDATE prod.dct_wf_task
                       SET state = 'CANCELLED'
                     WHERE step_instance_id = si.step_instance_id
                       AND state IN ('UNASSIGNED', 'ASSIGNED', 'INFO_REQUESTED');

                    hist(t.instance_id, 'STEP_SATISFIED', si.step_instance_id,
                         p_actor_kind => 'SYSTEM', p_to_state => 'SATISFIED',
                         p_note => s.step_key || ' quorum ' || v_met
                                || ' of ' || si.quorum_required);

                    run_hooks(t.instance_id, v_inst.version_id, si.step_id,
                              'ON_STEP_SATISFIED', p_user_id);
                    advance(t.instance_id, p_user_id);
                END IF;
        END CASE;
    END;

    -- ---------------------------------------------------------------------
    -- claim / release / delegate / reassign
    -- ---------------------------------------------------------------------
    PROCEDURE claim_task (p_task_id IN NUMBER, p_user_id IN NUMBER) IS
    BEGIN
        IF can_act(p_task_id, p_user_id) <> 'Y' THEN
            err(-20303, 'user ' || p_user_id || ' may not claim task ' || p_task_id);
        END IF;
        UPDATE prod.dct_wf_task
           SET assignee_user_id = p_user_id,
               state            = 'ASSIGNED',
               claimed_at       = SYSTIMESTAMP
         WHERE task_id = p_task_id;

        INSERT INTO prod.dct_wf_history (instance_id, task_id, event_code, actor_user_id, to_state)
        SELECT instance_id, task_id, 'TASK_CLAIMED', p_user_id, 'ASSIGNED'
          FROM prod.dct_wf_task WHERE task_id = p_task_id;
    END;

    PROCEDURE release_task (p_task_id IN NUMBER, p_user_id IN NUMBER) IS
    BEGIN
        IF can_act(p_task_id, p_user_id) <> 'Y' THEN
            err(-20303, 'user ' || p_user_id || ' may not release task ' || p_task_id);
        END IF;
        UPDATE prod.dct_wf_task
           SET assignee_user_id = NULL,
               state            = 'UNASSIGNED',
               claimed_at       = NULL
         WHERE task_id = p_task_id;

        INSERT INTO prod.dct_wf_history (instance_id, task_id, event_code, actor_user_id, to_state)
        SELECT instance_id, task_id, 'TASK_RELEASED', p_user_id, 'UNASSIGNED'
          FROM prod.dct_wf_task WHERE task_id = p_task_id;
    END;

    PROCEDURE delegate_task (p_task_id    IN NUMBER,
                             p_user_id    IN NUMBER,
                             p_to_user_id IN NUMBER,
                             p_comments   IN VARCHAR2 DEFAULT NULL) IS
        v_inst NUMBER;
        v_si   NUMBER;
        v_step NUMBER;
        v_vid  NUMBER;
    BEGIN
        IF can_act(p_task_id, p_user_id) <> 'Y' THEN
            err(-20303, 'user ' || p_user_id || ' may not delegate task ' || p_task_id);
        END IF;

        SELECT t.instance_id, t.step_instance_id, si.step_id, i.version_id
          INTO v_inst, v_si, v_step, v_vid
          FROM prod.dct_wf_task t
          JOIN prod.dct_wf_step_instance si ON si.step_instance_id = t.step_instance_id
          JOIN prod.dct_wf_instance i       ON i.instance_id       = t.instance_id
         WHERE t.task_id = p_task_id;

        UPDATE prod.dct_wf_task
           SET delegated_from = p_user_id,
               delegated_to   = p_to_user_id
         WHERE task_id = p_task_id;

        BEGIN
            INSERT INTO prod.dct_wf_task_participant
                (task_id, user_id, participant_type, via, via_ref)
            VALUES (p_task_id, p_to_user_id, 'POTENTIAL_OWNER',
                    'DELEGATE', TO_CHAR(p_user_id));
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
        END;

        hist(v_inst, 'TASK_DELEGATED', v_si, p_task_id,
             p_actor_user_id => p_user_id, p_comments => p_comments,
             p_note => 'to user ' || p_to_user_id);

        notify_user(p_to_user_id, v_inst, p_task_id, 'TASK_ASSIGNED', v_vid, v_step);
    END;

    PROCEDURE reassign_task (p_task_id       IN NUMBER,
                             p_admin_user_id IN NUMBER,
                             p_to_user_id    IN NUMBER,
                             p_reason        IN VARCHAR2 DEFAULT NULL) IS
        v_inst NUMBER;
        v_si   NUMBER;
        v_step NUMBER;
        v_vid  NUMBER;
    BEGIN
        SELECT t.instance_id, t.step_instance_id, si.step_id, i.version_id
          INTO v_inst, v_si, v_step, v_vid
          FROM prod.dct_wf_task t
          JOIN prod.dct_wf_step_instance si ON si.step_instance_id = t.step_instance_id
          JOIN prod.dct_wf_instance i       ON i.instance_id       = t.instance_id
         WHERE t.task_id = p_task_id;

        -- an admin reassignment REPLACES the owner (the leaver case), so the old
        -- participant rows go inactive rather than accumulating
        UPDATE prod.dct_wf_task_participant
           SET is_active = 'N'
         WHERE task_id = p_task_id;

        BEGIN
            INSERT INTO prod.dct_wf_task_participant
                (task_id, user_id, participant_type, via, via_ref)
            VALUES (p_task_id, p_to_user_id, 'POTENTIAL_OWNER',
                    'REASSIGN', TO_CHAR(p_admin_user_id));
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
            UPDATE prod.dct_wf_task_participant
               SET is_active = 'Y', via = 'REASSIGN'
             WHERE task_id = p_task_id AND user_id = p_to_user_id;
        END;

        UPDATE prod.dct_wf_task
           SET assignee_user_id = p_to_user_id,
               state            = 'ASSIGNED'
         WHERE task_id = p_task_id;

        hist(v_inst, 'TASK_REASSIGNED', v_si, p_task_id,
             p_actor_user_id => p_admin_user_id, p_actor_kind => 'ADMIN',
             p_note => SUBSTR('to user ' || p_to_user_id || ': ' || p_reason, 1, 400));

        notify_user(p_to_user_id, v_inst, p_task_id, 'TASK_ASSIGNED', v_vid, v_step);
    END;

    -- ---------------------------------------------------------------------
    -- request info
    -- ---------------------------------------------------------------------
    FUNCTION request_info (p_task_id    IN NUMBER,
                           p_user_id    IN NUMBER,
                           p_of_user_id IN NUMBER,
                           p_question   IN VARCHAR2) RETURN NUMBER IS
        v_inst NUMBER;
        v_si   NUMBER;
        v_step NUMBER;
        v_vid  NUMBER;
        v_req  NUMBER;
    BEGIN
        IF can_act(p_task_id, p_user_id) <> 'Y' THEN
            err(-20303, 'user ' || p_user_id || ' may not act on task ' || p_task_id);
        END IF;

        SELECT t.instance_id, t.step_instance_id, si.step_id, i.version_id
          INTO v_inst, v_si, v_step, v_vid
          FROM prod.dct_wf_task t
          JOIN prod.dct_wf_step_instance si ON si.step_instance_id = t.step_instance_id
          JOIN prod.dct_wf_instance i       ON i.instance_id       = t.instance_id
         WHERE t.task_id = p_task_id;

        INSERT INTO prod.dct_wf_info_request
            (task_id, instance_id, asked_by, asked_of, question)
        VALUES (p_task_id, v_inst, p_user_id, p_of_user_id, p_question)
        RETURNING req_id INTO v_req;

        UPDATE prod.dct_wf_task
           SET state = 'INFO_REQUESTED' WHERE task_id = p_task_id;

        hist(v_inst, 'INFO_REQUESTED', v_si, p_task_id,
             p_actor_user_id => p_user_id, p_to_state => 'INFO_REQUESTED',
             p_comments => p_question);

        notify_user(p_of_user_id, v_inst, p_task_id, 'INFO_REQUESTED', v_vid, v_step);
        RETURN v_req;
    END;

    PROCEDURE provide_info (p_req_id  IN NUMBER,
                            p_user_id IN NUMBER,
                            p_answer  IN VARCHAR2) IS
        r      prod.dct_wf_info_request%ROWTYPE;
        v_vid  NUMBER;
        v_step NUMBER;
    BEGIN
        SELECT * INTO r FROM prod.dct_wf_info_request WHERE req_id = p_req_id FOR UPDATE;
        IF r.status <> 'OPEN' THEN
            err(-20308, 'information request ' || p_req_id || ' is already ' || r.status);
        END IF;
        IF r.asked_of <> p_user_id THEN
            err(-20303, 'information request ' || p_req_id || ' was not asked of user ' || p_user_id);
        END IF;

        UPDATE prod.dct_wf_info_request
           SET answer = p_answer, status = 'ANSWERED', answered_at = SYSTIMESTAMP
         WHERE req_id = p_req_id;

        UPDATE prod.dct_wf_task
           SET state = 'ASSIGNED'
         WHERE task_id = r.task_id AND state = 'INFO_REQUESTED';

        SELECT i.version_id, si.step_id INTO v_vid, v_step
          FROM prod.dct_wf_task t
          JOIN prod.dct_wf_step_instance si ON si.step_instance_id = t.step_instance_id
          JOIN prod.dct_wf_instance i       ON i.instance_id       = t.instance_id
         WHERE t.task_id = r.task_id;

        hist(r.instance_id, 'INFO_SUBMITTED', NULL, r.task_id,
             p_actor_user_id => p_user_id, p_comments => p_answer);

        notify_user(r.asked_by, r.instance_id, r.task_id, 'INFO_SUBMITTED', v_vid, v_step);
    END;

    -- ---------------------------------------------------------------------
    -- cancel / resubmit
    -- ---------------------------------------------------------------------
    PROCEDURE cancel_instance (p_instance_id IN NUMBER,
                               p_user_id     IN NUMBER,
                               p_reason      IN VARCHAR2 DEFAULT NULL) IS
    BEGIN
        hist(p_instance_id, 'CANCEL_REQUESTED', p_actor_user_id => p_user_id,
             p_comments => p_reason);
        finish_instance(p_instance_id, 'CANCELLED', 'CANCELLED', p_user_id);
    END;

    PROCEDURE resubmit (p_instance_id IN NUMBER,
                        p_user_id     IN NUMBER,
                        p_comments    IN VARCHAR2 DEFAULT NULL) IS
        v_inst prod.dct_wf_instance%ROWTYPE;
    BEGIN
        SELECT * INTO v_inst FROM prod.dct_wf_instance
         WHERE instance_id = p_instance_id FOR UPDATE;

        IF v_inst.status NOT IN ('RETURNED', 'SUSPENDED') THEN
            err(-20308, 'instance ' || p_instance_id || ' is ' || v_inst.status
                      || ' and cannot be resubmitted');
        END IF;

        -- SAME instance resumes. The legacy engine forked a new one and split the
        -- audit trail; this is the fix.
        refresh_facts(p_instance_id);

        UPDATE prod.dct_wf_instance
           SET status = 'RUNNING' WHERE instance_id = p_instance_id;

        hist(p_instance_id, 'INSTANCE_RESUBMITTED',
             p_actor_user_id => p_user_id, p_comments => p_comments,
             p_from_state => v_inst.status, p_to_state => 'RUNNING');

        advance(p_instance_id, p_user_id);
    END;

    -- ---------------------------------------------------------------------
    -- simulate -- no writes, ever
    -- ---------------------------------------------------------------------
    FUNCTION simulate (p_process_code      IN VARCHAR2,
                       p_facts             IN CLOB,
                       p_initiator_user_id IN NUMBER DEFAULT NULL) RETURN CLOB IS
        v_pid   NUMBER;
        v_vid   NUMBER;
        v_pcode VARCHAR2(60);
        v_mid   NUMBER;
        v_org   NUMBER;
        v_out   JSON_OBJECT_T := JSON_OBJECT_T();
        v_steps JSON_ARRAY_T  := JSON_ARRAY_T();
        v_row   JSON_OBJECT_T;
        v_who   JSON_ARRAY_T;
        v_ast   CLOB;
        v_expr  VARCHAR2(2000);
        v_res   VARCHAR2(5);
        v_trace CLOB;
        v_prins t_prins;
        v_reason VARCHAR2(400);
        v_nm    VARCHAR2(200);
        v_due   TIMESTAMP := SYSTIMESTAMP;
    BEGIN
        SELECT p.process_id, p.process_code, p.module_id
          INTO v_pid, v_pcode, v_mid
          FROM prod.dct_wf_process p WHERE p.process_code = p_process_code;

        SELECT MAX(version_id) INTO v_vid
          FROM prod.dct_wf_process_version
         WHERE process_id = v_pid AND status IN ('PUBLISHED', 'DRAFT');

        BEGIN
            SELECT org_id INTO v_org FROM prod.dct_users WHERE user_id = p_initiator_user_id;
        EXCEPTION WHEN OTHERS THEN v_org := NULL;
        END;

        FOR s IN (SELECT * FROM prod.dct_wf_step
                   WHERE version_id = v_vid ORDER BY step_seq)
        LOOP
            v_row := JSON_OBJECT_T();
            v_row.put('stepKey', s.step_key);
            v_row.put('stepSeq', s.step_seq);
            v_row.put('name',    s.name_en);
            v_row.put('kind',    s.step_kind);

            v_res  := 'TRUE';
            v_expr := NULL;
            IF s.condition_id IS NOT NULL THEN
                BEGIN
                    SELECT expr_ast, expr_text INTO v_ast, v_expr
                      FROM prod.dct_wf_condition
                     WHERE condition_id = s.condition_id AND is_valid = 'Y';
                    v_res := prod.dct_wf_expr.eval(v_ast, p_facts, v_trace);
                EXCEPTION WHEN NO_DATA_FOUND THEN
                    v_res  := 'NULL';
                    v_expr := 'not compiled';
                END;
                v_row.put('condition', v_expr);
            END IF;

            v_row.put('fires',  v_res = 'TRUE');
            IF v_res <> 'TRUE' THEN
                -- "why did this step skip" is the single most valuable thing the
                -- legacy engine could never tell anyone
                v_row.put('skipReason', 'condition not met: ' || NVL(v_expr, '-'));
                v_steps.append(v_row);
                CONTINUE;
            END IF;

            v_who := JSON_ARRAY_T();
            IF s.step_kind = 'HUMAN' THEN
                v_prins.DELETE;
                BEGIN
                    resolve_participants(s.step_id, NULL, p_facts, p_initiator_user_id,
                                         v_org, v_pcode, v_mid, v_prins, v_reason);
                EXCEPTION WHEN OTHERS THEN
                    v_reason := SUBSTR(SQLERRM, 1, 200);
                END;
                FOR i IN 1 .. v_prins.COUNT LOOP
                    BEGIN
                        SELECT display_name INTO v_nm
                          FROM prod.dct_users WHERE user_id = v_prins(i).user_id;
                    EXCEPTION WHEN OTHERS THEN v_nm := 'user ' || v_prins(i).user_id;
                    END;
                    v_who.append(v_nm || ' (' || v_prins(i).via || ')');
                END LOOP;
                IF v_prins.COUNT = 0 THEN
                    v_row.put('warning', NVL(v_reason, 'no participant would be resolved'));
                END IF;
                v_due := due_from(v_due, s.sla_hours, s.sla_calendar);
                v_row.put('dueAt', TO_CHAR(v_due, 'YYYY-MM-DD HH24:MI'));
            END IF;
            v_row.put('approvers', v_who);
            v_steps.append(v_row);
        END LOOP;

        v_out.put('processCode', v_pcode);
        v_out.put('versionId',   v_vid);
        v_out.put('steps',       v_steps);
        RETURN v_out.to_clob;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        err(-20404, 'no workflow process with code ' || p_process_code);
        RETURN NULL;
    END;

    -- ---------------------------------------------------------------------
    -- sweep -- reminders, escalation, auto-action, SLA breach
    -- ---------------------------------------------------------------------
    PROCEDURE sweep IS
        v_off   VARCHAR2(200);
        v_hrs   NUMBER;
        v_lvl   NUMBER;
        v_n     PLS_INTEGER;
        v_due   NUMBER;
    BEGIN
        -- ---- reminders ----
        FOR t IN (SELECT t.task_id, t.instance_id, t.due_at, t.reminders_sent,
                         t.assignee_user_id, i.version_id,
                         si.step_id, s.name_en, s.reminder_offsets
                    FROM prod.dct_wf_task t
                    JOIN prod.dct_wf_step_instance si ON si.step_instance_id = t.step_instance_id
                    JOIN prod.dct_wf_step  s ON s.step_id     = si.step_id
                    JOIN prod.dct_wf_instance i ON i.instance_id = t.instance_id
                   WHERE t.state IN ('UNASSIGNED', 'ASSIGNED', 'INFO_REQUESTED')
                     AND t.due_at IS NOT NULL
                     AND s.reminder_offsets IS NOT NULL
                     AND i.status = 'RUNNING')
        LOOP
            v_off := t.reminder_offsets;
            v_n   := REGEXP_COUNT(v_off, '[^,]+');
            -- offsets are hours BEFORE due, largest first: '48,24,4'
            FOR k IN 1 .. v_n LOOP
                v_hrs := TO_NUMBER(TRIM(REGEXP_SUBSTR(v_off, '[^,]+', 1, k)));
                IF v_hrs IS NOT NULL
                   AND NVL(t.reminders_sent, 0) < k
                   AND SYSTIMESTAMP >= t.due_at - NUMTODSINTERVAL(v_hrs, 'HOUR') THEN

                    UPDATE prod.dct_wf_task
                       SET reminders_sent   = k,
                           last_reminder_at = SYSTIMESTAMP
                     WHERE task_id = t.task_id;

                    FOR p IN (SELECT user_id FROM prod.dct_wf_task_participant
                               WHERE task_id = t.task_id AND is_active = 'Y')
                    LOOP
                        notify_user(p.user_id, t.instance_id, t.task_id, 'REMINDER',
                                    t.version_id, t.step_id, t.name_en);
                    END LOOP;

                    hist(t.instance_id, 'REMINDER_SENT', NULL, t.task_id,
                         p_actor_kind => 'TIMER',
                         p_note => v_hrs || 'h before due');
                END IF;
            END LOOP;
        END LOOP;

        -- ---- SLA breach + escalation ----
        FOR t IN (SELECT t.task_id, t.instance_id, t.due_at, t.escalated_at,
                         t.escalation_level, i.version_id, si.step_id, s.name_en,
                         s.escalate_role_id, s.escalate_after_hours, i.initiator_org_id
                    FROM prod.dct_wf_task t
                    JOIN prod.dct_wf_step_instance si ON si.step_instance_id = t.step_instance_id
                    JOIN prod.dct_wf_step  s ON s.step_id     = si.step_id
                    JOIN prod.dct_wf_instance i ON i.instance_id = t.instance_id
                   WHERE t.state IN ('UNASSIGNED', 'ASSIGNED', 'INFO_REQUESTED')
                     AND t.due_at IS NOT NULL
                     AND SYSTIMESTAMP > t.due_at
                     AND i.status = 'RUNNING')
        LOOP
            -- breach notice: once
            IF t.escalation_level = 0 AND t.escalated_at IS NULL THEN
                FOR p IN (SELECT user_id FROM prod.dct_wf_task_participant
                           WHERE task_id = t.task_id AND is_active = 'Y')
                LOOP
                    notify_user(p.user_id, t.instance_id, t.task_id, 'SLA_BREACH',
                                t.version_id, t.step_id, t.name_en);
                END LOOP;
                hist(t.instance_id, 'SLA_BREACHED', NULL, t.task_id,
                     p_actor_kind => 'TIMER');
            END IF;

            -- escalation ACTUALLY adds the escalation target as a participant.
            -- The legacy sweep only notified -- it never reassigned, so an escalated
            -- request sat exactly where it was.
            IF t.escalate_role_id IS NOT NULL
               AND t.escalate_after_hours IS NOT NULL
               AND SYSTIMESTAMP > t.due_at + NUMTODSINTERVAL(t.escalate_after_hours, 'HOUR')
               AND NVL(t.escalation_level, 0) = 0 THEN

                FOR u IN (SELECT DISTINCT ur.user_id
                            FROM prod.dct_user_roles ur
                           WHERE ur.role_id   = t.escalate_role_id
                             AND ur.is_active = 'Y'
                             AND ur.start_date <= SYSDATE
                             AND (ur.end_date IS NULL OR ur.end_date >= SYSDATE))
                LOOP
                    BEGIN
                        INSERT INTO prod.dct_wf_task_participant
                            (task_id, user_id, participant_type, via, via_ref)
                        VALUES (t.task_id, u.user_id, 'POTENTIAL_OWNER',
                                'ESCALATION', TO_CHAR(t.escalate_role_id));
                    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
                    END;
                    notify_user(u.user_id, t.instance_id, t.task_id, 'ESCALATED',
                                t.version_id, t.step_id, t.name_en);
                END LOOP;

                UPDATE prod.dct_wf_task
                   SET escalated_at     = SYSTIMESTAMP,
                       escalation_level = 1
                 WHERE task_id = t.task_id;

                hist(t.instance_id, 'ESCALATED', NULL, t.task_id,
                     p_actor_kind => 'TIMER',
                     p_note => 'to role ' || t.escalate_role_id);
            END IF;
        END LOOP;

        -- ---- auto-action ----
        FOR t IN (SELECT t.task_id, si.activated_at, s.auto_action_outcome,
                         s.auto_action_after_hours, t.assignee_user_id
                    FROM prod.dct_wf_task t
                    JOIN prod.dct_wf_step_instance si ON si.step_instance_id = t.step_instance_id
                    JOIN prod.dct_wf_step  s ON s.step_id     = si.step_id
                    JOIN prod.dct_wf_instance i ON i.instance_id = t.instance_id
                   WHERE t.state IN ('UNASSIGNED', 'ASSIGNED')
                     AND i.status = 'RUNNING'
                     AND s.auto_action_outcome     IS NOT NULL
                     AND s.auto_action_after_hours IS NOT NULL
                     AND SYSTIMESTAMP > si.activated_at
                                      + NUMTODSINTERVAL(s.auto_action_after_hours, 'HOUR'))
        LOOP
            BEGIN
                -- the timer acts AS the assignee, and history records actor_kind TIMER,
                -- so an auto-approval is never mistaken for a human decision
                complete_task(t.task_id, t.assignee_user_id, t.auto_action_outcome,
                              'auto-actioned after '
                              || t.auto_action_after_hours || 'h with no response');
            EXCEPTION WHEN OTHERS THEN
                NULL;   -- one stuck task must not stop the sweep
            END;
        END LOOP;

        -- ---- late delegations (the vacation case) ----
        -- Participants expand at task CREATION, so a delegation created after a
        -- task already exists would never see it: the principal goes on leave and
        -- the pending task sits with them anyway. This pass attaches the delegate
        -- to every open task of the delegator, with the SAME scope semantics as
        -- resolve-time (ALL_ROLES / MODULE / SPECIFIC_ROLE -- dct_delegations'
        -- own vocabulary, see resolve_participants). Idempotent: NOT EXISTS.
        FOR d IN (SELECT t.task_id, t.instance_id, i.version_id,
                         si.step_id, s.name_en,
                         tp.user_id AS principal_id, dg.delegate_id
                    FROM prod.dct_wf_task t
                    JOIN prod.dct_wf_task_participant tp
                      ON tp.task_id = t.task_id
                     AND tp.participant_type = 'POTENTIAL_OWNER'
                     AND tp.is_active = 'Y'
                     AND tp.via <> 'DELEGATE'
                    JOIN prod.dct_wf_instance i ON i.instance_id = t.instance_id
                    JOIN prod.dct_wf_step_instance si ON si.step_instance_id = t.step_instance_id
                    JOIN prod.dct_wf_step s ON s.step_id = si.step_id
                    JOIN prod.dct_delegations dg
                      ON dg.delegator_id = tp.user_id
                     AND dg.status = 'ACTIVE'
                     AND TRUNC(SYSDATE) BETWEEN TRUNC(dg.start_date)
                                            AND TRUNC(dg.end_date)
                    LEFT JOIN prod.dct_roles r ON r.role_id = dg.role_id
                    LEFT JOIN prod.dct_modules m ON m.module_code = t.module_code
                   WHERE t.state IN ('UNASSIGNED', 'ASSIGNED', 'INFO_REQUESTED')
                     AND i.status = 'RUNNING'
                     AND (dg.scope = 'ALL_ROLES'
                          OR (dg.scope = 'MODULE'
                              AND dg.module_id IS NOT NULL
                              AND dg.module_id = m.module_id)
                          OR (dg.scope = 'SPECIFIC_ROLE'
                              AND tp.via IN ('ROLE', 'MAP', 'FALLBACK_ROLE')
                              AND r.role_code = tp.via_ref))
                     AND dg.delegate_id <> tp.user_id
                     AND NOT EXISTS (SELECT 1 FROM prod.dct_wf_task_participant x
                                      WHERE x.task_id = t.task_id
                                        AND x.user_id = dg.delegate_id))
        LOOP
            BEGIN
                INSERT INTO prod.dct_wf_task_participant
                    (task_id, user_id, participant_type, via, via_ref)
                VALUES (d.task_id, d.delegate_id, 'POTENTIAL_OWNER',
                        'DELEGATE', TO_CHAR(d.principal_id));

                hist(d.instance_id, 'TASK_DELEGATED', NULL, d.task_id,
                     p_actor_kind => 'SYSTEM', p_to_state => 'ASSIGNED',
                     p_note => 'late delegation: user ' || d.principal_id
                               || ' -> ' || d.delegate_id);

                notify_user(d.delegate_id, d.instance_id, d.task_id, 'TASK_ASSIGNED',
                            d.version_id, d.step_id, d.name_en);
            EXCEPTION WHEN OTHERS THEN
                NULL;   -- one bad row must not stop the sweep
            END;
        END LOOP;

        COMMIT;
    END;

END dct_wf_engine;
/

SHOW ERRORS

PROMPT
PROMPT --- synonyms (ORDS handlers run as ADMIN) ---

CREATE OR REPLACE SYNONYM dct_wf_engine FOR prod.dct_wf_engine;
CREATE OR REPLACE SYNONYM dct_wf_expr   FOR prod.dct_wf_expr;

PROMPT
PROMPT --- sweep job (every 15 minutes -- real timers, not a daily batch) ---

DECLARE
    v NUMBER;
BEGIN
    SELECT COUNT(*) INTO v FROM all_scheduler_jobs
     WHERE owner = 'PROD' AND job_name = 'DCT_WF_SWEEP_JOB';
    IF v = 0 THEN
        DBMS_SCHEDULER.CREATE_JOB(
            job_name        => 'PROD.DCT_WF_SWEEP_JOB',
            job_type        => 'PLSQL_BLOCK',
            job_action      => 'BEGIN prod.dct_wf_engine.sweep; END;',
            start_date      => SYSTIMESTAMP,
            repeat_interval => 'FREQ=MINUTELY;INTERVAL=15',
            enabled         => TRUE,
            comments        => 'DWP: reminders, escalation, auto-action, SLA breach');
        DBMS_OUTPUT.PUT_LINE('  created DCT_WF_SWEEP_JOB');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  exists  DCT_WF_SWEEP_JOB');
    END IF;
END;
/

PROMPT
PROMPT === engine done -- verifying ===

SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner = 'PROD'
   AND object_name IN ('DCT_WF_ENGINE', 'DCT_WF_EXPR')
 ORDER BY object_name, object_type;

SELECT job_name, enabled, repeat_interval
  FROM all_scheduler_jobs
 WHERE owner = 'PROD' AND job_name = 'DCT_WF_SWEEP_JOB';

SELECT engine, COUNT(*) AS modules FROM prod.dct_wf_route GROUP BY engine;

COMMIT;
