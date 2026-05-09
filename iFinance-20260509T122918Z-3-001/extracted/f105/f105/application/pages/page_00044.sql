prompt --application/pages/page_00044
begin
--   Manifest
--     PAGE: 00044
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
 p_id=>44
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Add Projects By Cost center'
,p_alias=>'ADD-PROJECTS-BY-COST-CENTER'
,p_page_mode=>'MODAL'
,p_step_title=>'Add Projects By Cost center'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220817081938'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(90458946074174808)
,p_plug_name=>'Select'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(90741917367552523)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(90458946074174808)
,p_button_name=>'Add'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(90741816952552522)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(90458946074174808)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(90741133609552516)
,p_branch_name=>'Go to 26'
,p_branch_action=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(90742049589552525)
,p_name=>'P44_EMPLOYEE'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(90458946074174808)
,p_prompt=>'Employee'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_07=>'Select Employee Name'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(90742012977552524)
,p_name=>'P44_COST_CENTER'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(90458946074174808)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select COST_CENTER_CODE || ''-'' || COST_CENTER_DESCRIPTION  d , COST_CENTER_CODE',
'from ',
'(',
'select distinct COST_CENTER_CODE, COST_CENTER_DESCRIPTION',
'from dct_gl_code_combinations_all',
'order by COST_CENTER_CODE',
');'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_07=>'Select Cost Center'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(90741731590552521)
,p_name=>'Cancel DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(90741816952552522)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(90741590647552520)
,p_event_id=>wwv_flow_api.id(90741731590552521)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(90741437200552519)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add Projects By CC Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'for pro in (select distinct PROJECT_NUMBER ',
'                from task ',
'                where cost_center = :P44_COST_CENTER',
'                and project_number not in (select entity_name ',
'                                            from btf_data_access_requests',
'                                            where person_id = :P44_EMPLOYEE)',
'                                            )',
'',
'loop ',
'',
'INSERT INTO btf_data_access_requests (',
'    person_id,',
'    entity_type,',
'    entity_name,',
'    request_status,',
'    start_date,',
'    priority',
') VALUES (',
'    :P44_EMPLOYEE,',
'    ''PROJECT'',',
'    pro.PROJECT_NUMBER,',
'    ''Auto-Approved'',',
'    sysdate,',
'    122',
');',
'',
'end loop;',
'',
'End;'))
,p_process_error_message=>'Something went wrong, Kindly call System Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(90741917367552523)
,p_process_success_message=>'Success.'
);
wwv_flow_api.component_end;
end;
/
