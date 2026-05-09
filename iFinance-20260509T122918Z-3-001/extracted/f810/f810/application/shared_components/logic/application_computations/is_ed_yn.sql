prompt --application/shared_components/logic/application_computations/is_ed_yn
begin
--   Manifest
--     APPLICATION COMPUTATION: IS_ED_YN
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(95229659256376441)
,p_computation_sequence=>20
,p_computation_item=>'IS_ED_YN'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select decode(nvl(COUNT(*), 0),0,''N'',''Y'')',
'  from COST_CENTERS_FBP',
' where ROLE_ID = 82',
' and PERSON_ID = :PERSON_ID',
' and STATUS = ''A''',
' and sysdate between nvl(start_date , sysdate - 10) ',
'                and nvl(end_date , sysdate + 10)'))
,p_computation_error_message=>'IS_ED_YN Not Set'
);
wwv_flow_api.component_end;
end;
/
