prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'Credit Cards'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Scroll Results Only in Side Column */',
'',
'',
'/*  Table Row Selected */',
'.a-GV-table tr.is-selected .a-GV-cell {',
'    background-color: #CEF6CE;',
'}',
'',
'/* Audit Region */',
'#history    .t-Region-header {',
'     background-color: #f3f0ef;',
'    color:#000;',
'}',
'#ID_APPROVAL_control_panel{',
'     display:none;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220313135047'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(62275266815852309)
,p_plug_name=>'Credit Cards Register'
,p_icon_css_classes=>'fa-credit-card-terminal'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'TREASURY_ADMIN_YN'
,p_plug_display_when_cond2=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(62275133191852308)
,p_plug_name=>'Credit Cards Report'
,p_parent_plug_id=>wwv_flow_api.id(62275266815852309)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23834504913372554)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    ccr.id,',
'    ccr.holder_person_id,',
'    ccr.holder_person_id    person_id,',
'    ccr.holder_name,',
'    ccr.expired_date,',
'    ccr.email,',
'    ccr.credit_limit,',
'    trim(to_char(credit_limit,''99,999,999,999.99'')) credit_limit_H,',
'    ccr.department_id,',
'    ccr.sector_id,',
'    ccr.cost_center,',
'    ccr.adcb_customer_yn,',
'    ccr.adcb_mobile_registered,',
'    ccr.adcb_email_registered,',
'    ccr.notes,',
'    ccr.status,',
'',
'    Case STATUS',
'            when ''Active''                   Then ''fa fa-check-circle''',
'            when ''In-Active''                Then ''fa-stop-circle-o''',
'            when ''Replacement in-progress''  Then ''fa-refresh''',
'            when ''Closing in-progress''      Then ''fa fa-times''',
'            when ''decreasing in-progress''   Then ''fa-long-arrow-down''',
'            when ''Increasing in-progress''   Then ''fa-long-arrow-up''',
'            when ''Under Process''            Then ''''',
'        End     icon,',
'        Case STATUS',
'            when ''Active''                       Then ''green''',
'            when ''In-Active''                    Then ''red''',
'            when ''Replacement in-progress''      Then ''blue''',
'            when ''Closing in-progress''          Then ''red''',
'            when ''decreasing in-progress''       Then ''red''',
'            when ''Increasing in-progress''       Then ''green''',
'            when ''Under Process''                Then ''blue''',
'        End     icon_color,',
'    ccr.created_by_request_id,',
'    ccr.created_by,',
'    ccr.created_on,',
'    ccr.updated_by,',
'    ccr.updated_on',
'     , ''<span aria-hidden="true" class="fa fa-circle-arrow-out-ne fa-2x"></span>'' Increase_limit',
'      , ''<span aria-hidden="true" class="fa fa-circle-arrow-out-ne fa-2x"></span>'' Increase_limit2',
'      , ''<span aria-hidden="true" class="fa fa-circle-arrow-out-sw fa-2x"></span>'' decrease_limit',
'      , ''<span aria-hidden="true" class="fa fa-circle-arrow-out-sw fa-2x"></span>'' decrease_limit2',
'      , ''<span aria-hidden="true" class="fa fa-stop-circle-o fa-2x fam-x fam-is-danger"></span>'' close_card',
'       , ''<span aria-hidden="true" class="fa fa-stop-circle-o fa-2x fam-x fam-is-danger"></span>'' close_card2',
'       , ''<span aria-hidden="true" class="fa fa-refresh fa-2x"></span>'' replacement',
'    ,',
'    case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'       when 0  THEN',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'        else  ',
'            ',
'         ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'       end Photo',
'FROM',
'    credit_cards_all ccr, employees_v e',
'where ccr.holder_person_id = e.person_id;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Credit Cards Report'
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
 p_id=>wwv_flow_api.id(62275009705852307)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::P21_CREDIT_CARD_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>54531289769073047
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62274928102852306)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62274854540852305)
,p_db_column_name=>'HOLDER_PERSON_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Employee Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62274710333852304)
,p_db_column_name=>'HOLDER_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Holder Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61981283715759853)
,p_db_column_name=>'EXPIRED_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Expired Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61981136642759852)
,p_db_column_name=>'EMAIL'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61981019698759851)
,p_db_column_name=>'CREDIT_LIMIT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Credit Limit'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61980917076759850)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24140385314244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61980888274759849)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24140385314244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61980786105759848)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61980629546759847)
,p_db_column_name=>'ADCB_CUSTOMER_YN'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'ADCB Customer?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24160177889244781)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61980518761759846)
,p_db_column_name=>'ADCB_MOBILE_REGISTERED'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'ADCB Mobile Registered'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61980482042759845)
,p_db_column_name=>'ADCB_EMAIL_REGISTERED'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'ADCB Email Registered'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61980381231759844)
,p_db_column_name=>'NOTES'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61980205207759843)
,p_db_column_name=>'CREATED_BY_REQUEST_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By Request Id'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61980193257759842)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61980058561759841)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61979919666759840)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61979827444759839)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61979681839759837)
,p_db_column_name=>'PHOTO'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61979499751759836)
,p_db_column_name=>'INCREASE_LIMIT'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Increase Limit'
,p_column_link=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:20:P20_ACTION,P20_CREDIT_CARD_ID,P20_HOLDER_NAME,P20_ACTION_NAME,P20_CURRENT_AMOUNT,P20_CURRENT_AMOUNT_H,P20_HOLDER_PERSON_ID:I,#ID#,#HOLDER_NAME#,Increase credit card limit,#CREDIT_LIMIT#,#CREDIT_LIMIT_H#,#HOLDER_P'
||'ERSON_ID#'
,p_column_linktext=>'#INCREASE_LIMIT#'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61979460228759835)
,p_db_column_name=>'DECREASE_LIMIT'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Decrease Limit'
,p_column_link=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:20:P20_ACTION,P20_CREDIT_CARD_ID,P20_HOLDER_NAME,P20_ACTION_NAME,P20_CURRENT_AMOUNT,P20_CURRENT_AMOUNT_H,P20_HOLDER_PERSON_ID:D,#ID#,#HOLDER_NAME#,Decrease credit card limit,#CREDIT_LIMIT#,#CREDIT_LIMIT_H#,#HOLDER_P'
||'ERSON_ID#'
,p_column_linktext=>'#DECREASE_LIMIT#'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(61979306288759834)
,p_db_column_name=>'CLOSE_CARD'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Close Card'
,p_column_link=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:20:P20_ACTION,P20_CREDIT_CARD_ID,P20_HOLDER_NAME,P20_ACTION_NAME,P20_HOLDER_PERSON_ID:C,#ID#,#HOLDER_NAME#,Close credit card,#HOLDER_PERSON_ID#'
,p_column_linktext=>'#CLOSE_CARD#'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25223956112575746)
,p_db_column_name=>'STATUS'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Status'
,p_column_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::P21_CREDIT_CARD_ID:#ID#'
,p_column_linktext=>'#STATUS#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25223275010575739)
,p_db_column_name=>'ICON'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Status'
,p_column_html_expression=>'<span class="#ICON#" style="color: #ICON_COLOR#"></span>'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25223158583575738)
,p_db_column_name=>'ICON_COLOR'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Icon Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25159027847138450)
,p_db_column_name=>'CREDIT_LIMIT_H'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Credit Limit H'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24677417198466140)
,p_db_column_name=>'INCREASE_LIMIT2'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Increase Limit'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_NEW,P2_APPROVAL_TYPE,P2_CREATED_BY_REQUEST_ID:#PERSON_ID#,3,#ID#'
,p_column_linktext=>'#INCREASE_LIMIT2#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24677386953466139)
,p_db_column_name=>'DECREASE_LIMIT2'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Decrease Limit'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_NEW,P2_APPROVAL_TYPE:#PERSON_ID#,4'
,p_column_linktext=>'#DECREASE_LIMIT2#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24677292722466138)
,p_db_column_name=>'CLOSE_CARD2'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Close Card'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_NEW,P2_APPROVAL_TYPE:#PERSON_ID#,5'
,p_column_linktext=>'#CLOSE_CARD2#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24676991709466135)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18101192742298129)
,p_db_column_name=>'REPLACEMENT'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Replace'
,p_column_link=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.:27:P27_CREDIT_CARD_ID:#ID#'
,p_column_linktext=>'#REPLACEMENT#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(61967884910720992)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'548385'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PHOTO:HOLDER_PERSON_ID:EMAIL:CREDIT_LIMIT:SECTOR_ID:STATUS:INCREASE_LIMIT2:DECREASE_LIMIT2:CLOSE_CARD2::REPLACEMENT'
,p_sum_columns_on_break=>'CREDIT_LIMIT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(25224547914575752)
,p_plug_name=>'Credit Cards Status'
,p_icon_css_classes=>'fa-credit-card fa-2x'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'TREASURY_ADMIN_YN'
,p_plug_display_when_cond2=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(25224408882575751)
,p_plug_name=>'By Count'
,p_parent_plug_id=>wwv_flow_api.id(25224547914575752)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(id) cards_count , sum(credit_limit)  total_amount, status',
'    ,        Case STATUS',
'            when ''Hold''         Then ''gray''',
'            when ''Active''     Then ''green''',
'            when ''Under Process''  Then ''Yellow''',
'            when ''In-Active''     Then ''red''',
' --           when ''Withdraw''     Then ''blue''',
'        End     icon_color',
'from credit_cards_all',
'group by status'))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(25224352509575750)
,p_region_id=>wwv_flow_api.id(25224408882575751)
,p_chart_type=>'donut'
,p_title=>'Credit cards count by status (Total: &P1_CC_COUNT.)'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
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
,p_legend_rendered=>'on'
,p_legend_position=>'bottom'
,p_overview_rendered=>'off'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlightAndExplode'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(25224250355575749)
,p_chart_id=>wwv_flow_api.id(25224352509575750)
,p_seq=>10
,p_name=>'Credit Cards By Count'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'CARDS_COUNT'
,p_items_label_column_name=>'STATUS'
,p_color=>'&ICON_COLOR.'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideSlice'
,p_items_label_display_as=>'ALL'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(25223886488575745)
,p_plug_name=>'By Amount'
,p_parent_plug_id=>wwv_flow_api.id(25224547914575752)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(id) cards_count , sum(credit_limit)  total_amount, status',
'    ,        Case STATUS',
'            when ''Hold''         Then ''gray''',
'            when ''Active''     Then ''green''',
'            when ''Under Process''  Then ''Yellow''',
'            when ''In-Active''     Then ''red''',
' --           when ''Withdraw''     Then ''blue''',
'        End     icon_color',
'from credit_cards_all',
'group by status'))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(25223731884575744)
,p_region_id=>wwv_flow_api.id(25223886488575745)
,p_chart_type=>'donut'
,p_title=>'Credit cards Amount by Status (Total: &P1_CC_AMOUNT. AED)'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
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
,p_legend_rendered=>'on'
,p_legend_position=>'bottom'
,p_overview_rendered=>'off'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(25223652399575743)
,p_chart_id=>wwv_flow_api.id(25223731884575744)
,p_seq=>10
,p_name=>'Credit Cards By Count'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'TOTAL_AMOUNT'
,p_items_label_column_name=>'STATUS'
,p_color=>'&ICON_COLOR.'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideSlice'
,p_items_label_display_as=>'ALL'
,p_threshold_display=>'onIndicator'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(23743586532932515)
,p_plug_name=>'Credit Cards Requests'
,p_region_name=>'ID_APPROVAL'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody:margin-top-none'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       CREATOR_PERSON_ID,',
'       REQUESTOR_PERSON_ID,',
'       REQUESTOR_ORG_ID,',
'       DEPARTMENT_ID,',
'       SECTOR_ID,',
'       COST_CENTER,',
'       (select c.cc_name_en',
'        from dct_cost_centers c',
'        where c.cc_code = cc.cost_center',
'        and ROWNUM  = 1) Cost_Center_name,',
'       PURPOSE,',
'       REQUESTED_AMOUNT,',
'       APPROVED_AMOUNT,',
'       EMPLOYEE_NUMBER,',
'       MOTHER_NAME,',
'       EMAIL,',
'       MOBILE_NUMBER,',
'       OFFICE_NUMBER,',
'       POSITION_NAME,',
'       POSITION_ID,',
'       ADCB_CUSTOMER_YN,',
'       ADCB_MOBILE_REGISTERED,',
'       ADCB_EMAIL_REGISTERED,',
'       DCT_APPROVAL_STATUS,',
'       decode(BANK_APPROVAL_STATUS,''Draft'' , ''Not Started'', BANK_APPROVAL_STATUS) BANK_APPROVAL_STATUS,',
'       NOTES,',
'       SUBMISSION_DATE,',
'       FINAL_DCT_APPROVAL,',
'       FINAL_BANK_APPROVAL,',
'       CREATED_BY_PERSON_ID,',
'       CREATED_ON,',
'       UPDATED_BY_PERSON_ID,',
'       UPDATED_ON, ',
'       APPROVAL_TYPE',
'  from CREDIT_CARDS  cc',
'  where REQUESTOR_PERSON_ID = decode(:TREASURY_ADMIN_YN,''Y'', REQUESTOR_PERSON_ID, :PERSON_ID)',
'  or CREATOR_PERSON_ID = decode(:TREASURY_ADMIN_YN,''Y'', CREATOR_PERSON_ID, :PERSON_ID)',
'  order by UPDATED_ON  desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Credit Cards Requests'
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
 p_id=>wwv_flow_api.id(23743641807932516)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'you don''t have any credit card requests.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ID,P2_ID2:#ID#,#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>23743641807932516
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23743775490932517)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23743828368932518)
,p_db_column_name=>'CREATOR_PERSON_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Creator'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(24146885424244788)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23743915128932519)
,p_db_column_name=>'REQUESTOR_PERSON_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Requestor'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24146885424244788)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23744096327932520)
,p_db_column_name=>'REQUESTOR_ORG_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Organization'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(24146367401244788)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23744193904932521)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24146367401244788)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23744210443932522)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24146367401244788)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23744337063932523)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23744448142932524)
,p_db_column_name=>'PURPOSE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23744524415932525)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23744656751932526)
,p_db_column_name=>'APPROVED_AMOUNT'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Approved Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23744714790932527)
,p_db_column_name=>'EMPLOYEE_NUMBER'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Employee Number'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23744820273932528)
,p_db_column_name=>'MOTHER_NAME'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Mother Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23744982815932529)
,p_db_column_name=>'EMAIL'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23745002936932530)
,p_db_column_name=>'MOBILE_NUMBER'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Mobile Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23745197611932531)
,p_db_column_name=>'OFFICE_NUMBER'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Office Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23745242101932532)
,p_db_column_name=>'POSITION_NAME'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Position Name'
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
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23745329646932533)
,p_db_column_name=>'POSITION_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Position Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23745428106932534)
,p_db_column_name=>'ADCB_CUSTOMER_YN'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'ADCB Customer ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24160177889244781)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23745590302932535)
,p_db_column_name=>'ADCB_MOBILE_REGISTERED'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'ADCB Mobile Registered'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23745681173932536)
,p_db_column_name=>'ADCB_EMAIL_REGISTERED'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'ADCB Email Registered'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23745748992932537)
,p_db_column_name=>'DCT_APPROVAL_STATUS'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'DOA Approval  Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23745821043932538)
,p_db_column_name=>'BANK_APPROVAL_STATUS'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Finance Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23745914539932539)
,p_db_column_name=>'NOTES'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(23747099185932550)
,p_db_column_name=>'SUBMISSION_DATE'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Submission Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24215273022492701)
,p_db_column_name=>'FINAL_DCT_APPROVAL'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Final DCT Approval On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24215366442492702)
,p_db_column_name=>'FINAL_BANK_APPROVAL'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Final Bank Approval'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24215465302492703)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(24146885424244788)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24215521557492704)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24215647534492705)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(24146885424244788)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24215708868492706)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(33462645473009025)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24678335834466149)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Request Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(24669503372330760)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(24232703342492064)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'242328'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUESTOR_PERSON_ID:DEPARTMENT_ID:COST_CENTER:PURPOSE:REQUESTED_AMOUNT:EMAIL:ADCB_CUSTOMER_YN:DCT_APPROVAL_STATUS:BANK_APPROVAL_STATUS:'
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
 p_id=>wwv_flow_api.id(17704338363582020)
,p_report_id=>wwv_flow_api.id(24232703342492064)
,p_name=>'Finance Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'BANK_APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("BANK_APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(17703952920582019)
,p_report_id=>wwv_flow_api.id(24232703342492064)
,p_name=>'Finance In-Progress'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'BANK_APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("BANK_APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(17703528560582019)
,p_report_id=>wwv_flow_api.id(24232703342492064)
,p_name=>'Finance rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'BANK_APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("BANK_APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(17703149794582019)
,p_report_id=>wwv_flow_api.id(24232703342492064)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'DCT_APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("DCT_APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(17702780264582019)
,p_report_id=>wwv_flow_api.id(24232703342492064)
,p_name=>'In-Progress'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'DCT_APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("DCT_APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(17702368350582018)
,p_report_id=>wwv_flow_api.id(24232703342492064)
,p_name=>'Rejected'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'DCT_APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("DCT_APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(17701901283582018)
,p_report_id=>wwv_flow_api.id(24232703342492064)
,p_name=>'Return'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'DCT_APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Returned'
,p_condition_sql=>' (case when ("DCT_APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Returned''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFD6D2'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(23934730216372424)
,p_plug_name=>'Credit Cards-Test'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23845862961372548)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(23782494216372596)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(23899958141372507)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(34282467274651535)
,p_plug_name=>'Overview'
,p_icon_css_classes=>'fa-money fa-anim-flash fam-information fam-is-warning'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  ''Total'' label,',
'        COUNT( cc.id) value,',
'        trim(to_char(nvl(sum(cc.requested_amount),0), ''99,999,999.99'')) || '' AED'' total_amount',
'       ,apex_util.prepare_url( ''f?p=''||:APP_ID||'':11:''||:APP_SESSION||''::NO::P11_DOA_STATUS,P11_FINANCE_STATUS:''|| ''All,Draft''  ) as link',
'from credit_cards cc',
'where cc.dct_approval_status != ''Draft''',
'Union all',
'select  ''DOA Approved'' label,',
'        COUNT( cc.id) value,',
'        trim(to_char(nvl(sum(cc.requested_amount),0), ''99,999,999.99'')) || '' AED'' total_amount',
'       ,apex_util.prepare_url( ''f?p=''||:APP_ID||'':11:''||:APP_SESSION||''::NO:ClearCache:P11_DOA_STATUS:''|| ''Approved'' ) as link',
'from credit_cards cc',
'where cc.dct_approval_status = ''Approved''',
'UNION All',
'select  ''Finance Approved'' label,',
'        COUNT( cc.id) value,',
'        trim(to_char(nvl(sum(cc.requested_amount),0), ''99,999,999.99'')) || '' AED'' total_amount',
'        ,apex_util.prepare_url( ''f?p=''||:APP_ID||'':11:''||:APP_SESSION||''::NO::P11_DOA_STATUS,P11_FINANCE_STATUS:''|| ''Approved,Approved'' ) as link',
'from credit_cards cc',
'where cc.bank_approval_status = ''Approved'''))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'TREASURY_ADMIN_YN'
,p_plug_display_when_cond2=>'Y'
,p_attribute_01=>'TOTAL_AMOUNT'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'&LINK.'
,p_attribute_05=>'0'
,p_attribute_06=>'B'
,p_attribute_07=>'DOT'
,p_attribute_08=>'Y'
,p_attribute_09=>'LABEL'
,p_plug_comment=>'only available to role: TREASURY_ADMIN_YN'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(164656980952899408)
,p_plug_name=>'My Credit Card'
,p_icon_css_classes=>'fa-credit-card-terminal'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(165004991901265559)
,p_plug_name=>'My Credit Cards Report'
,p_parent_plug_id=>wwv_flow_api.id(164656980952899408)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23834504913372554)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    ccr.id,',
'    ccr.holder_person_id,',
'    ccr.holder_person_id    person_id,',
'    ccr.holder_name,',
'    ccr.expired_date,',
'    ccr.email,',
'    ccr.credit_limit,',
'    trim(to_char(credit_limit,''99,999,999,999.99'')) credit_limit_H,',
'    ccr.department_id,',
'    ccr.sector_id,',
'    ccr.cost_center,',
'    ccr.adcb_customer_yn,',
'    ccr.adcb_mobile_registered,',
'    ccr.adcb_email_registered,',
'    ccr.notes,',
'    ccr.status,',
'    Case STATUS',
'            when ''Active''           Then ''fa fa-check-circle''',
'            when ''In-Active''        Then ''fa fa-times''',
'            when ''Under Process''    Then ''fa-gear''',
'        End     icon,',
'        Case STATUS',
'            when ''Active''          Then ''green''',
'            when ''In-Active''       Then ''red''',
'           when ''Under Process''    Then ''blue''',
'        End     icon_color,',
'    ccr.created_by_request_id,',
'    ccr.created_by,',
'    ccr.created_on,',
'    ccr.updated_by,',
'    ccr.updated_on',
'  --   , ''<span aria-hidden="true" class="fa fa-circle-arrow-out-ne fa-2x"></span>'' Increase_limit',
'      , ''<span aria-hidden="true" class="fa fa-circle-arrow-out-ne fa-2x"></span>'' Increase_limit2',
'  --    , ''<span aria-hidden="true" class="fa fa-circle-arrow-out-sw fa-2x"></span>'' decrease_limit',
'      , ''<span aria-hidden="true" class="fa fa-circle-arrow-out-sw fa-2x"></span>'' decrease_limit2',
'  --    , ''<span aria-hidden="true" class="fa fa-stop-circle-o fa-2x fam-x fam-is-danger"></span>'' close_card',
'       , ''<span aria-hidden="true" class="fa fa-stop-circle-o fa-2x fam-x fam-is-danger"></span>'' close_card2',
'    ,',
'    case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'       when 0  THEN',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'        else  ',
'            ',
'         ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'       end Photo',
'FROM',
'    credit_cards_all ccr, employees_v e',
'where ccr.holder_person_id = e.person_id',
'and ccr.holder_person_id = :PERSON_ID;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'My Credit Cards Report'
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
 p_id=>wwv_flow_api.id(165005077689265560)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'you don''t have any active credit card.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::P21_CREDIT_CARD_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>281811377164190914
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22112157901741591)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22111787601741591)
,p_db_column_name=>'CREDIT_LIMIT_H'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Credit Limit H'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22111320860741591)
,p_db_column_name=>'INCREASE_LIMIT2'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Increase Limit'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_NEW,P2_APPROVAL_TYPE:#PERSON_ID#,3'
,p_column_linktext=>'#INCREASE_LIMIT2#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22110992601741591)
,p_db_column_name=>'DECREASE_LIMIT2'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Decrease Limit'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_NEW,P2_APPROVAL_TYPE:#PERSON_ID#,4'
,p_column_linktext=>'#DECREASE_LIMIT2#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22110548057741591)
,p_db_column_name=>'CLOSE_CARD2'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Close Card'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_NEW,P2_APPROVAL_TYPE:#PERSON_ID#,5'
,p_column_linktext=>'#CLOSE_CARD2#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22110161709741590)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22109706167741590)
,p_db_column_name=>'HOLDER_PERSON_ID'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Employee Name'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22109379285741590)
,p_db_column_name=>'HOLDER_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Holder Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22108996905741590)
,p_db_column_name=>'EXPIRED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Expired Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22108504764741590)
,p_db_column_name=>'EMAIL'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22108184599741590)
,p_db_column_name=>'CREDIT_LIMIT'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Credit Limit'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22107754562741589)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22107359042741589)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22106994634741589)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22106582348741589)
,p_db_column_name=>'ADCB_CUSTOMER_YN'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'ADCB Customer?'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22106144267741589)
,p_db_column_name=>'ADCB_MOBILE_REGISTERED'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'ADCB Mobile Registered'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22105733080741588)
,p_db_column_name=>'ADCB_EMAIL_REGISTERED'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'ADCB Email Registered'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22105393202741588)
,p_db_column_name=>'NOTES'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22104912903741588)
,p_db_column_name=>'CREATED_BY_REQUEST_ID'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Created By Request Id'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22104511579741588)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22104131197741588)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22103770447741588)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22103375243741587)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22102966536741587)
,p_db_column_name=>'PHOTO'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22102562046741587)
,p_db_column_name=>'STATUS'
,p_display_order=>280
,p_column_identifier=>'Y'
,p_column_label=>'Status'
,p_column_html_expression=>'<span class="#ICON#" style="color: #ICON_COLOR#"> #STATUS#</span>'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22102110913741587)
,p_db_column_name=>'ICON'
,p_display_order=>290
,p_column_identifier=>'Z'
,p_column_label=>'Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22101739207741587)
,p_db_column_name=>'ICON_COLOR'
,p_display_order=>300
,p_column_identifier=>'AA'
,p_column_label=>'Icon Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(165019486678277766)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'947049'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PHOTO:HOLDER_PERSON_ID:CREDIT_LIMIT:SECTOR_ID:STATUS:INCREASE_LIMIT2:DECREASE_LIMIT2:CLOSE_CARD2:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(23742454925932504)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(23934730216372424)
,p_button_name=>'New_Credit_Card'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Credit Card'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_APPROVAL_TYPE:2'
,p_icon_css_classes=>'fa-plus-square-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25223457201575741)
,p_name=>'P1_CC_COUNT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(25224547914575752)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(*)',
'from credit_cards_all'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25223350047575740)
,p_name=>'P1_CC_AMOUNT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(25224547914575752)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(sum(credit_limit) , ''99,999,999,999.99''))',
'from credit_cards_all'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(17747044985098038)
,p_name=>'Close Replacement Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(62275133191852308)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(17746944666098037)
,p_event_id=>wwv_flow_api.id(17747044985098038)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.component_end;
end;
/
