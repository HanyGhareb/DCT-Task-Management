prompt --application/pages/page_00087
begin
--   Manifest
--     PAGE: 00087
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
 p_id=>87
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Chart of Accounts'
,p_alias=>'CHART-OF-ACCOUNTS'
,p_step_title=>'Chart of Accounts'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230418031546'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(51803455407877708)
,p_plug_name=>'Script to Bulk Update'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':PERSON_ID = 680461'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(51803367918877707)
,p_plug_name=>'Update Chapter'
,p_parent_plug_id=>wwv_flow_api.id(51803455407877708)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'MERGE INTO dct_gl_code_combinations_classifications e',
'    USING dct_gl_code_combinations_all h',
'    ON (e.cc_id = h.cc_id ',
'--            and h.ACCOUNT_CODE like ''4%''',
'            )',
'  WHEN MATCHED THEN',
'    UPDATE SET e.CHAPTER_ID = (case h.FUTURE2 when ''100103'' then ''133''',
'                                              when ''101553'' then ''133''   ',
'                                              when ''200104'' then ''134''',
'                                              when ''201554'' then ''134''',
'                                              when ''300105'' then ''135''',
'                                              when ''301439'' then ''135''',
'                                              when ''301555'' then ''135''',
'                                              when ''600232'' then ''136''',
'                                end)',
'  WHEN NOT MATCHED THEN',
'    INSERT (',
'                cc_id,',
'--                entity_id,',
'--                business_activity_id,',
'--                account_type_id,',
'                chapter_id,',
'                start_date,',
'                end_date,',
'                sector_id,',
'                department_id',
'            )',
'    VALUES ',
'            (h.cc_id, ',
'             (case h.FUTURE2 when ''100103'' then ''133''',
'                              when ''101553'' then ''133''   ',
'                              when ''200104'' then ''134''',
'                              when ''201554'' then ''134''',
'                              when ''300105'' then ''135''',
'                              when ''301439'' then ''135''',
'                              when ''301555'' then ''135''',
'                              when ''600232'' then ''136''',
'                end),',
'               sysdate,',
'               null,',
'               null,',
'               null',
'             );',
'    ',
'    ',
'    ',
'--    select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 30 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10);',
'-- update dct_gl_code_combinations_classifications set chapter_id = null;'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(51803322291877706)
,p_plug_name=>'Search'
,p_icon_css_classes=>'fa-search'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(51647475674727589)
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
 p_id=>wwv_flow_api.id(51646905297727584)
,p_plug_name=>'Chart of Accounts'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CC_ID,',
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
'       DEPARTMENT_ID,',
'       ID',
'  from GL_CODE_COMBINATIONS_V',
' where chapter_id = nvl(:P87_CHAPTER ,  chapter_id)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P87_CHAPTER'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Chart of Accounts'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(51646822677727584)
,p_name=>'Chart of Accounts'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:88:&SESSION.::&DEBUG.::P88_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>161637209711457048
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51646404867727581)
,p_db_column_name=>'CC_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Cc Id'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51645933856727580)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51645598850727580)
,p_db_column_name=>'ENTITY_DESCRIPTION'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Entity Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51645183443727580)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51644753555727579)
,p_db_column_name=>'COST_CENTER_DESCRIPTION'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Cost Center Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51644363431727579)
,p_db_column_name=>'BUDGET_CODE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Budget Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51643979229727579)
,p_db_column_name=>'BUDGET_GROUP_DESCRIPTION'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Budget Group Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51643593983727579)
,p_db_column_name=>'ACCOUNT_CODE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Account Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51643162538727579)
,p_db_column_name=>'ACCOUNT_DESCRIPTION'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Account Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51642801325727578)
,p_db_column_name=>'ACTIVITY_CODE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Activity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51642333863727578)
,p_db_column_name=>'ACTIVITY_DESCRIPTION'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Activity Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51642007717727578)
,p_db_column_name=>'FUTURE1'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51641578735727578)
,p_db_column_name=>'FUTURE1_DESCRIPTION'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Future1 Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51641199035727578)
,p_db_column_name=>'FUTURE2'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51640762665727578)
,p_db_column_name=>'FUTURE2_DESCRIPTION'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Future2 Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51640333893727577)
,p_db_column_name=>'ACCOUNT_TYPE'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Account Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51639934214727577)
,p_db_column_name=>'STATUS'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51639571588727577)
,p_db_column_name=>'FULL_CODE_COMBINATION'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Full Code Combination'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51639224284727576)
,p_db_column_name=>'FULL_CODE_COMBINATION_DESCRIPTION'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Full Code Combination Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51638799308727576)
,p_db_column_name=>'ENTITY_ID'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'DCT Entity'
,p_column_link=>'f?p=&APP_ID.:88:&SESSION.::&DEBUG.::P88_ID:#ID#'
,p_column_linktext=>'#ENTITY_ID#'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(71071080321406157)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51638384332727576)
,p_db_column_name=>'BUSINESS_ACTIVITY_ID'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Business Activity'
,p_column_link=>'f?p=&APP_ID.:88:&SESSION.::&DEBUG.::P88_ID:#ID#'
,p_column_linktext=>'#BUSINESS_ACTIVITY_ID#'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(71071274690402025)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51637987044727576)
,p_db_column_name=>'ACCOUNT_TYPE_ID'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Account Class'
,p_column_link=>'f?p=&APP_ID.:88:&SESSION.::&DEBUG.::P88_ID:#ID#'
,p_column_linktext=>'#ACCOUNT_TYPE_ID#'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(71071461979398892)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51637586125727575)
,p_db_column_name=>'CHAPTER_ID'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Chapter'
,p_column_link=>'f?p=&APP_ID.:88:&SESSION.::&DEBUG.::P88_ID:#ID#'
,p_column_linktext=>'#CHAPTER_ID#'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(71071651503392969)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51637221138727575)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51636773867727575)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51636351521727575)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51635999713727575)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51635610097727574)
,p_db_column_name=>'START_DATE'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51635137453727574)
,p_db_column_name=>'END_DATE'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51634794754727574)
,p_db_column_name=>'SECTOR_ID'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Sector'
,p_column_link=>'f?p=&APP_ID.:88:&SESSION.::&DEBUG.::P88_ID:#ID#'
,p_column_linktext=>'#SECTOR_ID#'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(1216232005294941)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51634396390727574)
,p_db_column_name=>'SECTOR_NAME'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Sector Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51633987198727574)
,p_db_column_name=>'DEPARTMENT_ID'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Department'
,p_column_link=>'f?p=&APP_ID.:88:&SESSION.::&DEBUG.::P88_ID:#ID#'
,p_column_linktext=>'#DEPARTMENT_ID#'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(1187523989265150)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51633595015727574)
,p_db_column_name=>'ID'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(51623491513723586)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1616606'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100000
,p_report_columns=>'COST_CENTER_CODE:COST_CENTER_DESCRIPTION:BUDGET_CODE:ACCOUNT_CODE:ACCOUNT_DESCRIPTION:FUTURE2:FUTURE2_DESCRIPTION:ACCOUNT_TYPE:ENTITY_ID:BUSINESS_ACTIVITY_ID:CHAPTER_ID:SECTOR_ID:'
,p_sort_column_1=>'COST_CENTER_CODE'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'ACCOUNT_CODE'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'FUTURE2'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(51455092797740208)
,p_report_id=>wwv_flow_api.id(51623491513723586)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'BUDGET_CODE'
,p_operator=>'not in'
,p_expr=>'8'
,p_condition_sql=>'"BUDGET_CODE" not in (#APXWS_EXPR_VAL1#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''8''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(51802701802877700)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(51803322291877706)
,p_button_name=>'Go'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Go'
,p_button_position=>'BOTTOM'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-search'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(51803231396877705)
,p_name=>'P87_CHAPTER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(51803322291877706)
,p_prompt=>'Chapter'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'GL CHAPTERS BY NUMBERS LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 30 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(51803126446877704)
,p_name=>'P87_SECTOR'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(51803322291877706)
,p_prompt=>'Sector'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'SECTORS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  NVL(SECTOR_NAME_USER , SECTOR_NAME) Name , SECTOR_ID',
'from dct_hr_sectors_v'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(51802986962877703)
,p_name=>'P87_BUSINESS_ACTIVITY'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(51803322291877706)
,p_prompt=>'Business Activity'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'GL BUSINESS ACTIVITIES LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 31 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(51802860848877702)
,p_name=>'P87_ACCOUNT_CLASS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(51803322291877706)
,p_prompt=>'Account Class'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'GL ACCOUNT TYPES LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 32 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(51802765787877701)
,p_name=>'P87_ENTITY'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(51803322291877706)
,p_prompt=>'DCT Entity'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'GL ENTITIES LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 29 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(51803769601877711)
,p_name=>'Close DA'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(51646905297727584)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(51803655901877710)
,p_event_id=>wwv_flow_api.id(51803769601877711)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(51646905297727584)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(51802627806877699)
,p_name=>'Search Da'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(51802701802877700)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(51802478907877698)
,p_event_id=>wwv_flow_api.id(51802627806877699)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(51646905297727584)
);
wwv_flow_api.component_end;
end;
/
