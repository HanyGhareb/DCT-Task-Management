SET DEFINE OFF
SET SQLBLANKLINES ON
-- db/v2/71_dct_wf_fact_line_manager.sql
-- Adds the FACT_LINE_MANAGER participant resolver ("on behalf of" routing:
-- climb to the line manager of a person named in a fact field, not the
-- submitter). Two changes only -- the CHECK constraint here, and one CASE
-- branch in the DCT_WF_ENGINE body (db/v2/63). Idempotent; safe to re-run.
-- Deploy this BEFORE re-running 63 so a saved rule can carry the new value.
DECLARE
    v_txt VARCHAR2(400);
BEGIN
    SELECT search_condition_vc INTO v_txt
      FROM all_constraints
     WHERE owner = 'PROD' AND constraint_name = 'CHK_WF_PR_RT';

    IF INSTR(v_txt, 'FACT_LINE_MANAGER') = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_wf_participant_rule DROP CONSTRAINT chk_wf_pr_rt';
        EXECUTE IMMEDIATE q'[ALTER TABLE prod.dct_wf_participant_rule ADD CONSTRAINT chk_wf_pr_rt CHECK (resolver_type IN ('ROLE','ROLE_SCOPED_ORG','ORG_HEAD','LINE_MANAGER','FACT_LINE_MANAGER','FACT_USER','STATIC_USER','PREVIOUS_ACTOR','INITIATOR'))]';
        DBMS_OUTPUT.PUT_LINE('  chk_wf_pr_rt: FACT_LINE_MANAGER added');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  chk_wf_pr_rt: already allows FACT_LINE_MANAGER');
    END IF;
END;
/
EXIT
