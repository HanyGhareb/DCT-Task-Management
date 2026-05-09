prompt --application/pages/page_00084
begin
--   Manifest
--     PAGE: 00084
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
 p_id=>84
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Proposal Plans'
,p_alias=>'BUDGET-PROPOSAL-PLANS'
,p_step_title=>'Budget Proposal Plans'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230508103849'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(54293588900658905)
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
 p_id=>wwv_flow_api.id(54292966436658904)
,p_plug_name=>'Budget Proposal Plans'
,p_icon_css_classes=>'fa-line-chart'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    plan_id,',
'    plan_name,',
'    proposal_year,',
'    plan_duration,',
'    plan_version,',
'    status,',
'    submitted_by,',
'    submitted_on,',
'    final_approved_by,',
'    final_approved_on,',
'    cancelled_by,',
'    cancelled_on,',
'    cancel_reason,',
'    plan_ch1_yn,',
'    ceiling_ch1_required_yn,',
'    ceiling_ch1_amount,',
'    plan_ch2_yn,',
'    ceiling_ch2_required_yn,',
'    ceiling_ch2_amount,',
'    plan_ch3_yn,',
'    ceiling_ch3_required_yn,',
'    ceiling_ch3_amount,',
'    plan_ch6_yn,',
'    ceiling_ch6_required_yn,',
'    ceiling_ch6_amount,',
'    plan_revenue_yn,',
'    future2_used,',
'    allow_add_cost_center_yn,',
'    allow_add_project_yn,',
'    allow_add_task_yn,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    copy_from_plan_id,',
'    plan_type,',
'    ceiling_ch2,',
'    ceiling_ch3,',
'    allcoated_ch2,',
'    allocated_ch3,',
'    (round((allcoated_ch2 / decode(ceiling_ch2,0,1,ceiling_ch2)) * 100)) ch2_pct,',
'    (round((allocated_ch3 / decode(ceiling_ch3,0,1,ceiling_ch3)) * 100)) ch3_pct,',
'    (round((allcoated_ch2 / decode(ceiling_ch2,0,1,ceiling_ch2)) * 100)) ch2_pct_H,',
'    (round((allocated_ch3 / decode(ceiling_ch3,0,1,ceiling_ch3)) * 100)) ch3_pct_H',
'FROM',
'    (',
'        SELECT',
'            plan_id,',
'            plan_name,',
'            proposal_year,',
'            plan_duration,',
'            plan_version,',
'            status,',
'            submitted_by,',
'            submitted_on,',
'            final_approved_by,',
'            final_approved_on,',
'            cancelled_by,',
'            cancelled_on,',
'            cancel_reason,',
'            plan_ch1_yn,',
'            ceiling_ch1_required_yn,',
'            ceiling_ch1_amount,',
'            plan_ch2_yn,',
'            ceiling_ch2_required_yn,',
'            ceiling_ch2_amount,',
'            plan_ch3_yn,',
'            ceiling_ch3_required_yn,',
'            ceiling_ch3_amount,',
'            plan_ch6_yn,',
'            ceiling_ch6_required_yn,',
'            ceiling_ch6_amount,',
'            plan_revenue_yn,',
'            future2_used,',
'            allow_add_cost_center_yn,',
'            allow_add_project_yn,',
'            allow_add_task_yn,',
'            created_by,',
'            created_on,',
'            updated_by,',
'            updated_on,',
'            copy_from_plan_id,',
'            plan_type,',
'            budget_proposal_pkg.plan_chapter_celing(plan_id, 134)    ceiling_ch2,',
'            budget_proposal_pkg.plan_chapter_celing(plan_id, 135)    ceiling_ch3,',
'            budget_proposal_pkg.plan_chapter_allocated(plan_id, 134) allcoated_ch2,',
'            budget_proposal_pkg.plan_chapter_allocated(plan_id, 135) allocated_ch3',
'        FROM',
'            budget_proposal_plans',
'    );'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Budget Proposal Plans'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(54292877406658904)
,p_name=>'Budget Proposal Plans'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>158991154982525728
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54292527542658903)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Plan ID'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54292079721658903)
,p_db_column_name=>'PLAN_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Plan Name'
,p_column_link=>'f?p=&APP_ID.:85:&SESSION.::&DEBUG.::P85_PLAN_ID:#PLAN_ID#'
,p_column_linktext=>'#PLAN_NAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54291649344658903)
,p_db_column_name=>'PROPOSAL_YEAR'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Proposal Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54291307000658902)
,p_db_column_name=>'PLAN_DURATION'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Plan Duration'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54290856560658902)
,p_db_column_name=>'PLAN_VERSION'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54290444931658902)
,p_db_column_name=>'STATUS'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54290063237658902)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54289685087658902)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54289307237658901)
,p_db_column_name=>'FINAL_APPROVED_BY'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Final Approved By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54288880027658901)
,p_db_column_name=>'FINAL_APPROVED_ON'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Final Approved On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54288432869658901)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54288112994658901)
,p_db_column_name=>'CANCELLED_ON'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Cancelled On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54287729150658901)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54287242151658901)
,p_db_column_name=>'PLAN_CH1_YN'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Plan Ch1 ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54286898320658900)
,p_db_column_name=>'CEILING_CH1_REQUIRED_YN'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Ceiling Ch1 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54286469351658900)
,p_db_column_name=>'CEILING_CH1_AMOUNT'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Ceiling Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54286044474658900)
,p_db_column_name=>'PLAN_CH2_YN'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Plan Ch2 ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54285713875658900)
,p_db_column_name=>'CEILING_CH2_REQUIRED_YN'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Ceiling Ch2 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54285254594658900)
,p_db_column_name=>'CEILING_CH2_AMOUNT'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Ceiling Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54284848410658900)
,p_db_column_name=>'PLAN_CH3_YN'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Plan Ch3 ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54284442033658899)
,p_db_column_name=>'CEILING_CH3_REQUIRED_YN'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Ceiling Ch3 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54284071726658899)
,p_db_column_name=>'CEILING_CH3_AMOUNT'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Ceiling Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54283702593658899)
,p_db_column_name=>'PLAN_CH6_YN'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Plan Ch6 ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54283291941658899)
,p_db_column_name=>'CEILING_CH6_REQUIRED_YN'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Ceiling Ch6 Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54282928775658899)
,p_db_column_name=>'CEILING_CH6_AMOUNT'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Ceiling Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54282528396658898)
,p_db_column_name=>'PLAN_REVENUE_YN'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Plan Revenue ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54282112725658898)
,p_db_column_name=>'FUTURE2_USED'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Future2 Used'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54281680199658898)
,p_db_column_name=>'ALLOW_ADD_COST_CENTER_YN'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Allow Add Cost Center ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54281241444658898)
,p_db_column_name=>'ALLOW_ADD_PROJECT_YN'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Allow Add Project ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54280869507658898)
,p_db_column_name=>'ALLOW_ADD_TASK_YN'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Allow Add Task ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54280479581658898)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54280087805658897)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54279665989658897)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54279289346658897)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54278843533658897)
,p_db_column_name=>'COPY_FROM_PLAN_ID'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Copy From Plan'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(50731049428315211)
,p_db_column_name=>'PLAN_TYPE'
,p_display_order=>45
,p_column_identifier=>'AJ'
,p_column_label=>'Plan Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(50661192721222067)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53929045251650288)
,p_db_column_name=>'CEILING_CH2'
,p_display_order=>55
,p_column_identifier=>'AK'
,p_column_label=>'Opex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53929009609650287)
,p_db_column_name=>'CEILING_CH3'
,p_display_order=>65
,p_column_identifier=>'AL'
,p_column_label=>'Capex Ceiling'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53928865774650286)
,p_db_column_name=>'ALLCOATED_CH2'
,p_display_order=>75
,p_column_identifier=>'AM'
,p_column_label=>'Opex Allcoated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53928743693650285)
,p_db_column_name=>'ALLOCATED_CH3'
,p_display_order=>85
,p_column_identifier=>'AN'
,p_column_label=>'Capex Allocated'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53928640342650284)
,p_db_column_name=>'CH2_PCT'
,p_display_order=>95
,p_column_identifier=>'AO'
,p_column_label=>'Ch2 Pct'
,p_column_type=>'NUMBER'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_format_mask=>'PCT_GRAPH:#20D92D:#1A7024:'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53928620810650283)
,p_db_column_name=>'CH3_PCT'
,p_display_order=>105
,p_column_identifier=>'AP'
,p_column_label=>'Ch3 Pct'
,p_column_type=>'NUMBER'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_format_mask=>'PCT_GRAPH:#F08BF0:#A31822:'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53928446592650282)
,p_db_column_name=>'CH2_PCT_H'
,p_display_order=>115
,p_column_identifier=>'AQ'
,p_column_label=>'Opex Progress'
,p_column_html_expression=>'#CH2_PCT_H#% #CH2_PCT#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47244402688850631)
,p_db_column_name=>'CH3_PCT_H'
,p_display_order=>125
,p_column_identifier=>'AR'
,p_column_label=>'Capex Progress'
,p_column_html_expression=>'#CH3_PCT_H#% #CH3_PCT#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(54268150347650544)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1590159'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PLAN_NAME:PROPOSAL_YEAR:PLAN_TYPE:CEILING_CH2:ALLCOATED_CH2:CH2_PCT_H:CEILING_CH3:ALLOCATED_CH3:CH3_PCT_H:UPDATED_BY:UPDATED_ON:STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(46957093471187389)
,p_report_id=>wwv_flow_api.id(54268150347650544)
,p_name=>'In-Progress'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(54314336322782527)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(54293588900658905)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'New Proposal Plan'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:85:&SESSION.::&DEBUG.:85::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
