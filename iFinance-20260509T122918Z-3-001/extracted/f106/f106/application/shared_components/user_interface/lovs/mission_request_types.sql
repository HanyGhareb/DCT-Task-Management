prompt --application/shared_components/user_interface/lovs/mission_request_types
begin
--   Manifest
--     MISSION REQUEST TYPES
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(110033950814469886)
,p_lov_name=>'MISSION REQUEST TYPES'
,p_lov_query=>'.'||wwv_flow_api.id(110033950814469886)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(110034281763469885)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Mission'
,p_lov_return_value=>'M'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(110034693090469885)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Training'
,p_lov_return_value=>'T'
);
wwv_flow_api.component_end;
end;
/
