prompt --application/shared_components/user_interface/lovs/gift_cards_categories
begin
--   Manifest
--     GIFT CARDS CATEGORIES
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
 p_id=>wwv_flow_api.id(116571414771827940)
,p_lov_name=>'GIFT CARDS CATEGORIES'
,p_lov_query=>'select GIFT_CARDS_CATEGORY_ID, CATEGORY_NAME, CATEGORY_VALUE ,CATEGORY_FEES_VALUE from GIFT_CARDS_CATEGORIES;'
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'GIFT_CARDS_CATEGORY_ID'
,p_display_column_name=>'CATEGORY_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'CATEGORY_VALUE'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
