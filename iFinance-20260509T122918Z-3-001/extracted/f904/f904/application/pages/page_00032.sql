prompt --application/pages/page_00032
begin
--   Manifest
--     PAGE: 00032
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>32
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Notifications History'
,p_alias=>'NOTIFICATIONS-HISTORY'
,p_step_title=>'Notifications History'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210518221515'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22150137321726497)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10254567086597785)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(10191147067597728)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(10308621936597827)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22150714866726497)
,p_plug_name=>'Notifications History'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'        h.id',
'       ,pr.payment_recommendation_id ',
'       ,pr.reference_number',
'       ,pr.payment_number',
'       ,pr.payment_recommendation_date',
'       ,pr.invoice_num',
'       ,pr.invoice_date',
'       ,pr.total_invoice_amount',
'       ,pr.vendor_name',
'       ,pr.contract_number',
'       ,pr.contract_amount',
'       ,pr.contract_title',
'       ,pr.contract_description',
'       ,pr.contract_reference',
'       ,pr.project_number',
'       ,pr.project_name',
'       ,h.role_id',
'       ,h.action_required',
'       ,h.action_date',
'       ,h.recevied_date',
'       ,h.status',
'       ,h.comments  "comment"',
'       ,h.approval_type',
'from cwip_payment_rec_approval_history h , cwip_payment_recommendation_v pr',
'where h.payment_recommendation_id = pr.payment_recommendation_id',
'and h.person_type = ''INT''',
'and h.person_id = :PERSON_ID  ',
'and h.status != ''Future''',
'order by h.action_date desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Notifications History'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(22150893382726497)
,p_name=>'Notifications History'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.:15:P15_PAYMENT_RECOMMENDATION_ID,P15_PAGE_FROM,P15_ID:#PAYMENT_RECOMMENDATION_ID#,32,#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>22150893382726497
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22151231934726500)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22151662552726500)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Reference Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22152016222726500)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22152403602726500)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_DATE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'REC Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22152895990726501)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22153240366726501)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22153699838726501)
,p_db_column_name=>'TOTAL_INVOICE_AMOUNT'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Total Invoice Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22154083463726502)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22154438751726502)
,p_db_column_name=>'CONTRACT_AMOUNT'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Contract Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22154859035726502)
,p_db_column_name=>'CONTRACT_TITLE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Contract Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22155214591726502)
,p_db_column_name=>'CONTRACT_DESCRIPTION'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Contract Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22155699556726503)
,p_db_column_name=>'CONTRACT_REFERENCE'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Contract Reference'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22156037949726503)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22156476389726503)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22156802979726503)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Role Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22157270184726504)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22157672889726504)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22158020597726504)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22158402530726505)
,p_db_column_name=>'STATUS'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22158894898726505)
,p_db_column_name=>'comment'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22159267647726505)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21963706358318825)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>31
,p_column_identifier=>'V'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21963963812318827)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>41
,p_column_identifier=>'W'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(22159699255728353)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'221597'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REFERENCE_NUMBER:CONTRACT_NUMBER:CONTRACT_TITLE:VENDOR_NAME:PROJECT_NAME:RECEVIED_DATE:ACTION_DATE:STATUS:'
,p_sort_column_1=>'ACTION_DATE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.component_end;
end;
/
