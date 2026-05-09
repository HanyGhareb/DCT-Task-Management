prompt --application/shared_components/logic/application_items/is_budget_planning_yn
begin
--   Manifest
--     APPLICATION ITEM: IS_BUDGET_PLANNING_YN
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>803
,p_default_id_offset=>213284032389184632
,p_default_owner=>'PROD'
);
wwv_flow_api.create_flow_item(
 p_id=>wwv_flow_api.id(7194006037075)
,p_name=>'IS_BUDGET_PLANNING_YN'
,p_protection_level=>'I'
,p_item_comment=>'to check if the login user has Budget Planning role (Budget Planning, BTF FBP FYI roles)  '
);
wwv_flow_api.component_end;
end;
/
