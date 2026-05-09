prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(3440093928015830)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'HR'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210127132442'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3281906024870702)
,p_plug_name=>'Missing HR Data'
,p_region_name=>'badgeListCircular'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(3355416515015745)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- 1- List of org without Level',
'select ''No Level'' lable ',
'        , Count(*) value ',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':5:''||:APP_SESSION||''::NO::P5_SHOW:''|| ''1'' ) as link',
'from organizations_details_v',
'where org_level is null ',
'group by ''No Level''',
'UNION ALL',
'-- 2- List of org without Parent Org',
'select ''No Parent'' lable ',
'        , Count(*) value ',
'      , apex_util.prepare_url( ''f?p=''||:APP_ID||'':5:''||:APP_SESSION||''::NO::P5_SHOW:''|| ''2'' ) as link',
'from organizations_details_v',
'where parent_org_name is null',
'and org_level <> ''Agency''',
'group by  ''No Parent''',
'UNION ALL',
'--3- List of org without org Manager',
'select ''No Manager'' lable ',
'        , Count(*) value ',
'       , apex_util.prepare_url( ''f?p=''||:APP_ID||'':5:''||:APP_SESSION||''::NO::P5_SHOW:''|| ''3'' ) as link',
'from organizations_details_v',
'where manager_emp_num is NULL',
'group by  ''No Manager''',
'UNION ALL',
'--4- List of org without Director',
'select ''No Director'' lable ',
'        , Count(*) value ',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':5:''||:APP_SESSION||''::NO::P5_SHOW:''|| ''4'' ) as link',
'from organizations_details_v',
'where director_num is null',
'and org_level not in (''Sector'' , ''Director General Office'' , ''Agency'' )',
'group by  ''No Director''',
'UNION ALL',
'--5- List of org without Executive Director',
'select ''No Exec Director'' lable ',
'        , Count(*) value ',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':5:''||:APP_SESSION||''::NO::P5_SHOW:''|| ''5'' ) as link',
'from organizations_details_v',
'where executive_director_num is null',
'and org_level not in (''Director General Office'' , ''Agency'' )',
'group by  ''No Exec Director''',
'UNION ALL',
'-- 6-  List of org without FBP',
'select ''No Finance Partner'' lable ',
'        , Count(*) value ',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':5:''||:APP_SESSION||''::NO::P5_SHOW:''|| ''6'' ) as link',
'from organizations_details_v',
'where fbp_role_id is null',
'group by  ''No Finance Partner''',
'UNION ALL',
'-- 7-  Employees Without photos',
'select ''No Employee Photo'' lable ',
'        , Count(*) value ',
'        , apex_util.prepare_url( ''f?p=''||:APP_ID||'':5:''||:APP_SESSION||''::NO::P5_SHOW:''|| ''8'' ) as link',
'from dct_employees_list2',
'where photo_blob is null',
'and current_flag = ''Y''',
'group by  ''No Employee Photo'', apex_util.prepare_url( ''f?p=''||:APP_ID||'':5:''||:APP_SESSION||''::NO::P5_SHOW:''|| ''8'' )',
'',
''))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'&LINK.'
,p_attribute_05=>'0'
,p_attribute_06=>'B'
,p_attribute_07=>'DOT'
,p_attribute_08=>'Y'
,p_attribute_09=>'LABLE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3450898918015891)
,p_plug_name=>'HR'
,p_icon_css_classes=>'app-icon'
,p_region_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(3345855043015740)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_query_num_rows=>15
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'Y'
);
wwv_flow_api.component_end;
end;
/
