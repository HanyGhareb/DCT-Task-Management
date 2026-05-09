prompt --application/shared_components/reports/report_queries/mission_query
begin
--   Manifest
--     WEB SERVICE: MISSION_QUERY
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>227103249168277234
,p_default_owner=>'PROD'
);
wwv_flow_api.create_shared_query(
 p_id=>wwv_flow_api.id(110391379078711426)
,p_name=>'MISSION_QUERY'
,p_query_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'        request_no                          request_no,',
'        to_char(request_date,''DD-MON-YYYY'') request_date,',
'        justification                       justification,',
'        case h.OVERSEAS_YN',
'                when ''Y''',
'                    Then (select l.country',
'                            from mission_legs l',
'                            where l.request_id = h.request_id',
'                            and ROWNUM = 1) ',
'                when ''N''',
'                    Then ',
'                    (SELECT  value',
'                     FROM   dct_lookup_values',
'                     WHERE  lookup_id = 35',
'                     and value_id = h.emirate)',
'                End                                     ',
'                                                country,',
'        ',
'        (select lv.value ',
'         from dct_lookup_values lv',
'        where VALUE_ID = priority)              priority,',
'        case request_type   ',
'                when ''M''    Then ''Mission''',
'                when ''T''    Then ''Training''',
'        End                                     request_type,',
'',
'        trim(to_char(nvl(mission_util.get_mission_amount(request_id),0) ,',
'                    ''99,999,999,999.99''))            Amount,',
'        e.title     ||',
'        '' ''         ||',
'        e.first_name ||',
'        '' ''          ||',
'        e.last_name             REQUESTOR          ',
'    ',
'FROM  MISSION_HEADER h, employees_v e',
'where h.REQUEST_FOR = e.person_id',
'and request_id =  :P_REQUEST_ID   ;'))
,p_xml_structure=>'APEX'
,p_report_layout_id=>wwv_flow_api.id(5258414252594736)
,p_format=>'PDF'
,p_output_file_name=>'MISSION_QUERY'
,p_content_disposition=>'ATTACHMENT'
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(5390367406752369)
,p_shared_query_id=>wwv_flow_api.id(110391379078711426)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'        request_no                          request_no,',
'        to_char(request_date,''DD-MON-YYYY'') request_date,',
'        justification                       justification,',
'        case h.OVERSEAS_YN',
'                when ''Y''',
'                    Then (select  SHORT_NAME',
'                          from countries',
'                          where CODE = (select l.country',
'                                        from mission_legs l',
'                                        where l.request_id = h.request_id',
'                                        and ROWNUM = 1)) ',
'                when ''N''',
'                    Then ',
'                    (SELECT  value',
'                     FROM   dct_lookup_values',
'                     WHERE  lookup_id = 35',
'                     and value_id = h.emirate)',
'                End                                     ',
'                                                country,',
'        ',
'        (select lv.value ',
'         from dct_lookup_values lv',
'        where VALUE_ID = priority)              priority,',
'        case request_type   ',
'                when ''M''    Then ''Mission''',
'                when ''T''    Then ''Training''',
'        End                                     request_type,',
'',
'        trim(to_char(nvl(mission_util.get_mission_amount(request_id),0) ,',
'                    ''99,999,999,999.99''))                       Amount,',
'        e.title     ||',
'        '' ''         ||',
'        e.first_name ||',
'        '' ''          ||',
'        e.last_name                                             REQUESTOR    ',
'        , to_char(START_DATE,''dd-Mon-yyyy'')                     start_date',
'        , to_char(END_DATE,''dd-Mon-yyyy'')                       End_date',
'        , MISSION_UTIL.get_grade(grade_code)                    Grade',
'        , trim(to_char(GRADE_RATE,''99,999,999,999.99''))                GRADE_RATE',
'        , (end_date - start_date) + 1                             Mission_days',
'        , case when overseas_yn = ''Y'' and travel_above_10hr_yn = ''Y''',
'                Then 4',
'             when overseas_yn = ''Y'' and travel_above_10hr_yn = ''N''  ',
'                Then 2',
'             else',
'                0',
'          End                                                 additional_days',
'        ',
'        , MISSION_UTIL.get_Eligible_pct(overseas_yn, full_day_yn, hospitality_yn, request_id)              eligible_pct',
'        , decode(PAY_ALONE,''Y'',''Yes'',''N'',''No'') PAY_ALONE',
'        , PAYMENT_METHOD',
'        , INVOICE_TYPE',
'        , SUPPLIER_NAME',
'        , SITE_NAME',
'        , CURRENCY',
'        , PAY_GROUP',
'        , PAYMENT_TERM',
'        , HEADER_CONTEXT',
'        , user_details.Bank_Name(REQUEST_FOR)   Bank_name',
'        , user_details.IBAN(REQUEST_FOR)        IBAN',
'        , decode(OVERSEAS_YN, ''Y'' ,''Yes'',''N'',''No'')  OVERSEAS_YN',
'        , decode(HOSPITALITY_YN, ''Y'' ,''Yes'',''N'',''No'')   HOSPITALITY_YN',
'        , h.request_status',
'--into  L_MissionType           ',
'FROM  MISSION_HEADER h, employees_v e',
'where h.REQUEST_FOR = e.person_id',
'and request_id =  :request_id;     '))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(5390553068752368)
,p_shared_query_id=>wwv_flow_api.id(110391379078711426)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select      SEQ',
'          , (select  SHORT_NAME',
'                          from countries',
'                          where CODE = COUNTRY) COUNTRY',
'          , CITY',
'          , to_char(START_DATE, ''dd-Mon-yyyy'') start_date',
'          , to_char(END_DATE, ''dd-Mon-yyyy'') END_DATE',
'          , NOTES ',
'from mission_legs',
'where REQUEST_ID =  :request_id',
'order by 1'))
);
wwv_flow_api.create_shared_query_stmnt(
 p_id=>wwv_flow_api.id(5390756692752368)
,p_shared_query_id=>wwv_flow_api.id(110391379078711426)
,p_sql_statement=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'--    id,',
'--    request_id,',
'    step_no,',
'--    person_id,',
'    (SELECT initcap(e.full_name_en)',
'     FROM employees_v e',
'     WHERE e.person_id = h.person_id)    full_name,',
'    (SELECT r.role_name',
'     FROM roles r',
'     WHERE r.role_id = h.role_id)       role_name,',
'    action_required,',
'    to_char(recevied_date, ''DD-Mon-YYYY'')       recevied_date,',
'    status,',
'    to_char(action_date, ''DD-Mon-YYYY HH:MI'')         action_date,',
'    comments,',
'    CASE',
'        WHEN dbms_lob.getlength(( SELECT  s.signature_blob',
'                                    FROM dct_employees_signatures s',
'                                    WHERE s.person_id = h.person_id',
'                                    AND s.status = ''Y''',
'                                )) > 0 ',
'            THEN',
'                (SELECT  s.signature_clob',
'                  FROM dct_employees_signatures s',
'                  WHERE  s.person_id = h.person_id',
'                  AND s.status = ''Y'')',
'    END                                        AS signature',
'FROM',
'    mission_approval_history h',
'WHERE',
'        h.request_id = :request_id',
'    AND status NOT IN ( ''Bateen'' )',
'order by step_no'))
);
wwv_flow_api.component_end;
end;
/
