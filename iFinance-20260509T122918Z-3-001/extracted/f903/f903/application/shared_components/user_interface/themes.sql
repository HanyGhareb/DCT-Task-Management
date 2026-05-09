prompt --application/shared_components/user_interface/themes
begin
--   Manifest
--     THEME: 903
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_theme(
 p_id=>wwv_flow_api.id(65603730945255797)
,p_theme_id=>42
,p_theme_name=>'Universal Theme'
,p_theme_internal_name=>'UNIVERSAL_THEME'
,p_ui_type_name=>'DESKTOP'
,p_navigation_type=>'L'
,p_nav_bar_type=>'LIST'
,p_reference_id=>4070917134413059350
,p_is_locked=>false
,p_default_page_template=>wwv_flow_api.id(65513403179255734)
,p_default_dialog_template=>wwv_flow_api.id(65498453377255725)
,p_error_template=>wwv_flow_api.id(65499940675255726)
,p_printer_friendly_template=>wwv_flow_api.id(65513403179255734)
,p_breadcrumb_display_point=>'REGION_POSITION_01'
,p_sidebar_display_point=>'REGION_POSITION_02'
,p_login_template=>wwv_flow_api.id(65499940675255726)
,p_default_button_template=>wwv_flow_api.id(65600970359255785)
,p_default_region_template=>wwv_flow_api.id(65544848715255753)
,p_default_chart_template=>wwv_flow_api.id(65544848715255753)
,p_default_form_template=>wwv_flow_api.id(65544848715255753)
,p_default_reportr_template=>wwv_flow_api.id(65544848715255753)
,p_default_tabform_template=>wwv_flow_api.id(65544848715255753)
,p_default_wizard_template=>wwv_flow_api.id(65544848715255753)
,p_default_menur_template=>wwv_flow_api.id(65554277731255756)
,p_default_listr_template=>wwv_flow_api.id(65544848715255753)
,p_default_irr_template=>wwv_flow_api.id(65543737550255752)
,p_default_report_template=>wwv_flow_api.id(65567986443255766)
,p_default_label_template=>wwv_flow_api.id(65599536546255781)
,p_default_menu_template=>wwv_flow_api.id(65602363670255785)
,p_default_calendar_template=>wwv_flow_api.id(65602499073255787)
,p_default_list_template=>wwv_flow_api.id(65597976446255780)
,p_default_nav_list_template=>wwv_flow_api.id(65589380618255777)
,p_default_top_nav_list_temp=>wwv_flow_api.id(65589380618255777)
,p_default_side_nav_list_temp=>wwv_flow_api.id(65588347540255776)
,p_default_nav_list_position=>'SIDE'
,p_default_dialogbtnr_template=>wwv_flow_api.id(65520625267255744)
,p_default_dialogr_template=>wwv_flow_api.id(65519636948255743)
,p_default_option_label=>wwv_flow_api.id(65599536546255781)
,p_default_required_label=>wwv_flow_api.id(65599642313255782)
,p_default_page_transition=>'NONE'
,p_default_popup_transition=>'NONE'
,p_default_navbar_list_template=>wwv_flow_api.id(65590365019255777)
,p_file_prefix => nvl(wwv_flow_application_install.get_static_theme_file_prefix(42),'#IMAGE_PREFIX#themes/theme_42/1.3/')
,p_files_version=>62
,p_icon_library=>'FONTAPEX'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#IMAGE_PREFIX#libraries/apex/#MIN_DIRECTORY#widget.stickyWidget#MIN#.js?v=#APEX_VERSION#',
'#THEME_IMAGES#js/theme42#MIN#.js?v=#APEX_VERSION#'))
,p_css_file_urls=>'#THEME_IMAGES#css/Core#MIN#.css?v=#APEX_VERSION#'
);
wwv_flow_api.component_end;
end;
/
