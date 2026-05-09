prompt --application/pages/page_00023
begin
--   Manifest
--     PAGE: 00023
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
 p_id=>23
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'Transfer Request - End User'
,p_step_title=>'Transfer Request - End User'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
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
'                background-color:#0e6655;',
'                color:black;',
'                }',
'.t-Region-title{',
'            color:black;',
'            font-weighfont-weight: bold;',
'                }',
'',
'/* Custom Header color */',
'#inside-page .t-Region-header{',
'    background-color :#81d0b5;',
'    font-weighfont-weight: bold;',
'}',
'',
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
'     background-color: #cae6e3;',
'    color:#000;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200529111158'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3944797069526118)
,p_plug_name=>'<b>Recent Requests  for project# &P23_PROJECT_NUMBER.</b>'
,p_region_name=>'inside-page'
,p_icon_css_classes=>'fa-window-check fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3941894827526088)
,p_plug_name=>'Recent Project Requests Report'
,p_parent_plug_id=>wwv_flow_api.id(3944797069526118)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
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
'    decode(from_to , ''TO'' , ''Addition'' , ''Deduction'' ) from_to,',
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
'    purpose_eu,',
'    priority,',
'    request_date,',
'    required_date',
'FROM',
'    btf_end_users_req',
'where project_number = :P23_PROJECT_NUMBER',
'and created_by = :P23_CREATED_BY',
'order by creation_date desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P23_PROJECT_NUMBER,P23_CREATED_BY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Recent Project Requests Report'
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
 p_id=>wwv_flow_api.id(3941989167526089)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>3941989167526089
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2019829510619387)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2020255812619387)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2020613619619387)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Request Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2021049414619387)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2021442453619387)
,p_db_column_name=>'FROM_TO'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Add / Ded'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2021867917619388)
,p_db_column_name=>'TCA_SECTOR'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Tca Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2022250675619388)
,p_db_column_name=>'DEPARTMENT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2022683070619388)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2023019472619388)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2023444554619388)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2023845815619388)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2024296217619389)
,p_db_column_name=>'BUDGET'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2024632532619389)
,p_db_column_name=>'ENCUMBRANCES'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Encumbrances'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2025032788619389)
,p_db_column_name=>'ACTUAL'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2025497084619389)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2025839659619389)
,p_db_column_name=>'BALANCE_AFTER'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Balance After'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2026288431619389)
,p_db_column_name=>'FUND_AVAILABLE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Fund Available'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2026614327619390)
,p_db_column_name=>'FORM_NO'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'From#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2027011478619390)
,p_db_column_name=>'LINE_NO'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Line No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2027454745619390)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2027815201619390)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2028250850619390)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2028610301619391)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2029061366619391)
,p_db_column_name=>'YEAR'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2029430841619391)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Purpose'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(77115537704664606)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2029879424619391)
,p_db_column_name=>'PRIORITY'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2030272228619391)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2030661446619391)
,p_db_column_name=>'REQUIRED_DATE'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Required Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(4031961914919412)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'20310'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:FROM_TO:JUSTIFICATION:REQUEST_STATUS:TASK_NUMBER:COST_CENTER:GL_ACCOUNT:BUDGET:ACTUAL:REQUESTED_AMOUNT:PURPOSE_EU:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(75671083769570433)
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
 p_id=>wwv_flow_api.id(75671650528570436)
,p_plug_name=>'Pre-Transfer Request Details'
,p_region_name=>'inside-page'
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:t-Form--leftLabels:margin-right-none'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'BTF_END_USERS_REQ'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(75659205565291138)
,p_plug_name=>'Audit Info'
,p_region_name=>'history'
,p_parent_plug_id=>wwv_flow_api.id(75671650528570436)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65530067520255748)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76896771780965922)
,p_plug_name=>'<b>Documents<b>'
,p_region_name=>'inside-page'
,p_icon_css_classes=>'fa-files-o'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76896859089965923)
,p_plug_name=>'Document Table'
,p_parent_plug_id=>wwv_flow_api.id(76896771780965922)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       REQUEST_ID,',
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
'  from BTF_EU_DOCUMENTS',
' where REquest_id = :P23_REQUEST_ID',
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
 p_id=>wwv_flow_api.id(76897098693965925)
,p_max_row_count=>'1000000'
,p_show_nulls_as=>'-'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>76897098693965925
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76897117051965926)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76897224349965927)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76897349891965928)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Request Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76897467838965929)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.:RP,:P32_ID,P32_STATUS,P32_REQUEST_NUMBER:#ID#,&P23_REQUEST_STATUS.,&P23_REQUEST_NO.'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76897593390965930)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76897622099965931)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76897769188965932)
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
 p_id=>wwv_flow_api.id(76897855464965933)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76897968606965934)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76898079899965935)
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
 p_id=>wwv_flow_api.id(76898152173965936)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76898249150965937)
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
 p_id=>wwv_flow_api.id(76898363037965938)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76898417179965939)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76898543046965940)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:BTF_EU_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(77029856838636831)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'770299'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(77191032785990523)
,p_name=>'Action History'
,p_region_name=>'inside-page'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_icon_css_classes=>'fa-history'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_grid_column_span=>8
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ROWNUM,',
'ID,',
'       REQUEST_TYPE,',
'       REQUEST_ID,',
'       ACTION_TYPE,',
'       CREATED_BY,',
'       (select e.full_name_en',
'        from dct_employees_list2 e',
'        where e.user_name = btf_all_actions.UPDATED_BY) Employee_name,',
'       CREATED_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE',
'  from BTF_ALL_ACTIONS',
' where request_id = :P23_REQUEST_ID',
'and request_type = ''Transfer Request End User''',
' order by UPDATED_DATE'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(65567986443255766)
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77192070327990533)
,p_query_column_id=>1
,p_column_alias=>'ROWNUM'
,p_column_display_sequence=>1
,p_column_heading=>'No'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77191159053990524)
,p_query_column_id=>2
,p_column_alias=>'ID'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77191289611990525)
,p_query_column_id=>3
,p_column_alias=>'REQUEST_TYPE'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77191390164990526)
,p_query_column_id=>4
,p_column_alias=>'REQUEST_ID'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77191433275990527)
,p_query_column_id=>5
,p_column_alias=>'ACTION_TYPE'
,p_column_display_sequence=>5
,p_column_heading=>'Action Type'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77191515110990528)
,p_query_column_id=>6
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>7
,p_column_heading=>'Action By'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77191920140990532)
,p_query_column_id=>7
,p_column_alias=>'EMPLOYEE_NAME'
,p_column_display_sequence=>6
,p_column_heading=>'Employee Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77191618446990529)
,p_query_column_id=>8
,p_column_alias=>'CREATED_DATE'
,p_column_display_sequence=>8
,p_column_heading=>'Action Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77191762215990530)
,p_query_column_id=>9
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>12
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(77191804935990531)
,p_query_column_id=>10
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(153672712511126111)
,p_plug_name=>'Collaboration'
,p_region_name=>'inside-page'
,p_icon_css_classes=>'fa-comments-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:margin-left-none'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(153674496025126129)
,p_name=>'comments'
,p_parent_plug_id=>wwv_flow_api.id(153672712511126111)
,p_template=>wwv_flow_api.id(65519636948255743)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat:t-Comments--iconsSquare'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'  CASE',
'        WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'          ''http://s1defp1.dev.uae:7001/ords/dev/profile/view/'' || user_name',
'        ELSE',
'            ''#APP_IMAGES#no-photo.png''',
'    END  user_icon, ',
'  creation_date  comment_date,',
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
'(SELECT',
'    c.comment_id,',
'    c.request_id,',
'    c.comment_text,',
'    c.created_by,',
'    c.updated_by,',
'    c.creation_date,',
'    c.updated_date,',
'    c.action,',
'    e.user_name,',
'    e.photo_blob    ',
'FROM',
'    btf_end_users_req_comments c , dct_employees_list2 e',
'where c.updated_by = e.user_name    )',
'where request_id = :P23_REQUEST_ID',
'order by UPDATED_DATE desc'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P23_REQUEST_ID'
,p_query_row_template=>wwv_flow_api.id(65570572943255767)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Conversations for this Request'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76970136483965883)
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
 p_id=>wwv_flow_api.id(76970531128965883)
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
 p_id=>wwv_flow_api.id(76970921151965884)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76971328655965884)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.::P31_COMMENT_ID:#COMMENT_ID#'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76971798319965884)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76972118980965884)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76972571010965884)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76972981711965884)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76973359609965885)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76973762698965885)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76974171055965885)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76974550591965885)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>12
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(75689603891570443)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(75671083769570433)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_button_condition=>'P23_REQUEST_STATUS'
,p_button_condition2=>'Draft'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76898700542965942)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(76896771780965922)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600261178255783)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.:RP,:P32_REQUEST_ID,P32_REQUEST_NUMBER:&P23_REQUEST_ID.,&P23_REQUEST_NO.'
,p_button_condition=>'P23_REQUEST_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76969454112965882)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(153672712511126111)
,p_button_name=>'AddComment'
,p_button_static_id=>'inside-page'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600261178255783)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Comment'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.::P31_REQUEST_ID:&P23_REQUEST_ID.'
,p_button_condition=>'P23_REQUEST_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(75690473924570444)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(75671083769570433)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>'P23_REQUEST_STATUS'
,p_button_condition2=>'Draft'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-remove'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(75690803744570444)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(75671083769570433)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P23_REQUEST_STATUS'
,p_button_condition2=>'Draft'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-save'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(75691270280570444)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(75671083769570433)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P23_REQUEST_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(75659364198291139)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(75671083769570433)
,p_button_name=>'Submit'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P23_REQUEST_STATUS'
,p_button_condition2=>'Draft'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(75790818272056623)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(75671083769570433)
,p_button_name=>'Back1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP::'
,p_button_condition=>'from33'
,p_button_condition_type=>'REQUEST_NOT_EQUAL_CONDITION'
,p_icon_css_classes=>'fa-step-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(77058160980629034)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(75671083769570433)
,p_button_name=>'Back33'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.:RP::'
,p_button_condition=>'from33'
,p_button_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_icon_css_classes=>'fa-step-backward'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(75691583473570444)
,p_branch_name=>'Go To Page 22'
,p_branch_action=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'REQUEST_NOT_EQUAL_CONDITION'
,p_branch_condition=>'from33'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(77058052612629033)
,p_branch_name=>'Go33'
,p_branch_action=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.:RP:P33_STATUS:&P23_REQUEST_STATUS.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>30
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'from33'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1925923955906740)
,p_name=>'P23_REQUEST_NO_H'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75656245232291108)
,p_name=>'P23_PROJECT_NAME'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Project Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select F_PROJECTBUDGET.PROJECT_NAME as PROJECT_NAME ',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' WHERE PROJECT_NUMBER = :P23_PROJECT_NUMBER'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75657169708291117)
,p_name=>'P23_COST_CENTER_NAME'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Cost Center Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT cc_name',
'from f_projectbudget',
'where task_number = :P23_TASK_NUMBER',
'and project_number = :P23_PROJECT_NUMBER'))
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
 p_id=>wwv_flow_api.id(75657856925291124)
,p_name=>'P23_ACCOUNT_NAME'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.ACCOUNT_NAME as ACCOUNT_NAME ',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where  NATURAL_ACCOUNT = :P23_GL_ACCOUNT'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Account Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75672081726570436)
,p_name=>'P23_REQUEST_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_source=>'REQUEST_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75672478233570437)
,p_name=>'P23_REQUEST_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Request No'
,p_source=>'REQUEST_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75672895706570437)
,p_name=>'P23_REQUEST_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_default=>'Draft'
,p_prompt=>'Request Status'
,p_source=>'REQUEST_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_grid_column_css_classes=>'u-color-9-text'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75673253044570437)
,p_name=>'P23_JUSTIFICATION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Justification'
,p_placeholder=>'--(7) Enter the Justification--'
,p_source=>'JUSTIFICATION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>2000
,p_cHeight=>4
,p_read_only_when=>'P23_REQUEST_STATUS'
,p_read_only_when2=>'Submitted:Accepted:Refused'
,p_read_only_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75673656271570437)
,p_name=>'P23_FROM_TO'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'From / To'
,p_source=>'FROM_TO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:To (Additional Budget);TO,From (Deduct Budget);FROM'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- (1) Select --'
,p_cHeight=>1
,p_read_only_when=>'P23_REQUEST_STATUS'
,p_read_only_when2=>'Submitted:Accepted:Refused'
,p_read_only_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75674008422570437)
,p_name=>'P23_TCA_SECTOR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Sector'
,p_source=>'TCA_SECTOR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75674451655570437)
,p_name=>'P23_DEPARTMENT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Department'
,p_source=>'DEPARTMENT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75674833982570437)
,p_name=>'P23_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Project Number'
,p_source=>'PROJECT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select entity_name d',
', entity_name  r',
'from btf_data_access',
'where entity_type = ''PROJECT''',
'and status = ''A''',
'and user_id = :APP_USER',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'--(3) Select project --'
,p_cHeight=>1
,p_read_only_when=>'P23_REQUEST_STATUS'
,p_read_only_when2=>'Submitted:Accepted:Refused'
,p_read_only_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75675243435570438)
,p_name=>'P23_TASK_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Task Number'
,p_source=>'TASK_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P23_FROM_TO = ''TO''',
'then',
'return ''SELECT task_number d , ',
'        task_number r',
'FROM f_projectbudget ',
'where project_number = :P23_PROJECT_NUMBER'' ;',
'else ',
'',
'return    ''SELECT task_number d , ',
'        task_number r',
'FROM f_projectbudget ',
'where project_number = :P23_PROJECT_NUMBER',
'and fund_available > 0'' ;',
'',
'end if'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'--(4) Select Task--'
,p_lov_cascade_parent_items=>'P23_PROJECT_NUMBER,P23_FROM_TO'
,p_ajax_items_to_submit=>'P23_PROJECT_NUMBER,P23_FROM_TO'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_read_only_when=>'P23_REQUEST_STATUS'
,p_read_only_when2=>'Submitted:Accepted:Refused'
,p_read_only_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_help_text=>'For Budget Transfer requests with type <b>(From)</b>, only Tasks with <b>Fund Available </b> will display. '
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75675641664570438)
,p_name=>'P23_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Cost Center'
,p_source=>'COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>7
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75676081635570438)
,p_name=>'P23_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'GL Account'
,p_source=>'GL_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P23_FROM_TO = ''TO''',
'then',
'return ''select  distinct natural_account d',
', natural_account r',
'from f_projectbudget',
'where project_number = :P23_PROJECT_NUMBER',
'and task_number = :P23_TASK_NUMBER'' ;',
'else ',
'',
'return    ''select  distinct natural_account d',
', natural_account r',
'from f_projectbudget',
'where project_number = :P23_PROJECT_NUMBER',
'and task_number = :P23_TASK_NUMBER',
'and fund_available > 0'' ;',
'',
'end if'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'--(5) Select GL Account --'
,p_lov_cascade_parent_items=>'P23_TASK_NUMBER,P23_PROJECT_NUMBER,P23_FROM_TO'
,p_ajax_items_to_submit=>'P23_PROJECT_NUMBER,P23_TASK_NUMBER,P23_FROM_TO'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_read_only_when=>'P23_REQUEST_STATUS'
,p_read_only_when2=>'Submitted:Accepted:Refused'
,p_read_only_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_help_text=>'For Budget Transfer requests with type <b>(From)</b>, only GL Accounts with <b>Fund Available </b> will display. '
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75676441325570438)
,p_name=>'P23_BUDGET'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Budget'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BUDGET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'left'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75676813599570438)
,p_name=>'P23_ENCUMBRANCES'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Encumbrances'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ENCUMBRANCES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'left'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75677287708570439)
,p_name=>'P23_ACTUAL'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Actual'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ACTUAL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'left'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75677600692570439)
,p_name=>'P23_REQUESTED_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Requested Amount'
,p_placeholder=>'--(6) Enter requested amount --'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'REQUESTED_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_grid_column_css_classes=>'u-color-9-text'
,p_read_only_when=>'P23_REQUEST_STATUS'
,p_read_only_when2=>'Submitted:Accepted:Refused'
,p_read_only_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75678024355570439)
,p_name=>'P23_BALANCE_AFTER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Balance After Transfer'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BALANCE_AFTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'left'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75678490202570439)
,p_name=>'P23_FUND_AVAILABLE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Fund Available'
,p_source=>'FUND_AVAILABLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'left'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75678861278570439)
,p_name=>'P23_FORM_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Form No'
,p_source=>'FORM_NO'
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
 p_id=>wwv_flow_api.id(75679211746570439)
,p_name=>'P23_LINE_NO'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Line No'
,p_source=>'LINE_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(75679676764570439)
,p_name=>'P23_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(75659205565291138)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
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
 p_id=>wwv_flow_api.id(75680073542570439)
,p_name=>'P23_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(75659205565291138)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
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
 p_id=>wwv_flow_api.id(75680418588570440)
,p_name=>'P23_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(75659205565291138)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_prompt=>'Creation Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATION_DATE'
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
 p_id=>wwv_flow_api.id(75681289342570440)
,p_name=>'P23_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(75659205565291138)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
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
 p_id=>wwv_flow_api.id(75682062337570440)
,p_name=>'P23_YEAR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(75659205565291138)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_default=>'select extract(year from sysdate) from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Year'
,p_source=>'YEAR'
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
 p_id=>wwv_flow_api.id(75791207978056627)
,p_name=>'P23_PURPOSE_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_default=>'select value from dct_lookup_values where value_id = :P23_PURPOSE_EU'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Purpose'
,p_source=>'PURPOSE_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P23_FROM_TO = ''TO''',
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
,p_lov_null_text=>'--(2) Select Purpose --'
,p_lov_cascade_parent_items=>'P23_FROM_TO'
,p_ajax_items_to_submit=>'P23_FROM_TO'
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
 p_id=>wwv_flow_api.id(76157168630095340)
,p_name=>'P23_PRIORITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_default=>'Low'
,p_prompt=>'Priority'
,p_source=>'PRIORITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:High;High,Medium;Medium,Low;Low'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_read_only_when=>'P23_REQUEST_STATUS'
,p_read_only_when2=>'Submitted:Accepted:Refused'
,p_read_only_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76703301406160228)
,p_name=>'P23_REQUEST_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_default=>'SELECT SYSDATE FROM DUAL;'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Request Date'
,p_source=>'REQUEST_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_read_only_when=>'P23_REQUEST_STATUS'
,p_read_only_when2=>'Submitted:Accepted:Refused'
,p_read_only_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76703499716160229)
,p_name=>'P23_REQUIRED_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_source_plug_id=>wwv_flow_api.id(75671650528570436)
,p_item_default=>'SELECT SYSDATE+7 FROM DUAL;'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Required Date'
,p_source=>'REQUIRED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_read_only_when=>'P23_REQUEST_STATUS'
,p_read_only_when2=>'Submitted:Accepted:Refused'
,p_read_only_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(1925882656906739)
,p_computation_sequence=>10
,p_computation_item=>'P23_REQUEST_NO_H'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_END_USERS_REQ.REQUEST_NO as REQUEST_NO',
' from BTF_END_USERS_REQ BTF_END_USERS_REQ',
' where BTF_END_USERS_REQ.REQUEST_ID = :P23_REQUEST_ID '))
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(75680947796570440)
,p_validation_name=>'P23_CREATION_DATE must be timestamp'
,p_validation_sequence=>210
,p_validation=>'P23_CREATION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(75680418588570440)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(75681787932570440)
,p_validation_name=>'P23_UPDATED_DATE must be timestamp'
,p_validation_sequence=>220
,p_validation=>'P23_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(75681289342570440)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75656343347291109)
,p_name=>'project# Changes'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_PROJECT_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75656467094291110)
,p_event_id=>wwv_flow_api.id(75656343347291109)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_TCA_SECTOR,P23_DEPARTMENT'
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
 p_id=>wwv_flow_api.id(75656523900291111)
,p_event_id=>wwv_flow_api.id(75656343347291109)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_DEPARTMENT,P23_TCA_SECTOR,P23_PROJECT_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT distinct department , tca_sector , project_name ',
'FROM f_projectbudget where project_number = :P23_PROJECT_NUMBER;'))
,p_attribute_07=>'P23_PROJECT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75656693994291112)
,p_event_id=>wwv_flow_api.id(75656343347291109)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_TCA_SECTOR,P23_DEPARTMENT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75656751632291113)
,p_name=>'before Submit Enable'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'apexbeforepagesubmit'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75656817176291114)
,p_event_id=>wwv_flow_api.id(75656751632291113)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_TCA_SECTOR,P23_DEPARTMENT,P23_COST_CENTER,P23_BUDGET,P23_ENCUMBRANCES,P23_ACTUAL,P23_FUND_AVAILABLE,P23_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75658589310291131)
,p_name=>'Disable After Refresh'
,p_event_sequence=>30
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(75671650528570436)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75658667806291132)
,p_event_id=>wwv_flow_api.id(75658589310291131)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_TCA_SECTOR,P23_DEPARTMENT,P23_COST_CENTER,P23_BUDGET,P23_ENCUMBRANCES,P23_ACTUAL,P23_FUND_AVAILABLE,P23_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75656913811291115)
,p_name=>'Project Next Focus'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_PROJECT_NUMBER'
,p_condition_element=>'P23_PROJECT_NUMBER'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75657078373291116)
,p_event_id=>wwv_flow_api.id(75656913811291115)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_TASK_NUMBER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75657277254291118)
,p_name=>'Task# Change'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_TASK_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75657312280291119)
,p_event_id=>wwv_flow_api.id(75657277254291118)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_COST_CENTER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75657437731291120)
,p_event_id=>wwv_flow_api.id(75657277254291118)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_COST_CENTER,P23_COST_CENTER_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT cost_center , cc_name',
'from f_projectbudget',
'where task_number = :P23_TASK_NUMBER',
'and project_number = :P23_PROJECT_NUMBER'))
,p_attribute_07=>'P23_TASK_NUMBER,P23_PROJECT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75657562517291121)
,p_event_id=>wwv_flow_api.id(75657277254291118)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_COST_CENTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75657611156291122)
,p_name=>'Task Next Focus`'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_TASK_NUMBER'
,p_condition_element=>'P23_TASK_NUMBER'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75657719243291123)
,p_event_id=>wwv_flow_api.id(75657611156291122)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_GL_ACCOUNT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75657948667291125)
,p_name=>'GL Account Changes'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_GL_ACCOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75658054103291126)
,p_event_id=>wwv_flow_api.id(75657948667291125)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_BUDGET,P23_ENCUMBRANCES,P23_ACTUAL,P23_FUND_AVAILABLE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75658198749291127)
,p_event_id=>wwv_flow_api.id(75657948667291125)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_ACCOUNT_NAME,P23_BUDGET,P23_ENCUMBRANCES,P23_ACTUAL,P23_FUND_AVAILABLE'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*',
'select  ACCOUNT_NAME',
'        ,trim(to_char(budget,''FML999G999G999G999G990D00'', ''NLS_CURRENCY=''''AED '''''')) budget',
'        ,trim(to_char(encumbrances,''FML999G999G999G999G990D00'' ,''NLS_CURRENCY=''''AED '''''')) encumbrances',
'        ,trim(to_char(actual,''FML999G999G999G999G990D00'', ''NLS_CURRENCY=''''AED '''''')) actual  ',
'        ,trim(to_char(fund_available,''FML999G999G999G999G990D00'', ''NLS_CURRENCY=''''AED '''''')) fund_available',
'from f_projectbudget',
'where project_number = :P23_PROJECT_NUMBER',
'and task_number = :P23_TASK_NUMBER',
'and natural_account = :P23_GL_ACCOUNT',
'',
'*/',
'select  ACCOUNT_NAME',
'        , budget',
'        , encumbrances',
'        , actual  ',
'        , fund_available',
'from f_projectbudget',
'where project_number = :P23_PROJECT_NUMBER',
'and task_number = :P23_TASK_NUMBER',
'and natural_account = :P23_GL_ACCOUNT',
'',
'/*',
'select  ACCOUNT_NAME',
'        ,trim(to_char(budget,''999,999,999.99'')) budget',
'        ,trim(to_char(encumbrances,''999,999,999.99'')) encumbrances',
'        ,trim(to_char(actual,''999,999,999.99'')) actual  ',
'        ,trim(to_char(fund_available,''999,999,999.99'')) fund_available',
'from f_projectbudget',
'where project_number = :P23_PROJECT_NUMBER',
'and task_number = :P23_TASK_NUMBER',
'--and cost_center = :P21_COST_CENTER',
'and natural_account = :P23_GL_ACCOUNT;',
'*/'))
,p_attribute_07=>'P23_PROJECT_NUMBER,P23_TASK_NUMBER,P23_GL_ACCOUNT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75658262475291128)
,p_event_id=>wwv_flow_api.id(75657948667291125)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_BUDGET,P23_ENCUMBRANCES,P23_ACTUAL,P23_FUND_AVAILABLE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75658397363291129)
,p_name=>'Transfer Amount Change TO'
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_REQUESTED_AMOUNT'
,p_condition_element=>'P23_FROM_TO'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'TO'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75658856503291134)
,p_event_id=>wwv_flow_api.id(75658397363291129)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75658422201291130)
,p_event_id=>wwv_flow_api.id(75658397363291129)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_BALANCE_AFTER'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>wwv_flow_string.join(wwv_flow_t_varchar2(
' (Number($v(''P23_REQUESTED_AMOUNT'')) + Number($v(''P23_FUND_AVAILABLE''))).toFixed(2);',
''))
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75659105180291137)
,p_event_id=>wwv_flow_api.id(75658397363291129)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76392460511025232)
,p_name=>'Transfer Amount Change From'
,p_event_sequence=>90
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_REQUESTED_AMOUNT'
,p_condition_element=>'P23_FROM_TO'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'FROM'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76392673138025234)
,p_event_id=>wwv_flow_api.id(76392460511025232)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76392573775025233)
,p_event_id=>wwv_flow_api.id(76392460511025232)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_BALANCE_AFTER'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>wwv_flow_string.join(wwv_flow_t_varchar2(
' (Number($v(''P23_FUND_AVAILABLE'')) - Number($v(''P23_REQUESTED_AMOUNT''))).toFixed(2);',
''))
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76392764664025235)
,p_event_id=>wwv_flow_api.id(76392460511025232)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75658995147291135)
,p_name=>'From To Change'
,p_event_sequence=>100
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_FROM_TO'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75659005425291136)
,p_event_id=>wwv_flow_api.id(75658995147291135)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_REQUESTED_AMOUNT,P23_BALANCE_AFTER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75659401667291140)
,p_name=>'Submit BTF'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(75659364198291139)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75790971625056624)
,p_event_id=>wwv_flow_api.id(75659401667291140)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Are you sure to submit the request to "Finance Business Partners" section ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75659523125291141)
,p_event_id=>wwv_flow_api.id(75659401667291140)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'UPDATE btf_end_users_req',
'set request_status = ''Submitted''',
'where request_id = :P23_REQUEST_ID;',
'',
'INSERT INTO btf_all_actions (',
'    request_type , request_id , action_type',
') VALUES (',
'    ''Transfer Request End User'' , :P23_REQUEST_ID , ''Submitted''',
');'))
,p_attribute_02=>'P23_REQUEST_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75791044982056625)
,p_event_id=>wwv_flow_api.id(75659401667291140)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'your request has been submitted successfully ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75792173990056636)
,p_event_id=>wwv_flow_api.id(75659401667291140)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75791370552056628)
,p_name=>'Show Buttons when create'
,p_event_sequence=>120
,p_condition_element=>'P23_REQUEST_ID'
,p_triggering_condition_type=>'NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75791487591056629)
,p_event_id=>wwv_flow_api.id(75791370552056628)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(75659364198291139)
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75791591965056630)
,p_event_id=>wwv_flow_api.id(75791370552056628)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(75690803744570444)
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75791611226056631)
,p_event_id=>wwv_flow_api.id(75791370552056628)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(75790818272056623)
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75791722329056632)
,p_event_id=>wwv_flow_api.id(75791370552056628)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(75690473924570444)
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75941759901438603)
,p_event_id=>wwv_flow_api.id(75791370552056628)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_FROM_TO'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75941566126438601)
,p_name=>'Focus Purpose'
,p_event_sequence=>130
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_FROM_TO'
,p_condition_element=>'P23_FROM_TO'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75941606795438602)
,p_event_id=>wwv_flow_api.id(75941566126438601)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_PURPOSE_EU'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(75941800244438604)
,p_name=>'Focuse '
,p_event_sequence=>140
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_PURPOSE_EU'
,p_condition_element=>'P23_PURPOSE_EU'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(75941922286438605)
,p_event_id=>wwv_flow_api.id(75941800244438604)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_PROJECT_NUMBER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76391326638025221)
,p_name=>'Disable when Page Load'
,p_event_sequence=>150
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_display_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_display_when_cond=>'P23_REQUEST_STATUS'
,p_display_when_cond2=>'Submitted:Accepted:Refused:In-Process'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76391478556025222)
,p_event_id=>wwv_flow_api.id(76391326638025221)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_PURPOSE_EU,P23_PROJECT_NUMBER,P23_TASK_NUMBER,P23_GL_ACCOUNT,P23_PRIORITY,P23_JUSTIFICATION,P23_REQUESTED_AMOUNT,P23_REQUIRED_DATE,P23_REQUEST_DATE,P23_FROM_TO'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76896317515965918)
,p_name=>'Collaboration Dialog Close'
,p_event_sequence=>160
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(153672712511126111)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76896474806965919)
,p_event_id=>wwv_flow_api.id(76896317515965918)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(153674496025126129)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(76896542212965920)
,p_name=>'Comments Dialog Closed'
,p_event_sequence=>170
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(153674496025126129)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(76896652946965921)
,p_event_id=>wwv_flow_api.id(76896542212965920)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(153674496025126129)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(75692464140570445)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(75671650528570436)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Create Form'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_process_error_message=>'error while update Transfer Request'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Transfer Request# &P23_REQUEST_NO. process Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(76899089737965945)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'add create action'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSERT INTO btf_all_actions (',
'    request_type , request_id , action_type',
') VALUES (',
'    ''Transfer Request End User'' , :P23_REQUEST_ID , ''Created''',
');'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(75691270280570444)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(75692027578570444)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(75671650528570436)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Create Form'
);
wwv_flow_api.component_end;
end;
/
