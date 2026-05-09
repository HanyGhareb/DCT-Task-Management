prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>118
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>2
,p_user_interface_id=>wwv_flow_api.id(122997627648781606)
,p_name=>'Customers'
,p_alias=>'CUSTOMERS'
,p_step_title=>'Customers'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>To find data enter a search term into the search dialog, or click on the column headings to limit the records returned.</p>',
'',
'<p>You can perform numerous functions by clicking the <strong>Actions</strong> button. This includes selecting the columns that are displayed / hidden and their display sequence, plus numerous data and format functions.  You can also define additiona'
||'l views of the data using the chart, group by, and pivot options.</p>',
'',
'<p>If you want to save your customizations select report, or click download to unload the data. Enter you email address and time frame under subscription to be sent the data on a regular basis.<p>',
'',
'<p>For additional information click Help at the bottom of the Actions menu.</p> ',
'',
'<p>Click the <strong>Reset</strong> button to reset the interactive report back to the default settings.</p>'))
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220830041722'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(123015066667781542)
,p_plug_name=>'Customers'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(122911181767781667)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CUSTOMER_NUMBER,',
'       CUSTOMER_NAME,',
'       CUSTOMER_TYPE,',
'       EMAIL_ADDRESS,',
'       LOCATION,',
'       STATUS,',
'       ACCOUNT_NAME,',
'       ACCOUNT_NUMBER,',
'       ORGANIZATION_NAME,',
'       ORGANIZATION_NUMBER,',
'       SHORT_CODE,',
'       CUSTOMER_KEY,',
'       EMAIL_ADDRESS_USER,',
'       EMAIL_VERIFIED_YN,',
'       REPRESENTATIVE_NAME',
'  from CUSTOMERS',
'  where SHORT_CODE = ''TCA'';'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Customers'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(123015134198781542)
,p_name=>'Customers'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:3:&APP_SESSION.:::3:P3_CUSTOMER_KEY:\#CUSTOMER_KEY#\'
,p_detail_link_text=>'<span class="fa fa-edit" aria-hidden="true"></span>'
,p_detail_link_auth_scheme=>wwv_flow_api.id(123002015284781584)
,p_owner=>'TCA9051'
,p_internal_uid=>123015134198781542
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123015582340781538)
,p_db_column_name=>'CUSTOMER_NUMBER'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Customer Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123015992716781537)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Customer Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123016342075781536)
,p_db_column_name=>'CUSTOMER_TYPE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Customer Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123016772793781536)
,p_db_column_name=>'EMAIL_ADDRESS'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123017121276781536)
,p_db_column_name=>'LOCATION'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Location'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123017567256781536)
,p_db_column_name=>'STATUS'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(123262759218760199)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123017974356781536)
,p_db_column_name=>'ACCOUNT_NAME'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123018309238781535)
,p_db_column_name=>'ACCOUNT_NUMBER'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Account Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123018733311781535)
,p_db_column_name=>'ORGANIZATION_NAME'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Organization Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123019160513781535)
,p_db_column_name=>'ORGANIZATION_NUMBER'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Organization Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123020340107781534)
,p_db_column_name=>'EMAIL_ADDRESS_USER'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Email (User)'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123020776523781534)
,p_db_column_name=>'EMAIL_VERIFIED_YN'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Email Verified ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(123265630952760193)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123019578597781535)
,p_db_column_name=>'SHORT_CODE'
,p_display_order=>24
,p_column_identifier=>'K'
,p_column_label=>'Short Code'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123019924168781535)
,p_db_column_name=>'CUSTOMER_KEY'
,p_display_order=>34
,p_column_identifier=>'L'
,p_column_label=>'Customer Key'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122543477058632122)
,p_db_column_name=>'REPRESENTATIVE_NAME'
,p_display_order=>44
,p_column_identifier=>'O'
,p_column_label=>'Representative Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(123058430318781324)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1230585'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CUSTOMER_NUMBER:CUSTOMER_NAME:CUSTOMER_TYPE:EMAIL_ADDRESS:EMAIL_ADDRESS_USER:LOCATION:STATUS:ACCOUNT_NAME:ACCOUNT_NUMBER:REPRESENTATIVE_NAME:EMAIL_VERIFIED_YN:'
,p_sort_column_1=>'CUSTOMER_NUMBER'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(123021927516781531)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(122922476001781663)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(122859041536781706)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(122976593233781628)
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(123021122513781534)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(123015066667781542)
,p_button_name=>'RESET_REPORT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(122975280422781629)
,p_button_image_alt=>'Reset'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:RR::'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(123023723948781529)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(123015066667781542)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(122975103376781629)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3'
,p_button_condition_type=>'NEVER'
,p_security_scheme=>wwv_flow_api.id(123002015284781584)
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(122543527289632123)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(123015066667781542)
,p_button_name=>'Update'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(122975280422781629)
,p_button_image_alt=>'Update'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-upload'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(122545098660632138)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(123015066667781542)
,p_button_name=>'Send'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(122975280422781629)
,p_button_image_alt=>'Send'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_icon_css_classes=>'fa-envelope-check'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(123022858022781530)
,p_name=>'Edit Report - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(123015066667781542)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(123023353900781529)
,p_event_id=>wwv_flow_api.id(123022858022781530)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(123015066667781542)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(122545349092632141)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Send Email'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Begin',
'AR_REMINDERS.SEND_REMINDER_1(''451CN-2242272'');',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(122545098660632138)
,p_process_success_message=>'Send'
);
wwv_flow_api.component_end;
end;
/
