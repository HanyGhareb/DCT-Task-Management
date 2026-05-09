prompt --application/shared_components/user_interface/lovs/status_lov
begin
--   Manifest
--     STATUS_LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(70065089609020977)
,p_lov_name=>'STATUS_LOV'
,p_lov_query=>'.'||wwv_flow_api.id(70065089609020977)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(70065407524020975)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Active'
,p_lov_return_value=>'A'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(70065822344020975)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'In-Active'
,p_lov_return_value=>'I'
);
wwv_flow_api.component_end;
end;
/
