prompt --application/shared_components/user_interface/lovs/person_name_by_id_lov
begin
--   Manifest
--     PERSON NAME BY ID LOV
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
 p_id=>wwv_flow_api.id(38872040010435083)
,p_lov_name=>'PERSON NAME BY ID LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DCT_BI_EMPLOYEES_V.FULL_NAME_EN as FULL_NAME_EN,',
'    DCT_BI_EMPLOYEES_V.PERSON_ID as PERSON_ID ',
' from DCT_BI_EMPLOYEES_V DCT_BI_EMPLOYEES_V'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PERSON_ID'
,p_display_column_name=>'FULL_NAME_EN'
,p_default_sort_column_name=>'FULL_NAME_EN'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
