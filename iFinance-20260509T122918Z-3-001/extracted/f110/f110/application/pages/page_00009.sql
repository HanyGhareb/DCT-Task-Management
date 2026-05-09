prompt --application/pages/page_00009
begin
--   Manifest
--     PAGE: 00009
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>110
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>9
,p_user_interface_id=>wwv_flow_api.id(13327188105480887)
,p_name=>'Approved Budget Allocation Scenarios'
,p_alias=>'APPROVED-BUDGET-ALLOCATION-SCENARIOS'
,p_step_title=>'Approved Budget Allocation Scenarios'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20221101210633'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(134414361188545828)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(13251955757480809)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(13188546909480758)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(13306063834480855)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(134414981005545827)
,p_plug_name=>'Approved Budget Allocation Scenarios'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(13240610854480803)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       APPROVED_AMOUNT_CH3,',
'       STATUS,',
'       START_DATE,',
'       END_DATE,',
'       BUDGET_YEAR,',
'       PROPOSED_SCENARIO,',
'       APPROVED_AMOUNT_CH2,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_ON,',
'       UPDATED_BY,',
'       BUDGET_VERSION,',
'       UPDATE_ALLOWED,',
'       PROPOSAL_AMOUNT_CH3,',
'       PROPOSAL_AMOUNT_CH2',
'        , ''<span class="fa fa-columns" aria-hidden="true"></span>'' Allocate_by_sector    ',
'  from APPROVED_BUDGET_SUMMARY',
'  where BUDGET_YEAR = NVL(:P9_YEAR, BUDGET_YEAR)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P9_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Approved Budget Allocation Scenarios'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(134415018014545827)
,p_name=>'Approved Budget Allocation Scenarios'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>134415018014545827
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134415483537545823)
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
 p_id=>wwv_flow_api.id(134415877169545822)
,p_db_column_name=>'APPROVED_AMOUNT_CH3'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Approved Amount Ch3'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134416205392545822)
,p_db_column_name=>'STATUS'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134416629019545822)
,p_db_column_name=>'START_DATE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134417074438545822)
,p_db_column_name=>'END_DATE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134417425591545822)
,p_db_column_name=>'BUDGET_YEAR'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Budget Year'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134417800389545821)
,p_db_column_name=>'PROPOSED_SCENARIO'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Proposed Scenario'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134418284567545821)
,p_db_column_name=>'APPROVED_AMOUNT_CH2'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Approved Amount Ch2'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134418606876545821)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134419069975545821)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134419492686545821)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134419820091545821)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134420296117545820)
,p_db_column_name=>'BUDGET_VERSION'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Budget Version'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134420669848545820)
,p_db_column_name=>'UPDATE_ALLOWED'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Update Allowed'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134421092189545820)
,p_db_column_name=>'PROPOSAL_AMOUNT_CH3'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Proposal Amount Ch3'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134421487026545820)
,p_db_column_name=>'PROPOSAL_AMOUNT_CH2'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Proposal Amount Ch2'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(134346749097125443)
,p_db_column_name=>'ALLOCATE_BY_SECTOR'
,p_display_order=>26
,p_column_identifier=>'Q'
,p_column_label=>'Allocate By Sector'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(134422848601536852)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1344229'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'BUDGET_YEAR:PROPOSED_SCENARIO:PROPOSAL_AMOUNT_CH2:APPROVED_AMOUNT_CH2:PROPOSAL_AMOUNT_CH3:APPROVED_AMOUNT_CH3:STATUS::ALLOCATE_BY_SECTOR'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(134346634824125442)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(134414361188545828)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(13304710257480854)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(134346542534125441)
,p_name=>'P9_YEAR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(134414361188545828)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
