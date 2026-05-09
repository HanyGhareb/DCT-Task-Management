prompt --application/pages/page_00033
begin
--   Manifest
--     PAGE: 00033
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
 p_id=>33
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'All End User Transfer Requests'
,p_alias=>'END-USER-REQUESTS'
,p_step_title=>'All End User Transfer Requests'
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
,p_last_updated_by=>'TCA9038'
,p_last_upd_yyyymmddhh24miss=>'20200520164030'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(77058861145629041)
,p_plug_name=>'All End User Transfer Requests'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    request_id,',
'    request_no,',
'    request_status,',
'    justification,',
'    decode(from_to, ''TO'', ''Addition'',''Deduction'') "Addition/Deduction" ,',
'    tca_sector Sector,',
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
'    (select e.full_name_en',
'from dct_employees_list2 e',
'where e.user_name = created_by) Employee_name,',
'    updated_by,',
'    creation_date,',
'    updated_date,',
'    year,',
'    purpose_eu,',
'    priority,',
'    request_date,',
'    required_date',
'FROM',
'    btf_end_users_req',
'where tca_sector in (SELECT  btf_data_access.entity_name d',
'                                                            FROM   btf_data_access',
'                                                            WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                                            and btf_data_access.user_id = :APP_USER)   ',
'AND request_status = nvl(:P33_STATUS , request_status)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P33_STATUS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_required_role=>'!'||wwv_flow_api.id(76610535612322773)
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
 p_id=>wwv_flow_api.id(77059029802629043)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>77059029802629043
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77059169004629044)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77059276868629045)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77059350877629046)
,p_db_column_name=>'REQUIRED_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Required Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77059471787629047)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Request No'
,p_column_link=>'f?p=&APP_ID.:23:&SESSION.:from33:&DEBUG.::P23_REQUEST_ID:#REQUEST_ID#'
,p_column_linktext=>'#REQUEST_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77059539326629048)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77059617393629049)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77059760821629050)
,p_db_column_name=>'Addition/Deduction'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Add/Ded'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77188882028990501)
,p_db_column_name=>'SECTOR'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77188959326990502)
,p_db_column_name=>'DEPARTMENT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Department'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77189054385990503)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77189119543990504)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77189225468990505)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77189303938990506)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77189424631990507)
,p_db_column_name=>'BUDGET'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77189533675990508)
,p_db_column_name=>'ENCUMBRANCES'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Encumbrances'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77189682100990509)
,p_db_column_name=>'ACTUAL'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77189730707990510)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77189823796990511)
,p_db_column_name=>'BALANCE_AFTER'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Balance After'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77189908737990512)
,p_db_column_name=>'FUND_AVAILABLE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Fund Available'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77190076615990513)
,p_db_column_name=>'FORM_NO'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Form No'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77190159791990514)
,p_db_column_name=>'LINE_NO'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Line No'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77190243587990515)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77190352440990516)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77190407669990517)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77190592612990518)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77190633234990519)
,p_db_column_name=>'YEAR'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77190769006990520)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Purpose'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(77115537704664606)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77190877261990521)
,p_db_column_name=>'PRIORITY'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7280881424257415)
,p_db_column_name=>'EMPLOYEE_NAME'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(77205248974049428)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'772053'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DEPARTMENT:REQUEST_NO:EMPLOYEE_NAME:Addition/Deduction:REQUEST_STATUS:JUSTIFICATION:PROJECT_NUMBER:TASK_NUMBER:COST_CENTER:GL_ACCOUNT:PURPOSE_EU:REQUEST_DATE:BUDGET:FUND_AVAILABLE:REQUESTED_AMOUNT:BALANCE_AFTER:'
,p_sort_column_1=>'UPDATED_DATE'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_break_on=>'SECTOR:DEPARTMENT'
,p_count_columns_on_break=>'REQUEST_NO'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(77099235954206977)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65554277731255756)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(65494572154255667)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(65602363670255785)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(77099865884206978)
,p_plug_name=>'All End User Transfer Requests'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    request_id,',
'    request_no,',
'    request_status,',
'    justification,',
'    decode(from_to, ''TO'', ''Addition'',''Deduction'') "Addition/Deduction" ,',
'    tca_sector Sector,',
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
'    purpose_eu,',
'    priority,',
'    request_date,',
'    required_date',
'FROM',
'    btf_end_users_req',
'where project_number in (SELECT  btf_data_access.entity_name d',
'                                                            FROM   btf_data_access',
'                                                            WHERE btf_data_access.entity_type = ''PROJECT''',
'                                                            and btf_data_access.user_id = :APP_USER)   ',
'AND request_status = nvl(:P33_STATUS , request_status)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P33_STATUS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_required_role=>wwv_flow_api.id(76610535612322773)
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(77099968531206978)
,p_name=>'All End User Transfer Requests'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>77099968531206978
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77100398090206980)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77100724353206980)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Request No'
,p_column_link=>'f?p=&APP_ID.:23:&SESSION.:from33:&DEBUG.::P23_REQUEST_ID:#REQUEST_ID#'
,p_column_linktext=>'#REQUEST_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77101174628206980)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77101568736206981)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77101966040206981)
,p_db_column_name=>'Addition/Deduction'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Add/Ded'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77102367515206981)
,p_db_column_name=>'SECTOR'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77102722981206981)
,p_db_column_name=>'DEPARTMENT'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Department'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77103117733206981)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77103578491206981)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77103914517206982)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77104305600206982)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77104777531206982)
,p_db_column_name=>'BUDGET'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77105112983206982)
,p_db_column_name=>'ENCUMBRANCES'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Encumbrances'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77105520172206983)
,p_db_column_name=>'ACTUAL'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77105997506206983)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77106360816206983)
,p_db_column_name=>'BALANCE_AFTER'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Balance After'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77106700705206983)
,p_db_column_name=>'FUND_AVAILABLE'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Fund Available'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77107166627206983)
,p_db_column_name=>'FORM_NO'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Form No'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77107523204206983)
,p_db_column_name=>'LINE_NO'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Line No'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77107902139206984)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77108366803206984)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77108710648206984)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77109123804206985)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77109573969206985)
,p_db_column_name=>'YEAR'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77109980224206985)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Purpose'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(77115537704664606)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77110390113206985)
,p_db_column_name=>'PRIORITY'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77110744389206985)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77111160865206986)
,p_db_column_name=>'REQUIRED_DATE'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Required Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(77112794876265711)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_alias=>'771128'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_view_mode=>'REPORT'
,p_report_columns=>'PROJECT_NUMBER:REQUEST_NO:Addition/Deduction:REQUEST_STATUS:JUSTIFICATION:TASK_NUMBER:COST_CENTER:GL_ACCOUNT:PURPOSE_EU:REQUEST_DATE:BUDGET:ENCUMBRANCES:ACTUAL:FUND_AVAILABLE:REQUESTED_AMOUNT:BALANCE_AFTER:'
,p_sort_column_1=>'CREATION_DATE'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_break_on=>'PROJECT_NUMBER:0:0:0:0:0'
,p_break_enabled_on=>'PROJECT_NUMBER:0:0:0:0:0'
,p_chart_type=>'pie'
,p_chart_label_column=>'APXWS_CC_001'
,p_chart_value_column=>'REQUESTED_AMOUNT'
,p_chart_aggregate=>'COUNT'
,p_chart_sorting=>'DEFAULT'
,p_chart_orientation=>'vertical'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(77121290287777690)
,p_report_id=>wwv_flow_api.id(77112794876265711)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'TO_CHAR(  AA, ''MONTH'')'
,p_column_type=>'STRING'
,p_column_label=>'Mon'
,p_report_label=>'Mon'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(77057998650629032)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(77099235954206977)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP::'
,p_icon_css_classes=>'fa-step-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(77057843629629031)
,p_name=>'P33_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(77099865884206978)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(77058942209629042)
,p_name=>'P33_STATUS_1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(77058861145629041)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
