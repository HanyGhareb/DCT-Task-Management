prompt --application/pages/page_00019
begin
--   Manifest
--     PAGE: 00019
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
 p_id=>19
,p_user_interface_id=>wwv_flow_api.id(122997627648781606)
,p_name=>'Reminders Tracking'
,p_alias=>'REMINDERS-TRACKING'
,p_step_title=>'Reminders Tracking'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230321040427'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(157184892224949898)
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
 p_id=>wwv_flow_api.id(157185437607949898)
,p_plug_name=>'Reminders Tracking'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(122911181767781667)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'AR_TRANSACTIONS_REMINDERS'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Reminders Tracking'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(157185580120949898)
,p_name=>'Reminders Tracking'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>157185580120949898
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156781446810174450)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157185981538949900)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>20
,p_column_identifier=>'A'
,p_column_label=>'Customer Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157189722236961601)
,p_db_column_name=>'ACOOUNT_NUMBER'
,p_display_order=>30
,p_column_identifier=>'K'
,p_column_label=>'Acoount Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157189822460961602)
,p_db_column_name=>'TRANSACTION_NUMBER'
,p_display_order=>40
,p_column_identifier=>'L'
,p_column_label=>'Transaction Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157189162059949903)
,p_db_column_name=>'TOURISM_FEES'
,p_display_order=>50
,p_column_identifier=>'I'
,p_column_label=>'Tourism Fees'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157189902060961603)
,p_db_column_name=>'DELAY_FEES'
,p_display_order=>60
,p_column_identifier=>'M'
,p_column_label=>'Delay Fees'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157190002991961604)
,p_db_column_name=>'SENT_ON'
,p_display_order=>70
,p_column_identifier=>'N'
,p_column_label=>'Sent On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157190108025961605)
,p_db_column_name=>'SENT_BY'
,p_display_order=>80
,p_column_identifier=>'O'
,p_column_label=>'Sent By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(157182907217903192)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157190261347961606)
,p_db_column_name=>'SUBJECT'
,p_display_order=>90
,p_column_identifier=>'P'
,p_column_label=>'Subject'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157190365627961607)
,p_db_column_name=>'SENT_TO'
,p_display_order=>100
,p_column_identifier=>'Q'
,p_column_label=>'Sent To'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157190440501961608)
,p_db_column_name=>'SENT_CC'
,p_display_order=>110
,p_column_identifier=>'R'
,p_column_label=>'Sent Cc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157190532398961609)
,p_db_column_name=>'SENT_BCC'
,p_display_order=>120
,p_column_identifier=>'S'
,p_column_label=>'Sent Bcc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157190633046961610)
,p_db_column_name=>'COMMENTS'
,p_display_order=>130
,p_column_identifier=>'T'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(157201222294967886)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1572013'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CUSTOMER_NAME:ACOOUNT_NUMBER:TOURISM_FEES:DELAY_FEES:SENT_ON:SENT_BY:SUBJECT:SENT_TO:SENT_CC:SENT_BCC:COMMENTS:'
);
wwv_flow_api.component_end;
end;
/
