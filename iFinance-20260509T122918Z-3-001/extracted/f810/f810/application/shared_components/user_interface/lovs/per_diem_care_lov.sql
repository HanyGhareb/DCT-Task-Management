prompt --application/shared_components/user_interface/lovs/per_diem_care_lov
begin
--   Manifest
--     PER DIEM / CARE LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>810
,p_default_id_offset=>110610876490006977
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(81269959753991779)
,p_lov_name=>'PER DIEM / CARE LOV'
,p_lov_query=>'.'||wwv_flow_api.id(81269959753991779)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(81270244492991780)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Per Diem'
,p_lov_return_value=>'P'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(81270639870991782)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Car'
,p_lov_return_value=>'C'
);
wwv_flow_api.component_end;
end;
/
