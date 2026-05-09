prompt --application/pages/page_00043
begin
--   Manifest
--     PAGE: 00043
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>43
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Dashboard - Drilldown'
,p_alias=>'DASHBOARD-DRILLDOWN'
,p_step_title=>'Dashboard - Drilldown'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230304064721'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(567104827599225)
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
 p_id=>wwv_flow_api.id(567683151599227)
,p_plug_name=>'Payment Recommendations Report'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(568182516602632)
,p_plug_name=>'Payment Recommendations'
,p_parent_plug_id=>wwv_flow_api.id(567683151599227)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CV.PAYMENT_RECOMMENDATION_ID,',
'       CV.REFERENCE_NUMBER,',
'       CV.PAYMENT_RECOMMENDATION_DATE,',
'       CV.CONTRACT_NUMBER,',
'       CV.PERIOD,',
'       CV.CONTRACT_TITLE,',
'       CV.CONTRACT_REFERENCE,',
'       CV.CONTRACT_DESCRIPTION,',
'       CV.INITIAL_CONTRACT_AMOUNT,',
'       CV.CONTRACT_AMOUNT,',
'       CV.CONTRACT_VARIATION_AMOUNT,',
'       CV.DCT_CONTRACT_VARIATION_AMOUNT,',
'       CV.BILLED_AMOUNT,',
'       CV.VENDOR_NUMBER,',
'       CV.VENDOR_NAME,',
'       CV.VENDOR_SITE_CODE,',
'       CV.REVISED_COMPLETION_DATE,',
'       CV.PROJECT_NUMBER,',
'       CV.PROJECT_NAME,',
'       CV.DCT_PROJECT_CODE,',
'       CV.PAYMENT_NUMBER,',
'       CV.PAYMENT_TYPE,',
'       CV.VALUATION_PERIOD,',
'       CV.EVALUATION_METHOD,',
'       CV.PREVIOUSELY_CERIFIED_APPROVED,',
'       CV.PREVIOUSELY_CERIFIED_PENDING,',
'       CV.CURRENT_VALUATION_AMOUNT,',
'       CV.DEDUCTIONS,',
'       CV.CUMULATIVE_CERIFIED_AMOUNT,',
'       CV.NET_AMOUNT_PAYABLE,',
'       CV.ATTACHEMENTS,',
'       CV.CREATED_BY,',
'       CV.CREATED_ON,',
'       CV.UPDATED_BY,',
'       CV.UPDATED_ON,',
'       CV.APPROVAL_STATUS,',
'       CV.SEQ_COUNT,',
'       CV.FINAL_APPROVE_ON,',
'       CV.INVOICE_NUM,',
'       CV.INVOICE_DATE,',
'       CV.TOTAL_INVOICE_AMOUNT,',
'       CV.CURRENCY,',
'       CV.CONTRACT_STAGE,',
'       CV.SCOPE_OF_WORK,',
'       CV.REMARK,',
'       CV.VALUATION_PERIOD_FROM,',
'       CV.VALUATION_PERIOD_TO,',
'       CV.IPC_NUMBER,',
'       CV.PREVIOUS_PAYMENTS,',
'       XX.received_date,',
'       XX.emp',
'  from CWIP_PAYMENT_RECOMMENDATION_V  cv,',
'    (select h.PAYMENT_RECOMMENDATION_ID , max(h.RECEVIED_DATE)  received_date,',
'       --     LISTAGG( e.first_name || '' '' || e.last_name , ''; '') WITHIN GROUP (ORDER BY hire_date) emp',
'          LISTAGG( nvl(e.FULL_NAME_EN , e.SF_EMPLOYEE_NAME) , ''; '') WITHIN GROUP (ORDER BY hire_date) emp',
'        from cwip_payment_rec_approval_history h, dct_employees_list2 e, cwip_payment_recommendation m',
'        where h.person_id = e.person_id',
'        and m.PAYMENT_RECOMMENDATION_ID = h.PAYMENT_RECOMMENDATION_ID',
'        and h.STATUS = ''Pending''',
'        and m.APPROVAL_STATUS in (''In-Progress'' , ''Hold'')',
'        group by h.PAYMENT_RECOMMENDATION_ID) XX',
' where CV.PAYMENT_RECOMMENDATION_ID = xx.payment_recommendation_id (+)',
'and CV.project_number = nvl(:P43_PROJECT , CV.project_number)',
'and CV.contract_number = nvl(:P43_CONTRACT, CV.contract_number)',
'and CV.approval_status = nvl(:P43_STATUS , CV.approval_status)',
'and extract(year from nvl(CV.PAYMENT_RECOMMENDATION_DATE , cv.submitted_on)) = nvl(:P43_YEAR, extract(year from CV.PAYMENT_RECOMMENDATION_DATE))',
'and CV.VENDOR_NAME = nvl(:P43_VENDOR , CV.VENDOR_NAME);'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P43_PROJECT,P43_CONTRACT,P43_YEAR,P43_STATUS,P43_VENDOR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
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
 p_id=>wwv_flow_api.id(568334484602633)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>41004376313504903
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(568389214602634)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(568470509602635)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Reference Number'
,p_column_link=>'f?p=&APP_ID.:29:&SESSION.::&DEBUG.:29:P29_PAYMENT_RECOMMENDATION_ID,P29_PAGE_FROM,P29_PR_ID:#PAYMENT_RECOMMENDATION_ID#,43,#PAYMENT_RECOMMENDATION_ID#'
,p_column_linktext=>'#REFERENCE_NUMBER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(568583412602636)
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
 p_id=>wwv_flow_api.id(568668803602637)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(568845531602638)
,p_db_column_name=>'PERIOD'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Period'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(568925264602639)
,p_db_column_name=>'CONTRACT_TITLE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Contract Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(569002519602640)
,p_db_column_name=>'CONTRACT_REFERENCE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Contract Reference'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(569110766602641)
,p_db_column_name=>'CONTRACT_DESCRIPTION'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Contract Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(569198615602642)
,p_db_column_name=>'INITIAL_CONTRACT_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Initial Contract Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(569258449602643)
,p_db_column_name=>'CONTRACT_AMOUNT'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'PO Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(569410465602644)
,p_db_column_name=>'CONTRACT_VARIATION_AMOUNT'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Contract Variation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(569557516602645)
,p_db_column_name=>'BILLED_AMOUNT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Billed Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(569619960602646)
,p_db_column_name=>'VENDOR_NUMBER'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Vendor Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(569696886602647)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(569813933602648)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(569913620602649)
,p_db_column_name=>'REVISED_COMPLETION_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Revised Completion Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(569992782602650)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(570067198602651)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(570199764602652)
,p_db_column_name=>'DCT_PROJECT_CODE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'DCT Project Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(570342919602653)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(570411523602654)
,p_db_column_name=>'PAYMENT_TYPE'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Payment Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(570482062602655)
,p_db_column_name=>'VALUATION_PERIOD'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Valuation Period'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(570565571602656)
,p_db_column_name=>'EVALUATION_METHOD'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Evaluation Method'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(570751426602657)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_APPROVED'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Previousely Cerified Approved'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(570848873602658)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_PENDING'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Previousely Cerified Pending'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(570955057602659)
,p_db_column_name=>'CURRENT_VALUATION_AMOUNT'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Current Valuation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(571009586602660)
,p_db_column_name=>'DEDUCTIONS'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Deductions'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(571138783602661)
,p_db_column_name=>'CUMULATIVE_CERIFIED_AMOUNT'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Cumulative Cerified Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(571226097602662)
,p_db_column_name=>'NET_AMOUNT_PAYABLE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Net Amount Payable'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(571348638602663)
,p_db_column_name=>'ATTACHEMENTS'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Attachements'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(571384543602664)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(571514885602665)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(571587694602666)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(571696607602667)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(571760735602668)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(571946505602669)
,p_db_column_name=>'SEQ_COUNT'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Seq Count'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(571973116602670)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572147632602671)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572195200602672)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572306388602673)
,p_db_column_name=>'TOTAL_INVOICE_AMOUNT'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Total Invoice Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572428576602674)
,p_db_column_name=>'CURRENCY'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572476984602675)
,p_db_column_name=>'CONTRACT_STAGE'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Contract Stage'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572561928602676)
,p_db_column_name=>'SCOPE_OF_WORK'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Scope Of Work'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572669814602677)
,p_db_column_name=>'REMARK'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Remark'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572855692602678)
,p_db_column_name=>'VALUATION_PERIOD_FROM'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Valuation Period From'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572886906602679)
,p_db_column_name=>'VALUATION_PERIOD_TO'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Valuation Period To'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572978799602680)
,p_db_column_name=>'IPC_NUMBER'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'IPC Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(574183230608731)
,p_db_column_name=>'PREVIOUS_PAYMENTS'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Previous Payments'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11642225932618362)
,p_db_column_name=>'DCT_CONTRACT_VARIATION_AMOUNT'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'DCT Contract Variation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11642274887618363)
,p_db_column_name=>'RECEIVED_DATE'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Since'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11642364589618364)
,p_db_column_name=>'EMP'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Pending With'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(594447631618302)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'410305'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REFERENCE_NUMBER:CONTRACT_NUMBER:CONTRACT_AMOUNT:VENDOR_NAME:DCT_PROJECT_CODE:PAYMENT_NUMBER:PREVIOUSELY_CERIFIED_APPROVED:PREVIOUSELY_CERIFIED_PENDING:CURRENT_VALUATION_AMOUNT:CUMULATIVE_CERIFIED_AMOUNT:NET_AMOUNT_PAYABLE:APPROVAL_STATUS:RECEIVED_DA'
||'TE:EMP:'
,p_sum_columns_on_break=>'CURRENT_VALUATION_AMOUNT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(574271304608732)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(567104827599225)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(262410877010578)
,p_name=>'P43_YEAR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(567683151599227)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(262472997010579)
,p_name=>'P43_PROJECT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(567683151599227)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(262654352010580)
,p_name=>'P43_CONTRACT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(567683151599227)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(568127476602631)
,p_name=>'P43_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(567683151599227)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(574421592608733)
,p_name=>'P43_VENDOR'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(567683151599227)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
