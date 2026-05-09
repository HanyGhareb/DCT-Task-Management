prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>7
,p_user_interface_id=>wwv_flow_api.id(11217697745956116)
,p_name=>'My Payments Recommendation'
,p_alias=>'MY-PAYMENTS-RECOMMENDATION'
,p_step_title=>'My Payments Recommendation'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20211026190253'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11929056879274297)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(11142414762956053)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(11079053308956006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(11196517955956091)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12359969438862839)
,p_plug_name=>'Payment Applications Report'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(11131192505956047)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct  PAYMENT_RECOMMENDATION_ID, REFERENCE_NUMBER, PAYMENT_RECOMMENDATION_DATE, CONTRACT_NUMBER, PERIOD, CONTRACT_TITLE, CONTRACT_REFERENCE, CONTRACT_DESCRIPTION, INITIAL_CONTRACT_AMOUNT, CONTRACT_AMOUNT, CONTRACT_VARIATION_AMOUNT, BILLED_'
||'AMOUNT, VENDOR_NUMBER, VENDOR_NAME, VENDOR_SITE_CODE, REVISED_COMPLETION_DATE, PROJECT_NUMBER, PROJECT_NAME, PAYMENT_NUMBER, PAYMENT_TYPE, VALUATION_PERIOD, EVALUATION_METHOD, PREVIOUSELY_CERIFIED_APPROVED, PREVIOUSELY_CERIFIED_PENDING, CURRENT_VALUA'
||'TION_AMOUNT, DEDUCTIONS, CUMULATIVE_CERIFIED_AMOUNT, NET_AMOUNT_PAYABLE, ATTACHEMENTS, CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON, APPROVAL_STATUS, SEQ_COUNT, FINAL_APPROVE_ON, INVOICE_NUM, INVOICE_DATE, TOTAL_INVOICE_AMOUNT, CURRENCY, CONTRACT_S'
||'TAGE, PREVIOUS_PAYMENTS',
'from',
'-- get all Recommendation payment for all contract for VENDOR assigned to EXT user',
'(select PAYMENT_RECOMMENDATION_ID,',
'       REFERENCE_NUMBER,',
'       PAYMENT_RECOMMENDATION_DATE,',
'       CONTRACT_NUMBER,',
'       PERIOD,',
'       CONTRACT_TITLE,',
'       CONTRACT_REFERENCE,',
'       CONTRACT_DESCRIPTION,',
'       INITIAL_CONTRACT_AMOUNT,',
'       CONTRACT_AMOUNT,',
'       CONTRACT_VARIATION_AMOUNT,',
'       BILLED_AMOUNT,',
'       VENDOR_NUMBER,',
'       VENDOR_NAME,',
'       VENDOR_SITE_CODE,',
'       REVISED_COMPLETION_DATE,',
'       PROJECT_NUMBER,',
'       PROJECT_NAME,',
'       PAYMENT_NUMBER,',
'       PAYMENT_TYPE,',
'       VALUATION_PERIOD,',
'       EVALUATION_METHOD,',
'       PREVIOUSELY_CERIFIED_APPROVED,',
'       PREVIOUSELY_CERIFIED_PENDING,',
'       CURRENT_VALUATION_AMOUNT,',
'       DEDUCTIONS,',
'       CUMULATIVE_CERIFIED_AMOUNT,',
'       NET_AMOUNT_PAYABLE,',
'       ATTACHEMENTS,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       APPROVAL_STATUS,',
'       SEQ_COUNT,',
'       FINAL_APPROVE_ON,',
'       INVOICE_NUM,',
'       INVOICE_DATE,',
'       TOTAL_INVOICE_AMOUNT,',
'       CURRENCY,',
'       CONTRACT_STAGE,',
'       PREVIOUS_PAYMENTS',
'  from CWIP_PAYMENT_RECOMMENDATION_V',
' where (vendor_number , vendor_site_code) in (select u.vendor_number ,u.vendor_site_code',
'                                                from dct_ext_users u',
'                                                where u.user_id = :PERSON_ID )',
'union all',
'-- get all Recommendation payment for all contract for the project assigned to EXT user without specific contract',
'select PAYMENT_RECOMMENDATION_ID,',
'       REFERENCE_NUMBER,',
'       PAYMENT_RECOMMENDATION_DATE,',
'       CONTRACT_NUMBER,',
'       PERIOD,',
'       CONTRACT_TITLE,',
'       CONTRACT_REFERENCE,',
'       CONTRACT_DESCRIPTION,',
'       INITIAL_CONTRACT_AMOUNT,',
'       CONTRACT_AMOUNT,',
'       CONTRACT_VARIATION_AMOUNT,',
'       BILLED_AMOUNT,',
'       VENDOR_NUMBER,',
'       VENDOR_NAME,',
'       VENDOR_SITE_CODE,',
'       REVISED_COMPLETION_DATE,',
'       PROJECT_NUMBER,',
'       PROJECT_NAME,',
'       PAYMENT_NUMBER,',
'       PAYMENT_TYPE,',
'       VALUATION_PERIOD,',
'       EVALUATION_METHOD,',
'       PREVIOUSELY_CERIFIED_APPROVED,',
'       PREVIOUSELY_CERIFIED_PENDING,',
'       CURRENT_VALUATION_AMOUNT,',
'       DEDUCTIONS,',
'       CUMULATIVE_CERIFIED_AMOUNT,',
'       NET_AMOUNT_PAYABLE,',
'       ATTACHEMENTS,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       APPROVAL_STATUS,',
'       SEQ_COUNT,',
'       FINAL_APPROVE_ON,',
'       INVOICE_NUM,',
'       INVOICE_DATE,',
'       TOTAL_INVOICE_AMOUNT,',
'       CURRENCY,',
'       CONTRACT_STAGE,',
'       PREVIOUS_PAYMENTS',
'  from CWIP_PAYMENT_RECOMMENDATION_V',
' where  contract_number in (select distinct contract_number',
'                         from cwip_contract_projects',
'                         where project_number in',
'                                                (select  distinct project_number',
'                                                  from CWIP_TEAM',
'                                                  where person_id = :PERSON_ID',
'                                                  and contract_number is null',
'                                                  and status = ''A''',
'                                                  and sysdate BETWEEN nvl(start_date, sysdate -10) ',
'                                                                and nvl(end_date, sysdate + 100)))',
'',
'-- get all Recommendation payment for specific contract assigned to EXT user ',
'Union ALL',
'select PAYMENT_RECOMMENDATION_ID,',
'       REFERENCE_NUMBER,',
'       PAYMENT_RECOMMENDATION_DATE,',
'       CONTRACT_NUMBER,',
'       PERIOD,',
'       CONTRACT_TITLE,',
'       CONTRACT_REFERENCE,',
'       CONTRACT_DESCRIPTION,',
'       INITIAL_CONTRACT_AMOUNT,',
'       CONTRACT_AMOUNT,',
'       CONTRACT_VARIATION_AMOUNT,',
'       BILLED_AMOUNT,',
'       VENDOR_NUMBER,',
'       VENDOR_NAME,',
'       VENDOR_SITE_CODE,',
'       REVISED_COMPLETION_DATE,',
'       PROJECT_NUMBER,',
'       PROJECT_NAME,',
'       PAYMENT_NUMBER,',
'       PAYMENT_TYPE,',
'       VALUATION_PERIOD,',
'       EVALUATION_METHOD,',
'       PREVIOUSELY_CERIFIED_APPROVED,',
'       PREVIOUSELY_CERIFIED_PENDING,',
'       CURRENT_VALUATION_AMOUNT,',
'       DEDUCTIONS,',
'       CUMULATIVE_CERIFIED_AMOUNT,',
'       NET_AMOUNT_PAYABLE,',
'       ATTACHEMENTS,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       APPROVAL_STATUS,',
'       SEQ_COUNT,',
'       FINAL_APPROVE_ON,',
'       INVOICE_NUM,',
'       INVOICE_DATE,',
'       TOTAL_INVOICE_AMOUNT,',
'       CURRENCY,',
'       CONTRACT_STAGE,',
'       PREVIOUS_PAYMENTS',
'  from CWIP_PAYMENT_RECOMMENDATION_V',
'  where contract_number in (select  Contract_number',
'                          from CWIP_TEAM',
'                          where person_id = :PERSON_ID',
'                          and contract_number is not null',
'                          and status = ''A''',
'                          and sysdate BETWEEN nvl(start_date, sysdate -10) ',
'                                    and nvl(end_date, sysdate + 100)',
'                         )',
') order by PAYMENT_RECOMMENDATION_DATE'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Payment Applications Report'
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
 p_id=>wwv_flow_api.id(12360014961862840)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>12360014961862840
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12360180978862841)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12360276703862842)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Reference Number'
,p_column_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::P4_FROM_PAGE,P4_PAYMENT_RECOMMENDATION_ID:7,#PAYMENT_RECOMMENDATION_ID#'
,p_column_linktext=>'#REFERENCE_NUMBER#'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12360319207862843)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12360485148862844)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12360593781862845)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Application Payment#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12360756428862847)
,p_db_column_name=>'PAYMENT_TYPE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Payment Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12361059177862850)
,p_db_column_name=>'EVALUATION_METHOD'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Evaluation Method'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12454942180889001)
,p_db_column_name=>'CURRENT_VALUATION_AMOUNT'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Current Valuation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12455169152889003)
,p_db_column_name=>'DEDUCTIONS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Deductions'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12455320456889005)
,p_db_column_name=>'NET_AMOUNT_PAYABLE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Net Amount Payable'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12455462172889006)
,p_db_column_name=>'ATTACHEMENTS'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Attachements'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(11414111784180670)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12455583643889007)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12455662433889008)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12455729995889009)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12455853941889010)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12455907038889011)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12456010245889012)
,p_db_column_name=>'CONTRACT_DESCRIPTION'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Contract Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12456223755889014)
,p_db_column_name=>'INITIAL_CONTRACT_AMOUNT'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Initial Contract Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12456377021889015)
,p_db_column_name=>'CONTRACT_AMOUNT'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Contract Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12456439771889016)
,p_db_column_name=>'CONTRACT_VARIATION_AMOUNT'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Contract Variation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12456515073889017)
,p_db_column_name=>'BILLED_AMOUNT'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Billed Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12457389628889025)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12457417205889026)
,p_db_column_name=>'VENDOR_NUMBER'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Vendor Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12457592723889027)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12457695043889028)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12457715101889029)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21962424072318812)
,p_db_column_name=>'CONTRACT_TITLE'
,p_display_order=>400
,p_column_identifier=>'AQ'
,p_column_label=>'Contract Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21962500991318813)
,p_db_column_name=>'CONTRACT_REFERENCE'
,p_display_order=>410
,p_column_identifier=>'AR'
,p_column_label=>'Contract Reference'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21962643313318814)
,p_db_column_name=>'REVISED_COMPLETION_DATE'
,p_display_order=>420
,p_column_identifier=>'AS'
,p_column_label=>'Revised Completion Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12360893031862848)
,p_db_column_name=>'VALUATION_PERIOD'
,p_display_order=>430
,p_column_identifier=>'H'
,p_column_label=>'Valuation Period'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12455020559889002)
,p_db_column_name=>'PERIOD'
,p_display_order=>440
,p_column_identifier=>'L'
,p_column_label=>'Period'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21962753949318815)
,p_db_column_name=>'SEQ_COUNT'
,p_display_order=>450
,p_column_identifier=>'AT'
,p_column_label=>'Seq Count'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12455260977889004)
,p_db_column_name=>'PREVIOUS_PAYMENTS'
,p_display_order=>460
,p_column_identifier=>'N'
,p_column_label=>'Previous Payments'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21962801951318816)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21962941774318817)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21963088865318818)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21963142206318819)
,p_db_column_name=>'TOTAL_INVOICE_AMOUNT'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Total Invoice Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21963259920318820)
,p_db_column_name=>'CURRENCY'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21963376718318821)
,p_db_column_name=>'CONTRACT_STAGE'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Contract Stage'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32803419119539625)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_APPROVED'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Previousely Cerified Approved'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32803560754539626)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_PENDING'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Previousely Cerified Pending'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32803679917539627)
,p_db_column_name=>'CUMULATIVE_CERIFIED_AMOUNT'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'Cumulative Cerified Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(12472984145889466)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'124730'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CONTRACT_NUMBER:REFERENCE_NUMBER:PAYMENT_NUMBER:PAYMENT_RECOMMENDATION_DATE:PAYMENT_TYPE:EVALUATION_METHOD:PREVIOUSELY_CERIFIED_APPROVED:PREVIOUSELY_CERIFIED_PENDING:CURRENT_VALUATION_AMOUNT:DEDUCTIONS:NET_AMOUNT_PAYABLE:CUMULATIVE_CERIFIED_AMOUNT:AP'
||'PROVAL_STATUS'
,p_sort_column_1=>'UPDATED_ON'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(45148062050561871)
,p_report_id=>wwv_flow_api.id(12472984145889466)
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
 p_id=>wwv_flow_api.id(45147634264561870)
,p_report_id=>wwv_flow_api.id(12472984145889466)
,p_name=>'In-Progress'
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
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(45147236574561870)
,p_report_id=>wwv_flow_api.id(12472984145889466)
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(45149272086563586)
,p_application_user=>'GNAGASINGHE@TCCO.COM'
,p_name=>'in-progress'
,p_description=>'show only in-progress payments requests'
,p_report_seq=>10
,p_report_columns=>'CONTRACT_NUMBER:REFERENCE_NUMBER:PAYMENT_NUMBER:PAYMENT_RECOMMENDATION_DATE:PAYMENT_TYPE:EVALUATION_METHOD:PREVIOUSELY_CERIFIED_APPROVED:PREVIOUSELY_CERIFIED_PENDING:CURRENT_VALUATION_AMOUNT:DEDUCTIONS:NET_AMOUNT_PAYABLE:CUMULATIVE_CERIFIED_AMOUNT:AP'
||'PROVAL_STATUS'
,p_sort_column_1=>'UPDATED_ON'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(45149041609563586)
,p_report_id=>wwv_flow_api.id(45149272086563586)
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
 p_id=>wwv_flow_api.id(45148941605563586)
,p_report_id=>wwv_flow_api.id(45149272086563586)
,p_name=>'In-Progress'
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
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(45148843826563586)
,p_report_id=>wwv_flow_api.id(45149272086563586)
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
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(45149113135563586)
,p_report_id=>wwv_flow_api.id(45149272086563586)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>'"APPROVAL_STATUS" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(32803383414539624)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11929056879274297)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(11195252240956089)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12458364651889035)
,p_name=>'P7_CONTRACT_NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11929056879274297)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(12458434074889036)
,p_computation_sequence=>10
,p_computation_item=>'P7_CONTRACT_NUMBER'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select t.contract_number ',
'from cwip_team t ',
'where t.person_id = :PERSON_ID'))
);
wwv_flow_api.component_end;
end;
/
