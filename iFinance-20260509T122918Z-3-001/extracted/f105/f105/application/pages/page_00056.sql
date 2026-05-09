prompt --application/pages/page_00056
begin
--   Manifest
--     PAGE: 00056
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>56
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'GL Chart of Accounts'
,p_alias=>'GL-CHART-OF-ACCOUNTS'
,p_step_title=>'GL Chart of Accounts'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_api.id(99715471933410727)
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230104213358'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(71632684255340704)
,p_plug_name=>'Filter By'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(71070197284421847)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99766883142410755)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(99703488427410717)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(99820961719410781)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(71069560422421848)
,p_plug_name=>'GL Chart of Accounts'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'        CC_ID,',
'       ENTITY_CODE,',
'       ENTITY_DESCRIPTION,',
'       COST_CENTER_CODE,',
'       COST_CENTER_DESCRIPTION,',
'       BUDGET_CODE,',
'       BUDGET_GROUP_DESCRIPTION,',
'       ACCOUNT_CODE,',
'       ACCOUNT_DESCRIPTION,',
'       ACTIVITY_CODE,',
'       ACTIVITY_DESCRIPTION,',
'       FUTURE1,',
'       FUTURE1_DESCRIPTION,',
'       FUTURE2,',
'       FUTURE2_DESCRIPTION,',
'       ACCOUNT_TYPE,',
'       STATUS,',
'       FULL_CODE_COMBINATION,',
'       FULL_CODE_COMBINATION_DESCRIPTION,',
'       ENTITY_ID,',
'       BUSINESS_ACTIVITY_ID,',
'       ACCOUNT_TYPE_ID,',
'       CHAPTER_ID,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       START_DATE,',
'       END_DATE,',
'       SECTOR_ID,',
'       SECTOR_NAME,',
'       DEPARTMENT_ID',
'  from GL_CODE_COMBINATIONS_V',
' -- where (CHAPTER_ID in (select * from apex_string.split(:P56_CHAPTER)) or CHAPTER_ID = CHAPTER_ID )'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'GL Chart of Accounts'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(71069442602421848)
,p_name=>'GL Chart of Accounts'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:57:&SESSION.::&DEBUG.:57:P57_GL_COMBINATION,P57_GL_COMBINATION_NAME,P57_ACCOUNT_TYPE,P57_ENTITY,P57_CHAPTER,P57_BUSINESS_ACTIVVITY,P57_ID,P57_CCID:#FULL_CODE_COMBINATION#,#FULL_CODE_COMBINATION_DESCRIPTION#,#ACCOUNT_TYPE_ID#,#ENTITY_ID#,'
||'#CHAPTER_ID#,#BUSINESS_ACTIVITY_ID#,#ID#,#CC_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>142214589786762784
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71069131999421851)
,p_db_column_name=>'CC_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71068659872421854)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71068350660421855)
,p_db_column_name=>'ENTITY_DESCRIPTION'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Entity Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71067954024421855)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71067559880421855)
,p_db_column_name=>'COST_CENTER_DESCRIPTION'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71067158919421855)
,p_db_column_name=>'BUDGET_CODE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Budget Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71066818847421855)
,p_db_column_name=>'BUDGET_GROUP_DESCRIPTION'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Budget Group Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71066356132421863)
,p_db_column_name=>'ACCOUNT_CODE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Account Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71065995212421863)
,p_db_column_name=>'ACCOUNT_DESCRIPTION'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Account Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71065614096421864)
,p_db_column_name=>'ACTIVITY_CODE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Activity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71065231244421864)
,p_db_column_name=>'ACTIVITY_DESCRIPTION'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Activity Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71064802954421864)
,p_db_column_name=>'FUTURE1'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71064391782421864)
,p_db_column_name=>'FUTURE1_DESCRIPTION'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Future1 Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71063953010421864)
,p_db_column_name=>'FUTURE2'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71063589406421864)
,p_db_column_name=>'FUTURE2_DESCRIPTION'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Future2 Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71063180310421865)
,p_db_column_name=>'ACCOUNT_TYPE'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Account Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71062800559421865)
,p_db_column_name=>'STATUS'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(780300318120911)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71062333301421865)
,p_db_column_name=>'FULL_CODE_COMBINATION'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Full Code Combination'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71062003141421866)
,p_db_column_name=>'FULL_CODE_COMBINATION_DESCRIPTION'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Full Code Combination Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71061613092421866)
,p_db_column_name=>'ENTITY_ID'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Entity'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(71071080321406157)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71061231745421866)
,p_db_column_name=>'BUSINESS_ACTIVITY_ID'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Business Activity'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(71071274690402025)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71060819880421866)
,p_db_column_name=>'ACCOUNT_TYPE_ID'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Account Type'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(71071461979398892)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71060407241421866)
,p_db_column_name=>'CHAPTER_ID'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Chapter'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(71071651503392969)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71060021987421867)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71059538985421867)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71059188330421867)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71058803147421867)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71058346121421867)
,p_db_column_name=>'START_DATE'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71058009630421867)
,p_db_column_name=>'END_DATE'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71057573070421868)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Sector'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71057159596421868)
,p_db_column_name=>'SECTOR_NAME'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Sector Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71056832374421868)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Department'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1187523989265150)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(71630596931340683)
,p_db_column_name=>'ID'
,p_display_order=>42
,p_column_identifier=>'AG'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(71046415703452524)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1422377'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'COST_CENTER_CODE:BUDGET_CODE:ACCOUNT_CODE:FUTURE2:ACCOUNT_TYPE:FULL_CODE_COMBINATION:ENTITY_BUSINESS_ACTIVITY_ACCOUNT_TYPE_CHAPTER_SECTOR_:ID'
,p_sort_column_1=>'CHAPTER_ID'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'COST_CENTER_CODE'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(71632089079340698)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(71632684255340704)
,p_button_name=>'Go'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Go'
,p_button_position=>'TOP_AND_BOTTOM'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(71632580083340703)
,p_name=>'P56_CHAPTER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(71632684255340704)
,p_prompt=>'Chapter'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'GL CHAPTERS BY NUMBERS LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 30 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(71632471729340702)
,p_name=>'P56_SECTOR'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(71632684255340704)
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'SECTORS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  NVL(SECTOR_NAME_USER , SECTOR_NAME) Name , SECTOR_ID',
'from dct_hr_sectors_v'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(71632382789340701)
,p_name=>'P56_BUSINESS_ACTIVITY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(71632684255340704)
,p_prompt=>'Business Activity'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'GL BUSINESS ACTIVITIES LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 31 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(71632243301340700)
,p_name=>'P56_ENTITY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(71632684255340704)
,p_prompt=>'Entity'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'GL ENTITIES LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 29 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(71632162823340699)
,p_name=>'P56_ACCOUNT_TYPE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(71632684255340704)
,p_prompt=>'Account Type'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'GL ACCOUNT TYPES LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 32 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'
,p_field_template=>wwv_flow_api.id(99818348479410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(71631998041340697)
,p_name=>'GO DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(71632089079340698)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(71631869329340696)
,p_event_id=>wwv_flow_api.id(71631998041340697)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(71069560422421848)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(71630636404340684)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update GL Classification Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Update dct_gl_code_combinations_classifications',
'set chapter_id = :   , ENTITY_ID = : , BUSINESS_ACTIVITY_ID = : , ACCOUNT_TYPE_ID = :',
'where ID = :CC_ID'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
