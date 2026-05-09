prompt --application/shared_components/user_interface/lovs/employee_name_by_personid_active_lov
begin
--   Manifest
--     EMPLOYEE NAME BY PERSONID-ACTIVE LOV
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
 p_id=>wwv_flow_api.id(26031585023945399)
,p_lov_name=>'EMPLOYEE NAME BY PERSONID-ACTIVE LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.full_name_en || '' ('' || e.employee_num  || '')'' emp_name, e.person_id ',
'from employees_v e',
'where e.current_flag = ''Y'''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PERSON_ID'
,p_display_column_name=>'EMP_NAME'
,p_default_sort_column_name=>'EMP_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
