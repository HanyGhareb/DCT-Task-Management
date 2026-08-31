SET DEFINE OFF
SET SQLBLANKLINES ON
-- db/v2/70_dct_wf_demo_seed.sql
-- Idempotent demo process for the Approval Processes designer page.
-- process_code DEMO_APPROVAL is inactive and on source_module DEMO (no route row),
-- so it never touches live approvals. Re-run to reset it to the published baseline.
-- Uses guarded INSERTs (not merge) and UNISTR for every Arabic string.
DECLARE
  v_sch   NUMBER; v_pid  NUMBER; v_ver  NUMBER;
  v_o_ar  NUMBER; v_o_arr NUMBER; v_o_end NUMBER;
  v_c_hi  NUMBER; v_c_lt NUMBER; v_s NUMBER;
  v_ast   CLOB;   v_err  VARCHAR2(1000);
BEGIN
  BEGIN
    SELECT process_id INTO v_pid FROM prod.dct_wf_process WHERE process_code='DEMO_APPROVAL';
    DELETE FROM prod.dct_wf_participant_rule WHERE step_id IN
      (SELECT step_id FROM prod.dct_wf_step WHERE version_id IN
        (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id=v_pid));
    DELETE FROM prod.dct_wf_step WHERE version_id IN
      (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id=v_pid);
    DELETE FROM prod.dct_wf_condition WHERE version_id IN
      (SELECT version_id FROM prod.dct_wf_process_version WHERE process_id=v_pid);
    DELETE FROM prod.dct_wf_process_version WHERE process_id=v_pid;
    DELETE FROM prod.dct_wf_process WHERE process_id=v_pid;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;
  DELETE FROM prod.dct_wf_fact_field  WHERE schema_id IN
    (SELECT schema_id FROM prod.dct_wf_fact_schema WHERE schema_code='DEMO_SCH');
  DELETE FROM prod.dct_wf_fact_schema WHERE schema_code='DEMO_SCH';

  SELECT set_id INTO v_o_ar  FROM prod.dct_wf_outcome_set WHERE set_code='APPROVE_REJECT';
  SELECT set_id INTO v_o_arr FROM prod.dct_wf_outcome_set WHERE set_code='APPROVE_REJECT_RETURN';
  SELECT set_id INTO v_o_end FROM prod.dct_wf_outcome_set WHERE set_code='ENDORSE_SET';

  INSERT INTO prod.dct_wf_fact_schema(schema_code,name_en,name_ar,source_view,source_key_column)
    VALUES('DEMO_SCH','Demo request facts',UNISTR('\062d\0642\0627\0626\0642\0020\0637\0644\0628\0020\062a\062c\0631\064a\0628\064a'),'DUAL','X')
    RETURNING schema_id INTO v_sch;
  INSERT INTO prod.dct_wf_fact_field(schema_id,field_key,label_en,data_type,source_column)
    VALUES(v_sch,'amount','Amount','NUMBER','AMT');
  INSERT INTO prod.dct_wf_fact_field(schema_id,field_key,label_en,data_type,source_column)
    VALUES(v_sch,'contract_months','Contract months','NUMBER','MONTHS');
  INSERT INTO prod.dct_wf_fact_field(schema_id,field_key,label_en,data_type,source_column)
    VALUES(v_sch,'department','Department','STRING','DEPT');

  INSERT INTO prod.dct_wf_process(process_code,source_module,name_en,name_ar,schema_id,requires_final_callback,is_active)
    VALUES('DEMO_APPROVAL','DEMO','Demo Approval Process',UNISTR('\0639\0645\0644\064a\0629\0020\0627\0639\062a\0645\0627\062f\0020\062a\062c\0631\064a\0628\064a\0629'),v_sch,'N','N')
    RETURNING process_id INTO v_pid;
  INSERT INTO prod.dct_wf_process_version(process_id,version_no,status)
    VALUES(v_pid,1,'PUBLISHED') RETURNING version_id INTO v_ver;

  v_ast := prod.dct_wf_expr.compile('amount >= 50000', v_sch, v_err);
  INSERT INTO prod.dct_wf_condition(version_id,condition_key,name_en,name_ar,expr_text,expr_ast,compiler_version,compiled_by,compiled_at,is_valid)
    VALUES(v_ver,'high_value','High value',UNISTR('\0642\064a\0645\0629\0020\0645\0631\062a\0641\0639\0629'),'amount >= 50000',v_ast,'1','SEED',SYSTIMESTAMP,'Y')
    RETURNING condition_id INTO v_c_hi;
  v_ast := prod.dct_wf_expr.compile('contract_months >= 6', v_sch, v_err);
  INSERT INTO prod.dct_wf_condition(version_id,condition_key,name_en,name_ar,expr_text,expr_ast,compiler_version,compiled_by,compiled_at,is_valid)
    VALUES(v_ver,'long_term','Long term',UNISTR('\0645\062f\0629\0020\0637\0648\064a\0644\0629\0020\0627\0644\0623\062c\0644'),'contract_months >= 6',v_ast,'1','SEED',SYSTIMESTAMP,'Y')
    RETURNING condition_id INTO v_c_lt;

  INSERT INTO prod.dct_wf_step(version_id,step_key,step_seq,name_en,name_ar,outcome_set_id,sla_hours,is_final_gate)
    VALUES(v_ver,'LINE_MGR',10,'Line manager review',UNISTR('\0645\0631\0627\062c\0639\0629\0020\0627\0644\0645\062f\064a\0631\0020\0627\0644\0645\0628\0627\0634\0631'),v_o_arr,48,'N') RETURNING step_id INTO v_s;
  INSERT INTO prod.dct_wf_participant_rule(step_id,resolver_type,role_code) VALUES(v_s,'ROLE','SYS_ADMIN');

  INSERT INTO prod.dct_wf_step(version_id,step_key,step_seq,name_en,name_ar,condition_id,outcome_set_id,sla_hours,is_final_gate)
    VALUES(v_ver,'FINANCE',20,'Finance endorsement',UNISTR('\062a\0623\064a\064a\062f\0020\0627\0644\0634\0624\0648\0646\0020\0627\0644\0645\0627\0644\064a\0629'),v_c_hi,v_o_end,72,'N') RETURNING step_id INTO v_s;
  INSERT INTO prod.dct_wf_participant_rule(step_id,resolver_type,role_code) VALUES(v_s,'ROLE','SYS_ADMIN');

  INSERT INTO prod.dct_wf_step(version_id,step_key,step_seq,name_en,name_ar,condition_id,outcome_set_id,sla_hours,is_final_gate)
    VALUES(v_ver,'DIRECTOR',30,'Director sign-off',UNISTR('\0627\0639\062a\0645\0627\062f\0020\0627\0644\0645\062f\064a\0631'),v_c_lt,v_o_ar,72,'N') RETURNING step_id INTO v_s;
  INSERT INTO prod.dct_wf_participant_rule(step_id,resolver_type,role_code) VALUES(v_s,'ROLE','SYS_ADMIN');

  INSERT INTO prod.dct_wf_step(version_id,step_key,step_seq,name_en,name_ar,outcome_set_id,sla_hours,is_final_gate)
    VALUES(v_ver,'FINAL',40,'Final approval',UNISTR('\0627\0644\0627\0639\062a\0645\0627\062f\0020\0627\0644\0646\0647\0627\0626\064a'),v_o_ar,48,'Y') RETURNING step_id INTO v_s;
  INSERT INTO prod.dct_wf_participant_rule(step_id,resolver_type,role_code) VALUES(v_s,'ROLE','SYS_ADMIN');

  COMMIT;
END;
/
EXIT
