prompt --application/shared_components/user_interface/lovs/approval_types_credit_cards_lov
begin
--   Manifest
--     APPROVAL TYPES CREDIT CARDS LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>103
,p_default_id_offset=>219773596381898043
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(24669503372330760)
,p_lov_name=>'APPROVAL TYPES CREDIT CARDS LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT approval_type_name, approval_type_id FROM approval_types where parent_id = 1;',
''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'APPROVAL_TYPE_ID'
,p_display_column_name=>'APPROVAL_TYPE_NAME'
,p_default_sort_column_name=>'APPROVAL_TYPE_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
