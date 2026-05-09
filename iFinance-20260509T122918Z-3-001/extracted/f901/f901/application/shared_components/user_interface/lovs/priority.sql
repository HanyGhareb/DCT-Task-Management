prompt --application/shared_components/user_interface/lovs/priority
begin
--   Manifest
--     PRIORITY
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>123
,p_default_id_offset=>6039605030667831
,p_default_owner=>'DEV'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(8338101286248980)
,p_lov_name=>'PRIORITY'
,p_lov_query=>'.'||wwv_flow_api.id(8338101286248980)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(8338483933248980)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Low'
,p_lov_return_value=>'L'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(8338837548248981)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Medium'
,p_lov_return_value=>'M'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(8339236480248981)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'High'
,p_lov_return_value=>'H'
);
wwv_flow_api.component_end;
end;
/
