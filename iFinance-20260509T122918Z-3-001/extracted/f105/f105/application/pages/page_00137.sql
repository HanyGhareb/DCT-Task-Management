prompt --application/pages/page_00137
begin
--   Manifest
--     PAGE: 00137
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
 p_id=>137
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Copy from End User'
,p_alias=>'COPY-FROM-END-USER'
,p_page_mode=>'MODAL'
,p_step_title=>'Copy from End User'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240208103955'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12324015255351102)
,p_plug_name=>'Copy from End User'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'you are going to copy from End User Cashflow, Are you sure?'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12324089926351103)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12324431808351106)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(12324089926351103)
,p_button_name=>'No'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'No'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12324343267351105)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(12324089926351103)
,p_button_name=>'Yes'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Yes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(12324803317351110)
,p_branch_name=>'Go to 127'
,p_branch_action=>'f?p=&APP_ID.:127:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12324545832351107)
,p_name=>'No Da'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(12324431808351106)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12324624500351108)
,p_event_id=>wwv_flow_api.id(12324545832351107)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(12324745564351109)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update ba_projects_allocation',
'set ',
'ALLOCATED_BUDGET_FBP = ALLOCATED_BUDGET_EU ,',
'JAN_FBP = JAN_EU,',
'FEB_FBP = FEB_EU,',
'MAR_FBP = MAR_EU,',
'APR_FBP = APR_EU,',
'MAY_FBP = MAY_EU,',
'JUN_FBP = JUN_EU,',
'JUL_FBP = JUL_EU,',
'AUG_FBP = AUG_EU,',
'SEP_FBP = SEP_EU,',
'OCT_FBP = OCT_EU,',
'NOV_FBP = NOV_EU,',
'DEC_FBP = DEC_EU',
'where COST_CENTER_CODE = :P127_COST_CENTER',
'and FISICAL_YEAR = :P127_YEAR;'))
,p_process_error_message=>'Error'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(12324343267351105)
,p_process_success_message=>'Copied'
);
wwv_flow_api.component_end;
end;
/
