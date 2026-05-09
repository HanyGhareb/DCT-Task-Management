prompt --application/shared_components/user_interface/lovs/emp_by_emails_popup
begin
--   Manifest
--     EMP BY EMAILS POPUP
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>118
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(156938486124525230)
,p_lov_name=>'EMP BY EMAILS POPUP'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en     || ',
'        ''(''             ||',
'        employee_num    ||',
'        ''-''             ||',
'        email           ||',
'        '')''                         as full_name_en',
'        , email',
'from employees_v',
'where current_flag = ''Y''',
'order by employee_num'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'EMAIL'
,p_display_column_name=>'FULL_NAME_EN'
);
wwv_flow_api.component_end;
end;
/
