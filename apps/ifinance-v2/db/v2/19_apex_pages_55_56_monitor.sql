-- =============================================================================
-- Sprint 4 — APEX Pages 55 + 56
--   55: Approval Monitor IR (all instances, all users)
--   56: Approval Instance Detail (read-only audit trail)
-- IDs: 9644000xxx432070 / 9655000xxx432070
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
-- PAGE 55 — Approval Monitor IR
-- =============================================================================
prompt --application/pages/delete_00055
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>55);
end;
/
prompt --application/pages/page_00055
begin
wwv_flow_imp_page.create_page(
 p_id=>55
,p_name=>'Approval Monitor'
,p_alias=>'APPROVAL-MONITOR'
,p_step_title=>'Approval Monitor'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9644000001432070)
,p_plug_name=>'Approval Monitor'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT i.instance_id,',
'       i.source_record_ref,',
'       i.source_module,',
'       t.template_name,',
'       i.overall_status,',
'       i.current_step_seq,',
'       s.step_name       AS current_step_name,',
'       u.display_name    AS submitted_by_name,',
'       i.submitted_at,',
'       i.last_action_at,',
'       i.completed_at',
'FROM   prod.dct_approval_instances i',
'JOIN   prod.dct_approval_templates t ON t.template_id = i.template_id',
'LEFT JOIN prod.dct_approval_steps s',
'       ON s.template_id = i.template_id',
'      AND s.step_seq    = i.current_step_seq',
'LEFT JOIN prod.dct_users u ON u.user_id = i.submitted_by',
'ORDER BY i.submitted_at DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Approval Monitor'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(9644000002432070)
,p_name=>'Approval Monitor'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_base_pk1=>'INSTANCE_ID'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'PROD'
,p_internal_uid=>9644000002432070
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9644000003432070)
,p_db_column_name=>'INSTANCE_ID'
,p_display_order=>0
,p_is_primary_key=>'Y'
,p_column_identifier=>'A'
,p_column_label=>'Instance Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9644000004432070)
,p_db_column_name=>'SOURCE_RECORD_REF'
,p_display_order=>1
,p_column_identifier=>'B'
,p_column_label=>'Reference'
,p_column_link=>'f?p=&APP_ID.:56:&SESSION.::&DEBUG.::P56_INSTANCE_ID:#INSTANCE_ID#'
,p_column_linktext=>'#SOURCE_RECORD_REF#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9644000005432070)
,p_db_column_name=>'SOURCE_MODULE'
,p_display_order=>2
,p_column_identifier=>'C'
,p_column_label=>'Module'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9644000006432070)
,p_db_column_name=>'TEMPLATE_NAME'
,p_display_order=>3
,p_column_identifier=>'D'
,p_column_label=>'Template'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9644000007432070)
,p_db_column_name=>'OVERALL_STATUS'
,p_display_order=>4
,p_column_identifier=>'E'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9644000008432070)
,p_db_column_name=>'CURRENT_STEP_NAME'
,p_display_order=>5
,p_column_identifier=>'F'
,p_column_label=>'Current Step'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9644000009432070)
,p_db_column_name=>'SUBMITTED_BY_NAME'
,p_display_order=>6
,p_column_identifier=>'G'
,p_column_label=>'Submitted By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9644000010432070)
,p_db_column_name=>'SUBMITTED_AT'
,p_display_order=>7
,p_column_identifier=>'H'
,p_column_label=>'Submitted'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9644000011432070)
,p_db_column_name=>'LAST_ACTION_AT'
,p_display_order=>8
,p_column_identifier=>'I'
,p_column_label=>'Last Action'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(9644000012432070)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'96440'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'INSTANCE_ID:SOURCE_RECORD_REF:SOURCE_MODULE:TEMPLATE_NAME:OVERALL_STATUS:CURRENT_STEP_NAME:SUBMITTED_BY_NAME:SUBMITTED_AT:LAST_ACTION_AT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9644000013432070)
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
-- PAGE 56 — Approval Instance Detail (read-only)
-- =============================================================================
prompt --application/pages/delete_00056
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>56);
end;
/
prompt --application/pages/page_00056
begin
wwv_flow_imp_page.create_page(
 p_id=>56
,p_name=>'Approval Instance Detail'
,p_alias=>'APPROVAL-INSTANCE-DETAIL'
,p_step_title=>'Approval Instance Detail'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
-- Instance summary region (Classic Report)
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9655000001432070)
,p_plug_name=>'Instance Summary'
,p_region_template_options=>'#DEFAULT#:t-Region--accent2'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT i.instance_id,',
'       i.source_record_ref,',
'       i.source_module,',
'       t.template_name,',
'       i.overall_status,',
'       i.current_step_seq,',
'       s.step_name      AS current_step_name,',
'       u.display_name   AS submitted_by_name,',
'       i.submitted_at,',
'       i.completed_at',
'FROM   prod.dct_approval_instances i',
'JOIN   prod.dct_approval_templates t ON t.template_id = i.template_id',
'LEFT JOIN prod.dct_approval_steps s',
'       ON s.template_id = i.template_id',
'      AND s.step_seq    = i.current_step_seq',
'LEFT JOIN prod.dct_users u ON u.user_id = i.submitted_by',
'WHERE  i.instance_id = :P56_INSTANCE_ID'))
,p_plug_source_type=>'NATIVE_SQL_REPORT'
,p_prn_page_header=>'Instance Summary'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9655000002432070)
,p_query_column_id=>1
,p_column_alias=>'INSTANCE_ID'
,p_column_display_sequence=>1
,p_column_heading=>'Instance ID'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9655000003432070)
,p_query_column_id=>2
,p_column_alias=>'SOURCE_RECORD_REF'
,p_column_display_sequence=>2
,p_column_heading=>'Reference'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9655000004432070)
,p_query_column_id=>3
,p_column_alias=>'SOURCE_MODULE'
,p_column_display_sequence=>3
,p_column_heading=>'Module'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9655000005432070)
,p_query_column_id=>4
,p_column_alias=>'TEMPLATE_NAME'
,p_column_display_sequence=>4
,p_column_heading=>'Template'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9655000006432070)
,p_query_column_id=>5
,p_column_alias=>'OVERALL_STATUS'
,p_column_display_sequence=>5
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9655000007432070)
,p_query_column_id=>6
,p_column_alias=>'CURRENT_STEP_NAME'
,p_column_display_sequence=>6
,p_column_heading=>'Current Step'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9655000008432070)
,p_query_column_id=>7
,p_column_alias=>'SUBMITTED_BY_NAME'
,p_column_display_sequence=>7
,p_column_heading=>'Submitted By'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9655000009432070)
,p_query_column_id=>8
,p_column_alias=>'SUBMITTED_AT'
,p_column_display_sequence=>8
,p_column_heading=>'Submitted At'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9655000010432070)
,p_query_column_id=>9
,p_column_alias=>'COMPLETED_AT'
,p_column_display_sequence=>9
,p_column_heading=>'Completed At'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
-- Action History IR
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9655000011432070)
,p_plug_name=>'Action History'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT a.actioned_at,',
'       u.display_name   AS actioned_by_name,',
'       s.step_seq,',
'       s.step_name,',
'       a.action,',
'       a.comments,',
'       a.is_escalation',
'FROM   prod.dct_approval_actions a',
'JOIN   prod.dct_approval_steps s ON s.step_id = a.step_id',
'LEFT JOIN prod.dct_users u ON u.user_id = a.actioned_by',
'WHERE  a.instance_id = :P56_INSTANCE_ID',
'ORDER BY a.actioned_at'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Action History'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(9655000012432070)
,p_name=>'Action History'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No actions recorded yet.'
,p_base_pk1=>'ACTIONED_AT'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'PROD'
,p_internal_uid=>9655000012432070
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9655000013432070)
,p_db_column_name=>'ACTIONED_AT'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9655000014432070)
,p_db_column_name=>'ACTIONED_BY_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9655000015432070)
,p_db_column_name=>'STEP_SEQ'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Step #'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9655000016432070)
,p_db_column_name=>'STEP_NAME'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Step'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9655000017432070)
,p_db_column_name=>'ACTION'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Action'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9655000018432070)
,p_db_column_name=>'COMMENTS'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(9655000019432070)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'96550'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ACTIONED_AT:ACTIONED_BY_NAME:STEP_SEQ:STEP_NAME:ACTION:COMMENTS'
);
-- Breadcrumb
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9655000020432070)
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
-- P56_INSTANCE_ID page item
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9655000021432070)
,p_name=>'P56_INSTANCE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9655000001432070)
,p_use_cache_before_default=>'NO'
,p_source=>'P56_INSTANCE_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
-- Back to Monitor button
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9655000022432070)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(9655000001432070)
,p_button_name=>'BACK_TO_MONITOR'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Back to Monitor'
,p_button_position=>'ABOVE_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:55:&APP_SESSION.::NO::'
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
