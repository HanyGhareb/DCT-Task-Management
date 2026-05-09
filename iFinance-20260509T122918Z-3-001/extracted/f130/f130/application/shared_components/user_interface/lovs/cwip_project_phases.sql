prompt --application/shared_components/user_interface/lovs/cwip_project_phases
begin
--   Manifest
--     CWIP PROJECT PHASES
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(86966748824702020)
,p_lov_name=>'CWIP PROJECT PHASES'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select VALUE , value_id ',
'from CWIP_LOOKUP_VALUES',
'where LOOKUP_ID = 7',
'and status = ''A''',
'and sysdate BETWEEN nvl(start_date,sysdate-10) ',
'    and NVL(end_date, sysdate + 10) ',
'order by value;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'VALUE_ID'
,p_display_column_name=>'VALUE'
);
wwv_flow_api.component_end;
end;
/
