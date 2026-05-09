prompt --application/shared_components/user_interface/lovs/item_sub_cstegories_popup
begin
--   Manifest
--     ITEM SUB_CSTEGORIES POPUP
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
 p_id=>wwv_flow_api.id(4611017499531974)
,p_lov_name=>'ITEM SUB_CSTEGORIES POPUP'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_ID  , CATEGORY_NAME ,CATEGORY_DESCRIPTION ',
'from dp_item_categories',
'where PARENT_CATEGORY_ID = :P10_CATEGORY_ID',
'and status = ''A''',
'and sysdate between nvl(START_DATE , sysdate - 10 ) and nvl(END_DATE , sysdate + 10)'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'CATEGORY_ID'
,p_display_column_name=>'CATEGORY_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'CATEGORY_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(4611353161533575)
,p_query_column_name=>'CATEGORY_NAME'
,p_heading=>'Category Name'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(5380322293495187)
,p_query_column_name=>'CATEGORY_DESCRIPTION'
,p_heading=>'Category Description'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(5380703178495187)
,p_query_column_name=>'CATEGORY_ID'
,p_display_sequence=>20
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.component_end;
end;
/
