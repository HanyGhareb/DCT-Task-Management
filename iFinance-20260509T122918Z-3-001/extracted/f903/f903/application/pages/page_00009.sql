prompt --application/pages/page_00009
begin
--   Manifest
--     PAGE: 00009
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
 p_id=>9
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'Budget Transfer Request Details'
,p_alias=>'FORM-DETAILS'
,p_step_title=>'Budget Transfer Request Details'
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
,p_step_template=>wwv_flow_api.id(65513403179255734)
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
,p_last_upd_yyyymmddhh24miss=>'20200520145250'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(66415542982720457)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65554277731255756)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(65494572154255667)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(65602363670255785)
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(66461626536879628)
,p_name=>'<b>Budget Deductions (From Lines)</b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_icon_css_classes=>'fa-cart-arrow-up fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--inline'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'BTF_LINES'
,p_query_where=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FORM_NO = :P9_FORM_NO',
'and FROM_TO = ''FROM'''))
,p_query_order_by=>'LINE_NO'
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
 p_id=>wwv_flow_api.id(66461778905879629)
,p_query_column_id=>1
,p_column_alias=>'FORM_NO'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66461862734879630)
,p_query_column_id=>2
,p_column_alias=>'LINE_NO'
,p_column_display_sequence=>3
,p_column_heading=>'Line No'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.::P30_LINE_ID,P30_FROM_TO_X_1,P30_STATUS,P30_FINANCE_STATUS:#LINE_ID#,FROM,&P9_STATUS.,&P9_FINANCE_STATUS.'
,p_column_linktext=>'#LINE_NO#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66461991536879631)
,p_query_column_id=>3
,p_column_alias=>'FROM_TO'
,p_column_display_sequence=>4
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66462001897879632)
,p_query_column_id=>4
,p_column_alias=>'PROJECT_NUMBER'
,p_column_display_sequence=>7
,p_column_heading=>'Project Number'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66462164832879633)
,p_query_column_id=>5
,p_column_alias=>'PROJECT_NAME'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66462212288879634)
,p_query_column_id=>6
,p_column_alias=>'TASK_NUMBER'
,p_column_display_sequence=>9
,p_column_heading=>'Task Number'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66462311564879635)
,p_query_column_id=>7
,p_column_alias=>'COST_CENTER'
,p_column_display_sequence=>10
,p_column_heading=>'Cost Center'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66462461100879636)
,p_query_column_id=>8
,p_column_alias=>'GL_ACCOUNT'
,p_column_display_sequence=>11
,p_column_heading=>'Gl Account'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66462514064879637)
,p_query_column_id=>9
,p_column_alias=>'BUDGET'
,p_column_display_sequence=>12
,p_column_heading=>'Budget'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66462680696879638)
,p_query_column_id=>10
,p_column_alias=>'FUND_AVAILABLE'
,p_column_display_sequence=>23
,p_column_heading=>'Fund Available'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66462795673879639)
,p_query_column_id=>11
,p_column_alias=>'TRANSFERRED_AMOUNT'
,p_column_display_sequence=>24
,p_column_heading=>'Transferred Amount'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66462859126879640)
,p_query_column_id=>12
,p_column_alias=>'BALANCE_AFTER'
,p_column_display_sequence=>25
,p_column_heading=>'Balance After'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66462916890879641)
,p_query_column_id=>13
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>14
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66463055394879642)
,p_query_column_id=>14
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>15
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66463149746879643)
,p_query_column_id=>15
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>16
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66463207571879644)
,p_query_column_id=>16
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>17
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66463337959879645)
,p_query_column_id=>17
,p_column_alias=>'LINE_ID'
,p_column_display_sequence=>1
,p_column_heading=>'<span class="u-VisuallyHidden">Edit</span>'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.::P30_LINE_ID,P30_FROM_TO_X_1,P30_STATUS,P30_FINANCE_STATUS:#LINE_ID#,FROM,&P9_STATUS.,&P9_FINANCE_STATUS.'
,p_column_linktext=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_display_when_cond_type=>'PLSQL_EXPRESSION'
,p_display_when_condition=>'(:P9_FINANCE_STATUS = ''Draft'' and :P9_STATUS = ''Draft'')'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66463460890879646)
,p_query_column_id=>18
,p_column_alias=>'TCA_SECTOR'
,p_column_display_sequence=>5
,p_column_heading=>'Sector'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66463534548879647)
,p_query_column_id=>19
,p_column_alias=>'DEPARTMENT'
,p_column_display_sequence=>6
,p_column_heading=>'Department'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66463665937879648)
,p_query_column_id=>20
,p_column_alias=>'STRATEGIC'
,p_column_display_sequence=>18
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66463787112879649)
,p_query_column_id=>21
,p_column_alias=>'PROGRAM'
,p_column_display_sequence=>19
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66463802464879650)
,p_query_column_id=>22
,p_column_alias=>'OUTPUT'
,p_column_display_sequence=>20
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66526792592664501)
,p_query_column_id=>23
,p_column_alias=>'ACTUAL'
,p_column_display_sequence=>21
,p_column_heading=>'Actual'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66526823184664502)
,p_query_column_id=>24
,p_column_alias=>'ENCUMBRANCES'
,p_column_display_sequence=>22
,p_column_heading=>'Encumbrances'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(66527636028664510)
,p_name=>'<b>Budget Additions (To Lines)</b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_icon_css_classes=>'fa-cart-arrow-down fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--inline'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'BTF_LINES'
,p_query_where=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FORM_NO = :P9_FORM_NO',
'and FROM_TO = ''TO'''))
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
 p_id=>wwv_flow_api.id(66527753943664511)
,p_query_column_id=>1
,p_column_alias=>'FORM_NO'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66527800708664512)
,p_query_column_id=>2
,p_column_alias=>'LINE_NO'
,p_column_display_sequence=>3
,p_column_heading=>'Line No'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.::P30_LINE_ID,P30_FROM_TO_X_1,P30_STATUS,P30_FINANCE_STATUS:#LINE_ID#,TO,&P9_STATUS.,&P9_FINANCE_STATUS.'
,p_column_linktext=>'#LINE_NO#'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66527908110664513)
,p_query_column_id=>3
,p_column_alias=>'FROM_TO'
,p_column_display_sequence=>4
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66528069680664514)
,p_query_column_id=>4
,p_column_alias=>'PROJECT_NUMBER'
,p_column_display_sequence=>7
,p_column_heading=>'Project Number'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66528171922664515)
,p_query_column_id=>5
,p_column_alias=>'PROJECT_NAME'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66528254806664516)
,p_query_column_id=>6
,p_column_alias=>'TASK_NUMBER'
,p_column_display_sequence=>9
,p_column_heading=>'Task Number'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66528369234664517)
,p_query_column_id=>7
,p_column_alias=>'COST_CENTER'
,p_column_display_sequence=>10
,p_column_heading=>'Cost Center'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66528468962664518)
,p_query_column_id=>8
,p_column_alias=>'GL_ACCOUNT'
,p_column_display_sequence=>11
,p_column_heading=>'Gl Account'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66528511008664519)
,p_query_column_id=>9
,p_column_alias=>'BUDGET'
,p_column_display_sequence=>12
,p_column_heading=>'Budget'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66528622267664520)
,p_query_column_id=>10
,p_column_alias=>'FUND_AVAILABLE'
,p_column_display_sequence=>15
,p_column_heading=>'Fund Available'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66528949108664523)
,p_query_column_id=>11
,p_column_alias=>'TRANSFERRED_AMOUNT'
,p_column_display_sequence=>16
,p_column_heading=>'Transferred Amount'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66529066138664524)
,p_query_column_id=>12
,p_column_alias=>'BALANCE_AFTER'
,p_column_display_sequence=>17
,p_column_heading=>'Balance After'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66529161079664525)
,p_query_column_id=>13
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>18
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66529233351664526)
,p_query_column_id=>14
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>19
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66529328546664527)
,p_query_column_id=>15
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>20
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66529451723664528)
,p_query_column_id=>16
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>21
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66529520575664529)
,p_query_column_id=>17
,p_column_alias=>'LINE_ID'
,p_column_display_sequence=>1
,p_column_heading=>'<span class="u-VisuallyHidden">Edit</span>'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.::P30_LINE_ID,P30_FROM_TO_X_1,P30_FORM_NO,P30_STATUS,P30_FINANCE_STATUS:#LINE_ID#,TO,#FORM_NO#,&P9_STATUS.,&P9_FINANCE_STATUS.'
,p_column_linktext=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_display_when_cond_type=>'PLSQL_EXPRESSION'
,p_display_when_condition=>'(:P9_FINANCE_STATUS = ''Draft'' and :P9_STATUS = ''Draft'')'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66529667523664530)
,p_query_column_id=>18
,p_column_alias=>'TCA_SECTOR'
,p_column_display_sequence=>5
,p_column_heading=>'Sector'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66529792024664531)
,p_query_column_id=>19
,p_column_alias=>'DEPARTMENT'
,p_column_display_sequence=>6
,p_column_heading=>'Department'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66529838356664532)
,p_query_column_id=>20
,p_column_alias=>'STRATEGIC'
,p_column_display_sequence=>22
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66529968610664533)
,p_query_column_id=>21
,p_column_alias=>'PROGRAM'
,p_column_display_sequence=>23
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66530008033664534)
,p_query_column_id=>22
,p_column_alias=>'OUTPUT'
,p_column_display_sequence=>24
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66528753256664521)
,p_query_column_id=>23
,p_column_alias=>'ACTUAL'
,p_column_display_sequence=>13
,p_column_heading=>'Actual'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66528840806664522)
,p_query_column_id=>24
,p_column_alias=>'ENCUMBRANCES'
,p_column_display_sequence=>14
,p_column_heading=>'Encumbrances'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76091016936459909)
,p_plug_name=>'<b>DOA Approval History</b>'
,p_icon_css_classes=>'fa-network-hub fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>100
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       FORM_NO,',
'       STEP_NO,',
'       POSITION,',
'       ENTITY_TYPE,',
'       ENTITY_NAME,',
'       ACTION_REQUIRED,',
'       USER_NAME,',
'       (select dct_employees_list2.full_name_en',
'        from dct_employees_list2',
'        where dct_employees_list2.user_name = btf_approval_history.user_name) Employee_name,',
'       STATUS,',
'       RECEVIED_DATE,',
'       ACTION_DATE,',
'       COMMENTS,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON',
'  from BTF_APPROVAL_HISTORY',
' where form_no = :P9_FORM_NO',
'and approval_type != ''BTR-Finance Internal''',
'order by step_no , recevied_date'))
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
 p_id=>wwv_flow_api.id(76091153471459910)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'Form not submitted for DOA approval yet.'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_sort=>'N'
,p_show_control_break=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_reset=>'N'
,p_show_help=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:18:&SESSION.::&DEBUG.::P18_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_auth_scheme=>wwv_flow_api.id(70305549671149387)
,p_owner=>'TCA9051'
,p_internal_uid=>76091153471459910
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76091208782459911)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76091352601459912)
,p_db_column_name=>'FORM_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Form No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76091413364459913)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76091560722459914)
,p_db_column_name=>'POSITION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Position'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76091696749459915)
,p_db_column_name=>'ENTITY_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Entity Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76091721352459916)
,p_db_column_name=>'ENTITY_NAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Entity Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76091894433459917)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76091910295459918)
,p_db_column_name=>'USER_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76092061540459919)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76092172909459920)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76092228552459921)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76092304193459922)
,p_db_column_name=>'COMMENTS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76092480573459923)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76092507213459924)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76092657690459925)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76092722979459926)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76092839829459927)
,p_db_column_name=>'EMPLOYEE_NAME'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(76122297169607820)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'761223'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:POSITION:ACTION_REQUIRED:USER_NAME:EMPLOYEE_NAME:STATUS:RECEVIED_DATE:ACTION_DATE:COMMENTS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(7341252592286763)
,p_report_id=>wwv_flow_api.id(76122297169607820)
,p_name=>'Pending With'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Pending'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Pending''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#C6F7CB'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(132003030306976186)
,p_name=>'<b>Transfer Request Details</b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>20
,p_region_css_classes=>'js-master-region'
,p_icon_css_classes=>'fa-braille fam-check fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-AVPList--leftAligned'
,p_grid_column_span=>8
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select FORM_NO,',
'       REVISION_NO,',
'       ORACLE_APPROVAL1,',
'       ORACLE_APPROVAL2,',
'       ORACLE_HYPERION,',
'       CREATION_DATE,',
'       CREATED_BY,',
'       REASON,',
'       BTF_NO,',
'       STATUS,',
'       UPDATED_BY,',
'       UPDATED_DATE,',
'       YEAR,',
'       SECTOR,',
'       priority,',
'       form_date,',
'       due_date',
'  from BTF_HEADER',
' where "FORM_NO" = :P9_FORM_NO'))
,p_display_when_condition=>'P9_FORM_NO'
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
 p_id=>wwv_flow_api.id(66368330070720351)
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
'and "FORM_NO" = :P9_FORM_NO'))
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66368759538720351)
,p_query_column_id=>2
,p_column_alias=>'REVISION_NO'
,p_column_display_sequence=>4
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "REVISION_NO" is not null',
'and "FORM_NO" = :P9_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66674820287106832)
,p_query_column_id=>3
,p_column_alias=>'ORACLE_APPROVAL1'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_report_column_required_role=>wwv_flow_api.id(70397243083858530)
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66674948899106833)
,p_query_column_id=>4
,p_column_alias=>'ORACLE_APPROVAL2'
,p_column_display_sequence=>12
,p_hidden_column=>'Y'
,p_report_column_required_role=>wwv_flow_api.id(70397243083858530)
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66675048046106834)
,p_query_column_id=>5
,p_column_alias=>'ORACLE_HYPERION'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_report_column_required_role=>wwv_flow_api.id(70397243083858530)
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66369175155720351)
,p_query_column_id=>6
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>5
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "CREATION_DATE" is not null',
'and "FORM_NO" = :P9_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66369583716720352)
,p_query_column_id=>7
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>6
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "CREATED_BY" is not null',
'and "FORM_NO" = :P9_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66369907457720352)
,p_query_column_id=>8
,p_column_alias=>'REASON'
,p_column_display_sequence=>17
,p_column_heading=>'Reason'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "REASON" is not null',
'and "FORM_NO" = :P9_FORM_NO'))
,p_derived_column=>'N'
,p_include_in_export=>'Y'
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
 p_id=>wwv_flow_api.id(66370302241720353)
,p_query_column_id=>9
,p_column_alias=>'BTF_NO'
,p_column_display_sequence=>3
,p_column_heading=>'BTF No'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "BTF_NO" is not null',
'and "FORM_NO" = :P9_FORM_NO'))
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66370717469720354)
,p_query_column_id=>10
,p_column_alias=>'STATUS'
,p_column_display_sequence=>7
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "STATUS" is not null',
'and "FORM_NO" = :P9_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66371157918720354)
,p_query_column_id=>11
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "UPDATED_BY" is not null',
'and "FORM_NO" = :P9_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66371579754720354)
,p_query_column_id=>12
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "UPDATED_DATE" is not null',
'and "FORM_NO" = :P9_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66371984192720354)
,p_query_column_id=>13
,p_column_alias=>'YEAR'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "YEAR" is not null',
'and "FORM_NO" = :P9_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66372356482720354)
,p_query_column_id=>14
,p_column_alias=>'SECTOR'
,p_column_display_sequence=>16
,p_column_heading=>'Sector'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76157080897095339)
,p_query_column_id=>15
,p_column_alias=>'PRIORITY'
,p_column_display_sequence=>15
,p_column_heading=>'Priority'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76700863934160203)
,p_query_column_id=>16
,p_column_alias=>'FORM_DATE'
,p_column_display_sequence=>2
,p_column_heading=>'Form Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76700964802160204)
,p_query_column_id=>17
,p_column_alias=>'DUE_DATE'
,p_column_display_sequence=>14
,p_column_heading=>'Due Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(132038743925976276)
,p_plug_name=>'Region Display Selector'
,p_region_css_classes=>'js-detail-rds'
,p_region_template_options=>'#DEFAULT#:margin-bottom-md'
,p_plug_template=>wwv_flow_api.id(65519636948255743)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_DISPLAY_SELECTOR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'STANDARD'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(132314308233414901)
,p_plug_name=>'<b>Summary </b>'
,p_icon_css_classes=>'fa-window-check'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--scrollBody:t-Form--leftLabels:t-Form--labelsAbove'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(132391526605212097)
,p_plug_name=>'<b><font color="black">Audit Info</font></b>'
,p_region_name=>'history'
,p_parent_plug_id=>wwv_flow_api.id(132314308233414901)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65530067520255748)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(132392076688212102)
,p_plug_name=>'<b>Documents</b>'
,p_icon_css_classes=>'fa-book fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>80
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(132392465604212106)
,p_plug_name=>'Documents Table'
,p_parent_plug_id=>wwv_flow_api.id(132392076688212102)
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
' where form_no = :P9_FORM_NO',
' order by created desc',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
' from BTF_DOCUMENTS BTF_DOCUMENTS',
' where FORM_NO = :P9_FORM_NO'))
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
 p_id=>wwv_flow_api.id(132392568529212107)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_filter=>'N'
,p_show_control_break=>'N'
,p_show_highlight=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_show_download=>'N'
,p_show_help=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>132392568529212107
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66402040873720436)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66402467413720441)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66402867338720442)
,p_db_column_name=>'FORM_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Form No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66403245219720442)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File name'
,p_column_link=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:RP:P6_ID,P6_REQUEST_STATUS,P6_FIN_REQUEST_STATUS:#ID#,&P9_STATUS.,&P9_FINANCE_STATUS.'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66403617419720442)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66404089007720442)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66404442274720443)
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
 p_id=>wwv_flow_api.id(66404857735720443)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'File Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66405208970720443)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66405650700720443)
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
 p_id=>wwv_flow_api.id(66406086023720443)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66406462782720443)
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
 p_id=>wwv_flow_api.id(66406837666720444)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66407212166720444)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66407664195720444)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:BTF_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(132471659453341775)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'664080'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:TAGS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(132589148235113502)
,p_plug_name=>'<b>Internal Finance Approval History</b>'
,p_icon_css_classes=>'fa-eye fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>90
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       FORM_NO,',
'       STEP_NO,',
'       POSITION,',
'       ENTITY_TYPE,',
'       ENTITY_NAME,',
'       ACTION_REQUIRED,',
'       USER_NAME,',
'       (select dct_employees_list2.full_name_en',
'        from dct_employees_list2',
'        where dct_employees_list2.user_name = btf_approval_history.user_name) Employee_name,',
'       STATUS,',
'       RECEVIED_DATE,',
'       ACTION_DATE,',
'       COMMENTS,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON',
'  from BTF_APPROVAL_HISTORY',
' where form_no = :P9_FORM_NO',
' and approval_type = ''BTR-Finance Internal''',
'order by step_no , recevied_date'))
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
 p_id=>wwv_flow_api.id(70375703599331728)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'Form not submitted for internal finance approval yet.'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_sort=>'N'
,p_show_control_break=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_reset=>'N'
,p_show_help=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:18:&SESSION.::&DEBUG.::P18_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_auth_scheme=>wwv_flow_api.id(70305549671149387)
,p_owner=>'TCA9051'
,p_internal_uid=>70375703599331728
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70375816293331729)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70375965418331730)
,p_db_column_name=>'FORM_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Form No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70376097977331731)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70376128596331732)
,p_db_column_name=>'POSITION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Position'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70376222848331733)
,p_db_column_name=>'ENTITY_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Entity Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70376343504331734)
,p_db_column_name=>'ENTITY_NAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Entity Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70376418752331735)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70376543179331736)
,p_db_column_name=>'USER_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70376638934331737)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70376773587331738)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70376886965331739)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70376956910331740)
,p_db_column_name=>'COMMENTS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70377047148331741)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70377187943331742)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70377275857331743)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(70377390521331744)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76090907800459908)
,p_db_column_name=>'EMPLOYEE_NAME'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(70478259501679322)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'704783'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:POSITION:ACTION_REQUIRED:USER_NAME:EMPLOYEE_NAME:STATUS:RECEVIED_DATE:ACTION_DATE:COMMENTS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(7342467549292775)
,p_report_id=>wwv_flow_api.id(70478259501679322)
,p_name=>'Current Status'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Pending'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Pending''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D4F7D4'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66362286828720325)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(66415542982720457)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Transfer Request'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:RP,3::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76090347042459902)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(66415542982720457)
,p_button_name=>'STOP_APPROVAL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Stop Approval'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'l_finance_status   VARCHAR2(50);',
'l_status           VARCHAR2(50);',
'BEGIN',
'',
'select finance_status , status',
'into    l_finance_status , l_status',
'from btf_header',
'where form_no = :P9_FORM_NO;',
'',
'    IF l_finance_status in  (''Draft'' , ''Approved'' , ''Rejected'' , ''Stopped'' )',
'    THEN',
'        RETURN false;',
'    ELSE',
'        RETURN true;',
'    END IF;',
'END;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-stop-circle-o'
,p_security_scheme=>wwv_flow_api.id(70305549671149387)
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76017082693486324)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(66415542982720457)
,p_button_name=>'SUBMIT_INT'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit (Finance Internally)'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'l_req    varchar2(1);',
'l_from_amount     number;',
'l_to_amount     number;',
'begin',
'',
'select btr_req_fin_approval',
'into     l_req',
'from btf_config',
'where id = 1;',
'',
'-- from amount',
'select nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0)',
'into l_from_amount',
'from BTF_LINES BTF_LINES',
'where FoRM_NO = :P9_FORM_NO',
'and from_to = ''FROM'';',
'',
'-- To Amount',
'',
'select nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0)',
'into l_to_amount',
'from BTF_LINES BTF_LINES',
'where FORM_NO = :P9_FORM_NO',
'and from_to = ''TO'';',
'',
'',
'',
'if :P9_FINANCE_STATUS in  (''Draft'' , ''Stopped'') ',
'    and l_to_amount =  l_from_amount ',
'    and l_from_amount != 0',
'    and l_req = ''Y''',
'    Then',
'        return true;',
'    else',
'        return false;',
'  end if;      ',
'',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-circle'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66362616869720325)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(66415542982720457)
,p_button_name=>'SUBMIT'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'    l_req                VARCHAR2(1);',
'    l_from_amount        number;',
'    l_to_amount          number;',
'',
'BEGIN',
'',
'    select btr_req_fin_approval',
'        into    l_req',
'    from btf_config',
'        where id = 1;',
'',
'-- from amount',
'select nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0)',
'    into l_from_amount',
'from BTF_LINES BTF_LINES',
'    where FoRM_NO = :P9_FORM_NO',
'    and from_to = ''FROM'';',
'',
'-- To Amount',
'select nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0)',
'    into l_to_amount',
'from BTF_LINES BTF_LINES',
'    where FORM_NO = :P9_FORM_NO',
'    and from_to = ''TO'';',
'',
'IF :p9_status in  (''Draft'' , ''Not Started'' )',
'        AND l_from_amount = l_to_amount ',
'        AND l_from_amount != 0 ',
'        AND ((l_req = ''Y'' and  :P9_FINANCE_STATUS	= ''Approved'') OR  l_req = ''N'')',
'    THEN',
'        RETURN true;',
'    ELSE',
'        RETURN false;',
'    END IF;',
'END;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-circle'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66361825692720321)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(66415542982720457)
,p_button_name=>'RESET'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft:t-Button--gapRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_image_alt=>'Reset'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:9:&SESSION.:RESET:&DEBUG.:RP,2::'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66886017984612401)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(66415542982720457)
,p_button_name=>'Home'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Home'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP,1::'
,p_button_condition=>'9'
,p_button_condition_type=>'CURRENT_PAGE_NOT_EQUAL_CONDITION'
,p_icon_css_classes=>'fa-home'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66401326089720429)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(132392076688212102)
,p_button_name=>'Add_file'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600261178255783)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add File'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:RP,6:P6_FORM_NO:&P9_FORM_NO.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66372758389720354)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(132003030306976186)
,p_button_name=>'EDIT'
,p_button_static_id=>'edit_master_btn'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_image_alt=>'Edit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:RP,3:P3_FORM_NO:&P9_FORM_NO.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'if :P9_FINANCE_STATUS = ''Draft'' ',
'    and  :P9_STATUS = ''Draft'' ',
'    Then',
'        return true;',
'    else',
'        return false;',
'  end if;      ',
'',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-pencil-square-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76702041173160215)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(66461626536879628)
,p_button_name=>'ADD_FROM_BTF_LINES'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(65600261178255783)
,p_button_image_alt=>'Add Line  (Transfer From  - Budget Deduction)'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.::P30_FORM_NO,P30_FROM_TO,P30_SOURCE,P30_FORM_NO_X,P30_FROM_TO_X_1:&P9_FORM_NO.,FROM,FBP,&P9_FORM_NO.,FROM'
,p_button_condition=>'P9_STATUS'
,p_button_condition2=>'Draft:Reject'
,p_button_condition_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(77192881991990541)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(66527636028664510)
,p_button_name=>'ADD_TO_BTF_LINES'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(65600261178255783)
,p_button_image_alt=>'Add Line  (Transfer From  - Budget Deduction)'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.::P30_FORM_NO,P30_FROM_TO,P30_FORM_NO_X,P30_FROM_TO_X_1:&P9_FORM_NO.,TO,&P9_FORM_NO.,TO'
,p_button_condition=>'P9_STATUS'
,p_button_condition2=>'Draft:Reject'
,p_button_condition_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66373124472720355)
,p_name=>'P9_FORM_NO'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(132003030306976186)
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66386326704720418)
,p_name=>'P9_TOTAL_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(132314308233414901)
,p_prompt=>'Total deduction (From Amount)'
,p_post_element_text=>'AED'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_column_css_classes=>'u-danger-text'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66386713623720418)
,p_name=>'P9_TOTAL_TO_AMOUNT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(132314308233414901)
,p_prompt=>'Total Addition (To Amount)'
,p_post_element_text=>'AED'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_grid_column_css_classes=>'u-success-text'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66387131894720418)
,p_name=>'P9_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(132314308233414901)
,p_item_default=>'Draft'
,p_prompt=>'Status'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.STATUS as STATUS ',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P9_FORM_NO'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Approval Status According to DCT DOA.'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66387811678720421)
,p_name=>'P9_CREATED_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(132391526605212097)
,p_prompt=>'Created By'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.CREATED_BY as CREATED_BY ',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P9_FORM_NO'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66388223315720421)
,p_name=>'P9_CREATED_ON'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(132391526605212097)
,p_prompt=>'Created ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(BTF_HEADER.UPDATED_DATE,''MM/DD/YYYY HH24:MI:SS'') as UPDATED_DATE',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P9_FORM_NO;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
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
 p_id=>wwv_flow_api.id(66388637145720421)
,p_name=>'P9_UPDATED_BY'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(132391526605212097)
,p_prompt=>'Updated By'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.UPDATED_BY as UPDATED_BY',
'from BTF_HEADER BTF_HEADER',
' where form_no = :P9_FORM_NO'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66389050167720421)
,p_name=>'P9_UPDATED_ON'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(132391526605212097)
,p_prompt=>'Updated ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(BTF_HEADER.UPDATED_DATE,''MM/DD/YYYY HH24:MI:SS'') as UPDATED_DATE',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P9_FORM_NO;'))
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
 p_id=>wwv_flow_api.id(70375175446331722)
,p_name=>'P9_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(132003030306976186)
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76017257056486326)
,p_name=>'P9_FINANCE_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(132314308233414901)
,p_item_default=>'Draft'
,p_prompt=>'Finance Status'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''<p style="color:red;">'' ||',
'        BTF_HEADER.finance_STATUS ',
'        || ''</p>'' as STATUS ',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P9_FORM_NO'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Internal Finance Approval Status'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(66416293106720469)
,p_computation_sequence=>10
,p_computation_item=>'P9_TOTAL_FROM'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  to_char(nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0),''99,999,999.99'')',
' from BTF_LINES BTF_LINES',
'where FoRM_NO = :P9_FORM_NO',
'and from_to = ''FROM'''))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(66416693310720470)
,p_computation_sequence=>20
,p_computation_item=>'P9_TOTAL_TO_AMOUNT'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select to_char(nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0),''99,999,999.99'')',
' from BTF_LINES BTF_LINES',
'where FoRM_NO = :P9_FORM_NO',
'and from_to = ''TO'''))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(66417047842720470)
,p_computation_sequence=>30
,p_computation_item=>'P9_STATUS'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.STATUS as STATUS ',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P9_FORM_NO'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(76019520009486349)
,p_computation_sequence=>40
,p_computation_item=>'P9_FINANCE_STATUS'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.finance_STATUS as STATUS ',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P9_FORM_NO'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66419290334720475)
,p_name=>'Edit Master Record'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(132003030306976186)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66419744680720475)
,p_event_id=>wwv_flow_api.id(66419290334720475)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(132003030306976186)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66420205832720475)
,p_event_id=>wwv_flow_api.id(66419290334720475)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(''Btf\u0020Header\u0020updated'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66420678903720476)
,p_name=>'Perform Search'
,p_event_sequence=>150
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P9_SEARCH'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === apex.jQuery.ui.keyCode.ENTER'
,p_bind_type=>'bind'
,p_bind_event_type=>'keypress'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66421625339720476)
,p_event_id=>wwv_flow_api.id(66420678903720476)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CANCEL_EVENT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66417321046720472)
,p_name=>'Submit BTF'
,p_event_sequence=>250
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(66362616869720325)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66531122241664545)
,p_event_id=>wwv_flow_api.id(66417321046720472)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to submit this budget transfer request?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66417852451720474)
,p_event_id=>wwv_flow_api.id(66417321046720472)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'BTF_WORKFLOW.submit_form(:P9_FORM_NO);',
'FOR c1 IN (',
'            select request_id',
'            from btf_lines',
'            where form_no = :P9_FORM_NO',
'             and request_id is not null',
'         ) LOOP',
'            INSERT INTO btf_all_actions (request_type , request_id , action_type) ',
'            VALUES (''Transfer Request End User'' , c1.request_id , ''DOA Processing'');',
'        end loop;',
'',
'end;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66418826150720475)
,p_event_id=>wwv_flow_api.id(66417321046720472)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Budget Transfer Request has been submitted successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66418300990720475)
,p_event_id=>wwv_flow_api.id(66417321046720472)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66527074618664504)
,p_name=>'Refresh on Dialog Close -From Lines'
,p_event_sequence=>260
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(66461626536879628)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66530142616664535)
,p_event_id=>wwv_flow_api.id(66527074618664504)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(66461626536879628)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66527337421664507)
,p_event_id=>wwv_flow_api.id(66527074618664504)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(''Line Added'');'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66531014081664544)
,p_event_id=>wwv_flow_api.id(66527074618664504)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(66415542982720457)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66530628228664540)
,p_name=>'Refresh on Dialog Close -To Lines'
,p_event_sequence=>270
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(66527636028664510)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66530713842664541)
,p_event_id=>wwv_flow_api.id(66530628228664540)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(''Line Added'');'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66530871660664542)
,p_event_id=>wwv_flow_api.id(66530628228664540)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(66527636028664510)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76019005002486344)
,p_name=>'Submit Internal Finance Approval'
,p_event_sequence=>280
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(76017082693486324)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76019181060486345)
,p_event_id=>wwv_flow_api.id(76019005002486344)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to submit this budget transfer request for Internal Finance Approval ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76019219519486346)
,p_event_id=>wwv_flow_api.id(76019005002486344)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'btf_workflow.submit_form2(:P9_FORM_NO,''BTR-Finance Internal'');',
'',
'FOR c1 IN (',
'            select request_id',
'            from btf_lines',
'            where form_no = :P9_FORM_NO',
'             and request_id is not null',
'         ) LOOP',
'            INSERT INTO btf_all_actions (request_type , request_id , action_type) ',
'            VALUES (''Transfer Request End User'' , c1.request_id , ''Finance Processing'');',
'        end loop;',
'',
'',
'end;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76019315547486347)
,p_event_id=>wwv_flow_api.id(76019005002486344)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Budget Transfer Request has been submitted successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76019443843486348)
,p_event_id=>wwv_flow_api.id(76019005002486344)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76090498131459903)
,p_name=>'Stop approval Action'
,p_event_sequence=>290
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(76090347042459902)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76090512205459904)
,p_event_id=>wwv_flow_api.id(76090498131459903)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'This action will stop approval process for Form# (&P9_FORM_NO.),Are you sure ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76090689182459905)
,p_event_id=>wwv_flow_api.id(76090498131459903)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'btf_workflow.stop_btf(:P9_FORM_NO , ''BTR-Finance Internal'');',
'FOR c1 IN (',
'            select request_id',
'            from btf_lines',
'            where form_no = :P9_FORM_NO',
'             and request_id is not null',
'         ) LOOP',
'            INSERT INTO btf_all_actions (request_type , request_id , action_type) ',
'            VALUES (''Transfer Request End User'' , c1.request_id , ''Stopped'');',
'        end loop;',
'end;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76090751732459906)
,p_event_id=>wwv_flow_api.id(76090498131459903)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Approval process for Request# &P9_FORM_NO. stop successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76090815908459907)
,p_event_id=>wwv_flow_api.id(76090498131459903)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(77193162859990544)
,p_name=>'set Draft'
,p_event_sequence=>300
,p_condition_element=>'P9_FINANCE_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Draft'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(77193291519990545)
,p_event_id=>wwv_flow_api.id(77193162859990544)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ADD_CLASS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P9_FINANCE_STATUS'
,p_attribute_01=>'u-info-text'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(66527243724664506)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_01=>'P9_FORM_NO,REQUEST'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
wwv_flow_api.component_end;
end;
/
