prompt --application/shared_components/data_loading/tables/ar_hotels_p_l
begin
--   Manifest
--     AR_HOTELS_P_L
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>118
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_load_table(
 p_id=>wwv_flow_api.id(169347026327269175)
,p_name=>'Upload Hotel PL'
,p_owner=>'#OWNER#'
,p_table_name=>'AR_HOTELS_P_L'
,p_unique_column_1=>'ACCOUNT_NUM'
,p_is_uk1_case_sensitive=>'N'
,p_is_uk2_case_sensitive=>'N'
,p_is_uk3_case_sensitive=>'N'
,p_skip_validation=>'N'
);
wwv_flow_api.component_end;
end;
/
