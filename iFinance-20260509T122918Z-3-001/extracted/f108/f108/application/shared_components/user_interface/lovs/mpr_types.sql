prompt --application/shared_components/user_interface/lovs/mpr_types
begin
--   Manifest
--     MPR TYPES
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(19499875202477399)
,p_lov_name=>'MPR TYPES'
,p_lov_query=>'.'||wwv_flow_api.id(19499875202477399)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(19500139719477400)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Tendering'
,p_lov_return_value=>'T'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(19500523221477401)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Non-Tendering'
,p_lov_return_value=>'S'
);
wwv_flow_api.component_end;
end;
/
