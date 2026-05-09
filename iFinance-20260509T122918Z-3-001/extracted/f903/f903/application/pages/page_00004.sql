prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
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
 p_id=>4
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'Btf Line'
,p_step_title=>'Line Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Form-inputContainer input[type=text].showfocus, .t-Form-inputContainer select.showfocus,  .t-Form-inputContainer select.showfocus.selectlist ,.apex-item-text select.showfocus, .apex-item-select {',
'  background-color: #CEF6CE !important;',
'}',
'',
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
,p_last_upd_yyyymmddhh24miss=>'20200427112045'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(65697963574256010)
,p_plug_name=>'&P4_FORM_NO. - &P4_LINE_NO. Details'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65519636948255743)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'BTF_LINES'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(65715968971256018)
,p_plug_name=>'Buttons'
,p_parent_plug_id=>wwv_flow_api.id(65697963574256010)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65520625267255744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(65904290387327602)
,p_plug_name=>'Audit Info.'
,p_parent_plug_id=>wwv_flow_api.id(65697963574256010)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65530067520255748)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P4_LINE_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(75942126590438607)
,p_plug_name=>'breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65554277731255756)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(65494572154255667)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(65602363670255785)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(65716366334256019)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(65715968971256018)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:RP::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(65717997523256019)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(65715968971256018)
,p_button_name=>'DELETE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--simple'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P4_LINE_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(65718383853256019)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(65715968971256018)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P4_LINE_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(65718753009256020)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(65715968971256018)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P4_LINE_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(75942075051438606)
,p_branch_name=>'Go To 9'
,p_branch_action=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:RP::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65698361329256010)
,p_name=>'P4_LINE_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Line Id'
,p_source=>'LINE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(65599536546255781)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65698745687256011)
,p_name=>'P4_FORM_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_source=>'FORM_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65699121045256011)
,p_name=>'P4_LINE_NO'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(*)+ 1',
'from btf_lines',
'where from_to = ''FROM''',
'and form_no = :P4_FORM_NO'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Line No'
,p_source=>'LINE_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>5
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65699547648256011)
,p_name=>'P4_FROM_TO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'From / To'
,p_source=>'FROM_TO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:From (Deduct Budget);FROM,To (Additional Budget);TO'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65699967777256011)
,p_name=>'P4_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Project Number'
,p_source=>'PROJECT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.PROJECT_NUMBER as PROJECT_NUMBER ',
'       , F_PROJECTBUDGET.PROJECT_NUMBER as r',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where tca_sector = :P4_TCA_SECTOR',
' and department = :P4_DEPARTMENT',
'order by 1'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P4_TCA_SECTOR,P4_DEPARTMENT'
,p_ajax_items_to_submit=>'P4_TCA_SECTOR,P4_DEPARTMENT'
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
 p_id=>wwv_flow_api.id(65700389308256011)
,p_name=>'P4_PROJECT_NAME'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Project Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT project_name',
' from f_projectbudget',
' where project_number = :P4_PROJECT_NUMBER;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'I'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65700704026256012)
,p_name=>'P4_TASK_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Task Number'
,p_source=>'TASK_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' if :P4_FROM_TO = ''TO''',
'then',
'return ''SELECT task_number d , ',
'        task_number r',
'FROM f_projectbudget ',
'where project_number = :P4_PROJECT_NUMBER'' ;',
'else ',
'',
'return    ''SELECT task_number d , ',
'        task_number r',
'FROM f_projectbudget ',
'where project_number = :P4_PROJECT_NUMBER',
'and fund_available > 0'' ;',
'',
'end if'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P4_PROJECT_NUMBER,P4_FROM_TO'
,p_ajax_items_to_submit=>'P4_FROM_TO,P4_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_help_text=>'only tasks with Budget and fund available balances. check the data from "Projects Data" Page.'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65701124783256012)
,p_name=>'P4_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Cost Center'
,p_source=>'COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>7
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65701532491256012)
,p_name=>'P4_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'GL Account'
,p_source=>'GL_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' if :P4_FROM_TO = ''TO''',
'then',
'return ''select  distinct natural_account d',
', natural_account r',
'from f_projectbudget',
'where project_number = :P4_PROJECT_NUMBER',
'and task_number = :P4_TASK_NUMBER'' ;',
'else ',
'',
'return    ''select  distinct natural_account d',
', natural_account r',
'from f_projectbudget',
'where project_number = :P4_PROJECT_NUMBER',
'and task_number = :P4_TASK_NUMBER',
'and fund_available > 0'' ;',
'end if'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P4_TASK_NUMBER,P4_PROJECT_NUMBER,P4_FROM_TO'
,p_ajax_items_to_submit=>'P4_PROJECT_NUMBER,P4_TASK_NUMBER,P4_FROM_TO'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_help_text=>'only GL Accounts with budget and fund available will display.'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65701943555256012)
,p_name=>'P4_BUDGET'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Budget'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BUDGET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65702333094256012)
,p_name=>'P4_FUND_AVAILABLE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Fund Available'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'FUND_AVAILABLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65702756138256013)
,p_name=>'P4_TRANSFERRED_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Requested Amount'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'TRANSFERRED_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65703197692256013)
,p_name=>'P4_BALANCE_AFTER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Balance After'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BALANCE_AFTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65703533806256013)
,p_name=>'P4_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(65904290387327602)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
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
 p_id=>wwv_flow_api.id(65703982444256014)
,p_name=>'P4_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(65904290387327602)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
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
 p_id=>wwv_flow_api.id(65704307845256014)
,p_name=>'P4_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(65904290387327602)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Creation Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATION_DATE'
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
 p_id=>wwv_flow_api.id(65705167583256014)
,p_name=>'P4_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(65904290387327602)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
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
 p_id=>wwv_flow_api.id(65705943005256014)
,p_name=>'P4_TCA_SECTOR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'From Sector'
,p_source=>'TCA_SECTOR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.TCA_SECTOR as TCA_SECTOR ',
'        , F_PROJECTBUDGET.TCA_SECTOR as D ',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where TCA_sector in (SELECT  btf_data_access.entity_name d',
'                FROM   btf_data_access',
'                WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                    and btf_data_access.user_id = :APP_USER)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65706346922256014)
,p_name=>'P4_DEPARTMENT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Department'
,p_source=>'DEPARTMENT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct department d',
'    , department r',
'from f_projectbudget',
'where tca_sector = :P4_TCA_SECTOR',
'and department is not null',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P4_TCA_SECTOR'
,p_ajax_items_to_submit=>'P4_TCA_SECTOR'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65706758151256015)
,p_name=>'P4_STRATEGIC'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_source=>'STRATEGIC'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65707166263256015)
,p_name=>'P4_PROGRAM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_source=>'PROGRAM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65707512975256015)
,p_name=>'P4_OUTPUT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_source=>'OUTPUT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65707984839256015)
,p_name=>'P4_ACTUAL'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Actual'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ACTUAL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65708320094256015)
,p_name=>'P4_ENCUMBRANCES'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Encumbrances'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ENCUMBRANCES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75942229906438608)
,p_name=>'P4_SOURCE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(65904290387327602)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Source'
,p_source=>'SOURCE'
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
 p_id=>wwv_flow_api.id(75942368348438609)
,p_name=>'P4_JUSTIFICATION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Justification'
,p_source=>'JUSTIFICATION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>80
,p_cMaxlength=>1000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75942459430438610)
,p_name=>'P4_PURPOSE_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Purpose'
,p_source=>'PURPOSE_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P4_FROM_TO = ''TO''',
'then',
'return ''select value d',
'     , value_id r',
'from dct_lookup_values',
'where status = ''''A''''',
'and lookup_id = (select lookup_id',
'from dct_lookups',
'where lookup_code = ''''PTARPEU'''')'' ;',
'else ',
'',
'return    ''select value d',
'     , value_id r',
'from dct_lookup_values',
'where status = ''''A''''',
'and lookup_id = (select lookup_id',
'from dct_lookups',
'where lookup_code = ''''PTDRPEU'''')'' ;',
'',
'end if'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P4_FROM_TO'
,p_ajax_items_to_submit=>'P4_FROM_TO'
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
 p_id=>wwv_flow_api.id(75943085009438616)
,p_name=>'P4_COST_CENTER_NAME'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'Cost Center Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT cc_name',
'from f_projectbudget',
'where task_number = :P4_TASK_NUMBER',
'and project_number = :P4_PROJECT_NUMBER'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75943138349438617)
,p_name=>'P4_GL_ACCOUNT_NAME'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_prompt=>'GL Account Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT account_name',
'from f_projectbudget',
'where natural_account = :P4_GL_ACCOUNT'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.NATURAL_ACCOUNT as d',
'       , F_PROJECTBUDGET.NATURAL_ACCOUNT as r',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :P4_PROJECT_NUMBER ',
' and   task_number    = :P4_TASK_NUMBER',
' and   budget         > 0'))
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75945967656438645)
,p_name=>'P4_REQUEST_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_item_source_plug_id=>wwv_flow_api.id(65697963574256010)
,p_source=>'REQUEST_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75946023301438646)
,p_name=>'P4_END_USER_REQUEST'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(65904290387327602)
,p_prompt=>'End User Request#'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select request_no',
'from btf_end_users_req',
'where request_id = :P4_REQUEST_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76701072507160205)
,p_name=>'P4_FUND_AVAILABLE_H'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(65697963574256010)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(65704814510256014)
,p_validation_name=>'P4_CREATION_DATE must be timestamp'
,p_validation_sequence=>150
,p_validation=>'P4_CREATION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(65704307845256014)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(65705697625256014)
,p_validation_name=>'P4_UPDATED_DATE must be timestamp'
,p_validation_sequence=>160
,p_validation=>'P4_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(65705167583256014)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75942899828438614)
,p_name=>'From TO Focus '
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_FROM_TO'
,p_condition_element=>'P4_FROM_TO'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75942904091438615)
,p_event_id=>wwv_flow_api.id(75942899828438614)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_PURPOSE_EU'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75943879161438624)
,p_name=>'Task# Change'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_TASK_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75943977519438625)
,p_event_id=>wwv_flow_api.id(75943879161438624)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_COST_CENTER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66461254978879624)
,p_event_id=>wwv_flow_api.id(75943879161438624)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_COST_CENTER,P4_COST_CENTER_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.COST_CENTER as COST_CENTER',
'       , cc_name',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :P4_PROJECT_NUMBER',
' and task_number = :P4_TASK_NUMBER;'))
,p_attribute_07=>'P4_TASK_NUMBER,P4_PROJECT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75944875574438634)
,p_event_id=>wwv_flow_api.id(75943879161438624)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_COST_CENTER'
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
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(65904389403327603)
,p_name=>'Project# Change'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_PROJECT_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(65904498575327604)
,p_event_id=>wwv_flow_api.id(65904389403327603)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_PROJECT_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.PROJECT_NAME as PROJECT_NAME ',
'    ',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :P4_PROJECT_NUMBER'))
,p_attribute_07=>'P4_PROJECT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75942602170438612)
,p_name=>'Clear Amount'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_FROM_TO'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75942729294438613)
,p_event_id=>wwv_flow_api.id(75942602170438612)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_TRANSFERRED_AMOUNT,P4_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75944029849438626)
,p_name=>'Disable'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_TASK_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75944196854438627)
,p_event_id=>wwv_flow_api.id(75944029849438626)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_COST_CENTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75943634769438622)
,p_name=>'Focus to GL Accoun'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_TASK_NUMBER'
,p_condition_element=>'P4_TASK_NUMBER'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75943703908438623)
,p_event_id=>wwv_flow_api.id(75943634769438622)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_GL_ACCOUNT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75944256579438628)
,p_name=>'Disable After Refresh'
,p_event_sequence=>50
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(65697963574256010)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75944326341438629)
,p_event_id=>wwv_flow_api.id(75944256579438628)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_COST_CENTER,P4_BUDGET,P4_ENCUMBRANCES,P4_ACTUAL,P4_FUND_AVAILABLE,P4_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75944469762438630)
,p_name=>'Enable All'
,p_event_sequence=>60
,p_bind_type=>'bind'
,p_bind_event_type=>'apexbeforepagesubmit'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75944500685438631)
,p_event_id=>wwv_flow_api.id(75944469762438630)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_COST_CENTER,P4_BUDGET,P4_ENCUMBRANCES,P4_ACTUAL,P4_FUND_AVAILABLE,P4_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75945096948438636)
,p_name=>'GL Account Changes'
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_GL_ACCOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75945183231438637)
,p_event_id=>wwv_flow_api.id(75945096948438636)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_BUDGET,P4_ENCUMBRANCES,P4_ACTUAL,P4_FUND_AVAILABLE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75945262684438638)
,p_event_id=>wwv_flow_api.id(75945096948438636)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_GL_ACCOUNT_NAME,P4_BUDGET,P4_ENCUMBRANCES,P4_ACTUAL,P4_FUND_AVAILABLE,P4_FUND_AVAILABLE_H'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  ACCOUNT_NAME',
'        , to_char(budget,''99,999,999.99'') budget',
'        , to_char(encumbrances,''99,999,999.99'') encumbrances',
'        , to_char(actual,''99,999,999.99'') actual  ',
'        , to_char(fund_available,''99,999,999.99'') fund_available',
'        , fund_available    fund_available_hidden',
'from f_projectbudget',
'where project_number = :P4_PROJECT_NUMBER',
'and task_number = :P4_TASK_NUMBER',
'and natural_account = :P4_GL_ACCOUNT',
'',
'',
'/*',
'select  ACCOUNT_NAME',
'        , budget',
'        , encumbrances',
'        , actual  ',
'        , fund_available',
'from f_projectbudget',
'where project_number = :P4_PROJECT_NUMBER',
'and task_number = :P4_TASK_NUMBER',
'and natural_account = :P4_GL_ACCOUNT',
'',
'*/'))
,p_attribute_07=>'P4_PROJECT_NUMBER,P4_TASK_NUMBER,P4_GL_ACCOUNT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75945322095438639)
,p_event_id=>wwv_flow_api.id(75945096948438636)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_BUDGET,P4_ENCUMBRANCES,P4_ACTUAL,P4_FUND_AVAILABLE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75945479376438640)
,p_name=>'Transfer Amount Change'
,p_event_sequence=>90
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_TRANSFERRED_AMOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75945533253438641)
,p_event_id=>wwv_flow_api.id(75945479376438640)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75945663117438642)
,p_event_id=>wwv_flow_api.id(75945479376438640)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_BALANCE_AFTER'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>' (Number($v(''P4_TRANSFERRED_AMOUNT'')) + Number($v(''P4_FUND_AVAILABLE_H''))).toFixed(2);'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75945796603438643)
,p_event_id=>wwv_flow_api.id(75945479376438640)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75946134736438647)
,p_name=>'Delete BTF Line'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(65717997523256019)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75946345400438649)
,p_event_id=>wwv_flow_api.id(75946134736438647)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Would you like to delet Line &P4_LINE_NO. from Budget Transfer# &P4_FORM_NO.?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75946216697438648)
,p_event_id=>wwv_flow_api.id(75946134736438647)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DELETE',
'FROM btf_lines',
'where line_id = :P4_LINE_ID;',
'',
'if :P4_REQUEST_ID is not null',
'then',
'update btf_end_users_req',
'set form_no = '''' , request_status = ''Accepted''',
'where REQUEST_ID = :P4_REQUEST_ID;',
'end if;',
'',
'INSERT INTO btf_all_actions (',
'    request_type , request_id , action_type',
') VALUES (',
'    ''Transfer Request End User'' , :P4_REQUEST_ID , ''Returned''',
');',
''))
,p_attribute_02=>'P4_LINE_ID,P4_REQUEST_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75946492819438650)
,p_event_id=>wwv_flow_api.id(75946134736438647)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Line &P4_LINE_NO. has been deleted successfully from Budget Transfer# &P4_FORM_NO.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76014702840486301)
,p_event_id=>wwv_flow_api.id(75946134736438647)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76701193801160206)
,p_name=>'Disable When Page Load'
,p_event_sequence=>110
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76701221893160207)
,p_event_id=>wwv_flow_api.id(76701193801160206)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_BALANCE_AFTER'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(65719591416256020)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(65697963574256010)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Btf Line'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Budget Transfer Request &P4_FORM_NO. updated Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(65719139116256020)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(65697963574256010)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Btf Line'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
