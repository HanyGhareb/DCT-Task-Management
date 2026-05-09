prompt --application/pages/page_00013
begin
--   Manifest
--     PAGE: 00013
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
 p_id=>13
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'Available to Oracle'
,p_step_title=>'Available to Oracle'
,p_autocomplete_on_off=>'OFF'
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
''))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200223133414'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(66886946020612410)
,p_plug_name=>'<b>Available to Oracle By Projects</b>'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  project_number  , ',
'        project_name , ',
'        task_number , ',
'        gl_account , ',
'        (select p.account_name',
'         from f_projectbudget p',
'         where p.natural_account = gl_account and ROWNUM <2) Account_name ,',
'        From_amount  , ',
'        to_amount',
'from (select l.project_number , l.project_name , l.task_number , l.gl_account  gl_account, sum(l.transferred_amount) From_amount , null to_amount',
'from btf_lines l',
'where l.form_no in (select h.form_no',
'                    from btf_header h',
'                    where h.status = ''Approved''',
'                    and h.oracle_approval1 is null)',
'    and l.from_to = ''FROM''',
'GROUP BY l.project_number , l.project_name , l.task_number , l.gl_account ',
'union all',
'select l.project_number , l.project_name , l.task_number , l.gl_account  gl_account,null from_amount , sum(l.transferred_amount) to_amount ',
'from btf_lines l',
'where l.form_no in (select h.form_no',
'                    from btf_header h',
'                    where h.status = ''Approved''',
'                    and h.oracle_approval1 is null)',
'    and l.from_to = ''TO''',
'GROUP BY l.project_number , l.project_name , l.task_number , l.gl_account) ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
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
 p_id=>wwv_flow_api.id(66887016585612411)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>66887016585612411
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66887147357612412)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66887250335612413)
,p_db_column_name=>'FROM_AMOUNT'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'From Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66887386938612414)
,p_db_column_name=>'TO_AMOUNT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'To Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66887663241612417)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66887733852612418)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66887898694612419)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66887985519612420)
,p_db_column_name=>'ACCOUNT_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(66924156224564028)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'669242'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:GL_ACCOUNT:ACCOUNT_NAME:FROM_AMOUNT:TO_AMOUNT:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(133586613583879312)
,p_plug_name=>'Breadcrumb'
,p_icon_css_classes=>'fa-play-circle'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65554277731255756)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(65494572154255667)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(65602363670255785)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(133587177504879313)
,p_plug_name=>'<b>Available to Oracle By GL</b>'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- By Cost Center and GL Accounts',
'select cost_center ,',
'        gl_account ,',
'        (select p.account_name',
'            from f_projectbudget p',
'            where p.natural_account = gl_account',
'            and ROWNUM <2) Account_name ,',
'        From_amount , ',
'        to_amount',
'from (select l.cost_center  cost_center , l.gl_account  gl_account, sum(l.transferred_amount) From_amount ,  null to_amount',
'from btf_lines l',
'where l.form_no in (select h.form_no',
'                    from btf_header h',
'                    where h.status = ''Approved''',
'                    and h.oracle_approval1 is null)',
'    and l.from_to = ''FROM''',
'GROUP BY l.cost_center , l.gl_account',
'UNION all',
'select l.cost_center cost_center , l.gl_account gl_account,null from_amount , sum(l.transferred_amount) TO_amount',
'from btf_lines l',
'where l.form_no in (select h.form_no',
'                    from btf_header h',
'                    where h.status = ''Approved''',
'                    and h.oracle_approval1 is null)',
'    and l.from_to = ''TO''',
'GROUP BY l.cost_center , l.gl_account)'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(133587284858879313)
,p_name=>'All BTF'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>133587284858879313
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66886480433612405)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>20
,p_column_identifier=>'P'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66886543978612406)
,p_db_column_name=>'FROM_AMOUNT'
,p_display_order=>30
,p_column_identifier=>'Q'
,p_column_label=>'From Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66886655915612407)
,p_db_column_name=>'TO_AMOUNT'
,p_display_order=>40
,p_column_identifier=>'R'
,p_column_label=>'To Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66886719013612408)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>50
,p_column_identifier=>'S'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66886804639612409)
,p_db_column_name=>'ACCOUNT_NAME'
,p_display_order=>60
,p_column_identifier=>'T'
,p_column_label=>'Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(133593283805880340)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'669060'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'COST_CENTER:GL_ACCOUNT:ACCOUNT_NAME:FROM_AMOUNT:TO_AMOUNT:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66899731660442570)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(133586613583879312)
,p_button_name=>'Home'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Home'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP,1::'
,p_icon_css_classes=>'fa-home'
);
wwv_flow_api.component_end;
end;
/
