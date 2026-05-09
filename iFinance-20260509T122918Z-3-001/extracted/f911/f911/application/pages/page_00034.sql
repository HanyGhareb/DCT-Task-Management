prompt --application/pages/page_00034
begin
--   Manifest
--     PAGE: 00034
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
 p_id=>34
,p_user_interface_id=>wwv_flow_api.id(23921013981372477)
,p_name=>'Search and Select '
,p_alias=>'SEARCH-AND-SELECT'
,p_page_mode=>'MODAL'
,p_step_title=>'Search and Select '
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220814113442'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(115459928423660812)
,p_plug_name=>'Search and Select '
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(23834504913372554)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select apex_item.checkbox2(1,e.person_id) Selected,',
'        e.person_id , e.full_name_en, e.employee_num, e.email , e.department_name, e.sector , e.mobile,',
'        e.sf_emirates_id Emirates_ID  ,',
'    CASE',
'        WHEN dbms_lob.getlength(e.photo_blob) > 0 THEN',
'          ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || e.user_name',
'        ELSE',
'           ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA000''',
'    END PHOTO_hidden,',
'        null PHOTO',
'from employees_v e',
'where  e.CURRENT_FLAG = ''Y''',
'and e.person_id not in (select PERSON_ID from gift_cards_request_line_details where LINE_ID = :P33_LINE_ID and REQUEST_ID = :P33_ID)',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Search and Select '
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(115459872184660812)
,p_name=>'Search and Select '
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>104313724197237231
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115459440693660809)
,p_db_column_name=>'SELECTED'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Selected'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_format_mask=>'PCT_GRAPH:::'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115459041036660808)
,p_db_column_name=>'PERSON_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Person Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115458634387660808)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115458238073660808)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Employee No'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115457835695660808)
,p_db_column_name=>'EMAIL'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115457455356660808)
,p_db_column_name=>'DEPARTMENT_NAME'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115457001509660807)
,p_db_column_name=>'SECTOR'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115456630098660807)
,p_db_column_name=>'MOBILE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Mobile'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115456285486660807)
,p_db_column_name=>'PHOTO_HIDDEN'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Photo Hidden'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(115455842627660807)
,p_db_column_name=>'PHOTO'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Photo'
,p_column_html_expression=>'<image src=''#PHOTO_HIDDEN#'' width=75 height=75>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(97231804000265938)
,p_db_column_name=>'EMIRATES_ID'
,p_display_order=>20
,p_column_identifier=>'K'
,p_column_label=>'Emirates Id'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(115454839988653146)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1043188'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SELECTED:PHOTO:FULL_NAME_EN:EMPLOYEE_NUM:EMAIL:SECTOR:MOBILE::EMIRATES_ID'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(115451695940635117)
,p_report_id=>wwv_flow_api.id(115454839988653146)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'FULL_NAME_EN'
,p_operator=>'contains'
,p_expr=>'Han'
,p_condition_sql=>'upper("FULL_NAME_EN") like ''%''||upper(#APXWS_EXPR#)||''%'''
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''Han''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(115479533776734926)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(115459928423660812)
,p_button_name=>'Add'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Add'
,p_button_position=>'TOP'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(115479023704734921)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(115459928423660812)
,p_button_name=>'Close'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(23898673468372508)
,p_button_image_alt=>'Close'
,p_button_position=>'TOP'
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(115478631039734917)
,p_branch_name=>'Go to 33'
,p_branch_action=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(115479303787734924)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add Employees'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_count                 NUMBER := apex_application.g_f01.count;',
'    l_selected_count        number;',
'begin',
'    select count(*)    into l_selected_count',
'    from gift_cards_request_line_details',
'    where request_id = :P33_ID and line_id = :P33_LINE_ID;',
'    ',
'     IF l_count = 0 THEN',
'                            apex_error.add_error(p_message => ''Please select at least one employee! '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'                    elsif  l_selected_count + l_count > :P33_CONTROL_COUNT    ',
'                        Then',
'                             apex_error.add_error(p_message => ''you have exceed the total employees. '',',
'                                        p_display_location => apex_error.c_inline_with_field_and_notif);',
'                            ',
'                    ELSIF l_count > 0 THEN',
'                            FOR i IN 1..l_count ',
'                                          LOOP',
'                                              INSERT INTO gift_cards_request_line_details (',
'                                                                                        request_id,',
'                                                                                        line_id,',
'                                                                                       GIFT_CARDS_CATEGORY_ID,   ',
'                                                                                        person_title,',
'                                                                                        person_id,',
'                                                                                        full_name_en,',
'                                                                                        email,',
'                                                                                        emirated_id,',
'                                                                                        mobile_number',
'                                                                                    ) select',
'                                                                                      :P33_ID,',
'                                                                                      :P33_LINE_ID,',
'                                                                                      :P33_GIFT_CARDS_CATEGORY_ID,',
'                                                                                      e.title  , ',
'                                                                                      e.person_id , ',
'                                                                                      e.full_name_en, ',
'                                                                                      e.email , ',
'                                                                                      e.national_identifier , ',
'                                                                                      e.mobile ',
'                                                                                    from employees_v e',
'                                                                                    where e.person_id = to_number(apex_application.g_f01(i));',
'                                          END LOOP;',
'                                           ',
'       ',
'                  End If;                                                                                     ',
'',
'End;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(115479533776734926)
);
wwv_flow_api.component_end;
end;
/
