prompt --application/pages/page_00012
begin
--   Manifest
--     PAGE: 00012
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>12
,p_user_interface_id=>wwv_flow_api.id(3440093928015830)
,p_name=>'Employees'
,p_alias=>'EMPLOYEES'
,p_step_title=>'Employees'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231023075938'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5127033568889640)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3364880770015750)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(3301434120015688)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(3418914725015794)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5127602210889640)
,p_plug_name=>'Employees'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3353501491015744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    person_id,',
'    employee_num,',
'    assignment_number,',
'    title,',
'    nvl(full_name_en,sf_employee_name)  full_name_en,',
'    full_name_ar,',
'    email,',
'    manager_flag,',
'    supervisor_num,',
'    supervisor_name,',
'    position_id,',
'    position,',
'    job_id,',
'    job,',
'    grade_id,',
'    grade,',
'    location_id,',
'    location,',
'    marital_status_id,',
'    marital_status,',
'    nationality_id,',
'    nationality,',
'    religion_code,',
'    religion,',
'    person_type_id,',
'    person_type,',
'    assignment_status_type_id,',
'    assignment_status_type,',
'    people_group_id,',
'    people_group,',
'    payroll_id,',
'    payroll,',
'    pay_basis_id,',
'    paybasis,',
'    assignment_type_id,',
'    assignment_type,',
'    current_flag,',
'    sex,',
'    birth_date,',
'    to_date(substr(hire_date,1,10),''dd-mm-yyyy'') hire_date,',
'    mobile,',
'    user_name,',
'    phone_nos,',
'    termination_date,',
'    org_id,',
'    org_name,',
'    org_level,',
'    cost_center_code,',
'    department_id,',
'    department_name,',
'    director_num,',
'    director_name,',
'    sector_id,',
'    sector,',
'    executive_director__name,',
'    executive_director_num,',
'    parent_org,',
'    parent_org_name,',
'    parent_level,',
'    partner_emp_num,',
'    partner_name,',
'    source',
'FROM',
'    employees_v;',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Employees'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(5127712582889640)
,p_name=>'Employees'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.::P13_PERSON_ID:#PERSON_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>5127712582889640
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5128145922889644)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5128550361889645)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Employee #'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5128978292889645)
,p_db_column_name=>'ASSIGNMENT_NUMBER'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Assignment #'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5129301519889645)
,p_db_column_name=>'TITLE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5129733469889646)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5130114991889646)
,p_db_column_name=>'FULL_NAME_AR'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Name (Arabic)'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5130502246889646)
,p_db_column_name=>'EMAIL'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5130952049889646)
,p_db_column_name=>'MANAGER_FLAG'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Manager ?'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5131393128889647)
,p_db_column_name=>'SUPERVISOR_NUM'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Supervisor #'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5131726083889647)
,p_db_column_name=>'SUPERVISOR_NAME'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Supervisor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5132199924889647)
,p_db_column_name=>'POSITION_ID'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Position Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5132594160889648)
,p_db_column_name=>'POSITION'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Position'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5132967106889648)
,p_db_column_name=>'JOB_ID'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Job Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5133394601889648)
,p_db_column_name=>'JOB'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Job'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5133738463889648)
,p_db_column_name=>'GRADE_ID'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Grade Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5134153368889649)
,p_db_column_name=>'GRADE'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Grade'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5134587456889649)
,p_db_column_name=>'LOCATION_ID'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Location Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5134950929889649)
,p_db_column_name=>'LOCATION'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Location'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5135371110889650)
,p_db_column_name=>'MARITAL_STATUS_ID'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Marital Status Id'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5135791023889650)
,p_db_column_name=>'MARITAL_STATUS'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Marital Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5136161845889650)
,p_db_column_name=>'NATIONALITY_ID'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Nationality Id'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5136567021889650)
,p_db_column_name=>'NATIONALITY'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Nationality'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5136965533889651)
,p_db_column_name=>'RELIGION_CODE'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Religion Code'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5137312009889651)
,p_db_column_name=>'RELIGION'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Religion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5137724053889651)
,p_db_column_name=>'PERSON_TYPE_ID'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Person Type Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5138121136889651)
,p_db_column_name=>'PERSON_TYPE'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Person Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5138529479889652)
,p_db_column_name=>'ASSIGNMENT_STATUS_TYPE_ID'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Assignment Status Type Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5138970690889652)
,p_db_column_name=>'ASSIGNMENT_STATUS_TYPE'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Assignment Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5139349566889652)
,p_db_column_name=>'PEOPLE_GROUP_ID'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'People Group Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5139797796889653)
,p_db_column_name=>'PEOPLE_GROUP'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'People Group'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5140167322889653)
,p_db_column_name=>'PAYROLL_ID'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Payroll Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5140557362889653)
,p_db_column_name=>'PAYROLL'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Payroll'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5140958301889654)
,p_db_column_name=>'PAY_BASIS_ID'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Pay Basis Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5141388952889654)
,p_db_column_name=>'PAYBASIS'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Pay basis'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5141740442889654)
,p_db_column_name=>'ASSIGNMENT_TYPE_ID'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Assignment Type Id'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5142147862889654)
,p_db_column_name=>'ASSIGNMENT_TYPE'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Assignment Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5142530538889655)
,p_db_column_name=>'CURRENT_FLAG'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Current Flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5142984154889655)
,p_db_column_name=>'SEX'
,p_display_order=>38
,p_column_identifier=>'AL'
,p_column_label=>'Sex'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5143328682889655)
,p_db_column_name=>'BIRTH_DATE'
,p_display_order=>39
,p_column_identifier=>'AM'
,p_column_label=>'Birth Date'
,p_column_type=>'STRING'
,p_format_mask=>'DD-MON-YYYY'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5144135137889656)
,p_db_column_name=>'MOBILE'
,p_display_order=>41
,p_column_identifier=>'AO'
,p_column_label=>'Mobile'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5144594661889656)
,p_db_column_name=>'USER_NAME'
,p_display_order=>42
,p_column_identifier=>'AP'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5144943252889656)
,p_db_column_name=>'PHONE_NOS'
,p_display_order=>43
,p_column_identifier=>'AQ'
,p_column_label=>'Phone Nos'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5145351615889657)
,p_db_column_name=>'TERMINATION_DATE'
,p_display_order=>44
,p_column_identifier=>'AR'
,p_column_label=>'Termination Date'
,p_column_type=>'STRING'
,p_format_mask=>'DD-MON-YYYY'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5145626629889657)
,p_db_column_name=>'ORG_ID'
,p_display_order=>45
,p_column_identifier=>'AS'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5146016702889657)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>46
,p_column_identifier=>'AT'
,p_column_label=>'Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5146445259889658)
,p_db_column_name=>'ORG_LEVEL'
,p_display_order=>47
,p_column_identifier=>'AU'
,p_column_label=>'Organization Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5146884396889658)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>48
,p_column_identifier=>'AV'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(196671344813468839)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5147247829889658)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>49
,p_column_identifier=>'AW'
,p_column_label=>'Department Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5147621086889658)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>50
,p_column_identifier=>'AX'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5148007563889659)
,p_db_column_name=>'DIRECTOR_NUM'
,p_display_order=>51
,p_column_identifier=>'AY'
,p_column_label=>'Director #'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5148413382889659)
,p_db_column_name=>'DIRECTOR_NAME'
,p_display_order=>52
,p_column_identifier=>'AZ'
,p_column_label=>'Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5148842058889659)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>53
,p_column_identifier=>'BA'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5149244050889660)
,p_db_column_name=>'SECTOR'
,p_display_order=>54
,p_column_identifier=>'BB'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5149624596889660)
,p_db_column_name=>'EXECUTIVE_DIRECTOR__NAME'
,p_display_order=>55
,p_column_identifier=>'BC'
,p_column_label=>'ED  Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5150021923889660)
,p_db_column_name=>'EXECUTIVE_DIRECTOR_NUM'
,p_display_order=>56
,p_column_identifier=>'BD'
,p_column_label=>'Executive Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5150413779889660)
,p_db_column_name=>'PARENT_ORG'
,p_display_order=>57
,p_column_identifier=>'BE'
,p_column_label=>'Parent Org'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5150870640889661)
,p_db_column_name=>'PARENT_ORG_NAME'
,p_display_order=>58
,p_column_identifier=>'BF'
,p_column_label=>'Parent Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5151283606889661)
,p_db_column_name=>'PARENT_LEVEL'
,p_display_order=>59
,p_column_identifier=>'BG'
,p_column_label=>'Parent org Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5151658734889661)
,p_db_column_name=>'PARTNER_EMP_NUM'
,p_display_order=>60
,p_column_identifier=>'BH'
,p_column_label=>'Partner Emp Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5152071008889662)
,p_db_column_name=>'PARTNER_NAME'
,p_display_order=>61
,p_column_identifier=>'BI'
,p_column_label=>'Partner Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(35048369969935347)
,p_db_column_name=>'HIRE_DATE'
,p_display_order=>71
,p_column_identifier=>'BJ'
,p_column_label=>'Hire Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157192149127961625)
,p_db_column_name=>'SOURCE'
,p_display_order=>81
,p_column_identifier=>'BK'
,p_column_label=>'Source'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(5152615023891292)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'51527'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORG_ID:PERSON_ID:EMPLOYEE_NUM:FULL_NAME_EN:EMAIL:SUPERVISOR_NAME:USER_NAME:ORG_NAME:COST_CENTER_CODE:DEPARTMENT_NAME:DIRECTOR_NAME:SECTOR:EXECUTIVE_DIRECTOR__NAME:SOURCE:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(189584471038022494)
,p_report_id=>wwv_flow_api.id(5152615023891292)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'CURRENT_FLAG'
,p_operator=>'='
,p_expr=>'Y'
,p_condition_sql=>'"CURRENT_FLAG" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''Y''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(55049520054290817)
,p_plug_name=>'Employees Not in ADERP'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    person_id,',
'    employee_num,',
'    assignment_number,',
'    title,',
'    full_name_en,',
'    full_name_ar,',
'    email,',
'    manager_flag,',
'    supervisor_num,',
'    supervisor_name,',
'    position_id,',
'    position,',
'    job_id,',
'    job,',
'    grade_id,',
'    grade,',
'    location_id,',
'    location,',
'    marital_status_id,',
'    marital_status,',
'    nationality_id,',
'    nationality,',
'    religion_code,',
'    religion,',
'    person_type_id,',
'    person_type,',
'    assignment_status_type_id,',
'    assignment_status_type,',
'    people_group_id,',
'    people_group,',
'    payroll_id,',
'    payroll,',
'    pay_basis_id,',
'    paybasis,',
'    assignment_type_id,',
'    assignment_type,',
'    current_flag,',
'    sex,',
'    birth_date,',
'    to_date(substr(hire_date,1,10),''dd-mm-yyyy'') hire_date,',
'    mobile,',
'    user_name,',
'    phone_nos,',
'    termination_date,',
'    org_id,',
'    org_name,',
'    org_level,',
'    cost_center_code,',
'    department_id,',
'    department_name,',
'    director_num,',
'    director_name,',
'    sector_id,',
'    sector,',
'    executive_director__name,',
'    executive_director_num,',
'    parent_org,',
'    parent_org_name,',
'    parent_level,',
'    partner_emp_num,',
'    partner_name',
'FROM',
'    employees_v',
'where source in (''Manual'',''SAP'');',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Employees Not in ADERP'
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
 p_id=>wwv_flow_api.id(55049709848290819)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.::P13_PERSON_ID:#PERSON_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>55049709848290819
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55049830710290820)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55049922489290821)
,p_db_column_name=>'ASSIGNMENT_STATUS_TYPE_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Assignment Status Type Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55050021936290822)
,p_db_column_name=>'ASSIGNMENT_STATUS_TYPE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Assignment Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55050144174290823)
,p_db_column_name=>'PEOPLE_GROUP_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'People Group Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55050247116290824)
,p_db_column_name=>'PEOPLE_GROUP'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'People Group'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55050301777290825)
,p_db_column_name=>'PAYROLL_ID'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Payroll Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55050434826290826)
,p_db_column_name=>'PAYROLL'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Payroll'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55050555144290827)
,p_db_column_name=>'PAY_BASIS_ID'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Pay Basis Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55050691751290828)
,p_db_column_name=>'PAYBASIS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Pay basis'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55050795053290829)
,p_db_column_name=>'ASSIGNMENT_TYPE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Assignment Type Id'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55050866543290830)
,p_db_column_name=>'ASSIGNMENT_TYPE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Assignment Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55050960039290831)
,p_db_column_name=>'CURRENT_FLAG'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Current Flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55051074108290832)
,p_db_column_name=>'SEX'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Sex'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55051173869290833)
,p_db_column_name=>'BIRTH_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Birth Date'
,p_column_type=>'STRING'
,p_format_mask=>'DD-MON-YYYY'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55051258499290834)
,p_db_column_name=>'MOBILE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Mobile'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55051324270290835)
,p_db_column_name=>'USER_NAME'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55051454080290836)
,p_db_column_name=>'PHONE_NOS'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Phone Nos'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55051520621290837)
,p_db_column_name=>'TERMINATION_DATE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Termination Date'
,p_column_type=>'STRING'
,p_format_mask=>'DD-MON-YYYY'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55051642333290838)
,p_db_column_name=>'ORG_ID'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55051728895290839)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55051886466290840)
,p_db_column_name=>'ORG_LEVEL'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Organization Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55051934886290841)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55052015429290842)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Department Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55052101264290843)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55052299113290844)
,p_db_column_name=>'DIRECTOR_NUM'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Director #'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55052383546290845)
,p_db_column_name=>'DIRECTOR_NAME'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55052486755290846)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Employee #'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55052521272290847)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55052637051290848)
,p_db_column_name=>'SECTOR'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55052799130290849)
,p_db_column_name=>'EXECUTIVE_DIRECTOR__NAME'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'ED  Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55052847033290850)
,p_db_column_name=>'EXECUTIVE_DIRECTOR_NUM'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Executive Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55365593862673101)
,p_db_column_name=>'PARENT_ORG'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Parent Org'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55365690253673102)
,p_db_column_name=>'PARENT_ORG_NAME'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Parent Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55365716715673103)
,p_db_column_name=>'PARENT_LEVEL'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Parent org Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55365838158673104)
,p_db_column_name=>'PARTNER_EMP_NUM'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Partner Emp Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55365968481673105)
,p_db_column_name=>'PARTNER_NAME'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Partner Name'
,p_column_type=>'STRING'
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
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55366090596673106)
,p_db_column_name=>'HIRE_DATE'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Hire Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55366158038673107)
,p_db_column_name=>'ASSIGNMENT_NUMBER'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Assignment #'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55366285111673108)
,p_db_column_name=>'TITLE'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55366315507673109)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55366429774673110)
,p_db_column_name=>'FULL_NAME_AR'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Name (Arabic)'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55366561745673111)
,p_db_column_name=>'EMAIL'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55366665108673112)
,p_db_column_name=>'MANAGER_FLAG'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Manager ?'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55366771969673113)
,p_db_column_name=>'SUPERVISOR_NUM'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Supervisor #'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55366874489673114)
,p_db_column_name=>'SUPERVISOR_NAME'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Supervisor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55366991780673115)
,p_db_column_name=>'POSITION_ID'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Position Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55367099451673116)
,p_db_column_name=>'POSITION'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Position'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55367195841673117)
,p_db_column_name=>'JOB_ID'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Job Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55367287842673118)
,p_db_column_name=>'JOB'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Job'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55367329990673119)
,p_db_column_name=>'GRADE_ID'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Grade Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55367425394673120)
,p_db_column_name=>'GRADE'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Grade'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55367536650673121)
,p_db_column_name=>'LOCATION_ID'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Location Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55367645842673122)
,p_db_column_name=>'LOCATION'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Location'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55367767537673123)
,p_db_column_name=>'MARITAL_STATUS_ID'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Marital Status Id'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55367868974673124)
,p_db_column_name=>'MARITAL_STATUS'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'Marital Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55367955818673125)
,p_db_column_name=>'NATIONALITY_ID'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Nationality Id'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55368025219673126)
,p_db_column_name=>'NATIONALITY'
,p_display_order=>570
,p_column_identifier=>'BE'
,p_column_label=>'Nationality'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55368137281673127)
,p_db_column_name=>'RELIGION_CODE'
,p_display_order=>580
,p_column_identifier=>'BF'
,p_column_label=>'Religion Code'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55368286057673128)
,p_db_column_name=>'RELIGION'
,p_display_order=>590
,p_column_identifier=>'BG'
,p_column_label=>'Religion'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55368321453673129)
,p_db_column_name=>'PERSON_TYPE_ID'
,p_display_order=>600
,p_column_identifier=>'BH'
,p_column_label=>'Person Type Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55368432105673130)
,p_db_column_name=>'PERSON_TYPE'
,p_display_order=>610
,p_column_identifier=>'BI'
,p_column_label=>'Person Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(55389606478676147)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'553897'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EMPLOYEE_NUM:FULL_NAME_EN:EMAIL:SUPERVISOR_NAME:USER_NAME:ORG_NAME:COST_CENTER_CODE:DEPARTMENT_NAME:DIRECTOR_NAME:SECTOR:EXECUTIVE_DIRECTOR__NAME:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(55049633519290818)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(55049520054290817)
,p_button_name=>'New_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(3417666671015793)
,p_button_image_alt=>'New'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.:16:P16_ACCOUNT_STATUS,P16_CURRENT_FLAG,P16_SOURCE_H:A,Y,Manual'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53437202077667737)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(5127602210889640)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(3417666671015793)
,p_button_image_alt=>'New'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.:16:P16_SOURCE,P16_ACCOUNT_STATUS,P16_CURRENT_FLAG:Manual,A,Y'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
