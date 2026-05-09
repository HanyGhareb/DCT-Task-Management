prompt --application/shared_components/user_interface/lovs/payroll_areas_lov
begin
--   Manifest
--     PAYROLL AREAS LOV
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
 p_id=>wwv_flow_api.id(189239939819672924)
,p_lov_name=>'PAYROLL AREAS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct sf_payroll_area d,sf_payroll_area r ',
'from dct_employees_list2 ',
'union ALL',
'select ''Freelancer'' d, ''Freelancer'' r ',
'from dual;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'R'
,p_display_column_name=>'D'
,p_default_sort_column_name=>'D'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
