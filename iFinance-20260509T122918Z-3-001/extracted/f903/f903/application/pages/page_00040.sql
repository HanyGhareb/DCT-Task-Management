prompt --application/pages/page_00040
begin
--   Manifest
--     PAGE: 00040
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_page(
 p_id=>40
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'Form Line Details - Approval'
,p_alias=>'FORM-LINE-DETAILS-APPROVAL'
,p_step_title=>'Form Line Details - Approval'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Form-inputContainer input[type=text].showfocus, .t-Form-inputContainer select.showfocus,  .t-Form-inputContainer select.showfocus.selectlist ,.apex-item-text select.showfocus, .apex-item-select {',
'  background-color: #CEF6CE !important;',
'}',
'',
'/* Scroll Results Only in Side Column */',
'.t-Body-side {',
'    display: flex;',
'    flex-direction: column;',
'    overflow: hidden;',
'}',
'.search-results {',
'    flex: 1;',
'    overflow: auto;',
'}',
'/* Format Search Region */',
'.search-region {',
'    border-bottom: 1px solid rgba(0,0,0,.1);',
'    flex-shrink: 0;',
'}',
'',
'.t-Region-header{',
'background-color:#0e6655;',
'    color:#FFFFFF;',
'}',
'.t-Region-title{',
'    color:#FFFFFF;',
'    font-weighfont-weight: bold;',
'}',
'',
'/* Set Header Panel */',
'.t-Header-branding {',
'    background-color: #0e6655;',
'}',
'',
'',
'/* Set Breadcrumb   */',
'.t-Body-title {',
'',
'    background-color: #EEE;',
'    color:#404040;',
'}',
'',
'/* Add Button - White */',
'.t-Region-header, .t-Region-header .t-Button--link, .t-Region-header .t-Button--noUI {',
'    color:  #FFF;',
'}',
'',
'/* New Plan Button */',
'.a-Button--hot, .t-Button--hot:not(.t-Button--simple), body .ui-button.ui-button--hot, body .ui-state-default.ui-priority-primary {',
'',
'    background-color: #0e6655;',
'    color:#fff;',
'}',
'',
'',
'/*  Table Row Selected */',
'.a-GV-table tr.is-selected .a-GV-cell {',
'    background-color: #CEF6CE;',
'}',
'',
'/* Audit Region */',
'#history .t-Region-header {',
'			background-color: #cae6e3;',
'			color:#000;',
'			}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'ALWAYS'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200518180215'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13959834490627895)
,p_plug_name=>'<b>Similar Requests </b>'
,p_icon_css_classes=>'fa-pause fa-anim-flash fam-pause fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13958969853627886)
,p_plug_name=>'Similar Requests Report'
,p_parent_plug_id=>wwv_flow_api.id(13959834490627895)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select form_no',
'        ,line_no',
'        ,updated_date',
'        ,justification',
'    , transferred_amount',
'    , (select h.finance_status',
'        from btf_header h',
'        where h.form_no = btf_lines.form_no) Finance_status',
'    ,  (select h.status',
'        from btf_header h',
'        where h.form_no = btf_lines.form_no) DOA_status',
'            ,project_number',
'        ,task_number',
'        ,gl_account    ',
'from btf_lines',
'where project_number = :P40_PROJECT_NUMBER_H',
'and task_number = :P40_TASK_NUMBER_H',
'and cost_center = :P40_COST_CENTER_H',
'and gl_account = :P40_GL_ACCOUNT_H',
'--and btf_lines.from_to = :P40_FROM_TO_X',
'--and (select h.completed',
'--    from btf_header h',
'--    where h.form_no = btf_lines.form_no) = ''N''',
'--and (select h.status',
'--    from btf_header h',
'--    where h.form_no = btf_lines.form_no) <> ''Rejected''',
'--and (select h.finance_status',
'--    from btf_header h',
'--    where h.form_no = btf_lines.form_no) <> ''Rejected''',
'and line_id <> :P40_LINE_ID    ',
'order by btf_lines.form_no'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Similar Requests Report'
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
 p_id=>wwv_flow_api.id(13959098032627887)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No similar transfer requests for above project/task.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>13959098032627887
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7116158563822519)
,p_db_column_name=>'FORM_NO'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Form No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7116554334822519)
,p_db_column_name=>'LINE_NO'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Line No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7117370600822520)
,p_db_column_name=>'JUSTIFICATION'
,p_display_order=>30
,p_column_identifier=>'D'
,p_column_label=>'Justification'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7117790432822520)
,p_db_column_name=>'TRANSFERRED_AMOUNT'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Transferred Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7118135512822520)
,p_db_column_name=>'FINANCE_STATUS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Finance Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7118501451822521)
,p_db_column_name=>'DOA_STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'DOA Approval Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7116948913822520)
,p_db_column_name=>'UPDATED_DATE'
,p_display_order=>80
,p_column_identifier=>'C'
,p_column_label=>'Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7017072163736241)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7017118969736242)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7017205248736243)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(14024820077827495)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'71189'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FORM_NO:LINE_NO:JUSTIFICATION:TRANSFERRED_AMOUNT:FINANCE_STATUS:DOA_STATUS:UPDATED_DATE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(83780617816982688)
,p_plug_name=>'Budget Transfer Request Line Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65544848715255753)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(149555442527606730)
,p_plug_name=>'&P40_FORM_NO. - &P40_LINE_NO. Details'
,p_parent_plug_id=>wwv_flow_api.id(83780617816982688)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65519636948255743)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'BTF_LINES'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(149761769340678322)
,p_plug_name=>'Audit Info.'
,p_region_name=>'history'
,p_parent_plug_id=>wwv_flow_api.id(149555442527606730)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(65530067520255748)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P40_LINE_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(159799605543789327)
,p_plug_name=>'breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65554277731255756)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(65494572154255667)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(65602363670255785)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7114019403822517)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(159799605543789327)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(65600970359255785)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:RP,::'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(7151856360822538)
,p_branch_name=>'Go To 9'
,p_branch_action=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:RP::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7015985509736230)
,p_name=>'P40_PROJECT_NUMBER_H'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(83780617816982688)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7016016292736231)
,p_name=>'P40_LINE_ID_H'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(83780617816982688)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7016807067736239)
,p_name=>'P40_TASK_NUMBER_H'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(83780617816982688)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7082941670822490)
,p_name=>'P40_CREATE_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(83780617816982688)
,p_item_default=>'M'
,p_prompt=>'<b>Create Line By:  </b>'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:Manual;M,Import from Accepted End Users Requests;I'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'2'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7085290654822492)
,p_name=>'P40_LINE_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_source=>'LINE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7085634698822492)
,p_name=>'P40_FORM_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_source=>'FORM_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7086070605822492)
,p_name=>'P40_LINE_NO'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(*)+ 1',
'from btf_lines',
'where from_to = ''TO''',
'and form_no = :P40_FORM_NO'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Line No'
,p_source=>'LINE_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>5
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7086474537822493)
,p_name=>'P40_FROM_TO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'From / To'
,p_source=>'FROM_TO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:From (Deduct Budget);FROM,To (Additional Budget);TO'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7086825393822493)
,p_name=>'P40_PURPOSE_EU'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Purpose'
,p_source=>'PURPOSE_EU'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P40_FROM_TO = ''TO''',
'then',
'return ''select value d',
'     , value_id r',
'from dct_lookup_values',
'where status = ''''A''''',
'and lookup_id = (select lookup_id',
'from dct_lookups',
'where lookup_code = ''''PTARPEU'''')'' ;',
'else ',
'',
'return    ''select value d',
'     , value_id r',
'from dct_lookup_values',
'where status = ''''A''''',
'and lookup_id = (select lookup_id',
'from dct_lookups',
'where lookup_code = ''''PTDRPEU'''')'' ;',
'',
'end if'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P40_FROM_TO'
,p_ajax_items_to_submit=>'P40_FROM_TO'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7087265627822493)
,p_name=>'P40_TCA_SECTOR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Sector'
,p_source=>'TCA_SECTOR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P40_FROM_TO = ''TO''',
'then',
'return ''select distinct F_PROJECTBUDGET.TCA_SECTOR as TCA_SECTOR ',
'        , F_PROJECTBUDGET.TCA_SECTOR as D ',
' from F_PROJECTBUDGET F_PROJECTBUDGET'' ;',
'else ',
'',
'return    ''select distinct F_PROJECTBUDGET.TCA_SECTOR as TCA_SECTOR ',
'        , F_PROJECTBUDGET.TCA_SECTOR as D ',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where TCA_sector in (SELECT  btf_data_access.entity_name d',
'                FROM   btf_data_access',
'                WHERE btf_data_access.entity_type = ''''TCA_SECTOR''''',
'                    and btf_data_access.user_id = :APP_USER)'' ;',
'',
'end if'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7087678496822494)
,p_name=>'P40_DEPARTMENT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Department'
,p_source=>'DEPARTMENT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct department d',
'    , department r',
'from f_projectbudget',
'where tca_sector = :P40_TCA_SECTOR',
'and department is not null',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P40_TCA_SECTOR'
,p_ajax_items_to_submit=>'P40_TCA_SECTOR'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7088090661822494)
,p_name=>'P40_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Project Number'
,p_source=>'PROJECT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P40_FROM_TO_X_1 = ''TO''',
'then',
'return ''select distinct F_PROJECTBUDGET.PROJECT_NUMBER as PROJECT_NUMBER ',
'       , F_PROJECTBUDGET.PROJECT_NUMBER as r',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where tca_sector = :P40_TCA_SECTOR',
' and department = :P40_DEPARTMENT',
'order by 1'' ;',
'else ',
'',
'return    ''select distinct F_PROJECTBUDGET.PROJECT_NUMBER as PROJECT_NUMBER ',
'       , F_PROJECTBUDGET.PROJECT_NUMBER as r',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where tca_sector = :P40_TCA_SECTOR',
' and department = :P40_DEPARTMENT',
'  and fund_available > 0',
'order by 1'' ;',
'',
'end if'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P40_TCA_SECTOR,P40_DEPARTMENT'
,p_ajax_items_to_submit=>'P40_TCA_SECTOR,P40_DEPARTMENT'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7088465831822494)
,p_name=>'P40_PROJECT_NAME'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Project Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT project_name',
' from f_projectbudget',
' where project_number = :P40_PROJECT_NUMBER;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'I'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7088854826822495)
,p_name=>'P40_TASK_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Task Number'
,p_source=>'TASK_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' if :P40_FROM_TO = ''TO''',
'then',
'return ''SELECT distinct task_number d , ',
'        task_number r',
'FROM f_projectbudget ',
'where project_number = :P40_PROJECT_NUMBER',
'order by 1 '' ;',
'else ',
'',
'return    ''SELECT distinct task_number d , ',
'        task_number r',
'FROM f_projectbudget ',
'where project_number = :P40_PROJECT_NUMBER',
'and fund_available > 0',
'order by 1'' ;',
'',
'end if'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P40_PROJECT_NUMBER,P40_FROM_TO'
,p_ajax_items_to_submit=>'P40_FROM_TO,P40_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_help_text=>'only tasks with Budget and fund available balances. check the data from "Projects Data" Page.'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7089776804822496)
,p_name=>'P40_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Cost Center'
,p_source=>'COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>7
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7090157985822496)
,p_name=>'P40_COST_CENTER_H'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7090519565822496)
,p_name=>'P40_COST_CENTER_NAME'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Cost Center Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT cc_name',
'from f_projectbudget',
'where task_number = :P40_TASK_NUMBER',
'and project_number = :P40_PROJECT_NUMBER'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7090942872822496)
,p_name=>'P40_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'GL Account'
,p_source=>'GL_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' if :P40_FROM_TO = ''TO''',
'then',
'return ''select  distinct natural_account d',
', natural_account r',
'from f_projectbudget',
'where project_number = :P40_PROJECT_NUMBER',
'and task_number = :P40_TASK_NUMBER'' ;',
'else ',
'',
'return    ''select  distinct natural_account d',
', natural_account r',
'from f_projectbudget',
'where project_number = :P40_PROJECT_NUMBER',
'and task_number = :P40_TASK_NUMBER',
'and fund_available > 0'' ;',
'end if'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P40_TASK_NUMBER,P40_PROJECT_NUMBER,P40_FROM_TO'
,p_ajax_items_to_submit=>'P40_PROJECT_NUMBER,P40_TASK_NUMBER,P40_FROM_TO'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_help_text=>'only GL Accounts with budget and fund available will display.'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7091820028822497)
,p_name=>'P40_GL_ACCOUNT_H'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7092289658822497)
,p_name=>'P40_GL_ACCOUNT_NAME'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'GL Account Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DISTINCT account_name',
'from f_projectbudget',
'where natural_account = :P40_GL_ACCOUNT'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct F_PROJECTBUDGET.NATURAL_ACCOUNT as d',
'       , F_PROJECTBUDGET.NATURAL_ACCOUNT as r',
' from F_PROJECTBUDGET F_PROJECTBUDGET',
' where project_number = :P40_PROJECT_NUMBER ',
' and   task_number    = :P40_TASK_NUMBER',
' and   budget         > 0'))
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7092638680822497)
,p_name=>'P40_BUDGET'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Budget'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BUDGET'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7093092690822498)
,p_name=>'P40_ENCUMBRANCES'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Encumbrances'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ENCUMBRANCES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7093496944822498)
,p_name=>'P40_ACTUAL'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Actual'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ACTUAL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7093825876822498)
,p_name=>'P40_FUND_AVAILABLE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Fund Available'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'FUND_AVAILABLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7094223335822498)
,p_name=>'P40_FUND_AVAILABLE_H'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7094696042822498)
,p_name=>'P40_PENDING'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Pending Transfer Amount'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'PENDING'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7095048027822498)
,p_name=>'P40_TRANSFERRED_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Requested Amount'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'TRANSFERRED_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7095400931822499)
,p_name=>'P40_BALANCE_AFTER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Balance After'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'BALANCE_AFTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7095879973822499)
,p_name=>'P40_STRATEGIC'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_source=>'STRATEGIC'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7096221235822499)
,p_name=>'P40_PROGRAM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_source=>'PROGRAM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7096694076822499)
,p_name=>'P40_OUTPUT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_source=>'OUTPUT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7097008873822499)
,p_name=>'P40_JUSTIFICATION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Justification'
,p_source=>'JUSTIFICATION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>80
,p_cMaxlength=>1000
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(65599928104255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7097466469822500)
,p_name=>'P40_REQUEST_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(149555442527606730)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_source=>'REQUEST_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7098883037822501)
,p_name=>'P40_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(149761769340678322)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7099218809822501)
,p_name=>'P40_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(149761769340678322)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Creation Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7099628698822501)
,p_name=>'P40_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(149761769340678322)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7100071633822502)
,p_name=>'P40_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(149761769340678322)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Updated Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7100468624822502)
,p_name=>'P40_SOURCE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(149761769340678322)
,p_item_source_plug_id=>wwv_flow_api.id(149555442527606730)
,p_prompt=>'Source'
,p_source=>'SOURCE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7100808957822502)
,p_name=>'P40_END_USER_REQUEST'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(149761769340678322)
,p_prompt=>'End User Request#'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select request_no',
'from btf_end_users_req',
'where request_id = :P40_REQUEST_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(65599876987255783)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(7128121903822527)
,p_validation_name=>'P40_CREATION_DATE must be timestamp'
,p_validation_sequence=>150
,p_validation=>'P40_CREATION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(7099218809822501)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(7128558282822527)
,p_validation_name=>'P40_UPDATED_DATE must be timestamp'
,p_validation_sequence=>160
,p_validation=>'P40_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(7100071633822502)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(7098161876822501)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(149555442527606730)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Btf Line'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Budget Transfer Request &P40_FORM_NO. updated Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(7097897694822500)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(149555442527606730)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Btf Line'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(7128895680822527)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'ASSIGN_END_USER_REQ'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BTF_WORKFLOW.INSERT_END_USER_REQ(p_selected_ids_json     => apex_application.g_x01 ',
'                                 , P_FORM_NO    => :P40_FORM_NO_X',
'                                 , P_FROM_TO    => :P40_FROM_TO_X_1);'))
,p_process_error_message=>'Error, While Add End User requests'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'End User Requests added Successfully.'
);
wwv_flow_api.component_end;
end;
/
