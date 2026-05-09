prompt --application/shared_components/user_interface/lovs/banks_lov
begin
--   Manifest
--     BANKS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>191955104108672310
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(242174461825581)
,p_lov_name=>'BANKS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BANK_NAME d, BANK_NAME r ',
'from banks',
'order by 1'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'R'
,p_display_column_name=>'D'
);
wwv_flow_api.component_end;
end;
/
