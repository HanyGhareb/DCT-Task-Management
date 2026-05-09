prompt --application/pages/page_00005
begin
--   Manifest
--     PAGE: 00005
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
 p_id=>5
,p_user_interface_id=>wwv_flow_api.id(3440093928015830)
,p_name=>'Missing HR Data Details'
,p_alias=>'MISSING-HR-DATA-DETAILS'
,p_step_title=>'Missing HR Data Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200914084604'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3282133053870704)
,p_plug_name=>'Missing HR Data Details: No Parent Organizations'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- 2- List of org without Parent Org',
'select *',
'from organizations_details_v',
'where parent_org_name is null',
'and org_level <> ''Agency'';'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P5_SHOW'
,p_plug_display_when_cond2=>'2'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Missing HR Data Details: No Parent Organizations'
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
 p_id=>wwv_flow_api.id(3282356088870706)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_ORG_ID,P8_FROM_PAGE:#ORG_ID#,5'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>3282356088870706
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3537657531139818)
,p_db_column_name=>'ORG_ID'
,p_display_order=>10
,p_column_identifier=>'B'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3537765435139819)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>20
,p_column_identifier=>'C'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3537881818139820)
,p_db_column_name=>'ORG_LEVEL'
,p_display_order=>30
,p_column_identifier=>'D'
,p_column_label=>'Org Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3537977001139821)
,p_db_column_name=>'PARENT_ORG'
,p_display_order=>40
,p_column_identifier=>'E'
,p_column_label=>'Parent Org'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3538098399139822)
,p_db_column_name=>'PARENT_ORG_NAME'
,p_display_order=>50
,p_column_identifier=>'F'
,p_column_label=>'Parent Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3538191494139823)
,p_db_column_name=>'PARENT_LEVEL'
,p_display_order=>60
,p_column_identifier=>'G'
,p_column_label=>'Parent Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3538213668139824)
,p_db_column_name=>'SHORT_NAME_EN'
,p_display_order=>70
,p_column_identifier=>'H'
,p_column_label=>'Short Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3538329493139825)
,p_db_column_name=>'STATUS'
,p_display_order=>80
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3538483286139826)
,p_db_column_name=>'MANAGER_EMP_NUM'
,p_display_order=>90
,p_column_identifier=>'J'
,p_column_label=>'Manager Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3538545368139827)
,p_db_column_name=>'MANAGER_NAME'
,p_display_order=>100
,p_column_identifier=>'K'
,p_column_label=>'Manager Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3538675707139828)
,p_db_column_name=>'PARTNER_EMP_NUM'
,p_display_order=>110
,p_column_identifier=>'L'
,p_column_label=>'Partner Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3538717101139829)
,p_db_column_name=>'PARTNER_NAME'
,p_display_order=>120
,p_column_identifier=>'M'
,p_column_label=>'Partner Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3538805802139830)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>130
,p_column_identifier=>'N'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3538915475139831)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>140
,p_column_identifier=>'O'
,p_column_label=>'Department Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3539002637139832)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>150
,p_column_identifier=>'P'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3539102516139833)
,p_db_column_name=>'DIRECTOR_NUM'
,p_display_order=>160
,p_column_identifier=>'Q'
,p_column_label=>'Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3539243363139834)
,p_db_column_name=>'DIRECTOR_NAME'
,p_display_order=>170
,p_column_identifier=>'R'
,p_column_label=>'Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3539379197139835)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>180
,p_column_identifier=>'S'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3539454063139836)
,p_db_column_name=>'SECTOR'
,p_display_order=>190
,p_column_identifier=>'T'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3539502281139837)
,p_db_column_name=>'EXECUTIVE_DIRECTOR_NUM'
,p_display_order=>200
,p_column_identifier=>'U'
,p_column_label=>'Executive Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3539696058139838)
,p_db_column_name=>'EXECUTIVE_DIRECTOR__NAME'
,p_display_order=>210
,p_column_identifier=>'V'
,p_column_label=>'Executive Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3539771754139839)
,p_db_column_name=>'ORG_RATE'
,p_display_order=>220
,p_column_identifier=>'W'
,p_column_label=>'Org Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3539865675139840)
,p_db_column_name=>'SERVICE_PROVIDER'
,p_display_order=>230
,p_column_identifier=>'X'
,p_column_label=>'Service Provider'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3539935172139841)
,p_db_column_name=>'ORG_PRIORITY'
,p_display_order=>240
,p_column_identifier=>'Y'
,p_column_label=>'Org Priority'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3540060191139842)
,p_db_column_name=>'START_DATE'
,p_display_order=>250
,p_column_identifier=>'Z'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3540171976139843)
,p_db_column_name=>'END_DATE'
,p_display_order=>260
,p_column_identifier=>'AA'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3540207787139844)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>270
,p_column_identifier=>'AB'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3540358648139845)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>280
,p_column_identifier=>'AC'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3540499327139846)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>290
,p_column_identifier=>'AD'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3540527459139847)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>300
,p_column_identifier=>'AE'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3285505238870738)
,p_plug_name=>'Missing HR Data Details: No Managers'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--3- List of org without org Manager',
'select *',
'from organizations_details_v',
'where manager_emp_num is NULL;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P5_SHOW'
,p_plug_display_when_cond2=>'3'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Missing HR Data Details: No Managers'
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
 p_id=>wwv_flow_api.id(3285731484870740)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_ORG_ID,P8_FROM_PAGE:#ORG_ID#,5'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>3285731484870740
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3540604930139848)
,p_db_column_name=>'ORG_ID'
,p_display_order=>10
,p_column_identifier=>'B'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3540712963139849)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>20
,p_column_identifier=>'C'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3540890144139850)
,p_db_column_name=>'ORG_LEVEL'
,p_display_order=>30
,p_column_identifier=>'D'
,p_column_label=>'Org Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3570409074148501)
,p_db_column_name=>'PARENT_ORG'
,p_display_order=>40
,p_column_identifier=>'E'
,p_column_label=>'Parent Org'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3570587183148502)
,p_db_column_name=>'PARENT_ORG_NAME'
,p_display_order=>50
,p_column_identifier=>'F'
,p_column_label=>'Parent Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3570617207148503)
,p_db_column_name=>'PARENT_LEVEL'
,p_display_order=>60
,p_column_identifier=>'G'
,p_column_label=>'Parent Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3570718222148504)
,p_db_column_name=>'SHORT_NAME_EN'
,p_display_order=>70
,p_column_identifier=>'H'
,p_column_label=>'Short Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3570891670148505)
,p_db_column_name=>'STATUS'
,p_display_order=>80
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3570958694148506)
,p_db_column_name=>'MANAGER_EMP_NUM'
,p_display_order=>90
,p_column_identifier=>'J'
,p_column_label=>'Manager Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3571052909148507)
,p_db_column_name=>'MANAGER_NAME'
,p_display_order=>100
,p_column_identifier=>'K'
,p_column_label=>'Manager Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3571129315148508)
,p_db_column_name=>'PARTNER_EMP_NUM'
,p_display_order=>110
,p_column_identifier=>'L'
,p_column_label=>'Partner Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3571248170148509)
,p_db_column_name=>'PARTNER_NAME'
,p_display_order=>120
,p_column_identifier=>'M'
,p_column_label=>'Partner Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3571347077148510)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>130
,p_column_identifier=>'N'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3571430600148511)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>140
,p_column_identifier=>'O'
,p_column_label=>'Department Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3571550680148512)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>150
,p_column_identifier=>'P'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3571630171148513)
,p_db_column_name=>'DIRECTOR_NUM'
,p_display_order=>160
,p_column_identifier=>'Q'
,p_column_label=>'Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3571765104148514)
,p_db_column_name=>'DIRECTOR_NAME'
,p_display_order=>170
,p_column_identifier=>'R'
,p_column_label=>'Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3571895389148515)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>180
,p_column_identifier=>'S'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3571978992148516)
,p_db_column_name=>'SECTOR'
,p_display_order=>190
,p_column_identifier=>'T'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3572090604148517)
,p_db_column_name=>'EXECUTIVE_DIRECTOR_NUM'
,p_display_order=>200
,p_column_identifier=>'U'
,p_column_label=>'Executive Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3572144714148518)
,p_db_column_name=>'EXECUTIVE_DIRECTOR__NAME'
,p_display_order=>210
,p_column_identifier=>'V'
,p_column_label=>'Executive Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3572216280148519)
,p_db_column_name=>'ORG_RATE'
,p_display_order=>220
,p_column_identifier=>'W'
,p_column_label=>'Org Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3572358012148520)
,p_db_column_name=>'SERVICE_PROVIDER'
,p_display_order=>230
,p_column_identifier=>'X'
,p_column_label=>'Service Provider'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3572497131148521)
,p_db_column_name=>'ORG_PRIORITY'
,p_display_order=>240
,p_column_identifier=>'Y'
,p_column_label=>'Org Priority'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3572511188148522)
,p_db_column_name=>'START_DATE'
,p_display_order=>250
,p_column_identifier=>'Z'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3572679001148523)
,p_db_column_name=>'END_DATE'
,p_display_order=>260
,p_column_identifier=>'AA'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3572711113148524)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>270
,p_column_identifier=>'AB'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3572881613148525)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>280
,p_column_identifier=>'AC'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3572927340148526)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>290
,p_column_identifier=>'AD'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3573045119148527)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>300
,p_column_identifier=>'AE'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(3621032742170494)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'36211'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORG_NAME:ORG_LEVEL:PARENT_ORG_NAME:PARENT_LEVEL:MANAGER_EMP_NUM:MANAGER_NAME:DEPARTMENT_NAME:DIRECTOR_NAME:SECTOR:EXECUTIVE_DIRECTOR_NUM:EXECUTIVE_DIRECTOR__NAME'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3285962566870742)
,p_plug_name=>'Missing HR Data Details: No Director (Check the organization hierarchy )'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--4- List of org without Director',
'select *',
'from organizations_details_v',
'where director_num is null',
'and org_level not in (''Sector'' , ''Director General Office'' , ''Agency'' );'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P5_SHOW'
,p_plug_display_when_cond2=>'4'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Missing HR Data Details: No Director (Check the organization hierarchy )'
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
 p_id=>wwv_flow_api.id(3286132843870744)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_ORG_ID,P8_FROM_PAGE:#ORG_ID#,5'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>3286132843870744
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3573199352148528)
,p_db_column_name=>'ORG_ID'
,p_display_order=>10
,p_column_identifier=>'B'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3573272916148529)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>20
,p_column_identifier=>'C'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3573309951148530)
,p_db_column_name=>'ORG_LEVEL'
,p_display_order=>30
,p_column_identifier=>'D'
,p_column_label=>'Org Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3573407222148531)
,p_db_column_name=>'PARENT_ORG'
,p_display_order=>40
,p_column_identifier=>'E'
,p_column_label=>'Parent Org'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3573572584148532)
,p_db_column_name=>'PARENT_ORG_NAME'
,p_display_order=>50
,p_column_identifier=>'F'
,p_column_label=>'Parent Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3573665679148533)
,p_db_column_name=>'PARENT_LEVEL'
,p_display_order=>60
,p_column_identifier=>'G'
,p_column_label=>'Parent Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3573779013148534)
,p_db_column_name=>'SHORT_NAME_EN'
,p_display_order=>70
,p_column_identifier=>'H'
,p_column_label=>'Short Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3573877394148535)
,p_db_column_name=>'STATUS'
,p_display_order=>80
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3573993025148536)
,p_db_column_name=>'MANAGER_EMP_NUM'
,p_display_order=>90
,p_column_identifier=>'J'
,p_column_label=>'Manager Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3574037890148537)
,p_db_column_name=>'MANAGER_NAME'
,p_display_order=>100
,p_column_identifier=>'K'
,p_column_label=>'Manager Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3574190248148538)
,p_db_column_name=>'PARTNER_EMP_NUM'
,p_display_order=>110
,p_column_identifier=>'L'
,p_column_label=>'Partner Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3574265118148539)
,p_db_column_name=>'PARTNER_NAME'
,p_display_order=>120
,p_column_identifier=>'M'
,p_column_label=>'Partner Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3574394910148540)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>130
,p_column_identifier=>'N'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3574441659148541)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>140
,p_column_identifier=>'O'
,p_column_label=>'Department Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3574518878148542)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>150
,p_column_identifier=>'P'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3574656437148543)
,p_db_column_name=>'DIRECTOR_NUM'
,p_display_order=>160
,p_column_identifier=>'Q'
,p_column_label=>'Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3574773617148544)
,p_db_column_name=>'DIRECTOR_NAME'
,p_display_order=>170
,p_column_identifier=>'R'
,p_column_label=>'Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3574848066148545)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>180
,p_column_identifier=>'S'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3574947890148546)
,p_db_column_name=>'SECTOR'
,p_display_order=>190
,p_column_identifier=>'T'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3575083336148547)
,p_db_column_name=>'EXECUTIVE_DIRECTOR_NUM'
,p_display_order=>200
,p_column_identifier=>'U'
,p_column_label=>'Executive Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3575163271148548)
,p_db_column_name=>'EXECUTIVE_DIRECTOR__NAME'
,p_display_order=>210
,p_column_identifier=>'V'
,p_column_label=>'Executive Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3575217415148549)
,p_db_column_name=>'ORG_RATE'
,p_display_order=>220
,p_column_identifier=>'W'
,p_column_label=>'Org Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3575307378148550)
,p_db_column_name=>'SERVICE_PROVIDER'
,p_display_order=>230
,p_column_identifier=>'X'
,p_column_label=>'Service Provider'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3585279500149301)
,p_db_column_name=>'ORG_PRIORITY'
,p_display_order=>240
,p_column_identifier=>'Y'
,p_column_label=>'Org Priority'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3585314897149302)
,p_db_column_name=>'START_DATE'
,p_display_order=>250
,p_column_identifier=>'Z'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3585460211149303)
,p_db_column_name=>'END_DATE'
,p_display_order=>260
,p_column_identifier=>'AA'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3585548893149304)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>270
,p_column_identifier=>'AB'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3585622764149305)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>280
,p_column_identifier=>'AC'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3585751165149306)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>290
,p_column_identifier=>'AD'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3585852936149307)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>300
,p_column_identifier=>'AE'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(3535394301136182)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'35354'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORG_NAME:ORG_LEVEL:PARENT_ORG:PARENT_ORG_NAME:PARENT_LEVEL:DEPARTMENT_NAME:DIRECTOR_NUM:SECTOR:EXECUTIVE_DIRECTOR_NUM:EXECUTIVE_DIRECTOR__NAME:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(3622367032196302)
,p_report_id=>wwv_flow_api.id(3535394301136182)
,p_name=>'No Director'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'DIRECTOR_NUM'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("DIRECTOR_NUM" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFD6D2'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3286305170870746)
,p_plug_name=>'Missing HR Data Details: No Executive Director (Check the organization hierarchy )'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--5- List of org without Executive Director',
'select *',
'from organizations_details_v',
'where executive_director_num is null',
'and org_level not in (''Director General Office'' , ''Agency'' );'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P5_SHOW'
,p_plug_display_when_cond2=>'5'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Missing HR Data Details: No Executive Director (Check the organization hierarchy )'
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
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(3286515475870748)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_ORG_ID,P8_FROM_PAGE:#ORG_ID#,5'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>3286515475870748
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3585945805149308)
,p_db_column_name=>'ORG_ID'
,p_display_order=>10
,p_column_identifier=>'B'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3586093144149309)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>20
,p_column_identifier=>'C'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3586136888149310)
,p_db_column_name=>'ORG_LEVEL'
,p_display_order=>30
,p_column_identifier=>'D'
,p_column_label=>'Org Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3586208198149311)
,p_db_column_name=>'PARENT_ORG'
,p_display_order=>40
,p_column_identifier=>'E'
,p_column_label=>'Parent Org'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3586387867149312)
,p_db_column_name=>'PARENT_ORG_NAME'
,p_display_order=>50
,p_column_identifier=>'F'
,p_column_label=>'Parent Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3586428256149313)
,p_db_column_name=>'PARENT_LEVEL'
,p_display_order=>60
,p_column_identifier=>'G'
,p_column_label=>'Parent Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3586526881149314)
,p_db_column_name=>'SHORT_NAME_EN'
,p_display_order=>70
,p_column_identifier=>'H'
,p_column_label=>'Short Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3586673131149315)
,p_db_column_name=>'STATUS'
,p_display_order=>80
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3586772598149316)
,p_db_column_name=>'MANAGER_EMP_NUM'
,p_display_order=>90
,p_column_identifier=>'J'
,p_column_label=>'Manager Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3586822624149317)
,p_db_column_name=>'MANAGER_NAME'
,p_display_order=>100
,p_column_identifier=>'K'
,p_column_label=>'Manager Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3586939000149318)
,p_db_column_name=>'PARTNER_EMP_NUM'
,p_display_order=>110
,p_column_identifier=>'L'
,p_column_label=>'Partner Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3587083771149319)
,p_db_column_name=>'PARTNER_NAME'
,p_display_order=>120
,p_column_identifier=>'M'
,p_column_label=>'Partner Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3587171192149320)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>130
,p_column_identifier=>'N'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3587231462149321)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>140
,p_column_identifier=>'O'
,p_column_label=>'Department Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3587372717149322)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>150
,p_column_identifier=>'P'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3587494404149323)
,p_db_column_name=>'DIRECTOR_NUM'
,p_display_order=>160
,p_column_identifier=>'Q'
,p_column_label=>'Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3587593499149324)
,p_db_column_name=>'DIRECTOR_NAME'
,p_display_order=>170
,p_column_identifier=>'R'
,p_column_label=>'Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3587674946149325)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>180
,p_column_identifier=>'S'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3587723633149326)
,p_db_column_name=>'SECTOR'
,p_display_order=>190
,p_column_identifier=>'T'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3587820665149327)
,p_db_column_name=>'EXECUTIVE_DIRECTOR_NUM'
,p_display_order=>200
,p_column_identifier=>'U'
,p_column_label=>'Executive Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3587903562149328)
,p_db_column_name=>'EXECUTIVE_DIRECTOR__NAME'
,p_display_order=>210
,p_column_identifier=>'V'
,p_column_label=>'Executive Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3588073254149329)
,p_db_column_name=>'ORG_RATE'
,p_display_order=>220
,p_column_identifier=>'W'
,p_column_label=>'Org Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3588142412149330)
,p_db_column_name=>'SERVICE_PROVIDER'
,p_display_order=>230
,p_column_identifier=>'X'
,p_column_label=>'Service Provider'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3588236281149331)
,p_db_column_name=>'ORG_PRIORITY'
,p_display_order=>240
,p_column_identifier=>'Y'
,p_column_label=>'Org Priority'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3588312853149332)
,p_db_column_name=>'START_DATE'
,p_display_order=>250
,p_column_identifier=>'Z'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3588489670149333)
,p_db_column_name=>'END_DATE'
,p_display_order=>260
,p_column_identifier=>'AA'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3588561956149334)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>270
,p_column_identifier=>'AB'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3588688459149335)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>280
,p_column_identifier=>'AC'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3588736603149336)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>290
,p_column_identifier=>'AD'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3588872290149337)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>300
,p_column_identifier=>'AE'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(3619603145153913)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'36197'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORG_ID:ORG_NAME:ORG_LEVEL:PARENT_ORG:PARENT_ORG_NAME:PARENT_LEVEL:SHORT_NAME_EN:STATUS:MANAGER_EMP_NUM:MANAGER_NAME:PARTNER_EMP_NUM:PARTNER_NAME:COST_CENTER_CODE:DEPARTMENT_ID:DEPARTMENT_NAME:DIRECTOR_NUM:DIRECTOR_NAME:SECTOR_ID:SECTOR:EXECUTIVE_DIRE'
||'CTOR_NUM:EXECUTIVE_DIRECTOR__NAME:ORG_RATE:SERVICE_PROVIDER:ORG_PRIORITY:START_DATE:END_DATE:CREATED_DATE:CREATED_BY:UPDATED_DATE:UPDATED_BY'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3286799235870750)
,p_plug_name=>'Missing HR Data Details: No Finance Business Partner '
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- 6-  List of org without FBP',
'select *',
'from organizations_details_v',
'where fbp_role_id is null ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P5_SHOW'
,p_plug_display_when_cond2=>'6'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Missing HR Data Details: No Finance Business Partner '
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
 p_id=>wwv_flow_api.id(3525768432131002)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_ORG_ID,P8_FROM_PAGE:#ORG_ID#,5'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>3525768432131002
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3529333881131038)
,p_db_column_name=>'ORG_ID'
,p_display_order=>10
,p_column_identifier=>'B'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3529447600131039)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>20
,p_column_identifier=>'C'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3529539512131040)
,p_db_column_name=>'ORG_LEVEL'
,p_display_order=>30
,p_column_identifier=>'D'
,p_column_label=>'Org Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3529694639131041)
,p_db_column_name=>'PARENT_ORG'
,p_display_order=>40
,p_column_identifier=>'E'
,p_column_label=>'Parent Org'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3529740813131042)
,p_db_column_name=>'PARENT_ORG_NAME'
,p_display_order=>50
,p_column_identifier=>'F'
,p_column_label=>'Parent Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3529833018131043)
,p_db_column_name=>'PARENT_LEVEL'
,p_display_order=>60
,p_column_identifier=>'G'
,p_column_label=>'Parent Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3529953296131044)
,p_db_column_name=>'SHORT_NAME_EN'
,p_display_order=>70
,p_column_identifier=>'H'
,p_column_label=>'Short Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3530007291131045)
,p_db_column_name=>'STATUS'
,p_display_order=>80
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3530166338131046)
,p_db_column_name=>'MANAGER_EMP_NUM'
,p_display_order=>90
,p_column_identifier=>'J'
,p_column_label=>'Manager Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3530290635131047)
,p_db_column_name=>'MANAGER_NAME'
,p_display_order=>100
,p_column_identifier=>'K'
,p_column_label=>'Manager Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3530330950131048)
,p_db_column_name=>'PARTNER_EMP_NUM'
,p_display_order=>110
,p_column_identifier=>'L'
,p_column_label=>'Partner Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3530439237131049)
,p_db_column_name=>'PARTNER_NAME'
,p_display_order=>120
,p_column_identifier=>'M'
,p_column_label=>'Partner Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3530515639131050)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>130
,p_column_identifier=>'N'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3535909152139801)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>140
,p_column_identifier=>'O'
,p_column_label=>'Department Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3536007037139802)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>150
,p_column_identifier=>'P'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3536192664139803)
,p_db_column_name=>'DIRECTOR_NUM'
,p_display_order=>160
,p_column_identifier=>'Q'
,p_column_label=>'Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3536245658139804)
,p_db_column_name=>'DIRECTOR_NAME'
,p_display_order=>170
,p_column_identifier=>'R'
,p_column_label=>'Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3536330356139805)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>180
,p_column_identifier=>'S'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3536403723139806)
,p_db_column_name=>'SECTOR'
,p_display_order=>190
,p_column_identifier=>'T'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3536522134139807)
,p_db_column_name=>'EXECUTIVE_DIRECTOR_NUM'
,p_display_order=>200
,p_column_identifier=>'U'
,p_column_label=>'Executive Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3536617108139808)
,p_db_column_name=>'EXECUTIVE_DIRECTOR__NAME'
,p_display_order=>210
,p_column_identifier=>'V'
,p_column_label=>'Executive Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3536748767139809)
,p_db_column_name=>'ORG_RATE'
,p_display_order=>220
,p_column_identifier=>'W'
,p_column_label=>'Org Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3536895532139810)
,p_db_column_name=>'SERVICE_PROVIDER'
,p_display_order=>230
,p_column_identifier=>'X'
,p_column_label=>'Service Provider'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3536994253139811)
,p_db_column_name=>'ORG_PRIORITY'
,p_display_order=>240
,p_column_identifier=>'Y'
,p_column_label=>'Org Priority'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3537015723139812)
,p_db_column_name=>'START_DATE'
,p_display_order=>250
,p_column_identifier=>'Z'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3537153971139813)
,p_db_column_name=>'END_DATE'
,p_display_order=>260
,p_column_identifier=>'AA'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3537206273139814)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>270
,p_column_identifier=>'AB'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3537331442139815)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>280
,p_column_identifier=>'AC'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3537461539139816)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>290
,p_column_identifier=>'AD'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3537527148139817)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>300
,p_column_identifier=>'AE'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7600862616029632)
,p_db_column_name=>'FBP_ROLE_ID'
,p_display_order=>310
,p_column_identifier=>'AF'
,p_column_label=>'Fbp Role Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7600978699029633)
,p_db_column_name=>'FBP_ROLE_NAME'
,p_display_order=>320
,p_column_identifier=>'AG'
,p_column_label=>'Fbp Role Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(3620254498155301)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'36203'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORG_ID:ORG_NAME:ORG_LEVEL:PARENT_ORG:PARENT_ORG_NAME:PARENT_LEVEL:SHORT_NAME_EN:STATUS:MANAGER_EMP_NUM:MANAGER_NAME:PARTNER_EMP_NUM:PARTNER_NAME:COST_CENTER_CODE:DEPARTMENT_ID:DEPARTMENT_NAME:DIRECTOR_NUM:DIRECTOR_NAME:SECTOR_ID:SECTOR:EXECUTIVE_DIRE'
||'CTOR_NUM:EXECUTIVE_DIRECTOR__NAME:ORG_RATE:SERVICE_PROVIDER:ORG_PRIORITY:START_DATE:END_DATE:CREATED_DATE:CREATED_BY:UPDATED_DATE:UPDATED_BY:FBP_ROLE_ID:FBP_ROLE_NAME'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3506843813078729)
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
 p_id=>wwv_flow_api.id(3507411327078729)
,p_plug_name=>'Missing HR Data Details: Organizations Levels'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- 1- List of org without Level',
'select * --count(*)',
'from organizations_details_v',
'where org_level is null;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P5_SHOW'
,p_plug_display_when_cond2=>'1'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Missing HR Data Details: Organizations Levels'
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
 p_id=>wwv_flow_api.id(3507539179078729)
,p_name=>'Missing HR Data Details'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_ORG_ID,P8_FROM_PAGE:#ORG_ID#,5'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>3507539179078729
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3507982787078750)
,p_db_column_name=>'ORG_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3508325170078750)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3508733343078751)
,p_db_column_name=>'ORG_LEVEL'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Org Level'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3509157146078751)
,p_db_column_name=>'PARENT_ORG'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Parent Org'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3509541020078751)
,p_db_column_name=>'PARENT_ORG_NAME'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Parent Org Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3509946655078751)
,p_db_column_name=>'PARENT_LEVEL'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Parent Level'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3510340339078752)
,p_db_column_name=>'SHORT_NAME_EN'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Short Name En'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3510704614078752)
,p_db_column_name=>'STATUS'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3511105959078752)
,p_db_column_name=>'MANAGER_EMP_NUM'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Manager Emp Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3511563971078753)
,p_db_column_name=>'MANAGER_NAME'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Manager Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3511969957078753)
,p_db_column_name=>'PARTNER_EMP_NUM'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Partner Emp Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3512325650078753)
,p_db_column_name=>'PARTNER_NAME'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Partner Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3512799249078753)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3513169028078753)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Department Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3513559667078754)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3513900319078754)
,p_db_column_name=>'DIRECTOR_NUM'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Director Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3514371429078754)
,p_db_column_name=>'DIRECTOR_NAME'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Director Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3514734411078754)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3515189324078755)
,p_db_column_name=>'SECTOR'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3515595205078755)
,p_db_column_name=>'EXECUTIVE_DIRECTOR_NUM'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Executive Director Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3515963927078755)
,p_db_column_name=>'EXECUTIVE_DIRECTOR__NAME'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Executive Director  Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3516339886078755)
,p_db_column_name=>'ORG_RATE'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Org Rate'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3516748241078756)
,p_db_column_name=>'SERVICE_PROVIDER'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Service Provider'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3517177348078756)
,p_db_column_name=>'ORG_PRIORITY'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Org Priority'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3517546532078756)
,p_db_column_name=>'START_DATE'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3517958213078756)
,p_db_column_name=>'END_DATE'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3518345329078757)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3518735038078757)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3519175830078757)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3519579799078757)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(3521227064105858)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'35213'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORG_NAME:ORG_LEVEL:PARENT_ORG_NAME:PARENT_LEVEL:'
,p_sort_column_1=>'ORG_NAME'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(3628608413308527)
,p_report_id=>wwv_flow_api.id(3521227064105858)
,p_name=>'No Level'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'ORG_LEVEL'
,p_operator=>'is null'
,p_condition_sql=>' (case when ("ORG_LEVEL" is null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFD6D2'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3525911685131004)
,p_plug_name=>'Missing HR Data Details: No Cost Center'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- 7-  List of org without cost center',
'select * -- count(*)',
'from organizations_details_v',
'where cost_center_code is null ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P5_SHOW'
,p_plug_display_when_cond2=>'7'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Missing HR Data Details: No Cost Center'
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
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(3526149566131006)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_ORG_ID,P8_FROM_PAGE:#ORG_ID#,5'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>3526149566131006
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3526393442131008)
,p_db_column_name=>'ORG_ID'
,p_display_order=>10
,p_column_identifier=>'B'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3526421718131009)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>20
,p_column_identifier=>'C'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3526582160131010)
,p_db_column_name=>'ORG_LEVEL'
,p_display_order=>30
,p_column_identifier=>'D'
,p_column_label=>'Org Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3526643966131011)
,p_db_column_name=>'PARENT_ORG'
,p_display_order=>40
,p_column_identifier=>'E'
,p_column_label=>'Parent Org'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3526762070131012)
,p_db_column_name=>'PARENT_ORG_NAME'
,p_display_order=>50
,p_column_identifier=>'F'
,p_column_label=>'Parent Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3526828913131013)
,p_db_column_name=>'PARENT_LEVEL'
,p_display_order=>60
,p_column_identifier=>'G'
,p_column_label=>'Parent Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3526914339131014)
,p_db_column_name=>'SHORT_NAME_EN'
,p_display_order=>70
,p_column_identifier=>'H'
,p_column_label=>'Short Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3527008675131015)
,p_db_column_name=>'STATUS'
,p_display_order=>80
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3527165422131016)
,p_db_column_name=>'MANAGER_EMP_NUM'
,p_display_order=>90
,p_column_identifier=>'J'
,p_column_label=>'Manager Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3527244628131017)
,p_db_column_name=>'MANAGER_NAME'
,p_display_order=>100
,p_column_identifier=>'K'
,p_column_label=>'Manager Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3527307449131018)
,p_db_column_name=>'PARTNER_EMP_NUM'
,p_display_order=>110
,p_column_identifier=>'L'
,p_column_label=>'Partner Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3527484657131019)
,p_db_column_name=>'PARTNER_NAME'
,p_display_order=>120
,p_column_identifier=>'M'
,p_column_label=>'Partner Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3527551080131020)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>130
,p_column_identifier=>'N'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3527692056131021)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>140
,p_column_identifier=>'O'
,p_column_label=>'Department Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3527792792131022)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>150
,p_column_identifier=>'P'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3527870199131023)
,p_db_column_name=>'DIRECTOR_NUM'
,p_display_order=>160
,p_column_identifier=>'Q'
,p_column_label=>'Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3527948260131024)
,p_db_column_name=>'DIRECTOR_NAME'
,p_display_order=>170
,p_column_identifier=>'R'
,p_column_label=>'Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3528097334131025)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>180
,p_column_identifier=>'S'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3528134913131026)
,p_db_column_name=>'SECTOR'
,p_display_order=>190
,p_column_identifier=>'T'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3528206856131027)
,p_db_column_name=>'EXECUTIVE_DIRECTOR_NUM'
,p_display_order=>200
,p_column_identifier=>'U'
,p_column_label=>'Executive Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3528324150131028)
,p_db_column_name=>'EXECUTIVE_DIRECTOR__NAME'
,p_display_order=>210
,p_column_identifier=>'V'
,p_column_label=>'Executive Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3528496891131029)
,p_db_column_name=>'ORG_RATE'
,p_display_order=>220
,p_column_identifier=>'W'
,p_column_label=>'Org Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3528572783131030)
,p_db_column_name=>'SERVICE_PROVIDER'
,p_display_order=>230
,p_column_identifier=>'X'
,p_column_label=>'Service Provider'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3528607038131031)
,p_db_column_name=>'ORG_PRIORITY'
,p_display_order=>240
,p_column_identifier=>'Y'
,p_column_label=>'Org Priority'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3528716263131032)
,p_db_column_name=>'START_DATE'
,p_display_order=>250
,p_column_identifier=>'Z'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3528824067131033)
,p_db_column_name=>'END_DATE'
,p_display_order=>260
,p_column_identifier=>'AA'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3528934900131034)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>270
,p_column_identifier=>'AB'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3529001713131035)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>280
,p_column_identifier=>'AC'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3529171563131036)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>290
,p_column_identifier=>'AD'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3529203936131037)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>300
,p_column_identifier=>'AE'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(4295969239364868)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'42960'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORG_ID:ORG_NAME:ORG_LEVEL:PARENT_ORG:PARENT_ORG_NAME:PARENT_LEVEL:SHORT_NAME_EN:STATUS:MANAGER_EMP_NUM:MANAGER_NAME:PARTNER_EMP_NUM:PARTNER_NAME:COST_CENTER_CODE:DEPARTMENT_ID:DEPARTMENT_NAME:DIRECTOR_NUM:DIRECTOR_NAME:SECTOR_ID:SECTOR:EXECUTIVE_DIRE'
||'CTOR_NUM:EXECUTIVE_DIRECTOR__NAME:ORG_RATE:SERVICE_PROVIDER:ORG_PRIORITY:START_DATE:END_DATE:CREATED_DATE:CREATED_BY:UPDATED_DATE:UPDATED_BY'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4170565873848432)
,p_plug_name=>'Missing HR Data Details: No Employee Photo'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3353501491015744)
,p_plug_display_sequence=>80
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select person_id ',
'        , full_name_en  ',
'        , user_name ',
'        , email',
'        ,  case nvl(dbms_lob.getlength(photo_blob),0) ',
'           when 0  THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(user_name)',
'           end Photo',
'from dct_employees_list2',
'where photo_blob is null',
'and current_flag = ''Y''',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P5_SHOW'
,p_plug_display_when_cond2=>'8'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Missing HR Data Details: No Employee Photo'
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
 p_id=>wwv_flow_api.id(4170706070848434)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.::P9_PERSON_ID:#PERSON_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>4170706070848434
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4170868187848435)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4170917183848436)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Full Name'
,p_column_link=>'f?p=100:2:&SESSION.::&DEBUG.::P2_USER_NAME:#USER_NAME#'
,p_column_linktext=>'#FULL_NAME_EN#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4171002323848437)
,p_db_column_name=>'USER_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4171191703848438)
,p_db_column_name=>'PHOTO'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4171231637848439)
,p_db_column_name=>'EMAIL'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(4299155530416905)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'42992'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FULL_NAME_EN:USER_NAME:PHOTO:EMAIL'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3282027377870703)
,p_name=>'P5_SHOW'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3507411327078729)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3282236594870705)
,p_name=>'P5_SHOW_1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3282133053870704)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3285631122870739)
,p_name=>'P5_SHOW_1_1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3285505238870738)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3286082885870743)
,p_name=>'P5_SHOW_1_1_1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3285962566870742)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3286405198870747)
,p_name=>'P5_SHOW_1_1_1_1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3286305170870746)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3525652039131001)
,p_name=>'P5_SHOW_1_1_1_1_1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3286799235870750)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3526013569131005)
,p_name=>'P5_SHOW_1_1_1_1_1_1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3525911685131004)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.component_end;
end;
/
