prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
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
 p_id=>3
,p_user_interface_id=>wwv_flow_api.id(3440093928015830)
,p_name=>'All Organizations - View'
,p_alias=>'ALL-ORGANIZATIONS-VIEW'
,p_step_title=>'All Organizations - View'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200805111021'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3468036479036539)
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
 p_id=>wwv_flow_api.id(3468646035036540)
,p_plug_name=>'All Organizations - View'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3353501491015744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'ORGANIZATIONS_V'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'All Organizations - View'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(3468793847036540)
,p_name=>'All Organizations - View'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>3468793847036540
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3469136691036544)
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
 p_id=>wwv_flow_api.id(3469580479036545)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3469982801036545)
,p_db_column_name=>'ORG_LEVEL'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Org Level'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3470380382036545)
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
 p_id=>wwv_flow_api.id(3470777268036545)
,p_db_column_name=>'PARENT_ORG_NAME'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Parent Org Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3471164217036545)
,p_db_column_name=>'PARENT_LEVEL'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Parent Level'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3471549213036546)
,p_db_column_name=>'SHORT_NAME_EN'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Short Name En'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3471995092036546)
,p_db_column_name=>'STATUS'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3472348041036546)
,p_db_column_name=>'MANAGER_EMP_NUM'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Manager Emp Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3472707540036546)
,p_db_column_name=>'MANAGER_NAME'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Manager Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3473103677036547)
,p_db_column_name=>'PARTNER_EMP_NUM'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Partner Emp Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3473542648036547)
,p_db_column_name=>'PARTNER_NAME'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Partner Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3473997705036547)
,p_db_column_name=>'ORG_RATE'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Org Rate'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3474368935036547)
,p_db_column_name=>'SERVICE_PROVIDER'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Service Provider'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3474775134036548)
,p_db_column_name=>'ORG_PRIORITY'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Org Priority'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3475197522036548)
,p_db_column_name=>'START_DATE'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3475537387036548)
,p_db_column_name=>'END_DATE'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3475975578036548)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3476362287036548)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3476739495036549)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3477133347036549)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3477565410036549)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3477945519036549)
,p_db_column_name=>'ORG_NAME_EN'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Org Name En'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3478328713036550)
,p_db_column_name=>'ORG_NAME_AR'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Org Name Ar'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3478703192036550)
,p_db_column_name=>'PARENT_ORG_ID'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Parent Org Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3479132931036550)
,p_db_column_name=>'ORG_LEVEL_ID'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Org Level Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3479572502036550)
,p_db_column_name=>'ORG_LEVEL_NAME'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Org Level Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3479943288036550)
,p_db_column_name=>'DATE_FROM'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Date From'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3480352232036551)
,p_db_column_name=>'SHORT_NAME_AR'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Short Name Ar'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3480755595036551)
,p_db_column_name=>'SOURCE'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Source'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3481193310036551)
,p_db_column_name=>'HR_STRUCTURE_ID'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Hr Structure Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3481547598036551)
,p_db_column_name=>'VERSION'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Version'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3481958847036552)
,p_db_column_name=>'ORG_NAME_AR_USER'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Org Name Ar User'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3482321292036552)
,p_db_column_name=>'PARENT_ORG_ID_USER'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Parent Org Id User'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3482702984036552)
,p_db_column_name=>'ORG_NAME_EN_USER'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Org Name En User'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(3483155403037184)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'34832'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ORG_ID:ORG_NAME:ORG_LEVEL:PARENT_ORG:PARENT_ORG_NAME:PARENT_LEVEL:SHORT_NAME_EN:STATUS:MANAGER_EMP_NUM:MANAGER_NAME:PARTNER_EMP_NUM:PARTNER_NAME:END_DATE:UPDATED_DATE:UPDATED_BY:COST_CENTER_CODE:ORG_NAME_EN:ORG_NAME_AR:PARENT_ORG_ID:ORG_LEVEL_ID:ORG_'
||'LEVEL_NAME:PARENT_ORG_ID_USER:ORG_NAME_EN_USER:'
);
wwv_flow_api.component_end;
end;
/
