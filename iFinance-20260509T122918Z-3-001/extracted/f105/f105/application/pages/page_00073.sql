prompt --application/pages/page_00073
begin
--   Manifest
--     PAGE: 00073
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
 p_id=>73
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Projects Planners'
,p_alias=>'PROJECTS-PLANNERS'
,p_step_title=>'Projects Planners'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230213094128'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(63207735438019613)
,p_plug_name=>'Search'
,p_icon_css_classes=>'fa-search-minus'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(233418403153511592)
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
 p_id=>wwv_flow_api.id(233418981570511593)
,p_plug_name=>'Projects Planner'
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    budget_allocation_plan_id,',
'    budget_allocation_plan_id   budget_allocation_plan_id_h,',
'    project_number,',
'    task_number,',
'    expenditure_type,',
'    entity_code,',
'    cost_center,',
'    cost_center    cost_center_h,',
'    budget_groub_code,',
'    gl_account,',
'    activity,',
'    future1,',
'    future2,',
'    sector_id,',
'    sector_id    sector_id_h,',
'    scenario,',
'    scenario_desc,',
'    APPROVED_BUDGET,',
'    approved_budget_ch1,',
'    approved_budget_ch2,',
'    approved_budget_ch3,',
'    approved_budget_ch6,',
'    status,',
'    comments,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    submitted_on,',
'    submitted_by',
'FROM    budget_allocation_projects_plans',
'where project_number in (select distinct  budget_allocation_role_users.project_number  ',
'                        from BUDGET_ALLOCATION_ROLE_USERS',
'                        where PERSON_ID = :PERSON_ID',
'                        and status = ''A''',
'                        and sysdate between nvl(start_date , sysdate - 10)',
'                            and nvl(end_date , sysdate + 10))',
'and ( approved_budget_ch1 <> 0 or',
'      approved_budget_ch2 <> 0 or',
'      approved_budget_ch3 <> 0 or',
'      approved_budget_ch6 <> 0 )',
'and budget_allocation_plan_id = nvl(:P73_PLAN, budget_allocation_plan_id)      ',
'and project_number = nvl(:P73_PROJECT_NUMBER, project_number)',
'and task_number = nvl(:P73_TASK, task_number)',
'order by project_number,',
'    task_number,',
'    expenditure_type;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P73_PLAN,P73_PROJECT_NUMBER,P73_TASK'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Sector Planners'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(233419136521511593)
,p_name=>'Sector Planners'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>446703168910696225
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63636075524251634)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63635725816251633)
,p_db_column_name=>'BUDGET_ALLOCATION_PLAN_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Budget Allocation Plan'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(70889094180742864)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63635249339251633)
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
 p_id=>wwv_flow_api.id(63634845281251633)
,p_db_column_name=>'APPROVED_BUDGET_CH1'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Approved Budget Ch1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63634529296251633)
,p_db_column_name=>'APPROVED_BUDGET_CH2'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Approved Budget Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63634046535251633)
,p_db_column_name=>'APPROVED_BUDGET_CH3'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Approved Budget Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63633719552251632)
,p_db_column_name=>'APPROVED_BUDGET_CH6'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Approved Budget Ch6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63633269639251632)
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
 p_id=>wwv_flow_api.id(63632882367251632)
,p_db_column_name=>'COMMENTS'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63632444784251632)
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
 p_id=>wwv_flow_api.id(63632097601251632)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63631728672251631)
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
 p_id=>wwv_flow_api.id(63631288597251631)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63630896201251631)
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
 p_id=>wwv_flow_api.id(63630466800251631)
,p_db_column_name=>'SCENARIO_DESC'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Scenario Desc'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63637672726251634)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>25
,p_column_identifier=>'R'
,p_column_label=>'Department / Cost Center'
,p_column_link=>'f?p=&APP_ID.:67:&SESSION.::&DEBUG.:67:P67_PLAN_ID,P67_SECTOR_ID,P67_COST_CENTER,P67_STATUS:#BUDGET_ALLOCATION_PLAN_ID_H#,#SECTOR_ID_H#,#COST_CENTER_H#,#STATUS#'
,p_column_linktext=>'#COST_CENTER#'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(71087570950221411)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63637303781251634)
,p_db_column_name=>'BUDGET_ALLOCATION_PLAN_ID_H'
,p_display_order=>35
,p_column_identifier=>'S'
,p_column_label=>'Budget Allocation Plan Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63694340176492930)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>45
,p_column_identifier=>'V'
,p_column_label=>'Project Number'
,p_column_link=>'f?p=&APP_ID.:74:&SESSION.::&DEBUG.:74:P74_PLAN_ID,P74_SECTOR_ID,P74_COST_CENTER,P74_PROJECT,P74_SCENARIO,P74_STATUS:#BUDGET_ALLOCATION_PLAN_ID_H#,#SECTOR_ID_H#,#COST_CENTER_H#,P74_PROJECT,P74_SCENARIO,#STATUS#'
,p_column_linktext=>'#PROJECT_NUMBER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63694275994492929)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>55
,p_column_identifier=>'W'
,p_column_label=>'Task Number'
,p_column_link=>'f?p=&APP_ID.:74:&SESSION.::&DEBUG.:74:P74_PLAN_ID,P74_SECTOR_ID,P74_COST_CENTER,P74_PROJECT,P74_SCENARIO,P74_STATUS:#BUDGET_ALLOCATION_PLAN_ID_H#,#SECTOR_ID_H#,#COST_CENTER_H#,#PROJECT_NUMBER#,#SCENARIO#,#STATUS#'
,p_column_linktext=>'#TASK_NUMBER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63694148101492928)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>65
,p_column_identifier=>'X'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63694057116492927)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>75
,p_column_identifier=>'Y'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63693997620492926)
,p_db_column_name=>'BUDGET_GROUB_CODE'
,p_display_order=>85
,p_column_identifier=>'Z'
,p_column_label=>'Budget Groub Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63693839531492925)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>95
,p_column_identifier=>'AA'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63693814378492924)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>105
,p_column_identifier=>'AB'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63693708245492923)
,p_db_column_name=>'FUTURE1'
,p_display_order=>115
,p_column_identifier=>'AC'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63693544925492922)
,p_db_column_name=>'FUTURE2'
,p_display_order=>125
,p_column_identifier=>'AD'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63693464808492921)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>135
,p_column_identifier=>'AE'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63693431532492920)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>145
,p_column_identifier=>'AF'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63693142020492918)
,p_db_column_name=>'COST_CENTER_H'
,p_display_order=>155
,p_column_identifier=>'AG'
,p_column_label=>'Cost Center H'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63693101168492917)
,p_db_column_name=>'SECTOR_ID_H'
,p_display_order=>165
,p_column_identifier=>'AH'
,p_column_label=>'Sector Id H'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(63205726791019592)
,p_db_column_name=>'APPROVED_BUDGET'
,p_display_order=>175
,p_column_identifier=>'AI'
,p_column_label=>'Approved Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(233428736083522222)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1496539'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'BUDGET_ALLOCATION_PLAN_ID:SCENARIO:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:GL_ACCOUNT:APPROVED_BUDGET:APXWS_CC_001:STATUS:'
,p_sum_columns_on_break=>'APPROVED_BUDGET_CH2:APPROVED_BUDGET_CH3:APPROVED_BUDGET_CH1:APPROVED_BUDGET_CH6:APXWS_CC_001'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(62902130597227782)
,p_report_id=>wwv_flow_api.id(233428736083522222)
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
 p_id=>wwv_flow_api.id(62901658732227782)
,p_report_id=>wwv_flow_api.id(233428736083522222)
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
 p_id=>wwv_flow_api.id(62901233982227782)
,p_report_id=>wwv_flow_api.id(233428736083522222)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'D + E + F + G'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total'
,p_report_label=>'Total'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(63207419972019609)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(63207735438019613)
,p_button_name=>'Clear'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Clear'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(63207495910019610)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(63207735438019613)
,p_button_name=>'Go'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Go'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-search'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(63206217957019597)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(233418981570511593)
,p_button_name=>'CASHFLOW'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--noUI:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Cashflow'
,p_button_position=>'REGION_TEMPLATE_EDIT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63207619805019611)
,p_name=>'P73_PROJECT_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(63207735438019613)
,p_prompt=>'Project Number'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT distinct',
'    project_number d,',
'    project_number r',
'FROM    budget_allocation_projects_plans',
'where project_number in (select distinct  budget_allocation_role_users.project_number  ',
'                        from BUDGET_ALLOCATION_ROLE_USERS',
'                        where PERSON_ID = :PERSON_ID',
'                        and status = ''A''',
'                        and sysdate between nvl(start_date , sysdate - 10)',
'                            and nvl(end_date , sysdate + 10))',
'and ( approved_budget_ch1 <> 0 or',
'      approved_budget_ch2 <> 0 or',
'      approved_budget_ch3 <> 0 or',
'      approved_budget_ch6 <> 0 );'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63207326824019608)
,p_name=>'P73_PLAN'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(63207735438019613)
,p_prompt=>'Allocation Plan'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select p.plan_name , p.plan_id',
'from budget_allocation_plans p',
'where plan_id in (SELECT distinct budget_allocation_plan_id ',
'                    FROM    budget_allocation_projects_plans',
'                    where project_number in (select distinct  budget_allocation_role_users.project_number  ',
'                                                from BUDGET_ALLOCATION_ROLE_USERS',
'                                                where PERSON_ID = :PERSON_ID',
'                                                and status = ''A''',
'                                                and sysdate between nvl(start_date , sysdate - 10)',
'                                                    and nvl(end_date , sysdate + 10))',
'                        and ( approved_budget_ch1 <> 0 or',
'                              approved_budget_ch2 <> 0 or',
'                              approved_budget_ch3 <> 0 or',
'                              approved_budget_ch6 <> 0 ))'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63207214811019607)
,p_name=>'P73_TASK'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(63207735438019613)
,p_prompt=>'Task'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT distinct',
'    TASK_number D,',
'    task_number R',
'FROM    budget_allocation_projects_plans',
'where project_number in (select distinct  budget_allocation_role_users.project_number  ',
'                        from BUDGET_ALLOCATION_ROLE_USERS',
'                        where PERSON_ID = :PERSON_ID',
'                        and status = ''A''',
'                        and sysdate between nvl(start_date , sysdate - 10)',
'                            and nvl(end_date , sysdate + 10))',
'and ( approved_budget_ch1 <> 0 or',
'      approved_budget_ch2 <> 0 or',
'      approved_budget_ch3 <> 0 or',
'      approved_budget_ch6 <> 0 );'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(63206109676019596)
,p_name=>'P73_GENERATE_CASHFLOW_YN'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(233418403153511592)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63207064826019606)
,p_name=>'Go DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(63207495910019610)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63206965027019605)
,p_event_id=>wwv_flow_api.id(63207064826019606)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(233418981570511593)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(63206914736019604)
,p_name=>'Clear DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(63207419972019609)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63206780946019603)
,p_event_id=>wwv_flow_api.id(63206914736019604)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P73_PLAN,P73_PROJECT_NUMBER,P73_TASK'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(63206704184019602)
,p_event_id=>wwv_flow_api.id(63206914736019604)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(233418981570511593)
);
wwv_flow_api.component_end;
end;
/
