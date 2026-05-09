prompt --application/pages/page_00035
begin
--   Manifest
--     PAGE: 00035
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>35
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'CWIP Contracts'
,p_alias=>'CWIP-CONTRACTS'
,p_step_title=>'CWIP Contracts'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220928065901'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(31534615473738540)
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
 p_id=>wwv_flow_api.id(31535238372738540)
,p_plug_name=>'CWIP Contracts'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    contract_number,',
'    contract_description,',
'    contract_amount,',
'    billed_amount,',
'    initial_contract_amount,',
'    contract_variation_amount,',
'    vendor_name,',
'    vendor_site_code,',
'    contract_type,',
'    contract_mode,',
'    attribute_category,',
'    buyer_name,',
'    approved_flag,',
'    approved_date,',
'    billing_status,',
'    start_date,',
'    end_date,',
'    contract_days,',
'    currency_code,',
'    cancel_flag,',
'    closed_code,',
'    contract_admin,',
'    creation_date,',
'    last_update_date,',
'    created_by,',
'    created_on,',
'    updated_by,',
'    updated_on,',
'    vendor_number,',
'    contract_title,',
'    c.dct_contract_code,',
'    c.contract_reference,',
'    c.dct_cost_type,',
'    (select cp.project_number',
'    from cwip_contract_projects CP',
'    where cp.contract_number = c.contract_number',
'    and ROWNUM = 1) project_number',
'from cwip_contract c',
'where c.contract_number in ',
'(SELECT',
'    contract_number',
'--    ,project_number,',
'--    task_number,',
'--    expenditure_type,',
'--    contract_amount,',
'--    billed_amount',
'FROM',
'    cwip_contract_projects',
'where ',
'',
'project_number in ( select PROJECT_NUMBER',
'                          from CWIP_TEAM',
'                         where 1=1',
'                         and role_id in (Select r.role_id from project_role r where r.category_id = 2)',
'                         and status = ''A''',
'                         and sysdate BETWEEN nvl(start_date , sysdate -1) and nvl(end_date, sysdate +10)',
'                         and person_type = ''INT''',
'                         and person_id = :PERSON_ID)',
'OR project_number in (select x.project_number ',
'from project x',
'where project_type = ''Capital''',
'and  exists (select 1 ',
'            from cwip_team',
'            where cwip_team.person_id = :PERSON_ID',
'            and cwip_team.project_number is null) )    ',
'or project_number in (select x.project_number',
'                        from project x',
'                        where :PERSON_ID = 680461 )',
' )',
'order by CONTRACT_NUMBER'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'CWIP Contracts'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(31535389876738540)
,p_name=>'CWIP Contracts'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>31535389876738540
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31535750032738537)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Contract Number'
,p_column_link=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.::P24_CONTRACT_NUMBER,P24_PROJECT_NUMBER,P24_PAGE_FROM:#CONTRACT_NUMBER#,#PROJECT_NUMBER#,35'
,p_column_linktext=>'#CONTRACT_NUMBER#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31536121710738535)
,p_db_column_name=>'CONTRACT_DESCRIPTION'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Description'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31536520112738535)
,p_db_column_name=>'CONTRACT_AMOUNT'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Contract Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31536946440738535)
,p_db_column_name=>'BILLED_AMOUNT'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Billed Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31537345515738535)
,p_db_column_name=>'INITIAL_CONTRACT_AMOUNT'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Initial Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31537705145738534)
,p_db_column_name=>'CONTRACT_VARIATION_AMOUNT'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Variation Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31538144370738534)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Vendor Name'
,p_column_link=>'f?p=&APP_ID.:66:&SESSION.::&DEBUG.::P66_VENDOR_NUMBER,P66_VENDOR_NAME,P66_VENDOR_SITE_CODE:#VENDOR_NUMBER#,#VENDOR_NAME#,#VENDOR_SITE_CODE#'
,p_column_linktext=>'#VENDOR_NAME#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31538543868738534)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Vendor Site'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31538996784738534)
,p_db_column_name=>'CONTRACT_TYPE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Contract Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31539335948738533)
,p_db_column_name=>'CONTRACT_MODE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Contract Mode'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31539722343738533)
,p_db_column_name=>'ATTRIBUTE_CATEGORY'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Attribute Category'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31540159655738533)
,p_db_column_name=>'BUYER_NAME'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Buyer '
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31540529974738532)
,p_db_column_name=>'APPROVED_FLAG'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Approved'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(10893109140999643)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31540951415738532)
,p_db_column_name=>'APPROVED_DATE'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Approved Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31541381887738532)
,p_db_column_name=>'BILLING_STATUS'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Billing Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31541796090738531)
,p_db_column_name=>'START_DATE'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31542190358738531)
,p_db_column_name=>'END_DATE'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31542552441738531)
,p_db_column_name=>'CONTRACT_DAYS'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Contract Days'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31542911517738530)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Currency'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31543303489738530)
,p_db_column_name=>'CANCEL_FLAG'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Cancel ?'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_rpt_named_lov=>wwv_flow_api.id(10893109140999643)
,p_rpt_show_filter_lov=>'1'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31543798026738530)
,p_db_column_name=>'CLOSED_CODE'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Closed Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31544136109738530)
,p_db_column_name=>'CONTRACT_ADMIN'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Contract Admin'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31544910783738529)
,p_db_column_name=>'LAST_UPDATE_DATE'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Last Update Date'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31545768921738528)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31546575839738528)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH:MIPM'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31546946851738528)
,p_db_column_name=>'VENDOR_NUMBER'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Vendor Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31547314355738527)
,p_db_column_name=>'CONTRACT_TITLE'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Contract Title'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31890075347194102)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>40
,p_column_identifier=>'AE'
,p_column_label=>'Creation Date'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(31890175607194103)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>50
,p_column_identifier=>'AF'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(258695494010541)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'AG'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(258768402010542)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>70
,p_column_identifier=>'AH'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(258946272010543)
,p_db_column_name=>'DCT_CONTRACT_CODE'
,p_display_order=>80
,p_column_identifier=>'AI'
,p_column_label=>'DCT Contract Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(258988624010544)
,p_db_column_name=>'CONTRACT_REFERENCE'
,p_display_order=>90
,p_column_identifier=>'AJ'
,p_column_label=>'Contract Reference'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(259115162010545)
,p_db_column_name=>'DCT_COST_TYPE'
,p_display_order=>100
,p_column_identifier=>'AK'
,p_column_label=>'Cost Type'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(31549628996692873)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'315497'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>25
,p_report_columns=>'CONTRACT_NUMBER:CONTRACT_REFERENCE:VENDOR_NAME:VENDOR_SITE_CODE:INITIAL_CONTRACT_AMOUNT:CONTRACT_AMOUNT:BILLED_AMOUNT:CONTRACT_VARIATION_AMOUNT:CONTRACT_TYPE:CONTRACT_MODE:BUYER_NAME:START_DATE:'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'CONTRACT_NUMBER'
,p_sort_direction_2=>'DESC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.component_end;
end;
/
