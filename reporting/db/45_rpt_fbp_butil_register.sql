-- =============================================================================
-- Reporting Platform -- FBP_BUTIL_REGISTER (FBP - Projects Budget Utilization)
-- File    : 45_rpt_fbp_butil_register.sql
-- Run     : python-oracledb as ADMIN (or sql -name prod_mcp)
-- Purpose : a distribution copy of BUDGET_UTIL_REGISTER (reporting/db/25) for
--           the FBP audience, per the marked-up sample
--           docs/Reports/FMR/FBP-Budget_Utilization_Register_2026.xlsx:
--           sheet "1. Budget Utilization Lines" carries a FIXED 21-column
--           layout -- every red-filled header of the sample is dropped (EBS
--           account, appropriation/program names, YTD budget, the vs-Budget
--           trio, all 8 plan columns, utilization pct, fund-movement pair)
--           and Task Number is swapped for Task Name (the bu_lines SQL
--           already emits task_name, v1.96.3). The layout is baked into the
--           DEFINITION (the copied bu_lines SQL is wrapped in a fixed
--           projection), so it holds on EVERY entry point -- GL bridge
--           (GL/db/52), BI run drawer, schedules -- and the page's
--           Manage-Columns view never affects it. Sheets 2-8 are a VERBATIM
--           copy, so RE-RUN this script after any 25 re-run to refresh the
--           copy. XLSX only. Launched from the GL Budget Utilization page's
--           Generate Report menu (bridge = GL/db/52).
-- Idempotent: refreshes the copied columns on every run, then re-wraps.
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  l_n    NUMBER;
  l_key  VARCHAR2(100);
  l_sql  CLOB;
  l_new  CLOB;
  l_desc VARCHAR2(1000);
  l_subj VARCHAR2(400);
BEGIN
  l_desc := 'FBP - Projects Budget Utilization -- the Budget Utilization Register (Excel) re-issued for the FBP distribution with a FIXED sheet-1 layout (21 agreed columns, Task Name in place of Task Number; no EBS account, appropriation/program name, YTD-budget, vs-Budget, plan, utilization-pct or fund-movement columns). All other worksheets are a verbatim copy of BUDGET_UTIL_REGISTER -- re-run reporting/db/45 after any db/25 re-run to refresh the copy. XLSX only; run from the GL Budget Utilization page (Generate Report menu, bridge GL/db/52) or the BI catalog. Parameters mirror the GL Budget Utilization page filters: year (required); period (YTD, MM-YYYY), sector, chapter, projecttype, costcenter, project, task, etype, search, bu, ovr, cmtmode (all optional).';
  l_subj := 'FBP - Projects Budget Utilization - {{ params.year }}{% if params.sector %} - {{ params.sector }}{% endif %}';

  SELECT COUNT(*) INTO l_n
    FROM prod.dct_rpt_definition
   WHERE report_code = 'FBP_BUTIL_REGISTER';

  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_definition
      (report_code, name_en, name_ar, description, category,
       source_type, source_ref, engine, default_formats,
       email_subject_tpl, email_body_tpl,
       params_json, param_spec_json, enabled, created_by, updated_by)
    SELECT 'FBP_BUTIL_REGISTER',
           'FBP - Projects Budget Utilization',
           UNISTR('FBP - \0627\0633\062A\063A\0644\0627\0644 \0645\064A\0632\0627\0646\064A\0629 \0627\0644\0645\0634\0627\0631\064A\0639'),
           l_desc, category, source_type, source_ref, engine, 'XLSX',
           l_subj,
           REPLACE(email_body_tpl, 'Budget Utilization Register', 'FBP - Projects Budget Utilization report'),
           params_json, param_spec_json, 'Y', 'SEED', 'SEED'
      FROM prod.dct_rpt_definition
     WHERE report_code = 'BUDGET_UTIL_REGISTER';
  ELSE
    UPDATE prod.dct_rpt_definition
       SET (source_ref, params_json, param_spec_json, category, source_type, engine) =
           (SELECT source_ref, params_json, param_spec_json, category, source_type, engine
              FROM prod.dct_rpt_definition
             WHERE report_code = 'BUDGET_UTIL_REGISTER'),
           name_en           = 'FBP - Projects Budget Utilization',
           name_ar           = UNISTR('FBP - \0627\0633\062A\063A\0644\0627\0644 \0645\064A\0632\0627\0646\064A\0629 \0627\0644\0645\0634\0627\0631\064A\0639'),
           description       = l_desc,
           email_subject_tpl = l_subj,
           email_body_tpl    = (SELECT REPLACE(email_body_tpl, 'Budget Utilization Register', 'FBP - Projects Budget Utilization report')
                                  FROM prod.dct_rpt_definition
                                 WHERE report_code = 'BUDGET_UTIL_REGISTER'),
           default_formats   = 'XLSX',
           enabled           = 'Y',
           updated_by        = 'SEED',
           updated_at        = SYSTIMESTAMP
     WHERE report_code = 'FBP_BUTIL_REGISTER';
  END IF;

  -- fixed sheet-1 layout: wrap the COPIED bu_lines SQL in the agreed 21-column
  -- projection (order = the FBP sample's kept headers; task_name replaces
  -- task_number). The inner ORDER BY is preserved by the plain projection.
  -- The copy refresh above restores the unwrapped SQL, so the wrap re-applies
  -- idempotently; the marker guards a partial re-run.
  SELECT JSON_VALUE(source_ref, '$.sections[0].key'),
         JSON_VALUE(source_ref, '$.sections[0].sql' RETURNING CLOB)
    INTO l_key, l_sql
    FROM prod.dct_rpt_definition
   WHERE report_code = 'FBP_BUTIL_REGISTER';
  IF l_key <> 'bu_lines' THEN
    RAISE_APPLICATION_ERROR(-20001, 'FBP copy: sections[0] is ' || l_key || ', expected bu_lines');
  END IF;
  IF INSTR(l_sql, 'FBP_FIXED_COLS') = 0 THEN
    l_new := TO_CLOB('SELECT /* FBP_FIXED_COLS */ budget_combination, sector, department, cost_centre, project_number, project_name, task_name, account_number, appropriation_code, chapter, dct_program_code, expenditure_type, annual_budget, actual_ap, actual_grn, actual_total, commitment_pr, obligation_po, open_encumbrance, fund_available, comments FROM (')
          || l_sql || TO_CLOB(')');
    UPDATE prod.dct_rpt_definition
       SET source_ref = JSON_TRANSFORM(source_ref,
                          SET '$.sections[0].sql' = l_new
                          RETURNING CLOB)
     WHERE report_code = 'FBP_BUTIL_REGISTER';
  END IF;

  -- SELF e-mail recipient, same as the register (ONDEMAND runs mail the
  -- requester; EMAIL_TEST_MODE routing applies as everywhere)
  SELECT COUNT(*) INTO l_n
    FROM prod.dct_rpt_recipient
   WHERE report_code = 'FBP_BUTIL_REGISTER' AND recipient_type = 'SELF';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_recipient
      (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
    VALUES
      ('FBP_BUTIL_REGISTER', 'SELF', NULL, 'EMAIL', 'Y', 'SEED', 'SEED');
  END IF;

  COMMIT;
  DBMS_OUTPUT.put_line('FBP_BUTIL_REGISTER upserted.');
END;
/

PROMPT === verify ===
SELECT report_code, name_en, source_type, engine, default_formats,
       CASE WHEN source_ref IS JSON THEN 'SRC OK' ELSE 'SRC BAD' END AS src_ok,
       DBMS_LOB.GETLENGTH(source_ref) AS src_len, enabled
  FROM prod.dct_rpt_definition
 WHERE report_code IN ('FBP_BUTIL_REGISTER', 'BUDGET_UTIL_REGISTER')
 ORDER BY report_code;

SELECT CASE WHEN INSTR(JSON_VALUE(source_ref, '$.sections[0].sql' RETURNING CLOB), 'FBP_FIXED_COLS') > 0
            THEN 'WRAP OK' ELSE 'WRAP MISSING' END AS wrap_ok,
       CASE WHEN INSTR(JSON_VALUE(source_ref, '$.sections[0].sql' RETURNING CLOB), 'task_name,') > 0
            THEN 'TASK NAME OK' ELSE 'TASK NAME MISSING' END AS tn_ok,
       JSON_VALUE(source_ref, '$.sections[1].key') AS sec1,
       JSON_VALUE(source_ref, '$.sections[7].key') AS sec7
  FROM prod.dct_rpt_definition
 WHERE report_code = 'FBP_BUTIL_REGISTER';

PROMPT FBP_BUTIL_REGISTER definition seeded (copy of BUDGET_UTIL_REGISTER, fixed sheet-1 layout).
