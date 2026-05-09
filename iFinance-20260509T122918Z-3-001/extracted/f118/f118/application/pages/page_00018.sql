prompt --application/pages/page_00018
begin
--   Manifest
--     PAGE: 00018
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
 p_id=>18
,p_user_interface_id=>wwv_flow_api.id(122997627648781606)
,p_name=>'Customer Reminders Track'
,p_alias=>'CUSTOMER-REMINDERS-TRACK'
,p_step_title=>'Customer Reminders Track'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230321035422'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(157170665699874978)
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
 p_id=>wwv_flow_api.id(157171236120874979)
,p_plug_name=>'Customer Reminders Track'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(122911181767781667)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ACOOUNT_NUMBER,',
'       CUSTOMER_NAME,',
'       TRANSACTION_NUMBER,',
'       DELAY_FEES,',
'       TOURISM_FEES,',
'       SENT_ON,',
'       SENT_BY,',
'       SUBJECT,',
'       SENT_TO,',
'       SENT_CC,',
'       SENT_BCC,',
'       COMMENTS',
'  from AR_TRANSACTIONS_REMINDERS',
'  WHERE ACOOUNT_NUMBER = :P18_ACCOUNT_NUM'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P18_ACCOUNT_NUM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Customer Reminders Track'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(157171308296874979)
,p_name=>'Customer Reminders Track'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>157171308296874979
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157171784172874982)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157172166697874982)
,p_db_column_name=>'ACOOUNT_NUMBER'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Acoount Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157172516995874983)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Customer Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157172979941874983)
,p_db_column_name=>'TRANSACTION_NUMBER'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Transaction Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157173325400874983)
,p_db_column_name=>'DELAY_FEES'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Delay Fees'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157173749699874983)
,p_db_column_name=>'TOURISM_FEES'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Tourism Fees'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157174129477874983)
,p_db_column_name=>'SENT_ON'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Sent On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157174509314874984)
,p_db_column_name=>'SENT_BY'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Sent By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(157182907217903192)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157174904157874984)
,p_db_column_name=>'SUBJECT'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Subject'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157175332159874984)
,p_db_column_name=>'SENT_TO'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Sent To'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157175713356874984)
,p_db_column_name=>'SENT_CC'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Sent Cc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157176164999874984)
,p_db_column_name=>'SENT_BCC'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Sent Bcc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157176530957874991)
,p_db_column_name=>'COMMENTS'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(157178328502890337)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1571784'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ACOOUNT_NUMBER:CUSTOMER_NAME:DELAY_FEES:TOURISM_FEES:SENT_ON:SENT_BY:SUBJECT:SENT_TO:SENT_CC:SENT_BCC:COMMENTS:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(156781306814174449)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(157170665699874978)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(122975280422781629)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:18::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(156781250010174448)
,p_name=>'P18_ACCOUNT_NUM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(157170665699874978)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
