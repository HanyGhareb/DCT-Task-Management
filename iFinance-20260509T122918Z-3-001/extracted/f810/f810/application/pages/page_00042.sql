prompt --application/pages/page_00042
begin
--   Manifest
--     PAGE: 00042
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>42
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Employees'
,p_alias=>'EMPLOYEES'
,p_step_title=>'Employees'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240131082415'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(79017722768738869)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12908155528762118)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12844716791762062)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12962203224762162)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(79018309511738871)
,p_plug_name=>'Employees'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select person_id ,',
'        full_name_en,',
'        employee_num,',
'        COST_CENTER_CODE,',
'        email,',
'    grade_id, location , ',
'    payroll_area_id , supervisor_num, director_person_id , executive_person_id',
'from employees_v',
'where current_flag =  ''Y''',
'and PERSON_ID not in (1,2,3, 4,5) ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Employees'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(79018394643738871)
,p_name=>'Employees'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>189629271133745848
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(79018813621738874)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Update'
,p_column_link=>'f?p=&APP_ID.:43:&SESSION.::&DEBUG.::P43_PERSON_ID:#PERSON_ID#'
,p_column_linktext=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_column_link_attr=>'#PERSON_ID#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(79019217219738876)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(79019535398738876)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(79019992618738876)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(79020331803738876)
,p_db_column_name=>'EMAIL'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(79020804320738877)
,p_db_column_name=>'GRADE_ID'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Grade'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109823118131928448)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(79021562862738877)
,p_db_column_name=>'PAYROLL_AREA_ID'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Payroll Area'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(78777153798461677)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(79021969835738877)
,p_db_column_name=>'SUPERVISOR_NUM'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Supervisor Num'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(79022388889738878)
,p_db_column_name=>'DIRECTOR_PERSON_ID'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Director'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48056159040127691)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(79022733741738878)
,p_db_column_name=>'EXECUTIVE_PERSON_ID'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Executive Director'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48056159040127691)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84397538861618526)
,p_db_column_name=>'LOCATION'
,p_display_order=>21
,p_column_identifier=>'L'
,p_column_label=>'Location'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(79023209264762118)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1896341'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PERSON_ID:FULL_NAME_EN:EMPLOYEE_NUM:COST_CENTER_CODE:GRADE_ID:LOCATION:PAYROLL_AREA_ID:EMAIL:SUPERVISOR_NUM:DIRECTOR_PERSON_ID:EXECUTIVE_PERSON_ID:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(82671879995866460)
,p_plug_name=>'Search'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(85706214060488630)
,p_plug_name=>'Search-L'
,p_parent_plug_id=>wwv_flow_api.id(82671879995866460)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(85706282658488631)
,p_plug_name=>'Downloads'
,p_parent_plug_id=>wwv_flow_api.id(82671879995866460)
,p_icon_css_classes=>'fa-braille'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><a title="Download Employees Outsource Data Template" href="#APP_IMAGES#Upload_Outsource_Data_Template.csv">Download Template</a></p>',
'<p><a title="Download Employees Lookups" href="#APP_IMAGES#Employees_Lookups.xlsx">Employees Lookups</a></p>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(82672312345866464)
,p_plug_name=>'Employees 2000'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select person_id ,',
'        full_name_en,',
'        employee_num,',
'        COST_CENTER_CODE,',
'        email,',
'    grade_id, location , ',
'    payroll_area_id , supervisor_num, director_person_id , executive_person_id',
'from employees_v',
'where current_flag =  ''Y''',
'and PERSON_ID not in (1,2,3, 4,5) ',
'and employee_num like ''2000%'' ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Employees 2000'
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
 p_id=>wwv_flow_api.id(82672336993866465)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>193283213483873442
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82672456977866466)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Update'
,p_column_link=>'f?p=&APP_ID.:43:&SESSION.::&DEBUG.::P43_PERSON_ID:#PERSON_ID#'
,p_column_linktext=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_column_link_attr=>'#PERSON_ID#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82672561613866467)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82672706891866468)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82672734093866469)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82672868592866470)
,p_db_column_name=>'EMAIL'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82672930206866471)
,p_db_column_name=>'GRADE_ID'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Grade'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(109823118131928448)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82673062767866472)
,p_db_column_name=>'PAYROLL_AREA_ID'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Payroll Area'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(78777153798461677)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82673201429866473)
,p_db_column_name=>'SUPERVISOR_NUM'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Supervisor Num'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85705534815488624)
,p_db_column_name=>'DIRECTOR_PERSON_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Director'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48056159040127691)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85705664191488625)
,p_db_column_name=>'EXECUTIVE_PERSON_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Executive Director'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48056159040127691)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(85705769764488626)
,p_db_column_name=>'LOCATION'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Location'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(85716263261495383)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1963272'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PERSON_ID:FULL_NAME_EN:EMPLOYEE_NUM:COST_CENTER_CODE:EMAIL:GRADE_ID:PAYROLL_AREA_ID:SUPERVISOR_NUM:DIRECTOR_PERSON_ID:EXECUTIVE_PERSON_ID:LOCATION'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(85815086865303735)
,p_application_user=>'TCA9051'
,p_name=>'no payroll area report'
,p_report_seq=>10
,p_report_columns=>'PERSON_ID:FULL_NAME_EN:EMPLOYEE_NUM:COST_CENTER_CODE:EMAIL:GRADE_ID:PAYROLL_AREA_ID:SUPERVISOR_NUM:DIRECTOR_PERSON_ID:EXECUTIVE_PERSON_ID:LOCATION'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(85815146500303736)
,p_report_id=>wwv_flow_api.id(85815086865303735)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'PAYROLL_AREA_ID'
,p_operator=>'is null'
,p_condition_sql=>'"PAYROLL_AREA_ID" is null'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(85815629933309890)
,p_application_user=>'TCA9051'
,p_name=>'no grade report'
,p_report_seq=>10
,p_report_columns=>'PERSON_ID:FULL_NAME_EN:EMPLOYEE_NUM:COST_CENTER_CODE:EMAIL:GRADE_ID:PAYROLL_AREA_ID:SUPERVISOR_NUM:DIRECTOR_PERSON_ID:EXECUTIVE_PERSON_ID:LOCATION'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(85815822120309892)
,p_report_id=>wwv_flow_api.id(85815629933309890)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'GRADE_ID'
,p_operator=>'is null'
,p_condition_sql=>'"GRADE_ID" is null'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(83677857491148834)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(79017722768738869)
,p_button_name=>'Upload'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Upload'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:45:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-cloud-upload'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(82671996671866461)
,p_name=>'P42_OUTSOUCE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(85706214060488630)
,p_item_default=>'N'
,p_prompt=>'Show 2000xx Only'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(82672063100866462)
,p_name=>'show only 200 Emp Da'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P42_OUTSOUCE'
,p_condition_element=>'P42_OUTSOUCE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(82672187292866463)
,p_event_id=>wwv_flow_api.id(82672063100866462)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(82672312345866464)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(85706090794488629)
,p_event_id=>wwv_flow_api.id(82672063100866462)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(79018309511738871)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(85705887053488627)
,p_event_id=>wwv_flow_api.id(82672063100866462)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(79018309511738871)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(85705982433488628)
,p_event_id=>wwv_flow_api.id(82672063100866462)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(82672312345866464)
);
wwv_flow_api.component_end;
end;
/
