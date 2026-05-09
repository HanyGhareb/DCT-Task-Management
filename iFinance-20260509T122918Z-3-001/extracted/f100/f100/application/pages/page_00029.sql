prompt --application/pages/page_00029
begin
--   Manifest
--     PAGE: 00029
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
 p_id=>29
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'All ADERP Users Accounts'
,p_alias=>'ALL-ADERP-USERS-ACCOUNTS'
,p_step_title=>'All ADERP Users Accounts'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_api.id(1688862454302373)
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20211111091741'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47170544440861263)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1611180433302287)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(1547752126302241)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(1665264360302322)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47171106854861263)
,p_plug_name=>'All ADERP Users Accounts'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1599843476302282)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>6
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PERSON_ID,',
'       USERNAME,',
'       PASSWORD,',
'       CHANGED',
'       ,LAST_UPDATE_ON',
'       ,email',
'       , ''<span aria-hidden="true" class="fa fa-mail-forward fa-2x fam-information fam-is-success"></span>'' Sync',
'  from ADERP_USERS',
' where CHANGED = ''Y''',
' AND PERSON_ID = NVL(:P29_PERSON_ID , PERSON_ID)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_PERSON_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'All ADERP Users Accounts'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(47171212578861263)
,p_name=>'All ADERP Users Accounts'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>47171212578861263
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47171606307861266)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47172004229861266)
,p_db_column_name=>'USERNAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Username'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47172499093861266)
,p_db_column_name=>'PASSWORD'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Password'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47172828611861266)
,p_db_column_name=>'CHANGED'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Changed'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(47163835489840303)
,p_db_column_name=>'LAST_UPDATE_ON'
,p_display_order=>14
,p_column_identifier=>'E'
,p_column_label=>'Last Update On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46653880540245740)
,p_db_column_name=>'EMAIL'
,p_display_order=>24
,p_column_identifier=>'F'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(46654707843245749)
,p_db_column_name=>'SYNC'
,p_display_order=>34
,p_column_identifier=>'I'
,p_column_label=>'Sync'
,p_column_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.::P30_PERSON_ID:#PERSON_ID#'
,p_column_linktext=>'#SYNC#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(47174010611869940)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'471741'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PERSON_ID:USERNAME:PASSWORD:CHANGED:LAST_UPDATE_ON:EMAIL:SYNC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(47209792043872302)
,p_plug_name=>'Filter'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>4
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(47209950297872304)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(47209792043872302)
,p_button_name=>'Go'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Go'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(47209828474872303)
,p_name=>'P29_PERSON_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(47209792043872302)
,p_prompt=>'Person ID'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(1662565247302319)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(46654832868245750)
,p_name=>'Closed Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(47171106854861263)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(47209677482872301)
,p_event_id=>wwv_flow_api.id(46654832868245750)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(47171106854861263)
);
wwv_flow_api.component_end;
end;
/
