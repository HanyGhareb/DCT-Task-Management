prompt --application/pages/page_00040
begin
--   Manifest
--     PAGE: 00040
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
 p_id=>40
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Expense Report 3'
,p_alias=>'EXPENSE-REPORT-31'
,p_step_title=>'Expense Report 3'
,p_allow_duplicate_submissions=>'N'
,p_reload_on_submit=>'A'
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
'}'))
,p_step_template=>wwv_flow_api.id(8013029938175491)
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200915152733'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6177601064764875)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6179002376764876)
,p_plug_name=>'Search'
,p_region_css_classes=>'search-region padding-md'
,p_region_template_options=>'#DEFAULT#:t-Form--stretchInputs'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8030481219175499)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_02'
,p_query_type=>'SQL'
,p_plug_query_num_rows=>15
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(6179841395764877)
,p_name=>'Master Records'
,p_template=>wwv_flow_api.id(8030604591175499)
,p_display_sequence=>20
,p_region_css_classes=>'search-results'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'t-MediaList--showDesc:t-MediaList--stack'
,p_display_point=>'REGION_POSITION_02'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select "EXPENSE_REPORT_ID",',
'    null link_class,',
'    apex_page.get_url(p_items => ''P40_EXPENSE_REPORT_ID'', p_values => "EXPENSE_REPORT_ID") link,',
'    null icon_class,',
'    null link_attr,',
'    null icon_color_class,',
'    case when nvl(:P40_EXPENSE_REPORT_ID,''0'') = "EXPENSE_REPORT_ID"',
'      then ''is-active'' ',
'      else '' ''',
'    end list_class,',
'    substr("EXPENSE_REPORT_NUM", 1, 50)||( case when length("EXPENSE_REPORT_NUM") > 50 then ''...'' end ) list_title,',
'    substr("EMPLOYEE_NUM", 1, 50)||( case when length("EMPLOYEE_NUM") > 50 then ''...'' end ) list_text,',
'    null list_badge',
'from "HRSS_EXPENSE_REPORTS" x',
'where (:P40_SEARCH is null',
'        or upper(x."EXPENSE_REPORT_NUM") like ''%''||upper(:P40_SEARCH)||''%''',
'        or upper(x."EMPLOYEE_NUM") like ''%''||upper(:P40_SEARCH)||''%''',
'    )',
'order by "EXPENSE_REPORT_NUM"'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P40_SEARCH'
,p_query_row_template=>wwv_flow_api.id(8073304490175512)
,p_query_num_rows=>1000
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'<div class="u-tC">No Records Found</div>'
,p_query_row_count_max=>500
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6180502937764882)
,p_query_column_id=>1
,p_column_alias=>'EXPENSE_REPORT_ID'
,p_column_display_sequence=>1
,p_column_heading=>'Expense Report Id'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6180864589764883)
,p_query_column_id=>2
,p_column_alias=>'LINK_CLASS'
,p_column_display_sequence=>2
,p_column_heading=>'Link Class'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6181301234764883)
,p_query_column_id=>3
,p_column_alias=>'LINK'
,p_column_display_sequence=>3
,p_column_heading=>'Link'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6181696788764883)
,p_query_column_id=>4
,p_column_alias=>'ICON_CLASS'
,p_column_display_sequence=>4
,p_column_heading=>'Icon Class'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6182147221764883)
,p_query_column_id=>5
,p_column_alias=>'LINK_ATTR'
,p_column_display_sequence=>5
,p_column_heading=>'Link Attr'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6182517784764883)
,p_query_column_id=>6
,p_column_alias=>'ICON_COLOR_CLASS'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Color Class'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6182875069764884)
,p_query_column_id=>7
,p_column_alias=>'LIST_CLASS'
,p_column_display_sequence=>7
,p_column_heading=>'List Class'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6183299675764884)
,p_query_column_id=>8
,p_column_alias=>'LIST_TITLE'
,p_column_display_sequence=>8
,p_column_heading=>'List Title'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6183662068764884)
,p_query_column_id=>9
,p_column_alias=>'LIST_TEXT'
,p_column_display_sequence=>9
,p_column_heading=>'List Text'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6184154651764884)
,p_query_column_id=>10
,p_column_alias=>'LIST_BADGE'
,p_column_display_sequence=>10
,p_column_heading=>'List Badge'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(6187534478764891)
,p_name=>'Hrss Expense Reports'
,p_template=>wwv_flow_api.id(8057862405175507)
,p_display_sequence=>10
,p_region_css_classes=>'js-master-region'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-AVPList--leftAligned'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'HRSS_EXPENSE_REPORTS'
,p_query_where=>'"EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'
,p_include_rowid_column=>false
,p_display_when_condition=>'P40_EXPENSE_REPORT_ID'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(8078743525175514)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Record Selected'
,p_query_row_count_max=>500
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6188062264764893)
,p_query_column_id=>1
,p_column_alias=>'EXPENSE_REPORT_ID'
,p_column_display_sequence=>1
,p_column_heading=>'Expense Report Id'
,p_heading_alignment=>'LEFT'
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "EXPENSE_REPORT_ID" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6188556488764893)
,p_query_column_id=>2
,p_column_alias=>'PETTY_CASH_ID'
,p_column_display_sequence=>2
,p_column_heading=>'Petty Cash Id'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "PETTY_CASH_ID" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6188898992764894)
,p_query_column_id=>3
,p_column_alias=>'EXPENSE_REPORT_DATE'
,p_column_display_sequence=>3
,p_column_heading=>'Expense Report Date'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "EXPENSE_REPORT_DATE" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6189359316764894)
,p_query_column_id=>4
,p_column_alias=>'PURPOSE'
,p_column_display_sequence=>4
,p_column_heading=>'Purpose'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "PURPOSE" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6189712526764894)
,p_query_column_id=>5
,p_column_alias=>'APPROVAL_STATUS'
,p_column_display_sequence=>5
,p_column_heading=>'Approval Status'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "APPROVAL_STATUS" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6190120332764894)
,p_query_column_id=>6
,p_column_alias=>'INVOICING_YN'
,p_column_display_sequence=>6
,p_column_heading=>'Invoicing Yn'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "INVOICING_YN" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6190499258764894)
,p_query_column_id=>7
,p_column_alias=>'PRIORITY'
,p_column_display_sequence=>7
,p_column_heading=>'Priority'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "PRIORITY" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6190919551764894)
,p_query_column_id=>8
,p_column_alias=>'JUSTIFICATION'
,p_column_display_sequence=>8
,p_column_heading=>'Justification'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "JUSTIFICATION" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6191303955764895)
,p_query_column_id=>9
,p_column_alias=>'COMMENT_TO_APPROVER'
,p_column_display_sequence=>9
,p_column_heading=>'Comment To Approver'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "COMMENT_TO_APPROVER" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6191695366764895)
,p_query_column_id=>10
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>10
,p_column_heading=>'Creation Date'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "CREATION_DATE" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6192154549764895)
,p_query_column_id=>11
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>11
,p_column_heading=>'Created By'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "CREATED_BY" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6192512746764895)
,p_query_column_id=>12
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>12
,p_column_heading=>'Updated By'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "UPDATED_BY" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6192895709764895)
,p_query_column_id=>13
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>13
,p_column_heading=>'Updated Date'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "UPDATED_DATE" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6193340847764896)
,p_query_column_id=>14
,p_column_alias=>'YEAR'
,p_column_display_sequence=>14
,p_column_heading=>'Year'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "YEAR" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6193747634764896)
,p_query_column_id=>15
,p_column_alias=>'EXPENSE_REPORT_NUM'
,p_column_display_sequence=>15
,p_column_heading=>'Expense Report Num'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "EXPENSE_REPORT_NUM" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6194152931764896)
,p_query_column_id=>16
,p_column_alias=>'PAID_YN'
,p_column_display_sequence=>16
,p_column_heading=>'Paid Yn'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "PAID_YN" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6194545847764896)
,p_query_column_id=>17
,p_column_alias=>'TYPE'
,p_column_display_sequence=>17
,p_column_heading=>'Type'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "TYPE" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6194960774764896)
,p_query_column_id=>18
,p_column_alias=>'EMP_ORG_ID'
,p_column_display_sequence=>18
,p_column_heading=>'Emp Org Id'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "EMP_ORG_ID" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6195336281764896)
,p_query_column_id=>19
,p_column_alias=>'EMPLOYEE_NUM'
,p_column_display_sequence=>19
,p_column_heading=>'Employee Num'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "HRSS_EXPENSE_REPORTS"',
'where "EMPLOYEE_NUM" is not null',
'and "EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'))
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6207826434764906)
,p_plug_name=>'Region Display Selector'
,p_region_css_classes=>'js-detail-rds'
,p_region_template_options=>'#DEFAULT#:margin-bottom-md'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8030481219175499)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source_type=>'NATIVE_DISPLAY_SELECTOR'
,p_plug_query_num_rows=>15
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P40_EXPENSE_REPORT_ID'
,p_attribute_01=>'STANDARD'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(6208217815764906)
,p_name=>'Hrss Expense Report Lines'
,p_template=>wwv_flow_api.id(8057862405175507)
,p_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_css_classes=>'js-detail-region'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_component_template_options=>'t-Report--stretch:#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--inline'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'HRSS_EXPENSE_REPORT_LINES'
,p_query_where=>'"EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'
,p_include_rowid_column=>true
,p_display_when_condition=>'P40_EXPENSE_REPORT_ID'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
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
 p_id=>wwv_flow_api.id(6208967628764909)
,p_query_column_id=>1
,p_column_alias=>'ROWID'
,p_column_display_sequence=>1
,p_column_heading=>'<span class="u-VisuallyHidden">Edit</span>'
,p_column_link=>'f?p=&APP_ID.:42:&APP_SESSION.::&DEBUG.:RP:P42_ROWID:#ROWID#'
,p_column_linktext=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_heading_alignment=>'LEFT'
,p_report_column_width=>32
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6209398132764909)
,p_query_column_id=>2
,p_column_alias=>'LINE_ID'
,p_column_display_sequence=>2
,p_column_heading=>'Line Id'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6209805344764909)
,p_query_column_id=>3
,p_column_alias=>'EXPENSE_REPORT_ID'
,p_column_display_sequence=>3
,p_column_heading=>'Expense Report Id'
,p_heading_alignment=>'LEFT'
,p_hidden_column=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6210261431764910)
,p_query_column_id=>4
,p_column_alias=>'EXPENSE_DATE'
,p_column_display_sequence=>4
,p_column_heading=>'Expense Date'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6210608351764910)
,p_query_column_id=>5
,p_column_alias=>'RECEIPT_AMOUNT'
,p_column_display_sequence=>5
,p_column_heading=>'Receipt Amount'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6211056682764910)
,p_query_column_id=>6
,p_column_alias=>'EXPENSE_TYPE'
,p_column_display_sequence=>6
,p_column_heading=>'Expense Type'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6211393292764910)
,p_query_column_id=>7
,p_column_alias=>'JUSTIFICATION'
,p_column_display_sequence=>7
,p_column_heading=>'Justification'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6211812268764910)
,p_query_column_id=>8
,p_column_alias=>'COMMENT_TO_APPROVER'
,p_column_display_sequence=>8
,p_column_heading=>'Comment To Approver'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6212215658764910)
,p_query_column_id=>9
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>9
,p_column_heading=>'Creation Date'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6212612707764911)
,p_query_column_id=>10
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>10
,p_column_heading=>'Created By'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6213042626764911)
,p_query_column_id=>11
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>11
,p_column_heading=>'Updated By'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6213451083764911)
,p_query_column_id=>12
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>12
,p_column_heading=>'Updated Date'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(6234546973764944)
,p_name=>'Expense Report Documents'
,p_template=>wwv_flow_api.id(8057862405175507)
,p_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_css_classes=>'js-detail-region'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_component_template_options=>'t-Report--stretch:#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--inline'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'EXPENSE_REPORT_DOCUMENTS'
,p_query_where=>'"EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'
,p_include_rowid_column=>true
,p_display_when_condition=>'P40_EXPENSE_REPORT_ID'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
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
 p_id=>wwv_flow_api.id(6235316099764947)
,p_query_column_id=>1
,p_column_alias=>'ROWID'
,p_column_display_sequence=>1
,p_column_heading=>'<span class="u-VisuallyHidden">Edit</span>'
,p_column_link=>'f?p=&APP_ID.:43:&APP_SESSION.::&DEBUG.:RP:P43_ROWID:#ROWID#'
,p_column_linktext=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_heading_alignment=>'LEFT'
,p_report_column_width=>32
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6235687131764947)
,p_query_column_id=>2
,p_column_alias=>'ID'
,p_column_display_sequence=>2
,p_column_heading=>'Id'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6236080428764947)
,p_query_column_id=>3
,p_column_alias=>'ROW_VERSION_NUMBER'
,p_column_display_sequence=>3
,p_column_heading=>'Row Version Number'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6236501640764948)
,p_query_column_id=>4
,p_column_alias=>'EXPENSE_REPORT_ID'
,p_column_display_sequence=>4
,p_column_heading=>'Expense Report Id'
,p_heading_alignment=>'LEFT'
,p_hidden_column=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6236939268764948)
,p_query_column_id=>5
,p_column_alias=>'FILENAME'
,p_column_display_sequence=>5
,p_column_heading=>'Filename'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6237331520764948)
,p_query_column_id=>6
,p_column_alias=>'FILE_MIMETYPE'
,p_column_display_sequence=>6
,p_column_heading=>'File Mimetype'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6237674698764948)
,p_query_column_id=>7
,p_column_alias=>'FILE_CHARSET'
,p_column_display_sequence=>7
,p_column_heading=>'File Charset'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6238103169764948)
,p_query_column_id=>8
,p_column_alias=>'FILE_BLOB'
,p_column_display_sequence=>8
,p_column_heading=>'File Blob'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6238505724764948)
,p_query_column_id=>9
,p_column_alias=>'FILE_COMMENTS'
,p_column_display_sequence=>9
,p_column_heading=>'File Comments'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6238899299764949)
,p_query_column_id=>10
,p_column_alias=>'TAGS'
,p_column_display_sequence=>10
,p_column_heading=>'Tags'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6239269362764949)
,p_query_column_id=>11
,p_column_alias=>'CREATED'
,p_column_display_sequence=>11
,p_column_heading=>'Created'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6239756910764949)
,p_query_column_id=>12
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>12
,p_column_heading=>'Created By'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6240118949764949)
,p_query_column_id=>13
,p_column_alias=>'UPDATED'
,p_column_display_sequence=>13
,p_column_heading=>'Updated'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6240524984764950)
,p_query_column_id=>14
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>14
,p_column_heading=>'Updated By'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(6263601972764992)
,p_name=>'Hrss Expense Report Comments'
,p_template=>wwv_flow_api.id(8057862405175507)
,p_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_css_classes=>'js-detail-region'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_component_template_options=>'t-Report--stretch:#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--inline'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'HRSS_EXPENSE_REPORT_COMMENTS'
,p_query_where=>'"EXPENSE_REPORT_ID" = :P40_EXPENSE_REPORT_ID'
,p_include_rowid_column=>true
,p_display_when_condition=>'P40_EXPENSE_REPORT_ID'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
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
 p_id=>wwv_flow_api.id(6264343412764994)
,p_query_column_id=>1
,p_column_alias=>'ROWID'
,p_column_display_sequence=>1
,p_column_heading=>'<span class="u-VisuallyHidden">Edit</span>'
,p_column_link=>'f?p=&APP_ID.:44:&APP_SESSION.::&DEBUG.:RP:P44_ROWID:#ROWID#'
,p_column_linktext=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_heading_alignment=>'LEFT'
,p_report_column_width=>32
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6264760195764994)
,p_query_column_id=>2
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>2
,p_column_heading=>'Comment Id'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6265066190764994)
,p_query_column_id=>3
,p_column_alias=>'EXPENSE_REPORT_ID'
,p_column_display_sequence=>3
,p_column_heading=>'Expense Report Id'
,p_heading_alignment=>'LEFT'
,p_hidden_column=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6265552935764995)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6265919048764995)
,p_query_column_id=>5
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>5
,p_column_heading=>'Created By'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6266358752764995)
,p_query_column_id=>6
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>6
,p_column_heading=>'Updated By'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6266715695764995)
,p_query_column_id=>7
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>7
,p_column_heading=>'Creation Date'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6267124907764995)
,p_query_column_id=>8
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>8
,p_column_heading=>'Updated Date'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6267520432764996)
,p_query_column_id=>9
,p_column_alias=>'ACTION'
,p_column_display_sequence=>9
,p_column_heading=>'Action'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(6285601523765028)
,p_name=>'Expense Report All Actions'
,p_template=>wwv_flow_api.id(8057862405175507)
,p_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_css_classes=>'js-detail-region'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_component_template_options=>'t-Report--stretch:#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--inline'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'EXPENSE_REPORT_ALL_ACTIONS'
,p_query_where=>'"ID" = :P40_EXPENSE_REPORT_ID'
,p_include_rowid_column=>true
,p_display_when_condition=>'P40_EXPENSE_REPORT_ID'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
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
 p_id=>wwv_flow_api.id(6286436828765030)
,p_query_column_id=>1
,p_column_alias=>'ROWID'
,p_column_display_sequence=>1
,p_column_heading=>'<span class="u-VisuallyHidden">Edit</span>'
,p_column_link=>'f?p=&APP_ID.:45:&APP_SESSION.::&DEBUG.:RP:P45_ROWID:#ROWID#'
,p_column_linktext=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_heading_alignment=>'LEFT'
,p_report_column_width=>32
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6286816951765030)
,p_query_column_id=>2
,p_column_alias=>'ID'
,p_column_display_sequence=>2
,p_column_heading=>'Id'
,p_heading_alignment=>'LEFT'
,p_hidden_column=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6287180344765036)
,p_query_column_id=>3
,p_column_alias=>'REQUEST_TYPE'
,p_column_display_sequence=>3
,p_column_heading=>'Request Type'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6287578956765036)
,p_query_column_id=>4
,p_column_alias=>'REQUEST_ID'
,p_column_display_sequence=>4
,p_column_heading=>'Request Id'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6287974422765036)
,p_query_column_id=>5
,p_column_alias=>'ACTION_TYPE'
,p_column_display_sequence=>5
,p_column_heading=>'Action Type'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6288430870765037)
,p_query_column_id=>6
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>6
,p_column_heading=>'Created By'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6288778968765037)
,p_query_column_id=>7
,p_column_alias=>'CREATED_DATE'
,p_column_display_sequence=>7
,p_column_heading=>'Created Date'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6289206185765037)
,p_query_column_id=>8
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>8
,p_column_heading=>'Updated By'
,p_heading_alignment=>'LEFT'
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
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6289619527765037)
,p_query_column_id=>9
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>9
,p_column_heading=>'Updated Date'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6307704363765072)
,p_plug_name=>'No Record Selected'
,p_region_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8030481219175499)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>'No Record Selected'
,p_plug_query_num_rows=>15
,p_plug_display_condition_type=>'ITEM_IS_NULL'
,p_plug_display_when_condition=>'P40_EXPENSE_REPORT_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6218067478764914)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(6208217815764906)
,p_button_name=>'POP_HRSS_EXPENSE_REPORT_LINES'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(8119283245175532)
,p_button_image_alt=>'Add Hrss Expense Report Lines'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&APP_SESSION.::&DEBUG.:RP,42:P42_EXPENSE_REPORT_ID:&P40_EXPENSE_REPORT_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6245822561764954)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(6234546973764944)
,p_button_name=>'POP_EXPENSE_REPORT_DOCUMENTS'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(8119283245175532)
,p_button_image_alt=>'Add Expense Report Documents'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:43:&APP_SESSION.::&DEBUG.:RP,43:P43_EXPENSE_REPORT_ID:&P40_EXPENSE_REPORT_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6271278333764998)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(6263601972764992)
,p_button_name=>'POP_HRSS_EXPENSE_REPORT_COMMENTS'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(8119283245175532)
,p_button_image_alt=>'Add Hrss Expense Report Comments'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:44:&APP_SESSION.::&DEBUG.:RP,44:P44_EXPENSE_REPORT_ID:&P40_EXPENSE_REPORT_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6293411392765040)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(6285601523765028)
,p_button_name=>'POP_EXPENSE_REPORT_ALL_ACTIONS'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(8119283245175532)
,p_button_image_alt=>'Add Expense Report All Actions'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:45:&APP_SESSION.::&DEBUG.:RP,45:P45_ID:&P40_EXPENSE_REPORT_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6308194605765072)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(6187534478764891)
,p_button_name=>'EDIT'
,p_button_static_id=>'edit_master_btn'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_image_alt=>'Edit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:41:&APP_SESSION.::&DEBUG.:RP,41:P41_EXPENSE_REPORT_ID:&P40_EXPENSE_REPORT_ID.'
,p_icon_css_classes=>'fa-pencil-square-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6178308616764875)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(6177601064764875)
,p_button_name=>'RESET'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft:t-Button--gapRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_image_alt=>'Reset'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:40:&APP_SESSION.:RESET:&DEBUG.:RP,40::'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6178756932764876)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(6177601064764875)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:41:&APP_SESSION.::&DEBUG.:RP,41::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6179383068764876)
,p_name=>'P40_SEARCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(6179002376764876)
,p_prompt=>'Search'
,p_placeholder=>'Search...'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(8118738374175531)
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
 p_id=>wwv_flow_api.id(6207451452764906)
,p_name=>'P40_EXPENSE_REPORT_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(6187534478764891)
,p_display_as=>'NATIVE_HIDDEN'
,p_lov_display_extra=>'NO'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6308512523765073)
,p_name=>'Edit Master Record'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(6187534478764891)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6309065103765073)
,p_event_id=>wwv_flow_api.id(6308512523765073)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(6187534478764891)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6309660467765073)
,p_event_id=>wwv_flow_api.id(6308512523765073)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(''Hrss\u0020Expense\u0020Reports\u0020updated'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6208284882764907)
,p_name=>'Refresh on Dialog Close'
,p_event_sequence=>40
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(6208217815764906)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6218784091764915)
,p_event_id=>wwv_flow_api.id(6208284882764907)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(6208217815764906)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6219289002764915)
,p_event_id=>wwv_flow_api.id(6208284882764907)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(''Hrss Expense Report Lines updated'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6234581724764944)
,p_name=>'Refresh on Dialog Close'
,p_event_sequence=>40
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(6234546973764944)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6246532821764954)
,p_event_id=>wwv_flow_api.id(6234581724764944)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(6234546973764944)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6247007741764954)
,p_event_id=>wwv_flow_api.id(6234581724764944)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(''Expense Report Documents updated'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6263691903764992)
,p_name=>'Refresh on Dialog Close'
,p_event_sequence=>40
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(6263601972764992)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6272035746765000)
,p_event_id=>wwv_flow_api.id(6263691903764992)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(6263601972764992)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6272486128765000)
,p_event_id=>wwv_flow_api.id(6263691903764992)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(''Hrss Expense Report Comments updated'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6285748540765028)
,p_name=>'Refresh on Dialog Close'
,p_event_sequence=>40
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(6285601523765028)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6294102144765040)
,p_event_id=>wwv_flow_api.id(6285748540765028)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(6285601523765028)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6294600394765040)
,p_event_id=>wwv_flow_api.id(6285748540765028)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(''Expense Report All Actions updated'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6308630537765073)
,p_name=>'Perform Search'
,p_event_sequence=>150
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P40_SEARCH'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === apex.jQuery.ui.keyCode.ENTER'
,p_bind_type=>'bind'
,p_bind_event_type=>'keypress'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6310444826765074)
,p_event_id=>wwv_flow_api.id(6308630537765073)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(6179841395764877)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6310907941765074)
,p_event_id=>wwv_flow_api.id(6308630537765073)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CANCEL_EVENT'
);
wwv_flow_api.component_end;
end;
/
