prompt --application/create_application
begin
--   Manifest
--     FLOW: 901
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>123
,p_default_id_offset=>6039605030667831
,p_default_owner=>'DEV'
);
wwv_flow_api.create_flow(
 p_id=>wwv_flow.g_flow_id
,p_owner=>nvl(wwv_flow_application_install.get_schema,'DEV')
,p_name=>nvl(wwv_flow_application_install.get_application_name,'HRSS')
,p_alias=>nvl(wwv_flow_application_install.get_application_alias,'HRSS')
,p_application_group=>7432707517191967
,p_application_group_name=>'ifinance'
,p_application_group_comment=>'i-Finance Group Application'
,p_page_view_logging=>'YES'
,p_page_protection_enabled_y_n=>'Y'
,p_checksum_salt=>'FDEAE2F721AB7B76276B4F74C754A4E394A3055B34E386353FE8A83E81F101F6'
,p_bookmark_checksum_function=>'SH512'
,p_compatibility_mode=>'19.2'
,p_flow_language=>'en'
,p_flow_language_derived_from=>'FLOW_PRIMARY_LANGUAGE'
,p_allow_feedback_yn=>'Y'
,p_date_format=>'DS'
,p_timestamp_format=>'DS'
,p_timestamp_tz_format=>'DS'
,p_direction_right_to_left=>'N'
,p_flow_image_prefix => nvl(wwv_flow_application_install.get_image_prefix,'')
,p_documentation_banner=>'Application created from create application wizard 2020.05.25.'
,p_authentication=>'PLUGIN'
,p_authentication_id=>wwv_flow_api.id(8155980356181922)
,p_application_tab_set=>0
,p_logo_type=>'IT'
,p_logo=>'#APP_IMAGES#app-54293-logo(1).png'
,p_logo_text=>'<cite>i<b>finance - Petty Cash Management</b></cite>'
,p_app_builder_icon_name=>'app-icon.svg'
,p_public_user=>'APEX_PUBLIC_USER'
,p_proxy_server=>nvl(wwv_flow_application_install.get_proxy,'')
,p_no_proxy_domains=>nvl(wwv_flow_application_install.get_no_proxy_domains,'')
,p_flow_version=>'Release 1.0'
,p_flow_status=>'AVAILABLE_W_EDIT_LINK'
,p_flow_unavailable_text=>'This application is currently unavailable at this time.'
,p_exact_substitutions_only=>'Y'
,p_browser_cache=>'N'
,p_browser_frame=>'D'
,p_rejoin_existing_sessions=>'N'
,p_csv_encoding=>'Y'
,p_auto_time_zone=>'N'
,p_substitution_string_01=>'APP_NAME'
,p_substitution_value_01=>'HRSS'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200915194705'
,p_file_prefix => nvl(wwv_flow_application_install.get_static_app_file_prefix,'')
,p_files_version=>4
,p_ui_type_name => null
);
wwv_flow_api.component_end;
end;
/
