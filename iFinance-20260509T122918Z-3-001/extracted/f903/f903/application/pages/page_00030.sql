prompt --application/pages/page_00030
begin
--   Manifest
--     PAGE: 00030
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
 p_id=>30
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'BTR FROM-TO Line Details'
,p_step_title=>'BTR FROM-TO Line Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Form-inputContainer input[type=text].showfocus, .t-Form-inputContainer select.showfocus,  .t-Form-inputContainer select.showfocus.selectlist ,.apex-item-text select.showfocus, .apex-item-select {',
'  background-color: #CEF6CE !important;',
'}',
'',
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
'#history .t-Region-header {',
'			background-color: #cae6e3;',
'			color:#000;',
'			}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>'(:P30_FINANCE_STATUS != ''Draft'' or :P30_STATUS != ''Draft'')'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200518145833'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6881325159805423)
,p_plug_name=>'<b>Pending Requests </b>'
,p_icon_css_classes=>'fa-pause fa-anim-flash fam-pause fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6880460522805414)
,p_plug_name=>'Pending Requests Report'
,p_parent_plug_id=>wwv_flow_api.id(6881325159805423)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'FUNC_BODY_RETURNING_SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P30_LINE_ID is null',
'then',
'return ''select form_no',
'        ,line_no',
'        ,updated_date',
'        ,justification',
'    , transferred_amount',
'    , (select h.finance_status',
'        from btf_header h',
'        where h.form_no = btf_lines.form_no) Finance_status',
'    ,  (select h.status',
'        from btf_header h',
'        where h.form_no = btf_lines.form_no) DOA_status',
'--    , btf_lines.tca_sector',
'--    , btf_lines.project_number',
'--    , btf_lines.project_name',
'--    ,btf_lines.task_number',
'--    ,btf_lines.cost_center',
'--    ,btf_lines.gl_account',
'from btf_lines',
'where project_number = :P30_PROJECT_NUMBER',
'and task_number = :P30_TASK_NUMBER',
'and cost_center = :P30_COST_CENTER_H',
'and gl_account = :P30_GL_ACCOUNT_H',
'and btf_lines.from_to = :P30_FROM_TO_X_1',
'and (select h.completed',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) = ''''N''''',
'and (select h.status',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) <> ''''Rejected''''',
'and (select h.finance_status',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) <> ''''Rejected''''    ',
'order by btf_lines.form_no'' ;',
'else ',
'',
'return    ''select form_no',
'        ,line_no',
'        ,updated_date',
'        ,justification',
'    , transferred_amount',
'    , (select h.finance_status',
'        from btf_header h',
'        where h.form_no = btf_lines.form_no) Finance_status',
'    ,  (select h.status',
'        from btf_header h',
'        where h.form_no = btf_lines.form_no) DOA_status',
'--    , btf_lines.tca_sector',
'--    , btf_lines.project_number',
'--    , btf_lines.project_name',
'--    ,btf_lines.task_number',
'--    ,btf_lines.cost_center',
'--    ,btf_lines.gl_account',
'from btf_lines',
'where project_number = :P30_PROJECT_NUMBER',
'and task_number = :P30_TASK_NUMBER',
'and cost_center = :P30_COST_CENTER_H',
'and gl_account = :P30_GL_ACCOUNT_H',
'and btf_lines.from_to = :P30_FROM_TO_X_1',
'and (select h.completed',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) = ''''N''''',
'and (select h.status',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) <> ''''Rejected''''',
'and (select h.finance_status',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) <> ''''Rejected''''',
'and line_id <> :P30_LINE_ID    ',
'order by btf_lines.form_no'' ;',
'',
'end if'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Pending Requests Report'
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
 p_id=>wwv_flow_api.id(6880588701805415)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>6880588701805415
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6880646197805416)
,p_db_column_name=>'FORM_NO'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Form No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6880730083805417)
,p_db_column_name=>'LINE_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Line No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6880881230805418)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6880920577805419)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6881028255805420)
,p_db_column_name=>'TRANSFERRED_AMOUNT'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Transferred Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6881159653805421)
,p_db_column_name=>'FINANCE_STATUS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Finance Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6881206912805422)
,p_db_column_name=>'DOA_STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'DOA Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(6946310747005023)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'69464'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FORM_NO:LINE_NO:JUSTIFICATION:TRANSFERRED_AMOUNT:FINANCE_STATUS:DOA_STATUS:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76702108486160216)
,p_plug_name=>'Budget Transfer Request Line Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(142476933196784258)
,p_plug_name=>'&P30_FORM_NO. - &P30_LINE_NO. Details'
,p_parent_plug_id=>wwv_flow_api.id(76702108486160216)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65519636948255743)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'BTF_LINES'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(142683260009855850)
,p_plug_name=>'Audit Info.'
,p_region_name=>'history'
,p_parent_plug_id=>wwv_flow_api.id(142476933196784258)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65530067520255748)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P30_LINE_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(142494938593784266)
,p_plug_name=>'Buttons'
,p_parent_plug_id=>wwv_flow_api.id(76702108486160216)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65520625267255744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(152727216909377713)
,p_plug_name=>'Select End User Budget Transfer Request'
,p_region_name=>'ig_req'
,p_parent_plug_id=>wwv_flow_api.id(76702108486160216)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    request_id,',
'    request_no,',
'    request_status,',
'    justification,',
'    from_to,',
'    tca_sector,',
'    department,',
'    project_number,',
'    task_number,',
'    cost_center,',
'    gl_account,',
'    budget,',
'    encumbrances,',
'    actual,',
'    requested_amount,',
'    balance_after,',
'    fund_available,',
'    form_no,',
'    line_no,',
'    created_by,',
'    updated_by,',
'    creation_date,',
'    updated_date,',
'    year,',
'    purpose_eu',
'FROM',
'    btf_end_users_req',
'where request_status = ''Accepted''',
'and from_to = :P30_FROM_TO',
'and tca_sector in (select a.entity_name',
'                    from btf_data_access a',
'                    where a.entity_type =''TCA_SECTOR''',
'                    and a.status = ''A''',
'                    and a.user_id = :APP_USER)'))
,p_plug_source_type=>'NATIVE_IG'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152617650491664418)
,p_name=>'APEX$ROW_ACTION'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152617721001664419)
,p_name=>'APEX$ROW_SELECTOR'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152729002060377715)
,p_name=>'REQUEST_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'REQUEST_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Request Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>40
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152729619387377715)
,p_name=>'REQUEST_NO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'REQUEST_NO'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Request No'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>50
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152730277330377715)
,p_name=>'REQUEST_STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'REQUEST_STATUS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Request Status'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>50
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152730856258377715)
,p_name=>'JUSTIFICATION'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'JUSTIFICATION'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Justification'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>2000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152731418321377716)
,p_name=>'FROM_TO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FROM_TO'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'From To'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>4
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152732083169377716)
,p_name=>'TCA_SECTOR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TCA_SECTOR'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Tca Sector'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>50
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152732683109377716)
,p_name=>'DEPARTMENT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEPARTMENT'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Department'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>100
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>255
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152733205946377716)
,p_name=>'PROJECT_NUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROJECT_NUMBER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Project Number'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>12
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152733793588377716)
,p_name=>'TASK_NUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TASK_NUMBER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Task Number'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>120
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>50
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152734476523377717)
,p_name=>'COST_CENTER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COST_CENTER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Cost Center'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>130
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>7
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152734986880377717)
,p_name=>'GL_ACCOUNT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GL_ACCOUNT'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Gl Account'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>140
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>6
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152735601090377717)
,p_name=>'BUDGET'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>150
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152736239155377717)
,p_name=>'ENCUMBRANCES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ENCUMBRANCES'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Encumbrances'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>160
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152736784624377718)
,p_name=>'ACTUAL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACTUAL'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Actual'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>170
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152737449561377718)
,p_name=>'REQUESTED_AMOUNT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'REQUESTED_AMOUNT'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Requested Amount'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>180
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152738026968377718)
,p_name=>'BALANCE_AFTER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BALANCE_AFTER'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Balance After'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>190
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152738648103377718)
,p_name=>'FUND_AVAILABLE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FUND_AVAILABLE'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Fund Available'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>200
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152739217698377719)
,p_name=>'FORM_NO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FORM_NO'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Form No'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>210
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>50
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152739877627377719)
,p_name=>'LINE_NO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LINE_NO'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Line No'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>220
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152740482677377719)
,p_name=>'CREATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_BY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Created By'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>230
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>50
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152740986926377719)
,p_name=>'UPDATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_BY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Updated By'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>240
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>50
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152741655405377720)
,p_name=>'CREATION_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATION_DATE'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Creation Date'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>250
,p_value_alignment=>'CENTER'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152742259335377720)
,p_name=>'UPDATED_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_DATE'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Updated Date'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>260
,p_value_alignment=>'CENTER'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152742877226377720)
,p_name=>'YEAR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'YEAR'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Year'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>270
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(152743461660377720)
,p_name=>'PURPOSE_EU'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PURPOSE_EU'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Purpose Eu'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>280
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
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
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(152727732772377714)
,p_internal_uid=>152727732772377714
,p_is_editable=>true
,p_lost_update_check_type=>'VALUES'
,p_submit_checked_rows=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_show_nulls_as=>'-'
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_toolbar_buttons=>null
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>false
,p_define_chart_view=>false
,p_enable_download=>true
,p_download_formats=>'CSV:HTML'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function (config)',
'{',
'  //No selected any row when the page is rendered',
'  config.initialSelection = false;',
'  //Begin - Creating one button, Favorite',
'  var $ = apex.jQuery,',
'    toolbarData = $.apex.interactiveGrid.copyDefaultToolbar(),',
'    toolbarGroup = toolbarData.toolbarFind( "actions3" );',
'',
'  toolbarGroup.controls.push(',
'  {',
'    type: "BUTTON",',
'    action: "favorite",',
'    icon: "fa fa-check fa-anim-flash fa-lg",',
'    iconBeforeLabel: true,',
'    hot: true,',
'  });',
'',
'  config.toolbarData = toolbarData;',
'  //End - Creating one button, Favorite  ',
'  config.initActions = function (actions)',
'  {',
'    // Defining the action for Favorite button',
'    actions.add(',
'    {',
'      name: "favorite",',
'      label: "Assign to Budget Transfer Request",',
'      action: favorite',
'    });',
'  }',
'',
'  function favorite(event, focusElement)',
'  {',
'    var i, records, model, record,',
'      view = apex.region("ig_req").widget().interactiveGrid("getCurrentView");',
'    var selectedIds = [];',
'    // if (view.supports.edit)',
'    // {',
'      model = view.model;',
'      records = view.getSelectedRecords();',
'      if (records.length > 0)',
'      {',
'        for (i = 0; i < records.length; i++)',
'        {',
'          record = records[i];            ',
'          selectedIds.push(records[i][0]);',
'        }',
'          // Invoke Ajax Callback Process',
'          apex.server.process ("ASSIGN_END_USER_REQ", ',
'                               {x01: JSON.stringify(selectedIds)},',
'                               {dataType: ''text'', ',
'                                success: function( pData )',
'                                {        ',
'                                    //Refresh IG - Favorite Employee (Optional)                                     ',
'                                    apex.region("ig_req").refresh();',
'                                }',
'                               }',
'                              );',
'        ',
'      }',
'    // }',
'  }',
'  return config;',
'}'))
);
wwv_flow_api.create_ig_report(
 p_id=>wwv_flow_api.id(152728146175377714)
,p_interactive_grid_id=>wwv_flow_api.id(152727732772377714)
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(152728230091377714)
,p_report_id=>wwv_flow_api.id(152728146175377714)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152729417637377715)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(152729002060377715)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152730032858377715)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>2
,p_column_id=>wwv_flow_api.id(152729619387377715)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152730644543377715)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(152730277330377715)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152731235219377716)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(152730856258377715)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152731843416377716)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(152731418321377716)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152732418004377716)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(152732083169377716)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152733078896377716)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(152732683109377716)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152733651158377716)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(152733205946377716)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152734218928377717)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>9
,p_column_id=>wwv_flow_api.id(152733793588377716)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152734827877377717)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(152734476523377717)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152735416823377717)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>11
,p_column_id=>wwv_flow_api.id(152734986880377717)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152736015993377717)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(152735601090377717)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152736664203377718)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>13
,p_column_id=>wwv_flow_api.id(152736239155377717)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152737197984377718)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>14
,p_column_id=>wwv_flow_api.id(152736784624377718)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152737805661377718)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>15
,p_column_id=>wwv_flow_api.id(152737449561377718)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152738394475377718)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>16
,p_column_id=>wwv_flow_api.id(152738026968377718)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152738999292377719)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>17
,p_column_id=>wwv_flow_api.id(152738648103377718)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152739596918377719)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>18
,p_column_id=>wwv_flow_api.id(152739217698377719)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152740210335377719)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>19
,p_column_id=>wwv_flow_api.id(152739877627377719)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152740876552377719)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>20
,p_column_id=>wwv_flow_api.id(152740482677377719)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152741405778377719)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>21
,p_column_id=>wwv_flow_api.id(152740986926377719)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152742035135377720)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>22
,p_column_id=>wwv_flow_api.id(152741655405377720)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152742611890377720)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>23
,p_column_id=>wwv_flow_api.id(152742259335377720)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152743187752377720)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>24
,p_column_id=>wwv_flow_api.id(152742877226377720)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152743875448377720)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>25
,p_column_id=>wwv_flow_api.id(152743461660377720)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(152745177611380840)
,p_view_id=>wwv_flow_api.id(152728230091377714)
,p_display_seq=>0
,p_column_id=>wwv_flow_api.id(152617650491664418)
,p_is_visible=>true
,p_is_frozen=>true
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(77422747462860810)
,p_plug_name=>'Pending'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:js-dialog-size720x480'
,p_plug_template=>wwv_flow_api.id(65539553967255751)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(77422846417860811)
,p_plug_name=>'Pending Report'
,p_parent_plug_id=>wwv_flow_api.id(77422747462860810)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'FUNC_BODY_RETURNING_SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P30_LINE_ID is null',
'then',
'return ''select form_no',
'        ,line_no',
'        ,updated_date',
'        ,justification',
'    , transferred_amount',
'    , (select h.finance_status',
'        from btf_header h',
'        where h.form_no = btf_lines.form_no) Finance_status',
'    ,  (select h.status',
'        from btf_header h',
'        where h.form_no = btf_lines.form_no) DOA_status',
'--    , btf_lines.tca_sector',
'--    , btf_lines.project_number',
'--    , btf_lines.project_name',
'--    ,btf_lines.task_number',
'--    ,btf_lines.cost_center',
'--    ,btf_lines.gl_account',
'from btf_lines',
'where project_number = :P30_PROJECT_NUMBER',
'and task_number = :P30_TASK_NUMBER',
'and cost_center = :P30_COST_CENTER_H',
'and gl_account = :P30_GL_ACCOUNT_H',
'and btf_lines.from_to = :P30_FROM_TO_X_1',
'and (select h.completed',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) = ''''N''''',
'and (select h.status',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) <> ''''Rejected''''',
'and (select h.finance_status',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) <> ''''Rejected''''    ',
'order by btf_lines.form_no'' ;',
'else ',
'',
'return    ''select form_no',
'        ,line_no',
'        ,updated_date',
'        ,justification',
'    , transferred_amount',
'    , (select h.finance_status',
'        from btf_header h',
'        where h.form_no = btf_lines.form_no) Finance_status',
'    ,  (select h.status',
'        from btf_header h',
'        where h.form_no = btf_lines.form_no) DOA_status',
'--    , btf_lines.tca_sector',
'--    , btf_lines.project_number',
'--    , btf_lines.project_name',
'--    ,btf_lines.task_number',
'--    ,btf_lines.cost_center',
'--    ,btf_lines.gl_account',
'from btf_lines',
'where project_number = :P30_PROJECT_NUMBER',
'and task_number = :P30_TASK_NUMBER',
'and cost_center = :P30_COST_CENTER_H',
'and gl_account = :P30_GL_ACCOUNT_H',
'and btf_lines.from_to = :P30_FROM_TO_X_1',
'and (select h.completed',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) = ''''N''''',
'and (select h.status',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) <> ''''Rejected''''',
'and (select h.finance_status',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) <> ''''Rejected''''',
'and line_id <> :P30_LINE_ID    ',
'order by btf_lines.form_no'' ;',
'',
'end if'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P30_PROJECT_NUMBER,P30_TASK_NUMBER,P30_COST_CENTER_H,P30_GL_ACCOUNT_H,P30_FROM_TO_X_1,P30_LINE_ID'
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
 p_id=>wwv_flow_api.id(77422978446860812)
,p_max_row_count=>'1000000'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>77422978446860812
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77423090512860813)
,p_db_column_name=>'FORM_NO'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Form No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77423174304860814)
,p_db_column_name=>'LINE_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Line No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77423281011860815)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77423395789860816)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77423492545860817)
,p_db_column_name=>'TRANSFERRED_AMOUNT'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77423505363860818)
,p_db_column_name=>'FINANCE_STATUS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Finance Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77423623011860819)
,p_db_column_name=>'DOA_STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'DOA Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(77455606673194763)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'774557'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FORM_NO:JUSTIFICATION:UPDATED_DATE:TRANSFERRED_AMOUNT:FINANCE_STATUS:DOA_STATUS:'
,p_sum_columns_on_break=>'TRANSFERRED_AMOUNT'
,p_count_distnt_col_on_break=>'FORM_NO'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(152721096212966855)
,p_plug_name=>'breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65554277731255756)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(65494572154255667)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(65602363670255785)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76792059827528269)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(142494938593784266)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:RP::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76792494459528269)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(142494938593784266)
,p_button_name=>'DELETE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--simple'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'(:P30_LINE_ID is not null and :P30_STATUS = ''Draft'' and :P30_FINANCE_STATUS = ''Draft'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76792890611528270)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(142494938593784266)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P30_LINE_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76793239022528270)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(142494938593784266)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P30_CREATION_DATE'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(76821228708528284)
,p_branch_name=>'Go To 9'
,p_branch_action=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:RP::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6880280645805412)
,p_name=>'P30_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(76702108486160216)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6880324938805413)
,p_name=>'P30_FINANCE_STATUS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(76702108486160216)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76702271469160217)
,p_name=>'P30_CREATE_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(76702108486160216)
,p_item_default=>'M'
,p_prompt=>'<b>Create Line By:  </b>'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:Manual;M,Import from Accepted End Users Requests;I'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'2'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76703130665160226)
,p_name=>'P30_FORM_NO_X'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(76702108486160216)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76703229096160227)
,p_name=>'P30_FROM_TO_X_1'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(76702108486160216)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76779583637528259)
,p_name=>'P30_LINE_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_source=>'LINE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76779935416528261)
,p_name=>'P30_FORM_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_source=>'FORM_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76780396732528261)
,p_name=>'P30_LINE_NO'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(*)+ 1',
'from btf_lines',
'where from_to = ''TO''',
'and form_no = :P30_FORM_NO'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Line No'
,p_source=>'LINE_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>5
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76780792433528261)
,p_name=>'P30_FROM_TO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'From / To'
,p_source=>'FROM_TO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:From (Deduct Budget);FROM,To (Additional Budget);TO'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76781122537528262)
,p_name=>'P30_PURPOSE_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Purpose'
,p_source=>'PURPOSE_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P30_FROM_TO = ''TO''',
'then',
'return ''select value d',
'     , value_id r',
'from dct_lookup_values',
'where status = ''''A''''',
'and lookup_id = (select lookup_id',
'from dct_lookups',
'where lookup_code = ''''PTARPEU'''')'' ;',
'else ',
'',
'return    ''select value d',
'     , value_id r',
'from dct_lookup_values',
'where status = ''''A''''',
'and lookup_id = (select lookup_id',
'from dct_lookups',
'where lookup_code = ''''PTDRPEU'''')'' ;',
'',
'end if'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P30_FROM_TO'
,p_ajax_items_to_submit=>'P30_FROM_TO'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76781576162528262)
,p_name=>'P30_TCA_SECTOR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Sector'
,p_source=>'TCA_SECTOR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P30_FROM_TO = ''TO''',
'then',
'return ''select distinct F_PROJECTBUDGET.TCA_SECTOR as TCA_SECTOR ',
'        , F_PROJECTBUDGET.TCA_SECTOR as D ',
' from F_PROJECTBUDGET F_PROJECTBUDGET'' ;',
'else ',
'',
'return    ''select distinct F_PROJECTBUDGET.TCA_SECTOR as TCA_SECTOR ',
'        , F_PROJECTBUDGET.TCA_SECTOR as D ',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where TCA_sector in (SELECT  btf_data_access.entity_name d',
'                FROM   btf_data_access',
'                WHERE btf_data_access.entity_type = ''''TCA_SECTOR''''',
'                    and btf_data_access.user_id = :APP_USER)'' ;',
'',
'end if'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76781983389528263)
,p_name=>'P30_DEPARTMENT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Department'
,p_source=>'DEPARTMENT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct department d',
'    , department r',
'from f_projectbudget',
'where tca_sector = :P30_TCA_SECTOR',
'and department is not null',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P30_TCA_SECTOR'
,p_ajax_items_to_submit=>'P30_TCA_SECTOR'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76782306596528263)
,p_name=>'P30_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Project Number'
,p_source=>'PROJECT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P30_FROM_TO_X_1 = ''TO''',
'then',
'return ''select distinct F_PROJECTBUDGET.PROJECT_NUMBER as PROJECT_NUMBER ',
'       , F_PROJECTBUDGET.PROJECT_NUMBER as r',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where tca_sector = :P30_TCA_SECTOR',
' and department = :P30_DEPARTMENT',
'order by 1'' ;',
'else ',
'',
'return    ''select distinct F_PROJECTBUDGET.PROJECT_NUMBER as PROJECT_NUMBER ',
'       , F_PROJECTBUDGET.PROJECT_NUMBER as r',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where tca_sector = :P30_TCA_SECTOR',
' and department = :P30_DEPARTMENT',
'  and fund_available > 0',
'order by 1'' ;',
'',
'end if'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P30_TCA_SECTOR,P30_DEPARTMENT'
,p_ajax_items_to_submit=>'P30_TCA_SECTOR,P30_DEPARTMENT'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76782724435528263)
,p_name=>'P30_PROJECT_NAME'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Project Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT project_name',
' from f_projectbudget',
' where project_number = :P30_PROJECT_NUMBER;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'I'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76783196355528263)
,p_name=>'P30_TASK_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Task Number'
,p_source=>'TASK_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' if :P30_FROM_TO = ''TO''',
'then',
'return ''SELECT distinct task_number d , ',
'        task_number r',
'FROM f_projectbudget ',
'where project_number = :P30_PROJECT_NUMBER',
'order by 1 '' ;',
'else ',
'',
'return    ''SELECT distinct task_number d , ',
'        task_number r',
'FROM f_projectbudget ',
'where project_number = :P30_PROJECT_NUMBER',
'and fund_available > 0',
'order by 1'' ;',
'',
'end if'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P30_PROJECT_NUMBER,P30_FROM_TO'
,p_ajax_items_to_submit=>'P30_FROM_TO,P30_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_help_text=>'only tasks with Budget and fund available balances. check the data from "Projects Data" Page.'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76784096118528264)
,p_name=>'P30_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Cost Center'
,p_source=>'COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>7
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76784473494528265)
,p_name=>'P30_COST_CENTER_NAME'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Cost Center Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT cc_name',
'from f_projectbudget',
'where task_number = :P30_TASK_NUMBER',
'and project_number = :P30_PROJECT_NUMBER'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76784808201528265)
,p_name=>'P30_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'GL Account'
,p_source=>'GL_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' if :P30_FROM_TO = ''TO''',
'then',
'return ''select  distinct natural_account d',
', natural_account r',
'from f_projectbudget',
'where project_number = :P30_PROJECT_NUMBER',
'and task_number = :P30_TASK_NUMBER'' ;',
'else ',
'',
'return    ''select  distinct natural_account d',
', natural_account r',
'from f_projectbudget',
'where project_number = :P30_PROJECT_NUMBER',
'and task_number = :P30_TASK_NUMBER',
'and fund_available > 0'' ;',
'end if'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P30_TASK_NUMBER,P30_PROJECT_NUMBER,P30_FROM_TO'
,p_ajax_items_to_submit=>'P30_PROJECT_NUMBER,P30_TASK_NUMBER,P30_FROM_TO'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_help_text=>'only GL Accounts with budget and fund available will display.'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
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
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76785767590528265)
,p_name=>'P30_GL_ACCOUNT_NAME'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'GL Account Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT account_name',
'from f_projectbudget',
'where natural_account = :P30_GL_ACCOUNT'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.NATURAL_ACCOUNT as d',
'       , F_PROJECTBUDGET.NATURAL_ACCOUNT as r',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :P30_PROJECT_NUMBER ',
' and   task_number    = :P30_TASK_NUMBER',
' and   budget         > 0'))
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76786145502528266)
,p_name=>'P30_BUDGET'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Budget'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BUDGET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76786549200528266)
,p_name=>'P30_ENCUMBRANCES'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Encumbrances'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ENCUMBRANCES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76786982849528266)
,p_name=>'P30_ACTUAL'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Actual'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ACTUAL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76787305185528266)
,p_name=>'P30_FUND_AVAILABLE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Fund Available'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'FUND_AVAILABLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76787765087528266)
,p_name=>'P30_FUND_AVAILABLE_H'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76788175007528266)
,p_name=>'P30_TRANSFERRED_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Requested Amount'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'TRANSFERRED_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76788514253528266)
,p_name=>'P30_BALANCE_AFTER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Balance After'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BALANCE_AFTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76788983475528266)
,p_name=>'P30_STRATEGIC'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_source=>'STRATEGIC'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76789340975528267)
,p_name=>'P30_PROGRAM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_source=>'PROGRAM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76789765867528267)
,p_name=>'P30_OUTPUT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_source=>'OUTPUT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76790187085528267)
,p_name=>'P30_JUSTIFICATION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Justification'
,p_source=>'JUSTIFICATION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>80
,p_cMaxlength=>1000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76790579044528267)
,p_name=>'P30_REQUEST_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_source=>'REQUEST_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76793925831528270)
,p_name=>'P30_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(142683260009855850)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76794389789528270)
,p_name=>'P30_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(142683260009855850)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Creation Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76794744136528270)
,p_name=>'P30_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(142683260009855850)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76795133531528271)
,p_name=>'P30_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(142683260009855850)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Updated Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76795569817528271)
,p_name=>'P30_SOURCE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(142683260009855850)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Source'
,p_source=>'SOURCE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76795980638528271)
,p_name=>'P30_END_USER_REQUEST'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(142683260009855850)
,p_prompt=>'End User Request#'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select request_no',
'from btf_end_users_req',
'where request_id = :P30_REQUEST_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(77356182841087625)
,p_name=>'P30_COST_CENTER_H'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(77422231726860805)
,p_name=>'P30_GL_ACCOUNT_H'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(77422394809860806)
,p_name=>'P30_PENDING'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(142476933196784258)
,p_item_source_plug_id=>wwv_flow_api.id(142476933196784258)
,p_prompt=>'Pending Transfer Amount'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'PENDING'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(76805164923528277)
,p_validation_name=>'P30_CREATION_DATE must be timestamp'
,p_validation_sequence=>150
,p_validation=>'P30_CREATION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(76794389789528270)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(76805510150528277)
,p_validation_name=>'P30_UPDATED_DATE must be timestamp'
,p_validation_sequence=>160
,p_validation=>'P30_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(76795133531528271)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76814780865528282)
,p_name=>'Task# Change'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_TASK_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76815731242528282)
,p_event_id=>wwv_flow_api.id(76814780865528282)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_COST_CENTER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76816238507528282)
,p_event_id=>wwv_flow_api.id(76814780865528282)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_COST_CENTER,P30_COST_CENTER_NAME,P30_COST_CENTER_H'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.COST_CENTER as COST_CENTER',
'       , cc_name',
'       ,COST_CENTER h',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :P30_PROJECT_NUMBER',
' and task_number = :P30_TASK_NUMBER;'))
,p_attribute_07=>'P30_TASK_NUMBER,P30_PROJECT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76815292456528282)
,p_event_id=>wwv_flow_api.id(76814780865528282)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_COST_CENTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76820252776528284)
,p_name=>'From TO Focus '
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_FROM_TO'
,p_condition_element=>'P30_FROM_TO'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76820730414528284)
,p_event_id=>wwv_flow_api.id(76820252776528284)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_PURPOSE_EU'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76805862542528277)
,p_name=>'Project# Change'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_PROJECT_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76806351322528278)
,p_event_id=>wwv_flow_api.id(76805862542528277)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_PROJECT_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.PROJECT_NAME as PROJECT_NAME ',
'    ',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :P30_PROJECT_NUMBER'))
,p_attribute_07=>'P30_PROJECT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76819344586528283)
,p_name=>'Clear Amount'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_FROM_TO'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76819858089528283)
,p_event_id=>wwv_flow_api.id(76819344586528283)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_TRANSFERRED_AMOUNT,P30_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76816693486528282)
,p_name=>'Disable'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_TASK_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76817118829528283)
,p_event_id=>wwv_flow_api.id(76816693486528282)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_COST_CENTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76813817911528282)
,p_name=>'Focus to GL Accoun'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_TASK_NUMBER'
,p_condition_element=>'P30_TASK_NUMBER'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76814365537528282)
,p_event_id=>wwv_flow_api.id(76813817911528282)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_GL_ACCOUNT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76817585048528283)
,p_name=>'Disable After Refresh'
,p_event_sequence=>50
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(142476933196784258)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76818068010528283)
,p_event_id=>wwv_flow_api.id(76817585048528283)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_COST_CENTER,P30_BUDGET,P30_ENCUMBRANCES,P30_ACTUAL,P30_FUND_AVAILABLE,P30_BALANCE_AFTER,P30_PENDING'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76818468911528283)
,p_name=>'Enable All'
,p_event_sequence=>60
,p_bind_type=>'bind'
,p_bind_event_type=>'apexbeforepagesubmit'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76818971132528283)
,p_event_id=>wwv_flow_api.id(76818468911528283)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_COST_CENTER,P30_BUDGET,P30_ENCUMBRANCES,P30_ACTUAL,P30_FUND_AVAILABLE,P30_BALANCE_AFTER,P30_PENDING'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76807637097528279)
,p_name=>'GL Account Changes'
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_GL_ACCOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76808188823528279)
,p_event_id=>wwv_flow_api.id(76807637097528279)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_BUDGET,P30_ENCUMBRANCES,P30_ACTUAL,P30_FUND_AVAILABLE,P30_COST_CENTER,P30_PENDING'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76808622491528279)
,p_event_id=>wwv_flow_api.id(76807637097528279)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_GL_ACCOUNT_NAME,P30_BUDGET,P30_ENCUMBRANCES,P30_ACTUAL,P30_FUND_AVAILABLE,P30_FUND_AVAILABLE_H,P30_GL_ACCOUNT_H'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  ACCOUNT_NAME',
'        , to_char(budget,''99,999,999.99'') budget',
'        , to_char(encumbrances,''99,999,999.99'') encumbrances',
'        , to_char(actual,''99,999,999.99'') actual  ',
'        , to_char(fund_available,''99,999,999.99'') fund_available',
'        , fund_available    fund_available_hidden',
'        ,natural_account',
'from f_projectbudget',
'where project_number = :P30_PROJECT_NUMBER',
'and task_number = :P30_TASK_NUMBER',
'and natural_account = :P30_GL_ACCOUNT',
'',
'',
'/*',
'select  ACCOUNT_NAME',
'        , budget',
'        , encumbrances',
'        , actual  ',
'        , fund_available',
'from f_projectbudget',
'where project_number = :P30_PROJECT_NUMBER',
'and task_number = :P30_TASK_NUMBER',
'and natural_account = :P30_GL_ACCOUNT',
'',
'*/'))
,p_attribute_07=>'P30_PROJECT_NUMBER,P30_TASK_NUMBER,P30_GL_ACCOUNT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77356052935087624)
,p_event_id=>wwv_flow_api.id(76807637097528279)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_PENDING'
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_pend number;',
'begin',
'if :P30_LINE_ID is null',
'',
'then',
'    select NVL(sum(transferred_amount),0)',
'    into l_pend',
'from btf_lines',
'where project_number = :P30_PROJECT_NUMBER',
'--and tca_sector       = :P30_TCA_SECTOR       ',
'and task_number      = :P30_TASK_NUMBER',
'and cost_center      = :P30_COST_CENTER_H',
'and gl_account       = :P30_GL_ACCOUNT',
'AND from_to          = :P30_FROM_TO_X_1',
'and (select h.completed',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) = ''N''',
'and (select h.status',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) <> ''Rejected''',
'and (select h.finance_status',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) <> ''Rejected''  ;',
'',
'else ',
'',
'select NVL(sum(transferred_amount),0)',
'into l_pend',
'from btf_lines',
'where project_number = :P30_PROJECT_NUMBER',
'--and tca_sector       = :P30_TCA_SECTOR       ',
'and task_number      = :P30_TASK_NUMBER',
'and cost_center      = :P30_COST_CENTER_H',
'and gl_account       = :P30_GL_ACCOUNT',
'AND from_to          = :P30_FROM_TO_X_1',
'and (select h.completed',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) = ''N''',
'and (select h.status',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) <> ''Rejected''',
'and (select h.finance_status',
'    from btf_header h',
'    where h.form_no = btf_lines.form_no) <> ''Rejected''',
'and line_id <> :P30_LINE_ID    ;',
'',
'end if;',
'',
'return l_pend;',
'',
'end;'))
,p_attribute_07=>'P30_PROJECT_NUMBER,P30_TASK_NUMBER,P30_COST_CENTER_H,P30_GL_ACCOUNT,P30_FROM_TO_X_1,P30_LINE_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76809162367528279)
,p_event_id=>wwv_flow_api.id(76807637097528279)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_BUDGET,P30_ENCUMBRANCES,P30_ACTUAL,P30_FUND_AVAILABLE,P30_COST_CENTER,P30_PENDING'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76809597403528279)
,p_name=>'Transfer Amount Change FROM'
,p_event_sequence=>90
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_TRANSFERRED_AMOUNT'
,p_condition_element=>'P30_FROM_TO_X_1'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'FROM'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76810012021528280)
,p_event_id=>wwv_flow_api.id(76809597403528279)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76810520024528280)
,p_event_id=>wwv_flow_api.id(76809597403528279)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_BALANCE_AFTER'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(  Number($v(''P30_FUND_AVAILABLE_H''))   - Number($v(''P30_TRANSFERRED_AMOUNT''))    -   Number($v(''P30_PENDING''))     ).toFixed(2);',
''))
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76811088151528280)
,p_event_id=>wwv_flow_api.id(76809597403528279)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(77192136513990534)
,p_name=>'Transfer Amount Change TO'
,p_event_sequence=>100
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_TRANSFERRED_AMOUNT'
,p_condition_element=>'P30_FROM_TO_X_1'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'TO'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77192220611990535)
,p_event_id=>wwv_flow_api.id(77192136513990534)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77192363626990536)
,p_event_id=>wwv_flow_api.id(77192136513990534)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_BALANCE_AFTER'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(',
'     Number($v(''P30_TRANSFERRED_AMOUNT'')) ',
'    + Number($v(''P30_FUND_AVAILABLE_H''))',
').toFixed(2);'))
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77192475548990537)
,p_event_id=>wwv_flow_api.id(77192136513990534)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76811451173528280)
,p_name=>'Delete BTF Line'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(76792494459528269)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76811930974528280)
,p_event_id=>wwv_flow_api.id(76811451173528280)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Would you like to delet Line &P30_LINE_NO. from Budget Transfer# &P30_FORM_NO.?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76812424547528281)
,p_event_id=>wwv_flow_api.id(76811451173528280)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DELETE',
'FROM btf_lines',
'where line_id = :P30_LINE_ID;',
'',
'if :P30_REQUEST_ID is not null',
'then',
'update btf_end_users_req',
'set form_no = '''' , request_status = ''Accepted''',
'where REQUEST_ID = :P30_REQUEST_ID;',
'end if;',
''))
,p_attribute_02=>'P30_LINE_ID,P30_REQUEST_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76812957271528281)
,p_event_id=>wwv_flow_api.id(76811451173528280)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Line &P30_LINE_NO. has been deleted successfully from Budget Transfer# &P30_FORM_NO.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76813426214528282)
,p_event_id=>wwv_flow_api.id(76811451173528280)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76806757567528278)
,p_name=>'Disable When Page Load'
,p_event_sequence=>120
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76807213204528279)
,p_event_id=>wwv_flow_api.id(76806757567528278)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76702382323160218)
,p_name=>'Show / Hide Line Details'
,p_event_sequence=>130
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_CREATE_FROM'
,p_condition_element=>'P30_CREATE_FROM'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'M'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76702487318160219)
,p_event_id=>wwv_flow_api.id(76702382323160218)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(142476933196784258)
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76702705012160222)
,p_event_id=>wwv_flow_api.id(76702382323160218)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(152727216909377713)
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76702559824160220)
,p_event_id=>wwv_flow_api.id(76702382323160218)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(152727216909377713)
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76702640643160221)
,p_event_id=>wwv_flow_api.id(76702382323160218)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(142476933196784258)
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77192632205990539)
,p_event_id=>wwv_flow_api.id(76702382323160218)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_SOURCE'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'Manual'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77192705679990540)
,p_event_id=>wwv_flow_api.id(76702382323160218)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_SOURCE'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'End User Project'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(77422545908860808)
,p_name=>'Open Pending'
,p_event_sequence=>150
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_PENDING'
,p_condition_element=>'P30_PENDING'
,p_triggering_condition_type=>'GREATER_THAN'
,p_triggering_expression=>'0'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
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
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77424390170860826)
,p_event_id=>wwv_flow_api.id(77422545908860808)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(77422747462860810)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77424447864860827)
,p_event_id=>wwv_flow_api.id(77422545908860808)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(77422846417860811)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(76791325561528268)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(142476933196784258)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Btf Line'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Budget Transfer Request &P30_FORM_NO. updated Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(76702986820160224)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(152727216909377713)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Add to Budget Transfer Request - Save Interactive Grid Data'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_process_error_message=>'Error while add End user request to BTR. Contact your system Admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'End user Request added to &P30_FORM_NO.Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(76790917513528267)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(142476933196784258)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Btf Line'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(76702845046160223)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'ASSIGN_END_USER_REQ'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BTF_WORKFLOW.INSERT_END_USER_REQ(p_selected_ids_json     => apex_application.g_x01 ',
'                                 , P_FORM_NO    => :P30_FORM_NO_X',
'                                 , P_FROM_TO    => :P30_FROM_TO_X_1);'))
,p_process_error_message=>'Error, While Add End User requests'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'End User Requests added Successfully.'
);
wwv_flow_api.component_end;
end;
/
