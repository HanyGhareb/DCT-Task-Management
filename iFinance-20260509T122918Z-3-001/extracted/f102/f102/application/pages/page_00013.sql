prompt --application/pages/page_00013
begin
--   Manifest
--     PAGE: 00013
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>13
,p_user_interface_id=>wwv_flow_api.id(3440093928015830)
,p_name=>'Employee Details'
,p_alias=>'EMPLOYEE-DETAILS'
,p_step_title=>'Employee Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_step_template=>wwv_flow_api.id(3317567033015717)
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231127161752'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(5071861446045148)
,p_name=>'Photo'
,p_template=>wwv_flow_api.id(3328276690015727)
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Form--noPadding:t-Form--xlarge:t-Form--stretchInputs:margin-top-lg'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'REGION_POSITION_03'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CASE',
'        WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || :P13_USER_NAME',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END PHOTO',
'from dct_employees_list2',
'where person_id = :P13_PERSON_ID',
''))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(3381706881015764)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5071956966045149)
,p_query_column_id=>1
,p_column_alias=>'PHOTO'
,p_column_display_sequence=>1
,p_column_heading=>'&P13_FULL_NAME_EN.'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="200" width="200"   style="border-radius:50%">'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5207708987119694)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3364880770015750)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(3301434120015688)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(3418914725015794)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5208389802119776)
,p_plug_name=>'Employee Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'DCT_EMPLOYEES_LIST2'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5071571678045145)
,p_plug_name=>'Personal Details'
,p_parent_plug_id=>wwv_flow_api.id(5208389802119776)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(3338469521015735)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5072048904045150)
,p_plug_name=>'Assignment Details '
,p_parent_plug_id=>wwv_flow_api.id(5208389802119776)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(3338469521015735)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5516100250809401)
,p_plug_name=>'Payroll Details'
,p_parent_plug_id=>wwv_flow_api.id(5208389802119776)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(3338469521015735)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5516222845809402)
,p_plug_name=>'Contacts Details'
,p_parent_plug_id=>wwv_flow_api.id(5208389802119776)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(3338469521015735)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5516339991809403)
,p_plug_name=>'Other Details'
,p_parent_plug_id=>wwv_flow_api.id(5208389802119776)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(3338469521015735)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(114776710562049817)
,p_plug_name=>'AP Vendors Accounts'
,p_parent_plug_id=>wwv_flow_api.id(5208389802119776)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(3338469521015735)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(114776815704049818)
,p_plug_name=>'Employee Vendors Report'
,p_parent_plug_id=>wwv_flow_api.id(114776710562049817)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3353501491015744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'EMPLOYEE_VENDORS'
,p_query_where=>'PERSON_ID = :P13_PERSON_ID'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P13_PERSON_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Employee Vendors Report'
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
 p_id=>wwv_flow_api.id(114776980273049819)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>114776980273049819
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114777009392049820)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114777120449049821)
,p_db_column_name=>'VENDOR_NUM'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Vendor Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114777222882049822)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114777358142049823)
,p_db_column_name=>'VENDOR_STATUS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114777426339049824)
,p_db_column_name=>'BANK_ACCOUNT'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Bank Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114777519916049825)
,p_db_column_name=>'BANK_ACCOUNT_NAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Bank Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114777687341049826)
,p_db_column_name=>'START_DATE_ACTIVE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Start Date Active'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114777794938049827)
,p_db_column_name=>'END_DATE_ACTIVE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'End Date Active'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114777812715049828)
,p_db_column_name=>'ENABLED_FLAG'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Enabled Flag'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114777973809049829)
,p_db_column_name=>'HOLD_FLAG'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Hold Flag'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114778052964049830)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114778103280049831)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114778220621049832)
,p_db_column_name=>'LAST_UPDATE_DATE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Last Update Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114778302221049833)
,p_db_column_name=>'LAST_UPDATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Last Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114778449742049834)
,p_db_column_name=>'EMPLOYEE_NUMBER'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Employee Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114778572199049835)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114778615016049836)
,p_db_column_name=>'IBAN'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'IBAN'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114778716862049837)
,p_db_column_name=>'ACCOUNT_TYPE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Account Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(115295661695824595)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(115292450088939455)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1152925'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'VENDOR_NAME:VENDOR_NUM:VENDOR_SITE_CODE:VENDOR_STATUS:BANK_ACCOUNT_NAME:BANK_ACCOUNT:IBAN:START_DATE_ACTIVE:END_DATE_ACTIVE:ENABLED_FLAG:HOLD_FLAG:ACCOUNT_TYPE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5516482911809404)
,p_plug_name=>'Photo Details'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3328276690015727)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6575253364184628)
,p_plug_name=>'Petty Cash'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(count(petty_cash_id) , 0) total , ''Total Requests'' label',
'from hrss_petty_cash',
'where employee_num = :P13_EMPLOYEE_NUM',
'group by ''Total Requests'''))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_ajax_items_to_submit=>'P13_EMPLOYEE_NUM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'LABEL'
,p_attribute_02=>'TOTAL'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6575356377184629)
,p_plug_name=>'Open Petty Cash'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(count(petty_cash_id) , 0) total , ''Open Requests'' Open',
'from hrss_petty_cash',
'where employee_num = :P13_EMPLOYEE_NUM',
'and status = ''Open''',
'group by ''Open Requests'';'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_ajax_items_to_submit=>'P13_EMPLOYEE_NUM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'OPEN'
,p_attribute_02=>'TOTAL'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(152120941286055502)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(5072048904045150)
,p_button_name=>'Clear_USER_ORG'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--link'
,p_button_template_id=>wwv_flow_api.id(3416848288015791)
,p_button_image_alt=>'Clear User Org'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(151913064606018614)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(5072048904045150)
,p_button_name=>'Clear_Line_Manager'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--link'
,p_button_template_id=>wwv_flow_api.id(3416848288015791)
,p_button_image_alt=>'Clear Line Manager'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(34282002161651531)
,p_button_sequence=>230
,p_button_plug_id=>wwv_flow_api.id(5072048904045150)
,p_button_name=>'reset_department_user'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(3416848288015791)
,p_button_image_alt=>'Reset'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-undo'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(35392077172055811)
,p_button_sequence=>270
,p_button_plug_id=>wwv_flow_api.id(5072048904045150)
,p_button_name=>'reset_director'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(3416848288015791)
,p_button_image_alt=>'Reset'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-undo'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(35392496348055815)
,p_button_sequence=>290
,p_button_plug_id=>wwv_flow_api.id(5072048904045150)
,p_button_name=>'reset_Executive_director'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(3416848288015791)
,p_button_image_alt=>'Reset'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-undo'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5250594779119808)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(5208389802119776)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>'P13_PERSON_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(142406949752823831)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(5208389802119776)
,p_button_name=>'Change_Password'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(3417666671015793)
,p_button_image_alt=>'Change Password'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_redirect_url=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.::P17_PERSON_ID,P17_EMP_NAME:&P13_PERSON_ID.,&P13_FULL_NAME_EN.'
,p_icon_css_classes=>'fa-key'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5249337679119805)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(5208389802119776)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5250984069119808)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(5208389802119776)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_button_condition=>'P13_PERSON_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5250159667119807)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(5208389802119776)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition_type=>'NEVER'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(5251280209119808)
,p_branch_action=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5069982731045129)
,p_name=>'P13_PERSON_TYPE_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_prompt=>'Person Type'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'from dct_employees_lookups',
'where lookup_name = ''Person Types''',
'and code = :P13_PERSON_TYPE_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5070041234045130)
,p_name=>'P13_PAYROLL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(5516100250809401)
,p_prompt=>'Payroll'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'            from dct_employees_lookups',
'            where lookup_name = ''PayrollId''',
'            and code = :P13_PAYROLL_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5070118465045131)
,p_name=>'P13_SUPERVISOR_NAME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_prompt=>'Supervisor Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select s.full_name_en',
'from dct_employees_list2 s',
'where s.employee_num =  :P13_SUPERVISOR_NUM'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5070268945045132)
,p_name=>'P13_ORGANIZATION_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_prompt=>'Organization Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select org_name',
'from organizations_v',
'where org_id = :P13_ORGANIZATION_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5070336075045133)
,p_name=>'P13_JOB'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_prompt=>'Job'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'from dct_employees_lookups',
'where lookup_name = ''Jobs Code''',
'and code = :P13_JOB_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5070490990045134)
,p_name=>'P13_POSITION'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_prompt=>'Position'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'from dct_employees_lookups',
'where lookup_name = ''Positions Codes''',
'and code = :P13_POSITION_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5070559960045135)
,p_name=>'P13_GRADE'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_prompt=>'Grade'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'from dct_employees_lookups',
'where lookup_name = ''Grades Codes''',
'and code = :P13_GRADE_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5070625738045136)
,p_name=>'P13_NATIONALITY'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_prompt=>'Nationality'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'from dct_employees_lookups',
'where lookup_name = ''Nationality Code''',
'and code = :P13_NATIONALITY_CODE'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5070760988045137)
,p_name=>'P13_MARITAL_STATUS_NAME'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_prompt=>'Marital Status'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'            from dct_employees_lookups',
'            where lookup_name = ''Marital Status Codes''',
'            and code = :P13_MARITAL_STATUS'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5070801689045138)
,p_name=>'P13_SEX_NAME'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_prompt=>'Gender'
,p_source=>'select decode (:P13_SEX , ''F'' , ''Female'' , ''Male'') from dual;'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5070931354045139)
,p_name=>'P13_RELIGION'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_prompt=>'Religion'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'from dct_employees_lookups',
'where lookup_name = ''Religion Codes''',
'and code = :P13_RELIGION_CODE'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5071039449045140)
,p_name=>'P13_LOCATION'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_prompt=>'Location'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'from dct_employees_lookups',
' where ',
'-- lookup_name = ''Locations Codes''',
'  code = :P13_LOCATION_ID',
'  and rownum =1'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5071121148045141)
,p_name=>'P13_ASSIGNMENT_TYPE_NAME'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_prompt=>'Assignment Type'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'  from dct_employees_lookups',
'  where lookup_name = ''Assignements Types Code''',
'   and code = :P13_ASSIGNMENT_TYPE'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5071234486045142)
,p_name=>'P13_PAY_BASIS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(5516100250809401)
,p_prompt=>'Pay Basis'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'            from dct_employees_lookups',
'            where lookup_name = ''PayBasisId''',
'            and code = :P13_PAY_BASIS_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5071335402045143)
,p_name=>'P13_ASSIGNMENT_STATUS_TYPE'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_prompt=>'Assignment Status Type'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'            from dct_employees_lookups',
'            where lookup_name = ''Assignment Status Types''',
'            and code = :P13_ASSIGNMENT_STATUS_TYPE_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5071401473045144)
,p_name=>'P13_PEOPLE_GROUP'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_prompt=>'People Group'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(desc_E_user , desc_e)',
'            from dct_employees_lookups',
'            where lookup_name = ''PeopleGroupId''',
'            and code = :P13_PEOPLE_GROUP_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5208668177119776)
,p_name=>'P13_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(5208389802119776)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5209056348119779)
,p_name=>'P13_PERSON_TYPE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'PERSON_TYPE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5209442211119780)
,p_name=>'P13_EMPLOYEE_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Employee Num'
,p_source=>'EMPLOYEE_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5209801842119780)
,p_name=>'P13_PAYROLL_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(5516100250809401)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'PAYROLL_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5210289014119780)
,p_name=>'P13_TITLE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Title'
,p_source=>'TITLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5210660475119780)
,p_name=>'P13_FIRST_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'First Name'
,p_source=>'FIRST_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5211084757119781)
,p_name=>'P13_SECOND_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Second Name'
,p_source=>'SECOND_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5211430505119781)
,p_name=>'P13_THIRD_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Third Name'
,p_source=>'THIRD_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5211827685119781)
,p_name=>'P13_LAST_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Last Name'
,p_source=>'LAST_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5212283992119781)
,p_name=>'P13_FIRST_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'First Name Ar'
,p_source=>'FIRST_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5212664120119782)
,p_name=>'P13_SECOND_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Second Name Ar'
,p_source=>'SECOND_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5213068284119782)
,p_name=>'P13_LAST_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Last Name Ar'
,p_source=>'LAST_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5213453624119782)
,p_name=>'P13_FULL_NAME_EN'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Full Name'
,p_source=>'FULL_NAME_EN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5213813817119782)
,p_name=>'P13_FULL_NAME_AR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Full Name (Arabic)'
,p_source=>'FULL_NAME_AR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5214294210119783)
,p_name=>'P13_NATIONAL_IDENTIFIER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'National Identifier'
,p_source=>'NATIONAL_IDENTIFIER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5214637854119783)
,p_name=>'P13_MANAGER_FLAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Manager ?'
,p_source=>'MANAGER_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'Copy of YES_LOV'
,p_lov=>'.'||wwv_flow_api.id(5295408541745737)||'.'
,p_begin_on_new_line=>'N'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'2'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5215002597119783)
,p_name=>'P13_SUPERVISOR_NUM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Supervisor Num'
,p_source=>'SUPERVISOR_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5215423184119784)
,p_name=>'P13_ORGANIZATION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'ORGANIZATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5215822627119784)
,p_name=>'P13_JOB_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'JOB_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5216223023119784)
,p_name=>'P13_POSITION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'POSITION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5216658247119784)
,p_name=>'P13_GRADE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'GRADE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5217066300119785)
,p_name=>'P13_NATIONALITY_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'NATIONALITY_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5217475612119785)
,p_name=>'P13_SEX'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'SEX'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5217808944119785)
,p_name=>'P13_MARITAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'MARITAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5218225396119785)
,p_name=>'P13_RELIGION_CODE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'RELIGION_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5218631044119786)
,p_name=>'P13_BIRTH_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Birth Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'BIRTH_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5219015591119786)
,p_name=>'P13_HIRE_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Hire Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'HIRE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5219446328119786)
,p_name=>'P13_ORIGINAL_HIRE_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Original Hire Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'ORIGINAL_HIRE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5219896220119786)
,p_name=>'P13_EMAIL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(5516222845809402)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Email'
,p_source=>'EMAIL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5220206620119787)
,p_name=>'P13_MOBILE_SMS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>440
,p_item_plug_id=>wwv_flow_api.id(5516222845809402)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Mobile SMS'
,p_source=>'MOBILE_SMS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5220616374119787)
,p_name=>'P13_LOCATION_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'LOCATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5221036941119787)
,p_name=>'P13_CURRENT_FLAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Current Flag (Active?)'
,p_source=>'CURRENT_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5221414223119787)
,p_name=>'P13_PRIMARY_FLAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Primary Flag ?'
,p_source=>'PRIMARY_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'Copy of YES_LOV'
,p_lov=>'.'||wwv_flow_api.id(5295408541745737)||'.'
,p_begin_on_new_line=>'N'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'2'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5221851533119788)
,p_name=>'P13_ASSIGNMENT_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'ASSIGNMENT_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5222216513119788)
,p_name=>'P13_ASSIGNMENT_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'ASSIGNMENT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5222682523119788)
,p_name=>'P13_ASSIGNMENT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Assignment Number'
,p_source=>'ASSIGNMENT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5223099828119789)
,p_name=>'P13_PAY_BASIS_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(5516100250809401)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'PAY_BASIS_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5223464266119789)
,p_name=>'P13_ASSIGNMENT_STATUS_TYPE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'ASSIGNMENT_STATUS_TYPE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5223895812119789)
,p_name=>'P13_PEOPLE_GROUP_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'PEOPLE_GROUP_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5224233026119789)
,p_name=>'P13_USER_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>690
,p_item_plug_id=>wwv_flow_api.id(5208389802119776)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'USER_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5224680953119790)
,p_name=>'P13_USER_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'User Name'
,p_source=>'USER_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5225087259119790)
,p_name=>'P13_PHONE_NOS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>600
,p_item_plug_id=>wwv_flow_api.id(5516222845809402)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Phone Nos'
,p_source=>'PHONE_NOS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5227041031119791)
,p_name=>'P13_BUSINESS_GROUP_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>700
,p_item_plug_id=>wwv_flow_api.id(5208389802119776)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'BUSINESS_GROUP_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5227445007119791)
,p_name=>'P13_ASSIGNMENT_CATEGORY_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'ASSIGNMENT_CATEGORY_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5227850668119792)
,p_name=>'P13_EMPLOYMENT_CATEGORY_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'EMPLOYMENT_CATEGORY_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5228280885119792)
,p_name=>'P13_TERMINATION_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Termination Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'TERMINATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5228628145119792)
,p_name=>'P13_PHOTO_BLOB'
,p_source_data_type=>'BLOB'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(5516482911809404)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Brows'
,p_source=>'PHOTO_BLOB'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(3416377484015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'DB_COLUMN'
,p_attribute_02=>'PHOTO_MIMETYPE'
,p_attribute_03=>'PHOTO_NAME'
,p_attribute_04=>'PHOTO_CHARSET'
,p_attribute_05=>'PHOTO_LASTUPD'
,p_attribute_06=>'Y'
,p_attribute_08=>'inline'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5229082552119793)
,p_name=>'P13_PHOTO_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(5516482911809404)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'PHOTO_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5229444096119793)
,p_name=>'P13_PHOTO_MIMETYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(5516482911809404)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'PHOTO_MIMETYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5229883207119793)
,p_name=>'P13_PHOTO_CHARSET'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(5516482911809404)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_source=>'PHOTO_CHARSET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5230262084119793)
,p_name=>'P13_PHOTO_LASTUPD'
,p_source_data_type=>'DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(5516482911809404)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Updated ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'PHOTO_LASTUPD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416377484015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5230660236119794)
,p_name=>'P13_ORGANIZATION_ID_USER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Organization (User)'
,p_source=>'ORGANIZATION_ID_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ALL ORGANIZATIONS WITH DETAILS LOV'
,p_lov=>'select org_name ,  org_level , parent_org_name parent_org ,parent_level, department_name , sector , org_id from organizations_details_v'
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_07=>'Select organization'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5231021050119794)
,p_name=>'P13_SUPERVISOR_NUM_USER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Supervisor Num (User)'
,p_source=>'SUPERVISOR_NUM_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ALL EMPLOYEES BY EMP NUM LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select full_name_en ',
'    , employee_num',
'from dct_employees_list2'))
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>20
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_07=>'Select Employee'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5231490757119794)
,p_name=>'P13_EMAIL_USER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_api.id(5516222845809402)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Email (User)'
,p_source=>'EMAIL_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>128
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'EMAIL'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5231809970119794)
,p_name=>'P13_MOBILE_USER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>450
,p_item_plug_id=>wwv_flow_api.id(5516222845809402)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Mobile (User)'
,p_source=>'MOBILE_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5516521772809405)
,p_name=>'P13_SECTOR'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5516671851809406)
,p_name=>'P13_DEPARTMENT'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_prompt=>'Department'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5516715950809407)
,p_name=>'P13_COST_CENTER'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5516918356809409)
,p_name=>'P13_DEPT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_prompt=>'Department'
,p_source=>'P13_DEPARTMENT'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34281508699651526)
,p_name=>'P13_COST_CENTER_USER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Cost Center (User)'
,p_source=>'COST_CENTER_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'COST CENTERS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct COST_CENTER_CODE ',
'    || ''('' || ',
'    COST_CENTER_DESCRIPTION',
'    || '')''  cc_name',
'    ,  COST_CENTER_CODE ',
'from dct_gl_code_combinations_all',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34281959590651530)
,p_name=>'P13_DEPARTMENT_USER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Department (User)'
,p_source=>'DEPARTMENT_ID_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(org_name_en_user , org_name_en) org_name',
'        , org_id',
'from dct_hr_organizations',
'where org_level_name = ''Department''',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'Y'
,p_attribute_06=>'0'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34282354677651534)
,p_name=>'P13_SECTOR_USER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Sector (User)'
,p_source=>'SECTOR_ID_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(org_name_en_user , org_name_en) org_name',
'        , org_id',
'from dct_hr_organizations',
'where ORG_LEVEL_ID = 2',
'--and org_level_name = ''Sector'' ',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(35391911806055810)
,p_name=>'P13_DIRECTOR_PERSON_ID_USER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Director (User)'
,p_source=>'DIRECTOR_PERSON_ID_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DCT_EMPLOYEES_LIST2.FULL_NAME_EN as FULL_NAME_EN,',
'    DCT_EMPLOYEES_LIST2.PERSON_ID as PERSON_ID ',
' from DCT_EMPLOYEES_LIST2 DCT_EMPLOYEES_LIST2',
' where CURRENT_FLAG = ''Y''',
' --and PERSON_ID != :P13_PERSON_ID ',
' ; '))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(35392315786055814)
,p_name=>'P13_EXECUTIVE_DIR_PERSON_ID_USER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(5072048904045150)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Executive Director (User)'
,p_source=>'EXECUTIVE_DIR_PERSON_ID_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DCT_EMPLOYEES_LIST2.FULL_NAME_EN || '' - '' || EMPLOYEE_NUM as FULL_NAME_EN,',
'    DCT_EMPLOYEES_LIST2.PERSON_ID as PERSON_ID ',
' from DCT_EMPLOYEES_LIST2 DCT_EMPLOYEES_LIST2',
' where CURRENT_FLAG = ''Y''',
' --and PERSON_ID != :P13_PERSON_ID ',
' ; '))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(40694605096912810)
,p_name=>'P13_ACCOUNT_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(5071571678045145)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Account Status'
,p_source=>'ACCOUNT_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'STATUS LOV'
,p_lov=>'.'||wwv_flow_api.id(4580824401142588)||'.'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(3416586982015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53437337448667738)
,p_name=>'P13_SOURCE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(5516339991809403)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Source'
,p_source=>'SOURCE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(189262648744827719)
,p_name=>'P13_PAYROLL_AREA'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(5516100250809401)
,p_item_source_plug_id=>wwv_flow_api.id(5208389802119776)
,p_prompt=>'Payroll Area'
,p_source=>'PAYROLL_AREA_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'PAYROLL AREAS LOV2'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PAYROLL_AREA , PAYROLL_AREA_ID',
'from payroll_areas',
'where status = ''A''',
'and sysdate between nvl(start_date ,  sysdate - 10) ',
'        and nvl(end_date , sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(3416298813015790)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(34282107502651532)
,p_name=>'reset department User DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(34282002161651531)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34282281612651533)
,p_event_id=>wwv_flow_api.id(34282107502651532)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_DEPARTMENT_USER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(35392140330055812)
,p_name=>'reset_director DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(35392077172055811)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(35392255770055813)
,p_event_id=>wwv_flow_api.id(35392140330055812)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_DIRECTOR_PERSON_ID_USER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(35392538490055816)
,p_name=>'reset_Executive_director DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(35392496348055815)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(35392626890055817)
,p_event_id=>wwv_flow_api.id(35392538490055816)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_EXECUTIVE_DIR_PERSON_ID_USER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(151913183879018615)
,p_name=>'clear Line Manager DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(151913064606018614)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(151913225715018616)
,p_event_id=>wwv_flow_api.id(151913183879018615)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_SUPERVISOR_NUM_USER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(152121051004055503)
,p_name=>'Clear_USER_ORG DA'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(152120941286055502)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(152121155086055504)
,p_event_id=>wwv_flow_api.id(152121051004055503)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_ORGANIZATION_ID_USER'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(5252124993119808)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(5208389802119776)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Employee Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(5251743098119808)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(5208389802119776)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Employee Details'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(5516801453809408)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Get Sector Dept CC '
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select sector , department_name , cost_center_code',
'into    :P13_SECTOR , :P13_DEPARTMENT , :P13_COST_CENTER',
'from employees_v',
'where person_id = :P13_PERSON_ID;',
'exception',
'    when others',
'        then ',
'            null;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
