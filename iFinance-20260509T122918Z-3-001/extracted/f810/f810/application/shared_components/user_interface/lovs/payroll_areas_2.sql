prompt --application/shared_components/user_interface/lovs/payroll_areas_2
begin
--   Manifest
--     PAYROLL AREAS 2
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
 p_id=>wwv_flow_api.id(98832729552016303)
,p_lov_name=>'PAYROLL AREAS 2'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  PAYROLL_AREA , PAYROLL_AREA_ID',
'from PAYROLL_AREAS;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PAYROLL_AREA_ID'
,p_display_column_name=>'PAYROLL_AREA'
,p_default_sort_column_name=>'PAYROLL_AREA'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
