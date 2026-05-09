prompt --application/pages/page_00086
begin
--   Manifest
--     PAGE: 00086
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
 p_id=>86
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'GL Cashflow'
,p_alias=>'GL-CASHFLOW'
,p_step_title=>'GL Cashflow'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230425101645'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(52826179413613184)
,p_plug_name=>'GL Balances For'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(51818917219925794)
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
 p_id=>wwv_flow_api.id(51818274413925794)
,p_plug_name=>'GL Cashflow'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select    gl.CC_ID',
'        , gl.BUDGET_YTD',
'        , gl.ENCUM_YTD',
'        , gl.ACTUAL_YTD ',
'        , nvl(cf.total,0) cashflow_balnace',
'        , NVL(JAN, 0)   JAN',
'        , NVL(FEB, 0)   FEB',
'        , NVL(MAR, 0)   MAR',
'        , NVL(APR, 0)   APR',
'        , NVL(MAY, 0)   MAY',
'        , NVL(JUN, 0)   JUN',
'        , NVL(JUL, 0)   JUL',
'        , NVL(AUG, 0)   AUG',
'        , NVL(SEP, 0)   SEP',
'        , NVL(OCT, 0)   OCT',
'        , NVL(NOV, 0)   NOV',
'        , NVL(DEC, 0)   DEC',
'        , gl.budget_ptd',
'        , gl.encum_ptd',
'        , gl.actual_ptd',
'        , gl_util.get_gl_combination(gl.cc_id) gl_code',
'        , gl_util.get_gl_combination_desc(gl.cc_id) GL_DESC',
'        ',
'from dct_gl_balances gl, (select CC_ID , sum(JAN + FEB + MAR + APR + MAY + JUN + JUL + AUG + SEP + OCT + NOV + DEC)  total',
'                                       , SUM(JAN) JAN',
'                                       , SUM(FEB) FEB',
'                                       , SUM(MAR) MAR',
'                                       , SUM(APR) APR',
'                                       , SUM(MAY) MAY',
'                                       , SUM(JUN) JUN',
'                                       , SUM(JUL) JUL',
'                                       , SUM(AUG) AUG',
'                                       , SUM(SEP) SEP',
'                                       , SUM(OCT) OCT',
'                                       , SUM(NOV) NOV',
'                                       , SUM(DEC) DEC',
'from cashflow_lines_v',
'where ACCOUNTING_YEAR = :P86_ACCOUNTING_YEAR',
'GROUP by cc_id) cf',
'where gl.cc_id = cf.cc_id (+)',
'and gl.fisical_period_name = :P86_PERIOD_NAME',
'and gl.cc_id in (',
'                select cc_id',
'                from dct_gl_code_combinations_classifications',
'                where CHAPTER_ID = :P86_CHAPTER);',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P86_ACCOUNTING_YEAR,P86_CHAPTER,P86_PERIOD_NAME'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'GL Cashflow'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(51818153924925794)
,p_name=>'GL Cashflow'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>161465878464258838
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51817794937925780)
,p_db_column_name=>'CC_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51817384844925779)
,p_db_column_name=>'BUDGET_YTD'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Budget - YTD'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51817028262925779)
,p_db_column_name=>'ENCUM_YTD'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Encumbrance - YTD '
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51816549393925779)
,p_db_column_name=>'ACTUAL_YTD'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Actual - YTD'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51816188804925779)
,p_db_column_name=>'CASHFLOW_BALNACE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Cashflow Balance'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51815795944925778)
,p_db_column_name=>'BUDGET_PTD'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Budget - PTD'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51815387076925778)
,p_db_column_name=>'ENCUM_PTD'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Encum - PTD'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51814991677925778)
,p_db_column_name=>'ACTUAL_PTD'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Actual - PTD'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51814587823925778)
,p_db_column_name=>'GL_CODE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'GL Combination'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51814231091925777)
,p_db_column_name=>'GL_DESC'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'GL Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51805366419877727)
,p_db_column_name=>'JAN'
,p_display_order=>20
,p_column_identifier=>'K'
,p_column_label=>'Jan'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51805325794877726)
,p_db_column_name=>'FEB'
,p_display_order=>30
,p_column_identifier=>'L'
,p_column_label=>'Feb'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51805216901877725)
,p_db_column_name=>'MAR'
,p_display_order=>40
,p_column_identifier=>'M'
,p_column_label=>'Mar'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51805127868877724)
,p_db_column_name=>'APR'
,p_display_order=>50
,p_column_identifier=>'N'
,p_column_label=>'Apr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51804948851877723)
,p_db_column_name=>'MAY'
,p_display_order=>60
,p_column_identifier=>'O'
,p_column_label=>'May'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51804834199877722)
,p_db_column_name=>'JUN'
,p_display_order=>70
,p_column_identifier=>'P'
,p_column_label=>'Jun'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51804772557877721)
,p_db_column_name=>'JUL'
,p_display_order=>80
,p_column_identifier=>'Q'
,p_column_label=>'Jul'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51804656838877720)
,p_db_column_name=>'AUG'
,p_display_order=>90
,p_column_identifier=>'R'
,p_column_label=>'Aug'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51804600320877719)
,p_db_column_name=>'SEP'
,p_display_order=>100
,p_column_identifier=>'S'
,p_column_label=>'Sep'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51804451560877718)
,p_db_column_name=>'OCT'
,p_display_order=>110
,p_column_identifier=>'T'
,p_column_label=>'Oct'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51804367266877717)
,p_db_column_name=>'NOV'
,p_display_order=>120
,p_column_identifier=>'U'
,p_column_label=>'Nov'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(51804251039877716)
,p_db_column_name=>'DEC'
,p_display_order=>130
,p_column_identifier=>'V'
,p_column_label=>'Dec'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(51810963155916084)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1614731'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100000
,p_report_columns=>'GL_CODE:BUDGET_YTD:ENCUM_YTD:ACTUAL_YTD:ACTUAL_PTD:CASHFLOW_BALNACE:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:'
,p_sum_columns_on_break=>'BUDGET_YTD:CASHFLOW_BALNACE:JAN:FEB:ENCUM_YTD:ACTUAL_YTD:ACTUAL_PTD'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(50355041643576095)
,p_report_id=>wwv_flow_api.id(51810963155916084)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'BUDGET_YTD'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>'"BUDGET_YTD" > to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(51651090849785114)
,p_application_user=>'TCA9051'
,p_name=>'Ch2'
,p_report_seq=>10
,p_display_rows=>100000
,p_report_columns=>'GL_CODE:BUDGET_YTD:CASHFLOW_BALNACE:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:GL_DESC:'
,p_sum_columns_on_break=>'BUDGET_YTD:CASHFLOW_BALNACE:JAN:FEB'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(51650982135785114)
,p_report_id=>wwv_flow_api.id(51651090849785114)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'BUDGET_YTD'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>'"BUDGET_YTD" > to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(51650859815785114)
,p_report_id=>wwv_flow_api.id(51651090849785114)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'GL_CODE'
,p_operator=>'not in'
,p_expr=>'451.4510210.1.351020.000000.451000.201554,451.4510210.1.351020.000000.451000.200104'
,p_condition_sql=>'"GL_CODE" not in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''451.4510210.1.351020.000000.451000.201554, 451.4510210.1.351020.000000.451000.200104''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(51650514569775661)
,p_application_user=>'TCA9051'
,p_name=>'CH3'
,p_report_seq=>10
,p_display_rows=>100000
,p_report_columns=>'GL_CODE:BUDGET_YTD:CASHFLOW_BALNACE:JAN:FEB:MAR:APR:MAY:JUN:JUL:AUG:SEP:OCT:NOV:DEC:GL_DESC:'
,p_sum_columns_on_break=>'BUDGET_YTD:CASHFLOW_BALNACE:JAN:FEB'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(51650427851775661)
,p_report_id=>wwv_flow_api.id(51650514569775661)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'BUDGET_YTD'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>'"BUDGET_YTD" > to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(51650309608775661)
,p_report_id=>wwv_flow_api.id(51650514569775661)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'GL_CODE'
,p_operator=>'not in'
,p_expr=>'451.4510210.1.351030.000000.451000.301555,451.4510210.1.351030.000000.451000.301439,451.4510210.1.351030.000000.451000.300105'
,p_condition_sql=>'"GL_CODE" not in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#, #APXWS_EXPR_VAL3#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''451.4510210.1.351030.000000.451000.301555, 451.4510210.1.351030.000000.451000.301439, 451.4510210.1.351030.000000.451000.300105''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(51805751655877731)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(52826179413613184)
,p_button_name=>'Go'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Go'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(52826123740613183)
,p_name=>'P86_ACCOUNTING_YEAR'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(52826179413613184)
,p_prompt=>'Accounting Year'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DISTINCT ACCOUNTING_YEAR D, ACCOUNTING_YEAR R',
'FROM PROJECT_BALANCES',
'ORDER BY 1 DESC'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(51805514589877728)
,p_name=>'P86_CHAPTER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(52826179413613184)
,p_prompt=>'Chapter'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'GL CHAPTERS BY NUMBERS LOV'
,p_lov=>'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 30 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(50548677983650728)
,p_name=>'P86_PERIOD_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(52826179413613184)
,p_item_default=>'04-2023'
,p_prompt=>'Period Name'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct FISICAL_PERIOD_NAME d, FISICAL_PERIOD_NAME r',
'from dct_gl_balances',
'where SUBSTR(FISICAL_PERIOD_NAME,4) = 2023',
'order by 1;',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818276588410779)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(51805683706877730)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(51805751655877731)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(51805563261877729)
,p_event_id=>wwv_flow_api.id(51805683706877730)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(51818274413925794)
);
wwv_flow_api.component_end;
end;
/
