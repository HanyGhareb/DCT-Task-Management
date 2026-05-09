prompt --application/pages/page_00020
begin
--   Manifest
--     PAGE: 00020
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>20
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Initiate Credit Card Actions'
,p_alias=>'INITIATE-CREDIT-CARD-ACTIONS'
,p_page_mode=>'MODAL'
,p_step_title=>'Initiate Credit Card change request'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220131110431'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(25223086679575737)
,p_plug_name=>'Action Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25222314171575730)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(25223086679575737)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25222058759575727)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(25223086679575737)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(25158746309138447)
,p_branch_name=>'Go to 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:20::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25222990455575736)
,p_name=>'P20_CREDIT_CARD_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(25223086679575737)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25222858113575735)
,p_name=>'P20_HOLDER_NAME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(25223086679575737)
,p_prompt=>'Holder Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25222775277575734)
,p_name=>'P20_ACTION'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(25223086679575737)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25222647619575733)
,p_name=>'P20_HOLDER_PERSON_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(25223086679575737)
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25222514772575732)
,p_name=>'P20_COMMENT'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(25223086679575737)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>3
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25221979411575726)
,p_name=>'P20_ATTACH'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(25223086679575737)
,p_prompt=>'Attach'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'APEX_APPLICATION_TEMP_FILES'
,p_attribute_09=>'REQUEST'
,p_attribute_10=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25220056653575707)
,p_name=>'P20_FILE_MIMETYPE'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(25223086679575737)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25219858469575705)
,p_name=>'P20_FILE_CHARSET'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(25223086679575737)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25219718665575704)
,p_name=>'P20_UPDATED_ON'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(25223086679575737)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25159311621138453)
,p_name=>'P20_TARGET_AMOUNT'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(25223086679575737)
,p_prompt=>'Target Amount'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_display_when=>':P20_ACTION in (''I'' , ''D'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25159243409138452)
,p_name=>'P20_ACTION_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(25223086679575737)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Request Type'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25159137411138451)
,p_name=>'P20_CURRENT_AMOUNT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(25223086679575737)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25158993130138449)
,p_name=>'P20_CURRENT_AMOUNT_H'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(25223086679575737)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(25222265009575729)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(25222314171575730)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(25222193390575728)
,p_event_id=>wwv_flow_api.id(25222265009575729)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(25158893750138448)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Process Action'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P20_ACTION = ''C''',
'    Then ',
'--****',
'INSERT INTO credit_cards (',
'            creator_person_id,',
'            requestor_person_id,',
'        --    requestor_org_id,',
'            department_id,',
'            sector_id,',
'            cost_center,',
'            purpose,',
'            requested_amount,',
'            approved_amount,',
'            employee_number,',
'            mother_name,',
'            email,',
'            mobile_number,',
'            office_number,',
'            position_name,',
'            position_id,',
'            adcb_customer_yn,',
'            adcb_mobile_registered,',
'            adcb_email_registered,',
'            dct_approval_status,',
'            bank_approval_status,',
'            notes,',
'            birth_date,',
'            sex,',
'            passport_no,',
'            passport_expire_date,',
'            uae_residence_no,',
'            uae_residence_expire_date,',
'            emirates_id,',
'            emirates_id_expire_date,',
'            nationality_id,',
'            printed_name,',
'--            submission_date,',
'--            final_dct_approval,',
'--            final_bank_approval,',
'        --    created_by_person_id,',
'        --    created_on,',
'        --    updated_by_person_id,',
'        --    updated_on,',
'            full_name,',
'            employee_id,',
'            approval_type,',
'        --    target_amount,',
'            filename,',
'            file_mimetype,',
'        --    file_charset,',
'            file_blob,',
'            created_by_request_id',
')  select ',
'            NV(''PERSON_ID''),',
'          cca.HOLDER_PERSON_ID,',
'--          cca.requestor_org_id,',
'           cca.DEPARTMENT_ID,',
'           CCA.SECTOR_ID,',
'           cca.COST_CENTER,',
'           null,        -- purpose',
'           null,        --requested_amount',
'           cca.CREDIT_LIMIT,',
'           nvl(cc.employee_number, e.EMPLOYEE_NUM),',
'           nvl(cc.mother_name, e.mother_name),        ',
'	   nvl(cc.EMAIL, e.email),',
'           nvl(cc.MOBILE_NUMBER, e.MOBILE),',
'           nvl(cc.OFFICE_NUMBER, e.MOBILE),',
'	   nvl(cc.POSITION_NAME, e.POSITION),',
'           cc.POSITION_ID,',
'           cc.adcb_customer_yn,',
'           cc.adcb_mobile_registered,',
'           cc.adcb_email_registered,',
'           ''Draft'',',
'	   null,		-- bank_approval_status  ',
'	  :P20_COMMENT,',
'           nvl(cc.BIRTH_DATE , e.BIRTH_DATE),',
'           nvl(cc.sex, e.sex),',
'           cc.PASSPORT_NO,      --nvl(cc.PASSPORT_NO),',
'           cc.PASSPORT_EXPIRE_DATE, --nvl(cc.PASSPORT_EXPIRE_DATE),',
'           cc.UAE_RESIDENCE_NO, --nvl(cc.UAE_RESIDENCE_NO),',
'           cc.UAE_RESIDENCE_EXPIRE_DATE,    -- nvl(cc.UAE_RESIDENCE_EXPIRE_DATE),',
'           cc.EMIRATES_ID,      --nvl(cc.EMIRATES_ID),',
'           cc.EMIRATES_ID_EXPIRE_DATE,     --  nvl(cc.EMIRATES_ID_EXPIRE_DATE),',
'           nvl(cc.NATIONALITY_ID, e.NATIONALITY_ID),         ',
'		nvl(cc.PRINTED_NAME, e.full_name_en),',
'--		null,        --SUBMISSION_DATE',
'--	   null,        -- FINAL_DCT_APPROVAL',
'--	   null,        --FINAL_BANK_APPROVAL',
'	   nvl(cc.FULL_NAME, e.FULL_NAME_EN),',
'	   e.person_id,',
'	   5,       -- Close Credit Card',
'--	   :P20_TARGET_AMOUNT,',
'	   (select FILENAME from apex_application_temp_files),',
'	   (select MIME_TYPE from apex_application_temp_files),',
'	   (select BLOB_CONTENT from apex_application_temp_files),	  ',
'	   cc.id',
'    from credit_cards_all cca , credit_cards cc, employees_v e',
'    where cca.id = :P20_CREDIT_CARD_ID',
'    and cca.CREATED_BY_REQUEST_ID = cc.ID (+)',
'    and cca.HOLDER_PERSON_ID = e.person_id;',
'',
'                  End if;   ',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
