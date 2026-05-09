prompt --application/pages/page_00027
begin
--   Manifest
--     PAGE: 00027
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>27
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Payment Recommendation Approve / Reject - Action'
,p_alias=>'PAYMENT-RECOMMENDATION-APPROVE-REJECT-ACTION'
,p_page_mode=>'MODAL'
,p_step_title=>'Payment Recommendation Approve / Reject - Action'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220215102650'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(21907482858048063)
,p_plug_name=>'Payment Recommendation Approve / Reject - Action'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'CWIP_PAYMENT_REC_APPROVAL_HISTORY'
,p_query_where=>'PERSON_ID = :PERSON_ID'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(29920211789177131)
,p_plug_name=>'Pending Payment Recommendation'
,p_parent_plug_id=>wwv_flow_api.id(21907482858048063)
,p_icon_css_classes=>'fa-warning'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--customIcons:t-Alert--warning:t-Alert--removeHeading'
,p_plug_template=>wwv_flow_api.id(10214032995597758)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>'<b style="color:red;">There are pending payments recommendations.</b>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P27_PREVIOUS_PAYMENT_APPROVED'
,p_plug_display_when_cond2=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(21923100075048075)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(21907482858048063)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'&P27_APPROVE_LABEL.'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>':P27_ACTION = ''Approve'' and :P27_PREVIOUS_PAYMENT_APPROVED = ''N'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-check-square'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(21864435147304246)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(21907482858048063)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'&P27_REJECT_LABEL.'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>':P27_ACTION = ''Reject'' and :P27_PREVIOUS_PAYMENT_APPROVED = ''N'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-check-square'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(14393585793263277)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(21907482858048063)
,p_button_name=>'Hold'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Hold'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>':P27_ACTION = ''Hold'' and :P27_PREVIOUS_PAYMENT_APPROVED = ''N'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-pause'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(21921927460048074)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(21907482858048063)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.::P15_PAYMENT_RECOMMENDATION_ID:&P27_PAYMENT_RECOMMENDATION_ID.'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(21923507783048075)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(21907482858048063)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition_type=>'NEVER'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(21922707760048075)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(21907482858048063)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition_type=>'NEVER'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(21923815320048075)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5000223049563961)
,p_name=>'P27_APPROVE_LABEL'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5000274949563962)
,p_name=>'P27_REJECT_LABEL'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21864348421304245)
,p_name=>'P27_ACTION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21907796477048064)
,p_name=>'P27_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Id'
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(10306172661597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21908112667048065)
,p_name=>'P27_PAYMENT_RECOMMENDATION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_source=>'PAYMENT_RECOMMENDATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21908585003048065)
,p_name=>'P27_STEP_NO'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_source=>'STEP_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21908998810048066)
,p_name=>'P27_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_source=>'PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21909301795048066)
,p_name=>'P27_PERSON_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_source=>'PERSON_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21909782046048066)
,p_name=>'P27_ROLE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_source=>'ROLE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21910141597048066)
,p_name=>'P27_ACTION_REQUIRED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_prompt=>'Action Required'
,p_source=>'ACTION_REQUIRED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21910585756048067)
,p_name=>'P27_RECEVIED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_prompt=>'Recevied Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'RECEVIED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21911323491048067)
,p_name=>'P27_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21911795963048068)
,p_name=>'P27_ACTION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_source=>'ACTION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21912513370048068)
,p_name=>'P27_COMMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_prompt=>'Comments'
,p_source=>'COMMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>255
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21912942407048069)
,p_name=>'P27_APPROVAL_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_source=>'APPROVAL_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21913381123048069)
,p_name=>'P27_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21914107637048069)
,p_name=>'P27_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21914529306048070)
,p_name=>'P27_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21914954564048070)
,p_name=>'P27_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21915790855048070)
,p_name=>'P27_ON_BEHALF'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_source=>'ON_BEHALF'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21916133255048070)
,p_name=>'P27_MORE_INFO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_item_source_plug_id=>wwv_flow_api.id(21907482858048063)
,p_source=>'MORE_INFO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29920137473177130)
,p_name=>'P27_PREVIOUS_PAYMENT_APPROVED'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(21907482858048063)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_count                         number;',
'l_PAYMENT_RECOMMENDATION_ID     Number;',
'l_seq_count                     Number;',
'BEGIN',
'',
'select h.PAYMENT_RECOMMENDATION_ID',
'into l_PAYMENT_RECOMMENDATION_ID',
'from cwip_payment_rec_approval_history h',
'where h.id = :P27_ID;',
'',
'-- get SEQ_COUNT',
'select c.seq_count',
'into l_seq_count',
'from cwip_payment_recommendation c',
'where c.payment_recommendation_id = l_PAYMENT_RECOMMENDATION_ID;',
'',
'SELECT count(*)',
'into l_count',
'from cwip_payment_rec_approval_history h , cwip_payment_recommendation c',
'where h.payment_recommendation_id = c.payment_recommendation_id',
'and person_id = :PERSON_ID',
'and c.contract_number = (Select x.contract_number',
'                        from cwip_payment_recommendation x',
'                        where x.payment_recommendation_id = l_PAYMENT_RECOMMENDATION_ID)',
'and h.status = ''Pending''',
'and h.id <> :P27_ID',
'and c.seq_count < l_seq_count;',
'',
'if l_count > 1 then return ''Y'';',
'else return ''N'';',
'end if;',
'END;'))
,p_source_type=>'FUNCTION_BODY'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(21911087700048067)
,p_validation_name=>'P27_RECEVIED_DATE must be timestamp'
,p_validation_sequence=>70
,p_validation=>'P27_RECEVIED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(21910585756048067)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(21912271321048068)
,p_validation_name=>'P27_ACTION_DATE must be timestamp'
,p_validation_sequence=>90
,p_validation=>'P27_ACTION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(21911795963048068)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(21913865185048069)
,p_validation_name=>'P27_CREATED_ON must be timestamp'
,p_validation_sequence=>120
,p_validation=>'P27_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(21913381123048069)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(21915409089048070)
,p_validation_name=>'P27_UPDATED_ON must be timestamp'
,p_validation_sequence=>150
,p_validation=>'P27_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(21914954564048070)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(21924702792048076)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(21907482858048063)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Payment Recommendation Approve / Reject - Action'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(21864203398304244)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approve Action'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'cwip_rec_payment_workflow.approve(:P27_PAYMENT_RECOMMENDATION_ID,:PERSON_ID, :P27_COMMENTS);',
'cwip_rec_payment_emails.CONFIRM_PAYMENT_APP_ACTION_EMAIL(:P27_PAYMENT_RECOMMENDATION_ID, :PERSON_ID, :PERSON_TYPE, :P27_ID,''A'');',
'',
'End;'))
,p_process_error_message=>'Error while approve, Please contact system admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(21923100075048075)
,p_process_success_message=>'Approved Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(21864598430304247)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reject Action'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'cwip_rec_payment_workflow.REJECTED(:P27_PAYMENT_RECOMMENDATION_ID,:PERSON_ID, :P27_COMMENTS);',
'cwip_rec_payment_emails.CONFIRM_PAYMENT_APP_ACTION_EMAIL(:P27_PAYMENT_RECOMMENDATION_ID, :PERSON_ID, :PERSON_TYPE, :P27_ID,''R'');',
'End;'))
,p_process_error_message=>'Error while Reject, Please contact system admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(21864435147304246)
,p_process_success_message=>'Rejected.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(14393735923263278)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Hold Action'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'cwip_rec_payment_workflow.Hold(:P27_PAYMENT_RECOMMENDATION_ID,:PERSON_ID, :P27_COMMENTS);',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(14393585793263277)
,p_process_success_message=>'Payment Application On Hold.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(21924397139048075)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(21907482858048063)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Payment Recommendation Approve / Reject - Action'
);
wwv_flow_api.component_end;
end;
/
