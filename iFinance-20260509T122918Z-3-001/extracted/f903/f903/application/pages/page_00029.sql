prompt --application/pages/page_00029
begin
--   Manifest
--     PAGE: 00029
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_page(
 p_id=>29
,p_user_interface_id=>wwv_flow_api.id(65623444952255812)
,p_name=>'BTF By DOA Status'
,p_step_title=>'BTF By DOA Status'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Scroll Results Only in Side Column */',
'.t-Body-side {',
'    display: flex;',
'    flex-direction: column;',
'    overflow: hidden;',
'}',
'.search-results {',
'    flex: 1;',
'    overflow: auto;',
'}',
'/* Format Search Region */',
'.search-region {',
'    border-bottom: 1px solid rgba(0,0,0,.1);',
'    flex-shrink: 0;',
'}',
'',
'.t-Region-header{',
'background-color:#0e6655;',
'    color:#FFFFFF;',
'}',
'.t-Region-title{',
'    color:#FFFFFF;',
'    font-weighfont-weight: bold;',
'}',
'',
'/* Set Header Panel */',
'.t-Header-branding {',
'    background-color: #0e6655;',
'}',
'',
'',
'/* Set Breadcrumb   */',
'.t-Body-title {',
'',
'    background-color: #EEE;',
'    color:#404040;',
'}',
'',
'/* Add Button - White */',
'.t-Region-header, .t-Region-header .t-Button--link, .t-Region-header .t-Button--noUI {',
'    color:  #FFF;',
'}',
'',
'/* New Plan Button */',
'.a-Button--hot, .t-Button--hot:not(.t-Button--simple), body .ui-button.ui-button--hot, body .ui-state-default.ui-priority-primary {',
'',
'    background-color: #0e6655;',
'    color:#fff;',
'}',
'',
'',
'/*  Table Row Selected */',
'.a-GV-table tr.is-selected .a-GV-cell {',
'    background-color: #CEF6CE;',
'}',
'',
'/* Audit Region */',
'#history    .t-Region-header {',
'     background-color: #f3f0ef;',
'    color:#000;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20200519134807'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(143419731037651096)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65554277731255756)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(65494572154255667)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(65602363670255785)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(143420294958651097)
,p_plug_name=>'All BTF'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(65543737550255752)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'        -- Header',
'        btf_header.form_no',
'        ,btf_header.priority',
'        ,btf_header.reason',
'        ,btf_header.status      DOA_STATUS',
'        , btf_header.finance_status',
'        ,btf_header.year',
'        ,btf_header.created_by      Header_Created_BY',
'        ,btf_header.creation_date   Header_Creation_date',
'        ,btf_header.updated_by      Header_Updated_By',
'        ,btf_header.updated_date    Headdr_Updated_Date',
'        ,decode(btf_header.completed,''Y'',''Yes'',''No'')     completed',
'        ,btf_header.revision_no',
'        ,(select sum(nvl(l.transferred_amount ,0)) ',
'        from btf_lines l',
'        where l.form_no = btf_header.form_no',
'        and l.from_to = ''FROM'') Amount',
'--    ,(select sum(nvl(l.transferred_amount ,0)) ',
'--        from btf_lines l',
'--        where l.form_no = btf_header.form_no',
'--        and l.from_to = ''TO'') total_to',
'    ,',
'    (select h.user_name',
'        from btf_approval_history h',
'        where h.form_no = btf_header.form_no',
'        and h.status = ''Pending'')',
'        || '' - '' ||',
'    (select e.full_name_en',
'        from dct_employees_list2 e',
'        where e.employee_num = (select substr(h.user_name,4)',
'                                from btf_approval_history h',
'                                where h.form_no = btf_header.form_no',
'                                and h.status = ''Pending''))Pending_with    ',
'from btf_header ',
'where  (btf_header.status = nvl(:P29_STATUS , btf_header.status) ',
'        and (btf_header.finance_status = nvl(:P29_FINANCE_STATUS , btf_header.finance_status)',
'        ))',
'and (btf_header.form_no in (select l.form_no ',
'                            from btf_lines l ',
'                            where l.form_no = btf_header.form_no ',
'                            and l.tca_sector in (SELECT  btf_data_access.entity_name d',
'                                                    FROM   btf_data_access',
'                                                    WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                                    and btf_data_access.user_id = :APP_USER))',
'or btf_header.sector in (SELECT  btf_data_access.entity_name d',
'                                                    FROM   btf_data_access',
'                                                    WHERE btf_data_access.entity_type = ''TCA_SECTOR''',
'                                                    and btf_data_access.user_id = :APP_USER))'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P29_STATUS,P29_FINANCE_STATUS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(143420402312651097)
,p_name=>'All BTF'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'TCA9051'
,p_internal_uid=>143420402312651097
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76733543443214355)
,p_db_column_name=>'FORM_NO'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Form No'
,p_column_link=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:RP,9:P9_FORM_NO:#FORM_NO#'
,p_column_linktext=>'#FORM_NO#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76733931262214356)
,p_db_column_name=>'REVISION_NO'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Revision No'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76735177432214356)
,p_db_column_name=>'REASON'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Reason'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76736338701214357)
,p_db_column_name=>'YEAR'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Year'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76737571443214358)
,p_db_column_name=>'PENDING_WITH'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Pending With'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76737912983214358)
,p_db_column_name=>'PRIORITY'
,p_display_order=>24
,p_column_identifier=>'O'
,p_column_label=>'Priority'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76738318344214358)
,p_db_column_name=>'DOA_STATUS'
,p_display_order=>34
,p_column_identifier=>'P'
,p_column_label=>'DOA Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76738775610214358)
,p_db_column_name=>'FINANCE_STATUS'
,p_display_order=>44
,p_column_identifier=>'Q'
,p_column_label=>'Finance Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76739160409214359)
,p_db_column_name=>'HEADER_CREATED_BY'
,p_display_order=>54
,p_column_identifier=>'R'
,p_column_label=>'Header Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76739502758214359)
,p_db_column_name=>'HEADER_CREATION_DATE'
,p_display_order=>64
,p_column_identifier=>'S'
,p_column_label=>'Header Creation Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76739953115214359)
,p_db_column_name=>'HEADER_UPDATED_BY'
,p_display_order=>74
,p_column_identifier=>'T'
,p_column_label=>'Header Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76740338304214359)
,p_db_column_name=>'HEADDR_UPDATED_DATE'
,p_display_order=>84
,p_column_identifier=>'U'
,p_column_label=>'Headdr Updated Date'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76740736447214360)
,p_db_column_name=>'COMPLETED'
,p_display_order=>94
,p_column_identifier=>'V'
,p_column_label=>'Completed'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(76701527160160210)
,p_db_column_name=>'AMOUNT'
,p_display_order=>114
,p_column_identifier=>'AR'
,p_column_label=>'Amount'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(143426401259652124)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'767495'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'FORM_NO:REASON:PRIORITY:DOA_STATUS:FINANCE_STATUS:AMOUNT:PENDING_WITH:COMPLETED'
,p_sort_column_1=>'FORM_NO'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76732427013214349)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(143419731037651096)
,p_button_name=>'Home'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Home'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP,1::'
,p_icon_css_classes=>'fa-home'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(76732827576214349)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(143419731037651096)
,p_button_name=>'New_BTF'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(65601045912255785)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Budget Transfer'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.:Direct:&DEBUG.:RP::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7017516800736246)
,p_name=>'P29_FINANCE_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(143420294958651097)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(76749953288214367)
,p_name=>'P29_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(143420294958651097)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
