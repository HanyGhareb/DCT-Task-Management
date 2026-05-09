prompt --application/shared_components/user_interface/lovs/emp_full_name_by_person_id_lov
begin
--   Manifest
--     EMP FULL NAME BY PERSON ID LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(36664110333548073)
,p_lov_name=>'EMP FULL NAME BY PERSON ID LOV'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'DCT_EMPLOYEES_LIST2'
,p_return_column_name=>'PERSON_ID'
,p_display_column_name=>'FULL_NAME_EN'
,p_default_sort_column_name=>'FULL_NAME_EN'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
