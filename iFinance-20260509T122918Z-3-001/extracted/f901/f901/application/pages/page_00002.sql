prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>123
,p_default_id_offset=>6039605030667831
,p_default_owner=>'DEV'
);
wwv_flow_api.create_page(
 p_id=>2
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Petty Cash Requests'
,p_alias=>'PETTY-CASH-REQUESTS'
,p_step_title=>'Petty Cash Requests'
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
,p_last_upd_yyyymmddhh24miss=>'20200606225339'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8156985844189480)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8396446923387920)
,p_plug_name=>'Petty Cash Report'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
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
'       EMPLOYEE_NUM,',
'       (select e.full_name_en from dct_employees_list2 e where HRSS_PETTY_CASH.EMPLOYEE_NUM =  e.EMPLOYEE_NUM) EMPLOYEE,',
'       PROJECT_NUMBER,',
'       (select DISTINCT f.project_name',
'        from f_projectbudget f',
'        where f.project_number = hrss_petty_cash.project_number) Project_name,',
'      (select DISTINCT f.tca_sector',
'        from f_projectbudget f',
'        where f.project_number = hrss_petty_cash.project_number) Sector,',
'      (select DISTINCT f.department',
'        from f_projectbudget f',
'        where f.project_number = hrss_petty_cash.project_number) Department,  ',
'       TASK,',
'       AMOUNT,',
'       (select sum(nvl(l.receipt_amount,0))',
'        from hrss_expense_report_lines l',
'        where l.expense_report_id in (select er.expense_report_id',
'                                        from hrss_expense_reports er',
'                                        where er.petty_cash_id = hrss_petty_cash.petty_cash_id',
'                                        and er.type = ''C'')) Cleared_amount,',
'    (select sum(nvl(l.receipt_amount,0))',
'        from hrss_expense_report_lines l',
'        where l.expense_report_id in (select er.expense_report_id',
'                                        from hrss_expense_reports er',
'                                        where er.petty_cash_id = hrss_petty_cash.petty_cash_id',
'                                        and er.type = ''R'')) Reimburacement_amount,    ',
'       PURPOSE,',
'       CLOSING_DATE,',
'       APPROVAL_STATUS,',
'       STATUS,',
'       case hrss_petty_cash.approval_status',
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
'       ''http://s1defp1.dev.uae:7001/ords/dev/profile/view/'' || ''TCA'' || EMPLOYEE_NUM PHOTO',
'  from HRSS_PETTY_CASH',
'  where status = nvl(:P2_STATUS , STATUS)',
'  and EMPLOYEE_NUM = nvl(:P2_EMP_NUM , EMPLOYEE_NUM)',
'  and PETTY_CASH_TYPE = nvl(:P2_TYPE ,PETTY_CASH_TYPE)',
'  and approval_status = nvl(:P2_APPROVAL_STATUS , approval_status)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P2_EMP_NUM,P2_STATUS,P2_TYPE'
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
 p_id=>wwv_flow_api.id(8396529321387921)
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
,p_internal_uid=>8396529321387921
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8396607768387922)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8396703183387923)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Petty Cash No'
,p_column_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P3_PETTY_CASH_ID:#PETTY_CASH_ID#'
,p_column_linktext=>'#PETTY_CASH_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8396864764387924)
,p_db_column_name=>'PETTY_CASH_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Petty Cash Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8396934964387925)
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
 p_id=>wwv_flow_api.id(8397054866387926)
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
 p_id=>wwv_flow_api.id(8397108562387927)
,p_db_column_name=>'EMPLOYEE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Employee'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8397280412387928)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8397366706387929)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8397421305387930)
,p_db_column_name=>'SECTOR'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8397591749387931)
,p_db_column_name=>'DEPARTMENT'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8397617314387932)
,p_db_column_name=>'TASK'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8397798470387933)
,p_db_column_name=>'AMOUNT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8397826939387934)
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
 p_id=>wwv_flow_api.id(8397975229387935)
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
 p_id=>wwv_flow_api.id(8398030792387936)
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
 p_id=>wwv_flow_api.id(8398147836387937)
,p_db_column_name=>'STATUS'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8398231345387938)
,p_db_column_name=>'status_color'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Status Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8398393245387939)
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
 p_id=>wwv_flow_api.id(8398471676387940)
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
 p_id=>wwv_flow_api.id(8398585653387941)
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
 p_id=>wwv_flow_api.id(8398636288387942)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8398717093387943)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8398809617387944)
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
 p_id=>wwv_flow_api.id(8398906947387945)
,p_db_column_name=>'YEAR'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8399037374387946)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8399176323387947)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8399284471387948)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8499636395132119)
,p_db_column_name=>'PHOTO'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8499781013132120)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46553020149858716)
,p_db_column_name=>'CLEARED_AMOUNT'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Cleared Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46553144851858717)
,p_db_column_name=>'REIMBURACEMENT_AMOUNT'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Reimburacement Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(8423133618353093)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'84232'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_DATE:EMPLOYEE:EMPLOYEE_NUM:PROJECT_NUMBER:DEPARTMENT:TASK:AMOUNT:CLEARED_AMOUNT:REIMBURACEMENT_AMOUNT:PURPOSE:CLOSING_DATE:APPROVAL_STATUS:PHOTO:'
,p_sort_column_1=>'PETTY_CASH_NO'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(8215510777432605)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(8156985844189480)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Petty Cash'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(29268928471292309)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(8156985844189480)
,p_button_name=>'Reimbursement'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(8119922506175532)
,p_button_image_alt=>'Reimbursement'
,p_button_position=>'REGION_TEMPLATE_EDIT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29268466303292304)
,p_name=>'P2_EMP_NUM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(8396446923387920)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29268563791292305)
,p_name=>'P2_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(8396446923387920)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29268653231292306)
,p_name=>'P2_TYPE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(8396446923387920)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29268706221292307)
,p_name=>'P2_APPROVAL_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(8396446923387920)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(29271098803292330)
,p_computation_sequence=>10
,p_computation_item=>'P2_EMP_NUM'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select substr(:APP_USER , 4)',
'from dual;'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(29269025179292310)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(8215510777432605)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(29269155715292311)
,p_event_id=>wwv_flow_api.id(29269025179292310)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(8156985844189480)
);
wwv_flow_api.component_end;
end;
/
