-- =============================================================================
-- PAY (App 215) -- Workflow Platform process seed for the change register
-- File    : 22_pay_chg_wf.sql
-- Run     : sql -name prod_mcp @22_pay_chg_wf.sql   (after 21; DWP 60-63 live)
-- Process : PAY_CHG_APPROVAL on source_module PAY
--             step 10 HR_SIGNOFF   -- role PAY_HR_ENTRY (fallback: business
--                                     admin, so the chain never hangs)
--             step 20 PAY_SIGNOFF  -- role PAY_PAYROLL_ENTRY, final gate
--           Outcomes APPROVE / RETURN / REJECT (shared APPROVE_REJECT_RETURN).
--           Hooks: ON_COMPLETE -> DCT_PAY_CHG_PKG.WF_ON_COMPLETE (CONFIRMED),
--                  ON_REJECT + ON_RETURN -> DCT_PAY_CHG_PKG.WF_ON_REJECT (OPEN).
--           Route row PAY -> WF (PAY has no legacy approvals).
-- Safe    : re-runnable. The definition is rebuilt ONLY while no workflow
--           instance references it; after that change it in the Designer.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE VIEW prod.dct_pay_chg_wf_fact_v AS
SELECT r.register_id,
       p.payroll_code,
       p.name_en AS payroll_name,
       pe.period_code,
       r.emp_count,
       r.change_count,
       (SELECT COUNT(*) FROM prod.dct_pay_chg_item i
        WHERE i.register_id = r.register_id AND i.change_kind = 'NEW_HIRE') AS new_hires,
       (SELECT COUNT(*) FROM prod.dct_pay_chg_item i
        WHERE i.register_id = r.register_id AND i.change_kind = 'EXIT') AS exits,
       (SELECT NVL(SUM(CASE WHEN i.attr_code IN ('GROSS','EMPLOYEE') THEN i.delta END), 0)
        FROM prod.dct_pay_chg_item i
        WHERE i.register_id = r.register_id) AS gross_impact,
       (SELECT COUNT(*) FROM prod.dct_pay_chg_item i
        WHERE i.register_id = r.register_id AND i.flags IS NOT NULL) AS flagged
FROM prod.dct_pay_chg_register r
JOIN prod.dct_pay_payroll p ON p.payroll_id = r.payroll_id
JOIN prod.dct_pay_period pe ON pe.period_id = r.period_id;

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
    SELECT module_id INTO v_mod FROM prod.dct_modules WHERE module_code = 'PAY';

    BEGIN
        SELECT process_id INTO v_pid FROM prod.dct_wf_process WHERE process_code = 'PAY_CHG_APPROVAL';
        SELECT COUNT(*) INTO v_inst FROM prod.dct_wf_instance i
          JOIN prod.dct_wf_process_version pv ON pv.version_id = i.version_id
         WHERE pv.process_id = v_pid;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_pid := NULL;
    END;

    IF v_pid IS NOT NULL AND v_inst > 0 THEN
        DBMS_OUTPUT.PUT_LINE('PAY_CHG_APPROVAL already has ' || v_inst ||
                             ' instance(s) -- definition left untouched.');
    ELSE
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
            (SELECT schema_id FROM prod.dct_wf_fact_schema WHERE schema_code = 'PAY_CHG_SCH');
        DELETE FROM prod.dct_wf_fact_schema WHERE schema_code = 'PAY_CHG_SCH';

        SELECT set_id INTO v_o_arr FROM prod.dct_wf_outcome_set WHERE set_code = 'APPROVE_REJECT_RETURN';

        INSERT INTO prod.dct_wf_fact_schema (schema_code, name_en, name_ar, source_view, source_key_column)
        VALUES ('PAY_CHG_SCH', 'Employee change register facts',
                UNISTR('\062D\0642\0627\0626\0642 \0633\062C\0644 \062A\063A\064A\064A\0631\0627\062A \0627\0644\0645\0648\0638\0641\064A\0646'),
                'DCT_PAY_CHG_WF_FACT_V', 'REGISTER_ID')
        RETURNING schema_id INTO v_sch;

        INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'payroll', 'Payroll', 'STRING', 'PAYROLL_CODE');
        INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'period', 'Period', 'STRING', 'PERIOD_CODE');
        INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'emp_count', 'Employees in scope', 'NUMBER', 'EMP_COUNT');
        INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'change_count', 'Changes', 'NUMBER', 'CHANGE_COUNT');
        INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'new_hires', 'New hires', 'NUMBER', 'NEW_HIRES');
        INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'exits', 'Exits', 'NUMBER', 'EXITS');
        INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'gross_impact', 'Gross impact (AED/month)', 'NUMBER', 'GROSS_IMPACT');
        INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (v_sch, 'flagged', 'Flagged changes', 'NUMBER', 'FLAGGED');

        INSERT INTO prod.dct_wf_process
               (process_code, source_module, name_en, name_ar, schema_id,
                requires_final_callback, default_sla_hours, is_active)
        VALUES ('PAY_CHG_APPROVAL', 'PAY',
                'Employee Change Register Sign-off',
                UNISTR('\0627\0639\062A\0645\0627\062F \0633\062C\0644 \062A\063A\064A\064A\0631\0627\062A \0627\0644\0645\0648\0638\0641\064A\0646'),
                v_sch, 'Y', 48, 'Y')
        RETURNING process_id INTO v_pid;

        INSERT INTO prod.dct_wf_process_version (process_id, version_no, status)
        VALUES (v_pid, 1, 'PUBLISHED') RETURNING version_id INTO v_ver;

        INSERT INTO prod.dct_wf_step
               (version_id, step_key, step_seq, name_en, name_ar, outcome_set_id, sla_hours, is_final_gate)
        VALUES (v_ver, 'HR_SIGNOFF', 10, 'HR sign-off',
                UNISTR('\0627\0639\062A\0645\0627\062F \0627\0644\0645\0648\0627\0631\062F \0627\0644\0628\0634\0631\064A\0629'),
                v_o_arr, 48, 'N')
        RETURNING step_id INTO v_s;
        INSERT INTO prod.dct_wf_participant_rule
               (step_id, resolver_type, role_code, fallback_rule)
        VALUES (v_s, 'ROLE', 'PAY_HR_ENTRY', 'BUSINESS_ADMIN');

        INSERT INTO prod.dct_wf_step
               (version_id, step_key, step_seq, name_en, name_ar, outcome_set_id, sla_hours, is_final_gate)
        VALUES (v_ver, 'PAY_SIGNOFF', 20, 'Payroll sign-off',
                UNISTR('\0627\0639\062A\0645\0627\062F \0641\0631\064A\0642 \0627\0644\0631\0648\0627\062A\0628'),
                v_o_arr, 48, 'Y')
        RETURNING step_id INTO v_s;
        INSERT INTO prod.dct_wf_participant_rule
               (step_id, resolver_type, role_code, fallback_rule)
        VALUES (v_s, 'ROLE', 'PAY_PAYROLL_ENTRY', 'BUSINESS_ADMIN');

        DBMS_OUTPUT.PUT_LINE('PAY_CHG_APPROVAL v1 PUBLISHED (2 steps)');
    END IF;

    up_action('PAY_CHG_WF_COMPLETE', 'DCT_PAY_CHG_PKG.WF_ON_COMPLETE',
              'Marks the change register CONFIRMED when both sign-off steps approve.', v_act_c);
    up_action('PAY_CHG_WF_REJECT', 'DCT_PAY_CHG_PKG.WF_ON_REJECT',
              'Reopens the change register on reject or return-to-initiator.', v_act_r);

    SELECT pv.version_id INTO v_ver
      FROM prod.dct_wf_process_version pv
      JOIN prod.dct_wf_process p ON p.process_id = pv.process_id
     WHERE p.process_code = 'PAY_CHG_APPROVAL' AND pv.status = 'PUBLISHED';

    up_hook(v_ver, 'ON_COMPLETE', v_act_c, 10);
    up_hook(v_ver, 'ON_REJECT',   v_act_r, 10);
    up_hook(v_ver, 'ON_RETURN',   v_act_r, 20);

    UPDATE prod.dct_wf_route
       SET engine = 'WF', effective_from = SYSDATE, changed_by = 'SEED'
     WHERE source_module = 'PAY';
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO prod.dct_wf_route (source_module, engine, effective_from, changed_by)
        VALUES ('PAY', 'WF', SYSDATE, 'SEED');
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('PAY workflow seed complete: hooks wired, route PAY -> WF');
END;
/

PROMPT === 22_pay_chg_wf.sql complete ===
EXIT
