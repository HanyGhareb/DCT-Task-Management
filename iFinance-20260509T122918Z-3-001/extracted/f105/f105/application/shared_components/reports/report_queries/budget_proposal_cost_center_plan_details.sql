prompt --application/shared_components/reports/report_queries/budget_proposal_cost_center_plan_details
begin
--   Manifest
--     WEB SERVICE: BUDGET_PROPOSAL_COST_CENTER_PLAN_DETAILS
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_shared_query(
 p_id=>wwv_flow_api.id(44021037504239857)
,p_name=>'BUDGET_PROPOSAL_COST_CENTER_PLAN_DETAILS'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PROJECT_NUMBER,',
'       projects_util.PROJECT_Name(PROJECT_NUMBER) project_name,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       PROJECTS_UTIL.TASK_INITIATIVE_ID(PROJECT_NUMBER,TASK_NUMBER )    INITIATIVE,',
'       PROJECTS_UTIL.TASK_PROGRAM_ID(PROJECT_NUMBER,TASK_NUMBER ) program,',
'        PROJECTS_UTIL.TASK_OBJECTIVE_ID(PROJECT_NUMBER,TASK_NUMBER ) objective,',
'        PROJECTS_UTIL.get_task_chapter(PROJECT_NUMBER,TASK_NUMBER ) Chapter,',
'       ENTITY_CODE,',
'       COST_CENTER,',
'       BUDGET_GROUB_CODE,',
'       GL_ACCOUNT,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2,',
'       PROJECT_DESCRIPTION,',
'       OUTCOME,',
'       PRIORITY,',
'       START_DATE,',
'       END_DATE,',
'       BP_EXPENSE_CATEGORY_ID,',
'       BP_EXPENSE_CLASS_ID,',
'       BP_COMMITMENT_TYPE_ID,',
'       BP_CLASSIFICATIONS_ID,',
'       COST_DRIVER,',
'       COST_DRIVER_UOM,',
'       COST_DRIVER_QUANTITY,',
'       COST,',
'       TOTAL_COST,',
'       JUSTIFICATIONS,',
'       CALCULATION_BASIS,',
'       COMMENTS,',
'       BUDGET_Y1,',
'       BUDGET_Y2,',
'       BUDGET_Y3,',
'       BUDGET_Y4,',
'       BUDGET_Y5,',
'       JAN,',
'       FEB,',
'       MAR,',
'       APR,',
'       MAY,',
'       JUN,',
'       JUL,',
'       AUG,',
'       SEP,',
'       OCT,',
'       NOV,',
'       DEC,',
'       ACTUAL_Y1,',
'       ACTUAL_Y2,',
'       ACTUAL_Y3,',
'       ACTUAL_Y4,',
'       ACTUAL_Y5,',
'',
'       DELIVERABLE_1,',
'       TRAGET_1,',
'       DELIVERABLE_2,',
'       TARGET_2,',
'       DELIVERABLE_3,',
'       TRAGET_3,',
'       STATUS',
'  from BUDGET_PROPOSAL_PROJECTS_PLANS',
'  where plan_id = :P97_PLAN_ID',
'  and cost_center = :P97_COST_CENTER '))
,p_xml_structure=>'APEX'
,p_format=>'XLS'
,p_output_file_name=>'BUDGET_PROPOSAL_COST_CENTER_PLAN_DETAILS'
,p_content_disposition=>'ATTACHMENT'
,p_xml_items=>'P97_PLAN_ID:P97_COST_CENTER'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(44020621689153186)
,p_shared_query_id=>wwv_flow_api.id(44021037504239857)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PROJECT_NUMBER,',
'       projects_util.PROJECT_Name(PROJECT_NUMBER) project_name,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'   --    PROJECTS_UTIL.TASK_INITIATIVE_ID(PROJECT_NUMBER,TASK_NUMBER )    INITIATIVE,',
'   --    PROJECTS_UTIL.TASK_PROGRAM_ID(PROJECT_NUMBER,TASK_NUMBER ) program,',
'   --     PROJECTS_UTIL.TASK_OBJECTIVE_ID(PROJECT_NUMBER,TASK_NUMBER ) objective,',
'   --     PROJECTS_UTIL.get_task_chapter(PROJECT_NUMBER,TASK_NUMBER ) Chapter,',
'    --   ENTITY_CODE,',
'    --   COST_CENTER,',
'    --   BUDGET_GROUB_CODE,',
'    --   GL_ACCOUNT,',
'    --   ACTIVITY,',
'    --   FUTURE1,',
'    --   FUTURE2,',
'       PROJECT_DESCRIPTION,',
'       OUTCOME,',
'       PRIORITY,',
'       START_DATE,',
'       END_DATE,',
'       BP_EXPENSE_CATEGORY_ID,',
'       BP_EXPENSE_CLASS_ID,',
'       BP_COMMITMENT_TYPE_ID,',
'       BP_CLASSIFICATIONS_ID,',
'       JUSTIFICATIONS,',
'       CALCULATION_BASIS,',
'       COMMENTS,',
'       BUDGET_Y1,',
'       BUDGET_Y2,',
'       BUDGET_Y3,',
'       BUDGET_Y4,',
'       BUDGET_Y5,',
'       JAN,',
'       FEB,',
'       MAR,',
'       APR,',
'       MAY,',
'       JUN,',
'       JUL,',
'       AUG,',
'       SEP,',
'       OCT,',
'       NOV,',
'       DEC,',
'    --   ACTUAL_Y1,',
'    --   ACTUAL_Y2,',
'    --   ACTUAL_Y3,',
'    --   ACTUAL_Y4,',
'    --   ACTUAL_Y5,',
'',
'       DELIVERABLE_1,',
'       TRAGET_1,',
'       DELIVERABLE_2,',
'       TARGET_2,',
'       DELIVERABLE_3,',
'       TRAGET_3  from BUDGET_PROPOSAL_PROJECTS_PLANS',
'  where plan_id = :P97_PLAN_ID',
'  and cost_center = :P97_COST_CENTER '))
);
wwv_flow_api.component_end;
end;
/
