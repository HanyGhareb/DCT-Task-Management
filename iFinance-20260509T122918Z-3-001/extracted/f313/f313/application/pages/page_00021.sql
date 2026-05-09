prompt --application/pages/page_00021
begin
--   Manifest
--     PAGE: 00021
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>145171879539529295
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>21
,p_user_interface_id=>wwv_flow_api.id(24631887413319249)
,p_name=>'TAC Meetings Calendar'
,p_alias=>'TAC-MEETINGS-CALENDAR'
,p_step_title=>'TAC Meetings Calendar'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210926104459'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(176018695538472)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24556678455319312)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(24493261337319361)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(24610734179319274)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(176586094538470)
,p_plug_name=>'TAC Meetings Calendar'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--accent15:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(24547287062319317)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select m.ID  ,',
'       m.MEETING_NUMBER || '' - ('' || ',
'       (select count(*)',
'       from tac_meeting_agenda x',
'       where x.meeting_id = m.id)',
'       || '')'' Meetings,',
'       m.METTING_DATE,',
'       m.PREPARED_PERSON_ID,',
'       m.NOTES,',
'       m.CREATED_BY_PERSON_ID,',
'       m.CREATED_ON,',
'       m.UPDATED_BY_PERSON_ID,',
'       m.UPDATED_ON,',
'       m.COMMITTEE_TYPE',
'  from TAC_MEETINGS m'))
,p_plug_source_type=>'NATIVE_CSS_CALENDAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'METTING_DATE'
,p_attribute_03=>'MEETINGS'
,p_attribute_04=>'ID'
,p_attribute_05=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:22:P22_ID:&ID.'
,p_attribute_06=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:22:P22_METTING_DATE:&APEX$NEW_START_DATE.'
,p_attribute_07=>'Y'
,p_attribute_08=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    update tac_meetings',
'       set metting_date = to_date(:APEX$NEW_START_DATE, ''YYYYMMDDHH24MISS'')',
'     where id = :APEX$PK_VALUE;',
'end;'))
,p_attribute_11=>'month:week:day:list:navigation'
,p_attribute_13=>'Y'
,p_attribute_16=>'&NOTES.'
,p_attribute_17=>'Y'
,p_attribute_18=>'00'
,p_attribute_19=>'Y'
,p_attribute_20=>'8'
,p_attribute_21=>'10'
,p_attribute_22=>'Y'
);
wwv_flow_api.component_end;
end;
/
