prompt --application/shared_components/logic/application_computations/is_senior_pme_role
begin
--   Manifest
--     APPLICATION COMPUTATION: IS_SENIOR_PME_ROLE
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>142
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(160268278230961514)
,p_computation_sequence=>20
,p_computation_item=>'IS_SENIOR_PME_ROLE'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select NVL(count(distinct role_id) , 0) xx',
'from cwip_team',
'where status = ''A''',
'and sysdate BETWEEN nvl(start_date ,to_date(''01-01-2020'' , ''dd-mm-yyyy'')) ',
'        AND nvl(end_date ,to_date(''01-01-4020'' , ''dd-mm-yyyy''))',
'and person_id = :PERSON_ID',
'and PERSON_TYPE = ''INT''',
'and ROLE_ID  = 10	--Senior Project Manager;'))
);
wwv_flow_api.component_end;
end;
/
