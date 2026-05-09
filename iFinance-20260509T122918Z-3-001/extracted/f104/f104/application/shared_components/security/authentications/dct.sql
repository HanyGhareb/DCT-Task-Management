prompt --application/shared_components/security/authentications/dct
begin
--   Manifest
--     AUTHENTICATION: DCT
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>104
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_authentication(
 p_id=>wwv_flow_api.id(4147166485636403)
,p_name=>'DCT'
,p_scheme_type=>'NATIVE_APEX_ACCOUNTS'
,p_invalid_session_type=>'URL'
,p_invalid_session_url=>'f?p=100:LOGIN'
,p_logout_url=>'f?p=100:LOGIN'
,p_cookie_name=>'&WORKSPACE_COOKIE.'
,p_use_secure_cookie_yn=>'Y'
,p_ras_mode=>0
);
wwv_flow_api.component_end;
end;
/
