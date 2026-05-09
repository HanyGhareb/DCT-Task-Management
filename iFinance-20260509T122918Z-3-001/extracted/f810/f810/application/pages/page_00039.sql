prompt --application/pages/page_00039
begin
--   Manifest
--     PAGE: 00039
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>39
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Duty Travel Declaration'
,p_alias=>'DUTY-TRAVEL-DECLARATION'
,p_step_title=>'Duty Travel Declaration'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230909142112'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(78635227659882035)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12908155528762118)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12844716791762062)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12962203224762162)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(78635876501882037)
,p_plug_name=>'Declaration'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(72140052853071965)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(78635876501882037)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12881785965762100)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(59202865354832048)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(78635227659882035)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-save-as'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(59202765329832047)
,p_name=>'P39_DECLARATION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(78635876501882037)
,p_prompt=>'Declaration'
,p_display_as=>'NATIVE_RICH_TEXT_EDITOR'
,p_cSize=>30
,p_cHeight=>10
,p_field_template=>wwv_flow_api.id(12959432198762158)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'Full'
,p_attribute_03=>'Y'
,p_attribute_05=>'top'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(72140132189071966)
,p_name=>'P39_MISSION_DECLARATION_UPDATE_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(72140052853071965)
,p_prompt=>'Last Update By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES ALL LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select full_name_en  , ',
'        person_id ',
'from employees_v;'))
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(72140315420071967)
,p_name=>'P39_MISSION_DECLARATION_UPDATE_ON'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(72140052853071965)
,p_prompt=>'Last Update on'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(59202592074832045)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Init Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select MISSION_DECLARATION_HTML , MISSION_DECLARATION_UPDATE_BY , MISSION_DECLARATION_UPDATE_ON',
'into :P39_DECLARATION , :P39_MISSION_DECLARATION_UPDATE_BY , :P39_MISSION_DECLARATION_UPDATE_ON',
'from ap_default_options',
'where id= 1;',
'',
'exception',
'    when others then null;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(59202934069832049)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    ',
'update ap_default_options ',
'set MISSION_DECLARATION_HTML = :P39_DECLARATION ,',
'    MISSION_DECLARATION_UPDATE_BY = :PERSON_ID ,',
'    MISSION_DECLARATION_UPDATE_ON = systimestamp',
'where id = 1;'))
,p_process_error_message=>'fail to updated Declaration . Contact System Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(59202865354832048)
,p_process_success_message=>'Declaration updated Successfully.'
);
wwv_flow_api.component_end;
end;
/
