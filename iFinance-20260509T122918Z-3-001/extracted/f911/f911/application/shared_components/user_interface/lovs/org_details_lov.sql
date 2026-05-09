prompt --application/shared_components/user_interface/lovs/org_details_lov
begin
--   Manifest
--     ORG DETAILS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(24140385314244793)
,p_lov_name=>'ORG DETAILS LOV'
,p_reference_id=>42999219987884720
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
 p_id=>wwv_flow_api.id(24144441804244789)
,p_query_column_name=>'ORG_ID'
,p_heading=>'ORG ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24144889351244789)
,p_query_column_name=>'ORGANIZATION'
,p_heading=>'Organization'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24145246180244789)
,p_query_column_name=>'DEPARTMENT_NAME'
,p_heading=>'Department'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24145611289244789)
,p_query_column_name=>'SECTOR'
,p_heading=>'Sector'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(24146051478244788)
,p_query_column_name=>'SECTOR_CODE'
,p_heading=>'Sector Code'
,p_display_sequence=>50
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
