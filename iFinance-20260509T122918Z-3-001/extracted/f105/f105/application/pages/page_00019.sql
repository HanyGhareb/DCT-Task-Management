prompt --application/pages/page_00019
begin
--   Manifest
--     PAGE: 00019
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
 p_id=>19
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Projects'
,p_alias=>'PROJECTS'
,p_step_title=>'Projects'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220808042816'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(95540332221877466)
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
 p_id=>wwv_flow_api.id(96016955516811400)
,p_plug_name=>'Projects'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(95540894305877467)
,p_plug_name=>'Projects'
,p_parent_plug_id=>wwv_flow_api.id(96016955516811400)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    p.project_number,',
'    p.project_code,',
'    p.project_name,',
'    p.project_type,',
'    p.project_status,',
'    p.tca_decision_number,',
'    p.project_mode,',
'    p.tca_project_phase,',
'    p.start_date,',
'    p.end_date,',
'    p.tca_project_location,',
'    p.tca_project_category,',
'    p.tca_project_activity,',
'    p.tca_strategic_projects,',
'    p.tca_programs,',
'    p.tca_output,',
'    p.tca_sector,',
'    p.tca_department,',
'    p.dct_sector_id,',
'    p.dct_department_id,',
'    p.dct_section_id,',
'    p.dct_unit_id,',
'    p.fin_project_name,',
'    p.service_provider,',
'    p.dct_mpr_allowed,',
'    p.dct_mpo_allowed,',
'    p.dct_project_rate,',
'    p.dct_status,',
'    p.ou_name,',
'    p.created_by,',
'    p.created_on,',
'    p.updated_by,',
'    p.updated_on,',
'    p.fin_project_code,',
'    p.director_person_id,',
'    (select e.full_name_en',
'    from employees_v e',
'    where e.person_id = p.director_person_id) Director_name,',
'    p.ed_person_id,',
'    (select e.full_name_en',
'    from employees_v e',
'    where e.person_id = p.ed_person_id) ED_name,',
'-- Project Balances',
'    pb.budget,',
'    pb.actual,',
'    pb.encumberance,',
'    pb.fund_available',
'/*',
'-- Task Detail',
'    ,(select count(task_number)',
'     from task t',
'     where t.project_number = p.project_number) Task_Count',
'-- End Users Access Active Count',
'    , (select count(distinct d.PERSON_ID)',
'from btf_data_access_requests d',
'where d.ENTITY_NAME = p.project_number',
'and REQUEST_STATUS in (''Approved'' , ''Auto-Approved'')',
'and sysdate between nvl(START_DATE , sysdate - 10) and nvl(END_DATE , sysdate + 10)) Active_End_user_count',
'',
'-- BTF End Users Requests Details',
'    , (select nvl(count(eu.REQUEST_ID),0)',
'        from btf_end_users_req eu',
'        where eu.PROJECT_NUMBER = p.project_number',
'        and eu.REQUEST_STATUS <> ''Draft'' ',
'        and eu.from_to = ''FROM'')    From_end_user_requests_count',
'    , (select nvl(count(eu.REQUEST_ID),0)',
'        from btf_end_users_req eu',
'        where eu.PROJECT_NUMBER = p.project_number',
'        and eu.REQUEST_STATUS <> ''Draft'' ',
'        and eu.from_to = ''TO'')    TO_end_user_requests_count        ',
'*/',
'FROM',
'    project p  , (select PROJECT_NUMBER, sum(BUDGET) Budget, sum(ACTUAL) Actual, sum(ENCUMBERANCE) Encumberance, sum(FUND_AVAILABLE) Fund_available',
'from project_balances',
'where accounting_year = :CURRENT_YEAR',
'GROUP by project_number',
'order by project_number) pb',
'where p.cwip_yn = ''N''',
'and p.project_number = pb.project_number (+)',
'and p.dct_status = :P19_SHOW_ALL --DECODE(:P19_SHOW_ALL, ''I'', ''I'', ''A'')',
'order by p.project_number;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P19_SHOW_ALL'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Projects'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(95540992869877467)
,p_name=>'Projects'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:19:P21_PROJECT_NUMBER,P21_PAGE_FROM:#PROJECT_NUMBER#,19'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>200897322061240880
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1165148499265112)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Project Number'
,p_column_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:21:P21_PROJECT_NUMBER,P21_PAGE_FROM:#PROJECT_NUMBER#,19'
,p_column_linktext=>'#PROJECT_NUMBER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1165533651265113)
,p_db_column_name=>'PROJECT_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Project Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1165924358265113)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1166340049265114)
,p_db_column_name=>'PROJECT_TYPE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Project Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1166692157265114)
,p_db_column_name=>'PROJECT_STATUS'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Project Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1167149852265115)
,p_db_column_name=>'TCA_DECISION_NUMBER'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'TCA Decision Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1167529431265116)
,p_db_column_name=>'PROJECT_MODE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Project Mode'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1167945271265116)
,p_db_column_name=>'TCA_PROJECT_PHASE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'TCA Project Phase'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1168277476265117)
,p_db_column_name=>'START_DATE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1168683887265117)
,p_db_column_name=>'END_DATE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1169149607265118)
,p_db_column_name=>'TCA_PROJECT_LOCATION'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'TCA Project Location'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1169554808265119)
,p_db_column_name=>'TCA_PROJECT_CATEGORY'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'TCA Project Category'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1169936732265119)
,p_db_column_name=>'TCA_PROJECT_ACTIVITY'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'TCA Project Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1170315815265120)
,p_db_column_name=>'TCA_STRATEGIC_PROJECTS'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'TCA Strategic Projects'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1170710554265120)
,p_db_column_name=>'TCA_PROGRAMS'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'TCA Programs'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1171149410265121)
,p_db_column_name=>'TCA_OUTPUT'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'TCA Output'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1171522397265122)
,p_db_column_name=>'TCA_SECTOR'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'TCA Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1171877875265122)
,p_db_column_name=>'TCA_DEPARTMENT'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'TCA Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1172351658265123)
,p_db_column_name=>'DCT_SECTOR_ID'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1187523989265150)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1172708086265123)
,p_db_column_name=>'DCT_DEPARTMENT_ID'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1187523989265150)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1173092632265124)
,p_db_column_name=>'DCT_SECTION_ID'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Section'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1187523989265150)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1173523565265125)
,p_db_column_name=>'DCT_UNIT_ID'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Unit'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1187523989265150)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1173943175265125)
,p_db_column_name=>'FIN_PROJECT_NAME'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Finance Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1174359546265126)
,p_db_column_name=>'SERVICE_PROVIDER'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Service Provider ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1174674793265126)
,p_db_column_name=>'DCT_MPR_ALLOWED'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'MPR Allowed ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1175166907265127)
,p_db_column_name=>'DCT_MPO_ALLOWED'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'MPO Allowed'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1175496371265128)
,p_db_column_name=>'DCT_PROJECT_RATE'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Project Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1175941765265129)
,p_db_column_name=>'OU_NAME'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'OU Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1176280016265129)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1176747431265130)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1177078960265130)
,p_db_column_name=>'FIN_PROJECT_CODE'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Finance Project Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1177556101265131)
,p_db_column_name=>'DIRECTOR_PERSON_ID'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Director'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1177957301265132)
,p_db_column_name=>'DIRECTOR_NAME'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1178310582265132)
,p_db_column_name=>'ED_PERSON_ID'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Executive Director'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1178740807265133)
,p_db_column_name=>'ED_NAME'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Ed Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1180625684265136)
,p_db_column_name=>'DCT_STATUS'
,p_display_order=>51
,p_column_identifier=>'AP'
,p_column_label=>'DCT Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(780300318120911)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1181047054265136)
,p_db_column_name=>'BUDGET'
,p_display_order=>61
,p_column_identifier=>'AQ'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1181464890265137)
,p_db_column_name=>'ACTUAL'
,p_display_order=>71
,p_column_identifier=>'AR'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1181831402265138)
,p_db_column_name=>'ENCUMBERANCE'
,p_display_order=>81
,p_column_identifier=>'AS'
,p_column_label=>'Encumberance'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1182250352265138)
,p_db_column_name=>'FUND_AVAILABLE'
,p_display_order=>91
,p_column_identifier=>'AT'
,p_column_label=>'Fund Available'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1182597937265139)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>101
,p_column_identifier=>'AU'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1183003577265139)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>111
,p_column_identifier=>'AV'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(95558025207878038)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1065397'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:DCT_SECTOR_ID:DCT_DEPARTMENT_ID:DIRECTOR_PERSON_ID:ED_PERSON_ID:BUDGET:ENCUMBERANCE:ACTUAL:FUND_AVAILABLE:'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(105021372464054286)
,p_report_id=>wwv_flow_api.id(95558025207878038)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'BUDGET'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>'"BUDGET" > to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1163274343265107)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(95540332221877466)
,p_button_name=>'Upload'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Upload'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.:::'
,p_button_condition=>':PERSON_ID = 680461'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-upload'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1164014930265108)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(96016955516811400)
,p_button_name=>'Update'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--noUI:t-Button--iconRight:t-Button--hoverIconPush:t-Button--padLeft'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Update All'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1164420767265108)
,p_name=>'P19_SHOW_ALL'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(96016955516811400)
,p_item_default=>'A'
,p_prompt=>'Show All'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_column=>10
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'A'
,p_attribute_03=>'Active'
,p_attribute_04=>'I'
,p_attribute_05=>'in-Active'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1184867683265145)
,p_name=>'Show All Status DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P19_SHOW_ALL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1185365799265145)
,p_event_id=>wwv_flow_api.id(1184867683265145)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(95540894305877467)
);
wwv_flow_api.component_end;
end;
/
