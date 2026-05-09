prompt --application/pages/page_00013
begin
--   Manifest
--     PAGE: 00013
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>40620729557075005
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>13
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'Tree Page'
,p_alias=>'TREE-PAGE'
,p_step_title=>'Tree Page'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200823135658'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4732333049491721)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1611180433302287)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(1547752126302241)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(1665264360302322)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(4732921330491723)
,p_plug_name=>'Tree'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(1601776079302283)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select case when connect_by_isleaf = 1 then 0',
'            when level = 1             then 1',
'            else                           -1',
'       end as status, ',
'       level, ',
'       org_level || ',
'       '': ''      || ',
'       "ORG_NAME"   ||',
'       '' (''         ||',
'       (select count(d.org_id) ',
'            from organizations_v d ',
'            where d.parent_org  = ORGANIZATIONS_V.Org_id',
'            and d.status = ''A''',
'       --     and sysdate BETWEEN nvl(d.start_date,SYSDATE -120 ) and nvl(d.end_date, sysdate + 100)',
'       ) ||',
'        '') ''                ||',
'        ''Cost Center: ''     ||',
'        cost_center_code    as title, ',
'       null as icon, ',
'       "ORG_ID" as value, ',
'       "ORG_NAME" as tooltip, ',
'       null as link ',
'from ORGANIZATIONS_V',
'--where org_level = ''Sector''',
'start with "ORG_ID" in (select s.org_id  from organizations_v s where s.org_level_id = 2)',
'connect by prior "ORG_ID" = "PARENT_ORG"',
'order siblings by "ORG_NAME"'))
,p_plug_source_type=>'NATIVE_JSTREE'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_02=>'S'
,p_attribute_04=>'DB'
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
 p_id=>wwv_flow_api.id(4733347318491723)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(4732921330491723)
,p_button_name=>'CONTRACT_ALL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_image_alt=>'Collapse All'
,p_button_position=>'REGION_TEMPLATE_CREATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(4734646947491730)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(4732921330491723)
,p_button_name=>'EXPAND_ALL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_id=>wwv_flow_api.id(1663835798302321)
,p_button_image_alt=>'Expand All'
,p_button_position=>'REGION_TEMPLATE_CREATE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4733735244491728)
,p_name=>'CONTRACT_ALL'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(4733347318491723)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4734257294491730)
,p_event_id=>wwv_flow_api.id(4733735244491728)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_TREE_COLLAPSE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(4732921330491723)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4735017259491732)
,p_name=>'EXPAND_ALL'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(4734646947491730)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4735562276491733)
,p_event_id=>wwv_flow_api.id(4735017259491732)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_TREE_EXPAND'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(4732921330491723)
);
wwv_flow_api.component_end;
end;
/
