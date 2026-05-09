prompt --application/shared_components/data_loading/tables/scm_pending_grn
begin
--   Manifest
--     SCM_PENDING_GRN
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>500
,p_default_id_offset=>354480484490134169
,p_default_owner=>'PROD'
);
wwv_flow_api.create_load_table(
 p_id=>wwv_flow_api.id(2234494407471764)
,p_name=>'Oending GRN Upload'
,p_owner=>'#OWNER#'
,p_table_name=>'SCM_PENDING_GRN'
,p_unique_column_1=>'PO_NUMBER'
,p_is_uk1_case_sensitive=>'N'
,p_unique_column_2=>'PO_AMOUNT'
,p_is_uk2_case_sensitive=>'N'
,p_is_uk3_case_sensitive=>'N'
,p_skip_validation=>'N'
);
wwv_flow_api.component_end;
end;
/
