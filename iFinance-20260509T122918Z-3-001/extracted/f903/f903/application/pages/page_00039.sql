prompt --application/pages/page_00039
begin
--   Manifest
--     PAGE: 00039
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_page(
 p_id=>39
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'New User '
,p_alias=>'NEW-USER'
,p_step_title=>'New User '
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_api.id(65510978040255732)
,p_page_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'Y'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200513113532'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1926526592906746)
,p_plug_name=>'User Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1926850157906749)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(1926526592906746)
,p_button_name=>'Send'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_image_alt=>'Send'
,p_button_position=>'BELOW_BOX'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1926634631906747)
,p_name=>'P39_EMPLOYEE_NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(1926526592906746)
,p_prompt=>'Employee Number'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(65599536546255781)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1926744397906748)
,p_name=>'P39_EMPLOYEE_EMAIL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(1926526592906746)
,p_prompt=>'Employee Email'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(65599536546255781)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.component_end;
end;
/
