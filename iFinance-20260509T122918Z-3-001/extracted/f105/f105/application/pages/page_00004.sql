prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
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
 p_id=>4
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'End User - Access Request Approve / Reject'
,p_alias=>'END-USER-ACCESS-REQUEST-APPROVE-REJECT'
,p_step_title=>'End User - Access Request Approve / Reject'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220503123457'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(92523104479983624)
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
 p_id=>wwv_flow_api.id(92562551041148065)
,p_plug_name=>'Request Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    h.id        history_id,',
'    h.request_id,',
'    h.step_no,',
'    h.person_id,',
'    h.role_desc,',
'    h.action_required,',
'    to_char(h.recevied_date,''DD-MON-YYYY HH:MI:SS'') recevied_date,',
'    h.status,',
'    h.action_date,',
'--    h.comments,',
'    h.approval_type_id,',
'    h.on_behalf,',
'    h.more_info,',
'    h.otp,',
'    h.otp_time,',
'    h.otp_count,',
'    h.hash_code,',
'    h.created_on,',
'    h.created_by,',
'    h.updated_by,',
'    h.updated_on,',
'    r.entity_name Prject,',
'    r.start_date,',
'    r.end_date,',
'    r.comments,',
'    (select e.full_name_en',
'     from employees_v e',
'     where e.person_id = r.created_by) Employee_name',
'FROM',
'    btf_data_access_requests_approval_history h , btf_data_access_requests r',
'where h.request_id = r.id',
'and h.id = :P4_ID'))
,p_is_editable=>false
,p_plug_source_type=>'NATIVE_FORM'
,p_ajax_items_to_submit=>'P4_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(135747016573846575)
,p_plug_name=>'Approvals'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--noBorder:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       REQUEST_ID,',
'       STEP_NO,',
'       ACTION_REQUIRED,',
'--       pc.USER_NAME,',
'       STATUS,',
'       RECEVIED_DATE,',
'       ACTION_DATE,',
'       COMMENTS,',
'       APPROVAL_TYPE_id,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       e.full_name_en,',
'       case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                 ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'           end Photo',
'from btf_data_access_requests_approval_history pc,  dct_employees_list2  e',
'  where pc.person_id = e.person_id (+)',
'and  pc.REQUEST_ID = :P4_REQUEST_ID',
'order by step_no , ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P4_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P4_STATUS != ''Draft'''
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approvals'
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
 p_id=>wwv_flow_api.id(135747109739846576)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>241103438931209989
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109696470245597)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110152061245597)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110538243245597)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110925752245597)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111335717245597)
,p_db_column_name=>'STATUS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111739656245598)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112152405245598)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(112478463245598)
,p_db_column_name=>'COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113292015245598)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113742867245599)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114115940245599)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114543422245599)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114963392245599)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115354235245599)
,p_db_column_name=>'PHOTO'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86296795822907)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(135801400691239075)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1054720'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ACTION_REQUIRED:STATUS:RECEVIED_DATE:ACTION_DATE:COMMENTS::APPROVAL_TYPE_ID'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(116110219245600)
,p_report_id=>wwv_flow_api.id(135801400691239075)
,p_name=>'Pending'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Pending'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Pending''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D0F1CC'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(101098553245592)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(92523104479983624)
,p_button_name=>'Approve'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(101475771245593)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(92523104479983624)
,p_button_name=>'Reject'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(101929468245593)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(92523104479983624)
,p_button_name=>'Delegate'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_FROM_PERSON_ID,P5_HISTORY_ID,P5_REQUEST_ID,P5_PAGE_FROM,P5_COMMENT:&PERSON_ID.,&P4_HISTORY_ID.,&P4_ID.,4,&P4_APPROVER_COMMENT.'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(125872823245617)
,p_branch_name=>'Go to 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(85181240822896)
,p_name=>'P4_APPROVAL_TYPE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'APPROVAL_TYPE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(85272694822897)
,p_name=>'P4_ON_BEHALF'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'ON_BEHALF'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(85440019822898)
,p_name=>'P4_MORE_INFO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'MORE_INFO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(85517811822899)
,p_name=>'P4_OTP'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'OTP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(85621136822900)
,p_name=>'P4_OTP_TIME'
,p_source_data_type=>'TIMESTAMP_LTZ'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'OTP_TIME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(85715886822901)
,p_name=>'P4_OTP_COUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'OTP_COUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(85794933822902)
,p_name=>'P4_HASH_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'HASH_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(85920946822903)
,p_name=>'P4_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86054972822904)
,p_name=>'P4_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86151172822905)
,p_name=>'P4_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(86200331822906)
,p_name=>'P4_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(102283593245593)
,p_name=>'P4_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(92523104479983624)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(103016370245594)
,p_name=>'P4_EMPLOYEE_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_prompt=>'Employee Name'
,p_source=>'EMPLOYEE_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(103421086245594)
,p_name=>'P4_PROJECT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_prompt=>'Project'
,p_source=>'PRJECT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(103778119245594)
,p_name=>'P4_COMMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_prompt=>'End User Comment'
,p_source=>'COMMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(104261707245594)
,p_name=>'P4_START_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_prompt=>'Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'START_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(104664562245594)
,p_name=>'P4_END_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_prompt=>'End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'END_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(105042875245594)
,p_name=>'P4_ACTION_REQUIRED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_prompt=>'Action Required'
,p_source=>'ACTION_REQUIRED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(105425398245595)
,p_name=>'P4_RECEVIED_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_prompt=>'Received On:'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'RECEVIED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(105820055245595)
,p_name=>'P4_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(106263806245595)
,p_name=>'P4_APPROVER_COMMENT'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_prompt=>'Approver Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>100
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(106579305245595)
,p_name=>'P4_HISTORY_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'HISTORY_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(107056479245595)
,p_name=>'P4_REQUEST_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'REQUEST_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(107415524245595)
,p_name=>'P4_STEP_NO'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'STEP_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(107857040245596)
,p_name=>'P4_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(108229087245596)
,p_name=>'P4_ROLE_DESC'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'ROLE_DESC'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(108650264245596)
,p_name=>'P4_ACTION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(92562551041148065)
,p_item_source_plug_id=>wwv_flow_api.id(92562551041148065)
,p_source=>'ACTION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(122048587245615)
,p_name=>'Approve DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(101098553245592)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(122481866245615)
,p_event_id=>wwv_flow_api.id(122048587245615)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'your are going to Approve this request, Are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(123064069245616)
,p_event_id=>wwv_flow_api.id(122048587245615)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'btf_end_user_workflow.approve(:P4_HISTORY_ID, :PERSON_ID, :P4_APPROVER_COMMENT);'
,p_attribute_02=>'P4_HISTORY_ID,P4_APPROVER_COMMENT,PERSON_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(123473597245616)
,p_event_id=>wwv_flow_api.id(122048587245615)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(123873431245616)
,p_name=>'Reject DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(101475771245593)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(124385371245616)
,p_event_id=>wwv_flow_api.id(123873431245616)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'your are going to Reject this request, Are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(124916267245616)
,p_event_id=>wwv_flow_api.id(123873431245616)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'btf_end_user_workflow.reject(:P4_HISTORY_ID, :PERSON_ID, :P4_APPROVER_COMMENT);'
,p_attribute_02=>'P4_HISTORY_ID,P4_APPROVER_COMMENT'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(125372753245617)
,p_event_id=>wwv_flow_api.id(123873431245616)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(121576677245614)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    h.id        history_id,',
'    h.request_id,',
'    h.step_no,',
'    h.person_id,',
'    h.role_desc,',
'    h.action_required,',
'    to_char(h.recevied_date,''DD-MON-YYYY HH:MIPM'') recevied_date,',
'    h.status,',
'--    h.action_date,',
'    h.comments,',
'    h.approval_type_id,',
'--    h.on_behalf,',
'--    h.more_info,',
'--    h.otp,',
'--    h.otp_time,',
'--    h.otp_count,',
'--    h.hash_code,',
'--    h.created_on,',
'--    h.created_by,',
'--    h.updated_by,',
'--    h.updated_on,',
'    r.entity_name Prject,',
'    to_char(r.start_date,''DD-MON-YYYY'') start_date,',
'    r.end_date,',
'    r.comments,',
'    (select e.full_name_en',
'     from employees_v e',
'     where e.person_id = r.created_by) Employee_name',
'    into ',
'        :P4_HISTORY_ID, :p4_REQUEST_ID, :P4_STEP_NO, :P4_PERSON_ID, :P4_ROLE_DESC, :P4_ACTION_REQUIRED, :P4_RECEVIED_DATE, :P4_STATUS, :P4_APPROVER_COMMENT, :P4_APPROVAL_TYPE_ID, :P4_PROJECT, :P4_START_DATE, :P4_END_DATE, :P4_COMMENTS',
'        , :P4_EMPLOYEE_NAME',
'FROM',
'    btf_data_access_requests_approval_history h , btf_data_access_requests r',
'where h.request_id = r.id',
'and h.id = :P4_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
