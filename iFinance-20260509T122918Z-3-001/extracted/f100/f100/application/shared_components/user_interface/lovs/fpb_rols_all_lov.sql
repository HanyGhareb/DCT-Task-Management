prompt --application/shared_components/user_interface/lovs/fpb_rols_all_lov
begin
--   Manifest
--     FPB_ROLS_ALL_LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(4495441690524811)
,p_lov_name=>'FPB_ROLS_ALL_LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select role_id , role_name',
'from roles',
'where main_category = 22'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ROLE_ID'
,p_display_column_name=>'ROLE_NAME'
,p_default_sort_column_name=>'ROLE_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
