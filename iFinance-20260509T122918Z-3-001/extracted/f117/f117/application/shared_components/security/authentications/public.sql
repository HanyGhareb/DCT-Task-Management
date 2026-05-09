prompt --application/shared_components/security/authentications/public
begin
--   Manifest
--     AUTHENTICATION: Public
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>117
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_authentication(
 p_id=>wwv_flow_api.id(22776290654584620)
,p_name=>'Public'
,p_scheme_type=>'NATIVE_DAD'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
);
wwv_flow_api.component_end;
end;
/
