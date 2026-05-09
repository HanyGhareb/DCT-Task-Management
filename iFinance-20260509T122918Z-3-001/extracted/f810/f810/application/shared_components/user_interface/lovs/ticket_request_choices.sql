prompt --application/shared_components/user_interface/lovs/ticket_request_choices
begin
--   Manifest
--     TICKET REQUEST CHOICES
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(109829432214610256)
,p_lov_name=>'TICKET REQUEST CHOICES'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = 36',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)',
'order by 1'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'VALUE_ID'
,p_display_column_name=>'VALUE'
);
wwv_flow_api.component_end;
end;
/
