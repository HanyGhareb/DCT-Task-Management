prompt --application/pages/page_00049
begin
--   Manifest
--     PAGE: 00049
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>49
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Delegation Management'
,p_alias=>'DELEGATION-MANAGEMENT'
,p_step_title=>'Delegation Management'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240307122416'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(195481386925585124)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12908155528762118)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12844716791762062)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12962203224762162)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(255164671689333466)
,p_plug_name=>'Missions Delegation Management'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12881785965762100)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(195481906766585122)
,p_plug_name=>'Delegation Management'
,p_parent_plug_id=>wwv_flow_api.id(255164671689333466)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  h.id',
'        ,h.REQUEST_ID',
'        ,h.step_no',
'         ,h.person_id',
'        ,h.recevied_date',
'        ,h.recevied_date    Pending_since',
'        ,H.APPROVAL_TYPE_ID',
'        ,e.full_name_en',
'        ,e.employee_num',
'        ,e.email',
'        ',
'        , p.request_no',
'        ,(select x.full_name_en ',
'         from employees_v x',
'         where x.person_id = p.SUBMITTED_BY) Requestor',
'         ',
'        ,p.AMOUNT Amount',
'        , case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end PHOTO',
'         , ''<span aria-hidden="true" class="fa fa-mail-forward fa-2x fam-information fam-is-success"></span>'' Action',
'         , ''<span aria-hidden="true" class="fa fa-envelope-o fa-2x fam-information fam-is-info"></span>'' Reminder',
'from mission_approval_history h , mission_header p , employees_v e',
'where h.REQUEST_ID = p.REQUEST_ID',
'and h.status = ''Pending''',
'and p.REQUEST_TYPE = ''M''',
'-- nd p.ou_code = :OU_CODE',
'and h.person_id = e.person_id;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Delegation Management'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(195482024511585122)
,p_name=>'Delegation Management'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>306092901001592099
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86598300003595556)
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
 p_id=>wwv_flow_api.id(86598580804595559)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86598940957595560)
,p_db_column_name=>'STEP_NO'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Step No'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86599358434595560)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86599727660595560)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86600187200595560)
,p_db_column_name=>'PENDING_SINCE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Pending Since'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86600613340595567)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86600952513595567)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Pending With'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86601398547595567)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86601814098595567)
,p_db_column_name=>'EMAIL'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86602131940595568)
,p_db_column_name=>'REQUESTOR'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Requestor'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86602562957595568)
,p_db_column_name=>'AMOUNT'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86602987069595568)
,p_db_column_name=>'PHOTO'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86603345255595569)
,p_db_column_name=>'ACTION'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Delegate'
,p_column_link=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:50:P50_EMPLOYEE_NAME,P50_PERSON_ID,P50_REQUEST_ID,P50_TYPE,P50_HISTORY_ID:#FULL_NAME_EN#,#PERSON_ID#,#REQUEST_ID#,D,#ID#'
,p_column_linktext=>'#ACTION#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86603743993595569)
,p_db_column_name=>'REMINDER'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Reminder'
,p_column_link=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:50:P50_EMPLOYEE_NAME,P50_PERSON_ID,P50_REQUEST_ID,P50_TYPE,P50_HISTORY_ID:#FULL_NAME_EN#,#PERSON_ID#,#REQUEST_ID#,R,#ID#'
,p_column_linktext=>'#REMINDER#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86604181076595569)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>25
,p_column_identifier=>'P'
,p_column_label=>'Request No'
,p_column_link=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.::P13_REQUEST_ID,REQUEST_ID,P13_PAGE_FROM:#REQUEST_ID#,#REQUEST_ID#,49'
,p_column_linktext=>'#REQUEST_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(195500034389487683)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1972154'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PHOTO:REQUEST_NO:FULL_NAME_EN:EMPLOYEE_NUM:RECEVIED_DATE:PENDING_SINCE:REQUESTOR:ACTION:REMINDER:'
,p_sort_column_1=>'PENDING_SINCE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(255164761922333467)
,p_plug_name=>'Training Delegation Management'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideShowIconsMath:is-expanded:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12881785965762100)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(256408057272434518)
,p_plug_name=>'Training Delegation Report'
,p_parent_plug_id=>wwv_flow_api.id(255164761922333467)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  h.id',
'        ,h.REQUEST_ID',
'        ,h.step_no',
'         ,h.person_id',
'        ,h.recevied_date',
'        ,h.recevied_date    Pending_since',
'        ,H.APPROVAL_TYPE_ID',
'        ,e.full_name_en',
'        ,e.employee_num',
'        ,e.email',
'        ',
'        , p.request_no',
'        ,(select x.full_name_en ',
'         from employees_v x',
'         where x.person_id = p.SUBMITTED_BY) Requestor',
'         ',
'        ,p.AMOUNT Amount',
'        , case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end PHOTO',
'         , ''<span aria-hidden="true" class="fa fa-mail-forward fa-2x fam-information fam-is-success"></span>'' Action',
'         , ''<span aria-hidden="true" class="fa fa-envelope-o fa-2x fam-information fam-is-info"></span>'' Reminder',
'from mission_approval_history h , mission_header p , employees_v e',
'where h.REQUEST_ID = p.REQUEST_ID',
'and h.status = ''Pending''',
'and p.REQUEST_TYPE = ''T''',
'-- and p.ou_code = :OU_CODE',
'and h.person_id = e.person_id;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Training Delegation Report'
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
 p_id=>wwv_flow_api.id(256408140075434519)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>367019016565441496
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86605562957595576)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86605962262595576)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86606379196595576)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Step No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86606819036595577)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86607130248595577)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86607567874595577)
,p_db_column_name=>'PENDING_SINCE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Pending Since'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86608011807595577)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Pending With'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86608385841595577)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86608729554595578)
,p_db_column_name=>'EMAIL'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86609151909595578)
,p_db_column_name=>'REQUESTOR'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Requestor'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86609946349595578)
,p_db_column_name=>'PHOTO'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Photo'
,p_column_html_expression=>'<br><img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86610364713595578)
,p_db_column_name=>'ACTION'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Action'
,p_column_link=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:50:P50_EMPLOYEE_NAME,P50_PERSON_ID,P50_REQUEST_ID,P50_TYPE,P50_HISTORY_ID:#FULL_NAME_EN#,#PERSON_ID#,#REQUEST_ID#,D,#ID#'
,p_column_linktext=>'#ACTION#'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(86610739608595579)
,p_db_column_name=>'REMINDER'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Reminder'
,p_column_link=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:50:P50_EMPLOYEE_NAME,P50_PERSON_ID,P50_REQUEST_ID,P50_TYPE,P50_HISTORY_ID:#FULL_NAME_EN#,#PERSON_ID#,#REQUEST_ID#,RBP,#ID#'
,p_column_linktext=>'#REMINDER#'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84398999320618540)
,p_db_column_name=>'APPROVAL_TYPE_ID'
,p_display_order=>150
,p_column_identifier=>'P'
,p_column_label=>'Approval Type Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84399071796618541)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>160
,p_column_identifier=>'Q'
,p_column_label=>'Request No'
,p_column_link=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.::P13_REQUEST_ID,REQUEST_ID,P13_PAGE_FROM:#REQUEST_ID#,#REQUEST_ID#,49'
,p_column_linktext=>'#REQUEST_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(84399202258618542)
,p_db_column_name=>'AMOUNT'
,p_display_order=>170
,p_column_identifier=>'R'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(256419025914441192)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1972224'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PHOTO:REQUEST_NO:FULL_NAME_EN:EMPLOYEE_NUM:RECEVIED_DATE:PENDING_SINCE:EMAIL:REQUESTOR:ACTION:REMINDER:'
,p_sort_column_1=>'PENDING_SINCE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(95286579622365053)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(255164671689333466)
,p_button_name=>'Process_Outsource_FYI'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Process Outsource Fyi'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_PAYROLL_ADMIN = ''Y'' OR',
':PERSON_ID = 680461'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(86612552060595583)
,p_name=>'Refresh after close Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(195481906766585122)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(86613110315595585)
,p_event_id=>wwv_flow_api.id(86612552060595583)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(195481906766585122)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(95286658665365054)
,p_name=>'Process_Outsource_FYI DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(95286579622365053)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(95286816392365055)
,p_event_id=>wwv_flow_api.id(95286658665365054)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you will process all requests pending with Companies FYI?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(95286848505365056)
,p_event_id=>wwv_flow_api.id(95286658665365054)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'for rec in (select h.id ,h.request_id , h.step_no , h.RECEVIED_DATE',
'        from mission_approval_history h',
'        where 1=1',
'        and h.STATUS = ''Pending'' ',
'        and h.ACTION_REQUIRED = ''FYI''',
'        and h.request_id in (select m.request_id ',
'                              from mission_header m',
'                              where m.request_id = h.request_id',
'                              and m.invoice_number is not null) )',
'Loop',
'    update mission_approval_history',
'    set STATUS = ''Notified'' , ACTION_DATE = systimestamp',
'    where id = rec.id;',
'    ',
'    update mission_approval_history',
'    set STATUS = ''Pending'' , RECEVIED_DATE = systimestamp',
'    where request_id = rec.request_id ',
'    and step_no = rec.step_no + 1 ',
'    ;',
'    ',
' --   dbms_output.put_line(''Done for '' || rec.request_id);',
'End loop;'))
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(95286958974365057)
,p_event_id=>wwv_flow_api.id(95286658665365054)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(195481906766585122)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(95287027170365058)
,p_event_id=>wwv_flow_api.id(95286658665365054)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(256408057272434518)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(95287153549365059)
,p_event_id=>wwv_flow_api.id(95286658665365054)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Success!'
);
wwv_flow_api.component_end;
end;
/
