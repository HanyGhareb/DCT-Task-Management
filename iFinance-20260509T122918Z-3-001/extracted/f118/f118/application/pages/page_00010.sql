prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
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
 p_id=>10
,p_user_interface_id=>wwv_flow_api.id(122997627648781606)
,p_name=>'Due Transaction - Drilldown'
,p_alias=>'DUE-TRANSACTION-DRILLDOWN'
,p_step_title=>'Due Transaction - Drilldown'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220823112810'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(123922702440766026)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(122922476001781663)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(122859041536781706)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(122976593233781628)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(123923366388766026)
,p_plug_name=>'Due Transaction - Drilldown'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(122911181767781667)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'AR_DUE_TRANSACTIONS'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Due Transaction - Drilldown'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(123923435426766026)
,p_name=>'Due Transaction - Drilldown'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>123923435426766026
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123923847984766023)
,p_db_column_name=>'CUSTOMER_NUMBER'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Customer Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123924269597766022)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Customer Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123924688278766022)
,p_db_column_name=>'AMOUNT_DUE_REMAINING'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Amount Due Remaining'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123925075158766022)
,p_db_column_name=>'TRANSACTION_NUMBER'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Transaction Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123925404111766022)
,p_db_column_name=>'TYPE_DESCRIPTION'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Type Description'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123925865150766022)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123926219533766022)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123926616608766021)
,p_db_column_name=>'TRUST_YN'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Trust Yn'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(122544967263632137)
,p_name=>'P10_NEW'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(123922702440766026)
,p_prompt=>'New'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(122974014211781630)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.component_end;
end;
/
