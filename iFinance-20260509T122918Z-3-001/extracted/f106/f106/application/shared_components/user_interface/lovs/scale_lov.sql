prompt --application/shared_components/user_interface/lovs/scale_lov
begin
--   Manifest
--     SCALE LOV
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
 p_id=>wwv_flow_api.id(109987462960962052)
,p_lov_name=>'SCALE LOV'
,p_lov_query=>'.'||wwv_flow_api.id(109987462960962052)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(109987742099962050)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'New Scale'
,p_lov_return_value=>'N'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(109988132753962050)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Old Scale'
,p_lov_return_value=>'O'
);
wwv_flow_api.component_end;
end;
/
