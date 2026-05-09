prompt --application/shared_components/user_interface/lovs/scoping_components_lov
begin
--   Manifest
--     SCOPING COMPONENTS LOV
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
 p_id=>wwv_flow_api.id(139639858043057475)
,p_lov_name=>'SCOPING COMPONENTS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select COMPONENT_NAME , COMPONENT_ID ',
'from dp_scope_components',
'where status = ''A''',
'--and  APPENDIX_ID = nvl(:APPENDIX_ID , APPENDIX_ID)',
'AND sysdate between nvl(start_date , sysdate - 10 ) and nvl(end_date , sysdate + 10)'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'COMPONENT_ID'
,p_display_column_name=>'COMPONENT_NAME'
,p_default_sort_column_name=>'COMPONENT_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
