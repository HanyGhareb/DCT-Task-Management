prompt --application/shared_components/security/app_access_control/budget_planning_acl_role
begin
--   Manifest
--     ACL ROLE: Budget Planning ACL Role
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
 p_id=>wwv_flow_api.id(70304373751166488)
,p_static_id=>'BUDGET_PLANNING_ROLE'
,p_name=>'Budget Planning ACL Role'
,p_description=>'Budget Planning Role'
);
wwv_flow_api.component_end;
end;
/
