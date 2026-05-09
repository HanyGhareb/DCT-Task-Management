prompt --application/pages/page_00051
begin
--   Manifest
--     PAGE: 00051
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>51
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'CWIP Payments Delegation - Admin'
,p_alias=>'CWIP-PAYMENTS-DELEGATION-ADMIN'
,p_step_title=>'CWIP Payments Delegation - Admin'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220210093346'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(81465206222034354)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10254567086597785)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(10191147067597728)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(10308621936597827)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(81465737989034352)
,p_plug_name=>'CWIP Payments Delegation - Admin'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(10245193460597780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   h.id',
'        ,h.PAYMENT_RECOMMENDATION_ID',
'        ,h.step_no',
'        ,h.person_id',
'        ,h.person_type',
'        ,h.recevied_date',
'        ,h.recevied_date    Pending_since',
'        ,h.status',
'        ,e.full_name_en',
'        ,e.employee_num',
'        ,e.email',
'        ,p.REFERENCE_NUMBER',
'        ,p.PAYMENT_RECOMMENDATION_DATE',
'        ,p.CURRENT_VALUATION_AMOUNT',
'        ,nvl(h.reminder_count,0) reminder_count',
'        ,h.reminder_by',
'        ,h.last_reminder_on',
'        , case nvl(dbms_lob.getlength(e.photo_blob),0) WHEN  0 then',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'          else ',
'            ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'          end PHOTO',
'         , ''<span aria-hidden="true" class="fa fa-mail-forward fa-2x fam-information fam-is-success"></span>'' Action',
'         , ''<span aria-hidden="true" class="fa fa-envelope-o fa-2x fam-information fam-is-info"></span>'' Reminder',
'from cwip_payment_rec_approval_history h , cwip_payment_recommendation p , employees_v e',
'where h.PAYMENT_RECOMMENDATION_ID = p.PAYMENT_RECOMMENDATION_ID',
'and h.status in (''Pending'', ''Hold'')',
'and p.APPROVAL_STATUS in (''In-Progress'', ''Hold'')',
'and h.person_id = e.person_id',
'and h.action_date is null'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Delegate Petty Cash - Admin'
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
 p_id=>wwv_flow_api.id(81465817504034352)
,p_name=>'Petty Cash Delegation - Admin'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>121901859332936622
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14084412756165206)
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
 p_id=>wwv_flow_api.id(14085202200165207)
,p_db_column_name=>'STEP_NO'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Step No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14086043083165207)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Pending With'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14086412167165207)
,p_db_column_name=>'EMAIL'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14082829970165205)
,p_db_column_name=>'PHOTO'
,p_display_order=>18
,p_column_identifier=>'I'
,p_column_label=>'Employee'
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
 p_id=>wwv_flow_api.id(14083243685165206)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>28
,p_column_identifier=>'J'
,p_column_label=>'Received ON'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14083630501165206)
,p_db_column_name=>'PENDING_SINCE'
,p_display_order=>38
,p_column_identifier=>'K'
,p_column_label=>'Pending Since'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14083980163165206)
,p_db_column_name=>'ACTION'
,p_display_order=>48
,p_column_identifier=>'M'
,p_column_label=>'Delegate'
,p_column_link=>'f?p=&APP_ID.:52:&SESSION.::&DEBUG.:52:P52_FROM_PERSON_ID,P52_HISTORY_ID,P52_PAYMENT_RECOMMENDATION_ID,P52_REFERENCE_NUMBER:#PERSON_ID#,#ID#,#PAYMENT_RECOMMENDATION_ID#,#REFERENCE_NUMBER#'
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
 p_id=>wwv_flow_api.id(14087575656165208)
,p_db_column_name=>'REMINDER'
,p_display_order=>58
,p_column_identifier=>'N'
,p_column_label=>'Reminder'
,p_column_link=>'f?p=&APP_ID.:53:&SESSION.::&DEBUG.::P53_EMPLOYEE_NAME,P53_P_HISTORY_ID,P53_P_PAYMENT_RECOMMENDATION_ID,P53_P_PERSON_ID,P53_P_PERSON_TYPE:#FULL_NAME_EN#,#ID#,#PAYMENT_RECOMMENDATION_ID#,#PERSON_ID#,#PERSON_TYPE#'
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
 p_id=>wwv_flow_api.id(14088006907165208)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>68
,p_column_identifier=>'O'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(13844471919843778)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>88
,p_column_identifier=>'Q'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14090706128170732)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>98
,p_column_identifier=>'U'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14090782022170733)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>108
,p_column_identifier=>'V'
,p_column_label=>'Reference Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14090920153170734)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_DATE'
,p_display_order=>118
,p_column_identifier=>'W'
,p_column_label=>'Payment Recommendation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14091005303170735)
,p_db_column_name=>'CURRENT_VALUATION_AMOUNT'
,p_display_order=>128
,p_column_identifier=>'X'
,p_column_label=>'Current Valuation Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14091549827170740)
,p_db_column_name=>'PERSON_TYPE'
,p_display_order=>138
,p_column_identifier=>'Y'
,p_column_label=>'Person Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14613097499388543)
,p_db_column_name=>'REMINDER_COUNT'
,p_display_order=>148
,p_column_identifier=>'Z'
,p_column_label=>'Reminder Count'
,p_column_link=>'f?p=&APP_ID.:55:&SESSION.::&DEBUG.:55:P55_PAYMENT_RECOMMENDATION_ID,P55_PPERSON_ID:#PAYMENT_RECOMMENDATION_ID#,#PERSON_ID#'
,p_column_linktext=>'#REMINDER_COUNT#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14613241769388544)
,p_db_column_name=>'REMINDER_BY'
,p_display_order=>158
,p_column_identifier=>'AA'
,p_column_label=>'Reminder By'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(14748831516520519)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(14613272569388545)
,p_db_column_name=>'LAST_REMINDER_ON'
,p_display_order=>168
,p_column_identifier=>'AB'
,p_column_label=>'Last Reminder On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(52049233650923179)
,p_db_column_name=>'STATUS'
,p_display_order=>178
,p_column_identifier=>'AC'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(81469496148975819)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'545244'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PHOTO:FULL_NAME_EN:EMAIL:REFERENCE_NUMBER:STATUS:PAYMENT_RECOMMENDATION_DATE:CURRENT_VALUATION_AMOUNT:PENDING_SINCE:REMINDER_COUNT:REMINDER_BY:LAST_REMINDER_ON:ACTION:REMINDER:'
,p_sort_column_1=>'PENDING_SINCE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(14091306751170738)
,p_name=>'close Dialog Delegation'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(81465737989034352)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(14091424123170739)
,p_event_id=>wwv_flow_api.id(14091306751170738)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(81465737989034352)
);
wwv_flow_api.component_end;
end;
/
