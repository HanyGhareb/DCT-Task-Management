prompt --application/pages/page_00062
begin
--   Manifest
--     PAGE: 00062
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
 p_id=>62
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Set Accounting Year'
,p_alias=>'SET-ACCOUNTING-YEAR'
,p_page_mode=>'MODAL'
,p_step_title=>'Set Accounting Year'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230130041638'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(68403809231892307)
,p_plug_name=>'Set Accounting Year'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(68403360286892303)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(68403809231892307)
,p_button_name=>'Close'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(68403499054892304)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(68403809231892307)
,p_button_name=>'SET'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Set'
,p_button_position=>'REGION_TEMPLATE_CREATE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(68403162812892301)
,p_branch_name=>'Go To Home'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(68403693050892306)
,p_name=>'P62_CURRENT_YEAR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(68403809231892307)
,p_prompt=>'Current Year'
,p_source=>'CURRENT_YEAR'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(68403604762892305)
,p_name=>'P62_SET_ACCOUNTING_YEAR'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(68403809231892307)
,p_item_default=>'CURRENT_YEAR'
,p_item_default_type=>'ITEM'
,p_prompt=>'Set To'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:2017;2017,2018;2018,2019;2019,2020;2020,2021;2021,2022;2022,2023;2023'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(68403247052892302)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Accounting Year Process'
,p_process_sql_clob=>':CURRENT_YEAR := :P62_SET_ACCOUNTING_YEAR;'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
