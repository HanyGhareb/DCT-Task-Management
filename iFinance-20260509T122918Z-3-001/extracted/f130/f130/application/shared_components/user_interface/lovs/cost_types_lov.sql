prompt --application/shared_components/user_interface/lovs/cost_types_lov
begin
--   Manifest
--     COST TYPES LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(30444530399539118)
,p_lov_name=>'COST TYPES LOV'
,p_lov_query=>'.'||wwv_flow_api.id(30444530399539118)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(30444844407539114)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Hard Cost'
,p_lov_return_value=>'Hard Cost'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(30445209420539113)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Soft Cost'
,p_lov_return_value=>'Soft Cost'
);
wwv_flow_api.component_end;
end;
/
