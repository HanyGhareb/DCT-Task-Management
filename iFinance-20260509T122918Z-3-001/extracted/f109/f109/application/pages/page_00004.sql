prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>4
,p_user_interface_id=>wwv_flow_api.id(11217697745956116)
,p_name=>'Payment Recommendation Form'
,p_alias=>'PAYMENT-RECOMMENDATION-FORM'
,p_step_title=>'Payment Recommendation Form'
,p_allow_duplicate_submissions=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';',
'',
'function isTomorrow(pDateItem){  ',
'  function getTomorrow(){ ',
'    var tomorrow = new Date();',
'    tomorrow.setDate(tomorrow.getDate() + 1);',
'    return tomorrow;',
'  };',
'',
'  function cutTime(pDate){',
'    return new Date(pDate.getFullYear(), pDate.getMonth(), pDate.getDate());',
'  };',
'',
'  // check if pDateItem leads to a selection',
'  // check if it is a datepicker',
'  // check if a date has been selected',
'  if ( $(pDateItem).length ',
'       && $(pDateItem).data("datepicker")',
'       && $(pDateItem).datepicker("getDate") !== null ',
'     ) ',
'  {        ',
'    var tomorrow = getTomorrow();',
'    var check = $(pDateItem).datepicker("getDate");',
'    var one = cutTime(check);',
'    var two = cutTime(tomorrow);',
'',
'    return one.getDate() === two.getDate();',
'  };',
'  return false;',
'};',
'',
'function checkdates(pStartDate , pEndDate){',
'    ',
'    const date1 = new Date(pStartDate);',
'    const date2 = new Date(pEndDate);',
'  ',
'    if(date1 > date2){',
'       // console.log(`${pStartDate} is greater than ${pEndDate}`)',
'        return true;',
'    } else if(date1 < date2){',
'      //  console.log(`${pEndDate} is greater than ${pStartDate}`)',
'        return false;',
'    } else{',
'       // console.log(`Both dates are equal`)',
'         return false;',
'    }',
'};'))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'document.getElementById("P4_CONTRACT_NUMBER").readOnly = true;',
'document.getElementById("P4_APPROVAL_STATUS").readOnly = true; ',
'document.getElementById("P4_PAYMENT_NUMBER").readOnly = true; ',
'document.getElementById("P4_NET_AMOUNT_PAYABLE").readOnly = true;',
'document.getElementById("P4_PREVIOUSELY_CERIFIED_APPROVED").readOnly = true; ',
'document.getElementById("P4_PREVIOUSELY_CERIFIED_PENDING").readOnly = true; ',
'document.getElementById("P4_CUMULATIVE_CERIFIED_AMOUNT").readOnly = true; '))
,p_css_file_urls=>'#WORKSPACE_IMAGES#main.css'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Form-label {',
'    	color: #368ed2;',
'	font-weight: bold;',
'	font-size:12px;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231128215044'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11472926973490322)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(11142414762956053)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(11079053308956006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(11196517955956091)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11473592326490340)
,p_plug_name=>'Payment Application Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:margin-right-none'
,p_plug_template=>wwv_flow_api.id(11133056164956048)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'CWIP_PAYMENT_RECOMMENDATION'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_read_only_when_type=>'PLSQL_EXPRESSION'
,p_plug_read_only_when=>':P4_APPROVAL_STATUS not in (''Draft'' , ''Stopped'',''Returned'')'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11059658576190036)
,p_plug_name=>'Attachements'
,p_parent_plug_id=>wwv_flow_api.id(11473592326490340)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(11133056164956048)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11059753079190037)
,p_plug_name=>'Payment Recommendation Report'
,p_parent_plug_id=>wwv_flow_api.id(11059658576190036)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders:js-showMaximizeButton'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(11131192505956047)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       payment_recommendation_id,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       TAGS,',
'       CREATED,',
'       CREATED_BY,',
'       UPDATED,',
'       UPDATED_BY,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from cwip_payment_recommendation_documents',
' where payment_recommendation_id = :P4_PAYMENT_RECOMMENDATION_ID',
' order by created desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Payment Recommendation Report'
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
 p_id=>wwv_flow_api.id(11059850331190038)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No documents available'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>11059850331190038
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11059915919190039)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11060075077190040)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11060178617190041)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11060262198190042)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File'
,p_column_link=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_ID,P5_APPROVAL_STATUS,P5_CONTRACT_NUMBER:#ID#,&P4_APPROVAL_STATUS.,&P4_CONTRACT_NUMBER.'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11060322524190043)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11060418884190044)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11060527429190045)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
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
 p_id=>wwv_flow_api.id(11060635194190046)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'File Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11060761433190047)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11060809536190048)
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
 p_id=>wwv_flow_api.id(11060958170190049)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11061089801190050)
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
 p_id=>wwv_flow_api.id(11516574229797801)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11516675263797802)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11516736001797803)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:CWIP_PAYMENT_RECOMMENDATION_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(11526593659802563)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'115266'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:TAGS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(20782358760193915)
,p_plug_name=>'Invoice Details'
,p_parent_plug_id=>wwv_flow_api.id(11473592326490340)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(11133056164956048)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(21271734717381943)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(11473592326490340)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(11116089530956038)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11517482611797810)
,p_plug_name=>'Collaboration'
,p_icon_css_classes=>'fa-comments-o fa-anim-flash fam-sleep fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:margin-left-none'
,p_plug_template=>wwv_flow_api.id(11133056164956048)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(11517583689797811)
,p_name=>'Comments'
,p_parent_plug_id=>wwv_flow_api.id(11517482611797810)
,p_template=>wwv_flow_api.id(11105666197956032)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  ',
'    CASE when user_type = ''Internal'' Then',
'        CASE',
'            WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(user_name)',
'            ELSE',
'     --        ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'                 ''#WORKSPACE_IMAGES#no-photo(1).png''',
'       ',
'       END ',
'    when user_type = ''External'' Then',
'         CASE when dbms_lob.getlength(photo_blob) > 0 THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/ExtUser/view/'' || upper(user_name)',
'            ELSE',
'          --   ''https://ifinance.dct.gov.ae:8004/dct/prod/ExtUser/view/'' || ''U0000''',
'             ''#WORKSPACE_IMAGES#no-photo(1).png''',
'        End ',
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
',case comment_to_person_type',
'        When ''INT''',
'            Then (Select e.full_name_en',
'                    from employees_v e',
'                    where e.person_id = comment_to_person_id)',
'        When ''EXT''',
'            Then  (Select u.full_name_en',
'                    from dct_ext_users  u',
'                    where u.user_id = comment_to_person_id)',
'        else',
'            ',
'                ''All''',
'    End     Comment_to',
'--',
'from   ',
'(SELECT',
'    c.comment_id,',
'    c.payment_recommendation_id,',
'    c.comment_text,',
'    c.created_by_person_id,',
'    c.updated_by_person_id,',
'    c.creation_date,',
'    c.updated_date,',
'    c.action        action,',
'    e.full_name_en,',
'    e.user_name,',
'    e.photo_blob,',
'    ''Internal''  user_type,',
'    c.filename,',
'    c.file_blob',
'    ,c.comment_to_person_type,',
'    c.comment_to_person_id',
'FROM',
'    cwip_payment_recommendation_comments c , dct_employees_list2 e',
'where c.updated_by_person_id = e.person_id',
'UNION all',
'SELECT',
'    c.comment_id,',
'    c.payment_recommendation_id,',
'    c.comment_text,',
'    c.created_by_person_id,',
'    c.updated_by_person_id,',
'    c.creation_date,',
'    c.updated_date,',
'    c.action            action,',
'    e.full_name_en,',
'    e.user_name,',
'    e.photo_blob,',
'    ''External''  user_type,',
'    c.filename,',
'    c.file_blob',
'   , c.comment_to_person_type,',
'    c.comment_to_person_id',
'FROM',
'    cwip_payment_recommendation_comments c , dct_ext_users e',
'where c.updated_by_person_id = e.user_id)',
'where payment_recommendation_id = :P4_PAYMENT_RECOMMENDATION_ID',
'order by CREATION_DATE desc;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_query_row_template=>wwv_flow_api.id(11161938461956066)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Communications yet.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11517621614797812)
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
 p_id=>wwv_flow_api.id(11517740505797813)
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
 p_id=>wwv_flow_api.id(40200771100767404)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>14
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span style="color:blue">From: </span>#USER_NAME#, <br><span style="color:blue">To: </span>#COMMENT_TO#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11517923010797815)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>3
,p_column_heading=>'Message'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::P6_COMMENT_ID,P6_ACTION:#COMMENT_ID#,Edited'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11518012019797816)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>4
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11518174746797817)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>5
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11518224961797818)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>6
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11518372197797819)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>7
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11518417904797820)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<br>',
'<hr>'))
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11518547173797821)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11518609848797822)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_column_format=>'DOWNLOAD:CWIP_PAYMENT_RECOMMENDATION_COMMENTS:FILE_BLOB:COMMENT_ID::FILE_MIMETYPE:FILENAME:UPDATED_DATE:FILE_CHARSET:attachment:Document #FILENAME#:'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(11518746861797823)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>11
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(40072771438098349)
,p_query_column_id=>13
,p_column_alias=>'FILENAME'
,p_column_display_sequence=>12
,p_column_heading=>'Filename'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(40200639521767403)
,p_query_column_id=>14
,p_column_alias=>'COMMENT_TO'
,p_column_display_sequence=>13
,p_column_heading=>'Comment To'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11867700781373909)
,p_plug_name=>'Approval History'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(11133056164956048)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    id,',
'    payment_recommendation_id,',
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
'       PAYMENT_RECOMMENDATION_ID,',
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
'       RECEVIED_DATE,',
'       STATUS,',
'       ACTION_DATE,',
'       COMMENTS,',
'       APPROVAL_TYPE,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       (case person_type when ''INT''  Then',
'                                (select e.photo_blob from employees_v e where e.person_id = h.person_id)',
'                         when ''EXT''  Then',
'                                (select u.photo_blob from dct_ext_users u where u.user_id = h.person_id)',
'           End                      ) PHOTO_BLOB',
'      , h.on_behalf     ',
'  from CWIP_PAYMENT_REC_APPROVAL_HISTORY h',
'  where PAYMENT_RECOMMENDATION_ID = :P4_PAYMENT_RECOMMENDATION_ID)',
'  order by step_no , id '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
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
 p_id=>wwv_flow_api.id(11867873361373910)
,p_max_row_count=>'1000000'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>11867873361373910
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11867992308373911)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11868037924373912)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11868143692373913)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11868206894373914)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11868379564373915)
,p_db_column_name=>'PERSON_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Person Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11868473254373916)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11868509288373917)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11868626914373918)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11868713364373919)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11868841954373920)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11868954650373921)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11869087700373922)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11869136373373923)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11869248978373924)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11869320263373925)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11869436723373926)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11870090437373932)
,p_db_column_name=>'FULL_NAME'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11870166402373933)
,p_db_column_name=>'ROLE_NAME'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Role'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11870213925373934)
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
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11870302198373935)
,p_db_column_name=>'PHOTO'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(11893582222071274)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'118936'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:FULL_NAME:ROLE_NAME:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:PHOTO:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(21947705418250583)
,p_report_id=>wwv_flow_api.id(11893582222071274)
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
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(21948177124250583)
,p_report_id=>wwv_flow_api.id(11893582222071274)
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Rejected'
,p_condition_sql=>' (case when ("STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''Rejected''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FFD6D2'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11487396182490349)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11472926973490322)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11195131831956089)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:&P4_FROM_PAGE.:&SESSION.::&DEBUG.::P3_CONTRACT_NUMBER,P7_CONTRACT_NUMBER:&P4_CONTRACT_NUMBER.,&P4_CONTRACT_NUMBER.'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11516899649797804)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11059658576190036)
,p_button_name=>'Add_Attachement'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11194401589956088)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Attachement'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_PAYMENT_RECOMMENDATION_ID,P5_ALLOW_INSERT,P5_CONTRACT_NUMBER:&P4_PAYMENT_RECOMMENDATION_ID.,Y,&P4_CONTRACT_NUMBER.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11518927193797825)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11517482611797810)
,p_button_name=>'AddComment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11194401589956088)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Collaborate '
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::P6_PAYMENT_RECOMMENDATION_ID,P6_ACTION:&P4_PAYMENT_RECOMMENDATION_ID.,New'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11488178534490350)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(11472926973490322)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11195131831956089)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>':P4_PAYMENT_RECOMMENDATION_ID is not null and :P4_APPROVAL_STATUS in ( ''Draft'' , ''Stopped'')'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11488526030490350)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(11472926973490322)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11195131831956089)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>':P4_APPROVAL_STATUS  in (''Draft'' , ''Stopped'' , ''Returned'') and :P4_PAYMENT_RECOMMENDATION_ID is not null'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11488927792490350)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(11472926973490322)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11195131831956089)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11519666121797832)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(11472926973490322)
,p_button_name=>'Submit'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(11195252240956089)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_doc_count number;',
'l_req       varchar2(1);',
'Begin',
'',
'-- check if doc required',
'-- select TEMP_DOC_REQ_YN',
'-- into l_req',
'-- from hrss_configurations',
'-- where id = 1;',
'',
'l_req := ''Y'';',
'',
'if (l_req = ''N'') then',
'           if      :P4_PAYMENT_RECOMMENDATION_ID is not null ',
'                    and :P4_APPROVAL_STATUS in (''Draft'' , ''Stopped'',''Returned'' , ''Rejected'')',
'                then ',
'                    return true;',
'                else',
'                    return false;',
'         end if;',
'            ',
'else',
'',
'select nvl(count(ID),0) as ID',
'into l_doc_count',
' from CWIP_PAYMENT_RECOMMENDATION_DOCUMENTS',
' where PAYMENT_RECOMMENDATION_ID = :P4_PAYMENT_RECOMMENDATION_ID;',
'',
'if      :P4_PAYMENT_RECOMMENDATION_ID is not null ',
'    and :P4_APPROVAL_STATUS in (''Draft'' , ''Stopped'',''Returned'' , ''Rejected'')',
'    and l_doc_count > 0',
'then ',
'    return true;',
'else',
'    return false;',
' end if;',
' end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-arrow-up-right-alt'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12357651217862816)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(11472926973490322)
,p_button_name=>'STOP_Approval'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(11195252240956089)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Stop Approval'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Declare',
'l_allow_stop    varchar2(1);',
'',
'begin',
'',
'--1) get Allow Stop for External Users from Configuration',
'select allow_ext_stop_app_yn',
'into l_allow_stop',
'from cwip_payments_configuration',
'where id = 1;',
'',
'    if  (:P4_PAYMENT_RECOMMENDATION_ID is not null and :P4_APPROVAL_STATUS = ''In-Progress'' and l_allow_stop = ''Y'')',
'        then',
'                return true;',
'        else',
'                return false;',
'    end if;',
'    ',
'    ',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(29486197014468123)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(11472926973490322)
,p_button_name=>'Copy'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(11195252240956089)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Copy'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P4_APPROVAL_STATUS'
,p_button_condition2=>'Rejected'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-copy'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(20783390373193925)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(11472926973490322)
,p_button_name=>'Print'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(11195252240956089)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Print'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-print'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(31455711222181437)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_api.id(11472926973490322)
,p_button_name=>'Rollbak'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11195131831956089)
,p_button_image_alt=>'Rollbak'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition_type=>'NEVER'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(29486679440468128)
,p_branch_name=>'Go to 3 after Delete'
,p_branch_action=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:P3_CONTRACT_NUMBER:&P4_CONTRACT_NUMBER.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(11488178534490350)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(29486748371468129)
,p_branch_name=>'Go to 3 after Copy'
,p_branch_action=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:P3_CONTRACT_NUMBER:&P4_CONTRACT_NUMBER.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(29486197014468123)
,p_branch_sequence=>20
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(11489288526490350)
,p_branch_name=>'Go To Page 4'
,p_branch_action=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::P4_PAYMENT_RECOMMENDATION_ID:&P4_PAYMENT_RECOMMENDATION_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>30
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(568428747567118)
,p_name=>'P4_EXECLUDE_VAT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_default=>'N'
,p_prompt=>'Exclude VAT?'
,p_source=>'EXECLUDE_VAT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO_LOV'
,p_lov=>'.'||wwv_flow_api.id(11414111784180670)||'.'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11473956703490341)
,p_name=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_source=>'PAYMENT_RECOMMENDATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11474303888490341)
,p_name=>'P4_REFERENCE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Reference Number:'
,p_pre_element_text=>'&P4_REFERENCE_CODE.'
,p_source=>'REFERENCE_NUMBER_PART1'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>6
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11474777069490341)
,p_name=>'P4_SUBMITTED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Submitted on:'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'SUBMITTED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_display_when=>'P4_APPROVAL_STATUS'
,p_display_when2=>'Draft'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11475173413490342)
,p_name=>'P4_CONTRACT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Contract Number :'
,p_source=>'CONTRACT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>12
,p_read_only_when=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_read_only_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11475505136490342)
,p_name=>'P4_PAYMENT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(max(SEQ_COUNT),0) + 1',
'from CWIP_PAYMENT_RECOMMENDATION',
'where CONTRACT_NUMBER = :P4_CONTRACT_NUMBER'))
,p_item_default_type=>'SQL_QUERY_COLON'
,p_prompt=>'Payment Number :'
,p_source=>'PAYMENT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11475909888490342)
,p_name=>'P4_PAYMENT_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Payment Type :'
,p_source=>'PAYMENT_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'PAYMENT TYPES LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from cwip_lookup_values',
'where lookup_id = 2',
'and status = ''A'''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11476331564490343)
,p_name=>'P4_VALUATION_PERIOD_FROM'
,p_source_data_type=>'DATE'
,p_is_required=>true
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Valuation Date:'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'VALUATION_PERIOD_FROM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_help_text=>'%This Is The date'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11476760606490343)
,p_name=>'P4_EVALUATION_METHOD'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Evaluation Method :'
,p_source=>'EVALUATION_METHOD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'EVALUATION METHODS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value , value_id',
'from cwip_lookup_values',
'where lookup_id = 6',
'and status = ''A'''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11477184538490343)
,p_name=>'P4_CURRENT_VALUATION_AMOUNT'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Current Valuation Amount :'
,p_post_element_text=>'&nbsp; &P4_CURRENCY.'
,p_source=>'trim(to_char(nvl(:P4_CURRENT_VALUATION_AMOUNT_H,0),''99,999,999,999.99''))'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_tag_attributes=>'onchange="this.value=Number(this.value).toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, ''$1,'')" style="color: green;font-size: 12pt;font-style: bold;"'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11477554071490343)
,p_name=>'P4_CONTRACT_STAGE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Contract Stage :'
,p_source=>'CONTRACT_STAGE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11477919713490344)
,p_name=>'P4_DEDUCTIONS'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Deductions :'
,p_post_element_text=>'&nbsp; &P4_CURRENCY.'
,p_source=>'trim(to_char(nvl(:P4_DEDUCTIONS_H,0),''99,999,999,999.99''))'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_tag_attributes=>'onchange="this.value=Number(this.value).toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, ''$1,'')" style="color: red;font-size: 12pt;font-style: bold;"'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11478786921490344)
,p_name=>'P4_NET_AMOUNT_PAYABLE'
,p_is_required=>true
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Net Amount Payable :'
,p_post_element_text=>'&nbsp; &P4_CURRENCY.'
,p_source=>'trim(to_char(nvl(:P4_NET_AMOUNT_PAYABLE_H,0),''99,999,999,999.99''))'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>255
,p_tag_attributes=>'style="color: green;font-size: 12pt;font-style: bold;"'
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_protection_level=>'I'
,p_help_text=>'Net Amount Payable without VAT'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11479122863490344)
,p_name=>'P4_ATTACHEMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Attachements :'
,p_source=>'ATTACHEMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11479549211490345)
,p_name=>'P4_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(21271734717381943)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Created By :</span>'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11479905935490345)
,p_name=>'P4_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(21271734717381943)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Created On :</span>'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11480745627490345)
,p_name=>'P4_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(21271734717381943)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Updated By :</span>'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11481192552490346)
,p_name=>'P4_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(21271734717381943)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'<span style="font-weight: bold;font-size:12px;color:#368ed2;">Updated On :</span>'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(11517237171797808)
,p_name=>'P4_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_default=>'Draft'
,p_prompt=>'Approval Status :'
,p_source=>'APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>15
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12458126140889033)
,p_name=>'P4_FROM_PAGE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11472926973490322)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20421911100199249)
,p_name=>'P4_SEQ_COUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(max(SEQ_COUNT),0) + 1',
'from CWIP_PAYMENT_RECOMMENDATION',
'where CONTRACT_NUMBER = :P4_CONTRACT_NUMBER'))
,p_item_default_type=>'SQL_QUERY'
,p_source=>'SEQ_COUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20782011331193912)
,p_name=>'P4_INVOICE_NUM'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(20782358760193915)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Invoice Num :'
,p_source=>'INVOICE_NUM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>128
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20782180739193913)
,p_name=>'P4_INVOICE_DATE'
,p_source_data_type=>'DATE'
,p_is_required=>true
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(20782358760193915)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Invoice Date :'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'INVOICE_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20782242478193914)
,p_name=>'P4_TOTAL_INVOICE_AMOUNT'
,p_is_required=>true
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(20782358760193915)
,p_prompt=>'Invoice Amount (with VAT) :'
,p_post_element_text=>'&nbsp; &P4_CURRENCY.'
,p_source=>'trim(to_char(nvl(:P4_TOTAL_INVOICE_AMOUNT_H,0),''99,999,999,999.99''))'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_tag_attributes=>'style="color: green;font-size: 12pt;font-style: bold;"'
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_help_text=>'Total Amount Including VAT'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(20783228625193924)
,p_name=>'P4_PAYMENT_RECOMMENDATION_ID_H'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_source=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21269087603381916)
,p_name=>'P4_CURRENCY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_default=>'AED'
,p_prompt=>'Currency :'
,p_source=>'CURRENCY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'CURRENCY LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select value  d , value r',
'from dct_lookup_values',
'where lookup_id = 11'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21270209964381928)
,p_name=>'P4_CURRENT_VALUATION_AMOUNT_H'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_source=>'CURRENT_VALUATION_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21270507693381931)
,p_name=>'P4_DEDUCTIONS_H'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_source=>'DEDUCTIONS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21271023002381936)
,p_name=>'P4_TOTAL_INVOICE_AMOUNT_H'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(20782358760193915)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_source=>'TOTAL_INVOICE_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21272480517381950)
,p_name=>'P4_NET_AMOUNT_PAYABLE_H'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_source=>'NET_AMOUNT_PAYABLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29487479417468136)
,p_name=>'P4_REFERENCE_CODE'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29487624259468138)
,p_name=>'P4_REFERENCE_NUMBERX'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_source=>'REFERENCE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29488140925468143)
,p_name=>'P4_SCOPE_OF_WORK'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>350
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Scope Of Work '
,p_source=>'SCOPE_OF_WORK'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>150
,p_cMaxlength=>4000
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
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
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29488218966468144)
,p_name=>'P4_REMARK'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>360
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Remark'
,p_source=>'REMARK'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>150
,p_cMaxlength=>4000
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(29488442125468146)
,p_name=>'P4_VALUATION_PERIOD_TO'
,p_source_data_type=>'DATE'
,p_is_required=>true
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'Valuation Period To :'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'VALUATION_PERIOD_TO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>10
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(31455605697181436)
,p_name=>'P4_IPC_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_source_plug_id=>wwv_flow_api.id(11473592326490340)
,p_prompt=>'IPC Number:'
,p_source=>'IPC_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(31456477729181444)
,p_name=>'P4_AVAILABLE_CONTRACT_BALANCE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(32175296544488838)
,p_name=>'P4_PREVIOUSELY_CERIFIED_APPROVED'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(sum(c.net_amount_payable),0),''99,999,999,999,999.99''))',
'FROM',
'    cwip_payment_recommendation c',
'where c.contract_number = :P4_CONTRACT_NUMBER',
'and c.approval_status = ''Approved'''))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Previously Certified Approved'
,p_post_element_text=>'&nbsp; &P4_CURRENCY.'
,p_source=>'trim(to_char(:P4_PREVIOUSELY_CERIFIED_APPROVED_H , ''99,999,999,999.99''))'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_tag_attributes=>'style="color: green;font-size: 12pt;font-style: bold;"'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(32175476040488840)
,p_name=>'P4_PREVIOUSELY_CERIFIED_PENDING'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(sum(c.net_amount_payable),0),''99,999,999,999.99''))',
'FROM',
'    cwip_payment_recommendation c',
'where c.contract_number = :P4_CONTRACT_NUMBER',
'and c.approval_status = ''In-Progress''',
'and c.seq_count < nvl(:P4_SEQ_COUNT , 99999)'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Previously Certified Pending:'
,p_post_element_text=>'&nbsp; &P4_CURRENCY.'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'trim(to_char(:P4_PREVIOUSELY_CERIFIED_PENDING_H , ''99,999,999,999.99''))'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_tag_attributes=>'style="color: green;font-size: 12pt;font-style: bold;"'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(32175545274488841)
,p_name=>'P4_CUMULATIVE_CERIFIED_AMOUNT'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_use_cache_before_default=>'NO'
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(sum(c.net_amount_payable),0),''99,999,999,999,999.99''))',
'FROM   cwip_payment_recommendation c',
'where c.contract_number = :P4_CONTRACT_NUMBER',
'and c.approval_status in (''Approved'' ,''In-Progress'')'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Cumulative Certified Amount'
,p_post_element_text=>'&nbsp; &P4_CURRENCY.'
,p_source=>'trim(to_char(nvl(:P4_CUMULATIVE_CERIFIED_AMOUNT_H,0),''99,999,999,999,999.99''))'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_tag_attributes=>'style="color: green;font-size: 12pt;font-style: bold;"'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_help_text=>'Cumulative Certified  without VAT'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(32175651101488842)
,p_name=>'P4_CUMULATIVE_CERIFIED_AMOUNT_H'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(sum(c.net_amount_payable),0)',
'FROM',
'    cwip_payment_recommendation c',
'where c.contract_number = :P4_CONTRACT_NUMBER',
'and c.approval_status in (''Approved'' ,''In-Progress'')'))
,p_item_default_type=>'SQL_QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(32569062202581204)
,p_name=>'P4_PREVIOUSELY_CERIFIED_PENDING_H'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(sum(c.net_amount_payable),0)',
'FROM',
'    cwip_payment_recommendation c',
'where c.contract_number = :P4_CONTRACT_NUMBER',
'and c.approval_status = ''In-Progress'''))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(32570214086581216)
,p_name=>'P4_PREVIOUSELY_CERIFIED_APPROVED_H'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(sum(c.net_amount_payable),0)',
'FROM',
'    cwip_payment_recommendation c',
'where c.contract_number = :P4_CONTRACT_NUMBER',
'and c.approval_status = ''Approved'''))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(32802909251539620)
,p_name=>'P4_CONTRACT_AMOUNT'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_source=>'select contract_amount from cwip_contract where contract_number = :P4_CONTRACT_NUMBER'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(32803730045539628)
,p_name=>'P4_PROJECT_NUMBER'
,p_item_sequence=>370
,p_item_plug_id=>wwv_flow_api.id(11473592326490340)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(11480404382490345)
,p_validation_name=>'P4_CREATED_ON must be timestamp'
,p_validation_sequence=>150
,p_validation=>'P4_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(11479905935490345)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(11481691037490346)
,p_validation_name=>'P4_UPDATED_ON must be timestamp'
,p_validation_sequence=>170
,p_validation=>'P4_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(11481192552490346)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(11519099065797826)
,p_name=>'Dialog Close'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(11518927193797825)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11519153084797827)
,p_event_id=>wwv_flow_api.id(11519099065797826)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(11517583689797811)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(11519283501797828)
,p_name=>'Comments Dialog Closed'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(11517583689797811)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11519398347797829)
,p_event_id=>wwv_flow_api.id(11519283501797828)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(11517583689797811)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(11867239491373904)
,p_name=>'Submit'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(11519666121797832)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11867356847373905)
,p_event_id=>wwv_flow_api.id(11867239491373904)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to submit your request for approval, Are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11867474986373906)
,p_event_id=>wwv_flow_api.id(11867239491373904)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
' cwip_rec_payment_workflow.SUBMIT(:P4_PAYMENT_RECOMMENDATION_ID);',
'END;'))
,p_attribute_02=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11867541505373907)
,p_event_id=>wwv_flow_api.id(11867239491373904)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Payment Recommendation REF# &P4_REFERENCE_NUMBER. Successfully Submitted.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(11867626550373908)
,p_event_id=>wwv_flow_api.id(11867239491373904)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12357714851862817)
,p_name=>'Stop Approval DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(12357651217862816)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12357828018862818)
,p_event_id=>wwv_flow_api.id(12357714851862817)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to withdraw Payment Recommendation &P4_REFERENCE_NUMBER., Are you sure? '
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12357901492862819)
,p_event_id=>wwv_flow_api.id(12357714851862817)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
' cwip_rec_payment_workflow.stop(:P4_PAYMENT_RECOMMENDATION_ID);',
'END;'))
,p_attribute_02=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12358010291862820)
,p_event_id=>wwv_flow_api.id(12357714851862817)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'The Payment Recommendation &P4_REFERENCE_NUMBER. has been stopped.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12358128191862821)
,p_event_id=>wwv_flow_api.id(12357714851862817)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(20781587269193907)
,p_name=>'ITEM GETS FOCUS'
,p_event_sequence=>50
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(11473592326490340)
,p_bind_type=>'bind'
,p_bind_event_type=>'focusin'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20781620566193908)
,p_event_id=>wwv_flow_api.id(20781587269193907)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ADD_CLASS'
,p_affected_elements_type=>'EVENT_SOURCE'
,p_attribute_01=>'showfocus'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(20781792761193909)
,p_name=>'ITEM LOSES FOCUS'
,p_event_sequence=>60
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(11473592326490340)
,p_bind_type=>'bind'
,p_bind_event_type=>'focusout'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20781847728193910)
,p_event_id=>wwv_flow_api.id(20781792761193909)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REMOVE_CLASS'
,p_affected_elements_type=>'EVENT_SOURCE'
,p_attribute_01=>'showfocus'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21162051353775250)
,p_name=>'Draft'
,p_event_sequence=>70
,p_condition_element=>'P4_APPROVAL_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Approved'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21267586553381901)
,p_event_id=>wwv_flow_api.id(21162051353775250)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ADD_CLASS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_APPROVAL_STATUS'
,p_attribute_01=>'draft'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21267688887381902)
,p_name=>'reject'
,p_event_sequence=>80
,p_condition_element=>'P4_APPROVAL_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Rejected'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21267702611381903)
,p_event_id=>wwv_flow_api.id(21267688887381902)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_APPROVAL_STATUS'
,p_attribute_01=>'color'
,p_attribute_02=>'red'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21267826573381904)
,p_name=>'Approve'
,p_event_sequence=>90
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_APPROVAL_STATUS'
,p_condition_element=>'P4_APPROVAL_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Approve'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21267947696381905)
,p_event_id=>wwv_flow_api.id(21267826573381904)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_APPROVAL_STATUS'
,p_attribute_01=>'color'
,p_attribute_02=>'green'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21268010771381906)
,p_name=>'Reject'
,p_event_sequence=>100
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_APPROVAL_STATUS'
,p_condition_element=>'P4_APPROVAL_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Rejected'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21268186843381907)
,p_event_id=>wwv_flow_api.id(21268010771381906)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_CSS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_APPROVAL_STATUS'
,p_attribute_01=>'color'
,p_attribute_02=>'red'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(20783464635193926)
,p_name=>'Print'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(20783390373193925)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(20783551225193927)
,p_event_id=>wwv_flow_api.id(20783464635193926)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'javaScript:window.open(''f?p=&APP_ID.:0:&SESSION.:PRINT_REPORT=Recommendation%20Payment'' , ''_blank'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21269182529381917)
,p_name=>'disable deduction after enter amount'
,p_event_sequence=>120
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_CURRENT_VALUATION_AMOUNT_H'
,p_condition_element=>'P4_CURRENT_VALUATION_AMOUNT_H'
,p_triggering_condition_type=>'NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21269412587381920)
,p_event_id=>wwv_flow_api.id(21269182529381917)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_DEDUCTIONS_H,P4_NET_AMOUNT_PAYABLE_H'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21269224770381918)
,p_event_id=>wwv_flow_api.id(21269182529381917)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_DEDUCTIONS_H'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21269374087381919)
,p_event_id=>wwv_flow_api.id(21269182529381917)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_DEDUCTIONS_H'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21270069910381926)
,p_name=>'Calculate Net Amount'
,p_event_sequence=>130
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_CURRENT_VALUATION_AMOUNT_H,P4_DEDUCTIONS_H'
,p_condition_element=>'P4_CURRENT_VALUATION_AMOUNT'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21270144156381927)
,p_event_id=>wwv_flow_api.id(21270069910381926)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_NET_AMOUNT_PAYABLE_H,P4_NET_AMOUNT_PAYABLE'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--nvl(:P4_CURRENT_VALUATION_AMOUNT_H,0) - NVL(:P4_DEDUCTIONS_H, 0)',
'(to_number(replace(nvl(:P4_CURRENT_VALUATION_AMOUNT_H,0),'','','''')) - to_number(replace(nvl(:P4_DEDUCTIONS_H,0),'','','''') ))'))
,p_attribute_07=>'P4_DEDUCTIONS_H,P4_CURRENT_VALUATION_AMOUNT_H,P4_TOTAL_INVOICE_AMOUNT_H'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(568327416567117)
,p_name=>'Calculate Invoice Amount'
,p_event_sequence=>140
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_CURRENT_VALUATION_AMOUNT_H,P4_DEDUCTIONS_H,P4_EXECLUDE_VAT'
,p_condition_element=>'P4_CURRENT_VALUATION_AMOUNT'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(568208873567115)
,p_event_id=>wwv_flow_api.id(568327416567117)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_TOTAL_INVOICE_AMOUNT,P4_TOTAL_INVOICE_AMOUNT_H'
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P4_EXECLUDE_VAT = ''N''',
'then ',
'return (to_number(replace(nvl(:P4_CURRENT_VALUATION_AMOUNT_H,0),'','','''')) - to_number(replace(nvl(:P4_DEDUCTIONS_H,0),'','','''') )) * 1.05 ;',
'else',
'',
'return ',
'(to_number(replace(nvl(:P4_CURRENT_VALUATION_AMOUNT_H,0),'','','''')) - to_number(replace(nvl(:P4_DEDUCTIONS_H,0),'','','''') )) ;',
'',
'end if;'))
,p_attribute_07=>'P4_DEDUCTIONS_H,P4_CURRENT_VALUATION_AMOUNT_H,P4_TOTAL_INVOICE_AMOUNT_H,P4_EXECLUDE_VAT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21270398393381929)
,p_name=>'set Hidden'
,p_event_sequence=>150
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_CURRENT_VALUATION_AMOUNT'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21270485768381930)
,p_event_id=>wwv_flow_api.id(21270398393381929)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_CURRENT_VALUATION_AMOUNT_H'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'to_number(replace(nvl(:P4_CURRENT_VALUATION_AMOUNT,0),'','',''''))'
,p_attribute_07=>'P4_CURRENT_VALUATION_AMOUNT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(32175710368488843)
,p_event_id=>wwv_flow_api.id(21270398393381929)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_CUMULATIVE_CERIFIED_AMOUNT_H'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
' to_number(replace(nvl(:P4_PREVIOUSELY_CERIFIED_APPROVED,0),'','','''') )',
'+ to_number(replace(nvl(:P4_PREVIOUSELY_CERIFIED_PENDING,0),'','','''') )',
'+ :P4_CURRENT_VALUATION_AMOUNT_H',
'- :P4_DEDUCTIONS_H'))
,p_attribute_07=>'P4_PREVIOUSELY_CERIFIED_APPROVED,P4_PREVIOUSELY_CERIFIED_PENDING,P4_CURRENT_VALUATION_AMOUNT_H,P4_DEDUCTIONS_H,P4_NET_AMOUNT_PAYABLE_H'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21270632205381932)
,p_name=>'Set Hidden deduction'
,p_event_sequence=>160
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_DEDUCTIONS'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21270794458381933)
,p_event_id=>wwv_flow_api.id(21270632205381932)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_DEDUCTIONS_H'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'to_number(replace(nvl(:P4_DEDUCTIONS,0),'','',''''))'
,p_attribute_07=>'P4_DEDUCTIONS'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(32175894376488844)
,p_event_id=>wwv_flow_api.id(21270632205381932)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_CUMULATIVE_CERIFIED_AMOUNT_H'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
' to_number(replace(nvl(:P4_PREVIOUSELY_CERIFIED_APPROVED,0),'','','''') )',
'+ to_number(replace(nvl(:P4_PREVIOUSELY_CERIFIED_PENDING,0),'','','''') )',
'+ :P4_CURRENT_VALUATION_AMOUNT_H',
'- :P4_DEDUCTIONS_H'))
,p_attribute_07=>'P4_PREVIOUSELY_CERIFIED_APPROVED,P4_PREVIOUSELY_CERIFIED_PENDING,P4_CURRENT_VALUATION_AMOUNT_H,P4_DEDUCTIONS_H,P4_NET_AMOUNT_PAYABLE_H'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21272281142381948)
,p_name=>'set Hidden ID'
,p_event_sequence=>170
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21272394076381949)
,p_event_id=>wwv_flow_api.id(21272281142381948)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_PAYMENT_RECOMMENDATION_ID_H'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>':P4_PAYMENT_RECOMMENDATION_ID'
,p_attribute_07=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21863451018304236)
,p_name=>'set Net Amount Payable'
,p_event_sequence=>180
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_NET_AMOUNT_PAYABLE_H'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21863533477304237)
,p_event_id=>wwv_flow_api.id(21863451018304236)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_NET_AMOUNT_PAYABLE'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'trim(to_char(nvl(:P4_NET_AMOUNT_PAYABLE_H,0),''99,999,999,999.99''))'
,p_attribute_07=>'P4_NET_AMOUNT_PAYABLE_H'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(21863684677304238)
,p_name=>'Set Total Invoice Amount'
,p_event_sequence=>190
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_TOTAL_INVOICE_AMOUNT_H'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(21863799989304239)
,p_event_id=>wwv_flow_api.id(21863684677304238)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_TOTAL_INVOICE_AMOUNT'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'trim(to_char(nvl(:P4_TOTAL_INVOICE_AMOUNT_H,0),''99,999,999,999.99''))'
,p_attribute_07=>'P4_TOTAL_INVOICE_AMOUNT_H'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(29486235266468124)
,p_name=>'Copy DA'
,p_event_sequence=>200
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(29486197014468123)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(29486369819468125)
,p_event_id=>wwv_flow_api.id(29486235266468124)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to generate new version from the payment application?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(29486465117468126)
,p_event_id=>wwv_flow_api.id(29486235266468124)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'l_verson number;',
'l_id number;',
'begin',
'--SELECT last_number ',
'--into l_id',
'--  FROM all_sequences',
'-- WHERE sequence_owner = ''PROD''',
' --  AND sequence_name = ''CWIP_PAYMENT_RECOMMENDATION_SEQ'';',
'l_id := CWIP_PAYMENT_RECOMMENDATION_SEQ.nextval   ;',
'',
'select max(nvl(x.verson,0))+1',
'into l_verson',
'from cwip_payment_recommendation x',
'where x.contract_number = :P4_CONTRACT_NUMBER',
'and x.seq_count = :P4_SEQ_COUNT;',
'',
'INSERT INTO cwip_payment_recommendation (',
'    PAYMENT_RECOMMENDATION_ID,',
'    reference_number,',
'    payment_recommendation_date,',
'    contract_number,',
'    payment_number,',
'    payment_type,',
'    valuation_period,',
'    valuation_period_from,',
'    valuation_period_to,',
'    evaluation_method,',
'    current_valuation_amount,',
'    period,',
'    deductions,',
'    previous_payments,',
'    net_amount_payable,',
'    attachements,',
'    approval_status,',
'    seq_count,',
'    final_approve_on,',
'    invoice_num,',
'    invoice_date,',
'    total_invoice_amount,',
'    currency,',
'    contract_stage,',
'    verson',
') SELECT',
'    l_id,',
'    reference_number,',
'    sysdate,',
'    contract_number,',
'    to_char(:P4_PAYMENT_NUMBER) || ''- Rev'' || to_char(l_verson),',
'    payment_type,',
'    valuation_period,',
'    valuation_period_from,',
'    valuation_period_to,',
'    evaluation_method,',
'    current_valuation_amount,',
'    period,',
'    deductions,',
'    previous_payments,',
'    net_amount_payable,',
'    attachements,',
'    ''Draft'',',
'    seq_count,',
'    null,',
'    invoice_num,',
'    invoice_date,',
'    total_invoice_amount,',
'    currency,',
'    contract_stage,',
'    l_verson',
'FROM',
'    cwip_payment_recommendation',
'where PAYMENT_RECOMMENDATION_ID = :P4_PAYMENT_RECOMMENDATION_ID;',
'',
'INSERT INTO cwip_payment_recommendation_documents (',
'    row_version_number,',
'    payment_recommendation_id,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    file_comments,',
'    tags,',
'    comment_id,',
'    project_number,',
'    contract_number',
') SELECT',
'    row_version_number,',
'    l_id,',
'    filename,',
'    file_mimetype,',
'    file_charset,',
'    file_blob,',
'    file_comments,',
'    tags,',
'    comment_id,',
'    project_number,',
'    contract_number',
'FROM',
'    cwip_payment_recommendation_documents',
'where PAYMENT_RECOMMENDATION_ID = :P4_PAYMENT_RECOMMENDATION_ID;',
'',
'commit;',
'end;'))
,p_attribute_02=>'P4_PAYMENT_RECOMMENDATION_ID,P4_CONTRACT_NUMBER,P4_SEQ_COUNT,P4_PAYMENT_NUMBER'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(29486566301468127)
,p_event_id=>wwv_flow_api.id(29486235266468124)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'New Version Created Sucessfully'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(32803279926539623)
,p_event_id=>wwv_flow_api.id(29486235266468124)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(29487828038468140)
,p_name=>'Set Reference Code'
,p_event_sequence=>210
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_REFERENCE_NUMBER'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(29487987389468141)
,p_event_id=>wwv_flow_api.id(29487828038468140)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_REFERENCE_NUMBERX'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>':P4_REFERENCE_CODE || :P4_REFERENCE_NUMBER'
,p_attribute_07=>'P4_REFERENCE_CODE,P4_REFERENCE_NUMBER'
,p_attribute_08=>'Y'
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
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(29488552966468147)
,p_name=>'Milestone DA'
,p_event_sequence=>220
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_EVALUATION_METHOD,P4_VALUATION_PERIOD_FROM'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'$v("P4_EVALUATION_METHOD") == 32'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(29488679554468148)
,p_event_id=>wwv_flow_api.id(29488552966468147)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_VALUATION_PERIOD_TO'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>':P4_VALUATION_PERIOD_FROM'
,p_attribute_07=>'P4_VALUATION_PERIOD_FROM'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(29917565576177104)
,p_event_id=>wwv_flow_api.id(29488552966468147)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_VALUATION_PERIOD_TO'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(29917432256177103)
,p_event_id=>wwv_flow_api.id(29488552966468147)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_VALUATION_PERIOD_TO'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(29917647327177105)
,p_name=>'Enable Evaluation Period To Before Submit DA'
,p_event_sequence=>230
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'$v("P4_EVALUATION_METHOD") == 32'
,p_bind_type=>'bind'
,p_bind_event_type=>'apexbeforepagesubmit'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(29917774259177106)
,p_event_id=>wwv_flow_api.id(29917647327177105)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_VALUATION_PERIOD_TO'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(29918995795177118)
,p_name=>'Validate Start and End Date'
,p_event_sequence=>240
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_VALUATION_PERIOD_TO'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'checkdates($v("P4_VALUATION_PERIOD_FROM") , $v("P4_VALUATION_PERIOD_TO"))'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(29919012448177119)
,p_event_id=>wwv_flow_api.id(29918995795177118)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Valuation Period to should be after valuation Period From date'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(29919186466177120)
,p_event_id=>wwv_flow_api.id(29918995795177118)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_VALUATION_PERIOD_TO'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(31455888489181438)
,p_name=>'rollbak'
,p_event_sequence=>250
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(31455711222181437)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(31455999324181439)
,p_event_id=>wwv_flow_api.id(31455888489181438)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Rollback ?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(31456035901181440)
,p_event_id=>wwv_flow_api.id(31455888489181438)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete from cwip_payment_rec_approval_history where payment_recommendation_id = :P4_PAYMENT_RECOMMENDATION_ID;',
'UPDATE cwip_payment_recommendation set approval_status = ''Draft'' where payment_recommendation_id = :P4_PAYMENT_RECOMMENDATION_ID;'))
,p_attribute_02=>'P4_PAYMENT_RECOMMENDATION_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(31456141354181441)
,p_event_id=>wwv_flow_api.id(31455888489181438)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Rollback Done'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(31456297614181442)
,p_event_id=>wwv_flow_api.id(31455888489181438)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(31456598235181445)
,p_name=>'Valuation Amount not > contract vailable Balance'
,p_event_sequence=>260
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_CURRENT_VALUATION_AMOUNT_H'
,p_condition_element=>'P4_CURRENT_VALUATION_AMOUNT_H'
,p_triggering_condition_type=>'GREATER_THAN'
,p_triggering_expression=>'&P4_AVAILABLE_CONTRACT_BALANCE.'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(31456631261181446)
,p_event_id=>wwv_flow_api.id(31456598235181445)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'you exceed the remaining balance &P4_AVAILABLE_CONTRACT_BALANCE., Please check the amount carefully.',
''))
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(32176333756488849)
,p_event_id=>wwv_flow_api.id(31456598235181445)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_CURRENT_VALUATION_AMOUNT,P4_CURRENT_VALUATION_AMOUNT_H'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(32176423682488850)
,p_event_id=>wwv_flow_api.id(31456598235181445)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_CURRENT_VALUATION_AMOUNT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(32176196005488847)
,p_name=>'set format'
,p_event_sequence=>270
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_CUMULATIVE_CERIFIED_AMOUNT_H'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(32176223237488848)
,p_event_id=>wwv_flow_api.id(32176196005488847)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_CUMULATIVE_CERIFIED_AMOUNT'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>'trim(to_char(:P4_CUMULATIVE_CERIFIED_AMOUNT_H, ''99,999,999,999.99''))'
,p_attribute_07=>'P4_CUMULATIVE_CERIFIED_AMOUNT_H'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(32802605670539617)
,p_name=>'Cumulative Certified Amount Exceed the contract amount'
,p_event_sequence=>280
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_CUMULATIVE_CERIFIED_AMOUNT_H'
,p_condition_element=>'P4_CUMULATIVE_CERIFIED_AMOUNT_H'
,p_triggering_condition_type=>'GREATER_THAN'
,p_triggering_expression=>'&P4_CONTRACT_AMOUNT.'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
,p_display_when_type=>'NEVER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(32802722498539618)
,p_event_id=>wwv_flow_api.id(32802605670539617)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Cumulative Certified Amount Exceed the contract amount'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(32803004377539621)
,p_event_id=>wwv_flow_api.id(32802605670539617)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_CURRENT_VALUATION_AMOUNT_H,P4_CURRENT_VALUATION_AMOUNT,P4_DEDUCTIONS,P4_CUMULATIVE_CERIFIED_AMOUNT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(32803136973539622)
,p_event_id=>wwv_flow_api.id(32802605670539617)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_CURRENT_VALUATION_AMOUNT'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(29487533378468137)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(11473592326490340)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Set Reference Number'
,p_attribute_01=>'PLSQL_CODE'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_count   number;',
'begin',
'    case :APEX$ROW_STATUS',
'    when ''C'' then',
'    --    insert into cwip_payment_recommendation ( REFERENCE_NUMBER)',
'    --    values ( :P4_REFERENCE_CODE || :P4_REFERENCE_NUMBER );',
'       if :P4_VALUATION_PERIOD_FROM > :valuation_period_to Then',
'          apex_error.add_error (',
'                              p_message          => ''Please check the selected Valuation Period'',',
'                               p_display_location =>  apex_error.c_inline_with_field_and_notif);',
'      End if;',
'        ',
'    when ''U'' then',
'          if :P4_VALUATION_PERIOD_FROM > :valuation_period_to Then',
'          apex_error.add_error (',
'                              p_message          => ''Please check the selected Valuation Period'',',
'                               p_display_location =>  apex_error.c_inline_with_field_and_notif);',
'      End if;',
'    when ''D'' then',
'     null;',
'    end case;',
'end;'))
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Payment recommendation updated successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(11490132930490351)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(11473592326490340)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Payment Recommendation Form'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_process_error_message=>'Error while update Payment recommendation, Please Contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Payment recommendation updated successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(11489727610490351)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(11473592326490340)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Payment Recommendation Form'
);
wwv_flow_api.component_end;
end;
/
