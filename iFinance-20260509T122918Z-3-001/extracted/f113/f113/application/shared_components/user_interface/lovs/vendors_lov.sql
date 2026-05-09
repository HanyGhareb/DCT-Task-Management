prompt --application/shared_components/user_interface/lovs/vendors_lov
begin
--   Manifest
--     VENDORS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>100034894930602818
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(62885997171801)
,p_lov_name=>'VENDORS LOV'
,p_reference_id=>53021573465325264
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select vendors.vendor_name , Vendor_site_code , vendor_number',
'from vendors',
'where vendor_site_status = ''Active'''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'VENDOR_NUMBER'
,p_display_column_name=>'VENDOR_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'VENDOR_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(65584551171802)
,p_query_column_name=>'VENDOR_NUMBER'
,p_heading=>'Vendor Number'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(65943475171802)
,p_query_column_name=>'VENDOR_NAME'
,p_heading=>'Vendor Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(66360119171803)
,p_query_column_name=>'VENDOR_SITE_CODE'
,p_heading=>'Vendor Site Code'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
