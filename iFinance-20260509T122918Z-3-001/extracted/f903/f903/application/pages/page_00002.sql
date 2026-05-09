prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
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
 p_id=>2
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'Budget Transfer Requests'
,p_step_title=>'Budget Transfer Requests'
,p_allow_duplicate_submissions=>'N'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'ON'
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
'',
'',
''))
,p_step_template=>wwv_flow_api.id(65502230508255728)
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This report page displays primary records in a selector on the side of the page. ',
'  Select a record to see the master record and any detail records defined.<br> ',
'  Click the edit icon ( <span class="fa fa-pencil-square-o" aria-hidden="true"></span> ) to edit the master record.',
'  For detail records, click the pencil, at the beginning of each row, to edit that record.</p>',
'<p>To limit the data displayed in the selector enter a search term into the search dialog.</p>',
'',
'<p>To add a new master record click <strong>Create</strong> at the top of the page.',
'  For detail records, click the plus icon ( + ) at the top of the detail region to add a detail record.</p>',
'',
'<p>Click <strong>Reset</strong> at the top of the page to reset the page back to the default settings, removing any search term previously defined.</p>'))
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200216160215'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(65641807403255908)
,p_name=>'<b>Transfer Request Header </b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>10
,p_region_css_classes=>'js-master-region'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-AVPList--leftAligned'
,p_grid_column_span=>7
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select FORM_NO,',
'       REVISION_NO,',
'       CREATION_DATE,',
'       CREATED_BY,',
'       REASON,',
'       BTF_NO,',
'       STATUS,',
'       UPDATED_BY,',
'       UPDATED_DATE,',
'       YEAR,',
'       SECTOR',
'  from BTF_HEADER',
' where "FORM_NO" = :P2_FORM_NO'))
,p_display_when_condition=>'P2_FORM_NO'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(65562578975255763)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No Record Selected'
,p_query_row_count_max=>500
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65666835236255991)
,p_query_column_id=>1
,p_column_alias=>'FORM_NO'
,p_column_display_sequence=>1
,p_column_heading=>'Form No'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "FORM_NO" is not null',
'and "FORM_NO" = :P2_FORM_NO'))
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65667297696255991)
,p_query_column_id=>2
,p_column_alias=>'REVISION_NO'
,p_column_display_sequence=>3
,p_column_heading=>'Revision No'
,p_use_as_row_header=>'N'
,p_column_format=>'99G999G999G999G999G999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "REVISION_NO" is not null',
'and "FORM_NO" = :P2_FORM_NO'))
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65667632474255991)
,p_query_column_id=>3
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>4
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "CREATION_DATE" is not null',
'and "FORM_NO" = :P2_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65668080402255991)
,p_query_column_id=>4
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>5
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "CREATED_BY" is not null',
'and "FORM_NO" = :P2_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65668418363255991)
,p_query_column_id=>5
,p_column_alias=>'REASON'
,p_column_display_sequence=>6
,p_column_heading=>'Reason'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "REASON" is not null',
'and "FORM_NO" = :P2_FORM_NO'))
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65668890941255991)
,p_query_column_id=>6
,p_column_alias=>'BTF_NO'
,p_column_display_sequence=>2
,p_column_heading=>'BTF No'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "BTF_NO" is not null',
'and "FORM_NO" = :P2_FORM_NO'))
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65669244379255992)
,p_query_column_id=>7
,p_column_alias=>'STATUS'
,p_column_display_sequence=>7
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "STATUS" is not null',
'and "FORM_NO" = :P2_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65669696801255992)
,p_query_column_id=>8
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>8
,p_column_heading=>'Updated By'
,p_heading_alignment=>'LEFT'
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "UPDATED_BY" is not null',
'and "FORM_NO" = :P2_FORM_NO'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65670085058255992)
,p_query_column_id=>9
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "UPDATED_DATE" is not null',
'and "FORM_NO" = :P2_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65670462973255992)
,p_query_column_id=>10
,p_column_alias=>'YEAR'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "YEAR" is not null',
'and "FORM_NO" = :P2_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66033331742491849)
,p_query_column_id=>11
,p_column_alias=>'SECTOR'
,p_column_display_sequence=>11
,p_column_heading=>'Sector'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(65656589355255971)
,p_plug_name=>'Budget Transfer Requests'
,p_region_template_options=>'#DEFAULT#:t-HeroRegion--hideIcon'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(65537437145255750)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_query_type=>'SQL'
,p_plug_query_num_rows=>15
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(65657707721255972)
,p_plug_name=>'Search'
,p_region_css_classes=>'search-region padding-md'
,p_region_template_options=>'#DEFAULT#:t-Form--stretchInputs'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(65519636948255743)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_02'
,p_query_type=>'SQL'
,p_plug_query_num_rows=>15
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(65658549528255973)
,p_name=>'Master Records'
,p_template=>wwv_flow_api.id(65519824037255744)
,p_display_sequence=>20
,p_region_css_classes=>'search-results'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'t-MediaList--showDesc:t-MediaList--stack'
,p_display_point=>'REGION_POSITION_02'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select "FORM_NO",',
'    null link_class,',
'    apex_page.get_url(p_items => ''P2_FORM_NO'', p_values => "FORM_NO") link,',
'    null icon_class,',
'    null link_attr,',
'    null icon_color_class,',
'    case when nvl(:P2_FORM_NO,''0'') = "FORM_NO"',
'      then ''is-active'' ',
'      else '' ''',
'    end list_class,',
'    substr("FORM_NO", 1, 50)||( case when length("FORM_NO") > 50 then ''...'' end ) list_title,',
'    substr("BTF_NO", 1, 50)||( case when length("BTF_NO") > 50 then ''...'' end ) list_text,',
'    null list_badge',
'from "BTF_HEADER" x',
'where (:P2_SEARCH is null',
'        or upper(x."FORM_NO") like ''%''||upper(:P2_SEARCH)||''%''',
'        or upper(x."BTF_NO") like ''%''||upper(:P2_SEARCH)||''%''',
'    )',
'order by "FORM_NO"'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P2_SEARCH'
,p_query_row_template=>wwv_flow_api.id(65557135741255760)
,p_query_num_rows=>1000
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'<div class="u-tC">No Records Found</div>'
,p_query_row_count_max=>500
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65659253816255977)
,p_query_column_id=>1
,p_column_alias=>'FORM_NO'
,p_column_display_sequence=>1
,p_column_heading=>'Form No'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65659670971255979)
,p_query_column_id=>2
,p_column_alias=>'LINK_CLASS'
,p_column_display_sequence=>2
,p_column_heading=>'Link Class'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65660083398255979)
,p_query_column_id=>3
,p_column_alias=>'LINK'
,p_column_display_sequence=>3
,p_column_heading=>'Link'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65660442063255979)
,p_query_column_id=>4
,p_column_alias=>'ICON_CLASS'
,p_column_display_sequence=>4
,p_column_heading=>'Icon Class'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65660885677255979)
,p_query_column_id=>5
,p_column_alias=>'LINK_ATTR'
,p_column_display_sequence=>5
,p_column_heading=>'Link Attr'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65661261746255979)
,p_query_column_id=>6
,p_column_alias=>'ICON_COLOR_CLASS'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Color Class'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65661650067255980)
,p_query_column_id=>7
,p_column_alias=>'LIST_CLASS'
,p_column_display_sequence=>7
,p_column_heading=>'List Class'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65662075556255980)
,p_query_column_id=>8
,p_column_alias=>'LIST_TITLE'
,p_column_display_sequence=>8
,p_column_heading=>'List Title'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65662458708255980)
,p_query_column_id=>9
,p_column_alias=>'LIST_TEXT'
,p_column_display_sequence=>9
,p_column_heading=>'List Text'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(65662837003255980)
,p_query_column_id=>10
,p_column_alias=>'LIST_BADGE'
,p_column_display_sequence=>10
,p_column_heading=>'List Badge'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(65677521022255998)
,p_plug_name=>'Region Display Selector'
,p_region_css_classes=>'js-detail-rds'
,p_region_template_options=>'#DEFAULT#:margin-bottom-md'
,p_plug_template=>wwv_flow_api.id(65519636948255743)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_DISPLAY_SELECTOR'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P2_FORM_NO'
,p_attribute_01=>'STANDARD'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(65720830991256022)
,p_plug_name=>'No Record Selected'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65519636948255743)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_source=>'No Record Selected'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NULL'
,p_plug_display_when_condition=>'P2_FORM_NO'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(65952749999694620)
,p_plug_name=>'<b>From Lines</b>'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(65904519476327605)
,p_plug_name=>'From Lines Table'
,p_parent_plug_id=>wwv_flow_api.id(65952749999694620)
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>10
,p_plug_grid_column_css_classes=>'js-detail-region'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select BTF_LINES.LINE_ID as LINE_ID,',
'    BTF_LINES.FORM_NO as FORM_NO,',
'    BTF_LINES.LINE_NO as LINE_NO,',
'    BTF_LINES.FROM_TO as FROM_TO,',
'    BTF_LINES.PROJECT_NUMBER as PROJECT_NUMBER,',
'    BTF_LINES.PROJECT_NAME as PROJECT_NAME,',
'    BTF_LINES.TASK_NUMBER as TASK_NUMBER,',
'    BTF_LINES.COST_CENTER as COST_CENTER,',
'    BTF_LINES.GL_ACCOUNT as GL_ACCOUNT,',
'    BTF_LINES.BUDGET as BUDGET,',
'    BTF_LINES.ACTUAL as ACTUAL,',
'    BTF_LINES.encumbrances as ENCUMBRANCES,',
'    BTF_LINES.FUND_AVAILABLE as FUND_AVAILABLE,',
'    BTF_LINES.TRANSFERRED_AMOUNT as TRANSFERRED_AMOUNT,',
'    BTF_LINES.BALANCE_AFTER as BALANCE_AFTER,',
'    BTF_LINES.CREATED_BY as CREATED_BY,',
'    BTF_LINES.UPDATED_BY as UPDATED_BY,',
'    BTF_LINES.CREATION_DATE as CREATION_DATE,',
'    BTF_LINES.UPDATED_DATE as UPDATED_DATE,',
'    BTF_LINES.TCA_SECTOR as TCA_SECTOR,',
'    BTF_LINES.DEPARTMENT as DEPARTMENT,',
'    BTF_LINES.STRATEGIC as STRATEGIC ',
' from BTF_LINES BTF_LINES',
' where FORM_NO = :P2_FORM_NO',
'  and  BTF_LINES.from_to = ''FROM'''))
,p_plug_source_type=>'NATIVE_IG'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P2_FORM_NO'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65907246177327632)
,p_name=>'LINE_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LINE_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Line Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>30
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
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65907309305327633)
,p_name=>'FORM_NO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FORM_NO'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Form No'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>true
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
,p_is_primary_key=>false
,p_default_type=>'ITEM'
,p_default_expression=>'P2_FORM_NO'
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65907493043327634)
,p_name=>'LINE_NO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LINE_NO'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'No'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65907567555327635)
,p_name=>'FROM_TO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FROM_TO'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'From To'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
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
,p_is_primary_key=>false
,p_default_type=>'STATIC'
,p_default_expression=>'FROM'
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65907656902327636)
,p_name=>'PROJECT_NUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROJECT_NUMBER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_POPUP_LOV'
,p_heading=>'Project'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_04=>'N'
,p_is_required=>false
,p_max_length=>12
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.PROJECT_NUMBER as PROJECT_NUMBER ',
'       , F_PROJECTBUDGET.PROJECT_NUMBER as r',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where tca_sector = :TCA_SECTOR'))
,p_lov_display_extra=>false
,p_lov_display_null=>true
,p_lov_cascade_parent_items=>'TCA_SECTOR'
,p_ajax_optimize_refresh=>true
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65907736198327637)
,p_name=>'PROJECT_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROJECT_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Project Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65907879458327638)
,p_name=>'TASK_NUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TASK_NUMBER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Task'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>100
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.TASK_NUMBER as TASK_NUMBER ',
'    , F_PROJECTBUDGET.TASK_NUMBER as d',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :PROJECT_NUMBER',
' order by 1'))
,p_lov_display_extra=>false
,p_lov_display_null=>true
,p_lov_cascade_parent_items=>'PROJECT_NUMBER'
,p_ajax_items_to_submit=>'TASK_NUMBER'
,p_ajax_optimize_refresh=>true
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65907905709327639)
,p_name=>'COST_CENTER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COST_CENTER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Cost Center'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>110
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65908061296327640)
,p_name=>'GL_ACCOUNT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GL_ACCOUNT'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'GL Account'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>120
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.NATURAL_ACCOUNT as d',
'       , F_PROJECTBUDGET.NATURAL_ACCOUNT as r',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :PROJECT_NUMBER ',
' and   task_number    = :TASK_NUMBER',
' and   budget         > 0'))
,p_lov_display_extra=>false
,p_lov_display_null=>true
,p_lov_cascade_parent_items=>'TASK_NUMBER,PROJECT_NUMBER'
,p_ajax_items_to_submit=>'GL_ACCOUNT'
,p_ajax_optimize_refresh=>true
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65908178463327641)
,p_name=>'BUDGET'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>230
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_format_mask=>'999G999G999G999G990D00PR'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65908204177327642)
,p_name=>'FUND_AVAILABLE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FUND_AVAILABLE'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Fund Available'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>260
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_format_mask=>'999G999G999G999G990D00PR'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65908377706327643)
,p_name=>'TRANSFERRED_AMOUNT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TRANSFERRED_AMOUNT'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Transferred Amount'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>270
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_format_mask=>'999G999G999G999G990D00PR'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65908433415327644)
,p_name=>'BALANCE_AFTER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BALANCE_AFTER'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Balance After'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>280
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_format_mask=>'999G999G999G999G990D00PR'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65908597276327645)
,p_name=>'CREATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_BY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Created By'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>170
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65908656703327646)
,p_name=>'UPDATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_BY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Updated By'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>180
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65908777250327647)
,p_name=>'CREATION_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATION_DATE'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Creation Date'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>190
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65908839175327648)
,p_name=>'UPDATED_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_DATE'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Updated Date'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>200
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65908971767327649)
,p_name=>'TCA_SECTOR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TCA_SECTOR'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Sector'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.TCA_SECTOR as TCA_SECTOR',
'        , F_PROJECTBUDGET.TCA_SECTOR as r',
' from F_PROJECTBUDGET F_PROJECTBUDGET'))
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65909071427327650)
,p_name=>'DEPARTMENT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEPARTMENT'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Department'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>210
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
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65950875587694601)
,p_name=>'STRATEGIC'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STRATEGIC'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Strategic'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>220
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65950905240694602)
,p_name=>'APEX$ROW_ACTION'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65951044047694603)
,p_name=>'APEX$ROW_SELECTOR'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65951870791694611)
,p_name=>'ACTUAL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACTUAL'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Actual'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>240
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_format_mask=>'999G999G999G999G990D00PR'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(65952191620694614)
,p_name=>'ENCUMBRANCES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ENCUMBRANCES'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Encumbrances'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>250
,p_value_alignment=>'RIGHT'
,p_attribute_03=>'right'
,p_format_mask=>'999G999G999G999G990D00PR'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(65907166178327631)
,p_internal_uid=>65907166178327631
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_add_row_if_empty=>false
,p_submit_checked_rows=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>false
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_toolbar_buttons=>'ACTIONS_MENU:SAVE'
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
);
wwv_flow_api.create_ig_report(
 p_id=>wwv_flow_api.id(65957059684697057)
,p_interactive_grid_id=>wwv_flow_api.id(65907166178327631)
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>false
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(65957116991697058)
,p_report_id=>wwv_flow_api.id(65957059684697057)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65957657535697062)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>0
,p_column_id=>wwv_flow_api.id(65907246177327632)
,p_is_visible=>false
,p_is_frozen=>true
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65958192844697066)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>2
,p_column_id=>wwv_flow_api.id(65907309305327633)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>211
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65958652063697068)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(65907493043327634)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>40
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65959143444697069)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(65907567555327635)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>64
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65959640392697071)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(65907656902327636)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>124
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65960145191697072)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(65907736198327637)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>174
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65960631417697073)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(65907879458327638)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>113
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65961178679697074)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>11
,p_column_id=>wwv_flow_api.id(65907905709327639)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>89
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65961611426697075)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(65908061296327640)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>85
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65962134256697076)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>13
,p_column_id=>wwv_flow_api.id(65908178463327641)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>83
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65962645320697078)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>16
,p_column_id=>wwv_flow_api.id(65908204177327642)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>122
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65963115716697079)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>17
,p_column_id=>wwv_flow_api.id(65908377706327643)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>131
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65963640862697080)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>18
,p_column_id=>wwv_flow_api.id(65908433415327644)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>112
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65964174339697081)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>19
,p_column_id=>wwv_flow_api.id(65908597276327645)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65964689773697082)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>20
,p_column_id=>wwv_flow_api.id(65908656703327646)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65965160247697083)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>21
,p_column_id=>wwv_flow_api.id(65908777250327647)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65965617404697084)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>22
,p_column_id=>wwv_flow_api.id(65908839175327648)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65966138588697085)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(65908971767327649)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>122
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65966634285697086)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>9
,p_column_id=>wwv_flow_api.id(65909071427327650)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>166
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65967100866697087)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>22
,p_column_id=>wwv_flow_api.id(65950875587694601)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>124
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65968513683703582)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>1
,p_column_id=>wwv_flow_api.id(65950905240694602)
,p_is_visible=>true
,p_is_frozen=>true
,p_width=>40
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65988441185917315)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>14
,p_column_id=>wwv_flow_api.id(65951870791694611)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>101
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(65994993791299905)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_display_seq=>15
,p_column_id=>wwv_flow_api.id(65952191620694614)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>119
);
wwv_flow_api.create_ig_report_aggregate(
 p_id=>wwv_flow_api.id(28266000000)
,p_view_id=>wwv_flow_api.id(65957116991697058)
,p_function=>'SUM'
,p_column_id=>wwv_flow_api.id(65908377706327643)
,p_show_grand_total=>false
,p_is_enabled=>true
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(65953085329694623)
,p_plug_name=>'<b>Request Summary </b>'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(66030303701491819)
,p_plug_name=>'<b><font color="black">Audit Info</font></b>'
,p_region_name=>'history'
,p_parent_plug_id=>wwv_flow_api.id(65953085329694623)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65530067520255748)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(65953193876694624)
,p_plug_name=>'<b>To Lines</>'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(66229751646393242)
,p_plug_name=>'To Lines Table'
,p_parent_plug_id=>wwv_flow_api.id(65953193876694624)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_LINES.LINE_ID as LINE_ID,',
'    BTF_LINES.FORM_NO as FORM_NO,',
'    BTF_LINES.LINE_NO as LINE_NO,',
'    BTF_LINES.FROM_TO as FROM_TO,',
'    BTF_LINES.PROJECT_NUMBER as PROJECT_NUMBER,',
'    BTF_LINES.PROJECT_NAME as PROJECT_NAME,',
'    BTF_LINES.TASK_NUMBER as TASK_NUMBER,',
'    BTF_LINES.COST_CENTER as COST_CENTER,',
'    BTF_LINES.GL_ACCOUNT as GL_ACCOUNT,',
'    BTF_LINES.BUDGET as BUDGET,',
'    BTF_LINES.FUND_AVAILABLE as FUND_AVAILABLE,',
'    BTF_LINES.TRANSFERRED_AMOUNT as TRANSFERRED_AMOUNT,',
'    BTF_LINES.BALANCE_AFTER as BALANCE_AFTER,',
'    BTF_LINES.CREATED_BY as CREATED_BY,',
'    BTF_LINES.UPDATED_BY as UPDATED_BY,',
'    BTF_LINES.CREATION_DATE as CREATION_DATE,',
'    BTF_LINES.UPDATED_DATE as UPDATED_DATE,',
'    BTF_LINES.TCA_SECTOR as TCA_SECTOR,',
'    BTF_LINES.DEPARTMENT as DEPARTMENT,',
'    BTF_LINES.STRATEGIC as STRATEGIC ,',
'    BTF_LINES.ACTUAL as ACTUAL,',
'    BTF_LINES.ENCUMBRANCES as ENCUMBRANCES',
' from BTF_LINES BTF_LINES',
' where  BTF_LINES.FORM_NO = :P2_FORM_NO',
' and BTF_LINES.FROM_TO = ''TO'''))
,p_plug_source_type=>'NATIVE_IG'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66229991815393244)
,p_name=>'LINE_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LINE_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Line Id'
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
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66230017663393245)
,p_name=>'FORM_NO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FORM_NO'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Form No'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>true
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
,p_is_primary_key=>false
,p_default_type=>'ITEM'
,p_default_expression=>'P2_FORM_NO'
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66230183466393246)
,p_name=>'LINE_NO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LINE_NO'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'No'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>60
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66230299352393247)
,p_name=>'FROM_TO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FROM_TO'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'From To'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>30
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
,p_is_primary_key=>false
,p_default_type=>'STATIC'
,p_default_expression=>'TO'
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66230342911393248)
,p_name=>'PROJECT_NUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROJECT_NUMBER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_POPUP_LOV'
,p_heading=>'Project'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_04=>'N'
,p_is_required=>false
,p_max_length=>12
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.PROJECT_NUMBER as PROJECT_NUMBER ',
'       , F_PROJECTBUDGET.PROJECT_NUMBER as r',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where tca_sector = :TCA_SECTOR'))
,p_lov_display_extra=>false
,p_lov_display_null=>true
,p_lov_cascade_parent_items=>'TCA_SECTOR'
,p_ajax_optimize_refresh=>true
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66230457670393249)
,p_name=>'PROJECT_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROJECT_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Project Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66230575582393250)
,p_name=>'TASK_NUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TASK_NUMBER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Task'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>100
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.TASK_NUMBER as TASK_NUMBER ',
'    , F_PROJECTBUDGET.TASK_NUMBER as d',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :PROJECT_NUMBER',
' order by 1'))
,p_lov_display_extra=>false
,p_lov_display_null=>true
,p_lov_cascade_parent_items=>'PROJECT_NUMBER'
,p_ajax_items_to_submit=>'TASK_NUMBER'
,p_ajax_optimize_refresh=>true
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66305352518207201)
,p_name=>'COST_CENTER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COST_CENTER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Cost Center'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66305470984207202)
,p_name=>'GL_ACCOUNT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GL_ACCOUNT'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'GL Account'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>120
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.NATURAL_ACCOUNT as d',
'       , F_PROJECTBUDGET.NATURAL_ACCOUNT as r',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :PROJECT_NUMBER ',
' and   task_number    = :TASK_NUMBER'))
,p_lov_display_extra=>false
,p_lov_display_null=>true
,p_lov_cascade_parent_items=>'TASK_NUMBER,PROJECT_NUMBER'
,p_ajax_items_to_submit=>'GL_ACCOUNT'
,p_ajax_optimize_refresh=>true
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66305555973207203)
,p_name=>'BUDGET'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BUDGET'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Budget'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>130
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66305608166207204)
,p_name=>'FUND_AVAILABLE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FUND_AVAILABLE'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Fund Available'
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66305799403207205)
,p_name=>'TRANSFERRED_AMOUNT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TRANSFERRED_AMOUNT'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Transferred Amount'
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66305801913207206)
,p_name=>'BALANCE_AFTER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BALANCE_AFTER'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Balance After'
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66305995779207207)
,p_name=>'CREATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_BY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Created By'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>220
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66306091561207208)
,p_name=>'UPDATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_BY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Updated By'
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66306154248207209)
,p_name=>'CREATION_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATION_DATE'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Creation Date'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>230
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66306210834207210)
,p_name=>'UPDATED_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_DATE'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Updated Date'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>240
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66306319267207211)
,p_name=>'TCA_SECTOR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TCA_SECTOR'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Sector'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.TCA_SECTOR as TCA_SECTOR',
'        , F_PROJECTBUDGET.TCA_SECTOR as r',
' from F_PROJECTBUDGET F_PROJECTBUDGET'))
,p_lov_display_extra=>false
,p_lov_display_null=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66306422626207212)
,p_name=>'DEPARTMENT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEPARTMENT'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Department'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>190
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66306505146207213)
,p_name=>'STRATEGIC'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STRATEGIC'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Strategic'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>200
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66306653317207214)
,p_name=>'APEX$ROW_ACTION'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66306770507207215)
,p_name=>'APEX$ROW_SELECTOR'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66307558417207223)
,p_name=>'ACTUAL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACTUAL'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Actual'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>140
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_region_column(
 p_id=>wwv_flow_api.id(66307616690207224)
,p_name=>'ENCUMBRANCES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ENCUMBRANCES'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Encumbrances'
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_api.create_interactive_grid(
 p_id=>wwv_flow_api.id(66229887471393243)
,p_internal_uid=>66229887471393243
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_add_row_if_empty=>true
,p_submit_checked_rows=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_show_nulls_as=>'-'
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_download_formats=>'CSV:HTML'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_api.create_ig_report(
 p_id=>wwv_flow_api.id(66310945460207458)
,p_interactive_grid_id=>wwv_flow_api.id(66229887471393243)
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_api.create_ig_report_view(
 p_id=>wwv_flow_api.id(66311021043207458)
,p_report_id=>wwv_flow_api.id(66310945460207458)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
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
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66311524224207463)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>2
,p_column_id=>wwv_flow_api.id(66229991815393244)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66312010296207469)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>6
,p_column_id=>wwv_flow_api.id(66230017663393245)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>163.55
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66312518167207471)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>3
,p_column_id=>wwv_flow_api.id(66230183466393246)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>48.55
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66313008605207472)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>7
,p_column_id=>wwv_flow_api.id(66230299352393247)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66313586315207474)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>5
,p_column_id=>wwv_flow_api.id(66230342911393248)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>103.9667
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66314071694207475)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>8
,p_column_id=>wwv_flow_api.id(66230457670393249)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66314500627207476)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>10
,p_column_id=>wwv_flow_api.id(66230575582393250)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>168.45
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66315079374207477)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>11
,p_column_id=>wwv_flow_api.id(66305352518207201)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>81.0833
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66315598522207478)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>12
,p_column_id=>wwv_flow_api.id(66305470984207202)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>84.083
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66316028412207480)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>13
,p_column_id=>wwv_flow_api.id(66305555973207203)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66316515650207481)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>16
,p_column_id=>wwv_flow_api.id(66305608166207204)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>105.0833
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66317025289207482)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>17
,p_column_id=>wwv_flow_api.id(66305799403207205)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>134.0833
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66317542679207483)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>18
,p_column_id=>wwv_flow_api.id(66305801913207206)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66318005594207485)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>19
,p_column_id=>wwv_flow_api.id(66305995779207207)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66318509636207487)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>20
,p_column_id=>wwv_flow_api.id(66306091561207208)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66319093070207488)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>21
,p_column_id=>wwv_flow_api.id(66306154248207209)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66319523922207489)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>22
,p_column_id=>wwv_flow_api.id(66306210834207210)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66320000430207490)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>4
,p_column_id=>wwv_flow_api.id(66306319267207211)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>119.817
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66320588723207491)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>9
,p_column_id=>wwv_flow_api.id(66306422626207212)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>96.44999999999999
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66321017159207492)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>23
,p_column_id=>wwv_flow_api.id(66306505146207213)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66322277836209785)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>0
,p_column_id=>wwv_flow_api.id(66306653317207214)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66345806026081350)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>14
,p_column_id=>wwv_flow_api.id(66307558417207223)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_api.create_ig_report_column(
 p_id=>wwv_flow_api.id(66347417334086432)
,p_view_id=>wwv_flow_api.id(66311021043207458)
,p_display_seq=>15
,p_column_id=>wwv_flow_api.id(66307616690207224)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>106.6833
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(66030853784491824)
,p_plug_name=>'<b>Documents</b>'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(66031242700491828)
,p_plug_name=>'Documents Table'
,p_parent_plug_id=>wwv_flow_api.id(66030853784491824)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       FORM_NO,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       TAGS,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from BTF_DOCUMENTS',
' where form_no = :P2_FORM_NO',
' order by created desc',
''))
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
 p_id=>wwv_flow_api.id(66031345625491829)
,p_max_row_count=>'1000000'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>66031345625491829
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66031456772491830)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66031545353491831)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66031693560491832)
,p_db_column_name=>'FORM_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Form No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66031776136491833)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Filename'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66031805986491834)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66031926478491835)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66032020869491836)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'OTHER'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66032137315491837)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'File Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66032233391491838)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66032339749491839)
,p_db_column_name=>'CREATED'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66032448685491840)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66032582577491841)
,p_db_column_name=>'UPDATED'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66032651688491842)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66032738366491843)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66032847889491844)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:BTF_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(66110436549621497)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'661105'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:TAGS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(66030943213491825)
,p_plug_name=>'<b>Approval History</b>'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P2_STATUS'
,p_plug_display_when_cond2=>'Draft'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(66227925331393224)
,p_name=>'Approval History Report'
,p_parent_plug_id=>wwv_flow_api.id(66030943213491825)
,p_template=>wwv_flow_api.id(65519636948255743)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'BTF_APPROVAL_HISTORY'
,p_query_where=>'form_no = :P2_FORM_NO'
,p_include_rowid_column=>false
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
 p_id=>wwv_flow_api.id(66228014821393225)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>1
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66228162539393226)
,p_query_column_id=>2
,p_column_alias=>'FORM_NO'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66228257839393227)
,p_query_column_id=>3
,p_column_alias=>'STEP_NO'
,p_column_display_sequence=>3
,p_column_heading=>'No'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66228366341393228)
,p_query_column_id=>4
,p_column_alias=>'POSITION'
,p_column_display_sequence=>4
,p_column_heading=>'Position'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66228448145393229)
,p_query_column_id=>5
,p_column_alias=>'ENTITY_TYPE'
,p_column_display_sequence=>5
,p_column_heading=>'Entity Type'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66228572066393230)
,p_query_column_id=>6
,p_column_alias=>'ENTITY_NAME'
,p_column_display_sequence=>6
,p_column_heading=>'Entity Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66228681993393231)
,p_query_column_id=>7
,p_column_alias=>'ACTION_REQUIRED'
,p_column_display_sequence=>7
,p_column_heading=>'Action Required'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66228748337393232)
,p_query_column_id=>8
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>8
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66228805766393233)
,p_query_column_id=>9
,p_column_alias=>'STATUS'
,p_column_display_sequence=>9
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66228946554393234)
,p_query_column_id=>10
,p_column_alias=>'RECEVIED_DATE'
,p_column_display_sequence=>10
,p_column_heading=>'Recevied Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66229084814393235)
,p_query_column_id=>11
,p_column_alias=>'ACTION_DATE'
,p_column_display_sequence=>11
,p_column_heading=>'Action Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66229197701393236)
,p_query_column_id=>12
,p_column_alias=>'COMMENTS'
,p_column_display_sequence=>12
,p_column_heading=>'Comments'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66229249486393237)
,p_query_column_id=>13
,p_column_alias=>'CREATED_ON'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66229352413393238)
,p_query_column_id=>14
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>14
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66229414337393239)
,p_query_column_id=>15
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>15
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66229585151393240)
,p_query_column_id=>16
,p_column_alias=>'UPDATED_ON'
,p_column_display_sequence=>16
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(65657026657255972)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(65656589355255971)
,p_button_name=>'RESET'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft:t-Button--gapRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_image_alt=>'Reset'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.:RESET:&DEBUG.:RP,2::'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(65904675253327606)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(65952749999694620)
,p_button_name=>'POP_BTF_LINES_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(65600261178255783)
,p_button_image_alt=>'Add Transfer From Line'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:RP,4:P4_FORM_NO:&P2_FORM_NO.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(65953347913694626)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(65953193876694624)
,p_button_name=>'POP_TO_BTF_LINES'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(65600261178255783)
,p_button_image_alt=>'Add Transfer To Line'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:RP,4:P4_FORM_NO:&P2_FORM_NO.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66031195293491827)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(66030853784491824)
,p_button_name=>'Add_file'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600261178255783)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add File'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:RP,6:P6_FORM_NO:&P2_FORM_NO.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(65721376695256023)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(65641807403255908)
,p_button_name=>'EDIT'
,p_button_static_id=>'edit_master_btn'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_image_alt=>'Edit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:RP,3:P3_FORM_NO:&P2_FORM_NO.'
,p_icon_css_classes=>'fa-pencil-square-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(65657417319255972)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(65656589355255971)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Transfer Request'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:RP,3::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66033175727491847)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(65656589355255971)
,p_button_name=>'SUBMIT'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P2_STATUS'
,p_button_condition2=>'Draft'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65658102263255973)
,p_name=>'P2_SEARCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(65657707721255972)
,p_prompt=>'Search'
,p_placeholder=>'Search...'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(65599784231255783)
,p_item_icon_css_classes=>'fa-search'
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large:t-Form-fieldContainer--postTextBlock'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65677176567255997)
,p_name=>'P2_FORM_NO'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(65641807403255908)
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65952890248694621)
,p_name=>'P2_TOTAL_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(65953085329694623)
,p_prompt=>'From'
,p_format_mask=>'999G999G999G999G990D00PR'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66029944722491815)
,p_name=>'P2_TOTAL_TO_AMOUNT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(65953085329694623)
,p_prompt=>'To'
,p_format_mask=>'999G999G999G999G990D00PR'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66030162531491817)
,p_name=>'P2_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(65953085329694623)
,p_item_default=>'Draft'
,p_prompt=>'Status'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.STATUS as STATUS ',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P2_FORM_NO'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66030497052491820)
,p_name=>'P2_CREATED_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(66030303701491819)
,p_prompt=>'Created By'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.CREATED_BY as CREATED_BY ',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P2_FORM_NO'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66030591299491821)
,p_name=>'P2_CREATED_ON'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(66030303701491819)
,p_prompt=>'Created ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.CREATION_DATE as CREATION_DATE',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P2_FORM_NO'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66030689976491822)
,p_name=>'P2_UPDATED_BY'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(66030303701491819)
,p_prompt=>'Updated By'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.UPDATED_BY as UPDATED_BY',
'from BTF_HEADER BTF_HEADER',
' where form_no = :P2_FORM_NO'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66030778141491823)
,p_name=>'P2_UPDATED_ON'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(66030303701491819)
,p_prompt=>'Updated ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.UPDATED_DATE as UPDATED_DATE',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P2_FORM_NO'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(65952985472694622)
,p_computation_sequence=>10
,p_computation_item=>'P2_TOTAL_FROM'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0) as TRANSFERRED_AMOUNT ',
' from BTF_LINES BTF_LINES',
'where FoRM_NO = :P2_FORM_NO',
'and from_to = ''FROM'''))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(66030031138491816)
,p_computation_sequence=>20
,p_computation_item=>'P2_TOTAL_TO_AMOUNT'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0) as TRANSFERRED_AMOUNT ',
' from BTF_LINES BTF_LINES',
'where FoRM_NO = :P2_FORM_NO',
'and from_to = ''TO'''))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(66033202813491848)
,p_computation_sequence=>30
,p_computation_item=>'P2_STATUS'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.STATUS as STATUS ',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P2_FORM_NO'))
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(66028689185491802)
,p_tabular_form_region_id=>wwv_flow_api.id(65904519476327605)
,p_validation_name=>'transfered amount not greater than fund'
,p_validation_sequence=>10
,p_validation=>'nvl(:FUND_AVAILABLE,0) <  nvl(:TRANSFERRED_AMOUNT,0)'
,p_validation_type=>'SQL_EXPRESSION'
,p_error_message=>'#COLUMN_HEADER# can''t exceed fund available'
,p_associated_column=>'TRANSFERRED_AMOUNT'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(65721651950256023)
,p_name=>'Edit Master Record'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(65641807403255908)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(65722298717256023)
,p_event_id=>wwv_flow_api.id(65721651950256023)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(65641807403255908)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(65722780882256023)
,p_event_id=>wwv_flow_api.id(65721651950256023)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(''Btf\u0020Header\u0020updated'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(65721775964256023)
,p_name=>'Perform Search'
,p_event_sequence=>150
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_SEARCH'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === apex.jQuery.ui.keyCode.ENTER'
,p_bind_type=>'bind'
,p_bind_event_type=>'keypress'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(65723507386256024)
,p_event_id=>wwv_flow_api.id(65721775964256023)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(65658549528255973)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(65724089025256024)
,p_event_id=>wwv_flow_api.id(65721775964256023)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CANCEL_EVENT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(65951405012694607)
,p_name=>'Set Project Name'
,p_event_sequence=>160
,p_triggering_element_type=>'COLUMN'
,p_triggering_region_id=>wwv_flow_api.id(65904519476327605)
,p_triggering_element=>'PROJECT_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(65951589303694608)
,p_event_id=>wwv_flow_api.id(65951405012694607)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'COLUMN'
,p_affected_elements=>'PROJECT_NAME,DEPARTMENT'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.PROJECT_NAME as PROJECT_NAME ',
'        ,DEPARTMENT as DEPARTMENT',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :PROJECT_NUMBER'))
,p_attribute_07=>'PROJECT_NUMBER,DEPARTMENT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(65951650376694609)
,p_name=>'select task'
,p_event_sequence=>170
,p_triggering_element_type=>'COLUMN'
,p_triggering_region_id=>wwv_flow_api.id(65904519476327605)
,p_triggering_element=>'TASK_NUMBER'
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
 p_id=>wwv_flow_api.id(65951794958694610)
,p_event_id=>wwv_flow_api.id(65951650376694609)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'COLUMN'
,p_affected_elements=>'COST_CENTER'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.COST_CENTER as COST_CENTER',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :PROJECT_NUMBER',
' and task_number = :TASK_NUMBER'))
,p_attribute_07=>'PROJECT_NUMBER,TASK_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(65952208830694615)
,p_name=>'get balances'
,p_event_sequence=>180
,p_triggering_element_type=>'COLUMN'
,p_triggering_region_id=>wwv_flow_api.id(65904519476327605)
,p_triggering_element=>'GL_ACCOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(65952336742694616)
,p_event_id=>wwv_flow_api.id(65952208830694615)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'COLUMN'
,p_affected_elements=>'BUDGET,ACTUAL,ENCUMBRANCES,FUND_AVAILABLE'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select F_PROJECTBUDGET.BUDGET as BUDGET,',
'    F_PROJECTBUDGET.ACTUAL as ACTUAL,',
'    F_PROJECTBUDGET.ENCUMBRANCES as ENCUMBRANCES,',
'    F_PROJECTBUDGET.FUND_AVAILABLE as FUND_AVAILABLE ',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number    = :PROJECT_NUMBER',
'and       task_number    = :TASK_NUMBER',
'and      natural_account = :GL_ACCOUNT',
''))
,p_attribute_07=>'GL_ACCOUNT,PROJECT_NUMBER,TASK_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(65952436547694617)
,p_name=>'Cal Balance after'
,p_event_sequence=>190
,p_triggering_element_type=>'COLUMN'
,p_triggering_region_id=>wwv_flow_api.id(65904519476327605)
,p_triggering_element=>'TRANSFERRED_AMOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(65952557842694618)
,p_event_id=>wwv_flow_api.id(65952436547694617)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'COLUMN'
,p_affected_elements=>'BALANCE_AFTER'
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>'return :FUND_AVAILABLE - :TRANSFERRED_AMOUNT ;'
,p_attribute_07=>'TRANSFERRED_AMOUNT,FUND_AVAILABLE'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66227643787393221)
,p_name=>'Submit BTF'
,p_event_sequence=>250
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(66033175727491847)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66227770361393222)
,p_event_id=>wwv_flow_api.id(66227643787393221)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    BTF_WORKFLOW.INSERT_SUBMIT_USER(:P2_FORM_NO);',
'end;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66229675245393241)
,p_event_id=>wwv_flow_api.id(66227643787393221)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Budget Transfer Request has been submitted successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66227830760393223)
,p_event_id=>wwv_flow_api.id(66227643787393221)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_STATUS'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66306981145207217)
,p_name=>'get Project and department'
,p_event_sequence=>260
,p_triggering_element_type=>'COLUMN'
,p_triggering_region_id=>wwv_flow_api.id(66229751646393242)
,p_triggering_element=>'PROJECT_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66307027300207218)
,p_event_id=>wwv_flow_api.id(66306981145207217)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'COLUMN'
,p_affected_elements=>'PROJECT_NAME,DEPARTMENT'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.PROJECT_NAME as PROJECT_NAME ',
'        ,DEPARTMENT as DEPARTMENT',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :PROJECT_NUMBER'))
,p_attribute_07=>'PROJECT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66307164427207219)
,p_name=>'set Cost Center'
,p_event_sequence=>270
,p_triggering_element_type=>'COLUMN'
,p_triggering_region_id=>wwv_flow_api.id(66229751646393242)
,p_triggering_element=>'TASK_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66307270717207220)
,p_event_id=>wwv_flow_api.id(66307164427207219)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'COLUMN'
,p_affected_elements=>'COST_CENTER'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.COST_CENTER as COST_CENTER',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :PROJECT_NUMBER',
' and task_number = :TASK_NUMBER'))
,p_attribute_07=>'PROJECT_NUMBER,TASK_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66307312864207221)
,p_name=>'get Balances'
,p_event_sequence=>280
,p_triggering_element_type=>'COLUMN'
,p_triggering_region_id=>wwv_flow_api.id(66229751646393242)
,p_triggering_element=>'GL_ACCOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66307449672207222)
,p_event_id=>wwv_flow_api.id(66307312864207221)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'COLUMN'
,p_affected_elements=>'BUDGET,ACTUAL,ENCUMBRANCES,FUND_AVAILABLE'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select F_PROJECTBUDGET.BUDGET as BUDGET,',
'    F_PROJECTBUDGET.ACTUAL as ACTUAL,',
'    F_PROJECTBUDGET.ENCUMBRANCES as ENCUMBRANCES,',
'    F_PROJECTBUDGET.FUND_AVAILABLE as FUND_AVAILABLE ',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number    = :PROJECT_NUMBER',
'and       task_number    = :TASK_NUMBER',
'and      natural_account = :GL_ACCOUNT',
''))
,p_attribute_07=>'PROJECT_NUMBER,TASK_NUMBER,GL_ACCOUNT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66307713740207225)
,p_name=>'Fund After Calc'
,p_event_sequence=>290
,p_triggering_element_type=>'COLUMN'
,p_triggering_region_id=>wwv_flow_api.id(66229751646393242)
,p_triggering_element=>'TRANSFERRED_AMOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66307887789207226)
,p_event_id=>wwv_flow_api.id(66307713740207225)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'COLUMN'
,p_affected_elements=>'BALANCE_AFTER'
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>'return :FUND_AVAILABLE + :TRANSFERRED_AMOUNT ;'
,p_attribute_07=>'FUND_AVAILABLE,TRANSFERRED_AMOUNT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(65951181926694604)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(65904519476327605)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Lines2 - Save Interactive Grid Data'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(66306863485207216)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(66229751646393242)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'To Lines Table - Save Interactive Grid Data'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
