prompt --application/pages/page_00035
begin
--   Manifest
--     PAGE: 00035
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>35
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Expense Report Page'
,p_alias=>'EXPENSE-REPORT-PAGE'
,p_step_title=>'Expense Report Page'
,p_allow_duplicate_submissions=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Form-label {',
'    	color: #368ed2;',
'	font-weight: bold;',
'	font-size:12px;',
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
'#history    .t-Region-header {',
'     background-color: #f3f0ef;',
'    color:#000;',
'}',
'',
'/* Custom Header color */',
'#inside-page .t-Region-header{',
'    background-color :#81d0b5;',
'    font-weight: bold;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>':P35_APPROVAL_STATUS not in (''Draft'' , ''Stopped'')'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240313115005'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5713743921231786)
,p_plug_name=>'Audit'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8040898187175502)
,p_plug_display_sequence=>80
,p_plug_new_grid_row=>false
,p_plug_new_grid_column=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5881939111168203)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5882488453168431)
,p_plug_name=>'Expense Report Details'
,p_region_name=>'inside-page'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'HRSS_EXPENSE_REPORTS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7197565092438606)
,p_plug_name=>'Emp Details'
,p_parent_plug_id=>wwv_flow_api.id(5882488453168431)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:t-Form--labelsAbove'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>2
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5713180890231781)
,p_plug_name=>'Expense Report Details'
,p_region_name=>'inside-page'
,p_parent_plug_id=>wwv_flow_api.id(5882488453168431)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5713327856231782)
,p_plug_name=>'Petty Cash Details'
,p_parent_plug_id=>wwv_flow_api.id(5882488453168431)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>2
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(37703314645753199)
,p_plug_name=>'Alert'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--warning'
,p_plug_template=>wwv_flow_api.id(8026775276175496)
,p_plug_display_sequence=>5
,p_plug_display_point=>'BODY'
,p_plug_source=>'Please Attache the supported documents'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Declare',
'l_count number;',
'',
'begin',
'     select count(*)',
'     into l_count',
'     from expense_report_documents',
'      where EXPENSE_REPORT_ID = :P35_EXPENSE_REPORT_ID ;',
'      ',
'if  l_count = 0',
'             then ',
'                 return true;',
'              else',
'                 return false;',
'end if;',
'',
'end;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(38020798312348358)
,p_plug_name=>'Region Display Selector'
,p_region_css_classes=>'js-detail-rds'
,p_region_template_options=>'#DEFAULT#:margin-bottom-md'
,p_plug_template=>wwv_flow_api.id(8030481219175499)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_DISPLAY_SELECTOR'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P35_EXPENSE_REPORT_ID'
,p_attribute_01=>'STANDARD'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(38021493419350676)
,p_name=>'Lines'
,p_template=>wwv_flow_api.id(8057862405175507)
,p_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_css_classes=>'js-detail-region'
,p_icon_css_classes=>'fa-list'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'t-Report--stretch:#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--inline'
,p_grid_column_span=>9
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'HRSS_EXPENSE_REPORT_LINES'
,p_query_where=>'"EXPENSE_REPORT_ID" = :P35_EXPENSE_REPORT_ID'
,p_query_order_by=>'LINE_ID'
,p_include_rowid_column=>true
,p_display_when_condition=>'P35_EXPENSE_REPORT_ID'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P35_EXPENSE_REPORT_ID'
,p_query_row_template=>wwv_flow_api.id(8084165237175515)
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No data found.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_query_row_count_max=>5000
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6385335434639311)
,p_query_column_id=>1
,p_column_alias=>'ROWID'
,p_column_display_sequence=>1
,p_column_heading=>'<span class="u-VisuallyHidden">Edit</span>'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.::P14_LINE_ID,P14_EXPENSE_REPORT_APPROVAL_STATUS,P14_EXPENSE_REPORT_APPROVAL_STATUS:#LINE_ID#,&P35_APPROVAL_STATUS.,&P35_APPROVAL_STATUS_1.'
,p_column_linktext=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6385725566639312)
,p_query_column_id=>2
,p_column_alias=>'LINE_ID'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6386111220639312)
,p_query_column_id=>3
,p_column_alias=>'EXPENSE_REPORT_ID'
,p_column_display_sequence=>3
,p_column_heading=>'Expense Report Id'
,p_heading_alignment=>'LEFT'
,p_hidden_column=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6386545458639312)
,p_query_column_id=>4
,p_column_alias=>'EXPENSE_DATE'
,p_column_display_sequence=>4
,p_column_heading=>'Expense Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6386887784639312)
,p_query_column_id=>5
,p_column_alias=>'RECEIPT_AMOUNT'
,p_column_display_sequence=>5
,p_column_heading=>'Receipt Amount'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6387266243639313)
,p_query_column_id=>6
,p_column_alias=>'EXPENSE_TYPE'
,p_column_display_sequence=>6
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6387675167639313)
,p_query_column_id=>7
,p_column_alias=>'JUSTIFICATION'
,p_column_display_sequence=>7
,p_column_heading=>'Justification'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6388103594639313)
,p_query_column_id=>8
,p_column_alias=>'COMMENT_TO_APPROVER'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6388495241639313)
,p_query_column_id=>9
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6388866169639313)
,p_query_column_id=>10
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6389352909639314)
,p_query_column_id=>11
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>11
,p_column_heading=>'Updated By'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6389710969639314)
,p_query_column_id=>12
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>12
,p_column_heading=>'Updated Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(54824292297621215)
,p_plug_name=>'Collaboration'
,p_region_name=>'inside-page'
,p_icon_css_classes=>'fa-comments-o fa-anim-flash fam-sleep fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_display_column=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P35_EXPENSE_REPORT_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(54824446277621217)
,p_name=>'Messages Report'
,p_region_name=>'projectUpdates'
,p_parent_plug_id=>wwv_flow_api.id(54824292297621215)
,p_template=>wwv_flow_api.id(8030481219175499)
,p_display_sequence=>10
,p_region_css_classes=>'updates-region'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'  CASE',
'        WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || user_name',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END  user_icon,',
'  updated_date  comment_date,',
'  (select e.full_name_en',
'    from dct_employees_list2 e',
'    where e.user_name = created_by) user_name,',
'  comment_text                    comment_text,',
'  null comment_modifiers,',
'  ''u-color-''||ora_hash(created_by,45) icon_modifier,',
'  action     actions,',
'  ''''     attribute_1,',
'  ''''     attribute_2,',
'  ''''    attribute_3,',
'  ''''    attribute_4,',
'  comment_id',
'from',
'  (SELECT',
'    c.comment_id,',
'    c.expense_report_id,',
'    c.comment_text,',
'    c.created_by,',
'    c.updated_by,',
'    c.creation_date,',
'    c.updated_date,',
'    c.action,',
'    e.user_name,',
'    e.photo_blob    ',
'FROM',
'    hrss_expense_report_comments c , dct_employees_list2 e',
'where c.updated_by = e.user_name    )',
'where Expense_report_id = :P35_EXPENSE_REPORT_ID',
'order by UPDATED_DATE desc;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P35_EXPENSE_REPORT_ID'
,p_query_row_template=>wwv_flow_api.id(8086778490175517)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6378512614600809)
,p_query_column_id=>1
,p_column_alias=>'USER_ICON'
,p_column_display_sequence=>1
,p_column_heading=>'User Icon'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<img src="#USER_ICON#" alt="Image Not Found" height="40" width="40">'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6378947816600809)
,p_query_column_id=>2
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>2
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6379320677600810)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6379669396600810)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::P21_COMMENT_ID,P21_ACTION:#COMMENT_ID#,edited'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6380077890600810)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6380468172600811)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6380952816600811)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6381356223600811)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6381736868600811)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6382095769600812)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6382533381600812)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6382945851600812)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>12
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(54837683268721948)
,p_name=>'Documents'
,p_template=>wwv_flow_api.id(8057862405175507)
,p_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_css_classes=>'js-detail-region'
,p_icon_css_classes=>'fa-book fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'t-Report--stretch:#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--inline'
,p_grid_column_span=>9
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       expense_report_id,',
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
'  from expense_report_documents',
' where expense_report_id = :P35_EXPENSE_REPORT_ID',
' order by created desc'))
,p_display_when_condition=>'P35_EXPENSE_REPORT_ID'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P35_EXPENSE_REPORT_ID'
,p_query_row_template=>wwv_flow_api.id(8084165237175515)
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No data found.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_query_row_count_max=>5000
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6394608028701573)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6394979785701573)
,p_query_column_id=>2
,p_column_alias=>'ROW_VERSION_NUMBER'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6395375359701573)
,p_query_column_id=>3
,p_column_alias=>'EXPENSE_REPORT_ID'
,p_column_display_sequence=>1
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6395798403701573)
,p_query_column_id=>4
,p_column_alias=>'FILENAME'
,p_column_display_sequence=>4
,p_column_heading=>'Document '
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.::P20_ID,P20_EXPENSE_REPORT_APPROVAL_STATUS:#ID#,&P35_APPROVAL_STATUS.'
,p_column_linktext=>'#FILENAME#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6396255852701574)
,p_query_column_id=>5
,p_column_alias=>'FILE_MIMETYPE'
,p_column_display_sequence=>14
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6396618054701574)
,p_query_column_id=>6
,p_column_alias=>'FILE_CHARSET'
,p_column_display_sequence=>15
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6396995048701574)
,p_query_column_id=>7
,p_column_alias=>'FILE_BLOB'
,p_column_display_sequence=>12
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6397434695701574)
,p_query_column_id=>8
,p_column_alias=>'FILE_COMMENTS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6397774677701574)
,p_query_column_id=>9
,p_column_alias=>'TAGS'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6398180902701575)
,p_query_column_id=>10
,p_column_alias=>'CREATED'
,p_column_display_sequence=>7
,p_column_heading=>'Created ON'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6398586412701575)
,p_query_column_id=>11
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>6
,p_column_heading=>'Created By'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6398972272701575)
,p_query_column_id=>12
,p_column_alias=>'UPDATED'
,p_column_display_sequence=>9
,p_column_heading=>'Updated ON'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6399459446701575)
,p_query_column_id=>13
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>8
,p_column_heading=>'Updated By'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6399788762701576)
,p_query_column_id=>14
,p_column_alias=>'FILE_SIZE'
,p_column_display_sequence=>16
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6400162247701576)
,p_query_column_id=>15
,p_column_alias=>'DOWNLOAD'
,p_column_display_sequence=>10
,p_column_heading=>'Download'
,p_use_as_row_header=>'N'
,p_column_format=>'DOWNLOAD:EXPENSE_REPORT_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(54952620737649738)
,p_plug_name=>'Approval History'
,p_icon_css_classes=>'fa-eye fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>90
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       REQUEST_ID,',
'       STEP_NO,',
'       ACTION_REQUIRED,',
'       pc.USER_NAME,',
'       STATUS,',
'       RECEVIED_DATE,',
'       ACTION_DATE,',
'       COMMENTS,',
'       APPROVAL_TYPE,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(pc.user_name)',
'           end Photo',
'           , e.full_name_en Name',
'  from hrss_expense_report_approval_history pc,  dct_employees_list2  e',
'  where pc.user_name = e.user_name (+)',
'and  pc.REQUEST_ID = :P35_EXPENSE_REPORT_ID',
'order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P35_EXPENSE_REPORT_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P35_APPROVAL_STATUS'
,p_plug_display_when_cond2=>'Draft'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approval History'
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
 p_id=>wwv_flow_api.id(54952754040649739)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>56942792367713503
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6408758878727246)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6409078686727246)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6410721701727247)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6411159015727248)
,p_db_column_name=>'USER_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6411532613727248)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6411862779727248)
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
 p_id=>wwv_flow_api.id(6412344469727248)
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
 p_id=>wwv_flow_api.id(6412755738727249)
,p_db_column_name=>'COMMENTS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6413067898727249)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6413535426727249)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6413874458727249)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6414320205727250)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6414754122727250)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6415153644727250)
,p_db_column_name=>'PHOTO'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6408350455727246)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Request Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32593677238346460)
,p_db_column_name=>'NAME'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(55345486115175300)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'84055'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:NAME:USER_NAME:STATUS:RECEVIED_DATE:ACTION_REQUIRED:ACTION_DATE:PHOTO:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(58907904595040445)
,p_report_id=>wwv_flow_api.id(55345486115175300)
,p_name=>'Pending'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Pending'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Pending''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D0F1CC'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(27679697664234540)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(5881939111168203)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :EMP_NUM in (9025 ,9051, 593 ,  9033) and :P35_APPROVAL_STATUS in ( ''Approved'', ''Stopped'') and :P35_INVOICING_YN = ''N''',
'Then ',
'return true;',
'else',
'return false;',
'End if ;'))
,p_button_condition_type=>'FUNCTION_BODY'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6377783058600807)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(54824292297621215)
,p_button_name=>'Add_Comment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119283245175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Comment'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::P21_EXPENSE_REPORT_ID:&P35_EXPENSE_REPORT_ID.'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6390123812639314)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(38021493419350676)
,p_button_name=>'POP_HRSS_EXPENSE_REPORT_LINES'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(8119283245175532)
,p_button_image_alt=>'Add Expense Report Line'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:RP,:P14_EXPENSE_REPORT_ID,P14_EXPENSE_REPORT_APPROVAL_STATUS:&P35_EXPENSE_REPORT_ID.,&P35_APPROVAL_STATUS.'
,p_button_condition=>':P35_APPROVAL_STATUS  in (''Draft'',''Stopped'', ''Return'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6400636211701576)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(54837683268721948)
,p_button_name=>'POP_HRSS_EXPENSE_REPORT_DOCUMENT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(8119283245175532)
,p_button_image_alt=>'Add Documents'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:RP,20:P20_EXPENSE_REPORT_ID,P20_EXPENSE_REPORT_APPROVAL_STATUS:&P35_EXPENSE_REPORT_ID.,&P35_APPROVAL_STATUS.'
,p_icon_css_classes=>'fa-plus'
,p_button_comment=>':P35_APPROVAL_STATUS  in (''Draft'',''Stopped'')'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5896879920168451)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(5881939111168203)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5897714491168453)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(5881939111168203)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>':P35_EXPENSE_REPORT_ID is not null and :P35_APPROVAL_STATUS = ''Draft'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5898110974168453)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(5881939111168203)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P35_APPROVAL_STATUS  in (''Draft'' , ''Stoped'') and :P35_EXPENSE_REPORT_ID is not null'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5898496019168453)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(5881939111168203)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save & Continue'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P35_EXPENSE_REPORT_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6402216180706749)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(5881939111168203)
,p_button_name=>'Submit'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_doc_count      number;',
'l_amount_line    number;',
'Begin',
'',
'select nvl(count(ID),0) as ID',
'into l_doc_count',
' from EXPENSE_REPORT_DOCUMENTS',
' where EXPENSE_REPORT_ID = :P35_EXPENSE_REPORT_ID;',
'',
' select nvl(sum(l.receipt_amount), 0) amount',
' into l_amount_line',
' from hrss_expense_report_lines l',
' where l.expense_report_id = :P35_EXPENSE_REPORT_ID;',
' ',
'if      :P35_EXPENSE_REPORT_ID is not null ',
'    and :P35_APPROVAL_STATUS in (''Draft'' , ''Stopped'' , ''Return'')',
'    and l_doc_count > 0',
'    and l_amount_line > 0',
'then ',
'    return true;',
'else',
'    return false;',
' end if;',
'',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6452309054766732)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(5881939111168203)
,p_button_name=>'STOP_Approval'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Stop Approval'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'(:P35_EXPENSE_REPORT_ID is not null and :P35_APPROVAL_STATUS = ''In-Progress'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7310039471469270)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(5881939111168203)
,p_button_name=>'Print'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Print'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'EMP_NUM'
,p_button_condition2=>'9051:593:9033:9025'
,p_button_condition_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_icon_css_classes=>'fa-print'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7311629402469286)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_api.id(5881939111168203)
,p_button_name=>'Post_to_AP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Post to AP'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:39:&SESSION.::&DEBUG.::P39_EXPENSE_REPORT_ID,P39_INVOICE_NUM,P39_INVOICING_YN:&P35_EXPENSE_REPORT_ID.,&P35_EXPENSE_REPORT_NUM.,''Y'''
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :EMP_NUM in (9033,9051) and :P35_APPROVAL_STATUS = ''Approved''',
'    Then return true;',
'    else ',
'    return false;',
' end if;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-print'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7310546385469275)
,p_button_sequence=>110
,p_button_plug_id=>wwv_flow_api.id(5881939111168203)
,p_button_name=>'Print_1'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Print photo'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'EMP_NUM'
,p_button_condition2=>'9051'
,p_button_condition_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_icon_css_classes=>'fa-print'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(6401449491706741)
,p_branch_name=>'Go To 35'
,p_branch_action=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.::P35_EXPENSE_REPORT_ID:&P35_EXPENSE_REPORT_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(5898496019168453)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(5898815649168454)
,p_branch_name=>'Go To Page Page From'
,p_branch_action=>'f?p=&APP_ID.:&P35_PAGE_FROM.:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(27291077983489461)
,p_name=>'P35_CANCEL_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_prompt=>'Cancel By'
,p_source=>'CANCEL_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEE NAME BY PERSONID LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en , person_id',
'from dct_employees_list2'))
,p_display_when=>'P35_APPROVAL_STATUS'
,p_display_when2=>'Cancelled'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(27290905751489460)
,p_name=>'P35_CANCEL_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_prompt=>'Cancel On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CANCEL_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P35_APPROVAL_STATUS'
,p_display_when2=>'Cancelled'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7197458721438605)
,p_name=>'P35_TYPE_H'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(5881939111168203)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7197248065438603)
,p_name=>'P35_TYPE_R'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_prompt=>'Type :'
,p_source=>'TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Clearing'' as display  , ''C'' as r',
'from dual',
'union all',
'select ''Reimbursement'' as display  , ''R'' r',
'from dual ;'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2040455890631909)
,p_name=>'P35_EMP_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(7197565092438606)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_item_default=>'EMP_NUM'
,p_item_default_type=>'ITEM'
,p_prompt=>'Emp#'
,p_source=>'EMPLOYEE_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2040380753631908)
,p_name=>'P35_NAME'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(7197565092438606)
,p_prompt=>'Name'
,p_source=>'select full_name_en from employees_v where employee_num = :P35_EMP_NUM'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5712158541231770)
,p_name=>'P35_PETTY_CASH_TYPE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(5713327856231782)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5713391183231783)
,p_name=>'P35_PETTY_CASH_AMOUNT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(5713327856231782)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Amount</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5713465036231784)
,p_name=>'P35_PETTY_CASH_REMAINING'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(5713327856231782)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Remaining </span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5882847617168432)
,p_name=>'P35_EXPENSE_REPORT_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_source=>'EXPENSE_REPORT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5883225428168437)
,p_name=>'P35_PETTY_CASH_ID'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Petty Cash :</span>'
,p_source=>'PETTY_CASH_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select petty_cash_no , petty_cash_id ',
'from petty_cash_all_v',
'where employee_num = :P35_EMPLOYEE_NUM',
'and (amount - cleared_amount) > 0',
'and approval_status = ''Approved''',
'and status = ''Open'';'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5883602634168440)
,p_name=>'P35_EXPENSE_REPORT_DATE'
,p_source_data_type=>'DATE'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_item_default=>'select sysdate from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Date :</span>'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'EXPENSE_REPORT_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>30
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'N'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5884447768168441)
,p_name=>'P35_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_item_default=>'Draft'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Approval Status :</span>'
,p_source=>'APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5884843305168441)
,p_name=>'P35_INVOICING_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_item_default=>'N'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Invoiced ? :</span>'
,p_source=>'INVOICING_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5885164863168441)
,p_name=>'P35_PRIORITY'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Priority :</span>'
,p_source=>'PRIORITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Low;L,Medium;M,High;H'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5885637229168442)
,p_name=>'P35_JUSTIFICATION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Justification :</span>'
,p_source=>'JUSTIFICATION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>4
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5886365641168443)
,p_name=>'P35_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(5713743921231786)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5887256447168444)
,p_name=>'P35_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(5713743921231786)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5887593904168444)
,p_name=>'P35_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(5713743921231786)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5887966672168445)
,p_name=>'P35_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(5713743921231786)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5888771404168445)
,p_name=>'P35_YEAR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_item_default=>'select extract(year from sysdate) from dual;'
,p_item_default_type=>'SQL_QUERY'
,p_source=>'YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5889205332168445)
,p_name=>'P35_EXPENSE_REPORT_NUM'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Expense Report# :</span>'
,p_source=>'EXPENSE_REPORT_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5889583096168446)
,p_name=>'P35_PAID_YN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_item_default=>'N'
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Paid ? :</span>'
,p_source=>'PAID_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5890018549168446)
,p_name=>'P35_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_prompt=>'Type :'
,p_source=>'TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P35_PETTY_CASH_TYPE = ''T''',
'then',
'return ''select ''''Clearing'''' d , ''''C'''' r',
'            from dual'' ;',
'else ',
'',
'return    ''select ''''Clearing'''' d , ''''C'''' r',
'            from dual',
'            UNION all',
'            select ''''Reimbursement'''' d , ''''R'''' r',
'            from dual'' ;',
'',
'end if'))
,p_lov_cascade_parent_items=>'P35_PETTY_CASH_TYPE'
,p_ajax_items_to_submit=>'P35_PETTY_CASH_TYPE'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(8118975198175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5890405318168446)
,p_name=>'P35_EMP_ORG_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_item_default=>'EMP_ORG_ID'
,p_item_default_type=>'ITEM'
,p_source=>'EMP_ORG_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5890787388168446)
,p_name=>'P35_EMPLOYEE_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_item_default=>'EMP_NUM'
,p_item_default_type=>'ITEM'
,p_source=>'EMPLOYEE_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5956620717081037)
,p_name=>'P35_PETTY_CASH_PROJECT'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(5713327856231782)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Project</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5956732474081038)
,p_name=>'P35_PETTY_CASH_TASK'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(5713327856231782)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Task</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5956809556081039)
,p_name=>'P35_PETTY_CASH_GL'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(5713327856231782)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">GL Account</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5956861685081040)
,p_name=>'P35_PETTY_CASH_CLEARED'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(5713327856231782)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Cleared</span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5956990799081041)
,p_name=>'P35_PETTY_CASH_REIMBURSEMENT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(5713327856231782)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Reimbursement </span>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(8118554792175530)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5957104338081042)
,p_name=>'P35_IMAGE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(7197565092438606)
,p_prompt=>'Image'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                 ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'           end  Photo',
'from dct_employees_list2  e',
'where e.employee_num = :P35_EMPLOYEE_NUM'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_IMAGE'
,p_tag_attributes=>'style="border-radius: 50%;display: block;margin-right: auto;width: 40%;"'
,p_field_template=>wwv_flow_api.id(8118738374175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'URL'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6401331135706740)
,p_name=>'P35_PAGE_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(5881939111168203)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7310138354469271)
,p_name=>'P35_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(37703314645753199)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7310863978469279)
,p_name=>'P35_CREATED_VIEW'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(5713743921231786)
,p_prompt=>'Create View'
,p_source=>'''Created on: '' || :P35_CREATION_DATE || '' - By: '' || :P35_CREATED_BY'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="border: 1px solid powderblue;padding: 2px;"'
,p_display_when=>'P35_EXPENSE_REPORT_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(8118738374175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7311009487469280)
,p_name=>'P35_UPDATED_VIEW'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(5713743921231786)
,p_prompt=>'Updated View'
,p_source=>'''Updated on: '' || :P35_UPDATED_DATE || '' - By: '' || :P35_UPDATED_BY'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="border: 1px solid powderblue;padding: 2px;"'
,p_grid_label_column_span=>0
,p_display_when=>'P35_EXPENSE_REPORT_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(8118738374175531)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28661182503766837)
,p_name=>'P35_TOTAL'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(7197565092438606)
,p_prompt=>'Total :'
,p_post_element_text=>'<b> &nbsp; AED</b>'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(sum(RECEIPT_AMOUNT), 0), ''99,999,999.99'')) tot',
'from hrss_expense_report_lines',
'where expense_report_id = :P35_EXPENSE_REPORT_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style=color:green;"'
,p_field_template=>wwv_flow_api.id(8118827706175531)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--xlarge'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(65068189635504765)
,p_name=>'P35_SEQ_COUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(5713180890231781)
,p_item_source_plug_id=>wwv_flow_api.id(5882488453168431)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select    nvl(max(HRSS_EXPENSE_REPORTS.SEQ_COUNT),0) + 1 as SEQ_COUNT ',
' from HRSS_EXPENSE_REPORTS HRSS_EXPENSE_REPORTS',
' WHERE HRSS_EXPENSE_REPORTS.EMPLOYEE_NUM  = :EMP_NUM'))
,p_item_default_type=>'SQL_QUERY'
,p_source=>'SEQ_COUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(5886923138168444)
,p_validation_name=>'P35_CREATION_DATE must be timestamp'
,p_validation_sequence=>90
,p_validation=>'P35_CREATION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(5886365641168443)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(5888537185168445)
,p_validation_name=>'P35_UPDATED_DATE must be timestamp'
,p_validation_sequence=>120
,p_validation=>'P35_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(5887966672168445)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5712246643231771)
,p_name=>'get Petty Cash Details'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P35_PETTY_CASH_ID'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5712325843231772)
,p_event_id=>wwv_flow_api.id(5712246643231771)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P35_PETTY_CASH_TYPE,P35_PETTY_CASH_AMOUNT,P35_PETTY_CASH_REMAINING,P35_PETTY_CASH_PROJECT,P35_PETTY_CASH_TASK,P35_PETTY_CASH_GL,P35_PETTY_CASH_CLEARED,P35_PETTY_CASH_REIMBURSEMENT'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select petty_cash_type_code , to_char(nvl(amount,0),''99,999,999.99'') amount ',
'    , to_char(nvl((amount - cleared_amount),0) ,''99,999,999.99'') remaining ',
'    , project_number , task , gl_account ',
'    , to_char(nvl(cleared_amount,0),''99,999,999.99'')    cleared_amount',
'    , to_char(nvl(reimburacement_amount,0),''99,999,999.99'')  reimburacement_amount',
'from petty_cash_all_v',
'where petty_cash_id = :P35_PETTY_CASH_ID;'))
,p_attribute_07=>'P35_PETTY_CASH_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5712485762231774)
,p_event_id=>wwv_flow_api.id(5712246643231771)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P35_EXPENSE_REPORT_NUM'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT (select petty_cash_no from petty_cash_all_v where petty_cash_id = :P35_PETTY_CASH_ID)	 ||',
'        ''/IE''                 ||',
'        (select nvl(max(SEQ_COUNT), 0) + 1',
'        from hrss_expense_reports e',
'        where e.petty_cash_id = :P35_PETTY_CASH_ID ) exp',
'from dual;'))
,p_attribute_07=>'P35_PETTY_CASH_ID'
,p_attribute_08=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5960672322081078)
,p_name=>'Dialog Closed new comment'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(6377783058600807)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5960788458081079)
,p_event_id=>wwv_flow_api.id(5960672322081078)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(54824446277621217)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5960906435081080)
,p_name=>'Dialog Closed Updated Commet'
,p_event_sequence=>30
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(54824446277621217)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5961025723081081)
,p_event_id=>wwv_flow_api.id(5960906435081080)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(54824446277621217)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5961095910081082)
,p_name=>'Dialog Closed new Lines'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(6390123812639314)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5961243017081083)
,p_event_id=>wwv_flow_api.id(5961095910081082)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(38021493419350676)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5961319122081084)
,p_name=>'Dialog Closed UpdateLines'
,p_event_sequence=>50
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(38021493419350676)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5961413861081085)
,p_event_id=>wwv_flow_api.id(5961319122081084)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(38021493419350676)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(28661276829766838)
,p_event_id=>wwv_flow_api.id(5961319122081084)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P35_TOTAL'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(sum(RECEIPT_AMOUNT), 0), ''99,999,999.99'')) tot',
'from hrss_expense_report_lines',
'where expense_report_id = :P35_EXPENSE_REPORT_ID;'))
,p_attribute_07=>'P35_EXPENSE_REPORT_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5961472898081086)
,p_name=>'Dialog Closed new Document'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(6400636211701576)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6401008491706737)
,p_event_id=>wwv_flow_api.id(5961472898081086)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(54837683268721948)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6401074453706738)
,p_name=>'Dialog Closed Update Document'
,p_event_sequence=>70
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(54837683268721948)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6401201383706739)
,p_event_id=>wwv_flow_api.id(6401074453706738)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(54837683268721948)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6402291686706750)
,p_name=>'Submit Expense Report'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(6402216180706749)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6402423146706751)
,p_event_id=>wwv_flow_api.id(6402291686706750)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to submit your Expense Report# &P35_EXPENSE_REPORT_NUM. for approval,Are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6402524630706752)
,p_event_id=>wwv_flow_api.id(6402291686706750)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'expense_report_workflow.submit(:P35_EXPENSE_REPORT_ID);',
'end;'))
,p_attribute_02=>'P35_EXPENSE_REPORT_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6402636666706753)
,p_event_id=>wwv_flow_api.id(6402291686706750)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Expense Report# &P35_EXPENSE_REPORT_NUM. Successfully Submitted.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6402744340706754)
,p_event_id=>wwv_flow_api.id(6402291686706750)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6402778683706755)
,p_name=>'Stop Approval'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(6452309054766732)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6402945313706756)
,p_event_id=>wwv_flow_api.id(6402778683706755)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure that you want to withdraw your Expense Report ? '
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6402978149706757)
,p_event_id=>wwv_flow_api.id(6402778683706755)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'expense_report_workflow.stop(:P35_EXPENSE_REPORT_ID );',
'',
'end;'))
,p_attribute_02=>'P35_EXPENSE_REPORT_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6403081740706758)
,p_event_id=>wwv_flow_api.id(6402778683706755)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'your Expense Report Approval has been stopped.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6403162006706759)
,p_event_id=>wwv_flow_api.id(6402778683706755)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7310280605469273)
,p_name=>'print'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(7310039471469270)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7310428639469274)
,p_event_id=>wwv_flow_api.id(7310280605469273)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'javaScript:window.open(''f?p=101:0:&SESSION.:PRINT_REPORT=ExpenseReportDetails3'' , ''_blank'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7310614678469276)
,p_name=>'New'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(7310546385469275)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7310715336469277)
,p_event_id=>wwv_flow_api.id(7310614678469276)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'javaScript:window.open(''f?p=101:0:&SESSION.:PRINT_REPORT=ExpenseReportDetails4'' , ''_blank'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7599939428612637)
,p_name=>'Dialog Close- AP Post'
,p_event_sequence=>120
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(7311629402469286)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7600025186612638)
,p_event_id=>wwv_flow_api.id(7599939428612637)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(5713180890231781)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7197048796438601)
,p_name=>'Display Expense report type LOV'
,p_event_sequence=>130
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P35_PETTY_CASH_TYPE'
,p_condition_element=>'P35_PETTY_CASH_TYPE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'T'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7196906251438600)
,p_event_id=>wwv_flow_api.id(7197048796438601)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P35_TYPE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7196517240438596)
,p_event_id=>wwv_flow_api.id(7197048796438601)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P35_TYPE_R'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7196889576438599)
,p_event_id=>wwv_flow_api.id(7197048796438601)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P35_TYPE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7196754912438598)
,p_event_id=>wwv_flow_api.id(7197048796438601)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P35_TYPE_R'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(27679528441234539)
,p_name=>'Cancel DA'
,p_event_sequence=>140
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(27679697664234540)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(27679400018234538)
,p_event_id=>wwv_flow_api.id(27679528441234539)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to cancel this request?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(27679380781234537)
,p_event_id=>wwv_flow_api.id(27679528441234539)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update hrss_expense_reports',
'set APPROVAL_STATUS = ''Cancelled'', CANCEL_BY = :PERSON_ID, CANCEL_ON = systimestamp',
'where EXPENSE_REPORT_ID = :P35_EXPENSE_REPORT_ID;',
'',
'',
'update hrss_expense_report_lines',
'set RECEIPT_AMOUNT = 0',
'where EXPENSE_REPORT_ID= :P35_EXPENSE_REPORT_ID;'))
,p_attribute_02=>'P35_EXPENSE_REPORT_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(27679281052234536)
,p_event_id=>wwv_flow_api.id(27679528441234539)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Cancelled Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(27679150236234535)
,p_event_id=>wwv_flow_api.id(27679528441234539)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(5899665203168454)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(5882488453168431)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Expense Report Page'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(5899344343168454)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(5882488453168431)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Expense Report Page'
);
wwv_flow_api.component_end;
end;
/
