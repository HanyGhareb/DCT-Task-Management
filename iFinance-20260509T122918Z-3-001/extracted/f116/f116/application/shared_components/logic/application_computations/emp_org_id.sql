prompt --application/shared_components/logic/application_computations/emp_org_id
begin
--   Manifest
--     APPLICATION COMPUTATION: EMP_ORG_ID
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>116
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_computation(
 p_id=>wwv_flow_api.id(100026855748501064)
,p_computation_sequence=>20
,p_computation_item=>'EMP_ORG_ID'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'QUERY'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select org_id',
'from employees_v',
'where person_id = :PERSON_ID'))
);
wwv_flow_api.component_end;
end;
/
