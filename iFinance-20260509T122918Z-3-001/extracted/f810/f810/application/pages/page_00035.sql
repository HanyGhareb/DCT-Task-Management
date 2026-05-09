prompt --application/pages/page_00035
begin
--   Manifest
--     PAGE: 00035
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
 p_id=>35
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Freelancers'
,p_alias=>'FREELANCERS'
,p_step_title=>'Freelancers'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220717111706'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4936830175918204)
,p_plug_name=>'Freelancers Report'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    person_id,',
'    employee_num,',
'    sf_number,',
'    full_name_en,',
'    full_name_ar,',
'    email,',
'    hire_date,',
'    national_identifier,',
'    mobile,',
'    user_name,',
'    source,',
'    account_status,',
'    sf_contract_type,',
'    sf_email,',
'    sf_emirates_id,',
'    sf_employee_name,',
'    sf_grade,',
'    sf_grade_id,',
'    sf_hire_date,',
'    sf_job_title,',
'    sf_location,',
'    sf_mobile_phone_number,',
'    sf_name_arabic,',
'    sf_nationality,',
'    sf_nationality_type,',
'    sf_payroll_area',
'FROM',
'    employees_v  -- 2584',
'WHERE',
'    sf_payroll_area = ''Non-Payroll'''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Freelancers Report'
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
 p_id=>wwv_flow_api.id(4937259948918204)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.:RP:P36_PERSON_ID:\#PERSON_ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>115548136438925181
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4937398855918203)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>0
,p_column_identifier=>'A'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4937720963918202)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4938099962918201)
,p_db_column_name=>'SF_NUMBER'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'SF Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4938522744918201)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Full Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4938863735918201)
,p_db_column_name=>'FULL_NAME_AR'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Full Name (AR)'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4939233478918201)
,p_db_column_name=>'EMAIL'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4939640997918201)
,p_db_column_name=>'HIRE_DATE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Hire Date'
,p_column_type=>'STRING'
,p_format_mask=>'DD-MON-YYYY'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4940057767918200)
,p_db_column_name=>'NATIONAL_IDENTIFIER'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'National ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4940445771918200)
,p_db_column_name=>'MOBILE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Mobile'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4940855597918200)
,p_db_column_name=>'USER_NAME'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4941272688918200)
,p_db_column_name=>'SOURCE'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Source'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4941635672918200)
,p_db_column_name=>'ACCOUNT_STATUS'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Account Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109817458020935965)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4942078170918199)
,p_db_column_name=>'SF_CONTRACT_TYPE'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'SF Contract Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4942505509918199)
,p_db_column_name=>'SF_EMAIL'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'SF Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4942892756918199)
,p_db_column_name=>'SF_EMIRATES_ID'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'SF Emirates ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4943289739918199)
,p_db_column_name=>'SF_EMPLOYEE_NAME'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'SF Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4943638469918199)
,p_db_column_name=>'SF_GRADE'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'SF Grade'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4944026950918199)
,p_db_column_name=>'SF_GRADE_ID'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'SF Grade ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4944452293918198)
,p_db_column_name=>'SF_HIRE_DATE'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'SF Hire Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4944900511918198)
,p_db_column_name=>'SF_JOB_TITLE'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'SF Job Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4945304000918198)
,p_db_column_name=>'SF_LOCATION'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'SF Location'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4945629872918198)
,p_db_column_name=>'SF_MOBILE_PHONE_NUMBER'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'SF Mobile Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4946094091918198)
,p_db_column_name=>'SF_NAME_ARABIC'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'SF Name Arabic'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4946522415918197)
,p_db_column_name=>'SF_NATIONALITY'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'SF Nationality'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4946878280918197)
,p_db_column_name=>'SF_NATIONALITY_TYPE'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'SF Nationality Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4947250318918197)
,p_db_column_name=>'SF_PAYROLL_AREA'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'SF Payroll Area'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(4964179266896175)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1155751'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EMPLOYEE_NUM:USER_NAME:SF_EMPLOYEE_NAME:SF_CONTRACT_TYPE:SF_EMAIL:SF_GRADE:SF_LOCATION:SF_MOBILE_PHONE_NUMBER:SF_NATIONALITY:ACCOUNT_STATUS:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4948614421918192)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4949753829918191)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(4936830175918204)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12960857103762161)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.:36'
,p_button_condition_type=>'NEVER'
);
wwv_flow_api.component_end;
end;
/
