prompt --application/pages/page_00105
begin
--   Manifest
--     PAGE: 00105
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
 p_id=>105
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Cost Center Proposal Plan Submission '
,p_alias=>'COST-CENTER-PROPOSAL-PLAN-SUBMISSION'
,p_page_mode=>'MODAL'
,p_step_title=>'Cost Center Proposal Plan Submission '
,p_allow_duplicate_submissions=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230611193133'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47360886932656812)
,p_plug_name=>'Button'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(99731046805410735)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47277775864722819)
,p_plug_name=>'Confirmation'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>you are going to submit your <strong><em>Budget Proposal Plan &P97_YEAR.</em></strong> for approval.</p>',
'<p>&nbsp;</p>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47360780461656811)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(47360886932656812)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47360493182656808)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(47360886932656812)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(47359779384656801)
,p_branch_name=>'Go to 97 CC Plan Details'
,p_branch_action=>'f?p=&APP_ID.:97:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53929229174650289)
,p_name=>'P105_COST_CENTER_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(47277775864722819)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47360233480656806)
,p_name=>'P105_CC_PLAN_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(47277775864722819)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47360186864656805)
,p_name=>'P105_PLAN_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(47277775864722819)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47360045945656804)
,p_name=>'P105_PLAN_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(47277775864722819)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47360030486656803)
,p_name=>'P105_COST_CENTER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(47277775864722819)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(47360703562656810)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(47360780461656811)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(47360591513656809)
,p_event_id=>wwv_flow_api.id(47360703562656810)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(47359918394656802)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Submit Cost Center Plan Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P105_CC_PLAN_ID = 365',
'    then ',
'        BUDGET_PROPOSAL_WORKFLOW.SUBMIT_AFH_PLAN(:P105_CC_PLAN_ID , :PERSON_ID);',
'    else',
'         BUDGET_PROPOSAL_WORKFLOW.SUBMIT_CC_PLAN(:P105_CC_PLAN_ID , :PERSON_ID);',
'end if;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(47360493182656808)
);
wwv_flow_api.component_end;
end;
/
