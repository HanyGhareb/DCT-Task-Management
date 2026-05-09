prompt --application/shared_components/security/authentications/dct
begin
--   Manifest
--     AUTHENTICATION: DCT
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_authentication(
 p_id=>wwv_flow_api.id(12398605991726508)
,p_name=>'DCT'
,p_scheme_type=>'NATIVE_CUSTOM'
,p_attribute_03=>'AUTHENTICATE_USER'
,p_attribute_05=>'N'
,p_invalid_session_type=>'LOGIN'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
);
wwv_flow_api.component_end;
end;
/
