prompt --application/shared_components/user_interface/lovs/expenditure_types_by_page_10
begin
--   Manifest
--     EXPENDITURE TYPES BY PAGE 10
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(303480753639160981)
,p_lov_name=>'EXPENDITURE TYPES BY PAGE 10'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EXPENDITURE_TYPE, DESCRIPTION, GL_ACCOUNT, GL_ACCOUNT_NAME',
'from expenditures_v',
'where project_number = :P10_PROJECT_NUMBER',
'and TASK_NUMBER = :P10_TASK_NUMBER ;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'EXPENDITURE_TYPE'
,p_display_column_name=>'EXPENDITURE_TYPE'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'EXPENDITURE_TYPE'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
