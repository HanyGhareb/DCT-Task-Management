prompt --application/pages/page_00009
begin
--   Manifest
--     PAGE: 00009
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
 p_id=>9
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'DP Items'
,p_alias=>'DP-ITEMS'
,p_step_title=>'DP Items'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>To find data enter a search term into the search dialog, or click on the column headings to limit the records returned.</p>',
'',
'<p>You can perform numerous functions by clicking the <strong>Actions</strong> button. This includes selecting the columns that are displayed / hidden and their display sequence, plus numerous data and format functions.  You can also define additiona'
||'l views of the data using the chart, group by, and pivot options.</p>',
'',
'<p>If you want to save your customizations select report, or click download to unload the data. Enter you email address and time frame under subscription to be sent the data on a regular basis.<p>',
'',
'<p>For additional information click Help at the bottom of the Actions menu.</p> ',
'',
'<p>Click the <strong>Reset</strong> button to reset the interactive report back to the default settings.</p>'))
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230504055917'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(127993022593449389)
,p_plug_name=>'Items'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ITEM_ID,',
'       INITIATIVE_ID,',
'       PROJECT_NUMBER,',
'       PROJECT_NEW_YN,',
'       PROJECT_NEW_NAME,',
'       PROJECT_DESCRIPTION,',
'       CATEGORY_ID,',
'       SUB_CATEGORY_ID,',
'       ESTIMATED_DATE,',
'       ESTIMATED_MONTH,',
'       ESTIMATED_YEAR,',
'       ESTIMATED_QUARTER,',
'       ESTIMATED_QUARTER || ''-'' || ESTIMATED_YEAR Estimated_on,',
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
'       DP_SCOPING_ID',
'  from DP_ITEMS',
'   where (CREATED_BY = :PERSON_ID  or ',
'         :PERSON_ID in (select dip.person_id from dp_item_participants dip where dip.item_id = DP_ITEMS.item_id and status = ''A'' and sysdate between nvl(start_date , sysdate -10) and nvl(end_date , sysdate + 10)))',
' order by item_id desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'DP Items'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(127993194368449389)
,p_name=>'DP Items'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ITEM_ID,P11_PAGE_FROM:#ITEM_ID#,9'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>127993194368449389
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(127993563963449387)
,p_db_column_name=>'ITEM_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Item ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128519348998121514)
,p_db_column_name=>'DP_ITEM_NAME'
,p_display_order=>20
,p_column_identifier=>'AT'
,p_column_label=>'Demand Planning Item Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(127993937952449387)
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
 p_id=>wwv_flow_api.id(127994306534449387)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(127994778351449386)
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
 p_id=>wwv_flow_api.id(127995133293449386)
,p_db_column_name=>'PROJECT_NEW_NAME'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'New Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(127995516203449386)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(127995938562449386)
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
 p_id=>wwv_flow_api.id(127996391999449386)
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
 p_id=>wwv_flow_api.id(127996735689449385)
,p_db_column_name=>'ESTIMATED_DATE'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Estimated Date'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(127997190834449385)
,p_db_column_name=>'ESTIMATED_MONTH'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Estimated Month'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(127997588540449385)
,p_db_column_name=>'ESTIMATED_YEAR'
,p_display_order=>120
,p_column_identifier=>'K'
,p_column_label=>'Estimated Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(127997949296449385)
,p_db_column_name=>'ESTIMATED_QUARTER'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Estimated Quarter'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(127998361143449385)
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
 p_id=>wwv_flow_api.id(127998773877449384)
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
 p_id=>wwv_flow_api.id(127999123762449384)
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
 p_id=>wwv_flow_api.id(127999524805449384)
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
 p_id=>wwv_flow_api.id(127999994755449384)
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
 p_id=>wwv_flow_api.id(128000352602449384)
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
 p_id=>wwv_flow_api.id(128000715043449383)
,p_db_column_name=>'DP_PROCUREMENT_METHOD'
,p_display_order=>200
,p_column_identifier=>'S'
,p_column_label=>'Procurement Method'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128420668962241785)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128001106137449383)
,p_db_column_name=>'ESTIMATED_BUDGET'
,p_display_order=>210
,p_column_identifier=>'T'
,p_column_label=>'Estimated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128001587384449380)
,p_db_column_name=>'ESTIMATED_BUDGET_BRACKET_ID'
,p_display_order=>220
,p_column_identifier=>'U'
,p_column_label=>'Estimated Budget Bracket'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128001965167449380)
,p_db_column_name=>'PLANNING_STATUS'
,p_display_order=>230
,p_column_identifier=>'V'
,p_column_label=>'Planning Status'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128420883056239409)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128002347047449380)
,p_db_column_name=>'REVIEW_STATUS'
,p_display_order=>240
,p_column_identifier=>'W'
,p_column_label=>'Review Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128002751173449380)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>250
,p_column_identifier=>'X'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128003002777449380)
,p_db_column_name=>'CUTT_OFF_DATE'
,p_display_order=>260
,p_column_identifier=>'Y'
,p_column_label=>'Cutt-Off Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128003465888449379)
,p_db_column_name=>'NOTES'
,p_display_order=>270
,p_column_identifier=>'Z'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128003833064449379)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>280
,p_column_identifier=>'AA'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128004238051449379)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>290
,p_column_identifier=>'AB'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128004600225449379)
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
 p_id=>wwv_flow_api.id(128005078438449379)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>310
,p_column_identifier=>'AD'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128005462307449379)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>320
,p_column_identifier=>'AE'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128005868814449378)
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
 p_id=>wwv_flow_api.id(128006213850449378)
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
 p_id=>wwv_flow_api.id(128006654787449378)
,p_db_column_name=>'REVIEW_REJECT_ON'
,p_display_order=>350
,p_column_identifier=>'AH'
,p_column_label=>'Review Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128007006568449378)
,p_db_column_name=>'REJECT_ON'
,p_display_order=>360
,p_column_identifier=>'AI'
,p_column_label=>'Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128007481674449378)
,p_db_column_name=>'REVIEW_REJECT_REASON'
,p_display_order=>370
,p_column_identifier=>'AJ'
,p_column_label=>'Review Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128007811828449378)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>380
,p_column_identifier=>'AK'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128008215268449377)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>390
,p_column_identifier=>'AL'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128008600659449375)
,p_db_column_name=>'REVIEW_APPROVE_ON'
,p_display_order=>400
,p_column_identifier=>'AM'
,p_column_label=>'Review Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128009073165449375)
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
 p_id=>wwv_flow_api.id(128009469913449374)
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
 p_id=>wwv_flow_api.id(128009805940449374)
,p_db_column_name=>'SUBMIT_APPROVAL_ON'
,p_display_order=>430
,p_column_identifier=>'AP'
,p_column_label=>'Submit Approval On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128010253804449374)
,p_db_column_name=>'SUBMIT_REVIEW_ON'
,p_display_order=>440
,p_column_identifier=>'AQ'
,p_column_label=>'Submit Review On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(128010601428449374)
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
 p_id=>wwv_flow_api.id(128011093689449374)
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
 p_id=>wwv_flow_api.id(138256221485279225)
,p_db_column_name=>'COUNT_YEAR'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Count Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138256371066279226)
,p_db_column_name=>'COUNT_ITEM'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Count Item'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138256486330279227)
,p_db_column_name=>'DP_YEAR'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Dp Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138256587826279228)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138256646268279229)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138256718397279230)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138256809579279231)
,p_db_column_name=>'ESTIMATED_DATE_DEFINE'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Estimated Date Define'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138256997794279232)
,p_db_column_name=>'ESTIMATED_BUDGET_DEFINE'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Estimated Budget Define'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138257035479279233)
,p_db_column_name=>'INITIATIVE_NEW_YN'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'Initiative New Yn'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138257155671279234)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Initiative New Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138257245229279235)
,p_db_column_name=>'DP_ITEM_CODE'
,p_display_order=>570
,p_column_identifier=>'BE'
,p_column_label=>'DP Item Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138257391889279236)
,p_db_column_name=>'DP_SCOPING_ID'
,p_display_order=>580
,p_column_identifier=>'BF'
,p_column_label=>'Dp Scoping Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138257491845279237)
,p_db_column_name=>'ESTIMATED_ON'
,p_display_order=>590
,p_column_identifier=>'BG'
,p_column_label=>'Estimated On'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(128094454617449304)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1280945'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DP_ITEM_CODE:DP_ITEM_NAME:PROJECT_NUMBER:CATEGORY_ID:SUB_CATEGORY_ID:ESTIMATED_ON:DP_PROCUREMENT_METHOD:ESTIMATED_BUDGET:PLANNING_STATUS:REVIEW_STATUS:APPROVAL_STATUS:'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(138177733383501785)
,p_report_id=>wwv_flow_api.id(128094454617449304)
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
 p_id=>wwv_flow_api.id(138177373413501785)
,p_report_id=>wwv_flow_api.id(128094454617449304)
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
 p_id=>wwv_flow_api.id(138177013172501785)
,p_report_id=>wwv_flow_api.id(128094454617449304)
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
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(128012214823449373)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127813188296449776)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(127749711524449850)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(127867332295449731)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(127513732724599141)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(128012214823449373)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'New'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:10,11::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(128011466336449373)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(127993022593449389)
,p_button_name=>'RESET_REPORT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Reset'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:RR::'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.component_end;
end;
/
