-- =============================================================================
-- Sprint 4 — APEX Pages 50 + 51 + 53 + 54
--   50: Approval Templates IR
--   51: Template Detail (modal drawer)
--   53: Approval Steps IR (filtered to template)
--   54: Step Detail (modal drawer)
-- IDs: 9600000xxx432070 / 9611000xxx432070 / 9622000xxx432070 / 9633000xxx432070
-- =============================================================================
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback

begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.15'
,p_default_workspace_id=>9249752073687531
,p_default_application_id=>200
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
end;
/

-- =============================================================================
-- PAGE 50 — Approval Templates IR
-- =============================================================================
prompt --application/pages/delete_00050
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>50);
end;
/
prompt --application/pages/page_00050
begin
wwv_flow_imp_page.create_page(
 p_id=>50
,p_name=>'Approval Templates'
,p_alias=>'APPROVAL-TEMPLATES'
,p_step_title=>'Approval Templates'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9600000001432070)
,p_plug_name=>'Approval Templates'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT t.template_id,',
'       t.template_code,',
'       t.template_name,',
'       m.module_name_en AS module_name,',
'       t.is_sequential,',
'       t.is_active,',
'       t.created_at',
'FROM   prod.dct_approval_templates t',
'LEFT JOIN prod.dct_modules m ON m.module_id = t.module_id',
'ORDER BY t.template_name'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Approval Templates'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(9600000002432070)
,p_name=>'Approval Templates'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_base_pk1=>'TEMPLATE_ID'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'PROD'
,p_internal_uid=>9600000002432070
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9600000003432070)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>0
,p_is_primary_key=>'Y'
,p_column_identifier=>'A'
,p_column_label=>'Template Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9600000004432070)
,p_db_column_name=>'TEMPLATE_CODE'
,p_display_order=>1
,p_column_identifier=>'B'
,p_column_label=>'Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9600000005432070)
,p_db_column_name=>'TEMPLATE_NAME'
,p_display_order=>2
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_link=>'f?p=&APP_ID.:51:&SESSION.::&DEBUG.::P51_TEMPLATE_ID:#TEMPLATE_ID#'
,p_column_linktext=>'#TEMPLATE_NAME#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9600000006432070)
,p_db_column_name=>'MODULE_NAME'
,p_display_order=>3
,p_column_identifier=>'D'
,p_column_label=>'Module'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9600000007432070)
,p_db_column_name=>'IS_SEQUENTIAL'
,p_display_order=>4
,p_column_identifier=>'E'
,p_column_label=>'Sequential'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9600000008432070)
,p_db_column_name=>'IS_ACTIVE'
,p_display_order=>5
,p_column_identifier=>'F'
,p_column_label=>'Active'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9600000009432070)
,p_db_column_name=>'CREATED_AT'
,p_display_order=>6
,p_column_identifier=>'G'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(9600000010432070)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'96000'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'TEMPLATE_ID:TEMPLATE_CODE:TEMPLATE_NAME:MODULE_NAME:IS_SEQUENTIAL:IS_ACTIVE:CREATED_AT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9600000011432070)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(9281295074536978)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9600000012432070)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(9600000001432070)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:51:&APP_SESSION.::&DEBUG.:51::'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(9600000013432070)
,p_name=>'Refresh After Close'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(9600000001432070)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9600000014432070)
,p_event_id=>wwv_flow_imp.id(9600000013432070)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(9600000001432070)
);
end;
/

-- =============================================================================
-- PAGE 51 — Template Detail (modal drawer)
-- =============================================================================
prompt --application/pages/delete_00051
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>51);
end;
/
prompt --application/pages/page_00051
begin
wwv_flow_imp_page.create_page(
 p_id=>51
,p_name=>'Template Detail'
,p_alias=>'TEMPLATE-DETAIL'
,p_page_mode=>'MODAL'
,p_step_title=>'Template Detail'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>1661186590416509825
,p_page_template_options=>'#DEFAULT#:js-dialog-class-t-Drawer--pullOutEnd'
,p_dialog_chained=>'N'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9611000001432070)
,p_plug_name=>'Template Detail'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT t.template_id,',
'       t.template_code,',
'       t.template_name,',
'       t.template_name_ar,',
'       t.module_id,',
'       t.description_en,',
'       t.description_ar,',
'       t.is_sequential,',
'       t.auto_approve_days,',
'       t.is_active',
'FROM   prod.dct_approval_templates t'))
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9611000002432070)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'TEXT',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9611000003432070)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(9611000002432070)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_alignment=>'RIGHT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9611000004432070)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(9611000002432070)
,p_button_name=>'DELETE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_alignment=>'RIGHT'
,p_button_execute_validations=>'N'
,p_confirm_message=>'&APP_TEXT$DELETE_MSG!RAW.'
,p_confirm_style=>'danger'
,p_button_condition=>'P51_TEMPLATE_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9611000005432070)
,p_button_sequence=>25
,p_button_plug_id=>wwv_flow_imp.id(9611000002432070)
,p_button_name=>'MANAGE_STEPS'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Manage Steps'
,p_button_position=>'PREVIOUS'
,p_button_alignment=>'LEFT'
,p_button_redirect_url=>'f?p=&APP_ID.:53:&APP_SESSION.::NO::P53_TEMPLATE_ID:&P51_TEMPLATE_ID.'
,p_button_condition=>'P51_TEMPLATE_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9611000006432070)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(9611000002432070)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P51_TEMPLATE_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9611000007432070)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(9611000002432070)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P51_TEMPLATE_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9611000008432070)
,p_name=>'P51_TEMPLATE_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Template Id'
,p_source=>'TEMPLATE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9611000009432070)
,p_name=>'P51_TEMPLATE_CODE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Template Code'
,p_source=>'TEMPLATE_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_label_alignment=>'RIGHT'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9611000010432070)
,p_name=>'P51_TEMPLATE_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Name (EN)'
,p_source=>'TEMPLATE_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>200
,p_label_alignment=>'RIGHT'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9611000011432070)
,p_name=>'P51_TEMPLATE_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Name (AR)'
,p_source=>'TEMPLATE_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>200
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9611000012432070)
,p_name=>'P51_MODULE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Module'
,p_source=>'MODULE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'SELECT module_name_en AS d, module_id AS r FROM prod.dct_modules WHERE is_active=''Y'' ORDER BY module_name_en'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-Select Module-'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9611000013432070)
,p_name=>'P51_IS_SEQUENTIAL'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_use_cache_before_default=>'NO'
,p_item_default=>'Y'
,p_prompt=>'Sequential Approval'
,p_source=>'IS_SEQUENTIAL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Yes;Y,No (Parallel);N'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9611000014432070)
,p_name=>'P51_AUTO_APPROVE_DAYS'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_use_cache_before_default=>'NO'
,p_item_default=>'0'
,p_prompt=>'Auto-Approve After (days, 0=off)'
,p_source=>'AUTO_APPROVE_DAYS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'auto',
  'virtual_keyboard', 'auto')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9611000015432070)
,p_name=>'P51_DESCRIPTION_EN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Description (EN)'
,p_source=>'DESCRIPTION_EN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>1000
,p_cHeight=>3
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9611000016432070)
,p_name=>'P51_IS_ACTIVE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9611000001432070)
,p_use_cache_before_default=>'NO'
,p_item_default=>'Y'
,p_prompt=>'Active'
,p_source=>'IS_ACTIVE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(9611000017432070)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(9611000003432070)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9611000018432070)
,p_event_id=>wwv_flow_imp.id(9611000017432070)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9611000019432070)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(9611000001432070)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Template Detail'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>9611000019432070
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9611000020432070)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>9611000020432070
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9611000021432070)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(9611000001432070)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Template Detail'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>9611000021432070
);
end;
/

-- =============================================================================
-- PAGE 53 — Approval Steps IR (filtered to a template)
-- =============================================================================
prompt --application/pages/delete_00053
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>53);
end;
/
prompt --application/pages/page_00053
begin
wwv_flow_imp_page.create_page(
 p_id=>53
,p_name=>'Approval Steps'
,p_alias=>'APPROVAL-STEPS'
,p_step_title=>'Approval Steps'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9622000001432070)
,p_plug_name=>'Approval Steps'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT s.step_id,',
'       s.step_seq,',
'       s.step_name,',
'       s.step_type,',
'       r.role_name AS required_role_name,',
'       u.display_name AS specific_user_name,',
'       s.escalation_days,',
'       s.is_mandatory,',
'       s.allow_skip',
'FROM   prod.dct_approval_steps s',
'LEFT JOIN prod.dct_roles r ON r.role_id = s.required_role_id',
'LEFT JOIN prod.dct_users u ON u.user_id = s.specific_user_id',
'WHERE  s.template_id = :P53_TEMPLATE_ID',
'ORDER BY s.step_seq'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Approval Steps'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(9622000002432070)
,p_name=>'Approval Steps'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_base_pk1=>'STEP_ID'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'PROD'
,p_internal_uid=>9622000002432070
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9622000003432070)
,p_db_column_name=>'STEP_ID'
,p_display_order=>0
,p_is_primary_key=>'Y'
,p_column_identifier=>'A'
,p_column_label=>'Step Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9622000004432070)
,p_db_column_name=>'STEP_SEQ'
,p_display_order=>1
,p_column_identifier=>'B'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9622000005432070)
,p_db_column_name=>'STEP_NAME'
,p_display_order=>2
,p_column_identifier=>'C'
,p_column_label=>'Step Name'
,p_column_link=>'f?p=&APP_ID.:54:&SESSION.::&DEBUG.::P54_STEP_ID:#STEP_ID#,P54_TEMPLATE_ID:#P53_TEMPLATE_ID#'
,p_column_linktext=>'#STEP_NAME#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9622000006432070)
,p_db_column_name=>'STEP_TYPE'
,p_display_order=>3
,p_column_identifier=>'D'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9622000007432070)
,p_db_column_name=>'REQUIRED_ROLE_NAME'
,p_display_order=>4
,p_column_identifier=>'E'
,p_column_label=>'Role'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9622000008432070)
,p_db_column_name=>'SPECIFIC_USER_NAME'
,p_display_order=>5
,p_column_identifier=>'F'
,p_column_label=>'User'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9622000009432070)
,p_db_column_name=>'ESCALATION_DAYS'
,p_display_order=>6
,p_column_identifier=>'G'
,p_column_label=>'Escalate (days)'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9622000010432070)
,p_db_column_name=>'IS_MANDATORY'
,p_display_order=>7
,p_column_identifier=>'H'
,p_column_label=>'Mandatory'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(9622000011432070)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'96220'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_ID:STEP_SEQ:STEP_NAME:STEP_TYPE:REQUIRED_ROLE_NAME:SPECIFIC_USER_NAME:ESCALATION_DAYS:IS_MANDATORY'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9622000012432070)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(9281295074536978)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9622000013432070)
,p_name=>'P53_TEMPLATE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9622000001432070)
,p_use_cache_before_default=>'NO'
,p_source=>'P53_TEMPLATE_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9622000014432070)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(9622000001432070)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Step'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:54:&APP_SESSION.::&DEBUG.:54:P54_TEMPLATE_ID:&P53_TEMPLATE_ID.'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9622000015432070)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(9622000001432070)
,p_button_name=>'BACK_TO_TEMPLATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Back to Template'
,p_button_position=>'LEFT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:51:&APP_SESSION.::NO::P51_TEMPLATE_ID:&P53_TEMPLATE_ID.'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(9622000016432070)
,p_name=>'Refresh After Close'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(9622000001432070)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9622000017432070)
,p_event_id=>wwv_flow_imp.id(9622000016432070)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(9622000001432070)
);
end;
/

-- =============================================================================
-- PAGE 54 — Step Detail (modal drawer)
-- =============================================================================
prompt --application/pages/delete_00054
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>54);
end;
/
prompt --application/pages/page_00054
begin
wwv_flow_imp_page.create_page(
 p_id=>54
,p_name=>'Step Detail'
,p_alias=>'STEP-DETAIL'
,p_page_mode=>'MODAL'
,p_step_title=>'Step Detail'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>1661186590416509825
,p_page_template_options=>'#DEFAULT#:js-dialog-class-t-Drawer--pullOutEnd'
,p_dialog_chained=>'N'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9633000001432070)
,p_plug_name=>'Step Detail'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT s.step_id,',
'       s.template_id,',
'       s.step_seq,',
'       s.step_name,',
'       s.step_name_ar,',
'       s.step_type,',
'       s.required_role_id,',
'       s.specific_user_id,',
'       s.escalation_days,',
'       s.escalate_role_id,',
'       s.is_mandatory,',
'       s.allow_skip',
'FROM   prod.dct_approval_steps s'))
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9633000002432070)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'TEXT',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9633000003432070)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(9633000002432070)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_alignment=>'RIGHT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9633000004432070)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(9633000002432070)
,p_button_name=>'DELETE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_alignment=>'RIGHT'
,p_button_execute_validations=>'N'
,p_confirm_message=>'&APP_TEXT$DELETE_MSG!RAW.'
,p_confirm_style=>'danger'
,p_button_condition=>'P54_STEP_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9633000005432070)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(9633000002432070)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P54_STEP_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9633000006432070)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(9633000002432070)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P54_STEP_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9633000007432070)
,p_name=>'P54_STEP_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Step Id'
,p_source=>'STEP_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9633000008432070)
,p_name=>'P54_TEMPLATE_ID'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Template Id'
,p_source=>'TEMPLATE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9633000009432070)
,p_name=>'P54_STEP_SEQ'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Sequence'
,p_source=>'STEP_SEQ'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_label_alignment=>'RIGHT'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'auto',
  'virtual_keyboard', 'auto')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9633000010432070)
,p_name=>'P54_STEP_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Step Name (EN)'
,p_source=>'STEP_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>200
,p_label_alignment=>'RIGHT'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9633000011432070)
,p_name=>'P54_STEP_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Step Name (AR)'
,p_source=>'STEP_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>200
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9633000012432070)
,p_name=>'P54_STEP_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_use_cache_before_default=>'NO'
,p_item_default=>'ROLE_BASED'
,p_prompt=>'Step Type'
,p_source=>'STEP_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Role Based;ROLE_BASED,User Specific;USER_SPECIFIC,Org Head;ORG_HEAD'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9633000013432070)
,p_name=>'P54_REQUIRED_ROLE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Required Role'
,p_source=>'REQUIRED_ROLE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'SELECT role_name AS d, role_id AS r FROM prod.dct_roles WHERE is_active=''Y'' ORDER BY role_name'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-None-'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9633000014432070)
,p_name=>'P54_SPECIFIC_USER_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Specific User'
,p_source=>'SPECIFIC_USER_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'SELECT display_name AS d, user_id AS r FROM prod.dct_users WHERE is_active=''Y'' ORDER BY display_name'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-None-'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9633000015432070)
,p_name=>'P54_ESCALATION_DAYS'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_use_cache_before_default=>'NO'
,p_item_default=>'3'
,p_prompt=>'Escalate After (days)'
,p_source=>'ESCALATION_DAYS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'auto',
  'virtual_keyboard', 'auto')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9633000016432070)
,p_name=>'P54_ESCALATE_ROLE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Escalate To Role'
,p_source=>'ESCALATE_ROLE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'SELECT role_name AS d, role_id AS r FROM prod.dct_roles WHERE is_active=''Y'' ORDER BY role_name'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-None-'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9633000017432070)
,p_name=>'P54_IS_MANDATORY'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_use_cache_before_default=>'NO'
,p_item_default=>'Y'
,p_prompt=>'Mandatory'
,p_source=>'IS_MANDATORY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9633000018432070)
,p_name=>'P54_ALLOW_SKIP'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9633000001432070)
,p_use_cache_before_default=>'NO'
,p_item_default=>'N'
,p_prompt=>'Allow Skip'
,p_source=>'ALLOW_SKIP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(9633000019432070)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(9633000003432070)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9633000020432070)
,p_event_id=>wwv_flow_imp.id(9633000019432070)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9633000021432070)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(9633000001432070)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Step Detail'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>9633000021432070
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9633000022432070)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>9633000022432070
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9633000023432070)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(9633000001432070)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Step Detail'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>9633000023432070
);
end;
/

prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set define on verify on feedback on
prompt  ...done
