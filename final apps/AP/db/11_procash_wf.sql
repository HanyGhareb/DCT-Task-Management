-- =============================================================================
-- Procash Transactions -- Workflow Platform process seed (App 212 / AP)
-- File    : 11_procash_wf.sql        2026-08-17
-- Run     : sql -name prod_mcp @11_procash_wf.sql   (after 08 and 09; DWP live)
--
-- Process : PROCASH_APPROVAL on source_module AP_PROCASH
--             step 10 LINE_MANAGER  -- the submitter's manager; falls back to
--                                      any PROCASH_ADMIN holder, which is
--                                      load bearing while the employee and
--                                      manager extract is still thin
--             step 20 FIN_DIRECTOR  -- role FIN_DIRECTOR (fallback business
--                                      admin), final gate
--           Outcomes APPROVE / REJECT / RETURN (shared APPROVE_REJECT_RETURN);
--           the action bar renders whatever the step's outcome set carries, so
--           adding an outcome later is a data change and needs no UI edit.
--           Hooks ON_COMPLETE -> DCT_AP_PROCASH_PKG.WF_APPROVED,
--                 ON_REJECT   -> DCT_AP_PROCASH_PKG.WF_REJECTED,
--                 ON_RETURN   -> DCT_AP_PROCASH_PKG.WF_RETURNED.
--
-- The route uses its OWN module code AP_PROCASH, never AP: nothing else in the
-- AP module is bound to the workflow engine, and a rollback stays a one row
-- UPDATE on dct_wf_route.
--
-- NOTHING IS SWITCHED ON HERE. The real on/off is the AP module setting
-- PROCASH_APPROVAL_MODE (ships NONE): while it is NONE no instance is ever
-- started, so this definition simply waits.
--
-- Safe    : re-runnable. The definition is rebuilt ONLY while no workflow
--           instance references it; after that, change it in the Designer.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE VIEW prod.dct_ap_procash_wf_fact_v AS
SELECT p.procash_id,
       p.payment_number,
       p.bank_reference,
       p.business_unit,
       p.currency_code,
       p.amount,
       p.amount_aed,
       NVL(p.payee_name, p.supplier_name) AS payee,
       NVL(p.supplier_number, ' ')        AS supplier_number,
       NVL(p.bank_account, ' ')           AS bank_account,
       (SELECT COUNT(*) FROM prod.dct_ap_procash_line l
         WHERE l.procash_id = p.procash_id) AS line_count,
       (SELECT CASE WHEN COUNT(DISTINCT l.coding_basis) > 1 THEN 'MIXED'
                    ELSE NVL(MAX(l.coding_basis), 'NONE') END
          FROM prod.dct_ap_procash_line l
         WHERE l.procash_id = p.procash_id) AS coding_basis
  FROM prod.dct_ap_procash p;

DECLARE
    v_sch   NUMBER;
    v_pid   NUMBER;
    v_ver   NUMBER;
    v_o_arr NUMBER;
    v_s     NUMBER;
    v_mod   NUMBER;
    v_act_a NUMBER;
    v_act_r NUMBER;
    v_act_t NUMBER;
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

    PROCEDURE fact (p_schema NUMBER, p_key VARCHAR2, p_label VARCHAR2, p_type VARCHAR2, p_col VARCHAR2) IS
    BEGIN
        INSERT INTO prod.dct_wf_fact_field (schema_id, field_key, label_en, data_type, source_column)
        VALUES (p_schema, p_key, p_label, p_type, p_col);
    END;
BEGIN
    SELECT module_id INTO v_mod FROM prod.dct_modules WHERE module_code = 'AP';

    BEGIN
        SELECT process_id INTO v_pid FROM prod.dct_wf_process WHERE process_code = 'PROCASH_APPROVAL';
        SELECT COUNT(*) INTO v_inst FROM prod.dct_wf_instance i
          JOIN prod.dct_wf_process_version pv ON pv.version_id = i.version_id
         WHERE pv.process_id = v_pid;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_pid := NULL;
    END;

    IF v_pid IS NOT NULL AND v_inst > 0 THEN
        DBMS_OUTPUT.PUT_LINE('PROCASH_APPROVAL already has ' || v_inst ||
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
            (SELECT schema_id FROM prod.dct_wf_fact_schema WHERE schema_code = 'PROCASH_SCH');
        DELETE FROM prod.dct_wf_fact_schema WHERE schema_code = 'PROCASH_SCH';

        SELECT set_id INTO v_o_arr FROM prod.dct_wf_outcome_set WHERE set_code = 'APPROVE_REJECT_RETURN';

        INSERT INTO prod.dct_wf_fact_schema (schema_code, name_en, name_ar, source_view, source_key_column)
        VALUES ('PROCASH_SCH', 'Procash transaction facts',
                UNISTR('\062D\0642\0627\0626\0642 \0645\0639\0627\0645\0644\0629 \0627\0644\062F\0641\0639 \0627\0644\0645\0628\0627\0634\0631'),
                'DCT_AP_PROCASH_WF_FACT_V', 'PROCASH_ID')
        RETURNING schema_id INTO v_sch;

        fact(v_sch, 'payment_number', 'Payment number',   'STRING', 'PAYMENT_NUMBER');
        fact(v_sch, 'bank_reference', 'Bank reference',   'STRING', 'BANK_REFERENCE');
        fact(v_sch, 'business_unit',  'Business unit',    'STRING', 'BUSINESS_UNIT');
        fact(v_sch, 'currency',       'Currency',         'STRING', 'CURRENCY_CODE');
        fact(v_sch, 'amount',         'Amount',           'NUMBER', 'AMOUNT');
        fact(v_sch, 'amount_aed',     'Amount (AED)',     'NUMBER', 'AMOUNT_AED');
        fact(v_sch, 'payee',          'Payee',            'STRING', 'PAYEE');
        fact(v_sch, 'bank_account',   'Paying account',   'STRING', 'BANK_ACCOUNT');
        fact(v_sch, 'line_count',     'Detail lines',     'NUMBER', 'LINE_COUNT');
        fact(v_sch, 'coding_basis',   'Coding basis',     'STRING', 'CODING_BASIS');

        INSERT INTO prod.dct_wf_process
               (process_code, source_module, name_en, name_ar, schema_id,
                requires_final_callback, default_sla_hours, is_active)
        VALUES ('PROCASH_APPROVAL', 'AP_PROCASH',
                'Procash Transaction Approval',
                UNISTR('\0627\0639\062A\0645\0627\062F \0645\0639\0627\0645\0644\0629 \0627\0644\062F\0641\0639 \0627\0644\0645\0628\0627\0634\0631'),
                v_sch, 'Y', 48, 'Y')
        RETURNING process_id INTO v_pid;

        INSERT INTO prod.dct_wf_process_version (process_id, version_no, status)
        VALUES (v_pid, 1, 'PUBLISHED') RETURNING version_id INTO v_ver;

        INSERT INTO prod.dct_wf_step
               (version_id, step_key, step_seq, name_en, name_ar, outcome_set_id, sla_hours, is_final_gate)
        VALUES (v_ver, 'LINE_MANAGER', 10, 'Line manager approval',
                UNISTR('\0627\0639\062A\0645\0627\062F \0627\0644\0645\062F\064A\0631 \0627\0644\0645\0628\0627\0634\0631'),
                v_o_arr, 48, 'N')
        RETURNING step_id INTO v_s;
        INSERT INTO prod.dct_wf_participant_rule
               (step_id, resolver_type, role_code, fallback_rule)
        VALUES (v_s, 'LINE_MANAGER', 'PROCASH_ADMIN', 'ANY_ROLE_HOLDER');

        INSERT INTO prod.dct_wf_step
               (version_id, step_key, step_seq, name_en, name_ar, outcome_set_id, sla_hours, is_final_gate)
        VALUES (v_ver, 'FIN_DIRECTOR', 20, 'Finance Director approval',
                UNISTR('\0627\0639\062A\0645\0627\062F \0645\062F\064A\0631 \0627\0644\0645\0627\0644\064A\0629'),
                v_o_arr, 48, 'Y')
        RETURNING step_id INTO v_s;
        INSERT INTO prod.dct_wf_participant_rule
               (step_id, resolver_type, role_code, fallback_rule)
        VALUES (v_s, 'ROLE', 'FIN_DIRECTOR', 'BUSINESS_ADMIN');

        DBMS_OUTPUT.PUT_LINE('PROCASH_APPROVAL v1 PUBLISHED (2 steps)');
    END IF;

    up_action('PROCASH_WF_APPROVED', 'DCT_AP_PROCASH_PKG.WF_APPROVED',
              'Moves the procash transaction to APPROVED when the final gate approves.', v_act_a);
    up_action('PROCASH_WF_REJECTED', 'DCT_AP_PROCASH_PKG.WF_REJECTED',
              'Moves the procash transaction to REJECTED when an approver rejects.', v_act_r);
    up_action('PROCASH_WF_RETURNED', 'DCT_AP_PROCASH_PKG.WF_RETURNED',
              'Returns the procash transaction to DRAFT when an approver asks for more information.', v_act_t);

    SELECT pv.version_id INTO v_ver
      FROM prod.dct_wf_process_version pv
      JOIN prod.dct_wf_process p ON p.process_id = pv.process_id
     WHERE p.process_code = 'PROCASH_APPROVAL' AND pv.status = 'PUBLISHED';

    up_hook(v_ver, 'ON_COMPLETE', v_act_a, 10);
    up_hook(v_ver, 'ON_REJECT',   v_act_r, 10);
    up_hook(v_ver, 'ON_RETURN',   v_act_t, 10);

    UPDATE prod.dct_wf_route
       SET engine = 'WF', effective_from = SYSDATE, changed_by = 'SEED'
     WHERE source_module = 'AP_PROCASH';
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO prod.dct_wf_route (source_module, engine, effective_from, changed_by)
        VALUES ('AP_PROCASH', 'WF', SYSDATE, 'SEED');
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Procash workflow seed complete: hooks wired, route AP_PROCASH -> WF');
    DBMS_OUTPUT.PUT_LINE('Approval stays OFF until the AP setting PROCASH_APPROVAL_MODE is set to WORKFLOW.');
END;
/

PROMPT === verification ===

SELECT p.process_code, p.source_module, pv.version_no, pv.status,
       (SELECT COUNT(*) FROM prod.dct_wf_step s WHERE s.version_id = pv.version_id) AS steps,
       (SELECT COUNT(*) FROM prod.dct_wf_process_hook h WHERE h.version_id = pv.version_id) AS hooks
  FROM prod.dct_wf_process p
  JOIN prod.dct_wf_process_version pv ON pv.process_id = p.process_id
 WHERE p.process_code = 'PROCASH_APPROVAL';

SELECT source_module, engine FROM prod.dct_wf_route WHERE source_module = 'AP_PROCASH';

SELECT object_name, status FROM all_objects
 WHERE owner = 'PROD' AND object_name IN ('DCT_AP_PROCASH_WF_FACT_V', 'DCT_AP_PROCASH_PKG');
