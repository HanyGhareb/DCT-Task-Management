prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>118
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>4
,p_user_interface_id=>wwv_flow_api.id(122997627648781606)
,p_name=>'Due Transactions'
,p_alias=>'DUE-TRANSACTIONS'
,p_step_title=>'Due Transactions'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>To find data enter a search term into the search dialog, or click on the column headings to limit the records returned.</p>',
'',
'<p>You can perform numerous functions by clicking the <strong>Actions</strong> button. This includes selecting the columns that are displayed / hidden and their display sequence, plus numerous data and format functions.  You can also define additiona'
||'l views of the data using the chart, group by, and pivot options.</p>',
'',
'<p>If you want to save your customizations select report, or click download to unload the data. Enter you email address and time frame under subscription to be sent the data on a regular basis.<p>',
'',
'<p>For additional information click Help at the bottom of the Actions menu.</p> ',
'',
'<p>Click the <strong>Reset</strong> button to reset the interactive report back to the default settings.</p>'))
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220830042433'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(122543756858632125)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(122913064144781666)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(122543896283632126)
,p_plug_name=>'Due Summary'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(122911181767781667)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CUSTOMER_NUMBER, CUSTOMER_NAME, ESCALATE ,email_verified_yn , sum(AMOUNT_DUE_REMAINING) total_amount , count(TRANSACTION_NUMBER) Trx_count',
'from(',
'select adt.CUSTOMER_NUMBER,',
'       adt.CUSTOMER_NAME,',
'       adt.AMOUNT_DUE_REMAINING,',
'       adt.TRANSACTION_NUMBER,',
'       adt.TYPE_DESCRIPTION,',
'       adt.DUE_DATE,',
'       adt.CREATION_DATE,',
'       round(sysdate - adt.due_date) + 1 Days,',
'       case when round(sysdate - adt.due_date) + 1 > 180        Then ''Final''',
'            when 180 >= round(sysdate - adt.due_date) + 1 and round(sysdate - adt.due_date) + 1> 60        Then ''Official''',
'            when 60 >= round(sysdate - adt.due_date) + 1 and round(sysdate - adt.due_date) + 1> 30        Then ''Friendly''',
'            else ''NA''',
'       End Escalate,     ',
'       adt.TRUST_YN,',
'       c.email_verified_yn',
'  from AR_DUE_TRANSACTIONS adt,  customers c',
'  where adt.customer_number = c.customer_number (+) ',
'  )',
'  group by CUSTOMER_NUMBER, CUSTOMER_NAME, ESCALATE, email_verified_yn',
'  order by 3 , 4 desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Due Summary'
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
 p_id=>wwv_flow_api.id(122543970397632127)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>122543970397632127
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122544094644632128)
,p_db_column_name=>'CUSTOMER_NUMBER'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Customer Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122544158881632129)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Customer Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122544294846632130)
,p_db_column_name=>'ESCALATE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Escalate'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122544341016632131)
,p_db_column_name=>'TOTAL_AMOUNT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Total Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122545659416632144)
,p_db_column_name=>'TRX_COUNT'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Trx Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122545940716632147)
,p_db_column_name=>'EMAIL_VERIFIED_YN'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Email Verified ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(123265630952760193)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(123917129261849594)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1239172'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CUSTOMER_NUMBER:CUSTOMER_NAME:ESCALATE:TOTAL_AMOUNT:TRX_COUNT:EMAIL_VERIFIED_YN'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(123040172281781371)
,p_plug_name=>'AR Due Transactions'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(122911181767781667)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select adt.CUSTOMER_NUMBER,',
'       adt.CUSTOMER_NAME,',
'       adt.AMOUNT_DUE_REMAINING,',
'       adt.TRANSACTION_NUMBER,',
'       adt.TYPE_DESCRIPTION,',
'       adt.DUE_DATE,',
'       adt.CREATION_DATE,',
'       round(sysdate - adt.due_date) + 1 Days,',
'       case when round(sysdate - adt.due_date) + 1 > 180        Then ''Final''',
'            when 180 >= round(sysdate - adt.due_date) + ',
'            1 and round(sysdate - adt.due_date) + 1> 60        Then ''Official''',
'            when 60 >= round(sysdate - adt.due_date) + 1 ',
'            and round(sysdate - adt.due_date) + 1> 30        Then ''Friendly''',
'            else ''NA''',
'       End Escalate,  ',
'       adt.TRUST_YN,',
'       NVL(c.email_verified_yn,''N'')    email_verified_yn',
'  from AR_DUE_TRANSACTIONS adt,  customers c',
'  where adt.customer_number = c.customer_number (+)'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Due Transactions'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(123040223649781371)
,p_name=>'Due Transactions'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:5:&APP_SESSION.:::5:P5_TRANSACTION_NUMBER:\#TRANSACTION_NUMBER#\'
,p_detail_link_text=>'<span class="fa fa-edit" aria-hidden="true"></span>'
,p_detail_link_auth_scheme=>wwv_flow_api.id(123002015284781584)
,p_owner=>'TCA9051'
,p_internal_uid=>123040223649781371
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123040698783781369)
,p_db_column_name=>'CUSTOMER_NUMBER'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Customer Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123041044919781369)
,p_db_column_name=>'CUSTOMER_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Customer Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123041489917781369)
,p_db_column_name=>'AMOUNT_DUE_REMAINING'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Due Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123041856591781369)
,p_db_column_name=>'TRANSACTION_NUMBER'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Transaction Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123042235644781368)
,p_db_column_name=>'TYPE_DESCRIPTION'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Type Description'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123042611940781368)
,p_db_column_name=>'DUE_DATE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Due Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123043053658781368)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(123043472519781368)
,p_db_column_name=>'TRUST_YN'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Trust ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(123265630952760193)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122543097469632118)
,p_db_column_name=>'DAYS'
,p_display_order=>18
,p_column_identifier=>'I'
,p_column_label=>'Days'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122545729007632145)
,p_db_column_name=>'ESCALATE'
,p_display_order=>28
,p_column_identifier=>'J'
,p_column_label=>'Escalate'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(122545837643632146)
,p_db_column_name=>'EMAIL_VERIFIED_YN'
,p_display_order=>38
,p_column_identifier=>'K'
,p_column_label=>'Email Verified ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(123265630952760193)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(123081387841781303)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1230814'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CUSTOMER_NUMBER:CUSTOMER_NAME:AMOUNT_DUE_REMAINING:TRANSACTION_NUMBER:TYPE_DESCRIPTION:DUE_DATE:CREATION_DATE:TRUST_YN::DAYS:ESCALATE:EMAIL_VERIFIED_YN'
,p_sort_column_1=>'DAYS'
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(123607928071008184)
,p_application_user=>'TCA9051'
,p_name=>'Customer By Total Due and Max Days'
,p_report_seq=>10
,p_report_type=>'GROUP_BY'
,p_report_alias=>'1236080'
,p_status=>'PUBLIC'
,p_report_columns=>'CUSTOMER_NUMBER:CUSTOMER_NAME:AMOUNT_DUE_REMAINING:TRANSACTION_NUMBER:TYPE_DESCRIPTION:DUE_DATE:CREATION_DATE:TRUST_YN::DAYS'
,p_sort_column_1=>'DAYS'
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
wwv_flow_api.create_worksheet_group_by(
 p_id=>wwv_flow_api.id(123608379737008178)
,p_report_id=>wwv_flow_api.id(123607928071008184)
,p_group_by_columns=>'CUSTOMER_NAME'
,p_function_01=>'SUM'
,p_function_column_01=>'AMOUNT_DUE_REMAINING'
,p_function_db_column_name_01=>'APXWS_GBFC_01'
,p_function_label_01=>'Total Due'
,p_function_format_mask_01=>'999G999G999G999G990D00'
,p_function_sum_01=>'N'
,p_function_02=>'MAX'
,p_function_column_02=>'DAYS'
,p_function_db_column_name_02=>'APXWS_GBFC_02'
,p_function_label_02=>'Max Days'
,p_function_format_mask_02=>'999G999G999G999G999G999G990'
,p_function_sum_02=>'N'
,p_sort_column_01=>'APXWS_GBFC_01'
,p_sort_direction_01=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(123044651776781364)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(122922476001781663)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(122859041536781706)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(122976593233781628)
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(123043883607781364)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(123040172281781371)
,p_button_name=>'RESET_REPORT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(122975280422781629)
,p_button_image_alt=>'Reset'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:RR::'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(123046448041781363)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(123040172281781371)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(122975103376781629)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5'
,p_button_condition_type=>'NEVER'
,p_security_scheme=>wwv_flow_api.id(123002015284781584)
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(122543680730632124)
,p_name=>'P4_SHOW'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(122543756858632125)
,p_item_default=>'S'
,p_prompt=>'Show Details'
,p_display_as=>'NATIVE_YES_NO'
,p_grid_column=>10
,p_field_template=>wwv_flow_api.id(122974014211781630)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'D'
,p_attribute_03=>'Details'
,p_attribute_04=>'S'
,p_attribute_05=>'Summary'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(123045592148781363)
,p_name=>'Edit Report - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(123040172281781371)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(123046048343781363)
,p_event_id=>wwv_flow_api.id(123045592148781363)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(123040172281781371)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(122544470007632132)
,p_name=>'SHow DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_SHOW'
,p_condition_element=>'P4_SHOW'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'S'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(122544532621632133)
,p_event_id=>wwv_flow_api.id(122544470007632132)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(122543896283632126)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(122544848642632136)
,p_event_id=>wwv_flow_api.id(122544470007632132)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(123040172281781371)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(122544686220632134)
,p_event_id=>wwv_flow_api.id(122544470007632132)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(123040172281781371)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(122544736687632135)
,p_event_id=>wwv_flow_api.id(122544470007632132)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(122543896283632126)
);
wwv_flow_api.component_end;
end;
/
