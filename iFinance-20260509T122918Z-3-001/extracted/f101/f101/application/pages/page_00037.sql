prompt --application/pages/page_00037
begin
--   Manifest
--     PAGE: 00037
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
 p_id=>37
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'All Petty Cash - Directors and ED -Details'
,p_alias=>'ALL-PETTY-CASH-DIRECTORS-AND-ED-DETAILS'
,p_step_title=>'All Petty Cash - Directors and ED -Details'
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
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220203042009'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12941216732775109)
,p_plug_name=>'Temporary Petty cash  Requests'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PETTY_CASH_ID,',
'       PETTY_CASH_NO,',
'       PETTY_CASH_DATE,',
'       DUE_DATE,',
'       PETTY_CASH_TYPE,',
'       pc.employee_num,',
'       e.full_name_en  employee  ,',
'       e.org_name      employee_organization,',
'       e.department_name    employee_department,',
'       e.sector             employee_Sector,',
'       PROJECT_NUMBER,',
'       (select DISTINCT f.project_name',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number) Project_name,',
'      (select DISTINCT f.tca_sector',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number) Project_Sector,',
'      (select DISTINCT f.department',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number) Project_Department,  ',
'       TASK,',
'       AMOUNT,',
'       PURPOSE,',
'       CLOSING_DATE,',
'       APPROVAL_STATUS,',
'       pc.STATUS,',
'       case pc.approval_status',
'        WHEN    ''Approved''  THEN ''green''',
'        WHEN    ''Rejected''   Then  ''red''',
'        When    ''In-Progress''   Then ''GoldenRod''',
'        ELSE    ''black''',
'       end    as  "status_color",',
'       pc.RECONCILED_DATE,',
'       pc.PRIORITY,',
'       pc.CREATION_DATE,',
'       pc.CREATED_BY,',
'       pc.UPDATED_BY,',
'       pc.UPDATED_DATE,',
'       pc.YEAR,',
'       GL_ACCOUNT,',
'       JUSTIFICATION,',
'       COMMENT_TO_APPROVER,',
'        case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end   PHOTO',
'  from petty_cash_all_v pc, employees_v  e, organizations_details_v org',
'  where extract(YEAR from pc.petty_cash_date) = extract(year from sysdate)',
'  and pc.employee_num = e.employee_num',
'  and  pc.emp_org_id = org.org_id',
'  and (org.executive_director_num = :EMP_NUM',
'OR org.director_num = :EMP_NUM)',
'  and pc.petty_cash_type_code = ''T'';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P37_STATUS,P37_TYPE,P37_APPROVAL_STATUS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P37_SHOW'
,p_plug_display_when_cond2=>'2'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Temporary Petty cash  Requests'
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
 p_id=>wwv_flow_api.id(12941727718775114)
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
,p_internal_uid=>14931766045838878
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6704168904326416)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6704616085326416)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6704981689326416)
,p_db_column_name=>'PHOTO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6705371323326417)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6705799320326417)
,p_db_column_name=>'EMPLOYEE_ORGANIZATION'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Employee Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6706231045326417)
,p_db_column_name=>'EMPLOYEE_DEPARTMENT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Employee Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6706602070326418)
,p_db_column_name=>'EMPLOYEE_SECTOR'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Employee Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6706983580326418)
,p_db_column_name=>'PROJECT_SECTOR'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Project Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6707441970326418)
,p_db_column_name=>'PROJECT_DEPARTMENT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Project Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6707848407326418)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Petty Cash#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6708169444326419)
,p_db_column_name=>'PETTY_CASH_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6708582629326419)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6708988362326419)
,p_db_column_name=>'PETTY_CASH_TYPE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8333351243197780)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6709406153326419)
,p_db_column_name=>'EMPLOYEE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Employee'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6709785185326420)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6710167988326420)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6710645887326420)
,p_db_column_name=>'TASK'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6711049779326421)
,p_db_column_name=>'AMOUNT'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6711412223326421)
,p_db_column_name=>'PURPOSE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8345862665015663)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6711807747326421)
,p_db_column_name=>'CLOSING_DATE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Closing Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6712261197326421)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Approval Status'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<span style="font-weight:bold;color:#status_color#">#APPROVAL_STATUS#</span>',
''))
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6712642086326422)
,p_db_column_name=>'STATUS'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6712998215326422)
,p_db_column_name=>'status_color'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Status Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6713410487326422)
,p_db_column_name=>'RECONCILED_DATE'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Reconciled Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6713825688326422)
,p_db_column_name=>'PRIORITY'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6714191676326423)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6714648542326423)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6715032274326423)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6715419304326423)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6715779517326424)
,p_db_column_name=>'YEAR'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6716239081326424)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6716624405326424)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(13032258919917500)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'87070'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_DATE:EMPLOYEE:EMPLOYEE_NUM:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:EMPLOYEE_ORGANIZATION:PROJECT_NUMBER:PROJECT_SECTOR:PROJECT_DEPARTMENT:AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY:PHOTO:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13014837615902897)
,p_plug_name=>'Permanent Petty cash Requests'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PETTY_CASH_ID,',
'       PETTY_CASH_NO,',
'       PETTY_CASH_DATE,',
'       DUE_DATE,',
'       PETTY_CASH_TYPE,',
'       pc.employee_num,',
'       e.full_name_en  employee  ,',
'       e.org_name      employee_organization,',
'       e.department_name    employee_department,',
'       e.sector             employee_Sector,',
'       PROJECT_NUMBER,',
'       (select DISTINCT f.project_name',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number) Project_name,',
'      (select DISTINCT f.tca_sector',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number) Project_Sector,',
'      (select DISTINCT f.department',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number) Project_Department,  ',
'       TASK,',
'       AMOUNT,',
'       PURPOSE,',
'       CLOSING_DATE,',
'       APPROVAL_STATUS,',
'       pc.STATUS,',
'       case pc.approval_status',
'        WHEN    ''Approved''  THEN ''green''',
'        WHEN    ''Rejected''   Then  ''red''',
'        When    ''In-Progress''   Then ''GoldenRod''',
'        ELSE    ''black''',
'       end    as  "status_color",',
'       pc.RECONCILED_DATE,',
'       pc.PRIORITY,',
'       pc.CREATION_DATE,',
'       pc.CREATED_BY,',
'       pc.UPDATED_BY,',
'       pc.UPDATED_DATE,',
'       pc.YEAR,',
'       GL_ACCOUNT,',
'       JUSTIFICATION,',
'       COMMENT_TO_APPROVER,',
'        case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end   PHOTO',
'  from petty_cash_all_v pc, employees_v  e, organizations_details_v org',
'  where extract(YEAR from pc.petty_cash_date) = extract(year from sysdate)',
'  and pc.employee_num = e.employee_num',
'  and  pc.emp_org_id = org.org_id',
'  and (org.executive_director_num = :EMP_NUM',
'OR org.director_num = :EMP_NUM)',
'  and pc.petty_cash_type_code = ''P'';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P37_STATUS,P37_TYPE,P37_APPROVAL_STATUS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P37_SHOW'
,p_plug_display_when_cond2=>'3'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Permanent Petty cash Requests'
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
 p_id=>wwv_flow_api.id(13014961843902898)
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
,p_internal_uid=>15005000170966662
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6717729220326426)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6718096268326426)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6718472439326426)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6718950877326426)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6719347576326427)
,p_db_column_name=>'YEAR'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6719742586326427)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6720118046326427)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6720503974326427)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6720937233326428)
,p_db_column_name=>'PHOTO'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6721359174326428)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6721681587326428)
,p_db_column_name=>'EMPLOYEE_ORGANIZATION'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Employee Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6722092514326428)
,p_db_column_name=>'EMPLOYEE_DEPARTMENT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Employee Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6722471500326429)
,p_db_column_name=>'EMPLOYEE_SECTOR'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Employee Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6722876718326429)
,p_db_column_name=>'PROJECT_SECTOR'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Project Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6723288289326429)
,p_db_column_name=>'PROJECT_DEPARTMENT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Project Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6723702527326429)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Petty Cash#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6724122120326430)
,p_db_column_name=>'PETTY_CASH_DATE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6724473153326430)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6724916648326430)
,p_db_column_name=>'PETTY_CASH_TYPE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8333351243197780)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6725264599326431)
,p_db_column_name=>'EMPLOYEE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Employee'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6725691623326431)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6726078080326431)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6726499053326431)
,p_db_column_name=>'TASK'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6726885184326432)
,p_db_column_name=>'AMOUNT'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6727356944326432)
,p_db_column_name=>'PURPOSE'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8345862665015663)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6727759791326432)
,p_db_column_name=>'CLOSING_DATE'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Closing Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6728087733326432)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Approval Status'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<span style="font-weight:bold;color:#status_color#">#APPROVAL_STATUS#</span>',
''))
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6728533829326433)
,p_db_column_name=>'STATUS'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6728914643326433)
,p_db_column_name=>'status_color'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Status Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6729291352326433)
,p_db_column_name=>'RECONCILED_DATE'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Reconciled Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6729684717326433)
,p_db_column_name=>'PRIORITY'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6730091858326434)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(13079336383967264)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'87205'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_DATE:EMPLOYEE_NUM:EMPLOYEE:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:EMPLOYEE_ORGANIZATION:PROJECT_NUMBER:PROJECT_SECTOR:PROJECT_DEPARTMENT:AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY:PHOTO:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13018220686902931)
,p_plug_name=>'Late Petty cash requests'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PETTY_CASH_ID,',
'       PETTY_CASH_NO,',
'       PETTY_CASH_DATE,',
'       DUE_DATE,',
'       PETTY_CASH_TYPE,',
'       pc.employee_num,',
'       e.full_name_en  employee  ,',
'       e.org_name      employee_organization,',
'       e.department_name    employee_department,',
'       e.sector             employee_Sector,',
'       PROJECT_NUMBER,',
'       (select DISTINCT f.project_name',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number',
'       and rownum = 1) Project_name,',
'      (select DISTINCT f.tca_sector',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number',
'        and rownum = 1) Project_Sector,',
'      (select DISTINCT f.department',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number',
'        and rownum = 1) Project_Department,  ',
'       TASK,',
'       AMOUNT,',
'       PURPOSE,',
'       CLOSING_DATE,',
'       APPROVAL_STATUS,',
'       STATUS,',
'       case pc.approval_status',
'        WHEN    ''Approved''  THEN ''green''',
'        WHEN    ''Rejected''   Then  ''red''',
'        When    ''In-Progress''   Then ''GoldenRod''',
'        ELSE    ''black''',
'       end    as  "status_color",',
'       RECONCILED_DATE,',
'       PRIORITY,',
'       CREATION_DATE,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_DATE,',
'       YEAR,',
'       GL_ACCOUNT,',
'       JUSTIFICATION,',
'       COMMENT_TO_APPROVER,',
'        case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end   PHOTO',
'  from HRSS_PETTY_CASH pc, employees_v  e',
'  where pc.closing_date < SYSDATE ',
'  and pc.employee_num = e.employee_num',
'and pc.status = ''Open''',
'and pc.approval_status = ''Approved'';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P37_STATUS,P37_TYPE,P37_APPROVAL_STATUS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P37_SHOW'
,p_plug_display_when_cond2=>'4'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Late Petty cash requests'
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
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(13018389653902932)
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
,p_internal_uid=>15008427980966696
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6731215174326435)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6731599668326435)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6732028354326435)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6732364637326436)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6732799939326436)
,p_db_column_name=>'YEAR'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6733212900326436)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6733614910326436)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6734003982326437)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6734388617326437)
,p_db_column_name=>'PHOTO'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6734792840326437)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6735174027326437)
,p_db_column_name=>'EMPLOYEE_ORGANIZATION'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Employee Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6735604089326438)
,p_db_column_name=>'EMPLOYEE_DEPARTMENT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Employee Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6736011873326438)
,p_db_column_name=>'EMPLOYEE_SECTOR'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Employee Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6736408042326438)
,p_db_column_name=>'PROJECT_SECTOR'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Project Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6736828591326438)
,p_db_column_name=>'PROJECT_DEPARTMENT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Project Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6737234495326439)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Petty Cash#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6737653618326439)
,p_db_column_name=>'PETTY_CASH_DATE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6737975195326439)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6738383069326440)
,p_db_column_name=>'PETTY_CASH_TYPE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8333351243197780)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6738846870326440)
,p_db_column_name=>'EMPLOYEE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Employee'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6739257608326440)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6739649430326440)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6740318867326441)
,p_db_column_name=>'TASK'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6740740186326441)
,p_db_column_name=>'AMOUNT'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6741123733326441)
,p_db_column_name=>'PURPOSE'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8345862665015663)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6741542483326442)
,p_db_column_name=>'CLOSING_DATE'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Closing Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6741884057326442)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Approval Status'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<span style="font-weight:bold;color:#status_color#">#APPROVAL_STATUS#</span>',
''))
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6742269060326442)
,p_db_column_name=>'STATUS'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6742732197326443)
,p_db_column_name=>'status_color'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Status Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6743098753326443)
,p_db_column_name=>'RECONCILED_DATE'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Reconciled Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6743548236326443)
,p_db_column_name=>'PRIORITY'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6743872301326444)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(13079937557968170)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'87343'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_DATE:EMPLOYEE_NUM:EMPLOYEE:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:EMPLOYEE_ORGANIZATION:PROJECT_NUMBER:PROJECT_SECTOR:PROJECT_DEPARTMENT:AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY:PHOTO:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13045628199923615)
,p_plug_name=>'Upcoming  Petty cash - 7 Days'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PETTY_CASH_ID,',
'       PETTY_CASH_NO,',
'       PETTY_CASH_DATE,',
'       DUE_DATE,',
'       PETTY_CASH_TYPE,',
'       pc.employee_num,',
'       e.full_name_en  employee  ,',
'       e.org_name      employee_organization,',
'       e.department_name    employee_department,',
'       e.sector             employee_Sector,',
'       PROJECT_NUMBER,',
'       (select DISTINCT f.project_name',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number) Project_name,',
'      (select DISTINCT f.tca_sector',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number) Project_Sector,',
'      (select DISTINCT f.department',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number) Project_Department,  ',
'       TASK,',
'       AMOUNT,',
'       PURPOSE,',
'       CLOSING_DATE,',
'       APPROVAL_STATUS,',
'       STATUS,',
'       case pc.approval_status',
'        WHEN    ''Approved''  THEN ''green''',
'        WHEN    ''Rejected''   Then  ''red''',
'        When    ''In-Progress''   Then ''GoldenRod''',
'        ELSE    ''black''',
'       end    as  "status_color",',
'       RECONCILED_DATE,',
'       PRIORITY,',
'       CREATION_DATE,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_DATE,',
'       YEAR,',
'       GL_ACCOUNT,',
'       JUSTIFICATION,',
'       COMMENT_TO_APPROVER,',
'        case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end   PHOTO',
'  from HRSS_PETTY_CASH pc, employees_v  e',
'  where trunc(pc.closing_date - SYSDATE) <= 7',
'  and pc.closing_date > SYSDATE ',
'  and pc.employee_num = e.employee_num',
'and pc.status = ''Open''',
'and pc.approval_status = ''Approved'';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P37_STATUS,P37_TYPE,P37_APPROVAL_STATUS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P37_SHOW'
,p_plug_display_when_cond2=>'5'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Upcoming  Petty cash - 7 Days'
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
 p_id=>wwv_flow_api.id(13045718196923616)
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
,p_internal_uid=>15035756523987380
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6675353563326394)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6675699649326395)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6676087197326395)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6676470679326395)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6676862174326395)
,p_db_column_name=>'YEAR'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6677333656326396)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6677742512326396)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6678115177326396)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6678535158326397)
,p_db_column_name=>'PHOTO'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6678905632326397)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6679263529326397)
,p_db_column_name=>'EMPLOYEE_ORGANIZATION'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Employee Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6679662419326397)
,p_db_column_name=>'EMPLOYEE_DEPARTMENT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Employee Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6680073580326398)
,p_db_column_name=>'EMPLOYEE_SECTOR'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Employee Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6680500683326398)
,p_db_column_name=>'PROJECT_SECTOR'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Project Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6680870839326398)
,p_db_column_name=>'PROJECT_DEPARTMENT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Project Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6681335088326399)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Petty Cash#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6681760208326399)
,p_db_column_name=>'PETTY_CASH_DATE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6682145947326399)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6682529655326399)
,p_db_column_name=>'PETTY_CASH_TYPE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8333351243197780)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6682866345326400)
,p_db_column_name=>'EMPLOYEE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Employee'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6683313180326400)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6683731047326400)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6684099310326400)
,p_db_column_name=>'TASK'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6684557772326401)
,p_db_column_name=>'AMOUNT'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6684881030326401)
,p_db_column_name=>'PURPOSE'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8345862665015663)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6685338089326401)
,p_db_column_name=>'CLOSING_DATE'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Closing Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6685740597326402)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Approval Status'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<span style="font-weight:bold;color:#status_color#">#APPROVAL_STATUS#</span>',
''))
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6686132093326402)
,p_db_column_name=>'STATUS'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6686540634326402)
,p_db_column_name=>'status_color'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Status Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6686871683326402)
,p_db_column_name=>'RECONCILED_DATE'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Reconciled Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6687296209326403)
,p_db_column_name=>'PRIORITY'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6687733164326403)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(13075244604946089)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'86781'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_DATE:EMPLOYEE_NUM:EMPLOYEE:EMPLOYEE_SECTOR:EMPLOYEE_DEPARTMENT:EMPLOYEE_ORGANIZATION:PROJECT_NUMBER:PROJECT_SECTOR:PROJECT_DEPARTMENT:AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY:PHOTO:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(52533044130138172)
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
 p_id=>wwv_flow_api.id(52772505209336612)
,p_plug_name=>'All Petty cash Requests'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PETTY_CASH_ID,',
'       PETTY_CASH_NO,',
'       PETTY_CASH_DATE,',
'       DUE_DATE,',
'       PETTY_CASH_TYPE,',
'       pc.employee_num,',
'       e.full_name_en  employee  ,',
'       e.org_name      employee_organization,',
'       e.department_name    employee_department,',
'       e.sector             employee_Sector,',
'       PROJECT_NUMBER,',
'       (select DISTINCT f.project_name',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number) Project_name,',
'      (select DISTINCT f.tca_sector',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number) Project_Sector,',
'      (select DISTINCT f.department',
'        from f_projectbudget f',
'        where f.project_number = pc.project_number) Project_Department,  ',
'       pc.TASK,',
'       pc.AMOUNT,',
'       PURPOSE,',
'       pc.CLOSING_DATE,',
'       pc.APPROVAL_STATUS,',
'       pc.STATUS,',
'       case pc.approval_status',
'        WHEN    ''Approved''  THEN ''green''',
'        WHEN    ''Rejected''   Then  ''red''',
'        When    ''In-Progress''   Then ''GoldenRod''',
'        ELSE    ''black''',
'       end    as  "status_color",',
'       pc.RECONCILED_DATE,',
'       pc.PRIORITY,',
'       pc.CREATION_DATE,',
'       pc.CREATED_BY,',
'       pc.UPDATED_BY,',
'       pc.UPDATED_DATE,',
'       YEAR,',
'       GL_ACCOUNT,',
'       JUSTIFICATION,',
'       COMMENT_TO_APPROVER,',
'        case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end   PHOTO',
'  from petty_cash_all_v pc, employees_v  e , organizations_details_v org',
'  where extract(YEAR from pc.petty_cash_date) = extract(year from sysdate)',
'  and pc.employee_num = e.employee_num',
'  and  pc.emp_org_id = org.org_id',
'  and (org.executive_director_num = :EMP_NUM',
'OR org.director_num = :EMP_NUM);'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P37_STATUS,P37_TYPE,P37_APPROVAL_STATUS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P37_SHOW'
,p_plug_display_when_cond2=>'1'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'All Petty cash Requests'
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
 p_id=>wwv_flow_api.id(52772587607336613)
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
,p_internal_uid=>54762625934400377
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6691542949326407)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6691931482326407)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Petty Cash#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6692317092326407)
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
 p_id=>wwv_flow_api.id(6692747653326408)
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
 p_id=>wwv_flow_api.id(6693149202326408)
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
 p_id=>wwv_flow_api.id(6693555160326408)
,p_db_column_name=>'EMPLOYEE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Employee'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6693946792326408)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6694329286326409)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6694684788326409)
,p_db_column_name=>'TASK'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6695131978326409)
,p_db_column_name=>'AMOUNT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6695518074326409)
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
 p_id=>wwv_flow_api.id(6695919141326410)
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
 p_id=>wwv_flow_api.id(6696287500326410)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Approval Status'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<span style="font-weight:bold;color:#status_color#">#APPROVAL_STATUS#</span>',
''))
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6696748011326410)
,p_db_column_name=>'STATUS'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6697078874326410)
,p_db_column_name=>'status_color'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Status Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6697530611326411)
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
 p_id=>wwv_flow_api.id(6697872443326411)
,p_db_column_name=>'PRIORITY'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
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
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6698356536326411)
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
 p_id=>wwv_flow_api.id(6698732509326411)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6699091581326412)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6699507318326412)
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
 p_id=>wwv_flow_api.id(6699882958326412)
,p_db_column_name=>'YEAR'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6700265160326412)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6700691504326413)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6701095881326413)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6701516367326413)
,p_db_column_name=>'PHOTO'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6701927144326414)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6689520663326405)
,p_db_column_name=>'EMPLOYEE_ORGANIZATION'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Employee Organization'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6689892529326405)
,p_db_column_name=>'EMPLOYEE_DEPARTMENT'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Employee Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6690309325326406)
,p_db_column_name=>'EMPLOYEE_SECTOR'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Employee Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6690723314326406)
,p_db_column_name=>'PROJECT_SECTOR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Project Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6691138443326406)
,p_db_column_name=>'PROJECT_DEPARTMENT'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Project Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(52799191904301785)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_alias=>'86923'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EMPLOYEE_NUM:EMPLOYEE:PETTY_CASH_NO:AMOUNT:PETTY_CASH_TYPE:PETTY_CASH_DATE:EMPLOYEE_ORGANIZATION:PROJECT_NUMBER:CLOSING_DATE:APPROVAL_STATUS:PHOTO:'
,p_sort_column_1=>'PETTY_CASH_NO'
,p_sort_direction_1=>'DESC'
,p_sum_columns_on_break=>'AMOUNT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6688854658326404)
,p_name=>'P37_SHOW'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(52533044130138172)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6702675164326414)
,p_name=>'P37_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(52772505209336612)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6703141499326415)
,p_name=>'P37_APPROVAL_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(52772505209336612)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6703472313326415)
,p_name=>'P37_TYPE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(52772505209336612)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.component_end;
end;
/
