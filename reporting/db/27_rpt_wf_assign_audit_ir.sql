SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
-- reporting/db/27_rpt_wf_assign_audit_ir.sql
-- Registers the workflow role-assignments audit as an Interactive Report
-- definition (WF_ROLE_ASSIGN_AUDIT) so the BI viewer offers column chooser,
-- control breaks, saved layouts and XLSX over prod.v_dct_wf_assign_audit
-- (created by db/v2/96). Idempotent guarded insert, no merge.
-- Viewer access follows the IR gate: BI_USER or SYS_ADMIN.

DECLARE
    v NUMBER;
BEGIN
    SELECT COUNT(*) INTO v FROM prod.dct_rpt_definition
     WHERE report_code = 'WF_ROLE_ASSIGN_AUDIT';
    IF v = 0 THEN
        INSERT INTO prod.dct_rpt_definition
            (report_code, name_en, name_ar, description, category,
             source_type, source_ref, engine, default_formats, enabled, created_by)
        VALUES
            ('WF_ROLE_ASSIGN_AUDIT',
             'Workflow Role Assignments Audit',
             UNISTR('\0633\062c\0644 \062a\062f\0642\064a\0642 \062a\0639\064a\064a\0646\0627\062a \0623\062f\0648\0627\0631 \0633\064a\0631 \0627\0644\0639\0645\0644'),
             'Every create, end, replace and void of a workflow role assignment: who changed what, when, on which business object.',
             'Workflow',
             'SQL',
             'SELECT l.log_id, l.logged_at, l.actor, l.action, l.assignment_id,'
             || ' l.object_type_code, l.object_type_name, l.object_key, l.object_key2,'
             || ' l.object_label, l.role_code, l.assignee_name, l.start_date, l.end_date,'
             || ' l.is_active FROM prod.v_dct_wf_assign_audit l ORDER BY l.logged_at DESC',
             'NATIVE', 'XLSX', 'Y', 'SEED');
        DBMS_OUTPUT.PUT_LINE('  WF_ROLE_ASSIGN_AUDIT registered');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  WF_ROLE_ASSIGN_AUDIT already present');
    END IF;
    COMMIT;
END;
/
EXIT
