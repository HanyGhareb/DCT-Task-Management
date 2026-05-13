prompt --application/pages/page_00036
begin
--   Manifest
--     PAGE: 00036
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>36
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'All Petty Cash - Directors and ED'
,p_alias=>'ALL-PETTY-CASH-DIRECTORS-AND-ED'
,p_step_title=>'All Petty Cash - Directors and ED'
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
' ',
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
,p_step_template=>wwv_flow_api.id(8015810857175492)
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220203041832'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12603768499664140)
,p_plug_name=>'Summary (2022)'
,p_region_template_options=>'#DEFAULT#:t-Region--hideShowIconsMath:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8040898187175502)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12604782241664150)
,p_plug_name=>'All Requests Year'
,p_parent_plug_id=>wwv_flow_api.id(12603768499664140)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , extract(YEAR from sysdate) || '' Total'' top_labl',
'from (',
'Select COUNT(distinct pc.petty_cash_id)  value ',
'from petty_cash_all_v pc , organizations_details_v org',
'where pc.emp_org_id = org.org_id',
'and extract(YEAR from pc.petty_cash_date) = extract(year from sysdate)',
'and (org.executive_director_num = :EMP_NUM',
'OR org.director_num = :EMP_NUM))'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'TOP_LABL'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.::P37_SHOW:1'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12605255744664155)
,p_plug_name=>'Late'
,p_parent_plug_id=>wwv_flow_api.id(12603768499664140)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , '' Late'' top_labl',
'from (',
'Select COUNT(distinct pc.petty_cash_id)  value ',
'from petty_cash_all_v pc , organizations_details_v org',
'where pc.emp_org_id = org.org_id',
'and closing_date < SYSDATE ',
'and pc.status = ''Open''',
'and approval_status = ''Approved''',
'and (org.executive_director_num = :EMP_NUM',
'OR org.director_num = :EMP_NUM));'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.::P37_SHOW:4'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12605315741664156)
,p_plug_name=>'Upcoming  close - 7 Days'
,p_parent_plug_id=>wwv_flow_api.id(12603768499664140)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , '' Upcoming'' top_labl',
'from (',
'Select nvl(count(*),0)  value ',
'from petty_cash_all_v pc , organizations_details_v org',
'where pc.emp_org_id = org.org_id',
'and trunc(pc.closing_date - SYSDATE) <= 7 ',
'and pc.closing_date > SYSDATE ',
'and pc.status = ''Open''',
'and pc.approval_status = ''Approved''',
'and (org.executive_director_num = :EMP_NUM',
'OR org.director_num = :EMP_NUM));'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.::P37_SHOW:5'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12605727423664160)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_api.id(12603768499664140)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8030604591175499)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12892904329502628)
,p_plug_name=>'Temporary '
,p_parent_plug_id=>wwv_flow_api.id(12603768499664140)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , extract(YEAR from sysdate) || '' Temporary''  top_labl',
'from (',
'Select COUNT(distinct pc.petty_cash_id)  value ',
'from petty_cash_all_v pc , organizations_details_v org',
'where pc.emp_org_id = org.org_id',
'and petty_cash_type_code = ''T''',
'and extract(YEAR from pc.petty_cash_date) = extract(year from sysdate)',
'and (org.executive_director_num = :EMP_NUM',
'OR org.director_num = :EMP_NUM));'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'TOP_LABL'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.::P37_SHOW:2'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12893086683502629)
,p_plug_name=>'Permanent'
,p_parent_plug_id=>wwv_flow_api.id(12603768499664140)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , extract(YEAR from sysdate) || '' Permanent'' top_labl',
'from (',
'Select COUNT(distinct pc.petty_cash_id)  value ',
'from petty_cash_all_v pc , organizations_details_v org',
'where pc.emp_org_id = org.org_id',
'and petty_cash_type_code = ''P''',
'and extract(YEAR from pc.petty_cash_date) = extract(year from sysdate)',
'and (org.executive_director_num = :EMP_NUM',
'OR org.director_num = :EMP_NUM));',
''))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'TOP_LABL'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.::P37_SHOW:3'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(46171275327359566)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(46410736406558006)
,p_plug_name=>'Petty Cash Report'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    pc.petty_cash_id,',
'    pc.petty_cash_no,',
'    pc.petty_cash_date,',
'    pc.due_date,',
'    pc.petty_cash_type,',
'    pc.petty_cash_type_code,',
'    pc.employee_num,',
'    pc.emp_name,',
'    pc.emp_org_id,',
'    pc.org_name,',
'    pc.department_id,',
'    pc.department_name,',
'    pc.sector_id,',
'    pc.sector,',
'    e.director_num,',
'    e.director_name,',
'    e.executive_director__name,',
'    e.executive_director_num,',
'    pc.cost_center_code,',
'    pc.project_number,',
'    pc.project_name,',
'    pc.task,',
'    pc.gl_account,',
'    pc.amount,',
'    pc.cleared_amount,',
'    nvl((AMOUNT - CLEARED_AMOUNT),0) Outstanding_Amount,',
'    pc.reimburacement_amount,',
'    pc.purpose,',
'    pc.purpose_desc,  ',
'    pc.closing_date,',
'    pc.approval_status,',
'    pc.status,',
'    case pc.approval_status',
'        WHEN    ''Approved''  THEN ''green''',
'        WHEN    ''Rejected''   Then  ''red''',
'        When    ''In-Progress''   Then ''GoldenRod''',
'        ELSE    ''black''',
'       end    as  "STATUS_COLOR",',
'    pc.reconciled_date,',
'    pc.priority,',
'    pc.justification,',
'    pc.comment_to_approver,',
'    pc.invoicing,',
'    pc.paid,',
'    pc.invoice_number,',
'    pc.invoice_date,',
'    pc.pv_number,',
'    pc.gl_date,',
'    pc.payment_number,',
'    pc.payment_date,',
'    pc.btr_required,',
'    pc.creation_date,',
'    pc.created_by,',
'    pc.updated_by,',
'    pc.updated_date,',
'    pc.year,',
'    pc.expense_reports_amount,',
'    case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end PHOTO',
'FROM',
'    petty_cash_all_v  pc , employees_v e , organizations_details_v org',
'where pc.employee_num = e.employee_num',
'and pc.emp_org_id = org.org_id',
'and (org.executive_director_num = :EMP_NUM',
'OR org.director_num = :EMP_NUM)'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Petty Cash Report'
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
 p_id=>wwv_flow_api.id(46410818804558007)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P3_PETTY_CASH_ID:#PETTY_CASH_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>48400857131621771
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6633811477053954)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6634171082053954)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Petty Cash#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6634594388053955)
,p_db_column_name=>'PETTY_CASH_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6634995200053955)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6635377776053956)
,p_db_column_name=>'PETTY_CASH_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8333351243197780)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6636168718053957)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6636630356053957)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6637018111053958)
,p_db_column_name=>'TASK'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6637375042053958)
,p_db_column_name=>'AMOUNT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6637852620053959)
,p_db_column_name=>'PURPOSE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8345862665015663)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6638239745053959)
,p_db_column_name=>'CLOSING_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Closing Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6638587228053960)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Approval Status'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<span style="font-weight:bold;color:#STATUS_COLOR#">#APPROVAL_STATUS#</span>',
''))
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6638968007053960)
,p_db_column_name=>'STATUS'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6639429014053961)
,p_db_column_name=>'RECONCILED_DATE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Reconciled Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6639856804053961)
,p_db_column_name=>'PRIORITY'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6640215856053962)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6640592562053962)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6641008986053963)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6641368261053963)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6641774104053963)
,p_db_column_name=>'YEAR'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6642204164053964)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6642608336053964)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6643051437053965)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6643432776053965)
,p_db_column_name=>'PHOTO'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6643776000053966)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6632186983053952)
,p_db_column_name=>'CLEARED_AMOUNT'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Cleared Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6632580337053953)
,p_db_column_name=>'REIMBURACEMENT_AMOUNT'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Reimburacement Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6632968090053953)
,p_db_column_name=>'STATUS_COLOR'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Status Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6633410081053954)
,p_db_column_name=>'OUTSTANDING_AMOUNT'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Outstanding Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6405876267706786)
,p_db_column_name=>'PETTY_CASH_TYPE_CODE'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Petty Cash Type Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6648867337135437)
,p_db_column_name=>'EMP_NAME'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Emp Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6648994317135438)
,p_db_column_name=>'EMP_ORG_ID'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Emp Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6649070220135439)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6649165604135440)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Department Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6649275037135441)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6649413003135442)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Sector Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6649509191135443)
,p_db_column_name=>'SECTOR'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6649649609135444)
,p_db_column_name=>'DIRECTOR_NUM'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6649676799135445)
,p_db_column_name=>'DIRECTOR_NAME'
,p_display_order=>480
,p_column_identifier=>'AV'
,p_column_label=>'Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6649774407135446)
,p_db_column_name=>'EXECUTIVE_DIRECTOR__NAME'
,p_display_order=>490
,p_column_identifier=>'AW'
,p_column_label=>'Executive Director Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6649887973135447)
,p_db_column_name=>'EXECUTIVE_DIRECTOR_NUM'
,p_display_order=>500
,p_column_identifier=>'AX'
,p_column_label=>'Executive Director Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6649998942135448)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>510
,p_column_identifier=>'AY'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6650078894135449)
,p_db_column_name=>'PURPOSE_DESC'
,p_display_order=>520
,p_column_identifier=>'AZ'
,p_column_label=>'Purpose Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6650240638135450)
,p_db_column_name=>'INVOICING'
,p_display_order=>530
,p_column_identifier=>'BA'
,p_column_label=>'Invoicing'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6650316295135451)
,p_db_column_name=>'PAID'
,p_display_order=>540
,p_column_identifier=>'BB'
,p_column_label=>'Paid'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6650387632135452)
,p_db_column_name=>'INVOICE_NUMBER'
,p_display_order=>550
,p_column_identifier=>'BC'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6650499425135453)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>560
,p_column_identifier=>'BD'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6650613587135454)
,p_db_column_name=>'PV_NUMBER'
,p_display_order=>570
,p_column_identifier=>'BE'
,p_column_label=>'Pv Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6650736544135455)
,p_db_column_name=>'GL_DATE'
,p_display_order=>580
,p_column_identifier=>'BF'
,p_column_label=>'Gl Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6650795475135456)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>590
,p_column_identifier=>'BG'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6650939385135457)
,p_db_column_name=>'PAYMENT_DATE'
,p_display_order=>600
,p_column_identifier=>'BH'
,p_column_label=>'Payment Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6651047722135458)
,p_db_column_name=>'BTR_REQUIRED'
,p_display_order=>610
,p_column_identifier=>'BI'
,p_column_label=>'Btr Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6651121680135459)
,p_db_column_name=>'EXPENSE_REPORTS_AMOUNT'
,p_display_order=>620
,p_column_identifier=>'BJ'
,p_column_label=>'Expense Reports Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(46437423101523179)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_alias=>'86342'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EMPLOYEE_NUM:EMP_NAME:PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_DATE:AMOUNT:CLEARED_AMOUNT:REIMBURACEMENT_AMOUNT:OUTSTANDING_AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PHOTO:'
,p_sort_column_1=>'PETTY_CASH_DATE'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'EMP_NAME'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'AMOUNT:CLEARED_AMOUNT:REIMBURACEMENT_AMOUNT:OUTSTANDING_AMOUNT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(58991682723567335)
,p_application_user=>'TCA318'
,p_name=>'In-Progress'
,p_description=>'Petty cash requests which are in-Progress approval status'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_columns=>'EMPLOYEE_NUM:EMP_NAME:PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_DATE:AMOUNT:CLEARED_AMOUNT:REIMBURACEMENT_AMOUNT:OUTSTANDING_AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PHOTO:'
,p_sort_column_1=>'PETTY_CASH_DATE'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'EMP_NAME'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'AMOUNT:CLEARED_AMOUNT:REIMBURACEMENT_AMOUNT:OUTSTANDING_AMOUNT'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(58991572458567335)
,p_report_id=>wwv_flow_api.id(58991682723567335)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>'"APPROVAL_STATUS" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6629052686053942)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(12605727423664160)
,p_button_name=>'Dashboard'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_image_alt=>'Dashboard'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-dashboard'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6644606982053971)
,p_name=>'P36_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(46410736406558006)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6644986396053973)
,p_name=>'P36_APPROVAL_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(46410736406558006)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6645431720053973)
,p_name=>'P36_TYPE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(46410736406558006)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.component_end;
end;
/
