prompt --application/pages/page_00054
begin
--   Manifest
--     PAGE: 00054
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>54
,p_user_interface_id=>wwv_flow_api.id(127888401519449706)
,p_name=>'Adding from Template Component Defaults'
,p_alias=>'ADDING-FROM-TEMPLATE-COMPONENT-DEFAULTS'
,p_page_mode=>'MODAL'
,p_step_title=>'Adding from Template Component Defaults'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20230122114428'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141326847900938543)
,p_plug_name=>'Select and Add'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(141327283093938547)
,p_plug_name=>'Available Samples'
,p_parent_plug_id=>wwv_flow_api.id(141326847900938543)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--showIcon:t-Region--accent14:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(127803777897449779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select apex_item.checkbox2(1,ID ) Selected ,',
'       APEX_ITEM.TEXTAREA(2,DEFAULT_TEXT,1,200) DEFAULT_TEXT,',
'       NOTES,',
'       APPENDIX_ID',
'  from DP_SCOPING_DEFAULT',
' where TEMPLATE_ID = :P54_TEMPLATE_ID',
' and APPENDIX_ID = :P54_APPENDIX_ID',
' and COMPONENT_ID = :P54_COMPOENET_ID;'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P54_TEMPLATE_ID,P54_APPENDIX_ID,P54_COMPOENET_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Available Samples'
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
 p_id=>wwv_flow_api.id(141585784764161511)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No Samples Available'
,p_show_search_textbox=>'N'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>141585784764161511
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141585864206161512)
,p_db_column_name=>'SELECTED'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Selected'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141586451526161518)
,p_db_column_name=>'DEFAULT_TEXT'
,p_display_order=>20
,p_column_identifier=>'F'
,p_column_label=>'Default Text'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141586108496161515)
,p_db_column_name=>'NOTES'
,p_display_order=>30
,p_column_identifier=>'D'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(141586231898161516)
,p_db_column_name=>'APPENDIX_ID'
,p_display_order=>40
,p_column_identifier=>'E'
,p_column_label=>'Appendix Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(141610240613929463)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1416103'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SELECTED:DEFAULT_TEXT:'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(141586720095161521)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(141327283093938547)
,p_button_name=>'Add_selected'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(127866064712449732)
,p_button_image_alt=>'Add Selected'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_icon_css_classes=>'fa-cart-plus'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(141587214791161526)
,p_branch_name=>'Go To 29'
,p_branch_action=>'f?p=&APP_ID.:29:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141326934052938544)
,p_name=>'P54_TEMPLATE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(141326847900938543)
,p_use_cache_before_default=>'NO'
,p_prompt=>'P54_TEMPLATE_ID'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141327051405938545)
,p_name=>'P54_TEMPLATE_COMPOENET_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(141326847900938543)
,p_use_cache_before_default=>'NO'
,p_prompt=>'P54_TEMPLATE_COMPOENET_ID'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141327146006938546)
,p_name=>'P54_APPENDIX_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(141326847900938543)
,p_use_cache_before_default=>'NO'
,p_prompt=>'P54_APPENDIX_ID'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141587038752161524)
,p_name=>'P54_ITEM_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(141326847900938543)
,p_use_cache_before_default=>'NO'
,p_prompt=>'P54_ITEM_ID'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(141587168662161525)
,p_name=>'P54_COMPOENET_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(141326847900938543)
,p_use_cache_before_default=>'NO'
,p_prompt=>'P54_COMPOENET_ID'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_api.id(127864612454449733)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(141586906814161523)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add Selected Rows Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'l_total                 Number;',
'l_count                 NUMBER := apex_application.g_f01.count;',
'',
'Begin',
'-- get total rows',
'select count(*) ',
'into l_total',
'from DP_SCOPING_DEFAULT',
' where TEMPLATE_ID = :P54_TEMPLATE_ID',
' and APPENDIX_ID = :P54_APPENDIX_ID',
' and COMPONENT_ID = :P54_COMPOENET_ID;',
'',
'',
'',
'-- check selected Rows ',
'  IF l_count = 0 THEN',
'                    apex_error.add_error(p_message => ''Please select at least one record! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'  else',
'',
'      FOR i IN 1..l_total LOOP',
'                        -- insert selected line    ',
'                INSERT INTO testh (    ss,',
'                                   ID) ',
'                        values( ',
'                               apex_application.g_f02(i),',
'                              apex_application.g_f01(i)',
'                            )',
'                        --from DP_SCOPING_DEFAULT',
'                        --where  apex_application.g_f01(i) is not null ',
'                        ;',
'        ',
'      END LOOP;',
'End if;',
'EXCEPTION',
'      WHEN no_data_found THEN',
'        NULL;',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(141586720095161521)
);
wwv_flow_api.component_end;
end;
/
