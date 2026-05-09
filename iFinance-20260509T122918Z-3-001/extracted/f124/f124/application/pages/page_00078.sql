prompt --application/pages/page_00078
begin
--   Manifest
--     PAGE: 00078
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
 p_id=>78
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'DP Items Reminders Details'
,p_alias=>'DP-ITEMS-REMINDERS-DETAILS'
,p_page_mode=>'MODAL'
,p_step_title=>'DP Items Reminders Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230313112742'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11483157132932286)
,p_plug_name=>'hidden'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11778239856824828)
,p_plug_name=>'DP Items Reminders Details'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ITEM_ID,',
'       REMINDER_TYPE,',
'       COMMENTS,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       PERSON_ID,',
'       HISTORY_ID',
'  from DP_ITEMS_REMINDERS',
'  where item_id = :P78_ITEM_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P78_ITEM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'DP Items Reminders Details'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(11778345929824828)
,p_name=>'DP Items Reminders Details'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No Reminders'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>155980514903880792
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11778773263824831)
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
 p_id=>wwv_flow_api.id(11779226636824832)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'DP Item Code'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(11791013955871785)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11779610980824832)
,p_db_column_name=>'REMINDER_TYPE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Reminder Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(11790780540866361)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11779969286824832)
,p_db_column_name=>'COMMENTS'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11780345438824832)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Sent By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11780780208824833)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Sent On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11781167262824833)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Sent To'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11781549327824833)
,p_db_column_name=>'HISTORY_ID'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'History Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(11791156509872281)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1559934'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ITEM_ID:PERSON_ID:UPDATED_ON:UPDATED_BY:COMMENTS:REMINDER_TYPE:'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11783849454846437)
,p_name=>'P78_ITEM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11483157132932286)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
