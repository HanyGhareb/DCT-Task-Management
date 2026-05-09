prompt --application/shared_components/reports/report_queries/item_status_report
begin
--   Manifest
--     WEB SERVICE: Item_status_report
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_shared_query(
 p_id=>wwv_flow_api.id(503212646347967162)
,p_name=>'Item_status_report'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    DP_ITEM_CODE,',
'    user_details.get_full_name(END_USER_ID) end_user,',
'    user_details.get_cost_center_name (COST_CENTER) cost_center,',
'    PROJECT_TITLE,',
'    PROJECT_DESCRIPTION,',
'    to_char(ESTIMATED_DATE,''DD-MON-YYYY'')       project_start_date,',
'    to_char(PROJECT_END_DATE,''DD-MON-YYYY'')     project_end_date,',
'    DP_ITEMS_UTIL.get_item_category_name(main_category_id)      Category_1,',
'    DP_ITEMS_UTIL.get_item_category_name(CATEGORY_ID)           Category_2,',
'    DP_ITEMS_UTIL.get_item_category_name(SUB_CATEGORY_ID)       Category_3,',
'    ',
'    PROJECT_NUMBER,',
'    TASK_NUMBER,',
'    EXPENDITURE_TYPE,',
'    trim(to_char(ESTIMATED_BUDGET,''99,999,999,999.99''))          ESTIMATED_BUDGET,',
'    trim(to_char(TOTAL_PROJECT_BUDGET,''99,999,999,999.99''))      TOTAL_PROJECT_BUDGET,',
'     DP_ITEMS_UTIL.get_dp_procurement_method_name(DP_PROCUREMENT_METHOD)    DP_PROCUREMENT_METHOD,',
'    ',
'    DP_ITEMS_UTIL.get_dp_item_type_name (DP_ITEM_TYPE_ID)     project_type,',
'    DP_ITEMS_UTIL.get_risk_name  (RISK_ID)          Risk,',
'    DP_ITEMS_UTIL.get_priority_name(PRIORITY_ID)         priority,',
'    ',
'     DP_ITEMS_UTIL.get_planning_status_name (PLANNING_STATUS)   PLANNING_STATUS,',
'    REVIEW_STATUS,',
'    APPROVAL_STATUS,',
'    NOTES',
'FROM',
'    DP_ITEMS',
'WHERE item_id = :P_item_id;'))
,p_xml_structure=>'STANDARD'
,p_format=>'PDF'
,p_output_file_name=>'Item_status_report'
,p_content_disposition=>'ATTACHMENT'
);
wwv_flow_api.component_end;
end;
/
