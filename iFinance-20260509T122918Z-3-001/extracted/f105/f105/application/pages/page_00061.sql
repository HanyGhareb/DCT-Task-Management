prompt --application/pages/page_00061
begin
--   Manifest
--     PAGE: 00061
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
 p_id=>61
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Allocation Plan Sector Assigment'
,p_alias=>'BUDGET-ALLOCATION-PLAN-SECTOR-ASSIGMENT'
,p_page_mode=>'MODAL'
,p_step_title=>'Budget Allocation Plan Sector Assigment'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240118132905'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70868685071453055)
,p_plug_name=>'Budget Allocation Plan Sector Assigment'
,p_region_template_options=>'#DEFAULT#:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99730028608410735)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'BUDGET_ALLOCATION_SECTORS_PLANS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70879838924360829)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(70868685071453055)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P61_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(66440561307965793)
,p_plug_name=>'Sector Cost Centers'
,p_parent_plug_id=>wwv_flow_api.id(70868685071453055)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(66440169018965789)
,p_plug_name=>'Sector Cost Centers Report'
,p_parent_plug_id=>wwv_flow_api.id(66440561307965793)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders:t-Form--large'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CC_CODE, CC_NAME_EN ',
'FROM dct_cost_centers',
'WHERE SECTOR_ORG_ID   = :P61_SECTOR_ID',
'AND STATUS =  ''A''',
'and sysdate between nvl(start_date , sysdate - 10)',
'            and nvl(end_date , sysdate + 10)',
'order by cc_code'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P61_SECTOR_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Sector Cost Centers Report'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(66440122535965788)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>146843909853218844
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66439947693965787)
,p_db_column_name=>'CC_CODE'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66439894969965786)
,p_db_column_name=>'CC_NAME_EN'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(66279645632872532)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1470044'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CC_CODE:CC_NAME_EN'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(61370307631166011)
,p_plug_name=>'H1'
,p_parent_plug_id=>wwv_flow_api.id(70868685071453055)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(61370158149166010)
,p_plug_name=>'H2'
,p_parent_plug_id=>wwv_flow_api.id(70868685071453055)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70858479358453060)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99731046805410735)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70858037626453061)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(70858479358453060)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70856459073453062)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(70858479358453060)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>'P61_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70856078259453062)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(70858479358453060)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P61_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70855655165453062)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(70858479358453060)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P61_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70878358691360814)
,p_name=>'P61_SCENARIO'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(70868685071453055)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_source=>'SCENARIO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70878297320360813)
,p_name=>'P61_SCENARIO_DESC'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(70868685071453055)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_source=>'SCENARIO_DESC'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70868416940453056)
,p_name=>'P61_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(70868685071453055)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Id'
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(99818469241410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70868031488453056)
,p_name=>'P61_BUDGET_ALLOCATION_PLAN_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(70868685071453055)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_source=>'BUDGET_ALLOCATION_PLAN_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70867571436453056)
,p_name=>'P61_SECTOR_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(61370307631166011)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_prompt=>'Sector'
,p_source=>'SECTOR_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct sector_name , sector_id',
'from(',
'select  CC_CODE ,user_details.org_name(SECTOR_ORG_ID) sector_name , SECTOR_ORG_ID sector_id ',
'from dct_cost_centers',
'where status = ''A''',
'and SECTOR_ORG_ID is not null',
'and sysdate between nvl(start_date , sysdate - 10) ',
'            and nvl(end_date , sysdate + 10))',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
,p_item_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(SECTOR_NAME_USER , SECTOR_NAME ) Sector ',
'       , sector_id',
'from dct_hr_sectors_v',
'',
'order by nvl(SECTOR_NAME_USER , SECTOR_NAME )'))
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70867160577453056)
,p_name=>'P61_APPROVED_BUDGET_CH1'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(61370307631166011)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_prompt=>'Approved Budget Ch1'
,p_post_element_text=>'&nbsp; AED'
,p_source=>'APPROVED_BUDGET_CH1'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_display_when=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P61_PLAN_ID_H,1) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70866767652453057)
,p_name=>'P61_APPROVED_BUDGET_CH2'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(61370307631166011)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_prompt=>'Approved Budget Ch2'
,p_post_element_text=>'&nbsp; AED'
,p_source=>'APPROVED_BUDGET_CH2'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_display_when=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P61_PLAN_ID_H,2) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70866349276453057)
,p_name=>'P61_APPROVED_BUDGET_CH3'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(61370307631166011)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_prompt=>'Approved Budget Ch3'
,p_post_element_text=>'&nbsp; AED'
,p_source=>'APPROVED_BUDGET_CH3'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_display_when=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P61_PLAN_ID_H,3) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70865975002453057)
,p_name=>'P61_APPROVED_BUDGET_CH6'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(61370307631166011)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_prompt=>'Approved Budget Ch6'
,p_post_element_text=>'&nbsp; AED'
,p_source=>'APPROVED_BUDGET_CH6'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_display_when=>'budget_allocation_pkg.CHECK_CHAPTER_EXIST(:P61_PLAN_ID_H,6) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70865582638453057)
,p_name=>'P61_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(61370158149166010)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_item_default=>'Draft'
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70865232318453057)
,p_name=>'P61_COMMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(61370307631166011)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_prompt=>'Comment'
,p_source=>'COMMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70864732602453058)
,p_name=>'P61_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(70879838924360829)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70864405110453058)
,p_name=>'P61_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(70879838924360829)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70863543547453058)
,p_name=>'P61_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(70879838924360829)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70863162137453058)
,p_name=>'P61_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(70879838924360829)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66440643257965794)
,p_name=>'P61_PLAN_ID_H'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(70868685071453055)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(61370672731166015)
,p_name=>'P61_ADDING_COST_CENTER_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(61370158149166010)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_item_default=>'N'
,p_prompt=>'Allow Adding Cost Center ?'
,p_source=>'ADDING_COST_CENTER_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(61370470192166013)
,p_name=>'P61_ADDING_PROJECT_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(61370158149166010)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_item_default=>'Y'
,p_prompt=>'Allow Adding Project ?'
,p_source=>'ADDING_PROJECT_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(61370351427166012)
,p_name=>'P61_ADDING_TASK_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(61370158149166010)
,p_item_source_plug_id=>wwv_flow_api.id(70868685071453055)
,p_item_default=>'Y'
,p_prompt=>'Allow Adding Task?'
,p_source=>'ADDING_TASK_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(70863843213453058)
,p_validation_name=>'P61_CREATED_ON must be timestamp'
,p_validation_sequence=>100
,p_validation=>'P61_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(70864405110453058)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(70862720512453059)
,p_validation_name=>'P61_UPDATED_ON must be timestamp'
,p_validation_sequence=>120
,p_validation=>'P61_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(70863162137453058)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(70879176734360822)
,p_validation_name=>'Chapter 1 Validation - create'
,p_validation_sequence=>130
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,1) + NVL(:P61_APPROVED_BUDGET_CH1,0) > budget_allocation_pkg.GET_APPROVED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,1)',
'Then',
'    return false;',
' else',
'    return true;',
'End if;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'You have Exceed the Chapter1 approved Budget.'
,p_when_button_pressed=>wwv_flow_api.id(70855655165453062)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(65412547179155410)
,p_validation_name=>'Chapter 1 Validation - Update'
,p_validation_sequence=>140
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_sec_amount    number;',
'begin',
'',
'select nvl(APPROVED_BUDGET_CH1,0)',
'into    l_sec_amount',
'from BUDGET_ALLOCATION_SECTORS_PLANS',
'where SECTOR_ID = :P61_SECTOR_ID',
'and BUDGET_ALLOCATION_PLAN_ID = :P61_BUDGET_ALLOCATION_PLAN_ID;',
'',
'IF budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,1) - l_sec_amount > budget_allocation_pkg.GET_APPROVED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,1)',
'Then',
'    return false;',
' else',
'    return true;',
'End if;',
'end;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'You have Exceed the Chapter1 approved Budget.'
,p_when_button_pressed=>wwv_flow_api.id(70856078259453062)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(70878952712360820)
,p_validation_name=>'Chapter 2 Validation - Create'
,p_validation_sequence=>150
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,2) + ',
'        NVL(:P61_APPROVED_BUDGET_CH2,0) > budget_allocation_pkg.GET_APPROVED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,2)',
'Then',
'    return false;',
' else',
'    return true;',
'End if;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'You have Exceed the Chapter2 approved Budget.'
,p_when_button_pressed=>wwv_flow_api.id(70855655165453062)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(65412452733155409)
,p_validation_name=>'Chapter 2 Validation - update'
,p_validation_sequence=>160
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_sec_amount    number;',
'begin',
'',
'select nvl(APPROVED_BUDGET_CH2,0)',
'into    l_sec_amount',
'from BUDGET_ALLOCATION_SECTORS_PLANS',
'where SECTOR_ID = :P61_SECTOR_ID',
'and BUDGET_ALLOCATION_PLAN_ID = :P61_BUDGET_ALLOCATION_PLAN_ID;',
'',
'IF budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,2) - l_sec_amount > budget_allocation_pkg.GET_APPROVED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,2)',
'Then',
'    return false;',
' else',
'    return true;',
'End if;',
'',
'End;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'You have Exceed the Chapter2 approved Budget.'
,p_when_button_pressed=>wwv_flow_api.id(70856078259453062)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(70878896468360819)
,p_validation_name=>'Chapter 3 Validation -  create'
,p_validation_sequence=>170
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,3) + ',
'        NVL(:P61_APPROVED_BUDGET_CH3,0) > budget_allocation_pkg.GET_APPROVED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,3)',
'Then',
'    return false;',
' else',
'    return true;',
'End if;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'You have Exceed the Chapter3 approved Budget.'
,p_when_button_pressed=>wwv_flow_api.id(70855655165453062)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(65412350278155408)
,p_validation_name=>'Chapter 3 Validation -  update'
,p_validation_sequence=>180
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_sec_amount    number;',
'begin',
'',
'select nvl(APPROVED_BUDGET_CH3,0)',
'into    l_sec_amount',
'from BUDGET_ALLOCATION_SECTORS_PLANS',
'where SECTOR_ID = :P61_SECTOR_ID',
'and BUDGET_ALLOCATION_PLAN_ID = :P61_BUDGET_ALLOCATION_PLAN_ID;',
'',
'IF budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,3) - l_sec_amount > budget_allocation_pkg.GET_APPROVED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,3)',
'Then',
'    return false;',
' else',
'    return true;',
'End if;',
'end;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'You have Exceed the Chapter3 approved Budget.'
,p_when_button_pressed=>wwv_flow_api.id(70856078259453062)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(70878772973360818)
,p_validation_name=>'Chapter 6 Validation- Create'
,p_validation_sequence=>190
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,6) + ',
'        NVL(:P61_APPROVED_BUDGET_CH6,0) > budget_allocation_pkg.GET_APPROVED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,6)',
'Then',
'    return false;',
' else',
'    return true;',
'End if;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'You have Exceed the Chapter6 approved Budget.'
,p_when_button_pressed=>wwv_flow_api.id(70855655165453062)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(65412276892155407)
,p_validation_name=>'Chapter 6 Validation- update'
,p_validation_sequence=>200
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_sec_amount    number;',
'begin',
'',
'select nvl(APPROVED_BUDGET_CH6,0)',
'into    l_sec_amount',
'from BUDGET_ALLOCATION_SECTORS_PLANS',
'where SECTOR_ID = :P61_SECTOR_ID',
'and BUDGET_ALLOCATION_PLAN_ID = :P61_BUDGET_ALLOCATION_PLAN_ID;',
'',
'IF budget_allocation_pkg.GET_ALLOCATED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,6) - l_sec_amount > budget_allocation_pkg.GET_APPROVED_BUDGET_BY_CH(:P61_BUDGET_ALLOCATION_PLAN_ID,6)',
'Then',
'    return false;',
' else',
'    return true;',
'End if;',
'end;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'You have Exceed the Chapter6 approved Budget.'
,p_when_button_pressed=>wwv_flow_api.id(70856078259453062)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70858023656453061)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(70858037626453061)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70857151038453061)
,p_event_id=>wwv_flow_api.id(70858023656453061)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66440448951965792)
,p_name=>'Sector Selected DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P61_SECTOR_ID'
,p_condition_element=>'P61_SECTOR_ID'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66440381024965791)
,p_event_id=>wwv_flow_api.id(66440448951965792)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(66440561307965793)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66439744633965785)
,p_event_id=>wwv_flow_api.id(66440448951965792)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(66440561307965793)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66440275088965790)
,p_event_id=>wwv_flow_api.id(66440448951965792)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(66440169018965789)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(70854892714453063)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(70868685071453055)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Budget Allocation Plan Sector Assigment'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(70854441459453063)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(70855300846453063)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(70868685071453055)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Budget Allocation Plan Sector Assigment'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
