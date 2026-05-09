prompt --application/pages/page_00092
begin
--   Manifest
--     PAGE: 00092
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
 p_id=>92
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'DP Bidder List Report'
,p_alias=>'DP-BIDDER-LIST-REPORT'
,p_step_title=>'DP Bidder List Report'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240229123051'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(372501653247065394)
,p_plug_name=>'APPENDIX D - PRICING SCHEDULE (BOQ)'
,p_region_template_options=>'#DEFAULT#:t-Wizard--showTitle:t-Wizard--hideStepsXSmall'
,p_component_template_options=>'js-wizardProgressLinks:t-WizardSteps--displayLabels'
,p_plug_template=>wwv_flow_api.id(127814120729449775)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(137979330732452596)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(127843097216449755)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(502676341046561703)
,p_plug_name=>'DP Bidder List Report'
,p_parent_plug_id=>wwv_flow_api.id(372501653247065394)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ITEM_ID,',
'       NEW_VENDOR_YN,',
'       RECOMMENDED_VENDOR_NUM,',
'       RECOMMENDED_VENDOR_SITE_CODE,',
'       RECOMMENDED_VENDOR_NAME,',
'       SN,',
'       LOCATION,',
'       CONTACT_NAME,',
'       CONTACT_EMAIL,',
'       EOI_STATUS,',
'       LICENSE_VERIFICATION,',
'       SIGNED_COC,',
'       NDA,',
'       ICV_STATUS,',
'       STATUS,',
'       NOTES,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON',
'  from DP_BIDDER_LIST',
'  where item_id = :P28_DP_ITEM_ID',
'  order by SN'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_DP_ITEM_ID,P92_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'DP Bidder List Report'
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
 p_id=>wwv_flow_api.id(502675936488561704)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_rows_per_page=>'N'
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
,p_show_help=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:93:&SESSION.::&DEBUG.:RP:P93_ID:\#ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in(''Draft'' , ''Return'')'
,p_owner=>'TCA9051'
,p_internal_uid=>234489719985668095
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502675831489561707)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502675439569561715)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502675012349561715)
,p_db_column_name=>'NEW_VENDOR_YN'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Registered'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502674558756561715)
,p_db_column_name=>'RECOMMENDED_VENDOR_NUM'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Vendor'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(502605696250783149)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502674166040561715)
,p_db_column_name=>'RECOMMENDED_VENDOR_SITE_CODE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502673855713561716)
,p_db_column_name=>'RECOMMENDED_VENDOR_NAME'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502673443081561716)
,p_db_column_name=>'SN'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'NO'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502672969208561716)
,p_db_column_name=>'LOCATION'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Location'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502672628371561716)
,p_db_column_name=>'CONTACT_NAME'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Contact Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502672191778561716)
,p_db_column_name=>'CONTACT_EMAIL'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Contact Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502671785210561717)
,p_db_column_name=>'EOI_STATUS'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'EOI Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128342850308489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502671431729561717)
,p_db_column_name=>'LICENSE_VERIFICATION'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'License Verification'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502671047965561721)
,p_db_column_name=>'SIGNED_COC'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Signed Code of Conduct'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502670615829561721)
,p_db_column_name=>'NDA'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'NDA'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502670203770561722)
,p_db_column_name=>'ICV_STATUS'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'ICV Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128342850308489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502669806155561722)
,p_db_column_name=>'STATUS'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128342850308489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502669361559561722)
,p_db_column_name=>'NOTES'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502669054842561722)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502668624743561722)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502668184454561723)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(502667777243561723)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(502656538391609431)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2345092'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SN:NEW_VENDOR_YN:RECOMMENDED_VENDOR_NUM:RECOMMENDED_VENDOR_SITE_CODE:RECOMMENDED_VENDOR_NAME:LOCATION:CONTACT_NAME:CONTACT_EMAIL:EOI_STATUS:LICENSE_VERIFICATION:SIGNED_COC:NDA:ICV_STATUS:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(374992239488636785)
,p_plug_name=>'Demand Planning Item Details &P92_SCOPE_CODE.'
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>1
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(502655348016616983)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(372501653247065394)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865952197449732)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(502654887734616985)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(372501653247065394)
,p_button_name=>'NEXT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_icon_css_classes=>'fa-chevron-right'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(502654515852616987)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(372501653247065394)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865952197449732)
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(502654083678616987)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(372501653247065394)
,p_button_name=>'PREVIOUS'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Previous'
,p_button_position=>'REGION_TEMPLATE_PREVIOUS'
,p_button_execute_validations=>'N'
,p_icon_css_classes=>'fa-chevron-left'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(502666400833561728)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(502676341046561703)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:93:&SESSION.::&DEBUG.:93:P93_ITEM_ID:&P28_DP_ITEM_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in(''Draft'' , ''Return'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(502653708589616990)
,p_name=>'P92_SCOPE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(372501653247065394)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(502653329604616995)
,p_name=>'P92_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(372501653247065394)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(502652894529616995)
,p_name=>'P92_TEMPLATE_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(372501653247065394)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(502652500911616995)
,p_name=>'P92_ITEM_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(372501653247065394)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(502652072401616996)
,p_name=>'P92_SUB_CATEGORY_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(372501653247065394)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(502630816887688050)
,p_name=>'P92_SCOPE_CODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(374992239488636785)
,p_prompt=>'Scoping Document Code'
,p_source=>'P28_SCOPE_CODE'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(502630367925688051)
,p_name=>'P92_APPROVAL_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(374992239488636785)
,p_prompt=>'Approval Status'
,p_source=>'P28_APPROVAL_STATUS'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(502629974513688051)
,p_name=>'P92_TEMPLATE_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(374992239488636785)
,p_prompt=>'Template Name'
,p_source=>'P28_TEMPLATE_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'SCOPING TEMPLATES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DP_SCOPE_TEMPLATES.TEMPLATE_NAME as TEMPLATE_NAME ,',
'    DP_SCOPE_TEMPLATES.TEMPLATE_ID as TEMPLATE_ID',
' from DP_SCOPE_TEMPLATES DP_SCOPE_TEMPLATES',
' where status = ''A''',
' and sysdate between nvl(start_date , sysdate -10) and nvl(end_date , sysdate +10)'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(502629609000688052)
,p_name=>'P92_REVIEW_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(374992239488636785)
,p_prompt=>'Review Status'
,p_source=>'P28_REVIEW_STATUS'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(502629210212688052)
,p_name=>'P92_PROCUREMENT_METHOD'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(374992239488636785)
,p_prompt=>'Procurement Method'
,p_source=>'P92_PROCUREMENT_METHOD'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'DP PROCUREMENT METHOD-ALL'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select TENDER_TYPE , ID',
' from DP_PROCUREMENT_METHOD'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(502667415620561723)
,p_name=>'Edit Report - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(502676341046561703)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(502666877226561727)
,p_event_id=>wwv_flow_api.id(502667415620561723)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(502676341046561703)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(502628737281693087)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Details Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DP_ITEMS_UTIL.get_dp_procurement_method_class_id(dp_procurement_method) ,',
'        DP_ITEMS_UTIL.get_dp_procurement_method_id(ITEM_ID) ',
'into    ',
'    :P92_PROCUREMENT_METHOD_CLASS_ID,',
'    :P92_PROCUREMENT_METHOD',
'from dp_items',
'where item_id = :P28_DP_ITEM_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
