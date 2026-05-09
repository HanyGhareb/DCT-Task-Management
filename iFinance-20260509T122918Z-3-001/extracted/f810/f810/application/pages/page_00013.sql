prompt --application/pages/page_00013
begin
--   Manifest
--     PAGE: 00013
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>13
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Mission Details'
,p_alias=>'MISSION-DETAILS1'
,p_step_title=>'Mission Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240228210504'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(249902945573027)
,p_plug_name=>'Payroll Details'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT person_id  ',
'FROM dct_data_access_assignment ',
'where entity_type_id = ''ROLE'' ',
'and entity_id = 96 ',
'and status = ''A'' ',
'and sysdate BETWEEN start_date ',
'and nvl(end_date , sysdate + 10)',
'and person_id = :PERSON_ID;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(250011820573028)
,p_plug_name=>'Payroll report'
,p_parent_plug_id=>wwv_flow_api.id(249902945573027)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select id,',
'    request_id,',
'    ou_name,',
'    invoice_type,',
'    supplier_name,',
'    site_name,',
'    invoice_date,',
'    received_date,',
'    gl_date,',
'    invoice_num,',
'    currency,',
'    amount,',
'    payment_method,',
'    invoice_description,',
'    bank_account_num,',
'    inv_context,',
'    emp_name,',
'    emp_num,',
'    bank_name,',
'    bank_acc_num,',
'    pay_group,',
'    payment_term,',
'    gl_account,',
'    line_desc,',
'    project,',
'    task,',
'    expenditure_type,',
'    project_org,',
'    status,',
'    PV_NUMBER,',
'    BATCH_NUMBER',
'from mission_invoices    ',
'where REQUEST_ID = :P13_REQUEST_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P13_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Payroll report'
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
 p_id=>wwv_flow_api.id(250094312573029)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>110860970802580006
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1410130966226330)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'AJ'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(250310530573031)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1028715580809153)
,p_db_column_name=>'OU_NAME'
,p_display_order=>30
,p_column_identifier=>'I'
,p_column_label=>'Ou Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1028739662809154)
,p_db_column_name=>'INVOICE_TYPE'
,p_display_order=>40
,p_column_identifier=>'J'
,p_column_label=>'Invoice Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1028850018809155)
,p_db_column_name=>'SUPPLIER_NAME'
,p_display_order=>50
,p_column_identifier=>'K'
,p_column_label=>'Supplier Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1029013372809156)
,p_db_column_name=>'SITE_NAME'
,p_display_order=>60
,p_column_identifier=>'L'
,p_column_label=>'Site Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1029092825809157)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>70
,p_column_identifier=>'M'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1029184693809158)
,p_db_column_name=>'RECEIVED_DATE'
,p_display_order=>80
,p_column_identifier=>'N'
,p_column_label=>'Received Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1029286238809159)
,p_db_column_name=>'GL_DATE'
,p_display_order=>90
,p_column_identifier=>'O'
,p_column_label=>'Gl Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1029410200809160)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>100
,p_column_identifier=>'P'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1029476993809161)
,p_db_column_name=>'CURRENCY'
,p_display_order=>110
,p_column_identifier=>'Q'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1029583880809162)
,p_db_column_name=>'AMOUNT'
,p_display_order=>120
,p_column_identifier=>'R'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1029697418809163)
,p_db_column_name=>'PAYMENT_METHOD'
,p_display_order=>130
,p_column_identifier=>'S'
,p_column_label=>'Payment Method'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1029820223809164)
,p_db_column_name=>'INVOICE_DESCRIPTION'
,p_display_order=>140
,p_column_identifier=>'T'
,p_column_label=>'Invoice Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1029911588809165)
,p_db_column_name=>'BANK_ACCOUNT_NUM'
,p_display_order=>150
,p_column_identifier=>'U'
,p_column_label=>'Bank Account Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1030020015809166)
,p_db_column_name=>'INV_CONTEXT'
,p_display_order=>160
,p_column_identifier=>'V'
,p_column_label=>'Inv Context'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1030101577809167)
,p_db_column_name=>'EMP_NAME'
,p_display_order=>170
,p_column_identifier=>'W'
,p_column_label=>'Employee Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1030195482809168)
,p_db_column_name=>'EMP_NUM'
,p_display_order=>180
,p_column_identifier=>'X'
,p_column_label=>'Employee Number'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1030250680809169)
,p_db_column_name=>'BANK_NAME'
,p_display_order=>190
,p_column_identifier=>'Y'
,p_column_label=>'Bank Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1030339205809170)
,p_db_column_name=>'BANK_ACC_NUM'
,p_display_order=>200
,p_column_identifier=>'Z'
,p_column_label=>'Bank Acc Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1030497929809171)
,p_db_column_name=>'PAY_GROUP'
,p_display_order=>210
,p_column_identifier=>'AA'
,p_column_label=>'Pay Group'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1030574717809172)
,p_db_column_name=>'PAYMENT_TERM'
,p_display_order=>220
,p_column_identifier=>'AB'
,p_column_label=>'Payment Term'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1030674565809173)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>230
,p_column_identifier=>'AC'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1409574867226324)
,p_db_column_name=>'LINE_DESC'
,p_display_order=>240
,p_column_identifier=>'AD'
,p_column_label=>'Line Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1409700526226325)
,p_db_column_name=>'PROJECT'
,p_display_order=>250
,p_column_identifier=>'AE'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1409743204226326)
,p_db_column_name=>'TASK'
,p_display_order=>260
,p_column_identifier=>'AF'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1409871579226327)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>270
,p_column_identifier=>'AG'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1410016469226328)
,p_db_column_name=>'PROJECT_ORG'
,p_display_order=>280
,p_column_identifier=>'AH'
,p_column_label=>'Project Org'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1410121420226329)
,p_db_column_name=>'STATUS'
,p_display_order=>290
,p_column_identifier=>'AI'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4997679759410356)
,p_db_column_name=>'PV_NUMBER'
,p_display_order=>300
,p_column_identifier=>'AK'
,p_column_label=>'PV Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4997822492410357)
,p_db_column_name=>'BATCH_NUMBER'
,p_display_order=>310
,p_column_identifier=>'AL'
,p_column_label=>'Batch Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(303786792790769)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1109147'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'INVOICE_NUM:SUPPLIER_NAME:INVOICE_DATE:AMOUNT:BANK_ACCOUNT_NUM:EMP_NAME:EMP_NUM:BANK_NAME:PV_NUMBER:STATUS:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(5800482986175244)
,p_report_id=>wwv_flow_api.id(303786792790769)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Pending'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Pending''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(5800914727175243)
,p_report_id=>wwv_flow_api.id(303786792790769)
,p_name=>'Running'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Running'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Running''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#D0F1CC'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(5801301369175243)
,p_report_id=>wwv_flow_api.id(303786792790769)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Success'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Success''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#3BAA2C'
,p_row_font_color=>'#FFFFFF'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(96256011765052827)
,p_plug_name=>'Actions'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'  from MISSION_ACTIONS',
'  where request_id = :P13_REQUEST_ID;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(96256025282052828)
,p_plug_name=>'Actions Report'
,p_parent_plug_id=>wwv_flow_api.id(96256011765052827)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select rownum,',
'        ID,',
'       REQUEST_ID,',
'       ACTION,',
'       COMMENTS,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE',
'  from MISSION_ACTIONS',
'  where request_id = :P13_REQUEST_ID',
'  order by id;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P13_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Actions Report'
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
 p_id=>wwv_flow_api.id(96256136175052829)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>206867012665059806
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(96256225629052830)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(96256368563052831)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(96256508218052832)
,p_db_column_name=>'ACTION'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Action'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(96256564900052833)
,p_db_column_name=>'COMMENTS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(96256639876052834)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(96256738310052835)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Action By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(96256889526052836)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(96256995928052837)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Action On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(96257462507052842)
,p_db_column_name=>'ROWNUM'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(96544494323626308)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2071554'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ROWNUM:ACTION:COMMENTS:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110051456798053601)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12908155528762118)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12844716791762062)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12962203224762162)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110052064977053601)
,p_plug_name=>'Main Details'
,p_icon_css_classes=>'fa-list-alt'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110052472756053600)
,p_plug_name=>'Summary'
,p_parent_plug_id=>wwv_flow_api.id(110052064977053601)
,p_icon_css_classes=>'fa-file-o'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110101242185864203)
,p_plug_name=>'Header Details'
,p_parent_plug_id=>wwv_flow_api.id(110052064977053601)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>7
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4994683251410326)
,p_plug_name=>'Payment Details'
,p_parent_plug_id=>wwv_flow_api.id(110101242185864203)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12881785965762100)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P13_CAR_REQUEST_YN != ''C'' or :P13_CAR_REQUEST_YN  is null'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(92630817503579841)
,p_plug_name=>'Email History'
,p_parent_plug_id=>wwv_flow_api.id(4994683251410326)
,p_icon_css_classes=>'fa-envelope-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       REQUEST_ID,',
'       SEND_TO,',
'       SEND_CC,',
'       SEND_BCC,',
'       MESSAGE_TEXT,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATED_ON,',
'       UPDATED_ON,',
'       SUBJECT',
'  from MISSION_EMAILS',
'  where REQUEST_ID = :P13_REQUEST_ID',
'  order by id desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P13_PAYROLL_AREA_ID not in (1,2)'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Email History'
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
 p_id=>wwv_flow_api.id(92630866327579842)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No emails sent'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>203241742817586819
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92630972030579843)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92631094482579844)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92631217197579845)
,p_db_column_name=>'SEND_TO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Send To'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92631263166579846)
,p_db_column_name=>'SEND_CC'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Send Cc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92631352053579847)
,p_db_column_name=>'SEND_BCC'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Send Bcc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92631497413579848)
,p_db_column_name=>'MESSAGE_TEXT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Message Text'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92631590469579849)
,p_db_column_name=>'FILENAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Filename'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92631634706579850)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92631815034579851)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92631914800579852)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>100
,p_column_identifier=>'J'
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
 p_id=>wwv_flow_api.id(92631948689579853)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Sent By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92632069559579854)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Sent By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92632217741579855)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92632297816579856)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92632386572579857)
,p_db_column_name=>'SUBJECT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Subject'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(92676364731279706)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2032873'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SEND_TO:SEND_CC:SEND_BCC:SUBJECT:MESSAGE_TEXT:UPDATED_BY:UPDATED_ON:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110136595857737706)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(110101242185864203)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12881785965762100)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110052862669053600)
,p_plug_name=>'Budget Details'
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'  from MISSION_DISTRIBUTIONS',
'  where REQUEST_ID = :P13_REQUEST_ID'))
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110139350918737734)
,p_plug_name=>'Budget Report'
,p_parent_plug_id=>wwv_flow_api.id(110052862669053600)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       decode(project_number, null, ''G'', ''P'') allocate_by,',
'       REQUEST_ID,',
'       ENTITY_CODE,',
'       COST_CENTER,',
'       BUDGET_GROUP_CODE,',
'       GL_ACCOUNT,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       AMOUNT,',
'       COMMENTS,',
'       ACTION_BY,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       (ENTITY_CODE',
'       ||''.'' ||',
'       COST_CENTER',
'       ||''.'' ||',
'       BUDGET_GROUP_CODE',
'       ||''.'' ||',
'       GL_ACCOUNT',
'       ||''.'' ||',
'       ACTIVITY',
'       ||''.'' ||',
'       FUTURE1',
'       ||''.'' ||',
'       FUTURE2) gl_combination',
'  from MISSION_DISTRIBUTIONS',
'  where REQUEST_ID = :P13_REQUEST_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P13_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Budget Report'
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
 p_id=>wwv_flow_api.id(110139460505737735)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:64:&SESSION.::&DEBUG.:64:P64_ID,P64_ALLOCATED_BY,P64_REQUEST_ID,P64_PAGE_FROM:#ID#,#ALLOCATE_BY#,#REQUEST_ID#,13'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(:PERSON_ID = 680461 OR :IS_FBP_YN = ''Y'') And',
':P13_PV_NUMBER is null'))
,p_owner=>'TCA9051'
,p_internal_uid=>110139460505737735
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110139554443737736)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110139601153737737)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110139774268737738)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110139855038737739)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110139927985737740)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110140000608737741)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110140127235737742)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110140285713737743)
,p_db_column_name=>'FUTURE1'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110140386700737744)
,p_db_column_name=>'FUTURE2'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110140456265737745)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110140516655737746)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110140640140737747)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110140768402737748)
,p_db_column_name=>'AMOUNT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110140896952737749)
,p_db_column_name=>'COMMENTS'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110140985549737750)
,p_db_column_name=>'ACTION_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Action By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110291302464602601)
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
 p_id=>wwv_flow_api.id(110291463025602602)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110291504513602603)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110291627072602604)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(249757501573026)
,p_db_column_name=>'GL_COMBINATION'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'GL Combination'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94790117955956230)
,p_db_column_name=>'ALLOCATE_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Allocate By'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(110332868708469076)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1103329'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:GL_COMBINATION:AMOUNT:COMMENTS:UPDATED_BY:UPDATED_ON::ALLOCATE_BY'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110053230564053600)
,p_plug_name=>'Destinations'
,p_icon_css_classes=>'fa-space-shuttle'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P13_OVERSEAS_YN'
,p_plug_display_when_cond2=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110137230813737713)
,p_plug_name=>'Legs Report'
,p_parent_plug_id=>wwv_flow_api.id(110053230564053600)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       REQUEST_ID,',
'       SEQ,',
'       COUNTRY,',
'       CITY,',
'       NO_OF_DAYS,',
'       START_DATE,',
'       END_DATE,',
'       SELF_HOSPITALITY_YN,',
'       TICKET_REQUEST,',
'       NOTES,',
'       CREATED_BY_PERSON_ID,',
'       UPDATED_BY_PERSON_ID,',
'       CREATION_DATE,',
'       UPDATED_DATE',
'  from MISSION_LEGS',
'  where REQUEST_ID = :P13_REQUEST_ID',
'  order by SEQ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P13_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Legs Report'
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
 p_id=>wwv_flow_api.id(110137325824737714)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.::P14_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P13_REQUEST_STATUS in (''Draft'' , ''Stop'' , ''Withdraw'' , ''Return'')'
,p_owner=>'TCA9051'
,p_internal_uid=>110137325824737714
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110137494922737715)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110137520766737716)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110137691826737717)
,p_db_column_name=>'SEQ'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110137771918737718)
,p_db_column_name=>'COUNTRY'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Country'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(110195700317850373)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110137889231737719)
,p_db_column_name=>'CITY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'City'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110137996445737720)
,p_db_column_name=>'NO_OF_DAYS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Days'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110138039198737721)
,p_db_column_name=>'START_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110138150335737722)
,p_db_column_name=>'END_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110138243905737723)
,p_db_column_name=>'SELF_HOSPITALITY_YN'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Self Hospitality ?'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110138309844737724)
,p_db_column_name=>'TICKET_REQUEST'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Ticket Request'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110138479126737725)
,p_db_column_name=>'NOTES'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110138583179737726)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110138678291737727)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110138796420737728)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110138885211737729)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(110240811752128637)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1102409'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SEQ:COUNTRY:CITY:START_DATE:END_DATE:NOTES:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110291793874602605)
,p_plug_name=>'Documents'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110291869755602606)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(110291793874602605)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       REQUEST_ID,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       TAGS,',
'       CREATED,',
'       CREATED_BY_PERSON_ID,',
'       UPDATED,',
'       UPDATED_BY_PERSON_ID,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from mission_documents',
'  where REQUEST_ID = :P13_REQUEST_ID',
'  order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P13_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Documents report'
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
 p_id=>wwv_flow_api.id(110291941763602607)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No attachments available. '
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>110291941763602607
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110292077262602608)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110292132327602609)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110292253634602610)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110292395260602611)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.::P15_ID,P15_PAGE_FROM,P15_STATUS:#ID#,13,&P13_REQUEST_STATUS.'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110292411808602612)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110292521501602613)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110292660002602614)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110292786397602615)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110292872575602616)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110292914367602617)
,p_db_column_name=>'CREATED'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110293061112602618)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110293118931602619)
,p_db_column_name=>'UPDATED'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110293246395602620)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110293328967602621)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110293463252602622)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:MISSION_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(110333415613468842)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1103335'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:CREATED:UPDATED_BY_PERSON_ID:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110293876461602626)
,p_plug_name=>'Approval History'
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P13_REQUEST_STATUS != ''Draft'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_plug_comment=>'or :person_id = 680461'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110293990268602627)
,p_plug_name=>'Approval History Report'
,p_parent_plug_id=>wwv_flow_api.id(110293876461602626)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    h.id,',
'    h.request_id,',
'    h.step_no,',
'    h.person_id,',
'    nvl(e.full_name_en,e.SF_EMPLOYEE_NAME) || '' ('' || upper(e.user_name) || '')'' Name,',
'    h.role_id,',
'    h.role_desc,',
'    h.action_required,',
'    h.recevied_date,',
'    h.status,',
'    h.action_date,',
'    h.comments,',
'    h.updated_by,',
'    h.updated_on,',
' --   h.approval_type,',
'    case h.status',
'        When ''Rejected'' Then ''u-danger-text''',
'        when ''Approved'' Then ''u-success''',
'        When ''Accepted'' Then ''u-success''',
'    End status_class,',
'       e.full_name_en,',
'    case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'       when 0  THEN',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'        else  ',
'            ',
'         ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'       end Photo',
'--',
'    , case h.status ',
'        when ''Pending'' ',
'            Then ''<span aria-hidden="true" class="fa fa-arrow-down"></span>''',
'        end add_after',
'        ',
'    , case h.status ',
'        when ''Future'' ',
'            Then ''<span class="fa fa-arrow-up" aria-hidden="true"></span>''',
'        when ''Pending'' ',
'            Then ''<span class="fa fa-arrow-up" aria-hidden="true"></span>''',
'        end add_befor',
'    , case h.status ',
'        when ''Future'' ',
'            Then ''<span aria-hidden="true" class="fa fa-trash"></span>''',
'        end remove',
'    , case when h.status = ''Future'' and h.role_id != 130',
'            Then ''<span aria-hidden="true" class="fa fa-pencil"></span>''',
'        end change    ',
'FROM',
'    mission_approval_history h, dct_employees_list2  e',
'where h.person_id = e.person_id (+)',
'and h.request_id = :P13_REQUEST_ID',
'and h.status != ''Bateen''',
'order by h.STEP_NO ',
', h.ID',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P13_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approval History Report'
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
 p_id=>wwv_flow_api.id(110294083828602628)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>110294083828602628
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110294152184602629)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110294270933602630)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110294385752602631)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110294418869602632)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110294541241602633)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109816436157935965)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110294657364602634)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Desc'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110294747951602635)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110294802813602636)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110294903674602637)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110295097876602638)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110295103072602639)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110295223336602640)
,p_db_column_name=>'STATUS_CLASS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Status Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110295333527602641)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110295499582602642)
,p_db_column_name=>'PHOTO'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(78652675530820751)
,p_db_column_name=>'NAME'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91222546565348759)
,p_db_column_name=>'ADD_AFTER'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Add After'
,p_column_link=>'f?p=&APP_ID.:55:&SESSION.::&DEBUG.:55:P55_EVENT,P55_HISTORY_ID,P55_PAGE_FROM,P55_REQUEST_ID,P55_PERSON_ID:A,#ID#,13,#REQUEST_ID#,#PERSON_ID#'
,p_column_linktext=>'#ADD_AFTER#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_COMPENSATION_BENIFIT_YN = ''Y'' or',
':IS_PAYROLL_ADMIN = ''Y''	OR',
':PERSON_ID = 680461'))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91222705545348760)
,p_db_column_name=>'ADD_BEFOR'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Add Befor'
,p_column_link=>'f?p=&APP_ID.:55:&SESSION.::&DEBUG.:55:P55_EVENT,P55_HISTORY_ID,P55_PAGE_FROM,P55_PERSON_ID,P55_REQUEST_ID:B,#ID#,13,#PERSON_ID#,#REQUEST_ID#'
,p_column_linktext=>'#ADD_BEFOR#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_COMPENSATION_BENIFIT_YN = ''Y'' or',
':IS_PAYROLL_ADMIN = ''Y''	OR',
':PERSON_ID = 680461'))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91222738698348761)
,p_db_column_name=>'REMOVE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Remove'
,p_column_link=>'f?p=&APP_ID.:55:&SESSION.::&DEBUG.:55:P55_EVENT,P55_HISTORY_ID,P55_PAGE_FROM,P55_REQUEST_ID,P55_PERSON_ID:D,#ID#,13,#REQUEST_ID#,#PERSON_ID#'
,p_column_linktext=>'#REMOVE#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_COMPENSATION_BENIFIT_YN = ''Y'' or',
':IS_PAYROLL_ADMIN = ''Y''	OR',
':PERSON_ID = 680461'))
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91874612666376429)
,p_db_column_name=>'CHANGE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Change'
,p_column_link=>'f?p=&APP_ID.:55:&SESSION.::&DEBUG.:55:P55_EVENT,P55_HISTORY_ID,P55_PAGE_FROM,P55_REQUEST_ID,P55_PERSON_ID:U,#ID#,13,#REQUEST_ID#,#PERSON_ID#'
,p_column_linktext=>'#CHANGE#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_COMPENSATION_BENIFIT_YN = ''Y'' or',
':IS_PAYROLL_ADMIN = ''Y''	OR',
':PERSON_ID = 680461'))
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104047138329560228)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(109808026822935975)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(104047234779560229)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(110347890875295237)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1103479'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:NAME:ROLE_ID:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:ADD_AFTER:ADD_BEFOR:REMOVE:CHANGE:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(104334534150523967)
,p_report_id=>wwv_flow_api.id(110347890875295237)
,p_name=>'Pending'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Pending'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Pending''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D0F1CC'
,p_row_font_color=>'#000000'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4997407432410353)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(249902945573027)
,p_button_name=>'Refresh'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--link:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Refresh'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(92633179107579865)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(110291793874602605)
,p_button_name=>'Allocate_Budget'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Allocate Budget'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:63:&SESSION.::&DEBUG.:63,22:P63_REQUEST_ID,P63_PAGE_FROM:&P13_REQUEST_ID.,13'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'L_COUNT    NUMBER := 0;',
'BEGIN',
'',
'SELECT NVL(COUNT(*),0) INTO L_COUNT FROM MISSION_DISTRIBUTIONS;',
'IF :PERSON_ID in( 680461, 1661454) AND L_COUNT > 0  and :P13_PV_NUMBER is null THEN ',
'    RETURN TRUE;',
'  ELSE',
'    RETURN FALSE;',
' END IF;',
'END;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-breadcrumb'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110024688844540831)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(110051456798053601)
,p_button_name=>'Delete'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':P13_REQUEST_ID is not null and :P13_REQUEST_STATUS = ''Draft'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110139263807737733)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(110053230564053600)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(12960115165762160)
,p_button_image_alt=>'New'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:14:P14_REQUEST_ID:&P13_REQUEST_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(117515221469594631)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(110293876461602626)
,p_button_name=>'Repair'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(12960115165762160)
,p_button_image_alt=>'Repair'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count    number := 0;',
'begin',
'',
'select nvl(count(*),0)',
'into    l_count',
'from mission_approval_history',
'where request_id = :P13_REQUEST_ID',
'and STATUS = ''Pending'';',
'',
'if (:P13_REQUEST_STATUS = ''in-Progress''  and l_count = 0)',
'    and',
'    (:IS_PAYROLL_ADMIN = ''Y'' or',
'    :IS_COMPENSATION_BENIFIT_YN = ''Y'' or',
'    :PERSON_ID = 680461)',
'    then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-play'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110025317884540838)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(110051456798053601)
,p_button_name=>'Rollback'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(12960857103762161)
,p_button_image_alt=>'Rollback'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':PERSON_ID = 680461'
,p_button_condition_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110293797621602625)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(110291793874602605)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(12960115165762160)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.::P15_REQUEST_ID,P15_PAGE_FROM:&P13_REQUEST_ID.,13'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(96257094832052838)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(110051456798053601)
,p_button_name=>'Return'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:19:&SESSION.::&DEBUG.:19:P19_ACTION,P19_REQUEST_ID:ReturnAfter,&P13_REQUEST_ID.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P13_PV_NUMBER is  null and (:IS_PAYROLL_ADMIN = ''Y'' or :PERSON_ID = 680461) AND :P13_REQUEST_STATUS  IN (''Approved'' ',
'                                                                                                        -- , ''in-Progress''',
'                                                                                                        )'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110026050083540845)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(110051456798053601)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P13_REQUEST_ID is not null and :P13_REQUEST_STATUS in (''Draft'',''Withdraw'' , ''Return'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(208756265530535)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(110051456798053601)
,p_button_name=>'Submit_Confirm'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Confirm'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':p13_request_id is not null and ',
':P13_REQUEST_STATUS in (''Approved'') and ',
':P13_COMPLETE_STATUS = ''Not Confirmed'' and',
'(:P13_CREATED_BY_PERSON_ID = :PERSON_ID or :P13_REQUEST_FOR = :PERSON_ID or :IS_COMPENSATION_BENIFIT_YN	= ''Y'')'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110026266522540847)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(110051456798053601)
,p_button_name=>'Cancel'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:62:&SESSION.::&DEBUG.:62:P62_REQUEST_ID,P62_ACTION:&P13_REQUEST_ID.,Cancel'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(:P13_CREATED_BY_PERSON_ID = :PERSON_ID  or',
':IS_COMPENSATION_BENIFIT_YN = ''Y'' OR',
':IS_PAYROLL_ADMIN = ''Y''',
')',
'and (:P13_PV_NUMBER IS NULL)',
'and :P13_REQUEST_STATUS != ''Cancelled'''))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110026314706540848)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(110051456798053601)
,p_button_name=>'Withdraw'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:19:&SESSION.::&DEBUG.:19:P19_ACTION,P19_REQUEST_ID:Withdraw,&P13_REQUEST_ID.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(:P13_CREATED_BY_PERSON_ID = :PERSON_ID )',
'and (:P13_REQUEST_STATUS not in (''Cancel'', ''Withdraw'' , ''Draft'' , ''Return'' , ''Approved'' , ''Rejected'' , ''Cancelled''))'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110026404185540849)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(110051456798053601)
,p_button_name=>'Print'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Print'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P13_REQUEST_STATUS != ''Draft'' and ',
'(:IS_COMPENSATION_BENIFIT_YN = ''Y'' or',
' :IS_PAYROLL_ADMIN =  ''Y'' or ',
':PERSON_ID in (1601441,680461) )'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-print'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110026103821540846)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_api.id(110051456798053601)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:&P13_PAGE_FROM.:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110101195997864202)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(110052064977053601)
,p_button_name=>'edit_header'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link'
,p_button_template_id=>wwv_flow_api.id(12960115165762160)
,p_button_image_alt=>'Edit Header'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.::P12_REQUEST_ID:&P13_REQUEST_ID.'
,p_button_condition=>':P13_REQUEST_STATUS in (''Draft'' , ''Stop'' , ''Withdraw'' , ''Return'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-pencil'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(91878690694376470)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(4994683251410326)
,p_button_name=>'Email'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Email'
,p_button_position=>'TOP'
,p_button_redirect_url=>'f?p=&APP_ID.:58:&SESSION.::&DEBUG.:58:P58_REQUEST_ID,P58_VEDNOR_NAME,P58_VEDNOR_NUM,P58_PAYROLL_AREA_ID:&P13_REQUEST_ID.,&P13_SUPPLIER_NAME.,&P13_SITE_NAME.,&P13_PAYROLL_AREA_ID.'
,p_button_condition=>':P13_SUPPLIER_NAME != ''PAYROLL'' and (:IS_PAYROLL_ADMIN = ''Y'' or :PERSON_ID = 680461 or :IS_COMPENSATION_BENIFIT_YN = ''Y'') and :P13_REQUEST_STATUS not in (''Cancelled'', ''Rejected'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-envelope-check'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(91875634281376440)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(4994683251410326)
,p_button_name=>'Invoice_Details'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Invoice Details'
,p_button_position=>'TOP'
,p_button_redirect_url=>'f?p=&APP_ID.:56:&SESSION.::&DEBUG.:56:P56_REQUEST_ID,P56_VENDOR_NAME:&P13_REQUEST_ID.,&P13_SUPPLIER_NAME.'
,p_button_condition=>':P13_SUPPLIER_NAME != ''PAYROLL'' and (:IS_PAYROLL_ADMIN = ''Y'' or :PERSON_ID in( 680461,1601441) or :IS_COMPENSATION_BENIFIT_YN = ''Y'') and :P13_REQUEST_STATUS not in (''Cancelled'', ''Rejected'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-file-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(249704973573025)
,p_branch_name=>'Go to 23 Confirm Submission'
,p_branch_action=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23:P23_REQUEST_ID:&P13_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(208756265530535)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(110398040840476401)
,p_branch_name=>'Go to 18'
,p_branch_action=>'f?p=&APP_ID.:18:&SESSION.::&DEBUG.:18:P18_REQUEST_ID:&P13_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(110026050083540845)
,p_branch_sequence=>20
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(110105371542864244)
,p_branch_name=>'Go to  &P13_PAGE_FROM.'
,p_branch_action=>'f?p=&APP_ID.:&P13_PAGE_FROM.:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>30
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1410265327226331)
,p_name=>'P13_TOTAL_DAYS'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Total Days'
,p_post_element_text=>'&nbsp; &nbsp; <b>Days</b>'
,p_source=>':P13_ADDITIONAL_DAYS + :P13_DAYS'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4994807985410327)
,p_name=>'P13_SUPPLIER_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(4994683251410326)
,p_prompt=>'Supplier Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4994849354410328)
,p_name=>'P13_SITE_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(4994683251410326)
,p_prompt=>'Supplier Site Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4994980776410329)
,p_name=>'P13_PAYMENT_METHOD'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(4994683251410326)
,p_prompt=>'Payment Method'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4995112378410330)
,p_name=>'P13_PAY_ALONE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(4994683251410326)
,p_prompt=>'Pay Alone?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(109820486212935961)||'.'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4995132797410331)
,p_name=>'P13_INVOICE_TYPE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(4994683251410326)
,p_prompt=>'Invoice Type'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4995272224410332)
,p_name=>'P13_IBAN'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(4994683251410326)
,p_prompt=>'IBAN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4995398044410333)
,p_name=>'P13_BANK_NAME'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(4994683251410326)
,p_prompt=>'Bank Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4996057173410340)
,p_name=>'P13_EMPLOYEE_NUM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(4994683251410326)
,p_prompt=>'Employee Number'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(81515613238368842)
,p_name=>'P13_CAR_REQUEST_YN'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Car / Per Diem'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'PER DIEM / CARE LOV'
,p_lov=>'.'||wwv_flow_api.id(81269959753991779)||'.'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(84398583064618536)
,p_name=>'P13_REQUEST_TYPE_DISPLAY'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(110051456798053601)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(84399881744618549)
,p_name=>'P13_COST_CENTER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'COST CENTERS WITH NAMES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''('' || COST_CENTER_CODE || '') '' || COST_CENTER_DESCRIPTION Name, COST_CENTER_CODE',
'from(',
'select distinct  COST_CENTER_DESCRIPTION, COST_CENTER_CODE',
'from dct_gl_code_combinations_all',
'order by COST_CENTER_CODE)'))
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(85707219277488640)
,p_name=>'P13_PV_NUMBER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'PV Number'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P13_PV_NUMBER'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(91875511402376438)
,p_name=>'P13_INVOICE_NUM'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(4994683251410326)
,p_prompt=>'Invoice Num'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P13_INVOICE_NUM'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(91875586208376439)
,p_name=>'P13_INVOICE_DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(4994683251410326)
,p_prompt=>'Invoice Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P13_INVOICE_DATE'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(92630489765579838)
,p_name=>'P13_PAYROLL_AREA_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(110051456798053601)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(97909807159754130)
,p_name=>'P13_CONFIRMED_START_DATE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Confirmed Start Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P13_COMPLETE_STATUS in (''Confirmed'' ,''in-Progress'')',
''))
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(97909947712754132)
,p_name=>'P13_CONFIRMED_END_DATE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Confirmed End Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P13_COMPLETE_STATUS in (''Confirmed'' ,''in-Progress'')',
''))
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(97910041891754133)
,p_name=>'P13_CONFIRMED_COMMENT'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Confirmed Comment'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P13_COMPLETE_STATUS in (''Confirmed'' ,''in-Progress'')',
''))
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110024036800540825)
,p_name=>'P13_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(110051456798053601)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110024271626540827)
,p_name=>'REQUEST_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(110051456798053601)
,p_source=>'P13_REQUEST_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110024347360540828)
,p_name=>'P13_PAGE_FROM'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(110051456798053601)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110024450122540829)
,p_name=>'P13_YEAR'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(110051456798053601)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110024569559540830)
,p_name=>'P13_SEQ'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(110051456798053601)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110101453170864205)
,p_name=>'P13_REQUEST_NO'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Request No'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110101558831864206)
,p_name=>'P13_REQUEST_DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Request Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110101657868864207)
,p_name=>'P13_REQUEST_FOR'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Request For'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110101755187864208)
,p_name=>'P13_GRADE_CODE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Grade'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110101891080864209)
,p_name=>'P13_GRADE_RATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Grade Rate'
,p_post_element_text=>'&nbsp; &nbsp; <b>AED</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110101950716864210)
,p_name=>'P13_OVERSEAS_YN'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Overseas ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(109820486212935961)||'.'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>unistr('<p><span style="color: #ff0000;"><strong>Yes: Mission outside UAE&nbsp;&nbsp;<span style="color: #0000ff;"> \0646\0639\0645 : \0625\0630\0627 \0643\0627\0646 \062C\0647\0629 \0627\0644\0633\0641\0631 \062E\0627\0631\062C \0627\0644\062F\0648\0644\0629</span></strong></span></p>')
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110102021468864211)
,p_name=>'P13_EMIRATE'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Emirate'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMIRATES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = 35',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)',
'order by 1'))
,p_display_when=>'P13_OVERSEAS_YN'
,p_display_when2=>'N'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110102191869864212)
,p_name=>'P13_FULL_DAY_YN'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Full Day ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(109820486212935961)||'.'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110102225553864213)
,p_name=>'P13_TRAVEL_ABOVE_10HR_YN'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Travel Above 10hr ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(109820486212935961)||'.'
,p_display_when=>'P13_OVERSEAS_YN'
,p_display_when2=>'Y'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110102339851864214)
,p_name=>'P13_TICKET_REQUEST'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Ticket Request ?'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'TICKET REQUEST CHOICES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = 36',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)',
'order by 1'))
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110102489717864215)
,p_name=>'P13_HOSPITALITY_YN'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Hospitality'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(109820486212935961)||'.'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>'if Yes, Hospitality hosted from other organization'
,p_inline_help_text=>'if Yes, Hospitality hosted from other organization'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110102537674864216)
,p_name=>'P13_TRANSPORTATION'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Transportation'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
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
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110102608380864217)
,p_name=>'P13_START_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Start Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110102705365864218)
,p_name=>'P13_END_DATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'End Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>':P13_CAR_REQUEST_YN != ''C'' or :P13_CAR_REQUEST_YN is null'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110102800334864219)
,p_name=>'P13_REQUEST_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110102994958864220)
,p_name=>'P13_COMPLETE_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Confirmation Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P13_REQUEST_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110103044283864221)
,p_name=>'P13_JUSTIFICATION'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Justification'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110103261105864223)
,p_name=>'P13_PURPOSE_EU'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Purpose'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110103356469864224)
,p_name=>'P13_PRIORITY'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Priority'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'PRIORITY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from dct_lookup_values',
'where lookup_id = (Select x.lookup_id',
'                    from dct_lookups x',
'                    where x.LOOKUP_CODE = ''PRIORITY'');'))
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110103403484864225)
,p_name=>'P13_SUBMITTED_ON'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Submitted On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P13_SUBMITTED_ON'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110103586290864226)
,p_name=>'P13_SUBMITTED_BY'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Submitted By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_display_when=>':P13_SUBMITTED_BY is not null and :P13_REQUEST_STATUS not in (''Cancelled'' , ''Return'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110103698523864227)
,p_name=>'P13_FINAL_APPROVE_ON'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Final Approve On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_display_when=>'P13_REQUEST_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110103722832864228)
,p_name=>'P13_REQUEST_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(110101242185864203)
,p_prompt=>'Request Type'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'MISSION REQUEST TYPES'
,p_lov=>'.'||wwv_flow_api.id(110033950814469886)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110103861335864229)
,p_name=>'P13_FINAL_REJECT_ON'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Final Reject On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P13_REQUEST_STATUS'
,p_display_when2=>'Rejected'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110103993526864230)
,p_name=>'P13_REJECTED_BY'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Rejected By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_display_when=>'P13_REQUEST_STATUS'
,p_display_when2=>'Rejected'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110104056246864231)
,p_name=>'P13_REJECT_REASON'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Reject Reason'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P13_REQUEST_STATUS'
,p_display_when2=>'Rejected'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110104154158864232)
,p_name=>'P13_CANCEL_ON'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Cancel on'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P13_REQUEST_STATUS'
,p_display_when2=>'Cancelled'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110104255001864233)
,p_name=>'P13_CANCELLED_BY'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Cancel By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_display_when=>'P13_REQUEST_STATUS'
,p_display_when2=>'Cancelled'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110104358858864234)
,p_name=>'P13_CANCEL_REASON'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Reason'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_display_when=>'P13_REQUEST_STATUS'
,p_display_when2=>'Cancelled'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110104440563864235)
,p_name=>'P13_CREATED_BY_PERSON_ID'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(110136595857737706)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110104565630864236)
,p_name=>'P13_UPDATED_BY_PERSON_ID'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(110136595857737706)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110104617371864237)
,p_name=>'P13_CREATION_DATE'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(110136595857737706)
,p_prompt=>'Created on'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110104739007864238)
,p_name=>'P13_UPDATED_DATE'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(110136595857737706)
,p_prompt=>'Update on'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110104822273864239)
,p_name=>'P13_AMOUNT'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Eligible Amount '
,p_post_element_text=>'&nbsp; &nbsp; <b>AED</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110105073133864241)
,p_name=>'P13_APPROVAL_TYPE_ID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(110051456798053601)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110136702331737708)
,p_name=>'P13_DAYS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Mission Days'
,p_post_element_text=>'&nbsp; &nbsp; <b>Days</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110136817267737709)
,p_name=>'P13_ADDITIONAL_DAYS'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Travel Days'
,p_post_element_text=>'&nbsp; &nbsp; <b>Days</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110136984091737710)
,p_name=>'P13_ELIGIBLE_PCT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(110052472756053600)
,p_prompt=>'Eligible PCT'
,p_post_element_text=>'&nbsp; &nbsp; <b>%</b>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(110024770050540832)
,p_name=>'Delete DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(110024688844540831)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110024891924540833)
,p_event_id=>wwv_flow_api.id(110024770050540832)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to delete this request? '
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110024940292540834)
,p_event_id=>wwv_flow_api.id(110024770050540832)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'delete from MISSION_HEADER where REQUEST_ID = :P13_REQUEST_ID;'
,p_attribute_02=>'P13_REQUEST_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110025061519540835)
,p_event_id=>wwv_flow_api.id(110024770050540832)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_PAGE_FROM'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'3'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110025155203540836)
,p_event_id=>wwv_flow_api.id(110024770050540832)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Deleted'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110025222993540837)
,p_event_id=>wwv_flow_api.id(110024770050540832)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(110025465439540839)
,p_name=>'Rollback DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(110025317884540838)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110025551638540840)
,p_event_id=>wwv_flow_api.id(110025465439540839)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to rollback?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110025644912540841)
,p_event_id=>wwv_flow_api.id(110025465439540839)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete from MISSION_APPROVAL_HISTORY where REQUEST_ID = :P13_REQUEST_ID;',
'update MISSION_HEADER set REQUEST_STATUS = ''Draft'' , COMPLETE_STATUS = '''' where REQUEST_ID = :P13_REQUEST_ID;',
'delete from MISSION_DISTRIBUTIONS where REQUEST_ID = :P13_REQUEST_ID;'))
,p_attribute_02=>'P13_REQUEST_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110025761030540842)
,p_event_id=>wwv_flow_api.id(110025465439540839)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Rollback Done;'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110025869473540843)
,p_event_id=>wwv_flow_api.id(110025465439540839)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_PAGE_FROM'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'3'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110025975338540844)
,p_event_id=>wwv_flow_api.id(110025465439540839)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(110026525936540850)
,p_name=>'Print DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(110026404185540849)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110101079342864201)
,p_event_id=>wwv_flow_api.id(110026525936540850)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'javaScript:window.open(''f?p=&APP_ID.:0:&SESSION.:PRINT_REPORT=MISSION_QUERY'', ''_blank'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(110139026870737731)
,p_name=>'New'
,p_event_sequence=>40
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(110137230813737713)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110139106147737732)
,p_event_id=>wwv_flow_api.id(110139026870737731)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(110137230813737713)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(321477433690535)
,p_name=>'Full Day DA'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P13_FULL_DAY_YN'
,p_condition_element=>'P13_FULL_DAY_YN'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(321571623690536)
,p_event_id=>wwv_flow_api.id(321477433690535)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_HOSPITALITY_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(321672580690537)
,p_event_id=>wwv_flow_api.id(321477433690535)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_HOSPITALITY_YN'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1410428366226333)
,p_name=>'Refresh DA'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(110139263807737733)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1410599005226334)
,p_event_id=>wwv_flow_api.id(1410428366226333)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(110137230813737713)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4997435191410354)
,p_name=>'RefreshDA'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(4997407432410353)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4997596913410355)
,p_event_id=>wwv_flow_api.id(4997435191410354)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(250011820573028)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(81515658723368843)
,p_name=>'Check Per Diem / Car '
,p_event_sequence=>80
,p_condition_element=>'P13_CAR_REQUEST_YN'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(81515813146368844)
,p_event_id=>wwv_flow_api.id(81515658723368843)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_CAR_REQUEST_YN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(81515890556368845)
,p_event_id=>wwv_flow_api.id(81515658723368843)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_CAR_REQUEST_YN'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(91874068234376424)
,p_name=>'Close DA'
,p_event_sequence=>90
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(110293990268602627)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(91874125919376425)
,p_event_id=>wwv_flow_api.id(91874068234376424)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(110293990268602627)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(92632982455579863)
,p_name=>'Email Close DA'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(91878690694376470)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(92633047088579864)
,p_event_id=>wwv_flow_api.id(92632982455579863)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(92630817503579841)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(94789547550956225)
,p_name=>'Allocate Budget DA'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(92633179107579865)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(94789722403956226)
,p_event_id=>wwv_flow_api.id(94789547550956225)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(110052862669053600)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(94789754738956227)
,p_event_id=>wwv_flow_api.id(94789547550956225)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(110139350918737734)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(117515281868594632)
,p_name=>'Repair DA'
,p_event_sequence=>120
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(117515221469594631)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(117515393840594633)
,p_event_id=>wwv_flow_api.id(117515281868594632)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to repair the workflow, Continue?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(117515502940594634)
,p_event_id=>wwv_flow_api.id(117515281868594632)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_steo_no           number;',
'l_ACTION_DATE       timestamp;',
'begin',
'',
'select max(STEP_NO) -- , ACTION_DATE',
'into    l_steo_no',
'from mission_approval_history',
'where request_id = :P13_REQUEST_ID',
'and STATUS = ''Approved'';',
'',
'select  ACTION_DATE',
'into    l_ACTION_DATE',
'from mission_approval_history',
'where request_id = :P13_REQUEST_ID',
'and STATUS = ''Approved''',
'and step_no = l_steo_no ;',
'',
'update mission_approval_history',
'set RECEVIED_DATE = l_ACTION_DATE, ',
'    STATUS  = case ACTION_REQUIRED  when ''FYI'' then ''Notified''',
'--                                    when ''Approve/Reject'' then ''''',
'                end, ',
'    ACTION_DATE = case ACTION_REQUIRED  when ''FYI'' then l_ACTION_DATE',
'--                                    when ''Approve/Reject'' then ''''',
'                end',
'where request_id = :P13_REQUEST_ID',
'and step_no = l_steo_no + 1',
'and ACTION_DATE is null;',
'',
'update mission_approval_history',
'set RECEVIED_DATE = l_ACTION_DATE, ',
'    STATUS  = case ACTION_REQUIRED  when ''FYI'' then ''Notified''',
'                                    when ''Approve/Reject'' then ''Pending''',
'                end, ',
'    ACTION_DATE = case ACTION_REQUIRED  when ''FYI'' then l_ACTION_DATE',
'--                                    when ''Approve/Reject'' then ''''',
'                end',
'where request_id = :P13_REQUEST_ID',
'and step_no = l_steo_no + 2',
'and ACTION_DATE is null;',
'',
'end;'))
,p_attribute_02=>'P13_REQUEST_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(117515618818594635)
,p_event_id=>wwv_flow_api.id(117515281868594632)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Repaired Sucessfully'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(117515682533594636)
,p_event_id=>wwv_flow_api.id(117515281868594632)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(110104937688864240)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize Mission details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    request_id,',
'    request_no,',
'    to_char(request_date,''DD-MON-YYYY'')                     request_date,',
'    user_details.get_full_name(request_for)                 request_for,',
'    MISSION_UTIL.get_grade(grade_code)                      grade_code,',
'    to_char(MISSION_UTIL.get_mission_rate(grade_code,overseas_yn),''99,999,999.99'')   grade_rate,',
'    overseas_yn,',
'    emirate,',
'    full_day_yn,',
'    travel_above_10hr_yn,',
'    ticket_request,',
'    hospitality_yn,',
'    transportation,',
'    to_char(start_date,''DD-MON-YYYY'')                       start_date,',
'    to_char(end_date,''DD-MON-YYYY'')                         end_date,',
'    request_status,',
'    complete_status,',
'    justification,',
'    year,',
'    purpose_eu,',
'    priority,',
'    to_char(submitted_on,''DD-MON-YYYY HH:MIPM'')             submitted_on,',
'    submitted_by,',
'    seq,',
'    to_char(final_approve_on,''DD-MON-YYYY HH:MIPM'')         final_approve_on,',
'    request_type,',
'    to_char(final_reject_on,''DD-MON-YYYY HH:MIPM'')          final_reject_on,',
'    rejected_by,',
'    reject_reason,',
'    to_char(cancel_on,''DD-MON-YYYY HH:MIPM'')                cancel_on,',
'    cancelled_by,',
'    cancel_reason,',
'    approval_type_id,',
'    created_by_person_id,',
'    updated_by_person_id,',
'    to_char(creation_date,''DD-MON-YYYY HH:MIPM'')            creation_date,',
'    to_char(updated_date,''DD-MON-YYYY HH:MIPM'')             updated_date,',
' --   to_char(amount , ''99,999,999,999.99'')                   amount,',
'    (end_date - start_date) + 1                             Mission_days,',
'    case when overseas_yn = ''Y'' and travel_above_10hr_yn = ''Y''',
'            Then 4',
'         when overseas_yn = ''Y'' and travel_above_10hr_yn = ''N''  ',
'            Then 2',
'         else',
'            0',
'    End                                                 additional_days,',
'    to_char(MISSION_UTIL.get_mission_amount(request_id) , ''99,999,999,999.99'')         mission_amount,',
'    MISSION_UTIL.get_Eligible_pct(overseas_yn, full_day_yn, hospitality_yn , :P13_REQUEST_ID)              eligible_pct,',
' ---',
'    SUPPLIER_NAME, ',
'    SITE_NAME,',
'    PAYMENT_METHOD,',
'    PAY_ALONE, ',
'    INVOICE_TYPE,',
'--    user_details.Bank_Name(REQUEST_FOR),',
'--    user_details.IBAN(REQUEST_FOR),',
'    MISSION_UTIL.get_mission_bank_name(request_id),',
'    MISSION_UTIL.get_mission_IBAN(request_id),',
'    user_details.get_emp_num(REQUEST_FOR),',
'    CAR_REQUEST_YN,',
'    PV_NUMBER,',
'    COST_CENTER,',
'    invoice_number,',
'    to_char(invoice_date, ''DD-Mon-YYYY''),',
'    PAYROLL_AREA_ID,',
'    to_char(CONFIRMED_START_DATE, ''DD-Mon-YYYY''),',
'    to_char(CONFIRMED_END_DATE, ''DD-Mon-YYYY''),',
'    CONFIRMED_COMMENT',
'into',
'    :P13_REQUEST_ID,',
'    :P13_REQUEST_NO,',
'    :P13_REQUEST_DATE,',
'    :P13_REQUEST_FOR,',
'    :P13_GRADE_CODE,',
'    :P13_GRADE_RATE,',
'    :P13_OVERSEAS_YN,',
'    :P13_EMIRATE,',
'    :P13_FULL_DAY_YN,',
'    :P13_TRAVEL_ABOVE_10HR_YN,',
'    :P13_TICKET_REQUEST,',
'    :P13_HOSPITALITY_YN,',
'    :P13_TRANSPORTATION,',
'    :P13_START_DATE,',
'    :P13_END_DATE,',
'    :P13_REQUEST_STATUS,',
'    :P13_COMPLETE_STATUS,',
'    :P13_JUSTIFICATION,',
'    :P13_YEAR,',
'    :P13_PURPOSE_EU,',
'    :P13_PRIORITY,',
'    :P13_SUBMITTED_ON,',
'    :P13_SUBMITTED_BY,',
'    :P13_SEQ,',
'    :P13_FINAL_APPROVE_ON,',
'    :P13_REQUEST_TYPE,',
'    :P13_FINAL_REJECT_ON,',
'    :P13_REJECTED_BY,',
'    :P13_REJECT_REASON,',
'    :P13_CANCEL_ON,',
'    :P13_CANCELLED_BY,',
'    :P13_CANCEL_REASON,',
'    :P13_APPROVAL_TYPE_ID,',
'    :P13_CREATED_BY_PERSON_ID,',
'    :P13_UPDATED_BY_PERSON_ID,',
'    :P13_CREATION_DATE,',
'    :P13_UPDATED_DATE,',
'--    :P13_AMOUNT,',
'    :P13_DAYS,',
'    :P13_ADDITIONAL_DAYS,',
'    :P13_AMOUNT,',
'    :P13_ELIGIBLE_PCT,',
'--',
'   :P13_SUPPLIER_NAME,',
'   :P13_SITE_NAME,',
'   :P13_PAYMENT_METHOD,',
'   :P13_PAY_ALONE,',
'   :P13_INVOICE_TYPE,',
'   :P13_BANK_NAME,',
'   :P13_IBAN,',
'   :P13_EMPLOYEE_NUM,',
'   :P13_CAR_REQUEST_YN,',
'   :P13_PV_NUMBER,',
'   :P13_COST_CENTER,',
'   :P13_INVOICE_NUM,',
'   :P13_INVOICE_DATE,',
'   :p13_PAYROLL_AREA_ID,',
'   :P13_CONFIRMED_START_DATE,',
'   :P13_CONFIRMED_END_DATE,',
'   :P13_CONFIRMED_COMMENT',
'   ',
'FROM    ',
'    mission_header',
'WHERE request_id = nvl(:P13_REQUEST_ID  , (SELECT last_number',
'                                          FROM all_sequences',
'                                         WHERE sequence_owner = ''PROD''',
'                                           AND sequence_name = ''MISSION_HEADER_SEQ'')',
'                        );',
'exception',
'    when others then null;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
