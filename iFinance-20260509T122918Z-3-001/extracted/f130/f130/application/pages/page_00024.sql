prompt --application/pages/page_00024
begin
--   Manifest
--     PAGE: 00024
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
 p_id=>24
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Contract Details'
,p_alias=>'CONTRACT-DETAILS'
,p_step_title=>'Contract Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240201092048'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11871042496373942)
,p_plug_name=>'TPC Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10228155320597771)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(174222219206664937)
,p_plug_name=>'Contract End Users'
,p_parent_plug_id=>wwv_flow_api.id(11871042496373942)
,p_icon_css_classes=>'fa-user'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>8
,p_plug_display_column=>2
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(174222263930664938)
,p_plug_name=>'Contract End Users Report'
,p_parent_plug_id=>wwv_flow_api.id(174222219206664937)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       CONTRACT_NUMBER,',
'       PERSON_ID,',
'       STATUS,',
'       START_DATE,',
'       END_DATE,',
'       NOTES,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE',
'  from CWIP_CONTRACT_END_USERS',
'  where contract_number = :P24_CONTRACT_NUMBER',
'  order by 1'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_CONTRACT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Contract End Users Report'
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
 p_id=>wwv_flow_api.id(174222372592664939)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_show_detail_link=>'C'
,p_detail_link=>'f?p=&APP_ID.:71:&SESSION.::&DEBUG.:71:P71_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>214658414421567209
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(174222517784664940)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(174222606979664941)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(174222720823664942)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(174222777494664943)
,p_db_column_name=>'STATUS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(10760317215192499)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(174222871722664944)
,p_db_column_name=>'START_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(174222969163664945)
,p_db_column_name=>'END_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(174223105304664946)
,p_db_column_name=>'NOTES'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(174223170167664947)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(174223309590664948)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(174223367288664949)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(174223500429664950)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(174669362734376942)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2151055'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PERSON_ID:STATUS:START_DATE:END_DATE:NOTES:CREATED_BY:UPDATED_BY:CREATION_DATE:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11871840058373950)
,p_plug_name=>'Selector'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_DISPLAY_SELECTOR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'STANDARD'
,p_attribute_02=>'Y'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12203339883870627)
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
 p_id=>wwv_flow_api.id(12203945824870851)
,p_plug_name=>'Contract Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'CWIP_CONTRACT'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11871126564373943)
,p_plug_name=>'DOF Details'
,p_parent_plug_id=>wwv_flow_api.id(12203945824870851)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10228155320597771)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11870956278373941)
,p_plug_name=>'Financial Details'
,p_parent_plug_id=>wwv_flow_api.id(11871126564373943)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10228155320597771)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24136575251555674)
,p_plug_name=>'Payment Recommendations'
,p_icon_css_classes=>'fa-box-arrow-out-east'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
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
'    valuation_period,',
'    evaluation_method,',
'    period,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    approval_status',
'    ',
'    ,(',
'    select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = p.contract_number',
'    and a.approval_status = ''Approved''',
'    and a.seq_count < p.seq_count',
'    ) Previousely_Cerified_Approved ',
'    ,',
'    (select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = p.contract_number',
'     and a.approval_status = ''In-Progress''',
'    and a.seq_count < p.seq_count ',
'    )  Previousely_Cerified_Pending',
'',
'    ',
'    , current_valuation_amount',
'    , nvl(deductions,0)    deductions',
'    , net_amount_payable',
'    ,',
'    (',
'    (select nvl(sum(a.net_amount_payable),0)',
'    from cwip_payment_recommendation a',
'    where a.contract_number = p.contract_number',
'      and a.approval_status in (''In-Progress'',''Approved'')',
'    and a.seq_count < p.seq_count ',
'    ) + p.net_amount_payable',
'    ) Cumulative_Cerified_Amount',
'    , case approval_status when ''Draft''  Then ''Y''',
'                           when ''Return'' Then ''Y''',
'           else ''N''',
'       end allow_edit    ',
'from cwip_payment_recommendation p',
'where p.contract_number = :P24_CONTRACT_NUMBER',
'order by contract_number , seq_count'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_CONTRACT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
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
 p_id=>wwv_flow_api.id(24136706681555675)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Payments Recommendations for This Contract'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:68:&SESSION.::&DEBUG.:68:P68_PAYMENT_RECOMMENDATION_ID,P68_FROM_PAGE,P68_PROJECT_NUMBER,P68_CONTRACT_NUMBER:#PAYMENT_RECOMMENDATION_ID#,24,&P24_PROJECT_NUMBER.,#CONTRACT_NUMBER#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>24136706681555675
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12297109005311969)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12297596826311970)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Reference Number'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12297976810311970)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Payment Recommendation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12298342699311970)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12298782405311970)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12299162723311971)
,p_db_column_name=>'PAYMENT_TYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Payment Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(11865753263354609)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12299585244311971)
,p_db_column_name=>'VALUATION_PERIOD'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Valuation Period'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12299959010311971)
,p_db_column_name=>'EVALUATION_METHOD'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Evaluation Method'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(11865220875354600)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12300333744311971)
,p_db_column_name=>'CURRENT_VALUATION_AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Current Valuation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12300775346311972)
,p_db_column_name=>'PERIOD'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Period'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12301185042311972)
,p_db_column_name=>'DEDUCTIONS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Deductions'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12301971888311972)
,p_db_column_name=>'NET_AMOUNT_PAYABLE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Net Amount Payable'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12302779061311973)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12303185600311973)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12303519982311973)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12303935478311974)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12304378708311974)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(574487629608734)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_APPROVED'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Previousely Cerified Approved'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(574568011608735)
,p_db_column_name=>'PREVIOUSELY_CERIFIED_PENDING'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Previousely Cerified Pending'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(574723723608736)
,p_db_column_name=>'CUMULATIVE_CERIFIED_AMOUNT'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Cumulative Cerified Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(99632854537221662)
,p_db_column_name=>'ALLOW_EDIT'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Allow Edit'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(24161116019654624)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'123047'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REFERENCE_NUMBER:PAYMENT_NUMBER:PAYMENT_RECOMMENDATION_DATE:PAYMENT_TYPE:EVALUATION_METHOD:CURRENT_VALUATION_AMOUNT:DEDUCTIONS:NET_AMOUNT_PAYABLE:APPROVAL_STATUS:'
,p_sort_column_1=>'PAYMENT_RECOMMENDATION_DATE'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'PAYMENT_NUMBER'
,p_sort_direction_2=>'ASC'
,p_sum_columns_on_break=>'CURRENT_VALUATION_AMOUNT:DEDUCTIONS:NET_AMOUNT_PAYABLE'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(174642503294310559)
,p_report_id=>wwv_flow_api.id(24161116019654624)
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
 p_id=>wwv_flow_api.id(174642920986310560)
,p_report_id=>wwv_flow_api.id(24161116019654624)
,p_name=>'Draft'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Draft'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Draft''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(174643343637310560)
,p_report_id=>wwv_flow_api.id(24161116019654624)
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
 p_id=>wwv_flow_api.id(24146981088557455)
,p_plug_name=>'Contract Invoices'
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>80
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    invoice_number,',
'    voucher_number,',
'    contract_number,',
'    description,',
'    invoice_date,',
'    invoice_received_date,',
'    approval_status,',
'    invoice_validation,',
'    invoice_type,',
'    payment_method,',
'    source,',
'    payment_status,',
'    currency_code,',
'    creation_date,',
'    created_by,',
'    validation_date,',
'    validated_by,',
'    validated_user,',
'    final_approval_date,',
'    approved_by,',
'    exchange_rate,',
'    exchange_date,',
'    payment_date,',
'    invoice_amount,',
'    functional_amount',
'from cwip_contract_invoices inv',
'where inv.contract_number = :P24_CONTRACT_NUMBER',
'and inv.invoice_amount <> 0 '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_CONTRACT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Project Invoices'
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
 p_id=>wwv_flow_api.id(24147093568557456)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Invoices for this Contract'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>24147093568557456
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12305468113313729)
,p_db_column_name=>'INVOICE_NUMBER'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12305809157313729)
,p_db_column_name=>'VOUCHER_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Voucher Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12306261861313730)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12306692405313730)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12307003973313730)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12307497083313731)
,p_db_column_name=>'INVOICE_RECEIVED_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Invoice Received Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12307822632313731)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12308253295313731)
,p_db_column_name=>'INVOICE_VALIDATION'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Invoice Validation'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12308672309313732)
,p_db_column_name=>'INVOICE_TYPE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Invoice Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12309030380313732)
,p_db_column_name=>'PAYMENT_METHOD'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Payment Method'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12309484037313732)
,p_db_column_name=>'SOURCE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Source'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12309839943313733)
,p_db_column_name=>'PAYMENT_STATUS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Payment Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(10893109140999643)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12310212775313733)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Currency Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12310672273313733)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12311071944313734)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12311477337313734)
,p_db_column_name=>'VALIDATION_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Validation Date'
,p_column_type=>'STRING'
,p_format_mask=>'DD-MON-YYYY'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12311818980313734)
,p_db_column_name=>'VALIDATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Validated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12312277742313735)
,p_db_column_name=>'VALIDATED_USER'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Validated User'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12312628478313735)
,p_db_column_name=>'FINAL_APPROVAL_DATE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Final Approval Date'
,p_column_type=>'STRING'
,p_format_mask=>'DD-MON-YYYY'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12313048010313735)
,p_db_column_name=>'APPROVED_BY'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Approved By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12313773440313746)
,p_db_column_name=>'EXCHANGE_RATE'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Exchange Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12314182671313746)
,p_db_column_name=>'EXCHANGE_DATE'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Exchange Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12314506460313746)
,p_db_column_name=>'PAYMENT_DATE'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Payment Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12314999285313746)
,p_db_column_name=>'INVOICE_AMOUNT'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Invoice Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12315352938313747)
,p_db_column_name=>'FUNCTIONAL_AMOUNT'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Functional Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(24187407944697350)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'123157'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>20
,p_report_columns=>'INVOICE_NUMBER:CONTRACT_NUMBER:INVOICE_AMOUNT:DESCRIPTION:INVOICE_DATE:PAYMENT_METHOD:PAYMENT_STATUS:PAYMENT_DATE:'
,p_sort_column_1=>'PAYMENT_DATE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(29920433504177133)
,p_plug_name=>'PME Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10228155320597771)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(31267781561762845)
,p_plug_name=>'Contractual Securities'
,p_icon_css_classes=>'fa-calendar-check-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>100
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID, CONTRACT_NUMBER, CONTRACTUAL_SECURITY_ID, ',
'        CONTRACT_REQUIRED, REFERENCE_NUMBER, AMOUNT, ',
'        VALID_FROM, VALID_TO, Validity, ',
'        DECODE(NVL(Validity, ''N''), ''Y'', ''fa fa-check-circle'', ''fa fa-times-circle'') icon,',
'        DECODE(NVL(Validity, ''N''), ''Y'', ''green'', ''red'') icon_color,',
'        NOTES, FILENAME, FILE_MIMETYPE, FILE_CHARSET, ',
'        FILE_BLOB, CREATED_BY_PERSON_ID, UPDATED_BY_PERSON_ID, ',
'        CREATION_DATE, UPDATED_DATE',
'from',
'(select  ID, CONTRACT_NUMBER, CONTRACTUAL_SECURITY_ID, CONTRACT_REQUIRED, ',
'        REFERENCE_NUMBER, AMOUNT, VALID_FROM, VALID_TO, ',
'        case when sysdate >= valid_from and sysdate <= valid_to Then ''Y''',
'            Else ''N''',
'        End Validity,',
'        NOTES, FILENAME, ',
'        FILE_MIMETYPE, FILE_CHARSET, FILE_BLOB, CREATED_BY_PERSON_ID, ',
'        UPDATED_BY_PERSON_ID, CREATION_DATE, UPDATED_DATE',
'from cwip_contract_contractual_securities)',
' where CONTRACT_NUMBER = :P24_CONTRACT_NUMBER',
' order by ID;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_CONTRACT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Contractual Securities'
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
 p_id=>wwv_flow_api.id(31424507262227435)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.:34:P34_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>31424507262227435
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31424642671227436)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31424790025227437)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31424835470227438)
,p_db_column_name=>'CONTRACTUAL_SECURITY_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Contractual Security'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(31396667483343774)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31424956207227439)
,p_db_column_name=>'CONTRACT_REQUIRED'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Contract Required ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(10893109140999643)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425039881227440)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Reference Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425147820227441)
,p_db_column_name=>'AMOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425269407227442)
,p_db_column_name=>'VALID_FROM'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Valid From'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425371477227443)
,p_db_column_name=>'VALID_TO'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Valid To'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425493001227444)
,p_db_column_name=>'NOTES'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425591828227445)
,p_db_column_name=>'FILENAME'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Filename'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425656800227446)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425743213227447)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31425955127227449)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31426062641227450)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(20691219654288121)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31452189340181401)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31452262273181402)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31452601893181406)
,p_db_column_name=>'ICON'
,p_display_order=>190
,p_column_identifier=>'T'
,p_column_label=>'Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31452762991181407)
,p_db_column_name=>'ICON_COLOR'
,p_display_order=>200
,p_column_identifier=>'U'
,p_column_label=>'Icon Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31452847049181408)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>210
,p_column_identifier=>'V'
,p_column_label=>'File Blob'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'OTHER'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31452909478181409)
,p_db_column_name=>'VALIDITY'
,p_display_order=>220
,p_column_identifier=>'W'
,p_column_label=>'Validity'
,p_column_html_expression=>'<span class="#ICON#" style="color: #ICON_COLOR#"></span>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(31471950571173816)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'314720'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CONTRACTUAL_SECURITY_ID:CONTRACT_REQUIRED:REFERENCE_NUMBER:AMOUNT:VALID_FROM:VALID_TO:NOTES:FILENAME:UPDATED_BY_PERSON_ID:UPDATED_DATE:ICON:ICON_COLOR:VALIDITY'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(39725357227361324)
,p_plug_name=>'Documents'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>90
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24005544191643512)
,p_plug_name=>'Payments Recommendations Attachments'
,p_parent_plug_id=>wwv_flow_api.id(39725357227361324)
,p_icon_css_classes=>'fa-file-archive-o fam-check fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    row_version_number,',
'    payment_recommendation_id,',
'    pay_recommendation_num,',
'    contract_number,',
'    project_number,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    file_comments,',
'    tags,',
'    created,',
'    created_by,',
'    updated,',
'    updated_by,',
'    comment_id ,',
'    download',
'from (',
'            SELECT',
'                id,',
'                row_version_number,',
'                payment_recommendation_id,',
'                (select c.reference_number',
'                from cwip_payment_recommendation c',
'                where c.payment_recommendation_id = d.payment_recommendation_id) PAY_RECOMMENDATION_NUM,',
'                (select c.contract_number',
'                from cwip_payment_recommendation c',
'                where c.payment_recommendation_id = d.payment_recommendation_id) Contract_number,',
'                (select p.project_number',
'                    from cwip_contract_projects p',
'                    where p.contract_number = (select c.contract_number',
'                                                from cwip_payment_recommendation c',
'                                                where c.payment_recommendation_id = d.payment_recommendation_id)',
'                       and rownum = 1                         ) Project_number,',
'                                                ',
'                filename,',
'                file_mimetype,',
'                file_charset,',
'                file_blob,',
'                file_comments,',
'                tags,',
'                created,',
'                created_by,',
'                updated,',
'                updated_by,',
'                comment_id,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'       sys.dbms_lob.getlength(file_blob) as download',
'            FROM',
'                cwip_payment_recommendation_documents d',
')',
'where Contract_number = :P24_CONTRACT_NUMBER'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_CONTRACT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Project Attachements'
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
 p_id=>wwv_flow_api.id(24107767023388480)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No attachments available for this contract'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_show_flashback=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>24107767023388480
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12290806534309978)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>10
,p_column_identifier=>'F'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12290405439309978)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'E'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12290054856309977)
,p_db_column_name=>'PAY_RECOMMENDATION_NUM'
,p_display_order=>30
,p_column_identifier=>'D'
,p_column_label=>'Payment Recommendation REF#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12291200284309978)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'G'
,p_column_label=>'File Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12292879965309979)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>60
,p_column_identifier=>'K'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12293214481309979)
,p_db_column_name=>'TAGS'
,p_display_order=>70
,p_column_identifier=>'L'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12288825251309976)
,p_db_column_name=>'ID'
,p_display_order=>80
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12289235462309977)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>90
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12289617373309977)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>100
,p_column_identifier=>'C'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12291692563309978)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>110
,p_column_identifier=>'H'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12292078031309979)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>120
,p_column_identifier=>'I'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12293676981309980)
,p_db_column_name=>'CREATED'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12294056238309980)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12294437087309980)
,p_db_column_name=>'UPDATED'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12294889329309980)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12295232553309981)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12292416078309979)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>180
,p_column_identifier=>'J'
,p_column_label=>'file blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12295681338309981)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>190
,p_column_identifier=>'R'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:CWIP_PAYMENT_RECOMMENDATION_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(24117892863394332)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'122960'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CONTRACT_NUMBER:PAY_RECOMMENDATION_NUM:FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
,p_sort_column_1=>'UPDATED'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(39725459252361325)
,p_plug_name=>'Contract Attachments'
,p_parent_plug_id=>wwv_flow_api.id(39725357227361324)
,p_icon_css_classes=>'fa-file-archive-o fam-check fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    row_version_number,',
'    payment_recommendation_id,',
'    pay_recommendation_num,',
'    contract_number,',
'    project_number,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    file_comments,',
'    tags,',
'    created,',
'    created_by,',
'    updated,',
'    updated_by,',
'    comment_id ,',
'    download',
'from (',
'            ',
'        select id,',
'                row_version_number,',
'                null  payment_recommendation_id,',
'                null  PAY_RECOMMENDATION_NUM,',
'                 Contract_number,',
'                 Project_number,                                ',
'                filename,',
'                file_mimetype,',
'                file_charset,',
'                file_blob,',
'                file_comments,',
'                tags,',
'                created,',
'                created_by,',
'                updated,',
'                updated_by,',
'                comment_id,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'       sys.dbms_lob.getlength(file_blob) as download',
'    from cwip_contract_documents)',
'where Contract_number = :P24_CONTRACT_NUMBER',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_CONTRACT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Project Attachements'
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
 p_id=>wwv_flow_api.id(39725680209361327)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No attachments available for this contract'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_show_flashback=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:49:&SESSION.::&DEBUG.:49:P49_ID,P49_PAGE_FROM:#ID#,24'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>39725680209361327
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39725774922361328)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39725849588361329)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726091599361331)
,p_db_column_name=>'PAY_RECOMMENDATION_NUM'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Payment Recommendation REF#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726185052361332)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726221756361333)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726303905361334)
,p_db_column_name=>'FILENAME'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'File Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726429239361335)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726542008361336)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726641340361337)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'file blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726720761361338)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726834146361339)
,p_db_column_name=>'TAGS'
,p_display_order=>120
,p_column_identifier=>'K'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39726961217361340)
,p_db_column_name=>'CREATED'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39727082169361341)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39727141451361342)
,p_db_column_name=>'UPDATED'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39727211279361343)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>160
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39727385891361344)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>170
,p_column_identifier=>'P'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39727480882361345)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>180
,p_column_identifier=>'Q'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:CWIP_CONTRACT_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(39727501626361346)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>190
,p_column_identifier=>'R'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(40061015508719016)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'400611'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
,p_sort_column_1=>'UPDATED_BY'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(185168681732633431)
,p_plug_name=>'Finance'
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(223229658470968763)
,p_plug_name=>'<span aria-hidden="true" class="fa fa-number-1-o "></span> Contract Members'
,p_icon_css_classes=>'fa-emoji-unamused'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10228155320597771)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(222878090757392651)
,p_name=>'Internal Contrtact Team'
,p_parent_plug_id=>wwv_flow_api.id(223229658470968763)
,p_template=>wwv_flow_api.id(10245193460597780)
,p_display_sequence=>20
,p_icon_css_classes=>'fa-chevron-circle-right'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--noBorders'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    t.id,',
'    t.project_number,',
'    t.task_number,',
'    t.contract_number,',
'    t.person_id,',
'    -- Persondetails',
'    e.full_name_en,',
'    CASE',
'        WHEN dbms_lob.getlength(e.photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || e.user_name',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END PHOTO,',
'    -- role_destails',
'    t.role_id,',
'    r.role_name,',
'    r.description,',
'    r.category_id,',
'    t.person_type,',
'    t.start_date,',
'    t.end_date,',
'    t.status,',
'    t.notes,',
'    t.created_by,',
'    t.created_on,',
'    t.updated_by,',
'    t.updated_on',
'FROM',
'    cwip_team t , project_role r , dct_employees_list2 e',
'where t.contract_number = :P24_CONTRACT_NUMBER',
'and t.role_id = r.role_id',
'and t.person_id = e.person_id',
'and r.category_id = 2'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P24_CONTRACT_NUMBER'
,p_query_row_template=>wwv_flow_api.id(10271480393597797)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Team assined.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170937562039692576)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>1
,p_column_heading=>'<span class="u-VisuallyHidden">Edit Member</span>'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.::P22_ID:#ID#'
,p_column_linktext=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="Edit Project Member">'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170938040107692577)
,p_query_column_id=>2
,p_column_alias=>'PROJECT_NUMBER'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170938424243692577)
,p_query_column_id=>3
,p_column_alias=>'TASK_NUMBER'
,p_column_display_sequence=>12
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170931170933692573)
,p_query_column_id=>4
,p_column_alias=>'CONTRACT_NUMBER'
,p_column_display_sequence=>5
,p_column_heading=>'Contract Number'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170931564391692573)
,p_query_column_id=>5
,p_column_alias=>'PERSON_ID'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170931966500692574)
,p_query_column_id=>6
,p_column_alias=>'FULL_NAME_EN'
,p_column_display_sequence=>3
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170932408676692574)
,p_query_column_id=>7
,p_column_alias=>'PHOTO'
,p_column_display_sequence=>2
,p_column_heading=>'Photo'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="50" width="50"   style="border-radius:50%">'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170932798284692574)
,p_query_column_id=>8
,p_column_alias=>'ROLE_ID'
,p_column_display_sequence=>14
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170933228236692574)
,p_query_column_id=>9
,p_column_alias=>'ROLE_NAME'
,p_column_display_sequence=>7
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170933589771692574)
,p_query_column_id=>10
,p_column_alias=>'DESCRIPTION'
,p_column_display_sequence=>4
,p_column_heading=>'Description'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170934057711692575)
,p_query_column_id=>11
,p_column_alias=>'CATEGORY_ID'
,p_column_display_sequence=>15
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170934416762692575)
,p_query_column_id=>12
,p_column_alias=>'PERSON_TYPE'
,p_column_display_sequence=>16
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170934834228692575)
,p_query_column_id=>13
,p_column_alias=>'START_DATE'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170935160431692575)
,p_query_column_id=>14
,p_column_alias=>'END_DATE'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170935586262692575)
,p_query_column_id=>15
,p_column_alias=>'STATUS'
,p_column_display_sequence=>6
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_api.id(10760317215192499)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170936038406692576)
,p_query_column_id=>16
,p_column_alias=>'NOTES'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170936377946692576)
,p_query_column_id=>17
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>17
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170936802555692576)
,p_query_column_id=>18
,p_column_alias=>'CREATED_ON'
,p_column_display_sequence=>18
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170937203010692576)
,p_query_column_id=>19
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>19
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170938787696692577)
,p_query_column_id=>20
,p_column_alias=>'UPDATED_ON'
,p_column_display_sequence=>20
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(223072035037928322)
,p_name=>'External Project Team'
,p_parent_plug_id=>wwv_flow_api.id(223229658470968763)
,p_template=>wwv_flow_api.id(10245193460597780)
,p_display_sequence=>40
,p_icon_css_classes=>'fa-chevron-circle-left'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--noBorders'
,p_new_grid_row=>false
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    t.id,',
'    t.project_number,',
'    t.task_number,',
'    t.contract_number,',
'    t.person_id,',
'    -- Persondetails',
'    e.full_name_en,',
'    CASE',
'        WHEN dbms_lob.getlength(e.photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || e.user_name',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END PHOTO,',
'    -- role_destails',
'    t.role_id,',
'    r.role_name,',
'    r.description,',
'    r.category_id,',
'    t.person_type,',
'    t.start_date,',
'    t.end_date,',
'    t.status,',
'    t.notes,',
'    t.created_by,',
'    t.created_on,',
'    t.updated_by,',
'    t.updated_on',
'FROM',
'    cwip_team t , project_role r , dct_ext_users e',
'where t.contract_number = :P24_CONTRACT_NUMBER',
'and t.role_id = r.role_id',
'and t.person_id = e.user_id',
'and r.category_id = 1'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P24_CONTRACT_NUMBER'
,p_query_row_template=>wwv_flow_api.id(10271480393597797)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Team assined.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170922605543692563)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>1
,p_column_heading=>'<span class="u-VisuallyHidden">Edit Member</span>'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23:P23_ID:#ID#'
,p_column_linktext=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="Edit Project Member">'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170922862386692564)
,p_query_column_id=>2
,p_column_alias=>'PROJECT_NUMBER'
,p_column_display_sequence=>7
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170923352111692564)
,p_query_column_id=>3
,p_column_alias=>'TASK_NUMBER'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170923756366692564)
,p_query_column_id=>4
,p_column_alias=>'CONTRACT_NUMBER'
,p_column_display_sequence=>5
,p_column_heading=>'Contract Number'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170924153104692564)
,p_query_column_id=>5
,p_column_alias=>'PERSON_ID'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170924463966692565)
,p_query_column_id=>6
,p_column_alias=>'FULL_NAME_EN'
,p_column_display_sequence=>3
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170924948354692565)
,p_query_column_id=>7
,p_column_alias=>'PHOTO'
,p_column_display_sequence=>2
,p_column_heading=>'Photo'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="50" width="50"   style="border-radius:50%">'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170925348784692565)
,p_query_column_id=>8
,p_column_alias=>'ROLE_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170925720077692565)
,p_query_column_id=>9
,p_column_alias=>'ROLE_NAME'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170926090039692566)
,p_query_column_id=>10
,p_column_alias=>'DESCRIPTION'
,p_column_display_sequence=>4
,p_column_heading=>'Role'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170926546500692566)
,p_query_column_id=>11
,p_column_alias=>'CATEGORY_ID'
,p_column_display_sequence=>12
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170926942558692566)
,p_query_column_id=>12
,p_column_alias=>'PERSON_TYPE'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170927327759692566)
,p_query_column_id=>13
,p_column_alias=>'START_DATE'
,p_column_display_sequence=>15
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170927737540692566)
,p_query_column_id=>14
,p_column_alias=>'END_DATE'
,p_column_display_sequence=>16
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170928102690692567)
,p_query_column_id=>15
,p_column_alias=>'STATUS'
,p_column_display_sequence=>6
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_api.id(10760317215192499)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170928500661692567)
,p_query_column_id=>16
,p_column_alias=>'NOTES'
,p_column_display_sequence=>14
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170928911704692567)
,p_query_column_id=>17
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>17
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170929318965692567)
,p_query_column_id=>18
,p_column_alias=>'CREATED_ON'
,p_column_display_sequence=>18
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170929703446692567)
,p_query_column_id=>19
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>19
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(170930070188692568)
,p_query_column_id=>20
,p_column_alias=>'UPDATED_ON'
,p_column_display_sequence=>20
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12228346191870872)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(12203945824870851)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition=>'P24_CONTRACT_NUMBER'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12227531966870871)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(12203945824870851)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition_type=>'NEVER'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12226703678870870)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(12203339883870627)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:&P24_PAGE_FROM.:&SESSION.::&DEBUG.::P21_PROJECT_NUMBER:&P24_PROJECT_NUMBER.'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12296470171309982)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(39725459252361325)
,p_button_name=>'Add_ATTACHEMENT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10306520873597824)
,p_button_image_alt=>'Add Attachement'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:49:&SESSION.::&DEBUG.:49:P49_CONTRACT_NUMBER,P49_PAGE_FROM,P49_PROJECT_NUMBER:&P24_CONTRACT_NUMBER.,24,&P24_PROJECT_NUMBER.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(99632905787221663)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(24136575251555674)
,p_button_name=>'New_Payment_'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'New Payment'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:68:&SESSION.::&DEBUG.:68:P68_CONTRACT_NUMBER,P68_FROM_PAGE,P68_REFERENCE_CODE,P68_AVAILABLE_CONTRACT_BALANCE,P68_PROJECT_NUMBER,P68_CONTRACT_NUMBER:&P24_CONTRACT_NUMBER.,24,&P24_REFERENCE_CODE.,&P24_AVAILABLE_CONTRACT_BALANCE.,&P24_PROJECT_NUMBER.,&P24_CONTRACT_NUMBER.'
,p_button_condition=>':IS_PME_ROLE > 0 or :IS_SENIOR_PME_ROLE > 0  or :PERSON_ID = 680461'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(170930470718692568)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(223072035037928322)
,p_button_name=>'Add_External_Member'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(10306520873597824)
,p_button_image_alt=>'Add External Team Member'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23:P23_PROJECT_NUMBER,P23_CONTRACT_NUMBER:&P24_PROJECT_NUMBER.,P24_CONTRACT_NUMBER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(170939199900692577)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(222878090757392651)
,p_button_name=>'Add_member'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(10306520873597824)
,p_button_image_alt=>'Add Member'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:22:P22_PROJECT_NUMBER,P22_CONTRACT_NUMBER,P22_PAGE_FROM:&P24_PROJECT_NUMBER.,&P24_CONTRACT_NUMBER.,24'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(174223620477664951)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(174222219206664937)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10306520873597824)
,p_button_image_alt=>'New End User'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:71:&SESSION.::&DEBUG.:71:P71_CONTRACT_NUMBER:&P24_CONTRACT_NUMBER.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(99632067563221655)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(12203339883870627)
,p_button_name=>'New_Payment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_image_alt=>'New Payment'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:68:&SESSION.::&DEBUG.:68:P68_CONTRACT_NUMBER,P68_FROM_PAGE,P68_REFERENCE_CODE,P68_AVAILABLE_CONTRACT_BALANCE,P68_PROJECT_NUMBER,P68_CONTRACT_NUMBER:&P24_CONTRACT_NUMBER.,24,&P24_REFERENCE_CODE.,&P24_AVAILABLE_CONTRACT_BALANCE.,&P24_PROJECT_NUMBER.,&P24_CONTRACT_NUMBER.'
,p_button_condition=>':IS_PME_ROLE > 0 or :IS_SENIOR_PME_ROLE > 0  or :PERSON_ID = 680461'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12227988470870872)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(12203339883870627)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(10307273349597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P24_CONTRACT_NUMBER'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(31452339593181403)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(31267781561762845)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add'
,p_button_position=>'TOP_AND_BOTTOM'
,p_button_redirect_url=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.:34:P34_CONTRACT_NUMBER:&P24_CONTRACT_NUMBER.'
,p_icon_css_classes=>'fa-calendar-ban'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(12228642221870872)
,p_branch_name=>'Go To Page &P24_PAGE_FROM.'
,p_branch_action=>'f?p=&APP_ID.:&P24_PAGE_FROM.:&SESSION.::&DEBUG.::P21_PROJECT_NUMBER:&P24_PROJECT_NUMBER.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4999320829563952)
,p_name=>'P24_DCT_CONTRACT_VARIATION_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(11871042496373942)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'TPC Contract Variation Amount'
,p_source=>'DCT_CONTRACT_VARIATION_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11871586624373947)
,p_name=>'P24_PROJECT_NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12204226320870851)
,p_name=>'P24_CONTRACT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(12203945824870851)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Number'
,p_source=>'CONTRACT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12204615933870854)
,p_name=>'P24_CONTRACT_DESCRIPTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(12203945824870851)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Description'
,p_source=>'CONTRACT_DESCRIPTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12205007304870855)
,p_name=>'P24_CONTRACT_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11870956278373941)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Budget Released for Payment'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'CONTRACT_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
,p_item_comment=>'Revised Contract Amount'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12205413243870855)
,p_name=>'P24_BILLED_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(11870956278373941)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Billed Amount'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BILLED_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12205828046870855)
,p_name=>'P24_INITIAL_CONTRACT_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11870956278373941)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Initial Contract Amount'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'INITIAL_CONTRACT_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12206295036870856)
,p_name=>'P24_CONTRACT_VARIATION_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(11870956278373941)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Variation Amount'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'CONTRACT_VARIATION_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12206691855870856)
,p_name=>'P24_VENDOR_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Vendor Name'
,p_source=>'VENDOR_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12207048767870856)
,p_name=>'P24_VENDOR_SITE_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Vendor Site Code'
,p_source=>'VENDOR_SITE_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12207474255870856)
,p_name=>'P24_CONTRACT_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Type'
,p_source=>'CONTRACT_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12207817248870857)
,p_name=>'P24_CONTRACT_MODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Mode'
,p_source=>'CONTRACT_MODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12208214103870857)
,p_name=>'P24_ATTRIBUTE_CATEGORY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Attribute Category'
,p_source=>'ATTRIBUTE_CATEGORY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12208621591870857)
,p_name=>'P24_BUYER_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Buyer Name'
,p_source=>'BUYER_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12209005126870857)
,p_name=>'P24_APPROVED_FLAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Approved ?'
,p_source=>'APPROVED_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(10893109140999643)||'.'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12209413639870858)
,p_name=>'P24_APPROVED_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Approved Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'APPROVED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12209865570870858)
,p_name=>'P24_BILLING_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Billing Status'
,p_source=>'BILLING_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12210296253870858)
,p_name=>'P24_START_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'START_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12210626191870858)
,p_name=>'P24_END_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'END_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12211072095870859)
,p_name=>'P24_CONTRACT_DAYS'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Days'
,p_format_mask=>'999G999G999G999G999G999G990'
,p_source=>'CONTRACT_DAYS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12211440345870859)
,p_name=>'P24_CURRENCY_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Currency Code'
,p_source=>'CURRENCY_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12211810783870859)
,p_name=>'P24_CANCEL_FLAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Cancel Flag'
,p_source=>'CANCEL_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(10893109140999643)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
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
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12212284459870860)
,p_name=>'P24_CLOSED_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Closed Code'
,p_source=>'CLOSED_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12212635830870860)
,p_name=>'P24_CONTRACT_ADMIN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Admin'
,p_source=>'CONTRACT_ADMIN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12213458566870860)
,p_name=>'P24_LAST_UPDATE_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Last Update Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'LAST_UPDATE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12213831292870861)
,p_name=>'P24_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(12203945824870851)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12214284148870861)
,p_name=>'P24_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(12203945824870851)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12215094808870862)
,p_name=>'P24_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(12203945824870851)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12215498812870862)
,p_name=>'P24_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(12203945824870851)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12216286117870863)
,p_name=>'P24_VENDOR_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11871126564373943)
,p_prompt=>'Vendor Number'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select VENDOR_NUMBER',
'from vendors',
'where VENDOR_NAME = :P24_VENDOR_NAME',
'and VENDOR_SITE_CODE = :P24_VENDOR_SITE_CODE',
'and rownum = 1'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12216685786870863)
,p_name=>'P24_COMPLETION_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(11871042496373942)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Completion Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'COMPLETION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12217042014870863)
,p_name=>'P24_REVISED_COMPLETION_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(11871042496373942)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Revised Completion Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'REVISED_COMPLETION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12458681331889038)
,p_name=>'P24_CONTRACT_TITLE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11871042496373942)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Title'
,p_source=>'CONTRACT_TITLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>1000
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29487067141468132)
,p_name=>'P24_DCT_CONTRACT_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11871042496373942)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'DCT Contract Code'
,p_source=>'DCT_CONTRACT_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>15
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29920917927177138)
,p_name=>'P24_DCT_COST_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(29920433504177133)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Cost Type:'
,p_source=>'DCT_COST_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'COST TYPES LOV'
,p_lov=>'.'||wwv_flow_api.id(30444530399539118)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(31890271424194104)
,p_name=>'P24_PAGE_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(12203339883870627)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(40072228628098344)
,p_name=>'P24_CONTRACT_REFERENCE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(11871042496373942)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Contract Reference'
,p_source=>'CONTRACT_REFERENCE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(58885751080309167)
,p_name=>'P24_REVISED_CONTRACT_AMOUNT'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(11870956278373941)
,p_prompt=>'Revised Contract Amount'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'trim(to_char(nvl(to_number(REPLACE(:P24_INITIAL_CONTRACT_AMOUNT,'','','''')),0)',
'+ ',
'nvl(to_number(REPLACE(:P24_CONTRACT_VARIATION_AMOUNT,'','','''')),0) , ''99,999,999,999.99''))'))
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(99632193823221656)
,p_name=>'P24_REFERENCE_CODE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(12203339883870627)
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_code                VARCHAR2(50);',
'  l_project_code        varchar2(50);',
'  l_contract_code       varchar2(50);',
'BEGIN',
'  select nvl(p.dct_project_code,''XXX'')',
'  into l_project_code',
'  from project p',
'  where p.project_number = :P24_PROJECT_NUMBER;',
'  ',
'  SELECT nvl(c.dct_contract_code,''XXX'')',
'   into    l_contract_code',
'  FROM cwip_contract c',
'  where c.contract_number = :P24_CONTRACT_NUMBER;',
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
 p_id=>wwv_flow_api.id(99632354428221657)
,p_name=>'P24_AVAILABLE_CONTRACT_BALANCE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(12203339883870627)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(contract_amount,0) - nvl(billed_amount,0) from cwip_contract',
'where contract_number = :P24_CONTRACT_NUMBER'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(185168824742633432)
,p_name=>'P24_APPROVAL_CASE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(185168681732633431)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Approval Case'
,p_source=>'APPROVAL_CASE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'CWIP APPROVAL CASE LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = (select l.lookup_id from dct_lookups l where l.lookup_code = ''CWIP_APPROVAL_CASE'') and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(10305900021597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(185168910072633433)
,p_name=>'P24_APPROVER_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(185168681732633431)
,p_item_source_plug_id=>wwv_flow_api.id(12203945824870851)
,p_prompt=>'Approver'
,p_source=>'APPROVER_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES ACTIVE - LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.full_name_en , e.email , e.employee_num, e.person_id',
'from employees_v e',
'where e.current_flag = ''Y''',
'and e.person_id > 10;'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(10306252784597823)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(12214796033870862)
,p_validation_name=>'P24_CREATED_ON must be timestamp'
,p_validation_sequence=>250
,p_validation=>'P24_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(12214284148870861)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(12215976861870863)
,p_validation_name=>'P24_UPDATED_ON must be timestamp'
,p_validation_sequence=>270
,p_validation=>'P24_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(12215498812870862)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(174223765664664953)
,p_name=>'Close New User DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(174223620477664951)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(174223899261664954)
,p_event_id=>wwv_flow_api.id(174223765664664953)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(174222263930664938)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(174224020442664955)
,p_name=>'Close New User DA2'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(174222263930664938)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(174224095883664956)
,p_event_id=>wwv_flow_api.id(174224020442664955)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(174222263930664938)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(185169051091633434)
,p_name=>'Approval Case DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P24_APPROVAL_CASE_ID'
,p_condition_element=>'P24_APPROVAL_CASE_ID'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'297'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(185169120917633435)
,p_event_id=>wwv_flow_api.id(185169051091633434)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_APPROVER_PERSON_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(185169356739633437)
,p_event_id=>wwv_flow_api.id(185169051091633434)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_APPROVER_PERSON_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(185169229675633436)
,p_event_id=>wwv_flow_api.id(185169051091633434)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_APPROVER_PERSON_ID'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(12229501271870873)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(12203945824870851)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Contract Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Contract &P24_CONTRACT_NUMBER. Updated Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(12229140725870873)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(12203945824870851)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Contract Details'
);
wwv_flow_api.component_end;
end;
/
