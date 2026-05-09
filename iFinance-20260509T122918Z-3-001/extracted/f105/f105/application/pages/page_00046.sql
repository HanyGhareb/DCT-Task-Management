prompt --application/pages/page_00046
begin
--   Manifest
--     PAGE: 00046
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
 p_id=>46
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Add Tasks from previous years'
,p_alias=>'ADD-TASKS-FROM-PREVIOUS-YEARS'
,p_step_title=>'Add Tasks from previous years'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230607182956'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(81294159177746170)
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
 p_id=>wwv_flow_api.id(81293540271746172)
,p_plug_name=>'&P46_PROJECT_NUMBER. tasks'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(82900765231029184)
,p_plug_name=>'Tasks Report'
,p_parent_plug_id=>wwv_flow_api.id(81293540271746172)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select apex_item.checkbox2(1,PROJECT_NUMBER|| ''-''|| TASK_NUMBER|| ''-''|| EXPENDITURE_TYPE|| ''-''|| COST_CENTER) Selected,',
'        task_number,',
'        COST_CENTER,',
'        EXPENDITURE_TYPE,',
'        future2,',
'        project_number',
'from        ',
'(select distinct pb.project_number,',
'        pb.TASK_NUMBER, ',
'       pb.COST_CENTER, ',
'       pb.EXPENDITURE_TYPE,',
'       t.future2',
'from project_balances pb , task t',
'where pb.TASK_NUMBER = t.task_number',
'and pb.project_number = :P46_PROJECT_NUMBER',
'--and pb.accounting_year != :CURRENT_YEAR ',
'and pb.TASK_NUMBER not in (select pb2.TASK_NUMBER',
'                          from project_balances pb2',
'                          where pb2.project_number = :P46_PROJECT_NUMBER',
'                            and pb2.accounting_year = :CURRENT_YEAR  ));',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P46_PROJECT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Tasks Report'
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
 p_id=>wwv_flow_api.id(82900729079029183)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>130383303310155449
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(81291673483758627)
,p_db_column_name=>'SELECTED'
,p_display_order=>10
,p_column_identifier=>'E'
,p_column_label=>'Selected'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(81292125099758631)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>20
,p_column_identifier=>'A'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(81291934330758630)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(81291908598758629)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(81291775906758628)
,p_db_column_name=>'FUTURE2'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(81291178341758622)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>60
,p_column_identifier=>'H'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(81285110905772219)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1319990'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SELECTED:TASK_NUMBER:COST_CENTER:EXPENDITURE_TYPE:FUTURE2::PROJECT_NUMBER'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(41016994410580807)
,p_plug_name=>'Task Creation Requests'
,p_parent_plug_id=>wwv_flow_api.id(81293540271746172)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'TASK_CREATION_REQUESTS'
,p_query_where=>'project_number = :P46_PROJECT_NUMBER'
,p_query_order_by=>'ID'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P46_PROJECT_NUMBER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Task Creation Requests'
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
 p_id=>wwv_flow_api.id(41016892410580806)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:113:&SESSION.::&DEBUG.:113:P113_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>172267139978603826
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41016823770580805)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41016710480580804)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41016627427580803)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41016526240580802)
,p_db_column_name=>'TASK_NAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Task Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41016404862580801)
,p_db_column_name=>'TASK_DESCRIPTION'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Task Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41016241308580800)
,p_db_column_name=>'TASK_START_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Task Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41016228671580799)
,p_db_column_name=>'TASK_END_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Task End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41016050342580798)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41016023433580797)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41015922679580796)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41015739776580795)
,p_db_column_name=>'FUTURE1'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41015729655580794)
,p_db_column_name=>'FUTURE2'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41015617266580793)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41015492207580792)
,p_db_column_name=>'DCT_SECTOR_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Dct Sector Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41015383526580791)
,p_db_column_name=>'DCT_DEPARTMENT_ID'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Dct Department Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41015237549580790)
,p_db_column_name=>'DCT_SECTION_ID'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Dct Section Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41015150272580789)
,p_db_column_name=>'DCT_UNIT_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Dct Unit Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41015087369580788)
,p_db_column_name=>'DCT_TASK_NAME'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Dct Task Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41014934325580787)
,p_db_column_name=>'DCT_SERVICE_PROVIDER'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Dct Service Provider'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41014910003580786)
,p_db_column_name=>'DCT_MPR_ALLOWED'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Dct Mpr Allowed'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41014741540580785)
,p_db_column_name=>'DCT_MPO_ALLOWED'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Dct Mpo Allowed'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41014681357580784)
,p_db_column_name=>'DCT_STATUS'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Dct Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41014554061580783)
,p_db_column_name=>'DIRECTOR_PERSON_ID'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Director'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(41014465903580782)
,p_db_column_name=>'ED_PERSON_ID'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Executive Director'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40683447442038631)
,p_db_column_name=>'INITIATIVE_ID'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Initiative'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(916102580051005)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40683415638038630)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Request Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40683266145038629)
,p_db_column_name=>'REQUEST_MSG'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Request Msg'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40683196943038628)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40683055529038627)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40683032212038626)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40682863143038625)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(40668651737026067)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1726154'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:PROJECT_NUMBER:TASK_NUMBER:TASK_NAME:TASK_DESCRIPTION:TASK_START_DATE:TASK_END_DATE:COST_CENTER:BUDGET_GROUP_CODE:ACTIVITY:FUTURE1:FUTURE2:EXPENDITURE_TYPE:INITIATIVE_ID:REQUEST_STATUS:REQUEST_MSG:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(41552772507522331)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(81294159177746170)
,p_button_name=>'New_TASK'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'New Task'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:113:&SESSION.::&DEBUG.:113:P113_PROJECT_NUMBER:&P46_PROJECT_NUMBER.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(81291585219758626)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(81294159177746170)
,p_button_name=>'Add'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-cart-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(81290937579758620)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(81294159177746170)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(81291077799758621)
,p_branch_name=>'Go to  41'
,p_branch_action=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(82900890144029185)
,p_name=>'P46_PROJECT_NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(81293540271746172)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(40682819566038624)
,p_name=>'Task Creation Requests DA'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(41016994410580807)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40682676614038623)
,p_event_id=>wwv_flow_api.id(40682819566038624)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(41016994410580807)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(40682530635038621)
,p_name=>'New_TASK DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(41552772507522331)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40682421868038620)
,p_event_id=>wwv_flow_api.id(40682530635038621)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(41016994410580807)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(81291434365758625)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add to current year process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'',
'l_count                 NUMBER := apex_application.g_f01.count;',
'',
'Begin',
'',
'  IF l_count = 0 THEN',
'                    apex_error.add_error(p_message => ''Please select at least one task! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'  else',
'  FOR i IN 1..l_count LOOP',
'        insert into project_balances',
'    (PROJECT_NUMBER, TASK_NUMBER, COST_CENTER, EXPENDITURE_TYPE, BUDGET, ACTUAL, ENCUMBERANCE, FUND_AVAILABLE, ACCOUNTING_YEAR)',
'select ',
'    pb.project_number, pb.TASK_NUMBER, pb.COST_CENTER, pb.EXPENDITURE_TYPE, 0, 0, 0, 0, :CURRENT_YEAR ',
'from project_balances pb',
'where PROJECT_NUMBER|| ''-''|| TASK_NUMBER|| ''-''|| EXPENDITURE_TYPE|| ''-''|| COST_CENTER = apex_application.g_f01(i)',
'         and rownum = 1;',
'         ',
'      END LOOP;',
' End if;',
'',
'End;',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(81291585219758626)
,p_process_success_message=>'Tasks Added Successfully'
);
wwv_flow_api.component_end;
end;
/
