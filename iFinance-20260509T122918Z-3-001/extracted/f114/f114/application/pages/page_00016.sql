prompt --application/pages/page_00016
begin
--   Manifest
--     PAGE: 00016
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>114
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>16
,p_user_interface_id=>wwv_flow_api.id(52958449993734913)
,p_name=>'Check Expire '
,p_alias=>'CHECK-EXPIRE'
,p_page_mode=>'MODAL'
,p_step_title=>'Check Expire '
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220615082004'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(111638430420816119)
,p_plug_name=>'Button'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(52847423684734857)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(111730803005298286)
,p_plug_name=>'Check Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(111638622917816121)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(111638430420816119)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(111638573510816120)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(111638430420816119)
,p_button_name=>'Replace'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_image_alt=>'Replace'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_icon_css_classes=>'fa-repeat'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(111639114413816126)
,p_branch_name=>'Go To 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(111638131640816116)
,p_name=>'P16_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(111730803005298286)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(111638285515816117)
,p_name=>'P16_NEW_CHECK_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(111730803005298286)
,p_prompt=>'New Check Number'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(52934951552734894)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(111638354299816118)
,p_name=>'P16_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(111730803005298286)
,p_prompt=>'New Check Date'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(52934951552734894)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(111639082273816125)
,p_validation_name=>'Required Expire Info'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if     :P16_NEW_CHECK_NUMBER is null or ',
'    :P16_DATE is null or :P16_ID is null',
'   then return false;',
'ENd if;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Please enter the new check number and date.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(111638744314816122)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(111638622917816121)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(111638873963816123)
,p_event_id=>wwv_flow_api.id(111638744314816122)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(111638928890816124)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Replace '
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update manager_checks',
'set STATUS = ''Expired'', expired_by = :PERSON_ID, expired_on = SYSTIMESTAMP ',
'where id = :P16_ID;',
'',
'INSERT INTO manager_checks (',
'    supplier_name,',
'    currency,',
'    amount,',
'    amount_in_aed,',
'    descriptions,',
'    pv,',
'    payment_no,',
'    list,',
'    payment_type,',
'    milestone_description,',
'    milestone_date,',
'    end_user_email,',
'    project,',
'    task,',
'    cost_center,',
'    gl_account,',
'    uploaded_by,',
'    uploaded_on,',
'    updated_by,',
'    updated_on,',
'    status,',
'    comments,',
'    end_user_person_id,',
'    email,',
'    submission_on,',
'    submit_by,',
'    final_approve_on,',
'    final_approve_by,',
'    receiving_person_name,',
'    emirates_id,',
'    check_num,',
'    expire_date,',
'    fisical_year,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    bank_grantee_number,',
'    contract_number',
') select',
' supplier_name,',
'    currency,',
'    amount,',
'    amount_in_aed,',
'    descriptions,',
'    pv,',
'    payment_no,',
'    list,',
'    payment_type,',
'    milestone_description,',
'    milestone_date,',
'    end_user_email,',
'    project,',
'    task,',
'    cost_center,',
'    gl_account,',
'    uploaded_by,',
'    uploaded_on,',
'    updated_by,',
'    updated_on,',
'    ''Hold'',',
'    comments,',
'    end_user_person_id,',
'    email,',
'    submission_on,',
'    submit_by,',
'    final_approve_on,',
'    final_approve_by,',
'    receiving_person_name,',
'    emirates_id,',
'    :P16_NEW_CHECK_NUMBER,',
'    :P16_DATE,',
'    fisical_year,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    bank_grantee_number,',
'    contract_number',
'    from manager_checks',
'    where id = :P16_ID;'))
,p_process_error_message=>'Can''t Expired'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(111638573510816120)
,p_process_success_message=>'Expired'
);
wwv_flow_api.component_end;
end;
/
