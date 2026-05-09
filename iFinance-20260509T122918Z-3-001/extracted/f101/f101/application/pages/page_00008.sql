prompt --application/pages/page_00008
begin
--   Manifest
--     PAGE: 00008
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
 p_id=>8
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'All Petty Cash'
,p_alias=>'ALL-PETTY-CASH'
,p_step_title=>'All Petty Cash'
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
,p_last_upd_yyyymmddhh24miss=>'20230614080748'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3986929297546462)
,p_plug_name=>'Summary (2020)'
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
 p_id=>wwv_flow_api.id(3987943039546472)
,p_plug_name=>'All Requests Year'
,p_parent_plug_id=>wwv_flow_api.id(3986929297546462)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select COUNT(distinct petty_cash_id)  value , extract(YEAR from petty_cash_date) || '' Total'' top_labl ',
'from HRSS_PETTY_CASH',
'where extract(YEAR from petty_cash_date) = extract(year from sysdate)',
'GROUP BY  extract(YEAR from petty_cash_date)'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'TOP_LABL'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_SHOW:1'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3988416542546477)
,p_plug_name=>'Late'
,p_parent_plug_id=>wwv_flow_api.id(3986929297546462)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(*) value , ''Late'' label',
'from hrss_petty_cash',
'where closing_date < SYSDATE ',
'and status = ''Open''',
'and approval_status = ''Approved'';'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'LABEL'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_SHOW:4'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3988476539546478)
,p_plug_name=>'Upcoming  close - 7 Days'
,p_parent_plug_id=>wwv_flow_api.id(3986929297546462)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(count(*),0) value , ''Upcoming'' label',
'from hrss_petty_cash',
'where trunc(closing_date - SYSDATE) <= 7 ',
'and closing_date > SYSDATE ',
'and status = ''Open''',
'and approval_status = ''Approved'' ;',
''))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'LABEL'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_SHOW:5'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3988888221546482)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_api.id(3986929297546462)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8030604591175499)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4276065127384950)
,p_plug_name=>'Temporary '
,p_parent_plug_id=>wwv_flow_api.id(3986929297546462)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select COUNT(distinct petty_cash_id)  value , extract(YEAR from petty_cash_date) || '' Temporary'' top_labl ',
'from HRSS_PETTY_CASH',
'where extract(YEAR from petty_cash_date) = extract(year from sysdate)',
'and petty_cash_type = ''T''',
'GROUP BY  extract(YEAR from petty_cash_date) || '' Temporary'' '))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'TOP_LABL'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_SHOW:2'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4276247481384951)
,p_plug_name=>'Permanent'
,p_parent_plug_id=>wwv_flow_api.id(3986929297546462)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select COUNT(distinct petty_cash_id)  value , extract(YEAR from petty_cash_date) || '' Permanent'' top_labl ',
'from HRSS_PETTY_CASH',
'where extract(YEAR from petty_cash_date) = extract(year from sysdate)',
'and petty_cash_type = ''P''',
'GROUP BY  extract(YEAR from petty_cash_date) || '' Permanent'' '))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'TOP_LABL'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_SHOW:3'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7073792819297548)
,p_plug_name=>'Pending With AP'
,p_parent_plug_id=>wwv_flow_api.id(3986929297546462)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(count(*),0) value , ''Pending'' label',
'from petty_cash_all_v',
'where  approval_status = ''Approved'' ',
'and invoicing  = ''No'';'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'LABEL'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_SHOW:6'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7077267952297583)
,p_plug_name=>'Pending With Treasury'
,p_parent_plug_id=>wwv_flow_api.id(3986929297546462)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(count(*),0) value , ''Pending'' label',
'from petty_cash_all_v',
'where  approval_status = ''Approved'' ',
'and invoicing = ''Yes''',
'and paid  = ''No'';'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'LABEL'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_SHOW:7'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(37554436125241888)
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
 p_id=>wwv_flow_api.id(37793897204440328)
,p_plug_name=>'Petty Cash Report'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PETTY_CASH_ID, PETTY_CASH_NO, PETTY_CASH_DATE, DUE_DATE, PETTY_CASH_TYPE, EMPLOYEE_NUM, EMPLOYEE, EMPLOYEE_SECTOR, EMPLOYEE_DEPARTMENT, PROJECT_NUMBER, PROJECT_NAME, ',
'        PROJECT_SECTOR, PROJECT_DEPARTMENT, TASK, AMOUNT, nvl(CLEARED_AMOUNT,0) CLEARED_AMOUNT, nvl(REIMBURACEMENT_AMOUNT, 0) REIMBURACEMENT_AMOUNT, ',
'        nvl(AMOUNT,0) - nvl(CLEARED_AMOUNT , 0) Outstanding_Amount,',
'        PURPOSE, CLOSING_DATE,APPROVAL_STATUS, STATUS, STATUS_COLOR, RECONCILED_DATE, PRIORITY, CREATION_DATE, CREATED_BY, UPDATED_BY, UPDATED_DATE, YEAR, ',
'        GL_ACCOUNT, JUSTIFICATION, COMMENT_TO_APPROVER, PHOTO',
'from (select pc.PETTY_CASH_ID,',
'       pc.PETTY_CASH_NO,',
'       pc.PETTY_CASH_DATE,',
'       pc.DUE_DATE,',
'       pc.PETTY_CASH_TYPE,',
'       e.EMPLOYEE_NUM,',
'       e.full_name_en       EMPLOYEE,',
'       e.sector             Employee_sector,',
'       e.department_name    Employee_department,',
'       pc.PROJECT_NUMBER,',
'       (select DISTINCT f.project_name',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number',
'        and ROWNUM = 1) Project_name,',
'      (select DISTINCT f.tca_sector',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number',
'        and ROWNUM = 1) Project_Sector,',
'      (select DISTINCT f.department',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number',
'        and ROWNUM = 1) Project_Department,  ',
'       TASK,',
'       AMOUNT,',
'       (select sum(nvl(l.receipt_amount,0))',
'        from hrss_expense_report_lines l',
'        where l.expense_report_id in (select er.expense_report_id',
'                                        from hrss_expense_reports er',
'                                        where er.petty_cash_id = pc.petty_cash_id',
'                                        and er.type = ''C''',
'                                        and er.approval_status = ''Approved'')) Cleared_amount,',
'    (select sum(nvl(l.receipt_amount,0))',
'        from hrss_expense_report_lines l',
'        where l.expense_report_id in (select er.expense_report_id',
'                                        from hrss_expense_reports er',
'                                        where er.petty_cash_id = pc.petty_cash_id',
'                                        and er.type = ''R''',
'                                        and er.approval_status = ''Approved'')) Reimburacement_amount,    ',
'       pc.PURPOSE,',
'       pc.CLOSING_DATE,',
'       pc.APPROVAL_STATUS,',
'       pc.STATUS,',
'       case pc.approval_status',
'        WHEN    ''Approved''  THEN ''green''',
'        WHEN    ''Rejected''   Then  ''red''',
'        When    ''In-Progress''   Then ''GoldenRod''',
'        ELSE    ''black''',
'       end    as  "STATUS_COLOR",',
'       pc.RECONCILED_DATE,',
'       pc.PRIORITY,',
'       pc.CREATION_DATE,',
'       pc.CREATED_BY,',
'       pc.UPDATED_BY,',
'       pc.UPDATED_DATE,',
'       pc.YEAR,',
'       pc.GL_ACCOUNT,',
'       pc.JUSTIFICATION,',
'       pc.COMMENT_TO_APPROVER,',
'          case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end PHOTO',
'  from HRSS_PETTY_CASH pc , employees_v e',
'  where pc.requestor_person_id = e.person_id',
'  -- where   pc.employee_num = e.employee_num',
'  and pc.APPROVAL_STATUS = NVL(:P8_APPROVAL_STATUS , pc.APPROVAL_STATUS));',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
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
 p_id=>wwv_flow_api.id(37793979602440329)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P3_PETTY_CASH_ID,P3_ID:#PETTY_CASH_ID#,#PETTY_CASH_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>37793979602440329
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29398434920052422)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29398847306052422)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Petty Cash#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29399202859052422)
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
 p_id=>wwv_flow_api.id(29399686050052422)
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
 p_id=>wwv_flow_api.id(29400008157052422)
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
 p_id=>wwv_flow_api.id(29400449805052423)
,p_db_column_name=>'EMPLOYEE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Employee'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29400896272052423)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29401204696052423)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29402476680052423)
,p_db_column_name=>'TASK'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29402847170052424)
,p_db_column_name=>'AMOUNT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29403228711052424)
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
 p_id=>wwv_flow_api.id(29403633933052424)
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
 p_id=>wwv_flow_api.id(29404043673052425)
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
 p_id=>wwv_flow_api.id(29404478776052425)
,p_db_column_name=>'STATUS'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29405283626052425)
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
 p_id=>wwv_flow_api.id(29405606406052425)
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
 p_id=>wwv_flow_api.id(29406063861052425)
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
 p_id=>wwv_flow_api.id(29406448471052426)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29406886263052426)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29407223174052426)
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
 p_id=>wwv_flow_api.id(29407668706052426)
,p_db_column_name=>'YEAR'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29408078742052426)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29408488404052427)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29408885109052427)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29409281046052427)
,p_db_column_name=>'PHOTO'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29409632008052427)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3986526390546458)
,p_db_column_name=>'EMPLOYEE_DEPARTMENT'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Employee Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3986600650546459)
,p_db_column_name=>'EMPLOYEE_SECTOR'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Employee Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3986713635546460)
,p_db_column_name=>'PROJECT_SECTOR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Project Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3986838297546461)
,p_db_column_name=>'PROJECT_DEPARTMENT'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Project Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5398289403457471)
,p_db_column_name=>'CLEARED_AMOUNT'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Cleared Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5398408492457472)
,p_db_column_name=>'REIMBURACEMENT_AMOUNT'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Reimburacement Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5398480882457473)
,p_db_column_name=>'STATUS_COLOR'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Status Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5398632948457474)
,p_db_column_name=>'OUTSTANDING_AMOUNT'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Outstanding Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(37820583899405501)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_alias=>'294100'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_DATE:EMPLOYEE:EMPLOYEE_NUM:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:AMOUNT:CLEARED_AMOUNT:REIMBURACEMENT_AMOUNT:OUTSTANDING_AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY:PHOTO:'
,p_sort_column_1=>'UPDATED_DATE'
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
 p_id=>wwv_flow_api.id(31104557420618827)
,p_report_id=>wwv_flow_api.id(37820583899405501)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'OUTSTANDING_AMOUNT'
,p_operator=>'<'
,p_expr=>'0'
,p_condition_sql=>' (case when ("OUTSTANDING_AMOUNT" < to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# < #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(60455729404870675)
,p_application_user=>'TCA9025'
,p_name=>'Late Closing'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_DATE:EMPLOYEE:EMPLOYEE_NUM:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:AMOUNT:CLEARED_AMOUNT:REIMBURACEMENT_AMOUNT:OUTSTANDING_AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY:PHOTO:'
,p_sort_column_1=>'PETTY_CASH_NO'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(60455639837870675)
,p_report_id=>wwv_flow_api.id(60455729404870675)
,p_name=>'Late'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'CLOSING_DATE'
,p_operator=>'<='
,p_expr=>'20200913000000'
,p_condition_sql=>' (case when ("CLOSING_DATE" <= to_date(#APXWS_EXPR#,''YYYYMMDDHH24MISS'')) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# <= #APXWS_EXPR_DATE#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#ED70A2'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(57858655976396778)
,p_application_user=>'TCA9025'
,p_name=>'Approved Petty Cash'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_DATE:EMPLOYEE:EMPLOYEE_NUM:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY:PHOTO'
,p_sort_column_1=>'PETTY_CASH_DATE'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'PETTY_CASH_NO'
,p_sort_direction_2=>'DESC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(57858585811396778)
,p_report_id=>wwv_flow_api.id(57858655976396778)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>'"APPROVAL_STATUS" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(19179127847469523)
,p_application_user=>'TCA9025'
,p_name=>'In-Progress Petty Cash'
,p_description=>'Display all petty cash in-progress approval '
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_view_mode=>'REPORT'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_DATE:EMPLOYEE:EMPLOYEE_NUM:PROJECT_NUMBER:AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY:PHOTO'
,p_sort_column_1=>'PETTY_CASH_NO'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(19179026036469523)
,p_report_id=>wwv_flow_api.id(19179127847469523)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'APPROVAL_STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>'"APPROVAL_STATUS" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(98691107697002017)
,p_application_user=>'TCA9051'
,p_name=>'Petty cash By Status'
,p_report_seq=>10
,p_report_type=>'CHART'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_DATE:EMPLOYEE:EMPLOYEE_NUM:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:AMOUNT:CLEARED_AMOUNT:REIMBURACEMENT_AMOUNT:OUTSTANDING_AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY:PHOTO:'
,p_sort_column_1=>'UPDATED_DATE'
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
,p_chart_type=>'lineWithArea'
,p_chart_label_column=>'APPROVAL_STATUS'
,p_chart_value_column=>'AMOUNT'
,p_chart_aggregate=>'SUM'
,p_chart_sorting=>'DEFAULT'
,p_chart_orientation=>'vertical'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(98691231222002017)
,p_report_id=>wwv_flow_api.id(98691107697002017)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'OUTSTANDING_AMOUNT'
,p_operator=>'<'
,p_expr=>'0'
,p_condition_sql=>' (case when ("OUTSTANDING_AMOUNT" < to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# < #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(98691531642007048)
,p_application_user=>'TCA9051'
,p_name=>'Petty cash By Sector'
,p_report_seq=>10
,p_report_type=>'CHART'
,p_view_mode=>'REPORT'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_DATE:EMPLOYEE:EMPLOYEE_NUM:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:AMOUNT:CLEARED_AMOUNT:REIMBURACEMENT_AMOUNT:OUTSTANDING_AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY:PHOTO:'
,p_sort_column_1=>'UPDATED_DATE'
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
,p_chart_type=>'lineWithArea'
,p_chart_label_column=>'EMPLOYEE_SECTOR'
,p_chart_value_column=>'AMOUNT'
,p_chart_aggregate=>'SUM'
,p_chart_sorting=>'DEFAULT'
,p_chart_orientation=>'vertical'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(98691661989007048)
,p_report_id=>wwv_flow_api.id(98691531642007048)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'OUTSTANDING_AMOUNT'
,p_operator=>'<'
,p_expr=>'0'
,p_condition_sql=>' (case when ("OUTSTANDING_AMOUNT" < to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# < #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3988772123546481)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(3988888221546482)
,p_button_name=>'Dashboard'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_image_alt=>'Dashboard'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-dashboard'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7309924965469269)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(37554436125241888)
,p_button_name=>'Print'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_image_alt=>'Print'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:0:&SESSION.:PRINT_REPORT=ExpenseReportDetails3:&DEBUG.:::'
,p_button_condition=>'EMP_NUM'
,p_button_condition2=>'9051'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29410845683052434)
,p_name=>'P8_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(37793897204440328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29411245436052434)
,p_name=>'P8_APPROVAL_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(37793897204440328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29411650348052435)
,p_name=>'P8_TYPE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(37793897204440328)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.component_end;
end;
/
