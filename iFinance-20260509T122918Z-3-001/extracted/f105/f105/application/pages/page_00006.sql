prompt --application/pages/page_00006
begin
--   Manifest
--     PAGE: 00006
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
 p_id=>6
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Budget Transfer requests'
,p_alias=>'EU-TRANSFER-REQUESTS'
,p_step_title=>'Budget Transfer requests'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA1577'
,p_last_upd_yyyymmddhh24miss=>'20220712021447'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(205666687680115)
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
 p_id=>wwv_flow_api.id(206208884680115)
,p_plug_name=>'EU Transfer requests'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select REQUEST_ID,',
'       REQUEST_NO,',
'       REQUEST_DATE,',
'       REQUIRED_DATE,',
'       REQUEST_STATUS,',
'       JUSTIFICATION,',
'       YEAR,',
'       PURPOSE_EU,',
'       PRIORITY,',
'       SUBMITTED_ON,',
'       SUBMITTED_BY,',
'       SEQ,',
'       FINAL_APPROVE_ON,',
'       CREATED_BY_PERSON_ID,',
'       UPDATED_BY_PERSON_ID,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       REASONS,',
'       SPM_PROJECT_NAME,',
'       SPM_PROJECT_ID,',
'       REQUEST_TYPE,',
'       FINAL_REJECT_ON,',
'       REJECTED_BY,',
'       REJECT_REASON,',
'       CANCEL_ON,',
'       CANCELLED_BY,',
'       CANCEL_REASON,',
'       STRATEGIC_YN,',
'       REQUEST_FOR',
'  from BTF_END_USERS_HEADER',
'  where REQUEST_FOR = :PERSON_ID ',
'  or CREATED_BY_PERSON_ID = :PERSON_ID',
'  or request_id in (select h.request_id from btf_end_users_req_approval_history h where h.person_id = :PERSON_ID)',
'  order by request_id'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'EU Transfer requests'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(206333244680115)
,p_name=>'EU Transfer requests'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>105562662436043528
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(206671436680119)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(207152855680119)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Request No'
,p_column_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_REQUEST_ID,P8_PAGE_FROM:#REQUEST_ID#,6'
,p_column_linktext=>'#REQUEST_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(207484367680119)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(207955258680119)
,p_db_column_name=>'REQUIRED_DATE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Required Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208370796680119)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208748101680120)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(209159073680120)
,p_db_column_name=>'YEAR'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(209480061680120)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Purpose'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(209901259680120)
,p_db_column_name=>'PRIORITY'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48255921784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(210368183680120)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(210706702680120)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211167895680121)
,p_db_column_name=>'SEQ'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211527999680121)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211881873680121)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(212358775680121)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(212716004680121)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(213152231680122)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(213499231680122)
,p_db_column_name=>'REASONS'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(213904907680122)
,p_db_column_name=>'SPM_PROJECT_NAME'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'SPM Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(214354964680122)
,p_db_column_name=>'SPM_PROJECT_ID'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'SPM Project'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(214672945680122)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(203139147648731)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(101712790851389807)
,p_db_column_name=>'FINAL_REJECT_ON'
,p_display_order=>31
,p_column_identifier=>'V'
,p_column_label=>'Final Reject On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(101712658422389806)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>41
,p_column_identifier=>'W'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(101712595667389805)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>51
,p_column_identifier=>'X'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(101712457116389804)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>61
,p_column_identifier=>'Y'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(101712351979389803)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>71
,p_column_identifier=>'Z'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(101712279566389802)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>81
,p_column_identifier=>'AA'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(101712192767389801)
,p_db_column_name=>'STRATEGIC_YN'
,p_display_order=>91
,p_column_identifier=>'AB'
,p_column_label=>'Strategic ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(101712131984389800)
,p_db_column_name=>'REQUEST_FOR'
,p_display_order=>101
,p_column_identifier=>'AC'
,p_column_label=>'Request For'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(215337957683712)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1055717'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NO:REQUEST_TYPE:REQUEST_DATE:PRIORITY:REQUEST_STATUS:FINAL_REJECT_ON:REJECTED_BY:REJECT_REASON:CANCEL_ON:CANCELLED_BY:CANCEL_REASON:STRATEGIC_YN:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(86498930822909)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(205666687680115)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'New'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
