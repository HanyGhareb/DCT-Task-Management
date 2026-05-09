prompt --application/shared_components/user_interface/lovs/cwip_users_lov
begin
--   Manifest
--     CWIP USERS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(2439310591362105)
,p_lov_name=>'CWIP USERS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EMPLOYEES_V.FULL_NAME_EN || '' ('' || EMPLOYEES_V.USER_NAME || '')'' as FULL_NAME_EN,',
'    EMPLOYEES_V.USER_NAME as USER_NAME ,',
'    person_id',
' from EMPLOYEES_V EMPLOYEES_V'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'USER_NAME'
,p_display_column_name=>'FULL_NAME_EN'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'FULL_NAME_EN'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(2439765020365175)
,p_query_column_name=>'USER_NAME'
,p_heading=>'User Name'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(2440257035365176)
,p_query_column_name=>'FULL_NAME_EN'
,p_heading=>'Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(2440619426365176)
,p_query_column_name=>'PERSON_ID'
,p_heading=>'Person Id'
,p_display_sequence=>30
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
);
wwv_flow_api.component_end;
end;
/
