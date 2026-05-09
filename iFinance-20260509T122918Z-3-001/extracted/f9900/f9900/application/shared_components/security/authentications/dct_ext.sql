prompt --application/shared_components/security/authentications/dct_ext
begin
--   Manifest
--     AUTHENTICATION: DCT_EXT
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>910
,p_default_id_offset=>82649548957193263
,p_default_owner=>'PROD'
);
wwv_flow_api.create_authentication(
 p_id=>wwv_flow_api.id(2294664134326929)
,p_name=>'DCT_EXT'
,p_scheme_type=>'NATIVE_CUSTOM'
,p_attribute_03=>'Ext_users.authenticate_ext_user'
,p_attribute_05=>'N'
,p_invalid_session_type=>'LOGIN'
,p_cookie_name=>'&DCT_EXT.'
,p_use_secure_cookie_yn=>'Y'
,p_ras_mode=>0
);
wwv_flow_api.component_end;
end;
/
