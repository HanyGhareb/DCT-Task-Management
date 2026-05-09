prompt --application/pages/page_00009
begin
--   Manifest
--     PAGE: 00009
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>114
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>9
,p_user_interface_id=>wwv_flow_api.id(52958449993734913)
,p_name=>'Managers Cheque List - Drilldown'
,p_alias=>'MANAGERS-CHEQUE-LIST-DRILLDOWN'
,p_step_title=>'Managers Cheque List - Drilldown'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230119061745'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(53830124907675876)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(52883202148734869)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(52819862093734839)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(52937373347734896)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(53830757765675880)
,p_plug_name=>'Managers Cheque List - Drilldown'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(52871984744734866)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select mcv.ID,',
'       mcv.SUPPLIER_NAME,',
'       mcv.CURRENCY,',
'       mcv.AMOUNT,',
'       mcv.AMOUNT_IN_AED,',
'       mcv.DESCRIPTIONS,',
'       mcv.PV,',
'       mcv.PAYMENT_NO,',
'       mcv.LIST,',
'       mcv.PAYMENT_TYPE,',
'       mcv.MILESTONE_DESCRIPTION,',
'       mcv.MILESTONE_DATE,',
'       mcv.END_USER_EMAIL,',
'       mcv.PROJECT,',
'       mcv.TASK,',
'       mcv.COST_CENTER,',
'       mcv.GL_ACCOUNT,',
'       mcv.UPLOADED_BY,',
'       mcv.UPLOADED_ON,',
'       mcv.UPDATED_BY,',
'       mcv.UPDATED_ON,',
'       mcv.STATUS,',
'       Case mcv.STATUS',
'            when ''Hold''     Then ''''',
'            when ''Released'' Then ''fa fa-check-circle''',
'            when ''Endorse'' Then ''fa-check-circle-o fa-lg''',
'            when ''Rejected'' Then ''fa-check-circle-o fa-lg''',
'            when ''Withdraw'' Then ''fa-check-circle-o fa-lg''',
'            when ''In-Progress'' then ''''',
'        End     icon,',
'        Case mcv.STATUS',
'            when ''Hold''     Then ''''',
'            when ''Released'' Then ''green''',
'            when ''Endorse'' Then ''green''',
'            when ''Rejected'' Then ''red''',
'            when ''Withdraw'' Then ''red''',
'            when ''In-Progress'' then ''#E0901C''',
'        End     icon_color,',
'',
'       mcv.COMMENTS,',
'       mcv.END_USER_PERSON_ID,',
'       mcv.department_name,',
'       mcv.sector,',
'       mcv.EMAIL,',
'       mcv.SUBMISSION_ON,',
'       mcv.SUBMIT_BY,',
'       mcv.FINAL_APPROVE_ON,',
'       mcv.FINAL_APPROVE_BY,',
'       mcv.RECEIVING_PERSON_NAME,',
'       mcv.EMIRATES_ID,',
'       mcv.CHECK_NUM,',
'       mcv.EXPIRE_DATE,',
'       mcv.BANK_GRANTEE_NUMBER,',
'       mcv.CONTRACT_NUMBER,',
'       x.emp    Pending_with,',
'       x.received_date received_date,',
'       x.received_date received_date_ON,',
'       y.LAST_APPROVED_BY,',
'       y.APPROVED_ON  last_APPROVED_ON',
'  from MANAGER_CHECKS_V mcv , ',
'  (select h.check_id , max(h.RECEVIED_DATE)  received_date,',
'        LISTAGG( e.first_name || '' '' || e.last_name , ''; '') WITHIN GROUP (ORDER BY hire_date) emp',
'    from manager_checks_approval_history h, dct_employees_list2 e, manager_checks m',
'    where h.person_id = e.person_id',
'    and m.id = h.check_id',
'    and h.status = ''Pending''',
'    and m.status in (''In-Progress'', ''Voiding'')',
'    group by h.check_id) x,',
'    (select h2.check_id check_id, e2.full_name_en  last_approved_by, h2.action_date Approved_on',
'        from manager_checks_approval_history h2 , employees_v e2',
'        where  1=1 ',
'        --and h2.mpr_id = mpr.id',
'        and h2.person_id = e2.person_id',
'        and h2.status = ''Approved''',
'        and h2.step_no = (select max(x2.step_no) from manager_checks_approval_history x2 where x2.check_id = h2.check_id)) y',
'where mcv.status = nvl(:P9_STATUS , mcv.Status)',
'and mcv.id = x.check_id (+)',
'and mcv.id = y.check_id (+)',
'and mcv.fisical_year = :P9_FISICAL_YEAR',
'order by mcv.FINAL_APPROVE_ON desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P9_STATUS,P9_FISICAL_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Managers Cheque List - Drilldown'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(53830880498675880)
,p_name=>'Managers Cheque List - Drilldown'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>53830880498675880
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53831299418675882)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53831691382675884)
,p_db_column_name=>'SUPPLIER_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Supplier Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53832084304675884)
,p_db_column_name=>'CURRENCY'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53832468761675884)
,p_db_column_name=>'AMOUNT'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53832814905675885)
,p_db_column_name=>'AMOUNT_IN_AED'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Amount (AED)'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53833272750675885)
,p_db_column_name=>'DESCRIPTIONS'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Descriptions'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53833601485675885)
,p_db_column_name=>'PV'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Pv'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53834055302675885)
,p_db_column_name=>'PAYMENT_NO'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Payment No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53834459251675886)
,p_db_column_name=>'LIST'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'List'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53834810046675886)
,p_db_column_name=>'PAYMENT_TYPE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Payment Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53835214689675886)
,p_db_column_name=>'MILESTONE_DESCRIPTION'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Milestone Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53835674543675886)
,p_db_column_name=>'MILESTONE_DATE'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Milestone Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53836028332675886)
,p_db_column_name=>'END_USER_EMAIL'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'End User Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53836482469675886)
,p_db_column_name=>'PROJECT'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Project'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53836893916675887)
,p_db_column_name=>'TASK'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53837261532675887)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53837614196675887)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53838069573675887)
,p_db_column_name=>'UPLOADED_BY'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Uploaded By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53838465387675887)
,p_db_column_name=>'UPLOADED_ON'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Uploaded On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53838860145675888)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53839233207675888)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53839627089675888)
,p_db_column_name=>'STATUS'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Status'
,p_column_html_expression=>'<span class="#ICON#" style="color: #ICON_COLOR#"> #STATUS#</span>'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53840010247675888)
,p_db_column_name=>'ICON'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53840485320675888)
,p_db_column_name=>'ICON_COLOR'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Icon Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53840857237675889)
,p_db_column_name=>'COMMENTS'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53841275616675889)
,p_db_column_name=>'END_USER_PERSON_ID'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'End User'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53841660869675889)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53842057681675889)
,p_db_column_name=>'SECTOR'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53842413686675889)
,p_db_column_name=>'EMAIL'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Email'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53842849673675890)
,p_db_column_name=>'SUBMISSION_ON'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Submission On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53843259788675890)
,p_db_column_name=>'SUBMIT_BY'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Submit By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53843673816675890)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53844045451675890)
,p_db_column_name=>'FINAL_APPROVE_BY'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Final Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53844449548675890)
,p_db_column_name=>'RECEIVING_PERSON_NAME'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Receiving Person Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53844852580675891)
,p_db_column_name=>'EMIRATES_ID'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Emirates ID'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53845288697675891)
,p_db_column_name=>'CHECK_NUM'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Check Num'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ID,P2_PAGE_FROM:#ID#,9'
,p_column_linktext=>'#CHECK_NUM#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53845609207675891)
,p_db_column_name=>'EXPIRE_DATE'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Expire Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54529884868073033)
,p_db_column_name=>'BANK_GRANTEE_NUMBER'
,p_display_order=>47
,p_column_identifier=>'AL'
,p_column_label=>'Bank Grantee Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54529998811073034)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>57
,p_column_identifier=>'AM'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54530431988073039)
,p_db_column_name=>'PENDING_WITH'
,p_display_order=>67
,p_column_identifier=>'AN'
,p_column_label=>'Pending With'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54530572542073040)
,p_db_column_name=>'RECEIVED_DATE'
,p_display_order=>77
,p_column_identifier=>'AO'
,p_column_label=>'Received Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54530683480073041)
,p_db_column_name=>'RECEIVED_DATE_ON'
,p_display_order=>87
,p_column_identifier=>'AP'
,p_column_label=>'Received Date On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54530760399073042)
,p_db_column_name=>'LAST_APPROVED_BY'
,p_display_order=>97
,p_column_identifier=>'AQ'
,p_column_label=>'Last Approved By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54530885386073043)
,p_db_column_name=>'LAST_APPROVED_ON'
,p_display_order=>107
,p_column_identifier=>'AR'
,p_column_label=>'Last Approved On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(53847452894688069)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'538475'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CHECK_NUM:PAYMENT_NO:END_USER_PERSON_ID:SUPPLIER_NAME:AMOUNT_IN_AED:DESCRIPTIONS:BANK_GRANTEE_NUMBER:CONTRACT_NUMBER:MILESTONE_DATE:PENDING_WITH:RECEIVED_DATE:STATUS:'
,p_sort_column_1=>'RECEIVED_DATE'
,p_sort_direction_1=>'DESC'
,p_sum_columns_on_break=>'AMOUNT:AMOUNT_IN_AED'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(53684182731159629)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(53830124907675876)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:&P9_PAGE_FROM.:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(53684032952159628)
,p_name=>'P9_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(53830124907675876)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54280321043746046)
,p_name=>'P9_PAGE_FROM'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(53830124907675876)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(142408674123823848)
,p_name=>'P9_FISICAL_YEAR'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(53830124907675876)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
