prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'Fund Management Home'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240307213639'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(101262317318951318)
,p_plug_name=>'Overview'
,p_icon_css_classes=>'fa-combo-chart'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':PERSON_ID = 680461 or ',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_FBP_EMP = ''Y'' or',
':IS_BTF_QUERY_YN = ''Y'''))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(101262186975951317)
,p_plug_name=>'Amount By Status (Total From: &P1_REQUEST_AMOUNT. AED)'
,p_parent_plug_id=>wwv_flow_api.id(101262317318951318)
,p_icon_css_classes=>'fa-money'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(101262078227951316)
,p_region_id=>wwv_flow_api.id(101262186975951317)
,p_chart_type=>'donut'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>false
,p_show_value=>true
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(101261958638951315)
,p_chart_id=>wwv_flow_api.id(101262078227951316)
,p_seq=>10
,p_name=>'By Status'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select sum(BTF_AMOUNT), REQUEST_STATUS, ICON_COLOR',
'from ',
'(',
'select FROM_AMOUNT btf_amount,',
'       Case REQUEST_STATUS',
'            when ''Approved'' ',
'                Then ',
'                    Case EXECUTED_STATUS ',
'                        When ''NA''           Then ''@Budget Planning''',
'                        When ''in-Process''            Then ''@Budget Planning''',
'                        when ''Executed''     Then ''Executed''',
'                    End    ',
'            when ''in-Progress''  Then ''in-Progress''',
'            when ''Rejected''     Then ''Rejected''',
'            when ''Withdraw''     Then ''Withdraw''',
'            when ''Cancel''       Then ''Cancel''',
'            when ''Draft''        Then ''Draft''',
'            when ''Return''       Then ''Return''',
'        End                                         REQUEST_STATUS',
'        ',
'    --',
'         ,Case REQUEST_STATUS',
'            when ''Approved'' ',
'                Then ',
'                    Case EXECUTED_STATUS ',
'                        When ''NA''           Then ''#C7C7CC''',
'                        When ''in-Process''            Then ''#C7C7CC''',
'                        when ''Executed''     Then ''#34AD48''',
'                    End    ',
'            when ''in-Progress''  Then ''#FFCC00''',
'            when ''Rejected''     Then ''#FF2D55''',
'            when ''Withdraw''     Then ''#007AFF''',
'            when ''Cancel''       Then ''black''',
'            when ''Draft''        Then ''#3FD4B4''',
'            when ''Return''       Then ''#AFE86D''',
'        End                                         icon_color',
'    --    ',
'     ',
'from btf_end_users_header_v',
'where YEAR = :P1_ACCOUNTING_YEAR',
')',
'',
'group by REQUEST_STATUS, ICON_COLOR;'))
,p_ajax_items_to_submit=>'P1_ACCOUNTING_YEAR'
,p_items_value_column_name=>'SUM(BTF_AMOUNT)'
,p_items_label_column_name=>'REQUEST_STATUS'
,p_color=>'&ICON_COLOR.'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideSlice'
,p_items_label_display_as=>'ALL'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(101261561280951311)
,p_plug_name=>'Count By Status (&P1_REQUEST_COUNT.)'
,p_parent_plug_id=>wwv_flow_api.id(101262317318951318)
,p_icon_css_classes=>'fa-number-0-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(101261476893951310)
,p_region_id=>wwv_flow_api.id(101261561280951311)
,p_chart_type=>'donut'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>false
,p_show_value=>true
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(101261260453951308)
,p_chart_id=>wwv_flow_api.id(101261476893951310)
,p_seq=>20
,p_name=>'By Sector'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(request_id), REQUEST_STATUS, ICON_COLOR , EXECUTED_STATUS',
'from ',
'(',
'select request_id,',
'       Case REQUEST_STATUS',
'            when ''Approved'' ',
'                Then ',
'                    Case EXECUTED_STATUS ',
'                        When ''NA''           Then ''@Budget Planning''',
'                        When ''in-Process''            Then ''@Budget Planning''',
'                        when ''Executed''     Then ''Executed''',
'                    End    ',
'            when ''in-Progress''  Then ''in-Progress''',
'            when ''Rejected''     Then ''Rejected''',
'            when ''Withdraw''     Then ''Withdraw''',
'            when ''Cancel''       Then ''Cancel''',
'            when ''Draft''        Then ''Draft''',
'            when ''Return''       Then ''Return''',
'        End                                         REQUEST_STATUS',
'        ',
'    --',
'         ,Case REQUEST_STATUS',
'            when ''Approved'' ',
'                Then ',
'                    Case EXECUTED_STATUS ',
'                        When ''NA''           Then ''#C7C7CC''',
'                        When ''in-Process''            Then ''#C7C7CC''',
'                        when ''Executed''     Then ''#34AD48''',
'                    End    ',
'            when ''in-Progress''  Then ''#FFCC00''',
'            when ''Rejected''     Then ''#FF2D55''',
'            when ''Withdraw''     Then ''#007AFF''',
'            when ''Cancel''       Then ''black''',
'            when ''Draft''        Then ''#3FD4B4''',
'            when ''Return''       Then ''#AFE86D''',
'        End                                         icon_color',
'    , EXECUTED_STATUS ',
'     ',
'from btf_end_users_header_v',
'    where YEAR = :P1_ACCOUNTING_YEAR',
')',
'',
'group by REQUEST_STATUS, ICON_COLOR , EXECUTED_STATUS;'))
,p_ajax_items_to_submit=>'P1_ACCOUNTING_YEAR'
,p_items_value_column_name=>'COUNT(REQUEST_ID)'
,p_items_label_column_name=>'REQUEST_STATUS'
,p_color=>'&ICON_COLOR.'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideSlice'
,p_items_label_display_as=>'ALL'
,p_link_target=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.::P35_REQUEST_STATUS,P35_EXECUTE_STATUS:&REQUEST_STATUS.,&EXECUTED_STATUS.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(53929716998650294)
,p_plug_name=>'Budget Transfer Requests'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1349428504912397)
,p_plug_name=>'All Budget Transfer requests'
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    request_id,',
'    request_no,',
'    request_date,',
'    required_date,',
'    request_status,',
'    justification,',
'    year,',
'    purpose_eu,',
'    priority,',
'    submitted_on,',
'    submitted_by,',
'    seq,',
'    final_approve_on,',
'    created_by_person_id,',
'    updated_by_person_id,',
'    creation_date,',
'    updated_date,',
'    reasons,',
'    spm_project_name,',
'    spm_project_id,',
'    request_type,',
'    final_reject_on,',
'    rejected_by,',
'    reject_reason,',
'    cancel_on,',
'    cancelled_by,',
'    cancel_reason,',
'    strategic_yn,',
'    from_amount,',
'    to_amount,',
'    nvl(nvl(from_amount, to_amount),0) Amount,',
'    ',
'    EXECUTED_STATUS  xx,',
'    Approval_case_id,',
'    case request_status when ''Approved''',
'        Then ',
'            case EXECUTED_STATUS when ''Executed'' Then ''<span class="fa fa-check-circle" style="color:green"></span>''',
'                else   ''<span class="fa fa-check-circle" style="color:red"></span>''',
'            end    ',
'     End    executed_status,',
'  --    ',
'         case request_status when ''Approved''',
'        Then ',
'            case EXECUTED_STATUS when ''Executed'' Then null',
'                else   apex_util.prepare_url( ''f?p=''||:APP_ID||'':33:''||:APP_SESSION||''::NO::P33_REQUEST_ID,P33_REQUEST_NUMBER:''|| request_id || '','' || request_no )',
'            end    ',
'     End    Link',
'     ,''<span aria-hidden="true" class="fa fa-copy fa-2x"></span>'' Copy',
'     ,case when ',
'                    REQUEST_STATUS = ''Approved'' and',
'                    EXECUTED_STATUS = ''NA''      and',
'                    BTF_EU_UTIL.btf_current_fund_request(request_id) > 0',
'            then ',
'                ''<span aria-hidden="true" class="fa fa-exclamation-triangle-o fa-anim-flash fam-x fam-is-danger"></span>''',
'            else',
'                ''<span class="fa fa-check-circle" style="color:green">''',
'    end Current_fund_status',
'FROM',
'    btf_end_users_header_v',
'    where YEAR = :P1_ACCOUNTING_YEAR'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P1_ACCOUNTING_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' OR',
':IS_IFINANCE_ADMIN = ''Y'' OR',
':IS_BUDGET_PLANNING_YN = ''Y'' OR',
':IS_BTF_QUERY_YN = ''Y'''))
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'EU Transfer requests'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(1349566795912398)
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>106705895987275811
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1349578439912399)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1349741296912400)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request No'
,p_column_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_REQUEST_ID,P8_PAGE_FROM,REQUEST_ID:#REQUEST_ID#,1,#REQUEST_ID#'
,p_column_linktext=>'#REQUEST_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1349821497912401)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1349888480912402)
,p_db_column_name=>'REQUIRED_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Required Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1350066250912403)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1350150380912404)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1350268057912405)
,p_db_column_name=>'YEAR'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1350276821912406)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Purpose'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1350440905912407)
,p_db_column_name=>'PRIORITY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48255921784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1350540048912408)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1350621490912409)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1350756296912410)
,p_db_column_name=>'SEQ'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1350784522912411)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1350933340912412)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1351031382912413)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1351110586912414)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1351203037912415)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1351358245912416)
,p_db_column_name=>'REASONS'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1351458072912417)
,p_db_column_name=>'SPM_PROJECT_NAME'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'SPM Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1351487334912418)
,p_db_column_name=>'SPM_PROJECT_ID'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'SPM Project'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1351624901912419)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(203139147648731)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1352677754912430)
,p_db_column_name=>'FINAL_REJECT_ON'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Final Reject On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1352792621912431)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1352917001912432)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1353011955912433)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1353149910912434)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1353177955912435)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1353328196912436)
,p_db_column_name=>'STRATEGIC_YN'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Strategic?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1353424487912437)
,p_db_column_name=>'FROM_AMOUNT'
,p_display_order=>290
,p_column_identifier=>'AC'
,p_column_label=>'Deduction Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1926199918365488)
,p_db_column_name=>'TO_AMOUNT'
,p_display_order=>300
,p_column_identifier=>'AD'
,p_column_label=>'Additional Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1926352771365489)
,p_db_column_name=>'AMOUNT'
,p_display_order=>310
,p_column_identifier=>'AE'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(100822215863881317)
,p_db_column_name=>'EXECUTED_STATUS'
,p_display_order=>320
,p_column_identifier=>'AF'
,p_column_label=>'Executed Status'
,p_column_link=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.::P33_REQUEST_ID,P33_REQUEST_NUMBER,P33_REQUEST_STATUS:#REQUEST_ID#,#REQUEST_NO#,#XX#'
,p_column_linktext=>'#EXECUTED_STATUS#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(100820931614881304)
,p_db_column_name=>'LINK'
,p_display_order=>330
,p_column_identifier=>'AG'
,p_column_label=>'Link'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(100820558824881301)
,p_db_column_name=>'XX'
,p_display_order=>340
,p_column_identifier=>'AH'
,p_column_label=>'Xx'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(77303237455358407)
,p_db_column_name=>'COPY'
,p_display_order=>350
,p_column_identifier=>'AI'
,p_column_label=>'Copy'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24019584173356895)
,p_db_column_name=>'APPROVAL_CASE_ID'
,p_display_order=>360
,p_column_identifier=>'AJ'
,p_column_label=>'Approval Case'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(22579478575036725)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1363940126464830)
,p_db_column_name=>'CURRENT_FUND_STATUS'
,p_display_order=>370
,p_column_identifier=>'AK'
,p_column_label=>'Current Fund Status'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1914021872439270)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1072704'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NO:REQUEST_TYPE:REQUEST_DATE:PRIORITY:CREATED_BY_PERSON_ID:AMOUNT:REQUEST_STATUS:EXECUTED_STATUS::CURRENT_FUND_STATUS'
,p_sort_column_1=>'UPDATED_DATE'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
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
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(1367921168260191)
,p_report_id=>wwv_flow_api.id(1914021872439270)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(1368367047260191)
,p_report_id=>wwv_flow_api.id(1914021872439270)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(1368699328260192)
,p_report_id=>wwv_flow_api.id(1914021872439270)
,p_name=>'Return'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Return'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Return''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#CCE5FF'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(1369077986260192)
,p_report_id=>wwv_flow_api.id(1914021872439270)
,p_name=>'in-Progress'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(84777233028870344)
,p_application_user=>'TCA9051'
,p_name=>'Pending Requests'
,p_report_seq=>10
,p_report_columns=>'REQUEST_NO:REQUEST_TYPE:REQUEST_DATE:PRIORITY:CREATED_BY_PERSON_ID:AMOUNT:REQUEST_STATUS::EXECUTED_STATUS:LINK:XX'
,p_sort_column_1=>'UPDATED_DATE'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
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
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(84777072596870344)
,p_report_id=>wwv_flow_api.id(84777233028870344)
,p_name=>'Approved'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Approved'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Approved''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#3BAA2C'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(84776936928870344)
,p_report_id=>wwv_flow_api.id(84777233028870344)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F44336'
,p_column_font_color=>'#FFFFFF'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(84776900201870344)
,p_report_id=>wwv_flow_api.id(84777233028870344)
,p_name=>'Return'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'Return'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Return''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#CCE5FF'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(84776753898870344)
,p_report_id=>wwv_flow_api.id(84777233028870344)
,p_name=>'in-Progress'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>' (case when ("REQUEST_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
,p_column_font_color=>'#000000'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(84777149881870344)
,p_report_id=>wwv_flow_api.id(84777233028870344)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'REQUEST_STATUS'
,p_operator=>'='
,p_expr=>'in-Progress'
,p_condition_sql=>'"REQUEST_STATUS" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''in-Progress''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(14844041141416996)
,p_plug_name=>'Cashflow'
,p_region_template_options=>'#DEFAULT#:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99740467168410739)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(234705261299222439)
,p_plug_name=>'Budget Allocation - &P1_ACCOUNTING_YEAR.'
,p_parent_plug_id=>wwv_flow_api.id(14844041141416996)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       COST_CENTER_CODE,',
'       user_details.get_cost_center_name(COST_CENTER_CODE) Department_Name,',
'       user_details.sector_id_by_cc(COST_CENTER_CODE , sysdate) Sector_Name,',
'       FISICAL_YEAR,',
'       nvl(CHAPTER1,0)  CEILING_CHAPTER1,',
'       nvl(CHAPTER2,0)  CEILING_CHAPTER2,',
'       nvl(BA_ALLOCATION.requested_budget(COST_CENTER_CODE, ''2'', FISICAL_YEAR),0)	requested_budget_ch2,',
'       nvl(BA_ALLOCATION.approved_budget(COST_CENTER_CODE, ''2'', FISICAL_YEAR),0)	approved_budget_ch2,',
'       nvl(BA_ALLOCATION.allocated_budget(COST_CENTER_CODE, ''2'', FISICAL_YEAR),0)	allocated_budget_ch2,',
'       nvl(CHAPTER3,0)  CEILING_CHAPTER3,',
'       nvl(BA_ALLOCATION.requested_budget(COST_CENTER_CODE, ''3'', FISICAL_YEAR),0)	requested_budget_ch3,',
'       nvl(BA_ALLOCATION.approved_budget(COST_CENTER_CODE, ''3'', FISICAL_YEAR),0)	approved_budget_ch3,',
'       nvl(BA_ALLOCATION.allocated_budget(COST_CENTER_CODE, ''3'', FISICAL_YEAR),0)	allocated_budget_ch3,',
'       nvl(CHAPTER6,0)  CEILING_CHAPTER6,',
'       COMMENTS,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY,',
'       allow_update,',
'       approval_status',
'  from BA_COST_CENTERS_CEILLING',
'  where FISICAL_YEAR = :P1_ACCOUNTING_YEAR',
'  and (',
'    -- first Condition: login user has cost center planner role',
'    COST_CENTER_CODE in (select  COST_CENTER',
'                                from BUDGET_ALLOCATION_ROLE_USERS',
'                                where role_id = 114        -- Cost center planner 114',
'                                and PERSON_ID = :PERSON_ID',
'                                and sysdate between nvl(start_date , sysdate - 10) ',
'                                                and nvl(end_date   , sysdate + 10)',
'                                and STATUS = ''A''',
'                                )',
'    OR',
'    -- 2nd Cond: login user has FBP',
'    :IS_IFINANCE_ADMIN      = ''Y''    OR',
'    :IS_FBP_EMP             = ''Y''    OR',
'    :IS_BUDGET_PLANNING_YN  = ''Y''',
'    )'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P1_ACCOUNTING_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Manage Cost Centers Ceiling Report'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(234705571709222439)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No Budget Allocation details available for &P1_ACCOUNTING_YEAR.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:126:&SESSION.::&DEBUG.:RP:P126_ID:\#ID#\'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':IS_BUDGET_PLANNING_YN = ''Y'' or',
':IS_IFINANCE_ADMIN = ''Y'''))
,p_owner=>'TCA9051'
,p_internal_uid=>447989604098407071
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11136163453318003)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11136548248318003)
,p_db_column_name=>'COST_CENTER_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Cost Center'
,p_column_link=>'f?p=&APP_ID.:127:&SESSION.::&DEBUG.:127:P127_YEAR,P127_COST_CENTER:#FISICAL_YEAR#,#COST_CENTER_CODE#'
,p_column_linktext=>'#COST_CENTER_CODE#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11136929047318004)
,p_db_column_name=>'FISICAL_YEAR'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Fisical Year'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11138922411318005)
,p_db_column_name=>'COMMENTS'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11139270748318005)
,p_db_column_name=>'CREATED'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Created on'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11139680090318005)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11140086870318005)
,p_db_column_name=>'UPDATED'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Updated on'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11140502252318005)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11135005749318002)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>22
,p_column_identifier=>'M'
,p_column_label=>'Department Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11135334052318002)
,p_db_column_name=>'SECTOR_NAME'
,p_display_order=>32
,p_column_identifier=>'N'
,p_column_label=>'Sector Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(1187523989265150)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11135719466318002)
,p_db_column_name=>'ALLOW_UPDATE'
,p_display_order=>42
,p_column_identifier=>'O'
,p_column_label=>'Allow Update'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8901882300781699)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>152
,p_column_identifier=>'AJ'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8902024702781700)
,p_db_column_name=>'CEILING_CHAPTER1'
,p_display_order=>162
,p_column_identifier=>'AK'
,p_column_label=>'Ceiling Chapter1'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8902115273781701)
,p_db_column_name=>'CEILING_CHAPTER2'
,p_display_order=>172
,p_column_identifier=>'AL'
,p_column_label=>'Ceiling Chapter2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8902175298781702)
,p_db_column_name=>'REQUESTED_BUDGET_CH2'
,p_display_order=>182
,p_column_identifier=>'AM'
,p_column_label=>'Requested Budget Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8902350782781703)
,p_db_column_name=>'APPROVED_BUDGET_CH2'
,p_display_order=>192
,p_column_identifier=>'AN'
,p_column_label=>'Approved Budget Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8902425735781704)
,p_db_column_name=>'ALLOCATED_BUDGET_CH2'
,p_display_order=>202
,p_column_identifier=>'AO'
,p_column_label=>'Allocated Budget Ch2'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8902561016781705)
,p_db_column_name=>'CEILING_CHAPTER3'
,p_display_order=>212
,p_column_identifier=>'AP'
,p_column_label=>'Ceiling Chapter3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8902602073781706)
,p_db_column_name=>'REQUESTED_BUDGET_CH3'
,p_display_order=>222
,p_column_identifier=>'AQ'
,p_column_label=>'Requested Budget Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8902714286781707)
,p_db_column_name=>'APPROVED_BUDGET_CH3'
,p_display_order=>232
,p_column_identifier=>'AR'
,p_column_label=>'Approved Budget Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8902803256781708)
,p_db_column_name=>'ALLOCATED_BUDGET_CH3'
,p_display_order=>242
,p_column_identifier=>'AS'
,p_column_label=>'Allocated Budget Ch3'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8902885580781709)
,p_db_column_name=>'CEILING_CHAPTER6'
,p_display_order=>252
,p_column_identifier=>'AT'
,p_column_label=>'Ceiling Chapter6'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(234724538729281691)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2244249'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_NAME:DEPARTMENT_NAME:COST_CENTER_CODE:REQUESTED_BUDGET_CH2:CEILING_CHAPTER2:APPROVED_BUDGET_CH2:ALLOCATED_BUDGET_CH2:REQUESTED_BUDGET_CH3:CEILING_CHAPTER3:APPROVED_BUDGET_CH3:ALLOCATED_BUDGET_CH3:COMMENTS:APPROVAL_STATUS:'
,p_sum_columns_on_break=>'CHAPTER2:CHAPTER3:CEILING_CHAPTER2:REQUESTED_BUDGET_CH2:APPROVED_BUDGET_CH2:ALLOCATED_BUDGET_CH3:APPROVED_BUDGET_CH3:REQUESTED_BUDGET_CH3:CEILING_CHAPTER3:ALLOCATED_BUDGET_CH2'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(14180236989757418)
,p_application_user=>'TCA9272'
,p_name=>'FBP'
,p_report_seq=>10
,p_report_columns=>'SECTOR_NAME:DEPARTMENT_NAME:COST_CENTER_CODE:REQUESTED_BUDGET_CH2:CEILING_CHAPTER2:APPROVED_BUDGET_CH2:ALLOCATED_BUDGET_CH2:REQUESTED_BUDGET_CH3:CEILING_CHAPTER3:APPROVED_BUDGET_CH3:ALLOCATED_BUDGET_CH3:COMMENTS:APPROVAL_STATUS::APXWS_CC_001'
,p_sum_columns_on_break=>'CHAPTER2:CHAPTER3:CEILING_CHAPTER2:REQUESTED_BUDGET_CH2:APPROVED_BUDGET_CH2:ALLOCATED_BUDGET_CH3:APPROVED_BUDGET_CH3:REQUESTED_BUDGET_CH3:CEILING_CHAPTER3:ALLOCATED_BUDGET_CH2'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(14180323936757419)
,p_report_id=>wwv_flow_api.id(14180236989757418)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'AO - AN'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'diff-Ch2'
,p_report_label=>'diff-Ch2'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(99855874479410836)
,p_plug_name=>'Fund Transfer'
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
 p_id=>wwv_flow_api.id(107458007925538196)
,p_plug_name=>'My Budget Transfer requests'
,p_icon_css_classes=>'fa-user'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    request_id,',
'    request_no,',
'    request_date,',
'    required_date,',
'    request_status,',
'    justification,',
'    year,',
'    purpose_eu,',
'    priority,',
'    submitted_on,',
'    submitted_by,',
'    seq,',
'    final_approve_on,',
'    created_by_person_id,',
'    updated_by_person_id,',
'    creation_date,',
'    updated_date,',
'    reasons,',
'    spm_project_name,',
'    spm_project_id,',
'    request_type,',
'    final_reject_on,',
'    rejected_by,',
'    reject_reason,',
'    cancel_on,',
'    cancelled_by,',
'    cancel_reason,',
'    strategic_yn,',
'    from_amount,',
'    to_amount,',
'    nvl(nvl(from_amount, to_amount),0) Amount',
'FROM',
'    btf_end_users_header_v',
'Where CREATED_BY_PERSON_ID = :PERSON_ID',
'and YEAR = nvl(:P1_ACCOUNTING_YEAR, :CURRENT_YEAR)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P1_ACCOUNTING_YEAR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'EU Transfer requests'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(107458132285538196)
,p_name=>'EU Transfer requests'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>212814461476901609
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1895729306494662)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1896145144494661)
,p_db_column_name=>'REQUEST_NO'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Request No'
,p_column_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_REQUEST_ID,P8_PAGE_FROM,REQUEST_ID:#REQUEST_ID#,1,#REQUEST_ID#'
,p_column_linktext=>'#REQUEST_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1896551241494661)
,p_db_column_name=>'REQUEST_DATE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Request Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1896872669494661)
,p_db_column_name=>'REQUIRED_DATE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Required Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1897338260494661)
,p_db_column_name=>'REQUEST_STATUS'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1897766665494660)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1898111217494660)
,p_db_column_name=>'YEAR'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1898520730494660)
,p_db_column_name=>'PURPOSE_EU'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Purpose'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1898937266494660)
,p_db_column_name=>'PRIORITY'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48255921784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1899303404494660)
,p_db_column_name=>'SUBMITTED_ON'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Submitted On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1899759605494660)
,p_db_column_name=>'SUBMITTED_BY'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Submitted By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1900096013494660)
,p_db_column_name=>'SEQ'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1900495394494659)
,p_db_column_name=>'FINAL_APPROVE_ON'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Final Approve On'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1900902180494659)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1901331058494659)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1901682304494659)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1902135412494659)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1902558160494659)
,p_db_column_name=>'REASONS'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1902877246494658)
,p_db_column_name=>'SPM_PROJECT_NAME'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'SPM Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1903299346494658)
,p_db_column_name=>'SPM_PROJECT_ID'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'SPM Project'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1903677556494658)
,p_db_column_name=>'REQUEST_TYPE'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(203139147648731)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1351715949912420)
,p_db_column_name=>'FINAL_REJECT_ON'
,p_display_order=>31
,p_column_identifier=>'V'
,p_column_label=>'Final Reject On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1351806448912421)
,p_db_column_name=>'REJECTED_BY'
,p_display_order=>41
,p_column_identifier=>'W'
,p_column_label=>'Rejected By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1351935429912422)
,p_db_column_name=>'REJECT_REASON'
,p_display_order=>51
,p_column_identifier=>'X'
,p_column_label=>'Reject Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1352000945912423)
,p_db_column_name=>'CANCEL_ON'
,p_display_order=>61
,p_column_identifier=>'Y'
,p_column_label=>'Cancel On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1352077614912424)
,p_db_column_name=>'CANCELLED_BY'
,p_display_order=>71
,p_column_identifier=>'Z'
,p_column_label=>'Cancelled By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(48836004784526)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1352228673912425)
,p_db_column_name=>'CANCEL_REASON'
,p_display_order=>81
,p_column_identifier=>'AA'
,p_column_label=>'Cancel Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1352305892912426)
,p_db_column_name=>'STRATEGIC_YN'
,p_display_order=>91
,p_column_identifier=>'AB'
,p_column_label=>'Strategic?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(782922329120916)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1352390380912427)
,p_db_column_name=>'FROM_AMOUNT'
,p_display_order=>101
,p_column_identifier=>'AC'
,p_column_label=>'Deduction Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1352473428912428)
,p_db_column_name=>'TO_AMOUNT'
,p_display_order=>111
,p_column_identifier=>'AD'
,p_column_label=>'Additional Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1352645709912429)
,p_db_column_name=>'AMOUNT'
,p_display_order=>121
,p_column_identifier=>'AE'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(107467136998541793)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1072604'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUEST_NO:REQUEST_TYPE:REQUEST_DATE:PRIORITY:AMOUNT:REQUEST_STATUS:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1956357654728272)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(99855874479410836)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'New Budget Transfer'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11301138134276998)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(234705261299222439)
,p_button_name=>'All_Cost_centers'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'All Cost Centers'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:138:&SESSION.::&DEBUG.::P138_ACCOUNTING_YEAR:&P1_ACCOUNTING_YEAR.'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':IS_FBP_EMP = ''Y'' or',
':PERSON_ID = 680461'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-braille'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(639303700444376)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(99855874479410836)
,p_button_name=>'New_Project_Access'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Request Project Access'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(100819886316881294)
,p_name=>'P1_REQUEST_AMOUNT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(99855874479410836)
,p_use_cache_before_default=>'NO'
,p_source=>'SELECT trim(to_char(SUM(nvl(FROM_AMOUNT,0)), ''99,999,999,999,999.99'')) FROM btf_end_users_header_v WHERE year = :P1_ACCOUNTING_YEAR;'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(100819770603881293)
,p_name=>'P1_REQUEST_COUNT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(99855874479410836)
,p_use_cache_before_default=>'NO'
,p_source=>'SELECT trim(to_char(COUNT(REQUEST_ID), ''99,999,999,999'')) FROM btf_end_users_header_v WHERE year = :P1_ACCOUNTING_YEAR;'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(70875296851360783)
,p_name=>'P1_ACCOUNTING_YEAR'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(53929716998650294)
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
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(70875178438360782)
,p_name=>'Accounting Year Changes DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_ACCOUNTING_YEAR'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(69700931584622231)
,p_event_id=>wwv_flow_api.id(70875178438360782)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(8903188647781712)
,p_name=>'Close BA'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(234705261299222439)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(8903354635781713)
,p_event_id=>wwv_flow_api.id(8903188647781712)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(234705261299222439)
);
wwv_flow_api.component_end;
end;
/
