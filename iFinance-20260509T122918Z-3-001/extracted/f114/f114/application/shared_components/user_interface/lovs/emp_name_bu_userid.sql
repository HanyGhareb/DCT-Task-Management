prompt --application/shared_components/user_interface/lovs/emp_name_bu_userid
begin
--   Manifest
--     EMP NAME BU USERID
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>114
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(55840792700881325)
,p_lov_name=>'EMP NAME BU USERID'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.full_name_en , e.user_id',
'from dct_employees_list2 e'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'USER_ID'
,p_display_column_name=>'FULL_NAME_EN'
,p_default_sort_column_name=>'FULL_NAME_EN'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
