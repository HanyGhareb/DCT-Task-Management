prompt --application/pages/page_00019
begin
--   Manifest
--     PAGE: 00019
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>19
,p_user_interface_id=>wwv_flow_api.id(12983317716762193)
,p_name=>'Mission Action'
,p_alias=>'MISSION-APPROVE-REJECT-ACTION'
,p_page_mode=>'MODAL'
,p_step_title=>'Mission Action'
,p_allow_duplicate_submissions=>'N'
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
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20240125115420'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110398125658476402)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12872392429762094)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(110407419611350948)
,p_plug_name=>'Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(212165817958947992)
,p_plug_name=>'Finance Business Partner'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent1:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'PLSQL_EXPRESSION'
,p_plug_display_when_condition=>':P19_ROLE_ID = 73 and :P19_ACTION = ''Approve'''
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
,p_plug_comment=>'for FBP only to add the distribution details for direct Payment'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(212431258775247347)
,p_plug_name=>'By Project'
,p_parent_plug_id=>wwv_flow_api.id(212165817958947992)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent1:t-Region--stacked:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(212432162255247356)
,p_plug_name=>'Project Report'
,p_parent_plug_id=>wwv_flow_api.id(212431258775247347)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select rownum,',
'        ID,',
'       REQUEST_ID,',
'       AMOUNT,',
'       PROJECT_NUMBER,',
'       TASK_NUMBER,',
'       EXPENDITURE_TYPE,',
'       COMMENTS,',
'       ',
'       '' <i class="fa fa-trash" aria-hidden="true"></i>'' Del',
'',
'  from mission_distributions',
'  where REQUEST_ID = :P19_REQUEST_ID',
'  order by id;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P19_REQUEST_ID'
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
 p_id=>wwv_flow_api.id(212432250862247357)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>323043127352254334
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(110794267072707)
,p_db_column_name=>'ROWNUM'
,p_display_order=>10
,p_column_identifier=>'I'
,p_column_label=>'No'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(108383919072708)
,p_db_column_name=>'AMOUNT'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109185150072708)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Project'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109548739072708)
,p_db_column_name=>'TASK_NUMBER'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'Task'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(109940611072708)
,p_db_column_name=>'EXPENDITURE_TYPE'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Expenditure Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(209469880530542)
,p_db_column_name=>'ID'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(209276573530541)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(209212799530540)
,p_db_column_name=>'COMMENTS'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(111186991072707)
,p_db_column_name=>'DEL'
,p_display_order=>140
,p_column_identifier=>'J'
,p_column_label=>'Remove'
,p_column_link=>'javascript:void(0);'
,p_column_linktext=>'   <i class="fa fa-trash" aria-hidden="true"></i>'
,p_column_link_attr=>'onclick="delete_rec(this, #ID#)" title="Click to remove this line"'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(212464994868461501)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1107224'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ROWNUM:PROJECT_NUMBER:TASK_NUMBER:EXPENDITURE_TYPE:AMOUNT:COMMENTS:DEL:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(212431309007247348)
,p_plug_name=>'By GL'
,p_parent_plug_id=>wwv_flow_api.id(212165817958947992)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent1:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12898750262762112)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(212434940270247384)
,p_plug_name=>'GL Report'
,p_parent_plug_id=>wwv_flow_api.id(212431309007247348)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12896834679762110)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       REQUEST_ID,',
'       AMOUNT,',
'       COMMENTS,',
'       ENTITY_CODE,',
'       COST_CENTER,',
'       BUDGET_GROUP_CODE,',
'       GL_ACCOUNT,',
'       ACTIVITY,',
'       FUTURE1,',
'       FUTURE2',
'  from mission_distributions',
'  where REQUEST_ID = :P19_REQUEST_ID',
'  order  by id;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P19_REQUEST_ID'
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
 p_id=>wwv_flow_api.id(212435031828247385)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_owner=>'TCA9051'
,p_internal_uid=>323045908318254362
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(113786519072705)
,p_db_column_name=>'AMOUNT'
,p_display_order=>60
,p_column_identifier=>'C'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114598449072705)
,p_db_column_name=>'ENTITY_CODE'
,p_display_order=>80
,p_column_identifier=>'E'
,p_column_label=>'Entity Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(114976305072705)
,p_db_column_name=>'COST_CENTER'
,p_display_order=>90
,p_column_identifier=>'F'
,p_column_label=>'Cost Center'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115352622072705)
,p_db_column_name=>'BUDGET_GROUP_CODE'
,p_display_order=>100
,p_column_identifier=>'G'
,p_column_label=>'Budget Group Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115752379072704)
,p_db_column_name=>'GL_ACCOUNT'
,p_display_order=>110
,p_column_identifier=>'H'
,p_column_label=>'Gl Account'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116125722072704)
,p_db_column_name=>'ACTIVITY'
,p_display_order=>120
,p_column_identifier=>'I'
,p_column_label=>'Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116547897072704)
,p_db_column_name=>'FUTURE1'
,p_display_order=>130
,p_column_identifier=>'J'
,p_column_label=>'Future1'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(116989388072704)
,p_db_column_name=>'FUTURE2'
,p_display_order=>140
,p_column_identifier=>'K'
,p_column_label=>'Future2'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(209052479530538)
,p_db_column_name=>'ID'
,p_display_order=>150
,p_column_identifier=>'L'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208949690530537)
,p_db_column_name=>'REQUEST_ID'
,p_display_order=>160
,p_column_identifier=>'M'
,p_column_label=>'Request Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(208867620530536)
,p_db_column_name=>'COMMENTS'
,p_display_order=>170
,p_column_identifier=>'N'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(212465676558461505)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1107282'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'COST_CENTER:GL_ACCOUNT:FUTURE2:AMOUNT:COMMENTS:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110399538981476416)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(110398125658476402)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(106849049072710)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(212431258775247347)
,p_button_name=>'add'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:22:P22_ALLOCATE_BY,P22_REQUEST_ID,P22_PAGE_FROM:P,&P19_REQUEST_ID.,19'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1  from mission_distributions',
'  where REQUEST_ID = :P19_REQUEST_ID;'))
,p_button_condition_type=>'NOT_EXISTS'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(112277132072706)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(212431309007247348)
,p_button_name=>'Add_GL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:22:P22_ALLOCATE_BY,P22_REQUEST_ID,P22_PAGE_FROM:G,&P19_REQUEST_ID.,19'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1  from mission_distributions',
'  where REQUEST_ID = :P19_REQUEST_ID;'))
,p_button_condition_type=>'NOT_EXISTS'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110398229324476403)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(110398125658476402)
,p_button_name=>'Approve'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--success:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Approve'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P19_ACTION'
,p_button_condition2=>'Approve'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110398333832476404)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(110398125658476402)
,p_button_name=>'Reject'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--danger:t-Button--iconRight:t-Button--hoverIconPush'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Reject'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P19_ACTION'
,p_button_condition2=>'Reject'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-thumbs-o-down'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3159983326269129)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(110398125658476402)
,p_button_name=>'Withdraw'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Withdraw'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P19_ACTION'
,p_button_condition2=>'Withdraw'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110398400050476405)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(110398125658476402)
,p_button_name=>'Delegate'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Delegate'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P19_ACTION'
,p_button_condition2=>'Delegate'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-sign-language'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(110399204158476413)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(110398125658476402)
,p_button_name=>'Return'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Return'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P19_ACTION'
,p_button_condition2=>'Return'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(96257179031052839)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(110398125658476402)
,p_button_name=>'Return_After'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconRight:t-Button--hoverIconSpin'
,p_button_template_id=>wwv_flow_api.id(12960939482762161)
,p_button_image_alt=>'Return to'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P19_ACTION'
,p_button_condition2=>'ReturnAfter'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(96257349306052841)
,p_branch_name=>'Go to 13'
,p_branch_action=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.::P13_REQUEST_ID:&P19_REQUEST_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(96257179031052839)
,p_branch_sequence=>10
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(99304331154685823)
,p_branch_name=>'Go to 19'
,p_branch_action=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(104574931072711)
,p_name=>'P19_ALLOCATE_BY'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(212165817958947992)
,p_item_default=>'P'
,p_prompt=>'Allocate By'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Project Level;P,GL Level;G'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(104934819072710)
,p_name=>'P19_AMOUNT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(212165817958947992)
,p_prompt=>'Eligible Amount '
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_is_persistent=>'N'
,p_escape_on_http_output=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(105349914072710)
,p_name=>'P19_DISTRIBUTED_AMOUNT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(212165817958947992)
,p_prompt=>'Allocated'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trim(to_char(nvl(Sum(AMOUNT),0) , ''99,999,999,999.99'')) amount',
'from mission_distributions',
'where REQUEST_ID = :P19_REQUEST_ID;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12959735177762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(105736891072710)
,p_name=>'P19_AMOUNT_H'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(212165817958947992)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(106174309072710)
,p_name=>'P19_DISTRIBUTED_AMOUNT_H'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(212165817958947992)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(97307153315097478)
,p_name=>'P19_SELECTED_ROLE_ID'
,p_is_required=>true
,p_item_sequence=>75
,p_item_plug_id=>wwv_flow_api.id(110407419611350948)
,p_prompt=>'Role'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ROLE_NAME , ROLE_ID ',
'FROM ROLES',
'WHERE ROLE_ID IN (SELECT DISTINCT ROLE_ID -- , ROLE_DESC ',
'FROM mission_approval_history',
'WHERE 1=1',
'and ROLE_ID IN (96 , 73, 74, 81 ,82 , 140 , 106 ,93))',
'order by 1;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>3
,p_display_when=>'P19_ACTION'
,p_display_when2=>'ReturnAfter'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110398597497476406)
,p_name=>'P19_REQUEST_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(110407419611350948)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110398652477476407)
,p_name=>'P19_ACTION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(110407419611350948)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110398752174476408)
,p_name=>'P19_HISTORY_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(110407419611350948)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110398850284476409)
,p_name=>'P19_PERSON_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(110407419611350948)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110398900647476410)
,p_name=>'P19_ROLE_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(110407419611350948)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110399051050476411)
,p_name=>'P19_TO_PERSON_ID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(110407419611350948)
,p_prompt=>'Select Employee Name'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'EMPLOYEES DETAILS  RETURN PERSONID- POPUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT e.full_name_en , e.employee_num , e.email , e.person_id , e.department_name , user_details.get_emp_emirate(person_id) Emirate',
'FROM employees_v e',
'where CURRENT_FLAG = ''Y'''))
,p_lov_display_null=>'YES'
,p_cSize=>100
,p_grid_label_column_span=>3
,p_display_when=>':P19_ACTION in (''Delegate'' , ''ReturnAfter'')'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(12959859471762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(110399189495476412)
,p_name=>'P19_COMMENT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(110407419611350948)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>3
,p_grid_label_column_span=>3
,p_field_template=>wwv_flow_api.id(12959574866762159)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(110399610186476417)
,p_name=>'Cancel DA'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(110399538981476416)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(110399770662476418)
,p_event_id=>wwv_flow_api.id(110399610186476417)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(209952139530547)
,p_name=>'show allocation DA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P19_ALLOCATE_BY'
,p_condition_element=>'P19_ALLOCATE_BY'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'P'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(209867676530546)
,p_event_id=>wwv_flow_api.id(209952139530547)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(212431258775247347)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(209521756530543)
,p_event_id=>wwv_flow_api.id(209952139530547)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(212431309007247348)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(209762126530545)
,p_event_id=>wwv_flow_api.id(209952139530547)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(212431309007247348)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(209670206530544)
,p_event_id=>wwv_flow_api.id(209952139530547)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(212431258775247347)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(210022176530548)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'get History details'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select role_id , id ,',
'    trim(to_char(MISSION_UTIL.get_mission_amount(request_id),''99,999,999,999,999.99'')) || '' AED'' Amount,',
'    MISSION_UTIL.get_mission_amount(request_id),',
'    (select sum(l.amount) from mission_distributions l where l.REQUEST_ID = mission_approval_history.request_id) line_sum',
'into :P19_role_id, :P19_HISTORY_ID,',
'    :P19_AMOUNT,',
'    :P19_AMOUNT_H,',
'    :P19_DISTRIBUTED_AMOUNT_H',
'from mission_approval_history',
'where id = :P20_HISTORY_ID;',
'',
'Exception',
'when others',
'    then null;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(99304435201685824)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Approve Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P19_ROLE_ID = 73 and  :P19_AMOUNT_H != nvl(:P19_DISTRIBUTED_AMOUNT_H ,0)',
'        Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please allocate the mission amount on project level or GL Level. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'MISSION_WORKFLOW.APPROVE(:P19_REQUEST_ID, :PERSON_ID, :P19_COMMENT, ''S'');',
'',
'End if;',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(110398229324476403)
,p_process_success_message=>'Approved Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(99304555208685825)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reject Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'IF :P19_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Reject this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'MISSION_WORKFLOW.REJECT(:P19_REQUEST_ID, :PERSON_ID, :P19_COMMENT, ''S'');',
'',
'End if;',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(110398333832476404)
,p_process_success_message=>'Rejected Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(99304689394685826)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delegated Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Begin',
'IF :P19_TO_PERSON_ID  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please select the employee. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'',
'MISSION_WORKFLOW.DELEGATE(:P19_REQUEST_ID, :PERSON_ID, :P19_TO_PERSON_ID, :P19_COMMENT, ''S'');',
'',
'End if;',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(110398400050476405)
,p_process_success_message=>'Delegated Successfully.'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(99304779549685827)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Return Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P19_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Return this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'MISSION_WORKFLOW.RETURN(:P19_REQUEST_ID, :PERSON_ID, :P19_COMMENT, ''S'');',
'',
'End if;',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(110399204158476413)
,p_process_success_message=>'Returned Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(96257275076052840)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Return After Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'IF :P19_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Return this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'MISSION_WORKFLOW.RETURN_AFTER(:P19_REQUEST_ID, :P19_TO_PERSON_ID, :P19_COMMENT, ''S'' , :P19_SELECTED_ROLE_ID);',
'',
'End if;',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(96257179031052839)
,p_process_success_message=>'Returned Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3160033568269130)
,p_process_sequence=>60
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Withdraw Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'',
'    ',
'        IF :P19_COMMENT  is  null  Then ',
'    ',
'                    apex_error.add_error (  p_message          => ''Please tell us why you want to Withdraw this request. ''  ,',
'                                                                            p_display_location =>  apex_error.c_inline_with_field_and_notif',
'                                            );',
'        else',
'            MISSION_WORKFLOW.STOP(:P19_REQUEST_ID,:PERSON_ID,:P19_COMMENT, ''S'');',
'',
'         End if;',
'',
'',
'END;'))
,p_process_error_message=>'Not Withdrawal, Please contact system Admin.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(3159983326269129)
,p_process_success_message=>'Withdraw Successfully.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(209102949530539)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete From Line'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
' DELETE FROM mission_distributions',
'  WHERE ID =  apex_application.g_x01;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
