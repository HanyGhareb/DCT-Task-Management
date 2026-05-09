prompt --application/shared_components/user_interface/lovs/status_lov
begin
--   Manifest
--     STATUS LOV
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
 p_id=>wwv_flow_api.id(24157293190244783)
,p_lov_name=>'STATUS LOV'
,p_reference_id=>43207737930011488
,p_lov_query=>'.'||wwv_flow_api.id(24157293190244783)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(24159239756244781)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Active'
,p_lov_return_value=>'A'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(24159626760244781)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'in-Active'
,p_lov_return_value=>'I'
);
wwv_flow_api.component_end;
end;
/
