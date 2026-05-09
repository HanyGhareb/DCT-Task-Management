prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>145171879539529295
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>7
,p_user_interface_id=>wwv_flow_api.id(24631887413319249)
,p_name=>'Single Source Approve Reject Actions'
,p_alias=>'SINGLE-SOURCE-APPROVE-REJECT-ACTIONS'
,p_page_mode=>'MODAL'
,p_step_title=>'Single Source Approve Reject Actions'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Form-label {',
'    	color: #368ed2;',
'	font-weight: bold;',
'	font-size:12px;',
'}',
'.oj-listbox-result-label{',
'color: red;}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220306130725'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(25757666975976149)
,p_plug_name=>'Single Source Approve Reject Actions'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24519865163319333)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'SCM_SINGL_SOURCE_APPROVAL_HISTORY'
,p_query_where=>'PERSON_ID = :PERSON_ID and SINGL_SOURCE_ID = :P7_SINGL_SOURCE_ID'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(277102128122527)
,p_plug_name=>'Select Buyer'
,p_parent_plug_id=>wwv_flow_api.id(25757666975976149)
,p_icon_css_classes=>'fa-emoji-neutral'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24547287062319317)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT apex_item.checkbox2(1,d.person_id) Selected,',
'        d.person_id , e.full_name_en ,',
'CASE',
'        WHEN dbms_lob.getlength(e.photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || e.user_name',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END PHOTO_hidden,',
'        null PHOTO',
'FROM dct_data_access_assignment d , employees_v e',
'where d.person_id = e.person_id',
'and d.entity_type_id = ''ROLE'' ',
'and d.entity_id = 48 ',
'and d.status = ''A'' ',
'and sysdate BETWEEN d.start_date and nvl(d.end_date , sysdate + 10);'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--:FORWARD_TO_BUYER = 1 and :P7_ACTION = ''Approve''',
'',
'',
':IS_SUPPLY_MANAGEMENT_UNIT_HEAD	= 1 and :P7_ACTION = ''Approve'' and :IS_COMMITTEE_SECRETARY	= 0'))
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Buyers'
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
 p_id=>wwv_flow_api.id(277024556122526)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>28708337107375936
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(276952200122525)
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
 p_id=>wwv_flow_api.id(276842717122524)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(276751084122523)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Buyer Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(276605717122522)
,p_db_column_name=>'PHOTO_HIDDEN'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Photo Hidden'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(276470510122521)
,p_db_column_name=>'PHOTO'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Photo'
,p_column_html_expression=>'<image src=''#PHOTO_HIDDEN#'' width=75 height=75>'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(41871089740861)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'290273'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SELECTED:PHOTO:FULL_NAME_EN:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(276416838122520)
,p_plug_name=>'Select Committee Members'
,p_parent_plug_id=>wwv_flow_api.id(25757666975976149)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24547287062319317)
,p_plug_display_sequence=>20
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
'from TAC_COMMITTEE_MEMBERS c, employees_v e',
' where c.member_id = e.person_id',
' and committee_id = (select c.id ',
'                     from tac_committees c',
'                     where ((select s.requested_amount',
'                                from scm_singl_source s',
'                                where s.id = :P7_SINGL_SOURCE_ID) BETWEEN AUTHORIZED_AMOUNT_FROM and nvl(AUTHORIZED_AMOUNT_TO,999999999999))',
'                                and sysdate between c.start_date and nvl(c.end_date, sysdate + 100))',
'and c.member_role != 87',
'order by c.seq;',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P7_SINGL_SOURCE_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_commitee_id   Number;',
'',
'begin',
'',
'if (:IS_COMMITTEE_SECRETARY > 0  and ',
'    :P7_ACTION = ''Approve''       and ',
'    :P7_IS_FINAL_STEP = ''N''      and',
'    :P7_COMMITEE_ID > 0)',
'',
'    Then',
'        return true;',
'    else ',
'        return false;',
'End if;',
'End;'))
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
 p_id=>wwv_flow_api.id(276328649122519)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>28709033014375943
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(276003284122516)
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
 p_id=>wwv_flow_api.id(275943424122515)
,p_db_column_name=>'ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(275776413122514)
,p_db_column_name=>'COMMITTEE_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Committee Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(275666876122513)
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
 p_id=>wwv_flow_api.id(275614117122512)
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
 p_id=>wwv_flow_api.id(91514681880539)
,p_db_column_name=>'START_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91568646880540)
,p_db_column_name=>'END_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91685741880541)
,p_db_column_name=>'STATUS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91742897880542)
,p_db_column_name=>'COMMENTS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(91874094880543)
,p_db_column_name=>'CREATED_BY_PERSON_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created By Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92031222880544)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92132809880545)
,p_db_column_name=>'UPDATED_BY_PERSON_ID'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated By Person Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92171646880546)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92312637880547)
,p_db_column_name=>'SEQ'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92395602880548)
,p_db_column_name=>'PHOTO_HIDDEN'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Photo Hidden'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(92521198880549)
,p_db_column_name=>'PHOTO'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Photo'
,p_column_html_expression=>'<image src=''#PHOTO_HIDDEN#'' width=75 height=75>'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(106369861840947)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'290918'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SELECTED:PHOTO:MEMBER_ID:MEMBER_ROLE:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2467797381682949)
,p_plug_name=>'Select SCM Unit Head'
,p_parent_plug_id=>wwv_flow_api.id(25757666975976149)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(24547287062319317)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT apex_item.checkbox2(1,d.person_id) Selected,',
'        d.person_id , e.full_name_en ,',
'CASE',
'        WHEN dbms_lob.getlength(e.photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || e.user_name',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END PHOTO_hidden,',
'        null PHOTO',
'FROM dct_data_access_assignment d , employees_v e',
'where d.person_id = e.person_id',
'and d.entity_type_id = ''ROLE'' ',
'and d.entity_id = 31 ',
'and d.status = ''A'' ',
'and sysdate BETWEEN d.start_date and nvl(d.end_date , sysdate + 10);'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':IS_SOUCEING_MANAGER= 1 and :P7_ACTION = ''Approve'''
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Select SCM Unit Head'
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
 p_id=>wwv_flow_api.id(2467873741682950)
,p_max_row_count=>'1000000'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>31453235405181412
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2467944149682951)
,p_db_column_name=>'SELECTED'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Select'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_format_mask=>'PCT_GRAPH:::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2468097543682952)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2468182676682953)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2468328656682954)
,p_db_column_name=>'PHOTO_HIDDEN'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Photo Hidden'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2468377110682955)
,p_db_column_name=>'PHOTO'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Photo'
,p_column_html_expression=>'<image src=''#PHOTO_HIDDEN#'' width=75 height=75>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(2592314240981202)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'315777'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SELECTED:PERSON_ID:FULL_NAME_EN:PHOTO_HIDDEN:PHOTO'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(25767082157976138)
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
 p_id=>wwv_flow_api.id(25767498389976138)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(25767082157976138)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(24609320066319275)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25769059039976136)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(25767082157976138)
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
 p_id=>wwv_flow_api.id(25769438127976135)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(25767082157976138)
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
 p_id=>wwv_flow_api.id(25769818581976135)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(25767082157976138)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25747889302248413)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(25767082157976138)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(24609474578319275)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P7_ACTION'
,p_button_condition2=>'Approve'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-check-square'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26242475670246048)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(25767082157976138)
,p_button_name=>'Delegate'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(24609474578319275)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P7_ACTION'
,p_button_condition2=>'Delegate'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-info'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25747980368248414)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(25767082157976138)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(24609474578319275)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P7_ACTION'
,p_button_condition2=>'Reject'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-check-square'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(25748280505248417)
,p_branch_name=>'Go to 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(92549342880550)
,p_name=>'P7_IS_TAC_MEMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT nvl(COUNT(*),0) ',
'FROM scm_singl_source_approval_history h',
'where id = :P7_ID',
'and h.person_id = :PERSON_ID',
'and ROLE_ID in (69, 70,71)'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(92651191880551)
,p_name=>'P7_IS_FINAL_STEP'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_item_source_plug_id=>wwv_flow_api.id(25757666975976149)
,p_source=>'FINAL_STEP_YN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(93091912880555)
,p_name=>'P7_DECISION'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_prompt=>'Decision'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>3
,p_display_when=>'P7_IS_FINAL_STEP'
,p_display_when2=>'D'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(24607996412319278)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(93804451880562)
,p_name=>'P7_DECISION_OPTION'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
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
,p_display_when=>'P7_IS_FINAL_STEP'
,p_display_when2=>'D'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(24608376141319276)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'5'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(499868213969652)
,p_name=>'P7_MEETNG_NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_prompt=>'Meetng No:'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select TAC_MEETING_AGENDA.MEETING_ID as MEETING_ID ',
' from TAC_MEETING_AGENDA TAC_MEETING_AGENDA',
' where request_id = :P7_SINGL_SOURCE_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct meeting_number from tac_meetings',
'UNION ',
'select DISTINCT meeting_number from tac_meetings'))
,p_cSize=>20
,p_display_when=>':P7_IS_FINAL_STEP = ''N'' and :IS_COMMITTEE_SECRETARY > 0'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(24608376141319276)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2468509412682956)
,p_name=>'P7_RECOMMENDATION'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_prompt=>'Recommendation'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>2
,p_display_when=>'IS_BUYER'
,p_display_when2=>'1'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(24608099134319277)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(23092643623022168)
,p_name=>'P7_COMMITEE_ID'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT  nvl(count(c.id),0)',
'FROM   tac_committees c',
'WHERE ( ',
'        ( SELECT  s.requested_amount',
'          FROM   scm_singl_source s',
'          WHERE  s.id = :p7_singl_source_id) ',
'          BETWEEN authorized_amount_from ',
'                    AND nvl(authorized_amount_to, 999999999999) ',
'       )',
'AND sysdate BETWEEN c.start_date AND nvl(c.end_date, sysdate + 100);'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25747569893248410)
,p_name=>'P7_ACTION'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25757947828976148)
,p_name=>'P7_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_item_source_plug_id=>wwv_flow_api.id(25757666975976149)
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25758287279976145)
,p_name=>'P7_SINGL_SOURCE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_item_source_plug_id=>wwv_flow_api.id(25757666975976149)
,p_source=>'SINGL_SOURCE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25758619706976144)
,p_name=>'P7_STEP_NO'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_item_source_plug_id=>wwv_flow_api.id(25757666975976149)
,p_source=>'STEP_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25759044612976144)
,p_name=>'P7_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_item_source_plug_id=>wwv_flow_api.id(25757666975976149)
,p_source=>'PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25759433446976143)
,p_name=>'P7_ROLE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_item_source_plug_id=>wwv_flow_api.id(25757666975976149)
,p_source=>'ROLE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25759806079976143)
,p_name=>'P7_ROLE_DESC'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_item_source_plug_id=>wwv_flow_api.id(25757666975976149)
,p_source=>'ROLE_DESC'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25760270555976143)
,p_name=>'P7_ACTION_REQUIRED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_item_source_plug_id=>wwv_flow_api.id(25757666975976149)
,p_source=>'ACTION_REQUIRED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25760626854976143)
,p_name=>'P7_RECEVIED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_item_source_plug_id=>wwv_flow_api.id(25757666975976149)
,p_source=>'RECEVIED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25761499893976142)
,p_name=>'P7_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_item_source_plug_id=>wwv_flow_api.id(25757666975976149)
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25761888344976142)
,p_name=>'P7_ACTION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_item_source_plug_id=>wwv_flow_api.id(25757666975976149)
,p_source=>'ACTION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25762622370976142)
,p_name=>'P7_COMMENT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_item_source_plug_id=>wwv_flow_api.id(25757666975976149)
,p_prompt=>'Comment'
,p_source=>'COMMENT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>255
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(24607996412319278)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
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
,p_default_id_offset=>145171879539529295
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(25763076710976141)
,p_name=>'P7_APPROVAL_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
,p_item_source_plug_id=>wwv_flow_api.id(25757666975976149)
,p_source=>'APPROVAL_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26781667318539101)
,p_name=>'P7_TO_PERSON_ID'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(25757666975976149)
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
,p_display_when=>'P7_ACTION'
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
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(25761103114976142)
,p_validation_name=>'P7_RECEVIED_DATE must be timestamp'
,p_validation_sequence=>70
,p_validation=>'P7_RECEVIED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(25760626854976143)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(25762335645976142)
,p_validation_name=>'P7_ACTION_DATE must be timestamp'
,p_validation_sequence=>90
,p_validation=>'P7_ACTION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(25761888344976142)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(25767578116976138)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(25767498389976138)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(25768322540976137)
,p_event_id=>wwv_flow_api.id(25767578116976138)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(25770657729976135)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(25757666975976149)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Single Source Approve Reject Actions'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(25748091510248415)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approve Action'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_to_person_id          NUMBER;',
'    l_min_count_to_approve  NUMBER;',
'    l_member_id             NUMBER;',
'    l_member_role           NUMBER;',
'    l_count                 NUMBER := apex_application.g_f01.count;',
'    l_requested_amount      Number;',
'    l_step_no               number;',
'BEGIN',
'-- get Single Source Amount ',
'SELECT s.requested_amount',
'into l_requested_amount',
'FROM scm_singl_source s',
'WHERE  s.id = :p7_singl_source_id;',
'',
'-- Souring Manager',
'if :IS_SOUCEING_MANAGER = 1 Then ',
'        IF l_count = 0 THEN',
'                    apex_error.add_error(p_message => ''Please select at least one Unit Head! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'                ELSIF l_count > 0 THEN',
'                    single_source_workflow.approve_forward(:p7_singl_source_id, :person_id,:P7_COMMENT);',
'                    FOR i IN 1..l_count LOOP',
'                        l_to_person_id := to_number(apex_application.g_f01(i));',
'                        single_source_workflow.INSERT_SCM_UNIT_HEAD(l_to_person_id, :p7_step_no, :p7_singl_source_id, ''Pending'');',
'                        SINGLE_SOURCE_EMAIL.SINGLE_SOURCE_ACTION_REQUIRED_EMAIL(:p7_singl_source_id ,l_to_person_id, ''SINGLE_SOURCE_ACTION_REQUIRED'' ,null , :P7_COMMENT);  -- 5/3/2022',
'                    END LOOP;',
'        ',
'                END IF;',
'--Unit Head                ',
'ELSIF :IS_SUPPLY_MANAGEMENT_UNIT_HEAD = 1 and (:P7_ROLE_ID <> 87 or :P7_ROLE_ID is null) Then   -- (role id  87 for Committee secratery emp) THEN  -- Buyer',
'        IF l_count = 0 THEN',
'            apex_error.add_error(p_message => ''Please select at least one Buyer to process the single source request! '',',
'                                p_display_location => apex_error.c_inline_with_field_and_notif);',
'        ELSIF l_count > 0 THEN',
'            single_source_workflow.approve_forward(:p7_singl_source_id, :person_id,:P7_COMMENT);',
'            FOR i IN 1..l_count LOOP',
'                l_to_person_id := to_number(apex_application.g_f01(i));',
'                single_source_workflow.insert_buyer(l_to_person_id, :p7_step_no, :p7_singl_source_id, ''Pending'');',
'                SINGLE_SOURCE_EMAIL.SINGLE_SOURCE_ACTION_REQUIRED_EMAIL(:p7_singl_source_id ,l_to_person_id, ''SINGLE_SOURCE_ACTION_REQUIRED'' ,null , :P7_COMMENT);      -- 5/3/2022',
'            END LOOP;',
'',
'        END IF;',
'-- Buyer',
'ELSIF :IS_BUYER = 1  and (:P7_ROLE_ID <> 87 or :P7_ROLE_ID is null) Then   -- (role id  87 for Committee secratery emp)',
'    if :P7_RECOMMENDATION is null then --(if recommendation null) start',
'         apex_error.add_error(p_message => ''Please enter your recommendation '',',
'                                p_display_location => apex_error.c_inline_with_field_and_notif);',
'      else',
'            single_source_workflow.approve(:p7_singl_source_id, :person_id,:P7_COMMENT);',
'            UPDATE scm_singl_source',
'            SET  recommendation = :P7_RECOMMENDATION',
'            WHERE id = :p7_singl_source_id;',
'   end if;   --(if recommendation null) End      ',
'-- Committee Secretary',
'ELSIF  :is_committee_secretary > 0',
'        AND :p7_is_final_step = ''N''',
'        AND :P7_COMMITEE_ID > 0',
'    --    and :P7_ROLE_ID = 87 Then   -- (role id  87 for Committee secratery emp)',
'    THEN  -- Secretary',
'    ',
'        SELECT c.min_count_to_approve',
'        INTO l_min_count_to_approve',
'        FROM  tac_committees c',
'        WHERE  c.committee_type = ( SELECT  c.committee_type',
'                                    FROM     tac_committees c',
'                                    WHERE l_requested_amount',
'                                         BETWEEN c.authorized_amount_from ',
'                                            AND nvl(authorized_amount_to, 9999999999)',
'                                    and sysdate between start_date and nvl(end_date, sysdate + 100)',
'                                );',
'',
'        IF l_count < l_min_count_to_approve + 1 THEN',
'            apex_error.add_error(p_message => ''Please select at least ''',
'                                              || to_char(l_min_count_to_approve )',
'                                              || '' members to submit.'',',
'                                p_display_location => apex_error.c_inline_with_field_and_notif);',
'',
'        ELSE',
'            l_step_no := single_source_workflow.get_max_step(:p7_singl_source_id) + 1;',
'            FOR i IN 1..l_count LOOP',
'                SELECT  m.member_id,  m.member_role',
'                 INTO   l_member_id, l_member_role',
'                FROM    tac_committee_members m',
'                WHERE   m.id = to_number(apex_application.g_f01(i));',
'',
'                INSERT INTO scm_singl_source_approval_history (',
'                    singl_source_id,',
'                    step_no,',
'                    person_id,',
'                    role_id,',
'                    role_desc,',
'                    action_required,',
'                    recevied_date,',
'                    status,',
'                    approval_type',
'                ) VALUES (',
'                    :p7_singl_source_id,',
'                    l_step_no,',
'                    l_member_id,',
'                    l_member_role,',
'                    ( SELECT  value',
'                        FROM  dct_lookup_values v',
'                        WHERE v.value_id = l_member_role',
'                    ),',
'                    ''Endorsement'',',
'                    systimestamp,',
'                    ''Future'',',
'                    ''SS_APPROVAL'');',
'            END LOOP;',
'    -- update to add hash code',
'   -- UPDATE scm_singl_source_approval_history set hash_code = apex_util.get_hash(apex_t_varchar2(SINGL_SOURCE_ID, id )) where singl_source_id = :p7_singl_source_id and ',
'            UPDATE scm_singl_source_approval_history',
'            SET  status = ''Endorse'', action_date = systimestamp',
'            WHERE  id = :p7_id;',
'        -- update next to Pending',
'            UPDATE scm_singl_source_approval_history',
'            SET  status = ''Pending'', recevied_date = systimestamp, hash_code = apex_util.get_hash(apex_t_varchar2(SINGL_SOURCE_ID, id ))',
'            WHERE  STEP_NO = :p7_step_no + 1',
'            and singl_source_id = :p7_singl_source_id;',
'   -- send Email to pending members',
'   for empRec in (select person_id from scm_singl_source_approval_history where singl_source_id = :p7_singl_source_id and  status = ''Pending'' ) loop',
'       SINGLE_SOURCE_EMAIL.SINGLE_SOURCE_ACTION_REQUIRED_EMAIL(:p7_singl_source_id ,empRec.person_id , ''SINGLE_SOURCE_ACTION_REQUIRED'' ,null , :P7_COMMENT);',
'      End loop;',
'        -- Insert committe undersecrteray',
'        single_source_workflow.insert_committee_secretary(:p7_singl_source_id, ''Future'', ''D'');    ',
'        -- insert EDSS',
'        single_source_workflow.INSERT_SSED  (:p7_singl_source_id, ''Future'');',
'        ',
'        -- insert US AND / OR Chairman',
'        if l_requested_amount > 1000000 and l_requested_amount <= 10000000',
'                then',
'--                    single_source_workflow.insert_committee_secretary(:p7_singl_source_id, ''Future'', ''D'');',
'                    single_source_workflow.insert_dct_undersecretary(:p7_singl_source_id, ''Future'', ''Y'');',
'                else',
'--                    single_source_workflow.insert_committee_secretary(:p7_singl_source_id, ''Future'', ''D'');',
'                    single_source_workflow.insert_dct_undersecretary(:p7_singl_source_id, ''Future'', ''N'');',
'                    single_source_workflow.insert_dct_chairman(:p7_singl_source_id, ''Future'', ''Y'');',
'        end if;   ',
'            -- Add Meeting calendar',
'            insert into tac_meeting_agenda (meeting_id, REQUEST_ID, NOTES) values ((select id',
'                                                                                    from tac_meetings',
'                                                                                    where meeting_number = :P7_MEETNG_NUMBER) , :p7_singl_source_id,:P7_COMMENT);',
'                 ',
'        END IF;',
'',
'ELSIF :p7_is_tac_member = 1 THEN',
'        single_source_workflow.approve_tac(:p7_singl_source_id, :person_id, :P7_COMMENT);',
'        insert into test values (''approve process  :p7_is_tac_member = 1'');',
'    -- Secretary ends by reject',
'    ELSIF :p7_is_final_step = ''D'' and :P7_DECISION_OPTION in (90,91) THEN    --( for decision: TO Be Resubmitted, Rejected)',
'        if :p7_decision is null then ',
'            apex_error.add_error(p_message => ''Please enter your decision! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'          else',
'               single_source_workflow.final_approve(:p7_singl_source_id, :person_id, :P7_COMMENT);',
'                UPDATE scm_singl_source',
'                SET',
'                    decision = :p7_decision,',
'                    decision_option = :p7_decision_option,',
'                    meeting_number = :p7_meetng_number',
'                WHERE',
'                    id = :p7_singl_source_id;',
'                    -- remove Undersecratary if it''s rejected by committee',
'                    delete from scm_singl_source_approval_history where step_no = :p7_step_no + 1;',
'          End if ;  ',
'ELSIF :p7_is_final_step = ''D'' and :P7_DECISION_OPTION not in (90,91)  THEN  --(Endorsed, Endorsed with Condition)',
'        if :p7_decision is null then ',
'            apex_error.add_error(p_message => ''Please enter your decision! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'        else',
'        single_source_workflow.approve(:p7_singl_source_id, :person_id,:P7_COMMENT);',
'        UPDATE scm_singl_source',
'        SET',
'            decision = :p7_decision,  decision_option = :p7_decision_option,',
'            meeting_number = :p7_meetng_number',
'        WHERE  id = :p7_singl_source_id;',
'        end if ;',
'',
'    ELSIF :p7_is_final_step = ''Y'' THEN',
'        single_source_workflow.final_approve(:p7_singl_source_id, :person_id, :P7_COMMENT);',
'    ELSIF',
'        :IS_SUPPLY_MANAGEMENT_UNIT_HEAD = 0',
'        AND :is_committee_secretary = 0',
'        AND :IS_SOUCEING_MANAGER = 0',
'    THEN',
'        single_source_workflow.approve(:p7_singl_source_id, :person_id,:P7_COMMENT);',
'    END IF;',
'END;'))
,p_process_error_message=>'Error while approve, Please contact system admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(25747889302248413)
,p_process_success_message=>'Approved Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(25748173755248416)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reject Action'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
'IF :P7_COMMENT is null THEN',
'                    apex_error.add_error(p_message => ''Please enter your comment! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'else',
'    single_source_workflow.Reject(:P7_SINGL_SOURCE_ID,:PERSON_ID, :P7_COMMENT);',
' End if;',
'End;'))
,p_process_error_message=>'Error while Reject, Please contact system admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(25747980368248414)
,p_process_success_message=>'Rejected.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(26781711571539102)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delegate Action'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'single_source_workflow.DELEGATE(:P7_SINGL_SOURCE_ID,:PERSON_ID , :P7_TO_PERSON_ID, :P7_COMMENT);',
'',
'end;'))
,p_process_error_message=>'error while Delegated, Please contact system admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(26242475670246048)
,p_process_success_message=>'Delegated'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(25771080826976135)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(25770233564976135)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(25757666975976149)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Single Source Approve Reject Actions'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
