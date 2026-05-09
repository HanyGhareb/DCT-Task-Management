prompt --application/pages/page_10090
begin
--   Manifest
--     PAGE: 10090
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>10090
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Email Reporting'
,p_alias=>'EMAIL-REPORTING'
,p_page_mode=>'MODAL'
,p_step_title=>'Email Reporting'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch:t-Dialog--noPadding'
,p_required_patch=>wwv_flow_api.id(21548070294648944)
,p_help_text=>'<p>This report shows all email queued to be sent and those already sent.</p>'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210209201914'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(21548308528648944)
,p_plug_name=>'Email Reporting'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select apex_lang.message(''APEX.FEATURE.EMAIL_REPORTING.QUEUED'') mail_status,',
'       id,',
'       mail_to,',
'       mail_from,',
'       mail_replyto,',
'       mail_subj,',
'       mail_cc,',
'       mail_bcc,',
'       mail_send_count,',
'       mail_send_error,',
'       last_updated_by,',
'       last_updated_on,',
'       mail_message_created, ',
'       lower(mail_message_created_by) message_created_by,',
'       app_id,',
'       dbms_lob.getlength(mail_body) text_body_size,',
'       dbms_lob.getlength(mail_body_html) html_body_size,',
'       null send_begin,',
'       null send_end,',
'       null mail_attachment_count,',
'       null mail_attachment_size',
'  from apex_mail_queue',
'union',
'select apex_lang.message(''APEX.FEATURE.EMAIL_REPORTING.SENT'') mail_status,',
'       mail_id id,',
'       mail_to,',
'       mail_from,',
'       mail_replyto,',
'       mail_subj,',
'       mail_cc,',
'       mail_bcc,',
'       null mail_send_count,',
'       mail_send_error,',
'       null last_updated_by,',
'       last_updated_on,',
'       mail_message_created,',
'       null message_created_by,',
'       app_id,',
'       mail_body_size text_body_size,',
'       mail_body_html_size html_body_size,',
'       mail_message_send_begin send_begin,',
'       mail_message_send_end   send_end,',
'       mail_attachment_count,',
'       mail_attachment_size',
'  from apex_mail_log'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Email Reporting'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(21549297676648944)
,p_name=>'Email Reporting'
,p_max_row_count=>'1000000'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>21549297676648944
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21549394587648946)
,p_db_column_name=>'MAIL_STATUS'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21549766236648947)
,p_db_column_name=>'ID'
,p_display_order=>11
,p_column_identifier=>'B'
,p_column_label=>'ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21550118721648949)
,p_db_column_name=>'MAIL_TO'
,p_display_order=>21
,p_column_identifier=>'C'
,p_column_label=>'To'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21550436717648950)
,p_db_column_name=>'MAIL_FROM'
,p_display_order=>31
,p_column_identifier=>'D'
,p_column_label=>'From'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21550879874648951)
,p_db_column_name=>'MAIL_REPLYTO'
,p_display_order=>41
,p_column_identifier=>'E'
,p_column_label=>'Reply To'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21551217715648953)
,p_db_column_name=>'MAIL_SUBJ'
,p_display_order=>51
,p_column_identifier=>'F'
,p_column_label=>'Subject'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21551678395648954)
,p_db_column_name=>'MAIL_CC'
,p_display_order=>61
,p_column_identifier=>'G'
,p_column_label=>'CC'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21552081787648956)
,p_db_column_name=>'MAIL_BCC'
,p_display_order=>71
,p_column_identifier=>'H'
,p_column_label=>'BCC'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21552486442648957)
,p_db_column_name=>'MAIL_SEND_COUNT'
,p_display_order=>81
,p_column_identifier=>'I'
,p_column_label=>'Send Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21552875831648959)
,p_db_column_name=>'MAIL_SEND_ERROR'
,p_display_order=>91
,p_column_identifier=>'J'
,p_column_label=>'Send Error'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21553283820648960)
,p_db_column_name=>'LAST_UPDATED_BY'
,p_display_order=>101
,p_column_identifier=>'K'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21553622534648962)
,p_db_column_name=>'LAST_UPDATED_ON'
,p_display_order=>111
,p_column_identifier=>'L'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21554046239648963)
,p_db_column_name=>'MAIL_MESSAGE_CREATED'
,p_display_order=>121
,p_column_identifier=>'M'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'since'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21554491548648965)
,p_db_column_name=>'MESSAGE_CREATED_BY'
,p_display_order=>131
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21554882664648966)
,p_db_column_name=>'APP_ID'
,p_display_order=>141
,p_column_identifier=>'O'
,p_column_label=>'Application ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21555259284648967)
,p_db_column_name=>'TEXT_BODY_SIZE'
,p_display_order=>151
,p_column_identifier=>'P'
,p_column_label=>'Text Body Size'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21555667597648969)
,p_db_column_name=>'HTML_BODY_SIZE'
,p_display_order=>161
,p_column_identifier=>'Q'
,p_column_label=>'HTML Body Size'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21556086552648970)
,p_db_column_name=>'SEND_BEGIN'
,p_display_order=>171
,p_column_identifier=>'R'
,p_column_label=>'Send Begin'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21556468017648972)
,p_db_column_name=>'SEND_END'
,p_display_order=>171
,p_column_identifier=>'S'
,p_column_label=>'Send End'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21556845563648973)
,p_db_column_name=>'MAIL_ATTACHMENT_COUNT'
,p_display_order=>181
,p_column_identifier=>'T'
,p_column_label=>'Attachment Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21557226778648974)
,p_db_column_name=>'MAIL_ATTACHMENT_SIZE'
,p_display_order=>191
,p_column_identifier=>'U'
,p_column_label=>'Attachment Size'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(21557904028648975)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'215580'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'MAIL_STATUS:MAIL_TO:MAIL_FROM:MAIL_SUBJ:MAIL_SEND_COUNT:MAIL_SEND_ERROR:MAIL_MESSAGE_CREATED:MESSAGE_CREATED_BY:APP_ID:HTML_BODY_SIZE'
,p_sort_column_1=>'MAIL_MESSAGE_CREATED'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(21558854181648976)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(21548308528648944)
,p_button_name=>'RESET_REPORT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Reset'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:&APP_PAGE_ID.:&SESSION.::&DEBUG.:&APP_PAGE_ID.,RR::'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.component_end;
end;
/
