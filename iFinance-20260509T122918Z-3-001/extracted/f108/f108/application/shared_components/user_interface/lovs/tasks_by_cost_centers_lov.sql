prompt --application/shared_components/user_interface/lovs/tasks_by_cost_centers_lov
begin
--   Manifest
--     TASKS BY COST CENTERS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(20246783462168925)
,p_lov_name=>'TASKS BY COST CENTERS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select t.task_number Task , t.task_number r , t.cost_center , t.cost_center cc_code',
'from tasks_all_v t',
'where t.project_number = :P2_PROJECT_NUMBER',
'order by 1'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'R'
,p_display_column_name=>'TASK'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'TASK'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(20247225608172101)
,p_query_column_name=>'R'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(23598228518784649)
,p_query_column_name=>'CC_CODE'
,p_heading=>'Cc Code'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(23598673433784649)
,p_query_column_name=>'TASK'
,p_heading=>'Task'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(20248027108172101)
,p_query_column_name=>'COST_CENTER'
,p_heading=>'Cost Center'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.component_end;
end;
/
