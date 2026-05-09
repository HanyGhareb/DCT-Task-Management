prompt --application/pages/page_00017
begin
--   Manifest
--     PAGE: 00017
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>143576171933264960
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>17
,p_user_interface_id=>wwv_flow_api.id(24631887413319249)
,p_name=>'TAC Committee Approve Reject Action'
,p_alias=>'TAC-COMMITTEE-APPROVE-REJECT-ACTION'
,p_page_mode=>'MODAL'
,p_step_title=>'TAC Committee Approve Reject Action'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220307113856'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(28480590590048381)
,p_plug_name=>'TAC Committee Approve Reject Action'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24519865163319333)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'TAC_FORM_APPROVAL_HISTORY'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(29351497597057239)
,p_plug_name=>'Select Committee Members'
,p_parent_plug_id=>wwv_flow_api.id(28480590590048381)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24547287062319317)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'       apex_item.checkbox2(1,c.ID) Selected,',
'       c.ID,',
'       COMMITTEE_ID,',
'       MEMBER_ID,',
'       MEMBER_ROLE,',
'       START_DATE,',
'       END_DATE,',
'       STATUS,',
'       COMMENTS,',
'       CREATED_BY_PERSON_ID,',
'       CREATED_ON,',
'       UPDATED_BY_PERSON_ID,',
'       UPDATED_ON,',
'       SEQ,',
'       CASE',
'        WHEN dbms_lob.getlength(e.photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || e.user_name',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END PHOTO_hidden,',
'        null PHOTO',
'  from TAC_COMMITTEE_MEMBERS c, employees_v e',
' where c.member_id = e.person_id',
' and committee_id = (',
'                    select c.id ',
'                    from tac_committees c',
'                    where (select s.estimated_amount',
'                            from tac_form s',
'                            where s.id = :P17_TAC_FORM_ID) BETWEEN AUTHORIZED_AMOUNT_FROM and nvl(AUTHORIZED_AMOUNT_TO,999999999999)',
'                            and sysdate between start_date and nvl(end_date, sysdate + 100) )',
'                    and c.member_role != 87',
'    order by c.seq;',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P17_TAC_FORM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':IS_COMMITTEE_SECRETARY > 0  and :P17_ACTION = ''Endorse'' and :P17_IS_FINAL_STEP = ''N'''
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Committee'
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
 p_id=>wwv_flow_api.id(29351585786057240)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>58336947449555702
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(642910507681292)
,p_db_column_name=>'SELECTED'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Selected'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_format_mask=>'PCT_GRAPH:::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(643327581681292)
,p_db_column_name=>'ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(643699872681291)
,p_db_column_name=>'COMMITTEE_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Committee Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(644106411681291)
,p_db_column_name=>'MEMBER_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25227436734855051)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(644448177681291)
,p_db_column_name=>'MEMBER_ROLE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Member Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(26650222993628901)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(644848665681291)
,p_db_column_name=>'START_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(645324986681290)
,p_db_column_name=>'END_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(645718327681290)
,p_db_column_name=>'STATUS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(646131194681290)
,p_db_column_name=>'COMMENTS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(646536986681290)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created By Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(646925486681289)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(647244353681289)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated By Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(647659796681289)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(648099517681289)
,p_db_column_name=>'SEQ'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(648530981681288)
,p_db_column_name=>'PHOTO_HIDDEN'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo Hidden'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(648936114681288)
,p_db_column_name=>'PHOTO'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Photo'
,p_column_html_expression=>'<image src=''#PHOTO_HIDDEN#'' width=75 height=75>'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(29734284297020706)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'296346'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SELECTED:PHOTO:MEMBER_ID:MEMBER_ROLE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(28494499314048362)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24520872858319332)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28494893242048361)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(28494499314048362)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(24609320066319275)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28496469513048359)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(28494499314048362)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(24609320066319275)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition_type=>'NEVER'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28344546641425616)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(28494499314048362)
,p_button_name=>'Endorse'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconLeft:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(24609474578319275)
,p_button_image_alt=>'Endorse'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P17_ACTION'
,p_button_condition2=>'Endorse'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-up fa-anim-flash'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28344887804425619)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(28494499314048362)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(24609474578319275)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P17_ACTION'
,p_button_condition2=>'Reject'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-down fa-anim-flash'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12728839941342375)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(28494499314048362)
,p_button_name=>'Delegate'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(24609474578319275)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P17_ACTION'
,p_button_condition2=>'Delegate'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-down fa-anim-flash'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28496812167048358)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(28494499314048362)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(24609320066319275)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition_type=>'NEVER'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28497224314048358)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(28494499314048362)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(24609320066319275)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition_type=>'NEVER'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(499652879969650)
,p_branch_name=>'Go To 11'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:11::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(499835738969651)
,p_name=>'P17_IS_FINAL_STEP'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>'FINAL_STEP_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(500001848969653)
,p_name=>'P17_IS_TAC_MEMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT nvl(COUNT(*),0) ',
'FROM tac_form_approval_history h',
'where h.id = :P17_ID',
'and h.person_id = :PERSON_ID',
'and ROLE_ID in (69, 70,71)'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(500065490969654)
,p_name=>'P17_MEETNG_NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_prompt=>'Meetng No:'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select meeting_number || '' ('' || to_char(metting_date,''dd-Mon-yyyy'') || '')'' d , id',
'from tac_meetings',
'order by metting_date desc'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Select Meeting --'
,p_cHeight=>1
,p_display_when=>':P17_IS_FINAL_STEP = ''N'' and :IS_COMMITTEE_SECRETARY	> 0'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(24608376141319276)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(500195527969655)
,p_name=>'P17_DECISION_OPTION'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_prompt=>'Decision Option'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'TCA DECISION OPTIONS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id ',
'from DCT_LOOKUP_VALUES ',
'where lookup_id = (select l.lookup_id ',
'                    from dct_lookups l ',
'                    where l.lookup_code = ''TACDECISION'') ',
'                    and status = ''A'' and sysdate BETWEEN nvl(start_date,sysdate-10) and NVL(end_date, sysdate + 10)'))
,p_display_when=>'P17_IS_FINAL_STEP'
,p_display_when2=>'Y'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(24608183510319277)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large:margin-left-none:margin-right-lg'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'10'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(500292532969656)
,p_name=>'P17_DECISION'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_prompt=>'Decision'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>2
,p_display_when=>'P17_IS_FINAL_STEP'
,p_display_when2=>'Y'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(24608548628319276)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12728947694342376)
,p_name=>'P17_TO_PERSON_ID'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_prompt=>'Delegated To'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'PERSON DETAILS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.employee_num || ''-'' || e.full_name_en  emp_name , e.person_id , e.org_id, e.department_name',
'        , e.sector , e.position ',
'        , e.department_id',
'        , e.sector_id',
'        , (select s.short_name_en',
'            from dct_hr_organizations s',
'            where s.org_id = e.sector_id) sector_code',
'from employees_v e',
'where current_flag = ''Y'' ',
'ORDER BY employee_num;    '))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_display_when=>'P17_ACTION'
,p_display_when2=>'Delegate'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(24608376141319276)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28344400047425615)
,p_name=>'P17_ACTION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28480989983048380)
,p_name=>'P17_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Id'
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>wwv_flow_api.id(24607996412319278)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28481392369048376)
,p_name=>'P17_TAC_FORM_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>'TAC_FORM_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28481745258048376)
,p_name=>'P17_STEP_NO'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>'STEP_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28482119407048375)
,p_name=>'P17_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>'PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28482599841048371)
,p_name=>'P17_PERSON_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>'PERSON_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28482998422048371)
,p_name=>'P17_ROLE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>'ROLE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28483327572048370)
,p_name=>'P17_ACTION_REQUIRED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>'ACTION_REQUIRED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28483736768048370)
,p_name=>'P17_RECEVIED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_prompt=>'Recevied Date'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'RECEVIED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(24608249101319276)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28484594053048369)
,p_name=>'P17_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28484925180048369)
,p_name=>'P17_ACTION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>'ACTION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28485733426048369)
,p_name=>'P17_COMMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_prompt=>'Comment'
,p_source=>'COMMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>255
,p_cHeight=>4
,p_field_template=>wwv_flow_api.id(24608420696319276)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28486163445048368)
,p_name=>'P17_APPROVAL_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>'APPROVAL_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28486554200048368)
,p_name=>'P17_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28487311538048368)
,p_name=>'P17_CREATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>'CREATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28487783032048367)
,p_name=>'P17_UPDATED_BY_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>'UPDATED_BY_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28488167754048367)
,p_name=>'P17_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28488992374048366)
,p_name=>'P17_ROLE_DESC'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(28480590590048381)
,p_item_source_plug_id=>wwv_flow_api.id(28480590590048381)
,p_source=>'ROLE_DESC'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(28484298245048370)
,p_validation_name=>'P17_RECEVIED_DATE must be timestamp'
,p_validation_sequence=>70
,p_validation=>'P17_RECEVIED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(28483736768048370)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(28485430621048369)
,p_validation_name=>'P17_ACTION_DATE must be timestamp'
,p_validation_sequence=>90
,p_validation=>'P17_ACTION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(28484925180048369)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(28487009591048368)
,p_validation_name=>'P17_CREATED_ON must be timestamp'
,p_validation_sequence=>120
,p_validation=>'P17_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(28486554200048368)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(28488674772048367)
,p_validation_name=>'P17_UPDATED_ON must be timestamp'
,p_validation_sequence=>150
,p_validation=>'P17_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(28488167754048367)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(28494912527048361)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(28494893242048361)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(28495769391048360)
,p_event_id=>wwv_flow_api.id(28494912527048361)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28498066091048358)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(28480590590048381)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form TAC Committee Approve Reject Action'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28345260980425623)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approve Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_to_person_id     number;',
'l_min_count_to_approve      Number;',
'l_member_id                 number;',
'l_MEMBER_ROLE               NUMBER;',
'l_count                    number :=  apex_application.g_f01.count;',
'BEGIN',
'',
'if :IS_COMMITTEE_SECRETARY > 0 and :P17_IS_FINAL_STEP = ''N''',
'Then  -- Secretary',
'     select c.min_count_to_approve ',
'        into l_min_count_to_approve',
'        from tac_committees c',
'        where c.committee_type = (select c.committee_type',
'                                from tac_committees c',
'                            where (select s.estimated_amount ',
'                                    from tac_form s',
'                                        where s.id = :P17_TAC_FORM_ID) BETWEEN c.AUTHORIZED_AMOUNT_FROM and nvl(AUTHORIZED_AMOUNT_TO,9999999999)',
'                                                  and sysdate between start_date and nvl(end_date, sysdate + 100)',
'                                  );',
'',
'    if l_count < l_min_count_to_approve + 1  ',
'    Then ',
'        apex_error.add_error (  p_message          => ''Please select at least '' || to_char(l_min_count_to_approve)  || '' members to submit.'' ,',
'                                p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                );',
'    else',
'    for i in 1..l_count',
'    loop',
'        select m.member_id , m.MEMBER_ROLE',
'        into l_member_id , l_MEMBER_ROLE',
'        from tac_committee_members m',
'        where m.id = to_number(apex_application.g_f01(i));',
'        INSERT INTO tac_form_approval_history (',
'                                        TAC_FORM_ID,',
'                                        step_no,',
'                                        person_id,',
'                                        role_id,',
'                                        role_desc,',
'                                        action_required,',
'                                        recevied_date,',
'                                        status,',
'                                        approval_type',
'                                    ) VALUES (',
'                                        :P17_TAC_FORM_ID,',
'                                        tac_form_workflow2.GET_MAX_STEP( :P17_TAC_FORM_ID ),',
'                                        l_member_id,',
'                                        l_MEMBER_ROLE,',
'                                        (select value',
'                                            from dct_lookup_values v ',
'                                            where v.value_id =l_MEMBER_ROLE),',
'                                        ''Endorse/Reject'',',
'                                        SYSTIMESTAMP,',
'                                        ''Pending'',',
'                                        ''TAC_APPROVAL''); ',
'    end loop;',
'                    UPDATE tac_form_approval_history',
'                     SET    status = ''Approved'', action_date = systimestamp',
'                     WHERE  id = :P17_ID;',
'-- Send Email for Pending Users',
'for emp in (select PERSON_ID ,  id',
'            from tac_form_approval_history',
'            where TAC_FORM_ID = :P17_TAC_FORM_ID',
'            and STATUS = ''Pending'')',
'    Loop',
'              ',
'tac_form_email.TAC_FORM_ACTION_REQUIRED_EMAIL(:P17_TAC_FORM_ID , emp.PERSON_ID, ''TAC_FORM_ACTION_REQUIRED'', emp.id, :P17_COMMENTS );',
'',
'    End Loop;              ',
'update tac_form set meeting_id = :P17_MEETNG_NUMBER where id = :P17_TAC_FORM_ID;',
'',
'INSERT INTO tac_meeting_agenda ( meeting_id, request_id,notes, request_type) ',
'VALUES (:P17_MEETNG_NUMBER,:P17_TAC_FORM_ID,:P17_COMMENTS,2);',
'',
'-- Insert Committe Secrtarty     ',
'     INSERT INTO tac_form_approval_history (',
'                        TAC_FORM_ID,',
'                        step_no,',
'                        person_id,',
'                        role_id,',
'                        role_desc,',
'                        action_required,',
'                        recevied_date,',
'                        status,',
'                        approval_type ,FINAL_STEP_YN',
'                    ) VALUES (',
'                        :P17_TAC_FORM_ID,',
'                        tac_form_workflow2.GET_MAX_STEP(:P17_TAC_FORM_ID)+ 1,',
'                        :PERSON_ID,',
'                        87,',
'                        ''Secretary'',',
'                        ''Endorse/Reject'',',
'                        SYSTIMESTAMP,',
'                        ''Future'',',
'                        ''TAC_APPROVAL'' , ''Y''); ',
'    end if;',
'Elsif :P17_IS_TAC_MEMBER = 1',
'Then',
'    tac_form_workflow2.approve_TAC2(:P17_TAC_FORM_ID,:PERSON_ID, :P17_COMMENTS);',
'    UPDATE TAC_form',
'    SET  decision = :p17_decision,',
'         decision_option = :p17_decision_option ',
'    --    ,meeting_number = :p17_meetng_number',
'    WHERE',
'        id = :P17_TAC_FORM_ID;',
'elsif',
'    :P17_IS_FINAL_STEP = ''Y'' Then tac_form_workflow2.FINAL_APPROVE(:P17_TAC_FORM_ID,:PERSON_ID, :P17_COMMENTS);',
'    update tac_form set DECISION = :P17_DECISION , DECISION_OPTION = :P17_DECISION_OPTION where id = :P17_TAC_FORM_ID;',
'elsif    ',
':IS_COMMITTEE_SECRETARY = 0 Then',
' tac_form_workflow2.Approve(:P17_TAC_FORM_ID,:PERSON_ID, :P17_COMMENTS);',
'End if;',
'',
'End;'))
,p_process_error_message=>'Error while Endorse'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(28344546641425616)
,p_process_success_message=>'Endorse Successfully. '
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>143576171933264960
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(12728667058342373)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reject Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
'IF :P17_COMMENTS is null THEN',
'                    apex_error.add_error(p_message => ''Please enter your comment! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'else',
'    tac_form_workflow2.REJECT(:P17_TAC_FORM_ID,:PERSON_ID, :P17_COMMENTS);',
' End if;',
'End;'))
,p_process_error_message=>'Not Rejected. Kindly contact System Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(28344887804425619)
,p_process_success_message=>'Rejected.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(12728797383342374)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delegate Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
'IF :P17_TO_PERSON_ID is null THEN',
'                    apex_error.add_error(p_message => ''Please Select the person! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'else',
'    tac_form_workflow2.DELEGATE(:P17_TAC_FORM_ID,:PERSON_ID , :P17_TO_PERSON_ID, :P17_COMMENTS );	',
' End if;',
'End;'))
,p_process_error_message=>'Not Delegated. Kindly contact system admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(12728839941342375)
,p_process_success_message=>'Delegated.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28498431615048358)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28497655725048358)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(28480590590048381)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form TAC Committee Approve Reject Action'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
