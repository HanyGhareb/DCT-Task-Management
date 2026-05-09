prompt --application/shared_components/security/app_access_control/employee
begin
--   Manifest
--     ACL ROLE: Employee
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>101
,p_default_id_offset=>67985499647402269
,p_default_owner=>'PROD'
);
wwv_flow_api.create_acl_role(
 p_id=>wwv_flow_api.id(29012378896711435)
,p_static_id=>'EMPLOYEE'
,p_name=>'Employee'
,p_description=>'Employee User - for Self-Services'
);
wwv_flow_api.component_end;
end;
/
