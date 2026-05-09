prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
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
 p_id=>11
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'All BTF'
,p_step_title=>'All BTF'
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
,p_required_role=>wwv_flow_api.id(70305549671149387)
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200430130708'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(66687872439436754)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
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
 p_id=>wwv_flow_api.id(66688436360436755)
,p_plug_name=>'All BTF'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'        -- Header',
'        btf_header.form_no',
'        ,btf_header.priority',
'        ,btf_header.reason',
'        ,btf_header.status      DOA_STATUS',
'        , btf_header.finance_status',
'        ,btf_header.year',
'        ,btf_header.created_by      Header_Created_BY',
'        ,btf_header.creation_date   Header_Creation_date',
'        ,btf_header.updated_by      Header_Updated_By',
'        ,btf_header.updated_date    Headdr_Updated_Date',
'        ,decode(btf_header.completed,''Y'',''Yes'',''No'')     completed',
'        ,btf_header.revision_no',
'        ,(select sum(nvl(l.transferred_amount ,0)) ',
'        from btf_lines l',
'        where l.form_no = btf_header.form_no',
'        and l.from_to = ''FROM'') Amount',
'--    ,(select sum(nvl(l.transferred_amount ,0)) ',
'--        from btf_lines l',
'--        where l.form_no = btf_header.form_no',
'--        and l.from_to = ''TO'') total_to',
'    ,',
'    (select h.user_name',
'        from btf_approval_history h',
'        where h.form_no = btf_header.form_no',
'        and h.status = ''Pending'')',
'        || '' - '' ||',
'    (select e.full_name_en',
'        from dct_employees_list2 e',
'        where e.employee_num = (select substr(h.user_name,4)',
'                                from btf_approval_history h',
'                                where h.form_no = btf_header.form_no',
'                                and h.status = ''Pending''))Pending_with    ',
'from btf_header ',
'where  btf_header.form_no in (select l.form_no ',
'                            from btf_lines l ',
'                            where l.form_no = btf_header.form_no ',
'                            and l.tca_sector in (SELECT  btf_data_access.entity_name d',
'                                                    FROM   btf_data_access',
'                                                    WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                                    and btf_data_access.user_id = :APP_USER))',
'and btf_header.status = nvl(:P11_STATUS , btf_header.status)',
'',
'',
'',
'/*',
'select ',
'        -- Header',
'        btf_header.form_no',
'        ,btf_header.priority',
'        ,btf_header.reason',
'        ,btf_header.status      DOA_STATUS',
'        , btf_header.finance_status',
'        ,btf_header.year',
'        ,btf_header.created_by      Header_Created_BY',
'        ,btf_header.creation_date   Header_Creation_date',
'        ,btf_header.updated_by      Header_Updated_By',
'        ,btf_header.updated_date    Headdr_Updated_Date',
'        ,decode(btf_header.completed,''Y'',''Yes'',''No'') completed',
'        ,btf_header.priority        Header_Priority',
'        ,btf_header.revision_no',
'        ,(select sum(nvl(l.transferred_amount ,0)) ',
'        from btf_lines l',
'        where l.form_no = btf_header.form_no',
'        and l.from_to = ''FROM'') total_from',
'    ,(select sum(nvl(l.transferred_amount ,0)) ',
'        from btf_lines l',
'        where l.form_no = btf_header.form_no',
'        and l.from_to = ''TO'') total_to',
'    ,',
'    (select h.user_name',
'        from btf_approval_history h',
'        where h.form_no = btf_header.form_no',
'        and h.status = ''Pending'')',
'        || '' - '' ||',
'    (select e.full_name_en',
'        from dct_employees_list2 e',
'        where e.employee_num = (select substr(h.user_name,4)',
'                                from btf_approval_history h',
'                                where h.form_no = btf_header.form_no',
'                                and h.status = ''Pending''))Pending_with    ',
'        ',
'---- Lines',
'        ,btf_lines.from_to',
'        ,btf_lines.line_no',
'        ,btf_lines.tca_sector',
'        ,btf_lines.department',
'        ,btf_lines.cost_center',
'        ,btf_lines.project_number',
'        ,btf_lines.project_name',
'        ,btf_lines.task_number',
'        ,btf_lines.gl_account',
'        ,btf_lines.budget',
'        ,btf_lines.encumbrances',
'        ,btf_lines.actual',
'        ,btf_lines.fund_available',
'        ,btf_lines.transferred_amount',
'        ,btf_lines.created_by',
'        ,btf_lines.creation_date',
'        ,btf_lines.updated_by',
'        ,btf_lines.updated_date',
'        ,btf_lines.program',
'        ,btf_lines.output',
'        ,btf_lines.justification',
'        ,btf_lines.purpose_eu',
'        ,btf_lines.source',
'        ,btf_lines.strategic',
'from btf_lines  LEFT OUTER JOIN btf_header ',
'on btf_lines.form_no = btf_header.form_no',
'and btf_header.form_no in (select l.form_no ',
'                            from btf_lines l ',
'                            where l.form_no = btf_header.form_no ',
'                            and l.tca_sector in (SELECT  btf_data_access.entity_name d',
'                                                    FROM   btf_data_access',
'                                                    WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                                    and btf_data_access.user_id = :APP_USER))',
'and btf_header.status = nvl(:P11_STATUS , btf_header.status)',
'',
'*/'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P11_STATUS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_document_header=>'SERVER'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
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
,p_prn_border_width=>.3
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(66688543714436755)
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
,p_internal_uid=>66688543714436755
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66688937141436759)
,p_db_column_name=>'FORM_NO'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Form No'
,p_column_link=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:RP,9:P9_FORM_NO:#FORM_NO#'
,p_column_linktext=>'#FORM_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66689371281436760)
,p_db_column_name=>'REVISION_NO'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Revision No'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66690552125436760)
,p_db_column_name=>'REASON'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66692523587436761)
,p_db_column_name=>'YEAR'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(66694160045436762)
,p_db_column_name=>'PENDING_WITH'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Pending With'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76336633153605034)
,p_db_column_name=>'PRIORITY'
,p_display_order=>24
,p_column_identifier=>'O'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76336790593605035)
,p_db_column_name=>'DOA_STATUS'
,p_display_order=>34
,p_column_identifier=>'P'
,p_column_label=>'DOA Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76336849935605036)
,p_db_column_name=>'FINANCE_STATUS'
,p_display_order=>44
,p_column_identifier=>'Q'
,p_column_label=>'Finance Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76336959920605037)
,p_db_column_name=>'HEADER_CREATED_BY'
,p_display_order=>54
,p_column_identifier=>'R'
,p_column_label=>'Header Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76337058104605038)
,p_db_column_name=>'HEADER_CREATION_DATE'
,p_display_order=>64
,p_column_identifier=>'S'
,p_column_label=>'Header Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76337140911605039)
,p_db_column_name=>'HEADER_UPDATED_BY'
,p_display_order=>74
,p_column_identifier=>'T'
,p_column_label=>'Header Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76337282137605040)
,p_db_column_name=>'HEADDR_UPDATED_DATE'
,p_display_order=>84
,p_column_identifier=>'U'
,p_column_label=>'Headdr Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76337323983605041)
,p_db_column_name=>'COMPLETED'
,p_display_order=>94
,p_column_identifier=>'V'
,p_column_label=>'Completed'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77058712368629040)
,p_db_column_name=>'AMOUNT'
,p_display_order=>104
,p_column_identifier=>'AR'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(66694542661437782)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'666946'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_view_mode=>'REPORT'
,p_report_columns=>'FORM_NO:REASON:YEAR:PENDING_WITH::PRIORITY:DOA_STATUS:FINANCE_STATUS:HEADER_CREATED_BY:HEADER_CREATION_DATE:HEADER_UPDATED_BY:HEADDR_UPDATED_DATE:COMPLETED:TRANSFERRED_PROGRAM:AMOUNT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(76413772817095736)
,p_application_user=>'TCA9051'
,p_name=>'BTR Headers'
,p_report_seq=>10
,p_view_mode=>'REPORT'
,p_report_columns=>'FORM_NO:REASON:YEAR:PENDING_WITH:PRIORITY:DOA_STATUS:FINANCE_STATUS:COMPLETED'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(76413979223104545)
,p_application_user=>'TCA9051'
,p_name=>'BTR Headers Bie'
,p_report_seq=>10
,p_report_type=>'CHART'
,p_view_mode=>'REPORT'
,p_report_columns=>'FORM_NO:REASON:YEAR:PENDING_WITH:PRIORITY:DOA_STATUS:FINANCE_STATUS:COMPLETED'
,p_chart_type=>'pie'
,p_chart_label_column=>'DOA_STATUS'
,p_chart_value_column=>'TOTAL_FROM'
,p_chart_aggregate=>'SUM'
,p_chart_sorting=>'LABEL_ASC'
,p_chart_orientation=>'vertical'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(66886236858612403)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(66687872439436754)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(70028104448169811)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(66687872439436754)
,p_button_name=>'New_BTF'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Budget Transfer'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.:Direct:&DEBUG.:RP::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(66886107156612402)
,p_name=>'P11_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(66688436360436755)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
