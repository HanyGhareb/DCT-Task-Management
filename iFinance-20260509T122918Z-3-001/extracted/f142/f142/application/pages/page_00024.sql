prompt --application/pages/page_00024
begin
--   Manifest
--     PAGE: 00024
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>142
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>24
,p_user_interface_id=>wwv_flow_api.id(159947477385220145)
,p_name=>'VO Request Details'
,p_alias=>'VO-REQUEST-DETAILS'
,p_step_title=>'VO Request Details'
,p_allow_duplicate_submissions=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>':P24_APPROVAL_STATUS not in (''Draft'' , ''Returned'' , ''Withdraw'')'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231217143232'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208533027046982247)
,p_plug_name=>'VO Request Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'VO_REQUESTS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208511269936676704)
,p_plug_name=>'Contract Details'
,p_parent_plug_id=>wwv_flow_api.id(208533027046982247)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208511656476676708)
,p_plug_name=>'Contract Details - L'
,p_parent_plug_id=>wwv_flow_api.id(208511269936676704)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208511782223676709)
,p_plug_name=>'Contract Details - R'
,p_parent_plug_id=>wwv_flow_api.id(208511269936676704)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208511319902676705)
,p_plug_name=>'Cost and Schedule prior this variation Order'
,p_parent_plug_id=>wwv_flow_api.id(208533027046982247)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208511897598676710)
,p_plug_name=>'Cost and Schedule prior this variation Order -L'
,p_parent_plug_id=>wwv_flow_api.id(208511319902676705)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208511903400676711)
,p_plug_name=>'Cost and Schedule prior this variation Order -R'
,p_parent_plug_id=>wwv_flow_api.id(208511319902676705)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208511421474676706)
,p_plug_name=>'Variation Details'
,p_parent_plug_id=>wwv_flow_api.id(208533027046982247)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--accent1:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208514298663676734)
,p_plug_name=>'Instruction'
,p_parent_plug_id=>wwv_flow_api.id(208511421474676706)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><span style="color: #3366ff;">under the terms of the above referenced Agreement, the following variation(s) is agreed:</span></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208514444225676736)
,p_plug_name=>'Variation Details 2'
,p_parent_plug_id=>wwv_flow_api.id(208511421474676706)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208511504185676707)
,p_plug_name=>'Cost Summary'
,p_parent_plug_id=>wwv_flow_api.id(208533027046982247)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208514522672676737)
,p_plug_name=>'Cost Summary Report'
,p_parent_plug_id=>wwv_flow_api.id(208511504185676707)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(159860948285220071)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       REQUEST_ID,',
'       ITEM_NAME,',
'       ITEM_DESCRIPTION,',
'       COMMENTS,',
'       STEP_NO,',
'       AMOUNT,',
'       STATUS,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON',
'  from VO_REQUESTS_COST_SUMMARY',
'  where request_id = :P24_REQUEST_ID',
'  order by id;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Cost Summary Report'
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
 p_id=>wwv_flow_api.id(208514685659676738)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.:25:P25_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_detail_link_cond=>'P24_APPROVAL_STATUS'
,p_detail_link_cond2=>'Draft'
,p_owner=>'TCA9051'
,p_internal_uid=>208514685659676738
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208514728601676739)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208514873002676740)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208514998759676741)
,p_db_column_name=>'ITEM_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Item Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208515032328676742)
,p_db_column_name=>'ITEM_DESCRIPTION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208515156435676743)
,p_db_column_name=>'COMMENTS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208515252161676744)
,p_db_column_name=>'STEP_NO'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208515336314676745)
,p_db_column_name=>'AMOUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208515489443676746)
,p_db_column_name=>'STATUS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(160313351617145412)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208515501795676747)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208515650840676748)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160254861235270033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208515783640676749)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160254861235270033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208515845341676750)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(208724729555614728)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2087248'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:ITEM_NAME:ITEM_DESCRIPTION:AMOUNT:STATUS:UPDATED_BY:UPDATED_ON:'
,p_sum_columns_on_break=>'AMOUNT'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208701339754579506)
,p_plug_name=>'Cost Summary footer'
,p_parent_plug_id=>wwv_flow_api.id(208511504185676707)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source=>'<p><span style="color: #ff0000;">Except as otherwise stated in this variation Order and / or previous variation Orders, all other terms and conditions of the above referenced Contract shall remain unchanged and in full effect.</span></p>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208512000333676712)
,p_plug_name=>'Documents'
,p_parent_plug_id=>wwv_flow_api.id(208533027046982247)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208512197243676713)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(208533027046982247)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159845881505220064)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P24_REQUEST_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208701436281579507)
,p_plug_name=>'Variation Details 3'
,p_parent_plug_id=>wwv_flow_api.id(208533027046982247)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(616926264329820378)
,p_plug_name=>'Approval History'
,p_parent_plug_id=>wwv_flow_api.id(208533027046982247)
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P24_APPROVAL_STATUS'
,p_plug_display_when_cond2=>'Draft'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(583406022728148561)
,p_plug_name=>'Approval History'
,p_parent_plug_id=>wwv_flow_api.id(616926264329820378)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--removeHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    REQUEST_ID,',
'    step_no,',
'    person_id,',
'    full_name,',
'    person_type,',
'    role_id,',
'    case on_behalf when ''Y'' then ''on-behalf '' || role_name',
'                        else role_name',
'    end role_name,',
'    action_required,',
'    recevied_date,',
'    status,',
'    action_date,',
'    comments,',
'    approval_type,',
'    created_on,',
'    created_by,',
'    updated_by,',
'    updated_on,',
'    photo_blob,',
'     reminder_count,',
'    reminder_by,',
'    (case person_type when ''INT''  Then',
'                                CASE',
'                                    WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'                                      ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || User_name',
'                                    ELSE',
'                                       ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'                                END ',
'                         when ''EXT''  Then',
'                                CASE',
'                                    WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'                                      ''https://ifinance.dct.gov.ae:8004/dct/prod/ExtUser/view/'' || User_name',
'                                    ELSE',
'                                       ''https://ifinance.dct.gov.ae:8004/dct/prod/ExtUser/view/U0000''',
'                                END',
'    End ) PHOTO',
'from (select ID,',
'       REQUEST_ID,',
'       STEP_NO,',
'       PERSON_ID,',
'       (case person_type when ''INT''  Then',
'                                (select initcap(e.full_name_en) from employees_v e where e.person_id = h.person_id)',
'                         when ''EXT''  Then',
'                                (select initcap(u.first_name || '' '' || u.last_name) from dct_ext_users u where u.user_id = h.person_id)',
'           End                      ) Full_name,',
'           ',
'       (case person_type when ''INT''  Then',
'                                (select e.user_name from employees_v e where e.person_id = h.person_id)',
'                         when ''EXT''  Then',
'                                (select u.user_name from dct_ext_users u where u.user_id = h.person_id)',
'           End                      ) User_name,    ',
'       PERSON_TYPE,',
'       ROLE_ID,',
'       (select r.role_name from project_role r where r.role_id = h.role_id) Role_Name,',
'       ACTION_REQUIRED,',
'       recevied_date + INTERVAL ''0 04:00:00.0'' DAY TO SECOND   as recevied_date ,',
'       STATUS,',
'       action_date + INTERVAL ''0 04:00:00.0'' DAY TO SECOND   as    action_date,',
'       COMMENTS,',
'       APPROVAL_TYPE,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'      nvl(h.reminder_count,0) reminder_count,',
'       h.reminder_by,',
'       (case person_type when ''INT''  Then',
'                                (select e.photo_blob from employees_v e where e.person_id = h.person_id)',
'                         when ''EXT''  Then',
'                                (select u.photo_blob from dct_ext_users u where u.user_id = h.person_id)',
'           End                      ) PHOTO_BLOB',
'      , h.on_behalf     ',
'  from vo_requests_approval_history h',
'  where request_ID = :P24_REQUEST_ID)',
'  order by step_no , id '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approval History'
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
 p_id=>wwv_flow_api.id(583406090050148562)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>583406090050148562
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211501036274018352)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211501467852018352)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211501818323018353)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211502214836018354)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211502663729018354)
,p_db_column_name=>'FULL_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Full Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211503012976018355)
,p_db_column_name=>'PERSON_TYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Person Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211503424445018356)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Role Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211503869451018357)
,p_db_column_name=>'ROLE_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Role Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211504284664018358)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211504628576018358)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211505066764018359)
,p_db_column_name=>'STATUS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211505484606018360)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211505871295018360)
,p_db_column_name=>'COMMENTS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211506223113018361)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211506610426018361)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211507075674018362)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211507408267018363)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211507816055018364)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211508226846018364)
,p_db_column_name=>'PHOTO_BLOB'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Photo Blob'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'OTHER'
,p_rpt_show_filter_lov=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211508672947018365)
,p_db_column_name=>'REMINDER_COUNT'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Reminder Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211509089747018366)
,p_db_column_name=>'REMINDER_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Reminder By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211509461836018367)
,p_db_column_name=>'PHOTO'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(583421605503158878)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2115098'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME:ROLE_NAME:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:REMINDER_COUNT:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(211510276074018369)
,p_report_id=>wwv_flow_api.id(583421605503158878)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Pending'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Pending''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#D0F1CC'
,p_row_font_color=>'#000000'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(208575213749982280)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(159872296964220075)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(159808885281220038)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(159926330718220124)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(208557455777982269)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(208575213749982280)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(208700983258579502)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(208511504185676707)
,p_button_name=>'New_COST'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Add Cost Item'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.:25:P25_REQUEST_ID:&P24_REQUEST_ID.'
,p_icon_css_classes=>'fa-plus-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(208558219747982270)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(208575213749982280)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(159924983903220123)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>':P24_REQUEST_ID is not null and :P24_APPROVAL_STATUS  in (''Draft'',''Withdraw'' , ''Return'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(208558609353982270)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(208575213749982280)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P24_REQUEST_ID is not null and :P24_APPROVAL_STATUS  in (''Draft'',''Withdraw'' , ''Return'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-save-as'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(208559010837982270)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(208575213749982280)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P24_REQUEST_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-save'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211491600524996728)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(208575213749982280)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P24_REQUEST_ID is not null and :P24_APPROVAL_STATUS  in (''Draft'',''Withdraw'' , ''Return'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>142
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211491949341997963)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(208575213749982280)
,p_button_name=>'rollback'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Rollback'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'PERSON_ID'
,p_button_condition2=>'680461'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211492232423999111)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(208575213749982280)
,p_button_name=>'Withdraw'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_REQUEST_ID,P12_ACTION:&P3_REQUEST_ID.,Withdraw'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P24_CREATED_BY = :PERSON_ID ',
'and :P24_APPROVAL_STATUS not in (''Cancel'', ''Withdraw'' , ''Draft'' , ''Approved'')'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211492510698000225)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(208575213749982280)
,p_button_name=>'CANCEL_REQUEST'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Cancel Request'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_REQUEST_ID,P12_ACTION:&P3_REQUEST_ID.,CANCEL'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P24_CREATED_BY = :PERSON_ID ',
'and :P24_APPROVAL_STATUS not in ( ''Draft'' , ''Cancel'' , ''Rejected'')'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(211493294856005104)
,p_branch_name=>'Go to Submit 28'
,p_branch_action=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_REQUEST_ID,P28_REQUEST_NO:&P24_REQUEST_ID.,&P24_REQUEST_NO.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(208559343726982270)
,p_branch_name=>'Go To Page 23'
,p_branch_action=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208512226022676714)
,p_name=>'P24_AGREEMENT_TITLE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(208511656476676708)
,p_prompt=>'Agreement Title'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208512326060676715)
,p_name=>'P24_CONTRACTING_PARTY'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(208511656476676708)
,p_prompt=>'Contracting Party'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208512416086676716)
,p_name=>'P24_AGREEMENT_REF'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(208511782223676709)
,p_prompt=>'Agreement Ref'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208512502432676717)
,p_name=>'P24_CONTRACT_STAGE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(208511782223676709)
,p_prompt=>'Contract Stage'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208513279437676724)
,p_name=>'P24_CONTRACT_VALUE_H'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(208511897598676710)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_source=>'CONTRACT_VALUE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208513412252676726)
,p_name=>'P24_APPROVED_VOS_COUNT'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(208511897598676710)
,p_prompt=>'Approved VOs (nr)'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208513544143676727)
,p_name=>'P24_APPROVED_VOS_VALUE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(208511897598676710)
,p_prompt=>'Approved VOs (Value)'
,p_post_element_text=>'<p>&nbsp; <strong>AED</strong></p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208513878475676730)
,p_name=>'P24_REVISED_CONTRACT_VALUE'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(208511897598676710)
,p_prompt=>'Revised Contract Value'
,p_post_element_text=>'<p>&nbsp; <strong>AED</strong></p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208514164132676733)
,p_name=>'P24_VO_NUM'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(208533027046982247)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'VO Number'
,p_source=>'SEQ'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208533317627982248)
,p_name=>'P24_REQUEST_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(208533027046982247)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Request Id'
,p_source=>'REQUEST_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208533789276982249)
,p_name=>'P24_REQUEST_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(208533027046982247)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Request No'
,p_source=>'REQUEST_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208534161667982249)
,p_name=>'P24_REQUEST_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(208533027046982247)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Request Date'
,p_source=>'REQUEST_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208534522201982250)
,p_name=>'P24_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(208511656476676708)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Project'
,p_source=>'PROJECT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'PROJECTS BY PERSON'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  PROJECT_NUMBER, PROJECT_NUMBER                 ||',
'                        '' (''                           || ',
'                        NVL(DCT_PROJECT_CODE,''XXX'')    ||',
'                        '')''                 DCT_PROJECT_CODE ,PROJECT_NAME',
'from project p',
'where  p.project_number in ( select PROJECT_NUMBER',
'                          from CWIP_TEAM',
'                         where 1=1',
'                         and role_id in (Select r.role_id from project_role r where r.category_id = 2)',
'                         and status = ''A''',
'                         and sysdate BETWEEN nvl(start_date , sysdate -1) and nvl(end_date, sysdate +10)',
'                         and person_type = ''INT''',
'                         and person_id = :PERSON_ID)',
'OR p.project_number in (select x.project_number ',
'from project x',
'where project_type = ''Capital''',
'and exists (select 1 ',
'            from cwip_team',
'            where cwip_team.person_id = :PERSON_ID',
'            and cwip_team.project_number is null) )    ',
'or p.project_number in (select x.project_number',
'                        from project x',
'                        where  project_type = ''Capital''',
'                        and :PERSON_ID = 680461 )',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>12
,p_field_template=>wwv_flow_api.id(159923987954220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208534975400982250)
,p_name=>'P24_CONTRACT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(208511656476676708)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Contract Number'
,p_source=>'CONTRACT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'CONTRACT BY PROJECT PAGE 24'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select cp.CONTRACT_NUMBER , cp.contract_number               ||',
'                            '' (''                             ||',
'                            NVL(c.CONTRACT_TITLE, ''XXX'') ||',
'                            '')''     contract',
'from cwip_contract_projects cp , cwip_contract c',
'where cp.contract_number = c.contract_number',
'and cp.project_number = :P24_PROJECT_NUMBER',
'order by 1'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P24_PROJECT_NUMBER'
,p_ajax_items_to_submit=>'P24_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208535345327982250)
,p_name=>'P24_CONTRACT_VALUE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(208511897598676710)
,p_prompt=>'Contract Value'
,p_post_element_text=>'<p>&nbsp; <strong>AED</strong></p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208535707473982251)
,p_name=>'P24_COMMENCEMENT_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(208511903400676711)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Commencement Date'
,p_source=>'COMMENCEMENT_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_read_only_when=>'CONTRACT_UTIL.APPROVED_VO_COUNT(:P24_CONTRACT_NUMBER)  > 0'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208536173061982251)
,p_name=>'P24_TIME_TO_COMPLET'
,p_source_data_type=>'DATE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(208511903400676711)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Time To Complet'
,p_source=>'TIME_TO_COMPLET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208536542375982251)
,p_name=>'P24_APPROVED_EXTENSION'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(208511903400676711)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Approved Extension'
,p_source=>'APPROVED_EXTENSION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208536966779982252)
,p_name=>'P24_SUBJECT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(208533027046982247)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Subject'
,p_source=>'SUBJECT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>4000
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208537340256982252)
,p_name=>'P24_DESCRIPTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(208514444225676736)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Brief Description'
,p_source=>'DESCRIPTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(159924135324220122)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208537706710982252)
,p_name=>'P24_PAYMENT_METHOD'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(208701436281579507)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Payment Method'
,p_source=>'PAYMENT_METHOD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208538131825982252)
,p_name=>'P24_SCHEDULE_IMPACT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(208701436281579507)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Schedule Impact'
,p_source=>'SCHEDULE_IMPACT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208538558350982253)
,p_name=>'P24_REVISED_COMPLETION_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(208701436281579507)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Revised Completion Date'
,p_source=>'REVISED_COMPLETION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208538967143982253)
,p_name=>'P24_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(208533027046982247)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_item_default=>'Draft'
,p_prompt=>'Approval Status'
,p_source=>'APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208539380084982253)
,p_name=>'P24_YEAR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Year'
,p_source=>'YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208539722728982253)
,p_name=>'P24_SEQ'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Seq'
,p_source=>'SEQ'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208540117525982254)
,p_name=>'P24_PRIORITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Priority'
,p_source=>'PRIORITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208540534744982254)
,p_name=>'P24_SUBMITTED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Submitted On'
,p_source=>'SUBMITTED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208541337261982254)
,p_name=>'P24_SUBMITTED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Submitted By'
,p_source=>'SUBMITTED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208541799559982255)
,p_name=>'P24_FINAL_APPROVE_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Final Approve On'
,p_source=>'FINAL_APPROVE_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208542547734982255)
,p_name=>'P24_FINAL_REJECT_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Final Reject On'
,p_source=>'FINAL_REJECT_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208543305456982262)
,p_name=>'P24_REJECTED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Rejected By'
,p_source=>'REJECTED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208543750302982262)
,p_name=>'P24_REJECT_REASON'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Reject Reason'
,p_source=>'REJECT_REASON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>2000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208544188913982262)
,p_name=>'P24_CANCEL_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Cancel On'
,p_source=>'CANCEL_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208544957276982263)
,p_name=>'P24_CANCELLED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Cancelled By'
,p_source=>'CANCELLED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208545331029982263)
,p_name=>'P24_CANCEL_REASON'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Cancel Reason'
,p_source=>'CANCEL_REASON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>2000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208545796370982263)
,p_name=>'P24_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208546187308982263)
,p_name=>'P24_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208546514621982264)
,p_name=>'P24_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Creation Date'
,p_source=>'CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208547338398982264)
,p_name=>'P24_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(208512197243676713)
,p_item_source_plug_id=>wwv_flow_api.id(208533027046982247)
,p_prompt=>'Updated Date'
,p_source=>'UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208701530980579508)
,p_name=>'P24_VALUE_OF_THIS_VO'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(208701436281579507)
,p_prompt=>'<p><strong><span style="color: #ff0000;">Value Of This VO</span></strong></p>'
,p_post_element_text=>'<p><strong><span">&nbsp; AED</span></strong></p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(208701759794579510)
,p_name=>'P24_REVISE_CONTRACT_VALUE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(208701436281579507)
,p_prompt=>'<p><span style="color: #ff0000;"><strong>Revise Contract Value Following this VO</strong></span></p>'
,p_post_element_text=>'<p><strong><span">&nbsp; AED</span></strong></p>'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(208541004279982254)
,p_validation_name=>'P24_SUBMITTED_ON must be timestamp'
,p_validation_sequence=>180
,p_validation=>'P24_SUBMITTED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(208540534744982254)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(208542274773982255)
,p_validation_name=>'P24_FINAL_APPROVE_ON must be timestamp'
,p_validation_sequence=>200
,p_validation=>'P24_FINAL_APPROVE_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(208541799559982255)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(208543031602982255)
,p_validation_name=>'P24_FINAL_REJECT_ON must be timestamp'
,p_validation_sequence=>210
,p_validation=>'P24_FINAL_REJECT_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(208542547734982255)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(208544658662982263)
,p_validation_name=>'P24_CANCEL_ON must be timestamp'
,p_validation_sequence=>240
,p_validation=>'P24_CANCEL_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(208544188913982262)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(208547039116982264)
,p_validation_name=>'P24_CREATION_DATE must be timestamp'
,p_validation_sequence=>290
,p_validation=>'P24_CREATION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(208546514621982264)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(208547833842982264)
,p_validation_name=>'P24_UPDATED_DATE must be timestamp'
,p_validation_sequence=>300
,p_validation=>'P24_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(208547338398982264)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(208512612689676718)
,p_name=>'get Contract Details DA'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P24_CONTRACT_NUMBER'
,p_condition_element=>'P24_CONTRACT_NUMBER'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208512720937676719)
,p_event_id=>wwv_flow_api.id(208512612689676718)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_AGREEMENT_TITLE'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'CONTRACT_UTIL.CONTRACT_TITLE(:P24_CONTRACT_NUMBER)'
,p_attribute_07=>'P24_CONTRACT_NUMBER'
,p_attribute_08=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>142
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208512863787676720)
,p_event_id=>wwv_flow_api.id(208512612689676718)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_CONTRACTING_PARTY'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'CONTRACT_UTIL.VENDOR_NAME(:P24_CONTRACT_NUMBER)'
,p_attribute_07=>'P24_CONTRACT_NUMBER'
,p_attribute_08=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208512940073676721)
,p_event_id=>wwv_flow_api.id(208512612689676718)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_AGREEMENT_REF'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'CONTRACT_UTIL.CONTRACT_REFERENCE(:P24_CONTRACT_NUMBER)'
,p_attribute_07=>'P24_CONTRACT_NUMBER'
,p_attribute_08=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(208513048128676722)
,p_name=>'get Contracts Amounts'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P24_CONTRACT_NUMBER'
,p_condition_element=>'P24_CONTRACT_NUMBER'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208513136856676723)
,p_event_id=>wwv_flow_api.id(208513048128676722)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_CONTRACT_VALUE_H'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'CONTRACT_UTIL.contract_amount(:P24_CONTRACT_NUMBER)'
,p_attribute_07=>'P24_CONTRACT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208513302758676725)
,p_event_id=>wwv_flow_api.id(208513048128676722)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_CONTRACT_VALUE'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'to_char(CONTRACT_UTIL.contract_amount(:P24_CONTRACT_NUMBER) , ''99,999,999,999,999.99'')'
,p_attribute_07=>'P24_CONTRACT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208513673488676728)
,p_event_id=>wwv_flow_api.id(208513048128676722)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_APPROVED_VOS_COUNT'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'CONTRACT_UTIL.APPROVED_VO_COUNT(:P24_CONTRACT_NUMBER)'
,p_attribute_07=>'P24_CONTRACT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208513759780676729)
,p_event_id=>wwv_flow_api.id(208513048128676722)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_APPROVED_VOS_VALUE'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'to_char(CONTRACT_UTIL.APPROVED_VO_AMOUNT(:P24_CONTRACT_NUMBER) , ''99,999,999,999.99'')'
,p_attribute_07=>'P24_CONTRACT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208513971129676731)
,p_event_id=>wwv_flow_api.id(208513048128676722)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_REVISED_CONTRACT_VALUE'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'to_char(CONTRACT_UTIL.contract_amount(:P24_CONTRACT_NUMBER) + CONTRACT_UTIL.APPROVED_VO_AMOUNT(:P24_CONTRACT_NUMBER) , ''99,999,999,999.99'')'
,p_attribute_07=>'P24_CONTRACT_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(208701165208579504)
,p_name=>'Cost Closed DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(208700983258579502)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208701277299579505)
,p_event_id=>wwv_flow_api.id(208701165208579504)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(208514522672676737)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208702242736579515)
,p_event_id=>wwv_flow_api.id(208701165208579504)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_VALUE_OF_THIS_VO'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(nvl(sum(amount),0) , ''99,999,999,999,999.99'')',
'from vo_requests_cost_summary',
'where request_id = :P24_REQUEST_ID;'))
,p_attribute_07=>'P24_CONTRACT_NUMBER,P24_REQUEST_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208702328692579516)
,p_event_id=>wwv_flow_api.id(208701165208579504)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_REVISE_CONTRACT_VALUE'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(',
'        nvl(sum(amount),0) ',
'    + CONTRACT_UTIL.contract_amount(:P24_CONTRACT_NUMBER) ',
'    + CONTRACT_UTIL.APPROVED_VO_AMOUNT(:P24_CONTRACT_NUMBER) , ''99,999,999,999.99'') tot',
'from vo_requests_cost_summary',
'where request_id = :P24_REQUEST_ID;'))
,p_attribute_07=>'P24_CONTRACT_NUMBER,P24_REQUEST_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(208701935681579512)
,p_name=>'Cost Summary Table Closed DA'
,p_event_sequence=>40
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(208514522672676737)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208702018316579513)
,p_event_id=>wwv_flow_api.id(208701935681579512)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(208514522672676737)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208702104739579514)
,p_event_id=>wwv_flow_api.id(208701935681579512)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_VALUE_OF_THIS_VO'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(nvl(sum(amount),0) , ''99,999,999,999,999.99'')',
'from vo_requests_cost_summary',
'where request_id = :P24_REQUEST_ID;'))
,p_attribute_07=>'P24_CONTRACT_NUMBER,P24_REQUEST_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208702418950579517)
,p_event_id=>wwv_flow_api.id(208701935681579512)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_REVISE_CONTRACT_VALUE'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(',
'        nvl(sum(amount),0) ',
'    + CONTRACT_UTIL.contract_amount(:P24_CONTRACT_NUMBER) ',
'    + CONTRACT_UTIL.APPROVED_VO_AMOUNT(:P24_CONTRACT_NUMBER) , ''99,999,999,999.99'') tot',
'from vo_requests_cost_summary',
'where request_id = :P24_REQUEST_ID;'))
,p_attribute_07=>'P24_CONTRACT_NUMBER,P24_REQUEST_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(208705612162579549)
,p_name=>'rollback Da'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(211491949341997963)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(208705792897579550)
,p_event_id=>wwv_flow_api.id(208705612162579549)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Rollback, Are you sure? '
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(211492949012005101)
,p_event_id=>wwv_flow_api.id(208705612162579549)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete from vo_requests_approval_history where request_id = :P24_REQUEST_ID;',
'',
'update vo_requests set approval_status = ''Draft'' , submitted_by = '''' , submitted_on = '''' where request_id = :P24_REQUEST_ID;'))
,p_attribute_02=>'P24_REQUEST_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(211493094132005102)
,p_event_id=>wwv_flow_api.id(208705612162579549)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Done'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(211493117081005103)
,p_event_id=>wwv_flow_api.id(208705612162579549)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(208560201271982271)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(208533027046982247)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form VO Request Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(208559804947982271)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(208533027046982247)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form VO Request Details'
);
wwv_flow_api.component_end;
end;
/
