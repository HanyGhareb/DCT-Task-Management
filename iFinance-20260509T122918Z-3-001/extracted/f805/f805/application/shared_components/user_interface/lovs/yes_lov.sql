prompt --application/shared_components/user_interface/lovs/yes_lov
begin
--   Manifest
--     YES_LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>805
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(36335922833816959)
,p_lov_name=>'YES_LOV'
,p_reference_id=>54234558046353501
,p_lov_query=>'.'||wwv_flow_api.id(36335922833816959)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(36337915318816958)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Yes'
,p_lov_return_value=>'Y'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(36338396929816958)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'No'
,p_lov_return_value=>'N'
);
wwv_flow_api.component_end;
end;
/
