prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>118
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>11
,p_user_interface_id=>wwv_flow_api.id(122997627648781606)
,p_name=>'Customer outstanding Report'
,p_alias=>'CUSTOMER-OUTSTANDING-REPORT'
,p_step_title=>'Customer outstanding Report'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230509102649'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(156911134942059187)
,p_plug_name=>'Customer outstanding Report'
,p_region_name=>'USERS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(122911181767781667)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ar.CUSTOMER_NAME,',
'       ar.ACCOUNT_NUM,',
'       ar.CUSTOMER_NUM,',
'       ar.EMAIL1,',
'       ar.EMAIL2,',
'       ar.EMAIL3,',
'       ar.EMAIL4,',
'       ar.DELAY_PENALTY,',
'       ar.TOURISM_FEES ,',
'       count(rem.id) reminder_count',
'  from AR_CUSTOMERS_OUTSTANDING ar, ar_transactions_reminders rem',
'  where ar.account_num = rem.ACOOUNT_NUMBER (+)',
'  group by ar.CUSTOMER_NAME,',
'       ar.ACCOUNT_NUM,',
'       ar.CUSTOMER_NUM,',
'       ar.EMAIL1,',
'       ar.EMAIL2,',
'       ar.EMAIL3,',
'       ar.EMAIL4,',
'       ar.DELAY_PENALTY,',
'       ar.TOURISM_FEES;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Customer outstanding Report'
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
 p_id=>wwv_flow_api.id(156911510372059187)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.::P20_ACCOUNT_NUM:\#ACCOUNT_NUM#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>156911510372059187
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156912404603059191)
,p_db_column_name=>'CUSTOMER_NUM'
,p_display_order=>10
,p_column_identifier=>'C'
,p_column_label=>'Customer Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156911696293059189)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>20
,p_column_identifier=>'A'
,p_column_label=>'Customer Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156912061625059190)
,p_db_column_name=>'ACCOUNT_NUM'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Account Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156912808860059191)
,p_db_column_name=>'EMAIL1'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Email 1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156913272294059191)
,p_db_column_name=>'EMAIL2'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Email 2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156913633205059191)
,p_db_column_name=>'EMAIL3'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Email 3'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156914080481059192)
,p_db_column_name=>'EMAIL4'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Email 4'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(154993506707789346)
,p_db_column_name=>'DELAY_PENALTY'
,p_display_order=>80
,p_column_identifier=>'I'
,p_column_label=>'Delay Penalty'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(154993625337789347)
,p_db_column_name=>'TOURISM_FEES'
,p_display_order=>90
,p_column_identifier=>'J'
,p_column_label=>'Tourism Fees'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156781124417174447)
,p_db_column_name=>'REMINDER_COUNT'
,p_display_order=>100
,p_column_identifier=>'K'
,p_column_label=>'Reminder Count'
,p_column_link=>'f?p=&APP_ID.:18:&SESSION.::&DEBUG.::P18_ACCOUNT_NUM:#ACCOUNT_NUM#'
,p_column_linktext=>'#REMINDER_COUNT#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(156918929146061077)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1569190'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CUSTOMER_NAME:ACCOUNT_NUM:CUSTOMER_NUM:EMAIL1:EMAIL2:EMAIL3:EMAIL4:DELAY_PENALTY:TOURISM_FEES:APXWS_CC_001:REMINDER_COUNT'
,p_sum_columns_on_break=>'TOTAL_AMOUNT'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(157043174630732043)
,p_report_id=>wwv_flow_api.id(156918929146061077)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'I + J'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total'
,p_report_label=>'Total'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(156916678414059202)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(122922476001781663)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(122859041536781706)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(122976593233781628)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(165926180989527850)
,p_plug_name=>'Download a Template'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(122896014873781677)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p>to get the template <a href="#APP_IMAGES#Upload_Template.xlsx">Click Here</a></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(154992434616789335)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(156916678414059202)
,p_button_name=>'Upload'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(122975280422781629)
,p_button_image_alt=>'Upload'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-upload'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(157190954557961613)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(156916678414059202)
,p_button_name=>'Clear'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(122975280422781629)
,p_button_image_alt=>'Clear'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-trash-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(154992544558789336)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(156916678414059202)
,p_button_name=>'Send_Reminder'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(122975280422781629)
,p_button_image_alt=>'Send Reminder'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13::'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(156917868619059204)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(156916678414059202)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(122975280422781629)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(156915533309059199)
,p_name=>'Edit Report - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(156911134942059187)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(156916089637059200)
,p_event_id=>wwv_flow_api.id(156915533309059199)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(156911134942059187)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(154992634604789337)
,p_name=>'Reminder DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(154992544558789336)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(154992743188789338)
,p_event_id=>wwv_flow_api.id(154992634604789337)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess( "Reminder Emails Sent Successfully." );'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(157191088106961614)
,p_name=>'Clear DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(157190954557961613)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(157191108827961615)
,p_event_id=>wwv_flow_api.id(157191088106961614)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to clear all Hotels outstanding data, Are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(157191235850961616)
,p_event_id=>wwv_flow_api.id(157191088106961614)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'delete  from AR_CUSTOMERS_OUTSTANDING;'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(157191356862961617)
,p_event_id=>wwv_flow_api.id(157191088106961614)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Hotels outstanding data cleared Successfully. '
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(157191412152961618)
,p_event_id=>wwv_flow_api.id(157191088106961614)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.component_end;
end;
/
