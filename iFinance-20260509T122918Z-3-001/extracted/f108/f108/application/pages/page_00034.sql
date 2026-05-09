prompt --application/pages/page_00034
begin
--   Manifest
--     PAGE: 00034
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>34
,p_user_interface_id=>wwv_flow_api.id(19279151117383422)
,p_name=>'Copy MPR  request'
,p_alias=>'COPY-MPR-REQUEST'
,p_page_mode=>'MODAL'
,p_step_title=>'Copy MPR  request'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220202112436'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11973421301745557)
,p_plug_name=>'Copy'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(19194535783383347)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'you will copy request# <b>&P34_REQUEST_NUMBER.</b>, Are you sure?'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11973058149745554)
,p_plug_name=>'BUTTONS'
,p_parent_plug_id=>wwv_flow_api.id(11973421301745557)
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(19168139315383331)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11972767526745551)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(11973058149745554)
,p_button_name=>'No'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'No'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11972879334745552)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11973058149745554)
,p_button_name=>'Copy'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(19256715332383394)
,p_button_image_alt=>'Copy'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-copy'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11973311467745556)
,p_name=>'P34_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11973421301745557)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11973186329745555)
,p_name=>'P34_REQUEST_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11973421301745557)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(11972625487745550)
,p_name=>'No DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(11972767526745551)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11972576915745549)
,p_event_id=>wwv_flow_api.id(11972625487745550)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(11972106706745544)
,p_name=>'Copy DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(11972879334745552)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11971973410745543)
,p_event_id=>wwv_flow_api.id(11972106706745544)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO mpr (',
'    creator_person_id,',
'    requestor_person_id,',
'    requestor_org_id,',
'    request_number,',
'    requested_amount,',
'    request_type,',
'    project_number,',
'    task_number,',
'    expenditure_type,',
'    initial_amount,',
'    dct_project_name,',
'    dct_project_description,',
'    submission_date,',
'    pr_number,',
'    deliverable_date,',
'    recommended_vendor_num,',
'    recommended_vendor_site_code,',
'    procurement_method,',
'    status,',
'    notes,',
'    dt_required,',
'    currency,',
'    department_id,',
'    sector_id,',
'    cost_center,',
'    fbp_person_id,',
'    fund_available_yn,',
'    new_project_yn,',
'    new_vendor_yn,',
'    recommended_vendor_name,',
'    seq_num,',
'    mpr_categpry',
') select ',
'    NV(''PERSON_ID''),',
'    requestor_person_id,',
'    requestor_org_id,',
'    (select ''MPR''                                    ||',
'        ''-''                                     ||',
'        (select nvl(s.short_name_en , ''XXX'')',
'            from organizations_details_v s',
'            where s.org_id = y.sector_id)       ||',
'        ''-''                                     ||',
'        extract(year from sysdate)              ||',
'         ''-''                                     ||',
'        (select nvl(count(*),0) + 1',
'        from mpr z',
'        where fisical_year = extract(year from sysdate))',
'        from mpr y',
'        where y.id = mpr.id),',
'    requested_amount,',
'    request_type,',
'    project_number,',
'    task_number,',
'    expenditure_type,',
'    initial_amount,',
'    dct_project_name,',
'    dct_project_description,',
'    submission_date,',
'    pr_number,',
'    deliverable_date,',
'    recommended_vendor_num,',
'    recommended_vendor_site_code,',
'    procurement_method,',
'    ''Draft'',',
'    notes,',
'    dt_required,',
'    currency,',
'    department_id,',
'    sector_id,',
'    cost_center,',
'    fbp_person_id,',
'    fund_available_yn,',
'    new_project_yn,',
'    new_vendor_yn,',
'    recommended_vendor_name,',
'    (select nvl(max(x.seq_num),0) + 1',
'    from mpr x',
'    where x.sector_id = mpr.sector_id),',
'    mpr_categpry',
'from mpr',
'where id = :P34_ID;'))
,p_attribute_02=>'P34_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11971826114745542)
,p_event_id=>wwv_flow_api.id(11972106706745544)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.component_end;
end;
/
