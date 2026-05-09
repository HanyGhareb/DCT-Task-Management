prompt --application/pages/page_00042
begin
--   Manifest
--     PAGE: 00042
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>42
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'DP Scoping Guideline'
,p_alias=>'DP-SCOPING-GUIDELINE'
,p_page_mode=>'MODAL'
,p_step_title=>'DP Scoping Guideline'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230208040350'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(139273835050859337)
,p_plug_name=>'Guideline'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(139274293447859341)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(127777381735449810)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139274385411859342)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(139274293447859341)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865952197449732)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2238203344188044)
,p_name=>'P42_HELP_TEXT'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(139273835050859337)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Help Text'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P28_TEMPLATE_ID , :P42_DATA_POINT_ID ) ',
'from dual;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2238282144188045)
,p_name=>'P42_DATA_POINT_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(139273835050859337)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2238408167188046)
,p_name=>'P42_TEMPLATE_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(139273835050859337)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139273973536859338)
,p_name=>'P42_HELP'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(139273835050859337)
,p_prompt=>'Guideline for &P42_LABEL.'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139274008035859339)
,p_name=>'P42_LABEL'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(139273835050859337)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139348293840743111)
,p_name=>'P42_COMPONENT_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(139273835050859337)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139274474315859343)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(139274385411859342)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139274588097859344)
,p_event_id=>wwv_flow_api.id(139274474315859343)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(139348176704743110)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Help By CompenetID'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(GUIDELINE , ''Guideline not available.'') GUIDELINE',
'into :P42_HELP',
'from dp_scope_components ',
'where COMPONENT_ID = :P42_COMPONENT_ID;',
'Exception',
'    when others',
'        Then Null;',
'     '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
