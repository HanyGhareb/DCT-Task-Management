prompt --application/shared_components/security/authorizations/hrss_approvers
begin
--   Manifest
--     SECURITY SCHEME: HRSS Approvers
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_security_scheme(
 p_id=>wwv_flow_api.id(29304425585911441)
,p_name=>'HRSS Approvers'
,p_scheme_type=>'NATIVE_IS_IN_GROUP'
,p_attribute_01=>'HRSS Approver'
,p_attribute_02=>'A'
,p_error_message=>'Only HRSS Approvers Can Access'
,p_caching=>'BY_USER_BY_SESSION'
);
wwv_flow_api.component_end;
end;
/
