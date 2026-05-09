prompt --application/shared_components/user_interface/themes
begin
--   Manifest
--     THEME: 113
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>100034894930602818
,p_default_owner=>'PROD'
);
wwv_flow_api.create_theme(
 p_id=>wwv_flow_api.id(99822325657410788)
,p_theme_id=>42
,p_theme_name=>'Universal Theme'
,p_theme_internal_name=>'UNIVERSAL_THEME'
,p_ui_type_name=>'DESKTOP'
,p_navigation_type=>'L'
,p_nav_bar_type=>'LIST'
,p_reference_id=>4070917134413059350
,p_is_locked=>false
,p_default_page_template=>wwv_flow_api.id(99723832930410730)
,p_default_dialog_template=>wwv_flow_api.id(99707319131410724)
,p_error_template=>wwv_flow_api.id(99708893420410724)
,p_printer_friendly_template=>wwv_flow_api.id(99723832930410730)
,p_breadcrumb_display_point=>'REGION_POSITION_01'
,p_sidebar_display_point=>'REGION_POSITION_02'
,p_login_template=>wwv_flow_api.id(99708893420410724)
,p_default_button_template=>wwv_flow_api.id(99819552699410780)
,p_default_region_template=>wwv_flow_api.id(99757408152410744)
,p_default_chart_template=>wwv_flow_api.id(99757408152410744)
,p_default_form_template=>wwv_flow_api.id(99757408152410744)
,p_default_reportr_template=>wwv_flow_api.id(99757408152410744)
,p_default_tabform_template=>wwv_flow_api.id(99757408152410744)
,p_default_wizard_template=>wwv_flow_api.id(99757408152410744)
,p_default_menur_template=>wwv_flow_api.id(99766883142410755)
,p_default_listr_template=>wwv_flow_api.id(99757408152410744)
,p_default_irr_template=>wwv_flow_api.id(99755588163410744)
,p_default_report_template=>wwv_flow_api.id(99783722631410762)
,p_default_label_template=>wwv_flow_api.id(99818469241410779)
,p_default_menu_template=>wwv_flow_api.id(99820961719410781)
,p_default_calendar_template=>wwv_flow_api.id(99821021797410782)
,p_default_list_template=>wwv_flow_api.id(99816564016410777)
,p_default_nav_list_template=>wwv_flow_api.id(99807530101410774)
,p_default_top_nav_list_temp=>wwv_flow_api.id(99807530101410774)
,p_default_side_nav_list_temp=>wwv_flow_api.id(99805970050410773)
,p_default_nav_list_position=>'SIDE'
,p_default_dialogbtnr_template=>wwv_flow_api.id(99731046805410735)
,p_default_dialogr_template=>wwv_flow_api.id(99730028608410735)
,p_default_option_label=>wwv_flow_api.id(99818469241410779)
,p_default_required_label=>wwv_flow_api.id(99818735156410779)
,p_default_page_transition=>'NONE'
,p_default_popup_transition=>'NONE'
,p_default_navbar_list_template=>wwv_flow_api.id(99808536871410775)
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
