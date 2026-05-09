prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>142
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>2
,p_user_interface_id=>wwv_flow_api.id(159947477385220145)
,p_name=>'Variation Requests VRs'
,p_alias=>'VARIATION-REQUESTS-VRS'
,p_step_title=>'Variation Requests VRs'
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
,p_last_upd_yyyymmddhh24miss=>'20231128131047'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(159966408470220198)
,p_plug_name=>'VR Requests'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(159860948285220071)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select REQUEST_ID,',
'       REQUEST_NO,',
'       REQUEST_DATE,',
'       PROJECT_NUMBER,',
'       CONTRACT_NUMBER,',
'       JUSTIFICATION,',
' --      CHANGE_REASONS,',
' --      CHANGE_REASON_OTHER,',
'       ESTIMATED_DAYS,',
'       ESTIMATED_COST,',
'       PROFESSIONAL_FEES,',
'       ESTIMATE_BASIS,',
'       ESTIMATE_BASIS_OTHERS,',
'       FUNDING_SOURCE,',
'       FUNDING_SOURCE_OTHERS,',
'       QUALITY_ASSESSMENT,',
'       END_USER_REQUIRED,',
'       END_USER_PERSON_ID,',
'       BM_REQUIRED,',
'       BM_REQUEST_ID,',
'       VO_REQUEST_ID,',
'       APPROVAL_STATUS,',
'       YEAR,',
'       SEQ,',
'       PRIORITY,',
'       SUBMITTED_ON,',
'       SUBMITTED_BY,',
'       FINAL_APPROVE_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       FINAL_REJECT_ON,',
'       REJECTED_BY,',
'       REJECT_REASON,',
'       CANCEL_ON,',
'       CANCELLED_BY,',
'       CANCEL_REASON',
'  --     SUBMITTED_BY_PERSON_TYPE',
'  from VR_REQUESTS'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Variation Requests VRs'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(159966532148220198)
,p_name=>'Variation Requests VRs'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:3:&APP_SESSION.:::3:P3_REQUEST_ID:\#REQUEST_ID#\'
,p_detail_link_text=>'<span class="fa fa-edit" aria-hidden="true"></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>159966532148220198
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159966979200220203)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Request ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159967309642220204)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Request No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159967722428220204)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159968105658220204)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159968520806220205)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159968994565220205)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Description of Change:'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159970183331220205)
,p_db_column_name=>'ESTIMATED_DAYS'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Estimated Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159970587584220206)
,p_db_column_name=>'ESTIMATED_COST'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Estimated Cost'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159971306613220206)
,p_db_column_name=>'ESTIMATE_BASIS'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Estimate Basis'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(160376683096964455)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159971702182220209)
,p_db_column_name=>'ESTIMATE_BASIS_OTHERS'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Estimate Basis - Other'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159972126624220209)
,p_db_column_name=>'FUNDING_SOURCE'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Funding Source'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(160420706167040837)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159972547008220209)
,p_db_column_name=>'FUNDING_SOURCE_OTHERS'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Funding Source - Other'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159972932308220210)
,p_db_column_name=>'QUALITY_ASSESSMENT'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Quality Assessment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159973348735220210)
,p_db_column_name=>'END_USER_REQUIRED'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'End User Required'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160314999765145413)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159973717132220210)
,p_db_column_name=>'END_USER_PERSON_ID'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'End User Representative'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160254861235270033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159974164532220210)
,p_db_column_name=>'BM_REQUIRED'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'BM Required'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160314999765145413)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159974594481220210)
,p_db_column_name=>'BM_REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Bm Request ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159974985622220211)
,p_db_column_name=>'VO_REQUEST_ID'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Vo Request ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159975790473220211)
,p_db_column_name=>'YEAR'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159976159140220211)
,p_db_column_name=>'SEQ'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'SEQ'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159976539609220212)
,p_db_column_name=>'PRIORITY'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159976975113220212)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159977305962220212)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160254861235270033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159977716065220212)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159978125019220212)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160254861235270033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159978522875220213)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160254861235270033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159978990665220213)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159979302397220215)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159979709847220216)
,p_db_column_name=>'FINAL_REJECT_ON'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Final Reject On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159980164866220216)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160254861235270033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159980509792220216)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159980972437220216)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159981375473220217)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160254861235270033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(159981775535220217)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>38
,p_column_identifier=>'AL'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(160456154770571431)
,p_db_column_name=>'PROFESSIONAL_FEES'
,p_display_order=>48
,p_column_identifier=>'AM'
,p_column_label=>'Professional Fees'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(160456297320571432)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>58
,p_column_identifier=>'AN'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(160019955824220397)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1600200'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NO:REQUEST_DATE:PROJECT_NUMBER:CONTRACT_NUMBER:JUSTIFICATION:ESTIMATED_DAYS:ESTIMATED_COST:ESTIMATE_BASIS:FUNDING_SOURCE::APPROVAL_STATUS'
,p_sort_column_1=>'REQUEST_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(159982983895220221)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(159872296964220075)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(159808885281220038)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(159926330718220124)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(159984608355220223)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(159982983895220221)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'New VR'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(159983753966220223)
,p_name=>'Edit Report - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(159966408470220198)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(159984274793220223)
,p_event_id=>wwv_flow_api.id(159983753966220223)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(159966408470220198)
);
wwv_flow_api.component_end;
end;
/
