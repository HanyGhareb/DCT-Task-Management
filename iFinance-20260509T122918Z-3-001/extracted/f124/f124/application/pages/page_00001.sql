prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'Demand Planning'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240314085900'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(515377055446329497)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11209990427664357)
,p_plug_name=>'Late Demand Planning Items'
,p_icon_css_classes=>'fa-clock-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent9:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>70
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select dp.ITEM_ID,',
'       INITIATIVE_ID,',
'       PROJECT_NUMBER,',
'       PROJECT_NEW_YN,',
'       decode(PROJECT_NEW_YN , ''Y'', PROJECT_NEW_NAME , PROJECT_NUMBER) Project,',
'       PROJECT_NEW_NAME,',
'       PROJECT_DESCRIPTION,',
'       CATEGORY_ID,',
'       SUB_CATEGORY_ID,',
'       ESTIMATED_DATE,',
'       ESTIMATED_MONTH,',
'       ESTIMATED_YEAR,',
'       ESTIMATED_QUARTER,',
'       END_USER_ID,',
'       END_USER_ID    END_USER_ID_H,',
'       SECTOR_ID,',
'       DEPARTMENT_ID,',
'       DP_ITEM_TYPE_ID,',
'       RISK_ID,',
'       PRIORITY_ID,',
'       DP_PROCUREMENT_METHOD,',
'       ESTIMATED_BUDGET,',
'       ESTIMATED_BUDGET_BRACKET_ID,',
'       PLANNING_STATUS,',
'       REVIEW_STATUS,',
'       APPROVAL_STATUS,',
'       CUTT_OFF_DATE,',
'       NOTES,',
'       dp.CREATED_BY,',
'       dp.CREATED_ON,',
'       dp.UPDATED_BY,',
'       dp.UPDATED_ON,',
'       COST_CENTER,',
'       REJECTED_BY,',
'       REVIEW_REJECTED_BY,',
'       REVIEW_REJECT_ON,',
'       REJECT_ON,',
'       REVIEW_REJECT_REASON,',
'       REJECT_REASON,',
'       FINAL_APPROVE_ON,',
'       REVIEW_APPROVE_ON,',
'       REVIEW_APPROVE_BY,',
'       FINAL_APPROVE_BY,',
'       SUBMIT_APPROVAL_ON,',
'       SUBMIT_REVIEW_ON,',
'       SUBMIT_REVIEW_BY,',
'       SUBMIT_APPROVAL_BY,',
'       DP_ITEM_NAME,',
'       COUNT_YEAR,',
'       COUNT_ITEM,',
'       DP_YEAR,',
'       CANCEL_ON,',
'       CANCELLED_BY,',
'       CANCEL_REASON,',
'       ESTIMATED_DATE_DEFINE,',
'       ESTIMATED_BUDGET_DEFINE,',
'       INITIATIVE_NEW_YN,',
'       INITIATIVE_NEW_NAME,',
'       DP_ITEM_CODE,',
'       DP_SCOPING_ID,',
'       MAIN_CATEGORY_ID,',
'       CONTRACT_NO,',
'       TOTAL_PROJECT_BUDGET,',
'       TASK_NUMBER,',
'       TASK_NUMBER_NEW,',
'       EXPENDITURE_TYPE,',
'       EXPENDITURE_TYPE_NEW,',
'       TASK_NEW_YN,',
'       sl.sla_date  due_date,',
'       trunc(sl.sla_date - sysdate )  Due_after,',
'       sl.sla_days  ,',
'       ''<span aria-hidden="true" class="fa fa-envelope-o fa-2x fam-information fam-is-info"></span>'' Reminder',
'  from DP_ITEMS dp, dp_items_sla_fact sl',
'  where dp.item_id = sl.item_id (+)',
'  and REVIEW_STATUS = ''Reviewed''',
'  and APPROVAL_STATUS = ''Approved''',
' and trunc((sysdate - sl.sla_date)) between 0 and 99999',
'  order by trunc(sysdate - sl.sla_date) desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':IS_DP_ADMIN = ''Y'' and 1 =2'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'DP Items'
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
 p_id=>wwv_flow_api.id(11210061477664358)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ITEM_ID,P11_PAGE_FROM,P11_ITEM_ID_H:#ITEM_ID#,1,#ITEM_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>155412230451720322
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11210166990664359)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Item ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11210285858664360)
,p_db_column_name=>'CATEGORY_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Main Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449582832098954)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11210344768664361)
,p_db_column_name=>'SUB_CATEGORY_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Sub Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449760929095476)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11210436086664362)
,p_db_column_name=>'ESTIMATED_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Estimated Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11210630514664363)
,p_db_column_name=>'ESTIMATED_MONTH'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Estimated Month'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11210638208664364)
,p_db_column_name=>'ESTIMATED_YEAR'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Estimated Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11210765270664365)
,p_db_column_name=>'ESTIMATED_QUARTER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Estimated Quarter'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11210924938664366)
,p_db_column_name=>'END_USER_ID'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'End User'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11210959173664367)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128342316999489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11211122488664368)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341292413489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11211162931664369)
,p_db_column_name=>'DP_ITEM_TYPE_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'DP Item Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128416904318325983)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11211309948664370)
,p_db_column_name=>'RISK_ID'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Risk'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128420411111243936)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11211384335664371)
,p_db_column_name=>'PRIORITY_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Priority'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341720324489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11211529754664372)
,p_db_column_name=>'DP_PROCUREMENT_METHOD'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Procurement Method'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128420668962241785)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11211599041664373)
,p_db_column_name=>'ESTIMATED_BUDGET'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Estimated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11211649165664374)
,p_db_column_name=>'ESTIMATED_BUDGET_BRACKET_ID'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Estimated Budget Bracket'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11211743896664375)
,p_db_column_name=>'PLANNING_STATUS'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Planning Status'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128420883056239409)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11211904085664376)
,p_db_column_name=>'REVIEW_STATUS'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Review Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11211945739664377)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11212110764664378)
,p_db_column_name=>'CUTT_OFF_DATE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Cutt-Off Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11212187459664379)
,p_db_column_name=>'NOTES'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11212278275664380)
,p_db_column_name=>'COUNT_YEAR'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Count Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11212349130664381)
,p_db_column_name=>'COUNT_ITEM'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Count Item'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11212523594664382)
,p_db_column_name=>'DP_YEAR'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Planning Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11212554029664383)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11212710039664384)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11212784295664385)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11212844084664386)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11380950555506537)
,p_db_column_name=>'ESTIMATED_DATE_DEFINE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Estimated Date Define ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11381128196506538)
,p_db_column_name=>'ESTIMATED_BUDGET_DEFINE'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Estimated Budget Define ?'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11381206575506539)
,p_db_column_name=>'INITIATIVE_NEW_YN'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'New Initiative ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11381274913506540)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'New Initiative Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11381335617506541)
,p_db_column_name=>'DP_ITEM_CODE'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'DP Item Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11381476377506542)
,p_db_column_name=>'DP_SCOPING_ID'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Dp Scoping Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11381565175506543)
,p_db_column_name=>'MAIN_CATEGORY_ID'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Main Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(128449582832098954)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11381650605506544)
,p_db_column_name=>'CONTRACT_NO'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Contract No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11381788353506545)
,p_db_column_name=>'TOTAL_PROJECT_BUDGET'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Total Project Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11381850861506546)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11382011282506547)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'New Task'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11382055126506548)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11382195760506549)
,p_db_column_name=>'EXPENDITURE_TYPE_NEW'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'New Expenditure Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11382282430506550)
,p_db_column_name=>'TASK_NEW_YN'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Task New ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11382350907506551)
,p_db_column_name=>'PROJECT'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11382526783506552)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11382608020506553)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11382669597506554)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11382802429506555)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11382892896506556)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11382992054506557)
,p_db_column_name=>'REVIEW_REJECTED_BY'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Review Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11383059705506558)
,p_db_column_name=>'REVIEW_REJECT_ON'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Review Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11383220721506559)
,p_db_column_name=>'REJECT_ON'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11383302987506560)
,p_db_column_name=>'REVIEW_REJECT_REASON'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Review Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11383332220506561)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11383518142506562)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11383531330506563)
,p_db_column_name=>'REVIEW_APPROVE_ON'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'Review Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11383693348506564)
,p_db_column_name=>'REVIEW_APPROVE_BY'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Review Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11383760242506565)
,p_db_column_name=>'FINAL_APPROVE_BY'
,p_display_order=>570
,p_column_identifier=>'BE'
,p_column_label=>'Final Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11383927979506566)
,p_db_column_name=>'SUBMIT_APPROVAL_ON'
,p_display_order=>580
,p_column_identifier=>'BF'
,p_column_label=>'Submit Approval On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11383936311506567)
,p_db_column_name=>'SUBMIT_REVIEW_ON'
,p_display_order=>590
,p_column_identifier=>'BG'
,p_column_label=>'Submit Review On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11384082092506568)
,p_db_column_name=>'SUBMIT_REVIEW_BY'
,p_display_order=>600
,p_column_identifier=>'BH'
,p_column_label=>'Submit Review By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11384158040506569)
,p_db_column_name=>'SUBMIT_APPROVAL_BY'
,p_display_order=>610
,p_column_identifier=>'BI'
,p_column_label=>'Submit Approval By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11384299666506570)
,p_db_column_name=>'DP_ITEM_NAME'
,p_display_order=>620
,p_column_identifier=>'BJ'
,p_column_label=>'Demand Planning Item Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11384414056506571)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>630
,p_column_identifier=>'BK'
,p_column_label=>'Initiative'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128335626861489802)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11384444714506572)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>640
,p_column_identifier=>'BL'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11384563089506573)
,p_db_column_name=>'PROJECT_NEW_YN'
,p_display_order=>650
,p_column_identifier=>'BM'
,p_column_label=>'Project New ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11384644527506574)
,p_db_column_name=>'PROJECT_NEW_NAME'
,p_display_order=>660
,p_column_identifier=>'BN'
,p_column_label=>'New Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11384778693506575)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>670
,p_column_identifier=>'BO'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11384905602506576)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>680
,p_column_identifier=>'BP'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11384985691506577)
,p_db_column_name=>'DUE_AFTER'
,p_display_order=>690
,p_column_identifier=>'BQ'
,p_column_label=>'Late Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11385103305506578)
,p_db_column_name=>'SLA_DAYS'
,p_display_order=>700
,p_column_identifier=>'BR'
,p_column_label=>'SLA Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11479671930932251)
,p_db_column_name=>'REMINDER'
,p_display_order=>710
,p_column_identifier=>'BS'
,p_column_label=>'Reminder'
,p_column_link=>'f?p=&APP_ID.:75:&SESSION.::&DEBUG.:75:P75_ITEM_ID,P75_PERSON_ID,P75_BUSINESS_OWNER:#ITEM_ID#,#END_USER_ID_H#,#END_USER_ID#'
,p_column_linktext=>'#REMINDER#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11481124961932265)
,p_db_column_name=>'END_USER_ID_H'
,p_display_order=>720
,p_column_identifier=>'BT'
,p_column_label=>'End User Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(11406462453512909)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1556087'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DP_ITEM_CODE:END_USER_ID:SECTOR_ID:ESTIMATED_BUDGET:DUE_DATE:DUE_AFTER:SLA_DAYS::REMINDER:END_USER_ID_H'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11385210078506579)
,p_plug_name=>'Risk Demand Planning Items'
,p_icon_css_classes=>'fa-clock-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent9:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select dp.ITEM_ID,',
'       INITIATIVE_ID,',
'       PROJECT_NUMBER,',
'       PROJECT_NEW_YN,',
'       decode(PROJECT_NEW_YN , ''Y'', PROJECT_NEW_NAME , PROJECT_NUMBER) Project,',
'       PROJECT_NEW_NAME,',
'       PROJECT_DESCRIPTION,',
'       CATEGORY_ID,',
'       SUB_CATEGORY_ID,',
'       ESTIMATED_DATE,',
'       ESTIMATED_MONTH,',
'       ESTIMATED_YEAR,',
'       ESTIMATED_QUARTER,',
'       END_USER_ID,',
'       SECTOR_ID,',
'       DEPARTMENT_ID,',
'       DP_ITEM_TYPE_ID,',
'       RISK_ID,',
'       PRIORITY_ID,',
'       DP_PROCUREMENT_METHOD,',
'       ESTIMATED_BUDGET,',
'       ESTIMATED_BUDGET_BRACKET_ID,',
'       PLANNING_STATUS,',
'       REVIEW_STATUS,',
'       APPROVAL_STATUS,',
'       CUTT_OFF_DATE,',
'       NOTES,',
'       dp.CREATED_BY,',
'       dp.CREATED_ON,',
'       dp.UPDATED_BY,',
'       dp.UPDATED_ON,',
'       COST_CENTER,',
'       REJECTED_BY,',
'       REVIEW_REJECTED_BY,',
'       REVIEW_REJECT_ON,',
'       REJECT_ON,',
'       REVIEW_REJECT_REASON,',
'       REJECT_REASON,',
'       FINAL_APPROVE_ON,',
'       REVIEW_APPROVE_ON,',
'       REVIEW_APPROVE_BY,',
'       FINAL_APPROVE_BY,',
'       SUBMIT_APPROVAL_ON,',
'       SUBMIT_REVIEW_ON,',
'       SUBMIT_REVIEW_BY,',
'       SUBMIT_APPROVAL_BY,',
'       DP_ITEM_NAME,',
'       COUNT_YEAR,',
'       COUNT_ITEM,',
'       DP_YEAR,',
'       CANCEL_ON,',
'       CANCELLED_BY,',
'       CANCEL_REASON,',
'       ESTIMATED_DATE_DEFINE,',
'       ESTIMATED_BUDGET_DEFINE,',
'       INITIATIVE_NEW_YN,',
'       INITIATIVE_NEW_NAME,',
'       DP_ITEM_CODE,',
'       DP_SCOPING_ID,',
'       MAIN_CATEGORY_ID,',
'       CONTRACT_NO,',
'       TOTAL_PROJECT_BUDGET,',
'       TASK_NUMBER,',
'       TASK_NUMBER_NEW,',
'       EXPENDITURE_TYPE,',
'       EXPENDITURE_TYPE_NEW,',
'       TASK_NEW_YN,',
'       sl.sla_date  due_date,',
'       trunc(sl.sla_date - sysdate )  Due_after,',
'       sl.sla_days  ',
'  from DP_ITEMS dp, dp_items_sla_fact sl',
'  where dp.item_id = sl.item_id (+)',
'  and REVIEW_STATUS = ''Reviewed''',
'  and APPROVAL_STATUS = ''Approved''',
'  and trunc((sl.sla_date - sysdate)) between  0 and 7',
'  order by trunc(sysdate - sl.sla_date) desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':IS_DP_ADMIN = ''Y'' and 1 =2'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'DP Items'
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
 p_id=>wwv_flow_api.id(11385304475506580)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ITEM_ID,P11_PAGE_FROM,P11_ITEM_ID_H:#ITEM_ID#,1,#ITEM_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>155587473449562544
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
 p_id=>wwv_flow_api.id(11385356927506581)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Item ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11385490059506582)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11385562119506583)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11385684627506584)
,p_db_column_name=>'ESTIMATED_DATE_DEFINE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Estimated Date Define ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11385771507506585)
,p_db_column_name=>'ESTIMATED_BUDGET_DEFINE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Estimated Budget Define ?'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11385874488506586)
,p_db_column_name=>'INITIATIVE_NEW_YN'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'New Initiative ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11473323830932237)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'New Initiative Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11473397134932238)
,p_db_column_name=>'DP_ITEM_CODE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'DP Item Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11473529729932239)
,p_db_column_name=>'DP_SCOPING_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Dp Scoping Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11473580160932240)
,p_db_column_name=>'MAIN_CATEGORY_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Main Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(128449582832098954)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11473700334932241)
,p_db_column_name=>'CONTRACT_NO'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Contract No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11473762315932242)
,p_db_column_name=>'TOTAL_PROJECT_BUDGET'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Total Project Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11473864416932243)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11473993900932244)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'New Task'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11474100605932245)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11474133681932246)
,p_db_column_name=>'EXPENDITURE_TYPE_NEW'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'New Expenditure Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11474231448932247)
,p_db_column_name=>'TASK_NEW_YN'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Task New ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11474382547932248)
,p_db_column_name=>'PROJECT'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11474487496932249)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11474548124932250)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11474718203932251)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11474830394932252)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11474860855932253)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11475012424932254)
,p_db_column_name=>'REVIEW_REJECTED_BY'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Review Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11475071670932255)
,p_db_column_name=>'REVIEW_REJECT_ON'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Review Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11475144669932256)
,p_db_column_name=>'REJECT_ON'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11475312861932257)
,p_db_column_name=>'REVIEW_REJECT_REASON'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Review Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11475356863932258)
,p_db_column_name=>'CATEGORY_ID'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Main Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449582832098954)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11475459405932259)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11475558227932260)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11475688115932261)
,p_db_column_name=>'REVIEW_APPROVE_ON'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Review Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11475756584932262)
,p_db_column_name=>'REVIEW_APPROVE_BY'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Review Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11475909231932263)
,p_db_column_name=>'FINAL_APPROVE_BY'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Final Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11475958836932264)
,p_db_column_name=>'SUBMIT_APPROVAL_ON'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Submit Approval On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11476077298932265)
,p_db_column_name=>'SUBMIT_REVIEW_ON'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Submit Review On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11476190514932266)
,p_db_column_name=>'SUBMIT_REVIEW_BY'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Submit Review By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11476268063932267)
,p_db_column_name=>'SUBMIT_APPROVAL_BY'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Submit Approval By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11476392635932268)
,p_db_column_name=>'DP_ITEM_NAME'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Demand Planning Item Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11476521333932269)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Initiative'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128335626861489802)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11476627672932270)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11476647986932271)
,p_db_column_name=>'PROJECT_NEW_YN'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Project New ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11476764745932272)
,p_db_column_name=>'PROJECT_NEW_NAME'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'New Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11476909639932273)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11476957821932274)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11477118853932275)
,p_db_column_name=>'DUE_AFTER'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Late Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11477201627932276)
,p_db_column_name=>'SLA_DAYS'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'SLA Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11477246962932277)
,p_db_column_name=>'SUB_CATEGORY_ID'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Sub Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449760929095476)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11477379096932278)
,p_db_column_name=>'ESTIMATED_DATE'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Estimated Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11477503436932279)
,p_db_column_name=>'ESTIMATED_MONTH'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Estimated Month'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11477625407932280)
,p_db_column_name=>'ESTIMATED_YEAR'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Estimated Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11477668131932281)
,p_db_column_name=>'ESTIMATED_QUARTER'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Estimated Quarter'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11477738010932282)
,p_db_column_name=>'END_USER_ID'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'End User'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11477842705932283)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128342316999489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11477960674932284)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341292413489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11478072097932285)
,p_db_column_name=>'DP_ITEM_TYPE_ID'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'DP Item Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128416904318325983)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11478168512932286)
,p_db_column_name=>'RISK_ID'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Risk'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128420411111243936)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11478309457932237)
,p_db_column_name=>'PRIORITY_ID'
,p_display_order=>570
,p_column_identifier=>'BE'
,p_column_label=>'Priority'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341720324489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11478333817932238)
,p_db_column_name=>'DP_PROCUREMENT_METHOD'
,p_display_order=>580
,p_column_identifier=>'BF'
,p_column_label=>'Procurement Method'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128420668962241785)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11478472981932239)
,p_db_column_name=>'ESTIMATED_BUDGET'
,p_display_order=>590
,p_column_identifier=>'BG'
,p_column_label=>'Estimated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11478587747932240)
,p_db_column_name=>'ESTIMATED_BUDGET_BRACKET_ID'
,p_display_order=>600
,p_column_identifier=>'BH'
,p_column_label=>'Estimated Budget Bracket'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11478638908932241)
,p_db_column_name=>'PLANNING_STATUS'
,p_display_order=>610
,p_column_identifier=>'BI'
,p_column_label=>'Planning Status'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128420883056239409)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11478793000932242)
,p_db_column_name=>'REVIEW_STATUS'
,p_display_order=>620
,p_column_identifier=>'BJ'
,p_column_label=>'Review Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11478908123932243)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>630
,p_column_identifier=>'BK'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11478937896932244)
,p_db_column_name=>'CUTT_OFF_DATE'
,p_display_order=>640
,p_column_identifier=>'BL'
,p_column_label=>'Cutt-Off Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11479065422932245)
,p_db_column_name=>'NOTES'
,p_display_order=>650
,p_column_identifier=>'BM'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11479194523932246)
,p_db_column_name=>'COUNT_YEAR'
,p_display_order=>660
,p_column_identifier=>'BN'
,p_column_label=>'Count Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11479239334932247)
,p_db_column_name=>'COUNT_ITEM'
,p_display_order=>670
,p_column_identifier=>'BO'
,p_column_label=>'Count Item'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11479394779932248)
,p_db_column_name=>'DP_YEAR'
,p_display_order=>680
,p_column_identifier=>'BP'
,p_column_label=>'Planning Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11479450958932249)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>690
,p_column_identifier=>'BQ'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11479625224932250)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>700
,p_column_identifier=>'BR'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(11505021072941969)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1557072'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DP_ITEM_CODE:END_USER_ID:SECTOR_ID:ESTIMATED_BUDGET:DUE_DATE:DUE_AFTER:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11482492614932279)
,p_plug_name=>'Monitor DP Items requests'
,p_icon_css_classes=>'fa-pie-chart-65'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':IS_DP_ADMIN = ''Y'' or :IS_IFINANCE_ADMIN = ''Y'' OR :IS_VIEW_ALL_DP_ITEMS > ''Y'' or  :Person_id in ( 128179 , 1646672)'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(122411222519330873)
,p_plug_name=>'Projects Status'
,p_parent_plug_id=>wwv_flow_api.id(11482492614932279)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(122411121400330872)
,p_region_id=>wwv_flow_api.id(122411222519330873)
,p_chart_type=>'bar'
,p_height=>'250'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>false
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'off'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(122410945714330871)
,p_chart_id=>wwv_flow_api.id(122411121400330872)
,p_seq=>10
,p_name=>'Projects Status'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select name ,dp_item_status_id, count (item_id)',
'    , apex_util.prepare_url( ''f?p=''||:APP_ID||'':77:''||:APP_SESSION||''::NO::P77_SHOW_REGION,P77_DP_ITEM_STATUS:''|| ''5,'' || dp_item_status_id  ) as link',
'from(',
'select DP_ITEMS_UTIL.get_dp_item_status_name(dp_item_status_id) NAME, dp_item_status_id ,item_id ',
'from dp_items',
'where DP_YEAR = :P1_YEAR',
'    )',
'group by name,dp_item_status_id'))
,p_ajax_items_to_submit=>'P1_YEAR'
,p_items_value_column_name=>'COUNT(ITEM_ID)'
,p_items_label_column_name=>'NAME'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideBarEdge'
,p_link_target=>'f?p=&APP_ID.:77:&SESSION.::&DEBUG.::P77_SHOW_REGION,P77_DP_ITEM_STATUS:5,&DP_ITEM_STATUS_ID.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(122410742296330869)
,p_chart_id=>wwv_flow_api.id(122411121400330872)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'off'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(122410889448330870)
,p_chart_id=>wwv_flow_api.id(122411121400330872)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11482552839932280)
,p_plug_name=>'Overview'
,p_parent_plug_id=>wwv_flow_api.id(11482492614932279)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- get total',
'select ''Total Count'' Status ',
'        ,nvl(count(dp.item_id),0) total_count',
'        , trim(to_char(SUM(dp.estimated_budget),''99,999,999,999,999.99'')) || '' AED'' total_budget',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':77:''||:APP_SESSION||''::NO::P77_SHOW_REGION:''|| ''1''  ) as link',
'from dp_items dp, dp_items_sla_fact sla',
'where dp.dp_year = :P1_YEAR',
'and dp.item_id = sla.item_id (+)',
'group by ''Total Count'', apex_util.prepare_url( ''f?p=''||:APP_ID||'':77:''||:APP_SESSION||''::NO::P77_SHOW_REGION:''|| ''1'' ) ',
'union all',
'-- get On Risk',
'select ''On Risk'' Status ',
'        ,nvl(count(dp.item_id),0) total_count',
'        , trim(to_char(SUM(dp.estimated_budget),''99,999,999,999,999.99'')) || '' AED'' total_budget',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':77:''||:APP_SESSION||''::NO::P77_SHOW_REGION:''|| ''2''  ) as link',
'from dp_items dp, dp_items_sla_fact sla',
'where dp.dp_year = :P1_YEAR ',
'and dp.item_id = sla.item_id',
'and REVIEW_STATUS = ''Reviewed''',
'and APPROVAL_STATUS = ''Approved''',
'and dp_scoping_id is null',
'and trunc((sla.sla_date - sysdate)) between 0 and 7 ',
'group by ''On Risk'', apex_util.prepare_url( ''f?p=''||:APP_ID||'':77:''||:APP_SESSION||''::NO::P77_SHOW_REGION:''|| ''2'' )',
'',
'UNION All',
'-- get Late',
'select ''Late'' Status ,',
'        nvl(count(*),0) total_count  ',
'        , trim(to_char(SUM(estimated_budget),''99,999,999,999,999.99'')) || '' AED'' total_budget',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':77:''||:APP_SESSION||''::NO::P77_SHOW_REGION:''|| ''3''  ) as link',
'from dp_items dp, dp_items_sla_fact sla',
'where dp.dp_year = :P1_YEAR ',
'and dp.item_id = sla.item_id',
'and REVIEW_STATUS = ''Reviewed''',
'and APPROVAL_STATUS = ''Approved''',
'and dp_scoping_id is null',
'and trunc((sysdate - sla.sla_date)) between 0 and 99999 ',
'group by ''Late'', apex_util.prepare_url( ''f?p=''||:APP_ID||'':77:''||:APP_SESSION||''::NO::P77_SHOW_REGION:''|| ''3'' )',
'union all',
'-- get On Draft',
'select ''Draft'' Status ',
'        ,nvl(count(dp.item_id),0) total_count',
'        , trim(to_char(SUM(dp.estimated_budget),''99,999,999,999,999.99'')) || '' AED'' total_budget',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':77:''||:APP_SESSION||''::NO::P77_SHOW_REGION:''|| ''4''  ) as link',
'from dp_items dp',
'where dp.dp_year = :P1_YEAR ',
'and REVIEW_STATUS = ''Draft''',
'--and APPROVAL_STATUS = ''Approved''',
'--and dp_scoping_id is null',
'--and trunc((sla.sla_date - sysdate)) between 0 and 7 ',
'group by ''On Risk'', apex_util.prepare_url( ''f?p=''||:APP_ID||'':77:''||:APP_SESSION||''::NO::P77_SHOW_REGION:''|| ''4'' )'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_ajax_items_to_submit=>'P1_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'TOTAL_BUDGET'
,p_attribute_02=>'TOTAL_COUNT'
,p_attribute_04=>'&LINK.'
,p_attribute_05=>'0'
,p_attribute_06=>'B'
,p_attribute_07=>'DOT'
,p_attribute_08=>'Y'
,p_attribute_09=>'STATUS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128132522938449275)
,p_plug_name=>'Page Navigation'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:u-colors:t-Cards--featured t-Cards--block force-fa-lg:t-Cards--displayIcons:t-Cards--4cols:t-Cards--hideBody:t-Cards--animColorFill'
,p_plug_template=>wwv_flow_api.id(127776395121449810)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(128130261437449276)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(127855242932449749)
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(129305944900084303)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127813188296449776)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(127749711524449850)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(127867332295449731)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(131993307538426015)
,p_plug_name=>'All Demand Planning Items'
,p_icon_css_classes=>'fa-dial-gauge-chart'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select dp.ITEM_ID,',
'       dp.INITIATIVE_ID,',
'       dp.PROJECT_NUMBER,',
'       projects_util.project_name(dp.project_number) project_name,',
'       dp.PROJECT_NEW_YN,',
'       decode(dp.PROJECT_NEW_YN , ''Y'', dp.PROJECT_NEW_NAME , dp.PROJECT_NUMBER) Project,',
'       dp.PROJECT_NEW_NAME,',
'       dp.PROJECT_DESCRIPTION,',
'       dp.CATEGORY_ID,',
'       dp.SUB_CATEGORY_ID,',
'       dp.ESTIMATED_DATE    Project_start_date,',
'       dp.PROJECT_END_DATE Project_end_date,',
'       dp.ESTIMATED_MONTH,',
'       dp.ESTIMATED_YEAR,',
'       dp.ESTIMATED_QUARTER,',
'       dp.END_USER_ID,',
'       dp.SECTOR_ID,',
'       user_details.sector_name_by_cc(dp.cost_center, sysdate) SECTOR_FINANCE,',
'       dp.DEPARTMENT_ID,',
'       dp.DP_ITEM_TYPE_ID,',
'       dp.RISK_ID,',
'       dp.PRIORITY_ID,',
'       dp.DP_PROCUREMENT_METHOD,',
'       dp.ESTIMATED_BUDGET,',
'       dp.ESTIMATED_BUDGET_BRACKET_ID,',
'       dp.PLANNING_STATUS,',
'       dp.REVIEW_STATUS,',
'       dp.APPROVAL_STATUS,',
'       dp.CUTT_OFF_DATE,',
'       dp.NOTES,',
'       dp.CREATED_BY,',
'       dp.CREATED_ON,',
'       dp.UPDATED_BY,',
'       dp.UPDATED_ON,',
'       dp.COST_CENTER,',
'       dp.project_title   ,',
'       user_details.get_cost_center_name(dp.COST_CENTER)  cost_center_name,',
'       dp.REJECTED_BY,',
'       dp.REVIEW_REJECTED_BY,',
'       dp.REVIEW_REJECT_ON,',
'       dp.REJECT_ON,',
'       dp.REVIEW_REJECT_REASON,',
'       dp.REJECT_REASON,',
'       dp.FINAL_APPROVE_ON,',
'       dp.REVIEW_APPROVE_ON,',
'       dp.REVIEW_APPROVE_BY,',
'       dp.FINAL_APPROVE_BY,',
'       dp.SUBMIT_APPROVAL_ON,',
'       dp.SUBMIT_REVIEW_ON,',
'       dp.SUBMIT_REVIEW_BY,',
'       dp.SUBMIT_APPROVAL_BY,',
'       dp.DP_ITEM_NAME,',
'       dp.COUNT_YEAR,',
'       dp.COUNT_ITEM,',
'       dp.DP_YEAR,',
'       dp.CANCEL_ON,',
'       dp.CANCELLED_BY,',
'       dp.CANCEL_REASON,',
'       dp.ESTIMATED_DATE_DEFINE,',
'       dp.ESTIMATED_BUDGET_DEFINE,',
'       dp.INITIATIVE_NEW_YN,',
'       dp.INITIATIVE_NEW_NAME,',
'       dp.DP_ITEM_CODE,',
'       dp.DP_SCOPING_ID,',
'       dp.MAIN_CATEGORY_ID,',
'       dp.CONTRACT_NO,',
'       dp.TOTAL_PROJECT_BUDGET,',
'       dp.TASK_NUMBER,',
'       dp.TASK_NUMBER_NEW,',
'       dp.EXPENDITURE_TYPE,',
'       dp.EXPENDITURE_TYPE_NEW,',
'       dp.TASK_NEW_YN,',
'       dp.template_id Template,',
'       dp_item_status_id,',
'  -- cashflow Details ',
'        cl.jan,',
'        cl.feb,',
'        cl.mar,',
'        cl.apr,',
'        cl.may,',
'        cl.jun,',
'        cl.jul,',
'        cl.aug,',
'        cl.sep,',
'        cl.oct,',
'        cl.nov,',
'        cl.dec',
'  from DP_ITEMS dp , cashflow_lines cl',
'  where dp.item_id  = cl.request_id (+)',
'  and dp.DP_YEAR = :P1_YEAR',
'--  and cl.source = ''DP''',
' order by dp.ITEM_ID DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P1_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':IS_DP_ADMIN = ''Y'' OR :IS_VIEW_ALL_DP_ITEMS > ''Y'' or :Person_id in ( 128179 , 1646672) or :IS_PBP_EMP = ''Y'''
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'DP Items'
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
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(131993573019426017)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ITEM_ID,P11_PAGE_FROM,P11_ITEM_ID_H:#ITEM_ID#,1,#ITEM_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>131993573019426017
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131993607630426018)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Item ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131993745575426019)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131993811554426020)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131993915760426021)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131994070039426022)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131994143548426023)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131994257442426024)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131994336412426025)
,p_db_column_name=>'REVIEW_REJECTED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Review Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131994497209426026)
,p_db_column_name=>'REVIEW_REJECT_ON'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Review Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131994534443426027)
,p_db_column_name=>'REJECT_ON'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131994680610426028)
,p_db_column_name=>'REVIEW_REJECT_REASON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Review Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131994753947426029)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131994816640426030)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131994989679426031)
,p_db_column_name=>'REVIEW_APPROVE_ON'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Review Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131995035974426032)
,p_db_column_name=>'REVIEW_APPROVE_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Review Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131995198838426033)
,p_db_column_name=>'FINAL_APPROVE_BY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Final Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131995233294426034)
,p_db_column_name=>'SUBMIT_APPROVAL_ON'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Submit Approval On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131995305609426035)
,p_db_column_name=>'SUBMIT_REVIEW_ON'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Submit Review On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131995497305426036)
,p_db_column_name=>'SUBMIT_REVIEW_BY'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Submit Review By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131995588134426037)
,p_db_column_name=>'SUBMIT_APPROVAL_BY'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Submit Approval By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131995642244426038)
,p_db_column_name=>'DP_ITEM_NAME'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Demand Planning Item Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131995720300426039)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Initiative'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128335626861489802)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131995802910426040)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131995943447426041)
,p_db_column_name=>'PROJECT_NEW_YN'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Project New ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131996030732426042)
,p_db_column_name=>'PROJECT_NEW_NAME'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'New Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131996129872426043)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131996241482426044)
,p_db_column_name=>'CATEGORY_ID'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Category Level 2'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(140752397958276427)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131996374979426045)
,p_db_column_name=>'SUB_CATEGORY_ID'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Category Level 3'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(140845235127023726)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131996564932426047)
,p_db_column_name=>'ESTIMATED_MONTH'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Estimated Month'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131996603818426048)
,p_db_column_name=>'ESTIMATED_YEAR'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Estimated Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131996762998426049)
,p_db_column_name=>'ESTIMATED_QUARTER'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Estimated Quarter'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(131996832075426050)
,p_db_column_name=>'END_USER_ID'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'End User'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133050387389907001)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Sector HR'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128342316999489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133050406744907002)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341292413489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133050584927907003)
,p_db_column_name=>'DP_ITEM_TYPE_ID'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Project Item Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128416904318325983)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133050604793907004)
,p_db_column_name=>'RISK_ID'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Risk'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128420411111243936)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133050774072907005)
,p_db_column_name=>'PRIORITY_ID'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Priority'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341720324489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133050890448907006)
,p_db_column_name=>'DP_PROCUREMENT_METHOD'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Procurement Method'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(502791478764956231)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133050912634907007)
,p_db_column_name=>'ESTIMATED_BUDGET'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Estimated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133051022482907008)
,p_db_column_name=>'ESTIMATED_BUDGET_BRACKET_ID'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Estimated Budget Bracket'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133051182286907009)
,p_db_column_name=>'PLANNING_STATUS'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Planning Status'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128420883056239409)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133051283203907010)
,p_db_column_name=>'REVIEW_STATUS'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Review Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133051394167907011)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133051414297907012)
,p_db_column_name=>'CUTT_OFF_DATE'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Cutt-Off Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133051512254907013)
,p_db_column_name=>'NOTES'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(135343736362699619)
,p_db_column_name=>'COUNT_YEAR'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Count Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(135343830942699620)
,p_db_column_name=>'COUNT_ITEM'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Count Item'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(135343920176699621)
,p_db_column_name=>'DP_YEAR'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Planning Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(135344017258699622)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(135344107144699623)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(135344254865699624)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(135344352712699625)
,p_db_column_name=>'ESTIMATED_DATE_DEFINE'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Estimated Date Define ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(135344466591699626)
,p_db_column_name=>'ESTIMATED_BUDGET_DEFINE'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Estimated Budget Define ?'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(135344511142699627)
,p_db_column_name=>'INITIATIVE_NEW_YN'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'New Initiative ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(135344692580699628)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'New Initiative Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(135344702087699629)
,p_db_column_name=>'DP_ITEM_CODE'
,p_display_order=>570
,p_column_identifier=>'BE'
,p_column_label=>'DP Item Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8892059979220158)
,p_db_column_name=>'DP_SCOPING_ID'
,p_display_order=>580
,p_column_identifier=>'BF'
,p_column_label=>'Dp Scoping Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8892223790220159)
,p_db_column_name=>'MAIN_CATEGORY_ID'
,p_display_order=>590
,p_column_identifier=>'BG'
,p_column_label=>'Category Level 1'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(128449582832098954)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8892254663220160)
,p_db_column_name=>'CONTRACT_NO'
,p_display_order=>600
,p_column_identifier=>'BH'
,p_column_label=>'Contract No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8892428111220161)
,p_db_column_name=>'TOTAL_PROJECT_BUDGET'
,p_display_order=>610
,p_column_identifier=>'BI'
,p_column_label=>'Total Project Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8892495393220162)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>620
,p_column_identifier=>'BJ'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8892614821220163)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>630
,p_column_identifier=>'BK'
,p_column_label=>'New Task'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8892707547220164)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>640
,p_column_identifier=>'BL'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8892793834220165)
,p_db_column_name=>'EXPENDITURE_TYPE_NEW'
,p_display_order=>650
,p_column_identifier=>'BM'
,p_column_label=>'New Expenditure Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8892925001220166)
,p_db_column_name=>'TASK_NEW_YN'
,p_display_order=>660
,p_column_identifier=>'BN'
,p_column_label=>'Task New ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8892959165220167)
,p_db_column_name=>'PROJECT'
,p_display_order=>670
,p_column_identifier=>'BO'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144168017618791243)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>680
,p_column_identifier=>'BP'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138519703799666373)
,p_db_column_name=>'TEMPLATE'
,p_display_order=>690
,p_column_identifier=>'BQ'
,p_column_label=>'Template'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(138404640303341881)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136966472526589170)
,p_db_column_name=>'JAN'
,p_display_order=>700
,p_column_identifier=>'BR'
,p_column_label=>'Jan'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136966348434589169)
,p_db_column_name=>'FEB'
,p_display_order=>710
,p_column_identifier=>'BS'
,p_column_label=>'Feb'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136966319244589168)
,p_db_column_name=>'MAR'
,p_display_order=>720
,p_column_identifier=>'BT'
,p_column_label=>'Mar'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136966174536589167)
,p_db_column_name=>'APR'
,p_display_order=>730
,p_column_identifier=>'BU'
,p_column_label=>'Apr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136966095908589166)
,p_db_column_name=>'MAY'
,p_display_order=>740
,p_column_identifier=>'BV'
,p_column_label=>'May'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136965983178589165)
,p_db_column_name=>'JUN'
,p_display_order=>750
,p_column_identifier=>'BW'
,p_column_label=>'Jun'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136965867022589164)
,p_db_column_name=>'JUL'
,p_display_order=>760
,p_column_identifier=>'BX'
,p_column_label=>'Jul'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136965784952589163)
,p_db_column_name=>'AUG'
,p_display_order=>770
,p_column_identifier=>'BY'
,p_column_label=>'Aug'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136965638942589162)
,p_db_column_name=>'SEP'
,p_display_order=>780
,p_column_identifier=>'BZ'
,p_column_label=>'Sep'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136965575297589161)
,p_db_column_name=>'OCT'
,p_display_order=>790
,p_column_identifier=>'CA'
,p_column_label=>'Oct'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136965464406589160)
,p_db_column_name=>'NOV'
,p_display_order=>800
,p_column_identifier=>'CB'
,p_column_label=>'Nov'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(136965350795589159)
,p_db_column_name=>'DEC'
,p_display_order=>810
,p_column_identifier=>'CC'
,p_column_label=>'Dec'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122547724885343739)
,p_db_column_name=>'DP_ITEM_STATUS_ID'
,p_display_order=>820
,p_column_identifier=>'CD'
,p_column_label=>'Project Status'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(122786651982504967)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(515375957811329487)
,p_db_column_name=>'SECTOR_FINANCE'
,p_display_order=>830
,p_column_identifier=>'CF'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(511558870669694078)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>840
,p_column_identifier=>'CG'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(509039754166628192)
,p_db_column_name=>'PROJECT_TITLE'
,p_display_order=>850
,p_column_identifier=>'CH'
,p_column_label=>'Project Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(509037506566628170)
,p_db_column_name=>'PROJECT_START_DATE'
,p_display_order=>860
,p_column_identifier=>'CI'
,p_column_label=>'Project Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(509037444631628169)
,p_db_column_name=>'PROJECT_END_DATE'
,p_display_order=>870
,p_column_identifier=>'CJ'
,p_column_label=>'Project End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(133070509207904564)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1330706'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100
,p_report_columns=>'DP_ITEM_CODE:SECTOR_FINANCE:PROJECT:PROJECT_NAME:END_USER_ID:TEMPLATE:ESTIMATED_BUDGET:PLANNING_STATUS:REVIEW_STATUS:APPROVAL_STATUS:DP_ITEM_STATUS_ID:COST_CENTER_NAME:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(499039166052608944)
,p_report_id=>wwv_flow_api.id(133070509207904564)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(499038760444608945)
,p_report_id=>wwv_flow_api.id(133070509207904564)
,p_name=>'Not Accepted'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Not Accepted'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Not Accepted''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFD6D2'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(499038364278608946)
,p_report_id=>wwv_flow_api.id(133070509207904564)
,p_name=>'Reviewd'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Reviewed'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Reviewed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(499037970856608946)
,p_report_id=>wwv_flow_api.id(133070509207904564)
,p_name=>'Withdraw'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Withdraw'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Withdraw''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(499037623228608947)
,p_report_id=>wwv_flow_api.id(133070509207904564)
,p_name=>'in-Progress'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#D0F1CC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(501498845640134259)
,p_application_user=>'TCA690'
,p_name=>'Tamer Team DP Report 2 with cash flow'
,p_description=>'Tamer Team DP Report 2 with cash flow'
,p_report_seq=>10
,p_report_alias=>'2357120'
,p_status=>'PUBLIC'
,p_display_rows=>100
,p_report_columns=>'DP_ITEM_CODE:PROJECT:PROJECT_NUMBER:PROJECT_TITLE:PROJECT_NAME:PROJECT_DESCRIPTION:SECTOR_FINANCE:TOTAL_PROJECT_BUDGET:DEPARTMENT_ID:COST_CENTER_NAME:END_USER_ID:ESTIMATED_BUDGET:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:PLANNING_STATUS:REVIEW_'
||'STATUS:APPROVAL_STATUS:DP_ITEM_STATUS_ID:REVIEW_APPROVE_BY:DP_PROCUREMENT_METHOD:TASK_NUMBER:EXPENDITURE_TYPE:MAIN_CATEGORY_ID:CATEGORY_ID:SUB_CATEGORY_ID'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(501453301804326174)
,p_report_id=>wwv_flow_api.id(501498845640134259)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(501452934033326175)
,p_report_id=>wwv_flow_api.id(501498845640134259)
,p_name=>'Not Accepted'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Not Accepted'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Not Accepted''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFD6D2'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(501452535859326176)
,p_report_id=>wwv_flow_api.id(501498845640134259)
,p_name=>'Reviewd'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Reviewed'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Reviewed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(501452106070326176)
,p_report_id=>wwv_flow_api.id(501498845640134259)
,p_name=>'Withdraw'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Withdraw'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Withdraw''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(501451739536326177)
,p_report_id=>wwv_flow_api.id(501498845640134259)
,p_name=>'in-Progress'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#D0F1CC'
,p_column_font_color=>'#000000'
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(572652931621875511)
,p_application_user=>'TCA9275'
,p_name=>'Demand Plan 4'
,p_report_seq=>10
,p_display_rows=>100
,p_report_columns=>'DP_ITEM_CODE:SECTOR_ID:PROJECT:PROJECT_NAME:END_USER_ID:DP_PROCUREMENT_METHOD:ESTIMATED_BUDGET:PLANNING_STATUS:REVIEW_STATUS:APPROVAL_STATUS:CANCEL_ON:CANCEL_REASON:CANCELLED_BY:CATEGORY_ID:CONTRACT_NO:COST_CENTER:COUNT_ITEM:COUNT_YEAR:CREATED_BY:CRE'
||'ATED_ON:CUTT_OFF_DATE:DP_ITEM_TYPE_ID:DEPARTMENT_ID:DP_SCOPING_ID:ESTIMATED_BUDGET_BRACKET_ID:ESTIMATED_DATE_DEFINE:ESTIMATED_MONTH:ESTIMATED_QUARTER:ESTIMATED_YEAR:EXPENDITURE_TYPE:FINAL_APPROVE_BY:FINAL_APPROVE_ON:INITIATIVE_ID:ITEM_ID:MAIN_CATEGOR'
||'Y_ID:EXPENDITURE_TYPE_NEW:INITIATIVE_NEW_YN:INITIATIVE_NEW_NAME:PROJECT_NEW_NAME:TASK_NUMBER_NEW:NOTES:DP_YEAR:PRIORITY_ID:PROJECT_NUMBER:PROJECT_DESCRIPTION:PROJECT_NEW_YN:REJECT_ON:REJECT_REASON:REJECTED_BY:REVIEW_APPROVE_BY:REVIEW_APPROVE_ON:REVIE'
||'W_REJECT_ON:REVIEW_REJECT_REASON:REVIEW_REJECTED_BY:RISK_ID:SUB_CATEGORY_ID:SUBMIT_APPROVAL_BY:SUBMIT_APPROVAL_ON:SUBMIT_REVIEW_BY:SUBMIT_REVIEW_ON:TASK_NUMBER:TASK_NEW_YN:TOTAL_PROJECT_BUDGET:UPDATED_BY:UPDATED_ON'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(572652331200870425)
,p_report_id=>wwv_flow_api.id(572652931621875511)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(572652169274870425)
,p_report_id=>wwv_flow_api.id(572652931621875511)
,p_name=>'Reviewd'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Reviewed'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Reviewed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(572514328294033324)
,p_application_user=>'TCA9270'
,p_name=>'All Columns'
,p_report_seq=>10
,p_display_rows=>100
,p_report_columns=>'DP_ITEM_CODE:SECTOR_ID:PROJECT:PROJECT_NAME:END_USER_ID:DP_PROCUREMENT_METHOD:ESTIMATED_BUDGET:PLANNING_STATUS:REVIEW_STATUS:APPROVAL_STATUS:CANCEL_ON:CANCEL_REASON:CANCELLED_BY:CATEGORY_ID:CONTRACT_NO:COST_CENTER:COUNT_ITEM:COUNT_YEAR:CREATED_BY:CRE'
||'ATED_ON:CUTT_OFF_DATE:DP_ITEM_TYPE_ID:DEPARTMENT_ID:DP_SCOPING_ID:ESTIMATED_BUDGET_BRACKET_ID:ESTIMATED_DATE_DEFINE:ESTIMATED_MONTH:ESTIMATED_QUARTER:ESTIMATED_YEAR:EXPENDITURE_TYPE:FINAL_APPROVE_BY:FINAL_APPROVE_ON:INITIATIVE_ID:ITEM_ID:MAIN_CATEGOR'
||'Y_ID:EXPENDITURE_TYPE_NEW:INITIATIVE_NEW_YN:INITIATIVE_NEW_NAME:PROJECT_NEW_NAME:TASK_NUMBER_NEW:NOTES:DP_YEAR:PRIORITY_ID:PROJECT_NUMBER:PROJECT_DESCRIPTION:PROJECT_NEW_YN:REJECT_ON:REJECT_REASON:REJECTED_BY:REVIEW_APPROVE_BY:REVIEW_APPROVE_ON:REVIE'
||'W_REJECT_ON:REVIEW_REJECT_REASON:REVIEW_REJECTED_BY:RISK_ID:SUB_CATEGORY_ID:SUBMIT_APPROVAL_BY:SUBMIT_APPROVAL_ON:SUBMIT_REVIEW_BY:SUBMIT_REVIEW_ON:TASK_NUMBER:TASK_NEW_YN:TOTAL_PROJECT_BUDGET:UPDATED_BY:UPDATED_ON'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(572514170671033323)
,p_report_id=>wwv_flow_api.id(572514328294033324)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(572514147097033323)
,p_report_id=>wwv_flow_api.id(572514328294033324)
,p_name=>'Reviewd'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Reviewed'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Reviewed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(566638173409259035)
,p_application_user=>'TCA9316'
,p_name=>'Cost Center'
,p_report_seq=>10
,p_display_rows=>100
,p_report_columns=>'DP_ITEM_CODE:SECTOR_ID:PROJECT:PROJECT_NAME:END_USER_ID:COST_CENTER:DP_PROCUREMENT_METHOD:TEMPLATE:ESTIMATED_BUDGET:PLANNING_STATUS:REVIEW_STATUS:APPROVAL_STATUS'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(566638025933259035)
,p_report_id=>wwv_flow_api.id(566638173409259035)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(566637917976259035)
,p_report_id=>wwv_flow_api.id(566638173409259035)
,p_name=>'Reviewd'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Reviewed'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Reviewed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(566638082512259035)
,p_report_id=>wwv_flow_api.id(566638173409259035)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'END_USER_ID'
,p_operator=>'='
,p_expr=>'Sherine Abdel Ghafar'
,p_condition_sql=>'"END_USER_ID" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''Sherine Abdel Ghafar''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(566467797876415888)
,p_application_user=>'TCA9050'
,p_name=>'DP report for tracker'
,p_report_seq=>10
,p_display_rows=>100
,p_report_columns=>'DP_ITEM_CODE:SECTOR_ID:PROJECT:PROJECT_NAME:END_USER_ID:DP_PROCUREMENT_METHOD:TEMPLATE:ESTIMATED_BUDGET:PLANNING_STATUS:REVIEW_STATUS:APPROVAL_STATUS:COST_CENTER:EXPENDITURE_TYPE:EXPENDITURE_TYPE_NEW:PROJECT_NEW_NAME:TASK_NUMBER_NEW:PROJECT_NUMBER:TA'
||'SK_NUMBER:TOTAL_PROJECT_BUDGET'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(566458095345314880)
,p_report_id=>wwv_flow_api.id(566467797876415888)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(564020641376499177)
,p_application_user=>'TCA9316'
,p_name=>'Culture Marketing'
,p_report_seq=>10
,p_display_rows=>100
,p_report_columns=>'DP_ITEM_CODE:SECTOR_ID:ESTIMATED_QUARTER:PROJECT:PROJECT_NAME:END_USER_ID:DP_PROCUREMENT_METHOD:TEMPLATE:ESTIMATED_BUDGET:DP_SCOPING_ID:PLANNING_STATUS:REVIEW_STATUS:APPROVAL_STATUS'
,p_sort_column_1=>'TEMPLATE'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'ESTIMATED_BUDGET'
,p_sort_direction_2=>'DESC'
,p_sort_column_3=>'DP_SCOPING_ID'
,p_sort_direction_3=>'ASC NULLS LAST'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(563993391368210792)
,p_report_id=>wwv_flow_api.id(564020641376499177)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(563993329302210792)
,p_report_id=>wwv_flow_api.id(564020641376499177)
,p_name=>'Reviewd'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Reviewed'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Reviewed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(563993733528210792)
,p_report_id=>wwv_flow_api.id(564020641376499177)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'END_USER_ID'
,p_operator=>'='
,p_expr=>'Sherine Abdel Ghafar'
,p_condition_sql=>'"END_USER_ID" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''Sherine Abdel Ghafar''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(563993603562210792)
,p_report_id=>wwv_flow_api.id(564020641376499177)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'TEMPLATE'
,p_operator=>'not in'
,p_expr=>'IT Services Scoping,Consultancy Scoping,Entertainment Scoping,Standard Services Scoping'
,p_condition_sql=>'"TEMPLATE" not in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#, #APXWS_EXPR_VAL3#, #APXWS_EXPR_VAL4#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''IT Services Scoping, Consultancy Scoping, Entertainment Scoping, Standard Services Scoping''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(563993498157210792)
,p_report_id=>wwv_flow_api.id(564020641376499177)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'TEMPLATE'
,p_operator=>'not in'
,p_expr=>'Website Development Scoping'
,p_condition_sql=>'"TEMPLATE" not in (#APXWS_EXPR_VAL1#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Website Development Scoping''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(507719881254670745)
,p_application_user=>'TCA9051'
,p_name=>'Hossam'
,p_description=>'For xxxxxx'
,p_report_seq=>10
,p_display_rows=>100
,p_report_columns=>'DP_ITEM_CODE:SECTOR_FINANCE:PROJECT:PROJECT_NAME:END_USER_ID:TEMPLATE:ESTIMATED_BUDGET:PLANNING_STATUS:REVIEW_STATUS:APPROVAL_STATUS:DP_ITEM_STATUS_ID::COST_CENTER_NAME'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(507719698904670745)
,p_report_id=>wwv_flow_api.id(507719881254670745)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(507719653927670746)
,p_report_id=>wwv_flow_api.id(507719881254670745)
,p_name=>'Not Accepted'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Not Accepted'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Not Accepted''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFD6D2'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(507719472520670746)
,p_report_id=>wwv_flow_api.id(507719881254670745)
,p_name=>'Reviewd'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Reviewed'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Reviewed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(507719373427670746)
,p_report_id=>wwv_flow_api.id(507719881254670745)
,p_name=>'Withdraw'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Withdraw'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Withdraw''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(507719323142670746)
,p_report_id=>wwv_flow_api.id(507719881254670745)
,p_name=>'in-Progress'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#D0F1CC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(507719839079670745)
,p_report_id=>wwv_flow_api.id(507719881254670745)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'COST_CENTER_NAME'
,p_operator=>'in'
,p_expr=>'DCT - Business Continuity Dept,DCT - Business Intelligence Dept'
,p_condition_sql=>'"COST_CENTER_NAME" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''DCT - Business Continuity Dept, DCT - Business Intelligence Dept''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(502938114820302421)
,p_application_user=>'TCA690'
,p_name=>'Tamer Team DP Report'
,p_description=>'Tamer Team DP Report'
,p_report_seq=>10
,p_display_rows=>100
,p_report_columns=>'DP_ITEM_CODE:PROJECT:PROJECT_NUMBER:PROJECT_TITLE:PROJECT_NAME:PROJECT_DESCRIPTION:SECTOR_FINANCE:DEPARTMENT_ID:COST_CENTER_NAME:END_USER_ID:ESTIMATED_BUDGET:PLANNING_STATUS:REVIEW_STATUS:APPROVAL_STATUS:DP_ITEM_STATUS_ID:REVIEW_APPROVE_BY:DP_PROCURE'
||'MENT_METHOD:TASK_NUMBER:EXPENDITURE_TYPE:MAIN_CATEGORY_ID:CATEGORY_ID:SUB_CATEGORY_ID'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(502937743487302428)
,p_report_id=>wwv_flow_api.id(502938114820302421)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(502937258398302431)
,p_report_id=>wwv_flow_api.id(502938114820302421)
,p_name=>'Not Accepted'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Not Accepted'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Not Accepted''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFD6D2'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(502936905882302434)
,p_report_id=>wwv_flow_api.id(502938114820302421)
,p_name=>'Reviewd'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Reviewed'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Reviewed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(502936491628302435)
,p_report_id=>wwv_flow_api.id(502938114820302421)
,p_name=>'Withdraw'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Withdraw'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Withdraw''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(502936094405302436)
,p_report_id=>wwv_flow_api.id(502938114820302421)
,p_name=>'in-Progress'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#D0F1CC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(502458940003968167)
,p_application_user=>'TCA9316'
,p_name=>'Demand_planning'
,p_report_seq=>10
,p_display_rows=>100
,p_report_columns=>'CREATED_BY:END_USER_ID:DP_ITEM_CODE:SECTOR_FINANCE:COST_CENTER_NAME:PROJECT_TITLE:ESTIMATED_BUDGET:TOTAL_PROJECT_BUDGET:REVIEW_STATUS:APPROVAL_STATUS:MAIN_CATEGORY_ID:CATEGORY_ID:SUB_CATEGORY_ID:PROJECT_START_DATE:PROJECT_END_DATE:DP_PROCUREMENT_METH'
||'OD:PROJECT:PROJECT_NAME:PROJECT_DESCRIPTION:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(498182917026415613)
,p_report_id=>wwv_flow_api.id(502458940003968167)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(498182814334415613)
,p_report_id=>wwv_flow_api.id(502458940003968167)
,p_name=>'Not Accepted'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Not Accepted'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Not Accepted''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFD6D2'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(498182742036415613)
,p_report_id=>wwv_flow_api.id(502458940003968167)
,p_name=>'Reviewd'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Reviewed'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Reviewed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(498182648137415613)
,p_report_id=>wwv_flow_api.id(502458940003968167)
,p_name=>'Withdraw'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Withdraw'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Withdraw''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(498182531528415613)
,p_report_id=>wwv_flow_api.id(502458940003968167)
,p_name=>'in-Progress'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#D0F1CC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(257652060018214200)
,p_plug_name=>'My Demand Planning Items'
,p_icon_css_classes=>'fa-user-check'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ITEM_ID,',
'       INITIATIVE_ID,',
'       PROJECT_NUMBER,',
'       PROJECT_NEW_YN,',
'       decode(PROJECT_NEW_YN , ''Y'', PROJECT_NEW_NAME , PROJECT_NUMBER) Project,',
'       PROJECT_NEW_NAME,',
'       PROJECT_DESCRIPTION,',
'       CATEGORY_ID,',
'       SUB_CATEGORY_ID,',
'       ESTIMATED_DATE,',
'       ESTIMATED_MONTH,',
'       ESTIMATED_YEAR,',
'       ESTIMATED_QUARTER,',
'       END_USER_ID,',
'       SECTOR_ID,',
'       DEPARTMENT_ID,',
'       DP_ITEM_TYPE_ID,',
'       RISK_ID,',
'       PRIORITY_ID,',
'       DP_PROCUREMENT_METHOD,',
'       ESTIMATED_BUDGET,',
'       ESTIMATED_BUDGET_BRACKET_ID,',
'       PLANNING_STATUS,',
'       REVIEW_STATUS,',
'       APPROVAL_STATUS,',
'       CUTT_OFF_DATE,',
'       NOTES,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       COST_CENTER,',
'       REJECTED_BY,',
'       REVIEW_REJECTED_BY,',
'       REVIEW_REJECT_ON,',
'       REJECT_ON,',
'       REVIEW_REJECT_REASON,',
'       REJECT_REASON,',
'       FINAL_APPROVE_ON,',
'       REVIEW_APPROVE_ON,',
'       REVIEW_APPROVE_BY,',
'       FINAL_APPROVE_BY,',
'       SUBMIT_APPROVAL_ON,',
'       SUBMIT_REVIEW_ON,',
'       SUBMIT_REVIEW_BY,',
'       SUBMIT_APPROVAL_BY,',
'       DP_ITEM_NAME,',
'       COUNT_YEAR,',
'       COUNT_ITEM,',
'       DP_YEAR,',
'       CANCEL_ON,',
'       CANCELLED_BY,',
'       CANCEL_REASON,',
'       ESTIMATED_DATE_DEFINE,',
'       ESTIMATED_BUDGET_DEFINE,',
'       dp_item_code',
'  from DP_ITEMS ',
' where (CREATED_BY = :PERSON_ID  or ',
'         :PERSON_ID in (select dip.person_id from dp_item_participants dip where dip.item_id = DP_ITEMS.item_id and status = ''A'' and sysdate between nvl(start_date , sysdate -10) and nvl(end_date , sysdate + 10)))',
' order by item_id desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'DP Items'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(257652231793214200)
,p_name=>'DP Items'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'you don''t have any Demand Plan Item yet.'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ITEM_ID,P11_PAGE_FROM,P11_ITEM_ID_H:#ITEM_ID#,1,#ITEM_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>257652231793214200
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129659379469764806)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Item ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129677393394764791)
,p_db_column_name=>'DP_ITEM_NAME'
,p_display_order=>20
,p_column_identifier=>'AT'
,p_column_label=>'Demand Planning Item Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129659711165764806)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Initiative'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128335626861489802)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129660122910764806)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129660586534764806)
,p_db_column_name=>'PROJECT_NEW_YN'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Project New ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129660902399764805)
,p_db_column_name=>'PROJECT_NEW_NAME'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'New Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129661346318764805)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129661772430764805)
,p_db_column_name=>'CATEGORY_ID'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Main Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449582832098954)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129662186604764805)
,p_db_column_name=>'SUB_CATEGORY_ID'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Sub Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449760929095476)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129662589466764805)
,p_db_column_name=>'ESTIMATED_DATE'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Estimated Date'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129662951291764805)
,p_db_column_name=>'ESTIMATED_MONTH'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Estimated Month'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129663388589764804)
,p_db_column_name=>'ESTIMATED_YEAR'
,p_display_order=>120
,p_column_identifier=>'K'
,p_column_label=>'Estimated Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129663759573764804)
,p_db_column_name=>'ESTIMATED_QUARTER'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Estimated Quarter'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129664140401764804)
,p_db_column_name=>'END_USER_ID'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'End User'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129664525024764804)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128342316999489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129664901562764804)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>160
,p_column_identifier=>'O'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341292413489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129665370831764804)
,p_db_column_name=>'DP_ITEM_TYPE_ID'
,p_display_order=>170
,p_column_identifier=>'P'
,p_column_label=>'DP Item Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128416904318325983)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129665750350764803)
,p_db_column_name=>'RISK_ID'
,p_display_order=>180
,p_column_identifier=>'Q'
,p_column_label=>'Risk'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128420411111243936)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129666155637764803)
,p_db_column_name=>'PRIORITY_ID'
,p_display_order=>190
,p_column_identifier=>'R'
,p_column_label=>'Priority'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341720324489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129666549509764803)
,p_db_column_name=>'DP_PROCUREMENT_METHOD'
,p_display_order=>200
,p_column_identifier=>'S'
,p_column_label=>'Procurement Method'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(502791478764956231)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129666977516764803)
,p_db_column_name=>'ESTIMATED_BUDGET'
,p_display_order=>210
,p_column_identifier=>'T'
,p_column_label=>'Estimated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129667378539764803)
,p_db_column_name=>'ESTIMATED_BUDGET_BRACKET_ID'
,p_display_order=>220
,p_column_identifier=>'U'
,p_column_label=>'Estimated Budget Bracket'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129667752414764803)
,p_db_column_name=>'PLANNING_STATUS'
,p_display_order=>230
,p_column_identifier=>'V'
,p_column_label=>'Planning Status'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128420883056239409)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129668196247764803)
,p_db_column_name=>'REVIEW_STATUS'
,p_display_order=>240
,p_column_identifier=>'W'
,p_column_label=>'Review Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129668524026764802)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>250
,p_column_identifier=>'X'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129668944697764802)
,p_db_column_name=>'CUTT_OFF_DATE'
,p_display_order=>260
,p_column_identifier=>'Y'
,p_column_label=>'Cutt-Off Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129669390181764802)
,p_db_column_name=>'NOTES'
,p_display_order=>270
,p_column_identifier=>'Z'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129669724620764802)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>280
,p_column_identifier=>'AA'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
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
 p_id=>wwv_flow_api.id(129670116400764802)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>290
,p_column_identifier=>'AB'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129670538110764802)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>300
,p_column_identifier=>'AC'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129670948770764801)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>310
,p_column_identifier=>'AD'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129671316448764801)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>320
,p_column_identifier=>'AE'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(129457052659370368)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129671790814764801)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>330
,p_column_identifier=>'AF'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129672178949764801)
,p_db_column_name=>'REVIEW_REJECTED_BY'
,p_display_order=>340
,p_column_identifier=>'AG'
,p_column_label=>'Review Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129672568937764801)
,p_db_column_name=>'REVIEW_REJECT_ON'
,p_display_order=>350
,p_column_identifier=>'AH'
,p_column_label=>'Review Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129672962265764801)
,p_db_column_name=>'REJECT_ON'
,p_display_order=>360
,p_column_identifier=>'AI'
,p_column_label=>'Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129673378553764800)
,p_db_column_name=>'REVIEW_REJECT_REASON'
,p_display_order=>370
,p_column_identifier=>'AJ'
,p_column_label=>'Review Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129673728595764800)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>380
,p_column_identifier=>'AK'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129674181249764800)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>390
,p_column_identifier=>'AL'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129674541545764800)
,p_db_column_name=>'REVIEW_APPROVE_ON'
,p_display_order=>400
,p_column_identifier=>'AM'
,p_column_label=>'Review Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129674993969764800)
,p_db_column_name=>'REVIEW_APPROVE_BY'
,p_display_order=>410
,p_column_identifier=>'AN'
,p_column_label=>'Review Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129675396964764792)
,p_db_column_name=>'FINAL_APPROVE_BY'
,p_display_order=>420
,p_column_identifier=>'AO'
,p_column_label=>'Final Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129675707418764792)
,p_db_column_name=>'SUBMIT_APPROVAL_ON'
,p_display_order=>430
,p_column_identifier=>'AP'
,p_column_label=>'Submit Approval On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129676146706764792)
,p_db_column_name=>'SUBMIT_REVIEW_ON'
,p_display_order=>440
,p_column_identifier=>'AQ'
,p_column_label=>'Submit Review On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129676573022764792)
,p_db_column_name=>'SUBMIT_REVIEW_BY'
,p_display_order=>450
,p_column_identifier=>'AR'
,p_column_label=>'Submit Review By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(129676996361764792)
,p_db_column_name=>'SUBMIT_APPROVAL_BY'
,p_display_order=>460
,p_column_identifier=>'AS'
,p_column_label=>'Submit Approval By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133051613580907014)
,p_db_column_name=>'COUNT_YEAR'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Count Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133051750321907015)
,p_db_column_name=>'COUNT_ITEM'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Count Item'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133051882591907016)
,p_db_column_name=>'DP_YEAR'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Dp Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133051955204907017)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133052007929907018)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133052175140907019)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133052259664907020)
,p_db_column_name=>'ESTIMATED_DATE_DEFINE'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Estimated Date Define'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(133052376659907021)
,p_db_column_name=>'ESTIMATED_BUDGET_DEFINE'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Estimated Budget Define'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(135344913656699631)
,p_db_column_name=>'DP_ITEM_CODE'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'DP Item Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8891960094220157)
,p_db_column_name=>'PROJECT'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(257753492042214115)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1296777'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DP_ITEM_CODE:PROJECT:DP_PROCUREMENT_METHOD:ESTIMATED_BUDGET:PLANNING_STATUS:REVIEW_STATUS:APPROVAL_STATUS:'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(136791087875030942)
,p_report_id=>wwv_flow_api.id(257753492042214115)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(136790710930030941)
,p_report_id=>wwv_flow_api.id(257753492042214115)
,p_name=>'Drat'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Draft'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Draft''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#B1E5F5'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(136790240050030941)
,p_report_id=>wwv_flow_api.id(257753492042214115)
,p_name=>'Not Accepted'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Not Accepted'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Not Accepted''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(136789866962030941)
,p_report_id=>wwv_flow_api.id(257753492042214115)
,p_name=>'Return'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Return'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Return''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#CCE5FF'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(136789435392030941)
,p_report_id=>wwv_flow_api.id(257753492042214115)
,p_name=>'Reviewed'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Reviewed'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Reviewed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(136789083012030940)
,p_report_id=>wwv_flow_api.id(257753492042214115)
,p_name=>'In Review'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(574255467085884934)
,p_application_user=>'TCA9270'
,p_name=>'DP Item With Description'
,p_report_seq=>10
,p_report_columns=>'DP_ITEM_CODE:PROJECT:PROJECT_DESCRIPTION:DP_PROCUREMENT_METHOD:ESTIMATED_BUDGET:PLANNING_STATUS:REVIEW_STATUS:APPROVAL_STATUS:'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(574255438855884934)
,p_report_id=>wwv_flow_api.id(574255467085884934)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(574255284642884933)
,p_report_id=>wwv_flow_api.id(574255467085884934)
,p_name=>'Drat'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Draft'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Draft''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#B1E5F5'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(574255207017884933)
,p_report_id=>wwv_flow_api.id(574255467085884934)
,p_name=>'Not Accepted'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Not Accepted'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Not Accepted''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(574255062100884933)
,p_report_id=>wwv_flow_api.id(574255467085884934)
,p_name=>'Return'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Return'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Return''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#CCE5FF'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(574255051541884933)
,p_report_id=>wwv_flow_api.id(574255467085884934)
,p_name=>'Reviewed'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Reviewed'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Reviewed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(574254871876884933)
,p_report_id=>wwv_flow_api.id(574255467085884934)
,p_name=>'In Review'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(129681243454728890)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(129305944900084303)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'New'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:10,11::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(519289928877516153)
,p_name=>'P1_YEAR'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(515377055446329497)
,p_item_default=>'extract(year from sysdate)'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Planning Year'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:2023;2023,2024;2024'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(515376912337329496)
,p_name=>'DP Year Changed DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_YEAR'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(515376842796329495)
,p_event_id=>wwv_flow_api.id(515376912337329496)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(131993307538426015)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(515376671515329494)
,p_event_id=>wwv_flow_api.id(515376912337329496)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(11482552839932280)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(515376647816329493)
,p_event_id=>wwv_flow_api.id(515376912337329496)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(122411222519330873)
);
wwv_flow_api.component_end;
end;
/
