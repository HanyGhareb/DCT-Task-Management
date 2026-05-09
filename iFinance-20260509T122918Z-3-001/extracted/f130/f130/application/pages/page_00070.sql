prompt --application/pages/page_00070
begin
--   Manifest
--     PAGE: 00070
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
 p_id=>70
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Vendor Bank Accounts'
,p_alias=>'VENDOR-BANK-ACCOUNTS'
,p_step_title=>'Vendor Bank Accounts'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230309065112'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(215385990029566549)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10254567086597785)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(10191147067597728)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(10308621936597827)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(215386558822566549)
,p_plug_name=>'Vendor Bank Accounts'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  rowid,',
'        acc.VENDOR_NUMBER,',
'        (select v.vendor_name',
'        from vendors v',
'        where v.vendor_number = acc.vendor_number',
'        and v.vendor_site_code = acc.vendor_site_code',
'        and rownum = 1) Vendor_name,',
'       acc.VENDOR_SITE_CODE,',
'       acc.BANK_ACCOUNT_NAME,',
'       acc.BANK_NAME,',
'       acc.BANK_ACCOUNT,',
'       acc.IBAN,',
'       acc.ACC_CREATED_BY,',
'       acc.ACC_UPDATED_BY,',
'       acc.ACC_CREATED_0N,',
'       acc.ACC_UPDATED_ON,',
'       acc.ACC_END_DATED',
'  from VENDORS_BANK_ACCOUNTS acc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Vendor Bank Accounts'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(215386649974566549)
,p_name=>'Vendor Bank Accounts'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>255822691803468819
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115049282052385004)
,p_db_column_name=>'VENDOR_NUMBER'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Vendor Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115049679033385007)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115050128777385007)
,p_db_column_name=>'BANK_ACCOUNT_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Bank Account Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115050532726385007)
,p_db_column_name=>'BANK_NAME'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Bank Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115050874600385007)
,p_db_column_name=>'BANK_ACCOUNT'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Bank Account'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115051264839385008)
,p_db_column_name=>'IBAN'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Iban'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115051742172385008)
,p_db_column_name=>'ACC_CREATED_BY'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Acc Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115052146919385008)
,p_db_column_name=>'ACC_UPDATED_BY'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Acc Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115052484518385008)
,p_db_column_name=>'ACC_CREATED_0N'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Acc Created 0n'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115052938232385008)
,p_db_column_name=>'ACC_UPDATED_ON'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Acc Updated On'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115053261991385009)
,p_db_column_name=>'ACC_END_DATED'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Acc End Dated'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115048544404385003)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>21
,p_column_identifier=>'L'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115048875997385003)
,p_db_column_name=>'ROWID'
,p_display_order=>31
,p_column_identifier=>'M'
,p_column_label=>'Rowid'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(215391678983575519)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1554897'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'VENDOR_NUMBER:VENDOR_NAME:VENDOR_SITE_CODE:BANK_ACCOUNT_NAME:BANK_NAME:BANK_ACCOUNT:IBAN:ACC_CREATED_BY:ACC_UPDATED_BY:ACC_CREATED_0N:ACC_UPDATED_ON:ACC_END_DATED::ROWID'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(115054389366385018)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(215385990029566549)
,p_button_name=>'Upload'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Upload'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-cloud-upload'
);
wwv_flow_api.component_end;
end;
/
