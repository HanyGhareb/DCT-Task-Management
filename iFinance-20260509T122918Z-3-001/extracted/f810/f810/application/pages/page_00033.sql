prompt --application/pages/page_00033
begin
--   Manifest
--     PAGE: 00033
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>33
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'SAP Employees  Data Load Results'
,p_alias=>'SAP-EMPLOYEES-DATA-LOAD-RESULTS'
,p_step_title=>'SAP Employees  Data Load Results'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* apply u-Report--dataLoad CSS class to Data Load Report and hide empty columns */',
'apex.jQuery("table.standardLook").addClass("u-Report u-Report--standardLook");',
'apex.jQuery("table.u-Report--standardLook tr:nth-child(1) td:empty").css("display", "none");',
'apex.jQuery("table.u-Report--standardLook tr th:empty").css("display", "none");',
'apex.jQuery("table.u-Report--standardLook tr th:empty").each( function (idx, elem) { apex.jQuery("table.u-Report--standardLook tr td[headers=\""+apex.jQuery(elem).attr(''id'')+"\"]").css("display", "none");});'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220714071257'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3249586121379239)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12908155528762118)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12844716791762062)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12962203224762162)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3250278056379239)
,p_plug_name=>'Data Load Wizard Progress'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(3200588400379296)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12938025336762142)
,p_translate_title=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3250590160379238)
,p_plug_name=>'SAP Employees  Data Load Results'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_region_attributes=>'style="width:100%;max-width:none;"'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(3252987437379237)
,p_name=>'Failed Records'
,p_template=>wwv_flow_api.id(12898750262762112)
,p_display_sequence=>20
,p_region_css_classes=>'data-upload-result'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_region_attributes=>'style="width:100%;max-width:none;" '
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select n001 as row_num,',
'       wwv_flow_lang.system_message( ''DATA_LOAD.'' || c049 ) as action,',
'       c048 as error,',
'       c001, c002, c003,',
'       c004, c005, c006,',
'       c007, c008, c009,',
'       c010, c011, c012,',
'       c013, c014, c015,',
'       c016, c017, c018,',
'       c019, c020, c021,',
'       c022, c023, c024,',
'       c025, c026, c027,',
'       c028, c029, c030,',
'       c031, c032, c033,',
'       c034, c035, c036,',
'       c037, c038, c039,',
'       c040, c041, c042,',
'       c043, c044, c045',
'  from apex_collections',
' where collection_name = ''LOAD_CONTENT''',
'   and c047 in (''FAILED'') ',
' order by seq_id'))
,p_display_when_condition=>'P33_ERROR_COUNT'
,p_display_condition_type=>'ITEM_NOT_NULL_OR_ZERO'
,p_query_headings=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare  ',
'    l_string varchar(32667);',
'begin',
'    l_string := wwv_flow_lang.system_message(''DATA_LOAD.SEQUENCE_ACTION'');',
'    l_string := l_string ||'':''|| wwv_flow_lang.system_message(''ERROR'');',
'    for l_heading in ( select c005 as label',
'                         from apex_collections',
'                        where collection_name = ''LOAD_COL_HEAD''',
'                        order by seq_id )',
'    loop',
'        l_string := l_string || '':'' || l_heading.label;',
'    end loop;',
'    return l_string;',
'end;'))
,p_query_headings_type=>'FUNCTION_BODY_RETURNING_COLON_DELIMITED_LIST'
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'no data found'
,p_query_num_rows_type=>'ROW_RANGES_IN_SELECT_LIST'
,p_query_row_count_max=>500
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3253665217379235)
,p_query_column_id=>1
,p_column_alias=>'ROW_NUM'
,p_column_display_sequence=>1
,p_column_heading=>'ROW_NUM'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3254075667379235)
,p_query_column_id=>2
,p_column_alias=>'ACTION'
,p_column_display_sequence=>2
,p_column_heading=>'ACTION'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3254484658379235)
,p_query_column_id=>3
,p_column_alias=>'ERROR'
,p_column_display_sequence=>3
,p_column_heading=>'ERROR'
,p_display_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3254895630379234)
,p_query_column_id=>4
,p_column_alias=>'C001'
,p_column_display_sequence=>4
,p_column_heading=>'C001'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3255299120379234)
,p_query_column_id=>5
,p_column_alias=>'C002'
,p_column_display_sequence=>5
,p_column_heading=>'C002'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3255670763379234)
,p_query_column_id=>6
,p_column_alias=>'C003'
,p_column_display_sequence=>6
,p_column_heading=>'C003'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3256032075379234)
,p_query_column_id=>7
,p_column_alias=>'C004'
,p_column_display_sequence=>7
,p_column_heading=>'C004'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3256503638379234)
,p_query_column_id=>8
,p_column_alias=>'C005'
,p_column_display_sequence=>8
,p_column_heading=>'C005'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3256889918379233)
,p_query_column_id=>9
,p_column_alias=>'C006'
,p_column_display_sequence=>9
,p_column_heading=>'C006'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3257262270379233)
,p_query_column_id=>10
,p_column_alias=>'C007'
,p_column_display_sequence=>10
,p_column_heading=>'C007'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3257654359379233)
,p_query_column_id=>11
,p_column_alias=>'C008'
,p_column_display_sequence=>11
,p_column_heading=>'C008'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3258048389379233)
,p_query_column_id=>12
,p_column_alias=>'C009'
,p_column_display_sequence=>12
,p_column_heading=>'C009'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3258497143379233)
,p_query_column_id=>13
,p_column_alias=>'C010'
,p_column_display_sequence=>13
,p_column_heading=>'C010'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3258884007379233)
,p_query_column_id=>14
,p_column_alias=>'C011'
,p_column_display_sequence=>14
,p_column_heading=>'C011'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3259281224379232)
,p_query_column_id=>15
,p_column_alias=>'C012'
,p_column_display_sequence=>15
,p_column_heading=>'C012'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3259722012379232)
,p_query_column_id=>16
,p_column_alias=>'C013'
,p_column_display_sequence=>16
,p_column_heading=>'C013'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3260043428379232)
,p_query_column_id=>17
,p_column_alias=>'C014'
,p_column_display_sequence=>17
,p_column_heading=>'C014'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3260476065379232)
,p_query_column_id=>18
,p_column_alias=>'C015'
,p_column_display_sequence=>18
,p_column_heading=>'C015'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3260877031379232)
,p_query_column_id=>19
,p_column_alias=>'C016'
,p_column_display_sequence=>19
,p_column_heading=>'C016'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3261289543379232)
,p_query_column_id=>20
,p_column_alias=>'C017'
,p_column_display_sequence=>20
,p_column_heading=>'C017'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3261702814379231)
,p_query_column_id=>21
,p_column_alias=>'C018'
,p_column_display_sequence=>21
,p_column_heading=>'C018'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3262075192379231)
,p_query_column_id=>22
,p_column_alias=>'C019'
,p_column_display_sequence=>22
,p_column_heading=>'C019'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3262430235379231)
,p_query_column_id=>23
,p_column_alias=>'C020'
,p_column_display_sequence=>23
,p_column_heading=>'C020'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3262830412379231)
,p_query_column_id=>24
,p_column_alias=>'C021'
,p_column_display_sequence=>24
,p_column_heading=>'C021'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3263289788379231)
,p_query_column_id=>25
,p_column_alias=>'C022'
,p_column_display_sequence=>25
,p_column_heading=>'C022'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3263667608379230)
,p_query_column_id=>26
,p_column_alias=>'C023'
,p_column_display_sequence=>26
,p_column_heading=>'C023'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3264060322379230)
,p_query_column_id=>27
,p_column_alias=>'C024'
,p_column_display_sequence=>27
,p_column_heading=>'C024'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3264508822379230)
,p_query_column_id=>28
,p_column_alias=>'C025'
,p_column_display_sequence=>28
,p_column_heading=>'C025'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3264920406379230)
,p_query_column_id=>29
,p_column_alias=>'C026'
,p_column_display_sequence=>29
,p_column_heading=>'C026'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3265309104379230)
,p_query_column_id=>30
,p_column_alias=>'C027'
,p_column_display_sequence=>30
,p_column_heading=>'C027'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3265678099379230)
,p_query_column_id=>31
,p_column_alias=>'C028'
,p_column_display_sequence=>31
,p_column_heading=>'C028'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3266121692379229)
,p_query_column_id=>32
,p_column_alias=>'C029'
,p_column_display_sequence=>32
,p_column_heading=>'C029'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3266451810379229)
,p_query_column_id=>33
,p_column_alias=>'C030'
,p_column_display_sequence=>33
,p_column_heading=>'C030'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3266877884379229)
,p_query_column_id=>34
,p_column_alias=>'C031'
,p_column_display_sequence=>34
,p_column_heading=>'C031'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3267232394379229)
,p_query_column_id=>35
,p_column_alias=>'C032'
,p_column_display_sequence=>35
,p_column_heading=>'C032'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3267713455379229)
,p_query_column_id=>36
,p_column_alias=>'C033'
,p_column_display_sequence=>36
,p_column_heading=>'C033'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3268072375379229)
,p_query_column_id=>37
,p_column_alias=>'C034'
,p_column_display_sequence=>37
,p_column_heading=>'C034'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3268484321379228)
,p_query_column_id=>38
,p_column_alias=>'C035'
,p_column_display_sequence=>38
,p_column_heading=>'C035'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3268882120379228)
,p_query_column_id=>39
,p_column_alias=>'C036'
,p_column_display_sequence=>39
,p_column_heading=>'C036'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3269289761379228)
,p_query_column_id=>40
,p_column_alias=>'C037'
,p_column_display_sequence=>40
,p_column_heading=>'C037'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3269651121379228)
,p_query_column_id=>41
,p_column_alias=>'C038'
,p_column_display_sequence=>41
,p_column_heading=>'C038'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3270026959379228)
,p_query_column_id=>42
,p_column_alias=>'C039'
,p_column_display_sequence=>42
,p_column_heading=>'C039'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3270451491379227)
,p_query_column_id=>43
,p_column_alias=>'C040'
,p_column_display_sequence=>43
,p_column_heading=>'C040'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3270846035379227)
,p_query_column_id=>44
,p_column_alias=>'C041'
,p_column_display_sequence=>44
,p_column_heading=>'C041'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3271311064379227)
,p_query_column_id=>45
,p_column_alias=>'C042'
,p_column_display_sequence=>45
,p_column_heading=>'C042'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3271650291379227)
,p_query_column_id=>46
,p_column_alias=>'C043'
,p_column_display_sequence=>46
,p_column_heading=>'C043'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3272100589379227)
,p_query_column_id=>47
,p_column_alias=>'C044'
,p_column_display_sequence=>47
,p_column_heading=>'C044'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3272483238379227)
,p_query_column_id=>48
,p_column_alias=>'C045'
,p_column_display_sequence=>48
,p_column_heading=>'C045'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(3273158319379226)
,p_name=>'Records Changed by Another User.'
,p_template=>wwv_flow_api.id(12898750262762112)
,p_display_sequence=>30
,p_region_css_classes=>'data-upload-result'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_region_attributes=>'style="width:100%;max-width:none;" '
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select n001 as row_num,',
'       wwv_flow_lang.system_message( ''DATA_LOAD.'' || c049 ) as action,',
'       c048 as error,',
'       c001, c002, c003,',
'       c004, c005, c006,',
'       c007, c008, c009,',
'       c010, c011, c012,',
'       c013, c014, c015,',
'       c016, c017, c018,',
'       c019, c020, c021,',
'       c022, c023, c024,',
'       c025, c026, c027,',
'       c028, c029, c030,',
'       c031, c032, c033,',
'       c034, c035, c036,',
'       c037, c038, c039,',
'       c040, c041, c042,',
'       c043, c044, c045',
'  from apex_collections',
' where collection_name = ''LOAD_CONTENT''',
'   and c049 in (''REVIEW'') ',
' order by seq_id'))
,p_display_when_condition=>'P33_REVIEW_COUNT'
,p_display_condition_type=>'ITEM_NOT_NULL_OR_ZERO'
,p_query_headings=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare  ',
'    l_string varchar(32667);',
'begin',
'    l_string := wwv_flow_lang.system_message(''DATA_LOAD.SEQUENCE_ACTION'');',
'    l_string := l_string ||'':''|| wwv_flow_lang.system_message(''ERROR'');',
'    for l_heading in ( select c005 as label',
'                         from apex_collections',
'                        where collection_name = ''LOAD_COL_HEAD''',
'                        order by seq_id )',
'    loop',
'        l_string := l_string || '':'' || l_heading.label;',
'    end loop;',
'    return l_string;',
'end;'))
,p_query_headings_type=>'FUNCTION_BODY_RETURNING_COLON_DELIMITED_LIST'
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'no data found'
,p_query_num_rows_type=>'ROW_RANGES_IN_SELECT_LIST'
,p_query_row_count_max=>500
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3273874137379223)
,p_query_column_id=>1
,p_column_alias=>'ROW_NUM'
,p_column_display_sequence=>1
,p_column_heading=>'ROW_NUM'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3274230311379223)
,p_query_column_id=>2
,p_column_alias=>'ACTION'
,p_column_display_sequence=>2
,p_column_heading=>'ACTION'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3274645942379223)
,p_query_column_id=>3
,p_column_alias=>'ERROR'
,p_column_display_sequence=>3
,p_column_heading=>'ERROR'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3275052121379223)
,p_query_column_id=>4
,p_column_alias=>'C001'
,p_column_display_sequence=>4
,p_column_heading=>'C001'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3275504580379223)
,p_query_column_id=>5
,p_column_alias=>'C002'
,p_column_display_sequence=>5
,p_column_heading=>'C002'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3275895385379222)
,p_query_column_id=>6
,p_column_alias=>'C003'
,p_column_display_sequence=>6
,p_column_heading=>'C003'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3276233600379222)
,p_query_column_id=>7
,p_column_alias=>'C004'
,p_column_display_sequence=>7
,p_column_heading=>'C004'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3276624602379222)
,p_query_column_id=>8
,p_column_alias=>'C005'
,p_column_display_sequence=>8
,p_column_heading=>'C005'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3277028418379222)
,p_query_column_id=>9
,p_column_alias=>'C006'
,p_column_display_sequence=>9
,p_column_heading=>'C006'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3277433706379222)
,p_query_column_id=>10
,p_column_alias=>'C007'
,p_column_display_sequence=>10
,p_column_heading=>'C007'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3277840733379222)
,p_query_column_id=>11
,p_column_alias=>'C008'
,p_column_display_sequence=>11
,p_column_heading=>'C008'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3278260133379221)
,p_query_column_id=>12
,p_column_alias=>'C009'
,p_column_display_sequence=>12
,p_column_heading=>'C009'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3278671177379221)
,p_query_column_id=>13
,p_column_alias=>'C010'
,p_column_display_sequence=>13
,p_column_heading=>'C010'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3279061059379221)
,p_query_column_id=>14
,p_column_alias=>'C011'
,p_column_display_sequence=>14
,p_column_heading=>'C011'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3279496425379221)
,p_query_column_id=>15
,p_column_alias=>'C012'
,p_column_display_sequence=>15
,p_column_heading=>'C012'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3279894203379221)
,p_query_column_id=>16
,p_column_alias=>'C013'
,p_column_display_sequence=>16
,p_column_heading=>'C013'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3280288082379220)
,p_query_column_id=>17
,p_column_alias=>'C014'
,p_column_display_sequence=>17
,p_column_heading=>'C014'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3280651758379220)
,p_query_column_id=>18
,p_column_alias=>'C015'
,p_column_display_sequence=>18
,p_column_heading=>'C015'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3281066548379220)
,p_query_column_id=>19
,p_column_alias=>'C016'
,p_column_display_sequence=>19
,p_column_heading=>'C016'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3281424166379220)
,p_query_column_id=>20
,p_column_alias=>'C017'
,p_column_display_sequence=>20
,p_column_heading=>'C017'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3281915139379220)
,p_query_column_id=>21
,p_column_alias=>'C018'
,p_column_display_sequence=>21
,p_column_heading=>'C018'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3282320728379220)
,p_query_column_id=>22
,p_column_alias=>'C019'
,p_column_display_sequence=>22
,p_column_heading=>'C019'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3282693110379219)
,p_query_column_id=>23
,p_column_alias=>'C020'
,p_column_display_sequence=>23
,p_column_heading=>'C020'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3283123282379219)
,p_query_column_id=>24
,p_column_alias=>'C021'
,p_column_display_sequence=>24
,p_column_heading=>'C021'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3283439513379219)
,p_query_column_id=>25
,p_column_alias=>'C022'
,p_column_display_sequence=>25
,p_column_heading=>'C022'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3283893769379219)
,p_query_column_id=>26
,p_column_alias=>'C023'
,p_column_display_sequence=>26
,p_column_heading=>'C023'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3284302697379219)
,p_query_column_id=>27
,p_column_alias=>'C024'
,p_column_display_sequence=>27
,p_column_heading=>'C024'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3284647198379218)
,p_query_column_id=>28
,p_column_alias=>'C025'
,p_column_display_sequence=>28
,p_column_heading=>'C025'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3285066339379218)
,p_query_column_id=>29
,p_column_alias=>'C026'
,p_column_display_sequence=>29
,p_column_heading=>'C026'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3285430348379218)
,p_query_column_id=>30
,p_column_alias=>'C027'
,p_column_display_sequence=>30
,p_column_heading=>'C027'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3285824521379218)
,p_query_column_id=>31
,p_column_alias=>'C028'
,p_column_display_sequence=>31
,p_column_heading=>'C028'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3286227283379218)
,p_query_column_id=>32
,p_column_alias=>'C029'
,p_column_display_sequence=>32
,p_column_heading=>'C029'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3286663077379218)
,p_query_column_id=>33
,p_column_alias=>'C030'
,p_column_display_sequence=>33
,p_column_heading=>'C030'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3287056780379217)
,p_query_column_id=>34
,p_column_alias=>'C031'
,p_column_display_sequence=>34
,p_column_heading=>'C031'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3287458196379217)
,p_query_column_id=>35
,p_column_alias=>'C032'
,p_column_display_sequence=>35
,p_column_heading=>'C032'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3287879434379217)
,p_query_column_id=>36
,p_column_alias=>'C033'
,p_column_display_sequence=>36
,p_column_heading=>'C033'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3288242923379217)
,p_query_column_id=>37
,p_column_alias=>'C034'
,p_column_display_sequence=>37
,p_column_heading=>'C034'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3288700570379217)
,p_query_column_id=>38
,p_column_alias=>'C035'
,p_column_display_sequence=>38
,p_column_heading=>'C035'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3289112036379217)
,p_query_column_id=>39
,p_column_alias=>'C036'
,p_column_display_sequence=>39
,p_column_heading=>'C036'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3289471867379216)
,p_query_column_id=>40
,p_column_alias=>'C037'
,p_column_display_sequence=>40
,p_column_heading=>'C037'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3289900220379216)
,p_query_column_id=>41
,p_column_alias=>'C038'
,p_column_display_sequence=>41
,p_column_heading=>'C038'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3290271175379216)
,p_query_column_id=>42
,p_column_alias=>'C039'
,p_column_display_sequence=>42
,p_column_heading=>'C039'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3290687905379216)
,p_query_column_id=>43
,p_column_alias=>'C040'
,p_column_display_sequence=>43
,p_column_heading=>'C040'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3291117609379216)
,p_query_column_id=>44
,p_column_alias=>'C041'
,p_column_display_sequence=>44
,p_column_heading=>'C041'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3291493459379215)
,p_query_column_id=>45
,p_column_alias=>'C042'
,p_column_display_sequence=>45
,p_column_heading=>'C042'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3291863139379215)
,p_query_column_id=>46
,p_column_alias=>'C043'
,p_column_display_sequence=>46
,p_column_heading=>'C043'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3292241839379215)
,p_query_column_id=>47
,p_column_alias=>'C044'
,p_column_display_sequence=>47
,p_column_heading=>'C044'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3292690748379215)
,p_query_column_id=>48
,p_column_alias=>'C045'
,p_column_display_sequence=>48
,p_column_heading=>'C045'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3251014452379238)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(3250590160379238)
,p_button_name=>'FINISH'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12960857103762161)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Finish'
,p_button_position=>'REGION_TEMPLATE_NEXT'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(3164122068269170)
,p_branch_name=>'Go to 34'
,p_branch_action=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3251457311379238)
,p_name=>'P33_INSERT_COUNT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3250590160379238)
,p_prompt=>'Inserted Row(s):'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_input=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3251910580379238)
,p_name=>'P33_UPDATE_COUNT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(3250590160379238)
,p_prompt=>'Updated Row(s):'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_input=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3252234892379238)
,p_name=>'P33_ERROR_COUNT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(3250590160379238)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Failed Row(s):'
,p_source=>'select count(*) c from apex_collections where collection_name = ''LOAD_CONTENT'' and c047 = ''FAILED'''
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_input=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3252681386379238)
,p_name=>'P33_REVIEW_COUNT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(3250590160379238)
,p_prompt=>'To be Reviewed Row(s):'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_input=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3160279513269132)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Merge Into SF_Employees'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Begin',
'',
'-- To Merge SF_EMPLOYEES_UPLOAD into SF_EMPLOYEES while upload',
'',
'MERGE into sf_employees sf USING',
'            sf_employees_upload sfu ON',
'           (sf.SF_ID = sfu.SF_ID)',
'  WHEN NOT MATCHED THEN',
'            INSERT (',
'                    sf.sf_id,',
'                    sf.oracle_id,',
'                    sf.employee_name,',
'                    sf.name_arabic,',
'                    sf.hire_date,',
'                    sf.grade,',
'                    sf.job_title,',
'                    sf.position_arabic,',
'                    sf.payroll_area,',
'                    sf.contract_type,  --10',
'                    sf.sector,',
'                    sf.sector_arabic,',
'                    sf.department,',
'                    sf.department_arabic,',
'                    sf.section,',
'                    sf.section_arabic,',
'                    sf.unit,',
'                    sf.unit_arabic,',
'                    sf.location,',
'                    sf.supervisor_name, --10',
'                    sf.gender,',
'                    sf.gender_arabic,',
'                    sf.nationality_type,',
'                    sf.nationality,',
'                    sf.nationality_arabic,',
'                    sf.marital_status,',
'                    sf.emirates_id,',
'                    sf.email_address,',
'                    sf.mobile_phone_number      --9',
') VALUES (',
'                    sfu.sf_id,',
'                    sfu.oracle_id,',
'                    sfu.employee_name,',
'                    sfu.name_arabic,',
'                    sfu.hire_date,',
'                    sfu.grade,',
'                    sfu.job_title,',
'                    sfu.position_arabic,',
'                    sfu.payroll_area,',
'                    sfu.contract_type,      --10',
'                    sfu.sector,',
'                    sfu.sector_arabic,',
'                    sfu.department,',
'                    sfu.department_arabic,',
'                    sfu.section,',
'                    sfu.section_arabic,',
'                    sfu.unit,',
'                    sfu.unit_arabic,',
'                    sfu.location,',
'                    sfu.supervisor_name,    --10',
'                    sfu.gender,             ',
'                    sfu.gender_arabic,',
'                    sfu.nationality_type,',
'                    sfu.nationality,',
'                    sfu.nationality_arabic,',
'                    sfu.marital_status,',
'                    sfu.emirates_id,',
'                    sfu.email_address,',
'                    sfu.mobile_phone_number',
')',
'',
'WHEN MATCHED THEN',
'     ',
'     UPDATE SET',
'                    ',
'                    sf.oracle_id = sfu.oracle_id,',
'                    sf.employee_name = sfu.employee_name,',
'                    sf.name_arabic = sfu.name_arabic,',
'                    sf.hire_date =  sfu.hire_date,',
'                    sf.grade  =  sfu.grade,',
'                    sf.job_title = sfu.job_title,',
'                    sf.position_arabic = sfu.position_arabic,',
'                    sf.payroll_area = sfu.payroll_area,',
'                    sf.contract_type = sfu.contract_type,',
'                    sf.sector = sfu.sector,',
'                    sf.sector_arabic = sfu.sector_arabic,',
'                    sf.department = sfu.department,',
'                    sf.department_arabic = sfu.department_arabic,',
'                    sf.section = sfu.section,',
'                    sf.section_arabic = sfu.section_arabic,',
'                    sf.unit = sfu.unit,',
'                    sf.unit_arabic = sfu.unit_arabic,',
'                    sf.location= sfu.location,',
'                    sf.supervisor_name = sfu.supervisor_name,',
'                    sf.gender = sfu.gender,',
'                    sf.gender_arabic = sfu.gender_arabic,',
'                    sf.nationality_type = sfu.nationality_type,',
'                    sf.nationality = sfu.nationality,',
'                    sf.nationality_arabic = sfu.nationality_arabic,',
'                    sf.marital_status =  sfu.marital_status,',
'                    sf.emirates_id =  sfu.emirates_id,',
'                    sf.email_address = sfu.email_address, ',
'                    sf.mobile_phone_number  = sfu.mobile_phone_number',
';',
'',
'',
'delete from sf_employees_upload;',
'',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(3251014452379238)
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3160332144269133)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'merge Direct Hire Employees'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Begin',
'-- to merge Direct Hire Employees',
'',
'for emp in (select SF_ID, ORACLE_ID, PAYROLL_AREA, CONTRACT_TYPE, LOCATION, EMAIL_ADDRESS , grade, JOB_TITLE, HIRE_DATE, NAME_ARABIC,',
'                   EMPLOYEE_NAME, NATIONALITY_TYPE, EMIRATES_ID, NATIONALITY, MOBILE_PHONE_NUMBER',
'             from sf_employees',
'            where ORACLE_ID is not null)',
'Loop',
'    update dct_employees_list2 e',
'    set e.sf_number = emp.sf_id,',
'        e.sf_payroll_area = emp.payroll_area,',
'        e.sf_contract_type = emp.contract_type,',
'        e.sf_location = emp.location,',
'        e.sf_email = emp.EMAIL_ADDRESS,',
'        e.SF_GRADE = emp.grade,',
'        e.SF_JOB_TITLE = emp.JOB_TITLE,',
'        e.SF_HIRE_DATE = emp.HIRE_DATE,',
'        e.SF_NAME_ARABIC = emp.NAME_ARABIC,',
'        e.SF_EMPLOYEE_NAME = emp.EMPLOYEE_NAME,',
'        e.SF_NATIONALITY_TYPE = emp.NATIONALITY_TYPE,',
'        e.SF_EMIRATES_ID = emp.EMIRATES_ID,',
'        e.SF_NATIONALITY = emp.NATIONALITY,',
'        e.SF_MOBILE_PHONE_NUMBER = emp.MOBILE_PHONE_NUMBER',
'        ',
'    where e.employee_num = emp.ORACLE_ID;',
'    ',
'  --  DBMS_OUTPUT.put_line(''Done for '' || emp.ORACLE_ID);',
'End loop;',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(3251014452379238)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3161763357269147)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Freelancers - Non_Payroll'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'merge into dct_employees_list2 e Using',
'               ( SELECT',
'                    sf_id,',
'                    EMPLOYEE_NAME,',
'                    NAME_ARABIC,',
'                    HIRE_DATE,',
'                    GRADE,',
'                    JOB_TITLE,                  ',
'                    payroll_area,',
'                    contract_type,                  ',
'                    location,',
'                    email_address,',
'                    NATIONALITY_TYPE,',
'                    NATIONALITY,',
'                    EMIRATES_ID,',
'                    MOBILE_PHONE_NUMBER,',
'                    GENDER',
'            FROM   sf_employees',
'            WHERE   payroll_area = ''Non-Payroll''',
'            and     email_address is not null)  emp ON',
'               (e.SF_NUMBER = emp.sf_id ',
'--               and sf.payroll_area = ''Non-Payroll''',
'                 )',
'    when Not MATCHED Then',
'        Insert (',
'    employee_num,       --sf_id',
'    person_id,',
'    full_name_en,       -- EMPLOYEE_NAME',
'    full_name_ar,       -- NAME_ARABIC',
'    national_identifier,    -- EMIRATES_ID',
'    sex,                    -- GENDER',
'--    marital_status,',
'    hire_date,            -- HIRE_DATE  ',
'    email,                -- email_address  ',
'--    location_id,',
'    current_flag,           -- ''Y''',
'    primary_flag,           -- ''Y''',
'    user_name,              -- ''SF'' || sf_number',
'    email_user,             -- email_address',
'    mobile_user,            -- MOBILE_PHONE_NUMBER',
'    account_status,         --  ''A''',
'    source,                 -- ''SAP''',
'    location_id_user,       -- null',
'    sf_number,              -- sf_id',
'    email_account,          -- lower(SUBSTR(EMAIL_ADDRESS,1,INSTRB(EMAIL_ADDRESS,''@'')-1))',
'    email_domain,           -- lower(SUBSTR(EMAIL_ADDRESS,INSTRB(EMAIL_ADDRESS,''@'') + 1))',
'    sf_payroll_area,        -- payroll_area',
'    sf_contract_type,       -- contract_type',
'    sf_location,            -- location',
'    sf_email,               -- email_address',
'    sf_grade,               -- GRADE',
'    sf_job_title,           -- JOB_TITLE',
'    sf_hire_date,           -- HIRE_DATE',
'    sf_name_arabic,         -- NAME_ARABIC',
'    sf_employee_name,       -- EMPLOYEE_NAME',
'    sf_NATIONALITY_TYPE,    -- NATIONALITY_TYPE',
'    ',
'    sf_NATIONALITY,         -- NATIONALITY',
'    sf_EMIRATES_ID,          -- EMIRATES_ID',
'--    mobile_user ,',
'    SF_MOBILE_PHONE_NUMBER',
'    ) ',
'VALUES',
'    (',
'    emp.sf_id,',
'    DCT_EMPLOYEES_LIST2_SEQ.nextval,',
'    emp.EMPLOYEE_NAME,',
'    emp.NAME_ARABIC,',
'    emp.EMIRATES_ID,',
'    substr(emp.GENDER,1,1),',
'--    marital_status,',
'    emp.HIRE_DATE  ,',
'    emp.email_address  ,',
'--    location_id,',
'    ''Y'',',
'    ''Y'',',
'    ''SF'' || emp.sf_id,',
'    emp.email_address,',
'    emp.MOBILE_PHONE_NUMBER,',
'    ''A'',',
'    ''SAP'',',
'    null,',
'    emp.sf_id,',
'    lower(SUBSTR(emp.EMAIL_ADDRESS,1,INSTRB(emp.EMAIL_ADDRESS,''@'')-1)),',
'    lower(SUBSTR(emp.EMAIL_ADDRESS,INSTRB(emp.EMAIL_ADDRESS,''@'') + 1)),',
'    emp.payroll_area,',
'    emp.contract_type,',
'    emp.location,',
'    emp.email_address,',
'    emp.GRADE,',
'    emp.JOB_TITLE,',
'    emp.HIRE_DATE,',
'    emp.NAME_ARABIC,',
'    emp.EMPLOYEE_NAME,',
'    emp.NATIONALITY_TYPE,',
'    emp.NATIONALITY,',
'    emp.EMIRATES_ID,',
'    emp.MOBILE_PHONE_NUMBER',
'    ',
'    )',
'    ',
'WHEN MATCHED THEN',
'     ',
'     UPDATE SET',
'',
'    employee_num = emp.sf_id,',
'--    person_id,',
'    full_name_en =  emp.EMPLOYEE_NAME,',
'    full_name_ar =  emp.NAME_ARABIC,',
'    national_identifier = emp.EMIRATES_ID,',
'    sex =  substr(emp.GENDER,1,1),',
'--    marital_status,',
'    hire_date =  emp.HIRE_DATE , ',
'    email  =  emp.email_address , ',
'--    location_id,',
'--    current_flag,           -- ''Y''',
'--    primary_flag,           -- ''Y''',
'    user_name =  ''SF'' || emp.sf_id ,',
'    email_user =  emp.email_address,',
'    mobile_user =  emp.MOBILE_PHONE_NUMBER,',
'--    account_status,         --  ''A''',
'    source = ''SAP'' ,',
'--    location_id_user,       -- null',
'',
'    email_account       = lower(SUBSTR(emp.EMAIL_ADDRESS,1,INSTRB(emp.EMAIL_ADDRESS,''@'')-1)),',
'    email_domain        = lower(SUBSTR(emp.EMAIL_ADDRESS,INSTRB(emp.EMAIL_ADDRESS,''@'') + 1)),',
'    sf_payroll_area     = emp.PAYROLL_AREA,',
'    sf_contract_type    = emp.CONTRACT_TYPE,',
'    sf_location         = emp.LOCATION,',
'    sf_email            = emp.EMAIL_ADDRESS,',
'    sf_grade            = emp.GRADE,',
'    sf_job_title        = emp.JOB_TITLE,',
'    sf_hire_date        = emp.HIRE_DATE,',
'    sf_name_arabic      = emp.NAME_ARABIC,',
'    sf_employee_name    = emp.EMPLOYEE_NAME,',
'    sf_NATIONALITY_TYPE = emp.NATIONALITY_TYPE,',
'    ',
'    sf_NATIONALITY      = emp.NATIONALITY,',
'    SF_EMIRATES_ID      = emp.EMIRATES_ID,',
'    SF_MOBILE_PHONE_NUMBER = emp.MOBILE_PHONE_NUMBER;',
'',
'',
'',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(3251014452379238)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3164329564269173)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Outsource - Exists in oracle '
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Begin',
'',
'for emp in ( SELECT',
'                    sf_id,',
'                    EMPLOYEE_NAME,',
'                    NAME_ARABIC,',
'                    HIRE_DATE,',
'                    GRADE,',
'                    JOB_TITLE,                  ',
'                    payroll_area,',
'                    contract_type,                  ',
'                    location,',
'                    email_address,',
'                    NATIONALITY_TYPE,',
'                    NATIONALITY,',
'                    EMIRATES_ID,',
'                    MOBILE_PHONE_NUMBER,',
'                    GENDER',
'            FROM   sf_employees sf',
'            WHERE   EXISTS (select * from dct_employees_list2 e where lower(SUBSTR(sf.EMAIL_ADDRESS,1,INSTRB(sf.EMAIL_ADDRESS,''@'')-1)) = lower(SUBSTR(e.EMAIL,1,INSTRB(e.EMAIL,''@'')-1)))',
'            and payroll_area not in (''Non-Payroll'' , ''DCT Payroll'' , ''LAD direct Hires'')',
'            and email_address is null)',
' LOOP',
'    UPDATE dct_employees_list2',
'    SET',
'    email_user =  emp.email_address,',
'    mobile_user =  emp.MOBILE_PHONE_NUMBER,',
'    sf_payroll_area     = emp.PAYROLL_AREA,',
'    sf_contract_type    = emp.CONTRACT_TYPE,',
'    sf_location         = emp.LOCATION,',
'    sf_email            = emp.EMAIL_ADDRESS,',
'    sf_grade            = emp.GRADE,',
'    sf_job_title        = emp.JOB_TITLE,',
'    sf_hire_date        = emp.HIRE_DATE,',
'    sf_name_arabic      = emp.NAME_ARABIC,',
'    sf_employee_name    = emp.EMPLOYEE_NAME,',
'    sf_NATIONALITY_TYPE = emp.NATIONALITY_TYPE,',
'    ',
'    sf_NATIONALITY      = emp.NATIONALITY,',
'    SF_EMIRATES_ID      = emp.EMIRATES_ID,',
'    SF_MOBILE_PHONE_NUMBER = emp.MOBILE_PHONE_NUMBER',
'where lower(SUBSTR(emp.EMAIL_ADDRESS,1,INSTRB(emp.EMAIL_ADDRESS,''@'')-1)) = lower(SUBSTR(EMAIL,1,INSTRB(EMAIL,''@'')-1));',
'',
'--DBMS_OUTPUT.PUT_LINE(''Updating '' || emp.EMPLOYEE_NAME );',
'',
'End LOOP;',
'',
'End;',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(3251014452379238)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(4164246940042824)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Outsource - NOT Exists in oracle '
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Begin',
'',
'    merge into dct_employees_list2 e using ',
'    (SELECT',
'                    sf_id,',
'                    EMPLOYEE_NAME,',
'                    NAME_ARABIC,',
'                    HIRE_DATE,',
'                    GRADE,',
'                    JOB_TITLE,                  ',
'                    payroll_area,',
'                    contract_type,                  ',
'                    location,',
'                    email_address,',
'                    NATIONALITY_TYPE,',
'                    NATIONALITY,',
'                    EMIRATES_ID,',
'                    MOBILE_PHONE_NUMBER,',
'                    GENDER',
'            FROM   sf_employees sf',
'            WHERE  Not EXISTS (select * from dct_employees_list2 e where lower(SUBSTR(sf.EMAIL_ADDRESS,1,INSTRB(sf.EMAIL_ADDRESS,''@'')-1)) = lower(SUBSTR(e.EMAIL,1,INSTRB(e.EMAIL,''@'')-1)))',
'            and payroll_area not in (''Non-Payroll'' , ''DCT Payroll'' , ''LAD direct Hires'')',
'            and email_address is not null ',
'    ) sf ON',
'    (lower(SUBSTR(sf.EMAIL_ADDRESS,1,INSTRB(sf.EMAIL_ADDRESS,''@'')-1)) = lower(SUBSTR(e.EMAIL,1,INSTRB(e.EMAIL,''@'')-1)))',
' when Not MATCHED Then ',
'    Insert (    ',
'    person_id,',
'    FULL_NAME_EN,',
'    FULL_NAME_AR,    ',
'    employee_num,',
'    current_flag,',
'    primary_flag,',
'    user_name,',
'    supervisor_num_user,',
'    email_user,',
'    mobile_user,',
'    account_status,',
'    source,',
'    sf_number,',
'    email_account,',
'    email_domain,',
'    sf_payroll_area,',
'    sf_contract_type,',
'    sf_location,',
'    sf_email,',
'    sf_grade,',
'    sf_job_title,',
'    sf_hire_date,',
'    sf_name_arabic,',
'    sf_employee_name,',
'    sf_nationality_type,',
'    sf_emirates_id,',
'    sf_nationality,',
'    sf_mobile_phone_number)',
'    VALUES',
'    (   DCT_EMPLOYEES_LIST2_SEQ.nextval,',
'        sf.EMPLOYEE_NAME,',
'        sf.NAME_ARABIC,',
'        sf.sf_id, ',
'        ''Y'',',
'        ''Y'', ',
'        ''SF''||sf.sf_id,',
'        null,',
'        sf.email_address,',
'        sf.MOBILE_PHONE_NUMBER,',
'        ''A'',',
'        ''SAP'',',
'        sf.sf_id,',
'        lower(SUBSTR(sf.EMAIL_ADDRESS,1,INSTRB(sf.EMAIL_ADDRESS,''@'')-1)),',
'        lower(SUBSTR(sf.EMAIL_ADDRESS,INSTRB(sf.EMAIL_ADDRESS,''@'') + 1)),',
'        sf.payroll_area,',
'        sf.contract_type,',
'        sf.location,',
'        sf.email_address,',
'        sf.GRADE,',
'        sf.JOB_TITLE,',
'        sf.HIRE_DATE,',
'        sf.NAME_ARABIC,',
'        sf.EMPLOYEE_NAME,',
'        sf.NATIONALITY_TYPE, ',
'        sf.EMIRATES_ID, ',
'        sf.NATIONALITY, ',
'        sf.MOBILE_PHONE_NUMBER',
'    )',
'',
'    ',
'WHEN MATCHED THEN',
'     ',
'     UPDATE SET    ',
'    email_user          = sf.email_address,',
'    FULL_NAME_EN        = sf.EMPLOYEE_NAME,',
'    FULL_NAME_AR        = sf.NAME_ARABIC,  ',
'    mobile_user         = sf.MOBILE_PHONE_NUMBER,',
'    sf_payroll_area     = sf.PAYROLL_AREA,',
'    sf_contract_type    = sf.CONTRACT_TYPE,',
'    sf_location         = sf.LOCATION,',
'    sf_email            = sf.EMAIL_ADDRESS,',
'    sf_grade            = sf.GRADE,',
'    sf_job_title        = sf.JOB_TITLE,',
'    sf_hire_date        = sf.HIRE_DATE,',
'    sf_name_arabic      = sf.NAME_ARABIC,',
'    sf_employee_name    = sf.EMPLOYEE_NAME,',
'    sf_NATIONALITY_TYPE = sf.NATIONALITY_TYPE,',
'    sf_NATIONALITY      = sf.NATIONALITY,',
'    SF_EMIRATES_ID      = sf.EMIRATES_ID,',
'    SF_MOBILE_PHONE_NUMBER = sf.MOBILE_PHONE_NUMBER',
'where lower(SUBSTR(sf.EMAIL_ADDRESS,1,INSTRB(sf.EMAIL_ADDRESS,''@'')-1)) = lower(SUBSTR(e.EMAIL,1,INSTRB(e.EMAIL,''@'')-1));',
'',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(3251014452379238)
);
wwv_flow_api.component_end;
end;
/
