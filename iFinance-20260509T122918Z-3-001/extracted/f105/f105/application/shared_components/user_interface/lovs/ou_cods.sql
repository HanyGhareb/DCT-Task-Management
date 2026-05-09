prompt --application/shared_components/user_interface/lovs/ou_cods
begin
--   Manifest
--     OU CODS
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
 p_id=>wwv_flow_api.id(15921106053436334)
,p_lov_name=>'OU CODS'
,p_lov_query=>'.'||wwv_flow_api.id(15921106053436334)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15920736182436333)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'TCA'
,p_lov_return_value=>'TCA'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15920367403436328)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'MSS'
,p_lov_return_value=>'MSS'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(15920020825436328)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'TCAC'
,p_lov_return_value=>'TCAC'
);
wwv_flow_api.component_end;
end;
/
