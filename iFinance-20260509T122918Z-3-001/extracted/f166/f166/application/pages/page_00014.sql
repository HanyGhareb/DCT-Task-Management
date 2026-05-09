prompt --application/pages/page_00014
begin
--   Manifest
--     PAGE: 00014
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>143576171933264960
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>14
,p_user_interface_id=>wwv_flow_api.id(24631887413319249)
,p_name=>'SMD Form Settings'
,p_alias=>'SMD-FORM-SETTINGS'
,p_step_title=>'SMD Form Settings'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220306103841'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(23698797093401091)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24556678455319312)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(24493261337319361)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(24610734179319274)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(23699377191401092)
,p_plug_name=>'Single Source Submit Declaration'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(24547287062319317)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(23093389535022175)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(23698797093401091)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(24609474578319275)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-save-as'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(23093140454022173)
,p_name=>'P14_DECLARATION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(23699377191401092)
,p_prompt=>'Declaration'
,p_display_as=>'NATIVE_RICH_TEXT_EDITOR'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(24607996412319278)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--xlarge'
,p_attribute_02=>'Full'
,p_attribute_03=>'Y'
,p_attribute_05=>'top'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(23093302814022174)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Init Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DECLARATION_HTML',
'into :P14_DECLARATION',
'from scm_settings',
'where sysdate between nvl(start_date , sysdate - 10) and nvl(end_date , sysdate + 10)',
'and end_date is null',
'--and rownum = 1',
';',
'exception',
'    when others then null;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(23093467272022176)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update scm_settings set end_date = sysdate where end_date is null;',
'insert into scm_settings (DECLARATION, DECLARATION_HTML, start_date) values (:P14_DECLARATION,:P14_DECLARATION ,sysdate);'))
,p_process_error_message=>'fail to updated Settings. Contact System Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(23093389535022175)
,p_process_success_message=>'Setting updated Successfully.'
);
wwv_flow_api.component_end;
end;
/
