prompt --application/pages/page_00033
begin
--   Manifest
--     PAGE: 00033
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>33
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'Login History'
,p_alias=>'LOGIN-HISTORY'
,p_step_title=>'Login History'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230910155158'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(92452350424969353)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1611180433302287)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(1547752126302241)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(1665264360302322)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(92452983067969354)
,p_plug_name=>'Login History'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1599843476302282)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select h.ID,',
'       h.USER_NAME,',
'       e.full_name_en,',
'       e.email,',
'       h.USER_KEY,',
'       h.ACTION_DATE,',
'       h.ACTION_DATE sinc,',
'       h.RESULT',
'  from LOGIN_HISTORY h, employees_v e',
'  where h.user_name = e.user_name',
'  order by h.ACTION_DATE desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Login History'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(92453047896969354)
,p_name=>'Login History'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>92453047896969354
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92453498777969356)
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
 p_id=>wwv_flow_api.id(92453886038969358)
,p_db_column_name=>'USER_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92454250014969358)
,p_db_column_name=>'USER_KEY'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'User Key'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92454608161969358)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92132336215459249)
,p_db_column_name=>'SINC'
,p_display_order=>14
,p_column_identifier=>'H'
,p_column_label=>'Sinc'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92455049170969358)
,p_db_column_name=>'RESULT'
,p_display_order=>24
,p_column_identifier=>'E'
,p_column_label=>'Result'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92132195012459247)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>34
,p_column_identifier=>'F'
,p_column_label=>'Full Name En'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92132270890459248)
,p_db_column_name=>'EMAIL'
,p_display_order=>44
,p_column_identifier=>'G'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(92455684108970085)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'924557'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:USER_NAME:USER_KEY:ACTION_DATE:RESULT:FULL_NAME_EN:EMAIL:SINC'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(189262497900827717)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(92452350424969353)
,p_button_name=>'Maintain'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(1663977999302321)
,p_button_image_alt=>'Maintain Accounts'
,p_button_position=>'REGION_TEMPLATE_EDIT'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(189262515337827718)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Maintain Accounts Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'for emp in (    select xx.USER_NAME USER_NAME, xx.USER_KEY    user_key, xx.ACTION_DATE',
'                from LOGIN_HISTORY  xx, (  select USER_NAME, MAX(ACTION_DATE) dd',
'                                            from LOGIN_HISTORY ',
'                                            where result = ''Sucess''',
'                                            GROUP by USER_NAME) BB',
'                where xx.user_name = bb.user_name',
'                and xx.action_date = bb.dd)',
'        Loop',
'                update dct_employees_list2',
'                set password = emp.user_key',
'                where user_name = emp.USER_NAME;',
'        End Loop;',
'End Loop;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(189262497900827717)
);
wwv_flow_api.component_end;
end;
/
