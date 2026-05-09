prompt --application/pages/page_00041
begin
--   Manifest
--     PAGE: 00041
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>41
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Projects Balances'
,p_alias=>'PROJECTS-BALANCES'
,p_step_title=>'Projects Balances'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240125095520'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(95251076140426826)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99766883142410755)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(99703488427410717)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(99820961719410781)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(95250480552426826)
,p_plug_name=>'Projects Balances'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PROJECT_NUMBER, PROJECT_NAME, TASK_NUMBER, FUTURE2, COST_CENTER, COST_CENTER_NAME, EXPENDITURE_TYPE, BUDGET, ACTUAL, ENCUMBERANCE, FUND_AVAILABLE, FROM_PENDING_BALANCE, TO_PENDING_BALANCE',
'from ',
'(SELECT',
'    pb.project_number,',
'    p.project_name,',
'    pb.task_number,',
'    (Select t.future2',
'     From Task t',
'     where t.project_number = pb.project_number ',
'     and t.task_number = pb.task_number',
'     and rownum = 1) Future2,',
'    pb.cost_center,',
'    user_details.get_cost_center_name(pb.cost_center)                                                                                                         cost_center_name,',
'    pb.expenditure_type,',
'    pb.budget,',
'    pb.actual,',
'    pb.encumberance,',
'    pb.fund_available,',
'    btf_eu_util.get_pending_balance(''FROM'', pb.project_number, pb.task_number, pb.expenditure_type, substr(pb.expenditure_type, 1,',
'    6))                           from_pending_balance,',
'    btf_eu_util.get_pending_balance(''TO'', pb.project_number, pb.task_number, pb.expenditure_type, substr(pb.expenditure_type, 1, 6))                             to_pending_balance',
'FROM',
'    project_balances  pb,',
'    project           p',
'WHERE',
'        pb.project_number = p.project_number (+)',
'    AND pb.accounting_year = nvl(:P41_ACCOUNTING_YEAR, pb.accounting_year)',
'ORDER BY',
'    pb.project_number,',
'    pb.task_number,',
'    pb.expenditure_type)',
'where   FUTURE2 is not null  ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P41_ACCOUNTING_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Projects Balances'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(95250386390426826)
,p_name=>'Projects Balances'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>118033645998757806
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95250000709426834)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Project Number'
,p_column_link=>'f?p=&APP_ID.:46:&SESSION.::&DEBUG.:46:P46_PROJECT_NUMBER:#PROJECT_NUMBER#'
,p_column_linktext=>'#PROJECT_NUMBER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95249559509426835)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95249223839426835)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95248812042426835)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95248355282426835)
,p_db_column_name=>'BUDGET'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95247998174426835)
,p_db_column_name=>'ACTUAL'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95247571018426836)
,p_db_column_name=>'ENCUMBERANCE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Encumberance'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95247190689426836)
,p_db_column_name=>'FUND_AVAILABLE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Fund Available'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95595361075377225)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>18
,p_column_identifier=>'I'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95595244892377224)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>28
,p_column_identifier=>'J'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95595175336377223)
,p_db_column_name=>'FROM_PENDING_BALANCE'
,p_display_order=>38
,p_column_identifier=>'K'
,p_column_label=>'Deduction Pending Balance'
,p_column_link=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.:34:P34_FROM_TO,P34_PROJECT_NUMBER,P34_TASK_NUMBER,P34_EXPENDITURE_TYPE,P34_PAGE_FROM:FROM,#PROJECT_NUMBER#,#TASK_NUMBER#,#EXPENDITURE_TYPE#,41'
,p_column_linktext=>'#FROM_PENDING_BALANCE#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(95595121086377222)
,p_db_column_name=>'TO_PENDING_BALANCE'
,p_display_order=>48
,p_column_identifier=>'L'
,p_column_label=>'Additional Pending Balance'
,p_column_link=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.:34:P34_FROM_TO,P34_PAGE_FROM,P34_PROJECT_NUMBER,P34_TASK_NUMBER,P34_EXPENDITURE_TYPE:TO,41,#PROJECT_NUMBER#,#TASK_NUMBER#,#EXPENDITURE_TYPE#'
,p_column_linktext=>'#TO_PENDING_BALANCE#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(83721028883291991)
,p_db_column_name=>'FUTURE2'
,p_display_order=>58
,p_column_identifier=>'M'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(95246741619427788)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1180373'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:COST_CENTER:COST_CENTER_NAME:EXPENDITURE_TYPE:FUTURE2:BUDGET:ACTUAL:ENCUMBERANCE:FUND_AVAILABLE:FROM_PENDING_BALANCE:TO_PENDING_BALANCE:'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(95218790881181021)
,p_application_user=>'TCA9051'
,p_name=>'Balance By Project'
,p_report_seq=>10
,p_report_type=>'GROUP_BY'
,p_view_mode=>'REPORT'
,p_report_columns=>'PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:COST_CENTER:COST_CENTER_NAME:EXPENDITURE_TYPE:BUDGET:ACTUAL:ENCUMBERANCE:FUND_AVAILABLE::FROM_PENDING_BALANCE:TO_PENDING_BALANCE'
);
wwv_flow_api.create_worksheet_group_by(
 p_id=>wwv_flow_api.id(95218690871181021)
,p_report_id=>wwv_flow_api.id(95218790881181021)
,p_group_by_columns=>'PROJECT_NUMBER'
,p_function_01=>'SUM'
,p_function_column_01=>'BUDGET'
,p_function_db_column_name_01=>'APXWS_GBFC_01'
,p_function_label_01=>'Total Budget'
,p_function_format_mask_01=>'999G999G999G999G990D00'
,p_function_sum_01=>'N'
,p_function_02=>'SUM'
,p_function_column_02=>'ACTUAL'
,p_function_db_column_name_02=>'APXWS_GBFC_02'
,p_function_label_02=>'Total Actual'
,p_function_format_mask_02=>'999G999G999G999G990D00'
,p_function_sum_02=>'N'
,p_function_03=>'SUM'
,p_function_column_03=>'ENCUMBERANCE'
,p_function_db_column_name_03=>'APXWS_GBFC_03'
,p_function_label_03=>'Total Encumberance'
,p_function_format_mask_03=>'999G999G999G999G990D00'
,p_function_sum_03=>'N'
,p_function_04=>'SUM'
,p_function_column_04=>'FUND_AVAILABLE'
,p_function_db_column_name_04=>'APXWS_GBFC_04'
,p_function_label_04=>'Total Fund'
,p_function_format_mask_04=>'999G999G999G999G990D00'
,p_function_sum_04=>'N'
,p_function_05=>'SUM'
,p_function_column_05=>'FROM_PENDING_BALANCE'
,p_function_db_column_name_05=>'APXWS_GBFC_05'
,p_function_label_05=>'Total Deduction Pending'
,p_function_format_mask_05=>'999G999G999G999G990D00'
,p_function_sum_05=>'N'
,p_function_06=>'SUM'
,p_function_column_06=>'TO_PENDING_BALANCE'
,p_function_db_column_name_06=>'APXWS_GBFC_06'
,p_function_label_06=>'Total Additional Pending'
,p_function_format_mask_06=>'999G999G999G999G990D00'
,p_function_sum_06=>'N'
,p_sort_column_01=>'PROJECT_NUMBER'
,p_sort_direction_01=>'ASC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(40682018171038616)
,p_plug_name=>'New Projects requests'
,p_icon_css_classes=>'fa-window-new'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'PROJECT_CREATION_REQUESTS'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'New Projects requests'
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
 p_id=>wwv_flow_api.id(40681882787038615)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:114:&SESSION.::&DEBUG.::P114_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>172602149602146017
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40681802831038614)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Request No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40681697953038613)
,p_db_column_name=>'PROJECT_TYPE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Project Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(39212809831376117)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40681554690038612)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40681489483038611)
,p_db_column_name=>'PROJECT_CODE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Project Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40681349062038610)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40681328702038609)
,p_db_column_name=>'DECISION_NO'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Decision No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40681144938038608)
,p_db_column_name=>'PROJECT_AUTHORIZER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Project Authorizer'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40681033246038607)
,p_db_column_name=>'PROJECT_START_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Project Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40680973261038606)
,p_db_column_name=>'DCT_SECTOR_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Dct Sector Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40680857428038605)
,p_db_column_name=>'DCT_DEPARTMENT_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Dct Department Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40680828057038604)
,p_db_column_name=>'DCT_SECTION_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Dct Section Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40680683762038603)
,p_db_column_name=>'DCT_UNIT_ID'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Dct Unit Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40680618851038602)
,p_db_column_name=>'DCT_TASK_NAME'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Dct Task Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40680517371038601)
,p_db_column_name=>'DCT_SERVICE_PROVIDER'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Dct Service Provider'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40680337737038600)
,p_db_column_name=>'DCT_MPR_ALLOWED'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Dct Mpr Allowed'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40680290366038599)
,p_db_column_name=>'DCT_MPO_ALLOWED'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Dct Mpo Allowed'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40680207894038598)
,p_db_column_name=>'DCT_STATUS'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Dct Status'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40680077276038597)
,p_db_column_name=>'DIRECTOR_PERSON_ID'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Director Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40679956779038596)
,p_db_column_name=>'ED_PERSON_ID'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Ed Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40679845100038595)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Initiative Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40679769937038594)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Request Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40679724528038593)
,p_db_column_name=>'REQUEST_MSG'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Request Msg'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40679557843038592)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40679462952038591)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40679430109038590)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40679320134038589)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(39171390069216287)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1741127'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:PROJECT_TYPE:PROJECT_NUMBER:PROJECT_CODE:PROJECT_NAME:DECISION_NO:PROJECT_AUTHORIZER:PROJECT_START_DATE:DCT_SECTOR_ID:DCT_DEPARTMENT_ID:DCT_SECTION_ID:DCT_UNIT_ID:DCT_TASK_NAME:DCT_SERVICE_PROVIDER:DCT_MPR_ALLOWED:DCT_MPO_ALLOWED:DCT_STATUS:DIRECT'
||'OR_PERSON_ID:ED_PERSON_ID:INITIATIVE_ID:REQUEST_STATUS:REQUEST_MSG:CREATED_BY:CREATED_ON:UPDATED_BY:UPDATED_ON'
,p_sort_column_1=>'UPDATED_ON'
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
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(40682300059038619)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(95251076140426826)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'New Project'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:114:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(40679139816038588)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(40682018171038616)
,p_button_name=>'New_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'New Project'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:114:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(69700823611622230)
,p_name=>'P41_ACCOUNTING_YEAR'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(95250480552426826)
,p_item_default=>'2024'
,p_prompt=>'Accounting Year'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:2022;2022,2023;2023,2021;2021,2020;2020,2019;2019,2018;2018,2017;2017,2024;2024'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(69700684831622229)
,p_name=>'Accounting Year Changes DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P41_ACCOUNTING_YEAR'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(69700583119622228)
,p_event_id=>wwv_flow_api.id(69700684831622229)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(95250480552426826)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(37113948722435797)
,p_name=>'New'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(40679139816038588)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(37113929500435796)
,p_event_id=>wwv_flow_api.id(37113948722435797)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(40682018171038616)
);
wwv_flow_api.component_end;
end;
/
