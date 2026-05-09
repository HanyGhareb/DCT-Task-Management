prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>110
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>11
,p_user_interface_id=>wwv_flow_api.id(13327188105480887)
,p_name=>'Budget Sector by Department'
,p_alias=>'BUDGET-SECTOR-BY-DEPARTMENT'
,p_step_title=>'Budget Sector by Department'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210109195227'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18157201926127031)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(13251955757480809)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(13188546909480758)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(13306063834480855)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(18157874852127031)
,p_plug_name=>'Budget Sector by Department'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(13240610854480803)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  SCENARIO_NAME, ',
'        SCENARIO_YEAR, ',
'        CHAPTER, ',
'        SECTOR,',
'        department_name,',
'        cost_center,',
'        round(sum(BUDGET_2020),2)         BUDGET_2020, ',
'        round(sum(BUDGET_2021),2)         BUDGET_2021, ',
'        round(sum(BUDGET_2022),2)         BUDGET_2022, ',
'        round(sum(BUDGET_2023),2)         BUDGET_2023, ',
'        round(sum(ALLOCATION_2021),2)     ALLOCATION_2021',
'from budget_v',
'where sector = nvl(:P11_SECTOR , sector)',
'and  type  = nvl(:P11_TYPE ,type)',
'AND expense_type  = nvl(:P11_EXPENSE_TYPE , expense_type)',
'AND NEW_ASSETS = NVL(:P11_NEW_ASSETS , NEW_ASSETS)',
'and account_number = nvl(:P11_ACCOUNT_NUMBER , account_number)',
'and account_name = nvl(:P11_ACCOUNT_NAME , account_name)',
'GROUP by SCENARIO_NAME, ',
'        SCENARIO_YEAR, ',
'        CHAPTER, ',
'        SECTOR ,department_name,',
'        cost_center',
'order by 1, 3,4,5,6       ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P11_SECTOR,P11_TYPE,P11_EXPENSE_TYPE,P11_NEW_ASSETS,P11_ACCOUNT_NUMBER,P11_ACCOUNT_NAME'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Budget Sector by Department'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(18157918430127031)
,p_name=>'Budget Sector by Department'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>18157918430127031
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18158319955127033)
,p_db_column_name=>'SCENARIO_NAME'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Scenario Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18158780380127034)
,p_db_column_name=>'SCENARIO_YEAR'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Scenario Year'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18159189326127034)
,p_db_column_name=>'CHAPTER'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Chapter'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18159574241127034)
,p_db_column_name=>'SECTOR'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18159909333127035)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Department Name'
,p_column_link=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_DEPARTMENT_NAME,P12_SECTOR,P12_COST_CENTER,P12_DEPARTMENT_NAME_H:#DEPARTMENT_NAME#,#SECTOR#,#COST_CENTER#,#DEPARTMENT_NAME#'
,p_column_linktext=>'#DEPARTMENT_NAME#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18160367088127035)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Cost Center'
,p_column_link=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13:P13_SECTOR,P13_DEPARTMENT_NAME,P13_COST_CENTER:#SECTOR#,#DEPARTMENT_NAME#,#COST_CENTER#'
,p_column_linktext=>'#COST_CENTER#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18160758628127035)
,p_db_column_name=>'BUDGET_2020'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Budget 2020'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18161190791127036)
,p_db_column_name=>'BUDGET_2021'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Budget 2021'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18161577991127036)
,p_db_column_name=>'BUDGET_2022'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Budget 2022'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18161958771127036)
,p_db_column_name=>'BUDGET_2023'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Budget 2023'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(18162356924127037)
,p_db_column_name=>'ALLOCATION_2021'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Allocation 2021'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(18164058333156393)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'181641'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SCENARIO_NAME:SCENARIO_YEAR:CHAPTER:SECTOR:DEPARTMENT_NAME:COST_CENTER:BUDGET_2020:BUDGET_2021:ALLOCATION_2021:APXWS_CC_001:BUDGET_2022:BUDGET_2023::APXWS_CC_002'
,p_sum_columns_on_break=>'BUDGET_2020:BUDGET_2021:BUDGET_2022:BUDGET_2023:ALLOCATION_2021:APXWS_CC_001'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(18183656290962154)
,p_report_id=>wwv_flow_api.id(18164058333156393)
,p_name=>'Remaining'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'APXWS_CC_001'
,p_operator=>'='
,p_expr=>'0'
,p_condition_sql=>' (case when ((#APXWS_CC_EXPR#) = to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D0F1CC'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(18184023521962154)
,p_report_id=>wwv_flow_api.id(18164058333156393)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'H -  K'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'2021 Difference'
,p_report_label=>'2021 Difference'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(31856426175521388)
,p_plug_name=>'Filter By'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(13242565869480804)
,p_plug_display_sequence=>5
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(18185043915967483)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(31856426175521388)
,p_button_name=>'Clear'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(13304710257480854)
,p_button_image_alt=>'Clear'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-recycle'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13672569429553917)
,p_name=>'P11_SECTOR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(18157201926127031)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18185431603967487)
,p_name=>'P11_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(31856426175521388)
,p_prompt=>'Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT exp_type d , ',
'                exp_type r ',
'from budget',
'where exp_type is not NULL',
'order by 1'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18185857188967488)
,p_name=>'P11_EXPENSE_TYPE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(31856426175521388)
,p_prompt=>'Expense Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT expense_type d , ',
'                expense_type r ',
'from budget',
'where expense_type is not null',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18186261352967488)
,p_name=>'P11_NEW_ASSETS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(31856426175521388)
,p_prompt=>'New Assets'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT new_assets d , ',
'                new_assets r ',
'from budget',
'where new_assets is not NULL',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18186692388967489)
,p_name=>'P11_ACCOUNT_NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(31856426175521388)
,p_prompt=>'Account Number'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT account_number || '' - ''  || account_name d , ',
'                account_number r ',
'from budget',
'--where new_assets is not NULL',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(18187070973967489)
,p_name=>'P11_ACCOUNT_NAME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(31856426175521388)
,p_prompt=>'Account Name'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT ACCOUNT_NAME d , ',
'                ACCOUNT_NAME r ',
'from budget',
'--where new_assets is not NULL',
'order by 1;'))
,p_cSize=>80
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(13303312112480851)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(13673539985553927)
,p_name=>'refresh report'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P11_TYPE,P11_EXPENSE_TYPE,P11_NEW_ASSETS,P11_ACCOUNT_NUMBER,P11_ACCOUNT_NAME'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13673682134553928)
,p_event_id=>wwv_flow_api.id(13673539985553927)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(18157874852127031)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(13673750198553929)
,p_name=>'clear search critera'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(18185043915967483)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13673856626553930)
,p_event_id=>wwv_flow_api.id(13673750198553929)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_TYPE,P11_EXPENSE_TYPE,P11_NEW_ASSETS,P11_ACCOUNT_NUMBER,P11_ACCOUNT_NAME'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13673919309553931)
,p_event_id=>wwv_flow_api.id(13673750198553929)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(18157874852127031)
);
wwv_flow_api.component_end;
end;
/
