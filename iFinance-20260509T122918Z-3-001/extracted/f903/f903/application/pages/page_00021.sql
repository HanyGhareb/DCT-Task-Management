prompt --application/pages/page_00021
begin
--   Manifest
--     PAGE: 00021
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
 p_id=>21
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'Transfer Request - End User'
,p_step_title=>'Transfer Request - End User'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Scroll Results Only in Side Column */',
'.t-Body-side {',
'    display: flex;',
'    flex-direction: column;',
'    overflow: hidden;',
'}',
'.search-results {',
'    flex: 1;',
'    overflow: auto;',
'}',
'/* Format Search Region */',
'.search-region {',
'    border-bottom: 1px solid rgba(0,0,0,.1);',
'    flex-shrink: 0;',
'}',
'',
'.t-Region-header{',
'background-color:#0e6655;',
'    color:#FFFFFF;',
'}',
'.t-Region-title{',
'    color:#FFFFFF;',
'    font-weighfont-weight: bold;',
'}',
'',
'/* Set Header Panel */',
'.t-Header-branding {',
'    background-color: #0e6655;',
'}',
'',
'',
'/* Set Breadcrumb   */',
'.t-Body-title {',
'',
'    background-color: #EEE;',
'    color:#404040;',
'}',
'',
'/* Add Button - White */',
'.t-Region-header, .t-Region-header .t-Button--link, .t-Region-header .t-Button--noUI {',
'    color:  #FFF;',
'}',
'',
'/* New Plan Button */',
'.a-Button--hot, .t-Button--hot:not(.t-Button--simple), body .ui-button.ui-button--hot, body .ui-state-default.ui-priority-primary {',
'',
'    background-color: #0e6655;',
'    color:#fff;',
'}',
'',
'',
'/*  Table Row Selected */',
'.a-GV-table tr.is-selected .a-GV-cell {',
'    background-color: #CEF6CE;',
'}',
'',
'/* Audit Region */',
'#history    .t-Region-header {',
'     background-color: #f3f0ef;',
'    color:#000;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200404013822'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70537047104675039)
,p_plug_name=>'<b>Budget Transfer Requests - Details</b>'
,p_icon_css_classes=>'fa-lg fa-file-o'
,p_region_template_options=>'#DEFAULT#:t-HeroRegion--iconsCircle'
,p_plug_template=>wwv_flow_api.id(65537437145255750)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70717427871036304)
,p_plug_name=>'Create Form'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--leftLabels'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'BTF_END_USERS_REQ'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70767472297532706)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(70717427871036304)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--scrollBody:t-Form--leftLabels'
,p_plug_template=>wwv_flow_api.id(65530067520255748)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70736560255036287)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(70717427871036304)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>'P21_REQUEST_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70735357954036288)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(70717427871036304)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70736903089036286)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(70717427871036304)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition=>'P21_REQUEST_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70736144901036287)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(70717427871036304)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>'P21_REQUEST_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(70737232413036286)
,p_branch_action=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70537832076675047)
,p_name=>'P21_PREVIOUS_FROM'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(sum(transferred_amount),0) transfer_from',
'from btf_lines',
'where form_no in (select h.form_no',
'                    from btf_header h',
'                    where h.status not in (''Completed'' , ''Rejected'' , ''Cancelled''))',
'and btf_lines.from_to = ''FROM''',
'and btf_lines.project_number = :P21_PROJECT_NUMBER',
'and btf_lines.task_number = :P21_TASK_NUMBER',
'and btf_lines.cost_center = :P21_COST_CENTER',
'and btf_lines.gl_account  = :P21_GL_ACCOUNT;',
''))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Pending From Balance (Finance)'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(sum(transferred_amount),0) transfer_from',
'from btf_lines',
'where form_no in (select h.form_no',
'                    from btf_header h',
'                    where h.status not in (''Completed'' , ''Rejected'' , ''Cancelled''))',
'and btf_lines.from_to = ''FROM''',
'and btf_lines.project_number = :P21_PROJECT_NUMBER',
'and btf_lines.task_number = :P21_TASK_NUMBER',
'and btf_lines.cost_center = :P21_COST_CENTER',
'and btf_lines.gl_account  = :P21_GL_ACCOUNT;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70537905006675048)
,p_name=>'P21_PREVIOUS_TO'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(sum(transferred_amount),0) transfer_from',
'from btf_lines',
'where form_no in (select h.form_no',
'                    from btf_header h',
'                    where h.status not in (''Completed'' , ''Rejected'' , ''Cancelled''))',
'and btf_lines.from_to = ''TO''',
'and btf_lines.project_number = :P21_PROJECT_NUMBER',
'and btf_lines.task_number = :P21_TASK_NUMBER',
'and btf_lines.cost_center = :P21_COST_CENTER',
'and btf_lines.gl_account  = :P21_GL_ACCOUNT;',
''))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Previous To Amount'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(sum(transferred_amount),0) transfer_from',
'from btf_lines',
'where form_no in (select h.form_no',
'                    from btf_header h',
'                    where h.status not in (''Completed'' , ''Rejected'' , ''Cancelled''))',
'and btf_lines.from_to = ''TO''',
'and btf_lines.project_number = :P21_PROJECT_NUMBER',
'and btf_lines.task_number = :P21_TASK_NUMBER',
'and btf_lines.cost_center = :P21_COST_CENTER',
'and btf_lines.gl_account  = :P21_GL_ACCOUNT;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70717887361036304)
,p_name=>'P21_REQUEST_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'ID'
,p_source=>'REQUEST_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(65599536546255781)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70718228090036300)
,p_name=>'P21_REQUEST_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select extract(year from sysdate) || ''/'' ||LPAD(to_char(count(*)+1),5,0) from btf_end_users_req;',
''))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Request No'
,p_source=>'REQUEST_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>50
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70718642942036298)
,p_name=>'P21_REQUEST_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_default=>'Draft'
,p_prompt=>'Request Status'
,p_source=>'REQUEST_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70719085659036297)
,p_name=>'P21_JUSTIFICATION'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Justification'
,p_source=>'JUSTIFICATION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>2000
,p_cHeight=>3
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70719472687036297)
,p_name=>'P21_FROM_TO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_default=>'TO'
,p_prompt=>'From / To'
,p_source=>'FROM_TO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:To;TO,From;FROM'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70719848718036297)
,p_name=>'P21_TCA_SECTOR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Sector'
,p_source=>'TCA_SECTOR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70720204038036296)
,p_name=>'P21_DEPARTMENT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Department'
,p_source=>'DEPARTMENT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70720612122036296)
,p_name=>'P21_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Project Number'
,p_source=>'PROJECT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select entity_name d',
', entity_name  r',
'from btf_data_access',
'where entity_type = ''PROJECT''',
'and status = ''A''',
'and user_id = :APP_USER'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70721007773036296)
,p_name=>'P21_TASK_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Task'
,p_source=>'TASK_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT task_number d , ',
'        task_number r',
'FROM f_projectbudget ',
'where project_number = :P21_PROJECT_NUMBER'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P21_PROJECT_NUMBER'
,p_ajax_items_to_submit=>'P21_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70721498371036296)
,p_name=>'P21_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Cost Center'
,p_source=>'COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>7
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70721873979036296)
,p_name=>'P21_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'GL Account'
,p_source=>'GL_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  distinct natural_account d',
', natural_account r',
'from f_projectbudget',
'where project_number = :P21_PROJECT_NUMBER',
'and task_number = :P21_TASK_NUMBER',
'and cost_center = :P21_COST_CENTER;',
''))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P21_PROJECT_NUMBER,P21_TASK_NUMBER'
,p_ajax_items_to_submit=>'P21_COST_CENTER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70722221433036296)
,p_name=>'P21_BUDGET'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Budget'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BUDGET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70722629877036295)
,p_name=>'P21_ENCUMBRANCES'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Encumbrances'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ENCUMBRANCES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70723069578036295)
,p_name=>'P21_ACTUAL'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Actual'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ACTUAL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70723412330036295)
,p_name=>'P21_REQUESTED_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Amount Requested'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'REQUESTED_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_tag_css_classes=>'Success'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70723828501036295)
,p_name=>'P21_BALANCE_AFTER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Balance After'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BALANCE_AFTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--xlarge'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70724284988036295)
,p_name=>'P21_FUND_AVAILABLE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Fund Available'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'FUND_AVAILABLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70724611415036295)
,p_name=>'P21_FORM_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Form No'
,p_source=>'FORM_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P21_REQUEST_STATUS'
,p_display_when2=>'Draft:Refused'
,p_display_when_type=>'VALUE_OF_ITEM_IN_CONDITION_NOT_IN_COLON_DELIMITED_LIST'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70725022938036294)
,p_name=>'P21_LINE_NO'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Line No'
,p_source=>'LINE_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P21_REQUEST_STATUS'
,p_display_when2=>'Draft:Refused'
,p_display_when_type=>'VALUE_OF_ITEM_IN_CONDITION_NOT_IN_COLON_DELIMITED_LIST'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70725495251036294)
,p_name=>'P21_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(70767472297532706)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70725842169036294)
,p_name=>'P21_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(70767472297532706)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70726256495036294)
,p_name=>'P21_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(70767472297532706)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Creation Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70727003435036293)
,p_name=>'P21_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(70767472297532706)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_prompt=>'Updated Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70727842645036292)
,p_name=>'P21_YEAR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(70767472297532706)
,p_item_source_plug_id=>wwv_flow_api.id(70717427871036304)
,p_item_default=>'select extract(YEAR from sysdate) from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Year'
,p_source=>'YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(70768867336532720)
,p_computation_sequence=>10
,p_computation_item=>'P21_PREVIOUS_FROM'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Declare',
'l_project_number        btf_end_users_req.project_number%TYPE;',
'l_task_number           btf_end_users_req.task_number%TYPE;',
'l_cost_center           btf_end_users_req.cost_center%TYPE;',
'l_gl_account            btf_end_users_req.gl_account%TYPE;',
'',
'l_amount                varchar2(20);',
'',
'Begin',
'select project_number , task_number , cost_center  , gl_account',
'into   l_project_number,l_task_number,l_cost_center,l_gl_account',
'from btf_end_users_req',
'where request_id = :P21_REQUEST_ID;',
'',
'',
'select to_char(nvl(sum(transferred_amount),0),''999,999,999.99'') transfer_from',
'into l_amount',
'from btf_lines',
'where form_no in (select h.form_no',
'                    from btf_header h',
'                    where h.status not in (''Completed'' , ''Rejected'' , ''Cancelled''))',
'and btf_lines.from_to = ''FROM''',
'and btf_lines.project_number = l_project_number',
'and btf_lines.task_number = l_task_number',
'and btf_lines.cost_center = l_cost_center',
'and btf_lines.gl_account  = l_gl_account;',
'',
':P21_PREVIOUS_FROM := l_amount;',
'',
'End;'))
,p_compute_when=>'P21_REQUEST_ID'
,p_compute_when_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(70726764616036293)
,p_validation_name=>'P21_CREATION_DATE must be timestamp'
,p_validation_sequence=>210
,p_validation=>'P21_CREATION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(70726256495036294)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(70727541798036292)
,p_validation_name=>'P21_UPDATED_DATE must be timestamp'
,p_validation_sequence=>220
,p_validation=>'P21_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(70727003435036293)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70537141019675040)
,p_name=>'change Project no'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P21_PROJECT_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70537228682675041)
,p_event_id=>wwv_flow_api.id(70537141019675040)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P21_DEPARTMENT,P21_TCA_SECTOR'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'SELECT distinct department , tca_sector FROM f_projectbudget where project_number = :P21_PROJECT_NUMBER'
,p_attribute_07=>'P21_PROJECT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70537358830675042)
,p_name=>'Cost center set value'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P21_TASK_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70537448452675043)
,p_event_id=>wwv_flow_api.id(70537358830675042)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P21_COST_CENTER'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct cost_center ',
'from f_projectbudget',
'where project_number = :P21_PROJECT_NUMBER',
'and task_number = :P21_TASK_NUMBER;',
''))
,p_attribute_07=>'P21_PROJECT_NUMBER,P21_TASK_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70537517533675044)
,p_name=>'change GL Account'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P21_GL_ACCOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70537688469675045)
,p_event_id=>wwv_flow_api.id(70537517533675044)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P21_BUDGET,P21_ENCUMBRANCES,P21_ACTUAL,P21_FUND_AVAILABLE'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   to_char(budget,''999,999,999.99'')',
'        ,to_char(encumbrances,''999,999,999.99'')',
'        ,to_char(actual,''999,999,999.99'')',
'        ,to_char(fund_available,''999,999,999.99'')',
'from f_projectbudget',
'where project_number = :P21_PROJECT_NUMBER',
'and task_number = :P21_TASK_NUMBER',
'and cost_center = :P21_COST_CENTER',
'and natural_account = :P21_GL_ACCOUNT;',
''))
,p_attribute_07=>'P21_PROJECT_NUMBER,P21_TASK_NUMBER,P21_COST_CENTER,P21_GL_ACCOUNT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70538041630675049)
,p_event_id=>wwv_flow_api.id(70537517533675044)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P21_PREVIOUS_FROM'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(sum(transferred_amount),0) transfer_from',
'from btf_lines',
'where form_no in (select h.form_no',
'                    from btf_header h',
'                    where h.status not in (''Completed'' , ''Rejected'' , ''Cancelled''))',
'and btf_lines.from_to = ''FROM''',
'and btf_lines.project_number = :P21_PROJECT_NUMBER',
'and btf_lines.task_number = :P21_TASK_NUMBER',
'and btf_lines.cost_center = :P21_COST_CENTER',
'and btf_lines.gl_account  = :P21_GL_ACCOUNT;',
''))
,p_attribute_07=>'P21_PROJECT_NUMBER,P21_TASK_NUMBER,P21_COST_CENTER,P21_GL_ACCOUNT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70538162701675050)
,p_event_id=>wwv_flow_api.id(70537517533675044)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P21_PREVIOUS_TO'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(sum(transferred_amount),0) transfer_from',
'from btf_lines',
'where form_no in (select h.form_no',
'                    from btf_header h',
'                    where h.status not in (''Completed'' , ''Rejected'' , ''Cancelled''))',
'and btf_lines.from_to = ''TO''',
'and btf_lines.project_number = :P21_PROJECT_NUMBER',
'and btf_lines.task_number = :P21_TASK_NUMBER',
'and btf_lines.cost_center = :P21_COST_CENTER',
'and btf_lines.gl_account  = :P21_GL_ACCOUNT;',
''))
,p_attribute_07=>'P21_PROJECT_NUMBER,P21_TASK_NUMBER,P21_COST_CENTER,P21_GL_ACCOUNT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70767142803532703)
,p_name=>'set Balance After'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P21_REQUESTED_AMOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70767249518532704)
,p_event_id=>wwv_flow_api.id(70767142803532703)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P21_BALANCE_AFTER'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'case :P21_FROM_TO ',
'    when ''TO''',
'        then',
'            Nvl(to_number(:P21_FUND_AVAILABLE, ''999G999G999G999G990D00''),0)  + 1',
'    else',
'    ',
'    Nvl(to_number(:P21_FUND_AVAILABLE, ''999G999G999G999G990D00''),0) -1',
'End'))
,p_attribute_07=>'P21_FUND_AVAILABLE,P21_REQUESTED_AMOUNT,P21_PREVIOUS_TO,P21_PREVIOUS_FROM'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70767974906532711)
,p_name=>'project number Focus '
,p_event_sequence=>50
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70768009352532712)
,p_event_id=>wwv_flow_api.id(70767974906532711)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P21_PROJECT_NUMBER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70768136998532713)
,p_name=>'Task Number focus'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P21_PROJECT_NUMBER'
,p_condition_element=>'P21_PROJECT_NUMBER'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70768231814532714)
,p_event_id=>wwv_flow_api.id(70768136998532713)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P21_TASK_NUMBER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70768355250532715)
,p_name=>'GL Account Number Focus'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P21_TASK_NUMBER'
,p_condition_element=>'P21_TASK_NUMBER'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70768492437532716)
,p_event_id=>wwv_flow_api.id(70768355250532715)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P21_GL_ACCOUNT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70768554414532717)
,p_name=>'Calculate Balances'
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P21_GL_ACCOUNT'
,p_condition_element=>'P21_GL_ACCOUNT'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70768608267532718)
,p_event_id=>wwv_flow_api.id(70768554414532717)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P21_PREVIOUS_FROM'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(nvl(sum(transferred_amount),0),''999,999,999.99'') transfer_from',
'from btf_lines',
'where form_no in (select h.form_no',
'                    from btf_header h',
'                    where h.status not in (''Completed'' , ''Rejected'' , ''Cancelled''))',
'and btf_lines.from_to = ''FROM''',
'and btf_lines.project_number = :P21_PROJECT_NUMBER',
'and btf_lines.task_number = :P21_TASK_NUMBER',
'and btf_lines.cost_center = :P21_COST_CENTER',
'and btf_lines.gl_account  = :P21_GL_ACCOUNT;',
''))
,p_attribute_07=>'P21_PROJECT_NUMBER,P21_TASK_NUMBER,P21_COST_CENTER,P21_GL_ACCOUNT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(70738164256036285)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(70717427871036304)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Create Form'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(70737795339036285)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(70717427871036304)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Create Form'
);
wwv_flow_api.component_end;
end;
/
