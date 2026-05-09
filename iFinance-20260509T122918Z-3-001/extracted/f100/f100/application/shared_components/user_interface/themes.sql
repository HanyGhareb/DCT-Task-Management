prompt --application/shared_components/user_interface/themes
begin
--   Manifest
--     THEME: 100
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_theme(
 p_id=>wwv_flow_api.id(1666658569302334)
,p_theme_id=>42
,p_theme_name=>'Universal Theme'
,p_theme_internal_name=>'UNIVERSAL_THEME'
,p_ui_type_name=>'DESKTOP'
,p_navigation_type=>'L'
,p_nav_bar_type=>'LIST'
,p_reference_id=>4070917134413059350
,p_is_locked=>false
,p_default_page_template=>wwv_flow_api.id(1566604861302260)
,p_default_dialog_template=>wwv_flow_api.id(1562394097302258)
,p_error_template=>wwv_flow_api.id(1554403726302253)
,p_printer_friendly_template=>wwv_flow_api.id(1566604861302260)
,p_breadcrumb_display_point=>'REGION_POSITION_01'
,p_sidebar_display_point=>'REGION_POSITION_02'
,p_login_template=>wwv_flow_api.id(1554403726302253)
,p_default_button_template=>wwv_flow_api.id(1663835798302321)
,p_default_region_template=>wwv_flow_api.id(1601776079302283)
,p_default_chart_template=>wwv_flow_api.id(1601776079302283)
,p_default_form_template=>wwv_flow_api.id(1601776079302283)
,p_default_reportr_template=>wwv_flow_api.id(1601776079302283)
,p_default_tabform_template=>wwv_flow_api.id(1601776079302283)
,p_default_wizard_template=>wwv_flow_api.id(1601776079302283)
,p_default_menur_template=>wwv_flow_api.id(1611180433302287)
,p_default_listr_template=>wwv_flow_api.id(1601776079302283)
,p_default_irr_template=>wwv_flow_api.id(1599843476302282)
,p_default_report_template=>wwv_flow_api.id(1630615094302299)
,p_default_label_template=>wwv_flow_api.id(1662779496302319)
,p_default_menu_template=>wwv_flow_api.id(1665264360302322)
,p_default_calendar_template=>wwv_flow_api.id(1665392858302323)
,p_default_list_template=>wwv_flow_api.id(1647095196302309)
,p_default_nav_list_template=>wwv_flow_api.id(1658439718302316)
,p_default_top_nav_list_temp=>wwv_flow_api.id(1658439718302316)
,p_default_side_nav_list_temp=>wwv_flow_api.id(1653401660302313)
,p_default_nav_list_position=>'SIDE'
,p_default_dialogbtnr_template=>wwv_flow_api.id(1575347927302268)
,p_default_dialogr_template=>wwv_flow_api.id(1574322396302267)
,p_default_option_label=>wwv_flow_api.id(1662779496302319)
,p_default_required_label=>wwv_flow_api.id(1663065957302319)
,p_default_page_transition=>'NONE'
,p_default_popup_transition=>'NONE'
,p_default_navbar_list_template=>wwv_flow_api.id(1653097688302312)
,p_file_prefix => nvl(wwv_flow_application_install.get_static_theme_file_prefix(42),'#IMAGE_PREFIX#themes/theme_42/1.5/')
,p_files_version=>76
,p_icon_library=>'FONTAPEX'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#IMAGE_PREFIX#libraries/apex/#MIN_DIRECTORY#widget.stickyWidget#MIN#.js?v=#APEX_VERSION#',
'#THEME_IMAGES#js/theme42#MIN#.js?v=#APEX_VERSION#'))
,p_css_file_urls=>'#THEME_IMAGES#css/Core#MIN#.css?v=#APEX_VERSION#'
);
wwv_flow_api.component_end;
end;
/
