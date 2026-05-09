prompt --application/shared_components/logic/build_options
begin
--   Manifest
--     BUILD OPTIONS: 130
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1200569973923101
,p_default_application_id=>904
,p_default_id_offset=>40436041828902270
,p_default_owner=>'PROD'
);
wwv_flow_api.create_build_option(
 p_id=>wwv_flow_api.id(21485779189631662)
,p_build_option_name=>'Feature: Theme Style Selection'
,p_build_option_status=>'INCLUDE'
,p_feature_identifier=>'APPLICATION_THEME_STYLE_SELECTION'
,p_build_option_comment=>'Allow administrators to select a default color scheme (theme style) for the application. Administrators can also choose to allow end users to choose their own theme style. '
);
wwv_flow_api.create_build_option(
 p_id=>wwv_flow_api.id(21492471864647220)
,p_build_option_name=>'Feature: Activity Reporting'
,p_build_option_status=>'INCLUDE'
,p_feature_identifier=>'APPLICATION_ACTIVITY_REPORTING'
,p_build_option_comment=>'Include numerous reports and charts on end user activity.'
);
wwv_flow_api.create_build_option(
 p_id=>wwv_flow_api.id(21548070294648944)
,p_build_option_name=>'Feature: Email Reporting'
,p_build_option_status=>'INCLUDE'
,p_feature_identifier=>'APPLICATION_EMAIL_REPORTING'
,p_build_option_comment=>'Includes a report displaying the mail to be sent joined with the log of emails already sent.'
);
wwv_flow_api.create_build_option(
 p_id=>wwv_flow_api.id(21560318361650988)
,p_build_option_name=>'Feature: Job Reporting'
,p_build_option_status=>'INCLUDE'
,p_feature_identifier=>'APPLICATION_JOB_REPORTING'
,p_build_option_comment=>'Includes a report on database jobs, with the ability to drill down on a specific job to see additional details.'
);
wwv_flow_api.component_end;
end;
/
