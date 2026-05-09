prompt --application/pages/page_00053
begin
--   Manifest
--     PAGE: 00053
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
 p_id=>53
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Copy BTF Request'
,p_alias=>'COPY-BTF-REQUEST'
,p_page_mode=>'MODAL'
,p_step_title=>'Copy BTF Request'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20221114092250'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(77170110300260855)
,p_plug_name=>'Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(77303070401358405)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(77170110300260855)
,p_button_name=>'Copy'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Copy'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(77303023499358404)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(77170110300260855)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Cancel'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(77303182304358406)
,p_name=>'P53_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(77170110300260855)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(77302248384358397)
,p_name=>'P53_BTF_NUM'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(77170110300260855)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(77302887195358403)
,p_name=>'Cancel DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(77303023499358404)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77302805103358402)
,p_event_id=>wwv_flow_api.id(77302887195358403)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(77302675961358401)
,p_name=>'Copy DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(77303070401358405)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77302578048358400)
,p_event_id=>wwv_flow_api.id(77302675961358401)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'l_seq               Number ;',
'l_request_no        varchar2(50);',
'L_REQUEST_TYPE        varchar2(1);',
'l_total_count        Number;',
'begin',
'',
'select btf_end_users_header.request_type',
'into L_REQUEST_TYPE',
'from btf_end_users_header',
'where request_id = :P53_ID ;',
'',
' SELECT BTF_END_USERS_REQ_SEQ.nextval',
'into l_seq',
'FROM all_sequences',
' WHERE sequence_owner = ''PROD''',
'   AND sequence_name = ''BTF_END_USERS_REQ_SEQ'';',
'   ',
'l_request_no := ''BTF'' || to_char(sysdate, ''yyyymmdd'') || ''/'' ',
'                   || :APP_USER                     || ''/''   ',
'                   || L_REQUEST_TYPE              ||',
'                   to_char(l_total_count);   ',
'                   ',
'    -- get total Count By Year',
'        select nvl(max(SEQ),0) + 1',
'        into l_total_count',
'        from btf_end_users_header',
'        where year = EXTRACT(year from sysdate)',
'        and REQUEST_TYPE = L_REQUEST_TYPE;                   ',
'   ',
'-- isert Header',
'   INSERT INTO btf_end_users_header (',
'    request_id,',
'    request_no,',
'    request_date,',
'    required_date,',
'    request_status,',
'    justification,',
'    year,',
'    priority,',
'    seq,',
'    request_type,',
'    SPM_PROJECT_NAME',
') select ',
'    l_seq,',
'    l_request_no,',
'    to_date(sysdate, ''DD-MON-YYYY''),',
'    to_date(sysdate + 7 , ''DD-MON-YYYY''),',
'    ''Draft'',',
'    JUSTIFICATION,',
'    EXTRACT(year from sysdate),',
'    priority,',
'    l_total_count,',
'    L_REQUEST_TYPE,',
'    null',
'from btf_end_users_header',
'where request_id = l_seq;',
'',
'-- insert Lines',
'',
'INSERT INTO btf_end_users_lines (',
'    request_id,',
'    line_no,',
'    required_date,',
'    justification,',
'    from_to,',
'    sector_id,',
'    department_id,',
'    purpose_eu,',
'    priority,',
'    project_number,',
'    task_number,',
'    expenditure_type,',
'    cost_center,',
'    gl_account,',
'    budget_group_code,',
'    activity,',
'    future1,',
'    future2,',
'    btf_request_id,',
'    source',
') VALUES (',
'    :v0,',
'    :v1,',
'    :v2,',
'    :v3,',
'    :v4,',
'    :v5,',
'    :v6,',
'    :v7,',
'    :v8,',
'    :v9,',
'    :v10,',
'    :v11,',
'    :v12,',
'    :v13,',
'    :v14,',
'    :v15,',
'    :v16,',
'    :v17,',
'    :v18,',
'    :v19',
');',
'   ',
' ',
'End;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77302468490358399)
,p_event_id=>wwv_flow_api.id(77302675961358401)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.component_end;
end;
/
