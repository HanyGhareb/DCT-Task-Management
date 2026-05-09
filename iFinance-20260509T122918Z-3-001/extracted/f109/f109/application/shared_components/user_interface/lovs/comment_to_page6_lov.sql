prompt --application/shared_components/user_interface/lovs/comment_to_page6_lov
begin
--   Manifest
--     COMMENT TO PAGE6 LOV
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>666
,p_default_id_offset=>90826491306730853
,p_default_owner=>'PROD'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(40236108374121332)
,p_lov_name=>'COMMENT TO PAGE6 LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  NAME ,  PERSON_ID ,person_type',
'From ',
'(select distinct person_id, case person_type',
'    When ''INT''',
'    Then (select full_name_en ',
'            from employees_v ',
'            where employees_v.person_id = cwip_payment_rec_approval_history.person_id',
'             and employees_v.person_id  != :PERSON_ID',
'             ) ',
'    When ''EXT''',
'        Then ',
'            (Select full_name_en ',
'            from dct_ext_users',
'            where user_id =  cwip_payment_rec_approval_history.person_id',
'            and user_id != :PERSON_ID',
'            )',
'    End name ',
'    , person_type',
'from cwip_payment_rec_approval_history ',
'where payment_recommendation_id = :P6_PAYMENT_RECOMMENDATION_ID)',
'where name is not null',
'order by 1'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'PERSON_ID'
,p_display_column_name=>'NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(40237392328181140)
,p_query_column_name=>'PERSON_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(40237766349181145)
,p_query_column_name=>'NAME'
,p_heading=>'Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.create_list_of_values_cols(
 p_id=>wwv_flow_api.id(40238181667181145)
,p_query_column_name=>'PERSON_TYPE'
,p_heading=>'Person Type'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_api.component_end;
end;
/
