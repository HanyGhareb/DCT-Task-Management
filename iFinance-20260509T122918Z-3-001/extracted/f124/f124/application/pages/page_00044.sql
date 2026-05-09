prompt --application/pages/page_00044
begin
--   Manifest
--     PAGE: 00044
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
 p_id=>44
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'Template Component Details'
,p_alias=>'TEMPLATE-COMPONENT-DETAILS'
,p_page_mode=>'MODAL'
,p_step_title=>'Template Component Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20221221075521'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(140067211554123916)
,p_plug_name=>'Search'
,p_icon_css_classes=>'fa-search'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(279432423837775165)
,p_plug_name=>'Template Component Details Report'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    apex_item.checkbox2(1,sc.COMPONENT_ID)    Selected,',
'    COMPONENT_NAME,',
'    component_id,',
'    order_num,',
'    appendix_id,',
'    status,',
'    start_date,',
'    end_date,',
'    created_by,',
'    updated_by,',
'    creation_date,',
'    updated_date,',
'    guideline,',
'    custom_label',
'FROM',
'    DP_SCOPE_COMPONENTS sc',
'where sc.COMPONENT_ID not in (select COMPONENT_ID ',
'                                from DP_SCOPE_COMP_TEMPLATE_DETAILS',
'                                where template_id = :P44_TEMPLATE_ID) ',
'and appendix_id = nvl(:P44_APPENDIX , appendix_id)',
'and sc.status = ''A'' ',
'and sysdate between nvl(start_date , sysdate - 10) and nvl(end_date , sysdate + 10)',
'order by appendix_id,  component_id, order_num;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P44_TEMPLATE_ID,P44_APPENDIX'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Template Component Details Report'
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
 p_id=>wwv_flow_api.id(279432507848775166)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>279432507848775166
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140084018040032045)
,p_db_column_name=>'SELECTED'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Selected'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140084856894032045)
,p_db_column_name=>'COMPONENT_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Component'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(139639858043057475)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140085261711032044)
,p_db_column_name=>'ORDER_NUM'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Order Num'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140085669220032044)
,p_db_column_name=>'APPENDIX_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Appendix'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(136727294356003195)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140086842622032043)
,p_db_column_name=>'STATUS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128342850308489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140087256463032043)
,p_db_column_name=>'START_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140087686985032043)
,p_db_column_name=>'END_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140088037254032043)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140088483485032043)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140088818109032043)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140089296766032042)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140089616389032042)
,p_db_column_name=>'GUIDELINE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Guideline'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140090076185032042)
,p_db_column_name=>'CUSTOM_LABEL'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Custom Label'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(140067823494123922)
,p_db_column_name=>'COMPONENT_NAME'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Component Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(279746277421269495)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1400904'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SELECTED:APPENDIX_ID:COMPONENT_ID:CUSTOM_LABEL:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(140081886648051253)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(140067211554123916)
,p_button_name=>'Add'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add Selected to Components'
,p_button_position=>'BELOW_BOX'
,p_icon_css_classes=>'fa-file-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(140082170262048976)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(140067211554123916)
,p_button_name=>'Add_all'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add All Components'
,p_button_position=>'BELOW_BOX'
,p_icon_css_classes=>'fa-table-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(140082473409047659)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(140067211554123916)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Close'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140067368550123917)
,p_name=>'P44_TEMPLATE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(140067211554123916)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140067447496123918)
,p_name=>'P44_APPENDIX'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(140067211554123916)
,p_prompt=>'Appendix'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'SCOPING APPENDIXES LOV '
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  DP_SCOPE_APPENDIX.APPENDIX_NAME as APPENDIX_NAME ,',
'        DP_SCOPE_APPENDIX.APPENDIX_ID as APPENDIX_ID',
'   ',
' from DP_SCOPE_APPENDIX DP_SCOPE_APPENDIX',
' where status = ''A''',
' and sysdate between nvl(start_date , sysdate -10) and nvl(end_date , sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(140067662917123920)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(140082473409047659)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(140067740671123921)
,p_event_id=>wwv_flow_api.id(140067662917123920)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(140455524011095015)
,p_name=>'Refresh'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P44_APPENDIX'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(140455610620095016)
,p_event_id=>wwv_flow_api.id(140455524011095015)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(279432423837775165)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(140455343366095013)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add Component Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count                 NUMBER := apex_application.g_f01.count;',
'Begin',
'  IF l_count = 0 THEN',
'                    apex_error.add_error(p_message => ''Please select at least one Component to add! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'  else',
'       FOR i IN 1..l_count LOOP',
'    -- insert selected line',
'INSERT INTO dp_scope_comp_template_details (',
'    template_id,',
'    appendix_id,',
'    component_id,',
'    order_num,',
'    guideline,',
'    custom_label,',
'    status,',
'    start_date,',
'    component_name',
'  ) ',
' select :P44_TEMPLATE_ID,',
'        ddp.appendix_id,',
'        apex_application.g_f01(i),',
'        order_num,',
'        guideline,',
'        custom_label,',
'        ''A'',',
'        sysdate,',
'        COMPONENT_NAME',
'  from  dp_scope_components ddp',
'  where COMPONENT_ID = apex_application.g_f01(i) ;',
'  ',
'      END LOOP;',
' End if;',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(140081886648051253)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(140455493775095014)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add All Components Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO dp_scope_comp_template_details (',
'    template_id,',
'    appendix_id,',
'    component_id,',
'    order_num,',
'    guideline,',
'    custom_label,',
'    status,',
'    start_date,',
'    component_name',
'  ) ',
' select :P44_TEMPLATE_ID,',
'        ddp.appendix_id,',
'        component_id,',
'        order_num,',
'        guideline,',
'        custom_label,',
'        ''A'',',
'        sysdate,',
'        COMPONENT_NAME',
'  from  dp_scope_components ddp',
'  where COMPONENT_ID not in ((select COMPONENT_ID ',
'                            from dp_scope_comp_template_details',
'                            where template_id = :P44_TEMPLATE_ID))',
'  and appendix_id = :P44_APPENDIX                          ;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(140082170262048976)
);
wwv_flow_api.component_end;
end;
/
