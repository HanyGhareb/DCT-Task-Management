prompt --application/pages/page_00054
begin
--   Manifest
--     PAGE: 00054
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>54
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'XX-RPA'
,p_alias=>'XX-RPA'
,p_step_title=>'XX-RPA'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210710193530'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(1637983321090373)
,p_name=>'Report 1'
,p_template=>wwv_flow_api.id(8057862405175507)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'--    petty_cash_type,',
'    pc.employee_num,',
'    (select v.vendor_name',
'    from employee_vendors v',
'    where v.employee_number =pc.employee_num ',
'    and v.vendor_name like ''FAB DEBIT CARD%'') vendor_name,',
'    ''ABU DHABI''                                 vendor_site,',
'    petty_cash_date                             invoice_date,',
'    petty_cash_date                             invoice_Received_date,',
'    sysdate                                     gl_date,',
'    petty_cash_no                               invoice_num,',
'    amount                                      invoice_amount,',
'    ''WIRE''                                       Pay_method,',
'    decode(petty_cash_type,''T'',''Temporary'',''Permanent'')  ',
'    || '' Petty Cash,For Emp#''',
'    || pc.employee_num',
'    || ''. ''',
'    || justification                                 AS description,',
'    (select v.bank_account_name',
'    from employee_vendors v',
'    where v.employee_number =pc.employee_num ',
'    and v.vendor_name like ''FAB DEBIT CARD%'') AS Bank_account_name,      ',
'    project_number,',
'    task,',
'    amount,',
'    gl_account,',
'    (select ''451.'' || t.COST_CENTER ||''.'' || BUDGET_GROUP_CODE || ''.''',
'    from task t',
'    where t.TASK_NUMBER = pc.task',
'    and ROWNUM = 1)',
'    || nvl(pc.gl_account,''XXXXXX'')',
'    || (select ''.'' ||t.ACTIVITY ||''.'' || FUTURE1 ||''.'' || FUTURE2',
'        from task t',
'        where t.TASK_NUMBER =  pc.task',
'        and ROWNUM = 1)                         distribution',
'FROM',
'    hrss_petty_cash pc , dct_employees_list2 e',
'where pc.employee_num = e.employee_num (+)',
'and approval_status = ''Approved''',
'and pending_with_ap = ''Y''',
'and pc.employee_num in (210, 187)',
'--and petty_cash_type = nvl(:P15_TYPE , petty_Cash_type)',
''))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(8084165237175515)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'no data found'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_query_row_count_max=>500
,p_csv_output=>'Y'
,p_csv_output_link_text=>'Download'
,p_prn_output=>'N'
,p_prn_format=>'PDF'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(31591574427340364)
,p_query_column_id=>1
,p_column_alias=>'EMPLOYEE_NUM'
,p_column_display_sequence=>16
,p_column_heading=>'Employee Num'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(1638766884090368)
,p_query_column_id=>2
,p_column_alias=>'VENDOR_NAME'
,p_column_display_sequence=>1
,p_column_heading=>'Vendor Name'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(1639111817090368)
,p_query_column_id=>3
,p_column_alias=>'VENDOR_SITE'
,p_column_display_sequence=>2
,p_column_heading=>'Vendor Site'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(1639592957090367)
,p_query_column_id=>4
,p_column_alias=>'INVOICE_DATE'
,p_column_display_sequence=>3
,p_column_heading=>'Invoice Date'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(1639927315090367)
,p_query_column_id=>5
,p_column_alias=>'INVOICE_RECEIVED_DATE'
,p_column_display_sequence=>4
,p_column_heading=>'Invoice Received Date'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(1640322480090367)
,p_query_column_id=>6
,p_column_alias=>'GL_DATE'
,p_column_display_sequence=>5
,p_column_heading=>'Gl Date'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(1640772883090367)
,p_query_column_id=>7
,p_column_alias=>'INVOICE_NUM'
,p_column_display_sequence=>6
,p_column_heading=>'Invoice Num'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(1641146954090366)
,p_query_column_id=>8
,p_column_alias=>'INVOICE_AMOUNT'
,p_column_display_sequence=>7
,p_column_heading=>'Invoice Amount'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(1641597384090366)
,p_query_column_id=>9
,p_column_alias=>'PAY_METHOD'
,p_column_display_sequence=>8
,p_column_heading=>'Pay Method'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(1641913085090366)
,p_query_column_id=>10
,p_column_alias=>'DESCRIPTION'
,p_column_display_sequence=>9
,p_column_heading=>'Description'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(1642347495090365)
,p_query_column_id=>11
,p_column_alias=>'BANK_ACCOUNT_NAME'
,p_column_display_sequence=>10
,p_column_heading=>'Bank Account Name'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(1642759760090365)
,p_query_column_id=>12
,p_column_alias=>'PROJECT_NUMBER'
,p_column_display_sequence=>11
,p_column_heading=>'Project Number'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(1643115975090365)
,p_query_column_id=>13
,p_column_alias=>'TASK'
,p_column_display_sequence=>12
,p_column_heading=>'Task'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(1643542892090364)
,p_query_column_id=>14
,p_column_alias=>'AMOUNT'
,p_column_display_sequence=>13
,p_column_heading=>'Amount'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(1643919496090364)
,p_query_column_id=>15
,p_column_alias=>'GL_ACCOUNT'
,p_column_display_sequence=>14
,p_column_heading=>'Gl Account'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(1644365630090363)
,p_query_column_id=>16
,p_column_alias=>'DISTRIBUTION'
,p_column_display_sequence=>15
,p_column_heading=>'Distribution'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.component_end;
end;
/
