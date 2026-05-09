prompt --application/shared_components/user_interface/lovs/more_info_persons
begin
--   Manifest
--     MORE INFO - PERSONS
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>0
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(21012528544385727)
,p_lov_name=>'MORE INFO - PERSONS'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct h.person_id , case h.PERSON_TYPE when ''INT''  THEN  (select e.full_name_en ',
'                                                 from employees_v e',
'                                                 where e.person_id = h.PERSON_ID)',
'                              else (select u.first_name||'' ''|| u.last_name',
'                                    from DCT_EXT_USERS u',
'                                    where u.user_id = h.PERSON_ID)',
'        End person_name ,',
'        role_id,',
'        h.on_behalf,',
'        (select r.role_name',
'            from project_role r',
'            where r.role_id = h.role_id ) role_name',
'            ,PERSON_TYPE',
'from cwip_payment_rec_approval_history h',
'where payment_recommendation_id = :P26_PAYMENT_RECOMMENDATION_ID_H',
'and status in (''Approved'' , ''Bateen'' , ''Delegated'' , ''Submit'', ''Submitted'')',
'and h.person_id  <> :PERSON_ID;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PERSON_ID'
,p_display_column_name=>'PERSON_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'PERSON_NAME'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(21013064937388342)
,p_query_column_name=>'PERSON_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(21013410018388342)
,p_query_column_name=>'PERSON_NAME'
,p_heading=>'Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(21013866108388342)
,p_query_column_name=>'ROLE_NAME'
,p_heading=>'Role'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(21021709043438480)
,p_query_column_name=>'PERSON_TYPE'
,p_heading=>'Person Type'
,p_display_sequence=>40
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(21031395769661051)
,p_query_column_name=>'ROLE_ID'
,p_heading=>'Role Id'
,p_display_sequence=>50
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(21031793477661052)
,p_query_column_name=>'ON_BEHALF'
,p_heading=>'On Behalf'
,p_display_sequence=>60
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
);
wwv_flow_api.component_end;
end;
/
