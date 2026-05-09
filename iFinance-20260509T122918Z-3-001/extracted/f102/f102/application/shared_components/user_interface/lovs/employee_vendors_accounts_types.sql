prompt --application/shared_components/user_interface/lovs/employee_vendors_accounts_types
begin
--   Manifest
--     EMPLOYEE VENDORS ACCOUNTS TYPES
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(115295661695824595)
,p_lov_name=>'EMPLOYEE VENDORS ACCOUNTS TYPES'
,p_lov_query=>'.'||wwv_flow_api.id(115295661695824595)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(115295986002824582)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Freelancer'
,p_lov_return_value=>'FL'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(115296311969824581)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Petty Cash'
,p_lov_return_value=>'PC'
);
wwv_flow_api.component_end;
end;
/
