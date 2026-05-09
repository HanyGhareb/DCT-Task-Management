prompt --application/pages/page_00055
begin
--   Manifest
--     PAGE: 00055
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>55
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Approval Control'
,p_alias=>'APPROVAL-CONTROL'
,p_page_mode=>'MODAL'
,p_step_title=>'Approval Control'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240216093448'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(91223454610348768)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(12872392429762094)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(91864580621042860)
,p_plug_name=>'Hidden'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(91865016695042861)
,p_plug_name=>'Change'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P55_EVENT in (''A'' , ''B'' , ''U'')'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(91223640555348770)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(91223454610348768)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12960857103762161)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(91223602994348769)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(91223454610348768)
,p_button_name=>'Ok'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Ok'
,p_button_position=>'REGION_TEMPLATE_EDIT'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(91874396810376427)
,p_branch_name=>'Go To Page 13'
,p_branch_action=>'f?p=&APP_ID.:&P55_PAGE_FROM.:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(91222905479348762)
,p_name=>'P55_HISTORY_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(91864580621042860)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(91223014969348763)
,p_name=>'P55_EVENT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(91864580621042860)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(91223198624348765)
,p_name=>'P55_EMPLOYEE'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(91865016695042861)
,p_prompt=>'Employee'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(91223226022348766)
,p_name=>'P55_ACTION_REQUIRED'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(91865016695042861)
,p_prompt=>'Action Required'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DISTINCT ACTION_REQUIRED  ACTION_REQUIRED , ACTION_REQUIRED h',
'FROM mission_approval_history',
'WHERE ACTION_REQUIRED IS NOT NULL',
'AND ACTION_REQUIRED != ''Submit'''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(91223392477348767)
,p_name=>'P55_ROLE_ID'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(91865016695042861)
,p_prompt=>'Role'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ROLE_NAME , ROLE_ID ',
'FROM ROLES',
'WHERE ROLE_ID IN (SELECT DISTINCT ROLE_ID -- , ROLE_DESC ',
'FROM mission_approval_history',
'WHERE 1=1',
'and ROLE_ID IN (96 , 73, 74, 81 ,82 , 140 , 106 ,93 , 130))',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(92632509520579858)
,p_name=>'P55_PAGE_FROM'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(91864580621042860)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(104046856649560225)
,p_name=>'P55_PERSON_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(91864580621042860)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(104047020498560226)
,p_name=>'P55_REQUEST_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(91864580621042860)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(104047103910560227)
,p_name=>'P55_APPLY'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(91865016695042861)
,p_item_default=>'N'
,p_prompt=>'Apply for all other in-progress requests ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>6
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(91223830600348772)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(91223640555348770)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(91223925685348773)
,p_event_id=>wwv_flow_api.id(91223830600348772)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(91223815745348771)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Execute Approval Control Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P55_EVENT in (''A'' , ''B'')',
'then',
'MISSION_WORKFLOW.insert_line(:P55_HISTORY_ID, :P55_EMPLOYEE , :P55_ACTION_REQUIRED , :P55_ROLE_ID , :P55_EVENT);',
'',
'if :P55_APPLY = ''Y''',
'    Then',
'        for rec in (select id ',
'                        from mission_approval_history h',
'                        where h.request_id in (select m.request_id',
'                                                from mission_header m',
'                                                where m.request_for = (select request_for from mission_header where request_id = :P55_REQUEST_ID )',
'                                                and m.request_status = ''in-Progress'')',
'                        and h.person_id = :P55_PERSON_ID)',
'                        ',
'                loop',
'                    MISSION_WORKFLOW.insert_line(rec.id, :P55_EMPLOYEE , :P55_ACTION_REQUIRED , :P55_ROLE_ID , :P55_EVENT);',
'                end loop;',
'    end if;',
'ENd if;'))
,p_process_error_message=>'Not Added, Contact System Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':P55_EVENT in (''A'' , ''B'')'
,p_process_when_type=>'PLSQL_EXPRESSION'
,p_process_success_message=>'Added Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(91874442948376428)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Remove Approval Control Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P55_EVENT = ''D''',
'then',
'MISSION_WORKFLOW.remove_line(:P55_HISTORY_ID);',
'',
'if :P55_APPLY = ''Y''',
'    Then',
'        for rec in (select id ',
'                        from mission_approval_history h',
'                        where h.request_id in (select m.request_id',
'                                                from mission_header m',
'                                                where m.request_for = (select request_for from mission_header where request_id = :P55_REQUEST_ID )',
'                                                and m.request_status = ''in-Progress'')',
'                        and h.person_id = :P55_PERSON_ID)',
'                        ',
'                loop',
'                    MISSION_WORKFLOW.remove_line(rec.id);',
'                end loop;',
'    end if;',
'ENd if;'))
,p_process_error_message=>'Not Removed, Contact System Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':P55_EVENT = ''D'''
,p_process_when_type=>'PLSQL_EXPRESSION'
,p_process_success_message=>'Removed Successfully'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(91874627282376430)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Approval Control Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P55_EVENT = ''U''',
'then',
'MISSION_WORKFLOW.update_line(:P55_HISTORY_ID, :P55_EMPLOYEE , :P55_ROLE_ID, :P55_ACTION_REQUIRED );',
'',
'if :P55_APPLY = ''Y''',
'    Then',
'        for rec in (select id ',
'                        from mission_approval_history h',
'                        where h.request_id in (select m.request_id',
'                                                from mission_header m',
'                                                where m.request_for = (select request_for from mission_header where request_id = :P55_REQUEST_ID )',
'                                                and m.request_status = ''in-Progress'')',
'                        and h.person_id = :P55_PERSON_ID)',
'                        ',
'                loop',
'                    MISSION_WORKFLOW.update_line(rec.id, :P55_EMPLOYEE , :P55_ROLE_ID, :P55_ACTION_REQUIRED );',
'                end loop;',
'    end if;',
'    ',
'ENd if;'))
,p_process_error_message=>'Not Updated, Contact System Admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':P55_EVENT = ''U'''
,p_process_when_type=>'PLSQL_EXPRESSION'
,p_process_success_message=>'Updated Successfully'
);
wwv_flow_api.component_end;
end;
/
