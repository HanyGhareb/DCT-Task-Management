SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- 60_dct_wf_ddl.sql
-- i-Finance Workflow Platform (DWP) -- Phase 0 -- metadata + runtime structures
-- Schema  : PROD (run as ADMIN with schema-qualified names)
-- Plan    : ~/.claude/plans/design-new-workflow-solution-woolly-sun.md
--
-- ENGINE  : NATIVE ONLY. Oracle APEX Workflow / Human Task are NOT used.
--           Spike finding 2026-07-14: every APEX outcome column is VARCHAR2(8)
--           with a check limiting it to APPROVED or REJECTED -- so APEX cannot
--           represent ENDORSE / AGREE / DISAGREE / RETURN_FOR_INFO / FYI.
--           Custom outcomes therefore live in dct_wf_outcome (ours), and there
--           is no apex_task_id / apex_workflow_id column anywhere by design.
--
-- PRIVILEGE NOTE (learned the hard way on this script):
--   The helper that issues the dynamic DDL must be a LOCAL procedure inside an
--   anonymous block, exactly as final apps/FL/db/25 does it. A *stored* helper
--   owned by PROD fails either way:
--     definer's rights -> ORA-01031 (roles are disabled in definer's-rights
--                         PL/SQL, so PROD has no directly-granted CREATE)
--     invoker's rights -> ORA-06598 (PROD lacks INHERIT PRIVILEGES on ADMIN)
--   An anonymous block simply runs as the caller (ADMIN) and works.
--
-- Idempotent -- guards use all_tables / all_tab_columns / all_indexes owner=PROD.
-- Additive  -- touches no existing table except the nullable wf_instance_id
--              column added to the 13 legacy source tables at the end.
-- =============================================================================

PROMPT === i-Finance Workflow Platform -- structures ===

PROMPT
PROMPT --- [1/5] definition layer, part A ---

DECLARE
    PROCEDURE mk (p_name IN VARCHAR2, p_ddl IN CLOB) IS
        v_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_n FROM all_tables
         WHERE owner = 'PROD' AND table_name = UPPER(p_name);
        IF v_n = 0 THEN
            EXECUTE IMMEDIATE p_ddl;
            DBMS_OUTPUT.PUT_LINE('  built  ' || LOWER(p_name));
        ELSE
            DBMS_OUTPUT.PUT_LINE('  exists ' || LOWER(p_name));
        END IF;
    END;
BEGIN

mk('DCT_WF_FACT_SCHEMA', q'[
CREATE TABLE prod.dct_wf_fact_schema (
    schema_id         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    schema_code       VARCHAR2(60)  NOT NULL UNIQUE,
    name_en           VARCHAR2(200) NOT NULL,
    name_ar           VARCHAR2(200),
    source_view       VARCHAR2(128) NOT NULL,
    source_key_column VARCHAR2(30)  NOT NULL,
    is_active         VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    created_by        VARCHAR2(100),
    created_at        TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT chk_wf_fs_act CHECK (is_active IN ('Y','N'))
)]');

mk('DCT_WF_FACT_FIELD', q'[
CREATE TABLE prod.dct_wf_fact_field (
    field_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    schema_id     NUMBER NOT NULL REFERENCES prod.dct_wf_fact_schema(schema_id),
    field_key     VARCHAR2(40)  NOT NULL,
    label_en      VARCHAR2(200) NOT NULL,
    label_ar      VARCHAR2(200),
    data_type     VARCHAR2(10)  NOT NULL,
    source_column VARCHAR2(128) NOT NULL,
    lov_category  VARCHAR2(60),
    display_order NUMBER DEFAULT 10,
    CONSTRAINT uq_wf_ff UNIQUE (schema_id, field_key),
    CONSTRAINT chk_wf_ff_dt CHECK (data_type IN ('NUMBER','STRING','DATE','BOOLEAN','LIST'))
)]');

mk('DCT_WF_PROCESS', q'[
CREATE TABLE prod.dct_wf_process (
    process_id              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    process_code            VARCHAR2(60) NOT NULL UNIQUE,
    module_id               NUMBER REFERENCES prod.dct_modules(module_id),
    source_module           VARCHAR2(40) NOT NULL,
    request_type_csv        VARCHAR2(400),
    name_en                 VARCHAR2(200) NOT NULL,
    name_ar                 VARCHAR2(200),
    description_en          VARCHAR2(1000),
    description_ar          VARCHAR2(1000),
    schema_id               NUMBER REFERENCES prod.dct_wf_fact_schema(schema_id),
    owner_role_id           NUMBER REFERENCES prod.dct_roles(role_id),
    requires_final_callback VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    default_sla_hours       NUMBER DEFAULT 72,
    is_active               VARCHAR2(1) DEFAULT 'N' NOT NULL,
    created_by              VARCHAR2(100),
    created_at              TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_by              VARCHAR2(100),
    updated_at              TIMESTAMP,
    CONSTRAINT chk_wf_p_act CHECK (is_active IN ('Y','N')),
    CONSTRAINT chk_wf_p_rfc CHECK (requires_final_callback IN ('Y','N'))
)]');

mk('DCT_WF_PROCESS_VERSION', q'[
CREATE TABLE prod.dct_wf_process_version (
    version_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    process_id      NUMBER NOT NULL REFERENCES prod.dct_wf_process(process_id),
    version_no      NUMBER NOT NULL,
    status          VARCHAR2(12) DEFAULT 'DRAFT' NOT NULL,
    definition_hash VARCHAR2(64),
    effective_from  DATE,
    effective_to    DATE,
    notes           VARCHAR2(1000),
    published_by    VARCHAR2(100),
    published_at    TIMESTAMP,
    retired_at      TIMESTAMP,
    created_by      VARCHAR2(100),
    created_at      TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT uq_wf_pv UNIQUE (process_id, version_no),
    CONSTRAINT chk_wf_pv_st CHECK (status IN ('DRAFT','PUBLISHED','RETIRED'))
)]');

mk('DCT_WF_OUTCOME_SET', q'[
CREATE TABLE prod.dct_wf_outcome_set (
    set_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    set_code  VARCHAR2(40)  NOT NULL UNIQUE,
    name_en   VARCHAR2(200) NOT NULL,
    name_ar   VARCHAR2(200),
    is_system VARCHAR2(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT chk_wf_os_sys CHECK (is_system IN ('Y','N'))
)]');

mk('DCT_WF_OUTCOME', q'[
CREATE TABLE prod.dct_wf_outcome (
    outcome_id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    set_id               NUMBER NOT NULL REFERENCES prod.dct_wf_outcome_set(set_id),
    outcome_code         VARCHAR2(32)  NOT NULL,
    label_en             VARCHAR2(100) NOT NULL,
    label_ar             VARCHAR2(100) NOT NULL,
    semantic             VARCHAR2(20)  NOT NULL,
    target_step_key      VARCHAR2(40),
    counts_toward_quorum VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    is_positive          VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    requires_comment     VARCHAR2(1) DEFAULT 'N' NOT NULL,
    requires_attachment  VARCHAR2(1) DEFAULT 'N' NOT NULL,
    icon                 VARCHAR2(40),
    color                VARCHAR2(20),
    display_order        NUMBER DEFAULT 10,
    CONSTRAINT uq_wf_o UNIQUE (set_id, outcome_code),
    CONSTRAINT chk_wf_o_code CHECK (REGEXP_LIKE(outcome_code,'^[A-Z][A-Z0-9_]*$')),
    CONSTRAINT chk_wf_o_sem  CHECK (semantic IN
        ('ADVANCE','REJECT','RETURN_TO_STEP','RETURN_TO_INITIATOR','HOLD','NOOP','ROUTE')),
    CONSTRAINT chk_wf_o_q   CHECK (counts_toward_quorum IN ('Y','N')),
    CONSTRAINT chk_wf_o_pos CHECK (is_positive IN ('Y','N')),
    CONSTRAINT chk_wf_o_rc  CHECK (requires_comment IN ('Y','N')),
    CONSTRAINT chk_wf_o_ra  CHECK (requires_attachment IN ('Y','N'))
)]');

mk('DCT_WF_CONDITION', q'[
CREATE TABLE prod.dct_wf_condition (
    condition_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    version_id       NUMBER NOT NULL REFERENCES prod.dct_wf_process_version(version_id),
    condition_key    VARCHAR2(40) NOT NULL,
    name_en          VARCHAR2(200),
    name_ar          VARCHAR2(200),
    expr_text        VARCHAR2(2000) NOT NULL,
    expr_ast         CLOB,
    compiler_version VARCHAR2(10),
    compiled_by      VARCHAR2(100),
    compiled_at      TIMESTAMP,
    is_valid         VARCHAR2(1) DEFAULT 'N' NOT NULL,
    compile_error    VARCHAR2(1000),
    CONSTRAINT uq_wf_c UNIQUE (version_id, condition_key),
    CONSTRAINT chk_wf_c_val CHECK (is_valid IN ('Y','N')),
    CONSTRAINT chk_wf_c_ast CHECK (expr_ast IS JSON)
)]');

mk('DCT_WF_STEP', q'[
CREATE TABLE prod.dct_wf_step (
    step_id                 NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    version_id              NUMBER NOT NULL REFERENCES prod.dct_wf_process_version(version_id),
    step_key                VARCHAR2(40)  NOT NULL,
    step_seq                NUMBER        NOT NULL,
    name_en                 VARCHAR2(200) NOT NULL,
    name_ar                 VARCHAR2(200),
    step_kind               VARCHAR2(16) DEFAULT 'HUMAN' NOT NULL,
    stage_key               VARCHAR2(40),
    parallel_group          VARCHAR2(40),
    quorum_type             VARCHAR2(10) DEFAULT 'ALL' NOT NULL,
    quorum_n                NUMBER,
    veto_on_reject          VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    condition_id            NUMBER REFERENCES prod.dct_wf_condition(condition_id),
    outcome_set_id          NUMBER REFERENCES prod.dct_wf_outcome_set(set_id),
    sla_hours               NUMBER,
    sla_calendar            VARCHAR2(20) DEFAULT 'CALENDAR' NOT NULL,
    reminder_offsets        VARCHAR2(200),
    escalate_role_id        NUMBER REFERENCES prod.dct_roles(role_id),
    escalate_after_hours    NUMBER,
    auto_action_outcome     VARCHAR2(32),
    auto_action_after_hours NUMBER,
    allow_claim             VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    allow_delegate          VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    allow_request_info      VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    allow_reassign          VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    allow_attachment        VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    comment_required        VARCHAR2(12) DEFAULT 'ON_NEGATIVE' NOT NULL,
    system_action_code      VARCHAR2(60),
    refresh_facts_before    VARCHAR2(1) DEFAULT 'N' NOT NULL,
    is_final_gate           VARCHAR2(1) DEFAULT 'N' NOT NULL,
    display_order           NUMBER DEFAULT 10,
    CONSTRAINT uq_wf_s_key UNIQUE (version_id, step_key),
    CONSTRAINT uq_wf_s_seq UNIQUE (version_id, step_seq),
    CONSTRAINT chk_wf_s_kind CHECK (step_kind IN ('HUMAN','SYSTEM','NOTIFY')),
    CONSTRAINT chk_wf_s_qt   CHECK (quorum_type IN ('ALL','ANY','N_OF_M','PERCENT')),
    CONSTRAINT chk_wf_s_cal  CHECK (sla_calendar IN ('CALENDAR','BUSINESS')),
    CONSTRAINT chk_wf_s_cr   CHECK (comment_required IN ('NEVER','ALWAYS','ON_NEGATIVE')),
    CONSTRAINT chk_wf_s_veto CHECK (veto_on_reject IN ('Y','N')),
    CONSTRAINT chk_wf_s_fg   CHECK (is_final_gate IN ('Y','N'))
)]');

END;
/

PROMPT
PROMPT --- [2/5] definition layer, part B ---

DECLARE
    PROCEDURE mk (p_name IN VARCHAR2, p_ddl IN CLOB) IS
        v_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_n FROM all_tables
         WHERE owner = 'PROD' AND table_name = UPPER(p_name);
        IF v_n = 0 THEN
            EXECUTE IMMEDIATE p_ddl;
            DBMS_OUTPUT.PUT_LINE('  built  ' || LOWER(p_name));
        ELSE
            DBMS_OUTPUT.PUT_LINE('  exists ' || LOWER(p_name));
        END IF;
    END;
BEGIN

mk('DCT_WF_PARTICIPANT_RULE', q'[
CREATE TABLE prod.dct_wf_participant_rule (
    rule_id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    step_id           NUMBER NOT NULL REFERENCES prod.dct_wf_step(step_id),
    rule_seq          NUMBER DEFAULT 10 NOT NULL,
    participant_type  VARCHAR2(20) DEFAULT 'POTENTIAL_OWNER' NOT NULL,
    resolver_type     VARCHAR2(24) NOT NULL,
    role_code         VARCHAR2(100),
    org_scope         VARCHAR2(20) DEFAULT 'NONE' NOT NULL,
    org_fact_path     VARCHAR2(200),
    static_org_id     NUMBER,
    static_user_id    NUMBER,
    fact_path         VARCHAR2(200),
    ref_step_key      VARCHAR2(40),
    levels_up         NUMBER DEFAULT 0,
    resolution_mode   VARCHAR2(12) DEFAULT 'UNION' NOT NULL,
    fallback_rule     VARCHAR2(20) DEFAULT 'ANY_ROLE_HOLDER' NOT NULL,
    min_resolved      NUMBER DEFAULT 1 NOT NULL,
    include_delegates VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    exclude_initiator VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    CONSTRAINT chk_wf_pr_pt CHECK (participant_type IN
        ('POTENTIAL_OWNER','BUSINESS_ADMIN','INITIATOR','VIEWER')),
    CONSTRAINT chk_wf_pr_rt CHECK (resolver_type IN
        ('ROLE','ROLE_SCOPED_ORG','ORG_HEAD','LINE_MANAGER','FACT_USER',
         'STATIC_USER','PREVIOUS_ACTOR','INITIATOR')),
    CONSTRAINT chk_wf_pr_os CHECK (org_scope IN
        ('NONE','REQUEST_ORG','INITIATOR_ORG','FACT','STATIC')),
    CONSTRAINT chk_wf_pr_fb CHECK (fallback_rule IN
        ('NONE','ANY_ROLE_HOLDER','BUSINESS_ADMIN','ORG_HEAD','FAIL')),
    CONSTRAINT chk_wf_pr_rm CHECK (resolution_mode IN ('UNION','FIRST_MATCH')),
    CONSTRAINT chk_wf_pr_id CHECK (include_delegates IN ('Y','N')),
    CONSTRAINT chk_wf_pr_ei CHECK (exclude_initiator IN ('Y','N'))
)]');

mk('DCT_WF_APPROVER_MAP', q'[
CREATE TABLE prod.dct_wf_approver_map (
    map_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    role_code    VARCHAR2(100) NOT NULL,
    org_id       NUMBER NOT NULL REFERENCES prod.dct_organizations(org_id),
    user_id      NUMBER NOT NULL REFERENCES prod.dct_users(user_id),
    module_id    NUMBER REFERENCES prod.dct_modules(module_id),
    process_code VARCHAR2(60),
    is_active    VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    valid_from   DATE,
    valid_to     DATE,
    notes        VARCHAR2(400),
    created_by   VARCHAR2(100),
    created_at   TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT chk_wf_am_act CHECK (is_active IN ('Y','N'))
)]');

mk('DCT_WF_ACTION_REGISTRY', q'[
CREATE TABLE prod.dct_wf_action_registry (
    action_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    action_code    VARCHAR2(60) NOT NULL UNIQUE,
    module_id      NUMBER REFERENCES prod.dct_modules(module_id),
    plsql_call     VARCHAR2(200) NOT NULL,
    signature_kind VARCHAR2(20) DEFAULT 'CTX' NOT NULL,
    description    VARCHAR2(400),
    is_active      VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    registered_by  VARCHAR2(100),
    registered_at  TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT chk_wf_ar_act  CHECK (is_active IN ('Y','N')),
    CONSTRAINT chk_wf_ar_call CHECK
        (REGEXP_LIKE(plsql_call,'^[A-Z][A-Z0-9_]{0,29}\.[A-Z][A-Z0-9_]{0,29}$'))
)]');

mk('DCT_WF_PROCESS_HOOK', q'[
CREATE TABLE prod.dct_wf_process_hook (
    hook_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    version_id NUMBER NOT NULL REFERENCES prod.dct_wf_process_version(version_id),
    step_id    NUMBER REFERENCES prod.dct_wf_step(step_id),
    event_code VARCHAR2(30) NOT NULL,
    action_id  NUMBER NOT NULL REFERENCES prod.dct_wf_action_registry(action_id),
    exec_order NUMBER DEFAULT 10 NOT NULL,
    on_error   VARCHAR2(10) DEFAULT 'FAIL' NOT NULL,
    is_active  VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    CONSTRAINT chk_wf_ph_evt CHECK (event_code IN
        ('FACTS','ON_SUBMIT','ON_STEP_SATISFIED','ON_COMPLETE',
         'ON_REJECT','ON_RETURN','ON_CANCEL')),
    CONSTRAINT chk_wf_ph_err CHECK (on_error IN ('FAIL','LOG')),
    CONSTRAINT chk_wf_ph_act CHECK (is_active IN ('Y','N'))
)]');

mk('DCT_WF_NOTIFY_TEMPLATE', q'[
CREATE TABLE prod.dct_wf_notify_template (
    template_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    template_code  VARCHAR2(60) NOT NULL UNIQUE,
    scope          VARCHAR2(10) DEFAULT 'GLOBAL' NOT NULL,
    version_id     NUMBER REFERENCES prod.dct_wf_process_version(version_id),
    step_id        NUMBER REFERENCES prod.dct_wf_step(step_id),
    event_code     VARCHAR2(40) NOT NULL,
    channel        VARCHAR2(12) NOT NULL,
    subject_en     VARCHAR2(400) NOT NULL,
    subject_ar     VARCHAR2(400) NOT NULL,
    body_en        CLOB NOT NULL,
    body_ar        CLOB NOT NULL,
    link_template  VARCHAR2(400),
    recipient_rule VARCHAR2(24) NOT NULL,
    is_active      VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    CONSTRAINT chk_wf_nt_scope CHECK (scope IN ('GLOBAL','PROCESS','STEP')),
    CONSTRAINT chk_wf_nt_chan  CHECK (channel IN ('INAPP','EMAIL','PUSH')),
    CONSTRAINT chk_wf_nt_rr    CHECK (recipient_rule IN
        ('STEP_OWNERS','INITIATOR','PREVIOUS_ACTOR','BUSINESS_ADMIN',
         'WATCHERS','ESCALATION_TARGET','FACT_EMAIL')),
    CONSTRAINT chk_wf_nt_act   CHECK (is_active IN ('Y','N'))
)]');

mk('DCT_WF_CALENDAR', q'[
CREATE TABLE prod.dct_wf_calendar (
    calendar_code VARCHAR2(20) PRIMARY KEY,
    name_en       VARCHAR2(100) NOT NULL,
    name_ar       VARCHAR2(100),
    work_days     VARCHAR2(20) DEFAULT 'MON,TUE,WED,THU,FRI' NOT NULL,
    day_start_hr  NUMBER DEFAULT 8,
    day_end_hr    NUMBER DEFAULT 16,
    is_active     VARCHAR2(1) DEFAULT 'Y' NOT NULL
)]');

mk('DCT_WF_HOLIDAY', q'[
CREATE TABLE prod.dct_wf_holiday (
    holiday_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    calendar_code VARCHAR2(20) NOT NULL REFERENCES prod.dct_wf_calendar(calendar_code),
    holiday_date  DATE NOT NULL,
    name_en       VARCHAR2(100),
    name_ar       VARCHAR2(100),
    CONSTRAINT uq_wf_hol UNIQUE (calendar_code, holiday_date)
)]');

mk('DCT_WF_ROUTE', q'[
CREATE TABLE prod.dct_wf_route (
    source_module  VARCHAR2(40) PRIMARY KEY,
    engine         VARCHAR2(10) DEFAULT 'LEGACY' NOT NULL,
    effective_from DATE DEFAULT SYSDATE NOT NULL,
    changed_by     VARCHAR2(100),
    CONSTRAINT chk_wf_rt_eng CHECK (engine IN ('LEGACY','WF'))
)]');

END;
/

PROMPT
PROMPT --- [3/5] runtime layer ---

DECLARE
    PROCEDURE mk (p_name IN VARCHAR2, p_ddl IN CLOB) IS
        v_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_n FROM all_tables
         WHERE owner = 'PROD' AND table_name = UPPER(p_name);
        IF v_n = 0 THEN
            EXECUTE IMMEDIATE p_ddl;
            DBMS_OUTPUT.PUT_LINE('  built  ' || LOWER(p_name));
        ELSE
            DBMS_OUTPUT.PUT_LINE('  exists ' || LOWER(p_name));
        END IF;
    END;
BEGIN

mk('DCT_WF_INSTANCE', q'[
CREATE TABLE prod.dct_wf_instance (
    instance_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    process_id         NUMBER NOT NULL REFERENCES prod.dct_wf_process(process_id),
    version_id         NUMBER NOT NULL REFERENCES prod.dct_wf_process_version(version_id),
    source_module      VARCHAR2(40) NOT NULL,
    source_record_id   NUMBER       NOT NULL,
    source_record_ref  VARCHAR2(200),
    fact_doc           CLOB,
    fact_refreshed_at  TIMESTAMP,
    status             VARCHAR2(20) DEFAULT 'RUNNING' NOT NULL,
    outcome_code       VARCHAR2(32),
    initiator_user_id  NUMBER REFERENCES prod.dct_users(user_id),
    initiator_org_id   NUMBER REFERENCES prod.dct_organizations(org_id),
    current_stage_key  VARCHAR2(40),
    priority           NUMBER DEFAULT 3,
    due_at             TIMESTAMP,
    cycle_count        NUMBER DEFAULT 0 NOT NULL,
    legacy_instance_id NUMBER,
    error_code         VARCHAR2(30),
    error_msg          VARCHAR2(1000),
    started_at         TIMESTAMP DEFAULT SYSTIMESTAMP,
    completed_at       TIMESTAMP,
    last_event_at      TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT chk_wf_i_fd CHECK (fact_doc IS JSON),
    CONSTRAINT chk_wf_i_st CHECK (status IN
        ('DRAFT','RUNNING','WAITING','RETURNED','SUSPENDED',
         'COMPLETED','REJECTED','CANCELLED','FAULTED'))
)]');

mk('DCT_WF_STEP_INSTANCE', q'[
CREATE TABLE prod.dct_wf_step_instance (
    step_instance_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    instance_id      NUMBER NOT NULL REFERENCES prod.dct_wf_instance(instance_id),
    step_id          NUMBER NOT NULL REFERENCES prod.dct_wf_step(step_id),
    step_key         VARCHAR2(40) NOT NULL,
    attempt_no       NUMBER DEFAULT 1 NOT NULL,
    parallel_group   VARCHAR2(40),
    status           VARCHAR2(12) DEFAULT 'PENDING' NOT NULL,
    quorum_type      VARCHAR2(10),
    quorum_required  NUMBER,
    quorum_met       NUMBER DEFAULT 0,
    condition_result VARCHAR2(5),
    condition_trace  CLOB,
    skipped_reason   VARCHAR2(400),
    activated_at     TIMESTAMP,
    due_at           TIMESTAMP,
    satisfied_at     TIMESTAMP,
    CONSTRAINT uq_wf_si UNIQUE (instance_id, step_id, attempt_no),
    CONSTRAINT chk_wf_si_st CHECK (status IN
        ('PENDING','ACTIVE','SATISFIED','SKIPPED','REJECTED','EXPIRED','CANCELLED','FAULTED')),
    CONSTRAINT chk_wf_si_ct CHECK (condition_trace IS JSON)
)]');

mk('DCT_WF_TASK', q'[
CREATE TABLE prod.dct_wf_task (
    task_id           NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 900000000) PRIMARY KEY,
    step_instance_id  NUMBER NOT NULL REFERENCES prod.dct_wf_step_instance(step_instance_id),
    instance_id       NUMBER NOT NULL REFERENCES prod.dct_wf_instance(instance_id),
    assignee_user_id  NUMBER REFERENCES prod.dct_users(user_id),
    state             VARCHAR2(16) DEFAULT 'UNASSIGNED' NOT NULL,
    outcome_code      VARCHAR2(32),
    outcome_at        TIMESTAMP,
    outcome_by        NUMBER REFERENCES prod.dct_users(user_id),
    comments          CLOB,
    claimed_at        TIMESTAMP,
    delegated_from    NUMBER,
    delegated_to      NUMBER,
    due_at            TIMESTAMP,
    priority          NUMBER DEFAULT 3,
    reminders_sent    NUMBER DEFAULT 0,
    last_reminder_at  TIMESTAMP,
    escalated_at      TIMESTAMP,
    escalation_level  NUMBER DEFAULT 0,
    subject_en        VARCHAR2(400),
    subject_ar        VARCHAR2(400),
    source_record_ref VARCHAR2(200),
    amount            NUMBER,
    currency          VARCHAR2(3),
    requester_name    VARCHAR2(200),
    module_code       VARCHAR2(40),
    created_at        TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT chk_wf_t_st CHECK (state IN
        ('UNASSIGNED','ASSIGNED','INFO_REQUESTED','COMPLETED','CANCELLED','EXPIRED','ERRORED'))
)]');

mk('DCT_WF_TASK_PARTICIPANT', q'[
CREATE TABLE prod.dct_wf_task_participant (
    task_id          NUMBER NOT NULL REFERENCES prod.dct_wf_task(task_id),
    user_id          NUMBER NOT NULL REFERENCES prod.dct_users(user_id),
    participant_type VARCHAR2(20) DEFAULT 'POTENTIAL_OWNER' NOT NULL,
    via              VARCHAR2(24),
    via_ref          VARCHAR2(100),
    is_active        VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    CONSTRAINT pk_wf_tp PRIMARY KEY (task_id, user_id, participant_type),
    CONSTRAINT chk_wf_tp_act CHECK (is_active IN ('Y','N'))
)]');

mk('DCT_WF_HISTORY', q'[
CREATE TABLE prod.dct_wf_history (
    history_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    instance_id      NUMBER NOT NULL REFERENCES prod.dct_wf_instance(instance_id),
    step_instance_id NUMBER REFERENCES prod.dct_wf_step_instance(step_instance_id),
    task_id          NUMBER REFERENCES prod.dct_wf_task(task_id),
    event_code       VARCHAR2(30) NOT NULL,
    actor_user_id    NUMBER REFERENCES prod.dct_users(user_id),
    actor_kind       VARCHAR2(10) DEFAULT 'USER' NOT NULL,
    outcome_code     VARCHAR2(32),
    comments         CLOB,
    from_state       VARCHAR2(20),
    to_state         VARCHAR2(20),
    payload          CLOB,
    source_note      VARCHAR2(400),
    event_at         TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT chk_wf_h_ak CHECK (actor_kind IN ('USER','SYSTEM','TIMER','ADMIN')),
    CONSTRAINT chk_wf_h_pl CHECK (payload IS JSON)
)]');

mk('DCT_WF_NOTIFY_LOG', q'[
CREATE TABLE prod.dct_wf_notify_log (
    log_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    instance_id NUMBER REFERENCES prod.dct_wf_instance(instance_id),
    task_id     NUMBER REFERENCES prod.dct_wf_task(task_id),
    template_id NUMBER REFERENCES prod.dct_wf_notify_template(template_id),
    event_code  VARCHAR2(40),
    channel     VARCHAR2(12),
    user_id     NUMBER,
    email       VARCHAR2(200),
    lang        VARCHAR2(2),
    dedupe_key  VARCHAR2(200),
    status      VARCHAR2(12) DEFAULT 'SENT' NOT NULL,
    warn_msg    VARCHAR2(400),
    sent_at     TIMESTAMP DEFAULT SYSTIMESTAMP
)]');

mk('DCT_WF_INFO_REQUEST', q'[
CREATE TABLE prod.dct_wf_info_request (
    req_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    task_id     NUMBER NOT NULL REFERENCES prod.dct_wf_task(task_id),
    instance_id NUMBER NOT NULL REFERENCES prod.dct_wf_instance(instance_id),
    asked_by    NUMBER NOT NULL REFERENCES prod.dct_users(user_id),
    asked_of    NUMBER NOT NULL REFERENCES prod.dct_users(user_id),
    question    VARCHAR2(2000) NOT NULL,
    answer      VARCHAR2(2000),
    status      VARCHAR2(12) DEFAULT 'OPEN' NOT NULL,
    asked_at    TIMESTAMP DEFAULT SYSTIMESTAMP,
    answered_at TIMESTAMP,
    CONSTRAINT chk_wf_ir_st CHECK (status IN ('OPEN','ANSWERED','CANCELLED'))
)]');

mk('DCT_WF_WATCHER', q'[
CREATE TABLE prod.dct_wf_watcher (
    instance_id NUMBER NOT NULL REFERENCES prod.dct_wf_instance(instance_id),
    user_id     NUMBER NOT NULL REFERENCES prod.dct_users(user_id),
    added_at    TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT pk_wf_w PRIMARY KEY (instance_id, user_id)
)]');

END;
/

PROMPT
PROMPT --- [4/5] indexes ---

DECLARE
    PROCEDURE mk_ix (p_name IN VARCHAR2, p_ddl IN VARCHAR2) IS
        v_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_n FROM all_indexes
         WHERE owner = 'PROD' AND index_name = UPPER(p_name);
        IF v_n = 0 THEN
            EXECUTE IMMEDIATE p_ddl;
            DBMS_OUTPUT.PUT_LINE('  built  ' || LOWER(p_name));
        ELSE
            DBMS_OUTPUT.PUT_LINE('  exists ' || LOWER(p_name));
        END IF;
    END;
BEGIN
    -- the unified worklist is ONE index range scan on this
    mk_ix('IX_WF_TP_USER',   'CREATE INDEX prod.ix_wf_tp_user ON prod.dct_wf_task_participant (user_id, is_active)');
    mk_ix('IX_WF_T_ASSIGN',  'CREATE INDEX prod.ix_wf_t_assign ON prod.dct_wf_task (assignee_user_id, state)');
    mk_ix('IX_WF_T_INST',    'CREATE INDEX prod.ix_wf_t_inst ON prod.dct_wf_task (instance_id)');
    mk_ix('IX_WF_T_DUE',     'CREATE INDEX prod.ix_wf_t_due ON prod.dct_wf_task (state, due_at)');
    mk_ix('IX_WF_I_SRC',     'CREATE INDEX prod.ix_wf_i_src ON prod.dct_wf_instance (source_module, source_record_id)');
    mk_ix('IX_WF_I_STATUS',  'CREATE INDEX prod.ix_wf_i_status ON prod.dct_wf_instance (status)');
    mk_ix('IX_WF_SI_INST',   'CREATE INDEX prod.ix_wf_si_inst ON prod.dct_wf_step_instance (instance_id, status)');
    mk_ix('IX_WF_H_INST',    'CREATE INDEX prod.ix_wf_h_inst ON prod.dct_wf_history (instance_id, event_at)');
    mk_ix('IX_WF_AM_LOOKUP', 'CREATE INDEX prod.ix_wf_am_lookup ON prod.dct_wf_approver_map (role_code, org_id, is_active)');
    mk_ix('UX_WF_AM_UNIQ',   'CREATE UNIQUE INDEX prod.ux_wf_am_uniq ON prod.dct_wf_approver_map (role_code, org_id, NVL(module_id,-1), NVL(process_code,''*''))');
    -- at most one PUBLISHED version per process
    mk_ix('UX_WF_PV_PUB',    'CREATE UNIQUE INDEX prod.ux_wf_pv_pub ON prod.dct_wf_process_version (CASE WHEN status = ''PUBLISHED'' THEN process_id END)');
END;
/

PROMPT
PROMPT --- [5/5] wf_instance_id on the legacy source tables (nullable, no FK) ---

DECLARE
    -- the 13 legacy source tables, verified against all_tables 2026-07-14.
    -- NOTE Duty Travel has NO dct_ prefix (dt_requests / dt_settlement).
    TYPE t_tabs IS TABLE OF VARCHAR2(40);
    v_tabs t_tabs := t_tabs(
        'DCT_PETTY_CASH','DCT_PC_REIMBURSEMENTS','DCT_PC_CLEARING',
        'DT_REQUESTS','DT_SETTLEMENT',
        'DCT_CC_REQUESTS','DCT_CC_REPLENISHMENTS',
        'DCT_FL_REGISTRATIONS','DCT_FL_CONTRACTS','DCT_FL_CONTRACT_AMENDMENTS',
        'DCT_FL_PAYMENT_VOUCHERS','DCT_FL_CONTRACT_RENEWALS',
        'DCT_FL_PROFILE_CHANGE_REQUESTS');
    v_t NUMBER;
    v_c NUMBER;
BEGIN
    FOR i IN 1 .. v_tabs.COUNT LOOP
        SELECT COUNT(*) INTO v_t FROM all_tables
         WHERE owner = 'PROD' AND table_name = v_tabs(i);
        IF v_t = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  skip   ' || LOWER(v_tabs(i)) || ' (absent)');
            CONTINUE;
        END IF;
        SELECT COUNT(*) INTO v_c FROM all_tab_columns
         WHERE owner = 'PROD' AND table_name = v_tabs(i)
           AND column_name = 'WF_INSTANCE_ID';
        IF v_c = 0 THEN
            EXECUTE IMMEDIATE 'ALTER TABLE prod.' || v_tabs(i) || ' ADD (wf_instance_id NUMBER)';
            DBMS_OUTPUT.PUT_LINE('  added  ' || LOWER(v_tabs(i)) || '.wf_instance_id');
        ELSE
            DBMS_OUTPUT.PUT_LINE('  exists ' || LOWER(v_tabs(i)) || '.wf_instance_id');
        END IF;
    END LOOP;
END;
/

PROMPT
PROMPT --- [6/6] recompile what the ALTER just invalidated ---

-- Adding a column to a table INVALIDATES every package body that depends on it.
-- Step 5 touches the 13 source tables, so DCT_PC_PKG / DCT_FL_PKG / DCT_CC_PKG /
-- DCT_DT_PKG / DCT_APPROVAL_PKG and friends all go INVALID. Oracle would silently
-- auto-recompile them on first call, so nothing actually breaks -- but leaving a
-- pile of INVALID objects behind masks the next REAL breakage, and someone reading
-- all_objects after this deploy would reasonably conclude we broke production.
-- Recompile them here so the deploy ends at zero INVALID, as it started.

DECLARE
    v_before NUMBER;
    v_after  NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_before FROM all_objects
     WHERE owner = 'PROD' AND status = 'INVALID';

    FOR o IN (SELECT object_name, object_type FROM all_objects
               WHERE owner = 'PROD' AND status = 'INVALID'
               ORDER BY DECODE(object_type, 'VIEW', 1, 2), object_name)
    LOOP
        BEGIN
            IF o.object_type = 'VIEW' THEN
                EXECUTE IMMEDIATE 'ALTER VIEW prod.' || o.object_name || ' COMPILE';
            ELSIF o.object_type = 'PACKAGE BODY' THEN
                EXECUTE IMMEDIATE 'ALTER PACKAGE prod.' || o.object_name || ' COMPILE BODY';
            ELSIF o.object_type = 'PACKAGE' THEN
                EXECUTE IMMEDIATE 'ALTER PACKAGE prod.' || o.object_name || ' COMPILE';
            END IF;
        EXCEPTION WHEN OTHERS THEN
            NULL;   -- an object that was ALREADY broken stays broken and is reported below
        END;
    END LOOP;

    SELECT COUNT(*) INTO v_after FROM all_objects
     WHERE owner = 'PROD' AND status = 'INVALID';

    DBMS_OUTPUT.PUT_LINE('  invalid before ' || v_before || ', after ' || v_after);
    IF v_after > 0 THEN
        DBMS_OUTPUT.PUT_LINE('  WARNING: ' || v_after || ' object(s) will not compile.');
        DBMS_OUTPUT.PUT_LINE('  Those were broken BEFORE this script -- investigate, do not ignore.');
    END IF;
END;
/

PROMPT
PROMPT === structures done -- verifying ===

SELECT COUNT(*) AS wf_tables FROM all_tables
 WHERE owner = 'PROD' AND table_name LIKE 'DCT\_WF\_%' ESCAPE '\';

SELECT COUNT(*) AS wf_indexes FROM all_indexes
 WHERE owner = 'PROD' AND index_name LIKE '%WF\_%' ESCAPE '\';

SELECT table_name FROM all_tables
 WHERE owner = 'PROD' AND table_name LIKE 'DCT\_WF\_%' ESCAPE '\'
 ORDER BY table_name;
