prompt --application/pages/page_00020
begin
--   Manifest
--     PAGE: 00020
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
 p_id=>20
,p_user_interface_id=>wwv_flow_api.id(10329664990597858)
,p_name=>'CWIP Projects'
,p_alias=>'CWIP-PROJECTS'
,p_step_title=>'CWIP Projects'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'TCA9051'
,p_last_upd_yyyymmddhh24miss=>'20210908041235'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11622640961977321)
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
 p_id=>wwv_flow_api.id(11623201092977321)
,p_plug_name=>'CWIP Projects'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(10243288598597779)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    p.project_number,',
'    p.project_code,',
'    p.project_name,',
'    p.project_type,',
'    p.project_status,',
'    p.tca_decision_number,',
'    p.project_mode,',
'    p.tca_project_phase,',
'    p.start_date,',
'    p.end_date,',
'    p.tca_project_location,',
'    p.tca_project_category,',
'    p.tca_project_activity,',
'    p.tca_strategic_projects,',
'    p.tca_programs,',
'    p.tca_output,',
'    p.tca_sector,',
'    p.tca_department,',
'    p.dct_sector_id,',
'    p.dct_department_id,',
'    p.dct_section_id,',
'    p.dct_unit_id,',
'    p.dct_project_name,',
'    p.service_provider,',
'    p.dct_mpr_allowed,',
'    p.dct_mpo_allowed,',
'    p.dct_project_rate,',
'    p.ou_name,',
'    p.created_by,',
'    p.created_on,',
'    p.updated_by,',
'    p.updated_on,',
'    p.DCT_PROJECT_CODE,',
'    -- Task Details',
'    (select count(task_number)',
'     from task t',
'     where t.project_number = p.project_number) Task_Count',
'    -- Expenditure Type',
'--    (select count(distinct e.expenditure_type)',
'--     from expenditure e',
'--     where e.project_number = p.project_number) Expenditure_type_count',
'    , (Select COUNT(distinct cp.contract_number)',
'       from cwip_contract_projects cp',
'       where cp.project_number = p.project_number) Contracts_count',
'    , (select COUNT(cpr.payment_recommendation_id)',
'        from cwip_payment_recommendation cpr',
'        where cpr.contract_number in (select cp.contract_number',
'                                      from cwip_contract_projects cp',
'                                      where cp.project_number = p.project_number)) Rec_payments_count',
'    , (select COUNT(ct.person_id)',
'        from cwip_team ct',
'        where ct.project_number = p.project_number',
'        and ct.status = ''A''',
'        and sysdate BETWEEN nvl(ct.start_date , to_date(''01-01-2020'' , ''dd-mm-yyyy''))',
'                and nvl(ct.end_date , to_date(''01-01-2120'' , ''dd-mm-yyyy''))) Project_Team_count',
'    , (select count(id)',
'        from cwip_payment_recommendation_documents recd',
'        where recd.payment_recommendation_id in (select rec.payment_recommendation_id',
'                                                from cwip_payment_recommendation rec',
'                                                where rec.contract_number in (select cp.contract_number',
'                                                                                from cwip_contract_projects cp',
'                                                                                where cp.project_number = p.project_number))) Project_doc_count',
'    ,(select count(inv.voucher_number)',
'    from cwip_contract_invoices inv',
'    where inv.contract_number in (select cp.contract_number',
'                                    from cwip_contract_projects cp',
'                                    where cp.project_number = p.project_number)',
'     and inv.invoice_amount <> 0 ) Invoices_count  ',
'FROM',
'    project p',
'where p.project_type = ''Capital''',
'and CWIP_YN = ''Y''',
'and p.project_number in ( select PROJECT_NUMBER',
'                          from CWIP_TEAM',
'                         where 1=1',
'                         and role_id in (Select r.role_id from project_role r where r.category_id = 2)',
'                         and status = ''A''',
'                         and sysdate BETWEEN nvl(start_date , sysdate -1) and nvl(end_date, sysdate +10)',
'                         and person_type = ''INT''',
'                         and person_id = :PERSON_ID)',
'OR p.project_number in (select x.project_number ',
'from project x',
'where project_type = ''Capital''',
'and exists (select 1 ',
'            from cwip_team',
'            where cwip_team.person_id = :PERSON_ID',
'            and cwip_team.project_number is null) )    ',
'or p.project_number in (select x.project_number',
'                        from project x',
'                        where  project_type = ''Capital''',
'                        and :PERSON_ID = 680461 )'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_page_header=>'CWIP Projects'
);
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(11623315440977321)
,p_name=>'CWIP Projects'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'C'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_detail_link=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::P21_PROJECT_NUMBER:#PROJECT_NUMBER#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'TCA9051'
,p_internal_uid=>11623315440977321
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11623796672977323)
,p_db_column_name=>'PROJECT_NUMBER'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Project Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11624131564977324)
,p_db_column_name=>'PROJECT_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Project Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11624586437977324)
,p_db_column_name=>'PROJECT_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11624950169977325)
,p_db_column_name=>'PROJECT_TYPE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Project Type'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11625314127977325)
,p_db_column_name=>'PROJECT_STATUS'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Project Status'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11625781972977326)
,p_db_column_name=>'TCA_DECISION_NUMBER'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Tca Decision Number'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11626146026977326)
,p_db_column_name=>'PROJECT_MODE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Project Mode'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11626536420977327)
,p_db_column_name=>'TCA_PROJECT_PHASE'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Tca Project Phase'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11626914665977327)
,p_db_column_name=>'START_DATE'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11627365700977328)
,p_db_column_name=>'END_DATE'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11627785450977328)
,p_db_column_name=>'TCA_PROJECT_LOCATION'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Tca Project Location'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11628151863977329)
,p_db_column_name=>'TCA_PROJECT_CATEGORY'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>'Tca Project Category'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11628512333977329)
,p_db_column_name=>'TCA_PROJECT_ACTIVITY'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>'Tca Project Activity'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11628910477977329)
,p_db_column_name=>'TCA_STRATEGIC_PROJECTS'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>'Tca Strategic Projects'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11629310783977330)
,p_db_column_name=>'TCA_PROGRAMS'
,p_display_order=>15
,p_column_identifier=>'O'
,p_column_label=>'Tca Programs'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11629738844977330)
,p_db_column_name=>'TCA_OUTPUT'
,p_display_order=>16
,p_column_identifier=>'P'
,p_column_label=>'Tca Output'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11630103574977331)
,p_db_column_name=>'TCA_SECTOR'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Tca Sector'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11630593830977331)
,p_db_column_name=>'TCA_DEPARTMENT'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Tca Department'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11630955480977332)
,p_db_column_name=>'DCT_SECTOR_ID'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Dct Sector Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11631390541977332)
,p_db_column_name=>'DCT_DEPARTMENT_ID'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Dct Department Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11631767777977333)
,p_db_column_name=>'DCT_SECTION_ID'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Dct Section Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11632154353977333)
,p_db_column_name=>'DCT_UNIT_ID'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Dct Unit Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11632525051977334)
,p_db_column_name=>'DCT_PROJECT_NAME'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>'DCT Project Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11632908455977334)
,p_db_column_name=>'SERVICE_PROVIDER'
,p_display_order=>24
,p_column_identifier=>'X'
,p_column_label=>'Service Provider'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11633377072977335)
,p_db_column_name=>'DCT_MPR_ALLOWED'
,p_display_order=>25
,p_column_identifier=>'Y'
,p_column_label=>'Dct Mpr Allowed'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11633760178977335)
,p_db_column_name=>'DCT_MPO_ALLOWED'
,p_display_order=>26
,p_column_identifier=>'Z'
,p_column_label=>'Dct Mpo Allowed'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11634198063977336)
,p_db_column_name=>'DCT_PROJECT_RATE'
,p_display_order=>27
,p_column_identifier=>'AA'
,p_column_label=>'Dct Project Rate'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11634573265977336)
,p_db_column_name=>'OU_NAME'
,p_display_order=>28
,p_column_identifier=>'AB'
,p_column_label=>'Ou Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11634951439977337)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>29
,p_column_identifier=>'AC'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11635346182977337)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>30
,p_column_identifier=>'AD'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11635766234977338)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11636129624977338)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>32
,p_column_identifier=>'AF'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11636578379977339)
,p_db_column_name=>'TASK_COUNT'
,p_display_order=>33
,p_column_identifier=>'AG'
,p_column_label=>'Tasks'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11636910649977339)
,p_db_column_name=>'CONTRACTS_COUNT'
,p_display_order=>34
,p_column_identifier=>'AH'
,p_column_label=>'Contracts'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11637395844977339)
,p_db_column_name=>'REC_PAYMENTS_COUNT'
,p_display_order=>35
,p_column_identifier=>'AI'
,p_column_label=>'Payments Recommendations'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11637746468977340)
,p_db_column_name=>'PROJECT_TEAM_COUNT'
,p_display_order=>36
,p_column_identifier=>'AJ'
,p_column_label=>'Team Members'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11638153053977340)
,p_db_column_name=>'PROJECT_DOC_COUNT'
,p_display_order=>37
,p_column_identifier=>'AK'
,p_column_label=>'Documents'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(11519951603797835)
,p_db_column_name=>'INVOICES_COUNT'
,p_display_order=>47
,p_column_identifier=>'AL'
,p_column_label=>'Invoices'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G990'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(29486990605468131)
,p_db_column_name=>'DCT_PROJECT_CODE'
,p_display_order=>57
,p_column_identifier=>'AM'
,p_column_label=>'DCT Project Code'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(11638525574978102)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'116386'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PROJECT_NUMBER:PROJECT_CODE:PROJECT_NAME:DCT_PROJECT_NAME:CONTRACTS_COUNT:REC_PAYMENTS_COUNT:INVOICES_COUNT:PROJECT_DOC_COUNT:PROJECT_TEAM_COUNT:'
,p_sort_column_1=>'PROJECT_NUMBER'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'0'
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
wwv_flow_api.component_end;
end;
/
