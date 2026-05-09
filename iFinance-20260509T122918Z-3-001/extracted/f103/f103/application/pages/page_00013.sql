prompt --application/pages/page_00013
begin
--   Manifest
--     PAGE: 00013
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>116806299474925354
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>13
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'My Notification History'
,p_alias=>'MY-NOTIFICATION-HISTORY'
,p_step_title=>'My Notification History'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210828114502'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(34961864336234949)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23845862961372548)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(23782494216372596)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(23899958141372507)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(34962385699234948)
,p_plug_name=>'My Notification History'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23834504913372554)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    h.id          id,',
'    h.credit_card_id,',
'    h.recevied_date,',
'    h.status,',
'    h.action_date,',
'    h.approval_type,',
'    -- credit card details',
'    cc.requested_amount,',
'    (select e.full_name_en',
'     from employees_v e',
'     where e.person_id = cc.requestor_person_id) Requestor,',
'      apex_util.prepare_url(''f?p=''|| :APP_ID || '':6:''|| :APP_SESSION || '':info:NO::P6_ID:''|| cc.id)    Link',
'FROM',
'    credit_card_approval_history h, credit_cards cc',
'where cc.id = h.credit_card_id',
'and h.person_id = :PERSON_ID',
'and h.status not in ( ''Pending'' , ''Future'')',
'union All',
'SELECT',
'    an.id                       id,',
'    to_number(request_id)        credit_card_id,',
'    created_date                recevied_date,',
'    decode(acknowledge,''Y'',''CLosed'',''N'',''Open'')                 Status,',
'    updated_date                action_date,',
'    case notification_type',
'        When  ''CREDIT_CARD_APPROVAL'' ',
'            Then ''Credit Card DOA Approval''',
'        when ''FINANCE_APPROVAL''  ',
'            Then ''Credit Card Finance Approval''',
'        else notification_type',
'        End                         approval_type,',
'     cc.requested_amount                                        requested_amount,  ',
'     (select e.full_name_en',
'     from employees_v e',
'     where e.person_id = cc.requestor_person_id)                Requestor,',
'     apex_util.prepare_url(''f?p=''|| :APP_ID || '':12:''|| :APP_SESSION || '':info:NO::P12_ID,P12_HISTORY_ID:''|| an.request_id|| '',''|| an.id)   Link',
'FROM',
'    all_notifications an , credit_cards cc',
'where cc.id = an.request_id',
'and an.person_id = :PERSON_ID',
'and an.acknowledge = ''Y'';'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'My Notification History'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(34962498585234948)
,p_name=>'My Notification History'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>34962498585234948
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34965654320234942)
,p_db_column_name=>'REQUESTOR'
,p_display_order=>10
,p_column_identifier=>'H'
,p_column_label=>'Requestor'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34964839889234943)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>20
,p_column_identifier=>'F'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34963685096234944)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34964056706234943)
,p_db_column_name=>'STATUS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34964424723234943)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34965208072234943)
,p_db_column_name=>'REQUESTED_AMOUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Requested Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34963247538234944)
,p_db_column_name=>'CREDIT_CARD_ID'
,p_display_order=>80
,p_column_identifier=>'B'
,p_column_label=>'Credit Card Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34966010497234942)
,p_db_column_name=>'LINK'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Link'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34962818337234944)
,p_db_column_name=>'ID'
,p_display_order=>100
,p_column_identifier=>'A'
,p_column_label=>'Info'
,p_column_link=>'#LINK#'
,p_column_linktext=>'<span class="fa fa-info-circle-o" aria-hidden="true"></span>'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(34966493651234101)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'349665'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUESTOR:APPROVAL_TYPE:RECEVIED_DATE:STATUS:ACTION_DATE:REQUESTED_AMOUNT:ID:CREDIT_CARD_ID'
,p_sort_column_1=>'ACTION_DATE'
,p_sort_direction_1=>'DESC NULLS LAST'
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
wwv_flow_api.component_end;
end;
/
