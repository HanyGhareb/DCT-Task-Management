prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>11
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'BTF End User Budget Transfer  Submit'
,p_alias=>'BTF-END-USER-BUDGET-TRANSFER-SUBMIT'
,p_page_mode=>'MODAL'
,p_step_title=>'BTF End User Budget Transfer  Submit'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240307213140'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(572681882099878)
,p_plug_name=>'Declaration'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>'<h4><span style="color: #003300;"><strong>Please Note that The new DCT Delegation of Authority (DoA) has been applied.</strong></span></h4>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(854051869863137)
,p_plug_name=>'Missing Supporting documents'
,p_parent_plug_id=>wwv_flow_api.id(572681882099878)
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>'Please attach the supporting documents.'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':L_DOC_COUNT = 0'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1348514036912388)
,p_plug_name=>'Amount Not Balance'
,p_parent_plug_id=>wwv_flow_api.id(572681882099878)
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_source=>'Total Amount deduction Must equal total addition amount'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P11_DIFF_H != 0 and :P8_REQUEST_TYPE IN (''S'' , ''C'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1348669074912389)
,p_plug_name=>'No Strategic Project '
,p_parent_plug_id=>wwv_flow_api.id(572681882099878)
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_source=>'No Strategic Projects Selected. Kindly change the request type to "Standard" '
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'case When :P8_REQUEST_TYPE_H = ''C'' and BTF_EU_UTIL.btf_initiative_count(:P11_REQUEST_ID) > 2',
'        Then return true;',
'  Else ',
'      return false;',
'End Case;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1349150538912394)
,p_plug_name=>'Strategic Project Selected'
,p_parent_plug_id=>wwv_flow_api.id(572681882099878)
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_source=>'For Standard Budget Transfer, you shouldn''t select strategic Project.'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'case When :P8_REQUEST_TYPE_H = ''C'' and BTF_EU_UTIL.btf_initiative_count(:P11_REQUEST_ID) >= 2',
'        Then return true;',
'  Else ',
'      return false;',
'End Case;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1349262206912395)
,p_plug_name=>'No Lines'
,p_parent_plug_id=>wwv_flow_api.id(572681882099878)
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_source=>'There is no lines entered.'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
' :P8_REQUEST_TYPE IN (''A'' , ''R'') and (to_number(replace(nvl(:P8_TOTAL_DEDUCTION,0),'','','''')) =  0 OR',
'                                      to_number(replace(nvl(:P8_TOTAL_ADDITION,0),'','','''')) = 0)'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1928945241365515)
,p_plug_name=>'Transfer from different chapters not possible.'
,p_parent_plug_id=>wwv_flow_api.id(572681882099878)
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>'As per Financial policy, Please select transfer lines from single chapter'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'BTF_EU_UTIL.single_chapter_yn(:P11_REQUEST_ID) = ''N'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(452011072133416)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(572681882099878)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Yes, Submit'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- :P11_VALID = ''Y'' and BTF_EU_UTIL.btf_initiative_count(:P11_REQUEST_ID) <= 2',
'',
':P11_VALID = ''Y'''))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(451682892133413)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(572681882099878)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'No, Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(452405186133420)
,p_branch_name=>'Go to  8'
,p_branch_action=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_REQUEST_ID:&P11_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(451485262133411)
,p_name=>'P11_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(572681882099878)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(451613690133412)
,p_name=>'P11_REQUEST_NO'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(572681882099878)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(853482437863132)
,p_name=>'P11_DIFF'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(572681882099878)
,p_source=>'P8_DIFF'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(853631883863133)
,p_name=>'P11_DIFF_H'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(572681882099878)
,p_use_cache_before_default=>'NO'
,p_source=>'to_number(replace(nvl(:P11_DIFF,0),'','',''''))'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(853713483863134)
,p_name=>'L_DOC_COUNT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(572681882099878)
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number;',
'l_doc    varchar2(1);',
'begin',
'if btf_eu_util.attach_req_by_type(:P11_REQUEST_TYPE)',
'    Then ',
'        select nvl(count(*),0)',
'        into l_count',
'        from btf_end_users_req_documents',
'        where request_id = :P11_REQUEST_ID;',
'        ',
'else',
'    l_count := 1;',
'end if;',
'',
'return l_count;',
'end;'))
,p_source_type=>'FUNCTION_BODY'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(853828445863135)
,p_name=>'LS_STRATEGIC_PROJECT'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(572681882099878)
,p_use_cache_before_default=>'NO'
,p_source=>'P8_STRATEGIC_YN'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1348882197912392)
,p_name=>'P11_VALID'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(572681882099878)
,p_source=>'P8_VALIDE'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1928817076365514)
,p_name=>'P11_REQUEST_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(572681882099878)
,p_use_cache_before_default=>'NO'
,p_prompt=>'P11_REQUEST_TYPE'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(451819193133414)
,p_name=>'Cancel DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(451682892133413)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(451923260133415)
,p_event_id=>wwv_flow_api.id(451819193133414)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(853320865863130)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Submit Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_doc_count                      Number := 1;',
'l_strategic_project_count        varchar2(1);',
'Begin',
'',
'/*',
'if btf_eu_util.attach_req_by_type(:P11_REQUEST_TYPE)',
'    Then ',
'        select nvl(count(*),0)',
'        into l_doc_count',
'        from btf_end_users_req_documents',
'        where request_id = :P11_REQUEST_ID;',
'        ',
'else',
'    l_doc_count := 1;',
'end if;',
'*/',
'',
'case :P8_REQUEST_TYPE ',
'    when ''S''',
'        Then',
'        /*',
'            select decode(nvl(count(*),0), 0 ,''N'',''Y'')  xx',
'            into l_strategic_project_count',
'            from btf_end_users_lines l',
'            where l.request_id = :P11_REQUEST_ID ',
'            and (l.project_number , l.task_number) in (select ti.PROJECT_NUMBER, ti.TASK_NUMBER',
'                                                       from task_initiatives ti',
'                                                       where ti.initiative_id in (select si.INITIATIVE_ID',
'                                                                                    from strategic_initiatives si',
'                                                                                    where si.INITIATIVE_TYPE = ''S''',
'                                                                                    and si.status = ''A''',
'                                                                                    and sysdate between nvl(start_date, sysdate - 10)',
'                                                                                                and nvl(end_date , sysdate + 10)));',
'          */',
'          ',
'          If',
'                --  l_doc_count = 0 ',
'              --OR l_strategic_project_count = ''Y''',
'              -- OR ',
'              :P11_DIFF_H != 0 ',
'                  Then',
'                          apex_error.add_error(p_message => ''Invalid request! '' || :LS_STRATEGIC_PROJECT   ,',
'                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'                   else     ',
'                      -- BTF_EU_WORKFLOW.SUBMIT_YEAR_END(:P11_REQUEST_ID , :PERSON_ID);',
'                        BTF_EU_WORKFLOW.SUBMIT(:P11_REQUEST_ID , :PERSON_ID);',
'               End If;',
'               ',
'           else',
'                ',
'               BTF_EU_WORKFLOW.SUBMIT(:P11_REQUEST_ID , :PERSON_ID);',
'         -- for Year end closing',
'         --      BTF_EU_WORKFLOW.SUBMIT_YEAR_END(:P11_REQUEST_ID , :PERSON_ID);',
'       End case;      ',
'              ',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(452011072133416)
,p_process_success_message=>'Submitted Successfully'
);
wwv_flow_api.component_end;
end;
/
