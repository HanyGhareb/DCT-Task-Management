prompt --application/shared_components/user_interface/lovs/item_categories_all_display
begin
--   Manifest
--     ITEM CATEGORIES ALL-DISPLAY
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(11362076622127119)
,p_lov_name=>'ITEM CATEGORIES ALL-DISPLAY'
,p_lov_query=>'select CATEGORY_NAME ,CATEGORY_ID  from dp_item_categories;'
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'CATEGORY_ID'
,p_display_column_name=>'CATEGORY_NAME'
,p_default_sort_column_name=>'CATEGORY_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
