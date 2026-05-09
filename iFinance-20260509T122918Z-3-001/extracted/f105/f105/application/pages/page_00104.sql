prompt --application/pages/page_00104
begin
--   Manifest
--     PAGE: 00104
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
 p_id=>104
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Proposal Plan Submission Confirmation'
,p_alias=>'BUDGET-PROPOSAL-PLAN-SUBMISSION'
,p_page_mode=>'MODAL'
,p_step_title=>'Budget Proposal Plan Submission Confirmation'
,p_allow_duplicate_submissions=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230508060549'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47419852182149809)
,p_plug_name=>'Chapter 3 Ceiling Validation'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><span style="color: #ff0000;"><em>Total Sectors Capex (Chapter 3) Ceiling can not exceed Plan Ceiling.</em></span></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BUDGET_PROPOSAL_PKG.CHECK_PLAN_CEILING_EXISTS(:P104_PLAN_ID , 135)',
'    and ',
'not BUDGET_PROPOSAL_PKG.CHECK_PLAN_CEILING_MATCH(:P104_PLAN_ID , 135)'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47419608139149806)
,p_plug_name=>'Sector ED Validation'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><span style="color: #ff0000;"><em>All Sectors included in the plan must have Executive Director assigned.</em></span></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number default 0 ;',
'begin',
'',
'select COUNT(*)',
'INTO l_count',
'from budget_proposal_sectors_plans',
'where plan_id = :P104_PLAN_ID',
'AND BUDGET_PROPOSAL_PKG.CHECK_SECTOR_ROLES_COUNT(PLAN_ID ,sector_id , 82)  = 0;',
'',
'   if l_count > 0',
'    Then ',
'        Return TRUE;',
'    else',
'        return FALSE;',
'    End if;',
'End ;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47419501715149805)
,p_plug_name=>'Sector Planner Validation'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><span style="color: #ff0000;"><em>All Sectors included in the plan must have at least planner assigned.</em></span></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number default 0 ;',
'begin',
'',
'select COUNT(*)',
'INTO l_count',
'from budget_proposal_sectors_plans',
'where plan_id = :P104_PLAN_ID',
'AND BUDGET_PROPOSAL_PKG.CHECK_SECTOR_ROLES_COUNT(PLAN_ID ,sector_id , 113)  = 0;',
'',
'   if l_count > 0',
'    Then ',
'        Return TRUE;',
'    else',
'        return FALSE;',
'    End if;',
'End ;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47419366546149804)
,p_plug_name=>'Cost Centers Planner Validation'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>90
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><span style="color: #ff0000;"><em>All Cost Centers included in the plan must have at least planner assigned.</em></span></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number default 0 ;',
'begin',
'',
'select COUNT(*)',
'INTO l_count',
'from budget_proposal_cost_centers_plans',
'where plan_id = :P104_PLAN_ID',
'AND BUDGET_PROPOSAL_PKG.CHECK_CC_ROLES_COUNT(PLAN_ID ,cost_center , 114)  = 0;',
'',
'   if l_count > 0',
'    Then ',
'        Return TRUE;',
'    else',
'        return FALSE;',
'    End if;',
'End ;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47419259483149803)
,p_plug_name=>'Cost Center Director  Validation'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><span style="color: #ff0000;"><em>All Cost Centers/Departments included in the plan must have Director assigned.</em></span></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number  ;',
'begin',
'',
'select COUNT(*)',
'INTO l_count',
'from budget_proposal_cost_centers_plans',
'where plan_id = :P104_PLAN_ID',
'AND BUDGET_PROPOSAL_PKG.CHECK_CC_ROLES_COUNT(PLAN_ID ,cost_center , 81)  = 0;',
'',
'   if l_count > 0',
'    Then ',
'        Return TRUE;',
'    else',
'        return FALSE;',
'    End if;',
'End ;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47418816238149798)
,p_plug_name=>'Buttons'
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
 p_id=>wwv_flow_api.id(47392060962542392)
,p_plug_name=>'Confirmation'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>you are going to submit plan <span style="color: #0000ff;"><strong><em>&P104_PLAN_NAME.</em></strong></span> to:</p>',
'<p>- Executive Directors,</p>',
'<p>- Sectors planners,</p>',
'<p>- Departments Directors.</p>',
'<p>- Departments Planners.</p>',
'<p>&nbsp;</p>',
'<p>are you sure?&nbsp;</p>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47391665639542392)
,p_plug_name=>'Chapter 2 Ceiling Validation'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(99726350799410732)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><span style="color: #ff0000;"><em>Total Sectors Opex (Chapter 2) Ceiling can not exceed Plan Ceiling.</em></span></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BUDGET_PROPOSAL_PKG.CHECK_PLAN_CEILING_EXISTS(:P104_PLAN_ID , 134)',
'    and ',
'not BUDGET_PROPOSAL_PKG.CHECK_PLAN_CEILING_MATCH(:P104_PLAN_ID , 134)'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47418679079149797)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(47418816238149798)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47418583040149796)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(47418816238149798)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47420146390149812)
,p_name=>'P104_PLAN_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(47392060962542392)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47420099554149811)
,p_name=>'P104_PLAN_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(47392060962542392)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(47418527611149795)
,p_name=>'Back DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(47418679079149797)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(47418410590149794)
,p_event_id=>wwv_flow_api.id(47418527611149795)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(47418140558149792)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Submit Process'
,p_process_sql_clob=>'BUDGET_PROPOSAL_WORKFLOW.submit(:P104_PLAN_ID , :PERSON_ID);'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(47418583040149796)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(47418087591149791)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(47418583040149796)
);
wwv_flow_api.component_end;
end;
/
