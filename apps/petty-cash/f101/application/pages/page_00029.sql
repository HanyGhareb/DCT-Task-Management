prompt --application/pages/page_00029
begin
--   Manifest
--     PAGE: 00029
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>29
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Petty Cash - Expenses Report'
,p_alias=>'PETTY-CASH-EXPENSES-REPORT'
,p_step_title=>'Petty Cash - Expenses Report'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200906071634'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4394804142542044)
,p_plug_name=>'Petty Cash Expenses Reports'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select er.EXPENSE_REPORT_ID,',
'       er.PETTY_CASH_ID,',
'       er.EXPENSE_REPORT_DATE,',
'       er.PURPOSE,',
'       er.APPROVAL_STATUS,',
'       er.INVOICING_YN,',
'       er.PRIORITY,',
'       er.JUSTIFICATION,',
'       er.COMMENT_TO_APPROVER,',
'       er.CREATION_DATE,',
'       er.CREATED_BY,',
'       er.UPDATED_BY,',
'       er.UPDATED_DATE,',
'       er.YEAR,',
'       er.EXPENSE_REPORT_NUM',
'       , (Select to_char(sum(nvl(l.receipt_amount,0)),''99,999,999.99'')     ',
'        from hrss_expense_report_lines l',
'        where l.expense_report_id = er.expense_report_id) Total_Amount',
'       , pc.petty_cash_no',
'       , pc.petty_cash_type',
'       , pc.amount  Petty_Cash_Amount',
'       , pc.project_number',
'       , pc.task',
'  from HRSS_EXPENSE_REPORTS er , hrss_petty_cash pc',
' where er.PETTY_CASH_ID  = pc.PETTY_CASH_ID',
' and er.PETTY_CASH_ID = :P29_PETTY_CASH_ID;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Petty Cash Expenses Reports'
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
 p_id=>wwv_flow_api.id(4394913667542045)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>6384951994605809
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4395044591542046)
,p_db_column_name=>'EXPENSE_REPORT_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Expense Report Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4395147912542047)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4395176384542048)
,p_db_column_name=>'EXPENSE_REPORT_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Expense Report Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4395359204542049)
,p_db_column_name=>'PURPOSE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4395448878542050)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4395482393542051)
,p_db_column_name=>'INVOICING_YN'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Invoicing Yn'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4395637518542052)
,p_db_column_name=>'PRIORITY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4395757363542053)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4395828922542054)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4395864816542055)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4395972226542056)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4396150078542057)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4396261397542058)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4396330340542059)
,p_db_column_name=>'YEAR'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4396456967542060)
,p_db_column_name=>'EXPENSE_REPORT_NUM'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Expense Report Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4396495219542061)
,p_db_column_name=>'TOTAL_AMOUNT'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Total Amount'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4396571003542062)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Petty Cash No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4396726169542063)
,p_db_column_name=>'PETTY_CASH_TYPE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Petty Cash Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4396818492542064)
,p_db_column_name=>'PETTY_CASH_AMOUNT'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Petty Cash Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4396946088542065)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4397058346542066)
,p_db_column_name=>'TASK'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(4426497637999954)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'64166'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EXPENSE_REPORT_ID:PETTY_CASH_ID:EXPENSE_REPORT_DATE:PURPOSE:APPROVAL_STATUS:INVOICING_YN:PRIORITY:JUSTIFICATION:COMMENT_TO_APPROVER:CREATION_DATE:CREATED_BY:UPDATED_BY:UPDATED_DATE:YEAR:EXPENSE_REPORT_NUM:TOTAL_AMOUNT:PETTY_CASH_NO:PETTY_CASH_TYPE:PE'
||'TTY_CASH_AMOUNT:PROJECT_NUMBER:TASK'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4418675243953342)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4397168246542068)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(4394804142542044)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New'
,p_button_position=>'TOP'
,p_button_redirect_url=>'f?p=&APP_ID.:18:&SESSION.::&DEBUG.::P18_PETTY_CASH_ID:&P29_PETTY_CASH_ID.'
,p_icon_css_classes=>'fa-plus-square-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4397159832542067)
,p_name=>'P29_PETTY_CASH_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(4418675243953342)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4397317880542069)
,p_name=>'P29_PETTY_CASH_NO'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(4418675243953342)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.component_end;
end;
/
