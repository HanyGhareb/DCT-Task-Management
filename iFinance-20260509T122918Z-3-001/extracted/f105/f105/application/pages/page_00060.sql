prompt --application/pages/page_00060
begin
--   Manifest
--     PAGE: 00060
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
 p_id=>60
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Submit Budget Allocation Plans to Sectors'
,p_alias=>'SUBMIT-BUDGET-ALLOCATION-PLANS-TO-SECTORS'
,p_page_mode=>'MODAL'
,p_step_title=>'Submit Budget Allocation Plans to Sectors'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230219114444'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70903284373432127)
,p_plug_name=>'hidden'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70878166949360812)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_api.id(70903284373432127)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><span style="color: #0000ff;">you are going to submit your budget allocation plan</span> <strong><span style="color: #ff0000;">&amp;P60_PLAN_NAME.</span></strong> <span style="color: #0000ff;">to Sectors Planners.</span></p>',
'<p><span style="color: #0000ff;">The Deadline to allocate the approved budget on all levels: <strong><span style="color: #ff0000;">&P60_DEADLINE.</span></strong></span></p>',
'<p><span style="color: #0000ff;">Sector Planners will receive email as well.</span></p>',
'<p><span style="color: #0000ff;">No changes allowed after submitting</span></p>',
'<p><span style="color: #0000ff;">&nbsp;If the plan not approved yet, you can return the plan for changes and submitted again (all sectors planners changes will be lost).</span></p>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70877984369360810)
,p_plug_name=>'Button'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noBorder'
,p_plug_template=>wwv_flow_api.id(99731046805410735)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70877871726360809)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(70877984369360810)
,p_button_name=>'No_Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'No, Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70878124203360811)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(70877984369360810)
,p_button_name=>'Yes_Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Yes, Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(70877473393360805)
,p_branch_name=>'Go to 59'
,p_branch_action=>'f?p=&APP_ID.:59:&SESSION.::&DEBUG.::P59_PLAN_ID:&P60_BUDGET_ALLOCATION_PLAN_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(71030526507770913)
,p_name=>'P60_BUDGET_ALLOCATION_PLAN_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(70903284373432127)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(71030378286770912)
,p_name=>'P60_TOTAL_APPROVED_BUDGET_CH1'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(70903284373432127)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(71030234840770911)
,p_name=>'P60_TOTAL_APPROVED_BUDGET_CH2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(70903284373432127)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(71030202489770910)
,p_name=>'P60_TOTAL_APPROVED_BUDGET_CH3'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(70903284373432127)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(71030100596770909)
,p_name=>'P60_TOTAL_APPROVED_BUDGET_CH6'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(70903284373432127)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(71029998815770908)
,p_name=>'P60_PLAN_NAME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(70903284373432127)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(62054168540305590)
,p_name=>'P60_DEADLINE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(70903284373432127)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(62054131283305589)
,p_computation_sequence=>10
,p_computation_item=>'P60_DEADLINE'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(first_dead_line , ''DD-Mon-YYYY'')',
'from budget_allocation_plans',
'where plan_id = :P60_BUDGET_ALLOCATION_PLAN_ID'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70877792766360808)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(70877871726360809)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70877713050360807)
,p_event_id=>wwv_flow_api.id(70877792766360808)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(70877626532360806)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Submit Sectors'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'',
'l_future2 varchar2(50);',
'',
'begin',
'',
'select FUTURE2_USED',
'into l_future2',
'from budget_allocation_plans',
'where plan_id = :P60_BUDGET_ALLOCATION_PLAN_ID;',
'',
'-- Insert Cost Centers -- Page 60',
'for sec IN (select sector_id, SCENARIO , SCENARIO_desc',
'            from budget_allocation_sectors_plans',
'            where budget_allocation_plan_id = :P60_BUDGET_ALLOCATION_PLAN_ID)',
'',
'loop   ',
'      for cc_list in (select distinct COST_CENTER_CODE',
'                      from  GL_CODE_COMBINATIONS_V ',
'                      where SECTOR_ID = sec.sector_id',
'                      and status = ''A''',
'                      and sysdate between nvl(start_date , sysdate - 10)',
'                            and nvl(end_date , sysdate + 10))  ',
'        Loop                    ',
'            INSERT INTO budget_allocation_cost_centers_plans (',
'                budget_allocation_plan_id,',
'                sector_id,',
'                cost_center,',
'                status,',
'                scenario,',
'                scenario_desc',
'            ) VALUES (',
'                :P60_BUDGET_ALLOCATION_PLAN_ID,',
'                sec.sector_id,',
'                cc_list.cost_center_code,',
'                ''Draft'',',
'                sec.scenario,',
'                sec.scenario_desc',
'            );',
'            --***************projects',
'            INSERT INTO budget_allocation_projects_plans (',
'                                                budget_allocation_plan_id,',
'                                                project_number,',
'                                                task_number,',
'                                                expenditure_type,',
'                                                entity_code,',
'                                                cost_center,',
'                                                budget_groub_code,',
'                                                gl_account,',
'                                                activity,',
'                                                future1,',
'                                                future2,',
'                                                sector_id,',
'                                                scenario,',
'                                                approved_budget,',
'                                                --approved_budget_ch1,',
'                                                --approved_budget_ch2,',
'                                                --approved_budget_ch3,',
'                                                --approved_budget_ch6,',
'                                                status,',
'                                                comments',
') select ',
'        :P60_BUDGET_ALLOCATION_PLAN_ID',
'       , PROJECT_NUMBER',
'       , TASK_NUMBER',
'       , EXPENDITURE_TYPE',
'       , ''451''',
'       , cc_list.cost_center_code',
'       , BUDGET_GROUP_CODE',
'       , GL_ACCOUNT',
'       , ACTIVITY',
'       , FUTURE1',
'       , FUTURE2 ',
'       , sec.sector_id',
'       , sec.scenario',
'       , 0',
'      -- , 0',
'      -- , 0',
'      -- , 0',
'       , ''Draft''',
'       , null',
'    FROM',
'        (select PROJECT_NUMBER, TASK_NUMBER, EXPENDITURE_TYPE, BUDGET_GROUP_CODE, GL_ACCOUNT, ACTIVITY, FUTURE1, FUTURE2',
'            from expenditures_v',
'            where cost_center = cc_list.cost_center_code',
'            and future2 in (select * from apex_string.split(l_future2,'':''))',
'        );',
'            ',
'            --***************projects',
'       end loop;',
'  end loop;     ',
'',
'update budget_allocation_plans',
'set status = ''In Process'',',
'    submitted_by = :PERSON_ID,',
'    submitted_on = SYSTIMESTAMP',
'where plan_id = :P60_BUDGET_ALLOCATION_PLAN_ID;',
'',
'End;',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(70878124203360811)
);
wwv_flow_api.component_end;
end;
/
