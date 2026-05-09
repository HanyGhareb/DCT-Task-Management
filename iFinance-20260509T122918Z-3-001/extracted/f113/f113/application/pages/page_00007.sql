prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>100034894930602818
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>7
,p_user_interface_id=>wwv_flow_api.id(99842037194410797)
,p_name=>'Payment Request Approve/Reject Actions'
,p_alias=>'PAYMENT-REQUEST-APPROVE-REJECT-ACTIONS'
,p_page_mode=>'MODAL'
,p_step_title=>'Payment Request Approve/Reject Actions'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function delete_rec(p_val, p_row) {',
'    var rec = $(p_val).closest(''tr'');',
'    apex.server.process(',
'        ''Delete From Line'', // Process or AJAX Callback name',
'    {',
'        x01: p_row',
'    }, // Parameter "x01"',
'    {',
'        beforeSend: function () {',
'            alert(''Are you sure want to delete this line'' + p_row);',
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
'	//apex.submit( ''DELETE'' );',
'    apex.submit(''remove_line'');',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9038'
,p_last_upd_yyyymmddhh24miss=>'20220409182831'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1346474480183710)
,p_plug_name=>'AP Accountants'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'       apex_item.checkbox2(1,e.person_id) Selected,',
'       e.full_name_en ,',
'       e.employee_num ,',
'       e.email,',
'       CASE',
'        WHEN dbms_lob.getlength(e.photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || e.user_name',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END PHOTO_hidden,',
'        null PHOTO',
'from  employees_v e',
' where e.person_id in (SELECT person_id',
'                        FROM dct_data_access_assignment ',
'                            where entity_type_id = ''ROLE'' ',
'                            and entity_id = 69  -- AP Accountant',
'                            and status = ''A'' ',
'                            and sysdate BETWEEN start_date ',
'                                and nvl(end_date , sysdate + 10))',
'order by e.FULL_NAME_EN;'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P7_ACTION = ''Approve'' and :P7_ROLE_ID = 68'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'AP Accountants'
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
 p_id=>wwv_flow_api.id(1346554453183711)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>101381449383786529
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1346668531183712)
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
 p_id=>wwv_flow_api.id(1346787540183713)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Accountant '
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1346854523183714)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Employee#'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1346997468183715)
,p_db_column_name=>'EMAIL'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1347058733183716)
,p_db_column_name=>'PHOTO_HIDDEN'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Photo Hidden'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1347147855183717)
,p_db_column_name=>'PHOTO'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Photo'
,p_column_html_expression=>'<image src=''#PHOTO_HIDDEN#'' width=75 height=75>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1567092907533044)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1016020'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SELECTED:PHOTO:FULL_NAME_EN:EMPLOYEE_NUM:EMAIL:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1348641009183732)
,p_plug_name=>'Finance Business Partner'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--stacked:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P7_ROLE_ID = 73 and :P7_ACTION = ''Approve'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_plug_comment=>'for FBP only to add the distribution details for direct Payment'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1614081825483087)
,p_plug_name=>'By Project'
,p_parent_plug_id=>wwv_flow_api.id(1348641009183732)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--stacked:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1614985305483096)
,p_plug_name=>'Project Report'
,p_parent_plug_id=>wwv_flow_api.id(1614081825483087)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select rownum,',
'        LINE_ID,',
'       PAYMENT_REQUEST_ID,',
'       AMOUNT,',
'       LINE_DESCRIPTION,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       NOTES,',
'       ',
'       '' <i class="fa fa-trash" aria-hidden="true"></i>'' Del',
'',
'  from PAYMENT_REQUEST_LINES',
'  where PAYMENT_REQUEST_ID = :P7_PAYMENT_REQUEST_ID',
'  order by line_id;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P7_PAYMENT_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Project Report'
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
 p_id=>wwv_flow_api.id(1615073912483097)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>101649968843085915
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1617702958483123)
,p_db_column_name=>'ROWNUM'
,p_display_order=>10
,p_column_identifier=>'I'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1615128641483098)
,p_db_column_name=>'LINE_ID'
,p_display_order=>20
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1615274475483099)
,p_db_column_name=>'PAYMENT_REQUEST_ID'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Payment Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1615634321483103)
,p_db_column_name=>'AMOUNT'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1615802769483104)
,p_db_column_name=>'LINE_DESCRIPTION'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Line Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1616542668483112)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1616608443483113)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1616792275483114)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1616828644483115)
,p_db_column_name=>'NOTES'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1710288897397920)
,p_db_column_name=>'DEL'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Remove'
,p_column_link=>'javascript:void(0);'
,p_column_linktext=>'   <i class="fa fa-trash" aria-hidden="true"></i>'
,p_column_link_attr=>'onclick="delete_rec(this, #LINE_ID#)" title="Click to remove this line"'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1647817918697241)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1016828'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ROWNUM:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:AMOUNT:LINE_DESCRIPTION::DEL'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1614132057483088)
,p_plug_name=>'By GL'
,p_parent_plug_id=>wwv_flow_api.id(1348641009183732)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1617763320483124)
,p_plug_name=>'GL Report'
,p_parent_plug_id=>wwv_flow_api.id(1614132057483088)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(99755588163410744)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select LINE_ID,',
'       PAYMENT_REQUEST_ID,',
'       AMOUNT,',
'       LINE_DESCRIPTION,',
'       ENTITY_CODE,',
'       COST_CENTER,',
'       BUDGET_GROUP_CODE,',
'       GL_ACCOUNT,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2',
'  from PAYMENT_REQUEST_LINES',
'  where PAYMENT_REQUEST_ID = :P7_PAYMENT_REQUEST_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P7_PAYMENT_REQUEST_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'GL Report'
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
 p_id=>wwv_flow_api.id(1617854878483125)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>101652749809085943
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1617937781483126)
,p_db_column_name=>'LINE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Line Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1618075459483127)
,p_db_column_name=>'PAYMENT_REQUEST_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Payment Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1618457236483131)
,p_db_column_name=>'AMOUNT'
,p_display_order=>60
,p_column_identifier=>'C'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1618536986483132)
,p_db_column_name=>'LINE_DESCRIPTION'
,p_display_order=>70
,p_column_identifier=>'D'
,p_column_label=>'Line Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1638895785685083)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>80
,p_column_identifier=>'E'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1638924246685084)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>90
,p_column_identifier=>'F'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1639074802685085)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>100
,p_column_identifier=>'G'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1639150637685086)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>110
,p_column_identifier=>'H'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1639207782685087)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>120
,p_column_identifier=>'I'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1639363903685088)
,p_db_column_name=>'FUTURE1'
,p_display_order=>130
,p_column_identifier=>'J'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1639500325685089)
,p_db_column_name=>'FUTURE2'
,p_display_order=>140
,p_column_identifier=>'K'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1648499608697245)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1016834'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'AMOUNT:LINE_DESCRIPTION:COST_CENTER:GL_ACCOUNT:FUTURE2:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1551947290288239)
,p_plug_name=>'Comment'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(99757408152410744)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1345718634183703)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(1551947290288239)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'&P7_APPROVAL_LABEL.'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>':P7_ACTION = ''Approve'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-thumbs-up fa-anim-flash'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1345860407183704)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(1551947290288239)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'&P7_REJECT_LABEL.'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>':P7_ACTION = ''Reject'''
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-thumbs-o-down fa-anim-flash'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1346280235183708)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(1551947290288239)
,p_button_name=>'Delegate'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>'P7_ACTION'
,p_button_condition2=>'Delegate'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1346384731183709)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(1551947290288239)
,p_button_name=>'Return'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>'P7_ACTION'
,p_button_condition2=>'Return'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-repeat'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1348479099183730)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(1551947290288239)
,p_button_name=>'send_update'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Send Update'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_button_condition=>'P7_ACTION'
,p_button_condition2=>'MORE_INFO'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-send-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1345961733183705)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(1551947290288239)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_api.id(99819552699410780)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1640684220685101)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(1614081825483087)
,p_button_name=>'add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8:P8_ALLOCATE_BY,P8_PAYMENT_REQUEST_ID:P,&P7_PAYMENT_REQUEST_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(1640938484685104)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(1614132057483088)
,p_button_name=>'Add_GL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(99819656626410780)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8:P8_ALLOCATE_BY,P8_PAYMENT_REQUEST_ID:G,&P7_PAYMENT_REQUEST_ID.'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1347630542183722)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_IN_CONDITION'
,p_branch_condition=>'Approve,Reject,Return,Delegate, send_update'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(1710326223397921)
,p_branch_name=>'Stay in 7'
,p_branch_action=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1344923013183695)
,p_name=>'P7_HISTORY_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(1551947290288239)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1345081611183696)
,p_name=>'P7_PAYMENT_REQUEST_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(1551947290288239)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1345247641183698)
,p_name=>'P7_ACTION'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(1551947290288239)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1345396242183699)
,p_name=>'P7_APPROVAL_LABEL'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(1551947290288239)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1345467764183700)
,p_name=>'P7_REJECT_LABEL'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(1551947290288239)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1345538925183701)
,p_name=>'P7_ROLE_ID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(1551947290288239)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1345696256183702)
,p_name=>'P7_COMMENT'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(1551947290288239)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(99818469241410779)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1347738508183723)
,p_name=>'P7_DELEGATE_TO_PERSON_ID'
,p_is_required=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(1551947290288239)
,p_prompt=>'Delegate To'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name',
'FROM employees_v e'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_display_when=>'P7_ACTION'
,p_display_when2=>'Delegate'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'DIALOG'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1347885335183724)
,p_name=>'P7_RETURN_TO_PERSON_ID'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(1551947290288239)
,p_prompt=>'Return to'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct e.full_name_en , h.PERSON_ID',
'from payment_request_approval_history h, employees_v e',
'where h.person_id = e.person_id ',
'and h.PAYMENT_REQUEST_ID = :P7_PAYMENT_REQUEST_ID',
'and  h.ACTION_DATE is not null '))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_display_when=>'P7_ACTION'
,p_display_when2=>'Return'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1347973923183725)
,p_name=>'P7_STEP_NO'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(1551947290288239)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1613656279483083)
,p_name=>'P7_INVOICE_AMOUNT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(1348641009183732)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Invoice Amount'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(INVOICE_AMOUNT,''99,999,999,999,999.99'') || '' '' || CURRENCY_CODE)',
'',
'from payment_requests_all',
'where PAYMENT_REQUEST_ID = :P7_PAYMENT_REQUEST_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(99818469241410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1613707063483084)
,p_name=>'P7_P7_INVOICE_AMOUNT_H'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(1348641009183732)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1613814245483085)
,p_name=>'P7_DISTRIBUTED_AMOUNT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(1348641009183732)
,p_prompt=>'Allocated'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(Sum(NVL(AMOUNT,0)) , ''99,999,999,999.99'')) ',
'from payment_request_lines',
'where PAYMENT_REQUEST_ID = :P7_PAYMENT_REQUEST_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(99818469241410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1613966082483086)
,p_name=>'P7_DISTRIBUTED_AMOUNT_H'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(1348641009183732)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(1614278292483089)
,p_name=>'P7_ALLOCATE_BY'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(1348641009183732)
,p_item_default=>'P'
,p_prompt=>'Allocate By'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Project Level;P,GL Level;G'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(99818572861410779)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1346101993183706)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(1345961733183705)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1346145186183707)
,p_event_id=>wwv_flow_api.id(1346101993183706)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(1614485920483091)
,p_name=>'show allocation'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P7_ALLOCATE_BY'
,p_condition_element=>'P7_ALLOCATE_BY'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'P'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1614598140483092)
,p_event_id=>wwv_flow_api.id(1614485920483091)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(1614081825483087)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1614884848483095)
,p_event_id=>wwv_flow_api.id(1614485920483091)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(1614132057483088)
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>100034894930602818
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1614645676483093)
,p_event_id=>wwv_flow_api.id(1614485920483091)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(1614081825483087)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(1614770272483094)
,p_event_id=>wwv_flow_api.id(1614485920483091)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(1614132057483088)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1614400574483090)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get Invoice amount for direct payment process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(INVOICE_AMOUNT,''99,999,999,999,999.99'') || '' '' || CURRENCY_CODE) , INVOICE_AMOUNT',
'into :P7_INVOICE_AMOUNT         , :P7_INVOICE_AMOUNT_H',
'from payment_requests_all',
'where PAYMENT_REQUEST_ID = :P7_PAYMENT_REQUEST_ID;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'NEVER'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1347223040183718)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approve Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_count                 NUMBER := apex_application.g_f01.count;',
'    l_to_person_id          NUMBER;',
'    l_invoice_amount        Number;',
'    l_invoice_amount_t     varchar2(50);',
'    l_allocate_amount       Number;',
'    l_invoice_amount_t2     Number;',
'begin',
'',
'-- AP document controller',
'if :P7_ROLE_ID = 68 then',
'                    IF l_count = 0 THEN',
'                            apex_error.add_error(p_message => ''Please select at least one Accountant! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'                    ELSIF l_count > 0 THEN',
'                                            payment_request_workflow.Approve_forward(:P7_PAYMENT_REQUEST_ID,41, :person_id,:P7_COMMENT);  ',
'                                         FOR i IN 1..l_count ',
'                                          LOOP',
'                                            l_to_person_id := to_number(apex_application.g_f01(i));',
'                                            payment_request_workflow.INSERT_AP_ACCOUNTANT(:P7_PAYMENT_REQUEST_ID,41,''Pending'',:P7_STEP_NO,l_to_person_id);',
'                                           payment_request_emails.SEND_PAYMENT_REQUEST_EMAIL(:P7_PAYMENT_REQUEST_ID,l_to_person_id',
'                                                                                             ,''ACTION_REQUIRED_PAYMENT_REQUEST''',
'                                                                                             ,PAYMENT_REQUEST_APPROVAL_HISTORY_SEQ.currval',
'                                                                                             ,:P7_COMMENT, :PERSON_ID,''Y'') ;',
'                                          END LOOP;',
'                                           ',
'       ',
'                  End If; ',
'-- for  FBP Role                  ',
'elsif  :P7_ROLE_ID = 73 then',
'          -- get Invoice amount, Allocated amount (to check the invoice_amount is allocated)',
'          ',
'           select round(Sum(NVL(AMOUNT,0)), 2)  ',
'            into l_allocate_amount  ',
'            from payment_request_lines',
'            where PAYMENT_REQUEST_ID = :P7_PAYMENT_REQUEST_ID;  ',
'            ',
'            ',
'            ',
'          select  INVOICE_AMOUNT ,  decode(VAT_APPLIED_YN, ''Y'',',
'                                                           trim(to_char(INVOICE_AMOUNT/1.05,  ''99,999,999,999.99'')),',
'                                           trim(to_char(INVOICE_AMOUNT,  ''99,999,999,999.99'') ))',
'                                 , round(decode(VAT_APPLIED_YN, ''Y'',',
'                                                           l_allocate_amount * 1.05, ',
'                                                           l_allocate_amount) )         ',
'            into l_invoice_amount , l_invoice_amount_t , l_invoice_amount_t2',
'            from payment_requests_all',
'            where PAYMENT_REQUEST_ID = :P7_PAYMENT_REQUEST_ID;',
'            ',
'       ',
'            if l_invoice_amount != l_invoice_amount_t2',
'                    then ',
'                        apex_error.add_error(p_message => ''you have to allocate the whole invoice amount which is '' || l_invoice_amount_t || ''('' || l_invoice_amount_t2 || '')'' ',
'                                                                       || ''  ('' || l_invoice_amount_t2 || '')'',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'                    else',
'                    payment_request_workflow.Approve(:P7_PAYMENT_REQUEST_ID,41, :person_id,:P7_COMMENT);   ',
'            end if;                            ',
'      ',
'      ',
'  ',
'  ',
'  else',
'   payment_request_workflow.Approve(:P7_PAYMENT_REQUEST_ID,41, :person_id,:P7_COMMENT);   ',
'      ',
'     End If; ',
'                  ',
'          ',
'End;'))
,p_process_error_message=>'you can''t approve, Please contact system admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(1345718634183703)
,p_process_success_message=>'Approved Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1347352883183719)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reject Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
'IF :P7_COMMENT is null THEN',
'                    apex_error.add_error(p_message => ''Please enter your comment! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'else',
'  payment_request_workflow.Reject(:P7_PAYMENT_REQUEST_ID,41,:person_id, :P7_COMMENT);',
'  ',
' End if;',
'End;'))
,p_process_error_message=>'you can''t reject, Please contact system admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(1345860407183704)
,p_process_success_message=>'Rejected.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1347469397183720)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delegate process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'  payment_request_workflow.DELEGATE(:P7_PAYMENT_REQUEST_ID,41,:person_id,:P7_DELEGATE_TO_PERSON_ID, :P7_comment);',
'end;'))
,p_process_error_message=>'You can''t delegate, Please contact system admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(1346280235183708)
,p_process_success_message=>'Delegated Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1347589165183721)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Return Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
'IF :P7_COMMENT is null THEN',
'                    apex_error.add_error(p_message => ''Please enter your comment! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'else',
'  payment_request_workflow.RETURN(:P7_PAYMENT_REQUEST_ID,41,:person_id,:P7_RETURN_TO_PERSON_ID, :P7_comment);',
'  ',
' End if;',
'End;'))
,p_process_error_message=>'You can''t return, Please contact system admin'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(1346384731183709)
,p_process_success_message=>'Returned Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1348590721183731)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'MORE_INFO Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
'IF :P7_COMMENT is null THEN',
'                    apex_error.add_error(p_message => ''Please enter your update! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'else',
'  payment_request_workflow.MORE_INFO(:P7_PAYMENT_REQUEST_ID,41,:person_id, :P7_comment);',
'  ',
' End if;',
'End;'))
,p_process_error_message=>'you can''t send your update, Please contact your system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(1348479099183730)
,p_process_success_message=>'your updates has been sent successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(1710116313397919)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete From Line'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
' DELETE FROM payment_request_lines',
'  WHERE LINE_ID =  apex_application.g_x01;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
