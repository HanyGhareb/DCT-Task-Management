prompt --application/pages/page_00028
begin
--   Manifest
--     PAGE: 00028
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>28
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'ADERP Account'
,p_alias=>'ADERP-ACCOUNT'
,p_step_title=>'ADERP Account'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220726113109'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47127471900757490)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1611180433302287)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(1547752126302241)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(1665264360302322)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(115608878916417336)
,p_plug_name=>'ADERP Account'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47124237145757487)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(47127471900757490)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47124662390757487)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(47127471900757490)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition_type=>'NEVER'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47125052740757488)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(47127471900757490)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Synch'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(47163697041840301)
,p_branch_name=>'Go to 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(115608989914417337)
,p_name=>'P28_PERSON_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(115608878916417336)
,p_prompt=>'Person ID'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(1662565247302319)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(115609013140417338)
,p_name=>'P28_USERNAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(115608878916417336)
,p_prompt=>'Username'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(1662565247302319)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(115609188792417339)
,p_name=>'P28_PASSWORD'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(115608878916417336)
,p_prompt=>'Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(1662565247302319)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(115609222754417340)
,p_name=>'P28_EMAIL'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(115608878916417336)
,p_prompt=>'Email'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(1662565247302319)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(115609363672417341)
,p_name=>'P28_STATUS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(115608878916417336)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(1662565247302319)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(115609482031417342)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Current User details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    e.person_id,',
'    e.user_name,',
'    e.email,',
'    decode(u.status, ''S'' , ''Success on '' , ',
'                   ''F'' , ''Fail on '',',
'                   ''C'' , ''Synch requested on '') || to_char(last_update_on , ''DD-Mon-YYYY HH12:MM:SS'')  Status',
'INTO',
'    :P28_PERSON_ID,',
'    :P28_USERNAME,',
'    :P28_EMAIL,',
'    :P28_STATUS',
'FROM',
'    aderp_users u , employees_v e',
'where u.person_id (+) = e.person_id',
'and e.person_id = :PERSON_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(115609578272417343)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Password Changes Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update aderp_users ',
'set password = :P28_PASSWORD, CHANGED = ''Y'' , Status = ''C''',
'where person_id = :PERSON_ID;',
'',
'',
'declare',
'l_count    number;',
'begin',
'',
'select count(*)',
'into l_count',
'from aderp_users',
'where person_id = :PERSON_ID;',
'',
'IF L_COUNT = 1',
'    THEN',
'        update aderp_users set password = :P28_PASSWORD, CHANGED = ''Y'' , Status = ''C'' where person_id = :PERSON_ID;',
'    else',
'        insert into aderp_users (person_id, username, password,changed, email , Status) values (:PERSON_ID,:P28_USERNAME, :P28_PASSWORD, ''Y'', :P28_EMAIL , ''C'');',
' end if;',
' ',
' End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(47125052740757488)
,p_process_success_message=>'Synchronous request has been submitted, you will notify Soon.'
);
wwv_flow_api.component_end;
end;
/
