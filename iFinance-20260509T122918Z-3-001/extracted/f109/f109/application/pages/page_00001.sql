prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(11217697745956116)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'CWIP Payment - Ex'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210903122722'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11234250784956164)
,p_plug_name=>'Home'
,p_icon_css_classes=>'fa-home'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(11123406100956043)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11301590709956246)
,p_plug_name=>'Page Navigation'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:u-colors:t-Cards--featured t-Cards--block force-fa-lg:t-Cards--displayIcons:t-Cards--4cols:t-Cards--hideBody:t-Cards--animColorFill'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(11105666197956032)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(11300817337956245)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(11184563974956082)
,p_plug_query_num_rows=>15
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(39724405175361315)
,p_branch_name=>'Go To Change Password'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:11::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_HEADER'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'FUNCTION_BODY'
,p_branch_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_change    varchar2(1);',
'begin',
'',
'select change_password',
'into l_change',
'from dct_ext_users',
'where user_name = :APP_USER;',
'',
'    if l_change = ''Y'' then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
);
wwv_flow_api.component_end;
end;
/
