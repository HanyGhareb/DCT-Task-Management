prompt --application/pages/page_00066
begin
--   Manifest
--     PAGE: 00066
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>66
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Vendor Details'
,p_alias=>'VENDOR-DETAILS'
,p_page_mode=>'MODAL'
,p_step_title=>'Vendor Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch:t-Dialog--noPadding'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220926203608'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(89121580306993606)
,p_plug_name=>'Vendor Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(89121990473993606)
,p_plug_name=>'Bank Accounts'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(89123425198990335)
,p_plug_name=>'Bank Accounts Report'
,p_parent_plug_id=>wwv_flow_api.id(89121990473993606)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    vendor_number,',
'    vendor_site_code,',
'    bank_account_name,',
'    bank_name,',
'    bank_account,',
'    iban,',
'    acc_created_by,',
'    acc_updated_by,',
'    acc_created_0n,',
'    acc_updated_on,',
'    acc_end_dated',
'FROM',
'    vendors_bank_accounts',
'where vendor_site_code = NVL(:P66_VENDOR_SITE_CODE,vendor_site_code)',
'and vendor_number = NVL(:P66_VENDOR_NUMBER,vendor_number)',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P66_VENDOR_SITE_CODE,P66_VENDOR_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Bank Accounts Report'
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
 p_id=>wwv_flow_api.id(89123510841990336)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>129559552670892606
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89123568610990337)
,p_db_column_name=>'VENDOR_NUMBER'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Vendor Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89123705725990338)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89123796277990339)
,p_db_column_name=>'BANK_ACCOUNT_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Bank Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89123900148990340)
,p_db_column_name=>'BANK_NAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Bank Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89123994799990341)
,p_db_column_name=>'BANK_ACCOUNT'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Bank Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89124090357990342)
,p_db_column_name=>'IBAN'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'IBAN'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89124204908990343)
,p_db_column_name=>'ACC_CREATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89124270574990344)
,p_db_column_name=>'ACC_UPDATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89124378978990345)
,p_db_column_name=>'ACC_CREATED_0N'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Created 0n'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89124474907990346)
,p_db_column_name=>'ACC_UPDATED_ON'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated On'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(89124592065990347)
,p_db_column_name=>'ACC_END_DATED'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'End Dated'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(89135176529827814)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1295713'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'VENDOR_NUMBER:VENDOR_SITE_CODE:BANK_ACCOUNT_NAME:BANK_NAME:BANK_ACCOUNT:IBAN:ACC_CREATED_BY:ACC_UPDATED_BY:ACC_CREATED_0N:ACC_UPDATED_ON:ACC_END_DATED'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(89122420296993606)
,p_plug_name=>'Contacts'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89123026460990331)
,p_name=>'P66_VENDOR_NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(89121580306993606)
,p_prompt=>'Vendor Number'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89123092471990332)
,p_name=>'P66_VENDOR_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(89121580306993606)
,p_prompt=>'Vendor Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89123233481990333)
,p_name=>'P66_VENDOR_SITE_CODE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(89121580306993606)
,p_prompt=>'Vendor Site Code'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89123272069990334)
,p_name=>'P66_TRN_NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(89121580306993606)
,p_prompt=>'TRN Number'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(89026969980455380)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Vendor Details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    vendor_number,',
'    vendor_name,',
'    vendor_site_code,',
'    trn_number',
'INTO',
'    :P66_VENDOR_NUMBER,',
'    :P66_VENDOR_NAME,',
'    :P66_VENDOR_SITE_CODE,',
'    :P66_TRN_NUMBER',
'FROM    vendors',
'where vendor_name = NVL(:P66_VENDOR_NAME,vendor_name)',
'and vendor_site_code = NVL(:P66_VENDOR_SITE_CODE,vendor_site_code)',
'and vendor_number = NVL(:P66_VENDOR_NUMBER,vendor_number)',
'and rownum = 1',
';'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
