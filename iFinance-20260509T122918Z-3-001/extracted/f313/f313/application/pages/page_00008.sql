prompt --application/pages/page_00008
begin
--   Manifest
--     PAGE: 00008
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>145171879539529295
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>8
,p_user_interface_id=>wwv_flow_api.id(24631887413319249)
,p_name=>'TAC Committees Report'
,p_alias=>'TAC-COMMITTEES-REPORT'
,p_step_title=>'SMD Committees Report'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220104124922'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(26494343716088943)
,p_plug_name=>'Report 1'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24545364387319318)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       COMMITTEE_TYPE,',
'       COMMITTEE_VERSION,',
'       START_DATE,',
'       END_DATE,',
'       AUTHORIZED_AMOUNT_FROM,',
'       AUTHORIZED_AMOUNT_TO,',
'       CREATED_FROM_COMMITTEE_ID,',
'       MIN_COUNT_TO_APPROVE Min_Member_count,',
'       CREATED_BY_PERSON_ID,',
'       CREATED_ON,',
'       UPDATED_BY_PERSON_ID,',
'       UPDATED_ON',
'       ,(select count(m.id)',
'from tac_committee_members m',
'where m.committee_id = TAC_COMMITTEES.ID',
'and m.status = ''A''',
'and sysdate between nvl(m.start_date , sysdate - 10) ',
'    and nvl(m.end_date , sysdate + 100)) Members_count',
'  from TAC_COMMITTEES'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Report 1'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(26494735902088943)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:RP,9:P9_ID:\#ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>26494735902088943
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26494851734088941)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26495238483088939)
,p_db_column_name=>'COMMITTEE_TYPE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Committee Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(26504590426049731)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26495641353088938)
,p_db_column_name=>'COMMITTEE_VERSION'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Committee Version'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26496043388088938)
,p_db_column_name=>'START_DATE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26496498215088938)
,p_db_column_name=>'END_DATE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26496831080088938)
,p_db_column_name=>'AUTHORIZED_AMOUNT_FROM'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Authorized Amount From'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26497266129088937)
,p_db_column_name=>'AUTHORIZED_AMOUNT_TO'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Authorized Amount To'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26497601763088937)
,p_db_column_name=>'CREATED_FROM_COMMITTEE_ID'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Created From Committee Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26498012789088937)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25227436734855051)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26498407260088937)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26498811133088936)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25227436734855051)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26499215662088936)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26241772398246041)
,p_db_column_name=>'MEMBERS_COUNT'
,p_display_order=>22
,p_column_identifier=>'M'
,p_column_label=>'Members Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26241906159246043)
,p_db_column_name=>'MIN_MEMBER_COUNT'
,p_display_order=>32
,p_column_identifier=>'N'
,p_column_label=>'Min Members to Approve'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(26502396767088399)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'265024'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'COMMITTEE_TYPE:COMMITTEE_VERSION:AUTHORIZED_AMOUNT_FROM:AUTHORIZED_AMOUNT_TO:MEMBERS_COUNT:MIN_MEMBER_COUNT:START_DATE:END_DATE:UPDATED_BY_PERSON_ID:UPDATED_ON:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(26500590355088930)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24556678455319312)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(24493261337319361)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(24610734179319274)
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26501757333088928)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(26494343716088943)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(24609474578319275)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Committee Type'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:9'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
