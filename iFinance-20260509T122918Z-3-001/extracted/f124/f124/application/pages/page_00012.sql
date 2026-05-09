prompt --application/pages/page_00012
begin
--   Manifest
--     PAGE: 00012
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
 p_id=>12
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'DP Item Review Action'
,p_alias=>'DP-ITEM-REVIEW-ACTION'
,p_page_mode=>'MODAL'
,p_step_title=>'DP Item Review Action'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231210182426'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128677470039987419)
,p_plug_name=>'Details'
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
 p_id=>wwv_flow_api.id(3921167756208483)
,p_plug_name=>'Only for Finance Business Partner'
,p_parent_plug_id=>wwv_flow_api.id(128677470039987419)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--accent14:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':IS_FBP_EMP = ''Y'' and (:P18_PROJECT_NEW_YN = ''Y'' or (:P18_PROJECT_NEW_YN = ''N'' and :P18_TASK_NEW_YN = ''Y''))'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(9844480840608640)
,p_plug_name=>'New Project Case A'
,p_parent_plug_id=>wwv_flow_api.id(3921167756208483)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P18_PROJECT_NEW_YN'
,p_plug_display_when_cond2=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(9844604545608641)
,p_plug_name=>'Existing Project - New Task Case B'
,p_parent_plug_id=>wwv_flow_api.id(3921167756208483)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P18_PROJECT_NEW_YN = ''N'' and :P18_TASK_NEW_YN = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3921274506208484)
,p_plug_name=>'Detials In'
,p_parent_plug_id=>wwv_flow_api.id(128677470039987419)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128678292095987427)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127777381735449810)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128678991025987434)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(128678292095987427)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128678324882987428)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(128678292095987427)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P12_ACTION'
,p_button_condition2=>'Approve'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128678490329987429)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(128678292095987427)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P12_ACTION'
,p_button_condition2=>'Reject'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128678588922987430)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(128678292095987427)
,p_button_name=>'Delegate'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P12_ACTION'
,p_button_condition2=>'Delegate'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128678641679987431)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(128678292095987427)
,p_button_name=>'Return'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P12_ACTION'
,p_button_condition2=>'Return'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128678731685987432)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(128678292095987427)
,p_button_name=>'Cancel'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P12_ACTION'
,p_button_condition2=>'CANCEL'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128678819953987433)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(128678292095987427)
,p_button_name=>'Withdraw'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P12_ACTION'
,p_button_condition2=>'Withdraw'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(128679882581987443)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(679170306236372)
,p_name=>'P12_CONTRACT_NO'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(3921274506208484)
,p_prompt=>'Contract No'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_grid_label_column_span=>3
,p_display_when=>':P12_ACTION = ''Approve'' and :P12_ROLE_ID = 108'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3921359245208485)
,p_name=>'P12_TASK_NEW_YN_B'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(9844604545608641)
,p_use_cache_before_default=>'NO'
,p_prompt=>'New Task ?'
,p_source=>'P18_TASK_NEW_YN'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3921459830208486)
,p_name=>'P12_TASK_NUMBER_B'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(9844604545608641)
,p_prompt=>'Task Number'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'TASKS BY PROJECT NUMBER PAGE 18'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select TASK_NUMBER  Task, TASK_DESCRIPTION, COST_CENTER, FUTURE2',
'from tasks_all_v',
'where project_number = :P18_PROJECT_NUMBER ;'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9844193160608637)
,p_name=>'P12_TASK_NUMBER_NEW_B'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(9844604545608641)
,p_use_cache_before_default=>'NO'
,p_prompt=>'New Task Name'
,p_source=>'P18_TASK_NUMBER_NEW'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_named_lov=>'TASKS ALL (SAMPLE)'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct TASK_NUMBER d, TASK_NUMBER R',
'from tasks_all_v',
'where task_number not like ''?%''',
'order by 1;'))
,p_cSize=>30
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>'Max 25 Character.'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9844315536608638)
,p_name=>'P12_EXPENDITURE_TYPE_B'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(9844604545608641)
,p_prompt=>'Expenditure Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'EXPENDITURE TYPES BY PAGE 18'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EXPENDITURE_TYPE, DESCRIPTION, GL_ACCOUNT, GL_ACCOUNT_NAME',
'from expenditures_v',
'where project_number = :P18_PROJECT_NUMBER',
'and TASK_NUMBER = :P12_TASK_NUMBER_B ;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P12_TASK_NUMBER_B'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9844404308608639)
,p_name=>'P12_EXPENDITURE_TYPE_NEW_B'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(9844604545608641)
,p_use_cache_before_default=>'NO'
,p_prompt=>'New Expenditure Type'
,p_source=>'P18_EXPENDITURE_TYPE_NEW'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EXPENDITURES ALL'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct EXPENDITURE_TYPE d, EXPENDITURE_TYPE r',
'from expenditures_v',
'order by 1'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9844724440608642)
,p_name=>'P12_COST_CENTER_B'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(9844604545608641)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'COST CENTERS WITH NAMES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select COST_CENTER_CODE || ''('' || COST_CENTER_DESCRIPTION || '')'' display, COST_CENTER_CODE',
'from( ',
'select DISTINCT COST_CENTER_CODE , COST_CENTER_DESCRIPTION ',
'from dct_gl_code_combinations_all);'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9844764348608643)
,p_name=>'P12_FUTURE2_B'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(9844604545608641)
,p_prompt=>'Future2'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'FUTRURE2 ALL'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct FUTURE2, FUTURE2 || ''('' || FUTURE2_DESCRIPTION || '')'' d',
'from dct_gl_code_combinations_all',
'order by 1'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9844904365608644)
,p_name=>'P12_TASK_NUMBER_NEW_A'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(9844480840608640)
,p_use_cache_before_default=>'NO'
,p_prompt=>'New Task'
,p_source=>'P18_TASK_NUMBER_NEW'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_named_lov=>'TASKS ALL (SAMPLE)'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct TASK_NUMBER d, TASK_NUMBER R',
'from tasks_all_v',
'where task_number not like ''?%''',
'order by 1;'))
,p_cSize=>30
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9844979569608645)
,p_name=>'P12_EXPENDITURE_TYPE_NEW_A'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(9844480840608640)
,p_use_cache_before_default=>'NO'
,p_prompt=>'New Expenditure Type'
,p_source=>'P18_EXPENDITURE_TYPE_NEW'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EXPENDITURES ALL'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct EXPENDITURE_TYPE d, EXPENDITURE_TYPE r',
'from expenditures_v',
'order by 1'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9845093097608646)
,p_name=>'P12_COST_CENTER_A'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(9844480840608640)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Cost Center'
,p_source=>'P18_COST_CENTER'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'COST CENTERS WITH NAMES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select COST_CENTER_CODE || ''('' || COST_CENTER_DESCRIPTION || '')'' display, COST_CENTER_CODE',
'from( ',
'select DISTINCT COST_CENTER_CODE , COST_CENTER_DESCRIPTION ',
'from dct_gl_code_combinations_all);'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(9845172513608647)
,p_name=>'P12_FUTURE2_A'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(9844480840608640)
,p_prompt=>'Future2'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'FUTRURE2 ALL'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct FUTURE2, FUTURE2 || ''('' || FUTURE2_DESCRIPTION || '')'' d',
'from dct_gl_code_combinations_all',
'order by 1'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128677502721987420)
,p_name=>'P12_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(128677470039987419)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128677679653987421)
,p_name=>'P12_ACTION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(128677470039987419)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128677758237987422)
,p_name=>'P12_HISTORY_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(128677470039987419)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128677827398987423)
,p_name=>'P12_PERSON_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(128677470039987419)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128677973383987424)
,p_name=>'P12_ROLE_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(128677470039987419)
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ROLE_ID ',
'from dp_items_approval_history',
'where id = :P12_HISTORY_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128678074279987425)
,p_name=>'P12_TO_PERSON_ID'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3921274506208484)
,p_prompt=>'Delegate To'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_display_when=>'P12_ACTION'
,p_display_when2=>'Delegate'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_07=>'Delegate To'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128678140818987426)
,p_name=>'P12_COMMENT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(3921274506208484)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>3
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(135478259896364518)
,p_name=>'P12_DP_PROCUREMENT_METHOD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(3921274506208484)
,p_prompt=>'Procurement Method'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'DP PROCUREMENT METHOD'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select TENDER_TYPE , ID',
' from DP_PROCUREMENT_METHOD',
' where status = ''A''',
' and sysdate between nvl(start_date , sysdate - 10)',
'                and nvl(End_date , sysdate + 10)',
' '))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_display_when=>':P12_ACTION = ''Approve'' and :P12_ROLE_ID = 108'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(128679000043987435)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(128678991025987434)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128679184534987436)
,p_event_id=>wwv_flow_api.id(128679000043987435)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3011938947758542)
,p_name=>'PROCUREMENT_METHOD DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P12_DP_PROCUREMENT_METHOD'
,p_condition_element=>'P12_DP_PROCUREMENT_METHOD'
,p_triggering_condition_type=>'IN_LIST'
,p_triggering_expression=>'6,7'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3012050030758543)
,p_event_id=>wwv_flow_api.id(3011938947758542)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_CONTRACT_NO'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3012397954758546)
,p_event_id=>wwv_flow_api.id(3011938947758542)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_CONTRACT_NO'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3012314243758545)
,p_event_id=>wwv_flow_api.id(3011938947758542)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_CONTRACT_NO'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(9845411288608649)
,p_name=>'Task Number NewB DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P12_TASK_NEW_YN_B'
,p_condition_element=>'P12_TASK_NEW_YN_B'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(9845451280608650)
,p_event_id=>wwv_flow_api.id(9845411288608649)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_TASK_NUMBER_NEW_B,P12_EXPENDITURE_TYPE_NEW_B'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(9845890168608654)
,p_event_id=>wwv_flow_api.id(9845411288608649)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_TASK_NUMBER_B,P12_EXPENDITURE_TYPE_B'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(9846035242608656)
,p_event_id=>wwv_flow_api.id(9845411288608649)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_COST_CENTER_B,P12_FUTURE2_B'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(9845597617608651)
,p_event_id=>wwv_flow_api.id(9845411288608649)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_TASK_NUMBER_NEW_B,P12_EXPENDITURE_TYPE_NEW_B'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(9845748110608653)
,p_event_id=>wwv_flow_api.id(9845411288608649)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_TASK_NUMBER_B,P12_EXPENDITURE_TYPE_B'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(9846226001608657)
,p_event_id=>wwv_flow_api.id(9845411288608649)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_COST_CENTER_B,P12_FUTURE2_B'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(9846418131608659)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'approve- FInance_Case A-New Project'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P18_PROJECT_NEW_YN = ''Y'' and :IS_FBP_EMP  = ''Y''  THEN',
'--***************',
'IF  :P12_TASK_NUMBER_NEW_A      is null OR',
'    :P12_EXPENDITURE_TYPE_NEW_A is null OR',
'    :P12_COST_CENTER_A          is null OR',
'    :P12_FUTURE2_A              is null     ',
'                Then',
'                    apex_error.add_error (  p_message  => ''Please enter the required details ''  ,',
'                                          p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                        );',
'        else',
'',
'            update dp_items',
'            set TASK_NEW_YN = ''Y'', ',
'                TASK_NUMBER = Null,',
'                TASK_NUMBER_NEW = :P12_TASK_NUMBER_NEW_A, ',
'                EXPENDITURE_TYPE= Null, ',
'                EXPENDITURE_TYPE_NEW = :P12_EXPENDITURE_TYPE_NEW_A',
'            where ITEM_ID = :P12_REQUEST_ID;',
'',
'            update cashflow_lines',
'            set ',
'                TASK_NUMBER_NEW  = :P12_TASK_NUMBER_NEW_A, ',
'                EXPENDITURE_TYPE_NEW = :P12_EXPENDITURE_TYPE_NEW_A,',
'',
'                ENTITY_CODE             = null, ',
'                COST_CENTER             = null,',
'                BUDGET_GROUB_CODE       = null,',
'                GL_ACCOUNT              = null,',
'                ACTIVITY                = null,',
'                FUTURE1                 = null,',
'                FUTURE2                 = null,',
'',
'                ENTITY_CODE_NEW         = ''451'', ',
'                COST_CENTER_NEW         = :P12_COST_CENTER_A, ',
'                BUDGET_GROUB_CODE_NEW   = 1,',
'                GL_ACCOUNT_NEW          = SUBSTR(:P12_EXPENDITURE_TYPE_NEW_A,1,6), ',
'                ACTIVITY_NEW            = ''000000'', ',
'                FUTURE1_NEW             = ''451000'', ',
'                FUTURE2_NEW             = :P12_FUTURE2_A,',
'                ',
'                STATUS                  = ''Approved''',
'            where SOURCE = ''DP''',
'             and   REQUEST_ID = :P12_REQUEST_ID;',
'      end if;',
'--**************',
'    dp_items_workflow.APPROVE(:P12_REQUEST_ID , :PERSON_ID, :P12_COMMENT , ''S'');',
'End if;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(128678324882987428)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(9846253954608658)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'approve-Finance_Case B'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P18_PROJECT_NEW_YN = ''N'' and :IS_FBP_EMP  = ''Y''   --- IF AAA',
'Then',
'--************',
'if :P12_TASK_NEW_YN_B = ''Y'' --- IF BBBB',
'Then ',
'    --- IF CCCCC',
'    IF  :P12_TASK_NUMBER_NEW_B      is null   OR',
'    :P12_EXPENDITURE_TYPE_NEW_B     is null   OR',
'    :P12_COST_CENTER_B              is null   OR',
'    :P12_FUTURE2_B                  is null   ',
'                Then',
'                    apex_error.add_error (  p_message  => ''Please enter Task, Expenditure type, Cost Center and Future2 ''  ,',
'                                          p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                        );',
'    else',
'            update dp_items',
'            set TASK_NEW_YN = :P12_TASK_NEW_YN_B, ',
'                TASK_NUMBER = Null, ',
'                TASK_NUMBER_NEW = :P12_TASK_NUMBER_NEW_B, ',
'                EXPENDITURE_TYPE= Null, ',
'                EXPENDITURE_TYPE_NEW = :P12_EXPENDITURE_TYPE_NEW_B',
'            where ITEM_ID = :P12_REQUEST_ID;',
'',
'            update cashflow_lines',
'            set ',
'                TASK_NUMBER_NEW         = :P12_TASK_NUMBER_NEW_B,',
'                TASK_NUMBER             = null,',
'                EXPENDITURE_TYPE_NEW    = :P12_EXPENDITURE_TYPE_NEW_B,',
'                EXPENDITURE_TYPE        = null,',
'                ',
'                ENTITY_CODE             = null, ',
'                COST_CENTER             = null,',
'                BUDGET_GROUB_CODE       = null,',
'                GL_ACCOUNT              = null,',
'                ACTIVITY                = null,',
'                FUTURE1                 = null,',
'                FUTURE2                 = null,',
'',
'                ENTITY_CODE_NEW         = ''451'', ',
'                COST_CENTER_NEW         = :P12_COST_CENTER_B, ',
'                BUDGET_GROUB_CODE_NEW   = 1,',
'                GL_ACCOUNT_NEW          = substr(:P12_EXPENDITURE_TYPE_NEW_B,1,6), ',
'                ACTIVITY_NEW            = ''000000'', ',
'                FUTURE1_NEW             = ''451000'', ',
'                FUTURE2_NEW             = :P12_FUTURE2_B,',
'                ',
'                STATUS                  = ''Approved''',
'            where SOURCE = ''DP''',
'             and   REQUEST_ID = :P12_REQUEST_ID;',
'             ',
'             dp_items_workflow.APPROVE(:P12_REQUEST_ID , :PERSON_ID, :P12_COMMENT , ''S'');',
'       end if;   --- IF CCCCC',
'',
'elsif :P12_TASK_NEW_YN_B = ''N''',
'    Then',
'        --- IF DDDDD',
'    IF  :P12_TASK_NUMBER_B      is null      OR',
'        :P12_EXPENDITURE_TYPE_B is null ',
'                Then',
'                    apex_error.add_error (  p_message  => ''Please enter Task and Expenditure type ''  ,',
'                                          p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                        );',
'        else',
'                update dp_items',
'                set TASK_NEW_YN = :P12_TASK_NEW_YN_B, ',
'                    TASK_NUMBER = :P12_TASK_NUMBER_B, ',
'                    TASK_NUMBER_NEW = Null, ',
'                    EXPENDITURE_TYPE= :P12_EXPENDITURE_TYPE_B,',
'                    EXPENDITURE_TYPE_NEW = Null',
'                where ITEM_ID = :P12_REQUEST_ID;',
'    ',
'                    update cashflow_lines',
'                    set ',
'                        TASK_NUMBER_NEW         = null, ',
'                        EXPENDITURE_TYPE_NEW    = null,',
'                        TASK_NUMBER             = :P12_TASK_NUMBER_B, ',
'                        EXPENDITURE_TYPE        = :P12_EXPENDITURE_TYPE_B,',
'                    ',
'                        ENTITY_CODE_NEW         = null,',
'                        COST_CENTER_NEW         = null, ',
'                        BUDGET_GROUB_CODE_NEW   = null,',
'                        GL_ACCOUNT_NEW          = null, ',
'                        ACTIVITY_NEW            = null, ',
'                        FUTURE1_NEW             = null,',
'                        FUTURE2_NEW             = null,',
'                        ',
'                        ENTITY_CODE             = ''451'', ',
'                        COST_CENTER             = PROJECTS_UTIL.task_cost_center(:P18_PROJECT_NUMBER, :P12_TASK_NUMBER_B), ',
'                        BUDGET_GROUB_CODE       = PROJECTS_UTIL.task_budget_code(:P18_PROJECT_NUMBER, :P12_TASK_NUMBER_B),',
'                        GL_ACCOUNT              = PROJECTS_UTIL.expenditure_type_gl_account(:P18_PROJECT_NUMBER, :P12_TASK_NUMBER_B, :P12_EXPENDITURE_TYPE_B), ',
'                        ACTIVITY                = PROJECTS_UTIL.task_activity(:P18_PROJECT_NUMBER, :P12_TASK_NUMBER_B), ',
'                        FUTURE1                 = PROJECTS_UTIL.task_future1(:P18_PROJECT_NUMBER, :P12_TASK_NUMBER_B), ',
'                        FUTURE2                 = PROJECTS_UTIL.task_future2(:P18_PROJECT_NUMBER, :P12_TASK_NUMBER_B)',
'                    where SOURCE = ''DP''',
'                     and   REQUEST_ID = :P12_REQUEST_ID;',
'                     ',
'                     dp_items_workflow.APPROVE(:P12_REQUEST_ID , :PERSON_ID, :P12_COMMENT , ''S'');',
'               End IF;  --- IF DDDDD      ',
'',
'end if;',
'--**********',
'End if; --- IF AAA'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(128678324882987428)
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(9846514499608660)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'approve-Finance_Case C- Existing Project and Task'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P18_PROJECT_NEW_YN = ''N'' and :IS_FBP_EMP  = ''Y''  and :P18_TASK_NEW_YN = ''N'' --- IF AAA',
'Then',
'                     dp_items_workflow.APPROVE(:P12_REQUEST_ID , :PERSON_ID, :P12_COMMENT , ''S'');',
'                     ',
'           update cashflow_lines',
'            set STATUS                  = ''Approved''',
'            where SOURCE = ''DP''',
'             and   REQUEST_ID = :P12_REQUEST_ID;',
'End if;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(128678324882987428)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(128679294392987437)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approve Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'if :P12_ROLE_ID = 108 ',
'    Then',
'        IF  :P12_DP_PROCUREMENT_METHOD is null ',
'                Then',
'                    apex_error.add_error (  p_message  => ''Please select the procurement method ''  ,',
'                                          p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                        );',
'        elsif',
'            :P12_DP_PROCUREMENT_METHOD in (6,7) and :P12_CONTRACT_NO is null Then',
'                                    apex_error.add_error (  p_message  => ''Please enter the contract number ''  ,',
'                                                          p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                                        );',
'                                                        ',
'        else  ',
'              ',
'              if :P12_DP_PROCUREMENT_METHOD is not null Then',
'                      update dp_items',
'                    set DP_PROCUREMENT_METHOD = :P12_DP_PROCUREMENT_METHOD,',
'                        CONTRACT_NO = :P12_CONTRACT_NO',
'                    where item_id = :P12_REQUEST_ID;',
'                End if;',
'                ',
'            dp_items_workflow.APPROVE(:P12_REQUEST_ID , :PERSON_ID, :P12_COMMENT , ''S'');',
'        End IF;  ',
'    elsif :IS_FBP_EMP  != ''Y''',
'        Then',
'         dp_items_workflow.APPROVE(:P12_REQUEST_ID , :PERSON_ID, :P12_COMMENT , ''S'');',
'End if;',
'END;'))
,p_process_error_message=>'Not Approved, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(128678324882987428)
,p_process_success_message=>'Approved Successfully'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(128679396618987438)
,p_process_sequence=>60
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reject Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P12_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Reject this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            dp_items_workflow.REJECT(:P12_REQUEST_ID , :PERSON_ID, :P12_COMMENT , ''S'');',
' End If;           ',
'',
'END;'))
,p_process_error_message=>'Not Rejected, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(128678490329987429)
,p_process_success_message=>'Rejected.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(128679424106987439)
,p_process_sequence=>70
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delegated Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'dp_items_workflow.DELEGATE(:P12_REQUEST_ID ,',
'                         :PERSON_ID,',
'                         :P12_TO_PERSON_ID,',
'                         :P12_COMMENT , ',
'                         ''S'');',
'',
'',
'END;'))
,p_process_error_message=>'Not Delegated, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(128678588922987430)
,p_process_success_message=>'Delegated Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(128679565306987440)
,p_process_sequence=>80
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Return Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P12_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Return this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            dp_items_workflow.RETURN_review(:P12_REQUEST_ID , :PERSON_ID, :P12_COMMENT , ''S'');',
' End If;           ',
'',
'END;'))
,p_process_error_message=>'Not Returned, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(128678641679987431)
,p_process_success_message=>'Returned Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(128679646534987441)
,p_process_sequence=>90
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Cancel Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'    ',
'        IF :P12_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to cancel this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            update dp_items',
'            set CANCEL_ON = SYSTIMESTAMP ,',
'            CANCELLED_BY = :PERSON_ID,',
'            CANCEL_REASON = :P12_COMMENT,',
'            REVIEW_STATUS = ''Cancel''',
'            where item_ID = :P12_REQUEST_ID;',
'            ',
'            delete from dp_items_approval_history',
'            where request_id = :P12_REQUEST_ID',
'            and ACTION_DATE is null;',
'',
'         End if;',
'',
'',
'END;'))
,p_process_error_message=>'Not Cancelled, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(128678731685987432)
,p_process_success_message=>'Cancelled Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(128679777865987442)
,p_process_sequence=>100
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Withdraw Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'    ',
'        IF :P12_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Withdraw this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            dp_items_workflow.STOP(:P12_REQUEST_ID,:PERSON_ID,:P12_COMMENT, ''S'');',
'         End if;',
'',
'',
'END;'))
,p_process_error_message=>'Not Withdrawal, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(128678819953987433)
,p_process_success_message=>'Withdraw Successfully.'
);
wwv_flow_api.component_end;
end;
/
