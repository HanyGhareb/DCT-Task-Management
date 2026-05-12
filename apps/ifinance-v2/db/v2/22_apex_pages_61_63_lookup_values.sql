-- =============================================================================
-- Sprint 5 — APEX Pages 61 + 63
--   61: Lookup Values IR  (filtered by P61_CATEGORY_ID)
--   63: Lookup Value Detail (modal drawer — create / edit / delete)
-- IDs: 9733000xxx432070 / 9744000xxx432070
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
-- PAGE 61 — Lookup Values IR
-- =============================================================================
prompt --application/pages/delete_00061
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>61);
end;
/
prompt --application/pages/page_00061
begin
wwv_flow_imp_page.create_page(
 p_id=>61
,p_name=>'Lookup Values'
,p_alias=>'LOOKUP-VALUES'
,p_step_title=>'Lookup Values'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
-- ── Breadcrumb ────────────────────────────────────────────────────────────────
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9733000000432070)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(9281295074536978)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>2977773244219042594
);
-- ── IR Region ─────────────────────────────────────────────────────────────────
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9733000001432070)
,p_plug_name=>'Lookup Values'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT v.value_id,',
'       v.value_code,',
'       v.value_name_en,',
'       v.value_name_ar,',
'       v.tag,',
'       v.display_order,',
'       v.is_default,',
'       v.is_active',
'FROM   prod.dct_lookup_values v',
'WHERE  v.category_id = :P61_CATEGORY_ID',
'ORDER BY v.display_order, v.value_name_en'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Lookup Values'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(9733000002432070)
,p_name=>'Lookup Values'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_base_pk1=>'VALUE_ID'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'PROD'
,p_internal_uid=>9733000002432070
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9733000003432070)
,p_db_column_name=>'VALUE_ID'
,p_display_order=>0
,p_is_primary_key=>'Y'
,p_column_identifier=>'A'
,p_column_label=>'Value Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9733000004432070)
,p_db_column_name=>'VALUE_CODE'
,p_display_order=>1
,p_column_identifier=>'B'
,p_column_label=>'Code'
,p_column_link=>'f?p=&APP_ID.:63:&SESSION.::&DEBUG.::P63_VALUE_ID:#VALUE_ID#,P63_CATEGORY_ID:&P61_CATEGORY_ID.'
,p_column_linktext=>'#VALUE_CODE#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9733000005432070)
,p_db_column_name=>'VALUE_NAME_EN'
,p_display_order=>2
,p_column_identifier=>'C'
,p_column_label=>'Name (EN)'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9733000006432070)
,p_db_column_name=>'VALUE_NAME_AR'
,p_display_order=>3
,p_column_identifier=>'D'
,p_column_label=>'Name (AR)'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9733000007432070)
,p_db_column_name=>'TAG'
,p_display_order=>4
,p_column_identifier=>'E'
,p_column_label=>'Tag'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9733000008432070)
,p_db_column_name=>'DISPLAY_ORDER'
,p_display_order=>5
,p_column_identifier=>'F'
,p_column_label=>'Order'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9733000009432070)
,p_db_column_name=>'IS_DEFAULT'
,p_display_order=>6
,p_column_identifier=>'G'
,p_column_label=>'Default'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9733000010432070)
,p_db_column_name=>'IS_ACTIVE'
,p_display_order=>7
,p_column_identifier=>'H'
,p_column_label=>'Active'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(9733000011432070)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'97330000114'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'VALUE_ID:VALUE_CODE:VALUE_NAME_EN:VALUE_NAME_AR:TAG:DISPLAY_ORDER:IS_DEFAULT:IS_ACTIVE'
);
-- ── Toolbar button: Create ────────────────────────────────────────────────────
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9733000012432070)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(9733000001432070)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Create'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:63:&APP_SESSION.::NO::P63_CATEGORY_ID:&P61_CATEGORY_ID.'
,p_icon_css_classes=>'fa-plus'
);
-- ── Hidden item: P61_CATEGORY_ID ─────────────────────────────────────────────
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9733000013432070)
,p_name=>'P61_CATEGORY_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9733000001432070)
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'Y'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
end;
/

-- =============================================================================
-- PAGE 63 — Lookup Value Detail (modal drawer)
-- =============================================================================
prompt --application/pages/delete_00063
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>63);
end;
/
prompt --application/pages/page_00063
begin
wwv_flow_imp_page.create_page(
 p_id=>63
,p_name=>'Lookup Value'
,p_alias=>'LOOKUP-VALUE'
,p_step_title=>'Lookup Value'
,p_autocomplete_on_off=>'OFF'
,p_page_mode=>'MODAL'
,p_step_template=>1661186590416509825
,p_page_template_options=>'#DEFAULT#:js-dialog-class-t-Drawer--pullOutEnd'
,p_dialog_chained=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'02'
);
-- ── Buttons region ────────────────────────────────────────────────────────────
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9744000001432070)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_03'
);
-- ── Form region ───────────────────────────────────────────────────────────────
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9744000002432070)
,p_plug_name=>'Lookup Value'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT v.value_id,',
'       v.category_id,',
'       v.value_code,',
'       v.value_name_en,',
'       v.value_name_ar,',
'       v.tag,',
'       v.display_order,',
'       v.is_default,',
'       v.is_active',
'FROM   prod.dct_lookup_values v'))
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
-- ── Items ─────────────────────────────────────────────────────────────────────
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9744000003432070)
,p_name=>'P63_VALUE_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Value Id'
,p_source=>'VALUE_ID'
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
 p_id=>wwv_flow_imp.id(9744000004432070)
,p_name=>'P63_CATEGORY_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Category Id'
,p_source=>'CATEGORY_ID'
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
 p_id=>wwv_flow_imp.id(9744000005432070)
,p_name=>'P63_VALUE_CODE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Value Code'
,p_source=>'VALUE_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
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
 p_id=>wwv_flow_imp.id(9744000006432070)
,p_name=>'P63_VALUE_NAME_EN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Name (English)'
,p_source=>'VALUE_NAME_EN'
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
 p_id=>wwv_flow_imp.id(9744000007432070)
,p_name=>'P63_VALUE_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Name (Arabic)'
,p_source=>'VALUE_NAME_AR'
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
 p_id=>wwv_flow_imp.id(9744000008432070)
,p_name=>'P63_TAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Tag'
,p_source=>'TAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>100
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
 p_id=>wwv_flow_imp.id(9744000009432070)
,p_name=>'P63_DISPLAY_ORDER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Display Order'
,p_source=>'DISPLAY_ORDER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>10
,p_cMaxlength=>10
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
 p_id=>wwv_flow_imp.id(9744000010432070)
,p_name=>'P63_IS_DEFAULT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Default Value'
,p_source=>'IS_DEFAULT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Yes;Y,No;N'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_lov_null_value=>''
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9744000011432070)
,p_name=>'P63_IS_ACTIVE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9744000002432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Active'
,p_source=>'IS_ACTIVE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Yes;Y,No;N'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_lov_null_value=>''
,p_label_alignment=>'RIGHT'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
-- ── Buttons ───────────────────────────────────────────────────────────────────
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9744000012432070)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(9744000001432070)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9744000013432070)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(9744000001432070)
,p_button_name=>'DELETE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_execute_validations=>'N'
,p_button_condition=>'P63_VALUE_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9744000014432070)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(9744000001432070)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--gapLeft'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'NEXT'
,p_button_condition=>'P63_VALUE_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9744000015432070)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(9744000001432070)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--gapLeft'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Add Value'
,p_button_position=>'NEXT'
,p_button_condition=>'P63_VALUE_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
-- ── Dynamic Action: Cancel button closes dialog ───────────────────────────────
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(9744000016432070)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(9744000012432070)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9744000017432070)
,p_event_id=>wwv_flow_imp.id(9744000016432070)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
-- ── Form initialise (fetch row) ───────────────────────────────────────────────
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9744000018432070)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(9744000002432070)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Lookup Value'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
-- ── Form DML ─────────────────────────────────────────────────────────────────
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9744000019432070)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(9744000002432070)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process Row'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
-- ── Close dialog after DML ────────────────────────────────────────────────────
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9744000020432070)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
end;
/
-- ── end ───────────────────────────────────────────────────────────────────────
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/

prompt Pages 61 (Lookup Values IR) and 63 (Lookup Value Detail) created.

set define on verify on feedback on
