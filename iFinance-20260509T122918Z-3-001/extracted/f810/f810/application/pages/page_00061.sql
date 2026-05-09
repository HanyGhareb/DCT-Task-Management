prompt --application/pages/page_00061
begin
--   Manifest
--     PAGE: 00061
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
 p_id=>61
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'My Worklist'
,p_alias=>'MY-WORKLIST'
,p_step_title=>'My Worklist'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231119145616'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(93472564420431675)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12908155528762118)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12844716791762062)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12962203224762162)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(93508436274278428)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-TabsRegion-mod--simple'
,p_plug_template=>wwv_flow_api.id(12905503889762115)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(93473203666431675)
,p_plug_name=>'My Worklist'
,p_parent_plug_id=>wwv_flow_api.id(93508436274278428)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT  h.id            history_ID,',
'        pr.request_id   request_id,',
'      case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'       when 0  THEN',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'        else  ',
'            ',
'         ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'       end Photo,',
'--  ',
'      e.employee_num,  ',
'--',
'    case REQUEST_TYPE when ''M'' Then ''Mission''',
'                     when  ''T'' Then ''Training'' ',
'    End ',
'    || ''# '' ||',
'    pr.REQUEST_NO   ||',
'    '',for: ''      ||',
'    user_details.get_full_name(e.person_id) ||',
'    '' (''                                     ||',
'    (trim(to_char(nvl(MISSION_UTIL.get_mission_amount(pr.request_id),0), ''99,999,999.99'')))           ||',
'    '' AED)''                                          AS      Subject,',
'',
'',
'  h.recevied_date    ',
'',
'   , h.created_on ',
'from mission_approval_history h , mission_header pr, employees_v e',
'',
'where pr.request_for = e.person_id ',
'and h.person_id = :PERSON_ID',
'and h.request_id = pr.request_id',
'and h.status = ''Pending'' ',
'order by h.created_on desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'My Worklist'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(93473250928431675)
,p_name=>'My Worklist'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>204084127418438652
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91721238800528467)
,p_db_column_name=>'PHOTO'
,p_display_order=>25
,p_column_identifier=>'K'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91721330824528468)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>35
,p_column_identifier=>'L'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91721446518528469)
,p_db_column_name=>'SUBJECT'
,p_display_order=>45
,p_column_identifier=>'M'
,p_column_label=>'Subject'
,p_column_link=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:20:P20_REQUEST_ID,P20_HISTORY_ID,P20_PAGE_FROM:#REQUEST_ID#,#HISTORY_ID#,61'
,p_column_linktext=>'#SUBJECT#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91721603304528470)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>55
,p_column_identifier=>'N'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91721626704528471)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>65
,p_column_identifier=>'O'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91721758582528472)
,p_db_column_name=>'HISTORY_ID'
,p_display_order=>75
,p_column_identifier=>'P'
,p_column_label=>'History Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91721830049528473)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>85
,p_column_identifier=>'Q'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(93477943366437363)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2040889'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PHOTO:EMPLOYEE_NUM:SUBJECT:RECEVIED_DATE:CREATED_ON:HISTORY_ID:REQUEST_ID'
,p_sort_column_1=>'RECEVIED_DATE'
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
 p_id=>wwv_flow_api.id(93508574800278429)
,p_plug_name=>'History'
,p_parent_plug_id=>wwv_flow_api.id(93508436274278428)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT  h.id            history_ID,',
'        pr.request_id   request_id,',
'      case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'       when 0  THEN',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'        else  ',
'            ',
'         ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'       end Photo,',
'--  ',
'      e.employee_num,  ',
'--',
'    case REQUEST_TYPE when ''M'' Then ''Mission''',
'                     when  ''T'' Then ''Training'' ',
'    End ',
'    || ''# '' ||',
'    pr.REQUEST_NO   ||',
'    '',for: ''      ||',
'    user_details.get_full_name(e.person_id) ||',
'    '' (''                                     ||',
'    (trim(to_char(nvl(MISSION_UTIL.get_mission_amount(pr.request_id),0), ''99,999,999.99'')))           ||',
'    '' AED)''                                          AS      Subject,',
'',
'',
'  h.recevied_date    ',
'  , h.ACTION_DATE',
'  , h.STATUS',
'',
'   , h.created_on ',
'from mission_approval_history h , mission_header pr, employees_v e',
'',
'where pr.request_for = e.person_id ',
'and h.person_id = :PERSON_ID',
'and h.request_id = pr.request_id',
'and h.ACTION_DATE is not null',
'order by h.ACTION_DATE desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'History'
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
 p_id=>wwv_flow_api.id(93508652714278430)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>204119529204285407
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(93508757276278431)
,p_db_column_name=>'PHOTO'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(93508876458278432)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(93508995704278433)
,p_db_column_name=>'SUBJECT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Subject'
,p_column_link=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13:P13_REQUEST_ID,REQUEST_ID,P13_PAGE_FROM,P13_REQUEST_ID:#REQUEST_ID#,#HISTORY_ID#,61,#REQUEST_ID#'
,p_column_linktext=>'#SUBJECT#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(93509037464278434)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(93509148646278435)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(93509263864278436)
,p_db_column_name=>'HISTORY_ID'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'History Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(93509338661278437)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(93509457075278438)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(93509572014278439)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(93523737441677545)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2041347'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PHOTO:EMPLOYEE_NUM:SUBJECT:RECEVIED_DATE:CREATED_ON:HISTORY_ID:REQUEST_ID:ACTION_DATE:STATUS'
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
wwv_flow_api.component_end;
end;
/
