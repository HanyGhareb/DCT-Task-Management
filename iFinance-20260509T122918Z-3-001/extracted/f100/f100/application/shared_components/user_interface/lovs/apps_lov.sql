prompt --application/shared_components/user_interface/lovs/apps_lov
begin
--   Manifest
--     APPS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(5028441291638957)
,p_lov_name=>'APPS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select APPLICATION_NAME|| ''('' || APPLICATION_ID || '')''  as APPLICATION_NAME, APPLICATION_ID ,  HOME_LINK ,LOGIN_URL	 ',
'from apex_applications ',
'where WORKSPACE = ''PROD'' and APPLICATION_ID < 999',
'order by 2'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'APPLICATION_ID'
,p_display_column_name=>'APPLICATION_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'APPLICATION_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
