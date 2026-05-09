prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>11
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'DP Item Details'
,p_alias=>'DP-ITEM-DETAILS'
,p_step_title=>'Demand Planning Item Details'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#WORKSPACE_IMAGES#main.css'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Form-label {',
'    	color: #368ed2;',
'	font-weight: bold;',
'	font-size:12px;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240229083750'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(299639472957655600)
,p_plug_name=>'Info'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--info:t-Alert--removeHeading:t-Form--slimPadding'
,p_plug_template=>wwv_flow_api.id(127772628480449819)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p>In Accordance to Supply Management Department''s SLA the project will require <span style="color: #0000ff;"><strong>&P11_SLA_DAYS. days</strong></span> to be delivered, please make sure to add project cashflow and submit for review as soon as possi'
||'ble.</p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P11_SLA_DAYS is not null'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(87418383085717)
,p_plug_name=>'Participants'
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>60
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(87280307085716)
,p_plug_name=>'Participants Report'
,p_parent_plug_id=>wwv_flow_api.id(87418383085717)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'DP_ITEM_PARTICIPANTS'
,p_query_where=>wwv_flow_string.join(wwv_flow_t_varchar2(
'item_id = :P11_ITEM_ID',
'or item_id = :P11_ITEM_ID_H'))
,p_query_order_by=>'ID'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P11_ITEM_ID,P11_ITEM_ID_H'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Participants Report'
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
 p_id=>wwv_flow_api.id(87260724085715)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_detail_link=>'f?p=&APP_ID.:59:&SESSION.::&DEBUG.::P59_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>144114908249970249
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(87121909085714)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(675641828236337)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(675774210236338)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(675845032236339)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(702510545341241)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(676000966236340)
,p_db_column_name=>'STATUS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128342850308489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(676039584236341)
,p_db_column_name=>'START_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(676181139236342)
,p_db_column_name=>'END_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(676267004236343)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(676416918236344)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(676443557236345)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(676534786236346)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(677726568236357)
,p_db_column_name=>'NOTES'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(687065267254662)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1448893'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PERSON_ID:ROLE_ID:STATUS:START_DATE:END_DATE:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(766016643241246)
,p_report_id=>wwv_flow_api.id(687065267254662)
,p_name=>'Owner'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Active'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Active''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D0F1CC'
,p_row_font_color=>'#000000'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8893206578220169)
,p_plug_name=>'Cashflow Details'
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>70
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'from cashflow_lines',
'where SOURCE = ''DP''',
'and REQUEST_ID = :P11_ITEM_ID;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8893313198220170)
,p_plug_name=>'Cashflow Details Report'
,p_parent_plug_id=>wwv_flow_api.id(8893206578220169)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select LINE_ID,',
'       BUDGET_ALLOCATION_PLAN_ID,',
'       ACCOUNTING_YEAR,',
'       MULTI_YEAR_YN,',
'       DISTRIBUTION_DATE,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       PROJECT_NAME_NEW,',
'       TASK_NUMBER_NEW,',
'       EXPENDITURE_TYPE_NEW,',
'       ENTITY_CODE,',
'       COST_CENTER,',
'       BUDGET_GROUB_CODE,',
'       GL_ACCOUNT,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2,',
'       ENTITY_CODE_NEW,',
'       COST_CENTER_NEW,',
'       BUDGET_GROUB_CODE_NEW,',
'       GL_ACCOUNT_NEW,',
'       ACTIVITY_NEW,',
'       FUTURE1_NEW,',
'       FUTURE2_NEW,',
'       ALLOCATED_BUDGET,',
'       BUDGET,',
'       ENCUMBERANCE,',
'       ACTUAL,',
'       nvl(JAN,0)  JAN ,',
'       nvl(FEB,0)   FEB,',
'       nvl(MAR,0)   MAR,',
'       nvl(APR,0)   APR,',
'       nvl(MAY,0)   MAY,',
'       nvl(JUN,0)   JUN,',
'       nvl(JUL,0)   JUL,',
'       nvl(AUG,0)   AUG,',
'       nvl(SEP,0)   SEP,',
'       nvl(OCT,0)   OCT,',
'       nvl(NOV,0)   NOV,',
'       nvl(DEC,0)   DEC,',
'       LINE_TYPE,',
'       TOTAL_CF,',
'       NOTE,',
'       STATUS,',
'       FINAL_STATUS_ON,',
'       SOURCE,',
'       REQUEST_ID,',
'       REQUEST_LINE_ID,',
'       INITIATIVE_ID,',
'       INITIATIVE_NEW_NAME,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       TOTAL_CF_FORMAT',
'  from CASHFLOW_LINES',
'  where SOURCE = ''DP''',
'and REQUEST_ID = :P11_ITEM_ID;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P11_ITEM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Cashflow Details Report'
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
 p_id=>wwv_flow_api.id(8893331368220171)
,p_max_row_count=>'1000000'
,p_allow_save_rpt_public=>'Y'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_rows_per_page=>'N'
,p_show_filter=>'N'
,p_show_control_break=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_show_help=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:74:&SESSION.::&DEBUG.::P74_ITEM_ID:&P11_ITEM_ID.'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P11_REVIEW_STATUS in (''Draft'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>153095500342276135
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8893436438220172)
,p_db_column_name=>'LINE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8893711103220174)
,p_db_column_name=>'ACCOUNTING_YEAR'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Budget Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8893895774220176)
,p_db_column_name=>'DISTRIBUTION_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Distribution Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8893949368220177)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8894120333220178)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8894164367220179)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8894300522220180)
,p_db_column_name=>'PROJECT_NAME_NEW'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'New Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8894376011220181)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'New Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8894473547220182)
,p_db_column_name=>'EXPENDITURE_TYPE_NEW'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'New Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8894549203220183)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8894642035220184)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8894818829220185)
,p_db_column_name=>'BUDGET_GROUB_CODE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Budget Groub Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8894925990220186)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9186620527247737)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9186638132247738)
,p_db_column_name=>'FUTURE1'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9186736749247739)
,p_db_column_name=>'FUTURE2'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9188021665247751)
,p_db_column_name=>'JAN'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'01-&P11_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9188117425247752)
,p_db_column_name=>'FEB'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'02-&P11_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9188145180247753)
,p_db_column_name=>'MAR'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'03-&P11_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9188256874247754)
,p_db_column_name=>'APR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'04-&P11_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9188417703247755)
,p_db_column_name=>'MAY'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'05-&P11_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9188490216247756)
,p_db_column_name=>'JUN'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'06-&P11_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9188626114247757)
,p_db_column_name=>'JUL'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'07-&P11_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9188706377247758)
,p_db_column_name=>'AUG'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'08-&P11_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9188763249247759)
,p_db_column_name=>'SEP'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'09-&P11_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9188848314247760)
,p_db_column_name=>'OCT'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'10-&P11_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9188972383247761)
,p_db_column_name=>'NOV'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'11-&P11_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9189079490247762)
,p_db_column_name=>'DEC'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'12-&P11_ESTIMATED_YEAR.'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9189346157247765)
,p_db_column_name=>'NOTE'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9189454597247766)
,p_db_column_name=>'STATUS'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9190229554247773)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9190248136247774)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9190424526247775)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9190453314247776)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9190611139247777)
,p_db_column_name=>'TOTAL_CF_FORMAT'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Total Cf Format'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9189998996247771)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>570
,p_column_identifier=>'AX'
,p_column_label=>'Initiative Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9190033229247772)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>580
,p_column_identifier=>'AY'
,p_column_label=>'Initiative New Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9189249942247764)
,p_db_column_name=>'TOTAL_CF'
,p_display_order=>590
,p_column_identifier=>'AQ'
,p_column_label=>'Total Cf'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9189597980247767)
,p_db_column_name=>'FINAL_STATUS_ON'
,p_display_order=>600
,p_column_identifier=>'AT'
,p_column_label=>'Final Status On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9189147408247763)
,p_db_column_name=>'LINE_TYPE'
,p_display_order=>610
,p_column_identifier=>'AP'
,p_column_label=>'Line Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9187663862247748)
,p_db_column_name=>'BUDGET'
,p_display_order=>620
,p_column_identifier=>'AA'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9187802585247749)
,p_db_column_name=>'ENCUMBERANCE'
,p_display_order=>630
,p_column_identifier=>'AB'
,p_column_label=>'Encumberance'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9187899413247750)
,p_db_column_name=>'ACTUAL'
,p_display_order=>640
,p_column_identifier=>'AC'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9187541236247747)
,p_db_column_name=>'ALLOCATED_BUDGET'
,p_display_order=>650
,p_column_identifier=>'Z'
,p_column_label=>'Allocated Budget'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9189673011247768)
,p_db_column_name=>'SOURCE'
,p_display_order=>660
,p_column_identifier=>'AU'
,p_column_label=>'Source'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8893612134220173)
,p_db_column_name=>'BUDGET_ALLOCATION_PLAN_ID'
,p_display_order=>670
,p_column_identifier=>'B'
,p_column_label=>'Budget Allocation Plan Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8893799680220175)
,p_db_column_name=>'MULTI_YEAR_YN'
,p_display_order=>680
,p_column_identifier=>'D'
,p_column_label=>'Multi Year Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9189823956247769)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>690
,p_column_identifier=>'AV'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9191524942247786)
,p_db_column_name=>'REQUEST_LINE_ID'
,p_display_order=>700
,p_column_identifier=>'BE'
,p_column_label=>'Request Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(9209625315252399)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1534118'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:APXWS_CC_001'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(9660378965553445)
,p_report_id=>wwv_flow_api.id(9209625315252399)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'AD + AE + AF + AG + AH + AI + AJ + AK + AL + AM + AN + AO'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Total'
,p_report_label=>'Total'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128642068738672040)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127813188296449776)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(127749711524449850)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(127867332295449731)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128642638510672038)
,p_plug_name=>'Main Details'
,p_icon_css_classes=>'fa-list-ul'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody:margin-right-none'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(123747193702893146)
,p_plug_name=>'Project Status Tracking.'
,p_parent_plug_id=>wwv_flow_api.id(128642638510672038)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_PBP_EMP = ''Y'' or',
':IS_DP_ADMIN = ''Y'' or',
':IS_VIEW_ALL_DP_ITEMS = ''Y'' or',
':PERSON_ID = 680461'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(123747075320893145)
,p_plug_name=>'Project Status Tracking'
,p_parent_plug_id=>wwv_flow_api.id(123747193702893146)
,p_icon_css_classes=>'fa-history'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       order_no,',
'       DP_ITEM_ID,',
'       DP_ITEM_STATUS_ID,',
'       COMMENT_TEXT,',
'       FROM_DATE,',
'       TO_DATE,',
'       ACTION,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download,',
'       SEND_TO_ALL,',
'       SEND_MAIL_YN,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATED_ON,',
'       UPDATED_ON',
'  from DP_ITEM_STATUS',
'  where DP_ITEM_ID = :P11_ITEM_ID',
'  order by order_no'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P11_ITEM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Project Status Tracking'
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
 p_id=>wwv_flow_api.id(123746977665893144)
,p_max_row_count=>'1000000'
,p_allow_report_saving=>'N'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'NONE'
,p_show_detail_link=>'N'
,p_show_select_columns=>'N'
,p_show_rows_per_page=>'N'
,p_show_filter=>'N'
,p_show_sort=>'N'
,p_show_control_break=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_show_help=>'N'
,p_download_formats=>'CSV:EMAIL:PDF'
,p_owner=>'TCA9051'
,p_internal_uid=>179775451586432438
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123746830103893143)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123746763013893142)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122547842538343741)
,p_db_column_name=>'ORDER_NO'
,p_display_order=>30
,p_column_identifier=>'T'
,p_column_label=>'Sequence'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123746702603893141)
,p_db_column_name=>'DP_ITEM_STATUS_ID'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Project Status'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(122786651982504967)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123746576473893140)
,p_db_column_name=>'COMMENT_TEXT'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123746476977893139)
,p_db_column_name=>'FROM_DATE'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'From'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123746426576893138)
,p_db_column_name=>'TO_DATE'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'To'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123746235835893137)
,p_db_column_name=>'ACTION'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Action'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123746193018893136)
,p_db_column_name=>'FILENAME'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Filename'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123746030745893135)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123745952636893134)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123745911441893133)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>120
,p_column_identifier=>'K'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123745787766893132)
,p_db_column_name=>'SEND_TO_ALL'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Send To All'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122551829867343781)
,p_db_column_name=>'SEND_MAIL_YN'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'Send Mail Yn'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122551825476343780)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'Performed By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122551708644343779)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>160
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122551614758343778)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>170
,p_column_identifier=>'P'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122551498734343777)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>180
,p_column_identifier=>'Q'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122551339381343776)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>190
,p_column_identifier=>'R'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122551324797343775)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>200
,p_column_identifier=>'S'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:DP_ITEM_STATUS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED_ON:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(122538214108257987)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1809843'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORDER_NO:DP_ITEM_STATUS_ID:CREATED_BY:FROM_DATE:TO_DATE:COMMENT_TEXT:DOWNLOAD:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(122295081897675063)
,p_report_id=>wwv_flow_api.id(122538214108257987)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'TO_DATE'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("TO_DATE" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D0F1CC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128643411891672037)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(128642638510672038)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128920558438697316)
,p_plug_name=>'Header Details'
,p_parent_plug_id=>wwv_flow_api.id(128642638510672038)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86019473138539315)
,p_plug_name=>'Project Details'
,p_parent_plug_id=>wwv_flow_api.id(128920558438697316)
,p_icon_css_classes=>'fa-number-1-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>90
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'ALWAYS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86019958169539320)
,p_plug_name=>'Details L1'
,p_parent_plug_id=>wwv_flow_api.id(86019473138539315)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86019858517539319)
,p_plug_name=>'Details R1'
,p_parent_plug_id=>wwv_flow_api.id(86019473138539315)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86019354323539314)
,p_plug_name=>'Details L1'
,p_parent_plug_id=>wwv_flow_api.id(86019473138539315)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86019278529539313)
,p_plug_name=>'Details R1'
,p_parent_plug_id=>wwv_flow_api.id(86019473138539315)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86007570894535531)
,p_plug_name=>'Budget Details'
,p_parent_plug_id=>wwv_flow_api.id(128920558438697316)
,p_icon_css_classes=>'fa-number-2-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>200
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'ALWAYS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86007431405535530)
,p_plug_name=>'Details L2'
,p_parent_plug_id=>wwv_flow_api.id(86007570894535531)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(86007393617535529)
,p_plug_name=>'Details R2'
,p_parent_plug_id=>wwv_flow_api.id(86007570894535531)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(80057095185541739)
,p_plug_name=>'Details Notes'
,p_parent_plug_id=>wwv_flow_api.id(86007570894535531)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128920724803697318)
,p_plug_name=>'Summary'
,p_parent_plug_id=>wwv_flow_api.id(128642638510672038)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_display_column=>11
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128920832270697319)
,p_plug_name=>'Status'
,p_parent_plug_id=>wwv_flow_api.id(128920724803697318)
,p_icon_css_classes=>'fa-suitcase'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody:t-Form--slimPadding:t-Form--large:t-Form--leftLabels:margin-right-none'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128643868169672037)
,p_plug_name=>'Documents'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>80
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128750155827237504)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(128643868169672037)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       DP_ITEMS_ID,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       TAGS,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY,',
'       COMMENT_ID,',
'      sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from DP_ITEMS_DOCUMENTS',
'  where dp_items_id = :P11_ITEM_ID',
'    order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P11_ITEM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Documents report'
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
 p_id=>wwv_flow_api.id(128750297986237505)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No documents available.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>128750297986237505
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128750387394237506)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128750465555237507)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128750592359237508)
,p_db_column_name=>'DP_ITEMS_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Dp Items Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128750681814237509)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.::P14_PAGE_FROM,P14_REVIEW_STATUS,P14_ID:11,&P11_REVIEW_STATUS.,#ID#'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128750739489237510)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128750899156237511)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128750943967237512)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128751015788237513)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128751135976237514)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128751248542237515)
,p_db_column_name=>'CREATED'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128751389225237516)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128751403301237517)
,p_db_column_name=>'UPDATED'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128751551496237518)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128751691167237519)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128751790120237520)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128751874634237521)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:DP_ITEMS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(128775810689952672)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1287759'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:TAGS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128644208214672037)
,p_plug_name=>'Review /Approval History'
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>90
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT 1',
'FROM dp_items_approval_history',
'where request_id = :P11_ITEM_ID;'))
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128752256387237525)
,p_plug_name=>'Review History Report'
,p_parent_plug_id=>wwv_flow_api.id(128644208214672037)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    h.id,',
'    h.request_id,',
'    h.step_no,',
'    h.person_id,',
'    h.role_id,',
'    h.role_desc,',
'    h.action_required,',
'    h.recevied_date,',
'    h.status,',
'    h.action_date,',
'    h.comments,',
'    h.approval_type,',
'    case h.status',
'        When ''Rejected'' Then ''u-danger-text''',
'        when ''Approved'' Then ''u-success''',
'        When ''Accepted'' Then ''u-success''',
'    End status_class,',
'       ',
'    e.full_name_en || ''('' || e.user_name || '')'' as full_name_en,',
'    case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'       when 0  THEN',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'        else  ',
'            ',
'         ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'       end Photo',
'FROM',
'    dp_items_approval_history h, dct_employees_list2  e',
'where h.person_id = e.person_id (+)',
'and h.request_id = :P11_ITEM_ID',
'and h.status != ''Beaten''',
'order by h.STEP_NO ',
'--, h.ID',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P11_ITEM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Review History Report'
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
 p_id=>wwv_flow_api.id(128752370862237526)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>128752370862237526
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128752434669237527)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128752548280237528)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128752647785237529)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128752708752237530)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128752854890237531)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(129038068099971033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128752983689237532)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128753041810237533)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128753173805237534)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128753205046237535)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128753310255237536)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128753406037237537)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128753543656237538)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128828562684256806)
,p_db_column_name=>'STATUS_CLASS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128828629196256807)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128828748628256808)
,p_db_column_name=>'PHOTO'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(129019330754924895)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1290194'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ROLE_ID:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(129958744372071470)
,p_report_id=>wwv_flow_api.id(129019330754924895)
,p_name=>'Pending'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Pending'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Pending''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D0F1CC'
,p_row_font_color=>'#000000'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(129032362785007606)
,p_plug_name=>'Collaboration'
,p_icon_css_classes=>'fa-comments-o  fam-sleep fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody:margin-left-none'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(129032531019007608)
,p_name=>'Comments Report'
,p_parent_plug_id=>wwv_flow_api.id(129032362785007606)
,p_template=>wwv_flow_api.id(127776395121449810)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Form--slimPadding:t-Form--large'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  ',
'        CASE',
'            WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(user_name)',
'     End   user_icon,',
'  updated_date  comment_date,',
'  full_name_en user_name,',
'  comment_text                    comment_text,',
'  null comment_modifiers,',
'   ''u-color-''||ora_hash(user_name,45) icon_modifier,',
'  ACTION     actions,',
'  ''''     attribute_1,',
'  ''''     attribute_2,',
'  ''''    attribute_3,',
'  sys.dbms_lob.getlength(file_blob)     attribute_4,',
'  comment_id,',
'  filename',
'  --',
',(Select e.full_name_en',
'                    from employees_v e',
'                    where e.person_id = comment_to_person_id)',
'         Comment_to',
'--',
'from   ',
'(SELECT',
'    c.comment_id,',
'    c.ITEM_ID,',
'    c.comment_text,',
'    c.created_by,',
'    c.updated_by,',
'    c.creation_date,',
'    c.updated_date,',
'    c.action        action,',
'    e.full_name_en,',
'    e.user_name,',
'    e.photo_blob,',
'    c.filename,',
'    c.file_blob,',
'    c.comment_to_person_id',
'FROM',
'    dp_items_comments c , dct_employees_list2 e',
'where c.updated_by = e.person_id',
')',
'where ITEM_ID = :P11_ITEM_ID',
'order by CREATION_DATE desc;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P11_ITEM_ID'
,p_query_row_template=>wwv_flow_api.id(127832693224449762)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Communications yet.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129032651831007609)
,p_query_column_id=>1
,p_column_alias=>'USER_ICON'
,p_column_display_sequence=>1
,p_column_heading=>'User Icon'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<img src="#USER_ICON#" alt="Image Not Found" height="40" width="40">'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129032778717007610)
,p_query_column_id=>2
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>2
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_column_html_expression=>'<br>#COMMENT_DATE#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129032802693007611)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span style="color:red">From: #USER_NAME# </span>'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129032943072007612)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.::P17_COMMENT_ID:#COMMENT_ID#'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129033005645007613)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129033120081007614)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129033226152007615)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129033377656007616)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129033400028007617)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129033507035007618)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129033659861007619)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129033788950007620)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>12
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129033893613007621)
,p_query_column_id=>13
,p_column_alias=>'FILENAME'
,p_column_display_sequence=>13
,p_column_heading=>'Filename'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(129033954002007622)
,p_query_column_id=>14
,p_column_alias=>'COMMENT_TO'
,p_column_display_sequence=>14
,p_column_heading=>'Comment To'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(129036717981007650)
,p_plug_name=>'Review & Verification Partners'
,p_icon_css_classes=>'fa-check-circle-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>50
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128920054696697311)
,p_plug_name=>'Roles'
,p_parent_plug_id=>wwv_flow_api.id(129036717981007650)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID, ITEM_ID, ROLE_ID, PERSON_ID, CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON',
'from DP_ITEM_ROLES',
'where item_id = :P11_ITEM_ID',
'or item_id = :P11_ITEM_ID_H;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P11_ITEM_ID,P11_ITEM_ID_H'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Roles'
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
 p_id=>wwv_flow_api.id(136448315144457250)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_detail_link=>'f?p=&APP_ID.:81:&SESSION.::&DEBUG.::P81_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_DP_ADMIN = ''Y'' or',
':IS_IFINANCE_ADMIN = ''Y'' or',
':IS_PBP_EMP = ''Y'''))
,p_owner=>'TCA9051'
,p_internal_uid=>167074114107868332
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136448209596457249)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(129038068099971033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136448060034457248)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136447977723457247)
,p_db_column_name=>'ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136447888588457246)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Item Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136447793775457245)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136447708489457244)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136447547885457243)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136447478574457242)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(136126905574617927)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1673956'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ROLE_ID:PERSON_ID:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(511556726615694056)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(86019858517539319)
,p_button_name=>'Change_procurment_Method'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Change Procurment Method'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:91:&SESSION.::&DEBUG.:91:P91_DP_ITEM_ID:&P11_ITEM_ID.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(:PERSON_ID = 680461 or :IS_PBP_EMP = ''Y'') and',
':P11_DP_PROCUREMENT_METHOD is not null and',
':P11_TEMPLATE_ID is null'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-eyedropper'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(122551063022343773)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(123747075320893145)
,p_button_name=>'change'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Change Project Status'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:84:&SESSION.::&DEBUG.::P84_DP_ITEM_ID:&P11_ITEM_ID.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_DP_ADMIN = ''Y'' or',
':PERSON_ID = 680461'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-circle-arrow-in-ne'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(122547578460343738)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(128920832270697319)
,p_button_name=>'Change_project'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Change Project Status'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:85:&SESSION.::&DEBUG.::P85_DP_ITEM_ID:&P11_ITEM_ID.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(:P11_DP_ITEM_STATUS_NEXT_ACTION = ''M'')',
'and (:IS_PBP_EMP = ''Y'' or',
':IS_DP_ADMIN = ''Y'' or',
'--:IS_VIEW_ALL_DP_ITEMS = ''Y'' or',
':PERSON_ID = 680461)'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-circle-arrow-in-ne'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(676653145236347)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(87418383085717)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add Participant'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:59:&SESSION.::&DEBUG.::P59_ITEM_ID:&P11_ITEM_ID.'
,p_button_condition=>'P11_APPROVAL_STATUS'
,p_button_condition2=>'Cancelled'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128676415845987409)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(128642068738672040)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:&P11_PAGE_FROM.:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128750014189237503)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(128643868169672037)
,p_button_name=>'New_document'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(129032431140007607)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(129032362785007606)
,p_button_name=>'AddComment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--noUI:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Collaborate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.::P17_ITEM_ID:&P11_ITEM_ID.'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128520922847121530)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(128642068738672040)
,p_button_name=>'Edit_Header'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Update Item Details'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:10:P10_ITEM_ID,P10_CHANGED:&P11_ITEM_ID.,N'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number  := 0 ;',
'begin',
'',
'select nvl(count(PERSON_ID),0)',
'into l_count',
'from DP_ITEM_PARTICIPANTS',
'where (item_id = :P11_ITEM_ID',
'or item_id = :P11_ITEM_ID_H)',
'and status = ''A''',
'and person_id = :PERSON_ID',
'and sysdate between nvl(start_date , sysdate - 10)',
'and nvl(end_date , sysdate + 10);',
'',
'if :P11_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'') and',
'(:P11_END_USER_ID = :PERSON_ID or ',
':P11_CREATED_BY = :PERSON_ID or',
'l_count > 0)',
'',
'Then',
'    return true;',
'else',
'    return false;',
'end if;',
'',
'End ;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-pencil'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(122411855239330880)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(128642068738672040)
,p_button_name=>'CANCEL_ITEM'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Cancel Item'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P11_REVIEW_STATUS not in  (''Cancelled'' )',
'and :P11_DP_SCOPING_ID is null',
'and (',
':IS_PBP_EMP = ''Y'' or',
':IS_DP_ADMIN = ''Y'' or',
'-- :IS_VIEW_ALL_DP_ITEMS = ''Y'' or',
':PERSON_ID = 680461 or ',
':PERSON_ID = :P11_CREATED_BY)'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-stop-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(136200647689004027)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(128642068738672040)
,p_button_name=>'Generate_Scoping'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Generate Scoping'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_count     VARCHAR2(1);',
'    l_result    boolean;',
'BEGIN',
'',
'    IF (:P11_approval_status = ''Approved''        AND',
'       NVL(:P11_estimated_budget_h, 0) > 50000  AND',
'       :P11_template_id IS not NULL             AND',
'       :P11_dp_scoping_id IS  NULL             AND',
'        DP_ITEMS_UTIL.get_dp_procurement_method_id(:P11_ITEM_ID) in (289)',
'       )',
'       ',
'       THEN',
'            IF :IS_DP_ADMIN = ''N''',
'                Then',
'                    SELECT  decode(COUNT(*), 0, ''N'', ''Y'')',
'                    INTO l_count',
'                    FROM dp_item_participants',
'                    WHERE   status = ''A''',
'                        AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)',
'                        AND item_id = :p11_item_id',
'                        AND :PERSON_ID = person_id;',
'                        ',
'                        IF l_count = ''Y''',
'                            then',
'                                return true;',
'                             else',
'                                return false;',
'                        end if;',
'            elsif   :IS_DP_ADMIN = ''Y''',
'                -- for Admin',
'                 then   ',
'                    return true;',
'            End if;',
'     Else',
'        return false;',
'    ',
'    End if;',
'END;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-clipboard-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(136202001465004041)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(128642068738672040)
,p_button_name=>'Scoping_Document'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Scoping Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P11_DP_SCOPING_ID is not null     and ',
':P11_APPROVAL_STATUS = ''Approved'' and',
'nvl(:P11_ESTIMATED_BUDGET_H,0) > 50000'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-file-word-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128676514268987410)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(128642068738672040)
,p_button_name=>'Rollback'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865952197449732)
,p_button_image_alt=>'Rollback'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'PERSON_ID'
,p_button_condition2=>'680461'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128828888107256809)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(128642068738672040)
,p_button_name=>'UPDATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P11_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'') and',
'(:P11_END_USER_ID = :PERSON_ID or :P11_CREATED_BY = :PERSON_ID) and 1 = 2'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-save-as'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128677286965987417)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(128642068738672040)
,p_button_name=>'Submit_REVIEW'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Submit For Review'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P11_ITEM_ID is not null ',
'and :P11_REVIEW_STATUS in (''Draft'',''Withdraw'' , ''Return'') ',
'and(:P11_END_USER_ID = :PERSON_ID or ',
'    :P11_CREATED_BY = :PERSON_ID  or ',
'    :PERSON_ID = 680461 or ',
'    :PERSON_ID =  DP_ITEMS_UTIL.get_active_owner(:P11_ITEM_ID) )'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7919712052999547)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_api.id(128642068738672040)
,p_button_name=>'Cashflow'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconLeft:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Cashflow'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number;',
'begin',
'',
'select nvl(count(*) , 0)',
'into l_count',
'from cashflow_lines',
'where SOURCE = ''DP''',
'and REQUEST_ID = :P11_ITEM_ID;',
'',
'if (:P11_ESTIMATED_BUDGET is not null and l_count = 0 and :P11_REVIEW_STATUS != ''Cancelled'')',
'    Then ',
'        return true;',
'    else',
'        return false;',
'end if;',
'',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_button_css_classes=>' class="t-Button t-Button--icon t-Button--success t-Button--iconLeft"'
,p_icon_css_classes=>'fa-money'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128677349419987418)
,p_button_sequence=>100
,p_button_plug_id=>wwv_flow_api.id(128642068738672040)
,p_button_name=>'Withdraw'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_ACTION,P12_REQUEST_ID:Withdraw,&P11_ITEM_ID.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(:P11_END_USER_ID = :PERSON_ID or :P11_CREATED_BY = :PERSON_ID )',
'and (:P11_REVIEW_STATUS not in (''Cancelled'', ''Withdraw'' , ''Draft'' , ''Return'' , ''Not Accepted''))',
'and :P11_DP_SCOPING_ID is null'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3047635517104341)
,p_button_sequence=>110
,p_button_plug_id=>wwv_flow_api.id(128642068738672040)
,p_button_name=>'Create_Version'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Create Version'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-copy'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7930498959110798)
,p_button_sequence=>120
,p_button_plug_id=>wwv_flow_api.id(128642068738672040)
,p_button_name=>'CREATE_PR'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Generate PR'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:71:&SESSION.::&DEBUG.::P71_ITEM_ID:&P11_ITEM_ID.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P11_APPROVAL_STATUS = ''Approved'' 	and ',
'nvl(:P11_ESTIMATED_BUDGET_H,0) <= 50000 and',
':P11_PR_GENERATION_STATUS  not in (''S'' , ''A'')	and',
':P11_PR_NUMBER		   is null'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-credit-card-terminal'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(122411316398330874)
,p_branch_name=>'Go to Home After Cancel'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(122411855239330880)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(128923990893697350)
,p_branch_name=>'GO TO Confirmation 13'
,p_branch_action=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13:P13_REVIEW_STATUS,P13_REQUEST_ID:&P11_REVIEW_STATUS.,&P11_ITEM_ID_H.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(128677286965987417)
,p_branch_sequence=>20
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(7919986063999550)
,p_branch_name=>'Go To Cashflow - 73'
,p_branch_action=>'f?p=&APP_ID.:74:&SESSION.::&DEBUG.:74:P74_ITEM_ID:&P11_ITEM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(7919712052999547)
,p_branch_sequence=>30
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(136202153510004042)
,p_branch_name=>'Go to Scoping document 28'
,p_branch_action=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_SCOPE_ID:&P11_DP_SCOPING_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(136202001465004041)
,p_branch_sequence=>40
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(136201183262004032)
,p_branch_name=>'Go to scoping confirmation 27'
,p_branch_action=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.::P27_ITEM_ID_H,P27_SCOPING_ID,P27_TEMPLATE,P27_TEMPLATE_ID:&P11_ITEM_ID.,&P11_DP_SCOPING_ID.,&P11_TEMPLATE.,&P11_TEMPLATE_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(136200647689004027)
,p_branch_sequence=>50
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(138256000233279223)
,p_branch_name=>'Go to 11'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ITEM_ID:&P11_ITEM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(128828888107256809)
,p_branch_sequence=>60
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(138256109412279224)
,p_branch_name=>'Go to 14'
,p_branch_action=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:14:P14_DP_ITEMS_ID,P14_PAGE_FROM,P14_REVIEW_STATUS:&P11_ITEM_ID.,11,&P11_REVIEW_STATUS.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(128750014189237503)
,p_branch_sequence=>70
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(528641017815468652)
,p_name=>'P11_PR_GENERATION_STATUS'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(128642068738672040)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(519289628220516150)
,p_name=>'P11_DP_PROCUREMENT_METHOD'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(86019858517539319)
,p_prompt=>'Procurement Method'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'DP PROCUREMENT METHOD-ALL'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select TENDER_TYPE , ID',
' from DP_PROCUREMENT_METHOD'))
,p_grid_label_column_span=>3
,p_display_when=>'P11_DP_PROCUREMENT_METHOD'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(519289473235516149)
,p_name=>'P11_CONTRACT_NO'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(86019278529539313)
,p_prompt=>'Contract No'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P11_CONTRACT_NO'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(515377073996329498)
,p_name=>'P11_ESTIMATED_BUDGET_DEFINE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(128642068738672040)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(515376496824329492)
,p_name=>'P11_SUBMIT_REVIEW_ON'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(128642068738672040)
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(515376438133329491)
,p_name=>'P11_EXPECTED_DELIVERY_DATE'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(128642068738672040)
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(515376272826329490)
,p_name=>'P11_SLA_DATE'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(128920832270697319)
,p_source=>'to_date(:P11_expected_delivery_date , ''DD-Mon-yyyy'')'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when=>'P11_EXPECTED_DELIVERY_DATE'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_help_text=>'SLA date is ....'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(299639790001655604)
,p_name=>'P11_PROJECT_NUMBER_H'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(86007431405535530)
,p_display_as=>'NATIVE_HIDDEN'
,p_help_text=>'Select from list of projects.'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(299639751876655603)
,p_name=>'P11_DP_ITEM_CODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(86019354323539314)
,p_prompt=>'Item Code'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(299639605529655602)
,p_name=>'P11_PR_NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(128642068738672040)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(299639545107655601)
,p_name=>'P11_SLA_DATE_AFTER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(128920832270697319)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(299639342550655599)
,p_name=>'P11_ESTIMATED_BUDGET_BRACKET_ID'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(128642068738672040)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297941997555259144)
,p_name=>'P11_MAIN_CATEGORY_ID'
,p_is_required=>true
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(86019958169539320)
,p_prompt=>'Category Level 1'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ITEM MAIN CATEGORIES POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  CATEGORY_NAME , CATEGORY_ID , CATEGORY_DESCRIPTION ',
'from dp_item_categories',
'where ORDER_LEVEL = 231 ;'))
,p_colspan=>11
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_help_text=>'Select from list of Level 1 categories depending on service being sourced.'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297941151511259142)
,p_name=>'P11_MAIN_CATEGORY_ID_H'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(86019958169539320)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297940770162259142)
,p_name=>'P11_CATEGORY_ID'
,p_is_required=>true
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(86019958169539320)
,p_prompt=>'Category Level 2'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ITEM CATEGORIES ALL LOV'
,p_lov=>'select  CATEGORY_NAME , CATEGORY_ID from dp_item_categories'
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P11_MAIN_CATEGORY_ID'
,p_ajax_items_to_submit=>'P11_MAIN_CATEGORY_ID'
,p_ajax_optimize_refresh=>'Y'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_help_text=>'Select from list of level 2 categories depending on service being sourced.'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297939820366259141)
,p_name=>'P11_SUB_CATEGORY_ID'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(86019958169539320)
,p_prompt=>'Category Level 3'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ITEM CATEGORIES ALL LOV'
,p_lov=>'select  CATEGORY_NAME , CATEGORY_ID from dp_item_categories'
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P11_CATEGORY_ID'
,p_ajax_items_to_submit=>'P11_CATEGORY_ID'
,p_ajax_optimize_refresh=>'Y'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_help_text=>'Select from list of Level 3 categories depending on service being sourced.'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297938585052259140)
,p_name=>'P11_END_USER_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(86019858517539319)
,p_prompt=>'End User'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297938266570259140)
,p_name=>'P11_END_USER_ID_OLD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(86019858517539319)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297937844885259139)
,p_name=>'P11_COST_CENTER'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(86019858517539319)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'COST CENTERS WITH NAMES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select COST_CENTER_CODE || ''('' || COST_CENTER_DESCRIPTION || '')'' display, COST_CENTER_CODE',
'from( ',
'select DISTINCT COST_CENTER_CODE , COST_CENTER_DESCRIPTION ',
'from dct_gl_code_combinations_all);'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297937466302259139)
,p_name=>'P11_CC_H'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(86019858517539319)
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when=>'P11_ITEM_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297937055685259139)
,p_name=>'P11_CC_NAME_H'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(86019858517539319)
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when=>'P11_ITEM_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297936672820259138)
,p_name=>'P11_SECTOR_ID'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(86019858517539319)
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORGANIZATION NAME RETURN ORG_ID'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297936232229259138)
,p_name=>'P11_DEPARTMENT_ID'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(86019858517539319)
,p_prompt=>'Department'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ORGANIZATION NAME RETURN ORG_ID'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297935514572259138)
,p_name=>'P11_PROJECT_TITLE'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(86019354323539314)
,p_prompt=>'Project Title'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_lov=>'select distinct PROJECT_TITLE from dp_items'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>'Please enter the project name that you wish to use for communication and documents titles through the procurement process.'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297935129520259138)
,p_name=>'P11_PROJECT_DESCRIPTION'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(86019354323539314)
,p_prompt=>'Project Brief'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>3
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_help_text=>'Give a summary in one or two paragraphs including brief statement on: project requirements, supplier key deliverables, location of work and special requirements, that could be used to send to suppliers for an Expression of Interest and other key docu'
||'ments'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297934191673259137)
,p_name=>'P11_INITIATIVE_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(86019354323539314)
,p_prompt=>'Initiative'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'INITIATIVES POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select INITIATIVE_ID, INITIATIVE_CODE, INITIATIVE_NAME, ',
'    decode(INITIATIVE_TYPE, ''S'' , ''Strategic'' , ''N'', ''Non-Strategic'') INITIATIVE_TYPE',
'from strategic_initiatives;'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297933504134259137)
,p_name=>'P11_DP_ITEM_TYPE_ID'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(86019278529539313)
,p_prompt=>'Project Item Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'DP ITEM TYPES LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 45 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><span style="text-decoration: underline;"><span style="color: #0000ff; text-decoration: underline;">Strategic:</span></span> Projects where a strategy needs to be designed and requires SA support throughout the process.</p>',
'<p><br /><span style="text-decoration: underline;"><span style="color: #0000ff; text-decoration: underline;">Operational:</span></span> Projects that don&rsquo;t directly impact the economy and don&rsquo;t require an approved business case by SPD.</p'
||'>'))
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297932645855259136)
,p_name=>'P11_RISK_ID'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(86019278529539313)
,p_prompt=>'Risk'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'DP RISK LEVEL LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 46 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10);'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Risk of the project - high, medium, low.',
'<p><span style="color: #0000ff;"><strong>High: </strong></span>Any delays, obstacles, or discrepancies can have a negative impact on the objectives of the project (e.g. financial, revenue, social, reputational).</p>',
'<p><strong><span style="color: #0000ff;">Low:</span> </strong>Possible delays won&rsquo;t have any major impact on the objectives of project.</p>'))
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297931695326259136)
,p_name=>'P11_PRIORITY_ID'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(86019278529539313)
,p_prompt=>'Priority'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'PRIORITY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from dct_lookup_values',
'where lookup_id = (Select x.lookup_id',
'                    from dct_lookups x',
'                    where x.LOOKUP_CODE = ''PRIORITY'');'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Priority of the project - high, medium, low.',
'<p><span style="color: #0000ff;"><strong>High: </strong><span style="color: #000000;">Requires a faster usual turn-around time</span></span></p>',
'<p><strong><span style="color: #0000ff;">Low:</span> </strong>Enough time for the standard procurement timeline to take place.</p>'))
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297930188651255365)
,p_name=>'P11_NOTES'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(80057095185541739)
,p_prompt=>'Notes'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>2
,p_grid_label_column_span=>2
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297929508573255364)
,p_name=>'P11_PROJECT_NEW_YN'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(86007431405535530)
,p_item_default=>'N'
,p_display_as=>'NATIVE_HIDDEN'
,p_help_text=>'Select if not an existing DCT project listed.'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297928622757255364)
,p_name=>'P11_PROJECT_NEW_YN_OLD'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(86007431405535530)
,p_item_default=>'N'
,p_prompt=>'New Project ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Select if not an existing DCT project listed.'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297927696141255363)
,p_name=>'P11_PROJECT_NUMBER'
,p_is_required=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(86007431405535530)
,p_prompt=>'Project'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'OPERATIONAL PROJECTS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PROJECT_NUMBER || '' - '' || PROJECT_NAME  PROJECT_NAME , project_number ',
'from project',
'where PROJECT_TYPE = ''Operational'''))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>'Select from list of projects.'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297926854423255363)
,p_name=>'P11_PROJECT_NEW_NAME'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(86007431405535530)
,p_prompt=>'New Project Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Name of project if not already listed'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297925896581255362)
,p_name=>'P11_TASK_NEW_YN'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(86007431405535530)
,p_item_default=>'N'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when=>'P11_PROJECT_NEW_YN'
,p_display_when2=>'N'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297925477461255362)
,p_name=>'P11_TASK_NEW_YN_OLD'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(86007431405535530)
,p_item_default=>'N'
,p_prompt=>'New Task ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297925109696255362)
,p_name=>'P11_TASK_NUMBER'
,p_is_required=>true
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(86007431405535530)
,p_prompt=>'Task'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TASKS BY PROJECT NUMBER PAGE10'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select TASK_NUMBER  Task, TASK_DESCRIPTION, COST_CENTER, FUTURE2',
'from tasks_all_v',
'where project_number = :P10_PROJECT_NUMBER;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P11_PROJECT_NUMBER'
,p_ajax_items_to_submit=>'P11_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_display_when=>':P11_PROJECT_NEW_YN = ''N'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297924703072255362)
,p_name=>'P11_TASK_NUMBER_NEW'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(86007431405535530)
,p_prompt=>'New Task'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_named_lov=>'TASKS ALL (SAMPLE)'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct TASK_NUMBER d, TASK_NUMBER R',
'from tasks_all_v',
'where task_number not like ''?%''',
'order by 1;'))
,p_cSize=>30
,p_cMaxlength=>25
,p_grid_label_column_span=>3
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>'Max 25 Character.'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'Y'
,p_attribute_10=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297923789681255361)
,p_name=>'P11_EXPENDITURE_TYPE'
,p_is_required=>true
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(86007431405535530)
,p_prompt=>'Expenditure Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'EXPENDITURE TYPES BY PAGE 10'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EXPENDITURE_TYPE, DESCRIPTION, GL_ACCOUNT, GL_ACCOUNT_NAME',
'from expenditures_v',
'where project_number = :P10_PROJECT_NUMBER',
'and TASK_NUMBER = :P10_TASK_NUMBER ;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P11_TASK_NUMBER'
,p_ajax_items_to_submit=>'P11_TASK_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_display_when=>':P11_PROJECT_NEW_YN = ''N'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297923425759255361)
,p_name=>'P11_EXPENDITURE_TYPE_NEW'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(86007431405535530)
,p_prompt=>'New Expenditure Type'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EXPENDITURES ALL'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct EXPENDITURE_TYPE d, EXPENDITURE_TYPE r',
'from expenditures_v',
'order by 1'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_grid_label_column_span=>3
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297922708635255361)
,p_name=>'P11_ESTIMATED_DATE_DEFINE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(86007393617535529)
,p_item_default=>'Y'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297922283558255360)
,p_name=>'P11_ESTIMATED_DATE_DEFINE_OLD'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(86007393617535529)
,p_item_default=>'Y'
,p_prompt=>'Estimated Date Define ?'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_label_column_span=>3
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297921948094255360)
,p_name=>'P11_ESTIMATED_DATE'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(86007393617535529)
,p_prompt=>'Project Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Enter the estimated date when the work must start'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
,p_attribute_08=>'+00:+05'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297921073331255360)
,p_name=>'P11_PROJECT_END_DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(86007393617535529)
,p_prompt=>'Project End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Enter the estimated date when the work expected to end'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297920147808255359)
,p_name=>'P11_ESTIMATED_YEAR'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(86007393617535529)
,p_prompt=>'Estimated Year'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:2024;2024,2025;2025,2026;2026,2027;2027,2028;2028,2029;2029'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297919709217255359)
,p_name=>'P11_ESTIMATED_QUARTER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(86007393617535529)
,p_prompt=>'Estimated Quarter'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:1;1,2;2,3;3,4;4'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297919339903255359)
,p_name=>'P11_ESTIMATED_BUDGET'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(86007393617535529)
,p_prompt=>'Current Year Budget'
,p_post_element_text=>'<p>&nbsp; AED</p>'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Enter project budget in AED for current year'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297918421190255359)
,p_name=>'P11_ESTIMATED_BUDGET_H'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(86007393617535529)
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'B'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297918013373255358)
,p_name=>'P11_TOTAL_PROJECT_BUDGET'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(86007393617535529)
,p_prompt=>'Total Project Budget'
,p_post_element_text=>'<p>&nbsp; AED</p>'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Enter project budget in AED'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(297917105770255358)
,p_name=>'P11_TOTAL_PROJECT_BUDGET_H'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(86007393617535529)
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'B'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(122551194190343774)
,p_name=>'P11_DP_ITEM_STATUS_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(128920832270697319)
,p_prompt=>'Project Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'DP ITEM STATUS ALL'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select STATUS_NAME , ID',
'from dp_item_status_definitions',
'order by order_no'))
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p style="text-align: center;"><span style="text-decoration: underline; color: #ff0000;"><strong>Project Statuses description</strong></span></p>',
'<table style="border-collapse: collapse; width: 100%; height: 126px;" border="1">',
'<tbody>',
'<tr style="height: 18px;">',
'<td style="width: 8.06169%; background-color: #1c9ae0; text-align: center; height: 18px;"><span style="color: #ffffff;">Status</span></td>',
'<td style="width: 27.3625%; background-color: #1c9ae0; text-align: center; height: 18px;"><span style="color: #ffffff;">Description</span></td>',
'<td style="width: 4.78963%; background-color: #1c9ae0; text-align: center; height: 18px;"><span style="color: #ffffff;">Performed By</span></td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 8.06169%; text-align: center; height: 18px;"><strong>Uninitiated</strong></td>',
'<td style="width: 27.3625%; height: 18px;">Project is created but not initiated yet.</td>',
'<td style="width: 4.78963%; height: 18px;">System</td>',
'</tr>',
'<tr style="background-color: #daeaf3;">',
'<td style="width: 8.06169%; text-align: center; height: 18px;"><strong>Initiated</strong></td>',
'<td style="width: 27.3625%; height: 18px;">Project is Approved and imitated as well.</td>',
'<td style="width: 4.78963%; height: 18px;">Procurement BP</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 8.06169%; text-align: center; height: 18px;"><strong>Scoping</strong></td>',
'<td style="width: 27.3625%; height: 18px;">Project is under Scoping Stage.</td>',
'<td style="width: 4.78963%; height: 18px;">System</td>',
'</tr>',
'<tr style="background-color: #daeaf3;">',
'<td style="width: 8.06169%; text-align: center; height: 18px;"><strong>Sourcing</strong></td>',
'<td style="width: 27.3625%; height: 18px;">PR is generated and currently is with Sourcing Team.</td>',
'<td style="width: 4.78963%; height: 18px;">System</td>',
'</tr>',
'<tr style="height: 18px;">',
'<td style="width: 8.06169%; text-align: center; height: 18px;"><strong>Awarding</strong></td>',
'<td style="width: 27.3625%; height: 18px;">Project moves to contract drafting stage.</td>',
'<td style="width: 4.78963%; height: 18px;">Procurement BP</td>',
'</tr>',
'<tr style="background-color: #daeaf3;">',
'<td style="width: 8.06169%; text-align: center; height: 18px;"><strong>Completed</strong></td>',
'<td style="width: 27.3625%; height: 18px;">Project is completed. Either LOA is being awarded or PO have been issue.</td>',
'<td style="width: 4.78963%; height: 18px;">Procurement BP</td>',
'</tr>',
'</tbody>',
'</table>'))
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(122547096218343733)
,p_name=>'P11_DP_ITEM_STATUS_NEXT_ACTION'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(128920832270697319)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(action_by,''S'')',
'from dp_item_status_definitions',
'where order_no = (',
'select order_no + 1',
'from dp_item_status_definitions',
'where id = :P11_DP_ITEM_STATUS_ID)'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(122546964380343732)
,p_name=>'P11_DP_ITEM_STATUS_ID_H'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(128920832270697319)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7024194346823043)
,p_name=>'P11_EXPECTED_DELIVER_ON'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(128920832270697319)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Expected Delivery ON'
,p_source=>'P11_EXPECTED_DELIVERY_DATE'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P11_EXPECTED_DELIVERY_DATE'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>'The expected delivery date based on: SLA days + Submission Date'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7024256108823044)
,p_name=>'P11_SLA_DAYS'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(128920832270697319)
,p_prompt=>'Total SLA Days'
,p_post_element_text=>'<b>&nbsp; days</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P11_SLA_DAYS'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Total working days required by SMD team to fulfill the request, based on Project value the SMD has define the required days to deliver the demand plan item requested '
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128519537257121516)
,p_name=>'P11_PAGE_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(128642068738672040)
,p_item_default=>'1'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128519652794121517)
,p_name=>'P11_ITEM_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(128642068738672040)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128522906769121550)
,p_name=>'P11_PLANNING_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(128920832270697319)
,p_prompt=>'Planning Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'DP ITEM PLANNING STATUS'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 48 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10);'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128675609240987401)
,p_name=>'P11_REVIEW_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(128920832270697319)
,p_prompt=>'Review Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128675764393987402)
,p_name=>'P11_APPROVAL_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(128920832270697319)
,p_prompt=>'Approval Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128675855840987403)
,p_name=>'P11_CUTT_OFF_DATE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(128920832270697319)
,p_prompt=>'Cut Off Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128676065576987405)
,p_name=>'P11_CREATED_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(128643411891672037)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
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
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128676172845987406)
,p_name=>'P11_UPDATED_BY'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(128643411891672037)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128676266793987407)
,p_name=>'P11_CREATED_ON'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(128643411891672037)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(128676352384987408)
,p_name=>'P11_UPDATED_ON'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(128643411891672037)
,p_prompt=>'Updated On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(129035401606007637)
,p_name=>'P11_REVIEW_REJECT_REASON'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(128920832270697319)
,p_prompt=>'Review Comment'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P11_REVIEW_STATUS'
,p_display_when2=>'Not Accepted'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(136201972268004040)
,p_name=>'P11_DP_SCOPING_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(128642068738672040)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138255025336279213)
,p_name=>'P11_TEMPLATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(128642068738672040)
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select TEMPLATE_NAME',
'from dp_scope_templates',
'where template_id = (select TEMPLATE_ID',
'                    from dp_item_categories',
'                    where CATEGORY_ID = (select sub_category_id',
'                                          from dp_items  ',
'                                          where item_id = :P11_ITEM_ID))'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138255184439279214)
,p_name=>'P11_TEMPLATE_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(128642068738672040)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139017450853657701)
,p_name=>'P11_ITEM_ID_H'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(128642068738672040)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(9528625790155844)
,p_validation_name=>'Check Cashflow Allocation process'
,p_validation_sequence=>70
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count       number;',
'l_allocate    number;',
'',
'begin',
'-- check allocation amount',
'',
'    select count(*)',
'    into l_count',
'    from cashflow_lines',
'    where source = ''DP''',
'    and request_id = :P11_ITEM_ID;',
'',
'if l_count > 0',
'    Then',
'                        select nvl(jan,0) +',
'                               nvl(FEB,0) +',
'                               nvl(MAR,0) +',
'                               nvl(APR,0) +',
'                               nvl(MAY,0) +',
'                               nvl(JUN,0) +',
'                               nvl(JUL,0) +',
'                               nvl(AUG,0) +',
'                               nvl(SEP,0) +',
'                               nvl(OCT,0) +',
'                               nvl(NOV,0) +',
'                               nvl(DEC,0)',
'                        into',
'                             l_allocate',
'                        from cashflow_lines',
'                        where source = ''DP''',
'                        and request_id = :P11_ITEM_ID;',
'    else',
'        l_allocate :=  0;',
'end if;',
'',
'-- ',
'if :P11_ESTIMATED_BUDGET_H = l_allocate and l_allocate != 0',
'    Then',
'        return true;',
'    else',
'        return false;',
'end if;',
'end;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Please enter the cashflow details to allocate the estimated budget.'
,p_when_button_pressed=>wwv_flow_api.id(128677286965987417)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(128521579776121536)
,p_name=>'New Project DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P11_PROJECT_NEW_YN'
,p_condition_element=>'P11_PROJECT_NEW_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128521773044121538)
,p_event_id=>wwv_flow_api.id(128521579776121536)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_PROJECT_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128521992407121540)
,p_event_id=>wwv_flow_api.id(128521579776121536)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_PROJECT_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128521633083121537)
,p_event_id=>wwv_flow_api.id(128521579776121536)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_PROJECT_NUMBER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128521857964121539)
,p_event_id=>wwv_flow_api.id(128521579776121536)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_PROJECT_NUMBER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(128522699853121547)
,p_name=>'ESTIMATED_BUDGET DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P11_ESTIMATED_BUDGET'
,p_condition_element=>'P11_ESTIMATED_BUDGET'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143066024691754148)
,p_event_id=>wwv_flow_api.id(128522699853121547)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete from CASHFLOW_LINES where SOURCE = ''DP''',
'and REQUEST_ID = :P11_ITEM_ID;'))
,p_attribute_02=>'P11_ITEM_ID'
,p_attribute_03=>'P11_PR_NUMBER'
,p_attribute_04=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143065857769754147)
,p_event_id=>wwv_flow_api.id(128522699853121547)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(8893313198220170)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7919391084999544)
,p_event_id=>wwv_flow_api.id(128522699853121547)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_ESTIMATED_BUDGET_H'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'to_number(replace(nvl(:P11_ESTIMATED_BUDGET,0),'','',''''))'
,p_attribute_07=>'P11_ESTIMATED_BUDGET'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(678746441236368)
,p_event_id=>wwv_flow_api.id(128522699853121547)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_ESTIMATED_BUDGET_BRACKET_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128522732781121548)
,p_event_id=>wwv_flow_api.id(128522699853121547)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_ESTIMATED_BUDGET_BRACKET_ID'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  BRACKET_ID',
'from dp_budget_brackets',
'where to_number(replace(nvl(:P11_ESTIMATED_BUDGET,0),'','','''')) between MIN_VALUE and  MAX_VALUE'))
,p_attribute_07=>'P11_ESTIMATED_BUDGET,P11_ESTIMATED_BUDGET_H'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7919746445999548)
,p_event_id=>wwv_flow_api.id(128522699853121547)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(7919712052999547)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(128676604787987411)
,p_name=>'Rollback DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(128676514268987410)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128676781271987412)
,p_event_id=>wwv_flow_api.id(128676604787987411)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to rollback?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128676822267987413)
,p_event_id=>wwv_flow_api.id(128676604787987411)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete from dp_items_APPROVAL_HISTORY where REQUEST_ID = :P11_ITEM_ID;',
'',
'update dp_items ',
'set REVIEW_STATUS = ''Draft'' , ',
'    APPROVAL_STATUS =  ''Required'' ,',
'    CONTRACT_NO = '''',',
'    DP_PROCUREMENT_METHOD = ''''',
'where item_ID = :P11_ITEM_ID;'))
,p_attribute_02=>'P11_ITEM_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128676991454987414)
,p_event_id=>wwv_flow_api.id(128676604787987411)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Rollback Done;'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128677026144987415)
,p_event_id=>wwv_flow_api.id(128676604787987411)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_PAGE_FROM'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'11'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128677198074987416)
,p_event_id=>wwv_flow_api.id(128676604787987411)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(128921066319697321)
,p_name=>'ESTIMATED_DATE_DEFINE DA'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P11_ESTIMATED_DATE_DEFINE'
,p_condition_element=>'P11_ESTIMATED_DATE_DEFINE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128921103489697322)
,p_event_id=>wwv_flow_api.id(128921066319697321)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_ESTIMATED_DATE,P11_ESTIMATED'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128921445292697325)
,p_event_id=>wwv_flow_api.id(128921066319697321)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_ESTIMATED_DATE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128921322777697324)
,p_event_id=>wwv_flow_api.id(128921066319697321)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_ESTIMATED_DATE,P11_ESTIMATED'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128922492313697335)
,p_event_id=>wwv_flow_api.id(128921066319697321)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_ESTIMATED_QUARTER,P11_ESTIMATED_YEAR'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128922387278697334)
,p_event_id=>wwv_flow_api.id(128921066319697321)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_ESTIMATED_QUARTER,P11_ESTIMATED_YEAR'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128922538152697336)
,p_event_id=>wwv_flow_api.id(128921066319697321)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_ESTIMATED_QUARTER,P11_ESTIMATED_YEAR'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(128922189915697332)
,p_name=>'get Quarter DA'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P11_ESTIMATED_DATE'
,p_condition_element=>'P11_ESTIMATED_DATE'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128922258146697333)
,p_event_id=>wwv_flow_api.id(128922189915697332)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_ESTIMATED'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Q'' || trim(to_char(to_date(:P11_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''Q''))',
'           || ''-'' ||',
'           trim(to_char(to_date(:P11_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''YYYY''))',
'           as xx',
'from dual;'))
,p_attribute_07=>'P11_ESTIMATED_DATE'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(128922766861697338)
,p_name=>'Budget Not Define DA'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P11_ESTIMATED_BUDGET_DEFINE'
,p_condition_element=>'P11_ESTIMATED_BUDGET_DEFINE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128922941144697340)
,p_event_id=>wwv_flow_api.id(128922766861697338)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_ESTIMATED_BUDGET'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128923005609697341)
,p_event_id=>wwv_flow_api.id(128922766861697338)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_ESTIMATED_BUDGET'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(128922857682697339)
,p_event_id=>wwv_flow_api.id(128922766861697338)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_ESTIMATED_BUDGET'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(129034017408007623)
,p_name=>'Dialog Close'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(129032431140007607)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129034106551007624)
,p_event_id=>wwv_flow_api.id(129034017408007623)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(129032531019007608)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(129034251545007625)
,p_name=>'Dialog Close 2'
,p_event_sequence=>80
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(129032531019007608)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(129034362727007626)
,p_event_id=>wwv_flow_api.id(129034251545007625)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(129032531019007608)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(135342740120699609)
,p_name=>'Initiative DA'
,p_event_sequence=>90
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P11_INITIATIVE_NEW_YN'
,p_condition_element=>'P11_INITIATIVE_NEW_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'No'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(135342887080699610)
,p_event_id=>wwv_flow_api.id(135342740120699609)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_INITIATIVE_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(135343039509699612)
,p_event_id=>wwv_flow_api.id(135342740120699609)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_INITIATIVE_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(135343218622699614)
,p_event_id=>wwv_flow_api.id(135342740120699609)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_INITIATIVE_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(135342942556699611)
,p_event_id=>wwv_flow_api.id(135342740120699609)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_INITIATIVE_NEW_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(135343115859699613)
,p_event_id=>wwv_flow_api.id(135342740120699609)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_INITIATIVE_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(135343395446699615)
,p_event_id=>wwv_flow_api.id(135342740120699609)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_INITIATIVE_NEW_NAME'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(676881953236349)
,p_name=>'Close DA'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(676653145236347)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(676965476236350)
,p_event_id=>wwv_flow_api.id(676881953236349)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(87280307085716)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(677115918236351)
,p_name=>'Close2 DA'
,p_event_sequence=>110
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(87280307085716)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(677195494236352)
,p_event_id=>wwv_flow_api.id(677115918236351)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(87280307085716)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7919433422999545)
,p_name=>'Total Project Budget DA'
,p_event_sequence=>140
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P11_TOTAL_PROJECT_BUDGET'
,p_bind_type=>'bind'
,p_bind_event_type=>'focusout'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7919612709999546)
,p_event_id=>wwv_flow_api.id(7919433422999545)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_TOTAL_PROJECT_BUDGET_H'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'to_number(replace(nvl(:P11_TOTAL_PROJECT_BUDGET,0),'','',''''))'
,p_attribute_07=>'P11_TOTAL_PROJECT_BUDGET'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(7922387875999574)
,p_name=>'New Task YN Changes'
,p_event_sequence=>150
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P11_TASK_NEW_YN'
,p_condition_element=>'P11_TASK_NEW_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7922576025999576)
,p_event_id=>wwv_flow_api.id(7922387875999574)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_TASK_NUMBER,P11_EXPENDITURE_TYPE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7923059275999581)
,p_event_id=>wwv_flow_api.id(7922387875999574)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_TASK_NUMBER_NEW,P11_EXPENDITURE_TYPE_NEW'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7922512996999575)
,p_event_id=>wwv_flow_api.id(7922387875999574)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_TASK_NUMBER_NEW,P11_EXPENDITURE_TYPE_NEW'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7922940751999580)
,p_event_id=>wwv_flow_api.id(7922387875999574)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_TASK_NUMBER_NEW,P11_EXPENDITURE_TYPE_NEW'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7922674849999577)
,p_event_id=>wwv_flow_api.id(7922387875999574)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_TASK_NUMBER,P11_EXPENDITURE_TYPE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(7922807695999578)
,p_event_id=>wwv_flow_api.id(7922387875999574)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_TASK_NUMBER,P11_EXPENDITURE_TYPE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(9528732304155846)
,p_name=>'Task Number Changed DA'
,p_event_sequence=>160
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P11_EXPENDITURE_TYPE'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(9528879161155847)
,p_event_id=>wwv_flow_api.id(9528732304155846)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count    number;',
'begin',
'',
'select nvl(count(*),0)',
'into l_count',
'from cashflow_lines',
'where source = ''DP''',
'and request_id = :P11_ITEM_ID;',
'',
'if l_count > 0',
'then',
'        update cashflow_lines',
'        set cost_center = PROJECTS_UTIL.task_cost_center(:P11_PROJECT_NUMBER, :P11_TASK_NUMBER),',
'            BUDGET_GROUB_CODE = PROJECTS_UTIL.task_budget_code(:P11_PROJECT_NUMBER, :P11_TASK_NUMBER),',
'            GL_ACCOUNT = PROJECTS_UTIL.expenditure_type_gl_account(:P11_PROJECT_NUMBER, :P11_TASK_NUMBER, :P11_EXPENDITURE_TYPE),',
'            activity = PROJECTS_UTIL.task_activity(:P11_PROJECT_NUMBER, :P11_TASK_NUMBER),',
'            future1  = PROJECTS_UTIL.task_future1(:P11_PROJECT_NUMBER, :P11_TASK_NUMBER),',
'            future2  = PROJECTS_UTIL.task_future2(:P11_PROJECT_NUMBER, :P11_TASK_NUMBER),',
'            entity_code = ''451'',',
'            task_number = :P11_TASK_NUMBER,',
'            expenditure_type = :P11_EXPENDITURE_TYPE',
'        where source = ''DP''',
'        and request_id = :P11_ITEM_ID;',
'',
'end if;',
'',
'end;'))
,p_attribute_02=>'P11_ITEM_ID,P11_PROJECT_NUMBER,P11_TASK_NUMBER,P11_EXPENDITURE_TYPE'
,p_attribute_03=>'P11_PR_NUMBER'
,p_attribute_04=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(141477952478711161)
,p_name=>'CREATE_PR DA'
,p_event_sequence=>170
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(7930498959110798)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(141477769711711159)
,p_event_id=>wwv_flow_api.id(141477952478711161)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Generating PR request submitted, you will notify once it''s created.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(141477924424711160)
,p_event_id=>wwv_flow_api.id(141477952478711161)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(136447410845457241)
,p_name=>'New'
,p_event_sequence=>180
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(128920054696697311)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(136447264710457240)
,p_event_id=>wwv_flow_api.id(136447410845457241)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(128920054696697311)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(122411795115330879)
,p_name=>'Cancel DA'
,p_event_sequence=>190
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(122411855239330880)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(122411645413330878)
,p_event_id=>wwv_flow_api.id(122411795115330879)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to cancel DP Item &P11_DP_ITEM_CODE., Are you Sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(122411626231330877)
,p_event_id=>wwv_flow_api.id(122411795115330879)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update dp_items',
'set CANCEL_ON = systimestamp ,',
'    CANCELLED_BY =:PERSON_ID ,',
'    REVIEW_STATUS = ''Cancelled'' ,',
'    APPROVAL_STATUS = ''Cancelled'' ,',
'    dp_item_status_id = 7 ,',
'    ESTIMATED_BUDGET = 0 ,',
'    TOTAL_PROJECT_BUDGET = 0',
'where ITEM_ID = :P11_ITEM_ID_H;',
'',
'-- update Cashflow Line',
'update CASHFLOW_LINES',
'set     ALLOCATED_BUDGET = 0,',
'       JAN = 0,',
'       FEB = 0,',
'       MAR = 0,',
'       APR = 0,',
'       MAY = 0,',
'       JUN = 0,',
'       JUL = 0,',
'       AUG = 0,',
'       SEP = 0,',
'       OCT = 0,',
'       NOV = 0,',
'       DEC = 0,',
'       STATUS = '' Cancelled'',',
'       TOTAL_CF_FORMAT = ''0.00''',
'  where SOURCE = ''DP''',
'and REQUEST_ID = :P11_ITEM_ID_H;',
'',
'-- Update Project Status',
'INSERT INTO dp_item_status (',
'    dp_item_id, dp_item_status_id, from_date, order_no) ',
'VALUES ',
'  (:P11_ITEM_ID_H, 7, systimestamp,(select max(nvl(ORDER_NO,1)) + 1',
'                                    from dp_item_status',
'                                    where dp_item_id = :P11_ITEM_ID_H)',
' );',
' ',
' ',
' update dp_item_status',
'set TO_DATE = systimestamp ',
'where dp_item_id = :P11_ITEM_ID_H',
'and order_no = (select max(nvl(ORDER_NO,1))',
'                from dp_item_status',
'                where dp_item_id = :P11_ITEM_ID_H); '))
,p_attribute_02=>'P11_ITEM_ID_H'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(122411478385330876)
,p_event_id=>wwv_flow_api.id(122411795115330879)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'DP Item &P11_DP_ITEM_CODE. Cancelled.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(122411376248330875)
,p_event_id=>wwv_flow_api.id(122411795115330879)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'CANCEL_ITEM'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(511556140416694050)
,p_name=>'Change_procurment_Method DA'
,p_event_sequence=>200
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(511556726615694056)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(511555967725694049)
,p_event_id=>wwv_flow_api.id(511556140416694050)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(128520836736121529)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize DP Item Details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    PROJECT_TITLE,',
'    PR_NUMBER,',
'    PR_GENERATION_STATUS,',
'    DP_ITEM_CODE,',
'    ITEM_ID,',
'    ITEM_ID item_id_h,',
'  --  DP_ITEM_NAME,',
'  --  INITIATIVE_NEW_YN,',
'    INITIATIVE_ID,',
'  --  INITIATIVE_NEW_NAME,',
'    decode(PROJECT_NEW_YN , ''N'' , PROJECT_NUMBER, ''Y'' ,PROJECT_NEW_NAME)	,',
'    PROJECT_NUMBER,',
'    PROJECT_NEW_YN,',
'    PROJECT_NEW_NAME,',
'    PROJECT_DESCRIPTION,',
'    main_category_id,',
'    CATEGORY_ID,',
'    SUB_CATEGORY_ID,',
'    END_USER_ID,',
'    SECTOR_ID,',
'    DEPARTMENT_ID,',
'    COST_CENTER,',
'    DP_ITEM_TYPE_ID,',
'    CONTRACT_NO,',
'    RISK_ID,',
'    PRIORITY_ID,',
'    DP_PROCUREMENT_METHOD,',
'    PLANNING_STATUS,',
'    REVIEW_STATUS,',
'    APPROVAL_STATUS,',
'    to_char(CUTT_OFF_DATE,''dd-Mon-YYYY''),',
'    CREATED_BY,',
'    to_char(CREATED_ON,''DD-MON-YYYY HH:MIPM''),',
'    UPDATED_BY,',
'    to_char(UPDATED_ON,''DD-MON-YYYY HH:MIPM''),',
'    to_char(PROJECT_END_DATE,''DD-MON-YYYY''),',
'    to_char(ESTIMATED_DATE,''DD-MON-YYYY''),',
'    ESTIMATED_YEAR,',
'    ESTIMATED_QUARTER,',
'    trim(to_char(ESTIMATED_BUDGET,''99,999,999,999.99''))     ESTIMATED_BUDGET,',
'    ESTIMATED_BUDGET,',
'    ESTIMATED_BUDGET_BRACKET_ID,',
'    NOTES,',
'    REVIEW_REJECT_REASON,',
'    ESTIMATED_DATE_DEFINE,',
'    DP_SCOPING_ID,',
'    to_char(DP_ITEMS_UTIL.GET_SLA_DATE(DP_ITEMS_UTIL.get_first_day(item_id) , ',
'                                       DP_ITEMS_UTIL.GET_SLA_DAYS(ESTIMATED_BUDGET))',
'            , ''DD-Mon-YYYY'')                                            SLA_DATE,',
'     to_char(DP_ITEMS_UTIL.GET_SLA_DATE2(DP_ITEMS_UTIL.get_first_day(item_id) , ',
'                                       DP_ITEMS_UTIL.GET_SLA_DAYS(ESTIMATED_BUDGET))',
'            , ''DD-Mon-YYYY'')                                            SLA_DATE,',
'    DP_ITEMS_UTIL.GET_SLA_DAYS(ESTIMATED_BUDGET)                        SAL_DAYS,',
'    TOTAL_PROJECT_BUDGET,',
'    trim(to_char(TOTAL_PROJECT_BUDGET,''99,999,999,999.99''))      TOTAL_PROJECT_BUDGET,',
'    TASK_NEW_YN,',
'    TASK_NUMBER,',
'    TASK_NUMBER_NEW,',
'    EXPENDITURE_TYPE,',
'    EXPENDITURE_TYPE_NEW,',
'    TEMPLATE_ID,',
'    DP_ITEM_STATUS_ID,',
'    DP_ITEM_STATUS_ID DP_ITEM_STATUS_ID_H,',
'    to_char(SUBMIT_REVIEW_ON,''DD-MON-YYYY HH:MIPM'')    SUBMIT_REVIEW_ON,',
'    to_char(dct_util.add_bus_days(SUBMIT_REVIEW_ON, DP_ITEMS_UTIL.GET_SLA_DAYS(ESTIMATED_BUDGET)),''dd-MON-yyyy'')  expected_delivery_date',
'INTO',
'    :P11_PROJECT_TITLE,',
'    :P11_PR_NUMBER,',
'    :P11_PR_GENERATION_STATUS,',
'    :P11_DP_ITEM_CODE,',
'    :P11_ITEM_ID,',
'    :P11_ITEM_ID_H,',
'   -- :P11_DP_ITEM_NAME,',
'   -- :P11_INITIATIVE_NEW_YN,',
'    :P11_INITIATIVE_ID,',
'  --  :P11_INITIATIVE_NEW_NAME,',
'    :P11_PROJECT_NUMBER,',
'    :P11_PROJECT_NUMBER_H,',
'    :P11_PROJECT_NEW_YN,',
'    :P11_PROJECT_NEW_NAME,',
'    :P11_PROJECT_DESCRIPTION,',
'    :P11_MAIN_CATEGORY_ID,',
'    :P11_CATEGORY_ID,',
'    :P11_SUB_CATEGORY_ID,',
'    :P11_END_USER_ID,',
'    :P11_SECTOR_ID,',
'    :P11_DEPARTMENT_ID,',
'    :P11_COST_CENTER,',
'    :P11_DP_ITEM_TYPE_ID,',
'    :P11_CONTRACT_NO,',
'    :P11_RISK_ID,',
'    :P11_PRIORITY_ID,',
'    :P11_DP_PROCUREMENT_METHOD,',
'    :P11_PLANNING_STATUS,',
'    :P11_REVIEW_STATUS,',
'    :P11_APPROVAL_STATUS,',
'    :P11_CUTT_OFF_DATE,',
'    :P11_CREATED_BY,',
'    :P11_CREATED_ON,',
'    :P11_UPDATED_BY,',
'    :P11_UPDATED_ON,',
'    :P11_PROJECT_END_DATE,',
'    :P11_ESTIMATED_DATE,',
'    :P11_ESTIMATED_YEAR,',
'    :P11_ESTIMATED_QUARTER,',
'    :P11_ESTIMATED_BUDGET,',
'    :P11_ESTIMATED_BUDGET_H,',
'    :P11_ESTIMATED_BUDGET_BRACKET_ID,',
'    :P11_NOTES,',
'    :P11_REVIEW_REJECT_REASON,',
'    :P11_ESTIMATED_DATE_DEFINE,',
'    :P11_DP_SCOPING_ID,',
'    :P11_SLA_DATE,',
'    :P11_SLA_DATE_AFTER,',
'    :P11_SLA_DAYS,',
'    :P11_TOTAL_PROJECT_BUDGET_H,',
'    :P11_TOTAL_PROJECT_BUDGET,',
'    :P11_TASK_NEW_YN,',
'    :P11_TASK_NUMBER,',
'    :P11_TASK_NUMBER_NEW,',
'    :P11_EXPENDITURE_TYPE,',
'    :P11_EXPENDITURE_TYPE_NEW,',
'    :P11_TEMPLATE_ID,',
'    :P11_DP_ITEM_STATUS_ID,',
'    :P11_DP_ITEM_STATUS_ID_H,',
'    :P11_SUBMIT_REVIEW_ON,',
'    :P11_expected_delivery_date',
'FROM',
'    DP_ITEMS',
'WHERE item_id = nvl(:P11_ITEM_ID  , (SELECT last_number',
'                                          FROM all_sequences',
'                                         WHERE sequence_owner = ''PROD''',
'                                           AND sequence_name = ''DP_ITEMS_SEQ'')',
'                        );',
'exception',
'    when others then null;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(128828950058256810)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_cutt_off_date    Date;',
'l_PLANNING_STATUS    Number;',
'begin',
'l_PLANNING_STATUS := DP_ITEMS_UTIL.GET_ITEM_PLANNING_STATUS(:P11_ITEM_ID , ''U'');',
'UPDATE dp_items',
'SET',
'    ESTIMATED_DATE_DEFINE = :P11_ESTIMATED_DATE_DEFINE,',
'    ESTIMATED_DATE            = to_date(:P11_ESTIMATED_DATE,''dd-Mon-YYYY''),',
'    ESTIMATED_QUARTER         = NVL(trim(to_char(to_date(:P11_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''Q'')) , :P11_ESTIMATED_QUARTER),',
'    ESTIMATED_YEAR            = NVL(trim(to_char(to_date(:P11_ESTIMATED_DATE, ''dd-Mon-YYYY'' ) , ''YYYY'')),:P11_ESTIMATED_YEAR),',
'    ESTIMATED_BUDGET_DEFINE = :P11_ESTIMATED_BUDGET_DEFINE,',
'    ESTIMATED_BUDGET            = :P11_ESTIMATED_BUDGET_H,',
'    ESTIMATED_BUDGET_BRACKET_ID = decode(:P11_ESTIMATED_BUDGET_H, Null,:P11_ESTIMATED_BUDGET_BRACKET_ID,',
'                                            (select  BRACKET_ID',
'                                            from dp_budget_brackets',
'                                            where :P11_ESTIMATED_BUDGET_H between MIN_VALUE and  MAX_VALUE)),',
'    DP_PROCUREMENT_METHOD       = :P11_DP_PROCUREMENT_METHOD,',
'    DP_ITEM_TYPE_ID             = :P11_DP_ITEM_TYPE_ID,',
'    RISK_ID                     = :P11_RISK_ID,',
'    PRIORITY_ID                 = :P11_PRIORITY_ID,',
'    NOTES                       = :P11_NOTES,',
'    --',
'    cutt_off_date               = dp_items_util.get_current_cuttoff_date(to_number(:CURRENT_YEAR)),',
'    PLANNING_STATUS             = l_PLANNING_STATUS,',
'    TOTAL_PROJECT_BUDGET        = :P11_TOTAL_PROJECT_BUDGET_H,',
'    TASK_NEW_YN                 = :P11_TASK_NEW_YN,',
'    TASK_NUMBER                 = :P11_TASK_NUMBER  , ',
'    TASK_NUMBER_NEW             = :P11_TASK_NUMBER_NEW,',
'    EXPENDITURE_TYPE            = :P11_EXPENDITURE_TYPE,',
'    EXPENDITURE_TYPE_NEW        = :P11_EXPENDITURE_TYPE_NEW',
'WHERE',
'    item_id = :P11_ITEM_ID;',
'end ;'))
,p_process_error_message=>'Changes not saved, Contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'UPDATE,Submit_REVIEW,New_document'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_process_success_message=>'Changes saved successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(11209908649664356)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set SLA'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count    number;',
'begin',
'select nvl(count(*),0)',
'            into l_count',
'            from dp_items_sla_fact',
'            where item_id = :P11_ITEM_ID;',
'',
'            if l_count > 0 then ',
'                        update dp_items_sla_fact sl SET sl.sla_date = DP_ITEMS_UTIL.GET_SLA_DATE(DP_ITEMS_UTIL.get_first_day(:P11_ITEM_ID) , ',
'                                                                                        DP_ITEMS_UTIL.GET_SLA_DAYS(:P11_ESTIMATED_BUDGET_H))',
'                                                    , sl.sla_days = DP_ITEMS_UTIL.GET_SLA_DAYS(:P11_ESTIMATED_BUDGET_H)',
'                            where sl.item_id = :P11_ITEM_ID;',
'                else',
'                    insert into dp_items_sla_fact (item_id, sla_date, sla_days)',
'                                    values ',
'                                        (:P11_ITEM_ID,',
'                                            DP_ITEMS_UTIL.GET_SLA_DATE(DP_ITEMS_UTIL.get_first_day(:P11_ITEM_ID) , ',
'                                                                                        DP_ITEMS_UTIL.GET_SLA_DAYS(:P11_ESTIMATED_BUDGET_H)),',
'                                            DP_ITEMS_UTIL.GET_SLA_DAYS(:P11_ESTIMATED_BUDGET_H)',
'                                        );',
'            end if;',
'            ',
'      end ;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
':REQUEST = ''UPDATE'' and :P11_ESTIMATED_BUDGET_H is not null and',
'    (:P11_ESTIMATED_DATE is not null OR(:P11_ESTIMATED_QUARTER is not null and',
'                                               :P11_ESTIMATED_YEAR   is not null) )'))
,p_process_when_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(141322782187938502)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'set Hidden Items process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
':P28_SCOPE_ID := :P11_DP_SCOPING_ID ;',
':P28_TEMPLATE_ID := :P11_TEMPLATE_ID;',
':P28_DP_ITEM_ID := :P11_ITEM_ID;',
'',
':P29_SCOPE_ID := :P11_DP_SCOPING_ID ;',
':P29_TEMPLATE_ID := :P11_TEMPLATE_ID;',
':P29_ITEM_ID := :P11_ITEM_ID;',
'',
':P30_SCOPE_ID := :P11_DP_SCOPING_ID ;',
':P30_TEMPLATE_ID := :P11_TEMPLATE_ID;',
':P30_ITEM_ID := :P11_ITEM_ID;',
'',
'',
':P31_SCOPE_ID := :P11_DP_SCOPING_ID ;',
':P31_TEMPLATE_ID := :P11_TEMPLATE_ID;',
':P31_ITEM_ID := :P11_ITEM_ID;',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(136202001465004041)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3047819345104342)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Create Version'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'L_ITEM_ID           Number;',
'l_COUNT_YEAR        Number;',
'l_COUNT_ITEM        Number;',
'--',
'l_INITIATIVE_ID     Number;',
'l_PROJECT_NUMBER    Number;',
'l_CATEGORY_ID       Number;',
'l_SUB_CATEGORY_ID   Number;',
'l_cost_center       Number;',
'Begin',
'',
' SELECT DP_ITEMS_SEQ.nextval',
'into L_ITEM_ID',
'FROM all_sequences',
' WHERE sequence_owner = ''PROD''',
'   AND sequence_name = ''DP_ITEMS_SEQ'';',
'',
'select user_details.get_cost_center(:PERSON_ID)',
'into l_cost_center',
'from dual;',
'',
'select NVL(Max(COUNT_YEAR),0)+1  ',
'into l_COUNT_YEAR',
'from dp_items',
'where dp_year = NV(''CURRENT_YEAR'');',
'',
'select INITIATIVE_ID  , PROJECT_NUMBER , CATEGORY_ID , SUB_CATEGORY_ID',
'into   l_INITIATIVE_ID  , l_PROJECT_NUMBER , l_CATEGORY_ID , l_SUB_CATEGORY_ID',
'from dp_items',
'where item_id = :P11_ITEM_ID;',
'',
'select NVL(Max(COUNT_ITEM),0)+1  ',
'into l_COUNT_ITEM',
'from dp_items',
'where dp_year = NV(''CURRENT_YEAR'')',
'and INITIATIVE_ID = l_INITIATIVE_ID',
'and project_number = l_PROJECT_NUMBER',
'and category_id = l_CATEGORY_ID',
'and SUB_CATEGORY_ID = l_SUB_CATEGORY_ID;',
'',
'INSERT INTO dp_items (',
'    initiative_id,',
'    project_number,',
'    project_new_yn,',
'    project_new_name,',
'    project_description,',
'    category_id,',
'    sub_category_id,',
'    estimated_date,',
'    estimated_month,',
'    estimated_year,',
'    estimated_quarter,',
'    end_user_id,',
'    sector_id,',
'    department_id,',
'    dp_item_type_id,',
'    risk_id,',
'    priority_id,',
'    dp_procurement_method,',
'    estimated_budget,',
'    estimated_budget_bracket_id,',
'    planning_status,',
'    review_status,',
'    approval_status,',
'    cutt_off_date,',
'    notes,',
'    cost_center,',
'    dp_item_name,',
'    count_year,',
'    count_item,',
'    dp_year,',
'    estimated_date_define,',
'    estimated_budget_define,',
'    initiative_new_yn,',
'    initiative_new_name,',
'    dp_item_code ,',
'    dp_scoping_id,',
'    main_category_id,',
'    contract_no',
') Select ',
'    initiative_id,',
'    project_number,',
'    project_new_yn,',
'    project_new_name,',
'    project_description,',
'    category_id,',
'    sub_category_id,',
'    estimated_date,',
'    estimated_month,',
'    estimated_year,',
'    estimated_quarter,',
'    end_user_id,',
'    sector_id,',
'    department_id,',
'    dp_item_type_id,',
'    risk_id,',
'    priority_id,',
'    dp_procurement_method,',
'    estimated_budget,',
'    estimated_budget_bracket_id,',
'    DP_ITEMS_UTIL.GET_ITEM_PLANNING_STATUS(:P11_ITEM_ID , ''I'') ,     --- planning_status,',
'    ''Draft'',           --  review_status,',
'    ''Required'',             -- approval_status,',
'    dp_items_util.get_current_cuttoff_date(to_number(:CURRENT_YEAR))    ,   --cutt_off_date,',
'    notes,',
'    cost_center,',
'    dp_item_name,',
'    count_year,',
'    l_COUNT_ITEM,',
'    NV(''CURRENT_YEAR''),',
'    estimated_date_define,',
'    estimated_budget_define,',
'    initiative_new_yn,',
'    initiative_new_name,',
'    dp_item_code || ''- V1'',',
'    Null,      --  dp_scoping_id,',
'    main_category_id,',
'    Null        -- contract_no',
'from dp_items',
'where item_id = :P11_ITEM_ID;',
'',
'',
'--',
'-- insert category role',
'if DP_ITEMS_UTIL.PBP_COUNT_BY_DP_CATEGORY_ID(L_SUB_CATEGORY_ID) > 0',
'then ',
'INSERT INTO dp_item_roles (item_id, role_id, person_id)',
'select L_ITEM_ID ,ROLE_ID, PERSON_ID ',
'from dp_item_category_roles',
'where CATEGORY_ID = L_SUB_CATEGORY_ID',
'and status = ''A''',
'and sysdate between nvl(START_DATE, sysdate - 10) and nvl(END_DATE , sysdate + 10) ;',
'',
'else',
'    -- insert PbP from cost center',
'    INSERT INTO dp_item_roles (item_id, role_id, person_id)',
'        select L_ITEM_ID ,108, PERSON_ID ',
'        from cost_centers_fbp',
'        where COST_CENTER = l_cost_center',
'        and status = ''A''',
'        and sysdate between nvl(START_DATE, sysdate - 10) and nvl(END_DATE , sysdate + 10) ',
'        and BP_TYPE = ''PBP'';',
'End if;        ',
'',
'-- insert finance BP',
'for emp in (select PERSON_ID ',
'            from cost_centers_fbp',
'            where COST_CENTER = l_cost_center ',
'            and STATUS = ''A''',
'            and sysdate between nvl(START_DATE , sysdate - 10) and nvl(END_DATE , sysdate + 10)',
'            and BP_TYPE = ''FBP'')',
'    loop',
'        INSERT INTO dp_item_roles (item_id, role_id, person_id)',
'        values (L_ITEM_ID , 227 , emp.person_id);',
'    end loop;',
'',
'-- Insert Participants',
'INSERT INTO dp_item_participants (item_id, person_id, role_id, status, start_date) ',
'VALUES (L_ITEM_ID, :PERSON_ID,',
'    241,    -- ROLE_id FOR OWNER (lOOKUP:DP_ITEM_PARTICIPANT_ROL)',
'    ''A'',sysdate);',
'',
'-- Copy Documents',
'INSERT INTO dp_items_documents (',
'    row_version_number,',
'    dp_items_id,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    file_comments,',
'    tags',
') Select',
'        row_version_number,',
'    dp_items_id,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    file_comments,',
'    tags',
'from dp_items_documents',
'where dp_items_id = :P11_ITEM_ID;',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(3047635517104341)
);
wwv_flow_api.component_end;
end;
/
