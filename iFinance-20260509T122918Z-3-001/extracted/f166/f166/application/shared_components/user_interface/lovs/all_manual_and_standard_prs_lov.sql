prompt --application/shared_components/user_interface/lovs/all_manual_and_standard_prs_lov
begin
--   Manifest
--     ALL MANUAL AND STANDARD PRS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>143576171933264960
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(25581282062467656)
,p_lov_name=>'ALL MANUAL AND STANDARD PRS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PR_NUMBER, REQUESTOR, to_char(AMOUNT,''99,999,999,999.99'') AMOUNT, PR_TYPE , NVL(PR_FUND_AVAILABLE,''N'') PR_FUND_AVAILABLE',
'from ',
'(select pr_no   as PR_NUMBER, preparer  requestor , amount , ''Standard'' PR_TYPE , '''' PR_FUND_AVAILABLE',
'from PR_ALL',
'UNION all',
'select m.request_number  PR_NUMBER, e.full_name_en requestor, m.requested_amount',
'    , ''Manual'' PR_TYPE , m.fund_available_yn    PR_FUND_AVAILABLE',
'from mpr m , employees_v e',
'where m.requestor_person_id = e.person_id',
'and m.status = ''Approved''',
'--and m.requested_amount >= 250000',
')',
'order by 1'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PR_NUMBER'
,p_display_column_name=>'PR_NUMBER'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(25581789131454930)
,p_query_column_name=>'PR_NUMBER'
,p_heading=>'PR Number'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(25609998188867051)
,p_query_column_name=>'PR_FUND_AVAILABLE'
,p_heading=>'Pr Fund Available'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(25582108793454930)
,p_query_column_name=>'REQUESTOR'
,p_heading=>'Requestor'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(25582526587454929)
,p_query_column_name=>'AMOUNT'
,p_heading=>'Amount'
,p_display_sequence=>30
,p_data_type=>'NUMBER'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(25582989253454929)
,p_query_column_name=>'PR_TYPE'
,p_heading=>'PR Type'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
