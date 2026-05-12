prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
--------------------------------------------------------------------------------
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

prompt APPLICATION 200 - i-Finance
--
-- Application Export:
--   Application:     200
--   Name:            i-Finance
--   Exported By:     ADMIN
--   Export Type:     Component Export
--   Manifest
--     PAGE: 40
--     PAGE: 41
--     PAGE: 42
--   Manifest End
--   Version:         24.2.15
--   Instance ID:     9249559497612069
--

begin
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/

-- =============================================================================
-- PAGE 40 — Modules IR
-- IDs: 9560000xxx432070
-- =============================================================================
prompt --application/pages/delete_00040
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>40);
end;
/
prompt --application/pages/page_00040
begin
wwv_flow_imp_page.create_page(
 p_id=>40
,p_name=>'Modules'
,p_alias=>'MODULES'
,p_step_title=>'Modules'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9560000001432070)
,p_plug_name=>'Modules'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT m.module_id,',
'       m.module_code,',
'       m.module_name_en,',
'       m.module_name_ar,',
'       m.module_type,',
'       m.category,',
'       m.apex_app_id,',
'       m.icon_class,',
'       m.is_active,',
'       m.is_admin_only,',
'       m.is_new_tab,',
'       m.display_order,',
'       m.created_at',
'FROM   prod.dct_modules m',
'ORDER BY m.display_order, m.module_name_en'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Modules'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(9560000002432070)
,p_name=>'Modules'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_base_pk1=>'MODULE_ID'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'PROD'
,p_internal_uid=>9560000002432070
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9560000003432070)
,p_db_column_name=>'MODULE_ID'
,p_display_order=>0
,p_is_primary_key=>'Y'
,p_column_identifier=>'A'
,p_column_label=>'Module Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9560000004432070)
,p_db_column_name=>'MODULE_CODE'
,p_display_order=>1
,p_column_identifier=>'B'
,p_column_label=>'Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9560000005432070)
,p_db_column_name=>'MODULE_NAME_EN'
,p_display_order=>2
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_type=>'STRING'
,p_column_link=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.::P41_MODULE_ID:#MODULE_ID#'
,p_column_linktext=>'#MODULE_NAME_EN#'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9560000006432070)
,p_db_column_name=>'MODULE_NAME_AR'
,p_display_order=>3
,p_column_identifier=>'D'
,p_column_label=>'Name (AR)'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9560000007432070)
,p_db_column_name=>'MODULE_TYPE'
,p_display_order=>4
,p_column_identifier=>'E'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9560000008432070)
,p_db_column_name=>'CATEGORY'
,p_display_order=>5
,p_column_identifier=>'F'
,p_column_label=>'Category'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9560000009432070)
,p_db_column_name=>'APEX_APP_ID'
,p_display_order=>6
,p_column_identifier=>'G'
,p_column_label=>'APEX App ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9560000010432070)
,p_db_column_name=>'ICON_CLASS'
,p_display_order=>7
,p_column_identifier=>'H'
,p_column_label=>'Icon'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9560000011432070)
,p_db_column_name=>'IS_ACTIVE'
,p_display_order=>8
,p_column_identifier=>'I'
,p_column_label=>'Active'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9560000012432070)
,p_db_column_name=>'IS_ADMIN_ONLY'
,p_display_order=>9
,p_column_identifier=>'J'
,p_column_label=>'Admin Only'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9560000013432070)
,p_db_column_name=>'DISPLAY_ORDER'
,p_display_order=>10
,p_column_identifier=>'K'
,p_column_label=>'Order'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(9560000014432070)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'95600'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'MODULE_ID:MODULE_CODE:MODULE_NAME_EN:MODULE_NAME_AR:MODULE_TYPE:CATEGORY:APEX_APP_ID:ICON_CLASS:IS_ACTIVE:IS_ADMIN_ONLY:DISPLAY_ORDER'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9560000015432070)
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
 p_id=>wwv_flow_imp.id(9560000016432070)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(9560000001432070)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:41:&APP_SESSION.::&DEBUG.:41::'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(9560000017432070)
,p_name=>'Edit Module - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(9560000001432070)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9560000018432070)
,p_event_id=>wwv_flow_imp.id(9560000017432070)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(9560000001432070)
);
end;
/

-- =============================================================================
-- PAGE 41 — Module Details (form / drawer)
-- IDs: 9571000xxx432070
-- =============================================================================
prompt --application/pages/delete_00041
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>41);
end;
/
prompt --application/pages/page_00041
begin
wwv_flow_imp_page.create_page(
 p_id=>41
,p_name=>'Module Details'
,p_alias=>'MODULE-DETAILS'
,p_page_mode=>'MODAL'
,p_step_title=>'Module Details'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>1661186590416509825
,p_page_template_options=>'#DEFAULT#:js-dialog-class-t-Drawer--pullOutEnd'
,p_dialog_chained=>'N'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9571000001432070)
,p_plug_name=>'Module Details'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT m.module_id,',
'       m.module_code,',
'       m.module_name_en,',
'       m.module_name_ar,',
'       m.module_type,',
'       m.apex_app_id,',
'       m.apex_page_id,',
'       m.app_url,',
'       m.icon_class,',
'       m.icon_color,',
'       m.bg_color,',
'       m.description_en,',
'       m.description_ar,',
'       m.category,',
'       m.display_order,',
'       m.is_active,',
'       m.is_new_tab,',
'       m.is_admin_only',
'FROM   prod.dct_modules m'))
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9571000002432070)
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
 p_id=>wwv_flow_imp.id(9571000003432070)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(9571000002432070)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_alignment=>'RIGHT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9571000004432070)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(9571000002432070)
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
,p_button_condition=>'P41_MODULE_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9571000005432070)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(9571000002432070)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P41_MODULE_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9571000006432070)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(9571000002432070)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P41_MODULE_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9571000007432070)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(9571000002432070)
,p_button_name=>'ROLE_ACCESS'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Role Access'
,p_button_position=>'PREVIOUS'
,p_button_alignment=>'LEFT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&APP_SESSION.::NO::P42_MODULE_ID:&P41_MODULE_ID.'
,p_button_condition=>'P41_MODULE_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9571000008432070)
,p_name=>'P41_MODULE_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Module Id'
,p_source=>'MODULE_ID'
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
 p_id=>wwv_flow_imp.id(9571000009432070)
,p_name=>'P41_MODULE_CODE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Module Code'
,p_source=>'MODULE_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
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
 p_id=>wwv_flow_imp.id(9571000010432070)
,p_name=>'P41_MODULE_NAME_EN'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Name'
,p_source=>'MODULE_NAME_EN'
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
 p_id=>wwv_flow_imp.id(9571000011432070)
,p_name=>'P41_MODULE_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Name (AR)'
,p_source=>'MODULE_NAME_AR'
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
 p_id=>wwv_flow_imp.id(9571000012432070)
,p_name=>'P41_MODULE_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Type'
,p_source=>'MODULE_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:APEX App;APEX_APP,Internal;INTERNAL,External;EXTERNAL'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select Type -'
,p_lov_null_value=>''
,p_label_alignment=>'RIGHT'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9571000013432070)
,p_name=>'P41_APEX_APP_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'APEX App ID'
,p_source=>'APEX_APP_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'trim_spaces', 'LEADING')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9571000014432070)
,p_name=>'P41_APEX_PAGE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'APEX Page ID'
,p_source=>'APEX_PAGE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'trim_spaces', 'LEADING')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9571000015432070)
,p_name=>'P41_APP_URL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'App URL'
,p_source=>'APP_URL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>80
,p_cMaxlength=>500
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
 p_id=>wwv_flow_imp.id(9571000016432070)
,p_name=>'P41_ICON_CLASS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Icon Class'
,p_source=>'ICON_CLASS'
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
 p_id=>wwv_flow_imp.id(9571000017432070)
,p_name=>'P41_CATEGORY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Category'
,p_source=>'CATEGORY'
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
 p_id=>wwv_flow_imp.id(9571000018432070)
,p_name=>'P41_DESCRIPTION_EN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Description'
,p_source=>'DESCRIPTION_EN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>80
,p_cMaxlength=>1000
,p_cHeight=>3
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'disabled', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9571000019432070)
,p_name=>'P41_DISPLAY_ORDER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Display Order'
,p_source=>'DISPLAY_ORDER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'trim_spaces', 'LEADING')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9571000020432070)
,p_name=>'P41_IS_ACTIVE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Active'
,p_source=>'IS_ACTIVE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9571000021432070)
,p_name=>'P41_IS_ADMIN_ONLY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Admin Only'
,p_source=>'IS_ADMIN_ONLY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9571000022432070)
,p_name=>'P41_IS_NEW_TAB'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_item_source_plug_id=>wwv_flow_imp.id(9571000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Open in New Tab'
,p_source=>'IS_NEW_TAB'
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
 p_id=>wwv_flow_imp.id(9571000023432070)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(9571000003432070)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9571000024432070)
,p_event_id=>wwv_flow_imp.id(9571000023432070)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9571000025432070)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(9571000001432070)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Module Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>9571000025432070
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9571000026432070)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>9571000026432070
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9571000027432070)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(9571000001432070)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Module Details'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>9571000027432070
);
end;
/

-- =============================================================================
-- PAGE 42 — Module Role Access IR
-- IDs: 9582000xxx432070
-- =============================================================================
prompt --application/pages/delete_00042
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>42);
end;
/
prompt --application/pages/page_00042
begin
wwv_flow_imp_page.create_page(
 p_id=>42
,p_name=>'Module Role Access'
,p_alias=>'MODULE-ROLE-ACCESS'
,p_step_title=>'Module Role Access'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9582000001432070)
,p_plug_name=>'Module Role Access'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT mr.mr_id,',
'       m.module_name_en,',
'       r.role_id,',
'       r.role_code,',
'       r.role_name_en,',
'       r.role_name_ar,',
'       mr.access_level,',
'       mr.created_at',
'FROM   prod.dct_module_roles mr',
'JOIN   prod.dct_modules      m  ON m.module_id = mr.module_id',
'JOIN   prod.dct_roles        r  ON r.role_id   = mr.role_id',
'WHERE  mr.module_id = :P42_MODULE_ID',
'ORDER BY r.role_name_en'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Module Role Access'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(9582000002432070)
,p_name=>'Module Role Access'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No roles assigned to this module.'
,p_base_pk1=>'MR_ID'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'PROD'
,p_internal_uid=>9582000002432070
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9582000003432070)
,p_db_column_name=>'MR_ID'
,p_display_order=>0
,p_is_primary_key=>'Y'
,p_column_identifier=>'A'
,p_column_label=>'Mr Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9582000004432070)
,p_db_column_name=>'MODULE_NAME_EN'
,p_display_order=>1
,p_column_identifier=>'B'
,p_column_label=>'Module'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9582000005432070)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>2
,p_column_identifier=>'C'
,p_column_label=>'Role Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9582000006432070)
,p_db_column_name=>'ROLE_CODE'
,p_display_order=>3
,p_column_identifier=>'D'
,p_column_label=>'Role Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9582000007432070)
,p_db_column_name=>'ROLE_NAME_EN'
,p_display_order=>4
,p_column_identifier=>'E'
,p_column_label=>'Role'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9582000008432070)
,p_db_column_name=>'ROLE_NAME_AR'
,p_display_order=>5
,p_column_identifier=>'F'
,p_column_label=>'Role (AR)'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9582000009432070)
,p_db_column_name=>'ACCESS_LEVEL'
,p_display_order=>6
,p_column_identifier=>'G'
,p_column_label=>'Access Level'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9582000010432070)
,p_db_column_name=>'CREATED_AT'
,p_display_order=>7
,p_column_identifier=>'H'
,p_column_label=>'Granted At'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(9582000011432070)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'95820'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'MR_ID:MODULE_NAME_EN:ROLE_CODE:ROLE_NAME_EN:ROLE_NAME_AR:ACCESS_LEVEL:CREATED_AT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9582000012432070)
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
 p_id=>wwv_flow_imp.id(9582000013432070)
,p_name=>'P42_MODULE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9582000001432070)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Module Id'
,p_source=>'P42_MODULE_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'Y'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9582000014432070)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(9582000001432070)
,p_button_name=>'BACK_TO_MODULE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Back to Module'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:41:&APP_SESSION.::NO::P41_MODULE_ID:&P42_MODULE_ID.'
);
end;
/

prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
end;
/
COMMIT;
