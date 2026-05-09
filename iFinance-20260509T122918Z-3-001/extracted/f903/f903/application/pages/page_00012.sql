prompt --application/pages/page_00012
begin
--   Manifest
--     PAGE: 00012
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_page(
 p_id=>12
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'BTF Approve / Reject'
,p_step_title=>'BTF Approve / Reject'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'ON'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Scroll Results Only in Side Column */',
'.t-Body-side {',
'    display: flex;',
'    flex-direction: column;',
'    overflow: hidden;',
'}',
'.search-results {',
'    flex: 1;',
'    overflow: auto;',
'}',
'/* Format Search Region */',
'.search-region {',
'    border-bottom: 1px solid rgba(0,0,0,.1);',
'    flex-shrink: 0;',
'}',
'',
'.t-Region-header{',
'background-color:#0e6655;',
'    color:#FFFFFF;',
'}',
'.t-Region-title{',
'    color:#FFFFFF;',
'    font-weighfont-weight: bold;',
'}',
'',
'/* Set Header Panel */',
'.t-Header-branding {',
'    background-color: #0e6655;',
'}',
'',
'',
'/* Set Breadcrumb   */',
'.t-Body-title {',
'',
'    background-color: #EEE;',
'    color:#404040;',
'}',
'',
'/* Add Button - White */',
'.t-Region-header, .t-Region-header .t-Button--link, .t-Region-header .t-Button--noUI {',
'    color:  #FFF;',
'}',
'',
'/* New Plan Button */',
'.a-Button--hot, .t-Button--hot:not(.t-Button--simple), body .ui-button.ui-button--hot, body .ui-state-default.ui-priority-primary {',
'',
'    background-color: #0e6655;',
'    color:#fff;',
'}',
'',
'',
'/*  Table Row Selected */',
'.a-GV-table tr.is-selected .a-GV-cell {',
'    background-color: #CEF6CE;',
'}',
'',
'/* Audit Region */',
'#history    .t-Region-header {',
'     background-color: #f3f0ef;',
'    color:#000;',
'}',
'',
'',
''))
,p_step_template=>wwv_flow_api.id(65513403179255734)
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This report page displays primary records in a selector on the side of the page. ',
'  Select a record to see the master record and any detail records defined.<br> ',
'  Click the edit icon ( <span class="fa fa-pencil-square-o" aria-hidden="true"></span> ) to edit the master record.',
'  For detail records, click the pencil, at the beginning of each row, to edit that record.</p>',
'<p>To limit the data displayed in the selector enter a search term into the search dialog.</p>',
'',
'<p>To add a new master record click <strong>Create</strong> at the top of the page.',
'  For detail records, click the plus icon ( + ) at the top of the detail region to add a detail record.</p>',
'',
'<p>Click <strong>Reset</strong> at the top of the page to reset the page back to the default settings, removing any search term previously defined.</p>'))
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200531224634'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6881421689805424)
,p_plug_name=>'<b>Similar Requests</b>'
,p_icon_css_classes=>'fa-braille fam-check fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>100
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6881580287805425)
,p_plug_name=>'Similar Requests Report'
,p_parent_plug_id=>wwv_flow_api.id(6881421689805424)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'SELECT',
'    form_no,',
'    line_no,',
'    decode(from_to,''FROM'' , ''Deduct'' , ''Addition'' ) "Add / Ded",',
'    project_number,',
'    project_name,',
'    task_number,',
'    cost_center,',
'    gl_account,',
'    budget,',
'    fund_available,',
'    transferred_amount,',
'    balance_after,',
'    created_by,',
'    updated_by,',
'    creation_date,',
'    updated_date,',
'    line_id,',
'    tca_sector,',
'    department,',
'    strategic,',
'    program,',
'    output,',
'    actual,',
'    encumbrances,',
'    justification,',
'    purpose_eu,',
'    source,',
'    request_id,',
'    pending',
'    ,(select h.status',
'        from btf_header h',
'        where h.form_no = btf_lines.form_no) status',
'    ,(select h.finance_status',
'        from btf_header h',
'        where h.form_no = btf_lines.form_no) finance_status',
'       ,(select h.form_date',
'        from btf_header h',
'        where h.form_no = btf_lines.form_no) form_date     ',
'FROM',
'    btf_lines',
'where project_number not in (select project_number ',
'                                from btf_lines',
'                                where form_no = :P12_FORM_NO)',
'and task_number not in (select task_number ',
'                            from btf_lines',
'                            where form_no = :P12_FORM_NO )',
'and gl_account not in (select gl_account',
'                            from btf_lines',
'                            where form_no = :P12_FORM_NO)',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Similar Requests Report'
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
 p_id=>wwv_flow_api.id(6881710542805427)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>6881710542805427
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6881877259805428)
,p_db_column_name=>'FORM_NO'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Form No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6881970349805429)
,p_db_column_name=>'LINE_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Line No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6882087399805430)
,p_db_column_name=>'Add / Ded'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Add &#x2F; Ded'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6882149647805431)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6882257436805432)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6882358230805433)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6882462421805434)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6882517603805435)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6882636852805436)
,p_db_column_name=>'BUDGET'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6882730624805437)
,p_db_column_name=>'FUND_AVAILABLE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Fund Available'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6882833149805438)
,p_db_column_name=>'TRANSFERRED_AMOUNT'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Transferred Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6882957420805439)
,p_db_column_name=>'BALANCE_AFTER'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Balance After'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6883096766805440)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6883114560805441)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6883228551805442)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6883338047805443)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6883448461805444)
,p_db_column_name=>'LINE_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6883563559805445)
,p_db_column_name=>'TCA_SECTOR'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Tca Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6883607755805446)
,p_db_column_name=>'DEPARTMENT'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6883776483805447)
,p_db_column_name=>'STRATEGIC'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Strategic'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6883808295805448)
,p_db_column_name=>'PROGRAM'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Program'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6883998342805449)
,p_db_column_name=>'OUTPUT'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Output'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6884007356805450)
,p_db_column_name=>'ACTUAL'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Actual'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6949887959128801)
,p_db_column_name=>'ENCUMBRANCES'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Encumbrances'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6949997808128802)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6950010888128803)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Purpose Eu'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6950142583128804)
,p_db_column_name=>'SOURCE'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Source'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6950276552128805)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6950374939128806)
,p_db_column_name=>'PENDING'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Pending'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6950664542128809)
,p_db_column_name=>'FORM_DATE'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Form Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6950782128128810)
,p_db_column_name=>'STATUS'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'DOA Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6950835650128811)
,p_db_column_name=>'FINANCE_STATUS'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Finance Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(6964874318129973)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'69649'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FORM_NO:FORM_DATE:PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:DEPARTMENT:GL_ACCOUNT:Add / Ded:JUSTIFICATION:TRANSFERRED_AMOUNT::STATUS:FINANCE_STATUS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(133212841744365720)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65554277731255756)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(65494572154255667)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(65602363670255785)
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(133258925298524891)
,p_name=>'<b>Budget deduction Lines</b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_icon_css_classes=>'fa-cart-arrow-up fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'BTF_LINES'
,p_query_where=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FORM_NO = :P12_FORM_NO',
'and FROM_TO = ''FROM'''))
,p_query_order_by=>'LINE_NO'
,p_include_rowid_column=>false
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(65567986443255766)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6954371392128846)
,p_query_column_id=>1
,p_column_alias=>'FORM_NO'
,p_column_display_sequence=>18
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6954457071128847)
,p_query_column_id=>2
,p_column_alias=>'LINE_NO'
,p_column_display_sequence=>2
,p_column_heading=>'Line No'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6954597700128848)
,p_query_column_id=>3
,p_column_alias=>'FROM_TO'
,p_column_display_sequence=>19
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6954680764128849)
,p_query_column_id=>4
,p_column_alias=>'PROJECT_NUMBER'
,p_column_display_sequence=>4
,p_column_heading=>'Project Number'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6954723131128850)
,p_query_column_id=>5
,p_column_alias=>'PROJECT_NAME'
,p_column_display_sequence=>16
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7013071905736201)
,p_query_column_id=>6
,p_column_alias=>'TASK_NUMBER'
,p_column_display_sequence=>5
,p_column_heading=>'Task Number'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7013121283736202)
,p_query_column_id=>7
,p_column_alias=>'COST_CENTER'
,p_column_display_sequence=>6
,p_column_heading=>'Cost Center'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7013248084736203)
,p_query_column_id=>8
,p_column_alias=>'GL_ACCOUNT'
,p_column_display_sequence=>7
,p_column_heading=>'Gl Account'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7013306452736204)
,p_query_column_id=>9
,p_column_alias=>'BUDGET'
,p_column_display_sequence=>9
,p_column_heading=>'Budget'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7013424299736205)
,p_query_column_id=>10
,p_column_alias=>'FUND_AVAILABLE'
,p_column_display_sequence=>12
,p_column_heading=>'Fund Available'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7013556918736206)
,p_query_column_id=>11
,p_column_alias=>'TRANSFERRED_AMOUNT'
,p_column_display_sequence=>13
,p_column_heading=>'Transferred Amount'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7013687080736207)
,p_query_column_id=>12
,p_column_alias=>'BALANCE_AFTER'
,p_column_display_sequence=>15
,p_column_heading=>'Balance After'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7013778062736208)
,p_query_column_id=>13
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>22
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7013847659736209)
,p_query_column_id=>14
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>23
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7013994114736210)
,p_query_column_id=>15
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>24
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7014007679736211)
,p_query_column_id=>16
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>25
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7014163002736212)
,p_query_column_id=>17
,p_column_alias=>'LINE_ID'
,p_column_display_sequence=>1
,p_column_heading=>'<span class="u-VisuallyHidden">show</span>'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.::P40_LINE_ID,P40_PROJECT_NUMBER_H,P40_LINE_ID_H,P40_TASK_NUMBER_H,P40_COST_CENTER_H,P40_GL_ACCOUNT_H:#LINE_ID#,#PROJECT_NUMBER#,#LINE_ID#,#TASK_NUMBER#,#COST_CENTER#,#GL_ACCOUNT#'
,p_column_linktext=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil-alt.png" class="apex-edit-pencil-alt" alt="">'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7014255084736213)
,p_query_column_id=>18
,p_column_alias=>'TCA_SECTOR'
,p_column_display_sequence=>17
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7014321408736214)
,p_query_column_id=>19
,p_column_alias=>'DEPARTMENT'
,p_column_display_sequence=>3
,p_column_heading=>'Department'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7014473178736215)
,p_query_column_id=>20
,p_column_alias=>'STRATEGIC'
,p_column_display_sequence=>20
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7014576617736216)
,p_query_column_id=>21
,p_column_alias=>'PROGRAM'
,p_column_display_sequence=>21
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7014642972736217)
,p_query_column_id=>22
,p_column_alias=>'OUTPUT'
,p_column_display_sequence=>28
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7014717766736218)
,p_query_column_id=>23
,p_column_alias=>'ACTUAL'
,p_column_display_sequence=>11
,p_column_heading=>'Actual'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7014896793736219)
,p_query_column_id=>24
,p_column_alias=>'ENCUMBRANCES'
,p_column_display_sequence=>10
,p_column_heading=>'Encumbrances'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7014992959736220)
,p_query_column_id=>25
,p_column_alias=>'JUSTIFICATION'
,p_column_display_sequence=>8
,p_column_heading=>'Justification'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7015023642736221)
,p_query_column_id=>26
,p_column_alias=>'PURPOSE_EU'
,p_column_display_sequence=>27
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7015126562736222)
,p_query_column_id=>27
,p_column_alias=>'SOURCE'
,p_column_display_sequence=>26
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7015273405736223)
,p_query_column_id=>28
,p_column_alias=>'REQUEST_ID'
,p_column_display_sequence=>29
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7015360386736224)
,p_query_column_id=>29
,p_column_alias=>'PENDING'
,p_column_display_sequence=>14
,p_column_heading=>'Pending'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(133324934790309773)
,p_name=>'<b>Budget Addition Lines</b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_icon_css_classes=>'fa-cart-arrow-down fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--inline'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select FORM_NO,',
'       LINE_NO,',
'       FROM_TO,',
'       PROJECT_NUMBER,',
'       PROJECT_NAME,',
'       TASK_NUMBER,',
'       COST_CENTER,',
'       GL_ACCOUNT,',
'       BUDGET,',
'       FUND_AVAILABLE,',
'       TRANSFERRED_AMOUNT,',
'       BALANCE_AFTER,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATION_DATE,',
'       UPDATED_DATE,',
'       LINE_ID,',
'       TCA_SECTOR,',
'       DEPARTMENT,',
'       STRATEGIC,',
'       PROGRAM,',
'       OUTPUT,',
'       ACTUAL,',
'       ENCUMBRANCES,',
'       JUSTIFICATION,',
'       PURPOSE_EU,',
'       SOURCE,',
'       REQUEST_ID,',
'       PENDING',
'  from BTF_LINES',
' where FORM_NO = :P12_FORM_NO',
'and FROM_TO = ''TO'''))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(65567986443255766)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66823896295645309)
,p_query_column_id=>1
,p_column_alias=>'FORM_NO'
,p_column_display_sequence=>16
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66824281859645309)
,p_query_column_id=>2
,p_column_alias=>'LINE_NO'
,p_column_display_sequence=>2
,p_column_heading=>'Line No'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.::P30_LINE_ID,P30_FROM_TO_X_1,P30_STATUS:#LINE_ID#,TO,&P12_STATUS.'
,p_column_linktext=>'#LINE_NO#'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66824689864645309)
,p_query_column_id=>3
,p_column_alias=>'FROM_TO'
,p_column_display_sequence=>17
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66825014489645309)
,p_query_column_id=>4
,p_column_alias=>'PROJECT_NUMBER'
,p_column_display_sequence=>4
,p_column_heading=>'Project Number'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66825444520645309)
,p_query_column_id=>5
,p_column_alias=>'PROJECT_NAME'
,p_column_display_sequence=>19
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66825812400645309)
,p_query_column_id=>6
,p_column_alias=>'TASK_NUMBER'
,p_column_display_sequence=>5
,p_column_heading=>'Task Number'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66826245373645309)
,p_query_column_id=>7
,p_column_alias=>'COST_CENTER'
,p_column_display_sequence=>6
,p_column_heading=>'Cost Center'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66826609217645310)
,p_query_column_id=>8
,p_column_alias=>'GL_ACCOUNT'
,p_column_display_sequence=>7
,p_column_heading=>'Gl Account'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66827011020645310)
,p_query_column_id=>9
,p_column_alias=>'BUDGET'
,p_column_display_sequence=>9
,p_column_heading=>'Budget'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66827412717645310)
,p_query_column_id=>10
,p_column_alias=>'FUND_AVAILABLE'
,p_column_display_sequence=>12
,p_column_heading=>'Fund Available'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66828663507645311)
,p_query_column_id=>11
,p_column_alias=>'TRANSFERRED_AMOUNT'
,p_column_display_sequence=>13
,p_column_heading=>'Transferred Amount'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66829081901645311)
,p_query_column_id=>12
,p_column_alias=>'BALANCE_AFTER'
,p_column_display_sequence=>15
,p_column_heading=>'Balance After'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66829469496645311)
,p_query_column_id=>13
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>20
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66829807542645311)
,p_query_column_id=>14
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>21
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66830281588645311)
,p_query_column_id=>15
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>22
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66830601575645311)
,p_query_column_id=>16
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>23
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66831035784645312)
,p_query_column_id=>17
,p_column_alias=>'LINE_ID'
,p_column_display_sequence=>1
,p_column_heading=>'<span class="u-VisuallyHidden">Edit</span>'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.::P40_LINE_ID,P40_PROJECT_NUMBER_H,P40_LINE_ID_H,P40_TASK_NUMBER_H,P40_GL_ACCOUNT_H:#LINE_ID#,#PROJECT_NUMBER#,#LINE_ID#,#TASK_NUMBER#,#GL_ACCOUNT#'
,p_column_linktext=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil-alt.png" class="apex-edit-pencil-alt" alt="">'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66831435377645312)
,p_query_column_id=>18
,p_column_alias=>'TCA_SECTOR'
,p_column_display_sequence=>18
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66831889309645312)
,p_query_column_id=>19
,p_column_alias=>'DEPARTMENT'
,p_column_display_sequence=>3
,p_column_heading=>'Department'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66832213567645312)
,p_query_column_id=>20
,p_column_alias=>'STRATEGIC'
,p_column_display_sequence=>24
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66832686021645312)
,p_query_column_id=>21
,p_column_alias=>'PROGRAM'
,p_column_display_sequence=>25
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66833037768645312)
,p_query_column_id=>22
,p_column_alias=>'OUTPUT'
,p_column_display_sequence=>26
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66827827636645310)
,p_query_column_id=>23
,p_column_alias=>'ACTUAL'
,p_column_display_sequence=>11
,p_column_heading=>'Actual'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66828298325645311)
,p_query_column_id=>24
,p_column_alias=>'ENCUMBRANCES'
,p_column_display_sequence=>10
,p_column_heading=>'Encumbrances'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7015454093736225)
,p_query_column_id=>25
,p_column_alias=>'JUSTIFICATION'
,p_column_display_sequence=>8
,p_column_heading=>'Justification'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7015593936736226)
,p_query_column_id=>26
,p_column_alias=>'PURPOSE_EU'
,p_column_display_sequence=>27
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7015601811736227)
,p_query_column_id=>27
,p_column_alias=>'SOURCE'
,p_column_display_sequence=>28
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7015795003736228)
,p_query_column_id=>28
,p_column_alias=>'REQUEST_ID'
,p_column_display_sequence=>29
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7015889574736229)
,p_query_column_id=>29
,p_column_alias=>'PENDING'
,p_column_display_sequence=>14
,p_column_heading=>'Pending'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(198800329068621449)
,p_name=>'<b>Transfer Request Header </b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>30
,p_region_css_classes=>'js-master-region'
,p_icon_css_classes=>'fa-braille fam-check fam-is-success'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-AVPList--leftAligned'
,p_grid_column_span=>7
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select FORM_NO,',
'       REVISION_NO,',
'       ORACLE_APPROVAL1,',
'       ORACLE_APPROVAL2,',
'       ORACLE_HYPERION,',
'       CREATION_DATE,',
'       CREATED_BY,',
'       REASON,',
'       BTF_NO,',
'       STATUS,',
'       UPDATED_BY,',
'       UPDATED_DATE,',
'       YEAR,',
'       SECTOR,',
'       priority,',
'       form_date,',
'       due_date',
'  from BTF_HEADER',
'  where "FORM_NO" = :P12_FORM_NO'))
,p_display_when_condition=>'P12_FORM_NO'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(65562578975255763)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_no_data_found=>'No Record Selected'
,p_query_row_count_max=>500
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66797829259645275)
,p_query_column_id=>1
,p_column_alias=>'FORM_NO'
,p_column_display_sequence=>1
,p_column_heading=>'Form No'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "FORM_NO" is not null',
'and "FORM_NO" = :P12_FORM_NO'))
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66798225621645276)
,p_query_column_id=>2
,p_column_alias=>'REVISION_NO'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "REVISION_NO" is not null',
'and "FORM_NO" = :P12_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66802291973645278)
,p_query_column_id=>3
,p_column_alias=>'ORACLE_APPROVAL1'
,p_column_display_sequence=>15
,p_hidden_column=>'Y'
,p_report_column_required_role=>wwv_flow_api.id(70397243083858530)
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66802619284645278)
,p_query_column_id=>4
,p_column_alias=>'ORACLE_APPROVAL2'
,p_column_display_sequence=>16
,p_hidden_column=>'Y'
,p_report_column_required_role=>wwv_flow_api.id(70397243083858530)
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66803028053645278)
,p_query_column_id=>5
,p_column_alias=>'ORACLE_HYPERION'
,p_column_display_sequence=>17
,p_hidden_column=>'Y'
,p_report_column_required_role=>wwv_flow_api.id(70397243083858530)
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66798611721645276)
,p_query_column_id=>6
,p_column_alias=>'CREATION_DATE'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "CREATION_DATE" is not null',
'and "FORM_NO" = :P12_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66799038460645277)
,p_query_column_id=>7
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "CREATED_BY" is not null',
'and "FORM_NO" = :P12_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66799455173645277)
,p_query_column_id=>8
,p_column_alias=>'REASON'
,p_column_display_sequence=>7
,p_column_heading=>'Reason'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "REASON" is not null',
'and "FORM_NO" = :P12_FORM_NO'))
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66799827484645277)
,p_query_column_id=>9
,p_column_alias=>'BTF_NO'
,p_column_display_sequence=>2
,p_column_heading=>'BTF No'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "BTF_NO" is not null',
'and "FORM_NO" = :P12_FORM_NO'))
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66800225472645277)
,p_query_column_id=>10
,p_column_alias=>'STATUS'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "STATUS" is not null',
'and "FORM_NO" = :P12_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66800683575645277)
,p_query_column_id=>11
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>12
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "UPDATED_BY" is not null',
'and "FORM_NO" = :P12_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66801060542645277)
,p_query_column_id=>12
,p_column_alias=>'UPDATED_DATE'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "UPDATED_DATE" is not null',
'and "FORM_NO" = :P12_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66801447087645278)
,p_query_column_id=>13
,p_column_alias=>'YEAR'
,p_column_display_sequence=>14
,p_hidden_column=>'Y'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1 from "BTF_HEADER"',
'where "YEAR" is not null',
'and "FORM_NO" = :P12_FORM_NO'))
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66801829152645278)
,p_query_column_id=>14
,p_column_alias=>'SECTOR'
,p_column_display_sequence=>6
,p_column_heading=>'Sector'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76157796611095346)
,p_query_column_id=>15
,p_column_alias=>'PRIORITY'
,p_column_display_sequence=>5
,p_column_heading=>'Priority'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6951129482128814)
,p_query_column_id=>16
,p_column_alias=>'FORM_DATE'
,p_column_display_sequence=>3
,p_column_heading=>'Form Date'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6951291917128815)
,p_query_column_id=>17
,p_column_alias=>'DUE_DATE'
,p_column_display_sequence=>4
,p_column_heading=>'Due Date'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(198836042687621539)
,p_plug_name=>'Region Display Selector'
,p_region_css_classes=>'js-detail-rds'
,p_region_template_options=>'#DEFAULT#:margin-bottom-md'
,p_plug_template=>wwv_flow_api.id(65519636948255743)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_DISPLAY_SELECTOR'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P12_FORM_NO'
,p_attribute_01=>'STANDARD'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(199111606995060164)
,p_plug_name=>'<b>Request Summary </b>'
,p_icon_css_classes=>'fa-window-check'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--scrollBody:t-Form--labelsAbove'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(199188825366857360)
,p_plug_name=>'<b><font color="black">Audit Info</font></b>'
,p_region_name=>'history'
,p_parent_plug_id=>wwv_flow_api.id(199111606995060164)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65530067520255748)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(199189375449857365)
,p_plug_name=>'<b>Documents</b>'
,p_icon_css_classes=>'fa-book fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>80
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(199189764365857369)
,p_plug_name=>'Documents Table'
,p_parent_plug_id=>wwv_flow_api.id(199189375449857365)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>8
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       FORM_NO,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       TAGS,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from BTF_DOCUMENTS',
' where form_no = :P12_FORM_NO',
' order by created desc',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>8.5
,p_prn_height=>11
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#9bafde'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'normal'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#efefef'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(199189867290857370)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_filter=>'N'
,p_show_control_break=>'N'
,p_show_highlight=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_show_download=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>199189867290857370
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66808991455645290)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66809309883645293)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66809771862645294)
,p_db_column_name=>'FORM_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Form No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66810162520645294)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66810526468645294)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66810996505645294)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66811383800645295)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'OTHER'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66811721046645295)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'File Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66812134601645297)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66812573386645297)
,p_db_column_name=>'CREATED'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66812979283645297)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66813393713645298)
,p_db_column_name=>'UPDATED'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'Y'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66813750504645298)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66814164358645298)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66814533997645298)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:BTF_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(199268958214987038)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'668149'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:TAGS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(199386446996758765)
,p_name=>'<b>Approval History</b>'
,p_template=>wwv_flow_api.id(65544848715255753)
,p_display_sequence=>90
,p_include_in_reg_disp_sel_yn=>'Y'
,p_icon_css_classes=>'fa-eye fa-anim-flash'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       FORM_NO,',
'       STEP_NO,',
'       POSITION,',
'       ENTITY_TYPE,',
'       ENTITY_NAME,',
'       ACTION_REQUIRED,',
'       USER_NAME,',
'       STATUS,',
'       RECEVIED_DATE,',
'       ACTION_DATE,',
'       COMMENTS,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON',
'  from BTF_APPROVAL_HISTORY',
' where form_no = :P12_FORM_NO',
'order by step_no , recevied_date'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(65567986443255766)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66815650097645302)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>1
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66816019260645303)
,p_query_column_id=>2
,p_column_alias=>'FORM_NO'
,p_column_display_sequence=>2
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66816410983645303)
,p_query_column_id=>3
,p_column_alias=>'STEP_NO'
,p_column_display_sequence=>3
,p_column_heading=>'No'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66816820983645304)
,p_query_column_id=>4
,p_column_alias=>'POSITION'
,p_column_display_sequence=>4
,p_column_heading=>'Position'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66817231371645304)
,p_query_column_id=>5
,p_column_alias=>'ENTITY_TYPE'
,p_column_display_sequence=>5
,p_column_heading=>'Entity Type'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66817671877645304)
,p_query_column_id=>6
,p_column_alias=>'ENTITY_NAME'
,p_column_display_sequence=>6
,p_column_heading=>'Entity Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66818073741645304)
,p_query_column_id=>7
,p_column_alias=>'ACTION_REQUIRED'
,p_column_display_sequence=>7
,p_column_heading=>'Action Required'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66818420389645304)
,p_query_column_id=>8
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>8
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66818813109645304)
,p_query_column_id=>9
,p_column_alias=>'STATUS'
,p_column_display_sequence=>9
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66819248159645305)
,p_query_column_id=>10
,p_column_alias=>'RECEVIED_DATE'
,p_column_display_sequence=>10
,p_column_heading=>'Recevied Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66819646861645305)
,p_query_column_id=>11
,p_column_alias=>'ACTION_DATE'
,p_column_display_sequence=>11
,p_column_heading=>'Action Date'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH:MIPM'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66820078200645305)
,p_query_column_id=>12
,p_column_alias=>'COMMENTS'
,p_column_display_sequence=>12
,p_column_heading=>'Comment'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66820410789645305)
,p_query_column_id=>13
,p_column_alias=>'CREATED_ON'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66820802137645305)
,p_query_column_id=>14
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>14
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66821231373645305)
,p_query_column_id=>15
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>15
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(66821628956645305)
,p_query_column_id=>16
,p_column_alias=>'UPDATED_ON'
,p_column_display_sequence=>16
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66822746355645306)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(133212841744365720)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Transfer Request'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:RP,3::'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66823183570645306)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(133212841744365720)
,p_button_name=>'SUBMIT'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_image_alt=>'Submit'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_button_condition_type=>'NEVER'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66822328602645306)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(133212841744365720)
,p_button_name=>'RESET'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft:t-Button--gapRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_image_alt=>'Reset'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.:RESET:&DEBUG.:RP,2::'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66808286261645287)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(199189375449857365)
,p_button_name=>'Add_file'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600261178255783)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add File'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:RP,6:P6_FORM_NO:&P12_FORM_NO.'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66833428077645312)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(133324934790309773)
,p_button_name=>'POP_TO_BTF_LINES'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(65600261178255783)
,p_button_image_alt=>'Add Transfer To Line'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::P10_FORM_NO:&P12_FORM_NO.'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66843764071645316)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(133258925298524891)
,p_button_name=>'POP_BTF_FROM_LINES_'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>wwv_flow_api.id(65600261178255783)
,p_button_image_alt=>'Add Transfer From Line'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:RP,4:P4_FORM_NO:&P12_FORM_NO.'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66803401525645279)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(198800329068621449)
,p_button_name=>'EDIT'
,p_button_static_id=>'edit_master_btn'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_image_alt=>'Edit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:RP,3:P3_FORM_NO:&P12_FORM_NO.'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-pencil-square-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66749093152549040)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(133212841744365720)
,p_button_name=>'Approve'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-check-square'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66749150494549041)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(133212841744365720)
,p_button_name=>'Reject'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-times-square'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70161254242914638)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(133212841744365720)
,p_button_name=>'Delegat'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_image_alt=>'Delegat'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:19:&SESSION.::&DEBUG.:RP,19:P19_FORM_NO:&P12_FORM_NO.'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(70268921736206618)
,p_branch_name=>'Go to Home'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6950962855128812)
,p_name=>'P12_FINANCE_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(199111606995060164)
,p_item_default=>'Draft'
,p_prompt=>'Finance Status'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.STATUS as STATUS ',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P12_FORM_NO'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66803894997645281)
,p_name=>'P12_FORM_NO'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(198800329068621449)
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66804883400645285)
,p_name=>'P12_TOTAL_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(199111606995060164)
,p_prompt=>'Total deduction (From Amount)'
,p_post_element_text=>'AED'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_column_css_classes=>'u-danger-text'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66805210267645285)
,p_name=>'P12_TOTAL_TO_AMOUNT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(199111606995060164)
,p_prompt=>'Total Addition (To Amount)'
,p_post_element_text=>'AED'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_grid_column_css_classes=>'u-success-text'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66805601057645285)
,p_name=>'P12_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(199111606995060164)
,p_item_default=>'Draft'
,p_prompt=>'Status'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.STATUS as STATUS ',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P12_FORM_NO'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66806327085645286)
,p_name=>'P12_CREATED_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(199188825366857360)
,p_prompt=>'Created By'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.CREATED_BY as CREATED_BY ',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P12_FORM_NO'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66806792733645286)
,p_name=>'P12_CREATED_ON'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(199188825366857360)
,p_prompt=>'Created ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.CREATION_DATE as CREATION_DATE',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P12_FORM_NO'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66807145513645286)
,p_name=>'P12_UPDATED_BY'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(199188825366857360)
,p_prompt=>'Updated By'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.UPDATED_BY as UPDATED_BY',
'from BTF_HEADER BTF_HEADER',
' where form_no = :P12_FORM_NO'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66807567222645287)
,p_name=>'P12_UPDATED_ON'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(199188825366857360)
,p_prompt=>'Updated ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.UPDATED_DATE as UPDATED_DATE',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P12_FORM_NO'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70268033427206609)
,p_name=>'P12_COMMENT'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(199111606995060164)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>40
,p_cHeight=>3
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70375018041331721)
,p_name=>'P12_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(198800329068621449)
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(70375263315331723)
,p_computation_sequence=>40
,p_computation_item=>'P12_ID'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select h.Id',
'from btf_approval_history h',
'where h.form_no = :P12_FORM_NO',
'and h.user_name = :APP_USER',
'and h.status = ''Pending'''))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(66844570128645324)
,p_computation_sequence=>10
,p_computation_item=>'P12_TOTAL_FROM'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0),''99,999,999.99'')',
'    --nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0) as TRANSFERRED_AMOUNT ',
' from BTF_LINES BTF_LINES',
'where FoRM_NO = :P12_FORM_NO',
'and from_to = ''FROM'''))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(66844941737645325)
,p_computation_sequence=>20
,p_computation_item=>'P12_TOTAL_TO_AMOUNT'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0),''99,999,999.99'')',
'    --nvl(sum(BTF_LINES.TRANSFERRED_AMOUNT),0) as TRANSFERRED_AMOUNT ',
' from BTF_LINES BTF_LINES',
'where FoRM_NO = :P12_FORM_NO',
'and from_to = ''TO'''))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(66845371882645325)
,p_computation_sequence=>30
,p_computation_item=>'P12_STATUS'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.STATUS as STATUS ',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P12_FORM_NO'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(6951022555128813)
,p_computation_sequence=>40
,p_computation_item=>'P12_FINANCE_STATUS'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select BTF_HEADER.finance_STATUS as STATUS ',
' from BTF_HEADER BTF_HEADER',
' where form_no = :P12_FORM_NO'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66848425959645327)
,p_name=>'Edit Master Record'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(198800329068621449)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66848917355645328)
,p_event_id=>wwv_flow_api.id(66848425959645327)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(198800329068621449)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66849406101645328)
,p_event_id=>wwv_flow_api.id(66848425959645327)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(''Btf\u0020Header\u0020updated'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66849803268645328)
,p_name=>'Perform Search'
,p_event_sequence=>150
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P12_SEARCH'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === apex.jQuery.ui.keyCode.ENTER'
,p_bind_type=>'bind'
,p_bind_event_type=>'keypress'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66850351135645328)
,p_event_id=>wwv_flow_api.id(66849803268645328)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CANCEL_EVENT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66846073191645326)
,p_name=>'Submit BTF'
,p_event_sequence=>250
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(66823183570645306)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66848080618645327)
,p_event_id=>wwv_flow_api.id(66846073191645326)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to submit this budget transfer request?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66846537253645327)
,p_event_id=>wwv_flow_api.id(66846073191645326)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'BTF_WORKFLOW.INSERT_SUBMIT_USER(:P12_FORM_NO);',
'BTF_WORKFLOW.insert_dept_from_appr(:P12_FORM_NO);',
'BTF_WORKFLOW.insert_dept_to_appr(:P12_FORM_NO);',
'BTF_WORKFLOW.INSERT_FIN_DEPT_APPR(:P12_FORM_NO);',
'BTF_WORKFLOW.INSERT_ED_APPR(:P12_FORM_NO);',
'BTF_WORKFLOW.INSERT_BUDGET_APPR(:P12_FORM_NO);',
'BTF_WORKFLOW.INSERT_FBP_FYI(:P12_FORM_NO);',
'end;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66847551587645327)
,p_event_id=>wwv_flow_api.id(66846073191645326)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Budget Transfer Request has been submitted successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66847024180645327)
,p_event_id=>wwv_flow_api.id(66846073191645326)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66850788460645329)
,p_name=>'Refresh on Dialog Close -From Lines'
,p_event_sequence=>260
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(133258925298524891)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66851781716645329)
,p_event_id=>wwv_flow_api.id(66850788460645329)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(133258925298524891)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66851296345645329)
,p_event_id=>wwv_flow_api.id(66850788460645329)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(''Line Added'');'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66852274180645329)
,p_event_id=>wwv_flow_api.id(66850788460645329)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(133212841744365720)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66852653913645329)
,p_name=>'Refresh on Dialog Close -To Lines'
,p_event_sequence=>270
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(133324934790309773)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66853135924645330)
,p_event_id=>wwv_flow_api.id(66852653913645329)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(''Line Added'');'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66853689174645331)
,p_event_id=>wwv_flow_api.id(66852653913645329)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(133324934790309773)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66749263183549042)
,p_name=>'Approve DA'
,p_event_sequence=>280
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(66749093152549040)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66749326935549043)
,p_event_id=>wwv_flow_api.id(66749263183549042)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure to approve ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66749432137549044)
,p_event_id=>wwv_flow_api.id(66749263183549042)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'BTF_WORKFLOW.APPROVE_BTF(:P12_FORM_NO , :APP_USER);',
'',
'end;'))
,p_attribute_02=>'P12_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70375470208331725)
,p_event_id=>wwv_flow_api.id(66749263183549042)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update btf_approval_history',
'set comments = :P12_COMMENT',
'where  id = :P12_ID ;'))
,p_attribute_02=>'P12_ID,P12_COMMENT'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66749547147549045)
,p_event_id=>wwv_flow_api.id(66749263183549042)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Approved Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70268858400206617)
,p_event_id=>wwv_flow_api.id(66749263183549042)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(66749700374549047)
,p_name=>'Reject DA'
,p_event_sequence=>290
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(66749150494549041)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66749806376549048)
,p_event_id=>wwv_flow_api.id(66749700374549047)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to cancel this BTF, Are you sure ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66749989718549049)
,p_event_id=>wwv_flow_api.id(66749700374549047)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'BTF_WORKFLOW.REJECT_BTF(:P12_FORM_NO , :APP_USER);',
'end;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70375545953331726)
,p_event_id=>wwv_flow_api.id(66749700374549047)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'update btf_approval_history',
'set comments = :P12_COMMENT',
'where  id = :P12_ID ;'))
,p_attribute_02=>'P12_ID,P12_COMMENT'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(66750046821549050)
,p_event_id=>wwv_flow_api.id(66749700374549047)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'BTF has been Rejected Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(70269096213206619)
,p_event_id=>wwv_flow_api.id(66749700374549047)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(66845694744645325)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_01=>'P12_FORM_NO,REQUEST'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
wwv_flow_api.component_end;
end;
/
