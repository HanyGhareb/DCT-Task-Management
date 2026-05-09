prompt --application/create_application
begin
--   Manifest
--     FLOW: 903
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_flow(
 p_id=>wwv_flow.g_flow_id
,p_owner=>nvl(wwv_flow_application_install.get_schema,'DEV')
,p_name=>nvl(wwv_flow_application_install.get_application_name,'Budget Transfer')
,p_alias=>nvl(wwv_flow_application_install.get_application_alias,'BTR')
,p_page_view_logging=>'YES'
,p_page_protection_enabled_y_n=>'Y'
,p_checksum_salt=>'AA105BCA3E946B92EF8E731B9DCD5E8C8040BE5A52E863160AE8169FD98C8505'
,p_bookmark_checksum_function=>'SH512'
,p_compatibility_mode=>'19.2'
,p_flow_language=>'en'
,p_flow_language_derived_from=>'FLOW_PRIMARY_LANGUAGE'
,p_allow_feedback_yn=>'Y'
,p_direction_right_to_left=>'N'
,p_flow_image_prefix => nvl(wwv_flow_application_install.get_image_prefix,'')
,p_documentation_banner=>'Application created from create application wizard 2020.02.04.'
,p_authentication=>'PLUGIN'
,p_authentication_id=>wwv_flow_api.id(65494205807255665)
,p_application_tab_set=>1
,p_logo_type=>'IT'
,p_logo=>'#APP_IMAGES#app-54293-logo.png'
,p_logo_text=>'<cite>i<b>finance - Budget Transfers Management</b></cite>'
,p_app_builder_icon_name=>'app-icon.png'
,p_public_user=>'APEX_PUBLIC_USER'
,p_proxy_server=>nvl(wwv_flow_application_install.get_proxy,'')
,p_no_proxy_domains=>nvl(wwv_flow_application_install.get_no_proxy_domains,'')
,p_flow_version=>'Release 1.0'
,p_flow_status=>'AVAILABLE_W_EDIT_LINK'
,p_flow_unavailable_text=>'This application is currently unavailable at this time.'
,p_exact_substitutions_only=>'Y'
,p_browser_cache=>'N'
,p_browser_frame=>'D'
,p_runtime_api_usage=>'T'
,p_rejoin_existing_sessions=>'N'
,p_csv_encoding=>'Y'
,p_auto_time_zone=>'N'
,p_friendly_url=>'N'
,p_substitution_string_01=>'APP_NAME'
,p_substitution_value_01=>'Budget Transfer'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210920090623'
,p_file_prefix => nvl(wwv_flow_application_install.get_static_app_file_prefix,'')
,p_files_version=>6
,p_ui_type_name => null
);
wwv_flow_api.component_end;
end;
/
