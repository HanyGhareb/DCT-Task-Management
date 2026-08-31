-- =============================================================================
-- Finance KPI Management Module (App 213) -- Workflow Platform process seed
-- File    : 05_kpi_wf_seed.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @05_kpi_wf_seed.sql   (after 04; DWP 60-63 live)
-- Process : KPI_RESULT_APPROVAL on source_module KPI_MGMT
--             step 10 SECTION_HEAD  -- initiator's line manager
--                     (fallback: any KPI_ADMIN holder)
--             step 20 FIN_DIRECTOR  -- role KPI_FIN_DIRECTOR, final gate
--                     (fallback: business admin, so the chain never hangs
--                      before the role is assigned)
--           Outcomes APPROVE / RETURN / REJECT (shared APPROVE_REJECT_RETURN).
--           Hooks: ON_COMPLETE -> DCT_KPI_PKG.WF_ON_COMPLETE (APPROVED),
--                  ON_REJECT + ON_RETURN -> DCT_KPI_PKG.WF_ON_REJECT (RETURNED).
--           Route row KPI_MGMT -> WF (new module, no legacy engine).
-- Safe    : re-runnable. The process definition is rebuilt ONLY while no
--           workflow instance references it; once instances exist the
--           definition is left untouched (change it in the Designer).
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

DECLARE
    v_sch   NUMBER;
    v_pid   NUMBER;
    v_ver   NUMBER;
    v_o_arr NUMBER;
    v_s     NUMBER;
    v_mod   NUMBER;
    v_act_c NUMBER;
    v_act_r NUMBER;
    v_inst  NUMBER := 0;

    PROCEDURE up_action (p_code VARCHAR2, p_call VARCHAR2, p_desc VARCHAR2, o_id OUT NUMBER) IS
    BEGIN
        UPDATE prod.dct_wf_action_registry
           SET plsql_call = p_call, description = p_desc, is_active = 'Y'
         WHERE action_code = p_code;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_wf_action_registry
                   (action_code, module_id, plsql_call, signature_kind, description, is_active, registered_by, registered_at)
            VALUES (p_code, v_mod, p_call, 'CTX', p_desc, 'Y', 'SEED', SYSTIMESTAMP);
        END IF;
        SELECT action_id INTO o_id FROM prod.dct_wf_action_registry WHERE action_code = p_code;
    END;

    PROCEDURE up_hook (p_ver NUMBER, p_event VARCHAR2, p_action NUMBER, p_ord NUMBER) IS
        v_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_n FROM prod.dct_wf_process_hook
         WHERE version_id = p_ver AND event_code = p_event AND action_id = p_action;
        IF v_n = 0 THEN
            INSERT INTO prod.dct_wf_process_hook
                   (version_id, step_id, event_code, action_id, exec_order, on_error, is_active)
            VALUES (p_ver, NULL, p_event, p_action, p_ord, 'FAIL', 'Y');
        END IF;
    END;
BEGIN
    SELECT module_id INTO v_mod FROM prod.dct_modules WHERE module_code = 'KPI_MGMT';

    -- ------------------------------------------------------------------ guard
    BEGIN
        SELECT process_id INTO v_pid FROM prod.dct_wf_process WHERE process_code = 'KPI_RESULT_APPROVAL';
        SELECT COUNT(*) INTO v_inst FROM prod.dct_wf_instance i
          JOIN prod.dct_wf_process_version pv ON pv.version_id = i.version_id
         WHERE pv.process_id = v_pid;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_pid := NULL;
    END;

    IF v_pid IS NOT NULL AND v_inst > 0 THEN
        DBMS_OUTPUT.PUT_LINE('KPI_RESULT_APPROVAL already has ' || v_inst ||
                             ' instance(s) -- definition left untouched.');
    ELSE
        -- ------------------------------------------------- rebuild definition
        IF v_pid IS NOT NULL THEN
            DELETE FROM prod.dct_wf_process_hook WHERE version_id IN
                (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id = v_pid);
            DELETE FROM prod.dct_wf_participant_rule WHERE step_id IN
                (SELECT step_id FROM prod.dct_wf_step WHERE version_id IN
                    (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id = v_pid));
            DELETE FROM prod.dct_wf_step WHERE version_id IN
                (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id = v_pid);
            DELETE FROM prod.dct_wf_condition WHERE version_id IN
                (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id = v_pid);
            DELETE FROM prod.dct_wf_process_version WHERE process_id = v_pid;
            DELETE FROM prod.dct_wf_process WHERE process_id = v_pid;
        END IF;
        DELETE FROM prod.dct_wf_fact_field WHERE schema_id IN
            (SELECT schema_id FROM prod.dct_wf_fact_schema WHERE schema_code = 'KPI_RES_SCH');
        DELETE FROM prod.dct_wf_fact_schema WHERE schema_code = 'KPI_RES_SCH';

        SELECT set_id INTO v_o_arr FROM prod.dct_wf_outcome_set WHERE set_code = 'APPROVE_REJECT_RETURN';

        INSERT INTO prod.dct_wf_fact_schema (schema_code, name_en, name_ar, source_view, source_key_column)
        VALUES ('KPI_RES_SCH', 'KPI result facts', 'حقائق نتيجة المؤشر', 'DCT_KPI_WF_FACT_V', 'RESULT_ID')
        RETURNING schema_id INTO v_sch;

        INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'kpi_code', 'KPI code', 'STRING', 'KPI_CODE');
        INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'kpi_name', 'KPI name', 'STRING', 'KPI_NAME');
        INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'score', 'Score (1-5)', 'NUMBER', 'SCORE');
        INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'result_pct', 'Result percentage', 'NUMBER', 'RESULT_PCT');
        INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'period_type', 'Period type', 'STRING', 'PERIOD_TYPE');
        INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'period_label', 'Period', 'STRING', 'PERIOD_LABEL');

        INSERT INTO prod.dct_wf_process
               (process_code, source_module, name_en, name_ar, schema_id,
                requires_final_callback, default_sla_hours, is_active)
        VALUES ('KPI_RESULT_APPROVAL', 'KPI_MGMT',
                'KPI Result Approval', 'اعتماد نتائج مؤشرات الأداء',
                v_sch, 'Y', 72, 'Y')
        RETURNING process_id INTO v_pid;

        INSERT INTO prod.dct_wf_process_version (process_id, version_no, status)
        VALUES (v_pid, 1, 'PUBLISHED') RETURNING version_id INTO v_ver;

        INSERT INTO prod.dct_wf_step
               (version_id, step_key, step_seq, name_en, name_ar, outcome_set_id, sla_hours, is_final_gate)
        VALUES (v_ver, 'SECTION_HEAD', 10, 'Section Head review', 'مراجعة رئيس القسم', v_o_arr, 72, 'N')
        RETURNING step_id INTO v_s;
        INSERT INTO prod.dct_wf_participant_rule
               (step_id, resolver_type, role_code, fallback_rule)
        VALUES (v_s, 'LINE_MANAGER', 'KPI_ADMIN', 'ANY_ROLE_HOLDER');

        INSERT INTO prod.dct_wf_step
               (version_id, step_key, step_seq, name_en, name_ar, outcome_set_id, sla_hours, is_final_gate)
        VALUES (v_ver, 'FIN_DIRECTOR', 20, 'Finance Director approval', 'اعتماد مدير المالية', v_o_arr, 72, 'Y')
        RETURNING step_id INTO v_s;
        INSERT INTO prod.dct_wf_participant_rule
               (step_id, resolver_type, role_code, fallback_rule)
        VALUES (v_s, 'ROLE', 'KPI_FIN_DIRECTOR', 'BUSINESS_ADMIN');

        DBMS_OUTPUT.PUT_LINE('KPI_RESULT_APPROVAL v1 PUBLISHED (2 steps)');
    END IF;

    -- ---------------------------------------------- action registry + hooks
    up_action('KPI_WF_COMPLETE', 'DCT_KPI_PKG.WF_ON_COMPLETE',
              'Marks the KPI result APPROVED when the approval chain completes.', v_act_c);
    up_action('KPI_WF_REJECT', 'DCT_KPI_PKG.WF_ON_REJECT',
              'Marks the KPI result RETURNED on reject or return-to-initiator.', v_act_r);

    SELECT pv.version_id INTO v_ver
      FROM prod.dct_wf_process_version pv
      JOIN prod.dct_wf_process p ON p.process_id = pv.process_id
     WHERE p.process_code = 'KPI_RESULT_APPROVAL' AND pv.status = 'PUBLISHED';

    up_hook(v_ver, 'ON_COMPLETE', v_act_c, 10);
    up_hook(v_ver, 'ON_REJECT',   v_act_r, 10);
    up_hook(v_ver, 'ON_RETURN',   v_act_r, 20);

    -- ------------------------------------------------------------- routing
    UPDATE prod.dct_wf_route
       SET engine = 'WF', effective_from = SYSDATE, changed_by = 'SEED'
     WHERE source_module = 'KPI_MGMT';
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO prod.dct_wf_route (source_module, engine, effective_from, changed_by)
        VALUES ('KPI_MGMT', 'WF', SYSDATE, 'SEED');
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('KPI workflow seed complete: hooks wired, route KPI_MGMT -> WF');
END;
/

PROMPT === 05_kpi_wf_seed.sql complete ===
