prompt --application/shared_components/user_interface/lovs/item_main_categories_lov
begin
--   Manifest
--     ITEM MAIN CATEGORIES LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(128449582832098954)
,p_lov_name=>'ITEM MAIN CATEGORIES LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 231 ;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'CATEGORY_ID'
,p_display_column_name=>'CATEGORY_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'CATEGORY_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(4272432226291298)
,p_query_column_name=>'CATEGORY_NAME'
,p_heading=>'Category Name'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
