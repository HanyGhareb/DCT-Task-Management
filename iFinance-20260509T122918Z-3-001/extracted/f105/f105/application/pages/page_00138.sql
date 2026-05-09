prompt --application/pages/page_00138
begin
--   Manifest
--     PAGE: 00138
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
 p_id=>138
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Cashflow All'
,p_alias=>'CASHFLOW-ALL'
,p_step_title=>'Cashflow All'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240305110901'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(16780287836233343)
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
 p_id=>wwv_flow_api.id(16780934760233341)
,p_plug_name=>'Cashflow All'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       FISICAL_YEAR,',
'       COST_CENTER_CODE,',
'       PROJECT_NUMBER,',
'       PROJECTS_UTIL.project_name(PROJECT_NUMBER) project_name,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       INITIATIVE_CODE,',
'       CHAPTER,',
'       EXPENSE_CLASS,',
'       REQUESTED_BUDGET,',
'       APPROVED_BUDGET,',
'       ALLOCATED_BUDGET_EU,',
'       JAN_EU,',
'       FEB_EU,',
'       MAR_EU,',
'       APR_EU,',
'       MAY_EU,',
'       JUN_EU,',
'       JUL_EU,',
'       AUG_EU,',
'       SEP_EU,',
'       OCT_EU,',
'       NOV_EU,',
'       DEC_EU,',
'       ALLOCATED_BUDGET_FBP,',
'       JAN_FBP,',
'       FEB_FBP,',
'       MAR_FBP,',
'       APR_FBP,',
'       MAY_FBP,',
'       JUN_FBP,',
'       JUL_FBP,',
'       AUG_FBP,',
'       SEP_FBP,',
'       OCT_FBP,',
'       NOV_FBP,',
'       DEC_FBP,',
'       COMMENTS_EU,',
'       COMMENTS_FBP,',
'       ITEM_CATEGORY1,',
'       ITEM_CATEGORY2,',
'       ITEM_CATEGORY3,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY',
'  from BA_PROJECTS_ALLOCATION',
'  WHERE FISICAL_YEAR = :P138_ACCOUNTING_YEAR'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P138_ACCOUNTING_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Cashflow All'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(16781031263233341)
,p_name=>'Cashflow All'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>230065063652417973
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16781448549233338)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16781823523233337)
,p_db_column_name=>'FISICAL_YEAR'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Fisical Year'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16782173067233337)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Cost Center Code'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(71087570950221411)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16782591475233336)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16783012034233336)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16783420586233336)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16783790593233335)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16784229142233335)
,p_db_column_name=>'INITIATIVE_CODE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Initiative Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16784652807233335)
,p_db_column_name=>'CHAPTER'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Chapter'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16784977723233335)
,p_db_column_name=>'EXPENSE_CLASS'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Expense Class'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16785415346233335)
,p_db_column_name=>'REQUESTED_BUDGET'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Requested Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16785842092233334)
,p_db_column_name=>'APPROVED_BUDGET'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Approved Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16786171163233334)
,p_db_column_name=>'ALLOCATED_BUDGET_EU'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Allocated Budget'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16786625500233328)
,p_db_column_name=>'JAN_EU'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Jan'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16786914586233327)
,p_db_column_name=>'FEB_EU'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Feb'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16787288154233327)
,p_db_column_name=>'MAR_EU'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Mar'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16787725229233327)
,p_db_column_name=>'APR_EU'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Apr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16788133723233327)
,p_db_column_name=>'MAY_EU'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'May'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16788538437233326)
,p_db_column_name=>'JUN_EU'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Jun'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16788874110233326)
,p_db_column_name=>'JUL_EU'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Jul'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16789310209233326)
,p_db_column_name=>'AUG_EU'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Aug'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16789765071233326)
,p_db_column_name=>'SEP_EU'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Sep'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16790133086233325)
,p_db_column_name=>'OCT_EU'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Oct'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16790503434233325)
,p_db_column_name=>'NOV_EU'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Nov'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16790953947233325)
,p_db_column_name=>'DEC_EU'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Dec'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16791318719233325)
,p_db_column_name=>'ALLOCATED_BUDGET_FBP'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Allocated Budget- FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16791683670233324)
,p_db_column_name=>'JAN_FBP'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Jan - FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16792162092233324)
,p_db_column_name=>'FEB_FBP'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Feb- FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16792566362233324)
,p_db_column_name=>'MAR_FBP'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Mar- FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16792946237233324)
,p_db_column_name=>'APR_FBP'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Apr- FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16793328685233324)
,p_db_column_name=>'MAY_FBP'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'May- FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16793671299233323)
,p_db_column_name=>'JUN_FBP'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Jun- FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16794123603233323)
,p_db_column_name=>'JUL_FBP'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Jul- FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16794545651233323)
,p_db_column_name=>'AUG_FBP'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Aug- FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16794956196233323)
,p_db_column_name=>'SEP_FBP'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Sep- FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16795358674233322)
,p_db_column_name=>'OCT_FBP'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Oct- FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16795716313233322)
,p_db_column_name=>'NOV_FBP'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Nov- FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16796082630233322)
,p_db_column_name=>'DEC_FBP'
,p_display_order=>38
,p_column_identifier=>'AL'
,p_column_label=>'Dec- FBP'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16796552490233321)
,p_db_column_name=>'COMMENTS_EU'
,p_display_order=>39
,p_column_identifier=>'AM'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16796881479233321)
,p_db_column_name=>'COMMENTS_FBP'
,p_display_order=>40
,p_column_identifier=>'AN'
,p_column_label=>'Comments- FBP'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16797329212233321)
,p_db_column_name=>'ITEM_CATEGORY1'
,p_display_order=>41
,p_column_identifier=>'AO'
,p_column_label=>'Category Level1'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(11362076622127119)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16797708105233321)
,p_db_column_name=>'ITEM_CATEGORY2'
,p_display_order=>42
,p_column_identifier=>'AP'
,p_column_label=>'Category Level2'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(11362076622127119)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16798123085233320)
,p_db_column_name=>'ITEM_CATEGORY3'
,p_display_order=>43
,p_column_identifier=>'AQ'
,p_column_label=>'Category Level3'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(11362076622127119)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16798561613233320)
,p_db_column_name=>'CREATED'
,p_display_order=>44
,p_column_identifier=>'AR'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16798947068233319)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>45
,p_column_identifier=>'AS'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16799268137233319)
,p_db_column_name=>'UPDATED'
,p_display_order=>46
,p_column_identifier=>'AT'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(16799713847233319)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>47
,p_column_identifier=>'AU'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(16831370690121177)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2301155'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'COST_CENTER_CODE:PROJECT_NUMBER:PROJECT_NAME:TASK_NUMBER:EXPENDITURE_TYPE:INITIATIVE_CODE:CHAPTER:EXPENSE_CLASS:REQUESTED_BUDGET:APPROVED_BUDGET:ALLOCATED_BUDGET_EU:JAN_EU:FEB_EU:MAR_EU:APR_EU:MAY_EU:JUN_EU:JUL_EU:AUG_EU:SEP_EU:OCT_EU:NOV_EU:DEC_EU:C'
||'OMMENTS_EU:ALLOCATED_BUDGET_FBP:JAN_FBP:FEB_FBP:MAR_FBP:APR_FBP:MAY_FBP:JUN_FBP:JUL_FBP:AUG_FBP:SEP_FBP:OCT_FBP:NOV_FBP:DEC_FBP:COMMENTS_FBP:ITEM_CATEGORY1:ITEM_CATEGORY2:ITEM_CATEGORY3:UPDATED:UPDATED_BY:'
,p_sort_column_1=>'COST_CENTER_CODE'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'PROJECT_NUMBER'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'TASK_NUMBER'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(176155742065762866)
,p_plug_name=>'Cashflow '
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>5
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(16801673254228507)
,p_name=>'P138_ACCOUNTING_YEAR'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(176155742065762866)
,p_item_default=>'SELECT extract(year from sysdate) FROM DUAL;'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Accounting Year'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:2022;2022,2023;2023,2024;2024'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.component_end;
end;
/
