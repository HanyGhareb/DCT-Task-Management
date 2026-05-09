prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
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
 p_id=>2
,p_user_interface_id=>wwv_flow_api.id(3440093928015830)
,p_name=>'All Organizations - Table'
,p_alias=>'ALL-ORGANIZATIONS-TABLE'
,p_step_title=>'All Organizations - Table'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200805110754'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3453608746022868)
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
 p_id=>wwv_flow_api.id(3454270670022869)
,p_plug_name=>'All Organizations - Table'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3353501491015744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'DCT_HR_ORGANIZATIONS'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'All Organizations - Table'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(3454310396022869)
,p_name=>'All Organizations - Table'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>3454310396022869
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3454719685022874)
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
 p_id=>wwv_flow_api.id(3455161527022875)
,p_db_column_name=>'ORG_NAME_EN'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Org Name En'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3455508200022875)
,p_db_column_name=>'ORG_NAME_AR'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Org Name Ar'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3455980765022875)
,p_db_column_name=>'PARENT_ORG_ID'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Parent Org Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3456368883022875)
,p_db_column_name=>'ORG_LEVEL_ID'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Org Level Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3456727714022875)
,p_db_column_name=>'STATUS'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3457193380022876)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3457513630022876)
,p_db_column_name=>'PARENT_ORG_NAME'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Parent Org Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3457936601022876)
,p_db_column_name=>'ORG_LEVEL_NAME'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Org Level Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3458349571022876)
,p_db_column_name=>'MANAGER_EMP_NUM'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Manager Emp Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3458740234022877)
,p_db_column_name=>'PARTNER_EMP_NUM'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Partner Emp Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3459123795022877)
,p_db_column_name=>'ORG_RATE'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Org Rate'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3459561128022877)
,p_db_column_name=>'SERVICE_PROVIDER'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Service Provider'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3459961029022877)
,p_db_column_name=>'DATE_FROM'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Date From'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3460379397022878)
,p_db_column_name=>'SHORT_NAME_EN'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Short Name En'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3460725990022878)
,p_db_column_name=>'SHORT_NAME_AR'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Short Name Ar'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3461143906022878)
,p_db_column_name=>'SOURCE'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Source'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3461575431022878)
,p_db_column_name=>'HR_STRUCTURE_ID'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Hr Structure Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3461908513022879)
,p_db_column_name=>'VERSION'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Version'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3462369477022879)
,p_db_column_name=>'ORG_NAME_AR_USER'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Org Name Ar User'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3462766101022879)
,p_db_column_name=>'PARENT_ORG_ID_USER'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Parent Org Id User'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3463132439022879)
,p_db_column_name=>'ORG_NAME_EN_USER'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Org Name En User'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3463519490022880)
,p_db_column_name=>'ORG_PRIORITY'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Org Priority'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3463973394022880)
,p_db_column_name=>'START_DATE'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3464399160022880)
,p_db_column_name=>'END_DATE'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3464722025022880)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3465178109022881)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3465516869022881)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3465943672022881)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(3466518173025141)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'34666'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORG_ID:ORG_NAME_EN:ORG_NAME_AR:PARENT_ORG_ID:ORG_LEVEL_ID:STATUS:COST_CENTER_CODE:PARENT_ORG_NAME:ORG_LEVEL_NAME:MANAGER_EMP_NUM:PARTNER_EMP_NUM:SHORT_NAME_EN:ORG_NAME_AR_USER:PARENT_ORG_ID_USER:ORG_NAME_EN_USER:END_DATE:'
);
wwv_flow_api.component_end;
end;
/
