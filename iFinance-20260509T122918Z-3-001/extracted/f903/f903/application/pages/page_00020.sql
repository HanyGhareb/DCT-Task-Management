prompt --application/pages/page_00020
begin
--   Manifest
--     PAGE: 00020
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
 p_id=>20
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'End User - Home'
,p_alias=>'USERHOME'
,p_step_title=>'End User - Home'
,p_autocomplete_on_off=>'OFF'
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
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200404011837'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(70769190395532723)
,p_name=>'<b>Recent Transfer Requests 2<b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'  substr(updated_by,0,2) user_avatar,',
'  ''u-color-''|| ( ora_hash(updated_by,45) + 1 ) user_color,',
'  (select e.full_name_en',
'    from dct_employees_list2 e',
'    where e.user_name = btf_end_users_req.updated_by) user_name,',
'  btf_end_users_req.updated_date event_date,',
'  btf_end_users_req.request_status event_type,',
'  btf_end_users_req.project_number || ''-'' || btf_end_users_req.task_number event_title,',
'  btf_end_users_req.justification  event_desc,',
'  case btf_end_users_req.request_status ',
'    when ''Draft'' then ''fa fa-clock-o''',
'    when ''closed'' then ''fa fa-check-circle-o''',
'    when ''on-hold'' then ''fa fa-exclamation-circle''',
'    when ''pending'' then ''fa fa-exclamation-triangle''',
'  end event_icon,',
'  case btf_end_users_req.request_status ',
'    when ''Draft'' then ''is-new''',
'    when ''closed'' then ''is-removed''',
'    when ''on-hold'' then ''is-updated''',
'    when ''pending'' then ''is-updated''',
'  end event_status,',
' -- ''f?p=&APP_ID.:21:&APP_SESSION.::NO::P21_REQUEST_ID:''||request_id event_link',
'  apex_util.prepare_url( ''f?p=''||:APP_ID||'':21:''||:APP_SESSION||''::NO::P21_REQUEST_ID:''|| request_id ) event_link',
'from btf_end_users_req',
'where created_by = :APP_USER',
'order by updated_date'))
,p_display_when_condition=>'USER_ACCESS_SECTOR'
,p_display_when_cond2=>'Y'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(65556509573255757)
,p_query_num_rows=>5
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No Budget Transfer Requests created for your sector/s.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70770299373532734)
,p_query_column_id=>1
,p_column_alias=>'USER_AVATAR'
,p_column_display_sequence=>1
,p_column_heading=>'User Avatar'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70770391635532735)
,p_query_column_id=>2
,p_column_alias=>'USER_COLOR'
,p_column_display_sequence=>2
,p_column_heading=>'User Color'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70770477190532736)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70770567937532737)
,p_query_column_id=>4
,p_column_alias=>'EVENT_DATE'
,p_column_display_sequence=>4
,p_column_heading=>'Event Date'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70770693677532738)
,p_query_column_id=>5
,p_column_alias=>'EVENT_TYPE'
,p_column_display_sequence=>5
,p_column_heading=>'Event Type'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70770720711532739)
,p_query_column_id=>6
,p_column_alias=>'EVENT_TITLE'
,p_column_display_sequence=>6
,p_column_heading=>'Event Title'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70770893274532740)
,p_query_column_id=>7
,p_column_alias=>'EVENT_DESC'
,p_column_display_sequence=>7
,p_column_heading=>'Event Desc'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70770927113532741)
,p_query_column_id=>8
,p_column_alias=>'EVENT_ICON'
,p_column_display_sequence=>8
,p_column_heading=>'Event Icon'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70771094794532742)
,p_query_column_id=>9
,p_column_alias=>'EVENT_STATUS'
,p_column_display_sequence=>9
,p_column_heading=>'Event Status'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70771151321532743)
,p_query_column_id=>10
,p_column_alias=>'EVENT_LINK'
,p_column_display_sequence=>10
,p_column_heading=>'Event Link'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(136232026410233649)
,p_plug_name=>'<b>Budget Transfer Requests - Home</b>'
,p_icon_css_classes=>'app-icon'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65537437145255750)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(136334506650233783)
,p_plug_name=>'Page Navigation'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:u-colors:t-Cards--featured t-Cards--block force-fa-lg:t-Cards--displayIcons:t-Cards--spanHorizontally:t-Cards--hideBody:t-Cards--animColorFill'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>90
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(65742603533256041)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(65590504563255778)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(137122464818642289)
,p_plug_name=>'Summary Status'
,p_region_name=>'badgeListCircular'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Draft'' lable , Count(*) value ',
'--, apex_util.prepare_url( ''f?p=''||:APP_ID||'':11:''||:APP_SESSION||''::NO::P11_STATUS:''|| ''Approved'' ) as link',
'from btf_end_users_req',
'where request_status =  ''Draft''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and btf_end_users_req.created_by = :APP_USER',
'UNION all',
'select ''Submitted'' lable , Count(*) value ',
'--, apex_util.prepare_url( ''f?p=''||:APP_ID||'':11:''||:APP_SESSION||''::NO::P11_STATUS:''|| ''Approved'' ) as link',
'from btf_end_users_req',
'where request_status =  ''Submitted''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and btf_end_users_req.created_by = :APP_USER',
'UNION all',
'select ''Accepted'' lable , Count(*) value ',
'--, apex_util.prepare_url( ''f?p=''||:APP_ID||'':11:''||:APP_SESSION||''::NO::P11_STATUS:''|| ''Approved'' ) as link',
'from btf_end_users_req',
'where request_status =  ''Accepted''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and btf_end_users_req.created_by = :APP_USER',
'UNION all',
'select ''Refused'' lable , Count(*) value ',
'--, apex_util.prepare_url( ''f?p=''||:APP_ID||'':11:''||:APP_SESSION||''::NO::P11_STATUS:''|| ''Approved'' ) as link',
'from btf_end_users_req',
'where request_status =  ''Refused''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and btf_end_users_req.created_by = :APP_USER'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'LABLE'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'&LINK.'
,p_attribute_05=>'0'
,p_attribute_06=>'L'
,p_attribute_07=>'DOT'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(137262899968084543)
,p_plug_name=>'<b>Budget Transfers By Sector</b>'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'USER_ACCESS_SECTOR'
,p_plug_display_when_cond2=>'Y'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(70619922823977681)
,p_region_id=>wwv_flow_api.id(137262899968084543)
,p_chart_type=>'bar'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'none'
,p_hover_behavior=>'none'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>false
,p_show_row=>false
,p_show_start=>false
,p_show_end=>false
,p_show_progress=>false
,p_show_baseline=>false
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>false
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(70621633765977680)
,p_chart_id=>wwv_flow_api.id(70619922823977681)
,p_seq=>10
,p_name=>'BTF Year'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Total'' Series ,  count(distinct form_no) , tca_sector',
'from btf_lines',
'where form_no in(select a.form_no  from btf_header a where a.year = EXTRACT(YEAR FROM sysdate))',
'and tca_sector in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                            and btf_data_access.user_id = :APP_USER)',
'                                            ',
'and from_to = :P20_FROM_TO_S                                               ',
'GROUP by tca_sector',
'order BY 1 desc'))
,p_ajax_items_to_submit=>'P20_FROM_TO_S'
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'COUNT(DISTINCTFORM_NO)'
,p_items_label_column_name=>'TCA_SECTOR'
,p_color=>'#0E6654'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(70622283588977680)
,p_chart_id=>wwv_flow_api.id(70619922823977681)
,p_seq=>20
,p_name=>'Approved'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Approved'' Series ,  count(distinct form_no) , tca_sector',
'from btf_lines',
'where form_no in(select a.form_no  ',
'                  from btf_header a ',
'                  where a.year = EXTRACT(YEAR FROM sysdate)',
'                  and a.status = ''Approved'')',
'and tca_sector in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                            and btf_data_access.user_id = :APP_USER)',
'and from_to = :P20_FROM_TO_S                                               ',
'GROUP by tca_sector',
'order BY 1 desc'))
,p_ajax_items_to_submit=>'P20_FROM_TO_S'
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'COUNT(DISTINCTFORM_NO)'
,p_items_label_column_name=>'TCA_SECTOR'
,p_color=>'#27A849'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(70622824306977679)
,p_chart_id=>wwv_flow_api.id(70619922823977681)
,p_seq=>30
,p_name=>'Rejected'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Rejected'' Series ,  count(distinct form_no) , tca_sector',
'from btf_lines',
'where form_no in(select a.form_no  ',
'                  from btf_header a ',
'                  where a.year = EXTRACT(YEAR FROM sysdate)',
'                  and a.status = ''Rejected'')',
'and tca_sector in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                            and btf_data_access.user_id = :APP_USER)',
'and from_to = :P20_FROM_TO_S                                               ',
'GROUP by tca_sector',
'order BY 1 desc'))
,p_ajax_items_to_submit=>'P20_FROM_TO_S'
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'COUNT(DISTINCTFORM_NO)'
,p_items_label_column_name=>'TCA_SECTOR'
,p_color=>'#C72E2E'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(70623487926977679)
,p_chart_id=>wwv_flow_api.id(70619922823977681)
,p_seq=>40
,p_name=>'in-Progress'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''in-Progress'' Series ,  count(distinct form_no) , tca_sector',
'from btf_lines',
'where form_no in(select a.form_no  ',
'                  from btf_header a ',
'                  where a.year = EXTRACT(YEAR FROM sysdate)',
'                  and a.status = ''in-Progress'')',
'and tca_sector in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                            and btf_data_access.user_id = :APP_USER)',
'and from_to = :P20_FROM_TO_S                                               ',
'GROUP by tca_sector',
'order BY 1 desc'))
,p_ajax_items_to_submit=>'P20_FROM_TO_S'
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'COUNT(DISTINCTFORM_NO)'
,p_items_label_column_name=>'TCA_SECTOR'
,p_color=>'#11BDA6'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(70620452546977681)
,p_chart_id=>wwv_flow_api.id(70619922823977681)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(70621071613977681)
,p_chart_id=>wwv_flow_api.id(70619922823977681)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_step=>2
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(137263890444084553)
,p_name=>'<b>Recent Transfer Requests<b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   request_id ',
'        , request_no ',
'        , justification ',
'        , request_status',
'        , case request_status ',
'                    when ''TTT'' then ''fa-clock-o is-open''',
'                    when ''22'' then ''fa-check-circle is-closed''',
'                    when ''Draft'' then ''fa fa-check-circle'' --fa-exclamation-circle is-holding''',
'                    when ''Pending'' then ''fa-exclamation-triangle is-pending''',
'          end    status_icon',
'        , case request_status ',
'                    when ''Draft'' then ''gray''',
'                    when ''Acepted'' then ''green''',
'                    when ''Refused'' then ''red'' --fa-exclamation-circle is-holding''',
'                    when ''Approved'' then ''yellow''',
'          end icon_color  ',
'        , project_number',
'        , task_number ',
'        , requested_amount',
'from btf_end_users_req',
'where created_by = :APP_USER',
'order by updated_date'))
,p_display_when_condition=>'USER_ACCESS_SECTOR'
,p_display_when_cond2=>'Y'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(65567986443255766)
,p_query_num_rows=>5
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No Budget Transfer Requests created for your sector/s.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70534123852675010)
,p_query_column_id=>1
,p_column_alias=>'REQUEST_ID'
,p_column_display_sequence=>1
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70534249337675011)
,p_query_column_id=>2
,p_column_alias=>'REQUEST_NO'
,p_column_display_sequence=>2
,p_column_heading=>'Request No'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::P21_REQUEST_ID:#REQUEST_ID#'
,p_column_linktext=>'#REQUEST_NO#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70534310569675012)
,p_query_column_id=>3
,p_column_alias=>'JUSTIFICATION'
,p_column_display_sequence=>5
,p_column_heading=>'Justification'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70534445022675013)
,p_query_column_id=>4
,p_column_alias=>'REQUEST_STATUS'
,p_column_display_sequence=>6
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span class="fa #STATUS_ICON#" style="color: #ICON_COLOR#"></span> #REQUEST_STATUS#  '
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70768955968532721)
,p_query_column_id=>5
,p_column_alias=>'STATUS_ICON'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70769004525532722)
,p_query_column_id=>6
,p_column_alias=>'ICON_COLOR'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70534547801675014)
,p_query_column_id=>7
,p_column_alias=>'PROJECT_NUMBER'
,p_column_display_sequence=>3
,p_column_heading=>'Project'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'#PROJECT_NUMBER#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70534614290675015)
,p_query_column_id=>8
,p_column_alias=>'TASK_NUMBER'
,p_column_display_sequence=>4
,p_column_heading=>'Task'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'#TASK_NUMBER#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70534701536675016)
,p_query_column_id=>9
,p_column_alias=>'REQUESTED_AMOUNT'
,p_column_display_sequence=>7
,p_column_heading=>'Amount'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'#REQUESTED_AMOUNT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(137266386369084578)
,p_name=>'Budget Team Pending List'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>80
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_new_grid_row=>false
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    form_no,',
'    revision_no,',
'    creation_date,',
'    created_by,',
'    reason,',
'    btf_no,',
'    ORACLE_APPROVAL1,',
'    ORACLE_APPROVAL2,',
'    ORACLE_HYPERION,',
'    status,',
'    updated_by,',
'    updated_date,',
'    year,',
'    sector',
'    ,(select sum(nvl(l.transferred_amount ,0)) ',
'        from btf_lines l',
'        where l.form_no = btf_header.form_no',
'        and l.from_to = ''FROM'') total_from',
'    ,(select sum(nvl(l.transferred_amount ,0)) ',
'        from btf_lines l',
'        where l.form_no = btf_header.form_no',
'        and l.from_to = ''TO'') total_to',
'    ,',
'    (select h.user_name',
'        from btf_approval_history h',
'        where h.form_no = btf_header.form_no',
'        and h.status = ''Pending'')',
'        || ',
'    (select e.full_name_en',
'        from dct_employees_list2 e',
'        where e.employee_num = (select substr(h.user_name,4)',
'                                from btf_approval_history h',
'                                where h.form_no = btf_header.form_no',
'                                and h.status = ''Pending''))Pending_with',
'FROM',
'    btf_header',
'where form_no in (select a.form_no from btf_approval_history a where a.status = ''Pending'' and a.entity_name = ''Budget Planning'')    ',
'    order by updated_date desc;'))
,p_display_condition_type=>'NEVER'
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(65567986443255766)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70592105941977719)
,p_query_column_id=>1
,p_column_alias=>'FORM_NO'
,p_column_display_sequence=>1
,p_column_heading=>'Form No'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:RP:P9_FORM_NO:#FORM_NO#'
,p_column_linktext=>'#FORM_NO#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70592594043977718)
,p_query_column_id=>2
,p_column_alias=>'REVISION_NO'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70592941209977718)
,p_query_column_id=>3
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>3
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70593310190977717)
,p_query_column_id=>4
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>4
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70593723628977717)
,p_query_column_id=>5
,p_column_alias=>'REASON'
,p_column_display_sequence=>5
,p_column_heading=>'Reason'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70594138900977717)
,p_query_column_id=>6
,p_column_alias=>'BTF_NO'
,p_column_display_sequence=>6
,p_column_heading=>'Btf No'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70594587255977716)
,p_query_column_id=>7
,p_column_alias=>'ORACLE_APPROVAL1'
,p_column_display_sequence=>7
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70594910524977716)
,p_query_column_id=>8
,p_column_alias=>'ORACLE_APPROVAL2'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70595329812977716)
,p_query_column_id=>9
,p_column_alias=>'ORACLE_HYPERION'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70595785667977716)
,p_query_column_id=>10
,p_column_alias=>'STATUS'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70596112051977716)
,p_query_column_id=>11
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70596529668977716)
,p_query_column_id=>12
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>12
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70596931635977715)
,p_query_column_id=>13
,p_column_alias=>'YEAR'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70597383175977715)
,p_query_column_id=>14
,p_column_alias=>'SECTOR'
,p_column_display_sequence=>14
,p_column_heading=>'Sector'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70597750497977715)
,p_query_column_id=>15
,p_column_alias=>'TOTAL_FROM'
,p_column_display_sequence=>15
,p_column_heading=>'Total From'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70598135912977715)
,p_query_column_id=>16
,p_column_alias=>'TOTAL_TO'
,p_column_display_sequence=>16
,p_column_heading=>'Total To'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70598592614977715)
,p_query_column_id=>17
,p_column_alias=>'PENDING_WITH'
,p_column_display_sequence=>17
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(137338356541526764)
,p_name=>'<b>My Work List</b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    form_no,',
'    revision_no,',
'    creation_date,',
'    created_by,',
'    reason,',
'    btf_no,',
'    ORACLE_APPROVAL1,',
'    ORACLE_APPROVAL2,',
'    ORACLE_HYPERION,',
'    status,',
'    updated_by,',
'    updated_date,',
'    year,',
'    sector',
'    ,(select sum(nvl(l.transferred_amount ,0)) ',
'        from btf_lines l',
'        where l.form_no = btf_header.form_no',
'        and l.from_to = ''FROM'') total_from',
'    ,(select sum(nvl(l.transferred_amount ,0)) ',
'        from btf_lines l',
'        where l.form_no = btf_header.form_no',
'        and l.from_to = ''TO'') total_to',
'    ,',
'    (select h.user_name',
'        from btf_approval_history h',
'        where h.form_no = btf_header.form_no',
'        and h.status = ''Pending''',
'        and h.user_name = :APP_USER)',
'        || ''-'' ||',
'    (select e.full_name_en',
'        from dct_employees_list2 e',
'        where e.user_name = :APP_USER)Pending_with',
'FROM',
'    btf_header',
'where form_no in (select a.form_no from btf_approval_history a where a.status = ''Pending'' and a.user_name = :APP_USER)    ',
'    order by updated_date desc;'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(65567986443255766)
,p_query_num_rows=>10
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'you don''t have any pending task, Good Done.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70599230558977711)
,p_query_column_id=>1
,p_column_alias=>'FORM_NO'
,p_column_display_sequence=>1
,p_column_heading=>'Form No'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:RP:P12_FORM_NO:#FORM_NO#'
,p_column_linktext=>'#FORM_NO#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70599606161977711)
,p_query_column_id=>2
,p_column_alias=>'REVISION_NO'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
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
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70600042625977711)
,p_query_column_id=>3
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>3
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70600468130977711)
,p_query_column_id=>4
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>4
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70600883871977710)
,p_query_column_id=>5
,p_column_alias=>'REASON'
,p_column_display_sequence=>5
,p_column_heading=>'Reason'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70601294249977710)
,p_query_column_id=>6
,p_column_alias=>'BTF_NO'
,p_column_display_sequence=>6
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70601634956977710)
,p_query_column_id=>7
,p_column_alias=>'ORACLE_APPROVAL1'
,p_column_display_sequence=>7
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70602070686977710)
,p_query_column_id=>8
,p_column_alias=>'ORACLE_APPROVAL2'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70602437974977710)
,p_query_column_id=>9
,p_column_alias=>'ORACLE_HYPERION'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70602874331977710)
,p_query_column_id=>10
,p_column_alias=>'STATUS'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70603222193977710)
,p_query_column_id=>11
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70603675232977709)
,p_query_column_id=>12
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>12
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70604055535977709)
,p_query_column_id=>13
,p_column_alias=>'YEAR'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70604459205977709)
,p_query_column_id=>14
,p_column_alias=>'SECTOR'
,p_column_display_sequence=>14
,p_column_heading=>'Sector'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70604825788977709)
,p_query_column_id=>15
,p_column_alias=>'TOTAL_FROM'
,p_column_display_sequence=>15
,p_column_heading=>'Total From'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70605200507977709)
,p_query_column_id=>16
,p_column_alias=>'TOTAL_TO'
,p_column_display_sequence=>16
,p_column_heading=>'Total To'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(70605698448977709)
,p_query_column_id=>17
,p_column_alias=>'PENDING_WITH'
,p_column_display_sequence=>17
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(140861019482184369)
,p_plug_name=>'<b>Approval History</b>'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>100
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(140860295493184362)
,p_plug_name=>'Approval History Table'
,p_parent_plug_id=>wwv_flow_api.id(140861019482184369)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'      ID,',
'       FORM_NO',
'       , (select reason from btf_header where btf_header.form_no = btf_approval_history.form_no) Reason',
'--       STEP_NO,',
'--       POSITION,',
'--       ENTITY_TYPE,',
'--       ENTITY_NAME,',
'--       ACTION_REQUIRED,',
'--       USER_NAME,',
'       ,STATUS,',
'       RECEVIED_DATE,',
'       ACTION_DATE,',
'       COMMENTS',
'--       CREATED_ON,',
'--       CREATED_BY,',
'--       UPDATED_BY,',
'--       UPDATED_ON',
'  from BTF_APPROVAL_HISTORY',
' where user_name = :APP_USER',
' and status not in (''Future'' , ''Submitted'' )',
'order by action_date'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>8.5
,p_prn_height=>11
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#9bafde'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'normal'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#efefef'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(140860345212184363)
,p_max_row_count=>'1000000'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_show_flashback=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>140860345212184363
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70606675313977705)
,p_db_column_name=>'FORM_NO'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Form No'
,p_column_link=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:RP:P9_FORM_NO,P9_ID:#FORM_NO#,#ID#'
,p_column_linktext=>'#FORM_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70608615969977698)
,p_db_column_name=>'REASON'
,p_display_order=>20
,p_column_identifier=>'F'
,p_column_label=>'Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70607040945977700)
,p_db_column_name=>'STATUS'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70607475391977700)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70607843040977699)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70608261926977698)
,p_db_column_name=>'COMMENTS'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70609079622977698)
,p_db_column_name=>'ID'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(140876066920530168)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'706094'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FORM_NO:STATUS:RECEVIED_DATE:ACTION_DATE:COMMENTS:REASON:ID'
,p_sort_column_1=>'ACTION_DATE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(140965286619309454)
,p_plug_name=>'<b>Amounts By Sectors</b>'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(70610186996977694)
,p_region_id=>wwv_flow_api.id(140965286619309454)
,p_chart_type=>'bar'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'none'
,p_hover_behavior=>'none'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>false
,p_show_row=>false
,p_show_start=>false
,p_show_end=>false
,p_show_progress=>false
,p_show_baseline=>false
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>false
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(70612967987977690)
,p_chart_id=>wwv_flow_api.id(70610186996977694)
,p_seq=>10
,p_name=>'BTF Year'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select series , amount_from , amount_to , TCA_sector',
'from',
'(select ''Total'' Series ',
'    ,  nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0) amount_from  ',
'    , null amount_to',
'    , tca_sector',
'from btf_lines',
'where form_no in(select a.form_no  from btf_header a where a.year = EXTRACT(YEAR FROM sysdate))',
'and btf_lines.from_to = ''FROM''',
'and tca_sector in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                            and btf_data_access.user_id = :APP_USER)',
'GROUP by tca_sector',
'UNION all',
'select ''Total'' Series ',
'    ,  null amount_from  ',
'    , nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0) amount_to',
'    , tca_sector',
'from btf_lines',
'where form_no in(select a.form_no  from btf_header a where a.year = EXTRACT(YEAR FROM sysdate))',
'and btf_lines.from_to = ''TO''',
'and tca_sector in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                            and btf_data_access.user_id = :APP_USER)',
'GROUP by tca_sector)'))
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'AMOUNT_FROM'
,p_items_label_column_name=>'TCA_SECTOR'
,p_color=>'#0E6654'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(70613561600977690)
,p_chart_id=>wwv_flow_api.id(70610186996977694)
,p_seq=>20
,p_name=>'Approved'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Total'' Series ,  nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0) amount  , tca_sector',
'from btf_lines',
'where form_no in(select a.form_no  ',
'                  from btf_header a ',
'                  where a.year = EXTRACT(YEAR FROM sysdate)',
'                  and a.status = ''Approved'')',
'and tca_sector in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                            and btf_data_access.user_id = :APP_USER)',
'GROUP by tca_sector',
'order BY 1 desc'))
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'AMOUNT'
,p_items_label_column_name=>'TCA_SECTOR'
,p_color=>'#27A849'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(70611880147977691)
,p_chart_id=>wwv_flow_api.id(70610186996977694)
,p_seq=>30
,p_name=>'Rejected'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Total'' Series ,  nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0) amount  , tca_sector',
'from btf_lines',
'where form_no in(select a.form_no  ',
'                  from btf_header a ',
'                  where a.year = EXTRACT(YEAR FROM sysdate)',
'                  and a.status = ''Rejected'')',
'and tca_sector in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                            and btf_data_access.user_id = :APP_USER)',
'GROUP by tca_sector',
'order BY 1 desc'))
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'AMOUNT'
,p_items_label_column_name=>'TCA_SECTOR'
,p_color=>'#C72E2E'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(70612432624977690)
,p_chart_id=>wwv_flow_api.id(70610186996977694)
,p_seq=>40
,p_name=>'in-Progress'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Total'' Series ,  nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0) amount  , tca_sector',
'from btf_lines',
'where form_no in(select a.form_no  ',
'                  from btf_header a ',
'                  where a.year = EXTRACT(YEAR FROM sysdate)',
'                  and a.status = ''in-Progress'')',
'and tca_sector in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                            and btf_data_access.user_id = :APP_USER)',
'GROUP by tca_sector',
'order BY 1 desc'))
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'AMOUNT'
,p_items_label_column_name=>'TCA_SECTOR'
,p_color=>'#11BDA6'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(70610622257977693)
,p_chart_id=>wwv_flow_api.id(70610186996977694)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(70611233971977692)
,p_chart_id=>wwv_flow_api.id(70610186996977694)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(140968530359309487)
,p_plug_name=>'<b>Budget Transfers By Department</b>'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_ajax_items_to_submit=>'P20_FROM_TO'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'USER_ACCESS_DEPT'
,p_plug_display_when_cond2=>'Y'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(70614480869977689)
,p_region_id=>wwv_flow_api.id(140968530359309487)
,p_chart_type=>'bar'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'none'
,p_hover_behavior=>'none'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>false
,p_show_row=>false
,p_show_start=>false
,p_show_end=>false
,p_show_progress=>false
,p_show_baseline=>false
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>false
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(70616177544977688)
,p_chart_id=>wwv_flow_api.id(70614480869977689)
,p_seq=>10
,p_name=>'BTF Year'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Total'' Series ,  count(distinct form_no) , department',
'from btf_lines',
'where form_no in(select a.form_no  from btf_header a where a.year = EXTRACT(YEAR FROM sysdate))',
'and btf_lines.department in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''DEPARTMENT''',
'                                            and btf_data_access.user_id = :APP_USER)',
'and from_to = :FROM_TO                                               ',
'GROUP by department',
'order BY 1 desc'))
,p_ajax_items_to_submit=>'P20_FROM_TO'
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'COUNT(DISTINCTFORM_NO)'
,p_items_label_column_name=>'DEPARTMENT'
,p_color=>'#0E6654'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(70616731526977688)
,p_chart_id=>wwv_flow_api.id(70614480869977689)
,p_seq=>20
,p_name=>'Approved'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Approved'' Series ,  count(distinct form_no) , department',
'from btf_lines',
'where form_no in(select a.form_no  ',
'                  from btf_header a ',
'                  where a.year = EXTRACT(YEAR FROM sysdate)',
'                  and a.status = ''Approved'')',
'and from_to = :P20_FROM_TO                 ',
'and department in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''DEPARTMENT''',
'                                            and btf_data_access.user_id = :APP_USER)',
'GROUP by department',
'order BY 1 desc'))
,p_ajax_items_to_submit=>'P20_FROM_TO'
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'COUNT(DISTINCTFORM_NO)'
,p_items_label_column_name=>'DEPARTMENT'
,p_color=>'#27A849'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(70617383401977687)
,p_chart_id=>wwv_flow_api.id(70614480869977689)
,p_seq=>30
,p_name=>'Rejected'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Rejected'' Series ,  count(distinct form_no) , department',
'from btf_lines',
'where form_no in(select a.form_no  ',
'                  from btf_header a ',
'                  where a.year = EXTRACT(YEAR FROM sysdate)',
'                  and a.status = ''Rejected'')',
'and department in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''DEPARTMENT''',
'                                            and btf_data_access.user_id = :APP_USER)',
'and from_to = :FROM_TO                                               ',
'GROUP by DEPARTMENT',
'order BY 1 desc'))
,p_ajax_items_to_submit=>'P20_FROM_TO'
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'COUNT(DISTINCTFORM_NO)'
,p_items_label_column_name=>'DEPARTMENT'
,p_color=>'#C72E2E'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(70617998952977687)
,p_chart_id=>wwv_flow_api.id(70614480869977689)
,p_seq=>40
,p_name=>'in-Progress'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''in-Progress'' Series ,  count(distinct form_no) , Department',
'from btf_lines',
'where form_no in(select a.form_no  ',
'                  from btf_header a ',
'                  where a.year = EXTRACT(YEAR FROM sysdate)',
'                  and a.status = ''in-Progress'')',
'and Department in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''DEPARTMENT''',
'                                            and btf_data_access.user_id = :APP_USER)',
'and from_to = :FROM_TO                                               ',
'GROUP by Department',
'order BY 1 desc'))
,p_ajax_items_to_submit=>'P20_FROM_TO'
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'COUNT(DISTINCTFORM_NO)'
,p_items_label_column_name=>'DEPARTMENT'
,p_color=>'#11BDA6'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(70615565312977688)
,p_chart_id=>wwv_flow_api.id(70614480869977689)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_step=>2
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(70614921648977688)
,p_chart_id=>wwv_flow_api.id(70614480869977689)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70619248460977683)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(136232026410233649)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Transfer Request'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:21:&SESSION.:Direct:&DEBUG.:RP::'
,p_icon_css_classes=>'fa-plus'
,p_security_scheme=>wwv_flow_api.id(70305549671149387)
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70618503767977687)
,p_name=>'P20_FROM_TO'
,p_is_required=>true
,p_item_sequence=>5
,p_item_plug_id=>wwv_flow_api.id(140968530359309487)
,p_item_default=>'FROM'
,p_prompt=>'By Line'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:From;FROM,To;TO'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70624094843977679)
,p_name=>'P20_FROM_TO_S'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(137262899968084543)
,p_item_default=>'FROM'
,p_prompt=>'View By'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:From Lines;FROM,To Lines;TO'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70628433214977670)
,p_name=>'Refresh'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P20_FROM_TO'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70628954950977667)
,p_event_id=>wwv_flow_api.id(70628433214977670)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(140968530359309487)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70629312311977667)
,p_name=>'Refresh Sectors'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P20_FROM_TO_S'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70629803857977666)
,p_event_id=>wwv_flow_api.id(70629312311977667)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(137262899968084543)
);
wwv_flow_api.component_end;
end;
/
