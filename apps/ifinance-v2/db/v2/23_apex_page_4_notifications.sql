-- =============================================================================
-- Sprint 5 — APEX Page 4
--   4: My Notifications IR
-- IDs: 9755000xxx432070
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
-- PAGE 4 — My Notifications
-- =============================================================================
prompt --application/pages/delete_00004
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>4);
end;
/
prompt --application/pages/page_00004
begin
wwv_flow_imp_page.create_page(
 p_id=>4
,p_name=>'My Notifications'
,p_alias=>'MY-NOTIFICATIONS'
,p_step_title=>'My Notifications'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
-- ── Breadcrumb ────────────────────────────────────────────────────────────────
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9755000000432070)
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
 p_id=>wwv_flow_imp.id(9755000001432070)
,p_plug_name=>'My Notifications'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT n.notification_id,',
'       n.is_read,',
'       n.notification_type,',
'       n.title_en,',
'       n.body_en,',
'       n.link_url,',
'       n.created_at,',
'       n.expires_at',
'FROM   prod.dct_notifications n',
'JOIN   prod.dct_users u ON u.user_id = n.recipient_user_id',
'WHERE  UPPER(u.username) = UPPER(:APP_USER)',
'ORDER BY n.is_read, n.created_at DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'My Notifications'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(9755000002432070)
,p_name=>'My Notifications'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No notifications found.'
,p_base_pk1=>'NOTIFICATION_ID'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX'
,p_enable_mail_download=>'Y'
,p_owner=>'PROD'
,p_internal_uid=>9755000002432070
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9755000003432070)
,p_db_column_name=>'NOTIFICATION_ID'
,p_display_order=>0
,p_is_primary_key=>'Y'
,p_column_identifier=>'A'
,p_column_label=>'ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9755000004432070)
,p_db_column_name=>'IS_READ'
,p_display_order=>1
,p_column_identifier=>'B'
,p_column_label=>'Read'
,p_column_type=>'STRING'
,p_heading_alignment=>'CENTER'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9755000005432070)
,p_db_column_name=>'NOTIFICATION_TYPE'
,p_display_order=>2
,p_column_identifier=>'C'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9755000006432070)
,p_db_column_name=>'TITLE_EN'
,p_display_order=>3
,p_column_identifier=>'D'
,p_column_label=>'Title'
,p_column_link=>'#LINK_URL#'
,p_column_linktext=>'#TITLE_EN#'
,p_column_link_attr=>'target="_blank"'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9755000007432070)
,p_db_column_name=>'BODY_EN'
,p_display_order=>4
,p_column_identifier=>'E'
,p_column_label=>'Message'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9755000008432070)
,p_db_column_name=>'LINK_URL'
,p_display_order=>5
,p_column_identifier=>'F'
,p_column_label=>'Link'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9755000009432070)
,p_db_column_name=>'CREATED_AT'
,p_display_order=>6
,p_column_identifier=>'G'
,p_column_label=>'Received'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(9755000010432070)
,p_db_column_name=>'EXPIRES_AT'
,p_display_order=>7
,p_column_identifier=>'H'
,p_column_label=>'Expires'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(9755000011432070)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'97550000114'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'NOTIFICATION_ID:IS_READ:NOTIFICATION_TYPE:TITLE_EN:BODY_EN:LINK_URL:CREATED_AT:EXPIRES_AT'
);
-- ── Toolbar button: Mark All Read ─────────────────────────────────────────────
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9755000012432070)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(9755000001432070)
,p_button_name=>'MARK_ALL_READ'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Mark All Read'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_icon_css_classes=>'fa-check-circle-o'
);
-- ── Process: Mark All Read ────────────────────────────────────────────────────
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9755000013432070)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Mark All Notifications Read'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'UPDATE prod.dct_notifications',
'SET    is_read  = ''Y'',',
'       read_at  = SYSTIMESTAMP',
'WHERE  recipient_user_id = (',
'           SELECT user_id',
'           FROM   prod.dct_users',
'           WHERE  UPPER(username) = UPPER(:APP_USER)',
'       )',
'  AND  is_read = ''N'';'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'All notifications marked as read.'
,p_process_when=>'MARK_ALL_READ'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
);
end;
/
-- ── end ───────────────────────────────────────────────────────────────────────
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/

prompt Page 4 (My Notifications IR) created.

set define on verify on feedback on
