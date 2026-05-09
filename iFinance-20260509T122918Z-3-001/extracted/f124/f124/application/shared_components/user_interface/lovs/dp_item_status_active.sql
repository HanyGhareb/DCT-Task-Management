prompt --application/shared_components/user_interface/lovs/dp_item_status_active
begin
--   Manifest
--     DP ITEM STATUS ACTIVE
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
 p_id=>wwv_flow_api.id(122786397862497537)
,p_lov_name=>'DP ITEM STATUS ACTIVE'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select STATUS_NAME , ID',
'from dp_item_status_definitions',
'where status = ''A''',
'and sysdate between nvl(start_date , sysdate - 10) and nvl(end_date , sysdate + 10)',
'order by order_no'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ID'
,p_display_column_name=>'STATUS_NAME'
);
wwv_flow_api.component_end;
end;
/
