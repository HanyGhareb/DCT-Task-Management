prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>3
,p_user_interface_id=>wwv_flow_api.id(1686359760302353)
,p_name=>'User Organizations Access'
,p_alias=>'USER-ORGANIZATIONS-ACCESS'
,p_step_title=>'User Organizations Access'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200908110206'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2431909148556882)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1611180433302287)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(1547752126302241)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(1665264360302322)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2432583833556883)
,p_plug_name=>'User Organizations Access'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton'
,p_plug_template=>wwv_flow_api.id(1599843476302282)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.user_name ,e.employee_num , e.full_name_en , e.email  , xx.org_name',
'   , case when e.user_name is null Then ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/TCA0000''',
'           else ''https://ifinance.dct.gov.ae:8004/dct/prod/profile/view/'' || e.user_name',
'      end    Photo     ',
'from dct_employees_list2 e , (select USER_ID,  LISTAGG(org_name_en , ''/'') org_name',
'                                from (',
'                                        select acc.user_id ,  acc.entity_id , org.org_name_en',
'                                            from dct_hr_organizations org , DCT_DATA_ACCESS_ASSIGNMENT acc',
'                                            where org.org_id(+) = acc.entity_id )',
'                                            GROUP by USER_ID) xx',
'                                            ',
'where e.user_name = xx.user_id(+)',
'and e.current_flag = ''Y'''))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'User Organizations Access'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(2432699484556883)
,p_name=>'User Organizations Access'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y_OF_Z'
,p_pagination_display_pos=>'TOP_AND_BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>2432699484556883
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2439949090635407)
,p_db_column_name=>'USER_NAME'
,p_display_order=>10
,p_column_identifier=>'F'
,p_column_label=>'User Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2433068984556891)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>20
,p_column_identifier=>'A'
,p_column_label=>'Employee#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2433450906556894)
,p_db_column_name=>'FULL_NAME_EN'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Employee Name'
,p_column_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::P4_USERID,P4_USER_NAME:#USER_NAME#,#FULL_NAME_EN#'
,p_column_linktext=>'#FULL_NAME_EN#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2433825991556894)
,p_db_column_name=>'EMAIL'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Email'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2434258077556894)
,p_db_column_name=>'ORG_NAME'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Organizations'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1843347120558739)
,p_db_column_name=>'PHOTO'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Photo'
,p_column_html_expression=>'<img src="#PHOTO#" alt="Image Not Found" height="40" width="40">'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(2434827089557914)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'24349'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'USER_NAME:EMPLOYEE_NUM:FULL_NAME_EN:ORG_NAME:PHOTO:'
,p_sort_column_1=>'ORG_NAME'
,p_sort_direction_1=>'ASC'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4769681891894725)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P3_ROLE'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4769970571894728)
,p_name=>'New_1'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P3_CATEGORIES'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4770067797894729)
,p_event_id=>wwv_flow_api.id(4769970571894728)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_ROLE'
);
wwv_flow_api.component_end;
end;
/
