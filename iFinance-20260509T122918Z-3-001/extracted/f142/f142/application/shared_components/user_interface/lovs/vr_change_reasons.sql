prompt --application/shared_components/user_interface/lovs/vr_change_reasons
begin
--   Manifest
--     VR CHANGE REASONS
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>142
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(160321452387212093)
,p_lov_name=>'VR CHANGE REASONS'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select   s.LOOKUP_VALUE',
'        ,s.id as ID',
' from dct_lookups_extended s',
' where s.status = ''A''',
' and CODE = ''VRCR''',
' and sysdate BETWEEN nvl(s.start_date, sysdate - 10) ',
'    and nvl(s.end_date, sysdate + 10)',
'order by DISPLAY_ORDER;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ID'
,p_display_column_name=>'LOOKUP_VALUE'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
