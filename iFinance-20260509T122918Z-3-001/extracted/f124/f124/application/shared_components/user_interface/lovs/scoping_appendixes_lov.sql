prompt --application/shared_components/user_interface/lovs/scoping_appendixes_lov
begin
--   Manifest
--     SCOPING APPENDIXES LOV 
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
 p_id=>wwv_flow_api.id(136727294356003195)
,p_lov_name=>'SCOPING APPENDIXES LOV '
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  DP_SCOPE_APPENDIX.APPENDIX_NAME as APPENDIX_NAME ,',
'        DP_SCOPE_APPENDIX.APPENDIX_ID as APPENDIX_ID',
'   ',
' from DP_SCOPE_APPENDIX DP_SCOPE_APPENDIX',
' where status = ''A''',
' and sysdate between nvl(start_date , sysdate -10) and nvl(end_date , sysdate + 10)'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'APPENDIX_ID'
,p_display_column_name=>'APPENDIX_NAME'
,p_default_sort_column_name=>'APPENDIX_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.component_end;
end;
/
