prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
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
 p_id=>3
,p_user_interface_id=>wwv_flow_api.id(11217697745956116)
,p_name=>'Contract Details'
,p_alias=>'CONTRACT-DETAILS'
,p_step_title=>'Contract Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_css_file_urls=>'#WORKSPACE_IMAGES#main.css'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Form-label {',
'    	color: #368ed2;',
'	font-weight: bold;',
'	font-size:12px;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'RAYMOND.BEARD@TURNTOWN.COM'
,p_last_upd_yyyymmddhh24miss=>'20230321061354'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11056936663190009)
,p_plug_name=>'Payments Applications for Contract# &P3_CONTRACT_NUMBER.'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(11116089530956038)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11057088377190010)
,p_plug_name=>'Payment Recommendation Report'
,p_parent_plug_id=>wwv_flow_api.id(11056936663190009)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders:js-showMaximizeButton'
,p_plug_template=>wwv_flow_api.id(11131192505956047)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    payment_recommendation_id,',
'    reference_number,',
'    payment_recommendation_date,',
'    contract_number,',
'    payment_number,',
'    payment_type,',
'    evaluation_method,',
'    valuation_period_from,',
'    period',
'--    valuation_period_to,',
'-- calculations   ',
'--    current_valuation_amount,   ',
'--    nvl(deductions,0)    deductions,',
'--    net_amount_payable,',
'    ,(',
'    select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = c.contract_number',
'    and a.approval_status = ''Approved''',
'    and a.seq_count < c.seq_count',
'    ) Previousely_Cerified_Approved ',
'    ,',
'    (select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = c.contract_number',
'    and a.approval_status = ''Approved''',
'    and a.seq_count < c.seq_count',
'    ) Previousely_Cerified_Approved_H',
'    ,',
'    (select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = c.contract_number',
'     and a.approval_status = ''In-Progress''',
'    and a.seq_count < c.seq_count ',
'    )  Previousely_Cerified_Pending',
'    ,',
'    (select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = c.contract_number',
'     and a.approval_status = ''In-Progress''',
'    and a.seq_count < c.seq_count ',
'    )  Previousely_Cerified_Pending_H',
'    ',
'    , current_valuation_amount',
'    , nvl(deductions,0)    deductions',
'    , net_amount_payable',
'    ,',
'    (',
'    (select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = c.contract_number',
'      and a.approval_status in (''In-Progress'',''Approved'')',
'    and a.seq_count < c.seq_count ',
'    ) + c.net_amount_payable',
'    ) Cumulative_Cerified_Amount,',
'-- Calc End',
'(select m.contract_amount',
'     from cwip_contract m',
'     where m.contract_number = c.contract_number) Contract_amount,',
'    attachements,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    approval_status,',
'    currency,',
'    INVOICE_NUM, INVOICE_DATE, TOTAL_INVOICE_AMOUNT, CONTRACT_STAGE,VERSON,SCOPE_OF_WORK, REMARK',
'FROM',
'    cwip_payment_recommendation c',
'where c.contract_number = :P3_CONTRACT_NUMBER',
'order by contract_number , seq_count',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P3_CONTRACT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_document_header=>'SERVER'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Payment Recommendation Report'
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
 p_id=>wwv_flow_api.id(11057762589190017)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_PAYMENT_RECOMMENDATION_ID,P4_FROM_PAGE,P4_PAYMENT_RECOMMENDATION_ID_H,P4_REFERENCE_CODE,P4_PREVIOUSELY_CERIFIED_PENDING_H,P4_PREVIOUSELY_CERIFIED_APPROVED_H,P4_PROJECT_NUMBER:#PAYMENT_RECOMMENDATION_ID#,3,#PAYME'
||'NT_RECOMMENDATION_ID#,&P3_REFERENCE_CODE.,#PREVIOUSELY_CERIFIED_PENDING_H#,#PREVIOUSELY_CERIFIED_APPROVED_H#,&P3_PROJECT_NUMBER.'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>11057762589190017
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11057891614190018)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11057941228190019)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Reference#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11058007393190020)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Preparation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11058154680190021)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Contract #'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11058273580190022)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Payment #'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11058370501190023)
,p_db_column_name=>'PAYMENT_TYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Payment Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(11506379812678238)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11058533266190025)
,p_db_column_name=>'EVALUATION_METHOD'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Evaluation Method'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(11506516891683324)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11058751848190027)
,p_db_column_name=>'PERIOD'
,p_display_order=>90
,p_column_identifier=>'J'
,p_column_label=>'Period'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32174916078488835)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_APPROVED'
,p_display_order=>100
,p_column_identifier=>'AD'
,p_column_label=>'Previously Certified Approved'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32570131114581215)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_APPROVED_H'
,p_display_order=>110
,p_column_identifier=>'AI'
,p_column_label=>'Previousely Cerified Approved H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32175041790488836)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_PENDING'
,p_display_order=>120
,p_column_identifier=>'AE'
,p_column_label=>'Previously Certified Pending'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32569186243581205)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_PENDING_H'
,p_display_order=>130
,p_column_identifier=>'AG'
,p_column_label=>'Previousely Cerified Pending H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11058640403190026)
,p_db_column_name=>'CURRENT_VALUATION_AMOUNT'
,p_display_order=>140
,p_column_identifier=>'I'
,p_column_label=>'Current Valuation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11058890158190028)
,p_db_column_name=>'DEDUCTIONS'
,p_display_order=>150
,p_column_identifier=>'K'
,p_column_label=>'Deductions'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11059089979190030)
,p_db_column_name=>'NET_AMOUNT_PAYABLE'
,p_display_order=>160
,p_column_identifier=>'M'
,p_column_label=>'Net Amount Payable'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32175157752488837)
,p_db_column_name=>'CUMULATIVE_CERIFIED_AMOUNT'
,p_display_order=>170
,p_column_identifier=>'AF'
,p_column_label=>'Cumulative Certified Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11059110926190031)
,p_db_column_name=>'ATTACHEMENTS'
,p_display_order=>180
,p_column_identifier=>'N'
,p_column_label=>'Attachements'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(11414111784180670)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11059278015190032)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>190
,p_column_identifier=>'O'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11059362694190033)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>200
,p_column_identifier=>'P'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11059478573190034)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>210
,p_column_identifier=>'Q'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11059591748190035)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>220
,p_column_identifier=>'R'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12356214082862802)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>230
,p_column_identifier=>'S'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21271234809381938)
,p_db_column_name=>'CURRENCY'
,p_display_order=>240
,p_column_identifier=>'T'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21271392881381939)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>250
,p_column_identifier=>'U'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21271463969381940)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>260
,p_column_identifier=>'V'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21271598155381941)
,p_db_column_name=>'TOTAL_INVOICE_AMOUNT'
,p_display_order=>270
,p_column_identifier=>'W'
,p_column_label=>'Total Invoice Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21271667008381942)
,p_db_column_name=>'CONTRACT_STAGE'
,p_display_order=>280
,p_column_identifier=>'X'
,p_column_label=>'Contract Stage'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29917898175177107)
,p_db_column_name=>'VALUATION_PERIOD_FROM'
,p_display_order=>290
,p_column_identifier=>'Y'
,p_column_label=>'Valuation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29918147096177110)
,p_db_column_name=>'SCOPE_OF_WORK'
,p_display_order=>300
,p_column_identifier=>'AB'
,p_column_label=>'Scope Of Work'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29918297693177111)
,p_db_column_name=>'REMARK'
,p_display_order=>310
,p_column_identifier=>'AC'
,p_column_label=>'Remark'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32569293629581206)
,p_db_column_name=>'VERSON'
,p_display_order=>320
,p_column_identifier=>'AH'
,p_column_label=>'Verson'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(32802864731539619)
,p_db_column_name=>'CONTRACT_AMOUNT'
,p_display_order=>330
,p_column_identifier=>'AJ'
,p_column_label=>'Contract Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(11505501212666214)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'115056'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_view_mode=>'REPORT'
,p_report_columns=>'REFERENCE_NUMBER:PAYMENT_NUMBER:PAYMENT_TYPE:EVALUATION_METHOD:VALUATION_PERIOD_FROM:PREVIOUSELY_CERIFIED_APPROVED:PREVIOUSELY_CERIFIED_PENDING:CURRENT_VALUATION_AMOUNT:DEDUCTIONS:NET_AMOUNT_PAYABLE:CUMULATIVE_CERIFIED_AMOUNT:APPROVAL_STATUS:'
,p_sort_column_1=>'0'
,p_sort_direction_1=>'ASC NULLS LAST'
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
 p_id=>wwv_flow_api.id(66412590865020609)
,p_report_id=>wwv_flow_api.id(11505501212666214)
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
,p_column_bg_color=>'#15D438'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(66412911154020610)
,p_report_id=>wwv_flow_api.id(11505501212666214)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#E8E545'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(66413377891020611)
,p_report_id=>wwv_flow_api.id(11505501212666214)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11057257963190012)
,p_plug_name=>'Actions'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(11133056164956048)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11057303149190013)
,p_plug_name=>'User Actions'
,p_parent_plug_id=>wwv_flow_api.id(11057257963190012)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader:t-Region--scrollBody:t-Form--slimPadding'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(11133056164956048)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(11449013460431254)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(11192132056956085)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11306804510042588)
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
 p_id=>wwv_flow_api.id(11307491411042610)
,p_plug_name=>'Contract# <b> &P3_CONTRACT_NUMBER. </b> Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(11133056164956048)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'CWIP_CONTRACTS_V'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11056680268190006)
,p_plug_name=>'Contract Details'
,p_parent_plug_id=>wwv_flow_api.id(11307491411042610)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(11116089530956038)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11056718261190007)
,p_plug_name=>'Project Details'
,p_parent_plug_id=>wwv_flow_api.id(11307491411042610)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-expanded:t-Region--noBorder:t-Region--scrollBody:t-Form--slimPadding'
,p_plug_template=>wwv_flow_api.id(11116089530956038)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11056811412190008)
,p_plug_name=>'Contracting Party'
,p_parent_plug_id=>wwv_flow_api.id(11307491411042610)
,p_icon_css_classes=>'fa-user'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody:t-Form--slimPadding'
,p_plug_template=>wwv_flow_api.id(11133056164956048)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11350422058042637)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(11307491411042610)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11195131831956089)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition_type=>'NEVER'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11350822014042638)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(11307491411042610)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11195131831956089)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition_type=>'NEVER'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11350045045042637)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(11307491411042610)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11195131831956089)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition_type=>'NEVER'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11349263300042637)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11307491411042610)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(11195252240956089)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20421874753199248)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11057088377190010)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11194401589956088)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Payment Recommendation'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_CONTRACT_NUMBER,P4_FROM_PAGE,P4_REFERENCE_CODE,P4_AVAILABLE_CONTRACT_BALANCE:&P3_CONTRACT_NUMBER.,3,&P3_REFERENCE_CODE.,&P3_AVAILABLE_CONTRACT_BALANCE.'
,p_icon_css_classes=>'fa-file-plus'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(11351125893042638)
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(42207042974343147)
,p_name=>'P3_CONTRACT_AMOUNT_CALC'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_prompt=>'Contract Amount'
,p_post_element_text=>'<b>&nbsp; &P3_CURRENCY_CODE.</b>'
,p_source=>'select trim(to_char(INITIAL_CONTRACT_AMOUNT + CONTRACT_VARIATION_AMOUNT , ''99,999,999,999,999.99'')) from cwip_contracts_v where contract_number = :P3_CONTRACT_NUMBER'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11307856165042610)
,p_name=>'P3_CONTRACT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'PO Number :'
,p_source=>'CONTRACT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11308244763042611)
,p_name=>'P3_CONTRACT_DESCRIPTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Contract Description :'
,p_source=>'CONTRACT_DESCRIPTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11308671778042611)
,p_name=>'P3_CONTRACT_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'CONTRACT_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11309023483042611)
,p_name=>'P3_BILLED_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Billed Amount :'
,p_post_element_text=>'<b>&nbsp; &P3_CURRENCY_CODE.</b>'
,p_format_mask=>'99G999G999G999G999G999G999G999G999G999G990'
,p_source=>'BILLED_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11309471264042611)
,p_name=>'P3_INITIAL_CONTRACT_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Initial Contract Amount :'
,p_post_element_text=>'<b>&nbsp; &P3_CURRENCY_CODE.</b>'
,p_format_mask=>'99G999G999G999G999G999G999G999G999G999G990'
,p_source=>'INITIAL_CONTRACT_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11309896280042612)
,p_name=>'P3_CONTRACT_VARIATION_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Contract Variation Amount :'
,p_post_element_text=>'<b>&nbsp; &P3_CURRENCY_CODE.</b>'
,p_format_mask=>'99G999G999G999G999G999G999G999G999G999G990'
,p_source=>'CONTRACT_VARIATION_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11310266595042612)
,p_name=>'P3_VENDOR_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>730
,p_item_plug_id=>wwv_flow_api.id(11307491411042610)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_source=>'VENDOR_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11310649889042612)
,p_name=>'P3_VENDOR_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(11056811412190008)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Vendor Name :'
,p_source=>'VENDOR_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11311053211042612)
,p_name=>'P3_VENDOR_SITE_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(11056811412190008)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Vendor Site Code :'
,p_source=>'VENDOR_SITE_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11311486592042613)
,p_name=>'P3_CONTRACT_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Contract Type :'
,p_source=>'CONTRACT_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11311854379042613)
,p_name=>'P3_CONTRACT_MODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Contract Mode :'
,p_source=>'CONTRACT_MODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11312214368042613)
,p_name=>'P3_ATTRIBUTE_CATEGORY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Attribute Category :'
,p_source=>'ATTRIBUTE_CATEGORY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
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
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11312615263042613)
,p_name=>'P3_BUYER_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Buyer Name :'
,p_source=>'BUYER_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11313053605042614)
,p_name=>'P3_APPROVED_FLAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Approved ? :'
,p_source=>'APPROVED_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(11414111784180670)||'.'
,p_cHeight=>1
,p_display_when_type=>'NEVER'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11313461184042614)
,p_name=>'P3_APPROVED_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Approved Date :'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'APPROVED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11313811751042614)
,p_name=>'P3_BILLING_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Billing Status :'
,p_source=>'BILLING_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11314298816042614)
,p_name=>'P3_START_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Start Date :'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'START_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11314659359042615)
,p_name=>'P3_END_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'End Date :'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'END_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11315077526042615)
,p_name=>'P3_CONTRACT_DAYS'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>490
,p_item_plug_id=>wwv_flow_api.id(11307491411042610)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_source=>'CONTRACT_DAYS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11315409736042615)
,p_name=>'P3_CURRENCY_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Currency :'
,p_source=>'CURRENCY_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11315831157042615)
,p_name=>'P3_CANCEL_FLAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Cancelled ? '
,p_source=>'CANCEL_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(11414111784180670)||'.'
,p_cHeight=>1
,p_display_when_type=>'NEVER'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11316235934042616)
,p_name=>'P3_CLOSED_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Closed Code :'
,p_source=>'CLOSED_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11316642564042616)
,p_name=>'P3_CONTRACT_ADMIN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>480
,p_item_plug_id=>wwv_flow_api.id(11307491411042610)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_source=>'CONTRACT_ADMIN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11317099611042616)
,p_name=>'P3_CREATION_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>410
,p_item_plug_id=>wwv_flow_api.id(11307491411042610)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_source=>'CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11317466399042616)
,p_name=>'P3_LAST_UPDATE_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(11307491411042610)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_source=>'LAST_UPDATE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11317862716042617)
,p_name=>'P3_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>440
,p_item_plug_id=>wwv_flow_api.id(11307491411042610)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11318236972042617)
,p_name=>'P3_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>450
,p_item_plug_id=>wwv_flow_api.id(11307491411042610)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11319002465042617)
,p_name=>'P3_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>460
,p_item_plug_id=>wwv_flow_api.id(11307491411042610)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11319411155042617)
,p_name=>'P3_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>470
,p_item_plug_id=>wwv_flow_api.id(11307491411042610)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11320266351042618)
,p_name=>'P3_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11056718261190007)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_source=>'PROJECT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11320637577042618)
,p_name=>'P3_PROJECT_CONTRACT_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(11056718261190007)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Project Contract Amount :'
,p_post_element_text=>'&P3_CURRENCY_CODE.'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'PROJECT_CONTRACT_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11321042659042618)
,p_name=>'P3_PROJECT_BILLED_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(11056718261190007)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Project Billed Amount :'
,p_post_element_text=>'&P3_CURRENCY_CODE.'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'PROJECT_BILLED_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11321472884042619)
,p_name=>'P3_PROJECT_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>500
,p_item_plug_id=>wwv_flow_api.id(11307491411042610)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_source=>'PROJECT_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11321873554042619)
,p_name=>'P3_PROJECT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11056718261190007)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Project Name :'
,p_source=>'PROJECT_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11322212785042619)
,p_name=>'P3_DCT_PROJECT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(11056718261190007)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'DCT Project Name :'
,p_source=>'DCT_PROJECT_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11322635830042619)
,p_name=>'P3_PROJECT_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>520
,p_item_plug_id=>wwv_flow_api.id(11307491411042610)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_source=>'PROJECT_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11323019134042620)
,p_name=>'P3_PROJECT_START_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(11056718261190007)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Project Start Date :'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'PROJECT_START_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11323427462042620)
,p_name=>'P3_PROJECT_END_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(11056718261190007)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Project End Date :'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'PROJECT_END_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11323812420042620)
,p_name=>'P3_TCA_PROGRAMS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>530
,p_item_plug_id=>wwv_flow_api.id(11307491411042610)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_source=>'TCA_PROGRAMS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21161435981775244)
,p_name=>'P3_CONTRACT_REFERENCE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Contract Reference :'
,p_source=>'CONTRACT_REFERENCE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29487359923468135)
,p_name=>'P3_REFERENCE_CODE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(11056718261190007)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_code                VARCHAR2(50);',
'  l_project_code        varchar2(50);',
'  l_contract_code       varchar2(50);',
'BEGIN',
'  select nvl(p.dct_project_code,''XXX'')',
'  into l_project_code',
'  from project p',
'  where p.project_number = :P3_PROJECT_NUMBER;',
'  ',
'  SELECT nvl(c.dct_contract_code,''XXX'')',
'   into    l_contract_code',
'  FROM cwip_contract c',
'  where c.contract_number = :P3_CONTRACT_NUMBER;',
'  ',
'  return l_project_code || ''-REC-'' || l_contract_code || ''-'' ;',
'  ',
'  ',
'END;'))
,p_source_type=>'FUNCTION_BODY'
,p_display_as=>'NATIVE_HIDDEN'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29920363146177132)
,p_name=>'P3_BALANCE'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_prompt=>'Balance :'
,p_post_element_text=>'<b>&nbsp; &P3_CURRENCY_CODE.</b>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(nvl(c.contract_amount,0) - nvl(c.billed_amount, 0) , ''99,999,999,999.99'') bal',
'from cwip_contract c',
'where c.contract_number = :P3_CONTRACT_NUMBER'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29921013812177139)
,p_name=>'P3_DCT_COST_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_item_source_plug_id=>wwv_flow_api.id(11307491411042610)
,p_prompt=>'Cost Type :'
,p_source=>'DCT_COST_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(31456384388181443)
,p_name=>'P3_AVAILABLE_CONTRACT_BALANCE'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(11056680268190006)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(contract_amount,0) - nvl(billed_amount,0) from cwip_contract',
'where contract_number = :P3_CONTRACT_NUMBER'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(11318779955042617)
,p_validation_name=>'P3_CREATED_ON must be timestamp'
,p_validation_sequence=>260
,p_validation=>'P3_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(11318236972042617)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(11319969762042618)
,p_validation_name=>'P3_UPDATED_ON must be timestamp'
,p_validation_sequence=>280
,p_validation=>'P3_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(11319411155042617)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(11352017821042638)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(11307491411042610)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Contract Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(11351665642042638)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(11307491411042610)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Contract Details'
);
wwv_flow_api.component_end;
end;
/
