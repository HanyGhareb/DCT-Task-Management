prompt --application/shared_components/user_interface/lovs/budget_proposal_plan_types
begin
--   Manifest
--     BUDGET PROPOSAL PLAN TYPES
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
 p_id=>wwv_flow_api.id(50661192721222067)
,p_lov_name=>'BUDGET PROPOSAL PLAN TYPES'
,p_lov_query=>'.'||wwv_flow_api.id(50661192721222067)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(50660923158222064)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Expenses'
,p_lov_return_value=>'E'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(50660463830222059)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Manpower'
,p_lov_return_value=>'M'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(50660095342222059)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Revenue'
,p_lov_return_value=>'R'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(50659662940222058)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'GL'
,p_lov_return_value=>'G'
);
wwv_flow_api.component_end;
end;
/
