prompt --application/shared_components/security/app_access_control/finance_admin
begin
--   Manifest
--     ACL ROLE: Finance Admin
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>114
,p_default_id_offset=>9604171250607172
,p_default_owner=>'DEV'
);
wwv_flow_api.create_acl_role(
 p_id=>wwv_flow_api.id(70304490251165389)
,p_static_id=>'FINANCE_ADMIN'
,p_name=>'Finance Admin'
);
wwv_flow_api.component_end;
end;
/
