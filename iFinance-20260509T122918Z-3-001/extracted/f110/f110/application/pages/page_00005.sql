prompt --application/pages/page_00005
begin
--   Manifest
--     PAGE: 00005
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>110
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>5
,p_user_interface_id=>wwv_flow_api.id(13327188105480887)
,p_name=>'Notification - Approved Budget Publish Request'
,p_alias=>'NOTIFICATION-APPROVED-BUDGET-PUBLISH-REQUEST'
,p_step_title=>'Notification - Approved Budget Publish Request'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.a-IRR-header, .a-IRR-header.a-IRR-header--group {',
'    border-bottom-width: 0;',
'    background-color: #0D7574;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210113113023'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18933759883243912)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(13242565869480804)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18978253194545796)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(13251955757480809)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(13188546909480758)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(13306063834480855)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(37862262435295623)
,p_plug_name=>'Approved Budget By Projects'
,p_region_name=>'budget_ir'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(13240610854480803)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       CHAPTER,',
'       SECTOR,',
'       DEPARTMENT_NAME,',
'       PROJECT_NUMBER,',
'       PROJECT_NAME,',
'       DCT_PROJECT_NAME,',
'       COST_CENTER,',
'       TASK_NAME,',
'       ACCOUNT_NUMBER,',
'       BUDGET_YEAR,',
'       PROPOSED_SCENARIO,',
'       BUDGET_VERSION,',
'       APPROVED_AMOUNT,',
'       STATUS,',
'       START_DATE,',
'       END_DATE,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_ON,',
'       UPDATED_BY',
'      , (select round(sum(nvl(budget_2020,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P5_SCENARIO',
'          and proposed_budget.scenario_year = :P5_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_PROJECT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_PROJECT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_PROJECT.department_name',
'          and aderp_project_number = APPROVED_BUDGET_BY_PROJECT.project_number',
'          AND cost_center = APPROVED_BUDGET_BY_PROJECT.cost_center',
'          AND task_name = APPROVED_BUDGET_BY_PROJECT.task_name)  Budget_2020',
'    , (select round(sum(nvl(budget_2021,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P5_SCENARIO',
'          and proposed_budget.scenario_year = :P5_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_PROJECT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_PROJECT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_PROJECT.department_name',
'          and aderp_project_number = APPROVED_BUDGET_BY_PROJECT.project_number',
'          AND cost_center = APPROVED_BUDGET_BY_PROJECT.cost_center',
'          AND task_name = APPROVED_BUDGET_BY_PROJECT.task_name)  Budget_2021',
'    , (select round(sum(nvl(budget_2022,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P5_SCENARIO',
'          and proposed_budget.scenario_year = :P5_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_PROJECT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_PROJECT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_PROJECT.department_name',
'          and aderp_project_number = APPROVED_BUDGET_BY_PROJECT.project_number',
'          AND cost_center = APPROVED_BUDGET_BY_PROJECT.cost_center',
'          AND task_name = APPROVED_BUDGET_BY_PROJECT.task_name)  Budget_2022',
'   , (select round(sum(nvl(budget_2023,0)),2) ',
'           from proposed_budget',
'          where proposed_budget.scenario_name = :P5_SCENARIO',
'          and proposed_budget.scenario_year = :P5_BUDGET_YEAR',
'          and proposed_budget.sector = APPROVED_BUDGET_BY_PROJECT.SECTOR',
'          and proposed_budget.chapter  = APPROVED_BUDGET_BY_PROJECT.CHAPTER',
'          and proposed_budget.department_name = APPROVED_BUDGET_BY_PROJECT.department_name',
'          and aderp_project_number = APPROVED_BUDGET_BY_PROJECT.project_number',
'          AND cost_center = APPROVED_BUDGET_BY_PROJECT.cost_center',
'          AND task_name = APPROVED_BUDGET_BY_PROJECT.task_name)  Budget_2023       ',
'  from APPROVED_BUDGET_BY_PROJECT',
'   where 1 =1',
'-- and SECTOR = :P5_SECTOR',
'AND PROPOSED_SCENARIO = :P5_SCENARIO',
'AND BUDGET_VERSION = :P5_VERSION',
'AND BUDGET_YEAR = :P5_BUDGET_YEAR',
'--AND CHAPTER = :P5_CHAPTER',
'--AND DEPARTMENT_NAME = :P5_DEPARTMENT_NAME'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P5_SCENARIO,P5_VERSION,P5_BUDGET_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approved Budget By Projects - IR'
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
 p_id=>wwv_flow_api.id(37904334403179907)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>37904334403179907
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18990554716013582)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18990950892013583)
,p_db_column_name=>'CHAPTER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Chapter'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18991393574013583)
,p_db_column_name=>'SECTOR'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18991716999013584)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18992160440013584)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18992508240013585)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18992914690013585)
,p_db_column_name=>'DCT_PROJECT_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Dct Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18993371075013586)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18993712925013586)
,p_db_column_name=>'TASK_NAME'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Task Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18994190153013586)
,p_db_column_name=>'ACCOUNT_NUMBER'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Account Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18994576869013587)
,p_db_column_name=>'BUDGET_YEAR'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Budget Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18994903580013588)
,p_db_column_name=>'PROPOSED_SCENARIO'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Proposed Scenario'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18995328984013588)
,p_db_column_name=>'BUDGET_VERSION'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Budget Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18995789522013589)
,p_db_column_name=>'APPROVED_AMOUNT'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Approved Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18996177553013593)
,p_db_column_name=>'STATUS'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18996557597013594)
,p_db_column_name=>'START_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18996910730013594)
,p_db_column_name=>'END_DATE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18997334083013595)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18997762212013596)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18998177983013596)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18998587832013597)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18998984583013597)
,p_db_column_name=>'BUDGET_2020'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Proposal 2020'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18999367495013598)
,p_db_column_name=>'BUDGET_2021'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Proposal 2021'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18999790411013598)
,p_db_column_name=>'BUDGET_2022'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Proposal 2022'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(19000170696013598)
,p_db_column_name=>'BUDGET_2023'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Proposal 2023'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(37947371532258239)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'190005'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR:DEPARTMENT_NAME:PROJECT_NUMBER:PROJECT_NAME:COST_CENTER:TASK_NAME:ACCOUNT_NUMBER:APPROVED_AMOUNT:BUDGET_2021:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(18933453663243909)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(18978253194545796)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(13304710257480854)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_PREVIOUS'
,p_icon_css_classes=>'fa-check'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(18933591392243910)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(18978253194545796)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(13304710257480854)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_PREVIOUS'
,p_icon_css_classes=>'fa-times-square-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(18933690232243911)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(18978253194545796)
,p_button_name=>'Return'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(13304710257480854)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_PREVIOUS'
,p_icon_css_classes=>'fa-retweet'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18933805952243913)
,p_name=>'P5_ALLOCATED_AMOUNT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(18933759883243912)
,p_prompt=>'Allocated Amount'
,p_post_element_text=>'AED'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18934077927243915)
,p_name=>'P5_START_DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(18933759883243912)
,p_prompt=>'Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18934140921243916)
,p_name=>'P5_END_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(18933759883243912)
,p_prompt=>'End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18979400108551058)
,p_name=>'P5_BUDGET_YEAR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(18933759883243912)
,p_prompt=>'Budget Year'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18979759651553156)
,p_name=>'P5_VERSION'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(18933759883243912)
,p_prompt=>'Version'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18980087945554725)
,p_name=>'P5_SCENARIO'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(18933759883243912)
,p_prompt=>'Proposed Scenario'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(18934272450243917)
,p_computation_sequence=>10
,p_computation_item=>'P5_ALLOCATED_AMOUNT'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(approved_amount,''9,999,999,999,999.99'')approved_amount',
'from (',
'select budget_year , BUDGET_VERSION ,status , start_date , end_date , proposed_scenario , SUM(nvl(approved_amount,0)) approved_amount',
'from approved_budget',
'GROUP BY budget_year , BUDGET_VERSION ,status, start_date , end_date , proposed_scenario )',
'where budget_year = :P5_BUDGET_YEAR',
'and  BUDGET_VERSION = :P5_VERSION',
'and  proposed_scenario = :P5_SCENARIO'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(18934312961243918)
,p_computation_sequence=>20
,p_computation_item=>'P5_START_DATE'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(start_date, ''dd-MON-yyyy'') ',
'from (',
'select budget_year , BUDGET_VERSION ,status , start_date , end_date , proposed_scenario , SUM(nvl(approved_amount,0)) approved_amount',
'from approved_budget',
'GROUP BY budget_year , BUDGET_VERSION ,status, start_date , end_date , proposed_scenario )',
'where budget_year = :P5_BUDGET_YEAR',
'and  BUDGET_VERSION = :P5_VERSION',
'and  proposed_scenario = :P5_SCENARIO'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(18934481425243919)
,p_computation_sequence=>30
,p_computation_item=>'P5_END_DATE'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(end_date, ''dd-MON-yyyy'') ',
'from (',
'select budget_year , BUDGET_VERSION ,status , start_date , end_date , proposed_scenario , SUM(nvl(approved_amount,0)) approved_amount',
'from approved_budget',
'GROUP BY budget_year , BUDGET_VERSION ,status, start_date , end_date , proposed_scenario )',
'where budget_year = :P5_BUDGET_YEAR',
'and  BUDGET_VERSION = :P5_VERSION',
'and  proposed_scenario = :P5_SCENARIO'))
);
wwv_flow_api.component_end;
end;
/
