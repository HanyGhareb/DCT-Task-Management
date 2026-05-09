prompt --application/pages/page_00063
begin
--   Manifest
--     PAGE: 00063
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
 p_id=>63
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Sector Planners'
,p_alias=>'SECTOR-PLANNERS'
,p_step_title=>'Sector Planners'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240118134333'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(64834888401013120)
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
 p_id=>wwv_flow_api.id(64834309984013119)
,p_plug_name=>'Sector Planners'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select id,',
'    budget_allocation_plan_id,',
'    budget_allocation_plan_id    budget_allocation_plan_id_h,',
'    sector_id,',
'    sector_id    sector_id_h,',
'    ',
'    -- Approved',
'    approved_budget_ch1,',
'    approved_budget_ch2,',
'    approved_budget_ch3,',
'    approved_budget_ch6,',
'    ',
'    -- Allocation',
'    allocated_budget_ch1,',
'    allocated_budget_ch2,',
'    allocated_budget_ch3,',
'    allocated_budget_ch6,',
'    ',
'    -- % Achivement ',
'    round(allocated_budget_ch1 / decode(approved_budget_ch1,0,1, approved_budget_ch1) , 1)  * 100            pct_allocation_ch1,',
'    round(allocated_budget_ch2 / decode(approved_budget_ch2,0,1, approved_budget_ch2) , 1)  * 100            pct_allocation_ch2,',
'    round(allocated_budget_ch3 / decode(approved_budget_ch3,0,1, approved_budget_ch3) , 1)  * 100            pct_allocation_ch3,',
'    round(allocated_budget_ch6 / decode(approved_budget_ch6,0,1, approved_budget_ch6) , 1)  * 100            pct_allocation_ch6,',
'    ',
'    --  Achivement ',
'    round(allocated_budget_ch1 / decode(approved_budget_ch1,0,1, approved_budget_ch1) , 1)  * 100            pctno_allocation_ch1,',
'    round(allocated_budget_ch2 / decode(approved_budget_ch2,0,1, approved_budget_ch2) , 1)  * 100            pctno_allocation_ch2,',
'    round(allocated_budget_ch3 / decode(approved_budget_ch3,0,1, approved_budget_ch3) , 1)  * 100            pctno_allocation_ch3,',
'    round(allocated_budget_ch6 / decode(approved_budget_ch6,0,1, approved_budget_ch6) , 1)  * 100            pctno_allocation_ch6,',
'    ',
'        -- GET LIVE DETAILS',
'    PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 133 ,budget_year , ''B'' )                              Current_budget_ch1',
'   ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 133 ,budget_year , ''E'' )                              Current_Encumberance_ch1',
'   ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 133 ,budget_year , ''A'' )                              Current_actual_ch1',
'   ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 133 ,budget_year , ''F'' )                              Current_fund_ch1',
'   ',
'   ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 134 ,budget_year , ''B'' )                              Current_budget_ch2',
'   ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 134 ,budget_year , ''E'' )                              Current_Encumberance_ch2',
'   ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 134 ,budget_year , ''A'' )                              Current_actual_ch2',
'   ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 134 ,budget_year , ''F'' )                              Current_fund_ch2',
'   ',
'   ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 135 ,budget_year , ''B'' )                              Current_budget_ch3',
'   ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 135 ,budget_year , ''E'' )                              Current_Encumberance_ch3',
'   ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 135 ,budget_year , ''A'' )                              Current_actual_ch3',
'   ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 135 ,budget_year , ''F'' )                              Current_fund_ch3',
'   ',
'   ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 136 ,budget_year , ''B'' )                              Current_budget_ch6',
'   ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 136 ,budget_year , ''E'' )                              Current_Encumberance_ch6',
'   ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 136 ,budget_year , ''A'' )                              Current_actual_ch6',
'   ,PROJECTS_UTIL.SECTOR_BALANCE(sector_id , 136 ,budget_year , ''F'' )                              Current_fund_ch6',
'    ',
'    ,status,',
'    comments,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    scenario,',
'    scenario_desc',
'From (',
'    SELECT',
'            id,',
'            budget_allocation_plan_id,',
'            sector_id,',
'            nvl(approved_budget_ch1,0)    approved_budget_ch1,',
'            nvl(approved_budget_ch2,0)    approved_budget_ch2,',
'            nvl(approved_budget_ch3,0)    approved_budget_ch3,',
'            nvl(approved_budget_ch6,0)    approved_budget_ch6,',
'        -- Allocation',
'    budget_allocation_pkg.get_allocated_budget_by_sec_ch(budget_allocation_plan_id, 1, sector_id)         allocated_budget_ch1,',
'    budget_allocation_pkg.get_allocated_budget_by_sec_ch(budget_allocation_plan_id, 2, sector_id)         allocated_budget_ch2,',
'    budget_allocation_pkg.get_allocated_budget_by_sec_ch(budget_allocation_plan_id, 3, sector_id)         allocated_budget_ch3,',
'    budget_allocation_pkg.get_allocated_budget_by_sec_ch(budget_allocation_plan_id, 6, sector_id)         allocated_budget_ch6,',
'            status,',
'            comments,',
'            created_by,',
'            created_on,',
'            updated_by,',
'            updated_on,',
'            scenario,',
'            scenario_desc,',
'            adding_cost_center_yn,',
'            adding_project_yn,',
'            adding_task_yn,',
'            budget_allocation_pkg.get_plan_year(budget_allocation_plan_id) budget_year',
'        FROM',
'            budget_allocation_sectors_plans',
'        )',
'where SECTOR_ID in (select SECTOR_ID ',
'                        from BUDGET_ALLOCATION_ROLE_USERS',
'                        where PERSON_ID = :PERSON_ID',
'                        and status = ''A''',
'                        and sysdate between nvl(start_date , sysdate - 10)',
'                            and nvl(end_date , sysdate + 10))',
'order by id',
'--and status != ''Draft''',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Sector Planners'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(64834155033013119)
,p_name=>'Sector Planners'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No Allocation Plans available.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>148449877356171513
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64833755877013115)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64833361668013115)
,p_db_column_name=>'BUDGET_ALLOCATION_PLAN_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Budget Allocation Plan'
,p_column_link=>'f?p=&APP_ID.:64:&SESSION.::&DEBUG.:64:P64_PLAN_ID,P64_SECTOR_ID,P64_STATUS,P64_SECTOR:#BUDGET_ALLOCATION_PLAN_ID_H#,#SECTOR_ID_H#,#STATUS#,#SECTOR_ID#'
,p_column_linktext=>'#BUDGET_ALLOCATION_PLAN_ID#'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(70889094180742864)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64833004236013115)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1187523989265150)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64832544376013114)
,p_db_column_name=>'APPROVED_BUDGET_CH1'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Approved Budget Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64832230161013114)
,p_db_column_name=>'APPROVED_BUDGET_CH2'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Approved Budget Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64831776785013114)
,p_db_column_name=>'APPROVED_BUDGET_CH3'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Approved Budget Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64831408966013114)
,p_db_column_name=>'APPROVED_BUDGET_CH6'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Approved Budget Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64830943902013114)
,p_db_column_name=>'STATUS'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(780300318120911)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64830616072013113)
,p_db_column_name=>'COMMENTS'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64830205544013107)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64829858265013107)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64829519233013106)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64829035339013106)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64828653572013106)
,p_db_column_name=>'SCENARIO'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Scenario'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(70830542814082706)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(64828274158013106)
,p_db_column_name=>'SCENARIO_DESC'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Scenario Desc'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(65410016066155384)
,p_db_column_name=>'BUDGET_ALLOCATION_PLAN_ID_H'
,p_display_order=>25
,p_column_identifier=>'P'
,p_column_label=>'Budget Allocation Plan Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(65409918879155383)
,p_db_column_name=>'SECTOR_ID_H'
,p_display_order=>35
,p_column_identifier=>'Q'
,p_column_label=>'Sector Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61370089654166009)
,p_db_column_name=>'ALLOCATED_BUDGET_CH1'
,p_display_order=>45
,p_column_identifier=>'R'
,p_column_label=>'Allocated Budget Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61369990118166008)
,p_db_column_name=>'ALLOCATED_BUDGET_CH2'
,p_display_order=>55
,p_column_identifier=>'S'
,p_column_label=>'Allocated Budget Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61369846818166007)
,p_db_column_name=>'ALLOCATED_BUDGET_CH3'
,p_display_order=>65
,p_column_identifier=>'T'
,p_column_label=>'Allocated Budget Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61369788069166006)
,p_db_column_name=>'ALLOCATED_BUDGET_CH6'
,p_display_order=>75
,p_column_identifier=>'U'
,p_column_label=>'Allocated Budget Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61369697714166005)
,p_db_column_name=>'CURRENT_BUDGET_CH1'
,p_display_order=>85
,p_column_identifier=>'V'
,p_column_label=>'Current Budget Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61369558245166004)
,p_db_column_name=>'CURRENT_ENCUMBERANCE_CH1'
,p_display_order=>95
,p_column_identifier=>'W'
,p_column_label=>'Current Encumberance Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61369478303166003)
,p_db_column_name=>'CURRENT_ACTUAL_CH1'
,p_display_order=>105
,p_column_identifier=>'X'
,p_column_label=>'Current Actual Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61369377549166002)
,p_db_column_name=>'CURRENT_FUND_CH1'
,p_display_order=>115
,p_column_identifier=>'Y'
,p_column_label=>'Current Fund Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61369287013166001)
,p_db_column_name=>'CURRENT_BUDGET_CH2'
,p_display_order=>125
,p_column_identifier=>'Z'
,p_column_label=>'Current Budget Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61369141150166000)
,p_db_column_name=>'CURRENT_ENCUMBERANCE_CH2'
,p_display_order=>135
,p_column_identifier=>'AA'
,p_column_label=>'Current Encumberance Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61369070969165999)
,p_db_column_name=>'CURRENT_ACTUAL_CH2'
,p_display_order=>145
,p_column_identifier=>'AB'
,p_column_label=>'Current Actual Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61368971998165998)
,p_db_column_name=>'CURRENT_FUND_CH2'
,p_display_order=>155
,p_column_identifier=>'AC'
,p_column_label=>'Current Fund Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61368928438165997)
,p_db_column_name=>'CURRENT_BUDGET_CH3'
,p_display_order=>165
,p_column_identifier=>'AD'
,p_column_label=>'Current Budget Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61368734167165996)
,p_db_column_name=>'CURRENT_ENCUMBERANCE_CH3'
,p_display_order=>175
,p_column_identifier=>'AE'
,p_column_label=>'Current Encumberance Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61368685024165995)
,p_db_column_name=>'CURRENT_ACTUAL_CH3'
,p_display_order=>185
,p_column_identifier=>'AF'
,p_column_label=>'Current Actual Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61368593262165994)
,p_db_column_name=>'CURRENT_FUND_CH3'
,p_display_order=>195
,p_column_identifier=>'AG'
,p_column_label=>'Current Fund Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61368449737165993)
,p_db_column_name=>'CURRENT_BUDGET_CH6'
,p_display_order=>205
,p_column_identifier=>'AH'
,p_column_label=>'Current Budget Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61368362388165992)
,p_db_column_name=>'CURRENT_ENCUMBERANCE_CH6'
,p_display_order=>215
,p_column_identifier=>'AI'
,p_column_label=>'Current Encumberance Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61368330240165991)
,p_db_column_name=>'CURRENT_ACTUAL_CH6'
,p_display_order=>225
,p_column_identifier=>'AJ'
,p_column_label=>'Current Actual Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61368178680165990)
,p_db_column_name=>'CURRENT_FUND_CH6'
,p_display_order=>235
,p_column_identifier=>'AK'
,p_column_label=>'Current Fund Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61368054031165989)
,p_db_column_name=>'PCT_ALLOCATION_CH1'
,p_display_order=>245
,p_column_identifier=>'AL'
,p_column_label=>'Ch1 Allocation Progress '
,p_column_type=>'NUMBER'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_format_mask=>'PCT_GRAPH:#A5EDDF:#1A7024:5'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61367974339165988)
,p_db_column_name=>'PCT_ALLOCATION_CH2'
,p_display_order=>255
,p_column_identifier=>'AM'
,p_column_label=>'Ch2 Allocation Progress'
,p_column_type=>'NUMBER'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_format_mask=>'PCT_GRAPH:#20D92D:#1A7024:'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61367864631165987)
,p_db_column_name=>'PCT_ALLOCATION_CH3'
,p_display_order=>265
,p_column_identifier=>'AN'
,p_column_label=>'Ch3 Allocation Progress'
,p_column_type=>'NUMBER'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_format_mask=>'PCT_GRAPH:#F0AAB7:#F2051C:'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61367748440165986)
,p_db_column_name=>'PCT_ALLOCATION_CH6'
,p_display_order=>275
,p_column_identifier=>'AO'
,p_column_label=>'Ch6 Allocation Progress'
,p_column_type=>'NUMBER'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_format_mask=>'PCT_GRAPH:#A5EDDF:#1A7024:'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61367703250165985)
,p_db_column_name=>'PCTNO_ALLOCATION_CH1'
,p_display_order=>285
,p_column_identifier=>'AP'
,p_column_label=>'Allocation Ch1 %'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61367605893165984)
,p_db_column_name=>'PCTNO_ALLOCATION_CH2'
,p_display_order=>295
,p_column_identifier=>'AQ'
,p_column_label=>'Allocation Ch2  Progress'
,p_column_html_expression=>'#PCTNO_ALLOCATION_CH2#% #PCT_ALLOCATION_CH2#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61367458736165983)
,p_db_column_name=>'PCTNO_ALLOCATION_CH3'
,p_display_order=>305
,p_column_identifier=>'AR'
,p_column_label=>'Allocation Ch3 Progress'
,p_column_html_expression=>'#PCTNO_ALLOCATION_CH3#% #PCT_ALLOCATION_CH3#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61367425037165982)
,p_db_column_name=>'PCTNO_ALLOCATION_CH6'
,p_display_order=>315
,p_column_identifier=>'AS'
,p_column_label=>'Allocation Ch6 %'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(64824555471002490)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1484595'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'BUDGET_ALLOCATION_PLAN_ID:SECTOR_ID:APPROVED_BUDGET_CH2:ALLOCATED_BUDGET_CH2:PCTNO_ALLOCATION_CH2:APPROVED_BUDGET_CH3:ALLOCATED_BUDGET_CH3:PCTNO_ALLOCATION_CH3:APXWS_CC_001:SCENARIO:STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(49146399873997206)
,p_report_id=>wwv_flow_api.id(64824555471002490)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APXWS_CC_001'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ((#APXWS_CC_EXPR#) is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(49146017842997205)
,p_report_id=>wwv_flow_api.id(64824555471002490)
,p_name=>'Active'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Active'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Active''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#D0F1CC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(49145574305997204)
,p_report_id=>wwv_flow_api.id(64824555471002490)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'D + E + F + G'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total'
,p_report_label=>'Total'
);
wwv_flow_api.component_end;
end;
/
