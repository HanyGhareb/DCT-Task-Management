prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>7
,p_user_interface_id=>wwv_flow_api.id(19279151117383422)
,p_name=>'Manual PR Action'
,p_alias=>'MPR-APPROVAL-ACTION'
,p_page_mode=>'MODAL'
,p_step_title=>'Manual PR Action'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230216095703'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(52295671776541372)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19168139315383331)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(26657443311249687)
,p_plug_name=>'Manual PR Action'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(52572122323137630)
,p_plug_name=>'Select Buyer'
,p_parent_plug_id=>wwv_flow_api.id(26657443311249687)
,p_icon_css_classes=>'fa-emoji-neutral'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT apex_item.checkbox2(1,d.person_id) Selected,',
'        d.person_id , e.full_name_en ,',
'CASE',
'        WHEN dbms_lob.getlength(e.photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || e.user_name',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END PHOTO_hidden,',
'        null PHOTO',
'FROM dct_data_access_assignment d , employees_v e',
'where d.person_id = e.person_id',
'and d.entity_type_id = ''ROLE'' ',
'and d.entity_id = 48 ',
'and d.status = ''A'' ',
'and sysdate BETWEEN d.start_date and nvl(d.end_date , sysdate + 10);'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':IS_SOUCEING_MANAGER	= 1 and :P7_ACTION = ''Approve'''
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Select Buyer'
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
 p_id=>wwv_flow_api.id(52572098173137629)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>150594817895295144
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52571992355137628)
,p_db_column_name=>'SELECTED'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Selected'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_format_mask=>'PCT_GRAPH:::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52571836807137627)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52571773809137626)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52571650258137625)
,p_db_column_name=>'PHOTO_HIDDEN'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Photo Hidden'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52571591240137624)
,p_db_column_name=>'PHOTO'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Photo'
,p_column_html_expression=>'<image src=''#PHOTO_HIDDEN#'' width=75 height=75>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20631388782203390)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(52295671776541372)
,p_button_name=>'Cancel'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(19256621748383394)
,p_button_image_alt=>'Cancel'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6:P6_ID:&P7_ID.'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(52571422595137623)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(52295671776541372)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P7_ACTION'
,p_button_condition2=>'Approve'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(52295525140541371)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(52295671776541372)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P7_ACTION'
,p_button_condition2=>'Reject'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20630981764203389)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(52295671776541372)
,p_button_name=>'Delegate'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--warning:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P7_ACTION'
,p_button_condition2=>'Delegate'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-info'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(52295453001541370)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(52295671776541372)
,p_button_name=>'Return'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P7_ACTION'
,p_button_condition2=>'Return'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(20635272148203402)
,p_branch_name=>'Go To 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52572499830137633)
,p_name=>'P7_ACTION'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(26657443311249687)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52572335677137632)
,p_name=>'P7_ACTION_REQUIRED'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(26657443311249687)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52572226984137631)
,p_name=>'P7_COMMENT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(26657443311249687)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(19255555017383393)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52295024673541366)
,p_name=>'P7_MPR_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(26657443311249687)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20631785078203390)
,p_name=>'P7_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(26657443311249687)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20632188291203391)
,p_name=>'P7_FROM_PERSON_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(26657443311249687)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20632575744203391)
,p_name=>'P7_TO_PERSON_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(26657443311249687)
,p_prompt=>'Delegated To'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEE NAME BY PERSONID LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en || ''-'' || employee_num   name , person_id',
'from employees_v'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_display_when=>'P7_ACTION'
,p_display_when2=>'Delegate'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(19255616347383393)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(20633258146203401)
,p_name=>'Delegation DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(20630981764203389)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20633798991203401)
,p_event_id=>wwv_flow_api.id(20633258146203401)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure that you want to delegate this approval for this Manual PR ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20634241111203401)
,p_event_id=>wwv_flow_api.id(20633258146203401)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'mpr_workflow.DELEGATE(:P7_ID ,:PERSON_ID , :P7_TO_PERSON_ID);',
'',
'end;'))
,p_attribute_02=>'P7_ID,P7_TO_PERSON_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20634758640203401)
,p_event_id=>wwv_flow_api.id(20633258146203401)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(52295325742541369)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approve Action'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_count                 NUMBER := apex_application.g_f01.count;',
'BEGIN',
'',
'if :IS_SOUCEING_MANAGER > 0',
'    Then     if l_count = 0  Then ',
'                                apex_error.add_error(p_message => ''Please select at least one buyer! '',',
'                                                    p_display_location => apex_error.c_inline_with_field_and_notif);',
'                         else',
'                             MPR_WORKFLOW2.approve(:P7_MPR_ID,:PERSON_ID,:P7_COMMENT,''S'');',
'                             MPR_WORKFLOW2.INSERT_BUYER(:P7_TO_PERSON_ID , :P6_STEP_NO , :P7_MPR_ID , ''Pending'');',
'               End if;',
'     else',
'          MPR_WORKFLOW2.approve(:P7_MPR_ID,:PERSON_ID,:P7_COMMENT,''S'');',
' End if;',
' End;'))
,p_process_error_message=>'Error while approve, Please contact system admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(52571422595137623)
,p_process_success_message=>'Approved Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(52295288709541368)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reject Action'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
'IF :P7_COMMENT is null THEN',
'                    apex_error.add_error(p_message => ''Please enter your Justification! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'else',
'    MPR_WORKFLOW2.REJECT(:P7_MPR_ID,:PERSON_ID, :P7_COMMENT , ''S'');',
' End if;',
'End;'))
,p_process_error_message=>'Error while Reject, Please contact system admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(52295525140541371)
,p_process_success_message=>'Rejected.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(52295175102541367)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delegate Action'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
'IF :P7_TO_PERSON_ID is null THEN',
'                    apex_error.add_error(p_message => ''Please select the delegated person.'',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'else',
'    MPR_WORKFLOW2.DELEGATE(:P7_MPR_ID,:PERSON_ID, :P7_TO_PERSON_ID, :P7_COMMENT , ''S'');',
' End if;',
'End;'))
,p_process_error_message=>'error while Delegated, Please contact system admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(20630981764203389)
,p_process_success_message=>'Delegated'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(52294609124541361)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Return Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
'IF :P7_COMMENT is null THEN',
'                    apex_error.add_error(p_message => ''Please enetr your comment to return the request.'',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'else',
'    MPR_WORKFLOW2.RETURN(:P7_MPR_ID, :PERSON_ID, :P7_COMMENT, ''S'');',
' End if;',
'End;'))
,p_process_error_message=>'Not Returned, Contact system admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(52295453001541370)
,p_process_success_message=>'Returned Successfully.'
);
wwv_flow_api.component_end;
end;
/
