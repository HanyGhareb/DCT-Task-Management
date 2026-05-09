prompt --application/shared_components/security/authorizations/approver_auz_role
begin
--   Manifest
--     SECURITY SCHEME: Approver AUZ Role
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_security_scheme(
 p_id=>wwv_flow_api.id(70528602176145068)
,p_name=>'Approver AUZ Role'
,p_scheme_type=>'NATIVE_IS_IN_GROUP'
,p_attribute_01=>'BTF Approvers Role'
,p_attribute_02=>'A'
,p_error_message=>'Only For BTF Approvers'
,p_reference_id=>70397243083858530
,p_caching=>'BY_USER_BY_SESSION'
);
wwv_flow_api.component_end;
end;
/
