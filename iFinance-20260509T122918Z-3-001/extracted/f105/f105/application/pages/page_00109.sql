prompt --application/pages/page_00109
begin
--   Manifest
--     PAGE: 00109
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
 p_id=>109
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Change Cost Center Ceiling'
,p_alias=>'CHANGE-COST-CENTER-CEILING'
,p_page_mode=>'MODAL'
,p_step_title=>'Change Cost Center Ceiling'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230601192646'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(43953583742021091)
,p_plug_name=>'Button'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(99731046805410735)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(43756594347771230)
,p_plug_name=>'Change Amount'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(43953419679021089)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(43953583742021091)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(43953453536021090)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(43953583742021091)
,p_button_name=>'Change'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Change'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(43954142336021097)
,p_name=>'P109_COST_CENTER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(43756594347771230)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(43954079674021096)
,p_name=>'P109_CC_PLAN_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(43756594347771230)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(43953939475021095)
,p_name=>'P109_PLAN_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(43756594347771230)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(43953857554021094)
,p_name=>'P109_SECTOR_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(43756594347771230)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(43953748942021093)
,p_name=>'P109_AMOUNT'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(43756594347771230)
,p_prompt=>'Amount'
,p_placeholder=>'Enter the change amount'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(43953664777021092)
,p_name=>'P109_TYPE'
,p_is_required=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(43756594347771230)
,p_prompt=>'Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'CHANGE_TYPES'
,p_lov=>'.'||wwv_flow_api.id(43753430507745382)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(43953252545021088)
,p_name=>'P109_CHAPTER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(43756594347771230)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(41549150117522295)
,p_name=>'P109_CEILING_TYPE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(43756594347771230)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
,p_item_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(B) Baseline Ceiling or',
'(A) Additional Ceiling'))
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(41549107096522294)
,p_name=>'P109_CEILING_DISPLAY'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(43756594347771230)
,p_prompt=>'Ceiling Display'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818110358410778)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(41548869439522292)
,p_name=>'P109_COMMENT'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(43756594347771230)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(41549519351522298)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(43953419679021089)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(41549338833522297)
,p_event_id=>wwv_flow_api.id(41549519351522298)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(43953161594021087)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Change Cost Center Ceiling Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Case :P109_CHAPTER',
'    When 134',
'        Then',
'            if :P109_CEILING_TYPE = ''B'' ',
'                Then',
'                    update budget_proposal_cost_centers_plans',
'                    set CEILING_CH2_AMOUNT = nvl(CEILING_CH2_AMOUNT,0) + decode(:P109_TYPE , ''I'', :P109_AMOUNT , ''D'' , :P109_AMOUNT * -1)',
'                    where id = :P109_CC_PLAN_ID;',
'                    ',
'                elsif :P109_CEILING_TYPE = ''A''',
'                   Then ',
'                    update budget_proposal_cost_centers_plans',
'                    set CEILING_CH2_ADDITIONAL = nvl(CEILING_CH2_ADDITIONAL,0) + decode(:P109_TYPE , ''I'', :P109_AMOUNT , ''D'' , :P109_AMOUNT * -1)',
'                    where id = :P109_CC_PLAN_ID;',
'            End if;',
'            ',
'    When 135',
'        Then',
'            if :P109_CEILING_TYPE = ''B'' ',
'                Then',
'                    update budget_proposal_cost_centers_plans',
'                    set CEILING_CH3_AMOUNT = nvl(CEILING_CH3_AMOUNT,0) + decode(:P109_TYPE , ''I'', :P109_AMOUNT , ''D'' , :P109_AMOUNT * -1)',
'                    where id = :P109_CC_PLAN_ID;',
'                    ',
'                elsif :P109_CEILING_TYPE = ''A''',
'                   Then ',
'                    update budget_proposal_cost_centers_plans',
'                    set CEILING_CH3_ADDITIONAL = nvl(CEILING_CH3_ADDITIONAL,0) + decode(:P109_TYPE , ''I'', :P109_AMOUNT , ''D'' , :P109_AMOUNT * -1)',
'                    where id = :P109_CC_PLAN_ID;',
'            End if;',
'        ',
'',
'End Case;',
'',
'INSERT INTO budget_proposal_cost_centers_plan_ceiling_changes (',
'    cc_plan_id,',
'    change_direction,',
'    baseline_type,',
'    amount,',
'    comments,',
'    chapter',
') VALUES (',
'    :P109_CC_PLAN_ID,',
'    :P109_TYPE,',
'    :P109_CEILING_TYPE,',
'    :P109_AMOUNT,',
'    :P109_COMMENT,',
'    :P109_CHAPTER',
');'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(43953453536021090)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(43953116898021086)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
