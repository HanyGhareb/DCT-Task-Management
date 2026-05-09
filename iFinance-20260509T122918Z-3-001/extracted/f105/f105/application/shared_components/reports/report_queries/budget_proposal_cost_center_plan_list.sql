prompt --application/shared_components/reports/report_queries/budget_proposal_cost_center_plan_list
begin
--   Manifest
--     WEB SERVICE: Budget proposal Cost Center Plan List
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
 p_id=>wwv_flow_api.id(45558005075982377)
,p_name=>'Budget proposal Cost Center Plan List'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       PLAN_ID,',
'       user_details.org_name(SECTOR_ID) Sector_Name,',
'       COST_CENTER,',
'       user_details.get_cost_center_name(cost_center) cost_center_name,',
'       user_details.get_full_name(user_details.get_cc_director_person_id(COST_CENTER)) DIRECTOR_NAME,',
'       user_details.get_full_name(user_details.get_cc_exec_dir_person_id(COST_CENTER)) ED_NAME,',
'--       CEILING_CH1_REQUIRED_YN,',
'--       CEILING_CH1_AMOUNT,',
'--       CEILING_CH2_REQUIRED_YN,',
'       CEILING_CH2_AMOUNT,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated(PLAN_ID , COST_CENTER , 134) CH2_Allocation,',
'--       CEILING_CH3_REQUIRED_YN,',
'       CEILING_CH3_AMOUNT,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated(PLAN_ID , COST_CENTER , 135) CH3_Allocation,',
'--       CEILING_CH6_REQUIRED_YN,',
'--       CEILING_CH6_AMOUNT,',
'       STATUS,',
'       COST_CENTER_INSTRUCTIONS,',
'       COMMENTS,',
'--       SUBMITTED_BY,',
'--       SUBMITTED_ON,',
'--       RECEIVED_ON,',
'--       RECEIVED_BY,',
'--       ALLOW_ADD_PROJECT_YN,',
'--       ALLOW_ADD_TASK_YN,',
'--       CREATED_BY,',
'--       CREATED_ON,',
'--       UPDATED_BY,',
'--       UPDATED_ON,',
'       (select count (distinct p.project_number)',
'        from budget_proposal_projects_plans p',
'        where p.plan_id = cc.plan_id',
'        and p.sector_id = cc.sector_id',
'        and p.cost_center = cc.cost_center) projects_count,',
'      (select count (*)',
'        from budget_proposal_projects_plans p',
'        where p.plan_id = cc.plan_id',
'        and p.sector_id = cc.sector_id',
'        and p.cost_center = cc.cost_center) line_count  ',
'  from BUDGET_PROPOSAL_COST_CENTERS_PLANS cc',
'  where plan_id = :P85_PLAN_ID',
'  order by cost_center'))
,p_xml_structure=>'APEX'
,p_report_layout_id=>wwv_flow_api.id(45545837772799994)
,p_format=>'XLS'
,p_output_file_name=>'Budget proposal Cost Center Plan List'
,p_content_disposition=>'ATTACHMENT'
,p_xml_items=>'P85_PLAN_ID'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(45545437130798577)
,p_shared_query_id=>wwv_flow_api.id(45558005075982377)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       PLAN_ID,',
'       user_details.org_name(SECTOR_ID) Sector_Name,',
'       COST_CENTER,',
'       user_details.get_cost_center_name(cost_center) cost_center_name,',
'       user_details.get_full_name(user_details.get_cc_director_person_id(COST_CENTER)) DIRECTOR_NAME,',
'       user_details.get_full_name(user_details.get_cc_exec_dir_person_id(COST_CENTER)) ED_NAME,',
'--       CEILING_CH1_REQUIRED_YN,',
'--       CEILING_CH1_AMOUNT,',
'--       CEILING_CH2_REQUIRED_YN,',
'       CEILING_CH2_AMOUNT,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated(PLAN_ID , COST_CENTER , 134) CH2_Allocation,',
'--       CEILING_CH3_REQUIRED_YN,',
'       CEILING_CH3_AMOUNT,',
'       BUDGET_PROPOSAL_PKG.CC_CHAPTER_allocated(PLAN_ID , COST_CENTER , 135) CH3_Allocation,',
'--       CEILING_CH6_REQUIRED_YN,',
'--       CEILING_CH6_AMOUNT,',
'       STATUS,',
'       COST_CENTER_INSTRUCTIONS,',
'       COMMENTS,',
'--       SUBMITTED_BY,',
'--       SUBMITTED_ON,',
'--       RECEIVED_ON,',
'--       RECEIVED_BY,',
'--       ALLOW_ADD_PROJECT_YN,',
'--       ALLOW_ADD_TASK_YN,',
'--       CREATED_BY,',
'--       CREATED_ON,',
'--       UPDATED_BY,',
'--       UPDATED_ON,',
'       (select count (distinct p.project_number)',
'        from budget_proposal_projects_plans p',
'        where p.plan_id = cc.plan_id',
'        and p.sector_id = cc.sector_id',
'        and p.cost_center = cc.cost_center) projects_count,',
'      (select count (*)',
'        from budget_proposal_projects_plans p',
'        where p.plan_id = cc.plan_id',
'        and p.sector_id = cc.sector_id',
'        and p.cost_center = cc.cost_center) line_count  ',
'  from BUDGET_PROPOSAL_COST_CENTERS_PLANS cc',
'  where plan_id = :P85_PLAN_ID',
'  order by cost_center'))
);
wwv_flow_api.component_end;
end;
/
