prompt --application/shared_components/user_interface/lovs/estimated_budget_bracket_lov
begin
--   Manifest
--     ESTIMATED BUDGET BRACKET LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>510
,p_default_id_offset=>737165656474229799
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(129510087609156996)
,p_lov_name=>'ESTIMATED BUDGET BRACKET LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  BRACKET_NAME , BRACKET_ID',
'from dp_budget_brackets',
'where status = ''A''',
'order by MIN_VALUE'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'BRACKET_ID'
,p_display_column_name=>'BRACKET_NAME'
);
wwv_flow_api.component_end;
end;
/
