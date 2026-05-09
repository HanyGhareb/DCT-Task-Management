prompt --application/shared_components/security/authorizations/dp_admin_role
begin
--   Manifest
--     SECURITY SCHEME: DP_ADMIN Role
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_security_scheme(
 p_id=>wwv_flow_api.id(144150454788724661)
,p_name=>'DP_ADMIN Role'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :IS_DP_ADMIN = ''Y'' or :IS_IFINANCE_ADMIN = ''Y'' ',
'Then return true;',
'else return false;',
'end if;'))
,p_error_message=>'You can''t access This resource. it''s only for Admin.'
,p_caching=>'BY_USER_BY_SESSION'
);
wwv_flow_api.component_end;
end;
/
