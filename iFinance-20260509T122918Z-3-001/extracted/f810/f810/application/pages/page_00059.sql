prompt --application/pages/page_00059
begin
--   Manifest
--     PAGE: 00059
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
 p_id=>59
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Invitation'
,p_alias=>'INVITATION'
,p_step_title=>'Invitation'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240103143303'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(161240631754386650)
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
 p_id=>wwv_flow_api.id(161241241177386650)
,p_plug_name=>'Invitation - Petty Cash '
,p_region_name=>'USERS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select employee_num ,',
'        title ,',
'        full_name_en     EMP_NAME,',
'        full_name_ar ,',
'        manager_flag ,',
'        supervisor_num ,',
'        org_name,',
'        org_id,',
'        Email    Email,',
'        User_Name',
'from employees_v',
'where current_flag = ''Y'''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Invitation - Petty Cash '
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(161241413675386650)
,p_name=>'Invitation - Petty Cash '
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>271852290165393627
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92700386552951090)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92700744052951090)
,p_db_column_name=>'TITLE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92701169871951090)
,p_db_column_name=>'FULL_NAME_AR'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Full Name Ar'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92701570319951090)
,p_db_column_name=>'MANAGER_FLAG'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Manager Flag'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92701975555951091)
,p_db_column_name=>'SUPERVISOR_NUM'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Supervisor Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92699171304951089)
,p_db_column_name=>'EMAIL'
,p_display_order=>17
,p_column_identifier=>'H'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92699613719951089)
,p_db_column_name=>'EMP_NAME'
,p_display_order=>27
,p_column_identifier=>'I'
,p_column_label=>'Emp Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92699926369951090)
,p_db_column_name=>'USER_NAME'
,p_display_order=>37
,p_column_identifier=>'J'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92702378978951091)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>47
,p_column_identifier=>'L'
,p_column_label=>'Org Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92702768836951091)
,p_db_column_name=>'ORG_ID'
,p_display_order=>57
,p_column_identifier=>'M'
,p_column_label=>'Org Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(161245597231415086)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2033140'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EMPLOYEE_NUM:TITLE:EMP_NAME:USER_NAME:SUPERVISOR_NUM:EMAIL:ORG_NAME:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(92704818400951095)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(161241241177386650)
,p_button_name=>'Send_Email'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Send Email'
,p_button_position=>'TOP'
,p_button_redirect_url=>'f?p=&APP_ID.:60:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(92707666785951098)
,p_name=>'Send Invitation mail'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(92704818400951095)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(92708143217951098)
,p_event_id=>wwv_flow_api.id(92707666785951098)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess( "Invitation Emails Sent Successfully." );'
);
wwv_flow_api.component_end;
end;
/
