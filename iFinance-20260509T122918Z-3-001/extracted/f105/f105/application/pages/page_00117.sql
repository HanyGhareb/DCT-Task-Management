prompt --application/pages/page_00117
begin
--   Manifest
--     PAGE: 00117
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
 p_id=>117
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Proposal Plan Documents '
,p_alias=>'BUDGET-PROPOSAL-PLAN-DOCUMENTS'
,p_step_title=>'Budget Proposal Plan Documents '
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230615114715'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(37680070501248285)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99766883142410755)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(99703488427410717)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(99820961719410781)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(37679451070248285)
,p_plug_name=>'Budget Proposal Plan Documents  Report'
,p_icon_css_classes=>'fa-file-arrow-down'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent13:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       PLAN_ID,',
'       SECTOR_ID,',
'       COST_CENTER,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       TAGS,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY,',
'       COMMENT_ID,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'        sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from BUDGET_PROPOSAL_PLANS_DOCUMENTS',
'  where plan_id = :P117_BUDGET_PROPOSAL_PLAN'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P117_BUDGET_PROPOSAL_PLAN'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Budget Proposal Plan Documents  Report'
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
 p_id=>wwv_flow_api.id(37679380602248285)
,p_name=>'Budget Proposal Plan Documents '
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>175604651786936347
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37678976446248281)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37678558890248281)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37678156177248280)
,p_db_column_name=>'PLAN_ID'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Plan Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(49565096744743668)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37677776294248280)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37677360082248280)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Cost Center'
,p_column_link=>'f?p=&APP_ID.:117:&SESSION.:APPLICATION_PROCESS=download_cost_center_documents:&DEBUG.::P117_CC_CODE_D:#COST_CENTER#'
,p_column_linktext=>'#COST_CENTER#'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37676939404248280)
,p_db_column_name=>'FILENAME'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'File Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37676544378248280)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37676186835248278)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37675802449248278)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>10
,p_column_identifier=>'I'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37675345590248277)
,p_db_column_name=>'TAGS'
,p_display_order=>11
,p_column_identifier=>'J'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37674942304248277)
,p_db_column_name=>'CREATED'
,p_display_order=>12
,p_column_identifier=>'K'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37674607596248277)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>13
,p_column_identifier=>'L'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37674230186248277)
,p_db_column_name=>'UPDATED'
,p_display_order=>14
,p_column_identifier=>'M'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37673814154248276)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>15
,p_column_identifier=>'N'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37673394143248276)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>16
,p_column_identifier=>'O'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37673015992248276)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>17
,p_column_identifier=>'P'
,p_column_label=>'Project Number'
,p_column_link=>'f?p=&APP_ID.:117:&SESSION.:APPLICATION_PROCESS=DOWNLOAD_ATTACHMENTS:&DEBUG.::P117_PROJECT_D:#PROJECT_NUMBER#'
,p_column_linktext=>'#PROJECT_NUMBER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(37672587558248276)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>18
,p_column_identifier=>'Q'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38090251685487405)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>28
,p_column_identifier=>'R'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38089885394487401)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>38
,p_column_identifier=>'S'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(38089753843487400)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>48
,p_column_identifier=>'T'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:BUDGET_PROPOSAL_PLANS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(37659434653214045)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1756246'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_ID:COST_CENTER:PROJECT_NUMBER:TASK_NUMBER:ROW_VERSION_NUMBER:FILENAME:FILE_COMMENTS:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(137151030671676359)
,p_plug_name=>'Search Criteria'
,p_icon_css_classes=>'fa-search'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(137151949531676368)
,p_plug_name=>'Search L'
,p_parent_plug_id=>wwv_flow_api.id(137151030671676359)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(137152077474676369)
,p_plug_name=>'Search R'
,p_parent_plug_id=>wwv_flow_api.id(137151030671676359)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(37670025198241744)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(137151030671676359)
,p_button_name=>'Search'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Search'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-search'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(37669620100241744)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(137151030671676359)
,p_button_name=>'Clear'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Clear'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38089454908487397)
,p_name=>'P117_PROJECT_D'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(137151030671676359)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(38089289694487395)
,p_name=>'P117_CC_CODE_D'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(137151030671676359)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37668898578241743)
,p_name=>'P117_BUDGET_PROPOSAL_PLAN'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(137151949531676368)
,p_prompt=>'Budget Proposal Plan'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT PLAN_NAME , PLAN_ID',
'FROM(',
'SELECT distinct plan_id  , budget_proposal_pkg.plan_name(plan_id) plan_name',
'FROM BUDGET_PROPOSAL_PROJECTS_PLANS',
'ORDER BY PLAN_ID)'))
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37668438576241743)
,p_name=>'P117_SECTOR'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(137151949531676368)
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select SECOR_NAME, SECTOR_ID',
'from(',
'select distinct SECTOR_ID , user_details.org_name(Sector_id) secor_name',
'from BUDGET_PROPOSAL_PROJECTS_PLANS)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37668077813241742)
,p_name=>'P117_COST_CENTER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(137151949531676368)
,p_prompt=>'Cost Center'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select COST_CENTER_NAME || ',
'        ''(''             ||',
'        COST_CENTER     ||',
'        '')''     COST_CENTER_NAME',
'        , COST_CENTER',
'from(',
'select distinct COST_CENTER , user_details.get_cost_center_name(cost_center) cost_center_name',
'from BUDGET_PROPOSAL_PROJECTS_PLANS',
'where SECTOR_ID = nvl(:P117_SECTOR , SECTOR_ID))',
'order by COST_CENTER'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P117_SECTOR_D'
,p_ajax_optimize_refresh=>'N'
,p_cSize=>40
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37667722388241742)
,p_name=>'P117_PROJECT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(137151949531676368)
,p_prompt=>'Project'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select project_number ||',
'        ''(''         ||',
'        project_name  ||',
'        '')''      project_name ',
'        , project_number',
'from(',
'select distinct project_number , projects_util.project_name(project_number) project_name',
'from BUDGET_PROPOSAL_PROJECTS_PLANS',
'where SECTOR_ID = nvl(:P117_SECTOR , SECTOR_ID)',
'and cost_center = nvl(:P117_COST_CENTER, cost_center))',
'order by project_number'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37666933941241742)
,p_name=>'P117_EXPENSE_CLASS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(137152077474676369)
,p_prompt=>'Expense Class'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BP EXPENSE CLASSES'
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
'                l.lookup_code = ''BP_EXPENSE_CLASSES''',
'        )',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37666555473241741)
,p_name=>'P117_EXPENSE_CATEGORY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(137152077474676369)
,p_prompt=>'Expense Category'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BP EXPENSE CATEGORY'
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
'                l.lookup_code = ''BP_EXPENSE_CATEGORIES''',
'        )',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37666201378241741)
,p_name=>'P117_COMMITMENT_TYPE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(137152077474676369)
,p_prompt=>'Commitment Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BP COMMITMENT TYPES'
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
'                l.lookup_code = ''BP_COMMITMENT_TYPES''',
'        )',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37665808515241741)
,p_name=>'P117_CLASSIFICATION'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(137152077474676369)
,p_prompt=>'Classification'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BP CLASSIFICATIONS'
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
'                l.lookup_code = ''BP_CLASSIFICATIONS''',
'        )',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(37113720964435794)
,p_name=>'P117_SECTOR_D'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(137151030671676359)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(38090107396487403)
,p_name=>'Search DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(37670025198241744)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(38090011383487402)
,p_event_id=>wwv_flow_api.id(38090107396487403)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(37679451070248285)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(38089723340487399)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'DOWNLOAD_ATTACHMENTS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
' DECLARE',
'    l_download_file_name  VARCHAR2(64) := :P117_PROJECT_D ||''-attachments.zip'';',
'    l_zip_file        BLOB;',
'    l_disposition     VARCHAR2(30) := ''attachment'';',
' BEGIN',
'    FOR i IN (select filename,',
'                    file_blob',
'               from budget_proposal_plans_documents',
'               where project_number = :P117_PROJECT_D',
'    ) LOOP',
'      -- Add files to the zip ',
'     apex_zip.add_file(',
'                        p_zipped_blob => l_zip_file',
'                      , p_file_name => i.filename',
'                      , p_content => i.file_blob',
'       );',
'    END LOOP;',
'',
'    -- Finish zipping',
'    apex_zip.finish(p_zipped_blob => l_zip_file);',
'    -- Download zip file',
'    sys.htp.init;',
'    sys.owa_util.mime_header(',
'                            ''application/zip''',
'                          , false',
'    );',
'    sys.htp.p(''Content-length: ''',
'              || sys.dbms_lob.getlength(l_zip_file));',
'',
'    sys.htp.p(''Content-Disposition: attachment; filename="''',
'              || l_download_file_name',
'              || ''"'');',
'    sys.owa_util.http_header_close;',
'    sys.wpg_docload.download_file(l_zip_file);',
'    apex_application.stop_apex_engine;',
' END;',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(37113503338435792)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'download_cost_center_documents'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
' DECLARE',
'--    L_SECTOR_FILE_NAME_ZIP      VARCHAR2(128) := :P117_SECTOR_D     ||  ''-attachments.zip'';',
'    L_CC_CODE_FILE_NAME_ZIP     VARCHAR2(128) := :P117_CC_CODE_D    ||  ''-attachments.zip'';',
'    L_PROJECT_FILE_NAME_ZIP     VARCHAR2(128) ;',
'    ',
'    ',
'    l_project_task_zip_file        BLOB;',
'    l_temp_blob                    BLOB;',
'    l_cost_center_zip_file         BLOB;',
'    l_disposition     VARCHAR2(30) := ''attachment'';',
' BEGIN',
' ',
'---1) cost_center Loop',
'for pro_rec in (select DISTINCT  project_number, task_number',
'                from     budget_proposal_plans_documents',
'                WHERE   cost_center = :p117_cc_code_d',
'                and project_number is not null',
'                order by 1,2',
'                )',
'    LOOP',
'    -- 2) project/task loop',
'                FOR i IN (select filename, file_blob',
'                          from budget_proposal_plans_documents',
'                            where project_number = pro_rec.project_number',
'                            and task_number = pro_rec.task_number',
'                        ) ',
'            LOOP',
'                    -- Add project_task files to the zip ',
'                     apex_zip.add_file( p_zipped_blob => l_project_task_zip_file',
'                                      , p_file_name => i.filename',
'                                      , p_content => i.file_blob',
'                                     );',
'                                     ',
'                    apex_zip.add_file( p_zipped_blob => l_cost_center_zip_file',
'                                      , p_file_name => i.filename',
'                                      , p_content => i.file_blob',
'                                     );                 ',
'      ',
'            -- Finish zipping',
'            -- apex_zip.finish(p_zipped_blob => l_project_task_zip_file);',
'      ',
'            END LOOP;',
'            ',
'            -- loop to add docs on cost center level only with out project',
'            FOR i IN (select filename,file_blob',
'                        from budget_proposal_plans_documents',
'                        where cost_center  = :p117_cc_code_d',
'                        and project_number is null',
'                        ) ',
'            LOOP',
'                    -- Add project_task files to the zip ',
'                     apex_zip.add_file( p_zipped_blob => l_project_task_zip_file',
'                                      , p_file_name => i.filename',
'                                      , p_content => i.file_blob',
'                                     );',
'                                     ',
'                    apex_zip.add_file( p_zipped_blob => l_cost_center_zip_file',
'                                      , p_file_name => i.filename',
'                                      , p_content => i.file_blob',
'                                     );  ',
'            End Loop;',
'',
'End LOOP;',
'    -- Finish zipping',
'    apex_zip.finish(p_zipped_blob => l_cost_center_zip_file);',
'    ',
'',
'    -- Download zip file',
'    sys.htp.init;',
'    sys.owa_util.mime_header(''application/zip'', false);',
'    ',
'    sys.htp.p(''Content-length: ''',
'              || sys.dbms_lob.getlength(l_cost_center_zip_file));',
'',
'    sys.htp.p(''Content-Disposition: attachment; filename="''',
'              || L_CC_CODE_FILE_NAME_ZIP',
'              || ''"'');',
'    ',
'    sys.owa_util.http_header_close;',
'    sys.wpg_docload.download_file(l_cost_center_zip_file);',
'    apex_application.stop_apex_engine;',
' ',
' END;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
