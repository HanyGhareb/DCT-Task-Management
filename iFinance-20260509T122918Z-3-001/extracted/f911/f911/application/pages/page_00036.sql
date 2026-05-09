prompt --application/pages/page_00036
begin
--   Manifest
--     PAGE: 00036
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>36
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Gift Cards request Approve / Reject'
,p_alias=>'GIFT-CARDS-REQUEST-APPROVE-REJECT'
,p_step_title=>'Gift Cards request Approve / Reject'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';',
'',
' function delete_rec(p_val, p_row) {',
'    var rec = $(p_val).closest(''tr'');',
'    apex.server.process(',
'        ''Delete From Line'', // Process or AJAX Callback name',
'    {',
'        x01: p_row',
'    }, // Parameter "x01"',
'    {',
'        beforeSend: function () {',
'            alert(''Are you sure want to delete this employee'');',
'            rec.removeClass(''vikas'');',
'            rec.removeClass(''pandey'');',
'            rec.children().hover(function () {',
'                rec.children().animate({',
'                    ''backgroundColor'': ''#71e817''',
'                }, 300);',
'            },',
'                function () {',
'                rec.children().animate({',
'                    ''backgroundColor'': ''#71e817''',
'                }, 300);',
'            });',
'            rec.children().animate({',
'                ''backgroundColor'': ''#71e817''',
'            }, 300);',
'        },',
'',
'        success: function (pData) {',
'',
'            // Success Javascript',
'            rec.children().wrapInner(''<div>'').children().fadeOut(500,',
'                function () {',
'                rec.remove(); // visually remove the row from the report',
'            });',
'        },',
'        dataType: "text" // Response type (here: plain text)',
'',
'    });',
'	',
'//	apex.submit( ''DELETE'' );',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'PLSQL_EXPRESSION'
,p_read_only_when=>':P36_APPROVAL_STATUS not in (''Draft'' , ''Withdraw'' ,''Returned'')'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220424111128'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(83716748672853597)
,p_plug_name=>'Gift Card details'
,p_icon_css_classes=>'fa-gift'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'GIFT_CARDS_REQUESTS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11975358548229635)
,p_plug_name=>'Summary Lines'
,p_parent_plug_id=>wwv_flow_api.id(83716748672853597)
,p_icon_css_classes=>'fa-list-ol'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent10:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11975306451229634)
,p_plug_name=>'Lines'
,p_parent_plug_id=>wwv_flow_api.id(11975358548229635)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23834504913372554)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select rownum No,',
'        LINE_ID,',
'       REQUEST_ID,',
'       CONTROL_COUNT,',
'       gift_cards_workflow.get_gift_card_fee_value(GIFT_CARDS_CATEGORY_ID) * CONTROL_COUNT	Fees,',
'       (gift_cards_workflow.get_vat_pct(GIFT_CARDS_SETTING_ID)  * ',
'       (gift_cards_workflow.get_gift_card_fee_value(GIFT_CARDS_CATEGORY_ID) * CONTROL_COUNT)',
'       )  VAT,',
'       CONTROL_AMOUNT,',
'       GIFT_CARDS_CATEGORY_ID,',
'       NOTES,',
'       ENTITY_CODE,',
'       COST_CENTER,',
'       BUDGET_CODE,',
'       GL_ACCOUNT,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       GIFT_CARDS_SETTING_ID,',
'        GIFT_CARDS_CATEGORY_ID  GIFT_CARDS_CATEGORY_ID_H  ,',
'       ''<span aria-hidden="true" class="fa fa-folder-user"></span>'' Employees,',
'       ''   <i class="fa fa-trash" aria-hidden="true"></i>'' Del',
'  from GIFT_CARDS_REQUEST_LINES',
' where REQUEST_ID = :P36_ID',
'order by LINE_ID;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P36_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Lines'
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
 p_id=>wwv_flow_api.id(11975172526229633)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.::P32_LINE_ID,P32_APPROVAL_STATUS:#LINE_ID#,&P26_APPROVAL_STATUS.'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_detail_link_condition_type=>'PLSQL_EXPRESSION'
,p_detail_link_cond=>':P26_APPROVAL_STATUS in (''Draft'' , ''Withdraw'' ,''Returned'')'
,p_owner=>'TCA9051'
,p_internal_uid=>207798423855668410
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114935926366406720)
,p_db_column_name=>'LINE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114935575149406719)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114927133653406715)
,p_db_column_name=>'NO'
,p_display_order=>30
,p_column_identifier=>'X'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114934762474406719)
,p_db_column_name=>'GIFT_CARDS_CATEGORY_ID'
,p_display_order=>40
,p_column_identifier=>'E'
,p_column_label=>'Card Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(116571414771827940)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114935137615406719)
,p_db_column_name=>'CONTROL_COUNT'
,p_display_order=>50
,p_column_identifier=>'C'
,p_column_label=>'Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114926733036406715)
,p_db_column_name=>'CONTROL_AMOUNT'
,p_display_order=>60
,p_column_identifier=>'Y'
,p_column_label=>'Cards Values'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114928324635406716)
,p_db_column_name=>'FEES'
,p_display_order=>70
,p_column_identifier=>'U'
,p_column_label=>'Fees'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114927993265406716)
,p_db_column_name=>'VAT'
,p_display_order=>80
,p_column_identifier=>'V'
,p_column_label=>'VAT'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114934321998406719)
,p_db_column_name=>'NOTES'
,p_display_order=>90
,p_column_identifier=>'F'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114933929358406719)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>100
,p_column_identifier=>'G'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114933528832406718)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>110
,p_column_identifier=>'H'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114933188578406718)
,p_db_column_name=>'BUDGET_CODE'
,p_display_order=>120
,p_column_identifier=>'I'
,p_column_label=>'Budget Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114932709811406718)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>130
,p_column_identifier=>'J'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114932343342406718)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>140
,p_column_identifier=>'K'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114931934981406718)
,p_db_column_name=>'FUTURE1'
,p_display_order=>150
,p_column_identifier=>'L'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114931584615406717)
,p_db_column_name=>'FUTURE2'
,p_display_order=>160
,p_column_identifier=>'M'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114931111691406717)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>170
,p_column_identifier=>'N'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114930793587406717)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>180
,p_column_identifier=>'O'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114930356577406717)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>190
,p_column_identifier=>'P'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114929907509406717)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>200
,p_column_identifier=>'Q'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114929558626406716)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>210
,p_column_identifier=>'R'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114929183087406716)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>220
,p_column_identifier=>'S'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114928778421406716)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>230
,p_column_identifier=>'T'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114927535543406716)
,p_db_column_name=>'GIFT_CARDS_SETTING_ID'
,p_display_order=>240
,p_column_identifier=>'W'
,p_column_label=>'Gift Cards Setting Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114926306295406715)
,p_db_column_name=>'EMPLOYEES'
,p_display_order=>250
,p_column_identifier=>'Z'
,p_column_label=>'Employees'
,p_column_link=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.:Y,,33:P33_ID,P33_LINE_ID,P33_GIFT_CARDS_CATEGORY_ID,P33_CONTROL_COUNT,P33_APPROVAL_STATUS,P33_CATEGORY:#REQUEST_ID#,#LINE_ID#,#GIFT_CARDS_CATEGORY_ID_H#,#CONTROL_COUNT#,&P26_APPROVAL_STATUS.,#GIFT_CARDS_CATEGORY_ID#'
||'##CONTROL_COUNT#,&P26_APPROVAL_STATUS.,#GIFT_CARDS_CATEGORY_ID#'
,p_column_linktext=>'<span aria-hidden="true" class="fa fa-folder-user"></span>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114925930869406714)
,p_db_column_name=>'DEL'
,p_display_order=>260
,p_column_identifier=>'AA'
,p_column_label=>'Delete'
,p_column_link=>'javascript:void(0);'
,p_column_linktext=>'   <i class="fa fa-trash" aria-hidden="true"></i>'
,p_column_link_attr=>'  onclick="delete_rec(this, #LINE_ID#)" title="Click to remove this line"'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_display_condition_type=>'PLSQL_EXPRESSION'
,p_display_condition=>':P36_APPROVAL_STATUS  in (''Draft'' , ''Withdraw'' ,''Returned'')'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114925528013406714)
,p_db_column_name=>'GIFT_CARDS_CATEGORY_ID_H'
,p_display_order=>270
,p_column_identifier=>'AC'
,p_column_label=>'Gift Cards Category Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(11664345229968443)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1048484'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'NO:GIFT_CARDS_CATEGORY_ID:CONTROL_COUNT:CONTROL_AMOUNT:FEES:VAT:APXWS_CC_001:UPDATED_BY:UPDATED_ON::EMPLOYEES:DEL:GIFT_CARDS_CATEGORY_ID_H'
,p_sum_columns_on_break=>'CONTROL_COUNT:FEES:APXWS_CC_001:VAT:CONTROL_AMOUNT'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(114924751339406713)
,p_report_id=>wwv_flow_api.id(11664345229968443)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'C  +  Y+ U + V'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Net Budget Cost'
,p_report_label=>'Net Budget Cost'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10673685612243611)
,p_plug_name=>'Details Lines'
,p_parent_plug_id=>wwv_flow_api.id(83716748672853597)
,p_icon_css_classes=>'fa-user-graduate'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent10:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10673588695243610)
,p_plug_name=>'Details report'
,p_parent_plug_id=>wwv_flow_api.id(10673685612243611)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23834504913372554)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select LINE_DETAILS_ID,',
'       LINE_ID,',
'       ld.PERSON_TYPE,',
'       ld.PERSON_TITLE,',
'       ld.PERSON_ID,',
'       ld.FULL_NAME_EN,',
'       ld.EMAIL,',
'       ld.EMIRATED_ID,',
'       ld.MOBILE_NUMBER,',
'       ld.NOTES,',
'       ENTITY_CODE,',
'       COST_CENTER,',
'       BUDGET_CODE,',
'       GL_ACCOUNT,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       CREATED_BY,',
'       CREATED_ON,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       REQUEST_ID,',
'       GIFT_CARDS_CATEGORY_ID,',
'                  CASE',
'        WHEN dbms_lob.getlength(e.photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || e.user_name',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END PHOTO_hidden,',
'            null PHOTO',
'  from GIFT_CARDS_REQUEST_LINE_DETAILS ld, employees_v e',
'  where ld.person_id = e.person_id',
'  and request_id = :P36_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P36_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Details report'
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
 p_id=>wwv_flow_api.id(10673453393243609)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>209100142988654434
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114948503751406727)
,p_db_column_name=>'LINE_DETAILS_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Details Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114948109620406726)
,p_db_column_name=>'LINE_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114947715898406726)
,p_db_column_name=>'PERSON_TYPE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Person Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114947388575406726)
,p_db_column_name=>'PERSON_TITLE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114946921103406726)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114946544467406726)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114946151628406725)
,p_db_column_name=>'EMAIL'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114945698790406725)
,p_db_column_name=>'EMIRATED_ID'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Emirated ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114945383614406725)
,p_db_column_name=>'MOBILE_NUMBER'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Mobile Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114944967895406725)
,p_db_column_name=>'NOTES'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114944557980406725)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114944184694406725)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114943772860406724)
,p_db_column_name=>'BUDGET_CODE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Budget Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114943314838406724)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114942933366406724)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114942539606406724)
,p_db_column_name=>'FUTURE1'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114942139612406724)
,p_db_column_name=>'FUTURE2'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114941795940406723)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114941326541406723)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114940906473406723)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114940573844406723)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114940156444406723)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114939767532406722)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114939372150406722)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>240
,p_column_identifier=>'X'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114938963314406722)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114938539582406722)
,p_db_column_name=>'GIFT_CARDS_CATEGORY_ID'
,p_display_order=>260
,p_column_identifier=>'Z'
,p_column_label=>'Card Category'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_api.id(116571414771827940)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114938140422406722)
,p_db_column_name=>'PHOTO_HIDDEN'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Photo Hidden'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114937778975406722)
,p_db_column_name=>'PHOTO'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Photo'
,p_column_html_expression=>'<image src=''#PHOTO_HIDDEN#'' width=60 height=60>'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(10528311895899230)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1048362'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FULL_NAME_EN:EMAIL:EMIRATED_ID:MOBILE_NUMBER:GIFT_CARDS_CATEGORY_ID:UPDATED_BY:UPDATED_ON:_HIDDEN:PHOTO'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10256747866487752)
,p_plug_name=>'Approval History'
,p_parent_plug_id=>wwv_flow_api.id(83716748672853597)
,p_icon_css_classes=>'fa-list'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent10:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CC.ID,',
'       cc.REQUEST_id,',
'       STEP_NO,',
'       ACTION_REQUIRED,',
'       e.USER_NAME,',
'       STATUS,',
'       RECEVIED_DATE,',
'       ACTION_DATE,',
'       COMMENTS,',
'       ROLE_ID,',
'--       APPROVAL_TYPE,',
'       CREATED_ON,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       UPDATED_ON,',
'       e.full_name_en,',
'       case nvl(dbms_lob.getlength(e.photo_blob),0) ',
'           when 0  THEN',
'                 ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || ''TCA000''',
'            else  ',
'                ',
'             ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || upper(e.user_name)',
'           end Photo',
'  from GIFT_CARDS_REQUESTS_APPROVAL_HISTORY cc,  dct_employees_list2  e',
'  where cc.person_id = e.person_id (+)',
'and  cc.REQUEST_ID = :P36_ID',
'order by step_no , ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P36_ID'
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
 p_id=>wwv_flow_api.id(10256650479487751)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>209516945902410292
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114956376635406733)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114955926020406733)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114955593404406733)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Step No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114955190076406733)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114954728841406733)
,p_db_column_name=>'USER_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114954369992406733)
,p_db_column_name=>'STATUS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114953984123406732)
,p_db_column_name=>'RECEVIED_DATE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Recevied Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114953499044406732)
,p_db_column_name=>'ACTION_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Action Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114953183792406732)
,p_db_column_name=>'COMMENTS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114952785196406732)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Role'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(114995297037599324)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114952329236406732)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114951961151406731)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114951556469406731)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114951123002406731)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114950775702406731)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114950344281406730)
,p_db_column_name=>'PHOTO'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(10237541898404541)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1048236'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:USER_NAME:ROLE_ID:ACTION_REQUIRED:STATUS:RECEVIED_DATE:ACTION_DATE:COMMENTS:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(114949573059406728)
,p_report_id=>wwv_flow_api.id(10237541898404541)
,p_name=>'pending'
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
 p_id=>wwv_flow_api.id(83674335175442241)
,p_plug_name=>'Budget Details'
,p_parent_plug_id=>wwv_flow_api.id(83716748672853597)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-collapsed:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(23819444978372562)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(83674426653442242)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(83716748672853597)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23819444978372562)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P36_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(83755941326853630)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23845862961372548)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(23782494216372596)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(23899958141372507)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(114936662196406721)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11975358548229635)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.::P32_REQUEST_ID,P32_GIFT_CARDS_SETTING_ID:&P36_ID.,&P36_GIFT_CARDS_SETTING_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(114920196707406710)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(83755941326853630)
,p_button_name=>'BACK'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Back'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-backward'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(115057095099979011)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(83755941326853630)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(115056927857979010)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(83755941326853630)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(115056839901979009)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(83755941326853630)
,p_button_name=>'Delegate'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(115056741737979008)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(83755941326853630)
,p_button_name=>'Return'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-reply'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(114899516604406696)
,p_branch_name=>'print'
,p_branch_action=>'f?p=&APP_ID.:0:&SESSION.:PRINT_REPORT=issuing%20gift%20card%20letter:&DEBUG.:::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(114899948929406696)
,p_branch_name=>'Go to Gift Card request lines 32'
,p_branch_action=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.:32:P32_REQUEST_ID,P32_PROJECT_NUMBER,P32_TASK_NUMBER,P32_EXPENDITURE_TYPE,P32_GIFT_CARDS_SETTING_ID:&P36_ID.,&P36_PROJECT_NUMBER.,&P36_TASK_NUMBER.,&P36_EXPENDITURE_TYPE.,&P36_GIFT_CARDS_SETTING_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>30
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(114899138775406696)
,p_branch_name=>'Keep in Page 26'
,p_branch_action=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.::P36_ID:&P36_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>40
,p_branch_condition_type=>'NEVER'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(114898743554406695)
,p_branch_name=>'Go To Page 25'
,p_branch_action=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>50
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114969802294406747)
,p_name=>'P36_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114969407059406746)
,p_name=>'P36_ID2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114969021066406745)
,p_name=>'P36_PRINT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_use_cache_before_default=>'NO'
,p_source=>'P36_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114968691526406745)
,p_name=>'P36_YEAR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_default=>'select extract(Year from sysdate) from dual;'
,p_item_default_type=>'SQL_QUERY'
,p_source=>'YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114968241578406745)
,p_name=>'P36_SEQ_COUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select nvl(max(seq_count),0) + 1',
'from gift_cards_requests',
'where year = EXTRACT(YEAR FROM sysdate);'))
,p_item_default_type=>'SQL_QUERY'
,p_source=>'SEQ_COUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114967889783406744)
,p_name=>'P36_APPROVAL_TYPE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_default=>'61'
,p_source=>'APPROVAL_TYPE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114967440864406744)
,p_name=>'P36_REFERENCE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''GC'' || ''/'' || :P36_Year || ''/'' || :P36_SEQ_COUNT',
'from dual;'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Reference Number'
,p_source=>'REFERENCE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>512
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114967023538406744)
,p_name=>'P36_REQUEST_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_default=>'sysdate'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Request Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'REQUEST_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>20
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_attribute_04=>'both'
,p_attribute_05=>'Y'
,p_attribute_07=>'MONTH_AND_YEAR'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114966693188406744)
,p_name=>'P36_GIFT_CARDS_SETTING_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_default=>'gift_cards_workflow.get_active_gift_card_setting_id()'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_source=>'GIFT_CARDS_SETTING_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114966202994406744)
,p_name=>'P36_REQUESTOR_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_default=>'PERSON_ID'
,p_item_default_type=>'ITEM'
,p_prompt=>'Request for :'
,p_source=>'REQUESTOR_PERSON_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'PERSON DETAILS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.employee_num || ''-'' || e.full_name_en  emp_name , e.person_id , e.org_id, e.department_name',
'        , e.sector ',
'        , e.department_id',
'        , e.sector_id',
'        , (select s.short_name_en',
'            from dct_hr_organizations s',
'            where s.org_id = e.sector_id) sector_code',
'        , cost_center_code    ',
'        , e.email',
'        , e.mobile',
'        , e.position',
'        , e.position_id',
'        , e.employee_num',
'        ,e.nationality_id',
'from employees_v e',
'where current_flag = ''Y'' ',
'ORDER BY employee_num;    '))
,p_lov_display_null=>'YES'
,p_cSize=>50
,p_cMaxlength=>255
,p_field_template=>wwv_flow_api.id(23897551787372510)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
,p_attribute_10=>'ORG_ID:P36_REQUESTOR_ORG_ID,DEPARTMENT_ID:P36_REQUESTOR_DEPT_ID,SECTOR_ID:P36_REQUESTOR_SECTOR_ID,COST_CENTER_CODE:P36_REQUESTOR_COST_CENTER,DEPARTMENT_NAME:P36_REQUESTOR_DEPT_NAME,SECTOR:P36_REQUESTOR_SECTOR_NAME'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114965802908406743)
,p_name=>'P36_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_default=>'Draft'
,p_prompt=>'Approval Status'
,p_source=>'APPROVAL_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114965491458406743)
,p_name=>'P36_REQUESTOR_ORG_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_source=>'REQUESTOR_ORG_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114965054628406743)
,p_name=>'P36_REQUESTOR_DEPT_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_source=>'REQUESTOR_DEPT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114964679977406742)
,p_name=>'P36_REQUESTOR_DEPT_NAME'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_prompt=>'Department'
,p_source=>'select org_name from organizations_details_v where org_id = :P36_REQUESTOR_DEPT_ID'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114964215400406742)
,p_name=>'P36_SUBMITTED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_prompt=>'Submitted On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'SUBMITTED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P36_APPROVAL_STATUS'
,p_display_when2=>'Draft'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114963858869406742)
,p_name=>'P36_REQUESTOR_SECTOR_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_source=>'REQUESTOR_SECTOR_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114963411999406742)
,p_name=>'P36_REQUESTOR_SECTOR_NAME'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_prompt=>'Sector'
,p_source=>'select org_name from organizations_details_v where org_id = :P36_REQUESTOR_SECTOR_ID'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114963032375406741)
,p_name=>'P36_REQUESTOR_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_source=>'REQUESTOR_COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114962676204406741)
,p_name=>'P36_SUBMITTED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_source=>'SUBMITTED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114962269396406741)
,p_name=>'P36_FINAL_APPROVED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_prompt=>'Final Approved On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'FINAL_APPROVED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P36_APPROVAL_STATUS'
,p_display_when2=>'Approved'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114961848068406741)
,p_name=>'P36_FINAL_APPROVED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_source=>'FINAL_APPROVED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114961447280406741)
,p_name=>'P36_TOTAL'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Total Amount'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   ',
'        trim(to_char(FEES + VAT + amount,''99,999,999.99'')) ||',
'        '' AED''  total_cost',
'from',
'(select sum(CONTROL_AMOUNT) amount,',
'       Sum(gift_cards_workflow.get_gift_card_fee_value(GIFT_CARDS_CATEGORY_ID) * CONTROL_COUNT)	Fees,',
'       Sum((gift_cards_workflow.get_vat_pct(GIFT_CARDS_SETTING_ID)  * ',
'       (gift_cards_workflow.get_gift_card_fee_value(GIFT_CARDS_CATEGORY_ID) * CONTROL_COUNT)',
'       ))  VAT',
'  from GIFT_CARDS_REQUEST_LINES',
' where REQUEST_ID = :P36_ID2    --:P36_PRINT',
' )'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114961071595406740)
,p_name=>'P36_COUNT'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_prompt=>'No of Employees'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(sum(l.CONTROL_COUNT),0),''99,999,999,999'')) cc',
'from gift_cards_request_lines l',
'where l.request_id = :P36_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114960691162406740)
,p_name=>'P36_NOTES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_prompt=>'Notes'
,p_source=>'NOTES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>2
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114960248603406740)
,p_name=>'P36_ENTITY_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_source=>'ENTITY_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114959884073406739)
,p_name=>'P36_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_source=>'COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114959434864406739)
,p_name=>'P36_BUDGET_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_source=>'BUDGET_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114959088904406739)
,p_name=>'P36_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_source=>'GL_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114958682370406739)
,p_name=>'P36_ACTIVITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_source=>'ACTIVITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114958262986406739)
,p_name=>'P36_FUTURE1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_source=>'FUTURE1'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114957887563406739)
,p_name=>'P36_FUTURE2'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(83716748672853597)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_source=>'FUTURE2'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114924001498406713)
,p_name=>'P36_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(83674335175442241)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_prompt=>'Project'
,p_source=>'PROJECT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'PROJECTS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct PROJECT_NUMBER || '' ('' ||  PROJECT_NAME || '')'' project_name , PROJECT_NUMBER',
'from project',
'where PROJECT_TYPE in (''Operational'' , ''Non GL Integrated'') ',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>12
,p_field_template=>wwv_flow_api.id(23897477492372510)
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
 p_id=>wwv_flow_api.id(114923683536406713)
,p_name=>'P36_TASK_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(83674335175442241)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_prompt=>'Task'
,p_source=>'TASK_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct TASK_NUMBER d , TASK_NUMBER',
'from expenditure',
'where PROJECT_NUMBER = :P36_PROJECT_NUMBER',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P36_PROJECT_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114923233564406712)
,p_name=>'P36_EXPENDITURE_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(83674335175442241)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_prompt=>'Expenditure Type'
,p_source=>'EXPENDITURE_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct EXPENDITURE_TYPE d , EXPENDITURE_TYPE',
'from expenditure',
'where PROJECT_NUMBER = :P36_PROJECT_NUMBER',
'and task_number = :P36_TASK_NUMBER',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P36_PROJECT_NUMBER,P36_TASK_NUMBER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114922545169406711)
,p_name=>'P36_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(83674426653442242)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'PERSON DETAILS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.employee_num || ''-'' || e.full_name_en  emp_name , e.person_id , e.org_id, e.department_name',
'        , e.sector ',
'        , e.department_id',
'        , e.sector_id',
'        , (select s.short_name_en',
'            from dct_hr_organizations s',
'            where s.org_id = e.sector_id) sector_code',
'        , cost_center_code    ',
'        , e.email',
'        , e.mobile',
'        , e.position',
'        , e.position_id',
'        , e.employee_num',
'        ,e.nationality_id',
'from employees_v e',
'where current_flag = ''Y'' ',
'ORDER BY employee_num;    '))
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114922147861406711)
,p_name=>'P36_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(83674426653442242)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_prompt=>'Created On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114921730011406711)
,p_name=>'P36_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(83674426653442242)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'PERSON DETAILS LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.employee_num || ''-'' || e.full_name_en  emp_name , e.person_id , e.org_id, e.department_name',
'        , e.sector ',
'        , e.department_id',
'        , e.sector_id',
'        , (select s.short_name_en',
'            from dct_hr_organizations s',
'            where s.org_id = e.sector_id) sector_code',
'        , cost_center_code    ',
'        , e.email',
'        , e.mobile',
'        , e.position',
'        , e.position_id',
'        , e.employee_num',
'        ,e.nationality_id',
'from employees_v e',
'where current_flag = ''Y'' ',
'ORDER BY employee_num;    '))
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'Y'
,p_attribute_02=>'LOV'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(114921344951406711)
,p_name=>'P36_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(83674426653442242)
,p_item_source_plug_id=>wwv_flow_api.id(83716748672853597)
,p_prompt=>'Updated On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(114907893605406701)
,p_validation_name=>'P36_SUBMITTED_ON must be timestamp'
,p_validation_sequence=>100
,p_validation=>'P36_SUBMITTED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(114964215400406742)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(114907440486406701)
,p_validation_name=>'P36_FINAL_APPROVED_ON must be timestamp'
,p_validation_sequence=>120
,p_validation=>'P36_FINAL_APPROVED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(114962269396406741)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(114907090212406700)
,p_validation_name=>'P36_CREATED_ON must be timestamp'
,p_validation_sequence=>260
,p_validation=>'P36_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(114922147861406711)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(114906623084406700)
,p_validation_name=>'P36_UPDATED_ON must be timestamp'
,p_validation_sequence=>280
,p_validation=>'P36_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(114921344951406711)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(114901805510406697)
,p_name=>'get GL Account'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P36_EXPENDITURE_TYPE'
,p_condition_element=>'P36_EXPENDITURE_TYPE'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(114901391217406697)
,p_event_id=>wwv_flow_api.id(114901805510406697)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P36_ENTITY_CODE,P36_COST_CENTER,P36_GL_ACCOUNT,P36_ACTIVITY,P36_FUTURE1,P36_FUTURE2'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''451'' entity , t.COST_CENTER, t.BUDGET_GROUP_CODE, exp.gl_account ,t.ACTIVITY, t.FUTURE1, t.FUTURE2',
'from expenditure exp , task t',
'where exp.task_number = t.task_number',
'and t.project_number = exp.PROJECT_NUMBER',
'and exp.PROJECT_NUMBER = :P36_PROJECT_NUMBER',
'and exp.task_number = :P36_TASK_NUMBER',
'and rownum = 1'))
,p_attribute_07=>'P36_PROJECT_NUMBER,P36_TASK_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(114905557518406700)
,p_name=>'refresh summary line after update'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(11975306451229634)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(114905020117406699)
,p_event_id=>wwv_flow_api.id(114905557518406700)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(11975306451229634)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(114904680725406698)
,p_name=>'New'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(114936662196406721)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(114904162407406698)
,p_event_id=>wwv_flow_api.id(114904680725406698)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(11975306451229634)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(114900927071406697)
,p_name=>'set ID2'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P36_ID'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(114900494091406697)
,p_event_id=>wwv_flow_api.id(114900927071406697)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P36_ID2'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>':P36_ID'
,p_attribute_07=>'P36_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(114905957887406700)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'set default requestor details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'          e.person_id',
'        , e.org_id',
'        , e.department_id',
'        , e.department_name',
'        , e.sector_id',
'        , e.sector ',
'        , cost_center_code    ',
'--        , e.employee_num',
'into    :P36_REQUESTOR_PERSON_ID,',
'        :P36_REQUESTOR_ORG_ID,',
'        :P36_REQUESTOR_DEPT_ID,',
'        :P36_REQUESTOR_DEPT_NAME,',
'        :P36_REQUESTOR_SECTOR_ID,',
'        :P36_REQUESTOR_SECTOR_NAME,',
'        :P36_REQUESTOR_COST_CENTER',
'from employees_v e',
'where person_id = :PERSON_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P36_ID'
,p_process_when_type=>'ITEM_IS_NULL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(114957044768406736)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(83716748672853597)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Gift Card details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(114957484117406737)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(83716748672853597)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Gift Card details'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(114906381958406700)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete From Line'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'-- delete records of GIFT_CARDS_REQUEST_LINES',
'insert into test values (apex_application.g_x01);',
'delete from GIFT_CARDS_REQUEST_LINES where LINE_ID = apex_application.g_x01;',
'',
'  commit;',
'END;',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
