prompt --application/shared_components/user_interface/lovs/eu_request_types
begin
--   Manifest
--     EU REQUEST TYPES
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(203139147648731)
,p_lov_name=>'EU REQUEST TYPES'
,p_lov_query=>'.'||wwv_flow_api.id(203139147648731)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(204171700648732)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Standard'
,p_lov_return_value=>'S'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(204666087648732)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Change Request'
,p_lov_return_value=>'C'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(203405560648732)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Budget Addition'
,p_lov_return_value=>'A'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(203853477648732)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'Budget Release'
,p_lov_return_value=>'R'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(31976206381433484)
,p_lov_disp_sequence=>5
,p_lov_disp_value=>'CWIP Transfer'
,p_lov_return_value=>'X'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(6151508999671408)
,p_lov_disp_sequence=>6
,p_lov_disp_value=>'CWIP- Budget Addition'
,p_lov_return_value=>'6'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(6151186597671398)
,p_lov_disp_sequence=>7
,p_lov_disp_value=>'CWIP- Budget Release'
,p_lov_return_value=>'7'
);
wwv_flow_api.component_end;
end;
/
