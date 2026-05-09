prompt --application/shared_components/user_interface/lovs/futrure2_all
begin
--   Manifest
--     FUTRURE2 ALL
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
 p_id=>wwv_flow_api.id(9917433167098014)
,p_lov_name=>'FUTRURE2 ALL'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct FUTURE2, FUTURE2 || ''('' || FUTURE2_DESCRIPTION || '')'' d',
'from dct_gl_code_combinations_all',
'order by 1'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'FUTURE2'
,p_display_column_name=>'D'
);
wwv_flow_api.component_end;
end;
/
