prompt --application/shared_components/user_interface/lovs/tac_form_purposes_active_lov
begin
--   Manifest
--     TAC FORM PURPOSES ACTIVE - LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>143576171933264960
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(26808113710120091)
,p_lov_name=>'TAC FORM PURPOSES ACTIVE - LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id ',
'from DCT_LOOKUP_VALUES ',
'where lookup_id = (select l.lookup_id ',
'                    from dct_lookups l ',
'                    where l.lookup_code = ''TACFORMPUR'') ',
'and status = ''A'' ',
'and sysdate BETWEEN nvl(start_date,sysdate-10) ',
'and NVL(end_date, sysdate + 10)',
'order by 2'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'VALUE_ID'
,p_display_column_name=>'VALUE'
);
wwv_flow_api.component_end;
end;
/
