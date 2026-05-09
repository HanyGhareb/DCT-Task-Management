prompt --application/shared_components/user_interface/lovs/petty_cash_types
begin
--   Manifest
--     PETTY CASH TYPES
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1448684262833497
,p_default_application_id=>123
,p_default_id_offset=>6039605030667831
,p_default_owner=>'DEV'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(8333351243197780)
,p_lov_name=>'PETTY CASH TYPES'
,p_lov_query=>'.'||wwv_flow_api.id(8333351243197780)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(8333661394197780)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Permanent'
,p_lov_return_value=>'P'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(8334013168197780)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Temporary'
,p_lov_return_value=>'T'
);
wwv_flow_api.component_end;
end;
/
