prompt --application/pages/page_00008
begin
--   Manifest
--     PAGE: 00008
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>8
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'BTF End User Details'
,p_alias=>'BTF-END-USER-DETAILS'
,p_step_title=>'BTF End User Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231212083647'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(242587857418406)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99766883142410755)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(99703488427410717)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(99820961719410781)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(243265491418406)
,p_plug_name=>'Main Detail'
,p_icon_css_classes=>'fa-list-alt'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(243661473418407)
,p_plug_name=>'Header Details'
,p_parent_plug_id=>wwv_flow_api.id(243265491418406)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(251259769473824)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(243661473418407)
,p_region_template_options=>'#DEFAULT#:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(82902257689029199)
,p_plug_name=>'Strategic Initiatives'
,p_parent_plug_id=>wwv_flow_api.id(251259769473824)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    select distinct PROJECT_NUMBER, TASK_NUMBER, INITIATIVE_ID, START_DATE, END_DATE, STATUS, CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON',
'    from task_initiatives ',
'    where project_number in (select distinct l.PROJECT_NUMBER  ',
'                            from btf_end_users_lines l',
'                            where l.request_id = :P8_REQUEST_ID)',
'    and task_number in (    select distinct l.task_number  ',
'                            from btf_end_users_lines l',
'                            where l.request_id = :P8_REQUEST_ID)',
'          order by PROJECT_NUMBER , TASK_NUMBER;',
'                            '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P8_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Strategic Initiatives'
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
 p_id=>wwv_flow_api.id(82902150820029198)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>130381881569155434
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82901975950029196)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82901835032029195)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82901740012029194)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Initiative'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(916102580051005)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82901656977029193)
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
 p_id=>wwv_flow_api.id(82901550956029192)
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
 p_id=>wwv_flow_api.id(82901482775029191)
,p_db_column_name=>'STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(780300318120911)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82901418810029190)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82901246479029189)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82901150658029188)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(82901082084029187)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(81550009142908497)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1317341'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:TASK_NUMBER:INITIATIVE_ID:START_DATE:END_DATE:STATUS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(249214192473804)
,p_plug_name=>'Summary'
,p_parent_plug_id=>wwv_flow_api.id(243265491418406)
,p_icon_css_classes=>'fa-usd'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent1:t-Region--stacked:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(244066147418407)
,p_plug_name=>'Deduction Lines (From) '
,p_icon_css_classes=>'fa-minus-square-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent9:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P8_REQUEST_TYPE_H'
,p_plug_display_when_cond2=>'A'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(290389989931130)
,p_plug_name=>'Deduction Lines Report'
,p_parent_plug_id=>wwv_flow_api.id(244066147418407)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select LINE_ID,',
'       REQUEST_ID,',
'       LINE_NO,',
'       REQUIRED_DATE,',
'       JUSTIFICATION,',
'       FROM_TO,',
'       SECTOR_ID,',
'       DEPARTMENT_ID,',
'       PURPOSE_EU,',
'       PRIORITY,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       COST_CENTER,',
'       user_details.get_cost_center_name(COST_CENTER) Cost_Center_name,',
'       GL_ACCOUNT,',
'       BUDGET_GROUP_CODE,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2,',
'       BUDGET,',
'       ENCUMBRANCES,',
'       ACTUAL,',
'       REQUESTED_AMOUNT,',
'       FUND_AVAILABLE,',
'       PROJECTS_UTIL.EXPENDITURE_BALANCE(project_number,',
'                                                        task_number,',
'                                                        expenditure_type,',
'                                                        extract(year from sysdate),',
'                                                        ''F'') current_fund_available,',
'       CF_LINE_ID,',
'       BTF_REQUEST_ID,',
'       CREATED_BY_PERSON_ID,',
'       UPDATED_BY_PERSON_ID,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       case when :P8_REQUEST_STATUS = ''Approved'' and ',
'                 :P8_EXECUTED_YN    = ''N''       and',
'                 BTF_EU_UTIL.btf_current_fund_line(LINE_ID) = ''Y''',
'            then',
'                ''<span class="fa fa-check-circle" style="color:green"></span>''',
'            else',
'                ''<span aria-hidden="true" class="fa fa-exclamation-triangle-o fa-anim-flash fam-x fam-is-danger"></span>''',
'        end current_fund',
'            ',
'  from BTF_END_USERS_LINES',
' where request_id = :P8_REQUEST_ID and from_to = ''FROM''',
' order by LINE_NO'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P8_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Deduction Lines Report'
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
 p_id=>wwv_flow_api.id(290557999931131)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No deduction lines.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.::P9_PAGE_FROM,P9_LINE_ID,P9_FROM_TO,P9_REQUEST_STATUS,P9_REQUEST_TYPE:8,#LINE_ID#,FROM,&P8_REQUEST_STATUS.,&P8_REQUEST_TYPE.'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P8_REQUEST_STATUS in (''Draft'' , ''Stop'' , ''Withdraw'' , ''Return'')'
,p_owner=>'TCA9051'
,p_internal_uid=>105646887191294544
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(290630908931132)
,p_db_column_name=>'LINE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(290696574931133)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(290796817931134)
,p_db_column_name=>'LINE_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(290931251931135)
,p_db_column_name=>'REQUIRED_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Required Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(290999844931136)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(291149505931137)
,p_db_column_name=>'FROM_TO'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'From To'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(329055680350388)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(329076682350389)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Department Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(329238712350390)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Purpose Eu'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(329367021350391)
,p_db_column_name=>'PRIORITY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(329401954350392)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Project '
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(329481721350393)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(329572985350394)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(329688795350395)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(329847674350396)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(329923003350397)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(330023526350398)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(330072498350399)
,p_db_column_name=>'FUTURE1'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(330267239350400)
,p_db_column_name=>'FUTURE2'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(330331773350401)
,p_db_column_name=>'BUDGET'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(330389530350402)
,p_db_column_name=>'ENCUMBRANCES'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Encumbrances'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(330486269350403)
,p_db_column_name=>'ACTUAL'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(330644390350404)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(330676892350405)
,p_db_column_name=>'FUND_AVAILABLE'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Fund'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(330823358350406)
,p_db_column_name=>'CF_LINE_ID'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Cf Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(330899586350407)
,p_db_column_name=>'BTF_REQUEST_ID'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Btf Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(331029122350408)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(331117045350409)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Updated By '
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(331256513350410)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(331333294350411)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(101260893712951304)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1363907513464829)
,p_db_column_name=>'CURRENT_FUND'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Current Fund'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P8_REQUEST_STATUS = ''Approved'' and :P8_EXECUTED_YN = ''N'''
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1363773323464828)
,p_db_column_name=>'CURRENT_FUND_AVAILABLE'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Current Fund Available'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P8_REQUEST_STATUS = ''Approved'' and :P8_EXECUTED_YN = ''N'''
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(343592027357709)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1057000'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'LINE_NO:JUSTIFICATION:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:COST_CENTER:COST_CENTER_NAME:GL_ACCOUNT:FUTURE2:BUDGET:ENCUMBRANCES:ACTUAL:FUND_AVAILABLE:REQUESTED_AMOUNT::CURRENT_FUND:CURRENT_FUND_AVAILABLE'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(100895899830101358)
,p_report_id=>wwv_flow_api.id(343592027357709)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUESTED_AMOUNT'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>' (case when ("REQUESTED_AMOUNT" > to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFD6D2'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(244444440418407)
,p_plug_name=>'Addition Lines (To) '
,p_icon_css_classes=>'fa-clipboard-plus'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent5:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P8_REQUEST_TYPE_H'
,p_plug_display_when_cond2=>'R'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(331381158350412)
,p_plug_name=>'Addition Lines  Report'
,p_parent_plug_id=>wwv_flow_api.id(244444440418407)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select LINE_ID,',
'       REQUEST_ID,',
'       LINE_NO,',
'       REQUIRED_DATE,',
'       JUSTIFICATION,',
'       FROM_TO,',
'       SECTOR_ID,',
'       DEPARTMENT_ID,',
'       PURPOSE_EU,',
'       PRIORITY,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       COST_CENTER,',
'       user_details.get_cost_center_name(COST_CENTER) Cost_Center_name,',
'       GL_ACCOUNT,',
'       BUDGET_GROUP_CODE,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2,',
'       BUDGET,',
'       ENCUMBRANCES,',
'       ACTUAL,',
'       REQUESTED_AMOUNT,',
'       FUND_AVAILABLE,',
'       CF_LINE_ID,',
'       BTF_REQUEST_ID,',
'       CREATED_BY_PERSON_ID,',
'       UPDATED_BY_PERSON_ID,',
'       CREATION_DATE,',
'       UPDATED_DATE',
'  from BTF_END_USERS_LINES',
' where request_id = :P8_REQUEST_ID and from_to = ''TO''',
' order by LINE_NO'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P8_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Addition Lines  Report'
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
 p_id=>wwv_flow_api.id(331521678350413)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No addition lines'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.::P9_PAGE_FROM,P9_LINE_ID:8,#LINE_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P8_REQUEST_STATUS in (''Draft'' , ''Stop'' , ''Withdraw'' , ''Return'')'
,p_owner=>'TCA9051'
,p_internal_uid=>105687850869713826
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(331581668350414)
,p_db_column_name=>'LINE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(331718192350415)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(331783224350416)
,p_db_column_name=>'LINE_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(331888797350417)
,p_db_column_name=>'REQUIRED_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Required Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(331981339350418)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(332096475350419)
,p_db_column_name=>'FROM_TO'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'From To'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(332253083350420)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(332297765350421)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Department Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(332423909350422)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Purpose Eu'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(332539706350423)
,p_db_column_name=>'PRIORITY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(332645233350424)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(332755794350425)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(332794156350426)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(332958336350427)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(332993582350428)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(333080852350429)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(333254564350430)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(333349822350431)
,p_db_column_name=>'FUTURE1'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(333390118350432)
,p_db_column_name=>'FUTURE2'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(333472013350433)
,p_db_column_name=>'BUDGET'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(333580491350434)
,p_db_column_name=>'ENCUMBRANCES'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Encumbrances'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(333724308350435)
,p_db_column_name=>'ACTUAL'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(333855525350436)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(333954633350437)
,p_db_column_name=>'FUND_AVAILABLE'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Fund Available'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(348837479380088)
,p_db_column_name=>'CF_LINE_ID'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Cf Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(348870996380089)
,p_db_column_name=>'BTF_REQUEST_ID'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Btf Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(348975455380090)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(349132014380091)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(349254366380092)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(349316087380093)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(101260735324951303)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(363331582383601)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1057197'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'LINE_NO:JUSTIFICATION:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:COST_CENTER:COST_CENTER_NAME:GL_ACCOUNT:FUTURE2:BUDGET:ENCUMBRANCES:ACTUAL:FUND_AVAILABLE:REQUESTED_AMOUNT:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(100895263880103205)
,p_report_id=>wwv_flow_api.id(363331582383601)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUESTED_AMOUNT'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("REQUESTED_AMOUNT" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#D0F1CC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(244793189418407)
,p_plug_name=>'Documents'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(351173585380112)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(244793189418407)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
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
'  from btf_end_users_req_documents',
'  where REQUEST_ID = :P8_REQUEST_ID',
'  order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P8_REQUEST_ID'
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
 p_id=>wwv_flow_api.id(351353592380113)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No documents available'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>105707682783743526
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(351456933380114)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(351519391380115)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(351593718380116)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(351729435380117)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::P10_PAGE_FROM,P10_STATUS,P10_ID:8,&P8_REQUEST_STATUS.,#ID#'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(351775712380118)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(351927952380119)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(352019437380120)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(352131184380121)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(352231692380122)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(352328754380123)
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
 p_id=>wwv_flow_api.id(352469687380124)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(352544206380125)
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
 p_id=>wwv_flow_api.id(352619509380126)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(352700545380127)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(352817257380128)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:BTF_END_USERS_REQ_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(437583468838603)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1057940'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY_PERSON_ID:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(252550907473837)
,p_plug_name=>'Approval History'
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent13:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P8_REQUEST_STATUS'
,p_plug_display_when_cond2=>'Draft'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(349473349380095)
,p_plug_name=>'Approval History Report'
,p_parent_plug_id=>wwv_flow_api.id(252550907473837)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    h.id,',
'    h.request_id,',
'    h.step_no,',
'    h.person_id,',
'    h.role_id,',
'    h.role_desc,',
'    h.action_required,',
'    h.recevied_date,',
'    h.status,',
'    h.action_date,',
'    h.comments,',
'    h.approval_type,',
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
'FROM',
'    btf_end_users_req_approval_history h, dct_employees_list2  e',
'where h.person_id = e.person_id (+)',
'and h.request_id = :P8_REQUEST_ID',
'and h.status != ''Bateen''',
'order by h.STEP_NO ',
'--, h.ID',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P8_REQUEST_NO'
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
 p_id=>wwv_flow_api.id(349594734380096)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>105705923925743509
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(349747720380097)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(349815563380098)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(349882882380099)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(350057055380100)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(350114971380101)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(581737489704835)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(350211804380102)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(350288262380103)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(350428449380104)
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
 p_id=>wwv_flow_api.id(350500698380105)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(350630123380106)
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
 p_id=>wwv_flow_api.id(350728595380107)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(350846241380108)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(350907298380109)
,p_db_column_name=>'STATUS_CLASS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(351045051380110)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(351133564380111)
,p_db_column_name=>'PHOTO'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(410250136758587)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1057666'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ROLE_ID:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'ID'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(1696078444619858)
,p_report_id=>wwv_flow_api.id(410250136758587)
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
 p_id=>wwv_flow_api.id(97676988943767314)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(242587857418406)
,p_button_name=>'upload'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--link:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Upload'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'PERSON_ID'
,p_button_condition2=>'680461'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-upload'
,p_button_comment=>'to be display when status in draft, Withdraw'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(252284767473835)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(244066147418407)
,p_button_name=>'New_from_line'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'New Deduction Line'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:9:P9_PAGE_FROM,P9_FROM_TO,P9_REQUEST_ID,P9_REQUEST_STATUS,P9_REQUEST_TYPE:8,FROM,&P8_REQUEST_ID.,&P8_REQUEST_STATUS.,&P8_REQUEST_TYPE.'
,p_button_condition=>':P8_REQUEST_STATUS in (''Draft'' , ''Stop'' , ''Withdraw'' , ''Return'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(252456592473836)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(244444440418407)
,p_button_name=>'New_to_line'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'New Addition Line'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:9:P9_FROM_TO,P9_PAGE_FROM,P9_REQUEST_ID,P9_REQUEST_STATUS,P9_REQUEST_TYPE:TO,8,&P8_REQUEST_ID.,&P8_REQUEST_STATUS.,&P8_REQUEST_TYPE.'
,p_button_condition=>':P8_REQUEST_STATUS in (''Draft'' , ''Stop'' , ''Withdraw'' , ''Return'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(286199499931088)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(244793189418407)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:10:P10_REQUEST_ID,P10_PAGE_FROM,P10_STATUS:&P8_REQUEST_ID.,8,&P8_REQUEST_STATUS.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(97676843055767313)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(242587857418406)
,p_button_name=>'download'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--link:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Download'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'PERSON_ID'
,p_button_condition2=>'680461'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-download'
,p_button_comment=>'to be display when status in draft, Withdraw'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(89269266822936)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(242587857418406)
,p_button_name=>'Delete'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':P8_REQUEST_ID is not null and :P8_REQUEST_STATUS = ''Draft'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(248274864473795)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(242587857418406)
,p_button_name=>'Rollback'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Rollback'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':PERSON_ID = 680461'
,p_button_condition_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(249041705473802)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(242587857418406)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P8_REQUEST_ID is not null and :P8_REQUEST_STATUS in (''Draft'',''Withdraw'' , ''Return'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(249155908473803)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(242587857418406)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:&P8_PAGE_FROM.:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(668111184550298)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(242587857418406)
,p_button_name=>'Cancel'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13:P13_REQUEST_ID,P13_ACTION:&P8_REQUEST_ID.,CANCEL'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(:P8_CREATED_BY_PERSON_ID = :PERSON_ID or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_IFINANCE_ADMIN = ''Y'' or',
':IS_FBP_EMP = ''Y'')',
'and (:P8_REQUEST_STATUS not in (''Draft'' , ''Cancel'' , ''Rejected''))',
'and :P8_EXECUTED_YN = ''N'''))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(668705298550304)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(242587857418406)
,p_button_name=>'Withdraw'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13:P13_REQUEST_ID,P13_ACTION:&P8_REQUEST_ID.,Withdraw'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(:P8_CREATED_BY_PERSON_ID = :PERSON_ID or :IS_FBP_EMP = ''Y'' )',
'and (:P8_REQUEST_STATUS not in (''Cancel'', ''Withdraw'' , ''Draft'' , ''Approved''))'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1359400299464784)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_api.id(242587857418406)
,p_button_name=>'Return'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--warning:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13:P13_ACTION,P13_REQUEST_ID:ReturnAfter,&P8_REQUEST_ID.'
,p_button_condition=>':P8_REQUEST_STATUS = ''Approved'' and :P8_EXECUTED_YN = ''N'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1929001344365516)
,p_button_sequence=>100
,p_button_plug_id=>wwv_flow_api.id(242587857418406)
,p_button_name=>'Print'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Print'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-print'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(251337805473825)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(243265491418406)
,p_button_name=>'edit_header'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link'
,p_button_template_id=>wwv_flow_api.id(99818871196410779)
,p_button_image_alt=>'Edit Header'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.::P7_REQUEST_ID:&P8_REQUEST_ID.'
,p_button_condition=>':P8_REQUEST_STATUS in (''Draft'' , ''Stop'' , ''Withdraw'' , ''Return'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-pencil'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(452556806133421)
,p_branch_name=>'Go to 11'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_REQUEST_ID,P11_REQUEST_NO,P11_VALID,P11_DIFF,P11_REQUEST_TYPE,LS_STRATEGIC_PROJECT:&P8_REQUEST_ID.,&P8_REQUEST_NO.,&P8_VALIDE.,&P8_DIFF.,&P8_REQUEST_TYPE_H.,&P8_STRATEGIC_YN.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(249041705473802)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(248205840473794)
,p_branch_name=>'Go To  PAGE_FROM'
,p_branch_action=>'f?p=&APP_ID.:&PAGE_FROM.:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(105998064931455697)
,p_name=>'P8_CANCELLED_BY'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(249214192473804)
,p_prompt=>'Cancel By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>3
,p_display_when=>'P8_REQUEST_STATUS'
,p_display_when2=>'Cancel'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(105997942785455696)
,p_name=>'P8_CANCEL_REASON'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(249214192473804)
,p_prompt=>'Cancel Reason'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_display_when=>'P8_REQUEST_STATUS'
,p_display_when2=>'Cancel'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(105997885442455695)
,p_name=>'P8_CANCEL_ON'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(249214192473804)
,p_prompt=>'Cancel On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_display_when=>'P8_REQUEST_STATUS'
,p_display_when2=>'Cancel'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(82902434217029201)
,p_name=>'P8_EXECUTED_YN'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(242587857418406)
,p_display_as=>'NATIVE_HIDDEN'
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
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24019712815356896)
,p_name=>'P8_APPROVAL_CASE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(249214192473804)
,p_prompt=>'Approval Case'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'APPROVAL CASES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = (',
'            SELECT',
'                l.lookup_id',
'            FROM',
'                dct_lookups l',
'            WHERE',
'                l.lookup_code = ''APPROVAL_CASES''',
'        )',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_grid_label_column_span=>3
,p_display_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(:IS_IFINANCE_ADMIN = ''Y'' or ',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_FBP_EMP = ''Y'') and :P8_APPROVAL_CASE_ID is not null'))
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89079283822935)
,p_name=>'P8_REQUEST_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(242587857418406)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(89311431822937)
,p_name=>'P8_PAGE_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(242587857418406)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(249344732473805)
,p_name=>'P8_REQUEST_NO'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(243661473418407)
,p_prompt=>'Request No'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(249411999473806)
,p_name=>'P8_REQUEST_DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(243661473418407)
,p_prompt=>'Request Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(249522568473807)
,p_name=>'P8_REQUIRED_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(243661473418407)
,p_prompt=>'Due Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(249734885473809)
,p_name=>'P8_REQUEST_STATUS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(243661473418407)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(249776299473810)
,p_name=>'P8_JUSTIFICATION'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(243661473418407)
,p_prompt=>'Justification'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(249911969473811)
,p_name=>'P8_PRIORITY'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(243661473418407)
,p_prompt=>'Priority'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'PRIORITY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from dct_lookup_values',
'where lookup_id = (Select x.lookup_id',
'                    from dct_lookups x',
'                    where x.LOOKUP_CODE = ''PRIORITY'');'))
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(250036466473812)
,p_name=>'P8_REQUEST_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(243661473418407)
,p_prompt=>'Request Type'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EU REQUEST TYPES'
,p_lov=>'.'||wwv_flow_api.id(203139147648731)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(250155508473813)
,p_name=>'P8_SUBMITTED_ON'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(249214192473804)
,p_prompt=>'Submitted On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_display_when=>'P8_REQUEST_STATUS'
,p_display_when2=>'Draft'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(250256138473814)
,p_name=>'P8_SUBMITTED_BY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(249214192473804)
,p_prompt=>'Submitted By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>3
,p_display_when=>'P8_REQUEST_STATUS'
,p_display_when2=>'Draft'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(250345712473815)
,p_name=>'P8_FINAL_APPROVE_ON'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(249214192473804)
,p_prompt=>'Final Approved On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_display_when=>'P8_REQUEST_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(250379935473816)
,p_name=>'P8_CREATED_BY_PERSON_ID'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(251259769473824)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(250506394473817)
,p_name=>'P8_UPDATED_BY_PERSON_ID'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(251259769473824)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(250600292473818)
,p_name=>'P8_CREATION_DATE'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(251259769473824)
,p_prompt=>'Creation Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(250671360473819)
,p_name=>'P8_UPDATED_DATE'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(251259769473824)
,p_prompt=>'Last Update On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(250796311473820)
,p_name=>'P8_SPM_PROJECT_NAME'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(243661473418407)
,p_prompt=>'Strategic Project Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P8_REQUEST_TYPE'
,p_display_when2=>'C'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(250887142473821)
,p_name=>'P8_YEAR'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(242587857418406)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(251014230473822)
,p_name=>'P8_SEQ'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(242587857418406)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(353100848380131)
,p_name=>'P8_TOTAL_DEDUCTION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(249214192473804)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Deduction'
,p_post_element_text=>'&nbsp; <b style="color:red;">AED</b>'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  to_char(nvl(sum(btf_lines.requested_amount),0),''99,999,999.99'')',
' from btf_end_users_lines BTF_LINES',
'where btf_lines.request_id = :P8_REQUEST_ID',
'and from_to = ''FROM'''))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_display_when=>'P8_REQUEST_TYPE_H'
,p_display_when2=>'A'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(353202471380132)
,p_name=>'P8_TOTAL_ADDITION'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(249214192473804)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Addition'
,p_post_element_text=>'&nbsp; <b style="color:green;">AED</b>'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  trim(to_char(nvl(sum(btf_lines.requested_amount),0),''99,999,999.99''))',
' from btf_end_users_lines BTF_LINES',
'where btf_lines.request_id = :P8_REQUEST_ID',
'and from_to = ''TO'''))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_display_when=>'P8_REQUEST_TYPE_H'
,p_display_when2=>'R'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(353277548380133)
,p_name=>'P8_DIFF'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(249214192473804)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Difference'
,p_post_element_text=>'&nbsp; <b style="color:green;">AED</b>'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Declare',
'l_from    number;',
'l_to      number;',
'begin',
'',
'select  nvl(sum(BTF_LINES.requested_amount),0)',
'into l_from',
' from btf_end_users_lines BTF_LINES',
'where request_id = :P8_REQUEST_ID',
'and from_to = ''FROM'';',
'',
'select  nvl(sum(BTF_LINES.requested_amount),0)',
'into l_to',
' from btf_end_users_lines BTF_LINES',
'where request_id = :P8_REQUEST_ID',
'and from_to = ''TO'';',
'',
'return trim(to_char(l_from - l_to,''99,999,999,999.99''));',
'end;'))
,p_source_type=>'FUNCTION_BODY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_display_when=>':P8_REQUEST_TYPE_H not in (''A'' ,''R'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(668993860550307)
,p_name=>'P8_REJECTED_BY'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(249214192473804)
,p_prompt=>'Rejected By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_grid_label_column_span=>3
,p_display_when=>'P8_REQUEST_STATUS'
,p_display_when2=>'Rejected'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(669164979550308)
,p_name=>'P8_REJECT_REASON'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(249214192473804)
,p_prompt=>'Reason'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_display_when=>'P8_REQUEST_STATUS'
,p_display_when2=>'Rejected'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(669174588550309)
,p_name=>'P8_FINAL_REJECT_ON'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(249214192473804)
,p_prompt=>'Rejected On'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>3
,p_display_when=>'P8_REQUEST_STATUS'
,p_display_when2=>'Rejected'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(852011252863117)
,p_name=>'REQUEST_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(242587857418406)
,p_source=>'P8_REQUEST_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(852358473863120)
,p_name=>'P8_REQUEST_TYPE_H'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(243661473418407)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(852422547863121)
,p_name=>'P8_STRATEGIC_YN'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(243661473418407)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1348835989912391)
,p_name=>'P8_VALIDE'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(243661473418407)
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_doc_count    Number;',
'l_from         Number;  ',
'l_to           Number; ',
'begin',
'--1 check doc required',
'if BTF_EU_UTIL.attach_req_by_type(:P8_REQUEST_TYPE_H )',
'Then',
'        select nvl(count(*),0)',
'        into l_doc_count',
'        from btf_end_users_req_documents',
'        where request_id = :P8_REQUEST_ID;',
'else',
'    l_doc_count := 1;',
'End if;',
'--2 check from Amount',
'select  nvl(sum(btf_lines.requested_amount),0)',
'into l_from',
' from btf_end_users_lines BTF_LINES',
'where btf_lines.request_id = :P8_REQUEST_ID',
'and from_to = ''FROM'';',
'--3 check To Amount',
'select nvl(sum(btf_lines.requested_amount),0)',
'into l_to',
' from btf_end_users_lines BTF_LINES',
'where btf_lines.request_id = :P8_REQUEST_ID',
'and from_to = ''TO'';',
'',
'--4',
'Case :P8_REQUEST_TYPE_H  ',
'When ''S''  Then',
'     ',
'     if (--l_doc_count = 0 ',
'         --or :P8_STRATEGIC_YN = ''Y'' ',
'          l_from != l_to  ',
'         OR l_from = 0',
'         OR l_to = 0',
'         OR BTF_EU_UTIL.single_chapter_yn(:P8_REQUEST_ID) = ''N'') ',
'        Then',
'            return ''N'';',
'        else',
'            return ''Y'';',
'     End IF;',
'     ',
'when ''C''  Then ',
'    if (l_doc_count = 0 ',
'        --or :P8_STRATEGIC_YN = ''N'' ',
'        OR l_from != l_to OR BTF_EU_UTIL.single_chapter_yn(:P8_REQUEST_ID) = ''N''',
'        OR l_from = 0',
'         OR l_to = 0) ',
'        Then',
'            return ''N'';',
'        else',
'            return ''Y'';',
'     End IF;',
'',
'when ''A'' Then ',
'    if l_doc_count = 0  ',
'        OR l_to = 0 ',
'        OR BTF_EU_UTIL.single_chapter_yn(:P8_REQUEST_ID) = ''N''',
'        Then',
'            return ''N'';',
'        else',
'            return ''Y'';',
'     End IF;',
'     ',
'When ''R'' Then ',
'    if l_doc_count = 0  OR l_from = 0 OR BTF_EU_UTIL.single_chapter_yn(:P8_REQUEST_ID) = ''N''',
'        Then',
'            return ''N'';',
'        else',
'            return ''Y'';',
'     End IF;',
'     ',
'When ''X'' Then ',
'            return ''Y'';     ',
'',
'End Case;',
'     ',
'end;'))
,p_source_type=>'FUNCTION_BODY'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(247604277473788)
,p_name=>'Delete DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(89269266822936)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(247722720473789)
,p_event_id=>wwv_flow_api.id(247604277473788)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to delete this request? '
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(247840997473790)
,p_event_id=>wwv_flow_api.id(247604277473788)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'delete from btf_end_users_header where REQUEST_ID = :P8_REQUEST_ID;'
,p_attribute_02=>'P8_REQUEST_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(247957708473791)
,p_event_id=>wwv_flow_api.id(247604277473788)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_PAGE_FROM'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'6'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(248012216473792)
,p_event_id=>wwv_flow_api.id(247604277473788)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Deleted'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(248096439473793)
,p_event_id=>wwv_flow_api.id(247604277473788)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(248428774473796)
,p_name=>'Rollback DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(248274864473795)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(248533102473797)
,p_event_id=>wwv_flow_api.id(248428774473796)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to rollback?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(248621693473798)
,p_event_id=>wwv_flow_api.id(248428774473796)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete from BTF_END_USERS_REQ_APPROVAL_HISTORY where REQUEST_ID = :P8_REQUEST_ID;',
'update BTF_END_USERS_HEADER set REQUEST_STATUS = ''Draft'' where REQUEST_ID = :P8_REQUEST_ID;'))
,p_attribute_02=>'P8_REQUEST_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(248754524473799)
,p_event_id=>wwv_flow_api.id(248428774473796)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Rollback Done;'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(248956244473801)
,p_event_id=>wwv_flow_api.id(248428774473796)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_PAGE_FROM'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'6'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(248828078473800)
,p_event_id=>wwv_flow_api.id(248428774473796)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1929113626365517)
,p_name=>'Print DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(1929001344365516)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1929238075365518)
,p_event_id=>wwv_flow_api.id(1929113626365517)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'javaScript:window.open(''f?p=&APP_ID.:0:&SESSION.:PRINT_REPORT=BTF_END_USER_QUERY'', ''_blank'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(97676781924767312)
,p_name=>'Download DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(97676843055767313)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(97676650986767311)
,p_event_id=>wwv_flow_api.id(97676781924767312)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'javaScript:window.open(''f?p=&APP_ID.:0:&SESSION.:PRINT_REPORT=upload_btf_lines_query'', ''_blank'')'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(251123313473823)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize BTF  End User details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    request_id,',
'    request_no,',
'    to_char(request_date,''DD-MON-YYYY'') request_date,',
'    to_char(required_date,''DD-MON-YYYY'') required_date,',
'    request_status,',
'    justification,',
'    year,',
'    priority,',
'    to_char(submitted_on,''DD-MON-YYYY HH:MIPM'')    submitted_on,       ',
'    submitted_by,',
'    seq,',
'    to_char(final_approve_on,''DD-MON-YYYY HH:MIPM'') final_approve_on,',
'    created_by_person_id,',
'    updated_by_person_id,',
'    to_char(creation_date,''DD-MON-YYYY HH:MIPM'')    creation_date,',
'    to_char(updated_date,''DD-MON-YYYY HH:MIPM'')    updated_date,',
'    spm_project_name,',
'--    spm_project_id,',
'    request_type,',
'    request_type request_type_h,',
'    REJECT_REASON,',
'    REJECTED_BY,',
'    to_char(FINAL_REJECT_ON,''DD-MON-YYYY HH:MIPM'')     FINAL_REJECT_ON,',
'    STRATEGIC_YN,',
'    CANCELLED_BY,',
'    CANCEL_REASON,',
'    to_char(CANCEL_ON , ''dd-Mon-yyyy HH:MM:SS AM'')  CANCEL_ON,',
'    NVL(EXECUTED_YN,''N''),',
'    APPROVAL_CASE_ID',
'INTO',
'    :P8_REQUEST_ID,',
'    :P8_REQUEST_NO,',
'    :P8_REQUEST_DATE,',
'    :P8_REQUIRED_DATE,',
'    :P8_REQUEST_STATUS,',
'    :P8_JUSTIFICATION,',
'    :P8_YEAR,',
'    :P8_PRIORITY,',
'    :P8_SUBMITTED_ON,',
'    :P8_SUBMITTED_BY,',
'    :P8_SEQ,',
'    :P8_FINAL_APPROVE_ON,',
'    :P8_CREATED_BY_PERSON_ID,',
'    :P8_UPDATED_BY_PERSON_ID,',
'    :P8_CREATION_DATE,',
'    :P8_UPDATED_DATE,',
'    :P8_SPM_PROJECT_NAME,',
'    :P8_REQUEST_TYPE,',
'    :P8_REQUEST_TYPE_H,',
'    :P8_REJECT_REASON,',
'    :P8_REJECTED_BY,',
'    :P8_FINAL_REJECT_ON,',
'    :P8_STRATEGIC_YN,',
'    :P8_CANCELLED_BY,',
'    :P8_CANCEL_REASON,',
'    :P8_CANCEL_ON,',
'    :P8_EXECUTED_YN,',
'    :P8_APPROVAL_CASE_ID',
'FROM',
'    btf_end_users_header',
'WHERE request_id = nvl(:P8_REQUEST_ID  , (SELECT last_number',
'                                          FROM all_sequences',
'                                         WHERE sequence_owner = ''PROD''',
'                                           AND sequence_name = ''BTF_END_USERS_REQ_SEQ'')',
'                        );',
'exception',
'    when others then null;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
