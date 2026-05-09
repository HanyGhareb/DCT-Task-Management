prompt --application/shared_components/user_interface/lovs/budget_allocation_roles
begin
--   Manifest
--     BUDGET ALLOCATION ROLES
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
 p_id=>wwv_flow_api.id(71091855092180279)
,p_lov_name=>'BUDGET ALLOCATION ROLES'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ROLE_NAME , ROLE_ID',
'from roles ',
'where MAIN_CATEGORY = 28',
'and status = ''A''',
'and sysdate between nvl(start_date , sysdate - 10) ',
'    and nvl(end_date , sysdate + 10)',
'and  ROLE_ID <> 57',
'order by role_id;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ROLE_ID'
,p_display_column_name=>'ROLE_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'ROLE_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
