prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>143576171933264960
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>11
,p_user_interface_id=>wwv_flow_api.id(24631887413319249)
,p_name=>'TAC Form Requests - Report'
,p_alias=>'TAC-FORM-REQUESTS-REPORT'
,p_step_title=>'TAC Form Requests - Report'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA1025'
,p_last_upd_yyyymmddhh24miss=>'20220703100438'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(26843695599092172)
,p_plug_name=>'TAC Forms Report'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24545364387319318)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    tac_type,',
'    form_number,',
'    meeting_number,',
'    seq_num,',
'    form_date,',
'    purpose,',
'    requestor_person_id,',
'    prepared_person_id,',
'    requestor_org_id,',
'    department_id,',
'    sector_id,',
'    cost_center,',
'    project_duration,',
'    duration_uom,',
'    project_duration_text,',
'    tender_no,',
'    project_title,',
'    estimated_amount,',
'    currency,',
'    fund_available,',
'    scope_of_work,',
'    recommendation,',
'    approval_status,',
'    notes,',
'    decision,',
'    exemption_others,',
'    tac_committee_id,',
'    meeting_id,',
'    decision_option,',
'    submission_date,',
'    final_approval,',
'    created_by_person_id,',
'    created_on,',
'    updated_by_person_id,',
'    updated_on',
'FROM',
'    tac_form;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'TAC Forms Report'
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
 p_id=>wwv_flow_api.id(26844088975092172)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No Procurement Forms Recorded '
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.::P12_ID,FORM_ID:#ID#,#ID#'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'TCA9051'
,p_internal_uid=>26844088975092172
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26844135373092171)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26844507047092170)
,p_db_column_name=>'TAC_TYPE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'TAC Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_api.id(26504590426049731)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26844959071092169)
,p_db_column_name=>'FORM_NUMBER'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Submission No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26845385314092169)
,p_db_column_name=>'MEETING_NUMBER'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Meeting No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26845791460092168)
,p_db_column_name=>'SEQ_NUM'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Seq Num'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26846132396092168)
,p_db_column_name=>'FORM_DATE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26846514888092168)
,p_db_column_name=>'PURPOSE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Purpose'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(26808308978116899)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26846900280092168)
,p_db_column_name=>'REQUESTOR_PERSON_ID'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Requestor'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25227436734855051)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26847379943092167)
,p_db_column_name=>'PREPARED_PERSON_ID'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Prepared By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25227436734855051)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26847736166092167)
,p_db_column_name=>'REQUESTOR_ORG_ID'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Requestor Org Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26848194064092167)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Department Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26848554636092167)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26848929522092166)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26849345139092166)
,p_db_column_name=>'PROJECT_DURATION'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Project Duration'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26849703056092166)
,p_db_column_name=>'DURATION_UOM'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Duration By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26850180727092165)
,p_db_column_name=>'PROJECT_DURATION_TEXT'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Project Duration Text'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26850578504092165)
,p_db_column_name=>'TENDER_NO'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Tender No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26850961508092165)
,p_db_column_name=>'PROJECT_TITLE'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Project Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26851329889092165)
,p_db_column_name=>'ESTIMATED_AMOUNT'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Estimated Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26851765311092164)
,p_db_column_name=>'CURRENCY'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26852137569092164)
,p_db_column_name=>'FUND_AVAILABLE'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Fund Available'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25249196382855039)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26852586240092164)
,p_db_column_name=>'SCOPE_OF_WORK'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Scope Of Work'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26852992992092164)
,p_db_column_name=>'RECOMMENDATION'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Recommendation'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26853329957092163)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26854150727092163)
,p_db_column_name=>'NOTES'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26858589488092160)
,p_db_column_name=>'SUBMISSION_DATE'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Submission Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26858958899092160)
,p_db_column_name=>'FINAL_APPROVAL'
,p_display_order=>38
,p_column_identifier=>'AL'
,p_column_label=>'Final Approval'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26859342574092160)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>39
,p_column_identifier=>'AM'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(25227436734855051)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26859751751092159)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>40
,p_column_identifier=>'AN'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26860197682092159)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>41
,p_column_identifier=>'AO'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(25227436734855051)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26860531708092159)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>42
,p_column_identifier=>'AP'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94260044880567)
,p_db_column_name=>'DECISION'
,p_display_order=>52
,p_column_identifier=>'AR'
,p_column_label=>'Decision'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94429914880568)
,p_db_column_name=>'EXEMPTION_OTHERS'
,p_display_order=>62
,p_column_identifier=>'AS'
,p_column_label=>'Exemption Others'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94474440880569)
,p_db_column_name=>'TAC_COMMITTEE_ID'
,p_display_order=>72
,p_column_identifier=>'AT'
,p_column_label=>'Tac Committee Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94622376880570)
,p_db_column_name=>'MEETING_ID'
,p_display_order=>82
,p_column_identifier=>'AU'
,p_column_label=>'Meeting Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(94670261880571)
,p_db_column_name=>'DECISION_OPTION'
,p_display_order=>92
,p_column_identifier=>'AV'
,p_column_label=>'Decision Option'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(26863437509090513)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'268635'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FORM_NUMBER:FORM_DATE:PURPOSE:REQUESTOR_PERSON_ID:PREPARED_PERSON_ID:PROJECT_TITLE:ESTIMATED_AMOUNT:CURRENCY:APPROVAL_STATUS:'
,p_sort_column_1=>'CREATED_ON'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
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
 p_id=>wwv_flow_api.id(85292663806405682)
,p_report_id=>wwv_flow_api.id(26863437509090513)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Completed'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Completed''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(85293078388405682)
,p_report_id=>wwv_flow_api.id(26863437509090513)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>' (case when ("APPROVAL_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#A96E17'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(26861887129092157)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24556678455319312)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(24493261337319361)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(24610734179319274)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26863006814092156)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(26843695599092172)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(24609474578319275)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New T&AC Major'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_TAC_TYPE,P12_TAC_TYPE_H:68,68'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26782485641539109)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(26843695599092172)
,p_button_name=>'CREATE_MIN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(24609474578319275)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New T&AC Minor'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_TAC_TYPE,P12_TAC_TYPE_H:67,67'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12389331610864866)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(26843695599092172)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(24609474578319275)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New PC Form'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_TAC_TYPE,P12_TAC_TYPE_H:123,123'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- :IS_SINGLE_SOURCE_ADMIN = ''Y'' or ',
'-- :IS_SUPPLY_MANAGEMENT_UNIT_HEAD > 0 or',
':IS_BUYER   > 0 or',
'--:IS_COMMITTEE_SECRETARY > 0 or',
'-- :IS_SOUCEING_MANAGER > 0',
':PERSON_ID = 680461'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.component_end;
end;
/
