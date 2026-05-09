prompt --application/pages/page_00090
begin
--   Manifest
--     PAGE: 00090
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>90
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'Search Item Category'
,p_alias=>'SEARCH-ITEM-CATEGORY'
,p_page_mode=>'MODAL'
,p_step_title=>'Search Item Category'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch:t-Dialog--noPadding'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240101234249'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(299394088470939008)
,p_plug_name=>'Categories'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select APEX_ITEM.RADIOGROUP (1,CATEGORY_ID) selected',
'     , CATEGORY_ID CATEGORY_ID3 ',
'     , CATEGORY_NAME CATEGORY_NAME3 ',
'     , CATEGORY_DESCRIPTION ',
'     , PARENT_CATEGORY_ID CATEGORY_ID2',
'     , DP_ITEMS_UTIL.get_item_category_name(PARENT_CATEGORY_ID)      CATEGORY_NAME2',
'     , DP_ITEMS_UTIL.get_parent_item_category_ID(PARENT_CATEGORY_ID) CATEGORY_ID1',
'     , DP_ITEMS_UTIL.get_item_category_name(DP_ITEMS_UTIL.get_parent_item_category_ID(PARENT_CATEGORY_ID))      CATEGORY_NAME1',
'from dp_item_categories',
'where 1=1',
'--and PARENT_CATEGORY_ID = :P10_CATEGORY_ID',
'and status = ''A''',
'and sysdate between nvl(START_DATE , sysdate - 10 ) and nvl(END_DATE , sysdate + 10)',
'and ORDER_LEVEL = 233',
'order by CATEGORY_NAME;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Categories'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(299642314050655629)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'NONE'
,p_show_detail_link=>'N'
,p_show_select_columns=>'N'
,p_show_rows_per_page=>'N'
,p_show_filter=>'N'
,p_show_sort=>'N'
,p_show_control_break=>'N'
,p_show_highlight=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_show_download=>'N'
,p_show_help=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>217872661930713615
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(299641556829655621)
,p_db_column_name=>'SELECTED'
,p_display_order=>10
,p_column_identifier=>'H'
,p_column_label=>'Select'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(299642235677655628)
,p_db_column_name=>'CATEGORY_ID3'
,p_display_order=>20
,p_column_identifier=>'A'
,p_column_label=>'Category Id3'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(299642165824655627)
,p_db_column_name=>'CATEGORY_NAME3'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Category Level 3'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(299642062149655626)
,p_db_column_name=>'CATEGORY_DESCRIPTION'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Category Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(299641910817655625)
,p_db_column_name=>'CATEGORY_ID2'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Category Id2'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(299641869859655624)
,p_db_column_name=>'CATEGORY_NAME2'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Category Level 2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(299641721244655623)
,p_db_column_name=>'CATEGORY_ID1'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'Category Id1'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(299641632299655622)
,p_db_column_name=>'CATEGORY_NAME1'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Category Level 1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(298143952841626641)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2193711'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SELECTED:CATEGORY_NAME3:CATEGORY_DESCRIPTION:CATEGORY_NAME2:CATEGORY_NAME1:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(517494133241319817)
,p_report_id=>wwv_flow_api.id(298143952841626641)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'CATEGORY_NAME1'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("CATEGORY_NAME1" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#EBE38D'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(517493755961319817)
,p_report_id=>wwv_flow_api.id(298143952841626641)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'CATEGORY_NAME2'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("CATEGORY_NAME2" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#A1F0DC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(517493259821319817)
,p_report_id=>wwv_flow_api.id(298143952841626641)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'CATEGORY_NAME3'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("CATEGORY_NAME3" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#C1BCE0'
);
wwv_flow_api.component_end;
end;
/
