prompt --application/pages/page_00006
begin
--   Manifest
--     PAGE: 00006
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>6
,p_user_interface_id=>wwv_flow_api.id(3440093928015830)
,p_name=>'Tree Page'
,p_alias=>'TREE-PAGE'
,p_step_title=>'Tree Page'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200808142629'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3649161754142394)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(3364880770015750)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(3301434120015688)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(3418914725015794)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3649790730142395)
,p_plug_name=>'Tree'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select case when connect_by_isleaf = 1 then 0',
'            when level = 1             then 1',
'            else                           -1',
'       end as status, ',
'       level, ',
'       "FULL_NAME_EN" as title, ',
'       null as icon, ',
'       "PERSON_ID" as value, ',
'       ''This is My Tooltip'' as tooltip, ',
'       null as link ',
'from "#OWNER#"."EMPLOYEES_V"',
'start with "SUPERVISOR_NUM" is null',
'connect by prior "PERSON_ID" = "SUPERVISOR_NUM"',
'order siblings by "FULL_NAME_EN"'))
,p_plug_source_type=>'NATIVE_JSTREE'
,p_plug_query_no_data_found=>'No data found.'
,p_attribute_02=>'S'
,p_attribute_04=>'STATIC'
,p_attribute_05=>'This is My Tooltip'
,p_attribute_07=>'APEX_TREE'
,p_attribute_08=>'a-Icon'
,p_attribute_09=>'icon-tree-folder'
,p_attribute_10=>'TITLE'
,p_attribute_11=>'LEVEL'
,p_attribute_12=>'ICON'
,p_attribute_15=>'STATUS'
,p_attribute_20=>'VALUE'
,p_attribute_22=>'TOOLTIP'
,p_attribute_23=>'LEVEL'
,p_attribute_24=>'LINK'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3650143458142396)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(3649790730142395)
,p_button_name=>'CONTRACT_ALL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_image_alt=>'Collapse All'
,p_button_position=>'REGION_TEMPLATE_CREATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3651410799142404)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(3649790730142395)
,p_button_name=>'EXPAND_ALL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_image_alt=>'Expand All'
,p_button_position=>'REGION_TEMPLATE_CREATE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3650581828142402)
,p_name=>'CONTRACT_ALL'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3650143458142396)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3651019632142404)
,p_event_id=>wwv_flow_api.id(3650581828142402)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_TREE_COLLAPSE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(3649790730142395)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3651827499142406)
,p_name=>'EXPAND_ALL'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3651410799142404)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3652337340142407)
,p_event_id=>wwv_flow_api.id(3651827499142406)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_TREE_EXPAND'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(3649790730142395)
);
wwv_flow_api.component_end;
end;
/
