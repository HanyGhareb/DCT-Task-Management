prompt --application/pages/page_00030
begin
--   Manifest
--     PAGE: 00030
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>30
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'All Payment Recommendations'
,p_alias=>'ALL-PAYMENT-RECOMMENDATIONS'
,p_step_title=>'All Payment Recommendations'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210902042618'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22096963456414298)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10254567086597785)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(10191147067597728)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(10308621936597827)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22097507645414298)
,p_plug_name=>'All Payment Recommendations'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    payment_recommendation_id,',
'    reference_number,',
'    payment_recommendation_date,',
'    contract_number,',
'    period,',
'    contract_title,',
'    contract_reference,',
'    contract_description,',
'    initial_contract_amount,',
'    contract_amount,',
'    contract_variation_amount,',
'    billed_amount,',
'    vendor_number,',
'    vendor_name,',
'    vendor_site_code,',
'    revised_completion_date,',
'    project_number,',
'    project_name,',
'    payment_number,',
'    payment_type,',
'    valuation_period,',
'    evaluation_method,',
'    previousely_cerified_approved,',
'    previousely_cerified_pending,',
'    current_valuation_amount,',
'    deductions,',
'    cumulative_cerified_amount,',
'    net_amount_payable,',
'    attachements,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    approval_status,',
'    seq_count,',
'    final_approve_on,',
'    invoice_num,',
'    invoice_date,',
'    total_invoice_amount,',
'    currency,',
'    contract_stage,',
'    previous_payments',
'FROM',
'    cwip_payment_recommendation_v',
'--',
'where  project_number in ( select PROJECT_NUMBER',
'                          from CWIP_TEAM',
'                         where 1=1',
'                         and role_id in (Select r.role_id from project_role r where r.category_id = 2)',
'                         and status = ''A''',
'                         and sysdate BETWEEN nvl(start_date , sysdate -1) and nvl(end_date, sysdate +10)',
'                         and person_type = ''INT''',
'                         and person_id = :PERSON_ID)',
'OR project_number in (select x.project_number ',
'from project x',
'where exists (select 1 ',
'            from cwip_team',
'            where cwip_team.person_id = :PERSON_ID',
'            and cwip_team.project_number is null) )    ',
'or project_number in (select x.project_number',
'                        from project x',
'                        where :PERSON_ID = 680461 )',
'--',
'     order by UPDATED_ON DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_document_header=>'SERVER'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Payment Recommendations'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#10591D'
,p_prn_header_font_color=>'#FFFFFF'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'12'
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
 p_id=>wwv_flow_api.id(22097666397414298)
,p_name=>'All Payment Recommendations'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>22097666397414298
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22098033204414300)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22098457068414301)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Reference Number'
,p_column_link=>'f?p=&APP_ID.:29:&SESSION.::&DEBUG.:29:P29_PAYMENT_RECOMMENDATION_ID,P29_PAGE_FROM,P29_PR_ID:#PAYMENT_RECOMMENDATION_ID#,30,#PAYMENT_RECOMMENDATION_ID#'
,p_column_linktext=>'#REFERENCE_NUMBER#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22098822392414301)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_DATE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Payment Recommendation Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22099254625414301)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22099699313414301)
,p_db_column_name=>'CONTRACT_TITLE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Contract Title'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22100007011414302)
,p_db_column_name=>'CONTRACT_REFERENCE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Contract Reference'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22100484084414302)
,p_db_column_name=>'CONTRACT_DESCRIPTION'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Contract Description'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22100837740414302)
,p_db_column_name=>'INITIAL_CONTRACT_AMOUNT'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Initial Contract Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22101296655414303)
,p_db_column_name=>'CONTRACT_AMOUNT'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Contract Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22101616553414303)
,p_db_column_name=>'CONTRACT_VARIATION_AMOUNT'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Contract Variation Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22102018191414303)
,p_db_column_name=>'BILLED_AMOUNT'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Billed Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22102424564414303)
,p_db_column_name=>'VENDOR_NUMBER'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Vendor Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22102849565414304)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22103293329414304)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22103601443414304)
,p_db_column_name=>'REVISED_COMPLETION_DATE'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Revised Completion Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22104061031414304)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22104408965414305)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22104873630414305)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22105271407414305)
,p_db_column_name=>'PAYMENT_TYPE'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Payment Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22105631344414305)
,p_db_column_name=>'VALUATION_PERIOD'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Valuation Period'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22106016934414306)
,p_db_column_name=>'EVALUATION_METHOD'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Evaluation Method'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22106480064414306)
,p_db_column_name=>'CURRENT_VALUATION_AMOUNT'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Current Valuation Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22106834200414306)
,p_db_column_name=>'PERIOD'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Period'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22107297851414306)
,p_db_column_name=>'DEDUCTIONS'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Deductions'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22107604622414307)
,p_db_column_name=>'PREVIOUS_PAYMENTS'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Previous Payments'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22108043645414307)
,p_db_column_name=>'NET_AMOUNT_PAYABLE'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Net Amount Payable'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22108460032414307)
,p_db_column_name=>'ATTACHEMENTS'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Attachements'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22108865943414307)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22109283202414308)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22109692222414308)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22110047466414308)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22110426032414308)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22110871334414309)
,p_db_column_name=>'SEQ_COUNT'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Seq Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22111207050414309)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22111612723414309)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22112052066414309)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22112475587414310)
,p_db_column_name=>'TOTAL_INVOICE_AMOUNT'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Total Invoice Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22112824657414310)
,p_db_column_name=>'CURRENCY'
,p_display_order=>38
,p_column_identifier=>'AL'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22113263495414310)
,p_db_column_name=>'CONTRACT_STAGE'
,p_display_order=>39
,p_column_identifier=>'AM'
,p_column_label=>'Contract Stage'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32570396776581217)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_APPROVED'
,p_display_order=>49
,p_column_identifier=>'AN'
,p_column_label=>'Previousely Cerified Approved'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32570450061581218)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_PENDING'
,p_display_order=>59
,p_column_identifier=>'AO'
,p_column_label=>'Previousely Cerified Pending'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32570560827581219)
,p_db_column_name=>'CUMULATIVE_CERIFIED_AMOUNT'
,p_display_order=>69
,p_column_identifier=>'AP'
,p_column_label=>'Cumulative Cerified Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(22114108649420290)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'221142'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REFERENCE_NUMBER:PAYMENT_RECOMMENDATION_DATE:CONTRACT_NUMBER:CONTRACT_TITLE:VENDOR_NAME:PROJECT_NAME:PAYMENT_TYPE:EVALUATION_METHOD:CURRENT_VALUATION_AMOUNT:NET_AMOUNT_PAYABLE:PREVIOUSELY_CERIFIED_APPROVED:PREVIOUSELY_CERIFIED_PENDING:CUMULATIVE_CERI'
||'FIED_AMOUNT:APPROVAL_STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(39898236943835886)
,p_report_id=>wwv_flow_api.id(22114108649420290)
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
 p_id=>wwv_flow_api.id(39898636135835886)
,p_report_id=>wwv_flow_api.id(22114108649420290)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(39899080926835885)
,p_report_id=>wwv_flow_api.id(22114108649420290)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.component_end;
end;
/
