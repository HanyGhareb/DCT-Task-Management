prompt --application/pages/page_00017
begin
--   Manifest
--     PAGE: 00017
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>116806299474925354
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>17
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Delegation'
,p_alias=>'DELEGATION'
,p_step_title=>'Delegation'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220303111800'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76499777366757618)
,p_plug_name=>'Credit Card Delegation'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23834504913372554)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  h.id',
'        ,h.credit_card_id',
'        ,h.step_no',
'         ,h.person_id',
'        ,h.recevied_date',
'        ,h.recevied_date    Pending_since',
'        ,H.APPROVAL_TYPE_ID',
'        ,e.full_name_en',
'        ,e.employee_num',
'        ,e.email',
'        ,(select x.full_name_en ',
'         from employees_v x',
'         where x.person_id = p.requestor_person_id) Requestor',
'        ,p.requested_amount',
'        , case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end PHOTO',
'         , ''<span aria-hidden="true" class="fa fa-mail-forward fa-2x fam-information fam-is-success"></span>'' Action',
'         , ''<span aria-hidden="true" class="fa fa-envelope-o fa-2x fam-information fam-is-info"></span>'' Reminder',
'from credit_card_approval_history h , credit_cards p , employees_v e',
'where h.credit_card_id = p.id',
'and h.status = ''Pending''',
'and h.person_id = e.person_id'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Credit Card Delegation'
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
 p_id=>wwv_flow_api.id(76499633006757617)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>40306666468167737
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76499589401757616)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76499410012757615)
,p_db_column_name=>'CREDIT_CARD_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Credit Card Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76499370404757614)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Step No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76499230936757613)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76499173055757612)
,p_db_column_name=>'PENDING_SINCE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Pending Since'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76499017306757611)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Pending With'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76498923866757610)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76498838562757609)
,p_db_column_name=>'EMAIL'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76498793626757608)
,p_db_column_name=>'REQUESTOR'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Requestor'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76498658740757607)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76498553464757606)
,p_db_column_name=>'PHOTO'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76498439376757605)
,p_db_column_name=>'ACTION'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Delegate'
,p_column_link=>'f?p=&APP_ID.:19:&SESSION.::&DEBUG.:19:P19_DELEGATE_FROM,P19_HISTORY_ID,P19_CREDIT_CARD_ID,P19_APPROVAL_TYPE_ID:#PERSON_ID#,#ID#,#CREDIT_CARD_ID#,#APPROVAL_TYPE_ID#'
,p_column_linktext=>'#ACTION#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76498381012757604)
,p_db_column_name=>'REMINDER'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Reminder'
,p_column_link=>'f?p=&APP_ID.:18:&SESSION.::&DEBUG.:18:P18_EMPLOYEE_NAME,P18_EMPLOYEE_NUMBER,P18_REQUEST_ID,P18_TYPE,P18_PERSON_ID:#FULL_NAME_EN#,#EMPLOYEE_NUM#,#CREDIT_CARD_ID#,CCR,#PERSON_ID#'
,p_column_linktext=>'#REMINDER#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76112560234012553)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22956627697919222)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(76124844667140273)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'406815'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PHOTO:RECEVIED_DATE:PENDING_SINCE:FULL_NAME_EN:EMPLOYEE_NUM:EMAIL:REQUESTOR:REQUESTED_AMOUNT:ACTION:REMINDER::APPROVAL_TYPE_ID'
,p_sort_column_1=>'PENDING_SINCE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(76138774971832654)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23845862961372548)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(23782494216372596)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(23899958141372507)
);
wwv_flow_api.component_end;
end;
/
