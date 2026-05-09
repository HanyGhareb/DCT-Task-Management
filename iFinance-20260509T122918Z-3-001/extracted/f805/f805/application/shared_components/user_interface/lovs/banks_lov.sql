prompt --application/shared_components/user_interface/lovs/banks_lov
begin
--   Manifest
--     BANKS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(36351221572275460)
,p_lov_name=>'BANKS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT BANK_NAME Bank_Name , BANK_NAME Bank',
'FROM BANKS;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'BANK_NAME'
,p_display_column_name=>'BANK'
,p_default_sort_column_name=>'BANK'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
