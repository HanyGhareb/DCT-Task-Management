prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'HRSS'
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
,p_last_upd_yyyymmddhh24miss=>'20231212140356'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(27647013146425241)
,p_plug_name=>'Petty cash Availability'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'	<marquee width="90%" direction="left" scrollamount="8">',
'<p><strong style="color: red;"> As per DOF Instructions, The last day to process Petty cash, Clearing and Reimburesement requests will be by Friday 08-Dec-2023. Please make sure to process all your requests before that day.</strong> For any help, ple'
||'ase contact: <a href="mailto:IMaharmeh@dctabudhabi.ae">Israa Imad Maharmeh</a>.</p>',
'</marquee>'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'L_SHOW_CLOSE_MSG_YN    varchar2(1);',
'begin',
'',
'SELECT    SHOW_CLOSE_MSG_YN',
'INTO L_SHOW_CLOSE_MSG_YN',
'FROM hrss_configurations',
'where id = 1;',
'',
'if L_SHOW_CLOSE_MSG_YN = ''Y'' Then return true;',
'    else return false;',
' end if;',
' ',
'end;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2373058595091679)
,p_plug_name=>'Petty Cash Admin - Quick Access'
,p_icon_css_classes=>'fa-exclamation-circle-o fa-2x'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--stacked:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-LinksList--showBadge:t-LinksList--showArrow:t-LinksList--nowrap:t-LinksList--actions:t-LinksList--showIcons'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>3
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(2371670453091682)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(8116971789175529)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P1_IS_PETTY_CASH_ADMIN'
,p_plug_display_when_cond2=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4584001859120852)
,p_plug_name=>'My Expense Reports (&P1_YEAR.)'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>90
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select lable ,',
'        value,',
'        link,',
'        nvl(amount , 0.00) || '' AED'' total_amount',
'from(',
'select  ''Clearing''   lable   , ',
'        count(*) value,',
'        to_char(sum(nvl(e.expense_report_amount ,0)),''99,999,999.99'') amount,',
'        apex_util.prepare_url( ''f?p=&APP_ID.:16:''||:APP_SESSION||''::NO:2:P16_TYPE:''|| ''Clearing'' ) as link',
'from expense_reports_all_v e',
'where e.expense_report_type = ''Clearing''',
'and e.employee_num = :EMP_NUM',
'and EXPENSE_REPORT_APPROVAL_STATUS not in (''EXPENSE_REPORT_APPROVAL_STATUS'' , ''Stopped'')',
'UNION ALL',
'select  ''Reimbursement''   lable  ,',
'        count(*) value,',
'        to_char(sum(nvl(e.expense_report_amount ,0)),''99,999,999.99'') amount      ',
'         , apex_util.prepare_url( ''f?p=&APP_ID.:16:''||:APP_SESSION||''::NO:2:P16_TYPE:''|| ''Reimbursement'' ) as link',
'from expense_reports_all_v e',
'where e.expense_report_type = ''Reimbursement''',
'and e.employee_num = :EMP_NUM ',
'and EXPENSE_REPORT_APPROVAL_STATUS not in (''EXPENSE_REPORT_APPROVAL_STATUS'' , ''Stopped''));'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P1_IS_PETTY_CASH_ADMIN'
,p_plug_display_when_cond2=>'Y'
,p_attribute_01=>'TOTAL_AMOUNT'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'&LINK.'
,p_attribute_05=>'0'
,p_attribute_06=>'B'
,p_attribute_07=>'DOT'
,p_attribute_08=>'Y'
,p_attribute_09=>'LABLE'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(6404473733706772)
,p_name=>'Notifications History'
,p_template=>wwv_flow_api.id(8055912915175506)
,p_display_sequence=>150
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  SELECT  ',
'    ''fa-file-text-o fa-anim-flash fam-check fam-is-success'' AS NOTE_ICON,',
'    ''rgb(50,208,45)'' AS NOTE_ICON_COLOR, ',
'    decode((select a.petty_cash_type',
'    from hrss_petty_cash a',
'    where a.petty_cash_id = hrss_approval_history.request_id) , ''T'' , ''Temporary'' , ''Permanent'') ||',
'    '' Petty Cash Request'' AS NOTE_HEADER,',
'    ''Emp: ''                 ||',
'     (Select e.full_name_en',
'        from dct_bi_employees_v e',
'        where e.EMPLOYEE_NUM = (select pc.EMPLOYEE_NUM',
'                            from hrss_petty_cash pc',
'                            where pc.petty_cash_id = hrss_approval_history.request_id))                   ||',
'    '', Amount: ''                ||',
'    (select trim(to_char(p.amount,''99,999,999.99'') )',
'        from hrss_petty_cash p',
'        where p.petty_cash_id = hrss_approval_history.request_id) ||',
'    '' AED'' AS NOTE_TEXT,',
'    /* set the link when click on list item */',
'    apex_util.prepare_url(''f?p=101''',
'                          || '':6:''',
'                          || V(''APP_SESSION'')',
'                          || ''::NO::P6_PETTY_CASH_ID:''',
'                          || request_id)  AS NOTE_LINK, ',
'    ''rgb(50,208,45)'' AS NOTE_COLOR',
'   from hrss_approval_history',
'where user_name = :APP_USER',
'and status != ''Pending''',
'UNION ALL ',
' SELECT    case notification_type ',
'        when ''Petty Cash Approved''',
'                then',
'                        ''fa-emoji-slight-smile fa-anim-flash fam-check fam-is-success''',
'        when  ''Petty Cash Rejected''',
'                then    ''fa-emoji-angry fa-anim-flash fam-x fam-is-danger''',
'        when   ''Petty Cash Invoiced''',
'                then    ''fa-info-circle-o fa-anim-flash fam-check fam-is-info''',
'        when    ''Petty Cash Paid''',
'                then ''fa-money fa-anim-flash fam-check fam-is-success''',
'     End  AS NOTE_ICON,',
'    ''rgb(50,208,45)'' AS NOTE_ICON_COLOR, ',
'    notification_type                         AS NOTE_HEADER,',
'      ''Petty Cash# ''                                              ||  ',
'     (select hpc.petty_cash_no',
'        from hrss_petty_cash hpc',
'        where hpc.petty_cash_id = all_notifications.request_id)     ||',
'     ''- Amount: ''                                                   ||',
'    (select trim(to_char(hpc.amount,''99,999,999.99'') )',
'        from hrss_petty_cash hpc',
'        where hpc.petty_cash_id = all_notifications.request_id)     ||   ',
'    '' AED ''                                                          ||',
'    case notification_type ',
'        when ''Petty Cash Approved''',
'                then',
'                        ''has been Approved.''',
'        when  ''Petty Cash Rejected''',
'                then    ''has been Rejected.''',
'        when    ''Petty Cash Invoiced''',
'                then    ''has been invoiced, Payment will process soon.''',
'        when    ''Petty Cash Paid''',
'                then    ''has been paid.''',
'     End                                                        AS NOTE_TEXT,',
'    apex_util.prepare_url(''f?p=101''',
'                          || '':23:''',
'                          || V(''APP_SESSION'')',
'                          || ''::NO::P23_PETTY_CASH_ID,P23_NOTE_HEADER,P23_ID:''',
'                          || request_id ||'','' ||notification_type || '','' || id)  AS NOTE_LINK, ',
'    ''rgb(50,208,45)'' AS NOTE_COLOR',
'from all_notifications',
'where (user_name = :EMP_NUM',
'or user_name = :APP_USER)',
'and acknowledge = ''Y'';'))
,p_display_condition_type=>'NEVER'
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(8069530418175510)
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
 p_id=>wwv_flow_api.id(6405329966706780)
,p_query_column_id=>1
,p_column_alias=>'NOTE_ICON'
,p_column_display_sequence=>1
,p_column_heading=>'Note Icon'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6405393019706781)
,p_query_column_id=>2
,p_column_alias=>'NOTE_ICON_COLOR'
,p_column_display_sequence=>2
,p_column_heading=>'Note Icon Color'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6405500341706782)
,p_query_column_id=>3
,p_column_alias=>'NOTE_HEADER'
,p_column_display_sequence=>3
,p_column_heading=>'Note Header'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6405611673706783)
,p_query_column_id=>4
,p_column_alias=>'NOTE_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Note Text'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6405753651706784)
,p_query_column_id=>5
,p_column_alias=>'NOTE_LINK'
,p_column_display_sequence=>5
,p_column_heading=>'Note Link'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6405763201706785)
,p_query_column_id=>6
,p_column_alias=>'NOTE_COLOR'
,p_column_display_sequence=>6
,p_column_heading=>'Note Color'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(28990352592398925)
,p_plug_name=>'Worklist'
,p_icon_css_classes=>'fa-thumbs-o-up fa-anim-flash fam-check fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>100
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select request_id',
'       , decode((Select p.petty_cash_type',
'        from hrss_petty_cash p',
'        where p.petty_cash_id = h.request_id ), ''T'' , ''Tempoarty Petty Cash'' , ''Permanent Petty Cash'') Request_type',
'      , (select e.full_name_en ',
'                    from dct_employees_list2 e',
'                    where e.user_name = updated_by)                         as "from"',
'     , ''Approval Required for ''     ||',
'       decode((Select p.petty_cash_type',
'        from hrss_petty_cash p',
'        where p.petty_cash_id = h.request_id ), ''T'' , ''Tempoarty Petty Cash'' , ''Permanent Petty Cash'') ||',
'       ''#: '' || ',
'       (Select p.petty_cash_no',
'        from hrss_petty_cash p',
'        where p.petty_cash_id = h.request_id )                 ||',
'    '', Amount: ''                ||',
'    (select trim(to_char(sum(p.amount),''99,999,999.99'')) ',
'        from hrss_petty_cash p',
'        where p.petty_cash_id = h.request_id) ||',
'    '' AED''      as "Subject"',
'    , h.recevied_date',
'    ,(Select p.priority',
'        from hrss_petty_cash p',
'        where p.petty_cash_id = h.request_id ) Priority',
'   ,RECEVIED_DATE     RECEVIED_TIME     ',
'from hrss_approval_history h',
'where lower(user_name) = lower(:APP_USER)',
' and h.status = ''Pending'''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_required_role=>wwv_flow_api.id(29304425585911441)
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Worklist'
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
 p_id=>wwv_flow_api.id(30626181902214738)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>30626181902214738
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30626269887214739)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30626330827214740)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30626418029214741)
,p_db_column_name=>'from'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'From'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30626589260214742)
,p_db_column_name=>'Subject'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Subject'
,p_column_link=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::P6_PETTY_CASH_ID:#REQUEST_ID#'
,p_column_linktext=>'#Subject#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30626688039214743)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30626729752214744)
,p_db_column_name=>'PRIORITY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30626835911214745)
,p_db_column_name=>'RECEVIED_TIME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Recevied Time'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(43114781917395778)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'431148'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_TYPE:from:Subject:RECEVIED_DATE:PRIORITY:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(29268354546292303)
,p_plug_name=>'My Temporary Petty Cash (&P1_YEAR.)'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select lable ,',
'        value,',
'        link,',
'        nvl(amount , 0.00) || '' AED'' total_amount',
'from (',
'',
'select ''Open'' lable , Count(*) value ',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':2:''||:APP_SESSION||''::NO:2:P2_STATUS,P2_TYPE:''|| ''Open,T'' ) as link',
'--        ,to_char(sum(nvl(amount,0)),''99,999,999.99'')|| '' AED'' Total_amoount,',
'        ,to_char(sum(nvl(amount,0)),''99,999,999.99'')  amount',
'from hrss_petty_cash',
'where status =  ''Open''',
'and employee_num = :EMP_NUM --Substr(:APP_USER,4)',
'and petty_cash_type = ''T''',
'and hrss_petty_cash.approval_status not in (''Stopped'' , ''Cancel'')',
'UNION ALL',
'select ''All Petty Cash in '' || Extract(YEAR from sysdate) lable , Count(*) value ',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':2:''||:APP_SESSION||''::NO:2:P2_TYPE:''|| ''T'' ) as link',
'--        ,to_char(sum(nvl(amount,0)),''99,999,999.99'')|| '' AED'' Total_amoount',
'        ,to_char(sum(nvl(amount,0)),''99,999,999.99'')       amount',
'from hrss_petty_cash',
'where employee_num = :EMP_NUM   -- Substr(:APP_USER,4)',
'and extract(YEAR from petty_cash_date ) = Extract(YEAR from sysdate)',
'and petty_cash_type = ''T'' ',
'and hrss_petty_cash.approval_status not in (''Stopped'' , ''Cancel''));'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P1_IS_PETTY_CASH_ADMIN'
,p_plug_display_when_cond2=>'Y'
,p_attribute_01=>'TOTAL_AMOUNT'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'&LINK.'
,p_attribute_05=>'0'
,p_attribute_06=>'B'
,p_attribute_07=>'DOT'
,p_attribute_08=>'Y'
,p_attribute_09=>'LABLE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(29268813695292308)
,p_plug_name=>'Petty Cash By Status'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>120
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Total'' lable , Count(*) value ',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':2:''||:APP_SESSION) as link',
'        ,to_char(sum(amount),''99,999,999.99'')|| '' AED'' Total_amoount',
'from hrss_petty_cash',
'where employee_num = Substr(:APP_USER,4)',
'UNION ALL',
'select ''Approved'' lable , Count(*) value ',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':2:''||:APP_SESSION||''::NO::P2_APPROVAL_STATUS:''|| ''Approved'' ) as link',
'        ,to_char(sum(amount),''99,999,999.99'')|| '' AED'' Total_amoount',
'from hrss_petty_cash',
'where approval_status =  ''Approved''',
'and employee_num = Substr(:APP_USER,4)',
'UNION ALL',
'select ''In-Progress'' lable , Count(*) value ',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':2:''||:APP_SESSION||''::NO::P2_APPROVAL_STATUS:''|| ''In-Progress'' ) as link',
'        ,to_char(sum(amount),''99,999,999.99'')|| '' AED'' Total_amoount',
'from hrss_petty_cash',
'where approval_status =  ''In-Progress''',
'and employee_num = Substr(:APP_USER,4)',
'UNION ALL',
'select ''Rejected'' lable , Count(*) value ',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':2:''||:APP_SESSION||''::NO::P2_APPROVAL_STATUS:''|| ''Rejected'' ) as link',
'        ,to_char(sum(amount),''99,999,999.99'')|| '' AED'' Total_amoount',
'from hrss_petty_cash',
'where approval_status =  ''Rejected''',
'and employee_num = Substr(:APP_USER,4)',
'UNION ALL',
'select ''Draft'' lable , Count(*) value ',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':2:''||:APP_SESSION||''::NO::P2_APPROVAL_STATUS:''|| ''Draft'' ) as link',
'        ,to_char(sum(amount),''99,999,999.99'')|| '' AED'' Total_amoount',
'from hrss_petty_cash',
'where approval_status =  ''Draft''',
'and employee_num = Substr(:APP_USER,4);',
''))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_attribute_01=>'TOTAL_AMOOUNT'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'f?p=&APP_ID.:&LINK.:&SESSION.::&DEBUG.:::'
,p_attribute_05=>'0'
,p_attribute_07=>'BOX'
,p_attribute_08=>'Y'
,p_attribute_09=>'LABLE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(29269700336292317)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30217616527181325)
,p_plug_name=>'Pending with Accounts Payable'
,p_icon_css_classes=>'fa-exclamation fa-anim-flash fam-pause fam-is-warning'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>140
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_required_role=>wwv_flow_api.id(29304211950907897)
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(29960934602468916)
,p_plug_name=>'To Be Processed By AP'
,p_parent_plug_id=>wwv_flow_api.id(30217616527181325)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select petty_cash_id,',
'    petty_cash_no,',
'    petty_cash_date,',
'    due_date,',
'    petty_cash_type,',
'    pc.employee_num,',
'    project_number,',
'    task,',
'    amount,',
'    purpose,',
'    closing_date,',
'    approval_status,',
'    status,',
'    reconciled_date,',
'    priority,',
'    creation_date,',
'    created_by,',
'    updated_by,',
'    updated_date,',
'    year,',
'    gl_account,',
'    justification,',
'    comment_to_approver,',
'    invoicing_yn,',
'    paid_yn,',
'    invoice_number,',
'    invoice_date,',
'    pv_number,',
'    gl_date,',
'    payment_number,',
'    payment_date',
'    ,e.full_name_en employye_name',
'    ,e.full_name_ar    employee_name_ar',
'    , case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                ''http://s1defp1.dev.uae:7001/ords/dev/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'           ''http://s1defp1.dev.uae:7001/ords/dev/profile/view/TCA'' || upper(pc.employee_num)',
'           end Photo',
'from hrss_petty_cash  pc , dct_employees_list2  e',
'where pc.employee_num = e.employee_num (+)',
'and approval_status = ''Approved''',
'and invoicing_yn = ''N'''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'To Be Processed By AP'
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
 p_id=>wwv_flow_api.id(29961056114468917)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>29961056114468917
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29961119768468918)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29961218791468919)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Petty Cash#'
,p_column_link=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.::P24_PETTY_CASH_ID,P24_TREASURY:#PETTY_CASH_ID#,N'
,p_column_linktext=>'#PETTY_CASH_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29961322210468920)
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
 p_id=>wwv_flow_api.id(29961402369468921)
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
 p_id=>wwv_flow_api.id(29961599598468922)
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
 p_id=>wwv_flow_api.id(29961602904468923)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29961711706468924)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29961816968468925)
,p_db_column_name=>'TASK'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29961972461468926)
,p_db_column_name=>'AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29962009352468927)
,p_db_column_name=>'PURPOSE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29962185261468928)
,p_db_column_name=>'CLOSING_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Closing Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29962201933468929)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29962335702468930)
,p_db_column_name=>'STATUS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29962446973468931)
,p_db_column_name=>'RECONCILED_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Reconciled Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29962556477468932)
,p_db_column_name=>'PRIORITY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29962681250468933)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29962766727468934)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29962802687468935)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29962999501468936)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
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
 p_id=>wwv_flow_api.id(29963025224468937)
,p_db_column_name=>'YEAR'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29963132617468938)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29963223591468939)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29963352465468940)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29963477842468941)
,p_db_column_name=>'INVOICING_YN'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Invoicing ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29963580842468942)
,p_db_column_name=>'PAID_YN'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Paid?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43119239803427609)
,p_db_column_name=>'INVOICE_NUMBER'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43119354027427610)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43119414308427611)
,p_db_column_name=>'PV_NUMBER'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Pv Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43119573584427612)
,p_db_column_name=>'GL_DATE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Gl Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43119681262427613)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43119774797427614)
,p_db_column_name=>'PAYMENT_DATE'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Payment Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43119856233427615)
,p_db_column_name=>'EMPLOYYE_NAME'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Employye Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43119965748427616)
,p_db_column_name=>'EMPLOYEE_NAME_AR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Employee Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43120010677427617)
,p_db_column_name=>'PHOTO'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(30181444057927031)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'301815'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_DATE:PETTY_CASH_TYPE:EMPLOYEE_NUM:PROJECT_NUMBER:AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY:PHOTO:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30218531983181334)
,p_plug_name=>'To Be Processed By Treasury'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>130
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select *',
'from hrss_petty_cash',
'where approval_status = ''Approved''',
'and Paid_yn = ''N''',
'and invoicing_yn = ''Y'''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'To Be Processed By Treasury'
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
 p_id=>wwv_flow_api.id(30218618262181335)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>30218618262181335
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30218752443181336)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30218889398181337)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Petty Cash#'
,p_column_link=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.::P24_PETTY_CASH_ID,P24_TREASURY:#PETTY_CASH_ID#,Y'
,p_column_linktext=>'#PETTY_CASH_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30218961739181338)
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
 p_id=>wwv_flow_api.id(30219030719181339)
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
 p_id=>wwv_flow_api.id(30219143074181340)
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
 p_id=>wwv_flow_api.id(30219299663181341)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30219322746181342)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30219411440181343)
,p_db_column_name=>'TASK'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30219515897181344)
,p_db_column_name=>'AMOUNT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30219692482181345)
,p_db_column_name=>'PURPOSE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Purpose'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30219740215181346)
,p_db_column_name=>'CLOSING_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Closing Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30219826460181347)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30219941808181348)
,p_db_column_name=>'STATUS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30220075062181349)
,p_db_column_name=>'RECONCILED_DATE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Reconciled Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30220169841181350)
,p_db_column_name=>'PRIORITY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30353131395996001)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30353276317996002)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30353328490996003)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30353488739996004)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30353528920996005)
,p_db_column_name=>'YEAR'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30353633474996006)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30353706043996007)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30353874131996008)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30353943277996009)
,p_db_column_name=>'INVOICING_YN'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Invoicing ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30354022985996010)
,p_db_column_name=>'PAID_YN'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Paid?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(29465087738252226)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30354135149996011)
,p_db_column_name=>'INVOICE_NUMBER'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Invoice Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30354286158996012)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30354359914996013)
,p_db_column_name=>'PV_NUMBER'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Pv Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30354436065996014)
,p_db_column_name=>'GL_DATE'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Gl Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30354503111996015)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30354678394996016)
,p_db_column_name=>'PAYMENT_DATE'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Payment Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(30367933771000781)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'303680'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_DATE:PETTY_CASH_TYPE:EMPLOYEE_NUM:PROJECT_NUMBER:TASK:AMOUNT:CLOSING_DATE:APPROVAL_STATUS:PRIORITY:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30580620169848502)
,p_plug_name=>'Pending Expense Reports- Payables'
,p_icon_css_classes=>'fa-money fa-anim-flash fam-information fam-is-warning'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  ''Clearing'' label,',
'        COUNT( distinct l.expense_report_id) value,',
'        trim(to_char(sum(l.receipt_amount), ''99,999,999.99'')) || '' AED'' total_amount',
'        ,apex_util.prepare_url( ''f?p=''||:APP_ID||'':15:''||:APP_SESSION||''::NO::P15_DISPLAY,P15_TYPE,P15_INVOICED,P15_PAID,P15_PENDING_WITH_AP:''|| ''E,Clearing,N,N,Y'' ) as link',
'from hrss_expense_report_lines l',
'where l.expense_report_id in (Select e.expense_report_id',
'                                from hrss_expense_reports e',
'                                where e.type = ''C''',
'                                and e.approval_status = ''Approved''',
'                                and e.pending_with_ap = ''Y'')',
'Union all',
'select  ''Reimbursement'' label,',
'        COUNT( distinct l.expense_report_id) value,',
'        trim(to_char(sum(l.receipt_amount), ''99,999,999.99'')) || '' AED'' total_amount',
'        ,apex_util.prepare_url( ''f?p=''||:APP_ID||'':15:''||:APP_SESSION||''::NO::P15_DISPLAY,P15_TYPE,P15_INVOICED,P15_PAID,P15_PENDING_WITH_AP:''|| ''E,Reimbursement,N,N,Y'' ) as link',
'from hrss_expense_report_lines l',
'where l.expense_report_id in (Select e.expense_report_id',
'                                from hrss_expense_reports e',
'                                where e.type = ''R''',
'                                and e.approval_status = ''Approved''',
'                                and e.pending_with_ap = ''Y'')',
''))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P1_IS_PETTY_CASH_ADMIN'
,p_plug_display_when_cond2=>'Y'
,p_attribute_01=>'TOTAL_AMOUNT'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'&LINK.'
,p_attribute_05=>'2'
,p_attribute_06=>'B'
,p_attribute_07=>'DOT'
,p_attribute_08=>'Y'
,p_attribute_09=>'LABEL'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30580922504848505)
,p_plug_name=>'Processed Expense Reports - Payables'
,p_icon_css_classes=>'fa-history fa-rotate-90 fam-heart fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:t-Form--noPadding:margin-left-none:margin-right-sm'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  ''Clearing'' label,',
'        COUNT( distinct l.expense_report_id) value,',
'        trim(to_char(sum(l.receipt_amount), ''99,999,999.99'')) || '' AED'' total_amount',
'        ,apex_util.prepare_url( ''f?p=''||:APP_ID||'':15:''||:APP_SESSION||''::NO::P15_DISPLAY,P15_TYPE,P15_INVOICED,P15_PAID,P15_PENDING_WITH_AP:''|| ''EP,Clearing,N,N,N'' ) as link',
'from hrss_expense_report_lines l',
'where l.expense_report_id in (Select e.expense_report_id',
'                                from hrss_expense_reports e',
'                                where e.type = ''C''',
'                                and e.approval_status = ''Approved''',
'                                and e.pending_with_ap = ''N'')',
'Union all',
'select  ''Reimbursement'' label,',
'        COUNT( distinct l.expense_report_id) value,',
'        trim(to_char(sum(l.receipt_amount), ''99,999,999.99'')) || '' AED'' total_amount',
'        ,apex_util.prepare_url( ''f?p=''||:APP_ID||'':15:''||:APP_SESSION||''::NO::P15_DISPLAY,P15_TYPE,P15_INVOICED,P15_PAID,P15_PENDING_WITH_AP:''|| ''EP,Reimbursement,N,N,N'' ) as link',
'from hrss_expense_report_lines l',
'where l.expense_report_id in (Select e.expense_report_id',
'                                from hrss_expense_reports e',
'                                where e.type = ''R''',
'                                and e.approval_status = ''Approved''',
'                                and e.pending_with_ap = ''N'')',
''))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P1_IS_PETTY_CASH_ADMIN'
,p_plug_display_when_cond2=>'Y'
,p_attribute_01=>'TOTAL_AMOUNT'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'&LINK.'
,p_attribute_05=>'2'
,p_attribute_06=>'B'
,p_attribute_07=>'DOT'
,p_attribute_08=>'Y'
,p_attribute_09=>'LABEL'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30622677330214703)
,p_plug_name=>'Pending Petty Cash - Payables'
,p_icon_css_classes=>'fa-money fa-anim-flash fam-information fam-is-warning'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''Temporary'' lable , ',
'        Count(*) value , ',
'        apex_util.prepare_url( ''f?p=''||:APP_ID||'':15:''||:APP_SESSION||''::NO::P15_DISPLAY,P15_TYPE,P15_INVOICED,P15_PAID:''|| ''P,'' || ''T,N,N'' ) as link',
'        ,to_char(sum(nvl(amount,0)),''99,999,999.99'')|| '' AED'' Total_amoount',
'from hrss_petty_cash',
'where approval_status = ''Approved''',
'-- and Paid_yn = ''N''',
'-- and invoicing_yn = ''N''',
'and pending_with_ap = ''Y''',
'and petty_cash_type = ''T''',
'UNION all ',
'select ''Permanent'' lable , ',
'        Count(*) value , ',
'        apex_util.prepare_url( ''f?p=''||:APP_ID||'':15:''||:APP_SESSION||''::NO::P15_DISPLAY,P15_TYPE,P15_INVOICED,P15_PAID:''|| ''P'' || '','' || ''P,N,N'' ) as link',
'        ,to_char(sum(nvl(amount,0)),''99,999,999.99'')|| '' AED'' Total_amoount',
'from hrss_petty_cash',
'where approval_status = ''Approved''',
'-- and Paid_yn = ''N''',
'-- and invoicing_yn = ''N''',
'and pending_with_ap = ''Y''',
'and petty_cash_type = ''P'''))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P1_IS_PETTY_CASH_ADMIN'
,p_plug_display_when_cond2=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'&LINK.'
,p_attribute_05=>'2'
,p_attribute_06=>'B'
,p_attribute_07=>'DOT'
,p_attribute_08=>'Y'
,p_attribute_09=>'LABLE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30622997007214706)
,p_plug_name=>'Processed Petty Cash - Payables'
,p_icon_css_classes=>'fa-history  fa-rotate-90 fam-heart fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>50
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select lable ',
'        , value',
'        , Link',
'--        , amount',
'--        , total_amount',
'        , nvl(amount , 0.00) || '' AED''  Total_amount ',
'from (select ''Temporary Processed in '' || EXTRACT(YEAR FROM sysdate) lable , ',
'        Count(*) value , ',
'        apex_util.prepare_url( ''f?p=''||:APP_ID||'':15:''||:APP_SESSION||''::NO:15:P15_DISPLAY,P15_TYPE,P15_YEAR,P15_INVOICED:''|| ''H,T,'' || extract(year from sysdate) || '',Y''  ) as link',
'        ,to_char(sum(nvl(amount,0)),''99,999,999.99'')|| '' AED'' Total_amount',
'        , to_char(sum(nvl(amount,0)),''99,999,999.99'') amount',
'from hrss_petty_cash',
'where approval_status = ''Approved''',
'--and Paid_yn = ''Y''',
'--and invoicing_yn = ''Y''',
'and pending_with_ap = nvl(''N'',pending_with_ap)      ',
'and petty_cash_type = ''T''',
'and  EXTRACT(YEAR FROM hrss_petty_cash.invoice_date) = EXTRACT(YEAR FROM sysdate) ',
'-- and EXTRACT(MONTH FROM payment_date) = nvl(:P1_MONTH ,EXTRACT(MONTH FROM sysdate)  )',
'UNION ALL',
'select ''Permanent Processed in '' || EXTRACT(YEAR FROM sysdate) lable , ',
'        Count(*) value , ',
'        apex_util.prepare_url( ''f?p=''||:APP_ID||'':15:''||:APP_SESSION||''::NO:15:P15_DISPLAY,P15_TYPE,P15_YEAR,P15_INVOICED:''|| ''H,P,'' || extract(year from sysdate) || '',Y'' ) as link',
'        ,to_char(sum(nvl(amount,0)),''99,999,999.99'')|| '' AED'' Total_amount',
'        ,to_char(sum(nvl(amount,0)),''99,999,999.99'')    amount',
'from hrss_petty_cash',
'where approval_status = ''Approved''',
'-- and Paid_yn = ''Y''',
'-- and invoicing_yn = ''Y''',
'and pending_with_ap = nvl(''N'',pending_with_ap)    ',
'and petty_cash_type = ''P''',
'and  EXTRACT(YEAR FROM hrss_petty_cash.invoice_date) = EXTRACT(YEAR FROM sysdate) )'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P1_IS_PETTY_CASH_ADMIN'
,p_plug_display_when_cond2=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'&LINK.'
,p_attribute_05=>'2'
,p_attribute_06=>'B'
,p_attribute_07=>'DOT'
,p_attribute_08=>'Y'
,p_attribute_09=>'LABLE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30623370054214710)
,p_plug_name=>'My Permanent Petty Cash (&P1_YEAR.)'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>80
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select lable ,',
'        value,',
'        link,',
'        nvl(amount , 0.00) || '' AED'' total_amount',
'from (',
'select ''Open'' lable , Count(*) value ',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':2:''||:APP_SESSION||''::NO:2:P2_STATUS,P2_TYPE:''|| ''Open,P'' ) as link',
'--        ,to_char(sum(nvl(amount,0)),''99,999,999.99'')|| '' AED'' Total_amoount,',
'        ,to_char(sum(nvl(amount,0)),''99,999,999.99'')  amount',
'from hrss_petty_cash',
'where status =  ''Open''',
'and employee_num = :EMP_NUM -- Substr(:APP_USER,4)',
'and petty_cash_type = ''P''',
'and hrss_petty_cash.approval_status not in (''Stopped'' , ''Cancel'')',
'UNION ALL',
'select ''All Petty Cash in '' || Extract(YEAR from sysdate) lable , Count(*) value ',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':2:''||:APP_SESSION||''::NO:2:P2_TYPE:''|| ''P'' ) as link',
'--        ,to_char(sum(nvl(amount,0)),''99,999,999.99'')|| '' AED'' Total_amoount',
'        ,to_char(sum(nvl(amount,0)),''99,999,999.99'')       amount',
'from hrss_petty_cash',
'where employee_num = :EMP_NUM   --Substr(:APP_USER,4)',
'and extract(YEAR from petty_cash_date ) = Extract(YEAR from sysdate)',
'and petty_cash_type = ''P'' ',
'and hrss_petty_cash.approval_status not in (''Stopped'' , ''Cancel''));'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P1_IS_PETTY_CASH_ADMIN'
,p_plug_display_when_cond2=>'Y'
,p_attribute_01=>'TOTAL_AMOUNT'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'&LINK.'
,p_attribute_05=>'0'
,p_attribute_06=>'B'
,p_attribute_07=>'DOT'
,p_attribute_08=>'Y'
,p_attribute_09=>'LABLE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30626934945214746)
,p_plug_name=>'Approval History'
,p_icon_css_classes=>'fa-thumbs-o-up fa-anim-flash fam-check fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>110
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select h.request_id',
'      ,''Petty Cash''   request_type',
'      ,pc.emp_name          "From"',
'      ,''Approval Required for ''                     ||',
'        pc.petty_cash_type                          ||',
'        '' Petty Cash#''                                         ||',
'        pc.petty_cash_no                            ||',
'        '', Amount: ''                                ||',
'        trim(to_char(pc.amount ,''99,999,999.99''))   ||',
'        '' AED''              as "Subject"',
'       , h.recevied_date',
'       , h.action_date',
'       , pc.priority',
'       , h.status',
'       ,apex_util.prepare_url(''f?p=101''',
'                          || '':6:''',
'                          || V(''APP_SESSION'')',
'                          || ''::NO::P6_PETTY_CASH_ID:''',
'                          || request_id)  AS NOTE_LINK',
'from hrss_approval_history h , petty_cash_all_v pc',
'where h.request_id = pc.petty_cash_id (+)',
'and h.user_name = :APP_USER',
'and h.status in (''Approved'' , ''Rejected'' , ''Delegated'')',
'UNION ALL',
'select  h.request_id                        request_id',
'       ,''Expense Report''                      Request_type',
'       ,(select e.full_name_en',
'            from employees_v e',
'            where e.employee_num = er.employee_num)  "From"',
'       , ''Approval Required for ''                                  ||',
'         er.expense_report_type                                    ||',
'         '' Expense Report#''                                                       ||',
'         er.EXPENSE_REPORT_NUM                                     ||',
'         '' ,Amount: ''                                              ||',
'         trim(to_char(er.expense_report_amount ,''99,999,999.99''))  ||  ',
'         '' AED''              as                 "Subject"',
'         , h.recevied_date',
'         , h.action_date',
'         , er.expense_report_priority',
'         , h.status',
'         ,apex_util.prepare_url(''f?p=101''',
'                          || '':38:''',
'                          || V(''APP_SESSION'')',
'                          || ''::NO::P38_EXPENSE_REPORT_ID,P38_ID:''',
'                          || request_id ||'',''  || id)  AS NOTE_LINK',
'from hrss_expense_report_approval_history h , expense_reports_all_v er ',
'where h.REQUEST_ID = er.expense_report_id (+)',
'and h.user_name = :APP_USER',
'and h.status in (''Approved'' , ''Rejected'' , ''Delegated'');',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>'select * from user_approval_history_v'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approval History'
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
,p_plug_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'to display all the approval history for loged in user (''Approved'' , ''Rejected'' , ''Delegated'')',
'using view [user_approval_history] '))
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(30627227528214749)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>30627227528214749
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(30627367091214750)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43118458302427601)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43118698419427603)
,p_db_column_name=>'Subject'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Subject'
,p_column_type=>'STRING'
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
 p_id=>wwv_flow_api.id(43118764598427604)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43118898519427605)
,p_db_column_name=>'PRIORITY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(8338101286248980)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(43119194678427608)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(4584755885120859)
,p_db_column_name=>'From'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'From'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5395419614457442)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27928858735113353)
,p_db_column_name=>'NOTE_LINK'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Note Link'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(43127580466432643)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'431276'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_TYPE:From:Subject:STATUS:RECEVIED_DATE:PRIORITY::ACTION_DATE:NOTE_LINK'
,p_sort_column_1=>'ACTION_DATE'
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(132954212576963031)
,p_plug_name=>'Petty Cash Report - FBP'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8057862405175507)
,p_plug_display_sequence=>160
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
'       pc.EMPLOYEE_NUM,',
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
'  where pc.employee_num = e.employee_num',
'  and pc.APPROVAL_STATUS = NVL(:P8_APPROVAL_STATUS , pc.APPROVAL_STATUS)',
'  ',
'  and pc.petty_cash_id in (select h.request_id',
'                            from hrss_approval_history h',
'                            where h.person_id = :PERSON_ID)',
'',
'  ',
'  );'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'IS_FBP_EMP'
,p_plug_display_when_cond2=>'Y'
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
 p_id=>wwv_flow_api.id(132954294974963032)
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
,p_internal_uid=>200939794622365301
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27178318927120441)
,p_db_column_name=>'PETTY_CASH_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Petty Cash Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27178773637120442)
,p_db_column_name=>'PETTY_CASH_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Petty Cash#'
,p_column_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P3_PETTY_CASH_ID,P3_ID:#PETTY_CASH_ID#,#PETTY_CASH_ID#'
,p_column_linktext=>'#PETTY_CASH_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27179159535120443)
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
 p_id=>wwv_flow_api.id(27179565708120443)
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
 p_id=>wwv_flow_api.id(27179948667120444)
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
 p_id=>wwv_flow_api.id(27180386288120445)
,p_db_column_name=>'EMPLOYEE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Employee'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27180713267120445)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27181193306120446)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27181556215120446)
,p_db_column_name=>'TASK'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27181955235120447)
,p_db_column_name=>'AMOUNT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27182344160120448)
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
 p_id=>wwv_flow_api.id(27182770992120448)
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
 p_id=>wwv_flow_api.id(27183113888120449)
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
 p_id=>wwv_flow_api.id(27183571651120450)
,p_db_column_name=>'STATUS'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27183991859120450)
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
 p_id=>wwv_flow_api.id(27184314791120451)
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
 p_id=>wwv_flow_api.id(27184770744120452)
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
 p_id=>wwv_flow_api.id(27185157259120452)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27185589230120453)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27185969368120454)
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
 p_id=>wwv_flow_api.id(27186328561120454)
,p_db_column_name=>'YEAR'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27186759575120455)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27187173397120455)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27187590209120456)
,p_db_column_name=>'COMMENT_TO_APPROVER'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Comment To Approver'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27187962572120457)
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
 p_id=>wwv_flow_api.id(27188399756120458)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27175139254120435)
,p_db_column_name=>'EMPLOYEE_DEPARTMENT'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Employee Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27175538718120437)
,p_db_column_name=>'EMPLOYEE_SECTOR'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Employee Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27175980833120438)
,p_db_column_name=>'PROJECT_SECTOR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Project Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27176323748120438)
,p_db_column_name=>'PROJECT_DEPARTMENT'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Project Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27176706132120439)
,p_db_column_name=>'CLEARED_AMOUNT'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Cleared Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27177176356120439)
,p_db_column_name=>'REIMBURACEMENT_AMOUNT'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Reimburacement Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27177523438120440)
,p_db_column_name=>'STATUS_COLOR'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Status Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(27177917261120441)
,p_db_column_name=>'OUTSTANDING_AMOUNT'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Outstanding Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(132980899271928204)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_alias=>'951742'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PETTY_CASH_NO:PETTY_CASH_TYPE:PETTY_CASH_DATE:EMPLOYEE:EMPLOYEE_NUM:EMPLOYEE_SECTOR:AMOUNT:CLEARED_AMOUNT:REIMBURACEMENT_AMOUNT:OUTSTANDING_AMOUNT:APPROVAL_STATUS:PHOTO:'
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
 p_id=>wwv_flow_api.id(27194937264168634)
,p_report_id=>wwv_flow_api.id(132980899271928204)
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
 p_id=>wwv_flow_api.id(29269683524292316)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(29269700336292317)
,p_button_name=>'New_Petty_Cash'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Petty Cash'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'',
'l_enable_petty_cash    varchar2(1);',
'',
'begin',
'',
'select nvl(enable_petty_cash ,''Y'')',
'into l_enable_petty_cash',
'from hrss_configurations',
'where id = 1;',
'',
'',
'    if l_enable_petty_cash = ''Y'' then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(16283594537544343)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(29269700336292317)
,p_button_name=>'New_Petty_Cash_available'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Petty Cash'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:61:&SESSION.::&DEBUG.:::'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'',
'l_enable_petty_cash    varchar2(1);',
'',
'begin',
'',
'select enable_petty_cash',
'into l_enable_petty_cash',
'from hrss_configurations',
'where id = 1;',
'',
'',
'    if l_enable_petty_cash = ''N'' then',
'        return false;',
'    else',
'        return True;',
'    end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(43120513050427622)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(29269700336292317)
,p_button_name=>'Expense_Report'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Expense Report'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.:35:P35_PAGE_FROM:1'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'',
'l_enable_clearing    varchar2(1);',
'',
'begin',
'',
'select enable_clearing',
'into l_enable_clearing',
'from hrss_configurations',
'where id = 1;',
'',
'',
'    if l_enable_clearing = ''Y'' then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(16283423606544342)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(29269700336292317)
,p_button_name=>'Expense_Report_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(8120043720175533)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Expense Report'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:61:&SESSION.::&DEBUG.:::'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'',
'l_enable_clearing    varchar2(1);',
'',
'begin',
'',
'select enable_clearing',
'into l_enable_clearing',
'from hrss_configurations',
'where id = 1;',
'',
'',
'    if l_enable_clearing = ''N'' then',
'        return false;',
'    else',
'        return True;',
'    end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(29270205707292322)
,p_branch_name=>'Go to 3'
,p_branch_action=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_COMPUTATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(29269683524292316)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1929838801356599)
,p_name=>'P1_IS_PETTY_CASH_ADMIN'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(29269700336292317)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5397601041457464)
,p_name=>'P1_YEAR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(29269700336292317)
,p_item_default=>'SELECT Extract(YEAR from sysdate) FROM DUAL'
,p_item_default_type=>'SQL_QUERY'
,p_source=>'SELECT Extract(YEAR from sysdate) FROM DUAL'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(27189561162120463)
,p_name=>'P1_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(132954212576963031)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(27189939415120464)
,p_name=>'P1_APPROVAL_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(132954212576963031)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(27190389687120465)
,p_name=>'P1_TYPE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(132954212576963031)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29269246582292312)
,p_name=>'P1_TEMP_COUNT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(28990352592398925)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29269315277292313)
,p_name=>'P1_PERM_COUNT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(28990352592398925)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30627020074214747)
,p_name=>'P1_TEMP_COUNT_1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(30626934945214746)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(30627128589214748)
,p_name=>'P1_PERM_COUNT_1'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(30626934945214746)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(29269432093292314)
,p_computation_sequence=>10
,p_computation_item=>'P1_TEMP_COUNT'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(petty_cash_no) ',
'from hrss_petty_cash',
'where employee_num = substr(:APP_USER,4)',
'and status = ''Open''',
'AND petty_cash_type = ''T'';'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(29269504819292315)
,p_computation_sequence=>20
,p_computation_item=>'P1_PERM_COUNT'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(petty_cash_no) ',
'from hrss_petty_cash',
'where employee_num = substr(:APP_USER,4)',
'and status = ''Open''',
'AND petty_cash_type = ''P'';'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(1929745475356598)
,p_computation_sequence=>10
,p_computation_item=>'P1_IS_PETTY_CASH_ADMIN'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Declare',
'l_count  varchar2(10);',
'begin',
'SELECT count(*)',
'into l_count',
'FROM dct_data_access_assignment ',
'where entity_type_id = ''ROLE'' ',
'and entity_id = 11 ',
'and status = ''A'' ',
'and sysdate BETWEEN start_date and nvl(end_date , sysdate + 10)',
'and person_id = :PERSON_ID;',
'',
'if l_count > 0 Then ',
'                    return ''Y'';',
'           else ',
'               return ''N'';',
'End if;',
'',
'end;'))
,p_computation_error_message=>'Error in P1_IS_PETTY_CASH_ADMIN'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(29269893791292318)
,p_name=>'Check Temporary'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(29269683524292316)
,p_condition_element=>'P1_TEMP_COUNT'
,p_triggering_condition_type=>'GREATER_THAN'
,p_triggering_expression=>'1'
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(29269957768292319)
,p_event_id=>wwv_flow_api.id(29269893791292318)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'As Per DCT Financial Policy, you can''t have multiple petty cash open at the same time.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(29270528090292325)
,p_event_id=>wwv_flow_api.id(29269893791292318)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'New_Petty_Cash'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(30355412564996024)
,p_name=>'Dialog Closed Invocing details'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(29960934602468916)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(30355565978996025)
,p_event_id=>wwv_flow_api.id(30355412564996024)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(29960934602468916)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(30355615083996026)
,p_name=>'Dialog Close Payment Deatils'
,p_event_sequence=>30
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(30218531983181334)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(30355797282996027)
,p_event_id=>wwv_flow_api.id(30355615083996026)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(30218531983181334)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(30581255825848508)
,p_name=>'Refresh Processed Petty Cash'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_YEAR'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(30581340236848509)
,p_event_id=>wwv_flow_api.id(30581255825848508)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(30580922504848505)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(30581426717848510)
,p_name=>'Refresh Process Petty Cash Month'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_MONTH'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(30581535620848511)
,p_event_id=>wwv_flow_api.id(30581426717848510)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(30580922504848505)
);
wwv_flow_api.component_end;
end;
/
