prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'Budget Transfer'
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
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200520121200'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7017446818736245)
,p_plug_name=>'BTR Finance Approval Status'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Draft'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':29:''||:APP_SESSION||''::NO:29:P29_FINANCE_STATUS:''|| ''Draft'' ) as link',
', BTF_WORKFLOW.form_amount_by_fin_status(''Draft'' , ''FROM'')|| '' AED'' Total_amount',
'from btf_header',
'where finance_status =  ''Draft''',
'and (btf_header.form_no in (select l.form_no ',
'                            from btf_lines l ',
'                            where l.form_no = btf_header.form_no ',
'                            and l.tca_sector in (SELECT  btf_data_access.entity_name d',
'                                                    FROM   btf_data_access',
'                                                    WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                                    and btf_data_access.user_id = :APP_USER))',
'or btf_header.sector in (SELECT  btf_data_access.entity_name d',
'                                                    FROM   btf_data_access',
'                                                    WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                                    and btf_data_access.user_id = :APP_USER))',
'UNION all',
'select ''in-Progress'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':29:''||:APP_SESSION||''::NO:29:P29_FINANCE_STATUS:''|| ''in-Progress'' ) as link',
', BTF_WORKFLOW.form_amount_by_fin_status(''in-Progress'' , ''FROM'')|| '' AED'' Total_amount',
'from btf_header',
'where finance_status =  ''in-Progress''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and form_no in (select l.form_no from btf_lines l where l.form_no = btf_header.form_no and l.tca_sector in (SELECT  btf_data_access.entity_name d',
'                FROM   btf_data_access',
'                WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                    and btf_data_access.user_id = :APP_USER))',
'UNION ALL',
'select ''Approved'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':29:''||:APP_SESSION||''::NO:29:P29_FINANCE_STATUS:''|| ''Approved'' ) as link',
', BTF_WORKFLOW.form_amount_by_fin_status(''Approved'' , ''FROM'') || '' AED'' Total_amount',
'from btf_header',
'where finance_status =  ''Approved''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and form_no in (select l.form_no from btf_lines l where l.form_no = btf_header.form_no and l.tca_sector in (SELECT  btf_data_access.entity_name d',
'                FROM   btf_data_access',
'                WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                    and btf_data_access.user_id = :APP_USER))',
'UNION all',
'select ''Rejected'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':29:''||:APP_SESSION||''::NO:29:P29_FINANCE_STATUS:''|| ''Rejected'' ) as link',
', BTF_WORKFLOW.form_amount_by_fin_status(''Rejected'' , ''FROM'')|| '' AED'' Total_amount',
'from btf_header',
'where finance_status =  ''Rejected''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and form_no in (select l.form_no from btf_lines l where l.form_no = btf_header.form_no and l.tca_sector in (SELECT  btf_data_access.entity_name d',
'                FROM   btf_data_access',
'                WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                    and btf_data_access.user_id = :APP_USER))',
''))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'TOTAL_AMOUNT'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'&LINK.'
,p_attribute_05=>'0'
,p_attribute_06=>'B'
,p_attribute_07=>'DOT'
,p_attribute_08=>'Y'
,p_attribute_09=>'LABLE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7280737042257414)
,p_plug_name=>'Transfer Requests Analysis'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>160
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7017670209736247)
,p_plug_name=>'Count of Transfer Requests By Purpose'
,p_parent_plug_id=>wwv_flow_api.id(7280737042257414)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select xx.count_request ',
'    , xx.total_amount ',
'    , xx.tca_sector ',
'    ,xx.from_to',
'    , (select v.value',
'         from dct_lookup_values v',
'              where v.value_id = xx.id) Purpose',
'from (SELECT',
'    count(line_id) count_request, ',
'    sum(transferred_amount) total_amount,',
'    from_to ,',
'    tca_sector, purpose_eu  id',
'FROM',
'    btf_lines ',
'group by from_to, tca_sector, purpose_eu) xx'))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_ajax_items_to_submit=>'P1_FROM_TO_PIE'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(7017718785736248)
,p_region_id=>wwv_flow_api.id(7017670209736247)
,p_chart_type=>'pie'
,p_title=>'Transfer Request Count By Purpose'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'on'
,p_legend_position=>'start'
,p_overview_rendered=>'off'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(7017813311736249)
,p_chart_id=>wwv_flow_api.id(7017718785736248)
,p_seq=>10
,p_name=>'Transfer Request Count By Purpose'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select xx.count_request ',
'    , xx.total_amount ',
'    , xx.tca_sector ',
'    ,xx.from_to',
'    , (select v.value',
'         from dct_lookup_values v',
'              where v.value_id = xx.id) Purpose',
'from (SELECT',
'    count(line_id) count_request, ',
'    sum(transferred_amount) total_amount,',
'    from_to ,',
'    tca_sector, purpose_eu  id',
'FROM',
'    btf_lines ',
'group by from_to, tca_sector, purpose_eu) xx',
'where xx.from_to = nvl(:P1_FROM_TO_PIE , xx.from_to)'))
,p_ajax_items_to_submit=>'P1_FROM_TO_PIE'
,p_items_value_column_name=>'COUNT_REQUEST'
,p_items_label_column_name=>'PURPOSE'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'COMBO'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7280095718257407)
,p_plug_name=>'Transfer Requests Amount By Purpose'
,p_parent_plug_id=>wwv_flow_api.id(7280737042257414)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select xx.count_request ',
'    , xx.total_amount ',
'    , xx.tca_sector ',
'    ,xx.from_to',
'    , (select v.value',
'         from dct_lookup_values v',
'              where v.value_id = xx.id) Purpose',
'from (SELECT',
'    count(line_id) count_request, ',
'    sum(transferred_amount) total_amount,',
'    from_to ,',
'    tca_sector, purpose_eu  id',
'FROM',
'    btf_lines ',
'group by from_to, tca_sector, purpose_eu) xx'))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_ajax_items_to_submit=>'P1_FROM_TO_PIE'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(7280207511257409)
,p_region_id=>wwv_flow_api.id(7280095718257407)
,p_chart_type=>'pie'
,p_title=>'Transfer Requests Amount By Purpose'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'on'
,p_legend_position=>'start'
,p_overview_rendered=>'off'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(7280347582257410)
,p_chart_id=>wwv_flow_api.id(7280207511257409)
,p_seq=>10
,p_name=>'Transfer Request Amount By Purpose'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select xx.count_request ',
'    , xx.total_amount ',
'    , xx.tca_sector ',
'    ,xx.from_to',
'    , (select v.value',
'         from dct_lookup_values v',
'              where v.value_id = xx.id) Purpose',
'from (SELECT',
'    count(line_id) count_request, ',
'    sum(transferred_amount) total_amount,',
'    from_to ,',
'    tca_sector, purpose_eu  id',
'FROM',
'    btf_lines ',
'group by from_to, tca_sector, purpose_eu) xx',
'where xx.from_to = nvl(:P1_FROM_TO_PIE , xx.from_to)'))
,p_ajax_items_to_submit=>'P1_FROM_TO_PIE'
,p_items_value_column_name=>'TOTAL_AMOUNT'
,p_items_label_column_name=>'PURPOSE'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'COMBO'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(65640899785255907)
,p_plug_name=>'<b>Budget Transfer - Home</b>'
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
 p_id=>wwv_flow_api.id(65743380025256041)
,p_plug_name=>'Page Navigation'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:u-colors:t-Cards--featured t-Cards--block force-fa-lg:t-Cards--displayIcons:t-Cards--spanHorizontally:t-Cards--hideBody:t-Cards--animColorFill'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>140
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(65742603533256041)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(65590504563255778)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(66672763819106811)
,p_name=>'<b>Recent Transfer Requests<b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select form_no',
'        , reason',
'        , finance_status',
'        , status',
'        , btf_workflow.get_form_last_upd_date(form_no) last_update',
'        ,(select e.full_name_en',
'            from dct_employees_list2 e',
'            where e.user_name = (select h.user_name',
'            from btf_approval_history h',
'            where h.form_no = btf_header.form_no',
'            and h.status = ''Pending''))Pending_with',
'from btf_header',
'where btf_header.sector in (SELECT  btf_data_access.entity_name d',
'                FROM   btf_data_access',
'                WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                    and btf_data_access.user_id = :APP_USER)',
'order by last_update desc'))
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
 p_id=>wwv_flow_api.id(66672873401106812)
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
 p_id=>wwv_flow_api.id(66673275289106816)
,p_query_column_id=>2
,p_column_alias=>'REASON'
,p_column_display_sequence=>2
,p_column_heading=>'Reason'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76333393574605001)
,p_query_column_id=>3
,p_column_alias=>'FINANCE_STATUS'
,p_column_display_sequence=>3
,p_column_heading=>'Finance Status'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66673424467106818)
,p_query_column_id=>4
,p_column_alias=>'STATUS'
,p_column_display_sequence=>4
,p_column_heading=>'DOA Status'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76333412051605002)
,p_query_column_id=>5
,p_column_alias=>'LAST_UPDATE'
,p_column_display_sequence=>6
,p_column_heading=>'Last Update'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66674155485106825)
,p_query_column_id=>6
,p_column_alias=>'PENDING_WITH'
,p_column_display_sequence=>5
,p_column_heading=>'Pending With'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(66675259744106836)
,p_name=>'Budget Team Pending List'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>130
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
 p_id=>wwv_flow_api.id(66675346207106837)
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
 p_id=>wwv_flow_api.id(66675420850106838)
,p_query_column_id=>2
,p_column_alias=>'REVISION_NO'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66675570749106839)
,p_query_column_id=>3
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>3
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66675698443106840)
,p_query_column_id=>4
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>4
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66675767534106841)
,p_query_column_id=>5
,p_column_alias=>'REASON'
,p_column_display_sequence=>5
,p_column_heading=>'Reason'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66675882756106842)
,p_query_column_id=>6
,p_column_alias=>'BTF_NO'
,p_column_display_sequence=>6
,p_column_heading=>'Btf No'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66675943251106843)
,p_query_column_id=>7
,p_column_alias=>'ORACLE_APPROVAL1'
,p_column_display_sequence=>7
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66676091499106844)
,p_query_column_id=>8
,p_column_alias=>'ORACLE_APPROVAL2'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66676129168106845)
,p_query_column_id=>9
,p_column_alias=>'ORACLE_HYPERION'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66676281923106846)
,p_query_column_id=>10
,p_column_alias=>'STATUS'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66676379885106847)
,p_query_column_id=>11
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66676442005106848)
,p_query_column_id=>12
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>12
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66676565650106849)
,p_query_column_id=>13
,p_column_alias=>'YEAR'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66676626376106850)
,p_query_column_id=>14
,p_column_alias=>'SECTOR'
,p_column_display_sequence=>14
,p_column_heading=>'Sector'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66745184157549001)
,p_query_column_id=>15
,p_column_alias=>'TOTAL_FROM'
,p_column_display_sequence=>15
,p_column_heading=>'Total From'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66745210403549002)
,p_query_column_id=>16
,p_column_alias=>'TOTAL_TO'
,p_column_display_sequence=>16
,p_column_heading=>'Total To'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66745366978549003)
,p_query_column_id=>17
,p_column_alias=>'PENDING_WITH'
,p_column_display_sequence=>17
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70269892857206627)
,p_plug_name=>'<b>Approval History</b>'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>150
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_required_role=>wwv_flow_api.id(70528602176145068)
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70269168868206620)
,p_plug_name=>'Approval History Table'
,p_parent_plug_id=>wwv_flow_api.id(70269892857206627)
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
' and status not in (''Future'' , ''Submitted'',''Pending'' )',
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
 p_id=>wwv_flow_api.id(70269218587206621)
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
,p_internal_uid=>70269218587206621
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70269385688206622)
,p_db_column_name=>'FORM_NO'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Form No'
,p_column_link=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:RP:P9_FORM_NO,P9_ID:#FORM_NO#,#ID#'
,p_column_linktext=>'#FORM_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70270313892206632)
,p_db_column_name=>'REASON'
,p_display_order=>20
,p_column_identifier=>'F'
,p_column_label=>'Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70269496782206623)
,p_db_column_name=>'STATUS'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70269535194206624)
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
 p_id=>wwv_flow_api.id(70269662956206625)
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
 p_id=>wwv_flow_api.id(70269785851206626)
,p_db_column_name=>'COMMENTS'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70374944309331720)
,p_db_column_name=>'ID'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(70284940295552426)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'702850'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FORM_NO:STATUS:RECEVIED_DATE:ACTION_DATE:COMMENTS:REASON:ID'
,p_sort_column_1=>'ACTION_DATE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(70377403734331745)
,p_plug_name=>'<b>Budget Transfers By Department</b>'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>120
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_ajax_items_to_submit=>'P1_FROM_TO_PIE'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'USER_ACCESS_DEPT'
,p_plug_display_when_cond2=>'Y'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(70377588713331746)
,p_region_id=>wwv_flow_api.id(70377403734331745)
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
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(70377671033331747)
,p_chart_id=>wwv_flow_api.id(70377588713331746)
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
,p_ajax_items_to_submit=>'P1_FROM_TO_PIE'
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'COUNT(DISTINCTFORM_NO)'
,p_items_label_column_name=>'DEPARTMENT'
,p_color=>'#0E6654'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
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
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(70377765707331748)
,p_chart_id=>wwv_flow_api.id(70377588713331746)
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
'and from_to = :P1_FROM_TO                 ',
'and department in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''DEPARTMENT''',
'                                            and btf_data_access.user_id = :APP_USER)',
'GROUP by department',
'order BY 1 desc'))
,p_ajax_items_to_submit=>'P1_FROM_TO_PIE'
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
 p_id=>wwv_flow_api.id(70377838912331749)
,p_chart_id=>wwv_flow_api.id(70377588713331746)
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
,p_ajax_items_to_submit=>'P1_FROM_TO_PIE'
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
 p_id=>wwv_flow_api.id(70377991265331750)
,p_chart_id=>wwv_flow_api.id(70377588713331746)
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
,p_ajax_items_to_submit=>'P1_FROM_TO_PIE'
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
 p_id=>wwv_flow_api.id(70533395863675002)
,p_chart_id=>wwv_flow_api.id(70377588713331746)
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
 p_id=>wwv_flow_api.id(70533252818675001)
,p_chart_id=>wwv_flow_api.id(70377588713331746)
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
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(76093301793459932)
,p_name=>'<b>Projects End Users Work List</b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>80
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Access Request'' as "Type"',
'       ,user_id as "from"',
'       ,''Request Access to '' ||',
'        lower(entity_type)  ||',
'        '' ''                 ||',
'        entity_name         ||',
'        '' for (''            ||',
'        (select full_name_en',
'            from dct_employees_list2',
'            where user_name = btf_data_access_requests.user_id) ||',
'         '')''   as Subject',
'       ,updated_on as "Received Date"',
'       ,priority        as "Priority"',
'       ,apex_util.prepare_url(''f?p=''',
'                          || :app_id',
'                          || '':27:''',
'                          || :app_session',
'                          || ''::NO::P27_ID:''',
'                          || id) AS link',
'from btf_data_access_requests',
'where request_status = ''Draft''',
'and (select distinct tca_sector',
'    from f_projectbudget',
'    where f_projectbudget.project_number = btf_data_access_requests.entity_name) in (SELECT  btf_data_access.entity_name d',
'                                                                                    FROM   btf_data_access',
'                                                                                    WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                                                                    and btf_data_access.user_id = :APP_USER)',
'',
'UNION ALL',
'',
'select  ''End User Budget Transfer'' Type',
'        , updated_by    as "from"',
'        , ''Budget Transfer Request for Project#'' ||',
'            project_number                       ||',
'            '' - Amount: ''                        ||',
'            to_char(requested_amount,''99,999,999.99'') ||',
'            '' AED''      as                              Subject',
'        , updated_date          as "Received Date"',
'        , priority              as "Priority"',
'        ,apex_util.prepare_url(''f?p=''',
'                          || :app_id',
'                          || '':24:''',
'                          || :app_session',
'                          || ''::NO::P24_REQUEST_ID:''',
'                          || request_id) AS link   ',
'from btf_end_users_req',
'where btf_end_users_req.tca_sector in (select entity_name',
'from btf_data_access',
'where entity_type = ''TCA_SECTOR''',
'and status = ''A''',
'and user_id = :APP_USER)',
'and request_status = ''Submitted''',
'',
'UNION ALL',
'',
'SELECT',
'    ''Budget Transfer Request''           as "Type",',
'    updated_by                          as "from",',
'    ''Approval Required for''     ||',
'    ''Form No. ''                 ||',
'     form_no                    ||',
'    '', Amount: ''                ||',
'    (select to_char(sum(l.transferred_amount),''99,999,999.99'') ',
'        from btf_lines l',
'        where l.form_no = btf_header.form_no',
'        and l.from_to = ''FROM'') ||',
'    '' AED''      as "Subject",',
'    (select recevied_date',
'        from btf_approval_history',
'        where form_no = btf_header.form_no',
'        and user_name = :APP_USER',
'        and status = ''Pending'') as "Received Date",',
'    priority        as "Priority",',
'    APEX_PAGE.GET_URL (',
'           p_application  => :app_id,',
'           p_session      => :app_session,',
'            p_page   => 12,',
'            p_items  => ''P12_FORM_NO'',',
'            p_values => form_no ) AS link',
'FROM',
'    btf_header',
'where form_no in (select a.form_no from btf_approval_history a where a.status = ''Pending'' and a.user_name = :APP_USER)    ;'))
,p_required_role=>wwv_flow_api.id(70305549671149387)
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
 p_id=>wwv_flow_api.id(76095110094459950)
,p_query_column_id=>1
,p_column_alias=>'Type'
,p_column_display_sequence=>1
,p_column_heading=>'Type'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76153239992095301)
,p_query_column_id=>2
,p_column_alias=>'from'
,p_column_display_sequence=>2
,p_column_heading=>'From'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76157614094095345)
,p_query_column_id=>3
,p_column_alias=>'SUBJECT'
,p_column_display_sequence=>3
,p_column_heading=>'Subject'
,p_use_as_row_header=>'N'
,p_column_link=>'#LINK#'
,p_column_linktext=>'#SUBJECT#'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76153440403095303)
,p_query_column_id=>4
,p_column_alias=>'Received Date'
,p_column_display_sequence=>4
,p_column_heading=>'Received Date'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76153504968095304)
,p_query_column_id=>5
,p_column_alias=>'Priority'
,p_column_display_sequence=>5
,p_column_heading=>'Priority'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76153624798095305)
,p_query_column_id=>6
,p_column_alias=>'LINK'
,p_column_display_sequence=>6
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76333519141605003)
,p_plug_name=>'<b>Budget Transfers  Count By Sector</b>'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>100
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
 p_id=>wwv_flow_api.id(76333787699605005)
,p_region_id=>wwv_flow_api.id(76333519141605003)
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
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(76333827375605006)
,p_chart_id=>wwv_flow_api.id(76333787699605005)
,p_seq=>10
,p_name=>'Addition By Sector'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Addition'' Series ,  count(distinct form_no) , tca_sector',
'from btf_lines',
'where form_no in(select a.form_no  from btf_header a where a.year = EXTRACT(YEAR FROM sysdate))',
'and tca_sector in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                            and btf_data_access.user_id = :APP_USER)',
'                                            ',
'and from_to = ''TO''',
'and (select h.status from btf_header h where h.form_no = btf_lines.form_no) = nvl(:P1_STATUS,(select h.status from btf_header h where h.form_no = btf_lines.form_no))',
'GROUP by tca_sector',
'order BY 1 desc ;'))
,p_ajax_items_to_submit=>'P1_STATUS'
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
 p_id=>wwv_flow_api.id(76333945360605007)
,p_chart_id=>wwv_flow_api.id(76333787699605005)
,p_seq=>20
,p_name=>'Deduction By Sector'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Deduction'' Series ,  count(distinct form_no) , tca_sector',
'from btf_lines',
'where form_no in(select a.form_no  from btf_header a where a.year = EXTRACT(YEAR FROM sysdate))',
'and tca_sector in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                            and btf_data_access.user_id = :APP_USER)',
'                                            ',
'and from_to = ''FROM''',
'and (select h.status from btf_header h where h.form_no = btf_lines.form_no) = nvl(:P1_STATUS,(select h.status from btf_header h where h.form_no = btf_lines.form_no))',
'GROUP by tca_sector',
'order BY 1 desc ;'))
,p_ajax_items_to_submit=>'P1_STATUS'
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'COUNT(DISTINCTFORM_NO)'
,p_items_label_column_name=>'TCA_SECTOR'
,p_color=>'#27A849'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(76334248585605010)
,p_chart_id=>wwv_flow_api.id(76333787699605005)
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
 p_id=>wwv_flow_api.id(76334384720605011)
,p_chart_id=>wwv_flow_api.id(76333787699605005)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76334603462605014)
,p_plug_name=>'<b>Budget Transfers Amount  By Sector</b>'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>110
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
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
 p_id=>wwv_flow_api.id(76334844453605016)
,p_region_id=>wwv_flow_api.id(76334603462605014)
,p_chart_type=>'bar'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'none'
,p_hover_behavior=>'dim'
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
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(76334992672605017)
,p_chart_id=>wwv_flow_api.id(76334844453605016)
,p_seq=>10
,p_name=>'Addition By Sector'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Addition'' Series ',
'    ,  round(sum(transferred_amount) / :P1_STATUS_AMOUNT_SCALE,1) Amount',
'    , tca_sector',
'    , ''Total Budget Additions By Sector'' tooltip',
'from btf_lines',
'where form_no in(select a.form_no  from btf_header a where a.year = EXTRACT(YEAR FROM sysdate))',
'and tca_sector in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                            and btf_data_access.user_id = :APP_USER)',
'                                            ',
'and from_to = ''TO''',
'and (select h.status from btf_header h where h.form_no = btf_lines.form_no) = nvl(:P1_STATUS,(select h.status from btf_header h where h.form_no = btf_lines.form_no))',
'GROUP by tca_sector',
'order BY 1 desc'))
,p_ajax_items_to_submit=>'P1_STATUS,P1_STATUS_AMOUNT_SCALE'
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'AMOUNT'
,p_group_short_desc_column_name=>'TOOLTIP'
,p_items_label_column_name=>'TCA_SECTOR'
,p_color=>'#0E6654'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(76335051849605018)
,p_chart_id=>wwv_flow_api.id(76334844453605016)
,p_seq=>20
,p_name=>'Deduction By Sector'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Deduction'' Series ,  round(sum(transferred_amount)/:P1_STATUS_AMOUNT_SCALE,1)  amount , tca_sector , ''Total Budget Deduction amount By Sector'' tooltip',
'from btf_lines',
'where form_no in(select a.form_no  from btf_header a where a.year = EXTRACT(YEAR FROM sysdate))',
'and tca_sector in (SELECT  btf_data_access.entity_name d',
'                                            FROM   btf_data_access',
'                                            WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                            and btf_data_access.user_id = :APP_USER)',
'                                            ',
'and from_to = ''FROM''',
'and (select h.status from btf_header h where h.form_no = btf_lines.form_no) = nvl(:P1_STATUS,(select h.status from btf_header h where h.form_no = btf_lines.form_no))',
'GROUP by tca_sector',
'order BY 1 desc ;'))
,p_ajax_items_to_submit=>'P1_STATUS,P1_STATUS_AMOUNT_SCALE'
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'AMOUNT'
,p_group_short_desc_column_name=>'TOOLTIP'
,p_items_label_column_name=>'TCA_SECTOR'
,p_color=>'#27A849'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(76335263031605020)
,p_chart_id=>wwv_flow_api.id(76334844453605016)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_title=>'Amount'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'top'
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
 p_id=>wwv_flow_api.id(76335104045605019)
,p_chart_id=>wwv_flow_api.id(76334844453605016)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76390809333025216)
,p_plug_name=>'BTR DOA Approval Status'
,p_region_name=>'badgeListCircular'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Draft'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':29:''||:APP_SESSION||''::NO:29:P29_STATUS:''|| ''Draft'' ) as link',
'    ,BTF_WORKFLOW.form_amount_by_status(''Draft'' , ''FROM'')|| '' AED'' Total_amoount',
'from btf_header',
'where status =  ''Draft''',
'and (btf_header.form_no in (select l.form_no ',
'                            from btf_lines l ',
'                            where l.form_no = btf_header.form_no ',
'                            and l.tca_sector in (SELECT  btf_data_access.entity_name d',
'                                                    FROM   btf_data_access',
'                                                    WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                                    and btf_data_access.user_id = :APP_USER))',
'or btf_header.sector in (SELECT  btf_data_access.entity_name d',
'                                                    FROM   btf_data_access',
'                                                    WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                                    and btf_data_access.user_id = :APP_USER))',
'UNION all',
'select ''Not Started'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':29:''||:APP_SESSION||''::NO:29:P29_STATUS:''|| ''Not Started'' ) as link',
',BTF_WORKFLOW.form_amount_by_status(''Not Started'' , ''FROM'')|| '' AED'' Total_amoount',
'from btf_header',
'where status =  ''Not Started''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and form_no in (select l.form_no from btf_lines l where l.form_no = btf_header.form_no and l.tca_sector in (SELECT  btf_data_access.entity_name d',
'                FROM   btf_data_access',
'                WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                    and btf_data_access.user_id = :APP_USER))',
'UNION all',
'select ''in-Progress'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':29:''||:APP_SESSION||''::NO:29:P29_STATUS:''|| ''in-Progress'' ) as link',
',BTF_WORKFLOW.form_amount_by_status(''in-Progress'' , ''FROM'')|| '' AED'' Total_amoount',
'from btf_header',
'where status =  ''in-Progress''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and form_no in (select l.form_no from btf_lines l where l.form_no = btf_header.form_no and l.tca_sector in (SELECT  btf_data_access.entity_name d',
'                FROM   btf_data_access',
'                WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                    and btf_data_access.user_id = :APP_USER))',
'UNION ALL',
'select ''Approved'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':29:''||:APP_SESSION||''::NO:29:P29_STATUS:''|| ''Approved'' ) as link',
',BTF_WORKFLOW.form_amount_by_status(''Approved'' , ''FROM'')|| '' AED'' Total_amoount',
'from btf_header',
'where status =  ''Approved''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and form_no in (select l.form_no from btf_lines l where l.form_no = btf_header.form_no and l.tca_sector in (SELECT  btf_data_access.entity_name d',
'                FROM   btf_data_access',
'                WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                    and btf_data_access.user_id = :APP_USER))',
'UNION all',
'select ''Rejected'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':29:''||:APP_SESSION||''::NO:29:P29_STATUS:''|| ''Rejected'' ) as link',
',BTF_WORKFLOW.form_amount_by_status(''Rejected'' , ''FROM'')|| '' AED'' Total_amoount',
'from btf_header',
'where status =  ''Rejected''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and form_no in (select l.form_no from btf_lines l where l.form_no = btf_header.form_no and l.tca_sector in (SELECT  btf_data_access.entity_name d',
'                FROM   btf_data_access',
'                WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                    and btf_data_access.user_id = :APP_USER))',
'UNION all',
'select ''Completed'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':29:''||:APP_SESSION||''::NO:29:P29_STATUS:''|| ''Completed'' ) as link',
',BTF_WORKFLOW.form_amount_by_status(''Completed'' , ''FROM'')|| '' AED'' Total_amoount',
'from btf_header',
'where status =  ''Completed''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and form_no in (select l.form_no from btf_lines l where l.form_no = btf_header.form_no and l.tca_sector in (SELECT  btf_data_access.entity_name d',
'                FROM   btf_data_access',
'                WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                    and btf_data_access.user_id = :APP_USER))'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_required_role=>'!'||wwv_flow_api.id(76610535612322773)
,p_attribute_01=>'TOTAL_AMOOUNT'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'&LINK.'
,p_attribute_05=>'0'
,p_attribute_06=>'B'
,p_attribute_07=>'DOT'
,p_attribute_08=>'Y'
,p_attribute_09=>'LABLE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76391287729025220)
,p_plug_name=>'Summary Status - End User'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Draft'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':33:''||:APP_SESSION||''::NO::P33_STATUS:''|| ''Draft'' ) as link',
'from btf_end_users_req',
'where btf_end_users_req.request_status =  ''Draft''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and project_number in (SELECT  btf_data_access.entity_name d',
'                                                            FROM   btf_data_access',
'                                                            WHERE btf_data_access.entity_type = ''PROJECT''',
'                                                            and btf_data_access.user_id = :APP_USER)',
'UNION All',
'select ''Submitted'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':33:''||:APP_SESSION||''::NO::P33_STATUS:''|| ''Submitted'' ) as link',
'from btf_end_users_req',
'where btf_end_users_req.request_status =  ''Submitted''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and project_number in (SELECT  btf_data_access.entity_name d',
'                                                            FROM   btf_data_access',
'                                                            WHERE btf_data_access.entity_type = ''PROJECT''',
'                                                            and btf_data_access.user_id = :APP_USER)',
'UNION All',
'select ''Accepted'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':33:''||:APP_SESSION||''::NO::P33_STATUS:''|| ''Accepted'' ) as link',
'from btf_end_users_req',
'where btf_end_users_req.request_status =  ''Accepted''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and project_number in (SELECT  btf_data_access.entity_name d',
'                                                            FROM   btf_data_access',
'                                                            WHERE btf_data_access.entity_type = ''PROJECT''',
'                                                            and btf_data_access.user_id = :APP_USER)',
'UNION all',
'select ''Refused'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':33:''||:APP_SESSION||''::NO::P33_STATUS:''|| ''Refused'' ) as link',
'from btf_end_users_req',
'where btf_end_users_req.request_status =  ''Refused''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and project_number in (SELECT  btf_data_access.entity_name d',
'                                                            FROM   btf_data_access',
'                                                            WHERE btf_data_access.entity_type = ''PROJECT''',
'                                                            and btf_data_access.user_id = :APP_USER)',
'UNION ALL',
'select ''In-Process'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':33:''||:APP_SESSION||''::NO::P33_STATUS:''|| ''In-Process'' ) as link',
'from btf_end_users_req',
'where btf_end_users_req.request_status =  ''In-Process''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and project_number in (SELECT  btf_data_access.entity_name d',
'                                                            FROM   btf_data_access',
'                                                            WHERE btf_data_access.entity_type = ''PROJECT''',
'                                                            and btf_data_access.user_id = :APP_USER)',
'UNION ALL',
'select ''Completed'' lable , Count(*) value , apex_util.prepare_url( ''f?p=''||:APP_ID||'':33:''||:APP_SESSION||''::NO::P33_STATUS:''|| ''Completed'' ) as link',
'from btf_end_users_req',
'where btf_end_users_req.request_status =  ''Completed''',
'and year = EXTRACT(YEAR FROM sysdate)',
'and project_number in (SELECT  btf_data_access.entity_name d',
'                                                            FROM   btf_data_access',
'                                                            WHERE btf_data_access.entity_type = ''PROJECT''',
'                                                            and btf_data_access.user_id = :APP_USER)'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_required_role=>wwv_flow_api.id(76610535612322773)
,p_attribute_01=>'LABLE'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'&LINK.'
,p_attribute_05=>'0'
,p_attribute_06=>'L'
,p_attribute_07=>'DOT'
,p_attribute_08=>'Y'
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
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(76899312945965948)
,p_name=>'<b>Budget Transfer Request  Work List</b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>90
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    form_no,',
'    ''Budget Transfer Request''           as "Type",',
'    (select e.full_name_en ',
'                    from dct_employees_list2 e',
'                    where e.user_name = updated_by)                         as "from",',
'    ''Approval Required for ''     ||',
'    ''Form No. ''                 ||',
'     form_no                    ||',
'    '', Amount: ''                ||',
'    (select to_char(sum(l.transferred_amount),''99,999,999.99'') ',
'        from btf_lines l',
'        where l.form_no = btf_header.form_no',
'        and l.from_to = ''FROM'') ||',
'    '' AED''      as "Subject",',
'    (select recevied_date',
'        from btf_approval_history',
'        where form_no = btf_header.form_no',
'        and user_name = :APP_USER',
'        and status = ''Pending'') as "Received Date",',
'    priority        as "Priority"',
'FROM',
'    btf_header',
'where form_no in (select a.form_no from btf_approval_history a where a.status = ''Pending'' and a.user_name = :APP_USER)    ;'))
,p_required_role=>wwv_flow_api.id(70528602176145068)
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
 p_id=>wwv_flow_api.id(77055388114629006)
,p_query_column_id=>1
,p_column_alias=>'FORM_NO'
,p_column_display_sequence=>6
,p_column_heading=>'Form No'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76899494046965949)
,p_query_column_id=>2
,p_column_alias=>'Type'
,p_column_display_sequence=>1
,p_column_heading=>'Type'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76899541292965950)
,p_query_column_id=>3
,p_column_alias=>'from'
,p_column_display_sequence=>2
,p_column_heading=>'From'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77055279819629005)
,p_query_column_id=>4
,p_column_alias=>'Subject'
,p_column_display_sequence=>3
,p_column_heading=>'Subject'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:RP:P12_FORM_NO:#FORM_NO#'
,p_column_linktext=>'#Subject#'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77054897435629001)
,p_query_column_id=>5
,p_column_alias=>'Received Date'
,p_column_display_sequence=>4
,p_column_heading=>'Received Date'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77054925620629002)
,p_query_column_id=>6
,p_column_alias=>'Priority'
,p_column_display_sequence=>5
,p_column_heading=>'Priority'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:RP:P12_FORM_NO:#FORM_NO#'
,p_column_linktext=>'#Priority#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(152725987288875361)
,p_name=>'<b>Recent Transfer Requests <b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>50
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    request_id  ,',
'  substr(priority,0,1) user_avatar,',
'  --''u-color-''|| ( ora_hash(updated_by,45) + 1 ) user_color,',
'  case PRIority ',
'    when ''High'' Then ''u-danger-bg''',
'    when ''Medium'' Then ''u-warning-bg''',
'    when ''Low''    Then ''u-success-bg''',
'    END user_color,',
'  ''REQ# '' || request_no || ''(AED'' || to_char(requested_amount,''999,999,99.99'')||'')''  user_name,',
'  btf_end_users_req.updated_date event_date,',
'  btf_end_users_req.request_status event_type,',
'  ''Project# :'' || btf_end_users_req.project_number || '' - Task:'' || btf_end_users_req.task_number event_title,',
'  ''Justification :'' || btf_end_users_req.justification  event_desc,',
'  case btf_end_users_req.request_status ',
'    when ''Draft'' then ''fa-stop-circle-o''',
'    when ''Accepted'' then ''fa fa-check-circle-o''         ',
'    when ''In-Process'' then ''fa-check-circle-o fa-anim-flash''',
'    when ''Refused'' then ''fa fa-exclamation-circle''',
'    when ''Submitted'' then ''fa fa-exclamation-triangle''',
'  end event_icon,',
'  case btf_end_users_req.request_status ',
'    when ''Draft'' then ''is-disabled''',
'    when ''Accepted'' then ''is-new''',
'    when ''In-Process'' then ''u-color-1-bg''',
'    when ''Refused'' then ''is-removed''',
'    when ''Submitted'' then ''is-updated''',
'  end event_status,',
' -- ''f?p=&APP_ID.:21:&APP_SESSION.::NO::P21_REQUEST_ID:''||request_id event_link',
'  apex_util.prepare_url( ''f?p=''||:APP_ID||'':23:''||:APP_SESSION||''::NO::P23_REQUEST_ID:''|| request_id ) event_link',
'from btf_end_users_req',
'where project_number in (SELECT  btf_data_access.entity_name d',
'                                                            FROM   btf_data_access',
'                                                            WHERE btf_data_access.entity_type = ''PROJECT''',
'                                                            and btf_data_access.user_id = :APP_USER)',
'order by updated_date desc'))
,p_required_role=>wwv_flow_api.id(76610535612322773)
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(65556509573255757)
,p_query_num_rows=>5
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'Y'
,p_csv_output_link_text=>'Download'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77123654407874950)
,p_query_column_id=>1
,p_column_alias=>'REQUEST_ID'
,p_column_display_sequence=>1
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:RP:P23_REQUEST_ID:\#REQUEST_ID#\'
,p_column_linktext=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77124033574874950)
,p_query_column_id=>2
,p_column_alias=>'USER_AVATAR'
,p_column_display_sequence=>2
,p_column_heading=>'User Avatar'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77124457493874950)
,p_query_column_id=>3
,p_column_alias=>'USER_COLOR'
,p_column_display_sequence=>3
,p_column_heading=>'User Color'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77124851450874950)
,p_query_column_id=>4
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>4
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77125243223874950)
,p_query_column_id=>5
,p_column_alias=>'EVENT_DATE'
,p_column_display_sequence=>5
,p_column_heading=>'Event Date'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77125615630874951)
,p_query_column_id=>6
,p_column_alias=>'EVENT_TYPE'
,p_column_display_sequence=>6
,p_column_heading=>'Event Type'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77126011702874951)
,p_query_column_id=>7
,p_column_alias=>'EVENT_TITLE'
,p_column_display_sequence=>7
,p_column_heading=>'Event Title'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77126462249874951)
,p_query_column_id=>8
,p_column_alias=>'EVENT_DESC'
,p_column_display_sequence=>8
,p_column_heading=>'Event Desc'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77126827893874951)
,p_query_column_id=>9
,p_column_alias=>'EVENT_ICON'
,p_column_display_sequence=>9
,p_column_heading=>'Event Icon'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77127239409874951)
,p_query_column_id=>10
,p_column_alias=>'EVENT_STATUS'
,p_column_display_sequence=>10
,p_column_heading=>'Event Status'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77127652092874951)
,p_query_column_id=>11
,p_column_alias=>'EVENT_LINK'
,p_column_display_sequence=>11
,p_column_heading=>'Event Link'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(153521189744913128)
,p_name=>'My Access Requests Status'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    user_id,',
'    (select e.full_name_en ',
'        from dct_employees_list2 e',
'        where e.user_name = btf_data_access_requests.user_id) Employee,',
'    entity_type,',
'    entity_name,',
'    (select distinct p.project_name ',
'        from f_projectbudget p',
'        where p.project_number = entity_name) Project_name,',
'    request_status,',
'    start_date,',
'    end_date,',
'    comments,',
'    created_on,',
'    created_by,',
'    updated_by,',
'    updated_on,',
'    priority,',
'    btf_data_access_requests.action_by,',
'    btf_data_access_requests.action_time,',
'    reviewer_note',
'FROM',
'    btf_data_access_requests',
'where created_by = :APP_USER',
'order by UPDATED_ON desc'))
,p_required_role=>wwv_flow_api.id(76610535612322773)
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(65567986443255766)
,p_query_num_rows=>5
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77128596428887892)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>1
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77128937381887892)
,p_query_column_id=>2
,p_column_alias=>'USER_ID'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77129341268887892)
,p_query_column_id=>3
,p_column_alias=>'EMPLOYEE'
,p_column_display_sequence=>3
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77129790260887892)
,p_query_column_id=>4
,p_column_alias=>'ENTITY_TYPE'
,p_column_display_sequence=>4
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77130120393887893)
,p_query_column_id=>5
,p_column_alias=>'ENTITY_NAME'
,p_column_display_sequence=>5
,p_column_heading=>'Project#'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:26:&SESSION.:user:&DEBUG.::P26_ID:#ID#'
,p_column_linktext=>'#ENTITY_NAME#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77130594317887893)
,p_query_column_id=>6
,p_column_alias=>'PROJECT_NAME'
,p_column_display_sequence=>6
,p_column_heading=>'Project Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77130927870887893)
,p_query_column_id=>7
,p_column_alias=>'REQUEST_STATUS'
,p_column_display_sequence=>15
,p_column_heading=>'Request Status'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77131355924887893)
,p_query_column_id=>8
,p_column_alias=>'START_DATE'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77131742392887894)
,p_query_column_id=>9
,p_column_alias=>'END_DATE'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77132170884887894)
,p_query_column_id=>10
,p_column_alias=>'COMMENTS'
,p_column_display_sequence=>7
,p_column_heading=>'Comment'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77132586904887894)
,p_query_column_id=>11
,p_column_alias=>'CREATED_ON'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77132942666887894)
,p_query_column_id=>12
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77133329822887894)
,p_query_column_id=>13
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>12
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77133790156887894)
,p_query_column_id=>14
,p_column_alias=>'UPDATED_ON'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77134148820887894)
,p_query_column_id=>15
,p_column_alias=>'PRIORITY'
,p_column_display_sequence=>14
,p_column_heading=>'Priority'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77134537728887895)
,p_query_column_id=>16
,p_column_alias=>'ACTION_BY'
,p_column_display_sequence=>16
,p_column_heading=>'Action By'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77134984549887895)
,p_query_column_id=>17
,p_column_alias=>'ACTION_TIME'
,p_column_display_sequence=>17
,p_column_heading=>'Action Time'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77135301007887895)
,p_query_column_id=>18
,p_column_alias=>'REVIEWER_NOTE'
,p_column_display_sequence=>18
,p_column_heading=>'Reviewer Note'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(77135744910887896)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(153521189744913128)
,p_button_name=>'New_DATA_ACCESS'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600261178255783)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Project Access'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(77137672918912690)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(152725987288875361)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600261178255783)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Transfer Request'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66672633654106810)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(65640899785255907)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Budget Transfer'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.:Direct:&DEBUG.:RP::'
,p_icon_css_classes=>'fa-plus'
,p_security_scheme=>wwv_flow_api.id(70305549671149387)
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(77058225353629035)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(65640899785255907)
,p_button_name=>'CREATE-EU'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Transfer Request'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23'
,p_security_scheme=>wwv_flow_api.id(76610535612322773)
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(77058306486629036)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(65640899785255907)
,p_button_name=>'New_DATA_ACCESS_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Project Access'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.:::'
,p_security_scheme=>wwv_flow_api.id(76610535612322773)
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7279577934257402)
,p_name=>'P1_FROM_TO_PIE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(7017670209736247)
,p_item_default=>'TO'
,p_prompt=>'Transfer Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Budget Addition;TO,Budget Deduction;FROM'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70533427185675003)
,p_name=>'P1_FROM_TO'
,p_is_required=>true
,p_item_sequence=>5
,p_item_plug_id=>wwv_flow_api.id(70377403734331745)
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
 p_id=>wwv_flow_api.id(76333694202605004)
,p_name=>'P1_STATUS'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(76333519141605003)
,p_prompt=>'View By '
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:Draft;Draft,in-Progress;in-Progress,Not Started;Not Started,Approved;Approved,Rejected;Rejected'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All Status'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76335560841605023)
,p_name=>'P1_STATUS_AMOUNT_SCALE'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(76334603462605014)
,p_item_default=>'1'
,p_prompt=>'Amount In'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Dirham;1,Thousand;1000,Million;1000000'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
,p_show_quick_picks=>'Y'
,p_quick_pick_label_01=>'Dirham'
,p_quick_pick_value_01=>'1'
,p_quick_pick_label_02=>'Thousand'
,p_quick_pick_value_02=>'1000'
,p_quick_pick_label_03=>'Million'
,p_quick_pick_value_03=>'1000000'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70533944689675008)
,p_name=>'Refresh Sectors'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_FROM_TO_S'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76334479024605012)
,p_name=>'Refresh Sector By Status'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_STATUS'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76334599525605013)
,p_event_id=>wwv_flow_api.id(76334479024605012)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(76333519141605003)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76336044716605028)
,p_event_id=>wwv_flow_api.id(76334479024605012)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(76334603462605014)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76335390648605021)
,p_name=>'Refresh Budget Amount By Sector'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_STATUS_AMOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76335452391605022)
,p_event_id=>wwv_flow_api.id(76335390648605021)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(76334603462605014)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76335635404605024)
,p_name=>'Refresh By Amount'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_STATUS_AMOUNT_SCALE'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76335746088605025)
,p_event_id=>wwv_flow_api.id(76335635404605024)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(76334603462605014)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1926968353906750)
,p_name=>'Show Notification'
,p_event_sequence=>60
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6879122797805401)
,p_event_id=>wwv_flow_api.id(1926968353906750)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'PLUGIN_APEX.NOTIFICATION'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{',
'    "refresh": 0,',
'    "mainIcon": "fa-bell",',
'    "mainIconColor": "white",',
'    "mainIconBackgroundColor": "rgba(70,70,70,0.9)",',
'    "mainIconBlinking": false,',
'    "counterBackgroundColor": "rgb(232, 55, 55 )",',
'    "counterFontColor": "white",',
'    "linkTargetBlank": false,',
'    "showAlways": false,',
'    "browserNotifications": {',
'        "enabled": true,',
'        "cutBodyTextAfter": 100,',
'        "link": false',
'    },',
'    "accept": {',
'        "color": "#44e55c",',
'        "icon": "fa-check"',
'    },',
'    "decline": {',
'        "color": "#b73a21",',
'        "icon": "fa-close"',
'    },',
'    "hideOnRefresh": true',
'}'))
,p_attribute_02=>'notification-menu'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    note_icon,',
'    note_icon_color,',
'    note_header,',
'    note_text,',
'    note_link,',
'    note_color,',
'    note_accept,',
'    note_decline,',
'    no_browser_notification',
'FROM',
'    btf_notifications;'))
,p_attribute_05=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7279674205257403)
,p_name=>'refresh pie on change'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_FROM_TO_PIE'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7279729778257404)
,p_event_id=>wwv_flow_api.id(7279674205257403)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(7017670209736247)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7280645061257413)
,p_event_id=>wwv_flow_api.id(7279674205257403)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(7280095718257407)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7280437688257411)
,p_name=>'refresh pie amount '
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_FROM_TO_AMOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7280562586257412)
,p_event_id=>wwv_flow_api.id(7280437688257411)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(7280095718257407)
);
wwv_flow_api.component_end;
end;
/
