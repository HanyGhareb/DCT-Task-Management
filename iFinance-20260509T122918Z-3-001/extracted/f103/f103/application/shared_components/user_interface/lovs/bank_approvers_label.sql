prompt --application/shared_components/user_interface/lovs/bank_approvers_label
begin
--   Manifest
--     BANK APPROVERS LABEL
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
 p_id=>wwv_flow_api.id(9368603804118820)
,p_lov_name=>'BANK APPROVERS LABEL'
,p_lov_query=>'.'||wwv_flow_api.id(9368603804118820)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(9368382001118820)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'First Approver'
,p_lov_return_value=>'1'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(9367967515118821)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Second Approver'
,p_lov_return_value=>'2'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(9367533846118821)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Third Approver'
,p_lov_return_value=>'3'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(9367198197118821)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'Fourth Approver'
,p_lov_return_value=>'4'
);
wwv_flow_api.component_end;
end;
/
