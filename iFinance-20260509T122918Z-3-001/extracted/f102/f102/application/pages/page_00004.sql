prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
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
 p_id=>4
,p_user_interface_id=>wwv_flow_api.id(3440093928015830)
,p_name=>'Organizations Details View'
,p_alias=>'ORGANIZATIONS-DETAILS-VIEW'
,p_step_title=>'Organizations Details View'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200805190021'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3490940854864718)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3364880770015750)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(3301434120015688)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(3418914725015794)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3491541357864719)
,p_plug_name=>'Organizations Details View'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3353501491015744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'ORGANIZATIONS_DETAILS_V'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Organizations Details View'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(3491652957864719)
,p_name=>'Organizations Details View'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>3491652957864719
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3492090919864752)
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
 p_id=>wwv_flow_api.id(3492470035864754)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3492895099864755)
,p_db_column_name=>'ORG_LEVEL'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Org Level'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3493215865864755)
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
 p_id=>wwv_flow_api.id(3493650935864756)
,p_db_column_name=>'PARENT_ORG_NAME'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Parent Org Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3494082411864756)
,p_db_column_name=>'PARENT_LEVEL'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Parent Level'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3494432731864757)
,p_db_column_name=>'SHORT_NAME_EN'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Short Name En'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3494864636864757)
,p_db_column_name=>'STATUS'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3495179288864757)
,p_db_column_name=>'MANAGER_EMP_NUM'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Manager Emp Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3495537381864758)
,p_db_column_name=>'MANAGER_NAME'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Manager Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3495922049864758)
,p_db_column_name=>'PARTNER_EMP_NUM'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Partner Emp Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3496358742864758)
,p_db_column_name=>'PARTNER_NAME'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Partner Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3496780414864759)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3497181473864759)
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
 p_id=>wwv_flow_api.id(3497592443864760)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3497985009864760)
,p_db_column_name=>'DIRECTOR_NUM'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Director Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3498345375864760)
,p_db_column_name=>'DIRECTOR_NAME'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Director Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3498746176864761)
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
 p_id=>wwv_flow_api.id(3499181171864761)
,p_db_column_name=>'SECTOR'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3499532468864762)
,p_db_column_name=>'EXECUTIVE_DIRECTOR_NUM'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Executive Director Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3499936554864762)
,p_db_column_name=>'EXECUTIVE_DIRECTOR__NAME'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Executive Director  Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3500357337864763)
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
 p_id=>wwv_flow_api.id(3500785585864763)
,p_db_column_name=>'SERVICE_PROVIDER'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Service Provider'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3501126940864763)
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
 p_id=>wwv_flow_api.id(3501537490864764)
,p_db_column_name=>'START_DATE'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3501943094864764)
,p_db_column_name=>'END_DATE'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3502320403864765)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3502747127864765)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3503134394864765)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3503511604864766)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(3504109350865582)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'35042'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORG_ID:ORG_NAME:ORG_LEVEL:PARENT_ORG:PARENT_ORG_NAME:PARENT_LEVEL:SHORT_NAME_EN:STATUS:MANAGER_EMP_NUM:MANAGER_NAME:PARTNER_EMP_NUM:PARTNER_NAME:COST_CENTER_CODE:DEPARTMENT_ID:DEPARTMENT_NAME:DIRECTOR_NUM:DIRECTOR_NAME:SECTOR_ID:SECTOR:EXECUTIVE_DIRE'
||'CTOR_NUM:EXECUTIVE_DIRECTOR__NAME:ORG_RATE:SERVICE_PROVIDER:ORG_PRIORITY:START_DATE:END_DATE:CREATED_DATE:CREATED_BY:UPDATED_DATE:UPDATED_BY'
);
wwv_flow_api.component_end;
end;
/
