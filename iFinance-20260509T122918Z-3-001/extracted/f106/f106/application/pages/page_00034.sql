prompt --application/pages/page_00034
begin
--   Manifest
--     PAGE: 00034
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>34
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'SAP Employees Data'
,p_alias=>'SAP-EMPLOYEES-DATA'
,p_step_title=>'SAP Employees Data'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220701062547'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3295428056335891)
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
 p_id=>wwv_flow_api.id(3296089968335891)
,p_plug_name=>'SAP Employees Data'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'SF_EMPLOYEES'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'SAP Employees Data'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(3296209840335891)
,p_name=>'SAP Employees Data'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>113907086330342868
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3296615353335879)
,p_db_column_name=>'SF_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'SF_ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3297016115335879)
,p_db_column_name=>'ORACLE_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Oracle ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3297388381335878)
,p_db_column_name=>'EMPLOYEE_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3297752529335878)
,p_db_column_name=>'NAME_ARABIC'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Name Arabic'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3298221071335878)
,p_db_column_name=>'HIRE_DATE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Hire Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3298525567335878)
,p_db_column_name=>'GRADE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Grade'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3298996710335878)
,p_db_column_name=>'JOB_TITLE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Job Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3299408325335878)
,p_db_column_name=>'POSITION_ARABIC'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Position Arabic'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3299786316335877)
,p_db_column_name=>'PAYROLL_AREA'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Payroll Area'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3300196735335877)
,p_db_column_name=>'CONTRACT_TYPE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Contract Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3300619400335877)
,p_db_column_name=>'SECTOR'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3301008666335877)
,p_db_column_name=>'SECTOR_ARABIC'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Sector Arabic'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3301415448335877)
,p_db_column_name=>'DEPARTMENT'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3301743413335877)
,p_db_column_name=>'DEPARTMENT_ARABIC'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Department Arabic'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3302138483335876)
,p_db_column_name=>'SECTION'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Section'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3302524767335876)
,p_db_column_name=>'SECTION_ARABIC'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Section Arabic'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3302979186335876)
,p_db_column_name=>'UNIT'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Unit'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3303350882335876)
,p_db_column_name=>'UNIT_ARABIC'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Unit Arabic'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3303804831335876)
,p_db_column_name=>'LOCATION'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Location'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3304168916335876)
,p_db_column_name=>'SUPERVISOR_NAME'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Supervisor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3304602980335875)
,p_db_column_name=>'GENDER'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Gender'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3304971096335875)
,p_db_column_name=>'GENDER_ARABIC'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Gender Arabic'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3305383689335875)
,p_db_column_name=>'NATIONALITY_TYPE'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Nationality Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3305724133335875)
,p_db_column_name=>'NATIONALITY'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Nationality'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3306171960335875)
,p_db_column_name=>'NATIONALITY_ARABIC'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Nationality Arabic'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3306527625335875)
,p_db_column_name=>'MARITAL_STATUS'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Marital Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3306990087335874)
,p_db_column_name=>'EMIRATES_ID'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Emirates ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3307410912335874)
,p_db_column_name=>'EMAIL_ADDRESS'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Email Address'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3307735778335874)
,p_db_column_name=>'MOBILE_PHONE_NUMBER'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Mobile Phone Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(3317441572331760)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1139284'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SF_ID:ORACLE_ID:EMPLOYEE_NAME:NAME_ARABIC:HIRE_DATE:GRADE:JOB_TITLE:POSITION_ARABIC:PAYROLL_AREA:CONTRACT_TYPE:SECTOR:SECTOR_ARABIC:DEPARTMENT:DEPARTMENT_ARABIC:SECTION:SECTION_ARABIC:UNIT:UNIT_ARABIC:LOCATION:SUPERVISOR_NAME:GENDER:GENDER_ARABIC:NAT'
||'IONALITY_TYPE:NATIONALITY:NATIONALITY_ARABIC:MARITAL_STATUS:EMIRATES_ID:EMAIL_ADDRESS:MOBILE_PHONE_NUMBER'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3160468462269134)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(3295428056335891)
,p_button_name=>'Download'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Download Template'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-file-arrow-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3159758745269127)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(3295428056335891)
,p_button_name=>'Update'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Update'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-cloud-upload'
);
wwv_flow_api.component_end;
end;
/
