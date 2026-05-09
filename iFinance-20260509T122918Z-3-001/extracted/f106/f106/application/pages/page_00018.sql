prompt --application/pages/page_00018
begin
--   Manifest
--     PAGE: 00018
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>18
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Mission Submit'
,p_alias=>'MISSION-SUBMIT'
,p_page_mode=>'MODAL'
,p_step_title=>'Mission Submit'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220717131312'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11306027947321149)
,p_plug_name=>'Missing Documents'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p style="color:red ; font-size:20px ">To submit your request, Please attach all the required documents.</p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_req_doc_count          number;',
'l_attached_doc           number;',
'BEGIN',
'',
'select count(*)',
'into l_attached_doc',
'from mission_documents d ',
'where d.REQUEST_ID = :P18_REQUEST_ID',
'and nvl(sys.dbms_lob.getlength(d.file_blob), 0) > 0 ;',
'',
'if l_attached_doc > 0    Then',
'          return false ;',
'          else ',
'          return true ;',
'',
'End if;  ',
'END;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110295659444602644)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12872392429762094)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110394879493504824)
,p_plug_name=>'Declartion'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>'You are going to submit the request for approval, Are you sure? '
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_req_doc_count          number;',
'l_attached_doc           number;',
'BEGIN',
'',
'select count(*)',
'into l_attached_doc',
'from mission_documents d ',
'where d.REQUEST_ID = :P18_REQUEST_ID',
'and nvl(sys.dbms_lob.getlength(d.file_blob), 0) > 0 ;',
'',
'if l_attached_doc > 0    Then',
'          return true ;',
'          else ',
'          return false ;',
'',
'End if;  ',
'END;'))
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110295745234602645)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(110295659444602644)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12960857103762161)
,p_button_image_alt=>'Cancel'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110295878913602646)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(110295659444602644)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Submit'
,p_button_position=>'BELOW_BOX'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_req_doc_count          number;',
'l_attached_doc           number;',
'BEGIN',
'',
'select count(*)',
'into l_attached_doc',
'from mission_documents d ',
'where d.REQUEST_ID = :P18_REQUEST_ID',
'and nvl(sys.dbms_lob.getlength(d.file_blob), 0) > 0 ;',
'',
'if l_attached_doc > 0    Then',
'          return true ;',
'          else ',
'          return false ;',
'',
'End if;  ',
'END;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(110296287215602650)
,p_branch_name=>'Go to 13'
,p_branch_action=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.::P13_REQUEST_ID:&P18_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110295567532602643)
,p_name=>'P18_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(110394879493504824)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(110295940896602647)
,p_name=>'Cancel DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(110295745234602645)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110296031728602648)
,p_event_id=>wwv_flow_api.id(110295940896602647)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(110296174850602649)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Submit Process'
,p_process_sql_clob=>'MISSION_WORKFLOW.SUBMIT(:P18_REQUEST_ID, :PERSON_ID);'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(110295878913602646)
,p_process_success_message=>'Submitted Successfully'
);
wwv_flow_api.component_end;
end;
/
