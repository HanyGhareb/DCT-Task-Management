prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>100034894930602818
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'ifinance Template'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220805075427'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(425385800308902)
,p_plug_name=>'Payment Requests Report - All'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PAYMENT_REQUEST_ID,',
'       REQUEST_NUMBER,',
'       REQUEST_DATE,',
'       VENDOR_NUMBER,',
'       vendor_name,',
'       VENDOR_SITE_CODE,',
'       OU_NAME,',
'       VENDOR_TYPE,',
'       INVOICE_NUMBER,',
'       INVOICE_DATE,',
'       INVOICE_DESCRIPTION,',
'       CURRENCY_CODE,',
'       INVOICE_AMOUNT,',
'       PO_AVAILABLE_YN,',
'       MULTIPLE_PO_YN,',
'       ADVANCE_PAYMENT_YN,',
'       BANK_GURANTEE_NUMBER,',
'       NOTES,',
'       VOUCHER_NUMBER,',
'       PV_STATUS,',
'       PAYMENT_NUMBER,',
'       PAYMENT_STATUS,',
'       CLEAR_STATUS,',
'       CLEAR_DATE,',
'       ENTITY_CODE,',
'       COST_CENTER,',
'       BUDGET_GROUP_CODE,',
'       GL_ACCOUNT,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2,',
'       STATUS,',
'       SUBMITTED_ON,',
'       SUBMITTED_BY,',
'       FINAL_APPROVED_ON,',
'       FINAL_APPROVED_BY,',
'       REJECT_BY,',
'       REJECT_ON,',
'       REJECT_REASON,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       REQUESTOR_PERSON_ID,',
'       PRIORITY',
'  from PAYMENT_REQUESTS_ALL_V',
' order by updated_on desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Payment Requests Report - All'
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
 p_id=>wwv_flow_api.id(425239581308901)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_PAYMENT_REQUEST_ID:#PAYMENT_REQUEST_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>99609655349293917
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572516980419892)
,p_db_column_name=>'REQUESTOR_PERSON_ID'
,p_display_order=>10
,p_column_identifier=>'AQ'
,p_column_label=>'Requestor '
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(76622441183899)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(425120753308900)
,p_db_column_name=>'PAYMENT_REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'A'
,p_column_label=>'Payment Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(425071009308899)
,p_db_column_name=>'REQUEST_NUMBER'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Request Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(424897632308898)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(424800570308897)
,p_db_column_name=>'VENDOR_NUMBER'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Vendor Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(424776110308896)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(424613913308895)
,p_db_column_name=>'OU_NAME'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'OU Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(424534597308894)
,p_db_column_name=>'VENDOR_TYPE'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Vendor Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(424492054308893)
,p_db_column_name=>'INVOICE_NUMBER'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(424344896308892)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(424260770308891)
,p_db_column_name=>'INVOICE_DESCRIPTION'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Invoice Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(424165974308890)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>120
,p_column_identifier=>'K'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(424052572308889)
,p_db_column_name=>'INVOICE_AMOUNT'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Invoice Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(423917757308888)
,p_db_column_name=>'PO_AVAILABLE_YN'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'PO Available ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(66771378171803)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(423808273308887)
,p_db_column_name=>'MULTIPLE_PO_YN'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'Multiple PO ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(66771378171803)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(423789155308886)
,p_db_column_name=>'ADVANCE_PAYMENT_YN'
,p_display_order=>160
,p_column_identifier=>'O'
,p_column_label=>'Advance Payment ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(66771378171803)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(423676469308885)
,p_db_column_name=>'BANK_GURANTEE_NUMBER'
,p_display_order=>170
,p_column_identifier=>'P'
,p_column_label=>'Bank Guarantee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(423568856308884)
,p_db_column_name=>'NOTES'
,p_display_order=>180
,p_column_identifier=>'Q'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(423455704308883)
,p_db_column_name=>'VOUCHER_NUMBER'
,p_display_order=>190
,p_column_identifier=>'R'
,p_column_label=>'Voucher Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(423355068308882)
,p_db_column_name=>'PV_STATUS'
,p_display_order=>200
,p_column_identifier=>'S'
,p_column_label=>'PV Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(423290791308881)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>210
,p_column_identifier=>'T'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(423188083308880)
,p_db_column_name=>'PAYMENT_STATUS'
,p_display_order=>220
,p_column_identifier=>'U'
,p_column_label=>'Payment Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(423046063308879)
,p_db_column_name=>'CLEAR_STATUS'
,p_display_order=>230
,p_column_identifier=>'V'
,p_column_label=>'Clear Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(422950097308878)
,p_db_column_name=>'CLEAR_DATE'
,p_display_order=>240
,p_column_identifier=>'W'
,p_column_label=>'Clear Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(422823158308877)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>250
,p_column_identifier=>'X'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(422734059308876)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>260
,p_column_identifier=>'Y'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(422654685308875)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>270
,p_column_identifier=>'Z'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(422514906308874)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>280
,p_column_identifier=>'AA'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(422494093308873)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>290
,p_column_identifier=>'AB'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(422392719308872)
,p_db_column_name=>'FUTURE1'
,p_display_order=>300
,p_column_identifier=>'AC'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(422203406308871)
,p_db_column_name=>'FUTURE2'
,p_display_order=>310
,p_column_identifier=>'AD'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(422129465308870)
,p_db_column_name=>'STATUS'
,p_display_order=>320
,p_column_identifier=>'AE'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(422076310308869)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>330
,p_column_identifier=>'AF'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(421914441308868)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>340
,p_column_identifier=>'AG'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(76622441183899)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(571636880419883)
,p_db_column_name=>'FINAL_APPROVED_ON'
,p_display_order=>350
,p_column_identifier=>'AH'
,p_column_label=>'Final Approved On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(571744468419884)
,p_db_column_name=>'FINAL_APPROVED_BY'
,p_display_order=>360
,p_column_identifier=>'AI'
,p_column_label=>'Final Approved By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(76622441183899)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(571865314419885)
,p_db_column_name=>'REJECT_BY'
,p_display_order=>370
,p_column_identifier=>'AJ'
,p_column_label=>'Reject By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(76622441183899)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(571927823419886)
,p_db_column_name=>'REJECT_ON'
,p_display_order=>380
,p_column_identifier=>'AK'
,p_column_label=>'Reject On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572026911419887)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>390
,p_column_identifier=>'AL'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572154446419888)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>400
,p_column_identifier=>'AM'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(76622441183899)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572265030419889)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>410
,p_column_identifier=>'AN'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572324269419890)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>420
,p_column_identifier=>'AO'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(76622441183899)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572464817419891)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>430
,p_column_identifier=>'AP'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572646171419893)
,p_db_column_name=>'PRIORITY'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(78642850183900)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(572731755419894)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(590596000425189)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1006255'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUESTOR_PERSON_ID:REQUEST_NUMBER:REQUEST_DATE:VENDOR_NAME:VENDOR_NUMBER:INVOICE_NUMBER:INVOICE_DATE:CURRENCY_CODE:INVOICE_AMOUNT:PO_AVAILABLE_YN:STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(17748995622962406)
,p_report_id=>wwv_flow_api.id(590596000425189)
,p_name=>'Approve'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(17749342968962406)
,p_report_id=>wwv_flow_api.id(590596000425189)
,p_name=>'In-Progress'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#A96E17'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(17749743214962405)
,p_report_id=>wwv_flow_api.id(590596000425189)
,p_name=>'Reject'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(99855874479410836)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99766883142410755)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(99703488427410717)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(99820961719410781)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(426270931308911)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(99855874479410836)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Payment Request'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_PAGE_FROM:1'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
