prompt --application/pages/page_00008
begin
--   Manifest
--     PAGE: 00008
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
 p_id=>8
,p_user_interface_id=>wwv_flow_api.id(3440093928015830)
,p_name=>'Organization Details'
,p_alias=>'ORGANIZATION-DETAILS'
,p_step_title=>'Organization Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210314104746'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7739093545111662)
,p_plug_name=>'Organization Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'DCT_HR_ORGANIZATIONS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7695548630798978)
,p_plug_name=>'Employees'
,p_parent_plug_id=>wwv_flow_api.id(7739093545111662)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3353501491015744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    person_type_id,',
'    (select desc_e',
'        from dct_employees_lookups',
'        where lookup_name = ''Person Types''',
'        and code = dct_employees_list2.person_type_id ) Person_type_name,',
'    employee_num,',
'    payroll_id,',
'    (select desc_e',
'        from dct_employees_lookups',
'        where lookup_name = ''PayrollId''',
'        and code = dct_employees_list2.payroll_id) Payroll_Name,',
'    person_id,',
'    title,',
'    first_name,',
'    second_name,',
'    third_name,',
'    last_name,',
'    first_name_ar,',
'    second_name_ar,',
'    last_name_ar,',
'    full_name_en,',
'    full_name_ar,',
'    national_identifier,',
'    decode(manager_flag, ''N'' , ''No'',''Yes'') Manager_Flag,',
'    supervisor_num,',
'    (select l.full_name_en',
'        from dct_employees_list2 l',
'        where l.employee_num = dct_employees_list2.supervisor_num) supervisor_name,',
'    (select dct_employees_list2.email',
'        from dct_employees_list2 l',
'        where l.employee_num = dct_employees_list2.supervisor_num) supervisor_Email,    ',
'    organization_id,',
'     (select org.org_name_en ',
'    from dct_hr_organizations org',
'    where org.org_id =  organization_id) organization_en,',
'    (select org.org_name_ar ',
'    from dct_hr_organizations org',
'    where org.org_id =  organization_id) organization_ar,',
'    job_id,',
'    (select desc_a',
'        from dct_employees_lookups',
'        where lookup_name = ''Jobs Code''',
'        and code = dct_employees_list2.job_id) Job_name_ar,',
'        (select desc_e',
'        from dct_employees_lookups',
'        where lookup_name = ''Jobs Code''',
'        and code = dct_employees_list2.job_id) Job_name_en,',
'    position_id,',
'    (select desc_e',
'        from dct_employees_lookups',
'        where lookup_name = ''Positions Codes''',
'        and code = to_char(dct_employees_list2.position_id)) Position_Name_en,',
'   (select desc_a',
'        from dct_employees_lookups',
'        where lookup_name = ''Positions Codes''',
'        and code = to_char(dct_employees_list2.position_id)) Position_Name_ar,     ',
'    grade_id,',
'    (select desc_a',
'        from dct_employees_lookups',
'        where lookup_name = ''Grades Codes''',
'        and code = dct_employees_list2.grade_id) grad_name,',
'    nationality_code,',
'     (select desc_e',
'        from dct_employees_lookups',
'        where lookup_name = ''Nationality Code''',
'        and code = nationality_code) nationality_en,',
'    (select desc_a',
'        from dct_employees_lookups',
'        where lookup_name = ''Nationality Code''',
'        and code = nationality_code) nationality_ar,',
'    decode(sex , ''F'' , ''Female'', ''Male'') gender,',
'    marital_status,',
'    (select desc_e',
'        from dct_employees_lookups',
'        where lookup_name = ''Marital Status Codes''',
'        and code = dct_employees_list2.marital_status) Marital_Status_Desc,',
'    religion_code,',
'    (select desc_a',
'        from dct_employees_lookups',
'        where lookup_name = ''Religion Codes''',
'        and code = dct_employees_list2.religion_code) Religion_ar,',
'   (select desc_e',
'        from dct_employees_lookups',
'        where lookup_name = ''Religion Codes''',
'        and code = dct_employees_list2.religion_code) Religion_en,     ',
'    to_Date(SUBSTR(birth_date,0,10),''dd-mm-yyyy'' ) birth_date,',
'    to_Date(SUBSTR(hire_date,0,10),''dd-mm-yyyy'' ) hire_date,',
'    to_Date(SUBSTR(original_hire_date,0,10),''dd-mm-yyyy'' ) original_hire_date,',
'    email,',
'    mobile_sms,',
'    location_id,',
'    (select desc_e',
'        from dct_employees_lookups',
'        where lookup_name = ''Locations Codes''',
'        and code = dct_employees_list2.location_id) Location_Name,',
'    decode(current_flag, ''Y'' ,''Yes'' ,''No'') Current_Flag,',
'    decode(primary_flag, ''Y'' ,''Yes'' ,''No'') primary_flag,',
'    assignment_type,',
'    assignment_id,',
'    assignment_number,',
'    pay_basis_id,',
'    assignment_status_type_id,',
'     (select desc_e',
'        from dct_employees_lookups',
'        where lookup_name = ''Assignment Status Types''',
'        and code = dct_employees_list2.assignment_status_type_id) Assignment_Status_en,',
'    (select desc_a',
'        from dct_employees_lookups',
'        where lookup_name = ''Assignment Status Types''',
'        and code = dct_employees_list2.assignment_status_type_id) Assignment_Status_ar,',
'    people_group_id,',
'    (select desc_e',
'        from dct_employees_lookups',
'        where lookup_name = ''PeopleGroupId''',
'        and code = dct_employees_list2.people_group_id) People_Group,',
'    user_id,',
'    user_name, PHONE_NOS,',
'    last_updatedate_people,',
'    last_updatedate_assignments,',
'    business_group_id,',
'    assignment_category_id,',
'    employment_category_id,',
'    to_Date(SUBSTR(termination_date,0,10),''dd-mm-yyyy'' ) termination_date,',
'    photo_blob,',
'    photo_name,',
'    photo_mimetype,',
'    photo_charset, PHOTO_LASTUPD,',
'    ( select  sum(net_pay)',
'        from dct_employees_payroll',
'        where  month = (select distinct max(month) from dct_employees_payroll)',
'        and  employee_number = dct_employees_list2.employee_num) Last_Payroll',
'   , CASE',
'        WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || user_name',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END PHOTO     ',
'FROM',
'    dct_employees_list2',
'where organization_id = :P8_ORG_ID',
'and current_flag = ''Y'';'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Employees'
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
 p_id=>wwv_flow_api.id(7695634722798979)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>7695634722798979
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4600857782153481)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>10
,p_column_identifier=>'C'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4605663465153487)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>20
,p_column_identifier=>'O'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4617646748153500)
,p_db_column_name=>'EMAIL'
,p_display_order=>40
,p_column_identifier=>'AS'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4624079424153507)
,p_db_column_name=>'USER_NAME'
,p_display_order=>50
,p_column_identifier=>'BI'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4607670621153489)
,p_db_column_name=>'SUPERVISOR_NAME'
,p_display_order=>60
,p_column_identifier=>'T'
,p_column_label=>'Report to'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4600053066153480)
,p_db_column_name=>'PERSON_TYPE_ID'
,p_display_order=>70
,p_column_identifier=>'A'
,p_column_label=>'Person Type Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4600454483153481)
,p_db_column_name=>'PERSON_TYPE_NAME'
,p_display_order=>80
,p_column_identifier=>'B'
,p_column_label=>'Person Type Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4601218943153482)
,p_db_column_name=>'PAYROLL_ID'
,p_display_order=>90
,p_column_identifier=>'D'
,p_column_label=>'Payroll Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4601604382153482)
,p_db_column_name=>'PAYROLL_NAME'
,p_display_order=>100
,p_column_identifier=>'E'
,p_column_label=>'Payroll Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4602045655153483)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>110
,p_column_identifier=>'F'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4602420013153483)
,p_db_column_name=>'TITLE'
,p_display_order=>120
,p_column_identifier=>'G'
,p_column_label=>'Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4602885747153484)
,p_db_column_name=>'FIRST_NAME'
,p_display_order=>130
,p_column_identifier=>'H'
,p_column_label=>'First Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4603294434153484)
,p_db_column_name=>'SECOND_NAME'
,p_display_order=>140
,p_column_identifier=>'I'
,p_column_label=>'Second Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4603620096153485)
,p_db_column_name=>'THIRD_NAME'
,p_display_order=>150
,p_column_identifier=>'J'
,p_column_label=>'Third Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4604032862153485)
,p_db_column_name=>'LAST_NAME'
,p_display_order=>160
,p_column_identifier=>'K'
,p_column_label=>'Last Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4604423295153485)
,p_db_column_name=>'FIRST_NAME_AR'
,p_display_order=>170
,p_column_identifier=>'L'
,p_column_label=>'First Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4604819289153486)
,p_db_column_name=>'SECOND_NAME_AR'
,p_display_order=>180
,p_column_identifier=>'M'
,p_column_label=>'Second Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4605249464153486)
,p_db_column_name=>'LAST_NAME_AR'
,p_display_order=>190
,p_column_identifier=>'N'
,p_column_label=>'Last Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4606030015153487)
,p_db_column_name=>'FULL_NAME_AR'
,p_display_order=>200
,p_column_identifier=>'P'
,p_column_label=>'Full Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4606485288153488)
,p_db_column_name=>'NATIONAL_IDENTIFIER'
,p_display_order=>210
,p_column_identifier=>'Q'
,p_column_label=>'National Identifier'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4606827420153488)
,p_db_column_name=>'MANAGER_FLAG'
,p_display_order=>220
,p_column_identifier=>'R'
,p_column_label=>'Manager Flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4607269826153489)
,p_db_column_name=>'SUPERVISOR_NUM'
,p_display_order=>230
,p_column_identifier=>'S'
,p_column_label=>'Supervisor Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4608000269153490)
,p_db_column_name=>'SUPERVISOR_EMAIL'
,p_display_order=>240
,p_column_identifier=>'U'
,p_column_label=>'Supervisor Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4608446103153490)
,p_db_column_name=>'ORGANIZATION_ID'
,p_display_order=>250
,p_column_identifier=>'V'
,p_column_label=>'Organization Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4608842923153490)
,p_db_column_name=>'ORGANIZATION_EN'
,p_display_order=>260
,p_column_identifier=>'W'
,p_column_label=>'Organization En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4609206304153491)
,p_db_column_name=>'ORGANIZATION_AR'
,p_display_order=>270
,p_column_identifier=>'X'
,p_column_label=>'Organization Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4609652842153491)
,p_db_column_name=>'JOB_ID'
,p_display_order=>280
,p_column_identifier=>'Y'
,p_column_label=>'Job Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4610028481153492)
,p_db_column_name=>'JOB_NAME_AR'
,p_display_order=>290
,p_column_identifier=>'Z'
,p_column_label=>'Job Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4610467540153492)
,p_db_column_name=>'JOB_NAME_EN'
,p_display_order=>300
,p_column_identifier=>'AA'
,p_column_label=>'Job Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4610860316153493)
,p_db_column_name=>'POSITION_ID'
,p_display_order=>310
,p_column_identifier=>'AB'
,p_column_label=>'Position Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4611248092153493)
,p_db_column_name=>'POSITION_NAME_EN'
,p_display_order=>320
,p_column_identifier=>'AC'
,p_column_label=>'Position Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4611610636153493)
,p_db_column_name=>'POSITION_NAME_AR'
,p_display_order=>330
,p_column_identifier=>'AD'
,p_column_label=>'Position Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4612012190153494)
,p_db_column_name=>'GRADE_ID'
,p_display_order=>340
,p_column_identifier=>'AE'
,p_column_label=>'Grade Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4612456673153494)
,p_db_column_name=>'GRAD_NAME'
,p_display_order=>350
,p_column_identifier=>'AF'
,p_column_label=>'Grad Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4612889704153495)
,p_db_column_name=>'NATIONALITY_CODE'
,p_display_order=>360
,p_column_identifier=>'AG'
,p_column_label=>'Nationality Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4613299775153495)
,p_db_column_name=>'NATIONALITY_EN'
,p_display_order=>370
,p_column_identifier=>'AH'
,p_column_label=>'Nationality En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4613640064153496)
,p_db_column_name=>'NATIONALITY_AR'
,p_display_order=>380
,p_column_identifier=>'AI'
,p_column_label=>'Nationality Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4614069301153496)
,p_db_column_name=>'GENDER'
,p_display_order=>390
,p_column_identifier=>'AJ'
,p_column_label=>'Gender'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4614487019153497)
,p_db_column_name=>'MARITAL_STATUS'
,p_display_order=>400
,p_column_identifier=>'AK'
,p_column_label=>'Marital Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4614888847153497)
,p_db_column_name=>'MARITAL_STATUS_DESC'
,p_display_order=>410
,p_column_identifier=>'AL'
,p_column_label=>'Marital Status Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4615267968153498)
,p_db_column_name=>'RELIGION_CODE'
,p_display_order=>420
,p_column_identifier=>'AM'
,p_column_label=>'Religion Code'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4615607335153498)
,p_db_column_name=>'RELIGION_AR'
,p_display_order=>430
,p_column_identifier=>'AN'
,p_column_label=>'Religion Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4616082382153499)
,p_db_column_name=>'RELIGION_EN'
,p_display_order=>440
,p_column_identifier=>'AO'
,p_column_label=>'Religion En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4616436055153499)
,p_db_column_name=>'BIRTH_DATE'
,p_display_order=>450
,p_column_identifier=>'AP'
,p_column_label=>'Birth Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4616805500153500)
,p_db_column_name=>'HIRE_DATE'
,p_display_order=>460
,p_column_identifier=>'AQ'
,p_column_label=>'Hire Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4617207176153500)
,p_db_column_name=>'ORIGINAL_HIRE_DATE'
,p_display_order=>470
,p_column_identifier=>'AR'
,p_column_label=>'Original Hire Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4618063309153501)
,p_db_column_name=>'MOBILE_SMS'
,p_display_order=>480
,p_column_identifier=>'AT'
,p_column_label=>'Mobile Sms'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4618445877153501)
,p_db_column_name=>'LOCATION_ID'
,p_display_order=>490
,p_column_identifier=>'AU'
,p_column_label=>'Location Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4618803213153502)
,p_db_column_name=>'LOCATION_NAME'
,p_display_order=>500
,p_column_identifier=>'AV'
,p_column_label=>'Location Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4619260980153502)
,p_db_column_name=>'CURRENT_FLAG'
,p_display_order=>510
,p_column_identifier=>'AW'
,p_column_label=>'Current Flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4619628149153503)
,p_db_column_name=>'PRIMARY_FLAG'
,p_display_order=>520
,p_column_identifier=>'AX'
,p_column_label=>'Primary Flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4620037635153503)
,p_db_column_name=>'ASSIGNMENT_TYPE'
,p_display_order=>530
,p_column_identifier=>'AY'
,p_column_label=>'Assignment Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4620497228153504)
,p_db_column_name=>'ASSIGNMENT_ID'
,p_display_order=>540
,p_column_identifier=>'AZ'
,p_column_label=>'Assignment Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4620896194153504)
,p_db_column_name=>'ASSIGNMENT_NUMBER'
,p_display_order=>550
,p_column_identifier=>'BA'
,p_column_label=>'Assignment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4621238658153505)
,p_db_column_name=>'PAY_BASIS_ID'
,p_display_order=>560
,p_column_identifier=>'BB'
,p_column_label=>'Pay Basis Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4621689573153505)
,p_db_column_name=>'ASSIGNMENT_STATUS_TYPE_ID'
,p_display_order=>570
,p_column_identifier=>'BC'
,p_column_label=>'Assignment Status Type Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4622010983153505)
,p_db_column_name=>'ASSIGNMENT_STATUS_EN'
,p_display_order=>580
,p_column_identifier=>'BD'
,p_column_label=>'Assignment Status En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4622420607153506)
,p_db_column_name=>'ASSIGNMENT_STATUS_AR'
,p_display_order=>590
,p_column_identifier=>'BE'
,p_column_label=>'Assignment Status Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4622858230153506)
,p_db_column_name=>'PEOPLE_GROUP_ID'
,p_display_order=>600
,p_column_identifier=>'BF'
,p_column_label=>'People Group Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4623267970153507)
,p_db_column_name=>'PEOPLE_GROUP'
,p_display_order=>610
,p_column_identifier=>'BG'
,p_column_label=>'People Group'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4623698276153507)
,p_db_column_name=>'USER_ID'
,p_display_order=>620
,p_column_identifier=>'BH'
,p_column_label=>'User Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4624467219153508)
,p_db_column_name=>'PHONE_NOS'
,p_display_order=>630
,p_column_identifier=>'BJ'
,p_column_label=>'Phone Nos'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4624859387153508)
,p_db_column_name=>'LAST_UPDATEDATE_PEOPLE'
,p_display_order=>640
,p_column_identifier=>'BK'
,p_column_label=>'Last Updatedate People'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4625203724153509)
,p_db_column_name=>'LAST_UPDATEDATE_ASSIGNMENTS'
,p_display_order=>650
,p_column_identifier=>'BL'
,p_column_label=>'Last Updatedate Assignments'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4625606705153509)
,p_db_column_name=>'BUSINESS_GROUP_ID'
,p_display_order=>660
,p_column_identifier=>'BM'
,p_column_label=>'Business Group Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4626040520153509)
,p_db_column_name=>'ASSIGNMENT_CATEGORY_ID'
,p_display_order=>670
,p_column_identifier=>'BN'
,p_column_label=>'Assignment Category Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4626484474153510)
,p_db_column_name=>'EMPLOYMENT_CATEGORY_ID'
,p_display_order=>680
,p_column_identifier=>'BO'
,p_column_label=>'Employment Category Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4626811084153510)
,p_db_column_name=>'TERMINATION_DATE'
,p_display_order=>690
,p_column_identifier=>'BP'
,p_column_label=>'Termination Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4627236969153511)
,p_db_column_name=>'PHOTO_BLOB'
,p_display_order=>700
,p_column_identifier=>'BQ'
,p_column_label=>'Photo Blob'
,p_column_html_expression=>'<img src="#PHOTO_BLOB#" alt="Image Not Found" height="40" width="40">'
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
 p_id=>wwv_flow_api.id(4627625682153511)
,p_db_column_name=>'PHOTO_NAME'
,p_display_order=>710
,p_column_identifier=>'BR'
,p_column_label=>'Photo Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4628054788153512)
,p_db_column_name=>'PHOTO_MIMETYPE'
,p_display_order=>720
,p_column_identifier=>'BS'
,p_column_label=>'Photo Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4628471783153512)
,p_db_column_name=>'PHOTO_CHARSET'
,p_display_order=>730
,p_column_identifier=>'BT'
,p_column_label=>'Photo Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4628843098153513)
,p_db_column_name=>'PHOTO_LASTUPD'
,p_display_order=>740
,p_column_identifier=>'BU'
,p_column_label=>'Photo Lastupd'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4629267551153514)
,p_db_column_name=>'LAST_PAYROLL'
,p_display_order=>750
,p_column_identifier=>'BV'
,p_column_label=>'Last Payroll'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4629607327153514)
,p_db_column_name=>'PHOTO'
,p_display_order=>760
,p_column_identifier=>'BW'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(7791745576127834)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'46300'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EMPLOYEE_NUM:FULL_NAME_EN:EMAIL:USER_NAME:SUPERVISOR_NAME_BLOB::PHOTO'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4586531714153466)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(7739093545111662)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>'P8_ORG_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4585705945153466)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(7739093545111662)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4586996496153467)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(7739093545111662)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition=>'P8_ORG_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4586100258153466)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(7739093545111662)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition_type=>'NEVER'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(4640337540153525)
,p_branch_name=>'Go To Page 7'
,p_branch_action=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
,p_branch_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_branch_condition=>'P8_FROM_PAGE'
,p_branch_condition_text=>'7'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(4499150048948226)
,p_branch_name=>'Go To Page 5'
,p_branch_action=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>11
,p_branch_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_branch_condition=>'P8_FROM_PAGE'
,p_branch_condition_text=>'5'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4499086390948225)
,p_name=>'P8_FROM_PAGE'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4587347482153467)
,p_name=>'P8_ORG_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_source=>'ORG_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4587710031153467)
,p_name=>'P8_ORG_NAME_EN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Organization Name  (EN)'
,p_source=>'ORG_NAME_EN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4588119077153467)
,p_name=>'P8_ORG_NAME_EN_USER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Organization Name  - User (EN)'
,p_source=>'ORG_NAME_EN_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>128
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4588582576153468)
,p_name=>'P8_ORG_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Organization Name  (AR)'
,p_source=>'ORG_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
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
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4588922274153468)
,p_name=>'P8_ORG_NAME_AR_USER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Organization Name  - User (AR)'
,p_source=>'ORG_NAME_AR_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>128
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4589336588153468)
,p_name=>'P8_ORG_LEVEL_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Level'
,p_source=>'ORG_LEVEL_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4589720958153468)
,p_name=>'P8_ORG_LEVEL_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Level - User'
,p_source=>'ORG_LEVEL_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'HR LEVELS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select level_name , level_id',
'from dct_hr_org_levels',
'where status = ''A''',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4590106549153469)
,p_name=>'P8_PARENT_ORG_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Parent Organization'
,p_source=>'PARENT_ORG_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ORGANIZATIONS ALL LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ORG_NAME_EN, ORG_ID',
'from (',
'Select nvl(ORG_NAME_EN_USER , org_name_en) org_name_en , org_id',
'from dct_hr_organizations)',
'',
'--Select org_name_en , org_id',
'--from dct_hr_organizations'))
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>255
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4590523577153469)
,p_name=>'P8_PARENT_ORG_ID_USER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Parent Organization - User'
,p_source=>'PARENT_ORG_ID_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ORGANIZATIONS ALL LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ORG_NAME_EN, ORG_ID',
'from (',
'Select nvl(ORG_NAME_EN_USER , org_name_en) org_name_en , org_id',
'from dct_hr_organizations)',
'',
'--Select org_name_en , org_id',
'--from dct_hr_organizations'))
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4590991464153469)
,p_name=>'P8_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'STATUS LOV'
,p_lov=>'.'||wwv_flow_api.id(4580824401142588)||'.'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4591300782153469)
,p_name=>'P8_COST_CENTER_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Cost Center Code'
,p_source=>'COST_CENTER_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select COST_CENTER_CODE || ',
'        '' (''            ||',
'        COST_CENTER_DESCRIPTION ||',
'        '')'' as d',
'        , COST_CENTER_CODE',
'from (',
'select DISTINCT cost_center_code as cost_center_code, COST_CENTER_DESCRIPTION ',
'from dct_gl_code_combinations_all',
'    order by 1',
')'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4591758967153470)
,p_name=>'P8_SHORT_NAME_EN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Short Name (EN)'
,p_source=>'SHORT_NAME_EN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>128
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4592189923153470)
,p_name=>'P8_MANAGER_EMP_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Manager'
,p_source=>'MANAGER_EMP_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ALL EMPLOYEES BY EMP NUM LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en ',
'    , employee_num',
'from dct_employees_list2'))
,p_lov_display_null=>'YES'
,p_cSize=>40
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4592556740153470)
,p_name=>'P8_FBP_ROLE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Finance Business Partner Role'
,p_source=>'FBP_ROLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'FPB_ROLS_ALL_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select role_id , role_name',
'from roles',
'where main_category = 22'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4592994366153470)
,p_name=>'P8_PARTNER_EMP_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Finance Business Partner'
,p_source=>'PARTNER_EMP_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ALL EMPLOYEES BY EMP NUM LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en ',
'    , employee_num',
'from dct_employees_list2'))
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>50
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4593361633153471)
,p_name=>'P8_ORG_RATE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Finance Performance Rate'
,p_source=>'ORG_RATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_STAR_RATING'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'5'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4593730120153471)
,p_name=>'P8_SERVICE_PROVIDER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Service Provider ?'
,p_source=>'SERVICE_PROVIDER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4594164684153471)
,p_name=>'P8_ORG_PRIORITY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Priority'
,p_source=>'ORG_PRIORITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_STAR_RATING'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'10'
,p_attribute_02=>'N'
,p_attribute_03=>'fa-fire fa-anim-flash'
,p_attribute_04=>'#29C2B0'
,p_attribute_06=>'#VALUE#'
,p_attribute_07=>'N'
,p_attribute_08=>'Y'
,p_attribute_09=>'STARS_AND_VALUE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4594546210153471)
,p_name=>'P8_START_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'START_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4594955182153471)
,p_name=>'P8_END_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'END_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4595320820153472)
,p_name=>'P8_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4595717014153472)
,p_name=>'P8_CREATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Created Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4596162697153472)
,p_name=>'P8_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4596560828153472)
,p_name=>'P8_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_prompt=>'Updated Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4596961775153477)
,p_name=>'P8_SHORT_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_source=>'SHORT_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4597322013153478)
,p_name=>'P8_HR_STRUCTURE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_source=>'HR_STRUCTURE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4597770322153478)
,p_name=>'P8_VERSION'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_source=>'VERSION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4598124346153478)
,p_name=>'P8_DATE_FROM'
,p_source_data_type=>'DATE'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_source=>'DATE_FROM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4598546936153478)
,p_name=>'P8_SOURCE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(7739093545111662)
,p_item_source_plug_id=>wwv_flow_api.id(7739093545111662)
,p_source=>'SOURCE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(4639556879153524)
,p_validation_name=>'P8_CREATED_DATE must be timestamp'
,p_validation_sequence=>250
,p_validation=>'P8_CREATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(4595717014153472)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(4639973095153524)
,p_validation_name=>'P8_UPDATED_DATE must be timestamp'
,p_validation_sequence=>270
,p_validation=>'P8_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(4596560828153472)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(4599385045153479)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(7739093545111662)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Organization Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(4598976966153479)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(7739093545111662)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Organization Details'
);
wwv_flow_api.component_end;
end;
/
