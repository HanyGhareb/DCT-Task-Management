prompt --application/pages/page_00025
begin
--   Manifest
--     PAGE: 00025
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>118
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>25
,p_user_interface_id=>wwv_flow_api.id(122997627648781606)
,p_name=>'Hotels P&L'
,p_alias=>'HOTELS-P-L'
,p_step_title=>'Hotels P&L'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230522201449'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(168796613801281348)
,p_plug_name=>'Email Template'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(122896014873781677)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(168795957367281341)
,p_plug_name=>'Email Setting'
,p_parent_plug_id=>wwv_flow_api.id(168796613801281348)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(122913064144781666)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(168796434648281346)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(168795957367281341)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(122896014873781677)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(169326425751163501)
,p_plug_name=>'Attachments'
,p_parent_plug_id=>wwv_flow_api.id(168795957367281341)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(122896014873781677)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(169326593092163502)
,p_plug_name=>'Attachments report'
,p_parent_plug_id=>wwv_flow_api.id(169326425751163501)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(122911181767781667)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    "ID",',
'    "ROW_VERSION_NUMBER",',
'    "FILENAME",',
'    "FILE_MIMETYPE",',
'    "FILE_CHARSET",',
'    sys.dbms_lob.getlength("FILE_BLOB") "FILE_BLOB",',
'    "FILE_COMMENTS",',
'    "TAGS",',
'    "CREATED",',
'    "CREATED_BY",',
'    "UPDATED",',
'    "UPDATED_BY",',
'    type,',
'    sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'FROM',
'    ar_hotels_p_l_documents'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Attachments report'
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
 p_id=>wwv_flow_api.id(169326678826163503)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>169326678826163503
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169326796898163504)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169326805698163505)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169326938184163506)
,p_db_column_name=>'FILENAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'File'
,p_column_link=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.::P26_ID:#ID#'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169327307861163510)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169327426217163511)
,p_db_column_name=>'TAGS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169327511509163512)
,p_db_column_name=>'CREATED'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169327629392163513)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(157182907217903192)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169327786232163514)
,p_db_column_name=>'UPDATED'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169327865953163515)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(157182907217903192)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169327943742163516)
,p_db_column_name=>'TYPE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169327009550163507)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>140
,p_column_identifier=>'D'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169327158981163508)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>150
,p_column_identifier=>'E'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169328028457163517)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>160
,p_column_identifier=>'N'
,p_column_label=>'File Blob'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169328137117163518)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>170
,p_column_identifier=>'O'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169328258968163519)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>180
,p_column_identifier=>'P'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:AR_HOTELS_P_L_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(169342455101196323)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1693425'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(169272259290882686)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(122922476001781663)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(122859041536781706)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(122976593233781628)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(169272879954882686)
,p_plug_name=>'Hotels P&L'
,p_region_name=>'USERS'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(122913064144781666)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'AR_HOTELS_P_L'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Hotels P&L'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(169272948424882686)
,p_name=>'Hotels P&L'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>169272948424882686
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169273306656882689)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Customer Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169273717657882689)
,p_db_column_name=>'ACCOUNT_NUM'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Account Num'
,p_column_link=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.::P31_ACCOUNT_NUM:#ACCOUNT_NUM#'
,p_column_linktext=>'#ACCOUNT_NUM#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169274120986882690)
,p_db_column_name=>'CUSTOMER_NUM'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Customer Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169274527629882690)
,p_db_column_name=>'TO_EMAIL'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'To Emails'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169274905785882690)
,p_db_column_name=>'CC_EMAIL'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Cc Emails'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169275389510882695)
,p_db_column_name=>'BCC_EMAIL'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Bcc Emails'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169275797201882696)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(157182907217903192)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169276186572882696)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169276544173882696)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(157182907217903192)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(169276921648882696)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(169287024549942522)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1692871'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CUSTOMER_NAME:ACCOUNT_NUM:CUSTOMER_NUM:TO_EMAIL:CC_EMAIL:BCC_EMAIL:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(168796711076281349)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(168795957367281341)
,p_button_name=>'Document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapRight'
,p_button_template_id=>wwv_flow_api.id(122975280422781629)
,p_button_image_alt=>'Email attachements'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.::P26_TYPE:PL'
,p_icon_css_classes=>'fa-paperclip'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(169328737974163524)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(169272879954882686)
,p_button_name=>'Upload'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(122975280422781629)
,p_button_image_alt=>'Upload'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-upload'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(168795700504281339)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(168795957367281341)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(122975280422781629)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-save-as'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(169328809061163525)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(169272879954882686)
,p_button_name=>'Send'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_api.id(122975280422781629)
,p_button_image_alt=>'Send Emails'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-comments-o fa-anim-flash'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(169328956203163526)
,p_branch_name=>'Go to Upload PL'
,p_branch_action=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(169328737974163524)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(168796063555281342)
,p_name=>'P25_EMAIL_TEMPLATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(168795957367281341)
,p_prompt=>'Email Template'
,p_display_as=>'NATIVE_RICH_TEXT_EDITOR'
,p_cSize=>120
,p_cMaxlength=>4000
,p_cHeight=>20
,p_field_template=>wwv_flow_api.id(122974232450781630)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_03=>'N'
,p_attribute_05=>'top'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(168796172555281343)
,p_name=>'P25_UPDATED_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(168796434648281346)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES LIST'
,p_lov=>'select Full_name_en , person_id from employees_v'
,p_field_template=>wwv_flow_api.id(122973838585781631)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(168796290992281344)
,p_name=>'P25_UPDATED_DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(168796434648281346)
,p_prompt=>'Last Updated'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(122973838585781631)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(169328368809163520)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(168796711076281349)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(169328471099163521)
,p_event_id=>wwv_flow_api.id(169328368809163520)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(169326593092163502)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(169328594155163522)
,p_name=>'Attachments report DA'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(169326593092163502)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(169328699699163523)
,p_event_id=>wwv_flow_api.id(169328594155163522)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(169326593092163502)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(169329152310163528)
,p_name=>'Send DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(169328809061163525)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(169329279164163529)
,p_event_id=>wwv_flow_api.id(169329152310163528)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to send email for all customers in below table. Are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(169329343309163530)
,p_event_id=>wwv_flow_api.id(169329152310163528)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'    l_context          apex_exec.t_context;    ',
'    l_id               pls_integer;',
'    l_ematil_to         pls_integer;',
'    l_ematil_cc         pls_integer;',
'    l_ematil_bcc        pls_integer;',
'    l_customer          pls_integer;',
'    ',
'    ',
'    l_emailsidx        pls_integer;',
'    l_namesids         pls_integer;',
'    l_pos               pls_integer;',
'    l_po_date          pls_integer;',
'    l_Amount           pls_integer;',
'    l_desc             pls_integer;',
'    l_region_id        number;',
'    l_vendor       pls_integer;',
'    ',
'    l_email_id          Number;',
'',
'begin',
'    -- Get the region id for the CUSTOMERS IR region',
'    select region_id',
'      into l_region_id',
'      from apex_application_page_regions',
'     where application_id = :APP_ID',
'       and page_id        = 25',
'       and static_id      = ''USERS'';',
' ',
'    -- Get the query context for the CUSTOMERS IR Region',
'    -- Documentation: https://docs.oracle.com/en/database/oracle/application-express/19.2/aeapi/OPEN_QUERY_CONTEXT-Function.html',
'    l_context := apex_region.open_query_context (',
'                        p_page_id => 25,',
'                        p_region_id => l_region_id );',
'    -- Get the column positions for EMAIL and NAME columns',
' --   l_id        := apex_exec.get_column_position( l_context, ''ID'' );',
'',
'    l_ematil_to := apex_exec.get_column_position( l_context, ''TO_EMAIL'' );',
'    l_ematil_cc   := apex_exec.get_column_position( l_context, ''CC_EMAIL'' );',
'    l_ematil_bcc := apex_exec.get_column_position( l_context, ''BCC_EMAIL'' );',
'    l_customer   := apex_exec.get_column_position( l_context, ''CUSTOMER_NAME'' );',
'    ',
'    -- Loop throught the query of the context',
'    while apex_exec.next_row( l_context ) loop  ',
'    ',
'    ',
'       l_email_id := apex_mail.send (',
'        p_from               => ''ifinance@dctabudhabi.ae'' ,   ',
'        p_to                 => apex_exec.get_varchar2( l_context, l_ematil_to ),',
'        p_cc                 => apex_exec.get_varchar2( l_context, l_ematil_cc ),',
'        p_bcc                 => apex_exec.get_varchar2( l_context, l_ematil_bcc ),         ',
'        p_template_static_id => ''HOTELS_PL'',',
'        p_placeholders       => ''{'' ||',
'        ''    "CUSTOMER_NAME":''            || apex_json.stringify( apex_exec.get_varchar2( l_context, l_customer )) ||    ',
'        ''   , "EMAIL_TEMPLATE":''          || apex_json.stringify( :P25_EMAIL_TEMPLATE) ||    ',
'--        ''   ,"NOTES":''               || apex_json.stringify( :P25_NOTE ) ||    ',
'        ''}'' );',
'  --***************      ',
'        FOR c1 IN (SELECT FILENAME, FILE_BLOB, FILE_MIMETYPE ',
'                    FROM ar_hotels_p_l_documents',
'                    WHERE TYPE = ''PL''',
'                   ) LOOP',
'            ',
'                    APEX_MAIL.ADD_ATTACHMENT(',
'                        p_mail_id    => l_email_id,',
'                        p_attachment => c1.FILE_BLOB,',
'                        p_filename   => c1.FILENAME,',
'                        p_mime_type  => c1.FILE_MIMETYPE);',
'                    END LOOP;',
'    COMMIT;',
'        ',
' --*****************       ',
'--        update scm_pending_grn grn',
'--        set grn.status = ''Sent''',
'--        where id = apex_json.stringify( apex_exec.get_number( l_context, l_id ));',
'     end loop;',
' ',
'     apex_exec.close( l_context );',
'     apex_mail.push_queue;',
'exception',
'     when others then',
'         apex_exec.close( l_context );',
'     raise; ',
'end;'))
,p_attribute_02=>'P25_EMAIL_TEMPLATE'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(169329453865163531)
,p_event_id=>wwv_flow_api.id(169329152310163528)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Emails Sent Successfully'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(169329577921163532)
,p_event_id=>wwv_flow_api.id(169329152310163528)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(168796355641281345)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Template'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    email_template,',
'    updated_by,',
'    to_char(updated_date,''DD-MON-YYYY HH:MIPM'')',
'into ',
'    :P25_EMAIL_TEMPLATE,',
'    :P25_UPDATED_BY,',
'    :P25_UPDATED_DATE',
'FROM',
'    ar_hotels_p_l_email_template',
'where id = 1;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(168796527961281347)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Email Template'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update ar_hotels_p_l_email_template',
'set email_template = :P25_EMAIL_TEMPLATE',
'where id = 1;'))
,p_process_error_message=>'Email Template Not Updated Successfully'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(168795700504281339)
,p_process_success_message=>'Email Template Updated Successfully'
);
wwv_flow_api.component_end;
end;
/
