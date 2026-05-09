prompt --application/pages/page_00039
begin
--   Manifest
--     PAGE: 00039
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
 p_id=>39
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'add Data Points to Scoping Template Details'
,p_alias=>'ADD-DATA-POINTS-TO-SCOPING-TEMPLATE-DETAILS'
,p_page_mode=>'MODAL'
,p_step_title=>'add Data Points to Scoping Template Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20221221085246'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(139225891155823536)
,p_plug_name=>'Search'
,p_icon_css_classes=>'fa-search'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(139348632153743115)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    apex_item.checkbox2(1,ds.data_point_id)    Selected,',
'    data_point_name,',
'    component_id,',
'    order_num,',
'    appendix_id,',
'    default_text,',
'    allow_edit,',
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
'    dp_scope_data_points ds',
'where ds.data_point_id not in (select data_point_id ',
'                                from dp_scope_data_points_template_details',
'                                where template_id = :P39_TEMPLATE_ID) ',
'and appendix_id = nvl(:P39_APPENDIX , appendix_id)',
'and component_id =  nvl(:P39_COMPONENT , component_id)',
'and ds.status = ''A'' ',
'and sysdate between nvl(start_date , sysdate - 10) and nvl(end_date , sysdate + 10)',
'order by appendix_id,  component_id, order_num;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P39_TEMPLATE_ID,P39_APPENDIX,P39_COMPONENT'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'New'
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
 p_id=>wwv_flow_api.id(139348716164743116)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>139348716164743116
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139348859275743117)
,p_db_column_name=>'SELECTED'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Selected'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139348903048743118)
,p_db_column_name=>'DATA_POINT_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Data Point Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139349047403743119)
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
 p_id=>wwv_flow_api.id(139349162982743120)
,p_db_column_name=>'ORDER_NUM'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Order Num'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139349272536743121)
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
 p_id=>wwv_flow_api.id(139349353037743122)
,p_db_column_name=>'DEFAULT_TEXT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Default Text'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139349405982743123)
,p_db_column_name=>'ALLOW_EDIT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Allow Edit'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139349512829743124)
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
 p_id=>wwv_flow_api.id(139349662622743125)
,p_db_column_name=>'START_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139349764085743126)
,p_db_column_name=>'END_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139349800624743127)
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
 p_id=>wwv_flow_api.id(139349997214743128)
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
 p_id=>wwv_flow_api.id(139350012449743129)
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
 p_id=>wwv_flow_api.id(139350141975743130)
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
 p_id=>wwv_flow_api.id(139350273002743131)
,p_db_column_name=>'GUIDELINE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Guideline'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(139350342171743132)
,p_db_column_name=>'CUSTOM_LABEL'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Custom Label'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(139662485737237445)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1396625'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SELECTED:DATA_POINT_NAME:CUSTOM_LABEL:APPENDIX_ID:COMPONENT_ID:ORDER_NUM:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139350762857743136)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(139225891155823536)
,p_button_name=>'Add'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add Selected to Template'
,p_button_position=>'BELOW_BOX'
,p_icon_css_classes=>'fa-file-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139351334252743142)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(139225891155823536)
,p_button_name=>'Add_all'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add All Data Elements'
,p_button_position=>'BELOW_BOX'
,p_icon_css_classes=>'fa-table-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139350872835743137)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(139225891155823536)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Close'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(139351260272743141)
,p_branch_name=>'Go To 26'
,p_branch_action=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.:26:P26_TEMPLATE_ID:&P39_TEMPLATE_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139194965833046246)
,p_name=>'P39_TEMPLATE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(139225891155823536)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139195082170046247)
,p_name=>'P39_APPENDIX'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(139225891155823536)
,p_prompt=>'Scoping Appendix'
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
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139195130416046248)
,p_name=>'P39_COMPONENT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(139225891155823536)
,p_prompt=>'Component'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DP_SCOPE_COMPONENTS.COMPONENT_NAME as COMPONENT_NAME,',
'    DP_SCOPE_COMPONENTS.COMPONENT_ID as COMPONENT_ID ',
' from DP_SCOPE_COMPONENTS DP_SCOPE_COMPONENTS',
' WHERE APPENDIX_ID = NVL(:P39_APPENDIX, APPENDIX_ID)',
' ORDER BY ORDER_NUM'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P39_APPENDIX'
,p_ajax_items_to_submit=>'P39_APPENDIX'
,p_ajax_optimize_refresh=>'N'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139350495451743133)
,p_name=>'Refresh DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P39_APPENDIX,P39_COMPONENT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139350516036743134)
,p_event_id=>wwv_flow_api.id(139350495451743133)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(139348632153743115)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139350941535743138)
,p_name=>'Close DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(139350872835743137)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139351060587743139)
,p_event_id=>wwv_flow_api.id(139350941535743138)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(139351126842743140)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add to Template Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'',
'l_count                 NUMBER := apex_application.g_f01.count;',
'',
'Begin',
'  IF l_count = 0 THEN',
'                    apex_error.add_error(p_message => ''Please select at least one data element! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'  else',
'       FOR i IN 1..l_count LOOP',
'    -- insert selected line',
'INSERT INTO dp_scope_data_points_template_details (',
'    template_id,',
'    appendix_id,',
'    component_id,',
'    data_point_id,',
'    order_num,',
'    guideline,',
'    custom_label,',
'    default_text,',
'    allow_edit,',
'    status,',
'    start_date,',
'    DATA_POINT_NAME',
'  ) ',
' select :P39_TEMPLATE_ID,',
'        ddp.appendix_id,',
'        ddp.component_id,',
'        apex_application.g_f01(i),',
'        order_num,',
'        guideline,',
'        custom_label,',
'        default_text,',
'        allow_edit,',
'        ''A'',',
'        sysdate,',
'        DATA_POINT_NAME',
'  from  dp_scope_data_points ddp',
'  where data_point_id = apex_application.g_f01(i) ;',
'  ',
'      END LOOP;',
' End if;',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(139350762857743136)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(139351488371743143)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add All data points to Template Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO dp_scope_data_points_template_details (',
'    template_id,',
'    appendix_id,',
'    component_id,',
'    data_point_id,',
'    order_num,',
'    guideline,',
'    custom_label,',
'    default_text,',
'    allow_edit,',
'    status,',
'    start_date,',
'    DATA_POINT_NAME',
'  ) ',
' select :P39_TEMPLATE_ID,',
'        ddp.appendix_id,',
'        ddp.component_id,',
'        data_point_id,',
'        order_num,',
'        guideline,',
'        custom_label,',
'        default_text,',
'        allow_edit,',
'        ''A'',',
'        sysdate,',
'        DATA_POINT_NAME',
'  from  dp_scope_data_points ddp',
'  where data_point_id not in ((select data_point_id ',
'                            from dp_scope_data_points_template_details',
'                            where template_id = :P39_TEMPLATE_ID))',
'   and appendix_id = :P39_APPENDIX',
'   and component_id = nvl(:P39_COMPONENT , component_id);',
'  '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(139351334252743142)
);
wwv_flow_api.component_end;
end;
/
