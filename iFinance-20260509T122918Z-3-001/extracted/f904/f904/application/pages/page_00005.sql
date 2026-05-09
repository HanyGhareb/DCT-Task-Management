prompt --application/pages/page_00005
begin
--   Manifest
--     PAGE: 00005
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
 p_id=>5
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'External Users Report'
,p_alias=>'EXTERNAL-USERS-REPORT'
,p_step_title=>'External Users Report'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210903114952'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10620275397166215)
,p_plug_name=>'External Users'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    "USER_ID",',
'    "USER_NAME",',
'    "USER_GROUP",',
'    "STATUS",',
'    "TITLE",',
'    "FIRST_NAME",',
'    "SECOND_NAME",',
'    "THIRD_NAME",',
'    "LAST_NAME",',
'    "FIRST_NAME_AR",',
'    "SECOND_NAME_AR",',
'    "LAST_NAME_AR",',
'    first_name || '' '' || second_name || '' ''|| last_name             "FULL_NAME_EN",',
'    first_name_ar || '' '' || second_name_ar || '' ''|| last_name_ar     "FULL_NAME_AR",',
'    "NATIONAL_IDENTIFIER",',
'    "NATIONALITY_CODE",',
'    "SEX",',
'    "EMAIL",',
'    "MOBILE_SMS",',
'    "PHONE_NUMBER",',
'    sys.dbms_lob.getlength("PHOTO_BLOB") "PHOTO_BLOB",',
'    "PHOTO_NAME",',
'    "PHOTO_MIMETYPE",',
'    "PHOTO_CHARSET",',
'    "PHOTO_LASTUPD",',
'    "PASSWORD",',
'    "ACCOUNT_STATUS",',
'    "CHANGE_PASSWORD",',
'    u."CREATED_BY",',
'    u."CREATED_ON",',
'    u."UPDATED_BY",',
'    u."UPDATED_ON",',
'    default_role,',
'    v.vendor_name',
'    ,v.vendor_number',
'    ,v.vendor_site_code',
'    ,''https://ifinance.dct.gov.ae:8004/dct/prod/ExtUser/view/'' || nvl(user_name, ''U0000'') PHOTO',
'FROM',
'    DCT_EXT_USERS u , vendors v',
'where u.vendor_number = v.vendor_number (+)',
'and u.vendor_site_code = v.vendor_site_code (+)',
'-- where user_name != ''U0000'''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'External Users'
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
 p_id=>wwv_flow_api.id(10620697639166215)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:RP:P6_USER_ID:\#USER_ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>10620697639166215
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10620726017166216)
,p_db_column_name=>'USER_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'User Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10621165513166217)
,p_db_column_name=>'USER_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10621933629166217)
,p_db_column_name=>'STATUS'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(10760317215192499)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10622375308166218)
,p_db_column_name=>'TITLE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10622703136166218)
,p_db_column_name=>'FIRST_NAME'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'First Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10623145806166218)
,p_db_column_name=>'SECOND_NAME'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Second Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10623559190166219)
,p_db_column_name=>'THIRD_NAME'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Third Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10623900609166219)
,p_db_column_name=>'LAST_NAME'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Last Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10624337822166219)
,p_db_column_name=>'FIRST_NAME_AR'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'First Name (AR)'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10624796009166220)
,p_db_column_name=>'SECOND_NAME_AR'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Second Name (AR)'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10625163508166220)
,p_db_column_name=>'LAST_NAME_AR'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Last Name (AR)'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10625587429166220)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Full Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10625962215166220)
,p_db_column_name=>'FULL_NAME_AR'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Full Name (AR)'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10626378596166221)
,p_db_column_name=>'NATIONAL_IDENTIFIER'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'National ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10626735419166221)
,p_db_column_name=>'NATIONALITY_CODE'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Nationality '
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(10760106323189775)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10627142977166221)
,p_db_column_name=>'SEX'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Gender'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(10753546905165718)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10627565007166222)
,p_db_column_name=>'EMAIL'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10627936398166222)
,p_db_column_name=>'MOBILE_SMS'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Mobile SMS /WhatsApp'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10628338668166222)
,p_db_column_name=>'PHONE_NUMBER'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Phone Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10628771307166222)
,p_db_column_name=>'PHOTO_BLOB'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Photo Blob'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DOWNLOAD:DCT_EXT_USERS:PHOTO_BLOB:USER_ID'
,p_tz_dependent=>'N'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10631943475166225)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10632376933166226)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10632710901166226)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10633120801166226)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10631137607166224)
,p_db_column_name=>'ACCOUNT_STATUS'
,p_display_order=>42
,p_column_identifier=>'AA'
,p_column_label=>'Account Status'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10631562599166225)
,p_db_column_name=>'CHANGE_PASSWORD'
,p_display_order=>52
,p_column_identifier=>'AB'
,p_column_label=>'Change Password'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10630714998166224)
,p_db_column_name=>'PASSWORD'
,p_display_order=>62
,p_column_identifier=>'Z'
,p_column_label=>'Password'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10629168553166223)
,p_db_column_name=>'PHOTO_NAME'
,p_display_order=>72
,p_column_identifier=>'V'
,p_column_label=>'Photo Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10629536319166223)
,p_db_column_name=>'PHOTO_MIMETYPE'
,p_display_order=>82
,p_column_identifier=>'W'
,p_column_label=>'Photo Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10629998478166223)
,p_db_column_name=>'PHOTO_CHARSET'
,p_display_order=>92
,p_column_identifier=>'X'
,p_column_label=>'Photo Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10630356424166224)
,p_db_column_name=>'PHOTO_LASTUPD'
,p_display_order=>102
,p_column_identifier=>'Y'
,p_column_label=>'Photo Lastupd'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(10621599623166217)
,p_db_column_name=>'USER_GROUP'
,p_display_order=>112
,p_column_identifier=>'C'
,p_column_label=>'User Group'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(9593963200676441)
,p_db_column_name=>'PHOTO'
,p_display_order=>122
,p_column_identifier=>'AG'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="50" width="50">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11519466495797830)
,p_db_column_name=>'DEFAULT_ROLE'
,p_display_order=>132
,p_column_identifier=>'AH'
,p_column_label=>'Default Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(11616609252557892)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6664915413724249)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>142
,p_column_identifier=>'AI'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6665063327724250)
,p_db_column_name=>'VENDOR_NUMBER'
,p_display_order=>152
,p_column_identifier=>'AJ'
,p_column_label=>'Vendor Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20780939452193901)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>162
,p_column_identifier=>'AK'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(10636296787174290)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'106363'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'USER_NAME:FULL_NAME_EN:DEFAULT_ROLE:EMAIL:PHONE_NUMBER:MOBILE_SMS::VENDOR_NAME'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10634402323166228)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(10635652064166229)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(10620275397166215)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(10307341140597826)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New User'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6'
,p_icon_css_classes=>'fa-plus-square-o'
);
wwv_flow_api.component_end;
end;
/
