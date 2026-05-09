prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(52958449993734913)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'Manager Checks'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240215103608'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(52712037915537917)
,p_plug_name=>'Manager Checks List'
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       SUPPLIER_NAME,',
'       CURRENCY,',
'       AMOUNT,',
'       AMOUNT_IN_AED,',
'       DESCRIPTIONS,',
'       PV,',
'       PAYMENT_NO,',
'       LIST,',
'       PAYMENT_TYPE,',
'       MILESTONE_DESCRIPTION,',
'       MILESTONE_DATE,',
'       END_USER_EMAIL,',
'       PROJECT,',
'       TASK,',
'       COST_CENTER,',
'       GL_ACCOUNT,',
'       UPLOADED_BY,',
'       UPLOADED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       STATUS,',
'       check_date,',
'       check_date_new,',
'       Case STATUS',
'            when ''Hold''     Then ''''',
'            when ''Released'' Then ''fa fa-check-circle''',
'            when ''Endorse'' Then ''fa-check-circle-o fa-lg''',
'            when ''Rejected'' Then ''fa-check-circle-o fa-lg''',
'            when ''Withdraw'' Then ''fa-check-circle-o fa-lg''',
'            when ''In-Progress'' then ''''',
'        End     icon,',
'        Case STATUS',
'            when ''Hold''     Then ''''',
'            when ''Released'' Then ''green''',
'            when ''Endorse'' Then ''green''',
'            when ''Rejected'' Then ''red''',
'            when ''Withdraw'' Then ''red''',
'            when ''In-Progress'' then ''#E0901C''',
'        End     icon_color,',
'',
'       COMMENTS,',
'       END_USER_PERSON_ID,',
'     user_details.get_cost_center(end_user_person_id) end_user_cost_center,',
'    (select PERSON_ID',
'        from cost_centers_fbp',
'        where BP_TYPE = ''FBP''',
'        and cost_center = user_details.get_cost_center(end_user_person_id) ',
'        and status = ''A''',
'        and rownum = 1',
'        and sysdate between nvl(start_date , sysdate - 10) ',
'                and nvl(end_date , sysdate + 10))            FBP_PERSON_ID,',
'       department_name,',
'       sector,',
'       EMAIL,',
'       SUBMISSION_ON,',
'       SUBMIT_BY,',
'       FINAL_APPROVE_ON,',
'       FINAL_APPROVE_BY,',
'       RECEIVING_PERSON_NAME,',
'       EMIRATES_ID,',
'       CHECK_NUM,',
'       CHECK_NUM_new,',
'       EXPIRE_DATE,',
'           BANK_GRANTEE_NUMBER,',
'    CONTRACT_NUMBER',
'  from MANAGER_CHECKS_V',
'  where FISICAL_YEAR = nvl(:P1_FISICAL_YEAR , FISICAL_YEAR)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P1_FISICAL_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number;',
'BEGIN',
'',
'SELECT count(*) ',
'into l_count',
'FROM dct_data_access_assignment ',
'where entity_type_id = ''ROLE'' ',
'and entity_id in (59,60,61  )--(59 Manager checks finance Approvers role,60  for accounts payables, 61 Access Manager checks group)',
'and status = ''A'' ',
'and sysdate BETWEEN start_date ',
'    and nvl(end_date , sysdate + 10)',
'and person_id = :PERSON_ID;',
'',
'  IF :IS_FBP_YN = ''Y'' or l_count > 0',
'    Then ',
'        return true;',
'    Else',
'        return false;',
'    End if;',
'END;'))
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Manager Checks Status As of &P1_TIME.'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'14'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#FF0F0F'
,p_prn_header_font_color=>'#FFFFFF'
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
,p_plug_comment=>'to be displayed only for (59 Manager checks finance Approvers role,60  for accounts payables, 61 Access Manager checks group) and for FBP (IS_FBP_YN item)'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(52712160448537918)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ID,P2_PAGE_FROM:#ID#,1'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil-alt.png" class="apex-edit-pencil-alt" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>52712160448537918
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52712267699537919)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52712391369537920)
,p_db_column_name=>'SUPPLIER_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Supplier Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52712441792537921)
,p_db_column_name=>'CURRENCY'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52712572510537922)
,p_db_column_name=>'AMOUNT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52712605287537923)
,p_db_column_name=>'AMOUNT_IN_AED'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Amount (AED)'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52712733524537924)
,p_db_column_name=>'DESCRIPTIONS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52712834876537925)
,p_db_column_name=>'PV'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'PVs'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52713052273537927)
,p_db_column_name=>'LIST'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'List'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52713167636537928)
,p_db_column_name=>'PAYMENT_TYPE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Payment Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52713298044537929)
,p_db_column_name=>'MILESTONE_DESCRIPTION'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Milestone Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52713398996537930)
,p_db_column_name=>'MILESTONE_DATE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Milestone Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52713466273537931)
,p_db_column_name=>'END_USER_EMAIL'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'End User Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52713580640537932)
,p_db_column_name=>'PROJECT'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52713624068537933)
,p_db_column_name=>'TASK'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52713702615537934)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52713830044537935)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52713905576537936)
,p_db_column_name=>'UPLOADED_BY'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Uploaded By'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52714030987537937)
,p_db_column_name=>'UPLOADED_ON'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Uploaded On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52714112480537938)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52714285571537939)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52714347896537940)
,p_db_column_name=>'STATUS'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Status'
,p_column_html_expression=>'<span class="#ICON#" style="color: #ICON_COLOR#"> #STATUS#</span>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52714475050537941)
,p_db_column_name=>'COMMENTS'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52714519238537942)
,p_db_column_name=>'END_USER_PERSON_ID'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Business Owner'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53299355651558616)
,p_db_column_name=>'EMAIL'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53299473576558617)
,p_db_column_name=>'SUBMISSION_ON'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Submission On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53299538941558618)
,p_db_column_name=>'SUBMIT_BY'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Submit By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53299632006558619)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53299784985558620)
,p_db_column_name=>'FINAL_APPROVE_BY'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Final Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53299823230558621)
,p_db_column_name=>'ICON'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53299989722558622)
,p_db_column_name=>'ICON_COLOR'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Icon Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53300050745558623)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53300137681558624)
,p_db_column_name=>'SECTOR'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53437862784667743)
,p_db_column_name=>'RECEIVING_PERSON_NAME'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Receiving Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53437934614667744)
,p_db_column_name=>'EMIRATES_ID'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Emirates ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53438090158667745)
,p_db_column_name=>'CHECK_NUM'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Check No'
,p_column_link=>'f?p=&APP_ID.:1:&SESSION.:APPLICATION_PROCESS=DOWNLOAD_ATTACHMENTS:&DEBUG.::P1_CHECK_ID_DOC,P1_CHECK_NUM_DOC:#ID#,#CHECK_NUM#'
,p_column_linktext=>'#CHECK_NUM#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53438177857667746)
,p_db_column_name=>'EXPIRE_DATE'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Expire Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54529257276073027)
,p_db_column_name=>'BANK_GRANTEE_NUMBER'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Bank Grantee Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54529309534073028)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111639265546816127)
,p_db_column_name=>'CHECK_NUM_NEW'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'New Check No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157192672009961630)
,p_db_column_name=>'PAYMENT_NO'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Payment No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157192796486961631)
,p_db_column_name=>'END_USER_COST_CENTER'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'End User Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157192889152961632)
,p_db_column_name=>'FBP_PERSON_ID'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'FBP Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(158481632624258812)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157193174104961635)
,p_db_column_name=>'CHECK_DATE'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Check Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157193221365961636)
,p_db_column_name=>'CHECK_DATE_NEW'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'Check Date New'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(52979270061820902)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'529793'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CHECK_NUM:CHECK_NUM_NEW:EXPIRE_DATE:SUPPLIER_NAME:END_USER_PERSON_ID:CURRENCY:AMOUNT:MILESTONE_DATE:DESCRIPTIONS:PV:STATUS:END_USER_COST_CENTER:FBP_PERSON_ID:'
,p_sort_column_1=>'SUPPLIER_NAME'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'PAYMENT_NO'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'AMOUNT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(54704777169886518)
,p_application_user=>'TCA596'
,p_name=>'Starcom Report '
,p_report_seq=>10
,p_report_columns=>'CHECK_NUM:SUPPLIER_NAME:END_USER_PERSON_ID:CURRENCY:AMOUNT:MILESTONE_DATE:DESCRIPTIONS:STATUS'
,p_sort_column_1=>'SUPPLIER_NAME'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'PAYMENT_NO'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'AMOUNT'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(54704881448886518)
,p_report_id=>wwv_flow_api.id(54704777169886518)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'in'
,p_expr=>'In-Progress,Released'
,p_condition_sql=>'"STATUS" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''In-Progress, Released''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(54704997390886519)
,p_report_id=>wwv_flow_api.id(54704777169886518)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'SUPPLIER_NAME'
,p_operator=>'='
,p_expr=>'STARCOM FZ LLC'
,p_condition_sql=>'"SUPPLIER_NAME" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''STARCOM FZ LLC''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(54706015040967680)
,p_application_user=>'TCA210'
,p_name=>'Starcom report'
,p_report_seq=>10
,p_report_columns=>'CHECK_NUM:SUPPLIER_NAME:END_USER_PERSON_ID:CURRENCY:AMOUNT:MILESTONE_DATE:DESCRIPTIONS:STATUS:CONTRACT_NUMBER:BANK_GRANTEE_NUMBER'
,p_sort_column_1=>'SUPPLIER_NAME'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'PAYMENT_NO'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'AMOUNT'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(54706163226967680)
,p_report_id=>wwv_flow_api.id(54706015040967680)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'in'
,p_expr=>'In-Progress,Released'
,p_condition_sql=>'"STATUS" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''In-Progress, Released''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(54706280326967680)
,p_report_id=>wwv_flow_api.id(54706015040967680)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'SUPPLIER_NAME'
,p_operator=>'='
,p_expr=>'STARCOM FZ LLC'
,p_condition_sql=>'"SUPPLIER_NAME" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''STARCOM FZ LLC''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(54759821557891462)
,p_application_user=>'TCA210'
,p_name=>'1st report '
,p_report_seq=>10
,p_report_columns=>'CHECK_NUM:SUPPLIER_NAME:END_USER_PERSON_ID:CURRENCY:AMOUNT:AMOUNT_IN_AED:MILESTONE_DATE:DESCRIPTIONS:MILESTONE_DESCRIPTION:STATUS'
,p_sort_column_1=>'SUPPLIER_NAME'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'PAYMENT_NO'
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(55240549534543827)
,p_application_user=>'TCA9036'
,p_name=>'KPMG Report 2'
,p_report_seq=>10
,p_report_columns=>'CHECK_NUM:SUPPLIER_NAME:END_USER_PERSON_ID:CURRENCY:AMOUNT:MILESTONE_DATE:DESCRIPTIONS:CONTRACT_NUMBER:BANK_GRANTEE_NUMBER:STATUS'
,p_sort_column_1=>'SUPPLIER_NAME'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'PAYMENT_NO'
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
 p_id=>wwv_flow_api.id(55240677522543827)
,p_report_id=>wwv_flow_api.id(55240549534543827)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'In-Progress'
,p_condition_sql=>'"STATUS" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''In-Progress''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(55240747287543827)
,p_report_id=>wwv_flow_api.id(55240549534543827)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'SUPPLIER_NAME'
,p_operator=>'='
,p_expr=>'KPMG LOWER GULF LIMITED'
,p_condition_sql=>'"SUPPLIER_NAME" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''KPMG LOWER GULF LIMITED''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(94029634254032158)
,p_application_user=>'TCA282'
,p_name=>'Bennty'
,p_report_seq=>10
,p_report_columns=>'CHECK_NUM:SUPPLIER_NAME:END_USER_PERSON_ID:CURRENCY:AMOUNT:MILESTONE_DATE:DESCRIPTIONS:STATUS'
,p_sort_column_1=>'SUPPLIER_NAME'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'PAYMENT_NO'
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
 p_id=>wwv_flow_api.id(94029705364032158)
,p_report_id=>wwv_flow_api.id(94029634254032158)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'PAYMENT_NO'
,p_operator=>'in'
,p_expr=>'1905,1901'
,p_condition_sql=>'"PAYMENT_NO" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# 1905, 1901  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(136897080721040119)
,p_application_user=>'TCA9051'
,p_name=>'By Release'
,p_report_seq=>10
,p_report_columns=>'CHECK_NUM:CHECK_NUM_NEW:EXPIRE_DATE:SUPPLIER_NAME:END_USER_PERSON_ID:CURRENCY:AMOUNT:MILESTONE_DATE:DESCRIPTIONS:FINAL_APPROVE_ON:FINAL_APPROVE_BY:STATUS'
,p_sort_column_1=>'SUPPLIER_NAME'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'PAYMENT_NO'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'AMOUNT'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(136897386230036680)
,p_report_id=>wwv_flow_api.id(136897080721040119)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'FINAL_APPROVE_BY'
,p_operator=>'is not null'
,p_condition_sql=>'"FINAL_APPROVE_BY" is not null'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(137846564160750885)
,p_application_user=>'TCA9051'
,p_name=>'Status Report'
,p_report_seq=>10
,p_report_columns=>'CHECK_NUM:CHECK_NUM_NEW:EXPIRE_DATE:SUPPLIER_NAME:END_USER_PERSON_ID:CURRENCY:AMOUNT:MILESTONE_DATE:DESCRIPTIONS:PV:STATUS:FINAL_APPROVE_ON:SUBMISSION_ON:SUBMIT_BY:END_USER_EMAIL:PAYMENT_TYPE'
,p_sort_column_1=>'SUPPLIER_NAME'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'PAYMENT_NO'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'AMOUNT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(156201160652697835)
,p_application_user=>'TCA210'
,p_name=>'FBP '
,p_report_seq=>10
,p_report_columns=>'CHECK_NUM:CHECK_NUM_NEW:EXPIRE_DATE:SUPPLIER_NAME:END_USER_PERSON_ID:FBP_PERSON_ID:CURRENCY:AMOUNT:AMOUNT_IN_AED:MILESTONE_DATE:DESCRIPTIONS:PV:STATUS:'
,p_sort_column_1=>'SUPPLIER_NAME'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'PAYMENT_NO'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'AMOUNT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(52969298190734951)
,p_plug_name=>'Managers Cheque'
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
 p_id=>wwv_flow_api.id(53301191818558634)
,p_plug_name=>'Upcoming Due '
,p_icon_css_classes=>'fa-clock-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent9:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    supplier_name,',
'    currency,',
'    amount,',
'    amount_in_aed,',
'    descriptions,',
'    pv,',
'    payment_no,',
'    list,',
'    payment_type,',
'    milestone_description,',
'    milestone_date milestone_since,',
'    milestone_date,',
'    end_user_email,',
'    project,',
'    task,',
'    cost_center,',
'    gl_account,',
'    uploaded_by,',
'    uploaded_on,',
'    updated_by,',
'    updated_on,',
'    status,',
'    comments,',
'    end_user_person_id,',
'    end_user_person_id    end_user_person_id_h,',
'    user_details.get_cost_center(end_user_person_id) end_user_cost_center,',
'    (select PERSON_ID',
'        from cost_centers_fbp',
'        where BP_TYPE = ''FBP''',
'        and cost_center = user_details.get_cost_center(end_user_person_id) ',
'        and status = ''A''',
'        and rownum = 1',
'        and sysdate between nvl(start_date , sysdate - 10) ',
'                and nvl(end_date , sysdate + 10))            FBP_PERSON_ID,',
'    full_name_en,',
'    department_name,',
'    sector,',
'    email,',
'    submission_on,',
'    submit_by,',
'    final_approve_on,',
'    final_approve_by,',
'    RECEIVING_PERSON_NAME,',
'    EMIRATES_ID,',
'    CHECK_NUM,',
'    CHECK_NUM_NEW,',
'    EXPIRE_DATE,',
'        BANK_GRANTEE_NUMBER,',
'    CONTRACT_NUMBER,',
'    (select nvl(count(*) , 0) from manager_checks_reminders mr',
'    where mr.check_id = manager_checks_v.id) Reminder_count',
'    , decode( end_user_person_id , null , ''No User''',
'    , ''<span aria-hidden="true" class="fa fa-envelope-o fa-2x fam-information fam-is-info"></span>'' ',
'        ) Reminder',
'    , decode( STATUS , ''Hold'',',
'    ''<span aria-hidden="true" class="fa fa-refresh fa-2x"></span>'', null) Expired         ',
'FROM',
'    manager_checks_v',
'where status not in (''Released'')    ',
'and  FISICAL_YEAR = nvl(:P1_FISICAL_YEAR , FISICAL_YEAR)',
'order by milestone_date  NULLS LAST',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P1_FISICAL_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number;',
'BEGIN',
'',
'SELECT count(*) ',
'into l_count',
'FROM dct_data_access_assignment ',
'where entity_type_id = ''ROLE'' ',
'and entity_id in (59,60,61  )--(59 Manager checks finance Approvers role,60  for accounts payables, 61 Access Manager checks group)',
'and status = ''A'' ',
'and sysdate BETWEEN start_date ',
'    and nvl(end_date , sysdate + 10)',
'and person_id = :PERSON_ID;',
'',
'  IF :IS_FBP_YN = ''Y'' or l_count > 0',
'    Then ',
'        return true;',
'    Else',
'        return false;',
'    End if;',
'END;'))
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Upcoming Due '
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
,p_plug_comment=>'to be displayed only for (59 Manager checks finance Approvers role,60  for accounts payables, 61 Access Manager checks group) and for FBP (IS_FBP_YN item)'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(53301273430558635)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>53301273430558635
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53301397063558636)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>114
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53301490406558637)
,p_db_column_name=>'SUPPLIER_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Supplier Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53301586019558638)
,p_db_column_name=>'CURRENCY'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53301605435558639)
,p_db_column_name=>'AMOUNT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Check Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53301717798558640)
,p_db_column_name=>'AMOUNT_IN_AED'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Amount  (AED)'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53301859803558641)
,p_db_column_name=>'DESCRIPTIONS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53301927558558642)
,p_db_column_name=>'PV'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'PV'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53302142786558644)
,p_db_column_name=>'LIST'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'List'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53302244179558645)
,p_db_column_name=>'PAYMENT_TYPE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Payment Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53302355824558646)
,p_db_column_name=>'MILESTONE_DESCRIPTION'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Milestone Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53302457633558647)
,p_db_column_name=>'MILESTONE_DATE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Milestone Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53435448508667719)
,p_db_column_name=>'MILESTONE_SINCE'
,p_display_order=>130
,p_column_identifier=>'AG'
,p_column_label=>'Milestone Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53302534449558648)
,p_db_column_name=>'END_USER_EMAIL'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'End User Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53302689695558649)
,p_db_column_name=>'PROJECT'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53302766126558650)
,p_db_column_name=>'TASK'
,p_display_order=>160
,p_column_identifier=>'O'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53433656759667701)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>170
,p_column_identifier=>'P'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53433736511667702)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>180
,p_column_identifier=>'Q'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53433864021667703)
,p_db_column_name=>'UPLOADED_BY'
,p_display_order=>190
,p_column_identifier=>'R'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53433924741667704)
,p_db_column_name=>'UPLOADED_ON'
,p_display_order=>200
,p_column_identifier=>'S'
,p_column_label=>'Uploaded On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53434003833667705)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>210
,p_column_identifier=>'T'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53434134663667706)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>220
,p_column_identifier=>'U'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53434201101667707)
,p_db_column_name=>'STATUS'
,p_display_order=>230
,p_column_identifier=>'V'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53434317978667708)
,p_db_column_name=>'COMMENTS'
,p_display_order=>240
,p_column_identifier=>'W'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53434468489667709)
,p_db_column_name=>'END_USER_PERSON_ID'
,p_display_order=>250
,p_column_identifier=>'X'
,p_column_label=>'End User Person ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53434583453667710)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>260
,p_column_identifier=>'Y'
,p_column_label=>'Business Owner'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53434648900667711)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>270
,p_column_identifier=>'Z'
,p_column_label=>'Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53434777364667712)
,p_db_column_name=>'SECTOR'
,p_display_order=>280
,p_column_identifier=>'AA'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53434894476667713)
,p_db_column_name=>'EMAIL'
,p_display_order=>290
,p_column_identifier=>'AB'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53434948436667714)
,p_db_column_name=>'SUBMISSION_ON'
,p_display_order=>300
,p_column_identifier=>'AC'
,p_column_label=>'Submission On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53435009644667715)
,p_db_column_name=>'SUBMIT_BY'
,p_display_order=>310
,p_column_identifier=>'AD'
,p_column_label=>'Submit By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53435119844667716)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>320
,p_column_identifier=>'AE'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53435253404667717)
,p_db_column_name=>'FINAL_APPROVE_BY'
,p_display_order=>330
,p_column_identifier=>'AF'
,p_column_label=>'Final Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53435682733667721)
,p_db_column_name=>'REMINDER'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Reminder'
,p_column_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8:P8_CHECK_ID,P8_PERSON_ID,P8_BUSINESS_OWNER,P8_AMOUNT:#ID#,#END_USER_PERSON_ID#,#FULL_NAME_EN#,#AMOUNT#'
,p_column_linktext=>'#REMINDER#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53437415965667739)
,p_db_column_name=>'RECEIVING_PERSON_NAME'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Receiving Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53437592276667740)
,p_db_column_name=>'EMIRATES_ID'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Emirates ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53437683350667741)
,p_db_column_name=>'CHECK_NUM'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Check No'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ID,P2_PAGE_FROM:#ID#,2'
,p_column_linktext=>'#CHECK_NUM#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53437767408667742)
,p_db_column_name=>'EXPIRE_DATE'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Expire Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(53682899299159616)
,p_db_column_name=>'REMINDER_COUNT'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Reminder Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54529094979073025)
,p_db_column_name=>'BANK_GRANTEE_NUMBER'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Bank Grantee Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54529196906073026)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111571160834794824)
,p_db_column_name=>'EXPIRED'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'Expire'
,p_column_link=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.::P16_ID:#ID#'
,p_column_linktext=>'#EXPIRED#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_display_condition_type=>'NEVER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111639370412816128)
,p_db_column_name=>'CHECK_NUM_NEW'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'New Check No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155988148719902422)
,p_db_column_name=>'PAYMENT_NO'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Payment No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155988232774902423)
,p_db_column_name=>'END_USER_PERSON_ID_H'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'End User Person Id H'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157192284695961626)
,p_db_column_name=>'END_USER_COST_CENTER'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'End User Cost Center'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157192361362961627)
,p_db_column_name=>'FBP_PERSON_ID'
,p_display_order=>470
,p_column_identifier=>'AU'
,p_column_label=>'FBP Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(158481632624258812)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(53455817132703178)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'534559'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>10
,p_report_columns=>'CHECK_NUM:CHECK_NUM_NEW:FULL_NAME_EN:SUPPLIER_NAME:FBP_PERSON_ID:AMOUNT:MILESTONE_SINCE:STATUS:REMINDER_COUNT:REMINDER:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(158488548666310502)
,p_report_id=>wwv_flow_api.id(53455817132703178)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'FULL_NAME_EN'
,p_operator=>'='
,p_expr=>'Abdulla Sayed Al Blooshi'
,p_condition_sql=>'"FULL_NAME_EN" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''Abdulla Sayed Al Blooshi''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(53435364998667718)
,p_plug_name=>'Overview'
,p_icon_css_classes=>'fa-line-chart'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number;',
'BEGIN',
'',
'SELECT count(*) ',
'into l_count',
'FROM dct_data_access_assignment ',
'where entity_type_id = ''ROLE'' ',
'and entity_id in (59,60,61  )--(59 Manager checks finance Approvers role,60  for accounts payables, 61 Access Manager checks group)',
'and status = ''A'' ',
'and sysdate BETWEEN start_date ',
'    and nvl(end_date , sysdate + 10)',
'and person_id = :PERSON_ID;',
'',
'  IF :IS_FBP_YN = ''Y'' or l_count > 0',
'    Then ',
'        return true;',
'    Else',
'        return false;',
'    End if;',
'END;'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_plug_comment=>'to be displayed only for (59 Manager checks finance Approvers role,60  for accounts payables, 61 Access Manager checks group) and for FBP (IS_FBP_YN item)'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(53300245021558625)
,p_plug_name=>'Check Count By Status (&P1_CHECK_COUNT.)'
,p_parent_plug_id=>wwv_flow_api.id(53435364998667718)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'MANAGER_CHECKS_V'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_ajax_items_to_submit=>'P1_FISICAL_YEAR'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(53300330449558626)
,p_region_id=>wwv_flow_api.id(53300245021558625)
,p_chart_type=>'donut'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_value=>true
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(53300444891558627)
,p_chart_id=>wwv_flow_api.id(53300330449558626)
,p_seq=>10
,p_name=>'Check Count By Status'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(ID) check_count,',
'       STATUS,',
'        Case STATUS',
'            when ''Hold''         Then ''gray''',
'            when ''Released''     Then ''green''',
'            when ''In-Progress''  Then ''Yellow''',
'            when ''Rejected''     Then ''red''',
'            when ''Withdraw''     Then ''blue''',
'        End     icon_color',
'  from MANAGER_CHECKS_V',
'  where FISICAL_YEAR = nvl(:P1_FISICAL_YEAR , FISICAL_YEAR)',
'  group by status '))
,p_ajax_items_to_submit=>'P1_FISICAL_YEAR'
,p_items_value_column_name=>'CHECK_COUNT'
,p_items_label_column_name=>'STATUS'
,p_color=>'&ICON_COLOR.'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideSlice'
,p_items_label_display_as=>'ALL'
,p_link_target=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:9:P9_STATUS,P9_PAGE_FROM,P9_FISICAL_YEAR:&STATUS.,1,&P1_FISICAL_YEAR.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(53300791930558630)
,p_plug_name=>'Check Amounts (AED) By Status - (&P1_CHECK_AMOUNT. AED) '
,p_parent_plug_id=>wwv_flow_api.id(53435364998667718)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(53300810878558631)
,p_region_id=>wwv_flow_api.id(53300791930558630)
,p_chart_type=>'donut'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_value=>true
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(53300969765558632)
,p_chart_id=>wwv_flow_api.id(53300810878558631)
,p_seq=>10
,p_name=>'Check Amount By Status'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select sum(amount_in_aed) check_amount,',
'       STATUS,',
'        Case STATUS',
'            when ''Hold''         Then ''gray''',
'            when ''Released''     Then ''green''',
'            when ''In-Progress''  Then ''Yellow''',
'            when ''Rejected''     Then ''red''',
'            when ''Withdraw''     Then ''blue''',
'        End     icon_color',
'  from MANAGER_CHECKS_V',
'  where FISICAL_YEAR = nvl(:P1_FISICAL_YEAR , FISICAL_YEAR)',
'  group by status '))
,p_ajax_items_to_submit=>'P1_FISICAL_YEAR'
,p_items_value_column_name=>'CHECK_AMOUNT'
,p_items_label_column_name=>'STATUS'
,p_color=>'&ICON_COLOR.'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideSlice'
,p_items_label_display_as=>'ALL'
,p_link_target=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:9:P9_STATUS,P9_PAGE_FROM,P9_FISICAL_YEAR:&STATUS.,1,&P1_FISICAL_YEAR.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(54275909536746002)
,p_plug_name=>'My Manager Cheques'
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       SUPPLIER_NAME,',
'       CURRENCY,',
'       AMOUNT,',
'       AMOUNT_IN_AED,',
'       DESCRIPTIONS,',
'       PV,',
'       PAYMENT_NO,',
'       LIST,',
'       PAYMENT_TYPE,',
'       MILESTONE_DESCRIPTION,',
'       MILESTONE_DATE,',
'       END_USER_EMAIL,',
'       PROJECT,',
'       TASK,',
'       COST_CENTER,',
'       GL_ACCOUNT,',
'       UPLOADED_BY,',
'       UPLOADED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       STATUS,',
'       Case STATUS',
'            when ''Hold''     Then ''''',
'            when ''Released'' Then ''fa fa-check-circle''',
'            when ''Endorse'' Then ''fa-check-circle-o fa-lg''',
'            when ''Rejected'' Then ''fa-check-circle-o fa-lg''',
'            when ''Withdraw'' Then ''fa-check-circle-o fa-lg''',
'            when ''In-Progress'' then ''''',
'        End     icon,',
'        Case STATUS',
'            when ''Hold''     Then ''''',
'            when ''Released'' Then ''green''',
'            when ''Endorse'' Then ''green''',
'            when ''Rejected'' Then ''red''',
'            when ''Withdraw'' Then ''red''',
'            when ''In-Progress'' then ''#E0901C''',
'        End     icon_color,',
'',
'       COMMENTS,',
'       END_USER_PERSON_ID,',
'       department_name,',
'       sector,',
'       EMAIL,',
'       SUBMISSION_ON,',
'       SUBMIT_BY,',
'       FINAL_APPROVE_ON,',
'       FINAL_APPROVE_BY,',
'       RECEIVING_PERSON_NAME,',
'       EMIRATES_ID,',
'       CHECK_NUM,',
'       EXPIRE_DATE,',
'           BANK_GRANTEE_NUMBER,',
'    CONTRACT_NUMBER',
'  from MANAGER_CHECKS_V',
'  where END_USER_PERSON_ID = :PERSON_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'IS_END_USER_PERSON'
,p_plug_display_when_cond2=>'Y'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'My Manager Cheques'
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
,p_plug_comment=>'to be displayed only for (59 Manager checks finance Approvers role,60  for accounts payables, 61 Access Manager checks group) and for FBP (IS_FBP_YN item)'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(54276033373746003)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil-alt.png" class="apex-edit-pencil-alt" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>54276033373746003
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54276194354746004)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54276233939746005)
,p_db_column_name=>'SUBMIT_BY'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Submit By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54276396495746006)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54276413878746007)
,p_db_column_name=>'FINAL_APPROVE_BY'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Final Approve By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54276510896746008)
,p_db_column_name=>'ICON'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54276691285746009)
,p_db_column_name=>'ICON_COLOR'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Icon Color'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54276716235746010)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54276808628746011)
,p_db_column_name=>'SECTOR'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54276984102746012)
,p_db_column_name=>'RECEIVING_PERSON_NAME'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Receiving Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54277055433746013)
,p_db_column_name=>'EMIRATES_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Emirates ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54277199967746014)
,p_db_column_name=>'CHECK_NUM'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Check No'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ID:#ID#'
,p_column_linktext=>'#CHECK_NUM#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54277250201746015)
,p_db_column_name=>'EXPIRE_DATE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Expire Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54277351280746016)
,p_db_column_name=>'SUPPLIER_NAME'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Supplier Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54277486026746017)
,p_db_column_name=>'CURRENCY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54277511126746018)
,p_db_column_name=>'AMOUNT'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54277636278746019)
,p_db_column_name=>'AMOUNT_IN_AED'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Amount (AED)'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54277799450746020)
,p_db_column_name=>'DESCRIPTIONS'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54277812510746021)
,p_db_column_name=>'PV'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'PVs'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54277994907746022)
,p_db_column_name=>'PAYMENT_NO'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Payment No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54278045595746023)
,p_db_column_name=>'LIST'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'List'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54278122579746024)
,p_db_column_name=>'PAYMENT_TYPE'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Payment Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54278252430746025)
,p_db_column_name=>'MILESTONE_DESCRIPTION'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Milestone Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54278380837746026)
,p_db_column_name=>'MILESTONE_DATE'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Milestone Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54278443543746027)
,p_db_column_name=>'END_USER_EMAIL'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'End User Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54278513192746028)
,p_db_column_name=>'PROJECT'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54278685010746029)
,p_db_column_name=>'TASK'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54278715194746030)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54278813022746031)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54278918516746032)
,p_db_column_name=>'UPLOADED_BY'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Uploaded By'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54279072184746033)
,p_db_column_name=>'UPLOADED_ON'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Uploaded On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54279182906746034)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54279279563746035)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54279357837746036)
,p_db_column_name=>'STATUS'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Status'
,p_column_html_expression=>'<span class="#ICON#" style="color: #ICON_COLOR#"> #STATUS#</span>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54279453107746037)
,p_db_column_name=>'COMMENTS'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54279503672746038)
,p_db_column_name=>'END_USER_PERSON_ID'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Business Owner'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54279648346746039)
,p_db_column_name=>'EMAIL'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Email'
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
,p_default_application_id=>114
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54279742502746040)
,p_db_column_name=>'SUBMISSION_ON'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Submission On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54529423069073029)
,p_db_column_name=>'BANK_GRANTEE_NUMBER'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Bank Grantee Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(54529531027073030)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(54317732784768959)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'543178'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PAYMENT_NO:CHECK_NUM:SUPPLIER_NAME:END_USER_PERSON_ID:CURRENCY:EXPIRE_DATE:AMOUNT_IN_AED:DESCRIPTIONS:MILESTONE_DATE:STATUS::BANK_GRANTEE_NUMBER:CONTRACT_NUMBER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(143005378773083519)
,p_application_user=>'TCA9230'
,p_name=>'Susan'
,p_report_seq=>10
,p_report_columns=>'PAYMENT_NO:CHECK_NUM:SUPPLIER_NAME:AMOUNT:CURRENCY:END_USER_PERSON_ID:EXPIRE_DATE:AMOUNT_IN_AED:DESCRIPTIONS:MILESTONE_DATE:STATUS:BANK_GRANTEE_NUMBER:CONTRACT_NUMBER:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(155988388532902424)
,p_plug_name=>'On Hold'
,p_region_name=>'USERS'
,p_icon_css_classes=>'fa-clock-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent9:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(52873880343734866)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    supplier_name,',
'    currency,',
'    amount,',
'    amount_in_aed,',
'    descriptions,',
'    pv,',
'    payment_no,',
'    list,',
'    payment_type,',
'    milestone_description,',
'    milestone_date milestone_since,',
'    milestone_date,',
'    end_user_email,',
'    project,',
'    task,',
'    cost_center,',
'    gl_account,',
'    uploaded_by,',
'    uploaded_on,',
'    updated_by,',
'    updated_on,',
'    status,',
'    comments,',
'    end_user_person_id,',
'    end_user_person_id    end_user_person_id_h,',
'    user_details.get_cost_center(end_user_person_id) end_user_cost_center,',
'    nvl(FBP_PERSON_ID , (select PERSON_ID',
'        from cost_centers_fbp',
'        where BP_TYPE = ''FBP''',
'        and cost_center = user_details.get_cost_center(end_user_person_id) ',
'        and status = ''A''',
'        and rownum = 1',
'        and sysdate between nvl(start_date , sysdate - 10) ',
'                and nvl(end_date , sysdate + 10)))            FBP_PERSON_ID,',
'    full_name_en,',
'    department_name,',
'    sector,',
'    email,',
'    submission_on,',
'    submit_by,',
'    final_approve_on,',
'    final_approve_by,',
'    RECEIVING_PERSON_NAME,',
'    EMIRATES_ID,',
'    CHECK_NUM,',
'    CHECK_NUM_NEW,',
'    EXPIRE_DATE,',
'        BANK_GRANTEE_NUMBER,',
'    CONTRACT_NUMBER,',
'    (select nvl(count(*) , 0) from manager_checks_reminders mr',
'    where mr.check_id = manager_checks_v.id) Reminder_count',
'    , decode( end_user_person_id , null , ''No User''',
'    , ''<span aria-hidden="true" class="fa fa-envelope-o fa-2x fam-information fam-is-info"></span>'' ',
'        ) Reminder',
'    , decode( STATUS , ''Hold'',',
'    ''<span aria-hidden="true" class="fa fa-refresh fa-2x"></span>'', null) Expired         ',
'FROM',
'    manager_checks_v',
'where  FISICAL_YEAR = nvl(:P1_FISICAL_YEAR , FISICAL_YEAR)',
'and status = NVL(:P1_STATUS , STATUS)',
'order by milestone_date  NULLS LAST',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P1_FISICAL_YEAR,P1_STATUS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count number;',
'BEGIN',
'',
'SELECT count(*) ',
'into l_count',
'FROM dct_data_access_assignment ',
'where entity_type_id = ''ROLE'' ',
'and entity_id in (59,60,61  )--(59 Manager checks finance Approvers role,60  for accounts payables, 61 Access Manager checks group)',
'and status = ''A'' ',
'and sysdate BETWEEN start_date ',
'    and nvl(end_date , sysdate + 10)',
'and person_id = :PERSON_ID;',
'',
'  IF :IS_FBP_YN = ''Y'' or l_count > 0',
'    Then ',
'        return true;',
'    Else',
'        return false;',
'    End if;',
'END;'))
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'On Hold'
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
,p_plug_comment=>'to be displayed only for (59 Manager checks finance Approvers role,60  for accounts payables, 61 Access Manager checks group) and for FBP (IS_FBP_YN item)'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(155988568978902426)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>155988568978902426
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155988695488902427)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155988702881902428)
,p_db_column_name=>'SECTOR'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155988849135902429)
,p_db_column_name=>'EMAIL'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155988905092902430)
,p_db_column_name=>'SUBMISSION_ON'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Submission On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155989095016902431)
,p_db_column_name=>'SUBMIT_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Submit By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155989104145902432)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155989204382902433)
,p_db_column_name=>'FINAL_APPROVE_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Final Approve By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155989397780902434)
,p_db_column_name=>'MILESTONE_SINCE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Milestone Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155989453463902435)
,p_db_column_name=>'REMINDER'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Reminder'
,p_column_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8:P8_CHECK_ID,P8_PERSON_ID,P8_BUSINESS_OWNER,P8_AMOUNT:#ID#,#END_USER_PERSON_ID#,#FULL_NAME_EN#,#AMOUNT#'
,p_column_linktext=>'#REMINDER#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155989539769902436)
,p_db_column_name=>'RECEIVING_PERSON_NAME'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Receiving Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155989675129902437)
,p_db_column_name=>'EMIRATES_ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Emirates ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155989707768902438)
,p_db_column_name=>'CHECK_NUM'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Check No'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ID,P2_PAGE_FROM:#ID#,1'
,p_column_linktext=>'#CHECK_NUM#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155989840425902439)
,p_db_column_name=>'EXPIRE_DATE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Expire Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155989932587902440)
,p_db_column_name=>'REMINDER_COUNT'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Reminder Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155990075026902441)
,p_db_column_name=>'BANK_GRANTEE_NUMBER'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Bank Grantee Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155990161562902442)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155990242284902443)
,p_db_column_name=>'EXPIRED'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Expire'
,p_column_link=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.::P16_ID:#ID#'
,p_column_linktext=>'#EXPIRED#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_display_condition_type=>'NEVER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155990331372902444)
,p_db_column_name=>'CHECK_NUM_NEW'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'New Check No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155990431431902445)
,p_db_column_name=>'PAYMENT_NO'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Payment No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155990596232902446)
,p_db_column_name=>'END_USER_PERSON_ID_H'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'End User Person Id H'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155990689446902447)
,p_db_column_name=>'SUPPLIER_NAME'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Supplier Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155990719593902448)
,p_db_column_name=>'CURRENCY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155990886807902449)
,p_db_column_name=>'AMOUNT'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Check Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(155990978133902450)
,p_db_column_name=>'AMOUNT_IN_AED'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Amount  (AED)'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156776552371174401)
,p_db_column_name=>'DESCRIPTIONS'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156776637981174402)
,p_db_column_name=>'PV'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'PV'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156776758023174403)
,p_db_column_name=>'LIST'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'List'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156776881724174404)
,p_db_column_name=>'PAYMENT_TYPE'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Payment Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156776971901174405)
,p_db_column_name=>'MILESTONE_DESCRIPTION'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Milestone Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156777096020174406)
,p_db_column_name=>'MILESTONE_DATE'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Milestone Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156777155247174407)
,p_db_column_name=>'END_USER_EMAIL'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'End User Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156777239497174408)
,p_db_column_name=>'PROJECT'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156777318090174409)
,p_db_column_name=>'TASK'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156777418066174410)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156777518079174411)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'GL Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156777649882174412)
,p_db_column_name=>'UPLOADED_BY'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156777762967174413)
,p_db_column_name=>'UPLOADED_ON'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Uploaded On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156777860904174414)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>380
,p_column_identifier=>'AL'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(52986061814825111)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156777947036174415)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>390
,p_column_identifier=>'AM'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156778015903174416)
,p_db_column_name=>'STATUS'
,p_display_order=>400
,p_column_identifier=>'AN'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156778151634174417)
,p_db_column_name=>'COMMENTS'
,p_display_order=>410
,p_column_identifier=>'AO'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156778273134174418)
,p_db_column_name=>'END_USER_PERSON_ID'
,p_display_order=>420
,p_column_identifier=>'AP'
,p_column_label=>'End User Person ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156778393660174419)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>430
,p_column_identifier=>'AQ'
,p_column_label=>'Business Owner'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(156778409379174420)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>440
,p_column_identifier=>'AR'
,p_column_label=>'Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157192424885961628)
,p_db_column_name=>'END_USER_COST_CENTER'
,p_display_order=>450
,p_column_identifier=>'AS'
,p_column_label=>'End User Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(157192556533961629)
,p_db_column_name=>'FBP_PERSON_ID'
,p_display_order=>460
,p_column_identifier=>'AT'
,p_column_label=>'FBP Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(158481632624258812)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(156796222690182591)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1567963'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CHECK_NUM:FULL_NAME_EN:SUPPLIER_NAME:FBP_PERSON_ID:AMOUNT:CURRENCY:AMOUNT_IN_AED:DESCRIPTIONS:END_USER_EMAIL:STATUS:REMINDER_COUNT:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(155988453103902425)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(155988388532902424)
,p_button_name=>'Send_Reminder_Email'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_image_alt=>'Send Reminder Email'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:19:&SESSION.::&DEBUG.:19::'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(52715386133537950)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(52969298190734951)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(52936058388734896)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Check'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2::'
,p_button_condition=>':PERSON_ID in (680461 , 1535161 ,128357)'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54181184680782809)
,p_name=>'P1_CHECK_COUNT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(52969298190734951)
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(*)',
'from manager_checks',
'where FISICAL_YEAR = nvl(:P1_FISICAL_YEAR , fisical_year);'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(54181249954782810)
,p_name=>'P1_CHECK_AMOUNT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(52969298190734951)
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(sum(AMOUNT_IN_AED) , ''99,999,999,999.99'')) tot',
'from manager_checks',
'where FISICAL_YEAR = nvl(:P1_FISICAL_YEAR , fisical_year);'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(104451608412598938)
,p_name=>'P1_TIME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(52712037915537917)
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'select to_char(SYSTIMESTAMP + INTERVAL ''4'' hour , ''dd-MON-yyyy hh:mi:ss'')  from dual;'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(142142477202939893)
,p_name=>'P1_FISICAL_YEAR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(53435364998667718)
,p_item_default=>'select extract(YEAR from sysdate) - 1 from dual;'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Fisical Year'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:2021;2021,2022;2022,2023;2023,2024;2024,2025;2024'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(52934951552734894)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(159173090800435610)
,p_name=>'P1_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(155988388532902424)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct STATUS d, status ',
'from manager_checks',
'where status not in (''Released'', ''Void'', ''Released- Manually'')',
'order by 1'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(52934951552734894)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(228125587318601603)
,p_name=>'P1_CHECK_ID_DOC'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(52712037915537917)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(228125609304601604)
,p_name=>'P1_CHECK_NUM_DOC'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(52712037915537917)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(53683664658159624)
,p_name=>'Remider DA'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(53301191818558634)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(53683780259159625)
,p_event_id=>wwv_flow_api.id(53683664658159624)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(53301191818558634)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(53683908187159627)
,p_event_id=>wwv_flow_api.id(53683664658159624)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess( "Reminder Email Sent. " );'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(141649308488843908)
,p_name=>'Change Year DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_FISICAL_YEAR'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(141649438365843909)
,p_event_id=>wwv_flow_api.id(141649308488843908)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(53300791930558630)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(141649598874843910)
,p_event_id=>wwv_flow_api.id(141649308488843908)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(53300245021558625)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(141649640268843911)
,p_event_id=>wwv_flow_api.id(141649308488843908)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(53301191818558634)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(141649757071843912)
,p_event_id=>wwv_flow_api.id(141649308488843908)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(52712037915537917)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(142408497449823846)
,p_name=>'Submit'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_FISICAL_YEAR'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(142408507541823847)
,p_event_id=>wwv_flow_api.id(142408497449823846)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(159173192075435611)
,p_name=>'Status DA'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_STATUS'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(159173215111435612)
,p_event_id=>wwv_flow_api.id(159173192075435611)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(155988388532902424)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(228125477322601602)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'DOWNLOAD_ATTACHMENTS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
' DECLARE',
'    l_download_file_name  VARCHAR2(64) := :P1_CHECK_NUM_DOC ||''-attachments.zip'';',
'    l_zip_file        BLOB;',
'    l_disposition     VARCHAR2(30) := ''attachment'';',
' BEGIN',
'    FOR i IN (select filename,',
'                    file_blob',
'               from MANAGER_CHECKS_DOCUMENTS',
'               where CHECK_ID = :P1_CHECK_ID_DOC',
'    ) LOOP',
'      -- Add files to the zip ',
'     apex_zip.add_file(',
'                        p_zipped_blob => l_zip_file',
'                      , p_file_name => i.filename',
'                      , p_content => i.file_blob',
'       );',
'    END LOOP;',
'',
'    -- Finish zipping',
'    apex_zip.finish(p_zipped_blob => l_zip_file);',
'    -- Download zip file',
'    sys.htp.init;',
'    sys.owa_util.mime_header(',
'                            ''application/zip''',
'                          , false',
'    );',
'    sys.htp.p(''Content-length: ''',
'              || sys.dbms_lob.getlength(l_zip_file));',
'',
'    sys.htp.p(''Content-Disposition: attachment; filename="''',
'              || l_download_file_name',
'              || ''"'');',
'    sys.owa_util.http_header_close;',
'    sys.wpg_docload.download_file(l_zip_file);',
'    apex_application.stop_apex_engine;',
' END;',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
