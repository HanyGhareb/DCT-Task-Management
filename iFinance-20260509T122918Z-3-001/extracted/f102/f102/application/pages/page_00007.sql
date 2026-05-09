prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
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
 p_id=>7
,p_user_interface_id=>wwv_flow_api.id(3440093928015830)
,p_name=>'Organizations Managment'
,p_alias=>'ORGANIZATIONS-MANAGMENT'
,p_step_title=>'Organizations Managment'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230921062958'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7085245451633495)
,p_plug_name=>'Employees By Organization'
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
'    organizations_v;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Employees By Organization'
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
 p_id=>wwv_flow_api.id(7085360272633496)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_ORG_ID:#ORG_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>7085360272633496
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4559721948142569)
,p_db_column_name=>'ORG_ID'
,p_display_order=>10
,p_column_identifier=>'R'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4560115562142569)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>20
,p_column_identifier=>'S'
,p_column_label=>'Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4560530809142569)
,p_db_column_name=>'ORG_LEVEL'
,p_display_order=>30
,p_column_identifier=>'T'
,p_column_label=>'Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4560911356142570)
,p_db_column_name=>'PARENT_ORG'
,p_display_order=>40
,p_column_identifier=>'U'
,p_column_label=>'Parent Org'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4561313241142570)
,p_db_column_name=>'PARENT_ORG_NAME'
,p_display_order=>50
,p_column_identifier=>'V'
,p_column_label=>'Parent Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4561747595142570)
,p_db_column_name=>'PARENT_LEVEL'
,p_display_order=>60
,p_column_identifier=>'W'
,p_column_label=>'Parent Level'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4562104751142570)
,p_db_column_name=>'SHORT_NAME_EN'
,p_display_order=>70
,p_column_identifier=>'X'
,p_column_label=>'Short Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4562540574142571)
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
 p_id=>wwv_flow_api.id(4562956123142571)
,p_db_column_name=>'MANAGER_EMP_NUM'
,p_display_order=>90
,p_column_identifier=>'Z'
,p_column_label=>'Manager Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4563363117142571)
,p_db_column_name=>'MANAGER_NAME'
,p_display_order=>100
,p_column_identifier=>'AA'
,p_column_label=>'Manager'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4563746061142571)
,p_db_column_name=>'PARTNER_EMP_NUM'
,p_display_order=>110
,p_column_identifier=>'AB'
,p_column_label=>'Partner Emp Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4564124250142571)
,p_db_column_name=>'PARTNER_NAME'
,p_display_order=>120
,p_column_identifier=>'AC'
,p_column_label=>'Partner Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4564501423142572)
,p_db_column_name=>'FBP_ROLE_ID'
,p_display_order=>130
,p_column_identifier=>'AD'
,p_column_label=>'Fbp Role Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4564965852142572)
,p_db_column_name=>'FBP_ROLE_NAME'
,p_display_order=>140
,p_column_identifier=>'AE'
,p_column_label=>'Finance Business Partner Role '
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4565383322142572)
,p_db_column_name=>'ORG_RATE'
,p_display_order=>150
,p_column_identifier=>'AF'
,p_column_label=>'Org Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4565764427142572)
,p_db_column_name=>'SERVICE_PROVIDER'
,p_display_order=>160
,p_column_identifier=>'AG'
,p_column_label=>'Service Provider'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4566158547142573)
,p_db_column_name=>'ORG_PRIORITY'
,p_display_order=>170
,p_column_identifier=>'AH'
,p_column_label=>'Org Priority'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4566577192142573)
,p_db_column_name=>'START_DATE'
,p_display_order=>180
,p_column_identifier=>'AI'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4566936959142573)
,p_db_column_name=>'END_DATE'
,p_display_order=>190
,p_column_identifier=>'AJ'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4567360659142573)
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
 p_id=>wwv_flow_api.id(4567798551142574)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>210
,p_column_identifier=>'AL'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4568155683142574)
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
 p_id=>wwv_flow_api.id(4568545515142574)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>230
,p_column_identifier=>'AN'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4568923213142574)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>240
,p_column_identifier=>'AO'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4569348404142574)
,p_db_column_name=>'ORG_NAME_EN'
,p_display_order=>250
,p_column_identifier=>'AP'
,p_column_label=>'Org Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4569747209142575)
,p_db_column_name=>'ORG_NAME_AR'
,p_display_order=>260
,p_column_identifier=>'AQ'
,p_column_label=>'Org Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4570193329142575)
,p_db_column_name=>'PARENT_ORG_ID'
,p_display_order=>270
,p_column_identifier=>'AR'
,p_column_label=>'Parent Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4570590903142575)
,p_db_column_name=>'ORG_LEVEL_ID'
,p_display_order=>280
,p_column_identifier=>'AS'
,p_column_label=>'Org Level Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4570907254142575)
,p_db_column_name=>'ORG_LEVEL_NAME'
,p_display_order=>290
,p_column_identifier=>'AT'
,p_column_label=>'Org Level Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4571361747142576)
,p_db_column_name=>'DATE_FROM'
,p_display_order=>300
,p_column_identifier=>'AU'
,p_column_label=>'Date From'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4571797086142576)
,p_db_column_name=>'SHORT_NAME_AR'
,p_display_order=>310
,p_column_identifier=>'AV'
,p_column_label=>'Short Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4572186756142576)
,p_db_column_name=>'SOURCE'
,p_display_order=>320
,p_column_identifier=>'AW'
,p_column_label=>'Source'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4572594645142576)
,p_db_column_name=>'HR_STRUCTURE_ID'
,p_display_order=>330
,p_column_identifier=>'AX'
,p_column_label=>'Hr Structure Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4572971601142577)
,p_db_column_name=>'VERSION'
,p_display_order=>340
,p_column_identifier=>'AY'
,p_column_label=>'Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4573331538142577)
,p_db_column_name=>'ORG_NAME_AR_USER'
,p_display_order=>350
,p_column_identifier=>'AZ'
,p_column_label=>'Org Name Ar User'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4573748219142577)
,p_db_column_name=>'PARENT_ORG_ID_USER'
,p_display_order=>360
,p_column_identifier=>'BA'
,p_column_label=>'Parent Org Id User'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4574112735142577)
,p_db_column_name=>'ORG_NAME_EN_USER'
,p_display_order=>370
,p_column_identifier=>'BB'
,p_column_label=>'Org Name En User'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(7664887778692818)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'45745'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORG_ID:ORG_NAME:ORG_LEVEL:PARENT_ORG_NAME:PARENT_LEVEL:STATUS:MANAGER_NAME:FBP_ROLE_NAME:COST_CENTER_CODE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7651069799513775)
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
 p_id=>wwv_flow_api.id(7667670970788065)
,p_plug_name=>'Organizations Hierarchy'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select case when connect_by_isleaf = 1 then 0',
'            when level = 1             then 1',
'            else                           -1',
'       end as status, ',
'       level, ',
'       --"ORG_NAME_EN" as title,',
'       (select b.level_name from dct_hr_org_levels b where b.level_id =  ORG_LEVEL_ID) ',
'       || '': '' ',
'       || nvl(ORG_NAME_EN , org_name_en_user)  ',
'       || ''('' ',
'       || (select count(d.org_id) ',
'            from DCT_HR_ORGANIZATIONS d ',
'            where d.parent_org_id_user  = DCT_HR_ORGANIZATIONS.Org_id',
'            and d.status = ''A''',
'            and sysdate BETWEEN nvl(d.start_date,SYSDATE -120 ) and nvl(d.end_date, sysdate + 100)) ',
'       || '')'' || '' - Cost Center: '' || (select b.cost_center_code from dct_hr_organizations b where b.org_id = DCT_HR_ORGANIZATIONS.Org_id) as title,',
'    --   || '' - Employee Count: ('' || (select count( h.assignment_number) from dct_employees_list h where h.organization_en = DCT_HR_ORGANIZATIONS.Org_id ) || '')'' as title,',
'    -- Icon',
'        Case (select b.level_name from dct_hr_org_levels b where b.level_id =  ORG_LEVEL_ID) ',
'       --     when ''Sector'' Then ''fa-check''',
'            when ''Department'' Then ''fa-folder-open-o''',
'            when ''Section'' then ''fa-number-2-o''',
'            when ''Unit'' Then ''fa-number-1-o''',
'        End    ',
'        as icon, ',
'       ORG_ID as value, ',
'       ORG_NAME_EN as tooltip ',
'      ,''f?p=&APP_ID.:8:''||:APP_SESSION||''::::P8_ORG_ID,P8_FROM_PAGE:''||"ORG_ID" || '',7'' as link ',
'from (select * from DCT_HR_ORGANIZATIONS',
'where status = ''A'' and sysdate BETWEEN nvl(dct_hr_organizations.start_date,SYSDATE -120 ) and nvl(end_date, sysdate + 100)) DCT_HR_ORGANIZATIONS',
'start with "ORG_ID" in (select org_id  from dct_hr_organizations where org_level_id = 2)',
'connect by prior "ORG_ID" = "PARENT_ORG_ID_USER"',
'order siblings by org_priority , "ORG_NAME_EN";'))
,p_plug_source_type=>'NATIVE_JSTREE'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_02=>'D'
,p_attribute_04=>'DB'
,p_attribute_09=>'icon-tree-folder'
,p_attribute_10=>'TITLE'
,p_attribute_11=>'LEVEL'
,p_attribute_12=>'ICON'
,p_attribute_15=>'STATUS'
,p_attribute_20=>'VALUE'
,p_attribute_22=>'TOOLTIP'
,p_attribute_23=>'LEVEL'
,p_attribute_24=>'LINK'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7740374931108900)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4575265361142582)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(7667670970788065)
,p_button_name=>'EXPAND_ALL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_image_alt=>'Expand All'
,p_button_position=>'TOP_AND_BOTTOM'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4575646971142583)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(7667670970788065)
,p_button_name=>'Collapse_All'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_image_alt=>'Collapse All'
,p_button_position=>'TOP_AND_BOTTOM'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(21965036810318838)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(7667670970788065)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(3417666671015793)
,p_button_image_alt=>'New'
,p_button_position=>'TOP_AND_BOTTOM'
,p_button_redirect_url=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(4558785587142565)
,p_name=>'P7_VIEW_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(7740374931108900)
,p_item_default=>'H'
,p_prompt=>'View Organizations By'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Hierarchy;H,Tabular;T'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(3416586982015790)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4576620070142585)
,p_name=>'EXPAND_ALL'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(4575265361142582)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4577179018142585)
,p_event_id=>wwv_flow_api.id(4576620070142585)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_TREE_EXPAND'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(7667670970788065)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4577590018142586)
,p_name=>'CONTRACT_ALL'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(4575646971142583)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4578031059142586)
,p_event_id=>wwv_flow_api.id(4577590018142586)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_TREE_COLLAPSE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(7667670970788065)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4578423605142586)
,p_name=>'Show Hide Org Details'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P7_VIEW_BY'
,p_condition_element=>'P7_VIEW_BY'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'H'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4578903155142586)
,p_event_id=>wwv_flow_api.id(4578423605142586)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(7667670970788065)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4580486252142587)
,p_event_id=>wwv_flow_api.id(4578423605142586)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(7085245451633495)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4579494366142586)
,p_event_id=>wwv_flow_api.id(4578423605142586)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(7667670970788065)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4579906028142587)
,p_event_id=>wwv_flow_api.id(4578423605142586)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(7085245451633495)
);
wwv_flow_api.component_end;
end;
/
