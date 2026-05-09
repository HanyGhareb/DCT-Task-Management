prompt --application/shared_components/security/authentications/duty_hub_dct
begin
--   Manifest
--     AUTHENTICATION: Duty Hub - DCT
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_authentication(
 p_id=>wwv_flow_api.id(79756670019868437)
,p_name=>'Duty Hub - DCT'
,p_scheme_type=>'NATIVE_CUSTOM'
,p_attribute_03=>'AUTHENTICATE_USER'
,p_attribute_05=>'N'
,p_invalid_session_type=>'LOGIN'
,p_cookie_name=>'&WORKSPACE_COOKIE.'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
);
wwv_flow_api.component_end;
end;
/
