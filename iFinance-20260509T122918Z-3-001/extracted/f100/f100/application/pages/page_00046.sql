prompt --application/pages/page_00046
begin
--   Manifest
--     PAGE: 00046
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>46
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'Vendor Bank Accounts'
,p_alias=>'VENDOR-BANK-ACCOUNTS'
,p_step_title=>'Vendor Bank Accounts'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220317105534'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(100338462644181571)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1611180433302287)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(1547752126302241)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(1665264360302322)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(100339031437181571)
,p_plug_name=>'Vendor Bank Accounts'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1599843476302282)
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
 p_id=>wwv_flow_api.id(100339122589181571)
,p_name=>'Vendor Bank Accounts'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:47:&SESSION.::&DEBUG.::P47_ROWID:#ROWID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>100339122589181571
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(100339529321181573)
,p_db_column_name=>'VENDOR_NUMBER'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Vendor Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(100339943333181574)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(100340302751181574)
,p_db_column_name=>'BANK_ACCOUNT_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Bank Account Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(100340734274181574)
,p_db_column_name=>'BANK_NAME'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Bank Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(100341166789181574)
,p_db_column_name=>'BANK_ACCOUNT'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Bank Account'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(100341505118181574)
,p_db_column_name=>'IBAN'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Iban'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(100341955752181575)
,p_db_column_name=>'ACC_CREATED_BY'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Acc Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(100342311523181575)
,p_db_column_name=>'ACC_UPDATED_BY'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Acc Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(100342799548181575)
,p_db_column_name=>'ACC_CREATED_0N'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Acc Created 0n'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(100343102970181575)
,p_db_column_name=>'ACC_UPDATED_ON'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Acc Updated On'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(100343509776181575)
,p_db_column_name=>'ACC_END_DATED'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Acc End Dated'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99302583928685805)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>21
,p_column_identifier=>'L'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99302662172685806)
,p_db_column_name=>'ROWID'
,p_display_order=>31
,p_column_identifier=>'M'
,p_column_label=>'Rowid'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(100344151598190541)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1003442'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'VENDOR_NUMBER:VENDOR_NAME:VENDOR_SITE_CODE:BANK_ACCOUNT_NAME:BANK_NAME:BANK_ACCOUNT:IBAN:ACC_CREATED_BY:ACC_UPDATED_BY:ACC_CREATED_0N:ACC_UPDATED_ON:ACC_END_DATED::ROWID'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(99302461132685804)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(100338462644181571)
,p_button_name=>'Upload'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(1663977999302321)
,p_button_image_alt=>'Upload'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-cloud-upload'
);
wwv_flow_api.component_end;
end;
/
