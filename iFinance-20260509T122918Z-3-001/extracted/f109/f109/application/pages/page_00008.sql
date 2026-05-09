prompt --application/pages/page_00008
begin
--   Manifest
--     PAGE: 00008
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
 p_id=>8
,p_user_interface_id=>wwv_flow_api.id(11217697745956116)
,p_name=>'Payment Recommendation Approve / Reject'
,p_alias=>'PAYMENT-RECOMMENDATION-APPROVE-REJECT'
,p_step_title=>'Payment Recommendation Approve / Reject'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210207210353'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(35628690854609343)
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
 p_id=>wwv_flow_api.id(35629356207609361)
,p_plug_name=>'Payment Recommendation Details'
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
,p_plug_read_only_when=>':P8_APPROVAL_STATUS not in (''Draft'' , ''Stoped'')'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(35215422457309057)
,p_plug_name=>'Attachements'
,p_parent_plug_id=>wwv_flow_api.id(35629356207609361)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(11133056164956048)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(35215516960309058)
,p_plug_name=>'Payment Recommendation Report'
,p_parent_plug_id=>wwv_flow_api.id(35215422457309057)
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
' where payment_recommendation_id = :P8_PAYMENT_RECOMMENDATION_ID',
' order by created desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P8_PAYMENT_RECOMMENDATION_ID'
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
 p_id=>wwv_flow_api.id(35215614212309059)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_ID,P5_APPROVAL_STATUS,P5_CONTRACT_NUMBER:#ID#,&P4_APPROVAL_STATUS.,&P4_CONTRACT_NUMBER.'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>35215614212309059
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12118495730595382)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12118881937595382)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12119260603595382)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12119613642595383)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Filename'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12120038038595383)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12120487640595384)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12120895769595384)
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
 p_id=>wwv_flow_api.id(12121200547595384)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'File Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12121633453595385)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12122064565595385)
,p_db_column_name=>'CREATED'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12122464916595385)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12122823277595385)
,p_db_column_name=>'UPDATED'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12123216878595386)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12123674251595386)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12124076853595386)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:CWIP_PAYMENT_RECOMMENDATION_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(35682357540921584)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'121244'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:TAGS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(35673246492916831)
,p_plug_name=>'Collaboration'
,p_icon_css_classes=>'fa-comments-o fa-anim-flash fam-sleep fam-is-success'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--scrollBody:margin-left-none'
,p_plug_template=>wwv_flow_api.id(11133056164956048)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(35673347570916832)
,p_name=>'Comments'
,p_parent_plug_id=>wwv_flow_api.id(35673246492916831)
,p_template=>wwv_flow_api.id(11105666197956032)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    CASE when user_type = ''Internal'' Then',
'        CASE',
'            WHEN dbms_lob.getlength(photo_blob) > 0 THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(user_name)',
'            ELSE',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'        END ',
'    when user_type = ''External'' Then',
'         CASE when dbms_lob.getlength(photo_blob) > 0 THEN',
'                ''https://ifinance.dct.gov.ae:8004/dct/prod/ExtUser/view/'' || upper(user_name)',
'            ELSE',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/ExtUser/view/'' || ''U0000''',
'        End ',
'     End   user_icon,',
'  updated_date  comment_date,',
'  case when user_type = ''Internal'' Then',
'        (select e.full_name_en',
'            from dct_employees_list2 e',
'            where e.user_name = created_by)',
'        when user_type = ''External'' Then    ',
'            (select u.first_name || '' '' || u.last_name',
'                from dct_ext_users u',
'                where u.user_name = created_by)',
'        End user_name,',
'  comment_text                    comment_text,',
'  null comment_modifiers,',
'  ''u-color-''||ora_hash(created_by,45) icon_modifier,',
'  action     actions,',
'  ''''     attribute_1,',
'  ''''     attribute_2,',
'  ''''    attribute_3,',
'  ''''    attribute_4,',
'  comment_id',
'from',
'  (SELECT',
'    c.comment_id,',
'    c.payment_recommendation_id,',
'    c.comment_text,',
'    c.created_by,',
'    c.updated_by,',
'    c.creation_date,',
'    c.updated_date,',
'    c.action,',
'    e.user_name,',
'    e.photo_blob,',
'    ''Internal''  user_type',
'FROM',
'    cwip_payment_recommendation_comments c , dct_employees_list2 e',
'where c.updated_by = e.user_name',
'UNION all',
'SELECT',
'    c.comment_id,',
'    c.payment_recommendation_id,',
'    c.comment_text,',
'    c.created_by,',
'    c.updated_by,',
'    c.creation_date,',
'    c.updated_date,',
'    c.action,',
'    e.user_name,',
'    e.photo_blob,',
'    ''External''  user_type',
'FROM',
'    cwip_payment_recommendation_comments c , dct_ext_users e',
'where c.updated_by = e.user_name )',
'where payment_recommendation_id = :P8_PAYMENT_RECOMMENDATION_ID',
'order by CREATION_DATE desc;',
''))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P8_PAYMENT_RECOMMENDATION_ID'
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
 p_id=>wwv_flow_api.id(12125897762595389)
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
 p_id=>wwv_flow_api.id(12126207100595389)
,p_query_column_id=>2
,p_column_alias=>'COMMENT_DATE'
,p_column_display_sequence=>2
,p_column_heading=>'Comment Date'
,p_use_as_row_header=>'N'
,p_column_format=>'SINCE'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12126646665595390)
,p_query_column_id=>3
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12127004336595390)
,p_query_column_id=>4
,p_column_alias=>'COMMENT_TEXT'
,p_column_display_sequence=>4
,p_column_heading=>'Message'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::P6_COMMENT_ID,P6_ACTION:#COMMENT_ID#,Edited'
,p_column_linktext=>'#COMMENT_TEXT#'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12127462636595391)
,p_query_column_id=>5
,p_column_alias=>'COMMENT_MODIFIERS'
,p_column_display_sequence=>5
,p_column_heading=>'Comment Modifiers'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12127828604595391)
,p_query_column_id=>6
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>6
,p_column_heading=>'Icon Modifier'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12128230605595391)
,p_query_column_id=>7
,p_column_alias=>'ACTIONS'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12128615967595392)
,p_query_column_id=>8
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>8
,p_column_heading=>'Attribute 1'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12129071818595392)
,p_query_column_id=>9
,p_column_alias=>'ATTRIBUTE_2'
,p_column_display_sequence=>9
,p_column_heading=>'Attribute 2'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12129451239595393)
,p_query_column_id=>10
,p_column_alias=>'ATTRIBUTE_3'
,p_column_display_sequence=>10
,p_column_heading=>'Attribute 3'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12129894693595393)
,p_query_column_id=>11
,p_column_alias=>'ATTRIBUTE_4'
,p_column_display_sequence=>11
,p_column_heading=>'Attribute 4'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12130258734595393)
,p_query_column_id=>12
,p_column_alias=>'COMMENT_ID'
,p_column_display_sequence=>12
,p_column_heading=>'Comment Id'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(36023464662492930)
,p_plug_name=>'Approval History'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
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
'    role_name,',
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
'  from CWIP_PAYMENT_REC_APPROVAL_HISTORY h',
'  where PAYMENT_RECOMMENDATION_ID = :P8_PAYMENT_RECOMMENDATION_ID)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P8_PAYMENT_RECOMMENDATION_ID'
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
 p_id=>wwv_flow_api.id(36023637242492931)
,p_max_row_count=>'1000000'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>36023637242492931
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12130928602595395)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12131367196595395)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12131711619595396)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12132154389595396)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12132519459595397)
,p_db_column_name=>'PERSON_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Person Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12132978961595397)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Role Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12133312465595398)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12133710510595398)
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
 p_id=>wwv_flow_api.id(12134160447595399)
,p_db_column_name=>'STATUS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12134556870595399)
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
 p_id=>wwv_flow_api.id(12134964980595400)
,p_db_column_name=>'COMMENTS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12135332499595400)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12135725444595401)
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
 p_id=>wwv_flow_api.id(12136199545595401)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12136562516595401)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12136976454595402)
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
 p_id=>wwv_flow_api.id(12137342037595402)
,p_db_column_name=>'FULL_NAME'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12137776123595403)
,p_db_column_name=>'ROLE_NAME'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Role'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12138181101595413)
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
 p_id=>wwv_flow_api.id(12138565957595414)
,p_db_column_name=>'PHOTO'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(36049346103190295)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'121389'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:FULL_NAME:ROLE_NAME:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:PHOTO:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(20892046627631185)
,p_report_id=>wwv_flow_api.id(36049346103190295)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12117795963595380)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(35215422457309057)
,p_button_name=>'Add_Attachement'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11194401589956088)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Attachement'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_PAYMENT_RECOMMENDATION_ID,P5_ALLOW_INSERT,P5_CONTRACT_NUMBER:&P8_PAYMENT_RECOMMENDATION_ID.,Y,&P8_CONTRACT_NUMBER.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12125125178595388)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(35673246492916831)
,p_button_name=>'AddComment'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11194401589956088)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Collaborate '
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::P6_PAYMENT_RECOMMENDATION_ID,P6_ACTION:&P8_PAYMENT_RECOMMENDATION_ID.,New'
,p_icon_css_classes=>'fa-envelope-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12356120797862801)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(35628690854609343)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(11195131831956089)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12356378635862803)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(35628690854609343)
,p_button_name=>'Approve'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(11195252240956089)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select * ',
'from cwip_payment_rec_approval_history',
'where person_id = :PERSON_ID',
'and status = ''Pending''',
'and PAYMENT_RECOMMENDATION_ID = :P8_PAYMENT_RECOMMENDATION_ID'))
,p_button_condition_type=>'EXISTS'
,p_icon_css_classes=>'fa-check-square'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12356422872862804)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(35628690854609343)
,p_button_name=>'Reject'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(11195252240956089)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select * ',
'from cwip_payment_rec_approval_history',
'where person_id = :PERSON_ID',
'and status = ''Pending''',
'and PAYMENT_RECOMMENDATION_ID = :P8_PAYMENT_RECOMMENDATION_ID'))
,p_button_condition_type=>'EXISTS'
,p_icon_css_classes=>'fa-times-square'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12356579044862805)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(35628690854609343)
,p_button_name=>'Delegate'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(11195252240956089)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select * ',
'from cwip_payment_rec_approval_history',
'where person_id = :PERSON_ID',
'and status = ''Pending''',
'and PAYMENT_RECOMMENDATION_ID = :P8_PAYMENT_RECOMMENDATION_ID'))
,p_button_condition_type=>'EXISTS'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(12150705894595423)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
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
 p_id=>wwv_flow_api.id(12109069161595375)
,p_name=>'P8_PAYMENT_RECOMMENDATION_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_source=>'PAYMENT_RECOMMENDATION_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12109443937595375)
,p_name=>'P8_CONTRACT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Contract Number'
,p_source=>'CONTRACT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>12
,p_read_only_when=>'P8_PAYMENT_RECOMMENDATION_ID'
,p_read_only_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12109864366595375)
,p_name=>'P8_REFERENCE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Reference Number'
,p_source=>'REFERENCE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12110230098595375)
,p_name=>'P8_PAYMENT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Payment Number'
,p_source=>'PAYMENT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12110625869595376)
,p_name=>'P8_PAYMENT_RECOMMENDATION_DATE'
,p_source_data_type=>'DATE'
,p_is_required=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_default=>'select sysdate from dual'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Date Prepared'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'PAYMENT_RECOMMENDATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(11194148454956088)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12111081367595376)
,p_name=>'P8_PAYMENT_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Payment Type'
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
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12111449301595376)
,p_name=>'P8_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_default=>'Draft'
,p_prompt=>'Approval Status'
,p_source=>'APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12111850961595376)
,p_name=>'P8_VALUATION_PERIOD'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Valuation Period'
,p_source=>'VALUATION_PERIOD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>50
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12112238278595377)
,p_name=>'P8_EVALUATION_METHOD'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Evaluation Method'
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
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12112664500595377)
,p_name=>'P8_CURRENT_VALUATION_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Current Valuation Amount'
,p_source=>'CURRENT_VALUATION_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12113060615595377)
,p_name=>'P8_PERIOD'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Period'
,p_source=>'PERIOD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>20
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12113434014595378)
,p_name=>'P8_DEDUCTIONS'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Deductions'
,p_source=>'DEDUCTIONS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12113872917595378)
,p_name=>'P8_PREVIOUS_PAYMENTS'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Previous Payments'
,p_source=>'PREVIOUS_PAYMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12114273208595378)
,p_name=>'P8_NET_AMOUNT_PAYABLE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Net Amount Payable'
,p_source=>'NET_AMOUNT_PAYABLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12114669620595378)
,p_name=>'P8_ATTACHEMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Attachements'
,p_source=>'ATTACHEMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
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
 p_id=>wwv_flow_api.id(12115012383595379)
,p_name=>'P8_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P8_PAYMENT_RECOMMENDATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12115420411595379)
,p_name=>'P8_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P8_PAYMENT_RECOMMENDATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12115895227595379)
,p_name=>'P8_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P8_PAYMENT_RECOMMENDATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12116240634595379)
,p_name=>'P8_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(35629356207609361)
,p_item_source_plug_id=>wwv_flow_api.id(35629356207609361)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P8_PAYMENT_RECOMMENDATION_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(11193800624956087)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(12145782107595420)
,p_validation_name=>'P8_CREATED_ON must be timestamp'
,p_validation_sequence=>150
,p_validation=>'P8_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(12115420411595379)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(12146118341595420)
,p_validation_name=>'P8_UPDATED_ON must be timestamp'
,p_validation_sequence=>170
,p_validation=>'P8_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(12116240634595379)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12146406990595420)
,p_name=>'Dialog Close'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(12125125178595388)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12146949559595421)
,p_event_id=>wwv_flow_api.id(12146406990595420)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(35673347570916832)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12147369172595421)
,p_name=>'Comments Dialog Closed'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(35673347570916832)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12147843761595421)
,p_event_id=>wwv_flow_api.id(12147369172595421)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(35673347570916832)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12356674156862806)
,p_name=>'Approve DA'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(12356378635862803)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12356749332862807)
,p_event_id=>wwv_flow_api.id(12356674156862806)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to approve, Are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12356851372862808)
,p_event_id=>wwv_flow_api.id(12356674156862806)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'cwip_rec_payment_workflow.approve(:P8_PAYMENT_RECOMMENDATION_ID,:PERSON_ID);',
'End;'))
,p_attribute_02=>'P8_PAYMENT_RECOMMENDATION_ID,PERSON_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12356994390862809)
,p_event_id=>wwv_flow_api.id(12356674156862806)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Approved Successfully.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12357005511862810)
,p_event_id=>wwv_flow_api.id(12356674156862806)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12357183072862811)
,p_name=>'Reject DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(12356422872862804)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12357228371862812)
,p_event_id=>wwv_flow_api.id(12357183072862811)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'you are going to reject, Are you sure?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12357318991862813)
,p_event_id=>wwv_flow_api.id(12357183072862811)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'cwip_rec_payment_workflow.REJECTED(:P8_PAYMENT_RECOMMENDATION_ID,:PERSON_ID);',
'End;'))
,p_attribute_02=>'P8_PAYMENT_RECOMMENDATION_ID,PERSON_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12357432556862814)
,p_event_id=>wwv_flow_api.id(12357183072862811)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'The Payment Recommendation &P8_REFERENCE_NUMBER. has been rejected.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12357500955862815)
,p_event_id=>wwv_flow_api.id(12357183072862811)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(12117074314595380)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(35629356207609361)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Payment Recommendation Form'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(12116621489595380)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(35629356207609361)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Payment Recommendation Form'
);
wwv_flow_api.component_end;
end;
/
