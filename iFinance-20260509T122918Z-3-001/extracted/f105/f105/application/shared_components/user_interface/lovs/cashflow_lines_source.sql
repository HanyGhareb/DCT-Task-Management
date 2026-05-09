prompt --application/shared_components/user_interface/lovs/cashflow_lines_source
begin
--   Manifest
--     CASHFLOW LINES SOURCE
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
 p_id=>wwv_flow_api.id(63042438900901735)
,p_lov_name=>'CASHFLOW LINES SOURCE'
,p_lov_query=>'.'||wwv_flow_api.id(63042438900901735)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(63042227240901734)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Demand Planning'
,p_lov_return_value=>'DP'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(63041753689901734)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Direct'
,p_lov_return_value=>'D'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(56841757752602889)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Budget Transfer'
,p_lov_return_value=>'BT'
);
wwv_flow_api.component_end;
end;
/
