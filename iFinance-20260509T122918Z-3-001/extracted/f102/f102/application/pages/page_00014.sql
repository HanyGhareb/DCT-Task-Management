prompt --application/pages/page_00014
begin
--   Manifest
--     PAGE: 00014
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
 p_id=>14
,p_user_interface_id=>wwv_flow_api.id(3440093928015830)
,p_name=>'HR Organization Tree'
,p_alias=>'HR-ORGANIZATION-TREE'
,p_step_title=>'HR Organization Tree'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210130100328'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(19950518915039884)
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
 p_id=>wwv_flow_api.id(19951118934039884)
,p_plug_name=>'HR Organization Tree'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select case when connect_by_isleaf = 1 then 0',
'            when level = 1             then 1',
'            else                           -1',
'       end as status,',
'       Level,',
'       title,',
'       value,',
'       tooltip,',
'        null as icon',
'--        ,''f?p=&APP_ID.:11:''||:APP_SESSION||''::::P11_ORG_ID:''||ORG_ID as link ',
',''f?p=&APP_ID.:11:''||:APP_SESSION||''::::P11_ORG_ID,P11_PAGE_FROM:''||ORG_ID||'',14'' as link ',
'from (Select ',
'        org_name,',
'        parent_org,',
'        org_id,',
'       ---- titl Definition',
'       nvl(org_level, ''no org level defined'') ||',
'       '': ''                                   ||',
'       org_name                               ||',
'       '' (''         ||',
'       (select count(d.org_id) ',
'            from organizations_v d ',
'            where d.parent_org  = ORGANIZATIONS_V.Org_id',
'            and d.status = ''A''',
'       --     and sysdate BETWEEN nvl(d.start_date,SYSDATE -120 ) and nvl(d.end_date, sysdate + 100)',
'       ) ||',
'        '') ''                ||',
'        ''Cost Center: ''     ||',
'        cost_center_code    ||',
'         Case org_level when ''Sector''  ',
'                                    Then '' - ED: '' || nvl(manager_name,''Not Defined'')',
'                         When ''Department''',
'                                    Then '' - Director: '' || nvl(manager_name,''Not Defined'')',
'                         When ''Section'' ',
'                                    Then  '' - Manager: '' || nvl(manager_name,''Not Defined'')',
'                         When ''Unit''  ',
'                                    Then   '' - Head: '' || nvl(manager_name,''Not Defined'')',
'                         Else null',
'                         End                as title,',
'       -----  End Title ------------',
'       ORG_ID                                   as value,',
'       Case org_name_en_user  when org_name_en',
'                               then ''As Defined in ADER: '' || org_name_en',
'                               else ',
'                                ''Adjusted in ifinance: '' || org_name_en_user || '', In ADERP: '' || org_name_en',
'                               End ',
'      || case DECODE(org_level_id, 2 , ''Sector'',3 ,''Department'',4 , ''Section'' ,5 , ''Unit'', ''NA'' ) when org_level_name ',
'                                then '' - No Changes in organization Level''',
'                              else',
'                                '' - There are Changes in Organozation Level in i-Finance''',
'                              End  ',
'                                as tooltip ',
'from ORGANIZATIONS_V',
'where status = ''A''',
')',
'start with "ORG_ID" in (select s.org_id  from organizations_v s where s.org_level_id = 2)',
'connect by prior ORG_ID = PARENT_ORG',
'order siblings by ORG_NAME'))
,p_plug_source_type=>'NATIVE_JSTREE'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_02=>'D'
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
 p_id=>wwv_flow_api.id(19951527700039885)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(19951118934039884)
,p_button_name=>'CONTRACT_ALL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_image_alt=>'Collapse All'
,p_button_position=>'REGION_TEMPLATE_CREATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(19952896602039888)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(19951118934039884)
,p_button_name=>'EXPAND_ALL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_id=>wwv_flow_api.id(3417513091015793)
,p_button_image_alt=>'Expand All'
,p_button_position=>'REGION_TEMPLATE_CREATE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(19951910988039887)
,p_name=>'CONTRACT_ALL'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(19951527700039885)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(19952406285039887)
,p_event_id=>wwv_flow_api.id(19951910988039887)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_TREE_COLLAPSE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(19951118934039884)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(19953282548039890)
,p_name=>'EXPAND_ALL'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(19952896602039888)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(19953704442039890)
,p_event_id=>wwv_flow_api.id(19953282548039890)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_TREE_EXPAND'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(19951118934039884)
);
wwv_flow_api.component_end;
end;
/
