prompt --application/pages/page_00071
begin
--   Manifest
--     PAGE: 00071
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
 p_id=>71
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'Generate Purchase Requisition '
,p_alias=>'PR-GENERATION'
,p_page_mode=>'MODAL'
,p_step_title=>'Generate Purchase Requisition '
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230423191832'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141478992976711171)
,p_plug_name=>'Budget Availability'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><span style="color: #ff0000;">No Fund available to serve your PR!</span></p>',
'<p>Fund Available: &P71_FUND_AVAILABLE_F. AED.</p>',
'<p>Estimated Budget required: &P11_ESTIMATED_BUDGET. AED </p>',
''))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P71_FUND_AVAILABLE < :P11_ESTIMATED_BUDGET_H'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141478855569711170)
,p_plug_name=>'Hidden'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3667334905973239)
,p_plug_name=>'Dispatcher Availability'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><span style="color: #ff0000;">There is no Dispatcher available!</span></p>',
'<p>Fund Available: &P71_FUND_AVAILABLE_F. AED.</p>',
'<p>Estimated Budget required: &P11_ESTIMATED_BUDGET. AED </p>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P71_FUND_AVAILABLE >= :P11_ESTIMATED_BUDGET_H'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3667716107973242)
,p_plug_name=>'Button'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127777381735449810)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3667581956973241)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(3667716107973242)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141478247945711164)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(3667716107973242)
,p_button_name=>'Generate'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Generate'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P11_APPROVAL_STATUS = ''Approved'' 	and ',
'nvl(:P11_ESTIMATED_BUDGET_H,0) <= 50000 and',
':P11_PR_GENERATION_STATUS   not in (''S'' , ''A'')	and',
':P11_PR_NUMBER		   is null 	and ',
':P71_FUND_AVAILABLE >= :P11_ESTIMATED_BUDGET_H'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-credit-card-terminal'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(141477544368711157)
,p_branch_name=>'Go To 11'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ITEM_ID,P11_ITEM_ID_H:&P71_ITEM_ID.,&P71_ITEM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(141478247945711164)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141478784091711169)
,p_name=>'P71_FUND_AVAILABLE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141478855569711170)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141478698933711168)
,p_name=>'P71_FUND_AVAILABLE_F'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(141478855569711170)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141477684110711158)
,p_name=>'P71_ITEM_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(141478855569711170)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3667747111973243)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3667581956973241)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3667880025973244)
,p_event_id=>wwv_flow_api.id(3667747111973243)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(141478566434711167)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DP_ITEMS_UTIL.CHECK_DP_ITEM_FUND(:P11_item_id ,:P11_ESTIMATED_YEAR,''F'') , to_char(DP_ITEMS_UTIL.CHECK_DP_ITEM_FUND(:P11_item_id ,:P11_ESTIMATED_YEAR,''F'') , ''99,999,999,999.99'')',
'into :P71_FUND_AVAILABLE , :P71_FUND_AVAILABLE_F',
'from dual;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(141478133503711163)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Generate PR Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO dp_items_pr_requests (',
'    item_id,',
'    status',
') VALUES (',
'    :P11_ITEM_ID,',
'    ''A''',
');',
'',
'update dp_items',
'set pr_generation_status = ''A''      -- available to RPA',
'    , pr_submitted_on = systimestamp',
'where item_id = :P11_ITEM_ID;',
'',
':P11_ITEM_ID := :P71_ITEM_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(141478247945711164)
,p_process_success_message=>'ssssssssssss'
);
wwv_flow_api.component_end;
end;
/
