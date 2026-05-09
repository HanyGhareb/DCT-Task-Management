prompt --application/shared_components/user_interface/lovs/technical_submission_lov
begin
--   Manifest
--     TECHNICAL SUBMISSION LOV
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
 p_id=>wwv_flow_api.id(138190893143257226)
,p_lov_name=>'TECHNICAL SUBMISSION LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 51 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)',
''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'VALUE_ID'
,p_display_column_name=>'VALUE'
,p_default_sort_column_name=>'VALUE'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
