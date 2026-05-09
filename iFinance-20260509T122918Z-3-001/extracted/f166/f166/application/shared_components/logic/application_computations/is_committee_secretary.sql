prompt --application/shared_components/logic/application_computations/is_committee_secretary
begin
--   Manifest
--     APPLICATION COMPUTATION: IS_COMMITTEE_SECRETARY
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>120
,p_default_id_offset=>143576171933264960
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(104336620847940)
,p_computation_sequence=>20
,p_computation_item=>'IS_COMMITTEE_SECRETARY'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(m.MEMBER_ID) ',
'from tac_committee_members m',
'where m.member_role = 87  -- for committee secretary role',
'and m.member_id = :PERSON_ID',
'and m.status = ''A''',
'and m.committee_id in (Select c.id',
'                        from tac_committees c',
'                        where c.STATUS = ''A''',
'                        and sysdate BETWEEN nvl(START_DATE, sysdate - 100) ',
'                                    and nvl(END_DATE, sysdate + 100))',
'and sysdate BETWEEN m.start_date and nvl(m.end_date, sysdate + 10);'))
,p_computation_error_message=>'Error while executing IS_COMMITTEE_SECRETARY Application Item'
);
wwv_flow_api.component_end;
end;
/
