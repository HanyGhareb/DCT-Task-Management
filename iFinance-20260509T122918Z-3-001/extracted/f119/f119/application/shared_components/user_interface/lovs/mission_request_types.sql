prompt --application/shared_components/user_interface/lovs/mission_request_types
begin
--   Manifest
--     MISSION REQUEST TYPES
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(113237722857908974)
,p_lov_name=>'MISSION REQUEST TYPES'
,p_lov_query=>'.'||wwv_flow_api.id(113237722857908974)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(113238178371908974)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Mission'
,p_lov_return_value=>'M'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(113238543312908974)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Training'
,p_lov_return_value=>'T'
);
wwv_flow_api.component_end;
end;
/
