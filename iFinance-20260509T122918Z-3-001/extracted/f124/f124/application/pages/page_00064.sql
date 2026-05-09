prompt --application/pages/page_00064
begin
--   Manifest
--     PAGE: 00064
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
 p_id=>64
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'DP Scoping Documents Home Page '
,p_alias=>'DP-SCOPING-DOCUMENTS-HOME-PAGE'
,p_step_title=>'DP Scoping Documents Home Page '
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240220094238'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(144549081521923440)
,p_plug_name=>'My Scoping Documents'
,p_icon_css_classes=>'fa-user-check'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    dps.scope_id,',
'    dps.scope_code,',
'    dps.dp_item_id,',
'    dps.project_name,',
'    dps.project_code,',
'    dps.project_number,',
'    dps.date_required,',
'    dps.main_category_id,',
'    dps.category_id,',
'    dps.sub_category_id,',
'    dps.rfp_ref_number,',
'    dps.expected_start_date,',
'    dps.expected_end_date,',
'    dps.tender_start_date,',
'    dps.tender_end_date,',
'    dps.technical_submission_id,',
'    dps.review_status,',
'    dps.approval_status,',
'    dps.template_id,',
'-- DP_ITEMS',
'    dpi.INITIATIVE_ID, ',
'    dpi.PROJECT_DESCRIPTION, ',
'    dpi.ESTIMATED_DATE, ',
'    dpi.ESTIMATED_YEAR, ',
'    dpi.ESTIMATED_QUARTER, ',
'    dpi.END_USER_ID, ',
'    dpi.SECTOR_ID, ',
'    dpi.DEPARTMENT_ID, ',
'    dpi.DP_ITEM_TYPE_ID, ',
'    dpi.RISK_ID, ',
'    dpi.PRIORITY_ID, ',
'    dpi.DP_PROCUREMENT_METHOD, ',
'    dpi.ESTIMATED_BUDGET, ',
'    dpi.ESTIMATED_BUDGET_BRACKET_ID, ',
'    dpi.PLANNING_STATUS, ',
'    dpi.REVIEW_STATUS               DP_ITEM_REVIEW_STATUS, ',
'    dpi.APPROVAL_STATUS             DP_ITEM_APPROVAL_STATUS, ',
'    dpi.CUTT_OFF_DATE, ',
'    dpi.NOTES, ',
'    dpi.DP_ITEM_NAME, ',
'    dpi.DP_YEAR, ',
'    dpi.INITIATIVE_NEW_YN, ',
'    dpi.INITIATIVE_NEW_NAME, ',
'    dpi.DP_ITEM_CODE, ',
'    dpi.CONTRACT_NO',
'FROM',
'    dp_scoping_a  dps,',
'    dp_items      dpi',
'WHERE',
'    dps.dp_item_id = dpi.item_id',
'and (select decode(count(*) , 0 , ''N'' , ''Y'')',
'from dp_item_participants',
'where status = ''A'' ',
'and sysdate between nvl(start_date , sysdate - 10)',
'and nvl(end_date , sysdate + 10)',
'and item_id = :P11_ITEM_ID',
'and :PERSON_ID = person_id) = ''Y'' ',
'order by dps.scope_id desc ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(144548944738923439)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'You don''t have any SoW documents yet.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL'
,p_detail_link=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_SCOPE_ID:#SCOPE_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>158973484513402143
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144548897163923438)
,p_db_column_name=>'SCOPE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Scope'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(138404640303341881)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144548789793923437)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341292413489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144548634162923436)
,p_db_column_name=>'DP_ITEM_TYPE_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'DP Item Type '
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128416904318325983)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144548555294923435)
,p_db_column_name=>'RISK_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Risk'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128420411111243936)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144548474671923434)
,p_db_column_name=>'PRIORITY_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Priority'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128341720324489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144548368423923433)
,p_db_column_name=>'DP_PROCUREMENT_METHOD'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Procurement Method'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128420668962241785)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144548273808923432)
,p_db_column_name=>'ESTIMATED_BUDGET'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Estimated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144171754578791281)
,p_db_column_name=>'ESTIMATED_BUDGET_BRACKET_ID'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Estimated Budget Bracket '
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(129510087609156996)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144171691063791280)
,p_db_column_name=>'PLANNING_STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Planning Status'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128420883056239409)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144171597674791279)
,p_db_column_name=>'DP_ITEM_REVIEW_STATUS'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'DP Item Review Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144171524606791278)
,p_db_column_name=>'DP_ITEM_APPROVAL_STATUS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'DP Item Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144171366362791277)
,p_db_column_name=>'CUTT_OFF_DATE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Cut-Off Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144171248906791276)
,p_db_column_name=>'NOTES'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144171167398791275)
,p_db_column_name=>'DP_ITEM_NAME'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'DP Item Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144171046230791274)
,p_db_column_name=>'DP_YEAR'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'DP Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144170936016791273)
,p_db_column_name=>'INITIATIVE_NEW_YN'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Initiative New ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144170894525791272)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Initiative New Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144170767468791271)
,p_db_column_name=>'DP_ITEM_CODE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'DP Item Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144170635029791270)
,p_db_column_name=>'CONTRACT_NO'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Contract No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144170583763791269)
,p_db_column_name=>'SCOPE_CODE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Scope Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144170451414791268)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144170399495791267)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144170281632791266)
,p_db_column_name=>'PROJECT_CODE'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Project Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144170184857791265)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144170051302791264)
,p_db_column_name=>'DATE_REQUIRED'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Date Required'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144169968753791263)
,p_db_column_name=>'MAIN_CATEGORY_ID'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Main Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449582832098954)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144169880718791262)
,p_db_column_name=>'CATEGORY_ID'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(140752397958276427)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144169812150791261)
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
 p_id=>wwv_flow_api.id(144169695280791260)
,p_db_column_name=>'RFP_REF_NUMBER'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'RFP Ref Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144169588869791259)
,p_db_column_name=>'EXPECTED_START_DATE'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Expected Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144169528943791258)
,p_db_column_name=>'EXPECTED_END_DATE'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Expected End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144169374408791257)
,p_db_column_name=>'TENDER_START_DATE'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Tender Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144169294267791256)
,p_db_column_name=>'TENDER_END_DATE'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Tender End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144169197954791255)
,p_db_column_name=>'TECHNICAL_SUBMISSION_ID'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Technical Submission'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(138190893143257226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144169074401791254)
,p_db_column_name=>'REVIEW_STATUS'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Review Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144168940363791253)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144168866484791252)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Scoping Template'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(138404640303341881)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144168783123791251)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Initiative'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128335626861489802)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144168728472791250)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144168593651791249)
,p_db_column_name=>'ESTIMATED_DATE'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Estimated Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144168499845791248)
,p_db_column_name=>'ESTIMATED_YEAR'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Estimated Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144168367914791247)
,p_db_column_name=>'ESTIMATED_QUARTER'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Estimated Quarter'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144168230335791246)
,p_db_column_name=>'END_USER_ID'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'End User'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(144168161573791245)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128342316999489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(144152826506768019)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1593697'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DP_ITEM_CODE:END_USER_ID:DATE_REQUIRED:MAIN_CATEGORY_ID:CATEGORY_ID:SUB_CATEGORY_ID:SCOPE_ID:DP_ITEM_TYPE_ID:DP_PROCUREMENT_METHOD:PROJECT_NUMBER:ESTIMATED_BUDGET:TEMPLATE_ID:ESTIMATED_DATE:PLANNING_STATUS:REVIEW_STATUS:APPROVAL_STATUS:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2310501579580412)
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
 p_id=>wwv_flow_api.id(2311082540580413)
,p_plug_name=>'All Scoping Documents'
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    dps.scope_id,',
'    dps.scope_code,',
'    dps.dp_item_id,',
'    dps.project_name,',
'    dps.project_code,',
'    dps.project_number,',
'    dps.date_required,',
'    dps.main_category_id,',
'    dps.category_id,',
'    dps.sub_category_id,',
'    dps.rfp_ref_number,',
'    dps.expected_start_date,',
'    dps.expected_end_date,',
'    dps.tender_start_date,',
'    dps.tender_end_date,',
'    dps.technical_submission_id,',
'    dps.review_status,',
'    dps.approval_status,',
'    dps.template_id,',
'-- DP_ITEMS',
'    dpi.INITIATIVE_ID, ',
'    dpi.PROJECT_DESCRIPTION, ',
'    dpi.ESTIMATED_DATE, ',
'    dpi.ESTIMATED_YEAR, ',
'    dpi.ESTIMATED_QUARTER, ',
'    dpi.END_USER_ID, ',
'    dpi.SECTOR_ID, ',
'    dpi.DEPARTMENT_ID, ',
'    dpi.DP_ITEM_TYPE_ID, ',
'    dpi.RISK_ID, ',
'    dpi.PRIORITY_ID, ',
'    dpi.DP_PROCUREMENT_METHOD, ',
'    DP_ITEMS_UTIL.get_dp_procurement_method_class_id(dpi.DP_PROCUREMENT_METHOD) procurment_method_class_id,',
'    DP_ITEMS_UTIL.get_dp_procurement_method_class_id(dpi.DP_PROCUREMENT_METHOD) procurment_method_class,',
'    dpi.ESTIMATED_BUDGET, ',
'    dpi.ESTIMATED_BUDGET_BRACKET_ID, ',
'    dpi.PLANNING_STATUS, ',
'    dpi.REVIEW_STATUS               DP_ITEM_REVIEW_STATUS, ',
'    dpi.APPROVAL_STATUS             DP_ITEM_APPROVAL_STATUS, ',
'    dpi.CUTT_OFF_DATE, ',
'    dpi.NOTES, ',
'    dpi.DP_ITEM_NAME, ',
'    dpi.DP_YEAR, ',
'    dpi.INITIATIVE_NEW_YN, ',
'    dpi.INITIATIVE_NEW_NAME, ',
'    dpi.DP_ITEM_CODE, ',
'    dpi.CONTRACT_NO',
'FROM',
'    dp_scoping_a  dps,',
'    dp_items      dpi',
'WHERE',
'    dps.dp_item_id = dpi.item_id',
'order by dps.scope_id desc ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':IS_DP_ADMIN = ''Y'' OR :IS_VIEW_ALL_DP_ITEMS > ''Y'''
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'DP Scoping Documents'
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
 p_id=>wwv_flow_api.id(2311227020580413)
,p_name=>'DP Scoping Documents Home Page '
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No SoW documents available yet.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL'
,p_detail_link=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_SCOPE_ID:#SCOPE_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>146513395994636377
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2311625825580417)
,p_db_column_name=>'SCOPE_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Scope Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2312009632580418)
,p_db_column_name=>'SCOPE_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Scope Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2312385238580418)
,p_db_column_name=>'DP_ITEM_ID'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Dp Item Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2312797365580418)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2313142310580418)
,p_db_column_name=>'PROJECT_CODE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Project Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2313613304580419)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2313951157580419)
,p_db_column_name=>'DATE_REQUIRED'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Date Required'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2314371928580419)
,p_db_column_name=>'MAIN_CATEGORY_ID'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Main Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449582832098954)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2314805283580421)
,p_db_column_name=>'CATEGORY_ID'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(140752397958276427)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2315227366580421)
,p_db_column_name=>'SUB_CATEGORY_ID'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Sub Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128449760929095476)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2315537632580421)
,p_db_column_name=>'RFP_REF_NUMBER'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'RFP Ref Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2315981845580422)
,p_db_column_name=>'EXPECTED_START_DATE'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Expected Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2316414698580422)
,p_db_column_name=>'EXPECTED_END_DATE'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Expected End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2316792716580422)
,p_db_column_name=>'TENDER_START_DATE'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Tender Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2317159206580422)
,p_db_column_name=>'TENDER_END_DATE'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Tender End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2317543962580423)
,p_db_column_name=>'TECHNICAL_SUBMISSION_ID'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Technical Submission'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(138190893143257226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2317976390580423)
,p_db_column_name=>'REVIEW_STATUS'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Review Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2318349106580423)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2318750703580423)
,p_db_column_name=>'TEMPLATE_ID'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Scoping Template'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(138404640303341881)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2319168108580424)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Initiative'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128335626861489802)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2319541846580424)
,p_db_column_name=>'PROJECT_DESCRIPTION'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Project Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2319932917580424)
,p_db_column_name=>'ESTIMATED_DATE'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Estimated Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2320349847580424)
,p_db_column_name=>'ESTIMATED_YEAR'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Estimated Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2320764580580424)
,p_db_column_name=>'ESTIMATED_QUARTER'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Estimated Quarter'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2321200121580425)
,p_db_column_name=>'END_USER_ID'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'End User'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2321603976580425)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128342316999489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2321940549580425)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128341292413489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2322425419580425)
,p_db_column_name=>'DP_ITEM_TYPE_ID'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'DP Item Type '
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128416904318325983)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2322745174580425)
,p_db_column_name=>'RISK_ID'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Risk'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128420411111243936)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2323221068580426)
,p_db_column_name=>'PRIORITY_ID'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Priority'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128341720324489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2323616917580426)
,p_db_column_name=>'DP_PROCUREMENT_METHOD'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Procurement Method'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128420668962241785)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2324007348580426)
,p_db_column_name=>'ESTIMATED_BUDGET'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Estimated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2324393010580426)
,p_db_column_name=>'ESTIMATED_BUDGET_BRACKET_ID'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Estimated Budget Bracket '
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(129510087609156996)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2324766089580427)
,p_db_column_name=>'PLANNING_STATUS'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Planning Status'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128420883056239409)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2325150457580427)
,p_db_column_name=>'DP_ITEM_REVIEW_STATUS'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'DP Item Review Status'
,p_column_type=>'STRING'
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
 p_id=>wwv_flow_api.id(2325563640580427)
,p_db_column_name=>'DP_ITEM_APPROVAL_STATUS'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'DP Item Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2325969032580427)
,p_db_column_name=>'CUTT_OFF_DATE'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Cut-Off Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2326378254580428)
,p_db_column_name=>'NOTES'
,p_display_order=>38
,p_column_identifier=>'AL'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2326733296580428)
,p_db_column_name=>'DP_ITEM_NAME'
,p_display_order=>39
,p_column_identifier=>'AM'
,p_column_label=>'DP Item Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2327133790580428)
,p_db_column_name=>'DP_YEAR'
,p_display_order=>40
,p_column_identifier=>'AN'
,p_column_label=>'DP Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2327621229580428)
,p_db_column_name=>'INITIATIVE_NEW_YN'
,p_display_order=>41
,p_column_identifier=>'AO'
,p_column_label=>'Initiative New ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2327949375580429)
,p_db_column_name=>'INITIATIVE_NEW_NAME'
,p_display_order=>42
,p_column_identifier=>'AP'
,p_column_label=>'Initiative New Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2328337473580429)
,p_db_column_name=>'DP_ITEM_CODE'
,p_display_order=>43
,p_column_identifier=>'AQ'
,p_column_label=>'DP Item Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2328822010580429)
,p_db_column_name=>'CONTRACT_NO'
,p_display_order=>44
,p_column_identifier=>'AR'
,p_column_label=>'Contract No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(511648819186999797)
,p_db_column_name=>'PROCURMENT_METHOD_CLASS_ID'
,p_display_order=>54
,p_column_identifier=>'AS'
,p_column_label=>'Procurment Method Class Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(511648701459999796)
,p_db_column_name=>'PROCURMENT_METHOD_CLASS'
,p_display_order=>64
,p_column_identifier=>'AT'
,p_column_label=>'Procurment Method Class'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(505772111001923632)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(2329343360582027)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1465316'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DP_ITEM_CODE:END_USER_ID:DATE_REQUIRED:MAIN_CATEGORY_ID:CATEGORY_ID:SUB_CATEGORY_ID:TEMPLATE_ID:ESTIMATED_DATE:DP_ITEM_TYPE_ID:DP_PROCUREMENT_METHOD:ESTIMATED_BUDGET:PLANNING_STATUS:REVIEW_STATUS:APPROVAL_STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(505719814460150748)
,p_report_id=>wwv_flow_api.id(2329343360582027)
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
 p_id=>wwv_flow_api.id(505719427155150748)
,p_report_id=>wwv_flow_api.id(2329343360582027)
,p_name=>'Reject'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Not Accepted'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Not Accepted''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(505719035948150748)
,p_report_id=>wwv_flow_api.id(2329343360582027)
,p_name=>'Required'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Required'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Required''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#CDE6EB'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(505718629826150748)
,p_report_id=>wwv_flow_api.id(2329343360582027)
,p_name=>'Draft'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REVIEW_STATUS'
,p_operator=>'='
,p_expr=>'Draft'
,p_condition_sql=>' (case when ("REVIEW_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Draft''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(505718211300150749)
,p_report_id=>wwv_flow_api.id(2329343360582027)
,p_name=>'Rejected'
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
 p_id=>wwv_flow_api.id(505717812902150749)
,p_report_id=>wwv_flow_api.id(2329343360582027)
,p_name=>'In-Progress'
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
