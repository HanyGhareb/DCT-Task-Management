prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
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
 p_id=>10
,p_user_interface_id=>wwv_flow_api.id(3440093928015830)
,p_name=>'Organizations'
,p_alias=>'ORGANIZATIONS'
,p_step_title=>'Organizations'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230202054010'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7398436749487928)
,p_plug_name=>'Organizations'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3353501491015744)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    org_id,',
'    org_name,',
'    org_level,',
'    parent_org,',
'    parent_org_name,',
'    parent_level,',
'    short_name_en,',
'    status,',
'    manager_emp_num,',
'    manager_name,',
'    partner_emp_num,',
'    partner_name,',
'    fbp_role_id,',
'    fbp_role_name,',
'    org_rate,',
'    service_provider,',
'    org_priority,',
'    start_date,',
'    end_date,',
'    created_date,',
'    created_by,',
'    updated_date,',
'    updated_by,',
'    cost_center_code,',
'    org_name_en,',
'    org_name_ar,',
'    parent_org_id,',
'    org_level_id,',
'    org_level_name,',
'    date_from,',
'    short_name_ar,',
'    source,',
'    hr_structure_id,',
'    version,',
'    org_name_ar_user,',
'    parent_org_id_user,',
'    org_name_en_user',
'FROM',
'    organizations_v'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Organizations'
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
 p_id=>wwv_flow_api.id(7398551570487929)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ORG_ID,P11_PAGE_FROM:#ORG_ID#,10'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>7398551570487929
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4872936603996997)
,p_db_column_name=>'ORG_ID'
,p_display_order=>10
,p_column_identifier=>'R'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4873303748996998)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>20
,p_column_identifier=>'S'
,p_column_label=>'Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4873733823996998)
,p_db_column_name=>'ORG_LEVEL'
,p_display_order=>30
,p_column_identifier=>'T'
,p_column_label=>'Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4874147439996998)
,p_db_column_name=>'PARENT_ORG'
,p_display_order=>40
,p_column_identifier=>'U'
,p_column_label=>'Parent Org'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4874549268996999)
,p_db_column_name=>'PARENT_ORG_NAME'
,p_display_order=>50
,p_column_identifier=>'V'
,p_column_label=>'Parent Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4874935184996999)
,p_db_column_name=>'PARENT_LEVEL'
,p_display_order=>60
,p_column_identifier=>'W'
,p_column_label=>'Parent Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4875303400996999)
,p_db_column_name=>'SHORT_NAME_EN'
,p_display_order=>70
,p_column_identifier=>'X'
,p_column_label=>'Short Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4875730300996999)
,p_db_column_name=>'STATUS'
,p_display_order=>80
,p_column_identifier=>'Y'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(4580824401142588)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4876186683997000)
,p_db_column_name=>'MANAGER_EMP_NUM'
,p_display_order=>90
,p_column_identifier=>'Z'
,p_column_label=>'Manager Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4876593644997000)
,p_db_column_name=>'MANAGER_NAME'
,p_display_order=>100
,p_column_identifier=>'AA'
,p_column_label=>'Manager'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4876910968997000)
,p_db_column_name=>'PARTNER_EMP_NUM'
,p_display_order=>110
,p_column_identifier=>'AB'
,p_column_label=>'Partner Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4877338300997000)
,p_db_column_name=>'PARTNER_NAME'
,p_display_order=>120
,p_column_identifier=>'AC'
,p_column_label=>'Partner Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4877760283997001)
,p_db_column_name=>'FBP_ROLE_ID'
,p_display_order=>130
,p_column_identifier=>'AD'
,p_column_label=>'Fbp Role Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4878130885997001)
,p_db_column_name=>'FBP_ROLE_NAME'
,p_display_order=>140
,p_column_identifier=>'AE'
,p_column_label=>'Finance Business Partner Role '
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4878571108997001)
,p_db_column_name=>'ORG_RATE'
,p_display_order=>150
,p_column_identifier=>'AF'
,p_column_label=>'Org Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4878967553997001)
,p_db_column_name=>'SERVICE_PROVIDER'
,p_display_order=>160
,p_column_identifier=>'AG'
,p_column_label=>'Service Provider'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4879347161997002)
,p_db_column_name=>'ORG_PRIORITY'
,p_display_order=>170
,p_column_identifier=>'AH'
,p_column_label=>'Org Priority'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4879760160997002)
,p_db_column_name=>'START_DATE'
,p_display_order=>180
,p_column_identifier=>'AI'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4880105120997002)
,p_db_column_name=>'END_DATE'
,p_display_order=>190
,p_column_identifier=>'AJ'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4880577017997003)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>200
,p_column_identifier=>'AK'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4880938886997003)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>210
,p_column_identifier=>'AL'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4881303598997003)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>220
,p_column_identifier=>'AM'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4881780493997003)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>230
,p_column_identifier=>'AN'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4882145442997004)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>240
,p_column_identifier=>'AO'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4882534113997004)
,p_db_column_name=>'ORG_NAME_EN'
,p_display_order=>250
,p_column_identifier=>'AP'
,p_column_label=>'Org Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4882925536997004)
,p_db_column_name=>'ORG_NAME_AR'
,p_display_order=>260
,p_column_identifier=>'AQ'
,p_column_label=>'Org Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4883326881997004)
,p_db_column_name=>'PARENT_ORG_ID'
,p_display_order=>270
,p_column_identifier=>'AR'
,p_column_label=>'Parent Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4883744518997005)
,p_db_column_name=>'ORG_LEVEL_ID'
,p_display_order=>280
,p_column_identifier=>'AS'
,p_column_label=>'Org Level Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4884105191997005)
,p_db_column_name=>'ORG_LEVEL_NAME'
,p_display_order=>290
,p_column_identifier=>'AT'
,p_column_label=>'Org Level Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4884518077997005)
,p_db_column_name=>'DATE_FROM'
,p_display_order=>300
,p_column_identifier=>'AU'
,p_column_label=>'Date From'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4884983136997005)
,p_db_column_name=>'SHORT_NAME_AR'
,p_display_order=>310
,p_column_identifier=>'AV'
,p_column_label=>'Short Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4885320981997006)
,p_db_column_name=>'SOURCE'
,p_display_order=>320
,p_column_identifier=>'AW'
,p_column_label=>'Source'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4885745242997006)
,p_db_column_name=>'HR_STRUCTURE_ID'
,p_display_order=>330
,p_column_identifier=>'AX'
,p_column_label=>'Hr Structure Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4886150898997006)
,p_db_column_name=>'VERSION'
,p_display_order=>340
,p_column_identifier=>'AY'
,p_column_label=>'Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4886595160997006)
,p_db_column_name=>'ORG_NAME_AR_USER'
,p_display_order=>350
,p_column_identifier=>'AZ'
,p_column_label=>'Org Name Ar User'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4886913154997007)
,p_db_column_name=>'PARENT_ORG_ID_USER'
,p_display_order=>360
,p_column_identifier=>'BA'
,p_column_label=>'Parent Org Id User'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4887375725997007)
,p_db_column_name=>'ORG_NAME_EN_USER'
,p_display_order=>370
,p_column_identifier=>'BB'
,p_column_label=>'Org Name En User'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(7978079076547251)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'48877'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORG_ID:ORG_NAME:ORG_LEVEL:PARENT_ORG_NAME:PARENT_LEVEL:STATUS:MANAGER_NAME:FBP_ROLE_NAME:COST_CENTER_CODE:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(146235875992469043)
,p_report_id=>wwv_flow_api.id(7978079076547251)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'ORG_NAME'
,p_operator=>'contains'
,p_expr=>'Corporate Strategic Planning'
,p_condition_sql=>'upper("ORG_NAME") like ''%''||upper(#APXWS_EXPR#)||''%'''
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Corporate Strategic Planning''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7964261097368208)
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
 p_id=>wwv_flow_api.id(8053566228963333)
,p_plug_name=>'View Organizations By'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3328078855015727)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<h4>In this page, you can manage organizations managers, Finance Business Partners and update the organizations hierarchy which are missing in HR system. </h4>',
'<p style="color:red">Warning: all changes are tracked and recorded for auditing purposes.</p>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(9560771990294616)
,p_plug_name=>'Inactive Organizations'
,p_region_template_options=>'#DEFAULT#:t-Region--hideShowIconsMath:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(3338469521015735)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'ORGANIZATIONS_V'
,p_query_where=>'status != ''A'''
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Inactive Organizations'
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
 p_id=>wwv_flow_api.id(9613351844878308)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_ORG_ID,P11_PAGE_FROM:#ORG_ID#,10'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>9613351844878308
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4889507924997010)
,p_db_column_name=>'ORG_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4889918839997010)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4890389044997011)
,p_db_column_name=>'ORG_LEVEL'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Org Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4890787074997011)
,p_db_column_name=>'PARENT_ORG'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Parent Org'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4891130621997011)
,p_db_column_name=>'PARENT_ORG_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Parent Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4891558543997011)
,p_db_column_name=>'PARENT_LEVEL'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Parent Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4891903596997011)
,p_db_column_name=>'SHORT_NAME_EN'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Short Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4892344927997012)
,p_db_column_name=>'STATUS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4892748108997012)
,p_db_column_name=>'MANAGER_EMP_NUM'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Manager Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4893183332997012)
,p_db_column_name=>'MANAGER_NAME'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Manager Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4893531076997012)
,p_db_column_name=>'PARTNER_EMP_NUM'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Partner Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4893967242997012)
,p_db_column_name=>'PARTNER_NAME'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Partner Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4894313782997013)
,p_db_column_name=>'FBP_ROLE_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Fbp Role Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4894744011997013)
,p_db_column_name=>'FBP_ROLE_NAME'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Fbp Role Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4895182813997013)
,p_db_column_name=>'ORG_RATE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Org Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4895536207997013)
,p_db_column_name=>'SERVICE_PROVIDER'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Service Provider'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4895996917997014)
,p_db_column_name=>'ORG_PRIORITY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Org Priority'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4896364408997014)
,p_db_column_name=>'START_DATE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4896710870997014)
,p_db_column_name=>'END_DATE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4897131388997014)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4897518885997014)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4897938218997015)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4898371161997015)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4898720677997015)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4899113380997015)
,p_db_column_name=>'ORG_NAME_EN'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Org Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4899584031997015)
,p_db_column_name=>'ORG_NAME_AR'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Org Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4899920431997016)
,p_db_column_name=>'PARENT_ORG_ID'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Parent Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4900369893997016)
,p_db_column_name=>'ORG_LEVEL_ID'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Org Level Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4900777030997016)
,p_db_column_name=>'ORG_LEVEL_NAME'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Org Level Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4901120604997016)
,p_db_column_name=>'DATE_FROM'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Date From'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4901552607997017)
,p_db_column_name=>'SHORT_NAME_AR'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Short Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4901942221997017)
,p_db_column_name=>'SOURCE'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Source'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4902388803997017)
,p_db_column_name=>'HR_STRUCTURE_ID'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Hr Structure Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4902741209997017)
,p_db_column_name=>'VERSION'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4903133819997018)
,p_db_column_name=>'ORG_NAME_AR_USER'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Org Name Ar User'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4903551481997018)
,p_db_column_name=>'PARENT_ORG_ID_USER'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Parent Org Id User'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4903990474997018)
,p_db_column_name=>'ORG_NAME_EN_USER'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Org Name En User'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(9671069674892624)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'49043'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORG_NAME:ORG_LEVEL:PARENT_ORG:PARENT_ORG_NAME:PARENT_LEVEL:SHORT_NAME_EN:STATUS:'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4907518383997021)
,p_name=>'Show Hide Org Details'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_VIEW_BY'
,p_condition_element=>'P10_VIEW_BY'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'H'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4909576284997022)
,p_event_id=>wwv_flow_api.id(4907518383997021)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(7398436749487928)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4909046514997021)
,p_event_id=>wwv_flow_api.id(4907518383997021)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(7398436749487928)
);
wwv_flow_api.component_end;
end;
/
