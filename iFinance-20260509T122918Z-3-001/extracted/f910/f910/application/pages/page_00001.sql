prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'i-finance'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200920045202'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1697198465302398)
,p_plug_name=>'i-finance Home'
,p_icon_css_classes=>'app-icon'
,p_region_template_options=>'#DEFAULT#:t-HeroRegion--hideIcon'
,p_plug_template=>wwv_flow_api.id(1592170296302278)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_source=>'Smart Finance Solution'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(4167429088848401)
,p_name=>'Home Menu'
,p_template=>wwv_flow_api.id(1601776079302283)
,p_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:u-colors:t-Cards--displaySubtitle:t-Cards--featured t-Cards--block force-fa-lg:t-Cards--displayIcons:t-Cards--5cols:t-Cards--animColorFill'
,p_display_point=>'REGION_POSITION_01'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'       CARD_TITLE,',
'       CARD_SUBTITLE,',
'       CARD_TEXT,',
'       CARD_SUBTEXT,',
'       nvl(CARD_MODIFIERS,''ss'') CARD_MODIFIERS,',
'       APP_ID,',
'       PAGE_ID,',
'       apex_page.get_url(  p_application  =>  APP_ID , p_page   =>  PAGE_ID  )    CARD_LINK,',
'       CARD_COLOR,',
'       CARD_ICON,',
'       CARD_INITIALS,',
'       STATUS,',
'       DESCRIPTION,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY',
'  from MENUS m',
'  where m.menu_id in (  select mr.menu_id ',
'                        from MENU_ROLES mr',
'                        where mr.menu_id = m.menu_id',
'                        and mr.role_id in (SELECT entity_id',
'                                            FROM DCT_DATA_ACCESS_ASSIGNMENT',
'                                            where user_id = :APP_USER',
'                                            and entity_type_id = ''ROLE'')',
'                        and mr.status = ''A'')',
'  order by order_no;'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(1617641641302292)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4169659294848423)
,p_query_column_id=>1
,p_column_alias=>'CARD_TITLE'
,p_column_display_sequence=>1
,p_column_heading=>'Card Title'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4169788318848424)
,p_query_column_id=>2
,p_column_alias=>'CARD_SUBTITLE'
,p_column_display_sequence=>2
,p_column_heading=>'Card Subtitle'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4169873776848425)
,p_query_column_id=>3
,p_column_alias=>'CARD_TEXT'
,p_column_display_sequence=>3
,p_column_heading=>'Card Text'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4169974066848426)
,p_query_column_id=>4
,p_column_alias=>'CARD_SUBTEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Card Subtext'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4170099404848427)
,p_query_column_id=>5
,p_column_alias=>'CARD_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Card Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5067995645045109)
,p_query_column_id=>6
,p_column_alias=>'APP_ID'
,p_column_display_sequence=>10
,p_column_heading=>'App Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5068004203045110)
,p_query_column_id=>7
,p_column_alias=>'PAGE_ID'
,p_column_display_sequence=>11
,p_column_heading=>'Page Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5067839930045108)
,p_query_column_id=>8
,p_column_alias=>'CARD_LINK'
,p_column_display_sequence=>9
,p_column_heading=>'Card Link'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4170249198848429)
,p_query_column_id=>9
,p_column_alias=>'CARD_COLOR'
,p_column_display_sequence=>6
,p_column_heading=>'Card Color'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4170334883848430)
,p_query_column_id=>10
,p_column_alias=>'CARD_ICON'
,p_column_display_sequence=>7
,p_column_heading=>'Card Icon'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(4170489240848431)
,p_query_column_id=>11
,p_column_alias=>'CARD_INITIALS'
,p_column_display_sequence=>8
,p_column_heading=>'Card Initials'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5068176465045111)
,p_query_column_id=>12
,p_column_alias=>'STATUS'
,p_column_display_sequence=>12
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5068240437045112)
,p_query_column_id=>13
,p_column_alias=>'DESCRIPTION'
,p_column_display_sequence=>13
,p_column_heading=>'Description'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5068389393045113)
,p_query_column_id=>14
,p_column_alias=>'CREATED'
,p_column_display_sequence=>14
,p_column_heading=>'Created'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5068432478045114)
,p_query_column_id=>15
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>15
,p_column_heading=>'Created By'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5068535673045115)
,p_query_column_id=>16
,p_column_alias=>'UPDATED'
,p_column_display_sequence=>16
,p_column_heading=>'Updated'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5068626092045116)
,p_query_column_id=>17
,p_column_alias=>'UPDATED_BY'
,p_column_display_sequence=>17
,p_column_heading=>'Updated By'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(7950097388144835)
,p_branch_name=>'Go To Change Password'
,p_branch_action=>'f?p=&APP_ID.:9996:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_HEADER'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'FUNCTION_BODY'
,p_branch_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_change    varchar2(1);',
'begin',
'',
'select change_password',
'into l_change',
'from dct_employees_list2',
'where user_name = :APP_USER;',
'',
'    if l_change = ''Y'' then',
'        return true;',
'    else',
'        return false;',
'    end if;',
'end;'))
);
wwv_flow_api.component_end;
end;
/
