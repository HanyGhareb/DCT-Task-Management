prompt --application/shared_components/logic/application_computations/is_end_user_person
begin
--   Manifest
--     APPLICATION COMPUTATION: IS_END_USER_PERSON
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>114
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(54319422219806080)
,p_computation_sequence=>20
,p_computation_item=>'IS_END_USER_PERSON'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select decode(COUNT(*), 0,''N'',''Y'')',
'from manager_checks',
'where end_user_person_id = :PERSON_ID;'))
);
wwv_flow_api.component_end;
end;
/
