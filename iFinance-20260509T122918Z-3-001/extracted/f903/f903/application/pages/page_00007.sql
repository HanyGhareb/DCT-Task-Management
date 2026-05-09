prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
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
 p_id=>7
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'Projects Data'
,p_step_title=>'Projects Data'
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
'    background-color: ',
'    #0e6655;',
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
'    color: ',
'    #FFF;',
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
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_api.id(69998939970147083)
,p_last_updated_by=>'TCA282'
,p_last_upd_yyyymmddhh24miss=>'20200501145836'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(66121156744477613)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(66121750114477614)
,p_plug_name=>'Projects Data'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select F_PROJECTBUDGET.PROJECT_NUMBER as PROJECT_NUMBER,',
'    F_PROJECTBUDGET.PROJECT_CODE as PROJECT_CODE,',
'    F_PROJECTBUDGET.PROJECT_NAME as PROJECT_NAME,',
'    F_PROJECTBUDGET.TCA_SECTOR as TCA_SECTOR,',
'    F_PROJECTBUDGET.DEPARTMENT as DEPARTMENT,',
'    F_PROJECTBUDGET.STRATEGIC as STRATEGIC,',
'    F_PROJECTBUDGET.PROGRAM as PROGRAM,',
'    F_PROJECTBUDGET.OUTPUT as OUTPUT,',
'    F_PROJECTBUDGET.TASK_NUMBER as TASK_NUMBER,',
'    F_PROJECTBUDGET.CC_NAME as CC_NAME,',
'    F_PROJECTBUDGET.ACCOUNT_NAME as ACCOUNT_NAME,',
'    F_PROJECTBUDGET.TIMESTAMP as TIMESTAMP,',
'    F_PROJECTBUDGET.ACTUAL as ACTUAL,',
'    F_PROJECTBUDGET.BUDGET as BUDGET,',
'    F_PROJECTBUDGET.COST_CENTER as COST_CENTER,',
'    F_PROJECTBUDGET.ENCUMBRANCES as ENCUMBRANCES,',
'    F_PROJECTBUDGET.FUND_AVAILABLE as FUND_AVAILABLE,',
'    F_PROJECTBUDGET.NATURAL_ACCOUNT as NATURAL_ACCOUNT',
'    ,(select sum(transferred_amount)',
'        from btf_lines l',
'        where l.project_number = f_projectbudget.project_number',
'        and l.task_number = f_projectbudget.task_number',
'        and l.cost_center = f_projectbudget.cost_center',
'        and l.gl_account  = f_projectbudget.natural_account',
'        and l.tca_sector = f_projectbudget.tca_sector',
'        and l.department = F_PROJECTBUDGET.DEPARTMENT',
'        and from_to = ''TO'') Budget_addition',
'     ,(select sum(transferred_amount)',
'        from btf_lines l',
'        where l.project_number = f_projectbudget.project_number',
'        and l.task_number = f_projectbudget.task_number',
'        and l.cost_center = f_projectbudget.cost_center',
'        and l.gl_account  = f_projectbudget.natural_account',
'        and l.tca_sector = f_projectbudget.tca_sector',
'        and l.department = F_PROJECTBUDGET.DEPARTMENT',
'        and from_to = ''FROM'') Budget_Deduction',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where f_projectbudget.tca_sector in  (select btf_data_access.entity_name',
'                                            from btf_data_access',
'                                            where btf_data_access.entity_type = ''TCA_SECTOR''',
'                                            and btf_data_access.user_id = :APP_USER)'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_required_role=>'!'||wwv_flow_api.id(76610535612322773)
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(66121862850477614)
,p_name=>'Projects Data'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>66121862850477614
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66122207669477616)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66122663462477616)
,p_db_column_name=>'PROJECT_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Project Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66123074377477617)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66123472265477617)
,p_db_column_name=>'TCA_SECTOR'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66123848999477617)
,p_db_column_name=>'DEPARTMENT'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66124290170477617)
,p_db_column_name=>'STRATEGIC'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Strategic'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66124609201477617)
,p_db_column_name=>'PROGRAM'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Program'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66125084730477617)
,p_db_column_name=>'OUTPUT'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Output'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66125455716477618)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66125806073477618)
,p_db_column_name=>'CC_NAME'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66127860291477619)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>20
,p_column_identifier=>'O'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66126289353477618)
,p_db_column_name=>'ACCOUNT_NAME'
,p_display_order=>30
,p_column_identifier=>'K'
,p_column_label=>'Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66129019687477619)
,p_db_column_name=>'NATURAL_ACCOUNT'
,p_display_order=>40
,p_column_identifier=>'R'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66127488258477618)
,p_db_column_name=>'BUDGET'
,p_display_order=>60
,p_column_identifier=>'N'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66128242989477619)
,p_db_column_name=>'ENCUMBRANCES'
,p_display_order=>70
,p_column_identifier=>'P'
,p_column_label=>'Encumbrances'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66127009970477618)
,p_db_column_name=>'ACTUAL'
,p_display_order=>80
,p_column_identifier=>'M'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66128605678477619)
,p_db_column_name=>'FUND_AVAILABLE'
,p_display_order=>90
,p_column_identifier=>'Q'
,p_column_label=>'Fund Available'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66126648872477618)
,p_db_column_name=>'TIMESTAMP'
,p_display_order=>100
,p_column_identifier=>'L'
,p_column_label=>'Timestamp'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77055405485629007)
,p_db_column_name=>'BUDGET_ADDITION'
,p_display_order=>110
,p_column_identifier=>'S'
,p_column_label=>'Budget Addition'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77055575270629008)
,p_db_column_name=>'BUDGET_DEDUCTION'
,p_display_order=>120
,p_column_identifier=>'T'
,p_column_label=>'Budget Deduction'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(66129400549478781)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'661295'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:PROJECT_NAME:TCA_SECTOR:DEPARTMENT:COST_CENTER:TASK_NUMBER:NATURAL_ACCOUNT:BUDGET:ENCUMBRANCES:ACTUAL:FUND_AVAILABLE:BUDGET_ADDITION:BUDGET_DEDUCTION:'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(70688265274392794)
,p_application_user=>'TCA9051'
,p_name=>'Hany'
,p_report_seq=>10
,p_report_columns=>'PROJECT_NUMBER:PROJECT_CODE:PROJECT_NAME:TCA_SECTOR:DEPARTMENT:TASK_NUMBER:CC_NAME:NATURAL_ACCOUNT:ACCOUNT_NAME:ACTUAL:BUDGET:COST_CENTER:ENCUMBRANCES:FUND_AVAILABLE:'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(77055688633629009)
,p_plug_name=>'Projects Data -End User'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select F_PROJECTBUDGET.PROJECT_NUMBER as PROJECT_NUMBER,',
'    F_PROJECTBUDGET.PROJECT_CODE as PROJECT_CODE,',
'    F_PROJECTBUDGET.PROJECT_NAME as PROJECT_NAME,',
'    F_PROJECTBUDGET.TCA_SECTOR as TCA_SECTOR,',
'    F_PROJECTBUDGET.DEPARTMENT as DEPARTMENT,',
'    F_PROJECTBUDGET.STRATEGIC as STRATEGIC,',
'    F_PROJECTBUDGET.PROGRAM as PROGRAM,',
'    F_PROJECTBUDGET.OUTPUT as OUTPUT,',
'    F_PROJECTBUDGET.TASK_NUMBER as TASK_NUMBER,',
'    F_PROJECTBUDGET.CC_NAME as CC_NAME,',
'    F_PROJECTBUDGET.ACCOUNT_NAME as ACCOUNT_NAME,',
'    F_PROJECTBUDGET.TIMESTAMP as TIMESTAMP,',
'    F_PROJECTBUDGET.ACTUAL as ACTUAL,',
'    F_PROJECTBUDGET.BUDGET as BUDGET,',
'    F_PROJECTBUDGET.COST_CENTER as COST_CENTER,',
'    F_PROJECTBUDGET.ENCUMBRANCES as ENCUMBRANCES,',
'    F_PROJECTBUDGET.FUND_AVAILABLE as FUND_AVAILABLE,',
'    F_PROJECTBUDGET.NATURAL_ACCOUNT as NATURAL_ACCOUNT',
'    ,(select sum(transferred_amount)',
'        from btf_lines l',
'        where l.project_number = f_projectbudget.project_number',
'        and l.task_number = f_projectbudget.task_number',
'        and l.cost_center = f_projectbudget.cost_center',
'        and l.gl_account  = f_projectbudget.natural_account',
'        and l.tca_sector = f_projectbudget.tca_sector',
'        and l.department = F_PROJECTBUDGET.DEPARTMENT',
'        and from_to = ''TO'') Budget_addition',
'     ,(select sum(transferred_amount)',
'        from btf_lines l',
'        where l.project_number = f_projectbudget.project_number',
'        and l.task_number = f_projectbudget.task_number',
'        and l.cost_center = f_projectbudget.cost_center',
'        and l.gl_account  = f_projectbudget.natural_account',
'        and l.tca_sector = f_projectbudget.tca_sector',
'        and l.department = F_PROJECTBUDGET.DEPARTMENT',
'        and from_to = ''FROM'') Budget_Deduction',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
'  where f_projectbudget.project_number in (select btf_data_access.entity_name',
'                                            from btf_data_access',
'                                            where btf_data_access.entity_type = ''PROJECT''',
'                                            and btf_data_access.user_id = :APP_USER)'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_required_role=>wwv_flow_api.id(76610535612322773)
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
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
 p_id=>wwv_flow_api.id(77055751529629010)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>77055751529629010
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77055865795629011)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77055929243629012)
,p_db_column_name=>'PROJECT_CODE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Project Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77056094437629013)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77056165613629014)
,p_db_column_name=>'TCA_SECTOR'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77056290348629015)
,p_db_column_name=>'DEPARTMENT'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77056341375629016)
,p_db_column_name=>'STRATEGIC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Strategic'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77056499974629017)
,p_db_column_name=>'PROGRAM'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Program'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77056535373629018)
,p_db_column_name=>'OUTPUT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Output'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77056611002629019)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77056764701629020)
,p_db_column_name=>'CC_NAME'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77056816611629021)
,p_db_column_name=>'ACCOUNT_NAME'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77056999316629022)
,p_db_column_name=>'TIMESTAMP'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Timestamp'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77057082442629023)
,p_db_column_name=>'ACTUAL'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77057172729629024)
,p_db_column_name=>'BUDGET'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77057263486629025)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77057376654629026)
,p_db_column_name=>'ENCUMBRANCES'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Encumbrances'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77057438049629027)
,p_db_column_name=>'FUND_AVAILABLE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Fund Available'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77057525189629028)
,p_db_column_name=>'NATURAL_ACCOUNT'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77057638347629029)
,p_db_column_name=>'BUDGET_ADDITION'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Budget Addition'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77057781126629030)
,p_db_column_name=>'BUDGET_DEDUCTION'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Budget Deduction'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(77092341683014849)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'770924'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:PROJECT_NAME:DEPARTMENT:COST_CENTER:TASK_NUMBER:NATURAL_ACCOUNT:BUDGET:ENCUMBRANCES:ACTUAL:FUND_AVAILABLE:BUDGET_ADDITION:BUDGET_DEDUCTION'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'TASK_NUMBER'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'NATURAL_ACCOUNT'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(77094016631044529)
,p_report_id=>wwv_flow_api.id(77092341683014849)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'BUDGET'
,p_operator=>'!='
,p_expr=>'0'
,p_condition_sql=>'"BUDGET" != to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# != #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(77095756217072549)
,p_application_user=>'TCA100'
,p_name=>'Task Budget'
,p_description=>'Total Task Budget By Project'
,p_report_seq=>10
,p_report_type=>'GROUP_BY'
,p_report_columns=>'PROJECT_NUMBER:PROJECT_NAME:DEPARTMENT:COST_CENTER:TASK_NUMBER:NATURAL_ACCOUNT:BUDGET:ENCUMBRANCES:ACTUAL:FUND_AVAILABLE:BUDGET_ADDITION:BUDGET_DEDUCTION'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'TASK_NUMBER'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'NATURAL_ACCOUNT'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_group_by(
 p_id=>wwv_flow_api.id(77095839343072549)
,p_report_id=>wwv_flow_api.id(77095756217072549)
,p_group_by_columns=>'PROJECT_NUMBER:TASK_NUMBER'
,p_function_01=>'SUM'
,p_function_column_01=>'BUDGET'
,p_function_db_column_name_01=>'APXWS_GBFC_01'
,p_function_label_01=>'Task Budget'
,p_function_format_mask_01=>'999G999G999G999G990D00'
,p_function_sum_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
