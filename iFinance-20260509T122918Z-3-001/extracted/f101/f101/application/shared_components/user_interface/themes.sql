prompt --application/shared_components/user_interface/themes
begin
--   Manifest
--     THEME: 101
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_theme(
 p_id=>wwv_flow_api.id(8122711108175539)
,p_theme_id=>42
,p_theme_name=>'Universal Theme'
,p_theme_internal_name=>'UNIVERSAL_THEME'
,p_ui_type_name=>'DESKTOP'
,p_navigation_type=>'L'
,p_nav_bar_type=>'LIST'
,p_reference_id=>4070917134413059350
,p_is_locked=>false
,p_default_page_template=>wwv_flow_api.id(8024217844175495)
,p_default_dialog_template=>wwv_flow_api.id(8007788145175489)
,p_error_template=>wwv_flow_api.id(8009295700175490)
,p_printer_friendly_template=>wwv_flow_api.id(8024217844175495)
,p_breadcrumb_display_point=>'REGION_POSITION_01'
,p_sidebar_display_point=>'REGION_POSITION_02'
,p_login_template=>wwv_flow_api.id(8009295700175490)
,p_default_button_template=>wwv_flow_api.id(8119922506175532)
,p_default_region_template=>wwv_flow_api.id(8057862405175507)
,p_default_chart_template=>wwv_flow_api.id(8057862405175507)
,p_default_form_template=>wwv_flow_api.id(8057862405175507)
,p_default_reportr_template=>wwv_flow_api.id(8057862405175507)
,p_default_tabform_template=>wwv_flow_api.id(8057862405175507)
,p_default_wizard_template=>wwv_flow_api.id(8057862405175507)
,p_default_menur_template=>wwv_flow_api.id(8067277693175509)
,p_default_listr_template=>wwv_flow_api.id(8057862405175507)
,p_default_irr_template=>wwv_flow_api.id(8055912915175506)
,p_default_report_template=>wwv_flow_api.id(8084165237175515)
,p_default_label_template=>wwv_flow_api.id(8118554792175530)
,p_default_menu_template=>wwv_flow_api.id(8121335853175533)
,p_default_calendar_template=>wwv_flow_api.id(8121469407175534)
,p_default_list_template=>wwv_flow_api.id(8116971789175529)
,p_default_nav_list_template=>wwv_flow_api.id(8107930070175526)
,p_default_top_nav_list_temp=>wwv_flow_api.id(8107930070175526)
,p_default_side_nav_list_temp=>wwv_flow_api.id(8106307755175525)
,p_default_nav_list_position=>'SIDE'
,p_default_dialogbtnr_template=>wwv_flow_api.id(8031419283175499)
,p_default_dialogr_template=>wwv_flow_api.id(8030481219175499)
,p_default_option_label=>wwv_flow_api.id(8118554792175530)
,p_default_required_label=>wwv_flow_api.id(8118641726175531)
,p_default_page_transition=>'NONE'
,p_default_popup_transition=>'NONE'
,p_default_navbar_list_template=>wwv_flow_api.id(8108974615175526)
,p_file_prefix => nvl(wwv_flow_application_install.get_static_theme_file_prefix(42),'#IMAGE_PREFIX#themes/theme_42/1.5/')
,p_files_version=>64
,p_icon_library=>'FONTAPEX'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#IMAGE_PREFIX#libraries/apex/#MIN_DIRECTORY#widget.stickyWidget#MIN#.js?v=#APEX_VERSION#',
'#THEME_IMAGES#js/theme42#MIN#.js?v=#APEX_VERSION#'))
,p_css_file_urls=>'#THEME_IMAGES#css/Core#MIN#.css?v=#APEX_VERSION#'
);
wwv_flow_api.component_end;
end;
/
