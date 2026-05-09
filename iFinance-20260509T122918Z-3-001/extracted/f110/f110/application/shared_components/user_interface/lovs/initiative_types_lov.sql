prompt --application/shared_components/user_interface/lovs/initiative_types_lov
begin
--   Manifest
--     INITIATIVE TYPES LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>110
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(134301761179978400)
,p_lov_name=>'INITIATIVE TYPES LOV'
,p_lov_query=>'.'||wwv_flow_api.id(134301761179978400)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(134302166490978399)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Strategic'
,p_lov_return_value=>'S'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(134302572433978399)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Non-Strategic'
,p_lov_return_value=>'N'
);
wwv_flow_api.component_end;
end;
/
