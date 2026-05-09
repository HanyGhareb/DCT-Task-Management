prompt --application/shared_components/user_interface/lovs/employees_name_by_person_ids_lov
begin
--   Manifest
--     Employees Name By Person IDs  LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(20691219654288121)
,p_lov_name=>'Employees Name By Person IDs  LOV'
,p_reference_id=>19496453621420111
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from dct_employees_list2'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PERSON_ID'
,p_display_column_name=>'FULL_NAME_EN'
,p_default_sort_column_name=>'FULL_NAME_EN'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
