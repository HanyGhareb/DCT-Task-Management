prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>100034894930602818
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>3
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Select PO and Receiving for Payment request lines'
,p_alias=>'SELECT-PO-AND-RECEIVING-FOR-PAYMENT-REQUEST-LINES'
,p_page_mode=>'MODAL'
,p_step_title=>'Select PO and Receiving for Payment request lines'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220321111902'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1003258557173987)
,p_plug_name=>'Select'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(575273604419919)
,p_plug_name=>'Lines '
,p_parent_plug_id=>wwv_flow_api.id(1003258557173987)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'--    receipt_key,',
'    apex_item.checkbox2(1,r.receipt_key) Selected,',
'    receipt_num,',
'    transaction_date,',
'    transaction_type,',
'    vendor_name,',
'--    vendor_type,',
'    vendor_site_code,',
'    po_number,',
'    po_line_num,',
'    shipment_num,',
'    need_by_date,',
'    project_number,',
'    task_number,',
'    expenditure_type,',
'    employee_name,',
'    entity_code,',
'    cost_center_code,',
'    budget_group_code,',
'    account_code,',
'    activity_code,',
'    future1,',
'    future2,',
'    creation_date,',
'--    currency_conversion_date,',
'--    currency_conversion_rate,',
'    currency_code,',
'    amount,',
'    functionl_amount,',
'    quantity',
'--    organization_number',
'FROM    receiving r',
'where vendor_name = nvl((Select v.vendor_name',
'                        from vendors v ',
'                        where v.vendor_number = :P3_VENDOR_NUMBER',
'                        and v.vendor_site_code = :P3_VENDOR_SITE_CODE), vendor_name)',
'and r.po_number = nvl(:P3_PO_NUMBER , r.po_number) ',
'and r.receipt_num = nvl(:P3_RECEIPT_NUMBER , r.receipt_num)',
'and r.currency_code = nvl(:P3_CURRENCY , r.currency_code)',
'order by RECEIPT_NUM desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P3_VENDOR_NUMBER,P3_VENDOR_SITE_CODE,P3_PO_NUMBER,P3_RECEIPT_NUMBER,P3_CURRENCY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Lines '
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
 p_id=>wwv_flow_api.id(575482442419921)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>100610377373022739
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(575594884419922)
,p_db_column_name=>'SELECTED'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Selected'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(575648489419923)
,p_db_column_name=>'RECEIPT_NUM'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Receipt Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(575730043419924)
,p_db_column_name=>'TRANSACTION_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Transaction Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(575837168419925)
,p_db_column_name=>'TRANSACTION_TYPE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Transaction Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(575994457419926)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(576092263419927)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Vendor Site'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(576146640419928)
,p_db_column_name=>'PO_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'PO Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(576221491419929)
,p_db_column_name=>'PO_LINE_NUM'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'PO Line'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(576403711419930)
,p_db_column_name=>'SHIPMENT_NUM'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Shipment '
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(576492801419931)
,p_db_column_name=>'NEED_BY_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Need By Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(576598017419932)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1004452084187483)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1004577333187484)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1004645618187485)
,p_db_column_name=>'EMPLOYEE_NAME'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Employee'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1004712952187486)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1004806994187487)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1004961866187488)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1005011855187489)
,p_db_column_name=>'ACCOUNT_CODE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1005190430187490)
,p_db_column_name=>'ACTIVITY_CODE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1005294752187491)
,p_db_column_name=>'FUTURE1'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1005371148187492)
,p_db_column_name=>'FUTURE2'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1005453599187493)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1005515204187494)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Currency '
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1005693106187495)
,p_db_column_name=>'AMOUNT'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1005718737187496)
,p_db_column_name=>'FUNCTIONL_AMOUNT'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Functionl Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1005813429187497)
,p_db_column_name=>'QUANTITY'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Quantity'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1020175799200802)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1010551'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>10
,p_report_columns=>'SELECTED:RECEIPT_NUM:PO_NUMBER:PO_LINE_NUM:SHIPMENT_NUM:TRANSACTION_DATE:PROJECT_NUMBER:TASK_NUMBER:EMPLOYEE_NAME:CURRENCY_CODE:AMOUNT:FUNCTIONL_AMOUNT:QUANTITY:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1007584570187514)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(575273604419919)
,p_button_name=>'Add'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_icon_css_classes=>'fa-window-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1007683694187515)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(575273604419919)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Close'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1006865150187507)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(1003258557173987)
,p_button_name=>'Search'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--simple:t-Button--gapRight:t-Button--gapBottom'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Search'
,p_button_position=>'TOP'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1006988701187508)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(1003258557173987)
,p_button_name=>'Clear'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Clear'
,p_button_position=>'TOP'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1008021751187519)
,p_branch_name=>'go to 2'
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::P2_PAYMENT_REQUEST_ID:&P3_PAYMENT_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1006276009187501)
,p_name=>'P3_PAYMENT_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(1003258557173987)
,p_prompt=>'Payment Request Id'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1006314228187502)
,p_name=>'P3_VENDOR_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(1003258557173987)
,p_prompt=>'Vendor'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'VENDORS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select vendors.vendor_name , Vendor_site_code , vendor_number',
'from vendors',
'where vendor_site_status = ''Active'''))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1006470342187503)
,p_name=>'P3_VENDOR_SITE_CODE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(1003258557173987)
,p_prompt=>'Vendor Site'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1006595929187504)
,p_name=>'P3_PO_NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(1003258557173987)
,p_prompt=>'PO Number'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1006696412187505)
,p_name=>'P3_RECEIPT_NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(1003258557173987)
,p_prompt=>'Receipt Number'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1006766625187506)
,p_name=>'P3_CURRENCY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(1003258557173987)
,p_item_default=>'AED'
,p_prompt=>'Currency'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1007053493187509)
,p_name=>'GO DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(1006865150187507)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1007125697187510)
,p_event_id=>wwv_flow_api.id(1007053493187509)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(575273604419919)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1007244696187511)
,p_name=>'Clear DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(1006988701187508)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1007402032187512)
,p_event_id=>wwv_flow_api.id(1007244696187511)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_PO_NUMBER,P3_RECEIPT_NUMBER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1007733883187516)
,p_name=>'Close DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(1007683694187515)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1007869956187517)
,p_event_id=>wwv_flow_api.id(1007733883187516)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1007475079187513)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'insert new lines process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'',
'l_count                 NUMBER := apex_application.g_f01.count;',
'',
'Begin',
'  IF l_count = 0 THEN',
'                    apex_error.add_error(p_message => ''Please select at least one receipt! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'  else',
'       FOR i IN 1..l_count LOOP',
'    -- insert selected line',
'                INSERT INTO payment_request_lines (',
'                payment_request_id,',
'                po_available_yn,',
'                po_number,',
'                po_line_num,',
'                shipment_num,',
'                receiving_number,',
'                amount,',
'                entity_code,',
'                cost_center,',
'                budget_group_code,',
'                gl_account,',
'                activity,',
'                future1,',
'                future2,',
'                project_number,',
'                task_number,',
'                expenditure_type,',
'                RECEIPT_KEY',
'            ) ',
'            SELECT  ',
'                :P3_PAYMENT_REQUEST_ID,',
'                ''Y'',',
'                po_number,',
'                po_line_num,',
'                shipment_num,   ',
'                receipt_num,',
'                amount,',
'                entity_code,',
'                cost_center_code,',
'                budget_group_code,',
'                account_code,',
'                activity_code,',
'                future1,',
'                future2,',
'                project_number,',
'                task_number,',
'                expenditure_type,',
'                apex_application.g_f01(i)',
'            FROM',
'                receiving',
'            where receipt_key = apex_application.g_f01(i);',
'      END LOOP;',
' End if;',
'',
'End;',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(1007584570187514)
);
wwv_flow_api.component_end;
end;
/
