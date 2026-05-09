prompt --application/pages/page_00016
begin
--   Manifest
--     PAGE: 00016
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>16
,p_user_interface_id=>wwv_flow_api.id(3440093928015830)
,p_name=>'Employee Details - Not in ADERP'
,p_alias=>'EMPLOYEE-DETAILS-NOT-IN-ADERP'
,p_step_title=>'Employee Details - Not in ADERP'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_step_template=>wwv_flow_api.id(3317567033015717)
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220530074404'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(60339822879403816)
,p_name=>'Photo'
,p_template=>wwv_flow_api.id(3328276690015727)
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Form--noPadding:t-Form--xlarge:t-Form--stretchInputs:margin-top-lg'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'REGION_POSITION_03'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CASE',
'        WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || :P16_USER_NAME',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END PHOTO',
'from dct_employees_list2',
'where person_id = :P16_PERSON_ID',
''))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(3381706881015764)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(55305606512358694)
,p_query_column_id=>1
,p_column_alias=>'PHOTO'
,p_column_display_sequence=>1
,p_column_heading=>'&P13_FULL_NAME_EN.'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="200" width="200"   style="border-radius:50%">'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(60475670420478362)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3364880770015750)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(3301434120015688)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(3418914725015794)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(60476351235478444)
,p_plug_name=>'Employee Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'DCT_EMPLOYEES_LIST2'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(60339533111403813)
,p_plug_name=>'Personal Details'
,p_parent_plug_id=>wwv_flow_api.id(60476351235478444)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-expanded:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(3338469521015735)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(60340010337403818)
,p_plug_name=>'Assignment Details '
,p_parent_plug_id=>wwv_flow_api.id(60476351235478444)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:t-Region--hideShowIconsMath:is-expanded:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(3338469521015735)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(60784061684168069)
,p_plug_name=>'Payroll Details'
,p_parent_plug_id=>wwv_flow_api.id(60476351235478444)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(3338469521015735)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(60784184279168070)
,p_plug_name=>'Contacts Details'
,p_parent_plug_id=>wwv_flow_api.id(60476351235478444)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-expanded:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(3338469521015735)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(60784301425168071)
,p_plug_name=>'Other Details'
,p_parent_plug_id=>wwv_flow_api.id(60476351235478444)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:t-Region--hideShowIconsMath:is-expanded:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(3338469521015735)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(60784444345168072)
,p_plug_name=>'Photo Details'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3328276690015727)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(61843214797543296)
,p_plug_name=>'Petty Cash'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(count(petty_cash_id) , 0) total , ''Total Requests'' label',
'from hrss_petty_cash',
'where employee_num = :P16_EMPLOYEE_NUM',
'group by ''Total Requests'''))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_ajax_items_to_submit=>'P16_EMPLOYEE_NUM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'LABEL'
,p_attribute_02=>'TOTAL'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(61843317810543297)
,p_plug_name=>'Open Petty Cash'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(count(petty_cash_id) , 0) total , ''Open Requests'' Open',
'from hrss_petty_cash',
'where employee_num = :P16_EMPLOYEE_NUM',
'and status = ''Open''',
'group by ''Open Requests'';'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_ajax_items_to_submit=>'P16_EMPLOYEE_NUM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'OPEN'
,p_attribute_02=>'TOTAL'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(55283661112358683)
,p_button_sequence=>750
,p_button_plug_id=>wwv_flow_api.id(60340010337403818)
,p_button_name=>'reset_department_user'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(3416848288015791)
,p_button_image_alt=>'Reset'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-undo'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(55282811789358683)
,p_button_sequence=>800
,p_button_plug_id=>wwv_flow_api.id(60340010337403818)
,p_button_name=>'reset_director'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(3416848288015791)
,p_button_image_alt=>'Reset'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-undo'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(55283217742358683)
,p_button_sequence=>830
,p_button_plug_id=>wwv_flow_api.id(60340010337403818)
,p_button_name=>'reset_Executive_director'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(3416848288015791)
,p_button_image_alt=>'Reset'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-undo'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(55270292979358676)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(60476351235478444)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>'P16_PERSON_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(55269464207358675)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(60476351235478444)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(55270660524358676)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(60476351235478444)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition=>'P16_PERSON_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(55269870789358676)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(60476351235478444)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition_type=>'NEVER'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(55330166252358725)
,p_branch_action=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55271094583358676)
,p_name=>'P16_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(60476351235478444)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55271440893358677)
,p_name=>'P16_USER_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>690
,p_item_plug_id=>wwv_flow_api.id(60476351235478444)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'USER_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55271844200358677)
,p_name=>'P16_BUSINESS_GROUP_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>700
,p_item_plug_id=>wwv_flow_api.id(60476351235478444)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'BUSINESS_GROUP_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55273369090358678)
,p_name=>'P16_EMPLOYEE_NUM'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Employee Num'
,p_source=>'EMPLOYEE_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(3416586982015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55273718953358678)
,p_name=>'P16_DEPT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_prompt=>'Department'
,p_source=>'P16_DEPARTMENT'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55274104750358678)
,p_name=>'P16_USER_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'User Name'
,p_source=>'USER_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55274568437358679)
,p_name=>'P16_PERSON_TYPE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'PERSON_TYPE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when_type=>'NEVER'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55274988932358679)
,p_name=>'P16_PERSON_TYPE_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_prompt=>'Person Type'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'from dct_employees_lookups',
'where lookup_name = ''Person Types''',
'and code = :P16_PERSON_TYPE_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55275369754358679)
,p_name=>'P16_ACCOUNT_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Account Status'
,p_source=>'ACCOUNT_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'STATUS LOV'
,p_lov=>'.'||wwv_flow_api.id(4580824401142588)||'.'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(3416586982015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55275754773358680)
,p_name=>'P16_FULL_NAME_EN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Full Name'
,p_source=>'FULL_NAME_EN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(3416586982015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55276196989358680)
,p_name=>'P16_TITLE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Title'
,p_source=>'TITLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_lov=>'select distinct title from dct_employees_list2'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416586982015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55276579005358680)
,p_name=>'P16_FULL_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Full Name (Arabic)'
,p_source=>'FULL_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55276987978358680)
,p_name=>'P16_NATIONAL_IDENTIFIER'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'National Identifier'
,p_source=>'NATIONAL_IDENTIFIER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416586982015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55277382225358680)
,p_name=>'P16_JOB_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'JOB_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55277728225358680)
,p_name=>'P16_JOB'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_prompt=>'Job'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'from dct_employees_lookups',
'where lookup_name = ''Jobs Code''',
'and code = :P16_JOB_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55278104316358681)
,p_name=>'P16_NATIONALITY_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Nationality'
,p_source=>'NATIONALITY_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'NATIONALITIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_e_user ,desc_e) nationality_name_en , code nationality_code  ',
'from dct_employees_lookups',
'where lookup_number = 1;'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(3416586982015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55278503846358681)
,p_name=>'P16_NATIONALITY'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_prompt=>'Nationality'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'from dct_employees_lookups',
'where lookup_name = ''Nationality Code''',
'and code = :P16_NATIONALITY_CODE'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55278986185358681)
,p_name=>'P16_POSITION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'POSITION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when_type=>'NEVER'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55279307098358681)
,p_name=>'P16_POSITION'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_prompt=>'Position'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'from dct_employees_lookups',
'where lookup_name = ''Positions Codes''',
'and code = :P16_POSITION_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55279737025358682)
,p_name=>'P16_BIRTH_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Birth Date'
,p_source=>'BIRTH_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55280118985358682)
,p_name=>'P16_GRADE'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_prompt=>'Grade'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'from dct_employees_lookups',
'where lookup_name = ''Grades Codes''',
'and code = :P16_GRADE_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55280583425358682)
,p_name=>'P16_GRADE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'GRADE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when_type=>'NEVER'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55280908210358682)
,p_name=>'P16_HIRE_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Hire Date'
,p_source=>'HIRE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55281397153358682)
,p_name=>'P16_CURRENT_FLAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Current Flag (Active?)'
,p_source=>'CURRENT_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55281790881358682)
,p_name=>'P16_LOCATION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Location'
,p_source=>'LOCATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'LOCATIONS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e) , code',
'from dct_employees_lookups',
' where lookup_name = ''Locations Codes'''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55282110330358683)
,p_name=>'P16_LOCATION'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(60339533111403813)
,p_prompt=>'Location'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'from dct_employees_lookups',
' where lookup_name = ''Locations Codes''',
' and code = :P16_LOCATION_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55284053939358684)
,p_name=>'P16_ASSIGNMENT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Assignment Number'
,p_source=>'ASSIGNMENT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55284402054358684)
,p_name=>'P16_MANAGER_FLAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_item_default=>'N'
,p_prompt=>'Manager ?'
,p_source=>'MANAGER_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'Copy of YES_LOV'
,p_lov=>'.'||wwv_flow_api.id(5295408541745737)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'2'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55284840633358684)
,p_name=>'P16_ORGANIZATION_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_prompt=>'Organization Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select org_name',
'from organizations_v',
'where org_id = :P16_ORGANIZATION_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55285212819358684)
,p_name=>'P16_ORGANIZATION_ID_USER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Organization (User)'
,p_source=>'ORGANIZATION_ID_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ALL ORGANIZATIONS WITH DETAILS LOV'
,p_lov=>'select org_name ,  org_level , parent_org_name parent_org ,parent_level, department_name , sector , org_id from organizations_details_v'
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_07=>'Select organization'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55285652111358685)
,p_name=>'P16_SUPERVISOR_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_prompt=>'Supervisor Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select s.full_name_en',
'from dct_employees_list2 s',
'where s.employee_num =  :P16_SUPERVISOR_NUM'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55286088599358685)
,p_name=>'P16_SUPERVISOR_NUM_USER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Supervisor Num (User)'
,p_source=>'SUPERVISOR_NUM_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ALL EMPLOYEES BY EMP NUM LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en ',
'    , employee_num',
'from dct_employees_list2'))
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_07=>'Select Employee'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55286427243358685)
,p_name=>'P16_SUPERVISOR_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Supervisor Num'
,p_source=>'SUPERVISOR_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55286884416358685)
,p_name=>'P16_ORGANIZATION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'ORGANIZATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when_type=>'NEVER'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55287256558358685)
,p_name=>'P16_ASSIGNMENT_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'ASSIGNMENT_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when_type=>'NEVER'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55287605838358685)
,p_name=>'P16_ASSIGNMENT_STATUS_TYPE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'ASSIGNMENT_STATUS_TYPE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when_type=>'NEVER'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55288098567358686)
,p_name=>'P16_ASSIGNMENT_STATUS_TYPE'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_prompt=>'Assignment Status Type'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'            from dct_employees_lookups',
'            where lookup_name = ''Assignment Status Types''',
'            and code = :P16_ASSIGNMENT_STATUS_TYPE_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55288441874358686)
,p_name=>'P16_ASSIGNMENT_TYPE_NAME'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_prompt=>'Assignment Type'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'  from dct_employees_lookups',
'  where lookup_name = ''Assignements Types Code''',
'   and code = :P16_ASSIGNMENT_TYPE'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55288804851358686)
,p_name=>'P16_TERMINATION_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Termination Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'TERMINATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55289221645358686)
,p_name=>'P16_ASSIGNMENT_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'ASSIGNMENT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when_type=>'NEVER'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55289620259358686)
,p_name=>'P16_ASSIGNMENT_CATEGORY_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'ASSIGNMENT_CATEGORY_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when_type=>'NEVER'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55290088741358687)
,p_name=>'P16_EMPLOYMENT_CATEGORY_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'EMPLOYMENT_CATEGORY_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when_type=>'NEVER'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55290498144358687)
,p_name=>'P16_SECTOR'
,p_item_sequence=>710
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55290825728358687)
,p_name=>'P16_SECTOR_USER'
,p_item_sequence=>720
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_prompt=>'Sector (User)'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(org_name_en_user , org_name_en) org_name',
'        , org_id',
'from dct_hr_organizations',
'where ORG_LEVEL_ID = 2',
'--and org_level_name = ''Sector'' ',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55291264939358687)
,p_name=>'P16_DEPARTMENT'
,p_item_sequence=>730
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_prompt=>'Department'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55291657689358687)
,p_name=>'P16_DEPARTMENT_USER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>740
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Department (User)'
,p_source=>'DEPARTMENT_ID_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(org_name_en_user , org_name_en) org_name',
'        , org_id',
'from dct_hr_organizations',
'where org_level_name = ''Department''',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'Y'
,p_attribute_06=>'0'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55292046419358687)
,p_name=>'P16_COST_CENTER'
,p_item_sequence=>770
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55292427703358688)
,p_name=>'P16_COST_CENTER_USER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>780
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Cost Center (User)'
,p_source=>'COST_CENTER_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'COST CENTERS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct COST_CENTER_CODE ',
'    || ''('' || ',
'    COST_CENTER_DESCRIPTION',
'    || '')''  cc_name',
'    ,  COST_CENTER_CODE ',
'from dct_gl_code_combinations_all',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55292834754358688)
,p_name=>'P16_DIRECTOR_PERSON_ID_USER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>790
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Director (User)'
,p_source=>'DIRECTOR_PERSON_ID_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DCT_EMPLOYEES_LIST2.FULL_NAME_EN as FULL_NAME_EN,',
'    DCT_EMPLOYEES_LIST2.PERSON_ID as PERSON_ID ',
' from DCT_EMPLOYEES_LIST2 DCT_EMPLOYEES_LIST2',
' where CURRENT_FLAG = ''Y''',
' --and PERSON_ID != :P16_PERSON_ID ',
' ; '))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55293216630358688)
,p_name=>'P16_EXECUTIVE_DIR_PERSON_ID_USER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>820
,p_item_plug_id=>wwv_flow_api.id(60340010337403818)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Executive Director (User)'
,p_source=>'EXECUTIVE_DIR_PERSON_ID_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DCT_EMPLOYEES_LIST2.FULL_NAME_EN || '' - '' || EMPLOYEE_NUM as FULL_NAME_EN,',
'    DCT_EMPLOYEES_LIST2.PERSON_ID as PERSON_ID ',
' from DCT_EMPLOYEES_LIST2 DCT_EMPLOYEES_LIST2',
' where CURRENT_FLAG = ''Y''',
' --and PERSON_ID != :P16_PERSON_ID ',
' ; '))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55293994462358688)
,p_name=>'P16_PAYROLL_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(60784061684168069)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'PAYROLL_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55294344363358689)
,p_name=>'P16_PAYROLL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(60784061684168069)
,p_prompt=>'Payroll'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'            from dct_employees_lookups',
'            where lookup_name = ''PayrollId''',
'            and code = :P16_PAYROLL_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55294752673358689)
,p_name=>'P16_PAY_BASIS_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(60784061684168069)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'PAY_BASIS_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55295142671358689)
,p_name=>'P16_PAY_BASIS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(60784061684168069)
,p_prompt=>'Pay Basis'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'            from dct_employees_lookups',
'            where lookup_name = ''PayBasisId''',
'            and code = :P16_PAY_BASIS_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55295824397358689)
,p_name=>'P16_EMAIL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(60784184279168070)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Email'
,p_source=>'EMAIL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55296207415358689)
,p_name=>'P16_EMAIL_USER'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(60784184279168070)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Email (User)'
,p_source=>'EMAIL_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>128
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416586982015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'EMAIL'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55296673218358690)
,p_name=>'P16_MOBILE_SMS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>440
,p_item_plug_id=>wwv_flow_api.id(60784184279168070)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Mobile SMS'
,p_source=>'MOBILE_SMS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55297034305358690)
,p_name=>'P16_MOBILE_USER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>450
,p_item_plug_id=>wwv_flow_api.id(60784184279168070)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Mobile (User)'
,p_source=>'MOBILE_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55297486791358690)
,p_name=>'P16_PHONE_NOS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>600
,p_item_plug_id=>wwv_flow_api.id(60784184279168070)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Phone Nos'
,p_source=>'PHONE_NOS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55298117161358690)
,p_name=>'P16_FIRST_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'First Name'
,p_source=>'FIRST_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55298533950358691)
,p_name=>'P16_FIRST_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'First Name Ar'
,p_source=>'FIRST_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55298943086358691)
,p_name=>'P16_SECOND_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Second Name'
,p_source=>'SECOND_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55299340304358691)
,p_name=>'P16_SECOND_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Second Name Ar'
,p_source=>'SECOND_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55299767298358691)
,p_name=>'P16_THIRD_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Third Name'
,p_source=>'THIRD_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55300153100358691)
,p_name=>'P16_LAST_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Last Name'
,p_source=>'LAST_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55300542052358691)
,p_name=>'P16_LAST_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Last Name Ar'
,p_source=>'LAST_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55300990478358692)
,p_name=>'P16_MARITAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Marital Status'
,p_source=>'MARITAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'MARITAL STATUS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e) , code',
'from dct_employees_lookups',
' where lookup_name = ''Marital Status Codes'';'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55301372169358692)
,p_name=>'P16_MARITAL_STATUS_NAME'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_prompt=>'Marital Status'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'            from dct_employees_lookups',
'            where lookup_name = ''Marital Status Codes''',
'            and code = :P16_MARITAL_STATUS'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55301751424358692)
,p_name=>'P16_SEX'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Gender'
,p_source=>'SEX'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:Male;M,Female;F'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(3416586982015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55302137029358692)
,p_name=>'P16_SEX_NAME'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_prompt=>'Gender'
,p_source=>'select decode (:P16_SEX , ''F'' , ''Female'' , ''Male'') from dual;'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55302571854358692)
,p_name=>'P16_RELIGION_CODE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'RELIGION_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55302918717358692)
,p_name=>'P16_ORIGINAL_HIRE_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Original Hire Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'ORIGINAL_HIRE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55303335747358693)
,p_name=>'P16_RELIGION'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Religion'
,p_source=>'RELIGION_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'RELIGION LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e) , code',
'from dct_employees_lookups',
' where lookup_name = ''Religion Codes'';'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55303764004358693)
,p_name=>'P16_PEOPLE_GROUP_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'PEOPLE_GROUP_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55304153038358693)
,p_name=>'P16_PEOPLE_GROUP'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_prompt=>'People Group'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'            from dct_employees_lookups',
'            where lookup_name = ''PeopleGroupId''',
'            and code = :P16_PEOPLE_GROUP_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55304584694358693)
,p_name=>'P16_PRIMARY_FLAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_item_default=>'Y'
,p_prompt=>'Primary Flag ?'
,p_source=>'PRIMARY_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'Copy of YES_LOV'
,p_lov=>'.'||wwv_flow_api.id(5295408541745737)||'.'
,p_begin_on_new_line=>'N'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'2'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55306351776358708)
,p_name=>'P16_PHOTO_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(60784444345168072)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'PHOTO_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55306719957358709)
,p_name=>'P16_PHOTO_MIMETYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(60784444345168072)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'PHOTO_MIMETYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55307186755358709)
,p_name=>'P16_PHOTO_CHARSET'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(60784444345168072)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'PHOTO_CHARSET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55307509627358709)
,p_name=>'P16_PHOTO_BLOB'
,p_source_data_type=>'BLOB'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(60784444345168072)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Brows'
,p_source=>'PHOTO_BLOB'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(3416377484015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'DB_COLUMN'
,p_attribute_02=>'PHOTO_MIMETYPE'
,p_attribute_03=>'PHOTO_NAME'
,p_attribute_04=>'PHOTO_CHARSET'
,p_attribute_05=>'PHOTO_LASTUPD'
,p_attribute_06=>'Y'
,p_attribute_08=>'inline'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55307944714358709)
,p_name=>'P16_PHOTO_LASTUPD'
,p_source_data_type=>'DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(60784444345168072)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_prompt=>'Updated ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'PHOTO_LASTUPD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416377484015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55368526845673131)
,p_name=>'P16_SOURCE_H'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(60784301425168071)
,p_item_source_plug_id=>wwv_flow_api.id(60476351235478444)
,p_source=>'SOURCE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(55329101001358724)
,p_name=>'reset department User DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(55283661112358683)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(55329691270358724)
,p_event_id=>wwv_flow_api.id(55329101001358724)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P16_DEPARTMENT_USER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(55327363777358723)
,p_name=>'reset_director DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(55282811789358683)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(55327842731358724)
,p_event_id=>wwv_flow_api.id(55327363777358723)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P16_DIRECTOR_PERSON_ID_USER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(55328252467358724)
,p_name=>'reset_Executive_director DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(55283217742358683)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(55328717583358724)
,p_event_id=>wwv_flow_api.id(55328252467358724)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P16_EXECUTIVE_DIR_PERSON_ID_USER'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(55049485241290816)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'set Person ID for outsource Emp'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DCT_EMPLOYEES_LIST2_SEQ.nextval',
'into :P16_PERSON_ID',
'from dual;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(55270660524358676)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(55272625811358678)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(60476351235478444)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Employee Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(55272227683358677)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(60476351235478444)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Employee Details'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(55326917863358723)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Get Sector Dept CC '
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select sector , department_name , cost_center_code',
'into    :P16_SECTOR , :P16_DEPARTMENT , :P16_COST_CENTER',
'from employees_v',
'where person_id = :P16_PERSON_ID;',
'exception',
'    when others',
'        then ',
'            null;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
