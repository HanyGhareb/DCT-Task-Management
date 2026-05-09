prompt --application/shared_components/user_interface/lovs/contractual_security_lov
begin
--   Manifest
--     CONTRACTUAL_SECURITY_LOV
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
 p_id=>wwv_flow_api.id(31396667483343774)
,p_lov_name=>'CONTRACTUAL_SECURITY_LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CONTRACTUAL_SECURITY_NAME	, ID , decode(CONTRACT_REQUIRED,''Y'',''Yes'',''N'',''No'') CONTRACT_REQUIRED_D,',
'         CONTRACT_REQUIRED',
'from CWIP_CONTRACTUAL_SECURITIES_LIST',
'order by id'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ID'
,p_display_column_name=>'CONTRACTUAL_SECURITY_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'CONTRACTUAL_SECURITY_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(31398251406322909)
,p_query_column_name=>'CONTRACTUAL_SECURITY_NAME'
,p_heading=>'Contractual Security Name'
,p_display_sequence=>5
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(31397863662322909)
,p_query_column_name=>'ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(31412340319243095)
,p_query_column_name=>'CONTRACT_REQUIRED_D'
,p_heading=>'Contract Required'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(31398679771322908)
,p_query_column_name=>'CONTRACT_REQUIRED'
,p_heading=>'Contract Required'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.component_end;
end;
/
