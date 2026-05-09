prompt --application/pages/page_00013
begin
--   Manifest
--     PAGE: 00013
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
 p_id=>13
,p_user_interface_id=>wwv_flow_api.id(24631887413319249)
,p_name=>'Submit TAC Approval '
,p_alias=>'SUBMIT-TAC-APPROVAL'
,p_step_title=>'Submit TAC Approval '
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210321103803'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(28097000908457475)
,p_plug_name=>'Send to'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(24547287062319317)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(27846085093814436)
,p_plug_name=>'T&AC Members'
,p_parent_plug_id=>wwv_flow_api.id(28097000908457475)
,p_region_template_options=>'#DEFAULT#:t-Form--noPadding:t-Form--stretchInputs:margin-top-none:margin-bottom-none:margin-left-none:margin-right-none'
,p_plug_template=>wwv_flow_api.id(24545364387319318)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>8
,p_plug_display_column=>2
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
' and committee_id = (select c.id',
'from tac_committees c',
'where c.committee_type = :P13_TAC_TYPE',
'and c.status = ''A''',
'and sysdate BETWEEN c.start_date and nvl(c.end_date, sysdate+10))'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P13_TAC_TYPE'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'T&AC Members'
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
 p_id=>wwv_flow_api.id(28109094025300202)
,p_max_row_count=>'1000000'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>28109094025300202
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28109111281300203)
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
 p_id=>wwv_flow_api.id(28110428232300216)
,p_db_column_name=>'PHOTO'
,p_display_order=>20
,p_column_identifier=>'N'
,p_column_label=>'Photo'
,p_column_html_expression=>'<image src=''#PHOTO_HIDDEN#'' width=75 height=75>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28109363836300205)
,p_db_column_name=>'MEMBER_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(25227436734855051)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28109435608300206)
,p_db_column_name=>'MEMBER_ROLE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Member Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(26650222993628901)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28109266949300204)
,p_db_column_name=>'COMMITTEE_ID'
,p_display_order=>50
,p_column_identifier=>'B'
,p_column_label=>'Committee Id'
,p_column_type=>'NUMBER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28109505489300207)
,p_db_column_name=>'START_DATE'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28109633652300208)
,p_db_column_name=>'END_DATE'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28109783799300209)
,p_db_column_name=>'STATUS'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28109819152300210)
,p_db_column_name=>'COMMENTS'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28109968513300211)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Created By Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28110075729300212)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28110141113300213)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>120
,p_column_identifier=>'K'
,p_column_label=>'Updated By Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28110280542300214)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28110304163300215)
,p_db_column_name=>'SEQ'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28110516881300217)
,p_db_column_name=>'PHOTO_HIDDEN'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo Hidden'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(28111316687300225)
,p_db_column_name=>'ID'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(28125966604293935)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'281260'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SELECTED:PHOTO:MEMBER_ID:MEMBER_ROLE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(28346092476425631)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24556678455319312)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(24493261337319361)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(24610734179319274)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28110797548300219)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(28346092476425631)
,p_button_name=>'Submit'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(24609474578319275)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(28346155941425632)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(28346092476425631)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(24609320066319275)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_ID:&P13_ID.'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(28345925139425630)
,p_branch_action=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.::P12_ID:&P13_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_COMPUTATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(27845859987814434)
,p_name=>'P13_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(28097000908457475)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(27845920473814435)
,p_name=>'P13_TAC_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(28097000908457475)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28346240681425633)
,p_name=>'P13_FORM_NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(28097000908457475)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28111269360300224)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approve Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_member_id                 number;',
'l_MEMBER_ROLE               NUMBER;',
'l_min_count_to_approve      Number;',
'begin',
'',
'select c.min_count_to_approve ',
'into l_min_count_to_approve',
'from tac_committees c',
'where c.committee_type = (select f.tac_type',
'                        from tac_form f',
'                        where f.id = :P13_ID);',
'if apex_application.g_f01.count < l_min_count_to_approve + 1',
'    Then ',
'        apex_error.add_error (',
'                                p_message          => ''Please select at least '' || to_char(l_min_count_to_approve+1)  || '' members to submit.'' ,',
'                                p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                );',
'    Else',
'    -- Insert Submit User',
'    tac_form_workflow.INSERT_TAC_SUBMIT_USER(:P13_ID);',
'for i in 1..apex_application.g_f01.count loop',
'',
'select m.member_id , m.MEMBER_ROLE',
'into l_member_id , l_MEMBER_ROLE',
'from tac_committee_members m',
'where m.id = to_number(apex_application.g_f01(i));',
'',
'INSERT INTO tac_form_approval_history (',
'    tac_form_id,',
'    step_no,',
'    person_id,',
'    role_id,',
'    action_required,    -- ''Endorse/Reject''',
'    recevied_date,',
'    status,',
'    approval_type,',
'    role_desc',
') VALUES (',
'    :P13_ID,',
'    2,',
'    l_member_id,',
'    l_MEMBER_ROLE,',
'    ''Endorse/Reject'',',
'    SYSTIMESTAMP,',
'    ''Pending'',',
'    ''TAC_APPROVAL'',',
'    (select value',
'from dct_lookup_values v ',
'where v.value_id =l_MEMBER_ROLE)',
');',
'',
'end loop;',
'tac_form_workflow.INSERT_Undersecretary(:P13_ID, ''Future'');',
'update tac_form set tac_approval_status = ''In-Progress'' where id = :P13_ID;',
'',
'End if;',
'end;'))
,p_process_error_message=>'Error while submit :P13_FORM_NUMBER'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(28110797548300219)
,p_process_success_message=>'&P13_FORM_NUMBER. Submitted successfully'
);
wwv_flow_api.component_end;
end;
/
