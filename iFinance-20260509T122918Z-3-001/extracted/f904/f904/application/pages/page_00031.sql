prompt --application/pages/page_00031
begin
--   Manifest
--     PAGE: 00031
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>31
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'Documents Library'
,p_alias=>'DOCUMENTS-LIBRARY'
,p_step_title=>'Documents Library'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210905155727'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22122968643573526)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10254567086597785)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(10191147067597728)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(10308621936597827)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22123598404573527)
,p_plug_name=>'Documents Library'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select REFERENCE_NUMBER, PAYMENT_NUMBER, PAYMENT_RECOMMENDATION_DATE, VENDOR_NAME, VENDOR_NUMBER, VENDOR_SITE_CODE, VALUATION_PERIOD, PROJECT_NUMBER, PROJECT_NAME, PAYMENT_TYPE, NET_AMOUNT_PAYABLE, CONTRACT_NUMBER, CONTRACT_TITLE, CONTRACT_DESCRIPTIO'
||'N, CURRENCY, CONTRACT_AMOUNT, ID, ROW_VERSION_NUMBER, PAYMENT_RECOMMENDATION_ID, FILENAME, FILE_MIMETYPE, FILE_CHARSET, FILE_BLOB, FILE_COMMENTS, TAGS, CREATED, CREATED_BY, UPDATED, UPDATED_BY, COMMENT_ID, FILE_SIZE, DOWNLOAD',
'From (',
'SELECT',
'    pr.reference_number,',
'    pr.payment_number,',
'    pr.payment_recommendation_date,',
'    pr.vendor_name,',
'    pr.vendor_number,',
'    pr.vendor_site_code,',
'    pr.valuation_period,',
'    pr.project_number,',
'    pr.project_name,',
'    pr.payment_type,',
'    pr.net_amount_payable,',
'    pr.contract_number,',
'    pr.contract_title,',
'    pr.contract_description,',
'    pr.currency,',
'    pr.contract_amount,',
'    d.id,',
'    d.row_version_number,',
'    d.payment_recommendation_id,',
'    d.filename,',
'    d.file_mimetype,',
'    d.file_charset,',
'    d.file_blob,',
'    d.file_comments,',
'    d.tags,',
'    d.created,',
'    d.created_by,',
'    d.updated,',
'    d.updated_by,',
'    d.comment_id,',
'--    d.project_number,',
'--    d.contract_number,',
'    sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'FROM',
'    cwip_payment_recommendation_documents d , cwip_payment_recommendation_v pr',
'where d.payment_recommendation_id (+) = pr.payment_recommendation_id)',
'',
'where project_number in ( select PROJECT_NUMBER',
'                          from CWIP_TEAM',
'                         where 1=1',
'                         and role_id in (Select r.role_id from project_role r where r.category_id = 2)',
'                         and status = ''A''',
'                         and sysdate BETWEEN nvl(start_date , sysdate -1) and nvl(end_date, sysdate +10)',
'                         and person_type = ''INT''',
'                         and person_id = :PERSON_ID)',
'OR project_number in (select x.project_number ',
'                        from project x',
'                        where project_type = ''Capital''',
'                        and exists (select 1 ',
'                                    from cwip_team',
'                                    where cwip_team.person_id = :PERSON_ID',
'                                    and cwip_team.project_number is null) )    ',
'or project_number in (select x.project_number',
'                        from project x',
'                        where project_type = ''Capital''',
'                        and :PERSON_ID = 680461 ) ;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Documents Library'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(22123678384573527)
,p_name=>'Documents Library'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>22123678384573527
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22124016606573528)
,p_db_column_name=>'REFERENCE_NUMBER'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Reference Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22124467064573529)
,p_db_column_name=>'PAYMENT_NUMBER'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Payment Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22124875757573529)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_DATE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'REC Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22125277540573529)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22125666884573530)
,p_db_column_name=>'VENDOR_NUMBER'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Vendor Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22126002498573530)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22126407203573530)
,p_db_column_name=>'VALUATION_PERIOD'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Valuation Period'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22126847897573531)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22127238242573531)
,p_db_column_name=>'PAYMENT_TYPE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Payment Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22127683885573531)
,p_db_column_name=>'NET_AMOUNT_PAYABLE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Net Amount Payable'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22128080455573531)
,p_db_column_name=>'CONTRACT_TITLE'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Contract Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22128475601573532)
,p_db_column_name=>'CONTRACT_DESCRIPTION'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Contract Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22128834779573532)
,p_db_column_name=>'CURRENCY'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22129274064573532)
,p_db_column_name=>'CONTRACT_AMOUNT'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Contract Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22129644317573533)
,p_db_column_name=>'ID'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22130046009573533)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22130439565573533)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22130895351573534)
,p_db_column_name=>'FILENAME'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Document'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22131212305573534)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22131675877573534)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22132068044573534)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>22
,p_column_identifier=>'U'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22132479743573535)
,p_db_column_name=>'TAGS'
,p_display_order=>23
,p_column_identifier=>'V'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22132817939573535)
,p_db_column_name=>'CREATED'
,p_display_order=>24
,p_column_identifier=>'W'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22133221200573535)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>25
,p_column_identifier=>'X'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22133691956573535)
,p_db_column_name=>'UPDATED'
,p_display_order=>26
,p_column_identifier=>'Y'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22134037033573536)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>27
,p_column_identifier=>'Z'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22134406390573537)
,p_db_column_name=>'COMMENT_ID'
,p_display_order=>28
,p_column_identifier=>'AA'
,p_column_label=>'Comment Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22134838864573537)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>29
,p_column_identifier=>'AB'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22135280109573537)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>30
,p_column_identifier=>'AC'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22135603280573538)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>31
,p_column_identifier=>'AD'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(22136028377573538)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>32
,p_column_identifier=>'AE'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:CWIP_PAYMENT_RECOMMENDATION_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(21963675041318824)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>42
,p_column_identifier=>'AF'
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
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(22136475596575097)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'221365'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'REFERENCE_NUMBER:VENDOR_NAME:CONTRACT_NUMBER:PROJECT_NAME:CURRENCY:FILENAME:FILE_COMMENTS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(40303482321167705)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       PROJECT_NUMBER,',
'       CONTRACT_NUMBER,',
'       PAYMENT_RECOMMENDATION_ID,',
'       FILENAME,',
'       FILE_MIMETYPE,',
'       FILE_CHARSET,',
'       FILE_BLOB,',
'       FILE_COMMENTS,',
'       UPDATED,',
'       UPDATED_BY,',
'       sys.dbms_lob.getlength(file_blob) as file_size,',
'    sys.dbms_lob.getlength(file_blob) as download',
'  from CWIP_DOCUMENTS'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'New'
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
 p_id=>wwv_flow_api.id(40303547005167706)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>40303547005167706
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40303686662167707)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40303708996167708)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40303832889167709)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Contract Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40303936050167710)
,p_db_column_name=>'PAYMENT_RECOMMENDATION_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Payment Recommendation Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40304098137167711)
,p_db_column_name=>'FILENAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Filename'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40304143525167712)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40304241800167713)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40304387243167714)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>80
,p_column_identifier=>'H'
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
 p_id=>wwv_flow_api.id(40304432912167715)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'File Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40304558372167716)
,p_db_column_name=>'UPDATED'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40304637743167717)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40304786806167718)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40304844474167719)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'DOWNLOAD:CWIP_DOCUMENTS:FILE_BLOB:ID:PAYMENT_RECOMMENDATION_ID:FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(40363537509570599)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'403636'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:PROJECT_NUMBER:CONTRACT_NUMBER:PAYMENT_RECOMMENDATION_ID:FILENAME:FILE_MIMETYPE:FILE_CHARSET:FILE_BLOB:FILE_COMMENTS:UPDATED:UPDATED_BY:FILE_SIZE:DOWNLOAD'
);
wwv_flow_api.component_end;
end;
/
