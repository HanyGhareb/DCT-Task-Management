prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>117
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(22915115765584721)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'docuements'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_api.id(22794498059584637)
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210221045309'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22929290507605305)
,p_plug_name=>unistr('Once you receive the invitation mail, Click \201CAccess i-Finance\201D button')
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(22830521940584659)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(20783692689193928)
,p_name=>'New'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20783753803193929)
,p_event_id=>wwv_flow_api.id(20783692689193928)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'EVENT_SOURCE'
,p_attribute_01=>'window.open("#WORKSPACE_IMAGES#Create New MPR.pdf#");'
);
wwv_flow_api.component_end;
end;
/
