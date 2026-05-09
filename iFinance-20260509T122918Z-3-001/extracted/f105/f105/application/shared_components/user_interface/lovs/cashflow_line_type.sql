prompt --application/shared_components/user_interface/lovs/cashflow_line_type
begin
--   Manifest
--     CASHFLOW LINE TYPE
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
 p_id=>wwv_flow_api.id(63041515993898428)
,p_lov_name=>'CASHFLOW LINE TYPE'
,p_lov_query=>'.'||wwv_flow_api.id(63041515993898428)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(63041220821898427)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'A'
,p_lov_return_value=>'Addition'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(63040812005898427)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'D'
,p_lov_return_value=>'Deduction'
);
wwv_flow_api.component_end;
end;
/
