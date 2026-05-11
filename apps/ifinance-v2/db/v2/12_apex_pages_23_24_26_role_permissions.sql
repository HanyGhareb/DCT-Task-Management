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
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
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
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PAGE: 24
--     PAGE: 23
--     PAGE: 26
--   Manifest End
--   Version:         24.2.15
--   Instance ID:     9249559497612069
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/

-- =============================================================================
-- PAGE 24 — Permissions Library (read-only IR)
-- IDs: 9471000xxx432070
-- =============================================================================
prompt --application/pages/delete_00024
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>24);
end;
/
prompt --application/pages/page_00024
begin
wwv_flow_imp_page.create_page(
 p_id=>24
,p_name=>'Permissions Library'
,p_alias=>'PERMISSIONS-LIBRARY'
,p_step_title=>'Permissions Library'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9471000001432070)
,p_plug_name=>'Permissions Library'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT p.permission_id,',
'       p.permission_code,',
'       p.permission_name_en AS permission_name,',
'       NVL(m.module_name_en, chr(8212)) AS module_name,',
'       p.action_type,',
'       p.description,',
'       p.is_active',
'FROM   dct_permissions p',
'LEFT JOIN dct_modules m ON p.module_id = m.module_id',
'ORDER BY m.module_name_en NULLS LAST, p.action_type, p.permission_code'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Permissions Library'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(9471000002432070)
,p_name=>'Permissions Library'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_base_pk1=>'PERMISSION_ID'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'PROD'
,p_internal_uid=>9471000002432070
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9471000003432070)
,p_db_column_name=>'PERMISSION_ID'
,p_display_order=>0
,p_is_primary_key=>'Y'
,p_column_identifier=>'A'
,p_column_label=>'Permission Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9471000004432070)
,p_db_column_name=>'PERMISSION_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9471000005432070)
,p_db_column_name=>'PERMISSION_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Permission Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9471000006432070)
,p_db_column_name=>'MODULE_NAME'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Module'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9471000007432070)
,p_db_column_name=>'ACTION_TYPE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Action Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9471000008432070)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Description'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9471000009432070)
,p_db_column_name=>'IS_ACTIVE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Active'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(9471000010432070)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'94710'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PERMISSION_ID:PERMISSION_CODE:PERMISSION_NAME:MODULE_NAME:ACTION_TYPE:DESCRIPTION:IS_ACTIVE'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9471000011432070)
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
end;
/

-- =============================================================================
-- PAGE 23 — Role Permissions (IR filtered by P23_ROLE_ID)
-- IDs: 9481000xxx432070
-- Navigated from: page 21 (Role Details) via "Permissions" button
-- Row detail link → page 26 (revoke existing)
-- "Grant Permission" button → page 26 (grant new)
-- =============================================================================
prompt --application/pages/delete_00023
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>23);
end;
/
prompt --application/pages/page_00023
begin
wwv_flow_imp_page.create_page(
 p_id=>23
,p_name=>'Role Permissions'
,p_alias=>'ROLE-PERMISSIONS'
,p_step_title=>'Role Permissions'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9481000001432070)
,p_plug_name=>'Role Permissions'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT rp.rp_id,',
'       p.permission_code,',
'       p.permission_name_en AS permission_name,',
'       NVL(m.module_name_en, chr(8212)) AS module_name,',
'       p.action_type,',
'       p.description,',
'       rp.granted_by,',
'       rp.granted_at',
'FROM   dct_role_permissions rp',
'JOIN   dct_permissions p  ON rp.permission_id = p.permission_id',
'LEFT JOIN dct_modules m   ON p.module_id      = m.module_id',
'WHERE  rp.role_id = :P23_ROLE_ID',
'ORDER BY m.module_name_en NULLS LAST, p.action_type, p.permission_code'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Role Permissions'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(9481000002432070)
,p_name=>'Role Permissions'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No permissions assigned to this role.'
,p_base_pk1=>'RP_ID'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_detail_link=>'f?p=&APP_ID.:26:&APP_SESSION.::&DEBUG.:RP:P26_ROLE_ID,P26_RP_ID:&P23_ROLE_ID.,#RP_ID#'
,p_detail_link_text=>'<span role="img" aria-label="Revoke" class="fa fa-trash-o" title="Revoke Permission"></span>'
,p_owner=>'PROD'
,p_internal_uid=>9481000002432070
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9481000003432070)
,p_db_column_name=>'RP_ID'
,p_display_order=>0
,p_is_primary_key=>'Y'
,p_column_identifier=>'A'
,p_column_label=>'Rp Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9481000004432070)
,p_db_column_name=>'PERMISSION_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9481000005432070)
,p_db_column_name=>'PERMISSION_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Permission Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9481000006432070)
,p_db_column_name=>'MODULE_NAME'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Module'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9481000007432070)
,p_db_column_name=>'ACTION_TYPE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Action Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9481000008432070)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Description'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9481000009432070)
,p_db_column_name=>'GRANTED_BY'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Granted By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9481000010432070)
,p_db_column_name=>'GRANTED_AT'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Granted At'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(9481000011432070)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'94810'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'RP_ID:PERMISSION_CODE:PERMISSION_NAME:MODULE_NAME:ACTION_TYPE:DESCRIPTION:GRANTED_BY:GRANTED_AT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9481000012432070)
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
 p_id=>wwv_flow_imp.id(9481000013432070)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(9481000001432070)
,p_button_name=>'GRANT_PERMISSION'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Grant Permission'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:26:&APP_SESSION.::&DEBUG.:RP:P26_ROLE_ID:&P23_ROLE_ID.'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(9481000014432070)
,p_name=>'Grant/Revoke Dialog Closed - Refresh IR'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(9481000001432070)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9481000015432070)
,p_event_id=>wwv_flow_imp.id(9481000014432070)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(9481000001432070)
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9481000016432070)
,p_name=>'P23_ROLE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9481000001432070)
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
end;
/

-- =============================================================================
-- PAGE 26 — Grant / Revoke Permission (modal drawer)
-- IDs: 9491000xxx432070
-- P26_RP_ID null  → GRANT mode (INSERT into dct_role_permissions)
-- P26_RP_ID set   → REVOKE mode (DELETE from dct_role_permissions)
-- =============================================================================
prompt --application/pages/delete_00026
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>26);
end;
/
prompt --application/pages/page_00026
begin
wwv_flow_imp_page.create_page(
 p_id=>26
,p_name=>'Grant / Revoke Permission'
,p_alias=>'GRANT-REVOKE-PERMISSION'
,p_page_mode=>'MODAL'
,p_step_title=>'Grant / Revoke Permission'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>1661186590416509825
,p_page_template_options=>'#DEFAULT#:js-dialog-class-t-Drawer--pullOutEnd'
,p_dialog_chained=>'N'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9491000001432070)
,p_plug_name=>'Grant / Revoke Permission'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9491000002432070)
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
 p_id=>wwv_flow_imp.id(9491000003432070)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(9491000002432070)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_alignment=>'RIGHT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9491000004432070)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(9491000002432070)
,p_button_name=>'REVOKE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Revoke Permission'
,p_button_position=>'DELETE'
,p_button_alignment=>'RIGHT'
,p_button_execute_validations=>'N'
,p_confirm_message=>'Revoke this permission from the role?'
,p_confirm_style=>'danger'
,p_button_condition=>'P26_RP_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9491000005432070)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(9491000002432070)
,p_button_name=>'GRANT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Grant Permission'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P26_RP_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9491000006432070)
,p_name=>'P26_RP_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9491000001432070)
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9491000007432070)
,p_name=>'P26_ROLE_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(9491000001432070)
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9491000008432070)
,p_name=>'P26_PERMISSION_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(9491000001432070)
,p_prompt=>'Permission'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT p.permission_name_en || '' ['' || p.permission_code || '']'' d,',
'       p.permission_id r',
'FROM   dct_permissions p',
'WHERE  p.is_active = ''Y''',
'  AND  p.permission_id NOT IN (',
'           SELECT rp.permission_id',
'           FROM   dct_role_permissions rp',
'           WHERE  rp.role_id = :P26_ROLE_ID',
'             AND  (:P26_RP_ID IS NULL OR rp.rp_id != :P26_RP_ID)',
'       )',
'UNION ALL',
'SELECT p.permission_name_en || '' ['' || p.permission_code || '']'' d,',
'       p.permission_id r',
'FROM   dct_permissions p',
'JOIN   dct_role_permissions rp ON rp.permission_id = p.permission_id',
'WHERE  rp.rp_id = :P26_RP_ID',
'ORDER BY 1'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select Permission -'
,p_lov_null_value=>''
,p_label_alignment=>'RIGHT'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(9491000009432070)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(9491000003432070)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9491000010432070)
,p_event_id=>wwv_flow_imp.id(9491000009432070)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9491000011432070)
,p_process_sequence=>5
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Existing Permission'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF :P26_RP_ID IS NOT NULL THEN',
'    SELECT permission_id',
'    INTO   :P26_PERMISSION_ID',
'    FROM   dct_role_permissions',
'    WHERE  rp_id   = :P26_RP_ID',
'    AND    role_id = :P26_ROLE_ID;',
'END IF;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P26_RP_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>9491000011432070
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9491000012432070)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Grant Permission'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO dct_role_permissions (role_id, permission_id, granted_by, granted_at)',
'VALUES (:P26_ROLE_ID, :P26_PERMISSION_ID, :APP_USER, SYSTIMESTAMP);'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'GRANT'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>9491000012432070
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9491000013432070)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Revoke Permission'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DELETE FROM dct_role_permissions',
'WHERE  rp_id   = :P26_RP_ID',
'AND    role_id = :P26_ROLE_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'REVOKE'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>9491000013432070
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9491000014432070)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'GRANT,REVOKE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>9491000014432070
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
