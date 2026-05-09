prompt --application/shared_components/navigation/lists/data_load_wizard_progress_dp_items_staging
begin
--   Manifest
--     LIST: Data Load Wizard Progress - DP Items Staging
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(10339441103954751)
,p_name=>'Data Load Wizard Progress - DP Items Staging'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.component_end;
end;
/
