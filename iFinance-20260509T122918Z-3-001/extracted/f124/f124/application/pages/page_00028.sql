prompt --application/pages/page_00028
begin
--   Manifest
--     PAGE: 00028
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>28
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'APPENDIX A - SCOPE OF WORK'
,p_alias=>'APPENDIX-A-SCOPE-OF-WORK'
,p_step_title=>'APPENDIX A - SCOPE OF WORK'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_api.id(127761711380449835)
,p_page_template_options=>'#DEFAULT#'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>':P28_REVIEW_STATUS not in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240229084010'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3051100879104375)
,p_plug_name=>'Collabouration'
,p_icon_css_classes=>'fa-envelope-edit'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3051686172104381)
,p_plug_name=>'History'
,p_parent_plug_id=>wwv_flow_api.id(3051100879104375)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(276632822872682748)
,p_name=>'Comments Report'
,p_parent_plug_id=>wwv_flow_api.id(3051686172104381)
,p_template=>wwv_flow_api.id(127776395121449810)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Form--slimPadding:t-Form--large'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  ',
'        CASE',
'            WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(user_name)',
'     End   user_icon,',
'  updated_date  comment_date,',
'  full_name_en user_name,',
'  comment_text                    comment_text,',
'  null comment_modifiers,',
'   ''u-color-''||ora_hash(user_name,45) icon_modifier,',
'  ACTION     actions,',
'  ''''     attribute_1,',
'  ''''     attribute_2,',
'  ''''    attribute_3,',
'  sys.dbms_lob.getlength(file_blob)     attribute_4,',
'  comment_id,',
'  filename',
'  --',
',(Select e.full_name_en',
'                    from employees_v e',
'                    where e.person_id = comment_to_person_id)',
'         Comment_to',
'--',
'from   ',
'(SELECT',
'    c.comment_id,',
'    c.ITEM_ID,',
'    c.comment_text,',
'    c.created_by,',
'    c.updated_by,',
'    c.creation_date,',
'    c.updated_date,',
'    c.action        action,',
'    e.full_name_en,',
'    e.user_name,',
'    e.photo_blob,',
'    c.filename,',
'    c.file_blob,',
'    c.comment_to_person_id',
'FROM',
'    dp_items_comments c , dct_employees_list2 e',
'where c.updated_by = e.person_id',
')',
'where ITEM_ID = :P28_DP_ITEM_ID',
'order by CREATION_DATE desc;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P28_DP_ITEM_ID'
,p_query_row_template=>wwv_flow_api.id(127832693224449762)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Communications yet.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3398346850619179)
,p_query_column_id=>1
,p_column_alias=>'USER_ICON'
,p_column_display_sequence=>1
,p_column_heading=>'User Icon'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<img src="#USER_ICON#" alt="Image Not Found" height="40" width="40">'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3398796725619179)
,p_query_column_id=>2
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>2
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_column_html_expression=>'<br>#COMMENT_DATE#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3399145487619179)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span style="color:red">From: #USER_NAME# </span>'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3403543986619182)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Text'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.::P17_COMMENT_ID:#COMMENT_ID#'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3399602115619179)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3399972812619180)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3400379132619180)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3400797574619180)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3401175190619180)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3401630116619181)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3401984916619181)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3402419600619181)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>12
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3402773981619181)
,p_query_column_id=>13
,p_column_alias=>'FILENAME'
,p_column_display_sequence=>13
,p_column_heading=>'Filename'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3403172774619181)
,p_query_column_id=>14
,p_column_alias=>'COMMENT_TO'
,p_column_display_sequence=>14
,p_column_heading=>'Comment To'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(137979888839452593)
,p_plug_name=>'APPENDIX A - SCOPE OF WORK'
,p_region_template_options=>'#DEFAULT#:t-Wizard--showTitle:t-Wizard--hideStepsXSmall'
,p_component_template_options=>'#DEFAULT#:js-wizardProgressLinks:t-WizardSteps--displayLabels'
,p_plug_template=>wwv_flow_api.id(127814120729449775)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(137979330732452596)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(127843097216449755)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(137979994121452593)
,p_plug_name=>'APPENDIX A - SCOPE OF WORK'
,p_parent_plug_id=>wwv_flow_api.id(137979888839452593)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127776395121449810)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3012519613758547)
,p_plug_name=>'Approval History'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent13:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>170
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P28_REVIEW_STATUS != ''Draft'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3048744561104352)
,p_plug_name=>'Approval History Report'
,p_parent_plug_id=>wwv_flow_api.id(3012519613758547)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    h.id,',
'    h.request_id,',
'    h.step_no,',
'    h.person_id,',
'    h.role_id,',
'    h.role_desc,',
'    h.action_required,',
'    h.recevied_date,',
'    h.status,',
'    h.action_date,',
'    h.comments,',
'    h.approval_type,',
'    case h.status',
'        When ''Rejected'' Then ''u-danger-text''',
'        when ''Approved'' Then ''u-success''',
'        When ''Accepted'' Then ''u-success''',
'    End status_class,',
'       ',
'    e.full_name_en || ''('' || e.user_name || '')'' as full_name_en,',
'    case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'       when 0  THEN',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'        else  ',
'            ',
'         ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'       end Photo',
'FROM',
'    DP_SCOPING_APPROVAL_HISTORY h, dct_employees_list2  e',
'where h.person_id = e.person_id (+)',
'and h.request_id = :P28_SCOPE_ID',
'and h.status != ''Beaten''',
'order by h.STEP_NO ',
'--, h.ID',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Approval History Report'
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
 p_id=>wwv_flow_api.id(3048846698104353)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>147251015672160317
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3048996483104354)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3049106708104355)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3049195527104356)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3049311869104357)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3049409759104358)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(129038068099971033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3049504744104359)
,p_db_column_name=>'ROLE_DESC'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Desc'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3049610100104360)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3049692355104361)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3049763913104362)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3049849365104363)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3049935316104364)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3050056983104365)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3050182281104366)
,p_db_column_name=>'STATUS_CLASS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3050252067104367)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3050400180104368)
,p_db_column_name=>'PHOTO'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(3339779946433811)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1475420'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:ROLE_ID:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'PERSON_ID'
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
 p_id=>wwv_flow_api.id(103387385162973450)
,p_report_id=>wwv_flow_api.id(3339779946433811)
,p_name=>'Pending'
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
 p_id=>wwv_flow_api.id(136202291067004043)
,p_plug_name=>'Project Overview'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,1) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138255567654279218)
,p_plug_name=>'Project Overview'
,p_parent_plug_id=>wwv_flow_api.id(136202291067004043)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'PLSQL_EXPRESSION'
,p_plug_read_only_when=>':P28_REVIEW_STATUS not in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2238584426188048)
,p_plug_name=>'DCT_REPRESENTATIVES_AND_SUPPORT REGION'
,p_parent_plug_id=>wwv_flow_api.id(138255567654279218)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(136202564981004046)
,p_plug_name=>'Requirements Overview'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,2) = ''Y'' and 1 = 2'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138255629478279219)
,p_plug_name=>'Requirements Overview'
,p_parent_plug_id=>wwv_flow_api.id(136202564981004046)
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138130771932298942)
,p_plug_name=>'Enquires and Contact Procedure'
,p_parent_plug_id=>wwv_flow_api.id(138255629478279219)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_plug_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This section is removed as per UAT Session1 on 30-Jan-23 (Tim, Swati, Tamer)',
'Server Side Condition used: DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,41) = ''Y''  '))
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138130833733298943)
,p_plug_name=>'Enquires and Contact Procedure Report'
,p_parent_plug_id=>wwv_flow_api.id(138130771932298942)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_A_ID,',
'       NAME,',
'       POSITION,',
'       EMAIL,',
'       PHONE_NO,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE',
'  from DP_SCOPING_A_ENQUIRES_CONTACT_PROC',
'  where DP_SCOPING_A_ID = :P28_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Enquires and Contact Procedure Report'
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
 p_id=>wwv_flow_api.id(138131082386298945)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Enquires and Contact Procedure available'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_control_break=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_show_help=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:52:&SESSION.::&DEBUG.::P52_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>138131082386298945
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138131179993298946)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138131294202298947)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138131379389298948)
,p_db_column_name=>'NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138131408769298949)
,p_db_column_name=>'POSITION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Position'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138131594931298950)
,p_db_column_name=>'EMAIL'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138156966378068401)
,p_db_column_name=>'PHONE_NO'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Phone No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138157086688068402)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138157154195068403)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138157233476068404)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138157359920068405)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(138169268991053625)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1381693'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'NAME:POSITION:EMAIL:PHONE_NO:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138157573306068407)
,p_plug_name=>'Objectives and Benefits to DCT'
,p_parent_plug_id=>wwv_flow_api.id(138255629478279219)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,61) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138157724241068409)
,p_plug_name=>'Objectives and Benefits to DCT Report'
,p_parent_plug_id=>wwv_flow_api.id(138157573306068407)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_A_ID,',
'       RECORD_TYPE,',
'       DESCRIPTION,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE,',
'       DELETED_FLAG',
'  from DP_SCOPING_A_OBJECTIVES_BENEFITS',
'  where DP_SCOPING_A_ID = :P28_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Objectives and Benefits to DCT Report'
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
 p_id=>wwv_flow_api.id(138157844598068410)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Objectives and Benefits to DCT available'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:55:&SESSION.::&DEBUG.::P55_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>138157844598068410
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138157926179068411)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138158039146068412)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138158116070068413)
,p_db_column_name=>'RECORD_TYPE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Objective / Benefit'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(144021439796014080)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138158204785068414)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138158332071068415)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138158474084068416)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138158540333068417)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138158691606068418)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138158772568068419)
,p_db_column_name=>'DELETED_FLAG'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Deleted Flag'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(138179683351014559)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1381797'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'RECORD_TYPE:DESCRIPTION:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(136202906132004050)
,p_plug_name=>'Timelines'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,3) = ''Y'' and',
'(:P28_EXPECTED_START_DATE is not null or ',
':P28_EXPECTED_END_DATE is not null or ',
':P28_TENDER_START_DATE is not null or ',
':P28_EXPECTED_CONTRACT_START_DATE is not null or ',
':P28_DURATION_COMMENTS is not null)'))
,p_plug_read_only_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_read_only_when=>'IS_PBP_EMP'
,p_plug_read_only_when2=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138255759230279220)
,p_plug_name=>'Timelines'
,p_parent_plug_id=>wwv_flow_api.id(136202906132004050)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'ALWAYS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138108749663338004)
,p_plug_name=>'Procurement Awarding Method'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,4) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138109180396338008)
,p_plug_name=>'Scope of Services'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,5) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3050624650104370)
,p_plug_name=>'Guidance'
,p_parent_plug_id=>wwv_flow_api.id(138109180396338008)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3050821460104372)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_api.id(138109180396338008)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138109536810338012)
,p_plug_name=>'Required Deliverables'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,6) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138159174650068423)
,p_plug_name=>'Required Deliverables Report'
,p_parent_plug_id=>wwv_flow_api.id(138109536810338012)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_A_ID,',
'       DELIVERABLE_DESCRIPTION,',
'       DELIVERABLE_WEIGHT,',
'       DATE_DEFINED_YN,',
'       MILESTONE_DUE_DATE,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE,',
'        FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from DP_SCOPING_A_DELIVERABLES',
'  where DP_SCOPING_A_ID = :P28_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Required Deliverables Report'
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
 p_id=>wwv_flow_api.id(138159281937068424)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Deliverables Available.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_control_break=>'N'
,p_show_flashback=>'N'
,p_show_help=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.::P33_ID,P33_DP_SCOPING_A_ID:#ID#,#DP_SCOPING_A_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>138159281937068424
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138159331039068425)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138159479269068426)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138159542932068427)
,p_db_column_name=>'DELIVERABLE_DESCRIPTION'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Deliverable Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138159692792068428)
,p_db_column_name=>'DELIVERABLE_WEIGHT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Weight'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138159704594068429)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138159899382068430)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138159949263068431)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138160043598068432)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1678868860295845)
,p_db_column_name=>'FILENAME'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'File Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1679029085295846)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1679072262295847)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1679179440295848)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1679247388295849)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'File Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1679419583295850)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1679446429295851)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:DP_SCOPING_A_DELIVERABLES:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:FILE_UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1679691705295853)
,p_db_column_name=>'DATE_DEFINED_YN'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Milestone Defined ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_api.id(128345817677489797)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1679740623295854)
,p_db_column_name=>'MILESTONE_DUE_DATE'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Milestone Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(138198317176203344)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1381984'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DELIVERABLE_DESCRIPTION:DATE_DEFINED_YN:MILESTONE_DUE_DATE:FILENAME:FILE_COMMENTS:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138109949499338016)
,p_plug_name=>'Performance Measurements'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,7) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138160344216068435)
,p_plug_name=>'Performance Measurements Report'
,p_parent_plug_id=>wwv_flow_api.id(138109949499338016)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select KPI_ID,',
'       DP_SCOPING_A_ID,',
'       KPI_NAME,',
'       KPI_DESCRIPTION,',
'       TARGET_VALUE,',
'       TARGET_DATE,',
'       TREND_DIRECTION,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE,',
'       METHOD_OF_MEASURE,',
'       SERVICE_CREDIT',
'  from DP_SCOPING_A_KPI',
'  where DP_SCOPING_A_ID = :P28_SCOPE_ID',
'  order by KPI_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Performance Measurements Report'
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
 p_id=>wwv_flow_api.id(138160461982068436)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Performance Measurements available.'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_control_break=>'N'
,p_show_computation=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.:34:P34_KPI_ID:#KPI_ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>138160461982068436
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138160572441068437)
,p_db_column_name=>'KPI_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Kpi Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138160636163068438)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138160760242068439)
,p_db_column_name=>'KPI_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'KPI Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138160853296068440)
,p_db_column_name=>'KPI_DESCRIPTION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138160966568068441)
,p_db_column_name=>'TARGET_VALUE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Target Value'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138161024874068442)
,p_db_column_name=>'TARGET_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Target Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138161197560068443)
,p_db_column_name=>'TREND_DIRECTION'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Trend Direction'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138161229667068444)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138161351123068445)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138161488817068446)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138161578854068447)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1680117855295857)
,p_db_column_name=>'METHOD_OF_MEASURE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Method Of Measure'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1680221408295858)
,p_db_column_name=>'SERVICE_CREDIT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Service Credit'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(138207147025177790)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1382072'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'KPI_NAME:KPI_DESCRIPTION:METHOD_OF_MEASURE:SERVICE_CREDIT:TARGET_VALUE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138110384396338020)
,p_plug_name=>'Supplier Responsibilities'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,8) = ''Y'' and 1 = 2'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138161641022068448)
,p_plug_name=>'Supplier Responsibilities Report'
,p_parent_plug_id=>wwv_flow_api.id(138110384396338020)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_A_ID,',
'       RESPONSIBILITY_NAME,',
'       RESPONSIBILITY_DATE,',
'       DFF1,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE',
'  from DP_SCOPING_A_SUPPLIER_RESP',
'  where DP_SCOPING_A_ID = :P28_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Supplier Responsibilities Report'
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
 p_id=>wwv_flow_api.id(138161754870068449)
,p_max_row_count=>'1000000'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.:35:P35_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>138161754870068449
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138161868378068450)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138207776842169701)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138207880542169702)
,p_db_column_name=>'RESPONSIBILITY_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Responsibility Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138207905299169703)
,p_db_column_name=>'RESPONSIBILITY_DATE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Responsibility Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138208086908169704)
,p_db_column_name=>'DFF1'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Dff1'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138208125013169705)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138208264542169706)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138208375475169707)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138208423787169708)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(138217137834156835)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1382172'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'RESPONSIBILITY_NAME:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138110722318338024)
,p_plug_name=>'Proposal Submission Requirements'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>90
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,9) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138208662511169710)
,p_plug_name=>'Proposal Submission Requirements Report'
,p_parent_plug_id=>wwv_flow_api.id(138110722318338024)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders:js-showMaximizeButton'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_A_ID,',
'       REQUIREMENT_NAME,',
'       REQUIREMENT_DESC,',
'       REQUIREMENT_TARGET,',
'       REQUIREMENT_DATE,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE',
'  from DP_SCOPING_A_PROPOSAL_SUBMISSION_REQ',
'  where DP_SCOPING_A_ID = :P28_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Proposal Submission Requirements Report'
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
 p_id=>wwv_flow_api.id(138208710274169711)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Proposal Submission Requirements Available'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.:36:P36_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>138208710274169711
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138208842713169712)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138208940046169713)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138209083372169714)
,p_db_column_name=>'REQUIREMENT_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Requirement Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138209117847169715)
,p_db_column_name=>'REQUIREMENT_DESC'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138209249969169716)
,p_db_column_name=>'REQUIREMENT_TARGET'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Requirement Target'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138209364282169717)
,p_db_column_name=>'REQUIREMENT_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Requirement Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138209402894169718)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138209561027169719)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138209632396169720)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138209727347169721)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(138229622409049868)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1382297'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REQUIREMENT_NAME:REQUIREMENT_DESC:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138111199620338028)
,p_plug_name=>'Security Requirements'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>100
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,10) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138209993920169723)
,p_plug_name=>'Security Requirements Report'
,p_parent_plug_id=>wwv_flow_api.id(138111199620338028)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_A_ID,',
'       SECURITY_REQ,',
'       PRIORITY,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE',
'  from DP_SCOPING_A_SECURITY_REQ',
'  where DP_SCOPING_A_ID =  :P28_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Security Requirements Report'
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
 p_id=>wwv_flow_api.id(138210001239169724)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Security Requirements defined'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.:37:P37_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_owner=>'TCA9051'
,p_internal_uid=>138210001239169724
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138210188185169725)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138210258980169726)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138210393881169727)
,p_db_column_name=>'SECURITY_REQ'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Security Requirement'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138210463015169728)
,p_db_column_name=>'PRIORITY'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Priority'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(128341720324489799)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138210543990169729)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138210642635169730)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138210775697169731)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138210883172169732)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(138233146691033413)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1382332'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECURITY_REQ:PRIORITY:UPDATED_BY:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138111552525338032)
,p_plug_name=>'Data Capture Requirements'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>110
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,11) = ''Y'' and 1 = 2'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138211082170169734)
,p_plug_name=>'Data Capture Requirements Report'
,p_parent_plug_id=>wwv_flow_api.id(138111552525338032)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders:js-showMaximizeButton'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       DP_SCOPING_A_ID,',
'       DATA_REQUIREMENT,',
'       DESCRIPTIONS,',
'       CREATED_BY,',
'       CREATION_DATE,',
'       UPDATED_BY,',
'       UPDATED_DATE',
'  from DP_SCOPING_A_DATA_CAPTURE_REQ',
'  where DP_SCOPING_A_ID = :P28_SCOPE_ID',
'  order by ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Data Capture Requirements Report'
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
 p_id=>wwv_flow_api.id(138211116069169735)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Data Capture Requirements Defined'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:38:&SESSION.::&DEBUG.:38:P38_ID:#ID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>138211116069169735
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138211279401169736)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138211391162169737)
,p_db_column_name=>'DP_SCOPING_A_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dp Scoping A Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138211475667169738)
,p_db_column_name=>'DATA_REQUIREMENT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Data Requirement'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138211513695169739)
,p_db_column_name=>'DESCRIPTIONS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138211645470169740)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138211739673169741)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138211811661169742)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138211948994169743)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(138237208984986835)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1382373'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:DP_SCOPING_A_ID:DATA_REQUIREMENT:DESCRIPTIONS:CREATED_BY:CREATION_DATE:UPDATED_BY:UPDATED_DATE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138111997574338036)
,p_plug_name=>'Intellectual Property/Copyrights of Work'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>120
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,12) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138112305415338040)
,p_plug_name=>'Reporting & Communication Requirements'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>130
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,13) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138112732905338044)
,p_plug_name=>'Added Value Offerings'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>140
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,14) = ''Y'' and 1 = 2'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138113128934338048)
,p_plug_name=>'Attachments and Supporting Documents'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody:t-Region--noPadding'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>150
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>'DP_SCOPING_UTIL.show_region_yn(''A'' , :P28_TEMPLATE_ID,15) = ''Y'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(266884857592980122)
,p_plug_name=>'Documents'
,p_parent_plug_id=>wwv_flow_api.id(138113128934338048)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(266991145250545589)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(266884857592980122)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(127801801541449780)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       SCOPING_ID,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       TAGS,',
'       SCOPING_APPENDIX,',
'       SCOPING_COMPONENT,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY,',
'       COMMENT_ID,',
'      sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from DP_SCOPING_DOCUMENTS',
'  where SCOPING_ID = :P28_SCOPE_ID',
'    order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_SCOPE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Documents report'
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
 p_id=>wwv_flow_api.id(266991287409545590)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>266991287409545590
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138241901565308078)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138242281994308078)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138243006481308077)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:56:&SESSION.::&DEBUG.::P56_ID,P56_PAGE_FROM:#ID#,28'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138243432480308077)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138243808683308077)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138244225546308077)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138244686065308077)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138245052945308076)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138245426335308076)
,p_db_column_name=>'CREATED'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138245883013308076)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138246207099308076)
,p_db_column_name=>'UPDATED'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138246696538308076)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(128328640271489809)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138247069968308075)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138247417586308075)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138247862173308075)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:DP_SCOPING_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138212456716169748)
,p_db_column_name=>'SCOPING_ID'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Scoping Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138212546252169749)
,p_db_column_name=>'SCOPING_APPENDIX'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Scoping Appendix'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(138212627359169750)
,p_db_column_name=>'SCOPING_COMPONENT'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Scoping Component'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(267016800113260757)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1382482'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(138253887822279201)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(137979994121452593)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>160
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(140457692251095036)
,p_plug_name=>'Demand Planning Item Details'
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127786760621449799)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(2238075835188043)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(138255629478279219)
,p_button_name=>'PROJECT_OVERVIEW_HELP_BTN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Introduction Help'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_TEMPLATE_ID,P42_DATA_POINT_ID:Requirement Overview,&P28_TEMPLATE_ID.,10'
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'Y'
,p_grid_column=>12
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(2238693606188049)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(2238584426188048)
,p_button_name=>'DCT_REPRESENTATIVES_AND_SUPPORT_HELP_BTN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'DCT Representatives and Support'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_TEMPLATE_ID,P42_DATA_POINT_ID:DCT Representatives and Support,&P28_TEMPLATE_ID.,9'
,p_button_condition=>'1 = 2'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'Y'
,p_grid_column=>12
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3047520649104339)
,p_button_sequence=>230
,p_button_plug_id=>wwv_flow_api.id(138255567654279218)
,p_button_name=>'LOCATION_OF_WORK_BTN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Location of Work Help'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_TEMPLATE_ID,P42_DATA_POINT_ID:Location of Work Guidance,&P28_TEMPLATE_ID.,6'
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'N'
,p_grid_column=>12
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3047391914104338)
,p_button_sequence=>270
,p_button_plug_id=>wwv_flow_api.id(138255567654279218)
,p_button_name=>'LANGUAGE_OF_WORK_BTN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_TEMPLATE_ID,P42_DATA_POINT_ID:Language of Work Guidance,&P28_TEMPLATE_ID.,7'
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'N'
,p_grid_column=>6
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3047321465104337)
,p_button_sequence=>310
,p_button_plug_id=>wwv_flow_api.id(138255567654279218)
,p_button_name=>'PROVISION_OF_SERVICES_HELP_BTN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Provision of Services Help'
,p_button_position=>'BODY'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_TEMPLATE_ID,P42_DATA_POINT_ID:Provision of Service Guidance,&P28_TEMPLATE_ID.,8'
,p_button_condition=>'1=2'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'Y'
,p_grid_column=>12
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(137981625938452590)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(137979888839452593)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865952197449732)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3404127002621513)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(3051686172104381)
,p_button_name=>'AddComment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Collaborate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.::P17_ITEM_ID:&P28_DP_ITEM_ID.'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(138157407726068406)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138130771932298942)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:52:&SESSION.::&DEBUG.:52:P52_DP_SCOPING_A_ID:&P28_SCOPE_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(138241269089308081)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(266884857592980122)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:56:&SESSION.::&DEBUG.::P56_SCOPING_ID,P56_PAGE_FROM,P56_SCOPING_APPENDIX:&P28_SCOPE_ID.,28,A'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139273746577859336)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(136202291067004043)
,p_button_name=>'PROJECT_OVERVIEW_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Project Overview Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Project Overview,1'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139274611930859345)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138111552525338032)
,p_button_name=>'DATA_CAPTURE_REQUIREMENTS_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Data Capture Requirements,11'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139274705027859346)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138111199620338028)
,p_button_name=>'Security_Requirement_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Security Requirements,10'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139274869000859347)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138110722318338024)
,p_button_name=>'PROPOSAL_SUBMISSION'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Proposal Submission Requirements,9'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139274989947859348)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138110384396338020)
,p_button_name=>'SUPPLIER_RESPONSIBILITIES_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Supplier Responsibilities,8'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139275099197859349)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138109949499338016)
,p_button_name=>'PERFORMANCE_MEASUREMENTS_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Performance Measurements,7'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139275164342859350)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138109536810338012)
,p_button_name=>'REQUIRED_DELIVERABLES_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Required Deliverables,6'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139347254244743101)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138109180396338008)
,p_button_name=>'SCOPE_OF_SERVICES_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Scope of Services,5'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139347381016743102)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138108749663338004)
,p_button_name=>'SUBMISSION_INFORMATION_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Submission Information,4'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139347432948743103)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(136202906132004050)
,p_button_name=>'TIMELINES_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Timelines,3'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139347532314743104)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(136202564981004046)
,p_button_name=>'REQUIREMENTS_OVERVIEW_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Requirements Overview,2'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139347670489743105)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138111997574338036)
,p_button_name=>'INTELLECTUAL_PROPERTY'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Intellectual Property/Copyrights of Work,12'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139347714073743106)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138112305415338040)
,p_button_name=>'REPORTING_COM_REQ_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Reporting & Communication Requirements,13'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139347885941743107)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138112732905338044)
,p_button_name=>'ADDED_VALUE_OFFERINGS_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Added Value Offerings,14'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(139347930886743108)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(138113128934338048)
,p_button_name=>'ATT_SUPP_DOCS_HELP'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--small:t-Button--primary:t-Button--link:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Help'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:42:P42_LABEL,P42_COMPONENT_ID:Attachments and Supporting Documents,15'
,p_icon_css_classes=>'fa-question-circle-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(138157667455068408)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(138157573306068407)
,p_button_name=>'Add_O'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:55:&SESSION.::&DEBUG.:55:P55_DP_SCOPING_A_ID:&P28_SCOPE_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(138160190735068433)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(138109536810338012)
,p_button_name=>'New_deliverable'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'New Deliverable'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.::P33_DP_SCOPING_A_ID:&P28_SCOPE_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(138160200285068434)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(138109949499338016)
,p_button_name=>'New_KPI'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'New KPI'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.::P34_DP_SCOPING_A_ID:&P28_SCOPE_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(138208598242169709)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(138110384396338020)
,p_button_name=>'Add_Resp'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.:35:P35_DP_SCOPING_A_ID:&P28_SCOPE_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(138209858931169722)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(138110722318338024)
,p_button_name=>'Add_Requirement'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add Requirement'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.:36:P36_DP_SCOPING_A_ID:&P28_SCOPE_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(138210995159169733)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(138111199620338028)
,p_button_name=>'New_Security_Requirement'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'New Security Requirement'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.:37:P37_DP_SCOPING_A_ID:&P28_SCOPE_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(138212022721169744)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(138111552525338032)
,p_button_name=>'New_Data_Capture'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'New Data Capture'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:38:&SESSION.::&DEBUG.:38:P38_DP_SCOPING_A_ID:&P28_SCOPE_ID.'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(143586730419562437)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(137979888839452593)
,p_button_name=>'Expand_All'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865263253449733)
,p_button_image_alt=>'Expand All'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-expand-collapse'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(137981941266452589)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(137979888839452593)
,p_button_name=>'NEXT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_icon_css_classes=>'fa-chevron-right'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(143585529428562425)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(137979888839452593)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(127865952197449732)
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>':P28_REVIEW_STATUS in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3667248869973238)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(137979888839452593)
,p_button_name=>'CREATE_PR'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Create PR'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:71:&SESSION.::&DEBUG.:::'
,p_button_condition=>':P28_REVIEW_STATUS = ''Reviewed'' and :P28_APPROVAL_STATUS = ''Approved'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-credit-card-terminal'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(137982628990452588)
,p_branch_name=>'Go To Page 29'
,p_branch_action=>'f?p=&APP_ID.:29:&SESSION.::&DEBUG.::P29_SCOPE_ID,P29_TEMPLATE_ID,P29_ITEM_ID:&P28_SCOPE_ID.,&P28_TEMPLATE_ID.,&P28_DP_ITEM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(137981941266452589)
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(509038987373628185)
,p_name=>'P28_PROCUREMENT_METHOD'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(140457692251095036)
,p_prompt=>'Procurement Method'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'DP PROCUREMENT METHOD-ALL'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select TENDER_TYPE , ID',
' from DP_PROCUREMENT_METHOD'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(509038818030628183)
,p_name=>'P28_PROCUREMENT_METHOD_CLASS_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(137979888839452593)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(679262498236373)
,p_name=>'P28_REVIEW_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(140457692251095036)
,p_prompt=>'Review Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(679366861236374)
,p_name=>'P28_APPROVAL_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(140457692251095036)
,p_prompt=>'Approval Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(680296856236383)
,p_name=>'P28_EXPECTED_CONTRACT_START_DATE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(138255759230279220)
,p_prompt=>'Expected Contract Start Date'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(680399653236384)
,p_name=>'P28_EXPECTED_CONTRACT_END_DATE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(138255759230279220)
,p_prompt=>'Expected Contract End Date'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1682694881295883)
,p_name=>'P28_SELECTION_CRITERIA'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(138108749663338004)
,p_prompt=>'Selection Criteria'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'MPR PROCUREMENT METHODS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select MPR_PROCUREMENT_METHODS.PROCUREMENT_METHOD_NAME as PROCUREMENT_METHOD_NAME,',
'    MPR_PROCUREMENT_METHODS.ID as ID ',
' from MPR_PROCUREMENT_METHODS MPR_PROCUREMENT_METHODS'))
,p_read_only_when=>':P28_REVIEW_STATUS not in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2597879717041938)
,p_name=>'P28_TECH_PCT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(138108749663338004)
,p_prompt=>'Technical'
,p_post_element_text=>'%'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>5
,p_begin_on_new_line=>'N'
,p_grid_column=>8
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2598028065041939)
,p_name=>'P28_COMM_PCT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(138108749663338004)
,p_prompt=>'Commercial'
,p_post_element_text=>'%'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>5
,p_begin_on_new_line=>'N'
,p_grid_column=>10
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(136202345555004044)
,p_name=>'P28_PROVISION_OF_SERVICES'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P28_TEMPLATE_ID ,  8 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Summary of requirements'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN( ''A'' , :P28_TEMPLATE_ID ,  8 ) = ''Y'' and 1 = 2'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_item_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'&P28_PROVISION_OF_SERVICES_HELP.',
'&P28_PROVISION_OF_SERVICES_LABEL.'))
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(136202431811004045)
,p_name=>'P28_DATE_REQUIRED'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_prompt=>'&P28_DATE_REQUIRED_LABEL.'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  2) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'&P28_DATE_REQUIRED_HELP.'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(137981314167452590)
,p_name=>'P28_PROJECT_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_prompt=>'&P28_PROJECT_NAME_LABEL.'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN( ''A'' , :P28_TEMPLATE_ID ,  1 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138108419665338001)
,p_name=>'P28_EXPECTED_START_DATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138255759230279220)
,p_prompt=>'Expected Contract Start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  13 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138108501952338002)
,p_name=>'P28_DURATION_COMMENTS'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(138255759230279220)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P28_TEMPLATE_ID ,  17 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Duration Comments'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  17 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138108803655338005)
,p_name=>'P28_TECHNICAL_SUBMISSION_ID'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(138108749663338004)
,p_prompt=>'Submission Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TECHNICAL SUBMISSION LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id from DCT_LOOKUP_VALUES where lookup_id = 51 and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  18 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
,p_item_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'&P28_TECHNICAL_SUBMISSION_ID_HELP.',
'&P28_TECHNICAL_SUBMISSION_ID_LABEL.'))
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138108900931338006)
,p_name=>'P28_BAFO_NEGOTIATION_ID'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(138108749663338004)
,p_prompt=>'&P28_BAFO_NEGOTIATION_ID_LABEL.'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(128345817677489797)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>3
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN( ''A'' , :P28_TEMPLATE_ID ,  19) = ''Y'' and 1 = 2'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_inline_help_text=>'&P28_BAFO_NEGOTIATION_ID_HELP.'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138109242680338009)
,p_name=>'P28_SCOPE_OF_SERVICES'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3050821460104372)
,p_prompt=>'Scope of Services'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>150
,p_cHeight=>10
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  20 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>':P28_REVIEW_STATUS not in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138129138038298926)
,p_name=>'P28_SCOPE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(137979888839452593)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138129270550298927)
,p_name=>'P28_DP_ITEM_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(137979888839452593)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138129372767298928)
,p_name=>'P28_PROJECT_CODE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_prompt=>'Project Code'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P28_PROJECT_CODE'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138129407523298929)
,p_name=>'P28_PROJECT_NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_prompt=>'Project Number'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P28_PROJECT_NUMBER'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138129548364298930)
,p_name=>'P28_CATEGORY_ID'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_prompt=>'Category Level 2'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM CATEGORY  LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 232 ;'))
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  3) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>'&P28_CATEGORY_ID_HELP.'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
,p_item_comment=>'Labe: &P28_CATEGORY_ID_LABEL.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138129629316298931)
,p_name=>'P28_SUB_CATEGORY_ID'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_prompt=>'Category Level 3'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM SUB CATEGORIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 233 ;'))
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  4 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>'&P28_SUB_CATEGORY_ID_HELP.'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
,p_item_comment=>'Labe: &P28_SUB_CATEGORY_ID_LABEL.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138129706267298932)
,p_name=>'P28_RFP_REF_NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_prompt=>'&P28_RFP_REF_NUMBER_LABEL.'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  5 ) = ''Y'' and :P28_RFP_REF_NUMBER is not null'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>'IS_PBP_EMP'
,p_read_only_when2=>'Y'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'&P28_RFP_REF_NUMBER_HELP.'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138129861107298933)
,p_name=>'P28_LOCATION_OF_WORK'
,p_is_required=>true
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_prompt=>'&P28_LOCATION_OF_WORK_LABEL.'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>120
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  6 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
,p_item_comment=>'&P28_LOCATION_OF_WORK_HELP.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138129995864298934)
,p_name=>'P28_LANGUAGE_OF_WORK'
,p_is_required=>true
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_prompt=>'&P28_LANGUAGE_OF_WORK_LABEL.'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'LANGUAGE LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select LANGUAGE d, LANGUAGE r',
'from languages',
'order by 1'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  7) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_item_comment=>'&P28_LANGUAGE_OF_WORK_HELP.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138130056953298935)
,p_name=>'P28_DCT_REPRESENTATIVES_AND_SUPPORT'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(2238584426188048)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P28_TEMPLATE_ID ,  9 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'&P28_DCT_REPRESENTATIVES_AND_SUPPORT_LABEL.'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  9 ) = ''Y'' and 1 = 2'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864946147449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_item_comment=>'&P28_DCT_REPRESENTATIVES_AND_SUPPORT_HELP.'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138130326579298938)
,p_name=>'P28_INTRODUCTION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138255629478279219)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P28_TEMPLATE_ID ,  10 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'&P28_INTRODUCTION_LABEL.'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  10 ) = ''Y'' and 1 = 2'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_item_comment=>'&P28_INTRODUCTION_HELP.'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138130439922298939)
,p_name=>'P28_ABOUT_DCT'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(138255629478279219)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P28_TEMPLATE_ID ,  11 ) and 1 = 2'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'About DCT'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>10
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  11 ) = ''Y'' and 1 = 2'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138130569325298940)
,p_name=>'P28_BACKGROUND_AND_SERVICES_REQUIRED'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(138255629478279219)
,p_item_default=>'DP_SCOPING_UTIL.GET_DATAPOINT_DEF_TEXT ( ''A'' , :P28_TEMPLATE_ID ,  12 )'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Background and Services Required'
,p_display_as=>'NATIVE_TEXTAREA'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  12 ) = ''Y'' and 1 = 2'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138158884311068420)
,p_name=>'P28_EXPECTED_END_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(138255759230279220)
,p_prompt=>'Expected Contract End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  14 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138158998867068421)
,p_name=>'P28_TENDER_START_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(138255759230279220)
,p_prompt=>'Expected Tender start Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  15 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138159071295068422)
,p_name=>'P28_TENDER_END_DATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(138255759230279220)
,p_prompt=>'Expected Tender End Date'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_begin_on_new_line=>'N'
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  16 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_02=>'+1d'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138212193377169745)
,p_name=>'P28_INTELLECTUAL_PROPERTY_COPYRIGHTS'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(138111997574338036)
,p_prompt=>'Intellectual Property Copyrights'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  21 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>':P28_REVIEW_STATUS not in (''Draft'' , ''Return'' , ''Withdraw'')'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138212253606169746)
,p_name=>'P28_REPORTING_COMMUNICATION_REQ'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(138112305415338040)
,p_prompt=>'Reporting Communication Requirements'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  22 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138212362786169747)
,p_name=>'P28_ADDED_VALUE_OFFERINGS'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(138112732905338044)
,p_prompt=>'Added Value Offerings'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>120
,p_cHeight=>5
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  23 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864778539449733)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138253912344279202)
,p_name=>'P28_CREATED_BY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138253887822279201)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138254061975279203)
,p_name=>'P28_CREATION_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(138253887822279201)
,p_prompt=>'Creation Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138254103310279204)
,p_name=>'P28_UPDATED_BY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(138253887822279201)
,p_prompt=>'Updated By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e',
'where person_id > 10'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138254288968279205)
,p_name=>'P28_UPDATED_DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(138253887822279201)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(138255856512279221)
,p_name=>'P28_DP_ITEM_DATE'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_prompt=>'DP Item Date'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'sELECT NVL(TO_CHAR(ESTIMATED_DATE, ''DD-MON-YYYY'') , ESTIMATED_QUARTER || ''- '' || ESTIMATED_YEAR)',
'FROM dp_items',
'WHERE item_id = :P28_DP_ITEM_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139195239337046249)
,p_name=>'P28_PROJECT_OVERVIEW_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(136202291067004043)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139195393735046250)
,p_name=>'P28_PROJECT_OVERVIEW_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(136202291067004043)
,p_prompt=>'PROJECT_OVERVIEW_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139232075871593502)
,p_name=>'P28_REQUIREMENTS_OVERVIEW_LAB'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(136202564981004046)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139232127088593503)
,p_name=>'P28_REQUIREMENTS_OVERVIEW_HELP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(136202564981004046)
,p_prompt=>'REQUIREMENTS_OVERVIEW_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139232209847593504)
,p_name=>'P28_TIMELINES_LABEL'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(136202906132004050)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139232341008593505)
,p_name=>'P28_TIMELINES_HELP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(136202906132004050)
,p_prompt=>'TIMELINES_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139232410885593506)
,p_name=>'P28_SUBMISSION_INFO_LABEL'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(138108749663338004)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139232584477593507)
,p_name=>'P28_SUBMISSION_INFO_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138108749663338004)
,p_prompt=>'SUBMISSION_INFORMATION_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139232601411593508)
,p_name=>'P28_SCOPE_OF_SERVICES_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3050624650104370)
,p_use_cache_before_default=>'NO'
,p_prompt=>'SCOPE_OF_SERVICES_HELP'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE (  ''A'' , :P28_TEMPLATE_ID ,  20 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_display_when=>'DP_SCOPING_UTIL.SHOW_DATAPOINT_YN(  ''A'' , :P28_TEMPLATE_ID ,  20 ) = ''Y'''
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139232750750593509)
,p_name=>'P28_SCOPE_OF_SERVICES_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(3050821460104372)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139232876565593510)
,p_name=>'P28_REQUIRED_DELIVERABLES_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138109536810338012)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139232965680593511)
,p_name=>'P28_REQUIRED_DELIVERABLE_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(138109536810338012)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139233028497593512)
,p_name=>'P28_PERFOR_MEASUR_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138109949499338016)
,p_prompt=>'PERFORMANCE_MEASUREMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139233158431593513)
,p_name=>'P28_PERFORM_MEASUR_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(138109949499338016)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139233296034593514)
,p_name=>'P28_SUPPLIER_RES_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138110384396338020)
,p_prompt=>'SUPPLIER_RESPONSIBILITIES_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139233375671593515)
,p_name=>'P28_SUPPLIER_RESPONS_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(138110384396338020)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139233436064593516)
,p_name=>'P28_PROPO_SUBMISSION_REQ_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138110722318338024)
,p_prompt=>'PROPOSAL_SUBMISSION_REQUIREMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139233552972593517)
,p_name=>'P28_PROPOSAL_SUBM_REQ_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(138110722318338024)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139233651754593518)
,p_name=>'P28_SECURITY_REQUIREMENTS_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138111199620338028)
,p_prompt=>'SECURITY_REQUIREMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139233757076593519)
,p_name=>'P28_SECURITY_REQUIREMENT_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(138111199620338028)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139233807982593520)
,p_name=>'P28_DATA_CAPTURE_REQ_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138111552525338032)
,p_prompt=>'DATA_CAPTURE_REQUIREMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139233920790593521)
,p_name=>'P28_DATA_CAPTURE_REQ_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(138111552525338032)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139234041233593522)
,p_name=>'P28_INTEL_PROP_COPYRIGHTS_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138111997574338036)
,p_prompt=>'INTELLECTUAL_PROPERTY_COPYRIGHTS_OF_WORK_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139234169125593523)
,p_name=>'P28_INTELL_PRO_COPYRIGHTSLABEL'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(138111997574338036)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139234215973593524)
,p_name=>'P28_REPORT_COMM_REQ_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138112305415338040)
,p_prompt=>'REPORTING_COMMUNICATION_REQUIREMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139234336826593525)
,p_name=>'P28_REPORT_COMM_REQ_LABEL'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(138112305415338040)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139234473715593526)
,p_name=>'P28_ADDED_VALUE_OFFERINGS_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138112732905338044)
,p_prompt=>'ADDED_VALUE_OFFERINGS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139234544164593527)
,p_name=>'P28_ADDED_VALUE_OFFERINGS_LAB'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(138112732905338044)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139234648175593528)
,p_name=>'P28_ATT_DOCUMENTS_HELP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(138113128934338048)
,p_prompt=>'ATTACHMENTS_SUPPORTING_DOCUMENTS_HELP'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(127864569373449734)
,p_item_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139234712400593529)
,p_name=>'P28_ATTACH_DOC_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(138113128934338048)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139348044105743109)
,p_name=>'P28_SCOPE_CODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(140457692251095036)
,p_prompt=>'Scoping Document Code'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139351563956743144)
,p_name=>'P28_TEMPLATE_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(137979888839452593)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(139351833722743147)
,p_name=>'P28_INTRODUCTION_HELP'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(138255629478279219)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P28_TEMPLATE_ID , 10  )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'U'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140456380328095023)
,p_name=>'P28_PROJECT_NAME_LABEL'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P28_TEMPLATE_ID ,  1)'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140456455862095024)
,p_name=>'P28_DATE_REQUIRED_LABEL'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P28_TEMPLATE_ID ,  2 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140456578122095025)
,p_name=>'P28_CATEGORY_ID_LABEL'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P28_TEMPLATE_ID , 3)'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140456638162095026)
,p_name=>'P28_SUB_CATEGORY_ID_LABEL'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P28_TEMPLATE_ID , 4 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140456771296095027)
,p_name=>'P28_RFP_REF_NUMBER_LABEL'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P28_TEMPLATE_ID ,  5 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140456839309095028)
,p_name=>'P28_LOCATION_OF_WORK_LABEL'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P28_TEMPLATE_ID ,  6 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140456964669095029)
,p_name=>'P28_LANGUAGE_OF_WORK_LABEL'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL(''A'' , :P28_TEMPLATE_ID , 7 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140457022277095030)
,p_name=>'P28_PROVISION_OF_SERVICES_LABEL'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL(''A'' , :P28_TEMPLATE_ID ,  8 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140457135304095031)
,p_name=>'P28_DCT_REPRESENTATIVES_AND_SUPPORT_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(2238584426188048)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL( ''A'' , :P28_TEMPLATE_ID , 9 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140457845135095038)
,p_name=>'P28_TEMPLATE_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(140457692251095036)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Template Name'
,p_source=>'P28_TEMPLATE_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'SCOPING TEMPLATES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DP_SCOPE_TEMPLATES.TEMPLATE_NAME as TEMPLATE_NAME ,',
'    DP_SCOPE_TEMPLATES.TEMPLATE_ID as TEMPLATE_ID',
' from DP_SCOPE_TEMPLATES DP_SCOPE_TEMPLATES',
' where status = ''A''',
' and sysdate between nvl(start_date , sysdate -10) and nvl(end_date , sysdate +10)'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140457951146095039)
,p_name=>'P28_MAIN_CATEGORY_ID'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_prompt=>'Category Level 1'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'ITEM MAIN CATEGORIES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CATEGORY_NAME , CATEGORY_ID',
'from dp_item_categories',
'where ORDER_LEVEL = 231 ;'))
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140458287369095042)
,p_name=>'P28_INTRODUCTION_LABEL'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(138255629478279219)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL(''A'' , :P28_TEMPLATE_ID , 10  )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'U'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140458338293095043)
,p_name=>'P28_LOCATION_OF_WORK_HELP'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P28_TEMPLATE_ID ,  6 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140458478021095044)
,p_name=>'P28_LANGUAGE_OF_WORK_HELP'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P28_TEMPLATE_ID , 7 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140458537073095045)
,p_name=>'P28_RFP_REF_NUMBER_HELP'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P28_TEMPLATE_ID ,  5 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140458611035095046)
,p_name=>'P28_PROVISION_OF_SERVICES_HELP'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P28_TEMPLATE_ID ,  8 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140458780441095047)
,p_name=>'P28_DCT_REPRESENTATIVES_AND_SUPPORT_HELP'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(2238584426188048)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P28_TEMPLATE_ID , 9 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140458866249095048)
,p_name=>'P28_DATE_REQUIRED_HELP'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P28_TEMPLATE_ID ,  2 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140458927378095049)
,p_name=>'P28_CATEGORY_ID_HELP'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P28_TEMPLATE_ID , 3)'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140459073563095050)
,p_name=>'P28_SUB_CATEGORY_ID_HELP'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(138255567654279218)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE( ''A'' , :P28_TEMPLATE_ID , 4 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140894804286593001)
,p_name=>'P28_TECHNICAL_SUBMISSION_ID_LABEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(138108749663338004)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL(''A'' , :P28_TEMPLATE_ID , 18  )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140894948060593002)
,p_name=>'P28_TECHNICAL_SUBMISSION_ID_HELP'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(138108749663338004)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P28_TEMPLATE_ID , 18  )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140895075848593003)
,p_name=>'P28_BAFO_NEGOTIATION_ID_LABEL'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(138108749663338004)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_LABEL(''A'' , :P28_TEMPLATE_ID , 19 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(140895199089593004)
,p_name=>'P28_BAFO_NEGOTIATION_ID_HELP'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(138108749663338004)
,p_use_cache_before_default=>'NO'
,p_source=>'DP_SCOPING_UTIL.GET_DATAPOINT_GUIDELINE(''A'' , :P28_TEMPLATE_ID , 19 )'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(144066188988480804)
,p_name=>'P28_EXPAND_ALL'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(137979888839452593)
,p_item_default=>'E'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(2599111451041950)
,p_validation_name=>'Validate Evaluation Criteria %'
,p_validation_sequence=>10
,p_validation=>':P28_TECH_PCT + :P28_COMM_PCT = 100'
,p_validation_type=>'PLSQL_EXPRESSION'
,p_error_message=>'Total Commercial% and Technical% must be 100. '
,p_always_execute=>'Y'
,p_associated_item=>wwv_flow_api.id(2598028065041939)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139018032636657707)
,p_name=>'Deliverable Close DA2'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(138159174650068423)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139018139074657708)
,p_event_id=>wwv_flow_api.id(139018032636657707)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138159174650068423)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139018431742657711)
,p_name=>'Performance Measurements Closing DA2'
,p_event_sequence=>30
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(138160344216068435)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139018527739657712)
,p_event_id=>wwv_flow_api.id(139018431742657711)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138160344216068435)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139018685173657713)
,p_name=>'Performance Measurements Closing DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(138160200285068434)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143064797322754136)
,p_event_id=>wwv_flow_api.id(139018685173657713)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139018739789657714)
,p_event_id=>wwv_flow_api.id(139018685173657713)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138160344216068435)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139018960017657716)
,p_name=>'DP_SCOPING_A_SUPPLIER_RESP Dialog Close DA'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(138208598242169709)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139019034877657717)
,p_event_id=>wwv_flow_api.id(139018960017657716)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138161641022068448)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139019179708657718)
,p_name=>'DP_SCOPING_A_SUPPLIER_RESP Dialog Close DA2'
,p_event_sequence=>60
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(138161641022068448)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139019284402657719)
,p_event_id=>wwv_flow_api.id(139019179708657718)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138161641022068448)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139019371592657720)
,p_name=>'Expand'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(138208598242169709)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139019418473657721)
,p_event_id=>wwv_flow_api.id(139019371592657720)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138110384396338020)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139019635462657723)
,p_name=>'Close DA'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(138209858931169722)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143064669545754135)
,p_event_id=>wwv_flow_api.id(139019635462657723)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139019769635657724)
,p_event_id=>wwv_flow_api.id(139019635462657723)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138208662511169710)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139019851628657725)
,p_name=>'Open Dialog'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(138209858931169722)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139019931387657726)
,p_event_id=>wwv_flow_api.id(139019851628657725)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138110722318338024)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139020043404657727)
,p_name=>'Close Dialog2'
,p_event_sequence=>100
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(138208662511169710)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139020122246657728)
,p_event_id=>wwv_flow_api.id(139020043404657727)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138208662511169710)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139020361877657730)
,p_name=>'DA Close3'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(138210995159169733)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139020496103657731)
,p_event_id=>wwv_flow_api.id(139020361877657730)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138209993920169723)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139020514663657732)
,p_name=>'Open3'
,p_event_sequence=>120
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(138210995159169733)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139020628780657733)
,p_event_id=>wwv_flow_api.id(139020514663657732)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138111199620338028)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139020773092657734)
,p_name=>'DA Close3A'
,p_event_sequence=>130
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(138209993920169723)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139020809213657735)
,p_event_id=>wwv_flow_api.id(139020773092657734)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138209993920169723)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139021015704657737)
,p_name=>'Dialog Close4'
,p_event_sequence=>140
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(138212022721169744)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139021141290657738)
,p_event_id=>wwv_flow_api.id(139021015704657737)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138211082170169734)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139021234699657739)
,p_name=>'Open4'
,p_event_sequence=>150
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(138212022721169744)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139021365158657740)
,p_event_id=>wwv_flow_api.id(139021234699657739)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138111552525338032)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(139021442426657741)
,p_name=>'Dialog Close4A'
,p_event_sequence=>160
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(138211082170169734)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(139021559930657742)
,p_event_id=>wwv_flow_api.id(139021442426657741)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138211082170169734)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(143585659971562426)
,p_name=>'Add DA'
,p_event_sequence=>170
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(138157407726068406)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143585745413562427)
,p_event_id=>wwv_flow_api.id(143585659971562426)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138130833733298943)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(143585800212562428)
,p_name=>'Changes Refresh DA'
,p_event_sequence=>180
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(138130833733298943)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143585998510562429)
,p_event_id=>wwv_flow_api.id(143585800212562428)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138130833733298943)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(143586068731562430)
,p_name=>'Add_O DA'
,p_event_sequence=>190
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(138157667455068408)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143586172220562431)
,p_event_id=>wwv_flow_api.id(143586068731562430)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138157724241068409)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(143586222361562432)
,p_name=>'Add_O DA2'
,p_event_sequence=>200
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(138157724241068409)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143586390606562433)
,p_event_id=>wwv_flow_api.id(143586222361562432)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138157724241068409)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(143586847195562438)
,p_name=>'Expand All DA'
,p_event_sequence=>210
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(143586730419562437)
,p_condition_element=>'P28_EXPAND_ALL'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'E'
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143586954297562439)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(136202291067004043)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143587049484562440)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138110722318338024)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144067704239480820)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138113128934338048)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143587124137562441)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138112305415338040)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144067667834480819)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138111997574338036)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143587263463562442)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(136202564981004046)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144067537004480818)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138111552525338032)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143587306042562443)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138108749663338004)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144067459775480817)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138111199620338028)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143587475577562444)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(136202906132004050)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144067319415480816)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138110384396338020)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143587564079562445)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138109180396338008)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144067222054480815)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138109949499338016)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143587651477562446)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>80
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138112732905338044)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144067167011480814)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>80
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138109536810338012)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143587743182562447)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>90
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138109536810338012)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144067096541480813)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>90
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138112732905338044)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143587894387562448)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>100
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138109949499338016)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144066901581480812)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>100
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138109180396338008)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143587920268562449)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>110
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138110384396338020)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144066826848480811)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>110
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(136202906132004050)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143588084310562450)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>120
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138111199620338028)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144066707290480810)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>120
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138108749663338004)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144065870156480801)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>130
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138111552525338032)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144066605600480809)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>130
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(136202564981004046)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144065959957480802)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>140
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138111997574338036)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144066546227480808)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>140
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138112305415338040)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144066043963480803)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>150
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138113128934338048)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144066461832480807)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>150
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138110722318338024)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144066249664480805)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'TRUE'
,p_action_sequence=>160
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P28_EXPAND_ALL'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'C'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144066350423480806)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>160
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(136202291067004043)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(144067859671480821)
,p_event_id=>wwv_flow_api.id(143586847195562438)
,p_event_result=>'FALSE'
,p_action_sequence=>170
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P28_EXPAND_ALL'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'E'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(2598063915041940)
,p_name=>'Selection Criteria DA'
,p_event_sequence=>220
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P28_SELECTION_CRITERIA'
,p_condition_element=>'P28_SELECTION_CRITERIA'
,p_triggering_condition_type=>'IN_LIST'
,p_triggering_expression=>'2'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2598228265041941)
,p_event_id=>wwv_flow_api.id(2598063915041940)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P28_TECH_PCT,P28_COMM_PCT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2598358396041943)
,p_event_id=>wwv_flow_api.id(2598063915041940)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P28_TECH_PCT,P28_COMM_PCT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2598253415041942)
,p_event_id=>wwv_flow_api.id(2598063915041940)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P28_TECH_PCT,P28_COMM_PCT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(2598472014041944)
,p_name=>'Check PCT DA'
,p_event_sequence=>230
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P28_TECH_PCT,P28_COMM_PCT'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Number(apex.item("P28_TECH_PCT").getValue()) + Number(apex.item("P28_COMM_PCT").getValue()) != 100  &&',
'    !apex.item("P28_TECH_PCT").isEmpty()&&',
'    !apex.item("P28_COMM_PCT").isEmpty()'))
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2598623139041945)
,p_event_id=>wwv_flow_api.id(2598472014041944)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Total Commercial% and Technical% must be 100. '
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2598661122041946)
,p_event_id=>wwv_flow_api.id(2598472014041944)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P28_COMM_PCT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3051270793104377)
,p_name=>'Close Comment DA'
,p_event_sequence=>240
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3404127002621513)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3051393598104378)
,p_event_id=>wwv_flow_api.id(3051270793104377)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(276632822872682748)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3051490778104379)
,p_name=>'Close Comment2 DA'
,p_event_sequence=>250
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(276632822872682748)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3051572000104380)
,p_event_id=>wwv_flow_api.id(3051490778104379)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(276632822872682748)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(143065047187754139)
,p_name=>'Deliverable Close DA'
,p_event_sequence=>260
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(138160190735068433)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143064870894754137)
,p_event_id=>wwv_flow_api.id(143065047187754139)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(143065027059754138)
,p_event_id=>wwv_flow_api.id(143065047187754139)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(138159174650068423)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(138254458415279207)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialize Scoping Appendix A'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    scope_id,',
'    scope_code,',
'    dp_item_id,',
'    NVL(project_name, (select PROJECT_NAME from project where PROJECT_NUMBER = dp_scoping_a.project_number) ) project_name,',
'    project_code,',
'    project_number,',
'    provision_of_services,',
'    to_char(date_required,''DD-MON-YYYY'') date_required, ',
'    main_category_id,',
'    category_id,',
'    sub_category_id,',
'    rfp_ref_number,',
'    location_of_work,',
'    language_of_work,',
'    dct_representatives_and_support,',
'    introduction,',
'    about_dct,',
'    background_and_services_required,',
'    to_char(expected_start_date,''DD-Mon-YYYY'')   expected_start_date,',
'    to_char(expected_end_date,''DD-Mon-YYYY'')   expected_end_date,',
'    duration_comments,',
'    to_char(tender_start_date,''DD-Mon-YYYY'') tender_start_date,',
'    to_char(tender_end_date,''DD-Mon-YYYY'')   tender_end_date,',
'    technical_submission_id,    ',
'    bafo_negotiation_id,',
'    SELECTION_CRITERIA,',
'    scope_of_services,',
'    intellectual_property_copyrights,',
'    reporting_communication_requirements,',
'    added_value_offerings,',
'    created_by,',
'    updated_by,',
'    to_char(creation_date,''DD-MON-YYYY HH:MIPM'') creation_date,',
'    to_char(updated_date,''DD-MON-YYYY HH:MIPM'') updated_date,',
'    APPROVAL_STATUS,',
'    REVIEW_STATUS,',
' --   template_id,',
'    template_id template_id_H,',
'    to_char(EXPECTED_CONTRACT_START_DATE,''DD-Mon-YYYY'')  EXPECTED_CONTRACT_START_DATE,',
'    to_char(EXPECTED_CONTRACT_END_DATE,''DD-Mon-YYYY'')    EXPECTED_CONTRACT_END_DATE,',
'    COMM_PCT,',
'    TECH_PCT',
'INTO',
'    :P28_scope_id,',
'    :P28_scope_code,',
'    :P28_dp_item_id,',
'    :P28_project_name,',
'    :P28_project_code,',
'    :P28_project_number,',
'    :P28_provision_of_services,',
'    :P28_date_required,',
'    :P28_main_category_id,',
'    :P28_category_id,',
'    :P28_sub_category_id,',
'    :P28_rfp_ref_number,',
'    :P28_location_of_work,',
'    :P28_language_of_work,',
'    :P28_dct_representatives_and_support,',
'    :P28_introduction,',
'    :P28_about_dct,',
'    :P28_background_and_services_required,',
'    :P28_expected_start_date,',
'    :P28_expected_end_date,',
'    :P28_duration_comments,',
'    :P28_tender_start_date,',
'    :P28_tender_end_date,',
'    :P28_technical_submission_id,',
'    :P28_bafo_negotiation_id,',
'    :P28_SELECTION_CRITERIA,',
'    :P28_scope_of_services,',
'    :P28_intellectual_property_copyrights,',
'    :P28_reporting_communication_req,',
'    :P28_added_value_offerings,',
'    :P28_created_by,',
'    :P28_updated_by,',
'    :P28_creation_date,',
'    :P28_updated_date,',
'    :P28_APPROVAL_STATUS,',
'    :P28_REVIEW_STATUS,',
'  --  :P28_TEMPLATE,',
'    :P28_TEMPLATE_ID,',
'    :P28_EXPECTED_CONTRACT_START_DATE,',
'    :P28_EXPECTED_CONTRACT_END_DATE,',
'    :P28_COMM_PCT,',
'    :P28_TECH_PCT',
'FROM',
'    dp_scoping_a',
'WHERE scope_id = nvl(:P28_scope_id  , (SELECT last_number',
'                                          FROM all_sequences',
'                                         WHERE sequence_owner = ''PROD''',
'                                           AND sequence_name = ''DP_SCOPING_SEQ'')',
'                        );',
'exception',
'    when others then null;    '))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(509038904008628184)
,p_process_sequence=>20
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Details Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DP_ITEMS_UTIL.get_dp_procurement_method_class_id(dp_procurement_method) ,',
'        DP_ITEMS_UTIL.get_dp_procurement_method_id(ITEM_ID) ',
'into    ',
'    :P28_PROCUREMENT_METHOD_CLASS_ID,',
'    :P28_PROCUREMENT_METHOD',
'from dp_items',
'where item_id = :P28_DP_ITEM_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(138254512930279208)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Scoping Appendix A Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'UPDATE dp_scoping_a',
'SET ',
'    provision_of_services = :P28_provision_of_services,',
'    date_required = to_date(:P28_date_required,''dd-Mon-YYYY''),',
' --   rfp_ref_number = :P28_rfp_ref_number,',
'    location_of_work = :P28_location_of_work,',
'    language_of_work = :P28_language_of_work,',
'    dct_representatives_and_support = :P28_dct_representatives_and_support ,',
'    introduction = :P28_introduction,',
'    about_dct = :P28_about_dct ,',
'    background_and_services_required = :P28_background_and_services_required ,',
'    expected_start_date = to_date(:P28_expected_start_date,''dd-Mon-YYYY''),',
'    expected_end_date = to_date(:P28_expected_end_date,''dd-Mon-YYYY''),',
'    duration_comments = :P28_duration_comments ,',
'    tender_start_date = to_date(:P28_tender_start_date,''dd-Mon-YYYY''),',
'    tender_end_date = to_date(:P28_tender_end_date,''dd-Mon-YYYY''),',
'    technical_submission_id = :P28_technical_submission_id ,',
'    bafo_negotiation_id = :P28_bafo_negotiation_id ,',
'    SELECTION_CRITERIA = :P28_SELECTION_CRITERIA,',
'    scope_of_services = :P28_scope_of_services ,',
'    intellectual_property_copyrights = :P28_intellectual_property_copyrights ,',
'    reporting_communication_requirements = :P28_REPORTING_COMMUNICATION_REQ ,',
'    added_value_offerings = :P28_added_value_offerings,',
'    EXPECTED_CONTRACT_START_DATE = :P28_EXPECTED_CONTRACT_START_DATE,',
'    EXPECTED_CONTRACT_END_DATE = :P28_EXPECTED_CONTRACT_END_DATE,',
'    COMM_PCT = :P28_COMM_PCT,',
'    TECH_PCT = :P28_TECH_PCT',
'where  scope_id = :P28_scope_id;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
