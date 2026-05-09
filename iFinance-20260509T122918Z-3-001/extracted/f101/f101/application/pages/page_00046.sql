prompt --application/pages/page_00046
begin
--   Manifest
--     PAGE: 00046
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
 p_id=>46
,p_user_interface_id=>wwv_flow_api.id(8142494873175551)
,p_name=>'Petty Cash Vouchers'
,p_alias=>'PETTY-CASH-VOUCHERS'
,p_step_title=>'Petty Cash Vouchers'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210424201553'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1367962778468361)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8067277693175509)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(8003821207175482)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(8121335853175533)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(1367309132468362)
,p_plug_name=>'Petty Cash Vouchers'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(8055912915175506)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select VENDOR_SITE_CODE Employee_Num,',
'        (Select full_name_en',
'         from employees_v',
'        where employee_num = VENDOR_SITE_CODE) Name,',
'       CREATION_DATE,',
'       BATCH_NAME,',
'       VOUCHER_NUM,',
'       INVOICE_NUM,',
'       DESCRIPTION,',
'       INVOICE_TYPE,',
'       INVOICE_DATE,',
'       GL_DATE,',
'       APPROVAL_STATUS,',
'       INVOICE_VALIDATION,',
'       CREATED_BY,',
'       LAST_UPDATED_BY,',
'       LAST_UPDATE_DATE,',
'       PAYMENT_BY,',
'       PAYMENT_DATE,',
'       AMOUNT_PAID,',
'       INVOICE_AMOUNT,',
'       PAY_GROUP,',
'       CHECK_NUMBER',
'  from HRSS_PETTY_CASH_INVOICES'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'Petty Cash Vouchers'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(1367210242468362)
,p_name=>'Petty Cash Vouchers'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>31324887993994152
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1366528270468366)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1366158615468366)
,p_db_column_name=>'BATCH_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Batch Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1365712961468367)
,p_db_column_name=>'VOUCHER_NUM'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Voucher Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1365328355468367)
,p_db_column_name=>'INVOICE_NUM'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Invoice Num'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1364961148468367)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Description'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1364583931468367)
,p_db_column_name=>'INVOICE_TYPE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Invoice Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1364163327468368)
,p_db_column_name=>'INVOICE_DATE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Invoice Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1363763714468368)
,p_db_column_name=>'GL_DATE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Gl Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1363312907468368)
,p_db_column_name=>'APPROVAL_STATUS'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Approval Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1362956223468368)
,p_db_column_name=>'INVOICE_VALIDATION'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Invoice Validation'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1362514250468369)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1362099060468369)
,p_db_column_name=>'LAST_UPDATED_BY'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Last Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1361730619468369)
,p_db_column_name=>'LAST_UPDATE_DATE'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Last Update Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1361309552468369)
,p_db_column_name=>'PAYMENT_BY'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Payment By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1360915034468369)
,p_db_column_name=>'PAYMENT_DATE'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Payment Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1360538173468370)
,p_db_column_name=>'AMOUNT_PAID'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Amount Paid'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1360119129468370)
,p_db_column_name=>'INVOICE_AMOUNT'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Invoice Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1359747734468370)
,p_db_column_name=>'PAY_GROUP'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Pay Group'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1359338058468370)
,p_db_column_name=>'CHECK_NUMBER'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Check Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1549541070249085)
,p_db_column_name=>'EMPLOYEE_NUM'
,p_display_order=>30
,p_column_identifier=>'U'
,p_column_label=>'Employee Num'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(1549464540249084)
,p_db_column_name=>'NAME'
,p_display_order=>40
,p_column_identifier=>'V'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(1358723041469570)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'313334'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CREATION_DATE:BATCH_VOUCHER_NUM:INVOICE_NUM:DESCRIPTION:INVOICE_TYPE:INVOICE_DATE:GL_DATE:APPROVAL_STATUS:INVOICE_VALIDATION:CREATED_BY:LAST_UPDATED_BY:LAST_UPDATE_DATE:PAYMENT_BY:PAYMENT_DATE:AMOUNT_PAID:INVOICE_AMOUNT:PAY_GROUP:CHECK_NUMBER:EMPLOYE'
||'E_NUM:NAME'
);
wwv_flow_api.component_end;
end;
/
