prompt --application/pages/page_00065
begin
--   Manifest
--     PAGE: 00065
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
 p_id=>65
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Submit Budget Allocation Plans to Cost Centers'
,p_alias=>'SUBMIT-BUDGET-ALLOCATION-PLANS-TO-COST-CENTERS'
,p_page_mode=>'MODAL'
,p_step_title=>'Submit Budget Allocation Plans to Cost Centers'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230212161823'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(77696748597669714)
,p_plug_name=>'hidden'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(77721866021741029)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_api.id(77696748597669714)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><span style="color: #0000ff;">you are going to submit your budget allocation plan</span> <strong><span style="color: #ff0000;">&P65_PLAN_NAME.</span></strong> <span style="color: #0000ff;">to Cost centers/Departments Planners. </span></p>',
'<p><span style="color: #0000ff;">Departments/Cost Centers Planners will receive email as well.</span></p>',
'<p><span style="color: #0000ff;">No changes allowed after submitting</span></p>',
'<p><span style="color: #0000ff;">&nbsp;If the plan not approved yet, you can return the plan for changes and submitted again (all Departments/Cost Centers planners changes will be lost).</span></p>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(77722048601741031)
,p_plug_name=>'Button'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(99731046805410735)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64679938513082777)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(77722048601741031)
,p_button_name=>'No_Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'No'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(64680354205082778)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(77722048601741031)
,p_button_name=>'Yes_Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Yes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(64678132445082770)
,p_branch_name=>'Go to 64'
,p_branch_action=>'f?p=&APP_ID.:64:&SESSION.::&DEBUG.::P64_PLAN_ID:&P65_BUDGET_ALLOCATION_PLAN_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64683415862082785)
,p_name=>'P65_BUDGET_ALLOCATION_PLAN_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(77696748597669714)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64683030962082784)
,p_name=>'P65_TOTAL_APPROVED_BUDGET_CH1'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(77696748597669714)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64682628825082784)
,p_name=>'P65_TOTAL_APPROVED_BUDGET_CH2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(77696748597669714)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64682140020082780)
,p_name=>'P65_TOTAL_APPROVED_BUDGET_CH3'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(77696748597669714)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64681789996082780)
,p_name=>'P65_TOTAL_APPROVED_BUDGET_CH6'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(77696748597669714)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(64681395235082779)
,p_name=>'P65_PLAN_NAME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(77696748597669714)
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PLAN_NAME',
'from budget_allocation_plans',
'where PLAN_ID = :P65_BUDGET_ALLOCATION_PLAN_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(64679220703082771)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(64679938513082777)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(64678656070082771)
,p_event_id=>wwv_flow_api.id(64679220703082771)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(64679623485082772)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Submit Sectors'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update budget_allocation_sectors_plans',
'set status = ''In Process''',
'where BUDGET_ALLOCATION_PLAN_ID = :P64_PLAN_ID',
'and SECTOR_ID = :P64_SECTOR_ID;',
'',
'--To Do Send Email',
'update budget_allocation_cost_centers_plans',
'set STATUS = ''Active'',',
'    RECEIVED_ON = SYSTIMESTAMP ,',
'    received_by = :PERSON_ID',
'WHERE SECTOR_ID = :P64_SECTOR_ID',
'and BUDGET_ALLOCATION_PLAN_ID = :P64_PLAN_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(64680354205082778)
);
wwv_flow_api.component_end;
end;
/
