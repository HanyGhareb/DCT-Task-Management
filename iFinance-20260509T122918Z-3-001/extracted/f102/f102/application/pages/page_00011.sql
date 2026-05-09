prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
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
 p_id=>11
,p_user_interface_id=>wwv_flow_api.id(3440093928015830)
,p_name=>'Organization Details'
,p_alias=>'ORGANIZATION-DETAILS1'
,p_step_title=>'Organization Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210221032616'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8066853564964089)
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
 p_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(8023954828651491)
,p_plug_name=>'Employees'
,p_parent_plug_id=>wwv_flow_api.id(8067499742964175)
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
'where organization_id = :P11_ORG_ID',
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
 p_id=>wwv_flow_api.id(8024040920651492)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>8024040920651492
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4929255840005991)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>10
,p_column_identifier=>'C'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4934085421005997)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>20
,p_column_identifier=>'O'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4946006890006013)
,p_db_column_name=>'EMAIL'
,p_display_order=>40
,p_column_identifier=>'AS'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4952424361006021)
,p_db_column_name=>'USER_NAME'
,p_display_order=>50
,p_column_identifier=>'BI'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4936054400006000)
,p_db_column_name=>'SUPERVISOR_NAME'
,p_display_order=>60
,p_column_identifier=>'T'
,p_column_label=>'Report to'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4928492469005989)
,p_db_column_name=>'PERSON_TYPE_ID'
,p_display_order=>70
,p_column_identifier=>'A'
,p_column_label=>'Person Type Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4928880327005990)
,p_db_column_name=>'PERSON_TYPE_NAME'
,p_display_order=>80
,p_column_identifier=>'B'
,p_column_label=>'Person Type Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4929601009005991)
,p_db_column_name=>'PAYROLL_ID'
,p_display_order=>90
,p_column_identifier=>'D'
,p_column_label=>'Payroll Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4930042985005992)
,p_db_column_name=>'PAYROLL_NAME'
,p_display_order=>100
,p_column_identifier=>'E'
,p_column_label=>'Payroll Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4930405914005993)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>110
,p_column_identifier=>'F'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4930817326005993)
,p_db_column_name=>'TITLE'
,p_display_order=>120
,p_column_identifier=>'G'
,p_column_label=>'Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4931270326005994)
,p_db_column_name=>'FIRST_NAME'
,p_display_order=>130
,p_column_identifier=>'H'
,p_column_label=>'First Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4931646849005994)
,p_db_column_name=>'SECOND_NAME'
,p_display_order=>140
,p_column_identifier=>'I'
,p_column_label=>'Second Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4932094151005995)
,p_db_column_name=>'THIRD_NAME'
,p_display_order=>150
,p_column_identifier=>'J'
,p_column_label=>'Third Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4932498253005995)
,p_db_column_name=>'LAST_NAME'
,p_display_order=>160
,p_column_identifier=>'K'
,p_column_label=>'Last Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4932830479005996)
,p_db_column_name=>'FIRST_NAME_AR'
,p_display_order=>170
,p_column_identifier=>'L'
,p_column_label=>'First Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4933225118005996)
,p_db_column_name=>'SECOND_NAME_AR'
,p_display_order=>180
,p_column_identifier=>'M'
,p_column_label=>'Second Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4933657435005997)
,p_db_column_name=>'LAST_NAME_AR'
,p_display_order=>190
,p_column_identifier=>'N'
,p_column_label=>'Last Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4934498155005998)
,p_db_column_name=>'FULL_NAME_AR'
,p_display_order=>200
,p_column_identifier=>'P'
,p_column_label=>'Full Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4934805574005998)
,p_db_column_name=>'NATIONAL_IDENTIFIER'
,p_display_order=>210
,p_column_identifier=>'Q'
,p_column_label=>'National Identifier'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4935248443005999)
,p_db_column_name=>'MANAGER_FLAG'
,p_display_order=>220
,p_column_identifier=>'R'
,p_column_label=>'Manager Flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4935640257006000)
,p_db_column_name=>'SUPERVISOR_NUM'
,p_display_order=>230
,p_column_identifier=>'S'
,p_column_label=>'Supervisor Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4936450493006001)
,p_db_column_name=>'SUPERVISOR_EMAIL'
,p_display_order=>240
,p_column_identifier=>'U'
,p_column_label=>'Supervisor Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4936833952006001)
,p_db_column_name=>'ORGANIZATION_ID'
,p_display_order=>250
,p_column_identifier=>'V'
,p_column_label=>'Organization Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4937259202006002)
,p_db_column_name=>'ORGANIZATION_EN'
,p_display_order=>260
,p_column_identifier=>'W'
,p_column_label=>'Organization En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4937690039006002)
,p_db_column_name=>'ORGANIZATION_AR'
,p_display_order=>270
,p_column_identifier=>'X'
,p_column_label=>'Organization Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4938010321006003)
,p_db_column_name=>'JOB_ID'
,p_display_order=>280
,p_column_identifier=>'Y'
,p_column_label=>'Job Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4938487200006003)
,p_db_column_name=>'JOB_NAME_AR'
,p_display_order=>290
,p_column_identifier=>'Z'
,p_column_label=>'Job Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4938854134006004)
,p_db_column_name=>'JOB_NAME_EN'
,p_display_order=>300
,p_column_identifier=>'AA'
,p_column_label=>'Job Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4939252464006004)
,p_db_column_name=>'POSITION_ID'
,p_display_order=>310
,p_column_identifier=>'AB'
,p_column_label=>'Position Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4939610778006005)
,p_db_column_name=>'POSITION_NAME_EN'
,p_display_order=>320
,p_column_identifier=>'AC'
,p_column_label=>'Position Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4940091363006005)
,p_db_column_name=>'POSITION_NAME_AR'
,p_display_order=>330
,p_column_identifier=>'AD'
,p_column_label=>'Position Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4940484874006006)
,p_db_column_name=>'GRADE_ID'
,p_display_order=>340
,p_column_identifier=>'AE'
,p_column_label=>'Grade Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4940893031006007)
,p_db_column_name=>'GRAD_NAME'
,p_display_order=>350
,p_column_identifier=>'AF'
,p_column_label=>'Grad Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4941263953006007)
,p_db_column_name=>'NATIONALITY_CODE'
,p_display_order=>360
,p_column_identifier=>'AG'
,p_column_label=>'Nationality Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4941628677006008)
,p_db_column_name=>'NATIONALITY_EN'
,p_display_order=>370
,p_column_identifier=>'AH'
,p_column_label=>'Nationality En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4942067659006008)
,p_db_column_name=>'NATIONALITY_AR'
,p_display_order=>380
,p_column_identifier=>'AI'
,p_column_label=>'Nationality Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4942461567006009)
,p_db_column_name=>'GENDER'
,p_display_order=>390
,p_column_identifier=>'AJ'
,p_column_label=>'Gender'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4942822779006009)
,p_db_column_name=>'MARITAL_STATUS'
,p_display_order=>400
,p_column_identifier=>'AK'
,p_column_label=>'Marital Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4943219829006010)
,p_db_column_name=>'MARITAL_STATUS_DESC'
,p_display_order=>410
,p_column_identifier=>'AL'
,p_column_label=>'Marital Status Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4943604605006010)
,p_db_column_name=>'RELIGION_CODE'
,p_display_order=>420
,p_column_identifier=>'AM'
,p_column_label=>'Religion Code'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4944059306006010)
,p_db_column_name=>'RELIGION_AR'
,p_display_order=>430
,p_column_identifier=>'AN'
,p_column_label=>'Religion Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4944422359006011)
,p_db_column_name=>'RELIGION_EN'
,p_display_order=>440
,p_column_identifier=>'AO'
,p_column_label=>'Religion En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4944898265006011)
,p_db_column_name=>'BIRTH_DATE'
,p_display_order=>450
,p_column_identifier=>'AP'
,p_column_label=>'Birth Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4945295233006012)
,p_db_column_name=>'HIRE_DATE'
,p_display_order=>460
,p_column_identifier=>'AQ'
,p_column_label=>'Hire Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4945695975006012)
,p_db_column_name=>'ORIGINAL_HIRE_DATE'
,p_display_order=>470
,p_column_identifier=>'AR'
,p_column_label=>'Original Hire Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4946417085006013)
,p_db_column_name=>'MOBILE_SMS'
,p_display_order=>480
,p_column_identifier=>'AT'
,p_column_label=>'Mobile Sms'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4946867826006014)
,p_db_column_name=>'LOCATION_ID'
,p_display_order=>490
,p_column_identifier=>'AU'
,p_column_label=>'Location Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4947287079006014)
,p_db_column_name=>'LOCATION_NAME'
,p_display_order=>500
,p_column_identifier=>'AV'
,p_column_label=>'Location Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4947675188006015)
,p_db_column_name=>'CURRENT_FLAG'
,p_display_order=>510
,p_column_identifier=>'AW'
,p_column_label=>'Current Flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4948024868006015)
,p_db_column_name=>'PRIMARY_FLAG'
,p_display_order=>520
,p_column_identifier=>'AX'
,p_column_label=>'Primary Flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4948421849006016)
,p_db_column_name=>'ASSIGNMENT_TYPE'
,p_display_order=>530
,p_column_identifier=>'AY'
,p_column_label=>'Assignment Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4948853720006016)
,p_db_column_name=>'ASSIGNMENT_ID'
,p_display_order=>540
,p_column_identifier=>'AZ'
,p_column_label=>'Assignment Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4949207273006017)
,p_db_column_name=>'ASSIGNMENT_NUMBER'
,p_display_order=>550
,p_column_identifier=>'BA'
,p_column_label=>'Assignment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4949640508006017)
,p_db_column_name=>'PAY_BASIS_ID'
,p_display_order=>560
,p_column_identifier=>'BB'
,p_column_label=>'Pay Basis Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4950053711006017)
,p_db_column_name=>'ASSIGNMENT_STATUS_TYPE_ID'
,p_display_order=>570
,p_column_identifier=>'BC'
,p_column_label=>'Assignment Status Type Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4950484977006018)
,p_db_column_name=>'ASSIGNMENT_STATUS_EN'
,p_display_order=>580
,p_column_identifier=>'BD'
,p_column_label=>'Assignment Status En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4950878704006018)
,p_db_column_name=>'ASSIGNMENT_STATUS_AR'
,p_display_order=>590
,p_column_identifier=>'BE'
,p_column_label=>'Assignment Status Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4951214686006019)
,p_db_column_name=>'PEOPLE_GROUP_ID'
,p_display_order=>600
,p_column_identifier=>'BF'
,p_column_label=>'People Group Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4951674157006019)
,p_db_column_name=>'PEOPLE_GROUP'
,p_display_order=>610
,p_column_identifier=>'BG'
,p_column_label=>'People Group'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4952095123006020)
,p_db_column_name=>'USER_ID'
,p_display_order=>620
,p_column_identifier=>'BH'
,p_column_label=>'User Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4952893006006021)
,p_db_column_name=>'PHONE_NOS'
,p_display_order=>630
,p_column_identifier=>'BJ'
,p_column_label=>'Phone Nos'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4953219223006022)
,p_db_column_name=>'LAST_UPDATEDATE_PEOPLE'
,p_display_order=>640
,p_column_identifier=>'BK'
,p_column_label=>'Last Updatedate People'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4953671382006022)
,p_db_column_name=>'LAST_UPDATEDATE_ASSIGNMENTS'
,p_display_order=>650
,p_column_identifier=>'BL'
,p_column_label=>'Last Updatedate Assignments'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4954053366006023)
,p_db_column_name=>'BUSINESS_GROUP_ID'
,p_display_order=>660
,p_column_identifier=>'BM'
,p_column_label=>'Business Group Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4954404508006023)
,p_db_column_name=>'ASSIGNMENT_CATEGORY_ID'
,p_display_order=>670
,p_column_identifier=>'BN'
,p_column_label=>'Assignment Category Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4954842787006024)
,p_db_column_name=>'EMPLOYMENT_CATEGORY_ID'
,p_display_order=>680
,p_column_identifier=>'BO'
,p_column_label=>'Employment Category Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4955252534006024)
,p_db_column_name=>'TERMINATION_DATE'
,p_display_order=>690
,p_column_identifier=>'BP'
,p_column_label=>'Termination Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4955627288006025)
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
 p_id=>wwv_flow_api.id(4956012446006025)
,p_db_column_name=>'PHOTO_NAME'
,p_display_order=>710
,p_column_identifier=>'BR'
,p_column_label=>'Photo Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4956496667006026)
,p_db_column_name=>'PHOTO_MIMETYPE'
,p_display_order=>720
,p_column_identifier=>'BS'
,p_column_label=>'Photo Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4956863048006026)
,p_db_column_name=>'PHOTO_CHARSET'
,p_display_order=>730
,p_column_identifier=>'BT'
,p_column_label=>'Photo Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4957262433006026)
,p_db_column_name=>'PHOTO_LASTUPD'
,p_display_order=>740
,p_column_identifier=>'BU'
,p_column_label=>'Photo Lastupd'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4957666384006027)
,p_db_column_name=>'LAST_PAYROLL'
,p_display_order=>750
,p_column_identifier=>'BV'
,p_column_label=>'Last Payroll'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4958075981006027)
,p_db_column_name=>'PHOTO'
,p_display_order=>760
,p_column_identifier=>'BW'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(8120151773980347)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'49584'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EMPLOYEE_NUM:FULL_NAME_EN:EMAIL:USER_NAME:SUPERVISOR_NAME_BLOB::PHOTO'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4914928868005980)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(8067499742964175)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>'P11_ORG_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4914190019005979)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(8067499742964175)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:&P11_PAGE_FROM.:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4915325081005980)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(8067499742964175)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition=>'P11_ORG_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4914538309005980)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4969080080006036)
,p_branch_name=>'Go To Page &P11_PAGE_FROM'
,p_branch_action=>'f?p=&APP_ID.:&P11_PAGE_FROM.:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4915788824005981)
,p_name=>'P11_ORG_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
,p_source=>'ORG_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4916123341005981)
,p_name=>'P11_ORG_NAME_EN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4916541775005981)
,p_name=>'P11_ORG_NAME_EN_USER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4916931705005982)
,p_name=>'P11_ORG_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4917358735005982)
,p_name=>'P11_ORG_NAME_AR_USER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4917703602005982)
,p_name=>'P11_ORG_LEVEL_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4918148427005982)
,p_name=>'P11_ORG_LEVEL_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4918545536005982)
,p_name=>'P11_PARENT_ORG_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4918935777005983)
,p_name=>'P11_PARENT_ORG_ID_USER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4919360034005983)
,p_name=>'P11_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'STATUS LOV'
,p_lov=>'.'||wwv_flow_api.id(4580824401142588)||'.'
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
 p_id=>wwv_flow_api.id(4919709569005983)
,p_name=>'P11_COST_CENTER_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
,p_prompt=>'Cost Center Code'
,p_source=>'COST_CENTER_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4920183630005983)
,p_name=>'P11_SHORT_NAME_EN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4920519616005984)
,p_name=>'P11_MANAGER_EMP_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4920913076005984)
,p_name=>'P11_FBP_ROLE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4921399451005984)
,p_name=>'P11_PARTNER_EMP_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
,p_prompt=>'Finance Business Partner'
,p_source=>'PARTNER_EMP_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
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
 p_id=>wwv_flow_api.id(4921794003005984)
,p_name=>'P11_ORG_RATE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4922194520005985)
,p_name=>'P11_SERVICE_PROVIDER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4922525980005985)
,p_name=>'P11_ORG_PRIORITY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4922986746005985)
,p_name=>'P11_START_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4923323243005985)
,p_name=>'P11_END_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4923727335005985)
,p_name=>'P11_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4924179108005986)
,p_name=>'P11_CREATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4924551830005986)
,p_name=>'P11_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4924940436005986)
,p_name=>'P11_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
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
 p_id=>wwv_flow_api.id(4925320302005986)
,p_name=>'P11_SHORT_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
,p_source=>'SHORT_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4925724543005987)
,p_name=>'P11_HR_STRUCTURE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
,p_source=>'HR_STRUCTURE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4926197611005987)
,p_name=>'P11_VERSION'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
,p_source=>'VERSION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4926524763005987)
,p_name=>'P11_DATE_FROM'
,p_source_data_type=>'DATE'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
,p_source=>'DATE_FROM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4926996441005987)
,p_name=>'P11_SOURCE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_item_source_plug_id=>wwv_flow_api.id(8067499742964175)
,p_source=>'SOURCE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(19682006127898122)
,p_name=>'P11_PAGE_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(8067499742964175)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(4968294894006035)
,p_validation_name=>'P11_CREATED_DATE must be timestamp'
,p_validation_sequence=>250
,p_validation=>'P11_CREATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(4924179108005986)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(4968668276006036)
,p_validation_name=>'P11_UPDATED_DATE must be timestamp'
,p_validation_sequence=>270
,p_validation=>'P11_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(4924940436005986)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(4927774660005988)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(8067499742964175)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Organization Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(4927377798005988)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(8067499742964175)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Organization Details'
);
wwv_flow_api.component_end;
end;
/
