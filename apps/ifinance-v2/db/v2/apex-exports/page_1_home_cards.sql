prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.15'
,p_default_workspace_id=>9249752073687531
,p_default_application_id=>200
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
end;
/
 
prompt APPLICATION 200 - i-Finance
--
-- Application Export:
--   Application:     200
--   Name:            i-Finance
--   Exported By:     ADMIN
--   Flashback:       0
--   Export Type:     Page Export
--   Manifest
--     PAGE: 1
--   Manifest End
--   Version:         24.2.15
--   Instance ID:     9249559497612069
--

begin
null;
end;
/
prompt --application/pages/delete_00001
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>1);
end;
/
prompt --application/pages/page_00001
begin
wwv_flow_imp_page.create_page(
 p_id=>1
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'i-Finance'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'13'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9294324700537040)
,p_plug_name=>'i-Finance'
,p_region_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'Y'
,p_plug_template=>2674017834225413037
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_query_num_rows=>15
,p_region_image=>'#APP_FILES#icons/app-icon-512.png'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9325507223594404)
,p_plug_name=>'App Launcher'
,p_title=>'App Launcher'
,p_parent_plug_id=>wwv_flow_imp.id(9294324700537040)
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT m.module_id,',
'       m.module_name_en                             AS title,',
'       m.module_name_ar                             AS subtitle,',
'       m.description_en                             AS body_text,',
'       m.icon_class                                 AS icon_css_classes,',
'       CASE',
'         WHEN m.app_url IS NOT NULL',
'           THEN m.app_url',
'         WHEN m.apex_app_id IS NOT NULL',
'           THEN APEX_PAGE.GET_URL(',
'                  p_application => m.apex_app_id,',
'                  p_page        => NVL(m.apex_page_id, 1))',
'         ELSE NULL',
'       END                                          AS module_url,',
'       CASE WHEN m.is_new_tab = ''Y''',
'            THEN ''target="_blank"''',
'            ELSE NULL',
'       END                                          AS link_attrs,',
'       m.category',
'FROM   dct_modules m',
'WHERE  m.is_active = ''Y''',
'  AND (',
'        m.is_admin_only = ''N''',
'     OR EXISTS (',
'          SELECT 1',
'          FROM   dct_user_roles  ur',
'          JOIN   dct_module_roles mr ON mr.role_id = ur.role_id',
'          WHERE  ur.user_id  = (SELECT user_id FROM dct_users WHERE username = :APP_USER)',
'          AND    ur.is_active = ''Y''',
'          AND    (ur.end_date IS NULL OR ur.end_date >= SYSDATE)',
'          AND    mr.module_id = m.module_id',
'       )',
'      )',
'ORDER BY m.display_order, m.module_name_en'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>false
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(9325613838594405)
,p_region_id=>wwv_flow_imp.id(9325507223594404)
,p_layout_type=>'GRID'
,p_title_adv_formatting=>false
,p_title_column_name=>'TITLE'
,p_sub_title_adv_formatting=>false
,p_sub_title_column_name=>'SUBTITLE'
,p_body_adv_formatting=>false
,p_body_column_name=>'BODY_TEXT'
,p_second_body_adv_formatting=>false
,p_icon_source_type=>'STATIC_CLASS'
,p_icon_css_classes=>'#ICON_CSS_CLASSES#'
,p_icon_position=>'START'
,p_media_adv_formatting=>false
,p_pk1_column_name=>'MODULE_ID'
);
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(9325741544594406)
,p_card_id=>wwv_flow_imp.id(9325613838594405)
,p_action_type=>'BUTTON'
,p_position=>'PRIMARY'
,p_display_sequence=>10
,p_label=>'Full Card'
,p_link_target_type=>'REDIRECT_URL'
,p_link_target=>'#MODULE_URL#'
,p_button_display_type=>'TEXT'
,p_is_hot=>false
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done



PL/SQL procedure successfully completed.

