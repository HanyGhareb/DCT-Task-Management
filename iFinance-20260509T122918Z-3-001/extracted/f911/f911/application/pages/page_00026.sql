prompt --application/pages/page_00026
begin
--   Manifest
--     PAGE: 00026
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
 p_id=>26
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Gift Card details'
,p_alias=>'GIFT-CARD-DETAILS'
,p_step_title=>'Gift Card details'
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
,p_read_only_when=>':P26_APPROVAL_STATUS not in (''Draft'' , ''Withdraw'' ,''Returned'')'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220819061806'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(21086411487637691)
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
 p_id=>wwv_flow_api.id(116778518708720923)
,p_plug_name=>'Summary Lines'
,p_parent_plug_id=>wwv_flow_api.id(21086411487637691)
,p_icon_css_classes=>'fa-list-ol'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent10:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P26_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(116778466611720922)
,p_plug_name=>'Lines'
,p_parent_plug_id=>wwv_flow_api.id(116778518708720923)
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
' where REQUEST_ID = :P26_ID',
'order by LINE_ID;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P26_ID'
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
 p_id=>wwv_flow_api.id(116778332686720921)
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
,p_internal_uid=>102995263695177122
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116778221001720920)
,p_db_column_name=>'LINE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116778192828720919)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116775840042720896)
,p_db_column_name=>'NO'
,p_display_order=>30
,p_column_identifier=>'X'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116777848982720916)
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
 p_id=>wwv_flow_api.id(116778020788720918)
,p_db_column_name=>'CONTROL_COUNT'
,p_display_order=>50
,p_column_identifier=>'C'
,p_column_label=>'Count'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116441959195276037)
,p_db_column_name=>'CONTROL_AMOUNT'
,p_display_order=>60
,p_column_identifier=>'Y'
,p_column_label=>'Cards Values'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116776178240720899)
,p_db_column_name=>'FEES'
,p_display_order=>70
,p_column_identifier=>'U'
,p_column_label=>'Fees'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116776010685720898)
,p_db_column_name=>'VAT'
,p_display_order=>80
,p_column_identifier=>'V'
,p_column_label=>'VAT'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116777768636720915)
,p_db_column_name=>'NOTES'
,p_display_order=>90
,p_column_identifier=>'F'
,p_column_label=>'Note'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116777695260720914)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>100
,p_column_identifier=>'G'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116777533274720913)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>110
,p_column_identifier=>'H'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116777448626720912)
,p_db_column_name=>'BUDGET_CODE'
,p_display_order=>120
,p_column_identifier=>'I'
,p_column_label=>'Budget Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116777335497720911)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>130
,p_column_identifier=>'J'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116777228589720910)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>140
,p_column_identifier=>'K'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116777189099720909)
,p_db_column_name=>'FUTURE1'
,p_display_order=>150
,p_column_identifier=>'L'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116777085939720908)
,p_db_column_name=>'FUTURE2'
,p_display_order=>160
,p_column_identifier=>'M'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116776935710720907)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>170
,p_column_identifier=>'N'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116776804775720906)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>180
,p_column_identifier=>'O'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116776778276720905)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>190
,p_column_identifier=>'P'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116776632975720904)
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
 p_id=>wwv_flow_api.id(116776526239720903)
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
 p_id=>wwv_flow_api.id(116776414976720902)
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
 p_id=>wwv_flow_api.id(116776388291720901)
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
 p_id=>wwv_flow_api.id(116775899092720897)
,p_db_column_name=>'GIFT_CARDS_SETTING_ID'
,p_display_order=>240
,p_column_identifier=>'W'
,p_column_label=>'Gift Cards Setting Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116440750173276025)
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
 p_id=>wwv_flow_api.id(115477151166734902)
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
,p_display_condition=>':P26_APPROVAL_STATUS  in (''Draft'' , ''Withdraw'' ,''Returned'')'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115323537990299121)
,p_db_column_name=>'GIFT_CARDS_CATEGORY_ID_H'
,p_display_order=>270
,p_column_identifier=>'AC'
,p_column_label=>'Gift Cards Category Id H'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(116467505390459731)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1033061'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'NO:GIFT_CARDS_CATEGORY_ID:CONTROL_COUNT:CONTROL_AMOUNT:FEES:VAT:APXWS_CC_001:UPDATED_BY:UPDATED_ON::EMPLOYEES:DEL:GIFT_CARDS_CATEGORY_ID_H'
,p_sum_columns_on_break=>'CONTROL_COUNT:FEES:APXWS_CC_001:VAT:CONTROL_AMOUNT'
);
wwv_flow_api.create_worksheet_computation(
 p_id=>wwv_flow_api.id(114881057514072870)
,p_report_id=>wwv_flow_api.id(116467505390459731)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'Y+ U + V'
,p_format_mask=>'999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Net Budget Cost'
,p_report_label=>'Net Budget Cost'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(115476845772734899)
,p_plug_name=>'Details Lines'
,p_parent_plug_id=>wwv_flow_api.id(21086411487637691)
,p_icon_css_classes=>'fa-user-graduate'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent10:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>'select 1 from gift_cards_request_line_details where request_id = :P26_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(115476748855734898)
,p_plug_name=>'Details report'
,p_parent_plug_id=>wwv_flow_api.id(115476845772734899)
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
'  and request_id = :P26_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P26_ID'
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
 p_id=>wwv_flow_api.id(115476613553734897)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>104296982828163146
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115476565345734896)
,p_db_column_name=>'LINE_DETAILS_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Details Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115476447262734895)
,p_db_column_name=>'LINE_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115476375731734894)
,p_db_column_name=>'PERSON_TYPE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Person Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115476196498734893)
,p_db_column_name=>'PERSON_TITLE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115346100949396742)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115346076148396741)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115345901962396740)
,p_db_column_name=>'EMAIL'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115345875825396739)
,p_db_column_name=>'EMIRATED_ID'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Emirated ID'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115345786783396738)
,p_db_column_name=>'MOBILE_NUMBER'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Mobile Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115345671190396737)
,p_db_column_name=>'NOTES'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115345594869396736)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115345482658396735)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115345351911396734)
,p_db_column_name=>'BUDGET_CODE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Budget Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115345280957396733)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115345113911396732)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115345094263396731)
,p_db_column_name=>'FUTURE1'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115344916715396730)
,p_db_column_name=>'FUTURE2'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115344797599396729)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115344761099396728)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115344690959396727)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115344536479396726)
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
 p_id=>wwv_flow_api.id(115344420559396725)
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
 p_id=>wwv_flow_api.id(115344388507396724)
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
 p_id=>wwv_flow_api.id(115344205589396723)
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
 p_id=>wwv_flow_api.id(115344115368396722)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>250
,p_column_identifier=>'Y'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115344077601396721)
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
 p_id=>wwv_flow_api.id(115343983767396720)
,p_db_column_name=>'PHOTO_HIDDEN'
,p_display_order=>270
,p_column_identifier=>'AA'
,p_column_label=>'Photo Hidden'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115343857913396719)
,p_db_column_name=>'PHOTO'
,p_display_order=>280
,p_column_identifier=>'AB'
,p_column_label=>'Photo'
,p_column_html_expression=>'<image src=''#PHOTO_HIDDEN#'' width=60 height=60>'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(115331472056390518)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1044422'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PHOTO:FULL_NAME_EN:EMAIL:EMIRATED_ID:MOBILE_NUMBER:GIFT_CARDS_CATEGORY_ID:UPDATED_BY:UPDATED_ON:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(115059908026979040)
,p_plug_name=>'Approval History'
,p_parent_plug_id=>wwv_flow_api.id(21086411487637691)
,p_icon_css_classes=>'fa-list'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent10:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>70
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
'and  cc.REQUEST_ID = :P26_ID',
'order by step_no , ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P26_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P26_APPROVAL_STATUS != ''Draft'''
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
 p_id=>wwv_flow_api.id(115059810639979039)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>104713785741919004
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115059768173979038)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115059637194979037)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115059536373979036)
,p_db_column_name=>'STEP_NO'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Step No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115059417132979035)
,p_db_column_name=>'ACTION_REQUIRED'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Action Required'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115059315458979034)
,p_db_column_name=>'USER_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115059217593979033)
,p_db_column_name=>'STATUS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115059196138979032)
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
 p_id=>wwv_flow_api.id(115059046847979031)
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
 p_id=>wwv_flow_api.id(115058916033979030)
,p_db_column_name=>'COMMENTS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115058879298979029)
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
 p_id=>wwv_flow_api.id(115058725490979028)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
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
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115058652415979027)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115058520986979026)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115058485595979025)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115058337643979024)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115058201931979023)
,p_db_column_name=>'PHOTO'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(115040702058895829)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1047329'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_NO:PHOTO:FULL_NAME_EN:USER_NAME:ROLE_ID:ACTION_REQUIRED:STATUS:RECEVIED_DATE:ACTION_DATE:COMMENTS:'
,p_sort_column_1=>'STEP_NO'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(114993324751582942)
,p_report_id=>wwv_flow_api.id(115040702058895829)
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
 p_id=>wwv_flow_api.id(97361539601670032)
,p_plug_name=>'Documents'
,p_parent_plug_id=>wwv_flow_api.id(21086411487637691)
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P26_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(97361391794670030)
,p_plug_name=>'Documents report'
,p_parent_plug_id=>wwv_flow_api.id(97361539601670032)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23834504913372554)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ROW_VERSION_NUMBER,',
'       REQUEST_ID,',
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
'  from gift_cards_requests_documents',
'  where REQUEST_ID = :P26_ID',
'  order by UPDATED desc;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P26_ID'
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
 p_id=>wwv_flow_api.id(97361231931670029)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>122412364450228014
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97361185435670028)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97361023829670027)
,p_db_column_name=>'ROW_VERSION_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Row Version Number'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97360931710670026)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97360879486670025)
,p_db_column_name=>'FILENAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'File Name'
,p_column_link=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.::P37_ID,P37_PAGE_FROM,P37_STATUS:#ID#,26,&P26_APPROVAL_STATUS.'
,p_column_linktext=>'#FILENAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97360737535670024)
,p_db_column_name=>'FILE_MIMETYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'File Mimetype'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97360687451670023)
,p_db_column_name=>'FILE_CHARSET'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'File Charset'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97360525931670022)
,p_db_column_name=>'FILE_BLOB'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'File Blob'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97360439494670021)
,p_db_column_name=>'FILE_COMMENTS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97360359726670020)
,p_db_column_name=>'TAGS'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97360267197670019)
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
 p_id=>wwv_flow_api.id(97360098163670018)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97360094706670017)
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
 p_id=>wwv_flow_api.id(97359952222670016)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(24139339382244793)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97359823219670015)
,p_db_column_name=>'FILE_SIZE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'File Size'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97359756952670014)
,p_db_column_name=>'DOWNLOAD'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Download'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DOWNLOAD:GIFT_CARDS_REQUESTS_DOCUMENTS:FILE_BLOB:ID::FILE_MIMETYPE:FILENAME:UPDATED:FILE_CHARSET:attachment::'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(97248794516040993)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1225249'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FILENAME:FILE_COMMENTS:TAGS:UPDATED:UPDATED_BY:DOWNLOAD:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(97359388090670010)
,p_plug_name=>'Budget Distribution'
,p_parent_plug_id=>wwv_flow_api.id(21086411487637691)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--showIcon:t-Region--accent5:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23836400541372553)
,p_plug_display_sequence=>50
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P26_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(97359271434670009)
,p_plug_name=>'Budget Report'
,p_parent_plug_id=>wwv_flow_api.id(97359388090670010)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23834504913372554)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select Amount , ENTITY_CODE, COST_CENTER, BUDGET_CODE, GL_ACCOUNT, ACTIVITY, FUTURE1, FUTURE2, ',
'        ENTITY_CODE || ''.'' || COST_CENTER || ''.'' || BUDGET_CODE || ''.'' || GL_ACCOUNT',
'        || ''.'' || ACTIVITY || ''.'' || FUTURE1 || ''.'' || FUTURE2 Gl_combination,',
'        PROJECT_NUMBER, TASK_NUMBER, EXPENDITURE_TYPE,',
'        user_details.get_cost_center_name(COST_CENTER) cost_center_name',
'from',
'(',
'select sum(TOTAL_AMOUNT) Amount, ENTITY_CODE, COST_CENTER, BUDGET_CODE, GL_ACCOUNT, ACTIVITY, FUTURE1, FUTURE2, PROJECT_NUMBER, TASK_NUMBER, EXPENDITURE_TYPE',
'from',
'(',
'select rownum No,',
'        LINE_ID,',
'       REQUEST_ID,',
'       CONTROL_COUNT,',
'       (gift_cards_workflow.get_gift_card_fee_value(GIFT_CARDS_CATEGORY_ID) * CONTROL_COUNT)	        --Fees,',
'       +',
'       (gift_cards_workflow.get_vat_pct(GIFT_CARDS_SETTING_ID)  * ',
'       (gift_cards_workflow.get_gift_card_fee_value(GIFT_CARDS_CATEGORY_ID) * CONTROL_COUNT)',
'       )            ---VAT,',
'       +',
'       CONTROL_AMOUNT as total_amount,',
'       ',
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
' where REQUEST_ID = :P26_ID',
'--order by LINE_ID',
')',
'group by ENTITY_CODE, COST_CENTER, BUDGET_CODE, GL_ACCOUNT, ACTIVITY, FUTURE1, FUTURE2, PROJECT_NUMBER, TASK_NUMBER, EXPENDITURE_TYPE',
')',
';'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P26_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Budget Report'
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
 p_id=>wwv_flow_api.id(97359141564670008)
,p_max_row_count=>'1000000'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>122414454817228035
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97358897142670006)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97358836731670005)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97358720049670004)
,p_db_column_name=>'BUDGET_CODE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Budget Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97358620431670003)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97358572712670002)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97358484497670001)
,p_db_column_name=>'FUTURE1'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97358339664670000)
,p_db_column_name=>'FUTURE2'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97358209892669999)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97358100961669998)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Task Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97358049901669997)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97357920526669996)
,p_db_column_name=>'AMOUNT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97357815832669995)
,p_db_column_name=>'GL_COMBINATION'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'GL Combination'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97357753315669994)
,p_db_column_name=>'COST_CENTER_NAME'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Cost Center Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(97236914663213758)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1225367'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'GL_COMBINATION:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:AMOUNT:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(21128824985049047)
,p_plug_name=>'Budget Details'
,p_parent_plug_id=>wwv_flow_api.id(21086411487637691)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-useLocalStorage:is-collapsed:t-Region--noBorder:t-Region--scrollBody:t-Form--large'
,p_plug_template=>wwv_flow_api.id(23819444978372562)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(21128733507049046)
,p_plug_name=>'Audit Info'
,p_parent_plug_id=>wwv_flow_api.id(21086411487637691)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(23819444978372562)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P26_ID'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(21047218833637658)
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
 p_id=>wwv_flow_api.id(116775559144720893)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(116778518708720923)
,p_button_name=>'Add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.::P32_REQUEST_ID,P32_GIFT_CARDS_SETTING_ID:&P26_ID.,&P26_GIFT_CARDS_SETTING_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(97361489545670031)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(97361539601670032)
,p_button_name=>'New_document'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(23897848603372510)
,p_button_image_alt=>'New Document'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.:37:P37_REQUEST_ID,P37_PAGE_FROM,P37_STATUS:&P26_ID.,26,&P26_APPROVAL_STATUS.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(21064220440637671)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(21047218833637658)
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
 p_id=>wwv_flow_api.id(21063495188637669)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(21047218833637658)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(23898584035372508)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>':P26_ID is not null and :P26_APPROVAL_STATUS = ''Draft'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_database_action=>'DELETE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(21063092193637669)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(21047218833637658)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Save & Close'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P26_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-save-as'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(21062659580637669)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(21047218833637658)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Save & add line'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_condition=>'P26_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-save'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(115321736158299103)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(21047218833637658)
,p_button_name=>'Submit'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.::P35_APPROVAL_TYPE_ID,P35_ID:&P26_APPROVAL_TYPE_ID.,&P26_ID.'
,p_button_condition=>':P26_ID is not null and :P26_APPROVAL_STATUS in (''Draft'' , ''Withdraw'' )'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(115058138491979022)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(21047218833637658)
,p_button_name=>'Rollback'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(23898584035372508)
,p_button_image_alt=>'Rollback'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(116441798710276036)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(21047218833637658)
,p_button_name=>'Print'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Print'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-print'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(97231915512265939)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(21086411487637691)
,p_button_name=>'edit_header'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--link'
,p_button_template_id=>wwv_flow_api.id(23897848603372510)
,p_button_image_alt=>'Edit Header'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-pencil'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(116441737868276035)
,p_branch_name=>'print'
,p_branch_action=>'f?p=&APP_ID.:0:&SESSION.:PRINT_REPORT=issuing%20gift%20card%20letter:&DEBUG.:::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(116441798710276036)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(116780084395720938)
,p_branch_name=>'Go to Gift Card request lines 32'
,p_branch_action=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.:32:P32_REQUEST_ID,P32_PROJECT_NUMBER,P32_TASK_NUMBER,P32_EXPENDITURE_TYPE,P32_GIFT_CARDS_SETTING_ID:&P26_ID.,&P26_PROJECT_NUMBER.,&P26_TASK_NUMBER.,&P26_EXPENDITURE_TYPE.,&P26_GIFT_CARDS_SETTING_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(21062659580637669)
,p_branch_sequence=>30
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(21128621559049045)
,p_branch_name=>'Keep in Page 26'
,p_branch_action=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.::P26_ID:&P26_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(21062659580637669)
,p_branch_sequence=>40
,p_branch_condition_type=>'NEVER'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(21062352136637669)
,p_branch_name=>'Go To Page 25'
,p_branch_action=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>50
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(117993412616352094)
,p_name=>'P26_YEAR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_default=>'select extract(Year from sysdate) from dual;'
,p_item_default_type=>'SQL_QUERY'
,p_source=>'YEAR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(117993345347352093)
,p_name=>'P26_SEQ_COUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
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
 p_id=>wwv_flow_api.id(116441608796276034)
,p_name=>'P26_PRINT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_use_cache_before_default=>'NO'
,p_source=>'P26_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(115060047295979041)
,p_name=>'P26_APPROVAL_TYPE_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_default=>'61'
,p_source=>'APPROVAL_TYPE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(115057564789979016)
,p_name=>'P26_COUNT'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_prompt=>'No of Employees'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(sum(l.CONTROL_COUNT),0),''99,999,999,999'')) cc',
'from gift_cards_request_lines l',
'where l.request_id = :P26_ID'))
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
 p_id=>wwv_flow_api.id(115057414959979015)
,p_name=>'P26_TOTAL'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
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
' where REQUEST_ID = :P26_ID2    --:P26_PRINT',
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
 p_id=>wwv_flow_api.id(115057341501979014)
,p_name=>'P26_ID2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21129273817049051)
,p_name=>'P26_REQUESTOR_DEPT_NAME'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_prompt=>'Department'
,p_source=>'select org_name from organizations_details_v where org_id = :P26_REQUESTOR_DEPT_ID'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21129129567049050)
,p_name=>'P26_REQUESTOR_SECTOR_NAME'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_prompt=>'Sector'
,p_source=>'select org_name from organizations_details_v where org_id = :P26_REQUESTOR_SECTOR_ID'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(23897477492372510)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21086102594637691)
,p_name=>'P26_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21085706980637688)
,p_name=>'P26_REFERENCE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''GC'' || to_char(sysdate , ''ddmmyyyy'') || ''/'' || :P26_SEQ_COUNT',
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
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21085300970637687)
,p_name=>'P26_REQUEST_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
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
 p_id=>wwv_flow_api.id(21084988002637686)
,p_name=>'P26_GIFT_CARDS_SETTING_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_default=>'gift_cards_workflow.get_active_gift_card_setting_id()'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_source=>'GIFT_CARDS_SETTING_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21084588895637686)
,p_name=>'P26_REQUESTOR_PERSON_ID'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
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
,p_attribute_10=>'ORG_ID:P26_REQUESTOR_ORG_ID,DEPARTMENT_ID:P26_REQUESTOR_DEPT_ID,SECTOR_ID:P26_REQUESTOR_SECTOR_ID,COST_CENTER_CODE:P26_REQUESTOR_COST_CENTER,DEPARTMENT_NAME:P26_REQUESTOR_DEPT_NAME,SECTOR:P26_REQUESTOR_SECTOR_NAME'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21084179515637686)
,p_name=>'P26_REQUESTOR_ORG_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_source=>'REQUESTOR_ORG_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21083742558637686)
,p_name=>'P26_REQUESTOR_DEPT_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_source=>'REQUESTOR_DEPT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21083390476637686)
,p_name=>'P26_REQUESTOR_SECTOR_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_source=>'REQUESTOR_SECTOR_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21082983503637685)
,p_name=>'P26_REQUESTOR_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_source=>'REQUESTOR_COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21082555142637685)
,p_name=>'P26_APPROVAL_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
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
 p_id=>wwv_flow_api.id(21082178766637685)
,p_name=>'P26_SUBMITTED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_prompt=>'Submitted On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'SUBMITTED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P26_APPROVAL_STATUS'
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
 p_id=>wwv_flow_api.id(21081384858637679)
,p_name=>'P26_SUBMITTED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_source=>'SUBMITTED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21080951360637679)
,p_name=>'P26_FINAL_APPROVED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_prompt=>'Final Approved On'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_source=>'FINAL_APPROVED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P26_APPROVAL_STATUS'
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
 p_id=>wwv_flow_api.id(21080126467637679)
,p_name=>'P26_FINAL_APPROVED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_source=>'FINAL_APPROVED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21079744597637678)
,p_name=>'P26_NOTES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_prompt=>'Purpose of Gift Requested'
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
 p_id=>wwv_flow_api.id(21079353666637678)
,p_name=>'P26_ENTITY_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_source=>'ENTITY_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21078914146637678)
,p_name=>'P26_COST_CENTER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_source=>'COST_CENTER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21078591569637678)
,p_name=>'P26_BUDGET_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_source=>'BUDGET_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21078137530637678)
,p_name=>'P26_GL_ACCOUNT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_source=>'GL_ACCOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21077731687637677)
,p_name=>'P26_ACTIVITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_source=>'ACTIVITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21077314234637677)
,p_name=>'P26_FUTURE1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_source=>'FUTURE1'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21076991986637677)
,p_name=>'P26_FUTURE2'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(21086411487637691)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_source=>'FUTURE2'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(21076577581637677)
,p_name=>'P26_PROJECT_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_api.id(21128824985049047)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
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
 p_id=>wwv_flow_api.id(21076128952637677)
,p_name=>'P26_TASK_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_api.id(21128824985049047)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_prompt=>'Task'
,p_source=>'TASK_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct TASK_NUMBER d , TASK_NUMBER',
'from expenditure',
'where PROJECT_NUMBER = :P26_PROJECT_NUMBER',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P26_PROJECT_NUMBER'
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
 p_id=>wwv_flow_api.id(21075738831637677)
,p_name=>'P26_EXPENDITURE_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_api.id(21128824985049047)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
,p_prompt=>'Expenditure Type'
,p_source=>'EXPENDITURE_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct EXPENDITURE_TYPE d , EXPENDITURE_TYPE',
'from expenditure',
'where PROJECT_NUMBER = :P26_PROJECT_NUMBER',
'and task_number = :P26_TASK_NUMBER',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P26_PROJECT_NUMBER,P26_TASK_NUMBER'
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
 p_id=>wwv_flow_api.id(21075326040637676)
,p_name=>'P26_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_api.id(21128733507049046)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
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
 p_id=>wwv_flow_api.id(21074946946637676)
,p_name=>'P26_CREATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_api.id(21128733507049046)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
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
 p_id=>wwv_flow_api.id(21074169688637676)
,p_name=>'P26_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_api.id(21128733507049046)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
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
 p_id=>wwv_flow_api.id(21073730694637676)
,p_name=>'P26_UPDATED_ON'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_api.id(21128733507049046)
,p_item_source_plug_id=>wwv_flow_api.id(21086411487637691)
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
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(21081683168637684)
,p_validation_name=>'P26_SUBMITTED_ON must be timestamp'
,p_validation_sequence=>100
,p_validation=>'P26_SUBMITTED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(21082178766637685)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(21080458331637679)
,p_validation_name=>'P26_FINAL_APPROVED_ON must be timestamp'
,p_validation_sequence=>120
,p_validation=>'P26_FINAL_APPROVED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(21080951360637679)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(21074486872637676)
,p_validation_name=>'P26_CREATED_ON must be timestamp'
,p_validation_sequence=>260
,p_validation=>'P26_CREATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(21074946946637676)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(21073245941637675)
,p_validation_name=>'P26_UPDATED_ON must be timestamp'
,p_validation_sequence=>280
,p_validation=>'P26_UPDATED_ON'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_api.id(21073730694637676)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(116780470029720942)
,p_name=>'get GL Account'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P26_EXPENDITURE_TYPE'
,p_condition_element=>'P26_EXPENDITURE_TYPE'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(116780328716720941)
,p_event_id=>wwv_flow_api.id(116780470029720942)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P26_ENTITY_CODE,P26_COST_CENTER,P26_GL_ACCOUNT,P26_ACTIVITY,P26_FUTURE1,P26_FUTURE2'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''451'' entity , t.COST_CENTER, t.BUDGET_GROUP_CODE, exp.gl_account ,t.ACTIVITY, t.FUTURE1, t.FUTURE2',
'from expenditure exp , task t',
'where exp.task_number = t.task_number',
'and t.project_number = exp.PROJECT_NUMBER',
'and exp.PROJECT_NUMBER = :P26_PROJECT_NUMBER',
'and exp.task_number = :P26_TASK_NUMBER',
'and rownum = 1'))
,p_attribute_07=>'P26_PROJECT_NUMBER,P26_TASK_NUMBER'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(116775726961720895)
,p_name=>'refresh summary line after update'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(116778466611720922)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(116775658848720894)
,p_event_id=>wwv_flow_api.id(116775726961720895)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(116778466611720922)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(116442424765276042)
,p_name=>'New'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(116775559144720893)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(116442333346276041)
,p_event_id=>wwv_flow_api.id(116442424765276042)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(116778466611720922)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(115058036458979021)
,p_name=>'Rollback DA'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(115058138491979022)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(115057991620979020)
,p_event_id=>wwv_flow_api.id(115058036458979021)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Rollback?'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(115057826377979019)
,p_event_id=>wwv_flow_api.id(115058036458979021)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Begin',
'delete from gift_cards_requests_approval_history where request_ID = :P26_ID;',
'update gift_cards_requests set APPROVAL_STATUS = ''Draft'' , SUBMITTED_ON = '''', FINAL_APPROVED_ON = '''' where id = :P26_ID;',
'--delete from all_notifications where request_id = :P2_ID;',
'End;'))
,p_attribute_02=>'P26_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(115057734908979018)
,p_event_id=>wwv_flow_api.id(115058036458979021)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(115057220387979013)
,p_name=>'set ID2'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P26_ID'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(115057150658979012)
,p_event_id=>wwv_flow_api.id(115057220387979013)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P26_ID2'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>':P26_ID'
,p_attribute_07=>'P26_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(21128943487049048)
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
'into    :P26_REQUESTOR_PERSON_ID,',
'        :P26_REQUESTOR_ORG_ID,',
'        :P26_REQUESTOR_DEPT_ID,',
'        :P26_REQUESTOR_DEPT_NAME,',
'        :P26_REQUESTOR_SECTOR_ID,',
'        :P26_REQUESTOR_SECTOR_NAME,',
'        :P26_REQUESTOR_COST_CENTER',
'from employees_v e',
'where person_id = :PERSON_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P26_ID'
,p_process_when_type=>'ITEM_IS_NULL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(21061425539637668)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(21086411487637691)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Gift Card details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(21061809783637668)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(21086411487637691)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Gift Card details'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(115477059787734901)
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
