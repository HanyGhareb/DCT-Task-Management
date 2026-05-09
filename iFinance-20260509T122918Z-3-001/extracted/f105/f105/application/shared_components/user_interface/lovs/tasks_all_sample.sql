prompt --application/shared_components/user_interface/lovs/tasks_all_sample
begin
--   Manifest
--     TASKS ALL (SAMPLE)
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(58419731054454731)
,p_lov_name=>'TASKS ALL (SAMPLE)'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct TASK_NUMBER d, TASK_NUMBER R',
'from tasks_all_v',
'where task_number not like ''?%''',
'order by 1;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'R'
,p_display_column_name=>'D'
);
wwv_flow_api.component_end;
end;
/
