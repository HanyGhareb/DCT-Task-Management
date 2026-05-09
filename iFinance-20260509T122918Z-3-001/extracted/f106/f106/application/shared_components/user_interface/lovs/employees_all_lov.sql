prompt --application/shared_components/user_interface/lovs/employees_all_lov
begin
--   Manifest
--     EMPLOYEES ALL LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(48056159040127691)
,p_lov_name=>'EMPLOYEES ALL LOV'
,p_reference_id=>68675421613580604
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select full_name_en  , ',
'        person_id ',
'from employees_v;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PERSON_ID'
,p_display_column_name=>'FULL_NAME_EN'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
