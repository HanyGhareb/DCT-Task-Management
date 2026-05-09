prompt --application/shared_components/user_interface/lovs/roles_dp
begin
--   Manifest
--     ROLES-DP
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
 p_id=>wwv_flow_api.id(138318517099188652)
,p_lov_name=>'ROLES-DP'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ROLE_NAME , role_id',
'from roles',
'where role_id in (',
'                     121 --View All DP Items',
'                    ,48     -- Buyer',
'                    ,111    -- DP Admin',
'                    ,119    -- BPB Section Head',
'                    ',
'                    )',
'            order by 1;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ROLE_ID'
,p_display_column_name=>'ROLE_NAME'
);
wwv_flow_api.component_end;
end;
/
