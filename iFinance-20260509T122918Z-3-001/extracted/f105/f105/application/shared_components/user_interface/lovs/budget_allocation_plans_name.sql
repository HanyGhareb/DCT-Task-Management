prompt --application/shared_components/user_interface/lovs/budget_allocation_plans_name
begin
--   Manifest
--     BUDGET ALLOCATION PLANS NAME
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
 p_id=>wwv_flow_api.id(70889094180742864)
,p_lov_name=>'BUDGET ALLOCATION PLANS NAME'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PLAN_NAME , PLAN_ID',
'from budget_allocation_plans'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PLAN_ID'
,p_display_column_name=>'PLAN_NAME'
,p_default_sort_column_name=>'PLAN_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
