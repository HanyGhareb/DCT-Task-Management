prompt --application/pages/page_00055
begin
--   Manifest
--     PAGE: 00055
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
 p_id=>55
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Show CWIP Payments Reminders'
,p_alias=>'SHOW-CWIP-PAYMENTS-REMINDERS'
,p_page_mode=>'MODAL'
,p_step_title=>'Show CWIP Payments Reminders'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'Y'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220207063802'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(14932569279770862)
,p_plug_name=>'Reminders Report'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID, PAYMENT_RECOMMENDATION_ID, REMINDER_TYPE, COMMENTS, UPDATED_BY, UPDATED_ON, PERSON_ID ',
'from cwip_payment_rec_reminders',
'where payment_recommendation_id = :P55_PAYMENT_RECOMMENDATION_ID',
'and person_id = :P55_PPERSON_ID',
'and history_id = nvl(:P55_HISTORY_ID , history_id)',
'order by UPDATED_ON desc ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P55_PAYMENT_RECOMMENDATION_ID,P55_PPERSON_ID,P55_HISTORY_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Reminders Report'
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
 p_id=>wwv_flow_api.id(14932713913770863)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Reminders Available.'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>55368755742673133
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14932772530770864)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14932948801770865)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14933028640770866)
,p_db_column_name=>'REMINDER_TYPE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Reminder Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(14748831516520519)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14933104484770867)
,p_db_column_name=>'COMMENTS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14933233642770868)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Remind By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14933342001770869)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Remind ON'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14933391036770870)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(14989439846859190)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'554255'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REMINDER_TYPE:UPDATED_BY:UPDATED_ON:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(14933742743770873)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10218704148597764)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14933798759770874)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(14933742743770873)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14933487356770871)
,p_name=>'P55_PAYMENT_RECOMMENDATION_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(14932569279770862)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(14933621840770872)
,p_name=>'P55_PPERSON_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(14932569279770862)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(51145593317447331)
,p_name=>'P55_HISTORY_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(14932569279770862)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(14933888341770875)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(14933798759770874)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(14933994648770876)
,p_event_id=>wwv_flow_api.id(14933888341770875)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.component_end;
end;
/
