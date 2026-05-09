prompt --application/shared_components/logic/application_computations/is_sector_planner_yn
begin
--   Manifest
--     APPLICATION COMPUTATION: IS_SECTOR_PLANNER_YN
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(70970115662667793)
,p_computation_sequence=>20
,p_computation_item=>'IS_SECTOR_PLANNER_YN'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select decode(count(*) , 0 , ''N'' , ''Y'')',
'from budget_allocation_role_users',
'where role_id = 113',
'and person_id = :PERSON_ID',
'and status = ''A''',
'and sysdate BETWEEN nvl(start_date, sysdate - 10) ',
'        AND nvl(end_date, sysdate + 10);'))
);
wwv_flow_api.component_end;
end;
/
