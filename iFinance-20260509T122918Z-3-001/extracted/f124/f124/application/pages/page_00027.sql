prompt --application/pages/page_00027
begin
--   Manifest
--     PAGE: 00027
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
 p_id=>27
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'Generate Scoping document Confirmation'
,p_alias=>'GENERATE-SCOPING-DOCUMENT-CONFIRMATION'
,p_page_mode=>'MODAL'
,p_step_title=>'Generate Scoping document Confirmation'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240229113045'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(136200732549004028)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(136201409982004035)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(137971446183351810)
,p_plug_name=>'Confirmation'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Please complete your scope of works within this application. Guidance notes are included within each step to guide you through the process.</p>',
'',
'<p>Please also attach your signed Procurement Information SoW form and signed conflict of interest forms for each technical evaluation panel member.</p>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(136200851628004029)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(136200732549004028)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(136201606435004037)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(136200732549004028)
,p_button_name=>'Start'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Let''s Start'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-paper-plane-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(136201706570004038)
,p_branch_name=>'Go to Scoping Wizard'
,p_branch_action=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.:28:P28_SCOPE_ID:&P27_SCOPING_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(136201606435004037)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(136201333149004034)
,p_name=>'P27_DP_ITEM_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(137971446183351810)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(136201537476004036)
,p_name=>'P27_SEND'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(136201409982004035)
,p_item_default=>'N'
,p_prompt=>'Send me copy of the requirements'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138255243736279215)
,p_name=>'P27_TEMPLATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(137971446183351810)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138255335687279216)
,p_name=>'P27_TEMPLATE_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(137971446183351810)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138255477287279217)
,p_name=>'P27_SCOPING_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(137971446183351810)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139017540679657702)
,p_name=>'P27_ITEM_ID_H'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(137971446183351810)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(136200905712004030)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(136200851628004029)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(136201006279004031)
,p_event_id=>wwv_flow_api.id(136200905712004030)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(136201830311004039)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Start Scoping Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'select "DP_SCOPING_SEQ".nextval into :P27_SCOPING_ID from dual;',
'',
'INSERT INTO dp_scoping_a (',
'    scope_id,',
'    scope_code,',
'    dp_item_id,',
'    project_name,',
'    project_number,',
'    date_required,',
'    main_category_id,',
'    category_id,',
'    sub_category_id,',
'    REVIEW_STATUS,',
'    APPROVAL_STATUS,',
'    template_id,',
'    task_number,',
'    task_number_new,',
'    expenditure_type,',
'    expenditure_type_new,',
'    PROVISION_OF_SERVICES',
') ',
'select ',
'      :P27_SCOPING_ID,',
'  DP_ITEM_CODE,',
'  :P27_ITEM_ID_H,',
'  PROJECT_NEW_NAME,',
'  PROJECT_NUMBER,',
'  sysdate ,     --:P11_ESTIMATED_DATE,',
'  main_category_id,',
'  CATEGORY_ID,',
'  SUB_CATEGORY_ID,',
'  ''Draft'',',
'  ''Required'',',
'  :P27_TEMPLATE_ID,',
'  :P11_task_number,',
'  :P11_TASK_NUMBER_NEW,',
'  :P11_EXPENDITURE_TYPE,',
'  :P11_EXPENDITURE_TYPE_NEW,',
'  PROJECT_DESCRIPTION',
'from dp_items',
'where ITEM_ID = :P27_ITEM_ID_H ;',
'',
'INSERT INTO dp_scoping_d (',
'    dp_scoping_d_id,',
'    template_id,',
'    dp_item_id',
') VALUES (',
'    :P27_SCOPING_ID,',
'    :P27_TEMPLATE_ID,',
'    :P27_ITEM_ID_H',
');',
'-- to insert addition Appendixes',
'--if DP_ITEMS_UTIL.get_dp_procurement_method_class_id(:P27_ITEM_ID_H) = 298',
'--Then',
'--    insert into DP_BIDDER_LIST (ITEM_ID) VALUES (:P27_SCOPING_ID);',
'--',
'--end if;',
'-- to insert addition Appendixes ******* END *********',
'',
'update dp_items set DP_SCOPING_ID = :P27_SCOPING_ID , DP_ITEM_STATUS_ID = 3 where ITEM_ID = :P27_ITEM_ID_H;',
'',
'-- Update Project Status',
'INSERT INTO dp_item_status (',
'    dp_item_id, dp_item_status_id, from_date, order_no) ',
'VALUES ',
'  (:P27_ITEM_ID_H, 3, systimestamp,(select max(nvl(ORDER_NO,1)) + 1',
'                                    from dp_item_status',
'                                    where dp_item_id = :P27_ITEM_ID_H)',
' );',
' ',
' ',
' update dp_item_status',
'set TO_DATE = systimestamp ',
'where dp_item_id = :P27_ITEM_ID_H',
'and order_no = (select max(nvl(ORDER_NO,1))',
'                from dp_item_status',
'                where dp_item_id = :P27_ITEM_ID_H); ',
'End;'))
,p_process_error_message=>'Scoping document not created .'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(136201606435004037)
,p_process_success_message=>'Scoping document created with Draft Status.'
);
wwv_flow_api.component_end;
end;
/
