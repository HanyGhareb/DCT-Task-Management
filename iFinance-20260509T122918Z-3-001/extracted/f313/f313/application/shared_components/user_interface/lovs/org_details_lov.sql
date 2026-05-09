prompt --application/shared_components/user_interface/lovs/org_details_lov
begin
--   Manifest
--     ORG DETAILS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>145171879539529295
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(25220923598855056)
,p_lov_name=>'ORG DETAILS LOV'
,p_reference_id=>19334784122615502
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select org_name || '' ('' || org_level || '') ''  organization, ',
'        org_id , ',
'        department_name , ',
'        sector ,',
'        (select s.short_name_en',
'            from dct_hr_organizations s',
'            where s.org_name_en = organizations_details_v.sector',
'            and ROWNUM = 1)  sector_code',
'from organizations_details_v',
'order by sector , department_name, org_name;    '))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ORG_ID'
,p_display_column_name=>'ORGANIZATION'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(25225063427855052)
,p_query_column_name=>'ORG_ID'
,p_heading=>'ORG ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(25225462520855052)
,p_query_column_name=>'ORGANIZATION'
,p_heading=>'Organization'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(25225870280855052)
,p_query_column_name=>'DEPARTMENT_NAME'
,p_heading=>'Department'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(25226238818855052)
,p_query_column_name=>'SECTOR'
,p_heading=>'Sector'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(25226670262855051)
,p_query_column_name=>'SECTOR_CODE'
,p_heading=>'Sector Code'
,p_display_sequence=>50
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
