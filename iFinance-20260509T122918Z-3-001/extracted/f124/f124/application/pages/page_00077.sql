prompt --application/pages/page_00077
begin
--   Manifest
--     PAGE: 00077
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
 p_id=>77
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'Drilldown - Demand Planning Dashboard'
,p_alias=>'DRILLDOWN-DEMAND-PLANNING-DASHBOARD'
,p_step_title=>'Drilldown - Demand Planning Dashboard'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230716162731'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(142040812879018647)
,p_plug_name=>'Draft Demand Planning Items'
,p_icon_css_classes=>'fa-clock-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P77_SHOW_REGION'
,p_plug_display_when_cond2=>'4'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(142040667801018646)
,p_plug_name=>'Draft Demand Planning Items Report'
,p_parent_plug_id=>wwv_flow_api.id(142040812879018647)
,p_icon_css_classes=>'fa-clock-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
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
'       (select nvl(count(*),0)',
'        from dp_items_reminders r',
'        where r.item_id = dp.item_id) Reminder_count,',
'       ''<span aria-hidden="true" class="fa fa-envelope-o fa-2x fam-information fam-is-info"></span>'' Reminder',
'  from DP_ITEMS dp, dp_items_sla_fact sl',
'  where dp.item_id = sl.item_id (+)',
'  and REVIEW_STATUS = ''Draft''',
'--  and APPROVAL_STATUS = ''Approved''',
'  and dp.dp_scoping_id is null',
'  order by dp.ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
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
 p_id=>wwv_flow_api.id(142040541527018645)
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
,p_internal_uid=>161481887725306937
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(142040528014018644)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Item ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(142040385045018643)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(142040249276018642)
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
 p_id=>wwv_flow_api.id(142040157960018641)
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
 p_id=>wwv_flow_api.id(142040032371018640)
,p_db_column_name=>'ESTIMATED_BUDGET_DEFINE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Estimated Budget Define ?'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(142040025642018639)
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
 p_id=>wwv_flow_api.id(142039846619018638)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'New Initiative Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(142039784568018637)
,p_db_column_name=>'DP_ITEM_CODE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'DP Item Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(142039687294018636)
,p_db_column_name=>'DP_SCOPING_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Dp Scoping Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(142039593662018635)
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
 p_id=>wwv_flow_api.id(142039524676018634)
,p_db_column_name=>'CONTRACT_NO'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Contract No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(142039372438018633)
,p_db_column_name=>'TOTAL_PROJECT_BUDGET'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Total Project Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(142039320795018632)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141484966020711181)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'New Task'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141484885296711180)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141484761118711179)
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
 p_id=>wwv_flow_api.id(141484720963711178)
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
 p_id=>wwv_flow_api.id(141484565210711177)
,p_db_column_name=>'PROJECT'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141484508789711176)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141484405953711175)
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
 p_id=>wwv_flow_api.id(141484230670711174)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141484185221711173)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141484070188711172)
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
 p_id=>wwv_flow_api.id(141483967845711171)
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
 p_id=>wwv_flow_api.id(141483899927711170)
,p_db_column_name=>'REVIEW_REJECT_ON'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Review Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141483734517711169)
,p_db_column_name=>'REJECT_ON'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141483705223711168)
,p_db_column_name=>'REVIEW_REJECT_REASON'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Review Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141483619449711167)
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
 p_id=>wwv_flow_api.id(141483469306711166)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141483401695711165)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141483238546711164)
,p_db_column_name=>'REVIEW_APPROVE_ON'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Review Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141483195724711163)
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
 p_id=>wwv_flow_api.id(141483117753711162)
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
 p_id=>wwv_flow_api.id(141482977363711161)
,p_db_column_name=>'SUBMIT_APPROVAL_ON'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Submit Approval On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141482862327711160)
,p_db_column_name=>'SUBMIT_REVIEW_ON'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Submit Review On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141482744541711159)
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
 p_id=>wwv_flow_api.id(141482707623711158)
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
 p_id=>wwv_flow_api.id(141482578425711157)
,p_db_column_name=>'DP_ITEM_NAME'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Demand Planning Item Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141482510545711156)
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
 p_id=>wwv_flow_api.id(141482380254711155)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141482310542711154)
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
 p_id=>wwv_flow_api.id(141482133847711153)
,p_db_column_name=>'PROJECT_NEW_NAME'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'New Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141482090361711152)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141481961887711151)
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
 p_id=>wwv_flow_api.id(141481898230711150)
,p_db_column_name=>'DUE_AFTER'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Late Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141481791418711149)
,p_db_column_name=>'SLA_DAYS'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'SLA Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141481711652711148)
,p_db_column_name=>'REMINDER'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Reminder'
,p_column_link=>'f?p=&APP_ID.:75:&SESSION.::&DEBUG.:75:P75_ITEM_ID,P75_PERSON_ID,P75_BUSINESS_OWNER:#ITEM_ID#,#END_USER_ID_H#,#END_USER_ID#'
,p_column_linktext=>'#REMINDER#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141481596591711147)
,p_db_column_name=>'END_USER_ID_H'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'End User Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141481523193711146)
,p_db_column_name=>'REMINDER_COUNT'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Reminder Count'
,p_column_link=>'f?p=&APP_ID.:78:&SESSION.::&DEBUG.::P78_ITEM_ID:#ITEM_ID#'
,p_column_linktext=>'#REMINDER_COUNT#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141481398301711145)
,p_db_column_name=>'SUB_CATEGORY_ID'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Sub Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449760929095476)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141481316243711144)
,p_db_column_name=>'ESTIMATED_DATE'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Estimated Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141481145864711143)
,p_db_column_name=>'ESTIMATED_MONTH'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Estimated Month'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141481105857711142)
,p_db_column_name=>'ESTIMATED_YEAR'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Estimated Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141480984629711141)
,p_db_column_name=>'ESTIMATED_QUARTER'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Estimated Quarter'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141480854858711140)
,p_db_column_name=>'END_USER_ID'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'End User'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141480816032711139)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128342316999489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141480690279711138)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>570
,p_column_identifier=>'BE'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341292413489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141480581001711137)
,p_db_column_name=>'DP_ITEM_TYPE_ID'
,p_display_order=>580
,p_column_identifier=>'BF'
,p_column_label=>'DP Item Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128416904318325983)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141480485262711136)
,p_db_column_name=>'RISK_ID'
,p_display_order=>590
,p_column_identifier=>'BG'
,p_column_label=>'Risk'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128420411111243936)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141480373024711135)
,p_db_column_name=>'PRIORITY_ID'
,p_display_order=>600
,p_column_identifier=>'BH'
,p_column_label=>'Priority'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341720324489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141480299179711134)
,p_db_column_name=>'DP_PROCUREMENT_METHOD'
,p_display_order=>610
,p_column_identifier=>'BI'
,p_column_label=>'Procurement Method'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128420668962241785)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141480155892711133)
,p_db_column_name=>'ESTIMATED_BUDGET'
,p_display_order=>620
,p_column_identifier=>'BJ'
,p_column_label=>'Estimated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141480116295711132)
,p_db_column_name=>'ESTIMATED_BUDGET_BRACKET_ID'
,p_display_order=>630
,p_column_identifier=>'BK'
,p_column_label=>'Estimated Budget Bracket'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141479954857711181)
,p_db_column_name=>'PLANNING_STATUS'
,p_display_order=>640
,p_column_identifier=>'BL'
,p_column_label=>'Planning Status'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128420883056239409)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141479863403711180)
,p_db_column_name=>'REVIEW_STATUS'
,p_display_order=>650
,p_column_identifier=>'BM'
,p_column_label=>'Review Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141479798897711179)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>660
,p_column_identifier=>'BN'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141479676482711178)
,p_db_column_name=>'CUTT_OFF_DATE'
,p_display_order=>670
,p_column_identifier=>'BO'
,p_column_label=>'Cutt-Off Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141479578548711177)
,p_db_column_name=>'NOTES'
,p_display_order=>680
,p_column_identifier=>'BP'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141479520169711176)
,p_db_column_name=>'COUNT_YEAR'
,p_display_order=>690
,p_column_identifier=>'BQ'
,p_column_label=>'Count Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141479388305711175)
,p_db_column_name=>'COUNT_ITEM'
,p_display_order=>700
,p_column_identifier=>'BR'
,p_column_label=>'Count Item'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141479286813711174)
,p_db_column_name=>'DP_YEAR'
,p_display_order=>710
,p_column_identifier=>'BS'
,p_column_label=>'Planning Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141479211883711173)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>720
,p_column_identifier=>'BT'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141479086974711172)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>730
,p_column_identifier=>'BU'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141452045486701666)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1620704'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DP_ITEM_CODE:END_USER_ID:SECTOR_ID:ESTIMATED_BUDGET:MAIN_CATEGORY_ID:PROJECT:PROJECT_NUMBER:SUB_CATEGORY_ID:ESTIMATED_DATE:PROJECT_DESCRIPTION:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(122410583363330867)
,p_plug_name=>'Projects Status'
,p_icon_css_classes=>'fa-clock-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P77_SHOW_REGION'
,p_plug_display_when_cond2=>'5'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(122410459575330866)
,p_plug_name=>'Projects Status Report'
,p_parent_plug_id=>wwv_flow_api.id(122410583363330867)
,p_icon_css_classes=>'fa-clock-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
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
'       dp_item_status_id,',
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
'       (select nvl(count(*),0)',
'        from dp_items_reminders r',
'        where r.item_id = dp.item_id) Reminder_count,',
'       ''<span aria-hidden="true" class="fa fa-envelope-o fa-2x fam-information fam-is-info"></span>'' Reminder',
'  from DP_ITEMS dp, dp_items_sla_fact sl',
'  where dp.item_id = sl.item_id (+)',
'  and dp_item_status_id = :P77_DP_ITEM_STATUS',
'  order by dp.ITEM_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P77_DP_ITEM_STATUS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
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
 p_id=>wwv_flow_api.id(122410409268330865)
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
,p_internal_uid=>181112019983994717
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122410246745330864)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Item ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122410168161330863)
,p_db_column_name=>'REVIEW_REJECT_REASON'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Review Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122410079993330862)
,p_db_column_name=>'CATEGORY_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(140752397958276427)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122409989876330861)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122409857479330860)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122409799563330859)
,p_db_column_name=>'REVIEW_APPROVE_ON'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Review Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122409649233330858)
,p_db_column_name=>'REVIEW_APPROVE_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Review Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122409583082330857)
,p_db_column_name=>'FINAL_APPROVE_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Final Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122409429333330856)
,p_db_column_name=>'SUBMIT_APPROVAL_ON'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Submit Approval On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122409383026330855)
,p_db_column_name=>'SUBMIT_REVIEW_ON'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Submit Review On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122409260372330854)
,p_db_column_name=>'SUBMIT_REVIEW_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Submit Review By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122409174454330853)
,p_db_column_name=>'SUBMIT_APPROVAL_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Submit Approval By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122409103301330852)
,p_db_column_name=>'DP_ITEM_NAME'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Demand Planning Item Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122408984819330851)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Initiative'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128335626861489802)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122408848936330850)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122408805074330849)
,p_db_column_name=>'PROJECT_NEW_YN'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Project New ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122408645534330848)
,p_db_column_name=>'PROJECT_NEW_NAME'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'New Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122408590108330847)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122408439057330846)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122408377971330845)
,p_db_column_name=>'DUE_AFTER'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Late Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122408255275330844)
,p_db_column_name=>'SLA_DAYS'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'SLA Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122408151979330843)
,p_db_column_name=>'REMINDER'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Reminder'
,p_column_link=>'f?p=&APP_ID.:75:&SESSION.::&DEBUG.:75:P75_ITEM_ID,P75_PERSON_ID,P75_BUSINESS_OWNER:#ITEM_ID#,#END_USER_ID_H#,#END_USER_ID#'
,p_column_linktext=>'#REMINDER#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122408125963330842)
,p_db_column_name=>'END_USER_ID_H'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'End User Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122407962171330841)
,p_db_column_name=>'REMINDER_COUNT'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Reminder Count'
,p_column_link=>'f?p=&APP_ID.:78:&SESSION.::&DEBUG.::P78_ITEM_ID:#ITEM_ID#'
,p_column_linktext=>'#REMINDER_COUNT#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122407915166330840)
,p_db_column_name=>'SUB_CATEGORY_ID'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Sub Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449760929095476)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122407820155330839)
,p_db_column_name=>'ESTIMATED_DATE'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Estimated Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122407643789330838)
,p_db_column_name=>'ESTIMATED_MONTH'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Estimated Month'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122407549612330837)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122407441776330836)
,p_db_column_name=>'ESTIMATED_YEAR'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Estimated Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122407420407330835)
,p_db_column_name=>'ESTIMATED_QUARTER'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Estimated Quarter'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122407289849330834)
,p_db_column_name=>'END_USER_ID'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'End User'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122407171501330833)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128342316999489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122407033039330832)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341292413489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122328562926839681)
,p_db_column_name=>'DP_ITEM_TYPE_ID'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'DP Item Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128416904318325983)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122328453856839680)
,p_db_column_name=>'RISK_ID'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Risk'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128420411111243936)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122328344779839679)
,p_db_column_name=>'PRIORITY_ID'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Priority'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341720324489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122328275436839678)
,p_db_column_name=>'DP_PROCUREMENT_METHOD'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Procurement Method'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128420668962241785)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122328179855839677)
,p_db_column_name=>'ESTIMATED_BUDGET'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Estimated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122328109640839676)
,p_db_column_name=>'ESTIMATED_BUDGET_BRACKET_ID'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Estimated Budget Bracket'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122328020328839675)
,p_db_column_name=>'PLANNING_STATUS'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Planning Status'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128420883056239409)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122327870862839674)
,p_db_column_name=>'REVIEW_STATUS'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Review Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122327810148839673)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122327643717839672)
,p_db_column_name=>'CUTT_OFF_DATE'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Cutt-Off Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122327576234839671)
,p_db_column_name=>'NOTES'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122327506387839670)
,p_db_column_name=>'COUNT_YEAR'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Count Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122327420902839669)
,p_db_column_name=>'COUNT_ITEM'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Count Item'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122327278763839668)
,p_db_column_name=>'DP_YEAR'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Planning Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122327165404839667)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122327124431839666)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122326949366839665)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122326834472839664)
,p_db_column_name=>'ESTIMATED_DATE_DEFINE'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Estimated Date Define ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122326754117839663)
,p_db_column_name=>'ESTIMATED_BUDGET_DEFINE'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Estimated Budget Define ?'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122326690971839662)
,p_db_column_name=>'INITIATIVE_NEW_YN'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'New Initiative ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122326586803839661)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'New Initiative Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122326501899839660)
,p_db_column_name=>'DP_ITEM_CODE'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'DP Item Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122326365276839659)
,p_db_column_name=>'DP_SCOPING_ID'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Dp Scoping Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122326295711839658)
,p_db_column_name=>'MAIN_CATEGORY_ID'
,p_display_order=>570
,p_column_identifier=>'BE'
,p_column_label=>'Main Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449582832098954)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122326132161839657)
,p_db_column_name=>'CONTRACT_NO'
,p_display_order=>580
,p_column_identifier=>'BF'
,p_column_label=>'Contract No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122326054599839656)
,p_db_column_name=>'TOTAL_PROJECT_BUDGET'
,p_display_order=>590
,p_column_identifier=>'BG'
,p_column_label=>'Total Project Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122325935611839655)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>600
,p_column_identifier=>'BH'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122325878308839654)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>610
,p_column_identifier=>'BI'
,p_column_label=>'New Task'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122325806768839653)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>620
,p_column_identifier=>'BJ'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122325725665839652)
,p_db_column_name=>'EXPENDITURE_TYPE_NEW'
,p_display_order=>630
,p_column_identifier=>'BK'
,p_column_label=>'New Expenditure Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122325621936839651)
,p_db_column_name=>'TASK_NEW_YN'
,p_display_order=>640
,p_column_identifier=>'BL'
,p_column_label=>'Task New ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122325472738839650)
,p_db_column_name=>'PROJECT'
,p_display_order=>650
,p_column_identifier=>'BM'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122325359663839649)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>660
,p_column_identifier=>'BN'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122325314889839648)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>670
,p_column_identifier=>'BO'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122325214609839647)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>680
,p_column_identifier=>'BP'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122325030182839646)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>690
,p_column_identifier=>'BQ'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122325004703839645)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>700
,p_column_identifier=>'BR'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122324889970839644)
,p_db_column_name=>'REVIEW_REJECTED_BY'
,p_display_order=>710
,p_column_identifier=>'BS'
,p_column_label=>'Review Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122324781889839643)
,p_db_column_name=>'REVIEW_REJECT_ON'
,p_display_order=>720
,p_column_identifier=>'BT'
,p_column_label=>'Review Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122324703724839642)
,p_db_column_name=>'REJECT_ON'
,p_display_order=>730
,p_column_identifier=>'BU'
,p_column_label=>'Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122324556315839641)
,p_db_column_name=>'DP_ITEM_STATUS_ID'
,p_display_order=>740
,p_column_identifier=>'BV'
,p_column_label=>'Project Status'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(122786651982504967)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(122299560126777789)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1812229'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DP_ITEM_CODE:PROJECT_NUMBER:PROJECT_DESCRIPTION:MAIN_CATEGORY_ID:SUB_CATEGORY_ID:DP_PROCUREMENT_METHOD:ESTIMATED_BUDGET:PLANNING_STATUS:REVIEW_STATUS:APPROVAL_STATUS:DP_ITEM_STATUS_ID:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11677746670441308)
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
 p_id=>wwv_flow_api.id(11678340404441308)
,p_plug_name=>'All Demand Planning Items'
,p_icon_css_classes=>'fa-dial-gauge-chart'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P77_SHOW_REGION'
,p_plug_display_when_cond2=>'1'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(287933176748935480)
,p_plug_name=>'All Demand Planning Items Report'
,p_parent_plug_id=>wwv_flow_api.id(11678340404441308)
,p_icon_css_classes=>'fa-dial-gauge-chart'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>60
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
'       (select nvl(count(*),0)',
'        from dp_items_reminders r',
'        where r.item_id = dp.item_id) Reminder_count',
'  from DP_ITEMS dp',
' order by ITEM_ID DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
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
 p_id=>wwv_flow_api.id(287933442229935482)
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
,p_internal_uid=>432135611203991446
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11742023845453504)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Item ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11742412660453504)
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
 p_id=>wwv_flow_api.id(11742818186453504)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11743169295453505)
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
 p_id=>wwv_flow_api.id(11743581051453505)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11743947853453505)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11744366108453505)
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
 p_id=>wwv_flow_api.id(11744788774453505)
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
 p_id=>wwv_flow_api.id(11745133086453506)
,p_db_column_name=>'REVIEW_REJECT_ON'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Review Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11745589701453506)
,p_db_column_name=>'REJECT_ON'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
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
 p_id=>wwv_flow_api.id(11745960967453506)
,p_db_column_name=>'REVIEW_REJECT_REASON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Review Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11746359856453506)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11746816333453506)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11747210172453507)
,p_db_column_name=>'REVIEW_APPROVE_ON'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Review Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11747603329453507)
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
 p_id=>wwv_flow_api.id(11748020059453507)
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
 p_id=>wwv_flow_api.id(11748412098453507)
,p_db_column_name=>'SUBMIT_APPROVAL_ON'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Submit Approval On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11748786860453507)
,p_db_column_name=>'SUBMIT_REVIEW_ON'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Submit Review On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11749175796453508)
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
 p_id=>wwv_flow_api.id(11749533742453508)
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
 p_id=>wwv_flow_api.id(11750024099453508)
,p_db_column_name=>'DP_ITEM_NAME'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Demand Planning Item Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11750418415453508)
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
 p_id=>wwv_flow_api.id(11750784615453508)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11751212867453509)
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
 p_id=>wwv_flow_api.id(11751534913453509)
,p_db_column_name=>'PROJECT_NEW_NAME'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'New Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11751944013453509)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11752428433453509)
,p_db_column_name=>'CATEGORY_ID'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Main Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449582832098954)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11752828240453518)
,p_db_column_name=>'SUB_CATEGORY_ID'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Sub Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449760929095476)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11753173556453519)
,p_db_column_name=>'ESTIMATED_DATE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Estimated Date'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11753541193453519)
,p_db_column_name=>'ESTIMATED_MONTH'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Estimated Month'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11753963804453519)
,p_db_column_name=>'ESTIMATED_YEAR'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Estimated Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11754387727453520)
,p_db_column_name=>'ESTIMATED_QUARTER'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Estimated Quarter'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11754798945453520)
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
 p_id=>wwv_flow_api.id(11755221155453520)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128342316999489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11755594090453520)
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
 p_id=>wwv_flow_api.id(11755947170453520)
,p_db_column_name=>'DP_ITEM_TYPE_ID'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'DP Item Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128416904318325983)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11756373755453521)
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
 p_id=>wwv_flow_api.id(11756761062453521)
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
 p_id=>wwv_flow_api.id(11757185505453521)
,p_db_column_name=>'DP_PROCUREMENT_METHOD'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Procurement Method'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128420668962241785)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11757607412453521)
,p_db_column_name=>'ESTIMATED_BUDGET'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Estimated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11758011635453521)
,p_db_column_name=>'ESTIMATED_BUDGET_BRACKET_ID'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Estimated Budget Bracket'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11758346038453522)
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
 p_id=>wwv_flow_api.id(11758819833453522)
,p_db_column_name=>'REVIEW_STATUS'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Review Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11759159083453522)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11759617561453522)
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
 p_id=>wwv_flow_api.id(11759970496453522)
,p_db_column_name=>'NOTES'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11760354412453523)
,p_db_column_name=>'COUNT_YEAR'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Count Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11760776696453523)
,p_db_column_name=>'COUNT_ITEM'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Count Item'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11761216711453523)
,p_db_column_name=>'DP_YEAR'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Planning Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11761550022453523)
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
 p_id=>wwv_flow_api.id(11761980703453523)
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
 p_id=>wwv_flow_api.id(11762409391453524)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11762829506453524)
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
 p_id=>wwv_flow_api.id(11763222886453524)
,p_db_column_name=>'ESTIMATED_BUDGET_DEFINE'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Estimated Budget Define ?'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11763619463453524)
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
 p_id=>wwv_flow_api.id(11763987694453524)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'New Initiative Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11764331359453525)
,p_db_column_name=>'DP_ITEM_CODE'
,p_display_order=>570
,p_column_identifier=>'BE'
,p_column_label=>'DP Item Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11738019692453502)
,p_db_column_name=>'DP_SCOPING_ID'
,p_display_order=>580
,p_column_identifier=>'BF'
,p_column_label=>'Dp Scoping Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11738412167453502)
,p_db_column_name=>'MAIN_CATEGORY_ID'
,p_display_order=>590
,p_column_identifier=>'BG'
,p_column_label=>'Main Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(128449582832098954)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11738753051453502)
,p_db_column_name=>'CONTRACT_NO'
,p_display_order=>600
,p_column_identifier=>'BH'
,p_column_label=>'Contract No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11739134818453502)
,p_db_column_name=>'TOTAL_PROJECT_BUDGET'
,p_display_order=>610
,p_column_identifier=>'BI'
,p_column_label=>'Total Project Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11739531542453503)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>620
,p_column_identifier=>'BJ'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11740025354453503)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>630
,p_column_identifier=>'BK'
,p_column_label=>'New Task'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11740398163453503)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>640
,p_column_identifier=>'BL'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11740732193453503)
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
 p_id=>wwv_flow_api.id(11741218294453504)
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
 p_id=>wwv_flow_api.id(11741556822453504)
,p_db_column_name=>'PROJECT'
,p_display_order=>670
,p_column_identifier=>'BO'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11482992982932284)
,p_db_column_name=>'REMINDER_COUNT'
,p_display_order=>680
,p_column_identifier=>'BP'
,p_column_label=>'Reminder Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(289010378418414029)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1559669'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DP_ITEM_CODE:PROJECT:END_USER_ID:DP_PROCUREMENT_METHOD:ESTIMATED_BUDGET:PLANNING_STATUS:REVIEW_STATUS:APPROVAL_STATUS::REMINDER_COUNT'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(11765221226453525)
,p_report_id=>wwv_flow_api.id(289010378418414029)
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
 p_id=>wwv_flow_api.id(11765538657453526)
,p_report_id=>wwv_flow_api.id(289010378418414029)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11678755950441309)
,p_plug_name=>'Late Demand Planning Items'
,p_icon_css_classes=>'fa-clock-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent9:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P77_SHOW_REGION'
,p_plug_display_when_cond2=>'3'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(167120482409171256)
,p_plug_name=>'Late Demand Planning Items Report'
,p_parent_plug_id=>wwv_flow_api.id(11678755950441309)
,p_icon_css_classes=>'fa-clock-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>50
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
'       (select nvl(count(*),0)',
'        from dp_items_reminders r',
'        where r.item_id = dp.item_id) Reminder_count,',
'       ''<span aria-hidden="true" class="fa fa-envelope-o fa-2x fam-information fam-is-info"></span>'' Reminder',
'  from DP_ITEMS dp, dp_items_sla_fact sl',
'  where dp.item_id = sl.item_id (+)',
'  and REVIEW_STATUS = ''Reviewed''',
'  and APPROVAL_STATUS = ''Approved''',
'  and dp.dp_scoping_id is null',
' and trunc((sysdate - sl.sla_date)) between 0 and 99999',
'  order by trunc(sysdate - sl.sla_date) desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
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
 p_id=>wwv_flow_api.id(167120553459171257)
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
,p_internal_uid=>311322722433227221
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11708551798450936)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Item ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11709009691450937)
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
 p_id=>wwv_flow_api.id(11709425505450938)
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
 p_id=>wwv_flow_api.id(11709784567450938)
,p_db_column_name=>'ESTIMATED_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Estimated Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11710149468450939)
,p_db_column_name=>'ESTIMATED_MONTH'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Estimated Month'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11710620772450940)
,p_db_column_name=>'ESTIMATED_YEAR'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Estimated Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11710967112450941)
,p_db_column_name=>'ESTIMATED_QUARTER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Estimated Quarter'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11711350113450941)
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
 p_id=>wwv_flow_api.id(11711783314450942)
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
 p_id=>wwv_flow_api.id(11712163583450942)
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
 p_id=>wwv_flow_api.id(11712534666450943)
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
 p_id=>wwv_flow_api.id(11712945247450944)
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
 p_id=>wwv_flow_api.id(11713390352450944)
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
 p_id=>wwv_flow_api.id(11713800769450945)
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
 p_id=>wwv_flow_api.id(11714141265450946)
,p_db_column_name=>'ESTIMATED_BUDGET'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Estimated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11714536042450946)
,p_db_column_name=>'ESTIMATED_BUDGET_BRACKET_ID'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Estimated Budget Bracket'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11714936999450949)
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
 p_id=>wwv_flow_api.id(11715398645450950)
,p_db_column_name=>'REVIEW_STATUS'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Review Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11715791497450950)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11716133444450951)
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
 p_id=>wwv_flow_api.id(11716570622450952)
,p_db_column_name=>'NOTES'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11716938512450952)
,p_db_column_name=>'COUNT_YEAR'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Count Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11717408506450953)
,p_db_column_name=>'COUNT_ITEM'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Count Item'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11717760288450954)
,p_db_column_name=>'DP_YEAR'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Planning Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11718182601450954)
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
 p_id=>wwv_flow_api.id(11718624420450955)
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
 p_id=>wwv_flow_api.id(11718931590450955)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
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
 p_id=>wwv_flow_api.id(11719339926450956)
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
 p_id=>wwv_flow_api.id(11719758772450957)
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
 p_id=>wwv_flow_api.id(11720051363450957)
,p_db_column_name=>'ESTIMATED_BUDGET_DEFINE'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Estimated Budget Define ?'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11720460672450958)
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
 p_id=>wwv_flow_api.id(11720911495450958)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'New Initiative Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11721296850450959)
,p_db_column_name=>'DP_ITEM_CODE'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'DP Item Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11721662016450960)
,p_db_column_name=>'DP_SCOPING_ID'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Dp Scoping Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11722033758450960)
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
 p_id=>wwv_flow_api.id(11722509952450961)
,p_db_column_name=>'CONTRACT_NO'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Contract No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11722885619450961)
,p_db_column_name=>'TOTAL_PROJECT_BUDGET'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Total Project Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11723277388450962)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11723647012450963)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'New Task'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11724055007450963)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11724460226450964)
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
 p_id=>wwv_flow_api.id(11724912259450970)
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
 p_id=>wwv_flow_api.id(11725301685450970)
,p_db_column_name=>'PROJECT'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11725700222450971)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11726069554450972)
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
 p_id=>wwv_flow_api.id(11726526589450972)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11726913901450973)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11727308028450973)
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
 p_id=>wwv_flow_api.id(11727708739450974)
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
 p_id=>wwv_flow_api.id(11728096464450975)
,p_db_column_name=>'REVIEW_REJECT_ON'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Review Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11728521884450975)
,p_db_column_name=>'REJECT_ON'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11728871618450976)
,p_db_column_name=>'REVIEW_REJECT_REASON'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Review Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11729277307450977)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11729718385450977)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11730074488450978)
,p_db_column_name=>'REVIEW_APPROVE_ON'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'Review Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11730480046450978)
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
 p_id=>wwv_flow_api.id(11730863085450979)
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
 p_id=>wwv_flow_api.id(11731258378450980)
,p_db_column_name=>'SUBMIT_APPROVAL_ON'
,p_display_order=>580
,p_column_identifier=>'BF'
,p_column_label=>'Submit Approval On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11731679521450981)
,p_db_column_name=>'SUBMIT_REVIEW_ON'
,p_display_order=>590
,p_column_identifier=>'BG'
,p_column_label=>'Submit Review On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11732111489450981)
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
 p_id=>wwv_flow_api.id(11732461901450982)
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
 p_id=>wwv_flow_api.id(11732874813450983)
,p_db_column_name=>'DP_ITEM_NAME'
,p_display_order=>620
,p_column_identifier=>'BJ'
,p_column_label=>'Demand Planning Item Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11733245974450983)
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
 p_id=>wwv_flow_api.id(11733646182450984)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>640
,p_column_identifier=>'BL'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11734041714450984)
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
 p_id=>wwv_flow_api.id(11734485506450985)
,p_db_column_name=>'PROJECT_NEW_NAME'
,p_display_order=>660
,p_column_identifier=>'BN'
,p_column_label=>'New Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11734845698450985)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>670
,p_column_identifier=>'BO'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11735306348450986)
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
 p_id=>wwv_flow_api.id(11735649997450987)
,p_db_column_name=>'DUE_AFTER'
,p_display_order=>690
,p_column_identifier=>'BQ'
,p_column_label=>'Late Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11736034559450987)
,p_db_column_name=>'SLA_DAYS'
,p_display_order=>700
,p_column_identifier=>'BR'
,p_column_label=>'SLA Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11736484849450988)
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
 p_id=>wwv_flow_api.id(11736863950450989)
,p_db_column_name=>'END_USER_ID_H'
,p_display_order=>720
,p_column_identifier=>'BT'
,p_column_label=>'End User Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11482862533932283)
,p_db_column_name=>'REMINDER_COUNT'
,p_display_order=>730
,p_column_identifier=>'BU'
,p_column_label=>'Reminder Count'
,p_column_link=>'f?p=&APP_ID.:78:&SESSION.::&DEBUG.::P78_ITEM_ID:#ITEM_ID#'
,p_column_linktext=>'#REMINDER_COUNT#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(167316954435019808)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1559394'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DP_ITEM_CODE:END_USER_ID:SECTOR_ID:ESTIMATED_BUDGET:DUE_DATE:DUE_AFTER:SLA_DAYS:REMINDER_COUNT:REMINDER:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11679150410441309)
,p_plug_name=>'On Risk Demand Planning Items'
,p_icon_css_classes=>'fa-crosshairs'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent9:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P77_SHOW_REGION'
,p_plug_display_when_cond2=>'2'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(167266930114010775)
,p_plug_name=>'Risk Demand Planning Items Report'
,p_parent_plug_id=>wwv_flow_api.id(11679150410441309)
,p_icon_css_classes=>'fa-clock-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>40
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
'       sl.sla_days,',
'       (select nvl(count(*),0)',
'        from dp_items_reminders r',
'        where r.item_id = dp.item_id) Reminder_count,',
'        ''<span aria-hidden="true" class="fa fa-envelope-o fa-2x fam-information fam-is-info"></span>'' Reminder',
'  from DP_ITEMS dp, dp_items_sla_fact sl',
'  where dp.item_id = sl.item_id (+)',
'  and REVIEW_STATUS = ''Reviewed''',
'  and APPROVAL_STATUS = ''Approved''',
'  and dp.dp_scoping_id is null',
'  and trunc((sl.sla_date - sysdate)) between  0 and 7',
'  order by trunc(sysdate - sl.sla_date) desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
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
 p_id=>wwv_flow_api.id(167267024511010776)
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
,p_internal_uid=>311469193485066740
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11679841930448237)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Item ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11680235084448238)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11680631779448238)
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
 p_id=>wwv_flow_api.id(11681091099448238)
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
 p_id=>wwv_flow_api.id(11681528042448238)
,p_db_column_name=>'ESTIMATED_BUDGET_DEFINE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Estimated Budget Define ?'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11681853403448239)
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
 p_id=>wwv_flow_api.id(11682245809448239)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'New Initiative Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11682715191448239)
,p_db_column_name=>'DP_ITEM_CODE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'DP Item Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11683070610448239)
,p_db_column_name=>'DP_SCOPING_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Dp Scoping Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11683458358448240)
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
 p_id=>wwv_flow_api.id(11683920507448240)
,p_db_column_name=>'CONTRACT_NO'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Contract No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11684293657448240)
,p_db_column_name=>'TOTAL_PROJECT_BUDGET'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Total Project Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11684723806448240)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11685074605448240)
,p_db_column_name=>'TASK_NUMBER_NEW'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'New Task'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11685509323448241)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11685884600448241)
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
 p_id=>wwv_flow_api.id(11686247537448241)
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
 p_id=>wwv_flow_api.id(11686672351448241)
,p_db_column_name=>'PROJECT'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11687122375448241)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11687525076448242)
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
 p_id=>wwv_flow_api.id(11687915907448242)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11688253608448242)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11688677117448242)
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
 p_id=>wwv_flow_api.id(11689111227448242)
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
 p_id=>wwv_flow_api.id(11689522396448243)
,p_db_column_name=>'REVIEW_REJECT_ON'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Review Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11689907594448243)
,p_db_column_name=>'REJECT_ON'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11690283952448243)
,p_db_column_name=>'REVIEW_REJECT_REASON'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Review Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11690681161448243)
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
 p_id=>wwv_flow_api.id(11691093788448243)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11691437952448244)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11691870415448244)
,p_db_column_name=>'REVIEW_APPROVE_ON'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Review Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11692258568448244)
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
 p_id=>wwv_flow_api.id(11692656728448244)
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
 p_id=>wwv_flow_api.id(11693046821448244)
,p_db_column_name=>'SUBMIT_APPROVAL_ON'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Submit Approval On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11693478956448245)
,p_db_column_name=>'SUBMIT_REVIEW_ON'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Submit Review On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11693892427448245)
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
 p_id=>wwv_flow_api.id(11694250265448245)
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
 p_id=>wwv_flow_api.id(11694708522448245)
,p_db_column_name=>'DP_ITEM_NAME'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Demand Planning Item Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11695120735448245)
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
 p_id=>wwv_flow_api.id(11695497866448246)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11695834308448246)
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
 p_id=>wwv_flow_api.id(11696325511448246)
,p_db_column_name=>'PROJECT_NEW_NAME'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'New Project Name'
,p_column_type=>'STRING'
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
 p_id=>wwv_flow_api.id(11696640151448246)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11697098958448246)
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
 p_id=>wwv_flow_api.id(11697434213448247)
,p_db_column_name=>'DUE_AFTER'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Late Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11697852517448247)
,p_db_column_name=>'SLA_DAYS'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'SLA Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11698293978448247)
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
 p_id=>wwv_flow_api.id(11698717098448247)
,p_db_column_name=>'ESTIMATED_DATE'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Estimated Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11699127391448248)
,p_db_column_name=>'ESTIMATED_MONTH'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Estimated Month'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11699436391448248)
,p_db_column_name=>'ESTIMATED_YEAR'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Estimated Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11699897078448248)
,p_db_column_name=>'ESTIMATED_QUARTER'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Estimated Quarter'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11700294504448248)
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
 p_id=>wwv_flow_api.id(11700680841448248)
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
 p_id=>wwv_flow_api.id(11701079576448249)
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
 p_id=>wwv_flow_api.id(11701522061448249)
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
 p_id=>wwv_flow_api.id(11701858450448249)
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
 p_id=>wwv_flow_api.id(11702268126448249)
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
 p_id=>wwv_flow_api.id(11702680958448249)
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
 p_id=>wwv_flow_api.id(11703110565448250)
,p_db_column_name=>'ESTIMATED_BUDGET'
,p_display_order=>590
,p_column_identifier=>'BG'
,p_column_label=>'Estimated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11703478459448250)
,p_db_column_name=>'ESTIMATED_BUDGET_BRACKET_ID'
,p_display_order=>600
,p_column_identifier=>'BH'
,p_column_label=>'Estimated Budget Bracket'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11703862891448250)
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
 p_id=>wwv_flow_api.id(11704263689448250)
,p_db_column_name=>'REVIEW_STATUS'
,p_display_order=>620
,p_column_identifier=>'BJ'
,p_column_label=>'Review Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11704658446448250)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>630
,p_column_identifier=>'BK'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11705110050448251)
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
 p_id=>wwv_flow_api.id(11705524172448251)
,p_db_column_name=>'NOTES'
,p_display_order=>650
,p_column_identifier=>'BM'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11705833533448251)
,p_db_column_name=>'COUNT_YEAR'
,p_display_order=>660
,p_column_identifier=>'BN'
,p_column_label=>'Count Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11706262988448251)
,p_db_column_name=>'COUNT_ITEM'
,p_display_order=>670
,p_column_identifier=>'BO'
,p_column_label=>'Count Item'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11706640923448251)
,p_db_column_name=>'DP_YEAR'
,p_display_order=>680
,p_column_identifier=>'BP'
,p_column_label=>'Planning Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11707056921448252)
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
 p_id=>wwv_flow_api.id(11707517033448252)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>700
,p_column_identifier=>'BR'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11483045171932285)
,p_db_column_name=>'REMINDER_COUNT'
,p_display_order=>710
,p_column_identifier=>'BS'
,p_column_label=>'Reminder Count'
,p_column_link=>'f?p=&APP_ID.:78:&SESSION.::&DEBUG.::P78_ITEM_ID:#ITEM_ID#'
,p_column_linktext=>'#REMINDER_COUNT#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11783973624846438)
,p_db_column_name=>'REMINDER'
,p_display_order=>720
,p_column_identifier=>'BT'
,p_column_label=>'Reminder'
,p_column_link=>'f?p=&APP_ID.:75:&SESSION.::&DEBUG.:75:P75_ITEM_ID,P75_PERSON_ID,P75_BUSINESS_OWNER:#ITEM_ID#,#END_USER_ID_H#,#END_USER_ID#'
,p_column_linktext=>'#REMINDER#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11784122921846439)
,p_db_column_name=>'END_USER_ID_H'
,p_display_order=>730
,p_column_identifier=>'BU'
,p_column_label=>'End User Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(167386741108446165)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1559100'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DP_ITEM_CODE:END_USER_ID:SECTOR_ID:ESTIMATED_BUDGET:DUE_DATE:DUE_AFTER:REMINDER_COUNT:REMINDER:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11482732673932282)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11677746670441308)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:77::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(122410701540330868)
,p_name=>'P77_DP_ITEM_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11677746670441308)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11482712455932281)
,p_name=>'P77_SHOW_REGION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11677746670441308)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
