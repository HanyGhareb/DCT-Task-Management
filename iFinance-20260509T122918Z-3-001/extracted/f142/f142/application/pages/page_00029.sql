prompt --application/pages/page_00029
begin
--   Manifest
--     PAGE: 00029
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
 p_id=>29
,p_user_interface_id=>wwv_flow_api.id(159947477385220145)
,p_name=>'VR Approve/Reject'
,p_alias=>'VR-APPROVE-REJECT'
,p_step_title=>'VR Approve/Reject'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'ALWAYS'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20231221083535'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(370695478391638981)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(159872296964220075)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_menu_id=>wwv_flow_api.id(159808885281220038)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(159926330718220124)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(371507384859423730)
,p_plug_name=>'VR Details'
,p_region_template_options=>'#DEFAULT#:t-Form--large'
,p_plug_template=>wwv_flow_api.id(159835490868220059)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'VR_REQUESTS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(370698017010639006)
,p_plug_name=>'Variation Request Details'
,p_parent_plug_id=>wwv_flow_api.id(371507384859423730)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(370698073894639007)
,p_plug_name=>'Purpose of Change'
,p_parent_plug_id=>wwv_flow_api.id(371507384859423730)
,p_icon_css_classes=>'fa-list-alt'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(370698205890639008)
,p_plug_name=>'Reason for Change'
,p_parent_plug_id=>wwv_flow_api.id(371507384859423730)
,p_icon_css_classes=>'fa-exchange'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(370698311652639009)
,p_plug_name=>'Cost and Time Impact'
,p_parent_plug_id=>wwv_flow_api.id(371507384859423730)
,p_icon_css_classes=>'fa-table-clock'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(370698421690639010)
,p_plug_name=>'Quality Assessment:'
,p_parent_plug_id=>wwv_flow_api.id(371507384859423730)
,p_icon_css_classes=>'fa-glasses'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>70
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'NEVER'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(370699070350639017)
,p_plug_name=>'Audit'
,p_parent_plug_id=>wwv_flow_api.id(371507384859423730)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159845881505220064)
,p_plug_display_sequence=>90
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P29_HISTORY_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(404228076927981011)
,p_plug_name=>'Documents'
,p_parent_plug_id=>wwv_flow_api.id(371507384859423730)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>80
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P29_HISTORY_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(404228191723981012)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(404228076927981011)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(159860948285220071)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       VR_REQUESTS_ID,',
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
'  from vr_requests_documents',
'  where VR_REQUESTS_ID = :P29_REQUEST_ID',
'  order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_HISTORY_ID'
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
 p_id=>wwv_flow_api.id(404228317170981013)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>404228317170981013
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211542233637203391)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211542606090203392)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Document Version'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211543052090203392)
,p_db_column_name=>'VR_REQUESTS_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Vr Requests Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211543400462203397)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211543895398203397)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211544216114203397)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211544673269203398)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211545058841203398)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211545416605203398)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211545854794203398)
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
 p_id=>wwv_flow_api.id(211546250966203399)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160254861235270033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211546637806203399)
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
 p_id=>wwv_flow_api.id(211547081235203399)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(160254861235270033)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211547441880203399)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211547865884203399)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:VR_REQUESTS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(405538952006547694)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2115482'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:ROW_VERSION_NUMBER:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(405495443631446585)
,p_plug_name=>'Approval History'
,p_parent_plug_id=>wwv_flow_api.id(371507384859423730)
,p_icon_css_classes=>'fa-users'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>100
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P29_APPROVAL_STATUS'
,p_plug_display_when_cond2=>'Draft'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(371975202029774768)
,p_plug_name=>'Approval History'
,p_parent_plug_id=>wwv_flow_api.id(405495443631446585)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody'
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
'    full_name || '' ('' || User_name || '')'' full_name,',
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
'  from vr_requests_approval_history h',
'  where request_ID = :P29_REQUEST_ID)',
'  order by step_no , id '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_HISTORY_ID'
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
 p_id=>wwv_flow_api.id(371975269351774769)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>371975269351774769
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211549259631203402)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211549698616203403)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211550051933203403)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211550449156203408)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211550835440203409)
,p_db_column_name=>'FULL_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Full Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211551222477203410)
,p_db_column_name=>'PERSON_TYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Person Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211551643668203410)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Role Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211552099023203411)
,p_db_column_name=>'ROLE_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Role Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211552405476203411)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211552819489203412)
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
 p_id=>wwv_flow_api.id(211553222766203413)
,p_db_column_name=>'STATUS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211553629879203413)
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
 p_id=>wwv_flow_api.id(211554098215203414)
,p_db_column_name=>'COMMENTS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211554490881203415)
,p_db_column_name=>'APPROVAL_TYPE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Approval Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211554831174203415)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211555239050203419)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211555660775203420)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211556059883203421)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211556462270203421)
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
 p_id=>wwv_flow_api.id(211556810264203422)
,p_db_column_name=>'REMINDER_COUNT'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Reminder Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211557250528203422)
,p_db_column_name=>'REMINDER_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Reminder By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(211557689536203423)
,p_db_column_name=>'PHOTO'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(371990784804785085)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'2115580'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME:ROLE_NAME:ACTION_REQUIRED:RECEVIED_DATE:STATUS:ACTION_DATE:COMMENTS:REMINDER_COUNT:'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(211558460784203424)
,p_report_id=>wwv_flow_api.id(371990784804785085)
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
 p_id=>wwv_flow_api.id(405498467781446615)
,p_plug_name=>'Scope'
,p_parent_plug_id=>wwv_flow_api.id(371507384859423730)
,p_icon_css_classes=>'fa-pie-chart-85'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(405809833054359169)
,p_plug_name=>'Additional Comments'
,p_parent_plug_id=>wwv_flow_api.id(371507384859423730)
,p_icon_css_classes=>'fa-comments-o'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--showIcon:t-Region--accent14:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(159862875324220071)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211541545760203390)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(404228076927981011)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(159924243842220122)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:10:P10_VR_REQUESTS_ID,P10_PAGE_FROM,P10_STATUS,P10_PROJECT_NUMBER,P10_CONTRACT_NUMBER:&P29_REQUEST_ID.,29,&P29_APPROVAL_STATUS.,&P29_PROJECT_NUMBER.,&P29_CONTRACT_NUMBER.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211560558532203427)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(370695478391638981)
,p_button_name=>'Back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211493355235005105)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(370695478391638981)
,p_button_name=>'Approve'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:30:P30_REQUEST_TYPE,P30_REQUEST_ID,P30_REQUEST_NO,P30_ACTION,P30_HISTORY_ID:VR,&P29_REQUEST_ID.,&P29_REQUEST_NO.,Approve,&P29_HISTORY_ID.'
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211495024668005122)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(370695478391638981)
,p_button_name=>'Reject'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:30:P30_REQUEST_TYPE,P30_REQUEST_ID,P30_REQUEST_NO,P30_ACTION,P30_HISTORY_ID:VR,&P29_REQUEST_ID.,&P29_REQUEST_NO.,Reject,&P29_HISTORY_ID.'
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211495149720005123)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(370695478391638981)
,p_button_name=>'Delegate'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:30:P30_REQUEST_TYPE,P30_REQUEST_ID,P30_REQUEST_NO,P30_ACTION,P30_HISTORY_ID:VR,&P29_REQUEST_ID.,&P29_REQUEST_NO.,Delegate,&P29_HISTORY_ID.'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(211495299183005124)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(370695478391638981)
,p_button_name=>'Return'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(159925091859220123)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:30:P30_REQUEST_TYPE,P30_REQUEST_ID,P30_REQUEST_NO,P30_ACTION,P30_HISTORY_ID:VR,&P29_REQUEST_ID.,&P29_REQUEST_NO.,Return,&P29_HISTORY_ID.'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(211586229403203445)
,p_branch_name=>'Go to 11 - Subit'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_REQUEST_ID,P11_REQUEST_NO:&P29_REQUEST_ID.,&P29_REQUEST_NO.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211494867128005120)
,p_name=>'P29_HISTORY_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(370695478391638981)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211522608064203371)
,p_name=>'P29_VO_REQUEST_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_source=>'VO_REQUEST_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211523036172203371)
,p_name=>'P29_BM_REQUEST_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_source=>'BM_REQUEST_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211523420260203371)
,p_name=>'P29_PRIORITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_source=>'PRIORITY'
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
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>142
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211523830840203372)
,p_name=>'P29_SUBMITTED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_source=>'SUBMITTED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211524235624203372)
,p_name=>'P29_SUBMITTED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_source=>'SUBMITTED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211524674880203372)
,p_name=>'P29_FINAL_APPROVE_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_source=>'FINAL_APPROVE_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211525017704203377)
,p_name=>'P29_FINAL_REJECT_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_source=>'FINAL_REJECT_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211525434148203378)
,p_name=>'P29_REJECTED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_source=>'REJECTED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211525861477203378)
,p_name=>'P29_REJECT_REASON'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_source=>'REJECT_REASON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211526285446203378)
,p_name=>'P29_CANCEL_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_source=>'CANCEL_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211526601241203378)
,p_name=>'P29_CANCELLED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_source=>'CANCELLED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211527037058203378)
,p_name=>'P29_CANCEL_REASON'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_source=>'CANCEL_REASON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211528506117203379)
,p_name=>'P29_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(370699070350639017)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211528955853203380)
,p_name=>'P29_CREATION_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(370699070350639017)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Created ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211529345772203381)
,p_name=>'P29_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(370699070350639017)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'N'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211529743976203381)
,p_name=>'P29_UPDATED_DATE'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_api.id(370699070350639017)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Updated ON'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211530430987203381)
,p_name=>'P29_REQUEST_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(370695478391638981)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_source=>'REQUEST_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211530884343203382)
,p_name=>'P29_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(370698017010639006)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
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
,p_cSize=>60
,p_cMaxlength=>12
,p_field_template=>wwv_flow_api.id(159923987954220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211531220492203382)
,p_name=>'P29_REQUEST_NO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(370698017010639006)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Request No'
,p_source=>'REQUEST_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211531617102203383)
,p_name=>'P29_CONTRACT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(370698017010639006)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Contract'
,p_source=>'CONTRACT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'CONTRACT BY PROJECT PAGE 29'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select cp.CONTRACT_NUMBER , cp.contract_number               ||',
'                            '' (''                             ||',
'                            NVL(c.CONTRACT_TITLE, ''XXX'') ||',
'                            '')''     contract',
'from cwip_contract_projects cp , cwip_contract c',
'where cp.contract_number = c.contract_number',
'and cp.project_number = :P29_PROJECT_NUMBER',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P29_PROJECT_NUMBER'
,p_ajax_items_to_submit=>'P29_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>60
,p_field_template=>wwv_flow_api.id(159923987954220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211532002810203383)
,p_name=>'P29_REQUEST_DATE'
,p_source_data_type=>'DATE'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(370698017010639006)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Request Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'REQUEST_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211532442928203383)
,p_name=>'P29_BM_REQUIRED'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(370698017010639006)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_default=>'Y'
,p_prompt=>'Cost Benchmark Required ? '
,p_source=>'BM_REQUIRED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(159923987954220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211532869120203383)
,p_name=>'P29_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(370698017010639006)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_default=>'Draft'
,p_prompt=>'Status'
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
 p_id=>wwv_flow_api.id(211533224751203383)
,p_name=>'P29_END_USER_REQUIRED'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(370698017010639006)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_default=>'N'
,p_prompt=>'End User Sign-off Required ?'
,p_source=>'END_USER_REQUIRED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(159923987954220121)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'Y'
,p_attribute_03=>'Yes'
,p_attribute_04=>'N'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211533685005203384)
,p_name=>'P29_END_USER_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(370698017010639006)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'End User Representative'
,p_source=>'END_USER_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211534057921203384)
,p_name=>'P29_YEAR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(370698017010639006)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_default=>'SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL'
,p_item_default_type=>'SQL_QUERY'
,p_source=>'YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211534425676203385)
,p_name=>'P29_SEQ'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(370698017010639006)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_item_default=>'SELECT NVL(MAX(SEQ), 0)+ 1 FROM vr_requests'
,p_item_default_type=>'SQL_QUERY'
,p_source=>'SEQ'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211535177801203385)
,p_name=>'P29_JUSTIFICATION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(370698073894639007)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Justification'
,p_source=>'JUSTIFICATION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>5
,p_grid_label_column_span=>1
,p_field_template=>wwv_flow_api.id(159923528297220120)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211535807230203386)
,p_name=>'P29_CHANGE_REASONS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(370698205890639008)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Change Reason'
,p_source=>'CHANGE_REASONS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'VR CHANGE REASONS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select   s.LOOKUP_VALUE',
'        ,s.id as ID',
' from dct_lookups_extended s',
' where s.status = ''A''',
' and CODE = ''VRCR''',
' and sysdate BETWEEN nvl(s.start_date, sysdate - 10) ',
'    and nvl(s.end_date, sysdate + 10)',
'order by DISPLAY_ORDER;'))
,p_field_template=>wwv_flow_api.id(159923987954220121)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--xlarge'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211536278741203386)
,p_name=>'P29_CHANGE_REASON_OTHER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(370698205890639008)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Other'
,p_source=>'CHANGE_REASON_OTHER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>512
,p_field_template=>wwv_flow_api.id(159923987954220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211536962105203387)
,p_name=>'P29_ESTIMATED_DAYS'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(370698311652639009)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Estimated Time Impact'
,p_post_element_text=>'<p><strong>&nbsp;Days</strong></p>'
,p_source=>'ESTIMATED_DAYS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923987954220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211537346147203387)
,p_name=>'P29_ESTIMATED_DAYS_COMMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(370698311652639009)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Estimated Days Comments'
,p_source=>'ESTIMATED_DAYS_COMMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>2
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211537776930203387)
,p_name=>'P29_ESTIMATED_COST'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(370698311652639009)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Estimated Cost Impact'
,p_post_element_text=>'<p><strong>&nbsp;AED</strong></p>'
,p_format_mask=>'999G999G999G999G990D00'
,p_source=>'ESTIMATED_COST'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(159923987954220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211538154624203388)
,p_name=>'P29_ESTIMATED_COST_COMMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(370698311652639009)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Estimated Cost Comment'
,p_source=>'ESTIMATED_COST_COMMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>2
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211538592978203388)
,p_name=>'P29_PROFESSIONAL_FEES'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(370698311652639009)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Professional Fee'
,p_source=>'PROFESSIONAL_FEES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'INCLUDE / EXCLUDE '
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    value,',
'    value_id',
'FROM',
'    dct_lookup_values',
'WHERE',
'        lookup_id = 61 -- VR Profession Fee',
'    AND status = ''A''',
'    AND sysdate BETWEEN nvl(start_date, sysdate - 10) AND nvl(end_date, sysdate + 10)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(159923987954220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211538933852203388)
,p_name=>'P29_ESTIMATE_BASIS'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(370698311652639009)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Basis of Estimate:'
,p_source=>'ESTIMATE_BASIS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'VR ESTIMATED BASIS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select   s.LOOKUP_VALUE    ',
'        ,s.id as ID',
' from dct_lookups_extended s',
' where s.status = ''A''',
' and CODE = ''VREB''',
' and sysdate BETWEEN nvl(s.start_date, sysdate - 10) ',
'    and nvl(s.end_date, sysdate + 10)',
'order by DISPLAY_ORDER;'))
,p_field_template=>wwv_flow_api.id(159923622455220121)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'1'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211539301699203388)
,p_name=>'P29_ESTIMATE_BASIS_OTHERS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(370698311652639009)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Specify The Estimate Basis'
,p_source=>'ESTIMATE_BASIS_OTHERS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(159923987954220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211539721421203388)
,p_name=>'P29_FUNDING_SOURCE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(370698311652639009)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Funding Source'
,p_source=>'FUNDING_SOURCE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'VR FUNDING SOURCE'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select   s.LOOKUP_VALUE ',
'        ,s.id as ID',
' from dct_lookups_extended s',
' where s.status = ''A''',
' and CODE = ''VRFS''',
' and sysdate BETWEEN nvl(s.start_date, sysdate - 10) ',
'    and nvl(s.end_date, sysdate + 10)',
'order by DISPLAY_ORDER;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(159923987954220121)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211540144826203389)
,p_name=>'P29_FUNDING_SOURCE_OTHERS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(370698311652639009)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Specify The Funding Source'
,p_source=>'FUNDING_SOURCE_OTHERS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(159923987954220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211540831892203389)
,p_name=>'P29_QUALITY_ASSESSMENT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(370698421690639010)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Quality Assessment'
,p_placeholder=>'Design assessment of proposed change, including functionality, durability, maintainability, etc'
,p_source=>'QUALITY_ASSESSMENT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>3
,p_field_template=>wwv_flow_api.id(159923872371220121)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211559196008203426)
,p_name=>'P29_SCOPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(405498467781446615)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Scope'
,p_source=>'SCOPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>4000
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(159923528297220120)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(211559825680203426)
,p_name=>'P29_ADDITIONAL_COMMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(405809833054359169)
,p_item_source_plug_id=>wwv_flow_api.id(371507384859423730)
,p_prompt=>'Additional Comments'
,p_source=>'ADDITIONAL_COMMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>4000
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(159923528297220120)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(211576267318203441)
,p_validation_name=>'P29_SUBMITTED_ON must be timestamp'
,p_validation_sequence=>250
,p_validation=>'P29_SUBMITTED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(211523830840203372)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(211576656653203441)
,p_validation_name=>'P29_FINAL_APPROVE_ON must be timestamp'
,p_validation_sequence=>270
,p_validation=>'P29_FINAL_APPROVE_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(211524674880203372)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(211577063959203441)
,p_validation_name=>'P29_CREATION_DATE must be timestamp'
,p_validation_sequence=>300
,p_validation=>'P29_CREATION_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(211528955853203380)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(211577446168203442)
,p_validation_name=>'P29_UPDATED_DATE must be timestamp'
,p_validation_sequence=>310
,p_validation=>'P29_UPDATED_DATE'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(211529743976203381)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(211577813065203442)
,p_validation_name=>'P29_FINAL_REJECT_ON must be timestamp'
,p_validation_sequence=>320
,p_validation=>'P29_FINAL_REJECT_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(211525017704203377)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(211578206199203442)
,p_validation_name=>'P29_CANCEL_ON must be timestamp'
,p_validation_sequence=>350
,p_validation=>'P29_CANCEL_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(211526285446203378)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(211578535037203442)
,p_name=>'show other DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P29_CHANGE_REASONS'
,p_condition_element=>'P29_CHANGE_REASONS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'8'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(211579075337203442)
,p_event_id=>wwv_flow_api.id(211578535037203442)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P29_CHANGE_REASON_OTHER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(211579599393203443)
,p_event_id=>wwv_flow_api.id(211578535037203442)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P29_CHANGE_REASON_OTHER'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(211580065415203443)
,p_event_id=>wwv_flow_api.id(211578535037203442)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P29_CHANGE_REASON_OTHER'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(211580413555203443)
,p_name=>'ESTIMATE_BASIS Others DA'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P29_ESTIMATE_BASIS'
,p_condition_element=>'P29_ESTIMATE_BASIS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'14'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(211580907951203443)
,p_event_id=>wwv_flow_api.id(211580413555203443)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P29_ESTIMATE_BASIS_OTHERS'
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
 p_id=>wwv_flow_api.id(211581492865203443)
,p_event_id=>wwv_flow_api.id(211580413555203443)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P29_ESTIMATE_BASIS_OTHERS'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(211581979173203444)
,p_event_id=>wwv_flow_api.id(211580413555203443)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P29_ESTIMATE_BASIS_OTHERS'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(211582352349203444)
,p_name=>'FUNDING_SOURCE Others DA'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P29_FUNDING_SOURCE'
,p_condition_element=>'P29_FUNDING_SOURCE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'15'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(211582882510203444)
,p_event_id=>wwv_flow_api.id(211582352349203444)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P29_FUNDING_SOURCE_OTHERS'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(211583375358203444)
,p_event_id=>wwv_flow_api.id(211582352349203444)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P29_FUNDING_SOURCE_OTHERS'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(211583865451203444)
,p_event_id=>wwv_flow_api.id(211582352349203444)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P29_FUNDING_SOURCE_OTHERS'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(211584231005203444)
,p_name=>'END_USER_REQUIRED DA'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P29_END_USER_REQUIRED'
,p_condition_element=>'P29_END_USER_REQUIRED'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(211584738958203445)
,p_event_id=>wwv_flow_api.id(211584231005203444)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P29_END_USER_PERSON_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(211585203833203445)
,p_event_id=>wwv_flow_api.id(211584231005203444)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P29_END_USER_PERSON_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(211585792851203445)
,p_event_id=>wwv_flow_api.id(211584231005203444)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P29_END_USER_PERSON_ID'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(211527810947203379)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(371507384859423730)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Vr Request'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(211527414335203379)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(371507384859423730)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Vr Request'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
