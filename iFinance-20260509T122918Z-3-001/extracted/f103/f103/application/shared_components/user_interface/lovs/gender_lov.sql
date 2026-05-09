prompt --application/shared_components/user_interface/lovs/gender_lov
begin
--   Manifest
--     GENDER LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>116806299474925354
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(38586911582233520)
,p_lov_name=>'GENDER LOV'
,p_lov_query=>'.'||wwv_flow_api.id(38586911582233520)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(38587213613233517)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'F'
,p_lov_return_value=>'Female'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(38587643017233516)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'M'
,p_lov_return_value=>'Male'
);
wwv_flow_api.component_end;
end;
/
