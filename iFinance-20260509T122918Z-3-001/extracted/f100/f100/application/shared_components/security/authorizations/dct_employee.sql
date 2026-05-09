prompt --application/shared_components/security/authorizations/dct_employee
begin
--   Manifest
--     SECURITY SCHEME: DCT Employee
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_security_scheme(
 p_id=>wwv_flow_api.id(2135043939931080)
,p_name=>'DCT Employee'
,p_scheme_type=>'NATIVE_IS_IN_GROUP'
,p_attribute_01=>'DCT Employee'
,p_attribute_02=>'W'
,p_error_message=>'Only Available to DCT Employees'
,p_caching=>'BY_USER_BY_SESSION'
);
wwv_flow_api.component_end;
end;
/
