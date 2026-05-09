prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_page(
 p_id=>2
,p_user_interface_id=>wwv_flow_api.id(11217697745956116)
,p_name=>'My Contracts'
,p_alias=>'MY-CONTRACTS'
,p_step_title=>'My Contracts'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_deep_linking=>'Y'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>To find data enter a search term into the search dialog, or click on the column headings to limit the records returned.</p>',
'',
'<p>You can perform numerous functions by clicking the <strong>Actions</strong> button. This includes selecting the columns that are displayed / hidden and their display sequence, plus numerous data and format functions.  You can also define additiona'
||'l views of the data using the chart, group by, and pivot options.</p>',
'',
'<p>If you want to save your customizations select report, or click download to unload the data. Enter you email address and time frame under subscription to be sent the data on a regular basis.<p>',
'',
'<p>For additional information click Help at the bottom of the Actions menu.</p> ',
'',
'<p>Click the <strong>Reset</strong> button to reset the interactive report back to the default settings.</p>'))
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20220122103844'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11235535539956166)
,p_plug_name=>'Cwip Contracts'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(11131192505956047)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct CONTRACT_NUMBER, PROJECT_NUMBERS, CONTRACT_DESCRIPTION, CONTRACT_TITLE, CONTRACT_AMOUNT, BILLED_AMOUNT, INITIAL_CONTRACT_AMOUNT, CONTRACT_VARIATION_AMOUNT, VENDOR_NUMBER, VENDOR_NAME, VENDOR_SITE_CODE, CONTRACT_TYPE, CONTRACT_MODE, AT'
||'TRIBUTE_CATEGORY, BUYER_NAME, APPROVED_FLAG, APPROVED_DATE, BILLING_STATUS, START_DATE, END_DATE, CONTRACT_DAYS, CURRENCY_CODE, CANCEL_FLAG, CLOSED_CODE, CONTRACT_ADMIN, CREATION_DATE, LAST_UPDATE_DATE, CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON,'
||' RECOMMENDATION_PAYMENTS_COUNT, INVOICES_COUNT',
'from (',
'-- get all Recommendation payment for all contract for VENDOR assigned to EXT user',
'--SELECT',
'--    c.contract_number,',
'--    cp.project_numbers,',
'--    c.contract_description,',
'--    c.contract_title    ,',
'--    c.contract_amount,',
'--    c.billed_amount,',
'--    c.initial_contract_amount,',
'--    nvl(c.contract_variation_amount,0) contract_variation_amount,',
'--    c.vendor_number,',
'--    c.vendor_name,',
'--    c.vendor_site_code,',
'--    c.contract_type,',
'--    c.contract_mode,',
'--    c.attribute_category,',
'--    c.buyer_name,',
'--    c.approved_flag,',
'--    c.approved_date,',
'--    c.billing_status,',
'--    c.start_date,',
'--    c.end_date,',
'--    c.contract_days,',
'--    c.currency_code,',
'--    c.cancel_flag,',
'--    c.closed_code,',
'--    c.contract_admin,',
'--    c.creation_date,',
'--    c.last_update_date,',
'--    c.created_by,',
'--    c.created_on,',
'--    c.updated_by,',
'--    c.updated_on',
'--  -- project Contract Details',
'----  ,cp.project_number',
'--  ',
'----  -- Analytic Details',
'--  ,(select count(rec.payment_recommendation_id)  ',
'--    from cwip_payment_recommendation rec',
'--    where rec.contract_number = c.contract_number) RECOMMENDATION_PAYMENTS_COUNT,',
'--    ',
'--  (select count(distinct inv.voucher_number)  ',
'--    from cwip_contract_invoices inv',
'--    where inv.contract_number = c.contract_number) INVOICES_COUNT  ',
'--FROM',
'--    cwip_contract c ',
'--    ,(select c.contract_number , LISTAGG(DISTINCT cp.project_number, '', '') WITHIN GROUP (ORDER BY cp.project_number) project_numbers',
'--        from cwip_contract c , cwip_contract_projects cp',
'--        where  c.contract_number = cp.contract_number ',
'--        group by c.contract_number) cp',
'--WHERE c.contract_number = cp.contract_number',
'--and (vendor_number , vendor_site_code) in (select u.vendor_number ,u.vendor_site_code',
'--                                                from dct_ext_users u',
'--                                                where u.user_id = :PERSON_ID )',
'--Union ALL',
'',
'-- get all Recommendation payment for all contract for the project assigned to EXT user without specific contract',
'SELECT',
'    c.contract_number,',
'    cp.project_numbers,',
'    c.contract_description,',
'    c.contract_title    ,',
' --    c.contract_amount,',
'    c.initial_contract_amount + nvl(c.contract_variation_amount,0)   contract_amount,',
'    c.billed_amount,',
'    c.initial_contract_amount,',
'    nvl(c.contract_variation_amount,0) contract_variation_amount,',
'    c.vendor_number,',
'    c.vendor_name,',
'    c.vendor_site_code,',
'    c.contract_type,',
'    c.contract_mode,',
'    c.attribute_category,',
'    c.buyer_name,',
'    c.approved_flag,',
'    c.approved_date,',
'    c.billing_status,',
'    c.start_date,',
'    c.end_date,',
'    c.contract_days,',
'    c.currency_code,',
'    c.cancel_flag,',
'    c.closed_code,',
'    c.contract_admin,',
'    c.creation_date,',
'    c.last_update_date,',
'    c.created_by,',
'    c.created_on,',
'    c.updated_by,',
'    c.updated_on',
'  -- project Contract Details',
'--  ,cp.project_number',
'  ',
'--  -- Analytic Details',
'  ,(select count(rec.payment_recommendation_id)  ',
'    from cwip_payment_recommendation rec',
'    where rec.contract_number = c.contract_number) RECOMMENDATION_PAYMENTS_COUNT,',
'    ',
'  (select count(distinct inv.voucher_number)  ',
'    from cwip_contract_invoices inv',
'    where inv.contract_number = c.contract_number) INVOICES_COUNT  ',
'FROM',
'    cwip_contract c ',
'    ,(select c.contract_number , LISTAGG(DISTINCT cp.project_number, '', '') WITHIN GROUP (ORDER BY cp.project_number) project_numbers',
'        from cwip_contract c , cwip_contract_projects cp',
'        where  c.contract_number = cp.contract_number ',
'        group by c.contract_number) cp',
'WHERE c.contract_number = cp.contract_number',
'and c.contract_number in (select distinct contract_number',
'                         from cwip_contract_projects',
'                         where project_number in',
'                                                (select  distinct project_number',
'                                                  from CWIP_TEAM',
'                                                  where person_id = :PERSON_ID',
'                                                  and contract_number is null',
'                                                  and status = ''A''',
'                                                  and sysdate BETWEEN nvl(start_date, sysdate -10) ',
'                                                                and nvl(end_date, sysdate + 100))',
'                         )',
'Union ALL',
'',
'-- get all Recommendation payment for specific contract assigned to EXT user ',
'SELECT',
'    c.contract_number,',
'    cp.project_numbers,',
'    c.contract_description,',
'    c.contract_title    ,',
'     --    c.contract_amount,',
'    c.initial_contract_amount + nvl(c.contract_variation_amount,0)   contract_amount,',
'    c.billed_amount,',
'    c.initial_contract_amount,',
'    nvl(c.contract_variation_amount,0) contract_variation_amount,',
'    c.vendor_number,',
'    c.vendor_name,',
'    c.vendor_site_code,',
'    c.contract_type,',
'    c.contract_mode,',
'    c.attribute_category,',
'    c.buyer_name,',
'    c.approved_flag,',
'    c.approved_date,',
'    c.billing_status,',
'    c.start_date,',
'    c.end_date,',
'    c.contract_days,',
'    c.currency_code,',
'    c.cancel_flag,',
'    c.closed_code,',
'    c.contract_admin,',
'    c.creation_date,',
'    c.last_update_date,',
'    c.created_by,',
'    c.created_on,',
'    c.updated_by,',
'    c.updated_on',
'  -- project Contract Details',
'--  ,cp.project_number',
'  ',
'--  -- Analytic Details',
'  ,(select count(rec.payment_recommendation_id)  ',
'    from cwip_payment_recommendation rec',
'    where rec.contract_number = c.contract_number) RECOMMENDATION_PAYMENTS_COUNT,',
'    ',
'  (select count(distinct inv.voucher_number)  ',
'    from cwip_contract_invoices inv',
'    where inv.contract_number = c.contract_number) INVOICES_COUNT  ',
'FROM',
'    cwip_contract c ',
'    ,(select c.contract_number , LISTAGG(DISTINCT cp.project_number, '', '') WITHIN GROUP (ORDER BY cp.project_number) project_numbers',
'        from cwip_contract c , cwip_contract_projects cp',
'        where  c.contract_number = cp.contract_number ',
'        group by c.contract_number) cp',
'WHERE c.contract_number = cp.contract_number',
'and c.contract_number in (select  Contract_number',
'                          from CWIP_TEAM',
'                          where person_id = :PERSON_ID',
'                          and contract_number is not null',
'                          and status = ''A''',
'                          and sysdate BETWEEN nvl(start_date, sysdate -10) ',
'                                    and nvl(end_date, sysdate + 100)',
'                         )',
') order by project_numbers ,contract_number  ; '))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A3'
,p_prn_width=>420
,p_prn_height=>297
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Contracts'
,p_prn_page_header_font_color=>'#196332'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer=>'Printed by i-finance CWIP Payments Stakeholders (DCT) on &CURRENT_DATE.'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'10'
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
,p_prn_border_color=>'#0E5735'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(11235618620956166)
,p_name=>'My Contracts'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>11235618620956166
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11236015584956171)
,p_db_column_name=>'CONTRACT_NUMBER'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Contract Number'
,p_column_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P3_CONTRACT_NUMBER:#CONTRACT_NUMBER#'
,p_column_linktext=>'#CONTRACT_NUMBER#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11236402142956172)
,p_db_column_name=>'CONTRACT_DESCRIPTION'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Contract Description'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11236885059956173)
,p_db_column_name=>'CONTRACT_AMOUNT'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Contract Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'99G999G999G999G999G999G999G999G999G999G990'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11237290804956173)
,p_db_column_name=>'BILLED_AMOUNT'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Billed Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'99G999G999G999G999G999G999G999G999G999G990'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11237621408956174)
,p_db_column_name=>'INITIAL_CONTRACT_AMOUNT'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Initial Contract Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'99G999G999G999G999G999G999G999G999G999G990'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11238035949956174)
,p_db_column_name=>'CONTRACT_VARIATION_AMOUNT'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Contract Variation Amount'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'99G999G999G999G999G999G999G999G999G999G990'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11238442802956174)
,p_db_column_name=>'VENDOR_NUMBER'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Vendor Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11238873182956175)
,p_db_column_name=>'VENDOR_NAME'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Vendor Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11239231901956175)
,p_db_column_name=>'VENDOR_SITE_CODE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Vendor Site Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11239600384956175)
,p_db_column_name=>'CONTRACT_TYPE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Contract Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11240034841956176)
,p_db_column_name=>'CONTRACT_MODE'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Contract Mode'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11240447307956176)
,p_db_column_name=>'ATTRIBUTE_CATEGORY'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Attribute Category'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11240890458956176)
,p_db_column_name=>'BUYER_NAME'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Buyer Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11241292107956176)
,p_db_column_name=>'APPROVED_FLAG'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Approved Flag'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11241693030956177)
,p_db_column_name=>'APPROVED_DATE'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Approved Date'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11242013117956177)
,p_db_column_name=>'BILLING_STATUS'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Billing Status'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11242442725956177)
,p_db_column_name=>'START_DATE'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11242812821956177)
,p_db_column_name=>'END_DATE'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11243241063956178)
,p_db_column_name=>'CONTRACT_DAYS'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Contract Days'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11243605481956178)
,p_db_column_name=>'CURRENCY_CODE'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Currency Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11244034938956178)
,p_db_column_name=>'CANCEL_FLAG'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Cancel Flag'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11244459176956178)
,p_db_column_name=>'CLOSED_CODE'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Closed Code'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11244846032956179)
,p_db_column_name=>'CONTRACT_ADMIN'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'Contract Admin'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11245288641956179)
,p_db_column_name=>'CREATION_DATE'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Creation Date'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11245603631956179)
,p_db_column_name=>'LAST_UPDATE_DATE'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Last Update Date'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11246410546956179)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11247225808956180)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11056445512190004)
,p_db_column_name=>'RECOMMENDATION_PAYMENTS_COUNT'
,p_display_order=>77
,p_column_identifier=>'BG'
,p_column_label=>'Payments Applications'
,p_column_link=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_CONTRACT_NUMBER,P12_SHOW_REPORT:#CONTRACT_NUMBER#,REC'
,p_column_linktext=>'#RECOMMENDATION_PAYMENTS_COUNT#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11056517146190005)
,p_db_column_name=>'INVOICES_COUNT'
,p_display_order=>87
,p_column_identifier=>'BH'
,p_column_label=>'Invoices'
,p_column_link=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_CONTRACT_NUMBER,P12_SHOW_REPORT:#CONTRACT_NUMBER#,Invoices'
,p_column_linktext=>'#INVOICES_COUNT#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12459558831889047)
,p_db_column_name=>'CONTRACT_TITLE'
,p_display_order=>97
,p_column_identifier=>'BI'
,p_column_label=>'Contract Title'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(20421736992199247)
,p_db_column_name=>'PROJECT_NUMBERS'
,p_display_order=>107
,p_column_identifier=>'BJ'
,p_column_label=>'Project Numbers'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(44832409559668113)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>117
,p_column_identifier=>'BK'
,p_column_label=>'Created By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(44832544495668114)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>127
,p_column_identifier=>'BL'
,p_column_label=>'Updated By'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(11260762528956200)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'112608'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_view_mode=>'REPORT'
,p_report_columns=>'CONTRACT_NUMBER:CONTRACT_TITLE:PROJECT_NUMBERS:CONTRACT_AMOUNT:BILLED_AMOUNT:CONTRACT_VARIATION_AMOUNT:RECOMMENDATION_PAYMENTS_COUNT:INVOICES_COUNT'
,p_sort_column_1=>'PROJECT_NUMBERS'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'CONTRACT_NUMBER'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11259606372956190)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(11142414762956053)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(11079053308956006)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(11196517955956091)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(11258808000956188)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(11235535539956166)
,p_button_name=>'RESET_REPORT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(11195252240956089)
,p_button_image_alt=>'Reset'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:RR::'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.component_end;
end;
/
